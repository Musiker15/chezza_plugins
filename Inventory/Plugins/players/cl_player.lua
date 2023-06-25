RegisterNetEvent('inventory:openPlayerInventory', function(pid, receiveWeapons)
    OpenInventory({type = 'player', id = pid, title = Locales.playerTitle, weight = true, receiveWeapons = receiveWeapons, delay = 1000})
end)

isPlayerDead = false
AddEventHandler('esx:onPlayerDeath', function() isPlayerDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isPlayerDead = false end)

AddEventHandler("inventory:open", function()
    if isPlayerDead or IsPedDeadOrDying(PlayerPedId()) then
        CloseInventory()
    end
end)
exports('CloseInventory', CloseInventory) -- exports.inventory:CloseInventory()