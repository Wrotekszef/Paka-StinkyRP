local Barabasz = {}
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId
local onBed = false
local playerPed = PlayerPedId()
local playercoords = GetEntityCoords(playerPed)

Barabasz.Zones = {
	Pos = {
		{
			Coords = vector3(1137.98, -1575.19, 35.38-0.95),
			Name = 'Clinic'
		},
	},
}

RegisterNetEvent('Exile:BarabaszAnim')
AddEventHandler('Exile:BarabaszAnim', function(id, zone, bed)
	onBed = true

	DoScreenFadeOut(200)
	Wait(1000)
	TriggerEvent('esx_ambulancejob:revive')
	Wait(1000)
	SetEntityCoordsNoOffset(playerPed, bed.Position, 0, 0, 0)
	SetEntityHeading(playerPed, bed.Position.w)

	ESX.Streaming.RequestAnimDict("missfbi5ig_0",function()
        TaskPlayAnim(playerPed, "missfbi5ig_0", "lyinginpain_loop_steve", 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)
	end)

	CreateThread(function()
        while onBed do
          	Wait(2)
          	DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(2, 200, true) -- Disable pause screen alternate
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 311, true) -- K
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
			DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
			DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
			DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
			DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
			DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
			DisableControlAction(0, 257, true) -- INPUT_ATTACK2
			DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
			DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
			DisableControlAction(0, 24, true) -- INPUT_ATTACK
			DisableControlAction(0, 25, true) -- INPUT_AIM
			DisableControlAction(0, 21, true) -- SHIFT
			DisableControlAction(0, 22, true) -- SPACE
			DisableControlAction(0, 288, true) -- F1
			DisableControlAction(0, 289, true) -- F2
			DisableControlAction(0, 170, true) -- F3
			DisableControlAction(0, 73, true) -- X
			DisableControlAction(0, 244, true) -- M
			DisableControlAction(0, 246, true) -- Y
			DisableControlAction(0, 74, true) -- H
			DisableControlAction(0, 29, true) -- B
			DisableControlAction(0, 243, true) -- ~
			DisableControlAction(0, 38, true) -- E
			DisableControlAction(0, 167, true) -- Job
			if not IsEntityPlayingAnim(playerPed, "missfbi5ig_0", "lyinginpain_loop_steve", 3) then
				TaskPlayAnim(playerPed, "missfbi5ig_0", "lyinginpain_loop_steve", 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)
			end
        end
    end)

	DoScreenFadeIn(200)


	exports["exile_taskbar"]:taskBar(25000, "Otrzymywanie pomocy medycznej", false, function(cb)
		if cb then
			onBed = false

			DoScreenFadeOut(200)
			Wait(500)
			ClearPedTasksImmediately(playerPed)
			Wait(500)
			SetEntityCoords(playerPed, bed.GetUp)
			SetEntityHeading(playerPed, bed.GetUp.w)
			TriggerServerEvent('Exile:BarabaszUnoccupied', id, zone)
			Wait(500)
	
			DoScreenFadeIn(200)
		end
	end)
end)

CreateThread(function()
    while true do
		Wait(3)
		local found = false
		for k,v in pairs(Barabasz.Zones) do
			for i=1, #v, 1 do
				local distance = #(playercoords - v[i].Coords)
				if distance < 6 then
					found = true
					ESX.DrawMarker(v[i].Coords)
					if distance < 1.5 then
						if not IsPedInAnyVehicle(playerPed, true) then
							ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby uzyskać ~y~pomoc medyczną~s~')
							if IsControlJustPressed(0, 46) or IsDisabledControlJustPressed(0, 46) and not onBed then
								if GetEntityHealth(playerPed) < 200 or exports["esx_ambulancejob"]:isDead() then
									ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(ExilePlayers)
										if ExilePlayers then
											if ExilePlayers['ambulance'] < 4 then
												PayMenu(ExilePlayers['ambulance'], v[i].Name)
											else
												ESX.ShowNotification('Nie możesz skorzystać z ~r~pomocy medycznej~w~ ponieważ na służbie jest już ~y~' .. ExilePlayers['ambulance'] .. ' medyków')
											end
										end
									end)
								else
									ESX.ShowNotification('~r~Nie potrzebujesz~w~ pomocy medycznej!')
								end
							end
						end
					end
				end
			end
		end

		if not found then
			Wait(1000)
		end
    end
end)

function PayMenu(a,b)
    local elements = {
        { label = 'Zapłać gotówką', value = 'money' },
        { label = 'Zapłać kartą', value = 'bank' },
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'paymenu',
    {
        title    = 'Wybierz sposób płatności',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        if data.current.value ~= nil then
            TriggerServerEvent('Exile:Barabasz', a,b,data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)

end