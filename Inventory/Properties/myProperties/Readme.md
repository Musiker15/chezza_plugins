**Only for inventory v4 and this version of myProperties *Update from 01.02.2022* !**

Replace the **client.lua** or replace the **Snippet inside** your ***client.lua***

```
if not onlyVisit then
    local inventory_item = NativeUI.CreateItem('Storage', '~b~Store some stuff')
    wardrobeMenu:AddItem(inventory_item)
    
    inventory_item.Activated = function(sender, index)
        for koP, oP in pairs(ownedProperties) do
            -- Default
            TriggerEvent('inventory:openHouse', ESX.GetPlayerData().identifier, propertyID, oP.property, 5000)

            -- For myMultichar Script
            --TriggerEvent('inventory:openHouse', '', propertyID, oP.property, 5000)
        end
        _menuPool:CloseAllMenus()
    end
end
```

***Tutorial made by Musiker15***