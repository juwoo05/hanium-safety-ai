import uuid
from datetime import date, datetime

from bedrock_utils import extract_converse_text
from config import (
    BEDROCK_MODEL_ID,
    S3_BUCKET_NAME,
    get_bedrock_runtime_client,
    get_s3_client,
    get_translate_client,
)
from schemas import ReportRequest

REPORT_URL_EXPIRES_IN = 3600
TRANSLATE_MAX_BYTES = 9000

REPORT_GENERATION_PROMPT = """당신은 건설현장 안전관리 보고서를 작성하는 전문가입니다.
아래 점검 정보를 바탕으로 한국어 마크다운 형식의 안전관리 보고서를 작성하세요.
보고서에는 현장 정보, 점검 ID, 작업 정보, 위험요소 목록(위험요소명/근거 법령/필요 조치), 조치 현황이 포함되어야 합니다.
설명 없이 보고서 본문만 출력하세요.

현장 ID: {site_id}
점검 ID: {inspection_id}
작업 정보: {work_info}

위험요소 목록:
{risk_items_text}

조치 현황:
{action_items_text}"""


def _build_mcp_context(request: ReportRequest) -> str:
    risk_items_text = "\n".join(
        f"- {item.risk_name} | 근거: {item.legal_basis} | 조치사항: {item.action_required}"
        for item in request.risk_items
    ) or "(감지된 위험요소 없음)"

    action_items_text = "\n".join(
        f"- {item.risk_name}: {item.action_status}"
        + (f" ({item.action_detail})" if item.action_detail else "")
        for item in request.action_items
    ) or "(등록된 조치 없음)"

    return REPORT_GENERATION_PROMPT.format(
        site_id=request.site_id,
        inspection_id=request.inspection_id,
        work_info=request.work_info,
        risk_items_text=risk_items_text,
        action_items_text=action_items_text,
    )


def _generate_report_text(context: str) -> str:
    response = get_bedrock_runtime_client().converse(
        modelId=BEDROCK_MODEL_ID,
        messages=[{"role": "user", "content": [{"text": context}]}],
        inferenceConfig={"maxTokens": 4096, "temperature": 0},
    )
    return extract_converse_text(response).strip()


def _translate_chunk(client, text: str, target_language: str) -> str:
    response = client.translate_text(
        Text=text, SourceLanguageCode="ko", TargetLanguageCode=target_language
    )
    return response["TranslatedText"]


def _translate_text(text: str, target_language: str) -> str:
    if target_language == "ko":
        return text

    client = get_translate_client()
    translated_chunks = []
    chunk = ""
    for paragraph in text.split("\n"):
        candidate = f"{chunk}\n{paragraph}" if chunk else paragraph
        if chunk and len(candidate.encode("utf-8")) > TRANSLATE_MAX_BYTES:
            translated_chunks.append(_translate_chunk(client, chunk, target_language))
            chunk = paragraph
        else:
            chunk = candidate
    if chunk:
        translated_chunks.append(_translate_chunk(client, chunk, target_language))
    return "\n".join(translated_chunks)


def _upload_report(site_id: str, report_id: str, text: str) -> str:
    key = f"reports/{site_id}/{date.today().isoformat()}/{report_id}.md"
    get_s3_client().put_object(
        Bucket=S3_BUCKET_NAME, Key=key, Body=text.encode("utf-8"), ContentType="text/markdown"
    )
    return key


def _presigned_report_url(key: str) -> str:
    return get_s3_client().generate_presigned_url(
        "get_object",
        Params={"Bucket": S3_BUCKET_NAME, "Key": key},
        ExpiresIn=REPORT_URL_EXPIRES_IN,
    )


def generate_report(request: ReportRequest) -> dict:
    context = _build_mcp_context(request)
    report_text = _generate_report_text(context)
    report_text = _translate_text(report_text, request.target_language)

    report_id = str(uuid.uuid4())
    report_s3_key = _upload_report(request.site_id, report_id, report_text)
    report_url = _presigned_report_url(report_s3_key)

    return {
        "report_id": report_id,
        "report_s3_key": report_s3_key,
        "report_url": report_url,
        "generated_at": datetime.now(),
    }
