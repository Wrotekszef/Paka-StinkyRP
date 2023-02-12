RegisterCommand("flashbang", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.group == 'best' then
		GiveWeaponToPed(PlayerPedId(), `WEAPON_FLASHBANG`, 10, false, true)
	end
end, false)