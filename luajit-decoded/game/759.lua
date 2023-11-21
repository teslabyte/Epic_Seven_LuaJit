SPLObjectRenderer = {}

copy_functions(HTBObjectRenderer, SPLObjectRenderer)

function SPLObjectRenderer.init(arg_1_0, arg_1_1)
	arg_1_0:base_init(SPLInterfaceImpl.whiteboardGet, SceneManager:getCurrentSceneName() == "spl", "tile_sub_object_icon", arg_1_1)
end

function SPLObjectRenderer.updateObjectSprite(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:base_updateObjectSprite(SPLInterfaceImpl.getPosById, arg_2_1, arg_2_2)
end

function SPLObjectRenderer.addTempRenderObject(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0:base_addTempRenderObject(SPLInterfaceImpl.createObjectData, arg_3_1, arg_3_2, arg_3_3)
end

function SPLObjectRenderer.addRenderObject(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1:getType() == "empty" then
		return 
	end
	
	local var_4_0 = arg_4_1:getUID()
	
	if arg_4_0.vars.object_hash[var_4_0] then
		print("WARN. ALREADY EXIST. PLEASE ADD AFTER CHECK")
		
		return 
	end
	
	local var_4_1 = arg_4_0:getObjectSprite(arg_4_1)
	
	arg_4_0.vars.object_hash[var_4_0] = var_4_1
	arg_4_0.vars._object_data_hash[var_4_0] = arg_4_1
	
	arg_4_0:updateObjectSprite(var_4_1, arg_4_1)
	
	if not arg_4_2 then
		arg_4_0:_procRequestEffectsOnAdded(var_4_0, var_4_1)
	end
end

function SPLObjectRenderer.addObjectUI(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if not arg_5_0.vars or not arg_5_0.vars.object_hash then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.object_hash[arg_5_1]
	
	if not var_5_0 then
		return 
	end
	
	arg_5_3 = arg_5_3 or {}
	arg_5_3.id = arg_5_1
	arg_5_3.x, arg_5_3.y = var_5_0:getPosition()
	
	local var_5_1 = var_5_0.object_data
	
	if var_5_1 and var_5_1:getChildTileList() then
		local var_5_2, var_5_3 = var_5_1:getMiddlePosition()
		
		arg_5_3.x = arg_5_3.x + var_5_2 * arg_5_0.vars.tile_width * 0.5
		arg_5_3.y = arg_5_3.y + var_5_3 * arg_5_0.vars.tile_height
	end
	
	local var_5_4 = SPLFieldUI:addFieldUI(arg_5_2, arg_5_3)
	
	var_5_0.ui_info = var_5_4
	
	return var_5_4
end

function SPLObjectRenderer.removeObjectUI(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not arg_6_0.vars.object_hash then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.object_hash[arg_6_1]
	
	if var_6_0 and var_6_0.ui_info then
		SPLFieldUI:removeFieldUI(arg_6_1)
		
		var_6_0.ui_info = nil
	end
end

function SPLObjectRenderer.requestExpire(arg_7_0, arg_7_1)
	arg_7_0:base_requestExpire(SPLInterfaceImpl.getObject, arg_7_1)
end

function SPLObjectRenderer.updateColorByFog(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:base_updateColorByFog(SPLInterfaceImpl.getTileByPos, arg_8_1, arg_8_2, arg_8_3)
end

function SPLObjectRenderer.setRenderObjectFogColor(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:base_setRenderObjectFogColor(SPLInterfaceImpl.whiteboardGet, arg_9_1, arg_9_2)
end

function SPLObjectRenderer.getLayer(arg_10_0)
	return arg_10_0.vars and arg_10_0.vars.object_layer
end

function SPLObjectRenderer.requirePreload(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.vars.object_hash[arg_11_1]
	
	if not var_11_0 then
		return 
	end
	
	if LOW_RESOLUTION_MODE then
		return 
	end
	
	local var_11_1 = var_11_0.object_data
	
	if not var_11_0:findChildByName("render_object") and not arg_11_0:isExceptPreloadObject(var_11_1) then
		arg_11_0:preloadRenderObject(var_11_1)
	end
end

function SPLObjectRenderer.isExceptPreloadObject(arg_12_0, arg_12_1)
	if not arg_12_1:isModel() then
		return true
	end
	
	local var_12_0 = arg_12_1:getSpritePath()
	local var_12_1 = DB("character", var_12_0, "model_id")
	
	return SPLSystem:isExceptPreloadModel(var_12_1)
end

function SPLObjectRenderer.setClairPosition(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.vars then
		return 
	end
	
	local var_13_0 = {}
	local var_13_1 = SPLTileMapSystem:getTileIdByPos(arg_13_2)
	local var_13_2 = 5
	local var_13_3 = SPLUtil:getTileCircle(arg_13_2, var_13_2)
	
	for iter_13_0, iter_13_1 in pairs(var_13_3) do
		local var_13_4 = iter_13_1:getTileId()
		local var_13_5 = SPLObjectSystem:getObject(var_13_4)
		
		if var_13_5 then
			local var_13_6 = var_13_5:getUID()
			
			if not var_13_0[var_13_6] then
				local var_13_7 = var_13_5:getTransTileList() or {}
				
				if table.isInclude(var_13_7, var_13_1) then
					var_13_0[var_13_6] = true
				end
			end
		end
	end
	
	arg_13_0:_updateObjectTransparency(arg_13_1, var_13_0)
end

function SPLObjectRenderer.resetClairPosition(arg_14_0, arg_14_1)
	if not arg_14_1 then
		for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.trans_object_hash or {}) do
			arg_14_0:_updateObjectTransparency(iter_14_0, nil)
		end
	else
		arg_14_0:_updateObjectTransparency(arg_14_1, nil)
	end
end

function SPLObjectRenderer._updateObjectTransparency(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.vars then
		return 
	end
	
	if not arg_15_0.vars.trans_object_hash then
		arg_15_0.vars.trans_object_hash = {}
	end
	
	local var_15_0 = table.clone(arg_15_0.vars.trans_object_hash[arg_15_1] or {})
	
	arg_15_0.vars.trans_object_hash[arg_15_1] = arg_15_2
	
	local var_15_1 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.trans_object_hash) do
		for iter_15_2, iter_15_3 in pairs(iter_15_1) do
			var_15_1[iter_15_2] = true
		end
	end
	
	for iter_15_4, iter_15_5 in pairs(var_15_1) do
		if not var_15_0[iter_15_4] then
			arg_15_0:tweenOpacity(iter_15_4, 76)
		end
	end
	
	for iter_15_6, iter_15_7 in pairs(var_15_0) do
		if not var_15_1[iter_15_6] then
			arg_15_0:tweenOpacity(iter_15_6, 255)
		end
	end
end

function SPLObjectRenderer.showEncounterEffect(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not arg_16_0.vars.object_hash then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.object_hash[arg_16_1]
	
	if not get_cocos_refid(var_16_0) then
		return 
	end
	
	local var_16_1 = var_16_0:findChildByName("render_object")
	
	if not get_cocos_refid(var_16_1) then
		return 
	end
	
	local var_16_2, var_16_3 = var_16_0:getPosition()
	
	if var_16_1.getBonePosition then
		local var_16_4, var_16_5 = var_16_1:getBonePosition("top")
		
		var_16_2 = var_16_2 + var_16_4
		var_16_3 = var_16_3 + var_16_5
	end
	
	EffectManager:Play({
		scale = 0.5,
		fn = "ui_tile_exclamation_mark.cfx",
		layer = SPLSystem:getEffectLayer(),
		x = var_16_2,
		y = var_16_3
	})
	SoundEngine:play("event:/effect/vaf3aa_enemy_eff")
end

function SPLObjectRenderer.tweenOpacity(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0.vars or not arg_17_0.vars.object_hash then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.object_hash[arg_17_1]
	
	if not var_17_0 then
		return 
	end
	
	local var_17_1 = "spl_obj." .. arg_17_1
	
	UIAction:Remove(var_17_1)
	
	local var_17_2 = var_17_0:getOpacity() / 255
	local var_17_3 = arg_17_2 / 255
	local var_17_4 = math.abs(var_17_3 - var_17_2) * 400
	
	UIAction:Add(SEQ(OPACITY(var_17_4, var_17_2, var_17_3)), var_17_0, var_17_1)
end
