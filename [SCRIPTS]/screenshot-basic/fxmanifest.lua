fx_version "bodacious"
game "gta5"
lua54 'yes'
client_script 'dist/client.js'
client_script 'client.lua'
server_script 'dist/server.js'
dependency 'yarn'
dependency 'webpack'
webpack_config 'client.config.js'
webpack_config 'server.config.js'
webpack_config 'ui.config.js'
exports {
    'requestScreenshotUploadImgur'
}
files {
    'dist/ui.html'
}
ui_page 'dist/ui.html'