local cancollect  = false
local PlayersHarvesting		   = {}
local recived_token_burgershot = {}

local TRIGGER_SELL = "exile_legalburgershot:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_legalburgershot:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local function Harvest(source, name)
	SetTimeout(60000, function()
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                xPlayer.showNotification('Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_legalburgershot:Cancel', source)
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

RegisterServerEvent('exile_legalburgershot:collect')
AddEventHandler('exile_legalburgershot:collect', function(name)

	local _source = source
    if name == "skladniki" then
        local xPlayer  = ESX.GetPlayerFromId(source)
        if xPlayer.getInventoryItem('skladniki').count == 0 then
            PlayersHarvesting[_source] = true
            xPlayer.showNotification('~y~Trwa zbieranie składników')
            Harvest(_source, name)
        else
            xPlayer.showNotification('~r~Nie możesz zbierać składników posiadając składników!')
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
        if xPlayer.secondjob.name == 'burgershot' then
            if xPlayer.getInventoryItem('burger').count == 0 then
                if countBefore >= 100 then
                    local xItem = xPlayer.getInventoryItem('skladniki')
                    if xItem.count == 100 then
                        local itemCount = math.floor((countBefore / 10))
                        xPlayer.removeInventoryItem('skladniki', itemCount * 10)
                        Paycheck('burgershot', xPlayer)
                        if itemCount >= 1 then
                            TriggerEvent('ExileRP:saveCours', xPlayer.secondjob.name, xPlayer.secondjob.grade, xPlayer.source)
                        end
                    else
                        exports['exile_logs']:SendLog(_source, 'BURGERSHOT: Próba zbugowania przeróbki! - gracz próbował przerabiać z ' .. xItem.count .. ' skladnikami (100 wymagane)', 'anticheat', '15844367')
                    end
                else
                    exports['exile_logs']:SendLog(_source, "BURGERSHOT OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
                end
            else
                xPlayer.showNotification('~r~Nie możesz przerabiać składników posiadając burgera!')
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
	if secondjob == 'burgershot' then
		if xPlayer.secondjob.grade == 9 then
			total = 58000                                ---29400 
		elseif xPlayer.secondjob.grade == 8 then
			total =  56000                                 ---28200
		elseif xPlayer.secondjob.grade == 7 then
			total =  54000                        ---27000
		elseif xPlayer.secondjob.grade == 6 then
			total =  50000                                 ---25800
		elseif xPlayer.secondjob.grade == 5 then
            total =  48000                          ---24600
        elseif xPlayer.secondjob.grade == 4 then
            total =   44000                 ---22200
        elseif xPlayer.secondjob.grade == 3 then
            total =   41000                              ---21000
        elseif xPlayer.secondjob.grade == 2 then
            total =   39000              ---19800
        elseif xPlayer.secondjob.grade == 1 then
			total =   37000                        ---18600
		elseif xPlayer.secondjob.grade == 0 then
            total =   35000                        ---17400
		end

        if xPlayer.group == 'vip' then
            total = (total*1.25)
        end
        
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..secondjob, function(account)
            account.addAccountMoney(total / 100 * 10)
        end)
        xPlayer.addInventoryItem('kwiatki', 9)
        xPlayer.showNotification('Otrzymano ~o~9x Kwiatki')
        xPlayer.addMoney(total)
        xPlayer.showNotification('Otrzymano ~g~'..total..'$ ~s~za dostarczenie.')
        exports['exile_logs']:SendLog(xPlayer.source, "BURGERSHOT: Zakończono kurs. Zarobek: " ..total.. "$", 'burgershot', '15844367')
        local chanceToDrop = math.random(1, 100)
        if chanceToDrop < 6 then
            xPlayer.addInventoryItem('czekoladka', 1)
            xPlayer.showNotification('~o~Otrzymano Czekoladki x1, gratulacje!')
        end
	end
end

RegisterServerEvent('exile_legalburgershot:stopPickup')
AddEventHandler('exile_legalburgershot:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
    TriggerClientEvent('exile_legalburgershot:Cancel', source)
end)

RegisterServerEvent('exile_legalburgershot:request')
AddEventHandler('exile_legalburgershot:request', function()
	if not recived_token_burgershot[source] then
		TriggerClientEvent("exile_legalburgershot:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING)
		recived_token_burgershot[source] = true
	else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_burgershot[source] = nil
    PlayersHarvesting[source] = nil
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	PlayersHarvesting[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_legalburgershot:insertPlayer')
AddEventHandler('exile_legalburgershot:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_legalburgershot:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)