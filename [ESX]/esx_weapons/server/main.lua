ESX.RegisterServerCallback('esx_newweaponshop:buyWeapon', function(source, cb, weaponName, type, zone)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local selectedWeapon = Config.Zones[zone].Items
	
	for k,v in ipairs(Config.Zones[zone].Items) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		cb(false)
	end

	if zone == 'GunShop' then
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				if selectedWeapon.itemtype == 'item' then
					xPlayer.addInventoryItem(weaponName, 1)
				elseif selectedWeapon.itemtype == 'weapon' then
					xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
				end
				exports['stinky_logs']:SendLog(source, "Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
			end
		elseif type == 2 then			
			if xPlayer.getMoney() >= selectedWeapon.price then
				if xPlayer.canCarryItem(weaponName, 1) then
					xPlayer.removeMoney(selectedWeapon.price)
					if selectedWeapon.itemtype == 'item' then
						xPlayer.addInventoryItem(weaponName, 1)
					elseif selectedWeapon.itemtype == 'weapon' then
						xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
					end
				else
					xPlayer.showNotification('~r~Nie możesz więcej unieść')
				end
			else	
				cb(false)
			end
		end
	elseif zone == 'GunShopDS' then
			if type == 1 then
				if xPlayer.getAccount('money').money >= selectedWeapon.price then
					xPlayer.removeAccountMoney('money', selectedWeapon.price)
					if selectedWeapon.itemtype == 'item' then
						xPlayer.addInventoryItem(weaponName, 1)
					elseif selectedWeapon.itemtype == 'weapon' then
						xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
					end
					exports['stinky_logs']:SendLog(source, "SKLEP GWIAZD: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
				else
					xPlayer.showNotification('~r~Nie masz tyle sianka!')
				end
			elseif type == 2 then			
				if xPlayer.getAccount('money').money >= selectedWeapon.price then
					if xPlayer.canCarryItem(weaponName, 1) then
						xPlayer.removeAccountMoney('money', selectedWeapon.price)
						if selectedWeapon.itemtype == 'item' then
							xPlayer.addInventoryItem(weaponName, 1)
						elseif selectedWeapon.itemtype == 'weapon' then
							xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
						end
						exports['stinky_logs']:SendLog(source, "SKLEP GWIAZD: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
					else
						xPlayer.showNotification('~r~Nie możesz więcej unieść')
					end
				else	
					xPlayer.showNotification('~r~Nie masz tyle sianka!')
					cb(false)
				end
			end
	elseif zone == 'mafia' then
		if type == 1 then
			if xPlayer.getAccount('money').money >= selectedWeapon.price then
				xPlayer.removeAccountMoney('money', selectedWeapon.price)
				if selectedWeapon.itemtype == 'item' then
					xPlayer.addInventoryItem(weaponName, 1)
				elseif selectedWeapon.itemtype == 'weapon' then
					xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
				end
				exports['stinky_logs']:SendLog(source, "SKLEP GWIAZD: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
			else
				xPlayer.showNotification('~r~Nie masz tyle sianka!')
			end
		elseif type == 2 then			
			if xPlayer.getAccount('money').money >= selectedWeapon.price then
				if xPlayer.canCarryItem(weaponName, 1) then
					xPlayer.removeAccountMoney('money', selectedWeapon.price)
					if selectedWeapon.itemtype == 'item' then
						xPlayer.addInventoryItem(weaponName, 1)
					elseif selectedWeapon.itemtype == 'weapon' then
						xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
					end
					exports['stinky_logs']:SendLog(source, "SKLEP GWIAZD: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
				else
					xPlayer.showNotification('~r~Nie możesz więcej unieść')
				end
			else	
				xPlayer.showNotification('~r~Nie masz tyle sianka!')
				cb(false)
			end
		end
	elseif zone == 'stinkycoin' then
		local stinkycoin = xPlayer.getInventoryItem("stinkycoin")
		if type == 1 then
			if stinkycoin.count >= selectedWeapon.price then
				xPlayer.removeInventoryItem("stinkycoin", selectedWeapon.price)
				if selectedWeapon.itemtype == 'item' then
					xPlayer.addInventoryItem(weaponName, 1)
				elseif selectedWeapon.itemtype == 'weapon' then
					xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
				end
				exports['stinky_logs']:SendLog(source, "SKLEP STINKYCOIN: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
			else
				xPlayer.showNotification('~r~Nie masz tyle coinsów!')
			end
		elseif type == 2 then			
			if stinkycoin.count >= selectedWeapon.price then
				if xPlayer.canCarryItem(weaponName, 1) then
					xPlayer.removeInventoryItem("stinkycoin", selectedWeapon.price)
					if selectedWeapon.itemtype == 'item' then
						xPlayer.addInventoryItem(weaponName, 1)
					elseif selectedWeapon.itemtype == 'weapon' then
						xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
					end
					exports['stinky_logs']:SendLog(source, "SKLEP STINKYCOIN: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
				else
					xPlayer.showNotification('~r~Nie możesz więcej unieść')
				end
			else	
				xPlayer.showNotification('~r~Nie masz tyle coinsów!')
				cb(false)
			end
		end
	else
		if type == 1 then
			if xPlayer.getAccount('money').money >= selectedWeapon.price then
				xPlayer.removeAccountMoney('money', selectedWeapon.price)
				
				if selectedWeapon.itemtype == 'item' then
					xPlayer.addInventoryItem(weaponName, 1)
				elseif selectedWeapon.itemtype == 'weapon' then
					xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
				end
				
				exports['stinky_logs']:SendLog(source, "Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
				cb(true)
			else
				xPlayer.showNotification('~r~Nie masz tyle sianka!')
				cb(false)
			end
		elseif type == 2 then			
			if xPlayer.getAccount('money').money >= selectedWeapon.price then
				if xPlayer.canCarryItem(weaponName, 1) then
					xPlayer.removeAccountMoney('money', selectedWeapon.price)
					if selectedWeapon.itemtype == 'item' then
						xPlayer.addInventoryItem(weaponName, 1)
					elseif selectedWeapon.itemtype == 'weapon' then
						xPlayer.addInventoryWeapon(weaponName, 1, 150, false)
					end
				else
					xPlayer.showNotification('~r~Nie możesz więcej unieść')
				end
			else	
				xPlayer.showNotification('~r~Nie masz tyle sianka!')
				cb(false)
			end
		end
	end
end)