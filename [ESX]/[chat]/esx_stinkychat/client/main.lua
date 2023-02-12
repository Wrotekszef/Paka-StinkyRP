local group 
local dontreport = false
local showkurwaid = true
kick = 1800
kickostrzezenie = true

local opisy = {}

local isLogouted = false

CreateThread(function()
	
    while ESX.GetPlayerData().job == nil do
		Wait(100)
	end

    TriggerServerEvent('exile_chat:checkBlocklist')
	ESX.PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('exileRP:ZapodajOpisyZPrzedWejscia', function(opis)
		opisy = opis
	end)
end)

local ped = PlayerPedId()
local pCoords = GetEntityCoords(ped)

CreateThread(function()
	while true do
		ped = PlayerPedId()
		pCoords = GetEntityCoords(ped)
		
		Wait(500)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(group)
	ESX.PlayerData.group = group
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
		TriggerServerEvent('exile_logs:triggerLog', "Przeteleportował się do markera", 'tpm')
end)

function TeleportToWaypoint()
	if ESX and ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best' then			
		local blip = GetFirstBlipInfoId(8)
		local playerPed = PlayerPedId()
		
		if blip ~= 0 then
			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					playerPed = vehicle
				else
					playerPed = nil
				end
			end

			local coord = GetBlipCoords(blip)
			local unused, ground = GetGroundZFor_3dCoord(coord.x, coord.y, 99999.0, 0)
			
			if ground == 0 then
				SetEntityCoords(playerPed, coord.x, coord.y, 0)
				
				local tries = 0
				while ground == 0 and tries < 2000 do
					Wait(100)
					unused, ground = GetGroundZFor_3dCoord(coord.x, coord.y, 99999.0, 0)
					tries = tries + 1
				end
				
				SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, ground + 2.0, true, true, true)
				RemoveBlip(blip)
			else
				SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, ground + 2.0, true, true, true)
				RemoveBlip(blip)
			end
		else
			ESX.ShowNotification('Nie zaznaczono znacznika na mapie')
		end	
	else
		ESX.ShowNotification("Nie możesz tego zrobić")
	end
end


CreateThread(function()
	while true do
		Wait(1000)
		gracz = PlayerPedId()
		if gracz then
			pozycja = GetEntityCoords(gracz, true)
			local bw = exports['esx_ambulancejob']:isDead()
			local isJailed = exports['esx_jailer']:getJailStatus()
			if pozycja == starapozycja and not bw and not isJailed then
				if time > 0 then
					if kickostrzezenie and time == math.ceil(kick / 30) then
						TriggerEvent("chatMessage", "🔔 SYSTEM: ", {255, 0, 0}, "^*^9Zostaniesz wyrzucony za [" .. time .. "] sekund za nieaktywność!")
					end
					time = time - 1
				else
					TriggerServerEvent("wyjebzaafk")
				end
			else
				time = kick
			end
			starapozycja = pozycja
		end
	end
end)

RegisterCommand("adminoff", function(source)
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "best" then
            if dontreport == false then
                dontreport = true
                ESX.ShowNotification("Pomyślnie wyłączono reporty!")
            else
                dontreport = false
                ESX.ShowNotification("Pomyślnie włączono reporty!")
            end
        end
    end)
end)

RegisterCommand("adminidoff", function(source)
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank ~= "user" then
            if showkurwaid == true then
                showkurwaid = false
                ESX.ShowNotification("Pomyślnie wyłączono id!")
            else
                showkurwaid = true
                ESX.ShowNotification("Pomyślnie włączono id!")
            end
        end
    end)
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(name, id, group, message, prefix, color)
	local pid = GetPlayerFromServerId(id)
	
	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end

	if Config.prefix[group] ~= nil and prefix == "" then
		prefix = Config.prefix[group]
	end


	if Config.group[group] ~= nil then
		if color == {} then
			color = Config.group[group]
		end
		TriggerEvent('chatMessage',"[" .. id .. "] 💬 "..prefix.. name .. ' ', Config.group[group], message)
	else
		TriggerEvent('chatMessage',"[" .. id .. "] 💬 "..prefix.. name .. ' ', Config.group[group], message)
	end
end)


RegisterNetEvent('sendProximityMessageDarkWeb')
AddEventHandler('sendProximityMessageDarkWeb', function(message, playerId)
	if ESX and (ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'offpolice' and ESX.PlayerData.job.name ~= 'sheriff' and ESX.PlayerData.job.name ~= 'offsheriff') then
		if (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
			TriggerEvent('chatMessage','[' .. playerId .. ']' .. "💻 DARKWEB: ", {164, 4, 4, 1}, message)
		else
			TriggerEvent('chatMessage',"💻 DARKWEB: ", {164, 4, 4, 1}, message)
		end
	end
end)

RegisterNetEvent('sendProximityMessageDarkWeb2')
AddEventHandler('sendProximityMessageDarkWeb2', function(message, playerId, job)
	if ESX and (ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'offpolice' and ESX.PlayerData.job.name ~= 'sheriff' and ESX.PlayerData.job.name ~= 'offsheriff') then
		if (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
			if ESX.GetPlayerData().thirdjob.name ~= nil and ESX.GetPlayerData().thirdjob.name ~= 'unemployed' then
				TriggerEvent('chatMessage','[' .. playerId .. ']' .. "💻 "..job..": ", {164, 4, 4, 1}, message)
			end
		else
			if ESX.GetPlayerData().thirdjob.name ~= nil and ESX.GetPlayerData().thirdjob.name ~= 'unemployed' then
				TriggerEvent('chatMessage', "💻 "..job..": ", {164, 4, 4, 1}, message)
			end
		end
	end
end)

RegisterNetEvent("exilerpChat:addOOC", function(id, name, color, message, icon) 
	if (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
		TriggerEvent('chatMessage','[' ..id.. ']' .. "🔔 ^*"..name, color, " "..message)
	else
		TriggerEvent('chatMessage', "🔔 ^*"..name, color, " "..message)
	end
end)

RegisterNetEvent("exilerpChat:addCrimeOOC", function(id, name, color, message, icon)
	if ESX and (ESX.GetPlayerData().thirdjob.name ~= 'unemployed' and ESX.PlayerData.job.name ~= nil) then
		if (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
			TriggerEvent('chatMessage','[' ..id.. ']' .. "🔔 CRIME ^*"..name, color, " "..message)
		else
			TriggerEvent('chatMessage', "🔔 CRIME ^*"..name, color, " "..message)
		end
	end
end)


RegisterNetEvent("exilerpChat:sendNews", function(id, name, color, message) 
	if (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
		TriggerEvent('chatMessage','[' ..id.. '] ' .. "📰 NEWS "..name..": ^*", color, message)
	else
		TriggerEvent('chatMessage', "📰 NEWS "..name..": ^*", color, message)
	end
end)

RegisterNetEvent("exilerpChat:sendNewsCompany", function(id, name, color, message) 
	if (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
		TriggerEvent('chatMessage','[' ..id.. '] ' .. "📰 Ogłoszenie Firmy "..name..": ^*", color, message)
	else
		TriggerEvent('chatMessage', "📰 Ogłoszenie Firmy "..name..": ^*", color, message)
	end
end)

RegisterNetEvent('sendProximityMessageTweet')
AddEventHandler('sendProximityMessageTweet', function(title, message, playerId)
	if not isLogouted then
		if (ESX and ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and showkurwaid then
			TriggerEvent('chatMessage',"^*["  .. playerId .. "] 🕊️ @" ..title, {	29, 161, 242}, ": "..message)
		else
			TriggerEvent('chatMessage',"^*🕊️ @"..title, {	29, 161, 242}, ": "..message)
		end
	end
end)

RegisterCommand('twt', function(source, args, user)
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() then
		TriggerServerEvent("sendProximityMessageTweetServer", table.concat(args, " "))
	else
		ESX.ShowNotification('Nie możesz pisać wiadomości będac zakutym/nie żyjąc.')
	end
end, false)

RegisterCommand('dw', function(source, args, user)	
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() then
		TriggerServerEvent("sendProximityMessageDarkWebServer", table.concat(args, " "))
	else
		ESX.ShowNotification('Nie możesz pisać wiadomości będac zakutym/nie żyjąc.')
	end
end, false)

RegisterCommand('dw2', function(source, args, user)	
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() then
		TriggerServerEvent("sendProximityMessageDarkWebServer2", table.concat(args, " "))
	else
		ESX.ShowNotification('Nie możesz pisać wiadomości będac zakutym/nie żyjąc.')
	end
end, false)

local font = 4 
local time = 6000 
local nbrDisplaying = 1

RegisterNetEvent('esx_rpchat:triggerDisplay')
AddEventHandler('esx_rpchat:triggerDisplay', function(text, source, color)
	local player = GetPlayerFromServerId(source)
    if player ~= -1 then
		local offset = 0 + (nbrDisplaying*0.14)
		Display(GetPlayerFromServerId(source), text, offset, color)
	end
end)

function Display(mePlayer, text, offset, color)
    local displaying = true
    CreateThread(function()
        Wait(time)
        displaying = false
    end)
    CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
			local ped = Citizen.InvokeNative(0x43A66C31C68491C0, mePlayer)
            local coordsMe = GetEntityCoords(ped, false)
            local coords = GetEntityCoords(PlayerPedId(), false)
			
			if #(coordsMe - coords) < 19.99 then
				if IsEntityVisible(Citizen.InvokeNative(0x43A66C31C68491C0, mePlayer)) then
					DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z'] + 0.75 + offset, text, color)
				end			
			end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text, color)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vec3(px, py, pz) - vec3(x, y, z))

    local scale = (1/dist)*1.7
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextCentre(true)


        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
		DrawRect(_x+0.0011, _y+scale/50, width*1.1, height*1.2, color.r, color.g, color.b, 100)
    end
end

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
    if IsEntityVisible(ped) then	
		TriggerEvent('chatMessage',"^* ["  .. name .. "] Obywatel: " .. message, {255, 152, 247})
	end
end)
RegisterNetEvent('sendProximityMessageZ')
AddEventHandler('sendProximityMessageZ', function(id, name, message)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
    if IsEntityVisible(ped) then	
		TriggerEvent('chatMessage',"^*["  .. name .. "] Obywatel: patrzy Ci głęboko w oczy.", {126, 255, 61})
	end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
	if IsEntityVisible(ped) then
		TriggerEvent('chatMessage',"^*["  .. name .. "] Obywatel: " .. message, {256, 202, 247})
	end
end)

RegisterNetEvent('sendProximityMessageCzy')
AddEventHandler('sendProximityMessageCzy', function(id, name, message, czy)
	local pid = GetPlayerFromServerId(id)
	
	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end

	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
	if IsEntityVisible(ped) then
		if czy == 1 then
			TriggerEvent('chatMessage',"^*🎲 [" .. name .. "] Obywatel(TRY): Udane", {256, 202, 247})
		elseif czy == 2 then
			TriggerEvent('chatMessage',"^*🎲 [" .. name .. "] Obywatel(TRY): Nieudane", {256, 202, 247})
		end
	end	
end)

RegisterNetEvent('esx_exilechat:pokazOpisChat')
AddEventHandler('esx_exilechat:pokazOpisChat', function(id, name, text)
	local pid = GetPlayerFromServerId(id)
	
	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
	if IsEntityVisible(ped) then	
		TriggerEvent('chatMessage',"^*[" .. id .. "] Obywatel: ".. name, {240, 240, 240})
	end
end)

--------------------------
----- ME / DO / OPIS -----
--------------------------

------------------
-----  OPIS  -----
------------------
local displayOpisHeight = -0.1


RegisterNetEvent('exileRP:opis')
AddEventHandler('exileRP:opis', function(player, opis)
    local info = opis
    local ajdi = player
    opisy[ajdi] = info
end)


RegisterNetEvent('exileRP:opisInnychGraczy')  -- to jest chyba useless
AddEventHandler('exileRP:opisInnychGraczy', function()
    local AjDi = GetPlayerServerId(PlayerId())
    local MojOpis = opisy[AjDi]
    TriggerServerEvent('exileRP:opisInnychGraczyServer', AjDi, MojOpis)
end)

CreateThread(function()
    while true do
        Wait(3)
		local found = false
        for _, player in ipairs(GetActivePlayers()) do
			local ajdi = GetPlayerServerId(player)
            if (opisy[ajdi] ~= nil and tostring(opisy[ajdi]) ~= '') then

				local ped = Citizen.InvokeNative(0x43A66C31C68491C0, player)
				local playerCoords = pCoords
				local targetCoords = GetEntityCoords(ped, true)
				local targetheading = GetEntityHeading(ped)
				local distance2 = #(playerCoords - targetCoords)

				if distance2 < 20 and IsEntityVisible(ped) then
					local veh = GetVehiclePedIsIn(ped, false)
					found = true
					local x, y, z = targetCoords.x, targetCoords.y, targetCoords.z
					if veh ~= 0 then
						for i = -1, 6 do
							PedInVeh = GetPedInVehicleSeat(veh, i)
							if PedInVeh == ped then
								if i == -1 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, 0.5, 0.5)
								elseif i == 0 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, 0.5, 0.5)
								elseif i == 1 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, -0.3, 0.5)
								elseif i == 2 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, -0.3, 0.5)
								elseif i == 3 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, 0.5, 0.5)
								elseif i == 4 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, 0.5, 0.5)
								elseif i == 5 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, -0.3, 0.5)
								elseif i == 6 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, -0.3, 0.5)
								end
								if cord then
									x, y, z = cord.x, cord.y, cord.z
								end
							end
						end
					end
					local tekst = tostring(opisy[ajdi])
					DrawText3DOpis(x, y, z + displayOpisHeight, tekst)
				end
            end
        end
		if not found then
			Wait(400)
		end
    end
end)

function DrawText3DOpis(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    if onScreen then
        SetTextScale(0.30, 0.30)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2)
    TriggerEvent('chatMessage',"^*^1 Odpowiedź wysłana do: [^*^3"  .. tPID .. "^*^1] ^*^3" .. names2)
end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3 )
	TriggerEvent('chatMessage',"^*^1 ADMIN: [^*^3"..source.."^*^1] [^*^3"  .. names3.. "^*^1]: ^*^3" .. textmsg)
end)

amountR = 0

RegisterNetEvent("acceptedReport", function(name, id, reportId, reporter, content) 
	local pid = GetPlayerFromServerId(id)
	local pidd = GetPlayerFromServerId(reporter)
	if PlayerId() == pidd then
		TriggerEvent('chatMessage',"^*^2📋 Twój report [#"..reportId.."] został przyjęty przez ^1["..id.."] ^2["..name.."]")

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'report_rate',
			{
				title    = 'Oceń pomoc ⭐',
				align    = 'center',
				elements = {
					{label = 'Bardzo dobra', value = '5'},
					{label = 'Dobra', value = '4'},
					{label = 'Przeciętna', value = '3'},
					{label = 'Słaba', value = '2'},
					{label = 'Bardzo słaba', value = '1'}
				}
			},
			function(data, menu)
				TriggerServerEvent("exilerp:rateReport", data.current.value, "["..id.."] "..name, content)
				ESX.ShowNotification("~g~Dziękujemy za opinie!")
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)
	elseif ESX and (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and pid ~= myId and not dontreport then
		TriggerEvent('chatMessage',"^*^2📋 Report [#"..reportId.."] został przyjęty przez ^1["..id.."] ^2["..name.."]")
	end
end)
RegisterNetEvent('sendReport')
AddEventHandler('sendReport', function(reportId, id, name, message, admins)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		amountR = amountR + 1
		CreateThread(function() 
			Wait(60000)
			amountR = amountR - 1
		end)
		if amountR >= 10 then
			TriggerServerEvent("exilerp:banReport", id)
			return
		end	
		if admins == 0 then
			TriggerEvent('chatMessage',"^*^3📋 Report [#"..reportId.. "] ^5Obecnie nie ma administracji na serwerze!")
		elseif admins == 1 then
			TriggerEvent('chatMessage',"^*^3📋 Report [#"..reportId.. "] ^5Wysłano do ^3["..admins.. "] ^5administratora")
		else
			TriggerEvent('chatMessage',"^*^3📋 Report [#"..reportId.. "] ^5Wysłano do ^3["..admins.. "] ^5administratorów")
		end
	elseif ESX and (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'starszyadmin' or ESX.PlayerData.group == 'starszymod' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and pid ~= myId and not dontreport then
		TriggerEvent('chatMessage',"^*^3📋 Report ^4[#"..reportId.." | ".. id .."] ^*^3"..name.. ": "..message)
	end
end)

RegisterCommand("fixicon", function() 
	hideIcon()
end)

function showProgress(icon, position, message, caption, color, timeout, showProgress) 
	SendNUIMessage({
		type = "showProgress",
		icon = icon,
		position = exports["qHud"]:getAlign(),
		message = message,
		caption = caption,
		color = color,
		timeout = timeout,
		showProgress = showProgress
	})
end

function showTaskbar(id, icon, position, message, caption, color, timeout, showProgress) 
	SendNUIMessage({
		type = "startTaskbar",
		id = id,
		icon = icon,
		position = exports["qHud"]:getAlign(),
		message = message,
		caption = caption,
		color = color,
		timeout = timeout,
		showProgress = showProgress
	})
end

function showSolid(id, icon, position, message, caption, color) 
	SendNUIMessage({
		type = "showSolid",
		id = id,
		icon = icon,
		position = exports["qHud"]:getAlign(),
		message = message,
		caption = caption,
		color = color
	})
end

function updateSolid(id, icon, position, message, caption, color) 
	SendNUIMessage({
		type = "updateSolid",
		id = id,
		icon = icon,
		position = exports["qHud"]:getAlign(),
		message = message,
		caption = caption,
		color = color
	})
end

function hideSolid(id) 
	SendNUIMessage({
		type = "hideSolid",
		id = id
	})
end

function stopTaskbar(id) 
	SendNUIMessage({
		type = "stopTaskbar",
		id = id
	})
end

function cancelProgress() 
	SendNUIMessage({
		type = "stopProgress"
	})
end
function showIcon(icon, animated, timeout) 
	SendNUIMessage({
		type = "show_icon",
		icon = icon,
		animate = animated,
		timeout = timeout
	})
end
function hideIcon() 
	SendNUIMessage({
		type = "hide_icon"
	})
end

RegisterCommand('twitterlogout', function(source, args, user)
	if isLogouted == true then
		isLogouted = false
		ESX.ShowNotification('Zalogowałeś się do twittera')
	elseif isLogouted == false then
		isLogouted = true
		ESX.ShowNotification('Wylogowaleś się z twittera')
	end
end, false)