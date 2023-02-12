fx_version 'cerulean'
games { 'gta5' }
author 'falszywyy'
lua54 'yes'
shared_scripts { 
	'@es_extended/imports.lua',
}
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