---
name: firestore-get
description: Firestoreのドキュメントを取得してJSON形式で返す。「Firestoreから取得」「ドキュメントを読む」「firestore get」などで発動。
---

# firestore-get

Firestoreドキュメントを取得し、通常のJSON形式で出力する。
Firestoreの型付きレスポンス（stringValue, integerValue等）は自動的にフラットなJSONに変換される。

## 必要な情報

ユーザーから以下を確認する（不明な場合のみ聞く）：

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| ドキュメントパス | ○ | - | users/abc123, shops/tokyo/items/item001 |
| データベースID | × | (default) | my-database |

## 実行

```bash
bash plugins/firestore-json/scripts/firestore_get.sh <project_id> <document_path> [database_id]
```

プロジェクトIDを省略して gcloud config のデフォルトを使う場合：
```bash
bash plugins/firestore-json/scripts/firestore_get.sh "" <document_path>
```

## 出力例

```json
{
  "name": "太郎",
  "age": 25,
  "active": true,
  "tags": ["admin", "user"],
  "address": {
    "city": "東京",
    "zip": "100-0001"
  }
}
```

## エラー時

- gcloud認証エラー → `gcloud auth login` を案内
- ドキュメントが見つからない → パスの確認を促す
- APIエラー → レスポンスのerrorオブジェクトがそのまま出力される
