Config.EnableLockers = true -- Personel Lockers
Config.lTextUI = 'default' -- 'default', 'okok' or 'ESX' [for 'ESX' you need 'esx_textui']

Config.Lockers = {
    ["mr_pd_1"] = {
        label = "PD Locker 1",
        positions = {
            vector3(482.96, -992.4, 30.69),
        },
        jobs = {'police'},
        weight = 1000,
        draw3dtext = true, -- Set to true if you want this
        draw3dlang = '~g~PD Locker 1', -- Set your Language if 'draw3dtext = true'
    },
}