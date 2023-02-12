local CurrentZone = nil
local GUI                     = {}
GUI.Time                      = 0
local IsImpounding 			  = false
local onNui = false
local localVehPlate = ''

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
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

function SpawnTowedVehicle(plate)
	TriggerServerEvent('falszywyy_garages:updateState', plate)
end

function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openGarage = false})
	onNui = false
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
	SendNUIMessage({openList = false})
	ESX.UI.Menu.CloseAll()
	cb('ok')
	onNui = false
end)
-- NUI Callback Methods
RegisterNUICallback('pull', function(data, cb)
	if BusyspinnerIsOn() then
		return
	end
	SetNuiFocus(false)
	SendNUIMessage({openList = false})
	cb('ok')
	BeginTextCommandBusyspinnerOn("FMMC_PLYLOAD")
	EndTextCommandBusyspinnerOn(4)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	if data.action == 'garage' then
		local playerPed  = PlayerPedId()
		
		ESX.TriggerServerCallback('falszywyy_garages:checkIfVehicleIsOwned', function (owned)
			local coords = vector3(CurrentZone.x, CurrentZone.y, CurrentZone.z)
			if owned then
				local heading = nil
				if CurrentZone.h ~= nil then
					heading = CurrentZone.h
				else
					heading = GetEntityHeading(playerPed)
				end
				ESX.Game.SpawnVehicle(owned.model, coords, heading, function(veh)
					TaskWarpPedIntoVehicle(playerPed, veh, -1)
					ESX.Game.SetVehicleProperties(veh, owned)
					SetVehicleEngineHealth(veh, owned.engineHealth)
					SetVehicleBodyHealth(veh, owned.bodyHealth)
					TriggerServerEvent('falszywyy_garages:pullCar', owned)
					SetEntityAsMissionEntity(veh, true, true)
					SetVehicleHasBeenOwnedByPlayer(veh, true)
					localVehPlate = string.lower(GetVehicleNumberPlateText(veh))
					TriggerEvent('ls:dodajklucze2', localVehPlate)
					
					BusyspinnerOff()
				end)
				Wait(200)
				onNui = false
			else
				ESX.ShowNotification('~r~Nie udało się wyciągnąć pojazdu, spróbuj jeszcze raz')
				BusyspinnerOff()
			end
		end, data.plate)	
		
	elseif data.action == 'impound' then
		if IsImpounding == false then
			IsImpounding = true
			ESX.TriggerServerCallback('falszywyy_garages:checkMoney', function(hasMoney)
				if hasMoney == 1 then
					TriggerServerEvent('exile_garages:findVehicle', data.plate)
					exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Trwa poszukiwanie pojazdu...", "Garaż", "grey-10", 5, true)
					Wait(5000)
					IsImpounding = false
					SpawnTowedVehicle(data.plate)
					ESX.ShowNotification("Pojazd o numerze rejestracyjnym ~y~" .. data.plate .. "~w~ został ~g~odholowany")
				else
					IsImpounding = false
					local needed = 0
					if hasMoney == 2 then
						needed = 2500
					elseif hasMoney == 3 then
						needed = 5000
					elseif hasMoney == 4 then
						needed = 15000
					elseif hasMoney == 5 then
						needed = 30000
					end	
					ESX.ShowNotification("Potrzebujesz ~g~" .. needed .. "$~w~ aby ~y~odholować~w~ pojazd")
				end
			end, false)
		else
			ESX.ShowNotification('~b~Poczekaj aż odholujesz poprzedni pojazd')
		end
		BusyspinnerOff()
	elseif data.action == 'impoundpd' then
		local playerPed  = PlayerPedId()
		ESX.TriggerServerCallback('falszywyy_garages:checkVehProps', function(veh)
			local coords = GetEntityCoords(PlayerPedId())
			ESX.ShowNotification("~b~Trwa poszukiwanie pojazdu...")
			Wait(math.random(500, 4000))
			ESX.Game.SpawnVehicle(veh.model, coords, GetEntityHeading(PlayerPedId()), function(vehicle)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				ESX.Game.SetVehicleProperties(vehicle, veh)
				SetVehicleEngineHealth(vehicle, veh.engineHealth)
				SetVehicleBodyHealth(vehicle, veh.bodyHealth)
				TriggerServerEvent("falszywyy_garages:removeCarFromPoliceParking", data.plate)
				SetEntityAsMissionEntity(vehicle, true, true)
				SetVehicleHasBeenOwnedByPlayer(vehicle, true)
				BusyspinnerOff()
			end)
		end, data.plate)
	elseif data.action == 'parkingmech' then
		local playerPed  = PlayerPedId()
		ESX.TriggerServerCallback('falszywyy_garages:checkVehProps', function(veh)
			local coords = GetEntityCoords(PlayerPedId())
			ESX.ShowNotification("~b~Trwa poszukiwanie pojazdu...")
			Wait(math.random(500, 4000))
			ESX.Game.SpawnVehicle(veh.model, coords, GetEntityHeading(PlayerPedId()), function(vehicle)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				ESX.Game.SetVehicleProperties(vehicle, veh)
				SetVehicleEngineHealth(vehicle, veh.engineHealth)
				SetVehicleBodyHealth(vehicle, veh.bodyHealth)
				TriggerServerEvent("falszywyy_garages:removeCarFromPoliceParking2", data.plate)
				SetEntityAsMissionEntity(vehicle, true, true)
				SetVehicleHasBeenOwnedByPlayer(vehicle, true)
				BusyspinnerOff()
			end)
		end, data.plate)
	end
end)

RegisterNUICallback('impoundall', function(data, cb)
	if BusyspinnerIsOn() then
		return
	end
	SetNuiFocus(false)
	SendNUIMessage({openList = false})
	cb('ok')
	BeginTextCommandBusyspinnerOn("FMMC_PLYLOAD")
	EndTextCommandBusyspinnerOn(4)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	if IsImpounding == false then
		IsImpounding = true
		ESX.TriggerServerCallback('falszywyy_garages:checkMoney', function(hasMoney)
			if hasMoney == 1 then
				exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Odholowywanie...", "Garaż", "grey-10", 5, true)
				Wait(5000)
				TriggerServerEvent('exile_garages:findVehicleAll')
				IsImpounding = false
			else
				IsImpounding = false
				local needed = 0
				if hasMoney == 2 then
					needed = 2500
				elseif hasMoney == 3 then
					needed = 5000
				elseif hasMoney == 4 then
					needed = 15000
				elseif hasMoney == 5 then
					needed = 30000
				end	
				ESX.ShowNotification("Potrzebujesz ~g~" .. needed .. "$~w~ aby ~y~odholować~w~ pojazd")
			end
		end, true)
	else
		IsImpounding = false
		ESX.ShowNotification('~b~Poczekaj aż odholujesz poprzedni pojazd')
	end
	BusyspinnerOff()
end)

RegisterNetEvent('exile_garages:findVehicle')
AddEventHandler('exile_garages:findVehicle', function(plate, owner)
	if ESX then
        local vehicles = ESX.Game.GetVehicles()
        for _, vehicle in ipairs(vehicles) do
            local vehiclePlate = GetVehicleNumberPlateText(vehicle, true)
            if type(vehiclePlate) == 'string' then
                vehiclePlate = vehiclePlate:gsub("%s$", "")
				if vehiclePlate == plate then
					ESX.Game.DeleteVehicle(vehicle)
                    break
                end
            end
        end
    end
end)

CreateThread(function()
	Wait(1000)
	for i=1, #Config.Garage, 1 do
		if not Config.Garage[i].role and Config.Garage[i].blip then
			local blip = AddBlipForCoord(vector3(Config.Garage[i].x, Config.Garage[i].y, Config.Garage[i].z))

			SetBlipSprite (blip, Config.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.65)
			SetBlipColour (blip, Config.Colour)	
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Garaż publiczny')
			EndTextCommandSetBlipName(blip)
		end
	end	
	
	for i=1, #Config.Zones, 1 do
		if Config.Zones[i].blip then
			local blip = AddBlipForCoord(vector3(Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z))
			SetBlipSprite (blip, Config.Zones[i].sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.65)
			SetBlipColour (blip, Config.Zones[i].color)	
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Zones[i].blip)
			EndTextCommandSetBlipName(blip)
		end
	end

	for i=1, #Config.Harbors, 1 do
		if Config.Harbors[i].blip then
			local blip = AddBlipForCoord(vector3(Config.Harbors[i].x, Config.Harbors[i].y, Config.Harbors[i].z))

			SetBlipSprite (blip, Config.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.65)
			SetBlipColour (blip, Config.Colour2)	
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Port publiczny')
			EndTextCommandSetBlipName(blip)
		end
	end

	for i=1, #Config.Hangar, 1 do
		if Config.Hangar[i].blip then
			local blip = AddBlipForCoord(vector3(Config.Hangar[i].x, Config.Hangar[i].y, Config.Hangar[i].z))

			SetBlipSprite (blip, Config.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.65)
			SetBlipColour (blip, Config.Colour3)	
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Hangar publiczny')
			EndTextCommandSetBlipName(blip)
		end
	end
end)

RegisterNetEvent('falszywyy_garages:removeGarage')
AddEventHandler('falszywyy_garages:removeGarage', function(x,y,z)
	for i=1, #Config.Garage, 1 do
		if Config.Garage[i].x == x and Config.Garage[i].y == y and Config.Garage[i].z == z then
			table.remove(Config.Garage, i)
			break
		end
	end	
end)

RegisterNetEvent('falszywyy_garages:addNewGarage')
AddEventHandler('falszywyy_garages:addNewGarage', function(x,y,z)
	table.insert(Config.Garage, {x = x, y = y, z = z, h = 0.0, blip = false})
end)

CreateThread(function()
	Wait(2000)
	while true do
		Wait(5)
		local garage = FindClosestGarage()

		if (garage ~= nil) then
			if not garage.role then
				if garage.vdist < 3.5 and not onNui then
					ESX.ShowHelpNotification('~w~Naciśnij ~INPUT_CONTEXT~ aby skorzystać ~y~z garażu\n~w~Naciśnij ~INPUT_THROW_GRENADE~ aby sprawdzić ~y~stan pojazdów')

					if IsControlJustReleased(0, 51) then
						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							LeftCar()
							Wait(500)
						else		
							OpenGarage(garage)
							Wait(500)
						end
					elseif IsControlJustReleased(0, 58) then
						OpenStatusCheckMenu()
						Wait(500)
					end	
				end

				ESX.DrawBigMarker(vec3(garage.x, garage.y, garage.z-0.95))
			elseif garage.role then
				if ESX.PlayerData.job.name == garage.role or ESX.PlayerData.secondjob.name == garage.role or ESX.PlayerData.thirdjob.name == garage.role or string.sub(ESX.PlayerData.job.name, 4) == garage.role then
					if garage.vdist < 3.5 and not onNui then
						ESX.ShowHelpNotification('~w~Naciśnij ~INPUT_CONTEXT~ aby skorzystać ~y~z garażu\n~w~Naciśnij ~INPUT_THROW_GRENADE~ aby sprawdzić ~y~stan pojazdów')

						if IsControlJustReleased(0, 51) then
							if IsPedSittingInAnyVehicle(PlayerPedId()) then
								LeftCar()
								Wait(500)
							else
								OpenGarage(garage)
								Wait(500)
							end
						elseif IsControlJustReleased(0, 58) then
							OpenStatusCheckMenu()
							Wait(500)
						end	
					end

					ESX.DrawBigMarker(vec3(garage.x, garage.y, garage.z-0.95))
				end
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	Wait(2000)
	while true do
		Wait(5)
		local garage = FindClosestHarbor()

		if (garage ~= nil) then
			if garage.vdist < 3.5 then
				ESX.ShowHelpNotification('~w~Naciśnij ~INPUT_CONTEXT~ aby skorzystać ~y~z portu\n~w~Naciśnij ~INPUT_THROW_GRENADE~ aby sprawdzić ~y~stan pojazdów')

				if IsControlJustReleased(0, 51) then
					if IsPedSittingInAnyVehicle(PlayerPedId()) then
						LeftCar()
						Wait(500)
					else
						OpenHarbor(garage)
						Wait(500)
					end
				elseif IsControlJustReleased(0, 58) then
					OpenStatusCheckMenu()
					Wait(500)
				end	
			end

			ESX.DrawBigMarker(vec3(garage.x, garage.y, garage.z-0.95))
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	Wait(2000)
	while true do
		Wait(5)
		local garage = FindClosestHangar()

		if (garage ~= nil) then
			if garage.vdist < 3.5 then
				ESX.ShowHelpNotification('~w~Naciśnij ~INPUT_CONTEXT~ aby skorzystać ~y~z hangaru\n~w~Naciśnij ~INPUT_THROW_GRENADE~ aby sprawdzić ~y~stan pojazdów')

				if IsControlJustReleased(0, 51) then
					if IsPedSittingInAnyVehicle(PlayerPedId()) then
						LeftCar()
						Wait(500)
					else
						OpenHangar(garage)
						Wait(500)
					end
				elseif IsControlJustReleased(0, 58) then
					OpenStatusCheckMenu()
					Wait(500)
				end	
			end

			ESX.DrawBigMarker(vec3(garage.x, garage.y, garage.z-0.95))
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(5)
		local zone = FindClosestZone()

		if (zone ~= nil) then			
			if zone.marker == 1 then
				if zone.vdist < 2.5 then
					ESX.ShowHelpNotification(zone.label)
					if IsControlJustReleased(0, 51) then						
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							TriggerFunction(zone.name)
						end
					end
				end
				
				ESX.DrawMarker(vec3(zone.x, zone.y, zone.z))
				
			else
				if ESX.PlayerData.job ~= nil then
					if zone.name == "parkingmech" and (ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') then
						if zone.vdist < 3.5 then
							ESX.ShowHelpNotification(zone.label)
							if IsControlJustReleased(0, 51) then
								if zone.name == 'destroy' then
									if IsPedSittingInAnyVehicle(PlayerPedId()) then
										TriggerFunction(zone.name)
									end
								else
									if not IsPedSittingInAnyVehicle(PlayerPedId()) then
										TriggerFunction(zone.name)
									end
								end
							end
						end
						
						ESX.DrawBigMarker(vec3(zone.x, zone.y, zone.z-0.95))
					end
					if zone.name == 'impoundpd' and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
						if zone.vdist < 3.5 then
							ESX.ShowHelpNotification(zone.label)
							if IsControlJustReleased(0, 51) then
								if zone.name == 'destroy' then
									if IsPedSittingInAnyVehicle(PlayerPedId()) then
										TriggerFunction(zone.name)
									end
								else
									if not IsPedSittingInAnyVehicle(PlayerPedId()) then
										TriggerFunction(zone.name)
									end
								end
							end
						end
						
						ESX.DrawBigMarker(vec3(zone.x, zone.y, zone.z-0.95))
					end
				end
			end
		else
			Wait(1000)
		end
	end
end)

TriggerFunction = function(zone)
	if zone == 'impound' then
		OpenImpoundMenu()
	elseif zone == 'impoundpd' then
		OpenPoliceImpoundMenu()
	elseif zone == 'parkingmech' then
		OpenMechImpoundMenu()
	elseif zone == 'destroy' then
		StartDestroying()
	elseif zone == 'contractT' then
		OpenSellCarMenu()
	elseif zone == 'coowner' then
		OpenCoOwnerMenu()
	end
end

CreateThread(function()
	while true do
		UpdatePedCoords()
		Wait(250)
	end
end)

local playerPedCoords = vector3(0.0, 0.0, 0.0)

UpdatePedCoords = function()
	playerPedCoords = GetEntityCoords(PlayerPedId())
end

FindClosestGarage = function()
	for i=1, #Config.Garage, 1 do
		local distRayCast = #(playerPedCoords - vec3(Config.Garage[i].x, Config.Garage[i].y, Config.Garage[i].z))

		if distRayCast < 15.0 then
			Config.Garage[i].vdist = distRayCast
			return Config.Garage[i]
		end		
	end
end

FindClosestHarbor = function()
	for i=1, #Config.Harbors, 1 do
		local distRayCast = #(playerPedCoords - vec3(Config.Harbors[i].x, Config.Harbors[i].y, Config.Harbors[i].z))

		if distRayCast < 15.0 then
			Config.Harbors[i].vdist = distRayCast
			return Config.Harbors[i]
		end		
	end
end

FindClosestHangar = function()
	for i=1, #Config.Hangar, 1 do
		local distRayCast = #(playerPedCoords - vec3(Config.Hangar[i].x, Config.Hangar[i].y, Config.Hangar[i].z))

		if distRayCast < 15.0 then
			Config.Hangar[i].vdist = distRayCast
			return Config.Hangar[i]
		end		
	end
end

FindClosestZone = function()
	for i=1, #Config.Zones, 1 do
		
		local distRayCast = #(playerPedCoords - vec3(Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z))

		if distRayCast < 15.0 then
			Config.Zones[i].vdist = distRayCast
			return Config.Zones[i]
		end		
	end
end

function LeftCar()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	local vehProperties = ESX.Game.GetVehicleProperties(veh)
	if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
		ESX.TriggerServerCallback('falszywyy_garages:checkCar', function(kalbak)
			if kalbak == 1 or kalbak == 2 then
				TriggerServerEvent('falszywyy_garages:leftCar', vehProperties)
	
				while DoesEntityExist(veh) do
					Wait(10)
					DeleteEntity(veh)
				end
			elseif kalbak == false then
				ESX.ShowNotification('~r~Pojazd nie należy do Ciebie!')
			end
		end, vehProperties)
	else
		ESX.ShowNotification('~r~Musisz być kierowcą!')
	end
end


function OpenGarage(zone)	
	onNui = true
	SendNUIMessage({
		clear = true
	})
	ESX.TriggerServerCallback('falszywyy_garages:getVehicles', function(vehicles)
		for i=1, #vehicles, 1 do
			local name = GetDisplayNameFromVehicleModel(vehicles[i].model)
			TriggerEvent('esx_vehicleshop:getVehicles', function(base)
				local found = false
				
				for _, vehicle in ipairs(base) do
					if GetHashKey(vehicle.model) == vehicles[i].model then
						name = vehicle.name
						found = true
						break
					end
				end
			  
				if not found then
					local label = GetLabelText(name)
					if label ~= "NULL" then
						name = label
					end
				end
				local health = vehicles[i].engineHealth
				if health > 900 then
					health = health-100
				end
				SendNUIMessage({
					add = true,
					plate = vehicles[i].plate,
					name = name,
					engine = vehicles[i].engineHealth and math.floor(health/900 * 100) or '??',
					body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
				})							  
			end)
		end
		SetNuiFocus(true, true)
		SendNUIMessage({openList = true, listType = 'garage'})
		CurrentZone = zone
	end)
end

function OpenHarbor(zone)
	SendNUIMessage({
		clear = true
	})
	ESX.TriggerServerCallback('falszywyy_garages:getBoats', function(vehicles)
		for i=1, #vehicles, 1 do
			local name = GetDisplayNameFromVehicleModel(vehicles[i].model)
			TriggerEvent('esx_vehicleshop:getVehicles', function(base)
				local found = false
				
				for _, vehicle in ipairs(base) do
					if GetHashKey(vehicle.model) == vehicles[i].model then
						name = vehicle.name
						found = true
						break
					end
				end
			  
				if not found then
					local label = GetLabelText(name)
					if label ~= "NULL" then
						name = label
					end
				end

				SendNUIMessage({
					add = true,
					plate = vehicles[i].plate,
					name = name,
					engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
					body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
				})							  
			end)
		end
		
		SetNuiFocus(true, true)
		SendNUIMessage({openList = true, listType = 'garage'})
		CurrentZone = zone
	end)
end

function OpenHangar(zone)	
	SendNUIMessage({
		clear = true
	})
	ESX.TriggerServerCallback('falszywyy_garages:getPlanes', function(vehicles)
		for i=1, #vehicles, 1 do
			local name = GetDisplayNameFromVehicleModel(vehicles[i].model)
			TriggerEvent('esx_vehicleshop:getVehicles', function(base)
				local found = false
				
				for _, vehicle in ipairs(base) do
					if GetHashKey(vehicle.model) == vehicles[i].model then
						name = vehicle.name
						found = true
						break
					end
				end
			  
				if not found then
					local label = GetLabelText(name)
					if label ~= "NULL" then
						name = label
					end
				end

				SendNUIMessage({
					add = true,
					plate = vehicles[i].plate,
					name = name,
					engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
					body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
				})							  
			end)
		end
		
		SetNuiFocus(true, true)
		SendNUIMessage({openList = true, listType = 'garage'})
		CurrentZone = zone
	end)
end

function round(n)
    if not n then return 0; end
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

-------------------------------------------------------------------------niniger
function OpenImpoundMenu()
	SendNUIMessage({
		clear = true
	})
	ESX.TriggerServerCallback('falszywyy_garages:getVehiclesToTow', function(vehicles)
		for i=1, #vehicles, 1 do
			local name = GetDisplayNameFromVehicleModel(vehicles[i].model)
			TriggerEvent('esx_vehicleshop:getVehicles', function(base)
				local found = false

				for _, vehicle in ipairs(base) do
					if GetHashKey(vehicle.model) == vehicles[i].model then
						name = vehicle.name
						found = true
						break
					end
				end
			  
				if not found then
					local label = GetLabelText(name)
					if label ~= "NULL" then
						name = label
					end
				end

				SendNUIMessage({
					add = true,
					plate = vehicles[i].plate,
					name = name,
					engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
					body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
				})							  
			end)
		end
	end)
	SetNuiFocus(true, true)
	SendNUIMessage({openList = true, listType = 'impound'})
end

------------------------------------------------------------------------
function OpenCoOwnerMenu()
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'subowner_player',
		{
			title = "Tablica rejestracyjna",
			align = 'center'
		},
		function(data, menu)
			local plate = string.upper(tostring(data.value))
			ESX.TriggerServerCallback('falszywyy_garages:checkIfPlayerIsOwner', function(isOwner)
				if isOwner then
					menu.close()
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'subowner_menu',
						{
							title = "Zarządzanie pojazdem " .. plate,
							align = 'center',
							elements	= {
								{label = "Nadaj współwłaściciela", value = 'give_sub'},
								{label = "Usuń współwłaścicieli", value = 'manage_sub'},
								{label = "Zmień rejestrację", value = 'change_rej'},
							}
						},
						function(data2, menu2)
							if data2.current.value == 'give_sub' then
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								if closestPlayer ~= -1 and closestDistance <= 3.0 then
									menu2.close()
									TriggerServerEvent('falszywyy_garages:setSubowner', plate, GetPlayerServerId(closestPlayer))
								else
									ESX.ShowNotification("~r~Brak osób w pobliżu")
								end
							elseif data2.current.value == 'manage_sub' then
								local elements = {}
								ESX.TriggerServerCallback('falszywyy_garages:getSubOwners', function(dane, val)
									if dane ~= nil then
									table.insert(elements, {label = "[Pierwszy] "..dane.firstname.." "..dane.lastname, value = val.co_owner, h = 'first'})
									end
									ESX.TriggerServerCallback('falszywyy_garages:getSubOwners2', function(danes, vals)
										if danes ~= nil then
										table.insert(elements, {label = "[Drugi] "..danes.firstname.." "..danes.lastname, value = vals.co_owner2, h = 'second'})
										end
										ESX.TriggerServerCallback('falszywyy_garages:getSubOwners3', function(danet, valt)
											if danet ~= nil then
												table.insert(elements, {label = "[Trzeci] "..danet.firstname.." "..danet.lastname, value = valt.co_owner3, h = 'third'})
											end
										ESX.UI.Menu.Open(
											'default', GetCurrentResourceName(), 'yesorno',
											{
												title = "Wybierz współwłaściciela",
												align = 'center',
												elements = elements
											},
											function(data3, menu3)
												if data3.current.h == 'first' then
													TriggerServerEvent('falszywyy_garages:deleteSubowner', plate, data3.current.value)
												end
												if data3.current.h == 'second' then
													TriggerServerEvent('falszywyy_garages:deleteSubowner2', plate, data3.current.value)
												end
												if data3.current.h == 'third' then
													TriggerServerEvent('falszywyy_garages:deleteSubowner3', plate, data3.current.value)
												end
												menu3.close()
											end,
											function(data3, menu3)
												menu3.close()
											end)
										end, plate)
									end, plate)
								end, plate)
								
							elseif data2.current.value == 'change_rej' then
								local vehicles = ESX.Game.GetVehicles()
								local found = false
								for _, vehicle in ipairs(vehicles) do
									local vehiclePlate = GetVehicleNumberPlateText(vehicle, true)
									if type(vehiclePlate) == 'string' then
										vehiclePlate = vehiclePlate:gsub("%s$", "")
										if vehiclePlate == plate then
											found = true
											break
										end
									end
								end
								if found == true then
									ESX.ShowNotification('~r~Pojazd musi zostać schowany do garażu')
								else
									ESX.UI.Menu.Open(
										'dialog', GetCurrentResourceName(), 'rejestracja',
										{
											title = "Nowa rejestracja (8 znaków włącznie ze spacjami)",
											align = 'center'
										},
										function(data3, menu3)
											if string.len(data3.value) == 8 then
												local newPlate = string.upper(data3.value)
												ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
													if not isPlateTaken then
														menu3.close()
														menu2.close()
														TriggerServerEvent('falszywyy_garages:updatePlate', plate, newPlate)
													else
														ESX.ShowNotification('~r~Ta rejestracja jest już zajęta')
													end
												end, newPlate)
											else
												ESX.ShowNotification('~r~Nieodpowiednia długość tekstu nowej rejestracji')
											end
										end,
										function(data3,menu3)
											menu3.close()
										end
									)
								end
							end
						end,
						function(data2,menu2)
							menu2.close()
						end
					)
				else
					ESX.ShowNotification("~r~Nie jesteś właścicielem tego pojazdu!")
				end
			end, plate)
		end,
		function(data,menu)
			menu.close()
		end
	)
end
---------------------------------------------------------
function OpenSellCarMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'yesorno',
		{
			title = "Czy na pewno chcesz zakupić umowę za 15 000$?",
			align = 'center',
			elements = {
				{label = "Nie", value = 'no'},
				{label = "Tak", value = 'yes'}
			}
		},
		function(data, menu)
			if data.current.value == 'yes' then
				TriggerServerEvent('falszywyy_garages:buyContract')
				menu.close()
			elseif data.current.value == 'no' then
				menu.close()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end
---------------------------------------------------------
function OpenPoliceImpoundMenu(zone)
	SendNUIMessage({
		clear = true
	})
	ESX.TriggerServerCallback('falszywyy_garages:getTakedVehicles', function(vehicles)
		for i=1, #vehicles, 1 do
			local name = GetDisplayNameFromVehicleModel(vehicles[i].model)
			TriggerEvent('esx_vehicleshop:getVehicles', function(base)
				local found = false
			  
				for _, vehicle in ipairs(base) do
					if GetHashKey(vehicle.model) == vehicles[i].model then
						name = vehicle.name
						found = true
						break
					end
				end
			  
				if not found then
					local label = GetLabelText(name)
					if label ~= "NULL" then
						name = label
					end
				end

				SendNUIMessage({
					add = true,
					plate = vehicles[i].plate,
					name = name,
					engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
					body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
				})
			end)
		end
	end)
	CurrentZone = zone
	SetNuiFocus(true, true)
	SendNUIMessage({openList = true, listType = 'impoundpd'})
end

function OpenMechImpoundMenu(zone)
	SendNUIMessage({
		clear = true
	})
	ESX.TriggerServerCallback('falszywyy_garages:getTakedVehiclesMech', function(vehicles)
		for i=1, #vehicles, 1 do
			local name = GetDisplayNameFromVehicleModel(vehicles[i].model)
			TriggerEvent('esx_vehicleshop:getVehicles', function(base)
				local found = false
			  
				for _, vehicle in ipairs(base) do
					if GetHashKey(vehicle.model) == vehicles[i].model then
						name = vehicle.name
						found = true
						break
					end
				end
			  
				if not found then
					local label = GetLabelText(name)
					if label ~= "NULL" then
						name = label
					end
				end

				SendNUIMessage({
					add = true,
					plate = vehicles[i].plate,
					name = name,
					engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
					body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
				})
			end)
		end
	end)
	CurrentZone = zone
	SetNuiFocus(true, true)
	SendNUIMessage({openList = true, listType = 'impoundpd'})
end

RegisterNetEvent('esx_contract:getVehicle')
AddEventHandler('esx_contract:getVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and playerDistance <= 3.0 then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = #(coords - vehiclecoords)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			local vehProps = ESX.Game.GetVehicleProperties(vehicle)
			ESX.ShowNotification('Wypisywanie Kontraktu na samochod o numerach: '.. vehProps.plate)
			TriggerServerEvent('esx_clothes:sellVehicle', GetPlayerServerId(closestPlayer), vehProps.plate, vehProps.model)
		else
			ESX.ShowNotification('Nie ma samochodu w pobliżu')
		end
	else
		ESX.ShowNotification('Nie ma nikogo w pobliżu')
	end
	
end)

RegisterNetEvent('esx_contract:showAnim')
AddEventHandler('esx_contract:showAnim', function(player)
	loadAnimDict('anim@amb@nightclub@peds@')
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
	Wait(20000)
	ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function OpenStatusCheckMenu()
	local elements = {}
	ESX.TriggerServerCallback('falszywyy-vehstatus:getVehicles', function(vehicles)
		for _,v in pairs(vehicles) do
			local state = v.state
			local plate = v.plate
			local labelvehicle

			if state == 'stored' then
				labelvehicle = "W garażu"
			elseif state == 'pulledout' then
				labelvehicle = "Wyciągnięty"
			elseif state == 'policeParking' then
				labelvehicle = "Parking policyjny"
				elseif state == 'mechanicParking' then
				labelvehicle = "Parking mechaników"
			end
			
			ESX.ShowNotification('Rejestracja: ~b~'..plate.. '\n~w~Status: ~b~'..labelvehicle)
		end
	end)
end