LotaTileMapData = ClassDef()

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = 0
	local var_1_1 = 0
	local var_1_2 = arg_1_3 / 2
	local var_1_3 = arg_1_4 / 2
	
	while var_1_2 >= math.abs(var_1_0) and var_1_3 >= math.abs(var_1_1) do
		var_1_0 = var_1_0 + arg_1_1
		var_1_1 = var_1_1 + arg_1_2
		
		local var_1_4 = table.clone(LotaTileInfoInterface)
		
		var_1_4.id = (var_1_1 - 1) * 50 + var_1_0
		var_1_4.pos.x = var_1_0
		var_1_4.pos.y = var_1_1
		
		table.insert(arg_1_0, LotaTileData(var_1_4))
	end
end

function _createBaseTile(arg_2_0)
	local var_2_0 = table.clone(LotaTileInfoInterface)
	
	var_2_0.id = -50
	var_2_0.pos.x = 0
	var_2_0.pos.y = 0
	var_2_0.pos.z = 1
	var_2_0.type = "lava"
	
	table.insert(arg_2_0, LotaTileData(var_2_0))
end

function CreateTiles(arg_3_0, arg_3_1)
	local var_3_0 = {}
	
	_createBaseTile(var_3_0)
	var_0_0(var_3_0, -2, 0, arg_3_0, arg_3_1)
	var_0_0(var_3_0, -1, -1, arg_3_0, arg_3_1)
	var_0_0(var_3_0, -1, 1, arg_3_0, arg_3_1)
	var_0_0(var_3_0, 2, 0, arg_3_0, arg_3_1)
	var_0_0(var_3_0, 1, 1, arg_3_0, arg_3_1)
	var_0_0(var_3_0, 1, -1, arg_3_0, arg_3_1)
	
	return var_3_0
end

function createTile(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = table.clone(LotaTileInfoInterface)
	
	var_4_0.id = arg_4_0
	var_4_0.pos.x = arg_4_1
	var_4_0.pos.y = arg_4_2
	var_4_0.pos.z = arg_4_3
	var_4_0.type = arg_4_4 or "grass"
	var_4_0.tile = arg_4_5
	
	return LotaTileData(var_4_0)
end

function createDemoMap(arg_5_0)
	local var_5_0 = {}
	
	for iter_5_0 = 0, 15 do
		for iter_5_1 = 0, 29 do
			local var_5_1 = iter_5_1 * 2
			
			if iter_5_0 % 2 ~= 0 then
				var_5_1 = var_5_1 + 1
			end
			
			table.insert(var_5_0, createTile(var_5_1, iter_5_0, 1))
		end
	end
	
	for iter_5_2 = 0, 15 do
		var_5_0[29 + iter_5_2]:setType("lava")
	end
	
	return var_5_0
end

function GenTileMap(arg_6_0)
	local var_6_0 = {}
	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = 0
	local var_6_4 = 0
	local var_6_5 = 9999999
	local var_6_6 = 99999999
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		local var_6_7 = iter_6_1:getPos()
		
		if not var_6_0[var_6_7.y] then
			var_6_0[var_6_7.y] = {}
		end
		
		var_6_0[var_6_7.y][var_6_7.x] = iter_6_1
		
		local var_6_8 = iter_6_1:getType()
		
		if not var_6_1[var_6_8] then
			var_6_1[var_6_8] = {}
		end
		
		local var_6_9 = iter_6_1:getTileId()
		
		if var_6_2[var_6_9] then
			error("TILE ID ALREDY EXIST")
		end
		
		var_6_2[var_6_9] = iter_6_1
		
		table.insert(var_6_1[var_6_8], iter_6_1)
		
		var_6_3 = math.max(var_6_7.x, var_6_3)
		var_6_4 = math.max(var_6_7.y, var_6_4)
		var_6_5 = math.min(var_6_7.x, var_6_5)
		var_6_6 = math.min(var_6_7.y, var_6_6)
	end
	
	return var_6_0, var_6_2, var_6_1, var_6_5, var_6_6, var_6_3, var_6_4
end

LOTA_ENTER_UI_MAP = {
	[109] = {
		id = 109,
		y = 7,
		x = 26,
		tile = "tile_03"
	},
	[80] = {
		id = 80,
		y = 6,
		x = 21,
		tile = "tile_03"
	},
	[110] = {
		id = 110,
		y = 7,
		x = 28,
		tile = "tile_02"
	},
	[81] = {
		id = 81,
		y = 6,
		x = 23,
		tile = "tile_01"
	},
	[105] = {
		id = 105,
		y = 7,
		x = 18,
		tile = "start_01"
	},
	[33] = {
		id = 33,
		y = 4,
		x = 19,
		tile = "tile_02"
	},
	[108] = {
		id = 108,
		y = 7,
		x = 24,
		tile = "tile_02"
	},
	[192] = {
		id = 192,
		y = 10,
		x = 25,
		tile = "tile_02"
	},
	[82] = {
		overlap = "pillar_broken",
		y = 6,
		id = 82,
		x = 25,
		tile = "tile_02x"
	},
	[34] = {
		id = 34,
		y = 4,
		x = 21,
		tile = "tile_01"
	},
	[83] = {
		id = 83,
		y = 6,
		x = 27,
		tile = "grass_02x"
	},
	[136] = {
		id = 136,
		y = 8,
		x = 25,
		tile = "tile_01"
	},
	[35] = {
		id = 35,
		y = 4,
		x = 23,
		tile = "tile_01"
	},
	[194] = {
		id = 194,
		y = 10,
		x = 29,
		tile = "tile_02"
	},
	[137] = {
		id = 137,
		y = 8,
		x = 27,
		tile = "tile_02"
	},
	[163] = {
		id = 163,
		y = 9,
		x = 24,
		tile = "tile_02"
	},
	[107] = {
		id = 107,
		y = 7,
		x = 22,
		tile = "tile_01"
	},
	[58] = {
		id = 58,
		y = 5,
		x = 24,
		tile = "tile_02"
	},
	[55] = {
		id = 55,
		y = 5,
		x = 18,
		tile = "grass_02"
	},
	[56] = {
		id = 56,
		y = 5,
		x = 20,
		tile = "tile_02"
	},
	[59] = {
		id = 59,
		y = 5,
		x = 26,
		tile = "tile_01"
	},
	[57] = {
		id = 57,
		y = 5,
		x = 22,
		tile = "tile_03"
	},
	[134] = {
		id = 134,
		y = 8,
		x = 21,
		tile = "tile_03"
	},
	[162] = {
		id = 162,
		y = 9,
		x = 22,
		tile = "tile_03"
	},
	[106] = {
		id = 106,
		y = 7,
		x = 20,
		tile = "boss_03"
	},
	[79] = {
		id = 79,
		y = 6,
		x = 19,
		tile = "boss_02"
	},
	[190] = {
		id = 190,
		y = 10,
		x = 21,
		tile = "tile_01"
	},
	[193] = {
		id = 193,
		y = 10,
		x = 27,
		tile = "tile_02"
	},
	[191] = {
		id = 191,
		y = 10,
		x = 23,
		tile = "tile_02"
	},
	[189] = {
		id = 189,
		y = 10,
		x = 19,
		tile = "tile_03"
	},
	[166] = {
		overlap = "obstacle_2",
		y = 9,
		id = 166,
		x = 30,
		tile = "grass_01x"
	},
	[36] = {
		id = 36,
		y = 4,
		x = 25,
		tile = "tile_03"
	},
	[133] = {
		id = 133,
		y = 8,
		x = 19,
		tile = "boss_02"
	},
	[165] = {
		id = 165,
		y = 9,
		x = 28,
		tile = "tile_02"
	},
	[161] = {
		id = 161,
		y = 9,
		x = 20,
		tile = "tile_01"
	},
	[135] = {
		id = 135,
		y = 8,
		x = 23,
		tile = "tile_03"
	},
	[138] = {
		id = 138,
		y = 8,
		x = 29,
		tile = "tile_01"
	},
	[160] = {
		id = 160,
		y = 9,
		x = 18,
		tile = "tile_02"
	},
	[164] = {
		id = 164,
		y = 9,
		x = 26,
		tile = "tile_02"
	}
}

function load_enter_ui_map()
	return LOTA_ENTER_UI_MAP
end

function load_next_map(arg_8_0)
	local var_8_0 = {}
	local var_8_1 = {}
	local var_8_2 = {}
	
	for iter_8_0 = 1, 100 do
		local var_8_3 = DBN("clan_heritage_tile_texture", iter_8_0, "id")
		
		if not var_8_3 then
			break
		end
		
		var_8_1[tostring(var_8_3)] = true
	end
	
	if arg_8_0 ~= "LUA_TABLE_enter_ui_map" then
		for iter_8_1 = 1, 9999 do
			local var_8_4, var_8_5, var_8_6, var_8_7 = DBN(arg_8_0, iter_8_1, {
				"id",
				"x",
				"y",
				"tile"
			})
			
			if not var_8_4 then
				break
			end
			
			local var_8_8 = tostring(var_8_4)
			
			if var_8_7 and var_8_1[var_8_7] then
				table.insert(var_8_0, createTile(var_8_8, tonumber(var_8_5), tonumber(var_8_6), 0, nil, var_8_7))
				
				var_8_2[var_8_7] = true
			end
		end
	else
		local var_8_9 = load_enter_ui_map()
		
		for iter_8_2, iter_8_3 in pairs(var_8_9) do
			iter_8_2 = tostring(iter_8_2)
			
			if iter_8_3.tile and var_8_1[iter_8_3.tile] then
				table.insert(var_8_0, createTile(iter_8_2, tonumber(iter_8_3.x), tonumber(iter_8_3.y), 0, nil, iter_8_3.tile))
				
				var_8_2[iter_8_3.tile] = true
			end
		end
	end
	
	if LOW_RESOLUTION_MODE or not LotaUtil:isUsePreload() then
		var_8_2 = {}
	end
	
	for iter_8_4, iter_8_5 in pairs(var_8_2) do
		local var_8_10 = DB("clan_heritage_tile_texture", iter_8_4, "resource")
		
		if var_8_10 then
			local var_8_11 = "tile/" .. var_8_10 .. ".png"
			
			preload(var_8_11, var_8_11)
		end
	end
	
	return var_8_0
end

function LotaTileMapData.constructor(arg_9_0, arg_9_1, arg_9_2)
	print("theme, map_id? ", arg_9_1, arg_9_2)
	
	arg_9_0.theme = arg_9_1
	
	arg_9_0:loadNextMap(arg_9_2)
end

function LotaTileMapData.loadNextMap_Core(arg_10_0, arg_10_1)
	local var_10_0
	local var_10_1
	local var_10_2
	local var_10_3
	local var_10_4, var_10_5, var_10_6, var_10_7
	
	arg_10_0.tile_map, arg_10_0.tile_id_hash_map, arg_10_0.tile_types_hash_map, var_10_4, var_10_5, var_10_6, var_10_7 = GenTileMap(arg_10_1)
	arg_10_0.tile_width = var_10_6 - var_10_4
	arg_10_0.tile_height = var_10_7 - var_10_5
	arg_10_0.min_x = var_10_4
	arg_10_0.min_y = var_10_5
	arg_10_0.max_x = var_10_6
	arg_10_0.max_y = var_10_7
end

function LotaTileMapData.loadNextMap(arg_11_0, arg_11_1)
	arg_11_0.tiles = load_next_map(arg_11_1)
	
	arg_11_0:loadNextMap_Core(arg_11_0.tiles)
end

function LotaTileMapData.getWidth(arg_12_0)
	return arg_12_0.tile_width
end

function LotaTileMapData.getHeight(arg_13_0)
	return arg_13_0.tile_height
end

function LotaTileMapData.getMinX(arg_14_0)
	return arg_14_0.min_x
end

function LotaTileMapData.getMaxX(arg_15_0)
	return arg_15_0.max_x
end

function LotaTileMapData.getMinY(arg_16_0)
	return arg_16_0.min_y
end

function LotaTileMapData.getMaxY(arg_17_0)
	return arg_17_0.max_y
end

function LotaTileMapData.getLength(arg_18_0)
	return table.count(arg_18_0.tiles)
end

function LotaTileMapData.getTileByIndex(arg_19_0, arg_19_1)
	return arg_19_0.tiles[arg_19_1]
end

function LotaTileMapData.getTileByPos(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.x
	local var_20_1 = arg_20_1.y
	
	if not arg_20_0.tile_map[var_20_1] then
		return nil
	end
	
	if not arg_20_0.tile_map[var_20_1][var_20_0] then
		return nil
	end
	
	return arg_20_0.tile_map[var_20_1][var_20_0]
end

function LotaTileMapData.getTileIdByPos(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0:getTileByPos(arg_21_1)
	
	if not var_21_0 then
		return nil
	end
	
	return var_21_0:getTileId()
end

function LotaTileMapData.getTileById(arg_22_0, arg_22_1)
	return arg_22_0.tile_id_hash_map[arg_22_1]
end

function LotaTileMapData.getTilesArrayByType(arg_23_0, arg_23_1)
	return arg_23_0.tile_types_hash_map[arg_23_1]
end
