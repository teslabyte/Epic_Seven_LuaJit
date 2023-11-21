DungeonTrialHallWeeklyRewad = {}
DungeonTrialHall = {}

function MsgHandler.trialhall_update(arg_1_0)
	if arg_1_0 then
		DungeonTrialHallWeeklyRewad:onShow(arg_1_0)
		DungeonTrialHall:setCurrentInfo(arg_1_0.current_info)
	end
	
	if arg_1_0 and arg_1_0.latest_id then
		DungeonTrialHall:setPrevSeasonID(arg_1_0.latest_id)
	end
	
	DungeonTrialHall:setMyRankUI(nil, arg_1_0.current_info, true)
end

function HANDLER.dungeon_trial(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_start" then
		DungeonTrialHall:onReady()
		
		return 
	end
	
	if arg_2_1 == "btn_reward_train" then
		DungeonTrialHall_RewardPopup:open()
		
		return 
	end
end

function HANDLER.dungeon_trial_rank_honor_p(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ok" then
		DungeonTrialHallWeeklyRewad:onCloseRankerPopup()
		DungeonTrialHallWeeklyRewad:onShowMyRewardPopup()
	end
end

function HANDLER.dungeon_trial_rank_reward_p(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_ok" then
		DungeonTrialHallWeeklyRewad:onCloseMyRewardPopup(rtn)
	end
end

function DungeonTrialHall.getDB(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = Account:getActiveTrialHall() or {}
	local var_5_2
	
	for iter_5_0 = 1, 999999999 do
		local var_5_3 = {}
		
		var_5_3.id, var_5_3.name, var_5_3.enter_key, var_5_3.boss_id, var_5_3.boss_penalty_skills, var_5_3.boss_benefit_skills, var_5_3.monster_id, var_5_3.icon_trial = DBN("level_battlemenu_trialhall", iter_5_0, {
			"id",
			"name",
			"enter_key",
			"boss_id",
			"boss_penalty_skills",
			"boss_benefit_skills",
			"monster_id",
			"icon_trial"
		})
		
		if not var_5_3.id then
			break
		end
		
		var_5_0[var_5_3.id] = var_5_3
		
		if var_5_3.id == var_5_1.id then
			var_5_2 = var_5_3
		end
	end
	
	return var_5_0, var_5_2
end

function DungeonTrialHall.create(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.parent_wnd = arg_6_1
	arg_6_0.vars.parent_right = DungeonList:getMenuWnd()
	arg_6_0.vars.parent_left = DungeonList:getLeftWnd()
	
	local var_6_0 = Account:getTrialHallSchedules()
	
	arg_6_0.vars.schedules = {}
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1.end_time > os.time() then
			table.insert(arg_6_0.vars.schedules, iter_6_1)
		end
	end
	
	table.sort(arg_6_0.vars.schedules, function(arg_7_0, arg_7_1)
		return (tonumber(arg_7_0.start_time) or 999) < (tonumber(arg_7_1.start_time) or 999)
	end)
	
	local var_6_1
	local var_6_2
	
	arg_6_0.vars.db_datas, var_6_2 = arg_6_0:getDB()
	
	local var_6_3 = Account:getActiveTrialHall()
	local var_6_4 = Account:isRestTimeTrialHall(var_6_3)
	
	arg_6_0.vars.right_base_wnd = arg_6_0.vars.parent_right:getChildByName("sub_Trial_Hall")
	arg_6_0.vars.base_wnd = arg_6_0.vars.parent_wnd:getChildByName("n_Train_base")
	arg_6_0.vars.original_pos_x = arg_6_0.vars.base_wnd:getPositionX()
	arg_6_0.vars.original_pos_y = arg_6_0.vars.base_wnd:getPositionY()
	
	arg_6_0.vars.base_wnd:setVisible(true)
	arg_6_0:createEnterWindow()
	arg_6_0.vars.wnd:setVisible(false)
	
	arg_6_0.vars.magic_eff = arg_6_0.vars.base_wnd:getChildByName("n_eff")
	arg_6_0.vars.dummy_scale = arg_6_0.vars.parent_wnd:getChildByName("dummy_scale")
	
	if_set_visible(arg_6_0.vars.parent_wnd, "n_Train_base", true)
	if_set_visible(arg_6_0.vars.parent_wnd, "selected", false)
	if_set_visible(arg_6_0.vars.parent_wnd, "n_original", false)
	if_set_visible(arg_6_0.vars.parent_left, "btn_reward_train", true)
	if_set_visible(arg_6_0.vars.right_base_wnd, "btn_trial_back", false)
	if_set_visible(arg_6_0.vars.right_base_wnd, "btn_story", true)
	
	local var_6_5 = arg_6_0.vars.parent_left:getChildByName("n_trial_info")
	
	var_6_5:setVisible(true)
	
	arg_6_0.vars.left_n_trial_info = var_6_5
	
	if_set_visible(var_6_5, "t_deadline", not var_6_4)
	if_set_visible(var_6_5, "t_nextboss", var_6_4)
	if_set_visible(arg_6_0.vars.parent_left, "btn_rank", true)
	
	local var_6_6 = arg_6_0.vars.db_datas[(arg_6_0.vars.schedules[1] or {}).id]
	
	if_set_visible(arg_6_0.vars.wnd, "n_no_data", false)
	arg_6_0:updateIcons()
	arg_6_0:updateTime()
	if_set_visible(arg_6_0.vars.left, "n_trial_info", true)
	
	if Account:getExclusiveShopNoti() == nil then
		query("get_exclusive_shop_item_noti")
	else
		arg_6_0:updateNewItemIcon()
	end
	
	if_set(arg_6_0.vars.left_n_trial_info:getChildByName("n_ranking"), "txt_my_rank", " ")
	if_set(arg_6_0.vars.left_n_trial_info:getChildByName("n_ranking"), "txt_pts", " ")
	if_set_visible(arg_6_0.vars.left_n_trial_info:getChildByName("n_ranking"), "rank_raid", false)
	
	if not TutorialGuide:isPlayingTutorial() then
		query("trialhall_update")
	end
	
	set_high_fps_tick(6000)
	
	arg_6_0.vars.layer = arg_6_0:getBackground()
	
	arg_6_0.vars.parent_wnd:addChild(arg_6_0.vars.wnd)
	arg_6_0.vars.layer:sortAllChildren()
	SAVE:setTempConfigData("red_dot_trial_hall", Account:getActiveTrialHall().id)
	
	return arg_6_0.vars.layer
end

function DungeonTrialHall.updateNewItemIcon(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.right_base_wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.right_base_wnd:getChildByName("btn_exchange_private")
	
	if get_cocos_refid(var_8_0) then
		if Account:getExclusiveShopNoti() then
			if_set_visible(var_8_0, "n_new_item", true)
		else
			if_set_visible(var_8_0, "n_new_item", false)
		end
		
		if_set(var_8_0, "txt_talk", T("trial_hall_new_equip"))
	end
end

function DungeonTrialHall.setCurrentInfo(arg_9_0, arg_9_1)
	arg_9_0.vars.currentInfo = arg_9_1 or {}
end

function DungeonTrialHall.getCurrentInfo(arg_10_0)
	return arg_10_0.vars.currentInfo
end

function DungeonTrialHall.getTargetId(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	return arg_11_0.vars.target_id
end

function DungeonTrialHall.updateIcons(arg_12_0)
	local var_12_0 = os.time()
	
	arg_12_0.vars.icon_wnds = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.schedules) do
		local var_12_1 = arg_12_0.vars.parent_wnd:getChildByName("n_trial_hall_" .. iter_12_0)
		
		if get_cocos_refid(var_12_1) then
			local var_12_2 = var_12_1:getChildByName("btn_trial_hall_" .. iter_12_0)
			local var_12_3 = var_12_1:getChildByName("selected")
			
			arg_12_0.vars.icon_wnds[iter_12_1.id] = var_12_1
			
			local var_12_4 = arg_12_0.vars.db_datas[iter_12_1.id]
			
			if iter_12_0 == 1 then
				local var_12_5 = Account:isRestTimeTrialHall(iter_12_1)
				
				if_set_visible(var_12_1, "txt_open", not var_12_5)
				
				if var_12_5 then
					if_set_sprite(var_12_1, "label_bg_red", "img/_titlebg_radder.png")
				end
				
				if not var_12_1.select_eff then
					var_12_1.select_eff = EffectManager:Play({
						x = 0,
						y = 0,
						fn = "trial_button_bounce.cfx",
						layer = var_12_1:getChildByName("n_eff")
					})
				end
			end
			
			var_12_3:setVisible(false)
			
			var_12_2.target_id = iter_12_1.id
			
			if_set(var_12_3, "txt_hero_name", T(var_12_4.name))
			if_set(var_12_1, "label_hero_name", T(var_12_4.name))
			
			if var_12_4.icon_trial then
				if_set_sprite(var_12_1, "boss_icon", "img/" .. var_12_4.icon_trial .. ".png")
			end
		end
	end
end

function DungeonTrialHall.updateTime(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if not arg_13_0.vars.schedules then
		return 
	end
	
	local var_13_0 = ""
	local var_13_1 = os.time()
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.schedules) do
		local var_13_2 = arg_13_0.vars.parent_wnd:getChildByName("n_trial_hall_" .. iter_13_0)
		local var_13_3 = arg_13_0.vars.db_datas[iter_13_1.id]
		local var_13_4 = ""
		local var_13_5 = false
		local var_13_6 = 0
		local var_13_7, var_13_8 = Account:isRestTimeTrialHall(iter_13_1)
		
		if var_13_1 >= iter_13_1.start_time and var_13_1 < iter_13_1.end_time then
			local var_13_9 = iter_13_1.end_time - var_13_1
			local var_13_10 = "remain_time_urgent"
			
			if var_13_7 and var_13_8 and var_13_8 > 0 then
				var_13_9 = var_13_8
				var_13_10 = "trial_hall_date_next"
			end
			
			if var_13_9 >= 3600 then
				var_13_4 = T(var_13_10, {
					time = sec_to_full_string(var_13_9, nil, {
						no_min = true
					})
				})
			else
				var_13_4 = T(var_13_10, {
					time = sec_to_string(var_13_9)
				})
			end
			
			local var_13_11 = var_13_4
		elseif var_13_1 >= iter_13_1.end_time then
			var_13_4 = T("urgent_time_expire")
		else
			var_13_4 = T("ui_trial_hall_start_time", {
				day = sec_to_string(iter_13_1.start_time - var_13_1)
			})
		end
		
		if var_13_7 then
			if_set_opacity(var_13_2, "txt_time", 127.5)
		end
		
		if_set(var_13_2, "txt_time", var_13_4)
		if_set(var_13_2, "txt_select_time", var_13_4)
	end
	
	if_set_visible(arg_13_0.vars.left_n_trial_info, "n_ranking", true)
end

function DungeonTrialHall.onEnter(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_2 = arg_14_2 or {}
	arg_14_0.vars.opts = arg_14_2
	arg_14_0.vars.info = arg_14_3
	
	if not arg_14_0.vars.opts.target_id then
		return Log.e("DungeonTrialHall.onEnter", "no_target_id")
	end
	
	arg_14_0.vars.target_id = arg_14_2.target_id
	arg_14_0.vars.target_db = arg_14_0.vars.db_datas[arg_14_0.vars.target_id]
	arg_14_0.vars.target_wnd = arg_14_0.vars.icon_wnds[arg_14_0.vars.target_id]
	arg_14_0.vars.select_wnd = arg_14_0.vars.target_wnd:getChildByName("selected")
	arg_14_0.vars.target_schedule = nil
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.schedules) do
		if iter_14_1.id == arg_14_0.vars.target_id then
			arg_14_0.vars.target_schedule = iter_14_1
			
			break
		end
	end
	
	if not arg_14_0.vars.target_schedule then
		return Log.e("DungeonTrialHall.onEnter", "no_schedule")
	end
	
	arg_14_0.vars.wnd:setVisible(true)
	arg_14_0.vars.select_wnd:setVisible(true)
	
	local var_14_0 = arg_14_0.vars.select_wnd:getChildByName("vignetting")
	
	var_14_0:setOpacity(0)
	if_set_visible(arg_14_0.vars.target_wnd, "n_select_off1", false)
	if_set_visible(arg_14_0.vars.target_wnd, "n_select_off2", false)
	
	local var_14_1 = arg_14_0.vars.target_wnd:getChildByName("n_trial_hall_button")
	local var_14_2 = arg_14_0.vars.parent_wnd:getChildByName("n_focus")
	local var_14_3 = arg_14_0.vars.target_wnd:convertToWorldSpace({
		x = 0,
		y = 0
	})
	local var_14_4 = var_14_2:getPositionX() - arg_14_0.vars.target_wnd:getPositionX()
	local var_14_5 = var_14_2:getPositionY() - arg_14_0.vars.target_wnd:getPositionY()
	
	UIAction:Add(LOG(MOVE_BY(200, var_14_4 * 1.2, var_14_5 * 1.2)), arg_14_0.vars.base_wnd, "block")
	UIAction:Add(LOG(SCALE_TO(200, 1.2)), arg_14_0.vars.dummy_scale, "block")
	UIAction:Add(SEQ(DELAY(100), OPACITY(200, 0, 1)), var_14_0, "block")
	if_set_visible(arg_14_0.vars.parent_wnd, "n_title", false)
	if_set_visible(arg_14_0.vars.parent_wnd, "reward", false)
	if_set_visible(arg_14_0.vars.right_base_wnd, "btn_exchange_private", false)
	if_set_visible(arg_14_0.vars.right_base_wnd, "btn_story", false)
	if_set_visible(arg_14_0.vars.parent_left, "btn_reward_train", false)
	if_set_visible(arg_14_0.vars.right_base_wnd, "btn_trial_back", true)
	if_set_visible(arg_14_0.vars.parent_left, "n_trial_info", false)
	
	local var_14_6 = arg_14_0.vars.wnd:getChildByName("RIGHT")
	local var_14_7 = arg_14_0.vars.wnd:getChildByName("LEFT")
	
	var_14_6:setPositionX(VIEW_BASE_RIGHT + 600)
	var_14_7:setPositionX(VIEW_BASE_LEFT - 400)
	UIAction:Add(LOG(MOVE_TO(400, VIEW_BASE_LEFT + NOTCH_WIDTH / 2)), var_14_7, "block")
	UIAction:Add(LOG(MOVE_TO(400, VIEW_BASE_RIGHT - NOTCH_WIDTH / 2)), var_14_6, "block")
	
	local var_14_8 = Account:getTrialHall(arg_14_0.vars.target_id)
	
	if_set_visible(arg_14_0.vars.wnd, "txt_no_score", var_14_8 == nil)
	if_set_visible(arg_14_0.vars.wnd, "txt_score_font", var_14_8 ~= nil)
	
	local var_14_9 = arg_14_0.vars.parent_wnd:getChildByName("LEFT")
	local var_14_10 = arg_14_0.vars.parent_right
	
	if arg_14_2.enter then
		var_14_9:setVisible(true)
		var_14_10:setVisible(true)
	end
	
	local var_14_11 = Account:getActiveTrialHall()
	local var_14_12 = Account:isRestTimeTrialHall(arg_14_0.vars.target_schedule)
	
	if var_14_8 then
		local var_14_13 = Account:getTrialHallRankInfo()
		
		if var_14_13 and var_14_13.id and var_14_13.id == arg_14_0.vars.target_id then
			var_14_8.rank = var_14_13.rank
			var_14_8.rank_rate = var_14_13.rank_rate
		elseif var_14_8.rank and tonumber(var_14_8.rank) < 1 then
			var_14_8.rank = nil
		end
	end
	
	arg_14_0:setMyRankUI(arg_14_0.vars.wnd, var_14_8)
	
	local var_14_14 = arg_14_0.vars.wnd:getChildByName("n_no_data")
	local var_14_15 = arg_14_0.vars.wnd:getChildByName("n_score_info")
	
	if not var_14_8 or table.empty(var_14_8) then
		if_set_visible(var_14_15, nil, false)
		if_set_visible(var_14_14, nil, true)
		if_set(var_14_14, "txt_info", T("ui_trial_hall_default_score"))
	elseif var_14_11 then
		if_set_visible(var_14_15, nil, true)
		if_set_visible(var_14_14, nil, false)
	end
	
	if arg_14_0.vars.target_schedule.id ~= var_14_11.id then
		if_set_opacity(arg_14_0.vars.wnd, "btn_start", 76.5)
	else
		if_set_opacity(arg_14_0.vars.wnd, "btn_start", 255)
	end
	
	arg_14_0:makeEffectList({
		scroll = "penalty_scrollview",
		db = "boss_penalty_skills",
		target_node = arg_14_0.vars.wnd,
		txt_color = cc.c3b(255, 129, 119)
	})
	arg_14_0:makeEffectList({
		scroll = "benefit_scrollview",
		db = "boss_benefit_skills",
		target_node = arg_14_0.vars.wnd,
		txt_color = cc.c3b(101, 190, 255)
	})
	set_high_fps_tick(6000)
	TopBarNew:checkhelpbuttonID("infodung_2")
	
	local var_14_16 = arg_14_0.vars.wnd:getChildByName("page_title")
	
	if arg_14_0.vars.info and get_cocos_refid(var_14_16) then
		if_set(var_14_16, "txt_title", arg_14_0.vars.info.title)
		if_set(var_14_16, "txt_desc", "")
		UIAction:Add(SOUND_TEXT(arg_14_0.vars.info.desc, true, nil, nil, 60), var_14_16:getChildByName("txt_desc"), "dungeon_list.text")
	end
	
	arg_14_0:toggleOtherIcons(false)
	arg_14_0:updateTargetIcon(true)
end

function DungeonTrialHall.updateTargetIcon(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.target_wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.target_wnd
	local var_15_1 = var_15_0:getChildByName("n_eff")
	local var_15_2 = false
	
	if get_cocos_refid(var_15_1) then
		var_15_1:setVisible(true)
	end
	
	if get_cocos_refid(var_15_0.select_eff) then
		var_15_0.select_eff:setVisible(not arg_15_1)
		
		var_15_2 = true
	end
	
	if arg_15_1 and not get_cocos_refid(var_15_0.select_hold_eff) then
		var_15_0.select_hold_eff = EffectManager:Play({
			scale = 1,
			fn = "trial_button_hold.cfx",
			y = 0,
			x = 0,
			layer = var_15_1
		})
	end
	
	if var_15_2 then
		var_15_0.select_hold_eff:setVisible(arg_15_1)
	elseif arg_15_1 then
		var_15_0.select_hold_eff:setVisible(true)
		var_15_0.select_hold_eff:setOpacity(0)
		UIAction:Add(SEQ(FADE_IN(150), SHOW(true)), var_15_0.select_hold_eff, "trial_button_hold")
	else
		var_15_0.select_hold_eff:setOpacity(255)
		UIAction:Add(SEQ(FADE_OUT(150), SHOW(false)), var_15_0.select_hold_eff, "trial_button_hold")
	end
end

function DungeonTrialHall.toggleOtherIcons(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not arg_16_0.vars.target_wnd then
		return 
	end
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.icon_wnds) do
		if iter_16_1 ~= arg_16_0.vars.target_wnd and get_cocos_refid(iter_16_1) then
			if not arg_16_1 then
				iter_16_1:setOpacity(255)
				UIAction:Add(SEQ(FADE_OUT(300), SHOW(false)), iter_16_1, "FO_" .. iter_16_0)
			else
				iter_16_1:setOpacity(0)
				UIAction:Add(SEQ(SHOW(true), FADE_IN(300)), iter_16_1, "FI_" .. iter_16_0)
			end
		end
	end
end

function DungeonTrialHall.createEnterWindow(arg_17_0)
	if get_cocos_refid(arg_17_0.vars.wnd) then
		arg_17_0.vars.wnd:removeFromParent()
		
		arg_17_0.vars.wnd = nil
	end
	
	arg_17_0.vars.wnd = load_control("wnd/dungeon_trial.csb")
	
	arg_17_0.vars.wnd:setScale(1)
	arg_17_0.vars.wnd:setLocalZOrder(1)
	
	return arg_17_0.vars.wnd
end

function DungeonTrialHall.set_rankImg(arg_18_0, arg_18_1, arg_18_2)
	for iter_18_0 = 1, 99 do
		local var_18_0 = "trialhall_rank_" .. iter_18_0
		local var_18_1, var_18_2 = DB("challenge_rank", var_18_0, {
			"rank",
			"rank_point"
		})
		
		if not var_18_1 or tonumber(arg_18_2) < tonumber(var_18_2) then
			if iter_18_0 ~= 1 then
				var_18_0 = "trialhall_rank_" .. iter_18_0 - 1
			end
			
			local var_18_3, var_18_4, var_18_5, var_18_6 = DB("challenge_rank", var_18_0, {
				"rank",
				"rank_point",
				"rank_reward",
				"rank_reward_value"
			})
			
			if not var_18_3 then
				Log.e("잘못된 결과값", var_18_0)
				
				return 
			end
			
			local var_18_7 = string.replace(var_18_3, "+", "_plus")
			
			SpriteCache:resetSprite(arg_18_1:getChildByName("rank_raid"), "img/rank_raid_" .. var_18_7 .. ".png")
			
			break
		end
	end
end

function DungeonTrialHall.makeEffectList(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1 or {}
	local var_19_1 = var_19_0.scroll
	local var_19_2 = var_19_0.db
	local var_19_3 = var_19_0.txt_color
	
	if not var_19_1 then
		return 
	end
	
	local var_19_4 = arg_19_0.vars.target_db[var_19_2] or ""
	local var_19_5 = load_control("wnd/trial_effect_grid.csb")
	local var_19_6 = string.split(var_19_4, ";")
	local var_19_7 = {
		x = 0,
		y = 0
	}
	local var_19_8 = 0
	local var_19_9 = 0
	local var_19_10 = 12
	local var_19_11 = 0
	
	for iter_19_0, iter_19_1 in pairs(var_19_6) do
		local var_19_12, var_19_13, var_19_14 = DB("cs", iter_19_1, {
			"boss_cs_icon_small",
			"boss_cs_icon_big",
			"boss_cs_description"
		})
		local var_19_15 = load_control("wnd/trial_effect_panel.csb")
		
		var_19_8 = var_19_8 + 1
		
		local var_19_16 = var_19_5:getChildByName("n_ability" .. var_19_8)
		
		if get_cocos_refid(var_19_16) then
			var_19_16:addChild(var_19_15)
			
			local var_19_17 = TooltipUtil:getCSTooltipText(T(var_19_14), iter_19_1)
			
			if var_19_12 then
				if_set_sprite(var_19_15, "icon", "buff/" .. var_19_12 .. ".png")
			end
			
			if_set(var_19_15, "txt", var_19_17)
			
			local var_19_18 = var_19_15:getChildByName("txt")
			local var_19_19 = 1
			
			if get_cocos_refid(var_19_18) then
				var_19_11 = 30 * var_19_18:getStringNumLines()
				
				var_19_18:setContentSize(var_19_18:getContentSize().width, var_19_11)
				
				var_19_19 = var_19_18:getScaleY()
				
				if var_19_3 then
					var_19_18:setColor(var_19_3)
				end
			end
			
			if var_19_8 == 1 then
				var_19_7.x = var_19_16:getPositionX()
				var_19_7.y = var_19_16:getPositionY()
			end
			
			var_19_16:setPosition(var_19_7.x, var_19_7.y)
			
			var_19_9 = var_19_9 + var_19_11
			var_19_7.y = var_19_7.y - var_19_11 * var_19_19 - var_19_10
		end
	end
	
	arg_19_0.vars[var_19_1] = {}
	
	copy_functions(ScrollView, arg_19_0.vars[var_19_1])
	
	arg_19_0.vars[var_19_1].getScrollViewItem = function(arg_20_0, arg_20_1)
		return arg_20_0.renderer
	end
	arg_19_0.vars[var_19_1].renderer = var_19_5
	arg_19_0.vars[var_19_1].scroll = var_19_0.target_node and var_19_0.target_node:getChildByName(var_19_1) or arg_19_0.vars.parent_wnd:getChildByName(var_19_1)
	
	local var_19_20 = var_19_5:getContentSize().height - var_19_7.y
	
	var_19_5:getChildByName("n_main"):setPositionY(-var_19_7.y)
	var_19_5:setContentSize(var_19_5:getContentSize().width, var_19_20)
	arg_19_0.vars[var_19_1]:initScrollView(arg_19_0.vars[var_19_1].scroll, var_19_5:getContentSize().width, var_19_5:getContentSize().height)
	arg_19_0.vars[var_19_1]:createScrollViewItems({
		1
	})
end

function DungeonTrialHall.CheckNotification(arg_21_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.TRIAL_HALL) then
		return false
	end
	
	if ContentDisable:byAlias(string.lower("trial_hall")) then
		return false
	end
	
	if Account:getConfigData("red_dot_trial_hall") ~= Account:getActiveTrialHall().id then
		return true
	end
	
	return false
end

function DungeonTrialHall.closeDetail(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.select_wnd:getChildByName("vignetting")
	
	arg_22_0.vars.select_wnd:setVisible(false)
	if_set_visible(arg_22_0.vars.target_wnd, "n_select_off1", true)
	if_set_visible(arg_22_0.vars.target_wnd, "n_select_off2", true)
	
	if not arg_22_1 then
		UIAction:Add(LOG(SPAWN(SCALE_TO(500, 1), MOVE_TO(500, arg_22_0.vars.original_pos_x, arg_22_0.vars.original_pos_y))), arg_22_0.vars.base_wnd, "block")
		UIAction:Add(LOG(SCALE_TO(500, 1)), arg_22_0.vars.dummy_scale, "block")
		UIAction:Add(SEQ(DELAY(100), OPACITY(200, 1, 0)), var_22_0, "block")
	end
	
	local var_22_1 = arg_22_0.vars.wnd:getChildByName("LEFT")
	local var_22_2 = arg_22_0.vars.wnd:getChildByName("RIGHT")
	
	UIAction:Add(RLOG(MOVE_TO(250, VIEW_BASE_LEFT - 700)), var_22_1, "block")
	UIAction:Add(RLOG(MOVE_TO(250, VIEW_BASE_RIGHT + 800)), var_22_2, "block")
	UIAction:Add(SEQ(DELAY(250), SHOW(false)), arg_22_0.vars.wnd, "block")
	if_set_visible(arg_22_0.vars.parent_wnd, "n_title", true)
	if_set_visible(arg_22_0.vars.parent_wnd, "reward", true)
	
	if DungeonList.vars.mode == "Trial_Hall" then
		if_set_visible(arg_22_0.vars.right_base_wnd, "btn_exchange_private", true)
		if_set_visible(arg_22_0.vars.right_base_wnd, "btn_story", true)
		if_set_visible(arg_22_0.vars.parent_left, "btn_reward_train", true)
		if_set_visible(arg_22_0.vars.parent_left, "n_trial_info", true)
		if_set_visible(arg_22_0.vars.parent_left:getChildByName("n_trial_info"), "btn_rank", true)
	end
	
	if_set_visible(arg_22_0.vars.right_base_wnd, "btn_trial_back", false)
	arg_22_0:toggleOtherIcons(true)
	arg_22_0:updateTargetIcon(false)
	set_high_fps_tick(6000)
end

function DungeonTrialHall.getDungeonDBName(arg_23_0)
	return "level_battlemenu_trialhall"
end

function DungeonTrialHall.getBackground(arg_24_0)
	local var_24_0 = cc.Layer:create()
	
	EffectManager:Play({
		x = 0,
		y = 0,
		fn = "ui_new_training_bg.cfx",
		layer = var_24_0
	})
	arg_24_0.vars.magic_eff:removeAllChildren()
	EffectManager:Play({
		fn = "ui_new_training_circles.cfx",
		layer = arg_24_0.vars.magic_eff
	})
	
	return var_24_0
end

function DungeonTrialHall.onAfterUpdate(arg_25_0)
	local var_25_0 = 1
	
	if arg_25_0.vars and get_cocos_refid(arg_25_0.vars.dummy_scale) then
		var_25_0 = arg_25_0.vars.dummy_scale:getScale()
	end
	
	if arg_25_0.vars and get_cocos_refid(arg_25_0.vars.base_wnd) then
		local var_25_1 = math.sin(uitick() / 2861 * 3.141592 / 2)
		local var_25_2 = math.sin(uitick() / 2179 * 3.141592 / 2)
		
		arg_25_0.vars.base_wnd:setScaleX(((var_25_2 + 1) / 2 * 0.03 + 1) * var_25_0)
		arg_25_0.vars.base_wnd:setScaleY(((var_25_1 + 1) / 2 * 0.03 + 1) * var_25_0)
		arg_25_0:updateTime()
	end
end

function DungeonTrialHall.onAfterEnter(arg_26_0)
	arg_26_0:updateUI()
end

function DungeonTrialHall.onLeave(arg_27_0)
	arg_27_0:closeDetail()
end

function DungeonTrialHall.updateUI(arg_28_0)
end

function DungeonTrialHall.updateNotifier(arg_29_0)
	local var_29_0 = arg_29_0:isNotifier()
end

function DungeonTrialHall.isNotifier(arg_30_0)
end

function DungeonTrialHall.getTargetDBId(arg_31_0)
	if not arg_31_0.vars or not arg_31_0.vars.target_db or not arg_31_0.vars.target_db.id then
		return 
	end
	
	return arg_31_0.vars.target_db.id
end

function DungeonTrialHall.onReady(arg_32_0)
	local var_32_0 = Account:getActiveTrialHall()
	local var_32_1 = Account:isRestTimeTrialHall(var_32_0)
	
	local function var_32_2()
		BattleReady:show({
			enter_id = arg_32_0.vars.target_db.enter_key,
			callback = arg_32_0,
			trial_id = arg_32_0.vars.target_db.id,
			currencies = DungeonList:getCurrentCurrencies()
		})
	end
	
	if arg_32_0.vars.target_schedule.id == var_32_0.id and var_32_1 then
	elseif arg_32_0.vars.target_schedule.id == var_32_0.id then
		var_32_2(nil)
	else
		balloon_message_with_sound("ui_msg_trial_hall_not_open")
	end
end

function DungeonTrialHall.onStartBattle(arg_34_0, arg_34_1)
	arg_34_1 = arg_34_1 or {}
	
	local var_34_0 = Account:getActiveTrialHall()
	
	if arg_34_0.vars.target_schedule then
		if arg_34_0.vars.target_schedule.id ~= var_34_0.id or arg_34_0.vars.target_db.id ~= var_34_0.id then
			balloon_message_with_sound("ui_msg_trial_hall_not_open")
			
			return 
		end
		
		startBattle(arg_34_0.vars.target_db.enter_key, {
			trial_id = arg_34_0.vars.target_db.id
		})
	end
end

function DungeonTrialHall.setPrevSeasonID(arg_35_0, arg_35_1)
	if not arg_35_0.vars then
		return 
	end
	
	arg_35_0.vars.pervSeasonID = arg_35_1
end

function DungeonTrialHall.getPrevSeasonID(arg_36_0)
	if not arg_36_0.vars then
		return 
	end
	
	return arg_36_0.vars.pervSeasonID
end

function DungeonTrialHall.setMyRankUI(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = arg_37_2 or {}
	local var_37_1 = arg_37_1 or arg_37_0.vars.left_n_trial_info
	
	if arg_37_3 then
		Account:setTrialHallRankInfo(var_37_0)
	end
	
	local var_37_2 = var_37_1:getChildByName("n_ranking")
	local var_37_3 = T("trial_hall_rank_none")
	local var_37_4 = T("trial_hall_battle_point_none")
	
	if not var_37_0.score then
		local var_37_5 = 0
	end
	
	if var_37_0.rank then
		if var_37_0.rank <= 100 then
			var_37_3 = T("trial_hall_rank_point_rank", {
				rank = var_37_0.rank
			})
		else
			local var_37_6 = round(var_37_0.rank_rate, 2)
			
			if var_37_6 * 10 > 0 then
				var_37_6 = math.ceil(var_37_0.rank_rate * 100) / 100
			end
			
			var_37_3 = T("trial_hall_rank_point_per", {
				per = math.max(var_37_6 * 100, 1)
			})
		end
		
		if_set(var_37_2, "txt_my_rank", var_37_3)
		if_set_visible(var_37_2, "txt_my_rank", true)
		if_set_visible(var_37_2, "txt_no_rank", false)
	else
		if_set_visible(var_37_2, "txt_my_rank", false)
		if_set_visible(var_37_2, "txt_no_rank", true)
	end
	
	local var_37_7 = 0
	local var_37_8 = var_37_1:getChildByName("n_score")
	
	if get_cocos_refid(var_37_8) then
		var_37_8:setVisible(true)
		
		if var_37_0.score then
			if_set_visible(var_37_8, "txt_score_font", true)
			if_set(var_37_8, "txt_score_font", comma_value(var_37_0.score or 3547890))
			
			var_37_7 = var_37_0.score or 0
		else
			if_set_visible(var_37_8, "txt_score_font", false)
			if_set_visible(var_37_8, "txt_no_score ", true)
		end
		
		arg_37_0:set_rankImg(var_37_8, var_37_7)
	end
	
	local var_37_9 = var_37_2:getChildByName("rank_raid")
	
	if get_cocos_refid(var_37_9) then
		var_37_9:setVisible(false)
	end
end

function DungeonTrialHallWeeklyRewad.onShow(arg_38_0, arg_38_1)
	if not arg_38_1 then
		return 
	end
	
	arg_38_0.vars = {}
	arg_38_0.vars.rtn = arg_38_1
	
	local var_38_0 = arg_38_1.latest_id
	
	if var_38_0 ~= (Account:getConfigData("trial_ranking_id") or "") and not table.empty(arg_38_1.ranker_list) then
		arg_38_0:onShowRankerPopup(arg_38_1)
		SAVE:setTempConfigData("trial_ranking_id", var_38_0)
		SAVE:sendQueryServerConfig()
	else
		arg_38_0:onShowMyRewardPopup()
	end
end

function DungeonTrialHallWeeklyRewad.onShowRankerPopup(arg_39_0, arg_39_1)
	if not arg_39_1 or not arg_39_1.ranker_list then
		return 
	end
	
	if not TutorialGuide:isClearedTutorial("system_118_new") then
		return 
	end
	
	arg_39_0.vars.ranker_popup = load_dlg("dungeon_trial_rank_honor_p", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_39_0.vars.ranker_popup)
	
	for iter_39_0 = 1, 3 do
		if_set_visible(arg_39_0.vars.ranker_popup, "n_" .. iter_39_0, false)
	end
	
	local var_39_0 = arg_39_1.ranker_list
	
	for iter_39_1, iter_39_2 in pairs(var_39_0) do
		local var_39_1 = iter_39_2.rank
		local var_39_2 = iter_39_2.user_info
		local var_39_3 = iter_39_2.score
		local var_39_4 = arg_39_0.vars.ranker_popup:getChildByName("n_" .. var_39_1)
		
		if not get_cocos_refid(var_39_4) then
			break
		end
		
		if_set_visible(arg_39_0.vars.ranker_popup, "n_" .. var_39_1, true)
		if_set(var_39_4, "txt_point", T("trial_hall_battle_point", {
			point = comma_value(var_39_3)
		}))
		if_set(var_39_4, "txt_user_name", var_39_2.name)
		UIUtil:getUserIcon(var_39_2.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = var_39_4:getChildByName("mob_icon_" .. var_39_1),
			border_code = var_39_2.border_code
		})
		
		if iter_39_2.clan_info then
			if_set(var_39_4, "txt_clan_name", iter_39_2.clan_info.name)
			ClanUtil:setSpriteEmblem(var_39_4, iter_39_2.clan_info.emblem)
		else
			if_set_visible(var_39_4, "txt_clan_name", false)
			if_set_visible(var_39_4, "n_emblem", false)
		end
	end
	
	if arg_39_1.latest_id then
		local var_39_5 = Account:getActiveTrialHall()
		local var_39_6
		local var_39_7 = Account:getTrialHallSchedules()
		
		if not var_39_5 or table.empty(var_39_5) then
			return 
		end
		
		local var_39_8 = 0
		local var_39_9 = 0
		
		for iter_39_3, iter_39_4 in pairs(var_39_7) do
			if var_39_5.id ~= iter_39_4.id and iter_39_4.id == arg_39_1.latest_id and iter_39_4.start_time < var_39_5.start_time and var_39_9 < iter_39_4.start_time then
				var_39_6 = iter_39_4
				var_39_9 = iter_39_4.start_time
			end
		end
		
		if not var_39_6 then
			return 
		end
		
		if_set_visible(arg_39_0.vars.ranker_popup, "n_contents", true)
		
		local var_39_10, var_39_11 = DB("level_battlemenu_trialhall", arg_39_1.latest_id, {
			"monster_id",
			"icon_trial"
		})
		
		if_set_sprite(arg_39_0.vars.ranker_popup, "img_boss", "img/" .. var_39_11 .. ".png")
		UIUtil:getRewardIcon("c", var_39_10, {
			no_popup = true,
			no_lv = true,
			no_grade = true,
			parent = arg_39_0.vars.ranker_popup:getChildByName("n_face")
		})
		
		local var_39_12 = var_39_6.start_time
		local var_39_13 = var_39_6.end_time
		local var_39_14 = timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_39_12,
			end_time = var_39_13
		})
		
		if var_39_14 then
			local var_39_15 = var_39_14.start_year .. "/" .. var_39_14.start_month .. "/" .. var_39_14.start_day .. "-" .. var_39_14.end_year .. "/" .. var_39_14.end_month .. "/" .. var_39_14.end_day
			
			if_set(arg_39_0.vars.ranker_popup, "txt_season_period", T("trial_hall_end_ranker_season", {
				season = var_39_15
			}))
		else
			if_set_visible(arg_39_0.vars.ranker_popup, "txt_season_period", false)
		end
	else
		if_set_visible(arg_39_0.vars.ranker_popup, "n_contents", false)
	end
end

function DungeonTrialHallWeeklyRewad.onCloseRankerPopup(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.ranker_popup) then
		return 
	end
	
	arg_40_0.vars.ranker_popup:removeFromParent()
end

function DungeonTrialHallWeeklyRewad.onShowMyRewardPopup(arg_41_0)
	if not arg_41_0.vars or not arg_41_0.vars.rtn or table.empty(arg_41_0.vars.rtn.rank_reward) or arg_41_0.vars.rtn.score and arg_41_0.vars.rtn.score <= 0 then
		arg_41_0.vars = nil
		
		return 
	end
	
	arg_41_0.vars.reward_popup = load_dlg("dungeon_trial_rank_reward_p", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_41_0.vars.reward_popup)
	
	local var_41_0 = arg_41_0.vars.rtn
	
	if var_41_0.rank <= 100 then
		if_set(arg_41_0.vars.reward_popup, "txt_rank_my", T("trial_hall_rank_point_rank", {
			rank = var_41_0.rank
		}))
	else
		local var_41_1 = round(var_41_0.rank_rate, 1)
		
		if var_41_1 <= 0 then
			var_41_1 = round(var_41_0.rank_rate, 2)
		end
		
		if_set(arg_41_0.vars.reward_popup, "txt_rank_my", T("trial_hall_rank_point_per", {
			per = var_41_1 * 100
		}))
	end
	
	if_set(arg_41_0.vars.reward_popup, "txt_pts_my", T("trial_hall_battle_point", {
		point = comma_value(var_41_0.score)
	}))
	
	local var_41_2 = var_41_0.rank_reward
	
	if var_41_2.new_items and var_41_2.new_items[1] then
		local var_41_3 = var_41_2.new_items[1]
		local var_41_4 = math.max(var_41_3.c - Account:getItemCount(var_41_3.code), 0)
		
		UIUtil:getRewardIcon(var_41_4, var_41_3.code, {
			show_small_count = true,
			parent = arg_41_0.vars.reward_popup:getChildByName("reward_item2")
		})
	end
	
	if var_41_2.gold then
		UIUtil:getRewardIcon(var_41_2.gold - Account:getCurrency("gold"), "to_gold", {
			show_small_count = true,
			parent = arg_41_0.vars.reward_popup:getChildByName("reward_item1")
		})
	end
	
	if var_41_2.exclusive then
		UIUtil:getRewardIcon(var_41_2.exclusive - Account:getCurrency("exclusive"), "to_exclusive", {
			show_small_count = true,
			parent = arg_41_0.vars.reward_popup:getChildByName("reward_item2")
		})
	end
	
	Account:addReward(var_41_0.rank_reward)
end

function DungeonTrialHallWeeklyRewad.onCloseMyRewardPopup(arg_42_0)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.reward_popup) then
		return 
	end
	
	arg_42_0.vars.reward_popup:removeFromParent()
	
	arg_42_0.vars = nil
end

function DungeonTrialHall.getSceneState(arg_43_0)
	if not arg_43_0.vars then
		return {}
	end
	
	local var_43_0 = {}
	
	if arg_43_0.vars.opts then
		var_43_0.target_id = arg_43_0.vars.opts.target_id
	end
	
	return var_43_0
end
