SPLMapLoader = {}

function spl_begin(arg_1_0)
	local var_1_0 = {
		map_id = arg_1_0 or "tile_vaf3aa_01"
	}
	
	SceneManager:nextScene("spl", var_1_0)
end

function map_loader_test(arg_2_0)
	SPLMapLoader:load(arg_2_0 or "tile_vaf3aa_01")
end

function SPLMapLoader.isLoaded(arg_3_0)
	if arg_3_0.tile_map ~= nil then
		return true
	end
	
	return false
end

function SPLMapLoader.getTileData(arg_4_0)
	return arg_4_0.tile_map
end

function SPLMapLoader.getMapId(arg_5_0)
	return arg_5_0.map_id
end

function SPLMapLoader.getOverlaps(arg_6_0)
	local var_6_0 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.tile_map) do
		if iter_6_1.overlap then
			table.insert(var_6_0, iter_6_1)
		end
	end
	
	return var_6_0
end

function SPLMapLoader.getObjects(arg_7_0)
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.tile_map) do
		if iter_7_1.object then
			table.insert(var_7_0, {
				id = iter_7_1.id,
				object = iter_7_1.object
			})
		end
		
		if iter_7_1.overlap then
			table.insert(var_7_0, {
				id = iter_7_1.id,
				object = iter_7_1.overlap
			})
		end
	end
	
	return var_7_0
end

function SPLMapLoader.load(arg_8_0, arg_8_1)
	if arg_8_0.map_id == arg_8_1 then
		print("is already loaded")
		
		return 
	end
	
	print("db_name?", arg_8_1)
	
	local var_8_0 = {}
	
	for iter_8_0 = 1, 9999 do
		local var_8_1 = DBN(arg_8_1, iter_8_0, "id")
		
		if not var_8_1 then
			break
		end
		
		local var_8_2 = SLOW_DB_ALL(arg_8_1, tostring(var_8_1))
		
		table.insert(var_8_0, var_8_2)
	end
	
	arg_8_0.tile_map = var_8_0
	arg_8_0.map_id = arg_8_1
end
