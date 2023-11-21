LotaObjectSystem = {}

function LotaObjectSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	
	LotaObjectRenderer:init(arg_1_1)
	
	arg_1_0.vars.manager = LotaObjectManager(arg_1_2)
	arg_1_0.vars.arti_effect_info_map = {}
	arg_1_0.vars._debug_hash_map = {}
end

_LOTA_OBJECT_DEBUG_UID = 0

function LotaObjectSystem.debug_addObject(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	_LOTA_OBJECT_DEBUG_UID = _LOTA_OBJECT_DEBUG_UID + 1
	arg_2_3 = arg_2_3 or {}
	
	local var_2_0 = {
		uid = _LOTA_OBJECT_DEBUG_UID,
		object = arg_2_2,
		id = arg_2_1:getTileId()
	}
	
	for iter_2_0, iter_2_1 in pairs(arg_2_3) do
		var_2_0[iter_2_0] = iter_2_1
	end
	
	LotaUtil:createChildIdListToObjectInfo(var_2_0)
	arg_2_0:debug_addObjectByInfo(arg_2_1, var_2_0)
end

function LotaObjectSystem.debug_updateObjectInfo(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = LotaTileMapSystem:getTileById(arg_3_1)
	local var_3_1 = var_3_0:getPos()
	
	if not arg_3_2.object_id then
		arg_3_2.object_id = arg_3_2.object
	end
	
	LotaUtil:createChildIdListToObjectInfo(arg_3_2)
	
	if arg_3_0.vars._debug_hash_map[var_3_1.y] and arg_3_0.vars._debug_hash_map[var_3_1.y][var_3_1.x] then
		local var_3_2 = arg_3_0.vars._debug_hash_map[var_3_1.y][var_3_1.x]
		local var_3_3 = var_3_2.info
		local var_3_4 = tostring(arg_3_2.tile_id)
		
		if arg_3_2.object ~= var_3_3.object then
			arg_3_0:debug_removeObjectToDebugList(var_3_0)
			arg_3_0:debug_addObjectByInfo(var_3_0, arg_3_2)
		elseif var_3_3.child_id then
			for iter_3_0, iter_3_1 in pairs(var_3_3.child_id) do
				local var_3_5 = LotaTileMapSystem:getTileById(tostring(iter_3_1))
				local var_3_6 = table.clone(arg_3_2)
				local var_3_7 = var_3_5:getPos()
				
				arg_3_0.vars._debug_hash_map[var_3_7.y][var_3_7.x].info = var_3_6
			end
			
			local var_3_8 = LotaTileMapSystem:getTileById(var_3_4):getPos()
			
			arg_3_0.vars._debug_hash_map[var_3_8.y][var_3_8.x].info = arg_3_2
		else
			var_3_2.info = arg_3_2
		end
	end
end

function LotaObjectSystem.debug_removeObjectToDebugList(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1:getPos()
	
	if not arg_4_0.vars._debug_hash_map[var_4_0.y] then
		return 
	end
	
	if arg_4_0.vars._debug_hash_map[var_4_0.y][var_4_0.x] then
		local var_4_1 = arg_4_0.vars._debug_hash_map[var_4_0.y][var_4_0.x].info
		
		if var_4_1.child_id then
			for iter_4_0, iter_4_1 in pairs(var_4_1.child_id) do
				local var_4_2 = iter_4_1
				local var_4_3 = LotaTileMapSystem:getTileById(tostring(var_4_2)):getPos()
				
				arg_4_0.vars._debug_hash_map[var_4_3.y][var_4_3.x] = nil
			end
			
			arg_4_0.vars._debug_hash_map[var_4_0.y][var_4_0.x] = nil
		else
			arg_4_0.vars._debug_hash_map[var_4_0.y][var_4_0.x] = nil
		end
	end
end

function LotaObjectSystem.debug_addObjectByInfo(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:debug_addObjectToDebugList(arg_5_1, arg_5_2)
	
	if arg_5_2.child_id then
		for iter_5_0, iter_5_1 in pairs(arg_5_2.child_id) do
			local var_5_0 = LotaTileMapSystem:getTileById(tostring(iter_5_1))
			local var_5_1 = table.clone(arg_5_2)
			
			arg_5_0:debug_addObjectToDebugList(var_5_0, var_5_1)
		end
	end
end

function LotaObjectSystem.debug_addObjectToDebugList(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getPos()
	
	if not arg_6_0.vars._debug_hash_map[var_6_0.y] then
		arg_6_0.vars._debug_hash_map[var_6_0.y] = {}
	end
	
	arg_6_0.vars._debug_hash_map[var_6_0.y][var_6_0.x] = {
		tile = arg_6_1,
		info = arg_6_2
	}
end

function LotaObjectSystem.debug_getFindObject(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	if arg_7_0.vars._debug_hash_map[arg_7_1.y] then
		local var_7_0 = arg_7_0.vars._debug_hash_map[arg_7_1.y][arg_7_1.x]
		
		if var_7_0 then
			return var_7_0.info
		end
	end
	
	return nil
end

function LotaObjectSystem.debug_removeFindObjectFromHashMap(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.tile_id
	local var_8_1 = LotaTileMapSystem:getTileById(var_8_0)
	
	if var_8_1 then
		local var_8_2 = var_8_1:getPos()
		
		arg_8_0.vars._debug_hash_map[var_8_2.y][var_8_2.x] = nil
		
		local var_8_3 = arg_8_1.child_id
		
		if not var_8_3 then
			return 
		end
		
		for iter_8_0, iter_8_1 in pairs(var_8_3) do
			local var_8_4 = LotaTileMapSystem:getTileById(iter_8_1)
			
			if var_8_4 then
				local var_8_5 = var_8_4:getPos()
				
				arg_8_0.vars._debug_hash_map[var_8_5.y][var_8_5.x] = nil
			end
		end
	end
end

function LotaObjectSystem.debug_lookUpTypes(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:debug_getFindObject(arg_9_1)
	
	if not var_9_0 then
		return 
	end
	
	local var_9_1 = var_9_0.object_id or var_9_0.object
	
	return DB("clan_heritage_object_data", var_9_1, {
		"eyesight",
		"type_1",
		"type_2"
	})
end

function LotaObjectSystem.debug_findAndAdd(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:debug_getFindObject(arg_10_1)
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = var_10_0.tile_id
	local var_10_2 = LotaTileMapSystem:getTileById(var_10_1)
	
	if not var_10_2 then
		return 
	end
	
	if arg_10_0:getObject(var_10_2:getTileId()) then
		return 
	end
	
	local var_10_3 = LotaTileMapSystem:getTileById(var_10_1)
	
	if var_10_3 then
		LotaObjectSystem:addObject(var_10_3, var_10_0)
		LotaMinimapRenderer:updateSprite(var_10_3)
		arg_10_0:debug_removeFindObjectFromHashMap(var_10_0)
	end
end

function LotaObjectSystem.debug_addFromDB(arg_11_0)
	for iter_11_0 = 1, 9999 do
		local var_11_0, var_11_1, var_11_2, var_11_3 = DBN(LotaSystem:getMapId(), iter_11_0, {
			"id",
			"x",
			"y",
			"object"
		})
		
		if not var_11_0 then
			break
		end
		
		if var_11_3 then
			local var_11_4 = LotaTileMapSystem:getTileById(tostring(var_11_0))
			
			arg_11_0:debug_addObject(var_11_4, var_11_3)
		end
	end
end

function LotaObjectSystem.updateObjectState(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1:isMonsterType() then
		if not arg_12_1:isActive() and not arg_12_1:isExistAfterObject() and LotaObjectRenderer:findObject(arg_12_1:getTileId()) then
			LotaObjectRenderer:removeRenderObject(arg_12_1:getTileId(), true)
			
			local var_12_0 = LotaTileMapSystem:getTileById(arg_12_1:getTileId())
			
			LotaMinimapRenderer:updateSprite(var_12_0)
			
			if LotaBattleReady:isActive() and tostring(LotaBattleReady:getTileId()) == tostring(var_12_0:getTileId()) then
				LotaBattleReady:close()
				Dialog:msgBox(T("msg_clan_heritage_enterfail"))
			end
			
			if LotaInteractiveUI:isActive() and LotaInteractiveUI:getSelectedTileId() == arg_12_1:getTileId() then
				LotaInteractiveUI:close()
			end
		end
		
		if arg_12_1:isActive() and arg_12_1:getTypeDetail() == "normal_monster" then
			LotaObjectRenderer:updateObjectUI(arg_12_1:getTileId())
			
			if LotaBattleReady:isActive() and tostring(LotaBattleReady:getTileId()) == tostring(arg_12_1:getTileId()) then
				LotaBattleReady:setupCountClear()
			end
		end
	elseif not arg_12_1:isActive() then
		LotaObjectRenderer:updateObject(arg_12_1:getTileId())
		
		if LotaBlessingUI:isActive() and tostring(LotaBlessingUI:getTileId()) == tostring(arg_12_1:getTileId()) then
			LotaBlessingUI:close()
			balloon_message_with_sound("msg_clan_heritage_goddess_complete")
		end
	end
end

function LotaObjectSystem.updateObjectRewardState(arg_13_0, arg_13_1)
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		local var_13_1 = arg_13_0:getObject(tostring(iter_13_1.tile_id))
		
		if var_13_1 then
			arg_13_0:updateObjectState(var_13_1, var_13_0)
		end
	end
	
	LotaObjectRenderer:procRequestEffects(var_13_0)
end

function LotaObjectSystem.updateMinimapData(arg_14_0, arg_14_1)
	LotaMinimapRenderer:updateSprite(LotaTileMapSystem:getTileById(arg_14_1:getUID()))
	
	local var_14_0 = arg_14_1:getChildTileList()
	
	if var_14_0 then
		for iter_14_0, iter_14_1 in pairs(var_14_0) do
			local var_14_1 = LotaTileMapSystem:getTileById(iter_14_1)
			
			LotaMinimapRenderer:updateSprite(var_14_1)
		end
	end
end

function LotaObjectSystem.updateObjectStatus(arg_15_0, arg_15_1)
	local var_15_0 = {}
	local var_15_1 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_1.clan) do
		table.insert(var_15_1, iter_15_1)
	end
	
	for iter_15_2, iter_15_3 in pairs(arg_15_1.user) do
		table.insert(var_15_1, iter_15_3)
	end
	
	for iter_15_4, iter_15_5 in pairs(var_15_1) do
		local var_15_2 = tostring(iter_15_5.tile_id)
		local var_15_3 = arg_15_0:getObject(var_15_2)
		local var_15_4 = iter_15_5.use_count or 0
		local var_15_5 = iter_15_5.object
		
		if var_15_3 and var_15_5 ~= var_15_3:getDBId() then
			arg_15_0:removeObject(var_15_2, true)
			arg_15_0:updateMinimapData(var_15_3)
			
			local var_15_6 = LotaTileMapSystem:getTileById(var_15_2)
			
			iter_15_5.object_id = iter_15_5.object
			
			local var_15_7 = arg_15_0:addObject(var_15_6, iter_15_5)
			
			LotaCameraSystem:objectCulling()
			arg_15_0:updateMinimapData(var_15_7)
		elseif var_15_3 then
			local var_15_8 = false
			
			if var_15_3:getClanObjectUseCount() ~= var_15_4 then
				var_15_8 = true
				
				var_15_3:updateUseCount(to_n(var_15_4))
			end
			
			if iter_15_5.object_info then
				var_15_3:updateObjectInfo(iter_15_5.object_info)
			end
			
			if var_15_8 then
				arg_15_0:updateObjectState(var_15_3, var_15_0)
			end
		else
			arg_15_0:debug_updateObjectInfo(var_15_2, iter_15_5)
		end
	end
	
	LotaObjectRenderer:procRequestEffects(var_15_0)
end

function LotaObjectSystem.updateBossDeadStatus(arg_16_0, arg_16_1)
	local var_16_0 = {}
	
	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		local var_16_1 = arg_16_0:getObject(tostring(iter_16_0))
		
		if var_16_1 then
			var_16_1:updateDead(iter_16_1)
			arg_16_0:updateObjectState(var_16_1, var_16_0)
		end
	end
	
	LotaObjectRenderer:procRequestEffects(var_16_0)
end

function LotaObjectSystem.releaseCurrentMapResource(arg_17_0)
	LotaObjectRenderer:release()
	arg_17_0.vars.manager:releaseCurrentMapResource()
end

function LotaObjectSystem.getObject(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	return arg_18_0.vars.manager:getObject(tostring(arg_18_1))
end

function LotaObjectSystem.getObjectsByType(arg_19_0, arg_19_1)
	if not arg_19_0.vars then
		return 
	end
	
	return arg_19_0.vars.manager:getObjectsByType(arg_19_1)
end

function LotaObjectSystem.removeObject(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.vars.manager:removeObject(arg_20_1)
	LotaObjectRenderer:removeRenderObject(arg_20_1, arg_20_2)
end

function LotaObjectSystem.addObject(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_2 and not arg_21_2.object_id then
		arg_21_2.object_id = arg_21_2.object
	end
	
	LotaUtil:createChildIdListToObjectInfo(arg_21_2)
	
	local var_21_0 = arg_21_0.vars.manager:addObject(arg_21_1, arg_21_2)
	
	if not var_21_0:isMonsterType() or var_21_0:isActive() then
		LotaObjectRenderer:addRenderObject(var_21_0)
	end
	
	return var_21_0
end

function LotaObjectSystem.takeLastArtifactEffects(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.arti_effect_info_map[tostring(arg_22_1)]
	
	arg_22_0.vars.arti_effect_info_map[tostring(arg_22_1)] = nil
	
	return var_22_0
end

function LotaObjectSystem.addLastArtifactEffects(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.vars.arti_effect_info_map[tostring(arg_23_1)] = arg_23_2
end

function LotaObjectSystem.getObjectType(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.manager:getObject(arg_24_1)
	
	if not var_24_0 then
		return 
	end
	
	return var_24_0:getTypeDetail(), var_24_0:getType()
end

function LotaObjectSystem.isObjectDead(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.vars.manager:getObject(arg_25_1)
	
	if not var_25_0 then
		return 
	end
	
	return LotaBattleDataSystem:isBossDeadByTileId(arg_25_1, var_25_0:getDBId())
end

function LotaObjectSystem.isObjectActive(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.vars.manager:getObject(arg_26_1)
	
	if not var_26_0 then
		return 
	end
	
	return var_26_0:isActive()
end

function LotaObjectSystem.onUseObject(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.vars.manager:getObject(arg_27_1)
	
	arg_27_0.vars.manager:onUseObject(var_27_0)
end

function LotaObjectSystem.onDetailObject(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.vars.manager:getObject(arg_28_1)
	
	arg_28_0.vars.manager:onDetailObject(var_28_0)
end

function LotaObjectSystem.onResponseObject(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_2.artifact_select_pool then
		LotaUserData:updateSelectArtifacts(arg_29_2.artifact_select_pool)
		LotaLegacySelectUI:open(LotaSystem:getUIDialogLayer(), LotaUserData:getSelectableArtifacts())
	end
	
	if arg_29_2.discover then
		local var_29_0 = arg_29_2.discover.pos
		
		LotaFogSystem:discoverLateRender(var_29_0.x, var_29_0.y, arg_29_2.discover.length)
	end
	
	local var_29_1 = arg_29_0.vars.manager:getObject(arg_29_1)
	
	if var_29_1 and arg_29_2.object_info then
		var_29_1:updateObjectInfo(arg_29_2.object_info.object_info)
	end
	
	arg_29_0.vars.manager:onResponseObject(var_29_1, arg_29_2)
	
	if not var_29_1:isActive() then
		arg_29_0:onExpireObject(var_29_1:getTileId())
	end
	
	if arg_29_2.exp then
		LotaUserData:updateExp(arg_29_2.exp, true)
	end
	
	LotaUIMainLayer:updateUI()
	LotaObjectRenderer:updateObject(var_29_1:getTileId())
	
	local var_29_2 = LotaTileMapSystem:getTileById(var_29_1:getTileId())
	
	if var_29_2 then
		LotaMinimapRenderer:updateSprite(var_29_2)
	end
end

function LotaObjectSystem.updateObjectRenderStatusByType(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:getObjectsByType(arg_30_1)
	
	for iter_30_0, iter_30_1 in pairs(var_30_0 or {}) do
		LotaObjectRenderer:updateObject(iter_30_1:getTileId())
		
		local var_30_1 = LotaTileMapSystem:getTileById(iter_30_1:getTileId())
		
		if var_30_1 then
			LotaMinimapRenderer:updateSprite(var_30_1)
		end
	end
end

function LotaObjectSystem.onExpireObject(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.vars.manager:getObject(arg_31_1)
	
	arg_31_0.vars.manager:onExpireObject(var_31_0)
end

function LotaObjectSystem.close(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	LotaObjectRenderer:release()
	
	arg_32_0.vars = nil
end
