import os

import boto3
from botocore.config import Config
from dotenv import load_dotenv

load_dotenv()

AWS_REGION = os.environ.get("AWS_REGION", "ap-northeast-2")
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
INTERNAL_API_KEY = os.environ.get("INTERNAL_API_KEY")
BEDROCK_MODEL_ID = os.environ.get("BEDROCK_MODEL_ID", "anthropic.claude-3-5-sonnet-20241022-v2:0")
KNOWLEDGE_BASE_ID = os.environ.get("KNOWLEDGE_BASE_ID")
RERANK_MODEL_ARN = os.environ.get(
    "RERANK_MODEL_ARN",
    f"arn:aws:bedrock:{AWS_REGION}::foundation-model/cohere.rerank-v3-5:0",
)

# Bedrock 호출은 응답이 느릴 수 있어 read_timeout을 넉넉히 잡고, 일시적 오류(스로틀링 등)는 표준 재시도로 흡수한다.
BEDROCK_CLIENT_CONFIG = Config(
    connect_timeout=5,
    read_timeout=60,
    retries={"max_attempts": 3, "mode": "standard"},
)


def get_s3_client():
    return boto3.client("s3", region_name=AWS_REGION)


def get_bedrock_runtime_client():
    return boto3.client("bedrock-runtime", region_name=AWS_REGION, config=BEDROCK_CLIENT_CONFIG)


def get_bedrock_agent_runtime_client():
    return boto3.client(
        "bedrock-agent-runtime", region_name=AWS_REGION, config=BEDROCK_CLIENT_CONFIG
    )


def get_translate_client():
    return boto3.client("translate", region_name=AWS_REGION)
