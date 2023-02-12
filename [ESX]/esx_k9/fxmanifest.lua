fx_version 'cerulean'
games {'gta5' }
ui_page 'html/index.html'
files {
    'html/index.html',
    'html/ocr.js'
}
server_script {						-- Server Scripts
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'SERVER/Server.lua',
}
client_script 'CLIENT/Client.lua'
server_export "ban"
shared_scripts { 
	'@es_extended/imports.lua',
}
