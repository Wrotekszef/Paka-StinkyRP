fx_version "bodacious"
games {"gta5"}
--
lua54 'yes'
ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/play.ttf',
	'html/playb.ttf',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'config.lua',
	'server.lua'
}
client_script {
	'config.lua',
	'client.lua'
}
shared_scripts { 
	'@es_extended/imports.lua',
}
dependencies {
	'esx_vehicleshop'
}
