fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'esx_ambulancejobb Edited By ExileRP Developers'
version '2.0'
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
	'client/main.lua',
}
exports {
	'isDead',
	'IsBlockWeapon'
}
dependency 'es_extended'
shared_scripts { 
	'@es_extended/imports.lua',
}