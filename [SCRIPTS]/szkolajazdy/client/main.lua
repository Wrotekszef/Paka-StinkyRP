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

local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)

	TriggerServerEvent('esx_exileschool:pay', Config.Prices['dmv'])
	
	if IsControlJustReleased(0, 322) then
		SendNUIMessage({
			openQuestion = false
		})
		Wait(200)
		SetNuiFocus(false)
	end
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		TriggerServerEvent('esx_exileschool:licenseplayeradd', 'dmv')
		ESX.ShowNotification(_U('passed_test'))
	else
		ESX.ShowNotification(_U('failed_test'))
	end
end

function StartDriveTest(type)
	ESX.Game.SpawnVehicle(Config.VehicleModels[type], Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Pos.h, function(vehicle)
		CurrentTest       = 'drive'
		CurrentTestType   = type
		CurrentCheckPoint = 0
		LastCheckPoint    = -1
		CurrentZoneType   = 'residence'
		DriveErrors       = 0
		IsAboveSpeedLimit = false
		CurrentVehicle    = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)
		platenum = math.random(10000, 99999)
		SetVehicleNumberPlateText(vehicle, "SCHOOL"..platenum)
		plaquevehicule = "SCHOOL"..platenum

		local playerPed   = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	end)

	TriggerServerEvent('esx_exileschool:pay', Config.Prices[type])
end

function StopDriveTest(success)
	if success then
		TriggerServerEvent('esx_exileschool:licenseplayeradd', CurrentTestType)
		ESX.ShowNotification(_U('passed_test'))
	else
		ESX.ShowNotification(_U('failed_test'))
	end

	CurrentTest     = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
CurrentZoneType = type
end

function OpenDMVSchoolMenu()
	local ownedLicenses = {}

	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end

	local elements = {}

	if not ownedLicenses['dmv'] then
		table.insert(elements, {label = _U('theory_test') .. ' <span style="color: green;">$' .. Config.Prices['dmv'] .. '</span>', value = 'theory_test'})
	end

	if ownedLicenses['dmv'] then
		if not ownedLicenses['drive'] then
			table.insert(elements, {label = _U('road_test_car') .. ' <span style="color: green;">$' .. Config.Prices['drive'] .. '</span>', value = 'drive_test', type = 'drive'})
		end

		if not ownedLicenses['drive_bike'] then
			table.insert(elements, {label = _U('road_test_bike') .. ' <span style="color: green;">$' .. Config.Prices['drive_bike'] .. '</span>', value = 'drive_test', type = 'drive_bike'})
		end

		if not ownedLicenses['drive_truck'] then
			table.insert(elements, {label = _U('road_test_truck') .. ' <span style="color: green;">$' .. Config.Prices['drive_truck'] .. '</span>', value = 'drive_test', type = 'drive_truck'})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dmvschool_actions',
	{
		title    = _U('driving_school'),
		elements = elements,
		align    = 'left'
	}, function(data, menu)
		if data.current.value == 'theory_test' then
			menu.close()
			SzkolaJazdyRoute68()
		elseif data.current.value == 'drive_test' then
			StartDriveTest(data.current.type)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end)
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb('OK')
end)

AddEventHandler('esx_exileschool:hasEnteredMarker', function(zone)
	if zone == 'DMVSchool' then
		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_exileschool:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_exileschool:loadLicenses')
AddEventHandler('esx_exileschool:loadLicenses', function(licenses)
	Licenses = licenses
end)

-- Create Blips
CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

	SetBlipSprite (blip, 408)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 15)
	SetBlipScale  (blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('driving_school_blip'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
CreateThread(function()
	while true do

		Wait(0)

		local coords, sleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < 15) then
				sleep = false
				ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z + 0.05))
			end
		end
		if sleep then
			Wait(500)
		end

	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do

		Wait(100)

		local coords, sleep      = GetEntityCoords(PlayerPedId()), true
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x then
				sleep = false
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_exileschool:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_exileschool:hasExitedMarker', LastZone)
		end
		if sleep then
			Wait(500)
		end
	end
end)

-- Block UI
CreateThread(function()
	while true do
		Wait(1)

		if CurrentTest == 'theory' then
			local playerPed = PlayerPedId()

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Wait(500)
		end
	end
end)

local bledy = 0

-- Key Controls
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction ~= nil then

			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'dmvschool_menu' then
					OpenDMVSchoolMenu()
					bledy = 0
				end

				CurrentAction = nil
			end
		else
			Wait(500)
		end
	end
end)

-- Test Teoretyczny
function SzkolaJazdyRoute68()
	TriggerServerEvent('esx_exileschool:pay', Config.Prices['dmv'])
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie1',
      {
          title    = 'Je??eli kierowca pojazdu znajduje si?? na skrzy??owaniu i us??yszy syren?? pojazdu uprzywilejowanego powinien:',
          align    = 'center',
          elements = {
			{label = 'Przejecha?? przez skrzy??owanie i zatrzyma?? si?? po prawej stronie', value = 'prawda'},
			{label = 'Natychmiast zatrzyma?? si?? na skrzy??owaniu', value = 'falsz'},
			{label = 'Przejecha?? przez skrzy??owanie i zatrzyma?? si?? po lewej stronie', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie2()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie2()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie2',
      {
          title    = 'Kraw????nik pomalowany na ________ oznacza, ??e nie mo??na przy nim parkowa??. ',
          align    = 'center',
          elements = {
			{label = '??????to', value = 'falsz'},
			{label = 'bia??o', value = 'falsz'},
			{label = 'czerwono', value = 'prawda'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie3()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie3()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie3',
      {
          title    = 'Widz??c zwierz??ta w pobli??u drogi kt??r?? si?? poruszamy nale??y:',
          align    = 'center',
          elements = {
			{label = 'Spokojnie, lecz ostro??nie przejecha?? obok nich', value = 'prawda'},
			{label = 'Tr??bi?? a?? zwierz??ta zejd?? z drogi', value = 'falsz'},
			{label = 'Przyspieszy??, aby przejecha?? zanim zwierz??ta wbiegn?? na drog??', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie4()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie4()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie4',
      {
          title    = 'Kiedy zaobserwuj?? podczas jazdy zjawisko aquaplaningu:',
          align    = 'center',
          elements = {
			{label = 'Wcisn?? gwa??townie hamulec', value = 'falsz'},
			{label = 'Delikatnie zdejm?? nog?? z gazu', value = 'prawda'},
			{label = 'Docisn?? gaz, ??eby auto z??apa??o przyczepno????', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie5()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie5()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie5',
      {
          title    = '??wiat??a mijania nale??y w????czy??:',
          align    = 'center',
          elements = {
			{label = 'O ka??dej porze dnia', value = 'falsz'},
			{label = 'Po zmroku', value = 'prawda'},
			{label = 'Nie musz?? o to dba??, bo w nowych autach ??wiat??a s?? samoczynne', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie6()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie6()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie6',
      {
          title    = 'Jeste?? ??wiadkiem wypadku, w pobli??u nie ma innych kierowc??w, co robisz?',
          align    = 'center',
          elements = {
			{label = 'Oddalasz si?? powoli, by nie nara??a?? si?? na niebezpiecze??stwo', value = 'falsz'},
			{label = 'Wzywasz s??u??by i uciekasz, ??eby nie podejrzewano cie o spowodowanie wypadku', value = 'falsz'},
			{label = 'Udzielasz pierwszej pomocy poszkodowanym i powiadamiasz s??u??by', value = 'prawda'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie7()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie7()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie7',
      {
          title    = 'Przed jazd?? wypijasz dwa piwa:',
          align    = 'center',
          elements = {
			{label = 'Dzi??ki temu, b??d?? mie?? szybsza reakcj??', value = 'falsz'},
			{label = 'Moje reakcje mog?? by?? op????nione', value = 'prawda'},
			{label = 'Mog?? ??le wyj???? na zdj??ciu fotoradaru', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie8()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie8()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie8',
      {
          title    = 'Jak sprawdzisz czy poszkodowany ma puls?',
          align    = 'center',
          elements = {
			{label = 'Poklepi?? go po czole', value = 'falsz'},
			{label = 'Nacisn?? na t??tnic?? szyjn?? z ca??ej si??y', value = 'falsz'},
			{label = 'Sprawdz?? na nadgarstku', value = 'prawda'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie9()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie9()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie9',
      {
          title    = 'Chc??c do????czy?? do ruchu na autostradzie musisz:',
          align    = 'center',
          elements = {
			{label = 'Przyspieszy??, by zr??wna?? si?? pr??dko??ci?? z autami jad??cymi autostrad??', value = 'prawda'},
			{label = 'Zwolni?? by ostro??nie zaj???? miejsce na pasie', value = 'falsz'},
			{label = 'Po prostu wjecha?? na pas, mam przecie?? pierwsze??stwo', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  Pytanie10()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie10()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie10',
      {
          title    = 'W manualnej skrzyni bieg??w, wciskaj??c gaz i szybko puszczaj??c sprz??g??o mo??emy dopu??ci?? do:',
          align    = 'center',
          elements = {
			{label = 'Uszkodzenia ??wiat??a cofania', value = 'falsz'},
			{label = 'Utraty przyczepno??ci podczas ruszania', value = 'prawda'},
			{label = 'Spalenia opony', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Wait(100)
		  KoniecPytan()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function KoniecPytan()
	if bledy >= 4 then
		bledy = 0
		ESX.ShowNotifcation('~r~Test niezaliczony! Spr??buj jeszcze raz!')
	elseif bledy < 4 then
		TriggerServerEvent('esx_exileschool:licenseplayeradd', 'dmv')
		TriggerServerEvent('esx_exileschool:reloadLicense')
		ESX.ShowNotification(_U('passed_test'))
	end
end

-- Drive test
CreateThread(function()
	while true do

		Wait(0)

		if CurrentTest == 'drive' then
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				ESX.ShowNotification(_U('driving_test_complete'))

				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = #(coords - vec3(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z))

				if distance <= 100.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
		else
			Wait(500)
		end
	end
end)

-- Speed / Damage control
CreateThread(function()
	while true do
		Wait(2)
		if CurrentTest == 'drive' then

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then
				DisableControlAction(0, Keys['F'], true)
				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true

							ESX.ShowNotification(_U('driving_too_fast', v))
							ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors))
						end
					end
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then

					DriveErrors = DriveErrors + 1

					ESX.ShowNotification(_U('you_damaged_veh'))
					ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors))

					-- avoid stacking faults
					LastVehicleHealth = health
					Wait(1500)
				end
			end
		else
			-- not currently taking driver test
			Wait(500)
		end
	end
end)