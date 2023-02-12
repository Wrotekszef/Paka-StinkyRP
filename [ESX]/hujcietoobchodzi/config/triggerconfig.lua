print("^2 [MIXAS AntiCheat] ^5 TriggerConfig Refresh ^0")

TriggerConfig = {}
TriggerConfig.BlacklistEvent = {
    Detection = true,
    Ban = true,
    Events = { -- you can add or remove blacklisted events below
        "mellotrainer:adminKick",
        'antilynx8:anticheat',
        'antilynxr4:detect',
        'antilynxr6:detection',
        "HCheat:TempDisableDetection",
        'ynx8:anticheat',
        'antilynx8r4a:anticheat',
        'lynx8:anticheat',
        'AntiLynxR4:kick',
        'esx_spectate:kick',
        'AntiLynxR4:log',
        'chat:server:ServerPSA',
        'd0pamine_xyz:getFuckedNigger',
        'adminmenu:allowall',
        'esx_mafiajob:confiscatePlayerItem',
        'esx_jailer:sendToJail',
        'NB:recruterplayer',
        ':tunnel_req',
        'f0ba1292-b68d-4d95-8823-6230cdf282b6',
        'gambling:spend',
        'hentailover:xdlol',
        'OG_cuffs:cuffCheckNearest',
        'hentailover:xdlol',
        'display',
        'advancedFuel:setEssence',
        'esx:jackingcar'
    }
}
    
TriggerConfig.SpecialCoordsEvent = { --If players uses events out of cordinates they get banned (which means cheaters will try to use events out of cordinates so you can get them)
    Detection = true,
    Ban = true,
    Events = {
        {trigger = "esx_pizza:pay", distance = 15, coords = {x = 11.43397, y = -1599.46, z = 29.375}},
        {trigger = "mixas:pay", distance = 15, coords = {x = -63.98506, y = 6300.167, z = 31.33}}
    }
}

TriggerConfig.GiveItemTriggers = {
    Detection = true,
    Events = { -- only item not WEAPON! (if trigger giving weapon dont add on here)
        "mxs:giveItem",
        "give:test",
    }
}


TriggerConfig.ProtectValues = {
    Detection = true,
    Events = { -- example: TriggerServerEvent('esx_pizza:pay',250000000)) --max 5 param
        {trigger = "esx_pizza:pay", max = 100, typee = 'ban'},
        {trigger = "checkya", max = 134, typee = 'kick'},
    }
}

TriggerConfig.Message = { --blacklisted events for messages
    Detection = true,
    Ban = true,
    Events = {
        "esx_cartel:message",
    },
    BlacklistedMessages = { -- you can add blacklisted messages here
        "MIXAS",
    }
}