UIBackground = {}
DEBUG.BG_ID = nil

function UIBackground.makeBGChangeAction(arg_1_0)
	return CALL(function()
		if get_cocos_refid(arg_1_0.vars.new_bg) then
			arg_1_0.vars.new_bg:removeFromParent()
			
			arg_1_0.vars.new_bg = nil
			arg_1_0.vars.field = nil
		end
		
		if not get_cocos_refid(arg_1_0.vars.prebake_bg) then
			return 
		end
		
		arg_1_0.vars.prebake_bg:setVisible(true)
		
		arg_1_0.vars.new_bg = arg_1_0.vars.prebake_bg
		arg_1_0.vars.field = arg_1_0.vars.prebake_field
		arg_1_0.vars.prebake_bg = nil
		arg_1_0.vars.prebake_field = nil
	end)
end

function UIBackground.makePreBGAction(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if not arg_3_1 or not arg_3_2 then
		return 
	end
	
	return LINEAR_CALL(400 * arg_3_3, nil, function(arg_4_0, arg_4_1)
		local var_4_0, var_4_1, var_4_2 = arg_3_2(arg_3_1)
		local var_4_3 = arg_3_4 or VIEW_WIDTH / 2
		
		if get_cocos_refid(var_4_0) and not var_4_2 then
			var_4_1:setViewPortPosition(var_4_3 + VIEW_WIDTH / 2 * arg_4_1)
			var_4_1:updateViewport()
		end
	end, 0, 0.5)
end

function UIBackground.makeAfterBGAction(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	return LOG(LINEAR_CALL(500 * arg_5_3, nil, function(arg_6_0, arg_6_1)
		local var_6_0, var_6_1, var_6_2 = arg_5_2(arg_5_1)
		local var_6_3 = arg_5_4 or VIEW_WIDTH / 2
		local var_6_4 = -(VIEW_WIDTH / 2 * (1 - arg_6_1))
		
		if get_cocos_refid(var_6_0) and not var_6_2 then
			var_6_1:setViewPortPosition(var_6_4 + var_6_3)
			var_6_1:updateViewport()
		end
	end, 0, 1))
end

function UIBackground.getCurrentBGAndField(arg_7_0)
	local var_7_0
	
	if arg_7_0.vars.new_bg then
		var_7_0 = arg_7_0.vars.new_bg.is_sprite
	end
	
	return arg_7_0.vars.new_bg, arg_7_0.vars.field, var_7_0
end

function UIBackground.makePreFadeAction(arg_8_0, arg_8_1, arg_8_2)
	return SEQ(LOG(OPACITY(400 * arg_8_1, 0, arg_8_2 or 0.9)), DELAY(100 * arg_8_1))
end

function UIBackground.makeAfterFadeAction(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	return SEQ(CALL(function()
		if arg_9_3 then
			arg_9_1:setOpacity(255 * arg_9_3)
		end
	end), LOG(OPACITY(500 * arg_9_2, arg_9_3 or 0.9, 0)))
end

function UIBackground.isExistBackground(arg_11_0)
	return get_cocos_refid(arg_11_0.vars.new_bg)
end

function UIBackground.isVisibleBackground(arg_12_0)
	return get_cocos_refid(arg_12_0.vars.new_bg) and not arg_12_0.vars.fade_out and arg_12_0.vars.new_bg:isVisible()
end

function UIBackground.fadeInBackground(arg_13_0)
	if not get_cocos_refid(arg_13_0.vars.new_bg) then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.dark_bg) then
		arg_13_0:_createDarkBG()
	end
	
	arg_13_0:updateDarkBGContentSize(arg_13_0.vars.dark_bg)
	arg_13_0:createFadeInAction(arg_13_0, arg_13_0.getCurrentBGAndField, arg_13_0.vars.dark_bg, arg_13_0.vars.bg_viewport_position)
	
	arg_13_0.vars.fade_out = false
end

function UIBackground.offBackground(arg_14_0)
	if_set_visible(arg_14_0.vars.new_bg, nil, false)
end

function UIBackground.fadeOutBackground(arg_15_0)
	if not get_cocos_refid(arg_15_0.vars.new_bg) then
		return 
	end
	
	if not get_cocos_refid(arg_15_0.vars.dark_bg) then
		arg_15_0:_createDarkBG()
	end
	
	arg_15_0:updateDarkBGContentSize(arg_15_0.vars.dark_bg)
	
	if UIAction:Find("fade_in") then
		UIAction:Remove("fade_in")
	end
	
	local var_15_0 = 1
	
	UIAction:Add(SPAWN(SEQ(arg_15_0:makePreBGAction(arg_15_0, arg_15_0.getCurrentBGAndField, var_15_0, arg_15_0.vars.bg_viewport_position), CALL(function()
		arg_15_0.vars.new_bg:setVisible(false)
	end)), SEQ(arg_15_0:makePreFadeAction(var_15_0), arg_15_0:makeAfterFadeAction(arg_15_0.vars.dark_bg, var_15_0))), arg_15_0.vars.dark_bg, "fade_out")
	
	arg_15_0.vars.fade_out = true
end

function UIBackground.createFadeInAction(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	if UIAction:Find("fade_out") then
		UIAction:Remove("fade_out")
	end
	
	local var_17_0 = 1
	
	arg_17_2(arg_17_1):setVisible(false)
	UIAction:Add(SPAWN(SEQ(DELAY(500 * var_17_0), CALL(function()
		arg_17_2(arg_17_1):setVisible(true)
	end), arg_17_0:makeAfterBGAction(arg_17_1, arg_17_2, var_17_0, arg_17_4)), SEQ(arg_17_0:makePreFadeAction(var_17_0, 0.8), arg_17_0:makeAfterFadeAction(arg_17_3, var_17_0, 0.9))), arg_17_3, "fade_in")
end

function UIBackground.updateDarkBGContentSize(arg_19_0, arg_19_1)
	if get_cocos_refid(arg_19_1) then
		arg_19_1:setPosition(VIEW_BASE_LEFT, -HEIGHT_MARGIN / 2)
		arg_19_1:setContentSize(VIEW_WIDTH, VIEW_HEIGHT + HEIGHT_MARGIN)
	end
end

function UIBackground._createDarkBG(arg_20_0)
	arg_20_0.vars.dark_bg = arg_20_0:createDarkBG(arg_20_0.vars.parent)
end

function UIBackground.createDarkBG(arg_21_0, arg_21_1)
	local var_21_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_21_0:setOpacity(0)
	var_21_0:setPosition(VIEW_BASE_LEFT, -HEIGHT_MARGIN / 2)
	var_21_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT + HEIGHT_MARGIN)
	arg_21_1:addChild(var_21_0)
	var_21_0:setName("@fade")
	
	return var_21_0
end

function UIBackground.create(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = {}
	
	copy_functions(UIBackground, var_22_0)
	
	arg_22_5 = arg_22_5 or {}
	
	var_22_0:init(arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	
	return var_22_0
end

function UIBackground.init(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	arg_23_0.vars = {}
	arg_23_0.vars.parent = arg_23_1
	arg_23_0.vars.view_port_idx = arg_23_2
	arg_23_0.vars.debug = {}
	arg_23_0.vars.default_poses = arg_23_5.default_poses or {
		0,
		0,
		VIEW_WIDTH / 2
	}
	arg_23_0.vars.default_scale = arg_23_5.default_scale or 1
	arg_23_0.vars.bg_col_name = arg_23_3
	arg_23_0.vars.bg_scale_col_name = arg_23_4
	arg_23_0.vars.active_flag = true
end

function UIBackground.remove(arg_24_0)
	if get_cocos_refid(arg_24_0.vars.new_bg) then
		arg_24_0.vars.new_bg:removeFromParent()
	end
	
	if get_cocos_refid(arg_24_0.vars.dark_bg) then
		arg_24_0.vars.dark_bg:removeFromParent()
	end
	
	arg_24_0.vars = nil
end

function UIBackground.setBackground(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if not arg_25_0.vars.active_flag then
		return 
	end
	
	if get_cocos_refid(arg_25_0.vars.new_bg) and not arg_25_2 then
		arg_25_0.vars.new_bg:removeFromParent()
	end
	
	if DEBUG.BG_ITEM then
		arg_25_1 = DEBUG.BG_ITEM
	end
	
	arg_25_0.vars.cur_item = arg_25_1
	
	local var_25_0 = DEBUG.BG_ID or arg_25_1.bg_id
	
	if var_25_0 == nil or var_25_0 == "lobby" then
		return 
	end
	
	local var_25_1
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5 = arg_25_1[arg_25_0.vars.bg_col_name] and string.split(arg_25_1[arg_25_0.vars.bg_col_name], ",") or arg_25_0.vars.default_poses
	local var_25_6 = arg_25_1[arg_25_0.vars.bg_scale_col_name] and to_n(arg_25_1[arg_25_0.vars.bg_scale_col_name]) or arg_25_0.vars.default_scale
	local var_25_7 = var_25_5[3] and to_n(var_25_5[3]) or VIEW_WIDTH / 2
	
	print("bg_id?", var_25_0)
	
	if not string.ends(var_25_0, ".png") then
		var_25_1, var_25_2 = FIELD_NEW:create(var_25_0, DESIGN_WIDTH * 2)
		
		var_25_1:setAnchorPoint(0.5, 0.5)
		
		if arg_25_3 then
			var_25_1:setRotation(arg_25_3)
		end
		
		var_25_2:lockViewPortRange({
			minRangeX = -DESIGN_WIDTH * 2,
			maxRangeX = DESIGN_WIDTH * 2
		})
		
		var_25_4 = var_25_1:findChildByName("@field_game_layer")
		
		var_25_4:setAnchorPoint(0.5, 0.5)
		var_25_2:setViewPortPosition(var_25_7)
		var_25_2:updateViewport()
		
		var_25_3 = false
	else
		var_25_1 = cc.Sprite:create(var_25_0)
		
		var_25_1:setAnchorPoint(0.5, 0.5)
		
		var_25_4 = var_25_1
		var_25_3 = true
	end
	
	arg_25_0.vars.parent:addChild(var_25_1)
	
	if arg_25_3 then
		var_25_4:setPosition(to_n(var_25_5[1]) * -1, to_n(var_25_5[2]) * -1)
	else
		var_25_4:setPosition(to_n(var_25_5[1]), to_n(var_25_5[2]))
	end
	
	var_25_4:setScale(var_25_6)
	
	if arg_25_2 then
		arg_25_0.vars.prebake_bg = var_25_1
		arg_25_0.vars.prebake_field = var_25_2
		
		arg_25_0.vars.prebake_bg:setVisible(false)
		
		arg_25_0.vars.prebake_viewport_position = var_25_7
		arg_25_0.vars.prebake_bg.is_sprite = var_25_3
	else
		arg_25_0.vars.new_bg = var_25_1
		arg_25_0.vars.field = var_25_2
		arg_25_0.vars.bg_viewport_position = var_25_7
		arg_25_0.vars.new_bg.is_sprite = var_25_3
	end
	
	arg_25_0.vars.last_poses = var_25_5
end

function UIBackground.useRATIOScale(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = DEBUG.BG_ID or arg_26_1.bg_id
	
	if var_26_0 == nil or var_26_0 == "lobby" then
		return 
	end
	
	local var_26_1 = VIEW_WIDTH / DESIGN_WIDTH
	local var_26_2 = (arg_26_2 and arg_26_0.vars.prebake_bg or arg_26_0.vars.new_bg):findChildByName("@field_game_layer")
	
	var_26_2:setScale(var_26_2:getScale() * var_26_1)
end

function UIBackground.getUsableGameLayer(arg_27_0, arg_27_1)
	if arg_27_1 then
		return arg_27_0:getPrebakeGameLayer()
	else
		return arg_27_0:getGameLayer()
	end
end

function UIBackground.getUsableBG(arg_28_0, arg_28_1)
	if arg_28_1 then
		return arg_28_0:getPrebakeBG()
	else
		return arg_28_0:getBG()
	end
end

function UIBackground.getUsableField(arg_29_0, arg_29_1)
	if arg_29_1 then
		return arg_29_0:getPrebakeField()
	else
		return arg_29_0:getField()
	end
end

function UIBackground.getPrebakeGameLayer(arg_30_0)
	return arg_30_0.vars.prebake_bg:findChildByName("@field_game_layer")
end

function UIBackground.getPrebakeBG(arg_31_0)
	return arg_31_0.vars.prebake_bg
end

function UIBackground.getPrebakeField(arg_32_0)
	return arg_32_0.vars.prebake_field
end

function UIBackground.getGameLayer(arg_33_0)
	return arg_33_0.vars.new_bg:findChildByName("@field_game_layer")
end

function UIBackground.getBG(arg_34_0)
	return arg_34_0.vars.new_bg
end

function UIBackground.getField(arg_35_0)
	return arg_35_0.vars.field
end

function UIBackground.getLastPoses(arg_36_0)
	return arg_36_0.vars.last_poses
end

function UIBackground.setActive(arg_37_0, arg_37_1)
	arg_37_0.vars.active_flag = arg_37_1
	
	if arg_37_0.vars.active_flag then
		return 
	end
	
	if get_cocos_refid(arg_37_0.vars.dark_bg) then
		arg_37_0.vars.dark_bg:removeFromParent()
	end
	
	if get_cocos_refid(arg_37_0.vars.prebake_bg) then
		arg_37_0.vars.prebake_bg:removeFromParent()
	end
	
	if get_cocos_refid(arg_37_0.vars.new_bg) then
		arg_37_0.vars.new_bg:removeFromParent()
	end
	
	arg_37_0.vars.dark_bg = nil
	arg_37_0.vars.prebake_bg = nil
	arg_37_0.vars.new_bg = nil
end

function UIBackground.fadeInOut(arg_38_0)
	if not get_cocos_refid(arg_38_0.vars.dark_bg) then
		arg_38_0:_createDarkBG()
	end
	
	arg_38_0.vars.dark_bg:setLocalZOrder(8888888)
	arg_38_0.vars.dark_bg:setOpacity(0)
	arg_38_0:updateDarkBGContentSize(arg_38_0.vars.dark_bg)
	
	local var_38_0 = 1
	local var_38_1 = arg_38_0:makePreBGAction(arg_38_0, arg_38_0.getCurrentBGAndField, var_38_0, arg_38_0.vars.bg_viewport_position)
	local var_38_2 = arg_38_0:makeAfterBGAction(arg_38_0, arg_38_0.getCurrentBGAndField, var_38_0, arg_38_0.vars.prebake_viewport_position)
	local var_38_3 = arg_38_0:makePreFadeAction(var_38_0)
	local var_38_4 = arg_38_0:makeAfterFadeAction(arg_38_0.vars.dark_bg, var_38_0)
	local var_38_5 = arg_38_0:makeBGChangeAction()
	local var_38_6 = SEQ(var_38_1, var_38_5, var_38_2)
	local var_38_7 = SEQ(var_38_3, var_38_4)
	
	UIAction:Add(SPAWN(var_38_6, var_38_7), arg_38_0.vars.dark_bg, "bg.fade")
	
	arg_38_0.vars.bg_viewport_position = arg_38_0.vars.prebake_viewport_position
end

local function var_0_0(arg_39_0, arg_39_1, arg_39_2)
	return string.format("REPORT! X : %f Y :%f VIEW : %f", arg_39_0, arg_39_1, arg_39_2)
end

local function var_0_1(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0:getGameLayer()
	
	if arg_40_1 then
		var_40_0:setScale(arg_40_1)
	end
	
	print("REPORT! SCALE : ", var_40_0:getScale())
end

local function var_0_2(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = arg_41_0:getField()
	local var_41_1 = arg_41_0:getGameLayer()
	
	if arg_41_1 then
		var_41_1:setPositionX(arg_41_1)
	end
	
	if arg_41_2 then
		var_41_1:setPositionY(arg_41_2)
	end
	
	if arg_41_3 then
		var_41_0:setViewPortPosition(arg_41_3)
		var_41_0:updateViewport()
	end
	
	if not arg_41_4 then
		print(var_0_0(var_41_1:getPositionX(), var_41_1:getPositionY(), var_41_0:getViewPortPosition()))
	end
end

function bg_zoom_position(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = UnitZoom:getUIBackground()
	
	if not var_42_0 then
		Log.e("CHECK UNIT ZOOM OPEN")
		
		return 
	end
	
	var_0_2(var_42_0, -arg_42_0, -arg_42_1, arg_42_2, true)
	
	local var_42_1 = var_42_0:getGameLayer()
	local var_42_2 = var_42_0:getField()
	
	print(var_0_0(var_42_1:getPositionX() * -1, var_42_1:getPositionY() * -1, var_42_2:getViewPortPosition()))
end

function bg_zoom_scale(arg_43_0)
	local var_43_0 = UnitZoom:getUIBackground()
	
	if not var_43_0 then
		Log.e("CHECK UNIT ZOOM OPEN")
		
		return 
	end
	
	var_0_1(var_43_0, arg_43_0)
end

function bg_hero_position(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = UnitMain:getUIBackground()
	
	if not var_44_0 then
		Log.e("CHECK UNIT MAIN OPEN")
		
		return 
	end
	
	var_0_2(var_44_0, arg_44_0, arg_44_1, arg_44_2)
end

function bg_hero_scale(arg_45_0)
	local var_45_0 = UnitMain:getUIBackground()
	
	if not var_45_0 then
		Log.e("CHECK UNIT MAIN OPEN")
		
		return 
	end
	
	var_0_1(var_45_0, arg_45_0)
end

function bg_pet_position(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = PetHouse:getUIBackground()
	
	if not var_46_0 then
		Log.e("CHECK PET HOUSE OPEN")
	end
	
	var_0_2(var_46_0, arg_46_0, arg_46_1, arg_46_2)
end

function bg_pet_scale(arg_47_0)
	local var_47_0 = PetHouse:getUIBackground()
	
	if not var_47_0 then
		Log.e("CHECK PET HOUSE OPEN")
		
		return 
	end
	
	var_0_1(var_47_0, arg_47_0)
end
