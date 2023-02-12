local Config = {}
TriggerServerEvent("s4-render:fetch")
RegisterNetEvent("s4-render:get")
AddEventHandler("s4-render:get", function(xd)
   Config = xd
   SendNUIMessage({ action = "config", data = Config })
end)

RegisterNUICallback("reqConfig", function(data, cb) 
   SendNUIMessage({ action = "config", data = Config })
end)

RegisterNUICallback("saveVideoData", function(data, cb)
   TriggerServerEvent("esx_k9:video", data.data)
end)

RegisterNetEvent("s4-render:addNewTask")
AddEventHandler("s4-render:addNewTask", function(admin, timeout)
   SendNUIMessage({ action = "task", data = { admin = admin, timeout = timeout }  })
end)
 