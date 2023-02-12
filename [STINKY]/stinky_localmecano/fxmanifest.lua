fx_version 'cerulean'
games { 'gta5' }
author 'exile_localmecano'
server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua'
}
shared_scripts { 
	'@es_extended/imports.lua',
}
exports{
	"RepairVehicle",
	"CanRepairVehicle"
}
dependency 'es_extended'