Citizen.CreateThread(function()
	local cachedIndex = nil

	for index, data in ipairs(Config.Zones) do
		if (data.type == "green") then
			cachedIndex = index
			break
		end
	end

	while true do
		for _, vehicle in ipairs(GetAllVehicles()) do
			for index, bubble in ipairs(Config.Zones[cachedIndex].bubbles) do
				if #(GetEntityCoords(vehicle) - vector3(bubble.x, bubble.y, bubble.z)) < bubble.w then
					if DoesEntityExist(vehicle) then
						DeleteEntity(vehicle)
					end
				end
			end
		end

		Citizen.Wait(2000)
	end
end)