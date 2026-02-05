# Royals

## 概要

チェスをモチーフにしたClaude Codeマルチエージェント管理プラグイン。
Queen（メインClaude）が部下（Pawn/Rook/Bishop/Knight）を召喚・統括し、タスクを並列処理する。

## 必須要件

- Claude Code CLI
- yq (YAML処理)
- jq (JSON処理)

## インストール

1. `plugins/royals/` をClaude Codeのプラグインディレクトリに配置
2. スクリプトに実行権限を付与:
   ```bash
   chmod +x plugins/royals/scripts/*.sh
   chmod +x plugins/royals/hooks/*.sh
   ```

## クイックスタート

1. `/crown` を実行してQueenとして覚醒
2. 陛下（あなた）が勅命を出す
3. Queenが適切な部下を召喚・統括

## コマンド一覧

| コマンド | 説明 |
|----------|------|
| `/crown` | 王国を開始（Queenとして覚醒） |
| `/summon` | 部下を召喚 |
| `/kingdom` | 王国状況を確認 |
| `/execution` | 部下を処刑 |

## 駒の役割

| 駒 | 役割 | 担当 |
|----|------|------|
| ♛ Queen | 統括者 | メインClaude（自動） |
| ♜ Rook | タスク整理・計画・進捗管理 | サブエージェント |
| ♝ Bishop | 監査・検証・レビュー | サブエージェント |
| ♞ Knight | 創造的発想・探索・アイデア出し | サブエージェント |
| ♟ Pawn | 基礎的な調査・実装作業 | サブエージェント |

## ディレクトリ構成

```
plugins/royals/
├── agents/      # エージェント定義
├── skills/      # スキル定義（/crown, /summon等）
├── templates/   # テンプレートファイル
├── schemas/     # JSON Schema定義
├── hooks/       # フック（自動処理）
└── scripts/     # ユーティリティスクリプト
```

## 褒美システム

部下は経験値（EXP）を獲得し、レベルアップする。

| レベル | 必要EXP | 称号 |
|--------|---------|------|
| Lv.1 | 0 | Recruit |
| Lv.2 | 200 | Apprentice |
| Lv.3 | 500 | Journeyman |
| Lv.4 | 1,000 | Veteran |
| Lv.5 | 2,000 | Master |
| Lv.6 | 5,000 | Grand Master |

## 状態管理

王国の状態は `.royals/kingdoms/{session_id}.yaml` で管理される。
セッションごとに独立した王国ファイルが作成され、部下の情報・クエスト履歴・処刑記録が保存される。
