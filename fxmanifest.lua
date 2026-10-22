fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'sd-computers-mdt'
author 'wraith'
version '1.0.0'
description 'MDT desktop app: police, medical and court terminals'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}
client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib',
    'sd-computers',
    'sd-phone',
}

files {
    'ui/dist/*',
    'ui/dist/**/*',
}
