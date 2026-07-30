from datetime import datetime

from pydantic import BaseModel


class AnalyzeRequest(BaseModel):
    site_id: str
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
