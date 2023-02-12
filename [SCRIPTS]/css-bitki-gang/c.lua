local pendingAccept = nil
local organizationname = nil
local forwarder = nil
local accepter = nil
local ajdi = nil

RegisterNetEvent("bitkiCG:acceptLose")
AddEventHandler("bitkiCG:acceptLose", function(org, orgName, sender, recipient, tId)
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
        TriggerServerEvent("bitkiSG:winResult", pendingAccept, organizationname, forwarder, accepter, screenshot, "accept", ajdi)
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
        TriggerServerEvent("bitkiSG:winResult", pendingAccept, screenshot, "deny", ajdi)
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
      TriggerServerEvent("bitkiSG:winResult", pendingAccept, organizationname, forwarder, accepter, screenshot, "timeout", ajdi)
      pendingAccept = nil
      ESX.UI.Menu.CloseAll()
    end  
  end)
end)