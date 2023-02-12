Config = {}

-- [[ SKRZYNKI ]] --
Config["image_source"] = "nui://loot_boxes/img/items/"

Config["chance"] = {
	[1] = { name = "Zwykła", rate = 53 },
	[2] = { name = "Rzadka", rate = 28 },
	[3] = { name = "Epicka", rate = 14 },
	[4] = { name = "Wyjątkowa", rate = 4 },
	[5] = { name = "Legendarna", rate = 1 },
}

Config["exilecases"] = {
    ["dailycase"] = { 
        name = "Exile Daily Case",
        list = {
            { money = 25000, tier = 1 },
        	{ money = 35000, tier = 1 },
            { money = 45000, tier = 1 },
        	{ money = 55000, tier = 1 },
            { money = 65000, tier = 1 },
       		{ money = 75000, tier = 1 },
            { money = 85000, tier = 1 },
        	{ money = 95000, tier = 1 },
            { money = 105000, tier = 2 },
            { money = 115000, tier = 2 },
            { money = 125000, tier = 2 },
            { money = 135000, tier = 2 },
            { money = 145000, tier = 2 },
            { money = 155000, tier = 2 },
            { money = 165000, tier = 2 },
            { money = 175000, tier = 2 },
            { money = 185000, tier = 3 },
            { money = 205000, tier = 3 },
            { money = 215000, tier = 3 },
            { money = 225000, tier = 3 },
            { money = 235000, tier = 3 },
            { money = 245000, tier = 3 },
            { weapon = "WEAPON_PISTOL", amount= 1, tier = 1 },
            { weapon = "WEAPON_SNSPISTOL", amount= 2, tier = 2 },
            { item = "exilecoin", amount= 10000, tier = 5 },
        }
    },
	["brazowa"] = { 
        name = "Exile Brazowa Chest",
        list = {
			{ money = 75000, tier = 1 },
			{ weapon = "WEAPON_PISTOL", amount= 1, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 1, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 1, tier = 1 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 1, tier = 1 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 1, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 1, tier = 1 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 1, tier = 1 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 1, tier = 1 },
			{ item = "exilecoin", amount= 2500, tier = 1 },
			{ money = 200000, tier = 2 },
			{ item = "kupon10", amount= 1, tier = 2 },
			{ item = "bon44", amount= 1, tier = 2 },	---VIP NA 3 dni---
			{ item = "coke_pooch", amount= 100, tier = 2 },
			{ item = "meth_pooch", amount= 150, tier = 2 },
			{ item = "weed_pooch", amount= 250, tier = 2 },
			{ item = "suppressor", amount= 1, tier = 2 },
			{ item = "clip_extended", amount= 1, tier = 2 },
			{ item = "kamzasmall", amount= 1, tier = 2 },
			{ item = "kamzaduza", amount= 1, tier = 2 },
			{ weapon = "WEAPON_PISTOL", amount= 1, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 2, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 2, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 2, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 2, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 2, tier = 2 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 2, tier = 2 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 2, tier = 2 },
			{ item = "exilecoin", amount= 5000, tier = 2 },
			{ item = "cokeperico_pooch", amount= 40, tier = 3 }, ---40 PORCJI KOKAINY PERICO---
			{ weapon = "WEAPON_DOUBLEACTION", amount= 1, tier = 4 },
			{ item = "srebrna", amount= 1, tier = 5 }, ---srebrna skrzynia---
        }
    },
	["srebrna"] = { 
        name = "Exile Srebrna Chest",
        list = {
			{ money = 350000, tier = 1 },
			{ weapon = "WEAPON_PISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 2, tier = 1 },
			{ item = "exilecoin", amount= 7500, tier = 1 },
			{ money = 500000, tier = 2 },
			{ item = "kupon10", amount= 2, tier = 2 },
			{ item = "bon43", amount= 1, tier = 2 },	---VIP NA 7 dni---
			{ item = "coke_pooch", amount= 300, tier = 2 },
			{ item = "meth_pooch", amount= 400, tier = 2 },
			{ item = "weed_pooch", amount= 500, tier = 2 },
			{ item = "suppressor", amount= 2, tier = 2 },
			{ item = "clip_extended", amount= 2, tier = 2 },
			{ item = "kamzasmall", amount= 2, tier = 2 },
			{ item = "kamzaduza", amount= 2, tier = 2 },
			{ weapon = "WEAPON_PISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 5, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 5, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 5, tier = 2 },
			{ item = "exilecoin", amount= 15000, tier = 2 },
			{ item = "kupon20", amount= 2, tier = 3 },
			{ item = "bon1", amount= 1, tier = 3 }, ---Zmiana rejestracji w pojeździe---
			{ item = "kasksaspswat", amount= 1, tier = 4 },
			{ item = "brazowa", amount= 2, tier = 5 },
			{ item = "zlota", amount= 1, tier = 5 },
        }
	},
	["fajerwerkowa"] = { 
        name = "Exile Fajerwerkowa Chest",
        list = {
			{ money = 350000, tier = 1 },
			{ weapon = "WEAPON_PISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 2, tier = 1 },
			{ item = "exilecoin", amount= 7500, tier = 1 },
			{ money = 500000, tier = 2 },
			{ item = "kupon10", amount= 2, tier = 2 },
			{ item = "bon43", amount= 1, tier = 2 },	---VIP NA 7 dni---
			{ item = "coke_pooch", amount= 300, tier = 2 },
			{ item = "meth_pooch", amount= 400, tier = 2 },
			{ item = "weed_pooch", amount= 500, tier = 2 },
			{ item = "suppressor", amount= 2, tier = 2 },
			{ item = "clip_extended", amount= 2, tier = 2 },
			{ item = "kamzasmall", amount= 2, tier = 2 },
			{ item = "kamzaduza", amount= 2, tier = 2 },
			{ weapon = "WEAPON_PISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 5, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 5, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 5, tier = 2 },
			{ item = "exilecoin", amount= 15000, tier = 2 },
			{ item = "kupon20", amount= 2, tier = 3 },
			{ item = "bon1", amount= 1, tier = 3 }, ---Zmiana rejestracji w pojeździe---
			{ item = "kasksaspswat", amount= 1, tier = 4 },
			{ item = "brazowa", amount= 2, tier = 5 },
			{ item = "zlota", amount= 1, tier = 5 },
        }
    },
	["szampanowa"] = { 
        name = "Exile Szampanowa Chest",
        list = {
			{ money = 350000, tier = 1 },
			{ weapon = "WEAPON_PISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 2, tier = 1 },
			{ item = "exilecoin", amount= 7500, tier = 1 },
			{ money = 500000, tier = 2 },
			{ item = "kupon10", amount= 2, tier = 2 },
			{ item = "bon43", amount= 1, tier = 2 },	---VIP NA 7 dni---
			{ item = "coke_pooch", amount= 300, tier = 2 },
			{ item = "meth_pooch", amount= 400, tier = 2 },
			{ item = "weed_pooch", amount= 500, tier = 2 },
			{ item = "suppressor", amount= 2, tier = 2 },
			{ item = "clip_extended", amount= 2, tier = 2 },
			{ item = "kamzasmall", amount= 2, tier = 2 },
			{ item = "kamzaduza", amount= 2, tier = 2 },
			{ weapon = "WEAPON_PISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 5, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 5, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 5, tier = 2 },
			{ item = "exilecoin", amount= 15000, tier = 2 },
			{ item = "kupon20", amount= 2, tier = 3 },
			{ item = "bon1", amount= 1, tier = 3 }, ---Zmiana rejestracji w pojeździe---
			{ item = "kasksaspswat", amount= 1, tier = 4 },
			{ item = "brazowa", amount= 2, tier = 5 },
			{ item = "zlota", amount= 1, tier = 5 },
        }
    },
	["zlota"] = { 
        name = "Exile Zlota Chest",
        list = {
			{ money = 1000000, tier = 1 },
			{ weapon = "WEAPON_PISTOL", amount= 12, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 12, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 12, tier = 1 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 12, tier = 1 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 12, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 12, tier = 1 },
			{ weapon = "WEAPON_COMBATPISTOL", amount= 12, tier = 1 },
			{ weapon = "WEAPON_FIVESEVEN", amount= 12, tier = 1 },
			{ item = "exilecoin", amount= 25000, tier = 1 },
			{ money = 2000000, tier = 2 },
			{ item = "bon1", amount= 1, tier = 2 }, ---Zmiana rejestracji w pojeździe---
			{ item = "kupon50", amount= 1, tier = 2 },
			{ item = "suppressor", amount= 3, tier = 2 },
			{ item = "clip_extended", amount= 3, tier = 2 },
			{ item = "grip", amount= 3, tier = 2 },
			{ item = "scope", amount= 1, tier = 2 },
			{ item = "smgclip", amount= 3, tier = 2 },
			{ item = "exilecoin", amount= 40000, tier = 2 },
			{ item = "bon11", amount= 1, tier = 3 },
			{ item = "bon57", amount= 2, tier = 3 },
			{ item = "bon61", amount= 1, tier = 3 }, ---Karta przeprania brudnego siana---
			{ item = "bon48", amount= 1, tier = 4 }, 
			{ weapon = "WEAPON_SMG", amount= 1, tier = 4 },
			{ weapon = "WEAPON_SMG_MK2", amount= 1, tier = 5 },
			{ item = "srebrna", amount= 3, tier = 5 }, 
			{ item = "brazowa", amount= 4, tier = 5 }, 
			{ item = "bon40", amount= 1, tier = 5 }, --- limita ---
        }
    },
	["serkowa"] = { 
        name = "Serkowa skrzynia",
        list = {
			{ item = "clip", amount= 50, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 2, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 3, tier = 1 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 2, tier = 1 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 2, tier = 1 },
			{ item = "coke_pooch", amount= 50, tier = 1 },
			{ item = "bon1", amount= 1, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ item = "opium_pooch", amount= 60, tier = 1 },
			{ item = "bon44", amount= 1, tier = 1 },	---VIP NA 3 dni---
			{ item = "cokeperico_pooch", amount= 50, tier = 1 },
			{ item = "grip", amount= 2, tier = 1 },
			{ item = "suppressor", amount= 2, tier = 1 },
			{ item = "clip_extended", amount= 2, tier = 1 },
			{ money = 325000, tier = 1 },
			{ black_money = 500000, tier = 1 },
			{ money = 750000, tier = 2 },
			{ black_money = 1000000, tier = 2 },
			{ item = "grip", amount= 3, tier = 2 },
			{ item = "suppressor", amount= 3, tier = 2 },
			{ item = "clip_extended", amount= 3, tier = 2 },
			{ item = "coke_pooch", amount= 120, tier = 2 },
			{ item = "opium_pooch", amount= 100, tier = 2 },
			{ item = "cokeperico_pooch", amount= 60, tier = 2 },
			{ item = "clip", amount= 40, tier = 2 },
			{ item = "smgclip", amount= 20, tier = 2 },
			{ item = "carbineclip", amount= 12, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 4, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 4, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 4, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 4, tier = 2 },
			{ weapon = "WEAPON_HEAVYPISTOL", amount= 1, tier = 2 },
			{ item = "kamzasmall", amount= 2, tier = 2 },
			{ item = "kamzaduza", amount= 1, tier = 2 },
			{ item = "legalna", amount= 1, tier = 2 },
			{ item = "crimowa", amount= 1, tier = 2 },
			{ item = "kupon10", amount= 2, tier = 2 },
			{ item = "coke_pooch", amount= 400, tier = 3 },
			{ item = "smgclip", amount= 25, tier = 3 },
			{ item = "carbineclip", amount= 18, tier = 3 },
			{ item = "opium_pooch", amount= 260, tier = 3 },
			{ item = "cokeperico_pooch", amount= 160, tier = 3 },
			{ item = "bon61", amount= 1, tier = 3 }, ---Karta przeprania brudnego siana---
			{ money = 2500000, tier = 3 },
			{ black_money = 4000000, tier = 3 },
			{ item = "legalna", amount= 2, tier = 3 },
			{ item = "crimowa", amount= 2, tier = 3 },
			{ item = "kupon10", amount= 3, tier = 3 },
			{ item = "kamzasmall", amount= 4, tier = 3 },
			{ item = "kamzaduza", amount= 2, tier = 3 },
			{ item = "opium_pooch", amount= 220, tier = 3 },
			{ item = "cokeperico_pooch", amount= 160, tier = 3 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_MINISMG", amount= 1, tier = 4 },
			{ item = "cokeperico_pooch", amount= 300, tier = 4 },
			{ item = "kamzasmall", amount= 8, tier = 4 },
			{ item = "kamzaduza", amount= 5, tier = 4 },
			{ item = "crimowa", amount= 1, tier = 4 },
			{ money = 5000000, tier = 4 },
			{ black_money = 6000000, tier = 4 },
			{ item = "legalna", amount= 2, tier = 4 },
			{ item = "kupon50", amount= 1, tier = 4 },
			{ item = "bon13", amount= 1, tier = 4 }, ---Skrócenie bana o 72h---
			{ item = "bon38", amount= 1, tier = 5 }, ---Dom limitowany---
			{ item = "kupon200", amount= 1, tier = 5 },
			{ item = "bon63", amount= 1, tier = 5 }, ---Limitka Custom Dźwięk---
			{ item = "bon40", amount= 1, tier = 5 }, ---Limitka---
			{ weapon = "WEAPON_COMBATPDW", amount= 1, tier = 5 },
			{ weapon = "WEAPON_SMG", amount= 1, tier = 5 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 5 },
        }
    },
	["serkowa2"] = { 
        name = "Serkowa skrzynia II",
        list = {
			{ weapon = "WEAPON_PISTOL50", amount= 1, tier = 1 },
			{ weapon = "WEAPON_DOUBLEACTION", amount= math.random(1,3), tier = 1 },
			{ weapon = "WEAPON_COMBATPDW", amount= 1, tier = 1 },
			{ item = "bon1", amount= 1, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ item = "opium_pooch", amount= 60, tier = 1 },
			{ item = "bon44", amount= 1, tier = 1 },	---VIP NA 3 dni---
			{ item = "cokeperico_pooch", amount= 50, tier = 1 },
			{ item = "grip", amount= 2, tier = 1 },
			{ item = "suppressor", amount= 2, tier = 1 },
			{ item = "clip_extended", amount= 2, tier = 1 },
			{ money = 325000, tier = 1 },
			{ black_money = 500000, tier = 1 },
			{ money = 750000, tier = 2 },
			{ black_money = 1000000, tier = 2 },
			{ item = "grip", amount= 3, tier = 2 },
			{ item = "suppressor", amount= 3, tier = 2 },
			{ item = "clip_extended", amount= 3, tier = 2 },
			{ item = "coke_pooch", amount= 120, tier = 2 },
			{ item = "opium_pooch", amount= 100, tier = 2 },
			{ item = "cokeperico_pooch", amount= 60, tier = 2 },
			{ item = "clip", amount= 40, tier = 2 },
			{ item = "smgclip", amount= 20, tier = 2 },
			{ item = "carbineclip", amount= 12, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 4, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 4, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 4, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 4, tier = 2 },
			{ weapon = "WEAPON_HEAVYPISTOL", amount= 1, tier = 2 },
			{ item = "kamzasmall", amount= 2, tier = 2 },
			{ item = "kamzaduza", amount= 1, tier = 2 },
			{ item = "legalna", amount= 1, tier = 2 },
			{ item = "crimowa", amount= 1, tier = 2 },
			{ item = "kupon10", amount= 2, tier = 2 },
			{ item = "coke_pooch", amount= 400, tier = 3 },
			{ item = "smgclip", amount= 25, tier = 3 },
			{ item = "carbineclip", amount= 18, tier = 3 },
			{ item = "opium_pooch", amount= 260, tier = 3 },
			{ item = "cokeperico_pooch", amount= 160, tier = 3 },
			{ item = "bon61", amount= 1, tier = 3 }, ---Karta przeprania brudnego siana---
			{ money = 2500000, tier = 3 },
			{ black_money = 4000000, tier = 3 },
			{ item = "legalna", amount= 2, tier = 3 },
			{ item = "crimowa", amount= 2, tier = 3 },
			{ item = "kupon10", amount= 3, tier = 3 },
			{ item = "kamzasmall", amount= 4, tier = 3 },
			{ item = "kamzaduza", amount= 2, tier = 3 },
			{ item = "opium_pooch", amount= 220, tier = 3 },
			{ item = "cokeperico_pooch", amount= 160, tier = 3 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_MINISMG", amount= 1, tier = 4 },
			{ item = "cokeperico_pooch", amount= 300, tier = 4 },
			{ item = "kamzasmall", amount= 8, tier = 4 },
			{ item = "kamzaduza", amount= 5, tier = 4 },
			{ item = "crimowa", amount= 1, tier = 4 },
			{ money = 5000000, tier = 4 },
			{ black_money = 6000000, tier = 4 },
			{ item = "legalna", amount= 2, tier = 4 },
			{ item = "kupon50", amount= 1, tier = 4 },
			{ item = "bon13", amount= 1, tier = 4 }, ---Skrócenie bana o 72h---
			{ item = "bon38", amount= 1, tier = 5 }, ---Dom limitowany---
			{ item = "kupon200", amount= 1, tier = 5 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 5 },
        }
    },
	["serkowa3"] = { 
        name = "Serkowa skrzynia III",
        list = {
			{ weapon = "WEAPON_PISTOL50", amount= 1, tier = 1 },
			{ weapon = "WEAPON_DOUBLEACTION", amount= math.random(1,3), tier = 1 },
			{ weapon = "WEAPON_PISTOL", amount = math.random(5, 10), tier = 1 },
			{ weapon = "WEAPON_COMBATPDW", amount= 1, tier = 1 },
			{ item = "bon1", amount= 1, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ item = "opium_pooch", amount= 60, tier = 1 },
			{ item = "bon44", amount= 1, tier = 1 },	---VIP NA 3 dni---
			{ item = "cokeperico_pooch", amount= 50, tier = 1 },
			{ item = "grip", amount= 2, tier = 1 },
			{ item = "suppressor", amount= 2, tier = 1 },
			{ item = "clip_extended", amount= 2, tier = 1 },
			{ money = 325000, tier = 1 },
			{ black_money = 500000, tier = 1 },
			{ money = 750000, tier = 2 },
			{ black_money = 1000000, tier = 2 },
			{ item = "grip", amount= 3, tier = 2 },
			{ item = "suppressor", amount= 3, tier = 2 },
			{ item = "clip_extended", amount= 3, tier = 2 },
			{ item = "coke_pooch", amount= 120, tier = 2 },
			{ item = "opium_pooch", amount= 100, tier = 2 },
			{ item = "cokeperico_pooch", amount= 60, tier = 2 },
			{ item = "clip", amount= 40, tier = 2 },
			{ item = "smgclip", amount= 20, tier = 2 },
			{ item = "carbineclip", amount= 12, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 4, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 4, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL", amount= 5, tier = 2 },
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 4, tier = 2 },
			{ weapon = "WEAPON_PISTOL_MK2", amount= 4, tier = 2 },
			{ weapon = "WEAPON_HEAVYPISTOL", amount= 1, tier = 2 },
			{ item = "kamzasmall", amount= 2, tier = 2 },
			{ item = "kamzaduza", amount= 1, tier = 2 },
			{ item = "legalna", amount= 1, tier = 2 },
			{ item = "crimowa", amount= 1, tier = 2 },
			{ item = "kupon10", amount= 2, tier = 2 },
			{ item = "coke_pooch", amount= 400, tier = 3 },
			{ item = "smgclip", amount= 25, tier = 3 },
			{ item = "carbineclip", amount= 180, tier = 3 },
			{ item = "opium_pooch", amount= 260, tier = 3 },
			{ item = "cokeperico_pooch", amount= 160, tier = 3 },
			{ item = "bon61", amount= 1, tier = 3 }, ---Karta przeprania brudnego siana---
			{ money = 2500000, tier = 3 },
			{ black_money = 4000000, tier = 3 },
			{ item = "legalna", amount= 3, tier = 3 },
			{ item = "crimowa", amount= 3, tier = 3 },
			{ item = "kupon10", amount= 3, tier = 3 },
			{ item = "kamzasmall", amount= 4, tier = 3 },
			{ item = "kamzaduza", amount= 2, tier = 3 },
			{ item = "opium_pooch", amount= 220, tier = 3 },
			{ item = "cokeperico_pooch", amount= 160, tier = 3 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_MINISMG", amount= 1, tier = 4 },
			{ item = "cokeperico_pooch", amount= 300, tier = 4 },
			{ item = "kamzasmall", amount= 8, tier = 4 },
			{ item = "kamzaduza", amount= 5, tier = 4 },
			{ item = "crimowa", amount= 3, tier = 4 },
			{ money = 5000000, tier = 4 },
			{ black_money = 6000000, tier = 4 },
			{ item = "legalna", amount= 5, tier = 4 },
			{ item = "kupon100", amount= 1, tier = 4 },
			{ item = "bon13", amount= 1, tier = 4 }, ---Skrócenie bana o 72h---
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 5 }, 
			{ item = "kupon200", amount= 1, tier = 5 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 5 },
        }
    },

	["trumna"] = { 
        name = "Exile Trumna",
        list = {
			{ item = "bon64", amount= 1, tier = 1 }, ---Mercedes X-CLASS---	
			{ weapon = "WEAPON_CERAMICPISTOL", amount= 10, tier = 1 },	
			{ weapon = "WEAPON_DOUBLEACTION", amount= math.random(1,3), tier = 1 },
			{ item = "coke_pooch", amount= 200, tier = 1 }, ---Mercedes E63---	
			{ item = "kamzasmall", amount= 10, tier = 1 }, ---Toyota Supra 2020---	
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 4, tier = 2 },	
			{ weapon = "WEAPON_FIVESEVEN", amount= 10, tier = 2 },	
			{ weapon = "WEAPON_MINISMG", amount= math.random(1,3), tier = 3 },
			{ item = "bon39", amount= 1, tier = 3 }, ---Brabus GT700---
			{ item = "legendarna", amount= 1, tier = 3 }, ---BMW M2---
			{ money = 15000000, tier = 4 },
			{ item = "kartafulltune", amount= 1, tier = 3 }, ---Kamacho---
			{ item = "shotgunclip", amount= 10, tier = 4 }, ---Mercedes G63 AMG---
			{ weapon = "WEAPON_SMG_MK2", amount= math.random(1,2), tier = 4 },
			{ weapon = "WEAPON_REVOLVER", amount= 1, tier = 5 },	
			{ item = "cokeperico_pooch", amount= math.random(100,1500), tier = 4 },

		}	
	},
	["cukierkowa"] = { 
        name = "Exile Cukierkowa Chest",
        list = {
			{ item = "bon1", amount= 1, tier = 1 }, 
			{ item = "dailycase", amount= 1, tier = 1 },
			{ item = "kawa", amount= 100, tier = 1 }, 
			{ item = "bon53", amount= 1, tier = 1 }, 
			{ money = 2000000, tier = 2 },
			{ item = "bon51", amount= 1, tier = 2 }, 	
			{ item = "legalna", amount= 2, tier = 2 }, 
			{ item = "kupon10", amount= 2, tier = 2 }, 
			{ item = "bon13", amount= 1, tier = 3 },
			{ item = "bon11", amount= 1, tier = 3 }, 
			{ item = "legendarna", amount= 1, tier = 4 }, 
			{ item = "bon47", amount= 1, tier = 4 }, 
			{ item = "bon8", amount= 1, tier = 4 }, 
			{ item = "bon46", amount= 1, tier = 4 }, 
			{ item = "carchest", amount= 1, tier = 4 }, 
			{ item = "bon40", amount= 1, tier = 5 }, 
			{ item = "bon62", amount= 1, tier = 5 }, 
		}	
	},

	["dyniowa"] = { 
		name = "Exile Dyniowa Chest",
		list = {
			{ item = "opium_pooch", amount= math.random(100,500), tier = 1 },
			{ item = "samarka", amount= 30, tier = 1 }, ---Porsche 918---	
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 30, tier = 1 }, ---Bentley Bentayga---	
			{ item = "bon60", amount= 1, tier = 1 }, ---Mercedes E63---	
			{ item = "bon57", amount= 1, tier = 1 }, ---Toyota Supra 2020---	
			{ item = "clip_extended", amount= 10, tier = 2 }, ---Bugatti---	
			{ item = "crimowa", amount= 2, tier = 2 }, ---Brabus 500---	
			{ item = "clip", amount= 200, tier = 2 }, ---Brabus G770---
			{ item = "kamzaduza", amount= math.random(10,30), tier = 2 },
			{ weapon = "WEAPON_DOUBLEACTION", amount= math.random(1,15), tier = 2 },
			{ item = "kartawymiany", amount= 1, tier = 2 }, ---Ferrari 488---	
			{ item = "blantoghaze", amount= math.random(1,200), tier = 2 },
			{ black_money = 6000000, tier = 3 },
			{ item = "bon28", amount= 1, tier = 3 }, ---BMW M3 F80---
			{ item = "bon54", amount= 1, tier = 3 }, ---B800C217---
			{ weapon = "WEAPON_MINISMG", amount= math.random(1,2), tier = 3 },
			{ item = "kupon100", amount= 1, tier = 4 }, ---BMW X7M---	
			{ item = "kupon10", amount= math.random(1,5), tier = 4 },
			{ item = "kupon50", amount= math.random(1,3), tier = 4 },
			{ item = "cokeperico_pooch", amount= math.random(1,200), tier = 4 },
			{ weapon = "WEAPON_SMG", amount= 1, tier = 4 }, ---Legendarne Auto 1---
			{ weapon = "WEAPON_DBSHOTGUN", amount= 1, tier = 5 }, ---Legendarne Auto 2---
			{ weapon = "WEAPON_APPISTOL", amount= 1, tier = 5 }, ---Legendarne Auto 2---
		}
	},

	["buggichest"] = { 
		name = "Exile Buggi Chest",
		list = {
			{ item = "keycard", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "bag", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "laptoptrain", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "drill", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "cutter", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "kupon10", amount= 2, tier = 1 }, ---x4 kupony10---
			{ item = "termicznabomba", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "c4", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "laptop", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "hackusb", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "zlotakarta", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "platynowakarta", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "diamentowakarta", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "kartakomendanta", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "pendrive", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "dysk", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "mapahumane", amount= 2, tier = 1 }, ---x2 itemy napadowe---
			{ item = "bon61", amount= 1, tier = 2 }, ---Karta przeprania brudnego siana---
			{ item = "kupon10", amount= 4, tier = 2 }, ---x4 kupony10---
			{ item = "keycard", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "bag", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "laptoptrain", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "drill", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "cutter", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "termicznabomba", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "c4", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "laptop", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "hackusb", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "zlotakarta", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "platynowakarta", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "diamentowakarta", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "kartakomendanta", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "pendrive", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "dysk", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ item = "mapahumane", amount= 4, tier = 2 }, ---x4 itemy napadowe---
			{ money = 2000000, tier = 2 },
			{ black_money = 4000000, tier = 2 },
			{ item = "kupon10", amount= 6, tier = 3 }, --- x6 Kupon10zł ---
			{ item = "kupon50", amount= 2, tier = 4 }, --- x2 Kupon50zł ---
			{ item = "kupon100", amount= 2, tier = 5 }, --- x2 Kupon100zł ---
		}
	},

	["prezentowa"] = { 
        name = "Christmas Chest",
        list = {
            ---TIER 1---
			{ item = "clip", amount= 50, tier = 1 },
			{ item = "crimowa", amount= 1, tier = 1 }, ---1 CRIMOWA---
			{ item = "coke_pooch", amount= 150, tier = 1 }, ---150 PORCJI KOKAINY---
			{ item = "opium_pooch", amount= 120, tier = 1 }, ---120 PORCJI OPIUM---
			{ item = "cokeperico_pooch", amount= 90, tier = 1 }, ---90 PORCJI KOKAINY PERICO---
			{ item = "kupon10", amount= 2, tier = 1 }, ---KUPONY 10PLN X2---
            ---TIER 2---
			{ item = "bon45", amount= 1, tier = 2 }, ---SKRÓCENIE BANA O 24H---
			{ item = "legalna", amount= 3, tier = 2 }, ---3 SKRZYNKI LEGALNE---
			{ item = "kawa", amount=1500, tier = 2 }, ---1500 XGAMEROW---
			{ item = "bon54", amount=1, tier = 2 }, ---STARTER PACK EKIPOWY 100PLN---	
			{ item = "bon46", amount=1, tier = 2 }, ---KARTA WYCZYSZCZENIA KARTOTEKI---	
			{ item = "bon43", amount=1, tier = 2 }, ---VIP na 7 dni---		
			{ item = "bon64", amount=1, tier = 2 }, ---SKRÓCENIE BANA O 48h---	
			{ item = "bon51", amount=1, tier = 2 }, ---LICENCJA NA BROŃ---	
			{ item = "kupon20", amount= 2, tier = 2 }, ---2 KUPONY 20PLN---
			{ money = 2000000, tier = 2 }, ---$2.000.000--- 
			{ weapon = "WEAPON_PISTOL50", amount= 2, tier = 2 }, ---2X PISTOL 50---	
			{ weapon = "WEAPON_APPISTOL", amount= 1, tier = 2 }, ---1X APPISTOL---	
			{ weapon = "WEAPON_MINISMG", amount= 1, tier = 2 }, ---1X MINISMG---	
            ---TIER 3---
			{ item = "shotgunclip", amount=3, tier = 3 }, ---3 MAGAZYNKI DO SHOTGUNA/MUSZKIETU---	
			{ item = "bon28", amount=1, tier = 3 }, ---BMW M3 F80---
			{ item = "crimowa", amount= 2, tier = 3 },	---2 CRIMOWE---		
			{ item = "kupon20", amount= 3, tier = 3 }, ---3 KUPONY 20PLN---
			{ item = "smgclip", amount= 25, tier = 3 }, ---MAGAZYNKI SMG---
			{ item = "carbineclip", amount= 18, tier = 3 }, ---MAGAZYNKI KARABIN---
			{ money = 4000000, tier = 3 }, ---$4.000.000---
			{ weapon = "WEAPON_COMBATPDW", amount= 1, tier = 3 }, ---1X PDW---
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 3 },	
            ---TIER 4---
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_CARBINERIFLE", amount= 1, tier = 4 },
			{ item = "bon13", amount= 1, tier = 4 }, ---SKRÓCENIE BANA O 72h---
			{ item = "kupon50", amount= 2, tier = 4 }, ---2X KUPON 50 PLN---
			{ item = "legendarna", amount= 2, tier = 4 }, ---2X LEGENDARNE---
			{ item = "carchest", amount= 1, tier = 4 }, ---1X CARCHEST---
			{ item = "bon66", amount= 1, tier = 4 }, ---AUTO Z BROKERA DO 10MLN---
			{ item = "bon61", amount=1, tier = 4 }, ---KARTA PRZEPRANIA BRUDNEGO SIANA---
            ---TIER 5---
			{ money = 10000000, tier = 5 }, ---$10.000.000---
			{ black_money = 13000000, tier = 5 }, ---$13.000.000 BRUDNEGO---
			{ item = "kupon200", amount= 1, tier = 5 },
			{ item = "bon39", amount= 1, tier = 5 }, ---PAKIET AUT ORGANIZACJI---
			{ item = "bon62", amount= 1, tier = 5 }, ---ŚMIGŁOWIEC---
			{ item = "bon40", amount= 1, tier = 5 }, ---LIMITKA---
			{ item = "bon63", amount= 1, tier = 5 }, ---LIMITKA CUSTOM DZWIEK---
        }
	},

	["piernikowa"] = { 
        name = "Piernikowa Chest",
        list = {
            ---TIER 1---
            { money = 1000000, tier = 1 }, ---$1.000.000---
            { item = "clip_extended", amount = 3, tier = 1}, 
            { item = "clip", amount = 50, tier = 1},
            { item = "kawa", amount = 500, tier = 1},
            { item = "kupon10", amount = 2, tier = 1}, 
            { item = "bread", amount = 50, tier = 1}, ---50 CHLEBA XD---
			{ item = "coke_pooch", amount= 150, tier = 1 }, ---150 PORCJI KOKAINY---
			{ item = "opium_pooch", amount= 120, tier = 1 }, ---120 PORCJI OPIUM---
			{ item = "cokeperico_pooch", amount= 90, tier = 1 }, ---90 PORCJI KOKAINY PERICO---
            { item = "kamzasmall", amount = 5, tier = 1},
            { item = "kamzaduza", amount = 3, tier = 1},
			{ item = "legalna", amount= 2, tier = 1 }, ---2 SKRZYNKI LEGALNE---
            { item = "crimowa", amount = 1, tier = 1}, ---1 CRIMOWA---
            { item = "dailycase", amount = 3, tier = 1},
            { item = "bon44", amount = 1, tier = 1}, ---VIP 3 DNI---
            ---TIER 2---
            { money = 2000000, tier = 2 }, ---$2.000.000---
            { item = "bon10", amount = 1, tier = 2}, ---SKRÓCENIE BANA 24H---
            { item = "kupon20", amount = 2, tier = 2},
            { item = "kupon10", amount = 3, tier = 2},
            { item = "kamzasmall", amount = 10, tier = 2},
            { item = "kamzaduza", amount = 5, tier = 2},
            { item = "blantoghaze", amount = 50, tier = 2},
            { item = "bon7", amount = 1, tier = 2}, ---50% TUNING AUTA ZNIŻKA---
			{ weapon = "WEAPON_PISTOL50", amount= 1, tier = 2 },
			{ weapon = "WEAPON_HEAVYPISTOL", amount= 2, tier = 2 },
			{ item = "legalna", amount= 3, tier = 2 }, ---3 SKRZYNKI LEGALNE---
            { item = "crimowa", amount = 2, tier = 2}, ---2 CRIMOWE---
            { item = "legendarna", amount = 1, tier = 2},
            { item = "dailycase", amount = 4, tier = 2},
            ---TIER 3---
            { money = 3000000, tier = 3 }, ---$3.000.000---
            { item = "kartafulltune", amount = 1, tier = 3},
            { item = "bon55", amount = 1, tier = 3}, ---Pakiet 50 dowolnych pistoletów + ammo---
            { item = "bon57", amount = 1, tier = 3}, ---OPIUM 24H---
            { item = "bon42", amount = 1, tier = 3}, ---AUTO Z BROKERA DO 5 MLN---
            { item = "shotgunclip", amount = 2, tier = 3}, ---2 MAGAZYNKI POMPA/MUSZKIET---
            { item = "bon30", amount = 1, tier = 3}, ---MERCEDES AMG ONE---
			{ item = "bon64", amount= 1, tier = 3 }, ---SKRÓCENIE BANA O 48h---
            { item = "bon11", amount = 1, tier = 3}, ---VIP 14 DNI---
			{ item = "kupon20", amount= 3, tier = 3 }, ---3 KUPONY 20PLN---
			{ weapon = "WEAPON_COMBATPDW", amount= 1, tier = 3 }, ---1X PDW---
            ---TIER 4---
            { money = 5000000, tier = 4 }, ---$5.000.000---
			{ weapon = "WEAPON_MILITARYRIFLE", amount= 1, tier = 4 }, ---MILITARKA---
            { item = "kupon50", amount = 2, tier = 4}, ---2 KUPONY 50 PLN----
            { item = "bon48", amount = 1, tier = 4}, ---DOWOLNE AUTO Z BROKERA---
            { item = "bon34", amount = 1, tier = 4}, ---HUMVEE---
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_CARBINERIFLE", amount= 1, tier = 4 },
            { item = "kupon100", amount = 2, tier = 4}, ---2 KUPONY 100 PLN----
            { item = "bon46", amount = 1, tier = 4}, ---WYCZYSZCZENIE KARTOTEKI---
            ---TIER 5---
            { money = 7500000, tier = 5 }, ---$7.500.000---
            { weapon = "WEAPON_MUSKET", amount= 1, tier = 5 }, ---MUSZKIET---
            { item = "carchest", amount = 3, tier = 5}, ---3 CAR CHESTY---
            { item = "bon63", amount = 1, tier = 5}, ----LIMITKA CUSTOM DŹWIĘK----
            { item = "bon37", amount = 1, tier = 5}, ---UDAJ SIE NA KANAŁ DO KRZYCHA---
            { item = "bon35", amount = 1, tier = 5}, ---LEGENDARNE AUTO 1---
			{ weapon = "WEAPON_COMBATMG", amount= 1, tier = 5 }, ---1X COMBAT MG KROWA---
        }
	},

	["skarpetowa"] = { 
		name = "Skarpetowa Chest",
		list = {
			---TIER 1---
			{ money = 500000, tier = 1 }, ---$500.000---
			{ black_money = 1000000, tier = 1 }, ---$1.000.000 BRUDNEGO---
			{ item = "bon1", amount = 1, tier = 1}, ---ZMIANA REJKI---
			{ item = "bon4", amount = 1, tier = 1}, ---25% ZNIŻKI TUNE AUTA--- 
			{ item = "bon44", amount = 1, tier = 1}, ---VIP NA 3 DNI--- 
			{ item = "kupon10", amount = 2, tier = 1}, ---2X 10PLN KUPON--- 
			{ item = "dailycase", amount = 2, tier = 1}, ---2 DAILY CASE--- 
			{ item = "legalna", amount = 1, tier = 1},  ---1 LEGALNA---
			{ weapon = "WEAPON_PISTOL50", amount= 1, tier = 1 },
			{ weapon = "WEAPON_HEAVYPISTOL", amount= 2, tier = 1 },
			{ item = "barylkakokainy", amount = 3, tier = 1}, 
			{ item = "barylkametaamfetaminy", amount = 5, tier = 1}, 
			---TIER 2---
			{ money = 1000000, tier = 2 }, ---$1.000.000---
			{ black_money = 2000000, tier = 2 }, ---$2.000.000 BRUDNEGO---
			{ item = "kupon20", amount = 2, tier = 2}, ---2x 20 PLN KUPON---
			{ item = "bon45", amount = 1, tier = 2}, ---SKRÓCENIE BANA 24H--- 
			{ item = "bon51", amount = 1, tier = 2}, ---LICENCJA NA BROŃ--- 
			{ item = "dailycase", amount = 3, tier = 2}, ---3 DAILY CASE--- 
			{ item = "crimowa", amount = 2, tier = 2},  ---2 CRIMOWA---
			{ item = "legalna", amount = 2, tier = 2},  ---2 LEGALNE---
			{ item = "legendarna", amount = 1, tier = 2}, ---LEGENDARNA---
			---TIER 3---
			{ money = 2000000, tier = 3 }, ---$2.000.000---
			{ black_money = 3000000, tier = 3 }, ---$3.000.000 BRUDNEGO---
			{ item = "kupon50", amount = 1, tier = 3}, ---KUPON 50PLN---
			{ item = "bon64", amount = 1, tier = 3}, ---SKRÓCENIE BANA 48H--- 
			{ item = "bon42", amount = 1, tier = 3}, ---AUTO Z BROKERA DO 5 MLN--- 
			{ item = "dailycase", amount = 4, tier = 3}, ---4 DAILY CASE--- 
			{ item = "crimowa", amount = 1, tier = 3},  ---1 CRIMOWA---
			{ item = "legalna", amount = 3, tier = 3},  ---3 LEGALNE--- 
			{ item = "kartawymiany", amount = 1, tier = 3}, ---KARTA WYMIANY NARKOTYKÓW---
			---TIER 4---
			{ money = 3000000, tier = 4 }, ---$3.000.000---
			{ black_money = 4000000, tier = 4 }, ---$4.000.000 BRUDNEGO---
			{ item = "kupon100", amount = 1, tier = 4}, ---KUPON 100PLN--- 
			{ item = "bon48", amount = 1, tier = 4}, ---DOWOLNE AUTO Z BROKERA---
			{ item = "bon61", amount = 1, tier = 4},  ---KARTA PRZEPRANIA BRUDNEGO SIANA---
			{ item = "bon66", amount = 1, tier = 4}, ---AUTO Z BROKERA DO 10MLN--- 
			{ item = "carchest", amount = 1, tier = 4}, ---CAR CHEST---
			---TIER 5---
			{ money = 5000000, tier = 5 }, ---$5.000.000---
			{ black_money = 6000000, tier = 5 }, ---$6.000.000 BRUDNEGO---
			{ item = "bon63", amount = 1, tier = 5},  ---LIMITKA CUSTOM DZWIEK---
			{ item = "kupon500", amount = 1, tier = 5}, ---KUPON 500PLN--- 
		}
	},
}