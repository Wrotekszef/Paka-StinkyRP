local licenseslist, CachedPlayers = {}, {}

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		MySQL.query('SELECT type, label FROM licenses', function(result)
			for i=1, #result, 1 do			
				licenseslist[result[i].type] = result[i].label
			end
		end)
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	if not CachedPlayers[playerId] then
		CachedPlayers[playerId] = {}
		
		MySQL.query('SELECT type FROM user_licenses WHERE owner = ? AND digit = ?', {xPlayer.identifier, xPlayer.digit}, function(result)
			if result[1] ~= nil then
				for k,v in ipairs(result) do				
					table.insert(CachedPlayers[playerId], v.type)
				end
			end
		end)
	end
end)

RegisterServerEvent("e-license:refresh", function(id) 
	local playerId = id
	local xPlayer = ESX.GetPlayerFromId(playerId)
	CachedPlayers[playerId] = {}
	MySQL.query('SELECT type FROM user_licenses WHERE owner = ? AND digit = ?', {xPlayer.identifier, xPlayer.digit}, function(result)
		if result[1] ~= nil then
			for k,v in ipairs(result) do		
				table.insert(CachedPlayers[playerId], v.type)
			end
		end

	end)		
end)

AddEventHandler('playerDropped', function()
	local _source = source
	
	if CachedPlayers[_source] then
		CachedPlayers[_source] = nil
	end
end)

function ScanTable(playerId, result) 	
	if playerId ~= nil and result ~= nil then		
		if CachedPlayers[playerId] ~= nil then
			for _, value in ipairs(CachedPlayers[playerId]) do
				if value == result then
					return true
				end
			end
		end
		
		return false
	end
end

function AddLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		if not ScanTable(xPlayer.source, type) then
			MySQL.update('INSERT INTO user_licenses (type, owner, digit) VALUES (?, ?, ?)', {type, xPlayer.identifier, xPlayer.getDigit()}, function(rowsChanged)
				if CachedPlayers[xPlayer.source] ~= nil then	
					table.insert(CachedPlayers[xPlayer.source], type)
				end
				
				if cb then
					cb()
				end
			end)
		else
			if cb then
				cb()
			end
		end
	else
		if cb then
			cb()
		end
	end
end

function AddAdvancedLicense(target, type, grade, time, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		if not ScanTable(xPlayer.source, type) then
			MySQL.update('INSERT INTO user_licenses (type, owner, digit, grade, time) VALUES (?, ?, ?, ?, ?)', {type, xPlayer.identifier, xPlayer.getDigit(), grade, time,}, function(rowsChanged)
				if CachedPlayers[xPlayer.source] ~= nil then	
					table.insert(CachedPlayers[xPlayer.source], type)
				end
				
				if cb then
					cb()
				end
			end)
		else
			if cb then
				cb()
			end
		end
	else
		if cb then
			cb()
		end
	end
end

function RemoveLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		if ScanTable(xPlayer.source, type) then
			MySQL.update('DELETE FROM user_licenses WHERE type = ? AND owner = ? AND digit = ?', {type,xPlayer.identifier,xPlayer.getDigit()}, function(rowsChanged)
			
				if CachedPlayers[xPlayer.source] ~= nil then
					for k,value in ipairs(CachedPlayers[xPlayer.source]) do
						if value == type then
							table.remove(CachedPlayers[xPlayer.source], k)
							break
						end
					end
				end
				
				if cb then
					cb()
				end
			end)
		else
			if cb then
				cb()
			end
		end
	else
		if cb then
			cb()
		end
	end
end

function GetLicense(type, cb)	
	local data = {}
	
	if licenseslist[type] ~= nil then
		data = {
			type = type,
			label = licenseslist[type]
		}
	end
	
	cb(data)
end

function GetLicenses(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)	
	
	if xPlayer ~= nil then
		local data = {}
		
		if CachedPlayers[xPlayer.source] ~= nil then
			for k,value in ipairs(CachedPlayers[xPlayer.source]) do
				if value ~= nil then
					table.insert(data, {
						type = value,
						label = licenseslist[value]
					})
				end			
			end
		end
		
		cb(data)
	else
		if cb then
			cb({})
		end
	end
end

function CheckLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
		
	if xPlayer ~= nil then
		if CachedPlayers[xPlayer.source] ~= nil then
			local found = false
			
			for k,value in ipairs(CachedPlayers[xPlayer.source]) do						
				if value == type then
					found = true
					break
				end			
			end
			
			if not found then
				cb(false)
			else
				cb(true)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:addAdvancedLicense')
AddEventHandler('esx_license:addAdvancedLicense', function(target, type, grade, time, cb)
	AddAdvancedLicense(target, type, grade, time, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)