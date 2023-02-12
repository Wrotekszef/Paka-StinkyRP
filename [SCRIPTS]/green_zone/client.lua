Citizen.CreateThread(function ()
    local isInArena, isArenaStarted = false, false

	AddEventHandler("areanas:isInArena", function(_isInArena, _isArenaStarted)
		isInArena = _isInArena
        isArenaStarted = _isArenaStarted
	end)

    local playerCoords, inZone, lastZone
    local justEnter = true
    local justChecked = false

    while true do
        if not (isInArena and isArenaStarted) then
            playerCoords, inZone = GetEntityCoords(PlayerPedId()), nil

            for index, data in ipairs(Config.Zones) do
                for index, bubble in ipairs(data.bubbles) do
                    if #(playerCoords - vec3(bubble.x, bubble.y, bubble.z)) < bubble.w then
                        inZone = data
                        break
                    end
                end

                if inZone then
                    break
                end
            end

            if inZone and lastZone then
                if inZone ~= lastZone then
                    if not justChecked then
                        justChecked = true
                        inZone = nil
                    end
                else
                    justChecked = false
                end
            end
            
            if inZone then
                if inZone ~= lastZone then
                    justEnter = true
                end

                if justEnter then
                    ESX.UI.Menu.CloseAll()
                    if (inZone.type == "green" or inZone.type == "drift") then
                        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
                        
                        NetworkSetFriendlyFireOption(false)
                        SetCanAttackFriendly(PlayerPedId(), true, false)
                        Citizen.InvokeNative(0x5FFE9B4144F9712F, true)
                    end

                    ClearPlayerWantedLevel(PlayerId())             

                    TriggerEvent('pNotify:SendNotification', ("%s"):format(inZone.enter), 2000, 'warning')
                    
                    if (inZone.type == 'yellow' or inZone.type == 'green') then
                        CheckCar()
                    end

                    lastZone = inZone
                    justEnter = false
                end

                if (inZone.type == "green") then
                    DisableControlAction(0, 288, true)
                    DisableControlAction(0, 264, true) 
                    DisableControlAction(0, 263, true) 
                    DisableControlAction(0, 141, true) 
                    DisableControlAction(0, 140, true) 
                end

                if (inZone.type == "green") then
                    TriggerEvent('esx_zones:isInZone', true, true)
                end
            else
                if not justEnter then
                    NetworkSetFriendlyFireOption(true)
                    SetCanAttackFriendly(PlayerPedId(), false, false)
                    Citizen.InvokeNative(0x5FFE9B4144F9712F, false)
                    TriggerEvent('esx_zones:isInZone', false, false)
                    justEnter = true
                end
            end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local playerCoords

    for _,data in ipairs(Config.Zones) do
        for _, bubble in ipairs(data.bubbles) do
            data.blip = AddBlipForCoord(bubble.x, bubble.y, bubble.z)
            SetBlipSprite(data.blip, data.id)
            SetBlipDisplay(data.blip, 4)
            SetBlipScale(data.blip, 1.0)
            SetBlipColour(data.blip, data.clr)
            SetBlipAsShortRange(data.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.title)
            EndTextCommandSetBlipName(data.blip)
        end
    end

    while true do
        playerCoords = GetEntityCoords(PlayerPedId())

        for index, data in ipairs(Config.Zones) do
            for index, bubble in ipairs(data.bubbles) do
				if #(playerCoords - vec3(bubble.x, bubble.y, bubble.z)) < bubble.w * 2 then
                    DrawMarker(28, bubble.x, bubble.y, bubble.z, 0, 0, 0, 0, 0, 0, bubble.w, bubble.w, bubble.w, data.color.r, data.color.g, data.color.b, 85, 0, 0, 2, 0, 0, 0, 0) 
                end
            end
        end

        Citizen.Wait(0)
	end
end)

IsWeapon = function(weaponHash)
    for index, hash in ipairs(Config.Weapons) do 
        if weaponHash == hash then
            return true
        end
    end

    return false
end

CheckCar = function()
	local ped = PlayerPedId()
	
	if DoesEntityExist(ped) then
		if IsPedSittingInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			
			if vehicle ~= nil then
				ESX.Game.DeleteVehicle(vehicle)
			end
		end
	end
end