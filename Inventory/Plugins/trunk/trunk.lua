if Config.Trunk then 
    local inTrunk = false
    local vehicle = nil

    local function VehicleInFront()
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
        local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
        local a, b, c, d, result = GetRaycastResult(rayHandle)
        return result
    end

    AddEventHandler('inventory:close', function()
        if vehicle then
            inTrunk = false
            SetVehicleDoorShut(vehicle, 5, true)
            vehicle = nil
        end
    end)

    RegisterCommand('openTrunk', function()
        if IsEntityDead(PlayerPedId()) then return end

        if not IsPedInAnyVehicle(PlayerPedId(), false) then 
            vehicle = VehicleInFront()

            if DoesEntityExist(vehicle) then
                if not IsVehicleStopped(vehicle) then return end

                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                local type = GetVehicleClass(vehicle)
                local locked = GetVehicleDoorLockStatus(vehicle)
                local trunkWeight = Config.TrunkWeights[type]

                if locked == 1 then
                    for k, v in pairs(Config.BlacklistedVehicleTypes) do
                        if type == v then
                            TriggerEvent('inventory:notify', 'error', "Vehicle does not have a trunk")
                            return
                        end
                    end

                    for k, v in pairs(Config.TrunkCustomWeights) do
                        if k:upper() == GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):upper() then
                            trunkWeight = v
                        end     
                    end

                    SetCarBootOpen(vehicle)

                    if Config.TrunkSave then
                        ESX.TriggerServerCallback("inventory:isVehicleOwned", function(owned)
                            OpenInventory({
                                id = plate, 
                                type = 'trunk', 
                                title = 'Trunk - <b>' .. plate .. '</b>',
                                weight = trunkWeight, 
                                save = owned,
                                timeout = Config.TrunkTimeout
                            }) 
                        end, plate)
                    else 
                        OpenInventory({
                            id = plate, 
                            type = 'trunk', 
                            title = 'Trunk - <b>' .. plate .. '</b>',
                            weight = trunkWeight, 
                            save = false,
                            timeout = Config.TrunkTimeout
                        }) 
                    end

                    inTrunk = true
                else 
                    TriggerEvent('inventory:notify', 'error', "Vehicle is Locked")
                end
            end
        end
    end, true)
    RegisterKeyMapping('openTrunk', 'Open Trunk', 'keyboard', Config.TrunkKey)

    CreateThread(function ()
        while true do 
            Wait(1000)
            if inTrunk and vehicle then 
                local dist = #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId()))

                if dist > 3.0 then 
                    SendNUIMessage({
                        action = 'close',
                        invName = GetCurrentResourceName()
                    })    
                end
            end
        end
    end)
end