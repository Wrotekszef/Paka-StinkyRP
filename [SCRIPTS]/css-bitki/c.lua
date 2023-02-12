local pendingAccept = nil
local organizationname = nil
local forwarder = nil
local accepter = nil
local ajdi = nil
local jobs = {
  'org14',
  'org15',
  'org16',
  'org17',
  'org18',
  'org19',
  'org20',
  'org21',
  'org22',
  'org23',
  'org24',
  'org25',
  'org26',
  'org27',
  'org28',
  'org29',
  'org30',
  'org31',
  'org32',
  'org33',
  'org34',
  'org35',
  'org36',
  'org37',
  'org38',
  'org39',
  'org40',
  'org41',
  'org42',
  'org43',
  'org44',
  'org45',
  'org46',
  'org47',
  'org48',
  'org49',
  'org50',
  'org51',
  'org52',
  'org53',
  'org54',
  'org55',
  'org56',
  'org57',
  'org58',
  'org59',
  'org60',
  'org61',
  'org62',
  'org63',
  'org64',
  'org65',
  'org66',
  'org67',
  'org68',
  'org69',
  'org70',
  'org71',
  'org72',
  'org73',
  'org74',
  'org80',
  'org81',
  'org82',
  'org83',
  'org84',
  'org85',
  'org86',
  'org87',
  'org88',
  'org89',
  'org90',
  'org91',
  'org92',
  'org93',
  'org94',
  'org95',
  'org96',
  'org97',
  'org98',
  'org99',
  'org100',
  'org101',
  'org102',
  'org103',
  'org104',
  'org105',
  'org106',
  'org107',
  'org108',
  'org109',
  'org110',
  'org111',
  'org112',
  'org113',
  'org114',
  'org115',
  'org116',
  'org117',
  'org118',
  'org119',
  'org120',
}

RegisterNetEvent("bitkiorg1C:acceptLose")
AddEventHandler("bitkiorg1C:acceptLose", function(org, orgName, sender, recipient, tId)
  if pendingAccept ~= nil then return end
  pendingAccept = org
  organizationname = orgName
  forwarder = sender
  accepter = recipient
  ajdi = tId

  local elements = {
		{label = 'Czy '..org..' wygrało?'},
		{label = '<font color=green>Tak</font>', value = 'win'},
		{label = '<font color=red>Nie</font>', value = 'cancel'},
	}
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wonrequest', {
		title    = 'Bitki',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'win' then
			if pendingAccept then
        local screenshot = nil
        exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/1003425792883167322/FqXY3hIEokHNdtJuFm7DLA5dxrtWfJVZF29PxUtGsklhadkRB1Ww7QXHGaZzBsPMGXAL", 'files[]', function(data)
          local response = json.decode(data)
          if response and response ~= nil and response.attachments and response.attachments[1] ~= nil and response.attachments[1].url ~= nil then
            screenshot = response.attachments[1].url..".jpeg"
          end
        end)
        ESX.ShowNotification("~w~Zaakceptowałeś ~r~przegraną ~w~bitki!")
        TriggerServerEvent("bitkiorg1S:winResult", pendingAccept, organizationname, forwarder, accepter, screenshot, "accept", ajdi)
        pendingAccept = nil
      end
			menu.close()
		elseif data.current.value == 'cancel' then
      if pendingAccept then
        local screenshot = nil
        exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/1003425792883167322/FqXY3hIEokHNdtJuFm7DLA5dxrtWfJVZF29PxUtGsklhadkRB1Ww7QXHGaZzBsPMGXAL", 'files[]', function(data)
          local response = json.decode(data)
          if response and response ~= nil and response.attachments and response.attachments[1] ~= nil and response.attachments[1].url ~= nil then
            screenshot = response.attachments[1].url..".jpeg"
          end
        end)
        ESX.ShowNotification("~w~Odrzuciłeś ~r~przegraną ~w~bitki!")
        TriggerServerEvent("bitkiorg1S:winResult", pendingAccept, screenshot, "deny", ajdi)
        pendingAccept = nil
      end 
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)

  CreateThread(function() 
    Wait(15000)
    if pendingAccept ~= nil then
      ESX.ShowNotification("Czas na ~r~zaakceptowanie ~w~bitki z ~r~["..pendingAccept.."] ~w~minął!")
      local screenshot = nil
        exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/1003425792883167322/FqXY3hIEokHNdtJuFm7DLA5dxrtWfJVZF29PxUtGsklhadkRB1Ww7QXHGaZzBsPMGXAL", 'files[]', function(data)
          local response = json.decode(data)
          if response and response ~= nil and response.attachments and response.attachments[1] ~= nil and response.attachments[1].url ~= nil then
            screenshot = response.attachments[1].url..".jpeg"
          end
        end)
      TriggerServerEvent("bitkiorg1S:winResult", pendingAccept, organizationname, forwarder, accepter, screenshot, "timeout", ajdi)
      pendingAccept = nil
      ESX.UI.Menu.CloseAll()
    end  
  end)
end)

local lastCreate = 0
local waitingforacceptedgwizdek = false
RegisterCommand('gwizdek', function()
    local now = GetGameTimer()
		if now > lastCreate then
      TriggerServerEvent("k-bitki:notifofi", ESX.PlayerData.thirdjob.name, ESX.PlayerData.thirdjob.label)
			lastCreate = now + 15000
      
		else
			ESX.ShowNotification('Nie możesz tak często używać ~r~/gwizdek')
		end
end)

local lastJoin = 0
RegisterCommand('gwizdekjoin', function(src, args, raw)
  local now = GetGameTimer()
		if now > lastJoin then
      if args[1] then
        TriggerServerEvent('k-bitki:notifstart', args[1])
      end
			lastJoin = now + 15000
		else
			ESX.ShowNotification('Nie możesz tak często używać ~r~/gwizdekjoin')
		end
end)

local blip
RegisterNetEvent("k-bitki:notifofi")
AddEventHandler("k-bitki:notifofi", function(job_label, job, coords, id)	
	if ESX.PlayerData.thirdjob ~= nil and ESX.PlayerData.thirdjob.name ~= nil then		
		for i,v in ipairs(jobs) do
			if ESX.PlayerData.thirdjob.name == v then
        waitingforacceptedgwizdek = true
				ESX.ShowAdvancedNotification('~o~GWIZDEK', 'Powiadomienie', "~b~Gwizdek został użyty przez: ~g~[" .. job_label .. "]!\n~b~Sprawdź GPS i wyślij ~g~[/gwizdekjoin "..id..']')
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 303)
        SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
    
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Bitka wyzwana przez: '..job..' ['..id..']')
        EndTextCommandSetBlipName(blip)
        CreateThread(function() 
          Wait(15000)
          if waitingforacceptedgwizdek then
            waitingforacceptedgwizdek = false
            RemoveBlip(blip)
            TriggerServerEvent('k-bitki:nolonger')
          end
        end)

        break
			end	
		end	
	end
end)

RegisterNetEvent("k-bitki:removeBlip")
AddEventHandler("k-bitki:removeBlip", function()	
  RemoveBlip(blip)
  waitingforacceptedgwizdek = false
end)

