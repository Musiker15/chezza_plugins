#### waveProperties with Chezza Inventory v4

*Thanks to opper4k for testing it. Tutorial made by Musiker15*

```
-- CUSTOM STORAGE FUNCTION
waveProperties.storageFunctionWhenPressedOpenKey = function(propertyID) -- function when the player press the key to open storage, u need to use propertyID
    if waveProperties.frameWork == "ESX" then
        -- Default
        TriggerEvent('inventory:openHouse', ESX.GetPlayerData().identifier, propertyID, propertyID, 500)
        -- For myMultichar Script
        --TriggerEvent('inventory:openHouse', '', propertyID, propertyID, 500)
    elseif waveProperties.frameWork == "QBCORE" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Property_" .. propertyID, {
            maxweight = 4000000, -- Configure the max weight you want.
            slots = 500, -- Configure the maximum slots
        })
        TriggerEvent("inventory:client:SetCurrentStash", "Property_" .. propertyID)
    end
end
```