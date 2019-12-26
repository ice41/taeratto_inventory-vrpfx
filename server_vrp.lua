-- local TaerAttOInventory = class("TaerAttOInventory", vRP.Extension)
-- convert from vRP 2
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "taeratto_inventory")

local cfgItem = module("vrp", "cfg/items")


RegisterServerEvent('taeratto_inventory:server:loadPlayerInventory')
AddEventHandler('taeratto_inventory:server:loadPlayerInventory', function(target)
    local user_id = vRP.getUserId({source})
    
    if user_id ~= nil then
        local data = vRP.getUserDataTable({user_id})
        if data == nil then
            -- print('data == nil: ')
        elseif data then

            -- print('json data item: '.. json.encode())
            -- print('items: ' .. json.encode(cfgItem.items['bank_money']))
            local inventory = {}
            local x = {}
            for k,v in pairs(data.inventory) do
                x[k] = {
                    amount = v.amount,
                    label = items[k][1],
                    usableType = items[k][3]
                }
            end

            print('x: '.. json.encode(x))

            inventory = x

            TriggerClientEvent('taeratto_inventory:client:setItems', source, {
                inventory = inventory
            })
            -- print('data ~= nil')
        end
        -- if data then
        --     -- for k,v in pairs(data.inventory) do
        --     --     -- print("key data: ".. k)
        --     -- end
        --     print('true data')
            
        -- end
        
        -- print('true')
    end
end)

RegisterServerEvent('taeratto_inventory:server:useItem')
AddEventHandler('taeratto_inventory:server:useItem', function(idname)
    local user_id = vRP.getUserId({source})
    -- vRP.items

    print('idname: '.. json.encode(idname))
    
    -- local name = vRP.getItemName(idname.name)
    -- local item = items[idname.name]
    -- print("item in use item: ".. json.encode(item))
      if user_id ~= nil then
        if vRP.tryGetInventoryItem({user_id, idname.name, 1, false}) and idname.usable then
        --   if vary_hunger ~= 0 then vRP.varyHunger(user_id,vary_hunger) end
        --   if vary_thirst ~= 0 then vRP.varyThirst(user_id,vary_thirst) end
        -- 4 hunger 5 thirst in array
        local item = items[idname.name]
        print('usable: '.. idname.usabletype)
        if idname.usabletype == 'drink' then
            vRP.varyThirst({user_id, item[5]})
            -- play_drinks({player})
            local seq = {
                {"mp_player_intdrink","intro_bottle",1},
                {"mp_player_intdrink","loop_bottle",1},
                {"mp_player_intdrink","outro_bottle",1}
              }
            
              vRPclient.playAnim(source,{false,seq,false})
            -- vRPclient.playAnim(source,{false,seq,true})
        elseif idname.usabletype == 'eat' then
            vRP.varyHunger({user_id, item[4]})
            -- play_eats({player}) --HAHAHA vRP dunko
            local seq = {
                {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
                {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
                {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
                {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
              }
            
              vRPclient.playAnim(source,{false,seq,false})
            -- vRPclient.playAnim(source,{false,seq,true})
        end

        
        
        --   if ftype == "drink" then
        --     vRPclient.notify(player,{"~b~ Drinking "..name.."."})
        --     play_drink(player)
        --   elseif ftype == "eat" then
        --     vRPclient.notify(player,{"~o~ Eating "..name.."."})
        --     play_eat(player)
        --   end
        print('ok')

        --   vRP.closeMenu(player)
        end
      end
end)

local function play_eats(player)
    local seq = {
      {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
      {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
      {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
      {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
    }
  
    vRPclient.playAnim(player,{true,{seq},false})
  end
  
  local function play_drinks(player)
    local seq = {
      {"mp_player_intdrink","intro_bottle",1},
      {"mp_player_intdrink","loop_bottle",1},
      {"mp_player_intdrink","outro_bottle",1}
    }
  
    vRPclient.playAnim(player,{true,{seq},false})
  end

-- function TaerAttOInventory.tunnel:loadPlayerInventory(target)
--     local user = getUser(target) -- vRP.users_by_source[target]
--     print('loadPlayerInventory : server: target: ' .. target)
--     local inventory = {}
--     inventory = user:getInventory()
--     print('Inventory: ' .. json.encode(inventory))
--     self.remote._SetItems(user.source, {
--         money = nil,
--         accounts = nil,
--         inventory = inventory,
--         weapons = nil
--     })
-- end

-- function TaerAttOInventory.tunnel:UsableItem(data) -- vRP 2
--     local user = getUser(source)
--     if data.usabletype == 'edible' then
--         local edibles = getEdibles()
--         local cfgEdible = getCfgEdible()
--         local types = getTypesEdible()
--         local effects = getEffectsEdible()
--         -- print('UsableItem: ' .. itemName)
--         -- print('edibles: ' .. json.encode(edible.edibles))

--         -- local temp = splitString(itemName, '|')
--         -- print('temp: ' .. json.encode(temp[2]))

--         local citem = vRP.EXT.Inventory:computeItem(data.fullid)
--         local edible = edibles[citem.args[2]]
--         local etype = types[edible.type]

--         if user:tryTakeItem(data.fullid, 1, true) then -- available check
--             if user.edible_action:perform(cfgEdible.action_delay) then
--                 user:tryTakeItem(data.fullid, 1, nil, true) -- consume

--                 etype[2](user, edible)

--                 -- effects
--                 for id, value in pairs(edible.effects) do
--                     local effect = effects[id]
--                     if effect then
--                         -- on_effect
--                         effect(user, value)
--                     end
--                 end
--             else
--                 vRP.EXT.Base.remote._notify(user.source, lang.common.must_wait(
--                                                 {user.edible_action:remaining()}))
--             end
--         end
--     else
--         TriggerClientEvent('mythic_notify:client:SendAlert', user.source, {type = 'error', text = 'ยังไม่เปิดให้บริการในส่วนนี้', length = 8500})
--     end

--     -- if user:tryTakeItem(itemName, 1, true) then
--     --     user:varyVital("food", 30)
--     --     user:varyVital("water", 30)
--     --     vRP.EXT.Survival.remote._varyHealth(user.source, 25)

--     --     vRP.EXT.Base.remote._notify(user.source, "~b~Drinking Vodka.")
--     --     local seq = {
--     --         {"mp_player_intdrink", "intro_bottle", 1},
--     --         {"mp_player_intdrink", "loop_bottle", 1},
--     --         {"mp_player_intdrink", "outro_bottle", 1}
--     --     }
--     --     vRP.EXT.Base.remote._playAnim(user.source, true, seq, false)
--     --     SetTimeout(5000, function()
--     --         self.remote.playMovement(user.source, "MOVE_M@DRUNK@VERYDRUNK",
--     --                                  true, true, false, false)
--     --         self.remote.playScreenEffect(user.source, "Rampage", 120)
--     --         user:varyExp("physical", "addiction", 0.08)
--     --     end)
--     --     SetTimeout(120000,
--     --                function()
--     --         self.remote.resetMovement(user.source, false)
--     --     end)

--     -- end
-- end

ESX = nil
ServerItems = {}
itemShopList = {}
local hasSqlRun = false

-- TriggerEvent(
-- 	"esx:getSharedObject",
-- 	function(obj)
-- 		ESX = obj
-- 	end
-- )

-- Load items
-- AddEventHandler('onMySQLReady', function()
-- 	hasSqlRun = true
-- 	-- LoadShop()
-- end)

-- extremely useful when restarting script mid-game
-- Citizen.CreateThread(function()
-- 	Citizen.Wait(2000) -- hopefully enough for connection to the SQL server

-- 	if not hasSqlRun then
-- 		-- LoadShop()
-- 		hasSqlRun = true
-- 	end
-- end)

--[[vehicleKeys = {}

RegisterNetEvent('monster_inventoryhud:server:setKeys')
AddEventHandler('monster_inventoryhud:server:setKeys', function(vehicle, plate)
	table.insert(vehicleKeys, {vehicle = vehicle, plate = plate})
end)

RegisterNetEvent('monster_inventoryhud:server:delKeys')
AddEventHandler('monster_inventoryhud:server:delKeys', function(vehicle, plate)
	for k,v in pairs(vehicleKeys) do
		if v.plate == plate then
			table.remove(vehicleKeys, k)
		end
	end
end)
--]]
-- ESX.RegisterServerCallback(
-- 	"esx_inventoryhud:getPlayerInventory",
-- 	function(source, cb, target)
-- 		local targetXPlayer = ESX.GetPlayerFromId(target)

-- 		if targetXPlayer ~= nil then
-- 			cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
-- 		else
-- 			cb(nil)
-- 		end
-- 	end
-- )

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler("esx_inventoryhud:tradePlayerItem",
                function(from, target, type, itemName, itemCount)
    local _source = from

    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if type == "item_standard" then
        local sourceItem = sourceXPlayer.getInventoryItem(itemName)
        local targetItem = targetXPlayer.getInventoryItem(itemName)

        if itemCount > 0 and sourceItem.count >= itemCount then
            if targetItem.limit ~= -1 and (targetItem.count + itemCount) >
                targetItem.limit then
            else
                sourceXPlayer.removeInventoryItem(itemName, itemCount)
                targetXPlayer.addInventoryItem(itemName, itemCount)
            end
        end
    elseif type == "item_money" then
        if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
            sourceXPlayer.removeMoney(itemCount)
            targetXPlayer.addMoney(itemCount)
        end
    elseif type == "item_account" then
        if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >=
            itemCount then
            sourceXPlayer.removeAccountMoney(itemName, itemCount)
            targetXPlayer.addAccountMoney(itemName, itemCount)
        end
    elseif type == "item_weapon" then
        if not targetXPlayer.hasWeapon(itemName) then
            sourceXPlayer.removeWeapon(itemName)
            targetXPlayer.addWeapon(itemName, itemCount)
        end
    end
end)

RegisterCommand("openinventory", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "inventory.openinventory") then
        local target = tonumber(args[1])
        local targetXPlayer = ESX.GetPlayerFromId(target)

        if targetXPlayer ~= nil then
            TriggerClientEvent("esx_inventoryhud:openPlayerInventory", source,
                               target, targetXPlayer.name)
        else
            TriggerClientEvent("chatMessage", source, "^1" .. _U("no_player"))
        end
    else
        TriggerClientEvent("chatMessage", source, "^1" .. _U("no_permissions"))
    end
end)

function LoadShop()
    -- while ESX == nil do
    -- 	Citizen.Wait(500)
    -- end
    local itemResult -- = exports['es_extended']:getSharedItems() --MySQL.Sync.fetchAll('SELECT * FROM items')

    local shopResult -- = MySQL.Sync.fetchAll('SELECT * FROM shops')

    local itemInformation = {}
    for i = 1, #itemResult, 1 do

        if itemInformation[itemResult[i].name] == nil then
            itemInformation[itemResult[i].name] = {}
        end

        --[[itemInformation[itemResult[i].name].label = itemResult[i].label
		itemInformation[itemResult[i].name].limit = itemResult[i].limit--]]
        itemInformation[itemResult[i].name].name = itemResult[i].name
        itemInformation[itemResult[i].name].label = itemResult[i].label
        itemInformation[itemResult[i].name].limit = itemResult[i].limit
        itemInformation[itemResult[i].name].rare = itemResult[i].rare
        itemInformation[itemResult[i].name].can_remove =
            itemResult[i].can_remove
    end

    for i = 1, #shopResult, 1 do
        if itemShopList[shopResult[i].store] == nil then
            itemShopList[shopResult[i].store] = {}
        end

        if itemInformation[shopResult[i].item].limit == -1 then
            itemInformation[shopResult[i].item].limit = 99999999
        end

        --[[table.insert(itemShopList[shopResult[i].store], {
			label = itemInformation[shopResult[i].item].label,
			item  = shopResult[i].item,
			price = shopResult[i].price,
			limit = itemInformation[shopResult[i].item].limit
		})--]]
        table.insert(itemShopList[shopResult[i].store],
                     { -- [shopResult[i].store]
            type = "item_standard",
            name = shopResult[i].item, -- itemInformation[itemResult[i].name].name,
            label = itemInformation[shopResult[i].item].label, -- itemInformation[itemResult[i].name].label,
            limit = itemInformation[shopResult[i].item].limit, -- itemInformation[itemResult[i].name].limit,
            rare = itemInformation[shopResult[i].item].rare,
            can_remove = itemInformation[shopResult[i].item].can_remove,
            price = shopResult[i].price, -- itemInformation[itemResult[i].name].price,
            count = 99999999
        })
    end
end

-- ESX.RegisterServerCallback('monster_inventoryhud:requestDBItems', function(source, cb)
-- 	if not hasSqlRun then
-- 		textNotification(source, 'The shop database has not been loaded yet, try again in a few moments.')
-- 	end

-- 	cb(itemShopList)
-- end)

function textNotification(source, text)
    -- TriggerClientEvent("Monster_base:textNotification", source, text, "inform")
    TriggerClientEvent('mythic_notify:client:SendAlert', source,
                       {type = 'inform', text = text})
end

RegisterServerEvent("suku:sendShopItems")
AddEventHandler("suku:sendShopItems",
                function(source, itemList) itemShopList = itemList end)

-- ESX.RegisterServerCallback("suku:getShopItems", function(source, cb, shoptype)
-- 	--[[itemShopList = {}
-- 	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
-- 	local itemInformation = {}

-- 	for i=1, #itemResult, 1 do

-- 		if itemInformation[itemResult[i].name] == nil then
-- 			itemInformation[itemResult[i].name] = {}
-- 		end

-- 		itemInformation[itemResult[i].name].name = itemResult[i].name
-- 		itemInformation[itemResult[i].name].label = itemResult[i].label
-- 		itemInformation[itemResult[i].name].limit = itemResult[i].limit
-- 		itemInformation[itemResult[i].name].rare = itemResult[i].rare
-- 		itemInformation[itemResult[i].name].can_remove = itemResult[i].can_remove
-- 		itemInformation[itemResult[i].name].price = itemResult[i].price--]]

-- 		--[[if shoptype == "regular" then
-- 			for _, v in pairs(Config.Shops.RegularShop.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end
-- 		if shoptype == "robsliquor" then
-- 			for _, v in pairs(Config.Shops.RobsLiquor.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end
-- 		if shoptype == "youtool" then
-- 			for _, v in pairs(Config.Shops.YouTool.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end
-- 		if shoptype == "prison" then
-- 			for _, v in pairs(Config.Shops.PrisonShop.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end
-- 		if shoptype == "weaponshop" then
-- 			local weapons = Config.Shops.WeaponShop.Weapons
-- 			for _, v in pairs(Config.Shops.WeaponShop.Weapons) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_weapon",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = 1,
-- 						ammo = v.ammo,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end

-- 			local ammo = Config.Shops.WeaponShop.Ammo
-- 			for _,v in pairs(Config.Shops.WeaponShop.Ammo) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_ammo",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = 1,
-- 						weaponhash = v.weaponhash,
-- 						ammo = v.ammo,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end

-- 			for _, v in pairs(Config.Shops.WeaponShop.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end
-- 	end--]]
-- 	cb(itemShopList)
-- end)

-- ESX.RegisterServerCallback("suku:getCustomShopItems", function(source, cb, shoptype, customInventory)
-- 	--[[itemShopList = {}
-- 	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
-- 	local itemInformation = {}

-- 	for i=1, #itemResult, 1 do

-- 		if itemInformation[itemResult[i].name] == nil then
-- 			itemInformation[itemResult[i].name] = {}
-- 		end

-- 		itemInformation[itemResult[i].name].name = itemResult[i].name
-- 		itemInformation[itemResult[i].name].label = itemResult[i].label
-- 		itemInformation[itemResult[i].name].limit = itemResult[i].limit
-- 		itemInformation[itemResult[i].name].rare = itemResult[i].rare
-- 		itemInformation[itemResult[i].name].can_remove = itemResult[i].can_remove
-- 		itemInformation[itemResult[i].name].price = itemResult[i].price

-- 		if shoptype == "normal" then
-- 			for _, v in pairs(customInventory.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end

-- 		if shoptype == "weapon" then
-- 			local weapons = customInventory.Weapons
-- 			for _, v in pairs(customInventory.Weapons) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_weapon",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = 1,
-- 						ammo = v.ammo,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end

-- 			local ammo = customInventory.Ammo
-- 			for _,v in pairs(customInventory.Ammo) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_ammo",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = 1,
-- 						weaponhash = v.weaponhash,
-- 						ammo = v.ammo,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end

-- 			for _, v in pairs(customInventory.Items) do
-- 				if v.name == itemResult[i].name then
-- 					table.insert(itemShopList, {
-- 						type = "item_standard",
-- 						name = itemInformation[itemResult[i].name].name,
-- 						label = itemInformation[itemResult[i].name].label,
-- 						limit = itemInformation[itemResult[i].name].limit,
-- 						rare = itemInformation[itemResult[i].name].rare,
-- 						can_remove = itemInformation[itemResult[i].name].can_remove,
-- 						price = itemInformation[itemResult[i].name].price,
-- 						count = 99999999
-- 					})
-- 				end
-- 			end
-- 		end
-- 	end--]]
-- 	cb(itemShopList)
-- end)

RegisterNetEvent("suku:SellItemToPlayer")
AddEventHandler("suku:SellItemToPlayer",
                function(source, type, item, count, zone)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
        local targetItem = xPlayer.getInventoryItem(item)
        if targetItem.limit == -1 or
            ((targetItem.count + count) <= targetItem.limit) then
            local list = itemShopList
            for k, v in pairs(list) do
                -- print(k,v,zone)
                if k == zone then
                    for i = 1, #v, 1 do
                        print(v[i].name, v[i].price)
                        if v[i].name == item then
                            local totalPrice = count * v[i].price
                            if xPlayer.getMoney() >= totalPrice then
                                xPlayer.removeMoney(totalPrice)
                                xPlayer.addInventoryItem(item, count)
                                TriggerClientEvent(
                                    'mythic_notify:client:SendAlert', source, {
                                        type = 'success',
                                        text = 'You purchased ' .. count .. " " ..
                                            v[i].label
                                    })
                            else
                                TriggerClientEvent(
                                    'mythic_notify:client:SendAlert', source, {
                                        type = 'error',
                                        text = 'You do not have enough money!'
                                    })
                            end
                        end

                    end
                end
            end
            --[[for i = 1, #list, 1 do
				if list[i].name == item then
					local totalPrice = count * list[i].price
					if xPlayer.getMoney() >= totalPrice then
						xPlayer.removeMoney(totalPrice)
						xPlayer.addInventoryItem(item, count)
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You purchased '..count.." "..list[i].label })
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough money!' })
					end
				end
            end--]]
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {
                type = 'error',
                text = 'You do not have enough space in your inventory!'
            })
        end
    end

    if type == "item_weapon" then
        local targetItem = xPlayer.getInventoryItem(item)
        if targetItem.count < 1 then
            local list = itemShopList
            for i = 1, #list, 1 do
                if list[i].name == item then
                    local targetWeapon =
                        xPlayer.hasWeapon(tostring(list[i].name))
                    if not targetWeapon then
                        local totalPrice = 1 * list[i].price
                        if xPlayer.getMoney() >= totalPrice then
                            xPlayer.removeMoney(totalPrice)
                            xPlayer.addWeapon(list[i].name, list[i].ammo)
                            TriggerClientEvent('mythic_notify:client:SendAlert',
                                               source, {
                                type = 'success',
                                text = 'You purchased a ' .. list[i].label
                            })
                        else
                            TriggerClientEvent('mythic_notify:client:SendAlert',
                                               source, {
                                type = 'error',
                                text = 'You do not have enough money!'
                            })
                        end
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert',
                                           source, {
                            type = 'error',
                            text = 'You already own this weapon!'
                        })
                    end
                end
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {
                type = 'error',
                text = 'You already own this weapon!'
            })
        end
    end

    if type == "item_ammo" then
        local targetItem = xPlayer.getInventoryItem(item)
        local list = itemShopList
        for i = 1, #list, 1 do
            if list[i].name == item then
                local targetWeapon = xPlayer.hasWeapon(list[i].weaponhash)
                if targetWeapon then
                    local totalPrice = count * list[i].price
                    local ammo = count * list[i].ammo
                    if xPlayer.getMoney() >= totalPrice then
                        xPlayer.removeMoney(totalPrice)
                        TriggerClientEvent("suku:AddAmmoToWeapon", source,
                                           list[i].weaponhash, ammo)
                        TriggerClientEvent('mythic_notify:client:SendAlert',
                                           source, {
                            type = 'success',
                            text = 'You purchased ' .. count .. " " ..
                                list[i].label
                        })
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert',
                                           source, {
                            type = 'error',
                            text = 'You do not have enough money!'
                        })
                    end
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source,
                                       {
                        type = 'error',
                        text = 'You do not own the weapon for this ammo type!'
                    })
                end
            end
        end
    end
end)

