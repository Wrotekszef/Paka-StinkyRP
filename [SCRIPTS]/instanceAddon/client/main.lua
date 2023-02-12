local instanceAddon, instanceAddondPlayers, registeredinstanceAddonTypes, playersToHide = {}, {}, {}, {}
local instanceAddonInvite, insideinstanceAddon

function GetinstanceAddon()
	return instanceAddon
end

function CreateinstanceAddon(type, data)
	TriggerServerEvent('instanceAddon:create', type, data)
end

function CloseinstanceAddon()
	instanceAddon = {}
	TriggerServerEvent('instanceAddon:close')
	insideinstanceAddon = false
end

function EnterinstanceAddon(instanceAddon)
	insideinstanceAddon = true
	TriggerServerEvent('instanceAddon:enter', instanceAddon.host)

	if registeredinstanceAddonTypes[instanceAddon.type].enter then
		registeredinstanceAddonTypes[instanceAddon.type].enter(instanceAddon)
	end
end

function LeaveinstanceAddon()
	if instanceAddon.host then
		if #instanceAddon.players > 1 then
			ESX.ShowNotification(_U('left_instanceAddon'))
		end

		if registeredinstanceAddonTypes[instanceAddon.type].exit then
			registeredinstanceAddonTypes[instanceAddon.type].exit(instanceAddon)
		end

		TriggerServerEvent('instanceAddon:leave', instanceAddon.host)
	end

	insideinstanceAddon = false
end

function InviteToinstanceAddon(type, player, data)
	TriggerServerEvent('instanceAddon:invite', instanceAddon.host, type, player, data)
end

function RegisterinstanceAddonType(type, enter, exit)
	registeredinstanceAddonTypes[type] = {
		enter = enter,
		exit  = exit
	}
end

AddEventHandler('instanceAddon:get', function(cb)
	cb(GetinstanceAddon())
end)

AddEventHandler('instanceAddon:create', function(type, data)
	CreateinstanceAddon(type, data)
end)

AddEventHandler('instanceAddon:close', function()
	CloseinstanceAddon()
end)

AddEventHandler('instanceAddon:enter', function(_instanceAddon)
	EnterinstanceAddon(_instanceAddon)
end)

AddEventHandler('instanceAddon:leave', function()
	LeaveinstanceAddon()
end)

AddEventHandler('instanceAddon:invite', function(type, player, data)
	InviteToinstanceAddon(type, player, data)
end)

AddEventHandler('instanceAddon:registerType', function(name, enter, exit)
	RegisterinstanceAddonType(name, enter, exit)
end)

RegisterNetEvent('instanceAddon:oninstanceAddondPlayersData')
AddEventHandler('instanceAddon:oninstanceAddondPlayersData', function(_instanceAddondPlayers)
	instanceAddondPlayers = _instanceAddondPlayers
end)

RegisterNetEvent('instanceAddon:onCreate')
AddEventHandler('instanceAddon:onCreate', function(_instanceAddon)
	instanceAddon = {}
end)

RegisterNetEvent('instanceAddon:onEnter')
AddEventHandler('instanceAddon:onEnter', function(_instanceAddon)
	instanceAddon = _instanceAddon
end)

RegisterNetEvent('instanceAddon:onLeave')
AddEventHandler('instanceAddon:onLeave', function(_instanceAddon)
	instanceAddon = {}
end)

RegisterNetEvent('instanceAddon:onClose')
AddEventHandler('instanceAddon:onClose', function(_instanceAddon)
	instanceAddon = {}
end)

RegisterNetEvent('instanceAddon:onPlayerEntered')
AddEventHandler('instanceAddon:onPlayerEntered', function(_instanceAddon, player)
	instanceAddon = _instanceAddon
	local playerName = GetPlayerName(GetPlayerFromServerId(player))

	ESX.ShowNotification(_('entered_into', playerName))
end)

RegisterNetEvent('instanceAddon:onPlayerLeft')
AddEventHandler('instanceAddon:onPlayerLeft', function(_instanceAddon, player)
	instanceAddon = _instanceAddon
	local playerName = GetPlayerName(GetPlayerFromServerId(player))

	ESX.ShowNotification(_('left_out', playerName))
end)

RegisterNetEvent('instanceAddon:onInvite')
AddEventHandler('instanceAddon:onInvite', function(_instanceAddon, type, data)
	instanceAddonInvite = {
		type = type,
		host = _instanceAddon,
		data = data
	}

	CreateThread(function()
		Wait(10000)

		if instanceAddonInvite then
			ESX.ShowNotification(_U('invite_expired'))
			instanceAddonInvite = nil
		end
	end)
end)

RegisterinstanceAddonType('default')

-- Controls for invite
CreateThread(function()
	while true do
		Wait(0)

		if instanceAddonInvite then
			ESX.ShowHelpNotification(_U('press_to_enter'))

			if IsControlJustReleased(0, 38) then
				EnterinstanceAddon(instanceAddonInvite)
				ESX.ShowNotification(_U('entered_instanceAddon'))
				instanceAddonInvite = nil
			end
		else
			Wait(500)
		end
	end
end)

-- instanceAddon players
CreateThread(function()
	while true do
		Wait(1000)
		playersToHide = {}

		if instanceAddon.host then
			-- Get players and sets them as pairs
			for k,v in ipairs(GetActivePlayers()) do
				playersToHide[GetPlayerServerId(v)] = true
			end

			-- Dont set our instanceAddond players invisible
			for _,player in ipairs(instanceAddon.players) do
				playersToHide[player] = nil
			end
		else
			for player,_ in pairs(instanceAddondPlayers) do
				playersToHide[player] = true
			end
		end
	end
end)
local playerPed = PlayerPedId()

CreateThread(function()
	while true do
		Wait(500)
		playerPed = PlayerPedId()
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		sleep = true
		-- Hide all these players
		for serverId,_ in pairs(playersToHide) do
			local player = GetPlayerFromServerId(serverId)

			if NetworkIsPlayerActive(player) then
				local otherPlayerPed = GetPlayerPed(player)
				SetEntityVisible(otherPlayerPed, false, false)
				SetEntityNoCollisionEntity(playerPed, otherPlayerPed, false)
				sleep = false
			end
		end
		if sleep then
			Wait(500)
		end
	end
end)

CreateThread(function()
	TriggerEvent('instanceAddon:loaded')
end)

-- Fix vehicles randomly spawning nearby the player inside an instanceAddon
CreateThread(function()
	while true do
		Wait(0) -- must be run every frame

		if insideinstanceAddon then
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)

			local pos = GetEntityCoords(PlayerPedId())
			RemoveVehiclesFromGeneratorsInArea(pos.x - 900.0, pos.y - 900.0, pos.z - 900.0, pos.x + 900.0, pos.y + 900.0, pos.z + 900.0)
		else
			Wait(500)
		end
	end
end)