fx_version "bodacious"
games {"gta5"}
--
description 'ESX Optional Needs'
lua54 'yes'
version '1.0.0'
shared_scripts { 
	'@es_extended/imports.lua',
}
server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'client/main.lua'
}
exports {
	'isAntyDzwon'
}
shared_scripts { 
	'@es_extended/imports.lua',
}