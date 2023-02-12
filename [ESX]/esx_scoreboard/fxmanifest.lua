fx_version 'adamant'
game 'gta5'
lua54 'yes'
shared_scripts { 
	'@es_extended/imports.lua',
}
server_script 'server/main.lua'
client_script {
	'@es_extended/imports.lua',
	'client/main.lua'
}
ui_page 'html/scoreboard.html'
files {
	'html/scoreboard.html',
	'html/style.css',
	'html/reset.css',
	'html/listener.js',
	'html/img.png'
}
server_exports {
	'ExilePlayers',
	'CounterPlayers'
}