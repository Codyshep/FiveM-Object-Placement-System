fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'EagleDev'
description 'None'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*'
}

client_scripts {
    'client/*',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

--[[

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/images/*'
}

escrow_ignore {
    'config.lua'
}

]]--