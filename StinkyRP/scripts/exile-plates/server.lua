RegisterServerEvent('exile-plates:buy')
AddEventHandler('exile-plates:buy', function(plate, index, vehicle)
    local _source = source
    MySQL.update.await(
		'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
		{
			['@plate'] = plate,
			['@state'] = "anonymous"
		}
	)

    TriggerClientEvent('exile-plates:buy', _source, plate, index, vehicle)
end)

RegisterServerEvent('exile-plates:delete')
AddEventHandler('exile-plates:delete', function(plate, vehicle, index)
    local _source = source
    MySQL.update.await(
		'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
		{
			['@plate'] = plate,
			['@state'] = "pulledout"
		}
	)
    TriggerClientEvent('exile-plates:delete', _source, plate, vehicle, index)
end)