--[[function GetControlOfEntity(entity)
    local netTime = 15
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and netTime > 0 do
        NetworkRequestControlOfEntity(entity)
        Wait(100)
        netTime = netTime - 1
    end
end


local animation = { lib = 'random@mugging3' , base = 'handsup_standing_base', enter = 'handsup_standing_enter', exit = 'handsup_standing_exit', fade = 1 }

CreateThread(function() 
    while true do
        Wait(2500)
        local a,ped = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if a then
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped, true) and not IsPedSwimming(ped) and not IsPedClimbing(ped) and not IsPedDeadOrDying(ped, 1) and not IsPedRagdoll(ped) and not IsEntityPlayingAnim(ped, animation.lib, animation.base, 3) and not IsEntityPlayingAnim(ped, animation.lib, animation.enter, 3) and not IsEntityPlayingAnim(ped, animation.lib, animation.exit, 3) and not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
                if not exports['exile_trunk']:checkInTrunk() and not exports["esx_ambulancejob"]:isDead() then
                    if GetEntityModel(ped) == GetHashKey('hc_hacker') or GetEntityModel(ped) == GetHashKey('s_m_m_doctor_01') or GetEntityModel(ped) == GetHashKey('s_m_y_casino_01') or GetEntityModel(ped) == GetHashKey('s_m_y_pilot_01') or GetEntityModel(ped) == GetHashKey('s_m_y_barman_01') or GetEntityModel(ped) == GetHashKey('s_m_o_busker_01') or  GetEntityModel(ped) == GetHashKey('a_m_y_business_02') or GetEntityModel(ped) == GetHashKey('s_m_y_barman_01') or GetEntityModel(ped) == GetHashKey('mp_m_shopkeep_01') or GetEntityModel(ped) == GetHashKey('a_f_y_business_01') or GetEntityModel(ped) == GetHashKey('cs_solomon') or GetEntityModel(ped) == GetHashKey('csb_tomcasino') or GetEntityModel(ped) == GetHashKey('s_m_m_strpreach_01') or GetEntityModel(ped) == GetHashKey('s_m_m_paramedic_01') or GetEntityModel(ped) == GetHashKey('ig_casey') or GetEntityModel(ped) == GetHashKey('s_m_y_ammucity_01') then
                    else
                        local crds = GetEntityCoords(ped)
                        if #(GetEntityCoords(PlayerPedId()) - crds) > 11.5 then
                            goto powrot
                        end
                        GetControlOfEntity(ped)
                        TaskSetBlockingOfNonTemporaryEvents(ped, true)
                        TaskStandStill(ped, 500 * 1000)
                        RequestAnimDict(animation.lib)
                        while not HasAnimDictLoaded(animation.lib) do
                            Wait(10)
                        end
                        ClearPedTasksImmediately(ped)
                        TaskSetBlockingOfNonTemporaryEvents(ped, true)
                        TaskStandStill(ped, 500 * 1000)
                        SetEntityCollision(ped, true)
                        SetPedCombatAttributes(ped, 292, true)
                        TaskPlayAnim(ped, animation.lib, animation.enter, 8.0, 8.0, 1.0, 50, 0, 0, 0, 0)
                        CreateThread(function() 
                            while true do
                                Wait(5000)
                                if DoesEntityExist(ped) and IsEntityPlayingAnim(ped, animation.lib, animation.base, 3) or IsEntityPlayingAnim(ped, animation.lib, animation.enter, 3) or IsEntityPlayingAnim(ped, animation.lib, animation.exit, 3) then
                                    if not IsPlayerFreeAimingAtEntity(PlayerId(), ped) and not IsEntityPlayingAnim(entity, 'mp_arresting', 'idle', 3) then
                                        TaskSetBlockingOfNonTemporaryEvents(ped, false)
                                        SetPedCombatAttributes(ped, 292, false)
                                        SetEntityCollision(ped, false)
                                        ClearPedTasksImmediately(ped)
                                        Wait(100)
                                        TaskReactAndFleePed(ped, PlayerPedId())
                                    end    
                                else
                                    break
                                end    
                            end
                        end)
                    end
                end    
            end    
        end  
        ::powrot::  
    end    
end)   ]]