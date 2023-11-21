HTBMovableManager = ClassDef()

function HTBMovableManager.base_onSetPos(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0:removePosHashMap(arg_1_6, arg_1_4:getUID())
	arg_1_0:addPosHashMap(arg_1_4, arg_1_5)
	
	local var_1_0 = HTBInterface:isPlayerMovable(arg_1_1, arg_1_4:getUID())
	
	HTBInterface:onMovableSetPos(arg_1_2, arg_1_4, arg_1_7, arg_1_5, var_1_0)
	HTBInterface:onMinimapUpdate(arg_1_3, arg_1_5, arg_1_6)
end

function HTBMovableManager.base_onCheckPos(arg_2_0, arg_2_1, arg_2_2)
	return HTBInterface:onCheckPos(arg_2_1, arg_2_2)
end

function HTBMovableManager.base_addMovable(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = HTBInterface:createMovableData(arg_3_1, arg_3_2)
	
	var_3_0:notifyObject(arg_3_0)
	table.insert(arg_3_0.vars.list, var_3_0)
	arg_3_0:addPosHashMap(var_3_0)
	
	local var_3_1 = var_3_0:getUID()
	
	if arg_3_0.vars.id_hash_map[var_3_1] then
		error("UID ALREADY EXIST. CHECK. ")
		
		return 
	end
	
	arg_3_0.vars.id_hash_map[var_3_1] = var_3_0
	
	return var_3_0
end

function HTBMovableManager.constructor(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_0.vars.list = {}
	arg_4_0.vars.id_hash_map = {}
	arg_4_0.vars.pos_hash_map = {}
end

function HTBMovableManager.releaseCurrentMapResource(arg_5_0)
	arg_5_0.vars.list = {}
	arg_5_0.vars.id_hash_map = {}
	arg_5_0.vars.pos_hash_map = {}
end

function HTBMovableManager.addPosHashMap(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or arg_6_1:getPos()
	
	if not arg_6_0.vars.pos_hash_map[arg_6_2.y] then
		arg_6_0.vars.pos_hash_map[arg_6_2.y] = {}
	end
	
	local var_6_0 = arg_6_0.vars.pos_hash_map[arg_6_2.y]
	
	if not var_6_0[arg_6_2.x] then
		var_6_0[arg_6_2.x] = {}
	end
	
	local var_6_1 = var_6_0[arg_6_2.x]
	
	table.insert(var_6_1, arg_6_1)
end

function HTBMovableManager.removePosHashMap(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.vars.pos_hash_map[arg_7_1.y]
	
	if not var_7_0 then
		error("ATTEMP NOT EXIST HASH MAP. INVALID Y.")
	end
	
	local var_7_1 = var_7_0[arg_7_1.x]
	
	if not var_7_1 then
		error("ATTEMP NOT EXIST HASH MAP. INVALID X.")
	end
	
	local var_7_2
	
	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if iter_7_1:getUID() == arg_7_2 then
			var_7_2 = iter_7_0
			
			break
		end
	end
	
	if not var_7_2 then
		error("ATTEMP NOT EXIST HASH MAP. INVALID ID.")
	end
	
	arg_7_0.vars.pos_hash_map[arg_7_1.y][arg_7_1.x][var_7_2] = nil
end

function HTBMovableManager.getMovablesByPos(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.x
	local var_8_1 = arg_8_1.y
	local var_8_2 = arg_8_0.vars.pos_hash_map[var_8_1]
	
	if not var_8_2 then
		return 
	end
	
	local var_8_3 = var_8_2[var_8_0]
	
	if not var_8_3 then
		return 
	end
	
	local var_8_4 = {}
	
	for iter_8_0, iter_8_1 in pairs(var_8_3) do
		table.insert(var_8_4, iter_8_1)
	end
	
	return var_8_4
end

function HTBMovableManager.getMovableById(arg_9_0, arg_9_1)
	return arg_9_0.vars.id_hash_map[arg_9_1]
end

function HTBMovableManager.removeMovableById(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:getMovableById(arg_10_1)
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = var_10_0:getPos()
	
	if not var_10_1 then
		return 
	end
	
	arg_10_0:removePosHashMap(var_10_1, arg_10_1)
	
	arg_10_0.vars.id_hash_map[arg_10_1] = nil
	
	local var_10_2
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.list) do
		if iter_10_1.id == arg_10_1 then
			var_10_2 = iter_10_0
		end
	end
	
	if var_10_2 then
		table.remove(arg_10_0.vars.list, var_10_2)
	end
end

function HTBMovableManager.getList(arg_11_0)
	return arg_11_0.vars.list
end
