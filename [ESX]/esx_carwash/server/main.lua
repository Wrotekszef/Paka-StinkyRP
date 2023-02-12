ESX = nil

TriggerEvent('exile:getsharedobject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_carwash:canAfford', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.EnablePrice then
		if xPlayer.getMoney() >= Config.Price then
			xPlayer.removeAccountMoney('money', Config.Price)
			-- local currentamount = xPlayer.getAccount('money')
			-- xPlayer.setAccountMoney('money', currentamount+Config.Price)
			-- xPlayer.removeMoney(Config.Price)
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end)