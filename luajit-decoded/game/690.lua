LotaBGRenderer = {}

function LotaBGRenderer.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.parent_layer = arg_1_1
	
	local var_1_0 = DB("clan_heritage_world", LotaSystem:getWorldId(), "bg_img") or "img/pvp_rta_ss1_r.png"
	
	arg_1_0.vars.bg = SpriteCache:getSprite(var_1_0)
	
	if not arg_1_0.vars.bg then
		arg_1_0.vars.bg = SpriteCache:getSprite("img/pvp_rta_ss1_r.png")
	end
	
	arg_1_0.vars.bg:setAnchorPoint(0, 0)
	
	arg_1_0.vars.pivot_x = VIEW_WIDTH / 2 + VIEW_BASE_LEFT
	arg_1_0.vars.pivot_y = VIEW_HEIGHT / 2
	
	local var_1_1 = arg_1_0.vars.bg:getContentSize()
	
	arg_1_0.vars.bg_width = var_1_1.width
	arg_1_0.vars.bg_height = var_1_1.height
	
	arg_1_0.vars.bg:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	arg_1_0.vars.bg:setLocalZOrder(-999)
	arg_1_0.vars.parent_layer:addChild(arg_1_0.vars.bg)
	arg_1_0:syncPosition()
end

function LotaBGRenderer.syncPosition(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.bg) then
		return 
	end
	
	local var_2_0, var_2_1 = LotaCameraSystem:getMoveRatio()
	local var_2_2 = arg_2_0.vars.bg_width - VIEW_WIDTH
	local var_2_3 = arg_2_0.vars.bg_height - VIEW_HEIGHT
	local var_2_4 = var_2_2 * var_2_0
	local var_2_5 = var_2_3 * var_2_1
	
	arg_2_0.vars.bg:setPosition(-var_2_4, -var_2_5)
end
