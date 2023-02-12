CreateThread(function ()
    while true do
        for _, nearPeds in pairs(GetGamePool('CPed')) do
            Wait(100)
            local model = GetEntityModel(nearPeds)

            if model == `u_m_y_zombie_01` or model == `s_m_m_movalien_01` then
                RequestAnimSet('move_m@drunk@verydrunk')
                while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
                    Citizen.Wait(0)
                end

                SetPedRagdollBlockingFlags(nearPeds, 1)
                SetPedCanRagdollFromPlayerImpact(nearPeds, false)
                SetPedEnableWeaponBlocking(nearPeds, true)
                DisablePedPainAudio(nearPeds, true)
                StopPedSpeaking(nearPeds, true)
                SetPedDiesWhenInjured(nearPeds, false)
                StopPedRingtone(nearPeds)
                SetPedMute(nearPeds)
                SetPedIsDrunk(nearPeds, true)
                SetPedConfigFlag(nearPeds, 166, false)
                SetPedConfigFlag(nearPeds, 170, false)
                SetBlockingOfNonTemporaryEvents(nearPeds, true)
                SetPedCanEvasiveDive(nearPeds, false)
                RemoveAllPedWeapons(nearPeds, true)

                SetPedMovementClipset(nearPeds, 'move_m@drunk@verydrunk', 1.0)


                SetPedConfigFlag(nearPeds, 100, false)
                TaskWanderStandard(nearPeds, 10.0, 10)
                if model == `s_m_m_movalien_01` then
                    SetEntityMaxHealth(nearPeds, 650)
                    SetEntityHealth(nearPeds, 650)
                elseif model == `u_m_y_zombie_01` then
                    SetEntityMaxHealth(nearPeds, 350)
                    SetEntityHealth(nearPeds, 350)
                end
                SetPedSuffersCriticalHits(nearPeds, false)


                if (#(GetEntityCoords(nearPeds) - GetEntityCoords(PlayerPedId()))) <= 1.3 then
                    if not IsPedRagdoll(nearPeds) and not IsPedGettingUp(nearPeds) and GetEntityHealth(nearPeds) > 100 then
                        RequestAnimSet('melee@unarmed@streamed_core_fps')
                        while not HasAnimSetLoaded('melee@unarmed@streamed_core_fps') do
                            Citizen.Wait(10)
                        end

                        TaskPlayAnim(nearPeds, 'melee@unarmed@streamed_core_fps', 'ground_attack_0_psycho', 8.0, 1.0, -1, 48, 0.001, false, false, false)

                        ApplyDamageToPed(PlayerPedId(), 200, false)
                    end
                end

                -- if (#(GetEntityCoords(nearPeds) - GetEntityCoords(PlayerPedId()))) <= 30.0 then
                --     TaskGoToEntity(nearPeds, PlayerPedId(), -1, 0.0, 2.0, 1073741824, 0)
                -- else
                --     SetPedMovementClipset(nearPeds, 'move_m@drunk@verydrunk', 1.0)
                -- end
            end
        end
        Wait(0)
    end
end)

