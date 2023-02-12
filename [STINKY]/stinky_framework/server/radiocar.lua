local carsWithRadio = {}
local radioData = {}

RegisterServerEvent("exilerp_radio:play", function(veh, url, vol) 
    if tonumber(vol) and tonumber(vol) > 100 or tonumber(vol) < 0 then
        return 
    end
	local car = veh
	local car1 = "radio:"..math.random(1000000, 9999999)
	if not carsWithRadio[car] then
		carsWithRadio[car] = true
		radioData[car] = {
			entity = car,
			url = url,
			vol = vol/100
		}
		TriggerClientEvent("exilerp_radio:sync", -1, car, radioData[car].url, radioData[car].vol, true)
	else
        carsWithRadio[veh] = false
        TriggerClientEvent("exilerp_radio:sync", -1, veh, "chuj", "chuj", false)
        Wait(50)
        carsWithRadio[car] = true
		radioData[car] = {
			entity = car,
			url = url,
			vol = vol/100
		}
		TriggerClientEvent("exilerp_radio:sync", -1, car, radioData[car].url, radioData[car].vol, true)
    end
end)

AddEventHandler("onResourceStop", function(rsrcname) 
    if GetCurrentResourceName() == rsrcname then
        for k,v in pairs(carsWithRadio) do
            if v == true then
                TriggerClientEvent("exilerp_radio:sync", -1, k, "chuj", "chuj", false)
            end
        end
    end
end)

RegisterServerEvent("exilerp_radio:changeVol", function(veh, vol) 
    if tonumber(vol) and tonumber(vol) > 100 or tonumber(vol) < 0 then
        return 
    end
	TriggerClientEvent("exilerp_radio:setVol", -1, veh, vol/100)
    radioData[veh].vol = vol/100
end)

RegisterServerEvent("exilerp_radio:stop", function(veh) 
	TriggerClientEvent("exilerp_radio:sync", -1, veh, "chuj", "chuj", false)
	carsWithRadio[veh] = false
end)