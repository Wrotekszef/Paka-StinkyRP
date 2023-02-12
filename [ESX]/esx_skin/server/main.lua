RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.update('UPDATE users SET skin = ? WHERE identifier = ?', { json.encode(skin), xPlayer.identifier})
	if GetPlayerRoutingBucket(_source) == _source then
		SetPlayerRoutingBucket(_source, 0)
		Wait(1000)
		TriggerClientEvent("tmsn701:reloadPed", _source)
	end
end)

RegisterServerEvent('tmsn701:KreatorBucket')
AddEventHandler('tmsn701:KreatorBucket', function(xd)
	local _source = source
	if xd then
		SetPlayerRoutingBucket(_source, _source)
	else
		SetPlayerRoutingBucket(_source, 0)
	end
	Wait(1000)
	TriggerClientEvent("tmsn701:reloadPed", _source)
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() ~= 'user' then
		local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

		file:write(json.encode(skin) .. "\n\n")
		file:flush()
		file:close()
	else
		print(('esx_skin: %s attempted saving skin to file'):format(xPlayer.getIdentifier()))
	end
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT skin FROM users WHERE identifier = ?', { xPlayer.identifier}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

RegisterCommand('skinsave', function(source, args, user)
	if source == 0 then
		if id[1]== nil then
			return
		end
		
		TriggerClientEvent('esx_skin:requestSaveSkin', args[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'starszyadmin' or xPlayer.group == 'starszymod' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport') then
			TriggerClientEvent('esx_skin:requestSaveSkin', source)
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)

RegisterCommand('skin', function(source, id, user)
	if source == 0 then	
		if id[1]== nil then
			return
		end
		TriggerEvent('sendMessageDiscord', "Otwarto menu skina Graczowi o ID: " .. id[1])
		TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'partner' or xPlayer.group == "starszyadmin" or xPlayer.group == 'starszymod' or xPlayer.group == 'starszymod' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport') then
			if id[1] ~= nil then
				if GetPlayerPing(id[1]) == 0 then
					xPlayer.showNotification('Niema nikogo o takim ID')
					return
				end
				xPlayer.showNotification('Otwarto menu skin Graczowi o ID: ' .. id[1])
				TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
			else
				TriggerClientEvent('esx_skin:openSaveableMenu', source)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)

RegisterCommand('setped', function(source, id, user)
	if source == 0 then
		if id[1]== nil then
			return
		end
		
		TriggerClientEvent('esx_skin:openSaveableMenuPed', id[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == "starszyadmin" or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod') then
			if id[1] ~= nil then
				if GetPlayerPing(id[1])== 0 then
					xPlayer.showNotification('Niema nikogo o takim ID')
					return
				end
				xPlayer.showNotification('Otwarto menu skin Graczowi o ID: '..id[1])
				TriggerClientEvent('esx_skin:openSaveableMenuPed', id[1])
			else
				TriggerClientEvent('esx_skin:openSaveableMenuPed', source)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)
