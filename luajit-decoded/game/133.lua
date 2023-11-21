SubStoryBurningDungeon = SubStoryBurningDungeon or {}

function HANDLER.dungeon_story_paradise(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = getParentWindow(arg_1_0).class
	
	if var_1_0 and var_1_0.onHandler then
		var_1_0:onHandler(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	end
end

function HANDLER_BEFORE.dungeon_story_paradise(arg_2_0, arg_2_1)
	local var_2_0 = getParentWindow(arg_2_0).class
	
	if var_2_0 and var_2_0.onHandlerBefore then
		var_2_0:onHandlerBefore(arg_2_0, arg_2_1)
	end
end

function HANDLER_CANCEL.dungeon_story_paradise(arg_3_0, arg_3_1)
	local var_3_0 = getParentWindow(arg_3_0).class
	
	if var_3_0 and var_3_0.onHandlerCancel then
		var_3_0:onHandlerCancel(arg_3_0, arg_3_1)
	end
end

local function var_0_0(arg_4_0, arg_4_1)
	local var_4_0 = getParentWindow(arg_4_0).class
	
	if var_4_0 and var_4_0.onScroll then
		var_4_0.onScroll(var_4_0)
	end
end

function SubStoryBurningDungeon.show(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if not get_cocos_refid(arg_5_1) then
		Log.e("SubStoryBurningDungeon", "parent is invalid")
		
		return 
	end
	
	if string.empty(arg_5_2) then
		Log.e("SubStoryBurningDungeon", "substory_id is empty")
		
		return 
	end
	
	if string.empty(arg_5_3) then
		Log.e("SubStoryBurningDungeon", "burning_battle_id is empty")
		
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.substory_id = arg_5_2
	arg_5_0.vars.burning_battle_id = arg_5_3
	arg_5_0.vars.substory_main_db = DBT("substory_main", arg_5_0.vars.substory_id, {
		"token_id1",
		"token_id2",
		"token_id3",
		"banner_icon"
	})
	arg_5_0.vars.burning_battle_db = SLOW_DB_ALL("substory_burning_battle", arg_5_0.vars.burning_battle_id)
	arg_5_0.vars.wnd = load_dlg("dungeon_story_paradise", true, "wnd")
	arg_5_0.vars.wnd.class = arg_5_0
	
	arg_5_1:addChild(arg_5_0.vars.wnd)
	
	local var_5_0 = SubStoryUtil:getTopbarCurrencies(arg_5_0.vars.substory_main_db, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:createFromPopup(T("burn_battle_title"), arg_5_0.vars.wnd, function()
		SubStoryBurningDungeon:hide()
	end, var_5_0, "infosubs_1")
	arg_5_0:_initData()
	arg_5_0:_initUI()
	TutorialGuide:procGuide()
end

function SubStoryBurningDungeon.hide(arg_7_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE(), CALL(function()
		arg_7_0.vars = nil
	end)), arg_7_0.vars.wnd, "block")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("burn_battle_title"))
end

function SubStoryBurningDungeon._initData(arg_9_0)
	arg_9_0.vars.floor_info_node = arg_9_0.vars.wnd:getChildByName("floor_info")
	
	if not get_cocos_refid(arg_9_0.vars.floor_info_node) then
		Log.e("SubStoryBurningDungeon", "floor_info_node is invalid")
		
		return 
	end
	
	arg_9_0.vars.floors = arg_9_0:getFloorList(arg_9_0.vars.burning_battle_db.enter_key)
	arg_9_0.vars.part_offset = 103
	arg_9_0.vars.part_count = #arg_9_0.vars.floors
	arg_9_0.vars.view_height = arg_9_0.vars.part_offset * (arg_9_0.vars.part_count + 1)
	
	local var_9_0 = arg_9_0.vars.burning_battle_db.reward_set
	
	arg_9_0.vars.reward_set_list = string.split(var_9_0 or "", ",")
	
	local var_9_1 = arg_9_0.vars.wnd:getChildByName("n_floors")
	
	if not get_cocos_refid(var_9_1) then
		Log.e("SubStoryBurningDungeon", "n_floors not found")
		
		return 
	end
	
	arg_9_0.vars.scrollview = var_9_1:getChildByName("scrollview")
	
	if not get_cocos_refid(arg_9_0.vars.scrollview) then
		Log.e("SubStoryBurningDungeon", "self.vars.scrollview not found")
		
		return 
	end
	
	local var_9_2 = arg_9_0.vars.wnd:getChildByName("reward1")
	
	if not get_cocos_refid(var_9_2) then
		Log.e("SubStoryBurningDungeon", "reward1 not found")
		
		return 
	end
	
	arg_9_0.vars.reward_scrollview = var_9_2:getChildByName("scroll_view")
	
	if not get_cocos_refid(arg_9_0.vars.reward_scrollview) then
		Log.e("SubStoryBurningDungeon", "self.vars.reward_scrollview not found")
		
		return 
	end
	
	arg_9_0.vars.left = arg_9_0.vars.wnd:getChildByName("LEFT")
	
	if not get_cocos_refid(arg_9_0.vars.left) then
		Log.e("SubStoryBurningDungeon", "self.vars.left not found")
		
		return 
	end
	
	if get_cocos_refid(arg_9_0.vars.listener) then
		arg_9_0:removeScrollEventListener(arg_9_0.vars.scrollview)
	end
	
	local var_9_3 = arg_9_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_9_3) then
		arg_9_0.vars.listener = cc.EventListenerTouchOneByOne:create()
		
		arg_9_0.vars.listener:registerScriptHandler(function(arg_10_0, arg_10_1)
			return arg_9_0:onTouchDown(arg_10_0, arg_10_1)
		end, cc.Handler.EVENT_TOUCH_BEGAN)
		arg_9_0.vars.listener:registerScriptHandler(function(arg_11_0, arg_11_1)
			return arg_9_0:onTouchUp(arg_11_0, arg_11_1)
		end, cc.Handler.EVENT_TOUCH_ENDED)
		arg_9_0.vars.listener:registerScriptHandler(function(arg_12_0, arg_12_1)
			return arg_9_0:onTouchMove(arg_12_0, arg_12_1)
		end, cc.Handler.EVENT_TOUCH_MOVED)
		
		local var_9_4 = cc.Node:create()
		
		var_9_4:setName("priority_node")
		arg_9_0.vars.scrollview:addChild(var_9_4)
		var_9_3:addEventListenerWithSceneGraphPriority(arg_9_0.vars.listener, var_9_4)
	end
end

function SubStoryBurningDungeon._initUI(arg_13_0)
	if not get_cocos_refid(arg_13_0.vars.wnd) then
		Log.e("SubStoryBurningDungeon", "wnd is invalid")
		
		return 
	end
	
	arg_13_0:initBackGround()
	arg_13_0:initText()
	arg_13_0:initScrollView()
	arg_13_0:updateFloorInfo()
	
	local var_13_0 = arg_13_0.vars.start_floor
	
	if var_13_0 > 4 then
		var_13_0 = 4
	end
	
	arg_13_0:moveToFloor(var_13_0, true, 0.7)
	arg_13_0:setBI()
	arg_13_0:setPortrait()
	arg_13_0:setEnchantedHero()
	arg_13_0:setMainReward()
	arg_13_0:setObtainableSet()
end

function SubStoryBurningDungeon.initText(arg_14_0)
	if_set(arg_14_0.vars.wnd, "txt_title_2", T("burn_battle_title"))
	if_set(arg_14_0.vars.wnd, "txt_go", T("abyss_replay_btn_2"))
end

function SubStoryBurningDungeon.initBackGround(arg_15_0)
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_bg")
	
	if not get_cocos_refid(var_15_0) then
		Log.e("SubStoryBurningDungeon", "n_bg not found")
		
		return 
	end
	
	if get_cocos_refid(arg_15_0.vars.bg) then
		arg_15_0.vars.bg:removeFromParent()
		
		arg_15_0.vars.bg = nil
	end
	
	if not string.empty(arg_15_0.vars.burning_battle_db.battle_bg) then
		local var_15_1, var_15_2 = FIELD_NEW:create(arg_15_0.vars.burning_battle_db.battle_bg, DESIGN_WIDTH * 2)
		
		var_15_1:setAnchorPoint(0.5, 0.5)
		var_15_1:setPosition(0, -(DESIGN_HEIGHT * 0.5))
		var_15_1:setScale(1)
		var_15_2:setViewPortPosition(VIEW_WIDTH / 2)
		var_15_2:updateViewport()
		var_15_0:addChild(var_15_1)
		
		arg_15_0.vars.bg = var_15_0
	end
end

function SubStoryBurningDungeon.initScrollView(arg_16_0)
	arg_16_0.vars.scrollview:setInnerContainerSize({
		width = arg_16_0.vars.scrollview:getContentSize().width,
		height = arg_16_0.vars.view_height + arg_16_0.vars.part_offset * 4
	})
	arg_16_0.vars.scrollview:setScrollStep(arg_16_0.vars.view_height / arg_16_0.vars.part_offset)
	arg_16_0.vars.scrollview:addEventListener(var_0_0)
	arg_16_0.vars.scrollview:setScrollSpeed(7)
	
	if arg_16_0.vars.scrollview.setMovementFactor then
		arg_16_0.vars.scrollview:setMovementFactor(0.1)
	end
end

function SubStoryBurningDungeon.onScroll(arg_17_0)
	arg_17_0:updateFloorInfo()
end

function SubStoryBurningDungeon.getFloorList(arg_18_0, arg_18_1)
	local var_18_0 = {}
	
	for iter_18_0 = 1, 99 do
		local var_18_1 = {}
		
		var_18_1.enter_id, var_18_1.name, var_18_1.type, var_18_1.show_reward_id = DB("level_enter", arg_18_1 .. string.format("%03d", iter_18_0), {
			"id",
			"name",
			"type",
			"show_reward_id"
		})
		
		if not var_18_1.enter_id then
			break
		end
		
		var_18_1.isLock = not Account:checkEnterMap(var_18_1.enter_id)
		var_18_1.isClear = Account:isMapCleared(var_18_1.enter_id)
		
		if not var_18_1.isLock then
			arg_18_0.vars.start_floor = iter_18_0
		end
		
		table.push(var_18_0, var_18_1)
	end
	
	return var_18_0
end

function SubStoryBurningDungeon.updateFloorInfo(arg_19_0)
	if not arg_19_0.vars or not arg_19_0.vars.scrollview or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.scrollview:getInnerContainerPosition().y
	
	if arg_19_0.vars.scroll_pos == var_19_0 then
		return 
	end
	
	arg_19_0.vars.scroll_pos = var_19_0
	arg_19_0.vars.f_floor = arg_19_0.vars.part_count - ((0 - var_19_0) / (arg_19_0.vars.view_height / (arg_19_0.vars.part_count + 1)) + 1) + 0.5
	arg_19_0.vars.f_floor = math.max(1, math.min(arg_19_0.vars.f_floor, arg_19_0.vars.part_count))
	arg_19_0.vars.i_floor = math.floor(arg_19_0.vars.f_floor + 0.5)
	
	arg_19_0.vars.floor_info_node:setPositionY((arg_19_0.vars.f_floor - arg_19_0.vars.i_floor) * arg_19_0.vars.part_offset)
	
	for iter_19_0 = -3, 3 do
		local var_19_1 = iter_19_0 + arg_19_0.vars.i_floor
		local var_19_2 = arg_19_0.vars.floor_info_node:getChildByName("F" .. iter_19_0)
		
		if var_19_1 < 1 or var_19_1 > arg_19_0.vars.part_count then
			var_19_2:setVisible(false)
			
			var_19_2.guide_tag = nil
		else
			var_19_2:setVisible(true)
			
			local var_19_3 = arg_19_0.vars.floors[var_19_1]
			
			var_19_2.guide_tag = var_19_3.enter_id
			
			if var_19_2.info ~= var_19_3 then
				var_19_2.info = var_19_3
				
				if_set(var_19_2, "floor", T(var_19_3.name))
				if_set_visible(var_19_2, "n_completed", var_19_3.isClear or var_19_1 < arg_19_0.vars.start_floor)
				if_set_visible(var_19_2, "n_locked", var_19_3.isLock)
				if_set_visible(var_19_2, "progressable", false)
				
				local var_19_4 = tostring(arg_19_0.vars.i_floor)
				local var_19_5 = arg_19_0.vars.burning_battle_db.enter_key
				local var_19_6 = ""
				
				for iter_19_1 = -2 + #var_19_4, 0 do
					var_19_6 = var_19_6 .. "0"
				end
				
				local var_19_7 = var_19_5 .. var_19_6 .. var_19_4
				local var_19_8 = var_19_2:getChildByName("floor")
				
				if not get_cocos_refid(var_19_8) then
					Log.e("SubStoryBurningDungeon", "c_floor not found")
					
					return 
				end
				
				local var_19_9 = var_19_2:getChildByName("progressable")
				
				if not get_cocos_refid(var_19_9) then
					Log.e("SubStoryBurningDungeon", "c_desc not found")
					
					return 
				end
				
				if var_19_3.isLock then
					var_19_8:setTextColor(cc.c3b(180, 180, 180))
				elseif var_19_3.isClear or var_19_1 < arg_19_0.vars.start_floor then
					var_19_8:setTextColor(cc.c3b(255, 255, 255))
				else
					var_19_8:setTextColor(cc.c3b(255, 255, 255))
					var_19_9:setVisible(true)
					var_19_9:setTextColor(cc.c3b(171, 135, 89))
					var_19_9:setOpacity(100)
					var_19_9:setString(T("can_enter"))
				end
			end
		end
	end
	
	if arg_19_0.vars.i_floor ~= arg_19_0.vars.prev_i_floor then
		arg_19_0.vars.prev_i_floor = arg_19_0.vars.i_floor
		
		arg_19_0:onChangeFloor(arg_19_0.vars.i_floor)
	end
end

function SubStoryBurningDungeon.moveToFloor(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_3 = arg_20_3 or 2
	arg_20_1 = math.max(0, math.min(arg_20_0.vars.part_count, arg_20_1))
	
	local var_20_0 = (arg_20_1 - 1) * (100 / (arg_20_0.vars.part_count - 1))
	
	if arg_20_2 then
		if var_20_0 == 100 then
			var_20_0 = 101
		end
		
		arg_20_0.vars.scrollview:scrollToPercentVertical(var_20_0, arg_20_3, true)
	else
		arg_20_0.vars.scrollview:jumpToPercentVertical(var_20_0)
	end
end

function SubStoryBurningDungeon.removeScrollEventListener(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_21_0.vars.listener) or not get_cocos_refid(arg_21_0.vars.scrollview) then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_21_0) then
		var_21_0:removeEventListener(arg_21_0.vars.listener)
	end
	
	arg_21_0.vars.listener:setEnabled(false)
	
	arg_21_0.vars.listener = nil
end

function SubStoryBurningDungeon.onChangeFloor(arg_22_0, arg_22_1)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.floors[arg_22_1]
	
	if_set(arg_22_0.vars.wnd, "txt_floor", T(var_22_0.name))
	
	local var_22_1 = arg_22_0.vars.burning_battle_db.battle_character
	local var_22_2 = DBT("character", var_22_1, {
		"face_id",
		"ch_attribute"
	})
	
	if_set_sprite(arg_22_0.vars.wnd, "face", "face/" .. var_22_2.face_id .. "_s.png")
	if_set_sprite(arg_22_0.vars.wnd, "cm_icon_element", "img/cm_icon_pro" .. var_22_2.ch_attribute .. ".png")
	arg_22_0.vars.reward_scrollview:removeAllChildren()
	
	local var_22_3 = var_22_0.show_reward_id
	local var_22_4 = string.split(var_22_3 or "", ";")
	local var_22_5 = 53
	local var_22_6 = 250
	local var_22_7 = 86
	local var_22_8 = 300
	
	if #var_22_4 > 3 then
		local var_22_9 = #var_22_4 - 3
		
		var_22_8 = var_22_8 + var_22_9 * var_22_7
		var_22_6 = var_22_6 + var_22_9 * var_22_7
	end
	
	for iter_22_0 = 1, #var_22_4 do
		local var_22_10 = var_22_4[iter_22_0]
		
		if var_22_10 then
			local var_22_11 = UIUtil:getRewardIcon(nil, var_22_10, {
				show_name = true,
				parent = arg_22_0.vars.reward_scrollview
			})
			
			var_22_11:setScale(0.8)
			var_22_11:setPosition(var_22_5, var_22_6)
			var_22_11:setName("reward_item" .. iter_22_0)
			
			var_22_6 = var_22_6 - var_22_7
		end
	end
	
	arg_22_0.vars.reward_scrollview:setInnerContainerSize({
		width = 289,
		height = var_22_8
	})
	arg_22_0.vars.reward_scrollview:jumpToTop()
	
	local var_22_12 = not arg_22_0.vars.floors[arg_22_0.vars.i_floor].isLock
	
	UIUtil:changeButtonState(arg_22_0.vars.wnd:getChildByName("btn_go"), var_22_12, true)
end

function SubStoryBurningDungeon.refreshButtonEnterInfo(arg_23_0)
	if not arg_23_0.vars.floors then
		return 
	end
	
	if not arg_23_0.vars.i_floor then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.floors[arg_23_0.vars.i_floor]
	
	if not var_23_0 then
		return 
	end
	
	if not arg_23_0.vars.wnd or not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	local var_23_1 = arg_23_0.vars.wnd:getChildByName("btn_go")
	
	if get_cocos_refid(var_23_1) then
		var_23_1.guide_tag = var_23_0.enter_id
		
		UIUtil:setButtonEnterInfo(var_23_1, var_23_0.enter_id)
	end
end

function SubStoryBurningDungeon.onTouchDown(arg_24_0, arg_24_1, arg_24_2)
	if UIAction:Find("block") then
		return false
	end
	
	arg_24_0.vars.touchdown_dirty = arg_24_1:getLocation()
	
	return true
end

function SubStoryBurningDungeon.onTouchMove(arg_25_0, arg_25_1, arg_25_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_25_0.vars.touchdown_dirty then
		return 
	end
	
	if math.abs(arg_25_0.vars.touchdown_dirty.x - arg_25_1:getLocation().x) > DESIGN_HEIGHT * 0.03 or math.abs(arg_25_0.vars.touchdown_dirty.y - arg_25_1:getLocation().y) > DESIGN_HEIGHT * 0.03 then
		arg_25_0.vars.touchdown_dirty = nil
	end
	
	return true
end

function SubStoryBurningDungeon.onTouchUp(arg_26_0, arg_26_1, arg_26_2)
	if UIAction:Find("block") then
		return false
	end
	
	if SubStoryBurningDungeon:isOverlapped() then
		return 
	end
	
	local var_26_0
	
	if arg_26_0.vars.touchdown_dirty and get_cocos_refid(arg_26_0.vars.floor_info_node) then
		var_26_0 = arg_26_1:getLocation()
		
		for iter_26_0 = -3, 3 do
			local var_26_1 = iter_26_0 + arg_26_0.vars.i_floor
			local var_26_2 = arg_26_0.vars.floor_info_node:getChildByName("F" .. iter_26_0)
			
			if var_26_1 < 1 or var_26_1 > arg_26_0.vars.part_count then
			else
				local var_26_3 = var_26_2:getChildByName("panel")
				
				if checkCollision(var_26_3, var_26_0.x, var_26_0.y) then
					arg_26_0:moveToFloor(var_26_1)
					arg_26_2:stopPropagation()
				end
			end
		end
	end
	
	return true
end

function SubStoryBurningDungeon.setBI(arg_27_0)
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_bi")
	
	if not get_cocos_refid(var_27_0) then
		Log.e("SubStoryBurningDungeon", "n_bi not found")
		
		return 
	end
	
	if not string.empty(arg_27_0.vars.substory_main_db.banner_icon) then
		if_set_sprite(var_27_0, "Sprite_322", "banner/" .. arg_27_0.vars.substory_main_db.banner_icon .. ".png")
	end
end

function SubStoryBurningDungeon.setPortrait(arg_28_0)
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_portrait")
	
	if not get_cocos_refid(var_28_0) then
		Log.e("SubStoryBurningDungeon", "n_portrait not found")
		
		return 
	end
	
	local var_28_1 = UIUtil:getPortraitAni(arg_28_0.vars.burning_battle_db.battle_character)
	
	if get_cocos_refid(var_28_1) then
		var_28_1:setScale(0.8)
		var_28_1:setOpacity(0)
		var_28_0:addChild(var_28_1)
	end
end

function SubStoryBurningDungeon.setEnchantedHero(arg_29_0)
	local var_29_0 = arg_29_0.vars.left:getChildByName("mob_icon")
	
	if not get_cocos_refid(var_29_0) then
		Log.e("SubStoryBurningDungeon", "mob_icon not found")
		
		return 
	end
	
	var_29_0:removeAllChildren()
	UIUtil:getRewardIcon(nil, arg_29_0.vars.burning_battle_db.hero_character, {
		scale = 1,
		parent = var_29_0
	})
end

function SubStoryBurningDungeon.setMainReward(arg_30_0)
	local var_30_0 = arg_30_0.vars.burning_battle_db.reward_item
	local var_30_1 = string.split(var_30_0 or "", ",")
	
	for iter_30_0 = 1, 2 do
		local var_30_2 = arg_30_0.vars.left:getChildByName("reward_item_" .. iter_30_0)
		
		if not get_cocos_refid(var_30_2) then
			Log.e("SubStoryBurningDungeon", "rewardNode not found")
			
			return 
		end
		
		var_30_2:removeAllChildren()
		
		if not var_30_1[iter_30_0] then
			return 
		end
		
		UIUtil:getRewardIcon(nil, var_30_1[iter_30_0], {
			scale = 1,
			parent = var_30_2
		})
	end
end

function SubStoryBurningDungeon.setObtainableSet(arg_31_0)
	local var_31_0 = arg_31_0.vars.left:getChildByName("n_set_icons")
	
	if not get_cocos_refid(var_31_0) then
		Log.e("SubStoryBurningDungeon", "n_set_icons not found")
		
		return 
	end
	
	for iter_31_0 = 1, 4 do
		local var_31_1 = var_31_0:getChildByName("set_icon" .. iter_31_0)
		
		if not get_cocos_refid(var_31_1) then
			Log.e("SubStoryBurningDungeon", "set_icon not found")
			
			return 
		end
		
		if iter_31_0 > #arg_31_0.vars.reward_set_list then
			var_31_1:setVisible(false)
		else
			local var_31_2 = EQUIP:getSetItemIconPath(arg_31_0.vars.reward_set_list[iter_31_0])
			
			if_set_sprite(var_31_1, nil, var_31_2)
		end
	end
	
	local var_31_3 = 183 + (4 - #arg_31_0.vars.reward_set_list) * 19.5
	
	var_31_0:setPositionX(var_31_3)
end

function SubStoryBurningDungeon.showSetTooltip(arg_32_0, arg_32_1)
	UIUtil:showObtainableSetTooltip(arg_32_0.vars.left, arg_32_0.vars.reward_set_list, arg_32_1)
	
	if arg_32_1 then
		local var_32_0 = arg_32_0.vars.left:getChildByName("n_set_tooltip")
		
		var_32_0:setPositionY(0)
		
		local var_32_1 = var_32_0:getChildByName("set_bg")
		local var_32_2 = var_32_1:getPositionY() - var_32_1:getContentSize().height
		local var_32_3 = 0 - var_32_2
		
		var_32_0:setPositionY(var_32_3)
	end
end

function SubStoryBurningDungeon.onHandler(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	if arg_33_2 == "btn_obtainable" then
		SubStoryBurningDungeon:showSetTooltip(false)
	end
	
	if arg_33_2 == "btn_go" then
		UIUtil:checkBtnTouchPos(arg_33_1, arg_33_4, arg_33_5)
		arg_33_0:ready()
	end
end

function SubStoryBurningDungeon.onHandlerBefore(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_2 == "btn_obtainable" then
		SubStoryBurningDungeon:showSetTooltip(true)
	end
end

function SubStoryBurningDungeon.onHandlerCancel(arg_35_0, arg_35_1, arg_35_2)
	if arg_35_2 == "btn_obtainable" then
		SubStoryBurningDungeon:showSetTooltip(false)
	end
end

function SubStoryBurningDungeon.ready(arg_36_0, arg_36_1)
	if not DEBUG.DEBUG_NO_ENTER_LIMIT and arg_36_0.vars.floors[arg_36_0.vars.i_floor].isLock then
		balloon_message_with_sound("err_prev_map")
		
		return 
	end
	
	arg_36_1 = arg_36_1 or {
		enter_id = arg_36_0.vars.floors[arg_36_0.vars.i_floor].enter_id,
		burning_battle_id = arg_36_0.vars.burning_battle_id,
		onEnter = function()
			arg_36_0:setEnterDungeonBattle(true)
		end
	}
	arg_36_0.vars.enter_id = arg_36_1.enter_id
	
	BurningReady:show(arg_36_1)
end

function SubStoryBurningDungeon.getBattleID(arg_38_0)
	if not arg_38_0.vars then
		return 
	end
	
	return arg_38_0.vars.burning_battle_id
end

function SubStoryBurningDungeon.isOverlapped(arg_39_0)
	if TouchBlocker:isBlockingScene(SceneManager:getCurrentSceneName()) then
		return true
	end
	
	return BattleReady:isShow() or Postbox:isShow() or Inventory:isShow() or HelpGuide:isShow() or UnitEquip:isVisible() or TopBarNew:isQuickMenuOpenned() or ChatMain:isVisible() or Dialog:getMsgBoxHandlerCount() > 0 or CollectionController:isShow() or MazeRaidRewards:isShow() or UIOption:isShow() or BackPlayControlBox:getWnd()
end

function SubStoryBurningDungeon.getEnterDungeonBattle(arg_40_0)
	return arg_40_0.enter_battle, arg_40_0.substory_id, arg_40_0.burning_battle_id
end

function SubStoryBurningDungeon.isValid(arg_41_0)
	return arg_41_0.vars and get_cocos_refid(arg_41_0.vars.wnd)
end

function SubStoryBurningDungeon.setEnterDungeonBattle(arg_42_0, arg_42_1)
	if not arg_42_0.vars then
		return 
	end
	
	arg_42_0.enter_battle = arg_42_1
	arg_42_0.substory_id = arg_42_0.vars.substory_id
	arg_42_0.burning_battle_id = arg_42_0.vars.burning_battle_id
	
	if arg_42_1 == false then
		arg_42_0.enter_battle = nil
		arg_42_0.substory_id = nil
		arg_42_0.burning_battle_id = nil
	end
end
