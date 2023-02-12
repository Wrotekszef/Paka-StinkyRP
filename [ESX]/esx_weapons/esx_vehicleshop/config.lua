Config                            = {}
Config.DrawDistance               = 15.0
Config.MarkerColor                = { r = 130, g = 0, b = 255 }

Config.RequiredResselJobGrade			= 3
Config.ResellPercentage           = 65

Config.Locale                     = 'pl'

Config.PlateLetters  = 3
Config.PlateNumbers  = 4
Config.PlateUseSpace = true

Config.Blips = {
}

Config.Zones = {

	ShopEntering = {
		Pos   = { x = -1259.26, y = -362.46, z = 36.90-0.95 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},

	ShopInside = {
		Pos     = { x = -1256.45, y = -366.16, z = 37.16-0.95 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 41.56,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -1242.79, y = -327.48, z = 37.22-0.95 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 318.82,
		Type    = -1
	},
	
	BoatEntering = {
		Pos   = { x = -332.15, y = -2792.74, z = 4.1 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},

	BoatInside = {
		Pos     = { x = -318.46, y = -2922.02, z = 1.09 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 5.0,
		Type    = -1
	},

	BoatOutside = {
		Pos     = { x = -273.85, y = -2752.50, z = 0.33 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 257.2,
		Type    = -1
	},

	PlaneEntering = {
		Pos   = { x = -941.13, y = -2954.42, z = 13.05 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},

	PlaneInside = {
		Pos     = { x = -1068.28, y = -3154.71, z = 14.05 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 58.37,
		Type    = -1
	},

	PlaneOutside = {
		Pos     = { x = -971.07, y = -3001.52, z = 13.95 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 60.07,
		Type    = -1
	},

	ResellVehicle = {
		Pos   = { x = -1233.53, y = -345.90, z = 37.33 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	}

}
