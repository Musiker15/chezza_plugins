local Debug = false
local props = {
    684586828, 577432224, 2707782415, 218085040, 666561306, 4236481708, 4088277111, 1511880420, 682791951, 651101403
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        if Debug then
            print(playerPed)
            print(playerPos)
        end

        for k, prop in pairs (props) do
            local inventory = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 25.0, prop, false, false, false)
            local invPos = GetEntityCoords(inventory)
            local dist = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, invPos.x, invPos.y, invPos.z, true)

            if Debug then
                print('inventory = ' .. inventory)
                print('invPos = ' .. invPos)
                print('dist = ' .. dist)
            end
            
            if dist < 3 then
                local invID = invPos .. ' - ' .. prop

                ESX.Game.Utils.DrawText3D(invPos, '[~r~E~w~] Mülltonne', 0.8)

                if IsControlJustReleased(0, 38) then
                    if invID ~= nil then
                        if Debug then
                            print('ID found')
                        end

                        TriggerEvent('inventory:openInventory', {
                            type = "trash",
                            id = invID,
                            title = "Mülltonne",
                            weight = 100, -- set to false for no weight
                            delay = 100,
                            save = true
                        })
                    else
                        if Debug then
                            print('ID not found')
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        local VAnlage = {x = -345.91, y = -1556.38, z = 25.23}
        local VAnlage2 = vector3(-345.91, -1556.38, 25.23)
        local distance = Vdist(playerPos, VAnlage.x, VAnlage.y, VAnlage.z)

        if distance <= 10 then
            ESX.Game.Utils.DrawText3D(VAnlage2, '[~r~E~w~] Müllverbrennung - ~g~Items werden gelöscht!', 0.8)
            DrawMarker(27, VAnlage.x, VAnlage.y, VAnlage.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 0, false)
        end

        if distance <= 2.0 then
            if IsControlJustReleased(0, 38) then
                TriggerEvent('inventory:openInventory', {
                    type = "trash",
                    id = playerPed,
                    title = "Müllverbrennung",
                    weight = 10000, -- set to false for no weight
                    save = false,
                    delay = 200
                })
            end

            AddEventHandler("inventory:close", function()
                ESX.ShowNotification('~r~Komm nach Server Neustart wieder!\n~g~Erst dann ist der Müll vollständig verbrannt!')
            end)
        end
    end
end)