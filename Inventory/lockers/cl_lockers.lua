if Config.EnableLockers then
    local lTextUIOpen = false
    CreateThread(function()
        while true do
            Wait(0)
            for k, locker in pairs(Config.Lockers) do 
                for i, position in ipairs(locker.positions) do
                    local distance = #(GetEntityCoords(PlayerPedId()) - position)

                    if distance <= 5.0 then 
                        if not locker.jobs or ESX.PlayerData.job and T(locker.jobs):includes(ESX.PlayerData.job.name) then 
                            DrawMarker(27, position.x, position.y, position.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 100, false, true, 0, false)
                                    
                            if locker.draw3dtext then
                                ESX.Game.Utils.DrawText3D(position, locker.draw3dlang, 0.8)
                            end

                            if distance <= 1.2 then 
                                if Config.lTextUI:match('default') then
                                    SetTextComponentFormat('STRING')
                                    AddTextComponentString("Drücke ~INPUT_CONTEXT~ um den " .. locker.label .. " zu öffnen")
                                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                                elseif Config.lTextUI:match('okok') then
                                    if not lTextUIOpen then
                                        exports['okokTextUI']:Open('[E] Spint öffnen', 'darkblue', 'left')
                                        lTextUIOpen = true
                                    end
                                elseif Config.lTextUI:match('ESX') then
                                    if not lTextUIOpen then
                                        exports["esx_textui"]:TextUI('[E] Spint öffnen', 'info') -- 'info', 'success', 'error'
                                        lTextUIOpen = true
                                    end
                                end

                                if IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback('inventory:getNameFromLockers', function(name, identifier)
                                        TriggerEvent('inventory:openInventory', {
                                            type = k,
                                            id = identifier,
                                            title = locker.label.. ' - ' .. name,
                                            weight = locker.weight,
                                            delay = 200,
                                            save = true
                                        })
                                    end)
                                end
                            elseif distance < 1.5 then
                                if Config.lTextUI:match('okok') then
                                    exports['okokTextUI']:Close()
                                    lTextUIOpen = false
                                elseif Config.lTextUI:match('ESX') then
                                    exports["esx_textui"]:HideUI()
                                    lTextUIOpen = false
                                end
                            end        
                        end            
                    end
                end
            end
        end
    end)
end