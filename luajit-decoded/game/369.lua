function UIUtil.makeUnitEquipItemTooltipOpts(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {
		wnd = arg_1_1,
		equip = arg_1_2
	}
	
	var_1_0.no_resize = true
	var_1_0.no_resize_name = true
	var_1_0.is_enhancer = true
	
	if arg_1_2:isArtifact() then
		var_1_0.up_cont = arg_1_1:getChildByName("n_up")
	elseif not arg_1_3 then
		var_1_0.up_cont = getChildByPath(arg_1_1, "n_up")
	end
	
	var_1_0.txt_name = arg_1_1:getChildByName("txt_name")
	var_1_0.txt_scale = 1
	var_1_0.txt_type = arg_1_1:getChildByName("txt_type")
	var_1_0.offset_per_char = 41.57
	
	return var_1_0
end

function UIUtil.updateUnitEquipNamePosition(arg_2_0, arg_2_1)
	if get_cocos_refid(arg_2_1.txt_name) and arg_2_1.txt_name:getStringNumLines() == 3 then
		arg_2_1.txt_name._origin_pos_y = arg_2_1.txt_name._origin_pos_y or arg_2_1.txt_name:getPositionY()
		
		arg_2_1.txt_name:setPositionY(arg_2_1.txt_name._origin_pos_y + 13)
		
		arg_2_1.txt_name._origin_size = arg_2_1.txt_name._origin_size or arg_2_1.txt_name:getContentSize()
		
		arg_2_1.txt_name:setContentSize({
			width = arg_2_1.txt_name._origin_size.width,
			height = arg_2_1.txt_name._origin_size.height + 13
		})
	end
end

function UIUtil.getStatIconPath(arg_3_0, arg_3_1)
	return "img/icon_menu_" .. string.gsub(arg_3_1, "_rate", "") .. ".png"
end

function UIUtil.setStatIcon(arg_4_0, arg_4_1, arg_4_2)
	SpriteCache:resetSprite(arg_4_1, "img/icon_menu_" .. string.gsub(arg_4_2, "_rate", "") .. ".png")
end

function UIUtil.startStatUpEffect(arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = arg_5_1:getPosition()
	local var_5_2 = CACHE:getEffect("itemupgrade_statup")
	
	var_5_2:setScale(1)
	var_5_2:setPosition(var_5_0, var_5_1)
	var_5_2:setLocalZOrder(2000)
	arg_5_1:getParent():addChild(var_5_2)
	UIAction:AddSync(SEQ(DMOTION("animation")), var_5_2)
end
