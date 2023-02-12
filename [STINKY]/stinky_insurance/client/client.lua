local sleep

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
end)

CreateThread(function()
	while true do
		Wait(5)
		sleep = true
		local coords = GetEntityCoords(PlayerPedId())
		for i, v in pairs (Config.Insurance) do
			local station = Config.Insurance[i]
			local dist = #(station.Pos - coords)
			if dist < 10.0 then
				ESX.DrawMarker(station.Pos)
				sleep = false
				if dist <= 1.5 then
					if station.Name == "Manage" then
						SetTextComponentFormat('STRING')
						AddTextComponentString("Naciśnij ~INPUT_CONTEXT~, aby nadać ubezpieczenie")
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					else
						SetTextComponentFormat('STRING')
						AddTextComponentString(_U('press_button'))
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					end
					if IsControlJustPressed(0, 38) then
						if IsPedInAnyVehicle(PlayerPedId()) then
						else
							MenuInsurance(station.Name)
						end
					end
				end
			end
		end
		if sleep then
			Wait(1000)
		end
	end
end)

function MenuInsurance(station)
	if station == 'NNW' or station == 'OC' then
		ESX.UI.Menu.CloseAll()
		ESX.TriggerServerCallback('exile_insurance:check', function(insTime)
			if insTime ~= nil  then
				ESX.ShowNotification(_U('ins_time', station, insTime))
			else
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'insurance_sell',
				{
					title    = _U('buy_ins', station),
					align    = 'center',
					elements = {
						{label = _U('3_days'),	value = 3},
						{label = _U('7_days'),	value = 7},
						{label = _U('14_days'),	value = 14},
						{label = _U('31_days'),	value = 31},
					}
				}, function(data, menu)
					TriggerServerEvent('exile_insurance:sell', station, data.current.value)
					menu.close()
				end,
				function(data, menu)
					menu.close()
				end
				)
			end
		end, station)
	else
		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'mechanik' and ESX.PlayerData.job.grade_name == 'boss') or (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss') or (ESX.PlayerData.job.name == 'gheneraugarage' and ESX.PlayerData.job.grade_name == 'boss') then
			MenuManageInsurance(ESX.PlayerData.job.name, ESX.PlayerData.job.grade_name)
		else
			ESX.ShowNotification('~r~Nie posiadasz dostępu do tego menu!')
		end
	end
end

MenuManageInsurance = function(job, grade)
	if (ESX.PlayerData.job.name == 'mechanik' and ESX.PlayerData.job.grade_name == 'boss') or (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss') or (ESX.PlayerData.job.name == 'gheneraugarage' and ESX.PlayerData.job.grade_name == 'boss') then
		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'insurance_menu2',
		{
			title    = "Ubezpieczenia firm",
			align    = 'center',
			elements = {
				{label = "Zarządzenie", value = 'manage'},
				{label = "Dodaj firmę do listy", value = 'add'},
			}
		}, function(data2, menu2)
			menu2.close()
			if data2.current.value == 'manage' then
				ESX.TriggerServerCallback('exile_insurance:getLicenses', function(licenses)
					if licenses then
						local elements = {
							head = {'Firma', 'OC', 'NNW', 'Akcje'},
							rows = {}
						}
						for i=1, #licenses, 1 do
							local jobInsurance = tostring(licenses[i].job_label)
							local oc = nil
							if licenses[i].oc == 0 then
								oc = '❌'
							elseif licenses[i].oc == 1 then
								oc = '✔️'
							end
							local nnw = nil
							if licenses[i].nnw == 0 then
								nnw = '❌'
							elseif licenses[i].nnw == 1 then
								nnw = '✔️'
							end

							table.insert(elements.rows, {
								data = licenses[i],
								cols = {
									licenses[i].job_label,
									oc,
									nnw,
									'{{' .. "Nadaj ubezpieczenie" .. '|set}} {{' .. "Zabierz" .. '|remove}}'
								}
							})
						end
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'insurancesManage', elements, function(data, menu)
							if data.value == 'set' then
								if ESX.PlayerData.job.name == 'mechanik' then
									if data.data.oc == 1 then
										ESX.ShowNotification('~r~Ta firma posiada już ubezpieczenie OC')
									else
										TriggerServerEvent('exile_insurance:setInsurance', 'SET', 'oc', data.data.name)
										ESX.ShowNotification("Pomyślnie ~g~nadano ~w~ubezpieczenie OC firmie " .. data.data.job_label)
									end
								elseif ESX.PlayerData.job.name == 'ambulance' then
									if data.data.nnw == 1 then
										ESX.ShowNotification('~r~Ta firma posiada już ubezpieczenie NNW')
									else
										TriggerServerEvent('exile_insurance:setInsurance', 'SET', 'nnw', data.data.name)
										ESX.ShowNotification("Pomyślnie ~g~nadano ~w~ubezpieczenie NNW firmie " .. data.data.job_label)
									end
								elseif ESX.PlayerData.job.name == 'gheneraugarage' then
									if data.data.oc == 1 then
										ESX.ShowNotification('~r~Ta firma posiada już ubezpieczenie OC')
									else
										TriggerServerEvent('exile_insurance:setInsurance', 'SET', 'oc', data.data.name)
										ESX.ShowNotification("Pomyślnie ~g~nadano ~w~ubezpieczenie OC firmie " .. data.data.job_label)
									end
								end
							elseif data.value == 'remove' then
								if ESX.PlayerData.job.name == 'mechanik' then
									if data.data.oc == 0 then
										ESX.ShowNotification('~r~Ta firma nie posiada ubezpieczenia OC')
									else
										TriggerServerEvent('exile_insurance:setInsurance', 'REMOVE', 'oc', data.data.name)
										ESX.ShowNotification("Pomyślnie ~r~zabrano ~w~ubezpieczenie OC firmie " .. data.data.job_label)
									end
								elseif ESX.PlayerData.job.name == 'ambulance' then
									if data.data.nnw == 0 then
										ESX.ShowNotification('~r~Ta firma nie posiada ubezpieczenia NNW')
									else
										TriggerServerEvent('exile_insurance:setInsurance', 'REMOVE', 'nnw', data.data.name)
										ESX.ShowNotification("Pomyślnie ~r~zabrano ~w~ubezpieczenie NNW firmie " .. data.data.job_label)
									end
								elseif ESX.PlayerData.job.name == 'gheneraugarage' then
									if data.data.oc == 0 then
										ESX.ShowNotification('~r~Ta firma nie posiada ubezpieczenia OC')
									else
										TriggerServerEvent('exile_insurance:setInsurance', 'REMOVE', 'oc', data.data.name)
										ESX.ShowNotification("Pomyślnie ~r~zabrano ~w~ubezpieczenie OC firmie " .. data.data.job_label)
									end
								end
							end
							menu.close()
						end, function(data, menu)
							menu.close()
						end)
					else
						ESX.ShowNotification("~r~Lista jest pusta, musisz dodać nową pracę do listy!")
					end
				end)
			elseif data2.current.value == 'add' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nazwa_ubioru', {
					title = ('Wprowadź nazwę pracy (np. police)')
				}, function(data3, menu3)
					menu3.close()
					local job_name = data3.value
					if job_name ~= nil then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nazwa_ubioru', {
							title = ('Wprowadź nazwę firmy (np. SASP)')
						}, function(data4, menu4)
							menu4.close()
							local job_label = data4.value
							if job_label ~= nil then
								TriggerServerEvent('exile_insurance:addInsurance', job_name, job_label)
							else
								ESX.ShowNotification("~r~Podana nazawa firmy jest niepoprawna!")
							end
		
						end, function(data4, menu4)
							menu4.close()
						end)
					else
						ESX.ShowNotification('~r~Podana nazwa pracy jest niepoprawna!')
					end

				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	else
		ESX.ShowNotification("~r~Nie masz dostępu do tego menu!")
	end
end

--[[local hinhi
local workers


ESX.TriggerServerCallback('exile_legaljobs:getLicenses', function(licencje)
	hinhi = licencje.level
end, licenses[i].name)
ESX.TriggerServerCallback('society:countMembers', function(all)
	workers = all
end, licenses[i].name)

local limitworkers = exports['exile_legaljobs']:GetLimits(hinhi)]]
