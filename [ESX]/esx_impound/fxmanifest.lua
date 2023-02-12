fx_version 'adamant'
game 'gta5'
lua54 'yes'
description 'Exile Impound'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}
client_scripts {
	'client/main.lua',
}
shared_scripts { 
	'@es_extended/imports.lua',
}