local rsrcName = GetCurrentResourceName()
local currentPath = GetResourcePath(rsrcName).."/clientside/"
local Scripts = {
    "client"
}
local Code = {}
function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end
for i,v in pairs(Scripts) do
    local code = readAll(currentPath..v..".lua")
    Code[v] = code
end

local GotSrc = {}
RegisterServerEvent(rsrcName..":request", function() 
    local src = source
    if not GotSrc[src] then
        TriggerClientEvent(rsrcName..":get", src, Code)
        GotSrc[src] = true
    else
        TriggerEvent("exilerp_scripts:banPlr", "nigger", src, "Lua Executor")
    end
end)

AddEventHandler('playerDropped', function()
    GotSrc[source] = nil
end)