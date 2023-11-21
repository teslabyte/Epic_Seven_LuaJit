HTBBGRenderer = {}

function HTBBGRenderer.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.vars = {}
	arg_1_0.vars.parent_layer = arg_1_3
	
	local var_1_0 = DB(arg_1_1, arg_1_2, "bg_img")
	
	if not var_1_0 then
		return 
	end
	
	arg_1_0.vars.bg = SpriteCache:getSprite(var_1_0)
	
	if not arg_1_0.vars.bg then
		return 
	end
	
	local var_1_1 = arg_1_0.vars.bg:getContentSize()
	
	arg_1_0.vars.bg_width = var_1_1.width
	arg_1_0.vars.bg_height = var_1_1.height
	
	arg_1_0.vars.bg:setAnchorPoint(0, 0)
	arg_1_0.vars.bg:setPosition(0, 0)
	arg_1_0.vars.bg:setLocalZOrder(-999)
	arg_1_0.vars.parent_layer:addChild(arg_1_0.vars.bg)
	arg_1_0:syncPosition()
end

function HTBBGRenderer.base_syncPosition(arg_2_0, arg_2_1)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.bg) then
		return 
	end
	
	local var_2_0, var_2_1 = HTBInterface:getMoveRatio(arg_2_1)
	local var_2_2 = math.clamp(var_2_0, 0, 1)
	local var_2_3 = math.clamp(var_2_1, 0, 1)
	local var_2_4 = arg_2_0.vars.bg_width - VIEW_WIDTH
	local var_2_5 = arg_2_0.vars.bg_height - VIEW_HEIGHT
	local var_2_6 = var_2_4 * var_2_2
	local var_2_7 = var_2_5 * var_2_3
	
	arg_2_0.vars.bg:setPosition(-var_2_6, -var_2_7)
end
