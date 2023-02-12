RegisterCommand('jail', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	if source == 0 then
		if GetPlayerName(args[1]) ~= nil then
			TriggerEvent('exilerp_scripts:jailonplayerchuj', tonumber(args[1]), tonumber(args[2] * 60))
		end
	else
		if xPlayer.group == 'superadmin' or xPlayer.group == 'best' then
			if args[1] then
				if GetPlayerName(args[1]) ~= nil then
					TriggerEvent('exilerp_scripts:jailonplayerchuj', tonumber(args[1]), tonumber(args[2] * 60))
				else
					xPlayer.showNotification('~r~Podałeś nieprawidłowe ID')
				end
			else
				TriggerEvent('exilerp_scripts:jailonplayerchuj', source, tonumber(args[2] * 60))
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

RegisterCommand('unjail', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	if source == 0 then
		if GetPlayerName(args[1]) ~= nil then
			TriggerEvent('exilerp_scripts:jailofffplayer', tonumber(args[1]))
		end
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.group == 'superadmin' or xPlayer.group == "starszyadmin" or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'best' then
			if args[1] then
				if GetPlayerName(args[1]) ~= nil then
					TriggerEvent('exilerp_scripts:jailofffplayer', tonumber(args[1]))
				else
					xPlayer.showNotification('~r~Podałeś nieprawidłowe ID')
				end
			else
				TriggerEvent('exilerp_scripts:jailofffplayer', source)
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

RegisterServerEvent('exilerp_scripts:jailonplayerchuj')
AddEventHandler('exilerp_scripts:jailonplayerchuj', function(target, jailTime)
	local _source = source
	local _target = target
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local xPlayer = ESX.GetPlayerFromId(_target)
	local identifier = xPlayer.identifier
	local digit = xPlayer.getDigit()
	local year1 = round2(os.date('%Y'),0)
	local month1 = round2(os.date('%m'),0)
	local day1 = round2(os.date('%d'),0)
	local hour1 = round2(os.date('%H'),0)
	local minutes1 = round2(os.date('%M'),0)
	local seconds1 = round2(os.date('%S') + (jailTime*4),0)
	local mTime = {year = year1, month = month1, day = day1, hour = hour1, min = minutes1, sec = seconds1}
	local dt = os.time(mTime)
	MySQL.query('SELECT identifier FROM jail WHERE identifier=?', {identifier}, function(result)
		if result[1] ~= nil then
			MySQL.update.await("UPDATE jail SET jail_time=@jt, timeleft=@timeleft WHERE identifier=@id AND digit = @digit", {['@id'] = identifier, ['@digit'] = digit, ['@jt'] = jailTime, ['@timeleft'] = dt})
		else
			MySQL.update("INSERT INTO jail (identifier, digit, jail_time,timeleft) VALUES (@identifier, @digit, @jail_time,@timeleft)", {['@identifier'] = identifier, ['@digit'] = digit, ['@jail_time'] = jailTime, ['@timeleft'] = dt})
		end
	end)	
	TriggerClientEvent('esx_policejob:unrestrain', _target)
	TriggerClientEvent('exilerp_scripts:prisontimepierdolene', _target, jailTime)
end)

RegisterServerEvent('esx_jailer:reloadCharacter')
AddEventHandler('esx_jailer:reloadCharacter', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.query('SELECT timeleft, jail_time FROM jail WHERE identifier=? AND digit = ?', {xPlayer.identifier, xPlayer.getDigit()}, function(result)
		if result[1] ~= nil then
			local jailTime = tonumber(result[1].timeleft)
			if jailTime ~= nil then
				local currentTime = os.time()
				local jailDiff = jailTime - currentTime
				if jailDiff <= 0 or jailDiff == nil then
					unjail(_source)
				else
					TriggerClientEvent('exilerp_scripts:connectafterchecker', _source, tonumber(result[1].jail_time))
				end
			else
				TriggerClientEvent('exilerp_scripts:unjailjailerplayerAfterChange', _source)
			end
		else
			TriggerClientEvent('exilerp_scripts:unjailjailerplayerAfterChange', _source)
		end
	end)
end)

RegisterServerEvent('exilerp_scripts:jailcheckerplayer')
AddEventHandler('exilerp_scripts:jailcheckerplayer', function()
	local player = source -- cannot parse source to client trigger for some weird reason
	local xPlayer = ESX.GetPlayerFromId(player)
	if xPlayer then
		local identifier = xPlayer.identifier -- get steam identifier
		local digit = xPlayer.getDigit()
		MySQL.query('SELECT timeleft FROM jail WHERE identifier=@id AND digit = @digit', {['@id'] = identifier, ['@digit'] = digit}, function(result)
			if result[1] ~= nil then
				local jailTime = tonumber(result[1].timeleft)
				if jailTime ~= nil then
					local currentTime = os.time()
					local jailDiff = jailTime - currentTime
					if jailDiff <= 0 or jailDiff == nil then
						unjail(player)
					else
						jailDiff = math.floor(jailDiff/4)
						MySQL.update.await("UPDATE jail SET jail_time=@jt WHERE identifier=@id AND digit = @digit", {['@id'] = identifier, ['@digit'] = digit, ['@jt'] = jailDiff})
						TriggerClientEvent('exilerp_scripts:connectafterchecker', player, tonumber(jailDiff))
					end
				else
					unjail(player)
				end
			end
		end)
	end
end)

RegisterServerEvent('exilerp_scripts:jailofffplayer')
AddEventHandler('exilerp_scripts:jailofffplayer', function(source)
	if source ~= nil then
		unjail(source)
	end
end)

RegisterServerEvent('exilerp_scripts:unjailjailerplayerTime')
AddEventHandler('exilerp_scripts:unjailjailerplayerTime', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local digit = xPlayer.getDigit()
	
	MySQL.query('SELECT identifier FROM jail WHERE identifier=@id AND digit = @digit', {
		['@id'] = identifier, 
		['@digit'] = digit
	}, function(gotInfo)
		if gotInfo[1] ~= nil then
		
			MySQL.update('DELETE from jail WHERE identifier = @id AND digit = @digit', {
				['@id'] = identifier, 
				['@digit'] = digit
			})
			
		end
	end)
	
	TriggerClientEvent('exilerp_scripts:unjailjailerplayer', _source)
end)

RegisterServerEvent('esx_jailer:updateRemaining')
AddEventHandler('esx_jailer:updateRemaining', function(jailTime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local digit = xPlayer.getDigit()
	MySQL.query('SELECT identifier FROM jail WHERE identifier=? AND digit = ?', {identifier, digit}, function(gotInfo)
		if gotInfo[1] ~= nil then
			local year1 = round2(os.date('%Y'),0)
			local month1 = round2(os.date('%m'),0)
			local day1 = round2(os.date('%d'),0)
			local hour1 = round2(os.date('%H'),0)
			local minutes1 = round2(os.date('%M'),0)
			local seconds1 = round2(os.date('%S') + (jailTime*4),0)
			local mTime = {year = year1, month = month1, day = day1, hour = hour1, min = minutes1, sec = seconds1}
			local dt = os.time(mTime)
			MySQL.update.await("UPDATE jail SET jail_time=?, timeleft=? WHERE identifier=? AND digit = ?", {jailTime, dt, identifier, digit})
		end
	end)
end)

function unjail(target)
	local xPlayer = ESX.GetPlayerFromId(target)
	local identifier = xPlayer.identifier
	local digit = xPlayer.getDigit()
	MySQL.query('SELECT identifier FROM jail WHERE identifier=@id AND digit = @digit', {['@id'] = identifier, ['@digit'] = digit}, function(gotInfo)
		if gotInfo[1] ~= nil then
			MySQL.update('DELETE from jail WHERE identifier = @id AND digit = @digit', {['@id'] = identifier, ['@digit'] = digit})
		end
	end)
	TriggerClientEvent('exilerp_scripts:unjailjailerplayer', target)
end

function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function round2(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end