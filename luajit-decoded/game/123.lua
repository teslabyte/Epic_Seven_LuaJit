function HANDLER.dungeon_story_challenge2_item(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_banner" then
		SubStoryLobbyUIDescent:showReady(arg_1_0.enter_id)
	end
end

function HANDLER.dungeon_story_challenge2(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_shop" then
		SubStoryLobby:hideBG()
		SubstoryManager:openStoryShop()
	elseif arg_2_1 == "btn_achieve" then
		SubstoryAchievePopup:show()
	end
end

SubStoryLobbyUIDescent = SubStoryLobbyUIDescent or {}

copy_functions(SubStoryLobbyCommon, SubStoryLobbyUIDescent)

function SubStoryLobbyUIDescent.onEnterUI(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = arg_3_1
	
	local var_3_0 = SubstoryUIUtil:getBackground(arg_3_2.id, arg_3_2.background_summary, {
		isEnter = true
	})
	
	var_3_0:setAnchorPoint(0.5, 0.5)
	var_3_0:setLocalZOrder(-1)
	arg_3_0.vars.wnd:addChild(var_3_0)
	
	local var_3_1 = SubStoryUtil:getEventState(arg_3_2.start_time, arg_3_2.end_time)
	
	if_set(arg_3_0.vars.wnd, "t_boss_name", T(arg_3_2.name))
	
	local var_3_2 = arg_3_0.vars.wnd:getChildByName("n_core_reward")
	
	if_set_visible(var_3_2, nil, var_3_1 == SUBSTORY_CONSTANTS.STATE_OPEN)
	
	if var_3_1 == SUBSTORY_CONSTANTS.STATE_OPEN then
		local var_3_3 = {
			hero_multiply_scale = 0.85,
			artifact_multiply_scale = 0.6,
			multiply_scale = 0.8
		}
		
		SubstoryManager:setCoreRewardIcons(var_3_2, arg_3_2.id, var_3_3)
	end
	
	if_set_visible(arg_3_0.vars.wnd, "n_preview", var_3_1 == SUBSTORY_CONSTANTS.STATE_READY)
	if_set_visible(arg_3_0.vars.wnd, "n_common", var_3_1 == SUBSTORY_CONSTANTS.STATE_OPEN)
	if_set_visible(arg_3_0.vars.wnd, "n_close", var_3_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON)
	
	local var_3_4 = arg_3_2.start_time
	local var_3_5 = arg_3_2.end_time
	
	if_set(arg_3_0.vars.wnd, "label_period", T("ui_dungeon_story_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_3_4,
		end_time = var_3_5
	})))
	TopBarNew:setVisible(true)
	TopBarNew:checkhelpbuttonID("infosubs_7")
	
	local var_3_6 = arg_3_0:getContentsDB(arg_3_2.id)
	
	if not var_3_6 then
		Log.e("no_contents_db", "need_data")
	end
	
	if_set(arg_3_0.vars.wnd, "chall_title", T(var_3_6.descent_stage_title))
	
	arg_3_0.vars.difficulty_id = var_3_6.level_difficulty_id
	
	arg_3_0:updateRemainTime()
	
	if var_3_1 == SUBSTORY_CONSTANTS.STATE_READY then
		arg_3_0:setPreviewUI(var_3_6)
	end
	
	local var_3_7 = arg_3_2.shop_schedule == nil or SubstoryManager:isOpenSubstoryShop(arg_3_2.shop_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	local var_3_8 = var_3_1 ~= SUBSTORY_CONSTANTS.STATE_READY and arg_3_2.category and var_3_7
	
	if_set_visible(arg_3_0.vars.wnd, "btn_shop", var_3_8)
	if_set_visible(arg_3_0.vars.wnd, "btn_achieve", arg_3_2.achieve_flag and arg_3_2.achieve_flag == "y" and var_3_1 == SUBSTORY_CONSTANTS.STATE_OPEN)
	
	local var_3_9 = SubStoryUtil:getTopbarCurrencies(arg_3_2, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:setCurrencies(var_3_9)
end

function SubStoryLobbyUIDescent.setPreviewUI(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.vars.wnd:getChildByName("n_preview")
	
	if_set(var_4_0, "title_t", T(arg_4_1.descent_stage_title))
	
	for iter_4_0 = 1, 3 do
		local var_4_1 = var_4_0:getChildByName("n_phase" .. iter_4_0)
		
		if_set_visible(var_4_1, nil, arg_4_1["descent_phase_info" .. iter_4_0])
		
		local var_4_2
		
		if get_cocos_refid(var_4_1) and arg_4_1["descent_phase_info" .. iter_4_0] then
			var_4_2 = string.split(arg_4_1["descent_phase_info" .. iter_4_0], ";")
			
			for iter_4_1 = 1, 4 do
				local var_4_3 = var_4_1:getChildByName("mob_icon" .. iter_4_1)
				
				var_4_3:setVisible(var_4_2[iter_4_1] ~= nil)
				
				if var_4_2[iter_4_1] then
					UIUtil:getRewardIcon(nil, var_4_2[iter_4_1], {
						hide_lv = true,
						hide_star = true,
						monster = true,
						off_power_detail = true,
						lv = 99,
						no_grade = true,
						parent = var_4_3
					})
				end
			end
		end
	end
end

function SubStoryLobbyUIDescent.updateUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	SubstoryUIUtil:updateNotifier(arg_5_0.vars.wnd)
end

function SubStoryLobbyUIDescent.createCard(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = load_control("wnd/dungeon_story_challenge2_item.csb")
	
	arg_6_1:addChild(var_6_0)
	
	if not arg_6_3 then
		var_6_0:setVisible(false)
		
		return 
	end
	
	local var_6_1 = var_6_0:getChildByName("n_icon_difficulty")
	
	if arg_6_4 then
		if_set_sprite(var_6_0, "img_banner", "banner/" .. arg_6_4 .. ".png")
	end
	
	for iter_6_0 = 1, 5 do
		if_set_visible(var_6_1, tostring(iter_6_0), arg_6_2 == iter_6_0)
	end
	
	var_6_0:getChildByName("btn_banner").enter_id = arg_6_3
	
	local var_6_2 = {
		"ui_battle_ready_difficulty_easy",
		"ui_battle_ready_difficulty_normal",
		"ui_battle_ready_difficulty_hard",
		"ui_battle_ready_difficulty_hell",
		"ui_battle_ready_difficulty_exhell"
	}
	
	if_set(var_6_0, "t_difficulty", T(var_6_2[arg_6_2]))
	
	local var_6_3 = DB("level_enter", arg_6_3, "use_enterpoint")
	local var_6_4 = BattleReady:GetReqPointAndRewards(arg_6_3)
	
	if_set(var_6_0, "label_0", tostring(var_6_3))
	if_set(var_6_0, "t_power", comma_value(var_6_4))
	
	local var_6_5 = var_6_0:getChildByName("card")
	
	if not Account:checkEnterMap(arg_6_3) then
		var_6_5:setCascadeOpacityEnabled(true)
	end
	
	local var_6_6 = var_6_5:getPositionX()
	
	var_6_5:setPositionX(var_6_5:getPositionX() + var_6_0:getContentSize().width)
	UIAction:Add(SPAWN(LOG(OPACITY(arg_6_2 * 150, 0, Account:checkEnterMap(arg_6_3) == nil and 0.3 or 1)), LOG(MOVE_TO(50 * arg_6_2, var_6_6, 0))), var_6_5, "block")
	
	if Account:isMapCleared(arg_6_3) then
		local var_6_7 = var_6_0:getChildByName("icon_clear")
		
		var_6_7:setPositionX(var_6_0:getChildByName("t_difficulty"):getContentSize().width + var_6_7:getContentSize().width - 15)
		UIAction:Add(SEQ(DELAY(arg_6_2 * 100), SPAWN(SHOW(true), LOG(SCALE(100, 0, 1.6)))), var_6_7, "descent.enter")
	end
	
	BattleSelectDiffcultyUtil:updateLimit(var_6_0, arg_6_3)
end

function SubStoryLobbyUIDescent.getContentsDB(arg_7_0, arg_7_1)
	return (DBT("substory_descent", arg_7_1, {
		"id",
		"level_difficulty_id",
		"btn_bg_1",
		"btn_bg_2",
		"btn_bg_3",
		"descent_stage_title",
		"descent_phase_info1",
		"descent_phase_info2",
		"descent_phase_info3"
	}))
end

function SubStoryLobbyUIDescent.showReady(arg_8_0, arg_8_1)
	if not Account:checkEnterMap(arg_8_1) then
		balloon_message_with_sound("ui_battle_ready_difficulty_error")
		
		return 
	end
	
	local var_8_0, var_8_1, var_8_2 = Account:getEnterLimitInfo(arg_8_1)
	
	if var_8_0 and var_8_0 < 1 then
		if var_8_2 then
			balloon_message_with_sound("msg_descent_exhell_enter_limit")
		else
			balloon_message_with_sound("battle_cant_getin")
		end
		
		return 
	end
	
	DescentReady:show({
		enter_id = arg_8_1
	})
end

function SubStoryLobbyUIDescent.onStartBattle(arg_9_0, arg_9_1)
	if Account:getCurrentTeam()[1] == nil and Account:getCurrentTeam()[2] == nil and Account:getCurrentTeam()[3] == nil and Account:getCurrentTeam()[4] == nil and not arg_9_1.npcteam_id then
		message(T("ui_need_hero"))
		
		return 
	end
	
	Dialog:closeAll()
	startBattle(arg_9_1.enter_id, arg_9_1)
	BattleReady:hide()
end

function SubStoryLobbyUIDescent.updateEnterQueryUI(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	local var_10_0 = arg_10_0:getContentsDB(arg_10_1.id)
	
	if not var_10_0 then
		Log.e("no_contents_db", "need_data")
	end
	
	for iter_10_0 = 0, 2 do
		local var_10_1 = arg_10_0.vars.wnd:getChildByName("n_difficulty_card" .. iter_10_0 + 1)
		local var_10_2 = var_10_0["btn_bg_" .. tostring(iter_10_0 + 1)]
		
		if var_10_1 then
			if iter_10_0 == 0 then
				arg_10_0:createCard(var_10_1, iter_10_0 + 3, arg_10_0.vars.difficulty_id, var_10_2)
			else
				local var_10_3 = get_difficulty_id(arg_10_0.vars.difficulty_id, iter_10_0)
				
				arg_10_0:createCard(var_10_1, iter_10_0 + 3, var_10_3, var_10_2)
			end
		end
	end
end
