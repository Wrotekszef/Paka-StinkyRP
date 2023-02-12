local places = {
    {coords = vector3(-1105.02, -1400.92, 5.23), numOfPeds = 10, peds = {--[[dont touch]]}},
    {coords = vector3(-1219.39, 62.9, 53.03), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(1112.78, -3143.55, 6.06), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(1376.31, -733.91, 67.23), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(2667.64, 1695.21, 24.49), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(395.01, 2972.89, 41.0), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(271.25, 6614.93, 29.7), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(2712.79, 4145.84, 43.79), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(-83.28, 891.44, 235.67), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(-85.73, -433.46, 36.24), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(-1868.28, -3003.89, 13.94), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(-65.5, 1876.12, 197.01), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(2540.3, -601.56, 64.13), numOfPeds = 10 , peds = {--[[dont touch]]}},
    {coords = vector3(-1632.83, 4736.75, 53.32), numOfPeds = 10 , peds = {--[[dont touch]]}},
}

local percentsForBoss = 3
local pedsToSend = {}
local zombieCount =  0

function RespawnZombies()
    for i = 1, #places do
        for j = 1, places[i].numOfPeds - #places[i].peds  do
            local plusOrMinus = math.random(0, 1) == 1
            local coords = places[i].coords
            if plusOrMinus then
                coords = vector3(places[i].coords.x + math.random()*math.random(2, 8), places[i].coords.y + math.random()*math.random(2, 8), places[i].coords.z)
            else
                coords = vector3(places[i].coords.x + math.random()*math.random(2, 8), places[i].coords.y + math.random()*math.random(2, 8), places[i].coords.z)
            end
            if math.random(1 , 100) > percentsForBoss then
                places[i].peds[#places[i].peds+1] = CreatePed(4, `u_m_y_zombie_01`, coords, tonumber(math.random(1, 359)..".0"), true, true)
            else
                places[i].peds[#places[i].peds+1] = CreatePed(4, `s_m_m_movalien_01`, coords, tonumber(math.random(1, 359)..".0"), true, true)
                places[i].isBoss = #places[i].peds
            end
            pedsToSend[#pedsToSend+1] = places[i].peds[#places[i].peds]
            zombieCount = zombieCount + 1
        end
    end
end


CreateThread(function()
    while true do
        RespawnZombies()
        TriggerClientEvent('chatMessage', -1, "🎃 HALLOWEEN: ^3Gniazda Zombie się odnowiły, ruszaj na łowy!", {255, 102, 0}, "")
        Wait(15*60*1000) -- dospawnienie brakujących zombie co 15 min
    end
end)

--main loop

CreateThread(function()
    while true do
        for i = 1, #places do
            for _, ped in pairs(places[i].peds) do
                if GetEntityHealth(ped) <= 0 then
                    local entity = GetPedSourceOfDeath(ped)
                    local players = GetPlayers()
                    for j = 1, #players do
                        if GetPlayerPed(players[j]) == entity then
                            places[i].peds[_] = nil
                            zombieCount = zombieCount -1
                            if places[i].isBoss and places[i].isBoss == _ then
                                places[i].isBoss = nil
                                GiveBossReward(players[j])
                            else
                                GiveReward(players[j])
                            end
                        end
                    end
                end
            end
        end
        Wait(250)
    end
end)

function GiveBossReward(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    if zombieCount <= 0 then
        TriggerClientEvent('esx:showAdvancedNotification', -1, '~o~Halloween', 'Powiadomienie', '~g~Wszystkie zombiaki zostały zabite! Gratulacje!')
    else
        TriggerClientEvent('esx:showAdvancedNotification', -1, '~o~Halloween', 'Powiadomienie', 'Pozostała ilość zombiaków wynosi: '..zombieCount)
    end

    xPlayer.addInventoryItem('pierniki', 1)
    xPlayer.showNotification('Gratulacje udało ci się pokonać ~r~Zombie Boss, ~w~w nagrodę otrzymujesz: ~o~Część trumny')
end

function GiveReward(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    if zombieCount <= 0 then
        TriggerClientEvent('esx:showAdvancedNotification', -1, '~o~Halloween', 'Powiadomienie', '~g~Wszystkie zombiaki zostały zabite! Gratulacje!')
    else
        TriggerClientEvent('esx:showAdvancedNotification', -1, '~o~Halloween', 'Powiadomienie', 'Pozostała ilość zombiaków wynosi: '..zombieCount)
    end


    xPlayer.addInventoryItem('zombiebrain', 1)
    xPlayer.showNotification('Gratulacje udało ci się pokonać ~r~Zombie, ~w~w nagrodę otrzymujesz: ~o~Mózg')
end