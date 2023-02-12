OrganizationBlip = {}
local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local isUsing = false
local zoneName = nil
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetEntityCoords = GetEntityCoords
local GetVehiclePedIsIn = GetVehiclePedIsIn
local playerPed = PlayerPedId()
local pid = PlayerId()
local car = GetVehiclePedIsIn(playerPed, false)
local pcoords  = GetEntityCoords(playerPed)

CreateThread(function()
	while true do
		Wait(500)
		playerPed = PlayerPedId()
		pid = PlayerId()
		car = GetVehiclePedIsIn(playerPed, false)
		pcoords = GetEntityCoords(playerPed)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	refreshBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	deleteBlip()
	refreshBlip()
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob)
	ESX.PlayerData.thirdjob = thirdjob
	deleteBlip()
	refreshBlip()
end)

local jestwjakiesorg = false

CreateThread(function()
	while true do
		if ESX.PlayerData.thirdjob and string.find(ESX.PlayerData.thirdjob.name, "org") then
			jestwjakiesorg = true
		else
			jestwjakiesorg = false
		end
		Wait(1000)
	end
end)

function refreshBlip()
	if ESX.PlayerData.thirdjob ~= nil and Config.Blips[ESX.PlayerData.thirdjob.name] then
		local blip = AddBlipForCoord(Config.Blips[ESX.PlayerData.thirdjob.name])
		SetBlipSprite (blip, 310)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Dom organizacji")
		EndTextCommandSetBlipName(blip)
		table.insert(OrganizationBlip, blip)
	end
end

function deleteBlip()
	if OrganizationBlip[1] ~= nil then
		for i=1, #OrganizationBlip, 1 do
			RemoveBlip(OrganizationBlip[i])
			table.remove(OrganizationBlip, i)
		end
	end
end

AddEventHandler('exile_organisations:hasEnteredMarker', function(zone)
	if zone == 'Cloakroom' then
		CurrentAction = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_menu', ESX.PlayerData.thirdjob.label)
		CurrentActionData = {}
	elseif zone == 'FixMenu' then
		CurrentAction = 'FixMenu_ast'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby skorzystać z mechanika"
		CurrentActionData = {}
	elseif zone == 'Blachy' then
		CurrentAction = 'Blachy'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby wybić blachy w pojeździe"
		CurrentActionData = {}
	elseif zone == 'MainMenu' then
		CurrentAction = 'MainMenu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć główne menu organizacji"
		CurrentActionData = {}
	elseif zone == 'LotniaMenu' then
		CurrentAction = 'LotniaMenu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć główne menu organizacji"
		CurrentActionData = {}
	elseif zone == 'LotniaMenu2' then
		CurrentAction = 'LotniaMenu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć główne menu organizacji"
		CurrentActionData = {}
	elseif zone == 'LotniaMenu3' then
		CurrentAction = 'LotniaMenu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć główne menu organizacji"
		CurrentActionData = {}
	end
end)

AddEventHandler('exile_organisations:hasExitedMarker', function(zone)
	if isUsing then
		isUsing = false
		TriggerServerEvent('exile:setUsed', zoneName, 'society_'..ESX.PlayerData.thirdjob.name, false)
	end
	zoneName = nil
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

CreateThread(function()
	while true do
		Wait(0)
		if ESX.PlayerData.thirdjob ~= nil then
			local letSleep =  true
			if jestwjakiesorg then
				if Config.Zones[ESX.PlayerData.thirdjob.name] then
					for k,v in pairs(Config.Zones[ESX.PlayerData.thirdjob.name]) do
						if v.coords and #(pcoords - v.coords) < Config.DrawDistance then
							letSleep = false
							if k then
								ESX.DrawMarker(v.coords)
							end
						end
					end
				end
				for k,v in pairs(Config.InstanceOrgs) do
					if v.coords and #(pcoords - v.coords) < Config.DrawDistance then
						letSleep = false
						if k then
							ESX.DrawMarker(v.coords)
						end
					end
				end
				if letSleep then
					Wait(1000)
				end
			else
				Wait(5000)
			end
		else
			Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(2000)

		if ESX.PlayerData.thirdjob ~= nil then
			if jestwjakiesorg then
				local isInMarker  = false
				local currentZone = nil
				if Config.Zones[ESX.PlayerData.thirdjob.name] then
					for k,v in pairs(Config.Zones[ESX.PlayerData.thirdjob.name]) do
						if k ~= "Barabasz" then
							if v.coords and (#(pcoords - v.coords) < 1.5) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end

				for k,v in pairs(Config.InstanceOrgs) do
					if k ~= "Barabasz" then
						if v.coords and (#(pcoords - v.coords) < 1.5) then
							isInMarker  = true
							currentZone = k
						end
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('exile_organisations:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('exile_organisations:hasExitedMarker', LastZone)
				end
			else
				Wait(5000)
			end
		else
			Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(3)
		if jestwjakiesorg then
			if CurrentAction then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) and ESX.PlayerData.thirdjob and Config.Zones[ESX.PlayerData.thirdjob.name] then

					if CurrentAction == 'cloakroom' then
						OpenCloakroomMenu('society_' .. ESX.PlayerData.thirdjob.name)
					elseif CurrentAction == 'MainMenu' then
						MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
					elseif CurrentAction == 'LotniaMenu' then
						OpenInventoryMenu('society_' .. ESX.PlayerData.thirdjob.name)
					elseif CurrentAction == 'FixMenu_ast' then
						FixMenu()
					elseif CurrentAction == 'Blachy' then
						exports['ExileRP']:WybijBlachyMenu()
					end

					CurrentAction = nil
				end
			else
				Wait(500)
			end
		else
			Wait(500)
		end
	end
end)

RegisterCommand('showF7ORG', function()
	if ESX.PlayerData.thirdjob then
		if not IsPedInAnyVehicle(playerPed) and not exports['esx_policejob']:IsCuffed() and not exports['esx_ambulancejob']:isDead() then
			ESX.TriggerServerCallback('exile_organisations:getLicenses', function(licenses)
				if licenses.menuf7 == 1 and licenses.blocked ~= 1 then
					OpenActionsMenu()
				else
					ESX.ShowNotification('~r~Twoja organizacja nie ma wykupionego dostępu do menu interakcji!')
				end
			end, 'society_' .. ESX.PlayerData.thirdjob.name)
		end
	end
end)

RegisterKeyMapping('showF7ORG', 'Otwórz menu organizacji', 'keyboard', 'F7')

function FixMenu()
	if IsPedInAnyVehicle(playerPed, false) then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanik_org_git',
		{
			title    = "Mechanik",
			align    = 'center',
			elements = {
				{label = "Naprawa mechaniczna", value = 1},
				{label = "Naprawa karoseri", value = 2},
			},
		}, function(data, menu)
			local r = data.current.value
			if IsPedInAnyVehicle(playerPed, false) then
				if r == 1 then
					local vehicle = car(playerPed, false)
					if GetVehicleEngineHealth(vehicle) < 1000 then
						menu.close()
						TriggerServerEvent('__orgs:mechanik')
						for i=10,0,-1 do
							ESX.ShowHelpNotification('~y~Trwa naprawa...~s~ ' .. i .. '~b~ sekund')
							Wait(1000)
						end
						FixMenu()
						SetVehicleEngineHealth(vehicle, 1000)
						SetVehicleEngineOn(vehicle, true, true )
						ESX.ShowNotification('~g~Naprawiono pojazd')
					else
						ESX.ShowNotification('~r~Pojazd nie wymaga naprawy')
					end
				elseif r == 2 then
					menu.close()
					local vehicle = car(playerPed, false)
					local health = GetVehicleEngineHealth(vehicle)
					TriggerServerEvent('__orgs:mechanik')
					for i=10,0,-1 do
						ESX.ShowHelpNotification('~y~Trwa naprawa...~s~ ' .. i .. '~b~ sekund')
						Wait(1000)
					end
					SetVehicleFixed(vehicle)
					Wait(300)
					SetVehicleEngineHealth(vehicle, health)
					SetVehicleEngineOn(vehicle, true, true )
					FixMenu()
					ESX.ShowNotification('~g~Naprawiono pojazd')
				end
			else
				menu.close()
			end
			
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('~r~Musisz być w pojeździe')
	end
end

function BarabaszHeal()
	if not IsPedInAnyVehicle(playerPed, false) and exports["esx_ambulancejob"]:isDead() then
		if ESX.PlayerData.thirdjob ~= nil then
			TriggerEvent('esx_ambulancejob:reviveblack', nil)
			ESX.ShowNotification('~g~Uleczono')
		end
	else
		ESX.ShowNotification('~r~Aby skorzystać z pomocy medycznej musisz być ranny.')
	end
end

function OpenOpiumMenu()
	local playerCoords = pcoords
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'opium_menu',
	{
		title    = "Przeróbka kokainy - zarządzanie",
		align    = 'center',
		elements = {
			{label = "Rozdane klucze", value = 'used'},
			{label = "Przekaż klucz", value = 'give_key'},
		}
	}, function(data, menu)
		menu.close()
		if data.current.value == 'used' then
			ESX.TriggerServerCallback('exile_organisations:getOpiumPermissions', function(cb)
				if cb[1] ~= nil then
					local elements2 = {
						head = {'Imię', 'Nazwisko', 'Do kiedy', 'Akcje'},
						rows = {}
					}
					for i=1, #cb, 1 do
						table.insert(elements2.rows, {
							data = cb[i].owner,
							cols = {
								cb[i].firstname,
								cb[i].lastname,
								cb[i].endTime,
								'{{' .. "Odbierz dostęp" .. '|hire}}'
							}
						})
					end
					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'opium_list', elements2, function(data2, menu2)
						if data2.value == 'hire' then
							menu2.close()
							TriggerServerEvent('exile_organisations:removeOpiumPermission', data2.data)
							Wait(300)
							OpenOpiumMenu()
						end
					end, function(data2, menu2)
						menu2.close()
						OpenOpiumMenu()
					end)
				else
					ESX.ShowNotification("~b~Brak rozdanych kluczy do przeróbki")
				end
			end)
		elseif data.current.value == 'give_key' then
			local playersInArea = ESX.Game.GetPlayersInArea(playerCoords, 5.0)
			local elements      = {}
			for i=1, #playersInArea, 1 do
				if playersInArea[i] ~= pid then
					table.insert(elements, {label = GetPlayerServerId(playersInArea[i]), value = GetPlayerServerId(playersInArea[i])})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
			{
				title    = "Osoby w pobliżu",
				align    = 'center',
				elements = elements,
			}, function(data2, menu2)
				menu2.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
				{
					title    = "Czas",
					align    = 'center',
					elements = {
						{label = "1 dzień", value = 1},
						{label = "3 dni", value = 3},
						{label = "7 dni", value = 7}
					},
				}, function(data3, menu3)
					menu3.close()
					TriggerServerEvent('exile_organisations:opiumPermission', data2.current.value, data3.current.value)
				end, function(data3, menu3)
					menu3.close()
					OpenOpiumMenu()
				end)
			end, function(data2, menu2)
				menu2.close()
				OpenOpiumMenu()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- function OpenExctasyMenu()
-- 	local playerCoords = pcoords
-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'exctasy_menu',
-- 	{
-- 		title    = "Przeróbka ekstazy - zarządzanie",
-- 		align    = 'center',
-- 		elements = {
-- 			{label = "Rozdane klucze", value = 'used'},
-- 			{label = "Przekaż klucz", value = 'give_key'},
-- 		}
-- 	}, function(data, menu)
-- 		menu.close()
-- 		if data.current.value == 'used' then
-- 			ESX.TriggerServerCallback('exile_organisations:getExctasyPermissions', function(cb)
-- 				if cb[1] ~= nil then
-- 					local elements2 = {
-- 						head = {'Imię', 'Nazwisko', 'Do kiedy', 'Akcje'},
-- 						rows = {}
-- 					}
-- 					for i=1, #cb, 1 do
-- 						table.insert(elements2.rows, {
-- 							data = cb[i].owner,
-- 							cols = {
-- 								cb[i].firstname,
-- 								cb[i].lastname,
-- 								cb[i].endTime,
-- 								'{{' .. "Odbierz dostęp" .. '|hire}}'
-- 							}
-- 						})
-- 					end
-- 					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'exctasy_list', elements2, function(data2, menu2)
-- 						if data2.value == 'hire' then
-- 							menu2.close()
-- 							TriggerServerEvent('exile_organisations:removeExctasyPermission', data2.data)	
-- 							Wait(300)	
-- 							OpenExctasyMenu()
-- 						end
-- 					end, function(data2, menu2)
-- 						menu2.close()
-- 						OpenExctasyMenu()
-- 					end)
-- 				else
-- 					ESX.ShowNotification("~b~Brak rozdanych kluczy do przeróbki")
-- 				end
-- 			end)
-- 		elseif data.current.value == 'give_key' then
-- 			local playersInArea = ESX.Game.GetPlayersInArea(playerCoords, 5.0)
-- 			local elements      = {}
-- 			for i=1, #playersInArea, 1 do
-- 				if playersInArea[i] ~= pid then
-- 					table.insert(elements, {label = GetPlayerServerId(playersInArea[i]), value = GetPlayerServerId(playersInArea[i])})
-- 				end
-- 			end
-- 			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
-- 			{
-- 				title    = "Osoby w pobliżu",
-- 				align    = 'center',
-- 				elements = elements,
-- 			}, function(data2, menu2)
-- 				menu2.close()
-- 				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
-- 				{
-- 					title    = "Czas",
-- 					align    = 'center',
-- 					elements = {
-- 						{label = "1 dzień", value = 1},
-- 						{label = "3 dni", value = 3},
-- 						{label = "7 dni", value = 7}
-- 					},
-- 				}, function(data3, menu3)
-- 					menu3.close()
-- 					TriggerServerEvent('exile_organisations:ExctasyPermission', data2.current.value, data3.current.value)
-- 				end, function(data3, menu3)
-- 					menu3.close()
-- 					OpenExctasyMenu()
-- 				end)
-- 			end, function(data2, menu2)
-- 				menu2.close()
-- 				OpenExctasyMenu()
-- 			end)
-- 		end
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

local bagonhead = false
local enabled = false
local bag = nil
local isdead = false

function OpenActionsMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Kajdanki", value = 'handcuffs'},
		{label = "Napraw pojazd", value = 'repair'},
		{label = "Obróć pojazd", value = 'obroc'},
		{label = "Użyj wytrychu", value = 'wytrych'},
		{label = "Worek", value = 'worek'}
	}
	if ESX.PlayerData.thirdjob.name == 'org27' then
		elements = {
		{label = "Kajdanki", value = 'handcuffs'},
		{label = "Napraw pojazd", value = 'repair'},
		{label = "Obróć pojazd", value = 'obroc'},
		{label = "Użyj wytrychu", value = 'wytrych'},
		{label = "Worek", value = 'worek'},
		{label = "Abonament Opium", value = 'opiummafia'},
		-- {label = "Abonament Ekstazy", value = 'ekstazymafia'},
		}
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
	{
		title    = 'Organizacja Przestępcza',
		align    = 'center',
		elements = elements
	}, function(data, menu)			
		if (data.current.value == 'handcuffs') then
			menu.close()
			TriggerEvent('Kajdanki')
		elseif (data.current.value == 'opiummafia') then
			menu.close()
			OpenOpiumMenu()
		-- elseif (data.current.value == 'ekstazymafia') then
		-- 	menu.close()
		-- 	OpenExctasyMenu()
		elseif (data.current.value == 'repair') then
			menu.close()
			if not exports["exile_taskbar"]:isBusy() then
				TriggerServerEvent('exile:pay', 1000)
			end
			TriggerEvent('esx_mechanikjob:onFixkitFree')
		elseif (data.current.value == 'obroc') then
			menu.close()
			if not exports["exile_taskbar"]:isBusy() then
				TriggerServerEvent('exile:pay', 1000)
			end
			ObrocPojazd()
		elseif (data.current.value == 'wytrych') then
			if not exports["exile_taskbar"]:isBusy() then
				TriggerServerEvent('exile:pay', 1500)
			end
			menu.close()
			TriggerEvent('esx_mechanikjob:onHijack')
		elseif (data.current.value == 'worek') then
			menu.close()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
			{
				title    = ESX.PlayerData.thirdjob.label,
				align    = 'center',
				elements = {
					{label = "Załóż", value = 'puton'},
					{label = "Zdejmij", value = 'putoff'},
				}
			}, function(data2, menu2)
				if data2.current.value == 'puton' then
					ESX.TriggerServerCallback('org:getItemAmount', function(qtty)
						if qtty > 0 then
							local player, distance = ESX.Game.GetClosestPlayer()
							local idkurwy = GetPlayerServerId(GetPlayerIndex())
							if distance ~= -1 and distance <= 1.0 then
								if not IsPedSprinting(playerPed) and not IsPedRagdoll(playerPed) and not IsPedRunning(playerPed) then
									TriggerServerEvent('exile_baghead:setbagon', GetPlayerServerId(player), idkurwy, 'puton')
								end
							else
								ESX.ShowNotification('Brak graczy w pobliżu.')
							end
						else
							ESX.ShowNotification('~r~Nie posiadasz przy sobie worka!')
						end
					end, 'worek')
				elseif data2.current.value == 'putoff' then
					local player, distance = ESX.Game.GetClosestPlayer()
					local idkurwy = GetPlayerServerId(GetPlayerIndex())
					if distance ~= -1 and distance <= 1.0 then
						if not IsPedSprinting(playerPed) and not IsPedRagdoll(playerPed) and not IsPedRunning(playerPed) then
							TriggerServerEvent('exile_baghead:setbagon', GetPlayerServerId(player), idkurwy, 'putoff')
						end
					else
						ESX.ShowNotification('Brak graczy w pobliżu.')
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

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

RegisterNetEvent('exile_baghead:setbag')
AddEventHandler('exile_baghead:setbag', function(idkurwy, corobi)
	local _idkurwy = idkurwy
	if bagonhead and corobi == 'putoff' then
		bagonhead = false
		TriggerEvent('exile_baghead:display', false)
		TriggerServerEvent('exile_baghead:itemhuj', _idkurwy, 'give')
		TriggerServerEvent('exile_baghead:woreknaleb', _idkurwy, 0)
	elseif not bagonhead and corobi == 'puton' then
		bagonhead = true
		TriggerEvent('exile_baghead:display', true)
		TriggerServerEvent('exile_baghead:itemhuj', _idkurwy, 'remove')
		TriggerServerEvent('exile_baghead:woreknaleb', _idkurwy, 1)
	end
end)

RegisterNetEvent('exile_baghead:kurwodajitem')
AddEventHandler('exile_baghead:kurwodajitem', function(gowno)
	local co = gowno
		if co == 'give' then
			TriggerServerEvent('exile_baghead:item', 'give')
		elseif co == 'remove' then
			TriggerServerEvent('exile_baghead:item', 'remove')
		end
end)

RegisterNetEvent('exile_baghead:display')
AddEventHandler('exile_baghead:display', function(value)
	if value == true then
		SetPedComponentVariation(playerPed, 1, 69, 1, 1)
		enabled = true
	elseif value == false then
		bagonhead = false
		SetPedComponentVariation(playerPed, 1, 0, 0, 0)
		enabled = false
	end
  SendNUIMessage({
    display = enabled
  })
end)

function IsWorek()
	return bagonhead
end

CreateThread(function()
	while true do
		Wait(1500)
		if bagonhead then
			if IsPedSprinting(playerPed) and not IsPedRagdoll(playerPed) then
				local ForwardVector = GetEntityForwardVector(playerPed)
				SetPedToRagdollWithFall(playerPed, 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedJumping(playerPed) and not IsPedRagdoll(playerPed) then
				local ForwardVector = GetEntityForwardVector(playerPed)
				SetPedToRagdollWithFall(playerPed, 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedInMeleeCombat(playerPed) and not IsPedRagdoll(playerPed) then
				local ForwardVector = GetEntityForwardVector(playerPed)
				SetPedToRagdollWithFall(playerPed, 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedHurt(playerPed) and not IsPedRagdoll(playerPed) then
				local ForwardVector = GetEntityForwardVector(playerPed)
				SetPedToRagdollWithFall(playerPed, 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
		end
	end
end)

AddEventHandler('playerSpawned', function()
	bagonhead = false
	isdead = false
	DeleteEntity(bag)
	SetEntityAsNoLongerNeeded(bag)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isdead = true
	SetPedComponentVariation(playerPed, 1, 0, 0, 0)
	  SendNUIMessage({
    display = false
  })
end)

withdrawDialog = function()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_black', {
		title = 'Ile Chcesz Wypłacić?'
	}, function(data, menu)
		TriggerServerEvent('exilerp_scripts:org:withdrawMoney', data.value)
		ESX.UI.Menu.CloseAll()
	end, function(data, menu)
		menu.close()
		MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
	end)

end

depositDialog = function()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_black', {
		title = 'Ile Chcesz Wypłacić?'
	}, function(data, menu)
		TriggerServerEvent('exilerp_scripts:org:depositMoney', data.value)
		ESX.UI.Menu.CloseAll()
	end, function(data, menu)
		menu.close()
		MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
	end)

end

openManageAccount = function(par)

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'zarzadzanie',
		{
			align = 'center',
			title = 'Konto Organizacji ' .. par['org'],
			elements = {
				{label = "Stan Konta : <font style='color:red'>" .. par['black_money'] .. "$</font>", value = nil},
				{label = "Wypłać nieopodatkowane pieniądze.", value = 'withdraw'},
				{label = "Zdeponuj nieopodatkowane pieniądze.", value = 'deposit'},
			}
		}, function(data, menu)
			if(data.current.value == 'deposit') then
				depositDialog()
			elseif(data.current.value == 'withdraw') then
				if ESX.PlayerData.thirdjob.grade > 4 then
					withdrawDialog()
				else 
					ESX.ShowNotification('Nie masz dostępu do tego elementu')
				end
			end
		end,
		function(data, menu)
			menu.close()
		MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
		end
	)

end

RegisterNetEvent('exilerp_scripts:showAccountMenu', function(par)

	openManageAccount(par)

end)


function MainOrganisationsMenu(organization)
	ESX.TriggerServerCallback('exile_organisations:getLicenses', function(licenses)
		print(licenses)
		print(json.encode(licenses))
		if licenses.blocked ~= 1 then
			local elements = {
				{label = "Zarządzaj kontem nieopodatkowanym", value = 'manage'},
				{label = "Zarządzaj kontem opodatkowanym i pracownikami", value = 'managment'},
				{label = "Magazyn", value = 'storage'},
			}
			if (Config.Zones[ESX.PlayerData.thirdjob.name] and ESX.PlayerData.thirdjob.grade >= Config.Zones[ESX.PlayerData.thirdjob.name].Licenses.from) or Config.InstanceOrgs.Licenses.from then
				table.insert(elements, {label = "Wykup dostęp", value = 'licenses'})
			end
			if ESX.PlayerData.thirdjob.grade == 5 then
				table.insert(elements, {label = 'Webhooki', value = 'webhooki'})
				table.insert(elements, {label = "Sklep organizacji", value = 'sklep'})
				--table.insert(elements, {label = "Starterpack", value = 'starterpack'})
			end
			table.insert(elements, {label = "Włóż wszystko", value = 'depositall'})
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mejn',
			{
				title    = 'Organizacja Przestępcza',
				align    = 'center',
				elements = elements
			}, function(data, menu)
				if data.current.value == 'storage' then
					OpenInventoryMenu('society_' .. ESX.PlayerData.thirdjob.name)
				elseif data.current.value == 'webhooki' then
					OpenWebhookMenu()
				elseif data.current.value == 'sklep' then
					SklepMenu()
				elseif(data.current.value == 'manage') then 
					TriggerServerEvent('exilerp_scripts:manageAccount')
				--[[elseif(data.current.value == 'starterpack') then
					TriggerServerEvent('exilerp_scripts:starterpack')]]
				elseif data.current.value == 'managment' then
					OpenBossMenu(ESX.PlayerData.thirdjob.name, (Config.Zones[ESX.PlayerData.thirdjob.name] and Config.Zones[ESX.PlayerData.thirdjob.name].MainMenu.from) or Config.InstanceOrgs.MainMenu.from)
				elseif data.current.value == "licenses" then
					OpenLicensesMenu('society_' .. ESX.PlayerData.thirdjob.name)
				elseif data.current.value == 'depositall' then
					TriggerEvent('exile_organisations:putInventoryItems', 'society_' .. ESX.PlayerData.thirdjob.name)
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.ShowNotification('~o~Twoja organizacja jest zablokowana!')
		end
	end, 'society_'..ESX.PlayerData.thirdjob.name)
end

function OpenInventoryMenu(organization)
	local elements = {
		{label = "Narkotyki", value = 'narkotyki'},
		{label = "Zestawy", value = 'kits'},
		{label = "Włóż", value = 'deposit'},
		{label = "Włóż wszystko", value = 'depositall'}
	}
	if (Config.Zones[ESX.PlayerData.thirdjob.name] and ESX.PlayerData.thirdjob.grade >= Config.Zones[ESX.PlayerData.thirdjob.name].Inventory.from) or ESX.PlayerData.thirdjob.grade >= Config.InstanceOrgs.Inventory.from then
		table.insert(elements, {label = "Wyciągnij", value = 'withdraw'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Magazyn',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			TriggerEvent('exile_organisations:getInventoryItem', organization)
		elseif data.current.value == 'depositall' then
			TriggerEvent('exile_organisations:putInventoryItems', organization)
		elseif data.current.value == 'deposit' then
			TriggerEvent('exile_organisations:putInventoryItem', organization)
		elseif data.current.value == 'narkotyki' then
			OpenNarkoMenu()
		elseif data.current.value == 'kits' then
			if ESX.PlayerData.thirdjob.name ~= nil and ESX.PlayerData.thirdjob.grade > 0 then
				OpenKitsMenu(ESX.PlayerData.thirdjob.name)
			else
				ESX.ShowNotification('~r~Nie posiadasz dostępu do zestawów')
			end
		end
	end, function(data, menu)
		ESX.UI.Menu.CloseAll()
		if isUsing then
			isUsing = false
			TriggerServerEvent('exile:setUsed', 'Inventories', 'society_'..ESX.PlayerData.thirdjob.name, false)
		end
	end)
end

function OpenLicensesMenu(society)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('exile_organisations:getLicenses', function(licenses)
		local elements = {
			head = {'Poziom', 'Umowa na Szafke', 'Umowa na Szatnie Premium', 'Umowa na Sejf', 'Umowa na Menu Interakcji', 'Akcje'},
			rows = {}
		}
		local level = tostring(licenses.level)
		local available = {}
		local items = nil
		if licenses.items == 0 then
			items = '❌'
			table.insert(available, {label = "Umowa na Szafke", value = 'items', price = 500000})
		elseif licenses.items == 1 then
			items = '✔️ <br>'
		end
		local addoncloakroom = nil
		if licenses.addoncloakroom == 0 then
			addoncloakroom = '❌'
			table.insert(available, {label = "Umowa na Szatnie Premium", value = 'addoncloakroom', price = 250000})
		elseif licenses.addoncloakroom == 1 then
			addoncloakroom = '✔️ <br>'
		end
		local safe = nil
		if licenses.safe == 0 then
			safe = '❌'
			table.insert(available, {label = "Umowa na Sejf", value = 'safe', price = 500000})
		elseif licenses.safe == 1 then
			safe = '✔️ <br>'
		end
		local menuf7 = nil
		if licenses.menuf7 == 0 then
			menuf7 = '❌'
			table.insert(available, {label = "Umowa na Menu Interakcji", value = 'menuf7', price = 1000000})
		elseif licenses.menuf7 == 1 then
			menuf7 = '✔️ <br>'
		end
		table.insert(elements.rows, {
			data = tonumber(level),
			cols = {
				level .. " <br>" .. tonumber(level) * 5 .. " osób",
				items,
				addoncloakroom,
				safe,
				menuf7,
				'{{' .. "Podnieś poziom" .. '|upgrade}} {{' .. "Wykup dostęp" .. '|buy}}'
			}
		})
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'organizations', elements, function(data, menu)
			if data.value == 'upgrade' then
				if data.data >= 20 then
					ESX.ShowNotification('~r~Osiągnąłeś już maksymalny poziom organizacji')
				else
					menu.close()
					local nextLevel = data.data + 1
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'nextlevel', {
						title    = 'Czy na pewno? ',
						align    = 'center',
						elements = {
							{label = 'Nie',  value = 'no'},
							{label = 'Tak (<span style="color:yellowgreen;">500 000$</span>)',  value = 'yes'},
						}
					}, function(data2, menu2)
						if data2.current.value == 'yes' then
							menu2.close()
							TriggerServerEvent('exile_organisations:upgradeOrganization', 'level', nextLevel, society, 500000)
						else
							menu2.close()
						end
					end, function(data2, menu2)
						menu2.close()
						OpenLicensesMenu(society)
					end)
				end
			elseif data.value == 'buy' then
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrade', {
					title    = 'Co chcesz wykupić?',
					align    = 'center',
					elements = available
				}, function(data2, menu2)
					menu2.close()
					local price = ESX.Math.GroupDigits(data2.current.price)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'yesorno', {
						title = "Czy na pewno?",
						align = 'center',
						elements = {
							{label = 'Nie',  value = 'no'},
							{label = 'Tak (<span style="color:yellowgreen;">'..price..'$</span>)',  value = 'yes'},
						}
					}, function(data3, menu3)
						if data3.current.value == 'yes' then
							menu3.close()
							TriggerServerEvent('exile_organisations:upgradeOrganization', data2.current.value, 1, society, data2.current.price)
						else
							menu3.close()
						end
					end, function(data3, menu3)
						menu3.close()
						OpenLicensesMenu(society)
					end)
				end, function(data2, menu2)
					menu2.close()
					OpenLicensesMenu(society)
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenCloakroomMenu(organization)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('exile_organisations:getLicenses', function(licenses)
		if licenses.blocked ~= 1 then
			local elements = {
				{ label = 'Ubrania prywatne', value = 'player_dressing'},
				{ label = 'Sklep z ubraniami', value = 'own_dressing'},
				{ label = 'Koszulka organizacji', value = 'Koszulka'},
				{ label = 'Kamizelka organizacji', value = 'kamza'}
			}
			if licenses.addoncloakroom == 1 then
				table.insert(elements, { label = 'Przeglądaj ubrania organizacji', value = 'przegladaj_ubrania' })
				if ESX.PlayerData.thirdjob.grade >= 3 then
					table.insert(elements, {
						label = ('<span style="color:yellowgreen;">Dodaj ubranie</span>'),
						value = 'zapisz_ubranie'
					})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
			{
				title    = 'Garderoba',
				align    = 'center',
				elements = elements
			}, function(data, menu)
				if data.current.value == 'own_dressing' then
					RestrictedMenu()
				elseif data.current.value == 'przegladaj_ubrania' then
					ESX.TriggerServerCallback('exile_organisations:getPlayerDressing', function(dressing)
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
							align    = 'center',
							elements = elements
						}, function(data2, menu2)
						
							local elements2 = {
								{ label = ('Ubierz ubranie'), value = 'ubierz_sie' },
							}
							if ESX.PlayerData.thirdjob.grade >= 3 then
								table.insert(elements2, {
									label = ('<span style="color:red;"><b>Usuń ubranie</b></span>'),
									value = 'usun_ubranie' 
								})
							end
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edycja_ubran', {
							title    = ('Ubrania'),
							align    = 'center',
							elements = elements2
						}, function(data3, menu3)
								if data3.current.value == 'ubierz_sie' then
									menu3.close()
									TriggerEvent('skinchanger:getSkin', function(skin)
										ESX.TriggerServerCallback('exile_organisations:getPlayerOutfit', function(clothes)
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
										end, data2.current.value, organization)
									end)
								end
								if data3.current.value == 'usun_ubranie' then
									menu3.close()
									menu2.close()
									TriggerServerEvent('exile_organisations:removeOutfit', data2.current.value, organization)
									ESX.ShowNotification('~r~Pomyślnie usunąłeś ubiór o nazwie: ~y~' .. data2.current.label)
								end
							end, function(data3, menu3)
								menu3.close()
							end)

						end, function(data2, menu2)
							menu2.close()
						end)
					end, organization)
				end
				if data.current.value == 'player_dressing' then
					ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
						local elements2 = {}
						for k,v in pairs(dressing) do
							table.insert(elements2, {label = v, value = k})
						end

						menu.close()

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
							title    = 'Garderoba',
							align    = 'left',
							elements = elements2
						}, function(data2, menu2)
							menu2.close()
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
								title = 'Wybierz ubranie - ' .. data2.current.label,
								align = 'center',
								elements = {
									{label = 'Ubierz', value = 'wear'},
									{label = 'Zmień nazwę', value = 'rename'},
									{label = 'Usuń ubranie', value = 'remove'}
								}
							}, function(data3, menu3)
								menu3.close()
								if data3.current.value == 'wear' then
									TriggerEvent('skinchanger:getSkin', function(skin)
										ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
											TriggerEvent('skinchanger:loadClothes', skin, clothes)
											TriggerEvent('esx_skin:setLastSkin', skin)

											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_skin:save', skin)
											end)
										end, data2.current.value)
									end)

									menu2.open()
								elseif data3.current.value == 'rename' then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
										title = 'Zmień nazwę - ' .. data2.current.label
									}, function(data4, menu4)
										menu4.close()
										menu.open()
										TriggerServerEvent('esx_property:renameOutfit', data2.current.value, data4.value)
										ESX.ShowNotification('Zmieniono nazwę ubrania!')
									end, function(data4, menu4)
										menu4.close()
										menu3.open()
									end)
								elseif data3.current.value == 'remove' then
									TriggerServerEvent('esx_property:removeOutfit', data2.current.value)
									ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data2.current.label)
									menu.open()
								end
							end, function(data3, menu3)
								menu3.close()
								menu2.open()
							end)
						end, function(data2, menu2)
							menu2.close()
							menu.open()
						end)
					end)
				end
				if data.current.value == 'Koszulka' then
					for k, v in pairs(Config.Organizacje) do
						if ESX.PlayerData and (ESX.PlayerData.thirdjob and ESX.PlayerData.thirdjob.name == v.praca) then
							if v.Tshirt or v.Tshirtdrugi then
								local tshirt = {}
								if ESX.PlayerData and (ESX.PlayerData.thirdjob and ESX.PlayerData.thirdjob.name == 'org22') then
									TriggerEvent('skinchanger:getSkin', function(skin)
										if skin.sex == 0 then
											tshirt = {
												['torso_1'] = Config.MaleTshirtdrugi,
												['torso_2'] = v.Tshirt,
												['arms'] = 0,
											}
										else
											tshirt = {
												['torso_1'] = Config.FemaleTshirt,
												['torso_2'] = v.Tshirt,
												['arms'] = 0,
											}
										end
										TriggerEvent('skinchanger:loadClothes', skin, tshirt)
										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('esx_skin:save', skin)
										end)
									end)
								else
									TriggerEvent('skinchanger:getSkin', function(skin)
										if skin.sex == 0 then
											tshirt = {
												['torso_1'] = Config.MaleTshirt,
												['torso_2'] = v.Tshirt,
												['arms'] = 0,
											}
										else
											tshirt = {
												['torso_1'] = Config.FemaleTshirt,
												['torso_2'] = v.Tshirt,
												['arms'] = 0,
											}
										end
										TriggerEvent('skinchanger:loadClothes', skin, tshirt)
										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('esx_skin:save', skin)
										end)
									end)
								end
							else
								ESX.ShowNotification('~r~Twoja organizacja nie posiada koszulki organizacji')
							end
						end
					end
				end
				if data.current.value == 'kamza' then
					for k, v in pairs(Config.Organizacje) do
						if ESX.PlayerData and (ESX.PlayerData.thirdjob and ESX.PlayerData.thirdjob.name == v.praca) then
							if v.Vest then
								local vest = {}
								TriggerEvent('skinchanger:getSkin', function(skin)
									if skin.sex == 0 then
										vest = {
											['tshirt_1'] = Config.MaleVest,
											['tshirt_2'] = v.Vest,
											['arms'] = 0,
										}
									else
										vest = {
											['tshirt_1'] = Config.FemaleVest,
											['tshirt_2'] = v.Vest,
											['arms'] = 0,
										}
									end
									TriggerEvent('skinchanger:loadClothes', skin, vest)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end)
							else
								ESX.ShowNotification('~r~Twoja organizacja nie posiada kamizelki organizacji')
							end
						end
					end
				end
				if data.current.value == 'skin_menu' then
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
				if data.current.value == 'zapisz_ubranie' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nazwa_ubioru', {
						title = ('Nazwa ubioru')
					}, function(data2, menu2)
						ESX.UI.Menu.CloseAll()

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('exile_organisations:saveOutfit', data2.value, skin, organization)
							ESX.ShowNotification('~g~Pomyślnie zapisano ubiór o nazwie: ~y~' .. data2.value)
						end)

					end, function(data2, menu2)
						menu2.close()

					end)
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.ShowNotification('~o~Twoja organizacja jest zablokowana!')
		end
	end, organization)
end

function OpenBossMenu(organization, grade)
	ESX.TriggerServerCallback('exile_organisations:getLicenses', function(licenses)
		if licenses.safe == 1 then
			if ESX.PlayerData.thirdjob.grade >= grade then
				TriggerEvent('esxexile_societyrpexileesocietybig:openThirdBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
			else
				TriggerEvent('esxexile_societyrpexileesocietybig:openThirdBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
			end
		else
			ESX.ShowNotification('~y~Aby wpłacać lub wypłacać pieniądze z sejfu, pierw musisz go wykupić!')
			if ESX.PlayerData.thirdjob.grade >= grade then
				TriggerEvent('esxexile_societyrpexileesocietybig:openThirdBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			else
				TriggerEvent('esxexile_societyrpexileesocietybig:openThirdBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = false })
			end
		end
	end, 'society_' .. organization)
end

CreateThread(function()
	while ESX.PlayerData.thirdjob == nil do
		Wait(500)
	end
	while true do
		Wait(30)
		if car then
			if ESX.PlayerData ~= nil and (Config.DriveByList[ESX.PlayerData.thirdjob.name] and GetEntitySpeed(car) * 3.6 < 75) then
				SetPlayerCanDoDriveBy(pid, true)
			else
				local AktualnaBron = GetSelectedPedWeapon(playerPed)
				if AktualnaBron == `WEAPON_STUNGUN` and GetEntitySpeed(car) * 3.6 < 30 or AktualnaBron == `WEAPON_UNARMED` then
					SetPlayerCanDoDriveBy(pid, true)
				else
					SetPlayerCanDoDriveBy(pid, false)
				end
			end
		else
			Wait(500)
		end
	end
end)

local currentSkin 			  = nil
function cleanPlayerskin()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function RestrictedMenu()
	ESX.UI.Menu.CloseAll()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'right',
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
									align = 'right',
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
				ESX.UI.Menu.CloseAll()
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

function OpenClothes()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for k,v in pairs(dressing) do
			table.insert(elements, {label = v, value = k})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
			title    = 'Garderoba',
			align    = 'left',
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

local ExileBlips = {
	{
		coords = {282.43, 6789.19, 15.69},
        sprite = 197,
        display = 4,
        scale = 0.7,
        color = 59,
        shortrange = true,
        name = "Czarny Medyk",
        exileBlip = false,
        exileBlipId = ""
    },
	{
		coords = {-2080.34, 2609.13, 3.08},
        sprite = 197,
        display = 4,
        scale = 0.7,
        color = 59,
        shortrange = true,
        name = "Czarny Medyk",
        exileBlip = false,
        exileBlipId = ""
    },
	{
		coords = {2527.42, 2586.28, 37.94},
        sprite = 197,
        display = 4,
        scale = 0.7,
        color = 59,
        shortrange = true,
        name = "Czarny Medyk",
        exileBlip = false,
        exileBlipId = ""
    },
	{
		coords = {858.68, -3203.42, 5.99},
        sprite = 197,
        display = 4,
        scale = 0.7,
        color = 59,
        shortrange = true,
        name = "Czarny Medyk",
        exileBlip = false,
        exileBlipId = ""
    },
	{
		coords = {1740.7823486328, 3306.7355957031, 41.223526000977},
        sprite = 197,
        display = 4,
        scale = 0.7,
        color = 59,
        shortrange = true,
        name = "Czarny Medyk",
        exileBlip = false,
        exileBlipId = ""
    },
}

CreateThread(function()
	for i,v in ipairs(ExileBlips) do
		local blip = AddBlipForCoord(v.coords[1], v.coords[2], v.coords[3])

		SetBlipSprite (blip, v.sprite)
		SetBlipDisplay(blip, v.display)
		SetBlipScale  (blip, v.scale)
		SetBlipColour (blip, v.color)
		SetBlipAsShortRange(blip, v.shortrange)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.name)
		EndTextCommandSetBlipName(blip)
	end	
end)

local coords = {
	vector3(282.43, 6789.19, 15.69-0.95),
	vector3(-2080.34, 2609.13, 3.08-0.95),
	vector3(2527.42, 2586.28, 37.94-0.95),
	vector3(858.68, -3203.42, 5.99-0.95),
	vector3(1740.7836914063, 3306.8322753906, 41.223526000977),
}

function CheckCoords()
	for k, v in pairs(coords) do
		if #(v - pcoords) < 2.0 then
			ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby skorzystać z usług lokalnego medyka')
			DrawMarker(32, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 54, 227, 175, 175, false, true, 2, true, false, false, false)
			return true
		end
	end
	return false
end

CreateThread(function()
	while true do
		Wait(0)
		if CheckCoords() then
			if IsControlJustPressed(0, 51) or IsDisabledControlJustPressed(0, 51) then
				BarabaszHeal()
			end
		else
			Wait(500)
		end
	end
end)

local coordsPD = {
	vector3(468.22, -1029.37, 28.25-0.95), -- missionrow
	vector3(-451.36, 5985.33, 31.29-0.95), -- plaeto
	vector3(-1777.85, 3066.79, 32.81-0.95), -- baza
	vector3(-35.36, -2551.98, 6.06-0.95), -- wodna
	vector3(1815.17, 3677.82, 33.02), -- sandy
	vector3(-1082.28, -864.61, 5.04-0.95), -- vespucci
	vector3(373.89, -1628.3, 29.29-0.95), -- davis 
	vector3(526.1, -26.3, 70.63-0.95), -- vinewood
}

function CheckCoordsPD()
	for k, v in pairs(coordsPD) do
		if #(v - pcoords) < 1.5 then
			ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby skorzystać z usług lokalnego medyka')
			ESX.DrawMarker(v)
			return true
		end
	end
	return false
end

CreateThread(function()
	while true do
		Wait(0)
		if CheckCoordsPD() then
			if IsControlJustPressed(0, 51) or IsDisabledControlJustPressed(0, 51) then
				if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' then
					BarabaszHeal()
				else
					ESX.ShowNotification('Nie posiadasz dostępu!')
				end
			end
		else
			Wait(500)
		end
	end
end)

function OpenKitsMenu()
	local elements = {}
	if ESX.PlayerData.thirdjob.name ~= nil and (ESX.PlayerData.thirdjob.grade_name == "szef" or ESX.PlayerData.thirdjob.grade >= 5) then
		table.insert(elements, {label = 'Stwórz zestaw (twój ekwipunek)', value = 'createkit'})
	end
	table.insert(elements, {label = 'Zestawy', value = 'kits'})
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_kits', {
		title    = 'Zestawy',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'createkit' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_kits_name', {
				title = 'Nazwa zestawu'
			}, function(data2, menu2)
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('exilerpKits:createkit', data2.value)
				OpenKitsMenu(ESX.PlayerData.thirdjob.name)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'kits' then
			TriggerServerEvent('exilerpKits:requestkits')
		end
	end, function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	end)
end

RegisterNetEvent('exilerpKits:sendrequestedkits', function(organization, result)
	local elements = {}
	for k, v in pairs(result) do
		table.insert(elements, {label = v.name, value = v.id})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_saved_kits', {
		title    = 'Zestawy',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local options = {
			{label = 'Wybierz zestaw', value = 'choose'},
			{label = 'Daj zestaw', value = 'give'},
		}
		if ESX.PlayerData.thirdjob.name ~= nil and (ESX.PlayerData.thirdjob.grade_name == "szef" or ESX.PlayerData.thirdjob.grade >= 5) then
			table.insert(options, {label = '<span style="color:red;"><b>Usuń zestaw</b></span>', value = 'delete'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_saved_kits2', {
			title    = 'Zestaw: '..data.current.label,
			align    = 'center',
			elements = options
		}, function(data2, menu2)
			menu2.close()
			if data2.current.value == 'choose' then
				TriggerServerEvent('exilerpKits:equipkit', data.current.value, data.current.label)
			elseif data2.current.value == 'delete' then
				TriggerServerEvent('exilerpKits:deletekit', data.current.value, data.current.label)
				OpenKitsMenu(ESX.PlayerData.thirdjob.name)
			elseif data2.current.value == 'give' then
				local players = ESX.Game.GetPlayersInArea(pcoords, 10.0)
				local serverIds = {}
				for i = 1, #players, 1 do
					if players[i] ~= pid then
						table.insert(serverIds, {label = 'ID: '..GetPlayerServerId(players[i]), value = GetPlayerServerId(players[i])})
					end
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_givekit', {
					title    = 'Wybierz gracza',
					align    = 'center',
					elements = serverIds
				}, function(data3, menu3)
					TriggerServerEvent('exilerpKits:givekit', data3.current.value, data.current.value, data.current.label)
					OpenKitsMenu(ESX.PlayerData.thirdjob.name)
				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
		MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
	end)
end)

OpenNarkoMenu = function()
	local src = source
	TriggerEvent('falszywyy_barylki:mieszaczmenu', src)
end

OpenWebhookMenu = function ()
	local src = source
	local elements = {
		{label = 'Sprawdź webhook', value = 'webhookcheck'},
		{label = 'Ustaw webhook', value = 'webhookadd'},
		{label = 'Zresetuj webhook', value = 'webhookreset'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_webhook', {
		title    = 'Webhook',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'webhookcheck' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('exile_organisations:webhookcheck')
		elseif data.current.value == 'webhookadd' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_webhook_name', {
				title = 'Link twojego webhooka'
			}, function(data2, menu2)
				if(string.find(data2.value, "https://discord.com/api/webhooks/")) then
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('exile_organisations:webhookadd', data2.value)
					ESX.ShowAdvancedNotification('~o~ExileRP', 'Organizacje', '~b~Webhook został pomyślnie ustawiony!')
				else
					ESX.ShowAdvancedNotification('~o~ExileRP', 'Organizacje', '~b~Webhook nie został ustawiony, wprowadź prawidłowe dane!')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'webhookreset' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('exile_organisations:webhookreset')
			ESX.ShowAdvancedNotification('~o~ExileRP', 'Organizacje', '~b~Webhook został pomyślnie zresetowany!')
		end
	end, function(data, menu)
		menu.close()
		MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
	end)
end

SklepMenu = function ()
	local src = source
	local elements = {
		{label = 'Magazynek do pistoletu (500$)', value = 'clip', howmany = 1, price = 500},
		{label = 'X-Gamer x100 (100.000$)', value = 'kawa', howmany = 100, price = 100000},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_webhook', {
		title    = 'Sklep organizacji',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'clip' or data.current.value == 'kawa' then
			TriggerServerEvent('exile_organisations:shop', data.current.value, data.current.howmany, data.current.price)
			SklepMenu()
		end
	end, function(data, menu)
		menu.close()
		MainOrganisationsMenu(ESX.PlayerData.thirdjob.name)
	end)
end

RegisterNetEvent('exile_organisations:getInventoryItem')
AddEventHandler('exile_organisations:getInventoryItem',function(society)

	ESX.TriggerServerCallback('exile:getStockItems', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = 'Brudne pieniądze: <span style="color: red;"> ' .. ESX.Math.GroupDigits(inventory.blackMoney) .. '$</span>',
				type = 'item_account',
				value = 'black_money'
			})
		end

		local weapons = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				if type(item.label) == 'table' and item.label.label then
					item.label = item.label.label
					item.type = 'weapon'
				end

				if item.type == 'weapon' then
					if not weapons[item.label] then
						weapons[item.label] = {
							label = item.label,
							list = {}
						}
					end

					table.insert(weapons[item.label].list, item.name)
				else
					table.insert(elements, {
						label = (item.count > 1 and 'x' .. item.count .. ' ' or '') .. item.label,
						type = 'item_standard',
						value = item.name
					})
				end
			end
		end

		for weaponLabel, weaponData in pairs(weapons) do
			if #weaponData.list > 0 then
				if #weaponData.list > 1 then
					if not IsSubMenuInElements(elements, weaponLabel) then
						table.insert(elements, {
							label = ('>> %s x%i <<'):format(weaponLabel, #weaponData.list),
							type = 'sub',

							value = weaponData
						})
					end
				else
					table.insert(elements, {
						label = weaponLabel,
						type = 'item_standard',
						value = weaponData.list[1]
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = "Magazyn",
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			if data.current.type == 'sub' then
				OpenSubGetInventoryItem(data.current.value, society)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = "Ilość",
				}, function(data2, menu2)
					local count = tonumber(data2.value)
	
					if count == nil then
						ESX.ShowNotification("~r~Nieprawidłowa wartość!")
					else
						menu2.close()
						menu.close()
	
						TriggerServerEvent('exile_organisations:getStockItem', data.current.type, data.current.value, count, society)
						ESX.SetTimeout(300, function()
							TriggerEvent('exile_organisations:getInventoryItem', society)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end)

RegisterNetEvent('exile_organisations:putInventoryItems')
AddEventHandler('exile_organisations:putInventoryItems', function(society)

	ESX.TriggerServerCallback('exile:getPlayerInventory', function(inventory)

		if inventory.blackMoney > 0 then
			local type = "item_money"
			local name = "black_money"
			local count = inventory.blackMoney
			TriggerServerEvent('exile_organisations:putItemInStock', type, name, count, society)
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				if not (item.type == 'sim') then
					local type = "item_standard"
					local name = item.name
					local count = item.count
					TriggerServerEvent('exile_organisations:putItemInStock', type, name, count, society)
				end
			end
		end
	end)
end)

RegisterNetEvent('exile_organisations:putInventoryItem')
AddEventHandler('exile_organisations:putInventoryItem', function(society)

	ESX.TriggerServerCallback('exile:getPlayerInventory', function(inventory)
		local elements = {}
		
		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = 'Brudne pieniądze: <span style="color: red;"> ' .. ESX.Math.GroupDigits(inventory.blackMoney) .. '$</span>',
				type  = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = (item.count > 1 and 'x' .. item.count .. ' ' or '') .. item.label,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = "Ekwipunek",
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			local itemType = data.current.type
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = "Ilość"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification("~r~Nieprawidłowa wartość!")
				else
					menu2.close()
					menu.close()

					TriggerServerEvent('exile_organisations:putItemInStock', itemType, itemName, count, society)
					ESX.SetTimeout(300, function()
						TriggerEvent('exile_organisations:putInventoryItem', society)
					end)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end)

function IsSubMenuInElements(elements, name)
	for i=1, #elements do
		if elements[i].type == 'sub' and elements[i].value == name then
			return true
		end
	end

	return false
end

function OpenSubGetInventoryItem(data, society)
	local elements = {}

	for i=1, #data.list do
		table.insert(elements, {
			label = data.label,
			type = 'item_standard',
			value = data.list[i]
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu_sub', {
		title    = ("Magazyn (%s)"):format(data.label),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_sub_get_item_count', {
			title = "Ilość",
		}, function(data2, menu2)
			local count = tonumber(data2.value)

			if count == nil then
				ESX.ShowNotification("~r~Nieprawidłowa wartość!")
			else
				menu2.close()
				menu.close()

				TriggerServerEvent('exile_organisations:getStockItem', data.current.type, data.current.value, count, society)
				ESX.SetTimeout(300, function()
					TriggerEvent('exile_organisations:getInventoryItem', society)
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end