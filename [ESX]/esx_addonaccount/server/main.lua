local AccountsIndex, Accounts, SharedAccounts = {}, {}, {}

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		local result = MySQL.query.await('SELECT * FROM addon_account')
		local mieszkania = MySQL.query.await('SELECT * FROM properties WHERE is_gateway = 0')
	
		for k=1, #mieszkania, 1 do
			table.insert(result, {name = 'property_black_money' .. mieszkania[k].name, label = "Mieszkanie", shared = 1})
		end

		for i=1, #result, 1 do
			local name   = result[i].name
			local label  = result[i].label
			local shared = result[i].shared

			local result2 = MySQL.query.await('SELECT * FROM addon_account_data WHERE account_name = ?', {name})
			if shared == 0 then
				table.insert(AccountsIndex, name)
				Accounts[name] = {}

				for j=1, #result2, 1 do
					local addonAccount = CreateAddonAccount(name, result2[j].owner, result2[j].money, result2[j].account_money)
					table.insert(Accounts[name], addonAccount)
				end
			else

				local money = nil
				local account_money = nil

				if #result2 == 0 then
					MySQL.update.await('INSERT INTO addon_account_data (account_name, money, account_money, owner) VALUES (?, ?, ?, NULL)',{name,0,0})
					money = 0
					account_money = 0
				else
					money = result2[1].money
					account_money = result2[1].account_money
				end

				local addonAccount   = CreateAddonAccount(name, nil, money, account_money)
				SharedAccounts[name] = addonAccount

			end
		end
	end
end)

function GetAccount(name, owner)
	for i=1, #Accounts[name], 1 do
		if Accounts[name][i].owner == owner then
			return Accounts[name][i]
		end
	end
end

function GetSharedAccount(name)
	return SharedAccounts[name]
end

AddEventHandler('esx_addonaccount:getAccount', function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

AddEventHandler('esx_addonaccount:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonAccounts = {}

	for i=1, #AccountsIndex, 1 do
		local name    = AccountsIndex[i]
		local account = GetAccount(name, xPlayer.identifier)

		if account == nil then
			MySQL.insert('INSERT INTO addon_account_data (account_name, money, account_money, owner) VALUES (?, ?, ?, ?)', {name, 0, nil, xPlayer.identifier})

			account = CreateAddonAccount(name, xPlayer.identifier, 0, nil)
			Accounts[name][#Accounts[name] + 1] = account
		end

		addonAccounts[#addonAccounts + 1] = account
	end

	xPlayer.set('addonAccounts', addonAccounts)
end)