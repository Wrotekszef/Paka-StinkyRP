local instanceAddons = {}

function GetinstanceAddondPlayers()
	local players = {}

	for k,v in pairs(instanceAddons) do
		for k2,v2 in ipairs(v.players) do
			players[v2] = true
		end
	end

	return players
end

AddEventHandler('playerDropped', function(reason)
	if instanceAddons[source] then
		CloseinstanceAddon(source)
	end
end)

function CreateinstanceAddon(type, player, data)
	instanceAddons[player] = {
		type    = type,
		host    = player,
		players = {},
		data    = data
	}

	TriggerEvent('instanceAddon:onCreate', instanceAddons[player])
	TriggerClientEvent('instanceAddon:onCreate', player, instanceAddons[player])
	TriggerClientEvent('instanceAddon:oninstanceAddondPlayersData', -1, GetinstanceAddondPlayers())
end

function CloseinstanceAddon(instanceAddon)
	if instanceAddons[instanceAddon] then

		for i=1, #instanceAddons[instanceAddon].players do
			TriggerClientEvent('instanceAddon:onClose', instanceAddons[instanceAddon].players[i])
		end

		instanceAddons[instanceAddon] = nil

		TriggerClientEvent('instanceAddon:oninstanceAddondPlayersData', -1, GetinstanceAddondPlayers())
		TriggerEvent('instanceAddon:onClose', instanceAddon)
	end
end

function AddPlayerToinstanceAddon(instanceAddon, player)
	local found = false

	for i=1, #instanceAddons[instanceAddon].players do
		if instanceAddons[instanceAddon].players[i] == player then
			found = true
			break
		end
	end

	if not found then
		table.insert(instanceAddons[instanceAddon].players, player)
	end

	TriggerClientEvent('instanceAddon:onEnter', player, instanceAddons[instanceAddon])

	for i=1, #instanceAddons[instanceAddon].players do
		if instanceAddons[instanceAddon].players[i] ~= player then
			TriggerClientEvent('instanceAddon:onPlayerEntered', instanceAddons[instanceAddon].players[i], instanceAddons[instanceAddon], player)
		end
	end

	TriggerClientEvent('instanceAddon:oninstanceAddondPlayersData', -1, GetinstanceAddondPlayers())
end

function RemovePlayerFrominstanceAddon(instanceAddon, player)
	if instanceAddons[instanceAddon] then
		TriggerClientEvent('instanceAddon:onLeave', player, instanceAddons[instanceAddon])

		if instanceAddons[instanceAddon].host == player then
			for i=1, #instanceAddons[instanceAddon].players do
				if instanceAddons[instanceAddon].players[i] ~= player then
					TriggerClientEvent('instanceAddon:onPlayerLeft', instanceAddons[instanceAddon].players[i], instanceAddons[instanceAddon], player)
				end
			end

			CloseinstanceAddon(instanceAddon)
		else
			for i=1, #instanceAddons[instanceAddon].players do
				if instanceAddons[instanceAddon].players[i] == player then
					instanceAddons[instanceAddon].players[i] = nil
				end
			end

			for i=1, #instanceAddons[instanceAddon].players do
				if instanceAddons[instanceAddon].players[i] ~= player then
					TriggerClientEvent('instanceAddon:onPlayerLeft', instanceAddons[instanceAddon].players[i], instanceAddons[instanceAddon], player)
				end

			end

			TriggerClientEvent('instanceAddon:oninstanceAddondPlayersData', -1, GetinstanceAddondPlayers())
		end
	end
end

function InvitePlayerToinstanceAddon(instanceAddon, type, player, data)
	TriggerClientEvent('instanceAddon:onInvite', player, instanceAddon, type, data)
end

RegisterServerEvent('instanceAddon:create')
AddEventHandler('instanceAddon:create', function(type, data)
	CreateinstanceAddon(type, source, data)
end)

RegisterServerEvent('instanceAddon:close')
AddEventHandler('instanceAddon:close', function()
	CloseinstanceAddon(source)
end)

RegisterServerEvent('instanceAddon:enter')
AddEventHandler('instanceAddon:enter', function(instanceAddon)
	AddPlayerToinstanceAddon(instanceAddon, source)
end)

RegisterServerEvent('instanceAddon:leave')
AddEventHandler('instanceAddon:leave', function(instanceAddon)
	local _source = source
	RemovePlayerFrominstanceAddon(instanceAddon, _source)
end)

RegisterServerEvent('instanceAddon:invite')
AddEventHandler('instanceAddon:invite', function(instanceAddon, type, player, data)
	InvitePlayerToinstanceAddon(instanceAddon, type, player, data)
end)
