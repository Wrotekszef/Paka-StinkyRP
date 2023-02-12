fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'esx_addonhouse'
version '1.1.0'
shared_scripts {
	'@es_extended/imports.lua',
}
server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}
dependencies {
	'es_extended',
	'instanceAddon',
	'cron',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore'
}
