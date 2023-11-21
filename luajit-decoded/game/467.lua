function HANDLER.story_slide_world_map(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_bg" then
		WorldMapLandSlideUI:onButtonEnter()
	elseif arg_1_1 == "btn_arrow_left" then
		WorldMapLandSlideUI:onButtonPrev()
	elseif arg_1_1 == "btn_arrow_right" then
		WorldMapLandSlideUI:onButtonNext()
	end
end

WorldMapLandSlideUI = {}

function WorldMapLandSlideUI.create(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or WorldMapManager:getController()
	
	if not arg_2_1 then
		return 
	end
	
	if arg_2_0.vars then
		arg_2_0:close()
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("story_slide_world_map", true, "wnd")
	arg_2_0.vars.controller = arg_2_1
	arg_2_0.vars.layer = arg_2_1:getLayer() or SceneManager:getRunningNativeScene()
	
	arg_2_0.vars.layer:addChild(arg_2_0.vars.wnd)
	arg_2_0.vars.wnd:setLocalZOrder(4)
	
	local var_2_0 = arg_2_1:getContinentID()
	local var_2_1 = string.sub(var_2_0, 1, -4)
	
	arg_2_0.vars.slide_list = arg_2_0:makeSlideList(var_2_1)
	
	local var_2_2 = to_n(string.sub(var_2_0, -3, -1))
	
	arg_2_0.vars.idx = var_2_2
	arg_2_0.vars.start_idx = var_2_2
	
	arg_2_0.vars.controller:updateContentButtons("LAND")
	arg_2_0:setSlide(arg_2_0.vars.wnd, arg_2_0.vars.slide_list[var_2_2])
	arg_2_0:setVisibleMagnifier(false)
	arg_2_0:setBackgroundImage()
	arg_2_0:onEnter()
end

function WorldMapLandSlideUI.onEnter(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_3_0.vars.wnd, "block")
	
	local var_3_0 = arg_3_0.vars.controller
	
	if var_3_0 then
		var_3_0:playCloudEffect(var_3_0:getWorldMapUI():getWnd())
	end
	
	TutorialGuide:procGuide()
end

function WorldMapLandSlideUI.onButtonEnter(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	local var_4_0 = (arg_4_0.vars.slide_list or {})[arg_4_0.vars.idx or 0]
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = arg_4_0.vars.controller
	
	if var_4_1 then
		var_4_1:moveLocalWorldScene({
			continent = var_4_0.key_normal
		})
	end
	
	arg_4_0:onLeave()
end

function WorldMapLandSlideUI.onButtonPrev(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.idx - 1
	local var_5_1 = arg_5_0.vars.slide_list[var_5_0]
	
	if not var_5_1 then
		return 
	end
	
	if not var_5_1.unlock then
		arg_5_0:showBalloonMessage(var_5_1)
		
		return 
	end
	
	arg_5_0.vars.idx = var_5_0
	
	local var_5_2, var_5_3 = arg_5_0:cloneCenterNode()
	
	if not get_cocos_refid(var_5_2) then
		return 
	end
	
	arg_5_0:setSlide(var_5_2, var_5_1)
	var_5_2:setLocalZOrder(1)
	var_5_2:setVisible(false)
	var_5_2:setPosition(-VIEW_WIDTH, 0)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(400, 0, 0))), var_5_2, "block")
	UIAction:Add(SEQ(LOG(MOVE_TO(400, VIEW_WIDTH, 0)), REMOVE()), var_5_3, "block")
end

function WorldMapLandSlideUI.onButtonNext(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.idx + 1
	local var_6_1 = arg_6_0.vars.slide_list[var_6_0]
	
	if not var_6_1 then
		return 
	end
	
	if not var_6_1.unlock then
		arg_6_0:showBalloonMessage(var_6_1)
		
		return 
	end
	
	arg_6_0.vars.idx = var_6_0
	
	local var_6_2, var_6_3 = arg_6_0:cloneCenterNode()
	
	if not get_cocos_refid(var_6_2) then
		return 
	end
	
	arg_6_0:setSlide(var_6_2, var_6_1)
	var_6_2:setLocalZOrder(1)
	var_6_2:setVisible(false)
	var_6_2:setPosition(VIEW_WIDTH, 0)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(400, 0, 0))), var_6_2, "block")
	UIAction:Add(SEQ(LOG(MOVE_TO(400, -VIEW_WIDTH, 0)), REMOVE()), var_6_3, "block")
end

function WorldMapLandSlideUI.cloneCenterNode(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	if get_cocos_refid(arg_7_0.vars.world_navi_icon) then
		arg_7_0.vars.world_navi_icon:removeFromParent()
	end
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("n_center")
	local var_7_1 = var_7_0:clone()
	
	var_7_0:setName("n_center_old")
	arg_7_0.vars.wnd:addChild(var_7_1)
	
	return var_7_1, var_7_0
end

function WorldMapLandSlideUI.updateSlideButton(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.idx
	local var_8_1 = arg_8_0.vars.slide_list[var_8_0 - 1]
	local var_8_2 = arg_8_0.vars.slide_list[var_8_0 + 1]
	local var_8_3 = arg_8_0.vars.wnd:getChildByName("n_arrow_left")
	local var_8_4 = arg_8_0.vars.wnd:getChildByName("n_arrow_right")
	
	if_set_visible(var_8_3, nil, var_8_1 ~= nil)
	if_set_visible(var_8_4, nil, var_8_2 ~= nil)
	
	if var_8_1 and get_cocos_refid(var_8_3) then
		var_8_3:setLocalZOrder(2)
		if_set_opacity(var_8_3, nil, 0)
		if_set_opacity(var_8_3, "btn_arrow_left", var_8_1.unlock and 255 or 76.5)
		UIAction:Add(SEQ(DELAY(100), FADE_IN(300)), var_8_3, "block")
	end
	
	if var_8_2 and get_cocos_refid(var_8_4) then
		var_8_4:setLocalZOrder(2)
		if_set_opacity(var_8_4, nil, 0)
		if_set_opacity(var_8_4, "btn_arrow_right", var_8_2.unlock and 255 or 76.5)
		UIAction:Add(SEQ(DELAY(100), FADE_IN(300)), var_8_4, "block")
	end
end

local function var_0_0(arg_9_0)
	if type(arg_9_0) == "string" then
		arg_9_0 = totable(arg_9_0)
	end
	
	if type(arg_9_0) ~= "table" then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0) do
		if iter_9_0 == "schedule" then
			if not SubstoryManager:isActiveSchedule(iter_9_1) then
				return false, iter_9_0, iter_9_1
			end
		elseif iter_9_0 == "enter" then
			if not Account:isMapCleared(iter_9_1) then
				return false, iter_9_0, iter_9_1
			end
		else
			Log.e("WorldMapLandSlideUI.invalid_condition")
			
			return nil
		end
	end
	
	return true
end

function WorldMapLandSlideUI.showBalloonMessage(arg_10_0, arg_10_1)
	if arg_10_1.lock_type then
		if arg_10_1.lock_type == "enter" then
			local var_10_0 = DB("level_enter", arg_10_1.lock_value, "name")
			
			balloon_message_with_sound("continent_slide_lock_enter", {
				enter = T(var_10_0)
			})
		elseif arg_10_1.lock_type == "schedule" then
			local var_10_1 = SubstoryManager:getRemainEnterTime(arg_10_1.lock_value)
			
			balloon_message_with_sound("continent_slide_lock_schedule", {
				time = sec_to_full_string(var_10_1)
			})
		else
			balloon_message_with_sound("mission_notyet")
		end
	end
end

function WorldMapLandSlideUI.makeSlideList(arg_11_0, arg_11_1)
	local var_11_0 = {}
	
	for iter_11_0 = 1, 999 do
		local var_11_1 = arg_11_1 .. string.format("%03d", iter_11_0)
		local var_11_2, var_11_3 = DB("level_world_2_continent_slide", var_11_1, {
			"id",
			"unlock_condition"
		})
		
		if not var_11_2 then
			break
		end
		
		local var_11_4, var_11_5 = DB("level_world_2_continent", var_11_1, {
			"name",
			"key_normal"
		})
		local var_11_6, var_11_7, var_11_8 = var_0_0(var_11_3)
		local var_11_9 = {
			name = var_11_4,
			key = var_11_1,
			key_normal = var_11_5,
			unlock = var_11_6,
			lock_type = var_11_7,
			lock_value = var_11_8
		}
		
		table.insert(var_11_0, var_11_9)
	end
	
	return var_11_0
end

function WorldMapLandSlideUI.setSlide(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_1) then
		return 
	end
	
	if not arg_12_2 then
		return 
	end
	
	if_set(arg_12_1, "txt_title", T(arg_12_2.name))
	if_set_sprite(arg_12_1, "story_bg", arg_12_0:getSlideImage(arg_12_2.key))
	arg_12_0:updateSlideButton()
	arg_12_0:updateLandNavigator()
end

function WorldMapLandSlideUI.setBackgroundImage(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_13_0.vars.wnd) and arg_13_0.vars.controller then
		local var_13_0 = DB("level_world_1_world", arg_13_0.vars.controller:getWorldID(), "img")
		local var_13_1 = arg_13_0.vars.wnd:getChildByName("bg")
		
		if get_cocos_refid(var_13_1) then
			var_13_1:setLocalZOrder(0)
			if_set_sprite(var_13_1, nil, var_13_0)
		end
	end
end

function WorldMapLandSlideUI.getSlideImage(arg_14_0, arg_14_1)
	local var_14_0 = DB("level_world_2_continent_slide", arg_14_1, "slide_img") or ""
	
	for iter_14_0 = 1, 9 do
		local var_14_1, var_14_2 = DB("level_world_2_continent_slide", arg_14_1, {
			"slide_condition_" .. iter_14_0,
			"slide_img_change_" .. iter_14_0
		})
		
		if not var_14_1 or not var_14_2 then
			break
		end
		
		if var_0_0(var_14_1) then
			var_14_0 = var_14_2
		end
	end
	
	return UIUtil:getIllustPath("story/bg/", var_14_0)
end

function WorldMapLandSlideUI.setVisibleMagnifier(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	if_set_visible(arg_15_0.vars.layer, "btn_zoom_out", arg_15_1)
	if_set_visible(arg_15_0.vars.layer, "n_quest_navi", arg_15_1)
end

function WorldMapLandSlideUI.updateLandNavigator(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	local var_16_0
	local var_16_1 = 0
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.slide_list) do
		if SubstoryManager:isActiveQuestInChapter(iter_16_1.key_normal) then
			if arg_16_0.vars.idx == iter_16_0 then
				var_16_0 = arg_16_0.vars.wnd:getChildByName("n_center"):getChildByName("n_navigator")
				var_16_1 = -60
				
				break
			end
			
			if iter_16_0 > arg_16_0.vars.idx then
				var_16_0 = arg_16_0.vars.wnd:getChildByName("n_navigator_right")
				var_16_1 = -65
				
				break
			end
			
			if iter_16_0 < arg_16_0.vars.idx then
				var_16_0 = arg_16_0.vars.wnd:getChildByName("n_navigator_left")
				var_16_1 = -65
			end
			
			break
		end
	end
	
	if get_cocos_refid(var_16_0) then
		if not get_cocos_refid(arg_16_0.vars.world_navi_icon) then
			local var_16_2 = UIUtil:makeNavigatorAni({
				scale = 0.55
			})
			
			var_16_2:setLocalZOrder(99999)
			
			arg_16_0.vars.world_navi_icon = var_16_2
		end
		
		arg_16_0.vars.world_navi_icon:ejectFromParent()
		var_16_0:addChild(arg_16_0.vars.world_navi_icon)
		arg_16_0.vars.world_navi_icon:setPosition(0, var_16_1)
	end
end

function WorldMapLandSlideUI.onLeave(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if arg_17_0.vars.controller then
		arg_17_0.vars.controller:playCloudEffect(arg_17_0.vars.controller:getWorldMapUI():getWnd())
	end
	
	UIAction:Add(SEQ(FADE_OUT(400), CALL(WorldMapLandSlideUI.close, arg_17_0)), arg_17_0.vars.wnd, "block")
end

function WorldMapLandSlideUI.close(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	arg_18_0:setVisibleMagnifier(true)
	
	if arg_18_0.vars.controller then
		arg_18_0.vars.controller:updateContentButtons("TOWN")
	end
	
	if get_cocos_refid(arg_18_0.vars.wnd) then
		arg_18_0.vars.wnd:removeFromParent()
	end
	
	arg_18_0.vars = nil
end
