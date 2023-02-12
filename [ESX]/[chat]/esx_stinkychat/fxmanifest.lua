fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'ESX RP Chat'
--
shared_scripts { 
	'@es_extended/imports.lua',
}
version '1.2.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locates/sv.lua',
	'locates/en.lua',
	'locates/fi.lua',
	'locates/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locates/sv.lua',
	'locates/en.lua',
	'locates/fi.lua',
	'locates/fr.lua',
	'config.lua',
	'client/main.lua'
}

ui_page 'html/index.html'
files {
	'html/index.html',
	'html/**/*.js',
	'html/**/*.png',
	'html/**/*.woff',
	'html/**/*.mp3',
	'html/**/*.woff2',
	'html/**/*.css'
}
exports {
	'showIcon',
	'hideIcon',
	'showProgress',
	'cancelProgress',
	'showTaskbar',
	'stopTaskbar',
	"showSolid",
	"hideSolid",
	"updateSolid"
}
server_exports {
	'getIdentity'
}
