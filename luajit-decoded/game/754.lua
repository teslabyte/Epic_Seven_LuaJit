SPLTileMapData = ClassDef(HTBTileMapData)

function createSPLTile(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = table.clone(LotaTileInfoInterface)
	
	var_1_0.id = arg_1_0
	var_1_0.pos.x = arg_1_1
	var_1_0.pos.y = arg_1_2
	var_1_0.pos.z = arg_1_3
	var_1_0.type = arg_1_4 or "grass"
	var_1_0.tile = arg_1_5
	
	return SPLTileData(var_1_0)
end

DEBUG.SPL_START_MAP = nil

function test_spl_map(arg_2_0)
	print("map_name?", arg_2_0)
	
	local var_2_0 = string.replace(arg_2_0, ".db", "")
	
	load_db(var_2_0, "db/" .. arg_2_0)
	
	DEBUG.SPL_START_MAP = var_2_0
	
	SceneManager:nextScene("spl")
end

function load_spl_demo_map()
	local var_3_0 = {}
	
	for iter_3_0 = 1, 9999 do
		local var_3_1 = DBN(DEBUG.SPL_START_MAP or "heritage_shandra01", iter_3_0, "id")
		
		if not var_3_1 then
			break
		end
		
		local var_3_2 = SLOW_DB_ALL(DEBUG.SPL_START_MAP or "heritage_shandra01", tostring(var_3_1))
		
		table.insert(var_3_0, var_3_2)
	end
	
	if false then
		MTV:setTbl(var_3_0, "RESULT")
	end
	
	do return var_3_0 end
	return SPL_DEMO_MAP
end

function load_next_map_spl(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = {}
	
	for iter_4_0 = 1, 9999 do
		local var_4_2 = DBN("tile_sub_tile_texture", iter_4_0, "id")
		
		if not var_4_2 then
			break
		end
		
		var_4_1[tostring(var_4_2)] = true
	end
	
	local var_4_3
	
	if SPLMapLoader:isLoaded() then
		var_4_3 = SPLMapLoader:getTileData()
	else
		var_4_3 = load_spl_demo_map()
	end
	
	for iter_4_1, iter_4_2 in pairs(var_4_3) do
		iter_4_1 = tostring(iter_4_1)
		
		if iter_4_2.tile and var_4_1[iter_4_2.tile] then
			table.insert(var_4_0, createSPLTile(iter_4_1, tonumber(iter_4_2.x), tonumber(iter_4_2.y), 0, nil, iter_4_2.tile))
		else
			Log.e("NO TEXTURE", iter_4_1, iter_4_2.tile)
		end
	end
	
	return var_4_0
end

function SPLTileMapData.loadNextMap(arg_5_0, arg_5_1)
	arg_5_0.tiles = load_next_map_spl(arg_5_1)
	
	arg_5_0:loadNextMap_Core(arg_5_0.tiles)
end
