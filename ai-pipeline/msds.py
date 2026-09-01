"""사진에서 MSDS 검색용 키워드/화학물질 후보를 추출한다.

graph.py의 이미지 분석 노드와 같은 방식(S3에서 이미지 로드 → Bedrock 멀티모달 converse)이지만,
Knowledge Base 검색은 하지 않고 "무엇을 검색해야 하는지"만 뽑아낸다. 실제 MSDS 문서 검색은
Spring 쪽 MsdsProvider(KOSHA/제조사/내부/mock)가 담당한다.
"""

import json

from bedrock_utils import extract_converse_text
from config import BEDROCK_MODEL_ID, S3_BUCKET_NAME, get_bedrock_runtime_client, get_s3_client
from schemas import ChemicalCandidate, MsdsDetectRequest, MsdsDetectResponse

DETECT_PROMPT = """당신은 화학물질 안전관리 전문가입니다.
아래 현장 사진(위험물 용기 라벨, 화학제품 포장, 경고표지 등)을 보고 MSDS(물질안전보건자료)를
찾는 데 필요한 정보를 추출하세요.

작업 정보: {work_info}

다음 형식의 JSON 객체 하나만 출력하세요. 설명 문장은 절대 쓰지 마세요.
{{
  "detected_keywords": ["사진에서 읽히는 물질명/제품명/경고문구/그림문자 등 키워드"],
  "chemical_candidates": [
    {{"chemical_name": "물질명(한글)", "cas_no": "CAS 번호 또는 null", "product_name": "제품명 또는 null", "confidence": 0-100 정수}}
  ]
}}

규칙:
- 라벨이 흐리거나 확신이 없으면 단정하지 말고 confidence를 낮춰서 여러 후보를 넣으세요.
- 사진에 화학물질이 전혀 없으면 두 배열 모두 빈 배열로 두세요.
- CAS 번호가 사진에 없으면 추측하지 말고 null 로 두세요."""


def _load_image_bytes(image_s3_key: str) -> bytes:
    response = get_s3_client().get_object(Bucket=S3_BUCKET_NAME, Key=image_s3_key)
    return response["Body"].read()


def _parse_json_object(raw_text: str) -> dict:
    text = raw_text.strip()
    if text.startswith("```"):
        text = text.split("\n", 1)[1] if "\n" in text else text
        text = text.rsplit("```", 1)[0]
    return json.loads(text.strip())


def detect_chemicals(request: MsdsDetectRequest) -> MsdsDetectResponse:
    image_bytes = _load_image_bytes(request.image_s3_key)

    response = get_bedrock_runtime_client().converse(
        modelId=BEDROCK_MODEL_ID,
        messages=[
            {
                "role": "user",
                "content": [
                    {"image": {"format": "jpeg", "source": {"bytes": image_bytes}}},
                    {"text": DETECT_PROMPT.format(work_info=request.work_info or "정보 없음")},
                ],
            }
        ],
        inferenceConfig={"maxTokens": 1024, "temperature": 0},
    )

    try:
        parsed = _parse_json_object(extract_converse_text(response))
    except (json.JSONDecodeError, ValueError):
        # 모델이 형식을 벗어난 응답을 준 경우: 인식 실패로 보고 빈 결과 반환(사용자가 직접 검색)
        return MsdsDetectResponse(detected_keywords=[], chemical_candidates=[])

    keywords = [str(k) for k in parsed.get("detected_keywords", []) if k]
    candidates: list[ChemicalCandidate] = []
    for raw in parsed.get("chemical_candidates", []):
        name = (raw or {}).get("chemical_name")
        if not name:
            continue
        candidates.append(
            ChemicalCandidate(
                chemical_name=str(name),
                cas_no=(str(raw["cas_no"]) if raw.get("cas_no") else None),
                product_name=(str(raw["product_name"]) if raw.get("product_name") else None),
                confidence=int(raw.get("confidence") or 0),
            )
        )

    return MsdsDetectResponse(detected_keywords=keywords, chemical_candidates=candidates)
