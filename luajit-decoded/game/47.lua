Analytics = {}

function Analytics.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.beforeSceneName = ""
	arg_1_0.vars.curSceneName = ""
	arg_1_0.vars.tabKey = ""
	arg_1_0.vars.start_time = 0
	arg_1_0.vars.map_id = ""
	arg_1_0.vars.load_loaclData_once = false
	arg_1_0.vars.last_send_Time = 0
	arg_1_0.vars.saveTime_interval = 1800000
	arg_1_0.vars.logs = {}
	arg_1_0.vars.logs.action = {}
	arg_1_0.vars.logs.ui_scene = {}
	arg_1_0.vars.shop_count = {}
	arg_1_0.vars.last_send_Time_local = 0
	arg_1_0.vars.saveTime_interval_local = 300000
end

Analytics:init()

function Analytics._dev_interval_time_set(arg_2_0, arg_2_1)
	if not arg_2_0.vars or not arg_2_1 then
		return 
	end
	
	arg_2_0.vars.saveTime_interval = arg_2_1
end

function Analytics._dev_interval_time_reset(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	arg_3_0.vars.saveTime_interval = 1800000
end

function Analytics.getDayID(arg_4_0)
	if not arg_4_0.vars or not AccountData then
		return 0
	end
	
	local var_4_0, var_4_1, var_4_2 = Account:serverTimeDayLocalDetail()
	
	return var_4_0
end

function Analytics.setCurScene(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if not arg_5_0.vars then
		return 
	end
	
	local var_5_0 = arg_5_0:getTime()
	
	if arg_5_1 then
		arg_5_0.vars.beforeSceneName = arg_5_1
		
		arg_5_0:saveData(arg_5_1)
	end
	
	if arg_5_2 then
		arg_5_0.vars.start_time = var_5_0
		arg_5_0.vars.curSceneName = arg_5_2
		
		if arg_5_3 and arg_5_3.logic and arg_5_3.logic.stageMap.map_data.enter then
			arg_5_0.vars.map_id = arg_5_3.logic.stageMap.map_data.enter
		else
			arg_5_0.vars.map_id = nil
		end
	end
end

function Analytics.createKey(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.map_id and arg_6_1 == "battle"
	local var_6_1 = ""
	local var_6_2 = ""
	local var_6_3 = ""
	local var_6_4 = ""
	local var_6_5 = {}
	local var_6_6 = true
	
	if var_6_0 then
		var_6_1 = "action"
		
		local var_6_7, var_6_8, var_6_9 = DB("level_enter", arg_6_0.vars.map_id, {
			"type",
			"contents_type",
			"local"
		})
		
		if var_6_8 then
			var_6_2 = var_6_8
		else
			var_6_2 = var_6_7
		end
		
		if var_6_9 and var_6_9 == "pvp" then
			if string.find(arg_6_0.vars.map_id, "pvp") then
				var_6_2 = "pvp_player"
			elseif string.find(arg_6_0.vars.map_id, "clan_war") then
				var_6_2 = "pvp_clan_war"
			elseif string.find(arg_6_0.vars.map_id, "rta") then
				var_6_2 = "pvp_net"
			elseif string.find(arg_6_0.vars.map_id, "tournament") then
				var_6_2 = "tournament"
			end
			
			if Battle.logic and Battle.logic:isPVP() and Battle.logic.enemy_uid and string.split(Battle.logic.enemy_uid, ":")[1] == "npc" then
				var_6_2 = "pvp_npc"
			end
		end
		
		var_6_2 = var_6_2 or "unknown"
		var_6_3 = arg_6_0.vars.map_id
		var_6_4 = var_6_1 .. "/" .. var_6_2 .. "/" .. var_6_3
		var_6_5.map_id = arg_6_0.vars.map_id
	else
		var_6_1 = "ui_scene"
		var_6_2 = arg_6_1
		var_6_3 = arg_6_0:getTabKey()
		
		if not var_6_3 then
			var_6_6 = false
		else
			local var_6_10 = arg_6_0:checkMiddleKey_exception(var_6_3)
			
			if var_6_10 then
				var_6_2 = var_6_10
			end
			
			var_6_4 = var_6_1 .. "/" .. var_6_2 .. "/" .. var_6_3
			
			arg_6_0:setTabKey(nil)
		end
	end
	
	var_6_5.main_key = string.lower(var_6_1 or "")
	var_6_5.middle_key = string.lower(var_6_2 or "")
	var_6_5.sub_key = string.lower(var_6_3 or "")
	
	return var_6_4, var_6_1, var_6_5, var_6_6
end

function Analytics.checkMiddleKey_exception(arg_7_0, arg_7_1)
	if arg_7_1 == "inventory" or arg_7_1 == "unit_equip" or arg_7_1 == "equip_upgrade" then
		return "equipment_manager_ui"
	elseif arg_7_1 == "gacha_inven" then
		return "unit_ui"
	end
	
	return false
end

function Analytics.toggleTab(arg_8_0, arg_8_1)
	Analytics:saveCurTabTime()
	Analytics:setMode(arg_8_1)
end

function Analytics.setPopup(arg_9_0, arg_9_1)
	arg_9_0:saveBeforeTab()
	arg_9_0:saveCurTabTime()
	arg_9_0:setMode(arg_9_1)
end

function Analytics.closePopup(arg_10_0)
	arg_10_0:toggleTab(arg_10_0:getBeforeTab())
end

function Analytics.setMode(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	arg_11_0:setTabKey(arg_11_1)
	
	arg_11_0.vars.start_time = arg_11_0:getTime()
end

function Analytics.setTabKey(arg_12_0, arg_12_1)
	arg_12_0.vars.tabKey = arg_12_1
end

function Analytics.getTabKey(arg_13_0)
	return arg_13_0.vars.tabKey
end

function Analytics.getBeforeTab(arg_14_0)
	return arg_14_0.vars.before_tab
end

function Analytics.saveBeforeTab(arg_15_0)
	arg_15_0.vars.before_tab = arg_15_0.vars.tabKey
end

function Analytics.saveCurTabTime(arg_16_0)
	arg_16_0:saveData(arg_16_0.vars.curSceneName)
	arg_16_0:setTabKey(nil)
end

function Analytics.saveData(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return 
	end
	
	local var_17_0, var_17_1, var_17_2, var_17_3 = arg_17_0:createKey(arg_17_1)
	
	if not var_17_0 or not var_17_1 or not var_17_3 then
		return 
	end
	
	if var_17_0 == "" or var_17_1 == "" then
		return 
	end
	
	local var_17_4 = arg_17_0:getTime()
	
	if arg_17_0.vars.start_time then
		local var_17_5 = var_17_4 - arg_17_0.vars.start_time
		local var_17_6 = arg_17_0:getMinTime(var_17_0, var_17_2)
		local var_17_7 = arg_17_0:getMaxTime(var_17_0, var_17_2)
		
		if var_17_5 >= 1 and var_17_6 < var_17_5 then
			if var_17_7 < var_17_5 then
				var_17_5 = var_17_7
			end
			
			local var_17_8 = math.floor(var_17_5 / 1000)
			local var_17_9 = {
				key = var_17_0,
				acc_time = var_17_8,
				result_key_table = var_17_2
			}
			
			arg_17_0:updateLogTable(var_17_1, var_17_9)
		end
	end
end

function Analytics.checkSaveDatas(arg_18_0)
	if arg_18_0:getTime() - arg_18_0.vars.last_send_Time > arg_18_0.vars.saveTime_interval then
		return true
	end
	
	return false
end

function Analytics.getTime(arg_19_0)
	return math.floor(LAST_TICK or -1)
end

function Analytics.updateLogTable(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if not arg_20_1 or not arg_20_2 then
		return 
	end
	
	if ContentDisable:byAlias("user_player_time") then
		return 
	end
	
	local var_20_0
	
	var_20_0 = arg_20_3 or {}
	
	local var_20_1 = false
	local var_20_2 = arg_20_0:getMaxTime(arg_20_2.key, arg_20_2.result_key_table)
	
	if arg_20_0.vars.logs[arg_20_1] then
		for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.logs[arg_20_1]) do
			if iter_20_1.key == arg_20_2.key then
				var_20_1 = true
				iter_20_1.acc_time = iter_20_1.acc_time + arg_20_2.acc_time
				
				if var_20_2 < iter_20_1.acc_time then
					iter_20_1.acc_time = var_20_2
				end
			end
		end
	end
	
	if not var_20_1 then
		if not arg_20_0.vars.logs[arg_20_1] then
			arg_20_0.vars.logs[arg_20_1] = {}
		end
		
		table.insert(arg_20_0.vars.logs[arg_20_1], arg_20_2)
	end
	
	if arg_20_2.result_key_table and arg_20_2.result_key_table.middle_key and arg_20_2.result_key_table.middle_key == "shop" then
		local var_20_3 = arg_20_2.result_key_table
		
		if var_20_3.sub_key then
			local var_20_4 = var_20_3.sub_key or ""
			
			if not arg_20_0.vars.shop_count[var_20_4] then
				arg_20_0.vars.shop_count[var_20_4] = 1
			else
				arg_20_0.vars.shop_count[var_20_4] = arg_20_0.vars.shop_count[var_20_4] + 1
			end
		end
	end
	
	print("user time log Save", arg_20_2.key, arg_20_2.acc_time, " Sec")
end

function Analytics.getMinTime(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_1 or not arg_21_2 then
		return 1000
	end
	
	local var_21_0 = arg_21_2.main_key or ""
	local var_21_1 = arg_21_2.middle_key or ""
	local var_21_2 = arg_21_2.sub_key or ""
	
	for iter_21_0 = 1, 999 do
		local var_21_3, var_21_4, var_21_5, var_21_6, var_21_7, var_21_8, var_21_9, var_21_10 = DBN("player_time", iter_21_0, {
			"id",
			"result_key",
			"category",
			"dungeon_mode",
			"ready_mode",
			"type",
			"key",
			"min_time"
		})
		
		if not var_21_3 then
			break
		end
		
		if var_21_5 == var_21_0 and var_21_8 == var_21_1 and var_21_10 then
			if var_21_8 == "dungeonlist" and var_21_6 and var_21_7 then
				if string.find(var_21_2, var_21_6) and string.find(var_21_2, var_21_7) then
					return var_21_10
				end
			elseif (var_21_8 == "world_sub" or var_21_8 == "worldmap_scene") and var_21_7 then
				if string.find(var_21_2, var_21_7) then
					return var_21_10
				end
			elseif var_21_9 == var_21_2 then
				return var_21_10
			end
		elseif var_21_5 == var_21_0 and var_21_0 == "action" and var_21_10 and var_21_1 == var_21_9 then
			return var_21_10
		end
	end
	
	return 1000
end

function Analytics.getMaxTime(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_1 or not arg_22_2 then
		return 1800000
	end
	
	local var_22_0 = arg_22_2.main_key or ""
	local var_22_1 = arg_22_2.middle_key or ""
	local var_22_2 = arg_22_2.sub_key or ""
	
	for iter_22_0 = 1, 999 do
		local var_22_3, var_22_4, var_22_5, var_22_6, var_22_7, var_22_8, var_22_9, var_22_10 = DBN("player_time", iter_22_0, {
			"id",
			"result_key",
			"category",
			"dungeon_mode",
			"ready_mode",
			"type",
			"key",
			"max_time"
		})
		
		if not var_22_3 then
			break
		end
		
		if var_22_5 == var_22_0 and var_22_8 == var_22_1 and var_22_10 then
			if var_22_8 == "dungeonlist" and var_22_6 and var_22_7 then
				if string.find(var_22_2, var_22_6) and string.find(var_22_2, var_22_7) then
					return var_22_10
				end
			elseif (var_22_8 == "world_sub" or var_22_8 == "worldmap_scene") and var_22_7 then
				if string.find(var_22_10, var_22_7) then
					return min_time
				end
			elseif var_22_9 == var_22_2 then
				return var_22_10
			end
		elseif var_22_5 == var_22_0 and var_22_0 == "action" and var_22_10 and var_22_1 == var_22_9 then
			return var_22_10
		end
	end
	
	return 1800000
end

function Analytics.getDatas(arg_23_0)
	if not arg_23_0.vars or not arg_23_0:checkSaveDatas() then
		return 
	end
	
	if ContentDisable:byAlias("user_player_time") then
		return 
	end
	
	if table.empty(arg_23_0.vars.logs.action) and table.empty(arg_23_0.vars.logs.ui_scene) then
		return 
	end
	
	local var_23_0 = json.encode(arg_23_0.vars.logs)
	
	print("user time log send.lobby", Analytics:getTime())
	
	arg_23_0.vars.last_send_Time = Analytics:getTime()
	
	arg_23_0:refreshAll()
	
	return var_23_0
end

function Analytics.refreshAll(arg_24_0)
	arg_24_0.vars.logs = {}
	arg_24_0.vars.logs.action = {}
	arg_24_0.vars.logs.ui_scene = {}
	
	arg_24_0:resetLocalLogs()
end

function Analytics.getMapKey(arg_25_0, arg_25_1)
	local var_25_0 = ""
	local var_25_1, var_25_2 = DB("level_enter", arg_25_1, {
		"type",
		"contents_type"
	})
	
	if var_25_2 and WorldMapManager:getController() and (var_25_2 == "substory" or var_25_2 == "adventure") then
		var_25_0 = WorldMapManager:getController():getMapKey()
	elseif var_25_1 and (var_25_1 == "genie" or var_25_1 == "abyss" or var_25_1 == "hunt" or var_25_1 == "trial_hall" or var_25_1 == "dungeon" or var_25_1 == "coop" or var_25_1 == "heritage") then
		if var_25_1 == "abyss" and var_25_2 and var_25_2 == "automaton" then
			var_25_0 = var_25_2
		else
			var_25_0 = var_25_1
		end
	end
	
	var_25_0 = var_25_0 or arg_25_1
	arg_25_1 = var_25_0 .. "/" .. arg_25_1
	
	return arg_25_1 or ""
end

function Analytics.loadLocalLogDatas_once(arg_26_0)
	if not arg_26_0.vars or arg_26_0.vars.load_loaclData_once == true then
		return 
	end
	
	arg_26_0.vars.logs = SAVE:get("analytics.user_play_time_logs", {
		ui_scene = {},
		actions = {}
	})
	arg_26_0.vars.load_loaclData_once = true
end

function Analytics.saveLocalLogs(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	if table.empty(arg_27_0.vars.logs.action) and table.empty(arg_27_0.vars.logs.ui_scene) then
		return 
	end
	
	if arg_27_0:getTime() - arg_27_0.vars.last_send_Time_local > arg_27_0.vars.saveTime_interval_local then
		SAVE:set("analytics.user_play_time_logs", arg_27_0.vars.logs)
		
		arg_27_0.vars.last_send_Time_local = arg_27_0:getTime()
		
		print("save analytics local log data")
	end
end

function Analytics.resetLocalLogs(arg_28_0)
	SAVE:set("analytics.user_play_time_logs", {
		actions = {},
		ui_scene = {}
	})
end
