local infa = {}
RegisterServerEvent("s4-render:fetch")
AddEventHandler("s4-render:fetch", function()
	if infa[source] == nil then 
        infa[source] = true
		TriggerClientEvent("s4-render:get", source, Config)
	else
		exports['esx_k9']:ban(source,"Gracz wyciąga webhooki do nagrywania.")
	end
end)

RegisterNetEvent("esx_k9:video")
AddEventHandler('esx_k9:video', function(dane)
	print(source, json.encode(dane))
	videomsg(source, "Nagranie wywołane przez: "..dane.admin.."\n\n"..dane.video, dane.video)
end)

function videomsg(id,powod)
	if not GetPlayerName(id) then return end
	PerformHttpRequest(Config.VideoWebhook, function()
	end, "POST", json.encode({
		embeds = {
			{
				author = {
					name = "ExileRP"
				},
				title = "VIDEO",
				description = "**Nick:** "..GetPlayerName(id).."\n**ServerID:** "..id.."\n**Powód:** "..powod,
				color = 2067276
			}
		}
		
	}), {
		["Content-Type"] = "application/json"
	})  
end


RegisterServerEvent("EasyAdmin:TakeVideo", function(playerId)
	local src=source
	local playerId = playerId
	if IsPlayerAceAllowed(src, "easyadmin.spectate") then
		TriggerClientEvent("s4-render:addNewTask", playerId, GetPlayerName(src), 10*1000)
	end
end)