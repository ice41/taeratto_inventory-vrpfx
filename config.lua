Config = {}
Config.Locale = "en"
Config.IncludeCash = true -- Include cash in inventory?
Config.IncludeWeapons = true -- Include weapons in inventory?
Config.IncludeAccounts = true -- Include accounts (bank, black money, ...)?
Config.ExcludeAccountsList = {"bank"} -- List of accounts names to exclude from inventory
Config.OpenControl = 289 -- Key for opening inventory. Edit html/js/config.js to change key for closing it.

-- List of item names that will close ui when used
Config.CloseUiItems = {
    "headbag", "fishingrod", "identitycard", "keycard", "lockpick", "bandage",
    "medikit", "blowpipe", "drivercard", "weaponcard", "radio", "tunerchip",
    "NoctisA", "CindyA", "bmxcall", "hamburger", "water", "bread", "icetea",
    "mixapero", "energy", "enginekiller"
}

items = {}

items["water"] = {"Water","", "drink",0,-25,0.5}
items["milk"] = {"Milk","", "drink",0,-5,0.5}
items["coffee"] = {"Coffee","","drink",0,-10,0.2}
items["tea"] = {"Tea","","drink",0,-15,0.2}
items["icetea"] = {"Ice-Tea","","drink",0,-20, 0.5}
items["orangejuice"] = {"Orange Juice","","drink",0,-25,0.5}
items["cocacola"] = {"Coca Cola","","drink",0,-35,0.3}
items["redbull"] = {"Red Bull","","drink",0,-40,0.3}
items["lemonade"] = {"Lemonade","","drink",0,-45,0.3}
items["vodka"] = {"Vodka","","drink",15,-65,0.5}

--FOOD

-- create Breed item
items["bread"] = {"Bread","","eat",-10,0,0.5}
items["donut"] = {"Donut","","eat",-15,0,0.2}
items["tacos"] = {"Tacos","","eat",-20,0,0.2}
items["sandwich"] = {"Sandwich","A tasty snack.","eat",-25,0,0.5}
items["kebab"] = {"Kebab","","eat",-45,0,0.85}
items["pdonut"] = {"Premium Donut","","eat",-25,0,0.5}
items["catfish"] = {"Catfish","","eat",10,15,0.3}
items["bass"] = {"Bass","","eat",10,15,0.3}

Config.ShopBlipID = 52
Config.LiquorBlipID = 93
Config.YouToolBlipID = 402
Config.PrisonShopBlipID = 52
Config.WeedStoreBlipID = 140
Config.WeaponShopBlipID = 110

Config.ShopLength = 14
Config.LiquorLength = 10
Config.YouToolLength = 2
Config.PrisonShopLength = 2

Config.Color = 2
Config.WeaponColor = 1

Config.WeaponLiscence = {x = 12.47, y = -1105.5, z = 29.8}
Config.LicensePrice = 5000

Config.Zones = {

    TwentyFourSeven = {
        Items = {},
        Pos = {
            {x = 373.875, y = 325.896, z = 103.566},
            {x = 2557.458, y = 382.282, z = 108.622},
            {x = -3038.939, y = 585.954, z = 7.908},
            {x = -3241.927, y = 1001.462, z = 12.830},
            {x = 547.431, y = 2671.710, z = 42.156},
            {x = 1961.464, y = 3740.672, z = 32.343},
            {x = 2678.916, y = 3280.671, z = 55.241},
            {x = 1729.216, y = 6414.131, z = 35.037}
        }
    },

    RobsLiquor = {
        Items = {},
        Pos = {
            {x = 1135.808, y = -982.281, z = 46.415},
            {x = -1222.915, y = -906.983, z = 12.326},
            {x = -1487.553, y = -379.107, z = 10.163},
            {x = -2968.243, y = 390.910, z = 15.043},
            {x = 1166.024, y = 2708.930, z = 38.157},
            {x = 1392.562, y = 3604.684, z = 34.980},
            {x = 25.723, y = -1346.966, z = 29.497},
            {x = -1393.409, y = -606.624, z = 30.319},
            {x = -1037.618, y = -2737.399, z = 20.169}
        }
    },

    LTDgasoline = {
        Items = {},
        Pos = {
            {x = -48.519, y = -1757.514, z = 29.421},
            {x = 1163.373, y = -323.801, z = 69.205},
            {x = -707.501, y = -914.260, z = 19.215},
            {x = -1820.523, y = 792.518, z = 138.118},
            {x = 1698.388, y = 4924.404, z = 42.063}
        }
    },

    PillboxHospital = {
        Items = {},
        Pos = {
            -- {x = 316.8,   y = -588.12, z = 43.29},

        }
    },

    JobCenter = {
        Items = {},
        Pos = {
            -- {x = -265.66,   y = -962.97, z = 31.22},

        }
    }
}
