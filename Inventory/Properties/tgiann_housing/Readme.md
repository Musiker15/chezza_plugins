**Go to */client/editable.lua***

Find ***OpenESXInventory(name)*** and replace it with:

```
local ESX = exports['es_extended']:getSharedObject()
TriggerEvent('inventory:openHouse', ESX.GetPlayerData().identifier, name, name, 500)
```

For ***myMultichar*** Script use this:

```
local ESX = exports['es_extended']:getSharedObject()
TriggerEvent('inventory:openHouse', ESX.GetPlayerData().identifier, '', name, 500)
```

*tested by opper4k*