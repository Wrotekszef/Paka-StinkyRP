fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'ESX Weapon Shop and Weapon Sync'
version '1.1.0'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}
exports {
	"IsWeapon"
}
dependency 'es_extended'
shared_scripts { 
	'@es_extended/imports.lua',
}