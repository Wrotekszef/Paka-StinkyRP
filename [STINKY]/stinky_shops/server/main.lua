RegisterServerEvent('e-shops:buynewItem')
AddEventHandler('e-shops:buynewItem', function(itemName, amount, price, itemlimit, moneytype, zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	amount = ESX.Round(amount)

	if amount < 0 then
		return
	end
	
	if type(price) == 'string' then
		price = tonumber(price)
	end

	if price ~= nil and amount ~= nil then
		price = price * amount
		local jebacciemoney = 0
		if moneytype == "stinkycoin" then
			jebacciemoney = xPlayer.getInventoryItem("stinkycoin").count
		else
			jebacciemoney = xPlayer.getAccount(moneytype).money
		end
		local missingMoney = (jebacciemoney - price) * -1
		if jebacciemoney >= price then
			local item = xPlayer.getInventoryItem(itemName)
			
			if item ~= nil then
				if itemName == 'sim' then			
					ESX.CreateDynamicItem({
						type = 'sim',
						owner = xPlayer.identifier,
						ownerdigit = xPlayer.digit,
						blocked = 0,
						admin1 = '',
						admindigit1 = '',			
						admin2 = '',
						admindigit2 = '',
					}, function(data, number)
						xPlayer.showNotification("Kupiłeś nowy starter #" .. number)
						xPlayer.addInventoryItem(data, 1)
						xPlayer.removeAccountMoney(moneytype, price)	
					end)
				else
					local count = 0

					for k,v in pairs(Config.Zones[zone].Items) do
						if v.item == itemName then
							count = 1
						end
					end

					if count > 1 then
						TriggerEvent('exilerp_scripts:banPlr', "nigger", _source, "Event-detected (e-shops)")
					else
						if itemlimit ~= nil then
							if itemlimit < amount or (item.count + amount) > itemlimit then
								xPlayer.showNotification('~r~Nie masz~s~ tyle ~y~wolnego miejsca ~s~ w ekwipunku!')
							else
								if moneytype == "stinkycoin" then
									xPlayer.removeInventoryItem("stinkycoin", price)
								else
									xPlayer.removeAccountMoney(moneytype, price)	
								end
								xPlayer.addInventoryItem(itemName, (zone == "Kasyno" and amount*100 or amount))
							end	
						end						
					end
				end
			end
		else
			xPlayer.showNotification('~r~Nie masz tyle '..(moneytype == 'money' and 'gotówki' or 'pieniędzy na karcie')..', brakuje ci ~g~$'.. missingMoney..'~r~!')
		end
	end
end)

local SellTrigger = 'e-shops:sellItem'..math.random(111111,999999)
local recived_token_shops = {}
RegisterServerEvent(SellTrigger)
AddEventHandler(SellTrigger, function(resourceName,itemName)
	local src = source
	if itemName == "phone" or itemName == "obraczka" or itemName == "bizuteria" or itemName == "handcuff" or itemName == "krotkofalowka" or itemName == "fixkit2" or itemName == "gopro" or itemName == "bon1" or itemName == "classic_phone" then
		if resourceName == GetCurrentResourceName() then
			local xPlayer = ESX.GetPlayerFromId(src)
			local xItem = xPlayer.getInventoryItem(itemName)
			if xItem.count <= xItem.limit then
				for k,v in pairs(Config.LombardItems) do
					if xItem.count > 0 then
						if itemName == v.item then
							local cena = xItem.count * v.price
							xPlayer.removeInventoryItem(itemName, xItem.count)
							xPlayer.addMoney(cena)
						end
					else
						TriggerClientEvent('esx:showNotification', src, 'Nie posiadasz tego przedmiotu w ekwipunku')
					end
				end
			end
		else
			TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Tried to bypass (e-shops)")
		end
	else
		TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Tried to give item (e-shops)")
	end
end)

ESX.RegisterServerCallback('e-phone:getHasSims', function(source, cb, admin)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	if admin then		
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)	
		local Items = ESX.GetItems()
		local result = {}

		for k,v in pairs(Items) do			
			if v.type == 'sim' then
				if (v.data.owner == xPlayer.identifier and v.data.ownerdigit == xPlayer.digit) or (v.data.admin1 == xPlayer.identifier and v.data.admindigit1 == xPlayer.digit) or (v.data.admin2 == xPlayer.identifier and v.data.admindigit2 == xPlayer.digit) then
					if v.data.mainsim == true then
						table.insert(result, v.data)
					end
				end
			end
		end
		cb(result)  
	else	
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local Items = ESX.GetItems()
		local result = {}

		for k,v in pairs(Items) do
			if v.type == 'sim' then
				if v.data.owner == xPlayer.identifier and v.data.ownerdigit == xPlayer.digit then
					if v.data.mainsim == true then
						table.insert(result, v.data)
					end
				end
			end
		end	
		cb(result)  
	end
end)

ESX.RegisterServerCallback('e-phone:getHasSimsCopy', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local Items = ESX.GetItems()
	local result = {}

	for k,v in pairs(Items) do
		if v.type == 'sim' then
			if v.data.owner == xPlayer.identifier and v.data.ownerdigit == xPlayer.digit then
				if v.data.mainsim == true then
					table.insert(result, v.data)
				end
			end
		end
	end

	cb(result, xPlayer.character.phone_number)  
end)

RegisterServerEvent('e-shops:request')
AddEventHandler('e-shops:request', function()
	local src = source
	if not recived_token_shops[src] then
		TriggerClientEvent("e-shops:getrequest", src, SellTrigger)
		recived_token_shops[src] = true
	else
		TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Tried to get token (e-shops)")
	end
end)

AddEventHandler('playerDropped', function()
	local src = source
    recived_token_shops[src] = nil
end)