local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetPlayerName = GetPlayerName
local GetPlayerInvincible_2 = GetPlayerInvincible_2
local SetEntityHealth = SetEntityHealth
local GetEntityHealth = GetEntityHealth
local NetworkIsInSpectatorMode = NetworkIsInSpectatorMode
local GetEntityCoords = GetEntityCoords
local GetFinalRenderedCamCoord = GetFinalRenderedCamCoo
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetVehicleTopSpeedModifier = GetVehicleTopSpeedModifier
local GetVehicleCheatPowerIncrease = GetVehicleCheatPowerIncrease

CreateThread(function()
    while true do
        Wait(5 * 1000)
        local minimum, maximum = GetModelDimensions(`mp_m_freemode_01`)
        if minimum and maximum then
            local size = (maximum - minimum)
            if size.y - 0.50 > 0.1 then
                TriggerServerEvent('gagri:gagri')
            elseif size.z - 2.24 > 0.05 then
                TriggerServerEvent('gagri:gagri')
            end
        end
    end
end)

RegisterNetEvent("exilerp_scripts:crash", function() 
    if not CConfig.CrashOnBan then return end
    CreateThread(function() 
        while true do
        end	
    end)
end)

CConfig = {}

CConfig.CrashOnBan = true

CConfig.InsertKeys = {
    ["DELETE"] = 214, ["INSERT"] = 121, ["HOME"] = 212, ["NUMPAD7"] = 117
}
CConfig.InsertDetection = true

CConfig.ScreenDelay = 10000
CConfig.InsertScreenDelay = 25000

CConfig.DMGBoostDetect = true
CConfig.CustomConnectEvent = true
CConfig.CustomConnect = "exilerp_scripts:connected"
-- Lista by exilerp
CConfig.WeaponComponents = {
    -- Pistol
    0xFED0FD71,
    0xED265A1C,
    0x359B7AAE,
    0x65EA7EBB,

    -- Combat Pistol
    0x721B079,
    0xD67B4F2D,
    0x359B7AAE,
    0xC304849A,

    -- AP Pistol
    0x31C4B22A,
    0x249A17D5,
    0x359B7AAE,
    0xC304849A,

    -- SNS Pistol
    0xF8802ED9,
    0x7B0033B3,

    -- Heavy Pistol
    0xD4A969A,
    0x64F9C62B,
    0x359B7AAE,
    0xC304849A,

    -- SNS Pistol MK II
    0x1466CE6,
    0xCE8C0772,
    0x4A4965F3,
    0x47DE9258,
    0x65EA7EBB,
    0xAA8283BF,

    -- Pistol MK II
    0x94F42D62,
    0x5ED6C128,
    0x43FD595B,
    0x8ED4BB70,
    0x65EA7EBB,
    0x21E34793,

    -- Vintage Pistol
    0x45A3B6BB,
    0x33BA12E8,
    0xC304849A,

    -- Machine Pistol
    0x476E85FF,
    0xB92C6979,
    0xA9E9CAF4,
    0xC304849A,
}

local za = false
local z = false
CreateThread(function() 
    if not CConfig.DMGBoostDetect then return end
    Wait(1000)
    CConfig.DefaultDamages = json.decode('{"2499030370":0.0,"568543123":0.0,"21392614":0.0,"3106695545":0.0,"1591132456":0.0,"1198425599":0.0,"834974250":0.0,"1694090795":0.0,"867832552":0.0,"3598405421":0.0,"899381934":0.0,"1168357051":0.0,"2396306288":0.0,"4275109233":0.0,"3465283442":0.0,"2063610803":0.0,"2850671348":0.0,"614078421":0.0,"1140676955":0.0,"4169150169":0.0,"1205768792":0.0,"119648377":0.0,"3271853210":1.0,"1709866683":1.0,"3978713628":0.0,"1246324211":0.0,"222992026":0.0,"2860680127":0.0}')
    function checkComponentDamage() 
        for k,v in pairs(CConfig.WeaponComponents) do
            local dmg = GetWeaponComponentDamageModifier(v)
            if dmg > 1.01 then
                TriggerServerEvent("exilerp_scripts:gotMeDMG", "DMG Boost detected, difference: "..dmg)
                break
            end
        end
    end
end)

local ssCount = 0
local screening = false

function insertCheck() 
    if not CConfig.InsertDetection then return end 
    while true do
        Wait(3)
        if not screening then   
            for i,v in pairs(CConfig.InsertKeys) do
                if IsControlJustPressed(0, v) or IsDisabledControlJustPressed(0, v) then
                    screening = true
                    exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/1021445990877765695/nAADbo0A9jEPV6p7_BL007k3cZZS-_A71oIPg2d9AdAMCUV7uxpA-sydhAeYwRLDj485", 'files[]', function(data)
                        local resp = json.decode(data)
                        if resp and resp ~= nil then
                            ssCount = ssCount+1
                            TriggerServerEvent("exilerp_scripts:sendScreen", resp.attachments[1].url, v, ssCount)
                        end
                        screening = false
                    end)
                end
            end
        else
            Wait(500)
        end
    end
end

CreateThread(function() 
    while not z do
        Wait(200)
    end
    CreateThread(function() 
        insertCheck()
    end)
end)