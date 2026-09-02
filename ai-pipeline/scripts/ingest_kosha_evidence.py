"""
한국산업안전보건공단(KOSHA) 공공데이터 API에서 사고사례·안전신호등 데이터를 가져와
증거자료 탭(evidence.py)이 검색하는 Bedrock Knowledge Base용 텍스트 문서로 변환해
S3에 업로드하는 배치 스크립트.

대상 API (둘 다 공공데이터포털 data.go.kr에서 무료 활용신청 필요):
  - 한국산업안전보건공단_국내재해사례 게시판 정보 조회서비스
    https://www.data.go.kr/data/15121001/openapi.do
  - 한국산업안전보건공단_건설현장 안전 신호등
    https://www.data.go.kr/data/15139182/openapi.do

evidence.py는 KB 문서에 카테고리 메타데이터가 없어 "S3 파일명에 포함된 키워드"로
법규/사고사례/지침을 구분한다 (_classify_category 참고). 그래서 이 스크립트가 만드는
파일명은 반드시 "사고" 또는 "재해"를 포함해야 사고사례(case) 카테고리로 분류된다.

⚠️ 중요: 두 API 모두 data.go.kr에 로그인해 "활용신청"을 완료해야 서비스키가 발급되고,
그래야 실제 응답 필드명을 확인할 수 있다. 이 스크립트는 필드명을 아직 실제 응답으로
검증하지 못한 상태이므로, 처음 실행할 때는 반드시 --dry-run으로 먼저 raw JSON 구조를
콘솔에 찍어보고, _first()에 넘기는 후보 키 이름들이 실제 응답과 맞는지 확인한 뒤
--dry-run 없이 돌릴 것. 후보 키가 하나도 안 맞아도 전체 필드를 텍스트로 직렬화해
업로드하므로 데이터 유실은 없지만, 문서 품질(가독성)은 떨어진다.

사용법:
    export KOSHA_SERVICE_KEY=발급받은_서비스키(디코딩된 값)
    python scripts/ingest_kosha_evidence.py --source case --dry-run
    python scripts/ingest_kosha_evidence.py --source case --pages 3
    python scripts/ingest_kosha_evidence.py --source signal --dry-run
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from config import S3_BUCKET_NAME, get_s3_client  # noqa: E402

DISASTER_CASE_ENDPOINT = "http://apis.data.go.kr/B552468/domestic-disaster/getDomesticDisasterList"
SAFETY_SIGNAL_ENDPOINT = "http://apis.data.go.kr/B552468/safety-signal/getSafetySignalList"
# ⚠️ 위 두 엔드포인트는 data.go.kr 상세페이지에 정확한 URL이 공개돼 있지 않아, KOSHA의
# 다른 공공데이터 API(B552468 오퍼레이터)들과 같은 규칙을 따를 것이라는 추정으로 채워둔
# 값이다. 활용신청 승인 후 "미리보기"에서 실제 엔드포인트를 확인해 아래 상수를 교체할 것.

S3_PREFIX = "kosha-evidence"


def _first(item: dict, *candidate_keys: str, default: str = "-") -> str:
    """여러 후보 키 이름 중 값이 있는 첫 번째를 반환한다. (실제 필드명 미확정 대응)"""
    for key in candidate_keys:
        value = item.get(key)
        if value not in (None, ""):
            return str(value)
    return default


def _call_api(endpoint: str, params: dict) -> dict:
    query = urllib.parse.urlencode(params, safe=",")
    url = f"{endpoint}?{query}"
    try:
        with urllib.request.urlopen(url, timeout=15) as res:
            raw = res.read().decode("utf-8")
    except urllib.error.URLError as e:
        # 서비스키가 URL 쿼리에 포함되므로 예외 메시지를 그대로 로그에 남기지 않는다.
        raise RuntimeError(f"KOSHA API 호출 실패: {type(e).__name__}") from None

    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        # data.go.kr은 서비스키가 틀리거나 미승인 상태면 JSON이 아니라 XML 에러 메시지를 준다.
        raise RuntimeError(f"KOSHA API가 JSON이 아닌 응답을 반환했습니다 (서비스키/승인 상태 확인 필요): {raw[:300]}")

    header = parsed.get("response", {}).get("header", {})
    result_code = header.get("resultCode")
    if result_code not in (None, "00", "0"):
        raise RuntimeError(f"KOSHA API 오류: {header.get('resultMsg', result_code)}")

    return parsed


def fetch_disaster_cases(service_key: str, business: str = "건설업", pages: int = 1, num_of_rows: int = 50) -> list[dict]:
    items: list[dict] = []
    for page in range(1, pages + 1):
        parsed = _call_api(
            DISASTER_CASE_ENDPOINT,
            {
                "ServiceKey": service_key,
                "callApiId": "국내재해사례 게시판 조회",
                "business": business,
                "pageNo": page,
                "numOfRows": num_of_rows,
                "dataType": "JSON",
            },
        )
        body = parsed.get("response", {}).get("body", {})
        page_items = body.get("items", {})
        if isinstance(page_items, dict):
            page_items = page_items.get("item", [])
        if isinstance(page_items, dict):
            page_items = [page_items]
        if not page_items:
            break
        items.extend(page_items)
    return items


def fetch_safety_signal(service_key: str, num_of_rows: int = 100) -> list[dict]:
    parsed = _call_api(
        SAFETY_SIGNAL_ENDPOINT,
        {
            "ServiceKey": service_key,
            "callApiId": "1020",
            "pageNo": 1,
            "numOfRows": num_of_rows,
            "dataType": "JSON",
        },
    )
    body = parsed.get("response", {}).get("body", {})
    items = body.get("items", {})
    if isinstance(items, dict):
        items = items.get("item", [])
    if isinstance(items, dict):
        items = [items]
    return items or []


def case_to_document(item: dict, index: int) -> tuple[str, str]:
    title = _first(item, "title", "bbsTitle", "sj", "subject")
    industry = _first(item, "business", "induty", "induCls")
    reg_date = _first(item, "regDate", "regDt", "frstRegDt")
    content = _first(item, "content", "cn", "bbsCn", "summary")

    if content == "-":
        # 후보 키가 하나도 안 맞을 때를 대비해, 전체 필드를 사람이 읽을 수 있는 형태로 직렬화한다.
        content = "\n".join(f"{k}: {v}" for k, v in item.items() if v not in (None, ""))

    text = f"[국내재해사례] {title}\n업종: {industry}\n등록일: {reg_date}\n\n{content}"
    safe_title = "".join(c for c in title if c.isalnum() or c in " _-")[:40].strip() or f"case{index}"
    filename = f"사고사례_국내재해사례_{safe_title}_{index}.txt"
    return filename, text


def signal_to_document(item: dict, index: int) -> tuple[str, str]:
    site_name = _first(item, "siteName", "sjNm", "bsnmNm", "constructionName")
    grade = _first(item, "signalGrade", "signal", "grade", "trafficLight")
    region = _first(item, "region", "area", "sido")
    inspect_date = _first(item, "inspectDate", "chkDt", "guidanceDate")

    if all(v == "-" for v in (site_name, grade, region, inspect_date)):
        body = "\n".join(f"{k}: {v}" for k, v in item.items() if v not in (None, ""))
    else:
        body = f"현장명: {site_name}\n지역: {region}\n안전신호등 등급: {grade}\n점검일: {inspect_date}"

    # 파일명에 "사고"/"재해"/"법"/"규칙"/"기준"이 없으면 evidence.py 휴리스틱상 guide로 분류된다.
    # 신호등 데이터는 참고 지침에 가깝다고 보고 guide로 분류되도록 그대로 둔다.
    text = f"[건설현장 안전신호등] {site_name}\n\n{body}"
    safe_name = "".join(c for c in site_name if c.isalnum() or c in " _-")[:40].strip() or f"signal{index}"
    filename = f"안전신호등_{safe_name}_{index}.txt"
    return filename, text


def upload(filename: str, text: str, dry_run: bool) -> None:
    if dry_run:
        print(f"--- (dry-run) s3://{S3_BUCKET_NAME}/{S3_PREFIX}/{filename} ---")
        print(text[:400])
        print()
        return

    get_s3_client().put_object(
        Bucket=S3_BUCKET_NAME,
        Key=f"{S3_PREFIX}/{filename}",
        Body=text.encode("utf-8"),
        ContentType="text/plain; charset=utf-8",
    )
    print(f"업로드 완료: s3://{S3_BUCKET_NAME}/{S3_PREFIX}/{filename}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", choices=["case", "signal"], required=True)
    parser.add_argument("--pages", type=int, default=1, help="국내재해사례: 가져올 페이지 수")
    parser.add_argument("--dry-run", action="store_true", help="S3 업로드 없이 raw 응답과 변환 결과만 출력")
    args = parser.parse_args()

    service_key = os.environ.get("KOSHA_SERVICE_KEY")
    if not service_key:
        print("환경변수 KOSHA_SERVICE_KEY가 필요합니다. (data.go.kr 활용신청 승인 후 발급되는 서비스키)")
        sys.exit(1)

    try:
        if args.source == "case":
            items = fetch_disaster_cases(service_key, pages=args.pages)
        else:
            items = fetch_safety_signal(service_key)
    except RuntimeError as e:
        print(f"조회 실패: {e}")
        print("엔드포인트 URL은 아직 실제 응답으로 검증되지 않은 추정값입니다 — 스크립트 상단 주석 참고.")
        sys.exit(1)

    label = "국내재해사례" if args.source == "case" else "안전신호등"
    print(f"{label} {len(items)}건 조회됨.")
    if items:
        print("--- 첫 번째 항목 raw JSON (필드명 확인용) ---")
        print(json.dumps(items[0], ensure_ascii=False, indent=2))

    to_document = case_to_document if args.source == "case" else signal_to_document
    for i, item in enumerate(items):
        filename, text = to_document(item, i)
        upload(filename, text, args.dry_run)

    if not args.dry_run:
        print(
            "\nS3 업로드 완료. Bedrock Knowledge Base 콘솔에서 데이터 소스 동기화(Sync)를 "
            "눌러야 evidence.py 검색에 반영됩니다."
        )


if __name__ == "__main__":
    main()
