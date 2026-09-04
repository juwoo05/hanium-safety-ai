import os

import boto3
from botocore.config import Config
from dotenv import load_dotenv

load_dotenv()

AWS_REGION = os.environ.get("AWS_REGION", "ap-northeast-2")
AWS_PROFILE = os.environ.get("AWS_PROFILE")
AWS_ACCESS_KEY_ID = os.environ.get("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.environ.get("AWS_SECRET_ACCESS_KEY")
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
INTERNAL_API_KEY = os.environ.get("INTERNAL_API_KEY")
# claude-3-5-sonnet-20241022-v2:0 등 최신 모델은 이 계정/리전에서 INFERENCE_PROFILE 방식만 지원해
# on-demand invoke가 막혀 있다. on-demand로 바로 호출 가능한 버전을 기본값으로 사용한다.
BEDROCK_MODEL_ID = os.environ.get("BEDROCK_MODEL_ID", "anthropic.claude-3-5-sonnet-20240620-v1:0")
KNOWLEDGE_BASE_ID = os.environ.get("KNOWLEDGE_BASE_ID")
# Bedrock Knowledge Base가 물려있던 OpenSearch Serverless(AOSS) 컬렉션이 삭제되어(비용 문제)
# KB 자체가 무용지물이 됐다. EC2에 Docker로 직접 띄운 OpenSearch를 대신 사용한다.
# scripts/ingest_opensearch.py가 이 인덱스에 문서를 색인한다.
OPENSEARCH_HOST = os.environ.get("OPENSEARCH_HOST")
OPENSEARCH_PORT = int(os.environ.get("OPENSEARCH_PORT", "9200"))
OPENSEARCH_USER = os.environ.get("OPENSEARCH_USER", "admin")
OPENSEARCH_PASSWORD = os.environ.get("OPENSEARCH_PASSWORD")
OPENSEARCH_INDEX = os.environ.get("OPENSEARCH_INDEX", "safety-index")
EMBED_MODEL_ID = os.environ.get("EMBED_MODEL_ID", "amazon.titan-embed-text-v2:0")
EMBED_DIMENSION = int(os.environ.get("EMBED_DIMENSION", "1024"))
# Cohere Rerank 3.5는 AWS_REGION(ap-northeast-2)에서 제공되지 않아 별도 리전을 사용한다.
# rerank는 이미 검색된 텍스트(INLINE 소스)만 넘겨 재순위화하므로 KB/S3와 리전이 달라도 무방하다.
RERANK_REGION = os.environ.get("RERANK_REGION", "ap-northeast-1")
RERANK_MODEL_ARN = os.environ.get(
    "RERANK_MODEL_ARN",
    f"arn:aws:bedrock:{RERANK_REGION}::foundation-model/cohere.rerank-v3-5:0",
)

# Bedrock 호출은 응답이 느릴 수 있어 read_timeout을 넉넉히 잡고, 일시적 오류(스로틀링 등)는 표준 재시도로 흡수한다.
BEDROCK_CLIENT_CONFIG = Config(
    connect_timeout=5,
    read_timeout=60,
    retries={"max_attempts": 3, "mode": "standard"},
)

# .env에 액세스 키가 있으면 그걸 우선 쓴다 - 팀원마다 로컬에 `aws configure --profile ...`를
# 따로 해야 하는 걸 피하기 위함이다. 없을 때만 AWS_PROFILE로 폴백하고, 그마저 없으면
# boto3 기본 자격증명 체인(예: 배포 환경의 IAM 역할)을 따른다.
if AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY:
    _session = boto3.Session(
        aws_access_key_id=AWS_ACCESS_KEY_ID,
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    )
elif AWS_PROFILE:
    _session = boto3.Session(profile_name=AWS_PROFILE)
else:
    _session = boto3.Session()


def get_s3_client():
    return _session.client("s3", region_name=AWS_REGION)


def get_bedrock_runtime_client():
    return _session.client("bedrock-runtime", region_name=AWS_REGION, config=BEDROCK_CLIENT_CONFIG)


def get_bedrock_agent_runtime_client():
    return _session.client(
        "bedrock-agent-runtime", region_name=AWS_REGION, config=BEDROCK_CLIENT_CONFIG
    )


def get_rerank_client():
    return _session.client(
        "bedrock-agent-runtime", region_name=RERANK_REGION, config=BEDROCK_CLIENT_CONFIG
    )


def get_translate_client():
    return _session.client("translate", region_name=AWS_REGION)


def get_opensearch_client():
    from opensearchpy import OpenSearch

    return OpenSearch(
        hosts=[{"host": OPENSEARCH_HOST, "port": OPENSEARCH_PORT}],
        http_auth=(OPENSEARCH_USER, OPENSEARCH_PASSWORD),
        use_ssl=True,
        verify_certs=False,
        ssl_show_warn=False,
        timeout=10,
    )
