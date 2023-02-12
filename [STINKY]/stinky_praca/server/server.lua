ESX = nil
TriggerEvent('exile:getsharedobject', function(obj) ESX = obj end)

RegisterServerEvent('KrzychuAC:spectate')
AddEventHandler('KrzychuAC:spectate', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.group == 'user' then
        TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spectate without permission")
    end
end)

RegisterServerEvent('KrzychuAC:speedModifier')
AddEventHandler('KrzychuAC:speedModifier', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.group == 'user' then
        TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to modifier vehicle")
    end
end)

RegisterServerEvent('KrzychuAC:spawnWeapon')
AddEventHandler('KrzychuAC:spawnWeapon', function(weapon)
    local _source = source
    TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to spawn weapons")
end)

--[[RegisterServerEvent('KrzychuAC:')
AddEventHandler('KrzychuAC:explosiveAmmo', function()
    local _source = source
    TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to explosiveAmmo")
end)

RegisterServerEvent('KrzychuAC:ToMuchArmour')
AddEventHandler('KrzychuAC:ToMuchArmour', function()
    local _source = source
    TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Too much armour")
end)]]
--[[
local exploCreator = {}
local vehCreator = {}
local pedCreator = {}
local entityCreator = {}

CreateThread(function()
    exploCreator = {}
    vehCreator = {}
    pedCreator = {}
    entityCreator = {}
    while true do
        Wait(10000)
        exploCreator = {}
        vehCreator = {}
        pedCreator = {}
        entityCreator = {}
    end
end)

AddEventHandler('entityCreating', function(entity)
    local status, retval = pcall(DoesEntityExist, entity)
    if not status or not retval then
      return
    end
    local eType = GetEntityPopulationType(entity)
    local src   = NetworkGetEntityOwner(entity)
    local model = GetEntityModel(entity)
    if Config.BlacklsitedEntity[model] then
        local reason = "Gracz tworzy blacklistowne entity: **" .. Config.BlacklsitedEntity[model] .. "**"
        TriggerEvent("exilerp_scripts:banPlr", "nigger", src, reason)
        CancelEvent()
        pcall(DeleteEntity, entity)
    end

    if GetEntityType(entity) == 2 then -- USUWANIE JAK ZA DUŻO AUT
        if string.lower(GetVehicleNumberPlateText(entity)) == 'Skript.GG' then
            TriggerEvent("exilerp_scripts:banPlr", "nigger", src, 'Respienie auta z wykorzystaniem Skript.GG')
        end
        vehCreator[src] = (vehCreator[src] or 0) + 1
        if vehCreator[src] > 3 then
            exports['exile_logs']:SendLog(src, 'Zrespił ponad 3 auta w mniej niż 10 sekund (' .. model .. ')', 'anticheat', '3066993')
            CancelEvent()
            pcall(DeleteEntity, entity)
        end
    end
end)

RegisterServerEvent('krzychuAC:nuidevTools')
AddEventHandler('krzychuAC:nuidevTools', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.group ~= 'best' then
        TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "ExileAC: Nui_DevTools opened.")
    end
end)

AddEventHandler("giveWeaponEvent",function(sender, data)
    if data.givenAsPickup == false then
        local source = sender
        TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "ExileAC: Tried to spawn weapons via giveWeaponEvent")
        CancelEvent()
    end
end)

local explosionIndex = {
    [0] = { name = "Grenade", log = true, ban = true },
    [1] = { name = "GrenadeLauncher", log = true, ban = true },
    [3] = { name = "Molotov", log = true, ban = true },
    [4] = { name = "Rocket", log = true, ban = true },
    [5] = { name = "TankShell", log = true, ban = true},
    [6] = { name = "Hi_Octane", log = false, ban = false },
    [7] = { name = "Car", log = false, ban = false },
    [8] = { name = "Plance", log = false, ban = false },
    [9] = { name = "PetrolPump", log = false, ban = false },
    [10] = { name = "Bike", log = false, ban = false },
    [11] = { name = "Dir_Steam", log = false, ban = false },
    [12] = { name = "Dir_Flame", log = false, ban = false },
    [13] = { name = "Dir_Water_Hydrant", log = false, ban = false },
    [14] = { name = "Dir_Gas_Canister", log = false, ban = false },
    [15] = { name = "Boat", log = true, ban = true },
    [16] = { name = "Ship_Destroy", log = true, ban = true },
    [17] = { name = "Truck", log = false, ban = false },
    [18] = { name = "Bullet", log = false, ban = false },
    [19] = { name = "SmokeGrenadeLauncher", log = false, ban = false },
    [20] = { name = "SmokeGrenade", log = false, ban = false },
    [21] = { name = "BZGAS", log = false, ban = false },
    [22] = { name = "Flare", log = false, ban = false },
    [23] = { name = "Gas_Canister", log = false, ban = false },
    [24] = { name = "Extinguisher", log = false, ban = false },
    [25] = { name = "Programmablear", log = false, ban = false },
    [26] = { name = "Train", log = true, ban = true },
    [27] = { name = "Barrel", log = false, ban = false },
    [28] = { name = "PROPANE", log = true, ban = true },
    [29] = { name = "Blimp", log = false, ban = false },
    [30] = { name = "Dir_Flame_Explode", log = false, ban = false },
    [31] = { name = "Tanker", log = false, ban = false },
    [32] = { name = "PlaneRocket", log = true, ban = true },
    [33] = { name = "VehicleBullet", log = true, ban = true },
    [34] = { name = "Gas_Tank", log = false, ban = false },
    [35] = { name = "FireWork", log = false, ban = false },
    [36] = { name = "SnowBall", log = false, ban = false },
    [37] = { name = "ProxMine", log = true, ban = true },
    [38] = { name = "Valkyrie_Cannon", log = true, ban = true }
}

AddEventHandler("explosionEvent",function(a7, a8)
    local src = source
    if explosionIndex[a8.explosionType] then
        local a9 = explosionIndex[a8.explosionType]
        if a9.log and not a9.ban then
            exports['exile_logs']:SendLog(src, 'Blocked Explosion:'..a9.name, 'anticheat', '3066993')
        end
        if a9.ban then
            TriggerEvent("exilerp_scripts:banPlr", "nigger", src, 'Blocked Explosion: '..a9.name)
        end
    end
    CancelEvent()
end)

local blockedTriggers = {
    {name = 'exilerp_scripts:jailonplayer', jobs = {'police', 'sheriff'}},
}]]

--[[CreateThread(function ()
    for i=1, #blockedTriggers, 1 do
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        AddEventHandler(blockedTriggers[i].name, function()
            for k,v in pairs(blockedTriggers.jobs) do
                if xPlayer.job.name == v then
                    return
                end
            end
        end)
        exports['exile_logs']:SendLog(src, 'Tried to execute: '..blockedTriggers[i].name, 'anticheat', '3066993')
    end
end)]]