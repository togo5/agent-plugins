#!/bin/bash
set -euo pipefail

PROJECT_ID="${1:-}"
DOC_PATH="${2:-}"
DB_ID="${3:-(default)}"

if [ -z "${PROJECT_ID}" ]; then
  PROJECT_ID=$(gcloud config get-value project 2>/dev/null || true)
fi

if [ -z "${PROJECT_ID}" ]; then
  echo "Usage: firestore_collections.sh <project_id> [document_path] [database_id]" >&2
  echo "" >&2
  echo "  project_id     GCP project ID (omit to use gcloud config)" >&2
  echo "  document_path  Parent document path (omit for root collections)" >&2
  echo "                 e.g. users/abc123, shops/tokyo" >&2
  echo "  database_id    Firestore database ID (default: (default))" >&2
  exit 1
fi

TOKEN=$(gcloud auth print-access-token 2>/dev/null) || {
  echo "Error: gcloud auth failed. Run 'gcloud auth login' first." >&2
  exit 1
}

BASE="https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/${DB_ID}/documents"

if [ -n "${DOC_PATH}" ]; then
  URL="${BASE}/${DOC_PATH}:listCollectionIds"
else
  URL="${BASE}:listCollectionIds"
fi

curl -s -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{}' \
  "${URL}" | jq '{
  collectionIds: (.collectionIds // [])
}'
