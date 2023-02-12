function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end


RegisterNetEvent("Exile:ClearAllVehs")
AddEventHandler("Exile:ClearAllVehs", function()
    for sR4HoXp6l3D4 in EnumerateVehicles() do
        if not IsPedInVehicle(playerPed, sR4HoXp6l3D4, true) then
            SetEntityAsMissionEntity(GetVehiclePedIsIn(sR4HoXp6l3D4, true), 1, 1)
            DeleteEntity(GetVehiclePedIsIn(sR4HoXp6l3D4, true))
            SetEntityAsMissionEntity(sR4HoXp6l3D4, 1, 1)
            DeleteEntity(sR4HoXp6l3D4)
        end
    end
end)

RegisterNetEvent("Exile:ClearAllEntities")
AddEventHandler("Exile:ClearAllEntities", function()
    for WEgd4 in EnumerateObjects() do
        DeleteEntity(WEgd4)
    end
end)

RegisterNetEvent("Exile:ClearAllPeds1")
AddEventHandler("Exile:ClearAllPeds1", function()
    PedStatus = 0
    Wait(100)
    ESX.ShowNotification('~y~Mapa zostanie wyczyszczona przez ~r~Administratora ~y~za ~r~30 sekund')
    Wait(30000)
    ESX.ShowNotification('~y~Mapa zostanie wyczyszczona przez ~r~Administratora ~y~za ~r~15 sekund')
    Wait(15000)
    ESX.ShowNotification('~y~Mapa zostanie wyczyszczona przez ~r~Administratora ~y~za ~r~5 sekund')
    Wait(5000)
    ESX.ShowNotification('~y~Mapa została wyczyszczona przez ~r~Administratora')
    Wait(100)
    local playerPed = PlayerPedId()
    for Kkjy25CzbmFuahd in EnumeratePeds() do
        PedStatus = PedStatus + 1
        if not (IsPedAPlayer(Kkjy25CzbmFuahd)) then
            RemoveAllPedWeapons(Kkjy25CzbmFuahd, true)
            for WEgd4 in EnumerateObjects() do
                DeleteEntity(WEgd4)
            end
            for sR4HoXp6l3D4 in EnumerateVehicles() do
                if not IsPedInVehicle(playerPed, sR4HoXp6l3D4, true) then
                    SetEntityAsMissionEntity(GetVehiclePedIsIn(sR4HoXp6l3D4, true), 1, 1)
                    DeleteEntity(GetVehiclePedIsIn(sR4HoXp6l3D4, true))
                    SetEntityAsMissionEntity(sR4HoXp6l3D4, 1, 1)
                    DeleteEntity(sR4HoXp6l3D4)
                end
            end
        end
    end
end)