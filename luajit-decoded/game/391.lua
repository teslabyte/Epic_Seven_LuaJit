SubstoryFestivalBoard = SubstoryFestivalBoard or {}

local var_0_0 = 9

function HANDLER.dungeon_story_request_renew(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_renew" then
		SubstoryFestivalBoard:queryRefresh(arg_1_0.slot_num)
	elseif arg_1_1 == "btn_cancel" then
		SubstoryFestivalBoard:onCloseRefreshMission()
	end
end

function HANDLER.dungeon_story_request_reward(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		Dialog:close("dungeon_story_request_reward")
	end
end

function HANDLER.dungeon_story_request_board_popup(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("dungeon_story_request_board_popup")
	end
end

function HANDLER.dungeon_story_request_board(arg_4_0, arg_4_1)
	if string.starts(arg_4_1, "btn_progress") then
		SubstoryFestivalBoard:onEventProgress(tonumber(arg_4_0.day))
	elseif arg_4_1 == "btn_renew" then
		SubstoryFestivalBoard:showRefreshMission(arg_4_0.slot_num)
	elseif arg_4_1 == "btn_complete" then
		SubstoryFestivalBoard:queryCompleteMission(arg_4_0.mission_id)
	elseif arg_4_1 == "btn_unknown" then
		SubstoryFestivalBoard:queryActiveMission(arg_4_0.mission_id)
	elseif arg_4_1 == "btn_move" then
		if not SubStoryFestival:isOpenEvent() then
			balloon_message_with_sound("fm_error_4")
			
			return 
		end
		
		if arg_4_0.path then
			SubstoryFestivalBoard:close()
			movetoPath(arg_4_0.path)
		end
	elseif arg_4_1 == "btn_reward" then
		SubstoryFestivalBoard:showRewardList()
	end
end

function MsgHandler.substory_festival_mission_refresh(arg_5_0)
	if arg_5_0.substory_id and arg_5_0.info and arg_5_0.change_index then
		Account:setSubStoryFestivals(arg_5_0.substory_id, arg_5_0.info)
		ConditionContentsManager:initSubStoryFestival(arg_5_0.substory_id)
		SubstoryFestivalBoard:updateRenewDlg()
	else
		Log.e("substory_festival_mission_refresh", "no_rtn_data")
	end
	
	if arg_5_0.result then
		Account:addReward(arg_5_0.result)
	end
end

function MsgHandler.substory_festival_mission_active(arg_6_0)
	if arg_6_0.substory_id and arg_6_0.info then
		SubstoryFestivalBoard:effectAndDelayedUpdate(SubstoryFestivalBoard:getIndexChanged(arg_6_0.info))
		Account:setSubStoryFestivals(arg_6_0.substory_id, arg_6_0.info)
		ConditionContentsManager:initSubStoryFestival(arg_6_0.substory_id)
		SubStoryFestival:onUpdateUI()
	else
		Log.e("substory_festival_mission_active", "no_rtn_data")
	end
end

function MsgHandler.substory_festival_misison_complete(arg_7_0)
	if arg_7_0.substory_id and arg_7_0.info and arg_7_0.rewards then
		SubstoryFestivalBoard:showRewardResult(arg_7_0.info, Account:addReward(arg_7_0.rewards, {
			single = true
		}))
		Account:setSubStoryFestivals(arg_7_0.substory_id, arg_7_0.info)
		SubstoryFestivalBoard:updateMissionUI()
		SubstoryFestivalBoard:updateProgressUI()
		SubStoryFestival:onUpdateUI()
	else
		Log.e("substory_festival_misison_complete", "no_rtn_data")
	end
end

function MsgHandler.substory_festival_progress_event(arg_8_0)
	if arg_8_0.substory_id and arg_8_0.info and arg_8_0.story_id then
		Account:setSubStoryFestivals(arg_8_0.substory_id, arg_8_0.info)
		SubstoryFestivalBoard:onPlayEvent(arg_8_0.story_id, function()
			SubstoryFestivalBoard:show()
		end)
	else
		Log.e("substory_festival_progress_event", "no_rtn_data")
	end
end

function SubstoryFestivalBoard.show(arg_10_0)
	arg_10_0.vars = {}
	arg_10_0.vars.info = SubstoryManager:getInfo()
	arg_10_0.vars.db = SubStoryFestival:getContentsDB()
	
	if arg_10_0:isDailyMissionCleared() and arg_10_0:isProgressEvent() then
		arg_10_0:queryProgressEvent(SubStoryFestival:getFestivalID())
		
		return 
	end
	
	arg_10_0.vars.wnd = Dialog:open("wnd/dungeon_story_request_board", arg_10_0, {
		use_backbutton = false
	})
	
	local var_10_0 = SceneManager:getRunningPopupScene()
	
	TopBarNew:createFromPopup(T("fm_board_btn"), arg_10_0.vars.wnd, function()
		arg_10_0:close()
	end)
	arg_10_0:updateProgressUI()
	arg_10_0:updateMissionUI()
	arg_10_0:updatePortrait()
	var_10_0:addChild(arg_10_0.vars.wnd)
	arg_10_0:fadeIn()
	
	if arg_10_0.vars.info.id == "vma1ba" then
		TutorialGuide:procGuide("tuto_vma1ba_description")
	end
end

function SubstoryFestivalBoard.fadeIn(arg_12_0)
	local var_12_0 = arg_12_0.vars.wnd
	local var_12_1 = var_12_0:getChildByName("n_pos")
	local var_12_2 = var_12_0:getChildByName("n_board")
	local var_12_3 = var_12_0:getChildByName("n_progress")
	local var_12_4, var_12_5 = var_12_1:getPosition()
	
	var_12_1:setOpacity(0)
	var_12_1:setPositionX(0)
	UIAction:Add(SEQ(MOVE_TO(250, var_12_4, var_12_5)), var_12_1, "block")
	UIAction:Add(SEQ(FADE_IN(150)), var_12_1, "block")
	
	local var_12_6, var_12_7 = var_12_3:getPosition()
	
	var_12_3:setPositionY(var_12_7 - 100)
	UIAction:Add(SEQ(MOVE_TO(250, var_12_6, var_12_7)), var_12_3, "block")
	var_12_2:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(200)), var_12_2, "block")
end

function SubstoryFestivalBoard.updateMissionUI(arg_13_0, arg_13_1)
	if not arg_13_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	if not arg_13_0.vars.info then
		return 
	end
	
	local var_13_0 = Account:getSubStoryFestivalInfo(arg_13_0.vars.info.id)
	local var_13_1 = arg_13_0.vars.wnd:getChildByName("n_board")
	
	for iter_13_0 = arg_13_1 or 1, arg_13_1 or 3 do
		local var_13_2 = var_13_1:getChildByName("n_mission" .. iter_13_0)
		local var_13_3 = iter_13_0 == 1
		
		if arg_13_0.vars["delayed" .. iter_13_0] then
		elseif get_cocos_refid(var_13_2) then
			local var_13_4 = var_13_0["mission_id" .. iter_13_0]
			
			if var_13_4 then
				local var_13_5 = DBT("substory_festival_mission", var_13_4, {
					"give_npc",
					"mission_area",
					"move_path",
					"difficulty",
					"mission_desc",
					"value",
					"reward_festival_point",
					"reward_item_type",
					"reward_item_value"
				})
				local var_13_6 = var_13_0["mission_state" .. iter_13_0]
				local var_13_7 = string.trim(var_13_5.value)
				local var_13_8 = totable(var_13_7)
				
				if var_13_6 == SUBSTORY_FESTIVAL_STATE.REWARDED then
					if_set_visible(var_13_2, "img_close", true)
					if_set_visible(var_13_2, "n_location", false)
					if_set_visible(var_13_2, "n_contents", false)
					if_set_visible(var_13_2, "icon_fix_noti", false)
				else
					if_set_visible(var_13_2, "img_close", false)
					if_set_visible(var_13_2, "icon_fix_noti", var_13_3)
					if_set_visible(var_13_2, "n_location", not var_13_3)
					
					local var_13_9 = "n_location"
					
					if var_13_3 then
						var_13_9 = "icon_fix_noti"
					end
					
					local var_13_10 = var_13_2:getChildByName(var_13_9)
					
					if get_cocos_refid(var_13_10) then
						var_13_10:setVisible(true)
						
						if var_13_5.give_npc and not var_13_3 then
							if_set_sprite(var_13_10, "face", "face/" .. var_13_5.give_npc .. "_s.png")
						end
						
						local var_13_11 = var_13_5.mission_area
						
						if not string.starts(var_13_11, "world") then
							var_13_11 = DB("level_enter", var_13_11, "name")
						end
						
						if_set(var_13_10, "t_location", T(var_13_11))
					end
					
					local var_13_12 = var_13_2:getChildByName("btn_unknown")
					
					if get_cocos_refid(var_13_12) then
						var_13_12.mission_id = var_13_4
						
						var_13_12:setVisible(var_13_6 == SUBSTORY_FESTIVAL_STATE.INACTIVE)
						var_13_12:setEnabled(var_13_6 == SUBSTORY_FESTIVAL_STATE.INACTIVE)
					end
					
					local var_13_13 = var_13_2:getChildByName("n_contents")
					
					if get_cocos_refid(var_13_13) and var_13_6 > SUBSTORY_FESTIVAL_STATE.INACTIVE then
						var_13_13:setVisible(true)
						
						if var_13_3 then
							if_set_visible(var_13_13, "n_difficulty", false)
							if_set_visible(var_13_13, "n_fix", true)
						else
							if_set_visible(var_13_13, "n_difficulty", true)
							if_set_visible(var_13_13, "n_fix", false)
							
							local var_13_14 = var_13_13:getChildByName("n_difficulty")
							
							if get_cocos_refid(var_13_14) then
								local var_13_15 = string.sub(var_13_5.difficulty, -1)
								local var_13_16 = {
									cc.c3b(48, 119, 29),
									cc.c3b(62, 81, 118),
									cc.c3b(191, 91, 18),
									cc.c3b(174, 44, 44)
								}
								
								if_set_sprite(var_13_14, "icon_difficulty", "img/cm_icon_etc_difficulty0" .. var_13_15 .. ".png")
								if_set(var_13_14, "t_difficulty", T(var_13_5.difficulty))
								if_set_color(var_13_14, "bg", var_13_16[tonumber(var_13_15)])
							end
						end
						
						if DEBUG.DEBUG_MAP_ID then
							if_set(var_13_13, "t_mission_contents", var_13_4)
						else
							if_set(var_13_13, "t_mission_contents", T(var_13_5.mission_desc, {
								count = var_13_8.count
							}))
						end
						
						if_set(var_13_13, "t_score", var_13_5.reward_festival_point)
						
						local var_13_17 = var_13_13:getChildByName("btn_renew")
						
						if get_cocos_refid(var_13_17) then
							var_13_17.slot_num = iter_13_0
							
							var_13_17:setVisible(var_13_6 == SUBSTORY_FESTIVAL_STATE.ACTIVE and not var_13_3)
						end
						
						local var_13_18 = var_13_13:getChildByName("btn_complete")
						
						if get_cocos_refid(var_13_18) then
							var_13_18.mission_id = var_13_4
							
							var_13_18:setVisible(var_13_6 == SUBSTORY_FESTIVAL_STATE.CLEAR)
						end
						
						local var_13_19 = var_13_13:getChildByName("btn_move")
						
						if get_cocos_refid(var_13_19) then
							var_13_19.path = var_13_5.move_path
							
							var_13_19:setVisible(var_13_6 == SUBSTORY_FESTIVAL_STATE.ACTIVE)
						end
						
						local var_13_20 = var_13_13:getChildByName("progress_bg")
						
						if get_cocos_refid(var_13_20) then
							local var_13_21 = var_13_8.count
							local var_13_22 = math.min(var_13_0["mission_score" .. iter_13_0], var_13_21)
							
							if_set_percent(var_13_20, "progress_bar", var_13_22 / var_13_21)
							if_set_color(var_13_20, "progress_bar", var_13_6 == SUBSTORY_FESTIVAL_STATE.CLEAR and cc.c3b(107, 193, 27) or cc.c3b(146, 109, 62))
							if_set(var_13_20, "txt", tostring(var_13_22) .. "/" .. tostring(var_13_21))
						end
						
						UIUtil:getRewardIcon(var_13_5.reward_item_value, var_13_5.reward_item_type, {
							parent = var_13_13:getChildByName("reward_item")
						})
					end
				end
			else
				if_set_visible(var_13_2, "img_close", true)
			end
		end
	end
end

function SubstoryFestivalBoard.updatePortrait(arg_14_0)
	local var_14_0 = DB("substory_festival_fm", arg_14_0.vars.info.id, "npc_board")
	local var_14_1 = UIUtil:getPortraitAni(var_14_0, {})
	
	if var_14_1 then
		arg_14_0.vars.wnd:getChildByName("n_pos"):addChild(var_14_1)
		var_14_1:setName("@portrait")
		var_14_1:setScale(0.8)
	end
	
	local var_14_2 = DB("substory_festival", SubStoryFestival:getFestivalID(), "balloon_board")
	
	arg_14_0.vars.wnd:getChildByName("n_balloon"):setScale(0)
	if_set_visible(arg_14_0.vars.wnd, "txt_balloon", false)
	
	if arg_14_0:isMissionAllCleared() then
		UIUtil:playNPCSoundAndTextRandomly(var_14_2 .. ".enter", arg_14_0.vars.wnd, "txt_balloon", 3000, var_14_2 .. ".clear", var_14_1)
	else
		UIUtil:playNPCSoundAndTextRandomly(var_14_2 .. ".enter", arg_14_0.vars.wnd, "txt_balloon", 3000, var_14_2 .. ".idle", var_14_1)
	end
end

function SubstoryFestivalBoard.effectAndDelayedUpdate(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	if not arg_15_1 then
		return 
	end
	
	arg_15_0.vars["delayed" .. arg_15_1] = true
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_mission" .. arg_15_1)
	
	var_15_0:getChildByName("btn_unknown"):setEnabled(false)
	EffectManager:Play({
		pivot_x = 0,
		fn = "ui_abductionstory_eff.cfx",
		pivot_y = 0,
		pivot_z = 99998,
		layer = var_15_0
	})
	UIAction:Add(SEQ(DELAY(100), CALL(function()
		arg_15_0.vars["delayed" .. arg_15_1] = nil
		
		SubstoryFestivalBoard:updateMissionUI(arg_15_1)
	end)), arg_15_0)
end

function SubstoryFestivalBoard.getIndexChanged(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	local var_17_0 = arg_17_1
	local var_17_1 = Account:getSubStoryFestivalInfo(arg_17_0.vars.info.id)
	
	for iter_17_0 = 1, 3 do
		if var_17_0["mission_id" .. iter_17_0] ~= var_17_1["mission_id" .. iter_17_0] then
			return iter_17_0
		end
		
		if var_17_0["mission_state" .. iter_17_0] ~= var_17_1["mission_state" .. iter_17_0] then
			return iter_17_0
		end
	end
	
	return nil
end

function SubstoryFestivalBoard.isMissionAllCleared(arg_18_0)
	local var_18_0 = Account:getSubStoryFestivalInfo(arg_18_0.vars.info.id)
	
	for iter_18_0 = 1, 3 do
		if var_18_0["mission_state" .. iter_18_0] ~= SUBSTORY_FESTIVAL_STATE.REWARDED then
			return false
		end
	end
	
	return true
end

function SubstoryFestivalBoard.isDailyMissionCleared(arg_19_0)
	return Account:getSubStoryFestivalInfo(arg_19_0.vars.info.id).mission_state1 >= SUBSTORY_FESTIVAL_STATE.CLEAR
end

function SubstoryFestivalBoard.updateProgressUI(arg_20_0)
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("n_progress")
	local var_20_1 = var_20_0:getChildByName("n_event")
	local var_20_2 = 0
	local var_20_3 = 1
	local var_20_4 = arg_20_0.vars.info.id
	local var_20_5 = DB("substory_festival_fm", var_20_4, "fm_max_day")
	
	for iter_20_0 = 1, var_20_5 do
		local var_20_6 = var_20_1:getChildByName("btn_progress" .. var_20_3)
		
		if DB("substory_festival", string.format("%s_%02d", var_20_4, iter_20_0), "fm_story_id") and get_cocos_refid(var_20_6) then
			local var_20_7 = arg_20_0:isChecked(iter_20_0)
			
			var_20_2 = var_20_2 + (var_20_7 and 1 or 0)
			
			if_set_visible(var_20_1, "icon_check" .. var_20_3, var_20_7)
			var_20_6:setOpacity(255 * (var_20_7 and 1 or 0.3))
			
			var_20_6.day = iter_20_0
			var_20_3 = var_20_3 + 1
		end
	end
	
	if_set_percent(var_20_0, "progress_bar", var_20_2 / var_0_0)
	if_set(var_20_0, "t_percent", math.floor(var_20_2 / var_0_0 * 100) .. "%")
end

function SubstoryFestivalBoard.isChecked(arg_21_0, arg_21_1)
	local var_21_0, var_21_1 = arg_21_0:isProgressEvent(arg_21_1)
	
	return var_21_1 == "clear" or var_21_0, var_21_1
end

function SubstoryFestivalBoard.getStoryId(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.info.id .. string.format("_%02d", tonumber(arg_22_1))
	
	return (DB("substory_festival", var_22_0, {
		"fm_story_id"
	}))
end

function SubstoryFestivalBoard.isProgressEvent(arg_23_0, arg_23_1)
	local var_23_0 = Account:getSubStoryFestivalInfo(arg_23_0.vars.info.id)
	local var_23_1 = var_23_0.day
	local var_23_2 = var_23_0.story_clear
	
	arg_23_1 = arg_23_1 or var_23_1
	
	if not arg_23_0:getStoryId(arg_23_1) then
		return false, "story"
	end
	
	if var_23_1 < arg_23_1 then
		return false, "day"
	elseif var_23_1 == arg_23_1 then
		if arg_23_0:isDailyMissionCleared() then
			if var_23_2 and arg_23_1 <= var_23_2 then
				return false, "clear"
			end
		else
			return false, "mission"
		end
	elseif arg_23_1 < var_23_1 then
		return false, "clear"
	end
	
	if not SubStoryFestival:isOpenEvent() then
		return false, "closed"
	end
	
	return true, nil
end

function SubstoryFestivalBoard.onEventProgress(arg_24_0, arg_24_1)
	local var_24_0, var_24_1 = arg_24_0:isChecked(arg_24_1)
	
	if var_24_0 then
		local var_24_2 = arg_24_0:getStoryId(arg_24_1)
		
		arg_24_0:onPlayEvent(var_24_2)
	elseif not SubStoryFestival:isOpenEvent() then
		balloon_message_with_sound("fm_error_4")
	else
		arg_24_1 = string.format("_%02d", arg_24_1)
		
		local var_24_3 = DB("substory_festival", arg_24_0.vars.info.id .. arg_24_1, {
			"progress_date_ui"
		})
		
		balloon_message_with_sound("fm_error_2", {
			date_ui = T(var_24_3)
		})
	end
end

function SubstoryFestivalBoard.onPlayEvent(arg_25_0, arg_25_1, arg_25_2)
	if is_playing_story() then
		return 
	end
	
	start_new_story(nil, arg_25_1, {
		force = true,
		on_finish = arg_25_2
	})
end

function SubstoryFestivalBoard.showRewardResult(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = SceneManager:getRunningPopupScene()
	local var_26_1 = Dialog:open("wnd/dungeon_story_request_reward", arg_26_0)
	
	arg_26_2 = arg_26_2.rewards[1]
	
	local var_26_2 = arg_26_2.is_currency and "to_" .. arg_26_2.code or arg_26_2.code
	
	UIUtil:getRewardIcon(arg_26_2.count, var_26_2, {
		parent = var_26_1:getChildByName("reward_item")
	})
	
	local var_26_3 = Account:getSubStoryFestivalInfo(arg_26_0.vars.info.id)
	local var_26_4 = arg_26_1.festival_score - var_26_3.festival_score
	
	if_set(var_26_1, "t_score", var_26_4)
	if_set_arrow(var_26_1)
	
	local var_26_5 = var_26_1:getChildByName("n_eff")
	
	if var_26_5 then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_26_5
		})
		UIAction:Add(DELAY(1000), var_26_1, "block")
	end
	
	var_26_0:addChild(var_26_1)
end

function SubstoryFestivalBoard.showRewardList(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	local var_27_0 = SceneManager:getRunningPopupScene()
	local var_27_1 = Dialog:open("wnd/dungeon_story_request_board_popup", arg_27_0)
	local var_27_2 = arg_27_0:initListView(var_27_1:getChildByName("list_view"))
	local var_27_3 = {
		cc.c3b(107, 193, 27),
		cc.c3b(51, 152, 238),
		cc.c3b(237, 94, 8),
		cc.c3b(228, 6, 6)
	}
	local var_27_4 = true
	
	for iter_27_0 = 4, 1, -1 do
		local var_27_5 = DB("substory_festival_fm", arg_27_0.vars.info.id, "mission_reward_difficulty_" .. iter_27_0)
		
		if var_27_5 then
			local var_27_6 = string.split(var_27_5, ";")
			
			var_27_2:addGroup({
				title = T("substory_fm_difficulty_label_" .. iter_27_0),
				icon = "img/cm_icon_etc_difficulty0" .. iter_27_0,
				color = var_27_3[iter_27_0],
				no_bar = var_27_4
			}, var_27_6)
			
			var_27_4 = false
		end
	end
	
	var_27_0:addChild(var_27_1)
end

function SubstoryFestivalBoard.initListView(arg_28_0, arg_28_1)
	if not arg_28_1 then
		return 
	end
	
	local var_28_0 = GroupListView:bindControl(arg_28_1)
	
	var_28_0:setListViewCascadeOpacityEnabled(true)
	var_28_0:setEnableMargin(true)
	
	local var_28_1 = load_control("wnd/dungeon_story_request_board_popup_header.csb")
	local var_28_2 = var_28_1:getContentSize()
	
	var_28_1:setContentSize(var_28_2.width, var_28_2.height + 6)
	
	local var_28_3 = {
		onUpdate = function(arg_29_0, arg_29_1, arg_29_2)
			if_set_color(arg_29_1, "n_level", arg_29_2.color)
			if_set(arg_29_1, "level_text", arg_29_2.title)
			if_set_sprite(arg_29_1, "cm_icon", arg_29_2.icon)
			if_set_visible(arg_29_1, "bar", not arg_29_2.no_bar)
			arg_29_1:setPosition(4, 6)
		end
	}
	local var_28_4 = UIUtil:getRewardIcon(1, "to_mura", {
		scale = 0.8
	})
	local var_28_5 = cc.Node:create()
	local var_28_6 = var_28_4:getContentSize()
	
	var_28_5:setContentSize(var_28_6.width - 4, var_28_6.height)
	
	local var_28_7 = {
		onUpdate = function(arg_30_0, arg_30_1, arg_30_2)
			UIUtil:getRewardIcon(1, arg_30_2, {
				scale = 0.8,
				parent = arg_30_1
			}):setPosition(53, 50)
		end
	}
	
	var_28_0:setRenderer(var_28_1, var_28_5, var_28_3, var_28_7)
	
	return var_28_0
end

function SubstoryFestivalBoard.showRefreshMission(arg_31_0, arg_31_1)
	if not SubStoryFestival:isOpenEvent() then
		balloon_message_with_sound("fm_error_4")
		
		return 
	end
	
	if Account:getSubStoryFestivalInfo(arg_31_0.vars.info.id)["mission_state" .. arg_31_1] ~= SUBSTORY_FESTIVAL_STATE.ACTIVE then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.wnd or SceneManager:getRunningPopupScene()
	local var_31_1 = Dialog:open("wnd/dungeon_story_request_renew", arg_31_0, {
		back_func = function()
			SubstoryFestivalBoard:onCloseRefreshMission()
		end
	})
	
	if_set(var_31_1:getChildByName("btn_renew"), "label", T("substory_album_popup2_btn2"))
	
	arg_31_0.vars.renew_dlg = var_31_1
	arg_31_0.vars.refresh_mission = false
	arg_31_0.vars.refresh_mission_idx = arg_31_1
	var_31_1:getChildByName("btn_renew").slot_num = arg_31_1
	arg_31_0.vars.renew_dlg.slot_num = arg_31_1
	
	local var_31_2 = arg_31_0.vars.db.substory_reset_free
	
	if_set(var_31_1, "t_renew_info", T("substory_album_popup2_desc2", {
		free = var_31_2
	}))
	if_set_visible(arg_31_0.vars.renew_dlg, "n_contents", true)
	arg_31_0:updateRenewDlg(arg_31_1)
	var_31_0:addChild(var_31_1)
	var_31_1:bringToFront()
end

function SubstoryFestivalBoard.getRefreshPrice(arg_33_0, arg_33_1)
	local var_33_0 = 0
	local var_33_1 = arg_33_0.vars.db
	local var_33_2 = Account:getSubStoryFestivalInfo(arg_33_0.vars.info.id)["refresh_count" .. arg_33_1]
	
	if var_33_2 >= var_33_1.substory_reset_free then
		var_33_0 = var_33_1.substory_reset_cost + (var_33_2 - var_33_1.substory_reset_free) * var_33_1.substory_reset_cost * var_33_1.substory_reset_add_cost
		var_33_0 = math.floor(var_33_0)
		
		local var_33_3 = var_33_1.substory_reset_cost + (var_33_1.substory_reset_limit - var_33_1.substory_reset_free) * var_33_1.substory_reset_cost * var_33_1.substory_reset_add_cost
		
		var_33_0 = math.min(var_33_0, var_33_3)
	end
	
	return var_33_0
end

function SubstoryFestivalBoard.updateRenewDlg(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.renew_dlg) then
		return 
	end
	
	local var_34_0 = arg_34_0.vars.renew_dlg
	local var_34_1 = arg_34_0.vars.renew_dlg.slot_num or arg_34_1
	local var_34_2 = Account:getSubStoryFestivalInfo(arg_34_0.vars.info.id)["refresh_count" .. var_34_1]
	local var_34_3 = arg_34_0.vars.db
	local var_34_4 = arg_34_0:getRefreshPrice(var_34_1)
	local var_34_5 = var_34_0:getChildByName("n_token")
	
	UIUtil:getRewardIcon(nil, var_34_3.substory_reset_token, {
		no_bg = true,
		parent = var_34_5
	})
	
	if var_34_4 == 0 then
		if_set(var_34_0, "price", T("shop_price_free"))
	else
		if_set(var_34_0, "price", comma_value(var_34_4))
	end
	
	local var_34_6 = arg_34_0.vars.renew_dlg:getChildByName("n_free_tip")
	
	var_34_6:setVisible(var_34_2 < var_34_3.substory_reset_free)
	if_set(var_34_6, "t_count", T("substory_album_popup2_desc4", {
		curr = var_34_2,
		max = var_34_3.substory_reset_free
	}))
	arg_34_0:_updateMissionUI(var_34_1)
end

function SubstoryFestivalBoard._updateMissionUI(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.renew_dlg) or not arg_35_1 then
		return 
	end
	
	local var_35_0 = arg_35_0.vars.renew_dlg:getChildByName("n_contents")
	local var_35_1 = Account:getSubStoryFestivalInfo(arg_35_0.vars.info.id)["mission_id" .. arg_35_1]
	
	if var_35_1 then
		local var_35_2 = DBT("substory_festival_mission", var_35_1, {
			"give_npc",
			"mission_area",
			"move_path",
			"difficulty",
			"mission_desc",
			"value",
			"reward_festival_point",
			"reward_item_type",
			"reward_item_value"
		})
		local var_35_3 = var_35_0:getChildByName("n_difficulty")
		
		if get_cocos_refid(var_35_3) then
			local var_35_4 = string.sub(var_35_2.difficulty, -1)
			local var_35_5 = {
				cc.c3b(48, 119, 29),
				cc.c3b(62, 81, 118),
				cc.c3b(191, 91, 18),
				cc.c3b(174, 44, 44)
			}
			
			if_set_sprite(var_35_3, "icon_difficulty", "img/cm_icon_etc_difficulty0" .. var_35_4 .. ".png")
			if_set(var_35_3, "t_difficulty", T(var_35_2.difficulty))
			if_set_color(var_35_3, "bg", var_35_5[tonumber(var_35_4)])
		end
		
		local var_35_6 = string.trim(var_35_2.value)
		local var_35_7 = totable(var_35_6)
		local var_35_8 = var_35_2.mission_area
		
		if not string.starts(var_35_8, "world") then
			var_35_8 = DB("level_enter", var_35_8, "name")
		end
		
		if_set(var_35_0, "t_location", T(var_35_8))
		
		if DEBUG.DEBUG_MAP_ID then
			if_set(var_35_0, "t_mission_contents", var_35_1)
		else
			if_set(var_35_0, "t_mission_contents", T(var_35_2.mission_desc, {
				count = var_35_7.count
			}))
		end
		
		if_set(var_35_0, "t_score", var_35_2.reward_festival_point)
		
		local var_35_9 = var_35_0:getChildByName("reward_item")
		
		if get_cocos_refid(var_35_9) then
			var_35_9:removeAllChildren()
			UIUtil:getRewardIcon(var_35_2.reward_item_value, var_35_2.reward_item_type, {
				parent = var_35_9
			})
		end
	end
end

function SubstoryFestivalBoard.onRefreshMission(arg_36_0, arg_36_1)
	arg_36_0:effectAndDelayedUpdate(arg_36_1)
	balloon_message_with_sound("fm_mission_reset_msg")
end

function SubstoryFestivalBoard.onCloseRefreshMission(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("boss_guide")
	UIAction:Add(SEQ(LOG(SPAWN(FADE_OUT(150), SCALE(150, 1, 0))), REMOVE()), arg_37_0.vars.renew_dlg, "block")
	
	if arg_37_0.vars.refresh_mission and arg_37_0.vars.refresh_mission_idx then
		SubstoryFestivalBoard:onRefreshMission(arg_37_0.vars.refresh_mission_idx)
		
		arg_37_0.vars.refresh_mission = nil
		arg_37_0.vars.refresh_mission_idx = nil
	end
end

function SubstoryFestivalBoard.queryRefresh(arg_38_0, arg_38_1)
	if not SubStoryFestival:isOpenEvent() then
		balloon_message_with_sound("fm_error_4")
		
		return 
	end
	
	local var_38_0 = arg_38_0:getRefreshPrice(arg_38_1)
	local var_38_1 = arg_38_0.vars.db.substory_reset_token
	
	if var_38_0 > Account:getCurrency(var_38_1) then
		UIUtil:checkCurrencyDialog(var_38_1)
		
		return 
	end
	
	local var_38_2 = Account:getSubStoryFestivalInfo(arg_38_0.vars.info.id)["mission_id" .. arg_38_1]
	
	arg_38_0.vars.refresh_mission = true
	
	query("substory_festival_mission_refresh", {
		substory_id = arg_38_0.vars.info.id,
		mission_id = var_38_2
	})
end

function SubstoryFestivalBoard.queryActiveMission(arg_39_0, arg_39_1)
	if not SubStoryFestival:isOpenEvent() then
		balloon_message_with_sound("fm_error_4")
		
		return 
	end
	
	query("substory_festival_mission_active", {
		substory_id = arg_39_0.vars.info.id,
		mission_id = arg_39_1
	})
end

function SubstoryFestivalBoard.queryCompleteMission(arg_40_0, arg_40_1)
	query("substory_festival_misison_complete", {
		substory_id = arg_40_0.vars.info.id,
		mission_id = arg_40_1
	})
end

function SubstoryFestivalBoard.queryProgressEvent(arg_41_0, arg_41_1)
	query("substory_festival_progress_event", {
		substory_id = arg_41_0.vars.info.id,
		festival_id = arg_41_1
	})
end

function SubstoryFestivalBoard.close(arg_42_0)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("Dialog.dungeon_story_request_board")
	UIAction:Add(SEQ(FADE_OUT(300), CALL(function()
		if not arg_42_0.vars then
			return 
		end
		
		if arg_42_0.vars and get_cocos_refid(arg_42_0.vars.wnd) then
			arg_42_0.vars.wnd:removeFromParent()
		end
		
		arg_42_0.vars.wnd = nil
		arg_42_0.vars = nil
	end)), arg_42_0.vars.wnd, "block")
	
	local var_42_0 = SceneManager:getCurrentSceneName()
	
	if var_42_0 == "world_custom" or var_42_0 == "world_sub" then
		local var_42_1 = WorldMapManager:getController()
		
		if var_42_1 then
			var_42_1:updateFestivalTags()
		end
	elseif SubstoryManager:isSubstoryLobbyScene(var_42_0) and SubstoryFestivalInn:isSchedulable(arg_42_0.vars.info) then
		TutorialGuide:startGuide("tuto_vma1ba_nextday")
	end
end
