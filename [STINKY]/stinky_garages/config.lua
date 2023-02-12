Impound = {}
CoOwner = {}
SellCar = {}
PoliceImpound = {}
Destroy = {}
Config = {
    Locale = 'pl',
	Sprite = 289,
	Colour = 38,
	Colour2 = 37,
	Colour3 = 47
}

Config.Garage = {
	-- Widoczne blipy
	{x = -51.075996398926, y = -1114.0532226563, z = 26.670249938965, blip = false}, --- Broker
	{x = 177.59004211426, y = -922.12286376953, z = 30.686807632446, blip = false}, --- spawn
	{x = 1864.74, y = 3692.51, z = 33.97, blip = false}, --- Komenda Sandy 
	{x = -550.48, y = -158.55, z = 38.23, blip = false}, --- Komenda Rockford
	{x = 389.87, y = -1612.94, z = 29.291955947876, blip = false}, --- Komenda Davis
	{x = -776.92, y = -2569.67, z = -35.06, blip = false}, -- GARAZ W BAZACH ORGANIZACJI
	{x = -1771.9118652344, y = 3105.388671875, z = 32.795722961426, blip = false}, --- Baza Wojskowa
	{x = 799.75793457031, y = -726.77526855469, z = 27.850521087646, blip= false}, -- Pizzeria
	{x = 491.19, y = -1335.91, z = 29.32, blip= true}, --- Odholownik obok mission row 155
	{x = 854.8, y = -2123.53, z = 30.54, blip = true}, --- Mechanik LST
	{x = -312.80, y = 229.28, z = 87.87, blip = false}, --- Chata jelon
	{x = -2035.5, y = -262.6, z = 23.38, blip = true}, --- Odholownik obok kościoła 603
	{x = -286.72, y = -1093.69, z = 23.78, blip = true}, --- Benner 383
	{x = -137.19, y = -1168.03, z = 23.76, blip = true}, --- Odholownik centrum 394
	{x = -366.69, y = -43.45, z = 54.42, blip = false}, --- Nad bankiem fleeca 529
	{x = 847.76, y = -2342.69, z = 30.33, blip = false}, --- Pomarańczowa ośka 61 
	{x = -707.47, y = -869.35, z = 23.43, blip = false}, --- Za stacją 366
	{x = -444.64, y = -2283.52, z = 7.6, blip = false}, --- Black medyk przy mazebank arenie 87
	{x = 1371.9, y = -2077.15, z = 51.99, blip = false}, --- Ośka BD 53 
	{x = -699.64, y = -2226.29, z = 5.89, blip = true}, --- Okolice nauki jazdy 81
	{x = -779.24, y = 5582.03, z = 33.48, blip = true}, --- Black medyk paleto 3003
	{x = 198.91, y = -3126.44, z = 5.79, blip = false}, --- Okolice pralni siana 24
	{x = 2536.76, y = 2580.64, z = 37.94, blip = true}, --- Dino sandy 960
	{x = -2528.02, y = 2341.23, z = 33.05, blip = true}, --- Stacja droga68 1001
	{x = 75.7923, y = 6365.6025, z = 30.2805+0.9, blip = true}, --- Odholownik paleto 3021 
	{x = 1161.71, y = -1494.22, z = 34.69, blip = true}, --- Szpital klinika 178
	{x = 1488.26, y = 3744.710, z = 33.80, blip = true}, --- Odholownik sandy 1017
	{x = -2195.02, y = 4267.44, z = 48.52, blip = true}, --- Za bazą wojskową 2001
	{x = 703.91, y = -981.03, z = 24.132, blip = false}, --- Krawiec 224 
	{x = 1422.44, y = -1504.34, z = 60.89, blip = false}, --- Ośka Marabunty 188
	{x = -613.20, y = 190.43, z = 70.00, blip = false}, --- XGamer 514
	{x = 327.750, y = -204.980, z = 54.09, blip = true}, --- Urzędnicza 582
	{x = -1469.39, y = -657.17, z = 29.50, blip = true}, --- Kebab 619
	{x = 1122.24, y = 2652.33, z = 37.99, blip = false}, --- Sandy naprzeciwko banku 939
	{x = -1062.04, y = -1152.41, z = 2.15, blip = true}, --- Vespucci Canals 336
	{x = -1171.03, y = -880.31, z = 14.1, blip = false}, --- Burgershot 333
	{x = -1551.5720214844, y = 131.82368469238, z = 56.786361694336, blip = false}, --- Playboy 648
	{x = -3146.09, y = 1084.69, z = 20.69, blip = true}, --- Great Ocean Highway 908
	{x = 76.31, y = -1549.52, z = 29.46, blip = true}, --- Milkman 128
	{x = -635.25, y = -1653.79, z = 25.82, blip = false}, --- Za złomowiskiem 386
	{x = 40.07, y = -863.97, z = 30.55, blip = true}, --- Parking główny 399
	{x = 885.98, y = -38.22, z = 78.76, blip = true}, --- Kasyno parking 404
	{x = -926.0, y = -163.99, z = 41.88, blip = true}, --- Naprzeciwko pola golfowego 669
	{x = -944.20629882813, y = -1532.0119628906, z = 5.0621476173401, blip = true}, --- LaPuertaPlaza 340
	{x = -1194.04, y = -1490.86, z = 4.38, blip = true}, --- Parking przy plaży 307
	{x = 1688.43, y = 4774.03, z = 41.92, blip = true}, --- Grapeseed obok sklepu z ubraniami 2015
	{x = 572.16, y = 2724.44, z = 42.06, blip = true}, --- Zoologiczny sandy 930
	{x = -1879.58, y = -308.17, z = 49.23, blip = true}, --- Hotel przy cmentarzu 613 
	{x = 2769.66, y = 3467.82, z = 55.57, blip = true}, --- Techniczny sandy 956
	{x = 333.21, y = -2038.74, z = 21.06, blip = true}, --- Ośka Vagosów 139
	{x = 1004.04, y = -2336.67, z = 30.51, blip = true}, --- Industrialne 64
	{x = -334.79, y = -751.01, z = 33.97, blip = true}, --- Czerwony parking 381
	{x = -1392.48, y = 80.49, z = 53.95, blip = true}, --- Pole golfowe 662
	{x = -2973.64, y = 70.09, z = 11.6, blip = true}, --- Great Ocean Highway 811
	{x = 2587.52, y = 419.76, z = 108.46, blip = true}, --- Stacja wschodnia autostrada 402
	{x = -1039.03, y = -2714.28, z = 13.81, blip = true}, --- Lotnisko 98 
	{x = 1366.88, y = -579.59, z = 74.38, blip = true}, --- Patelnia mirror park 444
	{x = -1093.5, y = -1047.61, z = 2.15, blip = false}, --- Vespucci Canals 335
	{x = 461.36, y = 239.93, z = 103.21, blip = true}, --- Po prawej od pacyfica 590
	{x = -795.99, y = 319.41, z = 85.68, blip = true}, --- Eclipse 501
	{x = -2322.01, y = 292.92, z = 169.46, blip = true}, --- Kortz Center 816
	{x = -515.5114, y = -295.2323, z = 35.501, blip = true}, --- Urząd przy szpitalu Mounth Zonah 507
	{x = 162.8165, y = -3335.345, z = 4.9943+1.0, blip = true}, --- Obok pralni siana 39
	{x = -410.7779, y = 1209.1434, z = 324.6917+0.9, blip = true}, --- Obserwatorium 703
	{x = 1188.7007, y = -3247.1418, z = 5.0788+0.9, blip = true}, --- Doki stary postop 19
	{x = -56.2495, y =  220.9092, z = 105.6039+0.9, blip = true}, --- Klub galaxy 560
	{x = 4970.3989, y =  -5746.2803, z = 18.9302+0.9, blip = true}, --- Cayo perico villa 
	{x = 954.15, y = 22.6, z = 81.15, blip = false}, --- Kasyno środek 400
	{x = 756.1909, y = 2533.8074, z = 72.1707+0.99, blip = false}, --- Rebel budowa sandy 931
	{x = -1021.8325, y = -510.2822, z = 35.1448+0.9, blip = true}, --- Plan filmowy 647 
	{x = -720.96, y = 507.73, z = 108.40, blip = false}, --- Chata limitowana 889 
	{x = 119.8747, y = -131.3839, z = 54.8847, blip = false}, --- Stary cardealer niedaleko urzędniczej 580
	{x = 2451.4944, y = 4997.7998, z = 46.0398, blip = false}, --- Grapeseed przy chacie 2025
	{x = 2564.6553, y = 4696.4478, z = 34.0779, blip = false}, --- Grapeseed naprzeciwko zbiórki milkmana 2026
	{x = 120.05, y = -1062.05, z = 29.19, blip = false}, --- Kwadraciak za bankiem fleeca 206
	{x = -524.4675, y = -888.9473, z = 24.1331, blip = false}, --- Weazel News 372
	{x = -1918.89, y = 2056.68, z = 140.98, blip = false}, --- Winiarnia 911
	{x = -1531.33, y = 889.68, z = 181.87, blip = false}, --- Chata limitowana 844
	{x = -395.08, y = 6312.73, z = 28.97, blip = false}, --- Chata paleto przy plaży 3009
	{x = -52.84, y = 6622.55, z = 29.95, blip = false}, --- Chata paleto przy plaży 3022
	{x = -626.1, y = 56.4, z = 43.73, blip = false}, --- Tinsel Towers 517
	{x = 842.7112, y = -1317.491, z = 26.1, blip = false}, --- Komenda obok divo 167
	{x = -1175.86, y = 290.47, z = 68.54, blip = false}, --- Obok pola golfowego 661
	{x = -893.9, y = -344.26, z = 34.53, blip = false}, --- Parking podziemny niedaleko planu filmowego 665
	{x = -1790.13, y = 460.61, z = 127.35, blip = false}, --- Chata limitowana 838
	{x = 279.34, y = -611.91, z = 43.22, blip = false}, --- Szpital Pillbox góra 201
	{x = 323.23, y = -547.83, z = 28.74, blip = false}, --- Szpital Pillbox dół 201
	{x = 2111.63, y = 4768.57, z = 41.19, blip = false}, --- Lotnisko grapeseed 2023
	{x = -127.1867, y = 1006.7983, z = 235.7, blip = false}, --- Chata limitowana 712
	{x = 838.7579, y = -3237.3801, z = -98.60, blip = false}, --- Jakaś baza pod dokami 13
	{x = -673.4064, y = 908.9037, z = 229.5074+0.9, blip = false}, --- Chata limitowana 893
	{x = -2584.03, y = 1701.9906, z = 140.4129, blip = false}, --- Helipad Chata limitowana pomiędzy 909 a 910
	{x = -187.3387, y = -1585.7897, z = 33.875+1.3, blip = false}, --- Forum drive 107
	{x = -1532.9789, y = 81.9971, z = 55.817+1.0, blip = false}, --- Playboy 648
	{x = -824.0345, y = 182.1567, z = 70.8006+1.2, blip = false}, --- Chata limitowana 692
	{x = 928.8199, y = -573.2177, z = 56.3764+1.2, blip = false}, --- Chata mirror park 429
	{x = 943.9417, y = -669.912, z = 57.061+1.2, blip = false}, --- Chata mirror park 420
	{x = 1989.6538, y = 3032.6936, z = 45.696+1.7, blip = false}, --- Yellow jack sandy 949
	{x = 1412.3381, y = 1109.8804, z = 113.8785+1.7, blip = false}, --- LaFuenta garaż 722
	{x = -1061.8348, y = 302.9888, z = 65.0022+1.7, blip = false}, --- Chata limitowana 674
	{x = 1393.88, y = 1117.17, z = 114.83, blip = false}, --- LaFuenta 722
	{x = -709.7434, y = 651.3831, z = 154.2255+1.5, blip = false}, --- Chata limitowana 891
	{x = -1749.7373, y = 365.9608, z = 88.7746+1.5, blip = false}, --- Chata limitowana 841
	{x = 313.7811, y = -1104.6948, z = 28.452+1.5, blip = false}, --- Melina obok MR 212
	{x = -1548.8711, y = 428.4748, z = 108.382+1.5, blip = false}, --- Chata limitowana 845
	{x = -1556.32, y = -389.72, z = 41.98+0.1, blip = false}, --- Ośka bloodsów 625
	{x = -2604.8188, y = 1675.7346, z = 141.713, blip = false}, --- Chata limitowana pomiędzy 909 a 910
	{x = -13.6885, y = -1414.7452, z = 28.8617, blip = false}, --- Ośka GSF 126
	{x = -1098.7319, y = 359.5399, z = 68.0414, blip = false}, --- Chata limitowana 667
	{x = -1547.1282, y = 880.796, z = 180.3436, blip = false}, --- Chata limitowana 844
	{x = -948.3535, y = 575.1801, z = 100.2000, blip = false}, --- Chata limitowana 880
	{x = -84.3419, y = -822.5928, z = 35.078, blip = false}, --- Parking podziemny 391
	{x = 53.6596, y = 476.7289, z = 145.9882, blip = false},  --- Chata limitowana 573
	{x = 2008.7709, y = 4984.708, z = 41.3293, blip = false}, --- Grapeseed niedaleko strefy 2020
	{x = 13.3717, y = 548.4252, z = 176.1719, blip = false}, --- Chata limitowana 564
	{x = -108.9362, y = 833.3428, z = 234.7666, blip = false}, -- THW 
	{x = 584.4418, y = 2788.7898, z = 41.2419, blip = false}, -- UTS
	{x = 821.9487, y = -2333.6594, z = 30.5148, blip = false}, -- OIOM
	{x = 982.1855, y = 982.1855, z = 73.111, blip = false}, -- MDM
	{x = 975.6122, y = -119.6026, z = 74.185, blip = false}, -- Losty
	{x = 1730.8621, y = 4830.605, z = 26.5319, blip = false}, -- Ocean Family
	{x = 797.2075, y = -2299.5796, z = 14.7542, blip = false}, -- NTS
	{x = -1097.1548, y = 4922.5317, z = 215.9822, blip = false}, -- MOB
	{x = 939.6608, y = -1472.2197, z = 30.1525, blip = false}, -- CLK 
	{x = 62.2607, y = 2362.3618, z = 78.5711, blip = false}, -- KGB
	{x = -1975.4038, y = 260.8438, z = 87.2691, blip = false}, -- N1554
	{x = -919.93, y = 109.45, z = 54.37, blip = false}, -- Assynu
	{x = 379.7284, y = -6.0568, z = 82.0332+0.9, blip = false}, -- Hotel of Baza stary
	{x = -1792.7058, y = 405.4841, z = 112.3389, blip = false}, -- Cartel Krzyca
	{x = -1780.4541, y = 458.1206, z = 127.3591, blip = false}, -- Cartel Krzyca
	{x = 4758.5684, y = -4788.02, z = 0.0983+1.5, blip = false}, -- Cartel Krzyca
	{x = 1192.3976, y = -2892.2915, z = -1.1287+2.3, blip = false}, -- Cartel Krzyca
	{x = 4805.334, y = -4716.0933, z = 5.7644+1.5, blip = false}, -- Cartel Krzyca
	{x = 1201.3181, y = -2909.3315, z = 4.9491+0.8, blip = false}, -- Cartel Krzyca
	{x = -1555.619, y = 21.7245, z = 57.6785+0.9, blip = false}, -- Cartel Krzyca
	{x = 100.0952, y = 2297.5342, z = 77.4537+0.9, blip = false}, -- ODV
	{x = -216.0012, y = -1496.121, z = 31.3001, blip = false}, -- GSF
	{x = 103.34, y = -1939.92, z = 20.80, blip = false}, -- BALLAS
	{x = -161.03, y = 2610.03, z = 32.51, blip = false}, -- SICARIOS
	{x = -526.7471, y = 528.3375, z = 111.0193, blip = false},
	{x = -2663.9511, y = 1307.2448, z = 146.16+1.5, blip = false},
	{x = -2587.2087, y = 1931.1119, z = 166.3543+1.5, blip = false},
	{x = -316.7922, y = -738.3469, z = 27.0797+1.5, blip = false},
	{x = 1880.5428, y = 3691.135, z = 33.6, blip = false},
	{x = 462.3951, y = -1019.2857, z = 27.1511+0.9, role = "police"}, -- Komenda MR
	{x = -1116.07, y = -856.93, z = 13.52, role = "police"}, -- Komenda Vespucci
	{x = -477.27, y = 6021.38, z = 31.34, role = "police"}, -- Komenda Paleto
	{x = -54.8941, y = -2543.9788, z = 5.06+0.9, role = "police"}, -- Komenda Doki
	{x = 1524.0947, y = 791.8511, z = 76.4973+1.5, role = "police"}, -- Komenda LS Freeway
	{x = 535.47, y = -27.96, z = 70.63, role = "police"}, -- Komenda Vinewood
	{x = 449.5125, y = -1919.1566, z = 24.7307, blip = false},
	{x = 568.6178, y = -1763.6263, z = 29.1689, blip = false},
	{x = 470.3698, y = -1520.5214, z = 29.2899, blip = false}, -- LOS AZTECAS  
	{x = 1256.1346, y = -1592.9822, z = 52.9055, blip = false}, -- MARABUNTA 
	{x = -583.1964, y = -1105.8060, z = 22.1789, blip = false}, -- UwU CAFE
	{x = -873.9523, y = -51.0185, z = 37.5828, blip = false}, -- DOM LIMITOWANY 680
	{x = -2671.9018, y = -555.2043, z = 11.0352, blip = false}, -- JACHT 1 
	{x = -3175.8176, y = -218.7200, z = 11.0352, blip = false}, -- JACHT 2 
	{x = -3453.7561, y = 340.1838, z = 11.0352, blip = false}, -- JACHT 3
	{x = -3528.2590, y = 1514.1503, z = 11.0352, blip = false}, -- JACHT 4
	{x = -3280.0708, y = 2111.0017, z = 11.0352, blip = false}, -- JACHT 5
	{x = 138.91, y = 311.17, z = 112.3, blip = true}, -- MAGAZYN
	{x = 809.41, y = -950.32, z = 25.97, blip = true}, -- DIVO GARAGE NOWY INTERIOR
	{x = -2706.08, y = -48.43, z = 16.10, blip = false}, -- CISON CHATA LIMITOWANA
	{x = 857.12, y = -1050.72, z = 28.50, blip = true}, -- GARAŻ ODHOLOWNIK PRZED DIVO GARAGE
	{x = -639.76, y = -1222.92, z = 11.50, blip = false}, -- YAKUZA
	{x = -1835.19, y = 4522.06, z = 4.50, blip = false}, -- ORG121
	{x = 2860.57, y = 2812.52, z = 33.35, blip = false}, --ORG90 LIMITOWANA
	{x = 4888.61, y = -5185.96, z = 2.60, blip = true}, -- CAYO GARAŻ 1
	{x = 5352.54, y = -5427.31, z = 49.50, blip = true}, -- CAYO GARAŻ 2
	{x = 4917.31, y = -4907.52, z = 3.50, blip = true}, -- CAYO GARAŻ 3
	{x = 5058.60, y = -4627.30, z = 2.80, blip = true}, -- CAYO GARAŻ 4
	{x = 4444.67, y = -4489.70, z = 4.40, blip = true}, -- CAYO GARAŻ 5
	{x = -1944.29, y = 547.78, z = 114.50, blip = false}, -- CHATA LIMITOWANA 831
	{x = -1905.90, y = 416.98, z = 96.23, blip = false}, -- CHATA LIMITOWANA 833
	{x = -68.17, y = 6274.19, z = 31.36, blip = false}, --- rzeźnik garaż
	{x = -1234.01, y = -332.17, z = 36.50, blip = true}, --- garaż przed CD
	{x = 2540.66, y = -379.01, z = 92.15, blip = true}, --- KOMENDA DTU
	{x = 1717.7, y = 3253.4, z = 41.14, blip = true}, --- LOTNISKO SANDY


	{x = 425.76, y = -994.42, z = 25.69, role = "sheriff"}, -- Komenda MR
	{x = -1079.78, y = -883.85, z = 4.6, role = "sheriff"}, -- Komenda Vespucci
	{x = -458.18, y = 6043.85, z = 31.34, role = "sheriff"}, -- Komenda Paleto
	{x = -88.9, y = -2525.92, z = 6.0, role = "sheriff"}, -- Komenda Doki
	{x = 1480.58, y = 751.41, z = 77.44, role = "sheriff"}, -- Komenda LS Freeway
	{x = 539.81, y = -41.65, z = 70.79, role = "sheriff"}, -- Komenda Vinewood

	{x = 902.42, y = -183.88, z = 73.89, role = "taxi"},
	{x = -464.1998, y = -2806.8694, z = 5.0503, role = "courier"},
	{x = 966.63, y = 44.88, z = 80.96, role = "casino"},
	{x = 691.7681, y = -960.2361, z = 22.7102, role = "krawiec"},
	{x = 409.2424, y = 6459.0923, z = 28.859, role = "grower"},
	{x = 140.48, y = -705.95, z = 33.13, role = "doj"},
	{x = -49.56, y = -1844.45, z = 26.28,  blip = false},
	{x = -297.58, y = -2190.27, z = 10.03, blip = false},
	{x = 742.02, y = -3179.01, z = 5.9, blip = false},
	{x = -951.63, y = -1284.01, z = 5.03, blip = true},
	{x = 145.28, y = -1511.52, z = 29.14, blip = false},
	{x = 155.32, y = -2969.34, z = 5.93-0.95, blip = true},
}

Config.Harbors = {
	{x = -910.48, y = -1458.06, z = 1.2, h = 290.0, blip = true},
	{x = 3869.96, y = 4470.27, z = 1.2, h = 267.88, blip = true},
	{x = -500.67, y = 6482.47, z = 1.2, h = 31.31, blip = true},
	{x = -3336.4, y = 992.15, z = 1.2, h = 89.28, blip = true},
	{x = 5101.44, y = -4651.05, z = 1.2, h = 254.95, blip = true},
	{x = -1633.10, y = -1171.45, z = 1.2, h = 132.92, blip = true},
	{x = -2078.00, y = 2596.35, z = 1.2, h = 142.07, blip = true},
	{x = -1599.63, y = 5260.28, z = 1.2, h = 26.44, blip = true},
	{x = 3380.04, y = 5186.75, z = 1.2, h = 276.43, blip = true},
	{x = 177.46, y = -3348.94, z = 1.2, h = 90.94, blip = true},
	{x = 1485.48, y = 3910.63, z = 31.5, h = 78.93, blip = true},
}

Config.Hangar = {
	{x = -724.58, y = -1444.26, z = 5.0, blip = true},
	{x = 1488.6021, y = 1067.1516, z = 113.8, blip = false},
	{x = -1274.51, y = -3386.33, z = 13.94, h = 330.0, blip = true},
	{x = 965.78, y = 42.24, z = 123.13, h = 146.57, blip = false},
	{x = 4432.33, y = -4515.55, z = 4.13, h = 108.73, blip = true},
	{x = -1552.6545410156, y = 845.91027832031, z = 183.66104125977, h = 100, blip = false},
	{x = 2112.5044, y = 4801.3027, z = 41.2103, h = 115.75, blip = true},
	{x = -2036.8712, y= 2875.2366, z = 33.0, h = 61.61, blip = true},
	{x = -966.77, y = -2983.86, z = 14.0, h = 63.62, blip = true},
}

Config.Zones = {
	{x = 1742.7652587891, y = 3299.5983886719, z = 41.223518371582-0.95, marker = 1, blip = false, sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, --- ODCHOLOWNIK LOTNISKO SANDY
	{x = 479.68, y = -1318.18, z = 28.3, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = -191.88, y = -1162.2, z = 23.67-0.95, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 866.67, y = -2135.58, z = 30.54-0.95, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 1530.0034, y = 3777.6526, z = 33.5615, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 93.475, y = 6357.0801, z = 30.4259, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 158.67, y = -2964.27, z = 5.96-0.95, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = -539.06, y = -195.56, z = 38.22-0.95, marker = 1, name = "coowner", label  = "Naciśnij ~INPUT_CONTEXT~ aby zarządzać pojazdem"},
	{x = 484.66, y = -1097.25, z = 29.2, marker = 2, blip = "Parking policyjny", sprite = 56, color = 3, name = "impoundpd", info = 'parkingpd', label  = "Naciśnij ~INPUT_CONTEXT~ wyciągnąć pojazd z parkingu policyjnego"},
	{x = 1881.3739, y = 3700.4404, z = 33.6, marker = 2, blip = "Parking policyjny", sprite = 56, color = 3, name = "impoundpd", info = 'parkingpd', label  = "Naciśnij ~INPUT_CONTEXT~ wyciągnąć pojazd z parkingu policyjnego"},
	{x = -451.27, y = 5990.52, z = 31.34, marker = 2, blip = "Parking policyjny", sprite = 56, color = 3, name = "impoundpd", info = 'parkingpd', label  = "Naciśnij ~INPUT_CONTEXT~ wyciągnąć pojazd z parkingu policyjnego"},
	{x = 269.88, y = -433.19, z = 45.24-0.95, marker = 1, name = "contractT", info = "contractT", label = "Naciśnij ~INPUT_CONTEXT~ aby zakupić umowę kupna/sprzedaży pojazdu"},
	{x = 2528.06, y = 2589.84, z = 37.04, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik dino
	{x = -763.91235351563, y = -2583.4438476563, z = -35.069072723389-0.95, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = -2022.64, y = -255.16, z = 22.52, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 149.46, y = 322.00, z = 111.15, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 846.93, y = -1050.66, z = 27.15, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik przed DG
	{x = -1827.9763183594, y = 4518.1552734375, z = 5.2976865768433-0.95, marker = 1, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"},
	{x = 4436.0361, y = -4476.3115, z = 3.4284, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik CAYO PERICO 1
	{x = 4965.5327, y = -5786.439, z = 19.9277, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik CAYO PERICO 2
	{x = 943.22, y = -1468.51, z = 30.10-0.95, marker = 1, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik ORG121
	{x = 99.90, y = -1966.07, z = 19.8, marker = 1, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik BALLAS
	{x = 2879.40, y = 2799.40, z = 32.4, marker = 1, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik ORG90
	{x = 837.58, y = -975.07, z = 25.97, marker = 2, blip = "Parking mechaników", sprite = 56, color = 3, name = "parkingmech", info = 'parkingmech', label  = "Naciśnij ~INPUT_CONTEXT~ wyciągnąć pojazd z parkingu mechaników"},
	{x = 850.65417480469, y = -2099.1340332031, z = 30.541009902954, marker = 2, blip = "Parking mechaników", sprite = 56, color = 3, name = "parkingmech", info = 'parkingmech', label  = "Naciśnij ~INPUT_CONTEXT~ wyciągnąć pojazd z parkingu mechaników"},
	{x = 2549.34, y = -315.43, z = 92.15, marker = 1, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, -- odholownik KOMENDA DTU
	{x = 179.32933044434, y = -929.09179687, z = 30.686815261841-0.95, marker = 1, blip = "Odholowywanie pojazdów", sprite = 289, color = 5, name = "impound", info = 'impound', label  = "Naciśnij ~INPUT_CONTEXT~ aby odebrać pojazd"}, --- ODCHOLOWNIK LOTNISKO SANDY
}