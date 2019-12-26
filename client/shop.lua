local shopData = nil


local Licenses = {}
local HasAlreadyEnteredMarker = false
local CurrentActionData       = {}
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
ESX = nil

-- Citizen.CreateThread(
--     function()
--         while ESX == nil do
--             TriggerEvent(
--                 "esx:getSharedObject",
--                 function(obj)
--                     ESX = obj
--                 end
--             )
--             Citizen.Wait(0)
--         end
--         Citizen.Wait(5000)
--         ESX.TriggerServerCallback('monster_inventoryhud:requestDBItems', function(shopInvent)
--             for k,v in pairs(shopInvent) do
--                 if (Config.Zones[k] ~= nil) then
--                     Config.Zones[k].Items = v
--                 end
--             end
--         end)
--     end
-- )

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for k,v in pairs(Config.Zones) do
            for i = 1, #v.Pos, 1 do
                if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
                    DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, true, false, false, false)
                end
            end
        end--]]


        --[[player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)
        if IsInRegularShopZone(coords) or IsInRobsLiquorZone(coords) or IsInYouToolZone(coords) or IsInPrisonShopZone(coords) or IsInWeaponShopZone(coords) then
            if IsInRegularShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("regular")
                    Citizen.Wait(2000)
                end
            end
            if IsInRobsLiquorZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("robsliquor")
                    Citizen.Wait(2000)
                end
            end
            if IsInYouToolZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("youtool")
                    Citizen.Wait(2000)
                end
            end
            if IsInPrisonShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    OpenShopInv("prison")
                    Citizen.Wait(2000)
                end
            end
            if IsInWeaponShopZone(coords) then
                if IsControlJustReleased(0, Keys["E"]) then
                    if Licenses['weapon'] ~= nil then
                        OpenShopInv("weaponshop")
                        Citizen.Wait(2000)
                    else
                        exports['mythic_notify']:DoHudText('error', 'You need a Fire Arms license before you can buy weapons')
                    end
                end
            end
        end
    end
end)--]]

AddEventHandler('monster_inventoryhud:hasEnteredMarker', function(zone)
    CurrentAction     = 'monster_shop'
    CurrentActionMsg  = 'E'
    CurrentActionData = {zone = zone}
    -- exports['Monster_base']:textNotification(zone)
end)

AddEventHandler('monster_inventoryhud:hasExitedMarker', function(zone)
    CurrentAction = nil
    -- exports['Monster_base']:textNotification(zone)
    -- ESX.UI.Menu.CloseAll()
end)


-- Enter / Exit marker events
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)
--         local coords      = GetEntityCoords(GetPlayerPed(-1))
--         local isInMarker  = false
--         local currentZone = nil

--         for k,v in pairs(Config.Zones) do
--             for i = 1, #v.Pos, 1 do
--                 if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 1.1) then
--                     isInMarker  = true
--                     ShopItems   = v.Items
--                     currentZone = k
--                     LastZone    = k
--                 end
--             end
--         end
--         if isInMarker and not HasAlreadyEnteredMarker then
--             HasAlreadyEnteredMarker = true
--             TriggerEvent('monster_inventoryhud:hasEnteredMarker', currentZone)
--         end
--         if not isInMarker and HasAlreadyEnteredMarker then
--             HasAlreadyEnteredMarker = false
--             TriggerEvent('monster_inventoryhud:hasExitedMarker', LastZone)
--         end
--     end
-- end)


-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)

--         if CurrentAction ~= nil then
            
--             -- exports['Monster_base']:ShowHelpNotification(CurrentActionMsg)

--             if IsControlJustReleased(0, 38) then

--                 if CurrentAction == 'monster_shop' then
--                     OpenShopInv(CurrentActionData.zone)
--                 end

--                 CurrentAction = nil
--             end

--         else
--             Citizen.Wait(500)
--         end
--     end
-- end)


function OpenShopInv(zone)
    -- exports['Monster_base']:textNotification('OpenShopInv')
    --exports['Monster_base']:textNotification(Config.Zones[zone][1].name)
    text = "shop"
    data = {text = text}
    inventory = {}

    --[[ESX.TriggerServerCallback("suku:getShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, zone)--]]

    for i=1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]

        if item.limit == -1 then
            item.limit = 100
        end
        -- exports['Monster_base']:textNotification(i)
        table.insert(inventory, item)

    end

    Citizen.Wait(500)
    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory, zone)
end

RegisterNetEvent("suku:OpenCustomShopInventory")
AddEventHandler("suku:OpenCustomShopInventory", function(type, zone)
    text = "shop"
    data = {text = text}
    inventory = {}

    --[[ESX.TriggerServerCallback("suku:getCustomShopItems", function(shopInv)
        for i = 1, #shopInv, 1 do
            table.insert(inventory, shopInv[i])
        end
    end, type, shopinventory)--]]
    for i=1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]

        if item.limit == -1 then
            item.limit = 100
        end

        table.insert(inventory, item)

    end
    Citizen.Wait(500)

    TriggerEvent("esx_inventoryhud:openShopInventory", data, inventory)
end)

RegisterNetEvent("esx_inventoryhud:openShopInventory")
AddEventHandler("esx_inventoryhud:openShopInventory", function(data, inventory, zone)
        setShopInventoryData(data, inventory, zone)--, weapons)
        openShopInventory()
end)

function setShopInventoryData(data, inventory, zone)
    shopData = data

    SendNUIMessage(
        {
            action = "setInfoText",
            text = data.text
        }
    )

    items = {}

    SendNUIMessage(
        {
            action = "setShopInventoryItems",
            itemList = inventory,
            zone = zone
        }
    )
end

function openShopInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "shop"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback("TakeFromShop", function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            -- exports['Monster_base']:textNotification(data.item.type..' '..data.item.name..' '..tonumber(data.number))
            TriggerServerEvent("suku:SellItemToPlayer", GetPlayerServerId(PlayerId()), data.item.type, data.item.name, tonumber(data.number), data.zone)
        end

        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)
--[[
RegisterNetEvent("suku:AddAmmoToWeapon")
AddEventHandler("suku:AddAmmoToWeapon", function(hash, amount)
    AddAmmoToPed(GetPlayerPed(-1), hash, amount)
end)

function IsInRegularShopZone(coords)
    RegularShop = Config.Shops.RegularShop.Locations
    for i = 1, #RegularShop, 1 do
        if GetDistanceBetweenCoords(coords, RegularShop[i].x, RegularShop[i].y, RegularShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInRobsLiquorZone(coords)
    RobsLiquor = Config.Shops.RobsLiquor.Locations
    for i = 1, #RobsLiquor, 1 do
        if GetDistanceBetweenCoords(coords, RobsLiquor[i].x, RobsLiquor[i].y, RobsLiquor[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInYouToolZone(coords)
    YouTool = Config.Shops.YouTool.Locations
    for i = 1, #YouTool, 1 do
        if GetDistanceBetweenCoords(coords, YouTool[i].x, YouTool[i].y, YouTool[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInPrisonShopZone(coords)
    PrisonShop = Config.Shops.PrisonShop.Locations
    for i = 1, #PrisonShop, 1 do
        if GetDistanceBetweenCoords(coords, PrisonShop[i].x, PrisonShop[i].y, PrisonShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end

function IsInWeaponShopZone(coords)
    WeaponShop = Config.Shops.WeaponShop.Locations
    for i = 1, #WeaponShop, 1 do
        if GetDistanceBetweenCoords(coords, WeaponShop[i].x, WeaponShop[i].y, WeaponShop[i].z, true) < 1.5 then
            return true
        end
    end
    return false
end--]]

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        coords = GetEntityCoords(player)

        if GetDistanceBetweenCoords(coords, Config.WeaponLiscence.x, Config.WeaponLiscence.y, Config.WeaponLiscence.z, true) < 3.0 then
            ESX.Game.Utils.DrawText3D(vector3(Config.WeaponLiscence.x, Config.WeaponLiscence.y, Config.WeaponLiscence.z), "Press [E] to open shop", 0.6)

            if IsControlJustReleased(0, Keys["E"]) then
                if Licenses['weapon'] == nil then
                    OpenBuyLicenseMenu()
                else
                    exports['mythic_notify']:DoHudText('error', 'You already have a Fire arms license!')
                end
                Citizen.Wait(2000)
            end
        end
    end
end)--]]

--[[RegisterNetEvent('suku:GetLicenses')
AddEventHandler('suku:GetLicenses', function (licenses)
    for i = 1, #licenses, 1 do
        Licenses[licenses[i].type] = true
    end
end)

function OpenBuyLicenseMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license',{
        title = 'Register a License?',
        elements = {
          { label = 'yes' ..' ($' .. Config.LicensePrice ..')', value = 'yes' },
          { label = 'no', value = 'no' },
        }
      },
      function (data, menu)
        if data.current.value == 'yes' then
            TriggerServerEvent('suku:buyLicense')
        end
        menu.close()
    end,
    function (data, menu)
        menu.close()
    end)
end
--]]
--[[Citizen.CreateThread(function()
    player = GetPlayerPed(-1)
    coords = GetEntityCoords(player)
    for k, v in pairs(Config.Shops.RegularShop.Locations) do
        CreateBlip(vector3(Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z ), "Convenience Store", 3.0, Config.Color, Config.ShopBlipID)
    end

    for k, v in pairs(Config.Shops.RobsLiquor.Locations) do
        CreateBlip(vector3(Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z ), "RobsLiquor", 3.0, Config.Color, Config.LiquorBlipID)
    end

    for k, v in pairs(Config.Shops.YouTool.Locations) do
        CreateBlip(vector3(Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z ), "YouTool", 3.0, Config.Color, Config.YouToolBlipID)
    end

    for k, v in pairs(Config.Shops.YouTool.Locations) do
        CreateBlip(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z), "Prison Commissary", 3.0, Config.Color, Config.PrisonShopBlipID)
    end

    for k, v in pairs(Config.Shops.WeaponShop.Locations) do
        CreateBlip(vector3(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z), "Ammunation", 3.0, Config.WeaponColor, Config.WeaponShopBlipID)
    end

    CreateBlip(vector3(-755.79, 5596.07, 41.67), "Cablecart", 3.0, 4, 36)
end)--]]

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(7)
--         player = PlayerPedId() --GetPlayerPed(-1)
--         coords = GetEntityCoords(player, true)

--         for k,v in pairs(Config.Zones) do
--             for i=1, #v.Pos, 1 do
--                 if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 3.0 then
--                     -- ESX.Game.Utils.DrawText3D(vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z), "Press [E] to open shop", 0.6)
--                     DrawText3D(vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z + 0.2), "~y~กด ~r~E~s~ ~g~เปิดร้านค้า~s~")
--                 end
--             end
--         end

--         --[[for k, v in pairs(Config.Shops.RegularShop.Locations) do
--             if GetDistanceBetweenCoords(coords, Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z, true) < 3.0 then
--                 ESX.Game.Utils.DrawText3D(vector3(Config.Shops.RegularShop.Locations[k].x, Config.Shops.RegularShop.Locations[k].y, Config.Shops.RegularShop.Locations[k].z + 1.0), "Press [E] to open shop", 0.6)
--             end
--         end

--         for k, v in pairs(Config.Shops.RobsLiquor.Locations) do
--             if GetDistanceBetweenCoords(coords, Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z, true) < 3.0 then
--                 ESX.Game.Utils.DrawText3D(vector3(Config.Shops.RobsLiquor.Locations[k].x, Config.Shops.RobsLiquor.Locations[k].y, Config.Shops.RobsLiquor.Locations[k].z + 1.0), "Press [E] to open shop", 0.6)
--             end
--         end

--         for k, v in pairs(Config.Shops.YouTool.Locations) do
--             if GetDistanceBetweenCoords(coords, Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z, true) < 3.0 then
--                 ESX.Game.Utils.DrawText3D(vector3(Config.Shops.YouTool.Locations[k].x, Config.Shops.YouTool.Locations[k].y, Config.Shops.YouTool.Locations[k].z + 1.0), "Press [E] to open shop", 0.6)
--             end
--         end

--         for k, v in pairs(Config.Shops.PrisonShop.Locations) do
--             if GetDistanceBetweenCoords(coords, Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z, true) < 3.0 then
--                 ESX.Game.Utils.DrawText3D(vector3(Config.Shops.PrisonShop.Locations[k].x, Config.Shops.PrisonShop.Locations[k].y, Config.Shops.PrisonShop.Locations[k].z), "Press [E] to open shop", 0.6)
--             end
--         end

--         for k, v in pairs(Config.Shops.WeaponShop.Locations) do
--             if GetDistanceBetweenCoords(coords, Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z, true) < 3.0 then
--                 ESX.Game.Utils.DrawText3D(vector3(Config.Shops.WeaponShop.Locations[k].x, Config.Shops.WeaponShop.Locations[k].y, Config.Shops.WeaponShop.Locations[k].z + 1.0), "Press [E] to open shop", 0.6)
--             end
--         end--]]
--     end
-- end)


-- local fontID = nil
-- Citizen.CreateThread(function()
--     while fontID == nil do
--         Citizen.Wait(5000)
--         fontID = exports['taeratto_base']:getFontID()
--     end
-- end)

-- DrawText3D = function(coords, text)
--     SetTextScale(0.55, 0.55)
--     SetTextFont(fontID) --4
--     SetTextProportional(1)
--     SetTextColour(255, 255, 255, 215)
--     SetTextEntry("STRING")
--     SetTextCentre(true)
--     AddTextComponentString(text)
--     --DrawText(_x,_y)
--     SetDrawOrigin(coords.x, coords.y, coords.z, 0)
--     DrawText(0.0, 0.0)
--     local factor = (string.len(text)) / 400
--     --DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
--     DrawRect(0.0, 0.0+0.0225, 0.007+ factor, 0.04, 0, 0, 0, 68)
--     ClearDrawOrigin()
-- end


--[[function CreateBlip(coords, text, radius, color, sprite)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, color)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end--]]