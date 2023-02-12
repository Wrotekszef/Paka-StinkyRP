fx_version 'cerulean'
games { 'gta5' }
author 'exile'
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'@es_extended/locale.lua',
	'locates/pl.lua',
	'config.lua',
	'client/client.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locates/pl.lua',
	'config.lua',
	'server.lua'
}
ui_page('client/html/UI.html')
files({
    'client/html/UI.html',
    'client/html/style.css',
	'client/html/tablet.png'
})