SubStoryTravelMap_v2 = {}

copy_functions(ScrollView, SubStoryTravelMap_v2)

local var_0_0 = 3

function HANDLER.dungeon_story_touristry_new(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "btn_unmove" then
		SubStoryTravelMap_v2:moveToPath()
	elseif arg_1_1 == "btn_opaque" then
		SubStoryTravelMap_v2:retry_travel()
	elseif arg_1_1 == "btn_green" then
		SubStoryTravelMap_v2:req_reward()
		TutorialGuide:procGuide()
	end
end

function HANDLER.touristry_icon_new(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_1 == "btn_touch" and arg_2_0.id then
		SubStoryTravelMap_v2:select_detail(arg_2_0.id)
		TutorialGuide:procGuide()
	end
end

function MsgHandler.substory_travel_misison_complete(arg_3_0)
	if arg_3_0 then
		if arg_3_0.rewards then
			local var_3_0 = {}
			
			Account:addReward(arg_3_0.rewards, {
				play_reward_data = var_3_0
			})
			
			if arg_3_0.rewards.new_equips and arg_3_0.rewards.new_equips[1] and arg_3_0.rewards.new_equips[1].code and string.starts(arg_3_0.rewards.new_equips[1].code, "exc") then
				ShopExclusiveEquip_result:open_resultPopup(arg_3_0, {
					type = "substory_travel"
				})
			end
		end
		
		SubStoryTravelMap_v2:res_rewardItem(arg_3_0)
		ConditionContentsManager:checkUnlockCondition()
	end
end

local var_0_1 = {
	npc_battle = "tag_battle",
	item = "tag_reward",
	story = "tag_story"
}
local var_0_2 = {
	npc_battle = "icon_battle",
	story = "icon_menu_story"
}

function SubStoryTravelMap_v2.show(arg_4_0)
	local var_4_0
	
	if arg_4_0.vars and arg_4_0.vars.cur_data then
		var_4_0 = arg_4_0.vars.cur_data.id
	end
	
	local var_4_1 = SubstoryManager:getInfo()
	
	if not var_4_1 or table.empty(var_4_1) then
		return 
	end
	
	if not var_4_1.contents_type_2 or var_4_1.contents_type_2 ~= "content_travel" then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.wnd = load_dlg("dungeon_story_touristry_new", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_4_0.vars.wnd)
	
	local var_4_2 = DB("content_travel", var_4_1.id, {
		"enter_btn_text"
	})
	
	TopBarNew:createFromPopup(T(var_4_2), arg_4_0.vars.wnd, function()
		arg_4_0:leave()
	end)
	
	local var_4_3 = SubStoryUtil:getTopbarCurrencies(var_4_1, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:setCurrencies(var_4_3)
	
	arg_4_0.vars.substory_id = var_4_1.id
	
	arg_4_0:initBG()
	arg_4_0:updateData()
	arg_4_0:initScrollView(arg_4_0.vars.wnd:getChildByName("scrollview_item"), 1100, 654)
	
	arg_4_0.vars.scrollview_empty_items = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.datas) do
		for iter_4_2, iter_4_3 in pairs(iter_4_1) do
			if iter_4_3.row % 4 == 0 then
				table.insert(arg_4_0.vars.scrollview_empty_items, {})
			end
		end
	end
	
	if arg_4_0.vars.substory_id == "vrimba" then
		table.remove(arg_4_0.vars.scrollview_empty_items, table.count(arg_4_0.vars.scrollview_empty_items))
	end
	
	arg_4_0:createScrollViewItems(arg_4_0.vars.scrollview_empty_items)
	arg_4_0:updateMapAll()
	
	local var_4_4 = arg_4_0:getFirstSelectMissionID()
	
	if var_4_0 then
		var_4_4 = var_4_0
	end
	
	local var_4_5 = arg_4_0:getRowIndex(var_4_4)
	
	arg_4_0:select_detail(var_4_4)
	arg_4_0:addMoreScrollViewSize()
	arg_4_0:scrollToIdx(var_4_5)
	TutorialGuide:procGuide()
end

function SubStoryTravelMap_v2.addMoreScrollViewSize(arg_6_0)
	local var_6_0 = 400
	local var_6_1 = {
		width = arg_6_0.scrollview:getInnerContainerSize().width + var_6_0,
		height = arg_6_0.scrollview:getInnerContainerSize().height
	}
	
	arg_6_0.scrollview:setInnerContainerSize(var_6_1)
	arg_6_0.scrollview:forceDoLayout()
end

function SubStoryTravelMap_v2.scrollToIdx(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = 275
	local var_7_1 = 0 - (var_7_0 * arg_7_1 - var_7_0 * 2 - 100)
	local var_7_2 = math.min(0, var_7_1)
	
	arg_7_0.scrollview:setInnerContainerPosition({
		y = 0,
		x = var_7_2
	})
end

function SubStoryTravelMap_v2.initBG(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) or get_cocos_refid(arg_8_0.vars.layer) or not arg_8_0.vars.substory_id then
		return 
	end
	
	local var_8_0, var_8_1, var_8_2, var_8_3 = DB("content_travel", arg_8_0.vars.substory_id, {
		"id",
		"image_type",
		"image",
		"ambient_color"
	})
	
	if not var_8_0 or not var_8_2 then
		return 
	end
	
	if var_8_1 == "atlas" then
		arg_8_0.vars.layer, arg_8_0.vars.field = FIELD_NEW:create(var_8_2, VIEW_WIDTH * 2)
		
		arg_8_0.vars.layer:setName("travel_bg")
		arg_8_0.vars.layer:setScale(0.6)
		arg_8_0.vars.field:setViewPortPosition(0)
		arg_8_0.vars.field:updateViewport()
		
		local var_8_4 = arg_8_0.vars.wnd:getChildByName("bg_map")
		
		var_8_4:addChild(arg_8_0.vars.layer)
		var_8_4:setVisible(true)
		
		if var_8_3 then
			arg_8_0.vars.layer:setColor(tocolor(var_8_3))
		end
		
		if arg_8_0.vars.scroll_schedule then
			Scheduler:remove(arg_8_0.vars.scroll_schedule)
		end
		
		arg_8_0.vars.scroll_schedule = Scheduler:add(arg_8_0.vars.wnd, SubStoryTravelMap_v2.updateBGScroll, SubStoryTravelMap_v2)
	elseif var_8_1 == "illust" then
		local var_8_5 = arg_8_0.vars.wnd:getChildByName("bg_illust")
		
		if_set_sprite(var_8_5, nil, "img/" .. var_8_2 .. ".png")
		var_8_5:setVisible(true)
	end
end

local var_0_3 = 0

function SubStoryTravelMap_v2.updateBGScroll(arg_9_0)
	if not arg_9_0.vars or not arg_9_0.scrollview and get_cocos_refid(arg_9_0.vars.field) then
		return 
	end
	
	local var_9_0 = 0
	local var_9_1 = 0
	local var_9_2 = arg_9_0.vars.field:getWidth()
	local var_9_3, var_9_4 = arg_9_0.scrollview:getInnerContainer():getPosition()
	local var_9_5 = var_9_3 * -1 / 10
	local var_9_6 = math.max(var_9_5, 0)
	local var_9_7 = math.min(var_9_6, var_9_2)
	
	if var_0_3 ~= var_9_7 then
		var_0_3 = var_9_7
	else
		return 
	end
	
	arg_9_0.vars.field:setViewPortPosition(var_9_7, 0)
	arg_9_0.vars.field:updateViewport()
end

function SubStoryTravelMap_v2.getRowIndex(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return 0
	end
	
	local var_10_0 = 0
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.datas) do
		for iter_10_2, iter_10_3 in pairs(iter_10_1) do
			if iter_10_3.id == arg_10_1 then
				return iter_10_0
			end
		end
	end
	
	return var_10_0
end

function SubStoryTravelMap_v2.findDataById(arg_11_0, arg_11_1)
	if not arg_11_1 then
		return 
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.datas) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1) do
			if iter_11_3.id == arg_11_1 then
				return iter_11_3
			end
		end
	end
end

function SubStoryTravelMap_v2.getFirstSelectMissionID(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) or not arg_12_0.vars.datas then
		return 
	end
	
	local var_12_0
	
	for iter_12_0 = 1, 999 do
		local var_12_1 = string.format("%s_%03d", arg_12_0.vars.substory_id, iter_12_0)
		local var_12_2 = arg_12_0:findDataById(var_12_1)
		
		if not var_12_2 then
			break
		end
		
		if not var_12_2.is_locked and not var_12_2.is_received_reward and var_12_2.can_receive_reward then
			var_12_0 = var_12_2.id
			
			return var_12_0
		end
	end
	
	if not var_12_0 then
		for iter_12_1 = 1, 999 do
			local var_12_3 = string.format("%s_%03d", arg_12_0.vars.substory_id, iter_12_1)
			local var_12_4 = arg_12_0:findDataById(var_12_3)
			
			if not var_12_4 then
				break
			end
			
			if not var_12_4.is_locked and not var_12_4.is_received_reward then
				var_12_0 = var_12_4.id
				
				return var_12_0
			end
		end
	end
	
	local var_12_5
	
	if not var_12_0 then
		var_12_5 = table.count(arg_12_0.vars.datas)
		
		if arg_12_0.vars.datas[var_12_5] then
			for iter_12_2 = 1, 3 do
				if arg_12_0.vars.datas[var_12_5][iter_12_2] then
					var_12_0 = arg_12_0.vars.datas[var_12_5][iter_12_2].id
				end
			end
		end
	end
	
	var_12_0 = var_12_0 or string.format("%s_%03d", arg_12_0.vars.substory_id, 1)
	
	return var_12_0
end

function SubStoryTravelMap_v2.getFirstReceivableTargetIcon(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) or not arg_13_0.vars.datas then
		return 
	end
	
	local var_13_0
	local var_13_1
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.datas) do
		for iter_13_2, iter_13_3 in pairs(iter_13_1) do
			if iter_13_3.icon and iter_13_3.can_receive_reward and not iter_13_3.is_received_reward then
				var_13_0 = iter_13_3.icon
				var_13_1 = iter_13_3.id
				
				break
			end
		end
		
		if var_13_0 then
			break
		end
	end
	
	return var_13_0, var_13_1
end

function SubStoryTravelMap_v2.updateData(arg_14_0)
	arg_14_0.vars.datas = {}
	arg_14_0.vars.map_icons = {}
	arg_14_0.vars.max_row = 0
	arg_14_0.vars.row_num = 1
	
	for iter_14_0 = 1, 9999999 do
		local var_14_0 = string.format("%s_%03d", arg_14_0.vars.substory_id, iter_14_0)
		local var_14_1 = DBT("substory_travel", var_14_0, {
			"id",
			"column",
			"row",
			"img_bg",
			"map_bg_icon",
			"map_icon",
			"unlock_predecessor",
			"condition",
			"value",
			"unlock_desc",
			"unlock_move",
			"reward_type",
			"reward_value",
			"reward_count",
			"grade_rate1",
			"set_drop_rate_id1",
			"completion_map_icon",
			"show_check_icon",
			"unlock_text_type",
			"unlock_title"
		})
		
		if not var_14_1 or table.empty(var_14_1) then
			break
		end
		
		if var_14_1.row > arg_14_0.vars.max_row then
			arg_14_0.vars.max_row = var_14_1.row
		end
		
		if var_14_1.column > var_0_0 then
			Log.e("Err: wrong column value  id: ", id, "column: ", var_14_1.column)
		end
		
		if not arg_14_0.vars.datas[var_14_1.row] then
			arg_14_0.vars.datas[var_14_1.row] = {}
		end
		
		if arg_14_0.vars.datas[var_14_1.row][var_14_1.column] then
			local var_14_2 = arg_14_0.vars.datas[var_14_1.row][var_14_1.column]
			
			Log.e("Err: overlap position!!  id: ", var_14_1.id, "same id: ", var_14_2.id, "column: ", var_14_1.column, "row: ", var_14_1.row)
		end
		
		if var_14_1.value then
			var_14_1.value = totable(var_14_1.value)
		end
		
		local var_14_3 = not var_14_1.condition and not var_14_1.value
		
		var_14_1.is_cleared = SubStoryTravel:isClearedMission(var_14_1.id)
		var_14_1.state = (SubStoryTravel:getMissionInfo(var_14_1.id) or {}).state
		var_14_1.is_locked = arg_14_0:_isLocked(var_14_1)
		var_14_1.is_received_reward = SubStoryTravel:isReceivedReward(var_14_1.id)
		var_14_1.can_receive_reward = SubStoryTravel:canReceiveReward(var_14_1.id, var_14_3)
		
		if var_14_1.can_receive_reward then
			var_14_1.is_received_prev_reward = arg_14_0:is_received_prev_reward(var_14_1)
		end
		
		arg_14_0.vars.datas[var_14_1.row][var_14_1.column] = var_14_1
	end
	
	for iter_14_1 = 1, arg_14_0.vars.max_row do
		if not arg_14_0.vars.map_icons[iter_14_1] then
			arg_14_0.vars.map_icons[iter_14_1] = {}
		end
		
		for iter_14_2 = 1, var_0_0 do
		end
	end
end

function SubStoryTravelMap_v2._isLocked(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	local var_15_0 = arg_15_1.id
	local var_15_1 = arg_15_1.unlock_predecessor
	
	if not var_15_1 then
		return 
	end
	
	local var_15_2 = false
	local var_15_3
	local var_15_4 = false
	local var_15_5 = false
	
	if var_15_1 then
		for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.datas) do
			for iter_15_2, iter_15_3 in pairs(iter_15_1) do
				if iter_15_3.id and iter_15_3.id == var_15_1 then
					if iter_15_3.is_locked then
						var_15_3 = true
					end
					
					var_15_4 = iter_15_3.can_receive_reward
					var_15_5 = iter_15_3.is_received_reward
					
					break
				end
			end
			
			if var_15_3 ~= nil then
				break
			end
		end
	end
	
	if arg_15_1.reward_type == "item" and var_15_5 then
		var_15_2 = false
	end
	
	if not var_15_3 then
		if not var_15_3 and not var_15_5 and not var_15_4 then
			var_15_2 = true
		end
		
		if var_15_5 then
			var_15_2 = false
		end
	end
	
	if var_15_3 == true or var_15_5 == false then
		var_15_2 = true
	end
	
	return var_15_2
end

function SubStoryTravelMap_v2.is_received_prev_reward(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.unlock_predecessor
	local var_16_1 = true
	
	if var_16_0 then
		var_16_1 = SubStoryTravel:isReceivedReward(var_16_0)
	end
	
	return var_16_1
end

function SubStoryTravelMap_v2.getScrollViewItem(arg_17_0, arg_17_1)
	local var_17_0 = load_control("wnd/dungeon_story_touristry_item_new.csb")
	local var_17_1 = {}
	
	for iter_17_0 = 1, 4 do
		local var_17_2 = string.format("%s_%02d", "n_map", iter_17_0)
		local var_17_3 = var_17_0:getChildByName(var_17_2)
		
		if var_17_3 then
			table.insert(var_17_1, var_17_3)
		end
	end
	
	local var_17_4 = {}
	
	for iter_17_1, iter_17_2 in pairs(var_17_1) do
		var_17_4[iter_17_1] = {}
		
		for iter_17_3 = 1, 3 do
			if not var_17_4[iter_17_1][iter_17_3] then
				var_17_4[iter_17_1][iter_17_3] = {}
			end
			
			local var_17_5 = string.format("%s_%02d", "n", iter_17_3)
			local var_17_6 = iter_17_2:getChildByName(var_17_5)
			
			if var_17_6 then
				var_17_6:setVisible(false)
				
				var_17_4[iter_17_1][iter_17_3] = var_17_6
				
				if_set_visible(var_17_6, "icon", false)
				
				local var_17_7 = load_control("wnd/touristry_icon_new.csb")
				
				var_17_6:addChild(var_17_7)
			end
		end
	end
	
	local var_17_8 = 1
	
	for iter_17_4 = arg_17_0.vars.row_num, arg_17_0.vars.row_num + 4 do
		if arg_17_0.vars.map_icons[iter_17_4] then
			for iter_17_5 = 1, 3 do
				if arg_17_0.vars.map_icons[iter_17_4] and var_17_4[var_17_8] and var_17_4[var_17_8][iter_17_5] then
					arg_17_0.vars.map_icons[iter_17_4][iter_17_5] = var_17_4[var_17_8][iter_17_5]
				end
			end
		end
		
		var_17_8 = var_17_8 + 1
	end
	
	arg_17_0.vars.row_num = arg_17_0.vars.row_num + 4
	
	if_set_visible(var_17_0, "selected", false)
	
	return var_17_0
end

function SubStoryTravelMap_v2.updateMapAll(arg_18_0)
	arg_18_0:updateMapData()
	arg_18_0:updateMapIcon()
	arg_18_0:drawLines()
	arg_18_0:updateProgress()
end

function SubStoryTravelMap_v2.updateProgress(arg_19_0)
	local var_19_0 = arg_19_0.vars.wnd:getChildByName("n_count")
	
	if not get_cocos_refid(var_19_0) then
		return 
	end
	
	local var_19_1 = var_19_0:getChildByName("n_progress")
	local var_19_2 = 0
	local var_19_3 = 0
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.datas) do
		for iter_19_2, iter_19_3 in pairs(iter_19_1) do
			var_19_3 = var_19_3 + 1
			
			if iter_19_3.is_cleared then
				var_19_2 = var_19_2 + 1
			end
		end
	end
	
	local var_19_4 = var_19_0:getChildByName("progress_bar")
	local var_19_5 = var_19_0:getChildByName("n_progress")
	local var_19_6 = var_19_5:getChildByName("@progress")
	
	if not var_19_6 then
		var_19_4:setVisible(false)
		
		local var_19_7 = WidgetUtils:createCircleProgress("img/cm_hero_circool1.png")
		
		var_19_7:setCascadeOpacityEnabled(true)
		var_19_7:setScale(var_19_4:getScale())
		var_19_7:setPosition(var_19_4:getPosition())
		var_19_7:setOpacity(var_19_4:getOpacity())
		var_19_7:setColor(var_19_4:getColor())
		var_19_7:setReverseDirection(false)
		var_19_7:setName("@progress")
		var_19_7:setPercentage(math.floor(var_19_2 / var_19_3 * 100))
		var_19_5:addChild(var_19_7)
		
		var_19_6 = var_19_7
		
		local var_19_8 = var_19_0:getChildByName("icon_menu")
		local var_19_9 = DB("content_travel", arg_19_0.vars.substory_id, {
			"enter_btn_icon"
		})
		
		if get_cocos_refid(var_19_8) and var_19_9 then
			if_set_sprite(var_19_8, nil, var_19_9)
		end
	end
	
	local var_19_10 = math.floor(100 * (var_19_2 / var_19_3))
	local var_19_11 = math.min(var_19_10, 100)
	
	var_19_6:setPercentage(0)
	
	local var_19_12 = var_19_11 / 0.3
	
	UIAction:Add(SEQ(PERCENTAGE(var_19_12, 0, var_19_11)), var_19_6, "progress_action")
	if_set(var_19_0, "txt_count", tostring(var_19_2) .. " / " .. tostring(var_19_3))
end

function SubStoryTravelMap_v2.updateMapData(arg_20_0)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.map_icons) do
		for iter_20_2, iter_20_3 in pairs(iter_20_1) do
			if arg_20_0.vars.datas[iter_20_0][iter_20_2] then
				local var_20_0 = arg_20_0.vars.datas[iter_20_0][iter_20_2]
				
				iter_20_3.is_hide = true
				
				if_set_visible(iter_20_3, nil, true)
				
				local var_20_1 = iter_20_3:getWorldPosition()
				
				var_20_0.x = var_20_1.x
				var_20_0.y = var_20_1.y
				var_20_0.icon = iter_20_3
				
				local var_20_2 = iter_20_3:getChildByName("btn_touch")
				
				if get_cocos_refid(var_20_2) then
					var_20_2.id = var_20_0.id
				end
			end
		end
	end
end

function SubStoryTravelMap_v2.updateMapIcon(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1 or {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.map_icons) do
		for iter_21_2, iter_21_3 in pairs(iter_21_1) do
			local var_21_1 = arg_21_0.vars.datas[iter_21_0][iter_21_2]
			
			if var_21_1 then
				local var_21_2 = var_21_1.is_locked
				local var_21_3 = var_21_1.is_cleared
				local var_21_4 = var_21_1.is_received_reward
				local var_21_5 = iter_21_3:getChildByName("map")
				
				if_set_sprite(iter_21_3, "img_icon", "map/" .. var_21_1.map_icon .. ".png")
				if_set_sprite(iter_21_3, "n_tag", "map/" .. var_0_1[var_21_1.reward_type] .. ".png")
				if_set_color(var_21_5, "icon", var_21_2 and tocolor("#888888") or tocolor("#ffffff"))
				if_set_visible(iter_21_3, "icon_etclock", var_21_2)
				if_set_visible(iter_21_3, "icon_clear_check", var_21_1.show_check_icon and var_21_4)
				
				if arg_21_0.vars.cur_data then
					if_set_visible(iter_21_3, "selected", var_21_1 == arg_21_0.vars.cur_data)
				end
				
				if var_21_1.completion_map_icon and var_21_3 then
					if_set_sprite(iter_21_3, "img_icon", "map/" .. var_21_1.completion_map_icon .. ".png")
				end
				
				if_set_visible(iter_21_3, "img_bg", var_21_1.map_bg_icon)
				
				if var_21_1.map_bg_icon then
					if_set_sprite(iter_21_3, "img_bg", var_21_1.map_bg_icon)
				end
				
				local var_21_6 = var_21_1.can_receive_reward
				
				if not var_21_0.ignore_eff_update then
					if not var_21_2 and var_21_6 and not var_21_4 and not iter_21_3.reward_eff then
						iter_21_3.reward_eff = EffectManager:Play({
							pivot_x = 0,
							fn = "ui_limited_reward.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							scale = 1.5,
							layer = iter_21_3
						})
					elseif not var_21_2 and not var_21_4 and not var_21_6 then
						iter_21_3.reward_eff = EffectManager:Play({
							pivot_x = 0,
							fn = "travel_select_guide.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							layer = iter_21_3
						})
					elseif iter_21_3.reward_eff then
						iter_21_3.reward_eff:removeFromParent()
						
						iter_21_3.reward_eff = nil
					end
					
					if arg_21_0:isShowNewEff(var_21_1.id) then
						EffectManager:Play({
							pivot_x = 0,
							fn = "ui_stage_unlock.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							layer = iter_21_3
						})
					end
				end
			end
		end
	end
end

function SubStoryTravelMap_v2.drawLines(arg_22_0)
	arg_22_0.vars.lines = {}
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.map_icons) do
		for iter_22_2, iter_22_3 in pairs(iter_22_1) do
			local var_22_0 = arg_22_0.vars.datas[iter_22_0][iter_22_2]
			
			if var_22_0 and var_22_0.unlock_predecessor then
				local var_22_1 = string.split(var_22_0.unlock_predecessor, ",")
				
				for iter_22_4, iter_22_5 in pairs(var_22_1) do
					local var_22_2 = arg_22_0:findMapDataByID(iter_22_5)
					
					if var_22_2 then
						local var_22_3 = 0
						local var_22_4 = 0
						local var_22_5 = var_22_2.column
						local var_22_6 = var_22_2.row
						local var_22_7 = var_22_0.column
						local var_22_8 = var_22_0.row
						local var_22_9 = {
							x = 0,
							y = 0
						}
						local var_22_10 = {
							x = var_22_0.x - var_22_2.x,
							y = (var_22_0.y - var_22_2.y) * -1
						}
						local var_22_11 = cc.Node:create()
						local var_22_12
						local var_22_13 = 0
						local var_22_14
						
						if not var_22_0.is_locked then
							var_22_12 = "img/cm_select_lineon.png"
							var_22_14 = 255
						else
							var_22_12 = "img/cm_select_lineoff.png"
							var_22_14 = 191.25
						end
						
						local var_22_15 = 0.9
						
						var_22_11:setPosition(var_22_9.x, var_22_9.y)
						
						local var_22_16 = var_22_11:getContentSize()
						
						var_22_11:setAnchorPoint(0.5, 0.5)
						
						local var_22_17 = math.sqrt(math.pow(var_22_10.x - var_22_9.x, 2) + math.pow(var_22_10.y - var_22_9.y, 2))
						local var_22_18 = WorldMapTown:getDegreesFromTo(var_22_9, var_22_10)
						
						var_22_11:setRotation(var_22_18)
						var_22_2.icon:addChild(var_22_11)
						addLine(var_22_11, var_22_12, var_22_17 * var_22_15, true)
						var_22_11:setCascadeOpacityEnabled(true)
						var_22_11:setOpacity(var_22_14)
						var_22_11:setLocalZOrder(-9999)
						
						local var_22_19 = {
							[var_22_0.id] = {
								var_22_11,
								var_22_18,
								var_22_17,
								var_22_0.id
							}
						}
						
						table.insert(arg_22_0.vars.lines, var_22_19)
					end
				end
			end
		end
	end
	
	for iter_22_6 = 1, 99999 do
		local var_22_20 = string.format("%s_%03d", arg_22_0.vars.substory_id, iter_22_6)
		local var_22_21, var_22_22 = DB("substory_travel", var_22_20, {
			"id",
			"unlock_predecessor_table"
		})
		
		if not var_22_21 then
			break
		end
		
		local var_22_23 = arg_22_0:findMapDataByID(var_22_21)
		
		if var_22_23 then
			var_22_23.icon:bringToFront()
		end
	end
end

function SubStoryTravelMap_v2.findMapDataByID(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.datas) do
		for iter_23_2, iter_23_3 in pairs(iter_23_1) do
			if iter_23_3.id == arg_23_1 then
				return iter_23_3
			end
		end
	end
end

function SubStoryTravelMap_v2.moveToPath(arg_24_0)
	if not arg_24_0.vars.cur_data then
		return 
	end
	
	local var_24_0 = SubstoryManager:getInfo()
	
	if not SubstoryManager:isActiveSchedule(var_24_0.id) then
		balloon_message_with_sound("end_sub_story_event")
		
		return 
	end
	
	local var_24_1 = WorldMapManager:getController()
	
	if var_24_1 then
		var_24_1:removeMovePathDelay()
	end
	
	if arg_24_0.vars.cur_data.is_locked then
		balloon_message_with_sound("notyet_adv")
	elseif arg_24_0.vars.cur_data.unlock_move then
		movetoPath(arg_24_0.vars.cur_data.unlock_move)
	else
		balloon_message_with_sound("substory_travel_reward_yet")
	end
end

function SubStoryTravelMap_v2.req_reward(arg_25_0, arg_25_1)
	if not arg_25_0.vars.substory_id or not arg_25_0.vars.cur_data then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.cur_data
	
	if var_25_0.is_locked or not var_25_0.is_received_prev_reward then
		balloon_message_with_sound("substory_travel_reward_yet")
		
		return 
	elseif var_25_0.is_received_reward then
		balloon_message_with_sound("substory_travel_reward_complete")
		
		return 
	end
	
	if var_25_0.reward_type == "item" then
		if var_25_0.can_receive_reward then
			query("substory_travel_misison_complete", {
				substory_id = arg_25_0.vars.substory_id,
				mission_id = var_25_0.id
			})
		else
			balloon_message_with_sound("substory_travel_reward_yet")
		end
	elseif var_25_0.reward_type == "npc_battle" then
		SubStoryTravelMap_v2:startNPCBattle()
	elseif var_25_0.reward_type == "story" then
		SubStoryTravelMap_v2:play_story()
	end
end

function SubStoryTravelMap_v2.retry_travel(arg_26_0, arg_26_1)
	if not arg_26_0.vars.substory_id or not arg_26_0.vars.cur_data then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.cur_data
	
	if var_26_0.reward_type == "npc_battle" then
		SubStoryTravelMap_v2:startNPCBattle({
			play_again = true
		})
	elseif var_26_0.reward_type == "story" then
		SubStoryTravelMap_v2:play_story({
			play_again = true
		})
	end
end

function SubStoryTravelMap_v2.select_detail(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_1 then
		return 
	end
	
	local var_27_0 = arg_27_2 or {}
	local var_27_1 = false
	
	if arg_27_0.vars.cur_data then
		var_27_1 = arg_27_1 == arg_27_0.vars.cur_data.id
	end
	
	if var_27_0.force_update_eff then
		var_27_1 = false
	end
	
	arg_27_0.vars.cur_data = arg_27_0:findMapDataByID(arg_27_1)
	
	if not arg_27_0.vars.cur_data then
		return 
	end
	
	local var_27_2 = arg_27_0.vars.cur_data.is_cleared
	local var_27_3 = SubStoryTravel:getMissionInfo(arg_27_0.vars.cur_data.id)
	
	arg_27_0:updateMapIcon({
		ignore_eff_update = true
	})
	arg_27_0:update_detail_info({
		ignore_eff_update = var_27_1
	})
end

function SubStoryTravelMap_v2.update_button(arg_28_0)
	if not arg_28_0.vars.cur_data then
		return 
	end
	
	if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
	if_set_visible(arg_28_0.vars.wnd, "btn_green", false)
	if_set_visible(arg_28_0.vars.wnd, "btn_unmove", false)
	
	local var_28_0 = arg_28_0.vars.cur_data
	local var_28_1 = var_28_0.is_locked
	local var_28_2 = var_28_0.can_receive_reward
	local var_28_3 = var_28_0.is_received_reward
	local var_28_4 = var_28_0.is_received_prev_reward
	local var_28_5 = var_28_0.is_cleared
	local var_28_6 = var_28_0.state
	local var_28_7 = var_28_0.reward_type
	local var_28_8 = var_28_0.unlock_move
	local var_28_9
	local var_28_10
	local var_28_11 = 255
	
	if var_28_1 then
		if var_28_6 == SUBSTORY_TRAVEL_STATE.CLEAR then
			var_28_11 = 76.5
			var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_green")
			
			if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_green", true)
			if_set(var_28_9, "text", T("guidequest_reward_get"))
		elseif var_28_8 then
			var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_unmove")
			
			if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_green", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_unmove", true)
			if_set(var_28_9, "text", T("go"))
		else
			var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_green")
			
			if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_green", true)
			if_set_visible(arg_28_0.vars.wnd, "btn_unmove", false)
			if_set(var_28_9, "text", T("guidequest_reward_get"))
			
			var_28_11 = 76.5
		end
	elseif var_28_3 then
		var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_opaque")
		
		if_set_visible(arg_28_0.vars.wnd, "btn_opaque", true)
		if_set_visible(arg_28_0.vars.wnd, "btn_green", false)
		if_set_visible(arg_28_0.vars.wnd, "btn_unmove", false)
		
		if var_28_7 == "item" then
			var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_green")
			
			if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_green", true)
			
			var_28_11 = 76.5
			var_28_10 = T("guidequest_reward_get")
		elseif var_28_7 == "story" then
			var_28_10 = T("ui_customdlc_restory_btn")
		elseif var_28_7 == "npc_battle" then
			var_28_10 = T("battle_start_replay")
		end
		
		if_set(var_28_9, "text", var_28_10)
	elseif var_28_2 then
		if not var_28_4 then
			var_28_11 = 76.5
		end
		
		var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_green")
		
		local var_28_12 = T("guidequest_reward_get")
		
		if_set(var_28_9, "text", var_28_12)
		if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
		if_set_visible(arg_28_0.vars.wnd, "btn_green", true)
		if_set_visible(arg_28_0.vars.wnd, "btn_unmove", false)
	else
		local var_28_13 = true
		
		if var_28_0.unlock_predecessor then
			local var_28_14 = SubStoryTravel:isReceivedReward(var_28_0.unlock_predecessor)
		end
		
		if not var_28_5 then
			var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_unmove")
			
			if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_green", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_unmove", true)
			
			if var_28_8 then
				if_set(var_28_9, "text", T("go"))
			else
				if_set(var_28_9, "text", T("guidequest_reward_get"))
				
				var_28_11 = 76.5
			end
		else
			var_28_9 = arg_28_0.vars.wnd:getChildByName("btn_green")
			
			local var_28_15 = T("guidequest_reward_get")
			
			if_set(var_28_9, "text", var_28_15)
			
			var_28_11 = 76.5
			
			if_set_visible(arg_28_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_28_0.vars.wnd, "btn_green", true)
			if_set_visible(arg_28_0.vars.wnd, "btn_unmove", false)
		end
	end
	
	local var_28_16
	
	if var_28_7 == "item" then
		var_28_16 = "cm_icon_etcdown"
	elseif var_28_7 == "story" then
		var_28_16 = "cm_icon_etcstory"
	elseif var_28_7 == "npc_battle" then
		var_28_16 = "cm_icon_etcbp"
	end
	
	if var_28_9 then
		if var_28_16 then
			if_set_sprite(var_28_9, "icon", "img/" .. var_28_16 .. ".png")
		end
		
		if_set_opacity(var_28_9, nil, var_28_11)
	end
	
	if var_28_7 == "story" or var_28_7 == "npc_battle" then
		if_set_visible(arg_28_0.vars.wnd, "n_icon", true)
		
		if var_28_16 then
			local var_28_17 = var_0_2[var_28_7]
			
			if_set_sprite(arg_28_0.vars.wnd, "n_icon", "img/" .. var_28_17 .. ".png")
		end
	else
		if_set_visible(arg_28_0.vars.wnd, "n_icon", false)
	end
	
	local var_28_18 = SubstoryManager:getInfo()
	
	if not SubstoryManager:isActiveSchedule(var_28_18.id) or var_28_1 then
		if_set_opacity(arg_28_0.vars.wnd, "btn_unmove", 76.5)
	end
end

function SubStoryTravelMap_v2.update_detail_info(arg_29_0, arg_29_1)
	if not arg_29_0.vars.cur_data then
		return 
	end
	
	local var_29_0 = arg_29_1 or {}
	
	if_set_visible(arg_29_0.vars.wnd, "btn_opaque", false)
	if_set_visible(arg_29_0.vars.wnd, "btn_green", false)
	if_set_visible(arg_29_0.vars.wnd, "btn_unmove", false)
	
	local var_29_1 = arg_29_0.vars.wnd:getChildByName("RIGHT")
	local var_29_2 = arg_29_0.vars.wnd:getChildByName("n_content")
	local var_29_3 = arg_29_0.vars.cur_data
	local var_29_4 = var_29_3.reward_type
	local var_29_5 = var_29_3.is_cleared
	local var_29_6 = var_29_3.state
	local var_29_7 = var_29_3.unlock_move
	local var_29_8 = var_29_3.is_locked
	local var_29_9 = var_29_3.can_receive_reward
	local var_29_10 = var_29_3.is_received_reward
	local var_29_11 = var_29_3.value
	
	arg_29_0:update_button()
	
	local var_29_12 = var_29_3.unlock_text_type
	
	if var_29_12 == "large" then
		if_set(var_29_1, "txt_title", T(var_29_3.unlock_title))
		if_set(var_29_1, "txt_name", T(var_29_3.unlock_desc))
		if_set_opacity(var_29_1, "txt_title", not var_29_8 and 255 or 1022)
		
		if var_29_8 then
			if_set_color(var_29_1, "txt_title", tocolor("#926D3E"))
		elseif var_29_10 or var_29_9 then
			if_set_color(var_29_1, "txt_title", tocolor("#6BC11B"))
		else
			if_set_color(var_29_1, "txt_title", tocolor("#AB8759"))
		end
	elseif var_29_12 == "small" then
		if_set(var_29_1, "txt_name", T(var_29_3.unlock_desc))
	end
	
	if_set(var_29_1, "txt_info", T(var_29_3.unlock_desc))
	
	if var_29_11 then
		if_set_visible(var_29_2, "progress_bg", true)
		if_set_visible(var_29_1, "txt_info", false)
		if_set_visible(var_29_1, "txt_title", var_29_12 == "large" and var_29_3.unlock_title)
		if_set_visible(var_29_1, "txt_name", var_29_3.unlock_desc)
	else
		if_set_visible(var_29_2, "progress_bg", false)
		if_set_visible(var_29_1, "txt_info", true)
		if_set_visible(var_29_1, "txt_name", false)
		if_set_visible(var_29_1, "txt_title", false)
		if_set_visible(var_29_1, "txt_title", var_29_12 == "large" and var_29_3.unlock_title)
	end
	
	if_set_visible(var_29_1, "img_bg", var_29_3.map_bg_icon)
	
	if var_29_3.map_bg_icon then
		if_set_sprite(var_29_1, "img_bg", var_29_3.map_bg_icon)
	end
	
	local var_29_13 = var_29_4 and var_29_4 == "item"
	local var_29_14 = var_29_1:getChildByName("n_content")
	local var_29_15 = var_29_1:getChildByName("n_reward_info")
	
	if var_29_13 and var_29_3.reward_value then
		local var_29_16 = var_29_3.reward_value
		local var_29_17 = var_29_3.reward_count
		local var_29_18 = string.starts(var_29_3.reward_value, "ef")
		local var_29_19 = string.starts(var_29_3.reward_value, "m")
		local var_29_20 = 1
		local var_29_21
		
		if var_29_18 then
			var_29_21 = getChildByPath(var_29_15, "n_art")
			var_29_20 = 1.2
		elseif var_29_19 then
			var_29_21 = getChildByPath(var_29_15, "n_mob")
		else
			var_29_21 = getChildByPath(var_29_15, "n_reward")
		end
		
		if_set_visible(var_29_1, "n_art", var_29_18)
		if_set_visible(var_29_1, "n_mob", var_29_19)
		if_set_visible(var_29_15, "n_reward", not var_29_19 and not var_29_18)
		
		if var_29_21 then
			var_29_21:setVisible(true)
			UIUtil:getRewardIcon(var_29_17, var_29_16, {
				no_detail_popup = true,
				parent = var_29_21,
				set_drop = var_29_3.set_drop_rate_id1,
				grade_rate = var_29_3.grade_rate1,
				scale = var_29_20
			})
		end
	else
		if_set_visible(var_29_15, "n_reward", false)
		if_set_visible(var_29_1, "n_item", false)
		if_set_visible(var_29_1, "n_art", false)
		if_set_visible(var_29_1, "n_mob", false)
	end
	
	if var_29_10 then
		var_29_15:setColor(tocolor("#888888"))
	else
		var_29_15:setColor(tocolor("#ffffff"))
	end
	
	if_set_visible(arg_29_0.vars.wnd, "icon_check", var_29_10)
	
	local var_29_22 = var_29_1:getChildByName("n_map")
	
	if not arg_29_0.vars.detail_map_icon then
		var_29_22:removeAllChildren()
		
		arg_29_0.vars.detail_map_icon = load_control("wnd/touristry_icon_new.csb")
		
		var_29_22:addChild(arg_29_0.vars.detail_map_icon)
	end
	
	if_set_sprite(var_29_22, "img_icon", "map/" .. var_29_3.map_icon .. ".png")
	if_set_sprite(var_29_22, "n_tag", "map/" .. var_0_1[var_29_3.reward_type] .. ".png")
	
	if var_29_3.map_bg_icon then
		if_set_sprite(var_29_22, "img_bg", var_29_3.map_bg_icon)
	end
	
	if_set_color(arg_29_0.vars.detail_map_icon:getChildByName("map"), "icon", var_29_8 and tocolor("#888888") or tocolor("#ffffff"))
	if_set_visible(var_29_22, "icon_etclock", var_29_8)
	
	local var_29_23 = getChildByPath(var_29_1, "icon_clear_check")
	
	if_set_visible(var_29_23, nil, var_29_10)
	
	if not var_29_0.ignore_eff_update then
		if get_cocos_refid(var_29_22.eff) then
			var_29_22.eff:removeFromParent()
			
			var_29_22.eff = nil
		end
		
		if not var_29_8 and var_29_9 and not var_29_10 then
			var_29_22.eff = EffectManager:Play({
				pivot_x = 0,
				fn = "ui_limited_reward.cfx",
				pivot_y = 0,
				pivot_z = 99998,
				scale = 1.5,
				layer = var_29_22
			})
		elseif not var_29_8 and not var_29_10 and not var_29_9 then
			var_29_22.eff = EffectManager:Play({
				pivot_x = 0,
				fn = "travel_select_guide.cfx",
				pivot_y = 0,
				pivot_z = 99998,
				layer = var_29_22
			})
		end
	end
	
	arg_29_0:update_progress()
end

function SubStoryTravelMap_v2.update_progress(arg_30_0)
	if not arg_30_0.vars.cur_data then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("n_content")
	local var_30_1 = arg_30_0.vars.wnd:getChildByName("RIGHT")
	local var_30_2 = arg_30_0.vars.cur_data.value
	
	if var_30_2 and get_cocos_refid(var_30_0) then
		local var_30_3 = var_30_0:getChildByName("progress_bg")
		local var_30_4 = tonumber(var_30_2.count) or 0
		local var_30_5 = SubStoryTravel:getMissionInfo(arg_30_0.vars.cur_data.id) or {}
		local var_30_6 = tonumber(var_30_5.score1) or 0
		
		if_set_percent(var_30_3, "progress_bar", var_30_6 / var_30_4)
		if_set(var_30_0, "t_percent", var_30_6 .. "/" .. var_30_4)
		
		if var_30_4 <= var_30_6 then
			if_set_color(var_30_3, "progress_bar", cc.c3b(107, 193, 27))
		else
			if_set_color(var_30_3, "progress_bar", cc.c3b(146, 109, 62))
		end
	end
end

function SubStoryTravelMap_v2.isShowNewEff(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not arg_31_0.vars.next_mission_id or not arg_31_1 then
		return 
	end
	
	return table.find(arg_31_0.vars.next_mission_id, arg_31_1)
end

function SubStoryTravelMap_v2.res_rewardItem(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.info
	
	if var_32_0 and var_32_0.contents_id then
		Account:updateSubStoryTravelMission(var_32_0.contents_id, arg_32_1.info)
	end
	
	local var_32_1 = var_32_0.contents_id
	
	if var_32_1 then
		arg_32_0.vars.next_mission_id = {}
		
		for iter_32_0 = 1, 99999 do
			local var_32_2 = string.format("%s_%03d", arg_32_0.vars.substory_id, iter_32_0)
			local var_32_3, var_32_4 = DB("substory_travel", var_32_2, {
				"id",
				"unlock_predecessor"
			})
			
			if not var_32_3 then
				break
			end
			
			if var_32_4 and var_32_4 == var_32_1 then
				table.insert(arg_32_0.vars.next_mission_id, var_32_3)
			end
		end
	end
	
	if arg_32_0.vars and get_cocos_refid(arg_32_0.vars.wnd) then
		arg_32_0:updateData()
		arg_32_0:createScrollViewItemsKeepPosition(arg_32_0.vars.scrollview_empty_items)
		arg_32_0:updateMapAll()
		arg_32_0:select_detail(var_32_0.contents_id, {
			force_update_eff = true
		})
		
		local var_32_5 = arg_32_0:getRowIndex(var_32_0.contents_id)
		
		arg_32_0:addMoreScrollViewSize()
		arg_32_0:scrollToIdx(var_32_5)
	end
	
	arg_32_0.vars.next_mission_id = nil
end

function SubStoryTravelMap_v2.leave_detail(arg_33_0)
	arg_33_0.vars.cur_data = nil
end

function SubStoryTravelMap_v2.startNPCBattle(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.wnd) or not arg_34_0.vars.cur_data then
		return 
	end
	
	local var_34_0 = (arg_34_1 or {}).play_again or false
	local var_34_1 = arg_34_0.vars.cur_data
	local var_34_2, var_34_3 = DB("level_enter", var_34_1.reward_value, {
		"id",
		"contents_type"
	})
	local var_34_4 = SubstoryManager:getInfo()
	
	if not var_34_2 or not var_34_3 or not var_34_4 or table.empty(var_34_4) then
		return 
	end
	
	if var_34_3 == "substory" then
		BattleReady:show({
			enter_id = var_34_2,
			callback = arg_34_0,
			play_again = var_34_0
		})
	end
end

function SubStoryTravelMap_v2.onStartBattle(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not arg_35_0.vars.cur_data then
		return 
	end
	
	local var_35_0 = arg_35_0.vars.cur_data
	
	if not arg_35_1.npcteam_id then
		return 
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_35_1.enter_id)
	startBattle(arg_35_1.enter_id, arg_35_1)
	BattleReady:hide()
	SubstoryManager:add_after_enter_call("open_travel_map", function()
		SubStoryTravelMap_v2:show()
	end)
	
	if not arg_35_1.play_again then
		query("substory_travel_misison_complete", {
			substory_id = arg_35_0.vars.substory_id,
			mission_id = var_35_0.id
		})
	end
end

function SubStoryTravelMap_v2.setVisible(arg_37_0, arg_37_1)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0.vars.wnd:setVisible(arg_37_1)
end

function SubStoryTravelMap_v2.play_story(arg_38_0, arg_38_1)
	if not arg_38_0.vars or not arg_38_0.vars.cur_data then
		return 
	end
	
	local var_38_0 = arg_38_1 or {}
	local var_38_1 = arg_38_0.vars.cur_data
	local var_38_2 = var_38_0.play_again
	
	if var_38_1.reward_type ~= "story" then
		return 
	end
	
	play_story(var_38_1.reward_value, {
		force = true,
		on_finish = function()
			if not var_38_2 then
				query("substory_travel_misison_complete", {
					substory_id = arg_38_0.vars.substory_id,
					mission_id = var_38_1.id
				})
			end
		end
	})
end

function SubStoryTravelMap_v2.leave(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("story_dlc_chronicle")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE(), CALL(function()
		arg_40_0.vars = nil
	end)), arg_40_0.vars.wnd, "block")
	SubStoryLobby:updateUI()
end
