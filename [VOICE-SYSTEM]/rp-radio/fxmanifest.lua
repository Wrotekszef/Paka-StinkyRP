fx_version "bodacious"
game "gta5"
lua54 'yes'
name "rp-radio"
description "exile_rpradio"
author "exile"
version "2.2.1"
dependencies {
	"pma-voice",
}
client_scripts {
	"config.lua",
	"client.lua",
}
shared_scripts { 
	'@es_extended/imports.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server.lua",
}
exports {
	'GetRadioData',
	'OpenRadioListW',
	'OpenRadioList',
	'RadioList'
}