CustomProfileCard.bg = {}

function CustomProfileCard.bg.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.parent = arg_1_1.parent
	
	local var_1_0 = load_control("wnd/profile_custom_bg.csb")
	
	arg_1_0.crop = var_1_0:getChildByName("n_crop")
	arg_1_0.bg = var_1_0:getChildByName("n_bg")
	
	arg_1_0.bg:setTransformParent(var_1_0)
	arg_1_0:load(arg_1_1)
	arg_1_0:createBg(arg_1_1)
	
	local var_1_1 = arg_1_0.parent:getWnd()
	
	if arg_1_0.parent and get_cocos_refid(var_1_1) then
		local var_1_2 = arg_1_1.type or arg_1_0.parent:convertNumberToType(arg_1_1.load_data[1])
		
		arg_1_0.layer_wnd = CustomProfileCard:createParentLayerNode(var_1_2)
		
		if get_cocos_refid(arg_1_0.layer_wnd) then
			var_1_0:setAnchorPoint(0.5, 0)
			var_1_0:setPosition(0, 0)
			arg_1_0.layer_wnd:addChild(var_1_0)
		end
		
		local var_1_3 = var_1_1:getChildByName("n_edit_on")
		
		if get_cocos_refid(var_1_3) then
			var_1_3:addChild(arg_1_0.layer_wnd)
		end
	end
	
	arg_1_0.layer_wnd:setLocalZOrder(arg_1_0.vars.order)
end

function CustomProfileCard.bg.delete(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.layer_wnd) or not get_cocos_refid(arg_2_0.bg) or not get_cocos_refid(arg_2_0.crop) then
		return 
	end
	
	if not arg_2_0.edit or not get_cocos_refid(arg_2_0.edit.bg_area) or not get_cocos_refid(arg_2_0.edit.area_wnd) or not get_cocos_refid(arg_2_0.edit.btn_select_move) then
		return 
	end
	
	arg_2_0.parent = nil
	arg_2_0.vars = nil
	
	arg_2_0.layer_wnd:removeFromParent()
	arg_2_0.edit.bg_area:removeFromParent()
	arg_2_0.edit.area_wnd:removeFromParent()
	arg_2_0.edit.btn_select_move:removeFromParent()
	
	arg_2_0.edit = nil
end

function CustomProfileCard.bg.load(arg_3_0, arg_3_1)
	if table.empty(arg_3_1.load_data) then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.order = arg_3_1.order
	arg_3_0.vars.type = arg_3_0.parent:convertNumberToType(arg_3_1.load_data[1]) or "bg"
	arg_3_0.vars.id = arg_3_1.load_data[2]
	arg_3_0.vars.bg_pos = table.copyElement(arg_3_1.load_data[3], {
		"x",
		"y"
	})
	arg_3_0.vars.crop_pos = table.copyElement(arg_3_1.load_data[4], {
		"x",
		"y"
	})
	arg_3_0.vars.crop_size = table.copyElement(arg_3_1.load_data[5], {
		"w",
		"h"
	})
	arg_3_0.vars.is_illust = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[6])
	arg_3_0.vars.is_visible = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[7])
	arg_3_0.vars.is_lock = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[8])
end

function CustomProfileCard.bg.save(arg_4_0)
	if not arg_4_0.vars then
		return nil
	end
	
	local var_4_0 = {
		arg_4_0.parent:convertTypeToNumber(arg_4_0.vars.type),
		arg_4_0.vars.id,
		(table.copyElement(arg_4_0.vars.bg_pos, {
			"x",
			"y"
		}))
	}
	
	var_4_0[3].x = math.floor(var_4_0[3].x * 10) / 10
	var_4_0[3].y = math.floor(var_4_0[3].y * 10) / 10
	var_4_0[4] = table.copyElement(arg_4_0.vars.crop_pos, {
		"x",
		"y"
	})
	var_4_0[4].x = math.floor(var_4_0[4].x * 10) / 10
	var_4_0[4].y = math.floor(var_4_0[4].y * 10) / 10
	var_4_0[5] = table.copyElement(arg_4_0.vars.crop_size, {
		"w",
		"h"
	})
	var_4_0[5].w = math.floor(var_4_0[5].w * 10) / 10
	var_4_0[5].h = math.floor(var_4_0[5].h * 10) / 10
	var_4_0[6] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_illust)
	var_4_0[7] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_visible)
	var_4_0[8] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_lock)
	
	return var_4_0
end

function CustomProfileCard.bg.initDB(arg_5_0, arg_5_1)
	if arg_5_0.vars or not get_cocos_refid(arg_5_0.crop) then
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.order = arg_5_1.order
	arg_5_0.vars.type = arg_5_1.type or "bg"
	arg_5_0.vars.id = arg_5_1.id
	arg_5_0.vars.bg_pos = {}
	arg_5_0.vars.bg_pos.x = math.floor(arg_5_0.bg:getPositionX() * 10) / 10
	arg_5_0.vars.bg_pos.y = math.floor(arg_5_0.bg:getPositionY() * 10) / 10
	arg_5_0.vars.crop_pos = {}
	arg_5_0.vars.crop_pos.x = math.floor(arg_5_0.crop:getPositionX() * 10) / 10
	arg_5_0.vars.crop_pos.y = math.floor(arg_5_0.crop:getPositionY() * 10) / 10
	
	local var_5_0 = arg_5_0.crop:getContentSize()
	
	arg_5_0.vars.crop_size = {}
	arg_5_0.vars.crop_size.w = math.floor(var_5_0.width * 10) / 10
	arg_5_0.vars.crop_size.h = math.floor(var_5_0.height * 10) / 10
	arg_5_0.vars.is_illust = arg_5_1.is_illust
	arg_5_0.vars.is_visible = arg_5_0.crop:isVisible()
	arg_5_0.vars.is_lock = false
end

function CustomProfileCard.bg.createBg(arg_6_0, arg_6_1)
	if not get_cocos_refid(arg_6_0.crop) or not get_cocos_refid(arg_6_0.bg) then
		return 
	end
	
	local var_6_0 = arg_6_1.id or arg_6_1.load_data[2]
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1
	local var_6_2
	local var_6_3 = arg_6_1.is_illust
	
	if var_6_3 == nil then
		var_6_3 = arg_6_0.parent:convertNumberToBoolen(arg_6_1.load_data[6])
	end
	
	if var_6_3 then
		local var_6_4 = DBT("dic_data_illust", var_6_0, {
			"illust",
			"thumbnail"
		})
		
		if table.empty(var_6_4) then
			return 
		end
		
		if string.find(var_6_4.illust, ".cfx") then
			local var_6_5 = 1580
			local var_6_6 = 720
			local var_6_7 = string.sub(var_6_4.illust, 1, string.find(var_6_4.illust, ".cfx") - 1)
			local var_6_8 = DB("profile_spine_illust_resolution", var_6_7, {
				"resolution"
			})
			
			if var_6_8 then
				local var_6_9 = string.split(var_6_8, ",")
				
				if not table.empty(var_6_9) then
					var_6_5 = var_6_9[1]
					var_6_6 = var_6_9[2]
				end
			end
			
			local var_6_10 = arg_6_0.bg:getPositionX()
			local var_6_11 = arg_6_0.bg:getPositionY()
			
			if arg_6_0.bg then
				arg_6_0.bg:removeFromParent()
				
				arg_6_0.bg = ccui.Layout:create()
				
				arg_6_0.bg:setName("n_bg")
				arg_6_0.bg:setAnchorPoint(0.5, 0.5)
				arg_6_0.bg:setContentSize(var_6_5, var_6_6)
				arg_6_0.bg:setPosition(var_6_10, var_6_11)
				arg_6_0.bg:setClippingEnabled(true)
				
				local var_6_12 = CACHE:getEffect(var_6_4.illust, "effect")
				
				var_6_12:setName("n_spine_illust")
				
				arg_6_0.bg.n_spine_illust = var_6_12
				var_6_2 = {
					x = var_6_10,
					y = var_6_11,
					effect = var_6_12,
					fn = var_6_4.illust,
					layer = arg_6_0.bg
				}
				
				arg_6_0.crop:addChild(arg_6_0.bg)
				
				local var_6_13 = arg_6_0.crop:getParent()
				
				arg_6_0.bg:setTransformParent(var_6_13)
			end
		else
			if var_6_4.thumbnail then
				var_6_1 = "item/art/" .. var_6_4.thumbnail .. ".png"
			else
				var_6_1 = UIUtil:getIllustPath("story/bg/", var_6_4.illust)
			end
			
			arg_6_0.bg:initWithFile(var_6_1)
		end
	else
		local var_6_14 = DB("item_material_profile", var_6_0, {
			"material_id"
		})
		local var_6_15 = DBT("item_material", var_6_14, {
			"ma_type",
			"ma_type2",
			"icon"
		})
		
		if table.empty(var_6_15) then
			return 
		end
		
		local var_6_16 = var_6_15.ma_type .. "/" .. var_6_15.ma_type2 .. "/" .. var_6_15.icon .. ".png"
		
		arg_6_0.bg:initWithFile(var_6_16)
	end
	
	local var_6_17 = arg_6_0.bg:getContentSize()
	
	if var_6_3 then
		local var_6_18 = 558 / var_6_17.height
		
		var_6_17.width = var_6_17.width * var_6_18
		var_6_17.height = var_6_17.height * var_6_18
		
		if var_6_2 and get_cocos_refid(arg_6_0.bg.n_spine_illust) then
			var_6_2.scale = var_6_18
			
			EffectManager:EffectPlay(var_6_2)
			arg_6_0.bg.n_spine_illust:setPosition(var_6_17.width * 0.5, var_6_17.height * 0.5)
			arg_6_0.bg.n_spine_illust:update(1)
		end
	end
	
	arg_6_0.bg:setContentSize(var_6_17.width, var_6_17.height)
	arg_6_0:initDB(arg_6_1)
	arg_6_0.bg:setPositionX(arg_6_0.vars.bg_pos.x)
	arg_6_0.bg:setPositionY(arg_6_0.vars.bg_pos.y)
	arg_6_0.crop:setPositionX(arg_6_0.vars.crop_pos.x)
	arg_6_0.crop:setPositionY(arg_6_0.vars.crop_pos.y)
	arg_6_0.crop:setContentSize(arg_6_0.vars.crop_size.w, arg_6_0.vars.crop_size.h)
	arg_6_0.crop:setVisible(arg_6_0.vars.is_visible)
	
	if arg_6_1.is_edit_mode then
		arg_6_0:createEditBox()
	end
end

function CustomProfileCard.bg.setOrder(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_0.vars.order = arg_7_1
	
	if get_cocos_refid(arg_7_0.layer_wnd) then
		arg_7_0.layer_wnd:setLocalZOrder(arg_7_0.vars.order)
	end
	
	if arg_7_0.edit and get_cocos_refid(arg_7_0.edit.area_wnd) and get_cocos_refid(arg_7_0.edit.btn_select_move) then
		arg_7_0.edit.area_wnd:setLocalZOrder(arg_7_0.vars.order)
		arg_7_0.edit.btn_select_move:setLocalZOrder(arg_7_0.vars.order)
	end
end

function CustomProfileCard.bg.getOrder(arg_8_0)
	if not arg_8_0.vars then
		return nil
	end
	
	return arg_8_0.vars.order
end

function CustomProfileCard.bg.getType(arg_9_0)
	if not arg_9_0.vars then
		return nil
	end
	
	return arg_9_0.vars.type or "bg"
end

function CustomProfileCard.bg.getId(arg_10_0)
	if not arg_10_0.vars then
		return nil
	end
	
	return arg_10_0.vars.id
end

function CustomProfileCard.bg.isIllust(arg_11_0)
	if not arg_11_0.vars then
		return false
	end
	
	return arg_11_0.vars.is_illust
end

function CustomProfileCard.bg.isVisible(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.crop) then
		return false
	end
	
	return arg_12_0.vars.is_visible or arg_12_0.crop:isVisible()
end

function CustomProfileCard.bg.isLock(arg_13_0)
	if not arg_13_0.vars then
		return false
	end
	
	return arg_13_0.vars.is_lock
end

function CustomProfileCard.bg.createEditBox(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.crop) or not get_cocos_refid(arg_14_0.bg) then
		return 
	end
	
	local var_14_0 = arg_14_0.parent:getWnd()
	
	arg_14_0.edit = {}
	arg_14_0.edit.bg_area = load_control("wnd/profile_custom_bg_area.csb")
	
	arg_14_0.edit.bg_area:setName("n_edit_" .. arg_14_0.vars.type)
	var_14_0:getChildByName("n_edit_back"):addChild(arg_14_0.edit.bg_area)
	
	local var_14_1 = arg_14_0.bg:getContentSize()
	local var_14_2 = arg_14_0.bg:getPositionX()
	local var_14_3 = arg_14_0.bg:getPositionY()
	local var_14_4 = arg_14_0.edit.bg_area:getChildByName("img_area")
	
	var_14_4:setPositionX(var_14_2)
	var_14_4:setPositionY(var_14_3)
	var_14_4:setContentSize(var_14_1)
	
	local var_14_5 = var_14_4:getChildByName("btn_area")
	
	var_14_5:setPositionX(var_14_1.width * 0.5)
	var_14_5:setPositionY(var_14_1.height * 0.5)
	var_14_5:setContentSize(var_14_4:getContentSize())
	
	arg_14_0.edit.btn_bg_move = var_14_5
	arg_14_0.edit.min_size = {
		w = 74,
		h = 74
	}
	arg_14_0.edit.max_size = {
		w = 378,
		h = 558
	}
	
	local var_14_6 = arg_14_0.crop:getContentSize()
	local var_14_7 = var_14_0:getChildByName("n_edit_boxes")
	
	arg_14_0.edit.area_wnd = cc.DrawNode:create(1)
	
	arg_14_0.edit.area_wnd:setName("n_edit_area")
	arg_14_0.edit.area_wnd:setAnchorPoint(0.5, 0.5)
	arg_14_0.edit.area_wnd:setPosition(var_14_6.width * 0.5, var_14_6.height * 0.5)
	arg_14_0.edit.area_wnd:setContentSize(var_14_6.width, var_14_6.height)
	arg_14_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_14_6.width, var_14_6.height), cc.c4f(1, 1, 1, 1))
	arg_14_0.edit.area_wnd:setTransformParent(arg_14_0.crop)
	arg_14_0.edit.area_wnd:setLocalZOrder(arg_14_0.vars.order)
	var_14_7:addChild(arg_14_0.edit.area_wnd)
	
	local var_14_8 = var_14_0:getChildByName("n_select_boxes")
	
	arg_14_0.edit.btn_select_move = ccui.Button:create()
	
	arg_14_0.edit.btn_select_move:setName("btn_select_move")
	arg_14_0.edit.btn_select_move:setAnchorPoint(0.5, 0.5)
	arg_14_0.edit.btn_select_move:setTouchEnabled(true)
	arg_14_0.edit.btn_select_move:ignoreContentAdaptWithSize(false)
	arg_14_0.edit.btn_select_move:setPosition(var_14_6.width * 0.5, var_14_6.height * 0.5)
	arg_14_0.edit.btn_select_move:setContentSize(var_14_6.width, var_14_6.height)
	arg_14_0.edit.btn_select_move:setTransformParent(arg_14_0.edit.area_wnd)
	arg_14_0.edit.btn_select_move:setLocalZOrder(arg_14_0.vars.order)
	arg_14_0.edit.btn_select_move:setVisible(not arg_14_0.vars.is_lock)
	var_14_8:addChild(arg_14_0.edit.btn_select_move)
	
	local var_14_9 = load_control("wnd/custom_edit_control.csb")
	
	var_14_9:setName("n_crop_btns")
	arg_14_0.edit.area_wnd:addChild(var_14_9)
	if_set_visible(var_14_9, "n_crop", true)
	if_set_visible(var_14_9, "n_side", false)
	if_set_visible(var_14_9, "n_fixed", true)
	if_set_visible(var_14_9, "n_multi", false)
	
	local var_14_10 = var_14_9:getChildByName("n_crop")
	
	if_set_visible(var_14_10, "n_ratio_135", true)
	if_set_visible(var_14_10, "n_ratio_315", true)
	if_set_visible(var_14_10, "n_side_north", true)
	if_set_visible(var_14_10, "n_side_south", true)
	if_set_visible(var_14_10, "n_side_west", true)
	if_set_visible(var_14_10, "n_side_east", true)
	
	local var_14_11 = 0
	local var_14_12 = 0
	
	arg_14_0.edit.btn_corner_scale_left = var_14_10:getChildByName("n_ratio_135")
	
	if get_cocos_refid(arg_14_0.edit.btn_corner_scale_left) then
		local var_14_13 = arg_14_0.edit.btn_corner_scale_left:getPositionX()
		local var_14_14 = arg_14_0.edit.btn_corner_scale_left:getPositionY()
		
		arg_14_0.edit.btn_corner_scale_left.offset_pos_x = var_14_13
		arg_14_0.edit.btn_corner_scale_left.offset_pos_y = var_14_14
		
		arg_14_0.edit.btn_corner_scale_left:setPosition(var_14_13, var_14_14 + var_14_6.height)
	end
	
	arg_14_0.edit.btn_corner_scale_right = var_14_10:getChildByName("n_ratio_315")
	
	if get_cocos_refid(arg_14_0.edit.btn_corner_scale_right) then
		local var_14_15 = arg_14_0.edit.btn_corner_scale_right:getPositionX()
		local var_14_16 = arg_14_0.edit.btn_corner_scale_right:getPositionY()
		
		arg_14_0.edit.btn_corner_scale_right.offset_pos_x = var_14_15
		arg_14_0.edit.btn_corner_scale_right.offset_pos_y = var_14_16
		
		arg_14_0.edit.btn_corner_scale_right:setPosition(var_14_15 + var_14_6.width, var_14_16)
	end
	
	arg_14_0.edit.btn_scale_y_top = var_14_10:getChildByName("n_side_north")
	
	if get_cocos_refid(arg_14_0.edit.btn_scale_y_top) then
		local var_14_17 = arg_14_0.edit.btn_scale_y_top:getPositionX()
		local var_14_18 = arg_14_0.edit.btn_scale_y_top:getPositionY()
		
		arg_14_0.edit.btn_scale_y_top.offset_pos_x = var_14_17
		arg_14_0.edit.btn_scale_y_top.offset_pos_y = var_14_18
		
		arg_14_0.edit.btn_scale_y_top:setPosition(var_14_17 + var_14_6.width * 0.5, var_14_18 + var_14_6.height)
	end
	
	arg_14_0.edit.btn_scale_y_bottom = var_14_10:getChildByName("n_side_south")
	
	if get_cocos_refid(arg_14_0.edit.btn_scale_y_bottom) then
		local var_14_19 = arg_14_0.edit.btn_scale_y_bottom:getPositionX()
		local var_14_20 = arg_14_0.edit.btn_scale_y_bottom:getPositionY()
		
		arg_14_0.edit.btn_scale_y_bottom.offset_pos_x = var_14_19
		arg_14_0.edit.btn_scale_y_bottom.offset_pos_y = var_14_20
		
		arg_14_0.edit.btn_scale_y_bottom:setPosition(var_14_19 + var_14_6.width * 0.5, var_14_20)
	end
	
	arg_14_0.edit.btn_scale_x_left = var_14_10:getChildByName("n_side_west")
	
	if get_cocos_refid(arg_14_0.edit.btn_scale_x_left) then
		local var_14_21 = arg_14_0.edit.btn_scale_x_left:getPositionX()
		local var_14_22 = arg_14_0.edit.btn_scale_x_left:getPositionY()
		
		arg_14_0.edit.btn_scale_x_left.offset_pos_x = var_14_21
		arg_14_0.edit.btn_scale_x_left.offset_pos_y = var_14_22
		
		arg_14_0.edit.btn_scale_x_left:setPosition(var_14_21, var_14_22 + var_14_6.height * 0.5)
	end
	
	arg_14_0.edit.btn_scale_x_right = var_14_10:getChildByName("n_side_east")
	
	if get_cocos_refid(arg_14_0.edit.btn_scale_x_right) then
		local var_14_23 = arg_14_0.edit.btn_scale_x_right:getPositionX()
		local var_14_24 = arg_14_0.edit.btn_scale_x_right:getPositionY()
		
		arg_14_0.edit.btn_scale_x_right.offset_pos_x = var_14_23
		arg_14_0.edit.btn_scale_x_right.offset_pos_y = var_14_24
		
		arg_14_0.edit.btn_scale_x_right:setPosition(var_14_23 + var_14_6.width, var_14_24 + var_14_6.height * 0.5)
	end
	
	local var_14_25 = var_14_9:getChildByName("n_fixed")
	
	if_set_visible(var_14_25, "n_move", true)
	if_set_visible(var_14_25, "n_off", true)
	
	arg_14_0.edit.btn_move = var_14_25:getChildByName("n_move")
	
	if get_cocos_refid(arg_14_0.edit.btn_move) then
		arg_14_0.edit.btn_move:setPosition(0, 0)
	end
	
	arg_14_0.edit.btn_delete = var_14_25:getChildByName("n_off")
	
	if get_cocos_refid(arg_14_0.edit.btn_delete) then
		arg_14_0.edit.btn_delete:setPosition(var_14_6.width, var_14_6.height)
	end
	
	arg_14_0:activeEditorBox(false)
	arg_14_0:addTouchEventListener()
end

function CustomProfileCard.bg.activeEditorBox(arg_15_0, arg_15_1)
	if not arg_15_0.edit or not get_cocos_refid(arg_15_0.edit.area_wnd) or not get_cocos_refid(arg_15_0.edit.bg_area) or not get_cocos_refid(arg_15_0.edit.area_wnd) then
		return 
	end
	
	arg_15_0.edit.bg_area:setVisible(arg_15_1)
	arg_15_0.edit.area_wnd:setVisible(arg_15_1)
end

function CustomProfileCard.bg.renderEditorBox(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.crop) then
		return 
	end
	
	if not arg_16_0.edit or not get_cocos_refid(arg_16_0.edit.area_wnd) then
		return 
	end
	
	local var_16_0 = arg_16_0.crop:getContentSize()
	
	arg_16_0.edit.area_wnd:setPosition(var_16_0.width * 0.5, var_16_0.height * 0.5)
	arg_16_0.edit.area_wnd:setContentSize(var_16_0.width, var_16_0.height)
	arg_16_0.edit.area_wnd:clear()
	arg_16_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_16_0.width, var_16_0.height), cc.c4f(1, 1, 1, 1))
	arg_16_0.edit.area_wnd:visit()
	arg_16_0.edit.btn_select_move:setPosition(var_16_0.width * 0.5, var_16_0.height * 0.5)
	arg_16_0.edit.btn_select_move:setContentSize(var_16_0.width, var_16_0.height)
	
	local var_16_1 = 0
	local var_16_2 = 0
	
	if get_cocos_refid(arg_16_0.edit.btn_corner_scale_left) then
		local var_16_3 = arg_16_0.edit.btn_corner_scale_left.offset_pos_x
		local var_16_4 = arg_16_0.edit.btn_corner_scale_left.offset_pos_y
		
		arg_16_0.edit.btn_corner_scale_left:setPosition(var_16_3, var_16_4 + var_16_0.height)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_corner_scale_right) then
		local var_16_5 = arg_16_0.edit.btn_corner_scale_right.offset_pos_x
		local var_16_6 = arg_16_0.edit.btn_corner_scale_right.offset_pos_y
		
		arg_16_0.edit.btn_corner_scale_right:setPosition(var_16_5 + var_16_0.width, var_16_6)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_scale_y_top) then
		local var_16_7 = arg_16_0.edit.btn_scale_y_top.offset_pos_x
		local var_16_8 = arg_16_0.edit.btn_scale_y_top.offset_pos_y
		
		arg_16_0.edit.btn_scale_y_top:setPosition(var_16_7 + var_16_0.width * 0.5, var_16_8 + var_16_0.height)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_scale_y_bottom) then
		local var_16_9 = arg_16_0.edit.btn_scale_y_bottom.offset_pos_x
		local var_16_10 = arg_16_0.edit.btn_scale_y_bottom.offset_pos_y
		
		arg_16_0.edit.btn_scale_y_bottom:setPosition(var_16_9 + var_16_0.width * 0.5, var_16_10)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_scale_x_left) then
		local var_16_11 = arg_16_0.edit.btn_scale_x_left.offset_pos_x
		local var_16_12 = arg_16_0.edit.btn_scale_x_left.offset_pos_y
		
		arg_16_0.edit.btn_scale_x_left:setPosition(var_16_11, var_16_12 + var_16_0.height * 0.5)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_scale_x_right) then
		local var_16_13 = arg_16_0.edit.btn_scale_x_right.offset_pos_x
		local var_16_14 = arg_16_0.edit.btn_scale_x_right.offset_pos_y
		
		arg_16_0.edit.btn_scale_x_right:setPosition(var_16_13 + var_16_0.width, var_16_14 + var_16_0.height * 0.5)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_move) then
		arg_16_0.edit.btn_move:setPosition(0, 0)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_delete) then
		arg_16_0.edit.btn_delete:setPosition(var_16_0.width, var_16_0.height)
	end
end

function CustomProfileCard.bg.addTouchEventListener(arg_17_0)
	if not arg_17_0.edit or not get_cocos_refid(arg_17_0.edit.area_wnd) then
		return 
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_bg_move) then
		arg_17_0.edit.btn_bg_move:addTouchEventListener(function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			arg_17_0:bgMoveEventHandler(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_select_move) then
		arg_17_0.edit.btn_select_move:addTouchEventListener(function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			arg_17_0:bgMoveEventHandler(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_move) then
		arg_17_0.edit.btn_move:getChildByName("btn"):addTouchEventListener(function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
			arg_17_0:cropMoveEventHandler(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_delete) then
		arg_17_0.edit.btn_delete:getChildByName("btn"):addTouchEventListener(function(arg_21_0, arg_21_1)
			arg_17_0:bgRemoveEventHandler(arg_21_0, arg_21_1)
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_scale_y_top) then
		arg_17_0.edit.btn_scale_y_top:getChildByName("btn"):addTouchEventListener(function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			arg_17_0:cropScaleYEventHandler(arg_22_0, arg_22_1, arg_22_2, arg_22_3, "top")
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_scale_y_bottom) then
		arg_17_0.edit.btn_scale_y_bottom:getChildByName("btn"):addTouchEventListener(function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			arg_17_0:cropScaleYEventHandler(arg_23_0, arg_23_1, arg_23_2, arg_23_3, "bottom")
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_scale_x_left) then
		arg_17_0.edit.btn_scale_x_left:getChildByName("btn"):addTouchEventListener(function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			arg_17_0:cropScaleXEventHandler(arg_24_0, arg_24_1, arg_24_2, arg_24_3, "left")
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_scale_x_right) then
		arg_17_0.edit.btn_scale_x_right:getChildByName("btn"):addTouchEventListener(function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			arg_17_0:cropScaleXEventHandler(arg_25_0, arg_25_1, arg_25_2, arg_25_3, "right")
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_corner_scale_left) then
		arg_17_0.edit.btn_corner_scale_left:getChildByName("btn"):addTouchEventListener(function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			arg_17_0:cropCornerScaleEventHandler(arg_26_0, arg_26_1, arg_26_2, arg_26_3, "left")
		end)
	end
	
	if get_cocos_refid(arg_17_0.edit.btn_corner_scale_right) then
		arg_17_0.edit.btn_corner_scale_right:getChildByName("btn"):addTouchEventListener(function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			arg_17_0:cropCornerScaleEventHandler(arg_27_0, arg_27_1, arg_27_2, arg_27_3, "right")
		end)
	end
	
	arg_17_0.edit.touch_bg_move_btn_count = 0
	arg_17_0.edit.touch_crop_move_btn_count = 0
	arg_17_0.edit.touch_corner_scale_btn_count = 0
	arg_17_0.edit.touch_scale_x_btn_count = 0
	arg_17_0.edit.touch_scale_y_btn_count = 0
end

function CustomProfileCard.bg.bgMoveEventHandler(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.bg) or not get_cocos_refid(arg_28_1) then
		return 
	end
	
	if not arg_28_0.edit or not get_cocos_refid(arg_28_0.edit.bg_area) or not get_cocos_refid(arg_28_0.edit.area_wnd) then
		return 
	end
	
	if arg_28_0.vars.is_lock then
		return 
	end
	
	if arg_28_0.edit.is_crop_move or arg_28_0.edit.is_crop_corner_scale or arg_28_0.edit.is_crop_scale_x or arg_28_0.edit.is_crop_scale_y then
		return 
	end
	
	if arg_28_2 == 0 then
		arg_28_0.edit.touch_bg_move_btn_count = arg_28_0.edit.touch_bg_move_btn_count + 1
		
		if arg_28_0.edit.touch_bg_move_btn_count == 1 then
			if not CustomProfileCardEditor:isFocusLayer(arg_28_0) and arg_28_1:getName() == "btn_select_move" then
				CustomProfileCardEditor:setFocusLayer(arg_28_0)
			end
			
			arg_28_0.edit.is_bg_move = true
			arg_28_0.edit.touch_begin_pos = {
				x = arg_28_3,
				y = arg_28_4
			}
			
			local var_28_0 = arg_28_0.edit.bg_area:getChildByName("img_area")
			
			arg_28_0.edit.origin_bg_area_pos = {
				x = var_28_0:getPositionX(),
				y = var_28_0:getPositionY()
			}
		end
	elseif arg_28_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_28_0) then
			return 
		end
		
		if table.empty(arg_28_0.edit.touch_begin_pos) or table.empty(arg_28_0.edit.origin_bg_area_pos) or not arg_28_0.edit.is_bg_move or arg_28_0.edit.touch_bg_move_btn_count ~= 1 then
			return 
		end
		
		arg_28_0.edit.is_bg_move = true
		arg_28_0.edit.touch_move_pos = {
			x = arg_28_3,
			y = arg_28_4
		}
		
		local var_28_1 = arg_28_0.edit.touch_move_pos.x - arg_28_0.edit.touch_begin_pos.x
		local var_28_2 = arg_28_0.edit.touch_move_pos.y - arg_28_0.edit.touch_begin_pos.y
		
		arg_28_0:setBgPosition(arg_28_0.edit.origin_bg_area_pos.x + var_28_1, arg_28_0.edit.origin_bg_area_pos.y + var_28_2)
	else
		arg_28_0.edit.touch_bg_move_btn_count = arg_28_0.edit.touch_bg_move_btn_count - 1
		
		if arg_28_0.edit.touch_bg_move_btn_count <= 0 then
			if not table.empty(arg_28_0.edit.origin_bg_area_pos) and not table.empty(arg_28_0.vars.bg_pos) and (math.abs(arg_28_0.edit.origin_bg_area_pos.x - arg_28_0.vars.bg_pos.x) >= 0.1 or math.abs(arg_28_0.edit.origin_bg_area_pos.y - arg_28_0.vars.bg_pos.y) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_28_0,
					undo_func = bind_func(arg_28_0.setBgPosition, arg_28_0, arg_28_0.edit.origin_bg_area_pos.x, arg_28_0.edit.origin_bg_area_pos.y),
					redo_func = bind_func(arg_28_0.setBgPosition, arg_28_0, arg_28_0.vars.bg_pos.x, arg_28_0.vars.bg_pos.y)
				}, true)
			end
			
			arg_28_0.edit.touch_bg_move_btn_count = 0
			arg_28_0.edit.is_bg_move = false
			arg_28_0.edit.touch_begin_pos = nil
			arg_28_0.edit.origin_bg_area_pos = nil
			arg_28_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.bg.cropMoveEventHandler(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.crop) or not get_cocos_refid(arg_29_1) then
		return 
	end
	
	if not arg_29_0.edit or not get_cocos_refid(arg_29_0.edit.area_wnd) then
		return 
	end
	
	if arg_29_0.edit.is_bg_move or arg_29_0.edit.is_crop_corner_scale or arg_29_0.edit.is_crop_scale_x or arg_29_0.edit.is_crop_scale_y then
		return 
	end
	
	if arg_29_2 == 0 then
		arg_29_0.edit.touch_crop_move_btn_count = arg_29_0.edit.touch_crop_move_btn_count + 1
		
		if arg_29_0.edit.touch_crop_move_btn_count == 1 then
			arg_29_0.edit.is_crop_move = true
			arg_29_0.edit.touch_begin_pos = {
				x = arg_29_3,
				y = arg_29_4
			}
			arg_29_0.edit.origin_crop_pos = {
				x = arg_29_0.crop:getPositionX(),
				y = arg_29_0.crop:getPositionY()
			}
		end
	elseif arg_29_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_29_0) then
			return 
		end
		
		if table.empty(arg_29_0.edit.touch_begin_pos) or table.empty(arg_29_0.edit.origin_crop_pos) or not arg_29_0.edit.is_crop_move or arg_29_0.edit.touch_crop_move_btn_count ~= 1 then
			return 
		end
		
		arg_29_0.edit.is_crop_move = true
		arg_29_0.edit.touch_move_pos = {
			x = arg_29_3,
			y = arg_29_4
		}
		
		local var_29_0 = arg_29_0.edit.touch_move_pos.x - arg_29_0.edit.touch_begin_pos.x
		local var_29_1 = arg_29_0.edit.touch_move_pos.y - arg_29_0.edit.touch_begin_pos.y
		
		arg_29_0:setCropPosition(arg_29_0.edit.origin_crop_pos.x + var_29_0, arg_29_0.edit.origin_crop_pos.y + var_29_1)
	else
		arg_29_0.edit.touch_crop_move_btn_count = arg_29_0.edit.touch_crop_move_btn_count - 1
		
		if arg_29_0.edit.touch_crop_move_btn_count <= 0 then
			if not table.empty(arg_29_0.edit.origin_crop_pos) and not table.empty(arg_29_0.vars.crop_pos) and (math.abs(arg_29_0.edit.origin_crop_pos.x - arg_29_0.vars.crop_pos.x) >= 0.1 or math.abs(arg_29_0.edit.origin_crop_pos.y - arg_29_0.vars.crop_pos.y) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_29_0,
					undo_func = bind_func(arg_29_0.setCropPosition, arg_29_0, arg_29_0.edit.origin_crop_pos.x, arg_29_0.edit.origin_crop_pos.y),
					redo_func = bind_func(arg_29_0.setCropPosition, arg_29_0, arg_29_0.vars.crop_pos.x, arg_29_0.vars.crop_pos.y)
				}, true)
			end
			
			arg_29_0.edit.touch_crop_move_btn_count = 0
			arg_29_0.edit.is_crop_move = false
			arg_29_0.edit.touch_begin_pos = nil
			arg_29_0.edit.origin_crop_pos = nil
			arg_29_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.bg.bgRemoveEventHandler(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_0.parent or not arg_30_0.vars or not get_cocos_refid(arg_30_0.layer_wnd) or not get_cocos_refid(arg_30_1) then
		return 
	end
	
	if not arg_30_0.edit or not get_cocos_refid(arg_30_0.edit.area_wnd) then
		return 
	end
	
	if arg_30_2 == 2 or arg_30_2 == 3 then
		arg_30_0.parent:deleteLayer({
			order = arg_30_0.vars.order,
			type = arg_30_0.vars.type
		})
	end
end

function CustomProfileCard.bg.cropCornerScaleEventHandler(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.crop) or not get_cocos_refid(arg_31_1) or not arg_31_5 then
		return 
	end
	
	if not arg_31_0.edit or not get_cocos_refid(arg_31_0.edit.area_wnd) then
		return 
	end
	
	if arg_31_0.edit.is_bg_move or arg_31_0.edit.is_crop_move or arg_31_0.edit.is_crop_scale_x or arg_31_0.edit.is_crop_scale_y then
		return 
	end
	
	if arg_31_2 == 0 then
		arg_31_0.edit.touch_corner_scale_btn_count = arg_31_0.edit.touch_corner_scale_btn_count + 1
		
		if arg_31_0.edit.touch_corner_scale_btn_count == 1 then
			arg_31_0.edit.is_crop_corner_scale = true
			arg_31_0.edit.touch_begin_pos = arg_31_1:convertToWorldSpace({
				x = arg_31_1:getPositionX(),
				y = arg_31_1:getPositionY()
			})
			
			local var_31_0 = arg_31_0.crop:getContentSize()
			local var_31_1 = arg_31_0.crop:getAnchorPoint()
			local var_31_2 = {
				x = var_31_0.width * var_31_1.x,
				y = var_31_0.height * var_31_1.y
			}
			
			arg_31_0.edit.center_pos = arg_31_0.crop:convertToWorldSpace({
				x = var_31_2.x,
				y = var_31_2.y
			})
			arg_31_0.edit.origin_crop_size = var_31_0
		end
	elseif arg_31_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_31_0) then
			return 
		end
		
		if table.empty(arg_31_0.edit.touch_begin_pos) or table.empty(arg_31_0.edit.center_pos) or not arg_31_0.edit.is_crop_corner_scale or arg_31_0.edit.touch_corner_scale_btn_count ~= 1 then
			return 
		end
		
		arg_31_0.edit.is_crop_corner_scale = true
		arg_31_0.edit.touch_move_pos = {
			x = arg_31_3,
			y = arg_31_4
		}
		
		local var_31_3 = arg_31_0.edit.touch_move_pos.x - arg_31_0.edit.touch_begin_pos.x
		local var_31_4 = arg_31_0.edit.touch_move_pos.y - arg_31_0.edit.touch_begin_pos.y
		local var_31_5 = math.atan(var_31_4 / var_31_3)
		local var_31_6 = math.deg(var_31_5)
		
		if var_31_6 < 0 then
			var_31_6 = 360 + var_31_6
		elseif var_31_6 > 360 then
			var_31_6 = var_31_6 - 360
		end
		
		local var_31_7 = arg_31_0.crop:getContentSize()
		local var_31_8 = var_31_7.width
		local var_31_9 = var_31_7.height
		local var_31_10 = 1
		local var_31_11 = math.abs(arg_31_0.edit.touch_move_pos.x - arg_31_0.edit.center_pos.x)
		local var_31_12 = math.abs(arg_31_0.edit.touch_move_pos.y - arg_31_0.edit.center_pos.y)
		
		if arg_31_5 == "left" then
			if var_31_8 <= arg_31_0.edit.min_size.w and var_31_9 <= arg_31_0.edit.min_size.h and arg_31_0.edit.touch_move_pos.x > arg_31_0.edit.center_pos.x and arg_31_0.edit.touch_move_pos.y < arg_31_0.edit.center_pos.y then
				arg_31_0:setCropSize(arg_31_0.edit.min_size.w, arg_31_0.edit.min_size.h)
				
				return 
			end
			
			if arg_31_0.edit.touch_begin_pos.x < arg_31_0.edit.touch_move_pos.x and arg_31_0.edit.touch_begin_pos.y > arg_31_0.edit.touch_move_pos.y and var_31_6 < 360 and var_31_6 > 270 then
				if var_31_12 <= var_31_11 then
					local var_31_13 = var_31_12 * 2 / var_31_9
					local var_31_14 = round(var_31_13, 2)
					
					var_31_9 = var_31_14 * var_31_9
					var_31_8 = var_31_14 * var_31_8
				elseif var_31_11 < var_31_12 then
					local var_31_15 = var_31_11 * 2 / var_31_8
					local var_31_16 = round(var_31_15, 2)
					
					var_31_9 = var_31_16 * var_31_9
					var_31_8 = var_31_16 * var_31_8
				end
			elseif var_31_11 <= var_31_12 then
				local var_31_17 = var_31_12 * 2 / var_31_9
				local var_31_18 = round(var_31_17, 2)
				
				var_31_9 = var_31_18 * var_31_9
				var_31_8 = var_31_18 * var_31_8
			elseif var_31_12 < var_31_11 then
				local var_31_19 = var_31_11 * 2 / var_31_8
				local var_31_20 = round(var_31_19, 2)
				
				var_31_9 = var_31_20 * var_31_9
				var_31_8 = var_31_20 * var_31_8
			end
		elseif arg_31_5 == "right" then
			if var_31_8 <= arg_31_0.edit.min_size.w and var_31_9 <= arg_31_0.edit.min_size.h and arg_31_0.edit.touch_move_pos.x < arg_31_0.edit.center_pos.x and arg_31_0.edit.touch_move_pos.y > arg_31_0.edit.center_pos.y then
				arg_31_0:setCropSize(arg_31_0.edit.min_size.w, arg_31_0.edit.min_size.h)
				
				return 
			end
			
			if arg_31_0.edit.touch_begin_pos.x > arg_31_0.edit.touch_move_pos.x and arg_31_0.edit.touch_begin_pos.y < arg_31_0.edit.touch_move_pos.y and var_31_6 < 360 and var_31_6 > 270 then
				if var_31_12 <= var_31_11 then
					local var_31_21 = var_31_12 * 2 / var_31_9
					local var_31_22 = round(var_31_21, 2)
					
					var_31_9 = var_31_22 * var_31_9
					var_31_8 = var_31_22 * var_31_8
				elseif var_31_11 < var_31_12 then
					local var_31_23 = var_31_11 * 2 / var_31_8
					local var_31_24 = round(var_31_23, 2)
					
					var_31_9 = var_31_24 * var_31_9
					var_31_8 = var_31_24 * var_31_8
				end
			elseif var_31_11 <= var_31_12 then
				local var_31_25 = var_31_12 * 2 / var_31_9
				local var_31_26 = round(var_31_25, 2)
				
				var_31_9 = var_31_26 * var_31_9
				var_31_8 = var_31_26 * var_31_8
			elseif var_31_12 < var_31_11 then
				local var_31_27 = var_31_11 * 2 / var_31_8
				local var_31_28 = round(var_31_27, 2)
				
				var_31_9 = var_31_28 * var_31_9
				var_31_8 = var_31_28 * var_31_8
			end
		end
		
		arg_31_0:setCropSize(var_31_8, var_31_9)
	else
		arg_31_0.edit.touch_corner_scale_btn_count = arg_31_0.edit.touch_corner_scale_btn_count - 1
		
		if arg_31_0.edit.touch_corner_scale_btn_count <= 0 then
			if not table.empty(arg_31_0.edit.origin_crop_size) and not table.empty(arg_31_0.vars.crop_size) and (math.abs(arg_31_0.edit.origin_crop_size.width - arg_31_0.vars.crop_size.w) >= 0.1 or math.abs(arg_31_0.edit.origin_crop_size.height - arg_31_0.vars.crop_size.h) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_31_0,
					undo_func = bind_func(arg_31_0.setCropSize, arg_31_0, arg_31_0.edit.origin_crop_size.width, arg_31_0.edit.origin_crop_size.height),
					redo_func = bind_func(arg_31_0.setCropSize, arg_31_0, arg_31_0.vars.crop_size.w, arg_31_0.vars.crop_size.h)
				}, true)
			end
			
			arg_31_0.edit.touch_corner_scale_btn_count = 0
			arg_31_0.edit.is_crop_corner_scale = false
			arg_31_0.edit.touch_begin_pos = nil
			arg_31_0.edit.center_pos = nil
			arg_31_0.edit.origin_crop_size = nil
			arg_31_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.bg.cropScaleXEventHandler(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.crop) then
		return 
	end
	
	if not arg_32_0.edit or not get_cocos_refid(arg_32_0.edit.area_wnd) or not get_cocos_refid(arg_32_1) or not arg_32_5 then
		return 
	end
	
	if arg_32_0.edit.is_bg_move or arg_32_0.edit.is_crop_move or arg_32_0.edit.is_crop_corner_scale or arg_32_0.edit.is_crop_scale_y then
		return 
	end
	
	if arg_32_2 == 0 then
		arg_32_0.edit.touch_scale_x_btn_count = arg_32_0.edit.touch_scale_x_btn_count + 1
		
		if arg_32_0.edit.touch_scale_x_btn_count == 1 then
			arg_32_0.edit.is_crop_scale_x = true
			
			local var_32_0 = arg_32_0.crop:getContentSize()
			local var_32_1 = arg_32_0.crop:getAnchorPoint()
			local var_32_2 = {
				x = var_32_0.width * var_32_1.x,
				y = var_32_0.height * var_32_1.y
			}
			
			arg_32_0.edit.center_pos_x = arg_32_0.crop:convertToWorldSpace({
				x = var_32_2.x,
				y = var_32_2.y
			}).x
			arg_32_0.edit.origin_crop_size = var_32_0
		end
	elseif arg_32_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_32_0) then
			return 
		end
		
		if not arg_32_0.edit.center_pos_x or not arg_32_0.edit.is_crop_scale_x or arg_32_0.edit.touch_scale_x_btn_count ~= 1 then
			return 
		end
		
		arg_32_0.edit.is_crop_scale_x = true
		arg_32_0.edit.touch_move_pos_x = arg_32_3
		
		local var_32_3 = arg_32_0.crop:getContentSize()
		local var_32_4 = var_32_3.width
		local var_32_5 = 1
		local var_32_6 = math.abs(arg_32_0.edit.touch_move_pos_x - arg_32_0.edit.center_pos_x)
		
		if arg_32_5 == "left" then
			if arg_32_0.edit.touch_move_pos_x > arg_32_0.edit.center_pos_x then
				arg_32_0:setCropSize(arg_32_0.edit.min_size.w, var_32_3.height)
				
				return 
			end
		elseif arg_32_5 == "right" and arg_32_0.edit.touch_move_pos_x < arg_32_0.edit.center_pos_x then
			arg_32_0:setCropSize(arg_32_0.edit.min_size.w, var_32_3.height)
			
			return 
		end
		
		local var_32_7 = var_32_6 * 2 / var_32_4
		local var_32_8 = round(var_32_7, 2) * var_32_4
		
		arg_32_0:setCropSize(var_32_8, var_32_3.height)
	else
		arg_32_0.edit.touch_scale_x_btn_count = arg_32_0.edit.touch_scale_x_btn_count - 1
		
		if arg_32_0.edit.touch_scale_x_btn_count <= 0 then
			if not table.empty(arg_32_0.edit.origin_crop_size) and not table.empty(arg_32_0.vars.crop_size) and math.abs(arg_32_0.edit.origin_crop_size.width - arg_32_0.vars.crop_size.w) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_32_0,
					undo_func = bind_func(arg_32_0.setCropSize, arg_32_0, arg_32_0.edit.origin_crop_size.width, arg_32_0.edit.origin_crop_size.height),
					redo_func = bind_func(arg_32_0.setCropSize, arg_32_0, arg_32_0.vars.crop_size.w, arg_32_0.edit.origin_crop_size.height)
				}, true)
			end
			
			arg_32_0.edit.touch_scale_x_btn_count = 0
			arg_32_0.edit.is_crop_scale_x = false
			arg_32_0.edit.center_pos_x = nil
			arg_32_0.edit.origin_crop_size = nil
			arg_32_0.edit.touch_move_pos_x = nil
		end
	end
end

function CustomProfileCard.bg.cropScaleYEventHandler(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.crop) then
		return 
	end
	
	if not arg_33_0.edit or not get_cocos_refid(arg_33_0.edit.area_wnd) or not get_cocos_refid(arg_33_1) or not arg_33_5 then
		return 
	end
	
	if arg_33_0.edit.is_bg_move or arg_33_0.edit.is_crop_move or arg_33_0.edit.is_crop_corner_scale or arg_33_0.edit.is_crop_scale_x then
		return 
	end
	
	if arg_33_2 == 0 then
		arg_33_0.edit.touch_scale_y_btn_count = arg_33_0.edit.touch_scale_y_btn_count + 1
		
		if arg_33_0.edit.touch_scale_y_btn_count == 1 then
			arg_33_0.edit.is_crop_scale_y = true
			
			local var_33_0 = arg_33_0.crop:getContentSize()
			local var_33_1 = arg_33_0.crop:getAnchorPoint()
			local var_33_2 = {
				x = var_33_0.width * var_33_1.x,
				y = var_33_0.height * var_33_1.y
			}
			
			arg_33_0.edit.center_pos_y = arg_33_0.crop:convertToWorldSpace({
				x = var_33_2.x,
				y = var_33_2.y
			}).y
			arg_33_0.edit.origin_crop_size = var_33_0
		end
	elseif arg_33_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_33_0) then
			return 
		end
		
		if not arg_33_0.edit.center_pos_y or not arg_33_0.edit.is_crop_scale_y or arg_33_0.edit.touch_scale_y_btn_count ~= 1 then
			return 
		end
		
		arg_33_0.edit.is_crop_scale_y = true
		arg_33_0.edit.touch_move_pos_y = arg_33_4
		
		local var_33_3 = arg_33_0.crop:getContentSize()
		local var_33_4 = var_33_3.height
		local var_33_5 = 1
		local var_33_6 = math.abs(arg_33_0.edit.touch_move_pos_y - arg_33_0.edit.center_pos_y)
		
		if arg_33_5 == "top" then
			if arg_33_0.edit.touch_move_pos_y < arg_33_0.edit.center_pos_y then
				arg_33_0:setCropSize(var_33_3.width, arg_33_0.edit.min_size.h)
				
				return 
			end
		elseif arg_33_5 == "bottom" and arg_33_0.edit.touch_move_pos_y > arg_33_0.edit.center_pos_y then
			arg_33_0:setCropSize(var_33_3.width, arg_33_0.edit.min_size.h)
			
			return 
		end
		
		local var_33_7 = var_33_6 * 2 / var_33_4
		local var_33_8 = round(var_33_7, 2) * var_33_4
		
		arg_33_0:setCropSize(var_33_3.width, var_33_8)
	else
		arg_33_0.edit.touch_scale_y_btn_count = arg_33_0.edit.touch_scale_y_btn_count - 1
		
		if arg_33_0.edit.touch_scale_y_btn_count <= 0 then
			if not table.empty(arg_33_0.edit.origin_crop_size) and not table.empty(arg_33_0.vars.crop_size) and math.abs(arg_33_0.edit.origin_crop_size.height - arg_33_0.vars.crop_size.h) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_33_0,
					undo_func = bind_func(arg_33_0.setCropSize, arg_33_0, arg_33_0.edit.origin_crop_size.width, arg_33_0.edit.origin_crop_size.height),
					redo_func = bind_func(arg_33_0.setCropSize, arg_33_0, arg_33_0.edit.origin_crop_size.width, arg_33_0.vars.crop_size.h)
				}, true)
			end
			
			arg_33_0.edit.touch_scale_y_btn_count = 0
			arg_33_0.edit.is_crop_scale_y = false
			arg_33_0.edit.center_pos_y = nil
			arg_33_0.edit.origin_crop_size = nil
			arg_33_0.edit.touch_move_pos_y = nil
		end
	end
end

function CustomProfileCard.bg.setBgPosition(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_0.vars or not arg_34_0.vars.bg_pos or not get_cocos_refid(arg_34_0.bg) then
		return 
	end
	
	if not arg_34_0.edit or not get_cocos_refid(arg_34_0.edit.bg_area) then
		return 
	end
	
	arg_34_0.edit.bg_area:getChildByName("img_area"):setPosition(arg_34_1, arg_34_2)
	
	arg_34_0.vars.bg_pos.x = arg_34_1
	arg_34_0.vars.bg_pos.y = arg_34_2
	
	arg_34_0.bg:setPosition(arg_34_1, arg_34_2)
end

function CustomProfileCard.bg.setCropPosition(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0.vars or not arg_35_0.vars.crop_pos or not get_cocos_refid(arg_35_0.crop) then
		return 
	end
	
	arg_35_0.vars.crop_pos.x = arg_35_1
	arg_35_0.vars.crop_pos.y = arg_35_2
	
	arg_35_0.crop:setPosition(arg_35_1, arg_35_2)
	arg_35_0:renderEditorBox()
end

function CustomProfileCard.bg.setCropSize(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_0.vars or not arg_36_0.vars.crop_size or not get_cocos_refid(arg_36_0.crop) then
		return 
	end
	
	if table.empty(arg_36_0.edit.min_size) or table.empty(arg_36_0.edit.max_size) then
		return 
	end
	
	if arg_36_1 <= arg_36_0.edit.min_size.w then
		arg_36_1 = arg_36_0.edit.min_size.w
	end
	
	if arg_36_2 <= arg_36_0.edit.min_size.h then
		arg_36_2 = arg_36_0.edit.min_size.h
	end
	
	if arg_36_1 >= arg_36_0.edit.max_size.w then
		arg_36_1 = arg_36_0.edit.max_size.w
	end
	
	if arg_36_2 >= arg_36_0.edit.max_size.h then
		arg_36_2 = arg_36_0.edit.max_size.h
	end
	
	arg_36_0.vars.crop_size.w = arg_36_1
	arg_36_0.vars.crop_size.h = arg_36_2
	
	arg_36_0.crop:setContentSize(arg_36_1, arg_36_2)
	arg_36_0:renderEditorBox()
end

function CustomProfileCard.bg.setVisible(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.crop) then
		return 
	end
	
	if arg_37_0.vars.is_visible == arg_37_1 then
		return 
	end
	
	if not arg_37_2 then
		local var_37_0 = arg_37_0.vars.is_visible
		local var_37_1 = arg_37_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_37_0,
			undo_func = bind_func(arg_37_0.setVisible, arg_37_0, var_37_0, true),
			redo_func = bind_func(arg_37_0.setVisible, arg_37_0, var_37_1, true)
		}, true)
	end
	
	arg_37_0.vars.is_visible = arg_37_1
	
	arg_37_0.crop:setVisible(arg_37_1)
end

function CustomProfileCard.bg.setLock(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars or not arg_38_0.edit or not get_cocos_refid(arg_38_0.edit.btn_select_move) then
		return 
	end
	
	if arg_38_0.vars.is_lock == arg_38_1 then
		return 
	end
	
	if not arg_38_2 then
		local var_38_0 = arg_38_0.vars.is_lock
		local var_38_1 = arg_38_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_38_0,
			undo_func = bind_func(arg_38_0.setLock, arg_38_0, var_38_0, true),
			redo_func = bind_func(arg_38_0.setLock, arg_38_0, var_38_1, true)
		}, true)
	end
	
	arg_38_0.vars.is_lock = arg_38_1
	
	arg_38_0.edit.btn_select_move:setVisible(not arg_38_1)
end
