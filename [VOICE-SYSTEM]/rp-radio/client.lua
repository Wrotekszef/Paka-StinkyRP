RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
    TriggerServerEvent("exilerp_scripts:fetchOrganizations")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob, response)
	ESX.PlayerData.secondjob = secondjob
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob, response)
	ESX.PlayerData.thirdjob = thirdjob
end)

local Radio = {
    Has = false,
    Open = false,
    On = false,
    Enabled = true,
    Handle = nil,
    Prop = `prop_cs_hand_radio`,
    Bone = 28422,
    Players = 0,
    Offset = vector3(0.0, 0.0, 0.0),
    Rotation = vector3(0.0, 0.0, 0.0),
    Dictionary = {
        "cellphone@",
        "cellphone@in_car@ds",
        "cellphone@str",    
        "random@arrests",  
    },
    Animation = {
        "cellphone_text_in",
        "cellphone_text_out",
        "cellphone_call_listen_a",
        "generic_radio_chatter",
    },
    Clicks = true, -- Radio clicks
}
Radio.Labels = {        
    { "FRZL_RADIO_HELP", "~s~" .. ("~" .. radioConfig.Controls.Activator.Name .. "~") .. " aby ukryć menu~n~~" .. radioConfig.Controls.Toggle.Name .. "~ aby ~g~włączyć~s~ radio~n~~" .. radioConfig.Controls.Input.Name .. "~ aby wybrać częstotliwość~n~~" .. radioConfig.Controls.ToggleClicks.Name .. "~ aby ~a~ dźwięk~n~~n~Częstotliwość: ~1~ MHz" },
    { "FRZL_RADIO_HELP2", "~s~" .. ("~" .. radioConfig.Controls.Activator.Name .. "~") .. " aby ukryć menu~n~~" .. radioConfig.Controls.Toggle.Name .. "~ aby ~r~wyłączyć~s~ radio~n~~n~Częstotliwość: ~1~ MHz" },
    { "FRZL_RADIO_INPUT", "Częstotliwość" },
}

local cache = {
}
local cacheOne = {
}

CreateThread(function() 
    while true do
        Wait(100)
        ESX.TriggerServerCallback('exile:getPlayerInventory', function(inventory)
            local has = false
            for i=1, #inventory.items, 1 do
                local item = inventory.items[i]
                if item.count > 0 then
                    if item.name == 'krotkofalowka' or item.name == 'radio' then
                        has = true
                        break
                    end    
                end
            end
            Radio.Has = has
        end)
        Wait(15000)
    end    
end)

RegisterNetEvent('rp-radio:toogle')
AddEventHandler('rp-radio:toogle', function()
	local playerPed = PlayerPedId()
	local isDead = IsEntityDead(playerPed)
    if isDead then return end
    if not Radio.Has then return end
    if not Radio.On then
        if radioConfig.Frequency.Access[radioConfig.Frequency.Current] then
            local found = false
            for i=1, #radioConfig.Frequency.Access[radioConfig.Frequency.Current], 1 do
                if ESX.PlayerData.job.name == radioConfig.Frequency.Access[radioConfig.Frequency.Current][i] or ESX.PlayerData.thirdjob.name == radioConfig.Frequency.Access[radioConfig.Frequency.Current][i] then
                    found = true
                    break
                end
            end
            
            if found == true then
                PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
                Radio.On = not Radio.On
                exports["pma-voice"]:SetMumbleProperty("radioEnabled", Radio.On)
                Radio:Add(radioConfig.Frequency.Current)
                ESX.ShowNotification("~g~Włączono radio")
            else
                PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
                ESX.ShowNotification("~r~Nie masz dostępu do tej częstotliwości")
            end
        else
            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 1)
            Radio.On = not Radio.On
            exports["pma-voice"]:SetMumbleProperty("radioEnabled", Radio.On)
            Radio:Add(radioConfig.Frequency.Current)
            ESX.ShowNotification("~g~Włączono radio")
        end
    else
        PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
        Radio.On = not Radio.On
        exports["pma-voice"]:SetMumbleProperty("radioEnabled", Radio.On)
        Radio:Remove()
        ESX.ShowNotification("~r~Wyłączono radio")
    end
end)

-- Add player to radio channel
function Radio:Add(id)
    cache = {}
    cacheOne = {}
    if Radio.On then
        TriggerServerEvent("exilerp_scripts:registerChannel", id)
    end
    exports["pma-voice"]:SetRadioChannel(id)
end

-- Remove player from radio channel
function Radio:Remove()
    cache = {}
    cacheOne = {}
    TriggerServerEvent("exilerp_scripts:unregisterChannel")
    exports["pma-voice"]:SetRadioChannel(0)
end

RegisterNetEvent("exilerpC:kickedFromRadio", function() 
    ESX.ShowNotification("~r~Zostałeś wyrzucony z radia przez moderatora")
    Radio.On = false
    Radio:Remove()
end)

-- Generate list of available frequencies
function GenerateFrequencyList()
    radioConfig.Frequency.List = {}

    for i = radioConfig.Frequency.Min, radioConfig.Frequency.Max do
        if not radioConfig.Frequency.Private[i] or radioConfig.Frequency.Access[i] then
            radioConfig.Frequency.List[#radioConfig.Frequency.List + 1] = i
        end
    end
end

-- Check if radio is open
function IsRadioOpen()
    return Radio.Open
end

-- Check if radio is switched on
function IsRadioOn()
    return Radio.On
end

-- Check if player has radio
function IsRadioAvailable()
    return Radio.Has
end

-- Check if radio is enabled or not
function IsRadioEnabled()
    return not Radio.Enabled
end

-- Check if radio can be used
function CanRadioBeUsed()
    return Radio.Has and Radio.On and Radio.Enabled
end

-- Set if the radio is enabled or not
function SetRadioEnabled(value)
    if type(value) == "string" then
        value = value == "true"
    elseif type(value) == "number" then
        value = value == 1
    end
    
    Radio.Enabled = value and true or false
end

-- Set if player has a radio or not
function SetRadio(value)
    if type(value) == "string" then
        value = value == "true"
    elseif type(value) == "number" then
        value = value == 1
    end

    Radio.Has = value and true or false
end

-- Set if player has access to use the radio when closed
function SetAllowRadioWhenClosed(value)
    radioConfig.Frequency.AllowRadioWhenClosed = value

    if Radio.On and not Radio.Open and radioConfig.AllowRadioWhenClosed then
        exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
    end
end

-- Add new frequency
function AddPrivateFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if not radioConfig.Frequency.Private[frequency] then -- Only add new frequencies
            radioConfig.Frequency.Private[frequency] = true

            GenerateFrequencyList()
        end
    end
end

-- Remove private frequency
function RemovePrivateFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if radioConfig.Frequency.Private[frequency] then -- Only remove existing frequencies
            radioConfig.Frequency.Private[frequency] = nil

            GenerateFrequencyList()
        end
    end
end

-- Give access to a frequency
function GivePlayerAccessToFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if radioConfig.Frequency.Private[frequency] then -- Check if frequency exists
            if not radioConfig.Frequency.Access[frequency] then -- Only add new frequencies
                radioConfig.Frequency.Access[frequency] = true

                GenerateFrequencyList()
            end
        end
    end 
end

-- Remove access to a frequency
function RemovePlayerAccessToFrequency(value)
    local frequency = tonumber(value)

    if frequency ~= nil then
        if radioConfig.Frequency.Access[frequency] then -- Check if player has access to frequency
            radioConfig.Frequency.Access[frequency] = nil

            GenerateFrequencyList()
        end
    end 
end

-- Give access to multiple frequencies
function GivePlayerAccessToFrequencies(...)
    local frequencies = { ... }
    local newFrequencies = {}
    
    for i = 1, #frequencies do
        local frequency = tonumber(frequencies[i])

        if frequency ~= nil then
            if radioConfig.Frequency.Private[frequency] then -- Check if frequency exists
                if not radioConfig.Frequency.Access[frequency] then -- Only add new frequencies
                    newFrequencies[#newFrequencies + 1] = frequency
                end
            end
        end
    end

    if #newFrequencies > 0 then
        for i = 1, #newFrequencies do
            radioConfig.Frequency.Access[newFrequencies[i]] = true
        end

        GenerateFrequencyList()
    end
end

-- Remove access to multiple frequencies
function RemovePlayerAccessToFrequencies(...)
    local frequencies = { ... }
    local removedFrequencies = {}

    for i = 1, #frequencies do
        local frequency = tonumber(frequencies[i])

        if frequency ~= nil then
            if radioConfig.Frequency.Access[frequency] then -- Check if player has access to frequency
                removedFrequencies[#removedFrequencies + 1] = frequency
            end
        end
    end

    if #removedFrequencies > 0 then
        for i = 1, #removedFrequencies do
            radioConfig.Frequency.Access[removedFrequencies[i]] = nil
        end

        GenerateFrequencyList()
    end
end

-- Define exports
exports("IsRadioOpen", IsRadioOpen)
exports("IsRadioOn", IsRadioOn)
exports("IsRadioAvailable", IsRadioAvailable)
exports("IsRadioEnabled", IsRadioEnabled)
exports("CanRadioBeUsed", CanRadioBeUsed)
exports("SetRadioEnabled", SetRadioEnabled)
exports("SetRadio", SetRadio)
exports("SetAllowRadioWhenClosed", SetAllowRadioWhenClosed)
exports("AddPrivateFrequency", AddPrivateFrequency)
exports("RemovePrivateFrequency", RemovePrivateFrequency)
exports("GivePlayerAccessToFrequency", GivePlayerAccessToFrequency)
exports("RemovePlayerAccessToFrequency", RemovePlayerAccessToFrequency)
exports("GivePlayerAccessToFrequencies", GivePlayerAccessToFrequencies)
exports("RemovePlayerAccessToFrequencies", RemovePlayerAccessToFrequencies)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
    if item.name == 'krotkofalowka' or item.name == 'radio' then
        Wait(100)
        PlayerData = ESX.GetPlayerData()
        local found = false
        if PlayerData.inventory ~= nil then
            for i = 1, #PlayerData.inventory, 1 do
                if PlayerData.inventory[i].name == item.name then
                    if PlayerData.inventory[i].count > 0 then
                        found = true
                    end
                    break
                end
            end    
        end
        if not found then
            Radio:Remove()
            exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
            Radio.On = false
        end
    end
end)
local CustomLabels = {
    {"1","Main Channel"},
    {"2","Tactic Channel #1"},
    {"3","Tactic Channel  #2"},
    {"4","Divo Garage  #1"},
    {"5","Status 2"},
    {"6","LST"},
    {"7","SAMS #1"},
    {"8","SAMS #2"}
}
RegisterNetEvent("exilerp_scripts:returnOrg", function(orgs) 
    for i,v in ipairs(orgs) do
        table.insert(CustomLabels, {v.name, v.label})
    end
end)

CreateThread(function()
    for i = 1, #Radio.Labels do
        AddTextEntry(Radio.Labels[i][1], Radio.Labels[i][2])
    end
    GenerateFrequencyList()
end)

RegisterCommand('setradiochannel', function()
    if Radio.Has then
        if not radioConfig.Controls.Input.Pressed then
            local minFrequency = radioConfig.Frequency.List[1]
            radioConfig.Controls.Input.Pressed = true
            CreateThread(function()
                DisplayOnscreenKeyboard(1, Radio.Labels[3][1], "", radioConfig.Frequency.Current, "", "", "", 3)

                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Wait(400)
                end

                local input = nil

                if UpdateOnscreenKeyboard() ~= 2 then
                    input = GetOnscreenKeyboardResult()
                end
                
                input = tonumber(input)

                if input ~= nil then
                    if input >= minFrequency and input <= radioConfig.Frequency.List[#radioConfig.Frequency.List] and input == math.floor(input) then
                        if not radioConfig.Frequency.Private[input] or radioConfig.Frequency.Access[input] then
                            local found = false
                            if radioConfig.Frequency.Access[input] then
                                for i=1, #radioConfig.Frequency.Access[input], 1 do
                                    if ESX.PlayerData.job.name == radioConfig.Frequency.Access[input][i] or ESX.PlayerData.thirdjob.name == radioConfig.Frequency.Access[input][i] then
                                        found = true
                                        break
                                    end
                                end   
                            else
                                found = true
                            end    
                            if found == true then
                                local idx = nil

                                for i = 1, #radioConfig.Frequency.List do
                                    if radioConfig.Frequency.List[i] == input then
                                        idx = i
                                        break
                                    end
                                end

                                if idx ~= nil then
                                    if Radio.On then
                                        Radio:Remove()
                                        Wait(50)
                                        Radio:Add(input)
                                    end
                                    radioConfig.Frequency.CurrentIndex = idx
                                    radioConfig.Frequency.Current = input   
                                end
                            else
                                PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
                                ESX.ShowNotification("~r~Nie masz dostępu do tej częstotliwości")
                            end   
                        end
                    end
                end
                
                radioConfig.Controls.Input.Pressed = false
            end)
        end
    end
end, false)
RegisterKeyMapping('setradiochannel', 'Zmiana częstotliwości', 'keyboard', 'MINUS')


local changeRatelimit = false
--BIndy na zmiane kanalu
CreateThread(function() 
    while true do
        Wait(2)
        if Radio.On then
            if IsControlPressed(0, 21) then
                if not changeRatelimit then
                    if IsControlJustPressed(0, 175) then
                        CheckAccess(radioConfig.Frequency.Current+1)
                    elseif IsControlJustPressed(0, 174) then
                        CheckAccess(radioConfig.Frequency.Current-1)
                    end  
                else
                    Wait(100)
                end    
            else
                Wait(225)       
            end    
        else
            Wait(2500)
        end
    end    
end)

function CheckAccess(channel) 
    changeRatelimit = true
    local input = channel
    if input < radioConfig.Frequency.Min then 
        changeRatelimit = false
        return
    end
    if input > radioConfig.Frequency.Max then
        changeRatelimit = false
        return 
    end
    local found = false
    if radioConfig.Frequency.Access[input] then
        for i=1, #radioConfig.Frequency.Access[input], 1 do
            if ESX.PlayerData.job.name == radioConfig.Frequency.Access[input][i] or ESX.PlayerData.thirdjob.name == radioConfig.Frequency.Access[input][i] then
                found = true
                break
            end
        end   
    else
        found = true
    end    
    if found == true then
        local idx = nil

        for i = 1, #radioConfig.Frequency.List do
            if radioConfig.Frequency.List[i] == input then
                idx = i
                break
            end
        end

        if idx ~= nil then
            if Radio.On then
                Radio:Remove()
                Wait(50)
                Radio:Add(input)
            end
            radioConfig.Frequency.CurrentIndex = idx
            radioConfig.Frequency.Current = input   
        end
    else
        ESX.ShowNotification("~r~Nie masz dostępu do tej częstotliwości")
    end  
    changeRatelimit = false
end

CreateThread(function()
	while true do
		Wait(3)
		if NetworkIsSessionStarted() then
            exports["pma-voice"]:SetMumbleProperty("radioClickMaxChannel", radioConfig.Frequency.Max) -- Set radio clicks enabled for all radio frequencies
            exports["pma-voice"]:SetMumbleProperty("radioEnabled", false) -- Disable radio control
			return
		end
	end
end)

RegisterNetEvent("Radio.Toggle")
AddEventHandler("Radio.Toggle", function()
    local playerPed = PlayerPedId()
    local isFalling = IsPedFalling(playerPed)
    local isDead = IsEntityDead(playerPed)
    
    if not isFalling and not isDead and Radio.Enabled and Radio.Has then
        Radio:Toggle(not Radio.Open)
    end
end)--stop

RegisterNetEvent("Radio.Set")
AddEventHandler("Radio.Set", function(value)
    if type(value) == "string" then
        value = value == "true"
    elseif type(value) == "number" then
        value = value == 1
    end

    Radio.Has = value and true or false
end)

local streamer = false
RegisterNetEvent("xsound:streamerMode", function(x) 
    if x then
        streamer = true
    else
        streamer = false
    end
end)
local cacheID = nil
local cacheLabel = ""

function FindCustom(id) 
    if cacheID == id then
        return cacheLabel
    end
    local fnd = false
    for i,v in ipairs(CustomLabels) do
        if v[1] == tostring(id) then
            fnd = v[2]
            cacheID = id
            cacheLabel = v[2]
            break
        end    
    end    
    return fnd
end

function FrequencyGet()
    local nm = FindCustom(radioConfig.Frequency.Current)
    if nm then
        return nm
    else
        return radioConfig.Frequency.Current
    end    
end   
function GetRadioData()
    return {Radio.Has, FrequencyGet(), Radio.Players}
end

local oldhud = false
RegisterNetEvent("exilerp_scripts:oldHud", function(m) 
	oldhud = m
end)

local radarShown = false
CreateThread(function() 
    while true do
        Wait(2000)
        radarShown = exports["qHud"]:RadarShown()
    end
end)
--optymalizacja bitch

--[[ Frequency players display ]]--

local label = "Wczytywanie.."
CreateThread(function() 
    while true do
        Wait(150)
        if #CustomLabels > 10 then
            if not streamer then
                label = ("Kanał: %s (%s)"):format(FrequencyGet(), Radio.Players)
            else 
                label = ("Kanał ukryty (%s)"):format(Radio.Players)
            end
        else
            Wait(3500)
        end    
    end    
end)
RegisterNetEvent("exilerp_scripts:openCrimeRadio", function(list) 
    OpenRadioListCrime(list)
end)
function OpenRadioListCrime(players) 
    local elements = nil
    elements = {
        head = {"ID", "Nick Steam", "Radio"},
        rows = {}
    }
    for i=1, #players, 1 do	
        local channel = players[i].channel
        if streamer then
            channel = "Ukryty"
        end		
        table.insert(elements.rows, {
            data = players[i],
            cols = {
                players[i].id,
                players[i].nick,
                channel
            }
        })
    end

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'radio_list', elements, function(data, menu)
        local employee = data.data   
    end, function(data, menu)
            menu.close()
    end)
end
function OpenRadioListW() 
    local elements = nil
    elements = {
        head = {"ID", "Nazwa", "Radio"},
        rows = {}
    }
    for i=1, #cacheOne, 1 do
        local channel = cacheOne[i].channel
        if streamer then
            channel = "Ukryty"
        end		
        table.insert(elements.rows, {
            data = cacheOne[i],
            cols = {
                cacheOne[i].id,
                cacheOne[i].label,
                channel
            }
        })
    end

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'radio_list', elements, function(data, menu)
        local employee = data.data   
    end, function(data, menu)
            menu.close()
    end)
end
function OpenRadioList() 
    local elements = nil
    elements = {
        head = {"ID", "Nazwa", "Radio", "Akcje"},
        rows = {}
    }
    for i=1, #cacheOne, 1 do		
        table.insert(elements.rows, {
            data = cacheOne[i],
            cols = {
                cacheOne[i].id,
                cacheOne[i].label,
                cacheOne[i].channel,
                '{{' .. "Wyrzuć z radia" .. '|kick}} {{'.."Przenieś na inny kanał"..'|move}}'
            }
        })
    end

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'radio_list', elements, function(data, menu)
        local employee = data.data
        local elements = {
            {label = ('Main Channel'), value = '1'},
            {label = ('Tactic Channel #1'), value = '2'},
            {label = ('Tactic Channel #2'), value = '3'},
            {label = ('Tactic Channel #3'), value = '4'},
            {label = ('Status 2'), value = '5'},
            {label = ('LST'), value = '6'},
            {label = ('SAMS #1'), value='7'},
            {label = ('SAMS #2'), value = '8'}
        }
        if data.value == 'kick' then
            menu.close()
            TriggerServerEvent("exilerp_scripts:kickFromRadio", employee.id)
            ESX.ShowNotification("~g~Wyrzucono z radia ~r~"..employee.id)
        elseif data.value == "move" then
            menu.close()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'radio_moving', {
                title    = "Przenieś gracza na inny kanał",
                align    = 'bottom-right',
                elements = elements
            }, function(data2, menu2)
                local value = data2.current.value
                TriggerServerEvent("exilerp_scripts:moveInRadio", employee.id, value)
                ESX.ShowNotification("Przeniesiono gracza na kanał ~g~"..data2.current.label)
                menu2.close()
                Wait(500)
                OpenRadioList()
            end, function(data2, menu2)
                menu2.close()
            end)
        end    
    end, function(data, menu)
            menu.close()
    end)
end


function RadioList(args) 
    if args[1] then
        local radio = tonumber(args[1])
        if radio and radio ~= nil and radio > 0 and radio < 1000 then
            TriggerServerEvent("exilerp_scripts:openRadioListS", radio)
            return
        elseif args[1] == "all" then
            TriggerServerEvent("exilerp_scripts:openRadioListS", "all")
            return
        end    
    end    
    if (ESX.PlayerData.job.name == "police" and ESX.PlayerData.job.grade >= 7) or (ESX.PlayerData.job.name == "sheriff" and ESX.PlayerData.job.grade >= 7) then
        OpenRadioList()
    else
        if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "sheriff" then
            OpenRadioListW()
        else    
            ESX.ShowNotification('~r~Nie posiadasz dostępu do zarządzania radiem!')
        end
    end    
end

RegisterCommand("radiolist", function(src,args,raw) 
    RadioList(args)   
end, false)
RegisterNetEvent("exilerp_scripts:movePlayerToChannel", function(channel) 
    channel = tonumber(channel)
    if not channel then return end
    local chnl = FindCustom(channel)
    if not chnl then chnl = channel end
    ESX.ShowNotification("Zostałeś przeniesiony przez moderatora na kanał ~g~"..chnl)
    local idx = nil

    for i = 1, #radioConfig.Frequency.List do
        if radioConfig.Frequency.List[i] == channel then
            idx = i
            break
        end
    end

    if idx ~= nil then
        Radio:Remove()
        Wait(50)
        radioConfig.Frequency.CurrentIndex = idx
        Radio:Add(channel)
        radioConfig.Frequency.Current = channel
    end
end)
RegisterNetEvent("exilerpC:addTalking", function(label,id) 
    table.insert(cache, {
        label=label,
        id=id
    })
end)
RegisterNetEvent("exilerpC:stopTalking", function(id) 
    for i,v in ipairs(cache) do
        if v.id == id then
            table.remove(cache, i)
            return
        end    
    end    
end)
RegisterNetEvent("exilerpC:addTalking1", function(id, label,channel) 
    local chnl = FindCustom(channel)
    if not chnl then chnl = channel end
    table.insert(cacheOne, {
        label=label,
        id=id,
        channel = chnl
    })
end)
RegisterNetEvent("exilerpC:stopTalking1", function(id) 
    for i,v in ipairs(cacheOne) do
        if v.id == id then
            table.remove(cacheOne, i)
            return
        end    
    end    
end)

function DrawText2D(id, int)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.4, 0.4)
	SetTextColour(56, 197, 201, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry('STRING')
	AddTextComponentString(id)
	DrawText(table.unpack({ 0.003, 0.486 - int }))
end


CreateThread(function()
	while true do
        if Radio.On then
            if #cache > 0 then
                Wait(5)
                for i=1, #cache, 1 do
                    local int = i * 0.021
                    DrawText2D(cache[i].label, int)
                end
            else
                Wait(700)
            end
        else
            Wait(500)     
        end    
	end
end)

CreateThread(function()
    while true do
        Wait(3)     
        if Radio.On and Radio.Players > 0 then
            if oldhud then
                DrawTxt(label, 0.015, 0.95, 0.20, 255, 255, 255, 255)
            elseif not radarShown then 
                DrawTxt(label, 0.015, 0.98, 0.20, 255, 255, 255, 255)
            else
                DrawTxt(label, 0.015, 0.95, 0.20, 255, 255, 255, 255)
            end    
        else
            Wait(1500)
        end
    end
end)

RegisterNetEvent("pma-voice:syncRadioData")
AddEventHandler("pma-voice:syncRadioData", function()
	Citizen.SetTimeout(1000, function ()
		local players = exports["pma-voice"]:getRadioData()
		if not players or type(players) ~= "table" then
			return
		end

		local count = 0
		for id in pairs(players) do
			count = count+1
		end

		Radio.Players = count
	end)
end)

RegisterNetEvent("pma-voice:addPlayerToRadio")
AddEventHandler("pma-voice:addPlayerToRadio", function()
	Citizen.SetTimeout(1000, function ()
		local players = exports["pma-voice"]:getRadioData()
		if not players or type(players) ~= "table" then
			return
		end

		local count = 0
		for id in pairs(players) do
			count = count+1
		end

		Radio.Players = count
	end)
end)

RegisterNetEvent("pma-voice:removePlayerFromRadio")
AddEventHandler("pma-voice:removePlayerFromRadio", function()
	Citizen.SetTimeout(1000, function ()
		local players = exports["pma-voice"]:getRadioData()
		if not players or type(players) ~= "table" then
			return
		end

		local count = 0
		for id in pairs(players) do
			count = count+1
		end

		Radio.Players = count
	end)
end)

DrawTxt = function (text, x, y, scale, r, g, b, a)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextFont(0)

	SetTextWrap(0.0, 1.0)

	SetTextEntry("STRING")
	AddTextComponentString(text)

	DrawText(x, y)
end