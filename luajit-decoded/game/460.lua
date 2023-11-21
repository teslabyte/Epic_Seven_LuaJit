BattleReady = {}

function MsgHandler.friend_stage_recommend(arg_1_0)
	BattleReadyFriends:updateData(arg_1_0)
end

function HANDLER_BEFORE.battle_ready(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_simple_info" then
		BattleReady:showSimpleInfo(true)
	end
end

function HANDLER_CANCEL.battle_ready(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_simple_info" then
		BattleReady:showSimpleInfo(false)
	end
end

function HANDLER.battle_ready(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	print("battle_ready", arg_4_1)
	UIUtil:checkBtnTouchPos(arg_4_0, arg_4_3, arg_4_4)
	
	if arg_4_1 == "btn_change_supporter" then
		BattleReadyFriends:show(BattleReady.vars.dlg:getChildByName("n_support"), BattleReady.vars.enter_id, BattleReady.vars.story_powerup_units)
		BattleReady:showSupportFriend()
	end
	
	if arg_4_1 == "btn_change_difficulty" then
		BattleReady:showDifficulty(true, true)
	end
	
	if arg_4_1 == "btn_simple_info" then
		BattleReady:showSimpleInfo(false)
	end
	
	if arg_4_1 == "btn_limit" then
		BattleReady:showLimitInfo(false)
	end
	
	if (arg_4_1 == "btn_management" or arg_4_1 == "btn_recovery_all") and arg_4_0:getOpacity() < 255 then
		return 
	end
	
	if arg_4_1 == "btn_management" then
		BattleReady:toggleEditMode()
	elseif arg_4_1 == "btn_select_team" then
		if BattleSelectDiffculty:isGotoFormation() then
			BattleReady:showTeamFormation()
		else
			BattleReadyFriends:show(BattleReady.vars.dlg:getChildByName("n_support"), BattleReady.vars.enter_id, BattleReady.vars.story_powerup_units)
			BattleReady:showSupportFriend()
		end
	elseif arg_4_1 == "btn_friend" then
		BattleReady:selectFriend()
		TutorialGuide:procGuide("lobby_adventure")
		
		if BattleReady.vars then
			if BattleReady.vars.enter_id == "ije004" then
				TutorialGuide:startGuide("ije004_bossicon")
			elseif BattleReady.vars.enter_id == "ije005" then
				TutorialGuide:startGuide("ije005_townicon")
			elseif BattleReady.vars.enter_id == "ije009" then
				TutorialGuide:startGuide("ije009_chaosicon")
			elseif BattleReady.vars.enter_id == "ije010" then
				TutorialGuide:startGuide("ije010_dungeonboss")
			end
		end
	elseif arg_4_1 == "btn_go" then
		BattleReady:pushGoButton()
		TutorialGuide:procGuide()
	elseif arg_4_1 == "btn_mob" then
		local var_4_0 = getParentWindow(arg_4_0)
		
		print(var_4_0.code, var_4_0.grade)
	elseif arg_4_1 == "btn_bg" then
		local var_4_1 = string.split(arg_4_0:getParent():getName(), "_")
		
		if var_4_1[1] == "btn" then
			BattleReadyFriends:updateCategory(tonumber(var_4_1[2]))
		end
	elseif arg_4_1 == "btn_close" then
		BattleReady:onButtonClose()
	elseif arg_4_1 == "btn_recovery_all" then
		local var_4_2 = Account:getTeam()
		local var_4_3 = {}
		
		for iter_4_0, iter_4_1 in pairs(var_4_2) do
			if iter_4_1.is_unit then
				table.insert(var_4_3, iter_4_1)
			end
		end
		
		Bistro:ReqFinishEating(var_4_3)
		
		return 
	elseif arg_4_1 == "btn_up" then
		if arg_4_0:getOpacity() < 255 then
			balloon_message_with_sound("automtn_weak_max")
			
			return 
		end
		
		BattleReady:onChangeWeekPoint()
	elseif arg_4_1 == "btn_down" then
		if arg_4_0:getOpacity() < 255 then
			balloon_message_with_sound("automtn_weak_cant_max")
			
			return 
		end
		
		BattleReady:onChangeWeekPoint(true)
	end
end

function HANDLER.expedition_battle_popup(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_cancel" then
		BattleReady:coopBackButton()
	end
	
	if arg_5_1 == "btn_stop_watching" then
		BattleReady:coopBattleStart()
		BattleReady:updateStopWatching()
	end
	
	if arg_5_1 == "btn_ok" then
		BattleReady:coopBattleStart()
	end
end

function BattleReady.getNPCTeam(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0
	
	for iter_6_0 = 1, 3 do
		local var_6_1 = arg_6_1["npcteam_quest" .. iter_6_0]
		
		if SubstoryManager:getInfo() and not SubstoryManager:isApplyQuestInBattle(var_6_1) then
			var_6_1 = nil
		end
		
		if var_6_1 then
			if var_6_1 == "force_npc" or var_6_1 == "once_npc" then
				if var_6_1 == "force_npc" then
					var_6_0 = arg_6_1["npcteam_id" .. iter_6_0]
					
					break
				elseif var_6_1 == "once_npc" then
					if not Account:isMapCleared(arg_6_3.enter_id) then
						var_6_0 = arg_6_1["npcteam_id" .. iter_6_0]
					end
					
					break
				end
			else
				local var_6_2 = (arg_6_2[var_6_1] or {}).state
				
				if (var_6_2 == "active" or tonumber(var_6_2) == SUBSTORY_QUEST_STATE.ACTIVE) and not Account:isMapCleared(arg_6_3.enter_id) then
					var_6_0 = arg_6_1["npcteam_id" .. iter_6_0]
					
					break
				end
			end
		end
	end
	
	return var_6_0
end

function BattleReady.setCurrencies(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {
		"crystal",
		"gold",
		"stamina"
	}
	
	if arg_7_1 == "defense_quest" or arg_7_1 == "dungeon_quest" or arg_7_1 == "quest" or arg_7_1 == "extra_quest" or arg_7_1 == "genie" or arg_7_1 == "hunt" or arg_7_1 == "descent" or arg_7_1 == "burning" then
		local var_7_1
		
		if arg_7_2 and arg_7_2 == "substory" then
			var_7_1 = SubstoryManager:getInfo() or {}
			
			for iter_7_0 = 1, 3 do
				if var_7_1["token_id" .. iter_7_0] then
					table.insert(var_7_0, var_7_1["token_id" .. iter_7_0])
				end
			end
		end
		
		TopBarNew:setCurrencies(var_7_0)
		
		if arg_7_2 and arg_7_2 == "substory" then
			TopBarNew:setCurrencyIconsSize()
		end
	elseif arg_7_1 == "abyss" and arg_7_2 == "automaton" then
		TopBarNew:setCurrencies({
			"crystal",
			"gold",
			"stamina",
			"stigma"
		})
	elseif arg_7_1 == "abyss" and arg_7_2 == "abyss" then
		TopBarNew:setCurrencies({
			"crystal",
			"gold",
			"abysskey",
			"stigma"
		})
	elseif arg_7_1 == "trial_hall" then
		TopBarNew:setCurrencies({
			"crystal",
			"gold"
		})
	else
		TopBarNew:setCurrencies(var_7_0)
	end
end

function BattleReady.canUseReadyUI(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if arg_8_1 then
		local var_8_0 = {
			"cook",
			"volleyball",
			"village",
			"arcade",
			"repair",
			"exorcist"
		}
		local var_8_1 = DB("level_enter", arg_8_1, {
			"type"
		})
		
		if var_8_1 and table.find(var_8_0, var_8_1) then
			return 
		end
	end
	
	return true
end

function BattleReady.show(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or {}
	
	if UIAction:Find("block") and not arg_9_1.ignore_block and SceneManager:getCurrentSceneName() ~= "DungeonList" then
		return 
	end
	
	local var_9_0, var_9_1 = BackPlayUtil:checkEnterableMapOnBackPlaying(arg_9_1.enter_id)
	
	if arg_9_1.enter_id and not var_9_0 then
		local var_9_2 = var_9_1 or "msg_bgbattle_samebattle_error"
		
		arg_9_1.enter_error_text = T(var_9_2)
	end
	
	if not checkGenieEnterable(arg_9_1.enter_id) then
		arg_9_1.enter_error_text = T("err_msg_enter_limit_altar")
	end
	
	UIUtil:closePopups()
	
	if WorldMapEpisodeList:isShow() then
		return 
	end
	
	if arg_9_0.vars and get_cocos_refid(arg_9_0.vars.dlg) then
		return 
	end
	
	if Account:checkMiner() and arg_9_1.enter_id == "ije004" and not Account:checkNameChanged() then
		UserNickName:popupNickname("user_force_nickname", function()
			arg_9_0:show(arg_9_1)
		end)
		
		return 
	end
	
	if arg_9_1.enter_id and not arg_9_0:canUseReadyUI(arg_9_1.enter_id) then
		return 
	end
	
	SoundEngine:play("event:/ui/stage_click")
	
	local var_9_3, var_9_4, var_9_5, var_9_6, var_9_7, var_9_8, var_9_9 = DB("level_enter", arg_9_1.enter_id, {
		"use_enterpoint",
		"type",
		"contents_type",
		"full_hp",
		"enter_limit",
		"supporter",
		"auto_battle_able"
	})
	
	arg_9_1.counter = arg_9_1.counter or var_9_3
	
	if string.find(arg_9_1.enter_id, "auto") then
		var_9_6 = nil
	end
	
	local var_9_10 = DBT("level_enter", arg_9_1.enter_id, {
		"npcteam_id1",
		"npcteam_id2",
		"npcteam_id3",
		"npcteam_quest1",
		"npcteam_quest2",
		"npcteam_quest3"
	}) or {}
	local var_9_11
	local var_9_12 = SubstoryManager:getInfo()
	
	if var_9_12 then
		var_9_11 = Account:getSubStoryQuestBySubstoryID(var_9_12.id)
	else
		var_9_11 = Account:getQuestMissions()
	end
	
	local var_9_13 = arg_9_0:getNPCTeam(var_9_10, var_9_11, arg_9_1) or arg_9_1.npc_team_id or arg_9_1._debug_ui_test_npcteam_id
	
	arg_9_0.vars = {}
	arg_9_0.vars.callback = arg_9_1.callback
	arg_9_0.vars.opts = arg_9_1
	arg_9_0.vars.enter_id = arg_9_1.enter_id
	arg_9_0.vars.full_hp = var_9_6
	arg_9_0.vars.hide_hpbar = arg_9_1.hide_hpbar
	arg_9_0.vars.enable_supporter = not var_9_13 and var_9_8 == "y"
	arg_9_0.vars.npcteam_id = var_9_13
	arg_9_0.vars.opts.npcteam_id = var_9_13
	arg_9_0.vars.difficulty_id = DB("level_enter", arg_9_0.vars.enter_id, "difficulty_id")
	arg_9_0.vars.level_type = var_9_4
	arg_9_0.vars.is_preview_quest = arg_9_1.cheat_preview_mode or DB("level_enter", arg_9_0.vars.enter_id, "type") == "preview_quest"
	arg_9_0.vars.is_tree = arg_9_1.is_tree
	
	if not arg_9_0.vars.is_tree and var_9_5 == "adventure" then
		local var_9_14, var_9_15 = DB("level_enter", arg_9_0.vars.enter_id, {
			"type",
			"episode"
		})
		
		if var_9_14 and var_9_15 and var_9_14 == "extra_quest" and var_9_15 == "adventure_ep5" then
			arg_9_0.vars.is_tree = true
		end
	end
	
	arg_9_0.vars.sub_story = nil
	
	if var_9_5 == "substory" then
		local var_9_16 = DB("level_enter", arg_9_0.vars.enter_id, "substory_contents_id")
		
		arg_9_0.vars.sub_story = SubstoryManager:makeInfo(var_9_16)
		
		if not arg_9_0.vars.sub_story then
			Log.e("DescentReady.init", "invalid_substory_info")
			
			return 
		end
		
		arg_9_0.vars.opts.sub_story = arg_9_0.vars.sub_story
	end
	
	if arg_9_1.practice_mode and DungeonHell:isAbyssHardMap(arg_9_0.vars.enter_id) then
		arg_9_1.practice_mode = nil
	end
	
	arg_9_0.vars.dlg = load_dlg("battle_ready", true, "wnd")
	
	TopBarNew:createFromPopup(T("battle_ready"), arg_9_0.vars.dlg, function()
		BattleReady:onButtonClose()
	end, arg_9_0.vars.opts.currencies)
	TopBarNew:setDisableLobbyAuto()
	
	arg_9_0.vars.dlg.guide_tag = arg_9_1.enter_id
	
	if not arg_9_1.currencies then
		arg_9_1.currencies = arg_9_0:setCurrencies(var_9_4, var_9_5)
	end
	
	if var_9_4 == "abyss" and (DungeonHell:isAbyssHardMap(arg_9_0.vars.enter_id) and Account:getHardHellFloor() + 1 or Account:getHellFloor()) <= to_n(string.sub(arg_9_1.enter_id, #arg_9_1.enter_id - 2, -1)) and arg_9_0.vars.opts.practice_mode then
		Log.e("invalid Practice_mode :", arg_9_1.enter_id)
		
		arg_9_0.vars.opts.practice_mode = nil
	end
	
	if arg_9_1.difficulty_level and arg_9_0.vars.difficulty_id then
		arg_9_0:setDifficulty(arg_9_1.difficulty_level)
		
		arg_9_0.vars.save_override_flag = true
	end
	
	arg_9_0.vars.isAutomaton = var_9_5 == "automaton"
	arg_9_0.vars.isTrialhall = var_9_4 == "trial_hall"
	arg_9_0.vars.isCoop = var_9_4 == "coop"
	arg_9_0.vars.isCrehunt = var_9_5 == "crehunt"
	arg_9_0.vars.isUnitOnceOnly = DB("level_maze_link", arg_9_0.vars.enter_id, "unit_once") == "y"
	
	local var_9_17 = SceneManager:getRunningNativeScene()
	
	if SceneManager:getCurrentSceneName() == "lobby" and Lobby:getLayer() then
		var_9_17 = Lobby:getLayer()
	end
	
	var_9_17:addChild(arg_9_0.vars.dlg)
	
	if not DungeonHell:isAbyssHardMap(arg_9_0.vars.enter_id) then
		GrowthGuideNavigator:proc()
	end
	
	arg_9_0.vars.opts.automaton_free_enter = false
	
	if arg_9_0.vars.isAutomaton then
		local var_9_18 = to_n(string.sub(arg_9_1.enter_id, 7, -1))
		
		arg_9_0:initAutomatonUI(var_9_18)
	elseif arg_9_0.vars.isCrehunt then
		arg_9_0:initCreviceUI()
		TutorialGuide:ifStartGuide("crehunt_battle")
	end
	
	arg_9_0:showLimitInfo(false, true)
	arg_9_0:updateEntrance()
	arg_9_0:updateUI()
	
	local var_9_19 = load_control("wnd/formation.csb", true)
	
	var_9_19:setAnchorPoint(0.5, 0.5)
	
	local var_9_20 = var_9_19:getChildByName("RIGHT")
	
	if NotchStatus:isLeft() then
		var_9_20:setPositionX(var_9_20:getPositionX() - NotchStatus:getNotchBaseLeft() + NotchStatus:getNotchSafeRight())
	else
		var_9_20:setPositionX(var_9_20:getPositionX() - NotchStatus:getNotchBaseLeft())
	end
	
	arg_9_0.vars.dlg:getChildByName("n_form"):addChild(var_9_19)
	
	local var_9_21 = {}
	local var_9_22
	
	if arg_9_0.vars.sub_story then
		var_9_22 = arg_9_0.vars.sub_story
		
		for iter_9_0 = 0, 2 do
			local var_9_23 = var_9_22["powerup_hero" .. iter_9_0]
			
			if var_9_23 then
				local var_9_24 = string.split(var_9_23, ",")
				
				for iter_9_1, iter_9_2 in pairs(var_9_24) do
					var_9_21[iter_9_2] = true
				end
			end
		end
	end
	
	local var_9_25 = {}
	
	if not table.empty(var_9_21) and arg_9_0.vars.sub_story then
		local var_9_26 = arg_9_0.vars.sub_story.powerup_hero0
		
		if var_9_26 then
			local var_9_27 = string.split(var_9_26, ",")
			
			for iter_9_3, iter_9_4 in pairs(var_9_27) do
				var_9_25[iter_9_4] = true
			end
		end
	end
	
	arg_9_0.vars.story_powerup_units = var_9_21
	arg_9_0.vars.substory_power_up_units = var_9_25
	arg_9_0.vars.is_enable_pet = PetUtil:isPetEnableMap(arg_9_0.vars.enter_id)
	
	local var_9_28 = arg_9_0.vars.isAutomaton or arg_9_0.vars.isTrialhall or arg_9_0.vars.isCoop
	local var_9_29 = not arg_9_0.vars.npcteam_id and not arg_9_0.vars.is_enable_pet
	
	arg_9_0.vars.is_guide_position = false
	
	if Account:getActiveQuestDataInBattle(arg_9_0.vars.enter_id) and TutorialGuide:isClearedTutorial("ije006_auto") and Account:isMapCleared("ije007") and not Account:isMapCleared("ije010") then
		arg_9_0.vars.is_guide_position = true
	end
	
	FormationEditor:initFormationEditor(arg_9_0, {
		battle_ready_dedi_effect = true,
		use_detail = true,
		on_pet_select_save_team = true,
		show_role_info = true,
		wnd = var_9_19,
		callbackSelectTeam = function(arg_12_0)
			local var_12_0 = false
			
			if arg_12_0 ~= BattleReady:getTeamIndex() then
				var_12_0 = true
			end
			
			arg_9_0:setNormalMode()
			BattleReady:setTeam(arg_12_0)
			
			if var_12_0 and arg_9_0.vars.is_guide_position then
				arg_9_0:refreshGuideButtons()
				arg_9_0:playQuestEffectGuide()
			end
		end,
		callbackSelectUnit = function(arg_13_0)
			HeroBelt:scrollToUnit(arg_13_0)
		end,
		callbackSelectEmptySlot = function(arg_14_0)
			if arg_9_0.vars.is_guide_position then
				BattleReady:toggleEditMode(true)
			end
		end,
		callbackChangeStatus = function(arg_15_0)
			if arg_15_0 == "Normal" then
				arg_9_0:playQuestEffectGuide()
			end
		end,
		disable_hp_info = arg_9_0.vars.full_hp == "y",
		is_automaton = arg_9_0.vars.opts.is_automaton,
		hide_hpbar = arg_9_0.vars.hide_hpbar,
		sub_story = arg_9_0.vars.sub_story,
		npcteam_id = arg_9_0.vars.npcteam_id,
		auto_battle_able = var_9_9,
		npc_text_change = arg_9_0.vars.opts.npc_text_change,
		is_enable_pet = arg_9_0.vars.is_enable_pet,
		sinsu_block = var_9_28,
		sinsu_only = var_9_29,
		map_id = arg_9_0.vars.enter_id,
		is_coop = arg_9_0.vars.isCoop,
		is_automaton = arg_9_0.vars.isAutomaton,
		is_crehunt = arg_9_0.vars.isCrehunt,
		is_unit_once = arg_9_0.vars.isUnitOnceOnly,
		story_powerup_units = var_9_21,
		is_difficulty = arg_9_0.vars.difficulty_id,
		ui_handler = function(arg_16_0, arg_16_1)
			if string.match(arg_16_1, "btn%d") and not arg_9_0.vars.edit_mode and not arg_9_0.vars.npcteam_id then
				BattleReady:toggleEditMode()
			end
			
			if arg_16_1 == "btn_support_back" and arg_9_0:isNormalMode() then
				BattleReady:toggleEditMode(false)
				BattleReady:setVisibleQuestEffectNode(false)
				BattleReady:showSupportFriend()
			end
			
			if arg_16_1 == "btn_difficulty_select" then
				BattleReady:toggleEditMode(false)
				BattleReady:setVisibleQuestEffectNode(false)
				BattleReady:showDifficulty(true)
			end
			
			if arg_16_1 == "btn_booster" then
				BoosterUI:show()
			end
			
			if arg_16_1 == "btn_penguin" then
				BattleReady:penguine_bonus()
			else
				BattleReady:off_penguine_bonus()
			end
			
			if arg_16_1 == "btn_bonus" then
				local var_16_0 = arg_9_0.vars.npcteam_id and TutorialBattle:getStoryUnits(arg_9_0.vars.npcteam_id) or Account:getTeam(BattleReady:getTeamIndex())
				
				ArtifactBonus:show(var_16_0, var_9_4, arg_9_0.vars.enter_id)
			end
			
			if arg_16_1 == "btn_boss_guide" then
				BattleReady:showBossGuide()
			end
			
			if arg_16_1 == "btn_boss_feature" then
				BattleReady:showBossFeature()
			end
		end
	})
	arg_9_0:setFormationEditMode(not arg_9_0.vars.npcteam_id)
	
	arg_9_0.vars.form = var_9_19
	arg_9_0.vars.btn_bonus = var_9_19:getChildByName("btn_bonus")
	
	arg_9_0:updateButtons()
	if_set_visible(var_9_19, "n_teamlist", true)
	if_set_visible(arg_9_0.vars.dlg, "btn_management", true)
	if_set_visible(arg_9_0.vars.dlg, "check_loop", not arg_9_0.vars.npcteam_id)
	if_set_visible(arg_9_0.vars.dlg, "difficulty_disc", false)
	if_set_visible(arg_9_0.vars.dlg, "support_disc", false)
	
	if arg_9_0.vars.npcteam_id then
		local var_9_30 = TutorialBattle:getStoryUnits(arg_9_0.vars.npcteam_id)
		
		arg_9_0:updateFormation(var_9_30)
		if_set_opacity(arg_9_0.vars.dlg, "btn_management", 76)
		if_set_opacity(arg_9_0.vars.dlg, "btn_recovery_all", 76)
		if_set_color(arg_9_0.vars.dlg, "base_sinsu", cc.c3b(76, 76, 76))
	else
		arg_9_0:updateFormation()
		UnlockSystem:setButtonUnlockInfo(arg_9_0.vars.dlg, "btn_management", "system_078")
	end
	
	if arg_9_0.vars.isAutomaton then
		if_set_visible(arg_9_0.vars.dlg:getChildByName("n_team_formation"), "bar1_l", false)
		if_set_visible(arg_9_0.vars.dlg, "btn_recovery_all", false)
	end
	
	local var_9_31 = arg_9_0.vars.dlg:getChildByName("n_window_ready")
	local var_9_32 = var_9_31:getPositionX() + math.random() * 9 - 4.5
	local var_9_33 = var_9_31:getPositionY() + math.random() * 9 - 4.5
	
	var_9_31:setPositionY(360)
	UIUtil:addNoise(var_9_31)
	arg_9_0.vars.dlg.c.dim_img:setOpacity((math.random() * 0.2 + 0.8) * 255)
	var_9_31:setPosition(var_9_32, var_9_33)
	Analytics:saveBeforeTab()
	arg_9_0:toggleEditMode(false)
	BattleReadyFriends:clearLastUseFriend(arg_9_0.vars.enter_id)
	BattleReadyFriends:clear()
	BattleSelectDiffculty:clear()
	if_set_visible(var_9_19, "n_maze_supporter", false)
	if_set_visible(var_9_19, "n_sinsu_only", false)
	
	if arg_9_0.vars.difficulty_id and not arg_9_0.vars.opts.enter_error_text and not arg_9_0.vars.npcteam_id and not arg_9_0.vars.opts.hide_open_difficulty then
		arg_9_0:showDifficulty()
	elseif arg_9_0.vars.enable_supporter and not arg_9_0.vars.opts.enter_error_text then
		if_set_visible(var_9_19, "base_support", true)
		BattleReadyFriends:show(arg_9_0.vars.dlg:getChildByName("n_support"), arg_9_0.vars.enter_id, var_9_21, var_9_25)
		arg_9_0:showSupportFriend()
	else
		if_set_visible(var_9_19, "base_support", false)
		
		if not arg_9_0.vars.npcteam_id and not arg_9_0.vars.is_enable_pet then
			if_set_visible(var_9_19, "base_pet", false)
			
			local var_9_34 = var_9_19:findChildByName("n_sinsu_only")
			
			if_set_visible(var_9_34, nil, not arg_9_0.vars.isAutomaton and not arg_9_0.vars.isTrialhall and not arg_9_0.vars.isCoop)
			if_set(var_9_34, "text", T("ui_ready_supporter_unusable"))
			
			if not DungeonHell:isAbyssHardMap(arg_9_0.vars.enter_id) then
				local var_9_35 = var_9_19:findChildByName("base_sinsu")
				
				var_9_35:setPositionY(var_9_35:getPositionY() - 52)
			end
		elseif not arg_9_0.vars.npcteam_id then
			local var_9_36 = var_9_19:findChildByName("n_maze_supporter")
			
			if_set_visible(var_9_19, "n_maze_supporter", not arg_9_0.vars.isAutomaton and not arg_9_0.vars.isTrialhall and not arg_9_0.vars.isCoop)
			if_set(var_9_36, "text", T("ui_ready_supporter_unusable"))
		elseif arg_9_0.vars.npcteam_id then
			local var_9_37 = var_9_19:findChildByName("n_sinsu_cant")
			
			var_9_37:setPositionY(var_9_37:getPositionY() + 96)
		end
		
		arg_9_0:showTeamFormation()
		arg_9_0:playQuestEffect()
	end
	
	arg_9_0:playQuestEffectGuide()
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
		if_set_visible(var_9_19, "base_pet", false)
	end
	
	StoryLogger:destroyWithViewer()
	LuaEventDispatcher:removeEventListenerByKey("ready.unit_detail_popup")
	LuaEventDispatcher:addEventListener("unit_popup_detail.close", LISTENER(arg_9_0.updateOnLeaveUnitPopupMode, arg_9_0), "ready.unit_detail_popup")
end

function BattleReady.isQuestExistOnReady(arg_17_0)
	if not arg_17_0.vars or not arg_17_0.vars.enter_id then
		return 
	end
	
	return arg_17_0.vars.is_guide_position or Account:getActiveQuestDataInBattle(arg_17_0.vars.enter_id)
end

function BattleReady.playQuestEffect(arg_18_0)
	local var_18_0 = arg_18_0:getBtnGo()
	
	if get_cocos_refid(var_18_0) then
		local var_18_1 = arg_18_0.vars.dlg:getChildByName("n_quest_eff")
		
		if arg_18_0.vars.is_guide_position or Account:getActiveQuestDataInBattle(arg_18_0.vars.enter_id) then
			while get_cocos_refid(var_18_1:getChildByName("@UI_QUEST_BUTTON")) do
				var_18_1:removeChildByName("@UI_QUEST_BUTTON")
			end
			
			EffectManager:Play({
				node_name = "@UI_QUEST_BUTTON",
				z = 99998,
				fn = "ui_quest_button.cfx",
				layer = var_18_1,
				x = var_18_0:getContentSize().width / 2 + 8,
				y = var_18_0:getContentSize().height / 2 + 6
			})
			if_set(var_18_0, "label", T("quest_story_btn"))
			arg_18_0.vars.dlg:getChildByName("icon_arr"):setVisible(false)
			arg_18_0.vars.dlg:getChildByName("icon_quest"):setVisible(true)
		else
			arg_18_0.vars.dlg:getChildByName("icon_quest"):setVisible(false)
		end
	end
end

function BattleReady.playQuestEffectGuide(arg_19_0)
	local function var_19_0()
		for iter_20_0 = 1, 4 do
			local var_20_0 = arg_19_0.vars.formation_wnd:getChildByName("pos" .. iter_20_0)
			
			if get_cocos_refid(var_20_0) then
				local var_20_1
				
				if type(arg_19_0.vars.team_idx) == "table" then
					var_20_1 = arg_19_0.vars.team_idx[tonumber(iter_20_0)]
				else
					var_20_1 = Account:getTeam(arg_19_0.vars.team_idx)[tonumber(iter_20_0)]
				end
				
				if not var_20_1 then
					return true
				end
			end
		end
	end
	
	if arg_19_0.vars.is_guide_position then
		local var_19_1 = arg_19_0:getBtnGo()
		
		if get_cocos_refid(var_19_1) then
			local var_19_2 = arg_19_0.vars.dlg:getChildByName("n_quest_eff")
			local var_19_3 = not var_19_0()
			
			var_19_2:setVisible(var_19_3)
			
			if var_19_3 then
				while get_cocos_refid(var_19_2:getChildByName("@UI_QUEST_BUTTON")) do
					var_19_2:removeChildByName("@UI_QUEST_BUTTON")
				end
				
				EffectManager:Play({
					node_name = "@UI_QUEST_BUTTON",
					z = 99998,
					fn = "ui_quest_button.cfx",
					layer = var_19_2,
					x = var_19_1:getContentSize().width / 2 + 8,
					y = var_19_1:getContentSize().height / 2 + 6
				})
				if_set(var_19_1, "label", T("quest_story_btn"))
				arg_19_0.vars.dlg:getChildByName("icon_arr"):setVisible(false)
				arg_19_0.vars.dlg:getChildByName("icon_quest"):setVisible(true)
			else
				arg_19_0.vars.dlg:getChildByName("icon_quest"):setVisible(false)
			end
		end
	end
end

function BattleReady.onButtonClose(arg_21_0)
	arg_21_0:saveTeamInfo()
	arg_21_0:showSimpleInfo()
	
	if arg_21_0.vars.callback and arg_21_0.vars.callback.onCloseBattleReadyDialog then
		arg_21_0.vars.callback:onCloseBattleReadyDialog()
		arg_21_0:hide(true)
	else
		set_high_fps_tick()
		arg_21_0:hide(true)
	end
	
	BackButtonManager:pop()
	TopBarNew:pop()
	Analytics:closePopup()
end

function BattleReady.getDlg(arg_22_0)
	if not arg_22_0.vars then
		return nil
	end
	
	return arg_22_0.vars.dlg
end

function BattleReady.setUserInfoAtSideUI(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_1:findChildByName("n_lv_0")
	local var_23_1, var_23_2 = UIUtil:numberDigitsToCharOffsets(arg_23_2.level, {
		1,
		2
	}, {
		42,
		21
	})
	
	UIUtil:warpping_setLevel(var_23_0, arg_23_2.level, 99, 2, {
		force_offset = true,
		offset_per_char = var_23_1
	})
	UIUtil:getUserIcon(arg_23_3, {
		parent = arg_23_1:findChildByName("n_face"),
		border_code = arg_23_2.border_code
	})
	
	local var_23_3 = arg_23_3:getTotalSkillLevel()
	
	if_set_visible(arg_23_1, "skill_up_bg", var_23_3 and var_23_3 > 0)
	
	if var_23_3 and var_23_3 > 0 then
		if_set(arg_23_1, "skill_up", "+" .. var_23_3)
	end
	
	var_23_2 = var_23_2 or 0
	
	if var_23_2 > 1 then
		var_23_0.prv_position = var_23_0.prv_position or var_23_0:getPositionX()
		
		var_23_0:setPositionX(var_23_0.prv_position + (1 - var_23_2) * 10.5)
	end
end

function BattleReady.setDevoteDetailAtSideUI(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0, var_24_1 = arg_24_3:getDevoteSkill()
	
	UIUtil:setDevoteDetail_new(arg_24_1, arg_24_3, {
		target = "n_dedi",
		fit_sprite = true
	})
	
	local var_24_2 = arg_24_1:getChildByName("n_dedi"):getChildByName("icon")
	
	if var_24_1 == 0 then
		local var_24_3 = arg_24_1:getChildByName("n_grade_locked")
		
		var_24_2.prv_position = var_24_2:getPositionX()
		
		var_24_2:setPositionX(var_24_3:getPositionX())
	elseif var_24_2 and var_24_2.prv_position then
		var_24_2:setPositionX(var_24_2.prv_position)
	end
end

function BattleReady.setSupporterSideUI(arg_25_0)
	local var_25_0 = BattleReadyFriends:getLastSelectedUnit()
	
	if var_25_0 then
		BattleReadyVisible:setVisibleOptional(arg_25_0.vars.dlg, "enable_support")
		
		local var_25_1 = (BattleReadyFriends:getLastUseFriend(arg_25_0.vars.enter_id) or {}).account_data or {}
		local var_25_2 = arg_25_0.vars.dlg:findChildByName("n_supporter_enable")
		
		if var_25_0:isFriendNPC() then
			if_set_visible(var_25_2, "npc_text", true)
			if_set_visible(var_25_2, "player_text", false)
			if_set(var_25_2, "npc_text", T("npc_friend", {
				name = T(var_25_0.db.name)
			}))
		else
			if_set_visible(var_25_2, "npc_text", false)
			if_set_visible(var_25_2, "player_text", true)
			if_set(var_25_2, "name", var_25_1.name)
		end
		
		arg_25_0:setUserInfoAtSideUI(var_25_2, var_25_1, var_25_0)
		arg_25_0:setDevoteDetailAtSideUI(var_25_2, var_25_1, var_25_0)
	else
		BattleReadyVisible:setVisibleOptional(arg_25_0.vars.dlg, "disable_support")
	end
end

function BattleReady.showDifficulty(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2 then
		arg_26_0.vars.opts.use_friend = BattleReadyFriends:useFriend(arg_26_0.vars.enter_id)
	end
	
	if_set_visible(arg_26_0.vars.dlg, "n_team_formation", false)
	arg_26_0:setVisibleBtnGo(false)
	arg_26_0:showLimitInfo(false)
	BattleSelectDiffculty:show(arg_26_0.vars.dlg, arg_26_0.vars.difficulty_id, arg_26_1)
	BattleReadyVisible:setVisible(arg_26_0.vars.dlg, "difficulty")
	arg_26_0:setSupporterSideUI()
end

function BattleReady.setDifficulty(arg_27_0, arg_27_1)
	if not arg_27_0.vars.difficulty_id then
		return 
	end
	
	arg_27_0.vars.difficulty_level = arg_27_1 or 0
	
	if arg_27_0.vars.difficulty_level == 0 then
		arg_27_0.vars.enter_id = arg_27_0.vars.difficulty_id
	else
		local var_27_0 = DB("level_difficulty", arg_27_0.vars.difficulty_id, "difficulty_" .. tostring(arg_27_0.vars.difficulty_level))
		
		if not var_27_0 then
			return 
		end
		
		arg_27_0.vars.enter_id = var_27_0
	end
	
	arg_27_0.vars.opts.difficulty_level = arg_27_1 or 0
	arg_27_0.vars.opts.enter_id = arg_27_0.vars.enter_id
	arg_27_0.vars.opts.difficulty_id = arg_27_0.vars.difficulty_id
	
	arg_27_0:updateEntrance()
	arg_27_0:updateUI()
end

function BattleReady.setVisibleBtnGo(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = not arg_28_2
	local var_28_1 = arg_28_0.vars.dlg:getChildByName("n_content")
	
	if get_cocos_refid(var_28_1) then
		local var_28_2 = arg_28_0.vars.isAutomaton ~= true or var_28_0
		
		if_set_visible(var_28_1, "btn_go", var_28_2 and arg_28_1)
	end
	
	local var_28_3 = arg_28_0.vars.dlg:getChildByName("n_content_tower")
	
	if get_cocos_refid(var_28_3) then
		local var_28_4 = arg_28_0.vars.isAutomaton == true or var_28_0
		
		if_set_visible(var_28_3, "btn_go", var_28_4 and arg_28_1)
	end
end

function BattleReady.setDifficultySideUI(arg_29_0)
	local var_29_0 = DB("level_enter", arg_29_0.vars.enter_id, "use_enterpoint")
	local var_29_1 = BattleReady:GetReqPointAndRewards(arg_29_0.vars.enter_id)
	local var_29_2 = arg_29_0.vars.dlg:findChildByName("n_difficulty_enable"):findChildByName("n_icon_difficulty")
	local var_29_3 = arg_29_0.vars.difficulty_level or tonumber(SAVE:get("difficulty." .. arg_29_0.vars.difficulty_id, 1)) - 1
	
	for iter_29_0 = 0, 3 do
		if_set_visible(var_29_2, tostring(iter_29_0), iter_29_0 == var_29_3)
		
		if iter_29_0 == var_29_3 then
			if_set_sprite(var_29_2, "n_select_bg", "img/_cm_difficulty0" .. iter_29_0 + 1 .. "_s.png")
		end
	end
	
	local var_29_4 = arg_29_0.vars.dlg:findChildByName("n_difficulty_enable")
	
	if_set(var_29_4, "t_power", comma_value(var_29_1))
	if_set(var_29_4, "t_stamina", tostring(var_29_0))
	
	local var_29_5 = {
		[0] = "ui_battle_ready_difficulty_easy",
		"ui_battle_ready_difficulty_normal",
		"ui_battle_ready_difficulty_hard",
		"ui_battle_ready_difficulty_hell"
	}
	
	if_set(var_29_4, "label", T(var_29_5[var_29_3]))
end

function BattleReady.showSupportFriend(arg_30_0)
	if not arg_30_0.vars or not arg_30_0.vars.dlg or not get_cocos_refid(arg_30_0.vars.dlg) then
		return 
	end
	
	BattleReadyVisible:setVisible(arg_30_0.vars.dlg, "support_friend")
	
	if not arg_30_0.vars.difficulty_id then
		BattleReadyVisible:setVisibleOptional(arg_30_0.vars.dlg, "disable_difficulty")
		if_set_visible(getChildByPath(arg_30_0.vars.dlg:getChildByName("n_select_difficulty"), "btn_change_difficulty"), nil, false)
	else
		BattleReadyVisible:setVisibleOptional(arg_30_0.vars.dlg, "enable_difficulty")
		if_set_visible(getChildByPath(arg_30_0.vars.dlg:getChildByName("n_select_difficulty"), "btn_change_difficulty"), nil, true)
		arg_30_0:setDifficultySideUI()
	end
	
	arg_30_0:setVisibleBtnGo(false)
	arg_30_0:showLimitInfo(false)
	
	if arg_30_0.vars.enter_id == "rai001" then
		TutorialGuide:startGuide("supporter_select")
	end
end

function BattleReady.showTeamFormation(arg_31_0)
	if not arg_31_0.vars or not arg_31_0.vars.dlg or not get_cocos_refid(arg_31_0.vars.dlg) then
		return 
	end
	
	BattleReadyVisible:setVisible(arg_31_0.vars.dlg, "team_formation")
	arg_31_0:setVisibleBtnGo(true, true)
	arg_31_0:playQuestEffect()
	
	if arg_31_0.vars.opts.enter_error_text then
		if_set_visible(arg_31_0.vars.dlg, "btn_difficulty_select", false)
	end
	
	local var_31_0 = BattleReadyFriends:getLastSelectedUnit()
	local var_31_1 = BattleReadyFriends:getLastUseFriend(arg_31_0.vars.enter_id)
	local var_31_2 = arg_31_0.vars.dlg:getChildByName("base_support"):getChildByName("n_face")
	local var_31_3
	
	if var_31_0 and var_31_0:isFriendNPC() then
		var_31_3 = var_31_0.db.code
	end
	
	local var_31_4 = arg_31_0.vars.isAutomaton or arg_31_0.vars.isTrialhall or arg_31_0.vars.isCoop
	
	if var_31_0 then
		var_31_2:removeAllChildren()
		if_set_visible(arg_31_0.vars.form, "n_no_supporter", false)
		
		local var_31_5 = (var_31_1 or {}).account_data or {}
		
		if var_31_3 then
			var_31_5.border_code = "ma_border1"
		end
		
		UIUtil:getUserIcon(var_31_0, {
			scale = 1.4,
			parent = var_31_2,
			border_code = var_31_5.border_code
		})
		arg_31_0:playBatchEffect(var_31_0)
		
		local var_31_6 = arg_31_0.vars.form:findChildByName("base_support")
		
		if arg_31_0.vars.story_powerup_units and arg_31_0.vars.story_powerup_units[var_31_0.db.code] then
			if_set_visible(var_31_6, "n_buff_story", true)
		else
			if_set_visible(var_31_6, "n_buff_story", false)
		end
	else
		var_31_2:removeAllChildren()
	end
	
	if_set_visible(arg_31_0.vars.form, "n_none_support", var_31_0 == nil)
	if_set_visible(arg_31_0.vars.form, "icon_friends", var_31_0 ~= nil)
	
	if arg_31_0.vars.is_guide_position then
		arg_31_0:showChangeButtonWithEffect()
	end
	
	arg_31_0:updateTeamPoint(arg_31_0.vars.custom_team or nil, var_31_0, {
		is_nullable_supporter = true,
		no_summon = var_31_4
	})
	
	if arg_31_0.vars.difficulty_id and Account:checkEnterMap(arg_31_0:getEnterID(), {}) then
		local var_31_7 = arg_31_0.vars.difficulty_level or tonumber(SAVE:get("difficulty." .. arg_31_0.vars.difficulty_id, 1)) - 1
		
		var_31_7 = var_31_7 or 0
		
		arg_31_0:updateDiffculty(var_31_7)
		BattleRepeat:update_repeatCheckbox()
	end
	
	arg_31_0:updateTeamArtifactBonus(arg_31_0.vars.custom_team or nil)
	arg_31_0:showLimitInfo(true)
	arg_31_0:setVisibleQuestEffectNode(not arg_31_0.vars.edit_mode)
	
	local var_31_8 = Bistro:getEatingUnits() or {}
	
	if #var_31_8 > 0 then
		TutorialGuide:startGuide("system_050")
	end
	
	if #var_31_8 > 0 and ConditionContentsManager:isMissionCleared("ep1_2_10") then
		TutorialGuide:startGuide("heal_all")
	end
	
	if arg_31_0.vars.isAutomaton then
		local var_31_9 = Account:getAutomatonHPInfo() or {}
		
		if not table.empty(var_31_9) and not TutorialGuide:isClearedTutorial("auto_heal") then
			for iter_31_0, iter_31_1 in pairs(var_31_9) do
				if tonumber(iter_31_1) < 1000 then
					TutorialGuide:startGuide("auto_heal")
					
					break
				end
			end
		end
	end
	
	if VIEW_WIDTH > DESIGN_WIDTH and not arg_31_0.vars.formation_moved then
		local var_31_10 = arg_31_0.vars.form:findChildByName("formation")
		local var_31_11 = (VIEW_WIDTH - DESIGN_WIDTH) / 2
		
		var_31_10:setPositionX(var_31_10:getPositionX() + var_31_11)
		
		arg_31_0.vars.formation_moved = true
	end
	
	TutorialGuide:onShowTeamFormationBattleReady(arg_31_0.vars.enter_id)
	
	if arg_31_0.vars.enter_id == "vfm0bb013" or arg_31_0.vars.enter_id == "vfm0bb014" or arg_31_0.vars.enter_id == "vfm0bb015" then
		TutorialGuide:startGuide("vfm0ba_token_stage")
	end
end

function BattleReady.isShow(arg_32_0)
	return arg_32_0.vars and get_cocos_refid(BattleReady.vars.dlg)
end

function BattleReady.hide(arg_33_0, arg_33_1)
	if arg_33_1 and arg_33_0.vars and get_cocos_refid(arg_33_0.vars.dlg) then
		arg_33_0.vars.dlg:removeFromParent()
	elseif arg_33_0.vars and get_cocos_refid(arg_33_0.vars.dlg) then
		local var_33_0 = SceneManager:getRunningNativeScene()
		local var_33_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_33_1:setPositionX(VIEW_BASE_LEFT)
		var_33_1:setContentSize({
			width = VIEW_WIDTH,
			height = VIEW_HEIGHT
		})
		var_33_1:setOpacity(0)
		var_33_0:addChild(var_33_1)
		UIAction:Add(SEQ(LOG(FADE_IN(500)), REMOVE()), var_33_1, "block")
		UIAction:Add(SEQ(DELAY(500), REMOVE()), arg_33_0.vars.dlg, "block")
	end
	
	arg_33_0.vars = {}
	
	LuaEventDispatcher:removeEventListenerByKey("ready.update_unit_popup")
	LuaEventDispatcher:removeEventListenerByKey(arg_33_0._formation_event_uid)
	BattleReadyFriends:clear()
end

function BattleReady.procCheckEnter(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	if arg_34_0.vars and arg_34_0.vars.npcteam_id then
	else
		if not UIUtil:checkUnitInven() then
			return 
		end
		
		if not UIUtil:checkTotalInven() then
			return 
		end
	end
	
	local var_34_0 = arg_34_0.vars.team_idx or Account:getCurrentTeamIndex()
	
	if not (Account:getTeamMemberCount(var_34_0, true) < 1) or arg_34_0.vars and arg_34_0.vars.npcteam_id then
	else
		balloon_message_with_sound("hero_cant_getin")
		
		return 
	end
	
	local var_34_1 = DB("level_enter", arg_34_2, "full_hp") == "y"
	local var_34_2 = Account:getCurrentTeam()
	
	for iter_34_0 = 1, 4 do
		if not arg_34_3 and not var_34_1 and var_34_2[iter_34_0] then
		end
	end
	
	return true
end

function BattleReady.lack_trial_token(arg_35_0)
	if arg_35_0.vars.lack_enter_item == "to_trial" then
		local var_35_0 = "buy.no_to_trial"
		local var_35_1 = true
		local var_35_2 = DungeonTrialHall:getTargetId()
		
		local function var_35_3()
			if var_35_2 then
				Shop:open("normal", string.sub(var_35_0, 11, -1), true)
			else
				Log.e("BattleReady.lack_trial_token", "no_target_id_in")
			end
		end
		
		if var_35_2 then
			local var_35_4 = load_dlg("shop_nocurrency", true, "wnd")
			
			if not var_35_1 then
				var_35_3 = nil
			end
			
			if_set(var_35_4, T(var_35_0 .. ".desc"))
			UIUtil:getRewardIcon(nil, string.sub(var_35_0, 8, -1), {
				show_name = true,
				detail = true,
				parent = var_35_4:getChildByName("n_item_pos")
			})
			Dialog:msgBox(T(var_35_0 .. ".desc"), {
				dlg = var_35_4,
				handler = var_35_3,
				yesno = var_35_1,
				title = T(var_35_0 .. ".title"),
				txt_shop_comment = T(var_35_0 .. ".comment")
			})
		else
			Log.e("BattleReady.lack_trial_token", "no_target_id_out")
		end
		
		return true
	end
	
	return false
end

function BattleReady.onEnter(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if not arg_37_0:procCheckEnter(arg_37_0.vars.dlg, arg_37_0.vars.enter_id, arg_37_1, function()
		arg_37_0:updateHeroTags()
	end, true) then
		return 
	end
	
	if not arg_37_0.vars.opts.practice_mode and not DungeonHell:isChallengeRetryMode(arg_37_0.vars.enter_id) and not arg_37_0.vars.enterable and not arg_37_0.vars.opts.automaton_free_enter then
		if arg_37_0.vars.lack_enter_item == "to_stamina" then
			UIUtil:wannaBuyStamina("battle.ready")
			
			return 
		end
		
		if arg_37_0.vars.lack_enter_item == "to_mazekey" then
			UIUtil:wannaBuyMazekey("battle.ready")
			
			return 
		end
		
		if arg_37_0.vars.lack_enter_item == "to_mazekey2" then
			UIUtil:wannaBuyMazekey2("battle.ready")
			
			return 
		end
		
		if arg_37_0.vars.lack_enter_item == "to_abysskey" then
			if DungeonHell:isAbyssHardMap(arg_37_0.vars.enter_id) then
				balloon_message_with_sound("not_enough_enter_token")
			else
				UIUtil:wannaBuyAbysskey("battle.ready")
			end
			
			return 
		end
		
		if arg_37_0:lack_trial_token() then
			return 
		end
		
		if DB("item_material", arg_37_0.vars.lack_enter_item, "id") then
			balloon_message_with_sound("not_enough_enter_item")
		else
			balloon_message_with_sound("battle_cant_getin")
		end
		
		return 
	end
	
	if arg_37_0.vars.isAutomaton then
		if DungeonAutomaton:checkAutomatonWeekChange() then
			return 
		end
		
		if arg_37_0.vars and arg_37_0.vars.enter_id then
			if string.starts(arg_37_0.vars.enter_id, "autome") and not AutomatonUtil:canSelect5Level() then
				return 
			end
			
			local var_37_0 = tonumber(string.sub(arg_37_0.vars.enter_id, 7, -1)) or -1
			local var_37_1 = Account:get_automaton_floor() + 1
			local var_37_2 = tonumber(Account:getAutomatonClearedFloor()) + 1
			
			if var_37_0 ~= var_37_1 or var_37_2 < var_37_0 then
				return 
			end
		end
	end
	
	local function var_37_3(arg_39_0)
		for iter_39_0, iter_39_1 in pairs(arg_39_0 or {}) do
			if Account:getUnitByCode(iter_39_1) then
				return true
			end
		end
		
		return false
	end
	
	if arg_37_0.vars.enter_id == "poe010" and not Account:isMapCleared("poe010") and not var_37_3({
		"c1005",
		"c0001",
		"c0002"
	}) then
		balloon_message_with_sound("msg_enter_limit_no_merc")
		
		return 
	end
	
	if arg_37_0.vars.enter_id == "poe017" and not Account:isMapCleared("poe017") and not var_37_3({
		"c0001"
	}) then
		balloon_message_with_sound("msg_enter_limit_no_merc")
		
		return 
	end
	
	if arg_37_2 == nil and Account:getCampSaveData(arg_37_0.vars.opts.enter_id) then
		Dialog:msgBox(T("exist_already_saved_data"), {
			yesno = true,
			handler = function()
				arg_37_0:onEnter(arg_37_1, true)
			end,
			cancel_handler = function()
				arg_37_0:onEnter(arg_37_1, false)
			end
		})
		
		return 
	end
	
	local var_37_4 = arg_37_0:checkPointLowerThenRequire()
	
	if arg_37_0.vars.isAutomaton and var_37_4 then
		local var_37_5 = Account:get_automaton_week_id()
		
		if SAVE:get("atmt_week_popup", 1) == var_37_5 then
			arg_37_3 = true
		end
	end
	
	if not arg_37_3 and var_37_4 then
		BattleReady:ShowLowerPointWarningPopup(nil, arg_37_0.vars.isAutomaton)
		
		return 
	end
	
	SoundEngine:play("event:/ui/battle_ready/btn_go")
	BattleSelectDiffculty:save(arg_37_0.vars.difficulty_id, arg_37_0.vars.difficulty_level, arg_37_0.vars.save_override_flag)
	
	arg_37_0.vars.opts.play_continue = arg_37_2
	
	if arg_37_0.vars.callback and arg_37_0.vars.callback.onStartBattle then
		local var_37_6 = Account:getCurrentTeam()
		local var_37_7 = Account:getCurrentTeamIndex()
		
		if arg_37_0.vars.isAutomaton then
			local var_37_8 = Account:getTeam(Account:getAutomatonTeamIndex())
			
			var_37_7 = Account:getAutomatonTeamIndex()
			
			if table.empty(var_37_8) then
				balloon_message_with_sound("hero_cant_getin")
				
				return 
			end
			
			arg_37_0.vars.opts.is_automaton = true
		elseif arg_37_0.vars.isCrehunt then
			local var_37_9 = Account:getTeam(Account:getCrehuntTeamIndex())
			
			var_37_7 = Account:getCrehuntTeamIndex()
			
			if Account:getTeamMemberCount(var_37_7, true) < 1 then
				balloon_message_with_sound("hero_cant_getin")
				
				return 
			end
			
			arg_37_0.vars.opts.is_crehunt = true
		end
		
		arg_37_0.vars.opts.npcteam_id = arg_37_0.vars.npcteam_id
		
		BattleRepeat:initBeforeBattleStart(var_37_7, arg_37_0.vars.enter_id, arg_37_0.vars.opts)
		arg_37_0.vars.callback:onStartBattle(arg_37_0.vars.opts)
	end
end

function _updateMissionBanner(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = DB("level_enter", arg_42_1, "mission" .. arg_42_2)
	
	if not var_42_0 then
		arg_42_0:setVisible(false)
		
		return 
	end
	
	local var_42_1, var_42_2, var_42_3, var_42_4, var_42_5, var_42_6, var_42_7, var_42_8, var_42_9 = DB("mission_data", var_42_0, {
		"name",
		"icon",
		"lobby_tooltip",
		"condition",
		"value",
		"reward_type",
		"reward_icon",
		"reward_id1",
		"reward_count1"
	})
	
	if var_42_1 == nil then
		arg_42_0:setVisible(false)
		
		return 
	end
	
	arg_42_0:setVisible(true)
	
	local var_42_10 = ""
	
	if var_42_8 then
		if string.split(var_42_8, "_")[1] == "to" then
			local var_42_11
			
			var_42_11 = DB("item_token", var_42_8, "icon") or ""
		elseif string.starts(var_42_8, "e") then
			local var_42_12
			
			var_42_12 = DB("equip_item", var_42_8, "icon") or ""
		end
	end
	
	if_set(arg_42_0, "disc", T(var_42_1))
	
	local var_42_13 = arg_42_0:getChildByName("item")
	
	arg_42_3 = arg_42_3 or 0.4
	
	local var_42_14 = cc.Sprite:create("img/cm_icon_starmap.png")
	
	var_42_14:setScale(arg_42_3)
	var_42_13:addChild(var_42_14)
	
	if Account:isDungeonMissionClearedByMissionId(arg_42_1, var_42_0) then
		local var_42_15 = cc.Sprite:create("img/cm_icon_check_b.png")
		
		var_42_15:setColor(cc.c3b(100, 203, 0))
		var_42_15:setScale(0.8)
		var_42_15:setAnchorPoint(0, 0)
		var_42_13:addChild(var_42_15)
		if_set_color(arg_42_0, "disc", cc.c4b(107, 193, 27))
	else
		if_set_color(arg_42_0, "disc", cc.c4b(171, 135, 89))
	end
	
	return true
end

function _getMissionRewardItem(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = DB("level_enter", arg_43_0, "mission" .. arg_43_1)
	
	if not var_43_0 then
		return 
	end
	
	local var_43_1, var_43_2, var_43_3 = DB("mission_data", var_43_0, {
		"reward_type",
		"reward_id1",
		"reward_count1"
	})
	
	if var_43_2 == nil then
		return 
	end
	
	local var_43_4 = Account:isDungeonMissionCleared(arg_43_0, arg_43_1) == true and true or nil
	local var_43_5 = var_43_4 == nil and true or nil
	
	return {
		var_43_2,
		var_43_3,
		mission_clear = var_43_4,
		star_reward = var_43_5
	}
end

function BattleReady.getLevelBaseBuffWeight(arg_44_0, arg_44_1)
	local var_44_0 = 1
	
	if arg_44_1 then
		local var_44_1 = string.split(arg_44_1, ",")
		
		for iter_44_0, iter_44_1 in pairs(var_44_1) do
			local var_44_2, var_44_3 = DB("cs", iter_44_1, {
				"map_point_weight",
				"cs_timing"
			})
			
			var_44_0 = var_44_0 + to_n(var_44_2)
		end
	end
	
	return var_44_0
end

function BattleReady.GetReqPointAndRewards(arg_45_0, arg_45_1)
	local var_45_0 = false
	local var_45_1
	
	if arg_45_1 and DB("level_automaton", arg_45_1, "id") then
		var_45_0 = true
		var_45_1 = arg_45_1
		
		local var_45_2 = DungeonAutomaton:getRound() or 1
		local var_45_3 = DungeonAutomaton:getRewardRound() or 1
		
		arg_45_1 = arg_45_1 .. string.format("@%d@%d", var_45_2, var_45_3)
	end
	
	local var_45_4 = {}
	local var_45_5 = {}
	local var_45_6 = {}
	local var_45_7 = DungeonMaze:getGoldChestItems(arg_45_1) or {}
	local var_45_8 = 0
	local var_45_9 = 0
	local var_45_10 = to_n(DB("level_enter_drops", arg_45_1, "battle"))
	local var_45_11, var_45_12 = DB("level_enter", arg_45_1, {
		"mob_buff",
		"mob_buff_lv"
	})
	local var_45_13 = arg_45_0:getLevelBaseBuffWeight(var_45_11)
	
	for iter_45_0 = 1, 40 do
		local var_45_14, var_45_15, var_45_16, var_45_17, var_45_18, var_45_19, var_45_20, var_45_21 = DB("level_enter_drops", arg_45_1, {
			"item" .. iter_45_0,
			"type" .. iter_45_0,
			"set" .. iter_45_0,
			"grade_rate" .. iter_45_0,
			"monster" .. iter_45_0,
			"lv" .. iter_45_0,
			"power" .. iter_45_0,
			"count" .. iter_45_0
		})
		
		if var_45_14 and not UIUtil:isHideItem(var_45_14) then
			table.push(var_45_7, {
				var_45_14,
				var_45_15,
				var_45_16,
				var_45_17
			})
		end
		
		if var_45_18 and var_45_18 ~= "cleardummy" then
			local var_45_22 = UNIT:create({
				code = var_45_18,
				lv = var_45_19,
				p = var_45_20
			})
			
			if var_45_11 then
				var_45_22:applyLevelBaseBuff(var_45_11, var_45_12)
			end
			
			var_45_9 = var_45_9 + var_45_21
			var_45_8 = var_45_8 + var_45_22:getPoint() * var_45_21
			
			local var_45_23 = DB("character", var_45_18, "monster_tier") or "normal"
			local var_45_24 = var_45_18 .. ":" .. var_45_23
			
			if not var_45_4[var_45_24] then
				var_45_4[var_45_24] = {
					m = var_45_18,
					lv = var_45_19,
					tier = var_45_23
				}
			elseif var_45_19 > var_45_4[var_45_24].lv then
				var_45_4[var_45_24].lv = var_45_19
			end
		end
	end
	
	local var_45_25 = var_45_8 * var_45_13
	local var_45_26, var_45_27, var_45_28 = DB("level_enter", arg_45_1, {
		"show_first_clear_reward_half",
		"show_first_clear_reward",
		"show_change_reward"
	})
	local var_45_29 = var_45_26 ~= nil and totable(var_45_26) or nil
	local var_45_30 = var_45_27 ~= nil and totable(var_45_27) or nil
	
	if var_45_30 then
		for iter_45_1, iter_45_2 in pairs(var_45_30) do
			if type(iter_45_2) == "string" then
				var_45_30[iter_45_1] = {
					iter_45_2
				}
			end
		end
	end
	
	if var_45_29 then
		for iter_45_3, iter_45_4 in pairs(var_45_29) do
			if type(iter_45_4) == "string" then
				var_45_29[iter_45_3] = {
					iter_45_4
				}
			end
		end
	end
	
	if Account:isMapCleared(arg_45_1) then
		for iter_45_5, iter_45_6 in pairs(var_45_29 or {}) do
			iter_45_6.is_half = true
			
			table.push(var_45_7, iter_45_6)
		end
	end
	
	for iter_45_7, iter_45_8 in pairs(var_45_30 or {}) do
		iter_45_8.is_half = Account:isMapCleared(arg_45_1)
		iter_45_8.first_reward = true
		
		table.push(var_45_7, iter_45_8)
	end
	
	local var_45_31 = UIUtil:sortDisplayItems(var_45_7, arg_45_1)
	local var_45_32
	
	if var_45_28 then
		var_45_31 = {}
		var_45_32 = totable(var_45_28)
		
		for iter_45_9 = 1, 99 do
			local var_45_33 = var_45_32[tostring(iter_45_9)]
			
			if not var_45_33 then
				break
			end
			
			table.push(var_45_31, var_45_33)
		end
	end
	
	local var_45_34 = 0
	
	if var_45_0 and var_45_1 then
		local var_45_35 = DB("level_automaton", var_45_1, {
			"monster_power"
		})
		
		if var_45_35 then
			var_45_34 = var_45_35
		end
	else
		if var_45_10 > 0 then
			var_45_34 = math.floor(var_45_25 / var_45_9 * (var_45_9 / var_45_10))
		else
			var_45_34 = 0
		end
		
		local var_45_36, var_45_37 = DB("level_enter", arg_45_1, {
			"difficulty_id",
			"add_battle_power"
		})
		
		if var_45_36 and var_45_37 then
			var_45_34 = to_n(var_45_37)
		else
			var_45_34 = var_45_34 + to_n(var_45_37)
		end
	end
	
	return var_45_34, var_45_4, var_45_31
end

function BattleReady.updateUI(arg_46_0)
	local var_46_0, var_46_1, var_46_2, var_46_3, var_46_4 = DB("level_enter", arg_46_0.vars.enter_id, {
		"name",
		"local",
		"type",
		"tag_icon",
		"subcus_value"
	})
	
	arg_46_0.vars.tag_icon_name = decodeTownTagIcon(var_46_3)
	
	if_set_visible(arg_46_0.vars.dlg, "n_simple_info", false)
	
	if arg_46_0.vars.tag_icon_name then
		if_set_sprite(arg_46_0.vars.dlg, "spr_tag_icon", "map/" .. arg_46_0.vars.tag_icon_name .. ".png")
		arg_46_0:showSimpleInfo(true, 360, true)
	end
	
	if_set_visible(arg_46_0.vars.dlg, "spr_tag_icon", arg_46_0.vars.tag_icon_name and true)
	if_set_visible(arg_46_0.vars.dlg, "spr_tag_icon", arg_46_0.vars.tag_icon_name and true)
	if_set_visible(arg_46_0.vars.dlg, "spr_tag_seal", false)
	
	local var_46_5 = arg_46_0:getRightContentWnd()
	
	if arg_46_0.vars.isAutomaton then
		var_46_1 = T(var_46_1, {
			level = Account:getAutomatonLevel()
		})
	else
		var_46_1 = T(var_46_1)
	end
	
	if_set(var_46_5, "txt_zone", var_46_1)
	if_set(var_46_5, "txt_title", T(var_46_0))
	if_set_visible(arg_46_0.vars.dlg, "check_loop", var_46_2 ~= "abyss")
	
	if arg_46_0.vars.isCoop then
		local var_46_6 = CoopMission:getCurrentRoom()
		
		if not var_46_6 then
			return 
		end
		
		local var_46_7 = var_46_6:getBossInfo()
		
		if not var_46_7 then
			return 
		end
		
		local var_46_8 = var_46_5:findChildByName("n_expedition")
		
		if_set_visible(var_46_8, nil, true)
		CoopUtil:setDifficulty(var_46_8, tonumber(var_46_7.difficulty), "txt_boss_level")
	end
	
	local var_46_11, var_46_12
	
	if var_46_4 and SubstoryManager:canShowSubCusUI() then
		local var_46_9 = totable(var_46_4)
		
		if var_46_9 and not table.empty(var_46_9) then
			var_46_5:getChildByName("n_custom"):setVisible(true)
			
			local var_46_10 = table.count(var_46_9) % 2 == 1
			
			var_46_11 = nil
			
			if var_46_10 then
				var_46_11 = var_46_5:getChildByName("n_odd")
			else
				var_46_11 = var_46_5:getChildByName("n_even")
			end
			
			var_46_11:setVisible(true)
			
			var_46_12 = 1
			
			for iter_46_0, iter_46_1 in pairs(var_46_9) do
				local var_46_13 = tonumber(iter_46_1) or 1
				local var_46_14 = iter_46_0
				local var_46_15 = var_46_11:getChildByName("n_" .. var_46_12)
				
				if not var_46_15 then
					break
				end
				
				var_46_15:setVisible(true)
				UIUtil:getRewardIcon(nil, var_46_14, {
					no_count = true,
					parent = var_46_15:getChildByName("n_item" .. var_46_12)
				})
				if_set(var_46_15, "txt_count" .. var_46_12, var_46_13)
				
				var_46_12 = var_46_12 + 1
			end
		end
	end
end

function BattleReady.initAutomatonUI(arg_47_0, arg_47_1)
	if not arg_47_0.vars.isAutomaton then
		return 
	end
	
	local var_47_0 = arg_47_0:getRightContentWnd()
	local var_47_1 = "monster_" .. DungeonAutomaton:getAutomatonMonsterDeviceRotateId()
	local var_47_2 = DB("level_automaton", arg_47_0.vars.enter_id, {
		var_47_1
	})
	local var_47_3 = {}
	
	if var_47_2 then
		for iter_47_0 = 1, 99 do
			local var_47_4 = var_47_2 .. "_" .. iter_47_0
			local var_47_5 = DBT("level_automaton_device", var_47_4, {
				"id",
				"category",
				"sort",
				"sort",
				"cs",
				"skill_1",
				"grade_1"
			})
			
			if not var_47_5.id then
				break
			end
			
			table.insert(var_47_3, var_47_5)
		end
		
		table.sort(var_47_3, function(arg_48_0, arg_48_1)
			return arg_48_0.sort < arg_48_1.sort
		end)
	end
	
	local var_47_6 = arg_47_1 <= Account:getAutomatonClearedFloor()
	
	if arg_47_0.vars and arg_47_0.vars.opts then
		arg_47_0.vars.opts.is_already_cleared = var_47_6
	end
	
	if_set_visible(var_47_0, "n_item_none", var_47_6)
	if_set_visible(var_47_0, "n_free_tip", var_47_6)
	
	if var_47_6 then
		local var_47_7 = var_47_0:getChildByName("n_free_tip")
		
		if_set(var_47_7, "txt_free_info", T("automtn_enter_free"))
		
		if var_47_7 then
			UIAction:Add(SEQ(DELAY(3000), LOG(FADE_OUT(500)), REMOVE()), var_47_7)
		end
		
		arg_47_0.vars.opts.automaton_free_enter = true
	end
	
	arg_47_0.vars.scrollEnemyDevice = {}
	
	copy_functions(ScrollView, arg_47_0.vars.scrollEnemyDevice)
	
	local var_47_8 = var_47_0:getChildByName("scroll_monster_device")
	
	function arg_47_0.vars.scrollEnemyDevice.getScrollViewItem(arg_49_0, arg_49_1)
		local var_49_0 = UIUtil:getDeviceIcon(arg_49_1.skill_1, {
			category = "monster",
			id = arg_49_1.id
		})
		
		var_49_0:setScale(0.7)
		
		return var_49_0
	end
	
	function arg_47_0.vars.scrollEnemyDevice.onSelectScrollViewItem(arg_50_0, arg_50_1, arg_50_2)
	end
	
	arg_47_0.vars.scrollEnemyDevice:initScrollView(var_47_8, 65, 65)
	arg_47_0.vars.scrollEnemyDevice:createScrollViewItems(var_47_3)
	
	if table.empty(var_47_3) then
		if_set_visible(var_47_0, "n_monster_dvice_none", true)
	else
		TutorialGuide:startGuide("auto_monster")
	end
end

function BattleReady.initCreviceUI(arg_51_0)
	if not arg_51_0.vars.isCrehunt then
		return 
	end
	
	local var_51_0 = arg_51_0:getRightContentWnd()
	
	if not get_cocos_refid(var_51_0) then
		return 
	end
	
	local var_51_1 = Account:getCrehuntDifficultyByEnterID(arg_51_0.vars.enter_id)
	local var_51_2 = var_51_0:getChildByName("n_boss")
	
	if get_cocos_refid(var_51_2) then
		local var_51_3 = DungeonCreviceUtil:getBossInfoWnd(var_51_1)
		
		if get_cocos_refid(var_51_3) then
			var_51_2:addChild(var_51_3)
		end
	end
	
	local var_51_4 = Account:getCrehuntSeasonAttribute()
	
	if var_51_4 then
		local var_51_5 = var_51_0:getChildByName("n_pro")
		
		if get_cocos_refid(var_51_5) then
			for iter_51_0, iter_51_1 in pairs(var_51_5:getChildren()) do
				if_set_visible(iter_51_1, nil, false)
			end
			
			if_set_visible(var_51_5, "icon_" .. var_51_4, true)
		end
		
		if_set(var_51_0, "txt_desc", T("crevicehunt_use_" .. var_51_4))
	end
	
	local var_51_6 = var_51_0:getChildByName("n_stone")
	
	if get_cocos_refid(var_51_6) then
		if_set(var_51_6, "txt_title_s", T("ui_crevicehunt_runestone_name"))
		DungeonCreviceMain.rune:setRuneSkillIcon(var_51_6)
		if_set(var_51_6, "txt_turn", T("ui_crevicehunt_limit_turn"))
		
		local var_51_7 = (GAME_CONTENT_VARIABLE.crevicehunt_limit_turn or 40) + DungeonCreviceUtil:getTeamReturnAdd()
		
		if_set(var_51_6, "txt_energy", T("ui_crevicehunt_limit_turn_count", {
			value = var_51_7
		}))
		if_set(var_51_6, "txt_damage", T("ui_crevicehunt_runestone_baseskill"))
		
		local var_51_8 = DungeonCreviceUtil:getRuneExp()
		local var_51_9 = DungeonCreviceUtil:getExtraDamageByExp(var_51_8)
		
		if_set(var_51_6, "txt_strong", T("ui_crevicehunt_runestone_baseskill_count", {
			value = var_51_9
		}))
	end
	
	DungeonCreviceUtil:openBossResetPopup(var_51_1)
	
	if DungeonCreviceUtil:isFirstEnter() then
		arg_51_0:showRetryInfo()
	end
end

function BattleReady.showRetryInfo(arg_52_0)
	if not arg_52_0.vars.isCrehunt then
		return 
	end
	
	local var_52_0 = arg_52_0:getRightContentWnd()
	
	if get_cocos_refid(var_52_0) then
		local var_52_1 = var_52_0:getChildByName("n_retry_tip")
		
		if get_cocos_refid(var_52_1) then
			if_set(var_52_1, "txt_info_retry", T("tag_crehunt_stamina"))
			var_52_1:setVisible(true)
			var_52_1:setScale(0)
			
			local var_52_2 = 1
			local var_52_3 = SEQ(DELAY(6000), RLOG(SCALE(80, 1, 0)), SHOW(false))
			
			UIAction:Add(SEQ(DELAY(to_n(360)), LOG(SCALE(150, 0, var_52_2 * 1.1)), DELAY(50), RLOG(SCALE(80, var_52_2 * 1.1, var_52_2)), var_52_3), var_52_1)
		end
	end
end

function BattleReady.getRightContentWnd(arg_53_0)
	local var_53_0
	
	if arg_53_0.vars.isAutomaton then
		var_53_0 = arg_53_0.vars.dlg:getChildByName("n_content_tower")
	elseif arg_53_0.vars.isCrehunt then
		var_53_0 = arg_53_0.vars.dlg:getChildByName("n_crevice")
	else
		var_53_0 = arg_53_0.vars.dlg:getChildByName("n_content")
	end
	
	return var_53_0
end

function BattleReady.getEnemyList(arg_54_0)
	if not arg_54_0.vars then
		return 
	end
	
	return arg_54_0:getRightContentWnd():getChildByName("enemy")
end

function BattleReady.getAbyssChallengeInfo(arg_55_0)
	if not arg_55_0.vars then
		return 
	end
	
	return arg_55_0.vars.form:getChildByName("n_abyss_challenge_info")
end

function BattleReady.getMissionList(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	return arg_56_0:getRightContentWnd():getChildByName("n_missions")
end

function BattleReady.updateEntrance(arg_57_0)
	local var_57_0 = arg_57_0.vars.enter_id
	local var_57_1 = arg_57_0.vars.dlg:getChildByName("mission")
	
	if_set_visible(arg_57_0.vars.dlg, "n_content", arg_57_0.vars.isAutomaton ~= true and arg_57_0.vars.isCrehunt ~= true)
	if_set_visible(arg_57_0.vars.dlg, "n_content_tower", arg_57_0.vars.isAutomaton == true)
	if_set_visible(arg_57_0.vars.dlg, "n_crevice", arg_57_0.vars.isCrehunt == true)
	
	local var_57_2 = arg_57_0:getRightContentWnd()
	local var_57_3 = arg_57_0.vars.dlg:getChildByName("mission")
	local var_57_4 = arg_57_0.vars.dlg:getChildByName("n_missions")
	local var_57_5 = 0
	
	for iter_57_0 = 1, 3 do
		local var_57_6 = var_57_4:getChildByName(string.format("%02d", iter_57_0))
		
		if var_57_6 and _updateMissionBanner(var_57_6, var_57_0, iter_57_0) then
			var_57_5 = var_57_5 + 1
		end
	end
	
	local var_57_7 = var_57_5 == 0
	local var_57_8 = arg_57_0.vars.dlg:getChildByName("n_nomission")
	
	if_set_visible(var_57_8, nil, var_57_7)
	
	if var_57_7 and get_cocos_refid(var_57_3) then
		local var_57_9 = DB("level_enter", var_57_0, "change_enter")
		local var_57_10 = var_57_3:getChildByName("n_text")
		
		if_set_visible(var_57_10, nil, var_57_9)
		
		if var_57_9 then
			local var_57_11 = totable(var_57_9)
			
			if_set(var_57_10, "t_mission_special", T(var_57_11.txt))
			if_set_visible(var_57_8, nil, false)
		end
	end
	
	local var_57_12 = arg_57_0.vars.dlg:getChildByName("check_repeat")
	local var_57_13 = arg_57_0.vars.dlg:getChildByName("text_repeat")
	
	if_set_visible(arg_57_0.vars.dlg, "check_repeat", false)
	if_set_visible(arg_57_0.vars.dlg, "text_repeat", false)
	
	local var_57_14, var_57_15, var_57_16 = arg_57_0:GetReqPointAndRewards(var_57_0)
	
	arg_57_0.vars.req_point = var_57_14
	
	if DungeonHell:isAbyssHardMap(arg_57_0.vars.enter_id) then
		var_57_16 = UIUtil:sortDisplayItems(DungeonHell:getChallengeRewards(var_57_0), var_57_0)
	elseif arg_57_0.vars.is_tree then
		for iter_57_1 = 1, 3 do
			local var_57_17 = _getMissionRewardItem(var_57_0, iter_57_1)
			
			if var_57_17 then
				table.insert(var_57_16, var_57_17)
			end
		end
	end
	
	local var_57_18 = DBT("level_enter", var_57_0, {
		"hide_battle_power",
		"cp_material",
		"cp_value"
	})
	local var_57_19 = UnlockSystem:isUnlockSystem(UNLOCK_ID.LOCAL_SHOP)
	local var_57_20 = var_57_18.cp_material and var_57_18.cp_value and var_57_19
	
	if_set_visible(arg_57_0.vars.dlg, "contr_point", var_57_20)
	
	if var_57_20 then
		if_set(arg_57_0.vars.dlg, "contr_point", T("mission_base_cpshop_cp_value", {
			value = var_57_18.cp_value
		}))
	end
	
	if var_57_18.hide_battle_power == "y" then
		arg_57_0.vars.req_point = 0
	end
	
	local var_57_21 = to_n(Account:getMapClearCount(var_57_0))
	
	if not PRODUCTION_MODE and ct and ct._enable_force_show_enemy_icon then
		var_57_21 = 1
	end
	
	local var_57_22 = {}
	
	for iter_57_2, iter_57_3 in pairs(var_57_15) do
		table.push(var_57_22, {
			iter_57_3.m,
			iter_57_3.lv,
			iter_57_3.tier
		})
	end
	
	table.sort(var_57_22, function(arg_58_0, arg_58_1)
		if arg_58_0[3] ~= arg_58_1[3] then
			if arg_58_0[3] == "boss" then
				return true
			end
			
			if arg_58_1[3] == "boss" then
				return false
			end
			
			if arg_58_0[3] == "subboss" then
				return true
			end
			
			if arg_58_1[3] == "subboss" then
				return false
			end
			
			if arg_58_0[3] == "elite" then
				return true
			end
			
			if arg_58_1[3] == "elite" then
				return false
			end
			
			return false
		end
		
		return arg_58_0[2] > arg_58_1[2]
	end)
	
	local var_57_23, var_57_24, var_57_25 = DB("level_enter", var_57_0, {
		"randomability",
		"type",
		"hide_boss"
	})
	
	if var_57_25 == "y" and (var_57_24 == "quest" or var_57_24 == "extra_quest" or var_57_24 == "dungeon_quest" or var_57_24 == "defense_quest" or var_57_24 == "descent" or var_57_24 == "burning") then
		for iter_57_4, iter_57_5 in pairs(var_57_22) do
			if var_57_21 == 0 and iter_57_5[3] == "boss" then
				iter_57_5[1] = "m0000"
			end
		end
	end
	
	arg_57_0.vars.ScrollEnemy = {}
	
	copy_functions(ScrollView, arg_57_0.vars.ScrollEnemy)
	
	function arg_57_0.vars.ScrollEnemy.getScrollViewItem(arg_59_0, arg_59_1)
		return UIUtil:getRewardIcon("c", arg_59_1[1], {
			no_db_grade = true,
			scale = 0.85,
			dlg_name = "battle_ready",
			hide_star = true,
			monster = true,
			lv = arg_59_1[2],
			tier = arg_59_1[3]
		})
	end
	
	function arg_57_0.vars.ScrollEnemy.onSelectScrollViewItem(arg_60_0, arg_60_1, arg_60_2)
	end
	
	local var_57_26 = var_57_2:getChildByName("scroll_enemy")
	local var_57_27 = {}
	local var_57_28 = {}
	local var_57_29 = var_57_2:getChildByName("n_elite_skill")
	
	if get_cocos_refid(var_57_26) and get_cocos_refid(var_57_29) then
		if var_57_24 ~= "quest" and var_57_24 ~= "extra_quest" and var_57_24 ~= "dungeon_quest" and var_57_24 ~= "urgent" then
			if var_57_23 then
				var_57_27 = string.split(var_57_23, ",")
			end
			
			for iter_57_6 = 1, 4 do
				if var_57_27[iter_57_6] then
					table.push(var_57_28, DB("character_randomability", tostring(var_57_27[iter_57_6]), "title_skill"))
				end
			end
		end
		
		var_57_29:setVisible(#var_57_28 > 0)
		
		if #var_57_28 > 0 then
			var_57_26:setDirection(2)
			var_57_26:setContentSize(var_57_26:getContentSize().width, 86)
			
			for iter_57_7, iter_57_8 in pairs(var_57_28) do
				if iter_57_8 then
					local var_57_30 = UIUtil:getSkillIcon(nil, iter_57_8, {
						skill_id = iter_57_8,
						tooltip_opts = {
							skill_id = iter_57_8
						}
					})
					
					var_57_29:getChildByName("n_skill" .. iter_57_7):addChild(var_57_30)
				end
			end
		end
		
		var_57_26:removeAllChildren()
		
		if #var_57_28 > 0 then
			arg_57_0.vars.ScrollEnemy:initScrollView(var_57_26, 75, 88)
		else
			arg_57_0.vars.ScrollEnemy:initScrollView(var_57_26, 75, 75)
		end
		
		arg_57_0.vars.ScrollEnemy:createScrollViewItems(var_57_22)
		var_57_26:jumpToPercentVertical(0)
		var_57_26:jumpToPercentHorizontal(0)
		
		arg_57_0.vars.ScrollItems = {}
		
		copy_functions(ScrollView, arg_57_0.vars.ScrollItems)
		
		function arg_57_0.vars.ScrollItems.getScrollViewItem(arg_61_0, arg_61_1)
			local var_61_0 = {
				dlg_name = "battle_ready",
				scale = 0.85,
				grade_max = true,
				set_drop = arg_61_1[3],
				grade_rate = arg_61_1[4]
			}
			
			if string.starts(arg_61_1[1], "e") and DB("equip_item", arg_61_1[1], "type") == "artifact" then
				var_61_0.scale = 0.66
			end
			
			local var_61_1 = arg_61_1.count or 0
			
			if var_61_1 == 0 and (tonumber(arg_61_1[2]) or 0) > 0 then
				var_61_1 = tonumber(arg_61_1[2])
			end
			
			if var_57_24 == "abyss" then
				var_61_1 = arg_61_1[2]
			end
			
			if arg_61_1.golden and (Account:isCurrencyType(arg_61_1[1]) or string.starts(arg_61_1[1], "ma_")) then
				var_61_1 = arg_61_1[2]
			else
				var_61_1 = nil
			end
			
			if BattleReady:isAbyssChallengeMode() or BattleReady.vars.is_tree then
				var_61_1 = arg_61_1[2]
			end
			
			if (tonumber(arg_61_1[4]) or 0) > 1 then
				var_61_0.grade_rate = "grade" .. arg_61_1[4]
			end
			
			var_61_0.reward_info = {}
			
			if arg_61_1.first_reward or arg_61_1.is_half then
				if arg_61_1.is_half then
					var_61_0.reward_info.first_reward_owned = true
				else
					var_61_0.reward_info.first_reward = true
				end
			end
			
			var_61_0.reward_info.stage_mission = arg_61_1.star_reward
			var_61_0.reward_info.stage_mission_owned = arg_61_1.mission_clear
			
			if arg_61_1.golden then
				if arg_61_1.already then
					var_61_0.reward_info.goldbox_reward_owned = true
				else
					var_61_0.reward_info.goldbox_reward = true
				end
			end
			
			local var_61_2 = UIUtil:getRewardIcon(var_61_1, arg_61_1[1], var_61_0)
			
			IconUtil.setIcon(var_61_2).addStar(arg_61_1.star_reward, arg_61_1.mission_clear and arg_61_1.mission_clear == true and tocolor("#888888")).addFirstReward(arg_61_1.first_reward or arg_61_1.is_half, arg_61_1.is_half and arg_61_1.is_half == true and tocolor("#888888"), arg_61_1.is_half).addCheckIcon(arg_61_1.is_half or arg_61_1.mission_clear).addGoldBox(arg_61_1.golden, arg_61_1.already ~= nil and tocolor("#888888") or tocolor("#ffffff"), arg_61_1.already).done()
			
			if arg_61_1.golden and tonumber(var_61_1) and tonumber(var_61_1) > 1 or BattleReady:isAbyssChallengeMode() then
				if_set(var_61_2, "txt_small_count", comma_value(var_61_1))
			end
			
			return var_61_2
		end
		
		function arg_57_0.vars.ScrollItems.onSelectScrollViewItem(arg_62_0, arg_62_1, arg_62_2)
		end
	end
	
	local var_57_31 = var_57_2:getChildByName("scroll_item")
	
	if get_cocos_refid(var_57_31) then
		var_57_31:removeAllChildren()
		arg_57_0.vars.ScrollItems:initScrollView(var_57_31, 85, 85, {
			skip_anchor = true
		})
		
		if not arg_57_0.vars.is_preview_quest and not arg_57_0.vars.opts.practice_mode and not arg_57_0.vars.opts.automaton_free_enter or DungeonHell:isAbyssHardMap(arg_57_0.vars.enter_id) then
			arg_57_0.vars.ScrollItems:createScrollViewItems(var_57_16)
		end
		
		local var_57_32 = var_57_2:findChildByName("n_noreward")
		
		if_set_visible(var_57_32, nil, not DungeonHell:isAbyssHardMap(arg_57_0.vars.enter_id) and arg_57_0.vars.opts.practice_mode == true or arg_57_0.vars.isCoop == true or arg_57_0.vars.isTrialhall == true or arg_57_0.vars.opts.automaton_free_enter == true or arg_57_0.vars.is_preview_quest)
		
		if arg_57_0.vars.isCoop then
			if_set(var_57_32, "txt_nomission", T("expedition_reward_no_preview"))
			
			if not var_57_32.origin_y then
				var_57_32.origin_y = var_57_32:getPositionY()
			end
			
			var_57_32:setPositionY(var_57_32.origin_y + 15)
		end
		
		if arg_57_0.vars.isTrialhall then
			if_set(var_57_32, "txt_nomission", T("trial_hall_reward_desc"))
		end
		
		if arg_57_0.vars.isAutomaton then
			if_set_visible(var_57_2, "n_item_none", arg_57_0.vars.opts.automaton_free_enter)
			
			local var_57_33 = var_57_2:getChildByName("n_item_none")
			
			if arg_57_0.vars.opts.automaton_free_enter and var_57_33 then
				if_set(var_57_33, "label", T("automtn_reset_reward_desc2"))
			end
		end
		
		if arg_57_0.vars.is_preview_quest then
			if_set(var_57_32, "txt_nomission", T("ui_substory_replay_reward_info"))
		end
	end
	
	arg_57_0:onUpdateWeekPoint()
end

function BattleReady.isAbyssChallengeMode(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	return DungeonHell:isAbyssHardMap(arg_63_0.vars.enter_id)
end

function BattleReady.setTouchEnabled(arg_64_0, arg_64_1)
	if arg_64_0.vars then
		if arg_64_0.vars.ScrollEnemy then
			arg_64_0.vars.ScrollEnemy:setTouchEnabled(arg_64_1)
		end
		
		if arg_64_0.vars.ScrollItems then
			arg_64_0.vars.ScrollItems:setTouchEnabled(arg_64_1)
		end
	end
end

function BattleReady.setNormalMode(arg_65_0)
end

function BattleReady.getBtnGo(arg_66_0)
	if arg_66_0.vars and get_cocos_refid(arg_66_0.vars.dlg) then
		local var_66_0 = arg_66_0:getRightContentWnd()
		
		if get_cocos_refid(var_66_0) then
			return var_66_0:getChildByName("btn_go")
		end
	end
end

function BattleReady.pushGoButton(arg_67_0)
	local var_67_0, var_67_1, var_67_2 = arg_67_0:checkWeekPoint()
	
	if not var_67_0 then
		return 
	end
	
	local var_67_3 = arg_67_0.vars and arg_67_0.vars.npcteam_id
	
	if var_67_0 > 0 then
		local var_67_4 = Dialog:msgBox(T("ui_msbbox_monster_weak_desc", {
			nuff_range = 10 * var_67_0
		}), {
			yesno = true,
			dlg = load_dlg("msgbox_monster_weak", true, "wnd"),
			title = T("ui_msbbox_monster_weak_title"),
			handler = function()
				arg_67_0:btnGo(var_67_3)
			end
		})
		
		UIUtil:getRewardIcon(nil, var_67_1, {
			show_name = true,
			parent = var_67_4.c.n_item
		})
		if_set(var_67_4, "txt_have", T("ui_msgbox_monster_weak_have", {
			have = Account:getPropertyCount(var_67_1)
		}))
		if_set(var_67_4, "t_token", var_67_2)
		UIUtil:getRewardIcon(nil, var_67_1, {
			no_count = true,
			no_frame = true,
			parent = var_67_4:getChildByName("n_token_icon")
		})
		
		return 
	end
	
	if arg_67_0.vars.opts.practice_mode and not DungeonHell:isAbyssHardMap(arg_67_0.vars.enter_id) then
		if DB("level_enter", arg_67_0.vars.enter_id, "type") == "abyss" then
			local var_67_5 = Dialog:msgBox(T("abyss_replay_desc"), {
				yesno = true,
				title = T("abyss_replay_title"),
				handler = function()
					arg_67_0:btnGo(var_67_3)
				end
			})
			
			return 
		end
	elseif DungeonHell:isAbyssHardMap(arg_67_0.vars.enter_id) and Account:getMapClearCount(arg_67_0.vars.enter_id) > 0 then
		local var_67_6 = Dialog:msgBox(T("abyss_hard_replay_desc"), {
			yesno = true,
			title = T("abyss_replay_title"),
			handler = function()
				arg_67_0:btnGo(var_67_3)
			end
		})
		
		return 
	end
	
	arg_67_0:btnGo(var_67_3)
end

function BattleReady.closeCoopWarningMsgBox(arg_71_0)
	if not arg_71_0.vars or not get_cocos_refid(arg_71_0.vars.coop_msgbox) then
		return 
	end
	
	arg_71_0:coopBackButton()
end

function BattleReady.coopBackButton(arg_72_0)
	if not arg_72_0.vars or not get_cocos_refid(arg_72_0.vars.coop_msgbox) then
		return 
	end
	
	BackButtonManager:pop()
	arg_72_0.vars.coop_msgbox:removeFromParent()
	
	arg_72_0.vars.coop_msgbox = nil
end

function BattleReady.updateStopWatching(arg_73_0)
	SAVE:set("coop.stop_watching", getCurrent3AMTime())
end

function BattleReady.isSkipCoopMsgBox(arg_74_0)
	return os.time() < (tonumber(SAVE:get("coop.stop_watching")) or 0)
end

function BattleReady.coopBattleStart(arg_75_0)
	local var_75_0 = CoopMission:getCurrentRoom()
	
	if not var_75_0 then
		Log.e("WRONG ATTEMP!")
		
		return 
	end
	
	local var_75_1 = var_75_0:getBossInfo()
	local var_75_2 = CoopUtil:getLevelData(var_75_1)
	
	if var_75_0:procCheckEnter(var_75_2) then
		arg_75_0:saveTeamInfo()
		CoopMission:onStartBattle({
			enter_id = var_75_2.level_enter,
			boss_id = var_75_1.boss_id
		})
	end
	
	arg_75_0:coopBackButton()
end

function BattleReady.btnGo(arg_76_0, arg_76_1)
	if arg_76_0.vars.isCoop then
		local var_76_0 = CoopMission:getCurrentRoom()
		
		if not var_76_0 then
			Log.e("WRONG ATTEMP!")
			
			return 
		end
		
		local var_76_1 = var_76_0:getBossInfo()
		local var_76_2 = CoopUtil:getLevelData(var_76_1)
		
		if var_76_0:procCheckEnter(var_76_2) then
			if arg_76_0:isSkipCoopMsgBox() then
				arg_76_0:coopBattleStart()
			else
				local var_76_3 = load_dlg("expedition_battle_popup", true, "wnd", function()
					arg_76_0:coopBackButton()
				end)
				
				arg_76_0.vars.coop_msgbox = var_76_3
				
				SceneManager:getRunningPopupScene():addChild(var_76_3)
			end
		end
		
		return 
	end
	
	local var_76_4, var_76_5, var_76_6 = Account:getEnterLimitInfo(arg_76_0.vars.enter_id)
	
	if var_76_4 and var_76_4 < 1 then
		if var_76_6 then
			balloon_message_with_sound("enter_limit_full_" .. var_76_6)
		else
			balloon_message_with_sound("battle_cant_getin")
		end
		
		return 
	end
	
	if arg_76_0.vars.opts.enter_error_text then
		balloon_message_with_sound_raw_text(arg_76_0.vars.opts.enter_error_text)
		
		return 
	end
	
	if arg_76_0.vars.sub_story then
		local var_76_7 = arg_76_0.vars.sub_story.id
		
		if not SubstoryManager:isOpenSubstoryDefaultSchedule(var_76_7) then
			balloon_message_with_sound("battle_cant_getin")
			
			return 
		end
	end
	
	if Account:hasTeamSameCodeUnit() then
		balloon_message_with_sound("already_in_team")
		
		return 
	end
	
	if DungeonHell:isAbyssHardMap(arg_76_0.vars.enter_id) and Account:isTeamSameClassUnit() then
		balloon_message_with_sound("abyss_hard_formation_no")
		
		return 
	end
	
	if arg_76_0.vars.isAutomaton then
		local var_76_8 = Account:getTeam(Account:getAutomatonTeamIndex())
		
		if table.empty(var_76_8) then
			balloon_message_with_sound("hero_cant_getin")
			
			return 
		end
		
		for iter_76_0, iter_76_1 in pairs(var_76_8) do
			if iter_76_1.inst and iter_76_1.inst.automaton_hp_r and iter_76_1.inst.automaton_hp_r <= 0 then
				balloon_message_with_sound("automtn_hero_death")
				
				return 
			end
		end
	end
	
	if arg_76_0.vars.isUnitOnceOnly then
		local var_76_9 = Account:getTeam(arg_76_0:getTeamIndex())
		
		for iter_76_2, iter_76_3 in pairs(var_76_9) do
			if iter_76_3 and Account:isMazeUsedUnit(arg_76_0.opts.map_id, iter_76_3:getUID()) then
				balloon_message_with_sound("msg_dungeon_challenge_claer_hero")
				
				return 
			end
		end
	end
	
	arg_76_0:onEnter(nil, nil, arg_76_1)
end

function BattleReady.getEnterID(arg_78_0)
	if not arg_78_0.vars or not arg_78_0.vars.enter_id then
		return 
	end
	
	return arg_78_0.vars.enter_id
end

function BattleReady.selectFriend(arg_79_0)
	arg_79_0.vars.opts.use_friend = BattleReadyFriends:useFriend(arg_79_0.vars.enter_id)
	
	arg_79_0:showTeamFormation()
	arg_79_0:playQuestEffect()
end

function BattleReady.update(arg_80_0)
	if arg_80_0.vars and get_cocos_refid(arg_80_0.vars.form) then
		BoosterUI:update(arg_80_0.vars.form)
	end
end

function BattleReady.friendSelectCategory(arg_81_0, arg_81_1)
	local var_81_0 = arg_81_0.vars.dlg:getChildByName("n_support"):getChildByName("category")
	
	for iter_81_0 = 1, 7 do
		local var_81_1 = var_81_0:getChildByName("btn_0" .. iter_81_0)
		local var_81_2 = var_81_1:getChildByName("btn_bg")
		
		if_set_visible(var_81_1, "sel", iter_81_0 == arg_81_1)
		
		if iter_81_0 == arg_81_1 then
			var_81_2:setColor(cc.c3b(255, 120, 0))
		else
			var_81_2:setColor(cc.c3b(0, 0, 0))
		end
	end
end

BattleReadyFriends = {}

function BattleReadyFriends.clear(arg_82_0)
	arg_82_0.vars = nil
end

function BattleReadyFriends.show(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	arg_83_0.vars = {}
	arg_83_0.vars.parent = arg_83_1
	arg_83_0.vars.category_idx = nil
	arg_83_0.vars.enter_id = arg_83_2
	
	if not arg_83_0.last_use_friend then
		arg_83_0.last_use_friend = {}
	elseif arg_83_2 and arg_83_0.last_use_friend[arg_83_2] then
		arg_83_0.last_use_friend[arg_83_2] = nil
	else
		arg_83_0.last_use_friend = {}
	end
	
	arg_83_0.vars.no_friend = nil
	arg_83_0.vars.listViewCtrl = arg_83_1:getChildByName("scrollview_support")
	arg_83_0.vars.listView = ItemListView_v2:bindControl(arg_83_0.vars.listViewCtrl)
	
	local var_83_0 = {
		onTouchUp = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
			if arg_84_4.cancelled then
				return 
			end
		end,
		onTouchDown = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
			if TutorialGuide:checkBlockBattleReadyScrollView() then
				return 
			end
			
			arg_83_0:selectItem(arg_85_2)
			
			return true
		end,
		onUpdate = function(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
			arg_83_0:updateListViewItem(arg_86_1, arg_86_3)
			
			return arg_86_3.id
		end
	}
	local var_83_1 = load_control("wnd/battle_ready_support_card.csb")
	
	var_83_1:setPositionY(var_83_1:getPositionY() - 8)
	
	if arg_83_0.vars.listViewCtrl.STRETCH_INFO then
		local var_83_2 = arg_83_0.vars.listViewCtrl:getContentSize()
		
		resetControlPosAndSize(var_83_1, var_83_2.width, arg_83_0.vars.listViewCtrl.STRETCH_INFO.width_prev)
	end
	
	arg_83_0.vars.listView:setRenderer(var_83_1, var_83_0)
	
	arg_83_0.vars.story_powerup_units = arg_83_3
	arg_83_0.vars.substory_power_up_units = arg_83_4
	
	local var_83_3 = false
	
	if Account:getSupportNpcs(arg_83_2) and not Account:canUseUserSupport(arg_83_2) then
		arg_83_0.vars.no_friend = true
		
		arg_83_0:updateCategory(1)
	else
		var_83_3 = arg_83_0:requestFriend()
	end
	
	if_set_visible(BattleReady.vars.dlg, "n_loading_support", var_83_3)
	if_set_visible(BattleReady.vars.dlg, "n_no_support", false)
	TutorialGuide:procGuide("ije001_continue")
end

function BattleReadyFriends.setTouchEnabled(arg_87_0, arg_87_1)
	if not arg_87_0.vars or not get_cocos_refid(arg_87_0.vars.listViewCtrl) then
		return 
	end
	
	arg_87_0.vars.listViewCtrl:setTouchEnabled(arg_87_1)
end

function BattleReadyFriends.getFirstFriendsControl(arg_88_0)
	if arg_88_0.ScrollViewItems[2] then
		return arg_88_0.ScrollViewItems[2].control
	end
	
	if arg_88_0.ScrollViewItems[1] then
		return arg_88_0.ScrollViewItems[1].control
	end
end

function BattleReadyFriends.requestFriend(arg_89_0, arg_89_1, arg_89_2, arg_89_3)
	if arg_89_0.friend_info_parsed then
		if not arg_89_0.friend_info_parsed.leader or table.count(arg_89_0.friend_info_parsed.leader) <= 5 then
			if arg_89_1 and arg_89_2 then
				if arg_89_0.friend_info_parsed.leader and table.count(arg_89_0.friend_info_parsed.leader) > 0 then
					return false
				else
					print("friend", "requestFriend SKIPPED. leader count <= 5")
					
					arg_89_0.friend_info_parsed = nil
				end
			else
				print("friend", "requestFriend SKIPPED. leader count <= 5")
				
				arg_89_0.friend_info_parsed = nil
			end
		end
		
		local var_89_0 = 1800
		
		if arg_89_0.friend_info_parsed and arg_89_0.friend_info_parsed_time + var_89_0 > os.time() then
			print("friend", "requestFriend SKIPPED. parsed timeout")
			
			if not arg_89_3 then
				arg_89_0:updateCategory(1)
			end
			
			arg_89_0.request_friend_callback = nil
			
			return false
		end
	end
	
	local var_89_1 = arg_89_2
	
	if arg_89_0.vars and arg_89_0.vars.enter_id then
		var_89_1 = arg_89_0.vars.enter_id
	end
	
	arg_89_0.friend_info_parsed = nil
	arg_89_0.request_friend_callback = arg_89_1
	
	print("req_supporter_list")
	query("friend_stage_recommend", {
		enter_id = var_89_1
	})
	
	return true
end

function BattleReadyFriends.removeFriend(arg_90_0, arg_90_1)
	if not arg_90_1 or not arg_90_0.friend_info_parsed then
		return 
	end
	
	for iter_90_0, iter_90_1 in pairs(arg_90_0.friend_info_parsed) do
		for iter_90_2, iter_90_3 in pairs(iter_90_1) do
			if iter_90_3.account_data and iter_90_3.account_data.id == arg_90_1 then
				iter_90_1[iter_90_2] = nil
				
				break
			end
		end
	end
end

function BattleReadyFriends._find_and_create_unit(arg_91_0, arg_91_1, arg_91_2, arg_91_3)
	for iter_91_0, iter_91_1 in pairs(arg_91_1) do
		if arg_91_2 == nil or iter_91_1.unit.id == arg_91_2 then
			local var_91_0 = UNIT:create(iter_91_1.unit)
			
			if var_91_0 then
				for iter_91_2, iter_91_3 in pairs(iter_91_1.equips) do
					if iter_91_3.p == iter_91_1.unit.id and iter_91_3 then
						local var_91_1 = EQUIP:createByInfo(iter_91_3)
						
						if var_91_1 then
							var_91_0:addEquip(var_91_1, true)
						end
					end
				end
				
				var_91_0:setSupporter(true)
				var_91_0:calc()
				var_91_0:setFriendNPC(arg_91_3)
				
				return var_91_0
			end
		end
	end
	
	return nil
end

function BattleReadyFriends._lv_to_exp(arg_92_0, arg_92_1, arg_92_2)
	return tonumber(DB("exp", tostring(math.max(arg_92_1 - 1, 0)), "tier" .. arg_92_2) or 0)
end

function BattleReadyFriends.updateData(arg_93_0, arg_93_1)
	if_set_visible(BattleReady.vars and BattleReady.vars.dlg, "n_loading_support", false)
	
	local var_93_0 = arg_93_1.stage_recommend or {}
	local var_93_1 = {
		"leader",
		"warrior",
		"knight",
		"assassin",
		"ranger",
		"mage",
		"manauser"
	}
	local var_93_2 = {
		leader = {},
		warrior = {},
		knight = {},
		assassin = {},
		ranger = {},
		mage = {},
		manauser = {}
	}
	local var_93_3 = 0
	
	for iter_93_0, iter_93_1 in pairs(var_93_0) do
		if iter_93_1.sd and iter_93_1.sd[1] then
			for iter_93_2, iter_93_3 in pairs(iter_93_1.sd) do
				if iter_93_2 == 1 then
					local var_93_4 = arg_93_0:_find_and_create_unit(iter_93_1.units, iter_93_3)
					
					if var_93_4 then
						table.push(var_93_2.leader, {
							account_data = iter_93_1.ad,
							friend_data = iter_93_1.fd,
							friend_point = iter_93_1.fp,
							unit = var_93_4
						})
						
						var_93_3 = var_93_3 + 1
					end
				else
					local var_93_5 = arg_93_0:_find_and_create_unit(iter_93_1.units, iter_93_3)
					
					if var_93_5 and var_93_5.db.role ~= "material" then
						table.push(var_93_2[var_93_5.db.role], {
							account_data = iter_93_1.ad,
							friend_data = iter_93_1.fd,
							friend_point = iter_93_1.fp,
							unit = var_93_5
						})
						
						var_93_3 = var_93_3 + 1
					end
				end
			end
		end
	end
	
	arg_93_0.friend_info_parsed = var_93_2
	arg_93_0.friend_info_parsed_time = os.time()
	
	print("friend", string.format("BattleReadyFriends %d parsed", var_93_3), arg_93_0.friend_info_parsed_time)
	arg_93_0:updateCategory(1)
	
	if arg_93_0.request_friend_callback then
		arg_93_0.request_friend_callback()
		
		arg_93_0.request_friend_callback = nil
	end
end

function BattleReadyFriends.updateCategory(arg_94_0, arg_94_1)
	if not arg_94_0.vars or not BattleReady.vars or not get_cocos_refid(BattleReady.vars.dlg) then
		return 
	end
	
	if_set_visible(BattleReady.vars.dlg, "n_loading_support", false)
	
	if arg_94_0.vars.category_idx == arg_94_1 then
		return 
	end
	
	if arg_94_1 then
		arg_94_0.vars.category_idx = arg_94_1
	end
	
	BattleReady:friendSelectCategory(arg_94_1)
	
	local var_94_0 = {
		"leader",
		"warrior",
		"knight",
		"assassin",
		"ranger",
		"mage",
		"manauser"
	}
	local var_94_1 = {}
	
	if arg_94_1 == 1 then
		local var_94_2 = Account:getSupportNpcs(arg_94_0.vars.enter_id) or {}
		
		for iter_94_0, iter_94_1 in pairs(var_94_2) do
			if iter_94_1.code and iter_94_1.lv and iter_94_1.g then
				local var_94_3 = DB("character", iter_94_1.code, "grade") or 1
				local var_94_4 = arg_94_0:_find_and_create_unit({
					{
						unit = {
							code = iter_94_1.code,
							exp = arg_94_0:_lv_to_exp(iter_94_1.lv, var_94_3),
							g = iter_94_1.g
						},
						equips = {}
					}
				}, nil, true)
				
				if var_94_4 then
					table.push(var_94_1, {
						friend_point = Account:getFriendPointData("npc"),
						unit = var_94_4
					})
				end
			end
		end
	end
	
	local var_94_5 = {}
	
	if not arg_94_0.vars.no_friend and arg_94_0.friend_info_parsed then
		local var_94_6 = 0
		local var_94_7 = 10
		local var_94_8 = 0
		local var_94_9 = 7
		
		for iter_94_2, iter_94_3 in pairs(arg_94_0.friend_info_parsed[var_94_0[arg_94_1]]) do
			if var_94_9 <= var_94_8 then
				break
			end
			
			if iter_94_3.friend_data then
				table.push(var_94_5, iter_94_3)
				
				var_94_8 = var_94_8 + 1
			end
		end
		
		local var_94_10 = var_94_6 + var_94_8
		
		for iter_94_4, iter_94_5 in pairs(arg_94_0.friend_info_parsed[var_94_0[arg_94_1]]) do
			if var_94_7 <= var_94_10 then
				break
			end
			
			if not iter_94_5.friend_data then
				table.push(var_94_5, iter_94_5)
				
				var_94_10 = var_94_10 + 1
			end
		end
		
		table.sort(var_94_5, function(arg_95_0, arg_95_1)
			local var_95_0 = to_n(arg_95_0.friend_point)
			local var_95_1 = to_n(arg_95_1.friend_point)
			
			if var_95_0 ~= var_95_1 then
				return var_95_1 < var_95_0
			end
			
			return arg_95_0.account_data.login_tm > arg_95_1.account_data.login_tm
		end)
	end
	
	table.join(var_94_1, var_94_5)
	if_set_visible(BattleReady.vars.dlg, "n_no_support", #var_94_1 == 0)
	
	arg_94_0.vars.category_list = var_94_1
	
	arg_94_0.vars.listView:removeAllChildren()
	arg_94_0.vars.listView:setDataSource(var_94_1)
	arg_94_0.vars.listView:jumpToPercentVertical(0)
	arg_94_0:selectItem(1, true)
end

function BattleReadyFriends.updateListViewItem(arg_96_0, arg_96_1, arg_96_2)
	local var_96_0
	
	if arg_96_2.account_data then
		if arg_96_2.friend_data == nil then
			if_set(arg_96_1, "recmm_text", T("recommend_friend", {
				name = arg_96_2.account_data.name
			}))
			if_set_visible(arg_96_1, "recmm_text", true)
			if_set_visible(arg_96_1, "name", false)
			
			var_96_0 = arg_96_1:getChildByName("recmm_text")
		else
			if_set(arg_96_1, "name", arg_96_2.account_data.name)
			if_set_visible(arg_96_1, "recmm_text", false)
			if_set_visible(arg_96_1, "name", true)
			
			var_96_0 = arg_96_1:getChildByName("name")
		end
		
		if_set_visible(arg_96_1, "npc_text", false)
		
		local var_96_1 = var_96_0:getContentSize()
		local var_96_2 = arg_96_1:getChildByName("n_lv")
		
		UIUtil:setLevel(arg_96_1:getChildByName("n_lv"), arg_96_2.account_data.level, MAX_ACCOUNT_LEVEL, 2)
		if_set_visible(arg_96_1, "n_last", true)
		if_set_visible(arg_96_1, "n_dedi", true)
		if_set(arg_96_1, "last_time", T("time_before", {
			time = sec_to_string(os.time() - arg_96_2.account_data.login_tm, nil, {
				login_tm = true
			})
		}))
	else
		if_set(arg_96_1, "npc_text", T("npc_friend", {
			name = T(arg_96_2.unit.db.name)
		}))
		if_set_scale_fit_width(arg_96_1, "npc_text", 390)
		if_set_visible(arg_96_1, "n_lv", false)
		if_set_visible(arg_96_1, "npc_text", true)
		if_set_visible(arg_96_1, "name", false)
		if_set_visible(arg_96_1, "recmm_text", false)
		if_set_visible(arg_96_1, "n_last", false)
		if_set_visible(arg_96_1, "n_dedi", false)
	end
	
	if arg_96_0.vars and arg_96_0.vars.story_powerup_units then
		if_set_visible(arg_96_1, "n_buff_story", arg_96_0.vars.story_powerup_units[arg_96_2.unit.db.code])
		
		if arg_96_0.vars.substory_power_up_units and not table.empty(arg_96_0.vars.substory_power_up_units) then
			if_set_visible(arg_96_1, "icon_allbuff_aura", arg_96_0.vars.substory_power_up_units[arg_96_2.unit.db.code])
		end
	end
	
	if arg_96_2.unit:isFriendSelected() then
		if_set_visible(arg_96_1, "selected", true)
	else
		if_set_visible(arg_96_1, "selected", false)
	end
	
	local var_96_3 = arg_96_2.unit:getTotalSkillLevel()
	
	if var_96_0 and var_96_3 and var_96_3 > 0 then
		arg_96_1:getChildByName("up"):setPositionX(var_96_0:getContentSize().width * var_96_0:getScaleX() + var_96_0:getPositionX() + 5)
		if_set_visible(arg_96_1, "up", true)
		if_set(arg_96_1, "txt_up", "+" .. var_96_3)
	else
		if_set_visible(arg_96_1, "up", false)
	end
	
	UIUtil:setDevoteDetail_new(arg_96_1, arg_96_2.unit, {
		target = "n_dedi",
		fit_string = true
	})
	UIUtil:getUserIcon(arg_96_2.unit, {
		parent = arg_96_1:getChildByName("n_face"),
		border_code = (arg_96_2.account_data or {}).border_code
	})
	UIUtil:getRewardIcon(arg_96_2.friend_point, "to_friendpoint", {
		no_popup = true,
		scale = 0.7,
		name = false,
		parent = arg_96_1:getChildByName("n_reward")
	})
end

function BattleReadyFriends.selectItem(arg_97_0, arg_97_1, arg_97_2)
	if not arg_97_0.vars or not arg_97_0.vars.category_list then
		return 
	end
	
	local var_97_0 = {}
	
	for iter_97_0, iter_97_1 in pairs(arg_97_0.vars.category_list) do
		if iter_97_0 == arg_97_1 then
			if arg_97_0.vars.no_friend then
				if not iter_97_1.unit:isFriendSelected() then
					iter_97_1.unit:setFriendSelect(true)
				end
			else
				iter_97_1.unit:setFriendSelect(not iter_97_1.unit:isFriendSelected())
			end
			
			table.insert(var_97_0, iter_97_1)
		elseif iter_97_1.unit:isFriendSelected() then
			iter_97_1.unit:setFriendSelect(false)
			table.insert(var_97_0, iter_97_1)
		end
	end
	
	if not arg_97_2 then
		TutorialGuide:procGuide()
	end
	
	for iter_97_2, iter_97_3 in pairs(var_97_0) do
		local var_97_1 = arg_97_0.vars.listView:getControl(iter_97_3)
		
		if get_cocos_refid(var_97_1) then
			if iter_97_3.unit:isFriendSelected() then
				if_set_visible(var_97_1, "selected", true)
			else
				if_set_visible(var_97_1, "selected", false)
			end
		end
	end
	
	SoundEngine:play("event:/ui/btn_small")
end

function BattleReadyFriends.useFriend(arg_98_0, arg_98_1)
	if not arg_98_0.vars or not arg_98_0.vars.enter_id or not arg_98_1 then
		return {}
	end
	
	if not arg_98_0.last_use_friend then
		arg_98_0.last_use_friend = {}
	end
	
	arg_98_0.vars.last_selected_unit = nil
	
	for iter_98_0, iter_98_1 in pairs(arg_98_0.vars.category_list) do
		if iter_98_1.unit:isFriendSelected() == true then
			local var_98_0
			
			if iter_98_1.unit:isFriendNPC() then
				var_98_0 = iter_98_1.unit.db.code
			end
			
			local var_98_1
			
			if iter_98_1.account_data then
				var_98_1 = iter_98_1.account_data.id
			end
			
			if not var_98_0 then
				arg_98_0.last_use_friend[arg_98_1] = iter_98_1
			else
				arg_98_0.last_use_friend[arg_98_1] = nil
			end
			
			arg_98_0.vars.last_selected_unit = iter_98_1.unit
			
			return {
				account_id = var_98_1,
				unit_uid = iter_98_1.unit.inst.uid,
				npc = var_98_0
			}
		end
	end
	
	arg_98_0:clearLastUseFriend(arg_98_1)
	
	return {}
end

function BattleReadyFriends.getLastSelectedUnit(arg_99_0)
	if not arg_99_0.vars then
		return nil
	end
	
	return arg_99_0.vars.last_selected_unit
end

function BattleReadyFriends.clearLastUseFriend(arg_100_0, arg_100_1)
	if not arg_100_1 then
		return 
	end
	
	if not arg_100_0.last_use_friend then
		arg_100_0.last_use_friend = {}
	end
	
	arg_100_0.last_use_friend[arg_100_1] = nil
end

function BattleReadyFriends.getLastUseFriend(arg_101_0, arg_101_1)
	if not arg_101_1 then
		return 
	end
	
	if not arg_101_0.last_use_friend then
		arg_101_0.last_use_friend = {}
	end
	
	return arg_101_0.last_use_friend[arg_101_1]
end

function BattleReadyFriends.setAutoFriend(arg_102_0, arg_102_1)
	if not arg_102_1 or not BattleRepeat.map_id then
		return 
	end
	
	if not arg_102_0.last_use_friend then
		arg_102_0.last_use_friend = {}
	end
	
	local var_102_0 = {}
	local var_102_1 = 10
	local var_102_2 = 0
	local var_102_3 = {
		"leader",
		"warrior",
		"knight",
		"assassin",
		"ranger",
		"mage",
		"manauser"
	}
	local var_102_4 = Account:getSupportNpcs(arg_102_1) or {}
	
	for iter_102_0, iter_102_1 in pairs(var_102_4) do
		if iter_102_1.code and iter_102_1.lv and iter_102_1.g then
			local var_102_5 = DB("character", iter_102_1.code, "grade") or 1
			local var_102_6 = arg_102_0:_find_and_create_unit({
				{
					unit = {
						code = iter_102_1.code,
						exp = arg_102_0:_lv_to_exp(iter_102_1.lv, var_102_5),
						g = iter_102_1.g
					},
					equips = {}
				}
			}, nil, true)
			
			if var_102_6 then
				table.push(var_102_0, {
					friend_point = Account:getFriendPointData("npc"),
					unit = var_102_6
				})
			end
		end
	end
	
	if not arg_102_0.friend_info_parsed or not arg_102_0.friend_info_parsed[var_102_3[1]] then
		return 
	end
	
	for iter_102_2, iter_102_3 in pairs(arg_102_0.friend_info_parsed[var_102_3[1]]) do
		if var_102_1 <= var_102_2 then
			break
		end
		
		if iter_102_3.friend_data then
			table.push(var_102_0, iter_102_3)
			
			var_102_2 = var_102_2 + 1
		end
	end
	
	for iter_102_4, iter_102_5 in pairs(arg_102_0.friend_info_parsed[var_102_3[1]]) do
		if var_102_1 <= var_102_2 then
			break
		end
		
		if not iter_102_5.friend_data then
			table.push(var_102_0, iter_102_5)
			
			var_102_2 = var_102_2 + 1
		end
	end
	
	if var_102_2 == 0 or not var_102_0[1] then
		return 
	end
	
	local var_102_7 = var_102_0[1]
	local var_102_8
	
	if var_102_7.unit:isFriendNPC() then
		var_102_8 = var_102_7.unit.db.code
	end
	
	local var_102_9
	
	if var_102_7.account_data then
		var_102_9 = var_102_7.account_data.id
	end
	
	if not var_102_8 then
		arg_102_0.last_use_friend[arg_102_1] = var_102_7
	end
	
	print("add auto supporter")
	
	return {
		account_id = var_102_9,
		unit_uid = var_102_7.unit.inst.uid,
		npc = var_102_8
	}
end

function BattleReady.ShowLowerPointWarningPopup(arg_103_0, arg_103_1, arg_103_2)
	if not arg_103_0.vars then
		return 
	end
	
	arg_103_1 = arg_103_1 or function()
		arg_103_0:btnGo(true)
		
		if arg_103_2 then
			local var_104_0 = Account:get_automaton_week_id()
			
			if SAVE:get("atmt_week_popup", 1) ~= var_104_0 then
				SAVE:set("atmt_week_popup", var_104_0)
			end
		end
	end
	
	local var_103_0 = "caution_battlepower_desc"
	
	if arg_103_2 then
		var_103_0 = "caution_battlepower_desc_automaton"
		
		Dialog:msgBox(T("caution_battlepower_desc_automaton"), {
			yesno = true,
			title = T("caution_battlepower_title"),
			handler = arg_103_1
		})
	else
		local var_103_1 = arg_103_0.vars.level_type
		
		Dialog:openDailySkipPopup(var_103_1 .. ".stop_watching", {
			info = "expedition_daily_stop_desc",
			title = "caution_battlepower_title",
			desc = var_103_0 or "caution_battlepower_desc",
			func = arg_103_1
		})
	end
end

function BattleReady.checkPointLowerThenRequire(arg_105_0)
	if arg_105_0.vars.point <= arg_105_0.vars.req_point * 0.75 then
		return true
	end
end

function BattleReady.setVisibleQuestEffectNode(arg_106_0, arg_106_1)
	if arg_106_0.vars.is_guide_position then
		return 
	end
	
	if arg_106_0.vars.dlg and get_cocos_refid(arg_106_0.vars.dlg) then
		local var_106_0 = arg_106_0.vars.dlg:getChildByName("n_quest_eff")
		
		if var_106_0 and get_cocos_refid(var_106_0) then
			var_106_0:setVisible(arg_106_1)
		end
	end
end

function BattleReady.toggleEditMode(arg_107_0, arg_107_1)
	local var_107_0 = arg_107_0.vars.edit_mode
	
	if arg_107_0.vars.edit_mode == arg_107_1 then
		return 
	end
	
	if arg_107_1 ~= nil then
		arg_107_0.vars.edit_mode = arg_107_1
	else
		arg_107_0.vars.edit_mode = not arg_107_0.vars.edit_mode
	end
	
	arg_107_0:enableFormationEditMode(arg_107_0.vars.edit_mode)
	
	local var_107_1 = arg_107_0.vars.dlg:findChildByName("n_sorting_f")
	
	if arg_107_0.vars.edit_mode then
		if not arg_107_0.vars.unitdock then
			local var_107_2 = arg_107_0.vars.sub_story and "Substory" or nil
			local var_107_3 = "Ready"
			
			if arg_107_0.vars.isAutomaton then
				var_107_3 = "Automaton"
			end
			
			if arg_107_0.vars.isUnitOnceOnly and var_107_3 == "Ready" then
				var_107_3 = string.format("%s:%s", var_107_3, arg_107_0.vars.enter_id)
			end
			
			arg_107_0.vars.unitdock = HeroBelt:create(var_107_2, {
				bottom = 150
			})
			
			arg_107_0.vars.dlg:getChildByName("n_herolist"):addChild(arg_107_0.vars.unitdock.vars.wnd)
			HeroBelt:changeSorterParent(var_107_1, true)
			arg_107_0.vars.unitdock:setEventHandler(arg_107_0.onHeroListEventForFormationEditor, arg_107_0)
			HeroBelt:resetData(Account.units, var_107_3, nil, true)
			
			local var_107_4 = Account:getCrehuntSeasonAttribute()
			
			if arg_107_0.vars.isCrehunt and var_107_4 then
				HeroBelt:setFixFilter("element", var_107_4)
			end
			
			local var_107_5 = HeroBelt:getItems()
			
			if #var_107_5 > 5 then
				HeroBelt:scrollToUnit(var_107_5[2])
			end
			
			arg_107_0.vars.unitdock.vars.wnd:setPosition(0, 0)
		end
	else
		arg_107_0:setNormalMode()
	end
	
	arg_107_0:setVisibleQuestEffectNode(not arg_107_0.vars.edit_mode)
	
	if arg_107_0.vars.is_guide_position then
		arg_107_0:showChangeButtonWithEffect()
	end
	
	if_set_visible(arg_107_0.vars.dlg, "n_touch_block_formation", not arg_107_0.vars.edit_mode)
	
	local var_107_6 = arg_107_0:getRightContentWnd()
	local var_107_7 = arg_107_0.vars.dlg:getChildByName("n_herolist")
	
	if var_107_1 and not var_107_1.origin_x then
		var_107_1.origin_x = var_107_1:getPositionX()
	end
	
	if arg_107_0.vars.edit_mode then
		var_107_7:setPositionX(400)
		var_107_1:setPositionX(var_107_1.origin_x + 400)
		
		local var_107_8 = var_107_6:getChildByName("slide_out")
		
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, 0 + VIEW_BASE_LEFT), 100)), var_107_7, "block")
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_BY(200, -400), 100)), var_107_1, "block")
		UIAction:Add(SEQ(RLOG(MOVE_TO(200, 400), 100), SHOW(false)), var_107_8, "block")
		SoundEngine:play("event:/ui/whoosh_a")
	else
		if var_107_0 then
			arg_107_0:saveTeamInfo()
		end
		
		if arg_107_0.vars.unitdock and arg_107_0.vars.unitdock.vars.wnd then
			local var_107_9 = var_107_6:getChildByName("slide_out")
			
			UIAction:Add(SEQ(RLOG(MOVE_TO(200, 400 + VIEW_BASE_LEFT), 100), SHOW(false)), var_107_7, "block")
			UIAction:Add(SEQ(RLOG(MOVE_BY(200, 400), 100), SHOW(false)), var_107_1, "block")
			UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, 0), 100)), var_107_9, "block")
			SoundEngine:play("event:/ui/whoosh_a")
		end
	end
	
	arg_107_0:showLimitInfo(var_107_0 and not arg_107_0.vars.edit_mode)
	
	local var_107_10 = "battle_ready"
	
	if arg_107_0.vars.edit_mode then
		var_107_10 = "edit_mode"
	end
	
	local var_107_11 = Analytics:getMapKey(arg_107_0.vars.enter_id) .. "/" .. var_107_10
	
	Analytics:toggleTab(var_107_11)
end

function BattleReady.updateButtons(arg_108_0)
	arg_108_0:updateEnterButton()
	arg_108_0:updateBossGuideButton()
end

function BattleReady.updateEnterButton(arg_109_0)
	if not arg_109_0.vars or not get_cocos_refid(arg_109_0.vars.dlg) then
		return 
	end
	
	local var_109_0 = arg_109_0:getBtnGo()
	
	if get_cocos_refid(var_109_0) then
		arg_109_0.vars.enterable, arg_109_0.vars.lack_enter_item = UIUtil:setButtonEnterInfo(var_109_0, arg_109_0.vars.enter_id, arg_109_0.vars.opts)
		
		local var_109_1 = true
		local var_109_2, var_109_3, var_109_4 = Account:getEnterLimitInfo(arg_109_0.vars.enter_id)
		
		if var_109_2 and var_109_2 < 1 then
			var_109_1 = false
		end
		
		UIUtil:changeButtonState(var_109_0, Account:checkEnterMap(arg_109_0.vars.enter_id) and var_109_1)
	end
end

function BattleReady.updateBossGuideButton(arg_110_0)
	if not arg_110_0.vars or not get_cocos_refid(arg_110_0.vars.dlg) or not arg_110_0.vars.enter_id then
		return 
	end
	
	if BossGuide:hasGuide(arg_110_0.vars.enter_id) then
		if arg_110_0.vars.opts.enter_error_text == nil then
			if_set_opacity(arg_110_0.vars.dlg, "btn_boss_guide", 255)
		else
			if_set_opacity(arg_110_0.vars.dlg, "btn_boss_guide", 76.5)
		end
	end
	
	if arg_110_0.vars.opts and arg_110_0.vars.opts.trial_id then
		if_set_visible(arg_110_0.vars.dlg, "btn_boss_feature", arg_110_0.vars.opts.trial_id)
	end
end

function BattleReady.updateOnLeaveUnitPopupMode(arg_111_0)
	if arg_111_0:isValid() then
		if arg_111_0.vars.edit_mode then
			HeroBelt:resetDataUseFilter(Account.units, "Ready", nil, true)
		end
		
		local var_111_0, var_111_1 = BackPlayUtil:checkEnterableMapOnBackPlaying(arg_111_0.vars.opts.enter_id)
		
		if arg_111_0.vars.opts.enter_id and not var_111_0 then
			local var_111_2 = var_111_1 or "msg_bgbattle_samebattle_error"
			
			arg_111_0.vars.opts.enter_error_text = T(var_111_2)
		else
			arg_111_0.vars.opts.enter_error_text = arg_111_0.vars.opts.enter_error_text or nil
		end
		
		arg_111_0:updateButtons()
		BattleRepeat:update_repeatCheckbox()
	end
end

function HANDLER.trial_hall_boss_feature(arg_112_0, arg_112_1)
	if arg_112_1 == "btn_close" then
		BattleReady:closeBossFeature()
	end
end

function BattleReady.closeBossFeature(arg_113_0)
	if not arg_113_0.vars or not get_cocos_refid(arg_113_0.vars.dlg) or not arg_113_0.vars.opts or not arg_113_0.vars.opts.trial_id then
		return 
	end
	
	if not get_cocos_refid(arg_113_0.vars.dlg.boss_feature) then
		return 
	end
	
	BackButtonManager:pop("trial_hall_boss_feature")
	UIAction:Add(SEQ(SPAWN(FADE_OUT(300), LOG(MOVE_BY(150, 0, -600))), REMOVE()), arg_113_0.vars.dlg.boss_feature, "block")
end

function BattleReady.showBossFeature(arg_114_0)
	if not arg_114_0.vars or not get_cocos_refid(arg_114_0.vars.dlg) or not arg_114_0.vars.opts or not arg_114_0.vars.opts.trial_id then
		return 
	end
	
	if get_cocos_refid(arg_114_0.vars.dlg.boss_feature) then
		return 
	end
	
	arg_114_0.vars.dlg.boss_feature = load_dlg("trial_hall_boss_feature", true, "wnd")
	
	arg_114_0.vars.dlg.boss_feature:setPositionY(-360)
	DungeonTrialHall:makeEffectList({
		scroll = "penalty_scrollview",
		db = "boss_penalty_skills",
		target_node = arg_114_0.vars.dlg.boss_feature,
		txt_color = cc.c3b(255, 129, 119)
	})
	DungeonTrialHall:makeEffectList({
		scroll = "benefit_scrollview",
		db = "boss_benefit_skills",
		target_node = arg_114_0.vars.dlg.boss_feature,
		txt_color = cc.c3b(101, 190, 255)
	})
	arg_114_0.vars.dlg:addChild(arg_114_0.vars.dlg.boss_feature)
	arg_114_0.vars.dlg.boss_feature:bringToFront()
	BackButtonManager:push({
		check_id = "trial_hall_boss_feature",
		back_func = function()
			BattleReady:closeBossFeature()
		end
	})
	UIAction:Add(SPAWN(LOG(MOVE_BY(150, 0, 720)), FADE_IN(300)), arg_114_0.vars.dlg.boss_feature, "block")
end

function BattleReady.showBossGuide(arg_116_0)
	if not arg_116_0.vars or not get_cocos_refid(arg_116_0.vars.dlg) or not arg_116_0.vars.enter_id then
		return 
	end
	
	if not BossGuide:hasGuide(arg_116_0.vars.enter_id) then
		return 
	end
	
	if arg_116_0.vars.opts.enter_error_text ~= nil then
		balloon_message_with_sound("cant_connect_bosspage")
	else
		BossGuide:show({
			parent = SceneManager:getRunningNativeScene(),
			enter_id = arg_116_0.vars.enter_id
		})
	end
end

function BattleReady.showSimpleInfo(arg_117_0, arg_117_1, arg_117_2, arg_117_3)
	if not arg_117_0.vars or not arg_117_0.vars.tag_icon_name or not get_cocos_refid(arg_117_0.vars.dlg) then
		return 
	end
	
	local var_117_0 = arg_117_0.vars.dlg:getChildByName("n_simple_info")
	
	if not get_cocos_refid(var_117_0) then
		return 
	end
	
	UIAction:Remove(var_117_0)
	
	if arg_117_0.vars.hide_tag_icon_text then
		return 
	elseif not DB("text", arg_117_0.vars.tag_icon_name, {
		"id"
	}) then
		arg_117_0.vars.hide_tag_icon_text = true
		
		return 
	end
	
	if arg_117_1 then
		var_117_0:setVisible(true)
		var_117_0:setScale(0)
		
		local var_117_1 = 1
		local var_117_2 = NONE()
		
		if arg_117_3 then
			var_117_2 = SEQ(DELAY(3000), RLOG(SCALE(80, 1, 0)), SHOW(false))
		end
		
		UIAction:Add(SEQ(DELAY(to_n(arg_117_2)), LOG(SCALE(150, 0, var_117_1 * 1.1)), DELAY(50), RLOG(SCALE(80, var_117_1 * 1.1, var_117_1)), var_117_2), var_117_0)
		
		local var_117_3 = T(arg_117_0.vars.tag_icon_name)
		local var_117_4 = string.replace(var_117_3, "\n", " ")
		
		if_set(var_117_0, "txt_simple_info", var_117_4)
		if_set(var_117_0, "txt_simple_info", var_117_4)
	else
		UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false)), var_117_0)
	end
end

function BattleReady.coop_showLimitInfo(arg_118_0, arg_118_1, arg_118_2)
	if not get_cocos_refid(arg_118_0.vars.dlg) then
		return 
	end
	
	local var_118_0 = CoopMission:getCurrentRoom()
	
	if not var_118_0 then
		return 
	end
	
	local var_118_1 = arg_118_0.vars.dlg:getChildByName("n_count_info")
	
	if not get_cocos_refid(var_118_1) then
		return 
	end
	
	local var_118_2 = var_118_1:getChildByName("talk_bg")
	local var_118_3 = var_118_1:getChildByName("talk_bg_quest")
	
	if not var_118_2 then
		return 
	end
	
	var_118_2:setVisible(true)
	var_118_3:setVisible(false)
	
	if arg_118_1 then
		local var_118_4 = var_118_0:getPlayCount()
		local var_118_5 = CoopUtil:getConfigDBValue("expedition_enter_limit")
		local var_118_6 = var_118_4 == var_118_5 and "expedition_limit_pop_cant" or "expedition_limit_pop"
		
		if_set(var_118_2, "txt_simple_info", T(var_118_6, {
			count = var_118_5 - var_118_4
		}))
		
		local var_118_7 = var_118_5 - var_118_4
		
		if_set(var_118_2, "txt_count", string.format("%d/%d", math.min(var_118_5, math.max(var_118_7, 0)), var_118_5))
		if_set_visible(var_118_1, "talk_bg_count", false)
		
		if arg_118_2 then
			var_118_1:setScale(1)
			if_set_visible(arg_118_0.vars.dlg, "n_count_info", true)
		else
			var_118_1:setVisible(true)
			var_118_1:setScale(0)
			UIAction:Add(SEQ(LOG(SCALE(80, 0, 1))), var_118_1)
		end
	else
		var_118_1:setScale(1)
		
		if arg_118_2 then
			if_set_visible(arg_118_0.vars.dlg, "n_count_info", false)
		else
			local function var_118_8(arg_119_0)
				arg_119_0:setScale(1)
			end
			
			if var_118_1:isVisible() then
				UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false), CALL(var_118_8, var_118_1)), var_118_1)
			end
		end
	end
end

function BattleReady.showLimitInfo(arg_120_0, arg_120_1, arg_120_2)
	if not get_cocos_refid(arg_120_0.vars.dlg) then
		return 
	end
	
	if arg_120_0.vars.isCoop then
		arg_120_0:coop_showLimitInfo(arg_120_1, arg_120_2)
		
		return 
	end
	
	local function var_120_0(arg_121_0)
		arg_121_0:setScale(1)
	end
	
	local var_120_1 = arg_120_0.vars.dlg:getChildByName("n_count_info")
	
	if not get_cocos_refid(var_120_1) then
		return 
	end
	
	local var_120_2 = false
	
	if arg_120_1 then
		local var_120_3, var_120_4, var_120_5, var_120_6 = Account:getEnterLimitInfo(arg_120_0.vars.enter_id)
		local var_120_7 = DB("level_enter", arg_120_0.vars.enter_id, {
			"achievement_link"
		})
		local var_120_8 = var_120_1:getChildByName("talk_bg")
		local var_120_9 = var_120_1:getChildByName("talk_bg_quest")
		
		if var_120_3 and var_120_4 then
			var_120_8:setVisible(true)
			var_120_9:setVisible(false)
			
			if var_120_5 then
				if var_120_5 == "only_once" then
					if var_120_3 > 0 then
						if_set(var_120_8, "txt_simple_info", T("enter_limit_pop_only_once", {
							count = var_120_4
						}))
					else
						if_set(var_120_8, "txt_simple_info", T("enter_limit_pop_used_only_once"))
					end
				elseif var_120_6 and var_120_6 > os.time() then
					if var_120_5 == "48days" and var_120_3 > 0 then
						if_set(var_120_8, "txt_simple_info", T("enter_limit_pop_new_" .. var_120_5, {
							count = var_120_4
						}))
					else
						if_set(var_120_8, "txt_simple_info", T("enter_limit_pop_used_" .. var_120_5, {
							count = var_120_4,
							reset_time = sec_to_string(var_120_6 - os.time())
						}))
					end
				else
					if_set(var_120_8, "txt_simple_info", T("enter_limit_pop_new_" .. var_120_5, {
						count = var_120_4
					}))
				end
				
				var_120_2 = true
			end
			
			if_set(var_120_8, "txt_count", string.format("%d/%d", math.min(var_120_4, math.max(var_120_3, 0)), var_120_4))
			if_set_visible(var_120_1, "talk_bg_count", false)
		elseif var_120_7 then
			var_120_2 = UIUtil:showSubstoryAchievementBalloon(var_120_1, var_120_7)
		else
			return 
		end
		
		if var_120_2 == false then
			return 
		end
		
		if arg_120_2 then
			var_120_1:setScale(1)
			if_set_visible(arg_120_0.vars.dlg, "n_count_info", true)
		else
			var_120_1:setVisible(true)
			var_120_1:setScale(0)
			UIAction:Add(SEQ(LOG(SCALE(80, 0, 1))), var_120_1)
		end
	else
		var_120_1:setScale(1)
		
		if arg_120_2 then
			if_set_visible(arg_120_0.vars.dlg, "n_count_info", false)
		elseif var_120_1:isVisible() then
			UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false), CALL(var_120_0, var_120_1)), var_120_1)
		end
	end
end

function BattleReady.checkWeekPoint(arg_122_0)
	local var_122_0 = to_n(arg_122_0.vars.opts.weak_lv)
	local var_122_1
	local var_122_2
	
	if var_122_0 > 0 then
	end
	
	return var_122_0, var_122_1, var_122_2
end

function BattleReady.onChangeWeekPoint(arg_123_0, arg_123_1)
	if not arg_123_0.vars.opts.weak_lv then
		arg_123_0.vars.opts.weak_lv = 0
	end
	
	local var_123_0
	
	if arg_123_1 then
		var_123_0 = math.min(arg_123_0.vars.opts.weak_lv + 1, 3)
	else
		var_123_0 = math.max(arg_123_0.vars.opts.weak_lv - 1, 0)
	end
	
	arg_123_0.vars.opts.weak_lv = var_123_0
	
	arg_123_0:onUpdateWeekPoint()
end

function BattleReady.isValid(arg_124_0)
	if not arg_124_0.vars or not get_cocos_refid(arg_124_0.vars.dlg) then
		return false
	end
	
	return true
end

function BattleReady.getAutomatonHealIcon(arg_125_0)
	if not arg_125_0.vars or not get_cocos_refid(arg_125_0.vars.dlg) then
		return false
	end
	
	for iter_125_0 = 1, 4 do
		local var_125_0 = arg_125_0.vars.dlg:getChildByName("info" .. iter_125_0)
		
		if get_cocos_refid(var_125_0) then
			local var_125_1 = var_125_0:getChildByName("n_heal")
			
			if get_cocos_refid(var_125_1) and var_125_1:isVisible() then
				return var_125_1:getChildByName("btn_heal")
			end
		end
	end
	
	return arg_125_0.vars.dlg:getChildByName("btn_heal")
end

function BattleReady.penguine_bonus(arg_126_0)
	if not arg_126_0.vars or not get_cocos_refid(arg_126_0.vars.dlg) then
		return 
	end
	
	if not arg_126_0.vars.is_max_level_exist then
		balloon_message_with_sound("msg_penguin_bonus_yet")
		
		return 
	end
	
	local var_126_0 = arg_126_0.vars.dlg:getChildByName("n_penguin_tip")
	
	if not get_cocos_refid(var_126_0) then
		return 
	end
	
	var_126_0:setVisible(not var_126_0:isVisible())
end

function BattleReady.off_penguine_bonus(arg_127_0)
	if not arg_127_0.vars or not get_cocos_refid(arg_127_0.vars.dlg) then
		return 
	end
	
	if_set_visible(arg_127_0.vars.dlg, "n_penguin_tip", false)
end

function BattleReady.onUpdateWeekPoint(arg_128_0)
	local var_128_0 = arg_128_0:getRightContentWnd()
	
	if not get_cocos_refid(var_128_0) then
		return 
	end
	
	return 
end

function BattleReady.isCrehuntMode(arg_129_0)
	if not arg_129_0.vars then
		return false
	end
	
	return arg_129_0.vars.isCrehunt
end
