---
name: firestore-docs
description: Firestoreコレクション配下のドキュメントID一覧を返す。「ドキュメント一覧」「コレクションの中身」「firestore docs」などで発動。
---

# firestore-docs

Firestoreコレクション配下のドキュメントID一覧を取得する。

## 必要な情報

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| コレクションパス | ○ | - | users, shops/tokyo/items |
| データベースID | × | (default) | my-database |
| ページサイズ | × | 100 | 50 |

## 実行

```bash
bash plugins/firestore-json/scripts/firestore_docs.sh <project_id> <collection_path> [database_id] [page_size]
```

プロジェクトIDを省略する場合：
```bash
bash plugins/firestore-json/scripts/firestore_docs.sh "" users
```

サブコレクションの場合：
```bash
bash plugins/firestore-json/scripts/firestore_docs.sh my-project shops/tokyo/items
```

## 出力例

```json
{
  "documents": ["abc123", "def456", "ghi789"],
  "nextPageToken": null
}
```

nextPageTokenがnull以外の場合、次ページがある。

## ページネーション

100件以上のドキュメントがある場合、nextPageTokenが返される。
次ページの取得は現状手動でcurlする必要がある（将来対応予定）。
