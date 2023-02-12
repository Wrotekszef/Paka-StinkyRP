local TimeElapsed = 0
local Timer = Config.lockTimer * 1000
local LockTask = false
local EngineStatus = false
local Ped = {
	Exists = false,
	Id = nil,
	InVehicle = false,
	VehicleInFront = nil,
	VehicleInFrontLock = nil
}
local inVeh = false
local vehPlate
local hasKM = 0
local showKM = 0

RegisterKeyMapping('-silnik', 'Włącz/wyłącz silnik', 'keyboard', 'Y')
RegisterCommand('-silnik', function(source, args, rawCommand)
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() then
		EngineToggle(Ped.Id)
		EngineStatus = true
		TimeElapsed = 0
	end
end, false)

RegisterKeyMapping('kluczyki', 'Zamknij/otwórz pojazd', 'keyboard', 'U')
RegisterCommand('kluczyki', function(source, args, rawCommand)
	if  not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() then
		LockSystem(Ped.Id)
		TimeElapsed = 0
	end
end, false)

RegisterKeyMapping('-keysmenu', 'Zamknij/otwórz auto zdalnie', 'keyboard', 'F9')
local timer = GetGameTimer()
RegisterCommand('-keysmenu', function(source, args, rawCommand)
	print(timer)
	print(GetGameTimer())
	print((GetGameTimer() - timer) )
	if (GetGameTimer() - timer) < 1000 then 
		ESX.ShowNotification('~r~Nie możesz tak często wyciągać kluczy!') 
		return 
	end
	timer = GetGameTimer()
	if not exports['esx_policejob']:IsCuffed() then
		GetKeysList()
	end
end)

CreateThread(function()
	while true do
		Wait(250)

		TimeElapsed = TimeElapsed + 200
		if not IsPauseMenuActive() then
			local ped = PlayerPedId()
			if not IsEntityDead(ped) then
				Ped.Exists = true
				Ped.Id = ped

				Ped.InVehicle = IsPedInAnyVehicle(Ped.Id, false)
				if not Ped.InVehicle then
					Ped.VehicleInFront = ESX.Game.GetVehicleInDirection(0.0, 20.0, -0.95)
					if Ped.VehicleInFront then
						Ped.VehicleInFrontLock = GetVehicleDoorLockStatus(Ped.VehicleInFront)
					else
						Ped.VehicleInFrontLock = nil
					end
				else
					Ped.VehicleInFront = nil
					Ped.VehicleInFrontLock = nil
				end

				if not Ped.VehicleInFront or Ped.VehicleInFrontLock > 1 then
					if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_menu') then
						ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_menu')
					end

					if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_doors_menu') then
						ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_doors_menu')
					end
				end
			else
				Ped.Exists = false
			end
		else
			Ped.Exists = false
		end
	end
end)

RegisterKeyMapping('-carmenu', 'Otwórz menu pojazdu', 'keyboard', 'H')
RegisterCommand('-carmenu', function(source, args, rawCommand)
	if Ped.Exists then
		if Ped.VehicleInFront and Ped.VehicleInFrontLock < 2 then
			if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_menu') then
				ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_menu')
			end

			if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_doors_menu') then
				ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_doors_menu')
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_menu', {
				title	= 'Pojazd',
				align	= 'bottom-right',
				elements = {
					{label = 'Wejdź do bagażnika', value = 'hide'},
					{label = 'Wyjdź z bagażnika', value = 'wyjdz'},
					{label = 'Otwórz / zamknij maskę', value = 'hood'},
					{label = 'Otwórz / zamknij drzwi', value = 'doors'},
					{label = 'Otwórz / zamknij bagażnik', value = 'trunk'}
				}
			}, function(data, menu)
				local action = data.current.value
				if action == 'hood' then
					OpenDoor(4)
				elseif action == 'trunk' then
					OpenDoor(5)
				elseif action == 'doors' then
					menu.close()
					CarDoorsMenu(menu)
				elseif action == 'hide' then
					menu.close()
					if Dragging then
						TriggerServerEvent('esx_policejob:drag', Dragging)
					end

					TriggerEvent('exile:forceInTrunk', GetPlayerServerId(PlayerId()))
				elseif action == 'wyjdz' then
					menu.close()

					TriggerEvent('exile:forceOutTrunk', GetPlayerServerId(PlayerId()))
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end
end, false)

CreateThread(function()
	while true do
		Wait(2)
		if Ped.Exists then
			if Ped.InVehicle then
				if IsControlPressed(2, 75) then
					if GetVehiclePedIsIn(Ped.Id) and DoesEntityExist(GetVehiclePedIsIn(Ped.Id)) then
						local engine = GetIsVehicleEngineRunning(GetVehiclePedIsIn(Ped.Id))
						repeat
							Wait(0)
							if engine then
								SetVehicleEngineOn(GetVehiclePedIsIn(Ped.Id), true, true, true)
							end
						until not IsPedInAnyVehicle(Ped.Id, false)
					end
				end
				if EngineStatus == false then
					SetVehicleEngineOn(GetVehiclePedIsIn(Ped.Id, false, false, true))
				end
				if EngineStatus == false then
					SetVehicleEngineOn(GetVehiclePedIsIn(Ped.Id, false), false, false, true)
					EngineStatus = true
				end
			else
				Wait(500)
			end
		else
			Wait(500)
		end
	end
end)

local doors = {
	--["seat_dside_f"] = -1,
	["seat_pside_f"] = 0,
	["seat_dside_r"] = 1,
	["seat_pside_r"] = 2
}
CreateThread(function()
	while true do
		Wait(2)
		if Ped.Exists then
			if Ped.VehicleInFront then
				DisableControlAction(0, 47, true)
				if IsDisabledControlJustPressed(0, 47) then
					local doorDistances = {}
					for bone, seat in pairs(doors) do
						local doorBone = GetEntityBoneIndexByName(Ped.VehicleInFront, bone)
						if doorBone ~= -1 then
							local coords = GetEntityCoords(Ped.Id, true)
							local doorCoords = GetWorldPositionOfEntityBone(Ped.VehicleInFront, doorBone)
							table.insert(doorDistances, {seat = seat, distance = #(coords - doorCoords)})
						end
					end
					local seat, distance
					if #doorDistances > 0 then
						seat = doorDistances[1].seat
						distance = doorDistances[1].distance

						table.remove(doorDistances, 1)
						for _, data in ipairs(doorDistances) do
							if data.distance < distance then
								seat, distance = data.seat, data.distance
							end
						end
					end
					if seat then
						TaskEnterVehicle(Ped.Id, Ped.VehicleInFront, -1, seat, 1.0, 1, 0)
					end
				end
			else
				Wait(333)
			end
		else
			Wait(500)
		end
	end
end)


function EngineToggle(playerPed)
	if TimeElapsed < Timer then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
		local plate = GetVehicleNumberPlateText(vehicle)
		if type(plate) == 'string' then
			plate = plate:gsub("%s$", "")
		end

		local status = IsVehicleEngineOn(vehicle)
		
		if not status then
			ESX.TriggerServerCallback('ls:hasKey', function(hasKey)
				if hasKey then
					SetVehicleEngineOn(vehicle, true, false, true)
					ESX.ShowAdvancedNotification('StinkyRP', "Silnik włączony", '~y~Nr rej.~s~: ' ..plate)
				else
					SetVehicleNeedsToBeHotwired(vehicle, true)
					ESX.ShowAdvancedNotification('StinkyRP', "Włączanie silnika...", '~y~Nr rej.~s~: ' ..plate)
				end
			end, plate)
		else
			SetVehicleEngineOn(vehicle, false, false, true)
			ESX.ShowAdvancedNotification('StinkyRP', "Silnik wyłączony", '~y~Nr rej.~s~: ' ..plate)	
		end
	end
end

function LockSystem(playerPed)
	-- if TimeElapsed < Timer and not LockTask then
	-- 	return
	-- end
	
	local vehicle, isInside = nil, false
	if Ped.InVehicle then
		vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle and (vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed) then
			vehicle = nil
		end

		isInside = true
	else
		vehicle = ESX.Game.GetVehicleInDirection(0.0, 20.0, -0.95)
	end
	
	if vehicle and DoesEntityExist(vehicle) then
		LockTask = true
		ClearPedTasks(playerPed)	
		local plate = GetVehicleNumberPlateText(vehicle, true)
		if type(plate) == 'string' then
			plate = plate:gsub("%s$", "")
		end
		
		local lockStatus = GetVehicleDoorLockStatus(vehicle)
		ESX.TriggerServerCallback('ls:check', function(hasKey, isOwned, isLocked)
			LockTask = false
			if hasKey then
				LockTask = true
				CreateThread(function()
					local id = NetworkGetNetworkIdFromEntity(vehicle)
					SetNetworkIdCanMigrate(id, false)

					local tries = 0
					while not NetworkHasControlOfNetworkId(id) and tries < 10 do
						tries = tries + 1
						NetworkRequestControlOfNetworkId(id)
						Wait(100)
					end

					if lockStatus < 2 then
						SetVehicleDoorsLocked(vehicle, 4)
						SetVehicleDoorsLockedForAllPlayers(vehicle, true)
						SetVehicleDoorsShut(vehicle, false)

						SetVehicleAlarm(vehicle, true)
						if not Ped.InVehicle then
							SetVehicleInteriorlight(vehicle, false)
						end
						
						ESX.ShowAdvancedNotification('StinkyRP', "Pojazd ~r~Zamknięty", '~y~Nr rej.~s~: ' ..plate, 2000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'lock', 0.3)
						if not IsPedInAnyVehicle(playerPed, true) then
							CreateThread(function()
								RequestAnimDict("gestures@m@standing@casual")
								while not HasAnimDictLoaded("gestures@m@standing@casual") do
									Wait(0)
								end

								TaskPlayAnim(playerPed, "gestures@m@standing@casual", "gesture_you_soft", 3.0, 1.0, -1, 48, 0, 0, 0, 0)
							end)
						end
					elseif lockStatus > 1 then
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)

						SetVehicleAlarm(vehicle, false)
						if not Ped.InVehicle then
							SetVehicleInteriorlight(vehicle, true)
						end

						ESX.ShowAdvancedNotification('StinkyRP', "Pojazd ~g~Otwarty", '~y~Nr rej.~s~: ' ..plate, 2000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'unlock', 0.3)
						if not IsPedInAnyVehicle(playerPed, true) then
							CreateThread(function()
								RequestAnimDict("gestures@m@standing@casual")
								while not HasAnimDictLoaded("gestures@m@standing@casual") do
									Wait(0)
								end

								TaskPlayAnim(playerPed, "gestures@m@standing@casual", "gesture_you_soft", 3.0, 1.0, -1, 48, 0, 0, 0, 0)
							end)
						end
					end

					if not Ped.InVehicle then
						CreateThread(function() 
							SetVehicleLights(vehicle, 2)
							SetVehicleBrakeLights(vehicle, true)
							Wait(200)
	
							SetVehicleLights(vehicle, 0)
							SetVehicleBrakeLights(vehicle, false)
							Wait(200)
							
							SetVehicleLights(vehicle, 2)
							SetVehicleBrakeLights(vehicle, true)
							Wait(200)
	
							SetVehicleLights(vehicle, 0)
							SetVehicleBrakeLights(vehicle, false)
						end)
					end

					SetNetworkIdCanMigrate(id, true)
					LockTask = false
				end)
			elseif not isInside then
				--
			elseif isOwned or isLocked then
				ESX.ShowAdvancedNotification('StinkyRP', "Ten pojazd nie należy do Ciebie", '~y~Nr rej.~s~: ' ..plate)
			elseif GetRandomIntInRange(1, 100) < Config.percentage then
				TriggerServerEvent('ls:addOwner', plate)
				ESX.ShowAdvancedNotification('StinkyRP', RandomMessages[GetRandomIntInRange(1, #RandomMessages)], '~y~Nr rej.~s~: ' ..plate)
			else
				TriggerServerEvent("ls:lockTheVehicle", plate)
				ESX.ShowAdvancedNotification('StinkyRP', "Niestety nie znalazłeś kluczy", '~y~Nr rej.~s~: ' ..plate)
			end
		end, plate)
	end
end

RegisterNetEvent('ls:notify')
AddEventHandler('ls:notify', function(label, text)
	if not text then
		text = ''
	end
	
	if not label then
		label = ''
	end
	
	ESX.ShowAdvancedNotification('StinkyRP', label, text)
end)

function LockCar(vehicle, plate) 
	local playerPed = Ped.Id
	local lockStatus = GetVehicleDoorLockStatus(vehicle)
	CreateThread(function()
		LockTask = true
		local id = NetworkGetNetworkIdFromEntity(vehicle)
		SetNetworkIdCanMigrate(id, false)

		local tries = 0
		while not NetworkHasControlOfNetworkId(id) and tries < 10 do
			tries = tries + 1
			NetworkRequestControlOfNetworkId(id)
			Wait(100)
		end

		if lockStatus < 2 then
			SetVehicleDoorsLocked(vehicle, 4)
			SetVehicleDoorsLockedForAllPlayers(vehicle, true)
			SetVehicleDoorsShut(vehicle, false)

			SetVehicleAlarm(vehicle, true)
			if not Ped.InVehicle then
				SetVehicleInteriorlight(vehicle, false)
			end
			
			ESX.ShowAdvancedNotification('StinkyRP', "Pojazd ~r~Zamknięty", '~y~Nr rej.~s~: ' ..plate, 2000)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'lock', 0.3)
			if not IsPedInAnyVehicle(playerPed, true) then
				CreateThread(function()
					RequestAnimDict("gestures@m@standing@casual")
					while not HasAnimDictLoaded("gestures@m@standing@casual") do
						Wait(0)
					end

					TaskPlayAnim(playerPed, "gestures@m@standing@casual", "gesture_you_soft", 3.0, 1.0, -1, 48, 0, 0, 0, 0)
				end)
			end
		elseif lockStatus > 1 then
			SetVehicleDoorsLocked(vehicle, 1)
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)

			SetVehicleAlarm(vehicle, false)
			if not Ped.InVehicle then
				SetVehicleInteriorlight(vehicle, true)
			end

			ESX.ShowAdvancedNotification('StinkyRP', "Pojazd ~g~Otwarty", '~y~Nr rej.~s~: ' ..plate, 2000)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'unlock', 0.3)
			if not IsPedInAnyVehicle(playerPed, true) then
				CreateThread(function()
					RequestAnimDict("gestures@m@standing@casual")
					while not HasAnimDictLoaded("gestures@m@standing@casual") do
						Wait(0)
					end

					TaskPlayAnim(playerPed, "gestures@m@standing@casual", "gesture_you_soft", 3.0, 1.0, -1, 48, 0, 0, 0, 0)
				end)
			end
		end

		if not Ped.InVehicle then
			CreateThread(function() 
				SetVehicleLights(vehicle, 2)
				SetVehicleBrakeLights(vehicle, true)
				Wait(200)

				SetVehicleLights(vehicle, 0)
				SetVehicleBrakeLights(vehicle, false)
				Wait(200)
				
				SetVehicleLights(vehicle, 2)
				SetVehicleBrakeLights(vehicle, true)
				Wait(200)

				SetVehicleLights(vehicle, 0)
				SetVehicleBrakeLights(vehicle, false)
			end)
		end

		SetNetworkIdCanMigrate(id, true)
		LockTask = false
	end)
end

local lastBlock = 0

function GetKeysList() 
	local now = GetGameTimer()
	if now > lastBlock then
		ESX.TriggerServerCallback("exilerp_scripts:getPrivatesKeys", function(cb) 
			if #cb > 0 then
				local vehs = ESX.Game.GetVehiclesInArea(GetEntityCoords(Ped.Id), 75.0)
				local z = {}
				local keys = {}
				local elements = {}
				for a,b in pairs(vehs) do
					local plate = GetVehicleNumberPlateText(b)
					table.insert(z, {veh=b, plate=plate:gsub(" ", "-")})
				end
				local hasdas = {}
				for c,d in pairs(cb) do
					for e,f in pairs(z) do
						if not hasdas[string.lower(f.plate)] then
							if string.lower(f.plate) == string.lower(d.plate:gsub(" ", "-")) then
								hasdas[string.lower(f.plate)] = true
								local str = '<span style="color: green">Otwarty</span>'
								if GetVehicleDoorLockStatus(f.veh) > 2 then
									str = '<span style="color: red">Zamknięty</span>'
								end
								table.insert(keys, f)
								table.insert(elements, {label = string.upper(f.plate):gsub("-", " ").." - "..str, value = string.upper(f.plate):gsub("-", " "), src = f.veh})
								goto dalej
							end
						end
					end
					::dalej::
				end
				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'keys_list',
					{
						title    = 'Klucze do aut',	
						align = "center",
						elements = elements
					},
					function(data, menu)
						LockCar(data.current.src, data.current.value)
						menu.close()
						GetKeysList()
					end,
					function(data, menu)
						menu.close()
					end
				)
			else
				ESX.ShowAdvancedNotification('StinkyRP', "Błąd", '~r~Nie masz żadnych kluczy!')
			end
		end)
		lastBlock = now + 5000
	else
		ESX.ShowNotification('~r~Musisz odczekać 5 sekund przed następnym użyciem')
	end
end

RegisterNetEvent('ls:dodajklucze')
AddEventHandler('ls:dodajklucze', function(localVehPlate)
	if type(localVehPlate) == 'string' then
		localVehPlate = localVehPlate:gsub("%s$", "")
	end
	TriggerServerEvent("ls:addOwner", localVehPlate)
end)

RegisterNetEvent('ls:dodajklucze2')
AddEventHandler('ls:dodajklucze2', function(localVehPlate)
	if type(localVehPlate) == 'string' then
		localVehPlate = localVehPlate:gsub("%s$", "")
	end
	TriggerServerEvent("ls:addOwner", localVehPlate)
end)

function CarDoorsMenu(parent)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_doors_menu', {
		title	= 'Pojazd - drzwi',
		align	= 'bottom-right',
		elements = {
			{label = 'Zamknij wszystkie drzwi', value = 'close'},
			{label = 'Lewy przód', value = 0},
			{label = 'Prawy przód', value = 1},
			{label = 'Lewy tył', value = 2},
			{label = 'Prawy tył', value = 3},
		}
	}, function(data, menu)
		local action = data.current.value
		if data.current.value == 'close' then
			CloseDoors()
		elseif data.current.value > -1 and data.current.value < 4 then
			OpenDoor(data.current.value)
		end
	end, function(data, menu)
		menu.close()
		parent.open()
	end)
end

function OpenDoor(id)
	if Ped.VehicleInFront and Ped.VehicleInFrontLock < 2 then
		if GetVehicleDoorAngleRatio(Ped.VehicleInFront, id) > 0 then
			SetVehicleDoorShut(Ped.VehicleInFront, id, false)
		else
			SetVehicleDoorOpen(Ped.VehicleInFront, id, false, false)
		end
	end
end

function CloseDoors()
	if Ped.VehicleInFront then
		for i = 0, 3 do
			SetVehicleDoorShut(Ped.VehicleInFront, i, false)
		end
	end
end