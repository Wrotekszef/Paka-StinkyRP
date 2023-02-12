RegisterServerEvent('esx_barbershop:pay')
AddEventHandler('esx_barbershop:pay', function(what)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if what == 'money' then
		xPlayer.removeMoney(Config.Price)
	else
		xPlayer.removeAccountMoney('bank', Config.Price)
	end
	TriggerClientEvent('esx:showNotification', source, _U('you_paid', ESX.Math.GroupDigits(Config.Price)))
end)

ESX.RegisterServerCallback('esx_barbershop:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.Price or xPlayer.getAccount('bank').money >= Config.Price then
		if xPlayer.getMoney() >= Config.Price then
			TriggerClientEvent('esx:showNotification', source, _U('you_paid', Config.Price))
			cb(true, 'money')
		elseif xPlayer.getAccount('bank').money >= Config.Price then
			TriggerClientEvent('esx:showNotification', source, _U('you_paid', Config.Price))
			cb(true, 'bank')
		end
	else
		cb(false)
	end
end)