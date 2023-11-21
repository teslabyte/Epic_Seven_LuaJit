HTBObjectManager = ClassDef()

function HTBObjectManager.base_constructor(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.object_hash_map = {}
	arg_1_0.vars.object_by_type = {}
	arg_1_0.vars.select_object = nil
	
	arg_1_0:loadOverlap(arg_1_1)
end

function HTBObjectManager.base_onDetailObject(arg_2_0, arg_2_1, arg_2_2)
	HTBInterface:onDetailCallback(arg_2_1, arg_2_2)
end

function HTBObjectManager.base_onUseObject(arg_3_0, arg_3_1, arg_3_2)
	HTBInterface:onUseCallback(arg_3_1, arg_3_2)
end

function HTBObjectManager.base_onResponseObject(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	HTBInterface:onResponseCallback(arg_4_1, arg_4_2, arg_4_3)
end

function HTBObjectManager.base_onExpireObject(arg_5_0, arg_5_1, arg_5_2)
	HTBInterface:onExpireCallback(arg_5_1, arg_5_2)
end

function HTBObjectManager.base_onCancelObject(arg_6_0, arg_6_1, arg_6_2)
	HTBInterface:onCancelCallback(arg_6_1, arg_6_2)
end

function HTBObjectManager.base_createOverlap(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	local var_7_0 = HTBInterface:getTileById(arg_7_1, arg_7_6)
	local var_7_1
	local var_7_2 = DB(arg_7_4, arg_7_7, arg_7_5)
	
	if var_7_2 then
		var_7_1 = HTBInterface:getChildIdList(arg_7_2, var_7_2)
	end
	
	local var_7_3 = {
		max_use = 0,
		use_count = -1,
		object_id = arg_7_7,
		tile_id = var_7_0:getTileId(),
		child_id = var_7_1
	}
	
	if not var_7_0 then
		error("LOAD FAILED LOAD FAILED LOAD FAILED BY TILE ID WAS NIL")
	end
	
	local var_7_4 = arg_7_0:addObject(var_7_0, var_7_3)
	
	HTBInterface:addObjectToRenderer(arg_7_3, var_7_4)
end

function HTBObjectManager.base_removeTileParent(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2:getTileId()
	
	if var_8_0 then
		HTBInterface:tileDetachObject(arg_8_1, var_8_0)
	end
end

function HTBObjectManager.base_setTileParentForRef(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	HTBInterface:tileAttachObject(arg_9_1, arg_9_2:getTileId(), arg_9_3)
end

function HTBObjectManager.base_setTileParent(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_3:getTileId()
	
	if var_10_0 then
		HTBInterface:tileDetachObject(arg_10_1, var_10_0)
	end
	
	HTBInterface:tileAttachObject(arg_10_2, arg_10_4:getTileId(), arg_10_3:getUID())
end

function HTBObjectManager.base_removeObject(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.vars.object_hash_map[arg_11_2]
	
	if not var_11_0 then
		Log.e("NOT EXIST BUT REMOVE TRY")
		
		return 
	end
	
	local var_11_1 = var_11_0:getChildTileList()
	
	if var_11_1 then
		local var_11_2 = var_11_0:getUID()
		
		for iter_11_0, iter_11_1 in pairs(var_11_1) do
			arg_11_0:removeObjectPerTile(iter_11_1)
			HTBInterface:tileDetachObject(arg_11_1, iter_11_1)
		end
		
		arg_11_0:removeObjectPerTile(var_11_2)
		HTBInterface:tileDetachObject(arg_11_1, var_11_2)
	else
		arg_11_0:removeObjectPerTile(arg_11_2)
		HTBInterface:tileDetachObject(arg_11_1, arg_11_2)
	end
end

function HTBObjectManager.base_addObject(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = tostring(arg_12_4.tile_id)
	
	if arg_12_3:getTileId() ~= var_12_0 then
		HTUtil:sendERROR("OBJECT MISMATCH : " .. "REQ TILE" .. arg_12_3:getTileId() .. " REAL ID " .. (var_12_0 or "") .. " DB? : " .. (arg_12_4.object or ""))
		
		return 
	end
	
	if arg_12_0.vars.object_hash_map[var_12_0] then
		local var_12_1 = arg_12_0.vars.object_hash_map[var_12_0]
		
		HTUtil:sendERROR("HASH ALREADY EXISTS. CHECK. OBJ INFO : TILE ID " .. var_12_0 .. " / (NEW) " .. (arg_12_4.object or "") .. " VS (EXIST) " .. var_12_1:getDBId())
		
		return 
	end
	
	local var_12_2 = HTBInterface:createObjectData(arg_12_1, arg_12_4)
	
	arg_12_0.vars.object_hash_map[var_12_0] = var_12_2
	
	local var_12_3 = var_12_2:getTypeDetail() or "not_type_detail"
	
	if not arg_12_0.vars.object_by_type[var_12_3] then
		arg_12_0.vars.object_by_type[var_12_3] = {}
	end
	
	arg_12_0.vars.object_by_type[var_12_3][var_12_0] = var_12_2
	
	arg_12_0:setTileParent(var_12_2, arg_12_3)
	
	if var_12_2:getChildTileList() then
		for iter_12_0, iter_12_1 in pairs(var_12_2:getChildTileList()) do
			local var_12_4 = HTBInterface:getTileById(arg_12_2, iter_12_1)
			
			arg_12_0:addObjectRef(var_12_4, arg_12_4)
		end
	end
	
	return var_12_2
end

function HTBObjectManager.loadOverlap(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1 or load_enter_ui_map()
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		iter_13_0 = tostring(iter_13_0)
		
		if iter_13_1.overlap then
			arg_13_0:createOverlap(iter_13_0, iter_13_1.overlap)
		end
	end
end

function HTBObjectManager.releaseCurrentMapResource(arg_14_0)
	arg_14_0.vars.object_hash_map = {}
end

function HTBObjectManager.addObjectRef(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = false
	
	for iter_15_0, iter_15_1 in pairs(arg_15_2.child_id) do
		if tostring(iter_15_1) == arg_15_1:getTileId() then
			var_15_0 = true
			
			break
		end
	end
	
	local var_15_1 = tostring(arg_15_2.tile_id)
	
	if not var_15_0 then
		HTUtil:sendERROR("OBJECT MISMATCH IN CHILD ID, OBJ INFO : " .. (var_15_1 or "") .. " DB? : " .. (arg_15_2.object or ""))
		
		return 
	end
	
	local var_15_2 = arg_15_1:getTileId()
	
	if arg_15_0.vars.object_hash_map[var_15_2] then
		local var_15_3 = arg_15_0.vars.object_hash_map[var_15_2]
		
		HTUtil:sendERROR("CHILD HASH ALREADY EXISTS. CHECK. OBJ INFO : TILE ID " .. var_15_2 .. " / (NEW) " .. (arg_15_2.object or "") .. " VS (EXIST) " .. var_15_3:getDBId())
		
		return 
	end
	
	local var_15_4 = arg_15_0.vars.object_hash_map[var_15_1]
	
	if not var_15_4 then
		HTUtil:sendERROR("PARENT DATA NOT EXIST : PARENT ID : " .. (var_15_1 or ""))
		
		return 
	end
	
	arg_15_0.vars.object_hash_map[var_15_2] = var_15_4
	
	arg_15_0:setTileParentForRef(arg_15_1, var_15_1)
end

function HTBObjectManager.removeObjectPerTile(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.object_hash_map[arg_16_1]
	
	if not var_16_0 then
		Log.e("NOT EXIST BUT REMOVE TRY")
		
		return 
	end
	
	arg_16_0.vars.object_hash_map[arg_16_1] = nil
	arg_16_0.vars.object_by_type[var_16_0:getTypeDetail() or "not_type_detail"][var_16_0:getTileId()] = nil
end

function HTBObjectManager.getObject(arg_17_0, arg_17_1)
	return arg_17_0.vars.object_hash_map[arg_17_1]
end

function HTBObjectManager.getObjectsByType(arg_18_0, arg_18_1)
	local var_18_0 = {}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.object_by_type[arg_18_1] or {}) do
		table.insert(var_18_0, iter_18_1)
	end
	
	return var_18_0
end

function HTBObjectManager.deSelectObject(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	arg_19_0.vars.select_object = nil
end
