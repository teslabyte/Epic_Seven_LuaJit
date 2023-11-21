SPLFieldUIInfo = ClassDef()

function SPLFieldUIInfo.constructor(arg_1_0, arg_1_1, arg_1_2)
	if not get_cocos_refid(arg_1_1) then
		return 
	end
	
	arg_1_2 = arg_1_2 or {}
	arg_1_0.node = arg_1_1
	
	arg_1_0.node:setCascadeColorEnabled(false)
	
	arg_1_0.origin_x = arg_1_2.x or 0
	arg_1_0.origin_y = arg_1_2.y or 0
	arg_1_0.offset_x = arg_1_2.offset_x or 0
	arg_1_0.offset_y = arg_1_2.offset_y or 0
	
	arg_1_0.node:setPositionX(arg_1_0.offset_x + arg_1_0.origin_x)
	arg_1_0.node:setPositionY(arg_1_0.offset_y + arg_1_0.origin_y)
	
	arg_1_0.origin_scale = arg_1_1:getScale()
	arg_1_0.adjust_scale = 1
	arg_1_0.opts = arg_1_2
	
	arg_1_0:updateUI()
	arg_1_0:updateUIScale()
end

function SPLFieldUIInfo.updateUIScale(arg_2_0)
	if not get_cocos_refid(arg_2_0.node) then
		return 
	end
	
	local var_2_0 = SPLCameraSystem:getScale() or 1
	
	arg_2_0.node:setScale(arg_2_0.origin_scale * arg_2_0.adjust_scale / var_2_0)
end

function SPLFieldUIInfo.updateScale(arg_3_0, arg_3_1)
	arg_3_0:updateUIScale()
end

function SPLFieldUIInfo.setVisible(arg_4_0, arg_4_1)
	if not get_cocos_refid(arg_4_0.node) then
		return 
	end
	
	arg_4_0.node:setVisible(arg_4_1)
end

function SPLFieldUIInfo.setOpacity(arg_5_0, arg_5_1)
	if not get_cocos_refid(arg_5_0.node) then
		return 
	end
	
	arg_5_0.node:setOpacity(arg_5_1)
end

function SPLFieldUIInfo.getOpacity(arg_6_0)
	if not get_cocos_refid(arg_6_0.node) then
		return 
	end
	
	return arg_6_0.node:getOpacity()
end

function SPLFieldUIInfo.updateUI(arg_7_0)
end

function SPLFieldUIInfo.remove(arg_8_0)
	if not get_cocos_refid(arg_8_0.node) then
		return 
	end
	
	arg_8_0.node:removeFromParent()
end

function SPLFieldUIInfo.setAdjustScale(arg_9_0, arg_9_1)
	if not get_cocos_refid(arg_9_0.node) then
		return 
	end
	
	arg_9_0.adjust_scale = arg_9_1
	
	arg_9_0:updateUIScale()
end

function SPLFieldUIInfo.getUID(arg_10_0)
	if not arg_10_0.opts then
		return 
	end
	
	return arg_10_0.opts.id
end

function SPLFieldUIInfo.getNode(arg_11_0)
	return arg_11_0.node
end
