Config.DispatchJobs = {
    {
        name = 'police',
        label = 'LSPD', -- Displays inside the App
        color = '#0000cd', -- HEX Color
    },
    {
        name = 'ambulance',
        label = 'Mediziner', -- Displays inside the App
        color = '#ff0000', -- HEX Color
    },
    {
        name = 'mechanic',
        label = 'Mechaniker', -- Displays inside the App
        color = '#808080', -- HEX Color
    },
    {
        name = 'taxi',
        label = 'Taxi', -- Displays inside the App
        color = '#ffff00', -- HEX Color
    },
}

Config.DispatchEvents = function(job, message)
    if job == "police" then
        TriggerServerEvent('dispatch:send', 'police', message, GetEntityCoords(PlayerPedId()))
    elseif job == "ambulance" then
        TriggerServerEvent('dispatch:send', 'ambulance', message, GetEntityCoords(PlayerPedId()))
    elseif job == "mechanic" then
        TriggerServerEvent('dispatch:send', 'mechanic', message, GetEntityCoords(PlayerPedId()))
    elseif job == "taxi" then
        TriggerServerEvent('dispatch:send', 'taxi', message, GetEntityCoords(PlayerPedId()))
    end

    TriggerEvent('phone:notify', { app = 'sdispatch', title = 'Dispatch', content = 'Successfully send a Dispatch'})
end