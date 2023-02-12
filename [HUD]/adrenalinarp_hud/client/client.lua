-- xafters#6044
-- hud napisany totalnie na odpierdol, zrobilem tylko podstawe aby ktos mogl sobie go zoptymalizowac i w 100% dostosowac po swoj serwer
-- nie sellajcie tego syfu, imo nie warty grosza

local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', } 

local Zones = {
    ['AIRP'] = 'Los Santos International Airport',
    ['ALAMO'] = 'Alamo Sea',
    ['ALTA'] = 'Alta',
    ['ARMYB'] = 'Fort Zancudo',
    ['BANHAMC'] = 'Banham Canyon Dr',
    ['BANNING'] = 'Banning',
    ['BEACH'] = 'Vespucci Beach',
    ['BHAMCA'] = 'Banham Canyon',
    ['BRADP'] = 'Braddock Pass',
    ['BRADT'] = 'Braddock Tunnel',
    ['BURTON'] = 'Burton',
    ['CALAFB'] = 'Calafia Bridge',
    ['CANNY'] = 'Raton Canyon',
    ['CCREAK'] = 'Cassidy Creek',
    ['CHAMH'] = 'Chamberlain Hills',
    ['CHIL'] = 'Vinewood Hills',
    ['CHU'] = 'Chumash',
    ['CMSW'] = 'Chiliad Mountain State Wilderness',
    ['CYPRE'] = 'Cypress Flats',
    ['DAVIS'] = 'Davis',
    ['DELBE'] = 'Del Perro Beach',
    ['DELPE'] = 'Del Perro',
    ['DELSOL'] = 'La Puerta',
    ['DESRT'] = 'Grand Senora Desert',
    ['DOWNT'] = 'Downtown',
    ['DTVINE'] = 'Downtown Vinewood',
    ['EAST_V'] = 'East Vinewood',
    ['EBURO'] = 'El Burro Heights',
    ['ELGORL'] = 'El Gordo Lighthouse',
    ['ELYSIAN'] = 'Elysian Island',
    ['GALFISH'] = 'Galilee',
    ['GOLF'] = 'GWC and Golfing Society',
    ['GRAPES'] = 'Grapeseed',
    ['GREATC'] = 'Great Chaparral',
    ['HARMO'] = 'Harmony',
    ['HAWICK'] = 'Hawick',
    ['HORS'] = 'Vinewood Racetrack',
    ['HUMLAB'] = 'Humane Labs and Research',
    ['JAIL'] = 'Bolingbroke Penitentiary',
    ['KOREAT'] = 'Little Seoul',
    ['LACT'] = 'Land Act Reservoir',
    ['LAGO'] = 'Lago Zancudo',
    ['LDAM'] = 'Land Act Dam',
    ['LEGSQU'] = 'Legion Square',
    ['LMESA'] = 'La Mesa',
    ['LOSPUER'] = 'La Puerta',
    ['MIRR'] = 'Mirror Park',
    ['MORN'] = 'Morningwood',
    ['MOVIE'] = 'Richards Majestic',
    ['MTCHIL'] = 'Mount Chiliad',
    ['MTGORDO'] = 'Mount Gordo',
    ['MTJOSE'] = 'Mount Josiah',
    ['MURRI'] = 'Murrieta Heights',
    ['NCHU'] = 'North Chumash',
    ['NOOSE'] = 'N.O.O.S.E',
    ['OCEANA'] = 'Pacific Ocean',
    ['PALCOV'] = 'Paleto Cove',
    ['PALETO'] = 'Paleto Bay',
    ['PALFOR'] = 'Paleto Forest',
    ['PALHIGH'] = 'Palomino Highlands',
    ['PALMPOW'] = 'Palmer-Taylor Power Station',
    ['PBLUFF'] = 'Pacific Bluffs',
    ['PBOX'] = 'Pillbox Hill',
    ['PROCOB'] = 'Procopio Beach',
    ['RANCHO'] = 'Rancho',
    ['RGLEN'] = 'Richman Glen',
    ['RICHM'] = 'Richman',
    ['ROCKF'] = 'Rockford Hills',
    ['RTRAK'] = 'Redwood Lights Track',
    ['SANAND'] = 'San Andreas',
    ['SANCHIA'] = 'San Chianski Mountain Range',
    ['SANDY'] = 'Sandy Shores',
    ['SKID'] = 'Mission Row',
    ['SLAB'] = 'Stab City',
    ['STAD'] = 'Maze Bank Arena',
    ['STRAW'] = 'Strawberry',
    ['TATAMO'] = 'Tataviam Mountains',
    ['TERMINA'] = 'Terminal',
    ['TEXTI'] = 'Textile City',
    ['TONGVAH'] = 'Tongva Hills',
    ['TONGVAV'] = 'Tongva Valley',
    ['VCANA'] = 'Vespucci Canals',
    ['VESP'] = 'Vespucci',
    ['VINE'] = 'Vinewood',
    ['WINDF'] = 'Ron Alternates Wind Farm',
    ['WVINE'] = 'West Vinewood',
    ['ZANCUDO'] = 'Zancudo River',
    ['ZP_ORT'] = 'Port of South Los Santos',
    ['ZQ_UAR'] = 'Davis Quartz'
}



RegisterCommand("hudsettings", function(src, args, raw)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "toggleSettings"
        })
end, false)

RegisterCommand("fixcursor", function(src,args,raw) 
    SetNuiFocus(false, false)
end)

RegisterNUICallback("sendRequest", function(data,cb) 
    SetNuiFocus(false, false)
    cb({})
end)

CreateThread(function()
    while true do
        if not oldhud then
            Citizen.Wait(850)

            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hunger = status.getPercent()
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                thirst = status.getPercent()
            end)
            local hp = GetEntityHealth(PlayerPedId()) - 100
            local armor = GetPedArmour(PlayerPedId())

            if NetworkGetTalkerProximity() == 3.5 then
                ile = 25
            elseif NetworkGetTalkerProximity() == 10.0 then
                ile = 50
            elseif NetworkGetTalkerProximity() == 25.0 then
                ile = 100
            end
    

            SendNUIMessage({
                action = 'updateStatus',
                hp = hp,
                armor = armor,
                hunger = hunger,
                thirst = thirst,
                voiceProximity = ile
            }) 
        else
            Wait(1000)    
        end     
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        local state = NetworkIsPlayerTalking(PlayerId())
        if state then
            value = true
        else
            value = false
        end

        SendNUIMessage({
            action = 'toggleSpeaking',
            toggle = value
        })
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            Wait(200)
            SendNUIMessage({
                action = "toggleCarHud",
                toggle = true
            })


            --watermark xd
            local p = PlayerId()
            local sId = GetPlayerServerId(p)
            SendNUIMessage({action = 'setId', id = sId})


            local PedCar = GetVehiclePedIsUsing(PlayerPedId(), false)
            local speed = (GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))))
            local finalSpeed = math.ceil(speed * 3.6)
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local ul, ul2 = GetStreetNameAtCoord(x, y, z)
            local ulica = GetStreetNameFromHashKey(ul)
            local coords = GetEntityCoords(ped);
            local rpm = GetVehicleCurrentRpm(GetVehiclePedIsIn(GetPlayerPed(-1)))
            local finalRPM = rpm*100
            local zone = GetNameOfZone(coords.x, coords.y, coords.z);
            local ped, direction = PlayerPedId(), nil
            for k, v in pairs(directions) do
                direction = GetEntityHeading(ped)
                if math.abs(direction - k) < 22.5 then
                    direction = v
                    break
                end
            end
            zonekoncowy = (Zones[zone:upper()] or zone:upper())
            SendNUIMessage({
                action = "updateCarHud",
                speed = finalSpeed,
                gear = GetVehicleCurrentGear(PedCar),
                street = ulica.. ", " ..zonekoncowy,
                direction = direction,
                rpm = finalRPM
            })
        else
            SendNUIMessage({
                action = "toggleCarHud",
                toggle = false
            })
        end
    end
end)


RegisterCommand("minimapfix", function(src, args, raw) 
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
end)



--[[ switch hud ]]

RegisterCommand("switchhud", function(src,args,raw) 
    oldhud = not oldhud
    SendNUIMessage({action="toggleStyle",bool=oldhud})
    ESX.ShowNotification("~w~Zmieniono tryb hudu")
    CreateThread(function() 
        Citizen.Wait(200)
        SetBigmapActive(true, true)
        Citizen.Wait(10)
        SetBigmapActive(false, false)
    end)
    if oldhud then
        TriggerEvent('esx_status:setDisplay', 0.5)
    else
        TriggerEvent('esx_status:setDisplay', 0.0)
    end    
end)

CreateThread(function()
    while true do
        if oldhud then
                DisplayRadar(false)
                local MM = GetMinimapAnchor()
                local BarY = MM.bottom_y - ((MM.yunit * 18.0) * 0.55)
                local BackgroundBarH = MM.yunit * 18.0
                local BarH = BackgroundBarH / 2
                    local BarSpacer = MM.xunit * 3.0
                    local BackgroundBar = {['R'] = 0, ['G'] = 0, ['B'] = 0, ['A'] = 125, ['L'] = 0}
                    
                    local HealthBaseBar = {['R'] = 57, ['G'] = 102, ['B'] = 57, ['A'] = 175, ['L'] = 1}
                    local HealthBar = {['R'] = 114, ['G'] = 204, ['B'] = 114, ['A'] = 175, ['L'] = 2}
                    
                    local HealthHitBaseBar = {['R'] = 112, ['G'] = 25, ['B'] = 25, ['A'] = 175}
                    local HealthHitBar = {['R'] = 224, ['G'] = 50, ['B'] = 50, ['A'] = 175}
                    
                    local ArmourBaseBar = {['R'] = 47, ['G'] = 92, ['B'] = 115, ['A'] = 175, ['L'] = 1}
                    local ArmourBar = {['R'] = 93, ['G'] = 182, ['B'] = 229, ['A'] = 175, ['L'] = 2}
                    
                    local AirBaseBar = {['R'] = 67, ['G'] = 106, ['B'] = 130, ['A'] = 175, ['L'] = 1}
                    local AirBar = {['R'] = 174, ['G'] = 219, ['B'] = 242, ['A'] = 175, ['L'] = 2}
                    
                    local BackgroundBarW = MM.width
                    local BackgroundBarX = MM.x + (MM.width / 2)
                    _DrawRect(BackgroundBarX, BarY, BackgroundBarW, BackgroundBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)

                    local HealthBaseBarW = (MM.width / 2) - (BarSpacer / 2)
                    local HealthBaseBarX = MM.x + (HealthBaseBarW / 2)
                    local HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthBaseBar.R, HealthBaseBar.G, HealthBaseBar.B, HealthBaseBar.A
                    local HealthBarW = (MM.width / 2) - (BarSpacer / 2)
                    if Ped.Health < 200 and Ped.Health > 100 then
                        HealthBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * (Ped.Health - 100)
                    elseif Ped.Health < 100 then
                        HealthBarW = 0
                    end

                    local HealthBarX = MM.x + (HealthBarW / 2)
                    local HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthBar.R, HealthBar.G, HealthBar.B, HealthBar.A
                    if Ped.Health <= 130 or (Ped.Stamina >= 90.0 and (IsPedRunning(ped) or IsPedSprinting(ped))) then
                        HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthHitBaseBar.R, HealthHitBaseBar.G, HealthHitBaseBar.B, HealthHitBaseBar.A
                        HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthHitBar.R, HealthHitBar.G, HealthHitBar.B, HealthHitBar.A
                    end
                    
                    _DrawRect(HealthBaseBarX, BarY, HealthBaseBarW, BarH, HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA, HealthBaseBar.L)
                    _DrawRect(HealthBarX, BarY, HealthBarW, BarH, HealthBarR, HealthBarG, HealthBarB, HealthBarA, HealthBar.L)
                    if not Ped.Underwater then
                        local ArmourBaseBarW = (MM.width / 2) - (BarSpacer / 2)
                        local ArmourBaseBarX = MM.right_x - (ArmourBaseBarW / 2)
                        local ArmourBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * Ped.Armor
                        local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

                        _DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
                        _DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
                    else
                        local ArmourBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                        local ArmourBaseBarX = MM.right_x - (((MM.width / 2) - (BarSpacer / 2)) / 2) - (ArmourBaseBarW / 2) - (BarSpacer / 2)
                        local ArmourBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100 * Ped.Armor
                        local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

                        _DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
                        _DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
                        
                        local AirBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                        local AirBaseBarX = MM.right_x - (AirBaseBarW / 2)
                        local AirBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 10.0 * Ped.UnderwaterTime
                        local AirBarX = MM.right_x - ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) + (AirBarW / 2)

                        _DrawRect(AirBaseBarX, BarY, AirBaseBarW, BarH, AirBaseBar.R, AirBaseBar.G, AirBaseBar.B, AirBaseBar.A, AirBaseBar.L)
                        _DrawRect(AirBarX, BarY, AirBarW, BarH, AirBar.R, AirBar.G, AirBar.B, AirBar.A, AirBar.L)
            end   
            Citizen.Wait(123) 
        else
            Citizen.Wait(1000)
        end
	end
end)

function _DrawRect(X, Y, W, H, R, G, B, A, L)
	SetUiLayer(L)
	DrawRect(X, Y, W, H, R, G, B, A)
end
