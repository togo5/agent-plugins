#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"
session_id="$(printf '%s' "$payload" | jq -r '.session_id // empty' | cut -c1-8)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // "."')"
agent_id="$(printf '%s' "$payload" | jq -r '.agent_id // empty')"
agent_type="$(printf '%s' "$payload" | jq -r '.agent_type // empty')"

# 必須フィールドをチェック
[[ -z "$session_id" ]] && exit 0
[[ -z "$agent_id" ]] && exit 0
[[ -z "$agent_type" ]] && exit 0

# Royalsのエージェントのみ対象
[[ ! "$agent_type" =~ ^royals: ]] && exit 0

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

# kingdom.yamlが存在しない場合は何もしない
[[ -z "$kingdom_path" || ! -f "$kingdom_path" ]] && exit 0

# agent_idから "agent-" プレフィックスを除去
clean_agent_id="${agent_id#agent-}"

# agent_typeから役職を判定
role="${agent_type#royals:}"

# 該当agentIdが既に存在するかチェック
existing=$(yq ".pieces[] | select(.agentId == \"$clean_agent_id\") | .agentId" "$kingdom_path" 2>/dev/null || echo "")

# 既に存在する場合は何もしない
[[ -n "$existing" ]] && exit 0

# yqで仮登録を実行
yq -i "
  .pieces += [
    {
      \"agentId\": \"$clean_agent_id\",
      \"role\": \"$role\",
      \"created_at\": \"$(date +%Y-%m-%d)\",
      \"exp\": 0,
      \"level\": 1,
      \"title\": \"Recruit\"
    }
  ]
" "$kingdom_path" 2>/dev/null || true

exit 0
