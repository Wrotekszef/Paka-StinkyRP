RegisterCommand("battlepass", function(source, args, rawCommand)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.group == 'battlepass' then
        xPlayer.addMoney(100000)
        xPlayer.showNotification('Otrzymałeś nagrodę w wysokości: 100000$')
    else
        xPlayer.showNotification('Nie posiadasz odpowiedniej roli do odebrania!')
    end
end, false)
