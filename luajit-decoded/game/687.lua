LotaObjectManager = ClassDef()

function LotaObjectManager.constructor(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.object_hash_map = {}
	arg_1_0.vars.object_by_type = {}
	arg_1_0.vars.select_object = nil
	
	arg_1_0:loadOverlap(arg_1_1)
end

function LotaObjectManager.createOverlap(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = LotaTileMapSystem:getTileById(arg_2_1)
	local var_2_1
	local var_2_2 = DB("clan_heritage_object_data", arg_2_2, "add_select")
	
	if var_2_2 then
		var_2_1 = LotaUtil:getChildIdList(arg_2_1, var_2_2)
	end
	
	local var_2_3 = {
		max_use = 0,
		use_count = -1,
		object_id = arg_2_2,
		tile_id = var_2_0:getTileId(),
		child_id = var_2_1
	}
	
	if not var_2_0 then
		error("LOAD FAILED LOAD FAILED LOAD FAILED BY TILE ID WAS NIL")
	end
	
	local var_2_4 = arg_2_0:addObject(var_2_0, var_2_3)
	
	LotaObjectRenderer:addRenderObject(var_2_4)
end

function LotaObjectManager.loadOverlap(arg_3_0, arg_3_1)
	if arg_3_1 ~= "LUA_TABLE_enter_ui_map" then
		for iter_3_0 = 1, 9999 do
			local var_3_0, var_3_1, var_3_2, var_3_3, var_3_4 = DBN(arg_3_1, iter_3_0, {
				"id",
				"x",
				"y",
				"tile",
				"overlap"
			})
			
			if not var_3_0 then
				break
			end
			
			if var_3_4 ~= "" and var_3_4 ~= nil then
				arg_3_0:createOverlap(var_3_0, var_3_4)
			end
		end
	else
		local var_3_5 = load_enter_ui_map()
		
		for iter_3_1, iter_3_2 in pairs(var_3_5) do
			iter_3_1 = tostring(iter_3_1)
			
			if iter_3_2.overlap then
				arg_3_0:createOverlap(iter_3_1, iter_3_2.overlap)
			end
		end
	end
end

function LotaObjectManager.releaseCurrentMapResource(arg_4_0)
	arg_4_0.vars.object_hash_map = {}
end

function LotaObjectManager.addObject(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = tostring(arg_5_2.tile_id)
	
	if arg_5_1:getTileId() ~= var_5_0 then
		LotaUtil:sendERROR("OBJECT MISMATCH : " .. "REQ TILE" .. arg_5_1:getTileId() .. " REAL ID " .. (var_5_0 or "") .. " DB? : " .. (arg_5_2.object or ""))
		
		return 
	end
	
	if arg_5_0.vars.object_hash_map[var_5_0] then
		local var_5_1 = arg_5_0.vars.object_hash_map[var_5_0]
		
		LotaUtil:sendERROR("HASH ALREADY EXISTS. CHECK. OBJ INFO : TILE ID " .. var_5_0 .. " / (NEW) " .. (arg_5_2.object or "") .. " VS (EXIST) " .. var_5_1:getDBId())
		
		return 
	end
	
	local var_5_2 = LotaObjectData(arg_5_2)
	
	arg_5_0.vars.object_hash_map[var_5_0] = var_5_2
	
	local var_5_3 = var_5_2:getTypeDetail() or "not_type_detail"
	
	if not arg_5_0.vars.object_by_type[var_5_3] then
		arg_5_0.vars.object_by_type[var_5_3] = {}
	end
	
	arg_5_0.vars.object_by_type[var_5_3][var_5_0] = var_5_2
	
	arg_5_0:setTileParent(var_5_2, arg_5_1)
	
	if var_5_2:getChildTileList() then
		for iter_5_0, iter_5_1 in pairs(var_5_2:getChildTileList()) do
			local var_5_4 = LotaTileMapSystem:getTileById(iter_5_1)
			
			arg_5_0:addObjectRef(var_5_4, arg_5_2)
		end
	end
	
	return var_5_2
end

function LotaObjectManager.addObjectRef(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = false
	
	for iter_6_0, iter_6_1 in pairs(arg_6_2.child_id) do
		if tostring(iter_6_1) == arg_6_1:getTileId() then
			var_6_0 = true
			
			break
		end
	end
	
	local var_6_1 = tostring(arg_6_2.tile_id)
	
	if not var_6_0 then
		LotaUtil:sendERROR("OBJECT MISMATCH IN CHILD ID, OBJ INFO : " .. (var_6_1 or "") .. " DB? : " .. (arg_6_2.object or ""))
		
		return 
	end
	
	local var_6_2 = arg_6_1:getTileId()
	
	if arg_6_0.vars.object_hash_map[var_6_2] then
		local var_6_3 = arg_6_0.vars.object_hash_map[var_6_2]
		
		LotaUtil:sendERROR("CHILD HASH ALREADY EXISTS. CHECK. OBJ INFO : TILE ID " .. var_6_2 .. " / (NEW) " .. (arg_6_2.object or "") .. " VS (EXIST) " .. var_6_3:getDBId())
		
		return 
	end
	
	local var_6_4 = arg_6_0.vars.object_hash_map[var_6_1]
	
	if not var_6_4 then
		LotaUtil:sendERROR("PARENT DATA NOT EXIST : PARENT ID : " .. (var_6_1 or ""))
		
		return 
	end
	
	arg_6_0.vars.object_hash_map[var_6_2] = var_6_4
	
	arg_6_0:setTileParentForRef(arg_6_1, var_6_1)
end

function LotaObjectManager.removeObjectPerTile(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.object_hash_map[arg_7_1]
	
	if not var_7_0 then
		Log.e("NOT EXIST BUT REMOVE TRY")
		
		return 
	end
	
	arg_7_0.vars.object_hash_map[arg_7_1] = nil
	arg_7_0.vars.object_by_type[var_7_0:getTypeDetail() or "not_type_detail"][var_7_0:getTileId()] = nil
end

function LotaObjectManager.removeObject(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.object_hash_map[arg_8_1]
	
	if not var_8_0 then
		Log.e("NOT EXIST BUT REMOVE TRY")
		
		return 
	end
	
	local var_8_1 = var_8_0:getChildTileList()
	
	if var_8_1 then
		local var_8_2 = var_8_0:getUID()
		
		for iter_8_0, iter_8_1 in pairs(var_8_1) do
			arg_8_0:removeObjectPerTile(iter_8_1)
			
			local var_8_3 = LotaTileMapSystem:getTileById(iter_8_1)
			
			LotaTileMapSystem:detachObject(iter_8_1)
		end
		
		arg_8_0:removeObjectPerTile(var_8_2)
		LotaTileMapSystem:detachObject(var_8_2)
	else
		arg_8_0:removeObjectPerTile(arg_8_1)
		LotaTileMapSystem:detachObject(arg_8_1)
	end
end

function LotaObjectManager.getObject(arg_9_0, arg_9_1)
	return arg_9_0.vars.object_hash_map[arg_9_1]
end

function LotaObjectManager.getObjectsByType(arg_10_0, arg_10_1)
	local var_10_0 = {}
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.object_by_type[arg_10_1] or {}) do
		table.insert(var_10_0, iter_10_1)
	end
	
	return var_10_0
end

function LotaObjectManager.removeTileParent(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1:getTileId()
	
	if var_11_0 then
		LotaTileMapSystem:detachObject(var_11_0)
	end
end

function LotaObjectManager.setTileParentForRef(arg_12_0, arg_12_1, arg_12_2)
	LotaTileMapSystem:attachObject(arg_12_1:getTileId(), arg_12_2)
end

function LotaObjectManager.setTileParent(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1:getTileId()
	
	if var_13_0 then
		LotaTileMapSystem:detachObject(var_13_0)
	end
	
	LotaTileMapSystem:attachObject(arg_13_2:getTileId(), arg_13_1:getUID())
end

function LotaObjectManager.deSelectObject(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	arg_14_0.vars.select_object = nil
end

function LotaObjectManager.onDetailObject(arg_15_0, arg_15_1)
	LotaObjectDataNotifyInterface.onDetail(arg_15_1)
end

function LotaObjectManager.onUseObject(arg_16_0, arg_16_1)
	LotaObjectDataNotifyInterface.onUse(arg_16_1)
end

function LotaObjectManager.onResponseObject(arg_17_0, arg_17_1, arg_17_2)
	LotaObjectDataNotifyInterface.onResponse(arg_17_1, arg_17_2)
end

function LotaObjectManager.onExpireObject(arg_18_0, arg_18_1)
	LotaObjectDataNotifyInterface.onExpire(arg_18_1)
end

function LotaObjectManager.onCancelObject(arg_19_0, arg_19_1)
	LotaObjectDataNotifyInterface.onCancel(arg_19_1)
end
