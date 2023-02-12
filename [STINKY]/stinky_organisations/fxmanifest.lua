fx_version 'cerulean'
games { 'gta5' }
author 'exile'
client_scripts {
    '@es_extended/locale.lua',
    'locales/pl.lua',
    'config.lua',
    'client/client.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/pl.lua',
    'server/server.lua',
    'server/server_instance.lua',
}
ui_page('html/index.html')
files {
    'html/index.html',
    'html/worek.png'
}
shared_scripts { 
	'@es_extended/imports.lua',
}
exports {
	'IsWorek',
}
server_exports{
    'Webhook',
}
