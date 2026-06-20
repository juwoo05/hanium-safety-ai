---
name: fastapi-test-writer
description: FastAPI AI 파이프라인 pytest 테스트 작성 — LangGraph 노드 단위 테스트, AWS 서비스 모킹, given-when-then 구조
metadata:
  type: skill
---

# FastAPI / Python 테스트 작성

## Trigger
"파이썬 테스트", "pytest", "fastapi test", "테스트 짜줘" + Python 파일이 대상일 때 이 스킬을 사용한다.

## Instructions

안전고리 FastAPI 파이프라인의 pytest 테스트를 작성한다.
given-when-then 구조, AWS 서비스 모킹, 의미 있는 한국어 함수명을 사용한다.

---

### 기본 구조

```python
import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

class TestAnalyzePipeline:
    def test_현장사진_업로드시_위험요소_분석결과를_반환한다(self):
        # given
        request_body = {
            "site_id": "site-001",
            "image_key": "site-001/2026-06-20/test.jpg",
            "work_info": "고소작업 구역 점검"
        }

        # when
        with patch("services.bedrock_service.invoke_model") as mock_bedrock:
            mock_bedrock.return_value = {"risk_items": [...]}
            response = client.post("/analyze", json=request_body)

        # then
        assert response.status_code == 200
        assert "risk_items" in response.json()
```

---

### AWS 서비스 모킹 패턴

**Bedrock 모킹**
```python
@patch("boto3.client")
def test_bedrock_호출_실패시_오류응답을_반환한다(mock_boto):
    mock_boto.return_value.invoke_model.side_effect = Exception("Bedrock error")
    response = client.post("/analyze", json={...})
    assert response.status_code == 500
```

**S3 모킹** — `moto` 라이브러리 사용 권장
```python
import boto3
from moto import mock_s3

@mock_s3
def test_현장사진_S3_업로드_성공시_키를_반환한다():
    s3 = boto3.client("s3", region_name="ap-northeast-2")
    s3.create_bucket(Bucket="test-bucket")
    # given / when / then ...
```

**OpenSearch 모킹**
```python
@patch("services.search_service.search_documents")
def test_검색결과_없을때_빈리스트로_파이프라인이_계속된다(mock_search):
    mock_search.return_value = []
    response = client.post("/analyze", json={...})
    assert response.status_code == 200
```

---

### LangGraph 노드 단위 테스트

각 노드를 독립적으로 테스트한다.

```python
from pipeline.nodes import analyze_image_node, search_documents_node

def test_이미지분석_노드_위험요소_항목을_포함한_상태를_반환한다():
    # given
    state = {"image_base64": "...", "work_info": "고소작업"}

    # when
    with patch("pipeline.nodes.bedrock_client") as mock:
        mock.invoke_model.return_value = {"body": ...}
        result = analyze_image_node(state)

    # then
    assert "risk_summary" in result
    assert "법규 근거" in result["risk_summary"]
```

---

### 테스트 파일 위치 규칙
```
fastapi-server/
  tests/
    test_analyze_endpoint.py   # /analyze 엔드포인트
    test_report_endpoint.py    # /report 엔드포인트
    test_pipeline_nodes.py     # LangGraph 노드 단위
    test_s3_service.py         # S3 업로드/조회
    conftest.py                # 공통 fixture (TestClient, mock AWS)
```

---

### 주의사항
- 실제 AWS 서비스를 호출하는 테스트는 작성하지 않는다 (비용 발생, CI 불안정).
- `conftest.py`에 공통 환경변수 mock fixture를 정의한다.
- 테스트 함수명은 한국어 + 스네이크케이스: `test_현장사진_없으면_400을_반환한다`.
