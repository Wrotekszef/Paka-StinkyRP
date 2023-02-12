local magazines = {owner={}, coowner={}}
local current = {}
local tempInfo = {
	magazineLevel = 0,
	cloakroomUnlocked = 0
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData

	LoopRefreshMagazines()
end)

CreateThread(function()
	LoopRefreshMagazines()
end)

function RefreshMagazines() 
	ESX.TriggerServerCallback("exile_houses_crime:fetchMagazines", function(magaziness) 
		if magaziness.owner[1] and magaziness.owner[1] ~= {} and magaziness.owner[1] ~= nil then
			tempInfo = {
				magazineLevel = tonumber(magaziness.owner[1].storage_level),
				cloakroomUnlocked = 1
			}
		end
		magazines = magaziness
	end)
end

RegisterNetEvent("exile_houses_crime:updateMagazines", function() 
	RefreshMagazines()
end)

function LoopRefreshMagazines() 
	CreateThread(function() 
		while true do
			RefreshMagazines()
			Citizen.Wait(1000*(60*5))
		end
	end)
end

local playerPed,playerCoords
local exitVector = vector3(Config.Exit.x, Config.Exit.y, Config.Exit.z)
local enterVector = vector3(Config.Enter.x, Config.Enter.y, Config.Enter.z)

CreateThread(function() 
	while true do
		playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		Citizen.Wait(600)
	end
end)

RegisterNetEvent("exile_houses_crime:openMenu", function(t)
	if t == "manage" then
		OpenManagment()
	end
end)

RegisterNetEvent("exile_houses_crime:setCurrentMagazine", function(mag) 
	print(json.encode(mag))
	current = mag
end)

function OpenManagment() 
	local elements = {}
	local date = magazines.owner[1].expires

	local storage = magazines.owner[1]["storage_level"]
	local coowner = magazines.owner[1]["coowner_level"]
	local storageCost = 0
	local coownerCost = 0
	if storage ~= 4 then
		storageCost = Config.UpgradeCost[storage]
	end
	if coowner ~= 5 then
		coownerCost = Config.UpgradeCost[coowner]
	end

	local expired = false
	
	table.insert(elements, {
		label = expired and "Magazyn wygasł!" or "Magazyn wygasa: "..date,
		value = "expiring"
	})
	table.insert(elements, {
		label = "Przedłuż magazyn",
		value = "extend_magazine"
	})

	table.insert(elements, {
		label = "Ulepsz limit współwłaścicieli ["..coowner.."/5] - "..coownerCost.."$",
		value = "upgrade_coowner"
	})

	table.insert(elements, {
		label = "Dodaj współwłaściciela",
		value = "add_coowner"
	})
	table.insert(elements, {
		label = "Usuń współwłaścicieli",
		value = "remove_coowner"
	})


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "magazines_manage", {
		title    = 'Zarządzanie magazynem',
		align    = 'center',
		elements = elements,
	}, function(data, menu)
		local val = data.current.value 
		if val == "extend_magazine" then
			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'exile_schowki',
				{
					align    = 'center',
					title    = ('O ile dni chcesz przedłużyć magazyn? 1 dzień - '..Config.CostExtend.."$"),
					elements = {}
				},
				function(data, menu)
					menu.close()
					local title = data.value
					if title ~= nil and tonumber(data.value) then
						if data.value <= 365 then
							TriggerServerEvent("exile_houses_crime:extendMagazine", data.value)
						else
							ESX.ShowNotification("~r~Możesz przedłużyć magazyn maksymalnie o 365 dni.")
						end
					else
						ESX.ShowNotification('~r~Nieprawidłowa ilość dni')
					end
				end,
				function(data,menu) 
					menu.close()
				end
		)
		elseif val == "upgrade_storage" then
			TriggerServerEvent("exile_houses_crime:magazineUpgrade", "storage")
		elseif val == "upgrade_coowner" then
			TriggerServerEvent("exile_houses_crime:magazineUpgrade", "coowner")
		elseif val == "add_coowner" then
			local elements2 = {}
			local playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

			if #playersNearby > 0 then
				for k,playerNearby in ipairs(playersNearby) do
					local sId = GetPlayerServerId(playerNearby)
					table.insert(elements2, {
						label = sId,
						value = sId
					})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "coowner_add", {
				title    = 'Wybierz komu chcesz nadać współwłaściciela',
				align    = 'center',
				elements = elements2,
			}, function(data2, menu2)
				local playerId = data2.current.value
				menu2.close()
				if playerId ~= nil then
					TriggerServerEvent("exile_houses_crime:addCoOwner", playerId)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif val == "remove_coowner" then
			ESX.TriggerServerCallback('exile_houses_crime:getCoowners', function(coowners)
				local elements2 = {}
				print(json.encode(coowners))
				for k,v in pairs(coowners) do
					table.insert(elements2, {
						label = v,
						value = k
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "coowner_remove", {
					title    = 'Usuwanie współwłaścicieli',
					align    = 'center',
					elements = elements2,
				}, function(data2, menu2)
					local playerIdentifier = data2.current.value
					menu2.close()
					if playerIdentifier ~= nil then
						TriggerServerEvent("exile_houses_crime:removeCoOwner", playerIdentifier)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenShared() 
	local elements = {}
	for i,v in pairs(magazines.coowner) do
		local expired = false
		table.insert(elements, {
			label = "Magazyn ["..v.bucket.."]"..(expired and " - Wygasł" or ""),
			value = v.id
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shared_magazines", {
		title    = 'Współdzielone magazyny',
		align    = 'center',
		elements = elements,
	}, function(data, menu)
		local val = data.current.value 
		menu.close()
		TriggerServerEvent("exile_houses_crime:enterMagazine", val)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenMainMenu() 
	local elements = {}
	if #magazines.owner > 0 then
		table.insert(elements, {
			label = "Wejdź do magazynu",
			value = "enter_magazine"
		})
		table.insert(elements, {
			label = "Zarządzaj magazynem",
			value = "manage_magazine"
		})
	else
		table.insert(elements, {
			label = "Wykup magazyn",
			value = "buy_magazine"
		})
	end
	if #magazines.coowner > 0 then
		table.insert(elements, {
			label = "Współdzielone magazyny",
			value = "shared_magazines"
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "magazines_interaction", {
		title    = 'Magazyny',
		align    = 'center',
		elements = elements,
	}, function(data, menu)
		local val = data.current.value 
		menu.close()
		if val == "enter_magazine" then
			TriggerServerEvent("exile_houses_crime:enterMagazine", magazines.owner[1].id)
		elseif val == "manage_magazine" then
			OpenManagment()
		elseif val == "buy_magazine" then
			TriggerServerEvent("exile_houses_crime:rentMagazine")
		elseif val == "shared_magazines" then
			OpenShared()
		end
	end, function(data, menu)
		menu.close()
	end)
end

CreateThread(function() 
	while true do
		local sleep = 700
		if true then
			local dist1 = #(playerCoords - exitVector)
			if dist1 < 12.0 then
				sleep = 3
				if dist1 < 2.0 then
					ESX.ShowHelpNotification("~s~Naciśnij ~INPUT_CONTEXT~ aby ~r~opuścić magazyn")
					if IsControlJustPressed(0, 38) then
						TriggerServerEvent("exile_houses_crime:exitMagazine")
					end
				end
				ESX.DrawMarker(vec3(Config.Exit.x, Config.Exit.y, Config.Exit.z))
			end
			local dist2 = #(playerCoords - enterVector)
			if dist2 < 12.0 then
				sleep = 3
				if dist2 < 2.0 then
					ESX.ShowHelpNotification("~s~Naciśnij ~INPUT_CONTEXT~ aby ~y~zarządzać magazynami")
					if IsControlJustPressed(0, 38) then
						OpenMainMenu()
					end
				end
				ESX.DrawMarker(vec3(Config.Enter.x, Config.Enter.y, Config.Enter.z))
			end
			local dist3 = #(playerCoords - Config.Magazine1)
			if dist3 < 6.0 then
				sleep = 3
				if dist3 < 2.0 then
					ESX.ShowHelpNotification("~s~Naciśnij ~INPUT_CONTEXT~ aby ~g~otworzyć szafke")
					if IsControlJustPressed(0, 38) then
						OpenStorage(current.identifier, current.id)
					end
				end
				ESX.DrawMarker(vec3(Config.Magazine1))
			end
			::przebieralnia::
			if tempInfo.cloakroomUnlocked then
				local dist7 = #(playerCoords - Config.Cloakroom)
				if dist7 < 6.0 then
					sleep = 3
					if dist7 < 2.0 then
						ESX.ShowHelpNotification("~s~Naciśnij ~INPUT_CONTEXT~ aby ~g~otworzyć przebieralnie")
						if IsControlJustPressed(0, 38) then
							OpenShopMenu()
						end
					end
					ESX.DrawMarker(vec3(Config.Cloakroom))
				end
			end
		end

		::huj::

		Citizen.Wait(sleep)
	end
end)

function OpenStorage(owner,id) 
	local elements = {}

	table.insert(elements, {label = "Wyciągnij przedmiot",  value = 'room_inventory'})
	table.insert(elements, {label = "Włóż przedmiot", value = 'player_inventory'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine',
	{
		title    = "Magazyn - Schowek",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'room_inventory' then
			OpenMagazineInv(owner,id)
		elseif data.current.value == 'player_inventory' then
			OpenPlayerInv(owner,id)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenMagazineInv(owner, id) 
	if not exports['esx_policejob']:IsCuffed() then
		ESX.TriggerServerCallback('exile_houses_crime:getMagazineInventory', function(inventory)

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
					  item.type = 'item_weapon'
				  end
  
				  if item.type == 'item_weapon' then
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

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine_inventory',
			{
				title    = "Magazyn - Szafka",
				align    = 'center',
				elements = elements
			}, function(data, menu)
				if data.current.type == 'item_weapon' then
					menu.close()

					TriggerServerEvent('exile_houses_crime:getItem', owner, data.current.type, data.current.value, data.current.ammo, id)
					ESX.SetTimeout(300, function()
						OpenMagazineInv(owner, id)
					end)
				else

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
						title = "Ilość"
					}, function(data2, menu)

						local quantity = tonumber(data2.value)
						if quantity == nil then
							ESX.ShowNotification("~r~Nie prawidłowa ilość")
						else
							menu.close()

							TriggerServerEvent('exile_houses_crime:getItem', owner, data.current.type, data.current.value, quantity, id)
							ESX.SetTimeout(300, function()
								OpenMagazineInv(owner, id)
							end)
						end

					end, function(data2, menu)
						menu.close()
					end)

				end

			end, function(data, menu)
				menu.close()
			end)

		end, owner, id)
	end
end

function OpenPlayerInv(owner,id) 
	ESX.UI.Menu.CloseAll()
  
	ESX.TriggerServerCallback('exile_houses_crime:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = "<font style='color:red'>Brudna gotówka: $"..ESX.Math.GroupDigits(inventory.blackMoney).. "</font>",
				type  = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				if item.label ~= nil then
					table.insert(elements, {
						label = item.label .. ' x' .. item.count,
						type  = 'item_standard',
						value = item.name
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
			title    = "Magazyn - Ekwipunek",
			align    = 'center',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'putcount', {
				title = "Ilość"
			}, function(data2, menu2)
				local quantity = tonumber(data2.value)
				if quantity == nil then
					ESX.ShowNotification("~r~Nie prawidłowa ilość")
				else
					menu2.close()
					print(owner, data.current.type, data.current.value, tonumber(data2.value), id)
					TriggerServerEvent('exile_houses_crime:putItem', owner, data.current.type, data.current.value, tonumber(data2.value), id)
					ESX.SetTimeout(300, function()
						OpenPlayerInv(owner,id)
					end)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function RestrictedMenu()
	ESX.UI.Menu.CloseAll()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = 'valid_this_purchase',
			align = 'center',
			elements = {
				{label = 'no', value = 'no'},
				{label = 'yes', value = 'yes'}
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
									title = 'save_in_dressing',
									align = 'center',
									elements = {
										{label = 'no',  value = 'no'},
										{label = 'yes', value = 'yes'}
									}
								}, function(data2, menu2)
									menu2.close()

									if data2.current.value == 'yes' then
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
											title = 'name_outfit'
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
						ESX.ShowNotification('not_enough_money')
						cleanPlayer()
					end
				end)
			elseif data.current.value == 'no' then
				OpenShopMenu()
				t = false
			end
		end, function(data, menu)
			menu.close()
			cleanPlayerskin()
		end)

	end, function(data, menu)
		menu.close()
		cleanPlayerskin()
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
		'bags_2',
		'bproof_1',
		'bproof_2'
	})
end

function OpenShopMenu()
	local elements = {
		{label = ('Przebieralnia'),  value = 'shop_clothes'},
		{label = ('Własne ubrania'), value = 'player_dressing'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title    = ('Przebieralnia'),
		align    = 'center',
		elements = elements,
    }, function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			RestrictedMenu()
		end

		if data.current.value == 'player_dressing' then
			OpenClothes()
		end
    end, function(data, menu)
		menu.close()
    end)
end

function OpenClothes()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for k,v in pairs(dressing) do
			table.insert(elements, {label = v, value = k})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
			title    = 'Garderoba',
			align    = 'center',
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
		end)
	end)
end

function cleanPlayerskin()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end