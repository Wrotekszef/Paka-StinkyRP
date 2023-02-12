fx_version 'adamant'
game 'gta5'
author 'Aiakos#8317' 
description 'codem-venicespawn'
version '1.0'
ui_page {'html/index.html'}
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'client.lua',
}
server_script {
	'server.lua',
	'@oxmysql/lib/MySQL.lua'
}
files {
'html/index.html', 
'html/img/*.png',
'html/script.js',
'html/style.css',
         
}
