LotaMovableManager = ClassDef()

function MakeMovable(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = table.clone(LotaMovableDataInterface)
	
	var_1_0.id = arg_1_0
	var_1_0.pos.x = arg_1_1
	var_1_0.pos.y = arg_1_2
	
	return LotaMovableData(var_1_0)
end

function LotaMovableManager.onSetPos(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0:removePosHashMap(arg_2_3, arg_2_1:getUID())
	arg_2_0:addPosHashMap(arg_2_1, arg_2_2)
	
	local var_2_0 = arg_2_1:getUID() == LotaMovableSystem:getCurrentPlayerId()
	local var_2_1 = true
	
	if arg_2_4 then
		LotaMovableRenderer:setPosMovable(arg_2_1, arg_2_2)
		
		if var_2_1 then
			LotaFogSystem:onSetPosJumpTo(arg_2_2, var_2_0)
		end
	elseif var_2_1 then
		LotaFogSystem:onSetPosMoveTo(arg_2_2, var_2_0)
	end
	
	if var_2_0 then
		LotaMinimapRenderer:setPosCenter(arg_2_2)
		
		local var_2_2 = LotaTileMapSystem:getTileByPos(arg_2_3)
		local var_2_3 = LotaTileMapSystem:getTileByPos(arg_2_2)
		
		if var_2_2 then
			LotaMinimapRenderer:updateSprite(var_2_2)
		end
		
		if var_2_3 then
			LotaMinimapRenderer:updateSprite(var_2_3)
		end
	end
end

function LotaMovableManager.onCheckPos(arg_3_0, arg_3_1, arg_3_2)
	return LotaSystemInterface.onCheckPos(arg_3_2)
end

function LotaMovableManager.constructor(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_0.vars.list = {}
	arg_4_0.vars.id_hash_map = {}
	arg_4_0.vars.pos_hash_map = {}
end

function LotaMovableManager.releaseCurrentMapResource(arg_5_0)
	arg_5_0.vars.list = {}
	arg_5_0.vars.id_hash_map = {}
	arg_5_0.vars.pos_hash_map = {}
end

function LotaMovableManager.addMovable(arg_6_0, arg_6_1)
	local var_6_0 = LotaMovableData(arg_6_1)
	
	var_6_0:notifyObject(arg_6_0)
	table.insert(arg_6_0.vars.list, var_6_0)
	arg_6_0:addPosHashMap(var_6_0)
	
	local var_6_1 = var_6_0:getUID()
	
	if arg_6_0.vars.id_hash_map[var_6_1] then
		error("UID ALREADY EXIST. CHECK. ")
		
		return 
	end
	
	arg_6_0.vars.id_hash_map[var_6_1] = var_6_0
end

function LotaMovableManager.addPosHashMap(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or arg_7_1:getPos()
	
	if not arg_7_0.vars.pos_hash_map[arg_7_2.y] then
		arg_7_0.vars.pos_hash_map[arg_7_2.y] = {}
	end
	
	local var_7_0 = arg_7_0.vars.pos_hash_map[arg_7_2.y]
	
	if not var_7_0[arg_7_2.x] then
		var_7_0[arg_7_2.x] = {}
	end
	
	local var_7_1 = var_7_0[arg_7_2.x]
	
	table.insert(var_7_1, arg_7_1)
end

function LotaMovableManager.removePosHashMap(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.vars.pos_hash_map[arg_8_1.y]
	
	if not var_8_0 then
		error("ATTEMP NOT EXIST HASH MAP. INVALID Y.")
	end
	
	local var_8_1 = var_8_0[arg_8_1.x]
	
	if not var_8_1 then
		error("ATTEMP NOT EXIST HASH MAP. INVALID X.")
	end
	
	local var_8_2
	
	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		if iter_8_1:getUID() == arg_8_2 then
			var_8_2 = iter_8_0
			
			break
		end
	end
	
	if not var_8_2 then
		error("ATTEMP NOT EXIST HASH MAP. INVALID ID.")
	end
	
	arg_8_0.vars.pos_hash_map[arg_8_1.y][arg_8_1.x][var_8_2] = nil
end

function LotaMovableManager.getMovablesByPos(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.x
	local var_9_1 = arg_9_1.y
	local var_9_2 = arg_9_0.vars.pos_hash_map[var_9_1]
	
	if not var_9_2 then
		return 
	end
	
	local var_9_3 = var_9_2[var_9_0]
	
	if not var_9_3 then
		return 
	end
	
	local var_9_4 = {}
	
	for iter_9_0, iter_9_1 in pairs(var_9_3) do
		table.insert(var_9_4, iter_9_1)
	end
	
	return var_9_4
end

function LotaMovableManager.getMovableById(arg_10_0, arg_10_1)
	return arg_10_0.vars.id_hash_map[arg_10_1]
end

function LotaMovableManager.removeMovableById(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getMovableById(arg_11_1)
	
	if not var_11_0 then
		return 
	end
	
	local var_11_1 = var_11_0:getPos()
	
	if not var_11_1 then
		return 
	end
	
	arg_11_0:removePosHashMap(var_11_1, arg_11_1)
	
	arg_11_0.vars.id_hash_map[arg_11_1] = nil
	
	local var_11_2
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.list) do
		if iter_11_1.id == arg_11_1 then
			var_11_2 = iter_11_0
		end
	end
	
	if var_11_2 then
		table.remove(arg_11_0.vars.list, var_11_2)
	end
end

function LotaMovableManager.getList(arg_12_0)
	return arg_12_0.vars.list
end
