ESX.RegisterServerCallback('inventory:getNameFromLockers', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.getName(), xPlayer.getIdentifier())
end)