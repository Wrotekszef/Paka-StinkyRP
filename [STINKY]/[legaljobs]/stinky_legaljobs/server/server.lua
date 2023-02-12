local Inventories = {}
local Weapons = {}
Licenses = {}

LegalJobs = {
    {
        name = "casino",
        organizationName = "Casino Royale"
    },
	{
        name = "uwucafe",
        organizationName = "uwucafe"
    },
	{
		name = "cardealer",
		organizationName = "Lux MotorSport"
	},
	{
		name = "burgershot",
		organizationName = "Burgershot"
	},
	{
		name = "pizzeria",
		organizationName = "Pizza This"
	},
	{
		name = "extreme",
		organizationName = "Extreme Sports"
	},
	{
		name = 'x-gamer',
		organizationName = 'X-Gamer'
	},
	{
		name = 'winiarz',
		organizationName = 'Winiarz'
	},
	{
		name = 'doj',
		organizationName = 'Department Of Justice'
	},
	{
		name = 'galaxy',
		organizationName = 'Galaxy Club'
	},
	{
		name = 'fisherman',
		organizationName = 'Rybak'
	},
	{
		name = 'grower',
		organizationName = 'Sadownik'
	},
	{
		name = 'milkman',
		organizationName = 'Mleczarz'
	},
	{
		name = 'fueler',
		organizationName = 'Rafiner'
	},
	{
		name = 'weazel',
		organizationName = 'Weazel News'
	},
	{
		name = 'baker',
		organizationName = 'Piekarz'
	},
	{
		name = 'farming',
		organizationName = 'Farmer'
	},
	{
		name = 'slaughter',
		organizationName = 'Rzeźnik'
	},
	{
		name = 'miner',
		organizationName = 'Górnik'
	},
	{
		name = 'krawiec',
		organizationName = 'Krawiec'
	},
	{
		name = 'psycholog',
		organizationName = 'Psycholog'
	},
	{
		name = 'swat',
		organizationName = 'SWAT'
	},
	{
		name = 'highcommand',
		organizationName = 'highcommand'
	},
	{
		name = 'sams2',
		organizationName = 'Ambulance'
	},
}

for i=1, #LegalJobs, 1 do
    TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', LegalJobs[i].name, LegalJobs[i].organizationName, 'society_'..LegalJobs[i].name, 'society_'..LegalJobs[i].name, 'society_'..LegalJobs[i].name, {type = 'private'})
end

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		MySQL.query('SELECT name, level FROM addon_legaljobs', function(result)
			for i=1, #result, 1 do
				local name = result[i].name
				local level = result[i].level
				table.insert(Licenses, {
					name = name,
					level = level,
				})
			end
		end)
	end
end)

ESX.RegisterServerCallback('exile_legaljobs:getLicenses', function(source, cb, society)
	local currentSociety = {}
	local found = false
	for i=1, #Licenses, 1 do
		if society == Licenses[i].name then
			currentSociety = Licenses[i]
			found = true
			break
		end
	end
	while found == false do 
		Wait(200)
	end
	cb(currentSociety)
end)

RegisterServerEvent('exile:kontrakt', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem('contract')
	if xPlayer.getJob().name == 'cardealer' then
		if item.limit == 5 and item.count >= item.limit then
			TriggerClientEvent('esx:showNotification', source, 'Nie uniesiesz więcej ~y~kontraktów')
		else
			xPlayer.addInventoryItem('contract', 1)
		end
	end
end)

RegisterServerEvent('exile_legaljobs:upgradeSociety')
AddEventHandler('exile_legaljobs:upgradeSociety', function(upgradeType, value, society, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
		for i=1, #Licenses, 1 do
			if Licenses[i].name == society then
				Licenses[i][upgradeType] = value
				break
			end
		end
		xPlayer.removeMoney(price)
		MySQL.update('UPDATE addon_legaljobs SET ' .. upgradeType .. ' = @value WHERE name = @name', {
			['@value'] = value,
			['@name'] = society
		})
		xPlayer.showNotification("~g~Wykupiłeś dostęp do wybranej przez siebie opcji")
	else
		xPlayer.showNotification("~r~Nie masz wystarczająco gotówki przy sobie")
	end
end)

ESX.RegisterServerCallback('exile:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	if xPlayer then
		local blackMoney = xPlayer.getAccount('black_money').money
		local items      = xPlayer.inventory

		cb({
			blackMoney = blackMoney,
			items      = items,
		})
	end
end)

ESX.RegisterServerCallback('exile:getStockItems', function(source, cb, society)
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
		if inventory == nil then
			items = {}
		else
			items = inventory.items
		end
	end)

	cb({
		blackMoney = blackMoney,
		items      = items
	})
end)

RegisterServerEvent('exile:getStockItem')
AddEventHandler('exile:getStockItem', function(itemType, itemName, count, society)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	local scriptJob = string.sub(society, 9)
	if scriptJob == 'swat' or scriptJob == 'sert' or scriptJob == 'highcommand' then
		if xPlayer.job.name == "police" then
			scriptJob = "police"
		end
		if xPlayer.job.name == "sheriff" then
			scriptJob = "sheriff"
		end
	end

	if scriptJob == 'sams2' then
		scriptJob = "ambulance"
	end

	if xPlayer.job.name == scriptJob or xPlayer.secondjob.name == scriptJob or xPlayer.thirdjob.name == scriptJob then
		if itemType == 'item_standard' then
			TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
				local sourceItem = xPlayer.getInventoryItem(itemName)
				local inventoryItem = inventory.getItem(itemName)

				if count > 0 and inventoryItem.count >= count then
					if sourceItem.limit ~= -1 and ((sourceItem.count + count) > sourceItem.limit) then
						TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nieprawidłowa wartość")
					else
						if xPlayer.canCarryItem(itemName, count)  then
							inventory.removeItem(itemName, count)
							xPlayer.addInventoryItem(itemName, count)

							TriggerClientEvent('esx:showNotification', xPlayer.source, "Wyciągnąłeś ~y~" .. sourceItem.label .. " ~b~x" .. count .. "~w~ z szafki")
							exports['exile_logs']:SendLog(xPlayer.source, "Wyciągnięto " .. sourceItem.label .. " x" .. count .. " z szafki: "..scriptJob, scriptJob, '3447003')
							--- DC PD BO KRZYCHU KAZAŁ
							exports['exile_logs']:SendLog(xPlayer.source, "Wyciągnięto " .. sourceItem.label .. " x" .. count .. " z szafki: "..scriptJob, 'dcpolice', '3447003')
							
							if society == 'society_swat' or scriptJob == 'swat' then
								exports['exile_logs']:SendLog(xPlayer.source, "Wyciągnął z wyposażenia SWAT / HC przedmiot: " .. sourceItem.label .. " x" .. count, 'wyposazenieswatsert', '3447003')
								exports['exile_logs']:SendLog(xPlayer.source, "Wyciągnął z wyposażenia SWAT / HC przedmiot: " .. sourceItem.label .. " x" .. count, 'swatstock', '3447003')

							end
						
						
						else
							xPlayer.showNotification('~r~Nie uniesiesz tak dużo!')
						end
					end
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nieprawidłowa wartość")
				end
			end)

		elseif itemType == 'item_account' then
			TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
				local roomAccountMoney = account.money

				if roomAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney(itemName, count)

					exports['exile_logs']:SendLog(xPlayer.source, "Wyciągnięto brudną gotówkę: " .. count .. " z szafki: "..scriptJob, scriptJob, '3447003')
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nieprawidłowa wartość")
				end
			end)
		end
	else
		if xPlayer then
			exports['exile_logs']:SendLog(xPlayer.source, GetCurrentResourceName() .. ':getStockItem - Wykryto próbę wyciągnięcia przedmiotu bez odpowiedniej pracy - ' .. string.upper(scriptJob), 'anticheat')
		end
	end
end)

RegisterServerEvent('exile:putItemInStock')
AddEventHandler('exile:putItemInStock', function(itemType, itemName, count, society, generate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	local scriptJob = string.sub(society, 9)
	if scriptJob == 'swat' or scriptJob == 'sert' or scriptJob == 'highcommand' then
		if xPlayer.job.name == "police" then
			scriptJob = "police"
		end
		if xPlayer.job.name == "sheriff" then
			scriptJob = "sheriff"
		end
	end

	if scriptJob == 'sams2' then
		scriptJob = "ambulance"
	end

	if xPlayer.job.name == scriptJob or xPlayer.secondjob.name == scriptJob or xPlayer.thirdjob.name == scriptJob then
		if itemType == 'item_standard' then
			if count > 0 and (sourceItem.count >= count) then
				xPlayer.removeInventoryItem(itemName, count)

				TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
					inventory.addItem(itemName, count)
				end)

				TriggerClientEvent('esx:showNotification', xPlayer.source, "Włożyłeś ~y~" .. sourceItem.label .. " ~b~x" .. count .. "~w~ do szafki")
				exports['exile_logs']:SendLog(xPlayer.source, "Włożono " .. sourceItem.label .. " x" .. count .. " do szafki: "..scriptJob, scriptJob, '3447003')
			
				if society == 'society_swat' or scriptJob == 'swat' then
					exports['exile_logs']:SendLog(xPlayer.source, "Gracz włożył do wyposażenia SWAT / HC przedmiot: " .. sourceItem.label .. " x" .. count, 'wyposazenieswatsert', '3447003')
					exports['exile_logs']:SendLog(xPlayer.source, "Gracz włożył do wyposażenia SWAT / HC przedmiot: " .. sourceItem.label .. " x" .. count, 'swatstock', '3447003')

				end
			
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nieprawidłowa ilość")
			end

		elseif itemType == 'item_account' then
			local playerAccountMoney = xPlayer.getAccount(itemName).money

			if playerAccountMoney >= count and count > 0 then
				xPlayer.removeAccountMoney(itemName, count)

				TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
					account.addMoney(count)
				end)

				exports['exile_logs']:SendLog(xPlayer.source, "Włożono brudną gotówkę: " .. count .. " do szafki: "..scriptJob, scriptJob, '3447003')
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nieprawidłowa ilość")
			end
		end
	else
		if xPlayer then
			exports['exile_logs']:SendLog(xPlayer.source, 'putItemInStock - Wykryto próbę włożenia przedmiotu bez odpowiedniej pracy - ' ..scriptJob, 'anticheat')
		end
	end
end)

RegisterServerEvent('exile:addItemToStock')
AddEventHandler('exile:addItemToStock', function(_source, itemType, itemName, count, society)
	local source = _source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local scriptJob = string.sub(society, 9)
	if xPlayer.job.name == scriptJob or xPlayer.secondjob.name == scriptJob or xPlayer.thirdjob.name == scriptJob then
		if itemType == 'item_standard' then
			TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
				local inventoryItem = inventory.getItem(itemName)
				inventory.addItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Włożono ~y~" .. inventoryItem.label .. " ~b~x" .. count .. "~w~ do szafki firmy")
				exports['exile_logs']:SendLog(_source, "Włożono " .. inventoryItem.label .. " x" .. count .. " do szafki: "..scriptJob, scriptJob, '3447003')
			end)
		end
	else
		if xPlayer then
			exports['exile_logs']:SendLog(_source, 'addItemToStock - Wykryto próbę włożenia przedmiotu bez odpowiedniej pracy - ' .. string.upper(scriptJob), 'anticheat')
		end
	end
end)

ESX.RegisterServerCallback('exile:isUsed', function(source, cb, tName, society)
	if tName == 'Inventories' then
		if Inventories[society] == true then
			cb(true)
		else
			cb(false)
		end
	elseif tName == 'Weapons' then
		if Weapons[society] == true then
			cb(true)
		else
			cb(false)
		end
	end
end)

RegisterServerEvent('exile:setUsed')
AddEventHandler('exile:setUsed', function(tName, society, boolean)
	if tName == 'Inventories' then
		Inventories[society] = boolean
	end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':showIdentify')
AddEventHandler(GetCurrentResourceName() .. ':showIdentify', function(currentJob)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job = ""
	local job_grade = 0
	if xPlayer.job.name == currentJob then
		job = xPlayer.job.label
		job_grade = xPlayer.job.grade_label
	elseif xPlayer.secondjob.name == currentJob then
		job = xPlayer.secondjob.label
		job_grade = xPlayer.secondjob.grade_label
	elseif xPlayer.thirdjob.name == currentJob then
		job = xPlayer.thirdjob.label
		job_grade = xPlayer.thirdjob.grade_label
	end
	if xPlayer ~= nil then
		TriggerClientEvent(GetCurrentResourceName() .. ':sendProx', -1, _source, xPlayer.character.firstname .. " " .. xPlayer.character.lastname, job, job_grade, xPlayer.character.phone_number)
	end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':giveWeapon')
AddEventHandler(GetCurrentResourceName() .. ':giveWeapon', function(name, quantity)
	local xPlayer = ESX.GetPlayerFromId(source)
	if name == 'GADGET_PARACHUTE' then
		xPlayer.addInventoryItem(name, tonumber(quantity))
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to spawn weapons without job")
	end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':giveItem')
AddEventHandler(GetCurrentResourceName() .. ':giveItem', function(name, quantity)
	local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(name)
    
	if name == 'nurek_1' or name == 'nurek_2' or name == 'nurek_3' or name == 'nurek_4' or name == 'nurek_5' or name == 'nurek_6' or name == 'beer' or name == 'vodka' or name == 'whisky' or name == 'tequila' or name == 'burbon' or name == 'aperitif' or name == 'cydr' or name == 'koniak' then
		if item.limit ~= -1 and item.count >= item.limit then
			TriggerClientEvent('esx:showNotification', source, "~r~Nie uniesiesz więcej " .. item.label)
		else
			xPlayer.addInventoryItem(name, quantity)
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to spawn items without job")
	end
end)

local Clothes = {
	'nurek_1',
	'nurek_2',
	'nurek_3',
	'nurek_4',
	'nurek_5',
	'nurek_6',
	'nurek_sasp',
	'nurek_sasd',
}

CreateThread(function()
	for i=1, #Clothes, 1 do
		ESX.RegisterUsableItem(Clothes[i], function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeInventoryItem(Clothes[i], 1)
			TriggerClientEvent('exile_legaljobs:putOnClothes', source, Clothes[i])
		end)
	end
end)

local Alcohols = {
	{
		name = 'beer',
		label = "piwo",
		status = 150000
	},
	{
		name = 'vodka',
		label = "setkę wódki",
		status = 250000
	},
	{
		name = 'shot',
		label = "30 ml czystej wódki",
		status = 250000
	},
	{
		name = 'drink',
		label = "drinka",
		status = 250000
	},
	{
		name = 'whisky',
		label = "100ml czystej szkockiej",
		status = 300000
	},
	{
		name = 'tequila',
		label = "setkę pysznej tequili",
		status = 300000
	},
	{
		name = 'burbon',
		label = "szklankę burbonu",
		status = 250000
	},
	{
		name = 'aperitif',
		label = "kieliszek aperitif",
		status = 300000
	},
	{
		name = 'cydr',
		label = "butelkę cydru",
		status = 250000
	},
	{
		name = 'koniak',
		label = "200ml koniaku",
		status = 350000
	},
}

CreateThread(function()
	for i=1, #Alcohols, 1 do
		ESX.RegisterUsableItem(Alcohols[i].name, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeInventoryItem(Alcohols[i].name, 1)
			TriggerClientEvent('esx_status:add', source, 'drunk', Alcohols[i].status)
			TriggerClientEvent('esx_optionalneeds:onDrink', source)
			TriggerClientEvent('esx:showNotification', source, "Wypiłeś/aś ~y~" .. Alcohols[i].label)
		end)
	end
end)

RegisterServerEvent('exile:pay')
AddEventHandler('exile:pay', function(cash)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  xPlayer.removeAccountMoney('bank', cash)
  xPlayer.showNotification('~w~Zapłaciłeś ~g~' ..cash.. ' ~w~za usługę.')
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil then
		local societyOrg = 'society_'..xPlayer.thirdjob.name
		local societyHidden = 'society_'..xPlayer.secondjob.name
		local societyLegal = 'society_'..xPlayer.job.name
		
		if Inventories[societyHidden] or Inventories[societyLegal] or Inventories[societyOrg] then
			if Inventories[societyHidden] then
				TriggerEvent('exile:setUsed', 'Inventories', societyHidden, false)
			elseif Inventories[societyLegal] then
				TriggerEvent('exile:setUsed', 'Inventories', societyLegal, false)
			elseif Inventories[societyOrg] then
				TriggerEvent('exile:setUsed', 'Inventories', societyOrg, false)
			end
		end
	end
end)

ESX.RegisterServerCallback('falszywyy-listing:getJob', function(source, cb)
	MySQL.query('SELECT * FROM jobs WHERE whitelisted = ?', {false}, function(result)
		local data = {}

		for i=1, #result, 1 do
			table.insert(data, {
				value = result[i].name,
				label = result[i].label
			})
		end

		cb(data)
	end)
end)

RegisterServerEvent('falszywyy-listing:getcityhallexilejob')
AddEventHandler('falszywyy-listing:getcityhallexilejob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer then
		xPlayer.setSecondJob(job, 0)
		exports['exile_logs']:SendLog(source, 'Zatrudnił się z Urzędu w pracy: '..job, 'boss_menu', '5793266')
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Zatrudniono w nowej pracy!')
	end
end)