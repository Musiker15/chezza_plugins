### Please open the Readme.md to see the Full Installation Documentation.

*Tutorial made by Musiker15. Tested by flinkz.*

---

**Chezza's Inventory V4 x Loaf_Motel**

Go to **config.lua** and change this:

```
Inventory = "chezza"
```

Then go to /**client/storage.lua** and replace this function:

```
OpenStorage = function(instance)
    ESX.UI.Menu.CloseAll()

    if Config.Inventory == "default" then
        if Config.Storage.Weapons then
            local weight, maxweight
            if Config.Storage.Limit then
                ESX.TriggerServerCallback("loaf_motel:get_weight", function(used, max)
                    weight = used
                    maxweight = max
                end, instance)
                while weight == nil do
                    Wait(0)
                end
            end

            elements = {
                {value = "items", label = Strings["items"]},
                {value = "weapons", label = Strings["weapons"]},
            }
            for k, v in pairs(Config.MoneyStorage) do
                if v.Allow then
                    table.insert(elements, {value = "money", label = Strings["money"]})
                    break
                end
            end
            if Config.Storage.Limit then
                table.insert(elements, {label = (Strings["weight"]:format(weight, maxweight))})
            end

            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "select_item_type", {
                title = Strings["storage"],
                align = Config.Options.Align,
                elements = elements
            }, function(data, menu)
                if data.current.value == "items" then
                    ItemInventory(instance)
                elseif data.current.value == "weapons" then
                    WeaponInventory(instance)
                elseif data.current.value == "money" then
                    MoneyStorage(instance)
                end
            end, function(data, menu)
                menu.close()
            end)
        else
            ItemInventory(instance)
        end
    elseif Config.Inventory == "chezza" then
        -- Default
        TriggerEvent('inventory:openHouse', ESX.GetPlayerData().identifier, instance, "Motelroom", 5000)
        -- For myMultichar Script
        --TriggerEvent('inventory:openHouse', '', instance, "Motelroom", 5000)
    elseif Config.Inventory == "modfreakz" then
        ESX.TriggerServerCallback("loaf_motel:register_inventory", function(built)
            if built then
                exports["mf-inventory"]:openOtherInventory(instance)
            end
        end, instance)
    elseif Config.Inventory == "linden" then
        ESX.TriggerServerCallback("loaf_motel:get_weight", function(_, max, owner)
            exports['linden_inventory']:OpenStash({owner = owner, id = instance, label = "Motel room", slots = max or 500})
        end, instance)
    elseif Config.Inventory == "ox" then
        exports.ox_inventory:openInventory("stash", {id = instance, owner = Cache.Instance.identifier})
    end
end
```