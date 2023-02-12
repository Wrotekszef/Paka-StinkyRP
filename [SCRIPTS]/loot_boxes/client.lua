RegisterNUICallback('exile_boxes:NUIoff', function(data, cb)
	SetNuiFocus(false,false)
    SendNUIMessage({
        type = "off"
    })
end)

RegisterNetEvent("exile_boxes:openexilecases")
AddEventHandler("exile_boxes:openexilecases", function(chest, win)
	SetNuiFocus(true,true)
	SendNUIMessage({
    type = "ui",
		data = win.data,
		img = win.img,
		win = win.win
  })
	Wait(15000)
	TriggerServerEvent('exile_boxes:giveReward')
end)