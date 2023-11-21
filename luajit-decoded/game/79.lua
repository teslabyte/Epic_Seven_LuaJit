FactionDetail = FactionDetail or {}
AchieveGroupPopup = {}

copy_functions(ScrollView, FactionDetail)

function HANDLER.achieve_get(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		AchievementBase:closeAchieveReward()
	end
end

function HANDLER.achieve_detail(arg_2_0, arg_2_1)
	if UIAction:Find("block") then
		return 
	end
	
	if string.starts(arg_2_1, "btn_close") then
		AchieveGroupPopup:close()
	end
end

function MsgHandler.clear_achievement(arg_3_0)
	local var_3_0 = ConditionContentsManager:getAchievement()
	
	if arg_3_0.clear_condition_group then
		var_3_0:setConditionGroupData(arg_3_0.group_id, arg_3_0.clear_condition_group)
	end
	
	local var_3_1 = arg_3_0.faction_rewards or {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		Account:setFactionExp(iter_3_0, iter_3_1.exp)
	end
	
	if arg_3_0.faction_group then
		Account:setFactionGroupInfo(arg_3_0.faction_group.faction_id, arg_3_0.faction_group.group_id, arg_3_0.faction_group)
	end
	
	Achievement:addConditionListner(arg_3_0.faction_id, arg_3_0.group_id)
	AchievementBase:updateAchieveData(arg_3_0.faction_id, arg_3_0.group_id)
	AchievementBase:updateRewards(arg_3_0)
	ConditionContentsManager:achievementClearForceUpdateConditions(arg_3_0.faction_group.faction_id, arg_3_0.faction_group.group_id)
end

function MsgHandler.clear_achievement_all(arg_4_0)
	local var_4_0
	
	if arg_4_0.init_condition_groups then
		var_4_0 = ConditionContentsManager:getAchievement()
		
		if var_4_0 then
			for iter_4_0, iter_4_1 in pairs(arg_4_0.init_condition_groups) do
				var_4_0:setConditionGroupData(iter_4_0, iter_4_1)
			end
		end
	end
	
	for iter_4_2, iter_4_3 in pairs(arg_4_0.faction_rewards or {}) do
		Account:setFactionExp(iter_4_2, iter_4_3.exp)
	end
	
	for iter_4_4, iter_4_5 in pairs(arg_4_0.faction_groups or {}) do
		local var_4_1 = iter_4_5.faction_id
		local var_4_2 = iter_4_5.group_id
		
		Account:setFactionGroupInfo(var_4_1, var_4_2, iter_4_5)
		Achievement:addConditionListner(var_4_1, var_4_2)
		AchievementBase:updateAchieveData(var_4_1, var_4_2)
	end
	
	AchievementBase:updateRewards(arg_4_0, true)
	
	for iter_4_6, iter_4_7 in pairs(arg_4_0.faction_groups or {}) do
		ConditionContentsManager:achievementClearForceUpdateConditions(iter_4_7.faction_id, iter_4_7.group_id)
	end
end

function MsgHandler.force_clear_achievement(arg_5_0)
	for iter_5_0, iter_5_1 in pairs(arg_5_0.infos or {}) do
		Account:setFactionGroupInfo(iter_5_1.faction_id, iter_5_1.group_id, iter_5_1)
	end
	
	FactionDetail:sort()
	FactionDetail:refreshCenterView()
end

function FactionDetail.init(arg_6_0)
	arg_6_0.vars = {}
	
	arg_6_0:createFactionDetailView({})
end

function FactionDetail.clear(arg_7_0)
	arg_7_0.vars = nil
end

function FactionDetail.selectCategory(arg_8_0, arg_8_1)
	local var_8_0 = AchievementBase:getWnd()
	
	if not get_cocos_refid(var_8_0) then
		return 
	end
	
	local var_8_1 = var_8_0:getChildByName("BASE_LEFT")
	local var_8_2 = var_8_0:getChildByName("BASE_CENTER")
	local var_8_3 = var_8_0:getChildByName("BASE_RIGHT")
	
	if_set_visible(var_8_2, "listview_vary", false)
	if_set_visible(var_8_1, "n_point", false)
	if_set_visible(var_8_3, "n_category", false)
	if_set_visible(var_8_2, "n_none", false)
	if_set_visible(var_8_2, "listview", true)
	if_set_visible(var_8_0, "n_dagger", false)
	var_8_2:setVisible(true)
	var_8_1:setVisible(true)
	arg_8_0:setDataSource(arg_8_1)
	arg_8_0:refreshCenterView()
	arg_8_0:jumpToTop()
	
	local var_8_4 = AchievementBase:getFactionID()
	
	ConditionContentsManager:factionCategoryForceUpdateConditoins(var_8_4, arg_8_1)
end

function FactionDetail.setDataSource(arg_9_0, arg_9_1)
	arg_9_0:sort()
	arg_9_0.vars.itemView:setDataSource(arg_9_1)
end

function FactionDetail.sort(arg_10_0)
	local var_10_0 = AchievementBase:getCurrentAchieveDatas()
	local var_10_1 = {
		[0] = 1,
		2,
		0
	}
	
	table.sort(var_10_0, function(arg_11_0, arg_11_1)
		local var_11_0 = Account:getFactionGroupInfo(arg_11_0.faction_id, arg_11_0.group_id)
		local var_11_1 = Account:getFactionGroupInfo(arg_11_1.faction_id, arg_11_1.group_id)
		local var_11_2 = var_11_0.state or 0
		
		if arg_11_0.hold then
			var_11_2 = 2
		end
		
		local var_11_3 = var_11_1.state or 0
		
		if arg_11_1.hold then
			var_11_3 = 2
		end
		
		if var_11_2 == var_11_3 then
			return arg_11_0.sort < arg_11_1.sort
		else
			return var_10_1[var_11_2] > var_10_1[var_11_3]
		end
	end)
end

function FactionDetail.refreshCenterView(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.itemView) then
		return 
	end
	
	arg_12_0.vars.itemView:refresh()
end

function FactionDetail.jumpToTop(arg_13_0)
	arg_13_0.vars.itemView:jumpToTop()
end

function FactionDetail.createFactionDetailView(arg_14_0, arg_14_1)
	local var_14_0 = AchievementBase:getWnd():getChildByName("listview")
	
	arg_14_0.vars.itemView = ItemListView_v2:bindControl(var_14_0)
	
	local var_14_1 = load_control("wnd/archievement_item.csb")
	
	if var_14_0.STRETCH_INFO then
		local var_14_2 = var_14_0:getContentSize()
		
		resetControlPosAndSize(var_14_1, var_14_2.width, var_14_0.STRETCH_INFO.width_prev)
	end
	
	local var_14_3 = {
		onUpdate = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			arg_14_0:updateScrollViewItem(arg_15_1, arg_15_3)
			
			return arg_15_3.id
		end
	}
	
	arg_14_0.vars.itemView:setRenderer(var_14_1, var_14_3)
	arg_14_0.vars.itemView:removeAllChildren()
	arg_14_0.vars.itemView:setDataSource(arg_14_1)
	arg_14_0.vars.itemView:jumpToTop()
end

function FactionDetail.updateScrollViewItem(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = Account:getFactionGroupInfo(arg_16_2.faction_id, arg_16_2.group_id) or {}
	local var_16_1 = ConditionContentsManager:getAchievement()
	local var_16_2 = arg_16_2.group
	local var_16_3 = var_16_1:getScore(arg_16_2.group_id)
	local var_16_4 = var_16_0.state or 0
	local var_16_5 = arg_16_2.value_data.count or 1
	local var_16_6 = 255
	local var_16_7 = 255
	local var_16_8 = arg_16_2.faction_id == POINT_FACTION_ID
	local var_16_9 = var_16_4
	
	if var_16_8 and var_16_4 == 1 then
		var_16_9 = 2
	end
	
	if arg_16_2.hold then
		var_16_9 = 2
	end
	
	if var_16_9 == 2 then
		var_16_6 = 76.5
	end
	
	if var_16_9 == 2 then
		var_16_7 = 76.5
	end
	
	if_set_sprite(arg_16_1, "img_face", "face/" .. arg_16_2.icon .. "_s.png")
	if_set_opacity(arg_16_1, "n_face", var_16_7)
	if_set_opacity(arg_16_1, "txt_time", var_16_7)
	
	local var_16_10 = arg_16_1:getChildByName("n_reward1")
	local var_16_11 = arg_16_1:getChildByName("n_reward2")
	local var_16_12
	local var_16_13 = T("category_achieve_point")
	
	if arg_16_2.reset_time then
		var_16_13 = T("category_achieve_point2")
	end
	
	if arg_16_2.reward_id1 then
		local var_16_14 = arg_16_2.faction_id
		
		if arg_16_2.reset_time then
			var_16_14 = "ap_" .. arg_16_2.reset_time
		end
		
		local var_16_15 = {
			icon_scale = 0.4,
			grade_max = true,
			parent = var_16_10,
			faction = var_16_14,
			faction_category = var_16_13,
			set_drop = arg_16_2.drop_rate_id1,
			grade_rate = arg_16_2.grade_rate1
		}
		local var_16_16 = UIUtil:getRewardIcon(tonumber(arg_16_2.reward_count1) or 1, arg_16_2.reward_id1, var_16_15)
	end
	
	if arg_16_2.reward_id2 then
		local var_16_17 = string.split(arg_16_2.reward_id2, "_")[1]
		
		if var_16_17 == "to" then
			local var_16_18 = UIUtil:getRewardIcon(tonumber(arg_16_2.reward_count2) or 1, arg_16_2.reward_id2, {
				parent = var_16_11
			})
		elseif DB("character", var_16_17, "id") then
			local var_16_19 = UIUtil:getRewardIcon("c", arg_16_2.reward_id2, {
				parent = var_16_11
			})
		else
			local var_16_20 = {
				grade_max = true,
				parent = var_16_11,
				set_drop = arg_16_2.drop_rate_id2,
				grade_rate = arg_16_2.grade_rate2
			}
			local var_16_21 = UIUtil:getRewardIcon(tonumber(arg_16_2.reward_count2), arg_16_2.reward_id2, var_16_20)
		end
	end
	
	local var_16_22
	local var_16_25, var_16_26
	
	if arg_16_2.value_data.group then
		var_16_22 = true
		
		local var_16_23 = arg_16_1:getChildByName("btn_detail_list")
		
		if var_16_23 then
			var_16_23.idx = arg_16_2.id
		end
		
		local var_16_24 = {}
		
		table.insert(var_16_24, "id")
		
		for iter_16_0 = 1, CONDITION_GROUP_COLUMN_MAX do
			table.insert(var_16_24, "condition_" .. iter_16_0)
			table.insert(var_16_24, "value_" .. iter_16_0)
			table.insert(var_16_24, "name_" .. iter_16_0)
		end
		
		var_16_25 = DBT("condition_group", arg_16_2.value_data.group, var_16_24)
		var_16_26 = 0
		
		for iter_16_1 = 1, CONDITION_GROUP_COLUMN_MAX do
			if var_16_25["condition_" .. iter_16_1] then
				var_16_26 = var_16_26 + 1
			else
				break
			end
		end
	end
	
	local var_16_27 = T(arg_16_2.name)
	
	if DEBUG.DEBUG_MAP_ID then
		var_16_27 = arg_16_2.group_id .. "." .. arg_16_2.lv
	end
	
	local var_16_28 = arg_16_1:getChildByName("n_normal")
	local var_16_29 = arg_16_1:getChildByName("n_reward")
	
	if var_16_8 then
		var_16_28 = arg_16_1:getChildByName("n_vary")
		
		local var_16_30 = arg_16_1:getChildByName("n_reward_vary")
		
		var_16_29:setPosition(var_16_30:getPosition())
	end
	
	if_set_visible(arg_16_1, "n_vary", var_16_8)
	if_set_visible(arg_16_1, "n_normal", not var_16_8)
	if_set(var_16_28, "txt_title", var_16_27)
	if_set(var_16_28, "txt_name", T(arg_16_2.desc))
	if_set_percent(var_16_28, "progress", var_16_3 / var_16_5)
	if_set(var_16_28, "txt_progress", comma_value(math.min(var_16_3, var_16_5)) .. " / " .. comma_value(var_16_5))
	
	if arg_16_2.value_data.group then
		local var_16_31, var_16_32 = ConditionContentsManager:getAchievement():getConditionsCount(arg_16_2.group_id, arg_16_2.value_data.group)
		
		if_set_percent(var_16_28, "progress", var_16_32 / var_16_31)
		if_set(var_16_28, "txt_progress", var_16_32 .. " / " .. var_16_31)
	end
	
	local var_16_33 = arg_16_1:getChildByName("btn_go")
	local var_16_34 = arg_16_1:getChildByName("btn_detail")
	local var_16_35 = var_16_22 or false
	local var_16_36 = not var_16_35
	
	if var_16_22 and var_16_9 == 1 then
		var_16_36 = true
	end
	
	if var_16_33 then
		var_16_33.faction_id = arg_16_2.faction_id
		var_16_33.group_id = arg_16_2.group_id
		var_16_33.id = arg_16_2.id
		var_16_34.id = arg_16_2.id
		var_16_34.group_id = arg_16_2.group_id
		var_16_34.faction_id = arg_16_2.faction_id
		
		if_set_visible(arg_16_1, "icon_check", var_16_9 == 1)
		if_set_visible(arg_16_1, "bg_progress", var_16_9 ~= 2)
		if_set_visible(arg_16_1, "n_reward1", var_16_9 ~= 2)
		if_set_visible(arg_16_1, "n_reward2", var_16_9 ~= 2)
		var_16_28:setOpacity(var_16_6)
		
		if var_16_9 == 0 then
			arg_16_0:updateTime(arg_16_1, arg_16_2)
		elseif var_16_9 == 1 then
			arg_16_0:updateTime(arg_16_1, arg_16_2)
		elseif var_16_9 == 2 then
			arg_16_0:updateTime(arg_16_1, arg_16_2)
			
			var_16_36 = false
			var_16_35 = false
		end
		
		UIUtil:setColorRewardButtonState(var_16_9, var_16_28, var_16_33, {
			add_x_clear = 8,
			test = arg_16_2.id
		})
		if_set_visible(arg_16_1, "n_complet", var_16_9 == 2)
		if_set_visible(arg_16_1, "btn_detail", var_16_35 and (not var_16_22 or var_16_9 ~= 1))
		if_set_visible(arg_16_1, "btn_go", var_16_36)
		
		if var_16_9 == 0 and arg_16_2.btn_move == nil then
			if_set_opacity(arg_16_1, "btn_go", 76.5)
		else
			if_set_opacity(arg_16_1, "btn_go", 255)
		end
	end
end

function FactionDetail.updateTime(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2.reset_time == "daily" then
		local var_17_0, var_17_1, var_17_2 = Account:serverTimeDayLocalDetail()
		
		if_set(arg_17_1, "txt_time", sec_to_string(var_17_2 - os.time()))
	elseif arg_17_2.reset_time == "weekly" then
		local var_17_3, var_17_4, var_17_5 = Account:serverTimeWeekLocalDetail()
		
		if_set(arg_17_1, "txt_time", sec_to_string(var_17_5 - os.time()))
	else
		if_set_visible(arg_17_1, "txt_time", false)
	end
end

function FactionDetail.onItemControl(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.group_id
	local var_18_1 = Account:getFactionGroupInfo(arg_18_1.faction_id, arg_18_1.group_id)
	local var_18_2 = AchievementBase:getAchieveDataByGroupID(arg_18_1.faction_id, arg_18_1.group_id)
	
	if not var_18_1 then
		return 
	end
	
	if not var_18_2 then
		return 
	end
	
	local var_18_3 = var_18_1.state
	local var_18_4
	
	if var_18_2.value_data and var_18_2.value_data.group then
		var_18_4 = true
	end
	
	if var_18_3 == 0 then
		if var_18_4 then
			AchieveGroupPopup:show(var_18_2)
		else
			local var_18_5 = var_18_2.btn_move
			
			if var_18_5 then
				movetoPath(var_18_5)
			end
		end
		
		if false then
		end
	elseif var_18_3 == 1 then
		local var_18_6 = var_18_2.faction_id
		local var_18_7 = var_18_2.group_id
		
		query("clear_achievement", {
			faction_id = var_18_6,
			group_id = var_18_7
		})
	end
end

function FactionDetail.getSimpleFace(arg_19_0, arg_19_1)
	local var_19_0 = cc.CSLoader:createNode("wnd/wnd_story_target.csb")
	
	var_19_0:setAnchorPoint(0.5, 0.5)
	
	if arg_19_1 then
		if_set_sprite(var_19_0, "img_face", "face/" .. arg_19_1 .. "_s.png")
		
		local var_19_1 = var_19_0:getChildByName("img_face")
		
		if not SpriteCache:resetSprite(var_19_1, "face/" .. arg_19_1 .. "_s.png") then
			SpriteCache:resetSprite(var_19_1, "face/m9991_s.png")
		end
	end
	
	if_set_sprite(var_19_0, "cm_hero_cirfrm_lock", "img/cm_hero_cirfrm2.png")
	if_set_visible(var_19_0, "icon_longing", false)
	if_set_visible(var_19_0, "cm_cool_hero_1", false)
	if_set_visible(var_19_0, "icon_locked", false)
	if_set_visible(var_19_0, "txt_name_0", false)
	
	return var_19_0
end

function FactionDetail.onUpdateUI(arg_20_0)
	arg_20_0:refreshCenterView()
end

function AchieveGroupPopup.close(arg_21_0)
	UIAction:Add(SEQ(FADE_OUT(400), REMOVE()), AchieveGroupPopup.wnd, "block")
	BackButtonManager:pop("achieve_detail")
end

copy_functions(ScrollView, AchieveGroupPopup)

function AchieveGroupPopup.show(arg_22_0, arg_22_1)
	arg_22_1 = arg_22_1 or {}
	
	local var_22_0 = load_dlg("achieve_detail", nil, "wnd", function()
		AchieveGroupPopup:close()
	end)
	
	arg_22_0.wnd = var_22_0
	arg_22_0.scrollview = var_22_0:getChildByName("scrollview")
	
	arg_22_0:initScrollView(arg_22_0.scrollview, 315, 55)
	SceneManager:getDefaultLayer():addChild(var_22_0)
	
	local var_22_1 = ConditionContentsManager:getAchievement()
	local var_22_2 = DB("character", arg_22_1.icon, "name")
	
	if_set(var_22_0, "txt_npc_name", T("request_npc", {
		npc_name = T(var_22_2)
	}))
	if_set(var_22_0, "txt_title", T(arg_22_1.name))
	if_set(var_22_0, "txt_desc", T(arg_22_1.desc))
	if_set_sprite(var_22_0, "img_face", "face/" .. arg_22_1.icon .. "_s.png")
	
	local var_22_3 = var_22_0:getChildByName("n_reward1")
	local var_22_4 = var_22_0:getChildByName("n_reward2")
	
	if arg_22_1.reward_id1 then
		UIUtil:getRewardIcon(tonumber(arg_22_1.reward_count1) or 1, arg_22_1.reward_id1, {
			icon_scale = 0.4,
			parent = var_22_3,
			faction = arg_22_1.faction_id
		})
	end
	
	if arg_22_1.reward_id2 then
		if string.split(arg_22_1.reward_id2, "_")[1] == "to" then
			local var_22_5 = UIUtil:getRewardIcon(tonumber(arg_22_1.reward_count2) or 1, arg_22_1.reward_id2, {
				parent = var_22_4
			})
		else
			local var_22_6 = UIUtil:getRewardIcon(tonumber(arg_22_1.reward_count2), arg_22_1.reward_id2, {
				parent = var_22_4
			})
		end
	end
	
	arg_22_0.wnd:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(400)), arg_22_0.wnd, "block")
	arg_22_0:setCondition(var_22_0, arg_22_1.group_id, arg_22_1.value_data.group)
	SoundEngine:play("event:/ui/popup/tap")
end

function AchieveGroupPopup.getScrollViewItem(arg_24_0, arg_24_1)
	local var_24_0 = cc.CSLoader:createNode("wnd/archievement_detail_item.csb")
	local var_24_1 = arg_24_1.condition_group_db
	
	if_set(var_24_0, "txt_title", T(var_24_1.name))
	set_scale_fit_width(var_24_0:getChildByName("txt_title"), 300)
	
	local var_24_2 = ConditionContentsManager:getAchievement():getConditionScore(arg_24_1.achieve_group_id, var_24_1.idx)
	
	if_set_percent(var_24_0, "progress", var_24_2 / var_24_1.max)
	
	local var_24_3 = var_24_2 >= tonumber(var_24_1.max)
	
	if_set(var_24_0, "txt_progress", math.min(var_24_2, var_24_1.max) .. " / " .. var_24_1.max)
	if_set_visible(var_24_0, "icon_check", var_24_3)
	
	if var_24_3 then
		if_set_color(var_24_0, "progress", cc.c3b(107, 193, 27))
		if_set_color(var_24_0, "txt_title", cc.c3b(107, 193, 27))
	else
		if_set_color(var_24_0, "progress", cc.c3b(146, 109, 62))
		if_set_color(var_24_0, "txt_title", cc.c3b(171, 135, 89))
	end
	
	return var_24_0
end

function AchieveGroupPopup.setCondition(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = {}
	local var_25_1 = {}
	
	table.insert(var_25_1, "id")
	
	for iter_25_0 = 1, CONDITION_GROUP_COLUMN_MAX do
		table.insert(var_25_1, "condition_" .. iter_25_0)
		table.insert(var_25_1, "value_" .. iter_25_0)
		table.insert(var_25_1, "name_" .. iter_25_0)
	end
	
	local var_25_2 = DBT("condition_group", arg_25_3, var_25_1)
	local var_25_3 = 0
	local var_25_4 = 0
	
	for iter_25_1 = 1, CONDITION_GROUP_COLUMN_MAX do
		local var_25_5 = arg_25_1:getChildByName("quest_" .. iter_25_1)
		
		if var_25_2["condition_" .. iter_25_1] then
			local var_25_6 = {
				count = 1
			}
			
			merge_table(totable(var_25_2["value_" .. iter_25_1]), var_25_6)
			table.insert(var_25_0, {
				achieve_group_id = arg_25_2,
				condition_group_db = {
					condition = var_25_2["condition_" .. iter_25_1],
					max = totable(var_25_2["value_" .. iter_25_1]).count,
					name = var_25_2["name_" .. iter_25_1],
					idx = iter_25_1
				}
			})
		end
	end
	
	arg_25_0:createScrollViewItems(var_25_0)
end
