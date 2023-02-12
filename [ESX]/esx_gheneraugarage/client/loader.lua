local rsrcName = GetCurrentResourceName()
AddEventHandler('onClientResourceStart', function(resource)
	if resource == rsrcName then
		TriggerServerEvent(rsrcName..":request")
	end
end)