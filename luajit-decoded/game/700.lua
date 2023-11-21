LotaUIMovableInfo = ClassDef()

function LotaUIMovableInfo.constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.node = LotaUtil:getUIControl("clan_heritage_my_info")
	arg_1_0.data = arg_1_2
	arg_1_0.last_x = 1
	arg_1_0.bone_height = arg_1_3
	
	local var_1_0, var_1_1 = arg_1_1:getPosition()
	
	arg_1_0:updatePosition(var_1_0, var_1_1)
	LotaSystem:addToMovableFieldUI(arg_1_0.node)
	arg_1_0:updateUIScale()
	arg_1_0:updateUI()
end

function LotaUIMovableInfo.updatePosition(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.node:setPositionX(arg_2_1)
	arg_2_0.node:setPositionY(arg_2_0.bone_height * 0.5 + 26 + arg_2_2)
end

function LotaUIMovableInfo.updateUIScale(arg_3_0)
	if not get_cocos_refid(arg_3_0.node) then
		return 
	end
	
	local var_3_0 = arg_3_0.node:getParent()
	local var_3_1 = 1
	
	if var_3_0:getScaleX() == var_3_0:getScaleY() then
		var_3_1 = var_3_1 * var_3_0:getScale()
	else
		local var_3_2 = var_3_0:getScaleX()
		local var_3_3 = var_3_0:getScaleY()
		
		if math.abs(var_3_2) == math.abs(var_3_3) then
			local var_3_4 = var_3_1 * math.abs(var_3_2)
		end
	end
	
	local var_3_5 = var_3_0:getParent()
	local var_3_6 = LotaCameraSystem:getPlayScale()
	local var_3_7 = LotaCameraSystem:getScale() or 1
	local var_3_8 = var_3_6 - var_3_7
	
	arg_3_0.node:setScale(1 / var_3_7)
	arg_3_0.node:setScaleX(arg_3_0.node:getScaleX() * arg_3_0.last_x)
	arg_3_0:updateUI()
end

function LotaUIMovableInfo.updateUI(arg_4_0)
	LotaUtil:updateLevelIconWithLv(arg_4_0.node, arg_4_0.data:getLevel(), {
		level_bg_name = "lv_bg",
		t_level_name = "t_lv",
		n_expedition_level_name = "n_char"
	})
	
	local var_4_0 = arg_4_0.node:findChildByName("t_name")
	
	if_set(var_4_0, nil, arg_4_0.data:getName())
	if_set_color(var_4_0, nil, arg_4_0.data:getUID() == AccountData.id and cc.c3b(107, 193, 27) or cc.c3b(255, 255, 255))
end

function LotaUIMovableInfo.setVisible(arg_5_0, arg_5_1)
	if_set_visible(arg_5_0.node, nil, arg_5_1)
end

function LotaUIMovableInfo.remove(arg_6_0)
	if not get_cocos_refid(arg_6_0.node) then
		return 
	end
	
	arg_6_0.node:removeFromParent()
end

function LotaUIMovableInfo.onSetScaleX(arg_7_0, arg_7_1)
end
