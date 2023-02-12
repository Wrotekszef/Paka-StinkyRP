fx_version 'adamant'
game 'gta5'
version '1.3.0'
description 'exile_animacje'
shared_scripts { 
	'@es_extended/imports.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}
client_scripts {
	'config.lua',
	'client.lua',
}
exports {
	'openAnimations',
	'blockAnims',
	'PedStatus',
	'getCarry'
}