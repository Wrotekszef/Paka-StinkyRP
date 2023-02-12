RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_impound')
AddEventHandler('esx_impound', function(type, police)
	local playerPed = PlayerPedId()

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
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'sheriff' or ESX.Playerdata.job.name == 'gheneraugarage' then
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			if vehicleProps then
				ESX.TriggerServerCallback('esx_impound:checkVehicleOwner', function(data, model, owner)
					TriggerEvent('esx_vehicleshop:getVehicles', function(base)
						local name = GetDisplayNameFromVehicleModel(vehicleProps.model)
						if name ~= 'CARNOTFOUND' then				
							local found = false
							for _, veh in ipairs(base) do
								if (veh.name:len() > 0 and veh.name == name) or veh.model == name then
									name = veh.name
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
						end

						if data then
							if model.model == vehicleProps.model then
								if police == 'cos' then
									TriggerServerEvent('falszywyy_garages:addCarFromPoliceParking', vehicleProps.plate)
								elseif police == 'MECH' then
									TriggerServerEvent('falszywyy_garages:addCarFromPoliceParkingMECH', vehicleProps.plate)
								else
									TriggerServerEvent('falszywyy_garages:updateState', vehicleProps.plate)
								end
							end
						else
							data = {
								foundOwner = false
							}
						end

						if GetVehicleNumberPlateText(vehicle) == vehicleProps.plate then
							ESX.ShowAdvancedNotification('ExileRP', vehicleProps.plate, '~y~Pojazd: ~s~' .. name .. '\n~y~Własność: ~s~' .. (owner and owner or 'Brak danych'), 'CHAR_BANK_MAZE', 6000)
						else
							ESX.ShowAdvancedNotification('ExileRP', '~r~--------~s~', '~y~Pojazd: ~s~' .. name .. '\n~y~Własność: ~s~Brak danych', 'CHAR_BANK_MAZE', 6000)
						end
						
						ESX.Game.DeleteVehicle(vehicle)
					end)
				end, vehicleProps.plate)
			end
		end
	else
		ESX.ShowNotification('Nie znaleziono pojazdu, podejdź bliżej!!')
	end
end)