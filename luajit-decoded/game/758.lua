SPLObjectManager = ClassDef(HTBObjectManager)

function SPLObjectManager.constructor(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.object_hash_map = {}
	arg_1_0.vars.object_key_map = {}
	arg_1_0.vars.object_link_map = {}
	arg_1_0.vars.object_by_type = {}
	arg_1_0.vars.select_object = nil
end

function SPLObjectManager.onDetailObject(arg_2_0, arg_2_1)
	arg_2_0:base_onDetailObject(SPLInterfaceImpl.objectNotifyCallback, arg_2_1)
end

function SPLObjectManager.onUseObject(arg_3_0, arg_3_1)
	if not arg_3_1 or not arg_3_1:isActive() then
		return 
	end
	
	arg_3_0:base_onUseObject(SPLInterfaceImpl.objectNotifyCallback, arg_3_1)
	arg_3_0:foreachSplObject(arg_3_0.vars.object_hash_map, function(arg_4_0, arg_4_1)
		arg_3_0:hideInteractButton(arg_4_1)
	end)
	SPLEventSystem:startEvent()
end

function SPLObjectManager.onResponseObject(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:base_onResponseObject(SPLInterfaceImpl.objectNotifyCallback, arg_5_1, arg_5_2)
end

function SPLObjectManager.onExpireObject(arg_6_0, arg_6_1)
	arg_6_0:base_onExpireObject(SPLInterfaceImpl.objectNotifyCallback, arg_6_1)
	arg_6_0:removeLinkObject(arg_6_1:getDBId())
end

function SPLObjectManager.onCancelObject(arg_7_0, arg_7_1)
	arg_7_0:base_onCancelCallback(SPLInterfaceImpl.objectNotifyCallback, arg_7_1)
end

function SPLObjectManager.createOverlap(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:base_createOverlap(SPLInterfaceImpl.getTileById, SPLInterfaceImpl.getChildIdList, SPLInterfaceImpl.addObjectToRenderer, "tile_sub_object_data", "add_select", arg_8_1, arg_8_2)
end

function SPLObjectManager.removeTileParent(arg_9_0, arg_9_1)
	arg_9_0:base_removeTileParent(SPLInterfaceImpl.tileDetachObject, arg_9_1)
end

function SPLObjectManager.setTileParentForRef(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:base_setTileParentForRef(SPLInterfaceImpl.tileAttachObject, arg_10_1, arg_10_2)
end

function SPLObjectManager.setTileParent(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0:base_setTileParent(SPLInterfaceImpl.tileDetachObject, SPLInterfaceImpl.tileAttachObject, arg_11_1, arg_11_2)
end

function SPLObjectManager.removeObject(arg_12_0, arg_12_1)
	arg_12_0:base_removeObject(SPLInterfaceImpl.tileDetachObject, arg_12_1)
end

function SPLObjectManager.addObject(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2 then
		local var_13_0 = DB("tile_sub_object_data", arg_13_2.object_id, "add_trans")
		
		if var_13_0 then
			arg_13_2.trans_id = SPLUtil:getChildIdList(arg_13_1:getTileId(), var_13_0)
		end
	end
	
	local var_13_1 = arg_13_0:base_addObject(SPLInterfaceImpl.createObjectData, SPLInterfaceImpl.getTileById, arg_13_1, arg_13_2)
	
	if var_13_1 and var_13_1:getDBId() then
		arg_13_0.vars.object_key_map[var_13_1:getDBId()] = var_13_1
		
		if var_13_1:getLinkId() then
			if not arg_13_0.vars.object_link_map[var_13_1:getLinkId()] then
				arg_13_0.vars.object_link_map[var_13_1:getLinkId()] = {}
			end
			
			arg_13_0.vars.object_link_map[var_13_1:getLinkId()][var_13_1:getDBId()] = var_13_1
		end
		
		var_13_1:onCreate()
	end
	
	return var_13_1
end

function SPLObjectManager.removeObjectPerTile(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.object_hash_map[arg_14_1]
	
	if not var_14_0 then
		Log.e("NOT EXIST BUT REMOVE TRY")
		
		return 
	end
	
	local var_14_1 = var_14_0:getDBId()
	local var_14_2 = var_14_0:getLinkId()
	
	arg_14_0.vars.object_hash_map[arg_14_1] = nil
	arg_14_0.vars.object_key_map[var_14_1] = nil
	arg_14_0.vars.object_by_type[var_14_0:getTypeDetail() or "not_type_detail"][arg_14_1] = nil
	
	if arg_14_0.vars.object_key_map[var_14_2] then
		arg_14_0.vars.object_key_map[var_14_2][var_14_1] = nil
	end
end

function SPLObjectManager.removeLinkObject(arg_15_0, arg_15_1)
	if not arg_15_0.vars.object_link_map[arg_15_1] then
		return 
	end
	
	local var_15_0 = table.shallow_clone(arg_15_0.vars.object_link_map[arg_15_1] or {})
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		arg_15_0:onExpireObject(iter_15_1)
	end
	
	arg_15_0.vars.object_link_map[arg_15_1] = nil
	
	SPLEventSystem:startEvent()
end

function SPLObjectManager.getObjectByKey(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	return arg_16_0.vars.object_key_map[arg_16_1]
end

function SPLObjectManager.getObjectList(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	return arg_17_0.vars.object_hash_map
end

function SPLObjectManager.foreachSplObject(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 then
		return 
	end
	
	for iter_18_0, iter_18_1 in pairs(arg_18_1) do
		if type(arg_18_2) == "function" then
			arg_18_2(iter_18_0, iter_18_1)
		end
	end
end

function SPLObjectManager.onFinishEvent(arg_19_0)
	local var_19_0 = {}
	local var_19_1 = SPLUtil:getTileCircle(SPLMovableSystem:getPlayerPos(), 1)
	
	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		local var_19_2 = iter_19_1:getTileId()
		
		var_19_0[var_19_2] = arg_19_0:getObject(var_19_2)
	end
	
	arg_19_0:foreachSplObject(var_19_0, function(arg_20_0, arg_20_1)
		if arg_20_1:getType() == "usable" and arg_20_1:isActive() then
			arg_19_0:showInteractButton(arg_20_1)
		end
	end)
end

function SPLObjectManager.onBeginStep(arg_21_0)
	local var_21_0 = {}
	local var_21_1 = SPLUtil:getTileCircle(SPLMovableSystem:getPlayerPos(), 1)
	
	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		local var_21_2 = iter_21_1:getTileId()
		
		var_21_0[var_21_2] = arg_21_0:getObject(var_21_2)
	end
	
	arg_21_0:foreachSplObject(var_21_0, function(arg_22_0, arg_22_1)
		arg_21_0:hideInteractButton(arg_22_1)
	end)
end

function SPLObjectManager.onEndStep(arg_23_0)
	arg_23_0:foreachSplObject(arg_23_0.vars.object_hash_map, function(arg_24_0, arg_24_1)
		if arg_24_1:isMainId(arg_24_0) then
			arg_24_1:onNear()
		end
	end)
end

function SPLObjectManager.showInteractButton(arg_25_0, arg_25_1)
	local var_25_0 = SPLUtil:makeInteractButton()
	local var_25_1 = arg_25_1:getUID()
	
	SPLObjectRenderer:removeObjectUI(var_25_1)
	if_set_sprite(var_25_0, "icon", arg_25_1:getButtonIcon())
	if_set(var_25_0, "t_open", T(arg_25_1:getButtonText()))
	
	local var_25_2 = arg_25_1:getIconYPos()
	local var_25_3 = SPLObjectRenderer:addObjectUI(var_25_1, var_25_0, {
		offset_y = var_25_2
	})
	
	var_25_0:addTouchEventListener(function(arg_26_0, arg_26_1)
		if arg_26_1 ~= 2 then
			return 
		end
		
		if UIAction:Find("block") then
			return 
		end
		
		if SPLSystem:isRequireTouchIgnore() then
			return 
		end
		
		arg_26_0:setTouchEnabled(false)
		SPLSystem:playSelectSound()
		SPLObjectSystem:onUseObject(var_25_1)
	end)
	var_25_0:setScale(0)
	UIAction:Add(SPAWN(SLIDE_IN_Y(200, 200), LOG(LINEAR_CALL(200, var_25_3, "setAdjustScale", 0, 1))), var_25_0, "block")
end

function SPLObjectManager.hideInteractButton(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1:getUID()
	local var_27_1 = SPLFieldUI:getFieldUI(var_27_0)
	
	if not var_27_1 then
		return 
	end
	
	local var_27_2 = var_27_1:getNode()
	
	UIAction:Add(SEQ(LOG(FADE_OUT(400)), CALL(function()
		SPLObjectRenderer:removeObjectUI(var_27_0)
	end)), var_27_2, "block")
end
