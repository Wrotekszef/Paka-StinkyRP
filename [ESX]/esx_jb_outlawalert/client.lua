Config = {
	GunshotAlert = true,
	GunshotOnlyCities = true,
	AlertFade = 180,
	GunpowderTimer = 60,
	
	AllowedWeapons = {
		["WEAPON_STUNGUN"] = true,
		["WEAPON_STUNGUN_MP"] = true,
		["WEAPON_SNOWBALL"] = true,
		["WEAPON_BALL"] = true,
		["WEAPON_FLARE"] = true,
		["WEAPON_STICKYBOMB"] = true,
		["WEAPON_FIREEXTINGUISHER"] = true,
		["WEAPON_PETROLCAN"] = true,
		["GADGET_PARACHUTE"] = true,
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_VINTAGEPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_SR_SUPP",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SR_SUPP_03",
		["WEAPON_BULLPUPSHOTGUN"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_SMG"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_COMBATPDW"] = true,
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_MARKSMANRIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_SNIPERRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_1911PISTOL"] = "COMPONENT_AT_PI_SUPP",
	}	
}


local shotTimer = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(coords, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 229)
	SetBlipColour(blip, 5)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Kradzież/Uprowadzenie pojazdu')
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Wait(0)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	--TriggerEvent("chatMessage", '[Centrala] ', { 0, 0, 0 }, alert)
	sendnotify(alert)
end)

RegisterNetEvent('destroyPlace')
AddEventHandler('destroyPlace', function(coords, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 304)
	SetBlipColour(blip, 7)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Podejrzany obywatel')
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	
	--TriggerEvent("chatMessage", '[Centrala] ', { 0, 0, 0 }, alert)
	sendnotify(alert)
end)

RegisterNetEvent('drugPlace')
AddEventHandler('drugPlace', function(coords, photo, id, gender, alert, skin)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 51)
	SetBlipColour(blip, 7)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 0)
	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Narkotyki')
	EndTextCommandSetBlipName(blip)
	
	CreateThread(function()
		local alpha = 250
		while true do
			Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	
	--TriggerEvent("chatMessage", '[Centrala] ', { 0, 0, 0 }, alert)
	sendnotify(alert)
	TriggerEvent("InteractSound_CL:PlayOnOne", "72", 0.1)
	if photo then
		TriggerEvent("FeedM:showAdvancedNotification", 'Alarm policyjny', '~r~Narkotyki', (gender and 'Mężczyzna' or 'Kobieta') .. ' sprzedaje narkotyki.', 'CHAR_ARTHUR')
	end
end)

RegisterNetEvent('accidentPlace')
AddEventHandler('accidentPlace', function(coords, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 380)
	SetBlipColour(blip, 2)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Wypadek/Kolizja')
	EndTextCommandSetBlipName(blip)
	CreateThread(function()
		local alpha = 250
		while true do
			Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	--TriggerEvent("chatMessage", '[Centrala] ', { 0, 0, 0 }, alert)
	sendnotify(alert)
end)

local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local ped = PlayerPedId()
local coords = GetEntityCoords(ped)

CreateThread(function ()
	while true do
		Wait(200)
		ped = PlayerPedId()
		coords = GetEntityCoords(ped)
	end
end)


local hasNotifs = true
RegisterCommand('togglegunshot', function()
	if ESX then
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
			if hasNotifs then
				hasNotifs = false
				ESX.ShowNotification('~r~Wyłączono powiadomienia strzałów')
			elseif not hasNotifs then
				hasNotifs = true
				ESX.ShowNotification('~g~Włączono powiadomienia strzałów')
			end
		else
			ESX.ShowNotification('Nie posiadasz do tego dostępu!')
		end
	end
end)


CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(0)
	end

	if not DecorIsRegisteredAsType("Gunpowder", 2) then
		DecorRegister("Gunpowder", 2)
	end

	while true do
		Wait(0)
		if IsAimCamActive() then
			if IsPedShooting(PlayerPedId()) then
				if shotTimer == 0 then
					TriggerEvent('esx:updateDecor', 'BOOL', NetworkGetNetworkIdFromEntity(ped), "Gunpowder", true)
				end

				local weapon, supress = GetSelectedPedWeapon(ped), nil
				for w, c in pairs(Config.AllowedWeapons) do
					if weapon == GetHashKey(w) then
						if c == true or HasPedGotWeaponComponent(ped, GetHashKey(w), GetHashKey(c)) then
							supress = (c == true)
							break
						end
					end
				end

				if supress ~= true then
					shotTimer = Config.GunpowderTimer * 10000
					if Config.GunshotAlert and not exports['esx_property']:isProperty() and hasNotifs then
						if CheckArea(coords, Config.GunshotOnlyCities, (supress == false and 10 or 120)) and not IsPedCurrentWeaponSilenced(ped) then
							local isPolice = ESX.PlayerData.job and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff')
							local str = "" .. (isPolice and "" or "") .. "Uwaga, strzały" .. (isPolice and " policyjne" or "")

							local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
							if s1 ~= 0 and s2 ~= 0 then
									str = str .. " przy " .. GetStreetNameFromHashKey(s1) .. "" .. (isPolice and "" or "") .. " na skrzyżowaniu z " .. GetStreetNameFromHashKey(s2)
							elseif s1 ~= 0 then
									str = str .. " przy " .. GetStreetNameFromHashKey(s1)
							end


							TriggerServerEvent('gunshotInProgress', {x = coords.x, y = coords.y, z = coords.y}, str, isPolice)
							Wait(10 * 1000)
						end
					end
				end
			end
		else
			Wait(200)
		end
	end
end)

--enableGunshot = true

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(coords, isPolice, alert)
	-- if not hasNotifs then return end
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 432)
	SetBlipColour(blip, (isPolice and 3 or 76))
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 0)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Strzały ' .. (isPolice and "policyjne" or "cywilne"))
	EndTextCommandSetBlipName(blip)
	TriggerEvent("InteractSound_CL:PlayOnOne", "71", 0.1)
	CreateThread(function()
		local alpha = 250
		while true do
			Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)

	if hasNotifs then
		--TriggerEvent("chatMessage", '[Centrala] ', { 0, 0, 0 }, alert)
		sendnotify(alert)
	end	
end)

--[[RegisterCommand("togglegunshot", function(src, args, raw) 
	if PlayerData.job.name == "police" then
		enableGunshot = not enableGunshot
		if enableGunshot then
			TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, "Włączono powiadomienia o strzałach", "fas fa-exclamation-circle")
		else
			TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, "Wyłączono powiadomienia o strzałach", "fas fa-exclamation-circle")
		end	
	end
end, false)]]

AddEventHandler('outlawalert:processThief', function(ped, vehicle, mode)
	local str = "" .. (mode == nil and "Próba kradzieży pojazdu" or (mode == true and "Uprowadzenie pojazdu" or "Kradzież pojazdu"))
	if DoesEntityExist(vehicle) then
		vehicle = GetEntityModel(vehicle)

		local coords = GetEntityCoords(ped, true)
		TriggerEvent('esx_vehicleshop:getVehicles', function(base)
			local name = GetLabelText(GetDisplayNameFromVehicleModel(vehicle))
			
			if name == 'NULL' then				
				local found = false
				for _, veh in ipairs(base) do
					if GetHashKey(veh.model) == vehicle then
						name = veh.name
						found = true
						break
					end
				end

				if not found then
					name = GetDisplayNameFromVehicleModel(vehicle)
				end

				str = str .. ' ' .. name .. ''
			end

			local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
			if s1 ~= 0 and s2 ~= 0 then
				str = str .. " przy " .. GetStreetNameFromHashKey(s1) .. " na skrzyżowaniu z " .. GetStreetNameFromHashKey(s2)
			elseif s1 ~= 0 then
				str = str .. " przy " .. GetStreetNameFromHashKey(s1)
			end

			TriggerServerEvent('notifyThief', {x = coords.x, y = coords.y, z = coords.y}, str)
		end)
	else
		local coords = GetEntityCoords(ped, true)

		local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		if s1 ~= 0 and s2 ~= 0 then
			str = str .. " przy " .. GetStreetNameFromHashKey(s1) .. " na skrzyżowaniu z " .. GetStreetNameFromHashKey(s2)
		elseif s1 ~= 0 then
			str = str .. " przy " .. GetStreetNameFromHashKey(s1)
		end

		TriggerServerEvent('notifyThief', {x = coords.x, y = coords.y, z = coords.y}, str)
	end
end)

local list = {}
CreateThread(function()
	while true do
		Wait(500)

		list = {}
		for _, pid in ipairs(GetActivePlayers()) do
			table.insert(list, GetPlayerPed(pid))
		end
	end
end)

function CheckArea(coords, should, dist)
    if not should then
        return true
    end

    local found = false
    for _, ped in ipairs(ESX.Game.GetPeds(list)) do
        local pedType = GetPedType(ped)
        if pedType ~= 28 and pedType ~= 27 and pedType ~= 6 then
            if #(coords - GetEntityCoords(ped)) < dist then
                return true
            end
        end
    end

    return false
end

CreateThread(function()
	while true do
		Wait(500)
		
		if IsEntityInWater(PlayerPedId()) then
			if DecorExistOn(PlayerPedId(), 'Gunpowder') then
				ClearGunPowder()
			end
		end
		
		if shotTimer > 0 then
			shotTimer = shotTimer - 500
			if shotTimer <= 0 then
				TriggerServerEvent('esx:updateDecor', 'DEL', NetworkGetNetworkIdFromEntity(PlayerPedId()), "Gunpowder")
				shotTimer = 0
			end
		end
	end
end)

function ClearGunPowder()
	TriggerServerEvent('esx:updateDecor', 'DEL', NetworkGetNetworkIdFromEntity(PlayerPedId()), "Gunpowder")
	shotTimer = 0
	ESX.ShowNotification('Wszedłeś/aś do wody i oczyściłeś/aś dłonie z prochu.') 
end

RegisterCommand('bk', function(source, args, user)
	if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff') then
		if not exports['esx_policejob']:IsCuffed() then
			local str
			
			if args[1] == 'sams' then
				str = 'Potrzebuje wsparcia'
			else
				str = "Potrzebne wsparcie"
			end
			
			local coords = GetEntityCoords(ped, false)

			local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
			if s1 ~= 0 and s2 ~= 0 then
				str = str .. " przy " .. GetStreetNameFromHashKey(s1) .. " na skrzyżowaniu z " .. GetStreetNameFromHashKey(s2)
			elseif s1 ~= 0 then
				str = str .. " przy " .. GetStreetNameFromHashKey(s1)
			end
			

			if args[1] == '0' then
				TriggerServerEvent('outlawalert:sendNotif', ESX.PlayerData.job.name, 'CODE 0', str, coords)
			elseif args[1] == '1' then
				TriggerServerEvent('outlawalert:sendNotif', ESX.PlayerData.job.name, 'CODE 1', str, coords)
			elseif args[1] == '2' then
				TriggerServerEvent('outlawalert:sendNotif', ESX.PlayerData.job.name, 'CODE 2', str, coords)
			elseif args[1] == '3' then
				TriggerServerEvent('outlawalert:sendNotif', ESX.PlayerData.job.name, 'CODE 3', str, coords)
			elseif args[1] == 'sams' then
				TriggerServerEvent('outlawalert:sendNotif', ESX.PlayerData.job.name, 'SASP/SASD', str, coords, 'dlasamsu')
			end
		end
	end
end, false)

RegisterNetEvent('bkPlace')
AddEventHandler('bkPlace', function(job, coords, code, name, text)
	SetNewWaypoint(coords.x, coords.y, coords.z)
	
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 58)
	SetBlipColour(blip, 27)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, false)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# ['..code..'] - '..name..' needs backup!')
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Wait(180 * 2)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	
	PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)
	--TriggerEvent("chatMessage", '[Centrala] ', { 0, 0, 0 }, '['..code..'] - '..name..' '..text)
	sendnotify('['..code..'] - '..name..' '..text)
end)

RegisterCommand('resetcelu', function(source, args, user)
	local source = source
	local ped = PlayerPedId()
	local coords = GetEntityCoords(PlayerPedId(), true)
	SetNewWaypoint(coords.x, coords.y, coords.z)
	ESX.ShowNotification("Usunięto ostatni cel podróży!")
end, false)

function SendNotification(options)
        options.animation = options.animation or {}
        options.sounds = options.sounds or {}
        options.docTitle = options.docTitle or {}

        local options = {
            type = options.type or "info",
            layout = options.layout or "centerLeft",
            theme = options.theme or "gta",
            text = options.text or "Powiadomienie Testowe",
            timeout = options.timeout or 5000,
            progressBar = options.progressBar ~= false and true or false,
            closeWith = options.closeWith or {},
            animation = {
                open =  "gta_effects_open",
                close =  "gta_effects_close"
            },
            sounds = {
                volume = options.sounds.volume or 0.5,
                conditions = options.sounds.conditions or {"docVisible"},
                sources = false
            },
            docTitle = {
                conditions = options.docTitle.conditions or {}
            },
            modal = options.modal or false,
            id = options.id or false,
            force = options.force or false,
            queue = options.queue or "global",
            killer = options.killer or false,
            container = options.container or false,
            buttons = options.button or false
        }
        SendNUIMessage({options = options})
end

function sendnotify(Message)
    local dane = {
        text = '<b><i class="fas fa-phone"></i> CENTRALA</span></b></br><span style="color: white;">'..Message,
        type = "alert",
        timeout = Interval or 5000,
        layout = "topRight",
        theme = "gta",
        centrala = "XD"
    }
    SendNotification(dane)
    -- PlaySound(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0, 0, 1)
end