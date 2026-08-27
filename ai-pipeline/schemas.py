from datetime import datetime

from pydantic import BaseModel


class AnalyzeRequest(BaseModel):
    # 현장 비교(조치 검증) 재분석처럼 특정 site에 속하지 않는 임시 재평가 요청은 site_id 없이 들어온다.
    site_id: str | None = None
    image_s3_key: str
    work_info: str


class RiskItem(BaseModel):
    risk_name: str
    legal_basis: str
    action_required: str


class AnalyzeResponse(BaseModel):
    inspection_id: str
    risk_items: list[RiskItem]
    analyzed_at: datetime


class ErrorResponse(BaseModel):
    error: str
    detail: str


class UploadResponse(BaseModel):
    s3_key: str


class ActionItem(BaseModel):
    risk_name: str
    action_status: str
    action_detail: str | None = None


class ReportRequest(BaseModel):
    site_id: str
    inspection_id: str
    work_info: str
    risk_items: list[RiskItem]
    action_items: list[ActionItem] = []
    target_language: str = "ko"


class ReportResponse(BaseModel):
    report_id: str
    report_s3_key: str
    report_url: str
    generated_at: datetime


class EvidenceRequest(BaseModel):
    query: str
    category: str | None = None  # "law" | "case" | "guide"; None이면 전체 검색


class EvidenceItem(BaseModel):
    title: str
    snippet: str
    source: str
    category: str
    relevance: int  # 0~100, rerank relevanceScore를 백분율로 환산


class EvidenceResponse(BaseModel):
    items: list[EvidenceItem]
