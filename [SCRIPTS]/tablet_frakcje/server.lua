local mandatAmount = nil

function SendLog(name, message, color)
	local embeds = {
		{
			["avatar_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			["username"] = "ExileRP",
			["author"] = {
				["name"] = "ExileRP - Log System",
				["url"] = "https://exilerp.eu/#glowna",
				["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			},
			["color"] = color,
			["title"] = "ExileRP",
			["description"] = message,
			["type"]="rich",
			["footer"] = {
				["text"] = os.date() .. " | ExileRP - Log System",
				["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			},
		}
	}
	
	if message == nil or message == '' then return false end
	
	local webhook = 'https://discord.com/api/webhooks/1018551863509004310/cni_0GHAx-yGURnLzOWXSvaFdXEqnHy9TPo3VLBb4BqXUXVUn1673Ht4zJxds5aYX5Ji'
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function SendSAMSLog(name, message, color)
	local embeds = {
		{
			["avatar_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			["username"] = "ExileRP",
			["author"] = {
				["name"] = "ExileRP - Log System",
				["url"] = "https://exilerp.eu/#glowna",
				["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			},
			["color"] = color,
			["title"] = "ExileRP",
			["description"] = message,
			["type"]="rich",
			["footer"] = {
				["text"] = os.date() .. " | ExileRP - Log System",
				["icon_url"] = "https://cdn.discordapp.com/attachments/987789713102499923/988879893049786428/favicon.png",
			},
		}
	}
	if message == nil or message == '' then return false end
	
	local webhook = 'https://discord.com/api/webhooks/950713012120080435/MaK0YWrbdgb7RD5XbdiyV9xLvnn2Ubvi07zRpSnVoqiJvy2AEQSXg0FLWgNzr4CjhaOc'
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('tablet_frakcje:SendMessage')
AddEventHandler('tablet_frakcje:SendMessage', function(target, mandatAmount, mandatReason)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local mandat = tonumber(mandatAmount)
	local dane = (sourceXPlayer.character.firstname .. ' ' .. sourceXPlayer.character.lastname)

	if sourceXPlayer.job.name == 'ambulance' or sourceXPlayer.job.name == 'offambulance'or sourceXPlayer.job.name == 'gheneraugarage' or sourceXPlayer.job.name == 'offgheneraugarage' or sourceXPlayer.job.name == 'offmechanik' or sourceXPlayer.job.name == 'mechanik' or sourceXPlayer.job.name == 'offdoj' or sourceXPlayer.job.name == 'doj' then
		local society = 'society_'..sourceXPlayer.job.name

		if sourceXPlayer.job.name == 'ambulance' then
			society = 'society_sams2'
		end

		TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
			if account then
				account.addAccountMoney(mandat)
			end
		end)

		targetXPlayer.removeAccountMoney('bank', mandat)
		sourceXPlayer.addAccountMoney('bank', mandat * 0.40)

		sourceXPlayer.showNotification('~g~Wystawiłeś fakturę na kwotę: ' ..mandat.. ' dla ID: '..targetXPlayer.source)
		targetXPlayer.showNotification('~g~Otrzymałeś fakturę na kwotę: ' ..mandat.. ' od ID: '..sourceXPlayer.source)

		SendLog("ExileRP - Log System", "**Faktura "..sourceXPlayer.job.label..":**\n\n**Kto wystawił:** " ..GetPlayerName(_source).. " + " ..sourceXPlayer.identifier.. "**\nID:** " .._source.. "**\n\nKto otrzymał:** " ..GetPlayerName(target).. "**\nID:** " ..target.. "**\nTreść: **" ..mandatReason.. "**\nIlość: **" ..mandat.."$", 5793266)

		if sourceXPlayer.job.name == 'ambulance' then
			SendSAMSLog("ExileRP - Log System", "**Faktura "..sourceXPlayer.job.label..":**\n\n**Kto wystawił:** " ..GetPlayerName(_source).. " + " ..sourceXPlayer.identifier.. "**\nID:** " .._source.. "**\n\nKto otrzymał:** " ..GetPlayerName(target).. "**\nID:** " ..target.. "**\nTreść: **" ..mandatReason.. "**\nIlość: **" ..mandat.."$", 5793266)
			MySQL.query('SELECT * FROM rankingsams WHERE chlop = @chlop', {
				['@chlop'] = dane
			}, function(result)
				local ranks = json.encode(result)
				if (ranks ~= '[]' and ranks ~= nil) then
					MySQL.query('UPDATE rankingsams SET ile = @ile WHERE chlop = @chlop', {
						['@chlop'] = dane,
						['@ile'] = tonumber(result[1].ile)+1
					})
					print('Added +1 to rank sams')
				else
					MySQL.query('INSERT INTO rankingsams (chlop, ile) VALUES (@chlop, @ile)', {
						['@chlop'] = dane,
						['@ile'] = 1
					})
					print('Added new player rank sams')
				end
				exports['exile_logs']:SendLog(source, "Dostał +1 do rankingu sams z powodu wystawienia faktury", 'fines', '10181046')
			end)
		else
			exports['esx_society']:SendLog(sourceXPlayer.job.name, "", "**Faktura "..sourceXPlayer.job.label..":**\n\n**Kto wystawił:** " ..GetPlayerName(_source).. " + " ..sourceXPlayer.identifier.. "**\nID:** " .._source.. "**\n\nKto otrzymał:** " ..GetPlayerName(target).. "**\nID:** " ..target.. "**\nTreść: **" ..mandatReason.. "**\nIlość: **" ..mandat.."$", '5793266')
		end
	else
		TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to give invoice (tablet_frakcje) (tmsn)")
	end

end)

RegisterNetEvent('exile_ban')
AddEventHandler('exile_ban', function()
	local src = source
	TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to give invoice (tablet_frakcje)")
end)