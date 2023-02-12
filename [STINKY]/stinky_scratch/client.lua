local isScratching = false

RegisterNetEvent('falszywyy_scratchcard:showSC')
AddEventHandler('falszywyy_scratchcard:showSC', function(scratch, component)
	if isScratching == false then	
		isScratching = true
		CreateThread(function()
			Wait(100)
			TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, false)
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'showNUI', scratch = scratch, component = component})
		end)
	end
end)

RegisterNUICallback('NUIFocusOff', function()
		isScratching = false
		SetNuiFocus(false, false)
		ClearPedTasksImmediately(PlayerPedId())
		TriggerServerEvent('falszywyy_scratchcard:payment')
end)

CreateThread(function()
	SetNuiFocus(false, false)
end)