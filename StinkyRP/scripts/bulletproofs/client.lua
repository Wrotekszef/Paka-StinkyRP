local PlayerPedId = PlayerPedId
local SetPedComponentVariation = SetPedComponentVariation
local SetPedArmour = SetPedArmour
local FreezeEntityPosition = FreezeEntityPosition
local playerPed = PlayerPedId()

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        Wait(500)
    end
end)

RegisterNetEvent('exile_kamza')
AddEventHandler('exile_kamza', function(typ)
	if typ == 'small' then
        SetPedArmour(playerPed, 25)
		ESX.PlayAnim('clothingshirt', 'try_shirt_neutral_c', 8.0, -1, 0)
		Wait(1000)
		SetPedComponentVariation(playerPed, 9, 11, 0, 2)
	elseif typ == 'big' then
        SetPedArmour(playerPed, 50)
		ESX.PlayAnim('clothingshirt', 'try_shirt_neutral_c', 8.0, -1, 0)
		Wait(1000)
		SetPedComponentVariation(playerPed, 9, 11, 1, 2)
	elseif typ == 'swat' then
        SetPedArmour(playerPed, 99)
		ESX.PlayAnim('clothingshirt', 'try_shirt_neutral_c', 8.0, -1, 0)
		Wait(1000)
		SetPedComponentVariation(playerPed, 9, 11, 1, 2)
	end
end)

RegisterNetEvent('falszywyy_barylki:mieszaczmenu')
AddEventHandler('falszywyy_barylki:mieszaczmenu', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mieszaczmenu', {
		title    = 'Mieszacz Narkotyków',
		align    = 'bottom-right',
		elements = {
			{label = 'Baryłka Marihuany (30g)', value = 'barylkaziola'},
			{label = 'Baryłka Metaamfetaminy (30g)', value = 'barylkametaamfetaminy'},
			{label = 'Baryłka Kokainy (30g)', value = 'barylkakokainy'},
			{label = 'Baryłka Opium (30g)', value = 'barylkaopium'},
			{label = 'Baryłka Kokainy Perico (30g)', value = 'barylkakokiperico'},
			{label = 'Baryłka OG Haze (30g)', value = 'barylkaoghaze'},
		}
	}, function(data2, menu2)
		if data2.current.value == 'barylkaoghaze' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie substancji", false, function(cb) 
				if cb then
					TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
					Wait(100)
					exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, function(cb) 
						if cb then
							Wait(100)
							TriggerServerEvent("falszywyy_barylki:mieszacz",'barylkaoghaze')
							FreezeEntityPosition(playerPed, false)
							Wait(1500)
						end
					end)
				end
			end)	
		elseif data2.current.value == 'barylkaziola' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie substancji", false, function(cb) 
				if cb then
					TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
					Wait(100)
					exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, function(cb) 
						if cb then
							Wait(100)
							TriggerServerEvent("falszywyy_barylki:mieszacz",'weed')
							FreezeEntityPosition(playerPed, false)
							Wait(1500)
						end
					end)
				end
			end)
		elseif data2.current.value == 'barylkametaamfetaminy' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, function(cb) 
				if cb then
					TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
					Wait(100)
					exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, function(cb) 
						if cb then
							Wait(100)
							TriggerServerEvent("falszywyy_barylki:mieszacz",'meth')
							FreezeEntityPosition(playerPed, false)
							Wait(1500)
						end
					end)
				end
			end)
		elseif data2.current.value == 'barylkakokainy' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, function(cb) 
				if cb then
					TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
					Wait(100)
					exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, function(cb) 
						if cb then
							Wait(100)
							TriggerServerEvent("falszywyy_barylki:mieszacz",'coke')
							FreezeEntityPosition(playerPed, false)
							Wait(1500)
						end
					end)
				end
			end)
		elseif data2.current.value == 'barylkaopium' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, function(cb) 
				if cb then
					TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
					Wait(100)
					exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, function(cb) 
						if cb then
							Wait(100)
							TriggerServerEvent("falszywyy_barylki:mieszacz",'opium')
							FreezeEntityPosition(playerPed, false)
							Wait(1500)
						end
					end)
				end
			end)
		elseif data2.current.value == 'barylkakokiperico' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, function(cb) 
				if cb then
					TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
					Wait(100)
					exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, function(cb) 
						if cb then
							Wait(100)
							TriggerServerEvent("falszywyy_barylki:mieszacz",'cokeperico')
							FreezeEntityPosition(playerPed, false)
							Wait(1500)
						end
					end)
				end
			end)
		end	
	end, function(data2, menu2)
		menu2.close()
	end)
end)