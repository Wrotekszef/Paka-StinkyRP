RegisterNetEvent("mmflashbang:Particles", function(coords)
    if coords then
        TriggerClientEvent("mmflashbang:Particles", -1, coords)
    end
end)

ESX.RegisterUsableItem('flashbang', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeInventoryItem('flashbang', 1)
        TriggerClientEvent('gdx_flashbang:onFlash', source)
        xPlayer.showNotification('~g~Wyjęto 1x flashbang')
    end
end)