fx_version 'adamant'
game 'gta5'
description 'esx_doorlock'
version '1.4.0'
server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua'
}
dependency 'es_extended'
shared_scripts { 
	'@es_extended/imports.lua',
}