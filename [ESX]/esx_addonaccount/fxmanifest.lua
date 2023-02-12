

fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Addon Account'
--
version '1.0.1'

server_scripts {
	'@es_extended/imports.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/main.lua'
}

dependency 'es_extended'