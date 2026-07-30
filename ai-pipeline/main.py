import uuid
from datetime import datetime

from botocore.exceptions import BotoCoreError, ClientError
from fastapi import Depends, FastAPI, File, UploadFile
from fastapi.responses import JSONResponse

from auth import verify_api_key
from config import S3_BUCKET_NAME, get_s3_client
from graph import build_analysis_graph
from report import generate_report
from schemas import (
    AnalyzeRequest,
    AnalyzeResponse,
    ErrorResponse,
    ReportRequest,
    ReportResponse,
    UploadResponse,
)

app = FastAPI(title="hanium-safety-ai pipeline", dependencies=[Depends(verify_api_key)])
analysis_graph = build_analysis_graph()


@app.post("/upload", response_model=UploadResponse, responses={500: {"model": ErrorResponse}})
def upload(file: UploadFile = File(...)):
    extension = file.filename.rsplit(".", 1)[-1] if "." in file.filename else "jpg"
    s3_key = f"site-photos/{uuid.uuid4()}.{extension}"
    try:
        get_s3_client().upload_fileobj(file.file, S3_BUCKET_NAME, s3_key)
    except (ClientError, BotoCoreError) as exc:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(error="AWSServiceError", detail=str(exc)).model_dump(),
        )
    return UploadResponse(s3_key=s3_key)


@app.post("/analyze", response_model=AnalyzeResponse, responses={500: {"model": ErrorResponse}})
def analyze(request: AnalyzeRequest):
    try:
        result = analysis_graph.invoke(
            {
                "site_id": request.site_id,
                "image_s3_key": request.image_s3_key,
                "work_info": request.work_info,
            }
        )
    except (ClientError, BotoCoreError) as exc:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(error="AWSServiceError", detail=str(exc)).model_dump(),
        )
    except Exception as exc:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(error=type(exc).__name__, detail=str(exc)).model_dump(),
        )

    return AnalyzeResponse(
        inspection_id=str(uuid.uuid4()),
        risk_items=result["risk_items"],
        analyzed_at=datetime.now(),
    )


@app.post("/report", response_model=ReportResponse, responses={500: {"model": ErrorResponse}})
def report(request: ReportRequest):
    try:
        result = generate_report(request)
    except (ClientError, BotoCoreError) as exc:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(error="AWSServiceError", detail=str(exc)).model_dump(),
        )
    except Exception as exc:
        return JSONResponse(
            status_code=500,
            content=ErrorResponse(error=type(exc).__name__, detail=str(exc)).model_dump(),
        )

    return ReportResponse(**result)
