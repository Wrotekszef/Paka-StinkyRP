local PlayersOnJob = {}

TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'gheneraugarage', 'Ghenerau Garage', 'society_gheneraugarage', 'society_gheneraugarage', 'society_gheneraugarage', {type = 'private'})

RegisterNetEvent('esx_gheneraugarage:giveweapon')
AddEventHandler('esx_gheneraugarage:giveweapon', function(weaponName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.job.name == "mechanic" or xPlayer.job.name == "gheneraugarage" or xPlayer.job.name == "mecano" then
		if weaponName == "WEAPON_WRENCH" or weaponName == "WEAPON_CROWBAR" or weaponName == "WEAPON_HAMMER" then			
			xPlayer.addInventoryWeapon(weaponName, 1, 48, false)
		else
			TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to spawn weapons without job")
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to spawn weapons without job")
	end
end)

RegisterServerEvent('esx_gheneraugarage:giveitem')
AddEventHandler('esx_gheneraugarage:giveitem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(item)
	if xPlayer.job.name == "gheneraugarage" or xPlayer.job.name == "offgheneraugarage" then
		if item == "gps" or item == "bodycam" or item == "radio" then
			if sourceItem.limit ~= -1 and (sourceItem.count + 1) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				xPlayer.addInventoryItem(item, 1)
			end
		else
			TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn items not gps or bodycam or radio")
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn items without job")
	end
end)

RegisterServerEvent('esx_gheneraugarage:onNPCJobMissionCompleted')
AddEventHandler('esx_gheneraugarage:onNPCJobMissionCompleted', function(distance, job, grade)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if PlayersOnJob[xPlayer.identifier] == true then
		local societyAccount
		local randomMnoznik = math.random(17, 17)
		local total = math.floor((distance * randomMnoznik) / 10)
		if grade > 3 then
			total = total * 1.00
		end
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
			societyAccount = account
		end)
		
		if societyAccount then
			local playerMoney  = math.floor(total / 100 * 40)
			local societyMoney = math.floor(total / 100 * 50)
			xPlayer.addMoney(playerMoney)
			societyAccount.addAccountMoney(societyMoney)
			TriggerClientEvent("esx:showNotification", _source, "Zarobiłeś ~g~".. playerMoney)
		else
			xPlayer.addMoney(total)
			TriggerClientEvent("esx:showNotification", _source, "Zarobiłeś ~g~".. total)
		end
		PlayersOnJob[xPlayer.identifier] = false
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source,  "Tried to give money (esx_gheneraugarage)")
	end
end)

ESX.RegisterUsableItem('blowpipe', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)

	TriggerClientEvent('esx_mechanikjob:onHijack', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('esx_mechanikjob:onFixkitFree', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('fixkit2', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit2', 1)

	TriggerClientEvent('esx_mechanikjob:onFixkitFree', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('carokit', 1)

	TriggerClientEvent('esx_mechanikjob:onCarokit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))
end)

RegisterServerEvent("exilerpNPC:jobComplete", function(jobId) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		if xPlayer.getJob().name == "gheneraugarage" or xPlayer.getJob().name == "offgheneraugarage" then
			local job = Config.TasksList[jobId]
			local price = job.price
			xPlayer.addMoney(price)
		else
			TriggerEvent("exilerp_scripts:banPlr", "nigger", xPlayer.source, "Tried to get money (esx_gheneraugarage)")
		end
	end
end)

ESX.RegisterServerCallback('mechanik:getPlayerDressing', function(source, cb, job)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
			local count  = store.count('dressing')
			local labels = {}

			for i=1, count, 1 do
				local entry = store.get('dressing', i)
				table.insert(labels, entry.label)
			end

			cb(labels)
		end)
	end
end)

ESX.RegisterServerCallback('mechanik:getPlayerOutfit', function(source, cb, num, job)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
			local outfit = store.get('dressing', num)
			cb(outfit.skin)
		end)
	end
end)

RegisterServerEvent('mechanik:removeOutfit')
AddEventHandler('mechanik:removeOutfit', function(label, job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == job then
		TriggerEvent('esx_datastore:getSharedDataStore', job, function(store)
			local dressing = store.get('dressing') or {}
			table.remove(dressing, label)
			store.set('dressing', dressing)
		end)
	end
end)