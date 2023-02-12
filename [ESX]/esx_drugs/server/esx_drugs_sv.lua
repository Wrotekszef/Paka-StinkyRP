local PlayersHarvesting		   = {}
local TimeToFarm = 2500
local TimeToProcess = 10000

RegisterServerEvent('esx_drugs:stopDrugs')
AddEventHandler('esx_drugs:stopDrugs', function()
	local _source = source
	PlayersHarvesting[_source] = nil
end)

RegisterServerEvent(GetCurrentResourceName() .. ':zbierajnarkos')
AddEventHandler(GetCurrentResourceName() .. ':zbierajnarkos', function(name)
    local _source = source
    PlayersHarvesting[_source] = true

    if PlayersHarvesting[_source] == true then
        local xPlayer  = ESX.GetPlayerFromId(_source)
        local item = xPlayer.getInventoryItem(name)
		if item ~= nil then
			if item.limit ~= -1 and item.count >= 141 then
				TriggerClientEvent('esx:showNotification', _source, 'Nie możesz już zbierać, Twój ekwipunek jest ~r~pełen~s~')
			else
				PlayersHarvesting[_source] = nil

				exports['exile_logs']:SendLog(source, "Zbieranie: " .. name .. " x10", 'drugs', '3066993')
				xPlayer.addInventoryItem(name, 10)
			end
		else
			PlayersHarvesting[_source] = nil
		end
    else
        return
    end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':przerabiajkolego')
AddEventHandler(GetCurrentResourceName() .. ':przerabiajkolego', function(name, name2)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if PlayersHarvesting[_source] == nil then
		PlayersHarvesting[_source] = true
		local pooch = xPlayer.getInventoryItem(name2..'_pooch')
		local itemQuantity = xPlayer.getInventoryItem(name).count
		local poochQuantity = xPlayer.getInventoryItem(name2..'_pooch').count
		if pooch ~= nil and itemQuantity ~= nil and poochQuantity ~= nil then
			if pooch.limit ~= -1 and poochQuantity >= pooch.limit then
				TriggerClientEvent('esx:showNotification', _source, '~r~Masz zbyt wiele woreczków!')
				
				PlayersHarvesting[_source] = nil
			elseif itemQuantity < 5 then
				TriggerClientEvent('esx:showNotification', _source, 'Nie masz wystarczająco narkotyku, aby go ~r~przetworzyć~s~')
				
				PlayersHarvesting[_source] = nil
			else
				xPlayer.removeInventoryItem(name, 5)
				xPlayer.addInventoryItem(name2 .. '_pooch', 1)
				exports['exile_logs']:SendLog(_source, "Przetwarzanie: " .. name2 .. "_pooch x1", 'drugs', '3447003')
				
				PlayersHarvesting[_source] = nil
			end
		end
	end
end)

local AuthorizedClients = {}
local Zones = {
    MethField          = {
        x = 350.52, y = 3393.34, z = 35.65,
        name = "Pole metamfetaminy",
        db_item = 'meth',
        sprite = 499,
        color = 26
    },
    MethProcessing     = {
        x = -1601.37, y = 5205.23, z = 3.45,
        name = "Przetwarzanie metamfetaminy",
        required = 'meth', 
        db_item = 'meth_pooch', 
        sprite = 499,
        color = 26
    },
    WeedField         = {
        x = 2224.0434570313, y = 5576.9633789063, z = 53.84631729126-0.95,
        name = "Pole marihuany",
        db_item = 'weed',
        sprite = 496,
        color = 52
    },
    WeedProcessing     = {
        x = 1263.27, y = 345.27, z = 81.10,
        name = "Przetwarzanie marihuany",
        required = 'weed', 
        db_item = 'weed_pooch'
    },

	CokeField         = {x = -2422.4240722656, y = 2552.3557128906, z = 2.7265448570251-0.87,         name = "Pole kokainy",     db_item = 'coke',                sprite = 501,    color = 40},
    CokeProcessing     = {x = 541.61, y = 3100.81, z = 39.45,          name = "Przetwarzanie kokainy",     required = 'coke', db_item = 'coke_pooch',        sprite = 478,    color = 40},

    CokePericoField         = {x = 999, y = 999, z = -999,         name = "Pole kokainy Perico",     db_item = 'cokeperico',                sprite = 501,    color = 40}, 
    CokePericoProcessing     = {x = 999, y = 999, z = -999,         name = "Przetwarzanie kokainy Perico",    required = 'cokeperico', db_item = 'cokeperico_pooch',        sprite = 478,    color = 40},

    OpiumField          = {x = 1011.2738, y = -3199.0823, z = -39.9431,        name = "Pole opium",    db_item = 'opium',                sprite = 501,    color = 26},
    OpiumProcessing     = {x = 1160.7366, y = -3191.6396, z = -39.9579,        name = "Przetwarzanie opium",    required = 'opium', db_item = 'opium_pooch',        sprite = 501,    color = 26},

	ExctasyField         = {x = 1102.3658447266, y = -3100.0686035156, z = -38.99995803833-0.90,         name = "Pole Ekstazy",     db_item = 'mdp2p',                sprite = 501,    color = 40},
    ExctasyProcessing     = {x = 1100.6724853516, y = -3196.1242675781, z = -38.993465423584-0.90,          name = "Przetwarzanie Ekstazy",     required = 'mdp2p', db_item = 'exctasy_pooch',        sprite = 478,    color = 40},

    OgHazeProcessing     = {x = 1607.86, y = -1690.91, z = 87.20,        name = "Przetwarzanie marihuany na OG Haze",    required = 'weed', db_item = 'oghaze_pooch',        sprite = 501,    color = 26},

    MilkjuiceField          = {x = 2368.3408, y = 3056.6101, z = 1047.3546,            name = "Pole soku mlecznego",        db_item = 'milkjuice',            sprite = 501,    color = 26},
	--
}

RegisterServerEvent('exile_drugs:getInventory')
AddEventHandler('exile_drugs:getInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local count = 0
	local itemName = nil
	local itemRequired = nil
	if xPlayer then
		for i, data in pairs(Zones) do
			if i == currentZone then
				if string.find(currentZone, "Processing") then
					count = xPlayer.getInventoryItem(data.db_item).count
					itemName = data.db_item
					itemRequired = xPlayer.getInventoryItem(data.required).count
				else
					count = xPlayer.getInventoryItem(data.db_item).count
					itemName = data.db_item
				end
				break
			end
		end
		TriggerClientEvent('exile_drugs:returnInventory', _source, count, itemName, itemRequired, xPlayer.job.name, currentZone)
	end
end)

RegisterServerEvent('drugs:registerClient')
AddEventHandler('drugs:registerClient', function(_eventName)
	local _source = source
	local _sourceName = GetPlayerName(_source)
	local _sourceIdentifier = GetPlayerIdentifier(_source, 0)

	if _sourceIdentifier ~= nil then
		if (AuthorizedClients[_sourceIdentifier:lower()] == nil) then
			AuthorizedClients[_sourceIdentifier:lower()] = _eventName
			TriggerClientEvent(AuthorizedClients[_sourceIdentifier:lower()], _source, Zones)
		end
	end
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local _sourceName = GetPlayerName(_source)
	local _sourceIdentifier = GetPlayerIdentifier(_source, 0)

	if (AuthorizedClients[_sourceIdentifier:lower()] ~= nil) then
		AuthorizedClients[_sourceIdentifier:lower()] = nil
	end
end)