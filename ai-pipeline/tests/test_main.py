from datetime import datetime
from unittest.mock import MagicMock

from botocore.exceptions import ClientError
from fastapi.testclient import TestClient

import main
from schemas import RiskItem

REQUEST_BODY = {"site_id": "site-1", "image_s3_key": "images/test.jpg", "work_info": "테스트 작업"}

REPORT_REQUEST_BODY = {
    "site_id": "site-1",
    "inspection_id": "inspection-1",
    "work_info": "고소작업",
    "risk_items": [
        {
            "risk_name": "추락 위험",
            "legal_basis": "산업안전보건법 제38조",
            "action_required": "안전난간 설치",
        }
    ],
}


def test_API_KEY_헤더가_없으면_401을_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    client = TestClient(main.app)

    response = client.post("/analyze", json=REQUEST_BODY)

    assert response.status_code == 401


def test_API_KEY가_틀리면_401을_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    client = TestClient(main.app)

    response = client.post("/analyze", headers={"X-API-Key": "wrong-key"}, json=REQUEST_BODY)

    assert response.status_code == 401


def test_서버에_INTERNAL_API_KEY가_설정되지_않으면_모든_요청을_거부한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", None)
    client = TestClient(main.app)

    response = client.post("/analyze", headers={"X-API-Key": "anything"}, json=REQUEST_BODY)

    assert response.status_code == 401


def test_AWS_호출이_ClientError를_던지면_500과_AWSServiceError를_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    monkeypatch.setattr(
        main.analysis_graph,
        "invoke",
        MagicMock(
            side_effect=ClientError(
                {"Error": {"Code": "ThrottlingException", "Message": "Rate exceeded"}},
                "Converse",
            )
        ),
    )
    client = TestClient(main.app)

    response = client.post("/analyze", headers={"X-API-Key": "secret-key"}, json=REQUEST_BODY)

    assert response.status_code == 500
    assert response.json()["error"] == "AWSServiceError"


def test_올바른_API_KEY면_분석_파이프라인을_호출하고_200을_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    monkeypatch.setattr(
        main.analysis_graph,
        "invoke",
        MagicMock(
            return_value={
                "risk_items": [
                    RiskItem(
                        risk_name="추락 위험",
                        legal_basis="산업안전보건법 제38조",
                        action_required="안전난간 설치",
                    )
                ]
            }
        ),
    )
    client = TestClient(main.app)

    response = client.post("/analyze", headers={"X-API-Key": "secret-key"}, json=REQUEST_BODY)

    assert response.status_code == 200
    assert response.json()["risk_items"][0]["risk_name"] == "추락 위험"


def test_report_요청에_API_KEY가_없으면_401을_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    client = TestClient(main.app)

    response = client.post("/report", json=REPORT_REQUEST_BODY)

    assert response.status_code == 401


def test_report가_AWS_ClientError를_던지면_500과_AWSServiceError를_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    monkeypatch.setattr(
        "main.generate_report",
        MagicMock(
            side_effect=ClientError(
                {"Error": {"Code": "ThrottlingException", "Message": "Rate exceeded"}},
                "Converse",
            )
        ),
    )
    client = TestClient(main.app)

    response = client.post(
        "/report", headers={"X-API-Key": "secret-key"}, json=REPORT_REQUEST_BODY
    )

    assert response.status_code == 500
    assert response.json()["error"] == "AWSServiceError"


def test_올바른_API_KEY면_보고서를_생성하고_200을_반환한다(monkeypatch):
    monkeypatch.setattr("auth.INTERNAL_API_KEY", "secret-key")
    monkeypatch.setattr(
        "main.generate_report",
        MagicMock(
            return_value={
                "report_id": "report-1",
                "report_s3_key": "reports/site-1/2026-07-27/report-1.md",
                "report_url": "https://example.com/report-1.md",
                "generated_at": datetime.now(),
            }
        ),
    )
    client = TestClient(main.app)

    response = client.post(
        "/report", headers={"X-API-Key": "secret-key"}, json=REPORT_REQUEST_BODY
    )

    assert response.status_code == 200
    assert response.json()["report_id"] == "report-1"
