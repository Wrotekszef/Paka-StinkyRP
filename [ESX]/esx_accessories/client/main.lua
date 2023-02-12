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

AddEventHandler('skinchanger:modelLoaded', function()
	TriggerEvent('esx_ciuchy:wear')
end)

RegisterNetEvent('esx_ciuchy:wear')
AddEventHandler('esx_ciuchy:wear', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin then
			TriggerServerEvent('falszywyy_clothes:addClothes', 
				false,
				skin['bags_1'], 
				skin['bags_2'], 
				skin['tshirt_1'], 
				skin['tshirt_2'], 
				skin['torso_1'], 
				skin['torso_2'], 
				skin['pants_1'], 
				skin['pants_2'], 
				skin['shoes_1'], 
				skin['shoes_2'], 
				skin['arms'], 
				skin['arms_2'], 
				skin['watches_1'], 
				skin['watches_2'], 
				skin['bracelets_1'], 
				skin['bracelets_2'], 
				skin['chain_1'],
				skin['chain_2'],
				skin['mask_1'],
				skin['mask_2'],
				skin['decals_1'],
				skin['decals_2'],
				skin['helmet_1'],
				skin['helmet_2'],
				skin['glasses_1'],
				skin['glasses_2'],
				skin['bproof_1'],
				skin['bproof_2'],
				skin['face'],
				skin['hair_1']
			)
		end
	end)
end)

RegisterNetEvent('falszywyy_clothes:PutOff')
AddEventHandler('falszywyy_clothes:PutOff', function(what)
	MenuUbran(what)
end)

function MenuUbran(action)
	local playerPed = PlayerPedId()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin then
			if action == 'chain' then
				if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
					TaskPlayAnim(playerPed, "clothingtie", "try_tie_positive_a", 8.0, -8.0, -1, 48, 0, false, false, false)
				end
				
				Wait(3000)
				StopAnimTask(playerPed, "clothingtie", "try_tie_positive_a", 1.0)
				
				if 0 == skin.chain_1 then
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['chain_1'] = value.chain_1,
								['chain_2'] = value.chain_2
							})						
						end
					end)
				else
					TriggerServerEvent('falszywyy_clothes:saveClothes', {['chain_1'] = skin.chain_1, ['chain_2'] = skin.chain_2})
					TriggerEvent('skinchanger:loadClothes', skin, {
						['chain_1'] = 0,
						['chain_2'] = 0
					})
				end
			elseif action == 'mask' then
				if 0 == skin.mask_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "mp_masks@on_foot", "put_on_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Wait(2000)
					StopAnimTask(playerPed, "mp_masks@on_foot", "put_on_mask", 1.0)
					
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['mask_1'] = value.mask_1,
								['mask_2'] = value.mask_2
							})						
						end
					end)
				else
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "missfbi4", "takeoff_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Wait(2000)
					StopAnimTask(playerPed, "missfbi4", "takeoff_mask", 1.0)

					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						TriggerServerEvent('falszywyy_clothes:saveClothes', {['mask_1'] = skin.mask_1, ['mask_2'] = skin.mask_2})
						
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['mask_1'] = 0,
								['mask_2'] = 0
							}, function()
								SetPedHeadBlendData(playerPed, value.face_1, skin['face_2'], skin['face_3'], skin['skin'], skin['skin_2'], skin['skin_3'], skin['blend_face'] / 10, skin['blend_skin'] / 10, skin['blend'] / 10, true)
							end)							
						else
							TriggerEvent('skinchanger:loadClothes', skin, {
								['mask_1'] = 0,
								['mask_2'] = 0
							})							
						end
					end)
				end
		  elseif action == 'hat' then
				if -1 == skin.helmet_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "missheistdockssetup1hardhat@", "put_on_hat", 8.0, -8.0, -1, 32, 0, false, false, false)
					end
					Wait(2000)
					StopAnimTask(playerPed, "missheistdockssetup1hardhat@", "put_on_hat", 1.0)
					
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['helmet_1'] = value.helmet_1,
								['helmet_2'] = value.helmet_2
							})						
						end
					end)
				else
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "veh@common@fp_helmet@", "take_off_helmet_stand", 8.0, -8.0, -1, 32, 0, false, false, false)
					end
					Wait(1500)
					StopAnimTask(playerPed, "veh@common@fp_helmet@", "take_off_helmet_stand", 1.0)
					
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['helmet_1'] = -1,
								['helmet_2'] = 0
							}, function()
								SetPedComponentVariation(playerPed, 2, value.hair_1, skin['hair_2'], 2)	
							end)															
						else
							TriggerServerEvent('falszywyy_clothes:saveClothes', {['helmet_1'] = skin.helmet_1, ['helmet_2'] = skin.helmet_2})
							TriggerEvent('skinchanger:loadClothes', skin, {
								['helmet_1'] = -1,
								['helmet_2'] = 0
							})							
						end
					end)
				end
			elseif action == 'zegarek' then
				if -1 == skin.watches_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "clothingshoes", "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
					
					Wait(1000)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_a", 1.0)

					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['watches_1'] = value.watches_1,
								['watches_2'] = value.watches_2
							})						
						end
					end)
				else
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "clothingshoes", "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					Wait(1000)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_a", 1.0)

					TriggerServerEvent('falszywyy_clothes:saveClothes', {['watches_1'] = skin.watches_1, ['watches_2'] = skin.watches_2})
					TriggerEvent('skinchanger:loadClothes', skin, {
						['watches_1'] = 0,
						['watches_2'] = 0
					})
				end
			elseif action == 'branzoleta' then
				if -1 == skin.bracelets_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "clothingshoes", "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
		
					Wait(1000)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_a", 1.0)
					
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['bracelets_1'] = value.bracelets_1,
								['bracelets_2'] = value.bracelets_2
							})						
						end
					end)
				else
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "clothingshoes", "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
					end
					
					Wait(1000)
					StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_a", 1.0)
					
					TriggerServerEvent('falszywyy_clothes:saveClothes', {['bracelets_1'] = skin.bracelets_1, ['bracelets_2'] = skin.bracelets_2})
					TriggerEvent('skinchanger:loadClothes', skin, {
						['bracelets_1'] = 0,
						['bracelets_2'] = 0
					})
				end
			elseif action == 'glasses' then
				if skin.sex == 0 and 0 == skin.glasses_1 or skin.sex == 1 and 5 == skin.glasses_1 then
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "mp_masks@on_foot", "put_on_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Wait(800)
					StopAnimTask(playerPed, "mp_masks@on_foot", "put_on_mask", 1.0)
					
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['glasses_1'] = value.glasses_1,
								['glasses_2'] = value.glasses_2
							})						
						end
					end)
				else
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, "missfbi4", "takeoff_mask", 8.0, -8.0, -1, 48, 0, false, false, false)
					end
					
					Wait(1000)
					StopAnimTask(playerPed, "missfbi4", "takeoff_mask", 1.0)

					TriggerServerEvent('falszywyy_clothes:saveClothes', {['glasses_1'] = skin.glasses_1, ['glasses_2'] = skin.glasses_2})
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, {
							['glasses_1'] = 0,
							['glasses_2'] = 0
						})
					else
						TriggerEvent('skinchanger:loadClothes', skin, {
							['glasses_1'] = 5,
							['glasses_2'] = 0
						})
					end
				end
			elseif action == 'bag' then
				if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
					TaskPlayAnim(playerPed, 'clothingshirt', "check_out_a", 8.0, 8.0, -1, 50, 0, false, false, false)
				end

				Wait(1500)
				StopAnimTask(playerPed, "clothingshirt", "check_out_a", 1.0)
				
				if 0 == skin.bags_1 then
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['bags_1'] = value.bags_1,
								['bags_2'] = value.bags_2
							})						
						end
					end)
				else
					TriggerServerEvent('falszywyy_clothes:saveClothes', {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
					TriggerEvent('skinchanger:loadClothes', skin, {
						['bags_1'] = 0,
						['bags_1'] = 0
					})
				end
			elseif action == 'coat' then
				if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
					TaskPlayAnim(playerPed, 'clothingshirt', "try_shirt_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
				end

				Wait(2000)
				StopAnimTask(playerPed, "clothingshirt", "try_shirt_positive_a", 1.0)
				
				if skin.sex == 0 then
					if 15 == skin.tshirt_1 and 15 == skin.torso_1 then
						ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
							if value then
							
								TriggerEvent('skinchanger:loadClothes', skin, {
									['tshirt_1'] = value.tshirt_1,
									['tshirt_2'] = value.tshirt_2,
									['torso_1'] = value.torso_1,
									['torso_2'] = value.torso_2,
									['arms'] = value.arms,
									['arms_2'] = value.arms_2
								})						
							end
						end)
					else
						TriggerServerEvent('falszywyy_clothes:saveClothes', {['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2,['arms'] = skin.arms,['arms_2'] = skin.arms_2})
						TriggerEvent('skinchanger:loadClothes', skin, {
							['tshirt_1'] = 15,
							['tshirt_2'] = 0,
							['torso_1'] = 15,
							['torso_2'] = 0,
							['arms'] = 15,
							['arms_2'] = 0
						})
					end
				elseif skin.sex == 1 then
					if 14 == skin.tshirt_1 and 448 == skin.torso_1 then
						ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
							if value then
								TriggerEvent('skinchanger:loadClothes', skin, {
									['tshirt_1'] = value.tshirt_1,
									['tshirt_2'] = value.tshirt_2,
									['torso_1'] = value.torso_1,
									['torso_2'] = value.torso_2,
									['arms'] = value.arms,
									['arms_2'] = value.arms_2
								})						
							end
						end)
					else
						TriggerServerEvent('falszywyy_clothes:saveClothes', {['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2,['arms'] = skin.arms,['arms_2'] = skin.arms_2})
						TriggerEvent('skinchanger:loadClothes', skin, {
							['tshirt_1'] = 14,
							['tshirt_2'] = 0,
							['torso_1'] = 448,
							['torso_2'] = 0,
							['arms'] = 15,
							['arms_2'] = 0
						})
					end
				end
			elseif action == 'kamizelka' then
				local a = GetPedArmour(PlayerPedId())
				
				if a >= 0 then
					if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
						TaskPlayAnim(playerPed, 'clothingshirt', "check_out_c", 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					Wait(1500)
					StopAnimTask(playerPed, "clothingshirt", "check_out_c", 1.0)
					
					if 0 == skin.bproof_1 then
						ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
							if value then
								TriggerEvent('skinchanger:loadClothes', skin, {
									['bproof_1'] = value.bproof_1,
									['bproof_2'] = value.bproof_2,
								})						
							end
						end)
					else
						TriggerServerEvent('falszywyy_clothes:saveClothes', {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
						TriggerEvent('skinchanger:loadClothes', skin, {
							['bproof_1'] = 0,
							['bproof_2'] = 0,
						})
					end
				else
					ESX.ShowNotification('~r~Nie możesz ściągnąć kamizelkę')
				end
			elseif action == 'legs' then
				if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
					TaskPlayAnim(playerPed, "clothingtrousers", "try_trousers_neutral_c", 44.0, -8.0, -1, 48, 0, false, false, false)
				end
				
				Wait(2500)
				StopAnimTask(playerPed, "clothingtrousers", "try_trousers_neutral_c", 1.0)
				
				if 61 == skin.pants_1 and skin.sex == 0 or 15 == skin.pants_1 and skin.sex == 1 then
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then	
							TriggerEvent('skinchanger:loadClothes', skin, {
								['pants_1'] = value.pants_1,
								['pants_2'] = value.pants_2,
							})						
						end
					end)
				else
					TriggerServerEvent('falszywyy_clothes:saveClothes', {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
					
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, {
							['pants_1'] = 61,
							['pants_2'] = 1,
						})
					else
						TriggerEvent('skinchanger:loadClothes', skin, {
							['pants_1'] = 15,
							['pants_2'] = 0,
						})
					end
				end
			elseif action == 'shoes' then
				if not IsPedInAnyVehicle(playerPed, false) and not exports['esx_policejob']:IsCuffed() then
					TaskPlayAnim(playerPed, "clothingshoes", "try_shoes_positive_d", 44.0, -8.0, -1, 48, 0, false, false, false)
				end
				
				Wait(2250)
				StopAnimTask(playerPed, "clothingshoes", "try_shoes_positive_d", 1.0)

				if 57 == skin.shoes_1 and skin.sex == 0 or 35 == skin.shoes_1 and skin.sex == 1 then
					ESX.TriggerServerCallback('falszywyy_clothes:getClothes', function(value)
						if value then
							TriggerEvent('skinchanger:loadClothes', skin, {
								['shoes_1'] = value.shoes_1,
								['shoes_2'] = value.shoes_2,
							})						
						end
					end)
				else
					TriggerServerEvent('falszywyy_clothes:saveClothes', {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, {
							['shoes_1'] = 34,
							['shoes_2'] = 0,
						})
					else
						TriggerEvent('skinchanger:loadClothes', skin, {
							['shoes_1'] = 35,
							['shoes_2'] = 0,
						})
					end
				end
			elseif action == 'faceundermask' then
				if 0 ~= skin.face and skin.mask_1 ~= 0 then
					SetPedHeadBlendData(playerPed, 0, skin['face_2'], skin['face_3'], skin['skin'], skin['skin_2'], skin['skin_3'], skin['blend_face'] / 10, skin['blend_skin'] / 10, skin['blend'] / 10, true)
				end
			elseif action == 'hairunderhat' then				
				if -1 ~= skin.hair_1 and skin.helmet_1 ~= -1 then
					SetPedComponentVariation(playerPed, 2,	0, skin['hair_2'], 2)	
				end		
			end
		end
	end)
end
--------------
RegisterKeyMapping('+-clothesMenu', 'Menu ubrań', 'keyboard', 'K')

RegisterCommand('+-clothesMenu', function()
	OpenAccessoryMenu()
end)

function OpenAccessoryMenu()
	for _, dict in ipairs({'clothingtie', 'mp_masks@on_foot', 'missfbi4', 'missheistdockssetup1hardhat@', 'veh@common@fp_helmet@', 'clothingshirt', 'clothingshoes', 'clothingtrousers'}) do
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(0)
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_unset_accessory', {
		title = ('Ubrania'),
		align = 'center',
		elements = {
			{label = 'Maska', value = 'mask'},
			{label = 'Czapka / Hełm', value = 'hat'},
			{label = 'Okulary', value = 'glasses'},
			{label = 'Łańcuch / Krawat / Plakietka', value = 'chain'},
			{label = 'Lewa ręka / Zegarek', value = 'zegarek'},
			{label = 'Prawa ręka', value = 'branzoleta'},
			{label = 'Tułów', value = 'coat'},
			{label = 'Nogi', value = 'legs'},
			{label = 'Stopy', value = 'shoes'},
			{label = 'Torba / Plecak', value = 'bag'},
			{label = 'Kamizelka', value = 'kamizelka'},
			{label = 'Schowaj włosy pod czapkę / hełm', value = 'hairunderhat'},
			{label = 'Schowaj twarz pod maskę', value = 'faceundermask'}
		}
	}, function(data, menu)
		if data.current.value then
			MenuUbran(data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterCommand('+dodatki', function(source, args, rawCommand)
	local playerPed = PlayerPedId()
	if not IsPedInAnyVehicle(playerPed, false) and GetSelectedPedWeapon(playerPed) ~= `WEAPON_UNARMED` then
		if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'esx_misiaczek') then
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_misiaczek', {
				title	= ('Ściągnij dodatki z broni'),
				align	= 'center',
				elements = {
					{label = 'Tłumik', value = "suppressor"},
					{label = 'Latarka', value = "flashlight"},
					{label = 'IronSights', value = "ironsights"},
					{label = 'Chwyt', value = "grip"},
					{label = 'Powiększony magazynek', value = "clip_extended"},
					{label = 'Box magazynek', value = "clip_box"},
					{label = 'Magazynek bębnowy', value = "clip_drum"},
					{label = 'Celownik', value = "scope"},
					{label = 'Luneta Advanced', value = "scope_advanced"},
					{label = 'Luneta Zoom', value = "scope_zoom"},
					{label = 'Luneta Nightvision', value = "scope_nightvision"},
					{label = 'Luneta Thermal', value = "scope_thermal"},
					{label = 'Celownik MK I', value = "scope_holo"},
					{label = 'Celownik MK II', value = "scope_medium"},
					{label = 'Celownik MK III', value = "scope_large"},
				}
			}, function(data, menu)						
				if data.current.value ~= nil then
					TriggerEvent('es_extended:setComponent', false, data.current.value)
				end
			end, function(data, menu)  
				menu.close()
			end)
		end
	end
end, false)

RegisterKeyMapping('+dodatki', 'Dodatki do broni','keyboard', 'PLUS')