SPLFogMapData = ClassDef(HTBFogMapData)

function SPLFogMapData.setDiscover(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0:base_setDiscover(SPLInterfaceImpl.getTileByPos, SPLInterfaceImpl.getTileById, SPLInterfaceImpl.getObject, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
end

function SPLFogMapData.isVisitedPosition(arg_2_0, arg_2_1)
	if not arg_2_0.fog_discovered_list then
		return false
	end
	
	local var_2_0 = arg_2_0:getHashKey(arg_2_1)
	
	return arg_2_0.fog_discovered_list[var_2_0] ~= nil
end

function SPLFogMapData.getFogCount(arg_3_0)
	if not arg_3_0.fog_list then
		return 0
	end
	
	return #arg_3_0.fog_list
end
