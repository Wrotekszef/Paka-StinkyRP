local nuiSC				= nil
local ScratchTable 		= {}
local payment			= 0

RegisterServerEvent('falszywyy_scratchcard:payment')
AddEventHandler('falszywyy_scratchcard:payment', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if ScratchTable[xPlayer.identifier] ~= nil then
		if ScratchTable[xPlayer.identifier] > 0 then
			TriggerClientEvent('esx:showNotification', _source, "~y~Wygrałeś ~g~$" .. ScratchTable[xPlayer.identifier])
			exports['exile_logs']:SendLog(source, "ZDRAPKA: " .. ' WYGRANO ' .. ScratchTable[xPlayer.identifier] .. '$', 'casino', '3066993')
			xPlayer.addMoney(ScratchTable[xPlayer.identifier])
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Spróbuj jeszcze raz")
		end
		ScratchTable[xPlayer.identifier] = nil
	else
		TriggerEvent('exilerp_scripts:banPlr', "nigger", _source, "Tried to cheat (exile_scratch)")
		--exports['exile_logs']:SendLog(_source, GetCurrentResourceName() .. ":payment - Wykryto próbę oszustwa", 'anticheat')
	end
end)

ScratchCard = function(source, type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local percent = math.random(1,100)
	if ScratchTable[xPlayer.identifier] == 0 then
		if type == 'silver' then
			if percent <= 20 then
				local whichPayment = math.random(1,100)
				if whichPayment <= 50 then
					payment = 8000
				elseif whichPayment > 50 and whichPayment <= 75 then
					payment = 11000
				elseif whichPayment > 75 and whichPayment <= 90 then
					payment = 14500
				elseif whichPayment > 90 and whichPayment <= 98 then
					payment = 18750
				elseif whichPayment > 98 then
					payment = 25000
				end
				ScratchTable[xPlayer.identifier] = payment
				TriggerClientEvent('falszywyy_scratchcard:showSC', _source, 'silver', payment)
			else
				payment = 0
				ScratchTable[xPlayer.identifier] = payment
				TriggerClientEvent('falszywyy_scratchcard:showSC', _source, 'silver', payment)
			end
		elseif type == 'gold' then
			if percent <= 15 then
				local whichPayment = math.random(1,100)
				if whichPayment <= 50 then
					payment = 45000
				elseif whichPayment > 50 and whichPayment <= 75 then
					payment = 56000
				elseif whichPayment > 75 and whichPayment <= 90 then
					payment = 75000
				elseif whichPayment > 90 and whichPayment <= 98 then
					payment = 90000
				elseif whichPayment > 98 then
					payment = 100000
				end
				ScratchTable[xPlayer.identifier] = payment
				TriggerClientEvent('falszywyy_scratchcard:showSC', _source, 'gold', payment)
			else
				payment = 0
				ScratchTable[xPlayer.identifier] = payment
				TriggerClientEvent('falszywyy_scratchcard:showSC', _source, 'gold', payment)
			end
		elseif type == 'diamond' then
			if percent <= 10 then
				local whichPayment = math.random(1,100)
				if whichPayment <= 50 then
					payment = 45000
				elseif whichPayment > 50 and whichPayment <= 75 then
					payment = 75000
				elseif whichPayment > 75 and whichPayment <= 90 then
					payment = 90000
				elseif whichPayment > 90 and whichPayment <= 98 then
					payment = 140000
				elseif whichPayment > 98 then
					payment = 180000
				end
				ScratchTable[xPlayer.identifier] = payment
				TriggerClientEvent('falszywyy_scratchcard:showSC', _source, 'diamond', payment)
			else
				payment = 0
				ScratchTable[xPlayer.identifier] = payment
				TriggerClientEvent('falszywyy_scratchcard:showSC', _source, 'diamond', payment)
			end
		end
	else
		TriggerEvent('exilerp_scripts:banPlr', "nigger", _source, "Tried to cheat (exile_scratch)")
		--exports['exile_logs']:SendLog(_source, GetCurrentResourceName() .. ":scratchCard - Wykryto próbę oszustwa", 'anticheat')
	end
end

ESX.RegisterUsableItem('scratchcard', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	if ScratchTable[xPlayer.identifier] == nil then
		ScratchTable[xPlayer.identifier] = 0
		xPlayer.removeInventoryItem('scratchcard', 1)
		ScratchCard(_source, 'silver')
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Poczekaj zanim zdrapiesz aktualną zdrapkę")
	end
end)

ESX.RegisterUsableItem('scratchcardgold', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	if ScratchTable[xPlayer.identifier] == nil then
		ScratchTable[xPlayer.identifier] = 0
		xPlayer.removeInventoryItem('scratchcardgold', 1)
		ScratchCard(_source, 'gold')
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Poczekaj zanim zdrapiesz aktualną zdrapkę")
	end
end)

ESX.RegisterUsableItem('scratchcarddiamond', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	if ScratchTable[xPlayer.identifier] == nil then
		ScratchTable[xPlayer.identifier] = 0
		xPlayer.removeInventoryItem('scratchcarddiamond', 1)
		ScratchCard(_source, 'diamond')
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Poczekaj zanim zdrapiesz aktualną zdrapkę")
	end
end)