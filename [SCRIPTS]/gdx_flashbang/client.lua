local IsWeakEffectSoundThreadWorking = false

if Config.FlashEffectWhiteScreenFadeOutTempo <= 0 then
	Config.FlashEffectWhiteScreenFadeOutTempo = 1.0
	print("FlashEffectWhiteScreenFadeOutTempo can't be zero, changing to 1.0")
end

CreateThread(function()
	if IsWeaponValid(`WEAPON_FLASHBANG`) then
		AddTextEntry("WT_GNADE_FLSH", Config.WeaponLabel)

		while true do
			local playerPed = PlayerPedId()
			local weapon = GetSelectedPedWeapon(playerPed)
			if weapon == `WEAPON_FLASHBANG` then
				if IsPedShooting(playerPed) then
					local playerPos = GetEntityCoords(playerPed)
					CreateThread(function()
						local handle = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 10.0, `w_ex_flashbang`, false, false, false)
				
						Wait(Config.ExplodeTime)
						
						if DoesEntityExist(handle) then
							local coords = GetEntityCoords(handle)
							SetEntityAsMissionEntity(handle, false, true)
							DeleteEntity(handle)
							AddFlashBangExplosion(coords)
							TriggerServerEvent("mmflashbang:Particles", coords)
						end
					end)
				end
			else
				Wait(300)
			end
	
			Wait(0)
		end
	end
end)

RegisterNetEvent("mmflashbang:Particles", function(pos)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	local type = CanGetFlashed(pos, playerPed, playerCoords)

	if #(playerCoords - pos) < Config.ExplosionEffectVisibilityRange then
		if type == "noeffect" then
			ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.2)
		elseif type == "weakeffect" then
			ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 1.0)
			ShakeGameplayCam('DRUNK_SHAKE', 1.0)
			AnimpostfxPlay("Dont_tazeme_bro", 0, false)

			CreateThread(function()
				IsWeakEffectSoundThreadWorking = true
				SendNUIMessage({ type = 'play', file = "flashbang", volume = (Config.WeakEffectSoundVolume - (#(GetEntityCoords(playerPed) - pos) * 0.07)) })

				local init = GetGameTimer()
				local s = Config.WeakEffectSoundVolume
				while GetGameTimer() - init < Config.WeakEffectSoundDuration and IsWeakEffectSoundThreadWorking do
					local a  = #(GetEntityCoords(playerPed) - pos)
					local sa = s - (a * 0.07)
					
					if sa < 0.0 then sa = 0.0 end

					if Config.UpdateEffectVolumeOnWeakEffect then SendNUIMessage({ type = 'volume', volume = sa }) end
					
					Wait(50)
				end
				if IsWeakEffectSoundThreadWorking then
					SendNUIMessage({ type = 'stop' })
				end
			end)

			CreateThread(function()
				Wait(Config.WeakEffectDuration)
				AnimpostfxStop("Dont_tazeme_bro")
				Wait(Config.AfterExplosionCameraReturnDuration)
				StopGameplayCamShaking(false)
			end)
		elseif type == "flash" then
			IsWeakEffectSoundThreadWorking = false
			ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 1.0)
			ShakeGameplayCam('DRUNK_SHAKE', 3.0)
			AnimpostfxPlay("Dont_tazeme_bro", 0, false)
			SendNUIMessage({ type = 'play', file = "flashbang", volume = Config.FlashEffectSoundVolume  })
			SendNUIMessage({ volume = Config.FlashEffectSoundVolume  })
			
			if Config.RagdollOnEffect then
				SetPedToRagdoll(playerPed, Config.FlashEffectWhiteScreenDuration, Config.FlashEffectWhiteScreenDuration, 0, true, true, false)
			end

			if Config.CanCutOutMumble then
				CutOutMumble(Config.MumbleCutOutDuration)
			end

			CreateThread(function()
				local init = GetGameTimer()

				while GetGameTimer() - init < Config.FlashEffectWhiteScreenDuration do
					DrawRect(0.0,0.0, 10.0, 10.0, 255, 255, 255, 255)
					Wait(0)
				end

				PlayAnim(playerPed, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 54, Config.FlashEffectDuration)

				local alpha = 255
				init = GetGameTimer()
				local init2 = init
				while alpha ~= 0 do
					local t = GetGameTimer()
					DrawRect(0.0,0.0, 10.0, 10.0, 255, 255, 255, alpha)

					if alpha > 220 then
						if t - init2 > (300 / Config.FlashEffectWhiteScreenFadeOutTempo) then
							init2 = t
							alpha = alpha - 1
						end
					elseif alpha >= 100 then
						if t - init2 > (180 / Config.FlashEffectWhiteScreenFadeOutTempo) then
							init2 = t
							alpha = alpha - 1
						end
					else
						if t - init2 >= (80 / Config.FlashEffectWhiteScreenFadeOutTempo) then
							init2 = t
							alpha = alpha - 1
						end
					end
					Wait(0)
				end
			end)

			CreateThread(function()
				local init = GetGameTimer()
				local player_ = PlayerId()

				if Config.DisablePlayerFiringOnEffect then
					SetPedCanSwitchWeapon(playerPed, false)
					while GetGameTimer() - init < Config.FlashEffectDuration do
						DisablePlayerFiring(player_, true)
						Wait(0)
					end
					SetPedCanSwitchWeapon(playerPed, true)
				else
					while GetGameTimer() - init < Config.FlashEffectDuration do
						Wait(0)
					end 
				end

				AnimpostfxStop("Dont_tazeme_bro")
				Wait(Config.AfterExplosionCameraReturnDuration)
				StopGameplayCamShaking(false)
			end)
		end
   
		RequestNamedPtfxAsset("core");
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(0)
		end
		UseParticleFxAssetNextCall("core")
		StartParticleFxLoopedAtCoord("ent_anim_paparazzi_flash", pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 25.0, false, false, false, false)
	end
end)

function CanGetFlashed(pos, playerped, playerCoords)
	local raycast = StartExpensiveSynchronousShapeTestLosProbe(pos.x, pos.y, pos.z, playerCoords.x, playerCoords.y, playerCoords.z, -1, 0, 4)
	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(raycast)
	
	if entityHit == playerped then
		local frontCoords = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 0.5, 0.0)
		local backCoords = GetOffsetFromEntityInWorldCoords(playerped, 0.0, -0.5, 0.0)

		local frontDist = #(pos - frontCoords)
		local backDist = #(pos - backCoords)
		local playerOrientation = "front"
		
		if frontDist > backDist then
			playerOrientation = "behind"
		end

		local dist = #(pos - playerCoords)

		if dist > Config.WeakEffectRange.farthest then
			return "noeffect"
		end

		if (dist > Config.WeakEffectRange.nearest and dist <= Config.WeakEffectRange.farthest) and playerOrientation == "front" then
			return "weakeffect"
		end

		if dist < Config.FlashEffectBehindPlayerRange and playerOrientation == "behind" then
			return "flash"
		end

		if dist < Config.FlashEffectInFrontOfPlayerRange and playerOrientation == "front" then
			return "flash"
		end
		
		if dist < Config.FlashEffectInFrontOfPlayerRange and playerOrientation == "behind" then
			return "weakeffect"
		end
	end
	return "noeffect"
end

function PlayAnim(ped, dict, name, flag, time)
	CreateThread(function()
		if Config.PedAnimationOnEffect then
			ClearPedTasks(ped)
			ClearPedTasksImmediately(ped)
		end
		
		if Config.MakePlayerUnarmedOnEffect then
			SetCurrentPedWeapon(ped, `weapon_unarmed`, true)
			Wait(0)
		end
		
		if Config.PedAnimationOnEffect then
			local init = GetGameTimer()
			RequestAnimDict(dict)
		
			while not HasAnimDictLoaded(dict) and GetGameTimer() - init < 30 do
				Wait(0)
			end
			
			TaskPlayAnim(ped, dict, name, 8.0, 8.0, time, flag, 1.0, false, false, false)	

			CreateThread(function()
				local init = GetGameTimer()
				while GetGameTimer() - init < time do
					if not IsEntityPlayingAnim(ped, dict, name, 3) then
						TaskPlayAnim(ped, dict, name, 8.0, 8.0, time, flag, 1.0, false, false, false)	
					end
					Wait(100)
				end
			end)
		end
	end)
end

function CutOutMumble(time)
	local players = GetActivePlayers()
	local init = GetGameTimer()
	CreateThread(function()
		while GetGameTimer() - init < time do
			for k,v in ipairs(players) do
				MumbleSetVolumeOverride(v, 0.0)
			end
			Wait(300)
		end
		for k,v in ipairs(players) do
			MumbleSetVolumeOverride(v, -1.0)
		end
	end)
end

RegisterNetEvent('gdx_flashbang:onFlash')
AddEventHandler('gdx_flashbang:onFlash', function()
	GiveWeaponToPed(PlayerPedId(), `WEAPON_FLASHBANG`, 10, false, true)
	ESX.ShowNotification('~r~Flashbang straci swoje właściwości za 15 sekund')
	Wait(15000)
	RemoveWeaponFromPed(PlayerPedId(), `WEAPON_FLASHBANG`)
end)
