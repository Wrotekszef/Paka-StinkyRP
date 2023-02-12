local chest = ''
local playerWinnings = {}

CreateThread(function()
	for k, v in pairs(Config["exilecases"]) do
		ESX.RegisterUsableItem(k, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			if not playerWinnings[source] then
				xPlayer.removeInventoryItem(k, 1)
				local winning = CalculateWin(k)
				playerWinnings[source] = winning
				TriggerClientEvent('exile_boxes:openexilecases', source, k, winning)
				chest = k
			end
		end)
	end
end)

AddEventHandler("playerDropped", function()
	local src = source
	playerWinnings[src] = nil
end)

function CalculateWin(type) 
	local sum = 0
	local draw = {}
	for k, v in pairs(Config["exilecases"][type].list) do
		local rate = Config["chance"][v.tier].rate * 100
		for i=1,rate do 
			if v.item then
				if v.amount then
					table.insert(draw, {item = v.item ,amount = v.amount, tier = v.tier})
				else
					table.insert(draw, {item = v.item ,amount = 1, tier = v.tier})
				end
			elseif v.weapon then
				table.insert(draw, {weapon = v.weapon , amount = v.amount, tier = v.tier})
			elseif v.vehicle then
				table.insert(draw, {vehicle = v.vehicle, tier = v.tier})
			elseif v.money then
				table.insert(draw, {money = v.money, tier = v.tier})
			elseif v.black_money then
				table.insert(draw, {black_money = v.black_money, tier = v.tier})
			end
			i = i + 1
		end
		sum = sum + rate
	end
	local random = math.random(1,sum)
	local data = Config["exilecases"][type].list
	local img = Config["image_source"]
	local win = draw[random]
	return {data = data, img = img, win = win}
end

RegisterServerEvent('exile_boxes:giveReward', function() 
	local src = source
	
	if not playerWinnings[src] then
		TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Próba oszukiwania w skrzynkach")
		return
	end

	local xPlayer = ESX.GetPlayerFromId(src)
	local win = playerWinnings[src].win
	local logChannel = ''
	local skrzynki = chest

	if skrzynki ~= 'dailycase' then
		logChannel = 'skrzynki'
	else
		logChannel = 'dailycase'
	end

	if win.item then
		Wait(5000)
		xPlayer.addInventoryItem(win.item, win.amount)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.item.." x"..win.amount.." z skrzynki "..skrzynki, logChannel, '5793266')
	elseif win.weapon then
		Wait(5000)
		xPlayer.addInventoryWeapon(win.weapon, win.amount, 1, false)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.weapon.." x"..win.amount.." z 5 ammo z skrzynki "..skrzynki, logChannel, '5793266')
	elseif win.money then
		Wait(5000)
		xPlayer.addMoney(win.money)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.money.."$ z skrzynki "..skrzynki, logChannel, '5793266')
	elseif win.black_money then
		Wait(5000)
		xPlayer.addAccountMoney('black_money', win.black_money)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.black_money.."$ brudnej gotowki z skrzynki "..skrzynki, logChannel, '5793266')
	end
	
	playerWinnings[src] = nil
end)