from unittest.mock import MagicMock

import boto3
from moto import mock_aws

from report import generate_report
from schemas import ActionItem, ReportRequest, RiskItem


def _sample_request(target_language="ko"):
    return ReportRequest(
        site_id="site-1",
        inspection_id="inspection-1",
        work_info="고소작업",
        risk_items=[
            RiskItem(
                risk_name="추락 위험",
                legal_basis="산업안전보건법 제38조",
                action_required="안전난간 설치",
            )
        ],
        action_items=[
            ActionItem(risk_name="추락 위험", action_status="진행중", action_detail="난간 설치 중")
        ],
        target_language=target_language,
    )


def _create_bucket():
    s3 = boto3.client("s3", region_name="ap-northeast-2")
    s3.create_bucket(
        Bucket="test-bucket", CreateBucketConfiguration={"LocationConstraint": "ap-northeast-2"}
    )
    return s3


@mock_aws
def test_한국어_보고서를_생성하면_번역없이_S3에_업로드하고_URL을_반환한다(monkeypatch):
    monkeypatch.setattr("report.S3_BUCKET_NAME", "test-bucket")
    s3 = _create_bucket()

    mock_bedrock = MagicMock()
    mock_bedrock.converse.return_value = {
        "output": {"message": {"content": [{"text": "# 안전관리 보고서\n추락 위험 감지"}]}}
    }
    monkeypatch.setattr("report.get_bedrock_runtime_client", lambda: mock_bedrock)

    mock_translate = MagicMock()
    monkeypatch.setattr("report.get_translate_client", lambda: mock_translate)

    result = generate_report(_sample_request(target_language="ko"))

    assert result["report_s3_key"].startswith("reports/site-1/")
    assert result["report_url"].startswith("https://")
    mock_translate.translate_text.assert_not_called()

    uploaded = s3.get_object(Bucket="test-bucket", Key=result["report_s3_key"])
    assert "안전관리 보고서" in uploaded["Body"].read().decode("utf-8")


@mock_aws
def test_target_language가_ko가_아니면_번역을_호출한다(monkeypatch):
    monkeypatch.setattr("report.S3_BUCKET_NAME", "test-bucket")
    s3 = _create_bucket()

    mock_bedrock = MagicMock()
    mock_bedrock.converse.return_value = {
        "output": {"message": {"content": [{"text": "추락 위험 감지"}]}}
    }
    monkeypatch.setattr("report.get_bedrock_runtime_client", lambda: mock_bedrock)

    mock_translate = MagicMock()
    mock_translate.translate_text.return_value = {"TranslatedText": "Fall risk detected"}
    monkeypatch.setattr("report.get_translate_client", lambda: mock_translate)

    result = generate_report(_sample_request(target_language="en"))

    mock_translate.translate_text.assert_called_once()
    uploaded = s3.get_object(Bucket="test-bucket", Key=result["report_s3_key"])
    assert uploaded["Body"].read().decode("utf-8") == "Fall risk detected"
