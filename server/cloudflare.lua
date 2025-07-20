-- Cloudflare API関数
function PurgeCloudflareCache()
    if not Config.Cloudflare.apiToken or Config.Cloudflare.apiToken == "your_cloudflare_api_token_here" then
        print('^1[Cloudflare Cache Purge] [ERROR]^7 Cloudflare API Tokenが設定されていません')
        return
    end
    
    if not Config.Cloudflare.zoneId or Config.Cloudflare.zoneId == "your_zone_id_here" then
        print('^1[Cloudflare Cache Purge] [ERROR]^7 Cloudflare Zone IDが設定されていません')
        return
    end
    
    if Config.Cloudflare.debug then
        print('^3[Cloudflare Cache Purge] [DEBUG]^7 API Token: ' .. string.sub(Config.Cloudflare.apiToken, 1, 10) .. '...')
        print('^3[Cloudflare Cache Purge] [DEBUG]^7 Zone ID: ' .. Config.Cloudflare.zoneId)
    end
    
    local apiUrl = string.format('https://api.cloudflare.com/client/v4/zones/%s/purge_cache', Config.Cloudflare.zoneId)
    local headers = {
        ['Authorization'] = 'Bearer ' .. Config.Cloudflare.apiToken,
        ['Content-Type'] = 'application/json'
    }
    
    local data = {}
    
    -- プレフィックスでパージするか、全てをパージするか
    if Config.Cloudflare.purgePrefixes and #Config.Cloudflare.purgePrefixes > 0 then
        data.prefixes = Config.Cloudflare.purgePrefixes
        
        if Config.Cloudflare.debug then
            print('^3[Cloudflare Cache Purge] [DEBUG]^7 指定のプレフィックスをパージします:')
            for i, prefix in ipairs(data.prefixes) do
                print('^3[Cloudflare Cache Purge] [DEBUG]^7 - ' .. prefix)
            end
        end
    else
        data.purge_everything = true
        if Config.Cloudflare.debug then
            print('^3[Cloudflare Cache Purge] [DEBUG]^7 全てのキャッシュをパージします')
        end
    end
    
    -- HTTP リクエストを送信
    PerformHttpRequest(apiUrl, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local response = json.decode(resultData)
            if response and response.success then
                print('^2[Cloudflare Cache Purge] [SUCCESS]^7 Cloudflareキャッシュのパージが完了しました')
                if Config.Cloudflare.debug then
                    print('^3[Cloudflare Cache Purge] [DEBUG]^7 Response: ' .. resultData)
                end
            else
                print('^1[Cloudflare Cache Purge] [ERROR]^7 Cloudflare APIからエラーレスポンスを受信しました')
                if response and response.errors then
                    for i, error in ipairs(response.errors) do
                        print('^1[Cloudflare Cache Purge] [ERROR]^7 - ' .. error.message)
                    end
                end
            end
        else
            print('^1[Cloudflare Cache Purge] [ERROR]^7 Cloudflare APIリクエストが失敗しました (HTTP ' .. errorCode .. ')')
            if Config.Cloudflare.debug then
                print('^3[Cloudflare Cache Purge] [DEBUG]^7 Response: ' .. resultData)
            end
        end
    end, 'POST', json.encode(data), headers)
end

-- 定期的なキャッシュパージ（オプション）
function StartPeriodicCachePurge(intervalMinutes)
    if intervalMinutes and intervalMinutes > 0 then
        local intervalMs = intervalMinutes * 60 * 1000
        SetTimeout(intervalMs, function()
            if Config.Cloudflare.debug then
                print('^3[Cloudflare Cache Purge] [DEBUG]^7 定期キャッシュパージを実行します')
            end
            TriggerEvent('cloudflare:purgeCache')
            StartPeriodicCachePurge(intervalMinutes)
        end)
    end
end

-- エクスポート関数
exports('purgeCache', function()
    PurgeCloudflareCache()
end)

exports('startPeriodicPurge', function(intervalMinutes)
    StartPeriodicCachePurge(intervalMinutes)
end)