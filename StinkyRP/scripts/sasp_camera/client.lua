local fov_max = 80.0
local fov_min = 5.0 
local zoomspeed = 3.0
local speed_lr = 4.0
local speed_ud = 4.0
local toggle_helicam = 51
local toggle_vision = 25
local toggle_rappel = 154
local toggle_lock_on = 22
local toggle_display = 29
local radiusup_key = 137 
local radiusdown_key = 21
local maxtargetdistance = 1000
local brightness = 1.0 
local spotradius = 4.0 
local speed_measure = "Km/h"
local target_vehicle = nil
local vehicle_display = 0 
local helicam = false
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 
local vehicles = {}
local PlayerPedId = PlayerPedId
local HasEntityClearLosToEntity = HasEntityClearLosToEntity
local IsControlJustPressed = IsControlJustPressed
local GetEntityCoords = GetEntityCoords
local GetPedInVehicleSeat = GetPedInVehicleSeat
local DoesEntityExist = DoesEntityExist
local GetVehiclePedIsIn = GetVehiclePedIsIn
local PlaySoundFrontend = PlaySoundFrontend
local SetPedCanRagdoll = SetPedCanRagdoll
local TaskRappelFromHeli = TaskRappelFromHeli
local SetTimecycleModifier = SetTimecycleModifier
local SetTimecycleModifierStrength = SetTimecycleModifierStrength
local HasScaleformMovieLoaded = HasScaleformMovieLoaded
local RequestScaleformMovie = RequestScaleformMovie
local NetworkIsSessionStarted = NetworkIsSessionStarted
local DecorRegister = DecorRegister
local CreateCam = CreateCam
local AttachCamToEntity = AttachCamToEntity
local GetEntityHeading = GetEntityHeading
local SetCamFov = SetCamFov
local SetCamRot = SetCamRot
local PushScaleformMovieFunction = PushScaleformMovieFunction
local RenderScriptCams = RenderScriptCams
local PushScaleformMovieFunctionParameterInt = PushScaleformMovieFunctionParameterInt
local PopScaleformMovieFunctionVoid = PopScaleformMovieFunctionVoid
local PointCamAtEntity = PointCamAtEntity
local DestroyCam = DestroyCam
local GetCamRot = GetCamRot
local GetCamFov = GetCamFov
local GetEntityHeightAboveGround = GetEntityHeightAboveGround
local SetNightvision = SetNightvision
local SetSeethrough = SetSeethrough
local HideHelpTextThisFrame = HideHelpTextThisFrame
local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetDisabledControlNormal = GetDisabledControlNormal
local GetDisplayNameFromVehicleModel = GetDisplayNameFromVehicleModel
local GetEntityModel = GetEntityModel
local GetLabelText = GetLabelText
local GetCamCoord = GetCamCoord
local StartShapeTestRay = StartShapeTestRay
local GetShapeTestResult = GetShapeTestResult
local IsEntityAVehicle = IsEntityAVehicle
local GetEntitySpeed = GetEntitySpeed
local GetStreetNameAtCoord = GetStreetNameAtCoord
local GetStreetNameFromHashKey = GetStreetNameFromHashKey
local playerPed = PlayerPedId()

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        Wait(500)
    end
end)


CreateThread(function() 
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			DecorRegister("SpotvectorX", 3) 
			DecorRegister("SpotvectorY", 3)
			DecorRegister("SpotvectorZ", 3)
			break
		end
	end
end)

CreateThread(function()
	Wait(5000)
	TriggerEvent('esx_vehicleshop:getVehicles', function(base)
		vehicles = base
	end)

	local heli
	CreateThread(function()
		local ticks = 0
		while true do
			Wait(100)
			if heli and target_vehicle and not HasEntityClearLosToEntity(heli, target_vehicle, 17) then
				ticks = ticks + 1
				if ticks == 10 then 
					target_vehicle = nil
					ticks = 0
				end
			else
				Wait(500)
				ticks = 0
			end
		end
	end)

	while true do
        Wait(0)

		heli = GetVehiclePedIsIn(playerPed, false)
		
		local sleep = true

		local model = GetEntityModel(heli)
		if model == `ms_heli` or model == `so_heli` or model == `pd_heli` or model == `valkyrie` or model == `valkyrie2` or model == `SamolocikKrzychu` or model == `annihilator2` then
			sleep = false
			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(0, toggle_helicam) and (GetPedInVehicleSeat(heli, -1) == playerPed or GetPedInVehicleSeat(heli, 0) == playerPed) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = true
					ESX.UI.HUD.SetDisplay(0.0)
				end
				
				if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
					if GetPedInVehicleSeat(heli, 1) == playerPed or GetPedInVehicleSeat(heli, 2) == playerPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						SetPedCanRagdoll(playerPed, false)
						TaskRappelFromHeli(playerPed, 1)
						CreateThread(function()
							Wait(30000)
							SetPedCanRagdoll(playerPed, true)
						end)
					else
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false) 
					end
				end
			end

			if IsControlJustPressed(0, toggle_display) and (GetPedInVehicleSeat(heli, -1) == playerPed or GetPedInVehicleSeat(heli, 0) == playerPed) then 
				ChangeDisplay()
			end

			if target_vehicle and (GetPedInVehicleSeat(heli, -1) == playerPed or GetPedInVehicleSeat(heli, 0) == playerPed) then
				local coords1 = GetEntityCoords(heli)
				local coords2 = GetEntityCoords(target_vehicle)

				local target_distance = #(coords1 - coords2)
				if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then
					target_vehicle = nil					
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end
		end
		
		if helicam then
			sleep = false
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Wait(0)
			end

			local heli = GetVehiclePedIsIn(playerPed, false)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0)
			PopScaleformMovieFunctionVoid()

			local locked_on_vehicle = nil
			while helicam and not DecorExistOn(playerPed, 'injured') and (GetVehiclePedIsIn(playerPed, false) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustPressed(0, toggle_helicam) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = false
				end

				if IsControlJustPressed(0, toggle_vision) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ChangeVision()
				end

				if IsControlJustPressed(0, radiusup_key) then
					TriggerServerEvent("exile_heli:radius.up")
				end

				if IsControlJustPressed(0, radiusdown_key) then
					TriggerServerEvent("exile_heli:radius.down")
				end

				if IsControlJustPressed(0, toggle_display) then 
					ChangeDisplay()
				end

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then
						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
						local coords1 = GetEntityCoords(heli)
						local coords2 = GetEntityCoords(locked_on_vehicle)

						local target_distance = #(coords1 - coords2)
						if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							target_vehicle = nil
							locked_on_vehicle = nil
							local rot = GetCamRot(cam, 2)
							local fov = GetCamFov(cam)
							local old cam = cam
							DestroyCam(old_cam, false)
							cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
							SetCamRot(cam, rot, 2)
							SetCamFov(cam, fov)
							RenderScriptCams(true, false, 0, 1, 0)
						end
					else
						locked_on_vehicle = nil
						target_vehicle = nil
					end
				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam, heli)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = vehicle_detected
							target_vehicle = vehicle_detected
							target_plate = GetVehicleNumberPlateText(target_vehicle, true)
						end
					end
				end

				HandleZoom(cam)
				HideHUDThisFrame()
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Wait(0)

			end

			helicam = false
			ClearTimecycleModifier()

			ESX.UI.HUD.SetDisplay(1.0)

			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
			vision_state = 0
		end

		if (model == `ms_heli` or model == `so_heli` or model == `pd_heli` or model == `valkyrie` or model == `valkyrie2` or model == `SamolocikKrzychu` or model == `annihilator2`) and target_vehicle and not helicam and vehicle_display ~= 2 then
			RenderVehicleInfo(target_vehicle)
			sleep = false
		end
		
		if sleep then
			Wait(500)
		end
	end
end)


RegisterNetEvent('exile_heli:radius.up')
AddEventHandler('exile_heli:radius.up', function(serverID)
	if spotradius < 10.0 then
		spotradius = spotradius + 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('exile_heli:radius.down')
AddEventHandler('exile_heli:radius.down', function(serverID)
	if spotradius > 4.0 then
		spotradius = spotradius - 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function ChangeDisplay()
	if vehicle_display == 0 then
		vehicle_display = 1
	elseif vehicle_display == 1 then
		vehicle_display = 2
	else
		vehicle_display = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	for i = 1, 35 do
		HideHudComponentThisFrame(i)
	end
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		local new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	DisableControlAction(2, 85, true)

	if IsControlJustPressed(0,241) then
		fov = math.max(fov - zoomspeed, fov_min)
	end

	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) 
end

function GetVehicleInView(cam, heli)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	local rayhandle = StartShapeTestRay(coords, coords+(forward_vector*200.0), 2, heli, 0)
	local result, hit, entityCoords, surfaceVector, entityHit = GetShapeTestResult(rayhandle)
	if hit and IsEntityAVehicle(entityHit) then
		return entityHit
	end
end

function RenderVehicleInfo(vehicle)	
	if DoesEntityExist(vehicle) then
		local name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
		if name ~= 'CARNOTFOUND' then				
			local found = false
			
			for _, veh in ipairs(vehicles) do
				if (veh.game == name) or veh.model == fmodel then
					local fmodel = veh.name
					found = true
					break
				end
			end

			if not found then
				local label = GetLabelText(name)
				if label ~= "NULL" then
					name = label
				end
			end
		end

		local licenseplate = GetVehicleNumberPlateText(vehicle)
		local vehspeed = GetEntitySpeed(vehicle)*3.6

		local coords = GetEntityCoords(vehicle, true)
		local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		local street1, street2 = GetStreetNameFromHashKey(s1), GetStreetNameFromHashKey(s2)

		SetTextFont(0)
		SetTextProportional(1)
		if vehicle_display == 0 then
			SetTextScale(0.0, 0.34)
		elseif vehicle_display == 1 then
			SetTextScale(0.0, 0.4)
		end

		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()

		SetTextEntry("STRING")
		if vehicle_display == 0 then
			AddTextComponentString("Prędkość: " .. math.floor(vehspeed + 0.5) .. " " .. speed_measure .. "\nPojazd: " .. name .. "\nNr rej.: " .. licenseplate .. "\n~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "~s~"))
		elseif vehicle_display == 1 then
			AddTextComponentString("Pojazd: " .. name .. "\nNr rej.: " .. licenseplate .. "\n~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "~s~"))
		end

		DrawText(0.75, 0.9)
	end
end

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
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

function FindVehicleByPlate(plate)
	for vehicle in EnumerateVehicles() do
		if GetVehicleNumberPlateText(vehicle, true) == plate then
			return vehicle
		end
	end
end