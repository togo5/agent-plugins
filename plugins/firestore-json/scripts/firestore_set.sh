#!/bin/bash
set -euo pipefail

PROJECT_ID="${1:-}"
DOC_PATH="${2:-}"
JSON_DATA="${3:-}"
DB_ID="${4:-(default)}"

if [ -z "${PROJECT_ID}" ]; then
  PROJECT_ID=$(gcloud config get-value project 2>/dev/null || true)
fi

if [ -z "${PROJECT_ID}" ] || [ -z "${DOC_PATH}" ]; then
  echo "Usage: firestore_set.sh <project_id> <document_path> '<json_data>' [database_id]" >&2
  echo "       echo '{...}' | firestore_set.sh <project_id> <document_path> '' [database_id]" >&2
  echo "" >&2
  echo "  project_id     GCP project ID (omit to use gcloud config)" >&2
  echo "  document_path  e.g. users/abc123" >&2
  echo "  json_data      JSON object to write (or pass via stdin)" >&2
  echo "  database_id    Firestore database ID (default: (default))" >&2
  exit 1
fi

if [ -z "${JSON_DATA}" ]; then
  if [ -t 0 ]; then
    echo "Error: No JSON data. Pass as 3rd argument or pipe via stdin." >&2
    exit 1
  fi
  JSON_DATA=$(cat)
fi

TOKEN=$(gcloud auth print-access-token 2>/dev/null) || {
  echo "Error: gcloud auth failed. Run 'gcloud auth login' first." >&2
  exit 1
}

URL="https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/${DB_ID}/documents/${DOC_PATH}"

FIRESTORE_DATA=$(echo "${JSON_DATA}" | jq '
def encode:
  if type == "string" then {"stringValue": .}
  elif type == "number" then
    if . == (. | floor) then {"integerValue": (. | tostring)}
    else {"doubleValue": .}
    end
  elif type == "boolean" then {"booleanValue": .}
  elif . == null then {"nullValue": null}
  elif type == "array" then {"arrayValue": {"values": [.[] | encode]}}
  elif type == "object" then {"mapValue": {"fields": (with_entries(.value |= encode))}}
  else .
  end;

{"fields": (with_entries(.value |= encode))}
')

curl -s -X PATCH \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "${FIRESTORE_DATA}" \
  "${URL}" | jq '
def decode:
  if has("stringValue") then .stringValue
  elif has("integerValue") then (.integerValue | tonumber)
  elif has("doubleValue") then .doubleValue
  elif has("booleanValue") then .booleanValue
  elif has("nullValue") then null
  elif has("timestampValue") then .timestampValue
  elif has("geoPointValue") then .geoPointValue
  elif has("referenceValue") then .referenceValue
  elif has("bytesValue") then .bytesValue
  elif has("arrayValue") then [(.arrayValue.values // [])[] | decode]
  elif has("mapValue") then ((.mapValue.fields // {}) | with_entries(.value |= decode))
  else .
  end;

if .fields then
  .fields | with_entries(.value |= decode)
elif .error then
  .
else
  .
end
'
