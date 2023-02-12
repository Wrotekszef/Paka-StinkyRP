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
	coords = {x = 914.17, y = -2124.88, z = 30.45-0.95},
	MechanikCount = 0
}

Config.Vehicles = {
	'rhapsody',
	'asea',
	'asterope',
	'banshee',
	'buffalo'
}

Config.Blips = {
	Mechanic = {
		Pos = vector3(822.65, -961.80, 25.97),
		Sprite = 446,
		Color = 5,
		Label = "Divo Garage"
	},
}

Config.Magazine = {
	vector3(804.54, -956.50, 24.97)
}

Config.Zones = {
	['gheneraugarage'] = {
		VehicleExtras = {
			Pos = { x = 836.95, y = -960.17, z = 25.11},
			Size  = { x = 3.5, y = 3.5, z = 3.5 },
			Color = { r = 0, g = 203, b = 214 },
			Type = 28
		},

		DutyList = {
			Pos   = { x = 835.31, y = -981.13, z = 32.07-0.95 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},

		MechanicActions = {
			Pos   = { x = 812.18, y = -991.61, z = 25.97-0.95 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
		
		PrivateStock = {
			Pos   = { x = 832.06, y = -981.17, z = 32.07-0.95 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
		
		BossMenu = {
			Pos   = { x = 840.80, y = -981.15, z = 32.07-0.95 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
		
		VehicleSpawner = {
			Pos   = { x = 828.05, y = -991.83, z = 25.97-0.95 },
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 27
		},
	
		VehicleSpawnPoint = {
			Pos   = { x = 841.75, y = -1011.29, z = 27.73 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Heading = 90.68,
			Type  = -1
		},
	
		VehicleDeleter = {
			Pos   = { x = 861.40, y = -1011.37, z = 29.79-0.95 },
			Size  = { x = 20.0, y = 20.0, z = 1.0 },
			Color = { r = 0, g = 203, b = 214 },
			Type  = 28
		},
	
		VehicleDelivery = {
			Pos   = { x = 860.16, y = -1025.45, z = 30.00-0.95 },
			Size  = { x = 20.0, y = 20.0, z = 3.0 },
			Color = { r = 204, g = 204, b = 0 },
			Type  = -1
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
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 515,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	novice_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 518,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	master_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 518,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	expert_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 514,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 119,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	professionalist_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 367,   ['torso_2'] = 10,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	specialist_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 136,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 101,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	coordinator_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 136,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 101,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	deputychief_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 367,   ['torso_2'] = 3,
			['decals_1'] = 0,  ['decals_2'] = 0,
			['arms'] = 101,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	chief_wear = {
		male = {
			['tshirt_1'] = 228,  ['tshirt_2'] = 1,
			['torso_1'] = 457,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 204,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 97,  ['bags_2'] = 3
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 366,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 101,
			['pants_1'] = 157,   ['pants_2'] = 1,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 121,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
		}
	},
	nurek_wear = { 
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 94,   ['pants_2'] = 0,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0
	
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 97,   ['pants_2'] = 0,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 0,  ['bags_2'] = 0
	
		}
	},
}

Config.TasksList = {
	{ -- 1
		blip = {x = -1249.04, y = -1062.49, z = 8.48},
		npc = {x = -1242.87, y = -1051.21, z = 8.33, heading = 77.31},
		vehicle = {x = -1249.57, y = -1044.81, z = 8.46, heading = 256.18},
		price = 0
	},
	{ -- 2
		blip = {x = -1262.53, y = -627.32, z = 27.03},
		npc = {x = -1259.41, y = -631.89, z = 27.04, heading = 78.15},
		vehicle = {x = -1262.47, y = -626.63, z = 26.89, heading = 272.23},
		price = 0
	},
	{ -- 3
		blip = {x = -593.44, y = -221.22, z = 36.63},
		npc = {x = -588.85, y = -217.77, z = 37.17, heading = 151.46},
		vehicle = {x = -593.4, y = -218.7, z = 36.8, heading = 340.99},
		price = 0
	},
	{ -- 4
		blip = {x = -153.24, y = -74.21, z = 54.25},
		npc = {x = -153.74, y = -65.66, z = 54.01, heading = 176.27},
		vehicle = {x = -151.53, y = -80.27, z = 54.46, heading = 91.43},
		price = 0
	},
	{ -- 5
		blip = {x = 1003.36, y = -540.09, z = 60.22},
		npc = {x = 993.96, y = -533.56, z = 60.02, heading = 233.93},
		vehicle = {x = 1000.93, y = -536.53, z = 60.04, heading = 325.91},
		price = 0
	},
	{ -- 6
		blip = {x = 1291.62, y = -423.42, z = 69.09},
		npc = {x = 1287.89, y = -418.99, z = 69.1, heading = 221.9},
		vehicle = {x = 1295.16, y = -426.56, z = 69.07, heading = 332.83},
		price = 0
	},
	
}