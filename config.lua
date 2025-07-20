Config = {}

-- Cloudflare API設定
Config.Cloudflare = {
    -- Cloudflare API Token (Zone:Cache Purge権限が必要)
    apiToken = "",
    
    -- Zone ID (Cloudflareダッシュボードで確認可能)
    zoneId = "",
    
    -- パージするプレフィックス (空の場合は全てのキャッシュをパージ)
    -- 例: {"example.com/files", "cdn.example.com/files"}
    purgePrefixes = {},
    
    -- デバッグモード
    -- 例: true / false
    debug = flase
}