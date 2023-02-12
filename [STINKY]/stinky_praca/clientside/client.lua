ESX = nil
local PlayerData = {}

CreateThread(function()
    while ESX == nil do
        TriggerEvent('exile:getsharedobject', function(obj) ESX = obj end)
        Wait(0)
    end
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)


local playerPed = PlayerPedId()
CreateThread(function()
    while true do
        Wait(500)
        playerPed = PlayerPedId()
    end
end)

CreateThread(function()
    while true do
        Wait(2500)
        if NetworkIsInSpectatorMode() then
            TriggerServerEvent('KrzychuAC:spectate')
        end

        PlayerData = ESX.GetPlayerData()
        for k, v in pairs(Config.Weapons) do
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(k), false) then
                local found = false
                for key, value in pairs(PlayerData.inventory) do
                    if value.type == 'weapon' then
                        if value.name == k then
                            found = true
                            break
                        end
                    end
                    if value.name == 'flashbang' then
                        found = true
                    end
                end
                if not found then
                    TriggerServerEvent('KrzychuAC:spawnWeapon', k)
                end
            end
        end


        --[[local kev = GetPedArmour(playerPed)
        if kev > Config.MaxArmor then
            if PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'offpolice' and PlayerData.job.name ~= 'sheriff' and PlayerData.job.name ~= 'offsheriff' then --DODAJCIE SOBIE TU JAKIES INNE JOBY JAK MACIE
                TriggerServerEvent('KrzychuAC:ToMuchArmour',  kev)
            end
        end]]
        --[[local _weapondamage = GetWeaponDamageType(GetSelectedPedWeapon(playerPed))
        if _weapondamage == 4 or _weapondamage == 5 or _weapondamage == 6 or _weapondamage == 13 then
            TriggerServerEvent("KrzychuAC:explosiveAmmo")
        end]]
    end
end)