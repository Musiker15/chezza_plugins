### Please open the Readme.md to see the Full Installation Documentation.

*Thanks to RickmaN for testing it. Tutorial made by Musiker15*

---

Go to `client.lua` and search for `function OpenRoomMenu(property)`.

Find this and replace it:

```
{label = _U('invite_player'), value = 'invite_player'},
{label = _U('player_clothes'), value = 'player_dressing'},
--{label = _U('remove_object'), value = 'room_inventory'},
--{label = _U('deposit_object'), value = 'player_inventory'},
{label = 'Open House Storage', value = 'chezza_inventory'},
```

Next scroll down and search for this:

```
if data.current.value == 'room_inventory' then
  OpenRoomInventoryMenu(property)
end
```

And replace it with:

```
if data.current.value == 'chezza_inventory' then
    -- Default // recommended
    TriggerEvent('inventory:openHouse', ESX.GetPlayerData().identifier, property.name, property.label, 500)
    -- For myMultichar Script
    --TriggerEvent('inventory:openHouse', '', property.name, property.label, 500)
end
```