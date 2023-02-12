OrgJobs = {}
MySQL.ready(function() 
    MySQL.query("SELECT * FROM jobs WHERE name LIKE ?", {"%org%"}, function(results) 
        for i,v in ipairs(results) do
            local final = (v.name):gsub("org", "")
            local number = tonumber(final)
            table.insert(OrgJobs, {
                name = tostring(number+100),
                label = v.label
            })
        end   
    end)
end)

local PlayerChannels = {}

function RegisterInChannel(id, channel, label) 
    TriggerClientEvent("exilerpC:stopTalking", -1, id)
    for i,v in ipairs(PlayerChannels) do
        if v.id == id then
            table.remove(PlayerChannels, i)
        end    
    end    
    table.insert(PlayerChannels, {
        id = id,
        channel = channel,
        label = label,
        nick = GetPlayerName(id)
    })
    for ii,vv in ipairs(PlayerChannels) do
        if not (vv.id == id) then
            if tonumber(vv.channel) < 6 then
                TriggerClientEvent("exilerpC:addTalking1", id, vv.id, vv.label, vv.channel)
            end
        end    
    end   
    if tonumber(channel) < 6 then
        TriggerClientEvent("exilerpC:addTalking1", -1, id, label, channel)
    end
end
function UnregisterInChannel(id) 
    TriggerClientEvent("exilerpC:stopTalking", -1, id)
    TriggerClientEvent("exilerpC:stopTalking1", -1, id)   
    for i,v in ipairs(PlayerChannels) do
        if v.id == id then
            table.remove(PlayerChannels, i)
        end    
    end    
end
AddEventHandler('playerDropped', function (reason)
    local src = source
    UnregisterInChannel(src)
end)
  
function GetChannel(id) 
    for i,v in ipairs(PlayerChannels) do
        if v.id == id then
            return v.channel
        end    
    end   
end
function SendStartTalking(label, id, channel) 
    for i,v in ipairs(PlayerChannels) do
        if v.channel == channel then
            TriggerClientEvent("exilerpC:addTalking", v.id, label, id)
        end    
    end  
end
function SendStopTalking(id, channel) 
    for i,v in ipairs(PlayerChannels) do
        if v.channel == channel then
            TriggerClientEvent("exilerpC:stopTalking", v.id, id)
        end    
    end  
end
function GetPlrsInChannel(channel) 
    local plrs = {}
    for i,v in ipairs(PlayerChannels) do
        if v.channel == channel then
            table.insert(plrs, v)
        end    
    end  
    return plrs
end
RegisterServerEvent("exilerp_scripts:moveInRadio", function(id,channel) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group == 'best' then
        TriggerClientEvent("exilerp_scripts:movePlayerToChannel", id, channel)
    else
        TriggerEvent('exilerp_scripts:banPlr', "nigger", src, "Tried to move player in radio without permission (rp-radio)")
    end
end)
RegisterServerEvent("exilerp_scripts:kickFromRadio", function(id) 
    local src = source
    TriggerClientEvent("exilerpC:kickedFromRadio", id)
end)
RegisterServerEvent("exilerp_scripts:registerChannel", function(chnl) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "mechanik" then
            local badge = json.decode(xPlayer.character.job_id).id
            if not badge then
                badge = ""
            else
                badge = "["..badge.."]"
            end   
            local str = badge.." "..xPlayer.character.firstname.." "..xPlayer.character.lastname
            RegisterInChannel(src, chnl, str)   
        else
            RegisterInChannel(src, chnl, tostring(src))
        end    
    end 
end)
RegisterServerEvent("exilerp_scripts:unregisterChannel", function() 
    local src = source
    UnregisterInChannel(src)
end)
RegisterServerEvent("exilerp_scripts:openRadioListS", function(r) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer and xPlayer.source ~= nil and xPlayer.source ~= 0 then
        if r == "all" then
            TriggerClientEvent("exilerp_scripts:openCrimeRadio", src, PlayerChannels)
        else
            TriggerClientEvent("exilerp_scripts:openCrimeRadio", src, GetPlrsInChannel(r))
        end    
    end    
end)
RegisterServerEvent("exilerp_scripts:addTalking", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        local channel = tonumber(GetChannel(src))
        if not channel then return end
        if channel < 9 then
            if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "mechanik" then
                local badge = json.decode(xPlayer.character.job_id).id
                if not badge then
                    badge = ""
                else
                    badge = "["..badge.."]"
                end   
                local str = badge.." ~w~"..xPlayer.character.firstname.." "..xPlayer.character.lastname
                if xPlayer.job.name == "sheriff" then
                    str = "~o~"..str
                elseif xPlayer.job.name == "police" then
                    str = "~b~"..str          
                elseif xPlayer.job.name == "ambulance" then
                    str = "~r~"..str
                elseif xPlayer.job.name == "mechanik" then
                    str = "~p~"..str
                end    
                SendStartTalking(str, src, channel)
            end    
        else
            SendStartTalking(tostring(src), src, channel)
        end    
    end    
end)
RegisterServerEvent("exilerp_scripts:stopTalking", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        local nigger = GetChannel(src)
        if nigger then
            local channel = tonumber(nigger)
            if not channel then return end
            SendStopTalking(src, channel)  
        end
    end    
end)

RegisterServerEvent("exilerp_scripts:fetchOrganizations", function() 
    local src = source
    if #OrgJobs > 0 then
        TriggerClientEvent("exilerp_scripts:returnOrg", src, OrgJobs)
    else
        CreateThread(function() 
            while #OrgJobs < 1 do
                Wait(100)
            end     
            TriggerClientEvent("exilerp_scripts:returnOrg", src, OrgJobs)
        end)
    end    
end)