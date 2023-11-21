SPLFogSystem = {}

copy_functions(HTBFogSystem, SPLFogSystem)

function SPLFogSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:base_init(SPLInterfaceImpl.initFogRenderer, arg_1_1, arg_1_2)
end

function SPLFogSystem.createFogMapData(arg_2_0, arg_2_1)
	arg_2_0:base_createFogMapData(SPLInterfaceImpl.whiteboardGet, SPLInterfaceImpl.createFogMapData, arg_2_1)
end

function SPLFogSystem.releaseCurrentMapResource(arg_3_0)
	arg_3_0:base_releaseCurrentMapResource(SPLInterfaceImpl.fogRendererRelease)
end

function SPLFogSystem.parsingFogMap(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_0.vars then
		return 
	end
	
	local var_4_0 = arg_4_0.vars.fog_map_data:getFogCount()
	local var_4_1 = arg_4_0:runLengthDecode(arg_4_1, var_4_0)
	local var_4_2 = #var_4_1 % 2 == 1
	local var_4_3 = 3
	
	arg_4_2 = arg_4_2 or HTBFogVisibilityEnum.VISIBLE
	
	local var_4_4 = 1
	
	for iter_4_0, iter_4_1 in ipairs(var_4_1) do
		if var_4_2 == true then
			for iter_4_2 = 1, iter_4_1 do
				local var_4_5 = SPLTileMapSystem:getTileById(var_4_4)
				
				if not var_4_5 then
					break
				end
				
				local var_4_6 = var_4_5:getPos()
				
				arg_4_0:onlyDiscover(var_4_6.x, var_4_6.y, var_4_3, arg_4_2)
				
				var_4_4 = var_4_4 + 1
			end
		else
			var_4_4 = var_4_4 + iter_4_1
		end
		
		var_4_2 = not var_4_2
	end
	
	arg_4_0:renderFogs()
end

function SPLFogSystem.renderFogs(arg_5_0)
	arg_5_0:base_renderFogs(SPLInterfaceImpl.fogRendererDraw)
end

function SPLFogSystem.close(arg_6_0)
	arg_6_0:base_close(SPLInterfaceImpl.fogRendererClose)
end

function SPLFogSystem._discover(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_3 = arg_7_3 or HTBFogVisibilityEnum.VISIBLE
	
	arg_7_0.vars.fog_map_data:discoverFog(arg_7_1, arg_7_2, arg_7_3)
end

function SPLFogSystem.onlyDiscover(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_0:_discover({
		x = arg_8_1,
		y = arg_8_2
	}, arg_8_3, arg_8_4)
end

function SPLFogSystem.discover(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_0:_discover({
		x = arg_9_1,
		y = arg_9_2
	}, arg_9_3, arg_9_4)
	arg_9_0:renderFogs()
end

function SPLFogSystem.createSightMap(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	local var_10_0 = {}
	local var_10_1 = SPLMapLoader:getTileData()
	
	for iter_10_0, iter_10_1 in ipairs(var_10_1) do
		var_10_0[iter_10_0] = 0
	end
	
	return var_10_0
end

function SPLFogSystem.getFogString(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	return arg_11_0:runLengthEncode(arg_11_0.vars.fog_map_data)
end

local var_0_0 = 64

local function var_0_1(arg_12_0)
	if arg_12_0 == 0 then
		arg_12_0 = 64
	end
	
	return string.sub(Base64.base_str, arg_12_0, arg_12_0)
end

function SPLFogSystem.runLengthEncode(arg_13_0, arg_13_1)
	local var_13_0 = {}
	
	local function var_13_1(arg_14_0)
		local var_14_0 = arg_13_1:getFogDataByIdx(arg_14_0)
		
		if not var_14_0 then
			return false
		end
		
		local var_14_1 = var_14_0:getPos()
		
		return arg_13_1:isVisitedPosition(var_14_1)
	end
	
	local function var_13_2(arg_15_0, arg_15_1)
		if arg_15_0 >= var_0_0 then
			table.insert(var_13_0, var_0_1(0))
			table.insert(var_13_0, var_0_1(math.floor(arg_15_0 / var_0_0)))
			table.insert(var_13_0, var_0_1(arg_15_0 % var_0_0))
		else
			table.insert(var_13_0, var_0_1(arg_15_0))
		end
	end
	
	local var_13_3 = arg_13_1:getFogCount()
	local var_13_4 = var_13_1(1)
	local var_13_5 = 1
	
	for iter_13_0 = 2, var_13_3 do
		local var_13_6 = var_13_1(iter_13_0)
		
		if var_13_4 == var_13_6 then
			var_13_5 = var_13_5 + 1
		else
			var_13_2(var_13_5, var_13_4)
			
			var_13_4 = var_13_6
			var_13_5 = 1
		end
	end
	
	if var_13_4 then
		var_13_2(var_13_5, var_13_4)
	end
	
	if #var_13_0 == 0 then
		return 
	end
	
	return table.concat(var_13_0)
end

function SPLFogSystem.runLengthDecode(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {}
	local var_16_1 = #arg_16_1
	local var_16_2 = {}
	
	for iter_16_0 = 0, 63 do
		var_16_2[var_0_1(iter_16_0)] = iter_16_0
	end
	
	local function var_16_3(arg_17_0)
		return var_16_2[arg_17_0] or -1
	end
	
	local var_16_4 = 1
	local var_16_5 = 0
	
	while var_16_4 <= var_16_1 and var_16_5 < arg_16_2 do
		local var_16_6 = var_16_3(string.sub(arg_16_1, var_16_4, var_16_4))
		
		var_16_4 = var_16_4 + 1
		
		if var_16_6 == 0 then
			local var_16_7 = var_16_3(string.sub(arg_16_1, var_16_4, var_16_4))
			
			var_16_4 = var_16_4 + 1
			
			local var_16_8 = var_16_3(string.sub(arg_16_1, var_16_4, var_16_4))
			
			var_16_4 = var_16_4 + 1
			var_16_6 = var_16_7 * var_0_0 + var_16_8
		end
		
		if arg_16_2 < var_16_5 + var_16_6 then
			var_16_6 = arg_16_2 - var_16_5
			var_16_5 = arg_16_2
		end
		
		table.insert(var_16_0, var_16_6)
	end
	
	return var_16_0
end

function SPLFogSystem.clear(arg_18_0)
	arg_18_0:parsingFogMap(var_0_1(0) .. var_0_1(63) .. var_0_1(63))
end
