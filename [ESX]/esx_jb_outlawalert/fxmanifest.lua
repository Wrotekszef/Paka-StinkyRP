fx_version "bodacious"
games {"gta5"}
lua54 'yes'
--
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
client_script "client.lua"
shared_scripts { 
	'@es_extended/imports.lua',
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav",
    "html/notif.wav"
}
