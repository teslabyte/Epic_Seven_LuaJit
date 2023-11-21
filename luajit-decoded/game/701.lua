LotaUIMonsterInfo = ClassDef()

function LotaUIMonsterInfo.constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_4 = arg_1_4 or 0
	arg_1_5 = arg_1_5 or 0
	arg_1_0.node = LotaUtil:getUIControl("clan_heritage_mob_info")
	
	arg_1_0.node:setCascadeColorEnabled(false)
	
	arg_1_0.object_db_id = arg_1_2
	arg_1_0.object_tile_id = arg_1_3
	arg_1_0.last_x = 1
	arg_1_0.last_scale = 1
	arg_1_0.offset_y = arg_1_5
	
	local var_1_0, var_1_1 = arg_1_1:getPosition()
	
	arg_1_0.origin_y = var_1_1
	
	arg_1_0.node:setPositionX(arg_1_4 + var_1_0)
	arg_1_0.node:setPositionY(-60 + arg_1_5 + var_1_1)
	LotaSystem:addToMonsterFieldUI(arg_1_0.node)
	arg_1_0:updateUI()
	arg_1_0:updateUIScale()
end

function LotaUIMonsterInfo.updateUIScale(arg_2_0)
	if not get_cocos_refid(arg_2_0.node) then
		return 
	end
	
	local var_2_0 = LotaCameraSystem:getScale() or 1
	
	arg_2_0.node:setScale(1 / var_2_0)
	arg_2_0.node:setScaleX(arg_2_0.node:getScaleX() * arg_2_0.last_x)
	
	if arg_2_0.bone_position_y then
		arg_2_0.node:setPositionY(arg_2_0.bone_position_y * 0.5 + arg_2_0.offset_y + arg_2_0.origin_y)
		
		if arg_2_0.node.slot then
			local var_2_1 = arg_2_0.node.slot:getContentSize()
			local var_2_2 = arg_2_0.bone_position_y * 0.5 + arg_2_0.offset_y + var_2_1.height
			
			arg_2_0.node.slot:setPositionY(var_2_2 * (1 - var_2_0) - 80)
		end
	end
end

function LotaUIMonsterInfo.setBonePositionY(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.bone_position_y = arg_3_1
	arg_3_0.y_offset = arg_3_2
	
	arg_3_0.node:setPositionY(arg_3_0.bone_position_y * 0.5 + arg_3_0.origin_y)
end

function LotaUIMonsterInfo.updateScale(arg_4_0, arg_4_1)
	if arg_4_1 < 0.05 then
		arg_4_0.node:setScale(0)
		
		arg_4_0.last_scale = 0
	else
		arg_4_0.node:setScale(1 / arg_4_1 * 0.5)
		
		arg_4_0.last_scale = 1 / arg_4_1 * 0.5
	end
	
	arg_4_0:updateUIScale()
end

function LotaUIMonsterInfo.reflect(arg_5_0)
	if not get_cocos_refid(arg_5_0.node) then
		return 
	end
	
	arg_5_0.node:setScaleX(arg_5_0.node:getScaleX() * -1)
	
	arg_5_0.last_x = -1
end

function LotaUIMonsterInfo.setVisible(arg_6_0, arg_6_1)
	if not get_cocos_refid(arg_6_0.node) then
		return 
	end
	
	arg_6_0.node:setVisible(arg_6_1)
end

function LotaUIMonsterInfo.setOpacity(arg_7_0, arg_7_1)
	if not get_cocos_refid(arg_7_0.node) then
		return 
	end
	
	arg_7_0.node:setOpacity(arg_7_1)
end

function LotaUIMonsterInfo.getOpacity(arg_8_0)
	if not get_cocos_refid(arg_8_0.node) then
		return 
	end
	
	return arg_8_0.node:getOpacity()
end

function LotaUIMonsterInfo.updateUI(arg_9_0)
	LotaUtil:updateMonsterInfoUI(arg_9_0.node, arg_9_0.object_db_id, arg_9_0.object_tile_id)
end

function LotaUIMonsterInfo.remove(arg_10_0)
	if not get_cocos_refid(arg_10_0.node) then
		return 
	end
	
	arg_10_0.node:removeFromParent()
end
