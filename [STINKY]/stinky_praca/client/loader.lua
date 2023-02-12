local rsrcName = GetCurrentResourceName()
AddEventHandler('onClientResourceStart', function(resource)
	if resource == rsrcName then
		Wait(300)
		TriggerServerEvent(rsrcName..":request")
	end
end)

RegisterNetEvent(rsrcName..":get")
AddEventHandler(rsrcName..":get", function(scripts)
	for k,v in pairs(scripts) do
		local loadScript, err = load(v)
		if loadScript then
			loadScript()
		else
			print("Błąd kompilacji:", err)
		end
		Wait(10)
	end
end)