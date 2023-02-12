

fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Data Store'
--
version '1.0.2'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/datastore.lua',
	'server/main.lua'
}
shared_scripts { 
	'@es_extended/imports.lua',
}