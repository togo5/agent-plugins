---
name: firestore-set
description: JSON(object)データをFirestoreドキュメントに書き込む。「Firestoreに書き込み」「ドキュメントを更新」「firestore set」などで発動。
---

# firestore-set

JSONデータをFirestoreドキュメントに書き込む。
ドキュメントが存在しない場合は新規作成、存在する場合は全フィールドを上書きする。

## 必要な情報

| パラメータ | 必須 | デフォルト | 例 |
|-----------|------|-----------|-----|
| GCPプロジェクトID | △ | `gcloud config get-value project` | my-project-123 |
| ドキュメントパス | ○ | - | users/abc123 |
| 書き込むJSONデータ | ○ | - | {"name": "太郎", "age": 25} |
| データベースID | × | (default) | my-database |

## 実行

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

## 型変換ルール

JSONからFirestoreへの変換：

| JSON型 | Firestore型 |
|--------|------------|
| string | stringValue |
| number (整数) | integerValue |
| number (小数) | doubleValue |
| boolean | booleanValue |
| null | nullValue |
| array | arrayValue |
| object | mapValue |

## 出力

書き込み成功時、保存されたデータがJSON形式で返される。

## 注意

- **全フィールドを上書きする**（部分更新ではない）
- 既存フィールドを残したい場合は、先に firestore-get で取得してからマージする
