RegisterServerEvent('gunshotInProgress')
AddEventHandler('gunshotInProgress', function(coords, str, isPolice)
	if str == nil or str == '' or str == ' ' then
		return
	else
		local src = source
		local Players = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(Players) do
			if (v.job == 'police' or v.job == 'sheriff') then
				TriggerClientEvent('gunshotPlace', v.id, coords, isPolice, str)
			end
		end
	end
end)

RegisterServerEvent('destroyingInProgress')
AddEventHandler('destroyingInProgress', function(coords, str)
	local _source = source
	if string.find(str, "Uwaga, podejrzany obywatel w okolicach złomowiska") then
		local Players = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(Players) do
			if (v.job == 'police' or v.job == 'sheriff') then
				TriggerClientEvent('destroyPlace', v.id, coords, str)
			end
		end
	end	
end)

RegisterServerEvent('sellDrugsInProgress')
AddEventHandler('sellDrugsInProgress', function(coords, str, photo, sex)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if string.find(str, " przy ^0") then
		local Players = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(Players) do
			if (v.job == 'police' or v.job == 'sheriff') then
				if photo == true then
					TriggerEvent('ReturnSkin', _source, function(data)
						local currentSkin = data
						TriggerClientEvent('drugPlace', v.id, coords, photo, xPlayer.source, sex, str, currentSkin)
					end)
				else
					TriggerClientEvent('drugPlace', v.id, coords, photo, xPlayer.source, sex, str)
				end
			end
		end
	end	
end)

RegisterServerEvent('notifyAccident')
AddEventHandler('notifyAccident', function(coords, str)
	local _source = source
	if string.find(str, " przy ^0") then
		local Players = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(Players) do
			if (v.job == 'police' or v.job == 'sheriff') then
				TriggerClientEvent('accidentPlace', v.id, coords, str)
			end
		end
	end	
end)

RegisterServerEvent('notifyThief')
AddEventHandler('notifyThief', function(coords, str)
	local _source = source
	if string.find(str, " przy ^0") then
		local Players = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(Players) do
			if (v.job == 'police' or v.job == 'sheriff') then
				TriggerClientEvent('thiefPlace', v.id, coords, str)
			end
		end
	end	
end)

RegisterServerEvent('outlawalert:sendNotif')
AddEventHandler('outlawalert:sendNotif', function(type, code, str, coords, usertype)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local GetPlayers = exports['esx_scoreboard']:ExilePlayers()
	for k,v in pairs(GetPlayers) do		
		if usertype ~= 'dlasamsu' then
			if (v.job == 'police' or v.job == 'sheriff') then
				local odznaka = json.decode(xPlayer.character.job_id)
				
				TriggerClientEvent('bkPlace', v.id, v.job, coords, code, odznaka.id, str)
			end
		else
			xPlayer.showNotification('~g~Prośba o wsparcie dla medyków została wysłana!')
			if (v.job == 'ambulance') then
				local odznaka = json.decode(xPlayer.character.job_id)
				TriggerClientEvent('bkPlace', v.id, v.job, coords, code, odznaka.id, str)
			end
		end

	end
end)

RegisterServerEvent("exilerp_scripts:triedToEscapePD", function(id) 
	local src = source
	if tonumber(src) ~= nil then
		TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Tried to trigger event (esx_jb_outlawalert)")
	else
		local xPlayer = ESX.GetPlayerFromId(id)
		local Players = exports['esx_scoreboard']:ExilePlayers()
		for k,v in pairs(Players) do
			if (v.job == 'police' or v.job == 'sheriff') then
				TriggerClientEvent('chatMessage', v.id, "^*Służba więzienna: ", {0, 0, 0}, "^5"..xPlayer.character.firstname..' '..xPlayer.character.lastname.." ^7 próbował uciec z więzienia!")
			end
		end
	end	
end)