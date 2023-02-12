local alert = nil
local alertOwner = nil

RegisterNetEvent('esx_addons_gcphone:call')
AddEventHandler('esx_addons_gcphone:call', function(data)  
	local cbs = function(msg)
		if msg ~= nil and msg ~= "" then
			local coords = GetEntityCoords(PlayerPedId(), false)			
			TriggerServerEvent('esx_addons_gcphone:startCall', data.number, msg, {
				x = coords.x,
				y = coords.y,
				z = coords.z
			})
		end
	end
  
	if data.message == nil then
		TriggerEvent('falszywyy:keyboard', function(value)
		  cbs(value)
		end, {
		  limit = 255,
		  type = 'textarea',
		  title = 'Wpisz wiadomość:'
		})
	else 
		cbs(data.message)
	end
end)


CreateThread(function()
	while true do
		Wait(10)
		if alert ~= nil then	
		
            SetTextComponentFormat("STRING")
            AddTextComponentString("Nacisnij ~INPUT_PICKUP~ aby, zaakceptowac\nNaciśnij ~INPUT_VEH_DUCK~ aby, odrzucić")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			


			if IsControlJustReleased(0, 38) then
				AcceptAlert(alert, alertOwner)
				Wait(10)
				alert = nil	
				alertOwner = nil			
			end			
			if IsControlJustReleased(0, 73) then
				Wait(10)
				alert = nil	
				alertOwner = nil
			end
		else
			Wait(150)
		end
	end
end)

RegisterNetEvent("exile:notifAccepted", function(msg) 
	ESX.ShowNotification(msg)
end)

function AcceptAlert(data, aO)
	ClearGpsPlayerWaypoint()
	SetNewWaypoint(data.coords.x, data.coords.y)
	TriggerServerEvent("exile:przyjetoWezwanie", aO)
	TriggerServerEvent('esx_addons_gcphone:acceptedAlert', alert.number)
	
	alert = nil
end

RegisterNetEvent('esx_addons_gcphone:acceptClient')
AddEventHandler('esx_addons_gcphone:acceptClient', function(name)
	ESX.ShowNotification(name..' przyjął wezwanie')
	alert = nil
end)

RegisterNetEvent('genesis-alert:sendAlert')
AddEventHandler('genesis-alert:sendAlert', function(data, id)
	alert = data
	alertOwner = id
end)