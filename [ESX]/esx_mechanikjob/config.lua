Config                            = {}
Config.Locale                     = 'pl'

Config.DrawDistance               = 7.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false

Config.NPCSpawnDistance           = 200.0
Config.NPCNextToDistance          = 25.0
Config.NPCJobEarnings             = { min = 7, max = 20 }
Config.Lokalny = {
	coords = {x=139.73, y=-3027.25, z=6.04},
	MechanikCount = 0
}

Config.Vehicles = {
	'rhapsody',
	'asea',
	'asterope',
	'banshee',
	'buffalo'
}


Config.Magazine = {
	vector3(-583.13439941406, -914.07562255859, 23.886739730835) 
}

Config.Zones = {
	['mechanik'] = {

		MechanicActions = {
			Pos   = { x = -559.8017578125, y = -898.91064453125, z = 24.00},
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
		
		BossMenu = {
			Pos   = { x = -605.47906494141, y = -919.39727783203, z = 23.00},
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},

		VehicleSpawner = {
			Pos   = { x = -537.31329345703, y = -887.33764648438, z = 25.00},
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
	
		VehicleSpawnPoint = {
			Pos   = { x = -559.8017578125, y = -898.91064453125, z = 24.00 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Heading = 355.17,
			Type  = -1
		},
	
		VehicleDeleter = {
			Pos   = { x = -532.38311767578, y = -889.26214599609, z = 24.00 },
			Size  = { x = 20.0, y = 20.0, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
	
		VehicleDelivery = {
			Pos   = { x = -556.19506835938, y = -929.85028076172, z = 23.00 },
			Size  = { x = 20.0, y = 20.0, z = 3.0 },
			Color = { r = 204, g = 204, b = 0 },
			Type  = -1
		},
		
		VehicleExtras = {
			Pos = {x = 888.16, y = -2102.81, z = 30.46-0.95},
			Size  = { x = 3.5, y = 3.5, z = 3.5 },
			Color = { r = 0, g = 203, b = 214 },
			Type = 28
		}
	},
}

Config.TowZones = {

}

Config.Towables = {
	vector3(-2480.9, -212.0, 17.4),
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8)
}

for k,v in ipairs(Config.Towables) do
	Config.TowZones['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
end

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	novice_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	master_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	expert_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	professionalist_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	specialist_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	coordinator_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	deputychief_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
	chief_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 0,
			['torso_1'] = 455,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 150,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 81,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 286,  ['tshirt_2'] = 1,
			['torso_1'] = 440,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 57,
			['pants_1'] = 168,   ['pants_2'] = 1,
			['shoes_1'] = 162,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 107,  ['bags_2'] = 9
		}
	},
}