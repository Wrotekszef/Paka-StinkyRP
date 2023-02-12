local level = 0
local workers = 0
local levelsecond = 0
local workerssecond = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
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

local playerPed = PlayerPedId()
local playerId = PlayerId()

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerId = PlayerId()
        Wait(500)
    end
end)

function OpenBossMenu(society, close, options, extras)	
	ESX.TriggerServerCallback('stinky_legaljobs:getLicenses', function(licenses)
		level = licenses.level
	end, society)
	ESX.TriggerServerCallback('society:countMembers', function(all)
		workers = all
	end, society)
	local options = options or {}
	
	if options.withdraw ~= nil and options.showmoney == nil then
		options.withdraw = options.withdraw
	end
	
	for k,v in pairs({
		showmoney = true,
		withdraw = true,
		deposit = true,
		employees = true,
		dirty = false,
		wash = false,
		badges = false,
		licenses  = false,
		grades = false	
	}) do
		if options[k] == nil then
			options[k] = v
		end
	end
	
	local elements = {}

	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getSocietyMoney', function(money)
		if options.showmoney then
			table.insert(elements, {label = 'Stan konta frakcji: <span style="color:limegreen;">'..money..'$', value = 'none'})
			table.insert(elements, {label = "Webhooki", value = "webhooki"})
		end

		if options.withdraw then
			table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
		end

		if options.deposit then
			table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
		end

		if options.wash then
			table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
		end

		if options.employees then
			table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
		end

		if options.grades then
			table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
		end

		if (society == 'mechanik' and (ESX.PlayerData.job.name == 'mechanik' and ESX.PlayerData.job.grade >= 6))
		or (society == 'gheneraugarage' and (ESX.PlayerData.job.name == 'gheneraugarage' and ESX.PlayerData.job.grade >= 6))
		or (society == 'police' and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 9))
		or (society == 'ambulance' and (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade >= 9))
		or (society == 'sheriff' and (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11)
		or (society == 'cardealer' and (ESX.PlayerData.job.name == 'cardealer' and ESX.PlayerData.job.grade >= 3)))
	 	then
			table.insert(elements, {label = 'Lista pracowników na służbie', value = 'duty_list'})
			table.insert(elements, {label = 'Wyzeruj wszystkie godziny', value = 'reset_allh'})
		end

		if (society == 'police' and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade >= 11)) then
			table.insert(elements, {label = 'Highway Patrol', value = 'manage_hwp'})
		end

		if (society == 'sheriff' and (ESX.PlayerData.job.name == 'sheriff' and ESX.PlayerData.job.grade >= 11)) then
			table.insert(elements, {label = 'Highway Patrol', value = 'manage_hwp'})
		end

		if extras and extras.main then
			for _, extra in ipairs(extras.main) do
				table.insert(elements, {label = extra.name, value = 'extra', event = extra.event, eventValue = extra.value})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society,
		{
			title    = _U('boss_menu'),
			align    = 'center',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'extra' then
				TriggerEvent(data.current.event, menu, data.current.eventValue) 
			elseif data.current.value == 'withdraw_society_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
					title = _U('withdraw_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('exilerp_scripts:withdrawMoney', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'reset_allh' then
				TriggerServerEvent('esxexile_societyrpexileesocietybig:reset_allh')
				ESX.ShowNotification('~o~Zresetowano wszystkim godziny (efekty po restarcie)')
			elseif data.current.value == 'duty_list' then
				OpenDutyListMenu(society)
			elseif data.current.value == 'manage_hwp' then
				TriggerEvent('esxexile_societyrpexileesocietybig:openLicenseBossMenu', 'hp', 100, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			elseif data.current.value == 'manage_dtu' then
				TriggerEvent('esxexile_societyrpexileesocietybig:openLicenseBossMenu', 'dtu', 100, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			elseif data.current.value == 'manage_swat' then
				TriggerEvent('esxexile_societyrpexileesocietybig:openLicenseBossMenu', 'swat', 100, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			elseif data.current.value == 'deposit_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society,
				{
					title = _U('deposit_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('exilerp_scripts:depositMoney', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)

			elseif data.current.value == 'wash_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society,
				{
					title = _U('wash_money_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('exilerp_scripts:washMoney', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'manage_employees' then
				OpenManageEmployeesMenu(society, options.licenses)
			elseif data.current.value == 'manage_grades' then
				OpenManageGradesMenu(society)
			elseif data.current.value == 'webhooki' then
				OpenFirstWebhookMenu()
			end

		end, function(data, menu)
			if close then
				close(data, menu)
			end
		end)
	end, society)
end

function OpenDutyListMenu(society) 
	ESX.TriggerServerCallback('exilerp_scripts:societyDutyList', function(list)
		ESX.UI.Menu.CloseAll()
		local elements = {}
		local workers6 = {}
		for i,v in ipairs(list) do
			local ii = #elements
			table.insert(elements, {label = v[1], value = ii+1})
			table.insert(workers6, v)
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(),society.."_dutylist",
		{ 
		title = "Pracownicy na służbie", 
		align = "center", 
		elements = elements 
		}, function(data, menu)
			-- local worker = workers6[data.current.value]
			-- ESX.ShowNotification('Wyrzucono ze służby '..worker[2][3])
			-- TriggerServerEvent("exilerp_scripts:kickFromDuty", worker[2][1], society, worker[2][2])
			-- menu.close()
		end, function(data, menu) 
		menu.close() 
		end)
	end, society)
end

function OpenManageEmployeesMenu(society, licenses)
	local limitworkers = exports['stinky_legaljobs']:GetLimits(level)
	local elements = {
		{label = "Zrekrutuj",       value = 'recruit'},
		{label = "Zarządzaj pracownikami", value = 'employee_list'},
	}
	
	if limitworkers ~= nil then
		table.insert(elements, {label = "Zatrudnionych: "..workers.." / "..limitworkers, value = nil})
	end
	
	if licenses then
		table.insert(elements, {label = "Zarządzaj licencjami", value = 'licenses'})
	end

	if society == 'police' or society == 'sheriff' or society == 'ambulance' or society == 'fire' or society == 'mechanik' or society == 'doj' or society == 'psycholog' or society == 'dtu' or society == 'gheneraugarage' then
		table.insert(elements, {label = "Przelej premię", value = 'give_money'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
			ESX.UI.Menu.CloseAll()
		end

		if data.current.value == 'recruit' then
			for i=1, #Config.LegalJobsList, 1 do
				if society == Config.LegalJobsList[i] then
					ESX.TriggerServerCallback('stinky_legaljobs:getLicenses', function(licenses)
						level = licenses.level
						OpenRecruitMenu(society, level, true)
					end, society)
					break
				else
					OpenRecruitMenu(society, level, false)
				end
			end
		end

		if data.current.value == 'licenses' then
			OpenLicensesMenu(society)
			ESX.UI.Menu.CloseAll()
		end

		if data.current.value == 'give_money' then
			OpenGiveMoneyMenu(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenGiveMoneyMenu(society)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	local elements = {}
	local serverIds = {}
	
	for k,v in ipairs(players) do
		if v ~= playerId then
			table.insert(serverIds, GetPlayerServerId(v))
		end
	end
	
	ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames", function(identities)
		for k,v in pairs(identities) do
			table.insert(elements, {
				player = k,
				label = v
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'obywatele_obok',
		{
			title = "Wybierz obywatela",
			align = 'center',
			elements = elements,
		},
		function(data, menu)
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'give_money', {
				title    = "Ile pieniędzy chcesz przelać?",
				align    = 'center'
			}, function(data2, menu2)
				menu2.close()
				TriggerServerEvent('esxexile_societyrpexileesocietybig:giveMoney', data.current.player, society, data2.value)
				Wait(300)
				OpenGiveMoneyMenu(society)
			end, function(data2, menu2)
				menu2.close()
				OpenGiveMoneyMenu(society)
			end)
		end,
		function(data, menu)
			menu.close()
		end)	
	end, serverIds)
end

function OpenGiveLicenseMenu(employee, society)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give', {
		title    = 'Jaką licencję chcesz nadać?',
		align    = 'center',
		elements = employee.available
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esxexile_societyrpexileesocietybig:giveLicense', employee, data.current.value)
		Wait(500)
		OpenLicensesMenu(society)
	end, function(data, menu)
		menu.close()
		OpenLicensesMenu(society)
	end)
end

function OpenGetLicenseMenu(employee, society)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give', {
		title    = 'Jaką licencję chcesz odebrać?',
		align    = 'center',
		elements = employee.owned
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esxexile_societyrpexileesocietybig:getLicense', employee, data.current.value)
		Wait(500)
		OpenLicensesMenu(society)
	end, function(data, menu)
		menu.close()
		OpenLicensesMenu(society)
		
	end)
end

function OpenLicensesMenu(society)
	ESX.TriggerServerCallback('exilerp_scripts:showLicense', function(employees)
		local elements = {
			head = {"Pracownik", "TD", "HC", "SEU", "SWAT", "DTU", "HELI", "SWIM", "AIAD", "HP", "Akcje"},
			rows = {}
		}
		
		for i=1, #employees, 1 do
			local td = '❌'
			local hc = '❌'
			local seu = '❌'
			local swat = '❌'
			local dtu = '❌'
			local heli = '❌'
			local nurek = '❌'
			local aiad = '❌'
			local hp = '❌'
			local available = {}
			local owned = {}
			for j=1, #employees[i].licenses, 1 do
				local license = employees[i].licenses[j]
				if license.name == 'td' then
					td = '✔️'
					table.insert(owned, {label = "Licencja TD", value = 'td'})
				elseif license.name == 'hc' then
					hc = '✔️'
					table.insert(owned, {label = "Licencja HC", value = 'hc'})
				elseif license.name == 'seu' then
					seu = '✔️'
					table.insert(owned, {label = "Licencja SEU", value = 'seu'})
				elseif license.name == 'swat' then
					swat = '✔️'
					table.insert(owned, {label = "Licencja SWAT", value = 'swat'})
				elseif license.name == 'dtu' then
					dtu = '✔️'
					table.insert(owned, {label = "Licencja DTU", value = 'dtu'})
				elseif license.name == 'heli' then
					heli = '✔️'
					table.insert(owned, {label = "Licencja HELI", value = 'heli'})
				elseif license.name == 'nurek' then
					nurek = '✔️'
					table.insert(owned, {label = "Licencja SWIM", value = 'nurek'})
				elseif license.name == 'aiad' then
					aiad = '✔️'
					table.insert(owned, {label = "Licencja AIAD", value = 'aiad'})
				elseif license.name == 'hp' then
					hp = '✔️'
					table.insert(owned, {label = "Licencja HP", value = 'hp'})
				end
			end
			if td == '❌' then
				table.insert(available, {label = "Licencja TD", value = 'td'})
			end
			if hc == '❌' then
				table.insert(available, {label = "Licencja HC", value = 'hc'})
			end
			if seu == '❌' then
				table.insert(available, {label = "Licencja SEU", value = 'seu'})
			end
			if swat == '❌' then
				table.insert(available, {label = "Licencja SWAT", value = 'swat'})
			end
			if dtu == '❌' then
				table.insert(available, {label = "Licencja DTU", value = 'dtu'})
			end
			if heli == '❌' then
				table.insert(available, {label = "Licencja HELI", value = 'heli'})
			end
			if nurek == '❌' then
				table.insert(available, {label = "Licencja SWIM", value = 'nurek'})
			end
			if aiad == '❌' then
				table.insert(available, {label = "Licencja AIAD", value = 'aiad'})
			end
			if hp == '❌' then
				table.insert(available, {label = "Licencja HP", value = 'hp'})
			end
			employees[i].owned = owned
			employees[i].available = available
			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					td,
					hc,
					seu,
					swat,
					dtu,
					heli,
					nurek,
					aiad,
					hp,
					'{{' .. "Nadaj licencję" .. '|give}} {{' .. "Odbierz licencję" .. '|get}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data
			if data.value == 'give' then
				OpenGiveLicenseMenu(employee, society)
			elseif data.value == 'get' then
				OpenGetLicenseMenu(employee, society)
			end			
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenEmployeeList(society)
	ESX.TriggerServerCallback('exilerp_scripts:showWorker', function(employees)	
	
		local elements = nil
		
		if (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'fire' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'doj' or ESX.PlayerData.job.name == 'psycholog' or ESX.PlayerData.job.name == 'dtu' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'cardealer' ) then
			elements = {
				head = {_U('employee'), _U('grade'), 'Odznaka', 'Godziny', _U('actions')},
				rows = {}
			}		
		end

		if (ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'fire' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'doj' or ESX.PlayerData.job.name == 'psycholog' or ESX.PlayerData.job.name == 'dtu' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'cardealer' ) then
			for i=1, #employees, 1 do
				local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

				local numer = employees[i].badge.number

				local gradeBadge = (tostring(numer))
				local czasufka = string.format("%.02f", employees[i].time) 

				if employees[i].badge.number == 0 then
					gradeBadge = 'Brak Odznaki'
				end
				
				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						gradeLabel,
						gradeBadge,
						czasufka.."H",
						'{{Odznaka |odznaka}} {{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}} {{Zeruj Godziny|clearhours}}'
					}
				})
			end
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'odznaka' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'odznaki', {
					title = 'Numer Odznaki'
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil or amount < 1 then
						ESX.ShowNotification('Niepoprawny numer!')
					else
						menu2.close()
						TriggerServerEvent('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyBadgesOnPoliceSide', employee, amount)
						Wait(200)
						OpenBossMenu(society)
					end
				end, function(data2, menu2)
					menu2.close()			
				end)				
			elseif data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyAddoneedsJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			elseif data.value == 'clearhours' then
				TriggerServerEvent('esxexile_societyrpexileesocietybig:clearhours', employee.identifier)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenRecruitMenu(society, level, custom)
	if custom then
		ESX.TriggerServerCallback('society:countMembers', function(all)
			if all >= exports['stinky_legaljobs']:GetLimits(level) then
				if tonumber(level) == 10 then
					ESX.ShowNotification('~r~Twoja firma posiada już maksymalny poziom i maksymalną ilość członków')
				else
					ESX.UI.Menu.CloseAll()
					ESX.ShowNotification('~r~Aby zatrudnić więcej osób musisz podnieść poziom firmy')
				end
			else
				local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
				if json.encode(players) ~= '[]' then
					local elements = {}
					local serverIds = {}
					
					for k,v in ipairs(players) do
						if v ~= playerId then
							table.insert(serverIds, GetPlayerServerId(v))
						end
					end
					
					ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames",function(identities)
						for k,v in pairs(identities) do
							table.insert(elements, {
								player = k,
								label = v
							})
						end		
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'special_cop_menu',
						{
							title = _U('recruiting'),
							align = 'center',
							elements = elements,
						},
						function(data, menu)
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
								title    = _U('do_you_want_to_recruit', data.current.label),
								align    = 'center',
								elements = {
									{label = _U('no'),  value = 'no'},
									{label = _U('yes'), value = 'yes'}
								}
							}, function(data2, menu2)
								menu2.close()

								if data2.current.value == 'yes' then
									ESX.ShowNotification(_U('you_have_hired', data.current.label))
									ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyAddoneedsJob', function()
										OpenRecruitMenu(society, level, custom)
									end, data.current.player, society, 0, 'hire', ESX.PlayerData.job.name, society)
								end
							end, function(data2, menu2)
								menu2.close()
							end)
						end,
						function(data, menu)
							menu.close()
						end)	
					end, serverIds)
				else
					ESX.ShowNotification('~r~Brak graczy w pobliżu!')
				end
			end
		end, society)
	else
		local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
		if json.encode(players) ~= '[]' then
			local elements = {}
			local serverIds = {}
			
			for k,v in ipairs(players) do
				if v ~= playerId then
					table.insert(serverIds, GetPlayerServerId(v))
				end
			end
			
			ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames",function(identities)
				for k,v in pairs(identities) do
					table.insert(elements, {
						player = k,
						label = v
					})
				end		
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'special_cop_menu',
				{
					title = _U('recruiting'),
					align = 'center',
					elements = elements,
				},
				function(data, menu)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
						title    = _U('do_you_want_to_recruit', data.current.label),
						align    = 'center',
						elements = {
							{label = _U('no'),  value = 'no'},
							{label = _U('yes'), value = 'yes'}
						}
					}, function(data2, menu2)
						menu2.close()

						if data2.current.value == 'yes' then
							ESX.ShowNotification(_U('you_have_hired', data.current.label))
							ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyAddoneedsJob', function()
								OpenRecruitMenu(society, level, custom)
							end, data.current.player, society, 0, 'hire', ESX.PlayerData.job.name, society)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end,
				function(data, menu)
					menu.close()
				end)	
			end, serverIds)
		else
			ESX.ShowNotification('~r~Brak graczy w pobliżu!')
		end
	end
end

function OpenPromoteMenu(society, employee)

	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getJob', function(job)

		local elements = {}
		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			if ESX.PlayerData.job.grade >= job.grades[i].grade then
				table.insert(elements, {
					label = gradeLabel,
					value = job.grades[i].grade,
					selected = (employee.job.grade == job.grades[i].grade)
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyAddoneedsJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

function OpenManageGradesMenu(society)

	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = _U('salary_management'),
			align    = 'center',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = _U('salary_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyAddoneedsJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

AddEventHandler('esxexile_societyrpexileesocietybig:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

function OpenThirdBossMenu(society, level, close, options)
	local options  = options or {}
	local elements = {}
	
	local fractionAccount = 0
    local moneyLoaded = false

	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getSocietyMoney', function(money)
		fractionAccount = money
		moneyLoaded = true
	end, society)

	while not moneyLoaded do
		Wait(100)
	end

	local defaultOptions = {
		showmoney = false,
		withdraw  = false,
		deposit   = true,
		wash      = false,
		employees = false,
		grades    = false
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.showmoney then
		table.insert(elements, {label = ('Saldo: '..fractionAccount..'$'), value = 'none'})
	end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.wash then
		table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('exilerp_scripts:withdrawThirdMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('exilerp_scripts:depositThirdMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'wash_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society, {
				title = _U('wash_money_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esxexile_societyrpexileesocietybig:washThirdMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'manage_employees' then
			OpenThirdManageEmployeesMenu(society, level)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenThirdManageEmployeesMenu(society, level)
	ESX.TriggerServerCallback('society:countHiddenMembers', function(all)
		local maxCount = tonumber(level) * 5

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
			title    = _U('employee_management'),
			align    = 'center',
			elements = {
				{label = _U('employee_list') .. ' <span style="color: #add8e6;">' .. all .. '/' .. maxCount .. '</span>', value = 'employee_list'},
				{label = _U('recruit'),       value = 'recruit'}
			}
		}, function(data, menu)

			if data.current.value == 'employee_list' then
				OpenThirdEmployeeList(society, level)
				ESX.UI.Menu.CloseAll()
			end

			if data.current.value == 'recruit' then
				OpenThirdRecruitMenu(society, level)
			end

		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenThirdEmployeeList(society, level)
	ESX.TriggerServerCallback('exilerp_scripts:showThirdWorker', function(employees)
		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].thirdjob.grade_label == '' and employees[i].thirdjob.label or employees[i].thirdjob.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenThirdPromoteMenu(society, employee, level)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyThirdJob', function()
					OpenThirdEmployeeList(society, level)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenThirdManageEmployeesMenu(society, level)
		end)

	end, society)

end

function OpenThirdRecruitMenu(society, level)
	ESX.TriggerServerCallback('society:countMembers', function(all)
		if all >= (tonumber(level) * 5) then
			if tonumber(level) == 20 then
				ESX.ShowNotification('~r~Twoja organizacja posiada już maksymalny poziom i maksymalną ilość członków')
			else
				ESX.ShowNotification('~r~Aby zatrudnić więcej osób musisz podnieść poziom organizacji')
			end
		else
			local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 5.0)
			if json.encode(players) ~= '[]' then
				local elements = {}
				local serverIds = {}

				for k,v in ipairs(players) do
					if v ~= playerId then
						table.insert(serverIds, GetPlayerServerId(v))
					end
				end
				ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames",function(identities)
					for k,v in pairs(identities) do
						table.insert(elements, {
							player = k,
							label = v
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
						title    = _U('recruiting'),
						align    = 'center',
						elements = elements
					}, function(data, menu)

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
							title    = _U('do_you_want_to_recruit', data.current.label),
							align    = 'center',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
							}
						}, function(data2, menu2)
							menu2.close()

							if data2.current.value == 'yes' then
								ESX.ShowNotification(_U('you_have_hired', data.current.label))

								ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyThirdJob', function()
									OpenThirdRecruitMenu(society, level)
								end, data.current.player, society, 0, 'hire')
							end
						end, function(data2, menu2)
							menu2.close()
						end)

					end, function(data, menu)
						menu.close()
					end)

				end, serverIds)
			else
				ESX.ShowNotification('~r~Brak graczy w pobliżu!')
			end
		end
	end, society)
end

function OpenThirdPromoteMenu(society, employee, level)

	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.thirdjob.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyThirdJob', function()
				OpenThirdEmployeeList(society, level)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenThirdEmployeeList(society, level)
		end)

	end, society)
end



function OpenLicenseBossMenu(society, level, close, options)
	local options  = options or {}
	local elements = {}

	local defaultOptions = {
		showmoney = false,
		withdraw  = false,
		deposit   = true,
		wash      = false,
		employees = false,
		grades    = false
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'manage_employees' then
			OpenLicenseManageEmployeesMenu(society, level)
		end
	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenLicenseManageEmployeesMenu(society, level)
	ESX.TriggerServerCallback('society:countLicenseMembers', function(all)
		local maxCount = tonumber(level) * 5

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
			title    = _U('employee_management'),
			align    = 'center',
			elements = {
				{label = _U('employee_list') .. ' <span style="color: #add8e6;">' .. all .. '/' .. maxCount .. '</span>', value = 'employee_list'},
				{label = _U('recruit'),       value = 'recruit'}
			}
		}, function(data, menu)

			if data.current.value == 'employee_list' then
				OpenLicenseEmployeeList(society, level)
			end

			if data.current.value == 'recruit' then
				OpenLicenseRecruitMenu(society, level)
			end

		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenLicenseEmployeeList(society, level)
	ESX.TriggerServerCallback('exilerp_scripts:showLicenseMember', function(employees)
		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}
		for i=1, #employees, 1 do
			-- local gradeLabel = (employees[i].thirdjob.grade_label == '' and employees[i].thirdjob.label or employees[i].thirdjob.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					employees[i].hiddenjob.grade_label,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenLicensePromoteMenu(society, employee, level)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyLicenseJob', function()
					OpenLicenseEmployeeList(society, level)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenLicenseManageEmployeesMenu(society, level)
		end)

	end, society)

end

function OpenLicenseRecruitMenu(society, level)
	ESX.TriggerServerCallback('society:countMembers', function(all)
		local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 5.0)
		if json.encode(players) ~= '[]' then
			local elements = {}
			local serverIds = {}

			for k,v in ipairs(players) do
				if v ~= playerId then
					table.insert(serverIds, GetPlayerServerId(v))
				end
			end
			ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames",function(identities)
				for k,v in pairs(identities) do
					table.insert(elements, {
						player = k,
						label = v
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
					title    = _U('recruiting'),
					align    = 'center',
					elements = elements
				}, function(data, menu)

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
						title    = _U('do_you_want_to_recruit', data.current.label),
						align    = 'center',
						elements = {
							{label = _U('no'),  value = 'no'},
							{label = _U('yes'), value = 'yes'}
						}
					}, function(data2, menu2)
						menu2.close()

						if data2.current.value == 'yes' then
							ESX.ShowNotification(_U('you_have_hired', data.current.label))

							ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietyLicenseJob', function()
								OpenLicenseRecruitMenu(society, level)
							end, data.current.player, society, 0, 'hire')
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				end, function(data, menu)
					menu.close()
				end)

			end, serverIds)
		else
			ESX.ShowNotification('~r~Brak graczy w pobliżu!')
		end
	end, society)
end





function OpenLicensePromoteMenu(society, employee, level)

	local elements = { }

	if(society == 'hp') then 
		grades = { 
			"Probie Officer",
			"Officer",
			"Sergeant",
			"Lieutenant",
			"Captain",
			"Commander",
			"Deputy Chief",
			"Chief"
		}
	elseif(society == 'swat') then 
		grades = {
			"Probie Operator",
			"Operator",
			"Advanced Operator",
			"Team Leader",
			"Deputy Chief",
			"Chief"
		}

	elseif(society == 'dtu') then
		grades = {
			"Probie Detective",
			"Detective",
			"Commander"
		}
	end

	for k,v in pairs(grades) do 

		table.insert(elements, {
			label = v,
			value = k,
			selected = ('CHUJ')
		})
	end

	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
		title    = _U('promote_employee', employee.name),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

		TriggerServerEvent('exilerp_scripts:awansLicense', employee.identifier)
		menu.close()
		OpenLicenseEmployeeList(society, level)
	end)

end

function OpenSecondBossMenu(society, close, options, extras)	
	ESX.TriggerServerCallback('stinky_legaljobs:getLicenses', function(licenses)
		levelsecond = licenses.level
	end, society)

	ESX.TriggerServerCallback('society:countMembers', function(all)
		workerssecond = all
	end, society)

	local options = options or {}
	
	if options.withdraw ~= nil and options.showmoney == nil then
		options.withdraw = options.withdraw
	end
	
	for k,v in pairs({
		showmoney = true,
		withdraw = true,
		deposit = true,
		employees = true,
		dirty = false,
		wash = false,
		badges = false,
		licenses  = false,
		grades = false	
	}) do
		if options[k] == nil then
			options[k] = v
		end
	end
	
	local elements = {}
	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getSocietyMoney', function(money)
		if options.showmoney then
			table.insert(elements, {label = 'Stan konta firmy: <span style="color:limegreen;">'..money..'$', value = 'none'})
			table.insert(elements, {label = 'Webhooki', value = 'webhooki'})
		end

		if options.withdraw then
			table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
		end

		if options.deposit then
			table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
		end

		if options.wash then
			table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
		end

		if options.employees then
			table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
		end

		if options.grades then
			table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
		end

		if extras and extras.main then
			for _, extra in ipairs(extras.main) do
				table.insert(elements, {label = extra.name, value = 'extra', event = extra.event, eventValue = extra.value})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society,
		{
			title    = _U('boss_menu'),
			align    = 'center',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'extra' then
				TriggerEvent(data.current.event, menu, data.current.eventValue)
			elseif data.current.value == 'withdraw_society_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
					title = _U('withdraw_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('exilerp_scripts:withdrawSecondMoney', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'webhooki' then
				OpenWebhookMenu()
			elseif data.current.value == 'deposit_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society,
				{
					title = _U('deposit_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('exilerp_scripts:depositSecondMoney', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)

			elseif data.current.value == 'wash_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society,
				{
					title = _U('wash_money_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('exilerp_scripts:washSecondMoney', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'manage_employees' then
				OpenSecondManageEmployeesMenu(society, options.licenses)
			elseif data.current.value == 'manage_grades' then
				OpenManageGradesMenu(society)
			end

		end, function(data, menu)
			if close then
				close(data, menu)
			end
		end)
	end, society)
end

OpenFirstWebhookMenu = function ()
	local src = source
	local elements = {
		{label = 'Sprawdź webhook', value = 'webhookcheck'},
		{label = 'Ustaw webhook', value = 'webhookadd'},
		{label = 'Zresetuj webhook', value = 'webhookreset'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_webhook', {
		title    = 'Webhook',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'webhookcheck' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esxexile_societyrpexileesocietybig:webhookcheck1')
		elseif data.current.value == 'webhookadd' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_webhook_name', {
				title = 'Link twojego webhooka'
			}, function(data2, menu2)
				if(string.find(data2.value, "https://discord.com/api/webhooks/")) then
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('esxexile_societyrpexileesocietybig:webhookadd1', data2.value)
					ESX.ShowAdvancedNotification('~o~StinkyRP', 'Firmy', '~b~Webhook został pomyślnie ustawiony!')
				else
					ESX.ShowAdvancedNotification('~o~StinkyRP', 'Firmy', '~b~Webhook nie został ustawiony, wprowadź prawidłowe dane!')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'webhookreset' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esxexile_societyrpexileesocietybig:webhookreset1')
			ESX.ShowAdvancedNotification('~o~StinkyRP', 'Firmy', '~b~Webhook został pomyślnie zresetowany!')
		end
	end, function(data, menu)
		menu.close()
	end)
end

OpenWebhookMenu = function ()
	local src = source
	local elements = {
		{label = 'Sprawdź webhook', value = 'webhookcheck'},
		{label = 'Ustaw webhook', value = 'webhookadd'},
		{label = 'Zresetuj webhook', value = 'webhookreset'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_webhook', {
		title    = 'Webhook',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'webhookcheck' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esxexile_societyrpexileesocietybig:webhookcheck')
		elseif data.current.value == 'webhookadd' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_webhook_name', {
				title = 'Link twojego webhooka'
			}, function(data2, menu2)
				if(string.find(data2.value, "https://discord.com/api/webhooks/")) then
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('esxexile_societyrpexileesocietybig:webhookadd', data2.value)
					ESX.ShowAdvancedNotification('~o~StinkyRP', 'Firmy', '~b~Webhook został pomyślnie ustawiony!')
				else
					ESX.ShowAdvancedNotification('~o~StinkyRP', 'Firmy', '~b~Webhook nie został ustawiony, wprowadź prawidłowe dane!')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'webhookreset' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esxexile_societyrpexileesocietybig:webhookreset')
			ESX.ShowAdvancedNotification('~o~StinkyRP', 'Firmy', '~b~Webhook został pomyślnie zresetowany!')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenSecondManageEmployeesMenu(society, licenses)
	local limitworkers = exports['stinky_legaljobs']:GetLimits(levelsecond)
	local elements = {
		{label = "Zrekrutuj",       value = 'recruit'},
		{label = "Zarządzaj pracownikami", value = 'employee_list'},
	}
	
	if limitworkers ~= nil then
		table.insert(elements, {label = "Zeruj wszystkie kursy tymczasowe", value = 'zeruj_kursy'})
		table.insert(elements, {label = "Zatrudnionych: "..workerssecond.." / "..limitworkers, value = nil})
	end

	if society == 'baker' or society == 'burgershot' or society == 'cardealer' or society == 'courier' or society == 'miner'
	or society == 'farming' or society == 'fisherman' or society == 'grower' or society == 'krawiec' or society == 'milkman'
	or society == 'pizzeria' or society == 'rafiner' or society == 'slaughter' or society == 'taxi' or society == 'weazel'
	or society == 'x-gamer' then
		table.insert(elements, {label = "Przelej premię", value = 'give_money'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenSecondEmployeeList(society)
			ESX.UI.Menu.CloseAll()
		end

		if data.current.value == 'give_money' then
			OpenGiveMoneyMenu(society)
		end

		if data.current.value == 'recruit' then
			for i=1, #Config.LegalJobsList, 1 do
				if society == Config.LegalJobsList[i] then
					ESX.TriggerServerCallback('stinky_legaljobs:getLicenses', function(licenses)
						levelsecond = licenses.level
						OpenSecondRecruitMenu(society, levelsecond, true)
					end, society)
					break
				else
					OpenSecondRecruitMenu(society, levelsecond, false)
				end
			end
		end

		if data.current.value == 'zeruj_kursy' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'chuj', {
				title    = 'Czy na pewno chcesz wyczyścić kursy?',
				align    = 'center',
				elements = {
					{ label = 'Tak', value = true },
					{ label = 'Nie', value = false }
				},
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:zeruj_kursy_all', function(cb)
						TriggerServerEvent('exile_logs:triggerLog', "Wyzerował wszystkie kursy w firmie: "..ESX.PlayerData.secondjob.name, 'boss_menu')
						ESX.ShowNotification('~g~Kursy zostały zresetowane')
					end, ESX.PlayerData.secondjob.name)
				end
			end, function(data2, menu2)
				ESX.UI.Menu.CloseAll()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenSecondEmployeeList(society)
	ESX.TriggerServerCallback('exilerp_scripts:showSecondWorker', function(employees)	
	
		local elements = nil
		
			elements = {
				head = {_U('employee'), _U('grade'), "Globalne kursy", "Tymaczasowe kursy", _U('actions')},
				rows = {}
			}			

			for i=1, #employees, 1 do
				local gradeLabel = (employees[i].secondjob.grade_label == '' and employees[i].secondjob.label or employees[i].secondjob.grade_label)
				
				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						gradeLabel,
						employees[i].secondjob.courses,
						employees[i].secondjob.courses2,
						'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}} {{Zeruj kursy|zeruj_kursy}}'
					}
				})
			end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenSecondPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))
				ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietySecondJob', function()
					OpenSecondEmployeeList(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			elseif data.value == 'zeruj_kursy' then
				ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:zeruj_kursy', function()
					OpenSecondEmployeeList(society)
				end, employee)
				ESX.ShowNotification('~b~Wyzerowano pomyślnie kurs tymczasowy pracownika!')
				TriggerServerEvent('exile_logs:triggerLog', "Wyzerował pojedyńczy kurs w firmie: "..ESX.PlayerData.secondjob.name.. "\nGraczowi: "..employee, 'boss_menu')
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenSecondRecruitMenu(society, level, custom)
	if custom then
		ESX.TriggerServerCallback('society:countSecondMembers', function(all)
			if all >= exports['stinky_legaljobs']:GetLimits(level) then
				if tonumber(level) == 10 then
					ESX.ShowNotification('~r~Twoja firma posiada już maksymalny poziom i maksymalną ilość członków')
				else
					ESX.UI.Menu.CloseAll()
					ESX.ShowNotification('~r~Aby zatrudnić więcej osób musisz podnieść poziom firmy')
				end
			else
				local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
				if json.encode(players) ~= '[]' then
					local elements = {}
					local serverIds = {}
					
					for k,v in ipairs(players) do
						if v ~= playerId then
							table.insert(serverIds, GetPlayerServerId(v))
						end
					end
					
					ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames",function(identities)
						for k,v in pairs(identities) do
							table.insert(elements, {
								player = k,
								label = v
							})
						end		
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'special_cop_menu',
						{
							title = _U('recruiting'),
							align = 'center',
							elements = elements,
						},
						function(data, menu)
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
								title    = _U('do_you_want_to_recruit', data.current.label),
								align    = 'center',
								elements = {
									{label = _U('no'),  value = 'no'},
									{label = _U('yes'), value = 'yes'}
								}
							}, function(data2, menu2)
								menu2.close()

								if data2.current.value == 'yes' then
									ESX.ShowNotification(_U('you_have_hired', data.current.label))
									ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietySecondJob', function()
										OpenSecondRecruitMenu(society, level, custom)
									end, data.current.player, society, 0, 'hire', ESX.PlayerData.secondjob.name, society)
								end
							end, function(data2, menu2)
								menu2.close()
							end)
						end,
						function(data, menu)
							menu.close()
						end)	
					end, serverIds)
				else
					ESX.ShowNotification('~r~Brak graczy w pobliżu!')
				end
			end
		end, society)
	else
		local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
		if json.encode(players) ~= '[]' then
			local elements = {}
			local serverIds = {}
			
			for k,v in ipairs(players) do
				if v ~= playerId then
					table.insert(serverIds, GetPlayerServerId(v))
				end
			end
			
			ESX.TriggerServerCallback("esxexile_societyrpexileesocietybig:getMeNames",function(identities)
				for k,v in pairs(identities) do
					table.insert(elements, {
						player = k,
						label = v
					})
				end		
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'special_cop_menu',
				{
					title = _U('recruiting'),
					align = 'center',
					elements = elements,
				},
				function(data, menu)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
						title    = _U('do_you_want_to_recruit', data.current.label),
						align    = 'center',
						elements = {
							{label = _U('no'),  value = 'no'},
							{label = _U('yes'), value = 'yes'}
						}
					}, function(data2, menu2)
						menu2.close()

						if data2.current.value == 'yes' then
							ESX.ShowNotification(_U('you_have_hired', data.current.label))
							ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietySecondJob', function()
								OpenSecondRecruitMenu(society, level, custom)
							end, data.current.player, society, 0, 'hire', ESX.PlayerData.secondjob.name, society)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end,
				function(data, menu)
					menu.close()
				end)	
			end, serverIds)
		else
			ESX.ShowNotification('~r~Brak graczy w pobliżu!')
		end
	end
end

function OpenSecondPromoteMenu(society, employee)
	
	ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:getJob', function(job)

		local elements = {}
		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			if ESX.PlayerData.secondjob.grade >= job.grades[i].grade then
				table.insert(elements, {
					label = gradeLabel,
					value = job.grades[i].grade,
					selected = (employee.secondjob.grade == job.grades[i].grade)
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esxexile_societyrpexileesocietybig:setAddNiggerPolarsdaqf31redsc8z9SocietySecondJob', function()
				OpenSecondEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenSecondEmployeeList(society)
		end)

	end, society)
end

AddEventHandler('esxexile_societyrpexileesocietybig:openLicenseBossMenu', function(society, level, close, options)
	OpenLicenseBossMenu(society, level, close, options)
end)

AddEventHandler('esxexile_societyrpexileesocietybig:openThirdBossMenu', function(society, level, close, options)
	OpenThirdBossMenu(society, level, close, options)
end)

AddEventHandler('esxexile_societyrpexileesocietybig:openSecondBossMenu', function(society, level, close, options)
	OpenSecondBossMenu(society, level, close, options)
end)