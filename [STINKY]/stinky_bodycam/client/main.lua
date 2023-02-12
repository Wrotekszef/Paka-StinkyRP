local haveItem = false
local Loaded = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData

	Loaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job

	if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage') and haveItem then
		TriggerEvent('bodycam:showw')
	else
		TriggerEvent('bodycam:closee')
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if ESX.PlayerData and ESX.PlayerData.inventory then
		CreateThread(function()
			if ESX.PlayerData.inventory ~= nil then
				local found = false
				for i = 1, #ESX.PlayerData.inventory, 1 do
					if ESX.PlayerData.inventory[i].name == item.name then
						ESX.PlayerData.inventory[i] = item
						found = true
						break
					end
				end
				
				if not found then
					ESX.TriggerServerCallback('esx:isValidItem', function(status)
						if status then
							table.insert(ESX.PlayerData.inventory, item)
						end
					end, item.name)			
				end
			end
		end)
	end
	
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' then
		if item == 'bodycam' and count > 0 then
			TriggerEvent('bodycam:showw')
		end	
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if ESX.PlayerData and ESX.PlayerData.inventory then
		CreateThread(function()
			if ESX.PlayerData.inventory ~= nil then
				local found = false
				for i = 1, #ESX.PlayerData.inventory, 1 do
					if ESX.PlayerData.inventory[i].name == item.name then
						ESX.PlayerData.inventory[i] = item
						found = true
						break
					end
				end
				
				if not found then
					ESX.TriggerServerCallback('esx:isValidItem', function(status)
						if status then
							table.insert(ESX.PlayerData.inventory, item)
						end
					end, item.name)
				end
			end
		end)
	end
	
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' then
		if item == 'bodycam' and count <= 0 then
			TriggerEvent('bodycam:closee')
		end	
	end
end)

RegisterNetEvent('bodycam:state')
AddEventHandler('bodycam:state', function(rodzaj)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' and haveItem then
		if rodzaj == true then
			TriggerEvent('bodycam:closee')
		elseif rodzaj == false then
			TriggerEvent('bodycam:showw')
		end
	end
end)

CreateThread(function()
	while true do
		Wait(500)
		if Loaded then
			if ESX.PlayerData.inventory ~= nil then
				for i = 1, #ESX.PlayerData.inventory, 1 do
					if ESX.PlayerData.inventory[i].name == 'bodycam' then
						if ESX.PlayerData.inventory[i].count > 0 then
							haveItem = true
						else
							haveItem = false
						end
					else
						Wait(2000)
					end
				end	
			end
		else
			Wait(1000)
		end		
	end
end)

local IsPaused = false
CreateThread(function()
	while true do
		Wait(200)
		if Loaded then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' and haveItem then
				if IsPauseMenuActive() and not IsPaused then
					IsPaused = true
					TriggerEvent('bodycam:closee')
				elseif not IsPauseMenuActive() and IsPaused then
					IsPaused = false
					TriggerEvent('bodycam:showw')
				end
			else
				Wait(500)
			end
		end
	end
end)

RegisterNetEvent("bodycam:showw")
AddEventHandler("bodycam:showw", function()
	local text = ''
	ESX.TriggerServerCallback('falszywyy-bodycam:getPlayerName', function(result)
		if ESX.PlayerData.job.name == 'ambulance' then
			text = 'SAMS - '..ESX.PlayerData.job.grade_label
		elseif ESX.PlayerData.job.name == 'police' then
			text = 'SASP - '..ESX.PlayerData.job.grade_label
		elseif ESX.PlayerData.job.name == 'sheriff' then
			text = 'SASD - '..ESX.PlayerData.job.grade_label
		elseif ESX.PlayerData.job.name == 'mechanik' then
			text = 'LST - '..ESX.PlayerData.job.grade_label
		elseif ESX.PlayerData.job.name == 'gheneraugarage' then
			text = 'Divo Garage  - '..ESX.PlayerData.job.grade_label
		end
		SendNUIMessage({
			action = 'updatecam',
			odznaka = result.name,
			napis = text,
		})
	end)
end)

RegisterNetEvent("bodycam:closee")
AddEventHandler("bodycam:closee", function()
	SendNUIMessage({
		action = 'closecam'
	})
end)

local updateGlobal = 0
local delay = 10 * 60000
local time = 0
CreateThread(function()
	while true do
		Wait(5000)
		if ESX.PlayerData.job and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'sheriff') then
			time = time + 5
			local timer = GetGameTimer()
			if not updateGlobal or updateGlobal < timer then
				TriggerServerEvent('bodycam:save', time)
				time = 0
				updateGlobal = timer + delay
			end
		end
	end
end)

local updateGlobalS = 0
local delayS = 10 * 60000
local timeS = 0

CreateThread(function()
	while true do
		Wait(5000)
		timeS = timeS + 5
		local timerS = GetGameTimer()
		if not updateGlobalS or updateGlobalS < timerS then
			print(timeS)
			TriggerServerEvent('bodycam:saveS', timeS)
			timeS = 0
			updateGlobalS = timerS + delayS
		end
	end
end)