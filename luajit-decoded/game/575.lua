ClanWeeklyAchieve = {}
CLAN_WEEKLY_ACHIEVE_STATE = {}
CLAN_WEEKLY_ACHIEVE_STATE.active = 0
CLAN_WEEKLY_ACHIEVE_STATE.clear = 1
CLAN_WEEKLY_ACHIEVE_STATE.complete = 2

local var_0_0 = 2800

function HANDLER.clan_weekly_mission(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		if arg_1_0.state == CLAN_WEEKLY_ACHIEVE_STATE.active and arg_1_0.move then
			movetoPath(arg_1_0.move)
		elseif arg_1_0.state == CLAN_WEEKLY_ACHIEVE_STATE.clear then
			query("clear_clan_weekly_achieve", {
				contents_id = arg_1_0.contents_id
			})
		end
	elseif arg_1_1 == "btn_point_reward" then
		ClanWeeklyAchieve:queryPointReward()
	end
end

function MsgHandler.clear_clan_weekly_achieve(arg_2_0)
	local var_2_0 = {
		title = T("clear_clan_weekly_achieve_title"),
		desc = T("clear_clan_weekly_achieve_reward_msg")
	}
	
	Account:addReward(arg_2_0.rewards, {
		play_reward_data = var_2_0
	})
	Clan:updateCurrencies(arg_2_0)
	Clan:updateInfo(arg_2_0)
	TopBarNew:topbarUpdate(true)
	Account:setClanMission(arg_2_0.mission_id, arg_2_0.doc_clan_misison)
	ClanWeeklyAchieve:updateStateWeeklyMissionData(arg_2_0.mission_id, arg_2_0.doc_clan_misison.state)
	ClanWeeklyAchieve:refresh()
	ClanCategory:updateScrollView()
	ClanWeeklyAchieve:updateRewardUI()
end

function MsgHandler.test_set_clan_weekly_mission_reward_point(arg_3_0)
	Account:updateClanWeekMissionRewardInfo(arg_3_0.reward_info)
end

function MsgHandler.test_change_clan_weekly_mission(arg_4_0)
	if arg_4_0.clan_mission_attrbutes then
		Account:resetConditonsByContentsType()
		Account:setClanMissions(arg_4_0.clan_mission_attrbutes)
	end
end

function MsgHandler.clan_weekly_mission_point_reward(arg_5_0)
	local var_5_0 = {
		title = T("ui_clan_misson_clanpoint_reward_name"),
		desc = T("ui_clan_misson_clanpoint_reward_desc")
	}
	local var_5_1 = Account:addReward(arg_5_0.rewards, {
		play_reward_data = var_5_0
	})
	
	if get_cocos_refid(var_5_1.reward_dlg) then
		local var_5_2 = var_5_1.reward_dlg:getChildByName("n_top")
		
		if get_cocos_refid(var_5_2) then
			if_set(var_5_2, "txt_title", var_5_0.title)
		end
	end
	
	if arg_5_0.reward_info then
		Account:updateClanWeekMissionRewardInfo(arg_5_0.reward_info)
	end
	
	ClanCategory:updateScrollView()
	ClanWeeklyAchieve:updateRewardUI()
end

function MsgHandler.get_clan_prev_weekly_mission_reward(arg_6_0)
	local var_6_0 = {
		title = T("ui_clan_misson_clanpoint_reward_name"),
		desc = T("ui_clan_misson_clanpoint_beforereward_desc")
	}
	local var_6_1 = Account:addReward(arg_6_0.rewards, {
		play_reward_data = var_6_0
	})
	
	if var_6_1 and get_cocos_refid(var_6_1.reward_dlg) then
		local var_6_2 = var_6_1.reward_dlg:getChildByName("n_top")
		
		if get_cocos_refid(var_6_2) then
			if_set(var_6_2, "txt_title", var_6_0.title)
		end
	end
	
	if arg_6_0.reward_info then
		Account:updateClanWeekMissionRewardInfo(arg_6_0.reward_info)
	end
	
	ClanCategory:updateScrollView()
end

function ClanWeeklyAchieve.show(arg_7_0, arg_7_1)
	arg_7_0.vars = {}
	arg_7_1 = arg_7_1 or SceneManager:getDefaultLayer()
	arg_7_0.vars.parents = arg_7_1
	arg_7_0.vars.wnd = Dialog:open("wnd/clan_weekly_mission", arg_7_0, {
		use_backbutton = false
	})
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("listview")
	
	arg_7_0.vars.itemView = ItemListView_v2:bindControl(var_7_0)
	arg_7_0.vars.n_point = arg_7_0.vars.wnd:getChildByName("n_point")
	arg_7_0.vars.data = arg_7_0:getWeeklyDataList()
	
	local var_7_1 = load_control("wnd/clan_weekly_mission_item.csb")
	
	if var_7_0.STRETCH_INFO then
		local var_7_2 = var_7_0:getContentSize()
		
		resetControlPosAndSize(var_7_1, var_7_2.width, var_7_0.STRETCH_INFO.width_prev)
	end
	
	local var_7_3 = {
		onUpdate = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			ClanWeeklyAchieve:updateItem(arg_8_1, arg_8_3)
			
			return arg_8_3.id
		end
	}
	
	arg_7_0.vars.itemView:setRenderer(var_7_1, var_7_3)
	arg_7_0.vars.itemView:removeAllChildren()
	arg_7_0.vars.itemView:setDataSource(arg_7_0.vars.data)
	
	local var_7_4, var_7_5, var_7_6 = Account:serverTimeWeekLocalDetail()
	
	if_set(arg_7_0.vars.wnd, "remain_time", sec_to_string(var_7_6 - os.time()))
	arg_7_0:varPointUI()
	arg_7_0:updateRewardUI()
	
	if Clan:isRewardablePrevClanWeeklyMission() then
		query("get_clan_prev_weekly_mission_reward")
	end
	
	return arg_7_0.vars.wnd
end

function ClanWeeklyAchieve.updateItem(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1:getChildByName("txt_title")
	
	if_set(var_9_0, nil, T(arg_9_2.name))
	
	if DEBUG.DEBUG_MAP_ID then
		if_set(var_9_0, nil, T(arg_9_2.id))
	end
	
	UIUserData:call(var_9_0, "SINGLE_WSCALE(330)", {
		origin_scale_x = 0.73
	})
	if_set(arg_9_1, "t_desc", T(arg_9_2.desc))
	
	local var_9_1 = ConditionContentsManager:getClanMissions():getScore(arg_9_2.id)
	local var_9_2 = totable(arg_9_2.value).count
	
	if_set(arg_9_1, "txt_progress", comma_value(var_9_1) .. " / " .. comma_value(var_9_2))
	if_set_percent(arg_9_1, "progress", var_9_1 / var_9_2)
	
	local var_9_3 = arg_9_1:getChildByName("n_member_reward1")
	local var_9_4 = arg_9_1:getChildByName("n_member_reward2")
	local var_9_5 = 255
	
	if arg_9_2.state == CLAN_WEEKLY_ACHIEVE_STATE.complete then
		var_9_5 = 76.5
	end
	
	local var_9_6 = {
		scale = 0.65,
		grade_max = true,
		parent = var_9_3,
		set_drop = arg_9_2.drop_rate_id1,
		grade_rate = arg_9_2.grade_rate1
	}
	local var_9_7 = {
		scale = 0.65,
		grade_max = true,
		parent = var_9_4,
		set_drop = arg_9_2.drop_rate_id2,
		grade_rate = arg_9_2.grade_rate2
	}
	
	UIUtil:getRewardIcon(arg_9_2.reward_count1 or 1, arg_9_2.reward_id1, var_9_6):setOpacity(var_9_5)
	UIUtil:getRewardIcon(arg_9_2.reward_count2 or 1, arg_9_2.reward_id2, var_9_7):setOpacity(var_9_5)
	
	local var_9_8 = arg_9_1:getChildByName("n_clan_reward1")
	local var_9_9 = arg_9_1:getChildByName("n_clan_reward2")
	
	UIUtil:getRewardIcon(arg_9_2.clan_reward_count1 or 1, arg_9_2.clan_reward_id1, {
		scale = 0.65,
		parent = var_9_8
	}):setOpacity(var_9_5)
	UIUtil:getRewardIcon(arg_9_2.clan_reward_count2 or 1, arg_9_2.clan_reward_id2, {
		custom_v2_desc = "ctp_clanpoint_tde",
		img = "ma_clanpoint",
		custom_v2 = "ctp_clanpoint_tl",
		scale = 0.65,
		custom_v2_category = "category_clanpoint",
		parent = var_9_9
	}):setOpacity(var_9_5)
	
	local var_9_10 = arg_9_1:getChildByName("btn_go")
	
	var_9_10.state = arg_9_2.state
	var_9_10.move = arg_9_2.btn_move
	var_9_10.contents_id = arg_9_2.id
	
	UIUtil:setColorRewardButtonState(var_9_10.state, arg_9_1, var_9_10, {
		add_x_clear = 8
	})
	arg_9_1:getChildByName("n_complet"):setVisible(arg_9_2.state == CLAN_WEEKLY_ACHIEVE_STATE.complete)
	
	if arg_9_2.state == CLAN_WEEKLY_ACHIEVE_STATE.complete then
		local var_9_11 = arg_9_1:getChildByName("n_card")
		
		if_set_opacity(var_9_11, nil, 76.5)
	end
end

function ClanWeeklyAchieve.sortData(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return 
	end
	
	local var_10_0 = {}
	
	var_10_0[0] = 2
	var_10_0[1] = 1
	var_10_0[2] = 3
	
	table.sort(arg_10_1, function(arg_11_0, arg_11_1)
		local var_11_0 = var_10_0[arg_11_0.state] or 0
		local var_11_1 = var_10_0[arg_11_1.state] or 0
		
		if var_11_0 == var_11_1 then
			return arg_11_0.sort < arg_11_1.sort
		else
			return var_11_0 < var_11_1
		end
	end)
	
	return arg_10_1
end

function ClanWeeklyAchieve.refresh(arg_12_0)
	arg_12_0.vars.data = arg_12_0:sortData(arg_12_0.vars.data)
	
	arg_12_0.vars.itemView:refresh()
end

function ClanWeeklyAchieve.getWeeklyDataList(arg_13_0)
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(Account:getClanMissions()) do
		local var_13_1 = Account:serverTimeWeekLocalDetail()
		local var_13_2 = DBT("clan_mission", iter_13_0, {
			"id",
			"name",
			"desc",
			"condition",
			"value",
			"reward_id1",
			"reward_count1",
			"grade_rate1",
			"set_drop_rate_id1",
			"reward_id2",
			"reward_count2",
			"set_drop_rate_id2",
			"clan_reward_id1",
			"clan_reward_count1",
			"clan_reward_id2",
			"clan_reward_count2",
			"btn_move",
			"sort"
		})
		
		if var_13_2.id and tonumber(iter_13_1.clan_id) == tonumber(Account:getClanId()) and tonumber(iter_13_1.week_id) == tonumber(var_13_1) then
			var_13_2.state = iter_13_1.state
			
			table.insert(var_13_0, var_13_2)
		end
	end
	
	return (arg_13_0:sortData(var_13_0))
end

function ClanWeeklyAchieve.updateStateWeeklyMissionData(arg_14_0, arg_14_1, arg_14_2)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.data) do
		if iter_14_1.id == arg_14_1 then
			arg_14_0.vars.data[iter_14_0].state = arg_14_2
			
			break
		end
	end
end

function ClanWeeklyAchieve.isCleared(arg_15_0, arg_15_1, arg_15_2)
	arg_15_2 = arg_15_2 or {}
	
	local var_15_0 = Account:getClanMission(arg_15_1)
	
	if var_15_0 and var_15_0.state >= 1 then
		return true
	end
	
	return false
end

function ClanWeeklyAchieve.getRewardDB(arg_16_0)
	local var_16_0 = {}
	
	for iter_16_0 = 1, 999 do
		local var_16_1, var_16_2, var_16_3, var_16_4 = DBN("clan_mission_point_reward", iter_16_0, {
			"id",
			"point",
			"reward_1",
			"value_1"
		})
		
		if not var_16_1 then
			break
		end
		
		table.insert(var_16_0, {
			id = var_16_1,
			point = var_16_2,
			reward_1 = var_16_3,
			value_1 = var_16_4
		})
	end
	
	table.sort(var_16_0, function(arg_17_0, arg_17_1)
		return arg_17_0.point < arg_17_1.point
	end)
	
	return var_16_0
end

function ClanWeeklyAchieve.varPointUI(arg_18_0)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_weekly"):getChildByName("progress_bg")
	local var_18_1 = var_18_0:getContentSize().width
	local var_18_2 = var_18_0:getChildByName("Img_dot")
	
	for iter_18_0 = 0, 28 do
		local var_18_3 = var_18_0:getChildByName("n_" .. iter_18_0 * 100)
		
		if var_18_3 then
			local var_18_4 = var_18_2:getContentSize().width
			
			var_18_3:setPositionX(var_18_1 * (iter_18_0 / 28))
		end
	end
end

function ClanWeeklyAchieve.queryPointReward(arg_19_0)
	local var_19_0 = Account:serverTimeWeekLocalDetail()
	
	if (Clan:getClanInfo() or {}).week_id ~= var_19_0 then
		balloon_message_with_sound("get_clanpoint_reward.get_lack")
		
		return 
	end
	
	if Clan:getWeekMissionRewardPoint() >= var_0_0 then
		balloon_message_with_sound("get_clanpoint_reward.get_all")
		
		return 
	end
	
	if ClanUtil:getWeekyMissionRewardableItemCnt() <= 0 then
		balloon_message_with_sound("get_clanpoint_reward.get_lack")
		
		return 
	end
	
	query("clan_weekly_mission_point_reward")
end

function ClanWeeklyAchieve.updateRewardUI(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_20_0.vars.n_point) then
		return 
	end
	
	local var_20_0 = ClanWeeklyAchieve:getRewardDB()
	
	if not var_20_0 then
		return 
	end
	
	local var_20_1 = arg_20_0.vars.n_point:getChildByName("n_weekly")
	local var_20_2 = Clan:getWeekMissionPoint()
	
	if_set(var_20_1, "txt_count", var_20_2)
	
	local var_20_3 = Clan:getWeekMissionRewardPoint()
	local var_20_4 = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		local var_20_5 = var_20_1:getChildByName("n_" .. tostring(iter_20_1.point))
		
		if get_cocos_refid(var_20_5) then
			local var_20_6 = var_20_5:getChildByName("n_icon")
			
			var_20_6:removeAllChildren()
			UIUtil:getRewardIcon(iter_20_1.value_1, iter_20_1.reward_1, {
				parent = var_20_6
			})
			
			local var_20_7 = var_20_5:getChildByName("btn_point_reward")
			
			if_set_visible(var_20_5, "img_noti", var_20_2 >= iter_20_1.point and var_20_3 < iter_20_1.point)
			if_set(var_20_5, "txt", iter_20_1.point)
			
			if get_cocos_refid(var_20_7) and var_20_2 < iter_20_1.point then
				var_20_7:setColor(cc.c3b(136, 136, 136))
			else
				var_20_7:setColor(cc.c3b(255, 255, 255))
			end
			
			if get_cocos_refid(var_20_7) and var_20_3 >= iter_20_1.point then
				var_20_7:setOpacity(76.5)
				if_set_visible(var_20_5, "icon_check", true)
			end
			
			var_20_4[tostring(iter_20_1.point)] = iter_20_1
		end
	end
	
	local var_20_8 = var_20_1:findChildByName("progress_bg")
	
	if var_20_8 then
		local var_20_9 = var_20_8:getContentSize()
		local var_20_10 = var_20_8:findChildByName("progress_bar")
		
		var_20_10:setPositionX(var_20_9.width / 2)
		if_set_percent(var_20_10, nil, var_20_2 / var_0_0)
	end
end

ClanAchieve = {}

function ClanAchieve.show(arg_21_0, arg_21_1)
	arg_21_0.vars = {}
	arg_21_0.vars.parents = arg_21_1
	arg_21_0.vars.wnd = Dialog:open("wnd/clan_feat", arg_21_0)
	
	return arg_21_0.vars.wnd
end
