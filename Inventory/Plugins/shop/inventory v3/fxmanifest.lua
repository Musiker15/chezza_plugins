fx_version "cerulean"
game "gta5"

version "3.7"
author "chezza"
description "Inventory for FiveM by Chezza Studios"

ui_page './web/dist/index.html'

files {
    './web/dist/index.html',
    './web/dist/app.js',
    './web/styles/*.css',
    './web/assets/icons/*.*',
    './web/assets/sounds/*.*',
    './web/assets/*.*'
}

shared_scripts {
    'config.lua',
    'config_*.lua'
}

client_scripts {
    "client/main.lua",
    "client/functions.lua",
    "client/plugins/*.lua",
    "locales.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/main.lua",
    "server/functions.lua",
    "server/plugins/*.lua"
}