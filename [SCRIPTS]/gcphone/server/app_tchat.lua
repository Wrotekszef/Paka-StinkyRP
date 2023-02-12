function TchatGetMessageChannel (channel, cb)
    MySQL.query("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", { 
        ['@channel'] = channel
    }, cb)
end

function TchatAddMessage (channel, message)
  local Query = "INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message);"
  local Query2 = 'SELECT * from phone_app_chat WHERE `id` = @id;'
  local Parameters = {
    ['@channel'] = channel,
    ['@message'] = message
  }
  MySQL.insert(Query, Parameters, function (id)
    MySQL.query(Query2, { ['@id'] = id }, function (reponse)
      TriggerClientEvent('e-phone:tchat_receive', -1, reponse[1])
    end)
  end)
end


RegisterServerEvent('e-phone:tchat_channelxdxdtesttesttest')
AddEventHandler('e-phone:tchat_channelxdxdtesttesttest', function(channel)
  local sourcePlayer = tonumber(source)
  TchatGetMessageChannel(channel, function (messages)
    TriggerClientEvent('e-phone:tchat_channelxdxdtesttesttest', sourcePlayer, channel, messages)
  end)
end)

RegisterServerEvent('e-phone:tchat_addMessage')
AddEventHandler('e-phone:tchat_addMessage', function(channel, message)
  TchatAddMessage(channel, message)
end)