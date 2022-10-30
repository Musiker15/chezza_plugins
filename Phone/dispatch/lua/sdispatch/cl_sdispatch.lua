RegisterNUICallback('getJobs', function(data, cb)  
    cb(Config.DispatchJobs)
end)

RegisterNUICallback('sendDispatch', function(data, cb)     
    Config.DispatchEvents(data.job, data.message)
end)