resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"


name 'TaerAttO Inventory HUD'
description 'Inventory HUD By TaerAttO'
author 'TaerAttO'
version '0.5.0'
url 'https://discord.gg/T2BW7Ft'

ui_page "html/ui.html"

client_scripts {
  "@vrp/lib/utils.lua",
  -- "client/*.lua",
  "config.lua",
  "client/*.lua"
  -- "locales/en.lua",
  
}

server_scripts {
  "@vrp/lib/utils.lua",
  "config.lua",
  "server_vrp.lua"
  -- "locales/en.lua",
  
}

-- exports {
--   'GetKeysInventory',
--   'RemoveKeysInventory'
-- }

files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/inventory.js",
  "html/js/config.js",
  -- JS LOCALES
  -- "html/locales/cs.js",
  "html/locales/en.js",
  -- "html/locales/fr.js",
  -- IMAGES
  "html/img/bullet.png",
  "html/img/monsterenergy.png",
  -- ICONS
  "html/img/items/*.png",
  
}
