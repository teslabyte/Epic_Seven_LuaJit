HTBObjectSystem = {}

function HTBObjectSystem.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.vars = {}
	
	HTBInterface:initObjectRenderer(arg_1_1, arg_1_3)
	
	arg_1_0.vars.manager = HTBInterface:createObjectManager(arg_1_2, arg_1_4)
	arg_1_0.vars.arti_effect_info_map = {}
	arg_1_0.vars._debug_hash_map = {}
end

function HTBObjectSystem.base_addObject(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_4 and not arg_2_4.object_id then
		arg_2_4.object_id = arg_2_4.object
	end
	
	HTBInterface:createChildIdListToObjectInfo(arg_2_1, arg_2_4)
	
	local var_2_0 = arg_2_0.vars.manager:addObject(arg_2_3, arg_2_4)
	
	if not var_2_0 then
		return 
	end
	
	if not var_2_0:isMonsterType() or var_2_0:isActive() then
		HTBInterface:objectAddRenderObject(arg_2_2, var_2_0)
	end
	
	return var_2_0
end

function HTBObjectSystem.base_removeObject(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	HTBInterface:objectRemoveRenderObject(arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.vars.manager:removeObject(arg_3_2)
end

function HTBObjectSystem.base_updateObjectRenderStatusByType(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0:getObjectsByType(arg_4_4)
	
	for iter_4_0, iter_4_1 in pairs(var_4_0 or {}) do
		HTBInterface:objectUpdateRenderObject(arg_4_1, iter_4_1:getTileId())
		
		local var_4_1 = HTBInterface:getTileById(arg_4_2, iter_4_1:getTileId())
		
		if var_4_1 then
			HTBInterface:onAfterObjectUpdate(arg_4_3, var_4_1)
		end
	end
end

function HTBObjectSystem.getObject(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	return arg_5_0.vars.manager:getObject(tostring(arg_5_1))
end

function HTBObjectSystem.getObjectsByType(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	return arg_6_0.vars.manager:getObjectsByType(arg_6_1)
end

function HTBObjectSystem.isObjectActive(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.manager:getObject(arg_7_1)
	
	if not var_7_0 then
		return 
	end
	
	return var_7_0:isActive()
end

function HTBObjectSystem.onUseObject(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.manager:getObject(arg_8_1)
	
	arg_8_0.vars.manager:onUseObject(var_8_0)
end

function HTBObjectSystem.onDetailObject(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.vars.manager:getObject(arg_9_1)
	
	arg_9_0.vars.manager:onDetailObject(var_9_0)
end

function HTBObjectSystem.onResponseObject(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.vars.manager:getObject(arg_10_1)
	
	arg_10_0.vars.manager:onResponseObject(var_10_0, arg_10_2)
end

function HTBObjectSystem.onExpireObject(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.vars.manager:getObject(arg_11_1)
	
	arg_11_0.vars.manager:onExpireObject(var_11_0)
end
