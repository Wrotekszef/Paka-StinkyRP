GameplayCamera = nil
local cam = nil
InstructionalButtons = nil
MyVehicle = {

	repair = function()

		SetVehicleBodyHealth(MyVehicle.vehicle, 1000.0)

		SetVehicleDeformationFixed(MyVehicle.vehicle)



		SetVehicleEngineHealth(MyVehicle.vehicle, 1000.0)

		SetVehicleFixed(MyVehicle.vehicle)



		SetVehicleUndriveable(MyVehicle.vehicle, false)

		SetVehicleEngineOn(MyVehicle.vehicle, true, true)

	end,

	wash = function()

		WashDecalsFromVehicle(MyVehicle.vehicle, 1.0)

		SetVehicleDirtLevel(MyVehicle.vehicle)

	end,

	needRepair = function()

		if GetVehicleEngineHealth(MyVehicle.vehicle) < Config.repair.minhealthengine then

			return true

		end



		if GetVehicleBodyHealth(MyVehicle.vehicle) < Config.repair.minhealthbody then

			return true

		end



		return false

	end

}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)



Menu = SetMenu()

LSC = Menu.new("Los Santos Customs", "KATEGORIE", 0.16, 0.13, 0.24, 0.36, 0, {255,255,255,255})

LSC.config.pcontrol = false



function SetinstructionalButtons(buttons, layout)

	CreateThread(function()

		if not HasScaleformMovieLoaded(InstructionalButtons) then

			InstructionalButtons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")

			while not HasScaleformMovieLoaded(InstructionalButtons) do

				Citizen.Wait(0)

			end

		else

			InstructionalButtons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")

			while not HasScaleformMovieLoaded(InstructionalButtons) do

				Citizen.Wait(0)

			end

		end



		local w, h = GetScreenResolution()

		PushScaleformMovieFunction(InstructionalButtons, "CLEAR_ALL")

		PopScaleformMovieFunction()



		PushScaleformMovieFunction(InstructionalButtons, "SET_DISPLAY_CONFIG")

		PushScaleformMovieFunctionParameterInt(w)

		PushScaleformMovieFunctionParameterInt(h)

		PushScaleformMovieFunctionParameterFloat(0.03)

		PushScaleformMovieFunctionParameterFloat(0.98)

		PushScaleformMovieFunctionParameterFloat(0.01)

		PushScaleformMovieFunctionParameterFloat(0.95)

		PushScaleformMovieFunctionParameterBool(true)

		PushScaleformMovieFunctionParameterBool(false)

		PushScaleformMovieFunctionParameterBool(false)

		PushScaleformMovieFunctionParameterInt(w)

		PushScaleformMovieFunctionParameterInt(h)

		PopScaleformMovieFunction()



		PushScaleformMovieFunction(InstructionalButtons, "SET_MAX_WIDTH")

		PushScaleformMovieFunctionParameterInt(1)

		PopScaleformMovieFunction()

		

		for i, btn in pairs(buttons) do

			PushScaleformMovieFunction(InstructionalButtons, "SET_DATA_SLOT")

			PushScaleformMovieFunctionParameterInt(i - 1)

			PushScaleformMovieFunctionParameterString(btn[1])

			PushScaleformMovieFunctionParameterString(btn[2])

			PopScaleformMovieFunction()

			

		end



		if layout ~= 1 then

			PushScaleformMovieFunction(InstructionalButtons, "SET_PADDING")

			PushScaleformMovieFunctionParameterInt(10)

			PopScaleformMovieFunction()

		end



		PushScaleformMovieFunction(InstructionalButtons, "DRAW_INSTRUCTIONAL_BUTTONS")

		PushScaleformMovieFunctionParameterInt(layout)

		PopScaleformMovieFunction()

	end)

end



function PointCamAtBone(obj, bone, ox, oy, oz)

	SetinstructionalButtons({

		{GetControlInstructionalButton(1, obj.config.controls.menu_back, 0), "Wstecz"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_select, 0), "Wybierz"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_up, 0), "Do góry"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_down, 0), "W dół"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_left, 0), "W lewo"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_right, 0), "W prawo"},

		{GetControlInstructionalButton(1, 0, 0), "Free camera"}

	 }, 0)

	SetCamActive(cam, true)



	local b = GetEntityBoneIndexByName(MyVehicle.vehicle, bone)

	local bx, by, bz = table.unpack(GetWorldPositionOfEntityBone(MyVehicle.vehicle, b))

	local ox2, oy2, oz2 = table.unpack(GetOffsetFromEntityGivenWorldCoords(MyVehicle.vehicle, bx, by, bz))

	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, ox2 + f(ox), oy2 + f(oy), oz2 +f(oz)))



	SetCamCoord(cam, x, y, z)

	PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, 0, oy2, oz2))

	RenderScriptCams(1, 1, 1000, 0, 0)

end



function MoveVehicleCamera(obj, pos, x, y, z)

	SetinstructionalButtons({

		{GetControlInstructionalButton(1, obj.config.controls.menu_back, 0), "Wstecz"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_select, 0), "Wybierz"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_up, 0), "Do góry"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_down, 0), "W dół"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_left, 0), "W lewo"},

		{GetControlInstructionalButton(1, obj.config.controls.menu_right, 0), "W prawo"},

		{GetControlInstructionalButton(1, 0, 0),"Free camera"}

	 }, 0)

	SetCamActive(cam, true)



	local vx, vy, vz = table.unpack(GetEntityCoords(MyVehicle.vehicle))

	local d = GetModelDimensions(GetEntityModel(MyVehicle.vehicle))

	local length, width, height = d.y * -2, d.x * -2, d.z * -2



	local ox, oy, oz

	if pos == 'front' then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, f(x), (length / 2)+ f(y), f(z)))

	elseif pos == "front-top" then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, f(x), (length / 2) + f(y),(height) + f(z)))

	elseif pos == "back" then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, f(x), -(length / 2) + f(y),f(z)))

	elseif pos == "back-top" then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, f(x), -(length / 2) + f(y),(height / 2) + f(z)))

	elseif pos == "left" then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, -(width / 2) + f(x), f(y), f(z)))

	elseif pos == "right" then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, (width / 2) + f(x), f(y), f(z)))

	elseif pos == "middle" then

		ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, f(x), f(y), (height / 2) + f(z)))

	end



	SetCamCoord(cam, ox, oy, oz)

	PointCamAtCoord(cam,GetOffsetFromEntityInWorldCoords(MyVehicle.vehicle, 0, 0, f(0)))

	RenderScriptCams(1, 1, 1000, 0, 0)

end



function f(n)

	return (n + 0.00001)

end



function round(num, idp)

	if idp and idp > 0 then

		local mult = 10 ^ idp

		return math.floor(num * mult + 0.5) / mult

	end



	return math.floor(num + 0.5)

end