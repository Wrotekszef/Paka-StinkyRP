fx_version "bodacious"
games {"gta5"}
lua54 'yes'
--
client_scripts {
	'@es_extended/imports.lua',
	'client/*.lua',
	'scripts/**/client.lua',
}
server_scripts {
	'@es_extended/imports.lua',
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
	'scripts/**/server.lua',
	'src/sv.js'
}
files {
    'html/index.html',
	'html/*.ogg',
	'html/*.mp4',
	'html/*.png',
}
ui_page('html/index.html')
exports {
	'DisplayingStreet',
	'DisableEffects',
	'EnableEffects',
	'isPlayerProne',
	'SetBlip',
	'WybijBlachyMenu',
	'blip_info',
	'isAntytroll'
}