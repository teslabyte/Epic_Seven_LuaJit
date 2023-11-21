SPLObjectSystem = {}

copy_functions(HTBObjectSystem, SPLObjectSystem)

function SPLObjectSystem.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = SPLMapLoader:getObjects()
	
	arg_1_0:base_init({
		initObjectRenderer = function(arg_2_0, arg_2_1)
			SPLObjectRenderer:init(arg_2_1)
		end
	}, {
		createObjectManager = function(arg_3_0, arg_3_1)
			return SPLObjectManager(arg_3_1)
		end
	}, arg_1_1, arg_1_2)
	arg_1_0:loadMap(var_1_0)
end

function SPLObjectSystem.addObject(arg_4_0, arg_4_1, arg_4_2)
	return arg_4_0:base_addObject(SPLInterfaceImpl.createChildIdListToObjectInfo, SPLInterfaceImpl.objectAddRenderObject, arg_4_1, arg_4_2)
end

function SPLObjectSystem.removeObject(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:base_removeObject(SPLInterfaceImpl.objectRemoveRenderObject, arg_5_1, arg_5_2)
end

function SPLObjectSystem.updateObjectRenderStatusByType(arg_6_0, arg_6_1)
	arg_6_0:base_updateObjectRenderStatusByType(SPLInterfaceImpl.objectRendererUpdateObject, SPLInterfaceImpl.getTileById, {}, arg_6_1)
end

function SPLObjectSystem.createObject(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = SPLTileMapSystem:getTileById(arg_7_2)
	
	if not var_7_0 then
		Log.e("NO TILE", arg_7_1, arg_7_2)
		
		return 
	end
	
	while arg_7_1 and arg_7_0:isObjectCompleted(arg_7_1) do
		local var_7_1, var_7_2 = DB("tile_sub_object_data", arg_7_1, {
			"map_icon_after",
			"next_object"
		})
		
		if not var_7_2 and var_7_1 then
			break
		end
		
		arg_7_1 = var_7_2
	end
	
	if not arg_7_1 then
		return 
	end
	
	local var_7_3 = SPLUserData:getObjectByID(arg_7_1)
	local var_7_4 = {
		tile_id = arg_7_2,
		object_id = arg_7_1,
		use_count = var_7_3 and var_7_3.use_count or 0
	}
	
	return arg_7_0:addObject(var_7_0, var_7_4)
end

function SPLObjectSystem.loadMap(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		arg_8_0:createObject(iter_8_1.object, iter_8_1.id)
	end
end

function SPLObjectSystem.getObjectByKey(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return 
	end
	
	return arg_9_0.vars.manager:getObjectByKey(arg_9_1)
end

function SPLObjectSystem.getObjectList(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	return arg_10_0.vars.manager:getObjectList()
end

function SPLObjectSystem.getObjectType(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.vars.manager:getObject(arg_11_1)
	
	if not var_11_0 then
		return 
	end
	
	return var_11_0:getType()
end

function SPLObjectSystem.onResponseObject(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.manager:getObjectByKey(arg_12_1)
	
	if var_12_0 and var_12_0:isActive() then
		arg_12_0.vars.manager:onResponseObject(var_12_0, arg_12_2)
		
		if not var_12_0:isActive() then
			arg_12_0:onExpireObject(var_12_0:getTileId())
		end
	end
	
	SPLCameraSystem:objectCulling()
end

function SPLObjectSystem.onFinishEvent(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	arg_13_0.vars.manager:onFinishEvent()
end

function SPLObjectSystem.onBeginStep(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	arg_14_0.vars.manager:onBeginStep()
end

function SPLObjectSystem.onEndStep(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0.vars.manager:onEndStep()
end

function SPLObjectSystem.onUseObjectByKey(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.manager:getObjectByKey(arg_16_1)
	
	if var_16_0 and var_16_0:isActive() then
		arg_16_0:onUseObject(var_16_0:getTileId())
	end
end

function SPLObjectSystem.changeIcon(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0:getObjectByKey(arg_17_1)
	
	if not var_17_0 then
		return 
	end
	
	SPLObjectRenderer:removeRenderObject(var_17_0:getUID())
	var_17_0:setObjectOffsetDB(arg_17_2)
	SPLObjectRenderer:addRenderObject(var_17_0)
	SPLCameraSystem:objectCulling()
end

function SPLObjectSystem.isObjectCompleted(arg_18_0, arg_18_1)
	local function var_18_0(arg_19_0)
		local var_19_0 = SPLUserData:getObjectByID(arg_19_0)
		
		if not var_19_0 then
			return false
		end
		
		return DB("tile_sub_object_data", arg_19_0, "max_use") <= (var_19_0.use_count or 0)
	end
	
	local var_18_1 = DB("tile_sub_object_data", arg_18_1, "link_object")
	
	return var_18_0(arg_18_1) or var_18_0(var_18_1)
end
