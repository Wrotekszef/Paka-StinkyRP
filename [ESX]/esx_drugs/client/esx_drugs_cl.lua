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

local cokeQTE       			= 0
local coke_poochQTE 			= 0
local cokePericoQTE       			= 0
local cokePerico_poochQTE 			= 0
local weedQTE					= 0
local weed_poochQTE 			= 0
local methQTE					= 0
local meth_poochQTE 			= 0
local opiumQTE					= 0
local opium_poochQTE 			= 0
local oghaze_poochQTE 			= 0
local milkjuiceQTE 				= 0
local mdp2pQTE = 0
local exctasyQTE = 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local blokada = false
local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local playerPed = PlayerPedId()
local coords = GetEntityCoords(playerPed)
CreateThread(function()
	while true do
		Wait(200)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
end)

AddEventHandler('exile_drugs:enteredMarker', function(zone)
	if myJob == 'police' or myJob == 'ambulance' or myJob == 'offpolice' or myJob == 'offambulance' then
		return
	end

	if zone == 'CokeField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		if cokeQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać narkotyk'
			CurrentActionData = {}
		end
	end

	if zone == 'CokePericoField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end

	if zone == 'CokePericoProcessing' then
		if cokePericoQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać narkotyk'
			CurrentActionData = {}
		end
	end

	if zone == 'MethField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		if methQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać narkotyk'
			CurrentActionData = {}
		end
	end

	if zone == 'WeedField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		if weedQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać narkotyk'
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		if opiumQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać narkotyk'
			CurrentActionData = {}
		end
	end

	if zone == 'OgHazeProcessing' then
		if weedQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać marihuane na OG Haze'
			CurrentActionData = {}
		end
	end

	if zone == 'MilkjuiceField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end
	
	if zone == 'ExctasyField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać narkotyk'
		CurrentActionData = {}
	end

	if zone == 'ExctasyProcessing' then
		if mdp2pQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przerabiać narkotyk'
			CurrentActionData = {}
		end
	end

end)

-- Render markers
CreateThread(function()
	while Config.Zones == nil do
		Wait(500)
	end

	while true do
		Wait(2)
		sleep = true
		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.x, v.y, v.z)) < Config.DrawDistance then
				ESX.DrawBigMarker(vec3(v.x, v.y, v.z))
				sleep = false
			
			end
		end
		if sleep then
			Wait(2000)
		end
	end
end)

-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('exile_drugs:returnInventory')
AddEventHandler('exile_drugs:returnInventory', function(count, itemName, itemRequired, jobName, currentZone)
	if itemName == 'coke' then
		cokeQTE	   	  = count
	elseif itemName == 'coke_pooch' then
		cokeQTE = itemRequired
		coke_poochQTE = count
	elseif itemName == 'cokeperico' then
		cokePericoQTE = count
	elseif itemName == 'cokeperico_pooch' then
		cokePericoQTE = itemRequired
		cokePerico_poochQTE = count
	elseif itemName == 'meth' then
		methQTE = count
	elseif itemName == 'meth_pooch' then
		methQTE = itemRequired
		meth_poochQTE = count
	elseif itemName == 'weed' then
		weedQTE = count
	elseif itemName == 'weed_pooch' then
		weedQTE = itemRequired
		weed_poochQTE = count
	elseif itemName == 'opium' then
		opiumQTE = count
	elseif itemName == 'opium_pooch' then
		opiumQTE = itemRequired
		opium_poochQTE = count
	elseif itemName == 'oghaze_pooch' then
		weedQTE = itemRequired
		oghaze_poochQTE = count
	elseif itemName == 'milkjuice' then
		milkjuiceQTE = count
	elseif itemName == 'mdp2p' then
		mdp2pQTE = count
	elseif itemName == 'exctasy_pooch' then
		mdp2pQTE = itemRequired
		exctasyQTE = count
	end
	
	myJob		 = jobName
	TriggerEvent('exile_drugs:enteredMarker', currentZone)
end)

-- Activate menu when player is inside marker
local isInMarker  = false

CreateThread(function()
	while Config.Zones == nil do
		Wait(500)
	end
	
	while true do
		local currentZone = nil
		local sleep = 500
		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.x, v.y, v.z)) < 5 and not exports['esx_policejob']:IsCuffed() and not exports['exile_trunk']:checkInTrunk() then
				isInMarker  = true
				currentZone = k
			else
				hasAlreadyEnteredMarker = false
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			sleep = 1000
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('exile_drugs:getInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('exile_drugs:exitedMarker')
		end
		Wait(sleep)
	end
end)

-- Key Controls
local mozeprzerwac = false
CreateThread(function()
	local sleep = 500
	while true do
		if CurrentAction ~= nil then
			local stop = true
			for k,v in pairs(Config.Zones) do
				if #(coords - vec3(v.x, v.y, v.z)) < Config.ZoneSize.x then
					stop = false
					break
				end
			end
			if not stop and not mozeprzerwac and not blokada then
				sleep = 0
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(ExilePlayers)
						if ExilePlayers then
							isInZone = true
							if CurrentAction == 'CokeField' then
								Zbierz('coke')
							elseif CurrentAction == 'CokeProcessing' then
								Przerob('coke', 'coke')
							elseif CurrentAction == 'CokePericoField' then
								Zbierz('cokeperico')
							elseif CurrentAction == 'CokePericoProcessing' then
								Przerob('cokeperico', 'cokeperico')
							elseif CurrentAction == 'MethField' then
								Zbierz('meth')
							elseif CurrentAction == 'MethProcessing' then
								Przerob('meth', 'meth')
							elseif CurrentAction == 'WeedField' then
								Zbierz('weed')
							elseif CurrentAction == 'WeedProcessing' then
								Przerob('weed', 'weed')
							elseif CurrentAction == 'OpiumField' then
								Zbierz('opium')
							elseif CurrentAction == 'OgHazeProcessing' then
								Przerob('weed', 'oghaze')
							elseif CurrentAction == 'MilkjuiceField' then
								Zbierz('milkjuice')
							elseif CurrentAction == 'ExctasyField' then
								Zbierz('mdp2p')
							elseif CurrentAction == 'ExctasyProcessing' then
								Przerob('mdp2p', 'exctasy')
							elseif CurrentAction == 'OpiumProcessing' then
								ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
									if hasWeaponLicense then
										Przerob('opium', 'opium')
									else
										ESX.ShowNotification("~r~Nie posiadasz licencji na przeróbke opium")
									end
								end, GetPlayerServerId(PlayerId()), 'opium_transform')
							else
								isInZone = false
							end						
						end
						
						CurrentAction = nil
					end)
				end	
			else
				TriggerEvent('exile_drugs:exitedMarker')
			end
		else
			sleep = 500
		end
		Wait(sleep)
	end
end)
function Zbierz(narkos)
	if mozeprzerwac == false then
		mozeprzerwac = true
		CreateThread(function()
			ESX.ShowNotification("~y~Zbieranie w trakcie...")
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(PlayerPedId(), true)
			repeat
				Wait(20000)
				SetTimeout(20000, function()
					if isInMarker and mozeprzerwac then
						TriggerServerEvent(GetCurrentResourceName() .. ':zbierajnarkos', narkos)
					end
				end)
			until mozeprzerwac == false and isInZone == false
		end)
	end
end

function Przerob(narkos, narkos2)
	if mozeprzerwac == false then
		CreateThread(function()
			ESX.ShowNotification("~y~Przerabianie w trakcie...")
			ESX.UI.Menu.CloseAll()
			mozeprzerwac = true

			FreezeEntityPosition(PlayerPedId(), true)
			repeat
				Wait(10000)
				SetTimeout(10000, function()
					if isInMarker and mozeprzerwac then
						TriggerServerEvent(GetCurrentResourceName() .. ':przerabiajkolego', narkos, narkos2)
					end
				end)
			until mozeprzerwac == false and isInZone == false
		end)
	end
end

CreateThread(function()
	while true do
		Wait(0)
		if mozeprzerwac then
			ESX.ShowHelpNotification('Naciśnij ~INPUT_REPLAY_TIMELINE_PICKUP_CLIP~ aby przerwać ~y~czynność~s~')
			if IsControlJustReleased(0, Keys['X']) then
				ESX.ShowNotification('~r~Przerwałeś czynność!')
				Wait(2000)
				mozeprzerwac = false
				FreezeEntityPosition(PlayerPedId(), false)
				TriggerEvent('exile_drugs:exitedMarker')
			end
		else
			Wait(1000)
		end
	end
end)


RegisterNetEvent('esx_drugs:cigarette')
AddEventHandler('esx_drugs:cigarette', function()
	local playerPed = PlayerPedId()
	
	CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)
	end)
end)

AddEventHandler('exile_drugs:exitedMarker', function()
	HasAlreadyEnteredMarker   = false
	LastZone                  = nil
	isInZone                  = false
	isInMarker 				  = false
	CurrentAction             = nil
	CurrentActionMsg          = ''
	CurrentActionData         = {}
	TriggerServerEvent('esx_drugs:stopDrugs')
	blokada = true
	Wait(21000)
	blokada = false
end)