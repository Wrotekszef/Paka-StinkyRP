local selectedspawnposition = nil
local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 1
local cam2Time = 1000
local paleto = {x = -95.2751, y = 6297.564, z = 31.356, h = 304.2 }
local sandy = {x = 1841.279, y = 3668.981, z = 33.679, h = 199.1 }
local pinkcage = {x = 292.3860, y = -223.763, z = 53.978, h = 163.4 }
local hospital = {x = 1155.351, y = -1522.716, z = 34.843, h = 68.04 }
local lspd = {x = 458.74, y = -1008.18, z = 28.27, h = 95.0 }
local vespucci = {x = -1493.36, y = -668.095, z = 29.025, h = 318.4}
local harbor = {x = 792.9912, y = -3066.08, z = 5.9144, h = 353.9}
local airport = {x = -1037.92, y = -2738.80, z = 20.169, h = 333.5}
local loadingPosition = nil
local isOrganizacja = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
    loadingPosition = (ESX.PlayerData.coords or {x = -1037.86, y = -2738.11, z = 20.16})
    TriggerServerEvent('esx_property:deleteLastProperty')
	TriggerServerEvent('esx_propertyaddon:deleteLastProperty')
    TriggerEvent('instance:leave')
end)

RegisterNUICallback("paleto", function()
	selectedspawnposition = paleto
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("airport", function()
	selectedspawnposition = airport
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("hospital", function()
	selectedspawnposition = hospital
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("sandyspawn", function()
	selectedspawnposition = sandy
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("pinkspawn", function()
	selectedspawnposition = pinkcage
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("lspdspawn", function()
	selectedspawnposition = lspd
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("vespucci", function()
	selectedspawnposition = vespucci
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("harbor", function()
	selectedspawnposition = harbor
	selectspawn(selectedspawnposition)
end)

RegisterNUICallback("last", function()
    local last = loadingPosition
    selectedspawnposition = last
    selectspawn(selectedspawnposition)
end)

local OrgsTeleports = {
	Exit = vector3(-786.14, -2567.76, -35.06),
	ExitVehs = vector3(-766.0, -2575.28, -35.97),

	Orgs = {
		--ORG14
		{
			From = vector3(2564.59, 4680.16, 34.07),
			Heading = 66.75,
			Visible = 'org14'
		},
		--ORG15
		{
			From = vector3(1941.67, 3842.43, 35.5),
			Heading = 66.75,
			Visible = 'org15'
		},
		--ORG16
		{
			From = vector3(1002.39, -1527.78, 30.84),
			Heading = 66.75,
			Visible = 'org16'
		},
		--ORG17
		{
			From = vector3(2710.08, 3455.04, 56.31),
			Heading = 66.75,
			Visible = 'org17'
		},
		--ORG18
		{
			From = vector3(1718.94, 4677.26, 43.65),
			Heading = 66.75,
			Visible = 'org18'
		},
		--ORG19
		{
			From = vector3(732.46, 2523.29, 73.37),
			Heading = 66.75,
			Visible = 'org19'
		},
			--ORG 21
		{
			From = vector3(1646.54, 4844.16, 42.01),
			Heading = 269.26,
			Visible = 'org21'
		},
		--ORG 22
		{
			From = vector3(2119.68, 3331.62, 46.78),
			Heading = 269.26,
			Visible = 'org22'
		},
		--ORG 23
		{
			From = vector3(-900.76, -982.45, 2.24),
			Heading = 269.26,
			Visible = 'org23'
		},
		--ORG 24
		{
			From = vector3(-109.74, 2797.84, 53.3),
			Heading = 269.26,
			Visible = 'org24'
		},
		--ORG 25
		{
			From = vector3(1719.54, 4760.49, 42.05),
			Heading = 269.26,
			Visible = 'org25'
		},
		--ORG 26
		{
			From = vector3(917.57, 3655.36, 32.48),
			Heading = 269.26,
			Visible = 'org26'
		},
		--ORG 28
		{
			From = vector3(591.96, 2782.61, 43.48),
			Heading = 290.2,
			Visible = 'org28'
		},
		--ORG 29
		{
			From = vector3(180.09, 2793.31, 45.65),
			Heading = 290.2,
			Visible = 'org29'
		},
		--ORG 30
		{
			From = vector3(83.987129211426, 190.70530700684, 105.2684173584),
			Heading = 269.26,
			Visible = 'org30'
		},
		--ORG 31
		{
			From = vector3(2685.45, 3515.26, 53.3),
			Heading = 269.26,
			Visible = 'org31'
		},
		--ORG 32
		{
			From = vector3(1693.75, 3461.58, 37.03),
			Heading = 269.26,
			Visible = 'org32'
		},
		--ORG 33
		{
			From = vector3(2389.51, 3310.14, 47.64),
			Heading = 269.26,
			Visible = 'org33'
		},
		--ORG 34
		{
			From = vector3(2932.17, 4623.97, 48.72),
			Heading = 269.26,
			Visible = 'org34'
		},
		--ORG 35
		{
			From = vector3(2728.65, 4142.12, 44.28),
			Heading = 269.26,
			Visible = 'org35'
		},
		--ORG 36
		{
			From = vector3(2488.51, 3441.74, 51.07),
			Heading = 269.26,
			Visible = 'org36'
		},
		--ORG 37
		{
			From = vector3(2665.33, 3276.38, 55.24),
			Heading = 269.26,
			Visible = 'org37'
		},
		--ORG 38
		{
			From = vector3(2588.21, 3167.92, 51.36),
			Heading = 269.26,
			Visible = 'org38'
		},
		--ORG 39
		{
			From = vector3(1194.32, 2722.36, 38.62),
			Heading = 269.26,
			Visible = 'org39'
		},
		--ORG 40
		{
			From = vector3(-356.84, -47.51, 54.42),
			Heading = 269.26,
			Visible = 'org40'
		},
		--ORG 41
		{
			From = vector3(2661.15, 3926.88, 42.19),
			Heading = 269.26,
			Visible = 'org41'
		},
		--ORG 42
		{
			From = vector3(2551.2, 347.97, 108.61),
			Heading = 269.26,
			Visible = 'org42'
		},
		--ORG 43
		{
			From = vector3(1713.14, -1555.2, 113.94),
			Heading = 269.26,
			Visible = 'org43'
		},
		--ORG 44
		{
			From = vector3(2832.47, 2800.18, 57.49),
			Heading = 269.26,
			Visible = 'org44'
		},
			--ORG 45
		{
			From = vector3(892.41, -2171.86, 32.28),
			Heading = 269.26,
			Visible = 'org45'
		},
		--ORG 46
		{
			From = vector3(1191.94, -1268.95, 35.31),
			Heading = 269.26,
			Visible = 'org46'
		},
		--ORG 47
		{
			From = vector3(797.6, -1628.5, 31.57),
			Heading = 269.26,
			Visible = 'org47'
		},
		--ORG 48
		{
			From = vector3(2389.5, 3310.16, 47.64),
			Heading = 269.26,
			Visible = 'org48'
		},
		--ORG 49
		{
			From = vector3(913.91, -1273.51, 27.09),
			Heading = 269.26,
			Visible = 'org49'
		},
			--ORG 50
		{
			From = vector3(707.52, -1140.26, 23.44),
			Heading = 269.26,
			Visible = 'org50'
		},
		--ORG 51
		{
			From = vector3(-391.28, 4355.65, 57.66),
			Heading = 269.26,
			Visible = 'org51'
		},
		--ORG 52
		{
			From = vector3(-246.97, 6068.81, 32.34),
			Heading = 269.26,
			Visible = 'org52'
		},
		--ORG 53
		{
			From = vector3(1557.37, 2162.32, 78.67),
			Heading = 269.26,
			Visible = 'org53'
		},
		--ORG 54
		{
			From = vector3(-20.86, 3030.2, 41.68),
			Heading = 269.26,
			Visible = 'org54'
		},
			--ORG 55
		{
			From = vector3(1240.08, -3179.96, 7.14),
			Heading = 269.26,
			Visible = 'org55'
		},
		--ORG 56
		{
			From = vector3(852.13, -1164.04, 25.77),
			Heading = 269.26,
			Visible = 'org56'
		},
		--ORG 57
		{
			From = vector3(1358.5963134766, 3614.6591796875, 34.885078430176),
			Heading = 269.26,
			Visible = 'org57'
		},
		--ORG 58
		{
			From = vector3(1555.93, 2189.56, 78.86),
			Heading = 269.26,
			Visible = 'org58'
		},
		--ORG 59
		{
			From = vector3(-1488.5, -205.86, 50.39),
			Heading = 269.26,
			Visible = 'org59'
		},
		--ORG 60
		{
			From = vector3(201.55, 2462.47, 55.9),
			Heading = 300.11,
			Visible = 'org60'
		},
		--ORG 61
		{
			From = vector3(152.51, 2281.01, 93.94),
			Heading = 300.11,
			Visible = 'org61'
		},
		--ORG 62
		{
			From = vector3(-45.64, 1884.2, 195.52),
			Heading = 300.11,
			Visible = 'org62'
		},
		--ORG 63
		{
			From = vector3(-1131.81, 380.21, 70.73),
			Heading = 300.11,
			Visible = 'org63'
		},
		--ORG 64
		{
			From = vector3(726.85, 4169.07, 40.7),
			Heading = 300.11,
			Visible = 'org64'
		},
		--ORG 65
		{
			From = vector3(-773.59, 5938.0, 23.1),
			Heading = 300.11,
			Visible = 'org65'
		},
		--ORG 66
		{
			From = vector3(780.72, 1274.68, 361.28),
			Heading = 300.11,
			Visible = 'org66'
		},
		--ORG 67
		{
			From = vector3(2041.2596435547, 3181.29296875, 45.094760894775+0.95),
			Heading = 300.11,
			Visible = 'org67'
		},
		--ORG 68
		{
			From = vector3(-765.68, 650.5, 145.69),
			Heading = 300.11,
			Visible = 'org68'
		},
		--ORG 69
		{
			From = vector3(1321.46, 4314.63, 38.33),
			Heading = 300.11,
			Visible = 'org69'
		},
		--ORG 70
		{
			From = vector3(-55.14, 6392.41, 31.61),
			Heading = 300.11,
			Visible = 'org70'
		},
		--ORG 71
		{
			From = vector3(1429.61, 4377.54, 44.59),
			Heading = 300.11,
			Visible = 'org71'
		},
		--ORG 72
		{
			From = vector3(2179.2, 3496.47, 46.01),
			Heading = 300.11,
			Visible = 'org72'
		},
		--ORG 73
		{
			From = vector3(2471.94, 4110.65, 38.06),
			Heading = 300.11,
			Visible = 'org73'
		},
		--ORG 74
		{
			From = vector3(2889.63, 4391.35, 50.45),
			Heading = 300.11,
			Visible = 'org74'
		},
		--ORG 80
		{
			From = vector3(429.43, 2993.56, 41.16),
			Heading = 300.11,
			Visible = 'org80'
		},
		--ORG 81
		{
			From = vector3(830.33, 2193.49, 52.25),
			Heading = 269.26,
			Visible = 'org81'
		},
		--ORG 82
		{
			From = vector3(221.1, 2602.26, 45.72),
			Heading = 269.26,
			Visible = 'org82'
		},
		--ORG 83
		{
			From = vector3(1961.06, 5184.88, 47.94),
			Heading = 269.26,
			Visible = 'org83'
		},
		--ORG 84
		{
			From = vector3(-480.95, 6266.42, 13.63),
			Heading = 269.26,
			Visible = 'org84'
		},
		--ORG 85
		{
			From = vector3(-105.65, 6528.57, 30.17),
			Heading = 269.26,
			Visible = 'org85'
		},
		--ORG 86
		{
			From = vector3(281.63, 6789.26, 15.85),
			Heading = 269.26,
			Visible = 'org86'
		},
		--ORG 87
		{
			From = vector3(-1101.62, 4940.76, 218.35),
			Heading = 269.26,
			Visible = 'org87'
		},
		--ORG 88
		{
			From = vector3(-1604.36, -832.72, 10.26),
			Heading = 269.26,
			Visible = 'org88'
		},
		--ORG 89
		{
			From = vector3(614.63, 2784.32, 43.48),
			Heading = 269.26,
			Visible = 'org89'
		},
		--ORG 90
		{
			From = vector3(2755.20, 2796.38, 33.97),
			Heading = 34.74,
			Visible = 'org90'
		},
		--ORG 91
		{
			From = vector3(307.9, 360.11, 105.34),
			Heading = 269.26,
			Visible = 'org91'
		},
		--ORG 92
		{
			From = vector3(581.03, 139.24, 99.47),
			Heading = 269.26,
			Visible = 'org92'
		},
		--ORG 93
		{
			From = vector3(2179.07, 3496.37, 46.01),
			Heading = 269.26,
			Visible = 'org93'
		},
		--ORG 94
		{
			From = vector3(304.59, 2821.0, 43.43),
			Heading = 269.26,
			Visible = 'org94'
		},
		--ORG 95
		{
			From = vector3(2987.98, 3481.61, 72.49),
			Heading = 269.26,
			Visible = 'org95'
		},
		--ORG 96
		{
			From = vector3(2554.25, 4668.09, 34.03),
			Heading = 269.26,
			Visible = 'org96'
		},
		--ORG 97
		{
			From = vector3(2581.08, 464.92, 108.62),
			Heading = 269.26,
			Visible = 'org97'
		},
		--ORG 98
		{
			From = vector3(1967.18, 4634.18, 41.08),
			Heading = 269.26,
			Visible = 'org98'
		},
		--ORG 99
		{
			From = vector3(216.65, 1191.92, 225.78),
			Heading = 269.26,
			Visible = 'org99'
		},
		--ORG 100
		{
			From = vector3(315.76, 502.02, 153.17),
			Heading = 269.26,
			Visible = 'org100'
		},
		--ORG 101
		{
			From = vector3(-3191.02, 1297.67, 19.07),
			Heading = 269.26,
			Visible = 'org101'
		},
		--ORG 102
		{
			From = vector3(387.51, 3584.71, 33.29),
			Heading = 269.26,
			Visible = 'org102'
		},
		--ORG 103
		{
			From = vector3(-263.95, 2196.63, 130.39),
			Heading = 269.26,
			Visible = 'org103'
		},
		--ORG 104
		{
			From = vector3(-1996.32, 591.18, 118.1),
			Heading = 269.26,
			Visible = 'org104'
		},
		--ORG 105
		{
			From = vector3(-326.21, -1295.57, 31.37),
			Heading = 269.26,
			Visible = 'org105'
		},
		--ORG 106
		{
			From = vector3(1215.0, 334.94, 81.99),
			Heading = 269.26,
			Visible = 'org106'
		},
		--ORG 107
		{
			From = vector3(204.62, -2014.91, 18.59),
			Heading = 269.26,
			Visible = 'org107'
		},
		--ORG 108
		{
			From = vector3(1211.34, 1857.38, 78.96),
			Heading = 269.26,
			Visible = 'org108'
		},
		--ORG 109
		{
			From = vector3(-1307.45, -1318.24, 4.87),
			Heading = 269.26,
			Visible = 'org109'
		},
		--ORG 110
		{
			From = vector3(1811.74, 3920.39, 33.69),
			Heading = 269.26,
			Visible = 'org110'
		},
		--ORG 111
		{
			From = vector3(-54.12, 374.71, 112.43),
			Heading = 269.26,
			Visible = 'org111'
		},
		--ORG 112
		{
			From = vector3(-1100.36, 2722.32, 18.8),
			Heading = 269.26,
			Visible = 'org112'
		},
		--ORG 113
		{
			From = vector3(-2543.82, 2316.05, 33.21),
			Heading = 269.26,
			Visible = 'org113'
		},
		--ORG 114
		{
			From = vector3(48.13, 6306.12, 31.49),
			Heading = 269.26,
			Visible = 'org114'
		},
		--ORG 115
		{
			From = vector3(-87.83, 6494.58, 32.1),
			Heading = 269.26,
			Visible = 'org115'
		},
		--ORG 116
		{
			From = vector3(1469.79, 6551.4, 14.68),
			Heading = 269.26,
			Visible = 'org116'
		},
		--ORG 117
		{
			From = vector3(-358.6, 6061.81, 31.5),
			Heading = 269.26,
			Visible = 'org117'
		},
		--ORG 118
		{
			From = vector3(-288.45, 6299.19, 31.49),
			Heading = 269.26,
			Visible = 'org118'
		},
		--ORG 119
		{
			From = vector3(-55.12, 6392.43, 31.61),
			Heading = 269.26,
			Visible = 'org119'
		},
		--ORG 120
		{
			From = vector3(-686.41, -2451.93, 15.12),
			Heading = 269.26,
			Visible = 'org120'
		},
		--ORG 121
		{
			From = vector3(-1835.49, 4521.66, 5.29),
			Heading = 269.26,
			Visible = 'org121'
		},
		--ORG 122
		{
			From = vector3(940.02, -1480.48, 30.10),
			Heading = 269.26,
			Visible = 'org122'
		},		
		--ORG 123
		{
			From = vector3(181.838, 6393.70, 31.38),
			Heading = 269.26,
			Visible = 'org123'
		},	
		--ORG 124
		{
			From = vector3(747.21, 6457.35, 31.70),
			Heading = 269.26,
			Visible = 'org124'
		},	
		--ORG 125
		{
			From = vector3(2424.01, 4021.48, 36.78),
			Heading = 269.26,
			Visible = 'org125'
		},	
		--ORG 126
		{
			From = vector3(2720.80, 4140.0, 43.96),
			Heading = 269.26,
			Visible = 'org126'
		},	
		--ORG 127
		{
			From = vector3(2663.34, 3277.62, 55.24),
			Heading = 269.26,
			Visible = 'org127'
		},	
		--ORG 128
		{
			From = vector3(2053.21, 2943.39, 47.64),
			Heading = 269.26,
			Visible = 'org128'
		},	
		--ORG 129
		{
			From = vector3(-42.05, 1881.23, 195.90),
			Heading = 269.26,
			Visible = 'org129'
		},	
		--ORG 130
		{
			From = vector3(-849.79, 5409.75, 34.71),
			Heading = 269.26,
			Visible = 'org130'
		},	
		--ORG 131
		{
			From = vector3(-425.9, 6357.18, 13.33),
			Heading = 269.26,
			Visible = 'org131'
		},	
		--ORG 132
		{
			From = vector3(2150.62, 4790.14, 40.99),
			Heading = 269.26,
			Visible = 'org132'
		},	
		--ORG 133
		{
			From = vector3(1798.94, 4610.73, 37.18),
			Heading = 269.26,
			Visible = 'org133'
		},	
		--ORG 134
		{
			From = vector3(561.96, 2594.27, 42.98),
			Heading = 269.26,
			Visible = 'org134'
		},	
		--ORG 135
		{
			From = vector3(-287.11, 2535.66, 75.25),
			Heading = 269.26,
			Visible = 'org135'
		},	
		--ORG 136
		{
			From = vector3(-397.01, 877.50, 230.80),
			Heading = 269.26,
			Visible = 'org136'
		},	
		--ORG 137
		{
			From = vector3(-1507.12, 1505.29, 115.28),
			Heading = 269.26,
			Visible = 'org137'
		},	


		-- ORGANIZACJE MAFIA
		{

			From = vector3(1394.9, 1149.82, 114.33),
			Heading = 90.0,
			Visible = 'org27'
		},
		--org45 limitowany dom
		{
			From = vector3(-1280.8353271484, 510.31872558594, 97.553527832031),
			Heading = 90.0,
			Visible = 'org45',
		},
		--KRZYCHA ORGANIZACJA ORG63--
		{
			From = vector3(-1138.2, 366.1, 70.3),
			Heading = 90.0,
			Visible = 'org63',
		},
		-- GANG ORG1
		{
			From = vector3(-163.94, -1618.21, 33.64),
			Heading = 90.0,
			Visible = 'org1',
		},
		-- GANG ORG30
		{
			From = vector3(-1488.4815673828, 840.94268798828, 176.21939086914),
			Heading = 90.0,
			Visible = 'org30',
		},
		-- GANG ORG2
		{
			From = vector3(1249.86, -1581.82, 58.35),
			Heading = 90.0,
			Visible = 'org2',
		},
		-- GANG ORG3
		{
			From = vector3(-646.04, -1242.02, 11.55),
			Heading = 90.0,
			Visible = 'org3',
		},
		-- GANG ORG4
		{
			From = vector3(-1574.6, -409.46, 47.36),
			Heading = 90.0,
			Visible = 'org4',
		},
		-- GANG ORG5
		{
			From = vector3(107.03, -1969.94, 20.91),
			Heading = 90.0,
			Visible = 'org5',
		},
		-- GANG ORG6
		{
			From = vector3(485.36, -1533.67, 29.28),
			Heading = 90.0,
			Visible = 'org6',
		},
		-- GANG ORG7
		{
			From = vector3(337.36, -2012.01, 21.49),
			Heading = 90.0,
			Visible = 'org7',
		},
		-- GANG ORG8
		{
			From = vector3(435.74, -1888.66, 30.83),
			Heading = 90.0,
			Visible = 'org8',
		},
		-- GANG ORG9
		{
			From = vector3(986.15, -133.65, 77.99),
			Heading = 90.0,
			Visible = 'org9',
		},
		-- GANG ORG10
		{
			From = vector3(1374.82, -2093.8, 47.7),
			Heading = 90.0,
			Visible = 'org10',
		},
		-- GANG ORG11
		{
			From = vector3(889.12, -475.89, 59.10),
			Heading = 90.0,
			Visible = 'org11',
		},
		-- GANG ORG12
		{
			From = vector3(-1975.2, 248.77, 86.91),
			Heading = 90.0,
			Visible = 'org12',
		},
		-- GANG ORG13
		{
			From = vector3(811.83, -2311.81, 29.56),
			Heading = 90.0,
			Visible = 'org13',
		},
		-- GANG ORG16
		{
			From = vector3(1002.39, -1527.78, 30.84),
			Heading = 90.0,
			Visible = 'org16',
		},
	}
}



local tpcoords = nil

RegisterNetEvent('exile_teleports:basecoords', function()
	CreateThread(function()
		for i=1, #OrgsTeleports.Orgs do
			if OrgsTeleports.Orgs[i].Visible == ESX.PlayerData.thirdjob.name then
				tpcoords = OrgsTeleports.Orgs[i].From
			end
		end
	end)
end)

RegisterNUICallback("tporg", function()
    if ESX.PlayerData.thirdjob ~= nil and ESX.PlayerData.thirdjob.name ~= 'unemployed' then
		TriggerEvent('exile_teleports:basecoords')
		Wait(1000)
		if tpcoords then			
			selectedspawnposition = tpcoords
			selectspawnorg(selectedspawnposition)
			
			TriggerServerEvent('esx_property:deleteLastProperty')
			TriggerEvent('instance:leave')
			SetNuiFocus(false, false)
			SendNUIMessage({
				type = 'close'
			})
		else
			ESX.ShowNotification('~r~Coś poszło nie tak, spróbuj ponownie później!')
		end
    end
end)

function selectspawn(par1)
	local playerPed = PlayerPedId()
	local campos = selectedspawnposition
	local cam2, cam = nil, nil
	cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
	PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
	SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
	if DoesCamExist(cam) then
	    DestroyCam(cam, true)
	end
	Wait(cam1Time)
	
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
	PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
	SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
	SpawnPlayer(selectedspawnposition)

end

function selectspawnorg(par1)
	local playerPed = PlayerPedId()
	local campos = selectedspawnposition
	local cam2, cam = nil, nil
	cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
	PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
	SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
	if DoesCamExist(cam) then
	    DestroyCam(cam, true)
	end
	Wait(cam1Time)
	
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
	PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
	SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
	SpawnPlayer(selectedspawnposition)

end

RegisterNetEvent('codem:client:openui')
AddEventHandler('codem:client:openui',function(isDead)
    local days = {"Niedziela", "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota"}
    local saat = GetClockHours()
    local min = GetClockMinutes()
    local players 
    local day =  days[GetClockDayOfWeek()]
	local isOrganizacja
	local isd = false 
	if ESX.PlayerData.thirdjob ~= nil and ESX.PlayerData.thirdjob.name ~= 'unemployed' then
		isOrganizacja = true
	end

    if isDead then
        isd = true
    end

    if saat < 10 then 
        saat = '0'..saat 
    end
    if min < 10 then 
        min = '0'..min 
    end

  ESX.TriggerServerCallback('codem:server:totalplayer',function(result)
    if result ~= nil then
		if ESX.PlayerData.job ~= nil then
			SetNuiFocus(true, true)
			SendNUIMessage({
				type = "open",
				zaman = saat..':'..min,
				gun = day,
				oyuncu = result,
				bw = isd,
				org = isOrganizacja,
				job = ESX.PlayerData.job.name
			})
		end
    else
        players = 'null'
    end
  end)

end)

local cloudOpacity = 0.01
local muteSound = true

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end


function InitialSetup()
    ToggleSound(muteSound)
    SwitchOutPlayer(PlayerPedId(), 0, 1)
end

function SpawnPlayer(Location)
    local pos = Location
    local ped = PlayerPedId()
    
    SetNuiFocus(false, false)

    InitialSetup()
    Wait(500)
    SetEntityCoords(ped, pos.x, pos.y, pos.z)
    Wait(500)
    SetEntityCoords(ped, pos.x, pos.y, pos.z)
    SetEntityHeading(ped, 80.0)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    Wait(500)
    SetNuiFocus(false, false)

    ShutdownLoadingScreen()
    
    ClearScreen()
    Wait(0)
    DoScreenFadeOut(0)

    ShutdownLoadingScreenNui()
    
    ClearScreen()
    Wait(0)
    ClearScreen()
    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Wait(0)
        ClearScreen()
    end
    
    local timer = GetGameTimer()

    while true do
        ClearScreen()
        Wait(0)
        
        if GetGameTimer() - timer > 500 then
            
            ToggleSound(false)
            SwitchInPlayer(PlayerPedId())
            ClearScreen()
            while GetPlayerSwitchState() ~= 12 do
                Wait(0)
                ClearScreen()
            end

            break
        end
    end
    
    ClearDrawOrigin()
	SetEntityVisible(GetPlayerPed(-1), true)
end