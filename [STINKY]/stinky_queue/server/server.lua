ESX	= nil
TriggerEvent('exile:getsharedobject', function(obj) ESX = obj end)

WhiteList = {}
BanList = {}
BackList = {}
players = {}
waiting = {}
connecting = {}
disconnected = {}
allTickets = {}
firstDisconnected = {}
nextPlayer = nil
nextPushed = nil
tick = 1
isRestarting = false

EmojiList = Config.EmojiList

local UbWebhook = 'https://discord.com/api/webhooks/1021447100770299924/MhPAvvO_f0Ub4PC9tTMwCqUcjrePp2ozozV0n8EczMl1btW3IVFs7ihlmW1aqlONiVh8'
local BanWebhook = 'https://discord.com/api/webhooks/1021447065294884974/AiP_lvT7JtKkD1UJGnC_u4calEQhbzM8d5UK2Ebd28SVJ0gYmvId1G0W6USz2nehjIBt'
local BiletWebhook = 'https://discord.com/api/webhooks/1021447138405785660/SelnXw6Dm58tbO7wgAwyWLNBmK-eMjbLYnqrG3AJcYabjGC_dsM67B4lCR7IIzpfNrPJ'
local WLaddWebhook = 'https://discord.com/api/webhooks/1021447187407835286/jQRtHdmXwsUgz1o6kjQbOVsVQ2uDRyubMSQ5lHWKOGw0eeAFoXzKmP0RDjyiuy4k9xo1'
local BanRoomKurwa = "https://discord.com/api/webhooks/1061270522899480647/NYLDy78ZrH8wTukixcjIfDpMY9ykUb77sMI-HjJfaKOK-VmGYvLpZsvKupv1A13XtmFn"
local UnBanyKurwaChuj = 'https://discord.com/api/webhooks/1062492197481615391/IIZ2D3oxdBkI_eMBcH3AorKeNRTahopyDeYS7a_zfHroBfUm78svem9x4OWNnqZ44v69'

local FormattedToken = "Bot OTQ2ODQ0ODc0OTQ1MjA4MzIw.GbX71X.D_F9ZIOAjF5BVnDlfOBHhzwsSns5Y7eItIOUgE"

whitelistRoles = {
	"639605531652259871",
	"819759720843837472", 
	"913959066005549106"
}

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetRoles(discordId)
	discordId = string.gsub(discordId, "discord:", "")
	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format("636664145554571308", discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			return roles
		else
			return false
		end
	else
		return false
	end
end

StopResource('hardcap')

RegisterServerEvent('exile_queue:isRestarting')
AddEventHandler('exile_queue:isRestarting', function(boolean)
	local src = source
	if src and src ~= 0 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Tried to set isRestarting [exile_queue]")
	end
end)

-- AddEventHandler('onResourceStop', function(resource)
-- 	if resource == GetCurrentResourceName() then
-- 		if GetResourceState('hardcap') == 'stopped' then
-- 			StartResource('hardcap')
-- 		end
-- 	end
-- end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
			isRestarting = true
            ESX.SavePlayers()
			ESX.SaveItems()
			TriggerEvent('es_extended:DoUpdateItems')
			Wait(5000)
			local xPlayers = ESX.GetPlayers()
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				DropPlayer(xPlayer.source, "Zaćmienie! Oczekuj na bilet powrotny.")
			end
        end)
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
    ESX.SavePlayers()
	ESX.SaveItems()
	TriggerEvent('es_extended:DoUpdateItems')
end)

AddEventHandler("playerConnecting", function(name, reject, def)
	local source	= source
	local steamID = GetSteamID(source)
	local discordID = GetDiscordID(source)
	local licenseID = GetLicenseID(source)
	print("^4[ExileRP] ^4"..GetPlayerName(source).." ^7Wchodzi na serwer.")
	if not steamID then
		reject(Config.NoSteam)
		CancelEvent()
		return
	end

	--if #WhiteList == 0 then
	--	def.done(Config.WhitelistNotLoaded)
	--	CancelEvent()
		--return
--	end
	
	--if #BanList == 0 then
	--	def.done(Config.BanlistNotLoaded)
	--	CancelEvent()
--  return
	--end
	
	if not Rocade(steamID, discordID, licenseID, def, source) then
		CancelEvent()
	end
end)

function AddBan(data)
	table.insert(BanList, data)
end

CreateThread(function()
	while true do
		Wait(10000)
		SetConvarServerInfo("Kolejka", tostring(#waiting))
	end
end)

CreateThread(function()
	local maxServerSlots = GetConvarInt('sv_maxclients', 500)
	while true do
		Wait(Config.TimerCheckPlaces * 1000)
		CheckConnecting()
		
		if #waiting > 0 and #connecting + GetNumPlayerIndices() == maxServerSlots and nextPlayer == nil then
			if nextPushed == nil then
				FindNext()
			else
				nextPlayer = nextPushed
				nextPushed = nil
			end
		end
		if #waiting > 0 and GetNumPlayerIndices() < maxServerSlots then
			ConnectFirst()
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		if #firstDisconnected > 0 then
			for k,v in pairs(firstDisconnected) do
				local now = os.time()
				if v[2] < now then
					nextPlayer = nil
					table.remove(firstDisconnected, k)
				end
			end
		else
			Wait(20000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		if #disconnected > 0 then
			for k,v in pairs(disconnected) do
				local now = os.time()
				if v[2] < now then
					table.remove(disconnected, k)
				end
			end
		else
			Wait(20000)
		end
	end
end)

RegisterServerEvent("exile_queue:playerKicked")
AddEventHandler("exile_queue:playerKicked", function(src, points)
	local sid = GetSteamID(src)
	Purge(sid)
end)

RegisterServerEvent("exile_queue:playerConnected")
AddEventHandler("exile_queue:playerConnected", function()
	local sid = GetSteamID(source)
	Purge(sid)
end)

AddEventHandler("playerDropped", function(reason)
	local steamID = GetSteamID(source)
	local backTicket = GetPlayerBackTicket(steamID)
	
	if backTicket == 1 then
		table.insert(disconnected, {steamID, (os.time() + 75)})
	end
	Purge(steamID)
end)

MySQL.ready(function()
	loadWhiteList()
	loadBanList()
end)

ESX.RegisterCommand('unban', {'mod', 'starszymod', 'starszyadmin', 'superadmin', 'admin', 'partner'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	local nickxd = ""
	local discordxd = ""
	if args.steamid then
		MySQL.update('UPDATE exile_bans SET isBanned=0 WHERE license=@license',
		{
			['@license']  = 'license:' .. args.steamid
		},function()
			for i=1, #BanList, 1 do
				if BanList[i] and BanList[i].license and (tostring(BanList[i].license)) == 'license:' .. tostring(args.steamid) then
					nickxd = BanList[i].name
					if BanList[i].discord then
						discordxd = BanList[i].discord
					else
						discordxd = args.steamid
					end
					table.remove(BanList, i)
				end
			end
			if xPlayer then
				xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został odbanowany!')
				local administrator = GetPlayerName(xPlayer.source)
				local date = os.date('*t')	
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local UbEmbded = {
					{
						["color"] = 8663865,
						["title"] = "UNBAN",
						["description"] = "Gracz: **license:"..args.steamid.."** został odbanowany/a przez **"..administrator.."**",
						["footer"] = {
						["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
				PerformHttpRequest(UbWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = UbEmbded}), { ['Content-Type'] = 'application/json' })
				if nickxd ~= "" then
					local wiadomosc = "Gracz: "..nickxd.."\nPrzez: "..administrator
					SendWebhookUnBanMessage(wiadomosc, "<@"..string.gsub(discordxd, "discord:", "")..">")
				end
			else
				local prompt = 'PROMPT'
				local date = os.date('*t')				
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local UbEmbded2 = {
					{
						["color"] = 8663865,
						["title"] = "UNBAN",
						["description"] = "Gracz: **license:"..args.steamid.."** został odbanowany/a przez **"..prompt.."**",
						["footer"] = {
						["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
				PerformHttpRequest(UbWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = UbEmbded2}), { ['Content-Type'] = 'application/json' })
				if nickxd ~= "" then
					local wiadomosc = "Gracz: "..nickxd.."\nPrzez: "..prompt
					SendWebhookUnBanMessage(wiadomosc, "<@"..string.gsub(discordxd, "discord:", "")..">")
				end
			end
		end)
	end
end, true, {help = "Komenda do odbanowywania gracza", validate = true, arguments = {
	{name = 'steamid', help = "Licencja steam", type = 'string'}
}})

ESX.RegisterCommand('banhex', {'mod', 'starszymod', 'starszyadmin', 'superadmin', 'admin', 'best', 'support', 'partner'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if args.steamid and tonumber(args.czas) and args.powod then
		local steamFound = false
		local steamID = args.steamid:lower()
		local tPlayer = ESX.GetPlayerFromIdentifier(steamID)
		if string.find(steamID, 'steam:') then
			steamFound = true
			if xPlayer then
				xPlayer.showNotification('[EXILE-QUEUE] ~o~Nie możesz zbanować użytkownika po steam ID. Użyj jego licencji!')
			end
		end
		if tPlayer and steamFound == false then
			local license, identifier, liveid, xblid, discord, playerip, targetName = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end

			local tokens = {}
            for i = 0, GetNumPlayerTokens(tPlayer.source) - 1 do 
                table.insert(tokens, GetPlayerToken(tPlayer.source, i))
            end
            tokens = json.encode(tokens)
			
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
			targetName = GetPlayerName(tPlayer.source)
		
			for k,v in ipairs(GetPlayerIdentifiers(tPlayer.source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
				elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
					identifier = v
				elseif string.sub(v, 1, string.len("live:")) == "live:" then
					liveid = v
				elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
					xblid  = v
				elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
					discord = v
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					playerip = v
				end
			end
			MySQL.update('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@identifier'] = identifier,
				['@license'] = license,
				['@playerip'] = playerip,
				['@name'] = targetName,
				['@discord'] = discord,
				['@hwid'] = tokens,
				['@reason'] = reason,
				['@live'] = liveid,
				['@xbl'] = xblid,
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					identifier = identifier,
					license = license,
					playerip = playerip,
					name = targetName,
					discord = discord,
					hwid = tokens,
					reason = reason,
					added = currentDate,
					live = liveid,
					xbl = xblid,
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
				
				local BanEmbded = {
					{
						["color"] = 8663865,
						["title"] = "BAN - LICENSE",
						["description"] = "**Kto:** "..targetName.." \n **Hex:** "..identifier.." \n **Licencja:** "..license.." \n **Discord:** "..discord.." \n **IP:** "..playerip.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
							["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded}), { ['Content-Type'] = 'application/json' })
				local wiadomosc = "Gracz: "..targetName.."\nPowód: "..reason.."\nPrzez: "..bannedby.."\nCzas Trwania: "..(args.czas == -1 and "PERM" or args.czas.."h")
				SendWebhookBanMessage(wiadomosc, "<@"..string.gsub(discord, "discord:", "")..">")
			end)
			
			if args.czas == -1 then
				DropPlayer(tPlayer.source, "Zostałeś zbanowany permanentnie na tym serwerze przez " .. bannedby .. ". Powód: " .. reason)
			else
				DropPlayer(tPlayer.source, "Zostałeś zbanowany przez " .. bannedby .. ". Powód: " .. reason)
			end
		elseif not tPlayer and steamFound == false then
			local license, identifier, liveid, xblid, discord, playerip = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
			MySQL.update('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@license'] = 'license:' .. steamID,
				['@identifier'] = "nieznane",
				['@playerip'] = "nieznane",
				['@name'] = "nieznane",
				['@discord'] = "nieznane",
				['@reason'] = reason,
				['@live'] = "nieznane",
				['@xbl'] = "nieznane",
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					license = 'license:' .. steamID,
					identifier = "nieznane",
					playerip = "nieznane",
					name = "nieznane",
					discord = "nieznane",
					reason = reason,
					added = currentDate,
					live = "nieznane",
					xbl = "nieznane",
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BanEmbded1 = {
					{
						["color"] = 8663865,
						["title"] = "BAN - LICENSE",
						["description"] = "**Kto:** Gracz Offline \n **Licencja:** license:"..steamID.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
							["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}

				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded1}), { ['Content-Type'] = 'application/json' })
				local wiadomosc = "Gracz: "..steamID.."\nPowód: "..reason.."\nPrzez: "..bannedby.."\nCzas Trwania: "..(args.czas == -1 and "PERM" or args.czas.."h")
				SendWebhookBanMessage(wiadomosc, "<@"..string.gsub(discord, "discord:", "")..">")
			end)
		end
	end
end, true, {help = "Komenda do banowania hex gracza", validate = true, arguments = {
	{name = 'steamid', help = "Licencja steam (bez license:)", type = 'string'},
	{name = 'czas', help = "Czas w godzinach", type = 'number'},
	{name = 'powod', help = "Powód -> użyj cudzysłowia", type = 'string'}
}})

ESX.RegisterCommand('bancheater', {'superadmin', 'best', 'partner'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if args.licenseid and args.steamid and args.discordid and tonumber(args.czas) and args.powod then
		local licencjarockstar = args.licenseid:lower()
        local steamid = args.steamid:lower()
        local discordid = args.discordid:lower()
		local tPlayer = ESX.GetPlayerFromIdentifier(licencjarockstar)
		if not tPlayer then
			local license, identifier, liveid, xblid, discord, playerip = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
			MySQL.update('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@license'] = 'license:' .. licencjarockstar,
				['@identifier'] = 'steam:' .. steamid,
				['@playerip'] = "nieznane",
				['@name'] = "nieznane",
				['@discord'] = 'discord:' .. discordid,
				['@reason'] = reason,
				['@live'] = "nieznane",
				['@xbl'] = "nieznane",
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					license = 'license:' .. licencjarockstar,
					identifier = 'steam:' .. steamid,
					playerip = "nieznane",
					name = "nieznane",
					discord = 'discord:' .. discordid,
					reason = reason,
					added = currentDate,
					live = "nieznane",
					xbl = "nieznane",
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Cheater został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BanEmbded1 = {
					{
						["color"] = 8663865,
						["title"] = "BAN - LICENSE",
						["description"] = "**Kto:** CHEATER \n **Licencja:** license:"..licencjarockstar.." \n **HEX:** steam:"..steamid.." \n **DISCORDID:** discord:"..discordid.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
							["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}	
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded1}), { ['Content-Type'] = 'application/json' })
			end)
		end
	end
end, true, {help = "Komenda do banowania cheatera", validate = true, arguments = {
	{name = 'licenseid', help = "Licencja fivem (bez license:)", type = 'string'},
    {name = 'steamid', help = "Licencja steam (bez steam:)", type = 'string'},
    {name = 'discordid', help = "Discord ID (bez discord:)", type = 'string'},
	{name = 'czas', help = "Czas w godzinach", type = 'number'},
	{name = 'powod', help = "Powód -> użyj cudzysłowia", type = 'string'}
}})

ESX.RegisterCommand('banid', {'mod', 'starszymod', 'starszyadmin', 'superadmin', 'admin' , 'best', 'support', 'partner'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if tonumber(args.id) and tonumber(args.czas) and args.powod then
		local tPlayer = ESX.GetPlayerFromId(tonumber(args.id))
		if tPlayer then
			local license, identifier, liveid, xblid, discord, playerip = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local targetName = GetPlayerName(tPlayer.source)
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end

			local tokens = {}
            for i = 0, GetNumPlayerTokens(tPlayer.source) - 1 do 
                table.insert(tokens, GetPlayerToken(tPlayer.source, i))
            end
            tokens = json.encode(tokens)
			
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
		
			for k,v in ipairs(GetPlayerIdentifiers(tPlayer.source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
				elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
					identifier = v
				elseif string.sub(v, 1, string.len("live:")) == "live:" then
					liveid = v
				elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
					xblid  = v
				elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
					discord = v
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					playerip = v
				end
			end
			MySQL.update('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@identifier'] = identifier,
				['@license'] = license,
				['@playerip'] = playerip,
				['@name'] = targetName,
				['@discord'] = discord,
				['@hwid'] = tokens,
				['@reason'] = reason,
				['@live'] = liveid,
				['@xbl'] = xblid,
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					identifier = identifier,
					license = license,
					playerip = playerip,
					name = targetName,
					discord = discord,
					hwid = tokens,
					reason = reason,
					added = currentDate,
					live = liveid,
					xbl = xblid,
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BanEmbded2 = {
					{
						["color"] = 8663865,
						["title"] = "BAN - ID",
						["description"] = "**Kto:** "..targetName.." \n **Hex:** "..identifier.." \n **Licencja:** "..license.." \n **IP:** "..playerip.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
						["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded2}), { ['Content-Type'] = 'application/json' })
				local wiadomosc = "Gracz: "..targetName.."\nPowód: "..reason.."\nPrzez: "..bannedby.."\nCzas Trwania: "..(args.czas == -1 and "PERM" or args.czas.."h")
				SendWebhookBanMessage(wiadomosc, "<@"..string.gsub(discord, "discord:", "")..">")
			end)

			if args.czas == -1 then
				DropPlayer(tPlayer.source, "Zostałeś zbanowany permanentnie na tym serwerze przez " .. bannedby .. ". Powód: " .. reason)
			else
				DropPlayer(tPlayer.source, "Zostałeś zbanowany przez " .. bannedby .. ". Powód: " .. reason)
			end
		end
	end
end, true, {help = "Komenda do banowania gracza po ID na serwerze", validate = true, arguments = {
	{name = 'id', help = "ID na serwerze", type = 'number'},
	{name = 'czas', help = "Czas w godzinach", type = 'number'},
	{name = 'powod', help = "Powód -> użyj cudzysłowia", type = 'string'}
}})

ESX.RegisterCommand('wldel', {'mod', 'starszymod', 'starszyadmin', 'superadmin', 'admin' , 'best'}, function(xPlayer, args, showError)
	if args.steamid ~= nil then
		MySQL.update('DELETE FROM whitelist WHERE identifier = @identifier', 
		{ 
			['@identifier'] = args.steamid
		}, function()
			for i=1, #WhiteList, 1 do
				if (tostring(WhiteList[i].steamID)) == tostring(args.steamid) then
					table.remove(WhiteList, i)
					break
				end
			end
		end)
	end
end, true, {help = "Komenda do banowania hex gracza", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('wladd', {'mod', 'starszymod', 'starszyadmin', 'superadmin', 'admin' , 'best'}, function(xPlayer, args, showError)
	if args.steamid ~= nil then
		local steamID = args.steamid:lower()
		MySQL.query('SELECT * FROM whitelist WHERE identifier = @identifier', {
			['@identifier'] = steamID
		}, function(result)
			if result[1] ~= nil then
				if xPlayer then
					xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~The player is already whitelisted on this server!')
				end
			else
				MySQL.update('INSERT INTO whitelist (identifier, ticket, back, discord) VALUES (@identifier, @ticket, @back, @discord)', {
					['@identifier'] = steamID,
					['@ticket'] = 5,
					['@back'] = 0,
					['@discord'] = 'Brak'
				}, function(rowsChanged)
					table.insert(WhiteList, {
						steamID = steamID,
						ticketType = 5,
						backTicket = 0,
						discordID = 'Brak',
						licenseID = 'Brak'
					})
					if xPlayer then
						xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~Dodano gracza: '..steamID..' na whiteliste!')
						local administrator = GetPlayerName(xPlayer.source)
						local date = os.date('*t')		
						if date.month < 10 then date.month = '0' .. tostring(date.month) end
						if date.day < 10 then date.day = '0' .. tostring(date.day) end
						if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
						if date.min < 10 then date.min = '0' .. tostring(date.min) end
						if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
						local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
					
						local WLaddEmbded = {
							{
								["color"] = "8663711",
								["title"] = "EXILE-QUEUE",
								["description"] = "Gracz: **"..steamID.."** został dodany na whiteliste przez **"..administrator.."**",
								["footer"] = {
								["text"] = "ExileRP WL System - " ..date.."",
								},
							}
						}
							
						PerformHttpRequest(WLaddWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = WLaddEmbded}), { ['Content-Type'] = 'application/json' })
					else
						local prompt = 'PROMPT'
						local date = os.date('*t')		
						if date.month < 10 then date.month = '0' .. tostring(date.month) end
						if date.day < 10 then date.day = '0' .. tostring(date.day) end
						if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
						if date.min < 10 then date.min = '0' .. tostring(date.min) end
						if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
						local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
					
						local WLaddEmbded1 = {
							{
								["color"] = "8663711",
								["title"] = "EXILE-QUEUE",
								["description"] = "Gracz: **"..steamID.."** został dodany na whiteliste przez **"..prompt.."**",
								["footer"] = {
								["text"] = "ExileRP WL System - " ..date.."",
								},
							}
						}
							
						PerformHttpRequest(WLaddWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = WLaddEmbded1}), { ['Content-Type'] = 'application/json' })
					end
				end)
			end
		end)
	end
end, true, {help = "Komenda do nadawania WLki", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('bilet', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.steamid and args.bilety then
		MySQL.update('UPDATE whitelist SET ticket = @ticket WHERE identifier = @identifier', {
			['@identifier'] = args.steamid,
			['@ticket'] = args.bilety
		}, function()
			for i=1, #WhiteList, 1 do
				if (tostring(WhiteList[i].steamID)) == tostring(args[1]) then
					WhiteList[i].ticketType = args.bilety
				end
			end
			if xPlayer then
				xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~Gracz: '..args.steamid..' dostał '..args.bilety..' ticketów!')
				local administrator = GetPlayerName(xPlayer.source)
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BiletEmbded = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = "Gracz: **"..args.steamid.."** dostał **"..args.bilety.."** ticketów od "..administrator.."!!",
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded}), { ['Content-Type'] = 'application/json' })
			else
				local prompt = 'PROMPT'
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BiletEmbded1 = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = "Gracz: **"..args.steamid.."** dostał **"..args.bilety.."** ticketów od "..prompt.."!!",
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded1}), { ['Content-Type'] = 'application/json' })
			end
		end)
	end
end, true, {help = "Komenda do nadawania biletu", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'},
	{name = 'bilety', help = "Ilość biletów", type = 'number'}
}})

ESX.RegisterCommand('powrotny', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.steamid and args.wartosc then
		MySQL.update('UPDATE whitelist SET back = @back WHERE identifier = @identifier', {
			['@identifier'] = args.steamid,
			['@back'] = args.wartosc
		}, function()
			for i=1, #WhiteList, 1 do
				if (tostring(WhiteList[i].steamID)) == tostring(args[1]) then
					WhiteList[i].back = args.wartosc
				end
			end
			if xPlayer then
				xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~Gracz: '..args.steamid..' dostał '..args.wartosc..' ticketów!')
				local administrator = GetPlayerName(xPlayer.source)
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
				local tempString = ""
				if args.wartosc == 0 then
					tempString = "Gracz **" .. administrator .. "** zabrał bilet powrotny dla gracza **"..args.steamid.."**"
				else
					tempString = "Gracz **" .. administrator .. "** nadał bilet powrotny dla gracza **"..args.steamid.."**"
				end
				local BiletEmbded = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = tempString,
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded}), { ['Content-Type'] = 'application/json' })
			else
				local prompt = 'PROMPT'
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
				local tempString = ""
				if args.wartosc == 0 then
					tempString = "Zabrano bilet powrotny dla gracza **"..args.steamid.."** przez PROMPT"
				else
					tempString = "Nadano bilet powrotny dla gracza **"..args.steamid.."** przez PROMPT"
				end
				local BiletEmbded1 = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = tempString,
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded1}), { ['Content-Type'] = 'application/json' })
			end
		end)
	end
end, true, {help = "Komenda do nadawania biletu", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'},
	{name = 'wartosc', help = "0 albo 1 w zależności od tego czy posiada", type = 'number'}
}})

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/".."636664145554571308", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
	else
		--print("Error: "..(guild.data or guild.code)) 
	end
end)


function SendWebhookBanMessage (message,meska)
    local embeds = {
                {
					author = {
						name = "ExileRP",
						icon_url = "https://cdn.discordapp.com/attachments/1030087654265593916/1060192877189271714/exilelogo.png"
					},
					["thumbnail"] = {
						["url"] = "https://cdn.discordapp.com/emojis/621422722404057091.png?size=96"
					},
            ["title"] = "Gracz Zbanowany",
            ["type"] = "rich",
            ["color"] = 10038562,
            ["footer"] = {
            ["text"] = message
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(BanRoomKurwa, function(err, text, headers) end, 'POST', json.encode({ username = nazwa,embeds = embeds, content = meska}), { ['Content-Type'] = 'application/json' })
end
function SendWebhookUnBanMessage (message,meska)
    local embeds = {
                {
					author = {
						name = "ExileRP",
						icon_url = "https://cdn.discordapp.com/attachments/1030087654265593916/1060192877189271714/exilelogo.png"
					},
					["thumbnail"] = {
						["url"] = "https://cdn.discordapp.com/emojis/887765412643754065.png?size=96"
					},
            ["title"] = "Gracz Odbanowany",
            ["type"] = "rich",
            ["color"] = 2067276,
            ["footer"] = {
            ["text"] = message
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(UnBanyKurwaChuj, function(err, text, headers) end, 'POST', json.encode({ username = nazwa,embeds = embeds,content = meska}), { ['Content-Type'] = 'application/json' })
end