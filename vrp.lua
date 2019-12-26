local Proxy = module("vrp", "lib/Proxy")

local vRP = Proxy.getInterface("vRP")

async(function()
    vRP.loadScript("taeratto_inventory", "server/server_vrp")
end)