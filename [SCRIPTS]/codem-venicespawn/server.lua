ESX.RegisterServerCallback("codem:server:totalplayer",function(source,cb)

    local player = ESX.GetPlayers()

    cb(#player)

end)
