SubStoryTravelMap = {}

copy_functions(ScrollView, SubStoryTravelMap)

local var_0_0 = 3

function HANDLER.dungeon_story_touristry(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "btn_unmove" then
		SubStoryTravelMap:moveToPath()
	elseif arg_1_1 == "btn_opaque" then
		SubStoryTravelMap:retry_travel()
	elseif arg_1_1 == "btn_green" then
		SubStoryTravelMap:req_reward()
	end
end

function HANDLER.touristry_icon(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_1 == "btn_touch" and arg_2_0.id then
		SubStoryTravelMap:select_detail(arg_2_0.id)
		TutorialGuide:procGuide()
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

function SubStoryTravelMap.show(arg_3_0)
	do return  end
	
	local var_3_0
	
	if arg_3_0.vars and arg_3_0.vars.cur_data then
		var_3_0 = arg_3_0.vars.cur_data.id
	end
	
	local var_3_1 = SubstoryManager:getInfo()
	
	if not var_3_1 or table.empty(var_3_1) then
		return 
	end
	
	if not var_3_1.contents_type_2 or var_3_1.contents_type_2 ~= "content_travel" then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("dungeon_story_touristry", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.wnd)
	TopBarNew:createFromPopup(T("substory_travel_title"), arg_3_0.vars.wnd, function()
		arg_3_0:leave()
	end)
	
	local var_3_2 = SubStoryUtil:getTopbarCurrencies(var_3_1, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:setCurrencies(var_3_2)
	
	arg_3_0.vars.substory_id = var_3_1.id
	
	arg_3_0:initBG()
	arg_3_0:updateData()
	arg_3_0:initScrollView(arg_3_0.vars.wnd:getChildByName("scrollview_touristry_item"), 928, 654)
	
	arg_3_0.vars.scrollview_empty_items = {}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.datas) do
		if iter_3_0 % 4 == 0 then
			table.insert(arg_3_0.vars.scrollview_empty_items, {})
		end
	end
	
	table.insert(arg_3_0.vars.scrollview_empty_items, {})
	arg_3_0:createScrollViewItems(arg_3_0.vars.scrollview_empty_items)
	arg_3_0:updateMapAll()
	
	local var_3_3 = arg_3_0:getFirstSelectMissionID()
	
	if var_3_0 then
		var_3_3 = var_3_0
	end
	
	if TutorialGuide:isPlayingTutorial() then
		local var_3_4
		local var_3_5
		
		var_3_5, var_3_3 = arg_3_0:getFirstReceivableTargetIcon()
	end
	
	local var_3_6 = arg_3_0:getRowIndex(var_3_3)
	
	arg_3_0:select_detail(var_3_3)
	arg_3_0:scrollToIdx(var_3_6)
	TutorialGuide:procGuide()
end

function SubStoryTravelMap.scrollToIdx(arg_5_0, arg_5_1)
	local var_5_0 = 232
	local var_5_1 = 0 - (var_5_0 * arg_5_1 - var_5_0 * 2 - 100)
	local var_5_2 = math.min(0, var_5_1)
	
	arg_5_0.scrollview:setInnerContainerPosition({
		y = 0,
		x = var_5_2
	})
end

function SubStoryTravelMap.initBG(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) or get_cocos_refid(arg_6_0.vars.layer) or not arg_6_0.vars.substory_id then
		return 
	end
	
	local var_6_0, var_6_1, var_6_2 = DB("content_travel", arg_6_0.vars.substory_id, {
		"id",
		"image",
		"ambient_color"
	})
	
	if not var_6_0 or not var_6_1 then
		return 
	end
	
	arg_6_0.vars.layer, arg_6_0.vars.field = FIELD_NEW:create(var_6_1, VIEW_WIDTH * 2)
	
	arg_6_0.vars.layer:setName("travel_bg")
	arg_6_0.vars.layer:setScale(0.6)
	arg_6_0.vars.field:setViewPortPosition(DESIGN_WIDTH * 0.5)
	arg_6_0.vars.field:updateViewport()
	arg_6_0.vars.wnd:getChildByName("bg"):addChild(arg_6_0.vars.layer)
	
	if var_6_2 then
		arg_6_0.vars.layer:setColor(tocolor(var_6_2))
	end
	
	if arg_6_0.vars.scroll_schedule then
		Scheduler:remove(arg_6_0.vars.scroll_schedule)
	end
	
	arg_6_0.vars.scroll_schedule = Scheduler:add(arg_6_0.vars.wnd, SubStoryTravelMap.updateBGScroll, SubStoryTravelMap)
end

local var_0_3 = 0

function SubStoryTravelMap.updateBGScroll(arg_7_0)
	if not arg_7_0.vars or not arg_7_0.scrollview and get_cocos_refid(arg_7_0.vars.field) then
		return 
	end
	
	local var_7_0 = 0
	local var_7_1 = 0
	local var_7_2 = arg_7_0.vars.field:getWidth()
	local var_7_3, var_7_4 = arg_7_0.scrollview:getInnerContainer():getPosition()
	local var_7_5 = var_7_3 * -1 / 10
	local var_7_6 = math.max(var_7_5, 0)
	local var_7_7 = math.min(var_7_6, var_7_2)
	
	if var_0_3 ~= var_7_7 then
		var_0_3 = var_7_7
	else
		return 
	end
	
	arg_7_0.vars.field:setViewPortPosition(var_7_7, 0)
	arg_7_0.vars.field:updateViewport()
end

function SubStoryTravelMap.getRowIndex(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 0
	end
	
	local var_8_0 = 0
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.datas) do
		for iter_8_2, iter_8_3 in pairs(iter_8_1) do
			if iter_8_3.id == arg_8_1 then
				return iter_8_0
			end
		end
	end
	
	return var_8_0
end

function SubStoryTravelMap.findDataById(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.datas) do
		for iter_9_2, iter_9_3 in pairs(iter_9_1) do
			if iter_9_3.id == arg_9_1 then
				return iter_9_3
			end
		end
	end
end

function SubStoryTravelMap.getFirstSelectMissionID(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) or not arg_10_0.vars.datas then
		return 
	end
	
	local var_10_0
	
	for iter_10_0 = 1, 999 do
		local var_10_1 = string.format("%s_%03d", arg_10_0.vars.substory_id, iter_10_0)
		local var_10_2 = arg_10_0:findDataById(var_10_1)
		
		if not var_10_2 then
			break
		end
		
		if not var_10_2.is_locked and not var_10_2.is_received_reward and var_10_2.can_receive_reward then
			var_10_0 = var_10_2.id
			
			return var_10_0
		end
	end
	
	if not var_10_0 then
		for iter_10_1 = 1, 999 do
			local var_10_3 = string.format("%s_%03d", arg_10_0.vars.substory_id, iter_10_1)
			local var_10_4 = arg_10_0:findDataById(var_10_3)
			
			if not var_10_4 then
				break
			end
			
			if not var_10_4.is_locked and not var_10_4.is_received_reward then
				var_10_0 = var_10_4.id
				
				return var_10_0
			end
		end
	end
	
	local var_10_5
	
	if not var_10_0 then
		var_10_5 = table.count(arg_10_0.vars.datas)
		
		if arg_10_0.vars.datas[var_10_5] then
			for iter_10_2 = 1, 3 do
				if arg_10_0.vars.datas[var_10_5][iter_10_2] then
					var_10_0 = arg_10_0.vars.datas[var_10_5][iter_10_2].id
				end
			end
		end
	end
	
	var_10_0 = var_10_0 or string.format("%s_%03d", arg_10_0.vars.substory_id, 1)
	
	return var_10_0
end

function SubStoryTravelMap.getFirstReceivableTargetIcon(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) or not arg_11_0.vars.datas then
		return 
	end
	
	local var_11_0
	local var_11_1
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.datas) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1) do
			if iter_11_3.icon and iter_11_3.can_receive_reward and not iter_11_3.is_received_reward then
				var_11_0 = iter_11_3.icon
				var_11_1 = iter_11_3.id
				
				break
			end
		end
		
		if var_11_0 then
			break
		end
	end
	
	return var_11_0, var_11_1
end

function SubStoryTravelMap.updateData(arg_12_0)
	arg_12_0.vars.datas = {}
	arg_12_0.vars.map_icons = {}
	arg_12_0.vars.max_row = 0
	arg_12_0.vars.row_num = 1
	
	for iter_12_0 = 1, 999 do
		local var_12_0 = string.format("%s_%03d", arg_12_0.vars.substory_id, iter_12_0)
		local var_12_1 = DBT("substory_travel", var_12_0, {
			"id",
			"column",
			"row",
			"map_icon",
			"unlock_predecessor",
			"condition",
			"value",
			"unlock_desc",
			"unlock_move",
			"reward_type",
			"reward_value",
			"reward_count"
		})
		
		if not var_12_1 or table.empty(var_12_1) then
			break
		end
		
		if var_12_1.row > arg_12_0.vars.max_row then
			arg_12_0.vars.max_row = var_12_1.row
		end
		
		if var_12_1.column > var_0_0 then
			Log.e("Err: wrong column value  id: ", id, "column: ", var_12_1.column)
		end
		
		if not arg_12_0.vars.datas[var_12_1.row] then
			arg_12_0.vars.datas[var_12_1.row] = {}
		end
		
		if arg_12_0.vars.datas[var_12_1.row][var_12_1.column] then
			local var_12_2 = arg_12_0.vars.datas[var_12_1.row][var_12_1.column]
			
			Log.e("Err: overlap position!!  id: ", var_12_1.id, "same id: ", var_12_2.id, "column: ", var_12_1.column, "row: ", var_12_1.row)
		end
		
		if var_12_1.value then
			var_12_1.value = totable(var_12_1.value)
		end
		
		local var_12_3 = not var_12_1.condition and not var_12_1.value
		
		var_12_1.is_cleared = SubStoryTravel:isClearedMission(var_12_1.id)
		var_12_1.state = (SubStoryTravel:getMissionInfo(var_12_1.id) or {}).state
		var_12_1.is_locked = arg_12_0:_isLocked(var_12_1)
		var_12_1.is_received_reward = SubStoryTravel:isReceivedReward(var_12_1.id)
		var_12_1.can_receive_reward = SubStoryTravel:canReceiveReward(var_12_1.id, var_12_3)
		
		if var_12_1.can_receive_reward then
			var_12_1.is_received_prev_reward = arg_12_0:is_received_prev_reward(var_12_1)
		end
		
		arg_12_0.vars.datas[var_12_1.row][var_12_1.column] = var_12_1
	end
	
	for iter_12_1 = 1, arg_12_0.vars.max_row do
		if not arg_12_0.vars.map_icons[iter_12_1] then
			arg_12_0.vars.map_icons[iter_12_1] = {}
		end
		
		for iter_12_2 = 1, var_0_0 do
		end
	end
end

function SubStoryTravelMap._isLocked(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return 
	end
	
	local var_13_0 = arg_13_1.id
	local var_13_1 = arg_13_1.unlock_predecessor
	
	if not var_13_1 then
		return 
	end
	
	local var_13_2 = false
	local var_13_3
	local var_13_4 = false
	local var_13_5 = false
	
	if var_13_1 then
		for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.datas) do
			for iter_13_2, iter_13_3 in pairs(iter_13_1) do
				if iter_13_3.id and iter_13_3.id == var_13_1 then
					if iter_13_3.is_locked then
						var_13_3 = true
					end
					
					var_13_4 = iter_13_3.can_receive_reward
					var_13_5 = iter_13_3.is_received_reward
					
					break
				end
			end
			
			if var_13_3 ~= nil then
				break
			end
		end
	end
	
	if arg_13_1.reward_type == "item" and var_13_5 then
		var_13_2 = false
	end
	
	if not var_13_3 then
		if not var_13_3 and not var_13_5 and not var_13_4 then
			var_13_2 = true
		end
		
		if var_13_5 then
			var_13_2 = false
		end
	end
	
	if var_13_3 == true then
		var_13_2 = true
	end
	
	return var_13_2
end

function SubStoryTravelMap._isLocked2(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	local var_14_0 = arg_14_1.id
	local var_14_1 = arg_14_1.unlock_predecessor
	local var_14_2 = SubStoryTravel:isLocked(var_14_0, var_14_1)
	local var_14_3
	local var_14_4 = false
	
	if var_14_1 then
		for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.datas) do
			for iter_14_2, iter_14_3 in pairs(iter_14_1) do
				if iter_14_3.id and iter_14_3.id == var_14_1 then
					if iter_14_3.is_locked or not iter_14_3.is_received_reward and not iter_14_3.can_receive_reward then
						var_14_3 = true
					end
					
					var_14_4 = iter_14_3.can_receive_reward
					
					break
				end
			end
			
			if var_14_3 ~= nil then
				break
			end
		end
		
		if var_14_3 == true then
			var_14_2 = true
		end
	end
	
	if arg_14_1.reward_type == "item" and not var_14_3 and var_14_4 then
		var_14_2 = false
	end
	
	return var_14_2
end

function SubStoryTravelMap.is_received_prev_reward(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.unlock_predecessor
	local var_15_1 = true
	
	if var_15_0 then
		var_15_1 = SubStoryTravel:isReceivedReward(var_15_0)
	end
	
	return var_15_1
end

function SubStoryTravelMap.getScrollViewItem(arg_16_0, arg_16_1)
	local var_16_0 = load_control("wnd/dungeon_story_touristry_item.csb")
	local var_16_1 = {}
	
	for iter_16_0 = 1, 4 do
		local var_16_2 = string.format("%s_%02d", "n_touristry_map", iter_16_0)
		local var_16_3 = var_16_0:getChildByName(var_16_2)
		
		if var_16_3 then
			table.insert(var_16_1, var_16_3)
		end
	end
	
	local var_16_4 = {}
	
	for iter_16_1, iter_16_2 in pairs(var_16_1) do
		var_16_4[iter_16_1] = {}
		
		for iter_16_3 = 1, 3 do
			if not var_16_4[iter_16_1][iter_16_3] then
				var_16_4[iter_16_1][iter_16_3] = {}
			end
			
			local var_16_5 = string.format("%s_%02d", "n_map", iter_16_3)
			local var_16_6 = iter_16_2:getChildByName(var_16_5)
			
			if var_16_6 then
				var_16_6:setVisible(false)
				
				var_16_4[iter_16_1][iter_16_3] = var_16_6
				
				if_set_visible(var_16_6, "touristry_map", false)
				
				local var_16_7 = load_control("wnd/touristry_icon.csb")
				
				var_16_6:addChild(var_16_7)
			end
		end
	end
	
	local var_16_8 = 1
	
	for iter_16_4 = arg_16_0.vars.row_num, arg_16_0.vars.row_num + 4 do
		if arg_16_0.vars.map_icons[iter_16_4] then
			for iter_16_5 = 1, 3 do
				if arg_16_0.vars.map_icons[iter_16_4] and var_16_4[var_16_8] and var_16_4[var_16_8][iter_16_5] then
					arg_16_0.vars.map_icons[iter_16_4][iter_16_5] = var_16_4[var_16_8][iter_16_5]
				end
			end
		end
		
		var_16_8 = var_16_8 + 1
	end
	
	arg_16_0.vars.row_num = arg_16_0.vars.row_num + 4
	
	if_set_visible(var_16_0, "selected", false)
	
	return var_16_0
end

function SubStoryTravelMap.updateMapAll(arg_17_0)
	arg_17_0:updateMapData()
	arg_17_0:updateMapIcon()
	arg_17_0:drawLines()
end

function SubStoryTravelMap.updateMapData(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.map_icons) do
		for iter_18_2, iter_18_3 in pairs(iter_18_1) do
			if arg_18_0.vars.datas[iter_18_0][iter_18_2] then
				local var_18_0 = arg_18_0.vars.datas[iter_18_0][iter_18_2]
				
				iter_18_3.is_hide = true
				
				if_set_visible(iter_18_3, nil, true)
				
				local var_18_1 = iter_18_3:getWorldPosition()
				
				var_18_0.x = var_18_1.x
				var_18_0.y = var_18_1.y
				var_18_0.icon = iter_18_3
				
				local var_18_2 = iter_18_3:getChildByName("btn_touch")
				
				if get_cocos_refid(var_18_2) then
					var_18_2.id = var_18_0.id
				end
			end
		end
	end
end

function SubStoryTravelMap.updateMapIcon(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1 or {}
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.map_icons) do
		for iter_19_2, iter_19_3 in pairs(iter_19_1) do
			local var_19_1 = arg_19_0.vars.datas[iter_19_0][iter_19_2]
			
			if var_19_1 then
				local var_19_2 = var_19_1.is_locked
				local var_19_3 = var_19_1.is_cleared
				local var_19_4 = var_19_1.is_received_reward
				local var_19_5 = iter_19_3:getChildByName("touristry_map")
				
				if_set_sprite(iter_19_3, "img_map_icon", "map/" .. var_19_1.map_icon .. ".png")
				if_set_sprite(iter_19_3, "tag", "map/" .. var_0_1[var_19_1.reward_type] .. ".png")
				if_set_color(var_19_5, "touristry_map", var_19_2 and tocolor("#888888") or tocolor("#ffffff"))
				if_set_visible(iter_19_3, "icon_etclock", var_19_2)
				if_set_visible(iter_19_3, "icon_clear_check", var_19_4)
				
				if arg_19_0.vars.cur_data then
					if_set_visible(iter_19_3, "selected", var_19_1 == arg_19_0.vars.cur_data)
				end
				
				local var_19_6 = var_19_1.can_receive_reward
				
				if not var_19_0.ignore_eff_update then
					if not var_19_2 and var_19_6 and not var_19_4 and not iter_19_3.reward_eff then
						iter_19_3.reward_eff = EffectManager:Play({
							pivot_x = 0,
							fn = "ui_limited_reward.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							scale = 1.5,
							layer = iter_19_3
						})
					elseif not var_19_2 and not var_19_4 and not var_19_6 then
						iter_19_3.reward_eff = EffectManager:Play({
							pivot_x = 0,
							fn = "travel_select_guide.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							layer = iter_19_3
						})
					elseif iter_19_3.reward_eff then
						iter_19_3.reward_eff:removeFromParent()
						
						iter_19_3.reward_eff = nil
					end
				end
			end
		end
	end
end

function SubStoryTravelMap.drawLines(arg_20_0)
	arg_20_0.vars.lines = {}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.map_icons) do
		for iter_20_2, iter_20_3 in pairs(iter_20_1) do
			local var_20_0 = arg_20_0.vars.datas[iter_20_0][iter_20_2]
			
			if var_20_0 and var_20_0.unlock_predecessor then
				local var_20_1 = string.split(var_20_0.unlock_predecessor, ",")
				
				for iter_20_4, iter_20_5 in pairs(var_20_1) do
					local var_20_2 = arg_20_0:findMapDataByID(iter_20_5)
					
					if var_20_2 then
						local var_20_3 = 0
						local var_20_4 = 0
						local var_20_5 = var_20_2.column
						local var_20_6 = var_20_2.row
						local var_20_7 = var_20_0.column
						local var_20_8 = var_20_0.row
						local var_20_9 = {
							x = 0,
							y = 0
						}
						local var_20_10 = {
							x = var_20_0.x - var_20_2.x,
							y = (var_20_0.y - var_20_2.y) * -1
						}
						local var_20_11 = cc.Node:create()
						local var_20_12
						local var_20_13 = 0
						local var_20_14
						
						if var_20_0.is_received_reward then
							var_20_12 = "img/cm_select_lineon.png"
							var_20_14 = 255
						else
							var_20_12 = "img/cm_select_lineoff.png"
							var_20_14 = 191.25
						end
						
						local var_20_15 = 0.8
						
						var_20_11:setPosition(var_20_9.x, var_20_9.y)
						
						local var_20_16 = var_20_11:getContentSize()
						
						var_20_11:setAnchorPoint(0.5, 0.5)
						
						local var_20_17 = math.sqrt(math.pow(var_20_10.x - var_20_9.x, 2) + math.pow(var_20_10.y - var_20_9.y, 2))
						local var_20_18 = WorldMapTown:getDegreesFromTo(var_20_9, var_20_10)
						
						var_20_11:setRotation(var_20_18)
						var_20_2.icon:addChild(var_20_11)
						addLine(var_20_11, var_20_12, var_20_17 * var_20_15, true)
						var_20_11:setCascadeOpacityEnabled(true)
						var_20_11:setOpacity(var_20_14)
						var_20_11:setLocalZOrder(-9999)
						var_20_2.icon:setGlobalZOrder(-9999)
						
						if var_20_0.column < var_20_2.column then
							var_20_0.icon:bringToFront()
						end
						
						local var_20_19 = {
							[var_20_0.id] = {
								var_20_11,
								var_20_18,
								var_20_17,
								var_20_0.id
							}
						}
						
						table.insert(arg_20_0.vars.lines, var_20_19)
					end
				end
			end
		end
	end
end

function SubStoryTravelMap.findMapDataByID(arg_21_0, arg_21_1)
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.datas) do
		for iter_21_2, iter_21_3 in pairs(iter_21_1) do
			if iter_21_3.id == arg_21_1 then
				return iter_21_3
			end
		end
	end
end

function SubStoryTravelMap.moveToPath(arg_22_0)
	if not arg_22_0.vars.cur_data then
		return 
	end
	
	local var_22_0 = SubstoryManager:getInfo()
	
	if not SubstoryManager:isActiveSchedule(var_22_0.id) then
		balloon_message_with_sound("end_sub_story_event")
		
		return 
	end
	
	if arg_22_0.vars.cur_data.unlock_move then
		movetoPath(arg_22_0.vars.cur_data.unlock_move)
	else
		balloon_message_with_sound("substory_travel_reward_yet")
	end
end

function SubStoryTravelMap.req_reward(arg_23_0, arg_23_1)
	if not arg_23_0.vars.substory_id or not arg_23_0.vars.cur_data then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.cur_data
	
	if var_23_0.is_locked or not var_23_0.is_received_prev_reward then
		balloon_message_with_sound("substory_travel_reward_yet")
		
		return 
	elseif var_23_0.is_received_reward then
		balloon_message_with_sound("substory_travel_reward_complete")
		
		return 
	end
	
	if var_23_0.reward_type == "item" then
		if var_23_0.can_receive_reward then
			query("substory_travel_misison_complete", {
				substory_id = arg_23_0.vars.substory_id,
				mission_id = var_23_0.id
			})
		else
			balloon_message_with_sound("substory_travel_reward_yet")
		end
	elseif var_23_0.reward_type == "npc_battle" then
		SubStoryTravelMap:startNPCBattle()
	elseif var_23_0.reward_type == "story" then
		SubStoryTravelMap:play_story()
	end
end

function SubStoryTravelMap.retry_travel(arg_24_0, arg_24_1)
	if not arg_24_0.vars.substory_id or not arg_24_0.vars.cur_data then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.cur_data
	
	if var_24_0.reward_type == "npc_battle" then
		SubStoryTravelMap:startNPCBattle({
			play_again = true
		})
	elseif var_24_0.reward_type == "story" then
		SubStoryTravelMap:play_story({
			play_again = true
		})
	end
end

function SubStoryTravelMap.select_detail(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_1 then
		return 
	end
	
	local var_25_0 = arg_25_2 or {}
	local var_25_1 = false
	
	if arg_25_0.vars.cur_data then
		var_25_1 = arg_25_1 == arg_25_0.vars.cur_data.id
	end
	
	if var_25_0.force_update_eff then
		var_25_1 = false
	end
	
	arg_25_0.vars.cur_data = arg_25_0:findMapDataByID(arg_25_1)
	
	if not arg_25_0.vars.cur_data then
		return 
	end
	
	local var_25_2 = arg_25_0.vars.cur_data.is_cleared
	local var_25_3 = SubStoryTravel:getMissionInfo(arg_25_0.vars.cur_data.id)
	
	arg_25_0:updateMapIcon({
		ignore_eff_update = true
	})
	arg_25_0:update_detail_info({
		ignore_eff_update = var_25_1
	})
end

function SubStoryTravelMap.update_button(arg_26_0)
	if not arg_26_0.vars.cur_data then
		return 
	end
	
	if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
	if_set_visible(arg_26_0.vars.wnd, "btn_green", false)
	if_set_visible(arg_26_0.vars.wnd, "btn_unmove", false)
	
	local var_26_0 = arg_26_0.vars.cur_data
	local var_26_1 = var_26_0.is_locked
	local var_26_2 = var_26_0.can_receive_reward
	local var_26_3 = var_26_0.is_received_reward
	local var_26_4 = var_26_0.is_received_prev_reward
	local var_26_5 = var_26_0.is_cleared
	local var_26_6 = var_26_0.state
	local var_26_7 = var_26_0.reward_type
	local var_26_8 = var_26_0.unlock_move
	local var_26_9
	local var_26_10
	local var_26_11 = 255
	
	if var_26_1 then
		if var_26_6 == SUBSTORY_TRAVEL_STATE.CLEAR then
			var_26_11 = 76.5
			var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_green")
			
			if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_green", true)
			if_set(var_26_9, "text", T("guidequest_reward_get"))
		elseif var_26_8 then
			var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_unmove")
			
			if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_green", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_unmove", true)
			if_set(var_26_9, "text", T("go"))
		else
			var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_green")
			
			if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_green", true)
			if_set_visible(arg_26_0.vars.wnd, "btn_unmove", false)
			if_set(var_26_9, "text", T("guidequest_reward_get"))
			
			var_26_11 = 76.5
		end
	elseif var_26_3 then
		var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_opaque")
		
		if_set_visible(arg_26_0.vars.wnd, "btn_opaque", true)
		if_set_visible(arg_26_0.vars.wnd, "btn_green", false)
		if_set_visible(arg_26_0.vars.wnd, "btn_unmove", false)
		
		if var_26_7 == "item" then
			var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_green")
			
			if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_green", true)
			
			var_26_11 = 76.5
			var_26_10 = T("guidequest_reward_get")
		elseif var_26_7 == "story" then
			var_26_10 = T("ui_customdlc_restory_btn")
		elseif var_26_7 == "npc_battle" then
			var_26_10 = T("battle_start_replay")
		end
		
		if_set(var_26_9, "text", var_26_10)
	elseif var_26_2 then
		if not var_26_4 then
			var_26_11 = 76.5
		end
		
		var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_green")
		
		local var_26_12 = T("guidequest_reward_get")
		
		if_set(var_26_9, "text", var_26_12)
		if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
		if_set_visible(arg_26_0.vars.wnd, "btn_green", true)
		if_set_visible(arg_26_0.vars.wnd, "btn_unmove", false)
	else
		local var_26_13 = true
		
		if var_26_0.unlock_predecessor then
			local var_26_14 = SubStoryTravel:isReceivedReward(var_26_0.unlock_predecessor)
		end
		
		if not var_26_5 then
			var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_unmove")
			
			if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_green", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_unmove", true)
			
			if var_26_8 then
				if_set(var_26_9, "text", T("go"))
			else
				if_set(var_26_9, "text", T("guidequest_reward_get"))
				
				var_26_11 = 76.5
			end
		else
			var_26_9 = arg_26_0.vars.wnd:getChildByName("btn_green")
			
			local var_26_15 = T("guidequest_reward_get")
			
			if_set(var_26_9, "text", var_26_15)
			
			var_26_11 = 76.5
			
			if_set_visible(arg_26_0.vars.wnd, "btn_opaque", false)
			if_set_visible(arg_26_0.vars.wnd, "btn_green", true)
			if_set_visible(arg_26_0.vars.wnd, "btn_unmove", false)
		end
	end
	
	local var_26_16
	
	if var_26_7 == "item" then
		var_26_16 = "cm_icon_etcdown"
	elseif var_26_7 == "story" then
		var_26_16 = "cm_icon_etcstory"
	elseif var_26_7 == "npc_battle" then
		var_26_16 = "cm_icon_etcbp"
	end
	
	if var_26_9 then
		if var_26_16 then
			if_set_sprite(var_26_9, "icon", "img/" .. var_26_16 .. ".png")
		end
		
		if_set_opacity(var_26_9, nil, var_26_11)
	end
	
	if var_26_7 == "story" or var_26_7 == "npc_battle" then
		if_set_visible(arg_26_0.vars.wnd, "n_normal_reward", true)
		
		if var_26_16 then
			local var_26_17 = var_0_2[var_26_7]
			
			if_set_sprite(arg_26_0.vars.wnd, "normal_reward", "img/" .. var_26_17 .. ".png")
		end
	else
		if_set_visible(arg_26_0.vars.wnd, "n_normal_reward", false)
	end
	
	local var_26_18 = SubstoryManager:getInfo()
	
	if not SubstoryManager:isActiveSchedule(var_26_18.id) then
		if_set_opacity(arg_26_0.vars.wnd, "btn_unmove", 76.5)
	end
end

function SubStoryTravelMap.update_detail_info(arg_27_0, arg_27_1)
	if not arg_27_0.vars.cur_data then
		return 
	end
	
	local var_27_0 = arg_27_1 or {}
	
	if_set_visible(arg_27_0.vars.wnd, "btn_opaque", false)
	if_set_visible(arg_27_0.vars.wnd, "btn_green", false)
	if_set_visible(arg_27_0.vars.wnd, "btn_unmove", false)
	
	local var_27_1 = arg_27_0.vars.wnd:getChildByName("RIGHT")
	local var_27_2 = arg_27_0.vars.cur_data
	local var_27_3 = var_27_2.reward_type
	local var_27_4 = var_27_2.is_cleared
	local var_27_5 = var_27_2.state
	local var_27_6 = var_27_2.unlock_move
	local var_27_7 = var_27_2.is_locked
	local var_27_8 = var_27_2.can_receive_reward
	local var_27_9 = var_27_2.is_received_reward
	
	arg_27_0:update_button()
	if_set(var_27_1, "txt_story", T(var_27_2.unlock_desc))
	
	local var_27_10 = var_27_3 and var_27_3 == "item"
	local var_27_11 = var_27_1:getChildByName("n_reword_contents")
	
	if var_27_10 and var_27_2.reward_value then
		local var_27_12 = var_27_2.reward_value
		local var_27_13 = var_27_2.reward_count
		local var_27_14 = getChildByPath(var_27_11, "reward_icon")
		
		if var_27_14 then
			var_27_14:setVisible(true)
			UIUtil:getRewardIcon(var_27_13, var_27_12, {
				no_detail_popup = true,
				parent = var_27_14
			})
		end
	else
		if_set_visible(var_27_1, "reward_icon", false)
		if_set_visible(var_27_1, "item_icon", false)
		if_set_visible(var_27_1, "item_art_icon", false)
		if_set_visible(var_27_1, "mob_icon", false)
	end
	
	local var_27_15 = var_27_1:getChildByName("touristry_map")
	
	if not arg_27_0.vars.detail_map_icon then
		var_27_15:removeAllChildren()
		
		arg_27_0.vars.detail_map_icon = load_control("wnd/touristry_icon.csb")
		
		var_27_15:addChild(arg_27_0.vars.detail_map_icon)
	end
	
	if_set_sprite(var_27_15, "img_map_icon", "map/" .. var_27_2.map_icon .. ".png")
	if_set_sprite(var_27_15, "tag", "map/" .. var_0_1[var_27_2.reward_type] .. ".png")
	if_set_color(arg_27_0.vars.detail_map_icon:getChildByName("touristry_map"), "touristry_map", not (not var_27_7 and not var_27_9) and tocolor("#888888") or tocolor("#ffffff"))
	if_set_visible(var_27_15, "icon_etclock", var_27_7)
	
	local var_27_16 = getChildByPath(var_27_1, "icon_clear_check")
	
	if_set_visible(var_27_16, nil, var_27_9)
	
	if not var_27_0.ignore_eff_update then
		if get_cocos_refid(var_27_15.eff) then
			var_27_15.eff:removeFromParent()
			
			var_27_15.eff = nil
		end
		
		if not var_27_7 and var_27_8 and not var_27_9 then
			var_27_15.eff = EffectManager:Play({
				pivot_x = 0,
				fn = "ui_limited_reward.cfx",
				pivot_y = 0,
				pivot_z = 99998,
				scale = 1.5,
				layer = var_27_15
			})
		elseif not var_27_7 and not var_27_9 and not var_27_8 then
			var_27_15.eff = EffectManager:Play({
				pivot_x = 0,
				fn = "travel_select_guide.cfx",
				pivot_y = 0,
				pivot_z = 99998,
				layer = var_27_15
			})
		end
	end
	
	if_set_visible(arg_27_0.vars.wnd, "n_get_reward", var_27_9)
	arg_27_0:update_progress()
end

function SubStoryTravelMap.update_progress(arg_28_0)
	if not arg_28_0.vars.cur_data then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_reword_contents")
	
	if get_cocos_refid(var_28_0) then
		local var_28_1 = var_28_0:getChildByName("progress_bg")
		local var_28_2 = arg_28_0.vars.cur_data.value
		
		if var_28_2 then
			if_set_visible(var_28_0, "progress_bg", true)
			
			local var_28_3 = tonumber(var_28_2.count) or 0
			local var_28_4 = SubStoryTravel:getMissionInfo(arg_28_0.vars.cur_data.id) or {}
			local var_28_5 = tonumber(var_28_4.score1) or 0
			
			if_set_percent(var_28_1, "progress_bar", var_28_5 / var_28_3)
			if_set(var_28_0, "t_percent", var_28_5 .. "/" .. var_28_3)
			
			if var_28_3 <= var_28_5 then
				if_set_color(var_28_1, "progress_bar", cc.c3b(107, 193, 27))
			else
				if_set_color(var_28_1, "progress_bar", cc.c3b(146, 109, 62))
			end
		else
			if_set_visible(var_28_0, "progress_bg", false)
		end
	end
end

function SubStoryTravelMap.res_rewardItem(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.info
	
	if var_29_0 and var_29_0.contents_id then
		Account:updateSubStoryTravelMission(var_29_0.contents_id, arg_29_1.info)
	end
	
	if arg_29_0.vars and get_cocos_refid(arg_29_0.vars.wnd) then
		arg_29_0:updateData()
		arg_29_0:createScrollViewItemsKeepPosition(arg_29_0.vars.scrollview_empty_items)
		arg_29_0:updateMapAll()
		arg_29_0:select_detail(var_29_0.contents_id, {
			force_update_eff = true
		})
	end
end

function SubStoryTravelMap.leave_detail(arg_30_0)
	arg_30_0.vars.cur_data = nil
end

function SubStoryTravelMap.startNPCBattle(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) or not arg_31_0.vars.cur_data then
		return 
	end
	
	local var_31_0 = (arg_31_1 or {}).play_again or false
	local var_31_1 = arg_31_0.vars.cur_data
	local var_31_2, var_31_3 = DB("level_enter", var_31_1.reward_value, {
		"id",
		"contents_type"
	})
	local var_31_4 = SubstoryManager:getInfo()
	
	if not var_31_2 or not var_31_3 or not var_31_4 or table.empty(var_31_4) then
		return 
	end
	
	if var_31_3 == "substory" then
		BattleReady:show({
			enter_id = var_31_2,
			callback = arg_31_0,
			play_again = var_31_0
		})
	end
end

function SubStoryTravelMap.onStartBattle(arg_32_0, arg_32_1)
	if not arg_32_0.vars or not arg_32_0.vars.cur_data then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.cur_data
	
	if not arg_32_1.npcteam_id then
		return 
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_32_1.enter_id)
	startBattle(arg_32_1.enter_id, arg_32_1)
	BattleReady:hide()
	SubstoryManager:add_after_enter_call("open_travel_map", function()
		SubStoryTravelMap:show()
	end)
	
	if not arg_32_1.play_again then
		query("substory_travel_misison_complete", {
			substory_id = arg_32_0.vars.substory_id,
			mission_id = var_32_0.id
		})
	end
end

function SubStoryTravelMap.setVisible(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.wnd) then
		return 
	end
	
	arg_34_0.vars.wnd:setVisible(arg_34_1)
end

function SubStoryTravelMap.play_story(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not arg_35_0.vars.cur_data then
		return 
	end
	
	local var_35_0 = arg_35_1 or {}
	local var_35_1 = arg_35_0.vars.cur_data
	local var_35_2 = var_35_0.play_again
	
	if var_35_1.reward_type ~= "story" then
		return 
	end
	
	play_story(var_35_1.reward_value, {
		force = true,
		on_finish = function()
			if not var_35_2 then
				query("substory_travel_misison_complete", {
					substory_id = arg_35_0.vars.substory_id,
					mission_id = var_35_1.id
				})
			end
		end
	})
end

function SubStoryTravelMap.leave(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("story_dlc_chronicle")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE(), CALL(function()
		arg_37_0.vars = nil
	end)), arg_37_0.vars.wnd, "block")
	SubStoryLobby:updateUI()
end
