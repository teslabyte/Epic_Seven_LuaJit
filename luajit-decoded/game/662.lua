LotaFogSystem = {}

function LotaFogSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_1
	
	arg_1_0:createFogMapData(arg_1_2)
	LotaFogRenderer:init(arg_1_1)
end

function LotaFogSystem.createFogMapData(arg_2_0, arg_2_1)
	local var_2_0 = LotaWhiteboard:get("map_min_x")
	local var_2_1 = LotaWhiteboard:get("map_max_x")
	local var_2_2 = LotaWhiteboard:get("map_min_y")
	local var_2_3 = LotaWhiteboard:get("map_max_y")
	
	if not var_2_0 then
		error("MUST 'TILE MAP SYSTEM : INIT' AFTER CALL.")
	end
	
	arg_2_0.vars.fog_map_data = LotaFogMapData(arg_2_1)
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

function LotaFogSystem.hexToBin(arg_3_0, arg_3_1)
	return var_0_0[arg_3_1]
end

function LotaFogSystem.releaseCurrentMapResource(arg_4_0)
	LotaFogRenderer:release()
	arg_4_0:createFogMapData()
end

function LotaFogSystem.parsingFogMap(arg_5_0, arg_5_1, arg_5_2)
	for iter_5_0 = 1, #arg_5_1 do
		local var_5_0 = iter_5_0
		local var_5_1 = arg_5_0:hexToBin(string.sub(arg_5_1, var_5_0, var_5_0))
		
		for iter_5_1 = 1, 4 do
			local var_5_2 = string.sub(var_5_1, iter_5_1, iter_5_1)
			local var_5_3 = (iter_5_0 - 1) * 4 + iter_5_1
			local var_5_4 = LotaTileMapSystem:getTileById(tostring(var_5_3))
			
			if not var_5_4 then
				break
			end
			
			local var_5_5 = var_5_4:getPos()
			
			if var_5_2 == "1" then
				arg_5_0:onlyDiscover(var_5_5.x, var_5_5.y, LotaWhiteboard:get("map_sight_cell"), arg_5_2)
			end
		end
	end
end

function LotaFogSystem.setDiscover(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars.fog_map_data:setDiscover(arg_6_1, arg_6_2)
end

function LotaFogSystem.discoverLateRender(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_0.vars.fog_map_data:discoverFog({
		x = arg_7_1,
		y = arg_7_2
	}, arg_7_3, arg_7_4)
	
	arg_7_0.vars.request_fog_render = true
end

function LotaFogSystem.renderFogs(arg_8_0)
	LotaFogRenderer:renderFogs(arg_8_0.vars.fog_map_data, 0, 0, 100, 30)
end

function LotaFogSystem.procRender(arg_9_0)
	if arg_9_0.vars and arg_9_0.vars.request_fog_render then
		arg_9_0:renderFogs()
		
		arg_9_0.vars.request_fog_render = false
	end
end

function LotaFogSystem.getFogData(arg_10_0)
	return arg_10_0.vars.fog_map_data
end

function LotaFogSystem.getFogDiscoveredList(arg_11_0)
	return arg_11_0.vars.fog_map_data:getFogDiscoveredList()
end

function LotaFogSystem.getFogVisibility(arg_12_0, arg_12_1, arg_12_2)
	return arg_12_0.vars.fog_map_data:getFogVisibility(arg_12_1, arg_12_2)
end

function LotaFogSystem.onlyDiscover(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0.vars.fog_map_data:discoverFog({
		x = arg_13_1,
		y = arg_13_2
	}, arg_13_3, arg_13_4)
end

function LotaFogSystem.discover(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	arg_14_0.vars.fog_map_data:discoverFog({
		x = arg_14_1,
		y = arg_14_2
	}, arg_14_3, arg_14_4)
	LotaFogRenderer:renderFogs(arg_14_0.vars.fog_map_data, 0, 0, 100, 30)
end

function LotaFogSystem.onAnotherPlayerConfirmStartPos(arg_15_0, arg_15_1)
	arg_15_0:discoverLateRender(arg_15_1.x, arg_15_1.y, LotaWhiteboard:get("map_sight_cell"), LotaFogVisibilityEnum.DISCOVER)
end

function LotaFogSystem.onAnotherPlayerSyncFog(arg_16_0, arg_16_1)
	arg_16_0:discoverLateRender(arg_16_1.x, arg_16_1.y, LotaWhiteboard:get("map_sight_cell"), LotaFogVisibilityEnum.DISCOVER)
end

function LotaFogSystem.onConfirmStartPoint(arg_17_0, arg_17_1)
	arg_17_0:discoverLateRender(arg_17_1.x, arg_17_1.y, LotaWhiteboard:get("map_sight_cell"), LotaFogVisibilityEnum.VISIBLE)
end

function LotaFogSystem.onSetPosJumpTo(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = LotaFogVisibilityEnum.DISCOVER
	
	if arg_18_2 then
		var_18_0 = LotaFogVisibilityEnum.VISIBLE
	end
	
	arg_18_0:discover(arg_18_1.x, arg_18_1.y, LotaWhiteboard:get("map_sight_cell"), var_18_0)
end

function LotaFogSystem.onSetPosMoveTo(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = LotaFogVisibilityEnum.DISCOVER
	
	if arg_19_2 then
		var_19_0 = LotaFogVisibilityEnum.VISIBLE
	end
	
	arg_19_0:discover(arg_19_1.x, arg_19_1.y, LotaWhiteboard:get("map_sight_cell"), var_19_0)
end

function LotaFogSystem.close(arg_20_0)
	LotaFogRenderer:close()
end
