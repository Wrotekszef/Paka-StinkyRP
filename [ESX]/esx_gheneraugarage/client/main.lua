local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone, NPCTargetDistance = false, GetGameTimer() - 5 * 60000, false, false, 0
local isDead, isBusy, pDistance = false, false, 0
local CurrentTask = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

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

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.TowZones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob(currZone)
	ESX.TriggerServerCallback('esx_gheneraugarage:getPoint', function(cb)
		if cb then
			NPCOnJob = true

			NPCTargetTowableZone = SelectRandomTowable()
			local zone       = Config.TowZones[NPCTargetTowableZone]

			NPCTargetDistance = (#(vec3(currZone.VehicleDelivery.Pos.x,  currZone.VehicleDelivery.Pos.y,  currZone.VehicleDelivery.Pos.z) - vec3(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)) * 2)

			Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
			SetBlipRoute(Blips['NPCTargetTowableZone'], true)

			ESX.ShowNotification(_U('drive_to_indicated'))
		end
	end)
end

function StopNPCJob(cancel, currZone)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	currZone.VehicleDelivery.Type = -1

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		TriggerServerEvent('esx_gheneraugarage:onNPCJobMissionCompleted', NPCTargetDistance, ESX.PlayerData.job.name, ESX.PlayerData.job.grade)
	end
	
	NPCOnJob                = false
	NPCTargetTowable        = nil
	NPCTargetTowableZone    = nil
	NPCTargetDistance       = 0
	NPCHasSpawnedTowable    = false
	NPCHasBeenNextToTowable = false
	NPCTargetDeleterZone    = false
end

function SetVehicleMaxMods(vehicle)
	local t = {
		modEngine       = 3,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modArmor        = 4,
		modXenon        = true,
		modTurbo        = true,
		dirtLevel       = 0
	}

	ESX.Game.SetVehicleProperties(vehicle, t)
end

function OpenExtras()
	local elements1 = {}
	local Gracz = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(Gracz, false)

	for ExtraID=0, 20 do
		if DoesExtraExist(vehicle, ExtraID) then
			if IsVehicleExtraTurnedOn(vehicle, ExtraID) == 1 then
				local tekstlabel = 'Dodatek '..tostring(ExtraID)..' - Zdemontuj'
				table.insert(elements1, {label = tekstlabel, posiada = true, value = ExtraID})
			elseif IsVehicleExtraTurnedOn(vehicle, ExtraID) == false then
				local tekstlabel = 'Dodatek '..tostring(ExtraID)..' - Podgląd'
				table.insert(elements1, {label = tekstlabel, posiada = false, value = ExtraID})
			end
		end
	end

	if #elements1 == 0 then
		table.insert(elements1, {label = 'Ten pojazd nie posiada dodatków!', posiada = nil, value = nil})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja', {
		title    = 'Dodatki - Sklep',
		align    = 'left',
		elements = elements1
	}, function(data, menu)
		local dodatek2 = data.current.value
		if dodatek2 ~= nil then
			local dodatekTekst = 'extra'..dodatek2
			local posiada = data.current.posiada
			if posiada then
				menu.close()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja_usun', {
					title    = 'Zdemontować dodatek?',
					align    = 'left',
					elements = {
						{label = "Tak", value = "tak"},
						{label = "Nie", value = "nie"},
					}
				}, function(data2, menu2)
					local akcja = data2.current.value
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local tablica = vehicleProps.plate
					if akcja == 'tak' then
						SetVehicleExtra(vehicle, dodatek2, 1)
						TriggerServerEvent('esx_policejob:DodatkiKup', tablica, dodatekTekst, false)
					elseif akcja == 'nie' then
						SetVehicleExtra(vehicle, dodatek2, 0)
					end
					menu2.close()
					Wait(200)
					OpenDodatkiGarazMenu()
				end, function(data2, menu2)
					menu2.close()
				end)
				
			elseif posiada == false then
				SetVehicleExtra(vehicle, dodatek2, 0)
				menu.close()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja_kup', {
					title = 'Potwierdzić montaż?',
					align = 'center',
					elements = {
						{label = "Tak - Zamontuj", value = "tak"},
						{label = "Nie - Anuluj", value = "nie"},
					}
				}, function(data3, menu3)
					local akcja = data3.current.value
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local tablica = vehicleProps.plate
					if akcja == 'tak' then
						TriggerServerEvent('esx_policejob:DodatkiKup', tablica, dodatekTekst, true)
					elseif akcja == 'nie' then
						SetVehicleExtra(vehicle, dodatek2, 1)
					end
					
					menu3.close()
					Wait(200)
					OpenDodatkiGarazMenu()
				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'menu_dodatki'
		CurrentActionMsg = ""
		CurrentActionData = {}
	end)
end

function OpenMechanicBossMenu(currJob, currGrade)
	if currGrade >= 6 then
		TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', currJob, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_boss_menu'
			CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu zarządzania"
			CurrentActionData = {}
		end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
	else
		TriggerEvent('esxexile_societyrpexileesocietybig:openBossMenu', currJob, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_boss_menu'
			CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu zarządzania"
			CurrentActionData = {}
		end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
	end
end

function OpenMechanicVehicleSpawner(currZone)
	local elements = {
		{label = "Laweta", value = 'lsc_flatbed'},
		{label = "Widlak", value = 'forklift'},
		{label = 'Ford 150', value = 'lsc_ford150'},
		{label = 'Rat Loader', value = 'ratloader2'},
		{label = 'Winky', value = 'winky'},
		{label = 'Odholownik', value = 'towtruck'},
		{label = 'Transpoter', value = 'vetir'},
		{label = 'Ciężarówka', value = 'mule4'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
		title    = _U('service_vehicle'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local vehicleProps = data.current.value
		ESX.Game.SpawnVehicle(data.current.value, currZone.VehicleSpawnPoint.Pos, currZone.VehicleSpawnPoint.Heading, function(vehicle)
			local playerPed = PlayerPedId()
			ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
			SetVehicleMaxMods(vehicle)
			local plate = "MECH " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)

		menu.close()
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'mechanic_vehicle_spawner'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć pojazd"
		CurrentActionData = {}
	end)
end

function OpenPrivateStockMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garderoba', {
		title    = "Szafka prywatna",
		align    = 'bottom-right',
		elements = {
			{label = "Ubrania prywatne", value = 'player_dressing'},
		}
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
						align    = 'bottom-right',
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
			end
	end, function(data, menu)
		menu.close()
		CurrentAction	  = 'mechanic_private_menu'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby otworzyć prywatną szafkę"
		CurrentActionData = {}
	end)
end


local canCarJack = false
local carJackPulled = false
local npcVeh = nil
local npc = nil

function OpenMechanicActionsMenu(currZone, currJob, currGrade)
	local elements = {
		{label =   ('Szatnia'), 			 value = 'szatnia_menu'	},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'},
		{label = 'Wyciągnij Radio', value = 'radio'},
		{label = 'Wyciągnij BODYCAM', value = 'bodycam'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = "Divo Garage",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'szatnia_menu' then
			OpenCloakroomMenu()
		elseif data.current.value == 'przegladaj_ubrania' then
			ESX.TriggerServerCallback('mechanik:getPlayerDressing', function(dressing)
				elements = nil
				local elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wszystkie_ubrania', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements
				}, function(data2, menu2)
				
					local elements2 = {
						{ label = ('Ubierz ubranie'), value = 'ubierz_sie' },
					}
					if ESX.PlayerData.secondjob.grade >= 7 then
						table.insert(elements2, {
							label = ('<span style="color:red;"><b>Usuń ubranie</b></span>'),
							value = 'usun_ubranie' 
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edycja_ubran', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements2
				}, function(data3, menu3)
						if data3.current.value == 'ubierz_sie' then
							menu3.close()
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('mechanik:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									ESX.ShowNotification('~g~Pomyślnie zmieniłeś swój ubiór!')
									ClearPedBloodDamage(playerPed)
									ResetPedVisibleDamage(playerPed)
									ClearPedLastWeaponDamage(playerPed)
									ResetPedMovementClipset(playerPed, 0)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value, currJob)
							end)
						end
						if data3.current.value == 'usun_ubranie' then
							menu3.close()
							menu2.close()
							TriggerServerEvent('mechanik:removeOutfit', data2.current.value, currJob)
							ESX.ShowNotification('~r~Pomyślnie usunąłeś ubiór o nazwie: ~y~' .. data2.current.label)
						end
					end, function(data3, menu3)
						menu3.close()
					end)
					
				end, function(data2, menu2)
					menu2.close()
				end)
			end, currJob)
		elseif data.current.value == 'put_stock' then
			TriggerEvent('exile:putInventoryItem', 'society_' .. currJob)
		elseif data.current.value == 'get_stock' then
			TriggerEvent('exile:getInventoryItem', 'society_' .. currJob)
		elseif data.current.value == 'gps' then
			TriggerServerEvent('esx_gheneraugarage:giveitem', 'gps', 1)
			ESX.ShowNotification("~g~Wyciągnięto GPS")
		elseif data.current.value == 'radio' then
			TriggerServerEvent('esx_gheneraugarage:giveitem', 'radio', 1)
			ESX.ShowNotification("~g~Wyciągnięto Radio")
		elseif data.current.value == 'bodycam' then
			TriggerServerEvent('esx_gheneraugarage:giveitem', 'bodycam', 1)
			ESX.ShowNotification("~g~Wyciągnięto BODYCAM")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('esx_gheneraugarage:onCarokit')
AddEventHandler('esx_gheneraugarage:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			CreateThread(function()
				Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_gheneraugarage:onFixkit')
AddEventHandler('esx_gheneraugarage:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		ESX.TriggerServerCallback('esx_gheneraugarage:getczesci', function (czesci)
			if czesci >= 3 then
				if IsPedInAnyVehicle(playerPed, false) then
					vehicle = GetVehiclePedIsIn(playerPed, false)
				else
					vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end

				if DoesEntityExist(vehicle) then

					CreateThread(function()
						if not exports["exile_taskbar"]:isBusy() then
							TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						end
						exports["exile_taskbar"]:taskBar(20000, "Naprawianie silnika", true, function(cb) 
							if cb then
								local first = true
								while first or not GetIsVehicleEngineRunning(vehicle) do
									SetVehicleEngineHealth(vehicle, 1000.0)
		
									SetVehicleUndriveable(vehicle, false)
									SetVehicleEngineOn(vehicle, true, true)
									first = false
									Wait(0)
								end
								ESX.ShowNotification(_U('veh_repaired'))
								TriggerServerEvent('esx_gheneraugarage:wezczesci')
							end
						end)
					end)
				end
			else
				ESX.ShowNotification('Nie posiadasz części zamiennych (5 sztuk)')
			end
		end)
	end
end)

RegisterNetEvent('esx_gheneraugarage:onFixkitFree')
AddEventHandler('esx_gheneraugarage:onFixkitFree', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification('Nie możesz tego wykonać w środku pojazdu!')
		return
	end

	if DoesEntityExist(vehicle) then
		IsBusy = true

		CreateThread(function()
			if not exports["exile_taskbar"]:isBusy() then
				TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			end
			exports["exile_taskbar"]:taskBar(20000, "Naprawianie pojazdu", true, function(cb) 
				if cb then
					SetVehicleEngineHealth(vehicle, 1000.0)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification('Pojazd naprawiony!')
				end
				IsBusy = false
			end)


		end)
	else
		ESX.ShowNotification('W pobliżu nie ma żadnego pojazdu!')
	end
end)

function canUse(coords)
	local areas = {
		vec3(823.90, -950.56, 25.97),
	}
	
	for k,v in pairs(areas) do
		if #(v - coords) < 20.0 then 
			return true
		end	
	end
	return false
end

function SpawnJackProp(vehicle)
    local heading = GetEntityHeading(vehicle)
    local objPos = GetEntityCoords(vehicle)
    carJackObj = CreateObject(GetHashKey("prop_carjack"), objPos.x, objPos.y, objPos.z - 0.95, true, true, true)
    SetEntityHeading(carJackObj, heading)
    FreezeEntityPosition(carJackObj, true)
end
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function GetControlOfEntity(entity)
    local netTime = 15
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and netTime > 0 do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
        netTime = netTime - 1
    end
end
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

usingJack 	= false
isJackRaised 	= false
carJackObj	= nil
vehicleData = {}
vehicleJack = nil
wheelProperties = {}
vehAnalysed = false
function CarJackFunction(type)
	local player = GetPlayerPed(-1)
	local coords = GetEntityCoords(player)
	local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

	if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then 
		if usingJack then return end 
		usingJack = true
		GetControlOfEntity(vehicle)

		local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
		local door = GetOffsetFromEntityInWorldCoords(vehicle, d2.x+0.2,0.0,0.0)
		local vehCoords = GetEntityCoords(vehicle, 1)
		local distance = (GetDistanceBetweenCoords(coords, vector3(door.x, door.y, door.z), true)) 
		
		while true do 
			Wait(2)
			coords = GetEntityCoords(player)
			if not DoesEntityExist(vehicle) then break end
			distance = (GetDistanceBetweenCoords(coords, vector3(door.x, door.y, door.z), true))
			if distance < 6.0 then
				local label = ""
				local findObj = GetClosestObjectOfType(vehCoords.x, vehCoords.y, vehCoords.z, 1.0, GetHashKey("prop_carjack"), false, false, false)
				if DoesEntityExist(findObj) then
					isJackRaised = true
					if type == 'interact' then
						label = "Obniż podnośnik"
					end
				else
					if type == 'interact' then
						isJackRaised = false
						label = "Podnieś podnośnik"
					end
				end
				DrawText3Ds(door.x, door.y, door.z, "~r~[E]~s~ "..label)
				if IsControlJustPressed(0, 38) and distance < 2.0 then
					UseTheJackFunction(vehicle)
					break
				end
			end
		end
	else
		ESX.ShowNotification("Brak pojazdu wokół ciebie")
	end
	usingJack = false
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(10)
	end
end

function UseTheJackFunction(vehicle)
	local player = PlayerPedId()
	if GetEntityModel(vehicle) == GetEntityModel(npcVeh) then
		if not canCarJack then
			ESX.ShowNotification("~r~Pierw porozmawiaj z klientem!")
			return
		else
			carJackPulled = true
			exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Zlecenie", "Napraw pojazd", "positive")
		end
	end
	TaskTurnPedToFaceEntity(player, vehicle, 1.0)
	Wait(1000)
	FreezeEntityPosition(vehicle, true)
	local vehPos = GetEntityCoords(vehicle)

	if not isJackRaised then 
		SpawnJackProp(vehicle)
		Wait(250)
	else
		if DoesEntityExist(carJackObj) then
			GetControlOfEntity(carJackObj)
			SetEntityAsMissionEntity(carJackObj)
			SetVehicleHasBeenOwnedByPlayer(carJackObj, true)
		else
			carJackObj = GetClosestObjectOfType(vehPos.x, vehPos.y, vehPos.z, 1.2, GetHashKey("prop_carjack"), false, false, false)
			GetControlOfEntity(carJackObj)
			SetEntityAsMissionEntity(carJackObj)
			SetVehicleHasBeenOwnedByPlayer(carJackObj, true)
		end
	end
	vehicleJack = vehicle
	local objPos = GetEntityCoords(carJackObj)
	-- Request & Load Animation:
	local anim_dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
	local anim_lib	= "weed_crouch_checkingleaves_idle_02_inspector"
	LoadAnim(anim_dict)
	-- progbar:
	local label = ''
	if isJackRaised then label = "Opuszczanie podnośnika" else label = "Podnoszenie podnośnika" end
	exports["exile_taskbar"]:cancellableTaskBar(3000, label, false)
	-- Raise Jack Task:
	local count = 5
	TaskPlayAnim(player, anim_dict, anim_lib, 3.5, -3.5, -1, 1, false, false, false, false)
	while true do
		vehPos = GetEntityCoords(vehicle)
		objPos = GetEntityCoords(carJackObj)
		if count > 0 then 
			Wait(550)
			-- ClearPedTasks(player)
			if not isJackRaised then
				SetEntityCoordsNoOffset(vehicle, vehPos.x, vehPos.y, (vehPos.z+0.10), true, false, false, true)
				SetEntityCoordsNoOffset(carJackObj, objPos.x, objPos.y, (objPos.z+0.10), true, false, false, true)
			else
				SetEntityCoordsNoOffset(vehicle, vehPos.x, vehPos.y, (vehPos.z-0.10), true, false, false, true)
				SetEntityCoordsNoOffset(carJackObj, objPos.x, objPos.y, (objPos.z-0.10), true, false, false, true)
			end
			FreezeEntityPosition(vehicle, true)
			FreezeEntityPosition(carJackObj, true)
			count = count - 1
		end
		if count <= 0 then 
			-- ClearPedTasks(player)
			if isJackRaised then
				FreezeEntityPosition(vehicle, false)
				if DoesEntityExist(carJackObj) then 
					DeleteEntity(carJackObj)
					DeleteObject(carJackObj)
				end
				carJackObj = nil
				isJackRaised = false
			else
				isJackRaised = true
			end
			usingJack = false
			break
		end
	end
	ClearPedTasks(player)
end


function OpenMobileMechanicActionsMenu(currZone, currJob, currGrade)
	ESX.UI.Menu.CloseAll()
	local elements = {}

	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		table.insert(elements, {label = _U('hijack'), value = 'hijack_vehicle'})
		table.insert(elements, {label = "Napraw silnik", value = 'fix_vehicle'})
		table.insert(elements, {label = "Napraw karoserie", value = 'fix_body'})
		table.insert(elements, {label = ('Użyj podnośnika'), value = 'car_jack'})
		table.insert(elements, {label = ('Umyj pojazd'), value = 'clean_vehicle'})
		table.insert(elements, {label = ('Odholuj pojazd'), value = 'impound_vehicle'})
		table.insert(elements, {label = 'Odholuj pojazd na parking', value = 'impound_vehicleparking'})
		table.insert(elements, {label ="Połóż obiekt", value = 'object_spawner'})
		table.insert(elements, {label = ('Tablet'), value = 'tablet'})
		if npc then
			table.insert(elements, {label = 'Anuluj zlecenie', value = 'cancel_job'})
		end
	end
  
	
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		
		table.insert(elements, {label = _U('flat_bed'), value = 'dep_vehicle'})
		
		if currGrade > 0 then
			local coords = GetEntityCoords(PlayerPedId())
			if canUse(coords) then
				table.insert(elements, {label = ('Tuning'), value = 'Tuning'})
			end
		end
		table.insert(elements, {label = 'Zlecenie', value = 'get_job'})
		if npc then
			table.insert(elements, {label = 'Anuluj zlecenie', value = 'cancel_job'})
		end
		
	end	
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title    = "Divo Garage",
		align    = 'center',
		elements = elements
		}, function(data, menu)
	  if data.current.value == 'Tuning' then
        menu.close()

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
          local vehicle = GetVehiclePedIsIn(ped, false)
          TriggerEvent('LSC:build', vehicle, true, "Tuning", "shopui_title_carmod", function(obj)
            TriggerEvent('LSC:open', 'categories')
            FreezeEntityPosition(vehicle, true)
          end, function()
            FreezeEntityPosition(vehicle, false)
          end)
        else
          ESX.ShowNotification('Musisz być w pojeździe!')
        end	  
	  elseif data.current.value == 'tablet' then
		menu.close()
		ExecuteCommand("et")
	  elseif data.current.value == 'get_job' then
		menu.close()
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if veh and GetEntityModel(veh) == GetHashKey("lsc_ford150") then
			TakeJob()
		else
			ESX.ShowNotification("~r~Aby wziąść zlecenie musisz być w pojeździe służbowym Ford Raptor F150")
		end
	  elseif data.current.value == 'cancel_job' then
		menu.close()
		EndMission()
	  elseif data.current.value == 'car_jack' then
		menu.close()
		CarJackFunction("interact")
      elseif data.current.value == 'hijack_vehicle' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
          local vehicle
          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
			local model = GetEntityModel(vehicle)
			if not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABoat(model) then

              CreateThread(function()				
				if not exports["exile_taskbar"]:isBusy() then
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
				end
				exports["exile_taskbar"]:taskBar(10000, "Trwa odblokowywanie", true, function(cb) 
					if cb then
						while GetVehicleDoorsLockedForPlayer(vehicle, PlayerId()) ~= false do
							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							Wait(0)
						end

						ClearPedTasksImmediately(playerPed)
						ESX.ShowNotification(_U('vehicle_unlocked'))
						TriggerServerEvent('exile:pay', 500)
					end
				end)
              end)
			end
          end
        end
      elseif data.current.value == 'fix_vehicle' then
		local playerPed = PlayerPedId()
		local vehicle   = ESX.Game.GetVehicleInDirection()
		if not vehicle then return end
		local coords    = GetEntityCoords(playerPed)
		local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
		local hood = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2.y+0.2,0.0)
		local distance = (GetDistanceBetweenCoords(coords, vector3(hood.x, hood.y, hood.z), true))
		if distance > 1.0 then
			ESX.ShowNotification("~r~Stoisz za daleko maski!")
			return
		end

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

		if DoesEntityExist(vehicle) then
			IsBusy = true

			CreateThread(function()
				if not exports["exile_taskbar"]:isBusy() then
					--TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
					SetVehicleDoorOpen(vehicle, 4, 0, 0)
					TaskTurnPedToFaceEntity(playerPed, vehicle, 1.0)
					Wait(1000)
					local animDict = "mini@repair"
					LoadAnim(animDict)
					if not IsEntityPlayingAnim(playerPed, animDict, "fixing_a_player", 3) then
						TaskPlayAnim(playerPed, animDict, "fixing_a_player", 5.0, -5, -1, 16, false, false, false, false)
					end
				end
				exports["exile_taskbar"]:taskBar(17000, "Naprawianie silnika", true, function(cb) 
					if cb then
						SetVehicleEngineHealth(vehicle, 1000.0)
						SetVehicleDeformationFixed(vehicle)
						SetVehicleUndriveable(vehicle, false)
						SetVehicleEngineOn(vehicle, true, true)
						ClearPedTasksImmediately(playerPed)

						ESX.ShowNotification(_U('vehicle_repaired'))

					end
					IsBusy = false
				end)


			end)
		else
			ESX.ShowNotification(_U('no_vehicle_nearby'))
		end
	  elseif data.current.value == 'fix_body' then
		local playerPed = PlayerPedId()
		local vehicle   = vehicleJack
		if not vehicle then return end
		local vCoords = GetEntityCoords(vehicle)
		local coords    = GetEntityCoords(playerPed)
		if #(vCoords - coords) > 5.0 then
			ESX.ShowNotification("~r~Jesteś za daleko pojazdu!")
			return
		end
		local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
		local hood = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2.y+0.2,0.0)
		local distance = (GetDistanceBetweenCoords(coords, vector3(hood.x, hood.y, hood.z), true))
		if distance > 1.0 then
			ESX.ShowNotification("~r~Stoisz za daleko maski!")
			return
		end

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

		if DoesEntityExist(vehicle) then
			IsBusy = true

			CreateThread(function()
				local length = 25*1000
				if not exports["exile_taskbar"]:isBusy() then
					--TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
					SetVehicleDoorOpen(vehicle, 4, 0, 0)
					SetEntityHeading(playerPed, GetEntityHeading(vehicle))
					Wait(1000)
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true)
					local health = GetVehicleBodyHealth(vehicle)
					local ehealth = GetVehicleEngineHealth(vehicle)
					length = 0
					if ehealth > 800 then
						length = 8000
					elseif ehealth > 700 then
						length = 13000
					elseif ehealth > 400 then
						length = 15000
					elseif ehealth > 200 then
						length = 17000
					else 
						length = 20000
					end
					if health > 800 then
						length = length+8000
					elseif health > 700 then
						length = length+13000
					elseif health > 400 then
						length = length+15000
					elseif health > 200 then
						length = length+17000
					else 
						length = length+20000
					end

				end
				exports["exile_taskbar"]:taskBar(length, "Naprawianie karoserii", true, function(cb) 
					if cb then
						SetVehicleFixed(vehicle)
						SetVehicleDeformationFixed(vehicle)
						SetVehicleUndriveable(vehicle, false)
						SetVehicleEngineOn(vehicle, true, true)
						ClearPedTasksImmediately(playerPed)

						ESX.ShowNotification(_U('vehicle_repaired'))
						if vehicle == npcVeh then
							VehicleFixed()
						end

					end
					IsBusy = false
				end)


			end)
		else
			ESX.ShowNotification(_U('no_vehicle_nearby'))
		end
      elseif data.current.value == 'clean_vehicle' then
		local playerPed = PlayerPedId()
		local vehicle   = ESX.Game.GetVehicleInDirection()
		local coords    = GetEntityCoords(playerPed)

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

		if DoesEntityExist(vehicle) then
			IsBusy = true

			CreateThread(function()
				if not exports["exile_taskbar"]:isBusy() then
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
				end
				exports["exile_taskbar"]:taskBar(10000, "Mycie pojazdu", true, function(cb) 
					if cb then
						SetVehicleDirtLevel(vehicle, 0)
						ClearPedTasksImmediately(playerPed)

						ESX.ShowNotification(_U('vehicle_cleaned'))
					end
					IsBusy = false
				end)



			end)
		else
			ESX.ShowNotification(_U('no_vehicle_nearby'))
		end
	elseif data.current.value == 'impound_vehicleparking' then
		local playerPed = PlayerPedId()
		ESX.UI.Menu.CloseAll()
		if CurrentTask.Busy then
			return
		end
		SetTextComponentFormat('STRING')
		AddTextComponentString('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie na parking mechaników~s~')
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		CurrentTask.Busy = true
		CurrentTask.Task = ESX.SetTimeout(10000, function()
			ClearPedTasks(playerPed)
			TriggerEvent("esx_impound", 'cos', 'MECH')
			ESX.ShowNotification('~o~Włożono pojazd na parking mechaników!')
			CurrentTask.Busy = false
			Citizen.Wait(100)
		end)

		CreateThread(function()
			while CurrentTask.Busy do
				Citizen.Wait(1000)

				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				if not DoesEntityExist(vehicle) and CurrentTask.Busy then
					ESX.ShowNotification('~r~Zajęcie zostało anulowane, ponieważ pojazd przemieścił się')
					ESX.ClearTimeout(CurrentTask.Task)

					ClearPedTasks(playerPed)
					CurrentTask.Busy = false
					break
				end
			end
		end)
	  elseif data.current.value == 'impound_vehicle' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)	 
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

			-- keep track of that vehicle!
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
      elseif data.current.value == 'dep_vehicle' then
		OnFlatbedUse('lsc_flatbed', currZone)
      elseif data.current.value == 'object_spawner' then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn', {
            title    = "Obiekty",
            align    = 'center',
            elements = {
			  {label = ('Słupek'),     value = 'prop_roadcone02a'},
			  {label = ('Barierka'), value = 'prop_barrier_work06a'},
			  {label = ('Przybornik'), value = 'prop_toolchest_01'},
            },
        }, function(data2, menu2)
			local model   = data2.current.value
			local playerPed = PlayerPedId()
			local coords  = GetEntityCoords(playerPed)
			local forward = GetEntityForwardVector(playerPed)
			local x, y, z = table.unpack(coords + forward * 1.0)

			if model == 'prop_roadcone02a' or model == 'prop_toolchest_01' or model == 'prop_barrier_work06a' then
				z = z - 1.0
			end

			ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
				SetEntityHeading(obj, GetEntityHeading(playerPed))
				PlaceObjectOnGroundProperly(obj)
			end)
        end, function(data2, menu2)
            menu2.close()
        end)
      end
	end, function(data, menu)
		menu.close()
	end)
end

function OnFlatbedUse(model, currZone)
	local playerPed = PlayerPedId()
	
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, model) then
	  if CurrentlyTowedVehicle == nil then
		local targetVehicle = nil
		local coords = GetEntityCoords(vehicle)
		if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 10.0) then
          targetVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)
		  if targetVehicle == vehicle or targetVehicle == 0 or targetVehicle == nil then
			targetVehicle = nil
		  end
		end

		if targetVehicle then
			if vehicle ~= targetVehicle then
			  local offset = {
				['lsc_flatbed'] = {x = 0.0, y = -3.0, z = 1.2},
				['ambflatbed'] = {x = 0.0, y = -2.5, z = 0.65},
				['mechflatbed'] = {x = 0.0, y = -2.5, z = 1.0}
			  }

			  AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), offset[model].x, offset[model].y, offset[model].z, 0, 0, 0, 1, 1, 0, 1, 0, 1)
			  CurrentlyTowedVehicle = targetVehicle
			  ESX.ShowNotification(_U('vehicle_success_attached'))

			  if NPCOnJob then
				if NPCTargetTowable == targetVehicle then
				  ESX.ShowNotification(_U('please_drop_off'))

				  currZone.VehicleDelivery.Type = 1
				  if Blips['NPCTargetTowableZone'] ~= nil then
					RemoveBlip(Blips['NPCTargetTowableZone'])
					Blips['NPCTargetTowableZone'] = nil
				  end

				  Blips['NPCDelivery'] = AddBlipForCoord(currZone.VehicleDelivery.Pos.x,  currZone.VehicleDelivery.Pos.y,  currZone.VehicleDelivery.Pos.z)
				  SetBlipRoute(Blips['NPCDelivery'], true)
				end
			  end
			else
			  ESX.ShowNotification(_U('cant_attach_own_tt'))
			end
		else
		  ESX.ShowNotification(_U('no_veh_att'))
		end
	  else
		DetachEntity(CurrentlyTowedVehicle, true, true)
		local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -12.0, 0.0)
		SetEntityCoords(CurrentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)

		SetVehicleOnGroundProperly(CurrentlyTowedVehicle)
		if NPCOnJob then
		  if CurrentlyTowedVehicle == NPCTargetTowable then
			if NPCTargetDeleterZone then
			  SetVehicleHasBeenOwnedByPlayer(NPCTargetTowable, false)
			  ESX.Game.DeleteVehicle(NPCTargetTowable)
			  StopNPCJob(false, currZone)
			else
			  ESX.ShowNotification("~r~Ten pojazd musi zostać odstawiony w prawidłowym miejscu")
			end
		  elseif NPCTargetDeleterZone then
			ESX.ShowNotification(_U('not_right_veh'))
		  end
		end

		CurrentlyTowedVehicle = nil
		ESX.ShowNotification(_U('veh_det_succ'))
	  end
	else
	  ESX.ShowNotification(_U('lsc_flatbed'))
	end
end

RegisterNetEvent('esx_gheneraugarage:onHijack')
AddEventHandler('esx_gheneraugarage:onHijack', function()
	local playerPed = PlayerPedId()

	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = ESX.Game.GetVehicleInDirection()
		if not vehicle then
			local coords = GetEntityCoords(playerPed, false)
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end
		end
	end

	if vehicle and vehicle ~= 0 then		
		if IsVehicleAlarmSet(vehicle) and GetRandomIntInRange(1, 100) <= 33 then
			local id = NetworkGetNetworkIdFromEntity(vehicle)
			SetNetworkIdCanMigrate(id, false)

			local tries = 0
			while not NetworkHasControlOfNetworkId(id) and tries < 10 do
				tries = tries + 1
				NetworkRequestControlOfNetworkId(id)
				Wait(100)
			end

			StartVehicleAlarm(vehicle)
			TriggerEvent('outlawalert:processThief', playerPed, vehicle, false)
			SetNetworkIdCanMigrate(id, true)
		end


		CreateThread(function()			
			if not exports["exile_taskbar"]:isBusy() then
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
			end
			exports["exile_taskbar"]:taskBar(15000, "Trwa Odblokowywanie", true, function(cb) 
				if cb then
					ClearPedSecondaryTask(playerPed)
					if GetRandomIntInRange(1, 100) <= 66 then
						local id = NetworkGetNetworkIdFromEntity(vehicle)
						SetNetworkIdCanMigrate(id, false)

						local tries = 0
						while not NetworkHasControlOfNetworkId(id) and tries < 10 do
							tries = tries + 1
							NetworkRequestControlOfNetworkId(id)
							Wait(100)
						end

						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						Wait(0)

						SetNetworkIdCanMigrate(id, true)
						ESX.ShowNotification(_U('veh_unlocked'))
						ClearPedTasks(playerPed)
						ClearPedSecondaryTask(playerPed)
					else
						ESX.ShowNotification(_U('hijack_failed'))
						ClearPedTasks(playerPed)
						ClearPedSecondaryTask(playerPed)
					end
				end
				
			end)


		end)
    end
end)

RegisterNetEvent('esx_gheneraugarage:onCarokit')
AddEventHandler('esx_gheneraugarage:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			CreateThread(function()
				local lastHealth = GetVehicleEngineHealth(vehicle)
				Wait(14900)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				Wait(100)
				SetVehicleEngineHealth(vehicle, lastHealth)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_gheneraugarage:onFixkit')
AddEventHandler('esx_gheneraugarage:onFixkit', function(value, wait)
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end

	if DoesEntityExist(vehicle) then
		IsBusy = true

		CreateThread(function()
			if not exports["exile_taskbar"]:isBusy() then
				TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			end
			exports["exile_taskbar"]:taskBar(20000, "Naprawianie pojazdu", true, function(cb) 
				if cb then
					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_repaired'))
				end
				
				IsBusy = false
			end)


		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
	end
end)


AddEventHandler('esx_gheneraugarage:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == "VehicleExtras" then
		CurrentAction     = 'extras_menu'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu z dodatkami"
		CurrentActionData = {}
	elseif zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = 'Wciśnij ~INPUT_CONTEXT~ aby otworzyć menu.'
		CurrentActionData = {}
	elseif zone == 'BossMenu' then
		CurrentAction	  = 'mechanic_boss_menu'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu zarządzania"
		CurrentActionData = {}
	elseif zone == 'PrivateStock' then
		CurrentAction	  = 'mechanic_private_menu'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby otworzyć prywatną szafkę"
		CurrentActionData = {}
	elseif zone == 'VehicleSpawner' then
		CurrentAction	  = 'mechanic_vehicle_spawner'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć pojazd"
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_gheneraugarage:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Pop NPC mission vehicle when inside area

CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(100)
	  end
	while true do
		Wait(3)
		if ESX.PlayerData.job.name == "gheneraugarage" then
			local sleep = true
			if NPCTargetTowableZone ~= nil and not NPCHasSpawnedTowable then
				sleep = false
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.TowZones[NPCTargetTowableZone]
				if #(coords - vec3(zone.Pos.x, zone.Pos.y, zone.Pos.z)) < Config.NPCSpawnDistance then
					local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]
					ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
						SetVehicleHasBeenOwnedByPlayer(vehicle, true)
						NPCTargetTowable = vehicle
					end)

					NPCHasSpawnedTowable = true
				end
			end

			if NPCTargetTowableZone ~= nil and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
				sleep = false
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.TowZones[NPCTargetTowableZone]
				if(#(coords - vec3(zone.Pos.x, zone.Pos.y, zone.Pos.z)) < Config.NPCNextToDistance) then
					ESX.ShowNotification(_U('please_tow'))
					NPCHasBeenNextToTowable = true
				end
			end
			if sleep then
				Wait(250)
			end
		else
			Wait(500)
		end
	end
end)

-- Create Blips
CreateThread(function()
	for k,v in pairs(Config.Blips) do
		local blip = AddBlipForCoord(v.Pos)

		SetBlipSprite (blip, v.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, v.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.Label)
		EndTextCommandSetBlipName(blip)
	end
end)
local inTunning = false
-- Display markers
CreateThread(function()
	while true do
		Wait(0)
		if ESX.PlayerData.job ~= nil then
		
			if Config.Zones[ESX.PlayerData.job.name] or Config.Zones[string.sub(ESX.PlayerData.job.name, 4)]  then
				local coords, letSleep = GetEntityCoords(PlayerPedId()), true
				local configTable
				if Config.Zones[ESX.PlayerData.job.name] ~= nil then
					configTable = Config.Zones[ESX.PlayerData.job.name]
				elseif Config.Zones[string.sub(ESX.PlayerData.job.name, 4)] ~= nil then
					configTable = Config.Zones[string.sub(ESX.PlayerData.job.name, 4)]
				end

				for k,v in pairs(configTable) do
					if v.Type ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
						if v.Type == 28 then
							ESX.DrawBigMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
						else
							ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
						end
						letSleep = false
					end
				end

				if letSleep then
					Wait(1000)
				end
			else
				Wait(1000)
			end
		
		else
			Wait(5000)
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		Wait(500)
		if ESX.PlayerData.job ~= nil then
			if Config.Zones[ESX.PlayerData.job.name] or Config.Zones[string.sub(ESX.PlayerData.job.name, 4)] then
				local sleep = true
				local coords      = GetEntityCoords(PlayerPedId())
				local isInMarker  = false
				local currentZone = nil
				local configTable
				if Config.Zones[ESX.PlayerData.job.name] ~= nil then
					configTable = Config.Zones[ESX.PlayerData.job.name]
				elseif Config.Zones[string.sub(ESX.PlayerData.job.name, 4)] ~= nil then
					configTable = Config.Zones[string.sub(ESX.PlayerData.job.name, 4)]
				end

				for k,v in pairs(configTable) do
					local size = v.Size.x if size == 20.0 then size = 3.5 end
					if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < size then
						sleep = false
						isInMarker  = true
						currentZone = k
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					print(1)
					TriggerEvent('esx_gheneraugarage:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					print(2)
					TriggerEvent('esx_gheneraugarage:hasExitedMarker', LastZone)
				end
				if sleep then
					Wait(500)
				end
			else
				Wait(2000)
			end
		else
			Wait(2000)
		end
	end
end)

CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(100)
	end
	while true do
		if ESX.PlayerData.job ~= nil and Config.Zones[ESX.PlayerData.job.name] or Config.Zones[string.sub(ESX.PlayerData.job.name, 4)] then
			local playerPed = PlayerPedId()
			if not IsPedInAnyVehicle(playerPed, false) then
				local coords = GetEntityCoords(playerPed)

				local found = false
				for _, prop in ipairs({
					'prop_roadcone02a',
					'prop_toolchest_01',
					'prop_barrier_work06a'
				}) do
					local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  2.0,  GetHashKey(prop), false, false, false)
					if DoesEntityExist(object) then
						CurrentAction     = 'remove_entity'
						CurrentActionMsg  = ('Naciśnij ~INPUT_CONTEXT~ aby usunąć ten obiekt')
						CurrentActionData = {entity = object}
						found = true
						break
					end
				end

				if not found and CurrentAction == 'remove_entity' then
					CurrentAction = nil
				end

				Wait(200)
			else
				Wait(1000)
			end
		else
			Wait(1000)
		end
	end
end)

-- Key Controls
CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(0)
		if ESX.PlayerData.job.name == "gheneraugarage" or ESX.PlayerData.job.name == "offgheneraugarage" then
			if CurrentAction then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) then
					if Config.Zones[ESX.PlayerData.job.name] then
						local currZone = Config.Zones[ESX.PlayerData.job.name]
						local currJob = ESX.PlayerData.job.name
						local currGrade = ESX.PlayerData.job.grade
						if CurrentAction == 'extras_menu' then
							OpenExtras()	
						elseif CurrentAction == 'mechanic_actions_menu' then
							OpenMechanicActionsMenu(currZone, currJob, currGrade)
						elseif CurrentAction == 'mechanic_boss_menu' then
							OpenMechanicBossMenu(currJob, currGrade)
						elseif CurrentAction == 'mechanic_vehicle_spawner' then
							OpenMechanicVehicleSpawner(currZone)
						elseif CurrentAction == 'mechanic_private_menu' then
							OpenPrivateStockMenu()
						elseif CurrentAction == 'delete_vehicle' then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						elseif CurrentAction == 'remove_entity' then
							DeleteEntity(CurrentActionData.entity)
						end

						CurrentAction = nil
					elseif Config.Zones[string.sub(ESX.PlayerData.job.name, 4)] then
						if CurrentAction == 'mechanic_actions_menu' then
							OpenMechanicActionsMenu(Config.Zones[string.sub(ESX.PlayerData.job.name, 4)], string.sub(ESX.PlayerData.job.name, 4), ESX.PlayerData.job.grade)
						end
					end
				end
			else
				Wait(333)
			end
		else
			Wait(2000)
		end
	end
end)

RegisterCommand('-ghenerauf6', function(source, args, rawCommand)
	if not isDead and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "gheneraugarage" and not isDead  then
		local currZone = Config.Zones[ESX.PlayerData.job.name]
		local currJob = ESX.PlayerData.job.name
		local currGrade = ESX.PlayerData.job.grade
		OpenMobileMechanicActionsMenu(currZone, currJob, currGrade)
	end
end, false)

RegisterKeyMapping('-ghenerauf6', 'Włącz/wyłącz menu (Divo Garage)', 'keyboard', 'F6')


RegisterCommand('-ghenerauf9', function(source, args, rawCommand)
	if not isDead and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "gheneraugarage" and not isDead  then
		local currZone = Config.Zones[ESX.PlayerData.job.name]
		if NPCOnJob then
			if GetGameTimer() - NPCLastCancel > 5 * 60000 then
				StopNPCJob(true, currZone)
				NPCLastCancel = GetGameTimer()
			else
				ESX.ShowNotification(_U('wait_five'))
			end
		else
			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `lsc_flatbed`) then
				StartNPCJob(currZone)
			else
				ESX.ShowNotification(_U('must_in_flatbed'))
			end
		end
	end
end, false)

RegisterKeyMapping('-ghenerauf9', 'Zacznij pracować (Divo Garage)', 'keyboard', 'F9')

-- Key Controls
CreateThread(function()
	while ESX.PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(10)
		if ESX.PlayerData.job.name == "gheneraugarage" and not isDead then
			if CurrentTask.busy then
				if IsControlJustReleased(0, 38) then
					ESX.ShowNotification('Unieważniasz zajęcie')
					ESX.ClearTimeout(CurrentTask.task)
					ClearPedTasks(PlayerPedId())

					CurrentTask.busy = false
				end	
			else
				Wait(250)
			end
		else
			Wait(2000)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	hasAlreadyJoined = true
end)

function OpenCloakroomMenu()

	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
	}

	if ESX.PlayerData.job.name == 'gheneraugarage' then
		table.insert(elements, {label = 'Ubrania Służbowe', value = 'uniforms'})
	end



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = ('Szatnia - DG'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.UI.Menu.CloseAll()
			if ESX.PlayerData.job.name == 'gheneraugarage' then
				ESX.ShowNotification('~b~Schodzisz ze służby')
				TriggerServerEvent('exile:setJob', 'gheneraugarage', false)
			end
		end

		if data.current.value == 'uniforms' then
			local elements2 = {
				{label = "Recruit", value = 'recruit_wear'},
				{label = "Novice", value = 'novice_wear'},
				{label = "Master", value = 'master_wear'},
				{label = "Expert", value = 'expert_wear'},
				{label = "Professionalist", value = 'professionalist_wear'},
				{label = "Specialist", value = 'specialist_wear'},
				{label = "Coordinator of DG", value = 'coordinator_wear'},
				{label = "Deputy Chief of DG", value = 'deputychief_wear'},
				{label = "Chief of DG", value = 'chief_wear'},
				{label = "Committee of DG", value = 'chief_wear'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'uniforms', {
				title    = "Szatnia - DG",
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

	if
		data.current.value == 'recruit_wear' or
		data.current.value == 'novice_wear' or
		data.current.value == 'master_wear' or
		data.current.value == 'expert_wear' or
		data.current.value == 'professionalist_wear' or
		data.current.value == 'specialist_wear' or
		data.current.value == 'coordinator_wear' or
		data.current.value == 'deputychief_wear' or
		data.current.value == 'chief_wear'
	then
		setUniform(data.current.value, playerPed)
	end

	end, function(data, menu)
		menu.close()
	end)
end



--[[
	NPC JOB
]]

local part1,part2,part3 = false,false,false

local progressID = "exilerpGhenerau"..math.random(10000,99999)
local shownProgress = false
local taskCoords = {}
local jobId = 0
local currentBlip = nil
function TakeJob(x) 
	if x and not tonumber(x) then return end
	if ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'offgheneraugarage' then
		shownProgress = true
		exports["esx_exilechat"]:showSolid(progressID, "hourglass_bottom", "center-special", "Zlecenie", "Oczekuj na informację od klienta...", "warning")
		Citizen.SetTimeout(3000, function() 
			if not x then
				jobId = math.random(1, #Config.TasksList)
				taskCoords = Config.TasksList[jobId]
			else
				jobId = tonumber(x)
				taskCoords = Config.TasksList[tonumber(x)]
			end
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
			Wait(320)
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
			Wait(320)
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
			TriggerEvent("FeedM:showAdvancedNotification", "NPC", '~o~Zlecenie', "Potrzebuję pomocy ze swoim samochodem!", 'CHAR_SOCIAL_CLUB', 5000)
			exports["esx_exilechat"]:updateSolid(progressID, "gps_fixed", "center-special", "Zlecenie", "Dojedź na miejsce klienta", "positive")
			PrepareJob()
			RemoveBlip(currentBlip)
			currentBlip = AddBlipForCoord(taskCoords.blip.x, taskCoords.blip.y, taskCoords.blip.z)
			SetBlipRoute(currentBlip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Zlecenie')
			EndTextCommandSetBlipName(currentBlip)
		end)
	end
end
local anims = {
	waiting = {
		lib = "random@domestic", anim = "f_distressed_loop"
	},
	repairing = {
		lib = "rcmme_tracey1", anim = "nervous_loop"
	},
	talking1 = {
		lib = "mini@hookers_sp", anim = "idle_reject_loop_c"
	},
	talking2 = {
		lib = "misscarsteal4@actor", anim = "actor_berating_assistant"
	},
	talking3 = {
		lib = "gestures@f@standing@casual", anim = "gesture_damn"
	},
	talking4 = {
		lib = "random@shop_tattoo", anim = "_idle"
	}
}
local cars = {
	"sultanrs",
	"sultan",
	"jester4",
	"previon",
	"tailgater2"
}
function PrepareJob() 
	CreateThread(function() 
		local model = GetHashKey("cs_nervousron")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(50)
		end
		ESX.Game.SpawnVehicle(cars[math.random(1,#cars)], vector3(taskCoords.vehicle.x, taskCoords.vehicle.y, taskCoords.vehicle.z-0.95), taskCoords.vehicle.heading, function(veh) 
			npcVeh = veh
			npc = CreatePed(5, model, taskCoords.npc.x, taskCoords.npc.y, taskCoords.npc.z-0.95, 0.0, false, true)

			SetEntityHeading(npc, taskCoords.npc.heading)
			SetVehicleEngineHealth(npcVeh, 100)
			SetVehicleDoorsLocked(npcVeh, true)
			SetVehicleDoorsLockedForPlayer(npcVeh, PlayerPedId(), true)
			FreezeEntityPosition(npc, true)
			FreezeEntityPosition(npcVeh, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			TaskPlayAnim(npc, anims.waiting.lib, anims.waiting.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		end)
	end)
end
local canTalkWithNPC = false
CreateThread(function() 
	while true do
		Wait(2000)
		if currentBlip ~= nil then
			local blipCoords = GetBlipCoords(currentBlip)
			local playerCoords = GetEntityCoords(PlayerPedId())
			local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if #(blipCoords - playerCoords) < 20.0 then
				if playerVehicle then
					if GetEntityModel(playerVehicle) == GetHashKey("lsc_ford150") then
						RemoveBlip(currentBlip)
						exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Zlecenie", "Porozmawiaj z klientem", "positive")
						canTalkWithNPC = true
						part1 = true
					else
						ESX.ShowNotification("~r~Przyjedź na miejsce samochodem służbowym Raptor F150!")
					end
				end
			end
		else
			Wait(5000)
		end
	end
end)
CreateThread(function() 
	while true do
		Wait(3)
		if canTalkWithNPC then
			local pedCoords = vector3(taskCoords.npc.x, taskCoords.npc.y, taskCoords.npc.z)
			local playerCoords = GetEntityCoords(PlayerPedId())
			if #(pedCoords - playerCoords) < 3.0 then
				DrawText3Ds(taskCoords.npc.x, taskCoords.npc.y, taskCoords.npc.z, "~r~[E]~s~ Porozmawiaj z klientem")
				if IsControlJustPressed(0, 38) then
					CreateTalkCam()
					if part1 then
						Dialog1()
					elseif part2 then
						Dialog2()
					end
				end
			end
		else
			Wait(1000)
		end
	end
end)
local cam = nil
function CreateTalkCam()
	canTalkWithNPC = false
	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')

	local coordsCam = GetOffsetFromEntityInWorldCoords(npc, 0.0, 1.0, 0.65)
	local coordsPly = GetEntityCoords(npc)
	SetCamCoord(cam, coordsCam)
	PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z']+0.65)

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)
end

function Dialog1() 
	part1 = false
	ClearPedTasks(npc)
	TaskPlayAnim(npc, anims.talking1.lib, anims.talking1.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Klient", "Witam, dziękuje za szybki przyjazd.", "black")
	Wait(3000)
	ClearPedTasks(npc)
	TaskPlayAnim(npc, anims.talking2.lib, anims.talking2.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Klient", "Jadąc wyjechał mi pojazd z nad przeciwka i wjechałem w drzewo.", "black")
	Wait(3000)
	ClearPedTasks(npc)
	TaskPlayAnim(npc, anims.talking3.lib, anims.talking3.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Klient", "Stało się to szybko i nagle!", "black")
	Wait(1500)
	ClearPedTasks(npc)
	TaskPlayAnim(npc, anims.talking4.lib, anims.talking4.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Klient", "Prosiłbym o naprawę pojazdu.", "black")
	Wait(5000)
	SetCamActive(cam, false)
	RenderScriptCams(false, false, 500, false, false)
	DestroyCam(cam)
	cam = nil
	ClearPedTasks(npc)
	TaskPlayAnim(npc, anims.repairing.lib, anims.repairing.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	exports["esx_exilechat"]:updateSolid(progressID, "precision_manufacturing", "center-special", "Zlecenie", "Podnieś pojazd na podnośnik i go napraw", "positive")
	SetEntityDrawOutline(npcVeh, true)
	SetEntityDrawOutlineColor(255,255,255,120)
	SetEntityDrawOutlineShader(0)
	canCarJack = true
end

function Dialog2() 
	ClearPedTasks(npc)
	TaskPlayAnim(npc, anims.talking1.lib, anims.talking1.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Klient", "Dziękuje za naprawe! Oto twoja zapłata.", "black")
	Wait(3000)
	SetCamActive(cam, false)
	RenderScriptCams(false, false, 500, false, false)
	DestroyCam(cam)
	cam = nil
	TriggerServerEvent("exilerpNPC:jobComplete", jobId)
	exports["esx_exilechat"]:updateSolid(progressID, "task_alt", "center-special", "Zlecenie", "Wykonano zlecenie! Zarobiono "..taskCoords.price.."$", "positive")
	Wait(15000)
	EndMission()
end

function EndMission() 
	exports["esx_exilechat"]:hideSolid(progressID)
	RemoveBlip(currentBlip)
	if cam then
		SetCamActive(cam, false)
		RenderScriptCams(false, false, 500, false, false)
		DestroyCam(cam)
		cam = nil
	end
	SetEntityDrawOutline(npcVeh, false)
	DeleteEntity(npc)
	DeleteEntity(npcVeh)
	npc = nil
	npcVeh = nil
	canTalkWithNPC = false
	currentBlip = nil
	canCarJack = false
	carJackPulled = false
end

function VehicleFixed() 
	SetEntityDrawOutline(npcVeh, false)
	UseTheJackFunction(npcVeh)
	exports["esx_exilechat"]:updateSolid(progressID, "record_voice_over", "center-special", "Zlecenie", "Naprawiono pojazd. Porozmawiaj z klientem", "positive")
	canTalkWithNPC = true
	part2 = true
end

--[[RegisterCommand("npcjob", function(src,args,raw) 
	if args[1] then
		TakeJob(args[1])
	end
end)

RegisterCommand("endjob", function() 
	if not shownProgress then return end
	exports["esx_exilechat"]:hideSolid(progressID)
	RemoveBlip(currentBlip)
	if cam then
		SetCamActive(cam, false)
		RenderScriptCams(false, false, 500, false, false)
		DestroyCam(cam)
		cam = nil
	end
	DeleteEntity(npc)
	DeleteEntity(npcVeh)
	SetEntityDrawOutline(npcVeh, false)
	canTalkWithNPC = false
	currentBlip = nil
	canCarJack = false
	carJackPulled = false
end)]]