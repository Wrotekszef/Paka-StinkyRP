local npc = {}
local cooldown = false
local blips = {}

CreateThread(function()
    ESX.PlayAnimOnPed = function(ped, dict, anim, speed, time, flag)
		ESX.Streaming.RequestAnimDict(dict, function()
			TaskPlayAnim(ped, dict, anim, speed, speed, time, flag, 1, false, false, false)
		end)
	end

	ESX.Game.MakeEntityFaceEntity = function(entity1, entity2)
		local p1 = GetEntityCoords(entity1, true)
		local p2 = GetEntityCoords(entity2, true)
	
		local dx = p2.x - p1.x
		local dy = p2.y - p1.y
	
		local heading = GetHeadingFromVector_2d(dx, dy)
		SetEntityHeading( entity1, heading )
	end
end)

local pedlist = {
    'ig_abigail',
    'csb_abigail',
    'u_m_y_abner',
    'a_m_m_afriamer_01',
    's_f_y_airhostess_01',
    's_m_y_airworker',
    'u_m_m_aldinapoli',
    'g_m_m_armboss_01',
    'g_m_m_armgoon_01',
    'g_m_y_armgoon_02',
    'g_m_m_armlieut_01',
    'ig_ashley',
    'cs_ashley',
    's_m_m_autoshop_01',
    's_m_m_autoshop_02',
    'ig_money',
    'csb_money',
    'g_m_y_azteca_01',
    'u_m_y_babyd',
    'g_m_y_ballaeast_01',
    'g_m_y_ballaorig_01',
    'g_f_y_ballas_01',
    'ig_ballasog',
    'csb_ballasog',
    'g_m_y_ballasout_01',
    's_f_y_bartender_01',
    'u_m_y_baygor',
    'a_f_m_beach_01',

    'a_f_y_beach_01',

    'a_m_m_beach_01',

    'a_m_o_beach_01',

    'a_m_y_beach_01',

    'a_m_m_beach_02',

    'a_m_y_beach_02',

    'a_m_y_beach_03',

    'a_m_y_beachvesp_01',

    'a_m_y_beachvesp_02',

    'ig_benny',

    'ig_bestmen',
    'a_f_m_bevhills_01',

    'a_f_y_bevhills_01',

    'a_m_m_bevhills_01',

    'a_m_y_bevhills_01',

    'a_f_m_bevhills_02',

    'a_f_y_bevhills_02',

    'a_m_m_bevhills_02',

    'a_m_y_bevhills_02',

    'a_f_y_bevhills_03',

    'a_f_y_bevhills_04',

    'u_m_m_bikehire_01',

    'u_f_y_bikerchic',
    'mp_f_boatstaff_01',

    'mp_m_boatstaff_01',

    'a_f_m_bodybuild_01',

    's_m_m_bouncer_01',

    'ig_brad',
    'cs_brad',

    'a_m_y_breakdance_01',

    'ig_bride',

    'csb_bride',
    'a_m_y_busicas_01',

    'a_f_y_business_01',

    'a_m_m_business_01',

    'a_m_y_business_01',

    'a_f_m_business_02',

    'a_f_y_business_02',

    'a_m_y_business_02',

    'a_f_y_business_03',

    'a_m_y_business_03',

    'a_f_y_business_04',

    's_m_o_busker_01',

    'ig_car3guy1',

    'csb_car3guy1',

    'ig_car3guy2',

    'csb_car3guy2',

    'cs_carbuyer',
    's_m_m_ccrew_01',

    's_m_y_chef_01',

    'ig_chef2',

    'csb_chef2',

    'ig_chef',

    'csb_chef',

    's_m_m_chemsec_01',

    'g_m_m_chemwork_01',

    'g_m_m_chiboss_01',

    'g_m_m_chicold_01',

    'g_m_m_chigoon_01',

    'g_m_m_chigoon_02',


    'csb_chin_goon',

    'u_m_y_chip',


    's_m_m_ciasec_01',

    'mp_m_claude_01',

    'ig_clay',

    'cs_clay',

    'ig_claypain',

    'ig_cletus',

    'csb_cletus',

    's_m_y_clown_01',

    's_m_m_cntrybar_01',

    'u_f_y_comjane',

    's_m_y_construct_01',

    's_m_y_construct_02',

    'ig_chrisformage',

    'cs_chrisformage',


    'csb_customer',

    'u_m_y_cyclist_01',

    'a_m_y_cyclist_01',

    'ig_dale',

    'cs_dale',

    'ig_davenorton',

    'cs_davenorton',

    's_m_y_dealer_01',

    'cs_debra',
    'ig_denise',

    'cs_denise',

    'csb_denise_friend',

    'ig_devin',

    'cs_devin',

    's_m_y_devinsec_01',

    'a_m_y_dhill_01',

    'u_m_m_doa_01',

    's_m_m_dockwork_01',

    's_m_y_dockwork_01',
    'ig_dom',

    'cs_dom',

    's_m_y_doorman_01',

    'a_f_m_downtown_01',

    'a_m_y_downtown_01',

    'ig_dreyfuss',

    'cs_dreyfuss',

    'ig_drfriedlander',

    'cs_drfriedlander',

    'mp_f_deadhooker',

    's_m_y_dwservice_01',

    's_m_y_dwservice_02',

    'a_f_m_eastsa_01',

    'a_f_y_eastsa_01',

    'a_m_m_eastsa_01',

    'a_m_y_eastsa_01',

    'a_f_m_eastsa_02',

    'a_f_y_eastsa_02',

    'a_m_m_eastsa_02',

    'a_m_y_eastsa_02',

    'a_f_y_eastsa_03',

    'u_m_m_edtoh',

    'a_f_y_epsilon_01',

    'a_m_y_epsilon_01',

    'a_m_y_epsilon_02',
    'ig_fabien',

    'cs_fabien',

    's_f_y_factory_01',

    's_m_y_factory_01',

    'g_m_y_famca_01',

    'mp_m_famdd_01',

    'g_m_y_famdnf_01',

    'g_m_y_famfor_01',

    'g_f_y_families_01',

    'a_m_m_farmer_01',

    'a_f_m_fatbla_01',

    'a_f_m_fatcult_01',

    'a_m_m_fatlatin_01',

    'a_f_m_fatwhite_01',

    'ig_fbisuit_01',

    'cs_fbisuit_01',

    's_f_m_fembarber',

    'u_m_m_fibarchitect',

    'u_m_y_fibmugger_01',

    's_m_m_fiboffice_01',

    's_m_m_fiboffice_02',

    'mp_m_fibsec_01',

    's_m_m_fibsec_01',

    'u_m_m_filmdirector',

    'u_m_o_filmnoir',

    'u_m_o_finguru_01',

    's_m_y_fireman_01',
    'a_f_y_fitness_01',

    'a_f_y_fitness_02',

    'ig_floyd',

    'cs_floyd',

    'csb_fos_rep',

    'player_one',

    'mp_f_freemode_01',

    'mp_m_freemode_01',

    'ig_g',

    's_m_m_gaffer_01',

    's_m_y_garbage',

    's_m_m_gardener_01',

    'a_m_y_gay_01',

    'a_m_y_gay_02',

    'csb_g',

    'a_m_m_genfat_01',

    'a_m_m_genfat_02',

    'a_f_y_genhot_01',

    'a_f_o_genstreet_01',

    'a_m_o_genstreet_01',

    'a_m_y_genstreet_01',

    'a_m_y_genstreet_02',

    's_m_m_gentransport',

    'u_m_m_glenstank_01',

    'a_f_y_golfer_01',

    'a_m_m_golfer_01',

    'a_m_y_golfer_01',

    'u_m_m_griff_01',

    's_m_y_grip_01',

    'ig_groom',

    'csb_groom',

    'csb_grove_str_dlr',

    'cs_guadalope',

    'u_m_y_guido_01',

    'u_m_y_gunvend_01',

    'cs_gurk',

    'hc_hacker',

    's_m_m_hairdress_01',

    'ig_hao',

    'csb_hao',

    'a_m_m_hasjew_01',

    'a_m_y_hasjew_01',

    's_m_m_highsec_01',

    's_m_m_highsec_02',

    'a_f_y_hiker_01',

    'a_m_y_hiker_01',

    'a_m_m_hillbilly_01',

    'a_m_m_hillbilly_02',

    'u_m_y_hippie_01',

    'a_f_y_hippie_01',

    'a_m_y_hippy_01',

    'a_f_y_hipster_01',

    'a_m_y_hipster_01',

    'a_f_y_hipster_02',

    'a_m_y_hipster_02',

    'a_f_y_hipster_03',

    'a_m_y_hipster_03',

    'a_f_y_hipster_04',

    's_f_y_hooker_01',

    's_f_y_hooker_02',

    's_f_y_hooker_03',

    'u_f_y_hotposh_01',

    'csb_hugh',

    'ig_hunter',

    'cs_hunter',

    'u_m_y_imporage',

    'csb_imran',

    'a_f_o_indian_01',

    'a_f_y_indian_01',

    'a_m_m_indian_01',

    'a_m_y_indian_01',

    'csb_jackhowitzer',

    'ig_janet',

    'cs_janet',

    'csb_janitor',

    's_m_m_janitor',

    'ig_jay_norris',

    'u_m_m_jesus_01',

    'a_m_y_jetski_01',

    'u_f_y_jewelass_01',

    'ig_jewelass',

    'cs_jewelass',

    'u_m_m_jewelsec_01',

    'u_m_m_jewelthief',

    'ig_jimmyboston',

    'cs_jimmyboston',

    'ig_jimmydisanto',

    'cs_jimmydisanto',

    'ig_joeminuteman',

    'cs_joeminuteman',

    'ig_johnnyklebitz',

    'cs_johnnyklebitz',

    'ig_josef',

    'cs_josef',

    'ig_josh',

    'cs_josh',

    'a_f_y_juggalo_01',

    'a_m_y_juggalo_01',

    'u_m_y_justin',

    'ig_karen_daniels',

    'cs_karen_daniels',

    'ig_kerrymcintosh',

    'g_m_m_korboss_01',

    'g_m_y_korean_01',

    'g_m_y_korean_02',

    'g_m_y_korlieut_01',

    'a_f_m_ktown_01',

    'a_f_o_ktown_01',

    'a_m_m_ktown_01',

    'a_m_o_ktown_01',

    'a_m_y_ktown_01',

    'a_f_m_ktown_02',

    'a_m_y_ktown_02',

    'ig_lamardavis',

    'cs_lamardavis',

    's_m_m_lathandy_01',

    'a_m_y_latino_01',

    'ig_lazlow',

    'cs_lazlow',

    'ig_lestercrest',

    'cs_lestercrest',

    'ig_lifeinvad_01',

    'cs_lifeinvad_01',

    's_m_m_lifeinvad_01',

    'ig_lifeinvad_02',

    's_m_m_linecook',

    'g_f_y_lost_01',

    'g_m_y_lost_01',

    'g_m_y_lost_02',

    'g_m_y_lost_03',

    's_m_m_lsmetro_01',

    'ig_magenta',

    'cs_magenta',

    's_f_m_maid_01',

    'a_m_m_malibu_01',

    'u_m_y_mani',

    'ig_manuel',

    'cs_manuel',

    's_m_m_mariachi_01',

    's_m_m_marine_01',

    's_m_y_marine_01',

    's_m_m_marine_02',

    's_m_y_marine_02',

    's_m_y_marine_03',

    'u_m_m_markfost',

    'ig_marnie',

    'cs_marnie',

    'mp_m_marston_01',

    'cs_martinmadrazo',

    'ig_maryann',

    'cs_maryann',

    'ig_maude',

    'csb_maude',

    'csb_mweather',

    'a_m_y_methhead_01',

    'g_m_m_mexboss_01',

    'g_m_m_mexboss_02',

    'a_m_m_mexcntry_01',

    'g_m_y_mexgang_01',

    'g_m_y_mexgoon_01',

    'g_m_y_mexgoon_02',

    'g_m_y_mexgoon_03',

    'a_m_m_mexlabor_01',

    'a_m_y_mexthug_01',

    'player_zero',

    'ig_michelle',

    'cs_michelle',

    's_f_y_migrant_01',

    's_m_m_migrant_01',

    'u_m_y_militarybum',

    'ig_milton',

    'cs_milton',

    's_m_y_mime',

    'u_f_m_miranda',

    'u_f_y_mistress',

    'mp_f_misty_01',

    'ig_molly',

    'cs_molly',

    'a_m_y_motox_01',

    'a_m_y_motox_02',

    's_m_m_movalien_01',

    'cs_movpremf_01',

    'cs_movpremmale',

    'u_f_o_moviestar',

    's_f_y_movprem_01',

    's_m_m_movprem_01',

    's_m_m_movspace_01',

    'mp_g_m_pros_01',

    'ig_mrk',

    'cs_mrk',

    'ig_mrsphillips',

    'cs_mrsphillips',

    'ig_mrs_thornhill',

    'cs_mrs_thornhill',

    'a_m_y_musclbeac_01',

    'a_m_y_musclbeac_02',

    'ig_natalia',

    'cs_natalia',

    'ig_nervousron',

    'cs_nervousron',

    'ig_nigel',

    'cs_nigel',

    'mp_m_niko_01',

    'a_m_m_og_boss_01',

    'ig_old_man1a',

    'cs_old_man1a',

    'ig_old_man2',

    'cs_old_man2',

    'ig_omega',

    'cs_omega',

    'ig_oneil',

    'ig_orleans',

    'cs_orleans',

    'ig_ortega',

    'csb_ortega',

    'csb_oscar',

    'ig_paige',

    'csb_paige',

    'a_m_m_paparazzi_01',

    'u_m_y_paparazzi',

    'ig_paper',

    'cs_paper',
    'u_m_y_party_01',

    'u_m_m_partytarget',

    'ig_patricia',

    'cs_patricia',

    's_m_y_pestcont_01',

    'hc_driver',

    'hc_gunman',

    's_m_m_pilot_01',

    's_m_y_pilot_01',

    's_m_m_pilot_02',

    'u_m_y_pogo_01',

    'g_m_y_pologoon_01',

    'g_m_y_pologoon_02',

    'a_m_m_polynesian_01',

    'a_m_y_polynesian_01',

    'ig_popov',

    'csb_popov',

    'u_f_y_poppymich',

    'csb_porndudes',

    's_m_m_postal_01',

    's_m_m_postal_02',

    'ig_priest',

    'cs_priest',

    'u_f_y_princess',

    's_m_m_prisguard_01',

    's_m_y_prismuscl_01',

    'u_m_y_prisoner_01',

    's_m_y_prisoner_01',

    'u_m_y_proldriver_01',

    'csb_prologuedriver',

    'u_f_o_prolhost_01',

    'a_f_m_prolhost_01',

    'a_m_m_prolhost_01',

    'u_f_m_promourn_01',

    'u_m_m_promourn_01',

    'u_m_m_prolsec_01',

    'csb_prolsec',

    'ig_prolsec_02',

    'cs_prolsec_02',

    'ig_ramp_gang',

    'csb_ramp_gang',

    'ig_ramp_hic',

    'csb_ramp_hic',

    'ig_ramp_hipster',

    'csb_ramp_hipster',

    'csb_ramp_marine',

    'ig_ramp_mex',

    'csb_ramp_mex',

    's_f_y_ranger_01',

    's_m_y_ranger_01',

    'ig_rashcosvki',

    'csb_rashcosvki',


    'u_m_m_rivalpap',

    'a_m_y_roadcyc_01',

    's_m_y_robber_01',

    'ig_roccopelosi',

    'csb_roccopelosi',

    'u_m_y_rsranger_01',

    'a_f_y_runner_01',

    'a_m_y_runner_01',

    'a_m_y_runner_02',

    'a_f_y_rurmeth_01',

    'a_m_m_rurmeth_01',

    'ig_russiandrunk',

    'cs_russiandrunk',

    'a_f_m_salton_01',

    'a_f_o_salton_01',

    'a_m_m_salton_01',

    'a_m_o_salton_01',

    'a_m_y_salton_01',

    'a_m_m_salton_02',

    'a_m_m_salton_03',

    'a_m_m_salton_04',

    'g_m_y_salvaboss_01',

    'g_m_y_salvagoon_01',

    'g_m_y_salvagoon_02',

    'g_m_y_salvagoon_03',

    'u_m_y_sbike',

    'a_f_y_scdressy_01',

    's_m_m_scientist_01',

    'ig_screen_writer',

    'csb_screen_writer',

    's_f_y_scrubs_01',

    's_m_m_security_01',
    's_f_m_shop_high',

    'mp_m_shopkeep_01',

    's_f_y_shop_low',

    's_m_y_shop_mask',

    's_f_y_shop_mid',

    'ig_siemonyetarian',

    'cs_siemonyetarian',

    'a_f_y_skater_01',

    'a_m_m_skater_01',

    'a_m_y_skater_01',

    'a_m_y_skater_02',

    'a_f_m_skidrow_01',

    'a_m_m_skidrow_01',
    'a_m_m_socenlat_01',

    'ig_solomon',

    'cs_solomon',

    'a_f_m_soucent_01',

    'a_f_o_soucent_01',

    'a_f_y_soucent_01',

    'a_m_m_soucent_01',

    'a_m_o_soucent_01',

    'a_m_y_soucent_01',

    'a_f_m_soucent_02',

    'a_f_o_soucent_02',

    'a_f_y_soucent_02',

    'a_m_m_soucent_02',

    'a_m_o_soucent_02',

    'a_m_y_soucent_02',

    'a_f_y_soucent_03',

    'a_m_m_soucent_03',

    'a_m_o_soucent_03',

    'a_m_y_soucent_03',

    'a_m_m_soucent_04',

    'a_m_y_soucent_04',

    'a_f_m_soucentmc_01',

    'u_m_m_spyactor',

    'u_f_y_spyactress',

    'u_m_y_staggrm_01',

    'a_m_y_stbla_01',

    'a_m_y_stbla_02',

    'ig_stevehains',

    'cs_stevehains',

    'a_m_y_stlat_01',

    'a_m_m_stlat_02',

    'ig_stretch',

    'cs_stretch',

    'csb_stripper_01',

    's_f_y_stripper_01',

    'csb_stripper_02',

    's_f_y_stripper_02',

    'mp_f_stripperlite',

    's_f_y_stripperlite',

    's_m_m_strperf_01',

    's_m_m_strpreach_01',

    'g_m_y_strpunk_01',

    'g_m_y_strpunk_02',

    's_m_m_strvend_01',

    's_m_y_strvend_01',

    'a_m_y_stwhi_01',

    'a_m_y_stwhi_02',

    'a_m_y_sunbathe_01',

    'a_m_y_surfer_01',

    's_m_y_swat_01',

    's_f_m_sweatshop_01',

    's_f_y_sweatshop_01',

    'ig_talina',

    'ig_tanisha',

    'cs_tanisha',

    'ig_taocheng',

    'cs_taocheng',

    'ig_taostranslator',

    'cs_taostranslator',

    'u_m_o_taphillbilly',

    'u_m_y_tattoo_01',

    'a_f_y_tennis_01',

    'a_m_m_tennis_01',

    'ig_tenniscoach',

    'cs_tenniscoach',

    'ig_terry',

    'cs_terry',

    'cs_tom',

    'ig_tomepsilon',

    'cs_tomepsilon',

    'ig_tonya',

    'csb_tonya',

    'a_f_y_topless_01',

    'a_f_m_tourist_01',

    'a_f_y_tourist_01',

    'a_m_m_tourist_01',

    'a_f_y_tourist_02',

    'ig_tracydisanto',

    'cs_tracydisanto',

    'ig_trafficwarden',

    'csb_trafficwarden',

    'u_m_o_tramp_01',

    'a_f_m_tramp_01',

    'a_m_m_tramp_01',

    'a_m_o_tramp_01',

    'a_f_m_trampbeac_01',

    'a_m_m_trampbeac_01',

    'a_m_m_tranvest_01',

    'a_m_m_tranvest_02',

    'player_two',

    's_m_m_trucker_01',

    'ig_tylerdix',

    'csb_undercover',

    's_m_m_ups_01',

    's_m_m_ups_02',

    's_m_y_uscg_01',

    'g_f_y_vagos_01',

    'mp_m_g_vagfun_01',

    'ig_vagspeak',

    'csb_vagspeak',

    's_m_y_valet_01',

    'a_m_y_vindouche_01',

    'a_f_y_vinewood_01',

    'a_m_y_vinewood_01',

    'a_f_y_vinewood_02',

    'a_m_y_vinewood_02',

    'a_f_y_vinewood_03',

    'a_m_y_vinewood_03',

    'a_f_y_vinewood_04',

    'a_m_y_vinewood_04',

    'ig_wade',

    'cs_wade',

    's_m_y_waiter_01',

    'ig_chengsr',

    'cs_chengsr',

    'u_m_m_willyfist',

    's_m_y_winclean_01',

    's_m_y_xmech_01',

    's_m_y_xmech_02',

    'a_f_y_yoga_01',

    'a_m_y_yoga_01',

    'ig_zimbor',

    'cs_zimbor',

    'u_m_y_zombie_01',

    'a_f_y_femaleagent',

    'g_f_importexport_01',

    'g_m_importexport_01',

    'ig_agent',

    'ig_malc',

    'mp_f_cardesign_01',

    'mp_f_chbar_01',

    'mp_f_cocaine_01',

    'mp_f_counterfeit_01',

    'mp_f_execpa_01',

    'mp_f_execpa_02',

    'mp_f_forgery_01',

    'mp_f_helistaff_01',

    'mp_f_meth_01',

    'mp_f_weed_01',

    'mp_m_cocaine_01',

    'mp_m_counterfeit_01',

    'mp_m_execpa_01',

    'mp_m_forgery_01',

    'mp_m_meth_01',

    'mp_m_securoguard_01',

    'mp_m_waremech_01',

    'mp_m_weapexp_01',

    'mp_m_weapwork_01',

    'mp_m_weed_01',

    's_m_y_xmech_02_mp',

    'u_f_m_drowned_01',

    'u_f_y_corpse_01',

    'u_m_m_streetart_01',

    'ig_lestercrest_2',

    'ig_avon',

    'u_m_y_juggernaut_01',

    'mp_m_avongoon',

    'mp_m_bogdangoon',
}

local cooldownskip = false

local SellZones = {
	vector3(-757.92, -662.48, 30.26),--LS
    vector3(440.55, -1829.9, 31.74),--LS
    vector3(542.81, -496.33, 35.79),--LS
    vector3(-1265.45, -2992.11, -30.22),--LS
	vector3(1736.39, 3751.54, 33.86),--SS
	vector3(-112.14, 6471.25, 37.16),--PB
}

function IsInZone(pCoords)
	if pCoords == nil then
		return false
	end
	
	for i=1, #SellZones, 1 do
		if #(SellZones[i] - pCoords) <= 1200.0 then
			return true
		end
	end

    ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Jesteś zbyt daleko miasta, musisz poszukać gdzie indziej klientów!')
	return false
end

local canSell, reject, photo, photomath, obj, obj2, retval

Next_ped = function(drugToSell, cops, samarka)
	if samarka then
		cooldownskip = true
	end

    if exports["esx_ambulancejob"]:isDead() then
        ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Nie możesz sprzedawać na BW!')
        return
    end 

	if cooldown and not cooldownskip then
		ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Poczekaj chwilę żeby psiarskie cię nie szukały!')
		return
	end

	if IsPedInAnyVehicle(PlayerPedId(), false) then
		ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Musisz wysiąść z samochodu!')
		return
	end

    local coords = GetEntityCoords(PlayerPedId())
    local cansellzone = IsInZone(coords)

    if cansellzone then

        cooldown = true
        npc.isSelling = true

        if npc ~= nil and npc.ped ~= nil then
            SetPedAsNoLongerNeeded(npc.ped)
        end

        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
        ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Poszukujesz klientów na: ~o~' .. drugToSell.label)
        Wait(math.random(2000, 5000))
        ClearPedTasks(PlayerPedId()) 
        npc.hash = GetHashKey(pedlist[math.random(1, #pedlist)])
        ESX.Streaming.RequestModel(npc.hash)
        npc.coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 50.0, 5.0)
        retval, npc.z = GetGroundZFor_3dCoord(npc.coords.x, npc.coords.y, npc.coords.z, 0)

        if retval == false then
            cooldown = false
            ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Klient, jednak nie chce tego towaru!')
            ClearPedTasks(PlayerPedId())
            return
        end

        npc.zone = GetLabelText(GetNameOfZone(npc.coords))
        drugToSell.zone = npc.zone
        npc.ped = CreatePed(5, npc.hash, npc.coords.x, npc.coords.y, npc.z, 0.0, true, true)
        PlaceObjectOnGroundProperly(npc.ped)
        SetEntityAsMissionEntity(npc.ped)
        
        if IsEntityDead(npc.ped) or GetEntityCoords(npc.ped) == vector3(0.0, 0.0, 0.0) then
            ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Nie znaleziono klienta!')
            DeleteEntity(npc.ped)
            return
        end
        if not npc.isSelling then
            npc = {}
            return
        end
        
        ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Znaleziono klienta na ~o~ ' .. npc.zone)
        TaskGoToEntity(npc.ped, PlayerPedId(), 60000, 4.0, 2.0, 0, 0)

        CreateThread(function()
            canSell = true
            while npc.ped ~= nil and npc.ped ~= 0 and not IsEntityDead(npc.ped) do
                Wait(0)
                npc.coords = GetEntityCoords(npc.ped)
                ESX.Game.Utils.DrawText3D(npc.coords, ('~g~Klient ~n~~r~chce kupić x%s %s'):format(drugToSell.count, drugToSell.label), 0.5)
                distance = #(GetEntityCoords(PlayerPedId()) - npc.coords)

                ESX.ShowHelpNotification('Naciśnij ~INPUT_VEH_DUCK~ aby ~r~przerwać sprzedaż')
                if not npc.isSelling then
                    ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', '~r~Przerwałeś sprzedaż')
                    SetPedAsNoLongerNeeded(npc.ped)
                    npc = {}
                    return
                end
                
                if distance < 2.0 then
                    if exports["esx_holdup"]:isHoldupingBig() then
                        ESX.ShowNotification('~b~Nie możesz sprzedawać narkotyków podczas aktywnego napadu!')
                        canSell = false
                    else
                        if not exports["esx_holdup"]:isHoldupingBig() and canSell and not IsPedInAnyVehicle(PlayerPedId(), false) then
                            ESX.ShowHelpNotification('Naciśnij ~INPUT_PICKUP~ by zacząć sprzedawać '..drugToSell.label)
                        end
                    end
                    if IsControlJustPressed(0, 38) and canSell and not IsPedInAnyVehicle(PlayerPedId(), false) then
                        canSell = false
                        SetPedTalk(npc.ped)
                        ESX.PlayAnim('missfbi3_party_b', 'talk_balcony_loop_male1', 8.0, -1, 0)
                        ESX.PlayAnimOnPed(npc.ped, 'missfbi3_party_b', 'talk_balcony_loop_male1', 8.0, -1, 0)
                        local liczenie = 0

                        while npc.isSelling do
                            ESX.ShowHelpNotification('Naciśnij ~INPUT_VEH_DUCK~ aby ~r~przerwać sprzedaż')
                            if liczenie >= 5 then liczenie = 0 break end
                            if not IsEntityPlayingAnim(PlayerPedId(), "missfbi3_party_b", "talk_balcony_loop_male1", 3) then
                                ESX.PlayAnim('missfbi3_party_b', 'talk_balcony_loop_male1', 8.0, -1, 0)
                            end
                            Wait(1000)
                            liczenie = liczenie + 1
                        end
                        if not npc.isSelling then
                            ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', '~r~Przerwałeś sprzedaż')
                            SetPedAsNoLongerNeeded(npc.ped)
                            npc = {}
                            return
                        end
                        ClearPedTasks(PlayerPedId())
                        ClearPedTasks(npc.ped)
                        if samarka then
                            reject = math.random(1, 14)
                        else
                            reject = math.random(1, 10)
                        end

                        if reject <= 5 then
                            drugToSell.coords = GetEntityCoords(PlayerPedId())
                            photo = true
                            photomath = math.random(1,5)
                            local ped = PlayerPedId()
                            local coords = GetEntityCoords(ped, false)
                            local str = "Sprzedaż narkotyków"
        
                            local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                            if s1 ~= 0 and s2 ~= 0 then
                                str = str .. " przy " .. GetStreetNameFromHashKey(s1) .. " na skrzyżowaniu z " .. GetStreetNameFromHashKey(s2)
                            elseif s1 ~= 0 then
                                str = str .. " przy " .. GetStreetNameFromHashKey(s1)
                            end
                            
                            TriggerServerEvent('sellDrugsInProgress', {x = coords.x, y = coords.y, z = coords.z}, str, photo, GetEntityModel(ped) ~= `mp_f_freemode_01`)
                            FreezeEntityPosition(PlayerPedId(), true)
                            if photomath >= 3 and photo then
                                TriggerEvent('chatMessage', '', { 240, 200, 240 }, 'Obywatel zrobił Ci zdjęcie.')
                            end
                            Wait(12000)
                            FreezeEntityPosition(PlayerPedId(), false)
                            SetPedAsNoLongerNeeded(npc.ped)
                            TaskCombatPed(npc.ped, PlayerPedId(), 0, 16)
                            npc = {}
                            ESX.Game.MakeEntityFaceEntity(PlayerPedId(), npc.ped)
                            ESX.Game.MakeEntityFaceEntity(npc.ped, PlayerPedId())
                            ESX.ShowAdvancedNotification('~o~Sprzedaż narkotyków', '', 'Ten towar jest chujowy jak barszcz!')
                            PlayAmbientSpeech1(npc.ped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
                            cooldown = false
                            return
                        end

                        SetPedTalk(npc.ped)
                        PlayAmbientSpeech1(npc.ped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
                        obj = CreateObject(GetHashKey('prop_weed_bottle'), 0, 0, 0, true)
                        AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                        obj2 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), 0, 0, 0, true)
                        AttachEntityToEntity(obj2, npc.ped, GetPedBoneIndex(npc.ped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                        ESX.PlayAnim('mp_common', 'givetake1_a', 8.0, -1, 0)
                        ESX.PlayAnimOnPed(npc.ped, 'mp_common', 'givetake1_a', 8.0, -1, 0)
                        Wait(1000)
                        AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                        AttachEntityToEntity(obj, npc.ped, GetPedBoneIndex(npc.ped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
                        Wait(1000)
                        DeleteEntity(obj)
                        DeleteEntity(obj2)
                        PlayAmbientSpeech1(npc.ped, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                        SetPedAsNoLongerNeeded(npc.ped)
                        TriggerServerEvent('exile_selldrugs:payzadrugi', drugToSell, npc.coords)
                        npc = {}
                        Wait(4000)
                        cooldown = false
                    end
                end
            end
        end)
    end
end

CreateThread(function()
    while true do
        if (IsEntityDead(npc.ped) or npc.ped == 0 or npc.ped == nil) and canSell then
            if npc.ped then DeletePed(npc.ped) end
            SetPedAsNoLongerNeeded(npc.ped)
            npc = {}
            cooldown = false
            canSell = false
            npc.isSelling = false
        end
        Wait(0)
    end
end)


CreateThread(function()
	while npc.isSelling do
		Wait(0)
        if IsControlJustPressed(0, 73) then
            npc.isSelling = false
            Wait(4000)
            cooldown = false
            ESX.ShowNotification('~o~Możesz już sprzedawać.')
        end
	end
end)

RegisterNetEvent('exile_selldrugs:findClientnadrugi')
AddEventHandler('exile_selldrugs:findClientnadrugi', Next_ped)

RegisterNetEvent('exilerp_scripts:gigacpun', function(money)
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    ESX.Scaleform.ShowFreemodeMessage('~o~GIGA CPUN', 'TRAFIŁEŚ NA GIGA CPUNA\nKTÓRY KUPIŁ OD CIEBIE WSZYSTKIE PORCJE\nZAROBIŁEŚ Z FRAJERA: ~r~'..money..'$', 4)
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
end)