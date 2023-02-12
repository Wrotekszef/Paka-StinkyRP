local cancollect  = false
local PlayersHarvesting		   = {}
local recived_token_slaughter = {}

local TRIGGER_SELL = "exile_legalrzeznik:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_legalrzeznik:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local function Harvest(source, name)
	SetTimeout(60000, function()
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                xPlayer.showNotification('Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_legalrzeznik:Cancel', source)
                TriggerEvent("exile_legalrzeznik:stopPickup")
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

RegisterServerEvent('exile_legalrzeznik:collect')
AddEventHandler('exile_legalrzeznik:collect', function(name)

	local _source = source
    if name == "slaughtered_chicken" then
        local xPlayer  = ESX.GetPlayerFromId(source)
        if xPlayer.getInventoryItem('slaughtered_chicken').count == 0 then
            PlayersHarvesting[_source] = true
            xPlayer.showNotification('~y~Trwa zbieranie zapakowanego kurczaka')
            Harvest(_source, name)
        else
            xPlayer.showNotification('~r~Nie możesz zbierać zapakowanego kurczaka posiadając zapakowanego kurczaka!')
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
        if xPlayer.secondjob.name == 'slaughter' then
            if xPlayer.getInventoryItem('packaged_chicken').count == 0 then
                if countBefore >= 100 then
                    local xItem = xPlayer.getInventoryItem('slaughtered_chicken')
                    if xItem.count == 100 then
                        local itemCount = math.floor((countBefore / 10))
                        xPlayer.removeInventoryItem('slaughtered_chicken', itemCount * 10)
                        Paycheck('slaughter', xPlayer)
                        if itemCount >= 1 then
                            TriggerEvent('ExileRP:saveCours', xPlayer.secondjob.name, xPlayer.secondjob.grade, xPlayer.source)
                        end
                    else
                        exports['exile_logs']:SendLog(_source, 'SLAUGHTER: Próba zbugowania przeróbki! - gracz próbował przerabiać z ' .. xItem.count .. ' kurczakami (100 wymagane)', 'anticheat', '15844367')
                    end
                else
                    exports['exile_logs']:SendLog(_source, "SLAUGHTER OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
                end
            else
                xPlayer.showNotification('~r~Nie możesz przerabiać zapakowanego kurczaka posiadając zapakowanego kurczaka!')
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
	if secondjob == 'slaughter' then
		if xPlayer.secondjob.grade == 9 then
			total = 24500
		elseif xPlayer.secondjob.grade == 8 then
			total = 23500
		elseif xPlayer.secondjob.grade == 7 then
			total = 22500
		elseif xPlayer.secondjob.grade == 6 then
			total = 21500
		elseif xPlayer.secondjob.grade == 5 then
            total = 20500
        elseif xPlayer.secondjob.grade == 4 then
            total = 19500
        elseif xPlayer.secondjob.grade == 3 then
            total = 18500
        elseif xPlayer.secondjob.grade == 2 then
            total = 17500
        elseif xPlayer.secondjob.grade == 1 then
			total = 16500
		elseif xPlayer.secondjob.grade == 0 then
            total = 15500
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
        exports['exile_logs']:SendLog(xPlayer.source, "SLAUGHTER: Zakończono kurs. Zarobek: " ..total.. "$", 'slaughter', '15844367')
        local chanceToDrop = math.random(1, 100)
        if chanceToDrop < 6 then
            xPlayer.addInventoryItem('czekoladka', 1)
            xPlayer.showNotification('~o~Otrzymano Czekoladki x1, gratulacje!')
        end
	end
end

RegisterServerEvent('exile_legalrzeznik:stopPickup')
AddEventHandler('exile_legalrzeznik:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
    TriggerClientEvent('exile_legalrzeznik:Cancel', source)
end)

RegisterServerEvent('exile_legalrzeznik:request')
AddEventHandler('exile_legalrzeznik:request', function()
	if not recived_token_slaughter[source] then
		TriggerClientEvent("exile_legalrzeznik:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING)
		recived_token_slaughter[source] = true
	else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_slaughter[source] = nil
    PlayersHarvesting[source] = nil
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	PlayersHarvesting[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_legalrzeznik:insertPlayer')
AddEventHandler('exile_legalrzeznik:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_legalrzeznik:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)