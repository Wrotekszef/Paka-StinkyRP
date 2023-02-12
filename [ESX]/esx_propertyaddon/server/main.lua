function GetPropertyAddon(name)
	for i=1, #Config.PropertiesAddon, 1 do
		if Config.PropertiesAddon[i].name == name then
			return Config.PropertiesAddon[i]
		end
	end
end

function SetPropertyOwnedAddon(name, price, rented, owner)
	MySQL.Async.execute('INSERT INTO owned_propertiesaddon (name, price, rented, owner) VALUES (@name, @price, @rented, @owner)', {
		['@name']   = name,
		['@price']  = price,
		['@rented'] = (rented and 1 or 0),
		['@owner']  = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_propertyaddon:SetPropertyOwnedAddon', xPlayer.source, name, true)

			if rented then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rented_for', ESX.Math.GroupDigits(price)))
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('purchased_for', ESX.Math.GroupDigits(price)))
			end
		end
	end)
end

function RemoveOwnedProperty(name, owner)
	MySQL.Async.execute('DELETE FROM owned_propertiesaddon WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_propertyaddon:SetPropertyOwnedAddon', xPlayer.source, name, false)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('made_property'))
		end
	end)
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM propertiesaddon', {}, function(propertiesaddon)

		for i=1, #propertiesaddon, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local roomMenu  = nil

			if propertiesaddon[i].entering ~= nil then
				entering = json.decode(propertiesaddon[i].entering)
			end

			if propertiesaddon[i].exit ~= nil then
				exit = json.decode(propertiesaddon[i].exit)
			end

			if propertiesaddon[i].inside ~= nil then
				inside = json.decode(propertiesaddon[i].inside)
			end

			if propertiesaddon[i].outside ~= nil then
				outside = json.decode(propertiesaddon[i].outside)
			end

			if propertiesaddon[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if propertiesaddon[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if propertiesaddon[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			if propertiesaddon[i].room_menu ~= nil then
				roomMenu = json.decode(propertiesaddon[i].room_menu)
			end

			table.insert(Config.PropertiesAddon, {
				name      = propertiesaddon[i].name,
				label     = propertiesaddon[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(propertiesaddon[i].ipls),
				gateway   = propertiesaddon[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				price     = propertiesaddon[i].price
			})
		end

		TriggerClientEvent('esx_propertyaddon:sendProperties', -1, Config.PropertiesAddon)
	end)
end)

ESX.RegisterServerCallback('esx_propertyaddon:GetPropertiesAddon', function(source, cb)
	cb(Config.PropertiesAddon)
end)

AddEventHandler('esx_ownedproperty:getOwnedPropertiesAddon', function(cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_propertiesaddon', {}, function(result)
		local propertiesaddon = {}

		for i=1, #result, 1 do
			table.insert(propertiesaddon, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetPropertyAddon(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner
			})
		end

		cb(propertiesaddon)
	end)
end)

AddEventHandler('esx_propertyaddon:SetPropertyOwnedAddon', function(name, price, rented, owner)
	SetPropertyOwnedAddon(name, price, rented, owner)
end)

AddEventHandler('esx_propertyaddon:removeOwnedProperty', function(name, owner)
	RemoveOwnedProperty(name, owner)
end)

RegisterServerEvent('esx_propertyaddon:rentProperty')
AddEventHandler('esx_propertyaddon:rentProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetPropertyAddon(propertyName)
	local rent     = ESX.Math.Round(property.price / 200)

	SetPropertyOwnedAddon(propertyName, rent, true, xPlayer.identifier)
end)

RegisterServerEvent('esx_propertyaddon:buyProperty')
AddEventHandler('esx_propertyaddon:buyProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetPropertyAddon(propertyName)

	if property.price <= xPlayer.getMoney() then
		xPlayer.removeMoney(property.price)
		SetPropertyOwnedAddon(propertyName, property.price, false, xPlayer.identifier)
	else
		TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
	end
end)

RegisterServerEvent('esx_propertyaddon:removeOwnedProperty')
AddEventHandler('esx_propertyaddon:removeOwnedProperty', function(propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	RemoveOwnedProperty(propertyName, xPlayer.identifier)
end)

AddEventHandler('esx_propertyaddon:removeOwnedPropertyIdentifier', function(propertyName, identifier)
	RemoveOwnedProperty(propertyName, identifier)
end)

RegisterServerEvent('esx_propertyaddon:saveLastProperty')
AddEventHandler('esx_propertyaddon:saveLastProperty', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_propertyaddon = @last_property WHERE identifier = @identifier', {
		['@last_property'] = property,
		['@identifier']    = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_propertyaddon:deleteLastProperty')
AddEventHandler('esx_propertyaddon:deleteLastProperty', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_propertyaddon = NULL WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_propertyaddon:getItem')
AddEventHandler('esx_propertyaddon:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getInventory', 'propertyaddon', xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then

				-- can the player carry the said amount of x item?
				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
					exports['exile_logs']:SendLog(_source, "Mieszkanie: "..xPlayerOwner.identifier.."\nWyciągnięto przedmiot: " .. item .. " x" .. count, 'property_get', '2123412')
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
			end
		end)

	elseif type == 'item_account' then

		TriggerEvent('esx_addonaccount:getAccount', 'propertyaddon_' .. item, xPlayerOwner.identifier, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
				exports['exile_logs']:SendLog(_source, "Mieszkanie: "..xPlayerOwner.identifier.."\nWyciągnięto brudną gotówkę: " .. count .. "$", 'property_get', '10181046')
			else
				TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
			end
		end)

	end
end)

RegisterServerEvent('esx_propertyaddon:putItem')
AddEventHandler('esx_propertyaddon:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'propertyaddon', xPlayerOwner.identifier, function(inventory)
				local sourceItem = xPlayer.getInventoryItem(item)
				if not string.find(sourceItem.label, "Chest") then
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, inventory.getItem(item).label))
					exports['exile_logs']:SendLog(_source, "Mieszkanie: "..xPlayerOwner.identifier.."\nWłożono przedmiot: " .. item .. " x" .. count, 'property_put', '2123412')
				else
					xPlayer.showNotification("Nie możesz wkładac do tej szafki Skrzynek / Bonów!")
				end
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getAccount', 'propertyaddon_' .. item, xPlayerOwner.identifier, function(account)
				account.addMoney(count)
				exports['exile_logs']:SendLog(_source, "Mieszkanie: "..xPlayerOwner.identifier.."\nWłożono brudną gotówkę: " .. count .. "$", 'property_put', '10181046')
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end

	end
end)

ESX.RegisterServerCallback('esx_propertyaddon:getOwnedPropertiesAddon', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT * FROM owned_propertiesaddon WHERE owner = @owner', {
			['@owner'] = xPlayer.identifier
		}, function(ownedProperties)
			local propertiesaddon = {}

			for i=1, #ownedProperties, 1 do
				table.insert(propertiesaddon, ownedProperties[i].name)
			end

			cb(propertiesaddon)
		end)
	end
end)

ESX.RegisterServerCallback('esx_propertyaddon:getLastProperty', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT last_propertyaddon FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		cb(users[1].last_propertyaddon)
	end)
end)

ESX.RegisterServerCallback('esx_propertyaddon:GetPropertyAddonInventory', function(source, cb, owner)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}

	TriggerEvent('esx_addonaccount:getAccount', 'propertyaddon_black_money', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getInventory', 'propertyaddon', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

ESX.RegisterServerCallback('esx_propertyaddon:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

ESX.RegisterServerCallback('esx_propertyaddon:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'propertyaddon', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('esx_propertyaddon:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'propertyaddon', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('esx_propertyaddon:removeOutfit')
AddEventHandler('esx_propertyaddon:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'propertyaddon', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM owned_propertiesaddon WHERE rented = 1', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)

			-- message player if connected
			if xPlayer then
				xPlayer.removeAccountMoney('bank', result[i].price)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_rent', ESX.Math.GroupDigits(result[i].price)))
			else -- pay rent either way
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
					['@bank']       = result[i].price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
				account.addMoney(result[i].price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 0, PayRent)
