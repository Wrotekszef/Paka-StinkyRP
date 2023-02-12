RegisterServerEvent("LSC:accept")
AddEventHandler("LSC:accept", function(name, button)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if button.price then
		if button.price <= xPlayer.getMoney() then
			TriggerClientEvent("LSC:accept", source, name, button)
			if xPlayer.job.name == 'gheneraugarage' then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
					local hajs = math.floor((button.price / 100) * 50)
					account.addAccountMoney(hajs)
				end)
			elseif xPlayer.job.name == 'mechanik' then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
					local hajs = math.floor((button.price / 100) * 50)
					account.addAccountMoney(hajs)
				end)
			end
			xPlayer.removeMoney(button.price)
			xPlayer.showNotification("Zapłacono: $"..button.price.." za zakup modyfikacji.")
		else
			TriggerClientEvent("LSC:cancel", source, name, xPlayer.getMoney() - button.price)
		end
	end
end)

RegisterServerEvent('LSC:refreshOwnedVehicle')
AddEventHandler('LSC:refreshOwnedVehicle', function(myCar)
	MySQL.update('UPDATE `owned_vehicles` SET `vehicle` = ? WHERE `plate` = ?', {myCar.plate,json.encode(myCar)})
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model
	local mods = veh.mods
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehiclePrice', function(source, cb, model)
	MySQL.query('SELECT price FROM vehicles WHERE model = ?', { model}, function(result)
		if result[1] ~= nil then			
			cb(result[1].price)
		else
			cb(2000000)
		end
	end)
end)