RegisterNetEvent('exile_magazine:getItem')
AddEventHandler('exile_magazine:getItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if type == 'item_standard' then
		TriggerEvent('esx_addoninventory:getInventory', 'exile_magazine', xPlayer.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)
			if count > 0 and inventoryItem.count >= count then
				if count > 0 and inventoryItem.count >= count then
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					exports['exile_logs']:SendLog(source, "Wyciągnięto przedmiot: "..xItem.label.."\nRespName: "..item.."\nIlość: x"..count, "schowek")
				else
					TriggerClientEvent("esx:showNotification", xPlayer.source, 'Nieprawidłowa ilość')
				end
			else
                TriggerClientEvent("esx:showNotification", xPlayer.source, 'Nieprawidłowa ilość')
			end
		end)
	elseif type == 'item_account' then
		TriggerEvent('esx_addonaccount:getAccount', 'exile_magazine_' .. item, xPlayer.identifier, function(account)
			if account.money >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
				exports['exile_logs']:SendLog(source, "testlog", "schowek")
			else
                TriggerClientEvent("esx:showNotification", xPlayer.source, 'Nieprawidłowa ilość')
			end
		end)
	end
end)

RegisterNetEvent('exile_magazine:putItem')
AddEventHandler('exile_magazine:putItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)
	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'exile_magazine', xPlayer.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				exports['exile_logs']:SendLog(source, "Włożono przedmiot: "..xItem.label.."\nRespName: "..item.."\nIlość: x"..count, "schowek")
			end)
		else
                TriggerClientEvent("esx:showNotification", xPlayer.source, 'Nieprawidłowa ilość')
		end
	elseif type == 'item_account' then
		if xPlayer.getAccount(item).money >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)
			exports['exile_logs']:SendLog(xPlayer.source, "testlog", "schowek")
			TriggerEvent('esx_addonaccount:getAccount', 'exile_magazine_' .. item, xPlayer.identifier, function(account)
				account.addMoney(count)
			end)
		else
                TriggerClientEvent("esx:showNotification", xPlayer.source, 'Nieprawidłowa ilość')
		end
	end
end)

ESX.RegisterServerCallback('exile_magazine:getPropertyInventory', function(source, cb)
    local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = 0
	local items      = {}
	TriggerEvent('esx_addonaccount:getAccount', 'exile_magazine_black_money', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getInventory', 'exile_magazine', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

ESX.RegisterServerCallback('exile_magazine:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)