# Cloudflare Cache Purge Script for FiveM

このスクリプトはFiveMサーバー用のCloudflareキャッシュパージスクリプトです。QB Coreフレームワークに対応しており、リソース詠み込み時やコマンドの実行でCloudflareのCDNキャッシュをパージします。

謎の需要を満たすために作成されました。

## 機能

- **自動キャッシュパージ**: リソース詠み込み時に自動でキャッシュをパージ
- **手動キャッシュパージ**: 管理者コマンドでキャッシュをパージ
- **プレフィックスパージ**: 特定のURLプレフィックスのみをパージ
- **全体パージ**: 全てのキャッシュをパージ
- **定期パージ**: 指定した間隔で定期的にパージ（オプション）
- **デバッグモード**: 詳細なログ出力

## 必要な権限

Cloudflare APIトークンには以下の権限が必要です：
- **Zone:Cache Purge** - キャッシュパージ権限

## インストール

1. このリポジトリをダウンロードまたはクローン
2. `resources/[standalone]` フォルダに配置

## 設定方法

`config.lua` ファイルを編集して設定を行います：

```lua
Config = {}

Config.Cloudflare = {
    -- Cloudflare API Token (Zone:Cache Purge権限が必要)
    apiToken = "your_cloudflare_api_token_here",
    
    -- Zone ID (Cloudflareダッシュボードで確認可能)
    zoneId = "your_zone_id_here",
    
    -- パージするプレフィックス (空の場合は全てのキャッシュをパージ)
    purgePrefixes = {"example.com/files", "cdn.example.com/assets"},
    
    -- デバッグモード
    debug = false
}
```

### 設定項目の説明

| 項目 | 説明 | 例 |
|------|------|-----|
| `apiToken` | Cloudflare API Token | `"abc123def456..."` |
| `zoneId` | CloudflareのZone ID | `"1234567890abcdef..."` |
| `purgePrefixes` | パージするURLプレフィックス | `{"example.com/files"}` |
| `debug` | デバッグログの表示 | `true` または `false` |

### API Token の取得方法

1. [Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)にアクセス
2. 「Create Token」をクリック
3. 「Custom token」を選択
4. 以下の権限を設定：
   - **Permissions**: Zone:Cache Purge:Edit
   - **Zone Resources**: Include:Specific zone:あなたのドメイン
5. 「Continue to summary」→「Create Token」

### Zone ID の確認方法

1. Cloudflareダッシュボードでドメインを選択
2. 右側のサイドバーに「Zone ID」が表示されます

## 使用方法

### 自動パージ
リソースが詠み込まれると自動的にキャッシュパージが実行されます。

### 手動パージ
以下のコマンドで手動実行できます：

**コンソールから:**
```
purgecache
```

**ゲーム内（管理者のみ）:**
```
/purgecache
```

### エクスポート関数
他のリソースから呼び出すことも可能です：

```lua
-- キャッシュパージを実行
exports['cloudflare-cache-purge']:purgeCache()

-- 定期パージを開始（30分間隔）
exports['cloudflare-cache-purge']:startPeriodicPurge(30)
```

## パージ設定例

### 特定のプレフィックスをパージ
```lua
purgePrefixes = {"example.com/files", "cdn.example.com/images"}
```

### 全てのキャッシュをパージ
```lua
purgePrefixes = {}
```
→ `{"purge_everything": true}` としてAPIに送信

## ログ出力例

### 成功時
```
[Cloudflare Cache Purge] [DEBUG] 指定のプレフィックスをパージします:
[Cloudflare Cache Purge] [DEBUG] - example.com/files
[Cloudflare Cache Purge] [SUCCESS] Cloudflareキャッシュのパージが完了しました
```

### エラー時
```
[Cloudflare Cache Purge] [ERROR] Cloudflare API Tokenが設定されていません
[Cloudflare Cache Purge] [ERROR] Cloudflare APIリクエストが失敗しました (HTTP 403)
```

## トラブルシューティング

### よくある問題

**1. API Token エラー**
- API Tokenが正しく設定されているか確認
- Zone:Cache Purge権限があるか確認

**2. Zone ID エラー**
- Zone IDが正しいか確認
- API Tokenが該当ゾーンにアクセス権限があるか確認

**3. HTTP 403 エラー**
- API Tokenの権限不足
- Zone IDとAPI Tokenの組み合わせが正しくない

**4. キャッシュがパージされない**
- プレフィックスの設定が正しいか確認

## 依存関係

- QB Core Framework
- FiveM Server
