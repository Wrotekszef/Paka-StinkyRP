Config                            = {}
Config.Locale                     = 'pl'

Config.DrawDistance               = 10.0

Config.AuthorizedWeapons = {
  { 
      name = 'clip',
      tableName = 'pistolmk2',
      price = 2000,
      ammo = 1000
  },
  { 
      name = 'WEAPON_SNSPISTOL',
      tableName = 'snspistol',
      price = 50000,
      ammo = 1000
  },
}

Config.InstanceOrgs = {
    Cloakroom = {
        coords = vector3(-785.89, -2570.34, -35.06 -0.99),
    },
    Inventory = {
        from = 1
    },
    Licenses = {
        from = 3
    },
    MainMenu = {
        coords = vector3(-786.40, -2580.33, -35.06 - 0.99),
        from = 5
    },
    LotniaMenu = {
        coords = vector3(1741.7537841797, 3303.4455566406, 41.223461151123-0.95),
        from = 1,
    },
    LotniaMenu2 = {
        coords = vector3(4435.12, -4468.54, 4.32-0.95),
        from = 1,
    },
    LotniaMenu3 = {
        coords = vector3(2548.06, 2581.16, 37.94-0.95),
        from = 1,
    },
    
    Barabasz = {},
}

Config.Blips = {
    -- ORGANIZACJE MAFIA
    ['org27'] = vector3(1399.516, 1139.5142, 113.3857),
    -- ORGANIZACJE GANGI
    ['org1'] = vector3(-156.11, -1616.267, 33.64),
    ['org2'] = vector3(1259.10, -1571.15, 58.35),
    ['org3'] = vector3(-650.31, -1236.35, 11.55),
    ['org4'] = vector3(-1565.02, -405.84, 48.26),
    ['org5'] = vector3(117.50, -1969.54, 21.32),
    ['org6'] = vector3(489.11, -1531.96, 29.28),
    ['org7'] = vector3(350.9563, -2028.8875, 27.5493),
    ['org8'] = vector3(449.0246, -1893.5128, 25.7869),
    ['org9'] = vector3(985.5410, -98.5267, 74.8463),
    ['org10'] = vector3(1373.7263, -2095.7183, 47.6543),
    ['org11'] = vector3(898.8, -480.32, 62.81),
    ['org12'] = vector3(-1973.26, 244.37, 91.22),
    ['org13'] = vector3(812.03, -2311.6, 30.46),
    -- ORGANIZACJE BOJÓWKI
    ['org16'] = vector3(1002.39, -1527.78, 30.84),
    ['org19'] = vector3(732.24, 2532.07, 73.21),
    ['org29'] = vector3(189.56, 2787.04, 45.59),
    ['org30'] = vector3(89.357040405273, 183.76336669922, 104.61236572266),
    ['org72'] = vector3(2176.74, 3506.08, 44.64),
    ['org73'] = vector3(2465.48, 4101.64, 38.06),
    ['org74'] = vector3(2887.71, 4383.28, 50.3),
    ['org14'] = vector3(2566.6, 4685.93, 34.05),
    ['org15'] = vector3(1949.08, 3824.05, 32.11),
    ['org17'] = vector3(2703.1, 3455.17, 55.63),
    ['org18'] = vector3(1720.68, 4670.11, 43.22),
    ['org21'] = vector3(1646.54, 4844.16, 42.01),
    ['org22'] = vector3(2109.73, 3325.99, 45.35),
    ['org23'] = vector3(-896.88, -985.09, 2.16),
    ['org24'] = vector3(-106.35, 2796.28, 53.34),
    ['org25'] = vector3(1710.79, 4758.21, 41.92),
    ['org26'] = vector3(919.43, 3658.91, 32.5),
    ['org28'] = vector3(588.48, 2786.79, 42.19),
    ['org31'] = vector3(2680.34, 3515.4, 52.71),
    ['org32'] = vector3(1694.29, 3460.63, 37.13),
    ['org33'] = vector3(2389.51, 3310.14, 47.64),
    ['org34'] = vector3(2934.44, 4631.88, 48.54),
    ['org35'] = vector3(2728.65, 4142.12, 44.28),
    ['org36'] = vector3(2488.51, 3441.74, 51.07),
    ['org37'] = vector3(2662.09, 3272.92, 55.24),
    ['org38'] = vector3(2592.44, 3161.17, 50.83),
    ['org39'] = vector3(1174.47, 2725.05, 38.0),
    ['org40'] = vector3(-361.88, -47.8, 54.42),
    ['org41'] = vector3(2661.15, 3926.88, 42.19),
    ['org42'] = vector3(2549.3, 341.68, 108.46),
    ['org43'] = vector3(1706.6, -1555.51, 112.63),
    ['org44'] = vector3(2832.01, 2799.7, 57.51),
    ['org45'] = vector3(-1278.1585693359, 496.93151855469, 97.890342712402),
    ['org64'] = vector3(726.73, 4170.97, 40.7),
    ['org47'] = vector3(784.16, -1625.04, 31.02),
    ['org48'] = vector3(2390.32, 3298.7, 47.49),
    ['org49'] = vector3(911.06, -1265.17, 25.58),
    ['org50'] = vector3(703.63, -1142.61, 23.59),
    ['org51'] = vector3(-388.91, 4340.74, 56.16),
    ['org52'] = vector3(-244.71, 6065.94, 32.34),
    ['org53'] = vector3(1551.95, 2154.23, 78),
    ['org54'] = vector3(-29.6681, 3045.1851, 39.99),
    ['org55'] = vector3(1242.99, -3155.83, 5.52),
    ['org56'] = vector3(841.95, -1162.71, 25.26),
    ['org57'] = vector3(1363.0988769531, 3617.6064453125, 34.891174316406),
    ['org58'] = vector3(1551.36, 2194.76, 78.87),
    ['org59'] = vector3(-1485.11, -199.82, 50.39),
    ['org60'] = vector3(190.44, 2456.29, 55.72),
    ['org61'] = vector3(153.04, 2279.83, 94.01),
    ['org62'] = vector3(-42.1, 1884.59, 195.45),
    ['org63'] = vector3(-1139.1710205078, 370.2868347168, 71.307334899902),
    ['org46'] = vector3(1192.15, -1267.83, 35.16),
    ['org65'] = vector3(-762.14, 5947.61, 20.15),
    ['org66'] = vector3(781.49, 1274.58, 361.28),
    ['org67'] = vector3(604.82232666016, 2784.7900390625, 41.210552215576),
    ['org68'] = vector3(-765.14, 650.72, 145.5),
    ['org69'] = vector3(1320.61, 4314.57, 38.14),
    ['org70'] = vector3(-55.42, 6393.42, 31.49),
    ['org71'] = vector3(1428.98, 4378.15, 44.3),
    ['org80'] = vector3(425.24, 2998.51, 40.46),
    ['org81'] = vector3(825.77, 2191.51, 52.41),
    ['org82'] = vector3(217.67, 2602.98, 45.82),
    ['org83'] = vector3(1963.87, 5180.14, 47.94),
    ['org84'] = vector3(-481.42, 6265.58, 13.41),
    ['org85'] = vector3(-105.76, 6534.99, 29.8),
    ['org86'] = vector3(281.97, 6789.24, 15.69),
    ['org87'] = vector3(-62.147, 834.7532, 234.7679),
    ['org88'] = vector3(-1605.51, -827.14, 10.05),
    ['org89'] = vector3(614.91, 2786.11, 43.48),
    ['org90'] = vector3(2760.50, 2799.44, 33.97),
    ['org91'] = vector3(306.14, 365.3, 105.27),
    ['org92'] = vector3(582.8, 131.28, 98.04),
    ['org93'] = vector3(2175.12, 3504.89, 45.36),
    ['org94'] = vector3(304.59, 2821.0, 43.43),
    ['org95'] = vector3(2988.45, 3481.6, 72.49),
    ['org96'] = vector3(2554.25, 4668.09, 34.03),
    ['org97'] = vector3(2581.08, 464.92, 108.62),
    ['org98'] = vector3(1967.16, 4634.29, 41.1),
    ['org99'] = vector3(216.65, 1191.92, 225.78),
    ['org100'] = vector3(318.55, 494.98, 152.74),
    ['org101'] = vector3(-3177.21, 1295.4, 14.48),
    ['org102'] = vector3(379.41, 3583.48, 33.29),
    ['org103'] = vector3(-264.05, 2196.42, 130.39),
    ['org104'] = vector3(-1993.0, 591.26, 117.9),
    ['org105'] = vector3(-326.62, -1295.48, 31.37),
    ['org106'] = vector3(1214.05, 333.64, 81.99),
    ['org107'] = vector3(207.38, -2016.24, 18.56),
    ['org108'] = vector3(1211.34, 1857.38, 78.96),
    ['org109'] = vector3(-1309.97, -1317.68, 4.87),
    ['org110'] = vector3(1812.57, 3924.07, 33.74),
    ['org111'] = vector3(-52.55, 375.58, 114.08),
    ['org112'] = vector3(-1100.36, 2722.32, 18.8),
    ['org113'] = vector3(-2543.77, 2316.56, 33.21),
    ['org114'] = vector3(48.69, 6305.07, 31.36),
    ['org115'] = vector3(-85.74, 6494.25, 31.49),
    ['org116'] = vector3(1471.21, 6551.58, 14.01),
    ['org117'] = vector3(-358.63, 6062.01, 31.5),
    ['org118'] = vector3(-290.03, 6302.59, 31.49),
    ['org119'] = vector3(-55.42, 6393.42, 31.49),
    ['org120'] = vector3(-688.64, -2454.41, 13.9),
    ['org121'] = vector3(-1835.12, 4520.65, 5.29),
    ['org122'] = vector3(939.44, -1476.99, 30.10),
    ['org123'] = vector3(181.838, 6393.70, 31.38),
    ['org124'] = vector3(747.21, 6457.35, 31.70),
    ['org125'] = vector3(2424.01, 4021.48, 36.78),
    ['org126'] = vector3(2720.80, 4140.0, 43.96),
    ['org127'] = vector3(2663.34, 3277.62, 55.24),
    ['org128'] = vector3(2053.21, 2943.39, 47.64),
    ['org129'] = vector3(-42.05, 1881.23, 195.90),
    ['org130'] = vector3(-849.79, 5409.75, 34.71),
    ['org131'] = vector3(-425.9, 6357.18, 13.33),
    ['org132'] = vector3(2150.62, 4790.14, 40.99),
    ['org133'] = vector3(1798.94, 4610.73, 37.18),
    ['org134'] = vector3(561.96, 2594.27, 42.98),
    ['org135'] = vector3(-287.11, 2535.66, 75.25),
    ['org136'] = vector3(-397.01, 877.50, 230.80),
    ['org137'] = vector3(-1507.12, 1505.29, 115.28),
}


Config.MaleTshirt = 423
Config.MaleTshirtdrugi = 422
Config.FemaleTshirt = 520

Config.MaleVest = 199
Config.FemaleVest = 272

Config.Organizacje = {
    org1 = {
		praca = 'org1',
    },
    org2 = {
		praca = 'org2',
    },
    org3 = {
		praca = 'org3',
    },
    org4 = {
		praca = 'org4',
    },
    org5 = {
		praca = 'org5',
        Tshirt = 1,
		Vest = 21,
    },
    org6 = {
		praca = 'org6',
    },
    org7 = {
		praca = 'org7',
    },
    org8 = {
		praca = 'org8',
    },
    org9 = {
		praca = 'org9',
    },
    org10 = {
		praca = 'org10',
    },
    org11 = {
		praca = 'org11',
    },
    org12 = {
		praca = 'org12',
    },
    org13 = {
		praca = 'org13',
        Tshirt = 8,
		Vest = 10,
    },
    org14 = {
		praca = 'org14',
        Tshirt = 13,
    },
    org15 = {
		praca = 'org15',
    },
    org16 = {
		praca = 'org16',
    },
    org17 = {
		praca = 'org17',
    },
    org18 = {
		praca = 'org18',
    },
    org19 = {
		praca = 'org19',
    },  
    org20 = {
		praca = 'org20',
    },
    org21 = {
		praca = 'org21',
    },
    org22 = {
		praca = 'org22',
        Tshirt = 10,
		Vest = 6,
    },
    org23 = {
		praca = 'org23',
    },
    org24 = {
		praca = 'org24',
    },
    org25 = {
		praca = 'org25',
        Tshirt = 4,
		Vest = 20,
    },
    org26 = {
		praca = 'org26',
    },
    org27 = {
		praca = 'org27',
    },
    org28 = {
		praca = 'org28',
        Tshirt = 2,
		Vest = 15,
    },
    org29 = {
		praca = 'org29',
    },
    org30 = {
		praca = 'org30',
    },
    org31 = {
		praca = 'org31',
        Tshirt = 1,
		Vest = 5,
    },
    org32 = {
		praca = 'org32',
        Tshirt = 5,
		Vest = 8,
    },
    org33 = {
		praca = 'org33',
    },
    org34 = {
		praca = 'org34',
    },
    org35 = {
		praca = 'org35',
    },
    org36 = {
		praca = 'org36',
    },
    org37 = {
		praca = 'org37',
    },
    org38 = {
		praca = 'org38',
    },
    org39 = {
		praca = 'org39',
    },
    org40 = {
		praca = 'org40',
    },
    org41 = {
		praca = 'org41',
        Tshirt = 12,
    },
    org42 = {
		praca = 'org42',
    },
    org43 = {
		praca = 'org43',
    },
    org44 = {
		praca = 'org44',
        Tshirt = 9,
		Vest = 12,
    },
    org45 = {
		praca = 'org45',
    },
    org46 = {
		praca = 'org46',
    },
    org47 = {
		praca = 'org47',
    },
    org48 = {
		praca = 'org48',
    },
    org49 = {
		praca = 'org49',
    },
    org50 = {
		praca = 'org50',
    },
    org51 = {
		praca = 'org51',
    },
    org52 = {
		praca = 'org52',
    },
    org53 = {
		praca = 'org53',
    },
    org54 = {
		praca = 'org54',
    },
    org55 = {
		praca = 'org55',
    },
    org56 = {
		praca = 'org56',
    },
    org57 = {
		praca = 'org57',
    },
    org58 = {
		praca = 'org58',
    },
    org59 = {
		praca = 'org59',
    },
    org60 = {
		praca = 'org60',
    },
    org61 = {
		praca = 'org61',
    },
    org62 = {
		praca = 'org62',
    },
    org63 = {
		praca = 'org63',
    },
    org64 = {
		praca = 'org64',
    },
    org65 = {
		praca = 'org65',
    },
    org66 = {
		praca = 'org66',
    },
    org67 = {
		praca = 'org67',
    },
    org68 = {
		praca = 'org68',
    },
    org69 = {
		praca = 'org69',
        Tshirt = 11,
		Vest = 14,
    },
    org70 = {
		praca = 'org70',
    },
    org71 = {
		praca = 'org71',
    },
    org72 = {
		praca = 'org72',
    },
    org73 = {
		praca = 'org73',
    },
    org74 = {
		praca = 'org74',
    },
    org80 = {
      praca = 'org80',
      },
      org81 = {
      praca = 'org81',
      },
      org82 = {
      praca = 'org82',
      },
      org83 = {
      praca = 'org83',
      },
      org84 = {
      praca = 'org84',
      },
      org85 = {
      praca = 'org85',
      },
      org86 = {
      praca = 'org86',
      },
      org87 = {
      praca = 'org87',
      },
      org88 = {
      praca = 'org88',
      },
      org89= {
      praca = 'org89',
      },
      org90 = {
      praca = 'org90',
      },
      org91 = {
      praca = 'org91',
      },
      org92 = {
      praca = 'org92',
      },
      org93 = {
      praca = 'org93',
      },
      org94 = {
      praca = 'org94',
      },
      org95 = {
      praca = 'org95',
      },
      org96 = {
      praca = 'org96',
      },
      org97 = {
      praca = 'org97',
      },
      org98 = {
        praca = 'org98',
      },
      org99 = {
      praca = 'org99',
      },
      org100 = {
      praca = 'org100',
      },
      org101 = {
      praca = 'org101',
      },
      org102 = {
      praca = 'org102',
      },
      org103 = {
      praca = 'org103',
      },
      org104 = {
      praca = 'org104',
      },
      org105 = {
      praca = 'org105',
      },
      org106 = {
      praca = 'org106',
      },
      org107 = {
      praca = 'org107',
      },
      org108 = {
      praca = 'org108',
      },
      org109 = {
      praca = 'org109',
      },
      org110 = {
      praca = 'org110',
      },
      org110 = {
      praca = 'org111',
      },
      org111 = {
        praca = 'org112',
      },
      org112 = {
      praca = 'org113',
      },
      org113 = {
      praca = 'org114',
      },
      org114 = {
      praca = 'org114',
      },
      org115 = {
      praca = 'org115',
      },
      org116 = {
      praca = 'org116',
      },
      org117 = {
      praca = 'org117',
      },
      org118 = {
      praca = 'org118',
      },
      org119 = {
      praca = 'org119',
      },
      org121 = {
      praca = 'org121',
      },
      org122 = {
      praca = 'org122',
      },
      org120 = {
        praca = 'org120',
      },
      org123 = {
        praca = 'org123',
      }, 
      org124 = {
        praca = 'org124',
      }, 
      org125 = {
        praca = 'org125',
      }, 
      org126 = {
        praca = 'org126',
      }, 
      org127 = {
        praca = 'org127',
      }, 
      org128 = {
        praca = 'org128',
      }, 
      org129 = {
        praca = 'org129',
      }, 
      org130 = {
        praca = 'org130',
      }, 
      org131 = {
        praca = 'org131',
      }, 
      org132 = {
        praca = 'org133',
      }, 
      org134 = {
        praca = 'org134',
      }, 
      org135 = {
        praca = 'org135',
      }, 
      org136= {
        praca = 'org136',
      }, 
      org137 = {
        praca = 'org137',
      }, 
}

Config.Zones = {
    --ORGANIZACJE MAFIA
    ['org27'] = {
        Cloakroom = {
            coords = vector3(1399.516, 1139.5142, 113.3857),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(1394.9, 1149.82, 114.33-0.95),
            from = 5
        },
        Barabasz = {
 
        }
    },

    --org45 limitowany dom
    ['org45'] = {
      Cloakroom = {
          coords = vector3(-1285.9454345703, 483.77767944336, 97.586067199707-0.9),
      },
      Inventory = {
          from = 1
      },
      Licenses = {
          from = 3
      },
      MainMenu = {
          coords = vector3(-1280.8353271484, 510.31872558594, 97.553527832031-0.9),
          from = 5
      },
      Barabasz = {

      }
  },

      --org121 limitowany dom
      ['org121'] = {
        Cloakroom = {
            coords = vector3(-1825.05, 4524.09, 5.28-0.9),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1823.25, 4509.62, 5.28-0.9),
            from = 5
        },
        Barabasz = {
  
        }
    },

      --org122 limitowana baza 176 działka
      ['org122'] = {
        Cloakroom = {
            coords = vector3(932.34, -1463.98, 33.61-0.9),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(944.02, -1463.43, 33.61-0.9),
            from = 5
        },
        Barabasz = {
  
        }
    },   
    
    --ORG90 - LIMITOWANA BAZA 962 DZIAŁKA
    ['org90'] = {
      Cloakroom = {
          coords = vector3(2879.18, 2814.93, 32.45),
      },
      Inventory = {
          from = 1
      },
      Licenses = {
          from = 3
      },
      MainMenu = {
          coords = vector3(2873.78, 2817.56, 32.45),
          from = 5
      },
      Barabasz = {

      }
  },   
    

    --n11554--
    ['org63'] = {
      Cloakroom = {
          coords = vector3(-1143.0, 369.3, 70.3+0.5),
      },
      Inventory = {
          from = 1
      },
      Licenses = {
          from = 3
      },
      MainMenu = {
          coords = vector3(-1138.2, 366.1, 70.3+0.5),
          from = 5
      },
      Barabasz = {

      }
  },
      --KRZYCHA ORGANIZACJA ORG87--
    ['org87'] = {
      Cloakroom = {
        coords = vector3(-51.696174621582, 838.35528564453, 235.71798706055+0.4),
    },
    Inventory = {
       from = 1
   },
      Licenses = {
        from = 3
    },
    MainMenu = {
      coords = vector3(-55.634120941162, 837.2177734375, 235.71798706055+0.4),
        from = 5
  },
  Barabasz = {

    }
},

    --ORGANIZACJE GANGI
    ['org1'] = {
        Cloakroom = {
            coords = vector3(-162.586, -1612.68, 33.64),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-163.94, -1618.21, 33.64),
            from = 5
        },
        Barabasz = {
 
        }
    },
        --ORGANIZACJE GANGI
        ['org30'] = {
          Cloakroom = {
              coords = vector3(-1494.3916015625, 840.69836425781, 176.21939086914),
          },
          Inventory = {
              from = 1
          },
          Licenses = {
              from = 3
          },
          MainMenu = {
              coords = vector3(-1488.4815673828, 840.94268798828, 176.21939086914),
              from = 5
          },
          Barabasz = {
   
          }
      },
    ['org2'] = {
      Cloakroom = {
          coords = vector3(1253.88, -1571.3, 58.74),
      },
      Inventory = {
          from = 1
      },
      Licenses = {
          from = 3
      },
      MainMenu = {
          coords = vector3(1249.86, -1581.82, 58.35),
          from = 5
      },
      Barabasz = {

      }
  },
  ['org3'] = {
    Cloakroom = {
        coords = vector3(-652.05, -1230.39, 11.55),
    },
    Inventory = {
        from = 1
    },
    Licenses = {
        from = 3
    },
    MainMenu = {
        coords = vector3(-646.04, -1242.02, 11.55),
        from = 5
    },
    Barabasz = {

    }
},
    ['org4'] = {
        Cloakroom = {
            coords = vector3(-1568.4, -405.35, 47.36),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1574.6, -409.46, 47.36),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org5'] = {
      Cloakroom = {
          coords = vector3(118.13, -1963.12, 20.55),
      },
      Inventory = {
          from = 1
      },
      Licenses = {
          from = 3
      },
      MainMenu = {
          coords = vector3(119.51, -1968.51, 20.55),
          from = 5
      },
      Barabasz = {

      }
  },
  ['org6'] = {
    Cloakroom = {
        coords = vector3(494.56, -1527.64, 29.28),
    },
    Inventory = {
        from = 1
    },
    Licenses = {
        from = 3
    },
    MainMenu = {
        coords = vector3(485.36, -1533.67, 29.28),
        from = 5
    },
    Barabasz = {

    }
},
    ['org7'] = {
      Cloakroom = {
        coords = vector3(344.7008, -2022.0562, 21.4449),
    },
    Inventory = {
        from = 1
    },
    Licenses = {
        from = 3
    },
    MainMenu = {
        coords = vector3(337.36, -2012.01, 21.49),
        from = 5
        },
        Barabasz = {
 
        }
    },
    ['org8'] = {
        Cloakroom = {
            coords = vector3(433.08, -1890.34, 30.83),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(435.74, -1888.66, 30.83),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org9'] = {
        Cloakroom = {
            coords = vector3(986.62, -92.56, 74.00),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(974.47, -96.56, 74.00),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org10'] = {
        Cloakroom = {
            coords = vector3(1376.18, -2097.63, 47.7),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(1374.82, -2093.8, 47.7),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org11'] = {
        Cloakroom = {
            coords = vector3(907.12, -484.22, 58.54),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(898.63, -480.30, 62.00),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org12'] = {
        Cloakroom = {
            coords = vector3(-1973.4, 244.32, 90.32),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1975.2, 248.77, 86.91),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org13'] = {
        Cloakroom = {
            coords = vector3(806.06, -2333.93, 29.56),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(811.83, -2311.81, 29.56),
            from = 5
        },
        Barabasz = {
 
        }
    },
    ['org16'] = {
      Cloakroom = {
          coords = vector3(-1525.36, 118.71, 55.64-0.95),
      },
      Inventory = {
          from = 1
      },
      Licenses = {
          from = 3
      },
      MainMenu = {
          coords = vector3(-1515.90, 120.48, 55.64-0.95),
          from = 5
      },
      Barabasz = {

      }
  },
}


Config.OpiumMenu = {
	coords = vector3(-58.14, -808.14, 242.43),
	owner = 'org27',
	from = 3
}

Config.ExctasyMenu = {
	coords = vector3(-59.21, -811.30, 242.43),
	owner = 'org27',
	from = 3
}

Config.NotGang = {
    'org14',
    'org15',
    'org16',
    'org17',
    'org18',
    'org19',
    'org20',
    'org21',
    'org22',
    'org23',
    'org24',
    'org25',
    'org26',
    'org27',
    'org28',
    'org29',
    'org30',
    'org31',
    'org32',
    'org33',
    'org34',
    'org35',
    'org36',
    'org37',
    'org38',
    'org39',
    'org40',
    'org41',
    'org42',
    'org43',
    'org44',
    'org45',
    'org46',
    'org47',
    'org48',
    'org49',
    'org50',
    'org51',
    'org52',
    'org53',
    'org54',
    'org55',
    'org56',
    'org57',
    'org58',
    'org59',
    'org60',
    'org61',
    'org62',
    'org63',
    'org64',
    'org65',
    'org66',
    'org67',
    'org68',
    'org69',
    'org70',
    'org71',
    'org72',
    'org73',
    'org74',
    'org80',
    'org81',
    'org82',
    'org83',
    'org84',
    'org85',
    'org86',
    'org87',
    'org88',
    'org89',
    'org90',
    'org91',
    'org92',
    'org93',
    'org94',
    'org95',
    'org96',
    'org97',
    'org98',
    'org99',
    'org100',
    'org101',
    'org102',
    'org103',
    'org104',
    'org105',
    'org106',
    'org107',
    'org108',
    'org109',
    'org110',
    'org111',
    'org112',
    'org113',
    'org114',
    'org115',
    'org116',
    'org117',
    'org118',
    'org119',
    'org120',
    'org121',
    'org122',
    'org123',
    'org124',
    'org125',
    'org126',
    'org127',
    'org128',
    'org129',
    'org130',
    'org131',
    'org132',
    'org133',
    'org134',
    'org135',
    'org136',
    'org137',
}

Config.DriveByList = {
  ['org1'] = true,
  ['org2'] = true,
  ['org3'] = true,
  ['org4'] = true,
  ['org5'] = true,
  ['org6'] = true,
  ['org7'] = true,
  ['org8'] = true,
  ['org9'] = true,
  ['org10'] = true,
  ['org11'] = true,
  ['org12'] = true,
  ['org13'] = true,
}
