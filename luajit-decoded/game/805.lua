UnitDetailStory = {}

function UnitDetailStory.onCreate(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	
	if not get_cocos_refid(arg_1_1.detail_wnd) then
		return 
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.menu_wnd = arg_1_1.detail_wnd:getChildByName("n_menu_story")
	
	arg_1_0:initDB()
	arg_1_0:initUI()
end

function UnitDetailStory.initDB(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.menu_wnd) then
		return 
	end
	
	Account:showServerResUI("unitinfo_substory")
end

function UnitDetailStory.initUI(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.menu_wnd) then
		return 
	end
	
	arg_3_0.vars.left = arg_3_0.vars.menu_wnd:getChildByName("left_story")
	arg_3_0.vars.right = arg_3_0.vars.menu_wnd:getChildByName("right_story")
	arg_3_0.vars.scrollview = arg_3_0.vars.right:getChildByName("ScrollView_story")
end

function UnitDetailStory.getMenu(arg_4_0)
	if not arg_4_0.vars then
		return nil
	end
	
	return arg_4_0.vars.menu_wnd
end

function UnitDetailStory.isVisible(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.menu_wnd) then
		return false
	end
	
	return arg_5_0.vars.menu_wnd:isVisible()
end

function UnitDetailStory.onRelease(arg_6_0)
end

function UnitDetailStory.onEnter(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_7_0.vars.left) or not get_cocos_refid(arg_7_0.vars.right) then
		return 
	end
	
	arg_7_0:enterUI()
end

function UnitDetailStory.onLeave(arg_8_0)
	if not arg_8_0:isVisible() then
		return 
	end
	
	if not get_cocos_refid(arg_8_0.vars.left) or not get_cocos_refid(arg_8_0.vars.right) then
		return 
	end
	
	arg_8_0:leaveUI()
end

function UnitDetailStory.enterUI(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_9_0.vars.left) or not get_cocos_refid(arg_9_0.vars.right) then
		return 
	end
	
	arg_9_0.vars.menu_wnd:setVisible(true)
	arg_9_0.vars.menu_wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_9_0.vars.menu_wnd, "block")
	
	local var_9_0 = arg_9_0.vars.menu_wnd:getChildByName("n_gener")
	
	if get_cocos_refid(var_9_0) then
		var_9_0:setOpacity(255)
	end
	
	local var_9_1 = arg_9_0.vars.left
	
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_9_1:getChildByName("name"), "block")
	
	local var_9_2 = arg_9_0.vars.right
	
	UIAction:Add(SEQ(SLIDE_IN(200, -100)), var_9_2, "block")
	
	local var_9_3 = UnitDetail:getHeroBelt()
	
	if var_9_3 then
		var_9_3:setTouchEnabled(false)
		var_9_3:setScrollEnabled(false)
	end
end

function UnitDetailStory.leaveUI(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.left) or not get_cocos_refid(arg_10_0.vars.right) then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(400), SHOW(false)), arg_10_0.vars.menu_wnd, "block")
	
	local var_10_0 = arg_10_0.vars.menu_wnd:getChildByName("n_gener")
	
	if get_cocos_refid(var_10_0) and var_10_0:isVisible() then
		UIAction:Add(FADE_OUT(200), var_10_0, "block")
	end
	
	local var_10_1 = arg_10_0.vars.left
	
	UIAction:Add(SLIDE_OUT(200, -600), var_10_1:getChildByName("name"), "block")
	
	local var_10_2 = arg_10_0.vars.right
	
	UIAction:Add(SLIDE_OUT(200, 100), var_10_2, "block")
	
	if get_cocos_refid(arg_10_0.vars.relation_wnd) then
		UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_10_0.vars.relation_wnd, "block")
		
		for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.relation_wnd:getChildren()) do
			if string.starts(iter_10_1:getName(), "new_line_") then
				for iter_10_2, iter_10_3 in pairs(iter_10_1:getChildren()) do
					UIAction:Add(FADE_OUT(200), iter_10_3, "block")
				end
			end
		end
	end
	
	local var_10_3 = UnitDetail:getHeroBelt()
	
	if var_10_3 then
		var_10_3:setTouchEnabled(true)
		var_10_3:setScrollEnabled(true)
	end
end

function UnitDetailStory.updateUnitInfo(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0:isVisible() then
		return 
	end
	
	arg_11_1 = arg_11_1 or arg_11_0.vars.unit
	
	local var_11_0 = UnitDetail:getHeroBelt()
	
	if var_11_0 then
		var_11_0:scrollToUnit(arg_11_1)
	end
	
	arg_11_0.vars.unit = arg_11_1
	
	local var_11_1 = arg_11_1.inst.code
	
	if arg_11_1:isMoonlightDestinyUnit() then
		var_11_1 = MoonlightDestiny:getRelationCharacterCode(var_11_1)
	end
	
	local var_11_2 = UnitInfosUtil:getCharacterVoiceName(var_11_1)
	
	if_set(arg_11_0.vars.menu_wnd, "txt_cv", var_11_2)
	
	local var_11_3 = arg_11_0.vars.menu_wnd:getChildByName("txt_name")
	
	var_11_3:setString(T(arg_11_1.db.name))
	UIUserData:proc(var_11_3)
	if_call(arg_11_0.vars.menu_wnd, "star1", "setPositionX", 10 + var_11_3:getContentSize().width * var_11_3:getScaleX() + var_11_3:getPositionX())
	UIUtil:setUnitAllInfo(arg_11_0.vars.menu_wnd, arg_11_1)
	
	if arg_11_0.vars.unit:isGrowthBoostRegistered() then
		local var_11_4 = arg_11_0.vars.unit:clone()
		
		GrowthBoost:apply(var_11_4)
		
		var_11_4.inst.locked = arg_11_0.vars.unit:isLocked()
		
		UIUtil:setUnitAllInfo(arg_11_0.vars.menu_wnd, var_11_4)
	end
	
	arg_11_0:makeRelationWnd()
	arg_11_0:updateUnitSubstory(arg_11_1)
end

function UnitDetailStory.getCurGeneration(arg_12_0)
	if not arg_12_0:isVisible() then
		return 
	end
	
	return arg_12_0.vars.current_generation
end

function UnitDetailStory.makeRelationWnd(arg_13_0, arg_13_1)
	if not arg_13_0:isVisible() then
		return 
	end
	
	if get_cocos_refid(arg_13_0.vars.relation_wnd) then
		arg_13_0.vars.relation_wnd:removeFromParent()
	end
	
	local var_13_0 = arg_13_0.vars.unit
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = var_13_0.db.code
	
	if var_13_0:isMoonlightDestinyUnit() then
		var_13_1 = MoonlightDestiny:getRelationCharacterCode(var_13_1)
	end
	
	RelationPipeLine:start()
	
	if not arg_13_1 then
		arg_13_0.vars.total_generation, arg_13_0.vars.current_generation = RelationPipeLine:getGeneration(var_13_1)
	end
	
	local var_13_2 = RelationPipeLine:makeRelationWnd(var_13_0, arg_13_0.vars.current_generation or 1)
	
	arg_13_0.vars.relation_wnd = var_13_2
	
	var_13_2:setPosition(0, 0)
	RelationPipeLine:setGenerationButton(arg_13_0.vars.menu_wnd, UnitInfosController:getUnit(), RelationPipeLine:getCache("current_id"), arg_13_0.vars.total_generation, arg_13_0.vars.current_generation)
	RelationPipeLine:generateRelationMap(var_13_2, arg_13_0.onSlotTouch)
	
	arg_13_0.vars.slot_info = RelationPipeLine:getCache("slot_info")
	arg_13_0.vars.released_slot = {}
	arg_13_0.vars.slot_req_story = {}
	
	arg_13_0.vars.menu_wnd:getChildByName("pivot"):addChild(var_13_2)
	RelationPipeLine:End()
	
	local var_13_3 = 300
	local var_13_4, var_13_5 = var_13_2:getPosition()
	
	var_13_2:setPosition(var_13_4, var_13_5 + 500)
	arg_13_0.vars.relation_wnd:setOpacity(0)
	UIAction:Add(SPAWN(FADE_IN(var_13_3), LOG(MOVE_TO(var_13_3 - 150, var_13_4, var_13_5))), arg_13_0.vars.relation_wnd, "block")
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.relation_wnd:getChildren()) do
		if string.starts(iter_13_1:getName(), "new_line_") then
			for iter_13_2, iter_13_3 in pairs(iter_13_1:getChildren()) do
				iter_13_3:setOpacity(0)
				UIAction:Add(SEQ(FADE_IN(var_13_3 + 400)), iter_13_3, "block")
			end
		end
	end
end

function UnitDetailStory.onSlotTouch(arg_14_0, arg_14_1)
	if not UnitDetailStory:isVisible() then
		return 
	end
	
	if arg_14_1 ~= 2 then
		return 
	end
	
	local var_14_0 = string.split(arg_14_0:getName(), "slot_")[2]
	local var_14_1 = UnitDetailStory.vars.slot_info[var_14_0]
	
	if var_14_1.slot_type == "fix" then
		if UIAction:Find("block") then
			return 
		end
		
		if var_14_1.locked then
			UnitStory:showUnlockInfoText(var_14_1)
		else
			UnitDetailStory:showDetailPopup(var_14_1, UnitDetailStory.vars.released_slot[var_14_0], var_14_0)
		end
	else
		balloon_message_with_sound("cant_relation")
	end
end

function UnitDetailStory.showUnlockInfoText(arg_15_0, arg_15_1)
	if not arg_15_0:isVisible() then
		return 
	end
	
	local var_15_0 = arg_15_1 or {}
	local var_15_1 = 100
	local var_15_2
	local var_15_3 = var_15_0.unlock_enter or var_15_0.unlock_mltheater
	
	if not var_15_3 then
		return 
	end
	
	local var_15_4, var_15_5, var_15_6 = DB("level_enter", var_15_3, {
		"id",
		"episode",
		"name"
	})
	
	if not var_15_4 then
		return 
	end
	
	if var_15_5 then
		var_15_1 = string.sub(var_15_5, -1, -1)
	end
	
	if var_15_6 then
		var_15_2 = T(var_15_6)
	end
	
	local var_15_7 = T("ep_select_num" .. var_15_1)
	
	balloon_message_with_sound("msg_relation_not_open", {
		episode = var_15_7,
		map = var_15_2
	})
end

function UnitDetailStory.showDetailPopup(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if not arg_16_0:isVisible() then
		return 
	end
	
	if not arg_16_1 or not arg_16_3 then
		return 
	end
	
	RelationPipeLine:showDetailPopup(arg_16_0.vars.slot_info, arg_16_0.vars.slot_req_story, arg_16_1, arg_16_2, arg_16_3, arg_16_4, SceneManager:getCurrentSceneName() ~= "unit_ui")
end

function UnitDetailStory.selectGeneration(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0:isVisible() then
		return 
	end
	
	if arg_17_2 == "next" then
		arg_17_1 = arg_17_1 + 1
	else
		arg_17_1 = arg_17_1 - 1
	end
	
	if arg_17_0.vars.current_generation == arg_17_1 then
		return 
	end
	
	if arg_17_1 > arg_17_0.vars.total_generation then
		return 
	end
	
	arg_17_0.vars.current_generation = arg_17_1
	
	arg_17_0:makeRelationWnd(true)
end

function UnitDetailStory.heroChangeInStory(arg_18_0, arg_18_1)
	if not arg_18_0:isVisible() or not arg_18_1 then
		return 
	end
	
	local var_18_0 = SceneManager:getRunningPopupScene():getChildByName("hero_story_fix_detail")
	
	if var_18_0 and get_cocos_refid(var_18_0) then
		var_18_0:removeFromParent()
		BackButtonManager:pop("hero_story_fix_detail")
	end
	
	local var_18_1 = UnitDetail:getHeroBelt()
	
	if var_18_1 then
		var_18_1:resetFilter()
		var_18_1:scrollToUnit(arg_18_1, 0)
		var_18_1:updateSelectedControlColor(arg_18_1)
	end
	
	UnitMain:onSelectUnit(arg_18_1)
end

function UnitDetailStory.showDetailPopup(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if not arg_19_1 or not arg_19_3 then
		return 
	end
	
	local var_19_0 = false
	
	if SceneManager:getRunningNativeScene():getChildByName("hero_story_fix_detail") ~= nil then
		local var_19_1 = SceneManager:getRunningNativeScene():getChildByName("hero_story_fix_detail")
		
		if get_cocos_refid(var_19_1) then
			var_19_1:removeFromParent()
			
			var_19_0 = true
		end
	end
	
	local var_19_2 = load_dlg("hero_story_fix_detail", true, "wnd")
	
	if_set_visible(var_19_2, "btn_next", false)
	if_set_visible(var_19_2, "btn_pre", false)
	if_set_visible(var_19_2, "btn_move2", true)
	
	local var_19_3 = var_19_2:getChildByName("base")
	local var_19_4 = var_19_2:getChildByName("base_move_detail")
	
	if get_cocos_refid(var_19_3) and get_cocos_refid(var_19_4) then
		var_19_3:setPosition(var_19_4:getPosition())
	end
	
	if arg_19_1.relation_count >= 2 then
		local var_19_5 = string.split(arg_19_3, "_")
		local var_19_6 = arg_19_3
		
		if not arg_19_4 then
			for iter_19_0 = 1, arg_19_1.relation_count do
				local var_19_7 = string.format("%s_%s_%d_%d", var_19_5[1], var_19_5[2], var_19_5[3], iter_19_0)
				
				if arg_19_0.vars.slot_info[var_19_7] and arg_19_0.vars.slot_info[var_19_7].locked == false then
					var_19_6 = var_19_7
					arg_19_1 = arg_19_0.vars.slot_info[var_19_6]
				end
			end
		end
		
		local var_19_8 = string.split(var_19_6, "_")
		
		if #var_19_8 < 4 then
			local var_19_9 = string.format("%s_%s_%d_%d", var_19_8[1], var_19_8[2], var_19_8[3], "1")
			
			if arg_19_0.vars.slot_info[var_19_9] then
				var_19_2:getChildByName("btn_next").code = var_19_9
				
				if_set_visible(var_19_2, "btn_pre", false)
				
				if not arg_19_0.vars.slot_info[var_19_9].locked then
					if_set_visible(var_19_2, "btn_next", true)
				end
			end
		else
			if_set_visible(var_19_2, "btn_pre", true)
			
			if tonumber(var_19_8[4]) == 1 then
				var_19_2:getChildByName("btn_pre").code = string.format("%s_%s_%d", var_19_8[1], var_19_8[2], var_19_8[3])
			else
				var_19_2:getChildByName("btn_pre").code = string.format("%s_%s_%d_%d", var_19_8[1], var_19_8[2], var_19_8[3], tonumber(var_19_8[4] - 1))
			end
			
			if_set_visible(var_19_2, "btn_next", false)
			
			local var_19_10 = tonumber(var_19_8[4]) + 1
			local var_19_11 = string.format("%s_%s_%d_%d", var_19_8[1], var_19_8[2], var_19_8[3], var_19_10)
			
			if arg_19_0.vars.slot_info[var_19_11] then
				var_19_2:getChildByName("btn_next").code = var_19_11
				
				if not arg_19_0.vars.slot_info[var_19_11].locked then
					if_set_visible(var_19_2, "btn_next", true)
				end
			end
		end
	end
	
	local function var_19_12()
		if get_cocos_refid(var_19_2) then
			var_19_2:removeFromParent()
		end
		
		BackButtonManager:pop("hero_story_fix_detail")
	end
	
	BackButtonManager:push({
		check_id = "hero_story_fix_detail",
		back_func = var_19_12
	})
	SceneManager:getRunningNativeScene():addChild(var_19_2)
	
	local var_19_13 = arg_19_1.relation_function
	local var_19_14 = arg_19_1.relation_type
	local var_19_15 = ccui.Button:create()
	
	var_19_15:setTouchEnabled(true)
	var_19_15:ignoreContentAdaptWithSize(false)
	var_19_15:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_19_15:setPosition(VIEW_BASE_LEFT, 0)
	var_19_15:setAnchorPoint(0, 0)
	var_19_15:setLocalZOrder(-1)
	var_19_15:addTouchEventListener(function(arg_21_0, arg_21_1)
		if arg_21_1 ~= 2 then
			return 
		end
		
		var_19_12()
	end)
	var_19_15:setName("btn_close")
	var_19_2:addChild(var_19_15)
	
	local var_19_16 = UnitStory:getSimpleFace(var_19_13, var_19_14)
	local var_19_17 = DB("character", var_19_13, "name")
	
	if_set(var_19_2, "chara_name", T(var_19_17))
	
	local var_19_18, var_19_19 = UIUtil:getRelationColorIcon(var_19_14)
	
	if_set_visible(var_19_16, "chara_name", false)
	if_set_visible(var_19_16, "icon_longing", false)
	if_set_visible(var_19_16, "t_relation", false)
	if_set(var_19_2, "t_relation", T("rb_fix_" .. var_19_14 .. "_tl"))
	if_set_color(var_19_2, "t_relation", var_19_18)
	if_set_sprite(var_19_2, "icon_longing", var_19_19)
	var_19_16:setScale(var_19_16:getScale() * 0.7)
	if_set_visible(var_19_16, "icon_locked", not arg_19_2)
	
	if not arg_19_2 then
		local var_19_20 = arg_19_1.slot_number
		local var_19_21 = arg_19_0.vars.slot_req_story[var_19_20]
		
		if var_19_21 then
			local var_19_22 = string.split(var_19_21, "_")
			
			if_set(var_19_2, "deactive_desc", T("cha_story_episode_long", {
				num = var_19_22[3]
			}))
		else
			if_set_visible(var_19_2, "active", true)
			if_set_visible(var_19_2, "deactive", false)
		end
	end
	
	var_19_2:getChildByName("face_node"):addChild(var_19_16)
	if_set(var_19_2, "active_desc", T(arg_19_1.relation_text or ""))
	
	local var_19_23 = var_19_2:getChildByName("LEFT")
	local var_19_24 = var_19_23:getPositionX()
	
	if var_19_0 == false then
		var_19_23:setPositionX(-400)
		UIAction:Add(LOG(MOVE_TO(250, var_19_24)), var_19_23, "block")
	else
		var_19_23:setPositionX(var_19_24)
	end
	
	var_19_2:getChildByName("btn_move2").code = var_19_13
end

function UnitDetailStory.updateUnitSubstory(arg_22_0, arg_22_1)
	if not arg_22_0:isVisible() or not get_cocos_refid(arg_22_0.vars.right) or not get_cocos_refid(arg_22_0.vars.scrollview) then
		return 
	end
	
	arg_22_1 = arg_22_1 or arg_22_0.vars.unit
	
	if not arg_22_1 then
		return 
	end
	
	local var_22_0 = arg_22_0:getCharacterSubStories(arg_22_1)
	local var_22_1 = table.count(var_22_0 or {}) > 0
	
	if_set_visible(arg_22_0.vars.right, "btn_book", false)
	if_set_visible(arg_22_0.vars.right, "btn_storylist", true)
	arg_22_0.vars.scrollview:setVisible(var_22_1)
	
	local var_22_2 = arg_22_0.vars.right:getChildByName("n_info")
	
	if get_cocos_refid(var_22_2) then
		var_22_2:setVisible(not var_22_1)
		if_set(var_22_2, "label", T("ui_hero_detail_story_btn_block", {
			char = arg_22_1:getName()
		}))
	end
	
	if var_22_1 then
		SubStoryViewerScroll:create(arg_22_1.db.code, 314, 151, "hero_detail_substory_item", arg_22_0.vars.scrollview, {
			select_callback = function(arg_23_0)
				arg_22_0.vars.selected_item = arg_23_0
				
				local var_23_0 = SubStoryViewerUtil:checkIsActive(arg_22_0.vars.selected_item)
				
				if_set_visible(arg_22_0.vars.right, "btn_book", var_23_0)
				if_set_visible(arg_22_0.vars.right, "btn_storylist", not var_23_0)
			end
		})
	else
		arg_22_0.vars.selected_item = nil
	end
end

function UnitDetailStory.getCharacterSubStories(arg_24_0, arg_24_1)
	if not arg_24_0:isVisible() then
		return 
	end
	
	arg_24_1 = arg_24_1 or arg_24_0.vars.unit
	
	if not arg_24_1 then
		return 
	end
	
	SubStoryViewerDB:create()
	
	local var_24_0 = arg_24_1.db.code
	
	if arg_24_1:isMoonlightDestinyUnit() then
		var_24_0 = MoonlightDestiny:getRelationCharacterCode(var_24_0)
	end
	
	return (SubStoryViewerDB:getCharacterSubStories(var_24_0))
end

function UnitDetailStory.updateItems(arg_25_0)
	if not arg_25_0:isVisible() or not get_cocos_refid(arg_25_0.vars.scrollView) or not arg_25_0.vars.selected_item then
		return 
	end
	
	SubStoryViewerScroll:updateItems()
end

function UnitDetailStory.getSelectedItem(arg_26_0)
	if not arg_26_0:isVisible() then
		return nil
	end
	
	return arg_26_0.vars.selected_item
end
