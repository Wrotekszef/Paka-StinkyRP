fx_version "bodacious"
games {"gta5"}
lua54 'yes'
--
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'@es_extended/imports.lua',
	'locales/en.lua',
	'config.lua',
	'client/tattoosList/list.lua',
	'client/main.lua'
}
shared_scripts { 
	'@es_extended/imports.lua',
}