local connected = false

AddEventHandler("playerSpawned", function()
	if not connected then
		TriggerServerEvent("exile_queue:playerConnected")
		connected = true
	end
end)