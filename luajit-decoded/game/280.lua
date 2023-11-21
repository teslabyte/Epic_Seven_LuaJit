CollectionDB = {}
CollectionDBTest = {}

function CollectionDBTest.initStoryDB(arg_1_0, arg_1_1)
	if not CollectionDB.vars then
		CollectionDB.vars = {}
	end
	
	print("Test Param , ", CollectionDB:initStoryDB())
	
	local var_1_0, var_1_1, var_1_2 = CollectionDB:initStoryDB()
	
	if not var_1_0 then
		print("Test Failed")
	end
	
	if arg_1_1 then
		table.print(CollectionDB:getStoryDB())
	end
end

function CollectionDBTest.dicUi(arg_2_0, arg_2_1)
	print("SHOW ALL DIC UI ID")
	
	local var_2_0
	
	for iter_2_0 = 1, 9999 do
		local var_2_1 = DBN("dic_ui", iter_2_0, "id")
		
		if not var_2_1 then
			break
		end
		
		var_2_0 = var_2_1
	end
	
	print("DIC_UI_OK? ", var_2_0 ~= arg_2_1)
end

function CollectionDB.getAddFlag(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_4 = arg_3_4 or {}
	
	local var_3_0 = arg_3_1[arg_3_2] or arg_3_1[arg_3_3]
	local var_3_1 = true
	
	if arg_3_2 == "c1005" or arg_3_2 == "c0001" or arg_3_2 == "c0002" then
		var_3_1 = false
		
		if Account:isMapCleared("poe017") then
			var_3_1 = arg_3_2 == "c0002"
		elseif Account:isMapCleared("poe010") then
			var_3_1 = arg_3_2 == "c0001"
		else
			var_3_1 = arg_3_2 == "c1005"
		end
	end
	
	if var_3_0 then
		local var_3_2 = os.time()
		
		if var_3_2 > var_3_0.start_time and var_3_2 < var_3_0.end_time then
			var_3_1 = false
		end
	end
	
	if arg_3_4.callbackDisableUnit and arg_3_4.callbackDisableUnit(arg_3_2) then
		var_3_1 = false
	end
	
	return var_3_1
end

function CollectionDB.initStoryDB(arg_4_0)
	arg_4_0.vars.story = {}
	arg_4_0.vars.story.parent_DB = {}
	arg_4_0.vars.story.pure_DB = {}
	arg_4_0.vars.story.all_count = 0
	arg_4_0.vars.story.view_count = 0
	
	local var_4_0 = AccountData.dictionary_hide or {}
	
	for iter_4_0 = 1, 9999 do
		local var_4_1, var_4_2, var_4_3, var_4_4, var_4_5, var_4_6, var_4_7, var_4_8, var_4_9, var_4_10, var_4_11, var_4_12, var_4_13, var_4_14, var_4_15, var_4_16 = DBN("dic_data_story", iter_4_0, {
			"id",
			"con_check",
			"quest_id",
			"face_id",
			"map_name",
			"title_name",
			"story_id",
			"story_sub",
			"movie",
			"illust",
			"show",
			"con_stage",
			"sort",
			"parent_id",
			"default_bg",
			"default_bgm"
		})
		
		if not var_4_1 then
			break
		end
		
		local var_4_17 = {
			id = var_4_1,
			con_check = var_4_2,
			quest_id = var_4_3,
			face_id = var_4_4,
			map_name = var_4_5,
			title_name = var_4_6,
			story_id = var_4_7,
			story_sub = var_4_8,
			movie = var_4_9,
			illust = var_4_10,
			show = var_4_11,
			con_stage = var_4_12,
			sort = var_4_13,
			p_id = var_4_14,
			default_bg = var_4_15,
			default_bgm = var_4_16
		}
		local var_4_18 = DB("dic_ui", var_4_14, "parent_id")
		local var_4_19 = arg_4_0:getAddFlag(var_4_0, var_4_1, var_4_14)
		
		if var_4_18 and var_4_19 then
			if not arg_4_0.vars.story.parent_DB[var_4_14] then
				arg_4_0.vars.story.parent_DB[var_4_14] = {}
			end
			
			arg_4_0.vars.story.pure_DB[var_4_1] = var_4_17
			arg_4_0.vars.story.parent_DB[var_4_14][var_4_1] = arg_4_0.vars.story.pure_DB[var_4_1]
			
			if CollectionUtil:isStoryUnlock(var_4_17) then
				arg_4_0.vars.story.view_count = arg_4_0.vars.story.view_count + 1
			end
			
			arg_4_0.vars.story.all_count = arg_4_0.vars.story.all_count + 1
		end
	end
	
	return true
end

function CollectionDB.isReceivableBgPackChapter(arg_5_0, arg_5_1)
	local var_5_0, var_5_1, var_5_2 = DB("dic_ui", arg_5_1, {
		"reward",
		"reward_con",
		"reward_check"
	})
	
	return var_5_0 and Account:getItemCount(var_5_0) == 0 and CollectionUtil:isRewardConditionStateCheckType(var_5_1) and CollectionUtil:isRewardConditionState(var_5_1, var_5_2)
end

local function var_0_0()
	local var_6_0 = {}
	
	for iter_6_0 = 1, 9999 do
		local var_6_1 = DBN("dic_data_story", iter_6_0, "parent_id")
		
		if not var_6_1 then
			break
		end
		
		local var_6_2, var_6_3 = DB("dic_ui", var_6_1, {
			"parent_id",
			"reward"
		})
		
		if var_6_2 and var_6_3 then
			if not var_6_0[var_6_2] then
				var_6_0[var_6_2] = {}
			end
			
			var_6_0[var_6_2][var_6_1] = true
		end
	end
	
	return var_6_0
end

function CollectionDB.isReceivableBgPackEpisode(arg_7_0, arg_7_1)
	arg_7_0._story_parent_map = arg_7_0._story_parent_map or var_0_0()
	
	if not arg_7_0._story_parent_map[arg_7_1] then
		return false
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0._story_parent_map[arg_7_1]) do
		if arg_7_0:isReceivableBgPackChapter(iter_7_0) then
			return true
		end
	end
	
	return false
end

function CollectionDB.isRemainReceivableBgPack(arg_8_0)
	arg_8_0._story_parent_map = arg_8_0._story_parent_map or var_0_0()
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0._story_parent_map) do
		if arg_8_0:isReceivableBgPackEpisode(iter_8_0) then
			return true
		end
	end
	
	return false
end

function CollectionDB.addSubStoryToStoryDB(arg_9_0, arg_9_1, arg_9_2)
	SubStoryViewerDB:create()
	
	if SubStoryViewerDB:isEmpty() == true then
		return 
	end
	
	arg_9_1.story7 = {}
	
	local var_9_0 = 0
	local var_9_1 = 0
	
	for iter_9_0, iter_9_1 in pairs(SubStoryViewerDB:getParentDB()) do
		table.insert(arg_9_1.story7, iter_9_1)
		
		if SubStoryViewerUtil:checkIsActive(iter_9_1) then
			var_9_0 = var_9_0 + 1
		end
		
		var_9_1 = var_9_1 + 1
	end
	
	arg_9_2.story7 = {
		have_count = var_9_0,
		max_count = var_9_1
	}
end

function CollectionDB.addSubstoryCount(arg_10_0, arg_10_1)
	SubStoryViewerDB:create()
	
	if SubStoryViewerDB:isEmpty() == true then
		return 
	end
	
	local var_10_0 = SubStoryViewerDB:getParentDB()
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		arg_10_1.all_count = arg_10_1.all_count + 1
		
		if SubStoryViewerUtil:checkIsActive(iter_10_1) then
			arg_10_1.view_count = arg_10_1.view_count + 1
		end
	end
end

function CollectionDB.CreateIllustDB(arg_11_0, arg_11_1)
	local var_11_0 = {
		parent_DB = {},
		pure_DB = {}
	}
	
	var_11_0.all_count = 0
	var_11_0.unlock_count = 0
	
	local var_11_1 = {}
	local var_11_2 = AccountData.dictionary_hide or {}
	
	for iter_11_0 = 1, 9999 do
		local var_11_3, var_11_4, var_11_5, var_11_6, var_11_7, var_11_8, var_11_9, var_11_10, var_11_11, var_11_12, var_11_13, var_11_14, var_11_15 = DBN("dic_data_illust", iter_11_0, {
			"id",
			"parent_id",
			"sort",
			"con_stage",
			"con_check",
			"quest_id",
			"illust",
			"unlock_msg",
			"jpn_hide",
			"con_stage_alternative",
			"con_check_alternative",
			"thumbnail",
			"lobby"
		})
		
		if not var_11_3 then
			break
		end
		
		local var_11_16 = {
			id = var_11_3,
			con_check = var_11_7,
			quest_id = var_11_8,
			illust = var_11_9,
			con_stage = var_11_6,
			sort = var_11_5,
			unlock_msg = var_11_10,
			parent_id = var_11_4,
			con_stage_alternative = var_11_12,
			con_check_alternative = var_11_13,
			lobby = var_11_15,
			thumbnail = var_11_14
		}
		local var_11_17 = arg_11_0:getAddFlag(var_11_2, var_11_3, var_11_4)
		
		if var_11_11 == "y" and Account:isJPN() then
			var_11_17 = false
		end
		
		local var_11_18
		
		if IS_PUBLISHER_ZLONG then
			var_11_18 = var_11_4
			
			for iter_11_1 = 1, 9 do
				local var_11_19, var_11_20 = DB("dic_ui", var_11_18, {
					"parent_id",
					"global_only"
				})
				
				if not var_11_19 then
					break
				end
				
				if var_11_20 == "y" then
					var_11_17 = false
					
					break
				end
				
				var_11_18 = var_11_19
			end
		end
		
		if var_11_16.lobby == "y" and arg_11_1 ~= "lobby" then
			var_11_17 = false
		end
		
		if var_11_17 then
			local var_11_21 = DB("dic_ui", var_11_4, "parent_id")
			
			if var_11_21 and arg_11_0:getAddFlag(var_11_2, var_11_21, var_11_4) then
				if not var_11_0.parent_DB[var_11_4] then
					var_11_0.parent_DB[var_11_4] = {}
				end
				
				var_11_0.pure_DB[var_11_3] = var_11_16
				var_11_0.parent_DB[var_11_4][var_11_3] = var_11_0.pure_DB[var_11_3]
				
				if CollectionUtil:isIllustUnlock(var_11_16) then
					var_11_0.unlock_count = var_11_0.unlock_count + 1
				end
				
				var_11_0.all_count = var_11_0.all_count + 1
			end
		end
	end
	
	return var_11_0
end

function CollectionDB.CreateCategoryDB(arg_12_0, arg_12_1)
	local var_12_0 = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		local var_12_1, var_12_2 = DB("dic_ui", iter_12_0, {
			"parent_id",
			"global_only"
		})
		
		if not var_12_1 then
			Log.e("CHK CHK CHK CHK CATEGORY WAS NIL.", var_12_1)
		end
		
		if var_12_2 ~= "y" or not IS_PUBLISHER_ZLONG then
			if not var_12_0[var_12_1] then
				var_12_0[var_12_1] = {}
			end
			
			var_12_0[var_12_1][iter_12_0] = iter_12_1
		end
	end
	
	return var_12_0
end

function CollectionDB.GetCategories(arg_13_0, arg_13_1)
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		local var_13_1, var_13_2 = DB("dic_ui", iter_13_0, {
			"sort",
			"global_only"
		})
		
		if var_13_2 ~= "y" or not IS_PUBLISHER_ZLONG then
			table.insert(var_13_0, {
				id = iter_13_0,
				sort = var_13_1
			})
		end
	end
	
	table.sort(var_13_0, function(arg_14_0, arg_14_1)
		return arg_14_0.sort < arg_14_1.sort
	end)
	
	return var_13_0
end

function CollectionDB.GetCategoryDataList(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1[arg_15_2]
	local var_15_1 = {}
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		local var_15_2, var_15_3 = DB("dic_ui", iter_15_0, {
			"sort",
			"global_only"
		})
		local var_15_4 = {}
		
		if var_15_3 ~= "y" or not IS_PUBLISHER_ZLONG then
			for iter_15_2, iter_15_3 in pairs(iter_15_1) do
				if CollectionUtil:isIllustUnlock(iter_15_3) then
					table.insert(var_15_4, iter_15_3)
				end
			end
			
			if #var_15_4 > 0 then
				table.sort(var_15_4, function(arg_16_0, arg_16_1)
					return arg_16_0.sort < arg_16_1.sort
				end)
				table.insert(var_15_1, {
					data = var_15_4,
					sort = var_15_2,
					id = iter_15_0
				})
			end
		end
	end
	
	table.sort(var_15_1, function(arg_17_0, arg_17_1)
		return arg_17_0.sort < arg_17_1.sort
	end)
	
	return var_15_1
end

function CollectionDB.initIllustDB(arg_18_0)
	arg_18_0.vars.illust = arg_18_0:CreateIllustDB()
end

function CollectionDB.initDB(arg_19_0, arg_19_1)
	arg_19_1 = arg_19_1 or {}
	arg_19_0.vars.parent_DB = {}
	arg_19_0.vars.character = {}
	arg_19_0.vars.monster = {}
	arg_19_0.vars.artifact = {}
	arg_19_0.vars.pet = {}
	arg_19_0.vars.character.parent_DB = {}
	arg_19_0.vars.monster.parent_DB = {}
	arg_19_0.vars.artifact.parent_DB = {}
	arg_19_0.vars.pet.parent_DB = {}
	arg_19_0.vars.character.pure_DB = {}
	arg_19_0.vars.monster.pure_DB = {}
	arg_19_0.vars.artifact.pure_DB = {}
	arg_19_0.vars.pet.pure_DB = {}
	arg_19_0.vars.character.all_count = 0
	arg_19_0.vars.monster.all_count = 0
	arg_19_0.vars.artifact.all_count = 0
	arg_19_0.vars.pet.all_count = 0
	arg_19_0.vars.character.have_count = 0
	arg_19_0.vars.artifact.have_count = 0
	arg_19_0.vars.pet.have_count = 0
	
	local function var_19_0(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		arg_20_0[arg_20_1.id] = arg_20_1
		
		if arg_20_3 == "e" and Account:getCollectionEquip(arg_20_1.id) then
			arg_19_0.vars.artifact.have_count = arg_19_0.vars.artifact.have_count + 1
		elseif arg_20_3 == "c" and Account:getCollectionUnit(arg_20_1.id) then
			arg_19_0.vars.character.have_count = arg_19_0.vars.character.have_count + 1
		elseif arg_20_3 == "p" and Account:getCollectionPet(arg_20_1.id) then
			arg_19_0.vars.pet.have_count = arg_19_0.vars.pet.have_count + 1
		end
		
		arg_19_0.vars[arg_20_2].all_count = arg_19_0.vars[arg_20_2].all_count + 1
	end
	
	local function var_19_1(arg_21_0)
		if arg_21_0.show == "n" then
			return 
		end
		
		if string.match(arg_21_0.parent_id, "c%d") then
			var_19_0(arg_19_0.vars.character.pure_DB, arg_21_0, "character", "c")
		elseif string.starts(arg_21_0.parent_id, "m") then
			var_19_0(arg_19_0.vars.monster.pure_DB, arg_21_0, "monster", "m")
		elseif string.starts(arg_21_0.parent_id, "e") then
			var_19_0(arg_19_0.vars.artifact.pure_DB, arg_21_0, "artifact", "e")
		elseif string.starts(arg_21_0.parent_id, "p") then
			var_19_0(arg_19_0.vars.pet.pure_DB, arg_21_0, "pet", "p")
		end
		
		CollectionUtil:make_tbl(arg_19_0.vars.parent_DB, arg_21_0.parent_id, arg_21_0)
	end
	
	local var_19_2 = AccountData.dictionary_hide or {}
	
	for iter_19_0 = 1, 9999 do
		local var_19_3, var_19_4, var_19_5, var_19_6, var_19_7, var_19_8, var_19_9, var_19_10, var_19_11, var_19_12, var_19_13 = DBN("dic_data", iter_19_0, {
			"id",
			"parent_id",
			"type",
			"type_detail",
			"role",
			"item_id",
			"show",
			"skill_preview",
			"con_stage",
			"con_check",
			"locked_msg"
		})
		
		if not var_19_3 then
			break
		end
		
		local var_19_14 = {
			id = var_19_3,
			parent_id = var_19_4,
			type = var_19_5,
			type_detail = var_19_6,
			role = var_19_7,
			item_id = var_19_8,
			show = var_19_9,
			skill_preview = var_19_10,
			con_stage = var_19_11,
			con_check = var_19_12,
			locked_msg = var_19_13
		}
		
		if arg_19_0:getAddFlag(var_19_2, var_19_3, var_19_4, arg_19_1) then
			var_19_1(var_19_14)
		end
	end
	
	for iter_19_1, iter_19_2 in pairs(arg_19_0.vars.parent_DB) do
		if string.match(iter_19_1, "c%d") then
			arg_19_0.vars.character.parent_DB[iter_19_1] = iter_19_2
		elseif string.starts(iter_19_1, "m") then
			arg_19_0.vars.monster.parent_DB[iter_19_1] = iter_19_2
		elseif string.starts(iter_19_1, "e") then
			arg_19_0.vars.artifact.parent_DB[iter_19_1] = iter_19_2
		elseif string.starts(iter_19_1, "p") then
			arg_19_0.vars.pet.parent_DB[iter_19_1] = iter_19_2
		end
	end
end

function CollectionDB.getModeDB(arg_22_0, arg_22_1)
	return ({
		arti = CollectionDB.getArtifactListDB,
		hero = CollectionDB.getUnitListDB,
		monster = CollectionDB.getMonsterListDB,
		story = CollectionDB.getStoryDB,
		pet = CollectionDB.getPetDB,
		illust = CollectionDB.getIllustDB
	})[arg_22_1](arg_22_0)
end

function CollectionDB.getIllustDB(arg_23_0)
	return arg_23_0.vars.illust.parent_DB, arg_23_0.vars.illust.pure_DB
end

function CollectionDB.getArtifactListDB(arg_24_0)
	return arg_24_0.vars.artifact.parent_DB, arg_24_0.vars.artifact.pure_DB
end

function CollectionDB.getUnitListDB(arg_25_0)
	return arg_25_0.vars.character.parent_DB, arg_25_0.vars.character.pure_DB
end

function CollectionDB.getMonsterListDB(arg_26_0)
	return arg_26_0.vars.monster.parent_DB, arg_26_0.vars.monster.pure_DB
end

function CollectionDB.getStoryDB(arg_27_0)
	return arg_27_0.vars.story.parent_DB, arg_27_0.vars.story.pure_DB
end

function CollectionDB.getPetDB(arg_28_0)
	return arg_28_0.vars.pet.parent_DB, arg_28_0.vars.pet.pure_DB
end

function CollectionDB.getAllCountDB(arg_29_0)
	return {
		hero = arg_29_0.vars.character.all_count,
		arti = arg_29_0.vars.artifact.all_count,
		monster = arg_29_0.vars.monster.all_count,
		story = arg_29_0.vars.story.all_count,
		pet = arg_29_0.vars.pet.all_count,
		illust = arg_29_0.vars.illust.all_count
	}
end

function CollectionDB.getHaveCountDB(arg_30_0)
	return {
		hero = arg_30_0.vars.character.have_count,
		arti = arg_30_0.vars.artifact.have_count,
		monster = arg_30_0.vars.monster.have_count,
		story = arg_30_0.vars.story.view_count,
		pet = arg_30_0.vars.pet.have_count,
		illust = arg_30_0.vars.illust.unlock_count
	}
end

function CollectionDB.init(arg_31_0, arg_31_1)
	arg_31_1 = arg_31_1 or {}
	arg_31_0.vars = {}
	
	arg_31_0:initDB(arg_31_1)
	
	if arg_31_1.only_use_pre_ban then
		return 
	end
	
	arg_31_0:initStoryDB()
	arg_31_0:initIllustDB()
	arg_31_0:addSubstoryCount(arg_31_0.vars.story)
end

function CollectionDB.close(arg_32_0)
	arg_32_0.vars = nil
end
