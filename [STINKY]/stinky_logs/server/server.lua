-- UŻYCIE PO SERVER: exports['exile_logs']:SendLog(source, message, 'channel', 'color')
-- UŻYCIE PO CLIENT: TriggerServerEvent('exile_logs:triggerLog', message, 'channel')

--[[_G.LoadResourceFile = function(...)
	local _source = source
	SendLog(_source, "Gracz próbował załadować plik \nIP: " .. GetPlayerEndpoint(source), 'anticheat')
end]]

SendLog = function(source, text, channel, color)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if channel ~= nil and Config.Webhooks[channel] ~= nil then
		local embed = {}
		if color == nil then
			color = "5793266"
		end
		if _source == nil then
			embed = {
				{
					["avatar_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
					["username"] = "StinkyRP",
					["author"] = {
						["name"] = "StinkyRP - Log System",
						["url"] = "https://exilerp.eu/#glowna",
						["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
					},
					["color"] = color,
					["title"] = "StinkyRP",
					["description"] = text,
					["type"]="rich",
					["footer"] = {
						["text"] = os.date() .. " | StinkyRP - Log System",
						["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
					},
				}
			}
		else
			local steamhex = GetPlayerIdentifiers(_source)[2]
			
			if steamhex ~= nil then
				steamhex = string.sub(steamhex, 9)
				local author = _source .. " - " .. steamhex .. " - " .. GetPlayerName(_source)
				if channel == 'anticheat' or channel == 'connect' or channel == 'disconnect' or channel == 'money' or channel == 'kills' or channel == 'characters' then
				local hex, dc = 'Brak SteamHEX', 'Brak DiscordID'
					for k,v in ipairs(GetPlayerIdentifiers(_source)) do
						if string.sub(v, 1, string.len("steam:")) == "steam:" then
							hex = v
						elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
							dc = v
						end
					end
					author = author .. " | " .. hex .. " | " .. dc
				elseif channel == 'item_give' or channel == 'item_drop' then
					local digit = "Digit: " .. xPlayer.getDigit()
					author = author .. " - " .. digit
				end
				embed = {
					{
						["avatar_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
						["username"] = "StinkyRP",
						["author"] = {
							["name"] = "StinkyRP - Log System",
							["url"] = "https://exilerp.eu/#glowna",
							["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
						},
						["color"] = color,
						["title"] = author,
						["description"] = text,
						["type"]="rich",
						["footer"] = {
							["text"] = os.date() .. " | StinkyRP - Log System",
							["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
						},
					}
				}
			end
		end
		
		PerformHttpRequest(Config.Webhooks[channel], function(err, text, headers) end, 'POST', json.encode({username = 'StinkyRP', avatar_url = 'https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png', embeds = embed}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent('stinky_logs:triggerLog')
AddEventHandler('stinky_logs:triggerLog', function(message, channel)
	local _source = source
	SendLog(_source, message, channel)
end)

AddEventHandler('playerConnecting', function()
    local _source = source
	SendLog(_source, "Gracz łączy się z serwerem", 'connect')
end)
	
AddEventHandler('playerDropped', function(reason)
	local _source = source
	local crds = GetEntityCoords(GetPlayerPed(_source))
	local name = GetPlayerName(_source)
    TriggerClientEvent("stinky_quit", -1, _source, crds, name, reason)
	SendLog(_source, "Gracz wychodzi z wyspy. \nPowód: " .. reason, 'disconnect')
end)		

RegisterServerEvent('stinky_logs:playerDied')
AddEventHandler('stinky_logs:playerDied', function(Killer, Message, Weapon)
	local _source = Killer
	local _src = source

	if Weapon then
		Message = Message .. ' **[' .. Weapon .. ']**'
	end

	local license, license_gracz = '', ''

	if _source then
		for k,v in pairs(GetPlayerIdentifiers(_source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			end
		end
	end

	if _src then
		for k,v in pairs(GetPlayerIdentifiers(_src))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license_gracz = v
			end
		end
	end

	SendLog(_source, Message .. '\n Licencja Zabijającego: **' .. license .. '**\n Licencja Zabitego: **' .. license_gracz .. '**', 'kills')
end)