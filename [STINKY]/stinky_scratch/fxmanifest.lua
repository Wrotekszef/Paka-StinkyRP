fx_version "bodacious"
games {"gta5"}
lua54 'yes'
--
shared_scripts { 
	'@es_extended/imports.lua',
}
client_scripts {
	'client.lua'
}
server_scripts {
    'server.lua'
}
ui_page('html/index.html')
files {
    'html/index.html',
	'html/styles.css',
	'html/scripts.js',
	'html/img/silver.png',
	'html/img/gold.png',
	'html/img/diamond.png',
	'html/font/Transistor.css'
}