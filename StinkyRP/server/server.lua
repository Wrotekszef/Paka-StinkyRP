local antytroll = {}
RegisterCommand('cam', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.triggerEvent('route68:kino')
end, false)

RegisterCommand('offhud', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.triggerEvent('route68:kino2')
end, false)

ESX.RegisterServerCallback('esx_falszywyy:getVehicleFromPlate', function(source, cb, plate)
	MySQL.query('SELECT owner, digit FROM owned_vehicles WHERE plate = ?', { plate}, function(result)
	
		if result[1] ~= nil then
			MySQL.query('SELECT `firstname`, `lastname`, `height`, `sex`, `dateofbirth` FROM characters WHERE identifier = ? AND digit = ?', { result[1].owner,result[1].digit}, function(result2)
				local lspdTags = MySQL.query.await('SELECT value from user_properties WHERE userId = ? and value=?', {result[1].owner, 'Poszukiwany'});
				
				local data = {
					owner = result2[1].firstname .. ' ' .. result2[1].lastname,
					sex = (result2[1].sex == 'm' and 'Mężczyzna' or 'Kobieta'),
					height = result2[1].height,
					dob = result2[1].dateofbirth,
					poszukiwany = lspdTags[1] ~= nil
				}
				cb(data)
			end)
		else
			cb('Nieznany')
		end
	end)
end)

RegisterNetEvent('ExileRP:saveCours')
AddEventHandler('ExileRP:saveCours', function(job, job_grade, source)
    local _source = source
	local identifier = ESX.GetPlayerFromId(_source).identifier
    local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.query.await("SELECT courses_count, courses_count_secound FROM user_courses WHERE identifier = ? AND digit = ? AND secondjob = ?", { identifier,xPlayer.getDigit(), job})
    if result[1] == nil then
        MySQL.update('INSERT INTO user_courses (identifier, firstname, lastname, digit, courses_count, courses_count_secound, secondjob, secondjob_grade) VALUES (@identifier, @firstname, @lastname, @digit, @courses_count, @courses_count_secound, @job, @job_grade)', 
        {
            ['@identifier'] = identifier,
            ['@firstname'] = xPlayer.character.firstname,
            ['@lastname'] = xPlayer.character.lastname,
            ['@digit'] = xPlayer.getDigit(),
            ['@courses_count'] = 1,
            ['@courses_count_secound'] = 1,
            ['@job'] = job,
            ['@job_grade'] = job_grade,
        })
    else
        local kursCount = result[1].courses_count
        local kursCount_secound = result[1].courses_count_secound
        MySQL.update('UPDATE user_courses SET courses_count=@courses_count, courses_count_secound=@courses_count_secound, secondjob_grade = @job_grade WHERE identifier = @identifier AND digit = @digit and secondjob = @job', 
        {
            ['@identifier'] = identifier,
            ['@digit'] = xPlayer.getDigit(),
            ['@courses_count'] = kursCount + 1,
            ['@courses_count_secound'] = kursCount_secound + 1,
            ['@job_grade'] = job_grade,
            ['@job'] = job,
        })
    end
	
    exports['esx_exilemenu']:KursyChange(_source, kursCount)
end)

ESX.RegisterServerCallback('ExileRP:getCourses', function(source, cb, job)
	MySQL.query('SELECT secondjob_grade, firstname, lastname, courses_count FROM user_courses WHERE secondjob = ? ORDER BY secondjob_grade DESC', {job}, function (results)
		if results[1] ~= nil then
			cb(results)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterUsableItem('coke_pooch', function(source)
	local src = source
    local data = ESX.GetPlayerFromId(src)
    


	data.removeInventoryItem('coke_pooch', 1)
    TriggerClientEvent('exilerp_scripts:onSpecialUse', src, 'coke')
end)

ESX.RegisterUsableItem('meth_pooch', function(source)
	local src = source
    local data = ESX.GetPlayerFromId(src)
    


	data.removeInventoryItem('meth_pooch', 1)
    TriggerClientEvent('exilerp_scripts:onSpecialUse', src, 'meth')
end)

ESX.RegisterUsableItem('wybielacz', function(source)
	local src = source
    local data = ESX.GetPlayerFromId(src)
    
	data.removeInventoryItem('wybielacz', 1)
    TriggerClientEvent('exilerp_scripts:onSpecialUse', src, 'wybielacz')
end)

RegisterCommand('giveallitem', function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if src then
        if xPlayer.group == 'best' then
            local graczedolisty = ESX.GetPlayers() -- Jak się nie używa tego w pętli to nie laguje jak coś ;3
            local xPlayers = ESX.GetExtendedPlayers()
            local item    = args[1]
            local count   = (args[2] == nil and 1 or tonumber(args[2]))
            local list = json.encode(graczedolisty)

            exports['exile_logs']:SendLog(src, "Data: " ..os.date().. "\nLista ID które otrzymają item: " ..list, 'giveallitem', '15158332')

            for i=1, #xPlayers, 1 do
                local xPlayer = xPlayers[i]
                if ESX.GetItemLabel(item) ~= nil then
                    Wait(10000)
                    if xPlayer then
                        xPlayer.addInventoryItem(item, count)
                        exports['exile_logs']:SendLog(src, "Administrator z danymi w tytule użył komendy /giveallitem\nGracz o ID: " ..xPlayer.source.. " otrzymał item o respname: " ..item.. " w ilości: " ..count, 'giveallitem', '15158332')
                    end
                end	
            end
        end
    end
end)

RegisterServerEvent('k:sendNotif', function(text)
    local _src = source
    local color = {r = 255, g = 152, b = 247, alpha = 255}
    TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _src, color)
    TriggerClientEvent("sendProximityMessageMe", -1, _src, _src, text)
end)

RegisterServerEvent('tmsn701_antytroll:register', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE `users` SET `antytroll` = @antytroll WHERE identifier = @identifier', {
		['@antytroll']	= 1,
		['@identifier']	= xPlayer.identifier
	})
	TriggerClientEvent("tmsn701_antytroll:load", xPlayer.source, 1)
	antytroll[xPlayer.source] = 1
	TriggerEvent("esx_scoreboard:antytroll", xPlayer.source, true)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT antytroll FROM `users` WHERE `identifier` = @identifier LIMIT 1', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
        if tonumber(result[1].antytroll) then
            if tonumber(result[1].antytroll) > 0 then
                TriggerEvent("tmsn701_antytroll:load", xPlayer, tonumber(result[1].antytroll))
            end
        end
    end)
end)

AddEventHandler('tmsn701_antytroll:load', function(xPlayer, czas)
	TriggerClientEvent("tmsn701_antytroll:load", xPlayer.source, czas)
	antytroll[xPlayer.source] = czas
	TriggerEvent("esx_scoreboard:antytroll", xPlayer.source, true)
end)

AddEventHandler("playerDropped", function(reason)
	local identifier = GetPlayerIdentifier(source, 0)
	if antytroll[source] then
		MySQL.Async.execute('UPDATE `users` SET `antytroll` = @antytroll WHERE identifier = @identifier', {
			['@antytroll']	= antytroll[source],
			['@identifier']	= identifier
		})
	end
	antytroll[source] = nil
end)

RegisterServerEvent('tmsn701_antytroll:update')
AddEventHandler('tmsn701_antytroll:update', function(xd)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type(xd) == "number" then
		antytroll[source] = xd
		if antytroll[source] == 0 then
			antytroll[source] = nil
			MySQL.Async.execute('UPDATE `users` SET `antytroll` = @antytroll WHERE identifier = @identifier', {
				['@antytroll']	= 0,
				['@identifier']	= xPlayer.identifier
			})
			TriggerEvent("esx_scoreboard:antytroll", source, false)
		end
	else
		exports['esx_k9']:ban(_source, type(xd).." w anty-trollu.")
	end
end)



function saveantytroll(id, cb)
	local asyncTasks = {}
	if antytroll[id] then
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer then
			table.insert(asyncTasks, function(cb2)
				MySQL.Async.execute('UPDATE `users` SET `antytroll` = @antytroll WHERE identifier = @identifier', {
					['@antytroll']	= antytroll[id],
					['@identifier']	= xPlayer.identifier
				}, function(rowsChanged)
					cb2()
				end)
			end)
		end
	end
	Async.parallel(asyncTasks, function(results)
		if cb then
			cb()
		end
	end)
end

function SaveAllAntyTrolls()
	local asyncTasks = {}
	local time = os.time()
	local count = 0

	for _, playerId in ipairs(GetPlayers()) do
		if antytroll[tonumber(playerId)] then
			count = count + 1
			table.insert(asyncTasks, function(cb)
				saveantytroll(tonumber(playerId), cb)
			end)
		end
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		if count > 0 then
			print(('^2[TomsonAntyTroll]^0 Zapisano antytrolla ^5%s^7 %s w ^5%s^7 ms - ^5%s^7'):format(count, count > 1 and 'graczy' or 'gracza', ESX.Math.Round((os.time() - time) / 1000000, 2), os.date("%H:%M %d/%m/%Y")))
		end
	end)
end

CreateThread(function()
	Wait(30000)
	while(true) do
		Citizen.Wait(15 * 60 * 1000)
		SaveAllAntyTrolls()
	end
end)

RegisterCommand("zapiszat", function(source, args, rawCommand)
	if source == 0 then
		SaveAllAntyTrolls()
	end
end, true)

RegisterCommand('cleartroll', function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if src then
        if xPlayer.group == 'best' then
            local player = tonumber(args[1]) or source
            local xPlayer = ESX.GetPlayerFromId(player)
            MySQL.Async.execute('UPDATE `users` SET `antytroll` = @antytroll WHERE identifier = @identifier', {
                ['@antytroll']	= 0,
                ['@identifier']	= xPlayer.identifier
            })
            TriggerClientEvent("tmsn701_antytroll:clear", player)
            antytroll[player] = nil
            TriggerEvent("esx_scoreboard:antytroll", player, false)
        end
    end
end)

