local PlayersHarvesting		   = {}
local PlayersTransforming	   = {}
local TimeToFarm = 5000
local TimeToProcess = 20000
local TimeToSell = 10000
local AuthorizedKey = math.random(100,999)

local function Harvest(source, name)
	SetTimeout(TimeToFarm, function()
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
			local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
				TriggerClientEvent('esx:showNotification', source, 'Nie możesz już zbierać, Twój ekwipunek jest ~r~pełen~s~')
			else
				xPlayer.addInventoryItem(name, 10)
				--exports['exile_logs']:SendLog(source, "Zbieranie: " .. name .. " x1", 'drugs', '3066993')
				Harvest(source, name)
			end
		else
			return
		end
	end)
end

local function Transform(source, name, name2)
	SetTimeout(TimeToProcess, function()
		if PlayersTransforming[source] == true then
			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			local pooch = xPlayer.getInventoryItem(name2..'_pooch')
			local itemQuantity = xPlayer.getInventoryItem(name).count
			local poochQuantity = xPlayer.getInventoryItem(name2..'_pooch').count
			if pooch.limit ~= -1 and poochQuantity >= pooch.limit then
				TriggerClientEvent('esx:showNotification', source, '~r~Masz zbyt wiele słoików!')
			elseif itemQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczająco owoców, aby je ~r~przetworzyć~s~')
			else
				xPlayer.removeInventoryItem(name, 5)
				xPlayer.addInventoryItem(name2 .. '_pooch', 1)
				--exports['exile_logs']:SendLog(source, "Przetwarzanie: " .. name2 .. "_pooch x1", 'drugs', '3447003')
				Transform(source, name, name2)
			end
		else
			return
		end
	end)
end

TriggerEvent('ExileAC:addEvent', GetCurrentResourceName() .. ':zbieranko' .. AuthorizedKey)
RegisterServerEvent(GetCurrentResourceName() .. ':zbieranko' .. AuthorizedKey)
AddEventHandler(GetCurrentResourceName() .. ':zbieranko' .. AuthorizedKey, function(name)
	local _source = source
	PlayersHarvesting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, '~y~Zbieranie w trakcie~s~...')
	Harvest(_source, name)
end)

TriggerEvent('ExileAC:addEvent', GetCurrentResourceName() .. ':stopzbieranko' .. AuthorizedKey)
RegisterServerEvent(GetCurrentResourceName() .. ':stopzbieranko' .. AuthorizedKey)
AddEventHandler(GetCurrentResourceName() .. ':stopzbieranko' .. AuthorizedKey, function(zone)
	local _source = source
	PlayersHarvesting[_source] = false
end)

TriggerEvent('ExileAC:addEvent', GetCurrentResourceName() .. ':przerabianko' .. AuthorizedKey)
RegisterServerEvent(GetCurrentResourceName() .. ':przerabianko' .. AuthorizedKey)
AddEventHandler(GetCurrentResourceName() .. ':przerabianko' .. AuthorizedKey, function(name, name2)
	local _source = source
	PlayersTransforming[_source] = true
	TriggerClientEvent('esx:showNotification', _source, '~y~Przetwarzanie w trakcie~s~...')
	Transform(_source, name, name2)
end)

TriggerEvent('ExileAC:addEvent', GetCurrentResourceName() .. ':stopprzerabianko' .. AuthorizedKey)
RegisterServerEvent(GetCurrentResourceName() .. ':stopprzerabianko' .. AuthorizedKey)
AddEventHandler(GetCurrentResourceName() .. ':stopprzerabianko' .. AuthorizedKey, function(zone)
	local _source = source
	PlayersTransforming[_source] = false
end)

RegisterServerEvent('exile_items:getInventory')
AddEventHandler('exile_items:getInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('exile_items:returnInventory', 
		_source, 
		xPlayer.getInventoryItem('jablko').count,
		xPlayer.getInventoryItem('jablko_pooch').count,
		xPlayer.job.name,  
		currentZone
	)
end)

local AuthorizedClients = {}

local Zones = {
	JablkoField			= {x = 377.7537,    y = 6505.4761,    z = 27.0032, 	name = "Pole Jabłek",				sprite = 496,	color = 52},
	JablkoField2		= {x = 362.9311,    y = 6505.3452,    z = 27.5885, 	name = "Pole Jabłek",				sprite = 496,	color = 52},
	JablkoField3		= {x = 347.5314,    y = 6504.9077,    z = 27.8674, 	name = "Pole Jabłek",          		sprite = 496,	color = 52},
	JablkoProcessing 	= {x = 408.09, y = 6496.95, z = 27.83, 	name = "Przetwarzanie Jabłek",		sprite = 496,	color = 52},
	
}

RegisterServerEvent('exile_items:registerClient')
AddEventHandler('exile_items:registerClient', function(_eventName)
	local _source = source
	local _sourceName = GetPlayerName(_source)
	local _sourceIdentifier = GetPlayerIdentifier(_source, 0)

	if (AuthorizedClients[_sourceIdentifier:lower()] == nil) then
		AuthorizedClients[_sourceIdentifier:lower()] = _eventName
		TriggerClientEvent(AuthorizedClients[_sourceIdentifier:lower()], _source, Zones, AuthorizedKey)
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