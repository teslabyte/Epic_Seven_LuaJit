if not PRODUCTION_MODE then
	SubStoryViewerBattle = {}
	
	function SubStoryViewerBattle.onBattle(arg_1_0, arg_1_1)
		startBattle("v3012a001", {
			practice_mode = true,
			npcteam_id = "lmn_sb_c3012_01"
		})
	end
end
