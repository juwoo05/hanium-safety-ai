import json
from unittest.mock import MagicMock

import boto3
import pytest
from moto import mock_aws

from graph import (
    analyze_with_bedrock,
    assemble_risk_items,
    load_image,
    rerank_documents,
    search_knowledge_base,
)


@mock_aws
def test_S3에_저장된_이미지를_읽으면_바이트를_state에_담는다(monkeypatch):
    monkeypatch.setattr("graph.S3_BUCKET_NAME", "test-bucket")
    s3 = boto3.client("s3", region_name="ap-northeast-2")
    s3.create_bucket(
        Bucket="test-bucket",
        CreateBucketConfiguration={"LocationConstraint": "ap-northeast-2"},
    )
    s3.put_object(Bucket="test-bucket", Key="images/test.jpg", Body=b"fake-image-bytes")

    state = {
        "site_id": "site-1",
        "image_s3_key": "images/test.jpg",
        "work_info": "테스트 작업",
    }

    result = load_image(state)

    assert result["image_bytes"] == b"fake-image-bytes"


def test_Bedrock_응답에_텍스트_콘텐츠가_없으면_ValueError를_발생시킨다(monkeypatch):
    mock_client = MagicMock()
    mock_client.converse.return_value = {
        "output": {"message": {"content": []}},
        "stopReason": "content_filtered",
    }
    monkeypatch.setattr("graph.get_bedrock_runtime_client", lambda: mock_client)

    state = {"site_id": "site-1", "work_info": "고소작업", "image_bytes": b"fake-image-bytes"}

    with pytest.raises(ValueError, match="content_filtered"):
        analyze_with_bedrock(state)


def test_Bedrock_멀티모달_응답을_받으면_이미지_요약을_state에_담는다(monkeypatch):
    mock_client = MagicMock()
    mock_client.converse.return_value = {
        "output": {"message": {"content": [{"text": " 안전난간 미설치 추락 위험 "}]}}
    }
    monkeypatch.setattr("graph.get_bedrock_runtime_client", lambda: mock_client)

    state = {"site_id": "site-1", "work_info": "고소작업", "image_bytes": b"fake-image-bytes"}

    result = analyze_with_bedrock(state)

    assert result["image_summary"] == "안전난간 미설치 추락 위험"


def test_KnowledgeBase_검색결과가_있으면_candidate_docs에_텍스트를_담는다(monkeypatch):
    mock_client = MagicMock()
    mock_client.retrieve.return_value = {
        "retrievalResults": [
            {"content": {"text": "산업안전보건법 제38조"}},
            {"content": {"text": "유사 사고사례 A"}},
        ]
    }
    monkeypatch.setattr("graph.get_bedrock_agent_runtime_client", lambda: mock_client)

    state = {"image_summary": "추락 위험", "candidate_docs": []}

    result = search_knowledge_base(state)

    assert result["candidate_docs"] == ["산업안전보건법 제38조", "유사 사고사례 A"]


def test_candidate_docs가_없으면_rerank를_호출하지_않고_빈_목록을_반환한다(monkeypatch):
    mock_client = MagicMock()
    monkeypatch.setattr("graph.get_rerank_client", lambda: mock_client)

    state = {"image_summary": "추락 위험", "candidate_docs": []}

    result = rerank_documents(state)

    assert result["reranked_docs"] == []
    mock_client.rerank.assert_not_called()


def test_rerank_결과의_index순서대로_candidate_docs를_재정렬한다(monkeypatch):
    mock_client = MagicMock()
    mock_client.rerank.return_value = {"results": [{"index": 1}, {"index": 0}]}
    monkeypatch.setattr("graph.get_rerank_client", lambda: mock_client)

    state = {
        "image_summary": "추락 위험",
        "candidate_docs": ["산업안전보건법 제38조", "유사 사고사례 A"],
    }

    result = rerank_documents(state)

    assert result["reranked_docs"] == ["유사 사고사례 A", "산업안전보건법 제38조"]


def test_LLM이_마크다운_코드블록으로_감싼_JSON을_응답해도_risk_items를_파싱한다(monkeypatch):
    mock_client = MagicMock()
    risk_items_json = json.dumps(
        [
            {
                "risk_name": "추락 위험",
                "legal_basis": "산업안전보건법 제38조",
                "action_required": "안전난간 설치",
            }
        ],
        ensure_ascii=False,
    )
    mock_client.converse.return_value = {
        "output": {"message": {"content": [{"text": f"```json\n{risk_items_json}\n```"}]}}
    }
    monkeypatch.setattr("graph.get_bedrock_runtime_client", lambda: mock_client)

    state = {"image_summary": "추락 위험", "reranked_docs": ["산업안전보건법 제38조"]}

    result = assemble_risk_items(state)

    assert len(result["risk_items"]) == 1
    assert result["risk_items"][0].risk_name == "추락 위험"
    assert result["risk_items"][0].action_required == "안전난간 설치"
