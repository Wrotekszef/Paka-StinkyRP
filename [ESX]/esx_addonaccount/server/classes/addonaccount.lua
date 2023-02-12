function CreateAddonAccount(name, owner, money, account_money)
	local self = {}

	self.name  = name
	self.owner = owner
	self.money = money
	self.account_money = account_money
	
	self.addMoney = function(m)
		self.money = self.money + m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end
	
	self.addAccountMoney = function(m)
		self.account_money = self.account_money + m

		self.save()

		TriggerClientEvent('esx_addonaccount:setAccountMoney', -1, self.name, self.account_money)
	end

	self.removeMoney = function(m)
		self.money = self.money - m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end
	
	self.removeAccountMoney = function(m)
		self.account_money = self.account_money - m

		self.save()

		TriggerClientEvent('esx_addonaccount:setAccountMoney', -1, self.name, self.account_money)
	end

	self.setMoney = function(m)
		self.money = m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end
	
	self.setAccountMoney = function(m)
		self.account_money = m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.account_money)
	end

	self.save = function()
		if self.owner == nil then
			MySQL.update('UPDATE addon_account_data SET money = ?, account_money = ? WHERE account_name = ?',{self.money,self.account_money,self.name})
		else
			MySQL.update('UPDATE addon_account_data SET money = ? WHERE account_name = ? AND owner = ?',{self.money,self.name,self.owner})
		end
	end

	return self
end