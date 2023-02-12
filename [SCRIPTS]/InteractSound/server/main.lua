RegisterServerEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
	TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to play sound to any players")
end)

RegisterServerEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
	local _source = source
  
    TriggerClientEvent('InteractSound_CL:PlayOnOne', _source, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
    -- TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, soundFile, soundVolume)
    TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to play sound to all players")
end)

--[[RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
	local _source = source
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, _source, maxDistance, soundFile, soundVolume)
end)]]

RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
  if maxDistance > 10 then
    TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to play sound with big distance - "..maxDistance)
    return
  end
  if GetConvar("onesync_enableInfinity", "false") == "true" then
    TriggerClientEvent('InteractSound_CL:PlayWithinDistanceOS', -1, GetEntityCoords(GetPlayerPed(source)), maxDistance, soundFile, soundVolume)
  else
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
  end
end)
