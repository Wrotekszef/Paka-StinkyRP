local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["centerSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["centerCTRL"] = 36, ["centerALT"] = 19, ["SPACE"] = 22, ["centerCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["center"] = 174, ["center"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
  
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPartNum             = nil
local CurrentAction = nil
local CurrentActionMsg  = ''
local CurrentActionData = {}
local IsDragged 					= false
local IsHandcuffed = false
local HandcuffTimer = nil
local isDead = false
local CopPlayer 					= nil
local Dragging 						= nil
local CurrentTask = {}
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetEntityCoords = GetEntityCoords
local IsPedInAnyVehicle = IsPedInAnyVehicle
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetPlayerServerId = GetPlayerServerId
local SetVehicleLivery = SetVehicleLivery
local SetVehicleExtra = SetVehicleExtra
local SetPedArmour = SetPedArmour
local ClearPedBloodDamage = ClearPedBloodDamage
local ResetPedVisibleDamage = ResetPedVisibleDamage
local ClearPedLastWeaponDamage = ClearPedLastWeaponDamage
local ResetPedMovementClipset = ResetPedMovementClipset
local GetCurrentResourceName = GetCurrentResourceName
local RequestAnimDict = RequestAnimDict
local HasAnimDictLoaded = HasAnimDictLoaded
local IsPedSittingInAnyVehicle = IsPedSittingInAnyVehicle
local TaskLeaveVehicle = TaskLeaveVehicle
local ClearPedTasksImmediately = ClearPedTasksImmediately
local FreezeEntityPosition = FreezeEntityPosition
local GetClosestVehicle = GetClosestVehicle
local IsAnyVehicleNearPoint = IsAnyVehicleNearPoint
local GetVehicleMaxNumberOfPassengers = GetVehicleMaxNumberOfPassengers
local TaskWarpPedIntoVehicle = TaskWarpPedIntoVehicle
local IsVehicleSeatFree = IsVehicleSeatFree
local IsEntityPlayingAnim = IsEntityPlayingAnim
local TaskPlayAnim = TaskPlayAnim
local SetEnableHandcuffs = SetEnableHandcuffs
local TaskSetBlockingOfNonTemporaryEvents = TaskSetBlockingOfNonTemporaryEvents
local TaskStandStill = TaskStandStill
local IsPedCuffed = IsPedCuffed
local DetachEntity = DetachEntity
local TaskReactAndFleePed = TaskReactAndFleePed
local DoesEntityExist = DoesEntityExist
local AttachEntityToEntity = AttachEntityToEntity
local GetEntityHeading = GetEntityHeading
local GetEntityForwardVector = GetEntityForwardVector
local PlaySound = PlaySound
local playerPed = PlayerPedId()
local playerId = PlayerId()
local coords = GetEntityCoords(playerPed)
local inVehicle = IsPedInAnyVehicle(playerPed, false)
local getVeh = GetVehiclePedIsIn(playerPed, false)

CreateThread(function()
	while not HasAnimDictLoaded("random@mugging3") do
        RequestAnimDict("random@mugging3")
        Wait(200)
    end
	while true do
		if IsDragged then
			sleep = 0
		else
			sleep = 250
		end
		playerPed = PlayerPedId()
		playerId = PlayerId()
		coords = GetEntityCoords(playerPed)
		inVehicle = IsPedInAnyVehicle(playerPed, false)
		getVeh = GetVehiclePedIsIn(playerPed, false)
		Wait(sleep)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

function IsCuffed()
	return IsHandcuffed
end
  
function SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, extrason, extrasoff, bulletproof, tint, wheel, tuning, plate)
	local t = {
		modArmor        = 4,
		modTurbo        = true,
		modXenon        = true,
		bulletProofTyre = false,
		windowTint      = 0,
		dirtLevel       = 0,
		color1			= 0,
		color2			= 0,
		modEngine		= 3,
		modBrakes		= 2,
		modTransmission	= 2,
		modSuspension 	= -1,
	}
	
	if tuning then
		t.modEngine = 3
		t.modBrakes = 2
		t.modTransmission = 2
		t.modSuspension = -1
	end

	if offroad then
		t.wheelColor = 5
		t.wheels = 4
		t.modFrontWheels = 17
	end

	if wheelsxd then
		t.wheels = 1
		t.modFrontWheels = 5
	end

	if bulletproof then
		t.bulletProofTyre = true
	end

	if color then
		t.color1 = color
	end

	if tint then
		t.windowTint = tint
	end

	if wheel then
		t.wheelColor = wheel.color
		t.wheels = wheel.group
		t.modFrontWheels = wheel.type
	end
	
	ESX.Game.SetVehicleProperties(vehicle, t)

	if #extrason > 0 then
		for i=1, #extrason do
			SetVehicleExtra(vehicle, extrason[i], false)
		end
	end
	
	if #extrasoff > 0 then
		for i=1, #extrasoff do
			SetVehicleExtra(vehicle, extrasoff[i], true)
		end
	end
	  
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end
  
function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end
  
function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end
  
function setLastUniform(clothes, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, clothes)
	end)
end
  
function setArmour(value, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin['bproof_1'] ~= 0 and skin['bproof_1'] ~= 10 then
			SetPedArmour(playerPed, value)
		else
			ESX.ShowNotification("~r~Nie masz kamizelki, która ma możliwość zaaplikowania wkładów")
		end
	end)
end
  
function OpenCloakroomMenu()
	ESX.UI.Menu.CloseAll()
	local grade = ESX.PlayerData.job.grade_name
	local hasSertLicense = false

	local elements = {
		{ label = ('Civilian Uniforms'), value = 'citizen_wear' },		
	}
  
	if ESX.PlayerData.job.name == 'police' then
		table.insert(elements, {label = 'Private Uniforms', value = 'player_dressing' })
	elseif ESX.PlayerData.job.name == 'sheriff' then
		table.insert(elements, {label = 'Private Uniforms', value = 'player_dressing' })
		table.insert(elements, {label = "Sheriff Uniforms", value = 'sheriffuniforms'})
		table.insert(elements, {label = "Combat Sheriff Uniforms", value = 'combatsheriff'})
	end

	if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "H.P. Uniforms", value = 'hpuniforms'})
			end
		end, GetPlayerServerId(playerId), 'hp')

		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "D.T.U. Marshal Uniforms", value = 'dtuuniforms'})
			end
		end, GetPlayerServerId(playerId), 'dtu')

		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "T.D. Uniforms", value = 'tduniforms'})
			end
		end, GetPlayerServerId(playerId), 'td')
		
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, {label = "A.I.A.D. Uniforms", value = 'aiaduniforms'})
			end
		end, GetPlayerServerId(playerId), 'aiad')
		
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				hasSertLicense = true
				table.insert(elements, {label = "S.W.A.T. Uniforms", value = 'swatuniforms'})
			end
		end, GetPlayerServerId(playerId), 'swat')

		Wait(100)
	
		table.insert(elements, {label = "Offical Patrol Uniforms", value = 'mundury1'})
		table.insert(elements, {label = "Combat Patrol Uniforms", value = 'mundury2'})
		table.insert(elements, {label = "Event Uniforms", value = 'mundury3'})
		table.insert(elements, {label = "Accessories", value = 'dodatki'})
	end
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)
		
		if data.current.value == 'job_wear' then
			menu.close()
		end

		if data.current.value == 'mundury1' then
			local elements2 = {
				{label = "Cadet Uniform", value = 'recruit_wear'},
				{label = "Probie Trooper Uniform", value = 'officer_wear'},
				{label = "Trooper Uniform", value = 'officer_wear2'},
				{label = "Senior Trooper Uniform", value = 'officer_wear3'},
				{label = "Sergeant Uniform", value = 'sergeant_wear'},
				{label = "Senior Sergeant Uniform", value = 'sergeant_wear2'},
				{label = "Staff Sergeant Uniform", value = 'sergeant_wear3'},
				{label = "Lieutenant Uniform", value = 'lieutenant_wear'},
				{label = "Lieutenant Uniform II", value = 'lieutenant_wear22'},
				{label = "Staff Lieutenant Uniform", value = 'lieutenant_wear2'},
				{label = "Staff Lieutenant Uniform II", value = 'lieutenant_wear222'},
				{label = "Captain Uniform", value = 'captain_wear'},
				{label = "Captain Uniform II", value = 'captain_wear22'},
				{label = "Staff Captain Uniform", value = 'captain_wear2'},
				{label = "Staff Captain Uniform II", value = 'captain_wear222'},
			}
			
			if ESX.PlayerData.job.grade_name == 'boss' then
				table.insert(elements, {label = "I Mundur ACOP/DCOP", value = 'chef_wear'})
				table.insert(elements, {label = "I Mundur COP", value = 'boss_wear'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "S.A.S.P. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	  
		if data.current.value == 'sheriffuniforms' then
			local elements2 = {
				{label= "Cadet Uniform", value= "recruit2_wear"},
				{label = "Probie Deputy Uniform", value = 'probie_wear'},
			}
			
			if (ESX.PlayerData.job.grade >= 0 and ESX.PlayerData.job.grade < 5) or ESX.PlayerData.job.grade >= 10 then
				table.insert(elements2, {label = "Deputy Uniform", value = 'deputy_wear2'})
				table.insert(elements2, {label = "Senior Deputy Uniform", value = 'deputy_wear3'})
			end
			
			if (ESX.PlayerData.job.grade >= 0 and ESX.PlayerData.job.grade < 7) or ESX.PlayerData.job.grade >= 10 then
				table.insert(elements2, {label = "Sergeant Uniform", value = 'sergeantsh_wear'})
				table.insert(elements2, {label = "Senior Sergeant Uniform", value = 'sergeantsh_wear2'})
				table.insert(elements2, {label = "Master Sergeant Uniform", value = 'sergeantsh_wear3'})
			end
			
			if (ESX.PlayerData.job.grade >= 0 and ESX.PlayerData.job.grade < 9) or ESX.PlayerData.job.grade >= 10 then
				table.insert(elements2, {label = "Lieutenant Uniform", value = 'lieutenantsh_wear'})
				table.insert(elements2, {label = "Lieutenant Uniform II", value = 'lieutenantsh_wear22'})
				table.insert(elements2, {label = "Senior Lieutenant Uniform", value = 'lieutenantsh_wear2'})
				table.insert(elements2, {label = "Senior Lieutenant Uniform II", value = 'lieutenantsh_wear222'})
			end
			
			if (ESX.PlayerData.job.grade >= 0 and ESX.PlayerData.job.grade < 11) or ESX.PlayerData.job.grade >= 10 then
				table.insert(elements2, {label = "Captain Uniform", value = 'captainsh_wear'})
				table.insert(elements2, {label = "Captain Uniform II", value = 'captainsh_wear22'})
				table.insert(elements2, {label = "Senior Captain Uniform", value = 'captainsh_wear2'})
				table.insert(elements2, {label = "Senior Captain Uniform II", value = 'captainsh_wear222'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "S.A.S.D. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'hpuniforms' then
			local elements2 = {
				{label = "H.P. Probie Uniform", value = 'probiehp'},
				{label = "H.P. Officer Uniform", value = 'officerhp'},
				{label = "H.P. Sergeant Uniform", value = 'sergeanthp'},
				{label = "H.P. Lieutenant Uniform", value = 'lieutenanthp'},
				{label = "H.P. Captain Uniform", value = 'captainhp'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "H.P. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'dtuuniforms' then
			local elements2 = {
				{label = "D.T.U Interview Uniform", value = 'dtu'},
				{label = "D.T.U Investigation Uniform 1", value = 'dtu1'},
				{label = "D.T.U Investigation Uniform 2", value = 'dtu2'},
				{label = "D.T.U Investigation Uniform 3", value = 'dtu3'},
				{label = "D.T.U Investigation Uniform 4", value = 'dtu4'},
				{label = "D.T.U Combat Uniform 1", value = 'dtu6'},
				{label = "D.T.U Combat Uniform 2", value = 'dtu7'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "D.T.U. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'tduniforms' then
			local elements2 = {
				{label = "T.D. Academy Command Uniform", value = 'tdacademy2_uniform'},
				{label = "T.D. Academy Uniform", value = 'tdacademy_uniform'},
				{label = "T.D. Normal Vest", value = 'tdbullet_wear'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "T.D. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
		
		if data.current.value == 'aiaduniforms' then
			local elements2 = {
				{label = "Probie Inspector", value = 'inspector0'},
				{label = "Inspector I", value = 'inspector1'},
				{label = "Inspector II", value = 'inspector2'},
				{label = "Inspector III", value = 'inspector3'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury5', {
				title    = "A.I.A.D. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'swatuniforms' then
			local elements2 = {
				{label = "S.W.A.T. Pacyfic Humane Alfa Uniform", value = 'swat_david1'},
				{label = "S.W.A.T. Baza Bravo Uniform", value = 'swat_david2'},
				{label = "S.W.A.T. Magazyn Charlie Uniform", value = 'swat_david3'},
				{label = "S.W.A.T. Zbrojownia Delta Uniform", value = 'swat_david4'},
				{label = "S.W.A.T. Normal Heavy Uniform", value = 'swat_wear4'},
				{label = "S.W.A.T. Staff Operator Uniform", value = 'swat_wear3'},
				{label = "S.W.A.T. Senior Operator Uniform", value = 'swat_wear'},
				{label = "S.W.A.T. Heavy Kevlar", value = 'armor_swat'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury7', {
				title    = "S.W.A.T. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value ~= 'armor_swat' then
					setUniform(data2.current.value, playerPed)
				end
				if data2.current.value == 'armor_swat' then
					setArmour(99, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	  
		if data.current.value == 'combatsheriff' then
			local elements2 = {}
			
			if ESX.PlayerData.job.grade >= 4 then
				table.insert(elements2, {label = "Sheriff Combat Uniform Sergeant", value = 'sheriff_patrol'})
			end
			
			if ESX.PlayerData.job.grade >= 7 then
				table.insert(elements2, {label = "Sheriff Combat Uniform Lieutenant", value = 'sheriff_patrol3'})
			end
			
			if ESX.PlayerData.job.grade >= 9 then
				table.insert(elements2, {label = "Sheriff Combat Uniform Capitan", value = 'sheriff_patrol4'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury2', {
				title    = "Combat S.A.S.D. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	  
		if data.current.value == 'mundury2' then
			local elements2 = {
				{label = "Combat Uniform Sergeant", value = 'police_patrol'},
				{label = "Combat Uniform Lieutenant", value = 'police_patrol3'},
				{label = "Combat Uniform Capitan", value = 'police_patrol4'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury2', {
				title    = "Combat S.A.S.P. Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'mundury3' then
  
			local elements2 = {
				{label = "Official Uniform", value = 'oficjalny_wear'},
				{label = "Motorcycle Uniform", value = 'motocykl_wear'},
				{label = "K-9 Uniform", value = 'k9_wear'},
				{label = 'Kevlar', value = 'armour'}
			}

			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
				if hasWeaponLicense then
					table.insert(elements2, {label = "Diver Uniform", value = 'nurek_wear'})
				end
				
				if ESX.PlayerData.job.name == 'sheriff' then
					table.insert(elements2, {label = "Sheriff Official Uniform", value = 'sheriff_official'})
					table.insert(elements2, {label = "Sheriff Motorcycle Uniform", value = 'motocyklsheriff_wear'})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury3', {
					title    = "Event Uniforms",
					align    = 'center',
					elements = elements2
				}, function(data2, menu2)
					if data2.current.value == 'armour' then
						setArmour(75, playerPed)
					else
						setUniform(data2.current.value, playerPed)
					end
				end, function(data2, menu2)
					menu2.close()
				end)		
			end, GetPlayerServerId(playerId), 'nurek')
		end

		if data.current.value == 'dodatki' then
			local elements2 = {
				{label = "Reflective Vest", value = 'gilet_wear'},
				{label = "Heavy Bag", value = 'torba_wear'},
			}
		  
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dodatki', {
				title    = "Addons Uniforms",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Private Uniforms",
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	  
		if data.current.value == 'citizen_wear' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if
			data.current.value == 'recruit_wear' or
			data.current.value == 'recruitszeryf_wear' or
			data.current.value == 'officer_wear' or
			data.current.value == 'officer_wear2' or
			data.current.value == 'officerszeryf_wear' or
			data.current.value == 'sergeant_wear' or
			data.current.value == 'sergeant_wear2' or
			data.current.value == 'sergeantszeryf_wear' or
			data.current.value == 'intendent_wear' or
			data.current.value == 'intendent_wear2' or
			data.current.value == 'intendentszeryf_wear' or
			data.current.value == 'lieutenant_wear' or
			data.current.value == 'lieutenant_wear2' or
			data.current.value == 'lieutenantszeryf_wear' or
			data.current.value == 'captain_wear' or
			data.current.value == 'captain_wear2' or
			data.current.value == 'chef_wear' or
			data.current.value == 'chefszeryf_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bossszeryf_wear' or
			data.current.value == 'sert_wear' or
			data.current.value == 'k9_wear' or
			data.current.value == 'police_patrol2' or
			data.current.value == 'police_patrol3' or
			data.current.value == 'oficjalny_wear' or
			data.current.value == 'motocykl_wear' or
			data.current.value == 'motocyklsheriff_wear' or
			data.current.value == 'nurek_wear' or
			data.current.value == 'sert2_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'bullet2_wear' or
			data.current.value == 'torba_wear' or
			data.current.value == 'gilet_wear' or
			data.current.value == 'gilet2_wear'
		then
			setUniform(data.current.value, playerPed)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end
  
function OpenVehicleSpawnerMenu(partNum)
	local vehicles = Config.PoliceStations.Vehicles
	
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local found = true
	for i, group in ipairs(Config.VehicleGroups) do
		local elements2 = {}
		
		for _, vehicle in ipairs(Config.AuthorizedVehicles) do
			local let = false
			for _, group in ipairs(vehicle.groups) do
				if group == i then
					let = true
					break
				end
			end

			if let then
				if vehicle.grade then
					if vehicle.hidden == true then
						if i ~= 7 then
							if not CanPlayerUseHidden(vehicle.grade) then
								let = false
							end
						else
							if not CanPlayerUseHidden(vehicle.grade) and not CanPlayerUse(vehicle.grade) then
								let = false
							end
						end
					else
						if not CanPlayerUse(vehicle.grade) then
							let = false
						end
					end
				elseif vehicle.grades and #vehicle.grades > 0 then
					let = false
					for _, grade in ipairs(vehicle.grades) do
						if ((vehicle.swat and IsSWAT) or grade == ESX.PlayerData.job.grade) and (not vehicle.label:find('SEU') or IsSEU) then
							let = true
							break
						end
					end
				end

				if let or (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
					table.insert(elements2, { label = vehicle.label, model = vehicle.model, livery = vehicle.livery, extrason = vehicle.extrason, extrasoff = vehicle.extrasoff, offroad = vehicle.offroad, wheelsxd = vehicle.wheelsxd, color = vehicle.color, plate = vehicle.plate, tint = vehicle.tint, bulletproof = vehicle.bulletproof, wheel = vehicle.wheel, tuning = vehicle.tuning })
				end
			end
		end
			
		if (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
			if #elements2 > 0 then
				table.insert(elements, {label = group, value = elements2, group = i})				
			end
		else
			if i == 5 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(playerId), 'seu')
			elseif i == 6 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					found = true
				end, GetPlayerServerId(playerId), 'dtu')
			elseif i == 7 then
				if ESX.PlayerData.job.name == 'sheriff' then
					table.insert(elements, { label = group, value = elements2, group = i })
				end
			elseif i == 8 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					found = true
				end, GetPlayerServerId(playerId), 'hp')
			elseif i == 9 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					found = true
				end, GetPlayerServerId(playerId), 'hp')
			elseif i == 10 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(playerId), 'aiad')
			elseif i == 11 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(playerId), 'swat')
			else
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		end
	end
	
	while not found do
		Wait(100)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
	  title    = _U('vehicle_menu'),
	  align    = 'center',
	  elements = elements
	}, function(data, menu)
		menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner_' .. data.current.group, {
				title    = data.current.label,
				align    = 'center',
				elements = data.current.value
			}, function(data2, menu2)
				local livery = data2.current.livery
				local extrason = data2.current.extrason
				local extrasoff = data2.current.extrasoff
				local offroad = data2.current.offroad
				local wheelsxd = data2.current.wheelsxd
				local color = data2.current.color
				local bulletproof = data2.current.bulletproof or false
				local tint = data2.current.tint
				local wheel = data2.current.wheel
				local tuning = data2.current.tuning

				local setPlate = true
				if data2.current.plate ~= nil and not data2.current.plate then
					setPlate = false
				end

				local vehicle = GetClosestVehicle(vehicles[partNum].spawnPoint.x,  vehicles[partNum].spawnPoint.y,  vehicles[partNum].spawnPoint.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) then
					if Config.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data2.current.model, {
							x = vehicles[partNum].spawnPoint.x,
							y = vehicles[partNum].spawnPoint.y,
							z = vehicles[partNum].spawnPoint.z
						}, vehicles[partNum].heading, function(vehicle)
							SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)
							if setPlate then
								local plate = ""
								if data.current.label == 'UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif data.current.label == 'HP UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif ESX.PlayerData.job.name == 'sheriff' then
									plate = "SASD " .. math.random(100,999)
								elseif ESX.PlayerData.job.name == 'hwp' then
									plate = "SAHP " .. math.random(100,999)
								else
									plate = "SASP " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(vehicle, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
								TriggerServerEvent("exilerp_temp:setPolicePlate", localVehPlate)
								TriggerServerEvent('exile_logs:triggerLog', "Wyjął pojazd policyjny " .. vehicle .. " o rejestracji: " .. localVehPlate, 'policecars', '3066993')
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
								TriggerServerEvent("exilerp_temp:setPolicePlate", localVehPlate)
								TriggerServerEvent('exile_logs:triggerLog', "Wyjął pojazd policyjny " .. vehicle .. " o rejestracji: " .. localVehPlate, 'policecars', '3066993')
							end

							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)
					else
						ESX.Game.SpawnVehicle(data2.current.model, {
							x = vehicles[partNum].spawnPoint.x,
							y = vehicles[partNum].spawnPoint.y,
							z = vehicles[partNum].spawnPoint.z
						}, vehicles[partNum].heading, function(vehicle)
							SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)
							if setPlate then
								local plate = ""
								
								if data.current.label == 'UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif ESX.PlayerData.job.name == 'sheriff' then
									plate = "SASD " .. math.random(100,999)
								else
									plate = "SASP " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(vehicle, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
								TriggerServerEvent("exilerp_temp:setPolicePlate", localVehPlate)
								TriggerServerEvent('exile_logs:triggerLog', "Wyjął pojazd policyjny " .. vehicle .. " o rejestracji: " .. localVehPlate, 'policecars', '3066993')
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
								TriggerServerEvent("exilerp_temp:setPolicePlate", localVehPlate)
								TriggerServerEvent('exile_logs:triggerLog', "Wyjął pojazd policyjny " .. vehicle .. " o rejestracji: " .. localVehPlate, 'policecars', '3066993')
							end

							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)
					end
				else
					ESX.ShowNotification('Pojazd znaduje się w miejscu wyciągnięcia następnego')
				end
			end, function(data2, menu2)
				menu.close()
				OpenVehicleSpawnerMenu(partNum)
			end)
		else
			ESX.ShowNotification("~r~Brak pojazdów w tej kategorii")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end)
end
  
  
function OpenLodzieSpawnerMenu(partNum)
	local lodzie = Config.PoliceStations.Lodzie
	ESX.UI.Menu.CloseAll()
	
	local elements = {}
	for i, group in ipairs(Config.LodzieGroups) do
		if (i ~= 10 and i ~= 6) or (i == 10 and IsSheriff) or (i == 6 and IsSEU) then
			local elements2 = {}
			for _, lodz in ipairs(Config.AuthorizedLodzie) do
				local let = false
				for _, group in ipairs(lodz.groups) do
					if group == i then
						let = true
						break
					end
				end

				if let then
					if lodz.grade then
						if not CanPlayerUse(lodz.grade) or (lodz.label:find('SEU') and not IsSEU) then
							let = false
						end
					elseif lodz.grades and #lodz.grades > 0 then
						let = false
						for _, grade in ipairs(lodz.grades) do
							if ((lodz.swat and IsSWAT) or grade == ESX.PlayerData.job.grade) and (not lodz.label:find('SEU') or IsSEU) then
								let = true
								break
							end
						end
					end

					if let or (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
						table.insert(elements2, { label = lodz.label, model = lodz.model, livery = lodz.livery, offroad = lodz.offroad, wheelsxd = lodz.wheelsxd, color = lodz.color, extrason = lodz.extrason, extrasoff = lodz.extrasoff, plate = lodz.plate, tint = lodz.tint, bulletproof = lodz.bulletproof, wheel = lodz.wheel, tuning = lodz.tuning })
					end
				end
			end

			if #elements2 > 0 then
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lodzie_spawner', {
		title    = _U('lodzie_menu'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lodzie_spawner_' .. data.current.group, {
				title    = data.current.label,
				align    = 'center',
				elements = data.current.value
			}, function(data2, menu2)
					local livery = data2.current.livery
					local offroad = data2.current.offroad
					local wheelsxd = data2.current.wheelsxd
					local color = data2.current.color
					local extrason = data2.current.extrason
					local extrasoff = data2.current.extrasoff
					local bulletproof = data2.current.bulletproof or false
					local tint = data2.current.tint
					local wheel = data2.current.wheel
					local tuning = data2.current.tuning

					local setPlate = true
					if data2.current.plate ~= nil and not data2.current.plate then
						setPlate = false
					end

					local lodz = GetClosestVehicle(lodzie[partNum].spawnPoint.x,  lodzie[partNum].spawnPoint.y,  lodzie[partNum].spawnPoint.z, 3.0, 0, 71)
					if not DoesEntityExist(lodz) then

						ESX.Game.SpawnVehicle(data2.current.model, {
							x = lodzie[partNum].spawnPoint.x,
							y = lodzie[partNum].spawnPoint.y,
							z = lodzie[partNum].spawnPoint.z
						}, lodzie[partNum].heading, function(lodz)
							SetVehicleMaxMods(lodz, livery, offroad, wheelsxd, color, extrason, extrasoff, bulletproof, tint, wheel, tuning)
							if setPlate then
								if data.current.label == 'UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif ESX.PlayerData.job.name == 'sheriff' then
									plate = "SASD " .. math.random(100,999)
								else
									plate = "SASP " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(lodz, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(lodz))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
								TriggerServerEvent("exilerp_temp:setPolicePlate", localVehPlate)
								TriggerServerEvent('exile_logs:triggerLog', "Wyjął pojazd policyjny " .. lodz .. " o rejestracji: " .. localVehPlate, 'policecars', '3066993')
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(lodz))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
								TriggerServerEvent("exilerp_temp:setPolicePlate", localVehPlate)
								TriggerServerEvent('exile_logs:triggerLog', "Wyjął pojazd policyjny " .. lodz .. " o rejestracji: " .. localVehPlate, 'policecars', '3066993')
							end

							TaskWarpPedIntoVehicle(playerPed,  lodz,  -1)
						end)
					else
						ESX.ShowNotification('Pojazd znaduje się w miejscu wyciągnięcia następnego')
					end
			end, function(data2, menu2)
				menu.close()
				OpenLodzieSpawnerMenu(partNum)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_lodzie_spawner'
		CurrentActionMsg  = _U('lodzie_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end)
end

function LokalnyOutOfCar(ped) 
	if IsPedSittingInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped, false)
		TaskLeaveVehicle(ped, vehicle, 16)
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Wait(0)
		end

		TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
		CreateThread(function() 
			Wait(300)
			ClearPedTasks(ped)
			FreezeEntityPosition(ped, true)
		end)
	end
end

function PutLokalnyInCar(ped) 
	local vehicle = nil
	if IsPedInAnyVehicle(ped, false) then
		vehicle = GetVehiclePedIsIn(ped, false)
	else
		vehicle = ESX.Game.GetVehicleInDirection()
		if not vehicle then
			local coords = GetEntityCoords(ped, false)
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end
		end
	end

	if vehicle and vehicle ~= 0 then
		local maxSeats =  GetVehicleMaxNumberOfPassengers(vehicle)
		if maxSeats >= 0 then
			local freeSeat
			for i = (maxSeats - 1), 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then		
				-- ClearPedTasksImmediately(ped)			
				local tick = 20
				repeat
					TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
					tick = tick - 1
					Wait(50)
				until IsPedInAnyVehicle(ped, false) or tick == 0
			end
		end
	end
end

function CuffLokalny(ped) 
	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Wait(0)
	end

	if not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Cuff", 0.5)
		TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
		SetEnableHandcuffs(ped, true)
		TaskSetBlockingOfNonTemporaryEvents(ped, true)
		TaskStandStill(ped, 500 * 1000)
		CreateThread(function() 
			while IsPedCuffed(ped) do
				if not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
					TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
				end
				Wait(200)
			end
		end)
	else
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Uncuff", 0.5)
		UnCuffLokalny(ped)
	end
end
function UnCuffLokalny(ped) 
	SetEnableHandcuffs(ped, false)
	Wait(100)
	-- ClearPedTasksImmediately(ped)
	FreezeEntityPosition(ped, false)
	DetachEntity(ped, true, false)
	TaskSetBlockingOfNonTemporaryEvents(ped, false)
	TaskReactAndFleePed(ped, playerPed)
	Dragging = nil
	DraggingLokal = false
end

local DraggingLokal = false

function DragLokalny(ped) 
	if DraggingLokal and DoesEntityExist(DraggingLokal) then
		ESX.ShowNotification("~r~Puszczono lokalnego")
		DetachEntity(DraggingLokal, true, false)
		FreezeEntityPosition(ped, false)
		TaskSetBlockingOfNonTemporaryEvents(DraggingLokal, true)
		TaskStandStill(DraggingLokal, 500 * 1000)
		Dragging = nil
		DraggingLokal = false
		return
	end
	if not Dragging then
		DraggingLokal = ped
		Dragging = ped
		FreezeEntityPosition(ped, true)
		AttachEntityToEntity(ped, playerPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		ESX.ShowNotification("~r~Chwycono lokalnego")
		TaskSetBlockingOfNonTemporaryEvents(ped, true)
		TaskStandStill(ped, 500 * 1000)
		CreateThread(function() 
			while DoesEntityExist(ped) do
				Wait(1000)
				if IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) or DraggingLokal then
					TaskSetBlockingOfNonTemporaryEvents(ped, true)
					TaskStandStill(ped, 500 * 1000)
				end
			end
			Dragging = nil
			DraggingLokal = false
			DetachEntity(ped, true, false)
			FreezeEntityPosition(ped, true)
		end)
	end
end


function HandcuffMenu()
	ESX.UI.Menu.CloseAll()
	  
	local elements = {}
	if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
		table.insert(elements, {label = "Zakuj/Rozkuj",      value = 'handcuff'})
		table.insert(elements, {label = "Zakuj/Rozkuj agresywnie", value = 'agresivehandcuff'})			
	else
		table.insert(elements, {label = "Zakuj/Rozkuj",      value = 'handcuff'})
	end
	
	table.insert(elements, {label = "Przenieś",      value = 'drag'})
	table.insert(elements, {label = "Przeszukaj",    value = 'body_search'})
	table.insert(elements, {label = "Ściągnij/Załóż ubrania",	value = 'clothes'})
	table.insert(elements, {label = "Włóż do pojazdu",  value = 'put_in_vehicle'})
	table.insert(elements, {label = "Wyciągnij z pojazdu", value = 'out_the_vehicle'})
	table.insert(elements, {label = "Włóż do bagażnika",	value = 'bagol1'})
	table.insert(elements, {label = "Wyciągnij z bagażnika",	value = 'bagol2'})
	table.insert(elements, {label = "Zabierz i ubierz ubranie",	value = 'przebieranko'})
	
	if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
		table.insert(elements, {label = _U('licencja'), value = 'license1'})
		table.insert(elements, {label = _U('GSR-test'), value = 'gsr'})
		table.insert(elements, {label = _U('license_check'), value = 'license' })
		table.insert(elements, {label = "Sprawdź dokumenty",      value = 'identity_card'})
		table.insert(elements, {label = "Wyszukaj w tablecie",      value = 'open_tablet'})
	end

	if ESX.PlayerData.job.name == 'ambulance' then
		table.insert(elements, {label = "Sprawdź dokumenty",      value = 'identity_card'})
	end
	
	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = "Kajdanki",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		local closestPed, closestDistancee = ESX.Game.GetClosestPed()
		if exports['StinkyRP']:isAntytroll() then
			ESX.ShowNotification("~r~Jesteś w trakcie antytrolla!")
			return
		end
		if (closestPlayer ~= -1 and closestDistance <= 3.0) or (closestPed ~= -1 and closestDistancee <= 3.0) then
			local action = data.current.value
			local targetPed = nil
			local isPlayer = false
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				targetPed = GetPlayerPed(closestPlayer)
				isPlayer = true
			elseif closestPed ~= -1 and closestDistancee <= 3.0 then
				targetPed = closestPed
			else
				return
			end
			local hasAnim1 = IsEntityPlayingAnim(targetPed, "missminuteman_1ig_2", "handsup_enter", 3)
			local hasAnim2 = IsEntityPlayingAnim(targetPed, "random@arrests@busted", "enter", 3)
			local hasAnimrece = IsEntityPlayingAnim(targetPed, "random@mugging3", "handsup_standing_base", 3)

			if action == 'handcuff' then
				if not exports['esx_property']:isProperty() then
					if not IsPedCuffed(targetPed) then
						if not CanCuff(targetPed) then
							ESX.ShowNotification("~r~Osoba którą próbujesz zakuć/odkuć nie ma rąk w górze")
							return
						end
					end	
					ClearPedTasks(targetPed)
					animacjazakuciarozkuciaxd()
					Wait(650)
					if isPlayer then
						TriggerServerEvent('esx_policejob:handcuffhype', GetPlayerServerId(closestPlayer))
						ESX.ShowNotification('~o~Zakułeś/Odkułeś ~g~[' .. GetPlayerServerId(closestPlayer) ..']')
					end
					if not isPlayer then
						CuffLokalny(targetPed)
						ESX.ShowNotification('~o~Zakuto/rozkuto lokalnego')
					end	
				end
			elseif action == 'open_tablet' then
				TriggerEvent("exilerpMdc:openCitizen", GetPlayerServerId(closestPlayer))
			elseif action == 'agresivehandcuff' then
				
				if not IsPedCuffed(targetPed) then
					local target, distance = ESX.Game.GetClosestPlayer()
					
					local playerheading = GetEntityHeading(playerPed)
					local playerlocation = GetEntityForwardVector(playerPed)
					
					local target_id = GetPlayerServerId(target)
					if distance <= 2.0 then
						TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, coords, playerlocation)
						ESX.ShowNotification('~o~Zakułeś ~g~[' .. GetPlayerServerId(closestPlayer) ..']')
					else
						ESX.ShowNotification("~r~Brak osób w pobliżu")
					end				
				else
					local target, distance = ESX.Game.GetClosestPlayer()
					
					local playerheading = GetEntityHeading(playerPed)
					local playerlocation = GetEntityForwardVector(playerPed)					
					local target_id = GetPlayerServerId(target)
					if distance <= 2.0 then
						animacjazakuciarozkuciaxd()
						TriggerServerEvent('esx_policejob:handcuffhype', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification("~r~Brak osób w pobliżu")
					end				
				end	
			elseif action == 'identity_card' then
				OpenIdentityCardMenu(closestPlayer)
			elseif action == 'body_search' then
				if IsPedCuffed(targetPed) then
					if IsPedCuffed(targetPed) or hasAnim1 or hasAnim2 and not IsPlayerDead(closestPlayer) then
						if isPlayer then
							TriggerServerEvent('exile_logs:triggerLog', "Przeszukiwanie gracza " .. GetPlayerServerId(closestPlayer), 'handcuffs', '3066993')
							OpenBodySearchMenu(closestPlayer)
						else
							ESX.ShowNotification('~r~Nie możesz przeszukać lokalnego!')
						end	
					end
				end
			elseif action == 'drag' then
					if IsPedCuffed(targetPed) then
						if isPlayer then
							TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
						else
							DragLokalny(targetPed)
						end
					end
			elseif action == 'put_in_vehicle' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						if Dragging then
							TriggerServerEvent('esx_policejob:drag', Dragging)
						end
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					else
						if DraggingLokal then
						DragLokalny(targetPed)
						end	
						PutLokalnyInCar(targetPed)
					end	
				end
			elseif action == 'przebieranko' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						local SelectedPlayer = closestPlayer
						przebieranko(SelectedPlayer)
					else
						ESX.ShowNotification('~r~Nie możesz przebrać się za lokalnego')
					end
				end
			elseif action == 'out_the_vehicle' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					else
						LokalnyOutOfCar(targetPed)
					end	
				end
			elseif action == 'bagol1' then
				if IsPedCuffed(targetPed) then
					if isPlayer then 
						if Dragging then
							TriggerServerEvent('esx_policejob:drag', Dragging)
						end			
						TriggerServerEvent('exile:putTargetInTrunk', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Nie możesz wsadzić lokalnego do bagażnika')
					end
				end
			elseif action == 'bagol2' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						TriggerServerEvent('exile:outTargetFromTrunk', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Nie możesz wyciągnąć lokalnego z bagażnika')
					end	
				end
			elseif action == 'clothes' then
			
				if IsPedCuffed(targetPed) then
					if not isPlayer then 
						ESX.ShowNotification('~r~Nie możesz rozebrać lokalnego')
					else
						menu.close()
					
						local elements2 = {
							{label = 'Maska', value = 'mask'},
							{label = 'Czapka / Hełm', value = 'hat'},
							{label = 'Okulary', value = 'glasses'},
							{label = 'Łańcuch / Krawat / Plakietka', value = 'chain'},
							{label = 'Lewa ręka / Zegarek', value = 'zegarek'},
							{label = 'Prawa ręka', value = 'branzoleta'},
							{label = 'Tułów', value = 'coat'},
							{label = 'Nogi', value = 'legs'},
							{label = 'Stopy', value = 'shoes'},
							{label = 'Torba / Plecak', value = 'bag'},
							{label = 'Kamizelka', value = 'kamizelka'},
						}

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_clothes', {
							title    = 'Kajdanki - Ubrania',
							align    = 'center',
							elements = elements2
						}, function(data2, menu2)
							if data2.current.value ~= nil then
								TriggerServerEvent('esx_ciuchy:takeoff', data2.current.value, GetPlayerServerId(closestPlayer))
							end
						end, function(data2, menu2)
							menu2.close()
							menu.open()
						end)
					end
				end
			elseif action == 'license' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						ShowPlayerLicense(closestPlayer)
					else
						ESX.ShowNotification('~r~Nie możesz zobaczyć licencji lokalnego')
					end	
				end
			elseif action == 'license1' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						TriggerServerEvent('esx_policejob:addlicenseforplayer', GetPlayerServerId(closestPlayer))
						ESX.ShowNotification(_U('nadano_licka'))
					else
						ESX.ShowNotification('~r~Nie możesz nadać licencji na broń lokalnemu')
					end
				end
			elseif action == 'gsr' then
				if isPlayer then
					if DecorExistOn(GetPlayerPed(closestPlayer), 'Gunpowder') then
						ESX.ShowNotification("~r~Wykryto proch na dłoniach!")
					else
						ESX.ShowNotification("~g~Nie wykryto prochu na dłoniach.")
					end
				else
					ESX.ShowNotification('~r~Nie możesz sprawdzić prochu lokalnemu')
				end
			end
		else
			local action = data.current.value
			if action == "body_search" then
				BodySearchOffline()
			else	
				ESX.ShowNotification(_U('no_players_nearby'))
			end
			ESX.ShowNotification(_U('no_players_nearby'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
  
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
	
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
	
		if Config.EnableESXIdentity then
	
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
	
			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end
	
			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end
	
			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end
	
			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
	
		end
	
		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}
	
		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end
	
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end
	
		if data.licenses ~= nil then
	
			table.insert(elements, {label = _U('license_label'), value = nil})
	
			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end
	
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align    = 'center',
			elements = elements,
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	
	end, GetPlayerServerId(player))

end

function przebieranko(target)
	local id = GetPlayerServerId(target)
	ESX.TriggerServerCallback("skinchanger:getSkin", function(cb) 
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadClothes', skin, cb)
		end)
	end, id)
end

function CanPlayerUseHidden(grade)
	return not grade or ESX.PlayerData.job.grade >= grade
end

function CanPlayerUse(grade)
	return not grade or ESX.PlayerData.job.grade >= grade
end
  
RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)	
	IsHandcuffed    = not IsHandcuffed
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(playerPed, x, y, z)
	SetEntityHeading(playerPed, playerheading)
	Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Wait(3760)
	TriggerEvent('esx_policejob:handcuff')
	loadanimdict('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	
	CreateThread(function()
		if IsHandcuffed then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if not exports['stinky_trunk']:checkInTrunk() then
				RequestAnimDict('mp_arresting')
				while not HasAnimDictLoaded('mp_arresting') do
					Wait(0)
				end

				if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
				end
			end
			
			ESX.UI.Menu.CloseAll()
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			DisablePlayerFiring(playerPed, true)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Cuff", 0.5)	
			StartHandcuffTimer()
		else
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Uncuff", 0.5)
				ClearPedTasksImmediately(playerPed)
			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			if exports['stinky_trunk']:checkInTrunk() then
				TaskPlayAnim(playerPed, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
		end
	end)
end)


RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function()
	Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Wait(3000)
end) 

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	ClearPedTasks(playerPed)
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(playerPed, x, y, z)
	SetEntityHeading(playerPed, playerheading)
	Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	IsHandcuffed = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(playerPed)
end)

function OpenPoliceActionsMenu()
	if not exports['esx_ambulancejob']:isDead() and not IsHandcuffed then
		ESX.UI.Menu.CloseAll()	
		local elements = {
			{label = "Interakcje z obywatelem",	value = 'citizen_interaction'},
			{label = "Interakcje z pojazdem", value = 'vehicle_interaction'},
		}
		
		if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			table.insert(elements, {label = "Interakcje z obiektami", value = 'object_spawner'})
			table.insert(elements, {label = 'Załóż/zdejmij worek na głowe', value = 'worek'})
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
			title    = 'San Andreas State Police',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'worek' then
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
				{
					title    = 'San Andreas State Police',
					align    = 'center',
					elements = {
						{label = "Załóż", value = 'puton'},
						{label = "Zdejmij", value = 'putoff'},
					}
				}, function(data2, menu2)
					if data2.current.value == 'puton' then
						ESX.TriggerServerCallback('org:getItemAmount', function(qtty)
							if qtty > 0 then
								local player, distance = ESX.Game.GetClosestPlayer()
								local idkurwy = GetPlayerServerId(GetPlayerIndex())
								if distance ~= -1 and distance <= 1.0 then
									if not IsPedSprinting(playerPed) and not IsPedRagdoll(playerPed) and not IsPedRunning(playerPed) then
										TriggerServerEvent('exile_baghead:setbagon', GetPlayerServerId(player), idkurwy, 'puton')
									end
								else
									ESX.ShowNotification('Brak graczy w pobliżu.')
								end
							else
								ESX.ShowNotification('~r~Nie posiadasz przy sobie worka!')
							end
						end, 'worek')
					elseif data2.current.value == 'putoff' then
						local player, distance = ESX.Game.GetClosestPlayer()
						local idkurwy = GetPlayerServerId(GetPlayerIndex())
						if distance ~= -1 and distance <= 1.0 then
							if not IsPedSprinting(playerPed) and not IsPedRagdoll(playerPed) and not IsPedRunning(playerPed) then
								TriggerServerEvent('exileHeadbag:setbagon', GetPlayerServerId(player), idkurwy, 'putoff')
							end
						else
							ESX.ShowNotification('Brak graczy w pobliżu.')
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'citizen_interaction' then
				HandcuffMenu()
			elseif data.current.value == 'vehicle_interaction' then
				local elements2  = {}
		
				if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					if not inVehicle then
						table.insert(elements2, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
						table.insert(elements2, {label = "Napraw pojazd", value = 'fix_vehicle'})
					
						if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
							table.insert(elements2, {label = "Odholuj pojazd",			value = 'impound'})
							table.insert(elements2, {label = "Zajmij pojazd na parking policyjny",		value = 'impoundpd'})	
							table.insert(elements2, {label = "Wyszukaj w tablecie",		value = 'open_tablet'})					
						end
					end
				else
					ESX.ShowNotification("~r~Brak pojazdów wokół ciebie")
					return
				end
			
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
					title    = 'Interakcje z pojazdem',
					align    = 'center',
					elements = elements2
				}, function(data2, menu2)
					local action    = data2.current.value
					if action == 'search_database' or IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
						local vehicle = ESX.Game.GetVehicleInDirection()
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Nie możesz zrobić tego w aucie!')
							return
						end
						if DoesEntityExist(vehicle) then
							if action == 'hijack_vehicle' then
								if(not IsPedInAnyVehicle(playerPed)) then
									if not exports["stinky_taskbar"]:isBusy() then
										TriggerServerEvent('exile:pay', 1500)
									end
									menu.close()
									TriggerEvent('esx_mechanikjob:onHijack')
								end
							elseif action == 'open_tablet' then
								TriggerEvent("exilerpMdc:openVehicle", GetVehicleNumberPlateText(vehicle))
								menu.close()
							elseif action == 'fix_vehicle' then
								if(not IsPedInAnyVehicle(playerPed)) then
									TriggerEvent('esx_mechanikjob:onFixkitFree')
									if not exports["stinky_taskbar"]:isBusy() then
										TriggerServerEvent('exile:pay', 500)
									end
								end
							elseif action == 'impound' then
								if not exports["esx_lscustom"]:OnTuneCheck() then
									if CurrentTask.Busy then
										return
									end

									SetTextComponentFormat('STRING')
									AddTextComponentString('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie~s~')
									DisplayHelpTextFromStringLabel(0, 0, 1, -1)
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									CurrentTask.Busy = true
									CurrentTask.Task = ESX.SetTimeout(10000, function()
										ClearPedTasks(playerPed)
										TriggerEvent("esx_impound", 'cos')
										CurrentTask.Busy = false
										Wait(100)
									end)

									CreateThread(function()
										while CurrentTask.Busy do
											Wait(1000)
											vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
											if not DoesEntityExist(vehicle) and CurrentTask.Busy then
												ESX.ShowNotification('~r~Zajęcie zostało anulowane, ponieważ pojazd przemieścił się')
												ESX.ClearTimeout(CurrentTask.Task)

												ClearPedTasks(playerPed)
												CurrentTask.Busy = false
												break
											end
										end
									end)
								end
							elseif action == 'impoundpd' then
								ESX.UI.Menu.CloseAll()
								if CurrentTask.Busy then
									return
								end
								SetTextComponentFormat('STRING')
								AddTextComponentString('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie na parking policyjny~s~')
								DisplayHelpTextFromStringLabel(0, 0, 1, -1)
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
								CurrentTask.Busy = true
								CurrentTask.Task = ESX.SetTimeout(10000, function()
									ClearPedTasks(playerPed)
									TriggerEvent("esx_impound", 'cos', 'cos')
									ESX.ShowNotification('~o~Włożono pojazd na parking policyjny!')
									CurrentTask.Busy = false
									Citizen.Wait(100)
								end)
	
								CreateThread(function()
									while CurrentTask.Busy do
										Citizen.Wait(1000)
	
										vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
										if not DoesEntityExist(vehicle) and CurrentTask.Busy then
											ESX.ShowNotification('~r~Zajęcie zostało anulowane, ponieważ pojazd przemieścił się')
											ESX.ClearTimeout(CurrentTask.Task)
	
											ClearPedTasks(playerPed)
											CurrentTask.Busy = false
											break
										end
									end
								end)
							end
						end
					end
			end, function(data2, menu2)
				menu2.close()
			end)
			elseif data.current.value == 'object_spawner' then
				if not IsPedSittingInAnyVehicle(playerPed) then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
						title    = _U('traffic_interaction'),
						align    = 'center',
						elements = {
							{label = _U('barrier'),		value = 'prop_barrier_work05'},
							{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
						}
					}, function(data2, menu2)
						local forward =  GetEntityForwardVector(playerPed)
						local objectCoords = (coords + forward * 1.0)
						local timer = 5	
						if data2.current.value == 'prop_barrier_work05' then
							ESX.Game.SpawnObject(data2.current.value, objectCoords, function(obj)					
								SetEntityHeading(obj, tonumber(GetEntityHeading(playerPed)))
								PlaceObjectOnGroundProperly(obj)
								FreezeEntityPosition(obj, true)
								SetEntityCollision(obj, true)
								Wait(60000 * 5)
								DeleteObject(obj)
							end)
						end
						if data2.current.value == 'p_ld_stinger_s' then
							ClearPedTasksImmediately(playerPed)
							ESX.Game.SpawnObject(data2.current.value, objectCoords, function(obj)					
								SetEntityHeading(obj, tonumber(GetEntityHeading(playerPed)))
								PlaceObjectOnGroundProperly(obj)
								Wait(60000 * 5)
								DeleteObject(obj)
							end)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification("~r~Nie możesz używać tego w pojeździe!")
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

CreateThread(function()
	local object
	while true do
		Wait(200)
		local pass = false
		if not object or object == 0 then
			pass = true
		elseif not DoesEntityExist(object) or #(coords - GetEntityCoords(object)) > 50.0 then
			pass = true
		end

		if pass then
			object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 50.0, `p_ld_stinger_s`, false, false, false)
		end

		if object and object ~= 0 then
			for _, vehicle in ipairs(ESX.Game.GetVehicles()) do
				local position = GetEntityCoords(vehicle)
				if #(position - coords) <= 30.0 then
					local closest = GetClosestObjectOfType(position.x, position.y, position.z, 1.5, `p_ld_stinger_s`, false, false, false)
					if closest and closest ~= 0 then
						for i = 0, 7 do
							if not IsVehicleTyreBurst(vehicle, i, true) then
								SetVehicleTyreBurst(vehicle, i, true, 1000)
							end
						end
					end
				end
			end
		end
	end
end)

function OpenBodySearchMenu(target)
	local serverId = GetPlayerServerId(target)
	
	ESX.TriggerServerCallback('esx_policejob:checkSearch', function(status)
		if status then
			ESX.ShowNotification("~r~Ta osoba jest już przeszukiwana przez kogoś!") 
		else 
			TaskPlayAnim(PlayerPed, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
			ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
				local elements = {}
				
				for i=1, #data.accounts, 1 do
					if data.accounts[i].money > 0 then
						if data.accounts[i].name == 'black_money' then
							table.insert(elements, {
								label    = data.accounts[i].money .. '$ [nieopodatkowana gotówka]',
								value    = 'black_money',
								type     = 'item_account',
								amount   = data.accounts[i].money
							})
							break
						end
					end
				end

				for i=1, #data.inventory, 1 do
					if data.inventory[i].count > 0 then
						if data.inventory[i].label ~= nil then
							table.insert(elements, {
								label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
								value    = data.inventory[i].name,
								type     = 'item_standard',
								amount   = data.inventory[i].count
							})
						end
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
					title    = _U('search'),
					align    = 'right',
					elements = elements
				}, function(data, menu)
					local itemType = data.current.type
					local itemName = data.current.value
					local amount   = data.current.amount
					local playerCoords = GetEntityCoords(playerPed)
					local targetCoords = GetEntityCoords(GetPlayerPed(target))
		
					if data.current.value ~= nil then
						ESX.TriggerServerCallback('esx_policejob:checkSearch2', function(cb)
							if cb == true then
								ClearPedTasksImmediately(playerPed)
								ESX.UI.Menu.CloseAll()
								if #(playerCoords - targetCoords) <= 3.0 then
									TriggerServerEvent('esx_policejob:confiscatePlayerItem', serverId, itemType, itemName, amount)
									OpenBodySearchMenu(target)
								end
							else
							end
						end, serverId)
					end
				end, function(data, menu)
					ClearPedTasksImmediately(playerPed)
					menu.close()
				end, nil, function()
					ClearPedTasksImmediately(playerPed)
					TriggerServerEvent('esx_policejob:cancelSearch', serverId)
				end)
			end, serverId)
		end
	end, serverId)
end

local CombatLogi = {}

RegisterNetEvent("exilerp_scripts:offlineLoot", function(license, coords) 
	if #(GetEntityCoords(playerPed) - vector3(coords.x, coords.y, coords.z)) < 85.0 then 
		table.insert(CombatLogi, {a=license, b=coords})
		CreateThread(function() 
			Wait(25000)
			for i,v in ipairs(CombatLogi) do
				if v.a == license then
					ESX.UI.Menu.CloseAll()
					table.remove(CombatLogi, i)
				end	
			end	
		end)
	end
end)

function BodySearchOffline() 
	local c = nil
	local d = nil
	for i,v in ipairs(CombatLogi) do
		if #(GetEntityCoords(playerPed) - vector3(v.b.x, v.b.y, v.b.z)) < 5.0 then
			c = v.a
			d = vector3(v.b.x, v.b.y, v.b.z)
			break
		end	
	end	
	if c == nil then return end
	local serverId = c
	ESX.TriggerServerCallback('esx_policejob:checkSearch1', function(status)
		if status then
			ESX.ShowNotification("~r~Ta osoba jest już przeszukiwana przez kogoś!") 
		else
			ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData1', function(data)
				if not data then return end
				local elements = {}			
				
				for i=1, #data.accounts, 1 do
					if data.accounts[i].money > 0 then
						if data.accounts[i].name == 'black_money' then
							table.insert(elements, {
								label    = data.accounts[i].money .. '$ [nieopodatkowana gotówka]',
								value    = 'black_money',
								type     = 'item_account',
								amount   = data.accounts[i].money
							})
							break
						end
					end
				end

				for i=1, #data.inventory, 1 do
					if data.inventory[i].count > 0 then
						if data.inventory[i].label ~= nil then
							table.insert(elements, {
								label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
								value    = data.inventory[i].name,
								type     = 'item_standard',
								amount   = data.inventory[i].count
							})
						end
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
					title    = _U('search'),
					align    = 'right',
					elements = elements
				}, function(data, menu)
					local itemType = data.current.type
					local itemName = data.current.value
					local amount   = data.current.amount
					local playerCoords = GetEntityCoords(playerPed)
					local targetCoords = d
		
					if data.current.value ~= nil then
						ESX.TriggerServerCallback('esx_policejob:checkSearch3', function(cb)
							if cb == true then
								ESX.UI.Menu.CloseAll()
								if #(playerCoords - targetCoords) <= 10.0 then
									TriggerServerEvent('esx_policejob:confiscatePlayerItem1', serverId, itemType, itemName, amount)
									BodySearchOffline()
								end
							else
							end
						end, serverId)
					end
				end, function(data, menu)
					menu.close()
				end, nil, function()
					TriggerServerEvent('esx_policejob:cancelSearch1', serverId)
				end)
			end, serverId)
		end
	end, serverId)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end
	  
		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end
	  
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'center',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
		  
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end
  
AddEventHandler('esx_policejob:hasEnteredMarker', function(station, partNum)
	if station == 'Cloakrooms' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif station == 'Pharmacy' then
		CurrentAction		= 'menu_pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}	
	elseif station == 'SWATArmory' then
		CurrentAction = 'menu_swat_armory'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię SWAT"
		CurrentActionData = {}
	elseif station == 'HCArmory' then
		CurrentAction = 'menu_hc_armory'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię High Command"
		CurrentActionData = {}
	elseif station == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {partNum = partNum}
	elseif station == 'Lodzie' then
		CurrentAction     = 'menu_lodzie_spawner'
		CurrentActionMsg  = _U('lodzie_spawner')
		CurrentActionData = {partNum = partNum}
	elseif station == 'Helicopters' then
		CurrentAction = 'menu_helicopter_spawner'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć helikopter"
		CurrentActionData = {partNum = partNum}
	elseif station == 'VehicleDodatki' then
		CurrentAction = 'menu_dodatki'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu dodatków do pojazdu"
		CurrentActionData = {}
	elseif station == 'VehicleFixing' then
		CurrentAction = 'menu_fixing'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby naprawić swój pojazd"
		CurrentActionData = {}
	elseif station == 'VehicleDeleters' then
		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	elseif station == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif station == 'SkinMenu' then
		CurrentAction = 'menu_skin'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~ aby się przebrać"
		CurrentActionData = {}
	elseif station == 'ChangeJob' then
		CurrentAction = 'change_job'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~ pobrać drugą odznakę"
		CurrentActionData = {}
	end
end)
  
AddEventHandler('esx_policejob:hasExitedMarker', function(station, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_policejob:handcuffhype')
AddEventHandler('esx_policejob:handcuffhype', function()
	local closestPlayer = ESX.Game.GetClosestPlayer()
	IsHandcuffed    = not IsHandcuffed
	ESX.ShowNotification('~o~Zostałeś zakuty/rozkuty przez ~g~[' .. GetPlayerServerId(closestPlayer) ..']')
	CreateThread(function()
		if IsHandcuffed then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if not exports['stinky_trunk']:checkInTrunk() then
				RequestAnimDict('mp_arresting')
				while not HasAnimDictLoaded('mp_arresting') do
					Wait(0)
				end

				if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
				end
			end
			
			ESX.UI.Menu.CloseAll()
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			DisablePlayerFiring(playerPed, true)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Cuff", 0.5)
			StartHandcuffTimer()
		else
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Uncuff", 0.5)
				ClearPedTasksImmediately(playerPed)
			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			
			if exports['stinky_trunk']:checkInTrunk() then
				TaskPlayAnim(playerPed, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
		end
	end)

end)
	
RegisterNetEvent('exilerp_pj:unrestplayer')
AddEventHandler('exilerp_pj:unrestplayer', function()
	if IsHandcuffed then
		IsHandcuffed = false
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'odkuj', 0.2)
		ClearPedTasksImmediately(playerPed)
		if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end

		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
	if IsHandcuffed or IsPlayerDead(playerId) then
		IsDragged = not IsDragged
		CopPlayer = tonumber(cop)
	end
end)

RegisterNetEvent('esx_policejob:dragging')
AddEventHandler('esx_policejob:dragging', function(target, dropped)
	DraggingLokal = false
	if not dropped then
		Dragging = target
	elseif Dragging == target then
		Dragging = nil
	end
end)

CreateThread(function()
	local attached = false
	while true do
		if Dragging then
			local ped = PlayerPedId()			
			SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
			Wait(100)
		elseif IsHandcuffed or IsPlayerDead(playerId) or isDead then
			local playerPedId = PlayerPedId()
			if IsDragged then
				if not attached then
					attached = true
					FreezeEntityPosition(playerPedId, true)
					AttachEntityToEntity(playerPedId, GetPlayerPed(GetPlayerFromServerId(CopPlayer)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					TriggerServerEvent('esx_policejob:dragging', CopPlayer, GetPlayerServerId(playerId))
				end
			elseif CopPlayer then
				DetachEntity(playerPedId, true, false)
				FreezeEntityPosition(playerPedId, false)

				TriggerServerEvent('esx_policejob:dragging', CopPlayer)
				attached = false
				CopPlayer = nil
			end
			Wait(10)
		else
			if IsDragged then
				local playerPedId = PlayerPedId()
				DetachEntity(playerPedId, true, false)
				TriggerServerEvent('esx_policejob:dragging', CopPlayer)

				local coords2 = GetEntityCoords(playerPedId, true)
				RequestCollisionAtCoord(coords2.x, coords2.y, coords2.z)

				attached = false
				CopPlayer = nil
				IsDragged = false
			end
			Wait(500)
		end	
	end
end)

RegisterNetEvent('esx_policejob:putInTrunk')
AddEventHandler('esx_policejob:putInTrunk', function(cop)
	if IsHandcuffed then				
		TriggerEvent('exile:forceInTrunk', cop)
	end
end)

RegisterNetEvent('esx_policejob:OutTrunk')
AddEventHandler('esx_policejob:OutTrunk', function(cop)
	if IsHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Wait(1)
		end
		TriggerEvent('exile:forceOutTrunk', cop)
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	else
		TriggerEvent('exile:forceOutTrunk', cop)
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	if IsHandcuffed or isDead then
		local vehicle = nil
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = ESX.Game.GetVehicleInDirection()
			if not vehicle then
				local coords = GetEntityCoords(playerPed, false)
				if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end
			end
		end
		if vehicle and vehicle ~= 0 then
			local maxSeats =  GetVehicleMaxNumberOfPassengers(vehicle)
			if maxSeats >= 0 then
				local freeSeat
				for i = (maxSeats - 1), 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end
				if freeSeat ~= nil then		
					ClearPedTasksImmediately(playerPed)			
					local tick = 20
					repeat
						TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
						tick = tick - 1
						Wait(50)
					until IsPedInAnyVehicle(playerPed, false) or tick == 0
				end
			end
		end
	end
end)
  
RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	if IsHandcuffed or isDead then
		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			TaskLeaveVehicle(playerPed, vehicle, 16)
			if not exports['stinky_trunk']:checkInTrunk() then
				RequestAnimDict('mp_arresting')
				while not HasAnimDictLoaded('mp_arresting') do
					Wait(0)
				end
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
			end
			CreateThread(function() 
				Wait(300)
				ClearPedTasksImmediately(playerPed)
			end)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		
		if IsHandcuffed then

			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true) 
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['TOP'], true) 
			DisableControlAction(2, Keys['SPACE'], true) 
			DisableControlAction(2, Keys['Q'], true) 
			DisableControlAction(2, Keys['~'], true) 
			DisableControlAction(2, Keys['Y'], true) 
			DisableControlAction(2, Keys['B'], true)
			DisableControlAction(2, Keys['TAB'], true) 
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true) 
			DisableControlAction(2, Keys['F3'], true) 
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['centerSHIFT'], true)
			DisableControlAction(2, Keys['V'], true) 
			DisableControlAction(2, Keys['P'], true) 
			DisableControlAction(2, 59, true) 
			DisableControlAction(2, Keys['centerCTRL'], true) 
			DisableControlAction(0, 47, true) 
			DisableControlAction(0, 264, true) 
			DisableControlAction(0, 257, true) 
			DisableControlAction(0, 140, true) 
			DisableControlAction(0, 141, true) 
			DisableControlAction(0, 142, true) 
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 56, true)

			if not IsPedCuffed(playerPed) then
				SetEnableHandcuffs(playerPed, true)
			end
			if IsPedInAnyPoliceVehicle(playerPed) then
				DisableControlAction(0, 75, true) 
				DisableControlAction(27, 75, true)
			end
			RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Wait(0)
            end
            if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) and not exports['stinky_trunk']:checkInTrunk() then
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            end
		else
			Wait(500)
			SetEnableHandcuffs(playerPed, false)
		end
	end
end)
  

CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(500)
	end
	
	for i=1, #Config.Blips, 1 do
		local blip = AddBlipForCoord(Config.Blips[i].Pos)

		SetBlipSprite (blip, Config.Blips[i].Sprite)
		SetBlipDisplay(blip, Config.Blips[i].Display)
		SetBlipScale  (blip, Config.Blips[i].Scale)
		SetBlipColour (blip, Config.Blips[i].Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blips[i].Label)
		EndTextCommandSetBlipName(blip)
	end
	
	if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
		for i=1, #Config.PoliceStations.Lodzie, 1 do
			local blip = AddBlipForCoord(Config.PoliceStations.Lodzie[i].coords)

			SetBlipSprite (blip, 404)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.7)
			SetBlipColour (blip, 38)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Port SASP")
			EndTextCommandSetBlipName(blip)
		end
	end
end)

CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(3)
		local found = false
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			for k,v in pairs(Config.PoliceStations) do
				for i=1, #v, 1 do
					if k == "VehicleDeleters" or k == 'VehicleDodatki' or k == 'VehicleFixing' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawBigMarker(vec3(v[i].coords))
						end
					end
					if k ~= "VehicleDeleters" and k ~= 'VehicleDodatki' and k ~= 'VehicleFixing' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawMarker(v[i].coords)
						end
					end
				end
			end
			if not found then
				Wait(2000)
			end
		else
			Wait(2000)
		end
	end
end)

CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(3)
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			local isInMarker     = false
			local found = false
			local currentStation = nil
			local currentPartNum = nil

			for k,v in pairs(Config.PoliceStations) do
				for i=1, #v, 1 do
					if k == "VehicleDeleters" or k == 'VehicleDodatki' then
						if #(coords - v[i].coords) < 3.0 then
							found = true
							isInMarker     = true
							currentStation = k
							currentPartNum = i
						end
					end
					
					if k ~= "VehicleDeleters" and k ~= 'VehicleDodatki' then
						if #(coords - v[i].coords) < Config.MarkerSize.x then
							found = true
							isInMarker     = true
							currentStation = k
							currentPartNum = i
						end
					end
				end
			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPartNum ~= currentPartNum)) then

				if (LastStation ~= nil and LastPartNum ~= nil) and (LastStation ~= currentStation or LastPartNum ~= currentPartNum) then
					TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPartNum             = currentPartNum
	
				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPartNum)
			end
		  
			if not found then
				Wait(1000)
			end
		else
			Wait(2000)
		end
	end
end)
  
  
RegisterNetEvent('esx_policejob:dodatkiGaraz')
AddEventHandler('esx_policejob:dodatkiGaraz', function()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		OpenDodatkiGarazMenu()
	end
end)

function DodatkiGarazCommand()
	if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') and ESX.PlayerData.job.grade >= 10 then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if IsPedInAnyVehicle(playerPed, false) then
			OpenDodatkiGarazMenu()
		end
	else
		ESX.ShowNotification('~r~Nie masz odpowiedniej rangi aby tego uzyc')
	end
end

  
function OpenDodatkiGarazMenu()
	local elements1 = {}
	local vehicle = GetVehiclePedIsIn(playerPed, false)

	for ExtraID=0, 20 do
		if DoesExtraExist(vehicle, ExtraID) then
			if IsVehicleExtraTurnedOn(vehicle, ExtraID) == 1 then
				local tekstlabel = 'Dodatek '..tostring(ExtraID)..' - Zdemontuj'
				table.insert(elements1, {label = tekstlabel, posiada = true, value = ExtraID})
			elseif IsVehicleExtraTurnedOn(vehicle, ExtraID) == false then
				local tekstlabel = 'Dodatek '..tostring(ExtraID)..' - Podgląd'
				table.insert(elements1, {label = tekstlabel, posiada = false, value = ExtraID})
			end
		end
	end

	if #elements1 == 0 then
		table.insert(elements1, {label = 'Ten pojazd nie posiada dodatków!', posiada = nil, value = nil})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja', {
		title    = 'Dodatki - Sklep',
		align    = 'center',
		elements = elements1
	}, function(data, menu)
		local dodatek2 = data.current.value
		if dodatek2 ~= nil then
			local dodatekTekst = 'extra'..dodatek2
			local posiada = data.current.posiada
			if posiada then
				menu.close()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja_usun', {
					title    = 'Zdemontować dodatek?',
					align    = 'center',
					elements = {
						{label = "Tak", value = "tak"},
						{label = "Nie", value = "nie"},
					}
				}, function(data2, menu2)
					local akcja = data2.current.value
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local tablica = vehicleProps.plate
					if akcja == 'tak' then
						SetVehicleExtra(vehicle, dodatek2, 1)
						TriggerServerEvent('esx_policejob:DodatkiKup', tablica, dodatekTekst, false)
					elseif akcja == 'nie' then
						SetVehicleExtra(vehicle, dodatek2, 0)
					end
					menu2.close()
					Wait(200)
					OpenDodatkiGarazMenu()
				end, function(data2, menu2)
					menu2.close()
				end)
				
			elseif posiada == false then
				SetVehicleExtra(vehicle, dodatek2, 0)
				menu.close()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja_kup', {
					title = 'Potwierdzić montaż?',
					align = 'center',
					elements = {
						{label = "Tak - Zamontuj", value = "tak"},
						{label = "Nie - Anuluj", value = "nie"},
					}
				}, function(data3, menu3)
					local akcja = data3.current.value
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local tablica = vehicleProps.plate
					if akcja == 'tak' then
						TriggerServerEvent('esx_policejob:DodatkiKup', tablica, dodatekTekst, true)
					elseif akcja == 'nie' then
						SetVehicleExtra(vehicle, dodatek2, 1)
					end
					
					menu3.close()
					Wait(200)
					OpenDodatkiGarazMenu()
				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = ''
		CurrentActionMsg = ""
		CurrentActionData = {}
	end)
end
	
function SpawnHelicopter(partNum)
	local helicopters = Config.PoliceStations.Helicopters
	local helimodel = ""
	if ESX.PlayerData.job.name == 'sheriff' then
		helimodel = "so_heli"
	elseif ESX.PlayerData.job.name == 'police' then
		helimodel = "pd_heli"
	end
	if not IsAnyVehicleNearPoint(helicopters[partNum].spawnPoint.x, helicopters[partNum].spawnPoint.y, helicopters[partNum].spawnPoint.z,  3.0) then
		ESX.Game.SpawnVehicle(helimodel, helicopters[partNum].spawnPoint, helicopters[partNum].heading, function(vehicle)
		  SetVehicleLivery(vehicle, 0)
		  local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
		  TriggerEvent('ls:dodajklucze2', localVehPlate)
	  end)
	end
end


CreateThread(function()
	while true do
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			if not IsPedInAnyVehicle(playerPed, false) then
				local found = false
				for _, prop in ipairs({
					`p_ld_stinger_s`,
					`prop_barrier_work05`
				}) do
					local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  2.0,  prop, false, false, false)
					if DoesEntityExist(object) then
						CurrentAction     = 'remove_entity'
						CurrentActionMsg  = _U('remove_prop')
						CurrentActionData = {entity = object}
						found = true
						break
					end
				end

				if not found and CurrentAction == 'remove_entity' then
					CurrentAction = nil
				end

				Wait(160)
			else
				Wait(1000)
			end
		else
			Wait(1000)
		end
	end
end)

local animation = { lib = 'random@mugging3' , base = 'handsup_standing_base', enter = 'handsup_standing_enter', exit = 'handsup_standing_exit', fade = 1 }

function CanCuff(src,l) 
	local gracz = src
	if l then
		gracz = GetPlayerPed(src)
	end
	if not gracz then return end
	local can = false
	if IsPlayerDead(gracz) or GetEntityHealth(gracz) == 0 or IsEntityPlayingAnim(gracz, 'dead', 'dead_a', 3) or IsEntityPlayingAnim(gracz, animation.lib, animation.base, 3) or IsEntityPlayingAnim(gracz, animation.lib, animation.enter, 3) or IsEntityPlayingAnim(gracz, animation.lib, animation.exit, 3) or IsEntityPlayingAnim(gracz, 'mp_arresting', 'idle', 3) or IsEntityPlayingAnim(gracz, 'random@mugging3', 'handsup_standing_enter', 3) or IsEntityPlayingAnim(gracz, 'random@mugging3', 'handsup_standing_exit', 3) or IsEntityPlayingAnim(gracz, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 3) or IsEntityDead(gracz) or IsPedBeingStunned(gracz) or IsPedSwimming(gracz) or IsPedSwimmingUnderWater(gracz) or IsEntityPlayingAnim(gracz, "missminuteman_1ig_2", "handsup_enter", 3) or IsEntityPlayingAnim(gracz, "random@arrests@busted", "enter", 3) or IsEntityPlayingAnim(gracz, "random@mugging3", "handsup_standing_base", 3) then
		can = true
	end
	if not l and IsPlayerDead(gracz) then
		can = false
	end
	return can
end

function RestrictedMenu()
	ESX.UI.Menu.CloseAll()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'center',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			local t = true
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
					if bought then
						
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
							currentSkin = skin
						end)

						ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
							if foundStore then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing',
								{
									title = _U('save_in_dressing'),
									align = 'center',
									elements = {
										{label = _U('no'),  value = 'no'},
										{label = _U('yes'), value = 'yes'}
									}
								}, function(data2, menu2)
									menu2.close()

									if data2.current.value == 'yes' then
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
											title = _U('name_outfit')
										}, function(data3, menu3)
											menu3.close()

											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
												ESX.ShowNotification('~g~Ubranie zostalo zapisane w domu\n~b~Nazwą zapisanego ubrania: ~g~'..data3.value)
												t = true												
											end)
										end, function(data3, menu3)
											menu3.close()
										end)
									end
								end)
							end
						end)

					else
						t = false
						ESX.ShowNotification(_U('not_enough_money'))
						cleanPlayer()
					end
				end)
			elseif data.current.value == 'no' then
				OpenShopMenu()
				t = false
			end
			
			if t then
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end
		end, function(data, menu)
			menu.close()
			cleanPlayerskin()
		end)

	end, function(data, menu)
		menu.close()
		cleanPlayerskin()
		
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'watches_1',
		'watches_2',
		'helmet_1',
		'helmet_2',
		'mask_1',
		'mask_2',
		'glasses_1',
		'glasses_2',
		'bags_1',
		'bags_2',
		'bproof_1',
		'bproof_2'
	})
end

function OpenShopMenu()
	local elements = {
		{label = _U('shop_clothes'),  value = 'shop_clothes'},
		{label = ('Własne ubrania'), value = 'player_dressing'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title    = _U('shop_main_menu'),
		align    = 'center',
		elements = elements,
    }, function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			RestrictedMenu()
		end

		if data.current.value == 'player_dressing' then
			OpenClothes()
		end
    end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
    end)
end

function OpenClothes()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for k,v in pairs(dressing) do
			table.insert(elements, {label = v, value = k})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
			title    = 'Garderoba',
			align    = 'center',
			elements = elements
		}, function(data, menu)		
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
				title = 'Wybierz ubranie - ' .. data.current.label,
				align = 'center',
				elements = {
					{label = 'Ubierz', value = 'wear'},
					{label = 'Zmień nazwę', value = 'rename'},
					{label = 'Usuń ubranie', value = 'remove'}
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value == 'wear' then
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data.current.value)
					end)
				elseif data2.current.value == 'rename' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
						title = 'Zmień nazwę - ' .. data.current.label
					}, function(data3, menu3)
						menu3.close()
						TriggerServerEvent('esx_property:renameOutfit', data.current.value, data3.value)
						ESX.ShowNotification('Zmieniono nazwę ubrania!')
						OpenClothes()
					end, function(data3, menu3)
						menu3.close()
						menu2.open()
					end)
				elseif data2.current.value == 'remove' then
					TriggerServerEvent('esx_property:removeOutfit', data.current.value)
					ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data.current.label)
					OpenClothes()
				end
			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)		
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end)
	end)
end

function cleanPlayerskin()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end

  
CreateThread(function()
	while true do
		Wait(5)
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			if CurrentAction ~= nil then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					if CurrentAction == 'menu_cloakroom' then
						OpenCloakroomMenu()
					elseif CurrentAction == 'menu_pharmacy' then
						OpenPharmacyMenu()
					elseif CurrentAction == 'menu_swat_armory' then
						OpenSWATArmoryMenu()
					elseif CurrentAction == 'menu_hc_armory' then
						OpenHCArmoryMenu()
					elseif CurrentAction == 'menu_vehicle_spawner' then
						OpenVehicleSpawnerMenu(CurrentActionData.partNum)
					elseif CurrentAction == 'delete_vehicle' then
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						TriggerServerEvent('exile_logs:triggerLog', "Schował pojazd policyjny " .. CurrentActionData.vehicle, 'chowpolicecars', '3066993')
					elseif CurrentAction == 'menu_lodzie_spawner' then
						OpenLodzieSpawnerMenu(CurrentActionData.partNum)
					elseif CurrentAction == 'menu_helicopter_spawner' then
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
							if hasWeaponLicense then
								SpawnHelicopter(CurrentActionData.partNum)
							else
								ESX.ShowNotification("~r~Nie posiadasz odpowiedniej licencji")
							end
						end, GetPlayerServerId(playerId), 'heli')
					elseif CurrentAction == 'menu_dodatki' then
						OpenDodatkiGarazMenu()
					elseif CurrentAction == 'menu_fixing' then
						if exports["stinky_localmecano"]:CanRepairVehicle() then
							exports["stinky_localmecano"]:RepairVehicle(true)
						end
					elseif CurrentAction == 'menu_boss_actions' then
						local elements = {
							{label = 'SASP',     value = 'sasp'}, 	
							{label = 'SASD',     value = 'sasd'}, 	
						}
					
						Wait(100)
					
						ESX.UI.Menu.CloseAll()
					
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'swat_armory', {
							title		= "Zarządzanie jednostkami",
							align		= 'center',			
							elements = elements
						}, function(data, menu)
							if data.current.value == 'sasp' then
								if (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
									TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', 'police', function(data, menu)
										menu.close()
										CurrentAction     = 'menu_boss_actions'
										CurrentActionMsg  = _U('open_bossmenu')
										CurrentActionData = {}
									end, { showmoney = true, withdraw = true, deposit = true, wash = true, employees = true, badges = true, licenses = true})
								elseif (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade < 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade < 11) then
									TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', 'police', function(data, menu)
										menu.close()
										CurrentAction     = 'menu_boss_actions'
										CurrentActionMsg  = _U('open_bossmenu')
										CurrentActionData = {}
									end, { showmoney = false, withdraw = false, deposit = true, wash = true, employees = false, badges = false, licenses = false})
								end
							elseif data.current.value == 'sasd' then
								if (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
									TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', 'sheriff', function(data, menu)
										menu.close()
										CurrentAction     = 'menu_boss_actions'
										CurrentActionMsg  = _U('open_bossmenu')
										CurrentActionData = {}
									end, { showmoney = true, withdraw = true, deposit = true, wash = true, employees = true, badges = true, licenses = true})
								elseif (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade < 10) or (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade < 11) then
									TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', 'sheriff', function(data, menu)
										menu.close()
										CurrentAction     = 'menu_boss_actions'
										CurrentActionMsg  = _U('open_bossmenu')
										CurrentActionData = {}
									end, { showmoney = false, withdraw = false, deposit = true, wash = true, employees = false, badges = false, licenses = false})
								end
							end
						end, function(data, menu)
							menu.close()
						end)
					elseif CurrentAction == 'remove_entity' then
						DeleteEntity(CurrentActionData.entity)
					elseif CurrentAction == 'menu_skin' then
						OpenShopMenu()
					elseif CurrentAction == 'change_job' then
						OpenChangeJobMenu()
					end
				
					CurrentAction = nil
				end
			else
				Wait(1000)
			end
		else
			Wait(1000)
		end
	end
end)

RegisterCommand('-policef6', function(source, args, rawCommand)
	if not isDead and ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
		OpenPoliceActionsMenu()
	end
end, false)

RegisterKeyMapping('-policef6', 'Otwórz policyjne menu', 'keyboard', 'F6')
local fastbinds = true
RegisterCommand('fastbinds', function()
	fastbinds = not fastbinds
end, false)
CreateThread(function()
	while true do
		Wait(8)
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			if fastbinds then
				if IsControlPressed(0, Keys['centerSHIFT']) then
					DisableControlAction(0, Keys['Q'], true)
					if IsDisabledControlJustPressed(0, Keys['Q']) and not IsPedInAnyVehicle(playerPed) and not isDead and not IsHandcuffed then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
							if CanCuff(closestPlayer, true) then
								animacjazakuciarozkuciaxd()
								Wait(700)
								TriggerServerEvent('esx_policejob:handcuffhype', GetPlayerServerId(closestPlayer))
								ESX.ShowNotification('~o~Zakułeś/Odkułeś ~g~[' .. GetPlayerServerId(closestPlayer) ..']')
							else
								ESX.ShowNotification("~r~Osoba którą próbujesz zakuć nie ma rąk w górze")
							end	
						else
							ESX.ShowNotification("~r~Brak osób w pobliżu")
						end
					end
					
					if IsControlJustPressed(0, Keys['E']) and not IsPedInAnyVehicle(playerPed) and not isDead and not IsHandcuffed then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
						else
							ESX.ShowNotification("~r~Brak osób w pobliżu")
						end
					end
				end

			else
				Wait(500)
			end
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:removedGPS')
AddEventHandler('esx_policejob:removedGPS', function(data)
	ESX.ShowNotification("~r~Utracono połączenie z nadajnikiem ~w~\n" .. data.name)
	local alpha = 250
	local gpsBlip = AddBlipForCoord(data.coords)
	SetBlipSprite(gpsBlip, 280)
	SetBlipColour(gpsBlip, 3)
	SetBlipAlpha(gpsBlip, alpha)
	SetBlipScale(gpsBlip, 1.2)
	SetBlipAsShortRange(gpsBlip, false)
	SetBlipCategory(gpsBlip, 15)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("# OSTATNIA LOKALIZACJA " .. data.name)
	EndTextCommandSetBlipName(gpsBlip)
	
	for i=1, 25, 1 do
		PlaySound(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0, 0, 1)
		Wait(300)
		PlaySound(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", 0, 0, 1)
		Wait(300)
	end
	
	while alpha ~= 0 do
		Wait(180 * 4)
		alpha = alpha - 1
		SetBlipAlpha(gpsBlip, alpha)
		if alpha == 0 then
			RemoveBlip(gpsBlip)
			return
		end
	end
end)
  
AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('exilerp_pj:unrestplayer')
end)
  
AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)
  
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('exilerp_pj:unrestplayer')

		if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end
	end
end)

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer then
		ESX.ClearTimeout(HandcuffTimer)
	end
	
	HandcuffTimer = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification("~y~Czujesz jak Twoje kajdanki luzują się...")
		TriggerEvent('exilerp_pj:unrestplayer')
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "Uncuff", 0.4)
	end)
end
  
function ImpoundVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end
  
RegisterNetEvent('Kajdanki')
AddEventHandler('Kajdanki', function()
	if exports['StinkyRP']:isAntytroll() then
		ESX.ShowNotification("~r~Jesteś w trakcie antytrolla!")
		return
	end
	if not inVehicle then
		HandcuffMenu()
	end
end)

function MenuBroni()
	local elements = {}
	
	for _,value in ipairs(Config.WeaponShop) do		
		if value.grade <= ESX.PlayerData.job.grade or value.job_name == ESX.PlayerData.job.grade_name then	
			if value.type == 'weapon' then
				table.insert(elements, {
					label = (value.label) .. (value.price == 0 and ' [<span style="color:green;">DARMOWE</span>]' or ' [<span style="color:green;">'..value.price..'$</span>]'),
					value = value.name,
					price = value.price
				})
			elseif value.type == 'weaponhc' and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') and ESX.PlayerData.job.grade >= 10 then 
				table.insert(elements, {
					label = (value.label) .. (value.price == 0 and ' [<span style="color:green;">DARMOWE</span>]' or ' [<span style="color:green;">'..value.price..'$</span>]'),
					value = value.name,
					price = value.price
				})
			else
				table.insert(elements, {
					label = value.label .. (value.price == 0 and ' [<span style="color:green;">DARMOWE</span>]' or ' [<span style="color:green;">'..value.price..'$</span>]'),
					value = value.name,
					price = value.price
				})
			end
		end
	end
	
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menubroni', {
		title    = 'Zbrojownia',
		align    = 'center',
		elements = elements
	}, function(data, menu)		
		TriggerServerEvent('esx_policejob:giveWeapon', data.current.value, 250, data.current.price, data.current.label)
	end, function(data, menu)
		menu.close()
		
		OpenPharmacyMenu()
	end)
end

OpenSWATArmoryMenu = function()
	local elements = {
		{label = _U('put_weapon'),     value = 'put_weapon'}, 	
	}

	ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
		if hasWeaponLicense or (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job and ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
			table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		end
	end, GetPlayerServerId(playerId), 'swat')

	Wait(100)

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'swat_armory', {
		title		= "Zbrojownia SWAT",
		align		= 'center',			
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_weapon' then
			TriggerEvent('exile:putInventoryItem', 'society_swat')
		elseif data.current.value == 'get_weapon' then
			TriggerEvent('exile:getInventoryItem', 'society_swat')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'menu_swat_armory'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię SWAT"
		CurrentActionData	= {}
	end)
end

OpenHCArmoryMenu = function()
	local elements = {
			{label = _U('put_weapon'),     value = 'put_weapon'}, 	
	}

	ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
		if hasWeaponLicense or (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 10) or (ESX.PlayerData.job and ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11) then
			table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		end
	end, GetPlayerServerId(playerId), 'hc')

	Wait(100)

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hc_armory', {
		title		= "Zbrojownia High Command",
		align		= 'center',			
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_weapon' then
			TriggerEvent('exile:putInventoryItem', 'society_highcommand')
		elseif data.current.value == 'get_weapon' then
			TriggerEvent('exile:getInventoryItem', 'society_highcommand')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'menu_hc_armory'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię High Command"
		CurrentActionData	= {}
	end)
end
  
function OpenPharmacyMenu()
  
	local elements = {}
	if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') and ESX.PlayerData.job.grade == 0 then
		elements = {
			{label = 'Pobierz wyposażenie patrolowe', value = 'get_wypo'},
			{label = _U('deposit_object'), value = 'put_stock'}, 
		}
	elseif (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') and (ESX.PlayerData.job.grade > 0 and ESX.PlayerData.job.grade < 10) then
		elements = {
			{label = 'Pobierz wyposażenie patrolowe', value = 'get_wypo'},
			{label = 'Weź broń',     value = 'get_weapon'}, 	
			{label = _U('remove_object'),  value = 'get_stock'}, 		
			{label = _U('deposit_object'), value = 'put_stock'}, 
		}
	elseif (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') and ESX.PlayerData.job.grade >= 10 then
		elements = {
			{label = 'Pobierz wyposażenie patrolowe', value = 'get_wypo'},
			{label = 'Weź wyposażenie specjalne', value = 'get_wypo2'},
			{label = 'Weź broń',     value = 'get_weapon'}, 	
			{label = _U('remove_object'),  value = 'get_stock'}, 		
			{label = _U('deposit_object'), value = 'put_stock'}, 
		}
	end
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title		= _U('pharmacy_menu_title'),
		align		= 'center',			
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('exile:putInventoryItem', 'society_'..ESX.PlayerData.job.name)
		elseif data.current.value == 'get_wypo' then
			OpenGetWypoMenu()
		elseif data.current.value == 'get_wypo2' then
			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
				if hasWeaponLicense then
					hasSertLicense = true
					OpenGetWypo2Menu()
				end
			end, GetPlayerServerId(playerId), 'swat')
		elseif data.current.value == 'get_weapon' then
			MenuBroni()
		elseif data.current.value == 'get_stock' then
			TriggerEvent('exile:getInventoryItem', 'society_'..ESX.PlayerData.job.name)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'menu_pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}
	end)
end
  
function OpenGetWypoMenu()
	local elements = {
		{label = _U('pharmacy_takeclip', "Magazynek do pistoletu"), value = 'clip', count = 1},
		{label = _U('pharmacy_takeradio', "Gps"), value = 'gps', count = 1},
		{label = _U('pharmacy_takeradio', "BodyCam"), value = 'bodycam', count = 1},
		{label = _U('pharmacy_takeradio', "Panic Button"), value = 'panic', count = 3},
		{label = _U('pharmacy_takeradio', "Radio"), value = 'radio', count = 1},
		{label = _U('pharmacy_takeradio', "Strój do nurkowania SASP"), value = 'nurek_sasp', count = 2},
		{label = _U('pharmacy_takeradio', "Strój do nurkowania SASD"), value = 'nurek_sasd', count = 2},
	}
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_take_wposazenie', {
		title    = 'Wyposażenie',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_policejob:giveItem', data.current.value, data.current.count)
	end, function(data, menu)
		menu.close()

		OpenPharmacyMenu()
	end)
end

function OpenGetWypo2Menu()
	local elements = {
		{label = _U('pharmacy_takeflashlight', _U('flashlight')), value = 'flashlight', count = 1},
		{label = _U('pharmacy_takeclip', "Magazynek do pistoletu"), value = 'clip', count = 1},
		{label = _U('pharmacy_takeradio', "Celownik MK I"), value = 'scope_holo', count = 1},
		{label = _U('pharmacy_takeradio', "Celownik MK II"), value = 'scope_medium', count = 1},
		{label = _U('pharmacy_takeradio', "Celownik MK III"), value = 'scope_large', count = 1},
		{label = _U('pharmacy_takeradio', "Uchwyt"), value = 'grip', count = 1},
		{label = _U('pharmacy_takeradio', "Celownik"), value = 'scope', count = 1},
		{label = _U('pharmacy_takeradio', "Powiększony Magazynek"), value = 'clip_extended', count = 1},
		{label = _U('pharmacy_takeradio', "Tłumik"), value = 'suppressor', count = 1},
		{label = _U('pharmacy_takeradio', "Kamizelka SWAT 100%"), value = 'kamzasaspbigswat', count = 1},
		{label = _U('pharmacy_takeradio', "Kask SWAT 100%"), value = 'kasksaspswat', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek bębnowy"), value = 'clip_drum', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do Shotgun"), value = 'shotgunclip', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do MG"), value = 'mgclip', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do Gusenberg"), value = 'gusenbergclip', count = 1},	
		{label = _U('pharmacy_takeradio', "Magazynek do Sniper"), value = 'sniperclip', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do SMG"), value = 'smgclip', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do PDW"), value = 'pdwclip', count = 1},	
		{label = _U('pharmacy_takeradio', "Magazynek do Carbine"), value = 'carbineclip', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do Assault"), value = 'assaultclip', count = 1},	
	}
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_take_wposazenie2', {
		title    = 'Wyposażenie',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_policejob:giveItem', data.current.value, data.current.count)
		-- TriggerServerEvent('exile_logs:triggerLog', "Gracz wyjął z Wyposażenia SWAT / HC item: " ..data.current.value.." w ilości: "..data.current.count, 'wyposazenieswatsert')
		-- TriggerServerEvent('exile_logs:triggerLog', "Gracz wyjął z Wyposażenia SWAT / HC item: " ..data.current.value.." w ilości: "..data.current.count, 'swatstock')
	end, function(data, menu)
		menu.close()
		
		OpenPharmacyMenu()
	end)
end
  
function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Wait(1)
		end
	end
end

function animacjazakuciarozkuciaxd()
	local ad = "mp_arresting"
	local anim = "a_uncuff"

	if (DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not isDead) then
		loadanimdict(ad)
		if (IsEntityPlayingAnim(playerPed, ad, anim, 8)) then
			TaskPlayAnim(playerPed, ad, "exit", 8.0, 3.0, 2000, 26, 1, 0, 0, 0)
			ClearPedSecondaryTask(playerPed)
		else
			TaskPlayAnim(playerPed, ad, anim, 8.0, 3.0, 2000, 26, 1, 0, 0, 0)
		end
	end
end

AddEventHandler('esx:onPlayerDeath', function(reason)
	TriggerServerEvent("exilerp_scripts:CLdeath")
end)

AddEventHandler('playerSpawned', function() 
	TriggerServerEvent("exilerp_scripts:CLrev")
end)

local cooldown = 0

AddEventHandler("onClientMapStart", function()
	TriggerEvent("chat:addSuggestion", "/10-13", "10-13")
	TriggerEvent("chat:addSuggestion", "/10-10", "10-10")
	TriggerEvent("chat:addTemplate", "10-13", "<img src='data:image/png;base64,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' height='16'> <b>{0}</b>: {1}")
end)

CreateThread(function()
	while true do
		if cooldown > 0 then
			Wait(1000)
			cooldown = cooldown - 1
		else
			Wait(2000)
		end
	end
end)

RegisterCommand("10-13", function()
	if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'ambulance' then
		if exports["esx_ambulancejob"]:isDead() then
			if cooldown <= 0 then
			
				cooldown = 60
				local Officer = {}
				Officer.Player = playerId
				Officer.Ped = playerPed
				Officer.Coords = coords
				Officer.Location = {}
				Officer.Location.Street, Officer.Location.CrossStreet = GetStreetNameAtCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
				Officer.Location.Street = GetStreetNameFromHashKey(Officer.Location.Street)
				if Officer.Location.CrossStreet ~= 0 then
					Officer.Location.CrossStreet = GetStreetNameFromHashKey(Officer.Location.CrossStreet)
					Officer.Location = Officer.Location.Street .. " X " .. Officer.Location.CrossStreet
				else
					Officer.Location = Officer.Location.Street
				end
				TriggerServerEvent("break_10-13srp:request", Officer)
			else
				ESX.ShowNotification('~r~Nie możesz używać 10-13 tak często!')
			end
		else
			ESX.ShowNotification('~r~Czujesz się zbyt dobrze, aby użyć 10-13')
		end
	else
		ESX.ShowNotification("Nie jesteś do tego ~r~uprawniony")
	end
end)

RegisterNetEvent("break_10-13srp:alert")
AddEventHandler("break_10-13srp:alert", function(Officer, name, jobTxt)
	PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)

	TriggerEvent("chatMessage", '^0[^3Centrala^0] ', { 0, 0, 0 }, "^*^110-13: ^*^7 " .. jobTxt .. " " .. name .. " | ^*^1Ulica ^*^7" .. Officer.Location)
	
	CreateThread(function()
		local Blip = AddBlipForCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
		SetBlipSprite (Blip, 303)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 1.0)
		SetBlipColour (Blip, 3)
		SetBlipAsShortRange(Blip, false)
		SetBlipCategory(Blip, 14)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("[10-13] " .. name)
		EndTextCommandSetBlipName(Blip)
		Wait(60000)
		RemoveBlip(Blip)
		Blip = nil
	end)
end)

RegisterCommand("10-10", function()
	if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'ambulance' then
		-- if exports["esx_ambulancejob"]:isDead() then
			if cooldown <= 0 then
			
				cooldown = 60
				local Officer = {}
				Officer.Player = playerId
				Officer.Ped = playerPed
				Officer.Coords = coords
				Officer.Location = {}
				Officer.Location.Street, Officer.Location.CrossStreet = GetStreetNameAtCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
				Officer.Location.Street = GetStreetNameFromHashKey(Officer.Location.Street)
				if Officer.Location.CrossStreet ~= 0 then
					Officer.Location.CrossStreet = GetStreetNameFromHashKey(Officer.Location.CrossStreet)
					Officer.Location = Officer.Location.Street .. " X " .. Officer.Location.CrossStreet
				else
					Officer.Location = Officer.Location.Street
				end
				TriggerServerEvent("break_10-10srp:request", Officer)
			else
				ESX.ShowNotification('~r~Nie możesz używać 10-10 tak często!')
			end
		-- else
		-- 	ESX.ShowNotification('~r~Czujesz się zbyt dobrze, aby użyć 10-10')
		-- end
	else
		ESX.ShowNotification("Nie jesteś do tego ~r~uprawniony")
	end
end)

RegisterNetEvent("break_10-10srp:alert")
AddEventHandler("break_10-10srp:alert", function(Officer, name, jobTxt)
	PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)

	TriggerEvent("chatMessage", '^0[^3Centrala^0] ', { 0, 0, 0 }, "^*^110-10: ^*^7 " .. jobTxt .. " " .. name .. " | ^*^1Ulica ^*^7" .. Officer.Location)
	
	CreateThread(function()
		local Blip = AddBlipForCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
		SetBlipSprite (Blip, 303)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 1.0)
		SetBlipColour (Blip, 3)
		SetBlipAsShortRange(Blip, false)
		SetBlipCategory(Blip, 14)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("[10-10] " .. name)
		EndTextCommandSetBlipName(Blip)
		Wait(60000)
		RemoveBlip(Blip)
		Blip = nil
	end)
end)

RegisterNetEvent('falszywyy:getCoords')
AddEventHandler('falszywyy:getCoords', function()
	local Officer = {}
	Officer.Player = playerId
	Officer.Ped = playerPed
	Officer.Coords = coords
	Officer.Location = {}
	Officer.Location.Street, Officer.Location.CrossStreet = GetStreetNameAtCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
	Officer.Location.Street = GetStreetNameFromHashKey(Officer.Location.Street)
	if Officer.Location.CrossStreet ~= 0 then
		Officer.Location.CrossStreet = GetStreetNameFromHashKey(Officer.Location.CrossStreet)
		Officer.Location = Officer.Location.Street .. " X " .. Officer.Location.CrossStreet
	else
		Officer.Location = Officer.Location.Street
	end
	TriggerServerEvent("falszywyy:panicrequest", Officer)
end)

RegisterNetEvent("falszywyy:triggerpanic")
AddEventHandler("falszywyy:triggerpanic", function(Officer, name)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, 'panic2', 0.1)
	
	TriggerEvent("chatMessage", '^0[^3Centrala^0] ', {0, 0, 0}, "^*CODE 0:^*^7 " .. name .. " | ^*^1Ulica ^*^7" .. Officer.Location)

	CreateThread(function()
		local Blip = AddBlipForCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
		SetBlipSprite (Blip, 378)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 1.0)
		SetBlipColour (Blip, 3)
		SetBlipAsShortRange(Blip, false)
		SetBlipCategory(Blip, 14)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("[CODE 0] " .. name)
		EndTextCommandSetBlipName(Blip)
		Wait(90000)
		RemoveBlip(Blip)
		Blip = nil
	end)
end)

local allow = {
	allow = false,
	job = false,
	item = false
}

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if ESX.PlayerData and ESX.PlayerData.inventory then
		CreateThread(function()
			if ESX.PlayerData.inventory ~= nil then
				local found = false
				for i = 1, #ESX.PlayerData.inventory, 1 do
					if ESX.PlayerData.inventory[i].name == item.name then
						ESX.PlayerData.inventory[i] = item
						found = true
						break
					end
				end
				
				if not found then
					ESX.TriggerServerCallback('esx:isValidItem', function(status)
						if status then
							table.insert(ESX.PlayerData.inventory, item)
						end
					end, item.name)			
				end
			end
		end)
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if ESX.PlayerData and ESX.PlayerData.inventory then
		CreateThread(function()
			if ESX.PlayerData.inventory ~= nil then
				local found = false
				for i = 1, #ESX.PlayerData.inventory, 1 do
					if ESX.PlayerData.inventory[i].name == item.name then
						ESX.PlayerData.inventory[i] = item
						found = true
						break
					end
				end
				
				if not found then
					ESX.TriggerServerCallback('esx:isValidItem', function(status)
						if status then
							table.insert(ESX.PlayerData.inventory, item)
						end
					end, item.name)
				end
			end
		end)
	end
end)

CreateThread(function()
	while true do
		Wait(500)
		if ESX.PlayerData and ESX.PlayerData.job and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') and ESX.PlayerData.inventory ~= nil then
			allow.job, allow.item = true, false
			for i = 1, #ESX.PlayerData.inventory, 1 do
				if ESX.PlayerData.inventory[i].name == 'radio' and ESX.PlayerData.inventory[i].count > 0 then
					allow.item = true
				end
			end
			
			allow.allow = not (exports['stinky_trunk']:checkInTrunk() or exports['esx_policejob']:IsCuffed())
		else
			Wait(2000)
			allow.job, allow.item = false, false
		end
	end
end)

local radioPressed = false

RegisterCommand('+radiopd', function()
	if exports['esx_ambulancejob']:isDead() then return end
	if exports['esx_policejob']:IsCuffed() then return end

	if allow.job and allow.item and allow.allow then
		if not radioPressed then
			radioPressed = true
			if not IsPlayerFreeAiming(playerId) then
				TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
				TaskPlayAnim(PlayerPedId(), "amb@code_human_police_investigate@idle_a", "idle_b", 8.0, -8, -1, 49, 0, 0, 0, 0 )
				SetEnableHandcuffs(PlayerPedId(), true)
				SetCurrentPedWeapon(PlayerPedId(), `GENERIC_RADIO_CHATTER`, true)
			elseif IsPlayerFreeAiming(playerId) then
				TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
				TaskPlayAnim(PlayerPedId(), "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
				SetEnableHandcuffs(PlayerPedId(), true)
				SetCurrentPedWeapon(PlayerPedId(), `GENERIC_RADIO_CHATTER`, true)
			end 
			CreateThread(function()
				while radioPressed do
					Wait(0)
					if IsEntityPlayingAnim(GetPlayerPed(playerId), "random@arrests", "generic_radio_enter", 3) then
						DisableActions()
					elseif IsEntityPlayingAnim(GetPlayerPed(playerId), "random@arrests", "radio_chatter", 3) then
						DisableActions()
					end
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiopd', function()
	if exports['esx_ambulancejob']:isDead() then return end
	if allow.job and allow.item and allow.allow then
		if radioPressed then
			radioPressed = false
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
			ClearPedTasks(PlayerPedId())
			SetEnableHandcuffs(PlayerPedId(), false)
			SetCurrentPedWeapon(PlayerPedId(), `GENERIC_RADIO_CHATTER`, true)
		end
	end
end, false)

RegisterKeyMapping('+radiopd', 'Animacja mówienia na radiu (SASP/SASD/SAMS)', 'keyboard', 'M')

function DisableActions()
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisablePlayerFiring(PlayerPedId(), true)
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Wait( 0 )
	end
end

local kask = false

RegisterNetEvent('tmsn701:kask')
AddEventHandler('tmsn701:kask', function(item, count)
	local chlop = {['helmet_1'] = 39, ['helmet_2'] = 0}
	local baba = {['helmet_1'] = 114, ['helmet_2'] = 0}

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, chlop)
		else
			TriggerEvent('skinchanger:loadClothes', skin, baba)
		end
	end)
	kask = true
	while not isDead do
		Wait(1000)
	end

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, {['helmet_1'] = -1, ['helmet_2'] = 0})
	end)
	kask = false
end)

function KaskOnHead()
	return kask
end
local death = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local a = playerPed
		if not isDead and not kask then
			local b, boneIndex = GetPedLastDamageBone(a)
			if boneIndex == 39317 or boneIndex == 25260 or boneIndex == 27474 or boneIndex == 35731 or boneIndex == 19336 or boneIndex == 31086 then
				for d, e in pairs(modifieddmg) do
					if HasEntityBeenDamagedByWeapon(a, e.weapon, 0) then
						-- ESX.TriggerServerCallback("testdmg", function(f)
							-- Citizen.Wait(110)
							-- if f and f <= 70.0 then
								if death == false then
									ApplyDamageToPed(a, 300, 1)
									death = true
								end
								Citizen.Wait(500)
								death = false
							-- end
						-- end)
					end
				end
			end
		end
		ClearEntityLastDamageEntity(a)
	end
end)