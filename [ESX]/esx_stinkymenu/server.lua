RegisterServerEvent('esx_exilemenu:getUserInfo')
AddEventHandler('esx_exilemenu:getUserInfo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local getCount = CheckCourses(_source)
	local coursesCount = getCount and '('..getCount..')' or ''

	if xPlayer ~= nil then
		TriggerClientEvent('esx_exilemenu:getUserInfo', _source, xPlayer.character.firstname, xPlayer.character.lastname, coursesCount)
	end
end)

function KursyChange(id, number)
	local _id = id
	local xPlayer = ESX.GetPlayerFromId(_id)
	
	local getCount = nil
	if number then
		getCount = number
	else
		getCount = CheckCourses(_id)
	end
	
	local coursesCount = getCount and '('..getCount..')' or ''

	if xPlayer ~= nil then
		TriggerClientEvent('esx_exilemenu:getUserInfo', _id, xPlayer.character.firstname, xPlayer.character.lastname, coursesCount)
	end
end

function CheckCourses(_source)
local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		local results = MySQL.query.await('SELECT courses_count FROM user_courses WHERE identifier = @identifier AND digit = @digit AND secondjob = @job', {
			['@identifier'] = xPlayer.identifier,
			['@digit'] = xPlayer.getDigit(),
			['@job'] = xPlayer.secondjob.name
		})
		if results[1] ~= nil and results[1].courses_count ~= nil then
			return results[1].courses_count
		else
			return nil
		end
	end
end

function getLicense(steamid, callback)
	local xPlayer = ESX.GetPlayerFromIdentifier(steamid)

	local data = {
		weapon = "no",
		drive = "no",
		drive_bike = "no",
		drive_truck = "no",
		ems_insurance = "no",
		oc_insurance = "no"
	}
		
	if xPlayer ~= nil then
		TriggerEvent('esx_license:getLicenses', xPlayer.source, function(result)
			if result ~= nil then
				for i=1, #result, 1 do	
					if result[i].type == "weapon" then
						data.weapon = "yes"
					end
					if result[i].type == "drive" then
						data.drive = "yes"
					end
					if result[i].type == "drive_bike" then
						data.drive_bike = "yes"
					end
					if result[i].type == "drive_truck" then
						data.drive_truck = "yes"
					end
					if result[i].type == "ems_insurance" then
						data.ems_insurance = "yes"
					end
					if result[i].type == "oc_insurance" then
						data.oc_insurance = "yes"
					end
				end
			end
		end)
	end
	
	callback(data)
end

RegisterNetEvent('exile:checkHasLicense', function()
	local _src = source
	local data = ESX.GetPlayerFromid(_src)
	local results = MySQL.query.await('SELECT grade, type FROM user_licenses WHERE owner = ? AND digit = ?', {xPlayer.identifier,xPlayer.getDigit()})
	formatGrade = tonumber(results[1].grade)
	local swatGrades = {
		"Probie Operator",
		"Operator",
		"Advanced Operator",
		"Team Leader",
		"Deputy Chief",
		"Chief"
	}
	
	local sertGrades = {
		"Probie Operator",
		"Operator",
		"Team Leader",
		"Commander"
	}
	
	local dtuGrades = {
		"Probie Detective",
		"Detective",
		"Commander"
	}
	if(results[1].type ~= nil) then
		if(results[1].type == 'dtu') then
			_grade = dtuGrades[formatGrade]
		elseif(results[1].type == 'swat') then
			_grade = swatGrades[formatGrade]
		elseif(results[1].type =='sert') then
			_grade = sertGrades[formatGrade]
		end
		TriggerClientEvent('exile:showLicenseUI', _src, formatGrade, results[1].type)
	end

end)

function CheckInsuranceEMS(job)
	local NNW = false
	if job == nil then
		return false
	end
	local results = MySQL.Sync.prepare('SELECT nnw FROM jobs_insurance WHERE name = ?', {job})
	if results == 0 then
		NNW = false
	else
		if results == 1 then
			NNW = true
		end
	end
	return NNW
end

function CheckInsuranceLSC(job)
	local OC = false
	if job == nil then
		return false
	end

	local results = MySQL.Sync.prepare('SELECT oc FROM jobs_insurance WHERE name = ?', {job})
	if results == nil then
		OC = false
	else
		if results == 1 then
			OC = true
		end
	end
	return OC
end


RegisterServerEvent('menu:id')
AddEventHandler('menu:id', function(type, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	getLicense(xPlayer.identifier, function(data2)
		if data2 ~= nil then
			local bron, kata, katb, katc, ubezmedtext, ubezmehtext
			if data2.weapon == "yes" then
				bron = true
			else
				bron = false
			end
			if data2.drive_bike == "yes" then
				kata = true
			else
				kata = false
			end
			if data2.drive == "yes" then
				katb = true
			else
				katb = false
			end
			if data2.drive_truck == "yes" then
				katc = true
			else
				katc = false
			end
			if data2.ems_insurance == "yes" then
				ubezmedtext = true
			else
				if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance' or xPlayer.job.name == 'mechanik' or xPlayer.job.name == 'offambulance' then
					local HasInsurance = CheckInsuranceEMS(xPlayer.job.name)
					if HasInsurance then
						ubezmedtext = true
					else
						ubezmedtext = false
					end
				else
					local HasInsurance = CheckInsuranceEMS(xPlayer.secondjob.name)

					if HasInsurance then
						ubezmedtext = true
					else
						ubezmedtext = false
					end
				end
			end
			if data2.oc_insurance == "yes" then
				ubezmehtext = true
			else
				if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance' or xPlayer.job.name == 'mechanik' or xPlayer.job.name == 'offambulance' then
					local HasInsurance = CheckInsuranceLSC(xPlayer.job.name)

					if HasInsurance then
						ubezmehtext = true
					else
						ubezmehtext = false
					end
				else
					local HasInsurance = CheckInsuranceLSC(xPlayer.secondjob.name)

					if HasInsurance then
						ubezmehtext = true
					else
						ubezmehtext = false
					end
				end
			end
			TriggerEvent('ReturnSkin', _source, function(data)
				local currentSkin = data
				local MainPlayerCoords = GetEntityCoords(GetPlayerPed(_source))
				if type == 1 then
					TriggerClientEvent('sendProximityMessageID', _source, _source, xPlayer.character, bron, kata, katb, katc, ubezmedtext, ubezmehtext, currentSkin)
				elseif type == 2 then
					if #(GetEntityCoords(GetPlayerPed(id)) - MainPlayerCoords) < 3 then
						TriggerClientEvent('sendProximityMessageID', _source, _source, xPlayer.character, bron, kata, katb, katc, ubezmedtext, ubezmehtext, currentSkin)
						TriggerClientEvent('sendProximityMessageID', id, _source, xPlayer.character, bron, kata, katb, katc, ubezmedtext, ubezmehtext, currentSkin)
					end
				end
			end)
		end
	end)
end)

RegisterNetEvent('menu:phone')
AddEventHandler('menu:phone', function(type, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName     = xPlayer.job.grade_name
	local jobLabel   = xPlayer.job.label
	local gradeLabel = xPlayer.job.grade_label
	if xPlayer ~= nil then
		TriggerEvent('ReturnSkin', _source, function(data)
			local currentSkin = data
			local MainPlayerCoords = GetEntityCoords(GetPlayerPed(_source))
			if type == 1 then
				TriggerClientEvent("sendProximityMessagePhone", _source, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
			elseif type == 2 then
				if #(GetEntityCoords(GetPlayerPed(id)) - MainPlayerCoords) < 3 then
					TriggerClientEvent("sendProximityMessagePhone", _source, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
					TriggerClientEvent("sendProximityMessagePhone", id, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
				end
			elseif type == 3 then
				TriggerClientEvent("sendProximityMessagePhoneDistance", _source, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
			end
		end)
	end
end)

RegisterNetEvent('menu:blacha1')
AddEventHandler('menu:blacha1', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha1", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha2')
AddEventHandler('menu:blacha2', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha2", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha3')
AddEventHandler('menu:blacha3', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha3", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha4')
AddEventHandler('menu:blacha4', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha4", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha5')
AddEventHandler('menu:blacha5', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha5", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha6')
AddEventHandler('menu:blacha6', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha6", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha7')
AddEventHandler('menu:blacha7', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha7", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha8')
AddEventHandler('menu:blacha8', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha8", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha9')
AddEventHandler('menu:blacha9', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.secondjob.label, data.badge) == data.badge then
			jobName = xPlayer.secondjob.grade_name
			jobLabel = xPlayer.secondjob.label
			gradeLabel = xPlayer.secondjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha9", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterCommand("dices", function(source, args, rawCommand)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local Message = ""
		local count = tonumber(args[1])
		if count and count > 0 and count <= 5 then
			if count == 1 then
				local value = math.random(1,6)
				Message = "rzuca kością, wypada [" .. value .. "]"
				TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
				TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
			else
				Message = "rzuca " .. count .. " koścmi i wypada odpowiednio:"
				for i=1, count, 1 do
					local value = math.random(1,6)
					Message = Message .. " [" .. value .. "]"
				end
				TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
				TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
			end
		elseif args[1] == nil then
			local value = math.random(1,6)
			Message = "rzuca kością, wypada [" .. value .. "]"
			TriggerClientEvent('sendProximityMessageDo', -1, source, source, Message)
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, Message, source, {r = 255, g = 152, b = 247, alpha = 255})
		end
	end
end, false)