RumbleCamera = {}

function RumbleCamera.create(arg_1_0, arg_1_1)
	local var_1_0 = {}
	
	copy_functions(arg_1_0, var_1_0)
	var_1_0:init(arg_1_1)
	
	return var_1_0
end

function RumbleCamera.init(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.create_opts = arg_2_1
	arg_2_0.vars.layers = arg_2_1.layers or arg_2_1.layer and {
		arg_2_1.layer
	} or {}
	arg_2_0.vars.camera = cc.Node:create()
	
	arg_2_0:setScale(arg_2_1.scale or 1)
	arg_2_0:setPosition(arg_2_1.x or 0, arg_2_1.y or 0)
	SceneManager:getRunningNativeScene():addChild(arg_2_0.vars.camera)
end

function RumbleCamera.update(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	for iter_3_0, iter_3_1 in ipairs(arg_3_0.vars.layers) do
		if get_cocos_refid(iter_3_1) then
			local var_3_0, var_3_1 = arg_3_0.vars.camera:getPosition()
			local var_3_2 = arg_3_0.vars.camera:getScale()
			local var_3_3 = DESIGN_WIDTH / 2 - (var_3_0 - DESIGN_WIDTH / 2) * var_3_2
			local var_3_4 = DESIGN_HEIGHT / 2 - (var_3_1 - DESIGN_HEIGHT / 2) * var_3_2
			
			iter_3_1:setPosition(var_3_3, var_3_4)
			iter_3_1:setScale(var_3_2)
		end
	end
end

function RumbleCamera.moveTo(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_0.vars then
		return 
	end
	
	BattleAction:Add(SEQ(LOG(MOVE_TO(arg_4_1 or 1000, arg_4_2, arg_4_3)), CALL(function()
		arg_4_0:setPosition(arg_4_2, arg_4_3)
	end)), arg_4_0.vars.camera)
end

function RumbleCamera.scaleTo(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0.vars then
		return 
	end
	
	BattleAction:Add(SEQ(LOG(SCALE(arg_6_1 or 1000, arg_6_0.vars.camera:getScale(), arg_6_2)), CALL(function()
		arg_6_0:setScale(arg_6_2)
	end)), arg_6_0.vars.camera)
end

function RumbleCamera.focusOnUnit(arg_8_0, arg_8_1)
	local var_8_0, var_8_1 = RumbleBoard:getPosition()
	local var_8_2 = arg_8_1:getPosition()
	local var_8_3, var_8_4 = RumbleBoard:tilePosToBoardPos(var_8_2.x, var_8_2.y)
	local var_8_5 = 80
	local var_8_6 = var_8_3 + var_8_0
	local var_8_7 = var_8_4 + var_8_1 + var_8_5
	
	arg_8_0:focus(var_8_6, var_8_7)
end

function RumbleCamera.focus(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars then
		return 
	end
	
	local var_9_0 = 2
	
	BattleAction:Add(LOG(SPAWN(MOVE_TO(500, arg_9_1, arg_9_2), SCALE(500, arg_9_0.vars.camera:getScale(), var_9_0))), arg_9_0.vars.camera)
end

function RumbleCamera.resetFocus(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	arg_10_0.vars.camera:setPosition(arg_10_0.vars.x, arg_10_0.vars.y)
	arg_10_0.vars.camera:setScale(arg_10_0.vars.scale)
end

function RumbleCamera.reset(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.create_opts
	
	arg_11_0:setScale(var_11_0.scale or 1)
	arg_11_0:setPosition(var_11_0.x or 0, var_11_0.y or 0)
end

function RumbleCamera.setScale(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		return 
	end
	
	arg_12_0.vars.scale = arg_12_1
	
	arg_12_0.vars.camera:setScale(arg_12_1)
end

function RumbleCamera.getScale(arg_13_0)
	if not arg_13_0.vars then
		return 1
	end
	
	return arg_13_0.vars.scale or 1
end

function RumbleCamera.getCameraScale(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.camera) then
		return 1
	end
	
	return arg_14_0.vars.camera:getScale()
end

function RumbleCamera.setPosition(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0.vars.x = arg_15_1
	arg_15_0.vars.y = arg_15_2
	
	arg_15_0.vars.camera:setPosition(arg_15_1, arg_15_2)
end

function RumbleCamera.getPosition(arg_16_0)
	if not arg_16_0.vars then
		return 0, 0
	end
	
	return arg_16_0.vars.x or 0, arg_16_0.vars.y or 0
end

function RumbleCamera.screenPosToWorldPos(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.x - SCREEN_WIDTH / 2
	local var_17_1 = arg_17_1.y - SCREEN_HEIGHT / 2
	local var_17_2, var_17_3 = arg_17_0:getPosition()
	local var_17_4 = arg_17_0:getScale()
	
	return {
		x = var_17_2 + var_17_0 / var_17_4,
		y = var_17_3 + var_17_1 / var_17_4
	}
end

function RumbleCamera.getCamera(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	return arg_18_0.vars.camera
end
