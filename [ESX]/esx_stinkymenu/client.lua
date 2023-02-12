local Vehicle = GetVehiclePedIsIn(ped, false)
local inVehicle = IsPedSittingInAnyVehicle(ped)
local lastCar = nil
local myIdentity = {}
local lastGameTimerId = 0
local lastGameTimerPhone = 0
local lastGameTimerOdznaka = 0
local lastGameTimerKurs = 0
local userName
local jobTable = {
	{
		job = "sert",
		label = "SERT"
	},
	{
		job = "dtu",
		label = "DTU"
	},
	{
		job = "sheriff",
		label = "SASD"
	},
	{
		job = "police",
		label = "SASP"
	},
	{
		job = "offpolice",
		label = "SASP"
	},{
		job = "ambulance",
		label = "SAMS"
	},
	{
		job = "offambulance",
		label = "SAMS"
	},
	{
		job = "gheneraugarage",
		label = "Divo Garage"
	},
	{
		job = "offgheneraugarage",
		label = "Divo Garage"
	},
	{
		job = "mechanik",
		label = "LST"
	},
	{
		job = "offmechanik",
		label = "LST"
	},
	{
		job = "doj",
		label = "DOJ"
	},
	{
		job = "psycholog",
		label = "LSPO"
	},
	{
		job = "fib",
		label = "FIB"
	},
}

local Siemanko = {
	job = 'unemployed',
	firstname = '',
	lastname = '',
	secondjob = 'unemployed',
	thirdjob = 'unemployed',
	kursy = 0,
}

CreateThread(function()
	Wait(5000)
	TriggerServerEvent('esx_exilemenu:getUserInfo')
end)

RegisterNetEvent('exile:showLicenseUI', function(grade, type)
	SendNUIMessage({type = 'showLicense', licencja = type, gradee = grade})
end)

RegisterNetEvent('esx_exilemenu:getUserInfo')
AddEventHandler('esx_exilemenu:getUserInfo', function(firstname, lastname, courses)
	Siemanko.kursy = courses
	Siemanko.firstname = firstname
	Siemanko.lastname = lastname
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xplr)
	ESX.PlayerData = xplr
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob)
	ESX.PlayerData.secondjob = secondjob
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob)
	ESX.PlayerData.thirdjob = thirdjob
end)

local markerplayer = nil

RegisterNetEvent('exilerp_idcard:chooseplayer')
AddEventHandler('exilerp_idcard:chooseplayer', function()
    local ped = PlayerPedId()
    local firstplayer = nil
    local elements = {}
    table.insert(elements, {label = 'Obejrzyj dowód', value = 'self', type = 'idcard'})
    table.insert(elements, {label = 'Pokaż dowód', value = 'showidcard', type = 'idcard'})
    table.insert(elements, {label = 'Obejrzyj wizytówke', value = 'self', type = 'businesscard'})
    table.insert(elements, {label = 'Pokaż wizytówke', value = 'showcard', type = 'businesscard'})
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "exilerp_showcards",
    {
        title = "Dokumenty",
        align = "center",
        elements = elements
    },
    function(data, menu)
        local elements2 = {}
        if data.current.value ~= 'self' then
            if data.current.value ~= 'showcardfull' then
                local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(ped, true), 2.0)
                if #playersInArea >= 1 then
                    menu.close()
                    for _, player in ipairs(playersInArea) do
                        if player ~= PlayerId() then
                            local sid = GetPlayerServerId(player)
                
                            table.insert(elements2, {label = sid, value = sid})
                        end
                    end
                    for k,v in pairs(elements2) do
                        if k == 1 then
                            firstplayer = GetPlayerFromServerId(v.value)
                        end
                    end
                    markerplayer = firstplayer
                    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "exilerp_showcards",
                    {
                        title = "Wybór obywatela",
                        align = "right",
                        elements = elements2
                    },
                    function(data2, menu2)
                        menu2.close()
                        local coords = GetEntityCoords(PlayerPedId(), true)
                        local targetped = GetPlayerPed(GetPlayerFromServerId(data2.current.value))
                        local targetcoords = GetEntityCoords(targetped, true)
                        if #(coords - targetcoords) < 2.0 then
							if data.current.type == "idcard" then
								TriggerServerEvent('menu:id', 2, data2.current.value)
								menu.close()
							else
								TriggerServerEvent('menu:phone', 2, data2.current.value)
								menu.close()
							end
                        else
                            ESX.ShowNotification('~r~Brak gracza w pobliżu')
                        end
                        markerplayer = nil
                    end, function(data2, menu2)
                        menu2.close()
                        markerplayer = nil
                    end, function(data2, menu2)
                        markerplayer = GetPlayerFromServerId(data2.current.value)
                    end)
                else
                    ESX.ShowNotification('~r~Brak graczy w pobliżu')
                end
            else
                TriggerServerEvent('menu:phone', 3, nil)
				menu.close()
            end
        else
			if data.current.type == "idcard" then
            	TriggerServerEvent('menu:id', 1, nil)
				menu.close()
			else
				TriggerServerEvent('menu:phone', 1, nil)
				menu.close()
			end
        end
    end, function(data, menu)
        menu.close()
        markerplayer = nil
    end)
end)

CreateThread(function()
	while true do
		Wait(2)
		if markerplayer then
			local ped = GetPlayerPed(markerplayer)
			local coords1 = GetEntityCoords(PlayerPedId(), true)
			local coords2 = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))
			if #(coords1 - coords2) < 40.0 then
				DrawMarker(0, coords2.x, coords2.y, coords2.z + 0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.25, 64, 159, 247, 100, false, true, 2, false, false, false, false)
			end
		else
			Wait(250)
		end
	end
end)


function chowaniebronianim()
    if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
        SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
        Wait(1)   
    end
end
      
function pokazdowodanim()  
    if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
        RequestAnimDict("random@atmrobberygen")
    while (not HasAnimDictLoaded("random@atmrobberygen")) do Wait(0) end
        TaskPlayAnim(PlayerPedId(), "random@atmrobberygen", "a_atm_mugging", 8.0, 3.0, 2000, 0, 1, false, false, false)
    end
end

function portfeldowodprop1()
    if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
        usuwanieprop()
        portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(PlayerPedId()), true)
        AttachEntityToEntity(portfel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
        Wait(500)
        dowod = CreateObject(GetHashKey('prop_michael_sec_id'), GetEntityCoords(PlayerPedId()), true)
        AttachEntityToEntity(dowod, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.150, 0.045, -0.015, 0.0, 0.0, 180.0, 1, 0, 0, 0, 0, 1)
        Wait(1300)
        usuwanieportfelprop()
    end
end

function usuwanieprop()
    DeleteEntity(dowod)
    DeleteEntity(portfel)
end
                  
function usuwanieportfelprop()
    DeleteEntity(dowod)
    Wait(200)
    DeleteEntity(portfel)
end

RegisterCommand('odznaka', function()
	if ESX.PlayerData.job ~= nil or ESX.PlayerData.secondjob ~= nil or ESX.PlayerData.thirdjob ~= nil then
		local now = GetGameTimer()
		if now > lastGameTimerOdznaka then
			if ESX.PlayerData.job.name == 'police' then
				TriggerServerEvent('menu:blacha1', {badge = 'SASP'})
			elseif ESX.PlayerData.job.name == 'gheneraugarage' then
				TriggerServerEvent('menu:blacha2', {badge = 'GG'})
			elseif ESX.PlayerData.job.name == 'mechanik' then
				TriggerServerEvent('menu:blacha4', {badge = 'LST'})
			elseif ESX.PlayerData.job.name == 'ambulance' then
				TriggerServerEvent('menu:blacha3', {badge = 'SAMS'})
			elseif ESX.PlayerData.job.name == 'doj' then
				TriggerServerEvent('menu:blacha7', {badge = 'DOJ'})
			elseif ESX.PlayerData.secondjob.name == 'psycholog' then
				TriggerServerEvent('menu:blacha8', {badge = 'LSPO'})
			elseif ESX.PlayerData.job.name == 'fib' then
				TriggerServerEvent('menu:blacha9', {badge = 'FIB'})
			elseif ESX.PlayerData.job.name == 'sheriff' then
				TriggerServerEvent('menu:blacha6', {badge = 'SASD'})
			end
			
			lastGameTimerOdznaka = now + 3000
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				blachaAnim()
			end
		else
			ESX.ShowNotification('Nie możesz tak często ~r~wyciągać odznaki')
		end
	end
end)

function dowodAnim()
    RequestAnimDict("random@atmrobberygen")
    while not HasAnimDictLoaded("random@atmrobberygen") do 
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "random@atmrobberygen", "a_atm_mugging", 8.0, 3.0, 2000, 56, 1, false, false, false)
    wallet = CreateObject(`prop_ld_wallet_01`, GetEntityCoords(PlayerPedId()), true)
    AttachEntityToEntity(wallet, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
    Wait(500)
    id = CreateObject(`prop_michael_sec_id`, GetEntityCoords(PlayerPedId()), true)
    AttachEntityToEntity(id, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.150, 0.045, -0.015, 0.0, 0.0, 180.0, 1, 0, 0, 0, 0, 1)
    Wait(1300)
    DeleteEntity(wallet)
    DeleteEntity(id)
end

function wizytowkaAnim()
    RequestAnimDict("random@atm_robbery@return_wallet_male")
    while not HasAnimDictLoaded("random@atm_robbery@return_wallet_male") do 
        Wait(0)
    end
    local prop = CreateObject(`prop_michael_sec_id`, GetEntityCoords(PlayerPedId()), true)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.07, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
    TaskPlayAnim(PlayerPedId(), "random@atm_robbery@return_wallet_male", "return_wallet_positive_a_player", 8.0, 3.0, 1000, 56, 1, false, false, false)
    Wait(1000)
    DeleteEntity(prop)
end

function blachaAnim()
    RequestAnimDict("paper_1_rcm_alt1-9")
    while not HasAnimDictLoaded("paper_1_rcm_alt1-9") do 
        Wait(0)
    end
    local prop = CreateObject(`prop_fib_badge`, GetEntityCoords(PlayerPedId()), true)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.07, 0.003, -0.065, 90.0, 0.0, 95.0, 1, 0, 0, 0, 0, 1)
    TaskPlayAnim(PlayerPedId(), "paper_1_rcm_alt1-9", "player_one_dual-9", 8.0, 3.0, 1000, 56, 1, false, false, false)
    Wait(1000)
    DeleteEntity(prop)
end

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)

RegisterNUICallback('NUIGenActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openGeneral'})
end)


RegisterNUICallback('manageid', function()
	local now = GetGameTimer()
	if now > lastGameTimerId then
		TriggerEvent('exilerp_idcard:chooseplayer')
		lastGameTimerId = now + 5000
		SetNuiFocus(false, false)
		SendNUIMessage({type = 'closeAll'})
	else
		ESX.ShowNotification('Nie możesz tak często ~r~zarządzać dokumentami (5 sekund)')
	end
end)

RegisterNUICallback('lockveh', function(data)
	exports['esx_kluczyki'].LockSystem(PlayerPedId())
end)

RegisterNUICallback('hud', function(data)
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
	Wait(10)
	exports['exile_hud'].HudConf()
end)

RegisterNetEvent('esx_exilemenu:showID')
AddEventHandler('esx_exilemenu:showID', function()
	local now = GetGameTimer()
	if now > lastGameTimerId then
		TriggerServerEvent('menu:id', data)
		lastGameTimerId = now + 3000
	end
end)

RegisterNUICallback('NUIKeysActions', function()
	GiveKeys()
end)

RegisterCommand('keys', function(source, args, raw)
	GiveKeys()
end)

function GiveKeys()	
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            local targetPed = GetPedInVehicleSeat(vehicle, 0)
            if IsPedInAnyVehicle(targetPed) then
                for _, player in ipairs(GetActivePlayers()) do
                    if targetPed == GetPlayerPed(player) then
                        TriggerServerEvent('esx_kluczyki:giveKeysAction', GetPlayerServerId(player), GetVehicleNumberPlateText(vehicle, true))
                        break
                    end
                end
            end
        else
			ESX.ShowNotification('~r~Nie jesteś na miejscu kierowcy')
		end
    else
		ESX.ShowNotification('~r~Nie jesteś w pojeździe')
	end
end

RegisterNetEvent('sendProximityMessageID')
AddEventHandler('sendProximityMessageID', function(id, citizen, bron, kata, katb, katc, ubezmedtext, ubezmehtext, skin)
	local playerId = GetPlayerFromServerId(id)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if playerId ~= -1 then

		CreateThread(function()
			local t = {
				d = 'ExileRP',
				s = 'Card',
				a = 255
			}

			local str = "Licencja na broń: " .. (bron and "~g~TAK" or "~r~NIE") .. "~s~\n"
			str = str .. "Ubezpieczenie: " .. (ubezmedtext == true and "~g~NNW" or "~r~NNW") .. " " .. (ubezmehtext == true and "~g~OC" or "~r~OC") .. "~s~\n"
			str = str .. "Prawo jazdy, kat.: " .. (kata and "~g~A" or "~r~A") .. " " .. (katb and "~g~B" or "~r~B") .. " " .. (katc and "~g~C" or "~r~C")

            local firstname, lastname = citizen.firstname, citizen.lastname

			if pid == myId then
				ExecuteCommand("me Pokazuje dowód: "..firstname.." "..lastname.." - "..citizen.dateofbirth)
			end
			
			TriggerEvent("FeedM:showAdvancedNotification", firstname .. ' ' .. lastname, '~y~' .. (citizen.sex == 'm' and "Mężczyzna" or "Kobieta") .. ', ' .. citizen.dateofbirth .. ', ' .. citizen.height .. "cm", str, "DIA_MIGRANT", 10000, t)
		
		end)		
	end
end)

RegisterNUICallback('togglephone', function(data)
	local now = GetGameTimer()
	if now > lastGameTimerPhone then
		TriggerServerEvent('menu:phone', data)
		lastGameTimerPhone = now + 3000
		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			wizytowkaAnim()
		end
	else
		ESX.ShowNotification('Nie możesz tak często ~r~wyciągać wizytówki')
	end
end)

RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, citizen, jobName, jobLabel, gradeLabel, skin)
	local playerId = GetPlayerFromServerId(id)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if playerId ~= -1 then

		if citizen.phone_number ~= nil then
			number = citizen.phone_number
		else
			number = 'Brak karty SIM'
		end

		if citizen.account_number ~= nil then
			account = citizen.account_number
		else
			account = 'Brak konta bankowego'
		end

		CreateThread(function()
			local t = {
				d = 'ExileRP',
				s = 'Card',
				a = 255
			}

            local firstname, lastname = citizen.firstname, citizen.lastname

			if pid == myId then
				TriggerEvent('chatMessage', "^*["  .. id .. "] Obywatel: pokazuje wizytówkę: ".." " .. firstname .. " " .. lastname .. " " .. number, {255, 152, 247})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 3.999 then
				TriggerEvent('chatMessage', "^*["  .. id .. "] Obywatel: pokazuje wizytówkę: ".." " .. firstname .. " " .. lastname .. " " .. number, {255, 152, 247})
			end

			TriggerEvent("FeedM:showAdvancedNotification", firstname, '~y~' .. jobLabel .. " - " .. gradeLabel, "~o~Numer telefonu:~w~ " .. number .. "\n~o~Numer konta:~w~ " .. account, "CHAR_MP_DETONATEPHONE", 10000, t)
		end)
	end
end)


RegisterNetEvent('sendProximityMessagePhoneDistance')
AddEventHandler('sendProximityMessagePhoneDistance', function(id, citizen, phone_number, account_number, jobName, jobLabel, gradeLabel, skin)
	local playerId = GetPlayerFromServerId(id)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local dis = #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(playerId)))
    if dis == 0 and myId ~= playerId and NetworkGetPlayerCoords(playerId) == vector3(0.0, 0.0, 0.0) then return end

	if dis < 5 then

		
		if phone_number ~= nil then
			number = phone_number
		else
			number = 'Brak karty SIM'
		end

		if account_number ~= nil then
			iban = account_number 
		else
			iban = 'Brak konta bankowego'
		end

		CreateThread(function()
			local t = {
				d = 'ExileRP',
				s = 'Card',
				a = 255
			}
        
            local firstname, lastname = citizen.firstname, citizen.lastname
			
			if pid == myId then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: pokazuje wizytówkę: ".." " .. firstname .. " " .. lastname .. " " .. number, {255, 152, 247})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 3.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: pokazuje wizytówkę: ".." " .. firstname .. " " .. lastname .. " " .. number, {255, 152, 247})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname, '~y~' .. jobLabel .. " - " .. gradeLabel, "~o~Numer telefonu:~w~ " .. number .. "\n~o~Numer konta:~w~ " .. iban, "CHAR_ARTHUR", 10000, t)
		end)
	end
end)

RegisterNUICallback('toggleblacha', function(data)	
	local now = GetGameTimer()
	if now > lastGameTimerOdznaka then
		if ESX.PlayerData.job.name == 'police' then
			TriggerServerEvent('menu:blacha1', data)
		elseif ESX.PlayerData.job.name == 'gheneraugarage' then
			TriggerServerEvent('menu:blacha2', data)
		elseif ESX.PlayerData.job.name == 'mechanik' then
			TriggerServerEvent('menu:blacha4', data)
		elseif ESX.PlayerData.job.name == 'ambulance' then
			TriggerServerEvent('menu:blacha3', data)
		elseif ESX.PlayerData.job.name == 'doj' then
			TriggerServerEvent('menu:blacha7', data)
		elseif ESX.PlayerData.secondjob.name == 'psycholog' then
			TriggerServerEvent('menu:blacha8', data)
		elseif ESX.PlayerData.job.name == 'fib' then
			TriggerServerEvent('menu:blacha9', data)
		elseif ESX.PlayerData.job.name == 'sheriff' then
			TriggerServerEvent('menu:blacha6', data)
		end
		lastGameTimerOdznaka = now + 3000
		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			blachaAnim()
		end
	else
		ESX.ShowNotification('Nie możesz tak często ~r~wyciągać odznaki')
	end
end)


function ShowOdznaka()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped, false) then
		CreateThread(function()
			RequestAnimDict("random@atm_robbery@return_wallet_male")
			while not HasAnimDictLoaded("random@atm_robbery@return_wallet_male") do		
				Wait(0)
			end


			TaskPlayAnim(ped, "random@atm_robbery@return_wallet_male", "return_wallet_positive_a_player", 8.0, 3.0, 1000, 56, 1, false, false, false)
			Wait(1000)
			DeleteObject(object)
		end)
	end
end

RegisterNetEvent('sendProximityMessageBlacha1')
AddEventHandler('sendProximityMessageBlacha1', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card5',
				a = 255
			}

			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~\n"
			str = str .. "Stopień: " .. ("~y~"..gradeLabel)

			local mestr = "Numer odznaki: " .. odznaka.id .. "\n"
			mestr = mestr .. "Stopień: " .. gradeLabel
			
			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				ExecuteCommand("me Pokazuje odznakę: "..firstname.." "..lastname.." - "..jobLabel.." - "..mestr)
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "WEB_LOSSANTOSPOLICEDEPT", 10000, gigadev)
		end)
	end
end)
RegisterNetEvent('sendProximityMessageBlacha2')
AddEventHandler('sendProximityMessageBlacha2', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - "..jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card3',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}
			
			local firstname, lastname = citizen.firstname, citizen.lastname

			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - '..jobLabel, str, "CHAR_CHAT_CALL", 10000, gigadev)
		end)
	end
end)
RegisterNetEvent('sendProximityMessageBlacha3')
AddEventHandler('sendProximityMessageBlacha3', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - "..jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card4',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~\n"
			str = str .. "Stopień: " .. ("~y~"..gradeLabel)
			
			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - '..jobLabel, str, "CHAR_CHAT_CALL", 10000, gigadev)
		end)
	end
end)

RegisterNetEvent('sendProximityMessageBlacha4')
AddEventHandler('sendProximityMessageBlacha4', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card3',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~\n"
			str = str .. "Stopień: " .. ("~y~"..gradeLabel)
			
			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "CHAR_CHAT_CALL", 10000, gigadev)
		end)
	end
end)

RegisterNetEvent('sendProximityMessageBlacha5')
AddEventHandler('sendProximityMessageBlacha5', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card5',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~\n"
			str = str .. "Stopień: " .. ("~y~"..gradeLabel)
			
			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "CHAR_CHAT_CALL", 10000, gigadev)
		end)
	end
end)
RegisterNetEvent('sendProximityMessageBlacha6')
AddEventHandler('sendProximityMessageBlacha6', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()

			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card6',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~\n"
			str = str .. "Stopień: " .. ("~y~"..gradeLabel)

			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "DIA_POLICE", 10000, gigadev)
		end)
	end
end)

RegisterNetEvent('sendProximityMessageBlacha7')
AddEventHandler('sendProximityMessageBlacha7', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local jobLabel = "Department of Justice"
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card7',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~"
			
			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "CHAR_CHAT_CALL", 10000, gigadev)
		end)
	end
end)

RegisterNetEvent('sendProximityMessageBlacha8')
AddEventHandler('sendProximityMessageBlacha8', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local jobLabel = "LSPO"
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] " .. citizen.firstname .. " " .. citizen.lastname.. " - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card8',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~"
			
			local firstname, lastname = citizen.firstname, citizen.lastname
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "CHAR_CHAT_CALL", 10000, gigadev)
		end)
	end
end)

RegisterNetEvent('sendProximityMessageBlacha9')
AddEventHandler('sendProximityMessageBlacha9', function(id, citizen, jobName, jobLabel, gradeLabel)
	local source = sid
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	local playerId = GetPlayerFromServerId(id)
	if playerId ~= -1 then
	
		local playerPed = GetPlayerPed(playerId)
		if playerId ~= PlayerId() then
			if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(playerPed, true)) > 3.0 then
				return
			end
		end

		CreateThread(function()
			
			local odznaka = json.decode(citizen.job_id)
			local subject = "["..odznaka.id .. "] - " .. jobLabel

			local gigadev  = {
				d = 'ExileRP',
				s = 'Card9',
				a = 255
			}


			local t = {
                d = 'CHAR_BANK_MAZE',
                s = 'warning',
                a = 180
			}

			local str = "Numer odznaki: " .. ("~y~"..odznaka.id) .. "~s~\n"
			str = str .. "Stopień: " .. ("~y~"..gradeLabel)


			local firstname = "Agent"
			local lastname = "DTU"
			
			if playerId == PlayerId() then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			elseif #(GetEntityCoords(GetPlayerPed(myId)) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
				TriggerEvent('chatMessage',"^*["  .. id .. "] Obywatel: wyciąga odznakę ".." " .. subject, {145, 129, 39})
			end
			TriggerEvent("FeedM:showAdvancedNotification", firstname..' '..lastname, '~y~Identyfikator - ' .. jobLabel, str, "DIA_PRO1_MICHAELMASK", 10000, gigadev)
		end)
	end
end)

RegisterNUICallback('NUIVehicleActions', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openVehicles'})
end)

RegisterNUICallback('NUIDoorActions', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openDoorActions'})
end)

RegisterNUICallback('toggleFrontLeftDoor', function()
   local playerPed = PlayerPedId()
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 0, false)            
       else
         SetVehicleDoorOpen(playerVeh, 0, false)             
      end
   end
end)

RegisterNUICallback('toggleFrontRightDoor', function()
   local playerPed = PlayerPedId()
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 1, false)            
       else
         SetVehicleDoorOpen(playerVeh, 1, false)             
      end
   end
end)

RegisterNUICallback('toggleBackLeftDoor', function()
   local playerPed = PlayerPedId()
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 2) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 2, false)            
       else
         SetVehicleDoorOpen(playerVeh, 2, false)             
      end
   end
end)

RegisterNUICallback('toggleBackRightDoor', function()
   local playerPed = PlayerPedId()
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 3) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 3, false)            
       else
         SetVehicleDoorOpen(playerVeh, 3, false)             
      end
   end
end)

RegisterNUICallback('toggleHood', function()
   local playerPed = PlayerPedId()
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 4) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 4, false)            
       else
         SetVehicleDoorOpen(playerVeh, 4, false)             
      end
   end
end)

RegisterNUICallback('toggleTrunk', function()
   local playerPed = PlayerPedId()
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 5) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 5, false)            
       else
         SetVehicleDoorOpen(playerVeh, 5, false)             
      end
   end
end)

RegisterNUICallback('toggleWindowsUp', function()
	local playerPed = PlayerPedId()
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		RollUpWindow(playerVeh, 0)
		RollUpWindow(playerVeh, 1)
		RollUpWindow(playerVeh, 2)
		RollUpWindow(playerVeh, 3)
	end
end)

RegisterNUICallback('toggleWindowsDown', function()
	local playerPed = PlayerPedId()
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		RollDownWindow(playerVeh, 0)
		RollDownWindow(playerVeh, 1)
		RollDownWindow(playerVeh, 2)
		RollDownWindow(playerVeh, 3)
	end
end)

RegisterNUICallback('NUIWindowActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openWindows'})
end)

local lastAllDoorsTimer = 0
local lastGameTimerDice = 0

RegisterCommand("servermenu", function()
	ESX.UI.Menu.CloseAll()
	local GlobalElements = {
		{label = "Dane osobowe", value = 'characterinfo'},
		{label = "Dokumenty", value = 'documents'},
		{label = 'Zarzadzanie kartami SIM', value = 'simki'},
		{label = "HUD", value = 'hud'},
		{label = "Kluczyki", value = 'keysgive'},
		{label = "Przekaż Kluczyki", value = 'keys'},
		{label = "Pojazd", value = 'car'},
		{label = "Inne", value = 'commands'},
	}
	if ESX.PlayerData.job.name == 'sheriff'
	or ESX.PlayerData.job.name == 'police'
	or ESX.PlayerData.job.name == 'mechanik'
	or ESX.PlayerData.job.name == 'gheneraugarage'
	or ESX.PlayerData.job.name == 'ambulance'
	or ESX.PlayerData.job.name == 'doj'
	or ESX.PlayerData.secondjob.name == 'psycholog'
	then
		GlobalElements = {
			{label = "Dane osobowe", value = 'characterinfo'},
			{label = "Dokumenty", value = 'documents'},
			{label = 'Zarządzanie SIM', value = 'simki'},
			{label = "Odznaka", value = 'odznaka'},
			{label = "HUD", value = 'hud'},
			{label = "Kluczyki", value = 'keysgive'},
			{label = "Przekaż Kluczyki", value = 'keys'},
			{label = "Pojazd", value = 'car'},
			{label = "Inne", value = 'commands'},
		}
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'server_menu', {
		title = 'Menu Serwerowe',
		align = 'center',
		elements = GlobalElements
	}, function(data, menu)
		if data.current.value == 'characterinfo' then
			characterinfo()
		elseif data.current.value == 'simki' then
			ExecuteCommand('kartysim')
		elseif data.current.value == 'documents' then
			ESX.UI.Menu.CloseAll()
			TriggerEvent("exilerp_idcard:chooseplayer")
		elseif data.current.value == 'odznaka' then
			ESX.UI.Menu.CloseAll()
			if ESX.PlayerData.job.name == 'mechanik' then
				odznaki = {
				{label = "LST", value = 'mg'},
				}
			elseif ESX.PlayerData.job.name == 'gheneraugarage' then
				odznaki = {
				{label = "Divo Garage", value = 'gg'},
				}
			elseif ESX.PlayerData.job.name == 'ambulance' then
				odznaki = {
				{label = "SAMS", value = 'sams'},
				}
			elseif ESX.PlayerData.job.name == 'doj' then
				odznaki = {
				{label = "DOJ", value = 'doj'},
				}
			elseif (ESX.PlayerData.secondjob.name == 'psycholog' and ESX.PlayerData.job.name == 'ambulance') then
				odznaki = {
				{label = "LSPO", value = 'psycholog'},
				{label = "SAMS", value = 'sams'},
				}
			elseif (ESX.PlayerData.secondjob.name == 'psycholog' and ESX.PlayerData.job.name == 'police') then
				odznaki = {
				{label = "LSPO", value = 'psycholog'},
				{label = "SASP", value = 'sasp'},
				}
			elseif (ESX.PlayerData.secondjob.name == 'psycholog' and ESX.PlayerData.job.name == 'sheriff') then
				odznaki = {
				{label = "LSPO", value = 'psycholog'},
				{label = "SASD", value = 'sheriff'},
				}
			elseif ESX.PlayerData.secondjob.name == 'psycholog' then
				odznaki = {
				{label = "LSPO", value = 'psycholog'},
				}
			elseif ESX.PlayerData.job.name == 'fib' then
				odznaki = {
				{label = "FIB", value = 'fib'},
				}
			elseif ESX.PlayerData.job.name == 'police' then
				odznaki = {
				{label = "SASP", value = 'sasp'},
				}
			elseif ESX.PlayerData.job.name == 'sheriff' then
				odznaki = {
				{label = "SASD", value = 'sheriff'},
				}
			elseif ESX.PlayerData.job.name == 'police' then
				odznaki = {
				{label = "SASP", value = 'sasp'},
				}
			else
				ESX.ShowNotification('Nie jesteś zatrudniony!')
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'server_menu', {
				title = 'Odznaki',
				align = 'center',
				elements = odznaki
			}, function(data2, menu)
				local now = GetGameTimer()
		if now > lastGameTimerOdznaka then
			if data2.current.value == 'sasp' then
				TriggerServerEvent('menu:blacha1', {badge = 'SASP'})
			elseif data2.current.value == 'gg' then
				TriggerServerEvent('menu:blacha2', {badge = 'Divo Garage'})
			elseif data2.current.value == 'mg' then
				TriggerServerEvent('menu:blacha4', {badge = 'LST'})
			elseif data2.current.value == 'sams' then
				TriggerServerEvent('menu:blacha3', {badge = 'SAMS'})
			elseif data2.current.value == 'doj' then
				TriggerServerEvent('menu:blacha7', {badge = 'DOJ'})
			elseif data2.current.value == 'psycholog' then
				TriggerServerEvent('menu:blacha8', {badge = 'LSPO'})
			elseif data2.current.value == 'fib' then
				TriggerServerEvent('menu:blacha9', {badge = 'FIB'})
			elseif data2.current.value == 'sheriff' then
				TriggerServerEvent('menu:blacha6', {badge = 'SASD'})
			end
			
			lastGameTimerOdznaka = now + 3000
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				blachaAnim()
			end
		else
			ESX.ShowNotification('Nie możesz tak często ~r~wyciągać odznaki')
		end
			end, function(data2, menu)
				menu.close()
			end)
		elseif data.current.value == 'hud' then
			menuhud()
		elseif data.current.value == 'keysgive' then
			ExecuteCommand("keysmenu")
		elseif data.current.value == 'keys' then
			ExecuteCommand("keys")
		elseif data.current.value == 'car' then
			menucar()
		elseif data.current.value == 'commands' then
			menucommands()
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterKeyMapping('blacha', 'Pokaż odznakę', 'keyboard', 'HOME')
RegisterKeyMapping('dowod', 'Pokaż dowód', 'keyboard', 'INSERT')

RegisterCommand('blacha', function()
  if not IsPauseMenuActive() then
	local now = GetGameTimer()
		if now > lastGameTimerOdznaka then
		if ESX.PlayerData.job.name == 'police' then
			TriggerServerEvent('menu:blacha1', {badge = 'SASP'})
			blachaAnim()
		elseif ESX.PlayerData.job.name == 'sheriff' then
			TriggerServerEvent('menu:blacha6', {badge = 'SASD'})
			blachaAnim()
		end
	else
		ESX.ShowNotification('Nie możesz tak często ~r~wyciągać odznaki')
	end
	lastGameTimerOdznaka = now + 3000
  end
end, false)

RegisterCommand('dowod', function()
	if not IsPauseMenuActive() then
	local now = GetGameTimer()
	if now > lastGameTimerOdznaka then
		local elements2 = {}
		 local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), true), 2.0)
                if #playersInArea >= 1 then
                    for _, player in ipairs(playersInArea) do
                        if player ~= PlayerId() then
                            local sid = GetPlayerServerId(player)
                
                            table.insert(elements2, {label = sid, value = sid})
                        end
                    end
                    for k,v in pairs(elements2) do
                        if k == 1 then
                            firstplayer = GetPlayerFromServerId(v.value)
                        end
                    end
                    markerplayer = firstplayer
                    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "exilerp_showcards",
                    {
                        title = "Wybór obywatela",
                        align = "right",
                        elements = elements2
                    },
                    function(data2, menu2)
                        menu2.close()
                        local coords = GetEntityCoords(PlayerPedId(), true)
                        local targetped = GetPlayerPed(GetPlayerFromServerId(data2.current.value))
                        local targetcoords = GetEntityCoords(targetped, true)
                        if #(coords - targetcoords) < 2.0 then
							TriggerServerEvent('menu:id', 2, data2.current.value)
							menu.close()
                        else
                            ESX.ShowNotification('~r~Brak gracza w pobliżu')
                        end
                        markerplayer = nil
                    end, function(data2, menu2)
                        menu2.close()
                        markerplayer = nil
                    end, function(data2, menu2)
                        markerplayer = GetPlayerFromServerId(data2.current.value)
                    end)
            else
                TriggerServerEvent('menu:id', 1, nil)
            end
	else
		ESX.ShowNotification('Nie możesz tak często ~r~wyciągać dowodu.')
	end
	  lastGameTimerOdznaka = now + 3000
	end
  end, false)

characterinfo = function()
	local characterinfo = {
		{label = "Dane osobowe: " .. Siemanko.firstname .. " " .. Siemanko.lastname, value = nil},
		{label = "Frakcja: " .. ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, value = nil},
		{label = "Legalna: " .. ESX.PlayerData.secondjob.label .. " - " .. ESX.PlayerData.secondjob.grade_label, value = nil},
		{label = "Organizacja: " .. ESX.PlayerData.thirdjob.label .. " - " .. ESX.PlayerData.thirdjob.grade_label, value = nil},
		{label = "<- Sprawdź Kursy ->", value = 'kursy'},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'characterinfo', {
		title = 'Dane osobowe',
		align = 'center',
		elements = characterinfo
	}, function(data2, menu2)
		if data2.current.value == 'kursy' then
			local now = GetGameTimer()
			if now > lastGameTimerKurs then
				if ESX.PlayerData.secondjob.name == 'winiarz' or ESX.PlayerData.secondjob.name == 'weazel' or ESX.PlayerData.secondjob.name == 'taxi' or ESX.PlayerData.secondjob.name == 'slaughter' or ESX.PlayerData.secondjob.name == 'rafiner'
				or ESX.PlayerData.secondjob.name == 'pizzeria' or ESX.PlayerData.secondjob.name == 'miner' or ESX.PlayerData.secondjob.name == 'milkman' or ESX.PlayerData.secondjob.name == 'krawiec' or ESX.PlayerData.secondjob.name == 'kawiarnia'
				or ESX.PlayerData.secondjob.name == 'grower' or ESX.PlayerData.secondjob.name == 'fisherman' or ESX.PlayerData.secondjob.name == 'farming' or ESX.PlayerData.secondjob.name == 'courier' or ESX.PlayerData.secondjob.name == 'burgershot'
				or ESX.PlayerData.secondjob.name == 'baker' or ESX.PlayerData.secondjob.name == 'x-gamer' then  
					ESX.ShowNotification('Liczba twoich kursów wynosi: '..Siemanko.kursy)
				else
					ESX.ShowNotification('Nie jesteś zatrudniony w żadnej z legalnych firm!')
				end
				lastGameTimerKurs = now + 3000
			else
				ESX.ShowNotification('Nie możesz tak często ~r~sprawdzać kursów')
			end
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end

menuhud = function()
	local elements2 = {
		{label = 'Konfiguracja HUD', value = 'hudchange'},
		{label = 'Ukryj/Odkryj HUD', value = 'hidehud'},
		{label = 'Minimap Fix', value = 'fixminimap'},
		{label = 'Cursor Fix', value = 'cursorfix'},
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuhud', {
		title = 'HUD',
		align = 'center',
		elements = elements2
	}, function(data2, menu2)
		if data2.current.value == 'hudchange' then
			ESX.UI.Menu.CloseAll()
			ExecuteCommand("hudsettings")
		elseif data2.current.value == 'hidehud' then
			ExecuteCommand("offhud")
			ESX.ShowNotification('~g~Wykonano Offhud')
		elseif data2.current.value == 'cursorfix' then
			ExecuteCommand("cursorfix")
			ESX.ShowNotification('~g~Wykonano Cursor Fix')
		elseif data2.current.value == 'fixminimap' then
			ExecuteCommand("minimapfix")
			ESX.ShowNotification('~g~Wykonano Minimap Fix')
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end

menucar = function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local elements2 = {
			{label = 'Drzwi', value = 'doors'},
			{label = 'Szyby', value = 'windows'},
		}
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menucar', {
			title = 'Pojazd',
			align = 'center',
			elements = elements2
		}, function(data2, menu2)
			if data2.current.value == 'doors' then
				menudoors()
			elseif data2.current.value == 'windows' then
				menuwindows()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	else
		ESX.ShowNotification('~r~Nie jesteś w pojeździe')
	end
end

menudoors = function()
	local elements = {
		{label = 'Przednie prawe drzwi', value = 1},
		{label = 'Przednie lewe drzwi', value = 0},
		{label = 'Tylne prawe drzwi', value = 3},
		{label = 'Tylne lewe drzwi', value = 2},
		{label = 'Maska', value = 4},
		{label = 'Bagażnik', value = 5},
		{label = 'Zamknij wszystko', value = 'alldoors'}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menudoors', {
		title = 'Drzwi',
		align = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			CarFunctions('doors', data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

menuwindows = function()
	local elements = {
		{label = 'Przednia prawa szyba', value = 1},
		{label = 'Przednia lewa szyba', value = 0},
		{label = 'Tylna prawa szyba', value = 3},
		{label = 'Tylna lewa szyba', value = 2}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuwindows', {
		title = 'Szyby',
		align = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			CarFunctions('windows', data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

CarFunctions = function(type, id)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		local vehicle = GetVehiclePedIsIn(ped, false)
		if type == 'doors' then
			if id ~= 'alldoors' then
				if GetVehicleDoorAngleRatio(vehicle, id) > 0.0 then
					SetVehicleDoorShut(vehicle, id, false)
				else
					SetVehicleDoorOpen(vehicle, id, false)
				end
			else
				if GetGameTimer() > lastAllDoorsTimer then
					SetVehicleDoorsShut(vehicle, false)
					lastAllDoorsTimer = GetGameTimer() + 5000
				end
			end
		elseif type == 'windows' then
			if not IsVehicleWindowIntact(vehicle, id) then
				RollUpWindow(vehicle, id)
			else
				RollDownWindow(vehicle, id)
			end
		end
	end
end

menucommands = function()
	local elements = {
		{label = 'Rzut kostką', value = 'dice'},
		{label = 'Streamermode', value = 'hideradiochannel'},
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menucommands', {
		title = 'Inne',
		align = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'dice' then
			if GetGameTimer() > lastGameTimerDice then
				local ped = PlayerPedId()
				RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
				TaskPlayAnim(ped, 'anim@mp_player_intcelebrationmale@wank', "wank", 18.0, 10.0, -1, 50, 0, false, true, true)
				Wait(1000)
				ClearPedTasks(ped)
				ExecuteCommand("dices")
				lastGameTimerDice = GetGameTimer() + 5000
			else
				ESX.ShowNotification('~r~Nie możesz tak często rzucać kostką')
			end
		elseif data.current.value == 'hideradiochannel' then
			ExecuteCommand("streamermode")
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterKeyMapping('servermenu', 'Menu serwerowe', 'keyboard', 'PAGEUP')