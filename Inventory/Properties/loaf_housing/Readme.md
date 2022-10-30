### Please open the Readme.md to see the Full Installation Documentation.

*Tutorial made by Kuuzoo edited by Musiker15.*

---

**Chezza's Inventory V4 x Loaf_Housing**

Then go to **loaf_housing** in **client/functions.lua** find

```
Config.Options.Inventory == "modfreaks" 
```

then place this above it

```
elseif Config.Options.Inventory == "chezza" then 
    ESX.UI.Menu.CloseAll() 
    if not v.storage.identifier then 
        ESX.TriggerServerCallback("loaf_housing:convert_storage", function(identifier) 
            TriggerEvent('inventory:openHouse', identifier, houseid, "House Storage", 5000) 
        end, houseid, k) 
    else 
        TriggerEvent('inventory:openHouse', v.storage.identifier, houseid, "House Storage", 5000) 
    end 
```

Don't forget to change the **config.lua** in **Config.Options** under

```
Inventory = "chezza"
```