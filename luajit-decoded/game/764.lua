SPLMovableRenderer = {}

copy_functions(HTBMovableRenderer, SPLMovableRenderer)

function SPLMovableRenderer.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:base_init(SPLInterfaceImpl.whiteboardSet, arg_1_1, arg_1_2, SceneManager:getCurrentSceneName() == "spl")
	
	arg_1_0.vars.interface_create_ui_movable_info = {
		createUIMovableInfo = function(arg_2_0)
			return nil
		end
	}
end

function SPLMovableRenderer.makeMovable(arg_3_0, arg_3_1)
	return arg_3_0:base_makeMovable(false, arg_3_1)
end

function SPLMovableRenderer._addModel(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0:base__addModel(arg_4_0.vars.interface_create_ui_movable_info, arg_4_1, arg_4_2, arg_4_3)
end

function SPLMovableRenderer.calcTilePosToWorldPos(arg_5_0, arg_5_1, arg_5_2)
	return arg_5_0:base_calcTilePosToWorldPos(SPLInterfaceImpl.calcTilePosToWorldPos, arg_5_1, arg_5_2)
end

function SPLMovableRenderer.updateColor(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:base_updateColor(SPLInterfaceImpl.getFogVisibility, arg_6_1, arg_6_2)
end

function SPLMovableRenderer.setFogColorToDrawObject(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:base_setFogColorToDrawObject(SPLInterfaceImpl.whiteboardGet, arg_7_1, arg_7_2)
end

function SPLMovableRenderer.updateDrawObjectsVisible(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = {
		isProcJumpPath = function()
			return false
		end
	}
	
	arg_8_0:base_updateDrawObjectsVisible(var_8_0, arg_8_1, arg_8_2)
end

function SPLMovableRenderer.updateColorByFog(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0:base_updateColorByFog(SPLInterfaceImpl.getMovablesByPos, arg_10_1, arg_10_2, arg_10_3)
end

function SPLMovableRenderer.requirePreload(arg_11_0, arg_11_1)
	local var_11_0 = SPLTileMapSystem:getPosById(arg_11_1)
	local var_11_1 = SPLMovableSystem:getMovablesByPos(var_11_0)
	
	if not var_11_1 then
		return 
	end
	
	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		local var_11_2 = arg_11_0.vars.id_to_draw_object[iter_11_1:getUID()]
		
		if not var_11_2.model and not arg_11_0:isExceptPreloadMovable(iter_11_1.leader_code) then
			arg_11_0:preloadModel(var_11_2.model_unit)
		end
	end
end

function SPLMovableRenderer.isExceptPreloadMovable(arg_12_0, arg_12_1)
	local var_12_0 = DB("character", arg_12_1, "model_id")
	
	return SPLSystem:isExceptPreloadModel(var_12_0)
end

function SPLMovableRenderer.setVisibleMovable(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not arg_13_0.vars.deferred_create then
		return 
	end
	
	local var_13_0 = SPLMovableSystem:getMovablesByPos(SPLTileMapSystem:getPosById(arg_13_1))
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = 100 - arg_13_0.vars.deferred_created_count
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_2 = arg_13_0.vars.id_to_draw_object[iter_13_1:getUID()]
		
		if not var_13_2.model and var_13_1 > 0 then
			arg_13_0:addModel(var_13_2)
			
			var_13_1 = var_13_1 - 1
		elseif not var_13_2.model then
			arg_13_0:addTempModel(var_13_2)
		end
		
		if var_13_2.model then
			var_13_2.model:setVisible(true)
			
			var_13_2.last_visible_tm = uitick()
		end
	end
end

function SPLMovableRenderer.updateGroupView(arg_14_0, arg_14_1)
end

function SPLMovableRenderer.updatePlayerModel(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	local var_15_0 = arg_15_1:getUID()
	local var_15_1 = arg_15_0.vars.id_to_draw_object[var_15_0]
	
	if var_15_1 then
		var_15_1.model_unit = UNIT:create({
			code = arg_15_1.leader_code
		})
		
		arg_15_0:removeModel(var_15_1)
		arg_15_0:addModel(var_15_1)
	end
end

function SPLMovableRenderer.addEffect(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.layer) then
		return 
	end
	
	local var_16_0 = EffectManager:Play({
		fn = arg_16_2 or "ui_pet_act_eff.cfx",
		layer = arg_16_0.vars.layer
	})
	local var_16_1 = arg_16_0.vars.id_to_draw_object[arg_16_1:getUID()]
	local var_16_2 = arg_16_0:calcMovableWorldPos(var_16_1, arg_16_1)
	
	var_16_0:setPosition(var_16_2.x, var_16_2.y)
	var_16_0:setLocalZOrder(var_16_1:getLocalZOrder() + 1)
end
