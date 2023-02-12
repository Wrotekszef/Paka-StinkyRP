RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
  local playerPed = PlayerPedId()
  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  Wait(1000)
  ClearPedTasksImmediately(playerPed)
end)


RegisterNetEvent('esx_optionalneeds:smoke')
AddEventHandler('esx_optionalneeds:smoke', function()
  TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING", 0, 1)               
end)


RegisterNetEvent('esx_optionalneeds:OGHaze')
AddEventHandler('esx_optionalneeds:OGHaze', function()
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Wait(10000)
	ClearPedTasksImmediately(PlayerPedId())
	exports["acidtrip"]:DoAcid(120000)               
end)

RegisterNetEvent('esx_optionalneeds:Exctasy')
AddEventHandler('esx_optionalneeds:Exctasy', function()
	DoScreenFadeOut(2000)
	Wait(4000)
	if GetPedArmour(PlayerPedId()) < 10 then
		SetPedArmour(PlayerPedId(), 10)
	end
	ExecuteCommand('e lezenie5')
	Wait(14000)
	DoScreenFadeIn(2000)
	ESX.ShowNotification('Czujesz się niepokonany...')
	Wait(1000)
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('esx_optionalneeds:menucrushera')
AddEventHandler('esx_optionalneeds:menucrushera', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crushermenu', {
		title    = 'Crusher',
		align    = 'bottom-right',
		elements = {
			{label = 'Marihuana', value = 'marihuana'},
			{label = 'OG Haze', value = 'oghaze'},
		}
	}, function(data2, menu2)
		if data2.current.value == 'marihuana' then
			--menu2.close()
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent("esx_optionalneeds:crusher",'2')
			Wait(1500)
		elseif data2.current.value == 'oghaze' then
			--menu2.close()
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent("esx_optionalneeds:crusher",'1')
			Wait(1500)
		end	
	end, function(data2, menu2)
		menu2.close()
	end)
end)

-- [[ ANTY DZWON ]] --

local antydzown = false

RegisterNetEvent('esx_optionalneeds:AntyDzwon')
AddEventHandler('esx_optionalneeds:AntyDzwon', function()
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Wait(10000)
	ClearPedTasksImmediately(PlayerPedId())
	antydzown = true          
	print(antydzown)
	Wait(900000)
	antydzown = false
	print(antydzown)
end)

function isAntyDzwon()
	if antydzown == false then
		return false
	elseif antydzown == true then
		return true
	end
end