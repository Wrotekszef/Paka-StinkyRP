local PlayersHarvesting		   = {}
local recived_token_uwucafe = {}

local TRIGGER_SELL = "exile_legaluwucafe:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_legaluwucafe:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local function Harvest(source, name)
	SetTimeout(60000, function()
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                xPlayer.showNotification('Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_legaluwucafe:Cancel', source)
                TriggerEvent("exile_legaluwucafe:stopPickup")
			else
				xPlayer.addInventoryItem(name, 20)
				Harvest(source, name)
			end
		else
			return
		end
	end)
end

function SalaryCheck(grade)
    if grade == 9 then
        return true
    else
        return false
    end
end

RegisterServerEvent('exile_legaluwucafe:collect')
AddEventHandler('exile_legaluwucafe:collect', function(name)
	local _source = source
    if name == "herbata" then
        local xPlayer  = ESX.GetPlayerFromId(source)
        if xPlayer.getInventoryItem('herbata').count == 0 then
            PlayersHarvesting[_source] = true
            xPlayer.showNotification('~y~Trwa zbieranie herbaty')
            Harvest(_source, name)
        else
            xPlayer.showNotification('~r~Nie możesz zbierać herbaty posiadając herbatę!')
        end
    else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", source, string.format("Tried to get item %s (Prace legalne)", name))
    end
end)

RegisterServerEvent(TRIGGER_TRANSFERING)
AddEventHandler(TRIGGER_TRANSFERING, function(countBefore, token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if SERVER_TOKEN == token then
        if xPlayer.secondjob.name == 'uwucafe' then
            if xPlayer.getInventoryItem('zapakowanaherbata').count == 0 then
                if countBefore >= 100 then
                    local xItem = xPlayer.getInventoryItem('herbata')
                    if xItem.count == 100 then
                        local itemCount = math.floor((countBefore / 10))
                        xPlayer.removeInventoryItem('herbata', itemCount * 10)
                        Paycheck('uwucafe', xPlayer)
                        if itemCount >= 1 then
                            TriggerEvent('ExileRP:saveCours', xPlayer.secondjob.name, xPlayer.secondjob.grade, xPlayer.source)
                        end
                    else
                        exports['exile_logs']:SendLog(_source, 'UWUCAFE: Próba zbugowania przeróbki! - gracz próbował przerabiać z ' .. xItem.count .. ' herbaty (100 wymagane)', 'anticheat', '15844367')
                    end
                else
                    exports['exile_logs']:SendLog(_source, "UWUCAFE OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
                end
            else
                xPlayer.showNotification('~r~Nie możesz przerabiać herbaty posiadając Zapakowaną Herbatkę!')
            end
        else
            TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to collect item without secondjob (Prace legalne)")
        end
    else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to collect item with wrong token (Prace legalne)")
    end
end)

Paycheck = function(secondjob, xPlayer)
	local total = nil
	if secondjob == 'uwucafe' then
		if xPlayer.secondjob.grade == 9 then
			total = 24500*2
		elseif xPlayer.secondjob.grade == 8 then
			total = 23500*2
		elseif xPlayer.secondjob.grade == 7 then
			total = 22500*2
		elseif xPlayer.secondjob.grade == 6 then
			total = 21500*2
		elseif xPlayer.secondjob.grade == 5 then
            total = 20500*2
        elseif xPlayer.secondjob.grade == 4 then
            total = 19500*2
        elseif xPlayer.secondjob.grade == 3 then
            total = 18500*2
        elseif xPlayer.secondjob.grade == 2 then
            total = 17500*2
        elseif xPlayer.secondjob.grade == 1 then
			total = 16500*2
		elseif xPlayer.secondjob.grade == 0 then
            total = 15500*2
		end

        if xPlayer.group == 'vip' then
            total = (total*1.25)
        end
        
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..secondjob, function(account)
            account.addAccountMoney(total / 100 * 10)
        end)

        xPlayer.addMoney(total)
        xPlayer.addInventoryItem('kwiatki', 9)
        xPlayer.showNotification('Otrzymano ~o~9x Kwiatki')
        xPlayer.showNotification('Otrzymano ~g~'..total..'$ ~s~za dostarczenie.')
        exports['exile_logs']:SendLog(xPlayer.source, "UwU CAFE: Zakończono kurs. Zarobek: " ..total.. "$", 'uwucafe', '15844367')
        local chanceToDrop = math.random(1, 100)
        if chanceToDrop < 6 then
            xPlayer.addInventoryItem('czekoladka', 1)
            xPlayer.showNotification('~o~Otrzymano Czekoladka x1, gratulacje!')
        end
	end
end

RegisterServerEvent('exile_legaluwucafe:stopPickup')
AddEventHandler('exile_legaluwucafe:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
    TriggerClientEvent('exile_legaluwucafe:Cancel', source)
end)

RegisterServerEvent('exile_legaluwucafe:request')
AddEventHandler('exile_legaluwucafe:request', function()
	if not recived_token_uwucafe[source] then
		TriggerClientEvent("exile_legaluwucafe:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING)
		recived_token_uwucafe[source] = true
	else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_uwucafe[source] = nil
    PlayersHarvesting[source] = nil
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	PlayersHarvesting[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_legaluwucafe:insertPlayer')
AddEventHandler('exile_legaluwucafe:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_legaluwucafe:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)