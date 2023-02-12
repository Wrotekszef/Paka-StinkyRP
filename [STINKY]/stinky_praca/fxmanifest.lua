fx_version 'cerulean'
game 'gta5'
description 'ExileRP'
author 'Sekul & desire'
version '1.0.0'
client_scripts {
   'client/*.lua',
   'config.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'config.lua',
}
ui_page 'html/index.html'
files {
	'html/index.html'
}