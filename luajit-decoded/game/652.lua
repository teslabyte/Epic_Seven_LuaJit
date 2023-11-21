TLRenderer = {}

function TLRenderer.createInstance(arg_1_0)
	local var_1_0 = {}
	
	copy_functions(TLRenderer, var_1_0)
	
	var_1_0.CharacterRenderer = {}
	
	copy_functions(TLCharacterRenderer, var_1_0.CharacterRenderer)
	
	return var_1_0
end

function TLRenderer.create(arg_2_0)
	arg_2_0.vars = {}
	arg_2_0.vars.layer = cc.Layer:create()
	
	arg_2_0.vars.layer:setAnchorPoint(0, 0)
	arg_2_0.vars.layer:setPosition(0, 0)
	arg_2_0:createBG()
	
	return arg_2_0.vars.layer
end

function TLRenderer.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:create()
	
	arg_3_0.vars.parent_layer = arg_3_1
	
	arg_3_0.vars.parent_layer:addChild(arg_3_0.vars.layer)
end

function TLRenderer.createBG(arg_4_0)
	local var_4_0 = TLDatabase:getRenderGroupData(arg_4_0.vars.key)
	
	if var_4_0 then
		arg_4_0:setBG(var_4_0.background_id)
	end
end

function TLRenderer.getCurrentBGName(arg_5_0)
	return arg_5_0.vars.current_bg_name
end

TLRenderer.FIELD_RANGE = 800

function TLRenderer.setBG(arg_6_0, arg_6_1)
	if get_cocos_refid(arg_6_0.vars.field_layer) then
		arg_6_0.vars.field_layer:removeFromParent()
	end
	
	local var_6_0, var_6_1 = FIELD_NEW:create(arg_6_1, 2580)
	
	var_6_1:lockViewPortRange({
		minRangeX = -TLRenderer.FIELD_RANGE,
		maxRangeX = TLRenderer.FIELD_RANGE
	})
	var_6_1:updateViewport()
	
	arg_6_0.vars.current_bg_name = arg_6_1
	arg_6_0.vars.field_layer = var_6_0
	arg_6_0.vars.field = var_6_1
	
	arg_6_0.vars.layer:addChild(var_6_0)
	arg_6_0:createCharacter()
end

function TLRenderer.moveScrollRatio(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.field
	local var_7_1 = var_7_0:getViewPortPosition() + arg_7_1
	local var_7_2 = math.max(-arg_7_0.FIELD_RANGE, var_7_1)
	local var_7_3 = math.min(arg_7_0.FIELD_RANGE, var_7_2)
	
	var_7_0:setViewPortPosition(var_7_3)
	var_7_0:updateViewport()
end

function TLRenderer.setScrollRatio(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.field
	
	var_8_0:setViewPortPosition(arg_8_1)
	var_8_0:updateViewport()
end

function TLRenderer.isActive(arg_9_0)
	return arg_9_0.vars and get_cocos_refid(arg_9_0.vars.field_layer)
end

function TLRenderer.getFieldLayer(arg_10_0)
	return arg_10_0.vars.field_layer
end

function TLRenderer.getField(arg_11_0)
	return arg_11_0.vars.field
end

function TLRenderer.getScrollRatio(arg_12_0)
	return arg_12_0.vars.field:getViewPortPosition()
end

function TLRenderer.changeBackground(arg_13_0, arg_13_1)
	arg_13_0:setBG(arg_13_1)
end

function TLRenderer.getCharacterRenderer(arg_14_0)
	if arg_14_0 == TLRenderer then
		return TLCharacterRenderer
	else
		return arg_14_0.CharacterRenderer
	end
end

function TLRenderer.createCharacter(arg_15_0)
	local var_15_0 = TLDatabase:getRenderGroupData(arg_15_0.vars.key)
	local var_15_1
	
	if var_15_0 then
		var_15_1 = var_15_0.char_main_id
	end
	
	local var_15_2 = arg_15_0:getCharacterRenderer()
	
	if get_cocos_refid(arg_15_0.vars.field_layer) then
		var_15_2:init(arg_15_0.vars.field_layer, var_15_1)
	end
end
