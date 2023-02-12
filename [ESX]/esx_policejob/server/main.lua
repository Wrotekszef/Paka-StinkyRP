TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'police', 'SASP', 'society_police', 'society_police', 'society_police', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'sert', 'SERT', 'society_sert', 'society_sert', 'society_sert', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'swat', 'SWAT', 'society_swat', 'society_swat', 'society_swat', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'sheriff', 'SASD', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'dtu', 'DTU', 'society_dtu', 'society_dtu', 'society_dtu', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'usms', 'USMS', 'society_usms', 'society_usms', 'society_usms', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'hp', 'HP', 'society_hp', 'society_hp', 'society_hp', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'hc', 'HC', 'society_hc', 'society_hc', 'society_hc', {type = 'public'})

local SearchTable = {}
local SearchTable1 = {}
local SavedInfo = {}

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo, price, label)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if (xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff') then
		if price ~= nil and price ~= 0 then			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..xPlayer.job.name, function(account)
				if price > 0 and account.account_money >= price then
					account.removeAccountMoney(price)

					if weapon == 'flashbang' then
						xPlayer.addInventoryItem(weapon)
					elseif (weapon == 'WEAPON_NIGHTSTICK' or weapon == 'WEAPON_FLASHLIGHT' or weapon == 'WEAPON_STUNGUN' or weapon == 'WEAPON_COMBATPISTOL'
					or weapon == 'WEAPON_FIVESEVEN' or weapon == 'WEAPON_PISTOL' or weapon == 'WEAPON_KNIFE' or weapon == 'WEAPON_SMOKEGREANDE' or weapon == 'WEAPON_HEAVYPISTOL'
					or weapon == 'WEAPON_COMBATPDW' or weapon == 'WEAPON_MILITARYRIFLE' or weapon == 'WEAPON_CARBINERIFLE' or weapon == 'WEAPON_CARBINERIFLE_MK2' or weapon == 'WEAPON_SNIPERRIFLE' or weapon == 'WEAPON_HEAVYSNIPER_MK2') then
						xPlayer.addInventoryWeapon(weapon, 1, 48, true)
					else
						TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to spawn weapons without job")
					end

					xPlayer.showNotification("Zakupiłeś ~g~" .. label)
					exports['exile_logs']:SendLog(src, "ZAKUPIŁ: " .. label ..  " za kwotę: " ..price.."$", 'police', '15158332')
					-- exports['exile_logs']:SendLog(src, "ZAKUPIŁ: " .. label ..  " za kwotę: " ..price.."$", 'swatstock', '15158332')
				else
					xPlayer.showNotification('~r~Brak potrzebnych funduszów na koncie frakcji')
				end
			end)
		else
			xPlayer.addInventoryWeapon(weapon, 1, 60, true)
			xPlayer.showNotification("Zakupiłeś ~g~" .. label)
			exports['exile_logs']:SendLog(src, "ZAKUPIŁ: " .. label .. " za kwotę: " ..price.."$", 'police', '15158332')
			exports['exile_logs']:SendLog(src, "Pobrał broń: " .. label .. " za kwotę: " ..price.."$", 'dcpolice', '15158332')
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to spawn weapons without job")
	end
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if not sourceXPlayer then return end
	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if itemName == 'phone' and (sourceXPlayer.job.name == 'police') then
			targetXPlayer.removeInventoryItem(itemName, amount)
			sourceXPlayer.addInventoryItem(itemName, amount)
			sourceXPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, target))
			targetXPlayer.showNotification(_U('got_confiscated', amount, sourceItem.label, _source))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
		end

		if (string.find(sourceItem.label, 'Chest') or string.find(sourceItem.label, 'Karta SIM #') or string.find(sourceItem.label, 'Bon') or itemName == 'phone' or itemName == 'opaska' or itemName == 'exilecoin') then
			sourceXPlayer.showNotification("Nie możesz zabrać ~r~"..sourceItem.label.."~s~!")
			return
		end

			if targetItem.count > 0 and targetItem.count <= amount then
				if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
					sourceXPlayer.showNotification(_U('quantity_invalid'))
				else
					targetXPlayer.removeInventoryItem(itemName, amount)
					sourceXPlayer.addInventoryItem(itemName, amount)
					sourceXPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, target))
					targetXPlayer.showNotification(_U('got_confiscated', amount, sourceItem.label, _source))
					exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
					
					if itemName == 'gps' and (targetXPlayer.job.name == 'police' or targetXPlayer.job.name == 'ambulance' or targetXPlayer.job.name == 'sheriff') then					
						local badge = json.decode(targetXPlayer.character.job_id).id
						if not badge then
							badge = 0
						end
						
						local data = {
							name = '['..badge..'] '..targetXPlayer.character.firstname..' '..targetXPlayer.character.lastname..' - '..targetXPlayer.job.grade_label,
							coords = GetEntityCoords(GetPlayerPed(target))
						}
						
						local GetPlayers = exports['esx_scoreboard']:ExilePlayers()
						for k,v in pairs(GetPlayers) do
							if v.job == 'police' or v.job == 'ambulance' or v.job == 'sheriff' then							
								TriggerClientEvent('esx_policejob:removedGPS', v.id, data)
							end
						end
					end
					
				end
		else
			sourceXPlayer.showNotification('Nie możesz tego zrobić!')
		end
	elseif itemType == 'item_money' then
		if targetXPlayer then
			local xyzz = targetXPlayer.getAccount('money').money
			if xyzz >= amount then
				targetXPlayer.removeMoney(amount)
				sourceXPlayer.addMoney(amount)
				sourceXPlayer.showNotification(_U('you_confiscated_money', amount, itemName, target))
				targetXPlayer.showNotification(_U('got_confiscated_money', amount, itemName, _source))
				exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
			end
		end
	elseif itemType == 'item_account' then
		if targetXPlayer then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)
			sourceXPlayer.showNotification(_U('you_confiscated_money', amount, itemName, target))
			targetXPlayer.showNotification(_U('got_confiscated_money', amount, itemName, _source))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')		
		end
	end
end)

function getItem(license, item) 
	local toreturn = nil
	MySQL.query("SELECT * FROM users WHERE identifier = ?", { license}, function(results)
		if results[1] then
			local inv = json.decode(results[1].inventory)
			if inv then
				local itemm = inv[item]
				if itemm then
					toreturn = itemm
				end	
			end	
		end	
		if toreturn == nil then
			toreturn = 0
		end	
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Wait(100)
	end	
	return toreturn
end

function getMoney(license) 
	local toreturn = nil
	MySQL.query("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				local itemm = inv["money"]
				if itemm then
					toreturn = itemm
				end	
			end	
		end	
		if toreturn == nil then
			toreturn = 0
		end	
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Wait(100)
	end	
	return toreturn
end
function getAccMoney(license, account) 
	local toreturn = nil
	MySQL.query("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				local itemm = inv[account]
				if itemm then
					toreturn = 0
				end	
			end	
		end	
		if toreturn == nil then
			toreturn = false
		end	
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Wait(100)
	end	
	return toreturn
end

function removeItem(license, item, amount) 
	MySQL.query("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].inventory)
			if inv then
				if inv[item] then
					inv[item] = inv[item]-amount
					local inventory = json.encode(inv)
					MySQL.update("UPDATE users SET inventory = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end	
		end	
	end)
end

function removeMoney(license, amount) 
	MySQL.query("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				if inv["money"] then
					inv["money"] = inv["money"]-amount
					local inventory = json.encode(inv)
					MySQL.update("UPDATE users SET accounts = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end	
		end	
	end)
end
function removeAccMoney(license, account, amount) 
	MySQL.query("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				if inv[account] then
					inv[account] = inv[account]-amount
					local inventory = json.encode(inv)
					MySQL.update("UPDATE users SET accounts = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end	
		end	
	end)
end

RegisterServerEvent('esx_policejob:confiscatePlayerItem1')
AddEventHandler('esx_policejob:confiscatePlayerItem1', function(target, itemType, itemName, amount)
	local _source = source
	local target = target:gsub("license:", "")
	local tPlayer = ESX.GetPlayerFromIdentifier(target)
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if not sourceXPlayer then return end

	if itemType == 'item_standard' then
		local targetItem = getItem(target, itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		
		if (string.find(sourceItem.label, 'Chest') or string.find(sourceItem.label, 'Karta SIM #') or string.find(sourceItem.label, 'Bon') or itemName == 'opaska' or itemName == 'exilecoin') then
			sourceXPlayer.showNotification("Nie możesz zabrać ~r~"..sourceItem.label.."~s~!")
			return
		end

		if targetItem > 0 and targetItem <= amount then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				sourceXPlayer.showNotification(_U('quantity_invalid'))
			else
				if not tPlayer then
					removeItem(target, itemName, amount)
				else
					tPlayer.removeInventoryItem(itemName, amount)
				end	
				sourceXPlayer.addInventoryItem   (itemName, amount)
				sourceXPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, target))
				exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. target .. "] \nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
			end
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end
	elseif itemType == 'item_money' then
		local money = 0
		if not tPlayer then
			money = getMoney(target)
		else
			money = tPlayer.getMoney()
		end
		if money and money >= amount then
			if not tPlayer then
				removeMoney(target, amount)
			else
				tPlayer.removeMoney(amount)
			end
			sourceXPlayer.addMoney(amount)
			sourceXPlayer.showNotification(_U('you_confiscated_money', amount, itemName, target))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. target .. "] \nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
		end
	elseif itemType == 'item_account' then
		local money = 0
		if not tPlayer then
			money = getAccMoney(target, itemName)
		else
			money = tPlayer.getAccountMoney(itemName)
		end
		if money >= amount then
			if not tPlayer then
				removeAccMoney(target, itemName, amount)
			else
				tPlayer.removeAccountMoney(itemName, amount)
			end
			sourceXPlayer.addAccountMoney(itemName, amount)
			sourceXPlayer.showNotification(_U('you_confiscated_account', amount, itemName, target))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. target .. "] \nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')	
		end	
	end
end)

RegisterServerEvent('esx_policejob:handcuffhype')
AddEventHandler('esx_policejob:handcuffhype', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    local distance = #(GetEntityCoords(GetPlayerPed(_source)) - GetEntityCoords(GetPlayerPed(target)))

	if not sourceXPlayer or not targetXPlayer then return end
    if distance > 100 then
		exports['exile_logs']:SendLog(_source, "Zakuł gracza a jego dystans wynosił: " .. distance .. "!", 'anticheat', '15158332')
		return
	end
	if target ~= false then
		exports['exile_logs']:SendLog(_source, "Zakuto/rozkuto gracza o ID: [" .. target .. "] ", 'handcuffs', '15158332')
		TriggerClientEvent('esx_policejob:handcuffhype', target)
	end
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	local _source = source
	if target then
		TriggerClientEvent('esx_policejob:drag', target, _source)
		TriggerClientEvent('esx_policejob:dragging', _source, target, true)
	end
end)

RegisterServerEvent('esx_policejob:dragging')
AddEventHandler('esx_policejob:dragging', function(target, cop)
	local _source = source
	if not cop then
		TriggerClientEvent('esx_policejob:dragging', target, _source, true)
	else
		TriggerClientEvent('esx_policejob:dragging', target, cop, false)
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	if target then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	end
end)

RegisterServerEvent('exile:putTargetInTrunk')
AddEventHandler('exile:putTargetInTrunk', function(target)
	local _source = source
	if target then
		TriggerClientEvent('esx_policejob:putInTrunk', target, _source)
	end
end)

RegisterServerEvent('exile:outTargetFromTrunk')
AddEventHandler('exile:outTargetFromTrunk', function(target)
	local _source = source
	if target then
		TriggerClientEvent('esx_policejob:OutTrunk', target, _source)
	end
end)

RegisterCommand('extrasy', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.group == 'superadmin' or xPlayer.group == 'best' then
		TriggerClientEvent('esx_policejob:dodatkiGaraz', source)
	else
		xPlayer.showNotification('~r~Nie posiadasz permisji')
	end
end, false)

RegisterNetEvent('esx_policejob:DodatkiKup')
AddEventHandler('esx_policejob:DodatkiKup', function(tablica, dodatek, state)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if state == true then
		xPlayer.showNotification('Zamontowano dodatek')
	elseif state == false then
		xPlayer.showNotification('Zdemontowano dodatek')
	end
end)

RegisterServerEvent("exilerp_scripts:CLrev", function() 
	local _source = source
	local license = "brak"
	for k,v in pairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	SavedInfo[license] = nil
end)

RegisterServerEvent("exilerp_scripts:CLdeath", function() 
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local license = "brak"
	for k,v in pairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	if xPlayer then
		local firstname = xPlayer.character.firstname
		local lastname  = xPlayer.character.lastname
		local sex       = xPlayer.character.sex
		local dob       = xPlayer.character.dateofbirth
		local height    = xPlayer.character.height

		local data = {
			name      = GetPlayerName(_source),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			license = license,
			accounts  = xPlayer.accounts,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			money     = xPlayer.getMoney(),
			coords    = xPlayer.getCoords()
		}

		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			data.licenses = licenses
			SavedInfo[license] = data
		end)
	end
end)

function GetCoordsSQL(license) 
	local toreturn = nil
	MySQL.query("SELECT * FROM users WHERE identifier = @license", {
		['@license'] = license
	}, function(results) 
		if results[1] then
			if results[1].lastpos then
				local lastpos = json.decode(results[1].lastpos)
				toreturn = {x=lastpos[1], y=lastpos[2], z=lastpos[3], heading=lastpos[4]}
			end	
			if toreturn == nil then
				toreturn = false
			end
		end
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Wait(150)
	end	
	return toreturn
end

AddEventHandler('playerDropped', function()
	local _source = source
	local id = GetPlayerIdentifiers(_source)
	local crds = GetEntityCoords(GetPlayerPed(_source))
	local license = "brak"
	for k,v in pairs(id) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	
	if SearchTable[_source] then
		SearchTable[_source] = nil
	end
	if SearchTable1[license] then
		SearchTable1[license] = nil
	end	
	local d = SavedInfo[license]
	if d then
		TriggerClientEvent("exilerp_scripts:offlineLoot", -1, license, crds)
	end	
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch', function(source, cb, target)
	if SearchTable[target] then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch2', function(source, cb, target)
	if SearchTable[target] then
		cb(true)
	else
		SearchTable[target] = true
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch1', function(source, cb, target)
	if SearchTable1[target] then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch3', function(source, cb, target)
	if SearchTable1[target] then
		cb(true)
	else
		SearchTable1[target] = true
		cb(false)
	end
end)

RegisterServerEvent('esx_policejob:cancelSearch1')
AddEventHandler('esx_policejob:cancelSearch1', function(target)
	if target and SearchTable1[target] then
		SearchTable1[target] = nil
	end
end)

RegisterServerEvent('esx_policejob:cancelSearch')
AddEventHandler('esx_policejob:cancelSearch', function(target)
	if target and SearchTable[target] then
		SearchTable[target] = nil
	end
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		local firstname = xPlayer.character.firstname
		local lastname  = xPlayer.character.lastname
		local sex       = xPlayer.character.sex
		local dob       = xPlayer.character.dateofbirth
		local height    = xPlayer.character.height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			money     = xPlayer.getMoney()
		}

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	end
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData1', function(source, cb, target)
	cb(SavedInfo[target])
end)

ESX.RegisterUsableItem('handcuff', function(source)
    TriggerClientEvent('Kajdanki', source)
end)

ESX.RegisterUsableItem('krotkofalowka', function(source)
	TriggerClientEvent('rp-radio:toogle', source)
end)

ESX.RegisterUsableItem('radio', function(source)
	TriggerClientEvent('rp-radio:toogle', source)
end)

RegisterServerEvent('esx_policejob:addlicenseforplayer')
AddEventHandler('esx_policejob:addlicenseforplayer', function (target)
    local _source = source
	local tPlayer = ESX.GetPlayerFromId(_source)
	local name2 = GetPlayerName(target)
	if tPlayer.job.name == 'police' or tPlayer.job.name == 'sheriff' then
		TriggerEvent('esx_license:addLicense', target, 'weapon')
		exports['exile_logs']:SendLog(_source, "Gracz wydał licencję na broń dla: [" .. target .. "] " .. name2, 'license')
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to give license to "..name2.."(esx_policejob )")
		return
	end
end)

RegisterServerEvent('esx_policejob:giveItem')
AddEventHandler('esx_policejob:giveItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if (xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice') or (xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'offsheriff') then
 		if (itemName ~= 'flashlight') and (itemName ~= 'ironsights') and (itemName ~= 'opaska')
		 and (itemName ~= 'gps') and (itemName ~= 'panic') and (itemName ~= 'bodycam') 
		 and (itemName ~= 'radio') and (itemName ~= 'kolczatka') and (itemName ~= 'barierka') 
		 and (itemName ~= 'pacholek') and (itemName ~= 'grip') 
		 and (itemName ~= 'scope') and (itemName ~= 'suppressor') and (itemName ~= 'clip_extended') 
		 and (itemName ~= 'kamzasaspbigswat') and (itemName ~= 'kamzasaspbigsert') and (itemName ~= 'kasksaspswat')
		 and (itemName ~= 'kasksaspsert') and (itemName ~= 'kamzasaspsmall') 
		 and (itemName ~= 'shotgunclip') and (itemName ~= 'mgclip') and (itemName ~= 'gusenbergclip')
		 and (itemName ~= 'sniperclip') and (itemName ~= 'smgclip') and (itemName ~= 'carbineclip')
		 and (itemName ~= 'pdwclip') and (itemName ~= 'assaultclip') and (itemName ~= 'clip')  and (itemName ~= 'clip_drum')
		 and (itemName ~= 'nurek_sasp') and (itemName ~= 'scope_medium') and (itemName ~= 'scope_large') and (itemName ~= 'scope_holo') and (itemName ~= 'nurek_sasd') and (itemName ~= 'pistol_ammo')
		 then
			TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn incorrect items")
			return
		end
		local xItem = xPlayer.getInventoryItem(itemName)
		local itemm = 1
		if xItem.limit ~= -1 then
			itemm = xItem.limit - xItem.count
		end
		if xItem.count < xItem.limit then
			xPlayer.addInventoryItem(itemName, count ~= nil and count or itemm)
		else
			xPlayer.showNotification(_U('max_item'))
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn items without job")
	end
end)

RegisterServerEvent('esx_policejob:requestarrest')
AddEventHandler('esx_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    local _source = source
    TriggerClientEvent('esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:doarrested', _source)
end)

RegisterServerEvent("break_10-13srp:request")
AddEventHandler("break_10-13srp:request", function(Officer)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local jobTxt = ''

	if xPlayer ~= nil then
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
			if (xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff') then
				jobTxt = 'Ranny funkcjonariusz przy użyciu broni'
			else
				jobTxt = 'Ranny medyk'
			end
			local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
			local color = {r = 256, g = 202, b = 247, alpha = 255}
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
			local odznaka = json.decode(xPlayer.character.job_id)
			local name = "[" .. odznaka.id .. "] " .. xPlayer.character.firstname .. " " .. xPlayer.character.lastname
			
			local GetPlayers = exports['esx_scoreboard']:ExilePlayers()
			for k,v in pairs(GetPlayers) do
				if v.job == 'police' or v.job == 'sheriff' or v.job == 'ambulance' then				
					TriggerClientEvent("break_10-13srp:alert", v.id, Officer, name, jobTxt)
				end
			end
		end
	end
end)

RegisterServerEvent("break_10-10srp:request")
AddEventHandler("break_10-10srp:request", function(Officer)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local jobTxt = ''

	if xPlayer ~= nil then
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
			if (xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff') then
				jobTxt = 'Ranny funkcjonariusz'
			else
				jobTxt = 'Ranny medyk przy użyciu broni'
			end
			local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
			local color = {r = 256, g = 202, b = 247, alpha = 255}
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
			local odznaka = json.decode(xPlayer.character.job_id)
			local name = "[" .. odznaka.id .. "] " .. xPlayer.character.firstname .. " " .. xPlayer.character.lastname
			
			local GetPlayers = exports['esx_scoreboard']:ExilePlayers()
			for k,v in pairs(GetPlayers) do
				if v.job == 'police' or v.job == 'sheriff' or v.job == 'ambulance' then				
					TriggerClientEvent("break_10-10srp:alert", v.id, Officer, name, jobTxt)
				end
			end
		end
	end
end)

RegisterCommand('c0', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('panic').count >= 1 then
		if (xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff') then
			TriggerClientEvent('falszywyy:getCoords', source)
			xPlayer.removeInventoryItem('panic', 1)
			local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
			local color = {r = 256, g = 202, b = 247, alpha = 255}
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
		else
			xPlayer.showNotification("~r~Częstotliwość tego panic buttona została zablokowana!")
		end
	else
		xPlayer.showNotification("~r~Nie posiadasz panic buttona!")
	end
end)

RegisterServerEvent("falszywyy:panicrequest")
AddEventHandler("falszywyy:panicrequest", function(Officer)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
		local color = {r = 256, g = 202, b = 247, alpha = 255}
		TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
		local odznaka = json.decode(xPlayer.character.job_id)
		local name = "[" .. odznaka.id .. "] " .. xPlayer.character.firstname .. " " .. xPlayer.character.lastname
		local GetPlayers = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(GetPlayers) do
			if v.job == 'police' or v.job == 'sheriff' then								
				TriggerClientEvent("falszywyy:triggerpanic", v.id, Officer, name)
			end
		end
	end
end)

ESX.RegisterUsableItem('kasksaspswat', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kasksaspswat', 1)
	TriggerClientEvent('tmsn701:kask', source)
end)