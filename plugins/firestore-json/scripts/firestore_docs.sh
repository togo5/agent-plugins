#!/bin/bash
set -euo pipefail

PROJECT_ID="${1:-}"
COLLECTION_PATH="${2:-}"
DB_ID="${3:-(default)}"
PAGE_SIZE="${4:-100}"

if [ -z "${PROJECT_ID}" ]; then
  PROJECT_ID=$(gcloud config get-value project 2>/dev/null || true)
fi

if [ -z "${PROJECT_ID}" ] || [ -z "${COLLECTION_PATH}" ]; then
  echo "Usage: firestore_list.sh <project_id> <collection_path> [database_id] [page_size]" >&2
  echo "" >&2
  echo "  project_id       GCP project ID (omit to use gcloud config)" >&2
  echo "  collection_path  e.g. users, shops/tokyo/items" >&2
  echo "  database_id      Firestore database ID (default: (default))" >&2
  echo "  page_size        Number of documents per page (default: 100)" >&2
  exit 1
fi

TOKEN=$(gcloud auth print-access-token 2>/dev/null) || {
  echo "Error: gcloud auth failed. Run 'gcloud auth login' first." >&2
  exit 1
}

URL="https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/${DB_ID}/documents/${COLLECTION_PATH}?pageSize=${PAGE_SIZE}"

curl -s -H "Authorization: Bearer ${TOKEN}" "${URL}" | jq '{
  documents: [.documents[]? | (.name | split("/") | last)],
  nextPageToken: (.nextPageToken // null)
}'
