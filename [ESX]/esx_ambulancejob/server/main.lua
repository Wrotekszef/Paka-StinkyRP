TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})
TriggerEvent('esxexile_societyrpexileesocietybig:registerSociety', 'ambulance', 'Ambulance', 'society_sams2', 'society_sams2', 'society_sams2', {type = 'public'})


RegisterServerEvent('esx_ambulancejob:reviveexile')
AddEventHandler('esx_ambulancejob:reviveexile', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getJob().name == 'ambulance' or xPlayer.getJob().name == 'offambulance' then 
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sams2', function(account)
			account.addAccountMoney(2000)
			xPlayer.addMoney(Config.ReviveReward)
		end)
		TriggerClientEvent('esx_ambulancejob:reviveexile', target)
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to revive (esx_ambulancejob)")
	end
end)

RegisterServerEvent('esx_ambulancejob:es')
AddEventHandler('esx_ambulancejob:es', function(cmd)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	local Doctors = tonumber(exports['esx_scoreboard']:CounterPlayers('ambulance'))
    if GetPlayerName(tonumber(cmd[1])) ~= nil then
        if xPlayer.job.name == 'ambulance' then
            TriggerClientEvent('esx_ambulancejob:reviveexile', cmd[1])
			exports['exile_logs']:SendLog(src, "/ulecz " .. cmd[1], 'ambulance')
        elseif xPlayer.job.name == 'police' then
            if xPlayer.job.grade > 2 and xPlayer.job.grade <= 10 then
                if Doctors <= 2 then
                    TriggerClientEvent('esx_ambulancejob:reviveexile', cmd[1])
					exports['exile_logs']:SendLog(src, "/ulecz " .. cmd[1], 'ambulance')
                else
                    TriggerClientEvent('esx:showNotification', src, '~b~Aby pomóc wezwij SAMS')
                end
            elseif xPlayer.job.grade > 10 then
                TriggerClientEvent('esx_ambulancejob:reviveexile', cmd[1])
				exports['exile_logs']:SendLog(src, "/ulecz " .. cmd[1], 'ambulance')
            else
                TriggerClientEvent('esx:showNotification', src, '~r~Nie masz odpowiedniego wyszkolenia do pomocy obywatelom')
            end
		elseif xPlayer.job.name == 'sheriff' then
            if xPlayer.job.grade > 2 and xPlayer.job.grade <= 10 then
                if Doctors <= 2 then
                    TriggerClientEvent('esx_ambulancejob:reviveexile', cmd[1])
					exports['exile_logs']:SendLog(src, "/ulecz " .. cmd[1], 'ambulance')
                else
                    TriggerClientEvent('esx:showNotification', src, '~b~Aby pomóc wezwij SAMS')
                end
            elseif xPlayer.job.grade > 10 then
                TriggerClientEvent('esx_ambulancejob:reviveexile', cmd[1])
				exports['exile_logs']:SendLog(src, "/ulecz " .. cmd[1], 'ambulance')
            else
                TriggerClientEvent('esx:showNotification', src, '~r~Nie masz odpowiedniego wyszkolenia do pomocy obywatelom')
            end
        end
    end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, itemName)
	TriggerClientEvent('esx_ambulancejob:heal', target, itemName)
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getAccount('money').money > 0 then
			xPlayer.setAccountMoney('money', 0)
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end

		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				if xPlayer.inventory[i].type ~= 'sim' and xPlayer.inventory[i].name ~= 'exilecoin' then
					xPlayer.removeInventoryItem(xPlayer.inventory[i].name, xPlayer.inventory[i].count)
				end
			end
		end
	end

	cb()
end)

if Config.EarlyRespawn and Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)

		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money
		local finePayable = false

		if bankBalance >= Config.EarlyRespawnFineAmount then
			finePayable = true
		else
			finePayable = false
		end

		cb(finePayable)
	end)

	ESX.RegisterServerCallback('esx_ambulancejob:payFine', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_fine', Config.EarlyRespawnFineAmount))
		xPlayer.removeAccountMoney('bank', Config.EarlyRespawnFineAmount)
		cb()
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local qtty = xPlayer.getInventoryItem(item).count
	cb(qtty)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" then
		if item == 'medikit' or item == 'bandage' or item == 'gps' or item == 'bodycam' or item == 'radio' then
			local limit = xPlayer.getInventoryItem(item).limit
			local delta = 1
			local qtty = xPlayer.getInventoryItem(item).count

			if limit ~= -1 then
				delta = limit - qtty
			end

			if qtty < limit then
				xPlayer.addInventoryItem(item, count ~= nil and count or delta)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
			end
		else
			TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to give item "..item.." (esx_ambulancejob)")
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn items without job")
	end
end)

RegisterCommand('revive', function(source, args, user)
	if source == 0 then
		TriggerClientEvent('esx_ambulancejob:reviveexile', tonumber(args[1]), true)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'partner' or xPlayer.group == 'starszyadmin' or xPlayer.group == 'starszymod' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport') then
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					TriggerClientEvent("esx:showNotification", tonumber(args[1]), "~g~Zostałeś ożywiony przez administratora ~b~"..GetPlayerName(xPlayer.source).."~g~!")
					TriggerClientEvent('esx_ambulancejob:reviveexile', tonumber(args[1]), true)
					exports['exile_logs']:SendLog(source, "Użyto komendy /revive " .. tonumber(args[1]), "admin_commands")
				end
			else
				TriggerClientEvent("esx:showNotification", source, "~g~Zostałeś ożywiony przez administratora!")
				TriggerClientEvent('esx_ambulancejob:reviveexile', source, true)
				exports['exile_logs']:SendLog(source, "Użyto komendy /revive", "admin_commands")
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

local Message = ""

ESX.RegisterUsableItem('apteczka', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('apteczka', 1)
	Message = "Używa apteczki"
	TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
	TriggerClientEvent('esx_ambulancejob:healitem', _source, 'apteczka')
end)

ESX.RegisterUsableItem('bandaz', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('bandaz', 1)
	Message = "Używa bandaża"
	TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
	TriggerClientEvent('esx_ambulancejob:healitem', _source, 'bandaz')
end)

ESX.RegisterUsableItem('leki', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('leki', 1)
	Message = "Kładzie tabletkę na język"
	TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
	Wait(1000)
	Message = "Popija tabletkę wodą"
	TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_ambulancejob:healitem', _source, 'leki')
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.scalar('SELECT isDead FROM users WHERE identifier = ? AND digit = ?', {xPlayer.identifier, xPlayer.digit}, function(isDead)
		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.update.await("UPDATE users SET isDead=? WHERE identifier=?", {isDead, xPlayer.identifier})
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer ~= nil then
		MySQL.scalar('SELECT isDead FROM users WHERE identifier = ?', { xPlayer.identifier}, function(isDead)
            if not isDead or isDead == 0 then 
                MySQL.query("SELECT health, armour FROM users WHERE identifier = ?", {xPlayer.identifier}, function(data)
                    if data[1].health ~= nil and data[1].armour ~= nil then
                        TriggerClientEvent('esx_healthnarmour:set', playerId, data[1].health, data[1].armour)
                    end
                end)
            else
                TriggerClientEvent('esx_healthnarmour:set', playerId, 0, 0)
            end
        end)
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	
	if xPlayer ~= nil then
		local health = GetEntityHealth(GetPlayerPed(xPlayer.source))
		local armour = GetPedArmour(GetPlayerPed(xPlayer.source))
		MySQL.update('UPDATE users SET health = ?, armour = ? WHERE identifier = ?', {health, armour,xPlayer.identifier})
  	end
end)

ESX.RegisterServerCallback('esxexile_societyrpexileesocietybig:getEmployeeslic', function(source, cb, job, society)
	MySQL.query('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = ? OR job = ? ORDER BY job_grade DESC', {society, 'off'..society}, function (results)
		local employees = {}
		local count = 0		
		for i=1,99 do if results[i] ~= nil then count = i else break end end
			for i=1, #results, 1 do
	
				local heli = false
				local moto = false
				local offroad = false
				local msu = false
				local swim = false
				MySQL.query('SELECT * FROM user_licenses WHERE owner = ?', {results[i].identifier}, function (results2)
					for k,v in pairs (results2) do
						if v.type == 'sams_heli' then
							heli = true
						elseif v.type == 'sams_moto' then
							moto = true
						elseif v.type == 'sams_offroad' then
							offroad = true
						elseif v.type == 'sams_msu' then
							msu = true
						elseif v.type == 'sams_swim' then
							swim = true
						end
					end	
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					licensess = {
					heli = heli,
					moto = moto,
					offroad = offroad,
					msu = msu,
					swim = swim,
					}
				})	
				if count == i then
					cb(employees)
				end				
				end)	
			end
	end)
end)

RegisterServerEvent('esx_ambulancejob:addlicense')
AddEventHandler('esx_ambulancejob:addlicense', function (identifier, licka)
    local _source = source
  	MySQL.update('INSERT INTO user_licenses (type, owner) VALUES (?, ?)',{licka,identifier},function (rowsChanged)
	end)
end)

RegisterServerEvent('esx_ambulancejob:removelicense')
AddEventHandler('esx_ambulancejob:removelicense', function (identifier, licka)
    local _source = source
  	MySQL.update('DELETE FROM user_licenses WHERE owner = ? AND type = ?',{licka,identifier},function (rowsChanged)
	end)
end)

RegisterServerEvent('esx_ambulancejob:checkwyrok', function (id)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local tPlayer = ESX.GetPlayerFromId(id)
	
	if tPlayer then
		MySQL.query('SELECT crimes FROM lspd_user_judgments WHERE userId = ? ', {tPlayer.identifier}, function(crimes)
			if json.encode(crimes) == '[]' then
				xPlayer.showNotification('~g~Obywatel nie był karany')
			else
				xPlayer.showNotification('~r~Obywatel jest karany')
			end
		end)
	end
end)