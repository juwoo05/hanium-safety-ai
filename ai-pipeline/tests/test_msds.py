import json
from unittest.mock import MagicMock

from msds import detect_chemicals
from schemas import MsdsDetectRequest


def _converse_returning(text: str):
    client = MagicMock()
    client.converse.return_value = {"output": {"message": {"content": [{"text": text}]}}}
    return client


def _patch(monkeypatch, converse_client):
    monkeypatch.setattr("msds._load_image_bytes", lambda key: b"fake-image-bytes")
    monkeypatch.setattr("msds.get_bedrock_runtime_client", lambda: converse_client)


def test_라벨_사진에서_물질_후보와_키워드를_추출한다(monkeypatch):
    payload = json.dumps(
        {
            "detected_keywords": ["톨루엔", "인화성", "GHS02"],
            "chemical_candidates": [
                {"chemical_name": "톨루엔", "cas_no": "108-88-3", "product_name": "락카 신너", "confidence": 88}
            ],
        },
        ensure_ascii=False,
    )
    _patch(monkeypatch, _converse_returning(payload))

    result = detect_chemicals(MsdsDetectRequest(image_s3_key="k.jpg", work_info="도장 작업"))

    assert result.detected_keywords == ["톨루엔", "인화성", "GHS02"]
    assert len(result.chemical_candidates) == 1
    assert result.chemical_candidates[0].cas_no == "108-88-3"
    assert result.chemical_candidates[0].confidence == 88


def test_마크다운_코드블록으로_감싼_JSON도_파싱한다(monkeypatch):
    payload = "```json\n" + json.dumps(
        {"detected_keywords": [], "chemical_candidates": [{"chemical_name": "아세톤"}]},
        ensure_ascii=False,
    ) + "\n```"
    _patch(monkeypatch, _converse_returning(payload))

    result = detect_chemicals(MsdsDetectRequest(image_s3_key="k.jpg"))

    assert result.chemical_candidates[0].chemical_name == "아세톤"
    assert result.chemical_candidates[0].cas_no is None


def test_모델이_형식을_벗어난_응답을_주면_빈_결과를_반환한다(monkeypatch):
    _patch(monkeypatch, _converse_returning("사진에 화학물질이 안 보입니다."))

    result = detect_chemicals(MsdsDetectRequest(image_s3_key="k.jpg"))

    assert result.detected_keywords == []
    assert result.chemical_candidates == []
