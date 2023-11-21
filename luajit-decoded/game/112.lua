SubStoryUtil = SubStoryUtil or {}

function SubStoryUtil.getScheduleInfo(arg_1_0, arg_1_1)
	local var_1_0 = os.time()
	local var_1_1 = arg_1_1
	local var_1_2
	local var_1_3 = Account:getSubStoryScheduleDBById(arg_1_1)
	
	if var_1_3 and var_1_3.id and var_1_3.start_time and var_1_0 < var_1_3.start_time then
		var_1_2 = var_1_3
		var_1_2.append = "pre"
		
		return var_1_2, var_1_1
	end
	
	local var_1_4 = DBT("substory_change_image", arg_1_1, {
		"schedule_1",
		"schedule_2",
		"schedule_3"
	})
	
	for iter_1_0 = 1, 9 do
		local var_1_5 = var_1_4["schedule_" .. iter_1_0]
		
		if not var_1_4["schedule_" .. iter_1_0] then
			break
		end
		
		local var_1_6 = Account:getSubStoryScheduleDBById(var_1_5)
		
		if var_1_6 and var_1_6.id and var_1_6.start_time and var_1_0 > var_1_6.start_time then
			var_1_2 = var_1_6
			var_1_2.append = iter_1_0
			var_1_1 = var_1_5
		end
	end
	
	return var_1_2, var_1_1
end

function SubStoryUtil.getEventTimeInfo(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return 
	end
	
	return arg_2_0:getEventState(arg_2_1.start_time, arg_2_1.end_time), arg_2_1.start_time, arg_2_1.end_time
end

function SubStoryUtil.getEventTimeInfoByID(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return 
	end
	
	local var_3_0 = arg_3_0:getSubstoryDB(arg_3_1)
	
	return arg_3_0:getEventTimeInfo(var_3_0)
end

function SubStoryUtil.getEventState(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = SUBSTORY_CONSTANTS.ONE_WEEK
	local var_4_1 = os.time()
	local var_4_2 = ""
	
	if var_4_0 < arg_4_1 - var_4_1 then
		var_4_2 = SUBSTORY_CONSTANTS.STATE_NONE
	elseif arg_4_1 < var_4_1 then
		if var_4_1 < arg_4_2 then
			var_4_2 = SUBSTORY_CONSTANTS.STATE_OPEN
		elseif var_4_1 < arg_4_2 + var_4_0 then
			var_4_2 = SUBSTORY_CONSTANTS.STATE_CLOSE_SOON
		else
			var_4_2 = SUBSTORY_CONSTANTS.STATE_CLOSE
		end
	else
		var_4_2 = SUBSTORY_CONSTANTS.STATE_READY
	end
	
	return var_4_2
end

function SubStoryUtil.getDBParams(arg_5_0)
	return {
		"id",
		"name",
		"icon_enter",
		"contents_type",
		"contents_type_2",
		"content2_schedule",
		"pass_id",
		"custom_type",
		"core_reward_summary",
		"core_reward_title1",
		"core_reward1",
		"core_reward_title2",
		"core_reward2",
		"core_reward_title3",
		"core_reward3",
		"core_reward_title4",
		"core_reward4",
		"reward_equip_info",
		"background_battle",
		"quest_flag",
		"achieve_flag",
		"background_summary",
		"background_home",
		"background_shop",
		"powerup_hero0",
		"powerup_cs0",
		"powerup_hero1",
		"powerup_cs1",
		"powerup_hero2",
		"powerup_cs2",
		"bonus_artifact1",
		"bonus_artifact2",
		"bonus_artifact3",
		"bonus_artifact4",
		"token_id1",
		"token_id2",
		"token_id3",
		"category",
		"shop_npc_id",
		"npc_balloon_id",
		"show_preview",
		"move_character",
		"condition_state_id",
		"ac_reward_id",
		"ac_reward_count",
		"shop_npc_info",
		"npc_balloon_info",
		"prologue_story",
		"help_id",
		"sort",
		"lite_ui",
		"unlock",
		"shop_schedule",
		"condition_type",
		"banner_icon",
		"powerup_hero_unknown_icon",
		"powerup_hero_open_schedule",
		"bonus_artifact_unknown_icon",
		"bonus_artifact_unknown_thumbnail",
		"bonus_artifact_open_schedule",
		"custom_item_title"
	}
end

function SubStoryUtil.getDBParams_2(arg_6_0)
	return {
		"dlc",
		"type",
		"cast_hero",
		"dlc_tag",
		"dlc_open",
		"dlc_token",
		"dlc_image",
		"dlc_value",
		"dlc_core_reward",
		"csb_name",
		"end_delete",
		"hide_date",
		"powerup_desc",
		"descent_powerup1",
		"descent_powerup2",
		"descent_powerup3",
		"world_ui_csb",
		"highlight_preview",
		"new_order",
		"custom_item_hide"
	}
end

function SubStoryUtil.getSubstoryDB(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	
	local var_7_0 = arg_7_0:getDBParams()
	local var_7_1 = DBT("substory_main", arg_7_1, var_7_0)
	local var_7_2 = arg_7_0:getDBParams_2()
	local var_7_3 = DBT("substory_main", arg_7_1, var_7_2)
	
	table.merge(var_7_1, var_7_3)
	
	if arg_7_2.is_lite then
		return var_7_1
	end
	
	var_7_1.logo_position = DB("substory_bg", var_7_1.background_battle, "logo_position")
	
	if var_7_1.logo_position then
		var_7_1.logo_position = totable(var_7_1.logo_position)
	end
	
	local var_7_4 = Account:getSubStoryScheduleDBById(var_7_1.id)
	
	if var_7_4 then
		if var_7_4.start_time then
			var_7_1.start_time = var_7_4.start_time
		end
		
		if var_7_4.end_time then
			var_7_1.end_time = var_7_4.end_time
		end
		
		if var_7_1.icon_enter then
			local var_7_5 = var_7_1.icon_enter
			local var_7_6 = (arg_7_0:getScheduleInfo(var_7_1.id) or {}).append
			
			if var_7_6 then
				local var_7_7 = var_7_5 .. "_" .. var_7_6
				
				if DB("substory_bg", var_7_7, "id") then
					var_7_5 = var_7_7
				end
			end
			
			var_7_1.icon_enter = DB("substory_bg", var_7_5, "icon_enter")
			var_7_1.banner_icon = totable(DB("substory_bg", var_7_5, "logo")).img or var_7_1.banner_icon
			var_7_1.logo_position = DB("substory_bg", var_7_5, "logo_position")
			
			if var_7_1.logo_position then
				var_7_1.logo_position = totable(var_7_1.logo_position)
			end
		end
		
		var_7_1.is_unlock = UnlockSystem:isUnlockSystem(var_7_1.unlock)
	end
	
	return var_7_1
end

function SubStoryUtil.isContentsType(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1.contents_type == arg_8_2 then
		return true
	end
	
	if arg_8_1.contents_type_2 == arg_8_2 then
		return true
	end
	
	return false
end

function SubStoryUtil.isContentsTypeByID(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0:getSubstoryDB(arg_9_1, {
		is_lite = true
	})
	
	return arg_9_0:isContentsType(var_9_0, arg_9_2)
end

function SubStoryUtil.isValidWorldMap(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_1 then
		return false
	end
	
	local var_10_0 = arg_10_1 .. string.format("%03d", 1)
	
	if DB("level_enter", var_10_0, {
		"substory_contents_id"
	}) ~= arg_10_2 then
		return false
	end
	
	return true
end

function SubStoryUtil.setSubstoryConfigData(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not arg_11_2 then
		return 
	end
	
	if not arg_11_3 then
		return 
	end
	
	local var_11_0 = "substory." .. arg_11_1 .. "." .. arg_11_2
	
	SAVE:setTempConfigData(var_11_0, arg_11_3)
end

function SubStoryUtil.getSubstoryConfigData(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_2 then
		return 
	end
	
	local var_12_0 = "substory." .. arg_12_1 .. "." .. arg_12_2
	
	return Account:getConfigData(var_12_0)
end

function SubStoryUtil.getTopbarCurrencies(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or {}
	
	local var_13_0 = table.clone(arg_13_2)
	
	if arg_13_1 then
		for iter_13_0 = 1, 3 do
			if arg_13_1["token_id" .. iter_13_0] then
				table.insert(var_13_0, arg_13_1["token_id" .. iter_13_0])
			end
		end
	end
	
	return var_13_0
end

function SubStoryUtil.getStoryList(arg_14_0, arg_14_1, arg_14_2)
	arg_14_2 = arg_14_2 or {}
	
	local var_14_0 = {}
	local var_14_1 = {}
	local var_14_2 = os.time()
	
	for iter_14_0 = 1, 999 do
		local var_14_3, var_14_4, var_14_5, var_14_6, var_14_7 = DBN("substory_main", iter_14_0, {
			"id",
			"type",
			"dlc",
			"jpn_hide",
			"clear_check"
		})
		
		if not var_14_3 then
			break
		end
		
		local var_14_8 = not DEBUG.MAP_DEBUG and var_14_6 == "y" and Account:isJPN()
		local var_14_9 = false
		local var_14_10 = {
			"vcudlc",
			"vewrda",
			"vtutoa"
		}
		local var_14_11 = table.find(var_14_10, var_14_3)
		
		if not var_14_11 and var_14_7 and Account:getItemCount(var_14_7) > 0 then
			local var_14_12 = Account:getTicketedLimit("sse:" .. var_14_3)
			
			if var_14_12 and var_14_2 < var_14_12.expire_tm then
			else
				var_14_11 = true
			end
		end
		
		if (var_14_4 == "substory" or var_14_4 == "album") and not var_14_8 and not var_14_11 then
			table.insert(var_14_1, var_14_3)
		end
	end
	
	for iter_14_1, iter_14_2 in pairs(var_14_1) do
		local var_14_13 = arg_14_0:getSubstoryDB(iter_14_2)
		
		if Account:getSubStoryScheduleDBById(var_14_13.id) then
			if arg_14_1 then
				local var_14_14 = SubStoryUtil:getEventState(var_14_13.start_time, var_14_13.end_time)
				local var_14_15 = var_14_13.unlock == nil or var_14_13.unlock and UnlockSystem:isUnlockSystem(var_14_13.unlock)
				local var_14_16 = var_14_14 == SUBSTORY_CONSTANTS.STATE_OPEN or var_14_14 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON or var_14_14 == SUBSTORY_CONSTANTS.STATE_READY and var_14_13.show_preview == "y"
				local var_14_17 = var_14_14 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON and var_14_13.end_delete == "y"
				local var_14_18 = var_14_16 and not var_14_17
				
				if arg_14_2.unlock_only and var_14_18 and var_14_15 then
					table.push(var_14_0, var_14_13)
				elseif not arg_14_2.unlock_only and var_14_18 then
					table.push(var_14_0, var_14_13)
				end
			else
				table.push(var_14_0, var_14_13)
			end
		end
	end
	
	local var_14_19 = Account:getSystemSubstory()
	
	if var_14_19 then
		local var_14_20 = arg_14_0:getSubstoryDB(var_14_19.substory_id)
		
		var_14_20.sort = 999
		
		local var_14_21 = var_14_20.unlock == nil or var_14_20.unlock and UnlockSystem:isUnlockSystem(var_14_20.unlock)
		
		if arg_14_2.unlock_only and var_14_21 then
			table.push(var_14_0, var_14_20)
		elseif not arg_14_2.unlock_only then
			table.push(var_14_0, var_14_20)
		end
	end
	
	local function var_14_22(arg_15_0)
		local var_15_0 = 0
		local var_15_1 = SubStoryUtil:getEventState(arg_15_0.start_time, arg_15_0.end_time)
		
		if not arg_15_0.is_unlock then
		elseif arg_15_0.highlight_preview == "y" and (var_15_1 == SUBSTORY_CONSTANTS.STATE_OPEN or var_15_1 == SUBSTORY_CONSTANTS.STATE_READY) then
			var_15_0 = var_15_0 + 1000000
		elseif var_15_1 == SUBSTORY_CONSTANTS.STATE_OPEN then
			var_15_0 = var_15_0 + 1000000
		elseif var_15_1 == SUBSTORY_CONSTANTS.STATE_READY then
			var_15_0 = var_15_0 + 500000
		elseif var_15_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON then
			var_15_0 = var_15_0 + 50000
		end
		
		return var_15_0 - tonumber(arg_15_0.sort or 1000000)
	end
	
	table.sort(var_14_0, function(arg_16_0, arg_16_1)
		local var_16_0 = var_14_22(arg_16_0)
		local var_16_1 = var_14_22(arg_16_1)
		
		if var_16_0 ~= var_16_1 then
			return var_16_1 < var_16_0
		end
		
		return arg_16_0.start_time < arg_16_1.start_time
	end)
	
	local var_14_23 = to_n(DEBUG.SUBSYORY_LIST_DELETE)
	
	if var_14_23 > 0 then
		for iter_14_3 = 1, var_14_23 do
			table.remove(var_14_0, 1)
		end
	end
	
	return var_14_0
end

function SubStoryUtil.getType(arg_17_0, arg_17_1)
	return DB("substory_main", arg_17_1, "type")
end

function SubStoryUtil.isSystemSubStory(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = "system"
	
	if arg_18_2 and arg_18_2.type == var_18_0 then
		return true
	elseif arg_18_0:getType(arg_18_1) == var_18_0 then
		return true
	end
	
	return false
end

function SubStoryUtil.isChangeSystemSubstory(arg_19_0)
	return arg_19_0:getRemainTimeToChangeSystemSubstory() <= 0
end

function SubStoryUtil.getRemainTimeToChangeSystemSubstory(arg_20_0)
	local var_20_0 = Account:getSystemSubstory()
	local var_20_1 = 99999999
	
	if not var_20_0 then
		Log.e("SubStoryUtil.getRemainTimeToChangeSystemSubstory", "invalid_system_substory")
		
		return var_20_1
	end
	
	local var_20_2 = var_20_0.start_time
	local var_20_3 = os.time()
	
	if var_20_2 then
		local var_20_4 = 1669863600
		local var_20_5 = 1782
		local var_20_6 = 14
		local var_20_7 = 86400
		local var_20_8 = math.floor((var_20_2 - var_20_4) / (var_20_6 * var_20_7))
		local var_20_9 = math.floor((var_20_3 - var_20_4) / (var_20_6 * var_20_7))
		local var_20_10 = var_20_9 + 1
		
		if var_20_8 < var_20_9 then
			return 0
		else
			next_section_start_tm = var_20_4 + var_20_6 * var_20_10 * var_20_7
			
			return next_section_start_tm - var_20_3
		end
	end
	
	Log.e("SubStoryUtil.getRemainTimeToChangeSystemSubstory", "invalid_start_time")
	
	return var_20_1
end

function SubStoryUtil.getLobbySound(arg_21_0)
	return "event:/bgm/default"
end

function SubStoryUtil.getNewSystemSubStoryIDList(arg_22_0)
	local var_22_0
	local var_22_1
	local var_22_2
	
	if not arg_22_0.new_system_substory_id_list then
		for iter_22_0 = 1, 99999 do
			local var_22_3, var_22_4 = DBN("substory_system_main", tostring(iter_22_0), {
				"id",
				"sort"
			})
			
			if not var_22_3 then
				break
			end
			
			if var_22_0 == nil or var_22_0 < var_22_4 then
				var_22_2 = var_22_1
				var_22_1 = var_22_3
			end
		end
		
		arg_22_0.new_system_substory_id_list = {}
		
		table.insert(arg_22_0.new_system_substory_id_list, var_22_1)
		table.insert(arg_22_0.new_system_substory_id_list, var_22_2)
	end
	
	return arg_22_0.new_system_substory_id_list
end

function SubStoryUtil.getChrCodeNewSystemSubstory(arg_23_0)
	local var_23_0 = arg_23_0:getNewSystemSubStoryIDList() or {}
	
	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		if SubstorySystemStory:isOpenSystemSubstorySchedule(iter_23_1) then
			return DB("substory_system_main", iter_23_1, "hero")
		end
	end
end

function SubStoryUtil.isOpenChronicleTitle(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_1 == "map" then
		return Account:isMapCleared(arg_24_2)
	elseif arg_24_1 == "substory" then
		return SubstorySystemStory:isSubstoryCleared(arg_24_2)
	elseif arg_24_1 == "spchange" then
		local var_24_0 = Account:getClassChangeInfoByCode(arg_24_2)
		
		return var_24_0 and var_24_0.state == 2
	elseif arg_24_1 == "sys_achieve" then
		return UnlockSystem:isUnlockSystem(arg_24_2)
	end
	
	return false
end

function SubStoryUtil.getLockChronicleDesc(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0:isOpenChronicleTitle(arg_25_1, arg_25_2) then
		return nil
	end
	
	if arg_25_3 then
		return T(arg_25_3)
	end
	
	if arg_25_1 == "map" then
		local var_25_0, var_25_1 = DB("level_enter", arg_25_2, {
			"episode",
			"name"
		})
		
		if not var_25_0 then
			Log.e("getLockChronicleDesc.no_episode", arg_25_2)
		end
		
		return T("chronicle_lock_map_desc", {
			episode = T("name_" .. var_25_0),
			map = T(var_25_1)
		})
	elseif arg_25_1 == "substory" then
		local var_25_2 = DB("substory_main", arg_25_2, "quest_chapter_desc")
		
		return T("chronicle_lock_substory_desc", {
			substory = T(var_25_2)
		})
	elseif arg_25_1 == "spchange" then
		local var_25_3 = DB("character", arg_25_2, "name")
		
		return T("chronicle_lock_spchange_desc", {
			name = T(var_25_3)
		})
	else
		return "none"
	end
	
	return nil
end

function SubStoryUtil.getSubCusItemList(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	local var_26_0 = GAME_STATIC_VARIABLE.substory_subcus_max_included or 8
	local var_26_1 = {}
	
	for iter_26_0 = 1, var_26_0 do
		local var_26_2 = "ma_subcus_" .. arg_26_1 .. "_" .. iter_26_0
		local var_26_3 = DBT("item_material", var_26_2, {
			"id",
			"name",
			"ma_type",
			"init_count",
			"max_count"
		})
		
		if var_26_3.id and var_26_3.ma_type and var_26_3.ma_type == "subcus" then
			var_26_3.count = Account:getItemCount(var_26_3.id) or 0
			
			table.insert(var_26_1, var_26_3)
		end
	end
	
	return var_26_1
end
