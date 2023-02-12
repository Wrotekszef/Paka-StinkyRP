RegisterServerEvent('exile_heli:radius.up')
AddEventHandler('exile_heli:radius.up', function()
	local serverID = source
	TriggerClientEvent('exile_heli:radius.up', -1, serverID)
end)

RegisterServerEvent('exile_heli:radius.down')
AddEventHandler('exile_heli:radius.down', function()
	local serverID = source
	TriggerClientEvent('exile_heli:radius.down', -1, serverID)
end)