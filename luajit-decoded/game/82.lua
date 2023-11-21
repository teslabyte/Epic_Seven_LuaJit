FactionDetailSica = FactionDetailSica or {}

copy_functions(FactionDetail, FactionDetailSica)

SICA_FACTION_ID = "sica"

function HANDLER.achieve_dagger(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_sica_exchange" then
		FactionSicaReward:show()
		
		return 
	end
	
	if arg_1_1 == "btn_go" then
		FactionDetailSica:onItemControl(arg_1_0)
	end
end

function HANDLER.achieve_dagger_card(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_card" then
		FactionDetailSica:setMode(arg_2_0.info.id)
		
		return 
	end
end

function HANDLER.achieve_dagger_reward(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("achieve_dagger_reward")
		
		return 
	end
	
	if arg_3_1 == "btn_get" then
		FactionSicaReward:onBtnGet(arg_3_0)
		
		return 
	end
end

function HANDLER.achieve_dagger_reward_get(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		FactionSicaReward:closeRewardPopup(arg_4_0.story_id)
	end
end

function HANDLER.achieve_dagger_get(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		Dialog:close("achieve_dagger_get")
	end
end

function MsgHandler.sica_reward_achievement(arg_6_0)
	local var_6_0 = ConditionContentsManager:getAchievement()
	
	if arg_6_0.clear_condition_group then
		var_6_0:setConditionGroupData(arg_6_0.group_id, arg_6_0.clear_condition_group)
	end
	
	local var_6_1 = Account:setFactionExp(arg_6_0.faction_id, arg_6_0.exp)
	
	if arg_6_0.faction_group then
		Account:setFactionGroupInfo(arg_6_0.faction_group.faction_id, arg_6_0.faction_group.group_id, arg_6_0.faction_group)
	end
	
	local var_6_2 = Account:addReward(arg_6_0.rewards)
	
	FactionDetailSica:showRewardPopup(arg_6_0.faction_id, var_6_2, arg_6_0.clear_achieve_id, var_6_1)
	FactionDetailSica:updateUI()
	FactionSicaListView:refresh()
	FactionSicaSubCategory:updateScrollView()
	FactionCategory:updateItems()
end

function MsgHandler.get_faction_reward(arg_7_0)
	Account:addReward(arg_7_0.rewards)
	FactionSicaReward:showPopupPointReward(arg_7_0.rewards, arg_7_0.faction_reward_info)
	Account:setFactionRewardInfo(arg_7_0.faction_reward_info)
	FactionSicaReward:refresh()
	FactionDetailSica:updateUI()
end

function FactionDetailSica.clear(arg_8_0)
	arg_8_0.vars = {}
end

function FactionDetailSica.init(arg_9_0)
	local var_9_0 = AchievementBase:getWnd()
	
	arg_9_0.vars = {}
	arg_9_0.vars.n_dagger = var_9_0:getChildByName("n_dagger")
	
	if not get_cocos_refid(arg_9_0.vars.n_dagger) then
		return 
	end
	
	local var_9_1 = load_dlg("achieve_dagger", true, "wnd")
	
	arg_9_0.vars.wnd = var_9_1
	
	arg_9_0.vars.n_dagger:addChild(var_9_1)
	arg_9_0:createCategoryDB()
	FactionSicaReward:init()
	arg_9_0:setUI()
	FactionSicaListView:createFactionDetailView(arg_9_0.vars.wnd)
	arg_9_0:setMode("lobby")
end

function FactionDetailSica.selectCategory(arg_10_0, arg_10_1)
	local var_10_0 = AchievementBase:getWnd()
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = var_10_0:getChildByName("BASE_LEFT")
	local var_10_2 = var_10_0:getChildByName("BASE_CENTER")
	local var_10_3 = var_10_0:getChildByName("BASE_RIGHT")
	
	if_set_visible(var_10_2, "listview_vary", false)
	if_set_visible(var_10_1, "n_point", false)
	if_set_visible(var_10_3, "n_category", false)
	if_set_visible(var_10_2, "n_none", false)
	if_set_visible(var_10_2, "listview", false)
	if_set_visible(var_10_0, "n_dagger", true)
	var_10_2:setVisible(false)
	var_10_1:setVisible(false)
	
	if not arg_10_0.vars.sub_category_scrollview then
		arg_10_0.vars.sub_category_scrollview = arg_10_0.vars.wnd:getChildByName("sub_scrollview")
		
		FactionSicaSubCategory:createSubCategory(arg_10_0.vars.sub_category_scrollview, arg_10_0.vars.category_db)
	end
	
	if not arg_10_0.vars.loop_on and arg_10_0.vars.mode == "lobby" then
		local var_10_4 = arg_10_0.vars.wnd:getChildByName("n_landing_bg")
		local var_10_5 = var_10_4:getChildByName("circle1")
		local var_10_6 = var_10_4:getChildByName("circle3")
		local var_10_7 = var_10_4:getChildByName("circle2")
		
		arg_10_0.vars.loop_on = true
		
		if get_cocos_refid(var_10_5) and get_cocos_refid(var_10_7) and get_cocos_refid(var_10_6) then
			UIAction:Add(LOOP(ROTATE(30000, 0, 360), 100), var_10_5, "sica_loop")
			UIAction:Add(LOOP(ROTATE(30000, 0, 360), 100), var_10_6, "sica_loop")
			UIAction:Add(LOOP(ROTATE(16000, 0, -360), 100), var_10_7, "sica_loop")
		end
	end
	
	ConditionContentsManager:sicaForceUpdateConditions()
end

function FactionDetailSica.updateModeUI(arg_11_0)
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
	
	for iter_11_2 = 1, 10 do
		local var_11_6 = var_11_3:getChildByName("n_" .. iter_11_2 * 10)
		local var_11_7 = var_11_5[tostring(iter_11_2 * 10)]
		
		if var_11_6 and var_11_7 then
			var_11_6:getChildByName("btn_point_reward").reward_db = var_11_7
		end
	end
	
	arg_11_0:updateRewardUI()
end

function FactionDetailSica.createCategoryDB(arg_12_0)
	arg_12_0.vars.category_db = {}
	
	for iter_12_0 = 1, 999 do
		local var_12_0, var_12_1, var_12_2, var_12_3, var_12_4 = DBN("achievement_honor_category", iter_12_0, {
			"id",
			"name",
			"icon",
			"sort",
			"jpn_hide"
		})
		
		if not var_12_0 then
			break
		end
		
		table.insert(arg_12_0.vars.category_db, {
			id = var_12_0,
			name = var_12_1,
			icon = var_12_2,
			sort = var_12_3,
			jpn_hide = var_12_4
		})
	end
	
	table.sort(arg_12_0.vars.category_db, function(arg_13_0, arg_13_1)
		return arg_13_0.sort < arg_13_1.sort
	end)
end

function FactionDetailSica.getCategory(arg_14_0)
	if not arg_14_0.vars then
		return {}
	end
	
	if not arg_14_0.vars.category_db then
		arg_14_0:createCategoryDB()
	end
	
	return arg_14_0.vars.category_db
end

function FactionDetailSica.setUI(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	if not arg_15_0.vars.category_db then
		return 
	end
	
	local var_15_0 = #arg_15_0.vars.category_db
	local var_15_1 = arg_15_0.vars.wnd:getChildByName("n_max" .. tostring(var_15_0))
	
	if not get_cocos_refid(var_15_1) then
		return 
	end
	
	arg_15_0.vars.category_icons = {}
	
	for iter_15_0 = 1, var_15_0 do
		local var_15_2 = var_15_1:getChildByName("n_" .. tostring(iter_15_0))
		local var_15_3 = arg_15_0.vars.category_db[iter_15_0]
		
		if var_15_2 and var_15_3 then
			local var_15_4 = arg_15_0:createCategoryIcon(var_15_2, var_15_3)
			
			arg_15_0.vars.category_icons[var_15_3.id] = var_15_4
		end
	end
end

function FactionDetailSica.updateUI(arg_16_0)
	local var_16_0 = Account:getFactionExp(SICA_FACTION_ID) or 0
	
	if_set(arg_16_0.vars.wnd, "txt_sica_point", comma_value(var_16_0))
	
	local var_16_1 = arg_16_0.vars.wnd:getChildByName("btn_sica_exchange")
	local var_16_2 = FactionSicaReward:getCountRewardAble() or 0
	
	if_set_visible(var_16_1, "img_noti", var_16_2 > 0)
end

function FactionDetailSica.getNotiCount(arg_17_0, arg_17_1)
	local var_17_0 = 0
	local var_17_1 = Account:getFactionGroupsByFactionID(SICA_FACTION_ID)
	
	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		if string.starts(iter_17_1.group_id, arg_17_1) and (tonumber(iter_17_1.state) or 0) == 1 then
			var_17_0 = var_17_0 + 1
		end
	end
	
	return var_17_0
end

function FactionDetailSica.createCategoryIcon(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = load_control("wnd/achieve_dagger_card.csb")
	
	arg_18_1:addChild(var_18_0)
	if_set_sprite(arg_18_1, "icon_menu", "img/" .. arg_18_2.icon .. ".png")
	if_set(arg_18_1, "txt_title", T(arg_18_2.name))
	
	local var_18_1 = arg_18_0:getNotiCount(arg_18_2.id)
	local var_18_2 = var_18_0:getChildByName("cm_noti")
	
	var_18_2:setVisible(var_18_1 > 0)
	
	if var_18_1 > 0 then
		if_set(var_18_2, "count", var_18_1)
	end
	
	var_18_0:getChildByName("btn_card").info = arg_18_2
	
	return var_18_0
end

function FactionDetailSica.getSubCategoryClearCount(arg_19_0, arg_19_1)
	local var_19_0 = Account:getFactionGroupsByFactionID(SICA_FACTION_ID) or {}
	local var_19_1 = 0
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		local var_19_2 = iter_19_1.group_id
		
		if string.split(var_19_2, "_")[1] == arg_19_1 and (iter_19_1.state or 0) >= 1 then
			var_19_1 = var_19_1 + 1
		end
	end
	
	return var_19_1
end

function FactionDetailSica.updateCategoryIcons(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	if not arg_20_0.vars.category_db then
		return 
	end
	
	local var_20_0 = #arg_20_0.vars.category_db
	
	for iter_20_0 = 1, var_20_0 do
		local var_20_1 = arg_20_0.vars.category_db[iter_20_0]
		local var_20_2 = arg_20_0.vars.category_icons[var_20_1.id]
		local var_20_3 = arg_20_0:getSubCategoryClearCount(var_20_1.id) or 0
		local var_20_4 = arg_20_0.vars.group_db[var_20_1.id]
		
		if not var_20_4 then
			arg_20_0:loadGroupData(var_20_1.id)
			
			var_20_4 = arg_20_0.vars.group_db[var_20_1.id]
		end
		
		local var_20_5 = #var_20_4
		
		if var_20_2 and var_20_1 then
			if_set(var_20_2, "t_count", tostring(var_20_3) .. " / " .. tostring(var_20_5))
			if_set(var_20_2, "txt_complet", tostring(math.floor(var_20_3 / var_20_5 * 100)) .. "%")
			
			local var_20_6 = var_20_2:getChildByName("progress_bar")
			local var_20_7 = var_20_2:getChildByName("n_progress")
			
			if not var_20_7:getChildByName("@progress") then
				var_20_6:setVisible(false)
				
				local var_20_8 = WidgetUtils:createCircleProgress("img/_hero_s_frame_w.png")
				
				var_20_8:setCascadeOpacityEnabled(true)
				var_20_8:setScale(var_20_6:getScale())
				var_20_8:setPosition(var_20_6:getPosition())
				var_20_8:setOpacity(var_20_6:getOpacity())
				var_20_8:setColor(var_20_6:getColor())
				var_20_8:setReverseDirection(false)
				var_20_8:setName("@progress")
				var_20_8:setPercentage(math.floor(var_20_3 / var_20_5 * 100))
				var_20_7:addChild(var_20_8)
			end
		end
	end
end

function FactionDetailSica.setMode(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.vars.mode == "lobby" and arg_21_1 ~= "lobby"
	
	if arg_21_0.vars.mode == arg_21_1 then
		return 
	end
	
	arg_21_0.vars.mode = arg_21_1
	
	arg_21_0:setDetailUI(var_21_0)
end

function FactionDetailSica.getMode(arg_22_0)
	return arg_22_0.vars.mode
end

function FactionDetailSica.setDetailUI(arg_23_0, arg_23_1)
	if not arg_23_0.vars then
		return 
	end
	
	if not arg_23_0.vars.category_db then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.mode
	
	if var_23_0 == "lobby" then
		for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.category_db) do
			arg_23_0:loadGroupData(iter_23_1.id)
		end
	else
		arg_23_0:loadGroupData(var_23_0)
	end
	
	if_set_visible(arg_23_0.vars.wnd, "SICA_CENTER", var_23_0 == "lobby")
	if_set_visible(arg_23_0.vars.wnd, "SICA_LEFT", var_23_0 ~= "lobby")
	if_set_visible(arg_23_0.vars.wnd, "SICA_RIGHT", var_23_0 ~= "lobby")
	
	if var_23_0 ~= "lobby" then
		local var_23_1 = arg_23_0.vars.wnd:getChildByName("sica_top_bar")
		
		if not var_23_1.origin_width then
			var_23_1.origin_width = var_23_1:getContentSize().width
		end
		
		var_23_1:setContentSize(var_23_1.origin_width - 127, var_23_1:getContentSize().height)
		
		local var_23_2 = arg_23_0.vars.wnd:getChildByName("n_sica_point")
		local var_23_3 = arg_23_0.vars.wnd:getChildByName("n_sica_point2")
		
		var_23_2:setPositionX(var_23_3:getPositionX())
		FactionSicaListView:setDataSource(arg_23_0.vars.group_db[var_23_0] or {})
		
		if arg_23_1 then
			local var_23_4 = arg_23_0.vars.wnd:getChildByName("n_sica_top")
			
			if not var_23_4.origin_pos_y then
				var_23_4.origin_pos_y = var_23_4:getPositionY()
			end
			
			var_23_4:setPositionY(var_23_4.origin_pos_y + 200)
			var_23_4:setOpacity(0)
			UIAction:Add(SPAWN(SHOW(true), FADE_IN(200), LOG(MOVE_BY(200, 0, -200))), var_23_4, "block")
			
			local var_23_5 = arg_23_0.vars.wnd:getChildByName("SICA_RIGHT")
			
			if not var_23_5.origin_pos_x then
				var_23_5.origin_pos_x = var_23_5:getPositionX()
			end
			
			var_23_5:setPositionX(var_23_5.origin_pos_x + 200)
			var_23_5:setOpacity(0)
			UIAction:Add(SPAWN(SHOW(true), FADE_IN(200), LOG(MOVE_BY(200, -200))), var_23_5, "block")
			
			local var_23_6 = arg_23_0.vars.wnd:getChildByName("n_quest")
			
			if not var_23_6.origin_pos_x then
				var_23_6.origin_pos_x = var_23_6:getPositionX()
			end
			
			var_23_6:setPositionX(var_23_6.origin_pos_x - 200)
			var_23_6:setOpacity(0)
			UIAction:Add(SPAWN(SHOW(true), FADE_IN(200), LOG(MOVE_BY(200, 200))), var_23_6, "block")
			FactionSicaSubCategory:runProgressFadeInAction()
		end
	end
	
	arg_23_0:updateUI()
	arg_23_0:updateCategoryIcons()
	FactionSicaSubCategory:updateSelected(var_23_0)
	
	if UIAction:Find("sica_loop") then
		UIAction:Remove("sica_loop")
	end
end

function FactionDetailSica.loadGroupData(arg_24_0, arg_24_1)
	if not arg_24_0.vars then
		return 
	end
	
	if not arg_24_0.vars.category_db then
		return 
	end
	
	local var_24_0 = AchievementUtil:getAchieveRowMax()
	
	if not arg_24_0.vars.group_db then
		arg_24_0.vars.group_db = {}
	end
	
	if not arg_24_0.vars.group_db[arg_24_1] then
		arg_24_0.vars.group_db[arg_24_1] = {}
		
		for iter_24_0 = 1, var_24_0 do
			local var_24_1 = string.format("%s_%03d", arg_24_1, iter_24_0)
			local var_24_2 = var_24_1 .. "_01"
			local var_24_3 = DBT("achievement", var_24_2, {
				"id",
				"name",
				"desc",
				"desc2",
				"icon",
				"condition",
				"value",
				"reward_id1",
				"reward_count1",
				"reward_id2",
				"reward_count2",
				"mail_id",
				"btn_move",
				"reset_time",
				"sort",
				"hide",
				"grade_rate1",
				"grade_rate2",
				"set_drop_rate_id1",
				"set_drop_rate_id2",
				"hold",
				"jpn_hide",
				"system_achievement",
				"difficulty"
			})
			
			var_24_3.faction_id = SICA_FACTION_ID
			var_24_3.group_id = var_24_1
			
			local var_24_4 = Account:isJPN() and var_24_3.jpn_hide == "y"
			
			if var_24_3 and var_24_3.id and not var_24_4 then
				table.insert(arg_24_0.vars.group_db[arg_24_1], var_24_3)
			end
		end
	end
end

function FactionDetailSica.getGroupData(arg_25_0, arg_25_1)
	if not arg_25_0.vars then
		return {}
	end
	
	if not arg_25_0.vars.category_db then
		return {}
	end
	
	local var_25_0 = AchievementUtil:getAchieveRowMax()
	
	if not arg_25_0.vars.group_db or not arg_25_0.vars.group_db[arg_25_1] then
		arg_25_0:loadGroupData(arg_25_1)
	end
	
	return arg_25_0.vars.group_db[arg_25_1]
end

function FactionDetailSica.onItemControl(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1.group_id
	local var_26_1 = Account:getFactionGroupInfo(arg_26_1.faction_id, arg_26_1.group_id)
	
	if not var_26_1 then
		return 
	end
	
	local var_26_2 = var_26_1.state
	
	if var_26_2 == 0 then
		local var_26_3 = arg_26_1.btn_move
		
		movetoPath(var_26_3)
	elseif var_26_2 == 1 then
		local var_26_4 = arg_26_1.faction_id
		local var_26_5 = arg_26_1.group_id
		
		query("sica_reward_achievement", {
			faction_id = var_26_4,
			group_id = var_26_5
		})
	end
end

function FactionDetailSica.showRewardPopup(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = Dialog:open("wnd/achieve_dagger_get", arg_27_0)
	
	SceneManager:getRunningPopupScene():addChild(var_27_0)
	
	local var_27_1 = Account:getFactionExp(arg_27_1)
	
	if_set(var_27_0, "txt_total", comma_value(var_27_1))
	if_set(var_27_0, "txt_add", comma_value(arg_27_4))
	if_set_arrow(var_27_0)
	
	local var_27_2 = arg_27_0.vars.mode
	local var_27_3 = arg_27_0.vars.group_db[var_27_2]
	
	for iter_27_0, iter_27_1 in pairs(var_27_3 or {}) do
		if iter_27_1.id == arg_27_3 then
			if_set(var_27_0, "txt_disc", T("ui_popup_desc_daggersicar", {
				achieve_title = T(iter_27_1.name)
			}))
			
			break
		end
	end
	
	local var_27_4 = var_27_0:getChildByName("n_item")
	local var_27_5 = {
		show_small_count = true,
		parent = var_27_4
	}
	
	for iter_27_2, iter_27_3 in pairs(arg_27_2.rewards or {}) do
		if iter_27_3.code then
			local var_27_6 = iter_27_3.code
			
			if iter_27_3.is_currency then
				var_27_6 = "to_" .. var_27_6
			end
			
			local var_27_7 = iter_27_3.count or iter_27_3.diff or 1
			local var_27_8 = UIUtil:getRewardIcon(var_27_7, var_27_6, var_27_5)
			
			break
		end
	end
	
	local var_27_9 = var_27_0:getChildByName("n_eff")
	
	if var_27_9 then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_27_9
		})
		UIAction:Add(DELAY(1000), var_27_0, "block")
	end
end

FactionSicaSubCategory = FactionSicaSubCategory or {}

copy_functions(ScrollView, FactionSicaSubCategory)

function FactionSicaSubCategory.createSubCategory(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.vars = {}
	arg_28_0.vars.scrollview = arg_28_1
	
	arg_28_0:initScrollView(arg_28_0.vars.scrollview, 116, 152)
	arg_28_0:createScrollViewItems(arg_28_2)
end

function FactionSicaSubCategory.getScrollViewItem(arg_29_0, arg_29_1)
	local var_29_0 = load_dlg("achieve_dagger_bar", true, "wnd")
	
	if_set_sprite(var_29_0, "icon_menu", "img/" .. arg_29_1.icon .. ".png")
	if_set(var_29_0, "txt_title", T(arg_29_1.name))
	arg_29_0:updateInfo(var_29_0, arg_29_1)
	
	local var_29_1 = var_29_0:getChildByName("n_progress")
	local var_29_2 = var_29_1:getChildByName("progress_bar")
	local var_29_3 = var_29_1:getChildByName("@progress")
	local var_29_4 = FactionDetailSica:getSubCategoryClearCount(arg_29_1.id) or 0
	local var_29_5 = #(FactionDetailSica:getGroupData(arg_29_1.id) or {})
	
	if not var_29_3 then
		var_29_2:setVisible(false)
		
		local var_29_6 = WidgetUtils:createCircleProgress("img/_hero_s_frame_w.png")
		
		var_29_6:setCascadeOpacityEnabled(true)
		var_29_6:setScale(var_29_2:getScale())
		var_29_6:setPosition(var_29_2:getPosition())
		var_29_6:setOpacity(var_29_2:getOpacity())
		var_29_6:setColor(var_29_2:getColor())
		var_29_6:setReverseDirection(false)
		var_29_6:setName("@progress")
		var_29_6:setPercentage(math.floor(var_29_4 / var_29_5 * 100))
		var_29_1:addChild(var_29_6)
		var_29_6:setVisible(false)
	end
	
	return var_29_0
end

function FactionSicaSubCategory.runProgressFadeInAction(arg_30_0)
	for iter_30_0, iter_30_1 in pairs(arg_30_0.ScrollViewItems) do
		if get_cocos_refid(iter_30_1.control) then
			local var_30_0 = iter_30_1.control:getChildByName("@progress")
			
			if get_cocos_refid(var_30_0) then
				UIAction:Add(SPAWN(SHOW(true), FADE_IN(200)), var_30_0, "block")
			end
		end
	end
end

function FactionSicaSubCategory.updateInfo(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = FactionDetailSica:getNotiCount(arg_31_2.id)
	local var_31_1 = arg_31_1:getChildByName("cm_noti")
	
	var_31_1:setVisible(var_31_0 > 0)
	
	if var_31_0 > 0 then
		if_set(var_31_1, "count", var_31_0)
	end
end

function FactionSicaSubCategory.updateScrollView(arg_32_0)
	for iter_32_0, iter_32_1 in pairs(arg_32_0.ScrollViewItems or {}) do
		arg_32_0:updateInfo(iter_32_1.control, iter_32_1.item)
	end
end

function FactionSicaSubCategory.onSelectScrollViewItem(arg_33_0, arg_33_1, arg_33_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	FactionDetailSica:setMode(arg_33_2.item.id)
end

function FactionSicaSubCategory.updateSelected(arg_34_0, arg_34_1)
	if not arg_34_0.ScrollViewItems then
		return 
	end
	
	for iter_34_0, iter_34_1 in pairs(arg_34_0.ScrollViewItems) do
		if_set_visible(iter_34_1.control, "select", arg_34_1 == iter_34_1.item.id)
	end
end

FactionSicaListView = FactionSicaListView or {}

function FactionSicaListView.createFactionDetailView(arg_35_0, arg_35_1)
	arg_35_0.vars = {}
	
	local var_35_0 = arg_35_1:getChildByName("sica_listview")
	
	arg_35_0.vars.itemView = ItemListView_v2:bindControl(var_35_0)
	
	local var_35_1 = load_control("wnd/achieve_dagger_quest_item.csb")
	
	if var_35_0.STRETCH_INFO then
		local var_35_2 = var_35_0:getContentSize()
		
		resetControlPosAndSize(var_35_1, var_35_2.width, var_35_0.STRETCH_INFO.width_prev)
	end
	
	local var_35_3 = {
		onUpdate = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
			arg_35_0:updateListViewItem(arg_36_1, arg_36_3)
			
			return arg_36_3.id
		end
	}
	
	arg_35_0.vars.itemView:setRenderer(var_35_1, var_35_3)
	arg_35_0.vars.itemView:removeAllChildren()
	arg_35_0:setDataSource({})
end

function FactionSicaListView.updateListViewItem(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_1:getChildByName("btn_go")
	local var_37_1 = 0
	local var_37_2 = (Account:getFactionGroupInfo(SICA_FACTION_ID, arg_37_2.group_id) or {}).state
	
	if_set_sprite(arg_37_1, "icon_grade", "img/dagger_assign_grade0" .. tostring(arg_37_2.difficulty or 1) .. ".png")
	UIUtil:setColorRewardButtonState(var_37_2, arg_37_1, var_37_0, {
		add_x_clear = 8
	})
	
	if var_37_2 == 2 then
		if_set_opacity(arg_37_1, "LEFT", 76.5)
		if_set_opacity(arg_37_1, "n_reward", 76.5)
		if_set_opacity(arg_37_1, "icon_check", 76.5)
	else
		if_set_opacity(arg_37_1, "LEFT", 255)
		if_set_opacity(arg_37_1, "n_reward", 255)
		if_set_opacity(arg_37_1, "icon_check", 255)
	end
	
	if_set(arg_37_1, "txt_title", T(arg_37_2.name))
	if_set_visible(arg_37_1, "icon_check", var_37_2 >= 1)
	
	if DEBUG.DEBUG_MAP_ID then
		if_set(arg_37_1, "txt_title", T(arg_37_2.id))
	end
	
	if_set(arg_37_1, "txt_sub_title", T(arg_37_2.desc))
	
	local var_37_3 = arg_37_1:getChildByName("n_item")
	local var_37_4 = arg_37_1:getChildByName("n_point")
	local var_37_5 = {
		icon_scale = 0.4,
		show_small_count = true,
		faction = "dagger",
		parent = var_37_4,
		faction_category = T("category_achieve_point_sica")
	}
	
	if arg_37_2.reward_id1 then
		local var_37_6 = UIUtil:getRewardIcon(tonumber(arg_37_2.reward_count1) or 1, arg_37_2.reward_id1, var_37_5)
	end
	
	local var_37_7 = {
		show_small_count = true,
		hero_multiply_scale = 0.94,
		artifact_multiply_scale = 0.67,
		parent = var_37_3,
		equip_stat = arg_37_2.equip_stat or {}
	}
	
	if arg_37_2.reward_id2 then
		local var_37_8 = UIUtil:getRewardIcon(tonumber(arg_37_2.reward_count2) or 1, arg_37_2.reward_id2, var_37_7)
	end
	
	var_37_0.group_id = arg_37_2.group_id
	var_37_0.faction_id = SICA_FACTION_ID
	var_37_0.btn_move = arg_37_2.btn_move
end

function FactionSicaListView.sort(arg_38_0, arg_38_1)
	local var_38_0 = {
		[0] = 1,
		2,
		0
	}
	
	table.sort(arg_38_1, function(arg_39_0, arg_39_1)
		local var_39_0 = Account:getFactionGroupInfo(arg_39_0.faction_id, arg_39_0.group_id)
		local var_39_1 = Account:getFactionGroupInfo(arg_39_1.faction_id, arg_39_1.group_id)
		local var_39_2 = var_39_0.state or 0
		local var_39_3 = var_39_1.state or 0
		
		if var_39_2 == var_39_3 then
			return arg_39_0.sort < arg_39_1.sort
		else
			return var_38_0[var_39_2] > var_38_0[var_39_3]
		end
	end)
	
	return arg_38_1
end

function FactionSicaListView.setDataSource(arg_40_0, arg_40_1)
	if not arg_40_0.vars then
		return 
	end
	
	if not arg_40_0.vars.itemView then
		return 
	end
	
	arg_40_0.vars.data = arg_40_1
	
	arg_40_0:sort(arg_40_0.vars.data)
	arg_40_0.vars.itemView:setDataSource(arg_40_0.vars.data)
	arg_40_0.vars.itemView:jumpToTop()
	
	local var_40_0 = arg_40_0.vars.itemView:getInnerContainerPosition()
	
	arg_40_0.vars.itemView:setInnerContainerPosition({
		x = var_40_0.x,
		y = var_40_0.y - 10
	})
end

function FactionSicaListView.refresh(arg_41_0, arg_41_1)
	if not arg_41_0.vars then
		return 
	end
	
	if not arg_41_0.vars.itemView then
		return 
	end
	
	if not arg_41_0.vars.data then
		return 
	end
	
	arg_41_0:sort(arg_41_0.vars.data)
	arg_41_0.vars.itemView:refresh()
	arg_41_0.vars.itemView:jumpToTop()
end

FactionSicaReward = FactionSicaReward or {}

function FactionSicaReward.init(arg_42_0)
	arg_42_0.vars = {}
	arg_42_0.vars.datas = {}
	
	for iter_42_0 = 1, 99 do
		local var_42_0, var_42_1, var_42_2, var_42_3, var_42_4, var_42_5, var_42_6, var_42_7 = DBN("achievement_honor_reward", iter_42_0, {
			"id",
			"title",
			"gather_point",
			"reward",
			"reward_count",
			"story_id",
			"lock",
			"before_reward_check"
		})
		
		if not var_42_0 then
			break
		end
		
		table.insert(arg_42_0.vars.datas, {
			id = var_42_0,
			title = var_42_1,
			gather_point = var_42_2,
			reward = var_42_3,
			reward_count = var_42_4,
			story_id = var_42_5,
			lock = var_42_6,
			before_reward_check = var_42_7
		})
	end
end

function FactionSicaReward.show(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	if not arg_43_0.vars.datas then
		return 
	end
	
	local var_43_0 = Dialog:open("wnd/achieve_dagger_reward", arg_43_0)
	
	SceneManager:getRunningPopupScene():addChild(var_43_0)
	
	local var_43_1 = var_43_0:getChildByName("listview")
	
	arg_43_0.vars.itemView = ItemListView_v2:bindControl(var_43_1)
	
	local var_43_2 = load_control("wnd/achieve_dagger_reward_item.csb")
	
	if var_43_1.STRETCH_INFO then
		local var_43_3 = var_43_1:getContentSize()
		
		resetControlPosAndSize(var_43_2, var_43_3.width, var_43_1.STRETCH_INFO.width_prev)
	end
	
	local var_43_4 = {
		onUpdate = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			arg_43_0:updateListViewItem(arg_44_1, arg_44_3)
			
			return arg_44_3.id
		end
	}
	
	arg_43_0.vars.itemView:setRenderer(var_43_2, var_43_4)
	arg_43_0.vars.itemView:removeAllChildren()
	arg_43_0.vars.itemView:setDataSource(arg_43_0.vars.datas)
end

function FactionSicaReward.getCountRewardAble(arg_45_0)
	if not arg_45_0.vars then
		return 0
	end
	
	if not arg_45_0.vars.datas then
		return 0
	end
	
	local var_45_0 = 0
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.datas) do
		local var_45_1 = Account:getFactionRewardByRewardID(iter_45_1.id)
		local var_45_2 = Account:getFactionExp(SICA_FACTION_ID) or 0
		local var_45_3 = var_45_1 and tonumber(var_45_1.receive_time or 0) > 0
		local var_45_4 = var_45_2 >= tonumber(iter_45_1.gather_point)
		
		if not var_45_3 and var_45_4 and not iter_45_1.lock then
			var_45_0 = var_45_0 + 1
		end
	end
	
	return var_45_0
end

function FactionSicaReward.updateListViewItem(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = Account:getFactionRewardByRewardID(arg_46_2.id)
	local var_46_1 = var_46_0 and tonumber(var_46_0.receive_time or 0) > 0
	local var_46_2 = Account:getFactionExp(SICA_FACTION_ID) or 0
	local var_46_3 = arg_46_2.before_reward_check
	local var_46_4 = var_46_3 == nil
	
	if var_46_3 then
		local var_46_5 = Account:getFactionRewardByRewardID(var_46_3)
		
		var_46_4 = var_46_5 and to_n(var_46_5.receive_time) > 0
	end
	
	local var_46_6 = var_46_2 >= tonumber(arg_46_2.gather_point)
	
	if_set_visible(arg_46_1, "n_none", arg_46_2.lock ~= nil)
	if_set_visible(arg_46_1, "n_reward", arg_46_2.lock == nil)
	
	local var_46_7 = arg_46_1:getChildByName("btn_get")
	
	var_46_7.reward_id = arg_46_2.id
	var_46_7.rewardable = var_46_6
	var_46_7.is_open_before_reward = var_46_4
	
	if arg_46_2.lock == nil then
		var_46_7:setVisible(not var_46_1)
		if_set_visible(arg_46_1, "n_complet", var_46_1)
		if_set(arg_46_1, "t_title", T(arg_46_2.title))
		if_set(arg_46_1, "txt_point", arg_46_2.gather_point)
	end
	
	if not var_46_6 or not var_46_4 then
		var_46_7:setOpacity(76.5)
	else
		var_46_7:setOpacity(255)
	end
	
	if var_46_1 then
		if_set_opacity(arg_46_1, "n_item", 76.5)
		if_set_opacity(arg_46_1, "t_title", 76.5)
	end
	
	local var_46_8 = arg_46_1:getChildByName("n_item")
	
	if arg_46_2.reward then
		UIUtil:getRewardIcon(nil, arg_46_2.reward, {
			hero_multiply_scale = 0.82,
			pet_multiply_scale = 0.82,
			multiply_scale = 0.84,
			parent = var_46_8
		})
	end
end

function FactionSicaReward.refresh(arg_47_0)
	if not arg_47_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_47_0.vars.itemView) then
		return 
	end
	
	arg_47_0.vars.itemView:refresh()
end

function FactionSicaReward.closeRewardPopup(arg_48_0, arg_48_1)
	if not arg_48_1 then
		return 
	end
	
	Dialog:close("achieve_dagger_reward_get")
	
	local var_48_0 = SceneManager:getRunningPopupScene()
	
	BackButtonManager:pop("Dialog.achieve_dagger_reward_get")
	start_new_story(var_48_0, arg_48_1, {
		force = true
	})
end

function FactionSicaReward.showPopupPointReward(arg_49_0, arg_49_1, arg_49_2)
	arg_49_1 = arg_49_1 or {}
	
	if not arg_49_2 then
		Log.e("FactionSicaReward.showPopupPointReward", "no_info")
		
		return 
	end
	
	local var_49_0, var_49_1 = DB("achievement_honor_reward", arg_49_2.reward_id, {
		"story_id",
		"title"
	})
	local var_49_2 = Dialog:open("wnd/achieve_dagger_reward_get", arg_49_0, {
		use_backbutton = false
	})
	
	BackButtonManager:push({
		check_id = "achieve_dagger_reward_get",
		back_func = function()
			arg_49_0:closeRewardPopup(var_49_0)
		end,
		dlg = var_49_2
	})
	SceneManager:getRunningPopupScene():addChild(var_49_2)
	
	local var_49_3 = var_49_2:getChildByName("n_reward")
	local var_49_4 = var_49_2:getChildByName("txt_name")
	local var_49_5 = var_49_2:getChildByName("txt_type")
	
	var_49_2:getChildByName("btn_close").story_id = var_49_0
	
	local var_49_6 = "ma_emo_c2033_angry_001"
	local var_49_7 = 1
	
	for iter_49_0, iter_49_1 in pairs(arg_49_1.new_items or {}) do
		if iter_49_1.code then
			var_49_6 = iter_49_1.code
			var_49_7 = iter_49_1.count
			
			break
		end
	end
	
	if_set(var_49_2, "t_title", T(var_49_1))
	if_set_arrow(var_49_2)
	UIUtil:getRewardIcon(var_49_7 or 1, var_49_6, {
		right_hero_name = true,
		hero_multiply_scale = 1.07,
		show_name = true,
		multiply_scale = 1.2,
		no_bg = true,
		pet_multiply_scale = 1.07,
		right_hero_type = true,
		show_equip_type = true,
		txt_name_width = 220,
		detail = true,
		parent = var_49_3,
		txt_type = var_49_5,
		txt_name = var_49_4
	})
	
	local var_49_8 = var_49_2:getChildByName("n_eff")
	
	if var_49_8 then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_49_8
		})
		UIAction:Add(DELAY(1000), var_49_2, "block")
	end
end

function FactionSicaReward.onBtnGet(arg_51_0, arg_51_1)
	if not arg_51_1.reward_id then
		return 
	end
	
	if arg_51_1.rewardable then
		if arg_51_1.is_open_before_reward then
			query("get_faction_reward", {
				reward_id = arg_51_1.reward_id,
				faction_id = SICA_FACTION_ID
			})
		else
			balloon_message_with_sound("msg_error_sicar_reward_before")
		end
		
		return 
	else
		balloon_message_with_sound("msg_error_lack_sicar_point")
	end
end
