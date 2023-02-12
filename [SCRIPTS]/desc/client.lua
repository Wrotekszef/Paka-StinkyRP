local hidden = false
local coords = {}
local scenes = {}
local Adminek = false
local ID = false

RegisterNetEvent('esx_scoreboard:players')
AddEventHandler('esx_scoreboard:players', function(Counter, xd)
	if xd then
		Adminek = true
	end
end)

RegisterNetEvent('opis2:send', function(sent)
    scenes = sent
end)

function Open_Main_Menu()
  ESX.UI.Menu.CloseAll()

  local elements = {
      {label = "Ustaw Opis", value = "setopis"},
      {label = "Usuń Opis", value = "deleteopis"},
      {label = "Ukryj Opisy", value = "hideopis"},
  }

  if Adminek then
    table.insert(elements, {label = "Wyświetl ID (ADMIN)", value = 'ID'})
    table.insert(elements, {label = "Usuń wszystkie opisy (ADMIN)", value = 'deleteopisy'})
    table.insert(elements, {label = "Usuń Opis (ADMIN)", value = 'deleteopis2'})
  end

  ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'opis_2',
      {
          title    = 'Opis',
          align    = 'center',
          elements = elements
      },
      function(data, menu)
        if data.current.value == "setopis" then
            ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'opis_2_text',
          {
            title = "Wpisz Tekst"
          },
          function(data2, menu2)
            local text = data2.value
            if text  == nil then
                TriggerEvent('esx:showNotification', 'Wiadomość nie może być pusta!')
            else
                menu2.close()
                menu.close()
                coords = GetEntityCoords(PlayerPedId())
                local message = data2.value

                if string.find(message, 'ni gger')
                or string.find(message, 'n igger')
                or string.find(message, 'n igga')
                or string.find(message, 'n ig')
                or string.find(message, 'ni g')
                or string.find(message, 'nig')
                or string.find(message, 'down')
                or string.find(message, 'simp')
                or string.find(message, 'pedal')
                or string.find(message, 'pedał')
                or string.find(message, 'cwe')
                or string.find(message, 'czarnuh')
                or string.find(message, 'żyd')
                or string.find(message, 'zyd')
                or string.find(message, 'hitler')
                or string.find(message, 'ciota')
                or string.find(message, 'czarnuchu')
                or string.find(message, 'murzyn')
                or string.find(message, 'nyg')
                or string.find(message, 'karzeł')
                or string.find(message, 'karzel')
                or string.find(message, 'simpie')
                or string.find(message, 'geju')
                or string.find(message, 'żydzie')
                or string.find(message, 'zydzie')
                or string.find(message, 'downie')
                or string.find(message, 'czarnuch')
                then
                    TriggerServerEvent('cotykurwabocie')
                    return
                end

                local distance = 20
                if ClosestScene() > 1.2 then
                    if message == nil then 
                        TriggerEvent('esx:showNotification', 'Wiadomość nie może być pusta!')
                    end
                    TriggerServerEvent('opis2:add', coords, message)
                else
                    TriggerEvent('esx:showNotification', 'Jesteś zbyt blisko innego opisu!')
                end
            end
          end,
        function(data2, menu2)
            menu2.close()
        end)
        end
        if data.current.value == "deleteopis" then
            local scene = ClosestSceneLooking()
            if scene ~= nil then
                TriggerServerEvent('opis2:delete', scene)
            end
        end
        if data.current.value == "deleteopisy" then
            TriggerServerEvent('opis2:admindelete2')
        end
        if data.current.value == "deleteopis2" then
            local scene = ClosestSceneLooking()
            if scene ~= nil then
                TriggerServerEvent('opis2:admindelete', scene)
            end
        end
        if data.current.value == "hideopis" then
            hidden = not hidden
            if hidden then
                TriggerEvent('esx:showNotification', 'Wyłączono wyświetlanie opis2')
            else
                TriggerEvent('esx:showNotification', 'Włączono wyświetlanie opis2')
            end
        end
        if data.current.value == "ID" then
            ID = not ID
            if ID then
                TriggerEvent('esx:showNotification', 'Wyłączono wyświetlanie ID w opis2')
            else
                TriggerEvent('esx:showNotification', 'Włączono wyświetlanie ID w opis2')
            end
        end
      end,
      function(data, menu)
          menu.close()
      end
  )
end

RegisterCommand('opis2', function(source, args, rawCommand)
    Open_Main_Menu()
end)

CreateThread(function()
    while true do
        Wait(5)
        if #scenes > 0 then
            if not hidden then
                local plyCoords = GetEntityCoords(PlayerPedId())
                local closest = ClosestScene()
                if closest > 10.0 then
                    Wait(2000)
                else
                    for k, v in pairs(scenes) do
                        distance = Vdist(plyCoords, v.coords)
                        if distance <= 10 then
                            DrawScene(v.coords, (ID and v.showid.."~s~ " or "")..v.message, {255,255,255})
                        end
                    end
                end
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
    end
end)

TriggerServerEvent('opis2:fetch')


function SceneTarget()
    local camCoords = GetPedBoneCoords(PlayerPedId(), 37193, 0.0, 0.0, 0.0)
    local farCoords = GetCoordsFromCam()
    local RayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords, farCoords, -1, PlayerPedId(), 4)
    local _, hit, endcoords, surfaceNormal, entityHit = GetShapeTestResult(RayHandle)
    if endcoords[1] == 0.0 then return end
    return endcoords
end

function GetCoordsFromCam()
    local rot = GetGameplayCamRot(2)
    local coord = GetGameplayCamCoord()
    
    local tZ = rot.z * 0.0174532924
    local tX = rot.x * 0.0174532924
    local num = math.abs(math.cos(tX))
    
    newCoordX = coord.x + (-math.sin(tZ)) * (num + 4.0)
    newCoordY = coord.y + (math.cos(tZ)) * (num + 4.0)
    newCoordZ = coord.z + (math.sin(tX) * 8.0)
    return vector3(newCoordX, newCoordY, newCoordZ)
end

function DrawScene(coords, text)
    size = 0.35
	rect = {0.005, 0.03, 250}

    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vec3(px, py, pz) - vec3(coords.x, coords.y, coords.z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
	SetTextScale(size, size)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextCentre(1)
    SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
	DrawText(_x,_y)
end

function ClosestScene()
    local closestscene = 1000.0
    for i = 1, #scenes do
        local distance = Vdist(scenes[i].coords, GetEntityCoords(PlayerPedId()))
        if (distance < closestscene) then
            closestscene = distance
        end
    end
    return closestscene
end

function ClosestSceneLooking()
    local closestscene = 1000.0
    local scanid = nil
    for i = 1, #scenes do
        local distance = Vdist(scenes[i].coords, GetEntityCoords(PlayerPedId()))
        if (distance < closestscene and distance < 1.0) then
            scanid = i
            closestscene = distance
        end
    end
    return scanid
end