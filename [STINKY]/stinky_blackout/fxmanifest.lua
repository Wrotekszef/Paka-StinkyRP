fx_version 'bodacious'
game 'gta5'
--
shared_scripts { 
	'@es_extended/imports.lua',
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
}
client_scripts {
    "client/main.lua",
}
ui_page 'html/index.html'
files {
    'html/index.html',
    'html/heartbeat.ogg',
}