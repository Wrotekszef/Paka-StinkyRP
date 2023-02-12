RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

local hasAlreadyEnteredMarker, lastZone, currentAction, currentActionMsg
local Changed = {}
Plates              = {}

Plates.DrawDistance = 10.0
Plates.MarkerSize   = {x = 3.0, y = 3.0, z = 1.5}
Plates.MarkerColor  = {r = 0, g = 242, b = 96}
Plates.MarkerType   = 25
Plates.WaitTime 	= 30000

Plates.Zones = { 
    vector3(-1522.91, 98.03, 55.95),
}

AddEventHandler('exile-plates:hasEnteredMarker', function(zone)
	currentAction = 'plate_menu'
	currentActionMsg = 'Naciśnij ~INPUT_CONTEXT~ aby zmienić ~b~rejestracje pojazdu'
end)

AddEventHandler('exile-plates:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	currentAction = nil
end)

CreateThread(function()
	while ESX.PlayerData == nil do
		Wait(200)
	end
	while true do
		Wait(3)
		if ESX.PlayerData.thirdjob ~= nil then
			local playerCoords, isInMarker, currentZone, letSleep = GetEntityCoords(PlayerPedId()), false, nil, true

			for k,v in pairs(Plates.Zones) do
				local distance = #(playerCoords - v)

				if distance < Plates.DrawDistance then
					letSleep = false
					ESX.DrawBigMarker(vec3(v))
					if distance < Plates.MarkerSize.x then
						isInMarker, currentZone = true, k
					end
				end
			end

			if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
				hasAlreadyEnteredMarker, lastZone = true, currentZone
				TriggerEvent('exile-plates:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('exile-plates:hasExitedMarker', lastZone)
			end

			if letSleep then
				Wait(500)
			end
		else
			Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(3)

		if currentAction then
			ESX.ShowHelpNotification(currentActionMsg)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.thirdjob then
				if currentAction == 'plate_menu' then
					WybijBlachyMenu()
				end
				currentAction = nil
			end
		else
			Wait(1000)
		end
	end
end)

function WybijBlachyMenu()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local plate = GetVehicleNumberPlateText(vehicle)
		local carIndex = GetVehicleIndexFromEntityIndex(vehicle)
		if vehicle then
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'plates', {
				title = 'Wybić blachy? ' .. plate,
				align = 'center',
				elements = {
					{label = 'Tak', value = true},
					{label = 'Nie', value = false}
				}
			}, function(data, menu)
				menu.close()
				if data.current.value == true then
					exports["exile_taskbar"]:taskBar(30000, "Wybijanie blach", false, function(cb) 
						if cb then
							TriggerServerEvent("exilerp_temp:tempPlate", vehicle, plate)
							ESX.ShowNotification('~g~Blachy wrócą po schowaniu auta do garażu i jego odholowaniu')
						end
					end)

				end
			end, function(data, menu)
				menu.close()
			end)
		end
	else
		ESX.ShowNotification("~r~Musisz znajdować się w pojeździe!")
	end
end

RegisterNetEvent('exile-plates:buy')
AddEventHandler('exile-plates:buy', function(plate, index, vehicle)
	SetVehicleNumberPlateText(vehicle, " ")
	Changed[index] = true
	Wait(120 * Plates.WaitTime)
	TriggerServerEvent('exile-plates:delete', plate, vehicle, index)
	ESX.ShowNotification("~g~Wybite blachy odpadły!")
end)

RegisterNetEvent('exile-plates:delete')
AddEventHandler('exile-plates:delete', function(plate, vehicle, index)
	SetVehicleNumberPlateText(vehicle, plate)
	Changed[index] = false
end)
