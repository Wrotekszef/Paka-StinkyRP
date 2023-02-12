ClientConfig = {}
ClientConfig.General = {
    EMethods = true, -- it blocks some executers (you cant start/stop or restart scripts when server is on, which means you should wait until restart of server)
    EMethodCheck = 10000, -- default 10000 (dont change it)
    AntiStopper = false, -- it blocks cheaters to stop scripts (when its on you cant start/stop or restart scripts you should wait until restart of server)
    AntiESX = false, -- if you use ESX as framework, you should keep it false.
    AntiGodMode = false, -- if true, it blocks some known methods of godmode BUT if you have a script which uses godmode keep it false.
    AntiSpectate = false, -- Cheater cant spectate when its on (dont forget to add your admin's hex ids or licences to ServerConfig.Whitelist so they can spectate !)
    AntiRadar = false, -- if you use Radar script, you should keep it false
    AntiVision = false, -- if you use Thermal/Night vision script, you should keep it false
    AntiMenyoo = true, -- it blocks menyooasi
    Safe = true, -- it blocks cheater to burn people
    SafeLoopTime = 100, -- don't change it // Default 100
    AntiArmourHack = true,
    MaxArmour = 100,
    MenuDetection = true,
    AntiLagSwitch = true,
    FreeCam = false,
    ScreenshotBasicName = 'screenshot-basic',
    AntiDrown = false,
    AntiSoundSpam = false, -- its blocks cheater to sound spam everyone. if u will use this +0.02 ms
    EulenFreecamDetection = false, -- its blocks eulen freecam cheats
    EulenSpectateDetection = false, -- its blocks eulen spectate cheats
    EulenHealDetection = true, -- its blocks eulen heal cheats
    AntiKillInvisible = true,
    AntiKillEulen = false,
    AntiHitBoxHack = false,
    PickupHack = true,
    BlockSuspensionHack = true,
    DisableTyresBurst = true,
}


ClientConfig.WLScripts = { -- if you add your script here, you will be able to start,stop or restart this script.
    "esx_policejob",
    "blips",
    "javascript",
}

ClientConfig.AntiLagSwitch = {
    Detection = true,
    Max = 250
}

ClientConfig.Particle = {
    Detection = false,
    RemoveTime = 10000, -- don't change it // default 10000
}

ClientConfig.AntiFly = {
    PlayerProtect = false, -- if true, it protects aganist car fly
    Distance = 20, -- Max Distance // default 20 
    Class = { -- dont change it
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13
    },
    -- its AntiFly method 2
    PlayerProtection2 = true,
    Distance2 = 5
}


ClientConfig.Blacklistkey = {
    Detection = true,
    CoolDown = 60000,
    Screenshot = true,
    BlacklistKeys = { -- you can add or remove blacklisted keys below, // EDIT IT FOR YOUR SERVER AND DONT FORGET TO INSTALL SCREENSHOTBASIC !
        {key = 121, name = 'INSERT', kick = false},
        {key = 212, name = 'HOME', kick = false},
    },
}

ClientConfig.SpawnVehicle = { -- Anti car spawn
    Detection = false,
    CoolDown = 1000,
    NpcVehicle = false,
    AllowedResources = {
        ['esx_cardealer'] = false,
        ['esx-carRental'] = false,
        ['MIXAS-v3.7'] = false,
    },
    DonateCars = { -- its block donate car spawn -- ITS IMPORTANT
        [GetHashKey('i8')] = false,
        [GetHashKey('s500')] = false,
    }
}

ClientConfig.Weapons = {
    Detection = false, -- if true, you activate blacklisted weapon option. (we recommend you to keep it true)
    AntiExplosiveWeapons = true, -- if true, you block explosive weapons
    RemoveBlacklistWeapon = false, -- if true, it deletes ONLY blacklisted weapon from inventory
    RemoveAllWeapons = false, -- when it detects blacklisted weapon in player's or cheater's inventory it deletes ALL weapons on him (we recommend you to keep it true)
    BLWeaponLog = false, -- it shows on logs(webhook on discord) use of blacklisted weapons
    InfiniteAmmoBlock = true,
    LoopTime = 10000, -- don't change it
    DamageBoostDetection = false,
    MaxDamageModify = 1, --
}

ClientConfig.WhitelistedWeapons = {
    [GetHashKey('WEAPON_PISTOL')] = true,
    [GetHashKey('WEAPON_MICROSMG')] = true,
    [966099553] = true, -- Default Fivem weapon, not delete this.
    [0] = true, -- Default Fivem weapon, not delete this.
}