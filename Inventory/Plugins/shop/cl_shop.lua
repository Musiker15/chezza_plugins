if Config.Shops then 
    function OpenShop(title, items, account, jobs, grades, license)
        if license then 
            ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
                if hasLicense then
                    OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
                else 
                    TriggerEvent('inventory:notify', Locales.noLicense, "error")
                end
            end, GetPlayerServerId(PlayerId()), license)
            return
        end

        if not jobs then 
            OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
            return
        end       

        if T(jobs):includes(ESX.PlayerData.job.name) then 
            if grades then 
                if T(grades):includes(ESX.PlayerData.job.grade) then 
                    canSee = true
                    OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
                else
                    TriggerEvent('inventory:notify', Locales.noAccessShop, "error")
                end
            else 
                canSee = true
                OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
            end
        else
            TriggerEvent('inventory:notify', Locales.noAccessShop, "error")
        end
    end

    RegisterNetEvent('inventory:openShop', function (title, items)
        OpenShop(title, items)
    end)

    if Config.ShopsBuiltIn then 
        local isPedLoaded = false
        local isNearShop = false
        local npc = nil
        local shopTextUIOpen = false
        local hadSpeak = false
        local currentShop = nil
        local Blips = {}

        RegisterNetEvent(Config.ESXPrefix..':playerLoaded')
        AddEventHandler(Config.ESXPrefix..':playerLoaded', function(xPlayer, isNew)
            resetShopBlips()
        end)

        RegisterNetEvent(Config.ESXPrefix..':playerLogout') 
        AddEventHandler(Config.ESXPrefix..':playerLogout', function(xPlayer, isNew)
            resetShopBlips()
        end)
        
        RegisterNetEvent(Config.ESXPrefix..':setJob')
        AddEventHandler(Config.ESXPrefix..':setJob', function(job)
            resetShopBlips()
        end)

        CreateThread(function ()
            while true do
                Wait(0)
                isNearShop = false
                for k,shops in pairs(Config.ShopLocations) do 
                    for k2,location in pairs(shops.locations) do 
                        --default: local distance = #(GetEntityCoords(PlayerPedId()) - location)
                        local distance = Vdist(GetEntityCoords(PlayerPedId()), location.x, location.y, location.z)

                        if shops.pedmodel ~= false then
                            if distance < 25 then
                                isNearShop = true
                                currentShop = shops

                                if not isPedLoaded then
                                    RequestModel(GetHashKey(shops.pedmodel))
                                    while not HasModelLoaded(GetHashKey(shops.pedmodel)) do
                                        Wait(1)
                                    end
                                    npc = CreatePed(4, GetHashKey(shops.pedmodel), location.x, location.y, location.z - 1.0, location.rot, false, true)
                                    FreezeEntityPosition(npc, true)	
                                    SetEntityHeading(npc, location.rot)
                                    SetEntityInvincible(npc, true)
                                    SetBlockingOfNonTemporaryEvents(npc, true)
                                    isPedLoaded = true
                                end
                            end

                            if Config.npcVoice then
                                if distance < 5 and not hadSpeak then
                                    PlayPedAmbientSpeechNative(npc, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE_NO_REPEAT_FRONTEND')
                                    hadSpeak = true
                                elseif distance > 6 and distance < 8 and hadSpeak then
                                    PlayPedAmbientSpeechNative(npc, 'GENERIC_BYE', 'SPEECH_PARAMS_FORCE_NO_REPEAT_FRONTEND')
                                    hadSpeak = false
                                end
                            end
                        else
                            if distance <= 5.0 then 
                                isNearShop = true
                                currentShop = shops

                                if isNearShop then
                                    DrawMarker(27, location.x, location.y, location.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 100, false, true, 0, false)
                                    if shops.draw3dtext ~= false then
                                        ESX.Game.Utils.DrawText3D(location, shops.draw3dtext.label, shops.draw3dtext.size)
                                    end
                                end
                            end
                        end

                        if distance <= 2.5 then
                            currentShop = shops

                            if Config.TextUI:match('default') then
                                SetTextComponentFormat('STRING')
                                AddTextComponentString(Locales.shopOpenBtn)
                                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                            elseif Config.TextUI:match('okok') then
                                if not shopTextUIOpen then
                                    exports['okokTextUI']:Open('[E] Open ' .. v.label .. ' ', 'darkblue', 'left')
                                    shopTextUIOpen = true
                                end
                            elseif Config.TextUI:match('esx') then
                                if not shopTextUIOpen then
                                    exports["esx_textui"]:TextUI('[E] Open ' .. shops.label .. ' ', 'info') -- 'info', 'success', 'error'
                                    shopTextUIOpen = true
                                end
                            elseif Config.TextUI:match('renzu') then
                                if not shopTextUIOpen then
                                    local renzuTable = {
                                        ['key'] = 'E', 
                                        ['title'] = ' '..shops.label..' ', 
                                        ['fa'] = '<i class="fad fa-shopping-basket"></i>'
                                    }
                                    TriggerEvent('renzu_popui:showui', renzuTable)
                                    shopTextUIOpen = true
                                end
                            end

                            if IsControlJustReleased(0, 38) then 
                                OpenShop(shops.label, shops.items, shops.addon_account_name, shops.jobs, shops.job_grades, shops.license)
                            end
                        elseif distance < 5 then
                            if Config.TextUI:match('okok') then
                                exports['okokTextUI']:Close()
                                shopTextUIOpen = false
                            elseif Config.textUI:match('esx') then
                                exports["esx_textui"]:HideUI()
                                shopTextUIOpen = false
                            elseif Config.textUI:match('renzu') then
                                TriggerEvent('renzu_popui:closeui')
                                shopTextUIOpen = false
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
            end
        end)

        function resetShopBlips()
            CreateThread(function ()
                for k,v in pairs(Blips) do 
                    RemoveBlip(v)
                    table.remove(Blips, k)
                end

                for k,shops in pairs(Config.ShopLocations) do
                    if shops.blip then 
                        local canSee = true

                        if shops.blip.hiddenForOthers then
                            canSee = false
                            if shops.jobs then 
                                if ESX.PlayerData.job then 
                                    if T(shops.jobs):includes(ESX.PlayerData.job.name) then 
                                        if shops.job_grades then 
                                            if T(shops.job_grades):includes(ESX.PlayerData.job.grade) then 
                                                canSee = true
                                            end
                                        else 
                                            canSee = true
                                        end
                                    end
                                else 
                                    canSee = false
                                end
                            end
                        end

                        if canSee then 
                            for k2,location in pairs(shops.locations) do 
                                --default: local blip = AddBlipForCoord(location)
                                if shops.blip ~= false then
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
                end
            end)
        end

        resetShopBlips()
    end
end