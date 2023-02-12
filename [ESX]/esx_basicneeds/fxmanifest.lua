fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'ESX Basic Needs'
--
version '1.0.1'
server_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}
server_exports {
	'isDrunk',
	'samarkaStatus'
}
shared_scripts { 
	'@es_extended/imports.lua',
}