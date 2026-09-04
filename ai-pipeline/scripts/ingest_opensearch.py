"""
S3의 안전 법규 문서를 다시 청킹 + Titan 임베딩해서 자체호스팅 OpenSearch(EC2)에 색인한다.

기존에는 Bedrock Knowledge Base가 이 과정(청킹/임베딩/색인)을 전부 자동으로 해줬으나,
KB가 물려있던 OpenSearch Serverless(AOSS) 컬렉션이 삭제되어(비용 문제로 추정) KB 자체가
무용지물이 됐다. 이 스크립트는 그 자동화를 대체하는 일회성 색인 작업이다.
문서가 바뀌지 않는 한 여러 번 실행할 필요는 없다(멱등: 기존 인덱스를 지우고 다시 만듦).

사용법: ai-pipeline 디렉터리에서 `python scripts/ingest_opensearch.py`
"""
import io
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from pypdf import PdfReader
import pypdfium2 as pdfium
from opensearchpy import OpenSearch, helpers

from config import S3_BUCKET_NAME, BEDROCK_MODEL_ID, get_s3_client, get_bedrock_runtime_client

OPENSEARCH_HOST = os.environ.get("OPENSEARCH_HOST", "15.165.210.219")
OPENSEARCH_PORT = int(os.environ.get("OPENSEARCH_PORT", "9200"))
OPENSEARCH_USER = os.environ.get("OPENSEARCH_USER", "admin")
OPENSEARCH_PASSWORD = os.environ["OPENSEARCH_PASSWORD"]
INDEX_NAME = "safety-index"
EMBED_MODEL_ID = "amazon.titan-embed-text-v2:0"
EMBED_DIMENSION = 1024

# Bedrock KB 기본 청킹 설정(FIXED_SIZE, maxTokens 300, overlap 20%)과 동일하게 맞춘다.
CHUNK_CHARS = 1200  # 토큰 300개 ~= 한글 기준 대략 1200자
CHUNK_OVERLAP = 240  # 20%


def get_client() -> OpenSearch:
    return OpenSearch(
        hosts=[{"host": OPENSEARCH_HOST, "port": OPENSEARCH_PORT}],
        http_auth=(OPENSEARCH_USER, OPENSEARCH_PASSWORD),
        use_ssl=True,
        verify_certs=False,
        ssl_show_warn=False,
    )


def extract_text_native(pdf_bytes: bytes) -> str:
    reader = PdfReader(io.BytesIO(pdf_bytes))
    return "\n".join(page.extract_text() or "" for page in reader.pages).strip()


def extract_text_via_vision(pdf_bytes: bytes, filename: str) -> str:
    """텍스트 레이어가 없는 스캔 PDF는 페이지를 이미지로 렌더링해 Claude 멀티모달로 읽는다."""
    bedrock = get_bedrock_runtime_client()
    doc = pdfium.PdfDocument(pdf_bytes)
    pages_text = []
    for i in range(len(doc)):
        page = doc[i]
        bitmap = page.render(scale=2.0)
        pil_image = bitmap.to_pil()
        buf = io.BytesIO()
        pil_image.save(buf, format="PNG")
        response = bedrock.converse(
            modelId=BEDROCK_MODEL_ID,
            messages=[{
                "role": "user",
                "content": [
                    {"image": {"format": "png", "source": {"bytes": buf.getvalue()}}},
                    {"text": "이 이미지는 안전 점검표 문서의 한 페이지입니다. 이미지에 보이는 텍스트 내용을 "
                              "가능한 그대로 한국어 텍스트로 옮겨 적으세요. 설명 없이 텍스트만 출력하세요."},
                ],
            }],
            inferenceConfig={"maxTokens": 2048, "temperature": 0},
        )
        text = "".join(
            block.get("text", "")
            for block in response["output"]["message"]["content"]
            if "text" in block
        )
        pages_text.append(text.strip())
        print(f"  [{filename}] page {i + 1}/{len(doc)} OCR 완료 ({len(text)}자)")
    return "\n\n".join(pages_text)


def chunk_text(text: str) -> list[str]:
    chunks = []
    start = 0
    step = CHUNK_CHARS - CHUNK_OVERLAP
    while start < len(text):
        chunk = text[start:start + CHUNK_CHARS].strip()
        if chunk:
            chunks.append(chunk)
        start += step
    return chunks


def embed(text: str, bedrock) -> list[float]:
    import json
    response = bedrock.invoke_model(
        modelId=EMBED_MODEL_ID,
        body=json.dumps({"inputText": text, "dimensions": EMBED_DIMENSION, "normalize": True}),
    )
    body = json.loads(response["body"].read())
    return body["embedding"]


def main():
    s3 = get_s3_client()
    bedrock = get_bedrock_runtime_client()
    client = get_client()

    if client.indices.exists(index=INDEX_NAME):
        print(f"기존 인덱스 {INDEX_NAME} 문서 전체 삭제 후 재색인")
        client.delete_by_query(index=INDEX_NAME, body={"query": {"match_all": {}}})

    objects = s3.list_objects_v2(Bucket=S3_BUCKET_NAME, Prefix="kb-source/").get("Contents", [])
    print(f"{len(objects)}개 문서 발견")

    actions = []
    for obj in objects:
        key = obj["Key"]
        print(f"처리 중: {key}")
        pdf_bytes = s3.get_object(Bucket=S3_BUCKET_NAME, Key=key)["Body"].read()

        text = extract_text_native(pdf_bytes)
        if len(text) < 200:
            print(f"  텍스트 레이어 부족({len(text)}자) → 이미지 OCR로 전환")
            text = extract_text_via_vision(pdf_bytes, key)

        chunks = chunk_text(text)
        print(f"  {len(chunks)}개 청크 생성")

        for idx, chunk in enumerate(chunks):
            vector = embed(chunk, bedrock)
            actions.append({
                "_index": INDEX_NAME,
                "_source": {
                    "text": chunk,
                    "vector": vector,
                    "metadata": {"source": key, "chunk_index": idx},
                },
            })

    print(f"총 {len(actions)}개 청크를 OpenSearch에 bulk 색인 중...")
    helpers.bulk(client, actions)
    client.indices.refresh(index=INDEX_NAME)
    count = client.count(index=INDEX_NAME)["count"]
    print(f"완료. 인덱스 문서 수: {count}")


if __name__ == "__main__":
    main()
