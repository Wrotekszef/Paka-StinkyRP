local closeCallback = nil
local ontune = false
local ontunecheck = false
function LSC:OnMenuClose(m)
	if closeCallback then
		closeCallback()
		closeCallback = nil
	end
end

function LSC:OnMenuChange(last, current)
	TriggerEvent('LSC:rollback')
	if last == "main" then
		last = self
	end

	CheckPurchases(current)
	if last.name == "categories" and current.name == "main" then
		SetVehicleDoorShut(MyVehicle.vehicle, 0, 0)
		SetVehicleDoorShut(MyVehicle.vehicle, 1, 0)
		SetVehicleDoorShut(MyVehicle.vehicle, 4, 0)
		SetVehicleDoorShut(MyVehicle.vehicle, 5, 0)
		SetFollowVehicleCamViewMode(0)

		LSC:Close()
		return
	end
	c = current.name:lower()
	if c == "drzwi" then
		SetVehicleDoorOpen(MyVehicle.vehicle, 0, 0, 0)
		SetVehicleDoorOpen(MyVehicle.vehicle, 1, 0, 0)
	elseif c == "bagażnik" then
		--- doorIndex:
		-- 0 = Front Left Door
		-- 1 = Front Right Door
		-- 2 = Back Left Door
		-- 3 = Back Right Door
		-- 4 = Hood
		-- 5 = Trunk
		-- 6 = Back
		-- 7 = Back2
		SetVehicleDoorOpen(MyVehicle.vehicle, 5, 0, 0)
	elseif c == "audio" or c == "rozpórka" or c == "akcesoria" then
		SetVehicleDoorOpen(MyVehicle.vehicle, 5, 0, 0)
		SetVehicleDoorOpen(MyVehicle.vehicle, 4, 0, 0)
	else
		SetVehicleDoorShut(MyVehicle.vehicle, 0, 0)
		SetVehicleDoorShut(MyVehicle.vehicle, 1, 0)
		SetVehicleDoorShut(MyVehicle.vehicle, 4, 0)
		SetVehicleDoorShut(MyVehicle.vehicle, 5, 0)
		SetFollowVehicleCamViewMode(0)
	end
end

function LSC:onSelectedIndexChanged(name, button)
	name = name:lower()
	local m = LSC.currentmenu

	p = m.parent or self.name
	if m == "main" then
		m = self
	end

	m = m.name:lower()
	p = p:lower()
	-- show preview of selected mod
	if m == "chrom" or m == "klasyczne" or m == "matowe" or m == "metalowe" then
		if p == "kolor główny" then
			SetVehicleColours(MyVehicle.vehicle,button.colorindex,MyVehicle.color[2])
		else
			SetVehicleColours(MyVehicle.vehicle,MyVehicle.color[1],button.colorindex)
			SetVehicleExtraColours(MyVehicle.vehicle, 0, MyVehicle.extracolor[2])	
		end
		
	elseif m == "metallic" then
		if p == "kolor główny" then
			SetVehicleColours(MyVehicle.vehicle,button.colorindex,MyVehicle.color[2])
		else
			SetVehicleColours(MyVehicle.vehicle,MyVehicle.color[1],button.colorindex)
			SetVehicleExtraColours(MyVehicle.vehicle, button.colorindex, MyVehicle.extracolor[2])				
		end
	elseif m == "lakier" then
		SetVehicleExtraColours(MyVehicle.vehicle,MyVehicle.extracolor[1], button.colorindex)
	elseif m == "kolor wnętrza" then
		SetVehicleInteriorColour(MyVehicle.vehicle,button.colorindex)
	elseif m == "kolor deski" then
		SetVehicleDashboardColour(MyVehicle.vehicle,button.colorindex)
	elseif m == "opony" then
		if button.name == "Custom" then
			SetVehicleMod(MyVehicle.vehicle,23,MyVehicle.mods[23].mod,true)
			if IsThisModelABike(GetEntityModel(MyVehicle.vehicle)) then
				SetVehicleMod(MyVehicle.vehicle,24,MyVehicle.mods[24].mod,true)
			end
		else
			SetVehicleMod(MyVehicle.vehicle,23,MyVehicle.mods[23].mod,false)
			if IsThisModelABike(GetEntityModel(MyVehicle.vehicle)) then
				SetVehicleMod(MyVehicle.vehicle,24,MyVehicle.mods[24].mod,false)
			end
		end
	elseif button.modtype and button.mod then
		if button.modtype ~= 18 and button.modtype ~= 22 and button.modtype ~= 8 then
			if button.wtype then
				SetVehicleWheelType(MyVehicle.vehicle,button.wtype)
			end

			SetVehicleMod(MyVehicle.vehicle,button.modtype, button.mod)	
		elseif button.modtype == 22 then
			ToggleVehicleMod(MyVehicle.vehicle,button.modtype, button.mod)
		elseif button.modtype == 8 then
			SetVehicleMod(MyVehicle.vehicle,9,button.mod)
			SetVehicleMod(MyVehicle.vehicle,8,button.mod)
		end
	elseif m == "wariant" then
		SetVehicleNumberPlateTextIndex(MyVehicle.vehicle,button.plateindex)
	elseif m == "naklejka" then
		SetVehicleLivery(MyVehicle.vehicle,button.mod)
	elseif m == "układ" then
		local neons = {255, 255, 255}
		if MyVehicle.neoncolor[1] then
			neons = MyVehicle.neoncolor
		end

		SetVehicleNeonLightsColour(MyVehicle.vehicle,neons[1],neons[2],neons[3])
		if button.name == "Brak" then
			for i, v in pairs(MyVehicle.neonlayout) do
				SetVehicleNeonLightEnabled(MyVehicle.vehicle,(i-1),false)
			end
		else
			for i, v in pairs(MyVehicle.neonlayout) do
				local t = i - 1
				if t ~= button.mod then
					SetVehicleNeonLightEnabled(MyVehicle.vehicle,t,v)
				end
			end

			SetVehicleNeonLightEnabled(MyVehicle.vehicle,button.mod,true)
		end
	elseif m == "kolor" then
		SetVehicleNeonLightsColour(MyVehicle.vehicle,button.neon[1], button.neon[2], button.neon[3])
	elseif m == "reflektory przednie" then
		if button.name == "Stock" then
			ToggleVehicleMod(MyVehicle.vehicle,22,0)
			SetVehicleHeadlightsColour(MyVehicle.vehicle,-1)
		elseif button.name == "Xenon" then
			ToggleVehicleMod(MyVehicle.vehicle,22,1)
			SetVehicleHeadlightsColour(MyVehicle.vehicle,-1)
		else
			ToggleVehicleMod(MyVehicle.vehicle,22,1)
			SetVehicleHeadlightsColour(MyVehicle.vehicle,button.color)
		end
	elseif m == "przyciemnianie szyb" then
		SetVehicleWindowTint(MyVehicle.vehicle, button.tint)
	elseif m == "klakson" then
		--Maybe some way of playing the horn?
		OverrideVehHorn(MyVehicle.vehicle,false,0)
		if IsHornActive(MyVehicle.vehicle) or IsControlPressed(1,86) then
			StartVehicleHorn(MyVehicle.vehicle, 10000, "HELDDOWN", 1)
		end
	end
end

function LSC:onButtonSelected(name, button)
	if button.name == 'Kuloodporne Opony' and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade < Config.bulletproof then return end
	if button.price and not button.purchased then
		TriggerServerEvent("LSC:accept", name, button)
	end
end

AddEventHandler('LSC:build', function(vehicle, mecano, label, sprite, oCb, cCb)
	ontune = true
	if ontune == true then
		LSC:setTitle(label)
		LSC.title_sprite = sprite
		LSC.buttons = {}

		LSC.config.controls = Config.menu.controls
		SetinstructionalButtons({
			{GetControlInstructionalButton(1, LSC.config.controls.menu_back, 0), "Wstecz"},
			{GetControlInstructionalButton(1, LSC.config.controls.menu_select, 0), "Wybierz"},
			{GetControlInstructionalButton(1, LSC.config.controls.menu_up, 0), "Do góry"},
			{GetControlInstructionalButton(1, LSC.config.controls.menu_down, 0), "W dół"},
			{GetControlInstructionalButton(1, LSC.config.controls.menu_left, 0), "W lewo"},
			{GetControlInstructionalButton(1, LSC.config.controls.menu_right, 0), "W prawo"}
		}, 0)
		
		LSC.config.size.width = f(Config.menu.width) or 0.24;
		LSC.config.size.height = f(Config.menu.height) or 0.36;
		
		LSC:setMaxButtons(Config.menu.maxbuttons)
		if type(Config.menu.position) == 'table' then
			LSC.config.position = { x = Config.menu.position.x, y = Config.menu.position.y}
		elseif type(Config.menu.position) == 'string' then
			if Config.menu.position == "left" then
				LSC.config.position = { x = 0.16, y = 0.13}
			elseif  Config.menu.position == "right" then
				LSC.config.position = { x = 1-0.16, y = 0.13}
			end
		end
		
		if type(Config.menu.theme) == "table" then
			LSC:setColors(Config.menu.theme.text_color,Config.menu.theme.stext_color,Config.menu.theme.bg_color,Config.menu.theme.sbg_color)
		elseif	type(Config.menu.theme) == "string" then
			if Config.menu.theme == "light" then
				LSC:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 155},{ r = 255,g = 255, b = 255, a = 255})
			elseif Config.menu.theme == "darkred" then
				LSC:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 155},{ r = 200,g = 15, b = 15, a = 200})
			elseif Config.menu.theme == "bluish" then	
				LSC:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 100},{ r = 0,g = 100, b = 255, a = 200})
			elseif Config.menu.theme == "greenish" then	
				LSC:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 100},{ r = 0,g = 200, b = 0, a = 200})
			end
		end

		LSC:addSubMenu("KATEGORIE", "categories", nil, false)
		LSC.categories.buttons = {}

		-- Calculate price for vehicle repair and add repair button
		local bodyDamage = (1000 - GetVehicleBodyHealth(vehicle)) / 100
		local engineDamage = (1000 - GetVehicleEngineHealth(vehicle)) / 100

		local fixPrice = (Config.repair.bodyperhundredprice * bodyDamage) + (Config.repair.engineperhundredprice * engineDamage)

		LSC:addPurchase("Napraw pojazd", round(fixPrice, 0), "Pełna naprawa karoserii oraz serwis.")
		
		-- Setup table for vehicle with all mods, colors, etc.
		MyVehicle.vehicle = vehicle
		MyVehicle.model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
		MyVehicle.color =  table.pack(GetVehicleColours(vehicle))
		MyVehicle.extracolor = table.pack(GetVehicleExtraColours(vehicle))
		MyVehicle.interiorColor = GetVehicleInteriorColour(vehicle)
		MyVehicle.dashboardColor = GetVehicleInteriorColour(vehicle)
		MyVehicle.neonlayout = {IsVehicleNeonLightEnabled(vehicle, 0) or false, IsVehicleNeonLightEnabled(vehicle, 1) or false, IsVehicleNeonLightEnabled(vehicle, 2) or false, IsVehicleNeonLightEnabled(vehicle, 3) or false}
		MyVehicle.neoncolor = table.pack(GetVehicleNeonLightsColour(vehicle))
		MyVehicle.smokecolor = table.pack(GetVehicleTyreSmokeColor(vehicle))
		MyVehicle.plateindex = GetVehicleNumberPlateTextIndex(vehicle)
		MyVehicle.liveryvariant = GetVehicleLivery(vehicle)

		MyVehicle.price = -1
		ESX.TriggerServerCallback('esx_vehicleshop:getVehiclePrice', function (price)
			MyVehicle.price = price
			--print(MyVehicle.model)
		end, MyVehicle.model)
		while MyVehicle.price == -1 do
			Citizen.Wait(100)
		end
		
		MyVehicle.mods = {}
		for i = 0, 48 do
			MyVehicle.mods[i] = {mod = nil}
		end

		SetVehicleModKit(vehicle, 0)
		for i, t in pairs(MyVehicle.mods) do
			if i == 22 then
				if IsToggleModOn(vehicle,i) then
					MyVehicle.headlights = GetVehicleHeadlightsColour(vehicle)
					if MyVehicle.headlights == 255 then
						MyVehicle.headlights = -1
					end

					t.mod = 1
				else
					t.mod = 0
				end
			elseif i == 18 then
				if IsToggleModOn(vehicle,i) then
					t.mod = 1
				else
					t.mod = 0
				end
			elseif i == 23 or i == 24 then
				t.mod = GetVehicleMod(vehicle,i)
				t.variation = GetVehicleModVariation(vehicle, i)
			else
				t.mod = GetVehicleMod(vehicle,i)
			end
		end

		if GetVehicleWindowTint(vehicle) == -1 or GetVehicleWindowTint(vehicle) == 0 then
			MyVehicle.windowtint = false
		else
			MyVehicle.windowtint = GetVehicleWindowTint(vehicle)
		end

		MyVehicle.wheeltype = GetVehicleWheelType(vehicle)
		MyVehicle.bulletProofTyres = not GetVehicleTyresCanBurst(vehicle)
		
		-- Menu stuff 
		local chassis,interior,bumper,fbumper,rbumper,engine = false,false,false,false,false
		for i = 0,48 do
			if GetNumVehicleMods(vehicle,i) and GetNumVehicleMods(vehicle,i) > 0 then
				if i == 1 then
					bumper = true
					fbumper = true
				elseif i == 2 then
					bumper = true
					rbumper = true
				elseif (i >= 42 and i <= 46) or i == 5 or i == 9 then --If any chassis mod exist then add chassis menu
					chassis = true
				elseif i >= 27 and i <= 37 then --If any interior mod exist then add interior menu
					interior = true
				elseif (i >= 39 and i <= 41) or i == 11 then
					engine = true
				end
			end
		end

		if mecano then
			AddMod(0, LSC.categories, "KLAPA", "Klapa", "Zwiększ docisk pojazdu dzięki dedykowanym spoilerom.",true)
			AddMod(3, LSC.categories, "PROGI", "Progi", "Popraw wygląd pojazdu dzięki dedykowanym dokładkom progów.",true)
			AddMod(4, LSC.categories, "WYDECH", "Wydech", "Dedykowane układy wydechowe.",true)
			AddMod(6, LSC.categories, "FRONT", "Front", "Popraw wygląd pojazdu dzięki dedykowanym grillom.",true)
			AddMod(7, LSC.categories, "MASKA", "Maska", "Popraw wygląd pojazdu dzięki dedykowanym maskom.",true)
			AddMod(8, LSC.categories, "BŁOTNIKI", "Błotniki", "Popraw wygląd pojazdu dzięki dedykowanym błotnikom.",true)
			AddMod(10, LSC.categories, "DACH", "Dach", "Zredukuj środek ciężkości dzięki dedykowanym panelom dachowym.",true)
			AddMod(12, LSC.categories, "HAMULCE", "Hamulce", "Zwiększ precyzję hamulców i wyeliminuj efekt fadingu.",true)
			AddMod(13, LSC.categories, "SKRZYNIA BIEGÓW", "Skrzynia biegów", "Lepsze przyspieszenie dzięki lepiej dobranym przełożeniom skrzyni biegów.",true)
		end

		AddMod(14, LSC.categories, "KLAKSON - [E] aby przetestować", "Klakson", "Aftermarketowe klaksony.",true)
		if mecano then
			AddMod(15, LSC.categories, "ZAWIESZENIE", "Zawieszenie", "Lepsze prowadzenie pojazdu, precyzyjniejszy układ kierowniczy.",true)
			AddMod(16, LSC.categories, "OPANCERZENIE", "Opancerzenie", "Zadbaj o bezpieczeństwo dzięki wzmocnieniu karoserii za pomocą paneli kompozytowych.",true)
			AddMod(18, LSC.categories, "TURBO", "Turbo", "Zmniejsz turbodziurę.",false)
		
			if chassis then
				local cm = LSC.categories:addSubMenu("NADWOZIE", "Nadwozie", "Dedykowane dodatki nadwozia pojazdu.",true)
				AddMod(42, cm, "NADWOZIE: DOKŁADKI #1", "Dokładki #1", "",true) --headlight trim
				AddMod(43, cm, "NADWOZIE: DOKŁADKI #2", "Dokładki #2", "",true) --foglights
				AddMod(44, cm, "NADWOZIE: DOD. DACHU", "Dodatki dachu", "",true) --roof scoops
				AddMod(45, cm, "NADWOZIE: WLEW PALIWA", "Wlew paliwa", "",true)
				AddMod(46, cm, "NADWOZIE: DRZWI", "Drzwi", "",true)-- windows
				AddMod(5, cm, "NADWOZIE: KLATKA", "Klatka", "",true)
				AddMod(9, cm, "NADWOZIE: PRAWY BŁOTNIK", "Prawy Błotnik", "",true)
			end

			if engine then
				local em = LSC.categories:addSubMenu("SILNIK", "Silnik", "Dedykowane dodatki pod maskę",true)
				AddMod(39, em, "SILNIK: AKCESORIA", "Akcesoria", "Customowe akcesoria silnika.",true)
				AddMod(40, em, "SILNIK: DODATKI", "Dodatki", "Ozdobne akcesoria.",true)
				AddMod(41, em, "SILNIK: ROZPÓRKA", "Rozpórka", "Zadbaj o karoserię dzięki rozpórce.",true)
				AddMod(11, em, "SILNIK: TUNING", "Tuning", "Zwiększ moc pojazdu.",true)
			end

			if interior then
				local im = LSC.categories:addSubMenu("WNĘTRZE", "Wnętrze", "Tylko prestiżowe produkty.",true)
				AddMod(27, im, "WNĘTRZE: WZÓR", "Wzór", "",true)
				AddMod(28, im, "WNĘTRZE: OZDOBY", "Ozdoby", "",true)
				AddMod(29, im, "WNĘTRZE: KONSOLA", "Konsola", "",true)
				AddMod(30, im, "WNĘTRZE: ZEGARY", "Zegary", "",true)
				AddMod(31, im, "WNĘTRZE: DRZWI", "Drzwi", "",true)
				AddMod(32, im, "WNĘTRZE: FOTELE", "Fotele", "",true)
				AddMod(33, im, "WNĘTRZE: KIEROWNICA", "Kierownica", "",true)
				AddMod(34, im, "WNĘTRZE: WYBIERAK", "Wybierak", "",true)
				AddMod(35, im, "WNĘTRZE: PLAKIETKI", "Plakietki", "",true)
				AddMod(36, im, "WNĘTRZE: AUDIO", "Audio", "",true)
				AddMod(37, im, "WNĘTRZE: BAGAŻNIK", "Bagażnik", "",true)
			end
		end
		
		local pm = LSC.categories:addSubMenu("TABLICE REJ.", "Tablice rejestracyjne","Ozdobne tablice rejestracyjne pojazdu.",true)
		local lm = pm:addSubMenu("TABLICE REJ.: WARIANT", "Wariant", "",true)
		for n, mod in pairs(Config.prices.plates) do
			local btn = lm:addPurchase(mod.name, GetPrice(mod.price))
			btn.plateindex = mod.plateindex
		end

		--Customize license plates
		AddMod(25, pm, "TABLICE REJ.: RAMKA", "Ramka", "",true)
		--AddMod(26, pm, "TABLICE REJ.: CUSTOMOWA", "Customowa", "",true)

		if mecano then
			AddMod(38, LSC.categories, "PNEUMATYKA", "Pneumatyka","",true)
		end

		AddMod(48, LSC.categories, "NAKLEJKI", "Naklejki", "Oklej swój pojazd specjalnymi naklejkami.",true)
		if mecano then
			if bumper then
				local bm = LSC.categories:addSubMenu("ZDERZAKI", "Zderzaki", "Popraw wygląd pojazdu dzięki dedykowanym zderzakom.",true)
				if fbumper then
					AddMod(1, bm, "ZDERZAKI: PRZÓD", "Przedni", "",true)
				end
				if rbumper then
					AddMod(2, bm, "ZDERZAKI: TYŁ", "Tylny", "",true)
				end
			end
		end
		
		lm = LSC.categories:addSubMenu("ŚWIATŁA", "Światła", "Popraw widoczność w nocy.",true)
		AddMod(22, lm, "ŚWIATŁA: REF. PRZEDNIE", "Reflektory przednie", nil, false)
		if mecano and not IsThisModelABike(GetEntityModel(vehicle)) then
			local nm = lm:addSubMenu("ŚWIATŁA: NEONY", "Neony", nil, true)
				local nlm = nm:addSubMenu("ŚWIATŁA - NEONY: UKŁAD", "Układ", nil, true)
					local btn = nlm:addPurchase("Brak")
					for n, mod in pairs(Config.prices.neonlayout) do
						local btn = nlm:addPurchase(mod.name, GetPrice(mod.price))
						btn.mod = mod.mod
					end

					local ncm = nm:addSubMenu("ŚWIATŁA - NEONY: KOLOR", "Kolor", "Pamiętaj aby najpierw wybrać układ!", true)
				for n, mod in pairs(Config.prices.neoncolor) do
					local btn = ncm:addPurchase(mod.name, GetPrice(mod.price))
					btn.neon = mod.neon
				end
		end

		local respray = LSC.categories:addSubMenu("LAKIEROWANIE", "Lakierowanie", "Zmień wygląd swojego pojazdu.",true)
		local pcol = respray:addSubMenu("LAKIEROWANIE: KOLOR GŁÓWNY", "Kolor główny",  nil,true)
				local m = pcol:addSubMenu("LAK. - KOL. GŁÓWNY: CHROM", "Chrom", nil,true)
				for n, c in pairs(Config.prices.chrome.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.chrome.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[1] then
						btn.purchased = true
					end
				end
				local m = pcol:addSubMenu("LAK. - KOL. GŁÓWNY: KLASYCZNE", "Klasyczne", nil,true)
				for n, c in pairs(Config.prices.classic.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.classic.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[1] then
						btn.purchased = true
					end
				end
				local m = pcol:addSubMenu("LAK. - KOL. GŁÓWNY: MATOWE", "Matowe", nil,true)
				for n, c in pairs(Config.prices.matte.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.matte.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[1] then
						btn.purchased = true
					end
				end
				local m = pcol:addSubMenu("LAK. - KOL. GŁÓWNY: METALLIC", "Metallic", nil,true)
				for n, c in pairs(Config.prices.metallic.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.metallic.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[1] then
						btn.purchased = true
					end
				end
				local m = pcol:addSubMenu("LAK. - KOL. GŁÓWNY: METALOWE", "Metalowe", nil,true)
				for n, c in pairs(Config.prices.metal.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.metal.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[1] then
						btn.purchased = true
					end
				end
				local scol = respray:addSubMenu("LAKIEROWANIE: KOLOR DODATKOWY", "Kolor dodatkowy", nil,true)
				local m = scol:addSubMenu("LAK. - KOL. DOD.: CHROM", "Chrom", nil,true)
				for n, c in pairs(Config.prices.chrome2.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.chrome2.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[2] then
						btn.purchased = true
					end
				end
				local m = scol:addSubMenu("LAK. - KOL. DOD.: KLASYCZNE", "Klasyczne", nil,true)
				for n, c in pairs(Config.prices.classic2.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.classic2.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[2] then
						btn.purchased = true
					end
				end
				local m = scol:addSubMenu("LAK. - KOL. DOD.: MATOWE", "Matowe", nil,true)
				for n, c in pairs(Config.prices.matte.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.matte2.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[2] then
						btn.purchased = true
					end
				end
				local m = scol:addSubMenu("LAK. - KOL. DOD.: METALLIC", "Metallic", nil,true)
				for n, c in pairs(Config.prices.metallic2.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.metallic2.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[2] or btn.colorindex == MyVehicle.extracolor[1] then
						btn.purchased = true
					end
				end
				local m = scol:addSubMenu("LAK. - KOL. DOD.: METALE", "Metalowe", nil,true)
				for n, c in pairs(Config.prices.metal2.colors) do
					local btn = m:addPurchase(c.name, GetPrice(Config.prices.metal2.price))
					btn.colorindex = c.colorindex
					if btn.colorindex == MyVehicle.color[2] then
						btn.purchased = true
					end
				end
			local liverCount = GetVehicleLiveryCount(vehicle) or 0
			if liverCount ~= -1 then
				local m = respray:addSubMenu("LAKIEROWANIE: NAKLEJKA", "Naklejka", nil, true)
				local btn = m:addPurchase("Stock", GetPrice(Config.prices.liveryvariant))

				btn.mod = 0
				if btn.mod == MyVehicle.liveryvariant then
					btn.purchased = true
				end

				for i = 1, liverCount - 1 do
					local l = GetLiveryName(vehicle, i)
					if not l then
						l = "Exile #" .. i
					end

					local btn = m:addPurchase(l, GetPrice(Config.prices.liveryvariant))
					btn.mod = i
					if btn.mod == MyVehicle.liveryvariant then
						btn.purchased = true
					end
				end
			end
			local m = respray:addSubMenu("LAKIEROWANIE: Kolor wnętrza", "Kolor wnętrza", nil,true)
			for n, c in pairs(Config.prices.classic.colors) do
				local btn = m:addPurchase(c.name, GetPrice(Config.prices.classic.price))
				btn.colorindex = c.colorindex
				if btn.colorindex == MyVehicle.interiorColor then
					btn.purchased = true
				end
			end
			local m = respray:addSubMenu("LAKIEROWANIE: Kolor deski", "Kolor deski", nil,true)
			for n, c in pairs(Config.prices.classic.colors) do
				local btn = m:addPurchase(c.name, GetPrice(Config.prices.classic.price))
				btn.colorindex = c.colorindex
				if btn.colorindex == MyVehicle.dashboardColor then
					btn.purchased = true
				end
			end
			respray:addPurchase('Mycie', GetPrice(Config.prices.wash))
		
		
		local wm = LSC.categories:addSubMenu("KOŁA", "Koła", "Customowe felgi oraz opony.",true)
			local rm = wm:addSubMenu("KOŁA - FELGI", "Felgi", "",true)
			local wtype = rm:addSubMenu("KOŁA - FELGI: Felga", "Felga", "Wybierz swój ulubiony wzór.",true)
				if IsThisModelABike(GetEntityModel(vehicle)) then
					local fwheels = wtype:addSubMenu("KOŁA - FEL. - WZÓR: PRZÓD", "Przód", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.frontwheel) do
							known[w.mod] = true
							local btn = fwheels:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.frontwheel.price))
							btn.wtype = Config.wheeltype.frontwheel.id
							btn.modtype = Config.wheeltype.frontwheel.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle, Config.wheeltype.frontwheel.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.frontwheel.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.frontwheel.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = fwheels:addPurchase(lbl, GetPrice(Config.wheeltype.frontwheel.price))
									btn.wtype = Config.wheeltype.frontwheel.id
									btn.modtype = Config.wheeltype.frontwheel.mod
									btn.mod = i
								end
							end
						end
						local bwheels = wtype:addSubMenu("KOŁA - FEL. - WZÓR: TYŁ", "Tył", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.backwheel) do
							known[w.mod] = true
							local btn = bwheels:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.backwheel.price))
							btn.wtype = Config.wheeltype.backwheel.id
							btn.modtype = Config.wheeltype.backwheel.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle, Config.wheeltype.backwheel.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.backwheel.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.backwheel.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = bwheels:addPurchase(lbl, GetPrice(Config.wheeltype.backwheel.price))
									btn.wtype = Config.wheeltype.backwheel.id
									btn.modtype = Config.wheeltype.backwheel.mod
									btn.mod = i
								end
							end
						end
				else
					local sportw = wtype:addSubMenu("KOŁA - FEL. - WZÓR: SPORTOWA", "Sportowa", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.sportwheels) do
							known[w.mod] = true
							local btn = sportw:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.sportwheels.price))
							btn.wtype = Config.wheeltype.sportwheels.id
							btn.modtype = Config.wheeltype.sportwheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle, Config.wheeltype.sportwheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.sportwheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.sportwheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = sportw:addPurchase(lbl, GetPrice(Config.wheeltype.sportwheels.price))
									btn.wtype = Config.wheeltype.sportwheels.id
									btn.modtype = Config.wheeltype.sportwheels.mod
									btn.mod = i
								end
							end
						end
						local musclew = wtype:addSubMenu("KOŁA - FEL. - WZÓR: MUSCLE", "Muscle", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.musclewheels) do
							known[w.mod] = true
							local btn = musclew:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.musclewheels.price))
							btn.wtype =  Config.wheeltype.musclewheels.id
							btn.modtype = Config.wheeltype.musclewheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle, Config.wheeltype.musclewheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.musclewheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.musclewheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = musclew:addPurchase(lbl, GetPrice(Config.wheeltype.musclewheels.price))
									btn.wtype = Config.wheeltype.musclewheels.id
									btn.modtype = Config.wheeltype.musclewheels.mod
									btn.mod = i
								end
							end
						end
						local lowriderw = wtype:addSubMenu("KOŁA - FEL. - WZÓR: LOWRIDER", "Lowrider", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.lowriderwheels) do
							known[w.mod] = true
							local btn = lowriderw:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.lowriderwheels.price))
							btn.wtype =  Config.wheeltype.lowriderwheels.id
							btn.modtype = Config.wheeltype.lowriderwheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle, Config.wheeltype.lowriderwheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.lowriderwheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.lowriderwheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = lowriderw:addPurchase(lbl, GetPrice(Config.wheeltype.lowriderwheels.price))
									btn.wtype = Config.wheeltype.lowriderwheels.id
									btn.modtype = Config.wheeltype.lowriderwheels.mod
									btn.mod = i
								end
							end
						end
						local suvw = wtype:addSubMenu("KOŁA - FEL. - WZÓR: SUV", "SUV", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.suvwheels) do
							known[w.mod] = true
							local btn = suvw:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.suvwheels.price))
							btn.wtype = Config.wheeltype.suvwheels.id
							btn.modtype = Config.wheeltype.suvwheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle, Config.wheeltype.suvwheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.suvwheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.suvwheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = suvw:addPurchase(lbl, GetPrice(Config.wheeltype.suvwheels.price))
									btn.wtype = Config.wheeltype.suvwheels.id
									btn.modtype = Config.wheeltype.suvwheels.mod
									btn.mod = i
								end
							end
						end
						local offroadw = wtype:addSubMenu("KOŁA - FEL. - WZÓR: OFFROAD", "Offroad", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.offroadwheels) do
							known[w.mod] = true
							local btn = offroadw:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.offroadwheels.price))
							btn.wtype = Config.wheeltype.offroadwheels.id
							btn.modtype = Config.wheeltype.offroadwheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle,Config.wheeltype.offroadwheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.offroadwheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.offroadwheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = offroadw:addPurchase(lbl, GetPrice(Config.wheeltype.offroadwheels.price))
									btn.wtype = Config.wheeltype.offroadwheels.id
									btn.modtype = Config.wheeltype.offroadwheels.mod
									btn.mod = i
								end
							end
						end
						local tunerw = wtype:addSubMenu("KOŁA - FEL. - WZÓR: TUNINGOWA", "Tuningowa", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.tunerwheels) do
							known[w.mod] = true
							local btn = tunerw:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.tunerwheels.price))
							btn.wtype = Config.wheeltype.tunerwheels.id
							btn.modtype = Config.wheeltype.tunerwheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle,Config.wheeltype.tunerwheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.tunerwheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.tunerwheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = tunerw:addPurchase(lbl, GetPrice(Config.wheeltype.tunerwheels.price))
									btn.wtype = Config.wheeltype.tunerwheels.id
									btn.modtype = Config.wheeltype.tunerwheels.mod
									btn.mod = i
								end
							end
						end
						local hughendw = wtype:addSubMenu("KOŁA - FEL. - WZÓR: HIGHEND", "Highend", nil,true)
						local known = {}
						for n, w in pairs(Config.prices.highendwheels) do
							known[w.mod] = true
							local btn = hughendw:addPurchase(w.name, GetPrice(w.price and w.price or Config.wheeltype.highendwheels.price))
							btn.wtype = Config.wheeltype.highendwheels.id
							btn.modtype = Config.wheeltype.highendwheels.mod
							btn.mod = w.mod
						end

						SetVehicleWheelType(vehicle,Config.wheeltype.highendwheels.id)
						for i = 0, tonumber(GetNumVehicleMods(vehicle, Config.wheeltype.highendwheels.mod)) do
							if not known[i] then
								local lbl = GetModTextLabel(vehicle, Config.wheeltype.highendwheels.mod, i)
								if lbl ~= nil then
									local lbl = tostring(GetLabelText(lbl))
									if lbl == "NULL" then
										lbl = "Exile #" .. i
									end

									local btn = hughendw:addPurchase(lbl, GetPrice(Config.wheeltype.highendwheels.price))
									btn.wtype = Config.wheeltype.highendwheels.id
									btn.modtype = Config.wheeltype.highendwheels.mod
									btn.mod = i
								end
							end
						end
				end

		SetVehicleWheelType(vehicle,MyVehicle.wheeltype)
		m = rm:addSubMenu("KOŁA - FELGI: LAKIER", "Lakier", "Pokoloruj swój ulubiony wzór.",true)
			for n, c in pairs(Config.prices.wheelcolor.colors) do
				local btn = m:addPurchase(c.name, GetPrice(Config.prices.wheelcolor.price))
				btn.colorindex = c.colorindex
			end
		
		m = wm:addSubMenu("KOŁA: OPONY", "Opony", "Dobierz styl opon.",true)
			for n, mod in pairs(Config.prices.wheelaccessories) do
				local btn = m:addPurchase(mod.name, GetPrice(mod.price))
				btn.smokecolor = mod.smokecolor
			end
		
		m = LSC.categories:addSubMenu("PRZYCIEMNIANIE SZYB", "Przyciemnianie szyb", "",true)	
		local btn = m:addPurchase("Brak")
			btn.tint = false
			for n, tint in pairs(Config.prices.windowtint) do
				btn = m:addPurchase(tint.name, GetPrice(tint.price))
				btn.tint = tint.tint
			end

		oCb()
		closeCallback = cCb
	end
end)

AddEventHandler('LSC:open', function(t)
	LSC:Open(t)
end)

RegisterNetEvent("LSC:accept")
AddEventHandler("LSC:accept", function(name, button)
	name = name:lower()

	local m = LSC.currentmenu
	if m == "main" then
		m = LSC
	end
	
	local mname = m.name:lower()
	-- Executed if button is selected + goes through checks
	if mname == "chrom" or mname ==  "klasyczne" or mname ==  "matowe" or mname ==  "metalowe" then
		if m.parent == "Kolor główny" then
			MyVehicle.color[1] = button.colorindex
		else
			MyVehicle.color[2] = button.colorindex
			MyVehicle.extracolor[1] = 0
		end
	elseif mname == "metallic" then
		if m.parent == "Kolor główny" then
			MyVehicle.color[1] = button.colorindex
		else
			MyVehicle.color[2] = button.colorindex
			MyVehicle.extracolor[1] = button.colorindex
		end
	elseif mname == "naklejka" then
		MyVehicle.liveryvariant = button.mod
	elseif mname == "naklejki" or mname == "pneumatyka" or mname == "klakson" or mname == "wlew paliwa" or mname == "ozdoby" or  mname == "dokładki #1" or mname == "dokładki #2" or mname == "dodatki dachu" or mname == "drzwi" or mname == "klatka" or mname == "prawy błotnik" or mname == "akcesoria" or mname == "rozpórka" or mname == "wzór" or mname == "konsola" or mname == "zegary" or mname == "fotele" or mname == "kierownica" or mname == "ramka" or mname == "customowa" or mname == "wybierak" or mname == "plakietki" or mname == "audio" or mname == "bagażnik" or mname == "opancerzenie" or mname == "zawieszenie" or mname == "skrzynia biegów" or mname == "hamulce" or mname == "tuning" or mname == "dach" or mname == "maska" or mname == "front" or mname == "wydech" or mname == "progi" or mname == "tylny" or mname == "przedni" or mname == "klapa" or mname == "dodatki" then
		MyVehicle.mods[button.modtype].mod = button.mod
		print(mname, MyVehicle.mods[button.modtype].mod, button.mod)
		local plate = GetVehicleNumberPlateText(MyVehicle.vehicle)
		local vehProperties = ESX.Game.GetVehicleProperties(MyVehicle.vehicle)
		TriggerServerEvent('exile_logs:triggerLog', "Zamontował "..mname.." "..MyVehicle.mods[button.modtype].mod.." dla pojazdu o rejestracji: "..plate, 'tuningi')
	elseif mname == "błotniki" then
		MyVehicle.mods[8].mod = button.mod
		MyVehicle.mods[9].mod = button.mod
	elseif mname == "turbo" then
		MyVehicle.mods[button.modtype].mod = button.mod
		ToggleVehicleMod(MyVehicle.vehicle, button.modtype, button.mod)
		local plate = GetVehicleNumberPlateText(MyVehicle.vehicle)
		local vehProperties = ESX.Game.GetVehicleProperties(MyVehicle.vehicle)
		TriggerServerEvent('exile_logs:triggerLog', "Zamontował turbo dla pojazdu o rejestracji: "..plate, 'tuningi')
	elseif mname == "reflektory przednie" then
		if button.mod then
			ToggleVehicleMod(MyVehicle.vehicle, 22, button.mod)
			MyVehicle.mods[22].mod = button.mod

			SetVehicleHeadlightsColour(MyVehicle.vehicle, -1)
			MyVehicle.headlights = -1
		elseif button.color then
			ToggleVehicleMod(MyVehicle.vehicle, 22, 1)
			MyVehicle.mods[22].mod = 1

			SetVehicleHeadlightsColour(MyVehicle.vehicle, button.color)
			MyVehicle.headlights = button.color
		end
	elseif mname == "układ" then

		if button.name == "Brak" then
			for i, v in pairs(MyVehicle.neonlayout) do
				MyVehicle.neonlayout[i] = false
			end

			MyVehicle.neoncolor = {255, 255, 255}
		else
			if not MyVehicle.neoncolor[1] then
				MyVehicle.neoncolor = {255, 255, 255}
			end

			MyVehicle.neonlayout[button.mod + 1] = true
		end

		for i, v in pairs(MyVehicle.neonlayout) do
			SetVehicleNeonLightEnabled(MyVehicle.vehicle,(i-1),v)
		end

	elseif mname == "kolor" then
		MyVehicle.neoncolor[1] = button.neon[1]
		MyVehicle.neoncolor[2] = button.neon[2]
		MyVehicle.neoncolor[3] = button.neon[3]
	elseif mname == "przyciemnianie szyb" then
		MyVehicle.windowtint = button.tint
	elseif mname == "sportowa" or mname == "muscle" or mname == "lowrider" or mname == "tył" or mname == "przód" or mname == "highend" or mname == "suv" or mname == "offroad" or mname == "tuningowa" then
		MyVehicle.wheeltype = button.wtype
		MyVehicle.mods[button.modtype].mod = button.mod
	elseif mname == "lakier" then
		MyVehicle.extracolor[2] = button.colorindex
	elseif mname == "kolor wnętrza" then
		MyVehicle.interiorColor = button.colorindex
	elseif mname == "kolor deski" then
		MyVehicle.dashboardColor = button.colorindex
	elseif mname == "opony" then
		if button.name == "Stock" then
			MyVehicle.mods[23].variation = false
			if IsThisModelABike(GetEntityModel(MyVehicle.vehicle)) then
				MyVehicle.mods[24].variation = false
			end
		elseif button.name == "Custom" then
			MyVehicle.mods[23].variation = true
			if IsThisModelABike(GetEntityModel(MyVehicle.vehicle)) then
				MyVehicle.mods[24].variation = true
			end
		elseif button.name == "Kuloodporne Opony" then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade < Config.bulletproof then return end
			if GetVehicleTyresCanBurst(MyVehicle.vehicle) then
				MyVehicle.bulletProofTyres = true
				SetVehicleTyresCanBurst(MyVehicle.vehicle,true)
			else
				MyVehicle.bulletProofTyres = false
				SetVehicleTyresCanBurst(MyVehicle.vehicle,false)
				
			end
		elseif button.smokecolor then
			if button.smokecolor == true then
				MyVehicle.mods[20].mod = false
				ToggleVehicleMod(MyVehicle.vehicle,20,false)
				MyVehicle.smokecolor = {0,0,0}
				SetVehicleTyreSmokeColor(MyVehicle.vehicle,0,0,0)
			else
				MyVehicle.mods[20].mod = true
				ToggleVehicleMod(MyVehicle.vehicle,20,true)
				MyVehicle.smokecolor = button.smokecolor
				SetVehicleTyreSmokeColor(MyVehicle.vehicle,button.smokecolor[1],button.smokecolor[2],button.smokecolor[3])
			end
		end
	elseif mname == "wariant" then
		MyVehicle.plateindex = button.plateindex
	elseif mname == "main" then
		if name == "napraw pojazd" then
			MyVehicle.repair()
			LSC:ChangeMenu("categories")
		end
	elseif button.name == "Mycie" then
		MyVehicle.wash()
	end

	CheckPurchases(m)
	TriggerServerEvent('LSC:refreshOwnedVehicle', ESX.Game.GetVehicleProperties(MyVehicle.vehicle))
	if mname == "main" then
		LSC:showNotification("Pojazd naprawiony za $" .. button.price .. ".")
	elseif button.name == "Mycie" then
		LSC:showNotification("Pojazd umyty za $" .. button.price .. ".")
	else
		LSC:showNotification("Zakupiono " .. button.name .. " za $" .. button.price .. "!")
	end
end)

RegisterNetEvent('LSC:cancel')
AddEventHandler('LSC:cancel', function(name, money)
	TriggerEvent('LSC:rollback')
	LSC:showNotification("~r~Nie posiadasz $" .. money .. " na " .. name .. ".")
end)

AddEventHandler('LSC:rollback', function(data, mecanos)
	SetVehicleModKit(MyVehicle.vehicle, 0)

	SetVehicleWheelType(MyVehicle.vehicle, MyVehicle.wheeltype)
	for i,m in pairs(MyVehicle.mods) do
		if i == 22 then
			ToggleVehicleMod(MyVehicle.vehicle,i,m.mod)
			SetVehicleHeadlightsColour(MyVehicle.vehicle, MyVehicle.headlights)
		elseif i == 18 then
			ToggleVehicleMod(MyVehicle.vehicle,i,m.mod)
		elseif i == 23 or i == 24 then
			SetVehicleMod(MyVehicle.vehicle,i,m.mod,m.variation)
		else
			SetVehicleMod(MyVehicle.vehicle,i,m.mod)
			if i == 8 then
				SetVehicleMod(MyVehicle.vehicle,9,m.mod)
			end
		end
	end

	SetVehicleColours(MyVehicle.vehicle,MyVehicle.color[1], MyVehicle.color[2])
	SetVehicleExtraColours(MyVehicle.vehicle,MyVehicle.extracolor[1], MyVehicle.extracolor[2])
	SetVehicleInteriorColour(MyVehicle.vehicle,MyVehicle.interiorColor)
	SetVehicleDashboardColour(MyVehicle.vehicle,MyVehicle.dashboardColor)

	SetVehicleNeonLightsColour(MyVehicle.vehicle,MyVehicle.neoncolor[1],MyVehicle.neoncolor[2],MyVehicle.neoncolor[3])
	for i, v in pairs(MyVehicle.neonlayout) do
		SetVehicleNeonLightEnabled(MyVehicle.vehicle,(i-1),v)
	end

	SetVehicleNumberPlateTextIndex(MyVehicle.vehicle, MyVehicle.plateindex)
	SetVehicleWindowTint(MyVehicle.vehicle, MyVehicle.windowtint)
	SetVehicleTyresCanBurst(MyVehicle.vehicle, not MyVehicle.bulletProofTyres)
	SetVehicleLivery(MyVehicle.vehicle, MyVehicle.liveryvariant)
end)

-- Bunch of checks
function CheckPurchases(m)
	local name = m.name:lower()
	if name == "chrom" or name ==  "klasyczne" or name ==  "matowe" or name ==  "metalowe" then
		if m.parent == "Kolor główny" then
			for i,b in pairs(m.buttons) do
				if b.purchased and b.colorindex ~= MyVehicle.color[1] then
					b.purchased = false
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == MyVehicle.color[1] then
					b.purchased = true
					b.sprite = "garage"
				end
			end
		else
			for i,b in pairs(m.buttons) do
				if b.purchased and b.colorindex ~= MyVehicle.color[2] then
					b.purchased = false
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == MyVehicle.color[2] then
					b.purchased = true
					b.sprite = "garage"
				end
			end
		end
	elseif name == "metallic" then
		if m.parent == "Kolor główny" then
			for i,b in pairs(m.buttons) do
				if b.purchased and b.colorindex ~= MyVehicle.color[1] then
					b.purchased = false
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == MyVehicle.color[1] then
					b.purchased = true
					b.sprite = "garage"
				end
			end
		else
			for i,b in pairs(m.buttons) do
				if b.purchased and b.colorindex ~= MyVehicle.color[2] and b.colorindex ~= MyVehicle.extracolor[1] then
					b.purchased = false
					b.sprite = nil
				elseif b.purchased == false and (b.colorindex == MyVehicle.color[2] or b.colorindex == MyVehicle.extracolor[1]) then
					b.purchased = true
					b.sprite = "garage"
				end
			end
		end
	elseif name == "opancerzenie" or name == "zawieszenie" or name == "skrzynia biegów" or name == "hamulce" or name == "tuning" or name == "dach" or name == "błotniki" or name == "maska" or name == "front" or name == "klatka" or name == "prawy błotnik" or name == "wydech" or name == "progi" or name == "tylny" or name == "przedni" or name == "klapa" then
		for i,b in pairs(m.buttons) do
			if b.mod == -1  then
				if MyVehicle.mods[b.modtype].mod == -1 then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite = nil
				end
			elseif b.mod == 0 or b.mod == false then
				if MyVehicle.mods[b.modtype].mod == false or MyVehicle.mods[b.modtype].mod == 0 then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite = nil
				end
			else
				if MyVehicle.mods[b.modtype].mod == b.mod then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite = nil
				end
			end
		end
	elseif name == "układ" then
		for i,b in pairs(m.buttons) do
			if b.name == "Brak" then
				if IsVehicleNeonLightEnabled(MyVehicle.vehicle, 0) == false and IsVehicleNeonLightEnabled(MyVehicle.vehicle, 1) == false and IsVehicleNeonLightEnabled(MyVehicle.vehicle, 2) == false and IsVehicleNeonLightEnabled(MyVehicle.vehicle, 3) == false then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite =  nil
				end
			elseif IsVehicleNeonLightEnabled(MyVehicle.vehicle, b.mod) then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite =  nil
			end
		end
	elseif name == "kolor" then
		for i,b in pairs(m.buttons) do
			if b.neon[1] == MyVehicle.neoncolor[1] and b.neon[2] == MyVehicle.neoncolor[2] and b.neon[3] == MyVehicle.neoncolor[3] then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "przyciemnianie szyb" then
		for i,b in pairs(m.buttons) do
			if MyVehicle.windowtint == b.tint then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "sportowa" or name == "muscle" or name == "lowrider" or name == "tył" or name == "przód" or name == "highend" or name == "suv" or name == "offroad" or name == "tuningowa" then
		for i,b in pairs(m.buttons) do
			if MyVehicle.mods[b.modtype].mod == b.mod and MyVehicle.wheeltype == b.wtype then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "lakier" then
		for i,b in pairs(m.buttons) do
			if b.colorindex == MyVehicle.extracolor[2] then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "kolor wnętrza" then
		for i,b in pairs(m.buttons) do
			if b.colorindex == MyVehicle.interiorColor then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "kolor deski" then
		for i,b in pairs(m.buttons) do
			if b.colorindex == MyVehicle.dashboardColor then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "opony" then
		for i,b in pairs(m.buttons) do
			if b.name == "Stock" then
				if MyVehicle.mods[23].variation == false then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite = nil
				end
			elseif b.name == "Custom" then
				if MyVehicle.mods[23].variation then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite = nil
				end
			elseif b.name == "Kuloodporne Opony" then
				if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade < Config.bulletproof then b.sprite = 'locked' return end
				if not GetVehicleTyresCanBurst(MyVehicle.vehicle) then
					b.sprite = "garage"
					b.purchased = true
				else
					b.purchased = false
					b.sprite = nil
				end
			elseif b.smokecolor then
				local tmp = b.smokecolor
				if b.smokecolor == true then
					tmp = {0,0,0}
				end

				local col = table.pack(GetVehicleTyreSmokeColor(MyVehicle.vehicle))
				if col[1] == tmp[1] and col[2] == tmp[2] and col[3] == tmp[3] then
					b.purchased = true
					b.sprite = "garage"
				else
					b.purchased = false
					b.sprite = nil
				end
			end
		end
	elseif name == "wariant" then
		for i,b in pairs(m.buttons) do
			if MyVehicle.plateindex == b.plateindex then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "naklejka" then
		for i,b in pairs(m.buttons) do
			if MyVehicle.liveryvariant == b.mod then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "reflektory przednie" then
		for i,b in pairs(m.buttons) do
			if b.mod and MyVehicle.mods[22].mod == b.mod then
				b.purchased = true
				b.sprite = "garage"
			elseif b.color and MyVehicle.headlights == b.color then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "wlew paliwa" or name == "ozdoby" or name == "dokładki #1" or name == "dokładki #2" or name == "dodatki dachu" or name == "drzwi" or name == "klatka" or name == "prawy błotnik" or name == "akcesoria" or name == "rozpórka" or name == "wzór" or name == "konsola" or name == "zegary" or name == "fotele" or name == "kierownica" or name == "ramka" or name == "customowa" or name == "wybierak" or name == "plakietki" or name == "audio" or name == "bagażnik" or name == "turbo" or  name == "pneumatyka" or name == "naklejki" or name == "klakson" or name == "dodatki" then
		for i,b in pairs(m.buttons) do
			if MyVehicle.mods[b.modtype].mod == b.mod then
				b.purchased = true
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	end
end

function GetPrice(price)
	if ESX.PlayerData.job and (ESX.PlayerData.job.name == 'gheneraugarage' or ESX.PlayerData.job.name == 'offgheneraugarage' or ESX.PlayerData.job.name == 'mechanik' or ESX.PlayerData.job.name == 'offmechanik' or ESX.PlayerData.job.name == 'mechanik3' or ESX.PlayerData.job.name == 'offmechanik3' or ESX.PlayerData.job.name == 'mechanik4' or ESX.PlayerData.job.name == 'offmechanik4') then
		price = round(price * 0.40)
	else
		price = round(price * 0.60)
	end

	return price
end

function AddMod(mod, parent, header, name, info, stock)
	local mods = tonumber(GetNumVehicleMods(MyVehicle.vehicle, mod))
	if (mods ~= nil and mods > 0) or mod == 18 or mod == 22 then
		local m = parent:addSubMenu(header, name, info,true)
		if stock then
			local btn = m:addPurchase("Stock")
			btn.modtype = mod
			btn.mod = -1
		end

		if Config.prices.mods[mod].percent or Config.prices.mods[mod].price then
			local price, cfgPercent = Config.prices.mods[mod].price and Config.prices.mods[mod].price or 0, Config.prices.mods[mod].percent and Config.prices.mods[mod].percent or 0
			if cfgPercent > 0 then
				price = round(price + (MyVehicle.price * (cfgPercent / 100)), 0)
			end

			price = GetPrice(price)
			for i = 0, mods do
				local lbl = GetModTextLabel(MyVehicle.vehicle, mod, i)
				if lbl ~= nil then
					local mname = tostring(GetLabelText(lbl))
					if mname == "NULL" then
						local btn = m:addPurchase("Exile #" .. (i + 1), price)
						btn.modtype = mod
						btn.mod = i
					else
						local btn = m:addPurchase(mname, price)
						btn.modtype = mod
						btn.mod = i
					end
				end
			end		
		else
			for n, v in pairs(Config.prices.mods[mod]) do
				local price, tmpPercent = v.price and v.price or 0, v.percent and v.percent or 0
				if tmpPercent > 0 then
					price = round(price + (MyVehicle.price * (tmpPercent / 100)), 0)
				end

				local btn = m:addPurchase(v.name, GetPrice(price))
				btn.modtype = mod
				if v.mod then
					btn.mod = v.mod
				elseif v.color then
					btn.color = v.color
				end
			end
		end
	end
end

OnTuneCheck = function ()
	ontunecheck = ontune
end