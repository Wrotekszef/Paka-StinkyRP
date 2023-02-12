local falszywyy = {
	['weed_pooch'] = math.random(1800, 2400),
	['meth_pooch'] = math.random(4200, 5600),
	['coke_pooch'] = math.random(5200, 8400),
	['cokeperico_pooch'] = math.random(6000, 8000),
	['opium_pooch'] = math.random(7000, 10000),
	['oghaze_pooch'] = math.random(2400, 3000),
	['exctasy_pooch'] = math.random(2600, 3600),

}

RegisterCommand('dealer', function(source, args, rawcommand)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'offsheriff' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance' then
		xPlayer.showNotification('~r~Nie masz dostępu jako członek frakcji!')
	else
		local drugToSell = {
			type = '',
			label = '',
			count = 0,
			i = 0,
			price = 0,
		}
		for k, v in pairs(falszywyy) do
			local item = xPlayer.getInventoryItem(k)
				
			if item == nil then
				return        
			end
			local cops = exports['esx_scoreboard']:CounterPlayers('police') + exports['esx_scoreboard']:CounterPlayers('sheriff')
			if cops <= 2 then
			 	xPlayer.showNotification('~r~Na służbie nie ma wystarczająco SASP/SASD!')
			 	return
			end
			local samarkaStatus = exports['esx_basicneeds']:samarkaStatus(source)
			local count = item.count
			drugToSell.i = drugToSell.i + 1
			drugToSell.type = k
			drugToSell.label = item.label
			
			if count == 1 then
				drugToSell.count = 1
			elseif count == 2 then
				drugToSell.count = math.random(1,2)
			elseif count == 3 then
				drugToSell.count = math.random(1,3)
			elseif count == 4 then
				drugToSell.count = math.random(1,4)
			elseif count >= 5 then
				drugToSell.count = math.random(1,5)
			end
			
			drugToSell.price = v
			if cops > 4 and cops < 8 then 
				drugToSell.price = drugToSell.price * 1.10
			elseif cops > 8 and cops < 12 then
				drugToSell.price = drugToSell.price * 1.20
			elseif cops > 12 and cops < 16 then
				drugToSell.price = drugToSell.price * 1.30
			elseif cops > 16 then
				drugToSell.price = drugToSell.price * 1.40
			end

			if drugToSell.count ~= 0 then
				TriggerClientEvent('exile_selldrugs:findClientnadrugi', source, drugToSell, cops, samarkaStatus)
				break
			end
			
			if ESX.Table.SizeOf(falszywyy) == drugToSell.i and drugToSell.count == 0 then
				xPlayer.showNotification('~r~Nie posiadasz narkotyków!')
			end
		end
	end
end, false)

RegisterServerEvent('exile_selldrugs:payzadrugi')
AddEventHandler('exile_selldrugs:payzadrugi', function(drugToSell, kordy)
	local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local chance = math.random(1,100)

	local locale = {
		['meth_pooch'] = drugToSell.count == 1 and 'paczkę metamfetaminy za' or 'paczki metamfetaminy za',
		['opium_pooch'] = drugToSell.count == 1 and 'paczkę opium za' or 'paczki opium za',
		['weed_pooch'] = drugToSell.count == 1 and 'paczkę marihuany za' or 'paczki marihuany za',
		['coke_pooch'] = drugToSell.count == 1 and 'paczkę kokainy za' or 'paczki kokainy za',
		['cokeperico_pooch'] = drugToSell.count == 1 and 'paczkę kokainy Perico za' or 'paczki kokainy za',
		['oghaze_pooch'] = drugToSell.count == 1 and 'woreczek OG Haze za' or 'woreczków OG Haze za',
		['exctasy_pooch'] = drugToSell.count == 1 and 'tabletkę ekstazy' or 'tabletek ekstazy'
	}

	if xPlayer.group == 'vip' then
		drugToSell.price = drugToSell.price * 1.25
	end

	local itemCount = xPlayer.getInventoryItem(drugToSell.type).count
	local money = (drugToSell.price * itemCount)

	if(chance < 2) then
		xPlayer.removeInventoryItem(drugToSell.type, itemCount)
		if drugToSell.type == 'weed_pooch' or drugToSell.type == 'oghaze_pooch' then
			xPlayer.addAccountMoney('money', (falszywyy[drugToSell.type] * itemCount))
		else
			xPlayer.addAccountMoney('black_money', (falszywyy[drugToSell.type] * itemCount))
		end
		TriggerClientEvent("exilerp_scripts:gigacpun", source, money)
		exports['exile_logs']:SendLog(source, 'Sprzedał: '..itemCount..'x '..locale[drugToSell.type]..' za: '.. (drugToSell.price * itemCount) ..'$ ['..kordy..']', 'selldrugs')
	else
		xPlayer.removeInventoryItem(drugToSell.type, drugToSell.count)
		if drugToSell.type == 'weed_pooch' or drugToSell.type == 'oghaze_pooch' then
			xPlayer.addAccountMoney('money', drugToSell.price * drugToSell.count)
		else
			xPlayer.addAccountMoney('black_money', drugToSell.price * drugToSell.count)
		end
		xPlayer.showNotification('Sprzedałeś ~o~'..drugToSell.count..' '..locale[drugToSell.type]..' ~g~'..drugToSell.price * drugToSell.count..'$')
		exports['exile_logs']:SendLog(source, 'Sprzedał: '..drugToSell.count..'x '..locale[drugToSell.type]..' za: '..drugToSell.price * drugToSell.count..'$ ['..kordy..']', 'selldrugs')
	end
	
	local prezentymatma = math.random(1, 100)
	if prezentymatma >= 75 then
		xPlayer.addInventoryItem('serduszka', 8)
		xPlayer.showNotification('Otrzymano ~o~8x Serduszka')
	end

	local samarkaReward = math.random(1, 100)
	if samarkaReward <= 10 then
		xPlayer.addInventoryItem('samarka', 1)
		xPlayer.showNotification('~g~Gratulację! ~w~Znalazłeś/aś ~b~samarkę!')
	end
end)