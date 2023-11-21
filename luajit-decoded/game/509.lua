CustomProfileCard.hero = {}

function CustomProfileCard.hero.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.parent = arg_1_1.parent
	
	arg_1_0:load(arg_1_1)
	arg_1_0:createModel(arg_1_1)
end

function CustomProfileCard.hero.delete(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.layer_wnd) or not get_cocos_refid(arg_2_0.model) then
		return 
	end
	
	if not arg_2_0.edit or not get_cocos_refid(arg_2_0.edit.area_wnd) or not get_cocos_refid(arg_2_0.edit.btn_select_move) then
		return 
	end
	
	arg_2_0.parent = nil
	arg_2_0.vars = nil
	
	arg_2_0.layer_wnd:removeFromParent()
	arg_2_0.edit.area_wnd:removeFromParent()
	arg_2_0.edit.btn_select_move:removeFromParent()
	
	arg_2_0.edit = nil
end

function CustomProfileCard.hero.load(arg_3_0, arg_3_1)
	if table.empty(arg_3_1.load_data) then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.order = arg_3_1.order
	arg_3_0.vars.type = arg_3_0.parent:convertNumberToType(arg_3_1.load_data[1]) or "hero"
	arg_3_0.vars.id = arg_3_1.load_data[2]
	arg_3_0.vars.pos = table.copyElement(arg_3_1.load_data[3], {
		"x",
		"y"
	})
	arg_3_0.vars.rotation = arg_3_1.load_data[4]
	arg_3_0.vars.is_sd = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[5])
	
	if arg_3_0.vars.is_sd then
		arg_3_0.vars.size = table.copyElement(arg_3_1.load_data[6], {
			"w",
			"h"
		})
	else
		arg_3_0.vars.scale = arg_3_1.load_data[6]
	end
	
	arg_3_0.vars.is_flip = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[7])
	arg_3_0.vars.face_id = arg_3_1.load_data[8]
	arg_3_0.vars.is_visible = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[9])
	arg_3_0.vars.is_lock = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[10])
end

function CustomProfileCard.hero.save(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.model) then
		return nil
	end
	
	local var_4_0 = {
		arg_4_0.parent:convertTypeToNumber(arg_4_0.vars.type),
		arg_4_0.vars.id,
		(table.copyElement(arg_4_0.vars.pos, {
			"x",
			"y"
		}))
	}
	
	var_4_0[3].x = math.floor(var_4_0[3].x * 10) / 10
	var_4_0[3].y = math.floor(var_4_0[3].y * 10) / 10
	var_4_0[4] = math.floor(arg_4_0.vars.rotation * 10) / 10
	var_4_0[5] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_sd)
	
	if arg_4_0.vars.is_sd then
		var_4_0[6] = table.copyElement(arg_4_0.vars.size, {
			"w",
			"h"
		})
		var_4_0[6].w = math.floor(var_4_0[6].w * 10) / 10
		var_4_0[6].h = math.floor(var_4_0[6].h * 10) / 10
	else
		var_4_0[6] = math.floor(arg_4_0.vars.scale * 1000) / 1000
	end
	
	var_4_0[7] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_flip)
	var_4_0[8] = arg_4_0.vars.face_id
	var_4_0[9] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_visible)
	var_4_0[10] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_lock)
	
	return var_4_0
end

function CustomProfileCard.hero.initDB(arg_5_0, arg_5_1)
	if arg_5_0.vars or not get_cocos_refid(arg_5_0.model) then
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.order = arg_5_1.order
	arg_5_0.vars.type = arg_5_1.type or "hero"
	arg_5_0.vars.id = arg_5_1.id
	arg_5_0.vars.pos = {}
	arg_5_0.vars.pos.x = math.floor(arg_5_0.model:getPositionX() * 10) / 10
	arg_5_0.vars.pos.y = math.floor(arg_5_0.model:getPositionY() * 10) / 10
	arg_5_0.vars.rotation = math.floor(arg_5_0.model:getRotation() * 10) / 10
	arg_5_0.vars.is_sd = arg_5_1.is_sd
	
	if arg_5_0.vars.is_sd then
		local var_5_0 = arg_5_0.model:getContentSize()
		
		arg_5_0.vars.size = {}
		arg_5_0.vars.size.w = math.floor(var_5_0.width * 10) / 10
		arg_5_0.vars.size.h = math.floor(var_5_0.height * 10) / 10
	else
		arg_5_0.vars.scale = math.floor(arg_5_0.model:getScale() * 1000) / 1000
	end
	
	arg_5_0.vars.is_flip = arg_5_1.is_flip or false
	arg_5_0.vars.face_id = arg_5_1.face_id or 0
	arg_5_0.vars.is_visible = arg_5_0.model:isVisible()
	arg_5_0.vars.is_lock = false
end

function CustomProfileCard.hero.createModel(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}
	
	local var_6_0 = arg_6_1.is_sd
	
	if var_6_0 == nil then
		var_6_0 = arg_6_0.parent:convertNumberToBoolen(arg_6_1.load_data[5])
	end
	
	if var_6_0 then
		arg_6_0:createSDModel(arg_6_1)
	else
		arg_6_0:createPortraitModel(arg_6_1)
	end
	
	arg_6_0.layer_wnd:setLocalZOrder(arg_6_0.vars.order)
	
	if arg_6_1.is_edit_mode then
		arg_6_0:createEditBox()
	end
end

function CustomProfileCard.hero.createPortraitModel(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or {}
	
	local var_7_0 = arg_7_1.id or arg_7_1.load_data[2]
	local var_7_1 = DB("character", var_7_0, "face_id") or "no_image"
	local var_7_2 = false
	
	if arg_7_1.is_capture then
		var_7_2 = true
	end
	
	local var_7_3, var_7_4 = UIUtil:getPortraitAni(var_7_1, {
		pin_sprite_position_y = true,
		is_static_state = var_7_2
	})
	
	if get_cocos_refid(var_7_3) then
		local var_7_5 = arg_7_1.type or arg_7_0.parent:convertNumberToType(arg_7_1.load_data[1])
		
		arg_7_0.layer_wnd = CustomProfileCard:createParentLayerNode(var_7_5)
		
		local var_7_6 = arg_7_0.parent:getWnd():getChildByName("n_edit_on")
		
		if get_cocos_refid(var_7_6) then
			var_7_6:addChild(arg_7_0.layer_wnd)
		end
		
		var_7_3:setScale(0.65)
		
		if var_7_4 then
			local var_7_7 = arg_7_1.face_id or arg_7_1.load_data[8]
			
			UnitMain:setMainUnitSkin(var_7_0, var_7_3, var_7_7)
			
			local var_7_8, var_7_9 = var_7_3:getRawBonePosition("ui_face")
			local var_7_10 = var_7_3:getRealScaleX()
			local var_7_11 = var_7_3:getRealScaleY()
			
			var_7_3.body:setPosition(-(var_7_8 * var_7_10), -(var_7_9 * var_7_11))
			
			local var_7_12 = arg_7_0.layer_wnd:getPositionY() - 558
			
			var_7_3:setPosition(-var_7_3.body:getPositionX(), var_7_12)
		else
			arg_7_0.layer_wnd:setPositionX(192)
			arg_7_0.layer_wnd:setPositionY(282)
		end
		
		arg_7_0.layer_wnd:addChild(var_7_3)
		
		arg_7_0.model = var_7_3
		
		arg_7_0:initDB(arg_7_1)
		arg_7_0.model:setPosition(arg_7_0.vars.pos.x, arg_7_0.vars.pos.y)
		arg_7_0.model:setScale(arg_7_0.vars.scale)
		arg_7_0.model:setRotation(arg_7_0.vars.rotation)
		
		if arg_7_0.vars.is_flip then
			arg_7_0.model:setScaleX(-arg_7_0.model:getScaleX())
		end
		
		arg_7_0.model:setVisible(arg_7_0.vars.is_visible)
	end
end

function CustomProfileCard.hero.createSDModel(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or {}
	
	local var_8_0 = arg_8_1.id or arg_8_1.load_data[2]
	
	if var_8_0 then
		local var_8_1 = DB("item_material_profile", var_8_0, {
			"material_id"
		})
		
		if not var_8_1 then
			return 
		end
		
		local var_8_2 = DB("profile_sd_character", var_8_1, {
			"model_img"
		})
		
		if not var_8_2 then
			return 
		end
		
		local var_8_3 = load_control("wnd/profile_custom_item.csb")
		
		arg_8_0.model = var_8_3:getChildByName("n_unit")
		
		local var_8_4 = arg_8_0.parent:getWnd()
		
		if arg_8_0.parent and get_cocos_refid(var_8_4) then
			local var_8_5 = arg_8_1.type or arg_8_0.parent:convertNumberToType(arg_8_1.load_data[1])
			
			arg_8_0.layer_wnd = CustomProfileCard:createParentLayerNode(var_8_5)
			
			arg_8_0.layer_wnd:setPositionX(192)
			arg_8_0.layer_wnd:setPositionY(282)
			
			if get_cocos_refid(arg_8_0.layer_wnd) then
				var_8_3:setAnchorPoint(0.5, 0.5)
				var_8_3:setPosition(0, 0)
				arg_8_0.layer_wnd:addChild(var_8_3)
			end
			
			local var_8_6 = var_8_4:getChildByName("n_edit_on")
			
			if get_cocos_refid(var_8_6) then
				var_8_6:addChild(arg_8_0.layer_wnd)
			end
		end
		
		local var_8_7 = "face/" .. var_8_2 .. ".png"
		
		if_set_sprite(arg_8_0.model, nil, var_8_7)
		
		local var_8_8 = arg_8_0.model:getContentSize()
		
		arg_8_0.origin_sd_model_size = {
			w = var_8_8.width,
			h = var_8_8.height
		}
		
		arg_8_0:initDB(arg_8_1)
		arg_8_0.model:setPosition(arg_8_0.vars.pos.x, arg_8_0.vars.pos.y)
		arg_8_0.model:setRotation(arg_8_0.vars.rotation)
		arg_8_0.model:setContentSize(arg_8_0.vars.size.w, arg_8_0.vars.size.h)
		arg_8_0.model:setFlippedX(arg_8_0.vars.is_flip)
		arg_8_0.model:setVisible(arg_8_0.vars.is_visible)
	end
end

function CustomProfileCard.hero.setOrder(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return 
	end
	
	arg_9_0.vars.order = arg_9_1
	
	if get_cocos_refid(arg_9_0.layer_wnd) then
		arg_9_0.layer_wnd:setLocalZOrder(arg_9_0.vars.order)
	end
	
	if arg_9_0.edit and get_cocos_refid(arg_9_0.edit.area_wnd) and get_cocos_refid(arg_9_0.edit.btn_select_move) then
		arg_9_0.edit.area_wnd:setLocalZOrder(arg_9_0.vars.order)
		arg_9_0.edit.btn_select_move:setLocalZOrder(arg_9_0.vars.order)
	end
end

function CustomProfileCard.hero.getOrder(arg_10_0)
	if not arg_10_0.vars then
		return nil
	end
	
	return arg_10_0.vars.order
end

function CustomProfileCard.hero.getType(arg_11_0)
	if not arg_11_0.vars then
		return nil
	end
	
	return arg_11_0.vars.type or "hero"
end

function CustomProfileCard.hero.getId(arg_12_0)
	if not arg_12_0.vars then
		return nil
	end
	
	return arg_12_0.vars.id
end

function CustomProfileCard.hero.getFaceId(arg_13_0)
	if not arg_13_0.vars then
		return nil
	end
	
	return arg_13_0.vars.face_id
end

function CustomProfileCard.hero.isSDModel(arg_14_0)
	if not arg_14_0.vars then
		return nil
	end
	
	return arg_14_0.vars.is_sd
end

function CustomProfileCard.hero.isFlip(arg_15_0)
	if not arg_15_0.vars then
		return nil
	end
	
	return arg_15_0.vars.is_flip
end

function CustomProfileCard.hero.isVisible(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.model) then
		return false
	end
	
	return arg_16_0.vars.is_visible or arg_16_0.model:isVisible()
end

function CustomProfileCard.hero.isLock(arg_17_0)
	if not arg_17_0.vars then
		return false
	end
	
	return arg_17_0.vars.is_lock
end

function CustomProfileCard.hero.createEditBox(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.model) then
		return 
	end
	
	arg_18_0.edit = {}
	
	local var_18_0 = arg_18_0.parent:getWnd()
	local var_18_1 = var_18_0:getChildByName("n_edit_boxes")
	
	arg_18_0.edit.area_wnd = cc.DrawNode:create(1)
	
	arg_18_0.edit.area_wnd:setName("n_edit_area")
	arg_18_0.edit.area_wnd:setAnchorPoint(0.5, 0.5)
	var_18_1:addChild(arg_18_0.edit.area_wnd)
	
	local var_18_2 = var_18_0:getChildByName("n_select_boxes")
	
	arg_18_0.edit.btn_select_move = ccui.Button:create()
	
	arg_18_0.edit.btn_select_move:setName("btn_select_move")
	arg_18_0.edit.btn_select_move:setAnchorPoint(0.5, 0.5)
	arg_18_0.edit.btn_select_move:setTouchEnabled(true)
	arg_18_0.edit.btn_select_move:ignoreContentAdaptWithSize(false)
	arg_18_0.edit.btn_select_move:setTransformParent(arg_18_0.edit.area_wnd)
	arg_18_0.edit.btn_select_move:setLocalZOrder(arg_18_0.vars.order)
	arg_18_0.edit.btn_select_move:setVisible(not arg_18_0.vars.is_lock)
	var_18_2:addChild(arg_18_0.edit.btn_select_move)
	arg_18_0:activeEditorBox(false)
	
	local var_18_3 = load_control("wnd/custom_edit_control.csb")
	
	var_18_3:setName("n_corner_btns")
	arg_18_0.edit.area_wnd:addChild(var_18_3)
	if_set_visible(var_18_3, "n_crop", false)
	if_set_visible(var_18_3, "n_side", false)
	if_set_visible(var_18_3, "n_fixed", false)
	if_set_visible(var_18_3, "n_multi", true)
	
	local var_18_4 = var_18_3:getChildByName("n_multi")
	
	if_set_visible(var_18_4, "n_ratio", true)
	if_set_visible(var_18_4, "n_rotate", true)
	if_set_visible(var_18_4, "n_off", true)
	
	arg_18_0.edit.btn_rotate = var_18_4:getChildByName("n_rotate")
	arg_18_0.edit.btn_delete = var_18_4:getChildByName("n_off")
	arg_18_0.edit.btn_corner_scale_left = var_18_4:getChildByName("n_ratio")
	arg_18_0.edit.btn_corner_scale_right = arg_18_0.edit.btn_corner_scale_left:clone()
	
	var_18_4:addChild(arg_18_0.edit.btn_corner_scale_right)
	
	local var_18_5
	
	if arg_18_0.vars.is_sd then
		local var_18_6 = ProfileCardConfigData.sd_zoom_min
		local var_18_7 = ProfileCardConfigData.sd_zoom_max
		
		arg_18_0.portrait_scale_limit = {
			min = var_18_6,
			max = var_18_7
		}
		arg_18_0.edit.area_size = arg_18_0.origin_sd_model_size
		arg_18_0.origin_sd_model_size = nil
		arg_18_0.edit.min_size = {
			w = arg_18_0.edit.area_size.w * var_18_6,
			h = arg_18_0.edit.area_size.h * var_18_6
		}
		arg_18_0.edit.max_size = {
			w = arg_18_0.edit.area_size.w * var_18_7,
			h = arg_18_0.edit.area_size.h * var_18_7
		}
		
		local var_18_8 = arg_18_0.model:getContentSize()
		local var_18_9 = {
			w = var_18_8.width,
			h = var_18_8.height
		}
		
		arg_18_0.edit.area_wnd:setPosition(var_18_9.w * 0.5, var_18_9.h * 0.5)
		arg_18_0.edit.area_wnd:setContentSize(var_18_9.w, var_18_9.h)
		arg_18_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_18_9.w, var_18_9.h), cc.c4f(1, 1, 1, 1))
		arg_18_0.edit.area_wnd:setTransformParent(arg_18_0.model)
		arg_18_0.edit.btn_select_move:setPosition(var_18_9.w * 0.5, var_18_9.h * 0.5)
		arg_18_0.edit.btn_select_move:setContentSize(var_18_9.w, var_18_9.h)
		
		if get_cocos_refid(arg_18_0.edit.btn_rotate) then
			arg_18_0.edit.btn_rotate:setPosition(0, 0)
		end
		
		if get_cocos_refid(arg_18_0.edit.btn_delete) then
			arg_18_0.edit.btn_delete:setPosition(var_18_9.w, var_18_9.h)
		end
		
		if get_cocos_refid(arg_18_0.edit.btn_corner_scale_left) then
			arg_18_0.edit.btn_corner_scale_left:setPosition(0, var_18_9.h)
		end
		
		if get_cocos_refid(arg_18_0.edit.btn_corner_scale_right) then
			arg_18_0.edit.btn_corner_scale_right:setPosition(var_18_9.w, 0)
		end
	else
		arg_18_0.portrait_scale_limit = {
			min = ProfileCardConfigData.hero_zoom_min,
			max = ProfileCardConfigData.hero_zoom_max
		}
		
		local var_18_10 = arg_18_0.vars.scale / 0.65
		
		arg_18_0.edit.area_size = {
			w = 378 * var_18_10,
			h = 558 * var_18_10
		}
		
		local var_18_11 = arg_18_0.edit.area_size
		
		arg_18_0.edit.area_wnd:setPositionX(arg_18_0.model:getPositionX())
		arg_18_0.edit.area_wnd:setPositionY(arg_18_0.model:getPositionY())
		arg_18_0.edit.area_wnd:setRotation(arg_18_0.model:getRotation())
		arg_18_0.edit.area_wnd:drawRect(cc.p(-(var_18_11.w * 0.5), -(var_18_11.h * 0.5)), cc.p(var_18_11.w * 0.5, var_18_11.h * 0.5), cc.c4f(1, 1, 1, 1))
		arg_18_0.edit.area_wnd:setTransformParent(arg_18_0.model:getParent())
		arg_18_0.edit.btn_select_move:setContentSize(var_18_11.w, var_18_11.h)
		
		if get_cocos_refid(arg_18_0.edit.btn_rotate) then
			arg_18_0.edit.btn_rotate:setPosition(-(var_18_11.w * 0.5), -(var_18_11.h * 0.5))
		end
		
		if get_cocos_refid(arg_18_0.edit.btn_delete) then
			arg_18_0.edit.btn_delete:setPosition(var_18_11.w * 0.5, var_18_11.h * 0.5)
		end
		
		if get_cocos_refid(arg_18_0.edit.btn_corner_scale_left) then
			arg_18_0.edit.btn_corner_scale_left:setPosition(-(var_18_11.w * 0.5), var_18_11.h * 0.5)
		end
		
		if get_cocos_refid(arg_18_0.edit.btn_corner_scale_right) then
			arg_18_0.edit.btn_corner_scale_right:setPosition(var_18_11.w * 0.5, -(var_18_11.h * 0.5))
		end
	end
	
	arg_18_0:addTouchEventListener()
end

function CustomProfileCard.hero.activeEditorBox(arg_19_0, arg_19_1)
	if not arg_19_0.edit or not get_cocos_refid(arg_19_0.edit.area_wnd) then
		return 
	end
	
	arg_19_0.edit.area_wnd:setVisible(arg_19_1)
end

function CustomProfileCard.hero.renderEditorBox(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.model) or not arg_20_0.edit then
		return 
	end
	
	if not arg_20_0.edit or not get_cocos_refid(arg_20_0.edit.area_wnd) then
		return 
	end
	
	local var_20_0
	
	if arg_20_0.vars.is_sd then
		local var_20_1 = arg_20_0.model:getContentSize()
		
		var_20_0 = {
			w = var_20_1.width,
			h = var_20_1.height
		}
	else
		var_20_0 = arg_20_0.edit.area_size
	end
	
	arg_20_0.edit.area_wnd:clear()
	arg_20_0.edit.area_wnd:visit()
	arg_20_0.edit.btn_select_move:setContentSize(var_20_0.w, var_20_0.h)
	
	if arg_20_0.vars.is_sd then
		arg_20_0.edit.area_wnd:setPosition(var_20_0.w * 0.5, var_20_0.h * 0.5)
		arg_20_0.edit.area_wnd:setContentSize(var_20_0.w, var_20_0.h)
		arg_20_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_20_0.w, var_20_0.h), cc.c4f(1, 1, 1, 1))
		arg_20_0.edit.btn_select_move:setPosition(var_20_0.w * 0.5, var_20_0.h * 0.5)
		
		if get_cocos_refid(arg_20_0.edit.btn_rotate) then
			arg_20_0.edit.btn_rotate:setPosition(0, 0)
		end
		
		if get_cocos_refid(arg_20_0.edit.btn_delete) then
			arg_20_0.edit.btn_delete:setPosition(var_20_0.w, var_20_0.h)
		end
		
		if get_cocos_refid(arg_20_0.edit.btn_corner_scale_left) then
			arg_20_0.edit.btn_corner_scale_left:setPosition(0, var_20_0.h)
		end
		
		if get_cocos_refid(arg_20_0.edit.btn_corner_scale_right) then
			arg_20_0.edit.btn_corner_scale_right:setPosition(var_20_0.w, 0)
		end
	else
		arg_20_0.edit.area_wnd:drawRect(cc.p(-(var_20_0.w * 0.5), -(var_20_0.h * 0.5)), cc.p(var_20_0.w * 0.5, var_20_0.h * 0.5), cc.c4f(1, 1, 1, 1))
		
		if get_cocos_refid(arg_20_0.edit.btn_rotate) then
			arg_20_0.edit.btn_rotate:setPosition(-(var_20_0.w * 0.5), -(var_20_0.h * 0.5))
		end
		
		if get_cocos_refid(arg_20_0.edit.btn_delete) then
			arg_20_0.edit.btn_delete:setPosition(var_20_0.w * 0.5, var_20_0.h * 0.5)
		end
		
		if get_cocos_refid(arg_20_0.edit.btn_corner_scale_left) then
			arg_20_0.edit.btn_corner_scale_left:setPosition(-(var_20_0.w * 0.5), var_20_0.h * 0.5)
		end
		
		if get_cocos_refid(arg_20_0.edit.btn_corner_scale_right) then
			arg_20_0.edit.btn_corner_scale_right:setPosition(var_20_0.w * 0.5, -(var_20_0.h * 0.5))
		end
	end
end

function CustomProfileCard.hero.addTouchEventListener(arg_21_0)
	if not arg_21_0.edit or not get_cocos_refid(arg_21_0.edit.area_wnd) then
		return 
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_select_move) then
		arg_21_0.edit.btn_select_move:addTouchEventListener(function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			arg_21_0:heroMoveEventHandler(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_rotate) then
		arg_21_0.edit.btn_rotate:getChildByName("btn"):addTouchEventListener(function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			arg_21_0:heroRotateEventHandler(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_corner_scale_left) then
		arg_21_0.edit.btn_corner_scale_left:getChildByName("btn"):addTouchEventListener(function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			arg_21_0:heroCornerScaleEventHandler(arg_24_0, arg_24_1, arg_24_2, arg_24_3, "left")
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_corner_scale_right) then
		arg_21_0.edit.btn_corner_scale_right:getChildByName("btn"):addTouchEventListener(function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			arg_21_0:heroCornerScaleEventHandler(arg_25_0, arg_25_1, arg_25_2, arg_25_3, "right")
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_delete) then
		arg_21_0.edit.btn_delete:getChildByName("btn"):addTouchEventListener(function(arg_26_0, arg_26_1)
			arg_21_0:heroRemoveEventHandler(arg_26_0, arg_26_1)
		end)
	end
	
	arg_21_0.edit.touch_move_btn_count = 0
	arg_21_0.edit.touch_corner_scale_btn_count = 0
	arg_21_0.edit.touch_rotate_btn_count = 0
end

function CustomProfileCard.hero.heroMoveEventHandler(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.model) or not get_cocos_refid(arg_27_1) then
		return 
	end
	
	if not arg_27_0.edit or not get_cocos_refid(arg_27_0.edit.area_wnd) then
		return 
	end
	
	if arg_27_0.vars.is_lock then
		return 
	end
	
	if arg_27_0.edit.is_corner_scale or arg_27_0.edit.is_rotate then
		return 
	end
	
	if arg_27_2 == 0 then
		arg_27_0.edit.touch_move_btn_count = arg_27_0.edit.touch_move_btn_count + 1
		
		if arg_27_0.edit.touch_move_btn_count == 1 then
			if not CustomProfileCardEditor:isFocusLayer(arg_27_0) and arg_27_1:getName() == "btn_select_move" then
				CustomProfileCardEditor:setFocusLayer(arg_27_0)
			end
			
			arg_27_0.edit.is_move = true
			arg_27_0.edit.touch_begin_pos = {
				x = arg_27_3,
				y = arg_27_4
			}
			arg_27_0.edit.origin_hero_pos = {
				x = arg_27_0.model:getPositionX(),
				y = arg_27_0.model:getPositionY()
			}
		end
	elseif arg_27_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_27_0) then
			return 
		end
		
		if table.empty(arg_27_0.edit.touch_begin_pos) or table.empty(arg_27_0.edit.origin_hero_pos) or not arg_27_0.edit.is_move or arg_27_0.edit.touch_move_btn_count ~= 1 then
			return 
		end
		
		arg_27_0.edit.is_move = true
		arg_27_0.edit.touch_move_pos = {
			x = arg_27_3,
			y = arg_27_4
		}
		
		local var_27_0 = arg_27_0.edit.touch_move_pos.x - arg_27_0.edit.touch_begin_pos.x
		local var_27_1 = arg_27_0.edit.touch_move_pos.y - arg_27_0.edit.touch_begin_pos.y
		
		arg_27_0:setPosition(arg_27_0.edit.origin_hero_pos.x + var_27_0, arg_27_0.edit.origin_hero_pos.y + var_27_1)
	else
		arg_27_0.edit.touch_move_btn_count = arg_27_0.edit.touch_move_btn_count - 1
		
		if arg_27_0.edit.touch_move_btn_count <= 0 then
			if not table.empty(arg_27_0.edit.origin_hero_pos) and not table.empty(arg_27_0.vars.pos) and (math.abs(arg_27_0.edit.origin_hero_pos.x - arg_27_0.vars.pos.x) >= 0.1 or math.abs(arg_27_0.edit.origin_hero_pos.y - arg_27_0.vars.pos.y) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_27_0,
					undo_func = bind_func(arg_27_0.setPosition, arg_27_0, arg_27_0.edit.origin_hero_pos.x, arg_27_0.edit.origin_hero_pos.y),
					redo_func = bind_func(arg_27_0.setPosition, arg_27_0, arg_27_0.vars.pos.x, arg_27_0.vars.pos.y)
				}, true)
			end
			
			arg_27_0.edit.touch_move_btn_count = 0
			arg_27_0.edit.is_move = false
			arg_27_0.edit.touch_begin_pos = nil
			arg_27_0.edit.origin_hero_pos = nil
			arg_27_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.hero.heroRotateEventHandler(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.model) or not get_cocos_refid(arg_28_1) then
		return 
	end
	
	if not arg_28_0.edit or not get_cocos_refid(arg_28_0.edit.area_wnd) then
		return 
	end
	
	if arg_28_0.edit.is_move or arg_28_0.edit.is_corner_scale then
		return 
	end
	
	if arg_28_2 == 0 then
		arg_28_0.edit.touch_rotate_btn_count = arg_28_0.edit.touch_rotate_btn_count + 1
		
		if arg_28_0.edit.touch_rotate_btn_count == 1 then
			arg_28_0.edit.is_rotate = true
			arg_28_0.edit.touch_begin_pos = {
				x = arg_28_3,
				y = arg_28_4
			}
			
			local var_28_0
			
			if arg_28_0.vars.is_sd then
				local var_28_1 = arg_28_0.model:getContentSize()
				
				var_28_0 = {
					w = var_28_1.width,
					h = var_28_1.height
				}
			else
				var_28_0 = arg_28_0.edit.area_size
			end
			
			local var_28_2 = {
				x = var_28_0.w * 0.5,
				y = var_28_0.h * 0.5
			}
			
			arg_28_0.edit.center_pos = arg_28_0.edit.btn_select_move:convertToWorldSpace({
				x = var_28_2.x,
				y = var_28_2.y
			})
			arg_28_0.edit.origin_hero_angle = arg_28_0.model:getRotation()
		end
	elseif arg_28_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_28_0) then
			return 
		end
		
		if table.empty(arg_28_0.edit.touch_begin_pos) or table.empty(arg_28_0.edit.center_pos) or not arg_28_0.edit.origin_hero_angle or not arg_28_0.edit.is_rotate or arg_28_0.edit.touch_rotate_btn_count ~= 1 then
			return 
		end
		
		arg_28_0.edit.is_rotate = true
		arg_28_0.edit.touch_move_pos = {
			x = arg_28_3,
			y = arg_28_4
		}
		
		local var_28_3 = math.deg(math.atan2(arg_28_0.edit.touch_begin_pos.y - arg_28_0.edit.center_pos.y, arg_28_0.edit.touch_begin_pos.x - arg_28_0.edit.center_pos.x) - math.atan2(arg_28_0.edit.touch_move_pos.y - arg_28_0.edit.center_pos.y, arg_28_0.edit.touch_move_pos.x - arg_28_0.edit.center_pos.x))
		
		arg_28_0:setRotation(var_28_3 + arg_28_0.edit.origin_hero_angle)
	else
		arg_28_0.edit.touch_rotate_btn_count = arg_28_0.edit.touch_rotate_btn_count - 1
		
		if arg_28_0.edit.touch_rotate_btn_count <= 0 then
			if arg_28_0.edit.origin_hero_angle and arg_28_0.vars.rotation and math.abs(arg_28_0.edit.origin_hero_angle - arg_28_0.vars.rotation) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_28_0,
					undo_func = bind_func(arg_28_0.setRotation, arg_28_0, arg_28_0.edit.origin_hero_angle),
					redo_func = bind_func(arg_28_0.setRotation, arg_28_0, arg_28_0.vars.rotation)
				}, true)
			end
			
			arg_28_0.edit.touch_rotate_btn_count = 0
			arg_28_0.edit.is_rotate = false
			arg_28_0.edit.touch_begin_pos = nil
			arg_28_0.edit.center_pos = nil
			arg_28_0.edit.origin_hero_angle = nil
			arg_28_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.hero.heroCornerScaleEventHandler(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.model) or not get_cocos_refid(arg_29_1) or not arg_29_5 then
		return 
	end
	
	if not arg_29_0.edit or not get_cocos_refid(arg_29_0.edit.area_wnd) or table.empty(arg_29_0.edit.area_size) then
		return 
	end
	
	if arg_29_0.edit.is_move or arg_29_0.edit.is_rotate then
		return 
	end
	
	if arg_29_2 == 0 then
		arg_29_0.edit.touch_corner_scale_btn_count = arg_29_0.edit.touch_corner_scale_btn_count + 1
		
		if arg_29_0.edit.touch_corner_scale_btn_count == 1 then
			arg_29_0.edit.is_corner_scale = true
			
			local var_29_0
			
			if arg_29_0.vars.is_sd then
				arg_29_0.edit.standard_dis = math.sqrt(arg_29_0.edit.area_size.w * 0.5 * (arg_29_0.edit.area_size.w * 0.5) + arg_29_0.edit.area_size.h * 0.5 * (arg_29_0.edit.area_size.h * 0.5))
				
				local var_29_1 = arg_29_0.model:getContentSize()
				
				var_29_0 = {
					w = var_29_1.width,
					h = var_29_1.height
				}
				arg_29_0.edit.origin_hero_size = var_29_1
			else
				var_29_0 = arg_29_0.edit.area_size
				arg_29_0.edit.standard_dis = math.sqrt(113562)
				arg_29_0.edit.origin_hero_scale_rate = arg_29_0.model:getScaleY() / 0.65
			end
			
			local var_29_2 = {
				x = var_29_0.w * 0.5,
				y = var_29_0.h * 0.5
			}
			
			arg_29_0.edit.center_pos = arg_29_0.edit.btn_select_move:convertToWorldSpace({
				x = var_29_2.x,
				y = var_29_2.y
			})
			arg_29_0.edit.origin_hero_angle = arg_29_0.model:getRotation()
		end
	elseif arg_29_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_29_0) then
			return 
		end
		
		if table.empty(arg_29_0.edit.center_pos) or not arg_29_0.edit.standard_dis or not arg_29_0.edit.origin_hero_angle or not arg_29_0.edit.is_corner_scale or arg_29_0.edit.touch_corner_scale_btn_count ~= 1 then
			return 
		end
		
		arg_29_0.edit.is_corner_scale = true
		arg_29_0.edit.touch_move_pos = {
			x = arg_29_3,
			y = arg_29_4
		}
		
		local var_29_3 = math.sin(math.rad(arg_29_0.edit.origin_hero_angle))
		local var_29_4 = math.cos(math.rad(arg_29_0.edit.origin_hero_angle))
		local var_29_5 = (arg_29_0.edit.touch_move_pos.x - arg_29_0.edit.center_pos.x) * var_29_4 - (arg_29_0.edit.touch_move_pos.y - arg_29_0.edit.center_pos.y) * var_29_3 + arg_29_0.edit.center_pos.x
		local var_29_6 = (arg_29_0.edit.touch_move_pos.x - arg_29_0.edit.center_pos.x) * var_29_3 + (arg_29_0.edit.touch_move_pos.y - arg_29_0.edit.center_pos.y) * var_29_4 + arg_29_0.edit.center_pos.y
		local var_29_7 = var_29_5 - arg_29_0.edit.center_pos.x
		local var_29_8 = var_29_6 - arg_29_0.edit.center_pos.y
		local var_29_9 = math.sqrt(var_29_7 * var_29_7 + var_29_8 * var_29_8) / arg_29_0.edit.standard_dis
		
		if not table.empty(arg_29_0.portrait_scale_limit) then
			if var_29_9 <= arg_29_0.portrait_scale_limit.min then
				var_29_9 = arg_29_0.portrait_scale_limit.min
			end
			
			if var_29_9 >= arg_29_0.portrait_scale_limit.max then
				var_29_9 = arg_29_0.portrait_scale_limit.max
			end
		end
		
		if arg_29_0.vars.is_sd then
			if arg_29_5 == "left" then
				if var_29_5 > arg_29_0.edit.center_pos.x and var_29_6 < arg_29_0.edit.center_pos.y then
					var_29_9 = arg_29_0.portrait_scale_limit.min
				end
			elseif arg_29_5 == "right" and var_29_5 < arg_29_0.edit.center_pos.x and var_29_6 > arg_29_0.edit.center_pos.y then
				var_29_9 = arg_29_0.portrait_scale_limit.min
			end
			
			local var_29_10 = arg_29_0.edit.area_size
			local var_29_11 = var_29_10.w * var_29_9
			local var_29_12 = var_29_10.h * var_29_9
			
			arg_29_0:setContentSize(var_29_11, var_29_12)
		else
			if arg_29_5 == "left" then
				if var_29_5 > arg_29_0.edit.center_pos.x and var_29_6 < arg_29_0.edit.center_pos.y then
					var_29_9 = arg_29_0.portrait_scale_limit.min
				end
			elseif arg_29_5 == "right" and var_29_5 < arg_29_0.edit.center_pos.x and var_29_6 > arg_29_0.edit.center_pos.y then
				var_29_9 = arg_29_0.portrait_scale_limit.min
			end
			
			arg_29_0:setScale(var_29_9)
		end
	else
		arg_29_0.edit.touch_corner_scale_btn_count = arg_29_0.edit.touch_corner_scale_btn_count - 1
		
		if arg_29_0.edit.touch_corner_scale_btn_count <= 0 then
			if arg_29_0.vars.is_sd then
				if not table.empty(arg_29_0.edit.origin_hero_size) and not table.empty(arg_29_0.vars.size) and (math.abs(arg_29_0.edit.origin_hero_size.width - arg_29_0.vars.size.w) >= 0.1 or math.abs(arg_29_0.edit.origin_hero_size.height - arg_29_0.vars.size.h) >= 0.1) then
					CustomProfileCardEditor:getLayerCommand():pushUndo({
						layer = arg_29_0,
						undo_func = bind_func(arg_29_0.setContentSize, arg_29_0, arg_29_0.edit.origin_hero_size.width, arg_29_0.edit.origin_hero_size.height),
						redo_func = bind_func(arg_29_0.setContentSize, arg_29_0, arg_29_0.vars.size.w, arg_29_0.vars.size.h)
					}, true)
				end
			elseif arg_29_0.edit.origin_hero_scale_rate and arg_29_0.vars.scale then
				local var_29_13 = math.abs(arg_29_0.edit.origin_hero_scale_rate - arg_29_0.vars.scale / 0.65)
				
				if math.floor(var_29_13 * 1000) / 1000 > 0 then
					CustomProfileCardEditor:getLayerCommand():pushUndo({
						layer = arg_29_0,
						undo_func = bind_func(arg_29_0.setScale, arg_29_0, arg_29_0.edit.origin_hero_scale_rate),
						redo_func = bind_func(arg_29_0.setScale, arg_29_0, arg_29_0.vars.scale / 0.65)
					}, true)
				end
			end
			
			arg_29_0.edit.touch_corner_scale_btn_count = 0
			arg_29_0.edit.is_corner_scale = false
			arg_29_0.edit.standard_dis = nil
			arg_29_0.edit.center_pos = nil
			arg_29_0.edit.origin_hero_size = nil
			arg_29_0.edit.origin_hero_scale = nil
			arg_29_0.edit.origin_hero_angle = nil
			arg_29_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.hero.heroRemoveEventHandler(arg_30_0, arg_30_1, arg_30_2)
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

function CustomProfileCard.hero.setPosition(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0.vars or table.empty(arg_31_0.vars.pos) or not get_cocos_refid(arg_31_0.model) then
		return 
	end
	
	if not arg_31_0.vars.is_sd then
		arg_31_0.edit.area_wnd:setPosition(arg_31_0.edit.area_wnd:getPositionX() + (arg_31_1 - arg_31_0.vars.pos.x), arg_31_0.edit.area_wnd:getPositionY() + (arg_31_2 - arg_31_0.vars.pos.y))
	end
	
	arg_31_0.vars.pos.x = arg_31_1
	arg_31_0.vars.pos.y = arg_31_2
	
	arg_31_0.model:setPosition(arg_31_1, arg_31_2)
	arg_31_0:renderEditorBox()
end

function CustomProfileCard.hero.setRotation(arg_32_0, arg_32_1)
	if not arg_32_0.vars or not arg_32_0.vars.rotation or not get_cocos_refid(arg_32_0.model) then
		return 
	end
	
	if not arg_32_0.vars.is_sd then
		arg_32_0.edit.area_wnd:setRotation(arg_32_1)
	end
	
	arg_32_0.vars.rotation = arg_32_1
	
	arg_32_0.model:setRotation(arg_32_1)
	arg_32_0:renderEditorBox()
end

function CustomProfileCard.hero.setScale(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not arg_33_0.vars.scale or not get_cocos_refid(arg_33_0.model) then
		return 
	end
	
	if table.empty(arg_33_0.edit.area_size) then
		return 
	end
	
	local var_33_0 = 0.65 * arg_33_1
	
	if not arg_33_0.vars.is_sd then
		arg_33_0.edit.area_size.w = 378 * arg_33_1
		arg_33_0.edit.area_size.h = 558 * arg_33_1
	end
	
	arg_33_0.vars.scale = var_33_0
	
	arg_33_0.model:setScale(var_33_0)
	
	if arg_33_0.vars.is_flip then
		arg_33_0.model:setScaleX(-var_33_0)
	end
	
	arg_33_0:renderEditorBox()
end

function CustomProfileCard.hero.setContentSize(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_0.vars or not arg_34_0.vars.size or not get_cocos_refid(arg_34_0.model) then
		return 
	end
	
	if table.empty(arg_34_0.edit.min_size) or table.empty(arg_34_0.edit.max_size) then
		return 
	end
	
	if arg_34_1 <= arg_34_0.edit.min_size.w then
		arg_34_1 = arg_34_0.edit.min_size.w
	end
	
	if arg_34_1 >= arg_34_0.edit.max_size.w then
		arg_34_1 = arg_34_0.edit.max_size.w
	end
	
	if arg_34_2 <= arg_34_0.edit.min_size.h then
		arg_34_2 = arg_34_0.edit.min_size.h
	end
	
	if arg_34_2 >= arg_34_0.edit.max_size.h then
		arg_34_2 = arg_34_0.edit.max_size.h
	end
	
	arg_34_0.vars.size.w = arg_34_1
	arg_34_0.vars.size.h = arg_34_2
	
	arg_34_0.model:setContentSize(arg_34_1, arg_34_2)
	arg_34_0:renderEditorBox()
end

function CustomProfileCard.hero.setFace(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0.vars or not arg_35_0.vars.id or not get_cocos_refid(arg_35_0.model) then
		return 
	end
	
	if arg_35_0.vars.is_sd then
		return 
	end
	
	if arg_35_0.vars.face_id == arg_35_1 then
		return 
	end
	
	if not arg_35_2 then
		local var_35_0 = arg_35_0.vars.face_id
		local var_35_1 = arg_35_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_35_0,
			undo_func = bind_func(arg_35_0.setFace, arg_35_0, var_35_0, true),
			redo_func = bind_func(arg_35_0.setFace, arg_35_0, var_35_1, true)
		}, true)
	end
	
	arg_35_0.vars.face_id = arg_35_1
	
	UnitMain:setMainUnitSkin(arg_35_0.vars.id, arg_35_0.model, arg_35_0.vars.face_id)
end

function CustomProfileCard.hero.setSkin(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_0.vars or not arg_36_0.vars.id or not get_cocos_refid(arg_36_0.model) then
		return 
	end
	
	if arg_36_0.vars.is_sd or table.empty(arg_36_1) then
		return 
	end
	
	if arg_36_0.vars.id == arg_36_1.skin_id then
		return 
	end
	
	if not arg_36_2 then
		local var_36_0 = {
			skin_id = arg_36_0.vars.id,
			face_id = arg_36_0.vars.face_id
		}
		local var_36_1 = table.copyElement(arg_36_1, {
			"skin_id",
			"face_id"
		})
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_36_0,
			undo_func = bind_func(arg_36_0.setSkin, arg_36_0, var_36_0, true),
			redo_func = bind_func(arg_36_0.setSkin, arg_36_0, var_36_1, true)
		}, true)
	end
	
	arg_36_0.vars.id = arg_36_1.skin_id
	arg_36_0.vars.face_id = arg_36_1.face_id
	
	local var_36_2 = DB("character", arg_36_0.vars.id, "face_id") or "no_image"
	local var_36_3, var_36_4 = UIUtil:getPortraitAni(var_36_2, {
		pin_sprite_position_y = true
	})
	
	if get_cocos_refid(var_36_3) and var_36_4 then
		UnitMain:setMainUnitSkin(arg_36_0.vars.id, var_36_3, arg_36_0.vars.face_id)
		var_36_3:setScale(0.65)
		
		local var_36_5, var_36_6 = var_36_3:getRawBonePosition("ui_face")
		local var_36_7 = var_36_3:getRealScaleX()
		local var_36_8 = var_36_3:getRealScaleY()
		
		var_36_3.body:setPosition(-(var_36_5 * var_36_7), -(var_36_6 * var_36_8))
		
		local var_36_9 = arg_36_0.layer_wnd:getPositionY() - 558
		
		var_36_3:setPosition(-var_36_3.body:getPositionX(), var_36_9)
		arg_36_0.layer_wnd:removeAllChildren()
		arg_36_0.layer_wnd:addChild(var_36_3)
		
		arg_36_0.model = var_36_3
		
		arg_36_0.model:setPosition(arg_36_0.vars.pos.x, arg_36_0.vars.pos.y)
		arg_36_0.model:setScale(arg_36_0.vars.scale)
		arg_36_0.model:setRotation(arg_36_0.vars.rotation)
		
		if arg_36_0.vars.is_flip then
			arg_36_0.model:setScaleX(-arg_36_0.model:getScaleX())
		end
		
		arg_36_0.model:setVisible(arg_36_0.vars.is_visible)
	end
end

function CustomProfileCard.hero.setFlip(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.model) then
		return 
	end
	
	if arg_37_0.vars.is_flip == arg_37_1 then
		return 
	end
	
	if not arg_37_2 then
		local var_37_0 = arg_37_0.vars.is_flip
		local var_37_1 = arg_37_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_37_0,
			undo_func = bind_func(arg_37_0.setFlip, arg_37_0, var_37_0, true),
			redo_func = bind_func(arg_37_0.setFlip, arg_37_0, var_37_1, true)
		}, true)
	end
	
	arg_37_0.vars.is_flip = arg_37_1
	
	if arg_37_0.vars.is_sd then
		arg_37_0.model:setFlippedX(arg_37_0.vars.is_flip)
	else
		local var_37_2 = math.abs(arg_37_0.model:getScaleX())
		
		if arg_37_0.vars.is_flip then
			arg_37_0.model:setScaleX(-var_37_2)
		else
			arg_37_0.model:setScaleX(var_37_2)
		end
	end
end

function CustomProfileCard.hero.setVisible(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.model) then
		return 
	end
	
	if arg_38_0.vars.is_visible == arg_38_1 then
		return 
	end
	
	if not arg_38_2 then
		local var_38_0 = arg_38_0.vars.is_visible
		local var_38_1 = arg_38_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_38_0,
			undo_func = bind_func(arg_38_0.setVisible, arg_38_0, var_38_0, true),
			redo_func = bind_func(arg_38_0.setVisible, arg_38_0, var_38_1, true)
		}, true)
	end
	
	arg_38_0.vars.is_visible = arg_38_1
	
	arg_38_0.model:setVisible(arg_38_1)
end

function CustomProfileCard.hero.setLock(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_0.vars or not arg_39_0.edit or not get_cocos_refid(arg_39_0.edit.btn_select_move) then
		return 
	end
	
	if arg_39_0.vars.is_lock == arg_39_1 then
		return 
	end
	
	if not arg_39_2 then
		local var_39_0 = arg_39_0.vars.is_lock
		local var_39_1 = arg_39_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_39_0,
			undo_func = bind_func(arg_39_0.setLock, arg_39_0, var_39_0, true),
			redo_func = bind_func(arg_39_0.setLock, arg_39_0, var_39_1, true)
		}, true)
	end
	
	arg_39_0.vars.is_lock = arg_39_1
	
	arg_39_0.edit.btn_select_move:setVisible(not arg_39_1)
end
