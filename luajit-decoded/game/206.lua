PvpSelectPopup = {}
SELECT_POPUP_SYNC_TM = 30

function HANDLER.pvp_sel(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		PvpSelectPopup:close()
	end
	
	if arg_1_1 == "btn_pvp" then
		PvpSelectPopup:goPvp()
	end
	
	if arg_1_1 == "btn_pvplive" then
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.WORLD_ARENA
		}, function()
			PvpSelectPopup:goArenaNet()
		end)
	end
	
	if arg_1_1 == "btn_npc_chall" then
		SceneManager:nextScene("pvp_npc")
	end
end

function PvpSelectPopup.show(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	
	local var_3_0 = SceneManager:getRunningPopupScene()
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("pvp_sel", true, "wnd", function()
		PvpSelectPopup:close()
	end)
	
	var_3_0:addChild(arg_3_0.vars.wnd)
	
	arg_3_0.world_pvp_season_id = getArenaNetSeasonId()
	arg_3_0.world_pvp_league_id = AccountData.world_pvp_league
	
	arg_3_0:update()
	UIUtil:slideOpen(arg_3_0.vars.wnd, arg_3_0.vars.wnd.c.cm_tooltipbox, true, true)
	SoundEngine:play("event:/ui/lobby/btn_package")
	TutorialGuide:procGuide()
	TutorialNotice:update("pvp_sel")
	GrowthGuideNavigator:proc()
end

function PvpSelectPopup.close(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("pvp_sel")
	UIUtil:slideOpen(arg_5_0.vars.wnd, arg_5_0.vars.wnd.c.cm_tooltipbox, false, true)
	
	arg_5_0.vars = nil
end

function PvpSelectPopup._test_on(arg_6_0, arg_6_1)
	if arg_6_1 then
		arg_6_0._test_value = true
	else
		arg_6_0._test_value = false
	end
end

function PvpSelectPopup.update(arg_7_0)
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("n_sel1")
	local var_7_1 = arg_7_0.vars.wnd:getChildByName("n_sel2")
	
	if AccountData.pvp_info then
		local var_7_2, var_7_3 = DB("pvp_sa", AccountData.pvp_info.league, {
			"name",
			"emblem"
		})
		
		SpriteCache:resetSprite(var_7_0:getChildByName("emblem"), "emblem/" .. var_7_3 .. ".png")
		if_set(var_7_0, "txt_grade_name", T(var_7_2))
		
		local var_7_4 = os.time()
		
		if arg_7_0._test_value or var_7_4 < AccountData.pvp_info.next_season_start_time and var_7_4 > AccountData.pvp_info.season_end_time then
			if_set_visible(var_7_0, "n_grade", false)
			if_set_visible(var_7_0, "n_npc_challenge", true)
		elseif var_7_4 > AccountData.pvp_info.season_start_time and var_7_4 < AccountData.pvp_info.season_end_time then
			if PvpSA:isBlindUser() then
				if_set_visible(var_7_0, "n_title", false)
				if_set_visible(var_7_0, "n_title_blind", true)
			else
				if_set_visible(var_7_0, "n_title", true)
				if_set_visible(var_7_0, "n_title_blind", false)
			end
			
			if_set_visible(var_7_0, "n_grade", true)
			if_set_visible(var_7_0, "n_npc_challenge", false)
		else
			if_set_visible(var_7_0, "n_npc_challenge", false)
			if_set_visible(var_7_0, "n_grade", false)
		end
	else
		if_set_visible(var_7_0, "n_npc_challenge", false)
		if_set_visible(var_7_0, "n_grade", false)
	end
	
	if_set_visible(var_7_1, "n_grade", UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_ARENA))
	
	if not arg_7_0.world_pvp_league_id then
		if_set_visible(var_7_1, "n_grade", false)
	else
		if_set_visible(var_7_1, "n_grade", true)
		
		if arg_7_0.world_pvp_league_id == "draft" then
			SpriteCache:resetSprite(var_7_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
			if_set(var_7_1, "txt_grade_name", T(ARENA_UNRANK_TEXT))
		else
			local var_7_5, var_7_6 = getArenaNetRankInfo(nil, arg_7_0.world_pvp_league_id)
			
			if var_7_5 and var_7_6 then
				SpriteCache:resetSprite(var_7_1:getChildByName("emblem"), "emblem/" .. var_7_6 .. ".png")
				if_set(var_7_1, "txt_grade_name", T(var_7_5))
			else
				if_set_visible(var_7_1, "n_grade", false)
			end
		end
	end
	
	if arg_7_0.world_pvp_season_id then
		local var_7_7 = DB("pvp_rta_season", arg_7_0.world_pvp_season_id, {
			"rta_bg1"
		})
		
		if var_7_7 then
			local var_7_8 = arg_7_0.vars.wnd:getChildByName("btn_pvplive")
			
			var_7_8:loadTextureNormal("img/" .. var_7_7 .. ".png")
			var_7_8:loadTexturePressed("img/" .. var_7_7 .. ".png")
			var_7_8:loadTextureDisabled("img/" .. var_7_7 .. ".png")
		end
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_ARENA) then
		if_set_opacity(var_7_1, "n_btn", 51)
	end
end

function PvpSelectPopup.goPvp(arg_8_0)
	if ContentDisable:byAlias("pvp") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "pvp" then
		arg_8_0:close()
		
		return 
	end
	
	query("pvp_sa_lobby")
end

function PvpSelectPopup.goArenaNet(arg_9_0)
	if ContentDisable:byAlias("world_arena") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "arena_net_lobby" then
		arg_9_0:close()
		
		return 
	end
	
	if MatchService:isProgress() then
		return 
	end
	
	if UIAction:Find("block") then
		return 
	end
	
	UIAction:Add(DELAY(1500), arg_9_0, "block")
	query("arena_net_enter_ready")
end
