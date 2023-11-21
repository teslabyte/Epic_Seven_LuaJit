EventMissionUtil = {}

function EventMissionUtil.createEventBanner(arg_1_0, arg_1_1)
	local var_1_0, var_1_1, var_1_2 = DB("event_mission_category", arg_1_1, {
		"banner",
		"bi",
		"bi_banner_data"
	})
	
	if not var_1_0 then
		for iter_1_0 = 1, 10 do
			Log.e(arg_1_1 .. " banner DATA NOT FOUND !!!!")
		end
		
		return nil
	end
	
	local var_1_3 = load_control("wnd/integrated_banner.csb")
	local var_1_4 = var_1_3:getChildByName("bi_img")
	
	if_set_sprite(var_1_3, "banner_bg", "banner/" .. var_1_0 .. ".png")
	if_set_sprite(var_1_4, nil, "banner/" .. var_1_1 .. ".png")
	arg_1_0:setDataUI(var_1_4, var_1_2)
	
	return var_1_3
end

function EventMissionUtil.setDataUI(arg_2_0, arg_2_1, arg_2_2)
	if not get_cocos_refid(arg_2_1) then
		return 
	end
	
	if not arg_2_2 then
		return 
	end
	
	local var_2_0 = string.split(arg_2_2, ";")
	local var_2_1 = to_n(var_2_0[1])
	
	if var_2_1 == 0 then
		var_2_1 = 1
	end
	
	local var_2_2 = to_n(var_2_0[2])
	local var_2_3 = to_n(var_2_0[3])
	
	arg_2_1:setPosition(var_2_2, var_2_3)
	arg_2_1:setScale(var_2_1)
end

function EventMissionUtil.getEventType(arg_3_0, arg_3_1)
	return "Days"
end

function EventMissionUtil.isForceActiveEventByID(arg_4_0, arg_4_1)
	local var_4_0 = Account:getEventTicket(arg_4_1)
	
	if not var_4_0 then
		return false
	end
	
	return arg_4_0:isForceActiveEvent(var_4_0)
end

function EventMissionUtil.isForceActiveEvent(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return false
	end
	
	if arg_5_1.vi0 and arg_5_1.vi0 + 86400 * (GAME_CONTENT_VARIABLE.return_user_buff_duration or 14) > os.time() then
		return true
	end
	
	return false
end

function EventMissionUtil.getIssuedCount(arg_6_0, arg_6_1)
	local var_6_0 = Account:getEventTicket(arg_6_1)
	
	return var_6_0 and to_n(var_6_0.issued_count) or 0
end

function EventMissionUtil.getIssuedTime(arg_7_0, arg_7_1)
	local var_7_0 = Account:getEventTicket(arg_7_1)
	
	if not var_7_0 then
		return 
	end
	
	local var_7_1 = var_7_0.issued_tm
	
	if (arg_7_1 == "7days_new" or arg_7_1 == "7days_return") and var_7_0.vi0 then
		var_7_1 = var_7_0.vi0
	end
	
	return var_7_1
end

function EventMissionUtil.getExpireTime(arg_8_0, arg_8_1)
	if not Account:getEventTicket(arg_8_1) then
		return 0
	end
	
	return arg_8_0:getIssuedTime(arg_8_1) + DB("event_mission_category", arg_8_1, "d_day") * 60 * 60 * 24
end

function EventMissionUtil.isActiveEvent(arg_9_0, arg_9_1)
	if arg_9_0:isForceActiveEventByID(arg_9_1) then
		return not arg_9_0:isEventCompleted(arg_9_1)
	end
	
	return arg_9_0:getIssuedCount(arg_9_1) == 1 and arg_9_0:getRemainTime(arg_9_1) > 0 and not arg_9_0:isEventCompleted(arg_9_1)
end

function EventMissionUtil.getRemainTime(arg_10_0, arg_10_1)
	local var_10_0 = os.time()
	local var_10_1 = arg_10_0:getExpireTime(arg_10_1)
	
	return math.max(var_10_1 - var_10_0, 0)
end

function EventMissionUtil.isShowBalloonEvent(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getEventTicket(arg_11_1)
	
	if not var_11_0 then
		return 
	end
	
	local var_11_1 = arg_11_0:getEventConfigData(arg_11_1, "day_balloon")
	
	if not var_11_1 and var_11_0.day_count == 1 then
		return true
	end
	
	local var_11_2 = os.time()
	local var_11_3 = arg_11_0:getIssuedTime(arg_11_1)
	
	if not var_11_3 then
		return 
	end
	
	if var_11_2 - var_11_3 < DB("event_mission_category", arg_11_1, "balloon_open_time") then
		return false
	end
	
	return Account:serverTimeDayLocalDetail() > to_n(var_11_1)
end

function EventMissionUtil.getBalloonEventInfo(arg_12_0)
	if IS_PUBLISHER_ZLONG then
		return 
	end
	
	local var_12_0 = arg_12_0:getEventTickets()
	
	if not var_12_0 or table.empty(var_12_0) then
		return 
	end
	
	local var_12_1
	
	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if arg_12_0:isShowBalloonEvent(iter_12_1.event_id) then
			if not var_12_1 then
				var_12_1 = iter_12_1
			elseif arg_12_0:getRemainTime(iter_12_1.event_id) < arg_12_0:getRemainTime(var_12_1.event_id) then
				var_12_1 = iter_12_1
			end
		end
	end
	
	if not var_12_1 then
		return 
	end
	
	local var_12_2 = not arg_12_0:getEventConfigData(var_12_1.event_id, "day_balloon") and var_12_1.day_count == 1
	
	return var_12_1, var_12_2
end

function EventMissionUtil.getMissionList(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or {}
	
	local var_13_0 = {}
	local var_13_1 = {}
	
	if arg_13_2.column_list then
		var_13_1 = arg_13_2.column_list
	else
		table.insert(var_13_1, "id")
		
		for iter_13_0, iter_13_1 in pairs(arg_13_2) do
			table.insert(var_13_1, iter_13_0)
		end
	end
	
	for iter_13_2 = 1, 99 do
		local var_13_2 = DBT("event_mission", string.format("%s_%02d", arg_13_1, iter_13_2), var_13_1)
		
		if not var_13_2 then
			break
		end
		
		local var_13_3 = true
		
		if arg_13_2.day then
			var_13_3 = arg_13_2.day == var_13_2.day
		end
		
		if var_13_3 then
			if var_13_2.value then
				var_13_2.value = totable(var_13_2.value)
			end
			
			var_13_2.sort = iter_13_2
			
			if Account:getStateEventMissoinByID(var_13_2.id) == EVENT_MISSION_STATE.COMPLETE then
				var_13_2.sort = iter_13_2 + 100
			end
			
			table.insert(var_13_0, var_13_2)
		end
	end
	
	table.sort(var_13_0, function(arg_14_0, arg_14_1)
		return arg_14_0.sort < arg_14_1.sort
	end)
	
	return var_13_0
end

function EventMissionUtil.getActiveMissionList(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:getEventTicket(arg_15_1)
	
	if not var_15_0 then
		return {}
	end
	
	local var_15_1 = {}
	local var_15_2 = var_15_0.day_count or 0
	
	for iter_15_0 = 1, var_15_2 do
		for iter_15_1, iter_15_2 in pairs(arg_15_0:getMissionList(arg_15_1, {
			day = iter_15_0
		})) do
			table.insert(var_15_1, iter_15_2)
		end
	end
	
	return var_15_1
end

function EventMissionUtil.getMaxRewardPoint(arg_16_0, arg_16_1)
	local var_16_0 = 0
	
	for iter_16_0 = 1, 99 do
		local var_16_1 = DBT("event_mission_day_reward", string.format("%s_mc_%02d", arg_16_1, iter_16_0), {
			"mission_count"
		})
		
		if not var_16_1 or not var_16_1.mission_count then
			break
		end
		
		var_16_0 = var_16_1.mission_count
	end
	
	return var_16_0
end

function EventMissionUtil.getEventScore(arg_17_0, arg_17_1)
	local var_17_0 = 0
	local var_17_1 = arg_17_0:getMissionList(arg_17_1)
	
	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		if Account:getStateEventMissoinByID(iter_17_1.id) == EVENT_MISSION_STATE.COMPLETE then
			var_17_0 = var_17_0 + 1
		end
	end
	
	return var_17_0
end

local function var_0_0(arg_18_0, arg_18_1)
	arg_18_0 = arg_18_0 or {}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0) do
		if Account:getStateEventMissoinByID(iter_18_1.id) == arg_18_1 then
			return true
		end
	end
	
	return false
end

function EventMissionUtil.isMissionRewardable(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0:isActiveEvent(arg_19_1) then
		return 
	end
	
	local var_19_0 = arg_19_0:getMissionList(arg_19_1, arg_19_2)
	
	return var_0_0(var_19_0, EVENT_MISSION_STATE.CLEAR)
end

function EventMissionUtil.isEventRewardable(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:getEventTicket(arg_20_1)
	
	if not var_20_0 then
		return 
	end
	
	local var_20_1 = arg_20_0:getEventScore(arg_20_1)
	local var_20_2 = var_20_0.reward_point
	
	for iter_20_0 = 1, 99 do
		local var_20_3 = DB("event_mission_day_reward", string.format("%s_mc_%02d", arg_20_1, iter_20_0), "mission_count")
		
		if not var_20_3 then
			break
		end
		
		if var_20_3 <= var_20_1 and var_20_2 < var_20_3 then
			return true
		end
	end
	
	return false
end

function EventMissionUtil.isShowRedDotEvent(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0:getActiveMissionList(arg_21_1)
	local var_21_1 = arg_21_0:isEventRewardable(arg_21_1)
	local var_21_2 = var_0_0(var_21_0, EVENT_MISSION_STATE.CLEAR)
	
	return var_21_1 or var_21_2
end

function EventMissionUtil.isShowRedDot(arg_22_0)
	local var_22_0 = arg_22_0:getEventTickets()
	
	if not var_22_0 or table.empty(var_22_0) then
		return 
	end
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if arg_22_0:isShowRedDotEvent(iter_22_1.event_id) then
			return true
		end
	end
	
	return false
end

function EventMissionUtil.setEventConfigData(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if not arg_23_2 then
		return 
	end
	
	if not arg_23_3 then
		return 
	end
	
	local var_23_0 = "event_mission." .. arg_23_1 .. "." .. arg_23_2
	
	SAVE:setTempConfigData(var_23_0, arg_23_3)
end

function EventMissionUtil.getEventConfigData(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_2 then
		return 
	end
	
	local var_24_0 = "event_mission." .. arg_24_1 .. "." .. arg_24_2
	
	return Account:getConfigData(var_24_0)
end

function EventMissionUtil.getEventTicket(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_2 and not arg_25_0:isActiveEvent(arg_25_1) then
		return 
	end
	
	return Account:getEventTicket(arg_25_1)
end

function EventMissionUtil.getEventTickets(arg_26_0)
	local var_26_0 = {}
	local var_26_1 = Account:getEventTickets() or {}
	
	for iter_26_0, iter_26_1 in pairs(var_26_1) do
		if arg_26_0:isActiveEvent(iter_26_1.event_id) then
			table.insert(var_26_0, iter_26_1)
		end
	end
	
	return var_26_0
end

function EventMissionUtil.popupEventEnd(arg_27_0, arg_27_1)
	if WebEventPopUp:isShow() then
		WebEventPopUp:close()
	end
	
	local var_27_0 = T(DB("event_mission_category", arg_27_1, "name"))
	
	Dialog:msgBox(T("em_mission_end_2"), {
		title = var_27_0
	})
end

function EventMissionUtil.isEventCompleted(arg_28_0, arg_28_1)
	local var_28_0 = Account:getEventTicket(arg_28_1)
	
	if not var_28_0 then
		return 
	end
	
	local var_28_1 = var_28_0.reward_point
	
	return arg_28_0:getMaxRewardPoint(arg_28_1) == var_28_1
end

function EventMissionUtil.isEventMissionEnabled(arg_29_0)
	return not ContentDisable:byAlias("event_mission")
end

function EventMissionUtil.set_bi_banner_data(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_30_0 = SceneManager:getRunningUIScene()
	local var_30_1 = arg_30_0:createEventBanner(arg_30_1)
	local var_30_2 = var_30_1:getChildByName("bi_img")
	
	arg_30_0:setDataUI(var_30_2, arg_30_2 .. ";" .. arg_30_3 .. ";" .. arg_30_4)
	
	local var_30_3 = {}
	
	table.push(var_30_3, {
		node = var_30_1,
		link = "epic7://webevent?event_mission=" .. arg_30_1
	})
	PromotionBanner:set(var_30_0:getChildByName("n_banner"), var_30_3)
end
