fx_version "bodacious"
games {"gta5"}
lua54 'yes'
client_script('client/client.lua')
server_script "@oxmysql/lib/MySQL.lua"
server_script 'server.lua'
ui_page('client/html/UI.html')
shared_scripts { 
	'@es_extended/imports.lua',
}
files {
	'client/html/UI.html',
    'client/html/style.css',
    'client/html/media/font/Bariol_Regular.otf',
    'client/html/media/font/Vision-Black.otf',
    'client/html/media/font/Vision-Bold.otf',
    'client/html/media/font/Vision-Heavy.otf',
    'client/html/media/img/bg.png',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/graph.png',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png'
}
exports {
    'TargetInBank'
}
