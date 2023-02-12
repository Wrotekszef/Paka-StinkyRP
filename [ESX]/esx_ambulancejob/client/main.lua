local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local choosedHospital = nil
local FirstSpawn				= true
local IsDead					= false
local TimerThreadId	   			= nil
local DistressThreadId			= nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local obezwladniony 			= false
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local IsBusy					= false
local blockShooting 			= GetGameTimer()
local CurrentTask 				= {}
local SamsBlip 					= {}
local cam 						= nil
local podczasleku 				= false
local czaslekutime 				= 300
local blokada 					= false
local heli 						= false
local eqText 					= '~r~NIE ZOSTANIE UTRACONY'
local removeItems 				= false
local SetEntityHealth = SetEntityHealth
local GetPedMaxHealth = GetPedMaxHealth
local ClearPedTasksImmediately = ClearPedTasksImmediately
local DoScreenFadeOut = DoScreenFadeOut
local IsScreenFadedOut = IsScreenFadedOut
local DoScreenFadeIn = DoScreenFadeIn
local GetHashKey = GetHashKey
local SetPedArmour = SetPedArmour
local ClearPedBloodDamage = ClearPedBloodDamage
local ResetPedVisibleDamage = ResetPedVisibleDamage
local ClearPedLastWeaponDamage = ClearPedLastWeaponDamage
local ResetPedMovementClipset = ResetPedMovementClipset
local SetEntityCoords = SetEntityCoords
local SetEntityHeading = SetEntityHeading
local SetGameplayCamRelativeHeading = SetGameplayCamRelativeHeading
local GetEntityMaxHealth = GetEntityMaxHealth
local SetPlayerInvincible = SetPlayerInvincible
local NetworkResurrectLocalPlayer = NetworkResurrectLocalPlayer
local DisableControlAction = DisableControlAction
local SetPlayerInvincible = SetPlayerInvincible
local SetEntityCanBeDamaged = SetEntityCanBeDamaged
local SetPlayerCanUseCover = SetPlayerCanUseCover
local SetEntityInvincible = SetEntityInvincible
local StopAnimTask = StopAnimTask
local RemoveAnimDict = RemoveAnimDict
local EnableAllControlActions = EnableAllControlActions
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetEntityCoords = GetEntityCoords
local playerPed = PlayerPedId()
local playerId = PlayerId()
local coords = GetEntityCoords(playerPed)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
		if lickajest then
			heli = true
		else
			heli = false
		end
	end, GetPlayerServerId(playerId), 'sams_heli')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	deleteBlip()
	refreshBlip()
end)

AddEventHandler('esx:onPlayerDeath', function()
	OnPlayerDeath()
end)

CreateThread(function ()
	while true do
		if IsDead then
			sleep = 0
			playerPed = PlayerPedId()
			playerId = PlayerId()
			coords = GetEntityCoords(playerPed)
		else
			sleep = 500
			playerPed = PlayerPedId()
			playerId = PlayerId()
			coords = GetEntityCoords(playerPed)
		end
		Wait(sleep)
	end
end)

function isDead()
	return IsDead
end

function checkArray(array, val)
	for _, value in ipairs(array) do
		local v = value
		if type(v) == 'string' then
			v = GetHashKey(v)
		end
		if v == val then
			return true
		end
	end
	return false
end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function RespawnPed(ped, coords)
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetEntityHeading(ped, coords.heading)
	if ped == playerPed then
		SetGameplayCamRelativeHeading(coords.heading)
	end
	
	SetEntityHealth(ped, GetEntityMaxHealth(ped))
	
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	TriggerEvent('esx:onPlayerSpawn', coords.x, coords.y, coords.z)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

CreateThread(function()
    while true do
        Wait(4)
        if blokada then
            DisableControlAction(2, 24, true) -- Attack
            DisableControlAction(2, 257, true) -- Attack 2
            DisableControlAction(2, 25, true) -- Aim
            DisableControlAction(2, 263, true) -- Melee Attack 1
            DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
            DisableControlAction(2, Keys['X'], true) -- Hands up
            DisableControlAction(2, Keys['PAGEDOWN'], true) -- Crawling
            DisableControlAction(2, Keys['B'], true) -- Pointing
            DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
            DisableControlAction(2, Keys['F1'], true) -- Disable phone
            DisableControlAction(2, Keys['F2'], true) -- Inventory
            DisableControlAction(2, Keys['F3'], true) -- Animations
            DisableControlAction(2, Keys['E'], true) -- E 
			DisableControlAction(2, Keys['G'], true) -- G
			DisableControlAction(2, Keys['~'], true) -- ~
			DisableControlAction(2, Keys['['], true) -- [
			DisableControlAction(2, Keys[']'], true) -- ]
			DisableControlAction(2, Keys['X'], true) -- X
            DisableControlAction(2, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
		else
			Wait(1000)
        end
    end
end)

CreateThread(function()
	while true do
		Wait(2000)
		if podczasleku then
			if(czaslekutime > 0)then
				czaslekutime = czaslekutime-2
			end
		else
			Wait(1000)
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

CreateThread(function()
	while true do
		Wait(0)
		if podczasleku then
			drawTxt(0.69, 1.43, 1.0, 1.0, 0.5, 'Lek zacznie działać za: ~r~' .. czaslekutime .. '~w~s', 255, 255, 255, 255)
		else
			Wait(1000)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(itemName)
	local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)
	local newHealth = math.min(maxHealth , math.floor(health + maxHealth/4))

	if itemName == 'bandaz' then
		SetEntityHealth(playerPed, newHealth)
	elseif itemName == 'apteczka' then
		SetEntityHealth(playerPed, maxHealth)
	elseif itemName == 'leki' then
		SetEntityHealth(playerPed, maxHealth)
	elseif itemName == 'small' then
		SetEntityHealth(playerPed, newHealth)
	elseif itemName == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end
end)

RegisterNetEvent('esx_ambulancejob:healitem')
AddEventHandler('esx_ambulancejob:healitem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'apteczka' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
		ESX.Streaming.RequestAnimDict(lib, function()
			blokada = true
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 0, 0, false, false, false)
			Wait(10000)
			ESX.ShowNotification(_U('used_medikit'))
			TriggerEvent('esx_ambulancejob:heal', 'apteczka')
			blokada = false
		end)
	elseif itemName == 'bandaz' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
		ESX.Streaming.RequestAnimDict(lib, function()
			blokada = true
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 0, 0, false, false, false)
			Wait(10000)
			ESX.ShowNotification(_U('used_bandage'))
			TriggerEvent('esx_ambulancejob:heal', 'bandaz')
			blokada = false
		end)
	elseif itemName == 'leki' and not podczasleku then
		if GetEntityHealth(playerPed) <= 175 then
			podczasleku = true
			Wait(1000)
			TriggerEvent('esx_basicneeds:onDrink')
			ESX.ShowNotification('~y~Tabletka zacznie działać za 5 minut!')
			Wait(300000)
			ESX.ShowNotification('~g~Leki przeciwbólowe zaczeły działać!')
			TriggerEvent('esx_ambulancejob:heal', 'leki')
			podczasleku = false
		else
			ESX.ShowNotification('~r~Nic cię nie boli, nie potrzebujesz leków!')
		end
	end
end)

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end

function StartDistressSignal()
	CreateThread(function()
		local timer = Config.RespawnDelayAfterRPDeath
		local signal = 0
		while IsDead do
			Wait(0)
			if obezwladniony then
				return
			else
				if signal < GetGameTimer() then
					SetTextFont(4)
					SetTextCentre(true)
					SetTextProportional(1)
					SetTextScale(0.45, 0.45)
					SetTextColour(255, 255, 255, 255)
					SetTextDropShadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()

					BeginTextCommandDisplayText('STRING')
					AddTextComponentSubstringPlayerName(_U('distress_send'))
					EndTextCommandDisplayText(0.5, 0.825)

					if IsDisabledControlPressed(0, Keys['G']) and not exports['esx_policejob']:IsCuffed() then
						SendDistressSignal()
						signal = GetGameTimer() + 90000 * 4
					end	
				end
			end
		end
	end)
end

function SendDistressSignal()
    ESX.TriggerServerCallback('e-phone:getItemAmount', function(qtty)
        if qtty > 0 then
            ESX.TriggerServerCallback('e-phone:getSimLoaded', function(sim)
                if sim == nil then
                    ESX.ShowNotification('~r~Nie posiadasz podpiętej karty sim')
                else
                    local godzinaInt = GetClockHours()
                    local godzina = ''
                    if string.len(tostring(godzinaInt)) == 1 then
                        godzina = '0'..godzinaInt
                    else
                        godzina = godzinaInt
                    end
                    local minutaInt = GetClockMinutes()
                    local minuta = ''
                    if string.len(tostring(minutaInt)) == 1 then
                        minuta = '0'..minutaInt
                    else
                        minuta = minutaInt
                    end
                    godzina = godzina..":"..minuta

                    ESX.ShowNotification('Sygnał alarmowy został wysłany!')

                    local coords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', 'Ranny obywatel o godzienie: '..godzina, {
                        x = coords.x,
                        y = coords.y,
                        z = coords.z
                    })
                end
            end)
        end
    end, 'phone')
end

function RemoveItemsAfterRPDeath()
	CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		ESX.UI.Menu.CloseAll()
		if removeItems then
			ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()	
				local hospital = string.upper(choosedHospital)
				ESX.SetPlayerData('lastPosition', Config["RespawnPlace"..hospital])
				TriggerServerEvent('esx:updateCoords', Config["RespawnPlace"..hospital])
				RespawnPed(playerPed, Config["RespawnPlace"..hospital])
				TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
				StopScreenEffect('DeathFailOut')
				DoScreenFadeIn(800)
			end)
		else
			local hospital = string.upper(choosedHospital)
			ESX.SetPlayerData('lastPosition', Config["RespawnPlace"..hospital])
			TriggerServerEvent('esx:updateCoords', Config["RespawnPlace"..hospital])
			RespawnPed(playerPed, Config["RespawnPlace"..hospital])
			TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end
	end)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return secs, mins
	end
end

local narcozone = {
	vec3(-1726.62, 2617.63, 1.64),
	vec3(2435.94, 4966.75, 41.44),
	vec3(-466.44, -1451.03, 19.85),
	vec3(-1155.4248, -2033.3641, 12.2105),
	vec3(-316.65, 2790.83, 58.88),
	vec3(2854.98, 1435.43, 23.61),
	vec3(1011.2738, -3199.0823, -39.9431),
	vec3(1160.7366, -3191.6396, -39.9579),
	vec3(1100.9709, -3100.1357, -39.95),
	vec3(1101.2207, -3195.9104, -39.9434),
	vec3(181.69706726074, 2761.9052734375, 43.426380157471),
	vec3(3304.15625, 5151.3115234375, 18.287322998047),
	vec3(-597.56982421875, 5304.8056640625, 70.214508056641),
}

function narcoticZone()
	for i=1, #narcozone, 1 do
		if #(coords - narcozone[i]) < 65 then
			return true
		end
	end
	return false
end

local GetIdOfThisThread = GetIdOfThisThread
local TerminateThread = TerminateThread

function StartDeathTimer()
	if TimerThreadId then
		TerminateThread(TimerThreadId)
	end
	ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(ExilePlayers)
		if ExilePlayers then
			if ExilePlayers['ambulance'] >= Config.EMS_TO_REMOVE_ITEMS then
				eqText = '~r~ZOSTANIE UTRACONY'
				removeItems = true
			else
				removeItems = false
				eqText = '~g~NIE ZOSTANIE UTRACONY'
			end
		end
	end)
	local timer = ESX.Math.Round(Config.RespawnToHospitalDelay)
	if narcoticZone() then
		timer = timer / 2000
	else
		timer = timer / 1000
	end
	local seconds,minutes = secondsToClock(timer)
	local firstScreen = true
	CreateThread(function() 
		HasTimer = true
		while timer > 0 and IsDead do
			Wait(1000)
			if timer > 0 then
				timer = timer - 1
			end
			seconds,minutes = secondsToClock(timer)
		end
		HasTimer = false
		firstScreen = false
	end)
	CreateThread(function()
		TimerThreadId = GetIdOfThisThread()

		while firstScreen do
			Wait(0)
			if obezwladniony then
				return
			else
				SetTextFont(4)
				SetTextCentre(true)
				SetTextProportional(1)
				SetTextScale(0.45, 0.45)
				SetTextColour(255, 255, 255, 255)
				SetTextDropShadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()

				BeginTextCommandDisplayText("STRING")
				AddTextComponentSubstringPlayerName('Pomoc dostępna za ~b~'..minutes..' minut i '..seconds..' sekund~w~\n Ekwipunek: ' .. eqText)
				EndTextCommandDisplayText(0.5, 0.850)
			end
		end

		local pressStart = nil
		while IsDead do
			Wait(0)
			if obezwladniony then 
				return
			else
				SetTextFont(4)
				SetTextCentre(true)
				SetTextProportional(1)
				SetTextScale(0.45, 0.45)
				SetTextColour(255, 255, 255, 255)
				SetTextDropShadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()

				BeginTextCommandDisplayText("STRING")
				AddTextComponentSubstringPlayerName('Przytrzymaj [~b~E~s~] aby zostać transportowanym\n Ekwipunek: ' .. eqText)
				EndTextCommandDisplayText(0.5, 0.850)

				if IsControlPressed(0, Keys['E']) or IsDisabledControlPressed(0, Keys['E']) then
					if not pressStart then
						pressStart = GetGameTimer()
					end

					if GetGameTimer() - pressStart > 3000 then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rp_dead', {
							title = ('Wybierz szpital'),
							align = 'center',
							elements = {
								{ label = ('Los Santos'), value = 'ls' },
							}
						}, function (data, menu)
							if data.current.value == 'ls' then
								choosedHospital = 'LS'
								RemoveItemsAfterRPDeath()
							end
							return
							menu.close()
						end, function (data, menu)
							menu.close()
						end)
						pressStart = nil
						break
					end
				else
					pressStart = nil
				end
			end	
		end
	end)
end

CreateThread(function()
	while true do
		Wait(2)

		if IsDead then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['F5'], true)
			EnableControlAction(0, Keys['N'], true)
			EnableControlAction(0, Keys['HOME'], true)
			EnableControlAction(0, Keys['DELETE'], true)
			EnableControlAction(0, Keys['H'], true)
			EnableControlAction(0, 21, true)
			EnableControlAction(0, Keys['Z'], true)
			EnableControlAction(0, 27, true)
			EnableControlAction(0, 173, true)
		else
			Wait(1000)
		end
	end
end)

function DeathFunc() 
	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
	CreateThread(function ()
		RequestAnimDict('dead')
		while not HasAnimDictLoaded('dead') do
			Wait(0)
		end

		local weapon = GetPedCauseOfDeath(playerPed)
		local sourceofdeath = GetPedSourceOfDeath(playerPed)
		local damagedbycar = false
		if weapon == 0 and sourceofdeath == 0 and HasEntityBeenDamagedByWeapon(playerPed, `WEAPON_RUN_OVER_BY_CAR`, 0) then
			damagedbycar = true
		end
		

		if not IsPedInAnyVehicle(playerPed, false)then
			NetworkResurrectLocalPlayer(coords, 0.0, false, false)
			Wait(100)
			SetEntityCoords(playerPed, coords)
		end
		SetPlayerInvincible(playerId, true)
		SetPlayerCanUseCover(playerId, false)

		local knockoutDuration = 15000

		if weapon == `WEAPON_UNARMED` or ((weapon == `WEAPON_RUN_OVER_BY_CAR` or damagedbycar) and sourceofdeath ~= playerPed) or weapon == `WEAPON_NIGHTSTICK` or weapon == `WEAPON_BAT` then
			obezwladniony = true
			TriggerServerEvent('esx_ambulancejob:setDeathStatus', 1)
			CreateThread(function()
				exports["exile_taskbar"]:taskBar(knockoutDuration, "Odzyskujesz siły...", false, function(cb) 
					RespawnPed(playerPed, coords)
					Wait(500)
					SetEntityHealth(playerPed, 200)
					TriggerEvent('esx_ambulancejob:reviveexile', source)
				end)
			end)
		end
		while IsDead do
			SetEntityInvincible(playerPed, true)
			SetEntityCanBeDamaged(playerPed, false)
			if not IsPedInAnyVehicle(playerPed, false) then
				if IsEntityDead(playerPed) then
					NetworkResurrectLocalPlayer(coords, 0.0, false, false)
					Wait(100)
					SetEntityCoords(playerPed, coords)
					SetPlayerInvincible(playerId, true)
					SetPlayerCanUseCover(playerId, false)
				end
				if not IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) then
					TaskPlayAnim(playerPed, 'dead', 'dead_a', 1.0, 1.0, -1, 2, 0, 0, 0, 0)
				end
			end

			Wait(1)
		end
		
		obezwladniony = false
		SetPlayerInvincible(playerId, false)
		SetPlayerCanUseCover(playerId, true)
		SetEntityInvincible(playerPed, false)
		SetEntityCanBeDamaged(playerPed, true)
		StopAnimTask(playerPed, 'dead', 'dead_a', 4.0)
		RemoveAnimDict('dead')
		EnableAllControlActions(0)
	end)
end

function OnPlayerDeath()
	if not IsDead then
		StartDeathCam()
		IsDead = true
		ESX.UI.Menu.CloseAll()
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', 1)

		StartDeathTimer()
		StartDistressSignal()
		ClearPedTasksImmediately(playerPed)
		DeathFunc()
	else
		SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
	end
end

function TeleportFadeEffect(entity, coords)

	CreateThread(function()

		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function OpenAmbulanceActionsMenu()

	local elements = {
		{label = 'Ubranie Służbowe', value = 'cloakroom'},
		{label = 'Ubrania Prywatne', value = 'player_dressing' },
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title		= _U('ambulance'),
		align		= 'center',
		elements	= elements
	}, function(data, menu)
		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}
	
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
	
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Garderoba prywatna",
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)
	
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		elseif data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'ambulance_actions_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}
	end)
end

function OpenMobileAmbulanceActionsMenu()

	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = ('Interakcje z cywilem'), value = 'citizen_interaction'},
		{label = ('Interakcje z pojazdem'), value = 'vehicle_interaction'},
		{label = ('Kajdanki'), value = 'Kajdanki'},
		{label = ('Tablet'), value = 'tablet'}
	}

	if ESX.PlayerData.job.grade >= 10 then
		elements = {
			{label = ('Interakcje z cywilem'), value = 'citizen_interaction'},
			{label = ('Interakcje z pojazdem'), value = 'vehicle_interaction'},
			{label = ('Kajdanki'), value = 'Kajdanki'},
			{label = ('Tablet'), value = 'tablet'},
			{label = 'Sprawdź wyrok po ID', value = 'wyrok'}
		}
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions',
	{
		title		= _U('ems_menu_title'),
		align		= 'center',
		elements	= elements
	}, function(data, menu)

		if data.current.value == 'wyrok' then
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'dialog_count',
				{
					align    = 'center',
					title    = 'ID',
					elements = {}
				},
				function(data, menu)
					TriggerServerEvent('esx_ambulancejob:checkwyrok', data.value)
					menu.close()
				end,
				function(data, menu)
					menu.close()
				end
			)
		elseif data.current.value == 'OpenRehabMenu' then					
			menu.close()
			OpenRehabMenu()
		elseif data.current.value == 'tablet' then
			menu.close()
			ExecuteCommand("et")
		elseif data.current.value == 'Kajdanki' then
			menu.close()
			TriggerEvent('Kajdanki')
		elseif data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title		= _U('ems_menu_title'),
				align		= 'center',
				elements	= {
					{label = ('Ożywa obywatela'), value = 'revive'},
					{label = ('Ulecz małe rany'), value = 'small'},
					{label = ('Ulecz poważne rany'), value = 'big'},
					{label = ('Wsadz do pojazdu'), value = 'put_in_vehicle'},
					{label = ('Wyciągnij z pojazdu'), value = 'out_vehicle'},
					
				}
			}, function(data, menu)
				if IsBusy then 
					return 
				end
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer == -1 or closestDistance > 1.0 then
							ESX.ShowNotification('~r~Brak graczy w pobliżu')
						else
		
							if data.current.value == 'revive' then
		
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
		
										if IsPedDeadOrDying(closestPlayerPed, 1) or IsEntityPlayingAnim(closestPlayerPed, 'dead', 'dead_a', 3) then
		
											IsBusy = true
											ESX.ShowNotification(_U('revive_inprogress'))
		
											local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
		
											for i=1, 7, 1 do
												Wait(900)
										
												ESX.Streaming.RequestAnimDict(lib, function()
													TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
												end)
											end
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:reviveexile', GetPlayerServerId(closestPlayer))
											IsBusy = false
		
											if Config.ReviveReward > 0 then
												ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward))
											else
												ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
											end
										else
											ESX.ShowNotification(_U('player_not_unconscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
							elseif data.current.value == 'small' then
		
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Wait(10000)
											ClearPedTasks(playerPed)
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_bandage'))
									end
								end, 'bandage')
		
							elseif data.current.value == 'big' then
		
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Wait(10000)
											ClearPedTasks(playerPed)
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
		
							elseif data.current.value == 'put_in_vehicle' then
								TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
							elseif data.current.value == 'out_vehicle' then
								TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
							end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title		= _U('ems_menu_title'),
				align		= 'center',
				elements	= {
					{label = ('Napraw pojazd'), value = 'repair'},
					{label = ('Odholuj pojazd'), value = 'impound_vehicle'},
					{label = ('Obróć pojazd'), value = 'obroc'},
				}
			}, function(data, menu)
				local vehicle = ESX.Game.GetVehicleInDirection()
				if IsPedSittingInAnyVehicle(playerPed) then
					ESX.ShowNotification('Nie możesz tego w aucie zrobić!')
					return
				end
					
				if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					ESX.ShowNotification('~r~Brak pojazdu w pobliżu')
				else

					if data.current.value == 'repair' then
						if(not IsPedInAnyVehicle(playerPed)) then
							TriggerEvent('esx_mechanikjob:onFixkitFree')
						end
					elseif data.current.value == 'obroc' then
						menu.close()
						if not exports["exile_taskbar"]:isBusy() then
							TriggerServerEvent('exile:pay', 1000)
						end
						ObrocPojazd()
					elseif data.current.value == 'hijack' then
						if(not IsPedInAnyVehicle(playerPed)) then
							TriggerServerEvent('exile:pay', 1500)
							menu.close()
							TriggerEvent('esx_mechanikjob:onHijack')
						end
					elseif data.current.value == 'impound_vehicle' then 
						if not exports["esx_lscustom"]:OnTuneCheck() then
							if CurrentTask.Busy then
								return
							end
					
							ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie~s~')
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					
							CurrentTask.Busy = true
							CurrentTask.Task = ESX.SetTimeout(10000, function()
								ClearPedTasks(playerPed)
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
								ESX.Game.DeleteVehicle(vehicle)
					
								CurrentTask.Busy = false
								Wait(100)
							end)
					
							CreateThread(function()
								while CurrentTask.Busy do
									Wait(1000)
					
									vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
									if not DoesEntityExist(vehicle) and CurrentTask.Busy then
										ESX.ShowNotification(_U(action .. '_canceled_moved'))
										ESX.ClearTimeout(CurrentTask.Task)
					
										ClearPedTasks(playerPed)
										CurrentTask.Busy = false
										break
									end
								end
							end)
						end
					end

					
				end
			end, function(data, menu)
				menu.close()
			end)		
		end

	end, function(data, menu)
		menu.close()
	end)
end


function OpenCloakroomMenu()

	ESX.UI.Menu.CloseAll()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{label = 'Ubrania Służbowe', value = 'alluniforms'},
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'alluniforms' then
			local elements2 = {
				{label = "Trial Period", value = 'trialperiod_wear'},
			}

			if ESX.PlayerData.job.grade == 0 then
				table.insert(elements2, {label = "Nurse", value = 'trainee_wear'})
			elseif ESX.PlayerData.job.grade == 1 then
				table.insert(elements2, {label = "Paramedic", value = 'paramedic_wear'})
			elseif ESX.PlayerData.job.grade == 2 then
				table.insert(elements2, {label = "Senior Paramedic", value = 'seniorparamedic_wear'})
			elseif ESX.PlayerData.job.grade == 3 then
				table.insert(elements2, {label = "Doctor", value = 'doctor_wear'})
			elseif ESX.PlayerData.job.grade == 4 then
				table.insert(elements2, {label = "Senior Doctor", value = 'seniordoctor_wear'})
			elseif ESX.PlayerData.job.grade == 5 then
				table.insert(elements2, {label = "Medical Specialist", value = 'medicalspecialist_wear'})
			elseif ESX.PlayerData.job.grade == 6 then
				table.insert(elements2, {label = "Surgeon", value = 'surgeon_wear'})
			elseif ESX.PlayerData.job.grade == 7 then
				table.insert(elements2, {label = "Assistant Neurosurgeon", value = 'assistantneurosurgeon_wear'})
			elseif ESX.PlayerData.job.grade == 8 then
				table.insert(elements2, {label = "Neurosurgeon", value = 'neurosurgeon_wear'})
			elseif ESX.PlayerData.job.grade == 9 then
				table.insert(elements2, {label = "Professor", value = 'professor_wear'})
			elseif ESX.PlayerData.job.grade >= 10 then
				table.insert(elements2, {label = "Nurse", value = 'trainee_wear'})
				table.insert(elements2, {label = "Paramedic", value = 'paramedic_wear'})
				table.insert(elements2, {label = "Senior Paramedic", value = 'seniorparamedic_wear'})
				table.insert(elements2, {label = "Doctor", value = 'doctor_wear'})
				table.insert(elements2, {label = "Senior Doctor", value = 'seniordoctor_wear'})
				table.insert(elements2, {label = "Medical Specialist", value = 'medicalspecialist_wear'})
				table.insert(elements2, {label = "Surgeon", value = 'surgeon_wear'})
				table.insert(elements2, {label = "Assistant Neurosurgeon", value = 'assistantneurosurgeon_wear'})
				table.insert(elements2, {label = "Neurosurgeon", value = 'neurosurgeon_wear'})
				table.insert(elements2, {label = "Professor", value = 'professor_wear'})
			end

			ESX.TriggerServerCallback('esx_license:checkLicense', function(kochalegie)
				if kochalegie then
					table.insert(elements2, {label = "SWIM", value = 'SWIM_wear'})
				end
			end, GetPlayerServerId(playerId), 'sams_swim')
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'alluniforms', {
				title    = "Szatnia - SAMS",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

	if
		data.current.value == 'trialperiod_wear' or
		data.current.value == 'trainee_wear' or
		data.current.value == 'nurse_wear' or
		data.current.value == 'paramedic_wear' or
		data.current.value == 'doctor_wear' or
		data.current.value == 'seniordoctor_wear' or
		data.current.value == 'medicalspecialist_wear' or
		data.current.value == 'assistantneurosurgeon_wear' or
		data.current.value == 'neurosurgeon_wear' or data.current.value == 'surgeon_wear' or data.current.value == 'SWIM_wear'
	then
		setUniform(data.current.value, playerPed)
	end

	end, function(data, menu)
		menu.close()
		
		CurrentAction		= 'ambulance_actions_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}

	end)
end

function SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, extrason, extrasoff, bulletproof, tint, wheel, tuning, plate)
	local t = {
		modArmor        = 4,
		modTurbo        = true,
		modXenon        = true,
		windowTint      = 0,
		dirtLevel       = 0,
		color1			= 0,
		color2			= 0
	}
	
	if tuning then
		t.modEngine = 3
		t.modBrakes = 2
		t.modTransmission = 2
		t.modSuspension = 3
	end

	if offroad then
		t.wheelColor = 5
		t.wheels = 4
		t.modFrontWheels = 17
	end

	if wheelsxd then
		t.wheels = 1
		t.modFrontWheels = 5
	end

	if bulletproof then
		t.bulletProofTyre = true
	end

	if color then
		t.color1 = color
	end

	if tint then
		t.windowTint = tint
	end

	if wheel then
		t.wheelColor = wheel.color
		t.wheels = wheel.group
		t.modFrontWheels = wheel.type
	end
	
	ESX.Game.SetVehicleProperties(vehicle, t)

	if #extrason > 0 then
		for i=1, #extrason do
			SetVehicleExtra(vehicle, extrason[i], false)
		end
	end
	
	if #extrasoff > 0 then
		for i=1, #extrasoff do
			SetVehicleExtra(vehicle, extrasoff[i], true)
		end
	end
	  
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end

function CanPlayerUseHidden(grade)
	return not grade or ESX.PlayerData.secondjob.grade >= grade
end

function CanPlayerUse(grade)
	return not grade or ESX.PlayerData.job.grade >= grade
end

function OpenVehicleSpawnerMenu(partNum)
	local vehicles = Config.Ambulance.Vehicles
	
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local found = true
	
	for i, group in ipairs(Config.VehicleGroups) do
		local elements2 = {}
		
		for _, vehicle in ipairs(Config.AuthorizedVehicles) do
			local let = false
			for _, group in ipairs(vehicle.groups) do
				if group == i then
					let = true
					break
				end
			end

			if let then
				if vehicle.grade then
					if vehicle.hidden == true then
						if i ~= 5 then
							if not CanPlayerUseHidden(vehicle.grade) then
								let = false
							end
						else
							if not CanPlayerUseHidden(vehicle.grade) and not CanPlayerUse(vehicle.grade) then
								let = false
							end
						end
					else
						if not CanPlayerUse(vehicle.grade) then
							let = false
						end
					end
				elseif vehicle.grades and #vehicle.grades > 0 then
					let = false
					for _, grade in ipairs(vehicle.grades) do
						if ((vehicle.swat and IsSWAT) or grade == ESX.PlayerData.job.grade) and (not vehicle.label:find('SEU') or IsSEU) then
							let = true
							break
						end
					end
				end

				if let then
					table.insert(elements2, { label = vehicle.label, model = vehicle.model, livery = vehicle.livery, extrason = vehicle.extrason, extrasoff = vehicle.extrasoff, offroad = vehicle.offroad, wheelsxd = vehicle.wheelsxd, color = vehicle.color, plate = vehicle.plate, tint = vehicle.tint, bulletproof = vehicle.bulletproof, wheel = vehicle.wheel, tuning = vehicle.tuning })
				end
			end
		end
			
		if (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade >= 10) then
			if #elements2 > 0 then
				table.insert(elements, {label = group, value = elements2, group = i})				
			end
		else
			if i == 4 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(playerId), 'sams_moto')
			elseif i == 5 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(playerId), 'sams_offroad')
			elseif i == 6 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(playerId), 'sams_msu')
			else
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		end
	end
	
	while not found do
		Wait(100)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
	  title    = _U('vehicle_menu'),
	  align    = 'center',
	  elements = elements
	}, function(data, menu)
		menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner_' .. data.current.group, {
				title    = data.current.label,
				align    = 'center',
				elements = data.current.value
			}, function(data2, menu2)
				local livery = data2.current.livery
				local extrason = data2.current.extrason
				local extrasoff = data2.current.extrasoff
				local offroad = data2.current.offroad
				local wheelsxd = data2.current.wheelsxd
				local color = data2.current.color
				local bulletproof = data2.current.bulletproof or false
				local tint = data2.current.tint
				local wheel = data2.current.wheel
				local tuning = data2.current.tuning

				local setPlate = true
				if data2.current.plate ~= nil and not data2.current.plate then
					setPlate = false
				end

				local vehicle = GetClosestVehicle(vehicles[partNum].spawnPoint.x,  vehicles[partNum].spawnPoint.y,  vehicles[partNum].spawnPoint.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) then	
					ESX.Game.SpawnVehicle(data2.current.model, {
						x = vehicles[partNum].spawnPoint.x,
						y = vehicles[partNum].spawnPoint.y,
						z = vehicles[partNum].spawnPoint.z
					}, vehicles[partNum].heading, function(vehicle)
						SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)

						if setPlate then
							local plate = ""
							
							if data.current.label == 'PATROL' then
								plate = math.random(100, 999) .. "SAMS" .. math.random(100, 999)
							elseif ESX.PlayerData.secondjob.name == 'sheriff' then
								plate = "SAMS " .. math.random(100,999)
							else
								plate = "SAMS " .. math.random(100,999)
							end
							
							SetVehicleNumberPlateText(vehicle, plate)
							local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
							TriggerEvent('ls:dodajklucze2', localVehPlate)
						else
							local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
							TriggerEvent('ls:dodajklucze2', localVehPlate)
						end

						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					end)
				else
					ESX.ShowNotification('Pojazd znaduje się w miejscu wyciągnięcia następnego')
				end
			end, function(data2, menu2)
				menu.close()
				OpenVehicleSpawnerMenu(partNum)
			end)
		else
			ESX.ShowNotification("~r~Brak pojazdów dostępnych w tej kategorii dla twojego stopnia.")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end)
end

function OpenHeliSpawnerMenu(zoneNumber)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'heli_spawner',
	{
		title		= "Helikoptery",
		align		= 'center',
		elements	= Config.AuthorizedHeli
	}, function(data, menu)
		menu.close()
		ESX.Game.SpawnVehicle(data.current.model, Config.Ambulance.Helicopters[zoneNumber].spawnPoint, Config.Ambulance.Helicopters[zoneNumber].heading, function(vehicle)
			local plate = "SAMS " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'heli_spawner_menu'
		CurrentActionMsg	= 'Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć helikopter.'
		CurrentActionData	= {zoneNumber = zoneNumber}
	end
	)
end

function OpenBoatSpawnerMenu(zoneNumber)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_spawner',
	{
		title		= "Garaż łodzi",
		align		= 'center',
		elements	= Config.AuthorizedBoats
	}, function(data, menu)
		menu.close()

		ESX.Game.SpawnVehicle(data.current.model, Config.Ambulance.Boats[zoneNumber].spawnPoint, Config.Ambulance.Boats[zoneNumber].heading, function(vehicle)
			local plate = "SAMS " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'boat_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć łódź"
		CurrentActionData	= {zoneNumber = zoneNumber}
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pharmacy',
	{
		title		= _U('pharmacy_menu_title'),
		align		= 'center',
		elements = {
			{label = _U('pharmacy_take') .. ' ' .. _('medikit'), value = 'medikit'},
			{label = _U('pharmacy_take') .. ' ' .. _('bandage'), value = 'bandage'},
			{label = _U('pharmacy_take') .. ' ' .. "Gps", value = 'gps', count = 1},
			{label = _U('pharmacy_take') .. ' ' .. "BodyCam", value = 'bodycam', count = 1},
			{label = _U('pharmacy_take') .. ' ' .. "Radio", value = 'radio', count = 1},
		},
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value, data.current.count)

	end, function(data, menu)
		menu.close()
		CurrentAction		= 'pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}
	end
	)
end

AddEventHandler('playerSpawned', function()
	EndDeathCam()
	IsDead = false

	if FirstSpawn then
		FirstSpawn = false
		CreateThread(function()
			local status = 0
			while true do
				if status == 0 then
					status = 1 
					TriggerEvent('falszywyy:load', function(result)
						if result == 3 then
							status = 2
						else
							status = 0
						end
					end)
				end
				
				Wait(200)
				if status == 2 then
					break
				end
			end
			
			exports.spawnmanager:setAutoSpawn(false)
		end)
	end
end)

RegisterNetEvent('esx_healthnarmour:set')
AddEventHandler('esx_healthnarmour:set', function(health, armour)
	local status = 0
	while true do
		if status == 0 then
			status = 1
			TriggerEvent('falszywyy:load', function(result)
				if result == 3 then
					status = 2
				else
					status = 0
				end
			end)
		end
		
		Wait(200)
		if status == 2 then
			break
		end
	end
	SetEntityHealth(playerPed, tonumber(health))
	SetPedArmour(playerPed, tonumber(armour))
	if tonumber(health) == 0 then
		ESX.ShowNotification('~r~Jesteś nieprzytomny/a, ponieważ przed wyjściem z serwera Twoja postać miała BW')
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		
		if blockShooting > GetGameTimer() then
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		else
			Wait(1000)
		end
	end
end)

function IsBlockWeapon()
	return blockShooting > GetGameTimer()
end

RegisterNetEvent('esx_ambulancejob:reviveexile')
AddEventHandler('esx_ambulancejob:reviveexile', function(notBlock)
	if notBlock == nil then
		notBlock = false
	end
	if IsDead and not notBlock then
		blockShooting = GetGameTimer() + (5 * 60000)
	end
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
	DoScreenFadeOut(800)

	Wait(800)
	
	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)
	ESX.SetPlayerData('loadout', {})
	TriggerServerEvent('esx:updateCoords', formattedCoords)
	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

RegisterNetEvent('esx_ambulancejob:reviveobez')
AddEventHandler('esx_ambulancejob:reviveobez', function(notBlock)
	if notBlock == nil then
		notBlock = false
	end
	if not notBlock then
		blockShooting = GetGameTimer() + (1 * 60000)
	end
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
	DoScreenFadeOut(800)

	Wait(800)
	
	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)
	ESX.SetPlayerData('loadout', {})
	TriggerServerEvent('esx:updateCoords', formattedCoords)
	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

CreateThread(function()
	local lastHealth = GetEntityHealth(playerPed)
	local lastArmour = GetPedArmour(playerPed)
	while true do
		Wait(1000)
		local health = GetEntityHealth(playerPed)
		local armour = GetPedArmour(playerPed)
		if HasEntityBeenDamagedByWeapon(playerPed, `WEAPON_RAMMED_BY_CAR`, 0) then
			ClearEntityLastDamageEntity(playerPed)
			if (health ~= lastHealth) then
				SetEntityHealth(playerPed, lastHealth)
			end
			if (armour ~= lastArmour) then
				SetPedArmour(playerPed, lastArmour)
			end
		end
		lastArmour = armour
		lastHealth = health
	end
end)

RegisterNetEvent('esx_ambulancejob:reviveblack')
AddEventHandler('esx_ambulancejob:reviveblack', function(admin)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
	DoScreenFadeOut(800)

	Wait(800)

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)
	ESX.SetPlayerData('loadout', {})
	TriggerServerEvent('esx:updateCoords', formattedCoords)
	RespawnPed(playerPed, formattedCoords, 0.0)

	if admin and admin ~= nil then
		TriggerEvent("esx:showNotification", "~g~Zostałeś ożywiony przez administratora ~b~"..admin.."~g~!")
	end

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

CreateThread(function()
	while true do
		Wait(2)
		if IsDead then
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 56, true)
			exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
		else
			Wait(500)
			exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
		end
	end
end)

function RestrictedMenu()
	ESX.UI.Menu.CloseAll()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'center',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			local t = true
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
					if bought then
						
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
							currentSkin = skin
						end)

						ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
							if foundStore then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing',
								{
									title = _U('save_in_dressing'),
									align = 'center',
									elements = {
										{label = _U('no'),  value = 'no'},
										{label = _U('yes'), value = 'yes'}
									}
								}, function(data2, menu2)
									menu2.close()

									if data2.current.value == 'yes' then
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
											title = _U('name_outfit')
										}, function(data3, menu3)
											menu3.close()

											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
												ESX.ShowNotification('~g~Ubranie zostalo zapisane w domu\n~b~Nazwą zapisanego ubrania: ~g~'..data3.value)
												t = true												
											end)
										end, function(data3, menu3)
											menu3.close()
										end)
									end
								end)
							end
						end)

					else
						t = false
						ESX.ShowNotification(_U('not_enough_money'))
						cleanPlayer()
					end
				end)
			elseif data.current.value == 'no' then
				OpenShopMenu()
				t = false
			end
			
			if t then
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end
		end, function(data, menu)
			menu.close()
			cleanPlayerskin()
		end)

	end, function(data, menu)
		menu.close()
		cleanPlayerskin()
		
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'watches_1',
		'watches_2',
		'helmet_1',
		'helmet_2',
		'mask_1',
		'mask_2',
		'glasses_1',
		'glasses_2',
		'bags_1',
		'bags_2'
	})
end

function OpenShopMenu()
	local elements = {
		{label = _U('shop_clothes'),  value = 'shop_clothes'},
		{label = ('Własne ubrania'), value = 'player_dressing'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title    = _U('shop_main_menu'),
		align    = 'center',
		elements = elements,
    }, function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			RestrictedMenu()
		end

		if data.current.value == 'player_dressing' then
			OpenClothes()
		end
    end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
    end)
end

function OpenClothes()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for k,v in pairs(dressing) do
			table.insert(elements, {label = v, value = k})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
			title    = 'Garderoba',
			align    = 'center',
			elements = elements
		}, function(data, menu)		
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
				title = 'Wybierz ubranie - ' .. data.current.label,
				align = 'center',
				elements = {
					{label = 'Ubierz', value = 'wear'},
					{label = 'Zmień nazwę', value = 'rename'},
					{label = 'Usuń ubranie', value = 'remove'}
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value == 'wear' then
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data.current.value)
					end)
				elseif data2.current.value == 'rename' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
						title = 'Zmień nazwę - ' .. data.current.label
					}, function(data3, menu3)
						menu3.close()
						TriggerServerEvent('esx_property:renameOutfit', data.current.value, data3.value)
						ESX.ShowNotification('Zmieniono nazwę ubrania!')
						OpenClothes()
					end, function(data3, menu3)
						menu3.close()
						menu2.open()
					end)
				elseif data2.current.value == 'remove' then
					TriggerServerEvent('esx_property:removeOutfit', data.current.value)
					ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data.current.label)
					OpenClothes()
				end
			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)		
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end)
	end)
end

function cleanPlayerskin()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(zone, number)
	if zone == 'Cloakrooms' then
		CurrentAction		= 'ambulance_actions_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}
	end

	if zone == 'LicensesMenu' then
		CurrentAction				 	= 'ambulance_licenes_menu'
		CurrentActionMsg			= "Naciśnij ~INPUT_CONTEXT~, aby zarządzać licencjami"
		CurrentActionData    = {}
	end

	if zone == 'Vehicles' then
		CurrentAction		= 'vehicle_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć pojazd"
		CurrentActionData	= {zoneNumber = number}
	end

	if zone == 'Boats' then
		CurrentAction		= 'boat_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć łódź"
		CurrentActionData	= {zoneNumber = number}
	end

	if zone == 'Pharmacies' then
		CurrentAction		= 'pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}
	end

	if zone == 'Helicopters' then
		CurrentAction		= 'heli_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć helikopter."
		CurrentActionData	= {zoneNumber = number}
	end
	
	if zone == 'Inventories' then
		CurrentAction		= 'items_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end

	if zone == 'Inventories2' then
		CurrentAction		= 'items2_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end
	
	if zone == 'BossActions' then
		CurrentAction		= 'boss_actions'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu zarządzania"
		CurrentActionData	= {}
	end

	if zone == 'SkinMenu' then
		CurrentAction = 'menu_skin'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~ aby się przebrać"
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleters' then
		if IsPedInAnyVehicle(playerPed, false) then
			local coords	= GetEntityCoords(playerPed, true)
			local vehicle, distance = ESX.Game.GetClosestVehicle({
			  x = coords.x,
			  y = coords.y,
			  z = coords.z
			})
			if distance ~= -1 and distance <= 1.0 then
				CurrentAction	 = 'delete_vehicle'
				CurrentActionMsg  = 'Schowaj pojazd'
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create blips
function refreshBlip()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
		for _, ez in ipairs(Config.OnlySamsBlip) do
			local blip = AddBlipForCoord(ez.Pos.x, ez.Pos.y, ez.Pos.z)
			SetBlipSprite (blip, ez.Sprite)
			SetBlipDisplay(blip, ez.Display)
			SetBlipScale  (blip, ez.Scale)
			SetBlipColour (blip, ez.Colour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Łodzie - SAMS")
			EndTextCommandSetBlipName(blip)
			Wait(0)
			table.insert(SamsBlip, blip)
		end
	end
end

function deleteBlip()
	if SamsBlip[1] ~= nil then
		for i=1, #SamsBlip, 1 do
			RemoveBlip(SamsBlip[i])
		end
		SamsBlip = {}
	end
end

CreateThread(function()
	for i=1, #Config.Blips, 1 do
		local cBlip = Config.Blips[i]
		local blip = AddBlipForCoord(cBlip.coords)

		SetBlipSprite(blip, Config.Sprite)
		SetBlipDisplay(blip, Config.Display)
		SetBlipScale(blip, Config.Scale)
		SetBlipColour(blip, Config.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Szpital")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(1000)
	end
	
	while true do
		Wait(3)
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance') then
			local found = false
			for k,v in pairs(Config.Ambulance) do
				for i=1, #v, 1 do
					if k == 'VehicleDeleters' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					elseif k == 'Cloakrooms' and (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance') then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawMarker(v[i].coords)
						end					
					end
					if k ~= 'VehicleDeleters' and k ~= 'Cloakrooms' and ESX.PlayerData.job.name == 'ambulance' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawMarker(v[i].coords)
						end
					end
				end
			end
			
			if not found then
				Wait(2000)
			end
		else
			Wait(2000)
		end
	end
end)

-- Activate menu when player is inside marker
CreateThread(function()
	while true do
		Wait(100)

		local sleep		= true
		local isInMarker	= false
		local currentZone	= nil
		local zoneNumber 	= nil
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance') then
			for k,v in pairs(Config.Ambulance) do
				for i=1, #v, 1 do
					if k == 'VehicleDeleters' then
						if #(coords - v[i].coords) < 3.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
					elseif k == 'Cloakrooms' then						
						if #(coords - v[i].coords) < Config.MarkerSize.x then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
					end
					if k ~= 'VehicleDeleters' and k ~= 'Cloakrooms' then
						if #(coords - v[i].coords) < Config.MarkerSize.x then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
					end
				end
			end
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone				= currentZone
				TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_ambulancejob:hasExitedMarker', lastZone)
			end
			if sleep then
				Wait(1000)
			end
		else
			Wait(1000)
		end
	end
end)

function OpenInventoryMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'items', {
		title    = 'Szafka',
		align    = 'center',
		elements = {
			{label = 'Wyciągnij ekwipunek', value = 'get'},
			{label = 'Zdeponuj ekwipunek', value = 'put'},
		}
	}, function(data,menu)
		menu.close()
		if data.current.value == 'get' then
			TriggerEvent('exile:getInventoryItem', 'society_ambulance')
		elseif data.current.value == 'put' then
			TriggerEvent('exile:putInventoryItem', 'society_ambulance')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'items_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end)
end

function OpenInventoryMenu2()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'items', {
		title    = 'Szafka',
		align    = 'center',
		elements = {
			{label = 'Wyciągnij ekwipunek', value = 'get'},
			{label = 'Zdeponuj ekwipunek', value = 'put'},
		}
	}, function(data,menu)
		menu.close()
		if data.current.value == 'get' then
			TriggerEvent('exile:getInventoryItem', 'society_sams2')
		elseif data.current.value == 'put' then
			TriggerEvent('exile:putInventoryItem', 'society_sams2')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'items2_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end)
end

-- Key Controls
CreateThread(function()
	while true do
		Wait(0)
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance') then
			if CurrentAction ~= nil then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then	
		
					if CurrentAction == 'ambulance_actions_menu' then
						OpenAmbulanceActionsMenu()
					end

					if CurrentAction == 'vehicle_spawner_menu' then
						OpenVehicleSpawnerMenu(CurrentActionData.zoneNumber)
					end

					if CurrentAction == 'heli_spawner_menu' then
						if heli then
							OpenHeliSpawnerMenu(CurrentActionData.zoneNumber)
						else
							ESX.ShowNotification('Nie posiadasz licencji na helikopter')
						end
					end

					if CurrentAction == 'boat_spawner_menu' then
						OpenBoatSpawnerMenu(CurrentActionData.zoneNumber)
					end

					if CurrentAction == 'pharmacy' then
						OpenPharmacyMenu()
					end

					if CurrentAction == 'ambulance_licenes_menu' then
						if ESX.PlayerData.job.grade >= 11 then
							LicenseSAMS('ambulance')
						else
							ESX.ShowNotification('Nie masz do tego dostępu')
						end
					end
					
					if CurrentAction == 'items_menu' then
						OpenInventoryMenu()
					end

					if CurrentAction == 'items2_menu' then
						if ESX.PlayerData.job.grade >= 11 then
							OpenInventoryMenu2()
						else
							ESX.ShowNotification('Nie masz do tego dostępu')
						end
					end

					if CurrentAction == 'menu_skin' then
						OpenShopMenu()
					end
					
					if CurrentAction == 'boss_actions' then
						ESX.UI.Menu.CloseAll()
						if ESX.PlayerData.job.grade >= 10 then
							TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', 'ambulance', function(data, menu)
								menu.close()
							end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true, badges = true})
						else
							TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', 'ambulance', function(data, menu)
								menu.close()
							end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false, badges = true})
						end
					end
					if CurrentAction == 'delete_vehicle' then
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					end
					CurrentAction = nil	
				end
			
			else
				Wait(500)
			end
		else
			Wait(1000)
		end
	end
end)

CreateThread(function()
	local timer = GetGameTimer()
	
	while true do

		Wait(0)
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
			if CurrentTask.busy then
				if IsControlJustReleased(0, 38) and timer < GetGameTimer() then
					ESX.ShowNotification('Unieważniasz zajęcie')
					ESX.ClearTimeout(CurrentTask.task)
					ClearPedTasks(playerPed)

					CurrentTask.busy = false
					
					timer = GetGameTimer() + 500
				end	
			else
				Wait(500)
			end
		else
			Wait(1000)
		end
	end
end)

RegisterCommand('-ambuf6', function(source, args, rawCommand)
	if not IsDead and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance' then
		OpenMobileAmbulanceActionsMenu()
	end
end, false)

RegisterKeyMapping('-ambuf6', 'Otwórz medyczne menu', 'keyboard', 'F6')

RegisterNetEvent('esx_ambulancejob:requestDeath')
AddEventHandler('esx_ambulancejob:requestDeath', function()
	if Config.AntiCombatLog then
		Wait(6000)
		SetEntityHealth(playerPed, 0)
		ESX.ShowNotification('~r~Jesteś nieprzytomny/a, ponieważ przed wyjściem z serwera Twoja postać miała BW')
	end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function LicenseSAMS(society)
	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getEmployeeslic', function(employees)
		local elements = nil
		local identifier = ''
			elements = {
				head = {"Pracownik", "HELI", "MOTO", "OFF-ROAD", "MSU", "SWIM", "Akcje"},
				rows = {}
			}
			for i=1, #employees, 1 do
				local licki = {}
				if employees[i].licensess.heli == true then
					licki[1] = '✔️'
				else
					licki[1] = "❌"
				end	
				if employees[i].licensess.moto == true then
					licki[2] = '✔️'
				else
					licki[2] = "❌"
				end	
				if employees[i].licensess.offroad == true then
					licki[3] = '✔️'
				else
					licki[3] = "❌"
				end	
				if employees[i].licensess.msu == true then
					licki[4] = '✔️'
				else
					licki[4] = "❌"
				end			
				if employees[i].licensess.swim == true then
					licki[5] = '✔️'
				else
					licki[5] = "❌"
				end		
				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						licki[1],
						licki[2],
						licki[3],
						licki[4],
						licki[5],
						'{{' .. "Nadaj Licencję" .. '|give}} {{' .. "Odbierz Licencję" .. '|take}}'
					}
				})
			end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data
			local elements = {
				{label = ('Licencja HELI'), value = 'heli'},
				{label = ('Licencja MOTO'), value = 'moto'},
				{label = ('Licencja OFF-ROAD'), value = 'offroad'},
				{label = ('Licencja MSU'), value = 'msu'},
				{label = ('Licencja SWIM'), value = 'swim'},
			}
			if data.value == 'give' then
				menu.close()
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'licencje',
					{
					  title = ('Nadaj licencje dla '..employee.name),
					  align = 'center',
					  elements = elements
					}, function(data2, menu2)
						local amount = data2.current.value
						local wartosc = ''

						if amount == 'heli' then
							wartosc = 'sams_heli'
						elseif amount == 'moto' then
							wartosc = 'sams_moto'
						elseif amount == 'offroad' then
							wartosc = 'sams_offroad'						
						elseif amount == 'msu' then
							wartosc = 'sams_msu'
						elseif amount == 'swim' then
							wartosc = 'sams_swim'
						end
						TriggerServerEvent('esx_ambulancejob:addlicense', employee.identifier, wartosc)
						ESX.ShowNotification('Nadano licencje ~b~'..amount.. '~s~ dla ~b~' ..employee.name)
					end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.value == 'take' then
				menu.close()
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'licencje',
					{
					  title = ('Wycofaj licencje dla '..employee.name),
					  align = 'center',
					  elements = elements
					}, function(data3, menu3)
						local amount = data3.current.value
						local wartosc = ''
						
						if amount == 'heli' then
							wartosc = 'sams_heli'
						elseif amount == 'moto' then
							wartosc = 'sams_moto'
						elseif amount == 'offroad' then
							wartosc = 'sams_offroad'						
						elseif amount == 'msu' then
							wartosc = 'sams_msu'
						elseif amount == 'swim' then
							wartosc = 'sams_swim'
						end
						TriggerServerEvent('esx_ambulancejob:removelicense', employee.identifier, wartosc)
						ESX.ShowNotification('Wycofano licencje ~b~'..amount.. ' ~s~dla ~b~' ..employee.name)		
					end, function(data3, menu3)
					menu3.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, 'ambulance', society)
end

local cam = nil

local angleY = 0.0
local angleZ = 0.0

CreateThread(function()
    while true do
        Wait(1)
        if (cam and IsDead) then
            ProcessCamControls()
		else
			Wait(1000)
		end
    end
end)

-- initialize camera
function StartDeathCam()
    ClearFocus()
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

-- destroy camera
function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    
    cam = nil
end

function ProcessCamControls()
    DisableFirstPersonCamThisFrame()
    
    local newPos = ProcessNewPosition()

    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    
    PointCamAtCoord(cam, coords.x, coords.y, coords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
    else
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX
    angleY = angleY + mouseY
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
        
    local behindCam = {
        x = coords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (3.5 + 0.5),
        y = coords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (3.5 + 0.5),
        z = coords.z + ((Sin(angleY))) * (3.5 + 0.5)
    }
    local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, playerPed, 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = 3.5
    if (hitBool and Vdist(coords.x, coords.y, coords.z + 0.5, hitCoords) < 3.5 + 0.5) then
        maxRadius = Vdist(coords.x, coords.y, coords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = coords.x + offset.x,
        y = coords.y + offset.y,
        z = coords.z + offset.z
    }
    return pos
end

RegisterCommand("ulecz",function(source, cmd)
	if ESX.PlayerData.job.name == 'ambulance' then
		ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(ExilePlayers)
			if ExilePlayers then
				if ESX.PlayerData.job.grade >= 10 then 
					TriggerServerEvent('esx_ambulancejob:es', cmd)
				elseif ESX.PlayerData.job.grade > 1 and ExilePlayers['ambulance'] <= 2 then
					TriggerServerEvent('esx_ambulancejob:es', cmd)
				else
					ESX.ShowNotification('Nie możesz używać uleczki brak odpowiedniego stopnia bądź jest 2 medyków na służbie')
				end
			end
		end)
	elseif ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' then
		if ESX.PlayerData.job.grade > 3 and ESX.PlayerData.job.grade <= 10 then
			ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(ExilePlayers)
				if ExilePlayers then
					if ExilePlayers['ambulance'] == 0 then
						TriggerServerEvent('esx_ambulancejob:es', cmd)
					else
						ESX.ShowNotification('~r~Aby pomóc wezwij SAMS')
					end
				end
			end)
		elseif ESX.PlayerData.job.grade > 10 then
			TriggerServerEvent('esx_ambulancejob:es', cmd)
		elseif ESX.PlayerData.job.grade <= 2 then
			ESX.ShowNotification('~r~Nie masz odpowiedniego wyszkolenia do pomocy obywatelom')
		end
	else
		ESX.ShowNotification('~r~Nie posiadasz dostępu!')
	end
end)

function ObrocPojazd()
	attempt = 0
	local vehicle   = ESX.Game.GetVehicleInDirection()
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification('Nie możesz tego wykonać w środku pojazdu!')
		return
	end
	if vehicle and DoesEntityExist(vehicle) then
		IsBusy = true
		CreateThread(function()
			if not exports["exile_taskbar"]:isBusy() then
				TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			end
			exports["exile_taskbar"]:taskBar(20000, "Obracanie pojazdu", true, function(cb) 
				if cb then
					while not NetworkHasControlOfEntity(entity) and attempt < 10 and DoesEntityExist(entity) do
						Wait(100)
						NetworkRequestControlOfEntity(entity)
						attempt = attempt + 1
					end
					local carCoords = GetEntityRotation(vehicle, 2)
					SetEntityRotation(vehicle, carCoords[1], 0, carCoords[3], 2, true)
					SetVehicleOnGroundProperly(vehicle)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification('Pojazd obrócony!')
				end
				IsBusy = false
			end)
		end)
	else
		ESX.ShowNotification('W pobliżu nie ma żadnego pojazdu!')
	end
end