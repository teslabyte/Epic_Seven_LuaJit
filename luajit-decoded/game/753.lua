SPLTileMapSystem = {}

copy_functions(HTBTileMapSystem, SPLTileMapSystem)

function SPLTileMapSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:base_init(SPLInterfaceImpl.createTileMapData, SPLInterfaceImpl.whiteboardSet, SPLInterfaceImpl.tileRendererInit, SPLInterfaceImpl.tileRendererDraw, arg_1_1, arg_1_2)
end

function SPLTileMapSystem.loadNextMap(arg_2_0)
	arg_2_0:base_loadNextMap(SPLInterfaceImpl.tileRendererRelease, SPLInterfaceImpl.tileRendererDraw)
end

function SPLTileMapSystem.close(arg_3_0)
	arg_3_0:base_close(SPLInterfaceImpl.tileRendererClose)
end

function SPLTileMapSystem.calcWorldPosToTilePos(arg_4_0, arg_4_1, arg_4_2)
	return arg_4_0:base_calcWorldPosToTilePos(SPLInterfaceImpl.whiteboardGet, SPLInterfaceImpl.getTileSprite, arg_4_1, arg_4_2)
end

function SPLTileMapSystem.onCheckPos(arg_5_0, arg_5_1, arg_5_2)
	return arg_5_0:base_onCheckPos(SPLInterfaceImpl.getTileByPos, arg_5_1, arg_5_2)
end

function SPLTileMapSystem.updateInteractArea(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	local var_6_0 = {}
	
	local function var_6_1(arg_7_0)
		local var_7_0 = SPLTileMapSystem:getTileById(arg_7_0)
		
		if var_7_0 then
			table.insert(var_6_0, var_7_0)
		end
	end
	
	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		local var_6_2 = iter_6_1:getTileId()
		local var_6_3 = SPLObjectSystem:getObject(var_6_2)
		
		if var_6_3 then
			local var_6_4 = var_6_3:getUID()
			local var_6_5 = var_6_3:getChildTileList() or {}
			
			for iter_6_2, iter_6_3 in pairs(var_6_5) do
				var_6_1(iter_6_3)
			end
			
			var_6_1(var_6_4)
		else
			var_6_1(var_6_2)
		end
	end
	
	arg_6_0.vars.interact_area = var_6_0
	
	SPLTileMapRenderer:drawMovableArea(arg_6_1)
end

function SPLTileMapSystem.getInteractableArea(arg_8_0)
	return arg_8_0.vars and arg_8_0.vars.interact_area or {}
end

function SPLTileMapSystem.isInteractableTile(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return false
	end
	
	local var_9_0 = arg_9_0:getInteractableArea()
	
	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if arg_9_1 == iter_9_1:getTileId() then
			return true
		end
	end
	
	return false
end
