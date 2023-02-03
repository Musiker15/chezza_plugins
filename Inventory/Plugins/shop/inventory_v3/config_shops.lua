Config.Shops = true -- toggle shops plugin | default: true
Config.ShopsBuiltIn = true -- toggle shops built in, add your shops below in Config.ShopLocations | default: false
Config.ShopDelay = 250 -- opening delay of the shop | default: 250

Config.shopHotkey = 38
Config.shopTextUI = {
    type = 'default', -- 'default', 'esx', 'okok' or 'renzu'
    color = 'darkblue', -- Only for okokTextUI
    position = 'left', -- Only for okokTextUI
    esx = 'info' -- Only for esx_textUI
}
Config.shopNPCVoice = true -- The NPC will say something to you

Config.ShopLocations = {
    ["247"] = {
        label = '24/7 Shop',
        license = false, -- license name, esx_license required!
        jobs = {enable = false, jobs = {
            {job = 'police', grade = 0},
        }},
        addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
        blip = {enable = true, id = 59, color = 2, scale = 0.8, hiddenForOthers = false},
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        text3d = {enable = true, label = '~g~Open Werkbank', size = 0.8},
        marker = {enable = true, type = 27, size = {a = 0.6, b = 0.6, c = 0.6}, color = {a = 255, b = 255, c = 255}},
        locations = {
            {x = 1727.71, y = 6415.24, z = 35.04, h = 242.06}, -- Paleto Bay
            {x = 1697.65, y = 4923.14, z = 42.063, h = 352.85}, -- Grapeseed
            {x = 1959.97, y = 3739.96, z = 32.34, h = 288.98}, -- Sandy Shores
            {x = 549.25, y = 2671.34, z = 42.156, h = 82.59}, -- Grand Senora
            {x = 24.44, y = -1347.33, z = 29.5, h = 266.37}, -- Near Unicorn
            {x = -1070.54, y = -2836.5, z = 27.7, h = 283.93}, -- Airport MLO
            {x = 372.48, y = 326.74, z = 103.57, h = 248.65}, -- Power Street bei 574
            {x = 2556.94, y = 380.71, z = 108.62, h = 342.38},
            {x = -3039.04, y = 584.18, z = 7.91, h = 357.0},
            {x = -3242.54, y = 999.74, z = 12.830, h = 336.15},
            {x = 1134.12, y = -982.77, z = 46.42, h = 279.46},
            {x = -1222.16, y = -908.53, z = 12.33, h = 23.5},
            {x = -1486.21, y = -377.92, z = 40.163, h = 126.46},
            {x = -2966.28, y = 390.67, z = 15.043, h = 85.91},
            {x = -47.08, y = -1758.46, z = 29.421, h = 53.42},
            {x = 1164.883, y = -323.38, z = 69.21, h = 106.81},
            {x = -705.9601, y = -914.250, z = 19.215, h = 110.24},
            {x = -1819.8, y = 793.92, z = 138.09, h = 154.0},
            {x = 1392.69, y = 3606.548, z = 34.980, h = 186.81}, -- Sandy Shores
            {x = 1166.14, y = 2710.830, z = 38.157, h = 168.31}, -- Grand Senora
            {x = 2677.75, y = 3279.35, z = 55.22, h = 325.98}, -- East Highway
        },
        items = {
            {type = 'item', name = 'bread', method = 'money', price = 10},
            {type = 'item', name = 'water', method = 'money', price = 10},
            {type = 'weapon', name = 'WEAPON_KNIFE', method = 'money', price = 30},
        }
    },
    ["GunShop"] = {
        label = 'Weapon Shop',
        license = 'weapon', -- license name, esx_license required!
        jobs = {enable = false, jobs = {
            {job = 'police', grade = 0},
        }},
        addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
        blip = {enable = true, id = 110, color = 1, scale = 0.8, hiddenForOthers = false},
        pedmodel = 's_m_y_ammucity_01', -- 's_m_y_ammucity_01' or false to use a Marker instead
        text3d = {enable = true, label = '~g~Open Werkbank', size = 0.8},
        marker = {enable = true, type = 27, size = {a = 0.6, b = 0.6, c = 0.6}, color = {a = 255, b = 255, c = 255}},
        locations = {
            {x = -661.767, y = -933.6132, z = 21.81, h = 153.07},   -- PLZ: 8140
            {x = 809.73, y = -2159.09, z = 29.61, h= 334.48},       -- PLZ: 9275
            {x = 1692.75, y = 3761.53, z = 34.68, h = 201.25},      -- PLZ: 3018
            {x = -331.18, y = 6085.64, z = 31.45, h = 192.75},      -- PLZ: 1034
            {x = 253.59, y = -51.44, z = 69.93, h = 51.02},         -- PLZ: 7121
            {x = 23.1, y = -1105.6, z = 29.8, h = 164.4},           -- PLZ: 8168
            {x = 253.72, y = -51.23, z = 69.93, h = 51.02},         -- PLZ: 7121
            {x = -1118.44, y = 2700.46, z = 18.54, h = 201.25},     -- PLZ: 5004
            {x = 841.49, y = -1035.32, z = 28.18, h = 342.99},      -- PLZ: 8194
        },
        items = {
            {type = 'weapon', name = 'WEAPON_PISTOL', method = 'money', price = 3, ammo = 100},
        }
    }
}