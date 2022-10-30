Config.Shops = true -- toggle shops plugin | default: true
Config.ShopsBuiltIn = false -- toggle shops built in, add your shops below in Config.ShopLocations | default: false
Config.ShopDelay = 250 -- opening delay of the shop | default: 250

Config.TextUI = 'default' -- 'default' or 'okok' or 'esx'
Config.npcVoice = true -- The NPC will say something to you

Config.ShopLocations = {
    --[[["GunShop"] = {
        label = 'Waffenladen',
        license = "weapon", -- "weapon" or false // license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1, 2, 3} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = {id = 110, color = 81, scale = 0.8, hiddenForOthers = false}, -- Set false to disable
        pedmodel = 's_m_y_ammucity_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            {x = -598.57, y = 221.92, z = 74.15, rot = 261.99},
        },
        items = {
            {type = 'weapon', name = 'WEAPON_PISTOL', method = 'money', price = 35000, sellPrice = 1, ammo = 100},
            {type = 'weapon', name = 'WEAPON_FLASHLIGHT', method = 'money', price = 100, sellPrice = 1, ammo = 100},
            {type = 'weapon', name = 'WEAPON_FIREEXTINGUISHER', method = 'money', price = 100, sellPrice = 1, ammo = 100},
            {type = 'weapon', name = 'WEAPON_KNIFE', method = 'money', price = 1000, sellPrice = 1, ammo = 100},
            {type = 'weapon', name = 'WEAPON_BAT', method = 'money', price = 100, sellPrice = 1, ammo = 100},
        }
    },]]
    ["GunShopCasino"] = {
        label = 'Waffenladen',
        license = false, -- "weapon" or false // license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 's_m_y_ammucity_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            {x = -598.57, y = 221.92, z = 74.15, rot = 261.99},
        },
        items = {
            {type = 'weapon', name = 'WEAPON_PISTOL', method = 'money', price = 1000, sellPrice = 1000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_MACHETE', method = 'money', price = 100, sellPrice = 100, ammo = 100},
            {type = 'weapon', name = 'WEAPON_STUNGUN', method = 'money', price = 1000, sellPrice = 1000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_MICROSMG', method = 'money', price = 5000, sellPrice = 5000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_PUMPSHOTGUN', method = 'money', price = 10000, sellPrice = 10000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_ASSAULTRIFLE', method = 'money', price = 10000, sellPrice = 10000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_GUSENBERG', method = 'money', price = 10000, sellPrice = 10000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_COMBATPISTOL', method = 'money', price = 1000, sellPrice = 1000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_PISTOL50', method = 'money', price = 1000, sellPrice = 1000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_SWITCHBLADE', method = 'money', price = 100, sellPrice = 100, ammo = 100},
            {type = 'weapon', name = 'WEAPON_DOUBLEACTION', method = 'money', price = 1000, sellPrice = 1000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_MINISMG', method = 'money', price = 5000, sellPrice = 5000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_KNIFE', method = 'money', price = 100, sellPrice = 100, ammo = 100},
            {type = 'weapon', name = 'WEAPON_KNUCKLE', method = 'money', price = 100, sellPrice = 100, ammo = 100},
            {type = 'weapon', name = 'WEAPON_SAWNOFFSHOTGUN', method = 'money', price = 10000, sellPrice = 10000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_COMPACTRIFLE', method = 'money', price = 5000, sellPrice = 5000, ammo = 100},
            {type = 'weapon', name = 'WEAPON_CARBINERIFLE', method = 'money', price = 10000, sellPrice = 10000, ammo = 100},
        }
    },
    ["Shop247"] = {
        label = 'Einkaufsmarkt',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = {id = 59, color = 2, scale = 0.8, hiddenForOthers = false}, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 1727.91, y = 6415.52, z = 35.04, rot = 214.3}, -- Paleto Bay
            {x = 1697.65, y = 4923.14, z = 42.063, rot = 352.85}, -- Grapeseed
            {x = 1959.97, y = 3739.96, z = 32.34, rot = 288.98}, -- Sandy Shores
            {x = 549.25, y = 2671.34, z = 42.156, rot = 82.59}, -- Grand Senora
            {x = 24.44, y = -1347.33, z = 29.5, rot = 266.37}, -- Near Unicorn
            {x = -1070.54, y = -2836.5, z = 27.7, rot = 283.93}, -- Airport MLO
            {x = 372.48, y = 326.74, z = 103.57, rot = 248.65}, -- Power Street bei 574
            {x = 2556.94, y = 380.71, z = 108.62, rot = 342.38},
            {x = -3039.04, y = 584.18, z = 7.91, rot = 357.0},
            {x = -3242.54, y = 999.74, z = 12.830, rot = 336.15},
            {x = 1134.12, y = -982.77, z = 46.42, rot = 279.46},
            {x = -1222.16, y = -908.53, z = 12.33, rot = 23.5},
            {x = -1486.21, y = -377.92, z = 40.163, rot = 126.46},
            {x = -2966.28, y = 390.67, z = 15.043, rot = 85.91},
            {x = -47.08, y = -1758.46, z = 29.421, rot = 53.42},
            {x = 1164.883, y = -323.38, z = 69.21, rot = 106.81},
            {x = -705.9601, y = -914.250, z = 19.215, rot = 110.24},
            {x = -1819.8, y = 793.92, z = 138.09, rot = 154.0},
        },
        items = {
            {type = "item", name = "bread", method = 'money', price = 60, sellPrice = 120},
            {type = "item", name = "hamburger", method = 'money', price = 80, sellPrice = 120},
            {type = "item", name = "water", method = 'money', price = 45, sellPrice = 120},
            {type = "item", name = "icetea", method = 'money', price = 55, sellPrice = 120},
            {type = "item", name = "jusfruit", method = 'money', price = 50, sellPrice = 120},
            {type = "item", name = "phone", method = 'money', price = 1200, sellPrice = 600},
            {type = "item", name = "spray", method = 'money', price = 350, sellPrice = 170},
            {type = "item", name = "spray_remover", method = 'money', price = 35, sellPrice = 20},
            {type = "item", name = "bandage", method = 'money', price = 76, sellPrice = 40},
            {type = "item", name = "beer", method = 'money', price = 85, sellPrice = 100},
            {type = "item", name = "contract", method = 'money', price = 150, sellPrice = 80},
            {type = "item", name = "turtlebait", method = 'money', price = 200, sellPrice = 100},
            {type = "item", name = "fishbait", method = 'money', price = 150, sellPrice = 130},
            {type = "item", name = "bag", method = 'money', price = 500, sellPrice = 300},
        }
    },
    ["Airport"] = {
        label = 'Einkaufsmarkt',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = {id = 59, color = 2, scale = 0.8, hiddenForOthers = false}, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = -1070.54, y = -2836.5, z = 27.7, rot = 283.93}, -- Airport MLO
        },
        items = {
            {type = "item", name = "bread", method = 'money', price = 60, sellPrice = 120},
            {type = "item", name = "hamburger", method = 'money', price = 80, sellPrice = 120},
            {type = "item", name = "water", method = 'money', price = 45, sellPrice = 120},
            {type = "item", name = "icetea", method = 'money', price = 55, sellPrice = 120},
            {type = "item", name = "jusfruit", method = 'money', price = 50, sellPrice = 120},
            {type = "item", name = "phone", method = 'money', price = 1200, sellPrice = 600},
            {type = "item", name = "spray", method = 'money', price = 350, sellPrice = 170},
            {type = "item", name = "spray_remover", method = 'money', price = 35, sellPrice = 20},
            {type = "item", name = "beer", method = 'money', price = 85, sellPrice = 100},
            {type = "item", name = "contract", method = 'money', price = 150, sellPrice = 80},
            {type = "item", name = "turtlebait", method = 'money', price = 200, sellPrice = 100},
            {type = "item", name = "fishbait", method = 'money', price = 150, sellPrice = 130},
            {type = "item", name = "bag", method = 'money', price = 500, sellPrice = 300},
        }
    },
    ["ShopLiquor"] = {
        label = 'Getränkeladen',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = {id = 59, color = 2, scale = 0.8, hiddenForOthers = false}, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 1392.69, y = 3606.548, z = 34.980, rot = 186.81}, -- Sandy Shores
            {x = 1166.14, y = 2710.830, z = 38.157, rot = 168.31}, -- Grand Senora
        },
        items = {
            {type = "item", name = "bread", method = 'money', price = 60, sellPrice = 30},
            {type = "item", name = "hamburger", method = 'money', price = 80, sellPrice = 40},
            {type = "item", name = "water", method = 'money', price = 45, sellPrice = 23},
            {type = "item", name = "icetea", method = 'money', price = 55, sellPrice = 27},
            {type = "item", name = "jusfruit", method = 'money', price = 50, sellPrice = 25},
            {type = "item", name = "beer", method = 'money', price = 85, sellPrice = 43},
            {type = "item", name = "JagerBomb", method = 'money', price = 100, sellPrice = 52},
            {type = "item", name = "Vodkaenergy", method = 'money', price = 100, sellPrice = 50},
        }
    },
    ["ShopTankstelle"] = {
        label = 'Tankstelle',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = {id = 59, color = 2, scale = 0.8, hiddenForOthers = false}, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 2678.1, y = 3279.39, z = 55.24, rot = 330.64},
        },
        items = {
            {type = "item", name = "bread", method = 'money', price = 60, sellPrice = 30},
            {type = "item", name = "hamburger", method = 'money', price = 80, sellPrice = 40},
            {type = "item", name = "water", method = 'money', price = 45, sellPrice = 23},
            {type = "item", name = "icetea", method = 'money', price = 55, sellPrice = 27},
            {type = "item", name = "jusfruit", method = 'money', price = 50, sellPrice = 25},
            {type = "item", name = "scratchcard", method = 'money', price = 5000, sellPrice = 2500},
            {type = "item", name = "cube", method = 'money', price = 15, sellPrice = 8},
            {type = "item", name = "beer", method = 'money', price = 85, sellPrice = 43},
            {type = "item", name = "JagerBomb", method = 'money', price = 100, sellPrice = 52},
            {type = "item", name = "Vodkaenergy", method = 'money', price = 100, sellPrice = 50},
        }
    },
    ["ShopBaumarkt"] = {
        label = 'Baumarkt',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = {id = 59, color = 2, scale = 0.8, hiddenForOthers = false}, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 2749.29, y = 3483.47, z = 55.67, rot = 70.64},
        },
        items = {
            {type = "item", name = "drill", method = 'money', price = 2500, sellPrice = 1800},
            {type = "item", name = "hammerwirecutter", method = 'money', price = 2000, sellPrice = 1200},
            {type = "item", name = "oxygenmask", method = 'money', price = 5000, sellPrice = 3000},
            {type = "item", name = "lockpick", method = 'money', price = 1500, sellPrice = 800},
            {type = "item", name = "fixtool", method = 'money', price = 1500, sellPrice = 800},
            {type = "item", name = "fishingrod", method = 'money', price = 2000, sellPrice = 1100},
            {type = "item", name = "cuffs", method = 'money', price = 1120, sellPrice = 700},
            {type = "item", name = "trailburst", method = 'money', price = 450, sellPrice = 250},
            {type = "item", name = "fountain", method = 'money', price = 450, sellPrice = 250},
            {type = "item", name = "shotburst", method = 'money', price = 450, sellPrice = 250},
            {type = "item", name = "starburst", method = 'money', price = 450, sellPrice = 250},
            {type = "item", name = "parachute", method = 'money', price = 500, sellPrice = 300},
            {type = "item", name = "huelse", method = 'money', price = 7, sellPrice = 3},
            {type = "item", name = "glasbottle", method = 'money', price = 10, sellPrice = 6},
        }
    },
    ["ShopSexShop"] = {
        label = 'SexShop',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 's_f_y_stripper_02', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 128.68, y = -1282.59, z = 29.27, rot = 122.61},
        },
        items = {
            {type = "item", name = "dildo", method = 'money', price = 69, sellPrice = 40},
            {type = "item", name = "dildo2", method = 'money', price = 96, sellPrice = 50},
            {type = "item", name = "condom", method = 'money', price = 69, sellPrice = 40},
        }
    },
    ["ShopIllegal"] = {
        label = 'Schwarzmarkt',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = -1913.94, y = 1388.83, z = 219.39, rot = 271.19},
        },
        items = {
            {type = "item", name = "lockpick", method = 'money', price = 1500, sellPrice = 700},
            {type = "item", name = "hackerDevice", method = 'money', price = 20000, sellPrice = 13000},
            {type = "item", name = "mini_c4", method = 'money', price = 7000, sellPrice = 4000},
            {type = "item", name = "normal_c4", method = 'money', price = 14000, sellPrice = 8000},
            {type = "item", name = "methlab", method = 'money', price = 1500, sellPrice = 700},
            {type = "item", name = "cuff_keys", method = 'money', price = 750, sellPrice = 500},
            {type = "item", name = "accesscard", method = 'money', price = 20000, sellPrice = 13000},
            {type = "item", name = "keycard", method = 'money', price = 7500, sellPrice = 4000},
            {type = "item", name = "coyotte", method = 'money', price = 3100, sellPrice = 1800},
            ----------------------------------------------------------------
            {type = "item", name = "smgclip", method = 'money', price = 550, sellPrice = 300},
            {type = "item", name = "shotgunclip", method = 'money', price = 800, sellPrice = 400},
            {type = "item", name = "rifleclip", method = 'money', price = 750, sellPrice = 500},
            {type = "item", name = "mgclip", method = 'money', price = 750, sellPrice = 500},
            ----------------------------------------------------------------
            {type = "item", name = "clip_extended", method = 'money', price = 680, sellPrice = 300},
            {type = "item", name = "suppressor", method = 'money', price = 680, sellPrice = 320},
            {type = "item", name = "luxary_finish", method = 'money', price = 680, sellPrice = 320},
        }
    },
    ["ShopComponents"] = {
        label = 'Waffen Munition / Komponenten',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 's_m_y_ammucity_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 20.69, y = -1104.74, z = 29.8, rot = 156.49}, -- LS Würfelpark
            {x = -333.06, y = 6083.48, z = 31.45, rot = 224.76}, -- Paleto Bay
            {x = 1690.89, y = 3759.42, z = 34.71, rot = 230.83}, -- Grapeseed
            {x = 254.61, y = -48.6, z = 69.94, rot = 68.59}, -- LS Vinewood
            {x = -664.5, y = -933.51, z = 21.83, rot = 176.34}, -- LS Little Soul
            {x = 844.47, y = -1035.35, z = 28.19, rot = 356.51}, -- LS La Mesa
            {x = 812.35, y = -2159.09, z = 29.62, rot = 0.96}, -- LS Cypress Flats
            {x = 2570.07, y = 292.59, z = 108.73, rot = 357.53}, -- Tataviam
            {x = -1120.53, y = 2698.37, z = 18.55, rot = 216.21}, -- Route 68
        },
        items = {
            {type = "item", name = "pistolclip", method = 'money', price = 250, sellPrice = 150},
            ----------------------------------------------------------------
            {type = "item", name = "flashlight", method = 'money', price = 680, sellPrice = 300},
            {type = "item", name = "scope", method = 'money', price = 680, sellPrice = 320},
            {type = "item", name = "grip", method = 'money', price = 680, sellPrice = 320},
            ----------------------------------------------------------------
            --[[
            {type = "item", name = "tint_green", method = 'money', price = 560, sellPrice = 150},
            {type = "item", name = "tint_gold", method = 'money', price = 560, sellPrice = 300},
            {type = "item", name = "tint_pink", method = 'money', price = 560, sellPrice = 400},
            {type = "item", name = "tint_army", method = 'money', price = 560, sellPrice = 500},
            {type = "item", name = "tint_lspd", method = 'money', price = 560, sellPrice = 500},
            {type = "item", name = "tint_orange", method = 'money', price = 560, sellPrice = 300},
            {type = "item", name = "tint_platinum", method = 'money', price = 560, sellPrice = 320},
            ]]
        }
    },
    ["ShopUTuner"] = {
        label = 'Underground Tuner',
        license = false, -- license name, esx_license required!
        jobs = {'mechanic'}, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = {4}, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 's_f_y_stripper_02', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = 1209.28, y = -3120.51, z = 5.54, rot = 50.58}, 
        },
        items = {
            {type = "item", name = "licenseplate", method = 'money', price = 500, sellPrice = 300},
            {type = "item", name = "zarowki", method = 'money', price = 500, sellPrice = 300},
            {type = "item", name = "tunerchip", method = 'money', price = 50000, sellPrice = 40000},
        }
    },
    ["ShopMechanic"] = {
        label = 'Mechaniker Shop',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = -216.01, y = -1334.37, z = 34.89, rot = 272.02}, 
        },
        items = {
            {type = "item", name = "hamburger", method = 'money', price = 80, sellPrice = 40},
            {type = "item", name = "icetea", method = 'money', price = 55, sellPrice = 30},
            {type = "item", name = "donut", method = 'money', price = 35, sellPrice = 15},
        }
    },
    ["ShopAmbulance"] = {
        label = 'Krankenhaus Shop',
        license = false, -- license name, esx_license required!
        jobs = false, -- {'job','job'} or false // set to false to disable whitelisting
        job_grades = false, -- {1} // set to false to disable grading
        addon_account_name = false, -- 'society_police' // adds to specified account when player buys item, set to false to disable addon_account
        blip = false, -- Set false to disable
        pedmodel = 'mp_m_shopkeep_01', -- 'mp_m_shopkeep_01' or false to use a Marker instead
        draw3dtext = {label = '~g~Open 24/7', size = 0.8}, -- {label = '~g~Open 24/7', size = 0.8} or false to disable
        locations = {
            -- default: vector3(373.875, 325.896, 102.566),
            {x = -432.17, y = -341.66, z = 34.91, rot = 80.52}, 
        },
        items = {
            {type = "item", name = "hamburger", method = 'money', price = 80, sellPrice = 40},
            {type = "item", name = "icetea", method = 'money', price = 55, sellPrice = 30},
            {type = "item", name = "donut", method = 'money', price = 35, sellPrice = 15},
            {type = "item", name = "phone", method = 'money', price = 1200, sellPrice = 600},
        }
    },
}