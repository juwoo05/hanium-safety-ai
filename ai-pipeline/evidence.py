from config import (
    KNOWLEDGE_BASE_ID,
    RERANK_MODEL_ARN,
    get_bedrock_agent_runtime_client,
    get_rerank_client,
)
from schemas import EvidenceItem, EvidenceRequest

RETRIEVE_TOP_N = 10
RERANK_TOP_N = 5

# Knowledge Base 문서에 카테고리 메타데이터가 없어(원본 산업안전보건법령·사고사례·매뉴얼 PDF 그대로 인제스천),
# S3 파일명 키워드로 법규/사고사례/지침을 구분하는 휴리스틱을 사용한다.
_CASE_KEYWORDS = ("사고", "재해")
_LAW_KEYWORDS = ("법", "규칙", "기준")


def _classify_category(source: str) -> str:
    if any(keyword in source for keyword in _CASE_KEYWORDS):
        return "case"
    if any(keyword in source for keyword in _LAW_KEYWORDS):
        return "law"
    return "guide"


def _extract_source(result: dict) -> str:
    uri = result.get("location", {}).get("s3Location", {}).get("uri", "")
    filename = uri.rsplit("/", 1)[-1] if uri else "관련 문서"
    return filename.rsplit(".", 1)[0] if "." in filename else filename


def _search_candidates(query: str) -> list[dict]:
    response = get_bedrock_agent_runtime_client().retrieve(
        knowledgeBaseId=KNOWLEDGE_BASE_ID,
        retrievalQuery={"text": query},
        retrievalConfiguration={"vectorSearchConfiguration": {"numberOfResults": RETRIEVE_TOP_N}},
    )
    candidates = []
    for result in response.get("retrievalResults", []):
        text = result.get("content", {}).get("text")
        if not text:
            continue
        candidates.append({"text": text, "source": _extract_source(result)})
    return candidates


def _rerank_candidates(query: str, candidates: list[dict], result_count: int) -> list[EvidenceItem]:
    if not candidates:
        return []

    response = get_rerank_client().rerank(
        queries=[{"type": "TEXT", "textQuery": {"text": query}}],
        sources=[
            {
                "type": "INLINE",
                "inlineDocumentSource": {"type": "TEXT", "textDocument": {"text": c["text"]}},
            }
            for c in candidates
        ],
        rerankingConfiguration={
            "type": "BEDROCK_RERANKING_MODEL",
            "bedrockRerankingConfiguration": {
                "modelConfiguration": {"modelArn": RERANK_MODEL_ARN},
                "numberOfResults": min(result_count, len(candidates)),
            },
        },
    )

    items = []
    for result in response.get("results", []):
        candidate = candidates[result["index"]]
        text = candidate["text"].strip()
        source = candidate["source"]
        items.append(
            EvidenceItem(
                title=source,
                snippet=text[:150] + ("..." if len(text) > 150 else ""),
                source=source,
                category=_classify_category(source),
                relevance=round(result.get("relevanceScore", 0) * 100),
            )
        )
    return items


def search_evidence(request: EvidenceRequest) -> list[EvidenceItem]:
    candidates = _search_candidates(request.query)

    if request.category:
        # 카테고리 필터가 있으면 상위 RERANK_TOP_N개만 보고 필터링하면 그 안에 해당 카테고리가
        # 하나도 없을 때 결과가 빈 배열이 되어버린다. 후보 전체를 재순위화한 뒤 필터링·상위 N개로 자른다.
        items = _rerank_candidates(request.query, candidates, len(candidates))
        return [item for item in items if item.category == request.category][:RERANK_TOP_N]

    return _rerank_candidates(request.query, candidates, RERANK_TOP_N)
