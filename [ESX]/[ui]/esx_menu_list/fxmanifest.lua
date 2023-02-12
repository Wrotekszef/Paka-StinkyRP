fx_version "bodacious"
games {"gta5"}
lua54 'yes'
client_scripts {
	'@es_extended/client/wrapper.lua',
	'client/main.lua'
}
ui_page {
	'html/ui.html'
}
files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
	'html/img/cursor.png',
	'html/img/keys/enter.png',
	'html/img/keys/return.png',
}
shared_script '@es_extended/imports.lua'