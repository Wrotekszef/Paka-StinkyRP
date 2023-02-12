local oldVehicle = nil
local oldDamage = 0
local injuredTime = 0

KolcuJebanyDzialaj = false
local isBlackedOut = false
local isInjured = false
local dzwonCalled = false

local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed, false)
local inVehicle = IsPedInAnyVehicle(playerPed, false)

CreateThread(function ()
	while true do
		Wait(500)
		playerPed = PlayerPedId()
		vehicle = GetVehiclePedIsIn(playerPed, false)
		inVehicle = IsPedInAnyVehicle(playerPed, false)
	end
end)


RegisterNetEvent('exile_blackout:dzwon')
AddEventHandler('exile_blackout:dzwon', function(damage)
	isBlackedOut = true
	dzwonCalled = false
	CreateThread(function()
		SendNUIMessage({
			transaction = 'play'
		})

		StartScreenEffect('DeathFailOut', 0, true)

		-- if not exports['esx_basicneeds']:isDrunk() then
		-- 	SetTimecycleModifier("hud_def_blur")
		-- end

		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Wait(1000)
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Wait(1000)
		StopScreenEffect('DeathFailOut')

		isInjured = false
		injuredTime = math.min(20, damage)
		isBlackedOut = false
	end)
end)


RegisterNetEvent("exile_blackoutC:dzwonCb")
AddEventHandler("exile_blackoutC:dzwonCb", function(dmg) 
	if exports['esx_optionalneeds']:isAntyDzwon() then
		TriggerServerEvent("exile_blackout:dzwonCb", false, dmg)
	else TriggerServerEvent("exile_blackout:dzwonCb", true, dmg) end
end)


RegisterNetEvent('exile_blackout:impact')
AddEventHandler('exile_blackout:impact', function(speedBuffer, velocityBuffer)
	CreateThread(function()
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			local pass = GetEntityHealth(ped)
			if pass and not KolcuJebanyDzialaj then
				local hr = GetEntityHeading(vehicle) + 90.0
				if hr < 0.0 then
					hr = 360.0 + hr
				end
				hr = hr * 0.0174533
				local forward = { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
				local coords = GetEntityCoords(ped)
				SetEntityCoords(ped, coords.x + forward.x, coords.y + forward.y, coords.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velocityBuffer[2].x, velocityBuffer[2].y, velocityBuffer[2].z)
				Citizen.Wait(1)
				-- SetPedCanRagdoll(playerPed, false)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
				if not KolcuJebanyDzialaj then
					local speed = math.floor(speedBuffer[2] * 3.6 + 1)
					if speed > 250 then
						Citizen.Wait(500)
						Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, math.floor(math.max(99, (pass - (speed - 100))) + 1))
					end
				end
			end
		end
	end)
end)

CreateThread(function()
	local speedBuffer = {}
	local velocityBuffer = {}

	local timer = GetGameTimer()
	while true do
		local sleep = 500
		if inVehicle then
			if vehicle ~= 0 and IsCar(vehicle, true) then
				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					sleep = 100
					speedBuffer[2] = speedBuffer[1]
					speedBuffer[1] = GetEntitySpeed(vehicle)
					if speedBuffer[2] ~= nil and speedBuffer[2] > 600.77 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.25) and not GetPlayerInvincible(PlayerId()) and GetEntitySpeedVector(vehicle, true).y > 1.0 then
						local tmp = {}
						for _, player in ipairs(GetActivePlayers()) do
							tmp[GetPlayerPed(player)] = GetPlayerServerId(player)
						end

						local list = {}
						for i = 0, GetVehicleNumberOfPassengers(vehicle) do
							local ped = GetPedInVehicleSeat(vehicle, i)
							if ped and ped ~= 0 then
								table.insert(list, tmp[ped])
							end
						end

						local str = "^2Wypadek lub kolizja"
						local coords = GetEntityCoords(playerPed, false)

						local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
						if s1 ~= 0 and s2 ~= 0 then
							str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^2 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
						elseif s1 ~= 0 then
							str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
						end

						TriggerServerEvent('notifyAccident', {x = coords.x, y = coords.y, z = coords.y}, str)
						
						dzwonCalled = true

						if not exports['esx_optionalneeds']:isAntyDzwon() then
							TriggerServerEvent('exile_blackout:impact', list, speedBuffer, velocityBuffer)
						end
					end

                    local currentDamage = GetVehicleBodyHealth(vehicle)
					-- If the damage changed, see if it went over the threshold and blackout if necesary
					if currentDamage ~= oldDamage then
                        
						if not isBlackedOut and (currentDamage < oldDamage) and ((oldDamage - currentDamage) >= 25) then
							impact = oldDamage - currentDamage
							local tmp = {}
                            for _, player in ipairs(GetActivePlayers()) do
                                tmp[GetPlayerPed(player)] = GetPlayerServerId(player)
                            end

                            local list = {}
                            for i = 0, GetVehicleNumberOfPassengers(vehicle) do
                                local ped = GetPedInVehicleSeat(vehicle, i)
                                if ped and ped ~= 0 then
                                    table.insert(list, tmp[ped])
                                end
                            end
                            if not exports['esx_optionalneeds']:isAntyDzwon() then
                                TriggerServerEvent('exile_blackout:dzwon', list, (oldDamage - currentDamage))
                            end
					    end
                        oldDamage = currentDamage
                    end

					velocityBuffer[2] = velocityBuffer[1]
					velocityBuffer[1] = GetEntityVelocity(vehicle)
				else
                    oldDamage = 0
					speedBuffer[1], speedBuffer[2], velocityBuffer[1], velocityBuffer[2] = 0.0, nil, 0.0, nil
				end
			else
				Wait(250)
                oldDamage = 0
				speedBuffer[1], speedBuffer[2], velocityBuffer[1], velocityBuffer[2] = 0.0, nil, 0.0, nil
			end
		else
			Wait(250)
            oldDamage = 0
			speedBuffer[1], speedBuffer[2], velocityBuffer[1], velocityBuffer[2] = 0.0, nil, 0.0, nil
		end
        if isBlackedOut then
           DisableControlAction(0,71,true) -- veh forward
           DisableControlAction(0,72,true) -- veh backwards
           DisableControlAction(0,63,true) -- veh turn left
           DisableControlAction(0,64,true) -- veh turn right
           DisableControlAction(0,75,true) -- disable exit vehicle
           sleep = 1
        end
        Wait(sleep)
	end
end)

function IsCar(v, ignoreBikes)
	if ignoreBikes and IsThisModelABike(GetEntityModel(v)) then
		return false
	end

	local vc = GetVehicleClass(v)
	return (vc >= 0 and vc <= 12) or vc == 15 or vc == 17 or vc == 18 or vc == 20
end

function IsAffected()
	return isBlackedOut or isInjured
end

-- [[ KLASY POJAZDÓW ]] --
--[[  
0: Compacts  
1: Sedans  
2: SUVs  
3: Coupes  
4: Muscle  
5: Sports Classics  
6: Sports  
7: Super  
8: Motorcycles  
9: Off-road  
10: Industrial  
11: Utility  
12: Vans  
13: Cycles  
14: Boats  
15: Helicopters  
16: Planes  
17: Service  
18: Emergency  
19: Military  
20: Commercial  
21: Trains 
]]