RegisterServerEvent("exile_houses_crime:rentMagazine", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local money = xPlayer.getMoney()
        if money >= Config.Cost then
            MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit AND buyed = 1", {
                ["@identifier"] = xPlayer.getIdentifier(),
                ["@digit"] = xPlayer.getDigit()
            }, function(res) 
                if res[1] then
                    xPlayer.showNotification("~r~Posiadasz już wykupiony magazyn!")
                else
                    money = xPlayer.getMoney()
                    if money >= Config.Cost then
                        MySQL.Async.execute("DELETE FROM `exile_houses_crime` WHERE identifier = @identifier AND digit = @digit",{
                            ["@identifier"] = xPlayer.getIdentifier(),
                            ["@digit"] = xPlayer.getDigit()
                        })
                        local expires = os.time()+(Config.ExtendDuration*7)
                        local date = os.date("%d.%m.%Y %H:%M", expires)
                        xPlayer.removeMoney(Config.Cost)
                        MySQL.Async.execute("INSERT INTO `exile_houses_crime` (`identifier`, `digit`, `coowner`, `coowner_digit`, `coowner1`, `coowner1_digit`, `coowner2`, `coowner2_digit`, `coowner3`, `coowner3_digit`, `coowner4`, `coowner4_digit`, `storage_level`, `coowner_level`, `buyed`, `expire`, `bucket`) VALUES (@identifier, @digit, '', '1', '', '1', '', '1', '', '1', '', '1', '1', '1', '1', @expire, @bucket)", {
                            ["@identifier"]=xPlayer.getIdentifier(),
                            ["@digit"]=xPlayer.getDigit(), 
                            ["@expire"]=expires,
                            ["@bucket"] = math.random(10000000,99999999)
                        }, function() 
                            MySQL.query('SELECT * FROM exile_houses_crime WHERE identifier = @identifier', {["@identifier"]=xPlayer.getIdentifier()}, function(crime_resultt)
                                if crime_resultt[1] then
                                    local crime_result = crime_resultt[1]
                                    TriggerEvent("exilerp:addonInventory", crime_result)
                                    TriggerEvent("exilerp:addAccount", crime_result)
                                end
                            end)
                            TriggerClientEvent("exile_houses_crime:updateMagazines", xPlayer.source)
                        end)
                        xPlayer.showNotification("~g~Zakupiono magazyn! Jest on ważny do ~c~"..date)
                    else
                        xPlayer.showNotification("~r~Nie stać Cie na zakup tego magazynu! Brakuje Ci ~g~"..(Config.Cost-money).."$")
                    end
                end
            end)
        else
            xPlayer.showNotification("~r~Nie stać Cie na zakup tego magazynu! Brakuje Ci ~g~"..(Config.Cost-money).."$")
        end
    end
end)

RegisterServerEvent("exile_houses_crime:extendMagazine", function(days) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        if not tonumber(days) then return end
        local cost = days*Config.CostExtend
        local money = xPlayer.getMoney()
        local bank = xPlayer.getAccount("bank").money
        local paymentType = ""
        if money >= cost then
            paymentType = "money"
        elseif bank >= cost then
            paymentType = "bank"
        else
            xPlayer.showNotification("~g~Nie stać Cię na opłacenie magazynu na ~c~"..days.." ~g~dni.")
            return
        end
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit()
        }, function(res) 
            if res[1] then
                if paymentType == "money" then
                    xPlayer.removeMoney(cost)
                elseif paymentType == "bank" then
                    xPlayer.removeAccountMoney('bank', cost)
                end
                if os.time() > res[1].expire then
                    res[1].expire = os.time()
                end
                local expires = res[1].expire+(Config.ExtendDuration*days)
                local date = os.date("%d.%m.%Y %H:%M", expires)
                MySQL.Async.execute("UPDATE exile_houses_crime SET expire = @expires WHERE id = @id", {
                    ["@expires"] = expires,
                    ["@id"] = res[1].id
                }, function() 
                    TriggerClientEvent("exile_houses_crime:openMenu", xPlayer.source)
                    TriggerClientEvent("exile_houses_crime:updateMagazines", xPlayer.source)
                end)
                if not tonumber(res[1].buyed) then
                    MySQL.Async.execute("UPDATE exile_houses_crime SET buyed = 1 WHERE id = @id", {
                        ["@id"] = res[1].id
                    })
                end
                xPlayer.showNotification("~g~Przedłużono magazyn do ~c~"..date.." ~g~"..(paymentType == "money" and "gotówką" or "kartą"))
            else
                xPlayer.showNotification("~r~Nie posiadasz nawet magazynu ¯\\_(ツ)_/¯")
            end
        end)
    end
end)

ESX.RegisterServerCallback("exile_houses_crime:getCoowners", function(source, cb) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit()
        }, function(res) 
            if res[1] then
                local identifiers = {res[1].coowner, res[1].coowner1, res[1].coowner2, res[1].coowner3, res[1].coowner4}
                local coownersA = {}
                local moznajaknajbardziej = false
                for k,v in pairs(identifiers) do
                    MySQL.query('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
                    {
                        ['@identifier'] = v,
                    }, function(dane)
                        if dane[1] then
                            coownersA[tostring(v)] = dane[1].firstname.." "..dane[1].lastname
                        end
                        if tostring(k) == "5" then
                            moznajaknajbardziej = true
                        end
                    end)
                end
                while not moznajaknajbardziej do
                    Citizen.Wait(69)
                end
                cb(coownersA)
            else
                xPlayer.showNotification("~r~Nie posiadasz wykupionego magazynu!")
            end
        end)
    end
end)

ESX.RegisterServerCallback('exile_houses_crime:getMagazineInventory', function(source, cb, owner, magazine)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}

	TriggerEvent('esx_addonaccount:getSharedAccount', 'crimehouse' .. magazine, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'crimehouse' .. magazine, function(inventory)
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

RegisterServerEvent('exile_houses_crime:getItem')
AddEventHandler('exile_houses_crime:getItem', function(owner, type, item, count, property)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		TriggerEvent('esx_addoninventory:getSharedInventory', 'crimehouse' .. property, function(inventory)
			local inventoryItem = inventory.getItem(item)
				local sourceItem = xPlayer.getInventoryItem(item)

			if count > 0 and inventoryItem.count >= count then
			
				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, "~r~Nie uniesiesz tyle")
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, "~g~Wyciągnięto ~c~x"..count.." "..inventoryItem.label)
					exports['exile_logs']:SendLog(_source, "[MAGAZYN] Wyciągnięto przedmiot: " .. item .. " x" .. count, 'magazyn', '2123412')
				end
			else
				TriggerClientEvent('esx:showNotification', _source, "~r~Nie masz tyle w szafce!")
			end
		end)

	elseif type == 'item_account' then

		TriggerEvent('esx_addonaccount:getSharedAccount', 'crimehouse' .. property, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
                xPlayer.showNotification("~r~Wyciągnięto brudną gotówkę w ilości: ".. count .. "$")
				exports['exile_logs']:SendLog(_source, "[MAGAZYN] Wyciągnięto brudną gotówkę: " .. count .. "$", 'magazyn', '10181046')
			else
				TriggerClientEvent('esx:showNotification', _source, "~r~Nieprawidłowa ilość")
				
			end
		end)
	end

end)

RegisterServerEvent('exile_houses_crime:putItem')
AddEventHandler('exile_houses_crime:putItem', function(owner, type, item, count, property)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

    -- check do sprwadzenia
    print(property)
    if property == nil then print("[exile_houses_crime]: property is nil (server.lua/208)") end

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'crimehouse'..property, function(inventory)
				local inventoryItem = inventory.getItem(item)
				local sourceItem = xPlayer.getInventoryItem(item)
				
				if sourceItem.limit ~= -1 and (inventoryItem.count + count) > (sourceItem.limit * 5) then
					TriggerClientEvent('esx:showNotification', _source, "~r~Nie masz odpowiednio dużo miejsca w mieszkaniu")
				else
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, "~g~Włożono ~c~x"..count.." "..inventory.getItem(item).label)
					exports['exile_logs']:SendLog(_source, "[MAGAZYN] Włożono przedmiot: " .. item .. " x" .. count, 'magazyn', '2123412')
				end
				
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Nieprawidłowa ilość")
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'crimehouse'..property, function(account)
				account.addMoney(count)
			end)

            xPlayer.showNotification('~r~Włożono brudną gotówkę: ' .. count .. '$')
			exports['exile_logs']:SendLog(_source, "[MAGAZYN] Włożono brudną gotówkę: " .. count .. "$", 'magazyn', '10181046')
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Nieprawidłowa ilość")
		end
	end

end)

ESX.RegisterServerCallback('exile_houses_crime:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)


ESX.RegisterServerCallback("exile_houses_crime:fetchMagazines", function(source, cb) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local magazines = {owner={},coowner={}}
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit()
        }, function(res) 
            if res[1] then
                local date = os.date("%d.%m.%Y %H:%M", res[1].expire)
                res[1].expires = date
                table.insert(magazines.owner, res[1])
            end
            MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE (coowner = @identifier AND coowner_digit = @digit) OR (coowner1 = @identifier AND coowner1_digit = @digit) OR (coowner2 = @identifier AND coowner2_digit = @digit) OR (coowner3 = @identifier AND coowner3_digit = @digit) OR (coowner4 = @identifier AND coowner4_digit = @digit)", {
                ["@identifier"] = xPlayer.getIdentifier(),
                ["@digit"] = xPlayer.getDigit()
            }, function(ress) 
                if ress[1] then
                    for i=0, #ress, 1 do
                        table.insert(magazines.coowner, ress[i])
                    end
                end
                cb(magazines)
            end)
        end)
    end
end)

function setCoowner(id, which, identifier, digit,id1,id2) 
    MySQL.Async.execute("UPDATE exile_houses_crime SET "..which.." = @identifier, "..(which..'_digit').." = @digit WHERE id = @id", {
        ["@identifier"] = identifier,
        ['@digit'] = digit,
        ["@id"]=id
    })
    TriggerClientEvent("exile_houses_crime:updateMagazines", id1)
    TriggerClientEvent("exile_houses_crime:updateMagazines", id2)
    TriggerClientEvent("exile_houses_crime:openMenu", id1)
end

RegisterServerEvent("exile_houses_crime:addCoOwner", function(id) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(id)
    if src == id then return end
    if xPlayer and tPlayer then
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit(),
        }, function(res) 
            if res[1] then
                local buyed = tonumber(res[1].buyed)
                if not buyed then
                    xPlayer.showNotification("~r~Musisz pierw opłacić swój magazyn!")
                    return
                end
                local lvl = res[1].coowner_level
                local t = nil
                if res[1].coowner == nil or res[1].coowner == "" then
                    t = "coowner"
                elseif (res[1].coowner1 == nil or res[1].coowner1 == "") and lvl > 1 then
                    t = "coowner1"
                elseif (res[1].coowner2 == nil or res[1].coowner2 == "") and lvl > 2 then
                    t = "coowner2"
                elseif (res[1].coowner3 == nil or res[1].coowner3 == "") and lvl > 3 then
                    t = "coowner3"
                elseif (res[1].coowner4 == nil or res[1].coowner4 == "") and lvl > 4 then
                    t = "coowner4"
                end
                if t == nil then
                    local str = "~r~Brak wolnych slotów na współwłaścicielu!"
                    if tonumber(lvl) ~= 5 then
                        str = str.." ~g~Możesz dokupić jeszcze ~c~"..5-tonumber(lvl).." ~g~slotów."
                    end
                    xPlayer.showNotification(str)
                    return
                end
                xPlayer.showNotification("~g~Nadano współwłaściciela dla ID ~c~"..id)
                setCoowner(res[1].id, t, tPlayer.getIdentifier(), tPlayer.getDigit(), xPlayer.source, tPlayer.source)
            else
                xPlayer.showNotification("~r~Pierw musisz wykupić magazyn!")
            end
        end)
    end
end)

RegisterServerEvent("exile_houses_crime:removeCoOwner", function(identifier) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromIdentifier(identifier)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit(),
        }, function(res) 
            if res[1] then
                local buyed = tonumber(res[1].buyed)
                if not buyed then
                    xPlayer.showNotification("~r~Musisz pierw opłacić swój magazyn!")
                    return
                end
                local t = nil
                if res[1].coowner == identifier then
                    t = "coowner"
                elseif res[1].coowner1 == identifier then
                    t = "coowner1"
                elseif res[1].coowner2 == identifier then
                    t = "coowner2"
                elseif res[1].coowner3 == identifier then
                    t = "coowner3"
                elseif res[1].coowner4 == identifier then
                    t = "coowner4"
                end
                if t == nil then
                    xPlayer.showNotification("~r~Ta osoba nie ma już kluczy!")
                    return
                end
                xPlayer.showNotification("~g~Usunięto współwłaściciela")
                MySQL.Async.execute("UPDATE exile_houses_crime SET "..t.." = NULL WHERE id = @id", {
                    ["@id"] = res[1].id
                })
                TriggerClientEvent("exile_houses_crime:updateMagazines", xPlayer.source)
                TriggerClientEvent("exile_houses_crime:openMenu", xPlayer.source)
                if tPlayer then
                    TriggerClientEvent("exile_houses_crime:updateMagazines", tPlayer.source)
                end

            else
                xPlayer.showNotification("~r~Pierw musisz wykupić magazyn!")
            end
        end)
    end
end)

RegisterServerEvent("exile_houses_crime:magazineUpgrade", function(what) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE identifier = @identifier AND digit = @digit", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit(),
        }, function(res) 
            if res[1] then
                local buyed = tonumber(res[1].buyed)
                if not buyed then
                    xPlayer.showNotification("~r~Musisz pierw opłacić swój magazyn!")
                    return
                end
                local lvl = nil
                local maxlvl = 0
                local newlvl = 0
                local table = ""
                if what == "storage" then
                    lvl = res[1].storage_level
                    maxlvl = 4
                    table = "storage_level"
                elseif what == "coowner" then
                    lvl = res[1].coowner_level
                    maxlvl = 5
                    table = "coowner_level"
                end

                if lvl == nil then
                    return
                end
                if lvl == maxlvl then
                    xPlayer.showNotification("~r~Już masz to ulepszone maksymalnie!")
                    return
                else
                    if xPlayer.getMoney() >= 150000 then
                        xPlayer.removeMoney(150000)
                        newlvl = lvl+1
                        MySQL.Async.execute("UPDATE exile_houses_crime SET "..table.." = @newlvl WHERE id = @id", {
                            ["@newlvl"] = newlvl,
                            ["@id"] = res[1].id
                        })
                        TriggerClientEvent("exile_houses_crime:updateMagazines", xPlayer.source)
                        TriggerClientEvent("exile_houses_crime:openMenu", xPlayer.source)

                        xPlayer.showNotification("~g~Podwyższono poziom "..(what == "storage" and "magazynu" or "współwłaścicieli").." na ~c~"..newlvl.."/"..maxlvl)
                        xPlayer.showNotification("~b~Zapłacono 150.000$ w gotówce za współwłaścicieli")
                    elseif xPlayer.getMoney() < 150000 then
                        xPlayer.showNotification("~b~Nie posiadasz 150.000$ w gotówce aby opłacić tą opcje")
                        return
                    end 
                end
            else
                xPlayer.showNotification("~r~Pierw musisz wykupić magazyn!")
            end
        end)
    end
end)

RegisterServerEvent("exile_houses_crime:enterMagazine", function(id) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM exile_houses_crime WHERE ((identifier = @identifier AND digit = @digit) OR (coowner = @identifier AND coowner_digit = @digit) OR (coowner1 = @identifier AND coowner1_digit = @digit) OR (coowner2 = @identifier AND coowner2_digit = @digit) OR (coowner3 = @identifier AND coowner3_digit = @digit) OR (coowner4 = @identifier AND coowner4_digit = @digit)) AND id = @id", {
            ["@identifier"] = xPlayer.getIdentifier(),
            ["@digit"] = xPlayer.getDigit(),
            ["@id"] = id
        }, function(ress) 
            if ress[1] then
                local buyed = tonumber(ress[1].buyed)
                if os.time() >= ress[1].expire then
                    xPlayer.showNotification("~r~Ten magazyn wygasł!")
                    if buyed then
                        MySQL.Async.execute("UPDATE exile_houses_crime SET buyed = 0 WHERE id = @id", {
                            ["@id"]=id
                        })
                    end
                    return
                end
                TriggerClientEvent("exile_houses_crime:setCurrentMagazine", xPlayer.source, ress[1])
                local bucket = ress[1].bucket
                SetPlayerRoutingBucket(src, bucket)
                xPlayer.setCoords(Config.Interior)
                xPlayer.showNotification("~g~Wchodzisz do magazynu")
            end
        end)
    end
end)

RegisterServerEvent("exile_houses_crime:exitMagazine", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        SetPlayerRoutingBucket(src, 0)
        xPlayer.setCoords(Config.Enter)
        xPlayer.showNotification("~r~Opuszczasz magazyn")
        TriggerClientEvent("exile_houses_crime:updateMagazines", xPlayer.source)
    end
end)