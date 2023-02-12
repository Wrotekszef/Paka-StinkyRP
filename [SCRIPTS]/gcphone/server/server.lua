math.randomseed(os.time())

ESX.RegisterServerCallback('e-phone:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer ~= nil then
		local items = xPlayer.getInventoryItem(item)
		
		if items == nil then
			cb(0)
		else
			cb(items.count)
		end
	end
end)

ESX.RegisterServerCallback('e-phone:canUse', function(source, cb, notify)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer ~= nil then
		local phone = xPlayer.getInventoryItem('phone')
		
		if phone and phone.count ~= nil and phone.count > 0 then		
			if xPlayer.character.phone_number ~= nil and xPlayer.character.phone_number ~= '' then				
				local found = false
				
				for k,v in ipairs(xPlayer.getInventory(false)) do
					if v.type == 'sim' then
						if v.data.number == xPlayer.character.phone_number then
							found = true
							local blocked = v.data.blocked == 0
							
							if notify and not blocked then
								xPlayer.showNotification('~r~Karta sim jest zablokowana')
							end
							
							cb(blocked)							
						end
					end
				end
				
				if not found then
					xPlayer.showNotification('~r~Nie posiadasz karty SIM przy sobie')
				end
			else
				if notify then
					xPlayer.showNotification('~r~Nie posiadasz podłączonej karty SIM')
				end
				
				cb(false)
			end
		else
			if notify then
				xPlayer.showNotification('~r~Nie posiadasz telefonu')
			end
			
			cb(false)
		end
		
	end
end)

function getPhoneRandomNumber()
    local numBase0 = math.random(10000,99999)
    local numBase1 = math.random(0,99999)
    local num = string.format("%03d-%04d", numBase0, numBase1 )
	return num
end

ESX.RegisterServerCallback('e-phone:getSimLoaded', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		cb(xPlayer.character.phone_number)
	end
  
end)

RegisterServerEvent('e-phone:zabierz')
AddEventHandler('e-phone:zabierz', function(target, number)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('e-phone:zajebkarte', targetPlayer.source, source, number)
end)

--====================================================================================
--  Utils
--====================================================================================

function getNumberPhone(identifier)
    local result = MySQL.query.await("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.query.await("SELECT identifier FROM users WHERE phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end


function getPlayerID(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	
	local identifiers = (xPlayer ~= nil and xPlayer.identifier or nil)
    return identifiers
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
	if identifier ~= nil then
		local phone_number = MySQL.query.await('SELECT phone_number FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier,
		})
		
		if phone_number[1] == nil then 
			return 
		end
		
		local result = MySQL.query.await("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.ownernumber = @ownernumber", {
			['@ownernumber'] = phone_number[1].phone_number
		})
		
		return result
	end
end
function addContact(source, identifier, number, display)
	if source ~= 0 then
		local sourcePlayer = tonumber(source)
		local phone_number = MySQL.query.await('SELECT phone_number FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier,
		})
		
		MySQL.insert("INSERT INTO phone_users_contacts (`ownernumber`, `number`,`display`) VALUES(@ownernumber, @number, @display)", {
			['@ownernumber'] = phone_number[1].phone_number,
			['@number'] = number,
			['@display'] = display,
		},function()
			notifyContactChange(sourcePlayer, identifier)
		end)
	end
end
function updateContact(source, identifier, id, number, display)
	if source ~= 0 then
		local sourcePlayer = tonumber(source)
		MySQL.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
			['@number'] = number,
			['@display'] = display,
			['@id'] = id,
		},function()
			notifyContactChange(sourcePlayer, identifier)
		end)
	end
end

function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
	local phone_number = MySQL.query.await('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier,
	})
	
    MySQL.update.await("DELETE FROM phone_users_contacts WHERE `ownernumber` = @ownernumber AND `id` = @id", {
        ['@ownernumber'] = phone_number[1].phone_number,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end
function deleteAllContact(identifier)
    MySQL.update.await("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end
function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("e-phone:contactList", sourcePlayer, getContacts(identifier))
    end
end

local cwellist = {}
RegisterServerEvent('e-phone:addContact')
AddEventHandler('e-phone:addContact', function(display, phoneNumber)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local sourcePlayer = tonumber(src)
    local identifier = getPlayerID(src)

	if cwellist[src] then
    	xPlayer.showNotification('~o~Odczekaj chwile!')
	else
		addContact(sourcePlayer, identifier, phoneNumber, display)
	end
	cwellist[src] = true
	CreateThread(function()
		Wait(2000)
		cwellist[src] = nil
	end)
end)

local zjeblist = {}
RegisterServerEvent('e-phone:updateContact')
AddEventHandler('e-phone:updateContact', function(id, display, phoneNumber)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)

	if zjeblist[src] then
    	xPlayer.showNotification('~o~Odczekaj chwile!')
	else
		updateContact(sourcePlayer, identifier, id, phoneNumber, display)
	end
	zjeblist[src] = true
	CreateThread(function()
		Wait(2000)
		zjeblist[src] = nil
	end)
end)

RegisterServerEvent('e-phone:deleteContact')
AddEventHandler('e-phone:deleteContact', function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = MySQL.query.await("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {
         ['@identifier'] = identifier
    })
    return result
end

function _internalAddMessage(transmitter, receiver, message, owner)
	local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
	local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
		['@transmitter'] = transmitter,
		['@receiver'] = receiver,
		['@message'] = message,
		['@isRead'] = owner,
		['@owner'] = owner
	}
	
	local id = MySQL.insert.await(Query, Parameters)
	return MySQL.query.await(Query2, {
		['@id'] = id
	})[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
	
	local memess = _internalAddMessage(phone_number, myPhone, message, 1)
	TriggerClientEvent("e-phone:receiveMessage", sourcePlayer, memess, false)	
	
    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
		local player = ESX.GetPlayerFromIdentifier(otherIdentifier)
		if player ~= nil then
			if player.source ~= source then	
				TriggerEvent('ReturnSkin', source, function(skin)
					if skin then
						TriggerClientEvent("e-phone:receiveMessage", player.source, tomess, source, skin)
					else
						TriggerClientEvent("e-phone:receiveMessage", player.source, tomess, source, false)
					end
				end)
			end	
		end
    end
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.update.await("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.update.await("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.update.await("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.update.await("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('e-phone:sendMessage')
AddEventHandler('e-phone:sendMessage', function(phoneNumber, message)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local sourcePlayer = tonumber(src)
	local identifier = getPlayerID(src)
	addMessage(sourcePlayer, identifier, phoneNumber, message)
	xPlayer.removeAccountMoney('bank', Config.sms)
	TriggerClientEvent('esx:showNotification', sourcePlayer, 'Pobrano za SMS: ~g~'..Config.sms..'$')
end)

RegisterServerEvent('e-phone:deleteMessage')
AddEventHandler('e-phone:deleteMessage', function(msgId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    deleteMessage(msgId)
end)

RegisterServerEvent('e-phone:deleteMessageNumber')
AddEventHandler('e-phone:deleteMessageNumber', function(number)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
end)

RegisterServerEvent('e-phone:deleteAllMessage')
AddEventHandler('e-phone:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('e-phone:setReadMessageNumber')
AddEventHandler('e-phone:setReadMessageNumber', function(num)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('e-phone:deleteALL')
AddEventHandler('e-phone:deleteALL', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("e-phone:contactList", sourcePlayer, {})
    TriggerClientEvent("e-phone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10
local actuallycall = {}

function getHistoriqueCall (num)
    local result = MySQL.query.await("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('e-phone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('e-phone:getHistoriqueCall')
AddEventHandler('e-phone:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)

local czas = 0
RegisterServerEvent('e-phone:internal_startCall')
AddEventHandler('e-phone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    local rtcOffer = rtcOffer
	local id = nil
	local found = false
    if phone_number == nil or phone_number == '' then 
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
	
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
	
    if is_valid == true then		
		local player = ESX.GetPlayerFromIdentifier(destPlayer)
		if player ~= nil then
			if player.source ~= source then
				if not actuallycall[player.source] and not actuallycall[sourcePlayer] then
					if AppelsEnCours[indexCall] == nil then
						AppelsEnCours[indexCall] = {
							id = indexCall,
							transmitter_src = sourcePlayer,
							transmitter_num = srcPhone,
							receiver_src = player.source,
							receiver_num = phone_number,
							is_valid = destPlayer ~= nil,
							is_accepts = false,
							hidden = hidden,
							rtcOffer = rtcOffer,
							extraData = extraData
						}
						
						if not actuallycall[player.source] then
							actuallycall[player.source] = true
						end
						
						if not actuallycall[sourcePlayer] then
							actuallycall[sourcePlayer] = true
						end
						
						TriggerEvent('e-phone:addCall', AppelsEnCours[indexCall])
						TriggerClientEvent('e-phone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
						TriggerClientEvent('e-phone:waitingCall', player.source, AppelsEnCours[indexCall], false)
						found = true
					end
				else
					found = true
					TriggerClientEvent('esx:showNotification', sourcePlayer, '~r~Numer jest aktualnie zajęty')
				end
			end
		end
		
		if not found then
			TriggerClientEvent('esx:showNotification',sourcePlayer, '~r~Numer znajduje się poza abonamentem')
		end
    else
		TriggerClientEvent('esx:showNotification',sourcePlayer, '~r~Numer jest nieprawidłowy lub nie istnieje')
    end

end)

RegisterServerEvent('e-phone:bill')
AddEventHandler('e-phone:bill', function(czas)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ile = math.floor(Config.call * czas / 4)
	xPlayer.removeAccountMoney('bank', ile)
	TriggerClientEvent('esx:showNotification', source, 'Pobrano za połączenie: ~g~'..ile..'$')
end)

RegisterServerEvent('e-phone:startCall')
AddEventHandler('e-phone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('e-phone:internal_startCall', source, phone_number, rtcOffer, extraData)	
end)

RegisterServerEvent('e-phone:candidates')
AddEventHandler('e-phone:candidates', function (callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        TriggerClientEvent('e-phone:candidates', to, candidates)
    end
end)

local czas = 0
local rozmowa = false
RegisterServerEvent('e-phone:acceptCall')
AddEventHandler('e-phone:acceptCall', function(infoCall, rtcAnswer)
	local sourcePlayer = tonumber(source)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('e-phone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
			
			SetTimeout(1000, function()
				if AppelsEnCours[id] ~= nil then
					TriggerClientEvent('e-phone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
				end
			end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)


RegisterServerEvent('e-phone:pobierzkase')
AddEventHandler('e-phone:pobierzkase', function(czas)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ile = math.floor(Config.call * czas)
	xPlayer.removeAccountMoney('bank', ile)
	TriggerClientEvent('esx:showNotification',source, 'Pobrano za połączenie: ~g~'..ile..'$')
end)


RegisterServerEvent('e-phone:rejectCall')
AddEventHandler('e-phone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('e-phone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('e-phone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
		
		if actuallycall[AppelsEnCours[id].transmitter_src] then
			actuallycall[AppelsEnCours[id].transmitter_src] = nil
		end
		
		if actuallycall[AppelsEnCours[id].receiver_src] then
			actuallycall[AppelsEnCours[id].receiver_src] = nil
		end
		
        TriggerEvent('e-phone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('e-phone:appelsDeleteHistorique')
AddEventHandler('e-phone:appelsDeleteHistorique', function(numero)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.update.await("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.update.await("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('e-phone:appelsDeleteAllHistorique')
AddEventHandler('e-phone:appelsDeleteAllHistorique', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)

--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('esx:playerLoaded',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    -- getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
	local myPhoneNumber = getNumberPhone(identifier)
	
	TriggerClientEvent("e-phone:myPhoneNumber", sourcePlayer, myPhoneNumber)
	TriggerClientEvent("e-phone:contactList", sourcePlayer, getContacts(identifier))
	TriggerClientEvent("e-phone:allMessage", sourcePlayer, getMessages(identifier))	
    -- end)
end)

-- Just For reload
RegisterServerEvent('e-phone:allUpdate')
AddEventHandler('e-phone:allUpdate', function()	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		TriggerClientEvent("e-phone:contactList", _source, getContacts(xPlayer.identifier))
		TriggerClientEvent("e-phone:allMessage", _source, getMessages(xPlayer.identifier))
		TriggerClientEvent('e-phone:getBourse', _source, getBourse())
		sendHistoriqueCall(_source, xPlayer.character.phone_number)
	end
end)

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end

RegisterServerEvent('e-phone:blockSIM')
AddEventHandler('e-phone:blockSIM', function(value, state)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if xPlayer.getMoney() >= Config.blockSIM then			
			local Items = ESX.GetItems()
			
			if Items[value.name] then
				for k,v in pairs(Items) do
					if v.data.number == value.number then
						ESX.SetItemsData(v.data.name, 'blocked', state)
					end
				end
				
				xPlayer.removeMoney(Config.blockSIM)
				if state == 1 then
					TriggerClientEvent('esx:showNotification', _source, "Zablokowano kartę z numerem: "..tostring(value.number))
				else
					TriggerClientEvent('esx:showNotification', _source, "Odblokowano kartę z numerem: "..tostring(value.number))
				end				
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczająco pieniędzy')
		end
	end	
end)

RegisterServerEvent('e-phone:CopyContactsSIM')
AddEventHandler('e-phone:CopyContactsSIM', function(phone_number, value)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if xPlayer.getMoney() >= Config.CopyContactsSIM then			
			MySQL.query("SELECT number, display FROM phone_users_contacts WHERE ownernumber = @ownernumber", {
				['@ownernumber'] = phone_number
			}, function(result)
				
				local found = 0
				for k,v in pairs(result) do
					found = found + 1
					
					MySQL.update('INSERT INTO phone_users_contacts (ownernumber,number,display) VALUES(@ownernumber,@number,@display)', {
						['@ownernumber'] = value.number,
						['@number'] = v.number,
						['@display'] = v.display,
					})
				end
				
				if found <= 0 then
					xPlayer.showNotification('~r~Nie posiadasz kontaktów do przeniesienia')
				else
					xPlayer.removeMoney(Config.CopyContactsSIM)
					TriggerClientEvent('esx:showNotification', _source, 'Przeniesiono kontakty na kartę SIM #'..tostring(value.number))			
				end
			end)
		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczająco pieniędzy')
		end
	end
end)

RegisterServerEvent('e-phone:delSIM')
AddEventHandler('e-phone:delSIM', function(value)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if xPlayer.getMoney() >= Config.zastrzezSIM then
			
			local simstodelete = {}
			local Items = ESX.GetItems()
			for k,v in pairs(Items) do
				if v.data.number == value.number then					
					simstodelete[v.data.name] = true
				end
			end
				
			for _, player in ipairs(ESX.GetExtendedPlayers()) do
				local xPlayer = ESX.GetPlayerFromId(player)
				
				if xPlayer ~= nil then
					for delete, __ in pairs(simstodelete) do
						local item = xPlayer.getInventoryItem(delete)

						if item.count > 0 then
							xPlayer.removeInventoryItem(delete, item.count)
						end						
					end
				end
			end
			
			ESX.DeleteDynamicItem(value.name)
			
			xPlayer.removeMoney(Config.zastrzezSIM)
			TriggerClientEvent('esx:showNotification', _source, "Zastrzeżono kartę z numerem: "..tostring(value.number))					
		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczająco pieniędzy')
		end
	end
end)

RegisterServerEvent('e-phone:duplikatSIM')
AddEventHandler('e-phone:duplikatSIM', function(value)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if xPlayer.getMoney() >= Config.duplikatSIM then
			local Items = ESX.GetItems()
			
			if Items[value.name] then
				local item2 = Items[value.name]
				
				ESX.CreateDynamicItem({
					type = 'sim',
					owner = item2.data.owner,
					ownerdigit = item2.data.ownerdigit,
					blocked = item2.data.blocked,
					admin1 = item2.data.admin1,
					admindigit1 = item2.data.admindigit1,			
					admin2 = item2.data.admin2,
					admindigit2 = item2.data.admindigit2,
					number = item2.data.number
				}, function(data)
					xPlayer.removeMoney(Config.duplikatSIM)					
					xPlayer.showNotification("Zapłacono za kartę: "..Config.duplikatSIM.."\nZduplikowano kartę z numerem: "..item2.data.number)
					xPlayer.addInventoryItem(data, 1)	
				end)				
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczająco pieniędzy')
		end
	end
end)

--admins

ESX.RegisterServerCallback('e-phone:getAdministrators', function(source, cb, value)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local Items = ESX.GetItems()
	
	local data = Items[value.name]
	if data then
		local result = {}
		
		local found, found2 = false, false
		
		if data.admin1 ~= '' and data.admindigit1 ~= '' then
			MySQL.query('SELECT firstname, lastname FROM characters WHERE identifier = @identifier AND digit = @digit', {
				['@identifier'] = data.admin1,
				['@digit'] = data.admindigit1
			}, function(result)
				table.insert(result, {label = result[1].firstname .. " " .. result[1].lastname, value = 1})
				found = true
			end)			
		else
			found = true
		end
		
		if data.admin2 ~= '' and data.admindigit2 ~= '' then
			MySQL.query('SELECT firstname, lastname FROM characters WHERE identifier = @identifier AND digit = @digit', {
				['@identifier'] = data.admin2,
				['@digit'] = data.admindigit2
			}, function(result)
				table.insert(result, {label = result[1].firstname .. " " .. result[1].lastname, value = 1})
				found2 = true
			end)		
		else
			found2 = true
		end
		
		while not found or not found2 do
			Wait(200)
		end
	else
		cb({})
	end
end)

RegisterServerEvent('e-phone:_internalAddMessagexdxdtesttesttest')
AddEventHandler('e-phone:_internalAddMessagexdxdtesttesttest', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

RegisterServerEvent('e-phone:removeAdministrator')
AddEventHandler('e-phone:removeAdministrator', function(value, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local Items = ESX.GetItems()
	
	local data = Items[value.name]
	if data then		
		if id == 1 then
			ESX.SetItemsData(value.name, 'admin1', '')
			ESX.SetItemsData(value.name, 'admindigit1', '')
			
			for k,v in ipairs(xPlayer.getInventory(false)) do
				if v.name == value.name then
					v.data.admin1 = ''
					v.data.admindigit1 = ''
				end
			end
				
		elseif id == 2 then
			ESX.SetItemsData(value.name, 'admin2', '')
			ESX.SetItemsData(value.name, 'admindigit2', '')	

			for k,v in ipairs(xPlayer.getInventory(false)) do
				if v.name == value.name then
					v.data.admin2 = ''
					v.data.admindigit2 = ''
				end
			end			
		end
		
		xPlayer.removeMoney(5000)
		xPlayer.showNotification('~g~Usunięto~w~ wybranego administratora numeru ~y~' .. value.number)	
	end
end)

RegisterServerEvent('e-phone:addAdministrator')
AddEventHandler('e-phone:addAdministrator', function(value, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	local Items = ESX.GetItems()

	if xPlayer.getMoney() >= 10000 then
		
		local data = Items[value.name]
		if data then					
			local canadd = false
			
			if data.admin1 == '' and data.admindigit1 == '' then
				ESX.SetItemsData(value.name, 'admin1', tPlayer.identifier)
				ESX.SetItemsData(value.name, 'admindigit1', tPlayer.getDigit())
				
				for k,v in ipairs(xPlayer.getInventory(false)) do
					if v.name == value.name then
						v.data.admin1 = tPlayer.identifier
						v.data.admindigit1 = tPlayer.getDigit()
					end
				end
				
				canadd = true
			elseif data.admin2 == '' and data.admindigit2 == '' then
				ESX.SetItemsData(value.name, 'admin2', tPlayer.identifier)
				ESX.SetItemsData(value.name, 'admindigit2', tPlayer.getDigit())

				for k,v in ipairs(xPlayer.getInventory(false)) do
					if v.name == value.name then
						v.data.admin2 = tPlayer.identifier
						v.data.admindigit2 = tPlayer.getDigit()
					end
				end
				
				canadd = true
			end			
			
			if not canadd then
				xPlayer.showNotification('Ten numer posiada już ~r~maksymalną ilość~w~ administratorów')
			else
				xPlayer.showNotification('~g~Nadano administratora~w~ numeru ~y~' .. value.number .. '~w~ dla [' .. target .. ']')
				tPlayer.showNotification('~g~Zostałeś administratorem~w~ numeru ~y~' .. value.number)
				xPlayer.removeMoney(10000)			
			end
		end	
		
	else
		xPlayer.showNotification('~r~Nie posiadasz wystarczająco pieniędzy')
	end
end)																																																					