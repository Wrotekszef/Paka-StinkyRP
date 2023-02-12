CreateThread(function()
    playSong()
end)

function playSong()
	exports["xsound"]:PlayUrlPos("Mechanik", "https://www.youtube.com/watch?v=uughUsQtq5g", 0.5, vector3(891.18, -2114.75, 34.16), false, {
		onPlayStart = function() 
			exports["xsound"]:Distance("Mechanik", 30.0)
		end,
		onPlayEnd = function() 
			playSong()
		end
	})
end

RegisterNetEvent("xsound:streamerMode", function(x) 
    if not x then
        playSong()
	end
end)

RegisterNetEvent("exilerp_radio:setVol", function(car, vol) 
    local soundname = "radio:"..car
    if exports["xsound"]:soundExists(soundname) then
        exports["xsound"]:setVolumeMax(soundname, vol)
    end
end)
RegisterNetEvent("exilerp_radio:sync", function(carSrc, url, vol, play) 
	local sleep = 50
	local cars = ESX.Game.GetVehicles()
	local car = nil

	for i=1, #cars, 1 do
		if DoesEntityExist(cars[i]) and GetVehicleNumberPlateText(cars[i]) == carSrc then
			car = cars[i]
			break
		end
	end
	if car == nil then
		return
	end
	local oldCoords = GetEntityCoords(car)
	local soundname = "radio:"..car
	if play then
		exports["xsound"]:PlayUrlPos(soundname, url, vol, oldCoords, false)
		exports["xsound"]:Distance(soundname, 25.0)
		local hasSet = false
		while true do
			if not exports["xsound"]:soundExists(soundname) then
				return
			end
			if DoesEntityExist(car) then
				local vehCoords = GetEntityCoords(car)
				local pedCoords = GetEntityCoords(PlayerPedId())
				if GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)) == GetVehicleNumberPlateText(car) then
					exports["xsound"]:Distance(soundname, 200.0)
					hasSet = true 
				elseif hasSet then
					exports["xsound"]:Distance(soundname, 25.0)
					hasSet = false
				end
				if #(vehCoords - pedCoords) < 30.0 then
					sleep = 80
					exports["xsound"]:Position(soundname, vehCoords)
				else
					sleep = 1000
				end
			else
				if exports["xsound"]:soundExists(soundname) then
					exports["xsound"]:Destroy(soundname)
				end
				break
			end
			Wait(sleep)
		end
	else
		if exports["xsound"]:soundExists(soundname) then
			exports["xsound"]:Destroy(soundname)
		end
	end
end)
RegisterCommand("radiostop", function(src,args,raw) 
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh and veh ~= 0 then
        TriggerServerEvent("exilerp_radio:stop", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
        ESX.ShowNotification("~g~Wyłączono radio w pojeździe!")
    else
        ESX.ShowNotification("~r~Musisz być w pojeździe by to użyć")
    end
end)

RegisterCommand("radiovol", function(src,args,raw) 
    local vol = tonumber(args[1])
    if vol and (vol > 100 or vol < 0) then
        ESX.ShowNotification("~r~Podaj głośność od 0 do 100!")
        return
    end
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh and veh ~= 0 then
        TriggerServerEvent("exilerp_radio:changeVol", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)), vol)
        ESX.ShowNotification("~g~Zmieniono głośność radia na ~c~"..vol.."%")
    else
        ESX.ShowNotification("~r~Musisz być w pojeździe by to użyć")
    end
end)
RegisterCommand("radiocar", function(src,args,raw) 
	if args[1] then
		local vol = tonumber(args[2])
		if args[2] and vol then
			if vol <= 100 and vol >= 0 then
				local veh = GetVehiclePedIsIn(PlayerPedId(), false)
				if veh and veh ~= 0 then
					TriggerServerEvent("exilerp_radio:play", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)), args[1], args[2])
				else
					ESX.ShowNotification("~r~Musisz być w pojeździe by to użyć")
				end
			else
				ESX.ShowNotification("~r~Podaj głośność od 0 do 100")
			end
		else
			ESX.ShowNotification("~r~Podaj prawidłową głośność")
		end
	else
		ESX.ShowNotification("~r~Podaj link do piosenki")
	end
end)