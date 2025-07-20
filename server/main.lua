-- QB Core Framework
local QBCore = exports['qb-core']:GetCoreObject()

-- リソース開始時にキャッシュパージを実行
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('^2[Cloudflare Cache Purge]^7 リソースが読み込まれました')
        
        if Config.Cloudflare.debug then
            print('^3[Cloudflare Cache Purge] [DEBUG]^7 Cloudflareキャッシュパージを開始します...')
        end
        
        -- 少し遅延を入れてからパージを実行
        SetTimeout(2000, function()
            TriggerEvent('cloudflare:purgeCache')
        end)
    end
end)

-- キャッシュパージイベント
RegisterNetEvent('cloudflare:purgeCache', function()
    PurgeCloudflareCache()
end)

-- 管理者コマンド（手動でキャッシュパージを実行）
QBCore.Commands.Add('purgecache', 'Cloudflareキャッシュをパージします', {}, false, function(source, args)
    -- コンソールからの実行をチェック
    if source == 0 then
        print('^2[Cloudflare Cache Purge]^7 コンソールからキャッシュパージを実行します')
        TriggerEvent('cloudflare:purgeCache')
        return
    end
    
    local Player = QBCore.Functions.GetPlayer(source)
    
    -- プレイヤーが存在しない場合の処理
    if not Player then
        print('^1[Cloudflare Cache Purge] [ERROR]^7 プレイヤーデータが見つかりません (ID: ' .. source .. ')')
        return
    end
    
    -- 権限チェック
    if (Player.PlayerData.job and Player.PlayerData.job.name == 'admin') or IsPlayerAceAllowed(source, 'command.purgecache') then
        TriggerEvent('cloudflare:purgeCache')
        TriggerClientEvent('QBCore:Notify', source, 'Cloudflareキャッシュパージを開始しました', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, '権限がありません', 'error')
    end
end, 'admin')