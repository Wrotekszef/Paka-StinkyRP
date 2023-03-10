SetConvarReplicated("serverType", GetConvar("serverType", "wloff"))

function getServer() 
	return GetConvar("serverType", "wloff")
end

local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
	math.randomseed(os.time())

	if length > 0 then
		return string.random(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	local _source = source
	if not ESX.Players[_source] then
		onPlayerJoined(_source)
	end
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateWeaponAmmo(weaponName, ammoCount)
	end
end)

ESX.RegisterUsableItem('clip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'clip')
end)

ESX.RegisterUsableItem('gusenbergclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'gusenbergclip')
end)

ESX.RegisterUsableItem('mgclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'mgclip')
end)

ESX.RegisterUsableItem('carbineclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'carbineclip')
end)

ESX.RegisterUsableItem('assaultclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'assaultclip')
end)

ESX.RegisterUsableItem('pdwclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'pdwclip')
end)

ESX.RegisterUsableItem('shotgunclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'shotgunclip')
end)

ESX.RegisterUsableItem('sniperclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'sniperclip')
end)

ESX.RegisterUsableItem('smgclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'smgclip')
end)

ESX.RegisterUsableItem('clipaddons', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'clipaddons')
end)

RegisterServerEvent('esx_weashop:remove')
AddEventHandler('esx_weashop:remove', function(extended)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local item = xPlayer.getInventoryItem(extended).count 
	if item >= 1 then
		xPlayer.removeInventoryItem(extended, 1)
	end
end)

RegisterNetEvent('es_extneded:giveclip')
AddEventHandler('es_extneded:giveclip', function(extended)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if extended ~= "clip" and extended ~= "clipaddons" and extended ~= "smgclip" and extended ~= "sniperclip" and extended ~= "shotgunclip" and extended ~= "pdwclip" and extended ~= "assaultclip" and extended ~= "carbineclip" then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Invalid Clip (es_extended)")
		return
	end
	if xPlayer ~= nil then
		if extended then
			if xPlayer.canCarryItem(extended, 1) then
				xPlayer.addInventoryItem(extended, 1)
			else	
				xPlayer.showNotification('~s~Nie mo??esz mie?? wi??cej magazynk??w')
			end
		end
	end
end)

RegisterNetEvent('es_extended:giveAmmo')
AddEventHandler('es_extended:giveAmmo', function(ammoItem, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if ammoItem == 'pistol_ammo' or ammoItem == 'rifle_ammo' or ammoItem == 'smg_ammo' or ammoItem == 'shotgun_ammo' or ammoItem == 'sniper_ammo' then
		if xPlayer.getInventoryItem(ammoItem).count <= 500 then
			if count == 32 then
				xPlayer.addInventoryItem(ammoItem, count)
			else
				TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Cheating Ammo Clip (es_extended)")
			end
		else
			xPlayer.showNotification('Nie mo??esz posiada?? wi??cej amunicji!')
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Cheating Ammo Invalid Clip (es_extended)")
	end
end)

RegisterNetEvent('es_extended:componentMenu')
AddEventHandler('es_extended:componentMenu', function(state, comp)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if comp == "suppressor" or comp == "clip_box" or comp == "flashlight_dodatek" or comp == "grip" or comp == "clip_extended" or comp == "scope_large" or comp == "scope_medium" or comp == "scope_holo" 
	or comp == "clip_drum" or comp == "scope" or comp == "scope_advanced" or comp == "scope_zoom" or comp == "scope_nightvision" or comp == "scope_thermal" then
		if state then
			xPlayer.removeInventoryItem(comp, 1)
		else
			xPlayer.addInventoryItem(comp, 1)
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Cheating tried to giveitem (es_extended) "..comp)
	end
end)

function onPlayerJoined(playerId)
	local identifier = ESX.GetIdentifier(playerId)
	if identifier then
		if ESX.GetPlayerFromIdentifier(identifier) then
			DropPlayer(playerId, ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
		else
			local result = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', { identifier })
			if result then
				loadESXPlayer(identifier, playerId)
			else
				local accounts = {}

				for account,money in pairs(Config.StartingAccountMoney) do
					accounts[account] = money
				end

				MySQL.update('INSERT INTO users (accounts, identifier) VALUES (@accounts, @identifier)', {
					['@accounts'] = json.encode(accounts),
					['@identifier'] = identifier
				}, function(rowsChanged)
					loadESXPlayer(identifier, playerId)
				end)
			end
		end
	else
		DropPlayer(playerId, 'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
	end
end

function loadESXPlayer(identifier, playerId)
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		character    = {},
		playerName = GetPlayerName(playerId),
		secondjob    = {},
		thirdjob    = {},
		dealerLevel  = {},
		digit        = 0,
		slot = {},
		opaska 		 = 0
	}
	local result = MySQL.prepare.await('SELECT * FROM `users` WHERE identifier = ?', {identifier})
	local job, grade, jobObject, gradeObject = result.job, tostring(result.job_grade)
	local secondjob, secondjobgrade = result.secondjob, tostring(result.secondjob_grade)
	local thirdjob, thirdjobgrade = result.thirdjob, tostring(result.thirdjob_grade)
	local foundAccounts, foundItems = {}, {}

	if result.firstname and result.lastname ~= '' then
		userData.character.firstname 		= result.firstname
		userData.character.lastname 		= result.lastname
		userData.character.dateofbirth  	= result.dateofbirth
		userData.character.sex				= result.sex
		userData.character.height			= result.height
		userData.character.status 			= result.status
		userData.character.phone_number 	= result.phone_number
		userData.character.account_number 	= result.account_number
		userData.character.pincode 			= result.pincode
		userData.character.job_id 			= result.job_id
		userData.character.opaska			= result.opaska
		userData.character.tattoos			= result.tattoos
	end

	if result.accounts and result.accounts ~= '' then
		local accounts = json.decode(result.accounts)

		for account,money in pairs(accounts) do
			foundAccounts[account] = money
		end
	end

	for account,label in pairs(Config.Accounts) do
		table.insert(userData.accounts, {
			name = account,
			money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
			label = label
		})
	end

	if ESX.DoesJobExist(job, grade) then
		jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
	else
		print(('[es_extended] [^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job, grade))
		job, grade = 'unemployed', '0'
		jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
	end

	if ESX.DoesJobExist(secondjob, secondjobgrade) then
		local jobObject, gradeObject = ESX.Jobs[secondjob], ESX.Jobs[secondjob].grades[secondjobgrade]

		userData.secondjob = {}

		userData.secondjob.id    = jobObject.id
		userData.secondjob.name  = jobObject.name
		userData.secondjob.label = jobObject.label

		userData.secondjob.grade        = tonumber(secondjobgrade)
		userData.secondjob.grade_name   = gradeObject.name
		userData.secondjob.grade_label  = gradeObject.label
		userData.secondjob.grade_salary = gradeObject.salary

		userData.secondjob.skin_male    = {}
		userData.secondjob.skin_female  = {}

		if gradeObject.skin_male ~= nil then
			userData.secondjob.skin_male = json.decode(gradeObject.skin_male)
		end

		if gradeObject.skin_female ~= nil then
			userData.secondjob.skin_female = json.decode(gradeObject.skin_female)
		end

	else
		print(('[es_extended] [^3WARNING^7] Ignoring invalid secondjob for %s [secondjob: %s, secondjobgrade: %s]'):format(identifier, secondjob, secondjobgrade))
		local secondjob, secondjobgrade = 'unemployed', '0'
		local jobObject, gradeObject = ESX.Jobs[secondjob], ESX.Jobs[secondjob].grades[secondjobgrade]

		userData.secondjob = {}

		userData.secondjob.id    = jobObject.id
		userData.secondjob.name  = jobObject.name
		userData.secondjob.label = jobObject.label

		userData.secondjob.grade        = tonumber(secondjobgrade)
		userData.secondjob.grade_name   = gradeObject.name
		userData.secondjob.grade_label  = gradeObject.label
		userData.secondjob.grade_salary = gradeObject.salary

		userData.secondjob.skin_male    = {}
		userData.secondjob.skin_female  = {}
	end

	if ESX.DoesJobExist(thirdjob, thirdjobgrade) then
		local jobObject, gradeObject = ESX.Jobs[thirdjob], ESX.Jobs[thirdjob].grades[thirdjobgrade]

		userData.thirdjob = {}

		userData.thirdjob.id    = jobObject.id
		userData.thirdjob.name  = jobObject.name
		userData.thirdjob.label = jobObject.label

		userData.thirdjob.grade        = tonumber(thirdjobgrade)
		userData.thirdjob.grade_name   = gradeObject.name
		userData.thirdjob.grade_label  = gradeObject.label
		userData.thirdjob.grade_salary = gradeObject.salary

		userData.thirdjob.skin_male    = {}
		userData.thirdjob.skin_female  = {}

		if gradeObject.skin_male ~= nil then
			userData.thirdjob.skin_male = json.decode(gradeObject.skin_male)
		end

		if gradeObject.skin_female ~= nil then
			userData.thirdjob.skin_female = json.decode(gradeObject.skin_female)
		end

	else
		print(('[es_extended] [^3WARNING^7] Ignoring invalid thirdjob for %s [thirdjob: %s, thirdjobgrade: %s]'):format(identifier, thirdjob, thirdjobgrade))
		local thirdjob, thirdjobgrade = 'unemployed', '0'
		local jobObject, gradeObject = ESX.Jobs[thirdjob], ESX.Jobs[thirdjob].grades[thirdjobgrade]

		userData.thirdjob = {}

		userData.thirdjob.id    = jobObject.id
		userData.thirdjob.name  = jobObject.name
		userData.thirdjob.label = jobObject.label

		userData.thirdjob.grade        = tonumber(thirdjobgrade)
		userData.thirdjob.grade_name   = gradeObject.name
		userData.thirdjob.grade_label  = gradeObject.label
		userData.thirdjob.grade_salary = gradeObject.salary

		userData.thirdjob.skin_male    = {}
		userData.thirdjob.skin_female  = {}
	end
	

	userData.job.id = jobObject.id
	userData.job.name = jobObject.name
	userData.job.label = jobObject.label

	userData.job.grade = tonumber(grade)
	userData.job.grade_name = gradeObject.name
	userData.job.grade_label = gradeObject.label
	userData.job.grade_salary = gradeObject.salary

	userData.job.skin_male = {}
	userData.job.skin_female = {}

	if gradeObject.skin_male then userData.job.skin_male = json.decode(gradeObject.skin_male) end
	if gradeObject.skin_female then userData.job.skin_female = json.decode(gradeObject.skin_female) end

	if result.inventory and result.inventory ~= '' then
		local inventory = json.decode(result.inventory)

		for name,count in pairs(inventory) do
			local item = ESX.Items[name]
			
			if item then						
				if type(item.data) =='string' then
					item.data = json.decode(item.data)
				end
		
				table.insert(userData.inventory, {
					name = name,
					count = count,
					label = item.label,
					limit = item.limit,
					usable = ESX.UsableItemsCallbacks[name] ~= nil,
					rare = item.rare,
					canRemove = item.canRemove,
					type = item.type,
					data = item.data
				})
			end
		end
	end

	table.sort(userData.inventory, function(a, b)
		return a.label < b.label
	end)
	
	if result.slot then
		userData.slot = json.decode(result.slot)
	end

	local discordGroup = PlayerDiscordRoles(playerId)

	if result.group then
        userData.group = result.group
    end

    if userData.group ~= discordGroup then
        userData.group = discordGroup
    end

	if result.tattoos then
		userData.tattoos = result.tattoos
	end

	if result.position and result.position ~= '' then
		userData.coords = json.decode(result.position)
	else
		userData.coords = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8}
	end

	if result.skin and result.skin ~= '' then
		userData.skin = json.decode(result.skin)
	else
		if userData.sex == 'f' then userData.skin = {sex=1} else userData.skin = {sex=0} end
	end
	
	if result.dealerLevel then
		userData.dealerLevel = json.decode(result.dealerLevel)
	end
	
	if result.digit ~= nil then
		userData.digit = result.digit
	end


	local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory, userData.job, userData.playerName, userData.coords, userData.character, userData.secondjob, userData.thirdjob, userData.dealerLevel, userData.digit, userData.slot)
	ESX.Players[playerId] = xPlayer
	TriggerEvent('esx:playerLoaded', playerId, xPlayer)

	xPlayer.triggerEvent('esx:playerLoaded', {
		accounts = xPlayer.getAccounts(),
		coords = xPlayer.getCoords(),
		identifier = xPlayer.getIdentifier(),
		inventory = xPlayer.getInventory(),
		job = xPlayer.getJob(),
		money = xPlayer.getMoney(),
		character	 = xPlayer.getCharacter(),
		secondjob	 = xPlayer.getSecondJob(),
		thirdjob	 = xPlayer.getThirdJob(),
		dealerLevel  = xPlayer.getDealerLevel(),
		digit 		 = xPlayer.getDigit(),
		slots 		 = xPlayer.getSlots(),
		group 		 = xPlayer.getGroup()
	})

	xPlayer.triggerEvent('esx:registerSuggestions', ESX.RegisteredCommands)
	xPlayer.triggerEvent('EasyAdmin:refreshPermission')
end

AddEventHandler('chatMessage', function(playerId, author, message)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	print("^4[ExileRP] ^4"..GetPlayerName(source).." ^7Opuszcza serwer. ["..reason.."]")
	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)

		ESX.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
		end)
		
		TriggerClientEvent("esx:onPlayerLogout", playerId)
	end
end)

RegisterNetEvent('esx:updateSlots')
AddEventHandler('esx:updateSlots', function(slots)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setSlots(slots)
	end
end)

RegisterNetEvent('esx:updateCoords')
AddEventHandler('esx:updateCoords', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateCoords(coords)
	end
end)

RegisterNetEvent('esx:gitestveInventoryItem')
AddEventHandler('esx:gitestveInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	local distance = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(GetPlayerPed(target)))
	if not sourceXPlayer then return end

	if type == 'item_standard' or type == 'item_weapon' or type == 'item_sim' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)
				
				if sourceItem.type == 'sim' then
					if sourceXPlayer.character.phone_number == sourceItem.data.number then
						sourceXPlayer.triggerEvent('e-phone:myPhoneNumber', nil)
						sourceXPlayer.setCharacter('phone_number', '')			
					end
				end
				
				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label, targetXPlayer.source))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label, sourceXPlayer.source))
				TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Przekazuje przedmiot "..sourceItem.label.. " w ilo??ci "..itemCount)
				exports['exile_logs']:SendLog(playerId, "Przekazano przedmiot: " .. sourceItem.label .. " x" .. itemCount .. " dla [" .. target .. "] " .. GetPlayerName(target), 'item_give', '2123412')			
			else
				sourceXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.name))
			end
		else
			sourceXPlayer.showNotification(_U('imp_invalid_quantity'))
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			sourceXPlayer.showNotification('~o~Przekazywanie pieni??dzy graczowi')
			Wait(5000)
			targetXPlayer.addAccountMoney(itemName, itemCount)
			sourceXPlayer.showNotification(_U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], targetXPlayer.source))
			targetXPlayer.showNotification(_U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], sourceXPlayer.source))
			TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Przekazuje pieni??dze w ilo??ci "..ESX.Math.GroupDigits(itemCount).. "$")
			exports['exile_logs']:SendLog(playerId, "Przekazano pieni??dze: " .. ESX.Math.GroupDigits(itemCount) .. "$ dla [" .. target .. "] " .. GetPlayerName(target), 'item_give', '15844367')
		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == 'item_standard' or type == 'item_weapon' or type == 'item_sim' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_quantity'))
		else
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification(_U('imp_invalid_quantity'))
			else
				xPlayer.removeInventoryItem(itemName, itemCount)
				xPlayer.showNotification(_U('threw_standard', itemCount, xItem.label))
				TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Upu??ci?? przedmiot ["..xItem.label.." - "..itemCount.."x]")
				exports['exile_logs']:SendLog(playerId, "Wyrzucono przedmiot: " .. xItem.label .. " x" .. itemCount, 'item_drop', '2123412')
				if type == 'item_weapon' then
					ESX.DeleteDynamicItem(itemName)
				end
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local account = xPlayer.getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification(_U('imp_invalid_amount'))
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				xPlayer.showNotification(_U('threw_account', ESX.Math.GroupDigits(itemCount), string.lower(account.label)))
				TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Upu??ci?? pieni??dze w ilo??ci "..ESX.Math.GroupDigits(itemCount).. "$")
				exports['exile_logs']:SendLog(playerId, "Wyrzucono pieni??dze: " .. ESX.Math.GroupDigits(itemCount) .. "$", 'item_drop', '15844367')
			end
		end
	end
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local item = xPlayer.getInventoryItem(itemName)

	if item.count > 0 then
		if item.type == 'sim' then
			if xPlayer.character.phone_number == item.data.number then
				MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
					['@identifier']   = xPlayer.identifier,
					['@phone_number'] = ''
				}, function(pass)
					if pass then
						xPlayer.showNotification('Od????czono kart?? SIM #'..tostring(item.data.number)) 
						xPlayer.triggerEvent('e-phone:myPhoneNumber', nil)
						xPlayer.setCharacter('phone_number', '')
					end
				end)
			else
				MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
					['@identifier']   = xPlayer.identifier,
					['@phone_number'] = item.data.number
				}, function(pass)
					if pass then
						xPlayer.showNotification('Pod????czono kart?? SIM #'..item.data.number)
						xPlayer.triggerEvent('e-phone:myPhoneNumber', item.data.number)
						xPlayer.setCharacter('phone_number', item.data.number)
					end
				end)
			end		
		else
			ESX.UseItem(src, itemName)
		end
	else
		xPlayer.showNotification(_U('act_imp'))
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		secondjob 	 = xPlayer.getSecondJob(),
		thirdjob	 = xPlayer.getThirdJob(),
		dealerLevel  = xPlayer.getDealerLevel(),
		money        = xPlayer.getMoney(),
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		secondjob 	 = xPlayer.getSecondJob(),
		thirdjob	 = xPlayer.getThirdJob(),
		dealerLevel  = xPlayer.getDealerLevel(),
		money        = xPlayer.getMoney(),
	})
end)

ESX.RegisterServerCallback('esx:getPlayerNames', function(source, cb, players)
	players[source] = nil

	for playerId,v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			players[playerId] = xPlayer.getName()
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx:isValidItem', function(source, cb, item)
	if ESX.Items[item] then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx:updateDecor')
AddEventHandler('esx:updateDecor', function(what, entity, key, value)
	TriggerClientEvent('esx:updateDecor', -1, what, entity, key, value)
end)

ConfigDC = {}
ConfigDC.DiscordToken = 'MTA2NjMyNDU4ODQ3ODM0MTI0MQ.G1FLrR.H68aPxScqQlriv__gs4srfyXSdc7vlQ5LbjCcY'
ConfigDC.DiscordGuild = '891655439840866344' 
ConfigDC.DiscordRoles = {
    ['823182171773730817'] = 'best', -- Zarz??d
	['949408681001365506'] = 'best', -- Lead Developer
    ['819679099185790976'] = 'superadmin', -- Head Admin
    ['909429170612871189'] = 'starszyadmin', -- Senior Admin
    ['819679104143065088'] = 'admin', -- Admin
    ['1044152476074508338'] = 'starszymod', -- Starszy Moderator
    ['819679125442134088'] = 'mod', -- Moderator
    ['819679130517241907'] = 'support', -- Support
    ['1044120315292295238'] = 'trialsupport', -- Trail Support
	['664452128294567966'] = 'partner', -- Partner
	['1034905216685985804'] = 'patron', 
	['1044153453515124746'] = 'patron', 
	['973666726820606012'] = 'vip', -- VIP
}

GetPlayerIdentifierByType = function(source, type, sub)
    local identifiers = GetPlayerIdentifiers(source)

    for i = 1, #identifiers do
        if identifiers[i]:match(type .. ':') then
            if sub then
                return identifiers[i]:sub(type:len() + 2, identifiers[i]:len())
            end

            return identifiers[i]
        end
    end

    return nil
end

PlayerDiscordRoles = function(playerId)
	if playerId then
		local discordId = GetPlayerIdentifierByType(playerId, 'discord', true)

		if discordId then
			local userRoles = DiscordGetRoles(discordId)

			if userRoles then
				for _, roleId in ipairs(userRoles) do
					local roleGroup = ConfigDC.DiscordRoles[roleId]
					
					if roleGroup then
						return roleGroup
					end
				end
			end
		end
	end

	return 'user'
end


DiscordApiRequest = function(method, endpoint, jsonData)
    local data = nil

    PerformHttpRequest('https://discordapp.com/api/' .. endpoint, function(errorCode, resultData, resultHeaders)
        data = {
            data = resultData,
            code = errorCode,
            headers = resultHeaders
        }
    end, method, #jsonData > 0 and json.encode(jsonData) or '', {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bot ' .. ConfigDC.DiscordToken
    })

    while data == nil do
        Wait(0)
    end

    return data
end

DiscordGetRoles = function(discordId)
    local endpoint = ('guilds/%s/members/%s'):format(ConfigDC.DiscordGuild, discordId)
    local member = DiscordApiRequest('GET', endpoint, {})

    if member.code == 200 then
        local data = json.decode(member.data)

        return data.roles
    end

    return nil
end