---
name: summon
description: 部下を召喚し、王国に登録する。「召喚」「summon」「部下を呼ぶ」などで発動。
---

# Summon - 召喚コマンド

部下を召喚し、王国に登録するコマンドである。

## 概要

- Queenが部下（Pawn/Knight/Bishop/Rook）を召喚する際の手順
- SubagentStart hookにより自動で仮登録される
- Queenがクエスト完了後に詳細情報を追記する

## 自動登録（Hook）

`on_quest_start.sh` により、召喚時に自動で kingdom.yaml に仮登録される：

```yaml
- agentId: "abc123"
  role: "pawn"
  created_at: "2026-02-04"
  exp: 0
  level: 1
  title: "Recruit"
```

## Queenの手順

1. 部下を召喚（Task tool使用）
2. クエスト完了後、以下の形式で報告：

```
═══════════════════════════════════════════
  SUMMON RECORD
═══════════════════════════════════════════
  AgentId:     [agentId]
  Name:        [名前]
  Role:        ♟/♜/♝/♞ [役職]
  Summoned:    [日付]

  EXP:         [経験値]
  LEVEL:       Lv.[レベル] ([称号])

  FIRST QUEST: [最初のクエスト名]
  VERDICT:     [評価]
═══════════════════════════════════════════
```

**♟/♜/♝/♞ [名前]、王国への入隊を許可されました。**

3. kingdom.yaml に詳細情報を追記：
   - name（命名）
   - aptitudes（適性値）
   - quest_history（クエスト履歴）

## kingdom.yaml 登録例

```yaml
pieces:
  - agentId: ad1f3dc
    name: "Pawn-I"
    role: pawn
    created_at: "2026-02-04"
    exp: 80
    level: 1
    title: "Recruit"
    aptitudes:
      documentation: 0.60
    quest_history:
      - quest: "最初のクエスト名"
        date: "2026-02-04"
        commits: []
        score: 80
        tags: [documentation]
        verdict: "good"
```

## 役職と召喚方法

| 役職 | subagent_type | 用途 |
|------|---------------|------|
| ♟ Pawn | royals:pawn | 基礎的な作業 |
| ♜ Rook | royals:rook | タスク整理・計画 |
| ♝ Bishop | royals:bishop | 監査・検証 |
| ♞ Knight | royals:knight | 創造的発想・探索 |

## 注意事項

- 召喚はQueenのみが行える
- 同じagentIdでresumeすることで、既存の部下に継続指示が可能
- 新規召喚は新しいagentIdが発行される
