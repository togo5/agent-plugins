---
name: firestore-subcollections
description: ドキュメント配下のサブコレクション一覧、またはルートコレクション一覧を返す。「サブコレクション一覧」「コレクション一覧」「firestore subcollections」などで発動。
---

# firestore-subcollections

指定ドキュメント配下のサブコレクションID一覧を取得する。
ドキュメントパスを省略するとルートレベルのコレクション一覧を返す。

## 必要な情報

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| ドキュメントパス | × | (ルート) | users/abc123, shops/tokyo |
| データベースID | × | (default) | my-database |

## 実行

サブコレクション一覧（特定ドキュメント配下）：
```bash
bash plugins/firestore-json/scripts/firestore_subcollections.sh <project_id> <document_path> [database_id]
```

ルートコレクション一覧：
```bash
bash plugins/firestore-json/scripts/firestore_subcollections.sh <project_id>
```

プロジェクトIDを省略する場合：
```bash
bash plugins/firestore-json/scripts/firestore_subcollections.sh "" users/abc123
```

## 出力例

```json
{
  "collectionIds": ["orders", "favorites", "settings"]
}
```

## ユースケース

- `users/abc123` のサブコレクションを確認 → orders, favorites 等
- ルートのコレクション構造を把握 → users, shops, configs 等
- データ構造の探索に便利
