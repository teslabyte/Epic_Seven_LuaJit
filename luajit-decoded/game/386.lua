SubStoryViewerDB = {}

function SubStoryViewerDB.foreach_dic_ui(arg_1_0, arg_1_1)
	local var_1_0 = AccountData.dictionary_hide or {}
	local var_1_1, var_1_2 = DBN("dic_ui", arg_1_1, {
		"id",
		"parent_id"
	})
	
	if var_1_0[var_1_1] or var_1_0[var_1_2] then
		return true
	end
	
	if not var_1_1 then
		return false
	end
	
	if var_1_2 ~= "story7" then
		return true
	end
	
	if not SubstorySystemStory:isOpenSystemSubstorySchedule(var_1_1) then
		return true
	end
	
	local var_1_3, var_1_4, var_1_5, var_1_6, var_1_7, var_1_8 = DBN("dic_ui", arg_1_1, {
		"name",
		"icon",
		"sort",
		"cast_main",
		"cast_sub",
		"desc"
	})
	local var_1_9 = {}
	
	table.insert(var_1_9, var_1_6)
	
	if var_1_7 ~= nil then
		var_1_7 = string.split(var_1_7, ",")
		
		for iter_1_0, iter_1_1 in pairs(var_1_7) do
			table.insert(var_1_9, iter_1_1)
		end
	end
	
	local var_1_10 = {
		id = var_1_1,
		name = var_1_3,
		icon = var_1_4,
		sort = var_1_5,
		cast_main = var_1_6,
		cast_sub = var_1_7,
		casting = var_1_9,
		desc = var_1_8
	}
	
	table.insert(arg_1_0.vars.db, var_1_10)
	
	arg_1_0.vars.parent_db[var_1_1] = var_1_10
	
	for iter_1_2, iter_1_3 in pairs(var_1_9) do
		if not arg_1_0.vars.key_char_code_db[iter_1_3] then
			arg_1_0.vars.key_char_code_db[iter_1_3] = {}
		end
		
		table.insert(arg_1_0.vars.key_char_code_db[iter_1_3], var_1_10)
	end
	
	return true
end

function SubStoryViewerDB.foreach_dic_data(arg_2_0, arg_2_1)
	local var_2_0, var_2_1, var_2_2, var_2_3, var_2_4, var_2_5, var_2_6, var_2_7, var_2_8, var_2_9, var_2_10, var_2_11 = DBN("dic_data_substory", arg_2_1, {
		"id",
		"parent_id",
		"sort",
		"quest_id",
		"face_id",
		"map_name",
		"title_name",
		"story_id",
		"level_enter",
		"npc_team",
		"default_bg",
		"default_bgm"
	})
	
	if not var_2_0 or not var_2_1 then
		return false
	end
	
	if not arg_2_0.vars.sub_story_data[var_2_1] then
		arg_2_0.vars.sub_story_data[var_2_1] = {}
	end
	
	table.insert(arg_2_0.vars.sub_story_data[var_2_1], {
		id = var_2_0,
		parent_id = var_2_1,
		sort = var_2_2,
		quest_id = var_2_3,
		face_id = var_2_4,
		map_name = var_2_5,
		title_name = var_2_6,
		story_id = var_2_7,
		npc_team = var_2_9,
		default_bg = var_2_10,
		default_bgm = var_2_11,
		level_enter = var_2_8
	})
	
	return true
end

function SubStoryViewerDB.createSearchCache(arg_3_0)
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.key_char_code_db) do
		local var_3_0 = T(DB("character", iter_3_0, "name"))
		
		if not arg_3_0.vars.search_cache[var_3_0] then
			arg_3_0.vars.search_cache[var_3_0] = {}
		end
		
		arg_3_0.vars.search_cache[var_3_0] = iter_3_1
	end
end

function SubStoryViewerDB.foreach_classchange_category(arg_4_0, arg_4_1)
	local var_4_0, var_4_1 = DBN("classchange_category", arg_4_1, {
		"char_id",
		"char_id_cc"
	})
	
	if not var_4_0 then
		return false
	end
	
	if arg_4_0.vars.key_char_code_db[var_4_0] then
		arg_4_0.vars.key_char_code_db[var_4_1] = arg_4_0.vars.key_char_code_db[var_4_0]
	end
	
	return true
end

function SubStoryViewerDB.create(arg_5_0)
	if arg_5_0.vars then
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.parent_db = {}
	arg_5_0.vars.db = {}
	arg_5_0.vars.key_char_code_db = {}
	
	for iter_5_0 = 1, 999 do
		if not arg_5_0:foreach_dic_ui(iter_5_0) then
			break
		end
	end
	
	arg_5_0.vars.sub_story_data = {}
	
	for iter_5_1 = 1, 999 do
		if not arg_5_0:foreach_dic_data(iter_5_1) then
			break
		end
	end
	
	for iter_5_2 = 1, 999 do
		if not arg_5_0:foreach_classchange_category(iter_5_2) then
			break
		end
	end
	
	arg_5_0.vars.search_cache = {}
	
	arg_5_0:createSearchCache()
end

function SubStoryViewerDB.searchByUnitName(arg_6_0, arg_6_1)
	local var_6_0 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.vars.search_cache) do
		if string.match(iter_6_0, arg_6_1) then
			for iter_6_2, iter_6_3 in pairs(iter_6_1) do
				table.print(iter_6_3)
				table.insert(var_6_0, iter_6_3)
			end
		end
	end
	
	return var_6_0
end

function SubStoryViewerDB.getCharacterSubStories(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	return arg_7_0.vars.key_char_code_db[arg_7_1]
end

function SubStoryViewerDB.getParentDB(arg_8_0)
	return arg_8_0.vars.db
end

function SubStoryViewerDB.isEmpty(arg_9_0)
	arg_9_0:create()
	
	return arg_9_0.vars.db[1] == nil
end

function SubStoryViewerDB.getParentByID(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	return arg_10_0.vars.parent_db[arg_10_1]
end

function SubStoryViewerDB.getSubStory(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	return arg_11_0.vars.sub_story_data[arg_11_1]
end

function SubStoryViewerDB.getSubStoryCount(arg_12_0)
	return table.count(arg_12_0.vars.sub_story_data or {})
end

function SubStoryViewerDB.destroy(arg_13_0)
	arg_13_0.vars = nil
end
