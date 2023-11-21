LotaEffectRenderer = {}
LotaEffectDataInterface = {
	tile_id = 32,
	effect_name = "mapeff_battle_shine.cfx",
	pos = {
		x = 0,
		y = 0
	}
}

function LotaEffectRenderer.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.effect_layer = arg_1_1
	arg_1_0.vars.effect_data_list = {}
	arg_1_0.vars.effect_cocos_obj_list = {}
	arg_1_0.vars.y_gap = LotaWhiteboard:get("tile_y_gap")
	arg_1_0.vars.tile_width = LotaWhiteboard:get("tile_width")
	arg_1_0.vars.tile_height = LotaWhiteboard:get("tile_height")
end

function LotaEffectRenderer.addEffectData(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:addRenderEffect(arg_2_1)
	
	arg_2_0:updateRenderEffect(var_2_0, arg_2_1)
end

function LotaEffectRenderer.addRenderEffect(arg_3_0, arg_3_1)
	local var_3_0 = EffectManager:Play({
		fn = arg_3_1.effect_name,
		layer = arg_3_0.vars.effect_layer
	})
	
	table.insert(arg_3_0.vars.effect_data_list, arg_3_1)
	table.insert(arg_3_0.vars.effect_cocos_obj_list, var_3_0)
	
	return var_3_0
end

function LotaEffectRenderer.generate(arg_4_0)
	for iter_4_0 = 1, 100 do
		for iter_4_1 = 1, 100 do
			if math.random(0, 100000) > 99900 then
				local var_4_0 = table.clone(LotaEffectDataInterface)
				
				var_4_0.pos = table.clone({
					x = iter_4_0,
					y = iter_4_1
				})
				
				LotaEffectRenderer:addEffectData(var_4_0)
			end
		end
	end
end

function LotaEffectRenderer.updateRenderEffect(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.pos
	local var_5_1 = arg_5_0.vars.tile_width
	local var_5_2 = arg_5_0.vars.tile_height
	local var_5_3 = arg_5_0.vars.y_gap
	local var_5_4 = var_5_0.x * (var_5_1 / 2)
	local var_5_5 = var_5_0.y * (var_5_2 / 2) - var_5_3
	
	arg_5_1:setPosition(var_5_4, var_5_5)
	arg_5_1:setLocalZOrder(var_5_0.y * -5 + 2)
end

function LotaEffectRenderer.close(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_6_0.vars.effect_layer) then
		arg_6_0.vars.effect_layer:removeFromParent()
	end
	
	arg_6_0.vars = nil
end
