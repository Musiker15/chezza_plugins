For inventory v3 add in: `inventory/client/plugins/`

```
RegisterNetEvent('inventory:openHouse', function (owner, id, title, weight)
    OpenInventory({id = owner..id, type = 'house', title = title, weight = weight, save = true, timeout = 1000})
end)
```

And then find the Event for opening the housing storage and replace it with:

```
TriggerEvent("inventory:openHouse", owner, inventoryId, Strings["inventory"], 25000)
```

***Made by andyy and LoafScripts***