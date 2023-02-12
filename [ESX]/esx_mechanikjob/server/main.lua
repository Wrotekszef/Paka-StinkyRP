local PlayersOnJob = {}

TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'mechanik', 'mechanik', 'society_mechanik', 'society_mechanik', 'society_mechanik', {type = 'private'})

RegisterNetEvent('esx_mechanikjob:giveweapon')
AddEventHandler('esx_mechanikjob:giveweapon', function(weaponName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.job.name == "mechanik" then
		if weaponName == "wrench" or weaponName == "crowbar" or weaponName == "hammer" then			
			xPlayer.addInventoryItem(weaponName, 1)
		else
			TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to spawn weapons without job")
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to spawn weapons without job")
	end
end)

RegisterServerEvent('esx_mechanikjob:giveitem')
AddEventHandler('esx_mechanikjob:giveitem', function(item)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local sourceItem = xPlayer.getInventoryItem(item)
	if xPlayer.job.name == "mechanik" or xPlayer.job.name == "offmechanik" then
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

RegisterServerEvent('esx_mechanikjob:onNPCJobMissionCompleted')
AddEventHandler('esx_mechanikjob:onNPCJobMissionCompleted', function(distance, job, grade)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print(job)
	print(xPlayer.job.name)
	if xPlayer.job.name == job then
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
			local playerMoney  = math.floor(total / 100 * 25)
			local societyMoney = math.floor(total / 100 * 25)
			xPlayer.addMoney(playerMoney)
			societyAccount.addAccountMoney(societyMoney)
			TriggerClientEvent("esx:showNotification", _source, "Zarobiłeś ~g~$".. playerMoney)
		else
			xPlayer.addMoney(total)
			TriggerClientEvent("esx:showNotification", _source, "Zarobiłeś ~g~$".. total)
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source,  "Tried to give money (esx_mechanikjob)")
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