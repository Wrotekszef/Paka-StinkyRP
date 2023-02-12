
local lockpos = false
local insidePrompt = false
-- openGui(length,math.random(1000000))
function openGui(sentLength,taskID,namesent,keepWeapon)
    if not keepWeapon then
        TriggerEvent("actionbar:setEmptyHanded")
    end
    guiEnabled = true
    SendNUIMessage({runProgress = true, Length = sentLength, Task = taskID, name = namesent})
end
function updateGui(sentLength,taskID,namesent)
    SendNUIMessage({runUpdate = true, Length = sentLength, Task = taskID, name = namesent})
end
local activeTasks = {}
function closeGuiFail()
    guiEnabled = false
    SendNUIMessage({closeFail = true})
    -- ClearPedTasks(PlayerPedId())
end
function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
    -- ClearPedTasks(PlayerPedId())
end

function closeNormalGui()
    guiEnabled = false
end

RegisterNUICallback('taskCancel', function(data, cb)
  closeGui()
  local taskIdentifier = data.tasknum
  activeTasks[taskIdentifier] = 2
end)

RegisterNUICallback('taskEnd', function(data, cb)
  closeNormalGui()
  
  local taskIdentifier = data.tasknum
  activeTasks[taskIdentifier] = 3
end)
local coffeetimer = 0

RegisterNetEvent('coffee:drink')
AddEventHandler('coffee:drink', function()
    if coffeetimer > 0 then
        coffeetimer = 6000
        TriggerEvent("Evidence:StateSet",27,6000)
        return
    else
        TriggerEvent("Evidence:StateSet",27,6000)
        coffeetimer = 6000
    end

    while coffeetimer > 0 do
        coffeetimer = coffeetimer - 1
        Wait(1000)
    end

end)


-- command is something we do in the loop if we want to disable more, IE a vehicle engine.
-- return true or false, if false, gives the % completed.

--[[local taskInProcess = false
function taskBar(length,name,runCheck,keepWeapon,vehicle,vehCheck)
    local playerPed = PlayerPedId()
    if taskInProcess then
        Citizen.SetTimeout(function() 
            return 0
        end, length)
    end 
    if coffeetimer > 0 then
        length = math.ceil(length * 0.66)
    end
    taskInProcess = true
    local taskIdentifier = "taskid" .. math.random(1000000)
    openGui(length,taskIdentifier,name,keepWeapon)
    activeTasks[taskIdentifier] = 1

    local maxcount = GetGameTimer() + length
    local curTime
    while activeTasks[taskIdentifier] == 1 do
        Wait(1)
        curTime = GetGameTimer()
        if curTime > maxcount or not guiEnabled then
            activeTasks[taskIdentifier] = 2
        end
        local fuck = 100 - (((maxcount - curTime) / length) * 100)
        fuck = math.min(100, fuck)
        updateGui(fuck,taskIdentifier,name)

        if runCheck then
            if IsPedClimbing(PlayerPedId()) or IsPedJumping(PlayerPedId()) or IsPedSwimming(PlayerPedId()) then
                SetPlayerControl(PlayerId(), 0, 0)
                local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
                totaldone = math.min(100, totaldone)
                taskInProcess = false
                closeGuiFail()
                Wait(1000)
                SetPlayerControl(PlayerId(), 1, 1)
                Wait(1000)
                return totaldone
            end
        end

        if vehicle ~= nil and vehicle ~= 0 then
            local driverPed = GetPedInVehicleSeat(vehicle, -1)
            if driverPed ~= playerPed and vehCheck then
                SetPlayerControl(PlayerId(), 0, 0)
                local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
                totaldone = math.min(100, totaldone)
                taskInProcess = false
                closeGuiFail()
                Wait(1000)
                SetPlayerControl(PlayerId(), 1, 1)
                Wait(1000)
                return totaldone
            end

            local model = GetEntityModel(playerVeh)
            if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
                if IsEntityInAir(vehicle) then
                    Wait(1000)
                    if IsEntityInAir(vehicle) then
                        local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
                        totaldone = math.min(100, totaldone)
                        taskInProcess = false
                        closeGuiFail()
                        Wait(1000)
                        return totaldone
                    end
                end
            end
        end
    end

    local resultTask = activeTasks[taskIdentifier]
    if resultTask == 2 then
        local totaldone = math.ceil(100 - (((maxcount - curTime) / length) * 100))
        totaldone = math.min(100, totaldone)
        taskInProcess = false
        closeGuiFail()
        return totaldone
    else
        closeGui()
        taskInProcess = false
        return 100
    end 
   
end]]

--[[
    'showTaskbar',
	'stopTaskbar'
]]
local taskbars = {}
local taskbarInProgress = false
function isBusy() 
    return taskbarInProgress
end
function taskBar(length,name,cancellable, cb) 
    if taskbarInProgress and cancellable then
        cb(false)
        TriggerEvent("esx:showNotification", "~r~Już coś robisz!")
        return
    end
    local id = math.random(100000, 999999)
    taskbars[id] = true
    taskbarInProgress = true
    exports["esx_exilechat"]:showTaskbar(id, "pending_actions", exports["qHud"]:getAlign(), name, "Wykonywanie czynności...", "grey-10", length/1000, true)
    local returned = false
    CreateThread(function() 
        if not cancellable then return end
        while taskbars[id] do
            Wait(3)
            if IsControlJustPressed(0, 73) then
                exports["esx_exilechat"]:stopTaskbar(id)
                TriggerEvent("esx:showNotification", "~r~Przerwano akcję...")
                taskbarInProgress = false
                returned = true
                taskbars[id] = false
                cb(false)
                return
            end
        end
    end)
    Citizen.SetTimeout(length, function() 
        taskbars[id] = false
    end)
    while taskbars[id] do
        Wait(100) 
    end
    if not returned then
        taskbars[id] = false
        taskbarInProgress = false
        cb(true)
    end
end

function cancellableTaskBar(length,name,cancellable) 
    local id = math.random(100000, 999999)
    taskbars[id] = true
    exports["esx_exilechat"]:showTaskbar(id, "pending_actions", exports["qHud"]:getAlign(), name, "Wykonywanie czynności...", "grey-10", length/1000, true)
    local returned = false
    CreateThread(function() 
        if not cancellable then return end
        while taskbars[id] do
            Wait(3)
            if IsControlJustPressed(0, 73) then
                exports["esx_exilechat"]:stopTaskbar(id)
                TriggerEvent("esx:showNotification", "~r~Przerwano akcję...")
                returned = true
                taskbars[id] = false
                return
            end
        end
    end)
    CreateThread(function() 
        Citizen.SetTimeout(length, function() 
            taskbars[id] = false
        end)
        while taskbars[id] do
            Wait(100) 
        end
        if not returned then
            taskbars[id] = false
        end
    end)
    return id
end
function cancelTaskBar(id) 
    taskbars[id] = false
    exports["esx_exilechat"]:stopTaskbar(id)
end

function customTaskbar(length,icon,align,title,content,color,showProgress, cancellable, cb) 
    if taskbarInProgress and cancellable then
        cb(false)
        TriggerEvent("esx:showNotification", "~r~Już coś robisz!")
        return
    end
    local id = math.random(100000, 999999)
    taskbars[id] = true
    taskbarInProgress = true
    exports["esx_exilechat"]:showTaskbar(id, icon, align, title, content, color, length/1000, showProgress)
    local returned = false
    CreateThread(function() 
        if not cancellable then return end
        while taskbars[id] do
            Wait(3)
            if IsControlJustPressed(0, 73) then
                exports["esx_exilechat"]:stopTaskbar(id)
                TriggerEvent("esx:showNotification", "~r~Przerwano akcję...")
                taskbarInProgress = false
                returned = true
                taskbars[id] = false
                cb(false)
                return
            end
        end
    end)
    Citizen.SetTimeout(length, function() 
        taskbars[id] = false
    end)
    while taskbars[id] do
        Wait(100) 
    end
    if not returned then
        taskbars[id] = false
        taskbarInProgress = false
        cb(true)
    end
end

function CheckCancels()
    if IsPedRagdoll(PlayerPedId()) then
        return true
    end
    return false
end
-- trigger this way for the timer with out stopping another thread
RegisterNetEvent('hud:taskBar')
AddEventHandler('hud:taskBar', function(length,name)
    taskBar(length,name)
end)

RegisterNetEvent('hud:insidePrompt')
AddEventHandler('hud:insidePrompt', function(bool)
    insidePrompt = bool
end)


RegisterNetEvent('event:control:taskBar')
AddEventHandler('event:control:taskBar', function(useID)
    if useID == 1 and not insidePrompt then
        TriggerEvent("radioGui")
    elseif useID == 2 and not insidePrompt then
        TriggerEvent("stereoGui") 
    elseif useID == 3 and not insidePrompt then
        TriggerEvent("phoneGui") 
    elseif useID == 4 and not insidePrompt then 
        TriggerEvent("inventory-open-request")
    elseif useID == 5 and guiEnabled then 
        closeGuiFail() 
    end
end)
 