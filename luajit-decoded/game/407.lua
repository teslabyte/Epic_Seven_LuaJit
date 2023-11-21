EventMissionDays = {}

function HANDLER.lobby_integrated_service_7days(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_select" then
		local var_1_0 = arg_1_0:getParent()
		
		EventMissionDays:onSelectTab(to_n(string.sub(var_1_0:getName(), -1, -1)))
		
		return 
	end
	
	if not EventMissionDays:isActive() then
		EventMissionDays:onEventEnd()
		
		return 
	end
	
	if arg_1_1 == "btn_all" then
		EventMissionDays:onButtonEventReward()
		
		return 
	end
	
	if arg_1_1 == "btn_reward" then
		EventMissionDays:onButtonEventReward(arg_1_0.req_point)
		
		return 
	end
end

function HANDLER.lobby_integrated_service_7days_card(arg_2_0, arg_2_1)
	if not EventMissionDays:isActive() then
		EventMissionDays:onEventEnd()
		
		return 
	end
	
	if arg_2_1 == "btn_go" then
		movetoPath(arg_2_0.path)
	elseif arg_2_1 == "btn_receive" then
		EventMissionDays:onButtonMissionReward(arg_2_0)
	end
end

function MsgHandler.event_mission_complete(arg_3_0)
	if arg_3_0.mission_info and arg_3_0.rewards then
		Account:updateEventMission(arg_3_0.mission_info)
		
		local var_3_0 = {
			title = T("em_reward_desc_1"),
			desc = T("em_reward_desc_2")
		}
		local var_3_1 = Account:addReward(arg_3_0.rewards, {
			play_reward_data = var_3_0
		})
		
		if var_3_1 and get_cocos_refid(var_3_1.reward_dlg) then
			var_3_1.reward_dlg:bringToFront()
		end
		
		EventMissionDays:updateMissionUI()
		EventMissionDays:updateEventTab()
	end
end

function MsgHandler.event_mission_progress_reward(arg_4_0)
	if arg_4_0.event_ticket_info and arg_4_0.rewards then
		Account:updateEventTicket(arg_4_0.event_ticket_info)
		
		local var_4_0 = {
			title = T("em_reward_desc_1"),
			desc = T("em_reward_desc_2")
		}
		local var_4_1 = Account:addReward(arg_4_0.rewards, {
			play_reward_data = var_4_0
		})
		
		if var_4_1 and get_cocos_refid(var_4_1.reward_dlg) then
			var_4_1.reward_dlg:bringToFront()
		end
		
		EventMissionDays:updateEventMain()
		EventMissionDays:updateEventTab()
	end
end

function EventMissionDays.open(arg_5_0, arg_5_1, arg_5_2)
	if not get_cocos_refid(arg_5_1) then
		return 
	end
	
	if arg_5_0.vars and arg_5_0.vars.event_id ~= arg_5_2 then
		arg_5_0:close()
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("lobby_integrated_service_7days", true, "wnd")
	
	arg_5_0.vars.wnd:setAnchorPoint(0, 0)
	arg_5_0.vars.wnd:setPosition(0, 0)
	
	arg_5_0.vars.tab = 1
	arg_5_0.vars.event_id = arg_5_2
	
	ConditionContentsManager:updateEventMissionConditionDispatch()
	arg_5_0:updateEventTab()
	arg_5_0:onSelectTab(1)
	arg_5_1:addChild(arg_5_0.vars.wnd)
	
	return arg_5_0.vars.wnd
end

function EventMissionDays.initEventMain(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_event_mask")
	local var_6_1 = DBT("event_mission_category", arg_6_0.vars.event_id, {
		"id",
		"day",
		"bg",
		"bi",
		"bi_data",
		"img_progressbar",
		"tint_progressbar_bg",
		"reward_bg1",
		"reward_bg2",
		"desc",
		"font_time",
		"outline_time",
		"font_desc",
		"outline_desc"
	})
	
	if not var_6_1 or not var_6_1.id then
		return 
	end
	
	local var_6_2 = var_6_1.day or 7
	
	for iter_6_0 = 1, var_6_2 do
		local var_6_3 = DBT("event_mission_day_reward", string.format("%s_mc_%02d", arg_6_0.vars.event_id, iter_6_0), {
			"id",
			"reward_id",
			"reward_count",
			"mission_count"
		})
		local var_6_4 = var_6_0:getChildByName("n_" .. iter_6_0)
		
		if not var_6_3 or not var_6_3.id or not get_cocos_refid(var_6_4) then
			break
		end
		
		local var_6_5 = iter_6_0 == var_6_2 and var_6_1.reward_bg2 or var_6_1.reward_bg1
		
		if var_6_5 then
			if_set_sprite(var_6_4, "item_bg", "img/" .. var_6_5 .. ".png")
		end
		
		local var_6_6 = var_6_4:getChildByName("btn_reward")
		
		if get_cocos_refid(var_6_6) then
			var_6_6.req_point = var_6_3.mission_count
		end
		
		UIUtil:getRewardIcon(nil, var_6_3.reward_id, {
			no_count = true,
			no_bg = true,
			tooltip_delay = 130,
			parent = var_6_4:getChildByName("n_item")
		})
		if_set(var_6_4, "txt_count", var_6_3.reward_count > 1 and var_6_3.reward_count or "")
	end
	
	local var_6_7 = var_6_0:getChildByName("txt_disc")
	local var_6_8 = var_6_0:getChildByName("txt_time")
	
	if get_cocos_refid(var_6_7) then
		if var_6_1.desc then
			var_6_7:setString(T(var_6_1.desc))
		end
		
		if var_6_1.font_desc then
			var_6_7:setTextColor(tocolor(var_6_1.font_desc))
		end
		
		if var_6_1.outline_desc then
			var_6_7:enableOutline(tocolor(var_6_1.outline_desc), 1)
		end
	end
	
	if get_cocos_refid(var_6_8) then
		if var_6_1.font_time then
			var_6_8:setTextColor(tocolor(var_6_1.font_desc))
		end
		
		if var_6_1.outline_time then
			var_6_8:enableOutline(tocolor(var_6_1.outline_time), 1)
		end
	end
	
	if_set_sprite(var_6_0, "n_bg", "banner/" .. var_6_1.bg .. ".png")
	if_set_sprite(var_6_0, "n_bi", "banner/" .. var_6_1.bi .. ".png")
	if_set_visible(var_6_0, "btn_all", true)
	if_set_visible(var_6_0, nil, true)
	EventMissionUtil:setDataUI(var_6_0:getChildByName("n_bi"), var_6_1.bi_data)
	
	local var_6_9 = var_6_0:getChildByName("n_progress_bar")
	local var_6_10 = var_6_0:getChildByName("n_progress")
	local var_6_11 = var_6_1.img_progressbar or "z_we_7days_new_progress"
	local var_6_12 = WidgetUtils:createBarProgress("img/" .. var_6_11 .. ".png", cc.p(0, 0.5), cc.p(1, 0))
	
	var_6_12:setName("progress_bar")
	var_6_12:setPercentage(0)
	var_6_12:setAnchorPoint(0, 0)
	var_6_12:setPosition(var_6_9:getPosition())
	var_6_12:setContentSize(var_6_9:getContentSize())
	var_6_10:addChild(var_6_12)
	var_6_9:removeFromParent()
	var_6_10:getChildByName("txt_bar_count"):bringToFront()
	
	if var_6_1.tint_progressbar_bg then
		if_set_color(var_6_0, "progress_bg", tocolor(var_6_1.tint_progressbar_bg))
	end
	
	arg_6_0.vars.ui_main = var_6_0
end

function EventMissionDays.updateEventMain(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_7_0.vars.ui_main) then
		arg_7_0:initEventMain()
	end
	
	local var_7_0 = arg_7_0.vars.event_id
	local var_7_1 = EventMissionUtil:getEventTicket(var_7_0, true)
	
	if not var_7_1 then
		return 
	end
	
	local var_7_2 = EventMissionUtil:getRemainTime(var_7_0)
	
	if var_7_2 > 3600 then
		if_set(arg_7_0.vars.ui_main, "txt_time", T("time_remain", {
			time = sec_to_full_string(var_7_2, nil, {
				count = 2
			})
		}))
	else
		if_set(arg_7_0.vars.ui_main, "txt_time", T("time_remain", {
			time = sec_to_full_string(var_7_2, nil, {
				count = 1
			})
		}))
	end
	
	local var_7_3 = EventMissionUtil:getEventScore(arg_7_0.vars.event_id)
	local var_7_4 = var_7_1.reward_point
	local var_7_5 = 0
	
	for iter_7_0 = 1, 99 do
		local var_7_6 = DB("event_mission_day_reward", string.format("%s_mc_%02d", arg_7_0.vars.event_id, iter_7_0), "mission_count")
		local var_7_7 = arg_7_0.vars.ui_main:getChildByName("n_" .. iter_7_0)
		
		if not var_7_6 or not get_cocos_refid(var_7_7) then
			break
		end
		
		local var_7_8 = var_7_6 <= var_7_4
		local var_7_9 = var_7_3 < var_7_6
		
		if_set_visible(var_7_7, "btn_reward", not var_7_8)
		if_set_visible(var_7_7, "icon_check", var_7_8)
		if_set_visible(var_7_7, "icon_etclock", var_7_9)
		if_set_opacity(var_7_7, "n_item", not var_7_8 and 255 or 76.5)
		if_set_color(var_7_7, "n_item", var_7_9 and cc.c3b(136, 136, 136) or cc.c3b(255, 255, 255))
		
		if var_7_5 < var_7_6 then
			var_7_5 = var_7_6
		end
	end
	
	local var_7_10 = arg_7_0.vars.ui_main:getChildByName("progress_bar")
	
	if get_cocos_refid(var_7_10) then
		local var_7_11 = var_7_3 / var_7_5
		
		var_7_10:setPercentage(var_7_11 * 100)
		
		local var_7_12 = 24
		local var_7_13 = 6
		local var_7_14 = var_7_10:getPositionX()
		local var_7_15 = math.max(var_7_12, var_7_11 * var_7_10:getContentSize().width - var_7_13)
		
		if_set_position_x(arg_7_0.vars.ui_main, "txt_bar_count", var_7_14 + var_7_15)
		if_set(arg_7_0.vars.ui_main, "txt_bar_count", var_7_3)
	end
	
	local var_7_16 = EventMissionUtil:isEventRewardable(arg_7_0.vars.event_id)
	
	if_set_opacity(arg_7_0.vars.ui_main, "btn_all", var_7_16 and 255 or 76.5)
end

function EventMissionDays.initMissionUI(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	local var_8_0 = DBT("event_mission_category", arg_8_0.vars.event_id, {
		"id",
		"bg",
		"bi",
		"bi_data",
		"tint_mission_list_bg"
	})
	
	if not var_8_0 or not var_8_0.id then
		return 
	end
	
	local var_8_1 = arg_8_0.vars.wnd:getChildByName("n_quest_mask")
	
	if_set_sprite(var_8_1, "n_bg", "banner/" .. var_8_0.bg .. ".png")
	if_set_sprite(var_8_1, "n_bi", "banner/" .. var_8_0.bi .. ".png")
	EventMissionUtil:setDataUI(var_8_1:getChildByName("n_bi"), var_8_0.bi_data)
	
	if var_8_0.tint_mission_list_bg then
		if_set_color(var_8_1, "img_box", tocolor(var_8_0.tint_mission_list_bg))
	end
	
	local var_8_2 = {}
	
	copy_functions(ScrollView, var_8_2)
	
	function var_8_2.getScrollViewItem(arg_9_0, arg_9_1)
		local var_9_0 = load_control("wnd/lobby_integrated_service_7days_card.csb")
		
		if arg_9_1.reward_id1 then
			UIUtil:getRewardIcon(arg_9_1.reward_count1, arg_9_1.reward_id1, {
				parent = var_9_0:getChildByName("n_1")
			})
		end
		
		if arg_9_1.reward_id2 then
			UIUtil:getRewardIcon(arg_9_1.reward_count2, arg_9_1.reward_id2, {
				parent = var_9_0:getChildByName("n_2")
			})
		end
		
		local var_9_1 = arg_9_1.value.count
		local var_9_2 = math.min(EventMissionDays:getMissionScore(arg_9_1.id), var_9_1)
		local var_9_3, var_9_4 = EventMissionDays:getMissionState(arg_9_1.id)
		
		if_set(var_9_0, "txt_title", T(arg_9_1.mission_desc))
		if_set(var_9_0, "txt_count", var_9_2 .. " / " .. var_9_1)
		
		if var_9_3 == EVENT_MISSION_STATE.CLEAR then
			if_set_color(var_9_0, "n_txt", cc.c3b(100, 203, 0))
			
			local var_9_5 = var_9_0:getChildByName("btn_receive")
			
			if get_cocos_refid(var_9_5) then
				if var_9_4 then
					var_9_5:setColor(cc.c3b(136, 136, 136))
					
					var_9_5.day_lock = arg_9_1.day
				else
					var_9_5.mission_id = arg_9_1.id
				end
				
				var_9_5:setVisible(true)
			end
		elseif var_9_3 == EVENT_MISSION_STATE.COMPLETE then
			if_set_color(var_9_0, "n_txt", cc.c3b(100, 203, 0))
			if_set_visible(var_9_0, "n_complet", true)
			if_set_opacity(var_9_0, "bar", 84.15)
			if_set_opacity(var_9_0, nil, 76.5)
		else
			local var_9_6 = var_9_0:getChildByName("btn_go")
			
			if get_cocos_refid(var_9_6) then
				var_9_6:setVisible(true)
				
				var_9_6.path = arg_9_1.btn_move
			end
		end
		
		return var_9_0
	end
	
	var_8_2:initScrollView(var_8_1:getChildByName("n_scrollview"), 722, 72)
	
	arg_8_0.vars.ui_mission = var_8_1
	arg_8_0.vars.mission_scroll = var_8_2
end

function EventMissionDays.onButtonMissionReward(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	if arg_10_1.day_lock then
		balloon_message_with_sound("em_mission_lock")
		
		return 
	end
	
	if not EventMissionUtil:isEventMissionEnabled() then
		balloon_message_with_sound("em_mission_end_3")
		
		return 
	end
	
	if not arg_10_1.mission_id then
		return 
	end
	
	query("event_mission_complete", {
		event_id = arg_10_0.vars.event_id,
		mission_id = arg_10_1.mission_id
	})
end

function EventMissionDays.onButtonEventReward(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	if not EventMissionUtil:isEventMissionEnabled() then
		balloon_message_with_sound("em_mission_end_3")
		
		return 
	end
	
	if arg_11_1 and to_n(arg_11_1) > to_n(EventMissionUtil:getEventScore(arg_11_0.vars.event_id)) then
		balloon_message_with_sound("em_reward_lock_2")
		
		return 
	end
	
	if not EventMissionUtil:isEventRewardable(arg_11_0.vars.event_id) then
		balloon_message_with_sound("em_reward_lock_3")
		
		return 
	end
	
	query("event_mission_progress_reward", {
		event_id = arg_11_0.vars.event_id
	})
end

function EventMissionDays.updateMissionUI(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.ui_mission) then
		arg_12_0:initMissionUI()
	end
	
	local var_12_0 = arg_12_0.vars.tab - 1
	local var_12_1 = {
		"id",
		"condition",
		"value",
		"day",
		"mission_desc",
		"reward_id1",
		"reward_count1",
		"reward_id2",
		"reward_count2",
		"btn_move"
	}
	local var_12_2 = EventMissionUtil:getMissionList(arg_12_0.vars.event_id, {
		day = var_12_0,
		column_list = var_12_1
	})
	
	arg_12_0.vars.mission_scroll:clearScrollViewItems()
	arg_12_0.vars.mission_scroll:setScrollViewItems(var_12_2)
end

function EventMissionDays.initEventTab(arg_13_0)
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_tap_mask")
	local var_13_1 = EventMissionUtil:getEventTicket(arg_13_0.vars.event_id)
	
	if var_13_1 then
		for iter_13_0 = var_13_1.day_count + 2, 8 do
			if_set_color(var_13_0, "n_tap" .. iter_13_0, cc.c3b(136, 136, 136))
		end
	end
	
	arg_13_0.vars.ui_tab = var_13_0
end

function EventMissionDays.updateEventTab(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_14_0.vars.ui_tab) then
		arg_14_0:initEventTab()
	end
	
	local var_14_0 = EventMissionUtil:getEventTicket(arg_14_0.vars.event_id, true)
	
	if not var_14_0 then
		return 
	end
	
	for iter_14_0 = 1, 8 do
		local var_14_1 = arg_14_0.vars.ui_tab:getChildByName("n_tap" .. iter_14_0)
		
		if_set_visible(var_14_1, "img_select", arg_14_0.vars.tab == iter_14_0)
		
		if iter_14_0 > 1 then
			local var_14_2 = iter_14_0 - 1
			
			if var_14_2 <= var_14_0.day_count then
				if_set_visible(var_14_1, "icon_noti", EventMissionUtil:isMissionRewardable(arg_14_0.vars.event_id, {
					day = var_14_2
				}))
			end
		else
			if_set_visible(var_14_1, "icon_noti", EventMissionUtil:isEventRewardable(arg_14_0.vars.event_id))
		end
	end
end

function EventMissionDays.onSelectTab(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0.vars.tab = arg_15_1
	
	arg_15_0:updateEventTab()
	
	if arg_15_1 == 1 then
		arg_15_0:updateEventMain()
		if_set_visible(arg_15_0.vars.ui_main, nil, true)
		if_set_visible(arg_15_0.vars.ui_mission, nil, false)
	else
		arg_15_0:updateMissionUI()
		if_set_visible(arg_15_0.vars.ui_main, nil, false)
		if_set_visible(arg_15_0.vars.ui_mission, nil, true)
	end
end

function EventMissionDays.getMissionScore(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	return Account:getScoreEventMissionByID(arg_16_1)
end

function EventMissionDays.getMissionState(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	local var_17_0 = EventMissionUtil:getEventTicket(arg_17_0.vars.event_id, true)
	
	if not var_17_0 then
		return 
	end
	
	local var_17_1 = DB("event_mission", arg_17_1, {
		"day"
	}) > var_17_0.day_count
	
	return Account:getStateEventMissoinByID(arg_17_1), var_17_1
end

function EventMissionDays.onEventEnd(arg_18_0)
	if not arg_18_0.vars then
		WebEventPopUp:close()
		
		return 
	end
	
	EventMissionUtil:popupEventEnd(arg_18_0.vars.event_id)
end

function EventMissionDays.isActive(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	return EventMissionUtil:isActiveEvent(arg_19_0.vars.event_id)
end

function EventMissionDays.close(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_20_0.vars.wnd) then
		arg_20_0.vars.wnd:removeFromParent()
		
		arg_20_0.vars.wnd = nil
	end
	
	arg_20_0.vars = nil
end
