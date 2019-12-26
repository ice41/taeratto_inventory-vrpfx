-- Tunnel = module("vrp", "lib/Tunnel")
-- Proxy = module("vrp", "lib/Proxy")

-- local cvRP = module("vrp", "client/vRP")
-- vRP = cvRP()

-- local TaerAttOInventory = class("TaerAttOInventory", vRP.Extension)

Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

isInInventory = false

-- function TaerAttOInventory:__construct()
--     vRP.Extension.__construct(self)

    

-- end -- end __construct()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.OpenControl) and
            IsInputDisabled(0) then openInventory() end
    end
end)

function openInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({action = "display", type = "normal"})
    SetNuiFocus(true, true)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage({action = "hide"})
    SetNuiFocus(false, false)
end

RegisterNUICallback("NUIFocusOff", function() closeInventory() end)

RegisterNUICallback("GetNearPlayers", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer -- = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}

    -- for i = 1, #players, 1 do
    --     if players[i] ~= PlayerId() then
    --         foundPlayers = true

    --         table.insert(
    --             elements,
    --             {
    --                 -- label = GetPlayerName(players[i]),
    --                 label = "",--getCharName(GetPlayerServerId(players[i])),
    --                 player = GetPlayerServerId(players[i])
    --             }
    --         )
    --     end
    -- end

    -- if not foundPlayers then
    --     exports['mythic_notify']:SendAlert('error', _U("players_nearby"))
    -- else
    --     SendNUIMessage(
    --         {
    --             action = "nearPlayers",
    --             foundAny = foundPlayers,
    --             players = elements,
    --             item = data.item
    --         }
    --     )
    -- end

    cb("ok")
end)

-- local plateIn = {}

RegisterNUICallback("UseItem", function(data, cb)
    -- TriggerServerEvent("esx:useItem", data.item.name)
    TriggerServerEvent('taeratto_inventory:server:useItem', data.item)
    -- self.remote._UsableItem(data.item)

    if shouldCloseInventory(data.item.name) then
        closeInventory()
    else
        Citizen.Wait(250)
        loadPlayerInventory()
    end

    cb("ok")
end)

RegisterNUICallback("DropItem", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then return end

    -- if data.item.name == "identitycard" or data.item.name == "drivercard" or data.item.name == "weaponcard" then
    --   exports['mythic_notify']:DoCustomHudText('inform', "ไม่สามารถทิ้งได้", 4000)
    -- elseif type(data.number) == "number" and math.floor(data.number) == data.number then
    --     TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
    -- end

    Wait(250)
    loadPlayerInventory()

    cb("ok")
end)

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49,
                 1, false, false, false)
    RemoveAnimDict(animDict)
end

RegisterNUICallback("GiveItem", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer -- = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    -- for i = 1, #players, 1 do
    --     if players[i] ~= PlayerId() then
    --         if GetPlayerServerId(players[i]) == data.player then
    --             foundPlayer = true
    --         end
    --     end
    -- end

    -- if foundPlayer then
    --     local count = tonumber(data.number)
    --     playAnim('mp_common', 'givetake1_a', 2500)

    --     if data.item.type == "item_weapon" then
    --         count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
    --     elseif data.item.name == "identitycard" then
    --       for i = 1, #players, 1 do
    --           if players[i] ~= PlayerId() then
    --               if GetPlayerServerId(players[i]) == data.player then
    --                   TriggerEvent('monster-idcard:open', GetPlayerServerId(players[i]))
    --               end
    --           end
    --       end

    --     elseif data.item.name == "drivercard" then
    --       for i = 1, #players, 1 do
    --           if players[i] ~= PlayerId() then
    --               if GetPlayerServerId(players[i]) == data.player then
    --                   TriggerEvent('monster-idcard:open', GetPlayerServerId(players[i]), "driver")

    --               end
    --           end
    --       end

    --     elseif data.item.name == "weaponcard" then
    --       -- TriggerEvent('monster-idcard:open', data.player)
    --       for i = 1, #players, 1 do
    --           if players[i] ~= PlayerId() then
    --               if GetPlayerServerId(players[i]) == data.player then
    --                   TriggerEvent('monster-idcard:open', GetPlayerServerId(players[i]), "weapon")

    --               end
    --           end
    --       end

    --     else
    --       TriggerServerEvent("esx:giveInventoryItem", data.player, data.item.type, data.item.name, count)
    --     end
    --     Wait(250)
    --     loadPlayerInventory()
    -- else
    --     exports['mythic_notify']:SendAlert('error', _U("player_nearby"))
    -- end
    cb("ok")
end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then return true end
    end

    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then return true end
    end

    return false
end

function loadPlayerInventory()
    print('Function: loadPlayerInventory')
    TriggerServerEvent('taeratto_inventory:server:loadPlayerInventory', GetPlayerServerId(PlayerId()))
    -- self.remote._loadPlayerInventory() -- vrp 2
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isInInventory then
            local playerPed = PlayerPedId()
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, Keys["W"], true) -- W
            DisableControlAction(0, Keys["A"], true) -- A
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)

            DisableControlAction(0, Keys["R"], true) -- Reload
            DisableControlAction(0, Keys["SPACE"], true) -- Jump
            DisableControlAction(0, Keys["Q"], true) -- Cover
            DisableControlAction(0, Keys["TAB"], true) -- Select Weapon
            DisableControlAction(0, Keys["F"], true) -- Also 'enter'?

            DisableControlAction(0, Keys["F1"], true) -- Disable phone
            DisableControlAction(0, Keys["F2"], true) -- Inventory
            DisableControlAction(0, Keys["F3"], true) -- Animations
            DisableControlAction(0, Keys["F6"], true) -- Job

            DisableControlAction(0, Keys["V"], true) -- Disable changing view
            DisableControlAction(0, Keys["C"], true) -- Disable looking behind
            DisableControlAction(0, Keys["X"], true) -- Disable clearing animation
            DisableControlAction(2, Keys["P"], true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, Keys["LEFTCTRL"], true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end
end)

-- Create Blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-265.66, -962.97, 31.22) -- local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
    SetBlipSprite(blip, 52)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Job Item') -- AddTextComponentString(_U('shops'))
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('taeratto_inventory:client:setItems')
AddEventHandler('taeratto_inventory:client:setItems', function(data)
    print("Function: SetItems")
    items = {}
    local inventory = data.inventory
    -- local accounts = data.accounts
    -- local money = data.money
    -- local weapons = data.weapons

    -- if Config.IncludeCash and money ~= nil and money > 0 then
    --     moneyData = {
    --         label = "cash",
    --         name = "cash",
    --         type = "item_money",
    --         count = money,
    --         usable = false,
    --         rare = false,
    --         limit = -1,
    --         canRemove = true
    --     }

    --     table.insert(items, moneyData)
    -- end

    -- if Config.IncludeAccounts and accounts ~= nil then
    --     for key, value in pairs(accounts) do
    --         if not shouldSkipAccount(accounts[key].name) then
    --             local canDrop = accounts[key].name ~= "bank"

    --             if accounts[key].money > 0 then
    --                 accountData = {
    --                     label = accounts[key].label,
    --                     count = accounts[key].money,
    --                     type = "item_account",
    --                     name = accounts[key].name,
    --                     usable = false,
    --                     rare = false,
    --                     limit = -1,
    --                     canRemove = canDrop
    --                 }
    --                 table.insert(items, accountData)
    --             end
    --         end
    --     end
    -- end

    local x = {}

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            local usable = false
            local usableType = false
            if value.usableType ~= nil then
                usable = true
                usableType = value.usableType
            end
            table.insert(x, {
                label = value.label,
                name = key,
                -- fullid = key,
                limit = -1,
                usable = usable,
                usabletype = usableType,
                rare = 0,
                canRemove = 1,
                type = "item_standard",
                count = value.amount
            })
            -- print('key: ' .. key .. ' value: ' .. value)
            -- print('inventory[key]: ' .. inventory[key])
            -- inventory.type = "item_standard"
            -- table.insert(items, inventory[key])
        end
        -- print('x: ' .. json.encode(x))
        table.insert(items, x)
        print('items: ' .. json.encode(items[1]))
    end

    -- table.insert( items, {
    --     label = "key",
    --     name = "key",
    --     limit = -1,
    --     usable = false,
    --     rare = 0,
    --     canRemove = 1,
    --     type = "item_standard",
    --     count = value
    -- })

    -- if Config.IncludeWeapons and weapons ~= nil then
    --     for key, value in pairs(weapons) do
    --         local weaponHash = GetHashKey(weapons[key].name)
    --         local playerPed = PlayerPedId()
    --         if HasPedGotWeapon(playerPed, weaponHash, false) and weapons[key].name ~= "WEAPON_UNARMED" then
    --             local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
    --             table.insert(
    --                 items,
    --                 {
    --                     label = weapons[key].label,
    --                     count = ammo,
    --                     limit = -1,
    --                     type = "item_weapon",
    --                     name = weapons[key].name,
    --                     usable = false,
    --                     rare = false,
    --                     canRemove = true
    --                 }
    --             )
    --         end
    --     end
    -- end

    SendNUIMessage({action = "setItems", itemList = items[1]})
end)

-- function TaerAttOInventory:SetItems(data)
--     print("Function: SetItems")
--     items = {}
--     local inventory = data.inventory
--     local accounts = data.accounts
--     local money = data.money
--     local weapons = data.weapons

--     -- if Config.IncludeCash and money ~= nil and money > 0 then
--     --     moneyData = {
--     --         label = "cash",
--     --         name = "cash",
--     --         type = "item_money",
--     --         count = money,
--     --         usable = false,
--     --         rare = false,
--     --         limit = -1,
--     --         canRemove = true
--     --     }

--     --     table.insert(items, moneyData)
--     -- end

--     -- if Config.IncludeAccounts and accounts ~= nil then
--     --     for key, value in pairs(accounts) do
--     --         if not shouldSkipAccount(accounts[key].name) then
--     --             local canDrop = accounts[key].name ~= "bank"

--     --             if accounts[key].money > 0 then
--     --                 accountData = {
--     --                     label = accounts[key].label,
--     --                     count = accounts[key].money,
--     --                     type = "item_account",
--     --                     name = accounts[key].name,
--     --                     usable = false,
--     --                     rare = false,
--     --                     limit = -1,
--     --                     canRemove = canDrop
--     --                 }
--     --                 table.insert(items, accountData)
--     --             end
--     --         end
--     --     end
--     -- end

--     local x = {}

--     if inventory ~= nil then
--         for key, value in pairs(inventory) do
--             local argsSplit = splitString(key, "|")
--             local typeEdible
--             local usableType = false
--             if argsSplit[2] ~= nil then
--                 typeEdible = argsSplit[2]
--                 usableType = argsSplit[1]
--             else
--                 typeEdible = argsSplit
--             end
--             table.insert(x, {
--                 label = typeEdible,
--                 name = typeEdible,
--                 fullid = key,
--                 limit = -1,
--                 usable = true,
--                 usabletype = usableType,
--                 rare = 0,
--                 canRemove = 1,
--                 type = "item_standard",
--                 count = value
--             })
--             print('key: ' .. key .. ' value: ' .. value)
--             print('inventory[key]: ' .. inventory[key])
--             -- inventory.type = "item_standard"
--             -- table.insert(items, inventory[key])
--         end
--         print('x: ' .. json.encode(x))
--         table.insert(items, x)
--         print('items: ' .. json.encode(items[1]))
--     end

--     -- table.insert( items, {
--     --     label = "key",
--     --     name = "key",
--     --     limit = -1,
--     --     usable = false,
--     --     rare = 0,
--     --     canRemove = 1,
--     --     type = "item_standard",
--     --     count = value
--     -- })

--     -- if Config.IncludeWeapons and weapons ~= nil then
--     --     for key, value in pairs(weapons) do
--     --         local weaponHash = GetHashKey(weapons[key].name)
--     --         local playerPed = PlayerPedId()
--     --         if HasPedGotWeapon(playerPed, weaponHash, false) and weapons[key].name ~= "WEAPON_UNARMED" then
--     --             local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
--     --             table.insert(
--     --                 items,
--     --                 {
--     --                     label = weapons[key].label,
--     --                     count = ammo,
--     --                     limit = -1,
--     --                     type = "item_weapon",
--     --                     name = weapons[key].name,
--     --                     usable = false,
--     --                     rare = false,
--     --                     canRemove = true
--     --                 }
--     --             )
--     --         end
--     --     end
--     -- end

--     SendNUIMessage({action = "setItems", itemList = items[1]})

-- end

-- function TaerAttOInventory:UsableItem()

-- end

local restricted = false

RegisterCommand('closeinv', function() closeInventory() end, restricted)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then closeInventory() end
end)

-- TaerAttOInventory.tunnel = {}
-- TaerAttOInventory.tunnel.SetItems = TaerAttOInventory.SetItems

-- vRP:registerExtension(TaerAttOInventory)
