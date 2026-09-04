import json
from typing import TypedDict

from langgraph.graph import END, StateGraph

from bedrock_utils import extract_converse_text
from config import (
    BEDROCK_MODEL_ID,
    EMBED_DIMENSION,
    EMBED_MODEL_ID,
    OPENSEARCH_INDEX,
    RERANK_MODEL_ARN,
    S3_BUCKET_NAME,
    get_bedrock_runtime_client,
    get_opensearch_client,
    get_rerank_client,
    get_s3_client,
)
from schemas import RiskItem

RERANK_TOP_N = 5

IMAGE_ANALYSIS_PROMPT = """당신은 건설현장 안전 점검 전문가입니다.
아래 작업 정보와 현장 사진을 보고 사진에서 관찰되는 안전 위험요소를 한국어로 간결하게 요약하세요.
설명 없이 위험요소 요약 문장만 출력하세요.

작업 정보: {work_info}"""

RISK_ASSEMBLY_PROMPT = """당신은 건설현장 안전 점검 보고서를 작성하는 전문가입니다.
아래 "현장 사진 분석 요약"과 "관련 법령/사고사례"를 참고하여 위험요소 목록을 JSON 배열로 작성하세요.

현장 사진 분석 요약:
{image_summary}

관련 법령/사고사례:
{context}

각 항목은 다음 필드를 가진 JSON 객체여야 합니다: risk_name(위험요소명), legal_basis(근거 법령 또는 사고사례), action_required(필요 조치사항).
반드시 JSON 배열만 출력하고 다른 설명은 출력하지 마세요."""


class AnalysisState(TypedDict):
    site_id: str | None
    image_s3_key: str
    work_info: str
    image_bytes: bytes
    image_summary: str
    candidate_docs: list[str]
    reranked_docs: list[str]
    risk_items: list[RiskItem]


def load_image(state: AnalysisState) -> AnalysisState:
    response = get_s3_client().get_object(Bucket=S3_BUCKET_NAME, Key=state["image_s3_key"])
    state["image_bytes"] = response["Body"].read()
    return state


def analyze_with_bedrock(state: AnalysisState) -> AnalysisState:
    response = get_bedrock_runtime_client().converse(
        modelId=BEDROCK_MODEL_ID,
        messages=[
            {
                "role": "user",
                "content": [
                    {"image": {"format": "jpeg", "source": {"bytes": state["image_bytes"]}}},
                    {"text": IMAGE_ANALYSIS_PROMPT.format(work_info=state["work_info"])},
                ],
            }
        ],
        inferenceConfig={"maxTokens": 1024, "temperature": 0},
    )
    state["image_summary"] = extract_converse_text(response).strip()
    return state


# Bedrock Knowledge Base가 물려있던 AOSS 컬렉션이 삭제되어(비용 문제) KB의 retrieve()가
# 항상 403으로 실패하는 상태였다(과거 코드에는 예외를 삼키고 빈 컨텍스트로 넘어가는 임시
# 우회만 있었음 — 검색 없이도 Claude가 그럴듯한 법규를 지어내서 겉으로는 동작하는 것처럼
# 보였다). 이제 EC2에 직접 띄운 OpenSearch를 Titan Embeddings로 우리가 직접 벡터화해
# 쿼리한다. scripts/ingest_opensearch.py가 색인한 safety-index를 사용한다.
def search_knowledge_base(state: AnalysisState) -> AnalysisState:
    try:
        bedrock = get_bedrock_runtime_client()
        embed_response = bedrock.invoke_model(
            modelId=EMBED_MODEL_ID,
            body=json.dumps({
                "inputText": state["image_summary"],
                "dimensions": EMBED_DIMENSION,
                "normalize": True,
            }),
        )
        query_vector = json.loads(embed_response["body"].read())["embedding"]

        response = get_opensearch_client().search(
            index=OPENSEARCH_INDEX,
            body={
                "size": 10,
                "query": {"knn": {"vector": {"vector": query_vector, "k": 10}}},
            },
        )
        state["candidate_docs"] = [
            hit["_source"]["text"]
            for hit in response.get("hits", {}).get("hits", [])
            if hit.get("_source", {}).get("text")
        ]
    except Exception:
        state["candidate_docs"] = []
    return state


def rerank_documents(state: AnalysisState) -> AnalysisState:
    if not state["candidate_docs"]:
        state["reranked_docs"] = []
        return state

    response = get_rerank_client().rerank(
        queries=[{"type": "TEXT", "textQuery": {"text": state["image_summary"]}}],
        sources=[
            {
                "type": "INLINE",
                "inlineDocumentSource": {"type": "TEXT", "textDocument": {"text": doc}},
            }
            for doc in state["candidate_docs"]
        ],
        rerankingConfiguration={
            "type": "BEDROCK_RERANKING_MODEL",
            "bedrockRerankingConfiguration": {
                "modelConfiguration": {"modelArn": RERANK_MODEL_ARN},
                "numberOfResults": min(RERANK_TOP_N, len(state["candidate_docs"])),
            },
        },
    )
    state["reranked_docs"] = [
        state["candidate_docs"][result["index"]] for result in response.get("results", [])
    ]
    return state


def _parse_risk_items_json(raw_text: str) -> list[dict]:
    text = raw_text.strip()
    if text.startswith("```"):
        text = text.split("\n", 1)[1] if "\n" in text else text
        text = text.rsplit("```", 1)[0]
    return json.loads(text.strip())


def assemble_risk_items(state: AnalysisState) -> AnalysisState:
    context = "\n".join(f"- {doc}" for doc in state["reranked_docs"]) or "(관련 법령/사고사례 없음)"
    response = get_bedrock_runtime_client().converse(
        modelId=BEDROCK_MODEL_ID,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "text": RISK_ASSEMBLY_PROMPT.format(
                            image_summary=state["image_summary"], context=context
                        )
                    }
                ],
            }
        ],
        inferenceConfig={"maxTokens": 2048, "temperature": 0},
    )
    raw_text = extract_converse_text(response)
    state["risk_items"] = [RiskItem(**item) for item in _parse_risk_items_json(raw_text)]
    return state


def build_analysis_graph():
    graph = StateGraph(AnalysisState)
    graph.add_node("load_image", load_image)
    graph.add_node("analyze_with_bedrock", analyze_with_bedrock)
    graph.add_node("search_knowledge_base", search_knowledge_base)
    graph.add_node("rerank_documents", rerank_documents)
    graph.add_node("assemble_risk_items", assemble_risk_items)

    graph.set_entry_point("load_image")
    graph.add_edge("load_image", "analyze_with_bedrock")
    graph.add_edge("analyze_with_bedrock", "search_knowledge_base")
    graph.add_edge("search_knowledge_base", "rerank_documents")
    graph.add_edge("rerank_documents", "assemble_risk_items")
    graph.add_edge("assemble_risk_items", END)

    return graph.compile()
