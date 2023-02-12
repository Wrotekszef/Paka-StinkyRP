ESX                           = nil

local CurrentZone = nil
local IsPlayerOnDuty = false
local secondjobVehicle = nil
local secondjobOrder = nil
local hasAlreadyJoined        = false
local loaded = false
local PlayerCoords = vector3(0.0, 0.0, 0.0)
local blip_ped = nil
local LastCancel = GetGameTimer() - 5 * 60000

CreateThread(function()
	while ESX == nil do
		TriggerEvent('exile:getsharedobject', function(obj) 
			ESX = obj 
		end)
		
		Wait(250)
	end
	
	Wait(5000)

	loaded = true
	
	while true do
		PlayerCoords = GetEntityCoords(PlayerPedId())
		Wait(1000)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)
RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob, response)
	ESX.PlayerData.secondjob = secondjob
end)

CreateThread(function()
	while true do
		if (PlayerCoords ~= nil and ESX.PlayerData ~= nil and ESX.PlayerData.secondjob ~= nil and (Config.Zones[ESX.PlayerData.secondjob.name] or Config.Zones[string.sub(ESX.PlayerData.secondjob.name, 4)])) then
			CurrentZone = nil
			local configTable
			if Config.Zones[ESX.PlayerData.secondjob.name] ~= nil then
				configTable = Config.Zones[ESX.PlayerData.secondjob.name]
			else
				configTable = Config.Zones[string.sub(ESX.PlayerData.secondjob.name, 4)]
			end
			for zone,zoneData in pairs(configTable) do
				local canDraw = true
				if (zoneData.settings.dutyOnly == true) then
					if not (IsPlayerOnDuty) then
						canDraw = false
					end
				end

				if (canDraw) then
					local zoneVDist = #(PlayerCoords - zoneData.coords)

					if (zoneVDist < 20.0) then
						if (zoneVDist < 1.0) then
							CurrentZone = zone
						end
						ESX.DrawMarker(vec3(zoneData.coords+zoneData.marker.offset))
					end
				end
			end
		else
			Wait(500)
		end
		Wait(4)
	end
end)

function setUniform(secondjob, grade)
	grade = tostring(grade)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[secondjob].male[grade] ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[secondjob].male[grade])
			else
				ESX.ShowNotification("Brak ubrania")
			end
		else
			if Config.Uniforms[secondjob].female[grade] ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[secondjob].female[grade])
			else
				ESX.ShowNotification("Brak ubrania")
			end
		end
	end)
end

OpenBossMenu = function()
	local elements = {
		{label = "Akcje szefa", value = '1'},
	}
	if ESX.PlayerData.secondjob.grade >= 9 then
		--table.insert(elements, {label = "Lista kursów", value = '2'})
		table.insert(elements, {label = "Zarządzanie frakcją", value = '3'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actionss', {
		title    = "Praca Legalna",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if ESX.PlayerData.secondjob.grade >= 7 then
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'taxi', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			elseif ESX.PlayerData.secondjob.grade_label == "Manager" then
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'taxi', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'taxi', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false})
			end
		elseif data.current.value == '2' then
			menu.close()
			ESX.TriggerServerCallback('ExileRP:getCourses', function(kursy)
				if kursy then
					local elements = {
						head = {'Imię i nazwisko', 'Liczba kursów', 'Stopień'},
						rows = {}
					}
					for i=1, #kursy, 1 do
						if kursy[i].secondjob_grade == 0 then
							grade = 'Okres próbny'
						elseif kursy[i].secondjob_grade == 1 then
							grade = 'Rekrut'
						elseif kursy[i].secondjob_grade == 2 then
							grade = 'Nowicjusz'
						elseif kursy[i].secondjob_grade == 3 then
							grade = 'Kierowca'
						elseif kursy[i].secondjob_grade == 4 then
							grade = 'Stażysta'
						elseif kursy[i].secondjob_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].secondjob_grade == 6 then
							grade = 'Zawodowiec'
						elseif kursy[i].secondjob_grade == 7 then
							grade = 'Obsługa'
						elseif kursy[i].secondjob_grade == 8 then
							grade = 'Manager'
						elseif kursy[i].secondjob_grade == 9 then
							grade = 'Właściciel'
						end
						local name = kursy[i].firstname .. ' ' ..kursy[i].lastname
						table.insert(elements.rows, {
							data = kursy[i],
							cols = {
								name, 
								kursy[i].courses_count, 
								grade
							}
						})
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'taxi', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
					end
				else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'taxi')
		elseif data.current.value == '3' then
			menu.close()
			exports['exile_legaljobs']:OpenLicensesMenu(ESX.PlayerData.secondjob.name)
		end

	end, function(data, menu)
		menu.close()
		CurrentZone = "BossMenu"
	end)
end

-- GivebackInvoices = function()
-- 	TriggerServerEvent(GetCurrentResourceName() .. ':sellInvoices')
-- end

CreateThread(function()
	while true do
		if (ESX.PlayerData ~= nil and ESX.PlayerData.secondjob ~= nil and (Config.Zones[ESX.PlayerData.secondjob.name] or Config.Zones[string.sub(ESX.PlayerData.secondjob.name, 4)])) then
			local CurrentZone_Data
			if Config.Zones[ESX.PlayerData.secondjob.name] ~= nil then
				CurrentZone_Data = Config.Zones[ESX.PlayerData.secondjob.name][CurrentZone]
			else
				CurrentZone_Data = Config.Zones[string.sub(ESX.PlayerData.secondjob.name, 4)][CurrentZone]
			end
			
			if (CurrentZone == "secondjobManager") then
				if not (IsPlayerOnDuty) then
					DrawNotification(CurrentZone_Data.settings.prompt:format("rozpocząć pracę."))
				else
					DrawNotification(CurrentZone_Data.settings.prompt:format("zakończyć pracę."))
				end

				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if not (DoesEntityExist(secondjobVehicle)) then
						IsPlayerOnDuty = not IsPlayerOnDuty
						if (IsPlayerOnDuty) then
							setUniform(ESX.PlayerData.secondjob.name, ESX.PlayerData.secondjob.grade)
							Wait(50)
							ESX.ShowNotification("~y~Rozpocząłeś pracę!")
						else
							CancelOrder()
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
								ESX.ShowNotification("~y~Zakończyłeś pracę!")
							end)
						end
					else
						ESX.ShowNotification("~y~Musisz zwrócić pojazd, aby, zakończyć zmianę!")
					end
					Wait(500)
				end
			elseif (CurrentZone == "Garage") then
				if not (IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle)) then
					DrawNotification(CurrentZone_Data.settings.prompt:format("wziąć pojazd służbowy."))
				end

				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if (IsPlayerOnDuty) then
						if not (IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle)) then
							if not DoesEntityExist(secondjobVehicle) then
								GetsecondjobVehicle(CurrentZone_Data.vehicles, CurrentZone_Data.coords)
							else
								ESX.ShowNotification('~r~Najpierw schowaj swój aktualny pojazd')
							end
						end
					else
						ESX.ShowNotification("~y~Musisz zacząć pracę aby, korzystać z garażu!")
					end
					Wait(500)
				end
			elseif (CurrentZone == "BossMenu") then
				DrawNotification(CurrentZone_Data.settings.prompt:format("otworzyć menu zarządzania"))
				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if (IsPlayerOnDuty) then
						OpenBossMenu()
					end
					Wait(1)
				end
			-- elseif (CurrentZone == 'Invoices') then
			-- 	DrawNotification(CurrentZone_Data.settings.prompt:format("oddać faktury"))
			-- 	if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
			-- 		if (IsPlayerOnDuty) then
			-- 			GivebackInvoices()
			-- 		end
			-- 		Wait(1)
			-- 	end
			elseif (CurrentZone == 'DeleteVeh') then
				DrawNotification(CurrentZone_Data.settings.prompt:format("schować pojazd służbowy."))
				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if (IsPlayerOnDuty) then
						if (IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle)) then
							StoresecondjobVehicle()
						else
							ESX.ShowNotification("~r~Musisz siedzieć w pojeździe lub to nie jest Twój pojazd służbowy")
						end
					end
				end
			end

			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and not IsDead and ESX.PlayerData.secondjob and ESX.PlayerData.secondjob.name == 'taxi' then
				if (IsPlayerOnDuty) then
					OpenMobileTaxiActionsMenu()
				end
			end

		else
			Wait(100)
		end
		Wait(7)
	end
end)

OpenMobileTaxiActionsMenu = function()
	while ESX.PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Rozpocznij/Zakończ pracę", value = 'start_secondjob'}
	}
	if ESX.PlayerData.secondjob.grade >= 8 then -- do zmiany na 9
		table.insert(elements, {label = "Sprawdź ostatniego kierowce", value = 'checkcar'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = "Taxi",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'start_secondjob' then
			if secondjobOrder ~= nil then
				CancelOrder()
			else
				if ESX.PlayerData.secondjob ~= nil and ESX.PlayerData.secondjob.name == 'taxi' then
					local playerPed = PlayerPedId()
					local vehicle   = GetVehiclePedIsIn(playerPed, false)
					if ESX.PlayerData.secondjob.grade >= 9 then
						MakeOrder()
						TriggerServerEvent('taxi:insertSmiec', GetVehicleNumberPlateText(vehicle))
					else
						if (IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle)) then
							MakeOrder()
							TriggerServerEvent('taxi:insertSmiec', GetVehicleNumberPlateText(vehicle))
						else
							ESX.ShowNotification("~y~Musisz być w pojeździe służbowym, aby rozpocząć przewóz osób")
						end
					end
				end
			end
		elseif data.current.value == 'checkcar' then
			local playerPed = PlayerPedId()
			local vehicle   = GetVehiclePedIsIn(playerPed, false)
			if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				ESX.TriggerServerCallback('taxi:checkSiedzacy', function(siedzi)
					if siedzi then
						local elements = {}
						local plate =  GetVehicleNumberPlateText(vehicle)
						for i=1, #siedzi, 1 do
							if siedzi[i].plate == plate then
								table.insert(elements, {label = siedzi[i].label, value = siedzi[i].plate})
							end
						end
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lastdriver', {
							title    = "Lista kierowców ["..plate..']',
							align    = 'bottom-right',
							elements = elements
						}, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)

					end
				end)
			else
				ESX.ShowNotification("~r~Musisz znajdować się w pojeździe jako kierwoca!")
			end

		end
	end, function(data, menu)
		menu.close()
	end)
end

MakeOrder = function()
	if (ESX.PlayerData ~= nil and ESX.PlayerData.secondjob ~= nil and Config.Zones[ESX.PlayerData.secondjob.name]) then
		if (DoesEntityExist(secondjobVehicle) and IsPlayerOnDuty and IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle)) then
			if (secondjobOrder == nil) then
				CreateNewTaxiOrder()
			end
		end
	end
end

CreateThread(function()
	while true do
		if ESX.PlayerData ~= nil and ESX.PlayerData.secondjob ~= nil and Config.Zones[ESX.PlayerData.secondjob.name] then
			if (DoesEntityExist(secondjobVehicle) and IsPlayerOnDuty and IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle))  then
				if secondjobOrder ~= nil then
					if secondjobOrder.status == 0 and secondjobOrder.ped == nil and #(PlayerCoords - secondjobOrder.start_point) < 40.0 then
						SpawnOrderPed()
						Wait(1000)
					end
				end
			else
				Wait(500)
			end
		else
			Wait(500)
		end
		Wait(100)
	end
end)

CreateThread(function()
	while true do
		if (ESX.PlayerData ~= nil and ESX.PlayerData.secondjob ~= nil and Config.Zones[ESX.PlayerData.secondjob.name]) then
			if (DoesEntityExist(secondjobVehicle) and IsPlayerOnDuty and IsPedSittingInVehicle(PlayerPedId(), secondjobVehicle)) then
				if (secondjobOrder ~= nil and DoesEntityExist(secondjobOrder.ped)) then
					if secondjobOrder.status == 0 and #(PlayerCoords - GetEntityCoords(secondjobOrder.ped)) < 5.0 then
						if IsControlJustReleased(0, 86) then
							HornOnClient(GetVehiclePedIsIn(PlayerPedId()))
						end
					end

					if secondjobOrder.status == 1 and #(PlayerCoords - secondjobOrder.end_point) < 10.0 then
						PlayAmbientSpeech1(secondjobOrder.ped, "TAXID_CLOSE_AS_POSS", "SPEECH_PARAMS_FORCE_NORMAL")
						GetTheFuckOutBitch()
					end
				else
					Wait(500)
				end
			else
				Wait(500)
			end
		else
			Wait(500)
		end
		Wait(7)
	end
end)

SpawnOrderPed = function()
	local pedModel = GetHashKey(Config.PedsList[math.random(1, #Config.PedsList)])

	RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do
		Wait(10)
	end

	secondjobOrder.ped = CreatePed(5, pedModel, secondjobOrder.start_point.x, secondjobOrder.start_point.y, secondjobOrder.start_point.z-0.5, 0.0, true, true)
	FreezeEntityPosition(secondjobOrder.ped, true)
	SetBlockingOfNonTemporaryEvents(secondjobOrder.ped, true)
	SetEntityAsMissionEntity(secondjobOrder.ped, 1, 1)
	SetModelAsNoLongerNeeded(pedModel)
	TaskStartScenarioInPlace(secondjobOrder.ped, "WORLD_HUMAN_STAND_MOBILE", 0, false)
	CanPedSpeak(secondjobOrder.ped, "TAXID_CLOSE_AS_POSS")
end

CancelOrder = function()
	if (secondjobOrder ~= nil) then
		if GetGameTimer() - LastCancel > 5 * 60000 then
			TriggerServerEvent('exile_taxi:unregisterNPCTrack')
			FreezeEntityPosition(secondjobVehicle, false)
			SetEntityAsNoLongerNeeded(secondjobOrder.ped)
			DeleteEntity(secondjobOrder.ped)
			if DoesBlipExist(blip_ped) then
				RemoveBlip(blip_ped)
			end
			if DoesBlipExist(secondjobOrder.blip) then
				RemoveBlip(secondjobOrder.blip)
			end
			secondjobOrder = nil
			LastCancel = GetGameTimer()
		else
			ESX.ShowNotification("Odczekaj ~y~5 minut~w~ przed następną ~r~anulacją trasy")
		end
	end
end

GetTheFuckOutBitch = function()
	BringVehicleToHalt(secondjobVehicle, 5.0, 3, 0)
	while (GetEntitySpeed(secondjobVehicle) < 0.2) do
		Wait(500)
	end
	TriggerServerEvent('exile_taxi:setTrackAsDone')
	TaskLeaveVehicle(secondjobOrder.ped, secondjobVehicle, 0)
	Wait(1000)
	TaskWanderStandard(secondjobOrder.ped, 1000.0, 1000.0)
	SetEntityAsNoLongerNeeded(secondjobOrder.ped)
	FreezeEntityPosition(secondjobVehicle, false)
	RemoveBlip(blip_ped)
	RemoveBlip(secondjobOrder.blip)
	secondjobOrder = nil	
end

HornOnClient = function(vehicle)
	if ESX.PlayerData.secondjob.grade >= 9 then
		secondjobVehicle = vehicle
	end
	secondjobOrder.status = 1

	FreezeEntityPosition(secondjobOrder.ped, false)
	FreezeEntityPosition(secondjobVehicle, true)
	TaskEnterVehicle(secondjobOrder.ped, secondjobVehicle, 10000, 2, 1.0, 1, 0)

	while not (IsPedSittingInVehicle(secondjobOrder.ped, secondjobVehicle)) do
		Wait(500)
	end
	PlayAmbientSpeech1(PlayerPedId(), "TAXID_WHERE_TO", "SPEECH_PARAMS_FORCE_NORMAL")
	FreezeEntityPosition(secondjobVehicle, false)

	RemoveBlip(blip_ped)

	secondjobOrder.blip = AddBlipForCoord(secondjobOrder.end_point)
	SetBlipSprite(secondjobOrder.blip, 164)
	SetBlipColour(secondjobOrder.blip, 60)
	SetBlipAsShortRange(secondjobOrder.blip, false)

	SetBlipRoute(secondjobOrder.blip, true)
	SetBlipRouteColour(secondjobOrder.blip, 60)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("~y~Miejsce docelowe")
	EndTextCommandSetBlipName(secondjobOrder.blip)
end

CreateNewTaxiOrder = function()
	secondjobOrder = { status = 0 }
	math.randomseed(math.random(1000, 9999999999))
	secondjobOrder.start_point = Config.CoordsList[math.random(1, #Config.CoordsList)]

	math.randomseed(math.random(1000, 9999999999))
	secondjobOrder.end_point = Config.CoordsList[math.random(1, #Config.CoordsList)]
	while #(PlayerCoords - secondjobOrder.end_point) < 1500.0 do
		math.randomseed(math.random(1000, 9999999999))
		secondjobOrder.end_point = Config.CoordsList[math.random(1, #Config.CoordsList)]
		Wait(100)
	end

	blip_ped = AddBlipForCoord(vec3(secondjobOrder.start_point.x, secondjobOrder.start_point.y, secondjobOrder.start_point.z))
	SetBlipSprite(blip_ped, 280)
	SetBlipColour(blip_ped, 60)
	SetBlipFlashes(blip_ped, true)
	SetBlipFlashInterval(blip_ped, 1000)
	SetBlipDisplay(blip_ped, 4)
	SetBlipAsShortRange(blip_ped, false)

	SetBlipRoute(blip_ped, true)
	SetBlipRouteColour(blip_ped, 60)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("~y~Klient")
	EndTextCommandSetBlipName(blip_ped)

	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(secondjobOrder.start_point.x, secondjobOrder.start_point.y, secondjobOrder.start_point.z))
	ESX.ShowNotification("Witam, czy można podjechać na ulicę, "..street.." ?")
	SetNewWaypoint(secondjobOrder.start_point.x, secondjobOrder.start_point.y)
	local playerLenght = #(PlayerCoords - secondjobOrder.start_point) * 1.25
	local truckLenght = #(secondjobOrder.start_point - secondjobOrder.end_point) * 1.25
	local wholeLenght = playerLenght + truckLenght
	TriggerServerEvent('exile_taxi:registerNewNPCTrack', wholeLenght)
end

SetDodatki = function(vehicle)
	local dodatki = {
		modBrakes       = 2,
		modArmor        = 4,
		color1          = 88, --zolty
		color2          = 88, --zolty
		modTurbo        = false,
		modXenon        = true,
		wheels          = 0,
		plateIndex      = 1,
		modXenonColor   = 6,
		windowTint      = 3,
		dirtLevel       = 0,
		modFrontWheels  = 19,
		modBackWheels = 19,
		wheelColor    = 1,
		extras          = {1,1,1,1}
	}
	local carmodel = GetEntityModel(vehicle)


	--[[if carmodel == -662904049 then --e63amg
		dodatki.color1 = 120
		dodatki.wheels = 4
		dodatki.wheelColor = 88
	end]]
		

	ESX.Game.SetVehicleProperties(vehicle, dodatki)
	--SetVehicleExtra(vehicle, extrasoff, false)
end

GetsecondjobVehicle = function(vehicle, coords)
	ESX.UI.Menu.CloseAll()
	local grade = 0
	if ESX.PlayerData.secondjob and ESX.PlayerData.secondjob.name == 'taxi' then
		grade = ESX.PlayerData.secondjob.grade
	end
	local elements = {}

	for _, vehicle in ipairs(Config.Vehicles) do
		if grade >= vehicle.grade then
			table.insert(elements, {label = vehicle.name, value = vehicle.spawn})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = "Garaż",
		align    = 'bottom-right',
		elements = elements

	}, function(data, menu)

		if not ESX.Game.IsSpawnPointClear(vehicle.coords, 5.0) then
			ESX.ShowNotification("~r~Wyjazd jest zablokowany przez inny pojazd!")
			return
		end

		menu.close()
		ESX.Game.SpawnVehicle(data.current.value, vehicle.coords, vehicle.heading, function(veh)
			secondjobVehicle = veh
			local tablicetaxi = ('TAXI '..math.random(100, 999))
			local playerPed = PlayerPedId()
			SetDodatki(veh)
			SetVehicleNumberPlateText(veh, tablicetaxi)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(veh))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
		end)
	end, function(data, menu)
		CurrentZone = 'Garage'
		menu.close()
	end)
end

StoresecondjobVehicle = function()
	ESX.Game.DeleteVehicle(secondjobVehicle)
	secondjobVehicle = nil
end

DrawNotification = function(string)
	SetTextComponentFormat('STRING')
	AddTextComponentString(string)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end