AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_exileschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('esx_exileschool:licenseplayeradd')
AddEventHandler('esx_exileschool:licenseplayeradd', function(type)
	local _source = source

	if type == 'dmv' or type == 'theory_test' or type == 'drive' or type == 'drive_bike' or type == 'drive_truck' then
		TriggerEvent('esx_license:addLicense', _source, type, function()
			TriggerEvent('esx_license:getLicenses', _source, function(licenses)
				TriggerClientEvent('esx_exileschool:loadLicenses', _source, licenses)
			end)
		end)
	end
end)

RegisterNetEvent('esx_exileschool:pay')
AddEventHandler('esx_exileschool:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', price))
end)

RegisterNetEvent('esx_exileschool:reloadLicense')
AddEventHandler('esx_exileschool:reloadLicense', function()
	local _source = source
	TriggerEvent('esx_license:getLicenses', _source, function(licenses)
		TriggerClientEvent('esx_exileschool:loadLicenses', _source, licenses)
	end)
end)
