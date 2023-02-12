local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetEntityCoords = GetEntityCoords
local IsPedInAnyVehicle = IsPedInAnyVehicle
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetCurrentPedWeapon = GetCurrentPedWeapon
local DecorRemove = DecorRemove
local NetworkSetFriendlyFireOption = NetworkSetFriendlyFireOption
local SetPlayerInvincible = SetPlayerInvincible
local SetCanAttackFriendly = SetCanAttackFriendly
local DecorSetBool = DecorSetBool
local SetEntityVisible = SetEntityVisible
local FreezeEntityPosition = FreezeEntityPosition
local SetFocusEntity = SetFocusEntity
local SetRelationshipBetweenGroups = SetRelationshipBetweenGroups
local IsPedArmed = IsPedArmed
local DisableControlAction = DisableControlAction
local DisablePlayerVehicleRewards = DisablePlayerVehicleRewards
local AllowPauseMenuWhenDeadThisFrame = AllowPauseMenuWhenDeadThisFrame
local HideHudComponentThisFrame = HideHudComponentThisFrame
local WaterOverrideSetStrength = WaterOverrideSetStrength
local SetPedDensityMultiplierThisFrame = SetPedDensityMultiplierThisFrame
local SetRandomVehicleDensityMultiplierThisFrame = SetRandomVehicleDensityMultiplierThisFrame
local SetScenarioPedDensityMultiplierThisFrame = SetScenarioPedDensityMultiplierThisFrame
local SetParkedVehicleDensityMultiplierThisFrame = SetParkedVehicleDensityMultiplierThisFrame
local SetRandomVehicleDensityMultiplierThisFrame = SetRandomVehicleDensityMultiplierThisFrame
local SetVehicleDensityMultiplierThisFrame = SetVehicleDensityMultiplierThisFrame
local ShowHudComponentThisFrame = ShowHudComponentThisFrame
local ClearAreaOfCops = ClearAreaOfCops
local SetEntityCoords = SetEntityCoords
local SetMapZoomDataLevel = SetMapZoomDataLevel
local SetBlipAlpha = SetBlipAlpha
local playerPed = PlayerPedId()
local playerid = PlayerId()
local playercoords = GetEntityCoords(playerPed)
local inVehicle = IsPedInAnyVehicle(playerPed, false)
local vehicle = GetVehiclePedIsIn(playerPed, false)
local status, weapon = GetCurrentPedWeapon(playerPed, true)

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerid = PlayerId()
		playercoords = GetEntityCoords(playerPed)
		inVehicle = IsPedInAnyVehicle(playerPed, false)
		vehicle = GetVehiclePedIsIn(playerPed, false)
		status, weapon = GetCurrentPedWeapon(playerPed, true)
        Wait(222)
    end
end)

AddEventHandler('esx:onPlayerSpawn', function() 
	canUsePropfix = false
	Wait(5000)
	canUsePropfix = true

	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_LOST"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_HILLBILLY"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_BALLAS"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_MEXICAN"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_FAMILY"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_MARABUNTE"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_SALVA"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AMBIENT_GANG_WEICHENG"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("GANG_1"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("GANG_2"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("GANG_9"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("GANG_10"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("FIREMAN"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("MEDIC"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("COP"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("ARMY"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("DEALER"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("CIVMALE"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("HEN"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("PRIVATE_SECURITY"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("SECURITY_GUARD"), joaat('PLAYER'))
	SetRelationshipBetweenGroups(1, joaat("AGGRESSIVE_INVESTIGATE"), joaat('PLAYER'))
end)

local strike = 0
local newPlayer = false
local Config = {	
	DisplayCrosshair = {
		'WEAPON_SNIPERRIFLE',
		'WEAPON_HEAVYSNIPER',
		'WEAPON_HEAVYSNIPER_MK2',
		'WEAPON_MARKSMANRIFLE',
		'WEAPON_MARKSMANRIFLE_MK2'
	},

	Visuals = {
		["misc.coronas.sizeScaleGlobal"] = 1.25,
		["misc.coronas.intensityScaleGlobal"] = 0.0,
		["misc.coronas.intensityScaleWater"] = 0.0,
		["misc.coronas.sizeScaleWater"] = 0.0,
		["misc.coronas.screenspaceExpansionWater"] = 0.0,
		["misc.coronas.zBiasMultiplier"] = 25.0,
		["misc.coronas.zBias.fromFinalSizeMultiplier"] = 0.1,
		["misc.coronas.underwaterFadeDist"] = 2.0,
		["misc.coronas.screenEdgeMinDistForFade"] = 0.0,
		["lodlight.corona.size"] = 1.75,
		["car.coronas.CutoffStart"] = 280.0,
		["train.light.fadelength"] = 20.0,
	},

	Strefy = {
		{
			Pos = vector3(-166.6, -1579.34, 35.04),
			Radius = 130.0,
			Colour = 2
		},
		{
			Pos = vector3(840.55, -2355.71, 30.33),
			Radius = 80.0,
			Colour = 17
		},
		{
			Pos = vector3(904.98, -485.84, 59.44),
			Radius = 80.0,
			Colour = 10
		},
		{
			Pos = vector3(-1980.32, 254.74, 87.21),
			Radius = 80.0,
			Colour = 24
		},
		{
			Pos = vector3(-642.63, -1233.79, 11.55),
			Radius = 60.0,
			Colour = 4
		},
		{
			Pos = vector3(112.23, -1955.95, 20.75),
			Radius = 100.0,
			Colour = 7
		},
		{
			Pos = vector3(362.59, -2062.23, 21.46),
			Radius = 90.0,
			Colour = 5
		},
		{
			Pos = vector3(972.63, -122.37, 74.34),
			Radius = 55.0,
			Colour = 72
		},
		{
			Pos = vector3(1377.49, -1552.52, 56.58),
			Radius = 80.0,
			Colour = 3
		},
		{
			Pos = vector3(-1555.9609, -401.6158, 41.0377),
			Radius = 70.0,
			Colour = 1
		},
		{
			Pos = vector3(449.031, -1894.219, 25.8005),
			Radius = 80.0,
			Colour = 29
		},
		{
			Pos = vector3(1378.9091, -2078.6506, 51.0489),
			Radius = 85.0,
			Colour = 40
		},
		{
			Pos = vector3(492.6717, -1534.2066, 29.2873),
			Radius = 70.0,
			Colour = 8
		},
		{
			Pos = vector3(52.0, 3707.03, 39.74), -- LOSTY
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(100.75, -2198.87, 6.18),
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(1515.61, -2147.06, 77.22),
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(2511.47, 4970.84, 44.54), -- ONEIL
			Radius = 60.0,
			Colour = 1
		},

		{
			Pos = vector3(1438.9573974609, 6344.1342773438, 24.984375), -- PALETO
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(3304.3237304688, 5146.1943359375, 18.319244384766), -- Latarnia
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(-1939.6918945313, 1784.5899658203, 173.49584960938), -- Winiarnia
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(409.82183837891, 6482.5234375, 28.808870315552), -- Sad Jabłek
			Radius = 60.0,
			Colour = 1
		},
		{
			Pos = vector3(2470.6467285156, 3769.9731445313, 41.330341339111), -- UFO
			Radius = 60.0,
			Colour = 1
		},
	}
	
}

CreateThread(function()
    Wait(1000)
	for i=1, #Config.Strefy, 1 do
		local blip = AddBlipForRadius(Config.Strefy[i].Pos, Config.Strefy[i].Radius)
		
		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, Config.Strefy[i].Colour)
		SetBlipAlpha(blip, 150)
		SetBlipAsShortRange(blip, true)
	end
end)

local can = true

local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false

local loadingStatus = 0
local loadingPosition = false

local inProperty = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	ESX.PlayerLoaded = true
	if not loadingPosition then
		print('[StinkyRP]: PlayerLoaded')
		loadingStatus = 1
		ESX.UI.HUD.SetDisplay(0.0)
		loadingPosition = (playerData.coords or {x = -1037.86, y = -2738.11, z = 20.16})

		-- SetPlayerInvincible(playerid, true)
		SetEntityVisible(playerPed, false)
		
		FreezeEntityPosition(playerPed, true)
		SetEntityCoords(playerPed, 0, 0, 0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob, response)
	ESX.PlayerData.secondjob = secondjob
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob, response)
	ESX.PlayerData.thirdjob = thirdjob
end)

RegisterCommand("duty", function(source, args, raw)
    TriggerServerEvent("komendaduty:onoff")
end, false)

RegisterCommand("clearnui", function()
	StopAudioScene("MP_LEADERBOARD_SCENE")
    SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
end)

RegisterCommand("shuff", function()
    TriggerEvent("SeatShuffle")
end, false)

CreateThread(function ()
	while true do
		Wait(3)
		if IsPedArmed(playerPed, 6) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		else
			Wait(500)
		end
	end
end)

local blockwheel = false

CreateThread(function() 
	while true do
		Wait(500)
		inProperty = exports['esx_property']:isProperty()
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
		SetWeaponDrops()
		ClearAreaOfCops(playercoords.x, playercoords.y, playercoords.z, 400.0)
		blockwheel = exports['esx_ambulancejob']:IsBlockWeapon()
		if blockwheel then
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		end
	end
end)

CreateThread(function() 
	while inProperty do
		Wait(0)
		ClearAreaOfPeds(playercoords.x, playercoords.y, playercoords.z, 10.0, 0)
	end
end)

local disableShuffle = true

CreateThread(function()
    local sleep
    while true do
        sleep = 200
        if inVehicle and disableShuffle then
            if GetPedInVehicleSeat(vehicle, 0) == playerPed then
                if GetIsTaskActive(playerPed, 165) then
                    sleep = 0
                    SetPedIntoVehicle(playerPed, vehicle, 0)
                    SetPedConfigFlag(playerPed, 184, true)
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('SeatShuffle', function()
	if inVehicle then
		disableShuffle = false
        SetPedConfigFlag(playerPed, 184, false)
        Wait(3000)
        disableShuffle = true
	else
		CancelEvent()
	end
end)

function RemoveWeaponDrops()
    local pickupList = {
	GetHashKey("PICKUP_AMMO_BULLET_MP"),
	GetHashKey("PICKUP_AMMO_FIREWORK"),
	GetHashKey("PICKUP_AMMO_FLAREGUN"),
	GetHashKey("PICKUP_AMMO_GRENADELAUNCHER"),
	GetHashKey("PICKUP_AMMO_GRENADELAUNCHER_MP"),
	GetHashKey("PICKUP_AMMO_HOMINGLAUNCHER"),
	GetHashKey("PICKUP_AMMO_MG"),
	GetHashKey("PICKUP_AMMO_MINIGUN"),
	GetHashKey("PICKUP_AMMO_MISSILE_MP"),
	GetHashKey("PICKUP_AMMO_PISTOL"),
	GetHashKey("PICKUP_AMMO_RIFLE"),
	GetHashKey("PICKUP_AMMO_RPG"),
	GetHashKey("PICKUP_AMMO_SHOTGUN"),
	GetHashKey("PICKUP_AMMO_SMG"),
	GetHashKey("PICKUP_AMMO_SNIPER"),
	GetHashKey("PICKUP_ARMOUR_STANDARD"),
	GetHashKey("PICKUP_CAMERA"),
	GetHashKey("PICKUP_CUSTOM_SCRIPT"),
	GetHashKey("PICKUP_GANG_ATTACK_MONEY"),
	GetHashKey("PICKUP_HEALTH_SNACK"),
	GetHashKey("PICKUP_HEALTH_STANDARD"),
	GetHashKey("PICKUP_MONEY_CASE"),
	GetHashKey("PICKUP_MONEY_DEP_BAG"),
	GetHashKey("PICKUP_MONEY_MED_BAG"),
	GetHashKey("PICKUP_MONEY_PAPER_BAG"),
	GetHashKey("PICKUP_MONEY_PURSE"),
	GetHashKey("PICKUP_MONEY_SECURITY_CASE"),
	GetHashKey("PICKUP_MONEY_VARIABLE"),
	GetHashKey("PICKUP_MONEY_WALLET"),
	GetHashKey("PICKUP_PARACHUTE"),
	GetHashKey("PICKUP_PORTABLE_CRATE_FIXED_INCAR"),
	GetHashKey("PICKUP_PORTABLE_CRATE_UNFIXED"),
	GetHashKey("PICKUP_PORTABLE_CRATE_UNFIXED_INCAR"),
	GetHashKey("PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL"),
	GetHashKey("PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW"),
	GetHashKey("PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE"),
	GetHashKey("PICKUP_PORTABLE_PACKAGE"),
	GetHashKey("PICKUP_SUBMARINE"),
	GetHashKey("PICKUP_VEHICLE_ARMOUR_STANDARD"),
	GetHashKey("PICKUP_VEHICLE_CUSTOM_SCRIPT"),
	GetHashKey("PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW"),
	GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD"),
	GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW"),
	GetHashKey("PICKUP_VEHICLE_MONEY_VARIABLE"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_APPISTOL"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_ASSAULTSMG"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_COMBATPISTOL"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_GRENADE"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_MICROSMG"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_MOLOTOV"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_PISTOL"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_PISTOL50"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_SAWNOFF"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_SMG"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_SMOKEGRENADE"),
	GetHashKey("PICKUP_VEHICLE_WEAPON_STICKYBOMB"),
	GetHashKey("PICKUP_WEAPON_ADVANCEDRIFLE"),
	GetHashKey("PICKUP_WEAPON_APPISTOL"),
	GetHashKey("PICKUP_WEAPON_ASSAULTRIFLE"),
	GetHashKey("PICKUP_WEAPON_ASSAULTSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_ASSAULTSMG"),
	GetHashKey("PICKUP_WEAPON_AUTOSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_BAT"),
	GetHashKey("PICKUP_WEAPON_BATTLEAXE"),
	GetHashKey("PICKUP_WEAPON_BOTTLE"),
	GetHashKey("PICKUP_WEAPON_BULLPUPRIFLE"),
	GetHashKey("PICKUP_WEAPON_BULLPUPSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_CARBINERIFLE"),
	GetHashKey("PICKUP_WEAPON_COMBATMG"),
	GetHashKey("PICKUP_WEAPON_COMBATPDW"),
	GetHashKey("PICKUP_WEAPON_COMBATPISTOL"),
	GetHashKey("PICKUP_WEAPON_COMPACTLAUNCHER"),
	GetHashKey("PICKUP_WEAPON_COMPACTRIFLE"),
	GetHashKey("PICKUP_WEAPON_CROWBAR"),
	GetHashKey("PICKUP_WEAPON_DAGGER"),
	GetHashKey("PICKUP_WEAPON_DBSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_FIREWORK"),
	GetHashKey("PICKUP_WEAPON_FLAREGUN"),
	GetHashKey("PICKUP_WEAPON_FLASHLIGHT"),
	GetHashKey("PICKUP_WEAPON_GRENADE"),
	GetHashKey("PICKUP_WEAPON_GRENADELAUNCHER"),
	GetHashKey("PICKUP_WEAPON_GUSENBERG"),
	GetHashKey("PICKUP_WEAPON_GOLFCLUB"),
	GetHashKey("PICKUP_WEAPON_HAMMER"),
	GetHashKey("PICKUP_WEAPON_HATCHET"),
	GetHashKey("PICKUP_WEAPON_HEAVYPISTOL"),
	GetHashKey("PICKUP_WEAPON_HEAVYSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_HEAVYSNIPER"),
	GetHashKey("PICKUP_WEAPON_HOMINGLAUNCHER"),
	GetHashKey("PICKUP_WEAPON_KNIFE"),
	GetHashKey("PICKUP_WEAPON_KNUCKLE"),
	GetHashKey("PICKUP_WEAPON_MACHETE"),
	GetHashKey("PICKUP_WEAPON_MACHINEPISTOL"),
	GetHashKey("PICKUP_WEAPON_MARKSMANPISTOL"),
	GetHashKey("PICKUP_WEAPON_MARKSMANRIFLE"),
	GetHashKey("PICKUP_WEAPON_MG"),
	GetHashKey("PICKUP_WEAPON_MICROSMG"),
	GetHashKey("PICKUP_WEAPON_MINIGUN"),
	GetHashKey("PICKUP_WEAPON_MINISMG"),
	GetHashKey("PICKUP_WEAPON_MOLOTOV"),
	GetHashKey("PICKUP_WEAPON_MUSKET"),
	GetHashKey("PICKUP_WEAPON_NIGHTSTICK"),
	GetHashKey("PICKUP_WEAPON_PETROLCAN"),
	GetHashKey("PICKUP_WEAPON_PIPEBOMB"),
	GetHashKey("PICKUP_WEAPON_PISTOL"),
	GetHashKey("PICKUP_WEAPON_PISTOL50"),
	GetHashKey("PICKUP_WEAPON_POOLCUE"),
	GetHashKey("PICKUP_WEAPON_PROXMINE"),
	GetHashKey("PICKUP_WEAPON_PUMPSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_RAILGUN"),
	GetHashKey("PICKUP_WEAPON_REVOLVER"),
	GetHashKey("PICKUP_WEAPON_RPG"),
	GetHashKey("PICKUP_WEAPON_SAWNOFFSHOTGUN"),
	GetHashKey("PICKUP_WEAPON_SMG"),
	GetHashKey("PICKUP_WEAPON_SMOKEGRENADE"),
	GetHashKey("PICKUP_WEAPON_SNIPERRIFLE"),
	GetHashKey("PICKUP_WEAPON_SNSPISTOL"),
	GetHashKey("PICKUP_WEAPON_SPECIALCARBINE"),
	GetHashKey("PICKUP_WEAPON_STICKYBOMB"),
	GetHashKey("PICKUP_WEAPON_STUNGUN"),
	GetHashKey("PICKUP_WEAPON_SWITCHBLADE"),
	GetHashKey("PICKUP_WEAPON_VINTAGEPISTOL"),
	GetHashKey("PICKUP_WEAPON_WRENCH"),
	GetHashKey("PICKUP_WEAPON_RAYCARBINE"),
	}
    for a = 1, #pickupList do
		RemoveAllPickupsOfType(pickupList[a])
		ToggleUsePickupsForPlayer(PlayerId(), pickupList[a], false)
    end
end

CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end

	while true do
		Wait(3)		
		RemoveWeaponDrops()
		DisablePlayerVehicleRewards(playerid)
		WaterOverrideSetStrength(0.5)
		SetPedDensityMultiplierThisFrame(0.01)
		SetScenarioPedDensityMultiplierThisFrame(0.01, 0.02)
		SetRandomVehicleDensityMultiplierThisFrame(0.01)
		SetParkedVehicleDensityMultiplierThisFrame(0.01)
		SetVehicleDensityMultiplierThisFrame(0.01)
		AllowPauseMenuWhenDeadThisFrame()	
		
		for _, iter in ipairs({1, 2, 3, 4, 7, 8, 9, 17, 18,20,22}) do -- 6
			HideHudComponentThisFrame(iter)
		end
		
		local getweapon = GetSelectedPedWeapon(playerPed)
		if (getweapon ~= `WEAPON_SNIPERRIFLE`) and (getweapon ~= `WEAPON_HEAVYSNIPER`) and (getweapon ~= `WEAPON_HEAVYSNIPER_MK2`) and (getweapon ~= `WEAPON_MARKSMANRIFLE`) and (getweapon ~= `WEAPON_MARKSMANRIFLE_MK2`) then
			HideHudComponentThisFrame(14)
		end


		DisableControlAction(0, 37)
		DisableControlAction(1, 157)
		DisableControlAction(1, 158)
		DisableControlAction(1, 160)
		DisableControlAction(1, 164)
		DisableControlAction(1, 165)
	end
end)

CreateThread(function()
    while true do
		local SCENARIO_TYPES = {
			"WORLD_VEHICLE_MILITARY_PLANES_SMALL", 
			"WORLD_VEHICLE_MILITARY_PLANES_BIG",
			"WORLD_VEHICLE_POLICE_BIKE",
			"WORLD_VEHICLE_POLICE_CAR",
			"WORLD_VEHICLE_POLICE",
			"WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
			"WORLD_VEHICLE_AMBULANCE",
		}
		local SCENARIO_GROUPS = {
			2017590552, 
			2141866469, 
			1409640232, 
			"ng_planes", 
		}
		local SUPPRESSED_MODELS = {
			"SHAMAL", 
			"LUXOR", 
			"LUXOR2", 
			"JET", 
			"LAZER",
			"TITAN", 
			"BARRACKS",
			"BARRACKS2", 
			"CRUSADER", 
			"RHINO",
			"AIRTUG",
			"RIPLEY", 
			'FROGGER',
			'MAVERICK',
			'SWIFT',
			'SWIFT2',
		}

        for _, sctyp in next, SCENARIO_TYPES do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, SCENARIO_GROUPS do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, model in next, SUPPRESSED_MODELS do
            SetVehicleModelIsSuppressed(joaat(model), true)
        end
        Wait(10000)
    end
end)

local recoils = {
	[`WEAPON_STUNGUN`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_FLAREGUN`] = {0.9, 1.9}, -- FLARE GUN

	[`WEAPON_SNSPISTOL`] = {2.2, 3.2}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {1.5, 2.4}, -- SNS PISTOL MK2
	[`WEAPON_NAVYREVOLVER`] = {1.5, 2.4}, -- SNS PISTOL MK2
	[`WEAPON_GADGETPISTOL`] = {1.5, 2.4}, -- SNS PISTOL MK2
	[`WEAPON_VINTAGEPISTOL`] = {1.8, 2.8}, -- VINTAGE PISTOL
	[`WEAPON_PISTOL`] = {2.2, 2.8}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {2.2, 2.8}, -- PISTOL MK2
	[`WEAPON_DOUBLEACTION`] = {2.0, 2.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER_MK2`] = {2.0, 2.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER`] = {2.0, 2.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_COMBATPISTOL`] = {2.0, 3.0}, -- COMBAT PISTOL
	[`WEAPON_FIVESEVEN`] = {2.0, 3.0}, -- FIVE SEVEN
	[`WEAPON_GLOCK`] = {2.0, 3.0}, -- GLOCK17
	[`WEAPON_HEAVYPISTOL`] = {0.5, 1.0}, -- HEAVY PISTOL
	[`WEAPON_PISTOL50`] = {2.9, 3.4}, -- 50 PISTOL
	[`WEAPON_CERAMICPISTOL`] = {1.5, 2.5}, -- Ceramicpistol

	[`WEAPON_DBSHOTGUN`] = {0.1, 0.6}, -- DOUBLE BARREL SHOTGUN
	[`WEAPON_SAWNOFFSHOTGUN`] = {2.1, 2.6}, -- SAWNOFF SHOTGUN
	[`WEAPON_PUMPSHOTGUN`] = {8.7, 10.2}, -- PUMP SHOTGUN
	[`WEAPON_PUMPSHOTGUN_MK2`] = {2.7, 3.2}, -- PUMP SHOTGUN MK2
	[`WEAPON_BULLPUPSHOTGUN`] = {1.5, 2.0}, -- BULLPUP SHOTGUN

	[`WEAPON_MICROSMG`] = {0.01, 0.05}, -- MICRO SMG (UZI)
	[`WEAPON_SMG`] = {0.01, 0.01}, -- SMG
	[`WEAPON_MINISMG`] = {0.05, 0.55}, -- MINISMG
	[`WEAPON_SMG_MK2`] = {0.001, 0.01}, -- SMG MK2
	[`WEAPON_ASSAULTSMG`] = {0.04, 0.54}, -- ASSAULT SMG
	[`WEAPON_COMBATPDW`] = {0.01, 0.02}, -- COMBAT PDW
	[`WEAPON_GUSENBERG`] = {0.075, 0.575}, -- GUSENBERG
	[`WEAPON_ASSAULTRIFLE_MK2`] = {0.075, 0.575}, -- GUSENBERG
	[`WEAPON_CARBINERIFLE_MK2`] = {0.075, 0.575}, -- GUSENBERG

	[`WEAPON_COMPACTRIFLE`] = {0.01, 0.03}, -- COMPACT RIFLE
	[`WEAPON_ASSAULTRIFLE`] = {0.1, 0.4}, -- ASSAULT RIFLE
	[`WEAPON_EMPLAUNCHER`] = {0.35, 0.75}, -- ASSAULT RIFLE
	[`WEAPON_HEAVYRIFLE`] = {0.40, 0.74}, -- ASSAULT RIFLE
	[`WEAPON_CARBINERIFLE`] = {0.40, 0.74}, -- CARBINE RIFLE

	[`WEAPON_MARKSMANRIFLE`] = {0.5, 1.0}, -- MARKSMAN RIFLE
	[`WEAPON_SNIPERRIFLE`] = {0.5, 1.0}, -- SNIPER RIFLE
}

local effects = {
	[`WEAPON_STUNGUN`] = {0.01, 0.02}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.01, 0.02}, -- STUN GUN
	[`WEAPON_FLAREGUN`] = {0.01, 0.02}, -- FLARE GUN

	[`WEAPON_SNSPISTOL`] = {0.08, 0.16}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_NAVYREVOLVER`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_GADGETPISTOL`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_VINTAGEPISTOL`] = {0.08, 0.16}, -- VINTAGE PISTOL
	[`WEAPON_PISTOL`] = {0.10, 0.20}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {0.11, 0.22}, -- PISTOL MK2
	[`WEAPON_CERAMICPISTOL`] = {0.07, 0.14}, -- Ceramicpistol
	[`WEAPON_DOUBLEACTION`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER_MK2`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_COMBATPISTOL`] = {0.1, 0.2}, -- COMBAT PISTOL
	[`WEAPON_FIVESEVEN`] = {0.1, 0.2}, -- FIVE SEVEN
	[`WEAPON_GLOCK`] = {0.1, 0.2}, -- GLOCK17
	[`WEAPON_HEAVYPISTOL`] = {0.1, 0.2}, -- HEAVY PISTOL
	[`WEAPON_PISTOL50`] = {0.1, 0.2}, -- 50 PISTOL

	[`WEAPON_DBSHOTGUN`] = {0.1, 0.2}, -- DOUBLE BARREL SHOTGUN
	[`WEAPON_SAWNOFFSHOTGUN`] = {0.095, 0.19}, -- SAWNOFF SHOTGUN
	[`WEAPON_PUMPSHOTGUN`] = {0.09, 0.18}, -- PUMP SHOTGUN
	[`WEAPON_PUMPSHOTGUN_MK2`] = {0.09, 0.18}, -- PUMP SHOTGUN MK2
	[`WEAPON_BULLPUPSHOTGUN`] = {0.085, 0.19}, -- BULLPUP SHOTGUN

	[`WEAPON_MICROSMG`] = {0.05, 0.1}, -- MICRO SMG (UZI)
	[`WEAPON_SMG`] = {0.01, 0.1}, -- SMG
	[`WEAPON_MINISMG`] = {0.05, 0.08}, -- MINISMG
	[`WEAPON_SMG_MK2`] = {0.01, 0.01}, -- SMG MK2
	[`WEAPON_ASSAULTSMG`] = {0.035, 0.07}, -- ASSAULT SMG
	[`WEAPON_COMBATPDW`] = {0.01, 0.02}, -- COMBAT PDW
	[`WEAPON_GUSENBERG`] = {0.035, 0.07}, -- GUSENBERG
	[`WEAPON_ASSAULTRIFLE_MK2`] = {0.035, 0.07}, -- GUSENBERG

	[`WEAPON_COMPACTRIFLE`] = {0.03, 0.08}, -- COMPACT RIFLE
	[`WEAPON_ASSAULTRIFLE`] = {0.023, 0.064}, -- ASSAULT RIFLE
	[`WEAPON_EMPLAUNCHER`] = {0.023, 0.064}, -- ASSAULT RIFLE
	[`WEAPON_HEAVYRIFLE`] = {0.03, 0.06}, -- ASSAULT RIFLE
	[`WEAPON_CARBINERIFLE`] = {0.03, 0.06}, -- CARBINE RIFLE

	[`WEAPON_MARKSMANRIFLE`] = {0.025, 0.05}, -- MARKSMAN RIFLE
	[`WEAPON_SNIPERRIFLE`] = {0.025, 0.05}, -- SNIPER RIFLE	

	[`WEAPON_FIREWORK`] = {0.5, 1.0} -- FIREWORKS
}

local drugged = false
function DisableEffects()
	drugged = true
end

function EnableEffects()
	drugged = false
end
local IsPedShooting = IsPedShooting
CreateThread(function()
	while true do
		Wait(3)
		if IsAimCamActive() then
			if weapon == 'WEAPON_FIREEXTINGUISHER' then
				SetPedInfiniteAmmo(playerPed, true, 'WEAPON_FIREEXTINGUISHER')
			elseif IsPedShooting(playerPed) then
				if can then							
					local recoil = recoils[weapon]
					if recoil and #recoil > 0 then
						local i, tv = (inVehicle and 2 or 1), 0
						if GetFollowPedCamViewMode() ~= 4 then
							repeat
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
								tv = tv + 0.1
								Wait(1)
							until tv >= recoil[i]
						else
							repeat
								local t = GetRandomFloatInRange(0.1, recoil[i])
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (recoil[i] > 0.1 and 1.2 or 0.333))
								tv = tv + t
								Wait(1)
							until tv >= recoil[i]
						end
					end
					if not drugged then	
						local effect = effects[weapon]
						if effect and #effect > 0 then
							ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (inVehicle and (effect[1] * 3) or effect[2]))
						end
					end
				end
			end
		else
			Wait(200)
		end
	end
end)

CreateThread(function()
	AddTextEntry('FE_THDR_GTAO', 'StinkyRP WL OFF ~s~| ~b~ID: ' .. GetPlayerServerId(playerid))
	while true do
		Wait(3)

		local show = false
		for _, model in ipairs(Config.DisplayCrosshair) do
			if weapon == joaat(model) then
				show = true
				break
			end
		end
		if not show then
			local aiming, shooting = IsControlPressed(0,25), IsPedShooting(playerPed)
			if aiming or shooting then
				if shooting and not aiming then
					isShooting = true
					aimTimer = 0
				else
					isShooting = false
				end
				if not isAiming then
					isAiming = true

					lastCamera = GetFollowPedCamViewMode()
					if lastCamera ~= 4 then
						SetFollowPedCamViewMode(4)
					end
				elseif GetFollowPedCamViewMode() ~= 4 then
					SetFollowPedCamViewMode(4)
				end
			elseif isAiming then
				local off = true
				if isShooting then
					off = false

					aimTimer = aimTimer + 20
					if aimTimer == 3000 then
						isShooting = false
						aimTimer = 0
						off = true
					end
				end
				if off then
					isAiming = false
					if lastCamera ~= 4 then
						SetFollowPedCamViewMode(lastCamera)
					end
				end
			elseif not inVehicle then
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 264, true)
			end
		else
			Wait(200)
		end
	end
end)

local veh,a, b, c, d, e, f, g, h, i, j, fmodel, fvspeed, fplate, bmodel, bvspeed, bplate

local radar = {
	shown = false,
	freeze = false,
	info = "~w~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić",
	info2 = "~w~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić",
	plate = "",
	model = "",
	plate2 = "",
	model2 = "",
}

function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1 + w, y - 0.10 + h)
end

CreateThread(function()
	while true do
		Wait(300)
		if radar.shown then
			local coordA = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.0, 1.0)
			local coordB = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 105.0, 0.0)
			local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, vehicle, 7)
			a, b, c, d, e = GetShapeTestResult(frontcar)
			if IsEntityAVehicle(e) then
				fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
				if not found then
					local label = GetLabelText(fmodel)
					if label ~= "NULL" then
						fmodel = label
						fvspeed = GetEntitySpeed(e)*3.6
						fplate = GetVehicleNumberPlateText(e)
					end
				end

				if fmodel ~= 'CARNOTFOUND' then
					local found = false
					local VehTable = exports['esx_vehicleshop']:getVehicles()
					local VehModel = GetEntityModel(e)
					for j=1, #VehTable, 1 do    
						if VehModel == joaat(VehTable[j].model) then
							fmodel = VehTable[j].name
							fvspeed = GetEntitySpeed(e)*3.6
							fplate = GetVehicleNumberPlateText(e)
							found = true
							break
						end
					end
				end
			end

			local bcoordB = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -105.0, 0.0)
			local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, vehicle, 7)
			f, g, h, i, j  = GetShapeTestResult(rearcar)
			if IsEntityAVehicle(j) then
				bmodel = GetDisplayNameFromVehicleModel(GetEntityModel(j))
				if not found then
					local label = GetLabelText(bmodel)
					if label ~= "NULL" then
						bmodel = label
						bvspeed = GetEntitySpeed(j)*3.6
						bplate = GetVehicleNumberPlateText(j)
					end
				end

				if bmodel ~= 'CARNOTFOUND' then
					local found = false
					local VehTable3 = exports['esx_vehicleshop']:getVehicles()
					local VehModel3 = GetEntityModel(j)
					for i=1, #VehTable3, 1 do
						if VehModel3 == joaat(VehTable3[i].model) then
							bmodel = VehTable3[i].name
							bvspeed = GetEntitySpeed(j)*3.6
							bplate = GetVehicleNumberPlateText(j)
							found = true
							break
						end
					end
				end
			end
		else
			Wait(1000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		sleep = true
		if radar.shown then
			sleep = false
			if radar.freeze then
				DrawAdvancedText(0.591, 0.833, 0.005, 0.0028, 0.40, "~y~Zatrzymano radar", 0, 191, 255, 255, 6, 0)
			end
			if not radar.freeze then
				if IsEntityAVehicle(e) then
					radar.plate = GetVehicleNumberPlateText(e)
					radar.model = fmodel
					radar.info = string.format("~y~Rejestracja: ~w~%s  ~y~Pojazd: ~w~%s  ~y~Prędkość: ~w~%s km/h", radar.plate, fmodel, math.floor(GetEntitySpeed(e) * 3.6 + 0.5))
				end

				if IsEntityAVehicle(j) then
					radar.plate2 = GetVehicleNumberPlateText(j)
					radar.model2 = bmodel
					radar.info2 = string.format("~y~Rejestracja: ~w~%s  ~y~Pojazd: ~w~%s  ~y~Prędkość: ~w~%s km/h", radar.plate2, bmodel, math.floor(GetEntitySpeed(j) * 3.6 + 0.5))		
				end
			end

			DrawAdvancedText(0.602, 0.903, 0.005, 0.0028, 0.4, "~b~RADAR - Front ([Num4] aby sprawdzić bazę)", 0, 153, 0, 255, 6, 0)
			DrawAdvancedText(0.602, 0.953, 0.005, 0.0028, 0.4, "~b~RADAR - Tył ([Num6] aby sprawdzić bazę)", 0, 153, 0, 255, 6, 0)
			DrawAdvancedText(0.602, 0.928, 0.005, 0.0028, 0.4, radar.info, 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.602, 0.979, 0.005, 0.0028, 0.4, radar.info2, 255, 255, 255, 255, 6, 0)
		end

		if not IsPedInAnyVehicle(playerPed) then
			radar.shown = false
			radar.freeze = false
			radar.model = nil
			radar.model2 = nil
			radar.plate = nil
			radar.plate2 = nil
		end
		if sleep then 
			Wait(500) 
		end
	end
end)

RegisterCommand("-radarSASP", function(source, args)
	if (IsPedInAnyPoliceVehicle(playerPed) or (IsVehicleModel(vehicle, `police65`) or IsVehicleModel(vehicle, `lsc_flatbed`) or IsVehicleModel(vehicle, `lsc_ford150`))) and not IsPedInAnyHeli(playerPed) then
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') then
			radar.shown = not radar.shown
		end
	end
end, false)

RegisterCommand("-radarSASP2", function(source, args)
	if (IsPedInAnyPoliceVehicle(playerPed) or (IsVehicleModel(vehicle, `police65`) or IsVehicleModel(vehicle, `lsc_flatbed`) or IsVehicleModel(vehicle, `lsc_ford150`))) and not IsPedInAnyHeli(playerPed) then
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') then
			radar.freeze = not radar.freeze
		end
	end
end, false)

RegisterKeyMapping("-radarSASP", "Radar policyjny", "keyboard", "NUMPAD5")
RegisterKeyMapping("-radarSASP2", "Zatrzymaj radar", "keyboard", "NUMPAD8")

RegisterCommand("-blachaSASP", function(source, args)
	if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') then
		if (IsPedInAnyPoliceVehicle(playerPed) or (IsVehicleModel(vehicle, `police65`) or IsVehicleModel(vehicle, `lsc_flatbed`) or IsVehicleModel(vehicle, `lsc_ford150`))) and not IsPedInAnyHeli(playerPed) and radar.shown then
			if radar.plate then
				TriggerEvent('esx_sprawdz:blachy', radar.plate:gsub("%s$", ""), radar.model)
			else
				ESX.ShowNotification('Brak rejestracji pojazdu z przodu')
			end
		end
	end
end, false)

RegisterCommand("-blachaSASP2", function(source, args)
	if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') then
		if (IsPedInAnyPoliceVehicle(playerPed) or (IsVehicleModel(vehicle, `police65`) or IsVehicleModel(vehicle, `lsc_flatbed`) or IsVehicleModel(vehicle, `lsc_ford150`))) and not IsPedInAnyHeli(playerPed) and radar.shown then
			if radar.plate2 then
				TriggerEvent('esx_sprawdz:blachy', radar.plate2:gsub("%s$", ""), radar.model2)
			else
				ESX.ShowNotification('Brak rejestracji pojazdu z tyłu')
			end
		end
	end
end, false)

RegisterKeyMapping("-blachaSASP", "Sprawdź blache [FRONT]", "keyboard", "NUMPAD4")
RegisterKeyMapping("-blachaSASP2", "Sprawdź blache [TYŁ]", "keyboard", "NUMPAD6")

RegisterNetEvent('esx_sprawdz:blachy')
AddEventHandler('esx_sprawdz:blachy', function(plate, model)
	ESX.ShowAdvancedNotification('StinkyRP', plate, '~y~Pojazd: ~s~'..model..'\n~y~Właściciel: ~s~Wyszukiwanie')
	Wait(2000)

	ESX.TriggerServerCallback('esx_falszywyy:getVehicleFromPlate', function(data)
		CreateThread(function()			
			local poszukiwany = '~r~Nie'
			if data.poszukiwany then
				PlaySound(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
				poszukiwany = '~g~Tak'
			end
			
			local str = ''

			if data.dob ~= nil or data.height ~= nil or data.sex ~= nil then
				str = "Data urodzenia: ~y~"..data.dob.."~s~\n"
				str = str .. "Wzrost: ~y~"..data.height .. "~s~\n"
				str = str .. "Płeć: ~y~" ..data.sex
			else
				str = "Data urodzenia: ~y~Brak danych~s~\n"
				str = str .. "Wzrost: ~y~Brak danych~s~\n"
				str = str .. "Płeć: ~y~Brak danych"
			end

			if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
				if data.owner ~= nil then
					TriggerEvent("FeedM:showAdvancedNotification", data.owner, '~s~Poszukiwany: ' ..poszukiwany, str, 'CHAR_BANK_MAZE', 10000)
				else
					TriggerEvent("FeedM:showAdvancedNotification", 'Lokalny', '~s~Poszukiwany: Brak informacji', str, 'CHAR_BANK_MAZE', 10000)
				end
			else
				if data.owner ~= nil then
					TriggerEvent("FeedM:showAdvancedNotification", data.owner, '~s~Obywatel', str, 'CHAR_BANK_MAZE', 10000)
				else
					TriggerEvent("FeedM:showAdvancedNotification", 'Lokalny', '~s~Nieznany', str, 'CHAR_BANK_MAZE', 10000)
				end
			end
		end)

	end, plate)
end)

CreateThread(function()
	while true do
		Wait(60000)
		
		ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(ExilePlayers)
			if ExilePlayers then
				SetDiscordAppId(845669298156208130)

				SetDiscordRichPresenceAsset('logo')
				name = GetPlayerName(playerid)
				id = GetPlayerServerId(playerid)
				SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
				SetRichPresence("ID: "..id.." | "..name.." | "..ExilePlayers['players'].."/"..ExilePlayers['maxPlayers'])
				SetDiscordRichPresenceAction(1, "Discord!", "https://discord.gg/stinkyrp")
				SetDiscordRichPresenceAction(0, "Zagraj z nami!", "fivem://connect/stinkyrp.eu")
			end
		end)
	end
end)

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

AddEventHandler('skinchanger:modelLoaded', function()
	ModelLoaded()
end)

AddEventHandler('falszywyy:newplayer', function()
	newPlayer = true
	ModelLoaded()
end)

function ModelLoaded()
	if loadingPosition ~= true and loadingStatus < 2 then
		print('[StinkyRP]: ModelLoaded')
		CreateThread(function()
			while not loadingPosition do
				Wait(10)
			end
			
			Wait(1000)
			loadingStatus = 2
			SendLoadingScreenMessage(json.encode({allow = true}))
		end)
	end
end

CreateThread(function()
	SetManualShutdownLoadingScreenNui(false)
	StartAudioScene("MP_LEADERBOARD_SCENE")
	SendLoadingScreenMessage(json.encode({ready = true}))
	TriggerEvent("rcore_loading:canTurnOff")
	TriggerEvent('chat:display', false)
	while true do
		Wait(0)
		if loadingStatus == 2 and (IsControlJustPressed(0, 18) or IsDisabledControlPressed(0, 18)) then
			StartWyspa()
			print('[StinkyRP]: Wczytano')
			break
		end
	end
end)

RegisterCommand('play', function(source, args, raw)
	if loadingStatus == 2 then
		CreateThread(StartWyspa)
	end
end, false)

function StartRegister(ped)
	SetCanAttackFriendly(ped, false, false)
	DecorSetBool(ped, "Register", true)
	-- SetPlayerInvincible(playerid, true)
end

function FinishRegister()
	SetCanAttackFriendly(playerPed, true, false)

	DecorRemove(playerPed, "Register")

	NetworkSetFriendlyFireOption(true)
	-- SetPlayerInvincible(playerid, false)
end
local isinintroduction = false
local introstep = 0

function startTrailer(allow)
	local introcam
	local coords = playercoords
	SetEntityVisible(playerPed, false, 0)
	FreezeEntityPosition(playerPed, true)
	SetFocusEntity(playerPed)
	Wait(1)
	BeginSrl()
	introstep = 1
	isinintroduction = true
	Wait(1)
	DoScreenFadeIn(500)
	Wait(100)
	PrepareMusicEvent("MP_MC_START")
	TriggerMusicEvent("MP_MC_START")
	NetworkOverrideClockTime(20,  10,  00)
	TriggerEvent('chat:clear')
	TriggerEvent('ExileRP:ToogleHud')
	DoScreenFadeOut(800)
	Wait(800)
	SendNUIMessage({transactionType = 'playVideo'})
	Wait(3500)
	SendNUIMessage({transactionType = 'playSoundTitle'})
	Wait(18000)
	SendNUIMessage({transactionType = 'stopVideo'})
	Wait(1500)
	SendNUIMessage({transactionType = 'playSoundTrailer'})
	Wait(1500)
	DoScreenFadeIn(2500)
	while true do
		Wait(0)
		DisableControlAction(0, 249, true)
		NetworkSetTalkerProximity(0.0)
		if introstep == 1 then
			SendNUIMessage({transactionType = 'showTitle', txtTitle = 'Dev-Team StinkyRP'})
			introcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
			SetCamActive(introcam, true)
			SetFocusArea(-399.2823, 1301.6515, 409.57, 0.0, 0.0, 0.0)
			SetCamParams(introcam, -399.2823, 1301.6515, 409.57, -10.0, 50.0, 200.3524, 42.2442, 0, 1, 1, 2)
			SetCamParams(introcam, -481.4334, 945.07, 308.17, 0.0, 0.0, 200.8659, 44.8314, 6000, 0, 0, 2)
			ShakeCam(introcam, "HAND_SHAKE", 0.15)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 5000
			introstep = 1.5
		elseif introstep == 1.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			introstep = 2
		elseif introstep == 2 then
			DoScreenFadeOut(800)
			Wait(800)
			DoScreenFadeIn(800)
			SetFocusArea(-2195.572, -661.93, 11.49, 0.0, 0.0, 0.0)
			SetCamParams(introcam, -2195.572, -661.93, 11.49, 1.6106, 0.5186, 18.58, 45.0069, 0, 1, 1, 2)
			SetCamParams(introcam, -2452.572, -721.93, 34.49, 2.8529, 0.5186, 90.58, 70.0069, 7000, 0, 0, 2)
			ShakeCam(introcam, "HAND_SHAKE", 0.15)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 5000
			introstep = 2.5
			SendNUIMessage({transactionType = 'showTitle', txtTitle = 'prezentuje'})
		elseif introstep == 2.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			introstep = 3
		elseif introstep == 3 then
			DoScreenFadeOut(800)
			Wait(800)
			NetworkOverrideClockTime(23,  10,  00)
			SetFocusArea(176.29, -659.53, 108.59, 0.0, 0.0, 0.0)
			
			Wait(320)
			DoScreenFadeIn(800)
			-- SetCamParams(introcam, -233.32, -2101.08, 34.59, 1.6106, 0.5186, 18.58, 45.0069, 0, 1, 1, 2)
			-- SetCamParams(introcam, -188.94, -2036.98, 34.57, 2.8529, 0.5186, 90.58, 70.0069, 7000, 0, 0, 2)
			SetCamParams(introcam, 176.29, -659.53, 108.59, -20.6106, 0.5186, 200.58, 45.0069, 0, 1, 1, 2)
			SetCamParams(introcam, 152.17, -1031.88, 28.57, -10.8529, 0.5186, 150.58, 70.0069, 7000, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 6000
			SendNUIMessage({transactionType = 'showLabel', txtLabel = "Miejsce spotkań"})
			introstep = 3.5
		elseif introstep == 3.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			SendNUIMessage({transactionType = 'hideLabel'})
			introstep = 4
		elseif introstep == 4 then
			DoScreenFadeOut(800)
			Wait(800)
			NetworkOverrideClockTime(20,  10,  00)
			SetFocusArea(-876.737, -1199.3153, 16.6188, 0.0, 0.0, 0.0)
			
			Wait(320)
			DoScreenFadeIn(800)
			SetCamParams(introcam, -876.737, -1199.3153, 16.6188, 0.7142, 0.3156, -105.7306, 40.033, 0, 1, 1, 2)
			SetCamParams(introcam, -838.899, -1204.4563, 7.1000, 0.9614, 0.5214, -140.7306, 40.033, 6000, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 5000
			SendNUIMessage({transactionType = 'showLabel', txtLabel = "Pełne ciekawych ludzi"})
			introstep = 4.5
		elseif introstep == 4.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			SendNUIMessage({transactionType = 'hideLabel'})
			introstep = 5
		elseif introstep == 5 then
			DoScreenFadeOut(800)
			Wait(800)
			SetEntityCoordsNoOffset(playerPed, -64.63, -790.4, 44.64, false, false, false, true)
			SetFocusArea(403.95, -981.39, 47.58, 0.0, 0.0, 0.0)
			
			Wait(320)
			DoScreenFadeIn(800)
			SetCamParams(introcam, 403.95, -981.39, 47.58, -50.7142, 0.3156, 240.607, 20.033, 0, 1, 1, 2)
			--SetCamParams(introcam, 418.08, -980.62, 32.58, 32.9614, 0.5214, 69.60, 40.033, 10000, 0, 0, 2)
			SetCamParams(introcam, 437.617, -981.91, 30.58, 15.9614, 0.5214, 270.60, 40.033, 6000, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 5000
			SendNUIMessage({transactionType = 'showLabel', txtLabel = "Innowacyjnych skryptów i rozwiązań"})
			introstep = 5.5
		elseif introstep == 5.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			SendNUIMessage({transactionType = 'hideLabel'})
			introstep = 6
		elseif introstep == 6 then
			DoScreenFadeOut(800)
			Wait(800)
			SetFocusArea(173.16, -946.22, 30.57, 0.0, 0.0, 0.0)
			
			Wait(320)
			DoScreenFadeIn(800)
			SetCamParams(introcam, 173.16, -946.22, 30.57, 0.7142, 0.3156, 270.595, 20.033, 0, 1, 1, 2)
			SetCamParams(introcam, 167.48, -974.4, 33.95, -2.9614, 0.5214, 258.59, 70.033, 10000, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 9000
			SendNUIMessage({transactionType = 'showLabel', txtLabel = "Dobrego poziomu"})
			introstep = 6.5
		elseif introstep == 6.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			SendNUIMessage({transactionType = 'hideLabel'})
			introstep = 7
		elseif introstep == 7 then
			DoScreenFadeOut(800)
			Wait(800)
			SetFocusArea(1123.93, -710.21, 55.19627, 0.0, 0.0, 0.0)
			
			Wait(320)
			DoScreenFadeIn(800)
			SetCamParams(introcam, 1123.93, -710.21, 56.19627, -5.7142, 0.3156, -170.7306, 60.033, 0, 1, 1, 2)
			SetCamParams(introcam, 1092.09, -634.21, 56.19627, -5.9614, 0.5214, -240.7306, 60.033, 7000, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 6000
			SendNUIMessage({transactionType = 'showLabel', txtLabel = "I dobrej zabawy"})
			introstep = 7.5
		elseif introstep == 7.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			SendNUIMessage({transactionType = 'hideLabel'})
			introstep = 8
		elseif introstep == 8 then
			DoScreenFadeOut(800)
			Wait(800)
			SetFocusArea(1542.44, 3890.90, 44.887, 0.0, 0.0, 0.0)
			Wait(320)
			DoScreenFadeIn(800)
			SetCamParams(introcam, 1542.44, 3890.90, 44.887, -1.6106, 0.5186, 150.3786, 45.0069, 0, 1, 1, 2)
			SetCamParams(introcam, 1476.52, 3879.90, 31.887, -2.8529, 0.5186, 80.8262, 45.0069, 10100, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 9100
			Wait(3500)
			SendNUIMessage({transactionType = 'showTitle', txtTitle = 'coś nowego i świeżego'})
			introstep = 8.5
		elseif introstep == 8.5 then
			Wait(800)
			while GetNetworkTime() < timer do
				Wait(0)
			end
			introstep = 9
		elseif introstep == 9 then
			DoScreenFadeOut(800)
			Wait(800)
			SetFocusArea(-4.6668, -900.9736, 184.887, 0.0, 0.0, 0.0)
			Wait(320)
			DoScreenFadeIn(800)
			SetCamParams(introcam, -4.6668, -900.9736, 184.887, -1.6106, -0.5186, 78.3786, 45.0069, 0, 1, 1, 2)
			SetCamParams(introcam, -23.0087, -896.4288, 184.1939, -2.8529, -0.5186, 81.8262, 45.0069, 18000, 0, 0, 2)
			RenderScriptCams(true, false, 3000, 1, 1)
			timer = GetNetworkTime() + 17000
			
			TriggerEvent('esx_exileschool:reloadLicense')

			local coords = playercoords
			DoScreenFadeOut(800)
			Wait(800)
			SetEntityCoordsNoOffset(playerPed, coords, false, false, false, true)
			FreezeEntityPosition(playerPed, true)
			SetEntityVisible(playerPed, true, 0)
			FreezeEntityPosition(playerPed, false)
			SendNUIMessage({transactionType = 'stopVideo'})
			DestroyCam(createdCamera, 0)
			DestroyCam(createdCamera, 0)
			RenderScriptCams(0, 0, 1, 1, 1)
			createdCamera = 0
			ClearTimecycleModifier("scanline_cam_cheap")
			SetFocusEntity(GetPlayerPed(playerid))    
			Wait(1000)
			Wait(320)
			DoScreenFadeIn(800)
			SendNUIMessage({transactionType = 'stopSoundTrailer'})
			TriggerEvent('ExileRP:ToogleHud')
			CancelMusicEvent("MP_MC_START")
			SetEntityCoords(playerPed, -781.0715, 315.8316, 217.6385, 0.0, 0.0, 0.0, 0.0)
			SetEntityHeading(playerPed, 93.5)
			EnableControlAction(0, 249, true)
			NetworkSetTalkerProximity(3.5)
			ESX.Scaleform.ShowFreemodeMessage('~o~Kreator', 'Ustaw się w dogodnym miejscu, za 30 sekund uruchomi się menu tworzenia postaci.', 10)
			Wait(200)
			ESX.Scaleform.ShowFreemodeMessage('~o~Kreator', 'Ustaw się w dogodnym miejscu, za 20 sekund uruchomi się menu tworzenia postaci.', 10)
			Wait(200)
			ESX.Scaleform.ShowFreemodeMessage('~o~Kreator', 'Ustaw się w dogodnym miejscu, za 10 sekund uruchomi się menu tworzenia postaci.', 10)
			Wait(200)
			TriggerEvent('esx_skin:openSaveableMenuNowy')
			break
		end
	end
end

Citizen.CreateThread(function()
    kordyskina = vec3(-783.98, 315.68, 216.83)
    while true do
        Citizen.Wait(3)
        ls = true
        ped = PlayerPedId()
        kordy = GetEntityCoords(ped)
        distance = Vdist(kordy, kordyskina)
        if distance < 10 then
            ls = false
            DrawMarker(25, kordyskina, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 3.0, 0, 255, 0, 50, 0, 0, 2, 0, 0, 0, 0)
            if distance < 2.0 then
                ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby poprawić postać.')
                if IsControlJustPressed(0,38) then
					TriggerEvent('esx_skin:openSaveableMenu')
                end
            end
        end
        if ls then
            Citizen.Wait(1500)
        end
    end
end)

local displayStreet = true


function DisplayingStreet()
	return displayStreet
end

AddEventHandler('ExileRP:setDisplayStreet', function(val)
	displayStreet = val
end)

function StartWyspa()
	BeginTextCommandBusyspinnerOn("FMMC_STARTTRAN")
	EndTextCommandBusyspinnerOn(4)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

	FreezeEntityPosition(playerPed, false)
	SetEntityVisible(playerPed, true)
	SetPlayerInvincible(playerid, false)
	StopAudioScene("MP_LEADERBOARD_SCENE")

	DoScreenFadeOut(0)	
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	SetPedMaxHealth(playerPed, 200)
	SetEntityHealth(playerPed, 200)
	SetEntityCoords(playerPed, loadingPosition.x, loadingPosition.y, loadingPosition.z)
	loadingPosition = true
	loadingStatus = 3

	-- if not exports['esx_jailer']:getJailStatus() then
	-- 	if not newPlayer then
	-- 		TriggerEvent('codem:client:openui')
	-- 	end
	-- end

	Wait(1000)

	DoScreenFadeIn(1000)
	while IsScreenFadingIn() do
		Wait(10)
	end

	Wait(2000)

	ESX.UI.HUD.SetDisplay(1.0)
	
	TriggerEvent('chat:clear')
	TriggerEvent('wybranopostac', true)
	TriggerEvent('route68:kino_state', false)
	BusyspinnerOff()
	
	if newPlayer then
		TriggerServerEvent("tmsn701:KreatorBucket", true)
		TriggerServerEvent("tmsn701_antytroll:register", true)
		TriggerEvent('skinchanger:loadDefaultModel', function()
			TriggerEvent('esx_skin:openSaveableRestrictedMenuCreate', FinishRegister, FinishRegister, {
			'sex',
			'skin',
			'skin_2',
			'blend_skin',
			'face',
			'face_2',
			'blend_face',
			'skin_3',
			'face_3',
			'blend',
			'eye_color',
			'nose_1',
			'nose_2',
			'nose_3',
			'nose_4',
			'nose_5',
			'nose_6',
			'eyebrow_1',
			'eyebrow_2',
			'cheeks_1',
			'cheeks_2',
			'cheeks_3',
			'lips',
			'jaw_1',
			'jaw_2',
			'chimp_1',
			'chimp_2',
			'chimp_3',
			'chimp_4',
			'neck',
			'age_1',
			'age_2',
			'sun_1',
			'sun_2',
			'moles_1',
			'moles_2',
			'complexion_1',
			'complexion_2',
			'blemishes_1',
			'blemishes_2',
			'hair_1',
			'hair_2',
			'hair_3',
			'hair_color_1',
			'hair_color_2',
			'eyebrows_1',
			'eyebrows_2',
			'eyebrows_3',
			'eyebrows_4',
			'makeup_1',
			'makeup_2',
			'makeup_3',
			'makeup_4',
			'blush_1',
			'blush_2',
			'blush_3',
			'lipstick_1',
			'lipstick_2',
			'lipstick_3',
			'lipstick_4',
			'beard_1',
			'beard_2',
			'beard_3',
			'beard_4',
			'chest_1',
			'chest_2',
			'chest_3',
			'bodyb_1',
			'bodyb_2',
			'tshirt_1',
			'tshirt_2',
			'torso_1',
			'torso_2',
			'decals_1',
			'decals_2',
			'arms',
			'arms_2',
			'pants_1',
			'pants_2',
			'shoes_1',
			'shoes_2',
			'chain_1',
			'chain_2',
			'helmet_1',
			'helmet_2',
			'bags_1',
			'bags_2'
			})
		end)
		startTrailer(allow)
		Wait(500)
	end
	TriggerEvent("exilerp_scripts:connected")
end

AddEventHandler('falszywyy:load', function(cb)
	cb(loadingStatus)
end)

function _DrawText(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

local SetPlayerLockon = SetPlayerLockon
local SetPedMinGroundTimeForStungun = SetPedMinGroundTimeForStungun
local time = 7000
CreateThread(function()
	local pausing = false
	while true do
		Wait(200)
		if IsPedBeingStunned(playerPed) then
			SetPedMinGroundTimeForStungun(playerPed, 6000)
		end
		if not IsPedArmed(playerPed, 1) and GetSelectedPedWeapon(playerPed) ~= `WEAPON_UNARMED` then
			SetPlayerLockon(playerid, false)
		else
			SetPlayerLockon(playerid, true)
		end
	end
end)

local vehicleRollThresh = 60
local vehicleClassDisable = {
    [0] = true,     --compacts
    [1] = true,     --sedans
    [2] = true,     --SUV's
    [3] = true,     --coupes
    [4] = true,     --muscle
    [5] = true,     --sport classic
    [6] = true,     --sport
    [7] = true,     --super
    [8] = false,    --motorcycle
    [9] = true,     --offroad
    [10] = true,    --industrial
    [11] = true,    --utility
    [12] = true,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = true,    --service
    [18] = true,    --emergency
    [19] = false    --military
}
local GetVehicleClass = GetVehicleClass
CreateThread(function()
    while true do
        Wait(10)
        local vehicleClass = GetVehicleClass(vehicle)
        if ((GetPedInVehicleSeat(vehicle, -1) == playerPed) and vehicleClassDisable[vehicleClass]) then
			if not IsEntityInAir(vehicle) then
				local vehicleRoll = GetEntityRoll(vehicle)
				if (math.abs(vehicleRoll) > vehicleRollThresh) then
					DisableControlAction(2, 59)
					DisableControlAction(2, 60)
				end
			else
				Wait(200)
            end
        else
            Wait(500)
        end
    end
end)

local blackBars = false
RegisterNetEvent('route68:kino_state')
AddEventHandler('route68:kino_state', function(rodzaj)
	if rodzaj then
		blackBars = true
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('chat:toggleChat', true)
		TriggerEvent('bodycam:state', true)
		TriggerEvent('esx_status:setDisplay', 0.0)
		TriggerEvent('radar:setHidden', true)
		TriggerEvent('carhud:display', false)
	elseif rodzaj == false then
		blackBars = false
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('chat:toggleChat', false)
		TriggerEvent('bodycam:state', false)
		TriggerEvent('esx_status:setDisplay', 1.0)
		TriggerEvent('radar:setHidden', false)
		TriggerEvent('carhud:display', true)
	end
end)

RegisterNetEvent('route68:kino')
AddEventHandler('route68:kino', function()
	cam = not cam
	
	if cam then
		blackBars = true
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('chat:toggleChat', true)
		TriggerEvent('bodycam:state', true)
		TriggerEvent('esx_status:setDisplay', 0.0)
		TriggerEvent('radar:setHidden', true)
		TriggerEvent('carhud:display', false)
	elseif not cam then
		blackBars = false
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('chat:toggleChat', false)
		TriggerEvent('bodycam:state', false)
		TriggerEvent('esx_status:setDisplay', 1.0)
		TriggerEvent('radar:setHidden', false)
		TriggerEvent('carhud:display', true)
	end
end)

CreateThread(function()
    while true do
        Wait(2)
        if blackBars then
            DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
            DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)
		else
			Wait(333)
		end
    end
end)

local simples = {
	`WEAPON_STUNGUN`,
	`WEAPON_FLAREGUN`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_SNSPISTOL_MK2`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_PISTOL`,
	`WEAPON_PISTOL_MK2`,
	`WEAPON_PISTOL50`,
	`WEAPON_GADGETPISTOL`,
	`WEAPON_DOUBLEACTION`,
	`WEAPON_FLASHBANG`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_FIVESEVEN`,
	`WEAPON_GLOCK`,
	`WEAPON_APPISTOL`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_CERAMICPISTOL`,
	`WEAPON_SNOWBALL`,
	`WEAPON_BALL`,
	`WEAPON_FLARE`,
	`WEAPON_FLASHLIGHT`,
	`WEAPON_KNUCKLE`,
	`WEAPON_SWITCHBLADE`,
	`WEAPON_NIGHTSTICK`,
	`WEAPON_KNIFE`,
	`WEAPON_DAGGER`,
	`WEAPON_MACHETE`,
	`WEAPON_HAMMER`,
	`WEAPON_WRENCH`,
	`WEAPON_CROWBAR`,
	`WEAPON_FERTILIZERCAN`,
	`WEAPON_REVOLVER`,
	`WEAPON_REVOLVER_MK2`,
	`WEAPON_STUNGUN_MP`,
	`WEAPON_STICKYBOMB`,
	`WEAPON_MOLOTOV`,
	`WEAPON_COMPACTLAUNCHER`,
	`WEAPON_DBSHOTGUN`,
	`WEAPON_SAWNOFFSHOTGUN`,
	`WEAPON_MICROSMG`,
	`WEAPON_SMG_MK2`,
	`WEAPON_NAVYREVOLVER`,
}

local types = {
	[2] = true,
	[3] = true,
	[5] = true,
	[6] = true,
	[10] = true,
	[12] = true
}
local DoesEntityExist = DoesEntityExist
local IsEntityDead = IsEntityDead
local holstered = 0
CreateThread(function()
	RequestAnimDict("rcmjosh4")
	while not HasAnimDictLoaded("rcmjosh4") do
		Wait(0)
	end

	RequestAnimDict("reaction@intimidation@1h")
	while not HasAnimDictLoaded("reaction@intimidation@1h") do
		Wait(0)
	end

	RequestAnimDict("weapons@pistol@")
	while not HasAnimDictLoaded("weapons@pistol@") do
		Wait(0)
	end

	while true do
		Wait(100)
		if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not inVehicle then
			local weapon = GetSelectedPedWeapon(playerPed)
			if weapon ~= `WEAPON_UNARMED` then
				if holstered == 0 then
					local t = 0
					if `WEAPON_SWITCHBLADE` == weapon then
						t = 1
					elseif CheckSimple(weapon) then
						TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
						t = 1
					elseif types[GetWeaponDamageType(weapon)] then
						-- TriggerServerEvent('k:sendNotif', 'Wyciąga broń długą')
						TaskPlayAnim(playerPed, "reaction@intimidation@1h", "intro", 3.0,1.0, -1, 48, 0, 0, 0, 0)
						SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED` , true)
						t = 2
					end

					holstered = weapon
					if t > 0 then
						if t == 1 then
							Wait(600)
						elseif t == 2 then
							Wait(1000)
							SetCurrentPedWeapon(playerPed, weapon, true)
							Wait(1500)
						end

						ClearPedTasks(playerPed)
					end
				elseif holstered ~= weapon then
					local t, h = 0, false
					if `WEAPON_SWITCHBLADE` == holstered then
						Wait(1500)
						ClearPedTasks(playerPed)

						if CheckSimple(weapon) and not IsEntityInAnyVehicle(PlayerPedId(), false) then
							TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
							t = 600
						elseif types[GetWeaponDamageType(weapon)]  and not IsEntityInAnyVehicle(PlayerPedId(), false)then
							-- TriggerServerEvent('k:sendNotif', 'Wyciąga broń długą')
							TaskPlayAnim(playerPed, "reaction@intimidation@1h", "intro", 3.0,1.0, -1, 48, 0, 0, 0, 0)
							SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED` , true)
							h = true
							t = 1000
						end
					elseif `WEAPON_SWITCHBLADE` == weapon then
						t = 600
					elseif CheckSimple(holstered) and CheckSimple(weapon) then
						TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
						t = 600
					elseif types[GetWeaponDamageType(holstered)] and types[GetWeaponDamageType(weapon)] then
						-- TriggerServerEvent('k:sendNotif', 'Wyciąga broń długą')
						TaskPlayAnim(playerPed, "reaction@intimidation@1h", "intro", 3.0,1.0, -1, 48, 0, 0, 0, 0)
						SetCurrentPedWeapon(playerPed, holstered, true)
						h = true
						t = 1000
					end

					holstered = weapon
					if t > 0 then
						Wait(t)
						if h then
							SetCurrentPedWeapon(playerPed, weapon, true)
							Wait(1500)
						end

						ClearPedTasks(playerPed)
					end
				end
			elseif holstered ~= 0 then
				local t, h = 0, false
				if `WEAPON_DOUBLEACTION` == holstered or `WEAPON_SWITCHBLADE` == holstered then
					t = 1500
				elseif CheckSimple(holstered) then
					TaskPlayAnim(playerPed, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
					t = 600
				elseif types[GetWeaponDamageType(holstered)] then
					-- TriggerServerEvent('k:sendNotif', 'Chowa broń długą')
					TaskPlayAnim(playerPed, "reaction@intimidation@1h", "outro", 8.0,2.0, -1, 48, 1, 0, 0, 0)
					SetCurrentPedWeapon(playerPed, holstered, true)
					h = true
					t = 1500
				end

				holstered = 0
				if t > 0 then
					Wait(t)
					if h then
						SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED` , true)
					end

					ClearPedTasks(playerPed)
				end
			end
		end
	end
end)

function CheckSimple(weapon)
	for _, simple in ipairs(simples) do
		if simple == weapon then
			return true
		end
	end

	return false
end

local canUsePropfix = true
RegisterCommand("propfix", function()
	if GetEntityHealth(playerPed) > 0 and not exports["esx_ambulancejob"]:isDead() then
		if not IsPedCuffed(playerPed) then
		if not IsPedSittingInAnyVehicle(playerPed) then
			if canUsePropfix then
					TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('exile_logs:triggerLog', 'Gracz użył komendy /propfix', 'propfix')
					wait = true
					Wait(50)
					local armour =	GetPedArmour(playerPed)
					local health = GetEntityHealth(playerPed)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadSkin', {sex=1})
						Wait(1000)
						TriggerEvent('skinchanger:loadSkin', {sex=0})
					elseif skin.sex == 1 then
						TriggerEvent('skinchanger:loadSkin', {sex=0})
						Wait(1000)
						TriggerEvent('skinchanger:loadSkin', {sex=1})
					end
					Wait(1000)
					ESX.ShowNotification('Załadowano ~g~HP / ARMOR ~w~sprzed użycia ~g~/propfix')
					SetEntityHealth(playerPed, health)
					SetPedArmour(playerPed, armour)
					canUsePropfix = false
					Wait(300000)
					canUsePropfix = true
					end)
				else
					ESX.ShowNotification('~r~Nie możesz tak często używać tej komendy!')
				end
			else
				ESX.ShowNotification('~r~Nie możesz używać propfixa w aucie')
			end
		else
			ESX.ShowNotification('~r~Nie możesz używać tej komendy podczas bycia zakutym.')
		end
	else
		ESX.ShowNotification('~r~Nie możesz używać tej komendy podczas BW.')
	end
end)

local HUD = {
	Blip = nil,
  }
  
CreateThread(function()
	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

	SetBlipAlpha(GetMainPlayerBlipId(), 0)
	SetBlipAlpha(GetNorthRadarBlip(), 0)
	while true do
		Wait(500)
		if IsPedOnFoot(playerPed) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(playerPed, true) then
			SetRadarZoom(1100)
		end
		local heading = GetEntityHeading(playerPed)
		if HUD.Blip and DoesBlipExist(HUD.Blip) then
			RemoveBlip(HUD.Blip)
		end

		HUD.Blip = AddBlipForEntity(playerPed)
		SetBlipSprite(HUD.Blip, (inVehicle and 545 or 1))

		SetBlipScale(HUD.Blip, 1.0)
		SetBlipCategory(HUD.Blip, 1)
		SetBlipPriority(HUD.Blip, 10)
		SetBlipColour(HUD.Blip, 55)
		SetBlipAsShortRange(HUD.Blip, true)

		SetBlipRotation(HUD.Blip, math.ceil(heading))
		ShowHeadingIndicatorOnBlip(HUD.Blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Twoja pozycja")
		EndTextCommandSetBlipName(HUD.Blip)
	end
end)

local ExileBlips = {
	{
		coords = {135.32, 323.05, 116.63},
        sprite = 473,
        display = 4,
        scale = 0.7,
        color = 56,
        shortrange = true,
        name = "Magazyn",
        exileBlip = false,
        exileBlipId = ""
    },
    {
        coords = {54.19, -1574.98, 29.46},
        sprite = 442,
        display = 4,
        scale = 0.7,
        color = 4,
        shortrange = true,
        name = "Milkman",
        exileBlip = true,
        exileBlipId = "exilerp_mleczarz"
    },
	{
        coords = {-1202.41, -895.03, 13.99},
        sprite = 126,
        display = 4,
        scale = 0.7,
        color = 5,
        shortrange = true,
        name = "Burgershot",
        exileBlip = true,
        exileBlipId = "exilerp_burgerownia"
    },
	{
        coords = {-71.9, 6265.27, 31.11},
        sprite = 480,
        display = 4,
        scale = 0.7,
        color = 21,
        shortrange = true,
        name = "Rzeźnik",
        exileBlip = true,
        exileBlipId = "exilerp_rzeznik"
    },
	{
        coords = {796.1, -749.96, 31.26},
        sprite = 488,
        display = 4,
        scale = 0.7,
        color = 0,
        shortrange = true,
        name = "Pizza This",
        exileBlip = true,
        exileBlipId = "exilerp_pizzathis"
    },
	{
        coords = {-332.15, -2792.74, 4.1},
        sprite = 471,
        display = 4,
        scale = 0.7,
        color = 3,
        shortrange = true,
        name = "Sklep z łodziami",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-718.77, -1326.51, 0.7},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {1736.29, 3976.24, 31.08},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-285.01, 6627.6, 6.24},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-3420.4172, 955.6319, 7.396},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {2836.5044, -732.4112, 0.3822},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {3373.8213, 5183.4863, 0.5161},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-941.13, -2954.42, 13.05},
        sprite = 584,
        display = 4,
        scale = 0.7,
        color = 30,
        shortrange = true,
        name = "Sklep z samolotami",
        exileBlip = true,
        exileBlipId = "airport2"
    },
	{
        coords = {-804.27, -1368.97, 4.32},
        sprite = 481,
        display = 4,
        scale = 0.7,
        color = 38,
        shortrange = true,
        name = "Extreme Sports",
        exileBlip = true,
        exileBlipId = "exilerp_extremesports"
    },
	{
        coords = {-1013.67, -481.0, 39.32},
        sprite = 133,
        display = 4,
        scale = 0.7,
        color = 7,
        shortrange = true,
        name = "Psycholog",
        exileBlip = true,
        exileBlipId = "exilerp_psycholog"
    },
	{
        coords = {-550.9989, -912.3848, 28.8366},
        sprite = 184,
        display = 4,
        scale = 0.7,
        color = 37,
        shortrange = true,
        name = "Weazel News",
        exileBlip = true,
        exileBlipId = "exilerp_weazelnews"
    },
	{
        coords = {-627.85 , 222.70, 94.60},
        sprite = 112,
        display = 4,
        scale = 0.7,
        color = 0,
        shortrange = true,
        name = "X-Gamer",
        exileBlip = true,
        exileBlipId = "exilerp_xgamer"
    },
	{
        coords = {-1045.8291, -2751.5154, 20.41348},
        sprite = 307,
        display = 4,
        scale = 0.7,
        color = 76,
        shortrange = true,
        name = "Lotnisko",
        exileBlip = true,
        exileBlipId = "airport"
    },
	{
        coords = {-1684.17 , -278.34, 74.7},
        sprite = 305,
        display = 4,
        scale = 0.7,
        color = 0,
        shortrange = true,
        name = "Kościół",
        exileBlip = true,
        exileBlipId = "church"
    },
	{
        coords = {932.25, 41.13, 80.29},
        sprite = 679,
        display = 4,
        scale = 0.7,
        color = 5,
        shortrange = true,
        name = "Casino Royale",
        exileBlip = true,
        exileBlipId = "casino"
    },
	{
        coords = {-539.06, -195.56, 38.22},
        sprite = 498,
        display = 4,
        scale = 0.7,
        color = 15,
        shortrange = true,
        name = "Urząd Miasta",
        exileBlip = true,
        exileBlipId = "cityhall"
    },
	{
        coords = {-682.38, -2239.51, 5.94},
        sprite = 440,
        display = 4,
        scale = 0.7,
        color = 49,
        shortrange = true,
        name = "Pralnia Pieniędzy",
        exileBlip = true,
        exileBlipId = "exilerp_pralnia"
    },
	{
        coords = {-1259.09, -359.55, 36.90},
        sprite = 523,
        display = 4,
        scale = 0.7,
        color = 46,
        shortrange = true,
        name = "Luxury Motosports",
        exileBlip = true,
        exileBlipId = "cardealer"
    },
	{
        coords = {-414.8303, -2796.4055, 5.0504},
        sprite = 363,
        display = 4,
        scale = 0.7,
        color = 30,
        shortrange = true,
        name = "PostOP",
        exileBlip = true,
        exileBlipId = "exilerp_kurier"
    },
	{
        coords = {715.05798339844, -971.34069824219, 36.854461669922},
        sprite = 366,
        display = 4,
        scale = 0.7,
        color = 2,
        shortrange = true,
        name = "Fly Beliodas",
        exileBlip = true,
        exileBlipId = "exilerp_krawiec"
    },
	{
        coords = {-1927.351, 2063.881, 139.7437},
        sprite = 479,
        display = 4,
        scale = 0.7,
        color = 27,
        shortrange = true,
        name = "Winiarz",
        exileBlip = true,
        exileBlipId = "exilerp_winiarz"
    },
	{
        coords = {892.95, -162.61, 76.89},
        sprite = 205,
        display = 4,
        scale = 0.7,
        color = 60,
        shortrange = true,
        name = "Downtown Cab. Co.",
        exileBlip = true,
        exileBlipId = "taxi"
    },
}

CreateThread(function()
	for i,v in ipairs(ExileBlips) do
		local blip = AddBlipForCoord(v.coords[1], v.coords[2], v.coords[3])

		SetBlipSprite (blip, v.sprite)
		SetBlipDisplay(blip, v.display)
		SetBlipScale  (blip, v.scale)
		SetBlipColour (blip, v.color)
		SetBlipAsShortRange(blip, v.shortrange)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.name)
		EndTextCommandSetBlipName(blip)
	end	
end)

RegisterNetEvent('exilerp_scripts:onSpecialUse', function(_type)
	
	local playerPedId = PlayerPedId()
	local health = GetEntityHealth(playerPedId)

	if(_type == 'coke') then
		ESX.PlayAnim('anim@amb@nightclub@peds@', 'missfbi3_party_snort_coke_b_male3', 4.0, -1, 0)
		Wait(10000)
		SetPedArmour(playerPedId, math.random(15,30))
		for i=1,3 do
			Wait(250)
			ShakeGameplayCam(playerPedId, 10.0)
		end
		ESX.ShowNotification('~r~Spożyto ~o~Porcje Kokainy')
	elseif(_type == 'meth') then
		ESX.PlayAnim('anim@amb@nightclub@peds@', 'missfbi3_party_snort_coke_b_male3', 4.0, -1, 0)
		Wait(10000)
		SetEntityHealth(playerPedId, 200)
		for i=1,7 do
			Wait(250)
			ShakeGameplayCam(playerPedId, 3.0)
		end
		ESX.ShowNotification('~r~Spożyto ~o~Porcje Metamfetaminy')
		SetPedMoveRateOverride(playerid, 10.0)
		SetRunSprintMultiplierForPlayer(playerid, 1.9)
		Wait(60000)
		SetRunSprintMultiplierForPlayer(playerid, 1.0)
	elseif(_type == 'wybielacz') then
		ESX.PlayAnim('amb@world_human_drinking@coffee@male@idle_a', 'idle_a', 4.0, -1, 0)
		SetPedMovementClipset(playerPedId, 'MOVE_M@DRUNK@VERYDRUNK', 1.0)
		repeat 
			Wait(5000)
			ShakeGameplayCam(playerPedId, 10.0)
			SetEntityHealth(playerPedId, health - 10)
			ESX.ShowNotification('~r~Czujesz sie coraz gorzej')
		until
			exports['esx_ambulancejob']:isDead()

		if(exports['esx_ambulancejob']:isDead()) then
			ClearPedTasksImmediately(playerPedId)
			ESX.ShowNotification('~r~Twój stan się poprawia')
		end
	end 

end)

RegisterNetEvent('exilerp_scripts:onSpecialUse', function(_type)
	
	local playerPedId = PlayerPedId()

	if(_type == 'coke') then
		SetPedArmour(playerPedId, math.random(25,50))
		for i=1,3 do
			Wait(250)
			ShakeGameplayCam(playerPedId, 10.0)
		end
		ESX.ShowNotification('~r~Spożyto ~o~Porcje Kokainy')
	elseif(_type == 'meth') then
		SetTimecycleModifierStrength(10.5, 1.0)
		ShakeGameplayCam('DRUNK_SHAKE', 10.5, 1.5)
		SetRunSprintMultiplierForPlayer(playerid, 1.35)
		ESX.ShowNotification('~r~Spożyto ~o~Porcje Metaamfetaminy')
	elseif(_type == 'wybielacz') then
		SetPedMovementClipset(playerPedId, 'MOVE_M@DRUNK@VERYDRUNK', 1.0)
		repeat 
			Wait(5000)
			ShakeGameplayCam(playerPedId, 10.0)
			SetEntityHealth(playerPedId, GetEntityHealth(playerPedId) - 10)
			ESX.ShowNotification('~r~Czujesz sie coraz gorzej')
		until
			exports['esx_ambulancejob']:isDead()

		if(exports['esx_ambulancejob']:isDead()) then
			ClearPedTasksImmediately(playerPedId)
		end
	end 

end)

local function switchSeat(_, args)
    local seatIndex = tonumber(args[1]) - 1
    
    if seatIndex < -1 or seatIndex >= 4 then
		ESX.ShowNotification('~r~Nie możesz przesiąść się na to miejsce!')
    else
        if vehicle ~= nil and vehicle > 0 then
            CreateThread(function()
				Wait(100)
				SetPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)
            end)
        end
    end
end

RegisterCommand("seat", switchSeat)

CreateThread(function ()
	while true do
		Wait(0)
		sleep = false
		if #(playercoords - vec3(0.0, 0.0, 0.0)) < 5.0 then
			ESX.DrawMarker(vec3(0.0, 0.0, 8.8))
			ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby przeteleportować się na spawn')
			if IsControlJustReleased(0, 38) then
				SetEntityCoords(playerPed, -541.20, -210.83, 36.69)
			end
		else
			sleep = true
		end
		if sleep then
			Wait(1000)
		end
	end
end)

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)
 
local Vehicle = {
    Coords = nil,
    Vehicle = nil,
    Dimension = nil,
    IsInFront = false
}
 
local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
 
local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end
 
CreateThread(function()
    while true do
        Wait(500)
        local vehicle = ESX.Game.GetClosestVehicle()
        if vehicle and vehicle ~= 0 then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local vehpos = GetEntityCoords(vehicle)
            local dimension = GetModelDimensions(GetEntityModel(vehicle), First, Second)
 
            if #(pos - vehpos) < 3.0 and not IsPedInAnyVehicle(ped, false) then
                Vehicle.Coords = vehpos
                Vehicle.Dimensions = dimension
                Vehicle.Vehicle = vehicle
                if #(vehpos + GetEntityForwardVector(vehicle) - pos) >
                    #(vehpos + GetEntityForwardVector(vehicle) * -1 - pos) then
                    Vehicle.IsInFront = false
                else
                    Vehicle.IsInFront = true
                end
            else
                Vehicle = {
                    Coords = nil,
                    Vehicle = nil,
                    Dimensions = nil,
                    IsInFront = false
                }
            end
        end
    end
end)
 
CreateThread(function()
    local sleep
    while true do
        sleep = 250
        if Vehicle.Vehicle then
            local ped = PlayerPedId()
            local vehClass = GetVehicleClass(Vehicle.Vehicle)
            sleep = 0
 
            if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= 100.0 and GetVehicleEngineHealth(Vehicle.Vehicle) >= 0 then
                if vehClass ~= 13 or vehClass ~= 14 or vehClass ~= 15 or vehClass ~= 16 then
                    DrawText3Ds(Vehicle.Coords.x, Vehicle.Coords.y, Vehicle.Coords.z, 'Naciśnij [~g~SHIFT~w~] i [~g~E~w~] aby pchać pojazd')
                end
            end
 
            if IsControlPressed(0, 21) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and
                not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, 38) and
                GetVehicleEngineHealth(Vehicle.Vehicle) <= 100.0 then
                NetworkRequestControlOfEntity(Vehicle.Vehicle)
                if Vehicle.IsInFront then
                    AttachEntityToEntity(ped, Vehicle.Vehicle, GetPedBoneIndex(ped, 6286), 0.0,
					Vehicle.Dimensions.y * -1 + 0.1, Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, false, false, false,
					true, 0, true)
                else
                    AttachEntityToEntity(ped, Vehicle.Vehicle, GetPedBoneIndex(ped, 6286), 0.0,
					Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 0.0, false, false, false, true,
					0, true)
                end
 
                loadAnimDict('missfinale_c2ig_11')
                TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)
                Wait(200)
 
                local currentVehicle = Vehicle.Vehicle
                while true do
                    Wait(0)
                    if IsDisabledControlPressed(0, 34) then
                        TaskVehicleTempAction(ped, currentVehicle, 11, 1000)
                    end
 
                    if IsDisabledControlPressed(0, 9) then
                        TaskVehicleTempAction(ped, currentVehicle, 10, 1000)
                    end
 
                    if Vehicle.IsInFront then
                        SetVehicleForwardSpeed(currentVehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(currentVehicle, 1.0)
                    end
 
                    if HasEntityCollidedWithAnything(currentVehicle) then
                        SetVehicleOnGroundProperly(currentVehicle)
                    end
 
                    if not IsDisabledControlPressed(0, 38) then
                        DetachEntity(ped, false, false)
                        StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                        FreezeEntityPosition(ped, false)
                        break
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
	StatSetProfileSetting(226, 0)	
	for key, value in pairs(Config.Visuals) do
		SetVisualSettingFloat(key, value)
	end
	while not Citizen.InvokeNative(0xB8DFD30D6973E135, playerid) do
		Citizen.Wait(100)
	end
end)

local antytrollTimer = 0 
local antytroll = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if antytroll then
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			SetWeaponDamageModifier(-1553120962, 0.0)
			antytrolltext(antytrollTimer)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)

		if antytroll then
			antytrollTimer = antytrollTimer - 1
			TriggerServerEvent("tmsn701_antytroll:update", antytrollTimer)
			if antytrollTimer < 1 then
				antytroll = false
				antytrollTimer = 0
			end
		end
	end
end)

RegisterNetEvent('tmsn701_antytroll:load')
AddEventHandler('tmsn701_antytroll:load', function(timer)
	antytrollTimer = timer
	antytroll = true
end)

RegisterNetEvent('tmsn701_antytroll:clear')
AddEventHandler('tmsn701_antytroll:clear', function()
	antytrollTimer = nil
	antytroll = false
end)


function isAntytroll()
	return antytroll
end

function antytrolltext(czas)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.35, 0.35)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextJustification(0)
	SetTextEntry("STRING")
	AddTextComponentString("~r~Anty-Troll~s~: ~s~"..(czas == 1 and "Pozostała" or czas <= 4 and "Pozostały" or "Pozostało").." ~g~"..czas.."~s~ "..(czas == 1 and "minuta" or czas <= 4 and "minuty" or "minut")..".")
	DrawText(0.472, 0.005)
end