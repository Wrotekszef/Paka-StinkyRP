Config               = {}

Config.DrawDistance  = 5
Config.Size          = { x = 2.0, y = 2.0, z = 0.5 }
Config.Color         = { r = 0, g = 0, b = 0 }
Config.itemtype          = 23
Config.Locale        = 'en'

Config.LicenseEnable = true
Config.LicensePrice  = 5000

Config.Zones = {
	GunShop = {
		Legal = true,
		nazwanamapie = "Sklep z bronią",
		Items = {
			{ weapon = 'WEAPON_PISTOL', label = 'Pistolet', price = 80000, ammoPrice = 200, AmmoToGive = 48, itemtype = 'weapon' },
			{ weapon = 'WEAPON_KNIFE', label = 'Nóż', price = 15000, itemtype = 'weapon' },
			{ weapon = 'clip', label = 'Magazynek', price = 10000, itemtype = 'item' }
		},
		Locations = {
			vector3(-662.1, -935.3, 20.8),
			vector3(810.2, -2157.3, 28.6),
			vector3(1693.4, 3759.5, 33.7),
			vector3(-330.2, 6083.8, 30.4),
			vector3(22.0, -1107.2, 28.8),
			vector3(2567.6, 294.3, 107.7),
			vector3(-1117.5, 2698.6, 17.5),
			vector3(842.4, -1033.4, 27.1)
		}
	},

	GunShopDS = {
		Legal = false,
		Items = {
            { weapon = 'WEAPON_PISTOL', label = 'Pistolet', price = 150000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_COMBATPISTOL', label = 'Pistolet Bojowy', price = 150000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_SNSPISTOL', label = 'Pukawka', price = 275000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
            { weapon = 'WEAPON_SNSPISTOL_MK2', label = 'Pukawka MK2', price = 290000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
            { weapon = 'WEAPON_CERAMICPISTOL', label = 'Ceramic Pistolet', price = 290000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
            { weapon = 'WEAPON_VINTAGEPISTOL', label = 'Pistolet Vintage', price = 300000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
            { weapon = 'WEAPON_PISTOL_MK2', label = 'Pistolet MK2', price = 305000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_HEAVYPISTOL', label = 'Ciężki Pistolet', price = 360000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
            { weapon = 'WEAPON_COMBATPDW', label = 'PDW', price = 4500000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
            { weapon = 'WEAPON_COMPACTRIFLE', label = 'Krótki AK-47', price = 6500000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon' },
        },
        Locations = {
            vector3(-467.61044311523, 6287.8364257813, 13.612411499023-1.20),
        } 
	},

	GunShopLosSantos = {
		Legal = false,
		Items = {
            { weapon = 'WEAPON_GLOCK', label = 'Glock 17', price = 200000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_MICROSMG', label = 'Micro SMG', price = 2250000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_MINISMG', label = 'Mini SMG', price = 2000000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_BAT', label = 'Bejsbol', price = 10000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_MACHETE', label = 'Maczeta', price = 10000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_KNUCKLE', label = 'Kastet', price = 10000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_WRENCH', label = 'Klucz do rur', price = 10000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
            { weapon = 'WEAPON_HATCHET', label = 'Siekiera', price = 10000, ammoPrice = 200, AmmoToGive = 100, itemtype = 'weapon'},
        },
        Locations = {
            vector3(-569.14343261719, -1798.1746826172, 22.709356307983-1.20),
        } 
	},

	stinkycoin = {
        Legal = false,
        Coins = true,
        nazwanamapie = "Stinky Coin Shop",
        Items = {
            { weapon = 'kupon10', label = 'Kupon 10zł Stinky', price = 10000, itemtype = 'item' },
            { weapon = 'kupon50', label = 'Kupon 50zł Stinky', price = 45000, itemtype = 'item' },
            { weapon = 'bon44', label = 'Vip 3 dni', price = 50000, itemtype = 'item' },
            { weapon = 'WEAPON_PISTOL', label = 'PISTOLET', price = 1000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_VINTAGEPISTOL', label = 'VINTAGE', price = 1000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_SNSPISTOL_MK2', label = 'SNS MK2', price = 1000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_PISTOL_MK2', label = 'PISTOL MK2', price = 1000, itemtype = 'weapon' },
            { weapon = 'brazowa', label = 'Stinky Brazowa Chest', price = 7500, itemtype = 'item' },
            { weapon = 'srebrna', label = 'Stinky Srebrna Chest', price = 20000, itemtype = 'item' },
            { weapon = 'zlota', label = 'Stinky Zlota Chest', price = 50000, itemtype = 'item' },
        },
        Locations = {
            vector3(193.56, -939.99, 29.60+1.00),
        } 
    },

	mafia = {
        Legal = false,
        job = true,
        Items = {
            { weapon = 'kawa', label = 'X-Gamer', price = 500, itemtype = 'item' },
            { weapon = 'kamzasmall', label = 'Mała kamizelka', price = 50000, itemtype = 'item' },
            { weapon = 'kamzaduza', label = 'Duża kamizelka', price = 100000, itemtype = 'item' },
			{ weapon = 'WEAPON_VINTAGEPISTOL', label = 'VINTAGE PISTOL', price = 200000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_SNSPISTOL', label = 'SNS PISTOL', price = 150000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_SNSPISTOL_MK2', label = 'SNS MK2', price = 200000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_PISTOL_MK2', label = 'PISTOL MK2', price = 200000, itemtype = 'weapon' },
			{ weapon = 'WEAPON_CERAMICPISTOL', label = 'CERAMIC PISTOL', price = 200000, itemtype = 'weapon' },
            { weapon = 'WEAPON_BAT', label = 'KIJ', price = 10000, itemtype = 'weapon' },
            { weapon = 'WEAPON_KNIFE', label = 'NÓŻ', price = 10000, itemtype = 'weapon' },
            { weapon = 'WEAPON_MACHETE', label = 'MACZETA', price = 10000, itemtype = 'weapon' },
            { weapon = 'WEAPON_SWITCHBLADE', label = 'SCYZORYK', price = 10000, itemtype = 'weapon' },
        },
        Locations = {
            vector3(1394.6587, 1144.4741, 113.3358),
        } 
    },
}