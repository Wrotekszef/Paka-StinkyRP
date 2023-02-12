local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PoliceGUI               = false
local CurrentTask             = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

RegisterCommand('et', function()
	if ESX.PlayerData.job ~= nil and
	(ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance'
	or ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'offgheneraugarage'
	or ESX.PlayerData.job.name == 'offmechanik' or ESX.PlayerData.job.name == 'mechanik'
	or ESX.PlayerData.job.name == 'offdoj' or ESX.PlayerData.job.name == 'doj') then
		if not PoliceGUI then
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'open'})
			PoliceGUI = true
			medkit = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)	
			DecorSetInt(medkit,"GamemodeCar",4488)
			AttachEntityToEntity(medkit, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true) -- object is attached to right hand 

			RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
			while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
				Wait(4)
			end

			TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
		end
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	PoliceGUI = false
	if medkit ~= nil then
		DeleteEntity(medkit) 
		medkit = nil
		StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end
end)

RegisterNUICallback('mandat', function(data, cb)
	if ESX.PlayerData.job ~= nil and 
	(ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offambulance'
	or ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'offgheneraugarage'
	or ESX.PlayerData.job.name == 'offmechanik' or ESX.PlayerData.job.name == 'mechanik'
	or ESX.PlayerData.job.name == 'offdoj' or ESX.PlayerData.job.name == 'doj') then
		local wysokoscmandatu = tonumber(data.mandatamount)
		if wysokoscmandatu > 100000 then
			ESX.ShowNotification('Kwota faktury przekroczyła maksymalną ilość: 100.000$')
		else
			local sender = GetPlayerServerId(player)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				MandatPlayer(GetPlayerServerId(closestPlayer), data.mandatamount, data.mandatreason)
				ESX.ShowNotification('~p~Wpłacono ' .. data.mandatamount / 8 .. '$ z faktury na Twoje konto w banku')
			else
				ESX.ShowNotification('Brak osób w pobliżu')
			end	
		end
	else
		TriggerServerEvent('exile_ban')
	end
end)

function MandatPlayer(player, ilosc, powod)
	TriggerServerEvent("tablet_frakcje:SendMessage", player, ilosc, powod)
end