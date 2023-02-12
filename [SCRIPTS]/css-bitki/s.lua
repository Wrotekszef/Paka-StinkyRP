local date = os.date('*t')
if date.month < 10 then date.month = '0' .. tostring(date.month) end
if date.day < 10 then date.day = '0' .. tostring(date.day) end
if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
if date.min < 10 then date.min = '0' .. tostring(date.min) end
if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' o godz: ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

RegisterCommand("winorg", function(src, args, raw) 
  if src > 0 then
    if tonumber(args[1]) then
      local xPlayer = ESX.GetPlayerFromId(src)
      local tPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
      exports['exile_logs']:SendLog(src, "Wpisał /winorg (Organizacja Przestępcza) "..xPlayer.thirdjob.name, 'bitkilogs', '3066993')
      local xOrg = nil
      local tOrg = nil
      if(xPlayer.thirdjob.name ~= tPlayer.thirdjob.name) then
      if string.sub(xPlayer.thirdjob.name, 1, 3) == "org" or string.sub(xPlayer.thirdjob.label, 1, 3) == "org" then
        if xPlayer.thirdjob.grade >= 2 then
           if string.sub(xPlayer.thirdjob.name, 1, 3) == "org" then xOrg = xPlayer.thirdjob.label else xOrg = xPlayer.thirdjob.label end
             if tPlayer.thirdjob.grade >= 2 then
              if string.sub(tPlayer.thirdjob.name, 1, 3) == "org" or string.sub(tPlayer.thirdjob.label, 1, 3) == "org" then
               if string.sub(tPlayer.thirdjob.name, 1, 3) == "org" then tOrg = tPlayer.thirdjob.label else tOrg = tPlayer.thirdjob.label end
                 TriggerClientEvent("bitkiorg1C:acceptLose", tPlayer.source, xOrg, xPlayer.thirdjob.name, xPlayer.name, tPlayer.name, src)
          else
            xPlayer.showNotification("Osoba której próbujesz wysłać prośbę nie jest w żadnej organizacji!")
          end  
        else
          xPlayer.showNotification("Tylko Kapitan+ może wysłać prośbę o zaakceptowanie bitki!")
        end
      else
        xPlayer.showNotification("Tylko Kapitan+ może zaakceptować bitki!")
      end
      else
        xPlayer.showNotification("Nie masz dostępu do tej komendy!")
      end
    else
      xPlayer.showNotification("~r~Nie możesz wysłać bitki do osoby z tej samej organizacji!!")
    end
    end
  end  
end, false)

RegisterNetEvent("bitkiorg1S:winResult")
AddEventHandler("bitkiorg1S:winResult", function(org, orgName, sender, recipient, screenshot, result, targetId) 
  local xPlayer = ESX.GetPlayerFromId(source)
  local tPlayer = ESX.GetPlayerFromId(tonumber(targetId))
  local xOrg = nil
  local xOrgName = nil
  if string.sub(xPlayer.thirdjob.name, 1, 3) == "org" then 
    xOrg = xPlayer.thirdjob.label 
    xOrgName = xPlayer.thirdjob.name
  else 
    xOrg = xPlayer.thirdjob.label
    xOrgName = xPlayer.thirdjob.name
  end
  if result == "accept" then
    tPlayer.showNotification('Bitka została ~g~zaakceptowana')
    local result = math.random(1, 100)
    if result <= 3 then
      tPlayer.addInventoryItem('goldenkey', 1)
    end
    MySQL.query("SELECT * FROM bitki WHERE org_name = @org_name", {
      ['@org_name'] = orgName,
    }, function (result)
      local wins = tonumber(result[1].wins)
      local loses = tonumber(result[1].loses)
      MySQL.update("UPDATE bitki SET wins = @wins WHERE org_name = @org_name", { 
        ['@org_name'] = orgName,
        ['@wins'] = tonumber(wins)+1
      })
      MySQL.query("SELECT * FROM bitki WHERE org_name = @org_name", {
        ['@org_name'] = xOrgName,
        }, function (resulttwo)
          local winstwo = tonumber(resulttwo[1].wins)
          local losestwo = tonumber(resulttwo[1].loses)
          MySQL.update.await("UPDATE bitki SET loses = @loses WHERE org_name = @org_name", { 
            ['@org_name'] = xOrgName,
            ['@loses'] = tonumber(losestwo)+1
          })
          local winratio = wins/loses
          local winratiotwo = winstwo/losestwo
          sendToDiscord(
          0x03dbfc, "Organizacja: "..org.." (W:"..(tonumber(wins)+1).." L:"..loses..", Razem: "..((tonumber(wins)+1)+loses).." WR: "..winratio..")\n\n**Wygrała bitke z:** \n\nOrganizacja:"..xOrg.." (W:"..winstwo.." L:"..(tonumber(losestwo)+1)..", Razem: "..((tonumber(winstwo)+1)+losestwo).." WR: "..winratiotwo..") \n\n**Wysyłający:** "..sender.."\n**Przyjmujący:** "..recipient, screenshot, "Bitki")
          tPlayer.showNotification("Statystki:\n"..org.." (W:"..(tonumber(wins)+1).." L:"..loses..", Razem: "..((tonumber(wins)+1)+loses).. ") WR: "..winratio)
        end)
    end)
  elseif result == "deny" then
    tPlayer.showNotification('Bitka została ~r~odrzucona')
  elseif result == "timeout" then
    tPlayer.showNotification('Czas na akceptacje bitki minął')
  end  
end)

sendToDiscord = function (color, message, img, footer)
  local embed = {
        {
            ["color"] = "15844367",
            ["title"] = "ExileRP - Bitki",
            ["description"] = message,
            ["image"] = {
              ["url"] = img,
            },
            ["footer"] = {
              ["text"] = "Wysłano: "..date.."",
              ["icon_url"] = 'https://media.discordapp.net/attachments/793387307825889311/908379177449820190/logo.png',
            }
        }
    }

  PerformHttpRequest('https://discord.com/api/webhooks/1046374656770330684/gD0RoImcWihu3PUObOr94TL3iye7A7VTq3mx9aq8N2nxMSAHR6Fj2EpHdskZf01fxTXp', function(err, text, headers) end, 'POST', json.encode({username = "ExileRP - Bitki", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local gwizdekid = {id = 0, job_name = 'undefined'}
RegisterServerEvent("k-bitki:notif")
AddEventHandler("k-bitki:notif", function(job, job_label)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if gwizdekid.id == 0 and gwizdekid.job_name == 'undefined' then
      if xPlayer.thirdjob.grade == 5 then
        TriggerClientEvent("k-bitki:notifofi", -1, job_label, job, xPlayer.coords, src)
        gwizdekid = {
          id = src,
          job_name = job_label,
        }
      else
        TriggerClientEvent("esx:showAdvancedNotification", src, '~o~GWIZDEK', 'Powiadomienie', '~b~Nie posiadasz stopnia szefa do wysyłania gwizdka!')
      end
    else
      TriggerClientEvent("esx:showAdvancedNotification", src, '~o~GWIZDEK', 'Powiadomienie', '~b~Gwizdek jest już w użyciu przez: '..gwizdekid.id.job_name..'\nWpisz /gwizdekjoin '..gwizdekid.id..' aby przyjąć wezwanie!')
    end
end)

RegisterServerEvent("k-bitki:notifstart")
AddEventHandler("k-bitki:notifstart", function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if gwizdekid.id ~= 0 and tonumber(gwizdekid.id) == tonumber(id) then
      if xPlayer.thirdjob.grade >= 2 then
        if xPlayer.thirdjob.label ~= gwizdekid.job_name then
          TriggerClientEvent("esx:showAdvancedNotification", gwizdekid.id, '~o~GWIZDEK', 'Powiadomienie', '~g~['..xPlayer.thirdjob.label..'] ~b~przyjął wezwanie do bitki!')
          TriggerClientEvent("esx:showAdvancedNotification", src, '~o~GWIZDEK', 'Powiadomienie', '~b~Przyjąłeś wezwanie do bitki: ~g~['..gwizdekid.job_name..']')
          TriggerClientEvent('k-bitki:removeBlip', -1)
          gwizdekid = {id = 0, job_name = 'undefined'}
        else
          TriggerClientEvent("esx:showAdvancedNotification", src, '~o~GWIZDEK', 'Powiadomienie', '~b~Nie możesz przyjąć gwizdka własnej ekipy!')
        end
      else
        TriggerClientEvent("esx:showAdvancedNotification", src, '~o~GWIZDEK', 'Powiadomienie', '~b~Nie możesz przyjąć gwizdka na tym stopniu w ekipie!')
      end
    end
  end)


RegisterServerEvent("k-bitki:nolonger")
AddEventHandler("k-bitki:nolonger", function()
  local src = source
  TriggerClientEvent("esx:showAdvancedNotification", src, '~o~GWIZDEK', 'Powiadomienie', '~b~Aktualny gwizdek się przedawnił, stwórz nowy /gwizdek!')
  gwizdekid = {id = 0, job_name = 'undefined'}
end)