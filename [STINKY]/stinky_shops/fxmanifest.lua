fx_version "bodacious"
games {"gta5"}
lua54 'yes'
--
description 'ESX Shops'
version '1.1.0'
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'config.lua',
	'client/main.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}
