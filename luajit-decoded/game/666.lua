LotaPathFindingSystem = {}

function LotaPathFindingSystem.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.movable_paths = {
		{
			x = 1,
			y = 1
		},
		{
			x = 2,
			y = 0
		},
		{
			x = 1,
			y = -1
		},
		{
			x = -1,
			y = 1
		},
		{
			x = -2,
			y = 0
		},
		{
			x = -1,
			y = -1
		}
	}
end

PATH_FINDING_MAX_COST = 6

function LotaPathFindingSystem.getAddedPosition(arg_2_0, arg_2_1, arg_2_2)
	return LotaUtil:getAddedPosition(arg_2_1, arg_2_2)
end

function LotaPathFindingSystem.getDecedPosition(arg_3_0, arg_3_1, arg_3_2)
	return LotaUtil:getDecedPosition(arg_3_1, arg_3_2)
end

function LotaPathFindingSystem.getAbsPosition(arg_4_0, arg_4_1)
	return LotaUtil:getAbsPosition(arg_4_1)
end

function LotaPathFindingSystem.isSamePosition(arg_5_0, arg_5_1, arg_5_2)
	return LotaUtil:isSamePosition(arg_5_1, arg_5_2)
end

function LotaPathFindingSystem.getUsableTiles(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}
	local var_6_1 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_2 or {}) do
		arg_6_0:addHash(var_6_1, iter_6_1)
	end
	
	for iter_6_2, iter_6_3 in pairs(arg_6_0.vars.movable_paths) do
		local var_6_2 = arg_6_0:getAddedPosition(arg_6_1, iter_6_3)
		
		if LotaTileMapSystem:onCheckPos(var_6_2) and not arg_6_0:findHash(var_6_1, var_6_2) then
			local var_6_3 = LotaTileMapSystem:getTileIdByPos(var_6_2)
			
			var_6_2.id = var_6_3
			
			if not var_6_3 then
				print("WARN! WARN! WARN! NOT ID!")
			end
			
			table.insert(var_6_0, var_6_2)
		elseif arg_6_0.vars.include_find_object_opt and LotaTileMapSystem:onCheckPos(var_6_2, arg_6_0.vars.include_find_object_opt) and not arg_6_0:findHash(var_6_1, var_6_2) then
			var_6_2.id = LotaTileMapSystem:getTileIdByPos(var_6_2)
			var_6_2.object_tile = true
			
			table.insert(var_6_0, var_6_2)
		end
	end
	
	return var_6_0
end

function LotaPathFindingSystem.getTileCost(arg_7_0, arg_7_1, arg_7_2)
	return LotaUtil:getTileCost(arg_7_1, arg_7_2)
end

function LotaPathFindingSystem.findBestPath(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0:getUsableTiles(arg_8_1)
	local var_8_1 = 99999
	local var_8_2
	
	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if not arg_8_0:findHash(arg_8_3, iter_8_1) then
			local var_8_3 = arg_8_0:getTileCost(iter_8_1, arg_8_2)
			
			if var_8_1 ~= var_8_3 then
				local var_8_4 = var_8_1
				
				var_8_1 = math.min(var_8_1, var_8_3)
				
				if var_8_4 ~= var_8_1 then
					var_8_2 = iter_8_1
				end
			end
		end
	end
	
	if not var_8_2 then
		return 
	end
	
	return var_8_2
end

function LotaPathFindingSystem.pathStack(arg_9_0, arg_9_1, arg_9_2)
	table.insert(arg_9_0.vars.parent_paths, table.clone(arg_9_1))
	table.insert(arg_9_0.vars.parent_tiles, table.clone(arg_9_2))
end

function LotaPathFindingSystem.addParentToStack(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_0:findHash(arg_10_1, arg_10_2) then
		arg_10_0:addHash(arg_10_1, arg_10_2)
		arg_10_0:pathStack(arg_10_3, arg_10_2)
	else
		local var_10_0 = arg_10_0:getHash(arg_10_1, arg_10_2)
		local var_10_1 = arg_10_2.cost
		local var_10_2 = arg_10_0:getTileCost(arg_10_2, arg_10_0.vars.dest)
		
		if var_10_1 < var_10_0 and var_10_1 + var_10_2 < arg_10_0.vars.max_cost then
			local var_10_3 = arg_10_0:getHashKey(arg_10_2)
			
			arg_10_0:addHash(arg_10_1, arg_10_2, true)
			arg_10_0:pathStack(arg_10_3, arg_10_2)
		end
	end
end

function LotaPathFindingSystem.getHashKey(arg_11_0, arg_11_1)
	return tostring(arg_11_1.x) .. "/" .. tostring(arg_11_1.y)
end

function LotaPathFindingSystem.getHash(arg_12_0, arg_12_1, arg_12_2)
	return arg_12_1[tostring(arg_12_2.x) .. "/" .. tostring(arg_12_2.y)]
end

function LotaPathFindingSystem.addHash(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = tostring(arg_13_2.x) .. "/" .. tostring(arg_13_2.y)
	
	if arg_13_1[var_13_0] and not arg_13_3 then
		Log.e("ALREADY EXISTS, BUT ADD HASH TRYED.")
		
		return false
	end
	
	arg_13_1[var_13_0] = arg_13_2.cost or 0
	
	return true
end

function LotaPathFindingSystem.findHash(arg_14_0, arg_14_1, arg_14_2)
	return arg_14_1[tostring(arg_14_2.x) .. "/" .. tostring(arg_14_2.y)] ~= nil
end

function LotaPathFindingSystem.findIter(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if not arg_15_3.cost and not arg_15_1 then
		arg_15_3.cost = 0
	elseif not arg_15_3.cost then
		arg_15_3.cost = arg_15_1.cost + 1
	end
	
	local var_15_0 = table.clone(arg_15_3)
	local var_15_1 = false
	local var_15_2 = {}
	local var_15_3 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_2) do
		arg_15_0:addHash(var_15_2, iter_15_1)
	end
	
	for iter_15_2 = 1, #arg_15_2 do
		table.insert(var_15_3, arg_15_2[iter_15_2])
	end
	
	for iter_15_3 = 1, 99 do
		table.insert(var_15_3, var_15_0)
		
		if arg_15_0:isSamePosition(var_15_0, arg_15_4) then
			var_15_1 = true
			
			break
		end
		
		if var_15_0.cost > arg_15_0.vars.max_cost then
			break
		end
		
		arg_15_0:addHash(var_15_2, var_15_0)
		arg_15_0:addParentToStack(arg_15_0.vars.parent_hash_map, var_15_0, var_15_3)
		
		local var_15_4 = arg_15_0:findBestPath(var_15_0, arg_15_4, var_15_2)
		
		if not var_15_4 then
			break
		end
		
		var_15_0.cost, var_15_0 = var_15_0.cost + 1, table.clone(var_15_4)
	end
	
	if var_15_1 then
		return var_15_3
	else
		return false
	end
end

function LotaPathFindingSystem.makeResultPath(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {}
	
	for iter_16_0 = 1, #arg_16_2 do
		table.insert(var_16_0, arg_16_2[iter_16_0])
	end
	
	for iter_16_1 = 1, #arg_16_1 do
		table.insert(var_16_0, arg_16_1[iter_16_1])
	end
	
	return var_16_0
end

function LotaPathFindingSystem.findStep(arg_17_0, arg_17_1)
	if #arg_17_0.vars.parent_paths <= 0 then
		return 
	end
	
	arg_17_1 = arg_17_1 or arg_17_0.vars.dest
	
	local var_17_0 = arg_17_0.vars.parent_tiles[#arg_17_0.vars.parent_tiles]
	local var_17_1 = arg_17_0.vars.parent_paths[#arg_17_0.vars.parent_paths]
	
	table.remove(arg_17_0.vars.parent_paths)
	table.remove(arg_17_0.vars.parent_tiles)
	
	local var_17_2 = arg_17_0:getUsableTiles(var_17_0, var_17_1)
	
	if arg_17_0:getHashKey(var_17_0) == "63/-13" then
	end
	
	for iter_17_0, iter_17_1 in pairs(var_17_2) do
		local var_17_3 = arg_17_0:findIter(var_17_0, var_17_1, iter_17_1, arg_17_1)
		
		if var_17_3 then
			local var_17_4 = var_17_3[#var_17_3].cost
			
			if arg_17_0.vars.best_path == nil and var_17_4 <= arg_17_0.vars.max_cost then
				arg_17_0.vars.max_cost = var_17_4
				arg_17_0.vars.best_path = var_17_3
			elseif var_17_4 ~= arg_17_0.vars.max_cost and var_17_4 < arg_17_0.vars.max_cost then
				arg_17_0.vars.max_cost = var_17_4
				arg_17_0.vars.best_path = var_17_3
			end
		end
	end
end

function LotaPathFindingSystem.findInit(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0:init()
	
	local var_18_0 = LotaWhiteboard:get("map_move_cell")
	
	arg_18_3 = arg_18_3 or var_18_0
	
	local var_18_1 = math.min(PATH_FINDING_MAX_COST, arg_18_3)
	
	arg_18_0.vars.include_find_object_opt = nil
	arg_18_0.vars.parent_paths = {}
	arg_18_0.vars.parent_tiles = {}
	arg_18_0.vars.parent_hash_map = {}
	arg_18_0.vars.find_path_hash_map = {}
	arg_18_0.vars.dest = arg_18_2
	arg_18_0.vars.max_cost = var_18_1
	arg_18_0.vars.best_path = nil
	
	local var_18_2 = table.clone(arg_18_1)
	
	var_18_2.cost = 0
	
	table.insert(arg_18_0.vars.parent_tiles, var_18_2)
	table.insert(arg_18_0.vars.parent_paths, {})
end

function LotaPathFindingSystem.find(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0:findInit(arg_19_1, arg_19_2, arg_19_3)
	
	if arg_19_0:getTileCost(arg_19_1, arg_19_2) > arg_19_0.vars.max_cost then
		print("TOO FAR! COST CALC TO MACH!", arg_19_0:getTileCost(arg_19_1, arg_19_2))
		
		return false
	end
	
	if LotaUtil:isSamePosition(arg_19_1, arg_19_2) then
		return false
	end
	
	local var_19_0 = uitick()
	
	for iter_19_0 = 1, 2000 do
		if #arg_19_0.vars.parent_paths <= 0 then
			break
		end
		
		arg_19_0:findStep(arg_19_2)
	end
	
	print("ticktick", var_19_0 - uitick())
	
	if #arg_19_0.vars.parent_paths > 0 then
		Log.e("ERROR : TOO MANY DEPTH. REMAIN PARENT PATHS.")
		
		return false
	end
	
	return arg_19_0.vars.best_path
end

function LotaPathFindingSystem.getNotReachedTiles(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0:getUsableTiles(arg_20_1)
	local var_20_1 = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		local var_20_2 = table.clone(iter_20_1)
		
		var_20_2.cost = arg_20_1.cost + 1
		
		if not arg_20_0:findHash(arg_20_2, var_20_2) then
			arg_20_0:addHash(arg_20_2, var_20_2)
			table.insert(var_20_1, var_20_2)
		elseif arg_20_0:getHash(arg_20_2, var_20_2) > var_20_2.cost then
			arg_20_0:addHash(arg_20_2, var_20_2, true)
			table.insert(var_20_1, var_20_2)
		end
	end
	
	return var_20_1
end

function LotaPathFindingSystem.reachIter(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if arg_21_4 < arg_21_1.cost + 1 then
		return 
	end
	
	local var_21_0 = arg_21_0:getNotReachedTiles(arg_21_1, arg_21_3)
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		iter_21_1.cost = arg_21_1.cost + 1
		
		table.insert(arg_21_2, iter_21_1)
	end
end

function LotaPathFindingSystem.getReachableTiles(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_0:init()
	
	arg_22_0.vars.include_find_object_opt = arg_22_3
	arg_22_2 = arg_22_2 or LotaWhiteboard:get("map_move_cell")
	
	local var_22_0 = table.clone(arg_22_1)
	
	var_22_0.cost = 0
	
	local var_22_1 = {
		var_22_0
	}
	local var_22_2 = {}
	local var_22_3 = {}
	local var_22_4 = {}
	
	arg_22_0:addHash(var_22_3, var_22_0)
	
	for iter_22_0 = 1, 2000 do
		local var_22_5 = #var_22_1
		
		if var_22_5 <= 0 then
			break
		end
		
		local var_22_6 = var_22_1[var_22_5]
		
		table.remove(var_22_1)
		
		if iter_22_0 ~= 1 then
			table.insert(var_22_2, var_22_6)
		end
		
		if not var_22_6.object_tile then
			arg_22_0:reachIter(var_22_6, var_22_1, var_22_3, arg_22_2)
		end
	end
	
	return var_22_2
end
