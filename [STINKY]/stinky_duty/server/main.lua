RegisterServerEvent('e-duty:setJob')
AddEventHandler('e-duty:setJob', function(job, status)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local grade = xPlayer.getJob().grade
	local praca = xPlayer.getJob().name
	if praca == job or praca == "off"..job then
		if status == true then
			xPlayer.setJob(job, grade)
			exports['exile_logs']:SendLog(_source, "Gracz: " ..xPlayer.name.. " wszedł na służbę\n Praca: " ..praca, 'duty', '5793266')
		elseif status == false then
			xPlayer.setJob('off' .. job, grade)
			exports['exile_logs']:SendLog(_source, "Gracz: " ..xPlayer.name.. " zszedł ze służby\n Praca: " ..praca, 'duty', '5793266')
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", _source,  "Tried to change job (exile_duty)")
	end		
end)

AddEventHandler("playerDropped", function(reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local allowedjob = {
		['police'] = true,
		['ambulance'] = true,
		['mechanik'] = true,
		['gheneraugarage'] = true,
		['fire'] = true,
		['doj'] = true,
		['k9'] = true,
		['cardealer'] = true,
		['sheriff'] = true,
	}
	Wait(1000)
	if xPlayer ~= nil then
		if allowedjob[xPlayer.job.name] then
			MySQL.update('UPDATE users SET job = @job WHERE identifier = @identifier', {
				['@job'] = 'off'..xPlayer.job.name,
				['@identifier'] = xPlayer.identifier
			})
		end
	end
end)