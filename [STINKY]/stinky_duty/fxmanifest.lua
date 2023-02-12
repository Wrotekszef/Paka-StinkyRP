fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'exile_duty'
version '1.0.0'
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'client/main.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua',
}