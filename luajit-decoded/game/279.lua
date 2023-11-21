CollectionUtil = {}

function CollectionUtil.make_tbl(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if not arg_1_1[arg_1_2] then
		arg_1_1[arg_1_2] = {}
	end
	
	table.insert(arg_1_1[arg_1_2], arg_1_3)
end

function CollectionUtil.make_tbl_key(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if not arg_2_1[arg_2_2] then
		arg_2_1[arg_2_2] = {}
	end
	
	arg_2_1[arg_2_2][arg_2_3] = arg_2_4
end

function CollectionUtil.isCanShow(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0
	
	if arg_3_2 == "c" then
		var_3_0 = Account:getCollectionUnit(arg_3_1)
	elseif arg_3_2 == "e" then
		var_3_0 = Account:getCollectionEquip(arg_3_1)
	end
	
	if arg_3_3 and var_3_0 then
		return true
	end
	
	if arg_3_4 and not var_3_0 then
		return true
	end
	
	return false
end

function CollectionUtil.isRewardConditionStateCheckType(arg_4_0, arg_4_1)
	return arg_4_1 == "maze" or arg_4_1 == "main" or arg_4_1 == nil
end

function CollectionUtil.isRewardConditionState(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 == "maze" then
		return Account:isClearedAchieve(arg_5_2)
	elseif arg_5_1 == "main" then
		return ConditionContentsManager:getQuestMissions():isClearedChapter(arg_5_2)
	elseif arg_5_1 == nil then
		return true
	end
	
	return false
end

function CollectionUtil.initCountDB(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_1[arg_6_2] = {}
	arg_6_1[arg_6_2].have_count = 0
	arg_6_1[arg_6_2].max_count = 0
	
	if not arg_6_3 then
		arg_6_1[arg_6_2].have_count = nil
	end
end

function CollectionUtil.setCountDB(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if not arg_7_1[arg_7_2] then
		arg_7_0:initCountDB(arg_7_1, arg_7_2, arg_7_4)
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_3) do
		if arg_7_4 and arg_7_4(iter_7_1) then
			arg_7_1[arg_7_2].have_count = arg_7_1[arg_7_2].have_count + 1
		end
		
		arg_7_1[arg_7_2].max_count = arg_7_1[arg_7_2].max_count + 1
	end
end

function CollectionUtil.isConditionOk(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return false
	end
	
	local var_8_0 = arg_8_1.con_stage
	
	if not var_8_0 then
		return true
	end
	
	if var_8_0 == "main" then
		return ConditionContentsManager:getQuestMissions():isCleared(arg_8_1.quest_id)
	elseif var_8_0 == "map_enter" then
		return Account:isMapCleared(arg_8_1.con_check)
	elseif var_8_0 == "class_change" then
		local var_8_1 = Account:getClassChangeInfo()[arg_8_1.con_check]
		
		if not var_8_1 then
			return false
		end
		
		return var_8_1.state == 2
	elseif var_8_0 == "achieve" then
		return Account:isClearedAchieve(arg_8_1.con_check)
	elseif var_8_0 == "maze" then
		return Account:getExplore(arg_8_1.con_check) == 100
	elseif var_8_0 == "faction" then
		local var_8_2 = arg_8_1.con_check
		
		if not var_8_2 then
			return 
		end
		
		local var_8_3 = string.split(var_8_2, ",")
		local var_8_4 = var_8_3[1]
		local var_8_5 = to_n(var_8_3[2])
		
		if not var_8_5 then
			return 
		end
		
		return var_8_5 <= Account:getFactionGrade(var_8_4)
	elseif var_8_0 == "honor" then
		return ((Account:getFactionRewardByRewardID(arg_8_1.con_check) or {}).receive_time or 0) > 0
	end
	
	return true
end

function CollectionUtil.isUnitUnlock(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return false
	end
	
	if not arg_9_1.con_stage then
		return true
	end
	
	if DEBUG.UNLOCK_DICT_UNIT_ALL then
		return true
	end
	
	return CollectionUtil:isConditionOk(arg_9_1)
end

function CollectionUtil.isStoryUnlock(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return 
	end
	
	if not arg_10_1.con_stage then
		return true
	end
	
	if DEBUG.SHOW_STORY_COLLECTION then
		return true
	end
	
	return CollectionUtil:isConditionOk(arg_10_1)
end

function CollectionUtil.isIllustUnlock(arg_11_0, arg_11_1)
	if not arg_11_1 then
		return 
	end
	
	if arg_11_1.con_stage_alternative and arg_11_1.con_stage_alternative ~= "" and arg_11_0:isIllustUnlock({
		con_check = arg_11_1.con_check_alternative,
		con_stage = arg_11_1.con_stage_alternative
	}) == true then
		return true
	end
	
	local var_11_0 = arg_11_1.con_stage
	
	if not var_11_0 then
		return true
	end
	
	if DEBUG.SHOW_ILLUST_COLLECTION then
		return true
	end
	
	if var_11_0 == "main" then
		return ConditionContentsManager:getQuestMissions():isCleared(arg_11_1.quest_id)
	end
	
	if var_11_0 == "map_enter" then
		return Account:isMapCleared(arg_11_1.con_check)
	end
	
	if var_11_0 == "item" then
		return Account:getItemCount(arg_11_1.con_check) > 0
	end
	
	if var_11_0 == "ml_theater_story" then
		return Account:get_mtl_ep_cleared_tm(arg_11_1.con_check) ~= nil
	end
	
	return true
end

function CollectionUtil.isArtifactUnlock(arg_12_0, arg_12_1)
	if not arg_12_1 then
		return false
	end
	
	if not arg_12_1.con_stage then
		return true
	end
	
	if DEBUG.UNLOCK_DICT_ARTIFACT_ALL then
		return true
	end
	
	if not PRODUCTION_MODE then
		return Account:getCollectionEquip(arg_12_1.id) ~= nil
	end
	
	return CollectionUtil:isConditionOk(arg_12_1)
end

function CollectionUtil.removeRegexCharacters(arg_13_0, arg_13_1)
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(CollectionUtil.REMOVE_REGEX_VALUES) do
		local var_13_1 = 0
		
		while var_13_1 do
			var_13_1 = string.find(arg_13_1, iter_13_0, var_13_1 + 1)
			
			if var_13_1 then
				table.insert(var_13_0, {
					pos = var_13_1,
					key = iter_13_0
				})
			else
				break
			end
		end
	end
	
	table.sort(var_13_0, function(arg_14_0, arg_14_1)
		return arg_14_0.pos < arg_14_1.pos
	end)
	
	local var_13_2 = ""
	local var_13_3 = 1
	
	for iter_13_2 = 1, #var_13_0 do
		var_13_2 = var_13_2 .. string.sub(arg_13_1, var_13_3, var_13_0[iter_13_2].pos - 1)
		var_13_2 = var_13_2 .. CollectionUtil.REMOVE_REGEX_VALUES[var_13_0[iter_13_2].key]
		var_13_3 = var_13_0[iter_13_2].pos + 1
	end
	
	return var_13_2 .. string.sub(arg_13_1, var_13_3, -1)
end

function CollectionUtil.makeQuestData(arg_15_0, arg_15_1)
	local var_15_0 = {}
	
	if arg_15_1.quest_id and not arg_15_1.face_id and arg_15_1.face_id ~= "" then
		local var_15_1, var_15_2, var_15_3 = DB("mission_data", arg_15_1.quest_id, {
			"name",
			"desc",
			"icon"
		})
		
		if var_15_1 == nil then
			var_15_1, var_15_2, var_15_3 = DB("substory_quest", arg_15_1.quest_id, {
				"name",
				"desc",
				"icon"
			})
		end
		
		var_15_0 = {
			name = var_15_2,
			desc = var_15_1,
			icon = var_15_3 and var_15_3 .. "_s" or nil
		}
	elseif arg_15_1.face_id or arg_15_1.face_id == "" then
		var_15_0 = {
			name = arg_15_1.title_name,
			desc = arg_15_1.map_name,
			icon = arg_15_1.face_id
		}
	end
	
	return var_15_0
end

function CollectionUtil.setStoryRendererBasic(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	
	if arg_16_2.icon then
		var_16_0 = "face/" .. arg_16_2.icon .. ".png"
	end
	
	if_set_sprite(arg_16_1, "face", var_16_0)
	if_set(arg_16_1, "txt_title", T(arg_16_2.name))
	if_set(arg_16_1, "txt_desc", T(arg_16_2.desc))
end

CollectionUtil.GRADE_SORT_ORDER = {
	6,
	5,
	4,
	3,
	2,
	1
}
CollectionUtil.ROLE_SORT_ORDER = {
	manauser = 8,
	knight = 4,
	material = 9,
	warrior = 3,
	ranger = 6,
	mage = 7,
	all = 1,
	share = 2,
	assassin = 5
}
CollectionUtil.ATTRIBUTE_SORT_ORDER = {
	wind = 3,
	fire = 1,
	light = 4,
	dark = 5,
	ice = 2
}
CollectionUtil.ARTI_ROLE_UNHASH_TABLE = {
	"share",
	"warrior",
	"knight",
	"assassin",
	"ranger",
	"mage",
	"manauser",
	all = "all"
}
CollectionUtil.ROLE_COMP_TO_KEY_DATA_STRING = {
	all = "error_string",
	knight = "ui_hero_role_knight",
	share = "ui_inventory_btn_public",
	manauser = "ui_hero_role_manauser",
	assassin = "ui_hero_role_assassin",
	warrior = "ui_hero_role_warrior",
	ranger = "ui_hero_role_ranger",
	mage = "ui_hero_role_mage"
}
CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON = {
	all = "icon_menu_all.png",
	knight = "icon_menu_roleknight.png",
	share = "icon_menu_roleshare.png",
	manauser = "icon_menu_rolremanauser.png",
	assassin = "icon_menu_roleassassin.png",
	warrior = "icon_menu_warrior.png",
	ranger = "icon_menu_ranger.png",
	mage = "icon_menu_rolemage.png"
}
CollectionUtil.REMOVE_REGEX_VALUES = {
	["%%"] = "%%",
	["%+"] = "%+",
	["%("] = "%(",
	["%]"] = "%]",
	["%."] = "%.",
	["%-"] = "%-",
	["%["] = "%[",
	["%*"] = "%*",
	["%)"] = "%)",
	["%?"] = "%?"
}
