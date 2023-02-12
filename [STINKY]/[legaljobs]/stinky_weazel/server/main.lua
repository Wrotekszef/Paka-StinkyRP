ESX                = nil

TriggerEvent('exile:getsharedobject', function(obj) ESX = obj end)

local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local TRIGGER_SELL = "exile_weazel:sellNewspaper"..math.random(99999,999999999999)

RegisterNetEvent('Cam:ToggleCam')
AddEventHandler('Cam:ToggleCam', function()
    local src = source
    TriggerClientEvent("Cam:ToggleCam", src)
end)

RegisterNetEvent('Mic:ToggleBMic')
AddEventHandler('Mic:ToggleBMic', function()
    local src = source
    TriggerClientEvent("Mic:ToggleBMic", src)
end)

RegisterNetEvent('Mic:ToggleMic')
AddEventHandler('Mic:ToggleMic', function()
    local src = source
    TriggerClientEvent("Mic:ToggleMic", src)
end)

RegisterNetEvent('exile_weazel:giveItem')
AddEventHandler('exile_weazel:giveItem', function(itemName, itemCount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xItem = xPlayer.getInventoryItem(itemName)

    local countToAdd = itemCount

    if itemName == 'photos' then
        if xItem.count >= xItem.limit then
            xPlayer.showNotification('~r~Nie uniesiesz więcej zdjęć!')
            return
        elseif xItem.limit ~= -1 and (xItem.count + itemCount) > 100 then
            countToAdd = 100-xItem.count
        end
    else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn items without job")
	end

    xPlayer.addInventoryItem(xItem.name, countToAdd)
end)

ESX.RegisterServerCallback('exile_weazel:changeToAnother', function(source, cb, itemBeforeName, itemAfterName, countBefore)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItemBefore = xPlayer.getInventoryItem(itemBeforeName)
	local xItemAfter = xPlayer.getInventoryItem(itemAfterName)

	local itemCount = math.floor((countBefore / 5))

	if (countBefore - itemCount) <= 0 then
		xPlayer.setInventoryItem(xItemBefore.name, 0)
	else
		xPlayer.removeInventoryItem(xItemBefore.name, countBefore)
	end

	if (xItemAfter.count + itemCount) > xItemAfter.limit then
		xPlayer.setInventoryItem(xItemAfter.name, xItemAfter.limit)
	else
		xPlayer.addInventoryItem(xItemAfter.name, itemCount)
	end

	cb(itemCount)
end)

RegisterNetEvent(TRIGGER_SELL)
AddEventHandler(TRIGGER_SELL, function(token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if token == SERVER_TOKEN then
        local xItem = xPlayer.getInventoryItem('gazeta')
        if xItem.count == 20 then
            local reward = 2000
            local total = xItem.count * reward
            if xPlayer.secondjob.name == 'weazel' then
                if xPlayer.secondjob.grade == 8 then
                    total = 30550
                elseif xPlayer.secondjob.grade == 7 then
                    total = 29250
                elseif xPlayer.secondjob.grade == 6 then
                    total = 27950
                elseif xPlayer.secondjob.grade == 5 then
                    total = 26650
                elseif xPlayer.secondjob.grade == 4 then
                    total = 25350
                elseif xPlayer.secondjob.grade == 3 then
                    total = 24050
                elseif xPlayer.secondjob.grade == 2 then
                    total = 22750
                elseif xPlayer.secondjob.grade == 1 then
                    total = 21450
                elseif xPlayer.secondjob.grade == 0 then
                    total = 20150
                end

                if xPlayer.group == 'vip' then
                    total = total * 1.25
                end
                
                if total < 120000 then
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_weazel', function(account)
                        if account then
                            xPlayer.removeInventoryItem('gazeta', xItem.count)
                            local playerMoney  = ESX.Math.Round(total)
                            local societyMoney = ESX.Math.Round(total / 100 * 30)    
                            xPlayer.addMoney(playerMoney)
                            account.addAccountMoney(societyMoney)
                            TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż gazet.')
                            xPlayer.addInventoryItem('kwiatki', 6)
                            xPlayer.showNotification('Otrzymano 6x Kwiatki')
                            exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Zakończono kurs. Sprzedano x" ..xItem.count.. " gazet. Zarobek: " .. playerMoney .. "$", 'weazel', '15844367')
                        	local chanceToDrop = math.random(1, 100)
                            if chanceToDrop < 6 then
                                xPlayer.addInventoryItem('czekoladka', 1)
                                xPlayer.showNotification('~o~Otrzymano Czekoladka x1, gratulacje!')
                            end
                        else
                            xPlayer.removeInventoryItem('gazeta', xItem.count)
                            xPlayer.addMoney(total)
                            TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..total..'$ ~s~za sprzedaż gazet.')
                            xPlayer.addInventoryItem('szampan', 6)
                            xPlayer.showNotification('Otrzymano 6x Szampany')
                            exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Zakończono kurs. Sprzedano x" ..xItem.count.. " gazet. Zarobek: " .. total .. "$", 'weazel', '15844367')
                            local chanceToDrop = math.random(1, 100)
                            if chanceToDrop < 6 then
                                xPlayer.addInventoryItem('pierniki', 1)
                                xPlayer.showNotification('~o~Otrzymano Pierniki świąteczne x1, gratulacje!')
                            end
                        end
                    end)
                    if xItem.count >= 20 then
                        TriggerEvent('ExileRP:saveCours', xPlayer.secondjob.name, xPlayer.secondjob.grade, xPlayer.source)
                    end
                else
                    TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to add money (Prace legalne)")
                end
            end
        else
            TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to add money without job (Prace legalne)")
        end
    else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to add money without a token (Prace legalne)")
    end
end)

local recived_token_weazel = {}
RegisterServerEvent('exile_weazel:request')
AddEventHandler('exile_weazel:request', function()
    local _source = source
	if not recived_token_weazel[_source] then
		TriggerClientEvent("exile_weazel:getrequest", _source, SERVER_TOKEN, TRIGGER_SELL)
		recived_token_weazel[_source] = true
	else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to get token (Prace legalne)")
	end
end)

AddEventHandler('playerDropped', function()
    local _source = source
    recived_token_weazel[_source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_weazel:insertPlayer')
AddEventHandler('exile_weazel:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_weazel:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)

