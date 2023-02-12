--CLOTHES

local clothes = {}

MySQL.ready(function()
	MySQL.query('SELECT * FROM db_clothes', function(result)
		for k,v in ipairs(result) do
			clothes[v.identifier] = {
				bags_1 = v.bag,
				bags_2 = v.bag2,
				tshirt_1 = v.tshirt,
				tshirt_2 = v.tshirt2,
				torso_1 = v.torso,
				torso_2 = v.torso2,
				pants_1 = v.legs,
				pants_2 = v.legs2,
				shoes_1 = v.shoes,
				shoes_2 = v.shoes2,
				arms = v.arms,
				arms_2 = v.arms2,
				chain_1 = v.chain,
				chain_2 = v.chain2,
				mask_1 = v.mask,
				mask_2 = v.mask2,
				decals_1 = v.decals,
				decals_2 = v.decals2,
				helmet_1 = v.hat,
				helmet_2 = v.hat2,
				glasses_1 = v.glasses,
				glasses_2 = v.glasses2,
				watches_1 = v.watches,
				watches_2 = v.watches2,
				bracelets_1 = v.bracelets,
				bracelets_2 = v.bracelets2,
				bproof_1 = v.bproof1,
				bproof_2 = v.bproof2,
				face_1 = v.face,
				hair_1 = v.hair,
			}	
		end
	end)	
end)

function item(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer ~= nil then
		local identifier = xPlayer.identifier
		
		if clothes[identifier] then
			return clothes[identifier]
		else
			return nil
		end
	else
		return nil
	end
end

RegisterServerEvent('esx_ciuchy:takeoff')
AddEventHandler('esx_ciuchy:takeoff', function(what, id)
	TriggerClientEvent('falszywyy_clothes:PutOff', id, what)
end)

ESX.RegisterServerCallback('falszywyy_clothes:getClothes', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		local identifier = xPlayer.identifier
		
		if clothes[identifier] then			
			cb(clothes[identifier])
		end
	end
end)

RegisterServerEvent('falszywyy_clothes:saveClothes')
AddEventHandler('falszywyy_clothes:saveClothes', function(tosave)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		local identifier = xPlayer.identifier
		
		if clothes[identifier] then
			for k,v in pairs(tosave) do				
				clothes[identifier][k] = v
			end
		end
	end
end)


RegisterServerEvent('falszywyy_clothes:addClothes')
AddEventHandler('falszywyy_clothes:addClothes', function(id, bag, bag2, tshirt, tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, arms2, watches, watches2, bracelets, bracelets2, chain, chain2, mask, mask2, decals, decals2, hat, hat2, glasses, glasses2, bproof1, bproof2, face, hair)
	local _source = source
	local xPlayer = nil
	
	if id ~= false then
		xPlayer = ESX.GetPlayerFromId(id)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end
	
	if xPlayer ~= nil then
		clothes[xPlayer.identifier] = {
			bags_1 = bag,
			bags_2 = bag2,
			tshirt_1 = tshirt,
			tshirt_2 = tshirt2,
			torso_1 = torso,
			torso_2 = torso2,
			pants_1 = legs,
			pants_2 = legs2,
			shoes_1 = shoes,
			shoes_2 = shoes2,
			arms = arms,
			arms_2 = arms2,
			chain_1 = chain,
			chain_2 = chain2,
			mask_1 = mask,
			mask_2 = mask2,
			decals_1 = decals,
			decals_2 = decals2,
			helmet_1 = hat,
			helmet_2 = hat2,
			glasses_1 = glasses,
			glasses_2 = glasses2,
			watches_1 = watches,
			watches_2 = watches2,
			bracelets_1 = bracelets,
			bracelets_2 = bracelets2,
			bproof_1 = bproof1,
			bproof_2 = bproof2,
			face_1 = face,
			hair_1 = hair,			
		}		
	end
end)

AddEventHandler('playerDropped', function()
	local playerId = source
	local name = item(playerId)
		
	if name ~= nil then
		local xPlayer = ESX.GetPlayerFromId(playerId)
		if xPlayer ~= nil then
			local digit = xPlayer.getDigit()
			
			MySQL.query('SELECT digit FROM db_clothes WHERE identifier = ? AND digit = ?', {xPlayer.identifier, digit}, function(result)
				if result[1] ~= nil then
					MySQL.update("UPDATE db_clothes SET bag=?, bag2=?, tshirt=? , tshirt2=?, torso=?, torso2=?, legs=?, legs2=?, shoes=?, shoes2=?, arms=?, arms2=?, chain=?, chain2=?,mask=?,mask2=?,decals=?,decals2=?,hat=?,hat2=?,watches=?,watches2=?,bracelets=?,bracelets2=?,glasses=?,glasses2=?,bproof1=?,bproof2=?, face=?, hair=? WHERE identifier=? AND digit = ?", {name.bags_1, name.bags_2, name.tshirt_1, name.tshirt_2, name.torso_1, name.torso_2, name.pants_1, name.pants_2, name.shoes_1, name.shoes_2,name.arms, name.arms_2, name.chain_1, name.chain_2, name.mask_1, name.mask_2, name.decals_1, name.decals_2, name.helmet_1, name.helmet_2, name.watches_1, name.watches_2,name.bracelets_1,name.bracelets_2,name.glasses_1,name.glasses_2,name.bproof_1, name.bproof_2,name.face_1,name.hair_1, xPlayer.identifier, digit})
				else
					MySQL.update("INSERT INTO db_clothes (identifier, digit, bag, bag2, tshirt , tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, arms2, chain, chain2,mask,mask2,decals,decals2,hat,hat2,watches,watches2,bracelets,bracelets2,glasses,glasses2,bproof1,bproof2,face,hair) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", {xPlayer.identifier, digit, name.bags_1, name.bags_2, name.tshirt_1, name.tshirt_2, name.torso_1, name.torso_2, name.pants_1, name.pants_2, name.shoes_1, name.shoes_2,name.arms, name.arms_2, name.chain_1, name.chain_2, name.mask_1, name.mask_2, name.decals_1, name.decals_2, name.helmet_1, name.helmet_2, name.watches_1, name.watches_2,name.bracelets_1,name.bracelets_2,name.glasses_1,name.glasses_2,name.bproof_1, name.bproof_2,name.face_1,name.hair_1})
				end
			end)	
		end
	end
end)



ESX.RegisterUsableItem('suppressor', function(source)	
	TriggerClientEvent('es_extended:setComponent', source, true, 'suppressor')
end)

ESX.RegisterUsableItem('flashlight_dodatek', function(source)	
    TriggerClientEvent('es_extended:setComponent', source, true, 'flashlight_dodatek')
end)

ESX.RegisterUsableItem('grip', function(source)	
	TriggerClientEvent('es_extended:setComponent', source, true, 'grip')
end)

ESX.RegisterUsableItem('clip_extended', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'clip_extended')
end)

ESX.RegisterUsableItem('clip_box', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'clip_box')
end)

ESX.RegisterUsableItem('scope_large', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_large')
end)

ESX.RegisterUsableItem('scope_medium', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_medium')
end)

ESX.RegisterUsableItem('scope_holo', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_holo')
end)

ESX.RegisterUsableItem('clip_drum', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'clip_drum')
end)

ESX.RegisterUsableItem('scope', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope')
end)

ESX.RegisterUsableItem('scope_advanced', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_advanced')
end)

ESX.RegisterUsableItem('scope_zoom', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_zoom')
end)

ESX.RegisterUsableItem('scope_nightvision', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_nightvision')
end)

ESX.RegisterUsableItem('scope_thermal', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_thermal')
end)