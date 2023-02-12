fx_version "bodacious"
games {"gta5"}
--
lua54 'yes'
shared_scripts { 
	'@es_extended/imports.lua',
}
client_script {
  'config.lua',
  'client.lua',
  'init.lua',
  
}
server_script {
  'config.lua',
  'server.lua',
}
