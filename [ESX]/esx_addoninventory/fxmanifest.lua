

fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Addon Inventory'
--
version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/addoninventory.lua',
	'server/main.lua'
}
shared_scripts { 
	'@es_extended/imports.lua',
}
dependency 'es_extended'