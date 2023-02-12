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

local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ShopOpen = false
local Weapons = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob)
	ESX.PlayerData.thirdjob = thirdjob
end)


function OpenShopMenu(zone)
	local CoinsShop = false
	local elements = {}
	local buyAmmo = {}
	ShopOpen = true
	local playerPed = PlayerPedId()

	if Config.Zones[CurrentActionData.zone].Coins then
		CoinsShop = true
	else
		CoinsShop = false
	end

	for k,v in ipairs(Config.Zones[zone].Items) do
		local label

		if v.item then
			if CoinsShop then
				if v.price > 0 then
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, 'StinkyCoins', ESX.Math.GroupDigits(v.price))
				else
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, 'StinkyCoins', ESX.Math.GroupDigits(v.price))
				end		
			else
				if v.price > 0 then
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, _U('gunshop_item', ESX.Math.GroupDigits(v.price)))
				else
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, _U('gunshop_free'))
				end		
			end

			table.insert(elements, {
				label = label,
				weaponLabel = v.label,
				name = v.weapon,
				price = v.price,
				ammoNumber = v.AmmoToGive,
				item = v.item
			})
		else
			if CoinsShop then
				if v.price > 0 then
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, 'StinkyCoins '.. v.price)
				else
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, 'Za darmo')
				end		
			else
				if v.price > 0 then
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, _U('gunshop_item', ESX.Math.GroupDigits(v.price)))
				else
					label = ('%s: <span style="color:green;">%s</span>'):format(v.label, _U('gunshop_free'))
				end		
			end
			
			table.insert(elements, {
				label = label,
				weaponLabel = v.label,
				name = v.weapon,
				price = v.price,
				ammoNumber = v.AmmoToGive,
				item = v.item
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gunshop_buy_weapons', {
		title    = 'Sklep',
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.item then			
			ESX.TriggerServerCallback('esx_newweaponshop:buyWeapon', function(bought)
				if bought then					
					PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, data.current.name, 2, zone)
		else
			ESX.TriggerServerCallback('esx_newweaponshop:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification('Zakupiłeś broń!')
					end
					PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, data.current.name, 1, zone)
		end

	end, function(data, menu)
		ShopOpen = false
		menu.close()
	end)

end

AddEventHandler('esx_newweaponshop:hasEnteredMarker', function(zone)
	if zone == "mafia" and ESX.PlayerData.thirdjob.name ~= nil and ESX.PlayerData.thirdjob.name == "org27" then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć sklep'
		CurrentActionData = { zone = zone }
	end
	if zone == 'GunShop' or zone == 'Ballas' then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć sklep'
		CurrentActionData = { zone = zone }
	end
	if zone == 'GunShopDS' or zone == 'GunShopLosSantos' or zone == 'stinkycoin' then
		CurrentAction     = 'shop_menu2'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć sklep'
		CurrentActionData = { zone = zone }
	end
end)

AddEventHandler('esx_newweaponshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if ShopOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

-- Create Blips
CreateThread(function()
	for k,v in pairs(Config.Zones) do
		if v.Legal then
			for i = 1, #v.Locations, 1 do
				local blip = AddBlipForCoord(v.Locations[i])

				SetBlipSprite (blip, 110)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.7)
				SetBlipColour (blip, 2)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(_U('map_blip'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Display markers
CreateThread(function()
	while true do
		Wait(0)

		local coords, sleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Locations, 1 do
				if (not v.job) or (v.job and ESX.PlayerData.thirdjob.name ~= nil and ESX.PlayerData.thirdjob.name == "org27") then 
					if (Config.Type ~= -1 and #(coords - v.Locations[i]) < Config.DrawDistance) then
						sleep = false					
						ESX.DrawMarker(vec3(v.Locations[i].x, v.Locations[i].y, v.Locations[i].z + 0.1))
					end
				end
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
		Wait(60)
		local coords, sleep = GetEntityCoords(PlayerPedId()), true
		local isInMarker, currentZone = false, nil

		for k,v in pairs(Config.Zones) do
			for i=1, #v.Locations, 1 do
			
				if #(coords - v.Locations[i]) < Config.Size.x then
					sleep = false
					isInMarker, ShopItems, currentZone, LastZone = true, v.Items, k, k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_newweaponshop:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_newweaponshop:hasExitedMarker', LastZone)
		end

		if sleep then
			Wait(500)
		end
	end
end)


-- Key Controls
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'shop_menu' then
					if Config.LicenseEnable and Config.Zones[CurrentActionData.zone].Legal then
						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
							if hasWeaponLicense then
								OpenShopMenu(CurrentActionData.zone)
							else
								ESX.ShowNotification("~r~Licencje wydaje SASP")
							end
						end, GetPlayerServerId(PlayerId()), 'weapon')
					else
						OpenShopMenu(CurrentActionData.zone)
					end
				end

				if CurrentAction == 'shop_menu2' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil
			end
		else
			Wait(500)
		end
	end
end)


function ReachedMaxAmmo(weaponName)

	local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponName)
	local _,maxAmmo = GetMaxAmmo(PlayerPedId(), weaponName)

	if ammo ~= maxAmmo then
		return false
	else
		return true
	end

end

function IsWeapon(name) 
	local is = false
	for weaponHash,v in pairs(Weapons) do
		if v.item == name then
			is = true
			break
		end
	end
	return is
end