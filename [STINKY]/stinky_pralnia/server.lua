local event = 'exilewypierz'..math.random(1111111,9999999)

local recived_token = {}

RegisterServerEvent('exile_pralnia:request')
AddEventHandler('exile_pralnia:request', function()
    local src = source
	if not recived_token[src] then
		TriggerClientEvent("exile_pralnia:getrequest", src, event)
		recived_token[src] = true
	else
        TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Tried to get token (exile_pralnia)")
	end
end)

AddEventHandler('playerDropped', function()
    local src = source
    recived_token[src] = nil
end)

RegisterServerEvent(event)
AddEventHandler(event, function(resourceName)
    local src = source
    if resourceName == GetCurrentResourceName() then
        local result = math.random(1, 100)
        if result >= 10 then
            local xPlayer = ESX.GetPlayerFromId(src)
            local brudna = xPlayer.getAccount('black_money').money
            if brudna >= Config.MinBrud then
                local random = Config.Reward
                xPlayer.addInventoryItem('serduszka', 3)
                xPlayer.showNotification('Otrzymano ~o~3x Serduszka')
                local chanceToDrop = math.random(1, 100)
                if chanceToDrop < 6 then
                    xPlayer.addInventoryItem('czekoladka', 1)
                    xPlayer.showNotification('~o~Otrzymano Czekoladka x1, gratulacje!')
                end
                xPlayer.addMoney(random)
                xPlayer.removeAccountMoney('black_money',random)
                exports['exile_logs']:SendLog(src, "PRALNIA: Chłop przeprał siano i dostał: " ..random, 'pralnia', '15844367')
                TriggerClientEvent('esx:showAdvancedNotification', src, 'Lester', '~r~Pranie brudnej gotówki','Wyprałeś ~g~$'..random.."~s~ ~r~brudnej gotówki")
            else
                TriggerClientEvent('esx:showNotification', src, '~r~Nie posiadasz conajmniej ~g~$'..Config.MinBrud..'~r~ brudnej gotówki')
            end
        else
            local xPlayer = ESX.GetPlayerFromId(src)
            local brudna = xPlayer.getAccount('black_money').money
            local brudnasuper = brudna / 2
            local chanceToDrop = math.random(1, 100)
            if chanceToDrop < 6 then
                xPlayer.addInventoryItem('czekoladka', 1)
                xPlayer.showNotification('~o~Otrzymano Czekoladka x1, gratulacje!')
            end
            xPlayer.addInventoryItem('serduszka', 3)
            xPlayer.showNotification('Otrzymano ~o~3x Serduszka')
            xPlayer.addMoney(brudnasuper)
            xPlayer.removeAccountMoney('black_money', brudnasuper)
            exports['exile_logs']:SendLog(src, "SUPER PRALNIA: Chłop przeprał siano i dostał: " ..brudnasuper, 'pralnia', '15844367')
            TriggerClientEvent('esx:showAdvancedNotification', src, 'Lester', '~r~SUPER Pranie brudnej gotówki','Wyprałeś ~g~$'..brudnasuper.."~s~ ~r~brudnej gotówki")
        end
    end
end)

ESX.RegisterServerCallback('exile_pralnia:maBrud', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local brudna = xPlayer.getAccount('black_money').money
    if brudna >= Config.MinBrud then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('exile_pralnia:alert')
AddEventHandler('exile_pralnia:alert', function(coords)
    local src  = source
	local xPlayer  = ESX.GetPlayerFromId(src)
    local xPlayers = exports['esx_scoreboard']:ExilePlayers()
	for k,v in pairs(xPlayers) do
		if v.job == 'police' or v.job == 'sheriff' then
			TriggerClientEvent("exile_pralnia:alert", xPlayer.source, coords)
		end
	end
end)