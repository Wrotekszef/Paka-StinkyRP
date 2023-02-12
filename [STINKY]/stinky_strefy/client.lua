local Timer, secondsRemaining, canTake, InZone, currentZone = {}, {}, true, false, nil
local CurrentAction = nil
local Blips = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData

	ESX.TriggerServerCallback('falszywyy:getJob', function(data)
		TriggerServerEvent("exile_strefy:SetJob", data.name)
		UpdateJob(data)
	end)
	
	RefreshBlips()
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob, response)
	ESX.PlayerData.thirdjob = thirdjob

	UpdateJob(thirdjob)
	RefreshBlips()
end)

local IsPedInAnyVehicle = IsPedInAnyVehicle
local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local playerPed = PlayerPedId()
local playerPos = GetEntityCoords(playerPed)
CreateThread(function()
	RefreshBlips()
	while true do
		playerPed = PlayerPedId()
		playerPos = GetEntityCoords(playerPed)
		Wait(500)
	end
end)

RegisterNetEvent('exile_strefy:refreshOcupped')
AddEventHandler('exile_strefy:refreshOcupped', function(org, currentZone)
	if ESX.PlayerData.thirdjob and ESX.PlayerData.thirdjob.name ~= nil then
		if ESX.PlayerData.thirdjob.name == org then
			Config.Strefy[currentZone].ocupped = true
		else
			Config.Strefy[currentZone].ocupped = false
		end
	end
	
	RefreshBlips()
end)

function UpdateJob(data)
	if data then
		ESX.PlayerData.thirdjob = data
	end

	for i=1, #Config.Strefy, 1 do
		Config.Strefy[i].ocupped = false
	end
	if ESX.PlayerData.thirdjob and ESX.PlayerData.thirdjob.name ~= nil then
		ESX.TriggerServerCallback('exile_strefy:checkStrefy', function(data)		
			for k,v in pairs(data) do
				if v[2] == ESX.PlayerData.thirdjob.name then
					Config.Strefy[k].ocupped = true
				else
					Config.Strefy[k].ocupped = false
				end
			end
		end)
	end
end

function RefreshBlips()
	for k,v in ipairs(Blips) do
		RemoveBlip(v)
		Blips[k] = nil
	end
	
	if ESX.PlayerData.thirdjob and ESX.PlayerData.thirdjob.name ~= nil then
		for i=1, #Config.Strefy, 1 do
			if Config.Strefy[i].Jobs then
				for ii,v in ipairs(Config.Strefy[i].Jobs) do
					if ESX.PlayerData.thirdjob.name == v then
						local blipZone = AddBlipForCoord(Config.Strefy[i].coords)
						SetBlipSprite(blipZone, 458)
						SetBlipColour(blipZone, Config.Strefy[i].ocupped and 2 or 59)
						SetBlipScale (blipZone, 1.0)
						SetBlipAsShortRange(blipZone, true)
		
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(Config.Strefy[i].ocupped and Config.Strefy[i].label or Config.Strefy[i].label)
						EndTextCommandSetBlipName(blipZone)
						
						table.insert(Blips, blipZone)
					end
				end	
			else
				local blipZone = AddBlipForCoord(Config.Strefy[i].coords)
				SetBlipSprite(blipZone, 458)
				SetBlipColour(blipZone, Config.Strefy[i].ocupped and 2 or 59)
				SetBlipScale (blipZone, 1.0)
				SetBlipAsShortRange(blipZone, true)
	
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.Strefy[i].ocupped and Config.Strefy[i].label or 'Strefa Wpływu')
				EndTextCommandSetBlipName(blipZone)
				
				table.insert(Blips, blipZone)
			end
		end
	end
end

function ReturnConfig()
	return Config.Strefy
end

RegisterNetEvent("exile_strefy:zoneTaken")
AddEventHandler("exile_strefy:zoneTaken", function(currentZone)
	local src = source
	TriggerServerEvent("exilerp_scripts:UpdateRankingStrefy", src)
	ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', '~g~Przejąłeś Strefe Wpływu, gratulacje!')
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
	
	TriggerServerEvent("exile_strefy:zoneTakenServer", ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label, currentZone)
end)

RegisterNetEvent("exile_strefy:RemoveActiveZone")
AddEventHandler("exile_strefy:RemoveActiveZone", function(currentZone, job_label, job)	
	if ESX.PlayerData.thirdjob ~= nil and ESX.PlayerData.thirdjob.name ~= nil then		
		if Config.Strefy[currentZone].Jobs then
			for i,v in ipairs(Config.Strefy[currentZone].Jobs) do
				if ESX.PlayerData.thirdjob.name == v then
					ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', "~y~" .. job_label .. "~w~ przejęła ~g~".. Config.Strefy[currentZone].label)
					break
				end	
			end	
		else
			ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', "~y~" .. job_label .. "~w~ przejęła ~g~".. Config.Strefy[currentZone].label)
		end
	end
end)

local taking = false
RegisterNetEvent("exile_strefy:cancelledTaking", function() 
	taking = false
end)

RegisterNetEvent("exile_strefy:startZone")
AddEventHandler("exile_strefy:startZone", function(currentZone, job, job_label)
	if ESX.PlayerData.thirdjob ~= nil and string.find(ESX.PlayerData.thirdjob.name, "org") then
		taking = true		
		for i = 6, 1, -1 do
			if not taking then
				break
			end
			ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', "~g~".. Config.Strefy[currentZone].label .. " ~y~jest przejmowana!\n~w~Pozostało ~g~"..i.." ~w~minut")
			Wait(60000)
		end
		taking = false
	end
end)

function OpenGetWeaponMenu(zone)	
	ESX.TriggerServerCallback('exile_strefy:getStock', function(items)
		if items == false then return end
		local elements = {}

		if items.blackMoney > 0 then
			table.insert(elements, {
				label = "Brudne pieniądze: <span style='color: yellow;'>"..ESX.Math.GroupDigits(items.blackMoney).."$",
				type = 'item_account',
				items = 'black_money',
				value = false
			})
		end

		for i=1, #items.items, 1 do
			local item = items.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = ('Strefa Wpływu ['..zone..']'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = "Ilość"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count ~= nil then
					menu2.close()
							
					ESX.TriggerServerCallback('exile_strefy:removeStock', function()
						OpenGetWeaponMenu(zone)
					end, data.current.type, data.current.value, count, 'society_strefy'..zone, zone)
				end
			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)
			
		end, function(data, menu)
			menu.close()
		end)
	end, 'society_strefy'..zone, zone)
end

local taskbarId = nil
CreateThread(function()
    while ESX.PlayerData.thirdjob == nil do
        Wait(3000)
    end
    while true do
        Wait(3)
		local sleep = true
		for i=1, #Config.Strefy, 1 do
			if ESX.PlayerData.thirdjob then
				if ESX.PlayerData.thirdjob.name ~= nil then
					if Config.Strefy[i].Jobs then
						for ii,v in ipairs(Config.Strefy[i].Jobs) do
							if ESX.PlayerData.thirdjob.name == v then
								if #(vec3(playerPos.x, playerPos.y, playerPos.z) - Config.Strefy[i].coords) < 30 then
									DrawMarker(27, Config.Strefy[i].coords.x, Config.Strefy[i].coords.y, Config.Strefy[i].coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 20.0, 20.0, 20.0, 184, 86, 79, 100, false, true, 2, true, nil, nil, false)
									sleep = false
									if #(vec3(playerPos.x, playerPos.y, playerPos.z) - Config.Strefy[i].coords) < 8.0 then
	
										if not exports["esx_ambulancejob"]:isDead() and not IsPedInAnyVehicle(playerPed, false) then
											ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby rozpocząć ~r~interkacje z Strefą Wpływu")
	
											if IsControlJustPressed(0, 38) then
												if not IsPedInAnyVehicle(playerPed, false) then
													currentZone = TakeZone(playerPos)
													if not Config.Strefy[i].ocupped and not Timer[currentZone] then
														ESX.TriggerServerCallback('exile_strefy:CheckZone', function(hold)
															if not hold then
																TriggerServerEvent('exile_strefy:HoldZone', currentZone, true, ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label)
																secondsRemaining[currentZone] = Config.secondsRemaining
																taskbarId = exports["exile_taskbar"]:cancellableTaskBar(Config.secondsRemaining*1000, "Przejmowanie "..Config.Strefy[i].label, false)
																Timer[currentZone] = true
																ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', 'Opuszczenie ~g~Strefy Wpływu ~w~spowoduje ~r~anulowanie ~w~przejmowania!')
															end
														end, currentZone)
													else
														if ESX.PlayerData.thirdjob.grade >= 2 then
															OpenGetWeaponMenu(currentZone)
														else
															ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', 'Przedmioty można wyciągać od rangi Kapitan+')
														end
													end
												else
													ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', 'Nie możesz przejmować Strefy Wpływu będąc w aucie!')
												end
											end
										end
									end
								end
								
								local timeLeft = nil
								if Timer[currentZone] then
									if secondsRemaining[currentZone] <= Config.secondsRemaining and secondsRemaining[currentZone] >= 5 then
										timeLeft = 'sekund'
									elseif secondsRemaining[currentZone] <= 4 and secondsRemaining[currentZone] >= 2 then
										timeLeft = 'sekundy'
									else
										timeLeft = 'sekunda'
									end
								end
								if (exports["esx_ambulancejob"]:isDead() and Timer[currentZone]) or (Timer[currentZone] and IsPedInAnyVehicle(playerPed, false)) then
									ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', '~r~Anulowano przejmowanie Strefy Wpływu!')
									exports["exile_taskbar"]:cancelTaskBar(taskbarId)
									TriggerServerEvent('exile_strefy:HoldZone', currentZone, false, ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label)
									Timer[currentZone] = false
									secondsRemaining[currentZone] = Config.secondsRemaining
									currentZone = nil
								end
							end	
						end	
					else
						if #(vec3(playerPos.x, playerPos.y, playerPos.z) - Config.Strefy[i].coords) < 30 then
							DrawMarker(27, Config.Strefy[i].coords.x, Config.Strefy[i].coords.y, Config.Strefy[i].coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 20.0, 20.0, 20.0, 184, 86, 79, 100, false, true, 2, true, nil, nil, false)
							sleep = false
							if #(vec3(playerPos.x, playerPos.y, playerPos.z) - Config.Strefy[i].coords) < 8.0 then

								if not exports["esx_ambulancejob"]:isDead() and not IsPedInAnyVehicle(playerPed, false) then
									ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby rozpocząć ~r~interkacje z Strefą Wpływu")

									if IsControlJustPressed(0, 38) then
										if not IsPedInAnyVehicle(playerPed, false) then
											currentZone = TakeZone(playerPos)
											if not Config.Strefy[i].ocupped and not Timer[currentZone] then
												ESX.TriggerServerCallback('exile_strefy:CheckZone', function(hold)
													if not hold then
														TriggerServerEvent('exile_strefy:HoldZone', currentZone, true, ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label)
														secondsRemaining[currentZone] = Config.secondsRemaining
														taskbarId = exports["exile_taskbar"]:cancellableTaskBar(Config.secondsRemaining*1000, "Przejmowanie "..Config.Strefy[i].label, false)
														Timer[currentZone] = true
														ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', 'Opuszczenie ~g~Strefy Wpływu ~w~spowoduje ~r~anulowanie ~w~przejmowania!')
													end
												end, currentZone)
											else
												OpenGetWeaponMenu(currentZone)
											end
										else
											ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', 'Nie możesz przejmować Strefy Wpływu będąc w aucie!')
										end
									end
								end
							end
						end
						
						local timeLeft = nil
						if Timer[currentZone] then
							if secondsRemaining[currentZone] <= Config.secondsRemaining and secondsRemaining[currentZone] >= 5 then
								timeLeft = 'sekund'
							elseif secondsRemaining[currentZone] <= 4 and secondsRemaining[currentZone] >= 2 then
								timeLeft = 'sekundy'
							else
								timeLeft = 'sekunda'
							end
						end
						if (exports["esx_ambulancejob"]:isDead() and Timer[currentZone]) or (Timer[currentZone] and IsPedInAnyVehicle(playerPed, false)) then
							ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', '~r~Anulowano przejmowanie Strefy Wpływu!')
							exports["exile_taskbar"]:cancelTaskBar(taskbarId)
							TriggerServerEvent('exile_strefy:HoldZone', currentZone, false, ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label)
							Timer[currentZone] = false
							secondsRemaining[currentZone] = Config.secondsRemaining
							currentZone = nil
						end
					end
				end
			else
				Wait(200)
			end
		end
		if sleep then
			Wait(500)
		end
	end
end)

CreateThread(function()
    while currentZone == nil do
        Wait(500)
    end
	
    while true do
		Wait(1000)
		if Timer[currentZone] then
			while currentZone ~= nil and secondsRemaining[currentZone] > 0 and not exports["esx_ambulancejob"]:isDead() do
				Wait(1000)
				if currentZone ~= nil then
					secondsRemaining[currentZone] = secondsRemaining[currentZone] - 1
					
					if #(playerPos - Config.Strefy[currentZone].coords) > 8.0 then
						ESX.ShowAdvancedNotification('~o~Strefa Wpływu', 'Powiadomienie', '~r~Anulowano przejmowanie Strefy Wpływu!')
						exports["exile_taskbar"]:cancelTaskBar(taskbarId)
						TriggerServerEvent('exile_strefy:HoldZone', currentZone, false, ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label)
						secondsRemaining[currentZone] = Config.secondsRemaining
						Timer[currentZone] = false
						currentZone = nil
						break
					end
					if secondsRemaining[currentZone] <= 0 then
						TriggerEvent('exile_strefy:zoneTaken', currentZone)
						secondsRemaining[currentZone] = Config.secondsRemaining
						Timer[currentZone] = false
						
						break
					end
				end
			end
		end
    end
end)

TakeZone = function(pCoords)
    if #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[1].coords) < 10 then
        return 1
    elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[2].coords) < 10 then
        return 2
    elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[3].coords) < 10 then
        return 3
    elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[4].coords) < 10 then
        return 4   
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[5].coords) < 10 then
        return 5   
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[6].coords) < 10 then
        return 6	
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[7].coords) < 10 then
        return 7	
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[8].coords) < 10 then
        return 8	
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[9].coords) < 10 then
        return 9
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[10].coords) < 10 then
        return 10
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[11].coords) < 10 then
		return 11
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[12].coords) < 10 then
		return 12
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[13].coords) < 10 then
		return 13
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[14].coords) < 10 then
		return 14
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[15].coords) < 10 then
		return 15
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[16].coords) < 10 then
		return 16
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[17].coords) < 10 then
		return 17
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[18].coords) < 10 then
		return 18
    end
end