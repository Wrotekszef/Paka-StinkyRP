ESX.RegisterUsableItem('kamzasmall', function (source)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeInventoryItem('kamzasmall', 1)
	TriggerClientEvent('exile_kamza', src, 'small')
	TriggerClientEvent('esx:showNotification', src, "~y~Założono małą kamizelkę")
end)

ESX.RegisterUsableItem('kamzaduza', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('kamzaduza', 1)
	TriggerClientEvent('exile_kamza', source, 'big')
	TriggerClientEvent('esx:showNotification', source, "~y~Założono dużą kamizelkę")
end)

ESX.RegisterUsableItem('kamzasaspbigswat', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('kamzasaspbigswat', 1)
	TriggerClientEvent('exile_kamza', source, 'swat')
	TriggerClientEvent('esx:showNotification', source, "~y~Założono 100% kamizelkę")
end)


RegisterServerEvent("falszywyy_barylki:mieszacz")
AddEventHandler("falszywyy_barylki:mieszacz", function(es)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkziolo = xPlayer.getInventoryItem('weed_pooch').count >= 30
    local checkmetaamfetamina = xPlayer.getInventoryItem('meth_pooch').count >= 30
    local checkkokaina = xPlayer.getInventoryItem('coke_pooch').count >= 30
    local checkopium = xPlayer.getInventoryItem('opium_pooch').count >= 30
	local checkperico = xPlayer.getInventoryItem('cokeperico_pooch').count >= 30
	local checkog = xPlayer.getInventoryItem('oghaze_pooch').count >= 30
	if es == 'weed' then
		if checkziolo then 
			xPlayer.removeInventoryItem('weed_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji marihuany!')
			xPlayer.addInventoryItem('barylkaziola', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji marihuany!')
		end
	elseif es == 'meth' then
		if checkmetaamfetamina then 
			xPlayer.removeInventoryItem('meth_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji metaamfetaminy!')
			xPlayer.addInventoryItem('barylkametaamfetaminy', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji metaamfetaminy!')
		end
    elseif es == 'coke' then
		if checkkokaina then 
			xPlayer.removeInventoryItem('coke_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji kokainy!')
			xPlayer.addInventoryItem('barylkakokainy', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji kokainy!')
		end
    elseif es == 'opium' then
		if checkopium then 
			xPlayer.removeInventoryItem('opium_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji opium!')
			xPlayer.addInventoryItem('barylkaopium', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji opium!')
		end
	elseif es == 'cokeperico' then
		if checkperico then
			xPlayer.removeInventoryItem('cokeperico_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji kokainy perico!')
			xPlayer.addInventoryItem('barylkacokeperico', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji kokainy perico!')
		end
	elseif es == 'oghaze_pooch' then
		if checkog then
			xPlayer.removeInventoryItem('oghaze_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji OG Haze!')
			xPlayer.addInventoryItem('barylkaoghaze', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji OG Haze!')
		end
	end
end)

RegisterServerEvent('falszywyy_barylki:komunikat')
AddEventHandler('falszywyy_barylki:komunikat', function(text)
	local _source = source
	TriggerClientEvent("sendProximityMessageMe", -1, _source, _source, text)
	
	local color = {r = 112, g = 56, b = 128, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
end)

ESX.RegisterUsableItem('mieszacz', function(source)
	TriggerClientEvent('falszywyy_barylki:mieszaczmenu', source)
	Wait(1500)
end)

ESX.RegisterUsableItem('barylkaziola', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('barylkaziola', 1)
	TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę marihuany!')
	xPlayer.addInventoryItem('weed_pooch', 30)
end)

ESX.RegisterUsableItem('barylkametaamfetaminy', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('barylkametaamfetaminy', 1)
	TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę metaamfetaminy!')
	xPlayer.addInventoryItem('meth_pooch', 30)
end)

ESX.RegisterUsableItem('barylkakokainy', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('barylkakokainy', 1)
	TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę kokainy!')
	xPlayer.addInventoryItem('coke_pooch', 30)
end)

ESX.RegisterUsableItem('barylkaopium', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('barylkaopium', 1)
	TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę opium!')
	xPlayer.addInventoryItem('opium_pooch', 30)
end)

ESX.RegisterUsableItem('barylkacokeperico', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('barylkacokeperico', 1)
	TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę kokainy perico!')
	xPlayer.addInventoryItem('cokeperico_pooch', 30)
end)

ESX.RegisterUsableItem('barylkaoghaze', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('barylkaoghaze', 1)
	TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę OG Haze!')
	xPlayer.addInventoryItem('barylkaoghaze', 30)
end)