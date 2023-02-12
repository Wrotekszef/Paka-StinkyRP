Citizen.CreateThread(function()
    while true do
        Wait(3000)
        TriggerEvent("esx_k9:SSWORKING")
    end
end)


WeaponComponents = {
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
	0xC304849A
}

CreateThread(function() 
	Citizen.Wait(30000)
	for k,v in pairs(WeaponComponents) do
		if v then
			local dmg = GetWeaponComponentDamageModifier(v)
			local accdmg = GetWeaponComponentAccuracyModifier(v)
			if dmg > 1 or accdmg > 0 then
				exports['screenshot-basic']:requestScreenshotUpload(GetConvar("screenshotstorage", "XD"), 'png', function(data)
				local resp = json.decode(data)
				cb = resp and resp.attachments[1].url or ""
					TriggerServerEvent("esx_k9:KICK", "DMG BOOST (3): DMG: ("..dmg..") ACC: ("..accdmg..")", cb and cb or "")
				end)
				break
			end
		end
	end
end)