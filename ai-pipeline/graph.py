import json
from typing import TypedDict

from langgraph.graph import END, StateGraph

from bedrock_utils import extract_converse_text
from config import (
    BEDROCK_MODEL_ID,
    KNOWLEDGE_BASE_ID,
    RERANK_MODEL_ARN,
    S3_BUCKET_NAME,
    get_bedrock_agent_runtime_client,
    get_bedrock_runtime_client,
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


# retrieve()는 Knowledge Base 내부에서 Titan Embeddings로 쿼리를 자동 벡터화한 뒤
# OpenSearch를 검색하므로, 별도의 임베딩 노드를 두지 않는다.
def search_knowledge_base(state: AnalysisState) -> AnalysisState:
    # TEMP-QA-DUMMY: AOSS 데이터 액세스 정책 403 이슈로 KB 검색이 막혀있어 더미 데이터 생성을 위해 임시 우회.
    try:
        response = get_bedrock_agent_runtime_client().retrieve(
            knowledgeBaseId=KNOWLEDGE_BASE_ID,
            retrievalQuery={"text": state["image_summary"]},
            retrievalConfiguration={"vectorSearchConfiguration": {"numberOfResults": 10}},
        )
        state["candidate_docs"] = [
            result["content"]["text"]
            for result in response.get("retrievalResults", [])
            if result.get("content", {}).get("text")
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
