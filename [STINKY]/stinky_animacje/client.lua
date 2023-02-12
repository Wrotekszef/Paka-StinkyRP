local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local isDead = false
local inAnim = false
local timer = nil  
  
local Ped = {
	Active = false,
	Locked = false,
	Alive = false,
	Available = false,
	Visible = false,
	InVehicle = false,
	OnFoot = false,
	Collection = false,
	Slots = false,
}

local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetEntityCoords = GetEntityCoords
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetVehicleClass = GetVehicleClass
local IsVehicleStopped = IsVehicleStopped
local GetIsVehicleEngineRunning = GetIsVehicleEngineRunning
local GetVehicleCurrentGear = GetVehicleCurrentGear
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetPlayerSprintStaminaRemaining = GetPlayerSprintStaminaRemaining
local GetPlayerUnderwaterTimeRemaining = GetPlayerUnderwaterTimeRemaining
local GetEntityHealth = GetEntityHealth
local GetPedArmour = GetPedArmour
local IsPedSwimmingUnderWater = IsPedSwimmingUnderWater
local NetworkIsPlayerTalking = NetworkIsPlayerTalking
local GetPlayerServerId = GetPlayerServerId
local IsPedInAnyVehicle = IsPedInAnyVehicle
local IsPedRunning = IsPedRunning
local IsPedSprinting = IsPedSprinting
local GetEntityHeading = GetEntityHeading
local IsRadarEnabled = IsRadarEnabled
local GetVehicleCurrentRpm = GetVehicleCurrentRpm
local GetEntitySpeed = GetEntitySpeed
local IsPauseMenuActive = IsPauseMenuActive
local GetVehicleEstimatedMaxSpeed = GetVehicleEstimatedMaxSpeed
local SetBigmapActive = SetBigmapActive
local DisplayRadar = DisplayRadar
local IsBigmapActive = IsBigmapActive
local IsBigmapFull = IsBigmapFull
local GetGameTimer = GetGameTimer
local GetActiveScreenResolution = GetActiveScreenResolution
local GetSafeZoneSize = GetSafeZoneSize
local GetAspectRatio = GetAspectRatio
local GetStreetNameAtCoord = GetStreetNameAtCoord
local GetStreetNameFromHashKey = GetStreetNameFromHashKey
local GetNameOfZone = GetNameOfZone
local SetRadarBigmapEnabled = SetRadarBigmapEnabled
local GetVehicleEngineHealth = GetVehicleEngineHealth
local AttachEntityToEntity = AttachEntityToEntity
local CreateObject = CreateObject
local SetCurrentPedWeapon = SetCurrentPedWeapon
local TaskPlayAnim = TaskPlayAnim
local ClearPedTasks = ClearPedTasks
local ClearPedTasksImmediately = ClearPedTasksImmediately
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local playerPed = PlayerPedId()
local pid = PlayerId()

CreateThread(function()
	while true do
		Wait(1000)
		playerPed = PlayerPedId()
		pid = PlayerId()
	end
end)

CreateThread(function()
	while true do
		Wait(400)

		Ped.Active = not IsPauseMenuActive()
		if Ped.Active then
			if not IsEntityDead(playerPed) then
				Ped.Locked = (exports['stinky_trunk']:checkInTrunk() or exports['esx_policejob']:IsCuffed() or exports["esx_ambulancejob"]:isDead())
				Ped.Alive = true
				Ped.Available = (Ped.Alive and not Ped.Locked)
				Ped.Visible = IsEntityVisible(playerPed)
				Ped.InVehicle = IsPedInAnyVehicle(playerPed, false)
				Ped.OnFoot = IsPedOnFoot(playerPed)

				if Ped.Available and not Ped.InVehicle and Ped.Visible then
					Ped.Collection = not IsPedFalling(playerPed) and not IsPedDiving(playerPed) and not IsPedSwimming(playerPed) and not IsPedSwimmingUnderWater(playerPed) and not IsPedInCover(playerPed, false) and not IsPedInParachuteFreeFall(playerPed) and (GetPedParachuteState(playerPed) == 0 or GetPedParachuteState(playerPed) == -1) and not IsPedBeingStunned(playerPed)
				else
					Ped.Collection = false
				end
				
				if Ped.Available then
					Ped.Slots = not IsPedFalling(playerPed) and not IsPedDiving(playerPed) and not IsPedSwimming(playerPed) and not IsPedSwimmingUnderWater(playerPed) and not IsPedInCover(playerPed, false) and not IsPedInParachuteFreeFall(playerPed) and (GetPedParachuteState(playerPed) == 0 or GetPedParachuteState(playerPed) == -1) and not IsPedBeingStunned(playerPed)
				else
					Ped.Slots = false
				end
			else
				Ped.Alive = false
				Ped.Available = false
				Ped.Visible = IsEntityVisible(playerPed)
				Ped.InVehicle = false
				Ped.OnFoot = true
				Ped.Collection = false
				Ped.Slots = false
			end
		end
	end
end)

function PedStatus()
	return Ped.Slots
end

  RegisterNetEvent('esx_animations:play')
  AddEventHandler('esx_animations:play', function(anim)
	if exports["esx_ambulancejob"]:isDead() then return end
	if animsblocked then
		return
	end
  		for i=1, #Config.Animations, 1 do
			for j=1, #Config.Animations[i].items, 1 do			  
				if tostring(anim) == tostring(Config.Animations[i].items[j].data.e) then
				  local cat = not IsPedCuffed(playerPed) and Config.Animations[i].items[j].type
				  local cat2 = Config.Animations[i].items[j].type
				  if cat == "anim" then
					  startAnim(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop, Config.Animations[i].items[j].data.car)
					  break
				  elseif cat2 == "faceexpression" then
					  startFaceExpression(Config.Animations[i].items[j].data.anim)
					  break
				  elseif cat == "anim2" then
					  startAnim2(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animangle" then
					  startAnimAngle(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animangle2" then
					  startAnimAngle(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animangle3" then
					  startAnimAngle(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animrozmowa" then
					  startAnimRozmowa(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animtabletka" then
					  startAnimTabletka(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animschowek" then
					  startAnimSchowek(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animochroniarz" then
					  startAnimOchroniarz(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animockniecie" then
					  startAnimOckniecie(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop" then
					  startAnimProp(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop2" then
					  startAnimProp2(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop3" then
					  startAnimProp3(Config.Animations[i].items[j].data.lib)
					  break
				  elseif cat == "animprop5" then
					  startAnimProp5(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop6" then
					  startAnimProp6(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop8" then
					  startAnimProp8(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop10" then
					  startAnimProp10(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop11" then
					  startAnimProp11(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop12" then
					  startAnimProp12(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop15" then
					  startAnimProp15(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
					elseif cat == "animprop16" then
						startAnimProp16(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
				  elseif cat == "animprop17" then
					  startAnimProp17(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop18" then
					  startAnimProp18(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop19" then
					  startAnimProp19(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop20" then
					  startAnimProp20(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop21" then
					  startAnimProp21(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop22" then
					  startAnimProp22(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop23" then
					  startAnimProp23(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop24" then
					  startAnimProp24(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
					elseif cat == "animprop33" then
						startAnimProp33(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop34" then
						startAnimProp34(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop35" then
						startAnimProp35(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop36" then
						startAnimProp36(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop37" then
						startAnimProp37(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop38" then
						startAnimProp38(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop39" then
						startAnimProp39(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
				  elseif cat == "scenario" then
					  startScenario(Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "scenariosit" then
					  startScenario2(Config.Animations[i].items[j].data.anim)
					  break				
				  end
			  end
		  end
	  end
  end)
  
AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

RegisterNetEvent('esx_animations:playscenario')
AddEventHandler('esx_animations:playscenario', function(anim, loop)
	startScenario(anim, loop)
end)

RegisterNetEvent('esx_animations:playscenario2')
AddEventHandler('esx_animations:playscenario2', function(anim)
	startScenario2(anim)
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function startWalkStyle(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(playerPed, anim, true)
	end)
end

function startFaceExpression(anim)
	SetFacialIdleAnimOverride(playerPed, anim)
end
  
  function startAnim(lib, anim, loop, car)
	  if IsPedInAnyVehicle(playerPed, true) and car == 1 then
		SetCurrentPedWeapon(playerPed, -1569615261,true)
		Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		end)
	elseif not IsPedInAnyVehicle(playerPed, true) and car <= 1 then
		if anim ~= "biker_02_stickup_loop" and anim ~= "b_atm_mugging" then
			SetCurrentPedWeapon(playerPed, -1569615261,true)
		end
		Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		end)
	elseif IsPedInAnyVehicle(playerPed, true) and car == 2 then
		SetCurrentPedWeapon(playerPed, -1569615261,true)
		Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		end)
	end
  end
  
  function startAnim2(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimAngle(lib, anim, loop)
	  local co = GetEntityCoords(playerPed)
	  local he = GetEntityHeading(playerPed)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnimAdvanced(playerPed, lib, anim, co.x, co.y, co.z, 0, 0, he-180, 8.0, 3.0, -1, loop, 0.0, 0, 0)
	  end)
  end
  end
  
  function startAnimAngle2(lib, anim, loop)
	  local co = GetEntityCoords(playerPed)
	  local he = GetEntityHeading(playerPed)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnimAdvanced(playerPed, lib, anim, co.x, co.y, co.z, 0, 0, he-90, 8.0, 3.0, -1, loop, 0.0, 0, 0)
	  end)
  end
  end
  
  function startAnimRozmowa(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, 33000, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimTabletka(lib, anim, loop)
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, 3200, loop, -1, false, false, false)
	  end)
  end
  
  function startAnimSchowek(lib, anim, loop)
	  if IsPedInAnyVehicle(playerPed, true) then
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, 5000, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimOchroniarz(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  Wait(1500)
		  RequestAnimDict("amb@world_human_stand_guard@male@base")
		  while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@base")) do Wait(0) end
		  TaskPlayAnim(playerPed, "amb@world_human_stand_guard@male@base", "base", 8.0, 3.0, -1, 51, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimOckniecie(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, 12000, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimProp(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  kierowanieruchemprop()
		  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  end)
  end
  end
  
  function startAnimProp2(lib, anim, loop)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  notesprop()
	  end)
  end
  
  function startAnimProp3(lib)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
	  TaskPlayAnim(playerPed, "random@burial", "a_burial", 8.0, -4.0, -1, 1, 0, 0, 0, 0)
		  lopataprop()
	  end)
  end
  end

  function startAnimProp5(lib, anim, loop)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  aparatprop()
	  end)
  end
  
  function startAnimProp6(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, 2000, loop, 1, false, false, false)
		  portfeldowodprop()
	  end)
  end
  end
  
  
  function startAnimProp8(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  clipboardprop()
	  end)
  end
  end

  
  function startAnimProp10(lib, anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  scierkaprop()
	  end)
  end
  end
  
  function startAnimProp11(lib, anim, loop, car)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  telefonprop()
	  end)
  end
  
  function startAnimProp12(lib, anim, loop, car)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  telefonprop2()
	  end)
  end
  
  function startAnimProp15(lib, anim, loop, car)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  kawaprop()
	  end)
  end

  function startAnimProp16(lib, anim, loop, car)
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		teddyprop()
	end)
end
  
  
  function startAnimProp17(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  kartonprop()
	  end)
  end
  end
  
  function startAnimProp18(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop()
	  end)
  end
  end
  
  function startAnimProp19(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop2()
	  end)
  end
  end
  
  function startAnimProp20(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop3()
	  end)
  end
  end
  
  function startAnimProp21(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop4()
	  end)
  end
  end
  
  function startAnimProp22(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  wiertarkaprop()
	  end)
  end
  end
  
  function startAnimProp23(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  toolboxprop()
	  end)
  end
  end
  
  function startAnimProp24(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(playerPed, true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(playerPed, -1569615261,true)
	  Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  bouquetprop()
	  end)
  end
  end

  function startAnimProp33(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		bouquetprop()
	end)
end
end
function startAnimProp34(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		guitarprop()
	end)
end
end
function startAnimProp35(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
		usuwanieanimprop()
		SetCurrentPedWeapon(playerPed, -1569615261,true)
		Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
			bookprop()
		end)
	end
	end
function startAnimProp36(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		szampanprop()
	end)
end
end
function startAnimProp37(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		wineprop()
	end)
end
end

function startAnimProp38(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		stickprop()
		stickprop2()
	end)
end
end

function startAnimProp39(lib, anim, loop, car)
	if not IsPedInAnyVehicle(playerPed, true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(playerPed, -1569615261,true)
	Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		plecakdokurwyy()
	end)
end
end

  function startScenario(anim, loop)
	  if not IsPedInAnyVehicle(playerPed, true) and loop == 1 then
		  TaskStartScenarioInPlace(playerPed, anim, 0, true)
	  elseif not IsPedInAnyVehicle(playerPed, true) and loop == 0 then
		  TaskStartScenarioInPlace(playerPed, anim, 0, false)
	  end
  end
  
  function startScenario2(anim)
	  local pos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -0.6, -0.5)
	  local heading = GetEntityHeading(playerPed)
	  if not IsPedInAnyVehicle(playerPed, true) then
		  ClearPedTasksImmediately(playerPed)
		  TaskStartScenarioAtPosition(playerPed, anim, pos['x'], pos['y'], pos['z'], heading, 0, 1, 0)
	  end
  end
  
function OpenAnimationsMenu(useBinding)
	if animsblocked then return end
	local elements = {}

	if not useBinding then
		table.insert(elements, { label = "Przypisz animacje", value = "bind" })
	else
		table.insert(elements, { label = "Lista przypisanych animacji", value = "binds" })
	end

	if not useBinding then
		table.insert(elements, { label = "Interakcje - Obywatel", value = "synced" })
	end
  
	for i=1, #Config.Animations, 1 do
		table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
	end
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_2") or 'animations', {
		title    = (useBinding and "Bindy") or 'Animacje',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			if data.current.value == "bind" then
				OpenAnimationsMenu(true)
			elseif data.current.value == "synced" then
				OpenSyncedMenu()
			elseif data.current.value == "binds" then
				OpenBindsMenu()
			else		
				OpenAnimationsSubMenu(data.current.value, useBinding)			
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

local markerplayer = nil

function OpenSyncedMenu()
	local elements2 = {}

	for k, v in pairs(Config['Synced']) do
		table.insert(elements2, {['label'] = v['Label'], ['id'] = k})
	end
            
	ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'play_synced',
	{
		title = 'Wspólne animacje',
		align = 'bottom-right',
		elements = elements2
	}, function(data2, menu2)
		current = data2['current']
		local allowed = false
		if Config['Synced'][current['id']]['Car'] then
			if IsPedInAnyVehicle(playerPed, false) then
				allowed = true
			else
				ESX.ShowNotification('~r~Nie jesteś w pojeździe!')
			end
		else
			allowed = true
		end
		if allowed then
			local allowed = false
			local ped = playerPed
			local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(ped, true), 2.0)
			local firstplayer = nil
			if #playersInArea >= 1 then
				local elements = {}
				for _, playerPed in ipairs(playersInArea) do
					if playerPed ~= pid then
						local sid = GetPlayerServerId(playerPed)
	
						table.insert(elements, {label = sid, value = sid})
					end
				end
				for k,v in pairs(elements) do
					if k == 1 then
						firstplayer = GetPlayerFromServerId(v.value)
					end
				end
				markerplayer = firstplayer
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "exilerp_animacje_synced",
				{
					title = "Wybierz obywatela",
					align = "center",
					elements = elements
				},
				function(data, menu)
					menu.close()
					if timer < GetGameTimer() then
                        ESX.ShowNotification('~b~Wysłano propozycję animacji!')
						TriggerServerEvent('loffe_animations:requestSynced', data.current.value, current['id'])
						markerplayer = nil
						timer = GetGameTimer() + 10000
					else
						ESX.ShowNotification('~r~Poczekaj chwilę przed następną propozycją wspólnej animacji')
						markerplayer = nil
					end
				end, function(data, menu)
					menu.close()
					markerplayer = nil
				end, function(data, menu)
					markerplayer = GetPlayerFromServerId(data.current.value)
				end)
			else
				ESX.ShowNotification('~r~Nie ma nikogo w pobliżu')
			end
		end
	end, function(data2, menu2)
		menu2['close']()
	end)
end

CreateThread(function()
	while true do
		Wait(0)
		if markerplayer then
			local ped = GetPlayerPed(markerplayer)
			local coords1 = GetEntityCoords(playerPed, true)
			local coords2 = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))
			if #(coords1 - coords2) < 40.0 then
				DrawMarker(0, coords2.x, coords2.y, coords2.z + 0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.25, 64, 159, 247, 100, false, true, 2, false, false, false, false)
			end
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('loffe_animations:syncRequest')
AddEventHandler('loffe_animations:syncRequest', function(requester, id)
    local accepted = false

	local elements = {}

	table.insert(elements, { label = "Zaakceptuj", value = true })
	table.insert(elements, { label = "Odrzuć", value = false })

	CreateThread(function()
		local resetmenu = false
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'synced_animation_request', {
			title = 'Propozycja animacji '..Config['Synced'][id]['Label']..' od '..requester,
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Zaakceptuj</span>', value = true },
				{ label = '<span style="color: lightcoral">Odrzuć</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			if data.current.value then
				resetmenu = true
				TriggerServerEvent('loffe_animations:syncAccepted', requester, id)
			else
				resetmenu = true
				TriggerServerEvent('loffe_animations:cancelSync', requester)
				ESX.ShowNotification('~r~Odrzuciłeś/aś propozycję wspólnej animacji')
			end
		end, function(data, menu)
			resetmenu = true
			menu.close()
			TriggerServerEvent('loffe_animations:cancelSync', requester)
			ESX.ShowNotification('~r~Odrzuciłeś/aś propozycję wspólnej animacji')
		end)
		Wait(5000)
		if not resetmenu then
			menu.close()
			TriggerServerEvent('loffe_animations:cancelSync', requester)
			ESX.ShowNotification('~r~Propozycja wspólnej animacji wygasła')
		end
	end)
end)

RegisterNetEvent('loffe_animations:playSynced')
AddEventHandler('loffe_animations:playSynced', function(serverid, id, type)
    local anim = Config['Synced'][id][type]

    local target = GetPlayerPed(GetPlayerFromServerId(serverid))
    if anim['Attach'] then
        local attach = anim['Attach']
        AttachEntityToEntity(playerPed, target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
    end

    Wait(750)

    if anim['Type'] == 'animation' then
        PlayAnim(anim['Dict'], anim['Anim'], anim['Flags'])
    end

    if type == 'Requester' then
        anim = Config['Synced'][id]['Accepter']
    else
        anim = Config['Synced'][id]['Requester']
    end
    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(playerPed, target, true)
    end
    DetachEntity(playerPed)
    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(playerPed, target, true)
    end

    ClearPedTasks(playerPed)
end)

PlayAnim = function(Dict, Anim, Flag)
    LoadDict(Dict)
    TaskPlayAnim(playerPed, Dict, Anim, 8.0, -8.0, -1, Flag or 0, 0, false, false, false)
end

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end
  
function OpenAnimationsSubMenu(menu, binding)
	local elements, title = {}, ""

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name == menu then
			title = Config.Animations[i].label
  
			for j=1, #Config.Animations[i].items, 1 do
				if Config.Animations[i].items[j].data.e ~= nil and tostring(Config.Animations[i].items[j].data.e) ~= "" then
					table.insert(elements, {
						label = Config.Animations[i].items[j].label .. ' ("<font color="#409ff7"><b>/e '..tostring(Config.Animations[i].items[j].data.e)..'</b></font>")',
						type  = Config.Animations[i].items[j].type,
						value = Config.Animations[i].items[j].data,
						bind = Config.Animations[i].items[j].data.e
					})
				else
					table.insert(elements, {
						label = Config.Animations[i].items[j].label,
						type  = Config.Animations[i].items[j].type,
						value = Config.Animations[i].items[j].data,
					})
				end
			end

			break
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_sub_2") or 'animations_sub', {
		title = title,
		align = 'right',
		elements = elements
	}, function(data, menu)
		if binding then
			ESX.ShowNotification("~o~Za chwilę rozpocznie się nasłuchiwanie klawisza (BACKSPACE/ESC = Anulowanie)")
			Wait(1500)

			ESX.ShowNotification("~y~Trwa nasłuchiwanie klawisza...")
			while true do
				if IsControlJustPressed(0, 202) then
					ESX.ShowNotification("~r~Anulowano bindowanie!")
					break
				end

				for keyName,keyId in pairs(Keys) do
					if IsControlJustPressed(0, keyId) then		
						menu.close()							
						BindKey(keyName:upper(), data.current.bind)							
						return
					end
				end

				Wait(5)
			end
		else
			local type = data.current.type
			local lib  = data.current.value.lib
			local anim = data.current.value.anim
			local loop = data.current.value.loop
			local car = data.current.value.car
	
			if type == 'scenario' then
				startScenario(anim, loop)
			elseif type == 'scenariosit' then
				startScenario2(anim)
			elseif type == 'walkstyle' then
				startWalkStyle(lib, anim)
			elseif type == 'faceexpression' then
				startFaceExpression(anim)
			elseif type == 'anim' then
				startAnim(lib, anim, loop, car)
			elseif type == 'anim2' then
				startAnim2(lib, anim, loop)
			elseif type == 'animangle' then
				startAnimAngle(lib, anim, loop)
			elseif type == 'animangle2' then
				startAnimAngle2(lib, anim, loop)
			elseif type == 'animangle3' then
				startAnimAngle3(lib, anim, loop)
			elseif type == 'animrozmowa' then
				startAnimRozmowa(lib, anim, loop)
			elseif type == 'animtabletka' then
				startAnimTabletka(lib, anim, loop)
			elseif type == 'animschowek' then
				startAnimSchowek(lib, anim, loop)
			elseif type == 'animochroniarz' then
				startAnimOchroniarz(lib, anim, loop)
			elseif type == 'animockniecie' then
				startAnimOckniecie(lib, anim, loop)
			elseif type == 'animprop' then
				startAnimProp(lib, anim, loop)
			elseif type == 'animprop2' then
				startAnimProp2(lib, anim, loop)
			elseif type == 'animprop3' then
				startAnimProp3(lib)
			elseif type == 'animprop5' then
				startAnimProp5(lib, anim, loop)
			elseif type == 'animprop6' then
				startAnimProp6(lib, anim, loop)
			elseif type == 'animprop8' then
				startAnimProp8(lib, anim, loop)
			elseif type == 'animprop10' then
				startAnimProp10(lib, anim, loop)
			elseif type == 'animprop11' then
				startAnimProp11(lib, anim, loop, car)
			elseif type == 'animprop12' then
				startAnimProp12(lib, anim, loop, car)
			elseif type == 'animprop15' then
				startAnimProp15(lib, anim, loop, car)
			elseif type == 'animprop16' then
				startAnimProp16(lib, anim, loop, car)
			elseif type == 'animprop17' then
				startAnimProp17(lib, anim, loop, car)
			elseif type == 'animprop18' then
				startAnimProp18(lib, anim, loop, car)
			elseif type == 'animprop19' then
				startAnimProp19(lib, anim, loop, car)
			elseif type == 'animprop20' then
				startAnimProp20(lib, anim, loop, car)
			elseif type == 'animprop21' then
				startAnimProp21(lib, anim, loop, car)
			elseif type == 'animprop22' then
				startAnimProp22(lib, anim, loop, car)
			elseif type == 'animprop23' then
				startAnimProp23(lib, anim, loop, car)
			elseif type == 'animprop24' then
				startAnimProp24(lib, anim, loop, car)
			elseif type == 'animprop33' then
				startAnimProp33(lib, anim, loop, car)
			elseif type == 'animprop34' then
				startAnimProp34(lib, anim, loop, car)
			elseif type == 'animprop35' then
				startAnimProp35(lib, anim, loop, car)
			elseif type == 'animprop36' then
				startAnimProp36(lib, anim, loop, car)
			elseif type == 'animprop37' then
				startAnimProp37(lib, anim, loop, car)
			elseif type == 'animprop38' then
				startAnimProp38(lib, anim, loop, car)
			elseif type == 'animprop39' then
				startAnimProp39(lib, anim, loop, car)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterKeyMapping('-animacje', 'Menu animacji', 'keyboard', 'F3')
RegisterCommand('-animacje', function(source, args, rawCommand)
	if not isDead and not exports['esx_policejob']:IsCuffed() then
		OpenAnimationsMenu()
	end
end, false)
local IsControlJustReleased = IsControlJustReleased
CreateThread(function()
	timer = GetGameTimer()
	while true do
		Wait(0)
		if not isDead then
			if IsControlJustReleased(0, 73) then
				ClearPedTasks(playerPed)
				usuwanieanimprop()
			end
		else
			Wait(1000)
		end
	end
end)
  
CreateThread(function()
	while true do
		Wait(500)
		local RemoveWeaponWhenAnim = CheckAnim()
		local RemoveWeaponWhenAnim2 = CheckAnim2()
		  
	  	if RemoveWeaponWhenAnim then
		  	SetCurrentPedWeapon(playerPed, -1569615261, true)
		elseif RemoveWeaponWhenAnim2 then
			SetCurrentPedWeapon(playerPed, -1569615261, true)
		end 
	end
end)
  
  -- BlockActions
  
  local animsDict = {
	['mini@hookers_sp'] = 'idle_reject_loop_c',
	['amb@world_human_hang_out_street@female_arms_crossed@base'] = 'base',
	['anim@amb@nightclub@peds@'] = 'rcmme_amanda1_stand_loop_cop',
	['random@gang_intimidation@'] = '001445_01_gangintimidation_1_female_wave_loop',
	['amb@medic@standing@timeofdeath@base'] = 'base',
	['amb@world_human_paparazzi@male@idle_a'] = 'idle_c',
	['amb@world_human_clipboard@male@idle_a'] = 'idle_c',
	['anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity'] = 'hi_dance_facedj_09_v1_female^1',
	['Anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity'] = 'hi_dance_facedj_09_v1_female^3',
	['aNim@amb@nightclub@dancers@crowddance_facedj@hi_intensity'] = 'hi_dance_facedj_09_v1_female^6',
	['anim@amb@nightclub@dancers@crowddance_facedj@med_intensity'] = 'mi_dance_facedj_09_v1_female^1',
	['anim@amb@nightclub@dancers@crowddance_groups@hi_intensity'] = 'hi_dance_crowd_09_v1_female^1',
	['Anim@amb@nightclub@lazlow@hi_podium@'] = 'danceidle_hi_11_turnaround_laz',
	['aNim@amb@nightclub@lazlow@hi_podium@'] = 'danceidle_hi_17_smackthat_laz',
	['anIm@amb@nightclub@lazlow@hi_podium@'] = 'danceidle_mi_13_enticing_laz',
	['special_ped@mountain_dancer@monologue_3@monologue_3a'] = 'mnt_dnc_buttwag',
	['amb@world_human_cop_idles@male@base'] = 'base',
	['amb@world_human_cop_idles@female@base'] = 'base',
	['cellphone@'] = 'cellphone_text_to_call',
	['amb@world_human_stand_mobile@male@text@base'] = 'base',
	['amb@world_human_drinking@coffee@male@idle_a'] = 'idle_c',
	['mp_player_int_uppergang_sign_a'] = 'mp_player_int_gang_sign_a',
	['mp_player_int_upperv_sign'] = 'mp_player_int_v_sign',
	['rcmepsilonism8'] = 'bag_handler_idle_a',
	['anim@heists@narcotics@trash'] = 'walk',
	['anim@heists@fleeca_bank@drilling'] = 'drill_straight_start',
	['anim@heists@box_carry@'] = 'idle'
  }
  
  local animsDict2 = {
	['amb@world_human_stand_guard@male@base'] = 'base'
  }
  
  
  function CheckAnim()
	  for k,v in pairs(animsDict)do
		  if IsEntityPlayingAnim(playerPed, k, v, 3) then
			  return true;
		  end
	  end
	  return false;
  end
  
  function CheckAnim2()
	  for k,v in pairs(animsDict2)do
		  if IsEntityPlayingAnim(playerPed, k, v, 3) then
			  return true;
		  end
	  end
	  return false;
  end
  
  function BlockAttack()
	  DisableControlAction(0, 25,   true) -- Input Aim
	  DisableControlAction(0, 24,   true) -- Input Attack
	  DisableControlAction(0, 140,  true) -- Melee Attack Alternate
	  DisableControlAction(0, 141,  true) -- Melee Attack Alternate
	  DisableControlAction(0, 142,  true) -- Melee Attack Alternate
	  DisableControlAction(0, 257,  true) -- Input Attack 2
	  DisableControlAction(0, 263,  true) -- Input Melee Attack
	  DisableControlAction(0, 264,  true) -- Input Melee Attack 2
	  DisableControlAction(0, 44,  true) -- Q
	  DisableControlAction(0, 157,  true) -- 1
	  DisableControlAction(0, 158,  true) -- 2
	  DisableControlAction(0, 160,  true) -- 3
	  DisableControlAction(0, 164,  true) -- 4
	  DisableControlAction(0, 165,  true) -- 5
	  DisableControlAction(0, 159,  true) -- 6
	  DisableControlAction(0, 161,  true) -- 7
	  DisableControlAction(0, 162,  true) -- 8
	  DisableControlAction(0, 163,  true) -- 9
	  DisableControlAction(0, 37,  true) -- TAB
	  DisableControlAction(0, 45,  true) -- R
  end
  
  
  -- Props
  
  function kierowanieruchemprop()
  parkingwand = CreateObject(GetHashKey('prop_parking_wand_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(parkingwand, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.1, 0.0, -0.03, 65.0, 100.0, 130.0, 1, 0, 0, 0, 0, 1)
  end
  
  function notesprop()
  notes = CreateObject(GetHashKey('prop_notepad_02'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(notes, playerPed, GetPedBoneIndex(playerPed, 0x49D9), 0.15, 0.03, 0.0, -42.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  pen = CreateObject(GetHashKey('prop_pencil_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(pen, playerPed, GetPedBoneIndex(playerPed, 0xFA10), 0.04, -0.02, 0.01, 90.0, -125.0, -180.0, 1, 0, 0, 0, 0, 1)
  end
  
  function lopataprop()
  lopata = CreateObject(GetHashKey('prop_ld_shovel'), GetEntityCoords(playerPed), true, false, false)
  AttachEntityToEntity(lopata, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
  end
  
  function blachaprop()
  blacha = CreateObject(GetHashKey('prop_fib_badge'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(blacha, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.03, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
  Wait(1000)
  usuwanieanimprop()
  end
  
  function aparatprop()
  aparat = CreateObject(GetHashKey('prop_pap_camera_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(aparat, playerPed, GetPedBoneIndex(playerPed, 0xE5F2), 0.1, -0.05, 0.0, -10.0, 50.0, 5.0, 1, 0, 0, 0, 0, 1)
  end
  
  function portfeldowodprop()
  portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(portfel, playerPed, GetPedBoneIndex(playerPed, 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  Wait(500)
  dowod = CreateObject(GetHashKey('prop_michael_sec_id'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(dowod, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.150, 0.045, -0.015, 0.0, 0.0, 180.0, 1, 0, 0, 0, 0, 1)
  Wait(1300)
  usuwanieportfelanimprop()
  end
  
  function portfelkasaprop()
  portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(portfel, playerPed, GetPedBoneIndex(playerPed, 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  Wait(500)
  kasa = CreateObject(GetHashKey('prop_anim_cash_note'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(kasa, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.175, 0.045, -0.015, 90.0, 90.0, 180.0, 1, 0, 0, 0, 0, 1)
  Wait(1300)
  usuwanieportfelanimprop()
  end
  
  function portfelkasaprop2()
  portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(portfel, playerPed, GetPedBoneIndex(playerPed, 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  Wait(500)
  kasa2 = CreateObject(GetHashKey('prop_anim_cash_pile_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(kasa2, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.175, 0.045, -0.015, 90.0, 90.0, 180.0, 1, 0, 0, 0, 0, 1)
  Wait(1300)
  usuwanieportfelanimprop()
  end
  
  function clipboardprop()
  clipboard = CreateObject(GetHashKey('p_amb_clipboard_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(clipboard, playerPed, GetPedBoneIndex(playerPed, 0x8CBD), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, 1, 0, 0, 0, 0, 1)
  end
  
  function scierkaprop()
  scierka = CreateObject(GetHashKey('prop_huf_rag_01'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(scierka, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.16, 0.0, -0.040, 10.0, 0.0, -45.0, 1, 0, 0, 0, 0, 1)
  end
  
  function telefonprop()
  telefon = CreateObject(GetHashKey('prop_amb_phone'), GetEntityCoords(playerPed), true)-- creates object
  AttachEntityToEntity(telefon, playerPed, GetPedBoneIndex(playerPed, 28422), -0.01, -0.005, 0.0, -10.0, 8.0, 0.0, 1, 0, 0, 0, 0, 1)
  end
  
  function telefonprop2()
  telefon2 = CreateObject(GetHashKey('prop_amb_phone'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(telefon2, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
  end
  
  function burgerprop()
  burger = CreateObject(GetHashKey('prop_sandwich_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(burger, playerPed, GetPedBoneIndex(playerPed, 18905), 0.135, 0.02, 0.05, -30.0, -120.0, -60.0, 1, 1, 0, 1, 1, 1)
  end
  
  function wodaprop()
  woda = CreateObject(GetHashKey('prop_ld_flow_bottle'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(woda, playerPed, GetPedBoneIndex(playerPed, 18905), 0.09, -0.065, 0.045, -100.0, 0.0, -25.0, 1, 1, 0, 1, 1, 1)
  end
  
  function kawaprop()
  kawa = CreateObject(GetHashKey('p_amb_coffeecup_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(kawa, playerPed, GetPedBoneIndex(playerPed, 57005), 0.14, 0.015, -0.03, -80.0, 0.0, -20.0, 1, 1, 0, 1, 1, 1)
  end

  function bouquetprop()
  bouquet = CreateObject(GetHashKey('prop_snow_flower_02'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(bouquet, playerPed, GetPedBoneIndex(playerPed, 24817), -0.29, 0.40, -0.02, -90.0, -90.0, 0.0, 1, 1, 0, 1, 1, 1)
  end

  function teddyprop()
  teddy = CreateObject(GetHashKey('v_ilev_mr_rasberryclean'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(teddy, playerPed, GetPedBoneIndex(playerPed, 24817), -0.20, 0.46, -0.016, -180.0, -90.0, 0.0, 1, 1, 0, 1, 1, 1)
  end
  
  function torbaprop()
  torba = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(torba, playerPed, GetPedBoneIndex(playerPed, 0xE0FD), 0.0, 0.0, 0.0, 0.0, 90.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function kartonprop()
  karton = CreateObject(GetHashKey('v_serv_abox_04'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(karton, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.08, -0.17, 0, 0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop()
  walizka = CreateObject(GetHashKey('prop_ld_case_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka, playerPed, GetPedBoneIndex(playerPed, 57005), 0.13, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop2()
  walizka2 = CreateObject(GetHashKey('hei_p_attache_case_shut'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka2, playerPed, GetPedBoneIndex(playerPed, 57005), 0.13, 0.0, 0.0, 0.0, 0.0, -90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop3()
  walizka3 = CreateObject(GetHashKey('prop_ld_suitcase_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka3, playerPed, GetPedBoneIndex(playerPed, 57005), 0.36, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop4()
  walizka4 = CreateObject(GetHashKey('prop_suitcase_03'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka4, playerPed, GetPedBoneIndex(playerPed, 57005), 0.36, -0.45, -0.05, -50.0, -60.0, 15.0, 1, 1, 0, 1, 1, 1)
  end
  
  function wiertarkaprop()
  wiertarka = CreateObject(GetHashKey('prop_tool_drill'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(wiertarka, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.04, -0.03, -90.0, 180.0, 0.0, 1, 1, 0, 1, 1, 1)
  end
  
  function toolboxprop()
  toolbox = CreateObject(GetHashKey('prop_tool_box_04'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(toolbox, playerPed, GetPedBoneIndex(playerPed, 57005), 0.43, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function toolboxprop2()
  toolbox2 = CreateObject(GetHashKey('prop_tool_box_02'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(toolbox2, playerPed, GetPedBoneIndex(playerPed, 57005), 0.53, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function tabletprop()
  tablet = CreateObject(GetHashKey('hei_prop_dlc_tablet'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(tablet, playerPed, GetPedBoneIndex(playerPed, 28422), -0.05, -0.007, -0.04, 0.0, 0.0, 0.0, 1, 1, 0, 1, 1, 1)
  end

  function guitarprop()
  guitar = CreateObject(GetHashKey('prop_acc_guitar_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(guitar, playerPed, GetPedBoneIndex(playerPed, 24818), -0.1, 0.31, 0.1, 0.0, 20.0, 150.0, 1, 1, 0, 1, 1, 1)
  end

  function bookprop()
  book = CreateObject(GetHashKey('prop_novel_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(book, playerPed, GetPedBoneIndex(playerPed, 6286), 0.15, 0.03, -0.065, 0.0, 180.0, 90.0, 1, 1, 0, 1, 1, 1)
  end

  function szampanprop()
  szampan = CreateObject(GetHashKey('prop_drink_champ'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(szampan, playerPed, GetPedBoneIndex(playerPed, 18905), 0.10, -0.03, 0.03, -100.0, 0.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function wineprop()
  win = CreateObject(GetHashKey('prop_drink_redwine'), 0.10, -0.03, 0.03, -100.0, 0.0, -10.0)
  AttachEntityToEntity(win, playerPed, GetPedBoneIndex(playerPed, 18905), 0.10, -0.03, 0.03, -100.0, 0.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function stickprop()
  stickpropss = CreateObject(GetHashKey('ba_prop_battle_glowstick_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(stickpropss, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0700,0.1400,0.0,-80.0,20.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function stickprop2()
  stickpropss2 = CreateObject(GetHashKey('ba_prop_battle_glowstick_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(stickpropss2, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0700,0.1400,0.0,-80.0,20.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function plecakdokurwyy()
  plecakdokurwy = CreateObject(GetHashKey('p_michael_backpack_s'), 0.07, -0.11, -0.05, 0.0, 90.0, 175.0)
  AttachEntityToEntity(plecakdokurwy, playerPed, GetPedBoneIndex(playerPed, 24818), 0.07, -0.11, -0.05, 0.0, 90.0, 175.0, -10.0, 1, 1, 0, 1, 1, 1)
  end
  
  function usuwanieanimprop()
  DeleteEntity(parkingwand)
  DeleteEntity(notes)
  DeleteEntity(lopata)
  DeleteEntity(blacha)
  DeleteEntity(pen)
  DeleteEntity(aparat)
  DeleteEntity(dowod)
  DeleteEntity(kasa)
  DeleteEntity(kasa2)
  DeleteEntity(clipboard)
  DeleteEntity(scierka)
  DeleteEntity(telefonvvv)
  DeleteEntity(telefon2)
  DeleteEntity(portfel)
  DeleteEntity(burger)
  DeleteEntity(woda)
  DeleteEntity(kawa)
  DeleteEntity(torba)
  DeleteEntity(karton)
  DeleteEntity(walizka)
  DeleteEntity(walizka2)
  DeleteEntity(walizka3)
  DeleteEntity(walizka4)
  DeleteEntity(wiertarka)
  DeleteEntity(toolbox)
  DeleteEntity(toolbox2)
  DeleteEntity(tablet)
  DeleteEntity(teddy)
  DeleteEntity(bouquet)
  DeleteEntity(guitar)
  DeleteEntity(book)
  DeleteEntity(szampan)
  DeleteEntity(win)
  DeleteEntity(stickpropss)
  DeleteEntity(stickpropss2)
  DeleteEntity(plecakdokurwy)
  --DeleteEntity(konkurwa)
  end
  
  function usuwanieportfelanimprop()
  DeleteEntity(dowod)
  DeleteEntity(kasa)
  DeleteEntity(kasa2)
  Wait(200)
  DeleteEntity(portfel)
  end
  
  
  ---------------------------------bongos------------------------------------------------------
  
  local holdingbong = false
  local bongmodel = "hei_heist_sh_bong_01"
  local bong_net = nil
  
  RegisterNetEvent('esx_animations:bongo')
  AddEventHandler('esx_animations:bongo', function(anim)
	  local ad1 = "anim@safehouse@bong"
	  local ad1a = "bong_stage1"
	  local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(pid), 0.0, 0.0, -5.0)
	  local bongspawned = CreateObject(GetHashKey(bongmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	  local netid = ObjToNet(bongspawned)
	  local plyCoords2 = GetEntityCoords(playerPed, true)
	  local head = GetEntityHeading(playerPed)
  
	  if (DoesEntityExist(playerPed) and not LocalPlayer.state.dead) then 
		  loadAnimDict(ad1)
		  RequestModel(GetHashKey(bongmodel))
		  if holdingbong then
			  Wait(100)
			  ClearPedSecondaryTask(playerPed)
			  DetachEntity(NetToObj(bong_net), 1, 1)
			  DeleteEntity(NetToObj(bong_net))
			  bong_net = nil
			  holdingbong = false
		  else
			  Wait(500)
			  SetNetworkIdExistsOnAllMachines(netid, true)
			  NetworkSetNetworkIdDynamic(netid, true)
			  SetNetworkIdCanMigrate(netid, false)
			  AttachEntityToEntity(bongspawned,GetPlayerPed(pid),GetPedBoneIndex(GetPlayerPed(pid), 18905),0.10,-0.25,0.0,95.0,190.0,180.0,1,1,0,1,0,1)
			  Wait(120)
			  bong_net = netid
			  holdingbong = true
			  Wait(1000)
			  TaskPlayAnimAdvanced(playerPed, ad1, ad1a, plyCoords2.x, plyCoords2.y, plyCoords2.z, 0.0, 0.0, head, 8.0, 1.0, 4000, 49, 0.25, 0, 0)
			  Wait(100)
			  Wait(7250)
			  TaskPlayAnim(playerPed, ad2, ad2a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			  Wait(500)
			  ClearPedSecondaryTask(playerPed)
			  DetachEntity(NetToObj(bong_net), 1, 1)
			  DeleteEntity(NetToObj(bong_net))
			  bong_net = nil
			  holdingbong = false
		  end
	  end
  end)
  
  function loadAnimDict(dict)
	  while (not HasAnimDictLoaded(dict)) do 
		  RequestAnimDict(dict)
		  Wait(5)
	  end
  end
  
  function openAnimations()
	OpenAnimationsMenu()
end

local animsblocked = false
function blockAnims(state)
	animsblocked = state
end

RegisterCommand("e",function(source, args)
	if tostring(args[1]) == nil then
		return
	elseif animsblocked then
		return
	elseif tostring(args[1]) == 'bramkarz' then
		local ad = "rcmepsilonism8"
		if ( DoesEntityExist( playerPed ) and not LocalPlayer.state.dead) then
			loadAnimDict( ad )
			if ( IsEntityPlayingAnim( playerPed, ad, "base_carrier", 3 ) ) then
				TaskPlayAnim( playerPed, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			else
				TaskPlayAnim( playerPed, ad, "base_carrier", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			end
		end
	else
		if not LocalPlayer.state.dead then
			TriggerEvent('esx_animations:play', args[1])
		end
	end
end, false)

local liftedplayer = nil
local carried = false
local liftedplayer69 = nil
local carried69 = false

CreateThread(function()
	while true do
		Wait(0)
		if liftedplayer then
			if not IsPedInAnyVehicle(playerPed, false) then
				local coords = GetEntityCoords(playerPed)
				ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
				if IsControlJustPressed(0, Keys['L']) then
					ClearPedTasks(playerPed)
					DetachEntity(playerPed, true, false)
					TriggerServerEvent("cmg2_animations:stop", liftedplayer)
					liftedplayer = nil
				end
			end
		else
			Wait(500)
		end
		if liftedplayer69 then
			if not IsPedInAnyVehicle(playerPed, false) then
				local coords = GetEntityCoords(playerPed)
				ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
				if IsControlJustPressed(0, Keys['L']) then
					ClearPedTasks(playerPed)
					DetachEntity(playerPed, true, false)
					TriggerServerEvent("cmg2_animations:stop", liftedplayer69)
					liftedplayer69 = nil
				end
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if carried then
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['~'], true) -- Hands up
			DisableControlAction(2, Keys['X'], true) -- Cancel Animation
			DisableControlAction(2, Keys['Y'], true) -- Turn off vehicle
			DisableControlAction(2, Keys['PAGEDOWN'], true) -- Crawling
			DisableControlAction(2, Keys['B'], true) -- Pointing
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F6'], true) -- Fraction actions
			DisableControlAction(2, Keys['V'], true) -- Disable changing view
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, Keys['U'], true) -- Disable zamykanie auta
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			if not IsEntityPlayingAnim(playerPed, "nm", "firemans_carry", 3) then
				TaskPlayAnim(playerPed, "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
			end
		else
			Wait(500)
	  	end
		if carried69 then
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['~'], true) -- Hands up
			DisableControlAction(2, Keys['X'], true) -- Cancel Animation
			DisableControlAction(2, Keys['Y'], true) -- Turn off vehicle
			DisableControlAction(2, Keys['PAGEDOWN'], true) -- Crawling
			DisableControlAction(2, Keys['B'], true) -- Pointing
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F6'], true) -- Fraction actions
			DisableControlAction(2, Keys['V'], true) -- Disable changing view
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, Keys['U'], true) -- Disable zamykanie auta
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			if not IsEntityPlayingAnim(playerPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
				TaskPlayAnim(playerPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8.0, 100000, 33, 0, false, false, false)
			end
		else
			Wait(500)
	  	end
	end
end)

RegisterNetEvent('exilerp_animacje:requestlift')
AddEventHandler('exilerp_animacje:requestlift', function(sender)
	CreateThread(function()		
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'request_lift', {
			title = '[' .. sender .. '] chce cie podnieść',
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Tak</span>', value = true },
				{ label = '<span style="color: lightcoral">Nie</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			local sender_ped = GetPlayerPed(GetPlayerFromServerId(sender))
			local playerBag = Player(GetPlayerServerId(sender))
			if playerBag.state.dead or IsPedCuffed(sender_ped) or IsPedBeingStunned(sender_ped) or IsPedDiving(sender_ped) or IsPedFalling(sender_ped) or IsPedJumping(sender_ped) or IsPedRunning(sender_ped) or IsPedSwimming(sender_ped) or exports['esx_vehicleshop']:isPlayerTestingVehicle() then
				ESX.ShowNotification('~r~Osoba nie zdołała cię podnieśc')
				return
			end
			TriggerServerEvent('exilerp_animacje:answerlift', sender, data.current.value)
		end)
		Wait(5000)
		menu.close()
	end)
end)

RegisterNetEvent('exilerp_animacje:answerlift')
AddEventHandler('exilerp_animacje:answerlift', function(answer, target)
	if answer then
		ESX.ShowNotification('~g~Podnosisz osobę')
		liftedplayer = target
		TriggerServerEvent('cmg2_animations:sync', target, 'missfinale_c2mcs_1', 'nm', 'fin_c2_mcs_1_camman', 'firemans_carry', 0.15, 0.27, 0.63, target, 100000, 0.0, 49, 33, 1)
	else
		ESX.ShowNotification('~r~Osoba nie pozwoliła się podnieść')
	end
end)


RegisterNetEvent('exilerp_animacje:requestlift69')
AddEventHandler('exilerp_animacje:requestlift69', function(sender)
	CreateThread(function()		
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'request_lift', {
			title = '[' .. sender .. '] chce cie podnieść',
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Tak</span>', value = true },
				{ label = '<span style="color: lightcoral">Nie</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			local sender_ped = GetPlayerPed(GetPlayerFromServerId(sender))
			local playerBag = Player(GetPlayerServerId(sender))
			if playerBag.state.dead or IsPedCuffed(sender_ped) or IsPedBeingStunned(sender_ped) or IsPedDiving(sender_ped) or IsPedFalling(sender_ped) or IsPedJumping(sender_ped) or IsPedRunning(sender_ped) or IsPedSwimming(sender_ped) or exports['esx_vehicleshop']:isPlayerTestingVehicle() then
				ESX.ShowNotification('~r~Osoba nie zdołała cię podnieśc')
				return
			end
			TriggerServerEvent('exilerp_animacje:answerlift69', sender, data.current.value)
		end)
		Wait(5000)
		menu.close()
	end)
end)

RegisterNetEvent('exilerp_animacje:answerlift69')
AddEventHandler('exilerp_animacje:answerlift69', function(answer, target)
	if answer then
		ESX.ShowNotification('~g~Podnosisz osobę')
		liftedplayer69 = target
		TriggerServerEvent('cmg2_animations:sync69', target, 'anim@heists@box_carry@', 'idle', 'amb@code_human_in_car_idles@generic@ps@base', 'base', -0.07, 0.36, 0.05, target, 100000, 0.0, 49, 33, 1)
	else
		ESX.ShowNotification('~r~Osoba nie pozwoliła się podnieść')
	end
end)
RegisterCommand('podnies', function(source, args, raw)
	local closest_player, closest_distance = ESX.Game.GetClosestPlayer()
    if not exports["esx_ambulancejob"]:isDead()then
        if not exports['esx_policejob']:IsCuffed() then
            if closest_distance < 2.0 and closest_player ~= -1 then
                TriggerServerEvent('route68_animacje:OdpalAnimacje4', GetPlayerServerId(closest_player))
            else
                ClearPedTasks(playerPed)
                DetachEntity(playerPed, true, false)
                ESX.ShowNotification('~r~Brak osoby w pobliżu')
            end
        else
            ClearPedTasks(playerPed)
            DetachEntity(playerPed, true, false)
            ESX.ShowNotification('~r~Nie możesz być zakutym!')
        end
    else
        ClearPedTasks(playerPed)
        DetachEntity(playerPed, true, false)
        ESX.ShowNotification('~r~Nie możesz być obezwładnionym!')
    end
end)

RegisterCommand('podnies2', function(source, args, raw)
	local closest_player, closest_distance = ESX.Game.GetClosestPlayer()
    if not exports["esx_ambulancejob"]:isDead()then
        if not exports['esx_policejob']:IsCuffed() then
            if closest_distance < 2.0 and closest_player ~= -1 then
                TriggerServerEvent('route68_animacje:OdpalAnimacje69', GetPlayerServerId(closest_player))
            else
                ClearPedTasks(playerPed)
                DetachEntity(playerPed, true, false)
                ESX.ShowNotification('~r~Brak osoby w pobliżu')
            end
        else
            ClearPedTasks(playerPed)
            DetachEntity(playerPed, true, false)
            ESX.ShowNotification('~r~Nie możesz być zakutym!')
        end
    else
        ClearPedTasks(playerPed)
        DetachEntity(playerPed, true, false)
        ESX.ShowNotification('~r~Nie możesz być obezwładnionym!')
    end
end)

local Oczekuje4 = false
local Czas4 = 7
local wysylajacy4 = nil

local Oczekuje469 = false
local Czas469 = 7
local wysylajacy469 = nil

RegisterNetEvent('route68_animacje:przytulSynchroC2')
AddEventHandler('route68_animacje:przytulSynchroC2', function(target)
	Oczekuje4 = true
	wysylajacy4 = target
end)

RegisterNetEvent('route68_animacje:przytulSynchroC269')
AddEventHandler('route68_animacje:przytulSynchroC269', function(target)
	Oczekuje469 = true
	wysylajacy469 = target
end)

CreateThread(function()
    while true do
		Wait(1000)
		if Oczekuje4 then
			Czas4 = Czas4 - 1
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Wait(1000)
		if Oczekuje469 then
			Czas469 = Czas469 - 1
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Wait(250)
		if Czas4 < 1 then
			Oczekuje4 = false
			Czas4 = 7
			wysylajacy4 = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Wait(250)
		if Czas469 < 1 then
			Oczekuje469 = false
			Czas469 = 7
			wysylajacy469 = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Wait(0)
		if Oczekuje4 then
			if IsControlJustPressed(0, 246) or IsDisabledControlJustPressed(0, 246) then
				Oczekuje4 = false
				Czas4 = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje5', wysylajacy4)
			end
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Wait(0)
		if Oczekuje469 then
			if IsControlJustPressed(0, 246) or IsDisabledControlJustPressed(0, 246) then
				Oczekuje469 = false
				Czas469 = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje569', wysylajacy469)
			end
		else
			Wait(500)
		end
    end
end)

local carryingBackInProgress = false
local niesie = false

function getCarry()
	return carryingBackInProgress
end

local carryingBackInProgress69 = false
local niesie69 = false

function getCarry69()
	return carryingBackInProgress69
end

CreateThread(function()
	while true do
		Wait(0)
		if niesie == true then
			local coords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
			ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
			if IsControlJustPressed(0, Keys['L']) then
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPlayer)
				carryingBackInProgress = false
				niesie = false
				ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
				DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
				TriggerServerEvent("cmg2_animations:stop", target)
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if niesie69 == true then
			local coords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
			ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
			if IsControlJustPressed(0, Keys['L']) then
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPlayer)
				carryingBackInProgress69 = false
				niesie69 = false
				ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
				DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
				TriggerServerEvent("cmg2_animations:stop69", target)
			end
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length, spin, controlFlag)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Wait(10)
	end

	if spin == nil then 
		spin = 180.0 
	end

	ClearPedTasksImmediately(playerPed)

	local coords = GetEntityCoords(playerPed, true)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	Wait(100)

	AttachEntityToEntity(playerPed, targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)

	if controlFlag == nil then 
		controlFlag = 0 
	end
	
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	carried = true
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Wait(10)
	end

	Wait(500)

	if controlFlag == nil then 
		controlFlag = 0 
	end

	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	carried = false
	ClearPedTasksImmediately(playerPed)
	DetachEntity(playerPed, true, false)
end)

RegisterNetEvent('cmg2_animations:startMenu2')
AddEventHandler('cmg2_animations:startMenu2', function()  
  local Gracz = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(Gracz, false) then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= nil and distance <= 4 then
			TriggerEvent('cmg2_animations:startMenu', GetPlayerServerId(closestPlayer))
		end
	end
end)

RegisterNetEvent('cmg2_animations:startMenu')
AddEventHandler('cmg2_animations:startMenu', function(obiekt)
	if not carryingBackInProgress then
		niesie = true
		carryingBackInProgress = true
		lib = 'missfinale_c2mcs_1'
		anim1 = 'fin_c2_mcs_1_camman'
		lib2 = 'nm'
		anim2 = 'firemans_carry'
		distans = 0.15
		distans2 = 0.27
		height = 0.63
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetPlayerPed(obiekt)
		target = obiekt
		if closestPlayer ~= nil then
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
		local closestPlayer = obiekt
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop",target)
	end
end)

RegisterNetEvent('cmg2_animations:syncTarget69')
AddEventHandler('cmg2_animations:syncTarget69', function(target, animationLib69, animation269, distans69, distans269, height69, length69, spin69, controlFlag69)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(animationLib69)
	while not HasAnimDictLoaded(animationLib69) do
		Wait(10)
	end

	if spin69 == nil then 
		spin69 = 260.0 
	end

	ClearPedTasksImmediately(playerPed)

	local coords = GetEntityCoords(playerPed, true)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	Wait(100)

	AttachEntityToEntity(playerPed, targetPed, 0, distans269, distans69, height69, 0.5, 0.5, spin69, false, false, false, false, 2, false)

	if controlFlag == nil then 
		controlFlag = 0 
	end
	
	TaskPlayAnim(playerPed, animationLib69, animation269, 8.0, -8.0, length69, controlFlag69, 0, false, false, false)

	carried69 = true
end)

RegisterNetEvent('cmg2_animations:syncMe69')
AddEventHandler('cmg2_animations:syncMe69', function(animationLib69, animation69,length69,controlFlag69,animFlag69)
	RequestAnimDict(animationLib69)
	while not HasAnimDictLoaded(animationLib69) do
		Wait(10)
	end

	Wait(500)

	if controlFlag69 == nil then 
		controlFlag69 = 0 
	end

	TaskPlayAnim(playerPed, animationLib69, animation69, 8.0, -8.0, length69, controlFlag69, 0, false, false, false)

	Wait(length69)
end)

RegisterNetEvent('cmg2_animations:cl_stop69')
AddEventHandler('cmg2_animations:cl_stop69', function()
	carried69 = false
	ClearPedTasksImmediately(playerPed)
	DetachEntity(playerPed, true, false)
end)

RegisterNetEvent('cmg2_animations:startMenu269')
AddEventHandler('cmg2_animations:startMenu269', function()  
  local Gracz = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(Gracz, false) then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= nil and distance <= 4 then
			TriggerEvent('cmg2_animations:startMenu69', GetPlayerServerId(closestPlayer))
		end
	end
end)

RegisterNetEvent('cmg2_animations:startMenu69')
AddEventHandler('cmg2_animations:startMenu69', function(obiekt)
	if not carryingBackInProgress69 then
		niesie69 = true
		carryingBackInProgress69 = true
		lib69 = 'anim@heists@box_carry@'
		anim169 = 'idle'
		lib269 = 'amb@code_human_in_car_idles@generic@ps@base'
		anim269 = 'base'
		distans69 = -0.07
		distans269 = 0.36
		height69 = 0.05
		spin69 = 180.0		
		length69 = 100000
		controlFlagMe69 = 49
		controlFlagTarget69 = 33
		animFlagTarget69 = 1
		local closestPlayer = GetPlayerPed(obiekt)
		target = obiekt
		if closestPlayer ~= nil then
			TriggerServerEvent('cmg2_animations:sync69', closestPlayer, lib69,lib269, anim169, anim269, distans69, distans269, height69,target,length69,spin69,controlFlagMe69,controlFlagTarget69,animFlagTarget69)
		end
	else
		carryingBackInProgress69 = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
		local closestPlayer = obiekt
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop69",target)
	end
end)

Bindings = {}
CreateThread(function()
	while true do
		if Bindings ~= {} then
			for key,anim in pairs(Bindings) do
				if Keys[key] then
					if IsControlJustReleased(0, Keys[key]) then
						TriggerEvent('esx_animations:play', anim)
					end
				end
			end
		else
			Wait(500)
		end
		Wait(10)
	end
end)

OpenBindsMenu = function()
	local elements = {}

	table.insert(elements, { label = "<< Usuń wszystkie >>", value = "ALL" })
	for key,anim in pairs(Bindings) do
		table.insert(elements, { label = ("%s - /e %s"):format(key, anim), value = key })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_delter', {
		title = 'Aktualne bindy',
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value ~= "ALL" then
			ESX.ShowNotification(("~g~Pomyślnie usunięto powiązanie [%s] z /e %s"):format(data.current.value, Bindings[data.current.value]))
			UnBindKey(data.current.value)

			Wait(200)
			OpenBindsMenu()
		else
			UnbindAll()
		end
	end, function(data, menu)
		menu.close()
	end)
end

BindKey = function(key, anim)
	if not Bindings[key:upper()] then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_check', {
			title = 'Potwierdź przypisanie '..key..' do /e '..anim..'.',
			align = 'bottom-right',
			elements = { { label = "Tak", check = true }, { label = "Nie" } }
		}, function(data, menu)
			menu.close()

			if data.current.check then
				Bindings[key:upper()] = anim:lower()
				SendNUIMessage({ action = "updateBinding", json = json.encode(Bindings) })
				ESX.ShowNotification(("~g~Pomyślnie powiązano [%s] z /e %s"):format(key:upper(), anim:lower()))
			end
		end, function(data, menu)
			menu.close()
		end)
	else ESX.ShowNotification("~r~Ten klawisz jest już zajęty!") end
end

UnBindKey = function(key)
	Bindings[key] = nil
	SendNUIMessage({ action = "updateBinding", json = json.encode(Bindings) })
end

UnbindAll = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unbindall', {
		title = 'Usunąć wszystkie powiązania?',
		align = 'bottom-right',
		elements = { { label = "Tak", check = true }, { label = "Nie" } }
	}, function(data, menu)
		if data.current.check then
			Bindings = {}
			SendNUIMessage({ action = "updateBinding", json = json.encode(Bindings) })

			ESX.ShowNotification("~g~Usunięto wszystkie powiązania!")
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback("setBinding", function(data)
	if data.binding then
		Bindings = data.binding
	end
end)

RegisterCommand("delbind",function(source, args)
	if Bindings[args[1]:upper()] then
		ESX.ShowNotification(("~g~Usunięto przypisanie [%s] do %s"):format(args[1]:upper(), Bindings[args[1]:upper()]:lower()))
		UnBindKey(args[1]:upper())	
	elseif args[1]:lower() == "all" then
		UnbindAll()
	else
		for key,anim in pairs(Bindings) do
			if anim:lower() == args[1] then
				UnBindKey(key)

				ESX.ShowNotification(("~g~Usunięto przypisanie [%s] do %s"):format(key, anim))
				return
			end
		end

		ESX.ShowNotification(("~r~Nie znaleziono powiązania z nazwą %s!"):format(args[1]))
	end
end, false)

CreateThread(function()
	for i=1, #Config.Animations, 1 do
		for j=1, #Config.Animations[i].items, 1 do
			if Config.Animations[i].items[j].data.e ~= "" then
				TriggerEvent('chat:addSuggestion', '/e '..Config.Animations[i].items[j].data.e)
			end
		end
	end
end)