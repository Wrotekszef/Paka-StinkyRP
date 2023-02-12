function CreateAddonInventory(name, owner, items)
	local self = {}

	self.name  = name
	self.owner = owner
	self.items = items

	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

		Wait(100)
		self.saveItem(name, item.count)
	end

	self.removeItem = function(name, count)
		local item = self.getItem(name)

		if (item.count - count) >= 0 then

			item.count = item.count - count
			self.saveItem(name, item.count)
	
			return true
		end

		return false
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.saveItem(name, item.count)
	end

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end
		
		local tires = 0
		while not Items[name] and tires < 2000 do
			Wait(100)
			tires = tires + 1
		end

		local item = {
			name  = name,
			count = 0,
			label = Items[name].label,
			type = Items[name].type
		}

		table.insert(self.items, item)

		if self.owner == nil then
			MySQL.update('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (?, ?, ?)',
			{self.name,name,0})
		else
			MySQL.update('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (?, ?, ?, ?)',{self.name,name, 0,self.owner})
		end
		
		return item
	end

	self.saveItem = function(name, count)
		if self.owner == nil then
			MySQL.update('UPDATE addon_inventory_items SET count = ? WHERE inventory_name = ? AND name = ?',{count,self.name,name})
		else
			MySQL.update('UPDATE addon_inventory_items SET count = ? WHERE inventory_name = ? AND name = ? AND owner = ?',{count,self.name,name,self.owner})
		end
	end

	return self
end