SPLPathFindingSystem = {}

copy_functions(HTBPathFindingSystem, SPLPathFindingSystem)

function SPLPathFindingSystem.getUsableTiles(arg_1_0, arg_1_1, arg_1_2)
	return arg_1_0:base_getUsableTiles(SPLInterfaceImpl.onCheckPos, SPLInterfaceImpl.getTileIdByPos, arg_1_1, arg_1_2)
end

function SPLPathFindingSystem.findInit(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0:base_findInit(SPLInterfaceImpl.whiteboardGet, arg_2_1, arg_2_2, arg_2_3)
end

function SPLPathFindingSystem.getReachableTiles(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return arg_3_0:base_getReachableTiles(SPLInterfaceImpl.whiteboardGet, arg_3_1, arg_3_2, arg_3_3)
end

function SPLPathFindingSystem.findNearestTile(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0
	local var_4_1
	
	for iter_4_0, iter_4_1 in pairs(arg_4_2) do
		local var_4_2 = iter_4_1:getPos()
		local var_4_3 = arg_4_0:find(arg_4_1, var_4_2, arg_4_3)
		
		if var_4_3 and (not var_4_1 or #var_4_3 < #var_4_1) then
			var_4_0 = iter_4_1
			var_4_1 = var_4_3
		end
	end
	
	return var_4_0, var_4_1
end
