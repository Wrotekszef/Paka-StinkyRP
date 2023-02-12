fx_version 'cerulean'
author 'exilerp top'
description 'Bitki'
game 'gta5'
shared_scripts { 
	'@es_extended/imports.lua',
}
client_script 'c.lua'
server_scripts {
  's.lua',
  '@oxmysql/lib/MySQL.lua',
  'discord/index.js',
}