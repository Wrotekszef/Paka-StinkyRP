local Beds = {
	['Clinic'] = {
		{
			Position = vector4(1136.08, -1585.42, 36.28-0.80, 4.88),
			GetUp = vector4(1137.98, -1575.19, 35.38, 81.5),
			Occupied = false
		},
		{
			Position = vector4(1140.34, -1585.51, 36.28-0.80, 4.88),
			GetUp = vector4(1137.98, -1575.19, 35.38, 81.5),
			Occupied = false
		},
		{
			Position = vector4(1144.49, -1585.26, 36.28-0.80, 4.88),
			GetUp = vector4(1137.98, -1575.19, 35.38, 81.5),
			Occupied = false
		},
		{
			Position = vector4(1148.96, -1585.43, 36.28-0.80, 4.88),
			GetUp = vector4(1137.98, -1575.19, 35.38, 81.5),
			Occupied = false
		},
	},
	
	['Sandy'] = {
		{
			Position = vector4(1820.06, 3669.60, 34.24, 299.33),
			GetUp = vector4(1821.50, 3670.35, 33.32, 299.83),
			Occupied = false
		},
		{
			Position = vector4(1823.02, 3672.12, 34.24, 119.66),
			GetUp = vector4(1823.75, 3671.35, 33.32, 212.84),
			Occupied = false
		},
		{
			Position = vector4(1819.26, 3671.34, 34.24, 299.85),
			GetUp = vector4(1820.47, 3672.02, 33.32, 299.94),
			Occupied = false
		},
		{
			Position = vector4(1818.35, 3672.99, 34.24, 300.02),
			GetUp = vector4(1819.50, 3673.70, 33.32, 299.31),
			Occupied = false
		},
		{
			Position = vector4(1822.04, 3673.96, 34.24, 119.78),
			GetUp = vector4(1821.66, 3674.84, 33.32, 32.62),
			Occupied = false
		},
		{
			Position = vector4(1817.30, 3674.69, 34.24, 297.91),
			GetUp = vector4(1817.16, 3675.74, 33.32, 30.84),
			Occupied = false
		},
	},  
}

RegisterServerEvent('Exile:BarabaszUnoccupied')
AddEventHandler('Exile:BarabaszUnoccupied', function(id, zone)
	if zone ~= nil and id ~= nil and Beds[zone][id].Occupied == true then
		Beds[zone][id].Occupied = false
	end
end)

function StartTreatment(source, zone, price, accountType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local currentBed = nil
	local currentId = nil
	local currentZone = zone

	if currentZone ~= nil then
		for i=1, #Beds[currentZone], 1 do
			if Beds[currentZone][i].Occupied == false then
				currentBed = Beds[currentZone][i]
				currentId = i
				Beds[currentZone][i].Occupied = true
				break
			end
		end
	end

	if currentBed == nil then
		xPlayer.showNotification('~r~Brak wolnych łóżek')
	else
		if price ~= 0 then
			if accountType == "money" then
				xPlayer.removeMoney(price)
			else
				xPlayer.removeAccountMoney('bank', price)
			end
			xPlayer.showNotification("Zapłaciłeś ~g~"..price.."$~w~ za ~y~pomoc medyczną...")
		else
			xPlayer.showNotification("W ramach ~g~ubezpieczenia~w~ otrzymałeś ~y~pomoc medyczną...")
		end

		TriggerClientEvent('Exile:BarabaszAnim', _source, currentId, currentZone, currentBed)
	end
end

RegisterServerEvent('Exile:Barabasz')
AddEventHandler('Exile:Barabasz', function(ems, zone, accountType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local HasInsurance = exports['esx_exilemenu']:CheckInsuranceEMS(xPlayer.job.name)

	if ems == 0 then
		TriggerEvent('esx_license:checkLicense', _source, "ems_insurance", function(has)
			if has or HasInsurance then
				StartTreatment(_source, zone, 0, accountType)
			else
				--if xPlayer.getAccount('bank').money >= 10000 or xPlayer.getMoney() >= 10000 then	
				if accountType == "money" then
					if xPlayer.getMoney() >= 10000 then
						StartTreatment(_source, zone, 10000, accountType)
					else
						xPlayer.showNotification("~r~Nie posiadasz ~g~10.000$~r~ aby zapłacić za ~g~pomoc medyczną")
					end
				elseif accountType == "bank" then
					if xPlayer.getAccount('bank').money >= 10000 then
						StartTreatment(_source, zone, 10000, accountType)
					else
						xPlayer.showNotification("~r~Nie posiadasz ~g~10.000$~r~ aby zapłacić za ~g~pomoc medyczną")
					end
				end
			end
		end)
	else
		TriggerEvent('esx_license:checkLicense', _source, "ems_insurance", function(has)
			local price
			if has or HasInsurance then
				price = 5000
			else
				price = 20000
			end

			if accountType == "money" then
				if xPlayer.getMoney() >= price then
					StartTreatment(_source, zone, price, accountType)
				else
					xPlayer.showNotification("~r~Nie posiadasz ~g~"..price.."$~r~ aby zapłacić za ~g~pomoc medyczną")
				end
			elseif accountType == "bank" then
				if xPlayer.getAccount('bank').money >= price then
					StartTreatment(_source, zone, price, accountType)
				else
					xPlayer.showNotification("~r~Nie posiadasz ~g~"..price.."$~r~ aby zapłacić za ~g~pomoc medyczną")
				end
			end
		end)
	end
end)