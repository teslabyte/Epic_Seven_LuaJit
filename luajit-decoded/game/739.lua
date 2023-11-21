HTBPathFindingSystem = {}

function HTBPathFindingSystem.base_getUsableTiles(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = {}
	local var_1_1 = {}
	
	for iter_1_0, iter_1_1 in pairs(arg_1_4 or {}) do
		arg_1_0:addHash(var_1_1, iter_1_1)
	end
	
	for iter_1_2, iter_1_3 in pairs(arg_1_0.vars.movable_paths) do
		local var_1_2 = arg_1_0:getAddedPosition(arg_1_3, iter_1_3)
		
		if HTBInterface:onCheckPos(arg_1_1, var_1_2) and not arg_1_0:findHash(var_1_1, var_1_2) then
			local var_1_3 = HTBInterface:getTileIdByPos(arg_1_2, var_1_2)
			
			var_1_2.id = var_1_3
			
			if not var_1_3 then
				print("WARN! WARN! WARN! NOT ID!")
			end
			
			table.insert(var_1_0, var_1_2)
		elseif arg_1_0.vars.include_find_object_opt and HTBInterface:onCheckPos(arg_1_1, var_1_2, arg_1_0.vars.include_find_object_opt) and not arg_1_0:findHash(var_1_1, var_1_2) then
			var_1_2.id = HTBInterface:getTileIdByPos(arg_1_2, var_1_2)
			var_1_2.object_tile = true
			
			table.insert(var_1_0, var_1_2)
		end
	end
	
	return var_1_0
end

function HTBPathFindingSystem.base_findInit(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0:init()
	
	local var_2_0 = HTBInterface:whiteboardGet(arg_2_1, "map_move_cell")
	
	arg_2_4 = arg_2_4 or var_2_0 or 6
	arg_2_0.vars.include_find_object_opt = nil
	arg_2_0.vars.parent_paths = {}
	arg_2_0.vars.parent_tiles = {}
	arg_2_0.vars.parent_hash_map = {}
	arg_2_0.vars.find_path_hash_map = {}
	arg_2_0.vars.dest = arg_2_3
	arg_2_0.vars.max_cost = arg_2_4
	arg_2_0.vars.best_path = nil
	
	local var_2_1 = table.clone(arg_2_2)
	
	var_2_1.cost = 0
	
	table.insert(arg_2_0.vars.parent_tiles, var_2_1)
	table.insert(arg_2_0.vars.parent_paths, {})
end

function HTBPathFindingSystem.base_getReachableTiles(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:init()
	
	arg_3_0.vars.include_find_object_opt = arg_3_4
	arg_3_3 = arg_3_3 or HTBInterface:whiteboardGet(arg_3_1, "map_move_cell")
	
	local var_3_0 = table.clone(arg_3_2)
	
	var_3_0.cost = 0
	
	local var_3_1 = {
		var_3_0
	}
	local var_3_2 = {}
	local var_3_3 = {}
	local var_3_4 = {}
	
	arg_3_0:addHash(var_3_3, var_3_0)
	
	for iter_3_0 = 1, 2000 do
		local var_3_5 = #var_3_1
		
		if var_3_5 <= 0 then
			break
		end
		
		local var_3_6 = var_3_1[var_3_5]
		
		table.remove(var_3_1)
		
		if iter_3_0 ~= 1 then
			table.insert(var_3_2, var_3_6)
		end
		
		if not var_3_6.object_tile then
			arg_3_0:reachIter(var_3_6, var_3_1, var_3_3, arg_3_3)
		end
	end
	
	return var_3_2
end

function HTBPathFindingSystem.init(arg_4_0)
	arg_4_0.vars = {}
	arg_4_0.vars.movable_paths = {
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

function HTBPathFindingSystem.getAddedPosition(arg_5_0, arg_5_1, arg_5_2)
	return HTUtil:getAddedPosition(arg_5_1, arg_5_2)
end

function HTBPathFindingSystem.getDecedPosition(arg_6_0, arg_6_1, arg_6_2)
	return HTUtil:getDecedPosition(arg_6_1, arg_6_2)
end

function HTBPathFindingSystem.getAbsPosition(arg_7_0, arg_7_1)
	return HTUtil:getAbsPosition(arg_7_1)
end

function HTBPathFindingSystem.isSamePosition(arg_8_0, arg_8_1, arg_8_2)
	return HTUtil:isSamePosition(arg_8_1, arg_8_2)
end

function HTBPathFindingSystem.getTileCost(arg_9_0, arg_9_1, arg_9_2)
	return HTUtil:getTileCost(arg_9_1, arg_9_2)
end

function HTBPathFindingSystem.findBestPath(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0:getUsableTiles(arg_10_1)
	local var_10_1 = 99999
	local var_10_2
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if not arg_10_0:findHash(arg_10_3, iter_10_1) then
			local var_10_3 = arg_10_0:getTileCost(iter_10_1, arg_10_2)
			
			if var_10_1 ~= var_10_3 then
				local var_10_4 = var_10_1
				
				var_10_1 = math.min(var_10_1, var_10_3)
				
				if var_10_4 ~= var_10_1 then
					var_10_2 = iter_10_1
				end
			end
		end
	end
	
	if not var_10_2 then
		return 
	end
	
	return var_10_2
end

function HTBPathFindingSystem.pathStack(arg_11_0, arg_11_1, arg_11_2)
	table.insert(arg_11_0.vars.parent_paths, table.clone(arg_11_1))
	table.insert(arg_11_0.vars.parent_tiles, table.clone(arg_11_2))
end

function HTBPathFindingSystem.addParentToStack(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not arg_12_0:findHash(arg_12_1, arg_12_2) then
		arg_12_0:addHash(arg_12_1, arg_12_2)
		arg_12_0:pathStack(arg_12_3, arg_12_2)
	else
		local var_12_0 = arg_12_0:getHash(arg_12_1, arg_12_2)
		local var_12_1 = arg_12_2.cost
		local var_12_2 = arg_12_0:getTileCost(arg_12_2, arg_12_0.vars.dest)
		
		if var_12_1 < var_12_0 and var_12_1 + var_12_2 <= arg_12_0.vars.max_cost then
			local var_12_3 = arg_12_0:getHashKey(arg_12_2)
			
			arg_12_0:addHash(arg_12_1, arg_12_2, true)
			arg_12_0:pathStack(arg_12_3, arg_12_2)
		end
	end
end

function HTBPathFindingSystem.getHashKey(arg_13_0, arg_13_1)
	return tostring(arg_13_1.x) .. "/" .. tostring(arg_13_1.y)
end

function HTBPathFindingSystem.getHash(arg_14_0, arg_14_1, arg_14_2)
	return arg_14_1[tostring(arg_14_2.x) .. "/" .. tostring(arg_14_2.y)]
end

function HTBPathFindingSystem.addHash(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = tostring(arg_15_2.x) .. "/" .. tostring(arg_15_2.y)
	
	if arg_15_1[var_15_0] and not arg_15_3 then
		Log.e("ALREADY EXISTS, BUT ADD HASH TRYED.")
		
		return false
	end
	
	arg_15_1[var_15_0] = arg_15_2.cost or 0
	
	return true
end

function HTBPathFindingSystem.findHash(arg_16_0, arg_16_1, arg_16_2)
	return arg_16_1[tostring(arg_16_2.x) .. "/" .. tostring(arg_16_2.y)] ~= nil
end

function HTBPathFindingSystem.findIter(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	if not arg_17_3.cost and not arg_17_1 then
		arg_17_3.cost = 0
	elseif not arg_17_3.cost then
		arg_17_3.cost = arg_17_1.cost + 1
	end
	
	local var_17_0 = table.clone(arg_17_3)
	local var_17_1 = false
	local var_17_2 = {}
	local var_17_3 = {}
	
	for iter_17_0, iter_17_1 in pairs(arg_17_2) do
		arg_17_0:addHash(var_17_2, iter_17_1)
	end
	
	for iter_17_2 = 1, #arg_17_2 do
		table.insert(var_17_3, arg_17_2[iter_17_2])
	end
	
	for iter_17_3 = 1, 99 do
		table.insert(var_17_3, var_17_0)
		
		if arg_17_0:isSamePosition(var_17_0, arg_17_4) then
			var_17_1 = true
			
			break
		end
		
		if var_17_0.cost > arg_17_0.vars.max_cost then
			break
		end
		
		arg_17_0:addHash(var_17_2, var_17_0)
		arg_17_0:addParentToStack(arg_17_0.vars.parent_hash_map, var_17_0, var_17_3)
		
		local var_17_4 = arg_17_0:findBestPath(var_17_0, arg_17_4, var_17_2)
		
		if not var_17_4 then
			break
		end
		
		var_17_0.cost, var_17_0 = var_17_0.cost + 1, table.clone(var_17_4)
	end
	
	if var_17_1 then
		return var_17_3
	else
		return false
	end
end

function HTBPathFindingSystem.makeResultPath(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {}
	
	for iter_18_0 = 1, #arg_18_2 do
		table.insert(var_18_0, arg_18_2[iter_18_0])
	end
	
	for iter_18_1 = 1, #arg_18_1 do
		table.insert(var_18_0, arg_18_1[iter_18_1])
	end
	
	return var_18_0
end

function HTBPathFindingSystem.findStep(arg_19_0, arg_19_1)
	if #arg_19_0.vars.parent_paths <= 0 then
		return 
	end
	
	arg_19_1 = arg_19_1 or arg_19_0.vars.dest
	
	local var_19_0 = arg_19_0.vars.parent_tiles[#arg_19_0.vars.parent_tiles]
	local var_19_1 = arg_19_0.vars.parent_paths[#arg_19_0.vars.parent_paths]
	
	table.remove(arg_19_0.vars.parent_paths)
	table.remove(arg_19_0.vars.parent_tiles)
	
	local var_19_2 = arg_19_0:getUsableTiles(var_19_0, var_19_1)
	
	for iter_19_0, iter_19_1 in pairs(var_19_2) do
		local var_19_3 = arg_19_0:findIter(var_19_0, var_19_1, iter_19_1, arg_19_1)
		
		if var_19_3 then
			local var_19_4 = var_19_3[#var_19_3].cost
			
			if arg_19_0.vars.best_path == nil and var_19_4 <= arg_19_0.vars.max_cost then
				arg_19_0.vars.max_cost = var_19_4
				arg_19_0.vars.best_path = var_19_3
			elseif var_19_4 ~= arg_19_0.vars.max_cost and var_19_4 < arg_19_0.vars.max_cost then
				arg_19_0.vars.max_cost = var_19_4
				arg_19_0.vars.best_path = var_19_3
			end
		end
	end
end

function HTBPathFindingSystem.find(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0:findInit(arg_20_1, arg_20_2, arg_20_3)
	
	if arg_20_0:getTileCost(arg_20_1, arg_20_2) > arg_20_0.vars.max_cost then
		print("TOO FAR! COST CALC TO MACH!", arg_20_0:getTileCost(arg_20_1, arg_20_2))
		
		return false
	end
	
	if HTUtil:isSamePosition(arg_20_1, arg_20_2) then
		return false
	end
	
	for iter_20_0 = 1, 2000 do
		if #arg_20_0.vars.parent_paths <= 0 then
			break
		end
		
		arg_20_0:findStep(arg_20_2)
	end
	
	if #arg_20_0.vars.parent_paths > 0 then
		Log.e("ERROR : TOO MANY DEPTH. REMAIN PARENT PATHS.")
		
		return false
	end
	
	return arg_20_0.vars.best_path
end

function HTBPathFindingSystem.getNotReachedTiles(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0:getUsableTiles(arg_21_1)
	local var_21_1 = {}
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		local var_21_2 = table.clone(iter_21_1)
		
		var_21_2.cost = arg_21_1.cost + 1
		
		if not arg_21_0:findHash(arg_21_2, var_21_2) then
			arg_21_0:addHash(arg_21_2, var_21_2)
			table.insert(var_21_1, var_21_2)
		elseif arg_21_0:getHash(arg_21_2, var_21_2) > var_21_2.cost then
			arg_21_0:addHash(arg_21_2, var_21_2, true)
			table.insert(var_21_1, var_21_2)
		end
	end
	
	return var_21_1
end

function HTBPathFindingSystem.reachIter(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if arg_22_4 < arg_22_1.cost + 1 then
		return 
	end
	
	local var_22_0 = arg_22_0:getNotReachedTiles(arg_22_1, arg_22_3)
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		iter_22_1.cost = arg_22_1.cost + 1
		
		table.insert(arg_22_2, iter_22_1)
	end
end
