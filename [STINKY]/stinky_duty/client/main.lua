RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

RegisterCommand('duty', function()
  if ESX.PlayerData.job.name == 'offpolice' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'offsheriff' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'offcardealer' or ESX.PlayerData.job.name == 'cardealer' or ESX.PlayerData.job.name == 'offdoj' or ESX.PlayerData.job.name == 'doj' or ESX.PlayerData.job.name == 'offfire' or ESX.PlayerData.job.name == 'fire' or ESX.PlayerData.job.name == 'offk9' or ESX.PlayerData.job.name == 'k9' or ESX.PlayerData.job.name == 'offambulance' or ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'offmechanik' or ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'offgheneraugarage' then
    if ESX.PlayerData.job.name == 'offambulance' then
      TriggerServerEvent('e-duty:setJob', 'ambulance', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'ambulance' then
      TriggerServerEvent('e-duty:setJob', 'ambulance', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offpolice' then
      TriggerServerEvent('e-duty:setJob', 'police', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'police' then
      TriggerServerEvent('e-duty:setJob', 'police', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offfire' then
      TriggerServerEvent('e-duty:setJob', 'fire', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'fire' then
      TriggerServerEvent('e-duty:setJob', 'fire', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offmechanik' then
      TriggerServerEvent('e-duty:setJob', 'mechanik', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'mechanik' then
      TriggerServerEvent('e-duty:setJob', 'mechanik', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offmechanik' then
      TriggerServerEvent('e-duty:setJob', 'mechanik', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'mechanik' then
      TriggerServerEvent('e-duty:setJob', 'mechanik', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offk9' then
      TriggerServerEvent('e-duty:setJob', 'k9', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'k9' then
      TriggerServerEvent('e-duty:setJob', 'k9', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offdoj' then
      TriggerServerEvent('e-duty:setJob', 'doj', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'doj' then
      TriggerServerEvent('e-duty:setJob', 'doj', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'gheneraugarage' then
      TriggerServerEvent('e-duty:setJob', 'gheneraugarage', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offgheneraugarage' then
      TriggerServerEvent('e-duty:setJob', 'gheneraugarage', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'cardealer' then
      TriggerServerEvent('e-duty:setJob', 'cardealer', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offcardealer' then
      TriggerServerEvent('e-duty:setJob', 'cardealer', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    elseif ESX.PlayerData.job.name == 'sheriff' then
      TriggerServerEvent('e-duty:setJob', 'sheriff', false)
      ESX.ShowNotification('~b~Schodzisz z służby')
      
    elseif ESX.PlayerData.job.name == 'offsheriff' then
      TriggerServerEvent('e-duty:setJob', 'sheriff', true)
      ESX.ShowNotification('~b~Wchodzisz na służbę')
      
    end
	else
		ESX.ShowNotification('~r~Nie jesteś zatrudniony!')
		
	end
end)