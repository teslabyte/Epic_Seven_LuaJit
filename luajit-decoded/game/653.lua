TLDatabase = {}
TLDatabase.MOCKUP_DB = {}
TLDatabase.MOCKUP_DB.GROUP = {
	test_0 = {
		background_id = "lfn_city2",
		id = "test_0",
		char_main_id = "test_char"
	}
}
TLDatabase.MOCKUP_DB.CHAR = {
	test_char_1 = {
		x = -100,
		b = 255,
		r = 255,
		target_layer = 1,
		g = 255,
		char_id = "c1002",
		y = 340,
		id = "test_char_1",
		scale = 2,
		ani = "idle"
	},
	test_char_2 = {
		x = 400,
		b = 255,
		r = 255,
		target_layer = 1,
		g = 255,
		char_id = "c1003",
		flip = "y",
		y = 340,
		id = "test_char_2",
		scale = 2,
		ani = "idle"
	},
	test_char_3 = {
		x = 400,
		b = 128,
		r = 128,
		target_layer = 10,
		g = 128,
		char_id = "c1126",
		flip = "y",
		y = 340,
		id = "test_char_3",
		scale = 1.24,
		ani = "idle"
	},
	test_char_4 = {
		x = 200,
		b = 255,
		r = 255,
		target_layer = 18,
		g = 255,
		char_id = "c1128",
		flip = "",
		y = 340,
		id = "test_char_4",
		scale = 1.24,
		ani = "idle"
	}
}

local var_0_0 = "test_castle_main_1\tc1002\t\t\t7\t255\t255\t255\t2\t-22\t200\tb_idle\ntest_castle_main_2\tc1001\t\t\t7\t255\t255\t255\t1.200000048\t140\t255\tflying\ntest_castle_main_3\tc1002\t\t\t1\t255\t255\t255\t5\t120\t-240\tidle\ntest_castle_main_4\tc1002\t\t\t1\t255\t255\t255\t2\t-185\t270\tcamping\ntest_castle_main_5\tc1003\t\t\t22\t255\t255\t255\t1\t-190\t320\tcamping\ntest_castle_main_6\tc1002\t\t\t1\t255\t255\t255\t2\t-100\t340\tidle\ntest_castle_main_7\tc1062\t\t\t0\t255\t255\t255\t2\t-380\t200\tcamping\ntest_castle_main_8\tc1076\t\t\t0\t255\t255\t255\t2.299999952\t500\t200\tcamping\ty\ntest_castle_main_9\tc1018\t\t\t23\t255\t255\t255\t0.800000012\t220\t320\tcamping\ty\ntest_castle_main_10\tc2062\t\t\t22\t128\t128\t128\t1.200000048\t-540\t340\tidle\ntest_castle_main_11\tc1076\tc1076_s01\t\t0\t255\t255\t255\t2\t550\t80\tidle\ntest_castle_main_12\tc1062\tc1062_s01\t\t\t0\t255\t255\t255\t2.5\t-470\t140\tidle\ntest_castle_main_13\tc1100\t\t\t22\t255\t255\t255\t0.800000012\t270\t340\tcamping\ty\ntest_castle_main_14\tc1001\t\t\t1\t255\t255\t255\t4\t640\t0\tidle\n\n"
local var_0_1 = "test_castle_sub1_1\tc1095\t\t\t0\t255\t255\t255\t1.399999976\t-310\t80\tb_idle\ntest_castle_sub1_2\tc1082\t\t\t27\t255\t255\t255\t2\t-300\t-120\tcamping\ntest_castle_sub1_3\tc1074\t\t\t27\t255\t255\t255\t2\t-190\t-120\tcamping\ty\ntest_castle_sub1_5\tc2082\t\t\t0\t255\t255\t255\t1.25\t-20\t140\tcamping\ty\ntest_castle_sub1_4\tc2095\t\t\t0\t255\t255\t255\t1.399999976\t100\t90\tb_idle\ty\ntest_castle_sub1_6\tc2074\t\t\t17\t140\t125\t125\t1.25\t-500\t340\tidle\ty\ntest_castle_sub1_7\tc2027\t\t\t1\t255\t255\t255\t0.5\t20\t450\trun\ntest_castle_sub1_8\tc6062\t\t\t14\t255\t255\t255\t0.949999988\t-40\t370\tcamping\n"
local var_0_2 = "test_castle_sub2_1\tc1112\t\t\t0\t255\t255\t255\t2\t0\t-40\tidle\ntest_castle_sub2_2\tc1111\t\t\t0\t255\t255\t255\t2\t200\t0\tidle\ntest_castle_sub2_3\tc1066\t\t\t0\t255\t255\t255\t2\t300\t0\tidle\ntest_castle_sub2_4\tc1110\t\t\t14\t255\t255\t255\t1\t-80\t340\tb_idle\ntest_castle_sub2_5\tc1109\t\t\t14\t255\t255\t255\t1\t0\t350\tcamping\ty\ntest_castle_sub2_6\tc1106\t\t\t0\t255\t255\t255\t1.950000048\t-300\t0\tidle\ntest_castle_sub2_7\tc1100\t\t\t0\t255\t255\t255\t1.75\t-400\t0\tidle\n"

function TLDatabase.getBGAndObjectKey(arg_1_0, arg_1_1)
	if arg_1_0.mockup then
		if arg_1_1 == "test_castle_sub1" then
			return "castle", "test_castle_sub1"
		elseif arg_1_1 == "test_castle_sub2" then
			return "castle", "test_castle_sub2"
		elseif arg_1_1 == "test_castle_main" then
			return "castle", "test_castle_main"
		end
	else
		local var_1_0, var_1_1 = DB("lobby_theme_group", arg_1_1, {
			"bg",
			"object_key"
		})
		
		return var_1_0, var_1_1
	end
end

function TLDatabase.isExistObjectData(arg_2_0, arg_2_1)
	if arg_2_0.mockup then
		return arg_2_0.debug_db[arg_2_1] ~= nil
	else
		return DB("lobby_theme_object", arg_2_1, "id") ~= nil
	end
end

function TLDatabase.getObjectData(arg_3_0, arg_3_1)
	if arg_3_0.mockup then
		return table.clone(arg_3_0.debug_db[arg_3_1])
	else
		return DBT("lobby_theme_object", arg_3_1, {
			"id",
			"character_id",
			"character_skin",
			"pet_id",
			"target_layer",
			"r",
			"g",
			"b",
			"scale",
			"x",
			"y",
			"ani",
			"flip"
		})
	end
end

function TLDatabase.getGroupRate(arg_4_0, arg_4_1)
	if arg_4_0.mockup then
		if arg_4_1 == "test_castle_sub1" then
			return 1
		elseif arg_4_1 == "test_castle_sub2" then
			return 1
		elseif arg_4_1 == "test_castle_main" then
			return 8
		end
	else
		return DB("lobby_theme_group", arg_4_1, "rate")
	end
end

function TLDatabase.initDebugMode(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.mockup = true
	arg_5_0.ignore_unlock = arg_5_1
	
	local var_5_0 = true
	
	if var_0_0 and var_5_0 then
		local var_5_1 = {
			"id",
			"character_id",
			"character_skin",
			"pet_id",
			"target_layer",
			"r",
			"g",
			"b",
			"scale",
			"x",
			"y",
			"ani",
			"flip"
		}
		local var_5_2 = {}
		local var_5_3 = {
			{
				"test_castle_main",
				var_0_0
			},
			{
				"test_castle_sub1",
				var_0_1
			},
			{
				"test_castle_sub2",
				var_0_2
			}
		}
		
		for iter_5_0, iter_5_1 in pairs(var_5_3) do
			local var_5_4 = iter_5_1[1]
			local var_5_5 = iter_5_1[2]
			local var_5_6 = string.split(var_5_5, "\n")
			
			var_5_2[var_5_4] = {}
			
			for iter_5_2, iter_5_3 in pairs(var_5_6) do
				local var_5_7 = {}
				local var_5_8 = 1
				local var_5_9 = string.split(iter_5_3, "\t")
				
				for iter_5_4, iter_5_5 in pairs(var_5_9) do
					if iter_5_5 ~= "" then
						local var_5_10 = tonumber(iter_5_5)
						
						var_5_7[var_5_1[var_5_8]] = var_5_10 or iter_5_5
					end
					
					var_5_8 = var_5_8 + 1
				end
				
				if not table.empty(var_5_7) then
					var_5_2[var_5_7.id] = var_5_7
				end
			end
		end
		
		arg_5_0.debug_db = var_5_2
		
		return arg_5_0:createThemeIllustByRandomList("test_castle_main,test_castle_sub1,test_castle_sub2", arg_5_2)
	end
end

function TLDatabase.isAllCheckGroup(arg_6_0, arg_6_1)
	if arg_6_0.ignore_unlock then
		return false
	end
	
	if arg_6_0.mockup then
		if arg_6_1 == "test_castle_main" then
			return false
		else
			return true
		end
	else
		return DB("lobby_theme_group", arg_6_1, "all_check") == "y"
	end
end

function TLDatabase.isAllUnlocked(arg_7_0, arg_7_1)
	if not arg_7_0:isAllCheckGroup(arg_7_1) then
		return true
	end
	
	local var_7_0, var_7_1 = arg_7_0:getBGAndObjectKey(arg_7_1)
	local var_7_2 = arg_7_0:getObjectDataList(var_7_1)
	
	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		if not arg_7_0:isUnlockObjectData(iter_7_1) then
			return false
		end
	end
	
	return true
end

function TLDatabase.createThemeIllustByRandomList(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = string.split(arg_8_1, ",")
	
	if not var_8_0 or table.empty(var_8_0) then
		return 
	end
	
	local var_8_1 = {}
	local var_8_2 = 0
	
	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if arg_8_0:isAllUnlocked(iter_8_1) then
			local var_8_3 = arg_8_0:getGroupRate(iter_8_1)
			
			if var_8_3 then
				var_8_2 = var_8_2 + var_8_3
				
				table.insert(var_8_1, {
					rate = var_8_3,
					id = iter_8_1
				})
			end
		end
	end
	
	local var_8_4 = math.random(0, var_8_2)
	local var_8_5
	
	for iter_8_2, iter_8_3 in pairs(var_8_1) do
		var_8_4 = var_8_4 - iter_8_3.rate
		
		if var_8_4 <= 0 then
			var_8_5 = iter_8_3.id
			
			break
		end
	end
	
	if not PRODUCTION_MODE and arg_8_3 then
		var_8_5 = arg_8_3
		arg_8_0.ignore_unlock = true
	elseif PRODUCTION_MODE then
		arg_8_0.ignore_unlock = false
	end
	
	if not var_8_5 then
		error("NOT EXIST GROUP ID! what? INFO: " .. arg_8_1 .. " " .. var_8_2 .. " " .. var_8_4)
	end
	
	return arg_8_1, arg_8_0:createThemeIllust(var_8_5, arg_8_2, arg_8_4)
end

function TLDatabase.getObjectDataList(arg_9_0, arg_9_1)
	local var_9_0 = {}
	
	for iter_9_0 = 1, 99 do
		local var_9_1 = string.format("%s_%d", arg_9_1, iter_9_0)
		
		if not arg_9_0:isExistObjectData(var_9_1) then
			break
		end
		
		local var_9_2 = arg_9_0:getObjectData(var_9_1)
		
		table.insert(var_9_0, var_9_2)
	end
	
	return var_9_0
end

function TLDatabase.isUnlockObjectData(arg_10_0, arg_10_1)
	local var_10_0 = false
	
	if arg_10_1.character_skin then
		local var_10_1 = arg_10_0._skin_cache[arg_10_1.character_skin]
		
		if not var_10_1 then
			Log.e("Err: Character Skin Code Not Exist in DB: " .. arg_10_1.character_skin)
		else
			var_10_0 = (Account:getItemCount(var_10_1) or 0) > 0
			
			if var_10_0 then
				var_10_0 = Account:getCollectionUnit(arg_10_1.character_id)
			end
		end
	elseif arg_10_1.character_id then
		var_10_0 = Account:getCollectionUnit(arg_10_1.character_id)
	elseif arg_10_1.pet_id then
		var_10_0 = Account:getCollectionPet(arg_10_1.pet_id)
	end
	
	return var_10_0
end

function TLDatabase.createThemeIllust(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0, var_11_1 = arg_11_0:getBGAndObjectKey(arg_11_1)
	
	if not var_11_0 then
		error("NOT EXIST GROUP ID! what? INFO: " .. arg_11_1)
		
		return 
	end
	
	local var_11_2
	local var_11_3
	
	if arg_11_2 then
		var_11_2 = TLRenderer:create()
		
		arg_11_3:addChild(var_11_2)
		TLRenderer:changeBackground(var_11_0)
		
		var_11_3 = TLRenderer
	else
		var_11_3 = TLRenderer:createInstance()
		var_11_2 = var_11_3:create()
		
		arg_11_3:addChild(var_11_2)
		var_11_3:changeBackground(var_11_0)
	end
	
	local var_11_4 = arg_11_0:getObjectDataList(var_11_1)
	
	if arg_11_0.ignore_unlock then
		arg_11_0:loadByCharList(var_11_4, var_11_3)
	else
		arg_11_0:loadByUnlockStatus(var_11_4, var_11_3)
	end
	
	return var_11_2
end

function TLDatabase.createCharacterSkinCache(arg_12_0)
	if arg_12_0._skin_cache then
		return 
	end
	
	arg_12_0._skin_cache = {}
	
	for iter_12_0 = 1, 999 do
		if not DBN("character_skin", iter_12_0, "id") then
			break
		end
		
		for iter_12_1 = 1, GAME_STATIC_VARIABLE.max_skin_count or 3 do
			local var_12_0 = string.format("skin%02d", iter_12_1)
			local var_12_1 = string.format("skin%02d_ma", iter_12_1)
			local var_12_2, var_12_3 = DBN("character_skin", iter_12_0, {
				var_12_0,
				var_12_1
			})
			
			if var_12_2 then
				arg_12_0._skin_cache[var_12_2] = var_12_3
			end
		end
	end
end

function TLDatabase.loadByUnlockStatus(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:createCharacterSkinCache()
	
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		if arg_13_0:isUnlockObjectData(iter_13_1) then
			table.insert(var_13_0, iter_13_1)
		end
	end
	
	arg_13_0:loadByCharList(var_13_0, arg_13_2)
end

function TLDatabase.loadByCharList(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2:getCharacterRenderer()
	
	var_14_0:clearCharDataList()
	var_14_0:setCharDataList(arg_14_1)
end

function TLDatabase.getRenderGroupData(arg_15_0, arg_15_1)
	if not arg_15_0.MOCKUP_DB.GROUP[arg_15_1] then
		return nil
	end
	
	return table.clone(arg_15_0.MOCKUP_DB.GROUP[arg_15_1])
end

function TLDatabase.getRenderCharData(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1 .. "_" .. arg_16_2
	
	if not arg_16_0.MOCKUP_DB.CHAR[var_16_0] then
		return nil
	end
	
	return table.clone(arg_16_0.MOCKUP_DB.CHAR[var_16_0])
end
