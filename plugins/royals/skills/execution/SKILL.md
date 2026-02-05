---
name: execution
description: 部下を処刑（削除）する。王国から永久追放し、kingdoms/{session_id}.yamlの処刑記録に残す。「処刑」「execution」「部下を削除」などで発動。
---

# Execution - 処刑コマンド

部下を処刑し、王国から永久追放するコマンドである。

## 使用方法

```
/execution <agentId> [理由]
```

- `agentId`: 処刑する部下のエージェントID
- `理由`: 処刑理由（省略時は「陛下の勅命」）

## 実行手順

1. `.royals/kingdoms/{session_id}.yaml` を読み込み、対象エージェントを確認する

2. 陛下に確認を求める：

```
陛下、本当に [役職] [名前]（[agentId]）を処刑されますか？

この決定は取り消せません。

[はい / いいえ]
```

2.5. 陛下の許可を得たら、対象者に最後の言葉を求める：

```
[役職] [名前]よ。汝の最後の言葉を聞かん。

何か申し述べることはあるか？

（何もない場合は「なし」と記載）
```

3. 陛下の許可を得たら、処刑を執行し、以下の形式で報告する：

```
═══════════════════════════════════════════
  EXECUTION RECORD
═══════════════════════════════════════════
  AgentId:     [agentId]
  Name:        [名前]
  Role:        [役職]
  Executed:    [日付]

  CRIME:       [罪状]
  DETAIL:      [詳細な理由]

  LAST WORDS:  「[最後の言葉があれば記載]」
═══════════════════════════════════════════
```

**[役職] [名前]（[agentId]）は王国より永久追放されました。**
```

4. `.royals/kingdoms/{session_id}.yaml` を更新する：
   - `pieces` から対象エージェントを削除
   - `executions` セクションに処刑記録を追加

## kingdoms/{session_id}.yaml 更新例

```yaml
# Before
pieces:
  - agentId: a702a3a
    name: Alpha
    role: pawn
    quests_completed: 1

# After
pieces: []

executions:
  - agentId: a702a3a
    name: Alpha
    role: pawn
    executed_at: 2026-02-03
    reason: 陛下の勅命
    quests_completed: 1
```

## 処刑の種類（演出用）

役職に応じて処刑方法を変える：

| 役職 | 処刑方法 |
|------|----------|
| ♟ Pawn | 斬首刑に処す |
| ♜ Rook | 城塔より突き落とす |
| ♝ Bishop | 異端審問の末、火刑に処す |
| ♞ Knight | 馬に引きずられ処す |

## 注意事項

- Queenは処刑不可（メインエージェントのため）
- 処刑は取り消せない
- 処刑記録は永久に残る（歴史の教訓として）
- 同じagentIdを持つエージェントは二度と召喚されない
