fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'esx_policejob for exile'
version '1.0'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
}
exports {
	'IsCuffed',
	'HandcuffMenu',
	'checkzakutedxD',
	'KaskOnHead'
}
dependencies {
	'es_extended',
}
shared_scripts { 
	'@es_extended/imports.lua',
}