fx_version 'cerulean'

author 'Slatu'

version '1.0'

game 'gta5'


client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}

shared_scripts {
    "shared/sh_config.lua",
}

client_scripts{
    '@es_extended/locale.lua',
    "client/cl_smask.lua",
}

server_scripts{
    '@es_extended/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    "server/sv_smask.lua",
}


shared_script '@es_extended/imports.lua'

