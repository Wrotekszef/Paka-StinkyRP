local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' },
}
local KeyOpenClose = 288 
local KeyTakeCall = 38
local menuIsOpen = false
local contacts = {}
local messages = {}
local isSpeaking = false
local myPhoneNumber = ''
local isDead = false
local USE_RTC = false
local callStartTime = nil
local ignoreFocus = false
local useMouse = false
local isAllowed = false
local takePhoto = false
local hasFocus = false

local PhoneInCall = {}
local currentPlaySound = false
local soundId = 1485
local soundDistanceMax = 8.0

function PhoneNumber()
	return myPhoneNumber
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("route68:shownotif")
AddEventHandler("route68:shownotif", function(text, color)
	ESX.ShowNotification(text)
end)

RegisterNetEvent('telefon')
AddEventHandler('telefon', function()
    ESX.TriggerServerCallback('e-phone:canUse', function(pass)
		if pass then
			TooglePhone()
		end
    end, true)
end)

RegisterNetEvent('kartasimsteel')
AddEventHandler('kartasimsteel', function(playerId)
local player, distance = ESX.Game.GetClosestPlayer()
local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(target))
	if distance ~= -1 and distance <= 3.0 then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		TriggerServerEvent('e-phone:zabierz', GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification("~r~W poblizu nie ma zadnego obywatela")
	end
end)
  
function HasPhone(cb)
	ESX.TriggerServerCallback('e-phone:canUse', function(pass)
		if pass then
			cb(true)
		end
	end, true)
end

function ShowNoPhoneWarning()
	ESX.ShowNotification("~r~Nie posiadasz telefonu")
end

AddEventHandler('playerSpawned', function()
	isDead = false
	SendNUIMessage({event = 'updateDead', isDead = isDead})
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	SendNUIMessage({event = 'updateDead', isDead = isDead})
end)


CreateThread(function()
	local lastMenu = false
	while true do
		Wait(444)
		if lastMenu ~= menuIsOpen then
			TriggerServerEvent('e-phone:setOpen', menuIsOpen)
			lastMenu = menuIsOpen
		end

		isAllowed = not isDead and not exports['esx_policejob']:IsCuffed()
	end
end)

  
RegisterCommand('showphone', function()
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() then
		ESX.TriggerServerCallback('e-phone:canUse', function(pass)
			if pass then
				TooglePhone()	
			end
		end, true)	  
	end
end)

RegisterKeyMapping('showphone', 'Otwórz/zamknij telefon', 'keyboard', 'F1')

local sleep = 500
CreateThread(function()
  	while true do
		if menuIsOpen then
			sleep = 0
			if not isAllowed or IsPedBeingStunned(PlayerPedId()) then
				TooglePhone()
			else
				sleep = 0
				DisableControlAction(0, 25,   true) -- Input Aim
				DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override

				DisableControlAction(0, 24,   true) -- Input Attack
				DisableControlAction(0, 140,  true) -- Melee Attack Alternate
				DisableControlAction(0, 141,  true) -- Melee Attack Alternate
				DisableControlAction(0, 142,  true) -- Melee Attack Alternate
				DisableControlAction(0, 257,  true) -- Input Attack 2
				DisableControlAction(0, 263,  true) -- Input Melee Attack
				DisableControlAction(0, 264,  true) -- Input Melee Attack 2

				DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
				DisableControlAction(0, 14,   true) -- Weapon Wheel Next
				DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
				DisableControlAction(0, 16,   true) -- Select Next Weapon
				DisableControlAction(0, 17,   true) -- Select Prev Weapon
				DisableControlAction(0, 36,   true) -- Crouch
				
				if USE_RTC then
					local player = PlayerId()
					if not isSpeaking then
						if NetworkIsPlayerTalking(player) then
							isSpeaking = true
							SendNUIMessage({event = "speak", speak = true})
						end
					elseif not NetworkIsPlayerTalking(player) then
						isSpeaking = false
						SendNUIMessage({event = "speak", speak = false})
					end
				end
			
				for _, value in ipairs(KeyToucheCloseEvent) do
					if IsControlJustPressed(1, value.code) then
						SendNUIMessage({keyUp = value.event})
					end
				end
				if useMouse == true and hasFocus == ignoreFocus then
					local nuiFocus = not hasFocus
					SetNuiFocus(nuiFocus, nuiFocus)
					hasFocus = nuiFocus
				  elseif useMouse == false and hasFocus == true then
					SetNuiFocus(false, false)
					hasFocus = false
				  end
				
			end
		elseif isSpeaking then
			sleep = 100
			isSpeaking = false
			SendNUIMessage({event = "speak", speak = false})
		else
			sleep = 500			
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('e-phone:ekwipunek')
AddEventHandler('e-phone:ekwipunek', function()
if takePhoto ~= true then
  if IsControlJustPressed(1, KeyOpenClose) then
    HasPhone(function (HasPhone)
      if HasPhone == true then
        TooglePhone()
      else
        ShowNoPhoneWarning()
      end
    end)
  end
  if menuIsOpen == true then
    for _, value in ipairs(KeyToucheCloseEvent) do
      if IsControlJustPressed(1, value.code) then
        SendNUIMessage({keyUp = value.event})
      end
    end
  end
end
end)

--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('e-phone:setEnableApp')
AddEventHandler('e-phone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

function getMenuIsOpen()
  return menuIsOpen
end

function PlaySoundJS (sound, volume)
  SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end
function PlaySoundJSX (sound, volume)
	SendNUIMessage({ event = 'playSound1', sound = sound, volume = volume })
  end

function SetSoundVolumeJS (sound, volume)
  SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS (sound)
  SendNUIMessage({ event = 'stopSound', sound = sound})
end

RegisterNetEvent("e-phone:forceOpenPhone")
AddEventHandler("e-phone:forceOpenPhone", function(_myPhoneNumber)
  if menuIsOpen == false then
    TooglePhone()
  end
end)
 
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("e-phone:myPhoneNumber")
AddEventHandler("e-phone:myPhoneNumber", function(_myPhoneNumber)
	myPhoneNumber = _myPhoneNumber  
	
	TriggerServerEvent('e-phone:allUpdate')
	SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = _myPhoneNumber})
end)

RegisterNetEvent("e-phone:contactList")
AddEventHandler("e-phone:contactList", function(_contacts)
	SendNUIMessage({event = 'updateContacts', contacts = _contacts})
	contacts = _contacts
end)

RegisterNetEvent("e-phone:allMessage")
AddEventHandler("e-phone:allMessage", function(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end)

RegisterNetEvent("e-phone:getBourse")
AddEventHandler("e-phone:getBourse", function(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

local numbers = {
	'sheriff',
	'police',
	'realestateagent',
	'weazel',
	'ambulance',
	'mechanic',
	'mechanic2',
	'avocat',
	'taxi',
	'fire'
}

RegisterNetEvent("e-phone:receiveMessage")
AddEventHandler("e-phone:receiveMessage", function(message, sender, skin)
	local society = false
	if message.transmitter ~= 'Anonim' then
		local t = tonumber(message.transmitter)
		if t then
			message.transmitter = string.format('%06d', tostring(t))
		else
			society = true
		end
	end	
	
	table.insert(messages, message)
	SendNUIMessage({event = 'newMessage', message = message})
	if message.owner == 0 then
		ESX.TriggerServerCallback('e-phone:canUse', function(pass)
			if pass then
				CreateThread(function()

					if isAllowed then
						local sourceKnown = nil
						
						for _, contact in pairs(contacts) do
							if contact.number == message.transmitter then
								sourceKnown = contact.display
								break
							end
						end
						
						if not skin then
							if society then
								PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
								Citizen.Wait(320)
								PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
								Citizen.Wait(320)
								PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
								TriggerEvent("FeedM:showAdvancedNotification", message.transmitter, '~o~Wezwanie', message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, 'CHAR_SOCIAL_CLUB', 5000)
							elseif sourceKnown then
								PlaySoundJSX("iphone_note.ogg", 0.2)
								if sender then
									ESX.Game.Utils.RenderHeadshotCached(GetEntityCoords(PlayerPedId(), false), sender, nil, function(pic)
										TriggerEvent("FeedM:showAdvancedNotification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, pic, 5000)
									end)								
								else
									TriggerEvent("FeedM:showAdvancedNotification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, 'CHAR_HUMANDEFAULT', 5000)
								end
							else
								TriggerEvent("FeedM:showAdvancedNotification", (message.transmitter ~= 'Anonim' and '#' or '~r~') .. message.transmitter, nil, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, 'CHAR_HUMANDEFAULT', 5000)
							end
						elseif sourceKnown then
							PlaySoundJSX("iphone_note.ogg", 0.2)
							if sender then
								ESX.Game.Utils.RenderHeadshotInternal(GetEntityCoords(PlayerPedId(), false), skin, function(handle, txd)
									TriggerEvent("FeedM:Notification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, txd, 5000, nil, function()
										UnregisterPedheadshot(handle)
									end)
								end)							
							end
						else
							PlaySoundJSX("iphone_note.ogg", 0.2)
							TriggerEvent("FeedM:showAdvancedNotification", (message.transmitter ~= 'Anonim' and '#' or '~r~') .. message.transmitter, nil, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, 'CHAR_HUMANDEFAULT', 5000)
						end
					end
				end)
			end
		end, false)
	end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
    TriggerServerEvent('e-phone:addContact', display, num)
end

function deleteContact(num) 
    TriggerServerEvent('e-phone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)	
	Wait(1500)
	TriggerServerEvent('e-phone:sendMessage', num, message)
	PlaySoundJSX("message_sent.ogg", 0.2)
end

function deleteMessage(msgId)
  TriggerServerEvent('e-phone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('e-phone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('e-phone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('e-phone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('e-phone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('e-phone:requestAllContact')
end

--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false

local waitingCall = false

RegisterNetEvent("e-phone:waitingCall")
AddEventHandler("e-phone:waitingCall", function(infoCall, initiator)	
	if initiator then
		SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})

		PhonePlayCall()
	elseif initiator == nil then
		menuIsOpen = false
		SendNUIMessage({show = false})
		PhonePlayOut()
	else
		ESX.TriggerServerCallback('e-phone:canUse', function(pass)
			if pass then
				SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
				waitingCall = true
			end		
		end, false)
	end
end)

RegisterNetEvent("e-phone:acceptCall")
AddEventHandler("e-phone:acceptCall", function(infoCall, initiator)
	if inCall == nil then
		inCall = true
	end
	
	exports["pma-voice"]:SetCallChannel(infoCall.id + 1)
	
	if not menuIsOpen then
		TooglePhone()
	end

	PhonePlayCall()
	SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
	waitingCall = false
end)

RegisterNetEvent("e-phone:rejectCall")
AddEventHandler("e-phone:rejectCall", function(infoCall)
	if inCall ~= nil then
		inCall = false
		
		if callStartTime ~= nil then
			TriggerServerEvent('e-phone:billCall', Citizen.InvokeNative(0x9A73240B49945C76) - callStartTime, id)
			callStartTime = nil
		end	
	else
		callStartTime = nil
	end
	
	exports['pma-voice']:removePlayerFromCall()
	SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
	waitingCall = false
	
	if menuIsOpen then
		PhonePlayText()
	end
	if menuIsOpen then
		TooglePhone()
	end
end)

RegisterNetEvent("e-phone:historiqueCall")
AddEventHandler("e-phone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function startCall(phone_number, rtcOffer, extraData)
	callStartTime = Citizen.InvokeNative(0x9A73240B49945C76)
	TriggerServerEvent('e-phone:startCall', phone_number, rtcOffer, extraData)
end

function acceptCall (infoCall, rtcAnswer)
	waitingCall = false
  TriggerServerEvent('e-phone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
	waitingCall = false
  TriggerServerEvent('e-phone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
	waitingCall = false
  TriggerServerEvent('e-phone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('e-phone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('e-phone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('e-phone:appelsDeleteAllHistorique')
end
  

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
	USE_RTC = use
	if USE_RTC and inCall ~= nil then
		TriggerEvent('esx_voice:setCall', true)
	end
	cb()
end)


RegisterNUICallback('onCandidates', function (data, cb)
  TriggerServerEvent('e-phone:candidates', data.id, data.candidates)
  cb()
end)

RegisterNetEvent("e-phone:candidates")
AddEventHandler("e-phone:candidates", function(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)



RegisterNetEvent('e-phone:autoCall')
AddEventHandler('e-phone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('e-phone:autoCallNumber')
AddEventHandler('e-phone:autoCallNumber', function(data)
  TriggerEvent('e-phone:autoCall', data.number)
end)

RegisterNetEvent('e-phone:autoAcceptCall')
AddEventHandler('e-phone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)

--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)
RegisterNUICallback('reponseText', function(data, cb)
	local params = {
		limit = data.limit or 1000,
		value = data.text or '',
		type = 'text'
	}
	if data.evt == 'message' then
		params.title = 'Wpisz wiadomość:'
		params.type = 'textarea'
	elseif data.evt == 'darkchat' then
		params.title = 'Wpisz nazwę kanału:'
	elseif data.evt == 'contact' then
		params.title = 'Wpisz nazwę kontaktu:'
	elseif data.evt == 'number' then
		params.title = 'Wpisz numer:'
	end

	TriggerEvent('falszywyy:keyboard', function(value)
		if data.evt == 'darkchat' then
			local channel = value or ''
			if channel ~= '' then
				cb(json.encode({text = channel}))
			else
				ESX.ShowNotification('Musisz wpisać nazwę kanału')
			end
		else
			cb(json.encode({text = value or ''}))
		end
	end, params)
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)	
	if data.message == '%pos%' then
		local myPos = GetEntityCoords(PlayerPedId())
		data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
		ESX.ShowNotification('~r~GPS, zostanie wysłany za 3 sekundy!')
		Wait(3000)
		ESX.ShowNotification('~g~GPS, wysłany pomyślnie!')
		TriggerServerEvent('e-phone:sendMessage', data.phoneNumber, data.message)
		PlaySoundJSX("message_sent.ogg", 0.2)
	else
		Wait(1500)
		TriggerServerEvent('e-phone:sendMessage', data.phoneNumber, data.message)
		PlaySoundJSX("message_sent.ogg", 0.2)
	end
end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  TriggerServerEvent('e-phone:addContact', data.display, data.phoneNumber)
end)
RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('e-phone:updateContact', data.id, data.display, data.phoneNumber)
end)
RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('e-phone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
  local eventName = data.eventName or ''
  if string.match(eventName, 'gcphone') then
    if data.data ~= nil then 
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
  else
  end
  cb()
end)

RegisterNUICallback('useMouse', function(um, cb)
  useMouse = um
end)
RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('e-phone:deleteALL')
  cb()
end)

function TooglePhone() 
	menuIsOpen = not menuIsOpen
	SendNUIMessage({show = menuIsOpen})
	if menuIsOpen == true then 
		PhonePlayIn()
		TriggerEvent('gg:PrzelaczRadar', true)
		DisableControlAction(0, 245, true)
	else
		PhonePlayOut()
		TriggerEvent('gg:PrzelaczRadar', false)
		ClearPedSecondaryTask(PlayerPedId())
		Wait(100)
		ClearPedTasks(PlayerPedId())
		DisableControlAction(0, 245, false)
		EnableControlAction(0, 245, true)
	end
end
RegisterNUICallback('faketakePhoto', function(data, cb)
	menuIsOpen = false
	TriggerEvent('e-phone:setMenuStatus', false)
	SendNUIMessage({show = false})
	TriggerEvent('camera:open')
	cb()
  end)
RegisterNUICallback('takePhoto', function(data, cb)
	CreateMobilePhone(1)
	CellCamActivate(true, true)
	takePhoto = true
	ESX.UI.HUD.SetDisplay(0.0)
	  TriggerEvent('es:setMoneyDisplay', 0.0)
	  TriggerEvent('esx_status:setDisplay', 0.0)
	  TriggerEvent('esx_voice:setDisplay', 0.0)
	  TriggerEvent('radar:setHidden', true)
	  TriggerEvent('chat:display', false)
	  TriggerEvent('carhud:display', false)
	Wait(0)
	if hasFocus == true then
	  SetNuiFocus(false, false)
	  hasFocus = false
	end
	while takePhoto do
	  Wait(0)
  
	  if IsControlJustPressed(1, 27) then -- Toogle Mode
		frontCam = not frontCam
		CellFrontCamActivate(frontCam)
	  elseif IsControlJustPressed(1, 177) then -- CANCEL
		DestroyMobilePhone()
		CellCamActivate(false, false)
		cb(json.encode({ url = nil }))
		takePhoto = false
		ESX.UI.HUD.SetDisplay(1.0)
			  TriggerEvent('es:setMoneyDisplay', 1.0)
			  TriggerEvent('esx_status:setDisplay', 1.0)
			  TriggerEvent('esx_voice:setDisplay', 1.0)
			  TriggerEvent('radar:setHidden', false)
			  TriggerEvent('chat:display', true)
			  TriggerEvent('carhud:display', true)
			  Wait(1000)
			  PhonePlayIn()
		break
	  elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC

		exports['screenshot-basic']:requestScreenshotUploadImgur(function(status)
			cb({})
		end, function(data)
			local resp = json.decode(data)
			DestroyMobilePhone()
			PhonePlayOut()
			CellCamActivate(false, false)
			if not resp.errors then
				cb(json.encode({ url = resp.data.link }))
			else
				cb({})
				ESX.ShowNotification("~r~Wystąpił błąd przy robieniu zdjęcia")
			end	
			ESX.UI.HUD.SetDisplay(1.0)
			TriggerEvent('es:setMoneyDisplay', 1.0)
			TriggerEvent('esx_status:setDisplay', 1.0)
			TriggerEvent('esx_voice:setDisplay', 1.0)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('chat:display', true)
			TriggerEvent('carhud:display', true)
			takePhoto = false
			Wait(1000)
			PhonePlayIn()
		end)
	  end
	  HideHudComponentThisFrame(7)
	  HideHudComponentThisFrame(8)
	  HideHudComponentThisFrame(9)
	  HideHudComponentThisFrame(6)
	  HideHudComponentThisFrame(19)
	  HideHudAndRadarThisFrame()
	end
  end)
RegisterNUICallback('closePhone', function(data, cb)
	disableChat = false
	menuIsOpen = false
	SendNUIMessage({show = false})
	PhonePlayOut()
	TriggerEvent('gg:PrzelaczRadar', false)
	cb()
end)

----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------
AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "gcphone" then
      TriggerServerEvent('e-phone:allUpdate')
  end
end)


RegisterNUICallback('setIgnoreFocus', function (data, cb)
	ignoreFocus = data.ignoreFocus
	cb()
  end)

RegisterNUICallback('takePhoto', function(data, cb)
	menuIsOpen = false
	SendNUIMessage({show = false})
	TriggerEvent('camera:open', data.number)
	cb()
end)

function openPhone()
	if menuIsOpen == false then
		ESX.TriggerServerCallback('e-phone:canUse', function(pass)
			if pass then
				TooglePhone()
			end
		end, true)
	end
end