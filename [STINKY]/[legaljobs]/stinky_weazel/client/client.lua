RegisterNetEvent("exile_weazel:getrequest")
TriggerServerEvent("exile_weazel:request")
AddEventHandler("exile_weazel:getrequest", function(a, b)
_G.donttouch = a
_G.exile_weazelsel = b
local donttouchme = _G.donttouch
local exile_weazelsell = _G.exile_weazelsel
	
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

local PlayerData              = {}
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local IsPlayerOnDuty = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local JobVehicle = nil
local TargetCoords            = nil
local CurrentlyTowedVehicle   = nil
local JobStarted = nil
local Blips                   = {}
local LastCancel = GetGameTimer() - 2 * 60000

ESX                           = nil
GUI.Time                      = 0

CreateThread(function()
    while ESX == nil do
        TriggerEvent('exile:getsharedobject', function(obj) 
			ESX = obj 
		end)
        
		Citizen.Wait(250)
    end
  
    Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob)
    PlayerData.secondjob = secondjob
end)

AddEventHandler('exile_weazel:hasEnteredMarker', function(zone, data)
	if zone == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby otworzyć panel zarządzania'
	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby otworzyć szatnię'
	elseif zone == 'VehicleActions' then
		CurrentAction     = 'menu_vehicle_actions'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ pobrać pojazd'
		CurrentActionData = data
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			if DoesEntityExist(vehicle) then
				CurrentAction     = 'menu_vehicle_deleter'
				CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ odstawić pojazd'
				CurrentActionData = data
				CurrentActionData.vehicle = vehicle
			end
		end
	elseif zone == 'JobZone' then
		CurrentAction     = 'job_zone'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ rozpocząc pracę'
	elseif zone == 'Printing' then
		CurrentAction     = 'printing'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ rozpocząc drukowanie'
	elseif zone == 'Sell' then
		CurrentAction     = 'sell'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ sprzedać gazety'
	end
end)

AddEventHandler('exile_weazel:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
        if PlayerData.secondjob ~= nil and PlayerData.secondjob.name == 'weazel' then
            local found = false

			local isInMarker  = false
			local currentZone = nil
			local currentData = nil

            local coords = GetEntityCoords(PlayerPedId())
            
            if #(coords - vec3(Config.BossActions.x, Config.BossActions.y, Config.BossActions.z)) < Config.DrawDistance then
                found = true
				
				ESX.DrawMarker(vec3(Config.BossActions.x, Config.BossActions.y, Config.BossActions.z))
			end
			
			for i=1, #Config.Cloakroom, 1 do
				if #(coords - vec3(Config.Cloakroom[i].coords.x, Config.Cloakroom[i].coords.y, Config.Cloakroom[i].coords.z)) < Config.DrawDistance then
					found = true
					
					ESX.DrawMarker(vec3(Config.Cloakroom[i].coords.x, Config.Cloakroom[i].coords.y, Config.Cloakroom[i].coords.z))
				end
			end
			
			for i, data in ipairs(Config.VehicleActions) do
                if #(coords - vec3(data.Spawner.x, data.Spawner.y, data.Spawner.z)) < Config.DrawDistance then
                    found = true
					
					ESX.DrawBigMarker(vec3(data.Spawner.x, data.Spawner.y, data.Spawner.z))
				end
			end

			for i, data in ipairs(Config.VehicleDeleters) do
                if #(coords - vec3(data.Spawner.x, data.Spawner.y, data.Spawner.z)) < Config.DrawDistance then
                    found = true
					
					ESX.DrawBigMarker(vec3(data.Spawner.x, data.Spawner.y, data.Spawner.z))
				end
			end

			--etap 1
			
			if JobStarted ~= nil then
				if JobStarted.start_point ~= nil then
					if #(GetEntityCoords(PlayerPedId()) - JobStarted.start_point) < 15.0 then
						found = true
						ESX.DrawBigMarker(JobStarted.start_point)
					end
				end
			end

			if JobStarted ~= nil then
				if JobStarted.start_point ~= nil then
					if #(coords - JobStarted.start_point) < 3.0 then
						isInMarker  = true
						currentZone = 'JobZone'
					end
				end
			end


			--etap 2
			
			if Config ~= nil then
				if Config.Printing ~= nil then
					if #(GetEntityCoords(PlayerPedId()) - Config.Printing) < 15.0 then
						found = true
						ESX.DrawBigMarker(Config.Printing)
					end
				end
			end

			if Config ~= nil then
				if Config.Printing ~= nil then
					if #(GetEntityCoords(PlayerPedId()) - Config.Printing) < 3.0 then
						isInMarker  = true
						currentZone = 'Printing'
					end
				end
			end

			--etap 3
			
			if Config ~= nil then
				if Config.EndPoint ~= nil then
					if #(GetEntityCoords(PlayerPedId()) - Config.EndPoint) < 15.0 then
						found = true
						ESX.DrawBigMarker(Config.EndPoint)
					end
				end
			end


			if Config ~= nil then
				if Config.EndPoint ~= nil then
					if #(GetEntityCoords(PlayerPedId()) - Config.EndPoint) < 3.0 then
						isInMarker  = true
						currentZone = 'Sell'
					end
				end
			end
			-----
    
			if #(coords - vec3(Config.BossActions.x, Config.BossActions.y, Config.BossActions.z)) < Config.MarkerSize.x then
				isInMarker  = true
				currentZone = 'BossActions'
			end
			
			for i=1, #Config.Cloakroom, 1 do
				if #(coords - vec3(Config.Cloakroom[i].coords.x, Config.Cloakroom[i].coords.y, Config.Cloakroom[i].coords.z)) < Config.MarkerSize.x then
					isInMarker  = true
					currentZone = 'Cloakroom'
				end
			end
			
			if not currentZone then
				for i, data in ipairs(Config.VehicleActions) do
					if #(coords - vec3(data.Spawner.x, data.Spawner.y, data.Spawner.z)) < Config.MarkerSize.x then
						isInMarker  = true
						currentZone = 'VehicleActions'
						currentData = data
						break
					end
				end

				if not currentZone then
					for i, data in ipairs(Config.VehicleDeleters) do
						if #(coords - vec3(data.Spawner.x, data.Spawner.y, data.Spawner.z)) < (Config.MarkerSize.x + 2.) then
							isInMarker  = true
							currentZone = 'VehicleDeleter'
							currentData = data
							break
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('exile_weazel:hasEnteredMarker', currentZone, currentData)
			end
			
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('exile_weazel:hasExitedMarker', LastZone)
            end
            
            if not found then
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.secondjob and PlayerData.secondjob.name == 'weazel' then
			if IsControlJustReleased(0, Keys['F6']) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'weazel_actions') then
				WeazelActionsMenu()
			end

			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)

				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, Keys['E']) then
					if CurrentAction == 'menu_vehicle_actions' then
						local elements = {}
						for _, vehicle in ipairs(Config.Vehicles) do
							if PlayerData.secondjob.grade >= vehicle.grade then
								table.insert(elements, vehicle)
							end
						end

						local save = CurrentActionData
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
							title	= 'Wybór pojazdu',
							align	= 'center',
							elements = elements
						}, function(data, menu)
							menu.close()
							ESX.Game.SpawnVehicle(data.current.model, GetEntityCoords(PlayerPedId()), 200, function(vehicle)
								JobVehicle = vehicle
								local playerPed, tick = PlayerPedId(), 20
								repeat
									TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
									tick = tick - 1
									Citizen.Wait(50)
								until IsPedInAnyVehicle(playerPed, false) or tick == 0
								SetVehicleMaxMods(vehicle, data.current.model, (data.current.livery or false), (data.current.offroad or false), (data.current.color or false), (data.current.extras or nil))
								local plate = "WEAZEL " .. math.random(1000,9999)
								SetVehicleNumberPlateText(vehicle, plate)
								TriggerServerEvent('ls:addOwner', plate, false)
								TriggerServerEvent('exile_weazel:insertPlayer', GetVehicleNumberPlateText(vehicle))
							end)
						end, function(data, menu)
							menu.close()
							CurrentAction	 = 'menu_vehicle_actions'
							CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ pobrać pojazd'
							CurrentActionData = save
						end)
					elseif CurrentAction == 'menu_vehicle_deleter' then
						if CurrentActionData.SpawnPoint then
						DoScreenFadeOut(800)
						while not IsScreenFadedOut() do
							Citizen.Wait(0)
						end
						end

						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						if CurrentActionData.SpawnPoint then
						ESX.Game.Teleport(PlayerPedId(), GetEntityCoords(PlayerPedId()), function()
							DoScreenFadeIn(800)
						end)
						end
					elseif CurrentAction == 'menu_boss_actions' then
						WeazelBossMenu()
					elseif CurrentAction == 'cloakroom' then
						OpenCloakroom()
					elseif CurrentAction == 'job_zone' then
						if not IsPedInAnyVehicle(PlayerPedId(), false) then
							StartPhoto()
						else
							ESX.ShowNotification("Aby rozpocząć ~r~zlecenie ~w~opuść ~r~pojazd")
						end
					elseif CurrentAction == 'printing' then
						if not IsPedInAnyVehicle(PlayerPedId(), false) then
							StartPrinting()
						else
							ESX.ShowNotification("Aby rozpocząć ~r~drukowanie ~w~opuść ~r~pojazd")
						end
					elseif CurrentAction == 'sell' then
						StartSelling()
					end

					CurrentAction = nil
				end
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

OpenCloakroom = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'Przebieralnia',
		align = 'center',
		elements = {
			{label = 'Ubrania robocze',     value = 'job_wear'},
			{label = 'Ubrania prywatne', value = 'citizen_wear'}
		}
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			if data.current.value == 'citizen_wear' then
				TriggerEvent('skinchanger:loadSkin', skin)
				-- USUWANIE BLIPOW PRZY PRZEBIERANIU
				RemoveBlip(blip_work)
				RemoveBlip(blip_printing)
				RemoveBlip(blip_end)
				
				if JobStarted ~= nil then
					CancelJob()
				end
			elseif data.current.value == 'job_wear' then
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.Male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.Female)
				end
				
				if JobStarted == nil then
					StartJob()
				end
			end
		end)

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

StartPhoto = function()
	FreezeEntityPosition(PlayerPedId(), true)
	RemoveBlip(blip_work)
	if not IsPedActiveInScenario(PlayerPedId()) then
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_PAPARAZZI", 0, false)
	end
	
	Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
	local camera = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, `prop_pap_camera_01`, false, false, false)
	if camera ~= 0 and camera ~= nil then
		SetEntityAsMissionEntity(camera, true, true)
		DeleteEntity(camera)
	end
	exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Przygotowywanie...", "Praca Legalna", "grey-10", 120, true)
	Wait(120000)
	TriggerServerEvent('exile_weazel:giveItem', 'photos', 100)
	FreezeEntityPosition(PlayerPedId(), false)
	ESX.ShowNotification('Zrobiono ~r~wystarczająco~w~ dużo zdjęć, udaj się do ~r~drukarni.')

end

StartPrinting = function()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'photos' then
			count = inventory[i].count
		end
	end
	if count >= 1 then
		FreezeEntityPosition(PlayerPedId(), true)
		RemoveBlip(blip_printing)
		ESX.Streaming.RequestAnimDict('gestures@m@standing@casual', function()
			TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@casual', 'gesture_easy_now', 8.0, -8.0, -1, 1, 0, false, false, false)
		end)
		ESX.ShowNotification('~r~Trwa drukowanie gazet...')
		Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
		exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Przygotowywanie...", "Praca Legalna", "grey-10", 120, true)
		Wait(120000)
		ESX.TriggerServerCallback('exile_weazel:changeToAnother', function(resultA)
			ESX.ShowNotification('~w~Wydrukowano ~r~'..resultA..' ~w~gazet z ~r~'..count..' ~w~zdjęć.')																					
		end, 'photos', 'gazeta', count)
		FreezeEntityPosition(PlayerPedId(), false)
		ESX.ShowNotification('Udaj się do ~r~siedziby ~w~aby sprzedać gazety')
	else
		ESX.ShowNotification('~r~Nie posiadasz żadnych zdjęć!')
	end
end

StartSelling = function()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'gazeta' then
			count = inventory[i].count
		end
	end
	if count == 20 then
		FreezeEntityPosition(PlayerPedId(), true)
		RemoveBlip(blip_end)
		ESX.Streaming.RequestAnimDict('gestures@m@standing@casual', function()
			TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@casual', 'gesture_easy_now', 8.0, -8.0, -1, 1, 0, false, false, false)
		end)
		ESX.ShowNotification('~r~Trwa sprzedawanie gazet...')
		exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Przygotowywanie...", "Praca Legalna", "grey-10", 120, true)
		Wait(120000)
		Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
		FreezeEntityPosition(PlayerPedId(), false)
		JobStarted = nil
		
		if JobStarted == nil then
			StartJob()
		end
		print(1)
		TriggerServerEvent(exile_weazelsell, donttouchme)
		print(2)
	else
		ESX.ShowNotification('~r~Nie posiadasz wymaganej liczby gazet (20)!')
	end
end

WeazelActionsMenu = function()
    ESX.UI.Menu.CloseAll()
	local elements = {
		{label = 'Kamera', value = 'cam'},
		{label = 'Mikrofon', value = 'mic'},
		{label = 'Mikrofon studyjny', value = 'bmic'},
		-- {label = "Rozpocznij/Zakończ pracę", value = 'start_job'}
	}

	if PlayerData.secondjob.grade >= 6 and IsPedInAnyVehicle(PlayerPedId(), false) then
		table.insert(elements, {label = 'Lista osób siedzących w tym pojeździe', value = 'checkcar'})
	end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weazel_actions', {
        title = 'Weazel News',
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
        menu.close()
        if data.current.value == 'cam' then
            TriggerEvent("Cam:ToggleCam")
        elseif data.current.value == 'mic' then
            TriggerEvent("Mic:ToggleMic")
        elseif data.current.value == 'bmic' then
			TriggerEvent("Mic:ToggleBMic")
		elseif data.current.value == 'checkcar' then
			local playerPed = PlayerPedId()
			local vehicle   = GetVehiclePedIsIn(playerPed, false)
			if IsVehicleModel(vehicle, 'weazelcar') then
				if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.TriggerServerCallback('exile_weazel:checkSiedzacy', function(siedzi)
						if siedzi then
							local elements = {}
							local plate =  GetVehicleNumberPlateText(vehicle)
							for i=1, #siedzi, 1 do
								if siedzi[i].plate == plate then
									table.insert(elements, {label = siedzi[i].label, value = siedzi[i].plate})	
								end
							end
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lastdriver_'..PlayerData.secondjob.name, {
								title    = "Lista kierowców ["..plate..']',
								align    = 'bottom-right',
								elements = elements
							}, function(data, menu)
							end, function(data, menu)
								menu.close()
							end)
						end
					end)
				else
					ESX.ShowNotification("~r~Musisz znajdować się w pojeździe jako kierwoca!")
				end
			else
				ESX.ShowNotification('~r~To nie auto firmowe!')
			end
		elseif data.current.value == 'start_job' then
			if JobStarted ~= nil then
				CancelJob()
			else
				if PlayerData.secondjob ~= nil and PlayerData.secondjob.name == 'weazel' then
					if (IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
						StartJob()
					else
						ESX.ShowNotification("~r~Musisz być w pojeździe służbowym, aby rozpocząć pracę")
					end
				end
			end
        end
    end, function(data, menu)
        menu.close()
    end)
end

WeazelBossMenu = function()
	local elements = {
		{label = "Akcje szefa", value = '1'},
    }
    if PlayerData.secondjob.grade >= 6 then
		table.insert(elements, {label = "Zarządzanie frakcją", value = '4'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weazel_boss', {
		title    =  PlayerData.secondjob.label,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.secondjob.grade >= 7 then
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'weazel', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			elseif PlayerData.secondjob.grade == 6 then
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'weazel', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true})
			else
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'weazel', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false})
            end
		elseif data.current.value == '4' then
			menu.close()
			exports['exile_legaljobs']:OpenLicensesMenu(PlayerData.secondjob.name)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'boss_actions'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć panel zarządzania"
		CurrentActionData = {}
	end)
end

SetVehicleMaxMods = function(vehicle, model, livery, offroad, color, extras)
	local mods = {
		bulletProofTyre = true,
		modTurbo		= true,
		modXenon		= true,
		dirtLevel	   = 0,
		modEngine	   = 3,
		modBrakes	   = 2,
		modTransmission = 2,
		modSuspension   = 3,
		extras		  = {1,1,1,1,1,1,1,1,1,1,1,1}
	}
	if offroad then
		mods.wheels = 4
		mods.modFrontWheels = 10
	end

	if color then
		if type(color) == 'table' then
			mods.color1 = color[1]
			mods.color2 = color[2]
		else
			mods.color1 = color
			mods.color2 = color
		end
	end

	mods.modArmor = 4
	if extras then
		for k, v in pairs(extras) do
			mods.extras[tonumber(k)] = tonumber(v)
		end
	end

	ESX.Game.SetVehicleProperties(vehicle, mods)
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end

CancelJob = function()
	if JobStarted ~= nil then
		if GetGameTimer() - LastCancel > 2 * 60000 then
			FreezeEntityPosition(JobVehicle, false)
			if DoesBlipExist(blip_work) then
				RemoveBlip(blip_work)
			elseif DoesBlipExist(blip_printing) then
				RemoveBlip(blip_printing)
			elseif DoesBlipExist(blip_end) then
				RemoveBlip(blip_end)
			end
			JobStarted = nil
			LastCancel = GetGameTimer()
		else
			ESX.ShowNotification("Odczekaj ~y~2 minuty~w~ przed następną ~r~anulacją pracy")
		end
	end
end

StartJob = function()
	if JobStarted == nil then
		CreateNewPlace('START')
	end
end

CreateNewPlace = function(state)
	if state == 'START' then
		JobStarted = {}
		math.randomseed(math.random(1000, 9999999999))
		JobStarted.start_point = Config.MissionLocations[math.random(1, #Config.MissionLocations)]

		--ETAP 1
		blip_work = AddBlipForCoord(vec3(JobStarted.start_point.x, JobStarted.start_point.y, JobStarted.start_point.z))
		SetBlipSprite(blip_work, 184)
		SetBlipColour(blip_work, 1)
		SetBlipDisplay(blip_work, 4)
		SetBlipAsShortRange(blip_work, false)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("#1 ~r~Zlecenie")
		EndTextCommandSetBlipName(blip_work)

		local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(JobStarted.start_point.x, JobStarted.start_point.y, JobStarted.start_point.z))
		ESX.ShowNotification("Witam, czy można podjechać na ulicę, "..street.." zrobić kilka ujęć?")
	end

	--ETAP 2
	blip_printing = AddBlipForCoord(vec3(Config.Printing.x, Config.Printing.y, Config.Printing.z))
	SetBlipSprite(blip_printing, 525)
	SetBlipColour(blip_printing, 1)
	SetBlipDisplay(blip_printing, 4)
	SetBlipAsShortRange(blip_printing, false)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("#2 ~r~Drukarnia")
	EndTextCommandSetBlipName(blip_printing)

	-- ETAP 3
	blip_end = AddBlipForCoord(vec3(Config.EndPoint.x, Config.EndPoint.y, Config.EndPoint.z))
	SetBlipSprite(blip_end, 500)
	SetBlipColour(blip_end, 1)
	SetBlipDisplay(blip_end, 4)
	SetBlipAsShortRange(blip_end, false)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("#3 ~r~Punkt dostawy gazet")
	EndTextCommandSetBlipName(blip_end)
end


end)