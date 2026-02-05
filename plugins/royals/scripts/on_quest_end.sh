#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"
transcript_path="$(printf '%s' "$payload" | jq -r '.transcript_path // empty')"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // "."')"
session_id="$(printf '%s' "$payload" | jq -r '.session_id // empty' | cut -c1-8)"

[[ -z "$transcript_path" ]] && exit 0
[[ -z "$session_id" ]] && exit 0
transcript_path="${transcript_path/#\~/$HOME}"
[[ ! -f "$transcript_path" ]] && exit 0

# kingdoms/{session_id}.yaml を探す
kingdom_path=""
search_dir="$cwd"
while [[ "$search_dir" != "/" ]]; do
  if [[ -f "$search_dir/.royals/kingdoms/${session_id}.yaml" ]]; then
    kingdom_path="$search_dir/.royals/kingdoms/${session_id}.yaml"
    break
  fi
  search_dir="$(dirname "$search_dir")"
done

[[ -z "$kingdom_path" || ! -f "$kingdom_path" ]] && exit 0

# 最新のトークン情報を取得
token_info=$(tail -100 "$transcript_path" | jq -s '
  [.[] | select(.toolUseResult?.agentId? and .toolUseResult?.totalTokens?)]
  | last // empty
  | {agentId: .toolUseResult.agentId, totalTokens: .toolUseResult.totalTokens}
' 2>/dev/null || echo "")

[[ -z "$token_info" || "$token_info" == "null" ]] && exit 0

agent_id=$(echo "$token_info" | jq -r '.agentId // empty')
tokens=$(echo "$token_info" | jq -r '.totalTokens // 0')

[[ -z "$agent_id" ]] && exit 0

# yq で更新（該当agentIdが存在する場合のみ）
yq -i "
  (.pieces[] | select(.agentId == \"$agent_id\")) |=
  (
    .total_tokens_used = ((.total_tokens_used // 0) + $tokens) |
    .last_tokens = $tokens |
    .last_token_update = \"$(date +%Y-%m-%dT%H:%M:%S)\"
  )
" "$kingdom_path" 2>/dev/null || true
