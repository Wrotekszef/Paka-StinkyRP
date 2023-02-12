local GetEntityHeading = GetEntityHeading
local DoesEntityExist = DoesEntityExist
local GetClosestObjectOfType = GetClosestObjectOfType
local SetEntityHeading = SetEntityHeading
local FreezeEntityPosition = FreezeEntityPosition
local IsControlJustReleased = IsControlJustReleased
local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)

CreateThread(function()
	while true do 
		Wait(300)
		playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	ESX.TriggerServerCallback('esx_doorlock:getDoorState', function(doorState)
		for index,state in pairs(doorState) do
			Config.DoorList[index].locked = state
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_doorlock:setDoorState')
AddEventHandler('esx_doorlock:setDoorState', function(index, state) 
	Config.DoorList[index].locked = state 
end)

CreateThread(function()
	while true do

		for k,v in ipairs(Config.DoorList) do
			v.IsAuthorized = IsAuthorized(v)

			if v.doors then
				for k2,v2 in ipairs(v.doors) do
					if v2.object and DoesEntityExist(v2.object) then
						if k2 == 1 then
							v.distanceToPlayer = #(playerCoords - GetEntityCoords(v2.object))
						end

						if v.locked and v2.objHeading and ESX.Math.Round(GetEntityHeading(v2.object)) ~= v2.objHeading then
							SetEntityHeading(v2.object, v2.objHeading)
						end
					else
						v.distanceToPlayer = nil
						v2.object = GetClosestObjectOfType(v2.objCoords, 1.0, v2.objHash, false, false, false)
					end
				end
			else
				if v.object and DoesEntityExist(v.object) then
					v.distanceToPlayer = #(playerCoords - GetEntityCoords(v.object))

					if v.locked and v.objHeading and ESX.Math.Round(GetEntityHeading(v.object)) ~= v.objHeading then
						SetEntityHeading(v.object, v.objHeading)
					end
				else
					v.distanceToPlayer = nil
					v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
				end
			end
		end

		Wait(500)
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local letSleep = true

		for k,v in ipairs(Config.DoorList) do
			if v.distanceToPlayer and v.distanceToPlayer < 20.00 then
				letSleep = false
				if v.doors then
					for k2,v2 in ipairs(v.doors) do
						FreezeEntityPosition(v2.object, v.locked)
					end
				else
					FreezeEntityPosition(v.object, v.locked)
				end
			end

			if v.distanceToPlayer and v.distanceToPlayer < v.maxDistance then
				letSleep = false
				if v.IsAuthorized then
					DrawText3Ds(v.textCoords.x, v.textCoords.y, v.textCoords.z, (v.locked and '[E] ~r~Zamknięte' or "[E] ~g~Otwarte"))
					if IsControlJustReleased(0, 38) then
						v.locked = not v.locked
						if v.locked then
							ESX.ShowNotification('~r~Drzwi zostały zamknięte')
						else
							ESX.ShowNotification('~g~Drzwi zostały otwarte')
						end
						TriggerServerEvent('esx_doorlock:updateState', k, v.locked)
					end
				end
			end
		end

		if letSleep then
			Wait(500)
		end
	end
end)

function IsAuthorized(door)
	if not ESX.PlayerData.job then
		return false
	end

	for k,job in pairs(door.authorizedJobs) do
		if job == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

function DrawText3Ds(x,y,z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 55)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end