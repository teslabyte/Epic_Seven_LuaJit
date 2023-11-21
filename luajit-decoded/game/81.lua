FactionPoint = FactionPoint or {}
FACTION_POINT_MODE = {
	DAILY = "daily",
	WEEKLY = "weekly"
}
FACTION_POINT_DAILY_MAX = 100
FACTION_POINT_WEEKLY_MAX = 120
POINT_FACTION_ID = "sisters"

function MsgHandler.get_faction_point_reward(arg_1_0)
	local var_1_0 = FactionDetailPoint:isMaxConsumedPointByMode(FACTION_POINT_MODE.DAILY)
	
	AchievementBase:updateRewards(arg_1_0)
	Account:setFactionPoint(arg_1_0.point_info)
	
	local var_1_1 = arg_1_0.faction_rewards or {}
	
	for iter_1_0, iter_1_1 in pairs(var_1_1) do
		Account:setFactionExp(iter_1_0, iter_1_1.exp)
	end
	
	local var_1_2 = FactionDetailPoint:isMaxConsumedPointByMode(FACTION_POINT_MODE.DAILY)
	local var_1_3 = FactionDetailPoint:isMaxConsumedPointByMode(FACTION_POINT_MODE.WEEKLY)
	
	if var_1_0 == false and var_1_2 == true then
		ConditionContentsManager:dispatch("faction.max.daily")
	end
	
	FactionDetailPoint:updateRewardUI()
	
	if not var_1_2 and var_1_3 then
	end
	
	AchievementBase:updateUI()
end

function FactionPoint.getDB(arg_2_0)
	if not arg_2_0.vars then
		arg_2_0.vars = {}
	end
	
	if arg_2_0.vars.db then
		return arg_2_0.vars.db
	end
	
	arg_2_0.vars.db = {}
	
	local var_2_0 = POINT_FACTION_ID
	local var_2_1 = AchievementUtil:getAchieveRowMax()
	
	for iter_2_0 = 101, var_2_1 + 100 do
		local var_2_2 = 1
		local var_2_3 = string.format("%s_%03d", var_2_0, iter_2_0)
		local var_2_4 = string.format("%s_%02d", var_2_3, var_2_2)
		local var_2_5, var_2_6, var_2_7 = DB("achievement", var_2_4, {
			"id",
			"reset_time",
			"reward_count1"
		})
		
		if not var_2_5 then
			break
		end
		
		if not arg_2_0.vars.db[var_2_0] then
			arg_2_0.vars.db[var_2_0] = {}
		end
		
		arg_2_0.vars.db[var_2_0][var_2_5] = {
			id = var_2_5,
			reset_time = var_2_6,
			reward_count1 = var_2_7
		}
	end
	
	return arg_2_0.vars.db
end

function FactionPoint.getRewardDB(arg_3_0)
	if not arg_3_0.vars then
		arg_3_0.vars = {}
	end
	
	if arg_3_0.vars.reward_db then
		return arg_3_0.vars.reward_db
	end
	
	arg_3_0.vars.reward_db = {}
	
	for iter_3_0 = 1, 99 do
		local var_3_0, var_3_1, var_3_2, var_3_3, var_3_4 = DBN("achievement_point_reward", iter_3_0, {
			"id",
			"mission_type",
			"point",
			"reward_1",
			"value_1"
		})
		
		if not var_3_0 then
			break
		end
		
		if not arg_3_0.vars.reward_db[var_3_1] then
			arg_3_0.vars.reward_db[var_3_1] = {}
		end
		
		table.insert(arg_3_0.vars.reward_db[var_3_1], {
			id = var_3_0,
			mission_type = var_3_1,
			point = var_3_2,
			reward_1 = var_3_3,
			value_1 = var_3_4
		})
	end
	
	for iter_3_1, iter_3_2 in pairs(arg_3_0.vars.reward_db) do
		table.sort(iter_3_2, function(arg_4_0, arg_4_1)
			return arg_4_0.point < arg_4_1.point
		end)
	end
	
	return arg_3_0.vars.reward_db
end

function FactionPoint.getPoint(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:getDB()
	local var_5_1 = 0
	local var_5_2 = 0
	local var_5_3 = POINT_FACTION_ID
	
	if not var_5_0[var_5_3] then
		return var_5_1
	end
	
	for iter_5_0, iter_5_1 in pairs(var_5_0[var_5_3]) do
		if arg_5_1 == iter_5_1.reset_time then
			if Account:isClearedAchieve(iter_5_0) then
				var_5_1 = var_5_1 + iter_5_1.reward_count1
			end
			
			var_5_2 = var_5_2 + iter_5_1.reward_count1
		end
	end
	
	return var_5_1
end

function FactionPoint.getRewardAbleCnt(arg_6_0)
	local var_6_0 = arg_6_0:getDB()
	
	return FactionPoint:getRewardAbleCntByMode(FACTION_POINT_MODE.DAILY) + FactionPoint:getRewardAbleCntByMode(FACTION_POINT_MODE.WEEKLY)
end

function FactionPoint.getRewardAbleCntByMode(arg_7_0, arg_7_1)
	local var_7_0 = FactionPoint:getRewardDB()
	
	if not var_7_0 then
		return 0
	end
	
	local var_7_1 = var_7_0[arg_7_1]
	
	if not var_7_1 then
		return 0
	end
	
	local var_7_2 = arg_7_0:getPoint(arg_7_1)
	local var_7_3 = Account:getFactionPoint() or {}
	local var_7_4 = 0
	
	if arg_7_1 == FACTION_POINT_MODE.DAILY then
		var_7_4 = var_7_3.day_point or 0
	elseif arg_7_1 == FACTION_POINT_MODE.WEEKLY then
		var_7_4 = var_7_3.week_point or 0
	end
	
	local var_7_5 = 0
	
	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if var_7_4 < iter_7_1.point and var_7_2 >= iter_7_1.point then
			var_7_5 = var_7_5 + 1
		end
	end
	
	return var_7_5
end

FactionDetailPoint = FactionDetailPoint or {}

copy_functions(FactionDetail, FactionDetailPoint)

function FactionDetailPoint.clear(arg_8_0)
	arg_8_0.vars = {}
end

function FactionDetailPoint.init(arg_9_0)
	local var_9_0 = AchievementBase:getWnd()
	local var_9_1 = var_9_0:getChildByName("BASE_LEFT")
	
	arg_9_0.vars.n_point = var_9_1:getChildByName("n_point")
	
	local var_9_2 = var_9_0:getChildByName("BASE_RIGHT")
	
	arg_9_0.vars.n_category = var_9_2:getChildByName("n_category")
	
	local var_9_3 = var_9_0:getChildByName("BASE_CENTER")
	
	arg_9_0.vars.n_none = var_9_3:getChildByName("n_none")
	
	local var_9_4 = var_9_0:getChildByName("n_daily")
	
	arg_9_0:varPointUI(var_9_4, 10)
	
	local var_9_5 = var_9_0:getChildByName("n_weekly")
	
	arg_9_0:varPointUI(var_9_5, 12)
	arg_9_0:createFactionDetailView({})
	arg_9_0:setMode(FACTION_POINT_MODE.DAILY)
end

function FactionDetailPoint.varPointUI(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1:getChildByName("progress_bg")
	local var_10_1 = var_10_0:getContentSize().width
	local var_10_2 = var_10_0:getChildByName("Img_dot")
	
	for iter_10_0 = 1, arg_10_2 do
		local var_10_3 = var_10_0:getChildByName("n_" .. iter_10_0 * 10)
		
		if var_10_3 then
			local var_10_4 = var_10_2:getContentSize().width
			
			var_10_3:setPositionX(var_10_1 * (iter_10_0 / arg_10_2))
		end
	end
end

function FactionDetailPoint.updateModeUI(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.n_category) then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.n_point) then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.n_none) then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.n_category:getChildByName("n_point_tab1")
	local var_11_1 = arg_11_0.vars.n_category:getChildByName("n_point_tab2")
	local var_11_2 = FactionDetailPoint:getMode()
	
	if_set_visible(var_11_0, "n_selected1", var_11_2 == FACTION_POINT_MODE.DAILY)
	if_set_visible(var_11_1, "n_selected2", var_11_2 == FACTION_POINT_MODE.WEEKLY)
	if_set_visible(arg_11_0.vars.n_point, "n_daily", var_11_2 == FACTION_POINT_MODE.DAILY)
	if_set_visible(arg_11_0.vars.n_point, "n_weekly", var_11_2 == FACTION_POINT_MODE.WEEKLY)
	
	local var_11_3 = arg_11_0.vars.n_point:getChildByName("n_" .. var_11_2)
	local var_11_4 = FactionPoint:getRewardDB()[var_11_2]
	local var_11_5 = {}
	
	for iter_11_0, iter_11_1 in pairs(var_11_4) do
		var_11_5[tostring(iter_11_1.point)] = iter_11_1
	end
	
	for iter_11_2 = 1, 12 do
		local var_11_6 = var_11_3:getChildByName("n_" .. iter_11_2 * 10)
		local var_11_7 = var_11_5[tostring(iter_11_2 * 10)]
		
		if var_11_6 and var_11_7 then
			var_11_6:getChildByName("btn_point_reward").reward_db = var_11_7
		end
	end
	
	arg_11_0:updateRewardUI()
end

function FactionDetailPoint.onUpdateUI(arg_12_0)
	arg_12_0:refreshCenterView()
	arg_12_0:updateRewardUI()
end

function FactionDetailPoint.updateRewardUI(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.n_category) then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.n_point) then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.n_none) then
		return 
	end
	
	local var_13_0 = FactionDetailPoint:getMode()
	local var_13_1 = FactionPoint:getRewardDB()[var_13_0]
	
	if not var_13_1 then
		return 
	end
	
	local var_13_2 = arg_13_0.vars.n_point:getChildByName("n_" .. var_13_0)
	local var_13_3 = FactionPoint:getPoint(var_13_0)
	
	if_set(var_13_2, "txt_count", var_13_3)
	
	local var_13_4 = Account:getFactionPoint() or {}
	local var_13_5 = 0
	local var_13_6 = 0
	
	if var_13_0 == FACTION_POINT_MODE.DAILY then
		var_13_5 = var_13_4.day_point or 0
		var_13_6 = FACTION_POINT_DAILY_MAX
	elseif var_13_0 == FACTION_POINT_MODE.WEEKLY then
		var_13_5 = var_13_4.week_point or 0
		var_13_6 = FACTION_POINT_WEEKLY_MAX
	end
	
	local var_13_7 = {}
	
	for iter_13_0, iter_13_1 in pairs(var_13_1) do
		local var_13_8 = var_13_2:getChildByName("n_" .. iter_13_1.point)
		
		if get_cocos_refid(var_13_8) then
			local var_13_9 = var_13_8:getChildByName("n_icon")
			
			var_13_9:removeAllChildren()
			UIUtil:getRewardIcon(iter_13_1.value_1, iter_13_1.reward_1, {
				parent = var_13_9
			})
			
			local var_13_10 = var_13_8:getChildByName("btn_point_reward")
			
			if_set_visible(var_13_8, "img_noti", var_13_3 >= iter_13_1.point and var_13_5 < iter_13_1.point)
			
			if get_cocos_refid(var_13_10) and var_13_3 < iter_13_1.point then
				var_13_10:setColor(cc.c3b(136, 136, 136))
			else
				var_13_10:setColor(cc.c3b(255, 255, 255))
			end
			
			if get_cocos_refid(var_13_10) and var_13_5 >= iter_13_1.point then
				var_13_10:setOpacity(76.5)
				if_set_visible(var_13_8, "icon_check", true)
			end
			
			var_13_7[tostring(iter_13_1.point)] = iter_13_1
		end
	end
	
	local var_13_11 = var_13_2:findChildByName("progress_bg")
	
	if var_13_11 then
		local var_13_12 = var_13_11:getContentSize()
		local var_13_13 = var_13_11:findChildByName("progress_bar")
		
		var_13_13:setPositionX(var_13_12.width / 2)
		if_set_percent(var_13_13, nil, var_13_3 / var_13_6)
	end
	
	local var_13_14 = FactionPoint:getRewardAbleCntByMode(FACTION_POINT_MODE.DAILY)
	local var_13_15 = FactionPoint:getRewardAbleCntByMode(FACTION_POINT_MODE.WEEKLY)
	local var_13_16 = arg_13_0.vars.n_category:getChildByName("n_point_tab1")
	local var_13_17 = arg_13_0.vars.n_category:getChildByName("n_point_tab2")
	
	if_set_visible(var_13_16, "img_noti", var_13_14 > 0)
	if_set_visible(var_13_17, "img_noti", var_13_15 > 0)
	
	local var_13_18 = FactionDetailPoint:isMaxConsumedPointByMode(var_13_0)
	
	arg_13_0.vars.n_none:setVisible(var_13_18)
	
	local var_13_19 = AchievementBase:getWnd():getChildByName("BASE_CENTER")
	
	if_set_visible(var_13_19, "listview_vary", not var_13_18)
	
	if var_13_18 then
		if var_13_0 == FACTION_POINT_MODE.DAILY then
			if_set(arg_13_0.vars.n_none, "txt_info", T("ui_complete_daily_achievement"))
		else
			if_set(arg_13_0.vars.n_none, "txt_info", T("ui_complete_weekly_achievement"))
		end
		
		if_set_sprite(arg_13_0.vars.n_none, "icon", "emblem/fa_em_ap_" .. var_13_0 .. ".png")
	end
end

function FactionDetailPoint.query(arg_14_0, arg_14_1)
	local var_14_0 = FactionDetailPoint:getMode()
	
	if arg_14_0:isMaxConsumedPointByMode(var_14_0) then
		balloon_message_with_sound("get_faction_point_reward.get_all")
		
		return 
	end
	
	if FactionPoint:getPoint(var_14_0) >= arg_14_1.point then
		query("get_faction_point_reward", {
			reward_id = arg_14_1.id,
			mode = var_14_0
		})
	else
		balloon_message_with_sound("msg_achieve_point_lack")
	end
end

function FactionDetailPoint.isMaxConsumedPointByMode(arg_15_0, arg_15_1)
	local var_15_0 = Account:getFactionPoint() or {}
	
	if arg_15_1 == FACTION_POINT_MODE.DAILY then
		return (var_15_0.day_point or 0) >= FACTION_POINT_DAILY_MAX
	else
		return (var_15_0.week_point or 0) >= FACTION_POINT_WEEKLY_MAX
	end
end

function FactionDetailPoint.createFactionDetailView(arg_16_0, arg_16_1)
	local var_16_0 = AchievementBase:getWnd():getChildByName("listview_vary")
	
	arg_16_0.vars.itemView = ItemListView_v2:bindControl(var_16_0)
	
	local var_16_1 = load_control("wnd/archievement_item.csb")
	
	if var_16_0.STRETCH_INFO then
		local var_16_2 = var_16_0:getContentSize()
		
		resetControlPosAndSize(var_16_1, var_16_2.width, var_16_0.STRETCH_INFO.width_prev)
	end
	
	local var_16_3 = {
		onUpdate = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			arg_16_0:updateScrollViewItem(arg_17_1, arg_17_3)
			
			return arg_17_3.id
		end
	}
	
	arg_16_0.vars.itemView:setRenderer(var_16_1, var_16_3)
	arg_16_0.vars.itemView:removeAllChildren()
	arg_16_0.vars.itemView:setDataSource(arg_16_1)
	arg_16_0.vars.itemView:jumpToTop()
end

function FactionDetailPoint.sort(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return 
	end
	
	local var_18_0 = {
		[0] = 2,
		1,
		0
	}
	
	table.sort(arg_18_1, function(arg_19_0, arg_19_1)
		local var_19_0 = Account:getFactionGroupInfo(arg_19_0.faction_id, arg_19_0.group_id)
		local var_19_1 = Account:getFactionGroupInfo(arg_19_1.faction_id, arg_19_1.group_id)
		local var_19_2 = var_19_0.state or 0
		local var_19_3 = var_19_1.state or 0
		
		if var_19_2 == var_19_3 then
			return arg_19_0.sort < arg_19_1.sort
		else
			return var_18_0[var_19_2] > var_18_0[var_19_3]
		end
	end)
end

function FactionDetailPoint.setMode(arg_20_0, arg_20_1)
	if arg_20_0.vars.mode == arg_20_1 then
		return 
	end
	
	arg_20_0.vars.mode = arg_20_1
	
	arg_20_0:updateModeUI()
	
	return true
end

function FactionDetailPoint.getMode(arg_21_0)
	return arg_21_0.vars.mode or FACTION_POINT_MODE.DAILY
end

function FactionDetailPoint.selectCategory(arg_22_0, arg_22_1)
	local var_22_0 = AchievementBase:getWnd()
	
	if not get_cocos_refid(var_22_0) then
		return 
	end
	
	local var_22_1 = arg_22_0:getMode()
	local var_22_2 = FactionDetailPoint:isMaxConsumedPointByMode(var_22_1)
	local var_22_3 = var_22_0:getChildByName("BASE_LEFT")
	local var_22_4 = var_22_0:getChildByName("BASE_CENTER")
	local var_22_5 = var_22_0:getChildByName("BASE_RIGHT")
	
	if_set_visible(var_22_4, "listview_vary", not var_22_2)
	if_set_visible(var_22_3, "n_point", true)
	if_set_visible(var_22_5, "n_category", true)
	if_set_visible(var_22_4, "listview", false)
	if_set_visible(var_22_0, "n_dagger", false)
	var_22_4:setVisible(true)
	var_22_3:setVisible(true)
	arg_22_0:setModeData(arg_22_1)
	arg_22_0:updateModeUI()
end

function FactionDetailPoint.setModeData(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or AchievementBase:getAchieveDataListByFactionID(POINT_FACTION_ID)
	
	if FactionDetailPoint:isMaxConsumedPointByMode(arg_23_0.vars.mode) then
		return 
	end
	
	local var_23_0 = {}
	
	for iter_23_0, iter_23_1 in pairs(arg_23_1) do
		if iter_23_1.reset_time == arg_23_0.vars.mode then
			table.insert(var_23_0, iter_23_1)
		end
	end
	
	arg_23_0:sort(var_23_0)
	arg_23_0:setDataSource(var_23_0)
	arg_23_0:refreshCenterView()
	arg_23_0:jumpToTop()
end

function FactionDetail.setDataSource(arg_24_0, arg_24_1)
	arg_24_0:sort(arg_24_1)
	arg_24_0.vars.itemView:setDataSource(arg_24_1)
end
