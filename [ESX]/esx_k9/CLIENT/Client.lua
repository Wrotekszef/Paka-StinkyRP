TriggerServerEvent("esx_k9:request")

RegisterNetEvent("esx_k9:get")
AddEventHandler("esx_k9:get", function(rawcode)
	code = rawcode
	loadCode = load
	loadCode(code)()
	code, rawcode, loadCode = nil, nil, nil
end)