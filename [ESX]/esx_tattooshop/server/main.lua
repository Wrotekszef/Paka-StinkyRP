AddEventHandler('esx:playerLoaded',function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if xPlayer.character.tattoos ~= nil then
			if xPlayer.character.tattoos ~= nil and xPlayer.character.tattoos ~= '' then
				TriggerClientEvent('esx_tattooshop:setTattoos', _source, json.decode(xPlayer.character.tattoos))
			else
				TriggerClientEvent('esx_tattooshop:setTattoos', _source, {})
			end			
		else
			TriggerClientEvent('esx_tattooshop:setTattoos', _source, {})
		end
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:getTattoos', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		if xPlayer.character.tattoos ~= nil and xPlayer.character.tattoos ~= '' then
			cb(json.decode(xPlayer.character.tattoos))
		else
			cb({})
		end
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		if xPlayer.character.tattoos ~= nil and xPlayer.character.tattoos ~= '' then
			cb(json.decode(xPlayer.character.tattoos))
		else
			cb({})
		end
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		table.insert(tattooList, tattoo)

		if xPlayer then
			if tattooList then
				MySQL.update('UPDATE users SET tattoos = ? WHERE identifier = ?', { json.encode(tattooList), xPlayer.identifier}, function()
					xPlayer.setCharacter('tattoos', json.encode(tattooList))
					TriggerClientEvent('esx:showNotification', source, _U('bought_tattoo', ESX.Math.GroupDigits(price)))
					cb(true)
				end)
			end
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', source, _U('not_enough_money', ESX.Math.GroupDigits(missingMoney)))
		cb(false)
	end
end)