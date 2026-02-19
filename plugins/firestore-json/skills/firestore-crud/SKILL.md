---
name: firestore-crud
description: Firestoreをcurl + gcloud認証で操作する。ドキュメントの取得・書き込み・一覧・サブコレクション一覧をJSON形式で扱う。「Firestoreから取得」「ドキュメントを読む」「Firestoreに書き込み」「ドキュメントを更新」「ドキュメント一覧」「コレクションの中身」「サブコレクション一覧」「コレクション一覧」「firestore get/set/docs/subcollections」などで発動。
---

# firestore

Firestoreをcurl + gcloud認証で操作するスキル。
ユーザーの意図に応じて **get / set / docs / subcollections** の4操作を1つのskillで処理する。

## 操作の判断

まずユーザーの意図を確認して、以下のいずれかの操作を実行する。

| 操作 | 意図の例 |
|------|---------|
| **get** | ドキュメントを取得したい、読みたい |
| **set** | ドキュメントに書き込みたい、更新したい |
| **docs** | コレクション内のドキュメントID一覧が欲しい |
| **subcollections** | サブコレクション一覧、またはルートコレクション一覧が欲しい |

---

## get — ドキュメント取得

Firestoreドキュメントを取得し、通常のJSON形式で出力する。
Firestoreの型付きレスポンス（stringValue, integerValue等）は自動的にフラットなJSONに変換される。

### パラメータ

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| ドキュメントパス | ○ | - | users/abc123, shops/tokyo/items/item001 |
| データベースID | × | (default) | my-database |

### 実行

```bash
bash plugins/firestore-json/scripts/firestore_get.sh <project_id> <document_path> [database_id]
```

プロジェクトIDを省略する場合：
```bash
bash plugins/firestore-json/scripts/firestore_get.sh "" <document_path>
```

### 出力例

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

---

## set — ドキュメント書き込み

JSONデータをFirestoreドキュメントに書き込む。
ドキュメントが存在しない場合は新規作成、存在する場合は全フィールドを上書きする。

### パラメータ

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| ドキュメントパス | ○ | - | users/abc123 |
| 書き込むJSONデータ | ○ | - | {"name": "太郎", "age": 25} |
| データベースID | × | (default) | my-database |

### 実行

引数で渡す：
```bash
bash plugins/firestore-json/scripts/firestore_set.sh <project_id> <document_path> '<json_data>' [database_id]
```

stdinで渡す：
```bash
echo '{"name": "太郎", "age": 25}' | bash plugins/firestore-json/scripts/firestore_set.sh <project_id> <document_path> '' [database_id]
```

プロジェクトIDを省略する場合：
```bash
bash plugins/firestore-json/scripts/firestore_set.sh "" users/abc123 '{"name": "太郎"}'
```

### 型変換ルール

| JSON型 | Firestore型 |
|--------|------------|
| string | stringValue |
| number (整数) | integerValue |
| number (小数) | doubleValue |
| boolean | booleanValue |
| null | nullValue |
| array | arrayValue |
| object | mapValue |

### 注意

- **全フィールドを上書きする**（部分更新ではない）
- 既存フィールドを残したい場合は、先に get で取得してからマージする

---

## docs — ドキュメントID一覧

Firestoreコレクション配下のドキュメントID一覧を取得する。

### パラメータ

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| コレクションパス | ○ | - | users, shops/tokyo/items |
| データベースID | × | (default) | my-database |
| ページサイズ | × | 100 | 50 |

### 実行

```bash
bash plugins/firestore-json/scripts/firestore_docs.sh <project_id> <collection_path> [database_id] [page_size]
```

プロジェクトIDを省略する場合：
```bash
bash plugins/firestore-json/scripts/firestore_docs.sh "" users
```

### 出力例

```json
{
  "documents": ["abc123", "def456", "ghi789"],
  "nextPageToken": null
}
```

nextPageTokenがnull以外の場合、次ページがある。

### ページネーション

100件以上のドキュメントがある場合、nextPageTokenが返される。
次ページの取得は現状手動でcurlする必要がある。

---

## subcollections — サブコレクション一覧

指定ドキュメント配下のサブコレクションID一覧を取得する。
ドキュメントパスを省略するとルートレベルのコレクション一覧を返す。

### パラメータ

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| ドキュメントパス | × | (ルート) | users/abc123, shops/tokyo |
| データベースID | × | (default) | my-database |

### 実行

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

### 出力例

```json
{
  "collectionIds": ["orders", "favorites", "settings"]
}
```

---

## 共通エラー対応

- gcloud認証エラー → `gcloud auth login` を案内
- ドキュメントが見つからない → パスの確認を促す
- APIエラー → レスポンスのerrorオブジェクトがそのまま出力される
