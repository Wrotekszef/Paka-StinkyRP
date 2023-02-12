function GenerateAccountNumber()	
    return tostring(math.random(1111111,9999999))
end

RegisterServerEvent('stinky_bank:checkAccountNumber')
AddEventHandler('stinky_bank:checkAccountNumber', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if xPlayer.character.account_number == nil or xPlayer.character.account_number == '0' then
			local accountNumber = GenerateAccountNumber()
			MySQL.Async.execute('UPDATE users SET account_number = @account_number WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier,
				['@account_number'] = accountNumber
			}, function()
				xPlayer.setCharacter('account_number', accountNumber)
			end)		
		end
	end
end)

AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
	local _source = playerId
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil then
		if xPlayer.character.account_number == nil or xPlayer.character.account_number == '0' then
			local accountNumber = GenerateAccountNumber()
			MySQL.Async.execute('UPDATE users SET account_number = @account_number WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier,
				['@account_number'] = accountNumber
			}, function()
				xPlayer.setCharacter('account_number', accountNumber)
			end)		
		end
	end
end)

RegisterServerEvent('stinky_bank:deposit')
AddEventHandler('stinky_bank:deposit', function(amount)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('chatMessage', _source, "🔔 BANK: ", {255, 0, 0}, " Zła ilość!")
	else
		xPlayer.removeMoney(amount)
		xPlayer.showNotification('~o~Wpłacanie pieniędzy na konto!')
		Wait(5000)
		xPlayer.showNotification('~o~Wpłacono pieniądze!')
		xPlayer.addAccountMoney('bank', tonumber(amount))
		exports['stinky_logs']:SendLog(_source, "Wpłacono " .. amount .. "$ do banku", 'money', '3066993')
	end
end)


RegisterServerEvent('stinky_bank:withdraw')
AddEventHandler('stinky_bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "🔔 BANK: ", {255, 0, 0}, " Zła ilość!")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		exports['stinky_logs']:SendLog(_source, "Wypłacono " .. amount .. "$ z banku", 'money', '15158332')
	end
end)

RegisterServerEvent('stinky_bank:balance')
AddEventHandler('stinky_bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
	
end)

RegisterNetEvent('csskrouble_bank:showTransfers')
AddEventHandler('csskrouble_bank:showTransfers', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll("SELECT * FROM `bank_transfers`", {
		['@licencja'] = xPlayer.identifier
	}, function(results) 
		local filtered = {}
		for i,v in ipairs(results) do
			if results[i].to == xPlayer.identifier then
				if results[i].to_digit == tostring(xPlayer.digit) then
					table.insert(filtered, results[i])
				end	
			end	
		end	
		TriggerClientEvent("csskrouble_bank:callbackTransfers", xPlayer.source, filtered)
	end)
end)

RegisterServerEvent('stinky_bank:transfer')
AddEventHandler('stinky_bank:transfer', function(to, amountt, anon, contest)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local account_number = to
	local balance = xPlayer.getAccount('bank').money
	if contest ~= '' then
		contest = contest
	else
		contest = "Brak"
	end
	if balance > 0 and balance >= tonumber(amountt) and tonumber(amountt) > 0 then
		MySQL.Async.fetchAll('SELECT accounts, identifier, digit, phone_number FROM users WHERE account_number = ?', {account_number}, function(result)
			if result[1] ~= nil then
				if result[1].identifier == xPlayer.identifier then
					xPlayer.showNotification('~r~Nie możesz przelać pieniędzy sam sobie')
				else
					local moneyTable = json.decode(result[1].accounts)
					local currentBank = moneyTable.bank
					local tPlayer = ESX.GetPlayerFromIdentifier(result[1].identifier)
					xPlayer.removeAccountMoney('bank', tonumber(amountt))
					if tonumber(anon) ~= 1 then
						string = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
					else
						string = "Anonimowego nadawcy"
					end
					MySQL.Async.execute("INSERT INTO `bank_transfers` (`from`, `from_label`, `to`, `to_digit`, `title`, `money`) VALUES (@fromI, @fromL, @receiver, @receiverD, @title, @moneyA)", {
						['@fromI'] = xPlayer.identifier,
						['@fromL'] = string,
						['@receiver'] = result[1].identifier,
						['@receiverD'] = result[1].digit,
						['@title'] = contest,
						['@moneyA'] = tonumber(amountt)
					})
					if tPlayer then
						tPlayer.showNotification('~y~Otrzymałeś przelew~w~ na kwotę ~g~' .. amountt .. '$ ~w~od ~y~' .. string .. ' ~w~o treści ~y~'..contest)
						tPlayer.addAccountMoney('bank', tonumber(amountt))
					else
						MySQL.Async.execute('UPDATE users SET accounts = JSON_SET(accounts, "$.bank", @newBank) WHERE identifier = @identifier',
						{
							['@identifier'] = result[1].identifier,
							['@newBank'] = currentBank + amountt
						})
						MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
						{
							['@transmitter'] = 'Bank',
							['@receiver'] = result[1].phone_number,
							['@message'] = 'Otrzymałeś przelew na kwotę ' .. amountt .. '$ od ' .. string .. ' o treści '..contest,
							['@isRead'] = 0,
							['@owner'] = 0
						})
					end
					xPlayer.showNotification('~y~Wysłałeś przelew~w~ na kwotę ~g~' .. amountt .. '$ ~w~na konto ~y~' .. account_number .. '')
					exports['stinky_logs']:SendLog(_source, "Przelano pieniądze do gracza [" .. result[1].identifier .. "] w wysokości " .. amountt .. "$", 'money')
				end
			else
				xPlayer.showNotification("~r~Taki numer konta nie istnieje bądź jest nieaktywny")
			end
		end)
	else
		xPlayer.showNotification("~r~Nie masz wystarczająco pieniędzy lub wystąpiła awaria w banku")
	end
end)

ESX.RegisterServerCallback('stinky_bank:character', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		cb(('Imię i nazwisko: %s %s <br>Numer konta: %s'):format(xPlayer.character.firstname, xPlayer.character.lastname, xPlayer.character.account_number))
	else
		cb(GetPlayerName(source))
	end
end)