ESX = nil
TriggerEvent("exile:getsharedobject", function(obj) ESX = obj end)

math.randomseed(os.time())

local plates = {}
ESX.RegisterServerCallback("exilerp_temp:checkPlate", function(src, cb, plate)
    local is = false
    for k,v in pairs(plates) do
        if v == plate then
            is = true
            break
        end
    end
    cb(is)
end)

function checkPlate(plate) 
    local is = false
    local realPlate = ""
    for k,v in pairs(plates) do
        if v == plate then
            is = true
            realPlate = k
            break
        end
    end
    return {is = is, plate = realPlate}
end

function removePlate(plate) 
    plates[plate] = nil
end

RegisterServerEvent("exilerp_temp:tempPlate", function(veh, carPlate) 
    local src = source
    if not checkPlate(carPlate).is then
        local randomPlate = generate_key(8)
        plates[carPlate] = randomPlate
        TriggerClientEvent("exilerp_temp:setPlate", src, veh, randomPlate)
        TriggerClientEvent("esx:showNotification", src, "~g~Przebito blachy w pojeździe ~c~"..carPlate.." ~g~nowe blachy to ~c~"..randomPlate.."")
        print("[temp] Saved ["..carPlate.."] - "..randomPlate)
    else
        TriggerClientEvent("esx:showNotification", src, "~r~Ten pojazd ma już przebite blachy!")
        print("[temp] Failed to save ["..carPlate.."]")
    end
end)

local character_set = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

local string_sub = string.sub
local math_random = math.random
local table_concat = table.concat
local character_set_amount = #character_set
local number_one = 1
local default_length = 10

function generate_key(length)
    local random_string = {}

    for int = number_one, length or default_length do
        local random_number = math_random(number_one, character_set_amount)
        local character = string_sub(character_set, random_number, random_number)

        random_string[#random_string + number_one] = character
    end

    return table_concat(random_string)
end