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

RegisterNetEvent("exile_legalburgershot:getrequest")
TriggerServerEvent("exile_legalburgershot:request")
AddEventHandler("exile_legalburgershot:getrequest", function(a, b, c)
	_G.donttouch = a
	_G.exile_krawic = b
	_G.exile_krawi2 = c

	local donttouchme = _G.donttouch
	local exile_legalburgershot = _G.exile_krawic
	local exile_legalburgershot2 = _G.exile_krawi2

local PlayerData, CafeBlips, CanWork, alreadyOut = {}, {}, false, false
local CurrentAction				= nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentActionData			= {}
local CurrentActionMsg			= ''
local cooldown = false
local blokada = false
local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local playerPed = PlayerPedId()
local pCoords = GetEntityCoords(playerPed)

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
		pCoords = GetEntityCoords(playerPed)
        Wait(500)
    end
end)

local Cfg = {
	CollectSeeds = {
		{
			coords = vector3(-2959.37, 371.74, 14.77-0.95),
		},
	},
	TransferingSeeds = {
		{
			coords = vector3(-1193.15, -904.28, 13.99-0.95),
		},
	},
	Garage = {
		{
			coords = vector3(-2976.34, 359.39, 14.78-0.95)
		},
		{
			coords = vector3(-1179.09, -878.07, 13.94-0.95)
		},
	},
	BossActions = {
		{
			coords = vector3(-1194.14, -895.74, 13.99-0.95)
		},
	},
	Cloakroom = {
		{
			coords = vector3(-2961.6, 376.83, 15.0-0.95)
		},
		{
			coords = vector3(-1177.65, -891.11, 13.78-0.95)
		},
	},
	Clothes = {
		Male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 460, ['torso_2'] = 6,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 52,
			['pants_1'] = 174, ['pants_2'] = 0,
			['shoes_1'] = 159, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0,
			['bproof_1'] = 0, ['bproof_2'] = 0,
			['mask_1'] = 0, ['mask_2'] = 0,
			['bags_1'] = 81, ['bags_2'] = 0
		},
		Female = {
			['tshirt_1'] = 14, ['tshirt_2'] = 0,
			['torso_1'] = 468, ['torso_2'] = 6,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 173, ['pants_2'] = 21,
			['shoes_1'] = 162, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0,
			['bproof_1'] = 0, ['bproof_2'] = 0,
			['mask_1'] = 0, ['mask_2'] = 0,
			['bags_1'] = 0, ['bags_2'] = 0
		},
	},
}

local Blips = {
	{title="#1 Szatnia", colour=5, id=126, see = true, coords = vector3(-2961.6, 376.83, 15.0)},
	{title="#2 Zbieranie Skladnik??w", colour=5, id=126, see = true, coords = vector3(-2959.37, 371.74, 14.77)},
	{title="#3 Przer??bka Skladnik??w", colour=5, id=126, see = true, coords = vector3(-1193.15, -904.28, 13.99)}
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	RefreshBlips()
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob)
	ESX.PlayerData.secondjob = secondjob
	CanWork = false
	DeleteBlip()
	RefreshBlips()
end)

RefreshBlips = function()
	if ESX.PlayerData.secondjob ~= nil and ESX.PlayerData.secondjob.name == 'burgershot' then
		for i=1, #Blips, 1 do
			if Blips[i].see then
				local blip = AddBlipForCoord(Blips[i].coords)
				SetBlipSprite(blip, Blips[i].id)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, 0.9)
				SetBlipColour(blip, Blips[i].colour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Blips[i].title)
				EndTextCommandSetBlipName(blip)

				table.insert(CafeBlips, blip)
			end
		end
	end
end

DeleteBlip = function()
	if CafeBlips[1] ~= nil then
		for i=1, #CafeBlips, 1 do
			RemoveBlip(CafeBlips[i])
			CafeBlips[i] = nil
		end
	end
end

CreateThread(function()
	while ESX.PlayerData.secondjob == nil do
		Wait(1000)
	end
	while true do
		Wait(1)
		if ESX.PlayerData.secondjob ~= nil and ESX.PlayerData.secondjob.name == 'burgershot' then
			local found = false
			local isInMarker	= false
			local currentZone	= nil
			local zoneNumber 	= nil
			for k,v in pairs(Cfg) do
				for i=1, #v, 1 do
					if CanWork or (k == 'Cloakroom' or k == 'BossActions' and ESX.PlayerData.secondjob.grade >= 7) then
						if k == 'CollectSeeds' or k == 'TransferingSeeds' then
							if not IsPedInAnyVehicle(playerPed, false) then
								if #(pCoords - v[i].coords) < 10.0 then
									found = true
									ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
								end
							end
						elseif k == 'Garage' then
							if #(pCoords - v[i].coords) < 10.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						else
							if #(pCoords - v[i].coords) < 10.0 then
								found = true
								ESX.DrawMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						end

						if k == 'Cloakroom' or k == 'BossActions' then
							if #(pCoords - v[i].coords) < 1.5 then
								isInMarker	= true
								currentZone = k
								zoneNumber = i
							end
						elseif k == 'CollectSeeds' then
							if #(pCoords - v[i].coords) < 4.0 then
								isInMarker	= true
								currentZone = k
								zoneNumber = i
							end
						else
							if #(pCoords - v[i].coords) < 2.0 then
								isInMarker	= true
								currentZone = k
								zoneNumber = i
							end
						end
						
					end
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone				= currentZone
				TriggerEvent('exile_legalburgershot:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('exile_legalburgershot:hasExitedMarker', lastZone)
			end

			if not found then
				Wait(2000)
			end
		else
			Wait(2000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(10)
		if ESX.PlayerData.secondjob and ESX.PlayerData.secondjob.name == 'burgershot' then
			if CurrentAction ~= nil then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'collect' then
						StartCollect()
					elseif CurrentAction == 'transfering' then
						TransferingSeeds()
					elseif CurrentAction == 'boss_actions' then
						OpenBossMenu()
					elseif CurrentAction == 'garage' then
						CarOut()
					elseif CurrentAction == 'cloakroom' then
						OpenCloakroom()
					elseif CurrentAction == 'exit' then
						FreezeEntityPosition(playerPed, false)
						ClearPedTasks(playerPed)
					end
					CurrentAction = nil
				end
			end
			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and ESX.PlayerData.secondjob.grade >= 7 then
				OpenMobileburgershotActionsMenu()
			end
		else
			Wait(2000)
		end
	end
end)

CreateThread(function()
    while true do
        Wait(0)
        if blokada then
            DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 18, true) -- Attack
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
			Wait(600)
        end
    end
end)

PlayAnim = function(lib, anim, time)
	RequestAnimDict(lib)
	while not HasAnimDictLoaded(lib) do
		Wait(10)
	end
	TaskPlayAnim(playerPed, lib, anim, 3.0, 3.0, time, 1, 0, false, false, false)
end

local IsPedInAnyVehicle = IsPedInAnyVehicle
local ClearPedTasks = ClearPedTasks
local FreezeEntityPosition = FreezeEntityPosition

StartCollect = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'skladniki' then
			count = inventory[i].count
		end
	end

	if count > 0 then
		ESX.ShowNotification('Nie mo??esz zbiera?? maj??c ju?? ile?? w ekwipunku')
		ClearPedTasks(playerPed)
		FreezeEntityPosition(playerPed, false)
		blokada = false
	else
		TriggerServerEvent('exile_legalburgershot:collect', 'skladniki')
		exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Przygotowywanie...", "Praca Legalna", "grey-10", 300, true)
		ClearPedTasks(playerPed)
		FreezeEntityPosition(playerPed, true)
		blokada = true
		PlayAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 600000)
	end
end

TransferingSeeds = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'skladniki' then
			count = inventory[i].count
		end
	end

	if count >= 100 then
		blokada = true
		ESX.ShowNotification('~y~Trwa przygotowywanie Burgera...')
		FreezeEntityPosition(playerPed, true)
		PlayAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 600000)
		exports["esx_exilechat"]:showProgress("notification_important", exports["qHud"]:getAlign(), "Przygotowywanie...", "Praca Legalna", "grey-10", 60, true)
		Wait(61000)
		ClearPedTasksImmediately(playerPed)
		TriggerServerEvent(exile_legalburgershot2, count, donttouchme)
		FreezeEntityPosition(playerPed, false)
		ClearPedTasks(playerPed)
		TriggerEvent("exilerp_scripts:cooldown", -1)
	else
		ESX.ShowNotification('~r~Potrzebujesz 100 sk??adnik??w aby rozpocz???? przerabianie!')
	end
end

CarOut = function()
	if IsPedInAnyVehicle(playerPed, false) then
		local carCafe = GetVehiclePedIsIn(playerPed, false)
		if IsVehicleModel(carCafe, GetHashKey("rumpo1")) then
			ESX.Game.DeleteVehicle(carCafe)
			alreadyOut = false
		else
			ESX.ShowNotifcation('~r~Mo??esz zwr??ci?? tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(GetEntityCoords(playerPed), 7) then
			ESX.Game.SpawnVehicle('rumpo1', GetEntityCoords(playerPed), 227.04, function(vehicle)
				local platenum = math.random(10, 99)
				SetVehicleLivery(vehicle, 1)
				SetVehicleNumberPlateText(vehicle, "BURG"..platenum)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				TriggerServerEvent('exile_legalburgershot:insertPlayer', GetVehicleNumberPlateText(vehicle))
			end)
			alreadyOut = true
		else
			ESX.ShowNotification('~r~Miejsce parkingowe jest ju?? zaj??te przez inny pojazd!')
		end
	end
end

OpenCloakroom = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'Przebieralnia',
		align = 'center',
		elements = {
			{label = 'Ubrania robocze',     value = 'secondjob_wear'},
			{label = 'Ubrania prywatne', value = 'citizen_wear'}
		}
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			if data.current.value == 'citizen_wear' then
				CanWork = false
				ESX.ShowNotification('~g~Za??o??ono ubrania cywilne')
				TriggerEvent('skinchanger:loadSkin', skin)
			elseif data.current.value == 'secondjob_wear' then
				CanWork = true
				ESX.ShowNotification('~g~Za??o??ono ubrania robocze')
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Cfg.Clothes.Male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Cfg.Clothes.Female)
				end
			end
		end)

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

OpenBossMenu = function()
	local elements = {
		{label = "Akcje szefa", value = '1'},
    }
    if ESX.PlayerData.secondjob.grade >= 7 then
		table.insert(elements, {label = "Zarz??dzanie frakcj??", value = '4'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'burgershot_boss', {
		title    = "Praca Legalna",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if ESX.PlayerData.secondjob.grade_label == "Manager" then
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'burgershot', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif ESX.PlayerData.secondjob.grade >= 6 then
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'burgershot', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esxexile_societyrpexileesocietybig:openSecondBossMenu', 'burgershot', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false})
            end
        elseif data.current.value == '2' then
			menu.close()
			ESX.TriggerServerCallback('ExileRP:getCourses', function(kursy)
				if kursy then
					local elements = {
						head = {'Imi?? i nazwisko', 'Liczba kurs??w', 'Stopie??'},
						rows = {}
					}
					for i=1, #kursy, 1 do
						if kursy[i].secondjob_grade == 0 then
							grade = 'Okres Pr??bny'
						elseif kursy[i].secondjob_grade == 1 then
							grade = 'Rekrut'
						elseif kursy[i].secondjob_grade == 2 then
							grade = 'Pracownik'
						elseif kursy[i].secondjob_grade == 3 then
							grade = 'Sta??ysta'
						elseif kursy[i].secondjob_grade == 4 then
							grade = 'Zawodowiec'
						elseif kursy[i].secondjob_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].secondjob_grade == 6 then
							grade = 'Koordynator'
						elseif kursy[i].secondjob_grade == 7 then
							grade = 'Manager'
						elseif kursy[i].secondjob_grade == 8 then
							grade = 'Zast??pca'
						elseif kursy[i].secondjob_grade == 9 then
							grade = 'Szef'
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'burgershot_courses', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kurs??w jest pusta!")
				end
			end, 'burgershot')
		elseif data.current.value == '4' then
			menu.close()
			exports['exile_legaljobs']:OpenLicensesMenu(ESX.PlayerData.secondjob.name)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'boss_actions'
		CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby otworzy?? menu zarz??dzania'
		CurrentActionData = {}
	end)
end

RegisterNetEvent('exile_legalburgershot:Cancel')
AddEventHandler('exile_legalburgershot:Cancel', function()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(playerPed)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	blokada = false
end)

AddEventHandler('exile_legalburgershot:hasEnteredMarker', function(zone, number)
	ESX.UI.Menu.CloseAll()

	if zone == 'Garage' then
		if IsPedInAnyVehicle(playerPed, false) then
			CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby schowa?? pojazd'
		else
			CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby wyci??gn???? pojazd'
		end
		CurrentAction		= 'garage'
		CurrentActionData	= {}
	end
	
	if not IsPedInAnyVehicle(playerPed, false) then
		if zone == 'CollectSeeds' then
			CurrentAction		= 'collect'
			CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby zebra?? sk??adniki'
			CurrentActionData	= {}
		end

		if zone == 'Cloakroom' then
			CurrentAction		= 'cloakroom'
			CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby otworzy?? szatni??'
			CurrentActionData	= {}
		end

		if zone == 'TransferingSeeds' and not cooldown then
			CurrentAction		= 'transfering'
			CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby przerobi?? sk??adniki'
			CurrentActionData	= {}
		end
		if zone == 'BossActions' then
			CurrentAction		= 'boss_actions'
			CurrentActionMsg = 'Naci??nij ~INPUT_CONTEXT~, aby otworzy?? menu zarz??dzania'
			CurrentActionData	= {}
		end
	end
end)

AddEventHandler('exile_legalburgershot:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('exile_legalburgershot:stopPickup', zone)
	CurrentActionMsg = ''
	CurrentAction = nil
	blokada = false
end)

OpenMobileburgershotActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, GetHashKey("rumpo1")) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_legalburgershot:checkSiedzacy', function(siedzi)
				if siedzi then
					local plate =  GetVehicleNumberPlateText(vehicle)
					for i=1, #siedzi, 1 do
						if siedzi[i].plate == plate then
							table.insert(elements, {label = siedzi[i].label, value = siedzi[i].plate})	
						end
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lastdriver_'..ESX.PlayerData.secondjob.name, {
						title    = "Lista kierowc??w ["..plate..']',
						align    = 'bottom-right',
						elements = elements
					}, function(data, menu)
					end, function(data, menu)
						menu.close()
					end)
				end
			end)
		else
			ESX.ShowNotification("~r~Musisz znajdowa?? si?? w poje??dzie jako kierwoca!")
		end
	end
end
end)