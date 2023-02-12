fx_version 'cerulean'
games { 'gta5' }
author 'falszywyy'
lua54 'yes'
client_scripts {
    'client.lua',
}
shared_scripts {
    'config.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}