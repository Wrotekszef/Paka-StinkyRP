local categoriesLastUpdateMillis = nil
local categoriesData = nil
local tagsLastUpdateMillis = nil
local tagsData = nil
local citizenTagPrefix = 'lspd.citizen.tag.'
local vehicleTagPrefix = 'lspd.vehicle.tag.'

ESX.RegisterServerCallback('esx_mdc:getAllTags', function(source, cb, target)
	if updateTimeExpired(tagsLastUpdateMillis, Config.expirationCacheMillis) then
		tagsData = MySQL.query.await('SELECT * FROM lspd_mdc_tag_suggestion',  {});
		tagsLastUpdateMillis = now()
	end
	cb(tagsData)
end)

ESX.RegisterServerCallback('esx_mdc:getConvictionCategories', function(source, cb, target)
	if updateTimeExpired(categoriesLastUpdateMillis, Config.expirationCacheMillis) then
		local categories = MySQL.query.await('SELECT id, name as categoryName, color FROM lspd_mdc_judgments_suggestion_category',  {});
		categoriesData = {}
		if categories[1] ~= nil then
			for _, catSuggestion in ipairs(categories) do
				local items = MySQL.query.await('SELECT * FROM lspd_mdc_judgments_suggestion WHERE categoryId = @categoryId', {
					['@categoryId'] = catSuggestion.id
				});
				catSuggestion.items = items
				table.insert(categoriesData, catSuggestion)
			end
		end
		categoriesLastUpdateMillis = now()
	end
	cb(categoriesData)
end)

function updateTimeExpired(timeMillis, expirationMillis)
	return timeMillis == nil or timeMillis <= now() - expirationMillis
end

function now()
	return os.time() * 1000 -- ms
end

ESX.RegisterServerCallback('esx_mdc:getPlayerName', function(source, cb, target, jobName, jobGrade)
	local xPlayer = ESX.GetPlayerFromId(target)
	local resultUser = MySQL.query.await('SELECT * FROM characters WHERE identifier = @identifier',  {
		['@identifier'] = xPlayer.identifier
	});
	local userData = resultUser[1]
	local resultDepartment = MySQL.query.await('SELECT CONCAT(\'(\',job.label,\' - \', grade.label,\')\') as departmentGrade FROM `jobs` job join `job_grades` grade on job.name = grade.job_name WHERE job.name=@job and grade.grade = @job_grade', {
		['job'] = jobName,
		['job_grade'] = jobGrade
	} );
	local departmentData = resultDepartment[1]
	cb(userData.firstname .. ' ' .. userData.lastname, departmentData.departmentGrade)
end)

ESX.RegisterServerCallback('esx_mdc:getCitizensWarrantsList', function(source, cb, target)
	MySQL.query('SELECT CONCAT(FIRSTNAME, \' \', LASTNAME) AS `citizenName`, \'\' AS photo, `sex`, `dateofbirth` AS birthdate FROM `characters` WHERE identifier IN (SELECT userId FROM `user_properties` WHERE value = \'Poszukiwany\')',  {}, 
		function(result)
			local users = result;
			local users = {}
			for _, userData in ipairs(result) do
				if userData.sex == 'm' then
					userData.sex = "Mężczyzna"
				else
					userData.sex = "Kobieta"
				end
				table.insert(users, userData)
			end
			cb(users)
		end
	);
end)

ESX.RegisterServerCallback('esx_mdc:getVehicleByPlate', function(source, cb, plate)
	MySQL.query('SELECT * FROM `owned_vehicles` WHERE LOWER(`plate`) = LOWER(@plate) OR LOWER(REPLACE(`plate`, \' \', \'\')) like LOWER(REPLACE(\'%' .. plate .. '%\', \' \', \'\'))',  {
		['@plate'] = plate
	}, 
		function(vehicleResult)
			local vehicleData = vehicleResult[1]
			if vehicleData == nil then
				cb({})
			else
				local owner = MySQL.query.await('SELECT job, job_grade, CONCAT(FIRSTNAME, \' \', LASTNAME) AS fullName FROM characters WHERE identifier = @owner', {
					['@owner'] = vehicleData.owner
				});
				vehicleData.ownerName = owner[1].fullName

				local notes = MySQL.query.await('SELECT *, DATE_FORMAT(date, "%d/%m/%Y %H:%i:%s") AS date from lspd_mdc_vehicle_notes WHERE vehicleId = @vehicleId ORDER BY date DESC', {
					['vehicleId'] = vehicleData.id
				} );
				if notes == nil then motes = {} end
				vehicleData.mdcNotes = notes

				local lspdTags = MySQL.query.await('SELECT value from vehicle_properties WHERE vehicleId = @vehicleId and name like \'' .. vehicleTagPrefix .. '%\'', {
					['vehicleId'] = vehicleData.id
				});

				vehicleData.modelname = json.decode(vehicleData.vehicle).name

				local lspdVehicleTags = {}
				for _, tag in ipairs(lspdTags) do
					table.insert(lspdVehicleTags, tag.value)
				end
				vehicleData.lspdTags = lspdVehicleTags
				cb(vehicleData)
			end
		end
	);
end)

RegisterServerEvent('esx_mdc:addNewVehicleNote')
AddEventHandler('esx_mdc:addNewVehicleNote', function(vehicleId, noteData)
	MySQL.update.await('INSERT INTO `lspd_mdc_vehicle_notes` (`addedBy`, `text`, `vehicleId`) VALUES (@addedBy, @text, @vehicle)',
	{
		['@addedBy'] = noteData.addedBy,
		['@text']    = noteData.text,
		['@vehicle'] = vehicleId
	})
end)

function GetRPName(playerId, data)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer ~= nil then
		data(xPlayer.character.firstname, xPlayer.character.lastname)
	end
end

RegisterServerEvent('esx_mdc:addNewCitizenConviction')
AddEventHandler('esx_mdc:addNewCitizenConviction', function(playerJobName, citizenId, convictionData)
	local xCitizen = ESX.GetPlayerFromIdentifier(citizenId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dane = (xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname)

	if xCitizen ~= nil then
		local citizenServerId = xCitizen.source
		local jailLength = convictionData.length
		local fee = convictionData.fee
		local crimes = convictionData.crimes
		local sentencespan = 0
		if jailLength == nil or jailLength == 0 then
			xCitizen.removeAccountMoney('bank', fee)
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..xPlayer.job.name, function(account)
				account.addAccountMoney(math.floor(fee * 70 / 100))
				xPlayer.addAccountMoney('bank', math.floor(fee * 30 / 100))
			end)
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
				account.addAccountMoney(math.floor(fee * 1 / 100))
			end)
			GetRPName(citizenServerId, function(firstname, lastname)
				TriggerClientEvent('chatMessage', -1, "^3^*[SĘDZIA] ^4" .. firstname .. " " .. lastname .. "^3 otrzymał mandat w wysokości ^4" .. fee .. "$^3 za ^4" .. crimes)
			end)
			MySQL.query('SELECT * FROM rankingpd WHERE chlop = @chlop', {
				['@chlop'] = dane
			}, function(result)
				local ranks = json.encode(result)
				if (ranks ~= '[]' and ranks ~= nil) then
					MySQL.query('UPDATE rankingpd SET ile = @ile WHERE chlop = @chlop', {
						['@chlop'] = dane,
						['@ile'] = tonumber(result[1].ile)+1
					})
					print('Added +1 to rank pd')
				else
					MySQL.query('INSERT INTO rankingpd (chlop, ile) VALUES (@chlop, @ile)', {
						['@chlop'] = dane,
						['@ile'] = 1
					})
					print('Added new player rank pd')
				end
				exports['exile_logs']:SendLog(source, "Dostał +1 do rankingu z powodu wystawienia mandatu", 'fines', '10181046')
			end)
			exports['exile_logs']:SendLog(source, "Wystawiono mandat dla [" .. citizenServerId .. "] " .. GetPlayerName(citizenServerId) .. ":\nPowód: " .. crimes .. "\nKwota: " .. fee, 'fines', '10181046')
		else
			sentencespan = jailLength
			TriggerEvent('exilerp_scripts:jailonplayerchuj', citizenServerId, jailLength * 60)
			xCitizen.removeAccountMoney('bank', fee)
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..xPlayer.job.name, function(account)
				account.addAccountMoney(fee)
			end)
			GetRPName(citizenServerId, function(firstname, lastname)
				TriggerClientEvent('chatMessage', -1, "^3^*[SĘDZIA] ^4" .. firstname .. " " .. lastname .. "^3 otrzymał karę więzenia: ^4".. jailLength.. " miesięcy ^3za ^4" .. crimes .. "^3 oraz karę o wartości: ^4" .. fee.. '$')
				exports['exile_logs']:SendLog(source, "Obywatel: "..firstname.." "..lastname.."\nWyrok: "..crimes.."\nOtrzymane miesiące: "..jailLength.."\nOtrzymana grzywna: "..fee, 'wyroki', '5793266')
			end)
			MySQL.query('SELECT * FROM rankingpdwyrok WHERE chlop = @chlop', {
				['@chlop'] = dane
			}, function(result)
				local ranks = json.encode(result)
				if (ranks ~= '[]' and ranks ~= nil) then
					MySQL.query('UPDATE rankingpdwyrok SET ile = @ile WHERE chlop = @chlop', {
						['@chlop'] = dane,
						['@ile'] = tonumber(result[1].ile)+1
					})
					print('Added +1 to rank pd')
				else
					MySQL.query('INSERT INTO rankingpdwyrok (chlop, ile) VALUES (@chlop, @ile)', {
						['@chlop'] = dane,
						['@ile'] = 1
					})
					print('Added new player rank pd')
				end
				exports['exile_logs']:SendLog(source, "Dostał +1 do rankingu z powodu wystawienia wyroku", 'fines', '10181046')
			end)
			TriggerEvent('exilerp_pj:unrestplayer', citizenServerId)
			exports['exile_logs']:SendLog(source, "Wysłano [" .. citizenServerId .. "] " .. GetPlayerName(citizenServerId) .. " do więzienia:\nPowód: " .. crimes .. "\nKwota: " .. fee .. "\nCzas: " .. jailLength, 'fines', '15158332')
		end
		--TriggerEvent('srp_logs:jailLog', playerJobName, citizenServerId, crimes, sentencespan)
		-- log history
		MySQL.update.await('INSERT INTO `lspd_user_judgments` (`userId`, `crimes`, `note`, `addedBy`, `length`, `fee`) VALUES (@userId, @crimes, @note, @addedBy, @length, @fee)',
		{
			['@userId']  = citizenId,
			['@crimes']  = convictionData.crimes,
			['@note']    = convictionData.note,
			['@addedBy'] = convictionData.addedBy,
			['@length']  = convictionData.length,
			['@fee']     = convictionData.fee
		})
	end
end)


RegisterServerEvent('esx_mdc:saveVehicle')
AddEventHandler('esx_mdc:saveVehicle', function(vehicleData)
	-- update properties
	MySQL.update.await('DELETE FROM `vehicle_properties` WHERE `vehicleId` = @vehicleId and `name` like \'' .. vehicleTagPrefix .. '%\'',
	{
		['@vehicleId'] = vehicleData.id
	})

	local values = 'INSERT INTO `vehicle_properties` (`vehicleId`, `name`, `value`) VALUES '
	local count = 1
	for _, tag in ipairs(vehicleData.lspdTags) do
		if( count ~= 1 ) then
			values = values .. ', '
		end
		values = values .. '(\'' .. vehicleData.id .. '\', \'' .. vehicleTagPrefix .. count .. '\', \'' .. tag .. '\')'
		count = count + 1
	end
	if count ~= 1 then
		MySQL.update.await(values, {})
	end
end)

ESX.RegisterServerCallback('esx_mdc:getVehiclesWarrantsList', function(source, cb, target)
	MySQL.query('SELECT owner, plate AS plateText, firstmodel AS model, CONCAT(FIRSTNAME, \' \', LASTNAME) AS owner FROM `owned_vehicles` join `characters` on owner = identifier  WHERE id IN (SELECT vehicleId FROM `vehicle_properties` WHERE value = \'Poszukiwany\')',  {}, 
		function(vehicleResult)
			cb(vehicleResult)
		end
	);
end)

MySQL.ready(function()
	MySQL.update.await("DELETE FROM lspd_mdc_user_notes WHERE (DATEDIFF(CURRENT_DATE, date) > 7)")
	--MySQL.update.await("DELETE FROM lspd_mdc_vehicle_notes WHERE (DATEDIFF(CURRENT_DATE, date) > 7)")
end)

ESX.RegisterServerCallback("esx_mdc:getCitizenByID", function(source,cb,id) 
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'offsheriff' then
		local targetPlayer = ESX.GetPlayerFromId(id)
		if targetPlayer and targetPlayer.source ~= 0 then
			MySQL.query("SELECT * FROM characters WHERE identifier = @identifier", {
				["@identifier"] = targetPlayer.getIdentifier()
			}, function(results) 
				local userData = results[1]
				if userData == nil then
					cb({})
				else
					local licenses = MySQL.query.await('SELECT * from user_licenses WHERE owner = @owner', {
						['owner'] = userData.identifier
					} );
					local tempdrive = false 
					local drive = false
					local weapon = false
					for _, license in ipairs(licenses) do
						if license.type == 'drive' then
							drive = true
						end
						if license.type == 'tempdrive' then
							tempdrive = true
						end
						if license.type == 'weapon' then
							weapon = true
						end
					end
					userData.driverLicense = drive and tempdrive
					userData.weaponLicense = weapon

					local resultApartments = MySQL.query.await('SELECT * from owned_properties WHERE owner = @owner', {
						['owner'] = userData.identifier
					} );
					userData.houses = resultApartments

					--[[local resultBusinesses = MySQL.query.await('SELECT * from srp_businesses WHERE owner = @owner', {
						['owner'] = userData.identifier
					} );]]
					userData.businesses = resultBusinesses

					local notes = MySQL.query.await('SELECT *, DATE_FORMAT(date, "%d/%m/%Y %H:%i:%s") AS date from lspd_mdc_user_notes WHERE userId = @owner ORDER BY id DESC', {
						['owner'] = userData.identifier
					} );
					if notes == nil then motes = {} end
					userData.mdcNotes = notes

					local lspdTags = MySQL.query.await('SELECT value from user_properties WHERE userId = @owner and name like \'' .. citizenTagPrefix .. '%\'', {
						['owner'] = userData.identifier
					});

					local lspdUserTags = {}
					for _, tag in ipairs(lspdTags) do
						table.insert(lspdUserTags, tag.value)
					end
					userData.lspdTags = lspdUserTags

					local convictions = MySQL.query.await('SELECT *, DATE_FORMAT(date, "%d/%m/%Y %H:%i:%s") AS date from lspd_user_judgments WHERE userId = @owner ORDER BY date DESC', {
						['owner'] = userData.identifier
					});
					userData.convictions = convictions

					if userData.sex == 'm' then
						userData.sex = "Mężczyzna"
					else
						userData.sex = "Kobieta"
					end
					cb(userData)
				end
			end)
		else
			xPlayer.showNotification("~r~Nie ma gracza o id ~y~["..id.."] ~r~na serwerze!")
		end
	end
end)

ESX.RegisterServerCallback('esx_mdc:getCitizenByName', function(source, cb, citizenName, citizenId)
	local whereClausure
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
		if citizenId ~= nil then
			whereClausure = 'T.identifier = \'' .. citizenId .. '\''
		else
			whereClausure = 'LOWER(T.fullName) like LOWER(\'%' .. citizenName .. '%\')'
		end
		MySQL.query('SELECT * from (select *, CONCAT(FIRSTNAME, \' \', LASTNAME) AS fullName FROM characters) as T WHERE ' .. whereClausure, {}, 
			function(resultUsers)
				local userData = resultUsers[1] -- ignore other results

				if userData == nil then
					cb({})
				else
					if #resultUsers > 1 then
						cb(resultUsers)
					else
						local licenses = MySQL.query.await('SELECT * from user_licenses WHERE owner = @owner', {
							['owner'] = userData.identifier
						} );
						local tempdrive = false 
						local drive = false
						local weapon = false
						for _, license in ipairs(licenses) do
							if license.type == 'drive' then
								drive = true
							end
							if license.type == 'tempdrive' then
								tempdrive = true
							end
							if license.type == 'weapon' then
								weapon = true
							end
						end
						userData.driverLicense = drive and tempdrive
						userData.weaponLicense = weapon

						local resultApartments = MySQL.query.await('SELECT * from owned_properties WHERE owner = @owner', {
							['owner'] = userData.identifier
						} );
						userData.houses = resultApartments

						--[[local resultBusinesses = MySQL.query.await('SELECT * from srp_businesses WHERE owner = @owner', {
							['owner'] = userData.identifier
						} );]]
						userData.businesses = resultBusinesses

						local notes = MySQL.query.await('SELECT *, DATE_FORMAT(date, "%d/%m/%Y %H:%i:%s") AS date from lspd_mdc_user_notes WHERE userId = @owner ORDER BY id DESC', {
							['owner'] = userData.identifier
						} );
						if notes == nil then motes = {} end
						userData.mdcNotes = notes

						local lspdTags = MySQL.query.await('SELECT value from user_properties WHERE userId = @owner and name like \'' .. citizenTagPrefix .. '%\'', {
							['owner'] = userData.identifier
						});

						local lspdUserTags = {}
						for _, tag in ipairs(lspdTags) do
							table.insert(lspdUserTags, tag.value)
						end
						userData.lspdTags = lspdUserTags

						local convictions = MySQL.query.await('SELECT *, DATE_FORMAT(date, "%d/%m/%Y %H:%i:%s") AS date from lspd_user_judgments WHERE userId = @owner ORDER BY date DESC', {
							['owner'] = userData.identifier
						});
						userData.convictions = convictions

						if userData.sex == 'm' then
							userData.sex = "Mężczyzna"
						else
							userData.sex = "Kobieta"
						end
						cb(userData)
					end
				end
		end)
	else
		TriggerEvent('exilerp_scripts:banPlr', "nigger", source, "Tried to open police tablet without job (policemdc)")
		--exports['exile_logs']:SendLog(source, "Próba wywołania tabletu policyjnego bez odpowiedniej pracy", 'anticheat')
	end
end)

RegisterServerEvent('esx_mdc:addNewCitizenNote')
AddEventHandler('esx_mdc:addNewCitizenNote', function(citizenId, noteData)
	MySQL.update.await('INSERT INTO `lspd_mdc_user_notes` (`addedBy`, `text`, `userId`) VALUES (@addedBy, @text, @citizen)',
	{
		['@addedBy'] = noteData.addedBy,
		['@text']    = noteData.text,
		['@citizen'] = citizenId
	})
end)

RegisterServerEvent('esx_mdc:saveCitizen')
AddEventHandler('esx_mdc:saveCitizen', function(citizenData)
	-- update properties
	MySQL.update.await('DELETE FROM `user_properties` WHERE `userId` = @owner and `name` like \'' .. citizenTagPrefix .. '%\'',
	{
		['@owner'] = citizenData.id
	})

	local values = 'INSERT INTO `user_properties` (`userId`, `name`, `value`) VALUES '
	local count = 1
	for _, tag in ipairs(citizenData.lspdTags) do
		if( count ~= 1 ) then
			values = values .. ', '
		end
		values = values .. '(\'' .. citizenData.id .. '\', \'' .. citizenTagPrefix .. count .. '\', \'' .. tag .. '\')'
		count = count + 1
	end
	if count ~= 1 then
		MySQL.update.await(values, {})
	end
end)
