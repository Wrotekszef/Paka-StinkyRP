RegisterNetEvent("e-phone:tchat_receive")
AddEventHandler("e-phone:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("e-phone:tchat_channelxdxdtesttesttest")
AddEventHandler("e-phone:tchat_channelxdxdtesttesttest", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('e-phone:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('e-phone:tchat_channelxdxdtesttesttest', data.channel)
end)
