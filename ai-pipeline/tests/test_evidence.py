from unittest.mock import MagicMock

from evidence import search_evidence
from schemas import EvidenceRequest


def _mock_retrieve_response():
    return {
        "retrievalResults": [
            {
                "content": {"text": "사업주는 근로자가 추락할 위험이 있는 장소에는 안전난간을 설치해야 한다."},
                "location": {"s3Location": {"uri": "s3://bucket/kb-source/산업안전보건법.pdf"}},
            },
            {
                "content": {"text": "2025년 건설현장 추락사고 사례 분석 결과 안전난간 미설치가 주요 원인이었다."},
                "location": {"s3Location": {"uri": "s3://bucket/kb-source/안전교육의 날 교육 사고사례.pdf"}},
            },
        ]
    }


def _mock_rerank_response():
    return {
        "results": [
            {"index": 0, "relevanceScore": 0.98},
            {"index": 1, "relevanceScore": 0.72},
        ]
    }


def test_검색어로_법규와_사고사례를_찾으면_카테고리를_파일명으로_분류한다(monkeypatch):
    mock_retrieve_client = MagicMock()
    mock_retrieve_client.retrieve.return_value = _mock_retrieve_response()
    monkeypatch.setattr("evidence.get_bedrock_agent_runtime_client", lambda: mock_retrieve_client)

    mock_rerank_client = MagicMock()
    mock_rerank_client.rerank.return_value = _mock_rerank_response()
    monkeypatch.setattr("evidence.get_rerank_client", lambda: mock_rerank_client)

    items = search_evidence(EvidenceRequest(query="안전난간 미설치"))

    assert len(items) == 2
    assert items[0].category == "law"
    assert items[0].relevance == 98
    assert items[1].category == "case"
    assert items[1].relevance == 72


def test_category_필터를_주면_해당_카테고리만_반환한다(monkeypatch):
    mock_retrieve_client = MagicMock()
    mock_retrieve_client.retrieve.return_value = _mock_retrieve_response()
    monkeypatch.setattr("evidence.get_bedrock_agent_runtime_client", lambda: mock_retrieve_client)

    mock_rerank_client = MagicMock()
    mock_rerank_client.rerank.return_value = _mock_rerank_response()
    monkeypatch.setattr("evidence.get_rerank_client", lambda: mock_rerank_client)

    items = search_evidence(EvidenceRequest(query="안전난간 미설치", category="case"))

    assert len(items) == 1
    assert items[0].category == "case"


def test_검색결과가_없으면_rerank를_호출하지_않고_빈_목록을_반환한다(monkeypatch):
    mock_retrieve_client = MagicMock()
    mock_retrieve_client.retrieve.return_value = {"retrievalResults": []}
    monkeypatch.setattr("evidence.get_bedrock_agent_runtime_client", lambda: mock_retrieve_client)

    mock_rerank_client = MagicMock()
    monkeypatch.setattr("evidence.get_rerank_client", lambda: mock_rerank_client)

    items = search_evidence(EvidenceRequest(query="아무거나"))

    assert items == []
    mock_rerank_client.rerank.assert_not_called()
