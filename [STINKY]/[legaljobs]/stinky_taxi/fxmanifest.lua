fx_version "bodacious"
games {"gta5"}
lua54 'yes'
--
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/s_config.lua',
	'server/main.lua'
}
client_scripts {
	'config.lua',
	'client/main.lua'
}
