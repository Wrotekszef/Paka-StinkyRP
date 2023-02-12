fx_version 'adamant'
games { 'gta5' }
lua54 'yes'
shared_scripts { 
	'@es_extended/imports.lua',
}
client_script 'client.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}