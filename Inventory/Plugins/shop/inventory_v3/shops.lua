if Config.Shops then 
    function OpenShop(title, items, account, jobs, grades, license)
        if license then 
            ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
                if hasLicense then
                    OpenInventory({type = 'shop', id = 'shop', title = title, account = account, shopItems = items, timeout = Config.ShopDelay, weight = false})
                else 
                    TriggerEvent('inventory:notify', "error", "You lack the license to access this container")
                end
            end, GetPlayerServerId(PlayerId()), license)
            return
        end

        if not jobs then 
            OpenInventory({type = 'shop', id = 'shop', title = title, account = account, shopItems = items, timeout = Config.ShopDelay, weight = false})
            return
        end       

        if shop_job_contains(jobs.jobs, ESX.PlayerData.job.name) then 
            if grades then 
                if shop_grade_contains(jobs.jobs, ESX.PlayerData.job.grade) then 
                    canSee = true
                    OpenInventory({type = 'shop', id = 'shop', title = title, account = account, shopItems = items, timeout = Config.ShopDelay, weight = false})
                else
                    TriggerEvent('inventory:notify', "error", "You can't access this shop")
                end
            else 
                canSee = true
                OpenInventory({type = 'shop', id = 'shop', title = title, account = account, shopItems = items, timeout = Config.ShopDelay, weight = false})
            end
        else
            TriggerEvent('inventory:notify', "error", "You can't access this shop")
        end
    end

    RegisterNetEvent('inventory:openShop', function (title, items, account, jobs, grades, license)
        OpenShop(title, items, account, jobs, grades, license)
    end)

    if Config.ShopsBuiltIn then 
        local isPedLoaded, isNearShop = false, false
        local npc, currentShop = nil, nil
        local shopTextUIOpen, hadSpeak = false, false
        local Blips = {}

        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded', function(xPlayer, isNew)
            ESX.PlayerData = xPlayer
            resetShopBlips()
        end)

        RegisterNetEvent('esx:playerLogout') 
        AddEventHandler('esx:playerLogout', function(xPlayer, isNew)
            resetShopBlips()
        end)
        
        RegisterNetEvent('esx:setJob')
        AddEventHandler('esx:setJob', function(job)
            ESX.PlayerData.job = job
            resetShopBlips()
        end)

        CreateThread(function ()
            while true do
                local sleep = 200
                isNearShop = false

                for k, shops in pairs(Config.ShopLocations) do 
                    for k2, location in pairs(shops.locations) do 
                        if not shops.jobs.enable or ESX.PlayerData.job and shop_job_contains(shops.jobs.jobs, ESX.PlayerData.job.name) and shop_grade_contains(shops.jobs.jobs, ESX.PlayerData.job.grade) then
                            local distance = Vdist(GetEntityCoords(PlayerPedId()), location.x, location.y, location.z)

                            if shops.pedmodel then
                                if distance < 20 then
                                    sleep = 0
                                    isNearShop = true
                                    currentShop = shops

                                    if not isPedLoaded then
                                        RequestModel(GetHashKey(shops.pedmodel))
                                        while not HasModelLoaded(GetHashKey(shops.pedmodel)) do
                                            Wait(1)
                                        end
                                        npc = CreatePed(4, GetHashKey(shops.pedmodel), location.x, location.y, location.z - 1.0, location.rot, false, true)
                                        FreezeEntityPosition(npc, true)	
                                        SetEntityHeading(npc, location.h)
                                        SetEntityInvincible(npc, true)
                                        SetBlockingOfNonTemporaryEvents(npc, true)
                                        isPedLoaded = true
                                    end
                                end

                                if Config.npcVoice then
                                    if distance < 4 and not hadSpeak then
                                        sleep = 0
                                        PlayPedAmbientSpeechNative(npc, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE_NO_REPEAT_FRONTEND')
                                        hadSpeak = true
                                    elseif distance > 4.5 and distance < 6 and hadSpeak then
                                        sleep = 0
                                        PlayPedAmbientSpeechNative(npc, 'GENERIC_BYE', 'SPEECH_PARAMS_FORCE_NO_REPEAT_FRONTEND')
                                        hadSpeak = false
                                    end
                                end
                            else
                                if distance <= 5.0 then 
                                    sleep = 0
                                    isNearShop = true
                                    currentShop = shops

                                    if shops.marker.enable then
                                        DrawMarker(shops.marker.type, location.x, location.y, location.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, shops.marker.size.a, shops.marker.size.b, shops.marker.size.c, shops.marker.color.a, shops.marker.color.b, shops.marker.color.c, 100, false, true, 0, false)
                                    end

                                    if shops.text3d.enable then
                                        ESX.Game.Utils.DrawText3D(location, shops.text3d.label, shops.text3d.size)
                                    end
                                end
                            end

                            if distance <= 2.5 then
                                sleep = 0
                                currentShop = shops

                                if Config.shopTextUI.type:match('default') then
                                    SetTextComponentFormat('STRING')
                                    AddTextComponentString(('Press ~g~E~s~ to open ~y~%s~s~'):format(currentShop.label))
                                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                                elseif Config.shopTextUI.type:match('okok') then
                                    if not shopTextUIOpen then
                                        exports['okokTextUI']:Open('[E] Open ' .. v.label .. ' ', Config.shopTextUI.color, Config.shopTextUI.position)
                                        shopTextUIOpen = true
                                    end
                                elseif Config.shopTextUI.type:match('esx') then
                                    if not shopTextUIOpen then
                                        exports["esx_textui"]:TextUI('[E] Open ' .. shops.label .. ' ', Config.shopTextUI.esx)
                                        shopTextUIOpen = true
                                    end
                                elseif Config.shopTextUI.type:match('renzu') then
                                    if not shopTextUIOpen then
                                        TriggerEvent('renzu_popui:showui', {
                                            ['key'] = 'E', 
                                            ['title'] = shops.label, 
                                            ['fa'] = '<i class="fad fa-shopping-basket"></i>'
                                        })
                                        shopTextUIOpen = true
                                    end
                                end

                                if IsControlJustReleased(0, Config.shopHotkey) then 
                                    OpenShop(shops.label, shops.items, shops.addon_account_name, shops.jobs, shops.job_grades, shops.license)
                                end
                            elseif distance < 5 then
                                sleep = 0
                                if Config.shopTextUI.type:match('okok') then
                                    exports['okokTextUI']:Close()
                                    shopTextUIOpen = false
                                elseif Config.shopTextUI.type:match('esx') then
                                    exports["esx_textui"]:HideUI()
                                    shopTextUIOpen = false
                                elseif Config.shopTextUI.type:match('renzu') then
                                    TriggerEvent('renzu_popui:closeui')
                                    shopTextUIOpen = false
                                end
                            end
                        end
                    end
                end

                if (isPedLoaded and not isNearShop) then
                    DeleteEntity(npc)
                    for k,shops in pairs(Config.ShopLocations) do 
                        SetModelAsNoLongerNeeded(GetHashKey(shops.pedmodel))
                    end
                    isPedLoaded = false
                end

                Wait(sleep)
            end
        end)

        function resetShopBlips()
            CreateThread(function ()
                for k, v in pairs(Blips) do 
                    RemoveBlip(v)
                    Blips = {}
                end

                for k, shops in pairs(Config.ShopLocations) do
                    if shops.blip.enable then 
                        local canSee = true

                        if shops.blip.hiddenForOthers then
                            canSee = false

                            if shops.jobs.enable then
                                if ESX.PlayerData.job then 
                                    if shop_job_contains(shops.jobs.jobs, ESX.PlayerData.job.name) then 
                                        if shop_grade_contains(shops.jobs.jobs, ESX.PlayerData.job.grade) then
                                            canSee = true
                                        else
                                            canSee = false
                                        end
                                    else
                                        canSee = false
                                    end
                                else
                                    canSee = false
                                end
                            end
                        end

                        if canSee then 
                            for k2, location in pairs(shops.locations) do 
                                local blip = AddBlipForCoord(location.x, location.y, location.z)

                                SetBlipSprite(blip, shops.blip.id)
                                SetBlipScale(blip, shops.blip.scale)
                                SetBlipDisplay(blip, 4)
                                SetBlipColour(blip, shops.blip.color)
                                SetBlipAsShortRange(blip, true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString(shops.label)
                                EndTextCommandSetBlipName(blip)      
                                table.insert(Blips, blip)
                            end
                        end
                    end
                end
            end)
        end

        resetShopBlips()
    end
end

shop_job_contains = function(table, value)
    for k, v in pairs(table) do
        if v.job == value then
            return true
        end
    end
    return false
end

shop_grade_contains = function(table, value)
    for k, v in pairs(table) do
        if v.grade <= value then
            return true
        end
    end
    return false
end