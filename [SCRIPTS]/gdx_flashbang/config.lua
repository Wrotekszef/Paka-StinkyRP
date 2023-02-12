Config = {
	WeaponLabel = "Flashbang",
	ExplodeTime = 2000,             			-- msec
	
	ExplosionEffectVisibilityRange = 80.0,

	CanCutOutMumble = true,
	MumbleCutOutDuration = 20000, 				-- msec

	WeakEffectDuration = 10000,					-- msec
	FlashEffectDuration = 20000,				-- msec
	WeakEffectSoundDuration = 19000,			-- msec
	FlashEffectWhiteScreenDuration = 5000, 		-- msec
	FlashEffectWhiteScreenFadeOutTempo = 1.0,
	AfterExplosionCameraReturnDuration = 3000, 	-- msec

	WeakEffectSoundVolume = 0.8,
	FlashEffectSoundVolume = 1.3,

	UpdateEffectVolumeOnWeakEffect = true,

	WeakEffectRange = { farthest = 50.0, nearest = 25.0 },
	FlashEffectBehindPlayerRange = 25.0,
	FlashEffectInFrontOfPlayerRange = 25.0,
	PedAnimationOnEffect = true,
	MakePlayerUnarmedOnEffect = true,
	DisablePlayerFiringOnEffect = true,
	RagdollOnEffect = true
}