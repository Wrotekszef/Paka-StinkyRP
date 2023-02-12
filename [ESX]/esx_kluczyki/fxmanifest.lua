fx_version 'adamant'
game 'gta5'
lua54 'yes'
--
client_scripts {
    '@es_extended/locale.lua',
    '@es_extended/imports.lua',
    "config/shared.lua",
    "client/client.lua",
}
server_scripts {
    '@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
    "config/shared.lua",
    "server/server.lua",
}
exports{
    "LockSystem"
}
shared_scripts { 
	'@es_extended/imports.lua',
}