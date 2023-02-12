local antyzjeb = {}

ESX['RegisterServerCallback']('loffe_animations:get_favorites', function(source, cb)
    local xPlayer = ESX['GetPlayerFromId'](source)

    MySQL['Async']['fetchScalar']("SELECT animacje FROM users WHERE identifier=@identifier", {['@identifier'] = xPlayer['identifier']}, function(result)
        if not result then
            MySQL['Async']['execute']([[
                UPDATE `users` SET animacje=@animacje WHERE identifier=@identifier
            ]], {
                ['@animacje'] = '{}',
                ['@identifier'] = xPlayer['identifier'],
            })
            cb('{}')
        else
            cb(result or '{}')
        end
    end)
end)

RegisterServerEvent('loffe_animations:update_favorites')
AddEventHandler('loffe_animations:update_favorites', function(animacje)
    local xPlayer = ESX['GetPlayerFromId'](source)

    MySQL['Async']['execute']([[
        UPDATE `users` SET animacje=@animacje WHERE identifier=@identifier
    ]], {
        ['@animacje'] = animacje,
        ['@identifier'] = xPlayer['identifier'],
    })

	TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['Updated_Favorites'])
end)

RegisterServerEvent('loffe_animations:syncAccepted')
AddEventHandler('loffe_animations:syncAccepted', function(requester, id)
    local accepted = source
    if requester == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (1)")
		return
	end
    TriggerClientEvent('loffe_animations:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('loffe_animations:playSynced', requester, accepted, id, 'Requester')
	AntyZjeb(source)
end)

RegisterServerEvent('loffe_animations:requestSynced')
AddEventHandler('loffe_animations:requestSynced', function(target, id)
    local requester = source
    local xPlayer = ESX['GetPlayerFromId'](requester)
    if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (2)")
		return
	end
    MySQL['Async']['fetchScalar']("SELECT firstname FROM users WHERE identifier=@identifier", {['@identifier'] = xPlayer['identifier']}, function(firstname)
        TriggerClientEvent('loffe_animations:syncRequest', target, requester, id, firstname)
    end)
	AntyZjeb(source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje4')
AddEventHandler('route68_animacje:OdpalAnimacje4', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (3)")
		return
	end
	xTarget.showNotification('~y~Naciśnij ~b~[Y] ~y~aby zostać noszonym przez ~b~['..xPlayer.source..']')
	xPlayer.showNotification('~b~Oczekiwanie na akceptację przez obywatela ~y~['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:przytulSynchroC2', xTarget.source, xPlayer.source)
	AntyZjeb(source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje69')
AddEventHandler('route68_animacje:OdpalAnimacje69', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (4)")
		return
	end
	xTarget.showNotification('~y~Naciśnij ~b~[Y] ~y~aby zostać noszonym przez ~b~['..xPlayer.source..']')
	xPlayer.showNotification('~b~Oczekiwanie na akceptację przez obywatela ~y~['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:przytulSynchroC269', xTarget.source, xPlayer.source)
	AntyZjeb(source)
end)

RegisterServerEvent('cmg2_animations:stop69')
AddEventHandler('cmg2_animations:stop69', function(target)
	local xTarget = ESX.GetPlayerFromId(target)
	if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (5)")
		return
	end
	if xTarget ~= nil then
		TriggerClientEvent('cmg2_animations:cl_stop69', xTarget.source)
	end
	AntyZjeb(source)
end)

RegisterServerEvent('cmg2_animations:sync69')
AddEventHandler('cmg2_animations:sync69', function(target, animationLib69,animationLib269, animation69, animation269, distans69, distans69, height69,targetSrc,length69,spin69,controlFlagSrc69,controlFlagTarget69,animFlagTarget69)
	if targetSrc == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (6)")
		return
	end
	TriggerClientEvent('cmg2_animations:syncTarget69', targetSrc, source, animationLib269, animation269, distans69, distans269, height69, length69,spin69,controlFlagTarget69,animFlagTarget69)
	TriggerClientEvent('cmg2_animations:syncMe69', source, animationLib69, animation69,length69,controlFlagSrc69,animFlagTarget69)
	AntyZjeb(source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje569')
AddEventHandler('route68_animacje:OdpalAnimacje569', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (7)")
		return
	end
	TriggerClientEvent('cmg2_animations:startMenu269', xTarget.source)
	AntyZjeb(source)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(target)
	local xTarget = ESX.GetPlayerFromId(target)
	if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (8)")
		return
	end
	if xTarget ~= nil then
		TriggerClientEvent('cmg2_animations:cl_stop', xTarget.source)
	end
	AntyZjeb(source)
end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	if targetSrc == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (9)")
		return
	end
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	AntyZjeb(source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje5')
AddEventHandler('route68_animacje:OdpalAnimacje5', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if target == -1 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry all players (9)")
		return
	end
	TriggerClientEvent('cmg2_animations:startMenu2', xTarget.source)
	AntyZjeb(source)
end)

AddEventHandler('playerDropped', function()
	local playerId = source

	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer then
		MySQL.ready(function ()
			MySQL.Sync.execute("UPDATE `users` set `slot` = @slot WHERE identifier=@identifier", {['@slot'] = '[]', ['@identifier'] = xPlayer.identifier})
		end)
	end
end)

function AntyZjeb(id)
	if not antyzjeb[id] then
		antyzjeb[id] = 0
	end
	antyzjeb[id] = antyzjeb[id] + 1
	if antyzjeb[id] > 8 then
		TriggerEvent("exilerp_scripts:banPlr", "nigger", source, "Tried to carry 8 times in 3 sec.")
	end
	Citizen.Wait(3000)
	if antyzjeb[id] then
		antyzjeb[id] = antyzjeb[id] - 1
	end
end