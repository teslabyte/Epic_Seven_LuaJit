HTBFogSystem = {}

function HTBFogSystem.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_2
	
	arg_1_0:createFogMapData(arg_1_3)
	HTBInterface:initFogRenderer(arg_1_1, arg_1_2)
end

function HTBFogSystem.base_createFogMapData(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = HTBInterface:whiteboardGet(arg_2_1, "map_min_x")
	local var_2_1 = HTBInterface:whiteboardGet(arg_2_1, "map_max_x")
	local var_2_2 = HTBInterface:whiteboardGet(arg_2_1, "map_min_y")
	local var_2_3 = HTBInterface:whiteboardGet(arg_2_1, "map_max_y")
	
	if not var_2_0 then
		error("MUST 'TILE MAP SYSTEM : INIT' AFTER CALL.")
	end
	
	arg_2_0.vars.map_sight_cell = HTBInterface:whiteboardGet(arg_2_1, "map_sight_cell")
	arg_2_0.vars.fog_map_data = HTBInterface:createFogMapData(arg_2_2, arg_2_3)
end

function HTBFogSystem.base_releaseCurrentMapResource(arg_3_0, arg_3_1)
	HTBInterface:fogRendererRelease(arg_3_1)
	arg_3_0:createFogMapData()
end

function HTBFogSystem.base_parsingFogMap(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	for iter_4_0 = 1, #arg_4_2 do
		local var_4_0 = iter_4_0
		local var_4_1 = arg_4_0:hexToBin(string.sub(arg_4_2, var_4_0, var_4_0))
		
		for iter_4_1 = 1, 4 do
			local var_4_2 = string.sub(var_4_1, iter_4_1, iter_4_1)
			local var_4_3 = (iter_4_0 - 1) * 4 + iter_4_1
			local var_4_4 = HTBInterface:getTileById(arg_4_1, tostring(var_4_3))
			
			if not var_4_4 then
				break
			end
			
			local var_4_5 = var_4_4:getPos()
			
			if var_4_2 == "1" then
				arg_4_0:onlyDiscover(var_4_5.x, var_4_5.y, arg_4_0.vars.map_sight_cell, arg_4_3)
			end
		end
	end
end

function HTBFogSystem.base_renderFogs(arg_5_0, arg_5_1)
	HTBInterface:fogRendererDraw(arg_5_1, arg_5_0.vars.fog_map_data)
end

function HTBFogSystem.base_close(arg_6_0, arg_6_1)
	HTBInterface:fogRendererClose(arg_6_1)
end

local var_0_0 = {
	["0"] = "0000",
	a = "1010",
	d = "1101",
	["2"] = "0010",
	["7"] = "0111",
	["3"] = "0011",
	e = "1110",
	b = "1011",
	f = "1111",
	c = "1100",
	["6"] = "0110",
	["9"] = "1001",
	["5"] = "0101",
	["1"] = "0001",
	["8"] = "1000",
	["4"] = "0100"
}

function HTBFogSystem.hexToBin(arg_7_0, arg_7_1)
	return var_0_0[arg_7_1]
end

function HTBFogSystem.setDiscover(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.vars.fog_map_data:setDiscover(arg_8_1, arg_8_2)
end

function HTBFogSystem.discoverLateRender(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_0.vars.fog_map_data:discoverFog({
		x = arg_9_1,
		y = arg_9_2
	}, arg_9_3, arg_9_4)
	
	arg_9_0.vars.request_fog_render = true
end

function HTBFogSystem.procRender(arg_10_0)
	if arg_10_0.vars and arg_10_0.vars.request_fog_render then
		arg_10_0:renderFogs()
		
		arg_10_0.vars.request_fog_render = false
	end
end

function HTBFogSystem.getFogData(arg_11_0)
	return arg_11_0.vars.fog_map_data
end

function HTBFogSystem.getFogDiscoveredList(arg_12_0)
	return arg_12_0.vars.fog_map_data:getFogDiscoveredList()
end

function HTBFogSystem.getFogVisibility(arg_13_0, arg_13_1, arg_13_2)
	return arg_13_0.vars.fog_map_data:getFogVisibility(arg_13_1, arg_13_2)
end

function HTBFogSystem.onlyDiscover(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	arg_14_0.vars.fog_map_data:discoverFog({
		x = arg_14_1,
		y = arg_14_2
	}, arg_14_3, arg_14_4)
end

function HTBFogSystem.discover(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	arg_15_0.vars.fog_map_data:discoverFog({
		x = arg_15_1,
		y = arg_15_2
	}, arg_15_3, arg_15_4)
	arg_15_0:renderFogs(arg_15_0.vars.fog_map_data)
end

function HTBFogSystem.onAnotherPlayerConfirmStartPos(arg_16_0, arg_16_1)
	arg_16_0:discoverLateRender(arg_16_1.x, arg_16_1.y, arg_16_0.vars.map_sight_cell, HTBFogVisibilityEnum.DISCOVER)
end

function HTBFogSystem.onConfirmStartPoint(arg_17_0, arg_17_1)
	arg_17_0:discoverLateRender(arg_17_1.x, arg_17_1.y, arg_17_0.vars.map_sight_cell, HTBFogVisibilityEnum.VISIBLE)
end

function HTBFogSystem.onSetPosJumpTo(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = HTBFogVisibilityEnum.DISCOVER
	
	if arg_18_2 then
		var_18_0 = HTBFogVisibilityEnum.VISIBLE
	end
	
	arg_18_0:discover(arg_18_1.x, arg_18_1.y, arg_18_0.vars.map_sight_cell, var_18_0)
end

function HTBFogSystem.onSetPosMoveTo(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = HTBFogVisibilityEnum.DISCOVER
	
	if arg_19_2 then
		var_19_0 = HTBFogVisibilityEnum.VISIBLE
	end
	
	arg_19_0:discover(arg_19_1.x, arg_19_1.y, arg_19_0.vars.map_sight_cell, var_19_0)
end
