local OwnedProperties, Blips, CurrentActionData = {}, {}, {}
local CurrentProperty, CurrentPropertyOwner, LastProperty, LastPart, CurrentAction, CurrentActionMsg
local firstSpawn, hasChest, hasAlreadyEnteredMarker = true, false, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.TriggerServerCallback('esx_propertyaddon:GetPropertiesAddon', function(properties)
		Config.PropertiesAddon = properties
		CreateBlips()
	end)

	ESX.TriggerServerCallback('esx_propertyaddon:getOwnedPropertiesAddon', function(ownedPropertiesAddon)
		for i=1, #ownedPropertiesAddon, 1 do
			SetPropertyOwnedAddon(ownedPropertiesAddon[i], true)
		end
	end)
end)

CreateThread(function()
	ESX.TriggerServerCallback('esx_propertyaddon:GetPropertiesAddon', function(properties)
		Config.PropertiesAddon = properties
		CreateBlips()
	end)

	ESX.TriggerServerCallback('esx_propertyaddon:getOwnedPropertiesAddon', function(ownedPropertiesAddon)
		for i=1, #ownedPropertiesAddon, 1 do
			SetPropertyOwnedAddon(ownedPropertiesAddon[i], true)
		end
	end)
end)

-- only used when script is restarting mid-session
RegisterNetEvent('esx_propertyaddon:sendProperties')
AddEventHandler('esx_propertyaddon:sendProperties', function(properties)
	Config.PropertiesAddon = properties
	CreateBlips()

	ESX.TriggerServerCallback('esx_propertyaddon:getOwnedPropertiesAddon', function(ownedPropertiesAddon)
		for i=1, #ownedPropertiesAddon, 1 do
			SetPropertyOwnedAddon(ownedPropertiesAddon[i], true)
		end
	end)
end)

function DrawSub(text, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, 1)
end

function CreateBlips()
	for i=1, #Config.PropertiesAddon, 1 do
		local property = Config.PropertiesAddon[i]

		if property.entering then
			Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)

			SetBlipSprite (Blips[property.name], 350)
			SetBlipDisplay(Blips[property.name], 4)
			SetBlipScale  (Blips[property.name], 0.3)
			SetBlipAsShortRange(Blips[property.name], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(_U('free_prop'))
			EndTextCommandSetBlipName(Blips[property.name])
		end
	end
end

function GetPropertiesAddon()
	return Config.PropertiesAddon
end

function GetPropertyAddon(name)
	for i=1, #Config.PropertiesAddon, 1 do
		if Config.PropertiesAddon[i].name == name then
			return Config.PropertiesAddon[i]
		end
	end
end

function GetGatewayAddon(property)
	for i=1, #Config.PropertiesAddon, 1 do
		local property2 = Config.PropertiesAddon[i]

		if property2.isGateway and property2.name == property.gateway then
			return property2
		end
	end
end

function GetGatewayAddonProperties(property)
	local properties = {}

	for i=1, #Config.PropertiesAddon, 1 do
		if Config.PropertiesAddon[i].gateway == property.name then
			table.insert(properties, Config.PropertiesAddon[i])
		end
	end

	return properties
end

function EnterPropertyAddon(name, owner)
	local property       = GetPropertyAddon(name)
	local playerPed      = PlayerPedId()
	CurrentProperty      = property
	CurrentPropertyOwner = owner

	for i=1, #Config.PropertiesAddon, 1 do
		if Config.PropertiesAddon[i].name ~= name then
			Config.PropertiesAddon[i].disabled = true
		end
	end

	TriggerServerEvent('esx_propertyaddon:saveLastProperty', name)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		for i=1, #property.ipls, 1 do
			RequestIpl(property.ipls[i])

			while not IsIplActive(property.ipls[i]) do
				Citizen.Wait(0)
			end
		end

		SetEntityCoords(playerPed, property.inside.x, property.inside.y, property.inside.z)
		DoScreenFadeIn(800)
		DrawSub(property.label, 5000)
	end)

end

function ExitPropertyAddon(name)
	local property  = GetPropertyAddon(name)
	local playerPed = PlayerPedId()
	local outside   = nil
	CurrentProperty = nil

	if property.isSingle then
		outside = property.outside
	else
		outside = GetGatewayAddon(property).outside
	end

	TriggerServerEvent('esx_propertyaddon:deleteLastProperty')

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		SetEntityCoords(playerPed, outside.x, outside.y, outside.z)

		for i=1, #property.ipls, 1 do
			RemoveIpl(property.ipls[i])
		end

		for i=1, #Config.PropertiesAddon, 1 do
			Config.PropertiesAddon[i].disabled = false
		end

		DoScreenFadeIn(800)
	end)
end

function SetPropertyOwnedAddon(name, owned)
	local property     = GetPropertyAddon(name)
	local entering     = nil
	local enteringName = nil

	if property.isSingle then
		entering     = property.entering
		enteringName = property.name
	else
		local gateway = GetGatewayAddon(property)
		entering      = gateway.entering
		enteringName  = gateway.name
	end

	if owned then
		OwnedProperties[name] = true
		RemoveBlip(Blips[enteringName])

		Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
		SetBlipSprite(Blips[enteringName], 40)
		SetBlipAsShortRange(Blips[enteringName], true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U('property'))
		EndTextCommandSetBlipName(Blips[enteringName])
	else
		OwnedProperties[name] = nil
		local found = false

		for k,v in pairs(OwnedProperties) do
			local _property = GetPropertyAddon(k)
			local _gateway  = GetGatewayAddon(_property)

			if _gateway then
				if _gateway.name == enteringName then
					found = true
					break
				end
			end
		end

		if not found then
			RemoveBlip(Blips[enteringName])

			Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
			SetBlipSprite(Blips[enteringName], 369)
			SetBlipAsShortRange(Blips[enteringName], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(_U('free_prop'))
			EndTextCommandSetBlipName(Blips[enteringName])
		end
	end
end

function PropertyIsOwnedAddon(property)
	return OwnedProperties[property.name] == true
end

function OpenPropertyMenuAddon(property)
	local elements = {}

	if PropertyIsOwnedAddon(property) then
		table.insert(elements, {label = _U('enter'), value = 'enter'})

		if not Config.EnablePlayerManagement then
			table.insert(elements, {label = _U('leave'), value = 'leave'})
		end
	else
		if not Config.EnablePlayerManagement then
            table.insert(elements, {label = _U('buy') .. " - $" .. property["price"], value = 'buy'})
        end

		table.insert(elements, {label = _U('visit'), value = 'visit'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property', {
		title    = property.label,
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'enter' then
			TriggerEvent('instanceAddon:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
		elseif data.current.value == 'leave' then
			TriggerServerEvent('esx_propertyaddon:removeOwnedProperty', property.name)
		elseif data.current.value == 'buy' then
			TriggerServerEvent('esx_propertyaddon:buyProperty', property.name)
		elseif data.current.value == 'visit' then
			TriggerEvent('instanceAddon:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'property_menu'
		CurrentActionMsg  = _U('press_to_menu')
		CurrentActionData = {property = property}
	end)
end

function OpenGatewayMenu(property)
	if Config.EnablePlayerManagement then
		OpenGatewayOwnedPropertiesMenu(gatewayProperties)
	else

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway', {
			title    = property.name,
			align    = 'center',
			elements = {
				{label = _U('owned_properties'),    value = 'owned_properties'},
				{label = _U('available_properties'), value = 'available_properties'}
		}}, function(data, menu)
			if data.current.value == 'owned_properties' then
				OpenGatewayOwnedPropertiesMenu(property)
			elseif data.current.value == 'available_properties' then
				OpenGatewayAvailablePropertiesMenu(property)
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'gateway_menu'
			CurrentActionMsg  = _U('press_to_menu')
			CurrentActionData = {property = property}
		end)
	end
end

function OpenGatewayOwnedPropertiesMenu(property)
	local gatewayProperties = GetGatewayAddonProperties(property)
	local elements          = {}

	for i=1, #gatewayProperties, 1 do
		if PropertyIsOwnedAddon(gatewayProperties[i]) then
			table.insert(elements, {
				label = gatewayProperties[i].label,
				value = gatewayProperties[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties', {
		title    = property.name .. ' - ' .. _U('owned_properties'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		local elements = {
			{label = _U('enter'), value = 'enter'}
		}

		if not Config.EnablePlayerManagement then
			table.insert(elements, {label = _U('leave'), value = 'leave'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties_actions', {
			title    = data.current.label,
			align    = 'center',
			elements = elements
		}, function(data2, menu2)
			menu2.close()

			if data2.current.value == 'enter' then
				TriggerEvent('instanceAddon:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
				ESX.UI.Menu.CloseAll()
			elseif data2.current.value == 'leave' then
				TriggerServerEvent('esx_propertyaddon:removeOwnedProperty', data.current.value)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGatewayAvailablePropertiesMenu(property)
	local gatewayProperties = GetGatewayAddonProperties(property)
	local elements          = {}

	for i=1, #gatewayProperties, 1 do
		if not PropertyIsOwnedAddon(gatewayProperties[i]) then
			table.insert(elements, {
				label = gatewayProperties[i].label .. ' $' .. ESX.Math.GroupDigits(gatewayProperties[i].price),
				value = gatewayProperties[i].name,
				price = gatewayProperties[i].price
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties', {
		title    = property.name .. ' - ' .. _U('available_properties'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties_actions', {
			title    = property.label .. ' - ' .. _U('available_properties'),
			align    = 'center',
			elements = {
				{label = _U('buy'), value = 'buy'},
				{label = _U('rent'), value = 'rent'},
				{label = _U('visit'), value = 'visit'}
		}}, function(data2, menu2)
			menu2.close()

			if data2.current.value == 'buy' then
				TriggerServerEvent('esx_propertyaddon:buyProperty', data.current.value)
			elseif data2.current.value == 'rent' then
				TriggerServerEvent('esx_propertyaddon:rentProperty', data.current.value)
			elseif data2.current.value == 'visit' then
				TriggerEvent('instanceAddon:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenRoomMenu(property, owner)
	local entering = nil
	local elements = {{label = _U('invite_player'),  value = 'invite_player'}}

	if property.isSingle then
		entering = property.entering
	else
		entering = GetGatewayAddon(property).entering
	end

	if CurrentPropertyOwner == owner then
		table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
		table.insert(elements, {label = _U('remove_cloth'), value = 'remove_cloth'})
	end

	table.insert(elements, {label = _U('remove_object'),  value = 'room_inventory'})
	table.insert(elements, {label = _U('deposit_object'), value = 'player_inventory'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = property.label,
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'invite_player' then

			local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)
			local elements      = {}

			for i=1, #playersInArea, 1 do
				if playersInArea[i] ~= PlayerId() then
					table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_invite', {
				title    = property.label .. ' - ' .. _U('invite'),
				align    = 'center',
				elements = elements,
			}, function(data2, menu2)
				TriggerEvent('instanceAddon:invite', 'property', GetPlayerServerId(data2.current.value), {property = property.name, owner = owner})
				ESX.ShowNotification(_U('you_invited', GetPlayerName(data2.current.value)))
			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('esx_propertyaddon:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = property.label .. ' - ' .. _U('player_clothes'),
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_propertyaddon:getPlayerOutfit', function(clothes)
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

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('esx_propertyaddon:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = property.label .. ' - ' .. _U('remove_cloth'),
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('esx_propertyaddon:removeOutfit', data2.current.value)
					ESX.ShowNotification(_U('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'room_inventory' then
			OpenRoomInventoryMenu(property, owner)
		elseif data.current.value == 'player_inventory' then
			OpenPlayerInventoryMenu(property, owner)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'room_menu'
		CurrentActionMsg  = _U('press_to_menu')
		CurrentActionData = {property = property, owner = owner}
	end)
end

function IsSubMenuInElements(elements, name)
	for i=1, #elements do
		if elements[i].type == 'sub' and elements[i].value == name then
			return true
		end
	end

	return false
end

function OpenRoomInventoryMenu(property, owner)
	if not exports['esx_policejob']:IsCuffed() then
		ESX.TriggerServerCallback('esx_propertyaddon:GetPropertyAddonInventory', function(inventory)
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

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory', {
				title    = property.label .. ' - ' .. _U('inventory'),
				align    = 'center',
				elements = elements
			}, function(data, menu)

				if data.current.type == 'sub' then
					OpenSubGetInventoryItem(data.current.value, property, owner)
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
		
							TriggerServerEvent('esx_propertyaddon:getItem', owner, data.current.type, data.current.value, count)
							ESX.SetTimeout(300, function()
								OpenRoomInventoryMenu(property, owner)
							end)
						end
					end, function(data2,menu)
						menu.close()
					end)
				end
			end, function(data, menu)
				menu.close()
			end)
		end, owner)
	end
end

function OpenSubGetInventoryItem(data, property, owner)
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

                TriggerServerEvent('esx_propertyaddon:getItem', owner, data.current.type, data.current.value, count)
                ESX.SetTimeout(300, function()
                    OpenRoomInventoryMenu(property, owner)
                end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPlayerInventoryMenu(property, owner)
	ESX.TriggerServerCallback('esx_propertyaddon:getPlayerInventory', function(inventory)
		local elements = {}

        if inventory.blackMoney > 0 then
            table.insert(elements, {
                label = _U('dirty_money', ESX.Math.GroupDigits(inventory.blackMoney)),
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
			title    = property.label .. ' - ' .. _U('inventory'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
				title = _U('amount')
			}, function(data2, menu2)
				local quantity = tonumber(data2.value)

				if quantity == nil then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu2.close()

					TriggerServerEvent('esx_propertyaddon:putItem', owner, data.current.type, data.current.value, tonumber(data2.value))
					ESX.SetTimeout(300, function()
						OpenPlayerInventoryMenu(property, owner)
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

AddEventHandler('instanceAddon:loaded', function()
	TriggerEvent('instanceAddon:registerType', 'property', function(instanceAddon)
		EnterPropertyAddon(instanceAddon.data.property, instanceAddon.data.owner)
	end, function(instanceAddon)
		ExitPropertyAddon(instanceAddon.data.property)
	end)
end)

AddEventHandler('playerSpawned', function()
	if firstSpawn then
		Citizen.CreateThread(function()
			while not ESX.IsPlayerLoaded() do
				Citizen.Wait(0)
			end

			ESX.TriggerServerCallback('esx_propertyaddon:getLastProperty', function(propertyName)
				if propertyName then
					if propertyName ~= '' then
						local property = GetPropertyAddon(propertyName)

						for i=1, #property.ipls, 1 do
							RequestIpl(property.ipls[i])

							while not IsIplActive(property.ipls[i]) do
								Citizen.Wait(0)
							end
						end

						TriggerEvent('instanceAddon:create', 'property', {property = propertyName, owner = ESX.GetPlayerData().identifier})
					end
				end
			end)
		end)

		firstSpawn = false
	end
end)

AddEventHandler('esx_propertyaddon:GetPropertiesAddon', function(cb)
	cb(GetPropertiesAddon())
end)

AddEventHandler('esx_propertyaddon:GetPropertyAddon', function(name, cb)
	cb(GetPropertyAddon(name))
end)

AddEventHandler('esx_propertyaddon:GetGatewayAddon', function(property, cb)
	cb(GetGatewayAddon(property))
end)

RegisterNetEvent('esx_propertyaddon:SetPropertyOwnedAddon')
AddEventHandler('esx_propertyaddon:SetPropertyOwnedAddon', function(name, owned)
	SetPropertyOwnedAddon(name, owned)
end)

RegisterNetEvent('instanceAddon:onCreate')
AddEventHandler('instanceAddon:onCreate', function(instanceAddon)
	if instanceAddon.type == 'property' then
		TriggerEvent('instanceAddon:enter', instanceAddon)
	end
end)

RegisterNetEvent('instanceAddon:onEnter')
AddEventHandler('instanceAddon:onEnter', function(instanceAddon)
	if instanceAddon.type == 'property' then
		local property = GetPropertyAddon(instanceAddon.data.property)
		local isHost   = GetPlayerFromServerId(instanceAddon.host) == PlayerId()
		local isOwned  = false

		if PropertyIsOwnedAddon(property) == true then
			isOwned = true
		end

		if isOwned or not isHost then
			hasChest = true
		else
			hasChest = false
		end
	end
end)

RegisterNetEvent('instanceAddon:onPlayerLeft')
AddEventHandler('instanceAddon:onPlayerLeft', function(instanceAddon, player)
	if player == instanceAddon.host then
		TriggerEvent('instanceAddon:leave')
	end
end)

AddEventHandler('esx_propertyaddon:hasEnteredMarker', function(name, part)
	local property = GetPropertyAddon(name)

	if part == 'entering' then
		if property.isSingle then
			CurrentAction     = 'property_menu'
			CurrentActionMsg  = _U('press_to_menu')
			CurrentActionData = {property = property}
		else
			CurrentAction     = 'gateway_menu'
			CurrentActionMsg  = _U('press_to_menu')
			CurrentActionData = {property = property}
		end
	elseif part == 'exit' then
		CurrentAction     = 'room_exit'
		CurrentActionMsg  = _U('press_to_exit')
		CurrentActionData = {propertyName = name}
	elseif part == 'roomMenu' then
		CurrentAction     = 'room_menu'
		CurrentActionMsg  = _U('press_to_menu')
		CurrentActionData = {property = property, owner = CurrentPropertyOwner}
	end
end)

AddEventHandler('esx_propertyaddon:hasExitedMarker', function(name, part)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Enter / Exit marker events & Draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true
		local currentProperty, currentPart

		for i=1, #Config.PropertiesAddon, 1 do
			local property = Config.PropertiesAddon[i]

			-- Entering
			if property.entering and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.entering.x, property.entering.y, property.entering.z+0.05, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 54, 227, 175, 175, false, true, 2, true, false, false, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'entering'
				end
			end

			-- Exit
			if property.exit and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.exit.x, property.exit.y, property.exit.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.exit.x, property.exit.y, property.exit.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 54, 227, 175, 175, false, true, 2, true, false, false, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'exit'
				end
			end

			-- Room menu
			if property.roomMenu and hasChest and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z,0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 54, 227, 175, 175, false, true, 2, true, false, false, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'roomMenu'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and (LastProperty ~= currentProperty or LastPart ~= currentPart) ) then
			hasAlreadyEnteredMarker = true
			LastProperty            = currentProperty
			LastPart                = currentPart

			TriggerEvent('esx_propertyaddon:hasEnteredMarker', currentProperty, currentPart)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_propertyaddon:hasExitedMarker', LastProperty, LastPart)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'property_menu' then
					OpenPropertyMenuAddon(CurrentActionData.property)
				elseif CurrentAction == 'gateway_menu' then
					if Config.EnablePlayerManagement then
						OpenGatewayOwnedPropertiesMenu(CurrentActionData.property)
					else
						OpenGatewayMenu(CurrentActionData.property)
					end
				elseif CurrentAction == 'room_menu' then
					OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
				elseif CurrentAction == 'room_exit' then
					TriggerEvent('instanceAddon:leave')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
