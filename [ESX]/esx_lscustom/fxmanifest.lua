fx_version 'adamant'
game 'gta5'
lua54 'yes'
--
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
}
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'client/menu.lua',
	'client/main.lua',
	'client/lsc.lua',
	'config.lua',
}
exports{
	'OnTuneCheck'
}