print("^2 [MIXAS AntiCheat] ^5 ServerConfig Refresh ^0")
ServerConfig = {}
ServerConfig.General = {
  BanSystem = true,
  KickBanEmoji = '[💚]',
  KickBanMessage = 'Cheating',
  JoinLog = false,
  IngameNotify = true,
  CustomBanTrigger = 'mxs:customban', -- Example user TriggerServerEvent('mxs:customban','Reason is here')
  ConfigRefreshCommand = 'acconfigrefresh', -- you can use this command to apply changes in serverconfig.lua without waiting for restart.
  UnbanCommand = 'mixasunban',
  BanCommand = 'mixasban',
  WeaponDetection = true, --its blocking giveweaponEvent
  BlockRequest = true, -- its important for DD0S Protections (blocking player jsons etc.)
  DontTouch = -1,
  AntiTeaser = true,
}

ServerConfig.Webhooks = {
  Main = "https://discord.com/api/webhooks/1061817069609422878/CK9JZVEHSQIWJu5lYMGXqrqDcJhwtIBMWuNi1KsPANgFw4ADiYUq3eVRFsz1wZ9bMBBi", -- Add your webhook for main mixas ac logs
  BlacklistKey = "https://discord.com/api/webhooks/1061817069609422878/CK9JZVEHSQIWJu5lYMGXqrqDcJhwtIBMWuNi1KsPANgFw4ADiYUq3eVRFsz1wZ9bMBBi", -- Add your webhooks here for screenshots
  JoinLog = "", -- add your webhook here for joinlog
  ScreenshotBase = "https://discord.com/api/webhooks/1061817160084758528/dy2bVKt49RM4mU0m1JR7FXYcgKL5SAS47XmvIk6-4enxfbVEdik3hNfZlVbvAzq1Fr-j"
}

ServerConfig.BlacklistCommand = { -- If non whitelisted players/admins uses that command they will be banned
  Detection = true,
  Ban = true,
  Commands = {
    'mixastest',
    'test2',
  }
}

ServerConfig.BlacklistReasons = { --its for disconnect/crash 
  Detection = false,
  Ban = true,
  Blacklist = {
    'test2',
  }
}

ServerConfig.BLNicknames = { -- List of blacklisted nicknames you can add or remove
  BlacklistNickname = true, 
  BlacklistNickNames = {
    "administrator", "admin", "adm1n", "adm!n", "admln", "moderator", "owner", "nigger", "n1gger", "moderator", "eulencheats", "lynxmenu", "atgmenu", "hacker", "bastard", "hamhaxia", "333gang", "ukrp", "eguk", "n1gger", "n1ga", "nigga", "n1gga", "nigg3r",
    "nig3r", "n199er", "n1993r", "rustchance.com", "rustchance", "hellcase.com", "hellcase", "youtube.com", "youtu.be", "youtube", "anticheat.gg", "anticheat", "fucking", "ψ", "@", "&", "{", "}", ";", "ϟ", "♕", "Æ", "Œ", "‰", "™", "š", "œ", "Ÿ", "µ", "ß",
    "±", "¦", "»", "«", "¼", "½", "¾", "¬", "¿", "Ñ", "®", "©", "²", "·", "•", "°", "þ",  "✪", "Ä", "ƒ", "Ã", "¢", "?", "†", "€", "웃", "и", "】", "【", "j4p.pl", "ֆ", "ȶ", "L͙", "a͙", "l͙", "ľ̶̚͝", "Ḩ̷̤͚̤͑͂̎̎͆", "a̸̢͉̠͎͒͌͐̑̇", "♚", "я", "Ʒ", "Ӂ̴", "Ƹ̴", "≋",
    "chocohax", "crysishosting.com", "crysishosting", "key-drop.com", "key-drop.pl", "skinhub.com", "skinhub", "`", "¤", "¡",
    "<",">"
  }
}

ServerConfig.ClearPedTask = { 
  ClearPedTaskMethod = false, -- if true, no one will be able to kick someone from vehicle
  CPTMethodKick = false,
  CPTMethodBan = false
}

ServerConfig.Explosions = {
  AntiExplosions = true, -- if true, it detects when someone explodes something
  MaxDamageDetection = true, -- if true, it detects when someone increases damage more than shown below
  MaxDamageScale = 2.0, -- max scale for explosion damage
  Kick = true,
  Ban = false,
  Debug = true,
  List = {
    --[0] = { name = "Grenade", log = true, kick = true },
    --[1] = { name = "GrenadeLauncher", log = true, kick = true },
    --[2] = { name = "C4", log = true, kick = true },
   -- [3] = { name = "Molotov", log = true, kick = true },
   -- [4] = { name = "Rocket", log = true, kick = true },
    --[5] = { name = "TankShell", log = true, kick = true},
  --  [6] = { name = "Hi_Octane", log = true, kick = true },
   -- [7] = { name = "Car", log = true, kick = true },
   -- [8] = { name = "Plance", log = true, kick = true },
    --[9] = { name = "PetrolPump", log = true, kick = true },
   -- [10] = { name = "Bike", log = true, kick = true },
   -- [11] = { name = "Dir_Steam", log = true, kick = true },
   -- [12] = { name = "Dir_Flame", log = true, kick = true },
   -- [13] = { name = "Dir_Water_Hydrant", log = false, kick = true },
   -- [14] = { name = "Dir_Gas_Canister", log = true, kick = true },
   -- [15] = { name = "Boat", log = true, kick = true },
    --[16] = { name = "Ship_Destroy", log = true, kick = true },
    --[17] = { name = "Truck", log = true, kick = true },
   -- [18] = { name = "Bullet", log = true, kick = true },
    --[19] = { name = "SmokeGrenadeLauncher", log = true, kick = true },
   -- [20] = { name = "SmokeGrenade", log = true, kick = true },
   -- [21] = { name = "BZGAS", log = true, kick = true },
   --[22] = { name = "Flare", log = true, kick = true },
    --[23] = { name = "Gas_Canister", log = true, kick = true },
    --[24] = { name = "Extinguisher", log = true, kick = true },
    --[25] = { name = "Programmablear",log = true, kick = true },
    --[26] = { name = "Train", log = true, kick = true },
    --[27] = { name = "Barrel", log = true, kick = true },
    --[28] = { name = "PROPANE", log = true, kick = true },
    --[29] = { name = "Blimp", log = true, kick = true },
   -- [30] = { name = "Dir_Flame_Explode", log = true, kick = true },
   -- [31] = { name = "Tanker", log = true, kick = true },
    --[32] = { name = "PlaneRocket", log = true, kick = true },
  --  [33] = { name = "VehicleBullet", kick = true },
   -- [34] = { name = "Gas_Tank", log = true, kick = true },
    --[35] = { name = "FireWork", log = true, kick = true },
    --[36] = { name = "SnowBall", log = true, kick = true },
    --[37] = { name = "ProxMine", log = true, kick = true },
    --[38] = { name = "Valkyrie_Cannon", log = true, kick = true },
    --[70] = { name = "AutoMizer", log = true, kick = true }
  }
}