SAVE = SAVE or {
	cache = {}
}

if not SAVE.NIL then
	SAVE.NIL = {}
end

function MsgHandler.save_config_datas(arg_1_0)
end

function SAVE.getTempConfigDatas(arg_2_0)
	arg_2_0.temp_config_datas = arg_2_0.temp_config_datas or {}
	
	return arg_2_0.temp_config_datas
end

function SAVE.setTempConfigData(arg_3_0, arg_3_1, arg_3_2)
	if Account:getConfigData(arg_3_1) == arg_3_2 then
		return 
	end
	
	arg_3_0:getTempConfigDatas()[arg_3_1] = arg_3_2
end

function SAVE.getTempConfigData(arg_4_0, arg_4_1)
	return arg_4_0:getTempConfigDatas()[arg_4_1]
end

function SAVE.setUserDefaultData(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 == nil or arg_5_2 == nil then
		return 
	end
	
	if type(arg_5_2) == "string" then
		cc.UserDefault:getInstance():setStringForKey(arg_5_1, arg_5_2)
	elseif type(arg_5_2) == "number" then
		cc.UserDefault:getInstance():setFloatForKey(arg_5_1, arg_5_2)
	elseif type(arg_5_2) == "boolean" then
		cc.UserDefault:getInstance():setBoolForKey(arg_5_1, arg_5_2)
	else
		Log.e("no_setUserDefaultData!", arg_5_1)
	end
end

function SAVE._makeQuestChapterHashMap(arg_6_0)
	if arg_6_0._mission_id_to_chapter then
		return 
	end
	
	arg_6_0._mission_id_to_chapter = {}
	
	local var_6_0 = {}
	
	for iter_6_0 = 1, 999 do
		local var_6_1, var_6_2, var_6_3 = DBN("quest_episode", iter_6_0, {
			"id",
			"mission_id",
			"key_chapter"
		})
		
		if not var_6_1 then
			break
		end
		
		table.insert(var_6_0, {
			id = var_6_1,
			ep_mission_id = var_6_2,
			key_chapter = var_6_3
		})
	end
	
	for iter_6_1, iter_6_2 in pairs(var_6_0) do
		for iter_6_3 = 1, 999 do
			local var_6_4, var_6_5, var_6_6 = DB("quest_chapter", iter_6_2.key_chapter .. "_" .. iter_6_3, {
				"id",
				"mission_id",
				"key_mission"
			})
			
			if not var_6_4 then
				break
			end
			
			local var_6_7 = {
				id = var_6_4,
				mission_id = var_6_5,
				key_mission = var_6_6,
				episode = iter_6_2.id,
				ep_mission_id = iter_6_2.mission_id
			}
			
			for iter_6_4 = 1, 999 do
				local var_6_8 = DB("mission_data", var_6_6 .. "_" .. iter_6_4, {
					"id"
				})
				
				if not var_6_8 then
					break
				end
				
				arg_6_0._mission_id_to_chapter[var_6_8] = var_6_7
			end
		end
	end
end

function SAVE.updateUserDefaultData_MainQuestClearState(arg_7_0, arg_7_1)
	if SubstoryManager:getInfo() then
		return 
	end
	
	arg_7_1 = arg_7_1 or 1
	
	arg_7_0:_makeQuestChapterHashMap()
	
	local var_7_0 = 1
	local var_7_1 = Account:getActiveQuestID()
	local var_7_2 = Account:getChapterQuestMissions()
	
	if var_7_2["ep" .. arg_7_1 .. "ch10"] and not var_7_1 then
		var_7_0 = arg_7_1
	end
	
	if var_7_1 then
		if arg_7_0._mission_id_to_chapter[var_7_1] then
			var_7_0 = arg_7_0._mission_id_to_chapter[var_7_1].episode
		else
			return 
		end
	else
		for iter_7_0 = 1, arg_7_1 do
			if var_7_2["ep" .. iter_7_0 .. "ch10"] then
				var_7_0 = iter_7_0 + 1
			end
		end
		
		var_7_0 = "ep" .. var_7_0
	end
	
	if not var_7_0 then
		return 
	end
	
	local var_7_3 = string.sub(var_7_0, 3, 3)
	
	if not var_7_3 then
		return 
	end
	
	local var_7_4 = tonumber(var_7_3)
	
	if not var_7_4 then
		return 
	end
	
	if var_7_4 >= EPISODE_THRESHOLD then
		var_7_4 = EPISODE_THRESHOLD
	end
	
	if var_7_4 == EPISODE_THRESHOLD and not Account:isMapCleared("tru017") then
		return 
	end
	
	local var_7_5 = "ep" .. var_7_4
	
	SAVE:setUserDefaultData("main_quest_progress", var_7_5)
end

function SAVE.getUserDefaultData(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == nil or arg_8_2 == nil then
		return 
	end
	
	if type(arg_8_2) == "string" then
		return cc.UserDefault:getInstance():getStringForKey(arg_8_1, arg_8_2)
	elseif type(arg_8_2) == "number" then
		return math.round(cc.UserDefault:getInstance():getFloatForKey(arg_8_1, arg_8_2) * 1000) / 1000
	elseif type(arg_8_2) == "boolean" then
		return cc.UserDefault:getInstance():getBoolForKey(arg_8_1, arg_8_2)
	else
		Log.e("no_getUserDefaultData!", arg_8_1)
	end
end

function SAVE.sendQueryServerConfig(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:updateConfigDataByTemp()
	
	if arg_9_1 or var_9_0 > 0 then
		local var_9_1 = arg_9_0:getJsonConfigData()
		
		query("save_config_datas", {
			config_datas = var_9_1
		})
	end
	
	return var_9_0
end

function SAVE.getJsonConfigData(arg_10_0)
	local var_10_0 = json.encode(Account:getConfigDatas())
	
	if string.len(var_10_0) > 10000 then
		Log.e("SAVE.sendQuery", "warning_10000" .. string.len(var_10_0))
	end
	
	return var_10_0
end

function SAVE.updateConfigDataByTemp(arg_11_0)
	local var_11_0 = arg_11_0:getTempConfigDatas()
	local var_11_1 = 0
	
	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if iter_11_1 == "null" then
			iter_11_1 = nil
		end
		
		local var_11_2 = Account:getConfigDatas()[iter_11_0]
		
		if var_11_2 ~= nil and var_11_2 == iter_11_1 then
			var_11_0[iter_11_0] = nil
		else
			Account:setConfigData(iter_11_0, iter_11_1)
			
			var_11_0[iter_11_0] = nil
			var_11_1 = var_11_1 + 1
		end
	end
	
	return var_11_1
end

function SAVE._set(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if type(arg_12_3) == "table" then
		_setcfg(arg_12_1, arg_12_2, json.encode(arg_12_3), true)
	else
		_setcfg(arg_12_1, arg_12_2, arg_12_3)
	end
end

function SAVE.set(arg_13_0, arg_13_1, arg_13_2)
	SAVE:_set("config.db", arg_13_1, arg_13_2)
	
	arg_13_0.need_to_flush = true
	
	arg_13_0:updateCache(arg_13_1, arg_13_2)
end

function SAVE._getKeepConfigKey(arg_14_0, arg_14_1)
	return "keep:" .. arg_14_1 .. ":" .. Account:getUserId()
end

function SAVE.setKeep(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0:_getKeepConfigKey(arg_15_1)
	
	SAVE:_set("keep_config.db", var_15_0, arg_15_2)
	arg_15_0:updateCache(var_15_0, arg_15_2)
end

function SAVE.getCacheTick(arg_16_0)
	return LAST_TICK + 300000
end

function SAVE.updateCache(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2 or arg_17_2 == false then
		local var_17_0
		
		if string.starts(arg_17_1, "option.") then
			var_17_0 = math.huge
		else
			var_17_0 = arg_17_0:getCacheTick()
		end
		
		arg_17_0.cache[arg_17_1] = {
			arg_17_2,
			var_17_0
		}
	else
		arg_17_0.cache[arg_17_1] = SAVE.NIL
	end
end

function SAVE.getOptionData(arg_18_0, arg_18_1, arg_18_2)
	return arg_18_0:getUserDefaultData(arg_18_1, arg_18_0:get(arg_18_1, arg_18_2))
end

function SAVE._get(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if arg_19_0.cache[arg_19_2] then
		local var_19_0 = arg_19_0.cache[arg_19_2]
		
		if var_19_0[1] == SAVE.NIL then
			return arg_19_3
		end
		
		var_19_0[2] = math.max(to_n(var_19_0[2]), arg_19_0:getCacheTick())
		
		if var_19_0[1] == nil then
			return arg_19_3
		end
		
		return var_19_0[1]
	end
	
	local var_19_1, var_19_2 = _getcfg(arg_19_1, arg_19_2)
	
	if var_19_2 then
		var_19_1 = json.decode(var_19_1)
	end
	
	arg_19_0:updateCache(arg_19_2, var_19_1)
	
	if var_19_1 == nil then
		return arg_19_3
	end
	
	return var_19_1
end

function SAVE.getKeep(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0:_getKeepConfigKey(arg_20_1)
	
	return SAVE:_get("keep_config.db", var_20_0, arg_20_2)
end

function SAVE.get(arg_21_0, arg_21_1, arg_21_2)
	return SAVE:_get("config.db", arg_21_1, arg_21_2)
end

function SAVE.load(arg_22_0)
	SoundEngine:setVolumeMaster(arg_22_0:getOptionData("sound.vol_master", 1))
	SoundEngine:setVolumeBGM(arg_22_0:getOptionData("sound.vol_bgm", 0.7))
	SoundEngine:setVolumeUI(arg_22_0:getOptionData("sound.vol_ui", 1))
	SoundEngine:setVolumeBattle(arg_22_0:getOptionData("sound.vol_battle", 1))
	SoundEngine:setVolumeVoice(arg_22_0:getOptionData("sound.vol_voice", 1))
	SoundEngine:setMute("master", arg_22_0:getOptionData("sound.mute_master", false))
	SoundEngine:setMute("bgm", arg_22_0:getOptionData("sound.mute_bgm", false))
	SoundEngine:setMute("ui", arg_22_0:getOptionData("sound.mute_ui", false))
	SoundEngine:setMute("battle", arg_22_0:getOptionData("sound.mute_battle", false))
	SoundEngine:setMute("voice", arg_22_0:getOptionData("sound.mute_voice", false))
	
	if IS_ANDROID_PC then
		MINIMUM_FPS = 60
	elseif LOW_RESOLUTION_MODE then
		MINIMUM_FPS = 0
	elseif arg_22_0:getOptionData("option.fps60", false) == true then
		MINIMUM_FPS = 60
	else
		MINIMUM_FPS = 0
	end
	
	print("MINIMUM_FPS : ", MINIMUM_FPS)
	
	if arg_22_0:getOptionData("option.adaptive_fps", true) ~= true or IS_ANDROID_PC then
		ADAPTIVE_FPS_FLAG = false
	end
end

function SAVE.incTutorialCounter(arg_23_0)
	local var_23_0 = arg_23_0:getTutorialCounter()
	
	Account:saveTutorialState("init", var_23_0 + 1)
	
	local var_23_1 = json.encode(AccountData.tutorial_list)
	
	query("tutorial_update", {
		tutorial_list = var_23_1
	})
	Singular:introLog(arg_23_0:getTutorialCounter())
	
	if IS_PUBLISHER_ZLONG then
		if arg_23_0:getTutorialCounter() == 1 then
			Zlong:createRole()
		end
		
		local var_23_2 = {
			ZLONG_LOG_CODE.INTRO_TUTORIAL_01,
			ZLONG_LOG_CODE.INTRO_TUTORIAL_02,
			ZLONG_LOG_CODE.INTRO_TUTORIAL_03,
			ZLONG_LOG_CODE.INTRO_TUTORIAL_04,
			ZLONG_LOG_CODE.INTRO_TUTORIAL_05,
			ZLONG_LOG_CODE.INTRO_TUTORIAL_06
		}
		
		Zlong:gameEventLog(var_23_2[arg_23_0:getTutorialCounter()])
	end
end

function SAVE.saveTutorialCount(arg_24_0, arg_24_1)
	Account:saveTutorialState("init", arg_24_1)
	
	local var_24_0 = json.encode(AccountData.tutorial_list)
	
	query("tutorial_update", {
		tutorial_list = var_24_0
	})
	Singular:introLog(arg_24_0:getTutorialCounter())
end

function SAVE.getTutorialCounter(arg_25_0)
	return (to_n(Account:getTutorialState("init")))
end

function SAVE.isPatchCompleteRequired(arg_26_0)
	if DEBUG.SKIP_TUTO then
		return true
	else
		return arg_26_0:getTutorialCounter() >= TOTURIALCOUNT.NEED_START_STORY_CH01_001
	end
end

function SAVE.isTutorialFinished(arg_27_0)
	if DEBUG.SKIP_TUTO then
		return true
	else
		return arg_27_0:getTutorialCounter() >= TOTURIALCOUNT.FIRST_ENTER_LOBBY
	end
end

function SAVE.saveTutorialGuide(arg_28_0, arg_28_1)
	Account:saveTutorialState(arg_28_1, 1)
end

function SAVE.getTutorialGuide(arg_29_0, arg_29_1)
	return Account:getTutorialState(arg_29_1)
end

function SAVE.Poll(arg_30_0)
	if arg_30_0.need_to_flush then
		arg_30_0:flush()
	end
end

function SAVE.save(arg_31_0)
	arg_31_0:Poll()
end

function SAVE.flush(arg_32_0)
	arg_32_0.need_to_flush = nil
end

function SAVE.destroy(arg_33_0)
	print("SAVE Destroy")
	_delcfg("config.db")
	
	arg_33_0.cache = {}
	arg_33_0.need_to_flush = nil
	
	delete_raw_file("config.db")
end

function SAVE.removeExpireConfigDatas(arg_34_0)
	for iter_34_0, iter_34_1 in pairs(Account:getConfigDatas()) do
		if iter_34_0 == "RepeatPlay_StartOn" or iter_34_0 == "exclusive_buy_first" or iter_34_0 == "repeatBattle_count" then
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif iter_34_0 == "red_dot_promotion" then
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif iter_34_0 == "game.random_shop.time" then
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif iter_34_0 == "growth_guide_tracking_group_id" then
			SAVE:setTempConfigData("gg_tracking_groupid", iter_34_1)
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif string.starts(iter_34_0, "help_effect") then
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif string.starts(iter_34_0, "growth_guide_is_opened_unlock_dialog_") then
			local var_34_0 = string.split(iter_34_0, "growth_guide_is_opened_unlock_dialog_")[2]
			
			SAVE:setTempConfigData("gg_unlock_dlg_" .. var_34_0, iter_34_1)
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif string.starts(iter_34_0, "growth_guide_last_opened_id_") then
			local var_34_1 = string.split(iter_34_0, "growth_guide_last_opened_id_")[2]
			
			SAVE:setTempConfigData("gg_last_open_id_" .. var_34_1, iter_34_1)
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif string.starts(iter_34_0, "app.") then
			if string.find(iter_34_0, "last_clear_town") or string.find(iter_34_0, "lastSelectWorldKey") or string.find(iter_34_0, "lastSelectLandKey") or string.find(iter_34_0, "lastSelectTownKey") then
				arg_34_0:copyMapData(iter_34_0, iter_34_1)
			elseif string.find(iter_34_0, "inven_equip_sort_index") or string.find(iter_34_0, "inven_exclusive_sort_index") or string.find(iter_34_0, "unit_list_sort_index") or string.find(iter_34_0, "inven_artifact_sort_index") or string.find(iter_34_0, "equip_enhance_sort_index") or string.find(iter_34_0, "artifact_enhance_sort_index") or string.find(iter_34_0, "equip_wear_sort_index") or string.find(iter_34_0, "artifact_wear_sort_index") then
				arg_34_0:copySortData(iter_34_0, iter_34_1)
			elseif string.find(iter_34_0, "last_postion_town") then
				SAVE:setTempConfigData(iter_34_0, "null")
			end
		elseif string.starts(iter_34_0, "last_clear_town.") then
			arg_34_0:removeSubStoryWorldMapData(iter_34_0)
		elseif string.starts(iter_34_0, "lastSelect") then
			SAVE:setTempConfigData(iter_34_0, "null")
		elseif string.starts(iter_34_0, "substory.") then
			arg_34_0:removeSubStory(iter_34_0)
		elseif string.starts(iter_34_0, "event_mission.") then
			arg_34_0:removeEventMission(iter_34_0)
		end
	end
	
	arg_34_0:sendQueryServerConfig()
end

function SAVE.copyMapData(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_1
	local var_35_1 = string.replace(var_35_0, "app.", "")
	local var_35_2 = string.replace(var_35_1, "map.", "")
	local var_35_3 = string.replace(var_35_2, ".substory", "")
	local var_35_4 = string.replace(var_35_3, ".custom", "")
	
	SAVE:setTempConfigData(var_35_4, arg_35_2)
	SAVE:setTempConfigData(arg_35_1, "null")
end

function SAVE.copySortData(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_1
	local var_36_1 = string.replace(var_36_0, "app.", "")
	
	SAVE:setTempConfigData(var_36_1, arg_36_2)
	SAVE:setTempConfigData(arg_36_1, "null")
end

function SAVE.removeSubStoryWorldMapData(arg_37_0, arg_37_1)
	local var_37_0 = string.split(arg_37_1, "last_clear_town.") or {}
	
	if not var_37_0[2] then
		return 
	end
	
	local var_37_1 = var_37_0[2]
	
	if SubstoryManager:isActiveSchedule(var_37_1, SUBSTORY_CONSTANTS.ONE_WEEK) then
		return 
	end
	
	SAVE:setTempConfigData("last_clear_town." .. var_37_1, "null")
end

function SAVE.removeSubStory(arg_38_0, arg_38_1)
	local var_38_0 = (string.split(arg_38_1, ".") or {})[2]
	
	if not var_38_0 then
		return 
	end
	
	if SubstoryManager:isActiveSchedule(var_38_0, SUBSTORY_CONSTANTS.ONE_WEEK) then
		return 
	end
	
	SAVE:setTempConfigData("substory." .. var_38_0 .. ".festival_b", "null")
	SAVE:setTempConfigData("substory." .. var_38_0 .. ".festival_s", "null")
	SAVE:setTempConfigData("substory." .. var_38_0 .. ".christmas_e", "null")
end

function SAVE.removeEventMission(arg_39_0, arg_39_1)
	local var_39_0 = (string.split(arg_39_1, ".") or {})[2]
	
	if not var_39_0 then
		return 
	end
	
	if EventMissionUtil:isActiveEvent(var_39_0) then
		return 
	end
	
	SAVE:setTempConfigData(arg_39_1, "null")
end
