DungeonMaze = DungeonMaze or {}
DungeonMazeMain = {}

function MsgHandler.dungeon_maze_explore_reward(arg_1_0)
	Account:setExploreRewardStep(arg_1_0.explore_info)
	
	local var_1_0 = Account:addReward(arg_1_0.rewards, {
		play_reward_data = {
			title = T("ui_dungeon_rate_reward_title"),
			desc = T("ui_dungeon_rate_reward_desc")
		}
	})
	
	if var_1_0 and get_cocos_refid(var_1_0.reward_dlg) then
		if_set(var_1_0.reward_dlg, "txt_title", T("ui_dungeon_rate_reward_title"))
	end
	
	DungeonMaze:updateFloorInfo(true)
	DungeonMaze:updateNotification()
end

function MsgHandler.update_maze_link_units(arg_2_0)
	if arg_2_0.maze_used_unit then
		Account:setMazeUsedUnit(arg_2_0.maze_used_unit)
	end
	
	DungeonMaze:showReadyWnd()
end

function MsgHandler.dungeon_maze_story_cleanup(arg_3_0)
	if arg_3_0.played_stories then
		Account:mergePlayedStories(arg_3_0.played_stories)
	end
	
	if arg_3_0.update_user_configs then
		Account:updateUserConfigs(arg_3_0.update_user_configs)
	end
end

function HANDLER.dungeon_maze(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_go" then
		if arg_4_0.active_flag then
			DungeonMaze:ready()
		else
			DungeonMaze:showFloorLockMessage()
		end
	end
	
	if arg_4_1 == "btn_reward" then
		MazeRaidRewards:show(DungeonMaze.vars.floors[DungeonMaze.vars.i_floor].id)
	end
	
	if arg_4_1 == "btn_go_shop" then
		query("market", {
			caller = "dungeon"
		})
	end
	
	if arg_4_1 == "btn_change_difficulty" then
		if ContentDisable:byAlias("mazehellchallenge") then
			balloon_message_with_sound("msg_contents_disable_mazehellchallenge")
			
			return 
		end
		
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.MAZE_CHALLENGE_OPEN) then
			balloon_message_with_sound("msg_dungeon_challenge_yet")
			
			return 
		end
		
		local function var_4_0()
			DungeonMaze.vars.i_floor = DungeonMaze.vars.i_floor + 1
			
			if table.count(DungeonMaze.vars.floors) < DungeonMaze.vars.i_floor then
				DungeonMaze.vars.i_floor = 1
			end
			
			DungeonMaze.vars.prev_i_floor = DungeonMaze.vars.i_floor
			
			SAVE:setKeep(string.format("maze_keep_stage:%s", DungeonMaze.vars.id), DungeonMaze.vars.i_floor)
			UIAction:Add(SEQ(CALL(function()
				EffectManager:Play({
					fn = "stagechange_cloud.cfx",
					delay = 0,
					pivot_z = 99998,
					layer = SceneManager:getRunningNativeScene(),
					pivot_x = VIEW_WIDTH / 2 + 90,
					pivot_y = VIEW_HEIGHT / 2
				})
			end), DELAY(600), CALL(function()
				DungeonMaze:onChangeFloor(DungeonMaze.vars.i_floor)
			end)), SceneManager:getRunningNativeScene(), "block")
		end
		
		if table.count(DungeonMaze.vars.floors) > DungeonMaze.vars.i_floor then
			local var_4_1 = {
				yesno = true,
				handler = var_4_0,
				yes_text = T("ui_btn_challenge")
			}
			
			Dialog:msgBox(T("ui_popup_dungeon_challenge"), var_4_1)
		else
			var_4_0()
		end
	end
	
	if arg_4_1 == "btn_reward_progress" then
		local var_4_2 = DungeonMaze:getCurrentFloorInfo()
		
		if not var_4_2 then
			return 
		end
		
		query("dungeon_maze_explore_reward", {
			enter_id = var_4_2.id
		})
	end
end

copy_functions(ScrollView, DungeonMazeMain)

function DungeonMazeMain.isRaidMazePresents(arg_8_0)
	for iter_8_0 = 1, 99 do
		local var_8_0, var_8_1 = DBN("level_battlemenu_dungeon", iter_8_0, {
			"key_enter",
			"hell_enter_key"
		})
		
		if not var_8_0 and not var_8_1 then
			break
		end
		
		local var_8_2
		
		if to_n(string.sub(var_8_0 or "", -3, -1)) > 0 then
			var_8_2 = {
				var_8_0
			}
		elseif var_8_1 then
			var_8_2 = {}
			
			for iter_8_1, iter_8_2 in pairs(totable(var_8_1)) do
				table.insert(var_8_2, iter_8_2)
			end
		end
		
		if var_8_2 then
			for iter_8_3, iter_8_4 in pairs(var_8_2) do
				local var_8_3, var_8_4, var_8_5 = DB("level_enter", iter_8_4, {
					"id",
					"type",
					"contents_type"
				})
				
				if not var_8_3 or not string.starts(var_8_4, "dungeon") then
					break
				end
				
				if var_8_5 == "raid" then
					return true
				end
			end
		else
			for iter_8_5 = 1, 999 do
				local var_8_6, var_8_7, var_8_8 = DB("level_enter", string.format("%s%03d", var_8_0, iter_8_5), {
					"id",
					"type",
					"contents_type"
				})
				
				if not var_8_6 or not string.starts(var_8_7, "dungeon") then
					break
				end
				
				if var_8_8 == "raid" then
					return true
				end
			end
		end
	end
	
	return false
end

function DungeonMazeMain.getScrollViewItem(arg_9_0, arg_9_1)
	local var_9_0 = load_control("wnd/dungeon_period_bar.csb")
	
	var_9_0.info = arg_9_1
	var_9_0.parent = arg_9_0
	var_9_0.idx = #arg_9_0.ScrollViewItems + 1
	var_9_0.guide_tag = tostring(arg_9_1.id)
	
	if_set(var_9_0, "title", T(arg_9_1.name))
	
	local var_9_1, var_9_2, var_9_3 = DB("level_battlemenu_dungeon", tostring(var_9_0.info.id or 1), {
		"key_enter",
		"icon_battlemenu",
		"hell_enter_key"
	})
	local var_9_4 = arg_9_1.floors
	local var_9_5 = arg_9_1.total_score
	local var_9_6 = table.count(var_9_4)
	
	if var_9_3 then
		local var_9_7 = totable(var_9_3)
		local var_9_8 = DungeonMaze:getRaidResetTime(var_9_7.hell)
		local var_9_9 = var_9_8 > 0
		local var_9_10
		
		if var_9_9 then
			if_set(var_9_0, "txt_time", sec_to_full_string(var_9_8))
			
			var_9_10 = "#6bc11b"
		else
			if_set(var_9_0, "txt_time", T("ui_raid_break_time"))
			
			var_9_10 = "#ab8759"
		end
		
		if_set_color(var_9_0, "txt_time", tocolor(var_9_10))
		if_set_visible(var_9_0, "txt_progress", false)
		if_set_visible(var_9_0, "t_complete", false)
	else
		local var_9_11 = math.floor(var_9_5 / var_9_6)
		
		if_set(var_9_0, "txt_progress", T("maze_rate", {
			rate = var_9_11
		}))
		if_set(var_9_0, "t_complete", T("ui_dungeon_maze_complete"))
		if_set_visible(var_9_0, "txt_progress", var_9_11 < 100)
		if_set_visible(var_9_0, "t_complete", var_9_11 >= 100)
	end
	
	if_set_visible(var_9_0, "txt_time", var_9_3 ~= nil)
	if_set_visible(var_9_0, "btn_reward_progress", not var_9_3)
	
	local var_9_12 = var_9_0:getChildByName("bg")
	
	if var_9_2 and get_cocos_refid(var_9_12) then
		SpriteCache:resetSprite(var_9_12, "img/" .. var_9_2 .. ".png")
	end
	
	if_set_visible(var_9_0, "n_face", false)
	
	local var_9_13 = UnlockSystem:isUnlockMaze(var_9_0.info.id)
	
	if_set_visible(var_9_0, "n_locked", not var_9_13)
	
	if not var_9_13 then
		local var_9_14 = 76.5
		
		if_set_opacity(var_9_0, "bg", var_9_14)
		if_set_opacity(var_9_0, "title", var_9_14)
		if_set_opacity(var_9_0, "txt_progress", var_9_14)
		if_set_opacity(var_9_0, "n_badge", var_9_14)
	end
	
	DungeonCommon:setEventBanner(var_9_0, arg_9_1)
	
	local var_9_15 = false
	
	for iter_9_0, iter_9_1 in pairs(var_9_4) do
		if iter_9_1.is_rewardable then
			var_9_15 = true
			
			break
		end
	end
	
	if_set_visible(var_9_0, "icon_noti", var_9_15)
	
	return var_9_0
end

function DungeonMazeMain.onSelectScrollViewItem(arg_10_0, arg_10_1, arg_10_2)
	if TutorialGuide:checkBlockDungeonPeriodList(arg_10_2) then
		return 
	end
	
	SoundEngine:play("event:/ui/btn_small")
	
	local var_10_0 = arg_10_2.item
	
	if not arg_10_2 or not var_10_0 then
		return 
	end
	
	local var_10_1 = to_n(var_10_0.id)
	local var_10_2 = UnlockSystem:isUnlockSystemAndMsg({
		exclude_story = true,
		dungeon_id = DungeonList.getCurrentDungeonId(),
		maze_id = var_10_1
	}, function()
		DungeonList:onEndStoryCallback(arg_10_2.item)
	end)
end

function DungeonMaze.updateNotification(arg_12_0)
	if DungeonMazeMain and DungeonMazeMain.ScrollViewItems then
		for iter_12_0, iter_12_1 in pairs(DungeonMazeMain.ScrollViewItems) do
			if get_cocos_refid(iter_12_1.control) then
				local var_12_0 = iter_12_1.item and iter_12_1.item.id
				local var_12_1, var_12_2, var_12_3 = DB("level_battlemenu_dungeon", tostring(var_12_0 or 1), {
					"key_enter",
					"icon_battlemenu",
					"hell_enter_key"
				})
				local var_12_4, var_12_5 = DungeonMaze:GetMazeList(var_12_1 or totable(var_12_3))
				local var_12_6 = false
				
				for iter_12_2, iter_12_3 in pairs(var_12_4) do
					if iter_12_3.is_rewardable then
						var_12_6 = true
						
						break
					end
				end
				
				if_set_visible(iter_12_1.control, "icon_noti", var_12_6)
			end
		end
	end
end

function DungeonMaze.updateFloorInfo(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.scrollview:getInnerContainerPosition().y
	
	if not arg_13_1 and arg_13_0.vars.scroll_pos == var_13_0 then
		return 
	end
	
	arg_13_0.vars.scroll_pos = var_13_0
	arg_13_0.vars.f_floor = arg_13_0.vars.part_count - ((0 - var_13_0) / (arg_13_0.vars.view_height / (arg_13_0.vars.part_count + 1)) + 1) + 1
	arg_13_0.vars.f_floor = math.max(1, math.min(arg_13_0.vars.f_floor, arg_13_0.vars.part_count))
	arg_13_0.vars.i_floor = math.floor(arg_13_0.vars.f_floor + 0.5)
	
	arg_13_0.vars.floor_info_node:setPositionY((arg_13_0.vars.f_floor - arg_13_0.vars.i_floor) * arg_13_0.vars.part_offset)
	
	local var_13_1 = SAVE:getKeep(string.format("maze_keep_stage:%s", arg_13_0.vars.id))
	
	if var_13_1 then
		if ContentDisable:byAlias("mazehellchallenge") then
			SAVE:setKeep(string.format("maze_keep_stage:%s", arg_13_0.vars.id), nil)
			
			arg_13_0.vars.i_floor = 1
		else
			arg_13_0.vars.i_floor = var_13_1
		end
	end
	
	local var_13_2
	
	for iter_13_0 = -3, 3 do
		local var_13_3 = iter_13_0 + arg_13_0.vars.i_floor
		local var_13_4 = arg_13_0.vars.floor_info_node:getChildByName("F" .. iter_13_0)
		
		var_13_4.guide_tag = tostring(var_13_3)
		
		if var_13_3 < 1 or var_13_3 > arg_13_0.vars.part_count then
			var_13_4:setVisible(false)
		else
			var_13_4:setVisible(true)
			
			local var_13_5 = arg_13_0.vars.floors[var_13_3]
			
			if var_13_4.floor ~= var_13_3 then
				var_13_4.floor = var_13_3
				
				if string.starts(var_13_5.id, "bmznet") then
					if_set(var_13_4, "floor", T(var_13_5.name2))
				else
					if_set(var_13_4, "floor", T("ui_dungeon_maze_floorinfo_floortext", {
						floor = var_13_3
					}))
				end
				
				local var_13_6 = var_13_4:getChildByName("floor")
				local var_13_7 = var_13_4:getChildByName("desc")
				local var_13_8 = math.floor(var_13_5.score)
				
				if_set_visible(var_13_4, "n_completed", var_13_8 >= 100)
				var_13_7:setVisible(false)
				
				if var_13_5.isLock then
					var_13_7:setOpacity(40)
					var_13_7:setString(T("ui_dungeon_maze_floorinfo_desc2"))
					if_set_visible(var_13_4, "n_locked", true)
					if_set_visible(var_13_4, "desc", false)
				else
					var_13_7:setOpacity(100)
					
					if var_13_8 < 100 then
						var_13_7:setString(T("ui_dungeon_maze_floorinfo_desc1", {
							rate = var_13_8
						}))
						var_13_7:setVisible(true)
					end
					
					if_set_visible(var_13_4, "n_locked", false)
				end
				
				if var_13_5.c_type and var_13_5.c_type == "raid" then
					var_13_6:setString(T(var_13_5.name))
				end
			end
			
			local var_13_9 = var_13_5.score
		end
	end
	
	GrowthGuideNavigator:proc()
	
	if arg_13_1 or arg_13_0.vars.i_floor ~= arg_13_0.vars.prev_i_floor then
		arg_13_0.vars.prev_i_floor = arg_13_0.vars.i_floor
		
		arg_13_0:onChangeFloor(arg_13_0.vars.i_floor)
	end
end

function DungeonMaze.refreshButtonEnterInfo(arg_14_0)
	if not arg_14_0.vars.floors then
		return 
	end
	
	if not arg_14_0.vars.i_floor then
		return 
	end
	
	if not arg_14_0.vars.wnd or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("btn_go")
	
	return UIUtil:setButtonEnterInfo(var_14_0, arg_14_0.vars.floors[arg_14_0.vars.i_floor].id)
end

function DungeonMaze.getGoldChestItems(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {}
	local var_15_1 = DB("level_enter", arg_15_1, {
		"show_box_reward_id"
	})
	
	if not var_15_1 or var_15_1 == "" then
		return 
	end
	
	local var_15_2 = totable(var_15_1)
	
	for iter_15_0, iter_15_1 in pairs(var_15_2) do
		var_15_0[iter_15_0] = iter_15_1
	end
	
	local var_15_3 = Account:getClearEvent(arg_15_1) or {}
	
	for iter_15_2, iter_15_3 in pairs(var_15_3) do
		local var_15_4 = string.sub(iter_15_2, 1, #iter_15_2 - 2)
		
		if var_15_0[var_15_4] then
			var_15_0[var_15_4].already = true
		end
	end
	
	if arg_15_2 then
		for iter_15_4, iter_15_5 in pairs(var_15_0) do
			for iter_15_6, iter_15_7 in pairs(arg_15_2:getCompletedRoadEvent()) do
				if string.starts(iter_15_6 or "", iter_15_4) and arg_15_2:isFirstCompletedRoadEvent(iter_15_6) then
					iter_15_5.is_first_clear = true
				end
			end
		end
	end
	
	local var_15_5 = {}
	
	for iter_15_8, iter_15_9 in pairs(var_15_0) do
		local var_15_6
		
		if Account:isCurrencyType(iter_15_9[1]) or string.starts(iter_15_9[1], "ma_") then
			var_15_6 = {
				iter_15_9[1],
				iter_15_9[2],
				golden = true,
				already = iter_15_9.already,
				is_first_clear = iter_15_9.is_first_clear
			}
		else
			var_15_6 = {
				iter_15_9[1],
				iter_15_9[2],
				iter_15_9[3],
				"grade" .. iter_15_9[4],
				golden = true,
				already = iter_15_9.already,
				is_first_clear = iter_15_9.is_first_clear
			}
		end
		
		table.push(var_15_5, var_15_6)
	end
	
	return var_15_5
end

function DungeonMaze.isGoldBoxReward(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0:getGoldChestItems(arg_16_2)
	
	for iter_16_0, iter_16_1 in pairs(var_16_0 or {}) do
		if arg_16_1 == iter_16_1[1] then
			return true
		end
	end
end

function DungeonMaze.getRaidResetTime(arg_17_0, arg_17_1)
	local var_17_0 = DB("level_enter", arg_17_1, {
		"reset_term"
	})
	local var_17_1 = 0
	
	if var_17_0 then
		if var_17_0 == "week" then
			local var_17_2, var_17_3, var_17_4 = Account:serverTimeWeekLocalDetail()
			
			var_17_1 = var_17_4 - (GAME_STATIC_VARIABLE.raid_week_break_time or 5) * 3600 - os.time()
		elseif var_17_0 == "month" then
			local var_17_5, var_17_6, var_17_7 = Account:serverTimeMonthInfo()
			
			var_17_1 = var_17_6 - (GAME_STATIC_VARIABLE.raid_month_break_time or 5) * 3600 - os.time()
		elseif var_17_0 == "day" then
			local var_17_8, var_17_9, var_17_10 = Account:serverTimeDayLocalDetail()
			local var_17_11 = (GAME_STATIC_VARIABLE.raid_day_break_time or 5) * 3600
			
			var_17_1 = end_time - var_17_11 - os.time()
		end
	end
	
	return var_17_1
end

function DungeonMaze.onChangeFloor(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not arg_18_0.vars.wnd then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.floors[arg_18_1]
	
	if var_18_0.score > 100 then
		var_18_0.score = 100
	end
	
	local var_18_1, var_18_2, var_18_3, var_18_4 = DB("level_enter", var_18_0.id, {
		"name",
		"mission1",
		"desc",
		"reset_term"
	})
	
	if_set(arg_18_0.vars.wnd, "label_desc", T(var_18_3))
	if_set(arg_18_0.vars.wnd, "label_title", T(var_18_1))
	
	if var_18_0.c_type and var_18_0.c_type == "raid" and var_18_4 then
		if_set_visible(arg_18_0.vars.wnd, "n_reset_time", true)
		
		local var_18_5 = arg_18_0:getRaidResetTime(var_18_0.id)
		
		if var_18_5 > 0 then
			if_set(arg_18_0.vars.wnd, "raid_remain", sec_to_full_string(var_18_5))
		else
			if_set(arg_18_0.vars.wnd, "raid_remain", T("ui_raid_break_time"))
		end
		
		if var_18_0.disabled then
			balloon_message_with_sound("raid_visible_error")
		end
	else
		if_set_visible(arg_18_0.vars.wnd, "n_reset_time", false)
	end
	
	local var_18_6 = false
	
	if not var_18_0.reward_info_1 and not var_18_0.reward_info_2 then
		if_set_visible(arg_18_0.vars.wnd, "reward1", false)
		
		var_18_6 = true
	else
		local var_18_7 = arg_18_0.vars.wnd:getChildByName("reward1")
		
		if get_cocos_refid(var_18_7) then
			var_18_7:setVisible(true)
			if_set_percent(var_18_7, "exp_gauge", var_18_0.score / 100)
			if_set(var_18_7, "txt_floor_exp", T("maze_rate_now", {
				rate = math.floor(var_18_0.score)
			}))
		end
		
		local var_18_8 = false
		local var_18_9 = Account:getExplore(var_18_0.id)
		local var_18_10 = Account:getExploreRewardStep(var_18_0.id)
		
		for iter_18_0 = 1, 2 do
			local var_18_11 = arg_18_0.vars.wnd:getChildByName("n_reward_item_" .. iter_18_0 * 50)
			
			var_18_11:removeAllChildren()
			
			if var_18_0.reward_info_1 and get_cocos_refid(var_18_11) then
				local var_18_12 = var_18_0["reward_info_" .. iter_18_0]
				local var_18_13 = UIUtil:getRewardIcon(var_18_12.count, var_18_12.code, {
					show_small_count = true,
					no_hero_name = true,
					detail = true,
					parent = var_18_11,
					grade_rate = var_18_12.grade_rate,
					set_drop = var_18_12.set_id
				})
				
				if var_18_9 >= iter_18_0 * 50 then
					if var_18_10 < iter_18_0 then
						local var_18_14 = EffectManager:Play({
							scale = 1,
							z = 99999,
							fn = "ui_pvp_allreward.cfx",
							y = 0,
							x = 0,
							layer = var_18_11
						})
						
						var_18_8 = true
					elseif get_cocos_refid(var_18_13) then
						var_18_13:setOpacity(76)
						if_set_visible(var_18_13, "icon_checked", true)
					end
				end
			end
		end
		
		if_set_visible(arg_18_0.vars.wnd, "btn_reward_progress", var_18_8)
	end
	
	if_set(arg_18_0.vars.wnd, "txt_floor_score", T("maze_prize", {
		name = T(var_18_0.name)
	}))
	
	local var_18_15 = arg_18_0.vars.wnd:getChildByName("btn_go")
	
	if get_cocos_refid(var_18_15) then
		if_set(var_18_15, "txt_go", T("ui_dungeon_maze_btngo_txt_go"))
		
		arg_18_0.vars.enterable = arg_18_0:refreshButtonEnterInfo()
		
		local var_18_16, var_18_17 = DB("item_token", var_18_0.point_type, {
			"type",
			"icon"
		})
		
		if_set_sprite(var_18_15, "icon_res", var_18_17 .. ".png")
		UIUtil:changeButtonState(var_18_15, not var_18_0.disabled and not var_18_0.isLock, true)
	end
	
	local var_18_18 = DB("level_enter", arg_18_0.vars.floors[arg_18_1].id, {
		"show_reward_id"
	})
	local var_18_19 = string.split(var_18_18 or "", ";")
	local var_18_20 = arg_18_0:getGoldChestItems(arg_18_0.vars.floors[arg_18_1].id) or {}
	
	for iter_18_1 = 1, 40 do
		local var_18_21, var_18_22, var_18_23, var_18_24 = DB("level_enter_drops", arg_18_0.vars.floors[arg_18_1].id, {
			"item" .. iter_18_1,
			"type" .. iter_18_1,
			"set" .. iter_18_1,
			"grade_rate" .. iter_18_1
		})
		
		if var_18_21 and table.isInclude(var_18_19, function(arg_19_0, arg_19_1)
			if arg_19_1 == var_18_21 then
				return true
			end
		end) then
			table.push(var_18_20, {
				var_18_21,
				var_18_22,
				var_18_23,
				var_18_24
			})
		end
	end
	
	local var_18_25 = UIUtil:sortDisplayItems(var_18_20, var_18_0.id)
	local var_18_26 = {}
	
	copy_functions(ScrollView, var_18_26)
	
	function var_18_26.getScrollViewItem(arg_20_0, arg_20_1)
		local var_20_0 = {
			scale = 0.8,
			grade_max = true,
			set_drop = arg_20_1[3],
			grade_rate = arg_20_1[4]
		}
		
		if arg_20_1.golden then
			var_20_0.reward_info = {}
			
			if arg_20_1.already then
				var_20_0.reward_info.goldbox_reward_owned = true
			else
				var_20_0.reward_info.goldbox_reward = true
			end
		end
		
		local var_20_1
		
		if arg_20_1.golden and Account:isCurrencyType(arg_20_1[1]) then
			var_20_1 = arg_20_1[2]
		end
		
		local var_20_2 = UIUtil:getRewardIcon(var_20_1, arg_20_1[1], var_20_0)
		
		IconUtil.setIcon(var_20_2).addGoldBox(arg_20_1.golden, arg_20_1.already ~= nil and tocolor("#888888") or tocolor("#ffffff"), arg_20_1.already).done()
		if_set(var_20_2, "txt_small_count", var_20_1)
		
		return var_20_2
	end
	
	function var_18_26.onSelectScrollViewItem(arg_21_0, arg_21_1, arg_21_2)
	end
	
	local var_18_27 = arg_18_0.vars.wnd:getChildByName("scroll_view")
	
	var_18_27:removeAllChildren()
	var_18_26:initScrollView(var_18_27, 80, 80, {
		skip_anchor = true
	})
	var_18_26:createScrollViewItems(var_18_25)
	
	if var_18_0.c_type and var_18_0.c_type == "raid" then
		local var_18_28 = DB("level_first_clear", var_18_0.id, "id") ~= nil
		
		if_set_visible(arg_18_0.vars.wnd, "btn_reward", var_18_28)
		TopBarNew:checkhelpbuttonID("infoznet")
		
		local var_18_29 = arg_18_0.vars.wnd:getChildByName("n_reset_time")
		
		if get_cocos_refid(var_18_29) then
			if not var_18_29.origin_x then
				var_18_29.origin_x = var_18_29:getPositionX()
			end
			
			if not var_18_29.origin_y then
				var_18_29.origin_y = var_18_29:getPositionY()
			end
			
			if not var_18_28 then
				local var_18_30 = arg_18_0.vars.wnd:getChildByName("btn_reward")
				local var_18_31 = arg_18_0.vars.wnd:getChildByName("btn_go_shop")
				
				if get_cocos_refid(var_18_30) and get_cocos_refid(var_18_31) then
					local var_18_32 = var_18_31:getPositionY() - var_18_30:getPositionY()
					
					var_18_29:setPosition(var_18_29.origin_x, var_18_29.origin_y + var_18_32)
				end
			else
				var_18_29:setPosition(var_18_29.origin_x, var_18_29.origin_y)
			end
		end
	else
		if_set_visible(arg_18_0.vars.wnd, "btn_reward", false)
		TopBarNew:checkhelpbuttonID("infolaby")
	end
	
	local var_18_33
	local var_18_34, var_18_35 = DB("level_battlemenu_dungeon", tostring(arg_18_0.vars.id), {
		"hell_image",
		"hell_enter_key"
	})
	
	if var_18_35 and var_18_34 then
		local var_18_36 = totable(var_18_35)
		
		for iter_18_2, iter_18_3 in pairs(var_18_36) do
			if var_18_0.id == iter_18_3 then
				var_18_33 = iter_18_2
			end
		end
		
		local var_18_37 = totable(var_18_34)[var_18_33]
		
		if var_18_37 then
			local var_18_38 = arg_18_0.vars.wnd:getParent()
			
			arg_18_0:makeBG(var_18_38, var_18_37)
		end
	end
	
	local var_18_39 = arg_18_0.vars.wnd:getChildByName("n_change")
	local var_18_40 = arg_18_0.vars.wnd:getChildByName("btn_change_difficulty")
	
	if var_18_33 == "challange" then
		if_set_color(arg_18_0.vars.wnd, "g_tint", tocolor("#250647"))
		
		if get_cocos_refid(var_18_39) then
			if_set_visible(var_18_39, "label_info", false)
		end
		
		if get_cocos_refid(var_18_40) then
			if_set(var_18_40, "label", T("ui_btn_challenge_mode_return"))
		end
	else
		if_set_color(arg_18_0.vars.wnd, "g_tint", tocolor("#000000"))
		
		if get_cocos_refid(var_18_39) then
			if_set_visible(var_18_39, "label_info", true)
		end
		
		if get_cocos_refid(var_18_40) then
			if_set(var_18_40, "label", T("ui_btn_challenge_mode"))
		end
	end
	
	local var_18_41 = arg_18_0.vars.wnd:getChildByName("label_desc")
	
	if get_cocos_refid(var_18_41) then
		if not var_18_41.origin_x then
			var_18_41.origin_x = var_18_41:getPositionX()
		end
		
		if not var_18_41.origin_y then
			var_18_41.origin_y = var_18_41:getPositionY()
		end
		
		if var_18_6 then
			local var_18_42 = arg_18_0.vars.wnd:getChildByName("n_label_desc_move")
			
			if get_cocos_refid(var_18_42) then
				var_18_41:setPosition(var_18_42:getPositionX(), var_18_42:getPositionY())
			end
		else
			var_18_41:setPosition(var_18_41.origin_x, var_18_41.origin_y)
		end
	end
	
	local var_18_43 = arg_18_0.vars.wnd:getChildByName("n_bottom")
	
	if get_cocos_refid(var_18_43) then
		if not var_18_43.origin_x then
			var_18_43.origin_x = var_18_43:getPositionX()
		end
		
		if not var_18_43.origin_y then
			var_18_43.origin_y = var_18_43:getPositionY()
		end
		
		if var_18_6 then
			local var_18_44 = arg_18_0.vars.wnd:getChildByName("n_bottom_move")
			
			if get_cocos_refid(var_18_44) then
				var_18_43:setPosition(var_18_44:getPositionX(), var_18_44:getPositionY())
			end
		else
			var_18_43:setPosition(var_18_43.origin_x, var_18_43.origin_y)
		end
	end
	
	if get_cocos_refid(var_18_27) then
		local var_18_45 = var_18_27:getContentSize()
		
		if not var_18_27.origin_width then
			var_18_27.origin_width = var_18_45.width
		end
		
		if not var_18_27.origin_height then
			var_18_27.origin_height = var_18_45.height
		end
		
		if var_18_6 then
			var_18_27:setContentSize(var_18_27.origin_width, 283)
		else
			var_18_27:setContentSize(var_18_27.origin_width, var_18_27.origin_height)
		end
	end
end

function DungeonMaze.GetMazeList(arg_22_0, arg_22_1)
	local var_22_0 = {}
	
	arg_22_1 = arg_22_1 or "dije"
	
	local var_22_1 = 0
	local var_22_2 = 1
	local var_22_3
	
	if type(arg_22_1) == "table" then
		var_22_3 = {}
		
		local var_22_4 = {
			challange = 2,
			hell = 1
		}
		
		for iter_22_0, iter_22_1 in pairs(arg_22_1) do
			if var_22_4[iter_22_0] then
				table.insert(var_22_3, var_22_4[iter_22_0], iter_22_1)
			else
				table.insert(var_22_3, iter_22_1)
			end
		end
	elseif to_n(string.sub(arg_22_1, -3, -1)) > 0 then
		var_22_3 = {
			arg_22_1
		}
	end
	
	local function var_22_5(arg_23_0)
		local var_23_0 = {
			missions = {}
		}
		
		var_23_0.id, var_23_0.name, var_23_0.name2, var_23_0.type, var_23_0.c_type, var_23_0.missions[1], var_23_0.missions[2], var_23_0.missions[3], var_23_0.missions[4], var_23_0.point_type, var_23_0.point = DB("level_enter", arg_23_0, {
			"id",
			"name",
			"name2",
			"type",
			"contents_type",
			"mission1",
			"mission2",
			"mission3",
			"mission4",
			"type_enterpoint",
			"use_enterpoint"
		})
		
		if not var_23_0.id or not string.starts(var_23_0.type, "dungeon") then
			return 
		end
		
		if not Account:checkEnterMap(var_23_0.id) then
			var_23_0.isLock = true
		end
		
		var_23_0.score = Account:getExplore(arg_23_0)
		
		if var_23_0.c_type == "raid" then
			if ContentDisable:byAlias("raid_maze_2") then
				var_23_0.disabled = true
			end
		elseif ContentDisable:byAlias("raid_maze_1") then
			var_23_0.disabled = true
		end
		
		if arg_23_0 == "bmznet003" and ContentDisable:byAlias("mazehellchallenge") then
			var_23_0.disabled = true
		end
		
		local var_23_1 = DBT("achievement_maze_reward", var_23_0.id, {
			"id",
			"reward_id1",
			"reward_count1",
			"grade_rate1",
			"set_drop_rate_id1",
			"reward_id2",
			"reward_count2",
			"grade_rate2",
			"set_drop_rate_id2"
		})
		
		if var_23_1.id then
			var_23_0.reward_info_1 = {
				code = var_23_1.reward_id1,
				count = var_23_1.reward_count1,
				grade_rate = var_23_1.grade_rate1,
				set_id = var_23_1.set_drop_rate_id1
			}
			var_23_0.reward_info_2 = {
				code = var_23_1.reward_id2,
				count = var_23_1.reward_count2,
				grade_rate = var_23_1.grade_rate2,
				set_id = var_23_1.set_drop_rate_id2
			}
		end
		
		if not ContentDisable:byAlias(var_23_0.id) then
			var_22_1 = var_22_1 + var_23_0.score
			
			table.push(var_22_0, var_23_0)
		end
		
		local var_23_2 = Account:getExplore(var_23_0.id)
		local var_23_3 = Account:getExploreRewardStep(var_23_0.id)
		local var_23_4 = false
		
		for iter_23_0 = 1, 2 do
			if var_23_0["reward_info_" .. iter_23_0] and var_23_2 >= iter_23_0 * 50 and var_23_3 < iter_23_0 then
				var_23_4 = true
				
				break
			end
		end
		
		var_23_0.is_rewardable = var_23_4
	end
	
	local var_22_6
	
	if var_22_3 then
		for iter_22_2, iter_22_3 in pairs(var_22_3) do
			var_22_5(iter_22_3)
		end
	else
		var_22_6 = arg_22_1
		
		for iter_22_4 = var_22_2, var_22_2 + 999 do
			var_22_5(string.format("%s%03d", var_22_6, iter_22_4))
		end
	end
	
	return var_22_0, var_22_1
end

local function var_0_0(arg_24_0, arg_24_1)
	DungeonMaze:onScroll()
end

function DungeonMaze.createScene(arg_25_0)
	arg_25_0:updateFloorInfo()
	
	local var_25_0
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.floors) do
		local var_25_1 = math.clamp(to_n(iter_25_1.score), 0, 100)
		
		if iter_25_1.c_type == "raid" then
			var_25_0 = arg_25_0.vars.i_floor
			
			break
		end
		
		if iter_25_1.isLock then
			break
		elseif var_25_1 < 100 then
			var_25_0 = iter_25_0
			
			break
		end
		
		var_25_0 = iter_25_0
	end
	
	if var_25_0 then
		arg_25_0.vars.i_floor = var_25_0
	else
		arg_25_0.vars.i_floor = table.count(arg_25_0.vars.floors)
	end
	
	arg_25_0:moveToFloor(arg_25_0.vars.i_floor)
	arg_25_0:onChangeFloor(arg_25_0.vars.i_floor)
	UIAction:Add(SEQ(LOG(FADE_IN(500))), arg_25_0.vars.wnd, "block")
end

function DungeonMaze.makeBG(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if get_cocos_refid(arg_26_0.vars.back_spr) then
		if arg_26_0.vars.back_spr:getName() == arg_26_2 then
			return 
		end
		
		arg_26_0.vars.back_spr:removeFromParent()
	end
	
	local var_26_0 = cc.Sprite:create("map/" .. arg_26_2 .. ".png")
	
	if get_cocos_refid(var_26_0) then
		var_26_0:setName(arg_26_2)
		arg_26_1:addChild(var_26_0)
		var_26_0:setLocalZOrder(4)
		var_26_0:setAnchorPoint(0.5, 0.5)
		var_26_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_26_0:setScale(2)
		
		arg_26_0.vars.back_spr = var_26_0
		
		if arg_26_3 then
			local var_26_1 = CACHE:getEffect(arg_26_3 .. ".scsp")
			
			var_26_1:setScaleFactor(1)
			var_26_1:setPosition(var_26_0:getContentSize().width / 2, var_26_0:getContentSize().height / 2)
			var_26_1:setAnchorPoint(0.5, 0.5)
			var_26_1:setAnimation(0, "animation", true)
			var_26_0:addChild(var_26_1)
		end
	end
end

function DungeonMaze.onEnter(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_2 = arg_27_2 or {}
	
	EffectManager:Play({
		fn = "stagechange_cloud.cfx",
		delay = 0,
		pivot_z = 99998,
		layer = SceneManager:getRunningNativeScene(),
		pivot_x = VIEW_WIDTH / 2 + 90,
		pivot_y = VIEW_HEIGHT / 2
	})
	
	if arg_27_2.name and DB("level_maze_story_cleanup", arg_27_2.name, "id") and Account:getUserConfigsHash("maze_renewal", arg_27_2.name) == nil then
		query("dungeon_maze_story_cleanup", {
			list_id = arg_27_2.name
		})
	end
	
	if arg_27_0.vars == nil then
		arg_27_0:create(arg_27_1)
	else
		arg_27_0.vars.scroll_pos = nil
	end
	
	local var_27_0, var_27_1, var_27_2, var_27_3, var_27_4, var_27_5, var_27_6, var_27_7 = DB("level_battlemenu_dungeon", tostring(arg_27_2.id or 1), {
		"name",
		"desc",
		"mission_id",
		"image",
		"effect",
		"key_enter",
		"hell_image",
		"hell_enter_key"
	})
	
	arg_27_0.vars.floors, arg_27_0.vars.total_score = arg_27_0:GetMazeList(var_27_5 or totable(var_27_7))
	arg_27_0.vars.part_offset = 103
	arg_27_0.vars.part_count = #arg_27_0.vars.floors
	arg_27_0.vars.view_height = arg_27_0.vars.part_offset * (arg_27_0.vars.part_count + 1)
	
	arg_27_0:makeBG(arg_27_1, var_27_3 or totable(var_27_6).hell, var_27_4)
	
	if not arg_27_0.vars.wnd then
		arg_27_0.vars.wnd = load_dlg("dungeon_maze", true, "wnd")
		
		arg_27_1:addChild(arg_27_0.vars.wnd)
	end
	
	if arg_27_0.vars.is_worldmap_mode then
		arg_27_0.vars.wnd:setLocalZOrder(5)
	end
	
	if_set(arg_27_0.vars.wnd, "desc_0", T(var_27_0))
	if_set(arg_27_0.vars.wnd, "txt_title", T("ui_dungeon_maze_txt_title", {
		name = T(var_27_0)
	}))
	if_set(arg_27_0.vars.wnd, "txt_desc", arg_27_3.desc)
	
	local var_27_8 = math.floor(arg_27_0.vars.total_score / #arg_27_0.vars.floors)
	
	arg_27_0.vars.wnd:getChildByName("total_exp_gauge"):setPercent(var_27_8)
	if_set(arg_27_0.vars.wnd:getChildByName("n_progress"), "txt_exp", T("maze_rate_total", {
		rate = math.floor(var_27_8)
	}))
	
	arg_27_0.vars.scrollview = arg_27_0.vars.wnd:getChildByName("scrollview")
	
	arg_27_0.vars.scrollview:setInnerContainerSize({
		width = arg_27_0.vars.scrollview:getContentSize().width,
		height = arg_27_0.vars.view_height + arg_27_0.vars.part_offset * 5
	})
	arg_27_0.vars.scrollview:setScrollStep(arg_27_0.vars.part_offset)
	
	arg_27_0.vars.floor_info_node = arg_27_0.vars.wnd:getChildByName("floor_info")
	arg_27_0.vars.floor_info_node.guide_tag = tostring(arg_27_2.id or 1)
	
	arg_27_0.vars.scrollview:setScrollSpeed(7)
	
	if arg_27_0.vars.scrollview.setMovementFactor then
		arg_27_0.vars.scrollview:setMovementFactor(0.1)
	end
	
	if get_cocos_refid(arg_27_0.vars.listener) then
		arg_27_0:removeScrollEventListener(arg_27_0.vars.scrollview)
	end
	
	local var_27_9 = arg_27_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_27_9) then
		arg_27_0.vars.listener = cc.EventListenerTouchOneByOne:create()
		
		arg_27_0.vars.listener:registerScriptHandler(function(arg_28_0, arg_28_1)
			return arg_27_0:onTouchDown(arg_28_0, arg_28_1)
		end, cc.Handler.EVENT_TOUCH_BEGAN)
		arg_27_0.vars.listener:registerScriptHandler(function(arg_29_0, arg_29_1)
			return arg_27_0:onTouchUp(arg_29_0, arg_29_1)
		end, cc.Handler.EVENT_TOUCH_ENDED)
		arg_27_0.vars.listener:registerScriptHandler(function(arg_30_0, arg_30_1)
			return arg_27_0:onTouchMove(arg_30_0, arg_30_1)
		end, cc.Handler.EVENT_TOUCH_MOVED)
		
		local var_27_10 = cc.Node:create()
		
		var_27_10:setName("priority_node")
		arg_27_0.vars.scrollview:addChild(var_27_10)
		var_27_9:addEventListenerWithSceneGraphPriority(arg_27_0.vars.listener, var_27_10)
	end
	
	local var_27_11 = arg_27_0.vars.wnd:getChildByName("LEFT")
	local var_27_12 = arg_27_0.vars.wnd:getChildByName("RIGHT")
	local var_27_13 = arg_27_0.vars.wnd:getChildByName("CENTER")
	
	arg_27_0.vars.wnd:getChildByName("n_area"):setVisible(not var_27_7)
	if_set_visible(arg_27_0.vars.wnd, "n_change", var_27_7 ~= nil)
	
	if var_27_7 then
		local var_27_14 = totable(var_27_7)
	else
		arg_27_0.vars.scrollview:addEventListener(var_0_0)
	end
	
	if not arg_27_2.enter then
		var_27_11:setPositionX(-400)
		var_27_12:setPositionX(VIEW_BASE_RIGHT + 600)
		var_27_13:setPositionY(-200)
		UIAction:Add(SEQ(DELAY(500), LOG(MOVE_TO(250, 0))), var_27_11, "block")
		UIAction:Add(SEQ(DELAY(500), LOG(MOVE_TO(250, VIEW_BASE_RIGHT + NotchStatus:getNotchSafeRight()))), var_27_12, "block")
		UIAction:Add(SEQ(DELAY(500), LOG(MOVE_TO(250, nil, 0))), var_27_13, "block")
	elseif arg_27_2.enter_info and arg_27_2.enter_info.show_ready_dialog and arg_27_2.enter_info.floor then
		arg_27_0.vars.i_floor = arg_27_2.enter_info.floor
	end
	
	if_set_opacity(arg_27_0.vars.wnd, nil, 0)
	
	arg_27_0.vars.id = arg_27_2.id
	
	arg_27_0:createScene()
	arg_27_0:checkNew()
	DungeonList:visibleOffIconNew("Maze")
end

function DungeonMaze.onTouchDown(arg_31_0, arg_31_1, arg_31_2)
	if UIAction:Find("block") then
		return false
	end
	
	arg_31_0.vars.touchdown_dirty = arg_31_1:getLocation()
	
	return true
end

function DungeonMaze.onTouchMove(arg_32_0, arg_32_1, arg_32_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_32_0.vars.touchdown_dirty then
		return 
	end
	
	if math.abs(arg_32_0.vars.touchdown_dirty.x - arg_32_1:getLocation().x) > DESIGN_HEIGHT * 0.03 or math.abs(arg_32_0.vars.touchdown_dirty.y - arg_32_1:getLocation().y) > DESIGN_HEIGHT * 0.03 then
		arg_32_0.vars.touchdown_dirty = nil
	end
	
	return true
end

function DungeonMaze.onTouchUp(arg_33_0, arg_33_1, arg_33_2)
	if UIAction:Find("block") then
		return false
	end
	
	if DungeonCommon:isOverlapped() then
		return 
	end
	
	local var_33_0
	
	if arg_33_0.vars.touchdown_dirty and get_cocos_refid(arg_33_0.vars.floor_info_node) then
		var_33_0 = arg_33_1:getLocation()
		
		for iter_33_0 = -3, 3 do
			local var_33_1 = iter_33_0 + arg_33_0.vars.i_floor
			local var_33_2 = arg_33_0.vars.i_floor or 99
			local var_33_3 = arg_33_0.vars.floor_info_node:getChildByName("F" .. iter_33_0)
			
			if var_33_1 < 1 or var_33_1 > arg_33_0.vars.part_count then
			elseif var_33_1 ~= var_33_2 then
				local var_33_4 = var_33_3:getChildByName("panel")
				
				if checkCollision(var_33_4, var_33_0.x, var_33_0.y) then
					arg_33_0:moveToFloor(var_33_1)
					arg_33_2:stopPropagation()
				end
			end
		end
	end
	
	return true
end

function DungeonMaze.removeScrollEventListener(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_34_0.vars.listener) then
		return 
	end
	
	if not get_cocos_refid(arg_34_0.vars.scrollview) then
		return 
	end
	
	local var_34_0 = arg_34_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_34_0) then
		var_34_0:removeEventListener(arg_34_0.vars.listener)
	end
	
	arg_34_0.vars.listener:setEnabled(false)
	
	arg_34_0.vars.listener = nil
end

function DungeonMaze.onLeave(arg_35_0)
	local var_35_0 = arg_35_0.vars.wnd:getChildByName("n_reset_time")
	
	if get_cocos_refid(var_35_0) and var_35_0:isVisible() then
		UIAction:Add(SPAWN(FADE_OUT(200), RLOG(MOVE_TO(250, -700))), var_35_0, "block")
	end
	
	local var_35_1 = arg_35_0.vars.wnd:getChildByName("btn_go_shop")
	
	if get_cocos_refid(var_35_1) and var_35_1:isVisible() then
		UIAction:Add(SPAWN(FADE_OUT(200), RLOG(MOVE_TO(250, -700))), var_35_1, "block")
	end
	
	local var_35_2 = arg_35_0.vars.wnd:getChildByName("btn_reward")
	
	if get_cocos_refid(var_35_2) and var_35_2:isVisible() then
		UIAction:Add(SPAWN(FADE_OUT(200), RLOG(MOVE_TO(250, -700))), var_35_2, "block")
	end
	
	local var_35_3 = arg_35_0.vars.wnd:getChildByName("LEFT")
	local var_35_4 = arg_35_0.vars.wnd:getChildByName("RIGHT")
	local var_35_5 = arg_35_0.vars.wnd:getChildByName("CENTER")
	
	UIAction:Add(RLOG(MOVE_TO(250, -700)), var_35_3, "block")
	UIAction:Add(RLOG(MOVE_TO(250, VIEW_BASE_RIGHT + 800)), var_35_4, "block")
	UIAction:Add(RLOG(MOVE_TO(250, nil, -200)), var_35_5, "block")
	UIAction:Add(SEQ(DELAY(250), REMOVE()), arg_35_0.vars.wnd, "block")
	
	arg_35_0.vars.wnd = nil
	
	if get_cocos_refid(arg_35_0.vars.back_spr) then
		arg_35_0.vars.back_spr:getParent():removeChild(arg_35_0.vars.back_spr)
	end
	
	arg_35_0:removeScrollEventListener()
end

function DungeonMaze.showReadyWnd(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.vars.floors[arg_36_0.vars.i_floor].id
	
	BattleReady:show({
		skip_intro = arg_36_1,
		enter_id = var_36_0,
		callback = arg_36_0,
		currencies = DungeonList:getCurrentCurrencies()
	})
	
	arg_36_0.vars.enter_id = var_36_0
	
	if not arg_36_0.vars.is_worldmap_mode then
		DungeonList.vars.enter_info = {
			show_ready_dialog = true,
			floor = arg_36_0.vars.i_floor
		}
	end
end

function DungeonMaze.ready(arg_37_0, arg_37_1)
	if arg_37_0.vars.floors[arg_37_0.vars.i_floor].isLock then
	end
	
	local var_37_0 = arg_37_0.vars.floors[arg_37_0.vars.i_floor].id
	
	if arg_37_0:isBreakTime(var_37_0) then
		return 
	end
	
	if DB("level_maze_link", var_37_0, "unit_once") == "y" then
		query("update_maze_link_units", {
			enter_id = var_37_0
		})
		
		return 
	end
	
	arg_37_0:showReadyWnd(arg_37_1)
end

function DungeonMaze.isBreakTime(arg_38_0, arg_38_1)
	local var_38_0 = DB("level_enter", arg_38_1, "reset_term")
	
	if var_38_0 then
		local var_38_1 = os.time()
		
		if var_38_0 == "week" then
			local var_38_2, var_38_3, var_38_4 = Account:serverTimeWeekLocalDetail()
			
			if var_38_1 >= var_38_4 - (GAME_STATIC_VARIABLE.raid_week_break_time or 5) * 3600 then
				Dialog:msgBox(T("msg_maze_enter_fail", timeToStringDef({
					preceding_with_zeros = true,
					time = var_38_4 + 1
				})))
				
				return true
			end
		elseif var_38_0 == "day" then
			local var_38_5, var_38_6, var_38_7 = Account:serverTimeDayLocalDetail()
			
			if var_38_1 >= var_38_7 - (GAME_STATIC_VARIABLE.raid_day_break_time or 5) * 3600 then
				Dialog:msgBox(T("msg_maze_enter_fail", timeToStringDef({
					preceding_with_zeros = true,
					time = var_38_7 + 1
				})))
				
				return true
			end
		elseif var_38_0 == "month" then
			local var_38_8, var_38_9, var_38_10 = Account:serverTimeMonthInfo()
			
			if var_38_1 >= var_38_9 - (GAME_STATIC_VARIABLE.raid_month_break_time or 5) * 3600 then
				Dialog:msgBox(T("msg_maze_enter_fail", timeToStringDef({
					preceding_with_zeros = true,
					time = var_38_9 + 1
				})))
				
				return true
			end
		end
	end
	
	return false
end

function DungeonMaze.showFloorLockMessage(arg_39_0)
	local var_39_0 = arg_39_0.vars.floors[arg_39_0.vars.i_floor]
	
	if var_39_0.c_type == "raid" and var_39_0.disabled then
		balloon_message_with_sound("raid_visible_error")
		
		return 
	end
	
	if var_39_0.isLock then
		local var_39_1 = DB("level_enter", var_39_0.id, "req_map_msg")
		
		balloon_message_with_sound(var_39_1)
	end
end

function DungeonMaze.getCurrentFloorInfo(arg_40_0)
	if not arg_40_0.vars then
		return 
	end
	
	if not arg_40_0.vars.floors or not arg_40_0.vars.i_floor then
		return 
	end
	
	return arg_40_0.vars.floors[arg_40_0.vars.i_floor]
end

function DungeonMaze.onStartBattle(arg_41_0, arg_41_1)
	arg_41_1 = arg_41_1 or {}
	
	startBattle(arg_41_1.enter_id, {
		play_continue = arg_41_1.play_continue
	})
end

function DungeonMaze.onCloseBattleReadyDialog(arg_42_0)
	if arg_42_0.vars.enter_id then
		BattleReady:hide()
		
		arg_42_0.vars.enter_id = nil
	end
end

function DungeonMaze.beginWorldMapMode(arg_43_0, arg_43_1, arg_43_2)
	arg_43_2 = arg_43_2 or {
		id = 1
	}
	arg_43_2.is_worldmap_mode = true
	arg_43_0.vars = {}
	arg_43_0.vars.is_worldmap_mode = arg_43_2.is_worldmap_mode
	
	arg_43_0:onEnter(arg_43_1, arg_43_2)
	
	if arg_43_0.vars.is_worldmap_mode then
		local var_43_0 = arg_43_0:getBackground()
		
		arg_43_0.vars.wnd:getChildByName("n_bg"):addChild(var_43_0)
	end
end

function DungeonMaze.getBackground(arg_44_0)
	local var_44_0 = cc.Layer:create()
	
	EffectManager:Play({
		pivot_y = 0,
		pivot_x = 0,
		fn = "ui_bg_maze.cfx",
		layer = var_44_0
	})
	
	return var_44_0
end

function DungeonMaze.moveToFloor(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	arg_45_3 = arg_45_3 or 2
	arg_45_1 = math.max(0, math.min(arg_45_0.vars.part_count, arg_45_1))
	
	local var_45_0 = (arg_45_1 - 1) * (100 / (arg_45_0.vars.part_count - 1))
	
	if arg_45_2 then
		arg_45_0.vars.scrollview:scrollToPercentVertical(var_45_0, arg_45_3, true)
	else
		arg_45_0.vars.scrollview:jumpToPercentVertical(var_45_0)
	end
end

function DungeonMaze.endWorldMapMode(arg_46_0)
	arg_46_0:onLeave()
end

function DungeonMaze.create(arg_47_0, arg_47_1)
	arg_47_0.vars = {}
	arg_47_0.vars.list = {}
	
	for iter_47_0 = 1, 99 do
		local var_47_0 = {
			id = tostring(iter_47_0)
		}
		
		var_47_0.name, var_47_0.desc, var_47_0.menu_img, var_47_0.event_banner, var_47_0.key_enter, var_47_0.hell_enter_key, var_47_0.sort = DB("level_battlemenu_dungeon", tostring(iter_47_0), {
			"name",
			"desc",
			"icon_battlemenu",
			"event_banner",
			"key_enter",
			"hell_enter_key",
			"sort"
		})
		
		if not var_47_0.name then
			break
		end
		
		local var_47_1, var_47_2 = DungeonMaze:GetMazeList(var_47_0.key_enter or totable(var_47_0.hell_enter_key))
		local var_47_3 = table.count(var_47_1)
		local var_47_4 = math.floor(var_47_2 / var_47_3)
		
		var_47_0.floors = var_47_1
		var_47_0.total_score = var_47_2
		
		table.push(arg_47_0.vars.list, var_47_0)
	end
	
	local function var_47_5(arg_48_0)
		local var_48_0 = arg_48_0.hell_enter_key ~= nil
		local var_48_1 = tonumber(arg_48_0.sort) or 999
		local var_48_2 = math.floor(arg_48_0.total_score / table.count(arg_48_0.floors))
		local var_48_3 = not UnlockSystem:isUnlockMaze(arg_48_0.id)
		local var_48_4 = 0
		
		if var_48_2 >= 100 then
			var_48_4 = 3
		end
		
		if var_48_3 then
			var_48_4 = 1
		end
		
		if var_48_0 then
			var_48_4 = 2
		end
		
		return var_48_4, var_48_1
	end
	
	table.sort(arg_47_0.vars.list, function(arg_49_0, arg_49_1)
		local var_49_0, var_49_1 = var_47_5(arg_49_0)
		local var_49_2, var_49_3 = var_47_5(arg_49_1)
		
		if var_49_0 < var_49_2 then
			return true
		end
		
		if var_49_2 < var_49_0 then
			return false
		end
		
		return var_49_1 < var_49_3
	end)
	DungeonMazeMain:initScrollView(arg_47_1:getChildByName("maze_scrollview"), 250, 204)
	DungeonMazeMain:createScrollViewItems(arg_47_0.vars.list)
	if_set_visible(arg_47_1, "bg_item2", true)
	if_set(arg_47_1, "label_maze", T("maze_now", {
		name = #arg_47_0.vars.list
	}))
	
	if not arg_47_0.vars.is_worldmap_mode then
		return arg_47_0:getBackground()
	end
end

function DungeonMaze.onScroll(arg_50_0)
	arg_50_0:updateFloorInfo()
end

function DungeonMaze.getSceneState(arg_51_0)
	if not arg_51_0.vars then
		return {}
	end
	
	return {
		id = arg_51_0.vars.id
	}
end

function DungeonMaze.getFirstDungeonControl(arg_52_0)
	return DungeonMazeMain.ScrollViewItems[1].control
end

function DungeonMaze.getDungeonControl(arg_53_0, arg_53_1)
	if DungeonMazeMain.ScrollViewItems and arg_53_1 <= #DungeonMazeMain.ScrollViewItems then
		return DungeonMazeMain.ScrollViewItems[arg_53_1].control
	end
end

function DungeonMaze.getControlAndIndexByID(arg_54_0, arg_54_1)
	for iter_54_0, iter_54_1 in pairs(DungeonMazeMain.ScrollViewItems) do
		if iter_54_1 and iter_54_1.item and tostring(iter_54_1.item.id) == tostring(arg_54_1) then
			return iter_54_1.control, iter_54_0
		end
	end
end

function DungeonMaze.scrollToIndex(arg_55_0, arg_55_1)
	if DungeonMazeMain.ScrollViewItems and arg_55_1 <= #DungeonMazeMain.ScrollViewItems then
		DungeonMazeMain:scrollToIndex(arg_55_1)
	end
end

function DungeonMaze.checkNew(arg_56_0)
	NewNotice:checkNew(NewNotice.ID.MAZE)
end

function DungeonMaze.isNew(arg_57_0)
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.MAZE) and NewNotice:isNew(NewNotice.ID.MAZE)
end

function DungeonMaze.CheckNotification(arg_58_0)
	local var_58_0 = Account:getCurrency("mazekey") > 0
	
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.MAZE) and var_58_0
end

function DungeonMaze.onGameEvent(arg_59_0, arg_59_1, arg_59_2)
	if not arg_59_0.vars then
		return 
	end
	
	if arg_59_1 == "shop_buy" or arg_59_1 == "read_mail" then
		arg_59_0:refreshButtonEnterInfo()
	end
end

MazeRaidRewards = {}

function HANDLER.dungeon_maze_reward(arg_60_0, arg_60_1)
	if arg_60_1 == "btn_close" then
		MazeRaidRewards:hide()
	end
end

function MazeRaidRewards.show(arg_61_0, arg_61_1, arg_61_2)
	arg_61_2 = arg_61_2 or {}
	arg_61_0.wnd = load_dlg("dungeon_maze_reward", true, "wnd")
	arg_61_0.map_id = arg_61_1
	arg_61_0.opts = arg_61_2
	arg_61_0.db_id = arg_61_0.opts.db_id or "level_first_clear"
	
	SceneManager:getRunningNativeScene():addChild(arg_61_0.wnd)
	BackButtonManager:push({
		check_id = "maze_raid_rewards",
		back_func = function()
			MazeRaidRewards:hide()
		end
	})
	arg_61_0:update()
end

function MazeRaidRewards.isShow(arg_63_0)
	return get_cocos_refid(arg_63_0.wnd)
end

function MazeRaidRewards.hide(arg_64_0)
	if get_cocos_refid(arg_64_0.wnd) then
		arg_64_0.wnd:removeFromParent()
	end
	
	arg_64_0.wnd = nil
	
	BackButtonManager:pop("maze_raid_rewards")
end

function MazeRaidRewards.update(arg_65_0)
	if not get_cocos_refid(arg_65_0.wnd) then
		return 
	end
	
	arg_65_0.item_data = {}
	
	local var_65_0 = arg_65_0.opts.col_list or {
		"mission_id_",
		"mission_target_",
		"target_level_",
		"reward_id_",
		"reward_count_",
		"grade_rate_",
		"set_drop_"
	}
	local var_65_1 = arg_65_0.opts.item_count or 5
	
	for iter_65_0 = 1, var_65_1 do
		local var_65_2 = {}
		
		for iter_65_1, iter_65_2 in pairs(var_65_0) do
			table.insert(var_65_2, iter_65_2 .. iter_65_0)
		end
		
		local var_65_3, var_65_4, var_65_5, var_65_6, var_65_7, var_65_8, var_65_9 = DB(arg_65_0.db_id, arg_65_0.map_id, var_65_2)
		
		table.insert(arg_65_0.item_data, {
			mission_id = var_65_3,
			mission_target = var_65_4,
			target_level = var_65_5,
			reward_id = var_65_6,
			reward_count = var_65_7,
			grade_rate = var_65_8,
			set_drop = var_65_9
		})
	end
	
	local var_65_10 = arg_65_0.wnd:getChildByName("listview")
	
	arg_65_0.itemView = ItemListView_v2:bindControl(var_65_10)
	
	local var_65_11 = load_control("wnd/dungeon_maze_reward_item.csb")
	
	if var_65_10.STRETCH_INFO then
		local var_65_12 = var_65_10:getContentSize()
		
		resetControlPosAndSize(var_65_11, var_65_12.width, var_65_10.STRETCH_INFO.width_prev)
	end
	
	local var_65_13 = arg_65_0.opts.list_updater or {
		onUpdate = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
			local var_66_0 = arg_66_1:getChildByName("reward_item")
			
			UIUtil:getRewardIcon(nil, arg_66_3.reward_id, {
				show_small_count = true,
				no_hero_name = true,
				detail = true,
				parent = var_66_0,
				count = arg_66_3.reward_count,
				set_drop = arg_66_3.set_drop,
				grade_rate = arg_66_3.grade_rate
			})
			
			local var_66_1 = arg_66_1:getChildByName("mob_icon")
			
			UIUtil:getRewardIcon(nil, arg_66_3.mission_target, {
				no_db_grade = true,
				hide_star = true,
				monster = true,
				hide_lv = true,
				scale = 1,
				parent = var_66_1,
				lv = arg_66_3.target_level
			})
			
			local var_66_2 = T(DB("character", arg_66_3.mission_target, "name"))
			
			if_set(arg_66_1, "t_name", var_66_2)
			
			local var_66_3 = ConditionContentsManager:isMissionCleared(arg_66_3.mission_id)
			
			if_set_visible(arg_66_1, "n_already", var_66_3)
			if_set_visible(arg_66_1, "txt", not var_66_3)
			arg_66_1:setColor(var_66_3 and cc.c3b(76, 76, 76) or cc.c3b(255, 255, 255))
			
			return arg_66_3.id
		end
	}
	
	arg_65_0.itemView:setRenderer(var_65_11, var_65_13)
	arg_65_0.itemView:removeAllChildren()
	arg_65_0.itemView:setDataSource(arg_65_0.item_data)
end
