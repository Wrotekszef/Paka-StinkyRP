Config                            = {}
Config.DrawDistance               = 15.0
Config.MarkerColor                = { r = 56, g = 197, b = 201 }
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.Sprite  = 489
Config.Display = 4
Config.Scale   = 1.0
Config.Colour  = 19
Config.ReviveReward               = 1500
Config.AntiCombatLog              = true
Config.LoadIpl                    = false
Config.Locale = 'en'
Config.RespawnToHospitalDelay		= 180000
Config.EMS_TO_REMOVE_ITEMS 			= 2
 
Config.CenaNaprawki = 3500
 
local second = 1000
local minute = 60 * second
 
-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 5 * minute
 
Config.EnablePlayerManagement       = true
Config.EnableSocietyOwnedVehicles   = false
 
Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = true
Config.RemoveItemsAfterRPDeath      = true
 
-- Will display a timer that shows RespawnDelayAfterRPDeath as a countdown
Config.ShowDeathTimer               = false
 
-- Will allow respawn after half of RespawnDelayAfterRPDeath has elapsed.
Config.EarlyRespawn                 = false
-- The player will be fined for respawning early (on bank account)
Config.EarlyRespawnFine                  = false
Config.EarlyRespawnFineAmount            = 500
 
Config.RespawnPlaceLS = vector3(199.39529418945, -931.14123535156, 30.686790466309)
Config.RespawnPlacePALETO = vector3(-247.4772, 6330.8159, 31.4761)
Config.RespawnPlaceSANDY = vector3(-247.4772, 6330.8159, 31.4761)
 
Config.Blips = {
	{
		coords = vector3(1143.64 , -1542.54, 51.71)
	},
	{
		coords = vector3(-271.48, 6321.92, 32.42)
	}
}
 
Config.OnlySamsBlip = {
	{
		Pos     = { x = -718.77, y = -1326.51, z = 1.5 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = 2836.1272, y = -732.8671, z = 0.416 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = -3420.7292, y = 955.541, z = 7.3967 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = 3373.7449, y = 5183.4521, z = 0.5102 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = 1736.29, y = 3976.24, z = 31.98 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos	= { x = -285.01, y = 6627.6, z = 7.2 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
}
 
Config.VehicleGroups = {
	'PATROL', -- 1
	'TRANSPORT', -- 2
	'DODATKOWE', -- 3
	'MOTO', -- 4
	'OFF-ROAD', -- 5
	'MSU', -- 6
}
 
-- https://wiki.rage.mp/index.php?title=Vehicles
Config.AuthorizedVehicles = {
	{
		grade = 0,
		model = 'pd_dirtbike',
		label = 'Cross',
		groups = {4},
		livery = 2,
		extrason = {},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_coach',
		label = 'Autobus',
		groups = {2},
		livery = 0,
		extrason = {1,3,4,5,6,7},
		extrasoff = {2},
		tint = 1,
	},
	{
		grade = 4,
		model = 'ms_explorer',
		label = 'Ford Explorer',
		groups = {1},
		livery = 0,
		extrason = {1,3,4,5,6,7},
		extrasoff = {2},
		tint = 1,
	},
	{
		grade = 2,
		model = 'ms_jeep',
		label = 'Jeep Cherokee',
		groups = {1},
		livery = 0,
		extrason = {1,3,4,5,6,7},
		extrasoff = {2},
		tint = 1,
	},
	{
		grade = 2,
		model = 'ms_impala',
		label = 'Chevrolet Imapala',
		groups = {1},
		livery = 0,
		extrason = {1,3,4,5,6,7},
		extrasoff = {2},
		tint = 1,
	},
	{
		grade = 6,
		model = 'ms_charger',
		label = 'Dodge Charger 2018',
		groups = {1},
		livery = 0,
		extrason = {1,3,4,5,6,7},
		extrasoff = {2},
		tint = 1,
	},
	{
		grade = 10,
		model = 'ms_m5',
		label = 'BMW M5',
		groups = {1},
		livery = 0,
		extrason = {1,3,4,5,6,7},
		extrasoff = {2},
		tint = 1,
	},
	{
		grade = 4,
		model = 'ms_raptor',
		label = 'Ford Raptor',
		groups = {1},
		livery = 0,
		extrason = {1,2,3},
		extrasoff = {4,5},
	},
	{
		grade = 4,
		model = 'ms_tahoe21',
		label = 'Chevrolet Tahoe 21',
		groups = {1},
		livery = 0,
		extrason = {1,2,3},
		extrasoff = {4,5},
	},
	{
		grade = 5,
		model = 'ms_tundra',
		label = 'Toyota Tundra',
		groups = {1},
		livery = 0,
		extrason = {1,2,3},
		extrasoff = {4,5},
	},
	{
		grade = 0,
		model = 'ms_ram19',
		label = 'Dodge Ram',
		groups = {5},
		livery = 0,
		extrason = {1,2,3},
		extrasoff = {4,5},
	},
	{
		grade = 1,
		model = 'ms_tahoe',
		label = 'Chevrolet Tahoe 19',
		groups = {1},
		livery = 0,
		extrason = {1,2,3},
		extrasoff = {4,5},
	},
	{
		grade = 0,
		model = 'ms_transformer',
		label = 'Ford F350',
		groups = {1},
		livery = 0,
		extrason = {1,2},
		extrasoff = {},
	},
	{
		grade = 1,
		model = 'ms_outlander',
		label = 'Quad',
		groups = {3},
		livery = 0,
		extrason = {1},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_bike',
		label = 'Rower Medyczny',
		groups = {3},
		livery = 0,
		extrason = {1,2},
		extrasoff = {},
	},		
	{
		grade = 0,
		model = 'ms_Bronco',
		label = 'Ford Bronco',
		groups = {5},
		livery = 1,
		extrason = {1,3,4,5,6},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_chair',
		label = 'Wózek Inwalidzki',
		groups = {2},
		livery = 0,
		extrason = {},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_charger18',
		label = 'Dodge Charger 2018',
		groups = {6},
		livery = 2,
		extrason = {1,2,3,4,5,6,7},
		extrasoff = {},
	},
	{
		grade = 4,
		model = 'ms_colorado',
		label = 'Chevrolet Colorado',
		groups = {2},
		livery = 2,
		extrason = {1,2,3,4,5,6},
		extrasoff = {},
	},
	{
		grade = 1,
		model = 'ms_everest14',
		label = 'Ford Everest',
		groups = {1},
		livery = 1,
		extrason = {1,2,3,4,5,6},
		extrasoff = {},
	},
	{
		grade = 1,
		model = 'ms_f150',
		label = 'Ford F150',
		groups = {2},
		livery = 0,
		extrason = {1,2,3,4,5,6,7,8,9,10,12},
		extrasoff = {11},
	},
	{
		grade = 0,
		model = 'ms_fj',
		label = 'Toyota FJ',
		groups = {2},
		livery = 0,
		extrason = {1,2,3,4,5,6,7,10,11},
		extrasoff = {},
	},
	{
		grade = 5,
		model = 'ms_focus',
		label = 'Ford Focus',
		groups = {2},
		livery = 0,
		extrason = {1,2,3},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_kawasaki',
		label = 'Kawasaki Medyczny',
		groups = {4},
		livery = 0,
		extrason = {1,2,3,4},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_lexus',
		label = 'Lexus',
		groups = {6},
		livery = 1,
		extrason = {1,2},
		extrasoff = {},
	},
	{
		grade = 12,
		model = 'ms_mustang',
		label = 'Ford Mustang',
		groups = {2},
		livery = 0,
		extrason = {1,2,3,4,6,8,9},
		extrasoff = {5,7},
	},
	{
		grade = 0,
		model = 'ms_paka',
		label = 'Karetka',
		groups = {2},
		livery = 2,
		extrason = {5,8,10},
		extrasoff = {},
	},
	{
		grade = 1,
		model = 'ms_silv2020w',
		label = 'Chevrolet Silverado 2020',
		groups = {2},
		livery = 0,
		extrason = {1,2,3,4,5,6,7,8,9},
		extrasoff = {},
	},
	{
		grade = 1,
		model = 'ms_silvleo',
		label = 'Chevrolet Silverado',
		groups = {2},
		livery = 0,
		extrason = {1,2,4},
		extrasoff = {3},
	},
	{
		grade = 10,
		model = 'ms_tesla',
		label = 'Tesla',
		groups = {2},
		livery = 0,
		extrason = {1,2},
		extrasoff = {},
	},
	{
		grade = 0,
		model = 'ms_titan',
		label = 'Nissan Titan',
		groups = {5},
		livery = 1,
		extrason = {1,2,9},
		extrasoff = {},
	},
}

Config.AuthorizedHeli = {
	{
	   model = 'ms_heli',
	   label = 'Helikopter'
	},
}
Config.AuthorizedBoats = {
	{
		model = 'dinghy',
		label = 'Łódź'
	},
	{
		model = 'ms_boat1',
		label = 'Łódka Medyczna',
	},
}
 
Config.Ambulance = {
	LicensesMenu = {
		{
			coords = vector3(1132.88, -1580.12, 35.38-0.95),--LOS SANTOS
		},
	},

	Cloakrooms = {
		{
			coords = vector3(1142.47, -1549.97, 35.38-0.95),--LOS SANTOS
		},
	},

	Vehicles = {
		{
			coords = vector3(1171.98, -1524.37, 34.84-0.95),--LOS SANTOS
			spawnPoint = vector3(1177.87, -1509.94, 34.69),
			heading = 87.53
		},
		{
			coords = vector3(-251.49851989746, 6339.4916992188, 32.489204406738-0.95),--PALETO
			spawnPoint = vector3(-258.11804199219, 6344.48046875, 32.426071166992),
			heading = 294.34
		},
	},

	Boats = {
		{
			coords = vector3(-718.77, -1326.51, 0.7),
			spawnPoint = vector3(-724.68, -1328.62, 0.12),
			heading = 229.75
		},
		{
			coords = vector3(1736.29, 3976.24, 31.08),
			spawnPoint = vector3(1736.63, 3986.54, 30.33),
			heading = 17.2
		},
		{
			coords = vector3(-285.01, 6627.6, 6.24),
			spawnPoint = vector3(-287.84, 6624.39, -0.2),
			heading = 47.37

		},
		{
			coords = vector3(-3420.4172, 955.6319, 7.3967),
			spawnPoint = vector3(-3434.8318, 945.8564, 0.5458),
			heading = 88.32

		},
		{
			coords = vector3(2836.5044, -732.4112, 0.3822),
			spawnPoint = vector3(2853.5557, -728.2502, 0.3811),
			heading = 261.94

		},
		{
			coords = vector3(3373.8213, 5183.4863, 0.5161),
			spawnPoint = vector3(3384.6956, 5181.6299, 0.5161),
			heading = 271.24

		},
	},

	Helicopters = {
		{
			coords = vector3(1141.07, -1620.86, 34.88-0.95),--LOS SANTOS
			spawnPoint = vector3(1140.39, -1611.39, 34.69),
			heading = 265.97
		},
		{
			coords    = vector3(1831.4998, 3687.6494, 37.9),
			spawnPoint = vector3(1833.4812, 3680.8623, 39.1894),
			heading    = 34.6
		},
		{
			coords    = vector3(-268.85, 6322.52, 37.6-0.95),
			spawnPoint = vector3(-258.39, 6316.31, 37.61),
			heading    = 223.6
		},
	},
	
	SkinMenu = {
		{
			coords = vector3(1145.58, -1552.17, 35.38-0.95),--LOS SANTOS
		},
	},
 
	VehicleDeleters = {
		{
			coords = vector3(1195.07, -1508.66, 34.69-0.95),--LOS SANTOS
		},
		{
			coords = vector3(-258.11804199219, 6344.48046875, 32.426071166992-0.95),--PALETO
		},
		{
			coords = vector3(1833.6592, 3679.8035, 38.72)
		},
		{
			coords = vector3(-258.39, 6316.31, 37.61-0.95)
		},
	},

	Inventories2 = {
		{
			coords = vector3(1132.58, -1573.69, 35.38-0.95),--LOS SANTOS
		},
	},

	Inventories = {
		{
			coords = vector3(1142.12, -1573.03, 35.38-0.95),--LOS SANTOS
		},
	},

	Pharmacies = {
		{
			coords = vector3(1144.31, -1574.9, 35.38-0.95),--LOS SANTOS
		},
	},

	BossActions = {
		{
		 	coords = vector3(1132.86, -1583.89, 35.38-0.95),--LOS SANTOS
		},
	}
}

Config.Uniforms = {
	trialperiod_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 452,   ['torso_2'] = 3,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 121,
            ['pants_1'] = 156,   ['pants_2'] = 0,
            ['shoes_1'] = 113,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 463,   ['torso_2'] = 3,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 138,
            ['pants_1'] = 228,   ['pants_2'] = 3,
            ['shoes_1'] = 156,   ['shoes_2'] = 4,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	trainee_wear = {
		male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 452,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 121,
            ['pants_1'] = 156,   ['pants_2'] = 1,
            ['shoes_1'] = 113,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 463,   ['torso_2'] = 4,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 138,
            ['pants_1'] = 228,   ['pants_2'] = 4,
            ['shoes_1'] = 156,   ['shoes_2'] = 4,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	nurse_wear = {
        male = {
            ['tshirt_1'] = 226,  ['tshirt_2'] = 0,
            ['torso_1'] = 447,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 74,
            ['pants_1'] = 4,   ['pants_2'] = 7,
            ['shoes_1'] = 166,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 304,  ['tshirt_2'] = 2,
            ['torso_1'] = 459,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 109,
            ['pants_1'] = 178,   ['pants_2'] = 21,
            ['shoes_1'] = 114,   ['shoes_2'] = 12,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	paramedic_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 450,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 86,
            ['pants_1'] = 178,   ['pants_2'] = 0,
            ['shoes_1'] = 166,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 135,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 460,   ['torso_2'] = 0,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 106,
            ['pants_1'] = 178,   ['pants_2'] = 21,
            ['shoes_1'] = 114,   ['shoes_2'] = 12,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 128,  ['bags_2'] = 0
        }
    },
	seniorparamedic_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 449,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 74,
            ['pants_1'] = 178,   ['pants_2'] = 0,
            ['shoes_1'] = 164,   ['shoes_2'] = 11,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 124,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 464,   ['torso_2'] = 1,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 101,
            ['pants_1'] = 232,   ['pants_2'] = 2,
            ['shoes_1'] = 114,   ['shoes_2'] = 12,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 128,  ['bags_2'] = 0
        }
    },
	doctor_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 444,   ['torso_2'] = 1,
            ['decals_1'] = 137,   ['decals_2'] = 3,
            ['arms'] = 81,
            ['pants_1'] = 28,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 458,   ['torso_2'] = 1,
            ['decals_1'] = 147,   ['decals_2'] = 3,
            ['arms'] = 109,
            ['pants_1'] = 232,   ['pants_2'] = 2,
            ['shoes_1'] = 114,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	seniordoctor_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 444,   ['torso_2'] = 5,
            ['decals_1'] = 137,   ['decals_2'] = 4,
            ['arms'] = 81,
            ['pants_1'] = 28,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 458,   ['torso_2'] = 5,
            ['decals_1'] = 147,   ['decals_2'] = 4,
            ['arms'] = 109,
            ['pants_1'] = 232,   ['pants_2'] = 2,
            ['shoes_1'] = 114,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	medicalspecialist_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 444,   ['torso_2'] = 6,
            ['decals_1'] = 137,   ['decals_2'] = 5,
            ['arms'] = 81,
            ['pants_1'] = 24,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 458,   ['torso_2'] = 6,
            ['decals_1'] = 147,   ['decals_2'] = 5,
            ['arms'] = 109,
            ['pants_1'] = 232,   ['pants_2'] = 2,
            ['shoes_1'] = 114,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	surgeon_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 444,   ['torso_2'] = 8,
            ['decals_1'] = 137,   ['decals_2'] = 7,
            ['arms'] = 81,
            ['pants_1'] = 28,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 460,   ['torso_2'] = 1, 
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 106,
            ['pants_1'] = 178,   ['pants_2'] = 21,
            ['shoes_1'] = 114,   ['shoes_2'] = 12,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	assistantneurosurgeon_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 448,   ['torso_2'] = 4,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 86,
            ['pants_1'] = 28,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 135,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 462,   ['torso_2'] = 4,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 101,
            ['pants_1'] = 159,   ['pants_2'] = 2,
            ['shoes_1'] = 114,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 128,  ['bags_2'] = 0
        }
    },
	neurosurgeon_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 444,   ['torso_2'] = 8,
            ['decals_1'] = 137,   ['decals_2'] = 7,
            ['arms'] = 81,
            ['pants_1'] = 28,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 126,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 462,   ['torso_2'] = 5,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 101,
            ['pants_1'] = 159,   ['pants_2'] = 2,
            ['shoes_1'] = 114,   ['shoes_2'] = 12,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	professor_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 448,   ['torso_2'] = 5,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 82,
            ['pants_1'] = 24,   ['pants_2'] = 0,
            ['shoes_1'] = 10,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 126,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 133,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 8,  ['tshirt_2'] = 0,
            ['torso_1'] = 437,   ['torso_2'] = 5,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 101,
            ['pants_1'] = 154,   ['pants_2'] = 2,
            ['shoes_1'] = 107,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 96,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 117,  ['bags_2'] = 0
        }
    },
	nurek_wear = { 
        male = {
            ['tshirt_1'] = 123,  ['tshirt_2'] = 0,
            ['torso_1'] = 443,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 82,
            ['pants_1'] = 150,   ['pants_2'] = 1,
            ['shoes_1'] = 67,   ['shoes_2'] = 4,
            ['helmet_1'] = 0,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 26,     ['ears_2'] = 4,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 133,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 153,  ['tshirt_2'] = 0,
            ['torso_1'] = 431,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 213,
            ['pants_1'] = 97,   ['pants_2'] = 15,
            ['shoes_1'] = 70,   ['shoes_2'] = 4,
            ['helmet_1'] = 0,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 28,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 0,  ['bags_2'] = 0
        }
    },
	SWIM_wear = {
        male = {
            ['tshirt_1'] = 123,  ['tshirt_2'] = 0,
            ['torso_1'] = 443,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 82,
            ['pants_1'] = 154,   ['pants_2'] = 1,
            ['shoes_1'] = 67,   ['shoes_2'] = 4,
            ['helmet_1'] = 0,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 26,     ['ears_2'] = 4,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 124,  ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 153,  ['tshirt_2'] = 0,
            ['torso_1'] = 456,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 213,
            ['pants_1'] = 97,   ['pants_2'] = 20,
            ['shoes_1'] = 70,   ['shoes_2'] = 20,
            ['helmet_1'] = 0,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 28,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['bags_1'] = 128,  ['bags_2'] = 0
        }
    },
}
