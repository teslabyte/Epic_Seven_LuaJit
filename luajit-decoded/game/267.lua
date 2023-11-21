CoopUtil = {}

function CoopUtil.setRankText(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_3 == nil or arg_1_3 == 0 or arg_1_5 and arg_1_4 == 0
	local var_1_1 = not var_1_0 and T("pvp_list_rank", {
		rank = arg_1_2 or "-"
	}) or T("pvp_season_rank_no")
	
	if_set(arg_1_1, "txt_rank", var_1_1)
	if_set(arg_1_1, "txt_my_damage", comma_value(arg_1_4))
	if_set_visible(arg_1_1, "txt_my_damage", not var_1_0)
	if_set_visible(arg_1_1, "txt_damage", not var_1_0)
end

function CoopUtil.setDifficulty(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if_set(arg_2_1, arg_2_3 or "txt_level", T("expedition_boss_level_desc2", {
		level = arg_2_2
	}))
	
	local var_2_0 = "cm_icon_difficulty_" .. arg_2_2 .. ".png"
	
	if_set_sprite(arg_2_1, "icon_difficulty", var_2_0)
end

function CoopUtil.makeRankingListView(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3 or {}
	local var_3_1 = ItemListView_v2:bindControl(arg_3_1)
	
	var_3_1:setListViewCascadeEnabled(true)
	
	local var_3_2 = load_control("wnd/expedition_ready_rank_bar.csb")
	local var_3_3 = {
		onUpdate = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			local var_4_0
			local var_4_1 = false
			local var_4_2 = var_3_0 and var_3_0.result_scene
			
			if var_4_2 then
				var_4_0 = arg_4_1:getChildByName("RIGHT_user")
				
				if_set_visible(arg_4_1, "RIGHT_user", true)
				if_set_visible(arg_4_1, "RIGHT", false)
				
				var_4_1 = true
			else
				var_4_0 = arg_4_1:getChildByName("RIGHT")
				
				if_set_visible(arg_4_1, "RIGHT_user", false)
				if_set_visible(arg_4_1, "RIGHT", true)
			end
			
			if_set(var_4_0, "txt_name", arg_4_3.name)
			
			if var_4_1 then
				UIUserData:call(var_4_0:getChildByName("txt_name"), "SINGLE_WSCALE(120)")
				UIUserData:call(var_4_0:getChildByName("txt_damage"), "SINGLE_WSCALE(120)")
			else
				UIUserData:call(var_4_0:getChildByName("txt_name"), "SINGLE_WSCALE(168)")
				UIUserData:call(var_4_0:getChildByName("txt_damage"), "SINGLE_WSCALE(168)")
			end
			
			arg_4_1:setCascadeOpacityEnabled(true)
			
			local var_4_3 = arg_4_3.rank <= 3
			
			if_set_visible(arg_4_1, "txt_toprank", var_4_3)
			if_set_visible(arg_4_1, "txt_rank", not var_4_3)
			
			local var_4_4 = var_4_3 and "txt_toprank" or "txt_rank"
			
			if_set(arg_4_1, var_4_4, T("pvp_list_rank", {
				rank = arg_4_3.rank
			}))
			
			local var_4_5 = arg_4_3.count
			local var_4_6 = arg_3_0:getConfigDBValue("expedition_enter_limit")
			local var_4_7 = to_n(var_4_6) - to_n(var_4_5)
			
			if not var_3_0.ignore_max_count then
				if_set(arg_4_1, "t_count", var_4_7 .. "/" .. var_4_6)
			else
				if_set(arg_4_1, "t_count", to_n(var_4_5))
			end
			
			if_set(var_4_0, "txt_damage", comma_value(arg_4_3.total_score))
			
			local var_4_8 = UIUtil:getLightIcon(arg_4_3.leader_code, arg_4_3.border_code)
			
			arg_4_1:findChildByName("face_icon"):addChild(var_4_8)
			if_set_visible(arg_4_1, "btn_user", var_4_2)
			
			if var_4_2 then
				arg_4_1:getChildByName("btn_user").data = arg_4_3
				
				if arg_4_3.uid and arg_4_3.uid == Account:getUserId() then
					if_set_visible(arg_4_1, "btn_user", false)
				end
			end
		end
	}
	
	var_3_1:setRenderer(var_3_2, var_3_3)
	var_3_1:setDataSource(arg_3_2)
	
	return var_3_1
end

function CoopUtil.showFriendButton(arg_5_0, arg_5_1)
	if not arg_5_1 or not arg_5_1.uid then
		return 
	end
	
	Friend:preview(arg_5_1.uid, nil, {
		off_battle_btn = true
	})
end

function CoopUtil.isValidRtn(arg_6_0, arg_6_1)
	if arg_6_1.coop_rest_time then
		return false
	else
		return true
	end
end

function CoopUtil.ExitLobby(arg_7_0)
	if not get_cocos_refid(CoopMission.maintenance) then
		CoopMission.maintenance = Dialog:msgBox(T("expedition_rest_pop_desc"), {
			title = T("expedition_rest_pop_title"),
			handler = function()
				CoopMission.maintenance = nil
				
				SceneManager:nextScene("lobby")
			end
		})
	end
end

function CoopUtil.findUserData(arg_9_0, arg_9_1, arg_9_2)
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		if to_n(iter_9_0) == arg_9_2 then
			iter_9_1.uid = to_n(iter_9_0)
			
			return iter_9_1
		end
	end
	
	return nil
end

function CoopUtil.makeCoopMemberArray(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {}
	
	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		iter_10_1.uid = to_n(iter_10_0)
		
		local var_10_1 = iter_10_1.count ~= nil and iter_10_1.count > 0
		local var_10_2 = iter_10_1.total_score ~= nil and iter_10_1.total_score > 0
		
		if var_10_1 and (arg_10_2 and var_10_2 or not arg_10_2) then
			table.insert(var_10_0, iter_10_1)
		end
	end
	
	return var_10_0
end

function CoopUtil.getValidList(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2 or {}
	local var_11_1 = arg_11_1
	local var_11_2 = os.time()
	local var_11_3 = Account:getCoopMissionSchedule().season_number
	local var_11_4 = DB("expedition_config", "expedition_result_keep_time", {
		"client_value"
	})
	local var_11_5 = {}
	
	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		local var_11_6 = CoopUtil:getBossInfo(iter_11_1)
		local var_11_7 = iter_11_1.boss_user_info ~= nil and true or false
		
		if var_11_7 and var_11_6.entered == true then
			var_11_7 = false
		end
		
		local var_11_8 = arg_11_0:getLevelData(var_11_6).party_max or 6
		local var_11_9 = false
		
		if var_11_6.season_no ~= var_11_3 or var_11_7 == true and CoopUtil:isExpired(var_11_6.expire_tm, var_11_2) or var_11_6.clear_tm and var_11_2 >= var_11_6.clear_tm + var_11_4 or var_11_8 <= var_11_6.user_count and var_11_7 then
			table.insert(var_11_5, iter_11_0)
			
			var_11_9 = true
		end
		
		if var_11_0.is_open_list and not var_11_9 and CoopUtil:isExpired(var_11_6.expire_tm, var_11_2) then
			table.insert(var_11_5, iter_11_0)
			
			local var_11_10 = true
		end
	end
	
	for iter_11_2, iter_11_3 in pairs(var_11_5) do
		var_11_1[iter_11_3] = nil
	end
	
	return var_11_1
end

function CoopUtil.makeTeamHashTbl(arg_12_0, arg_12_1)
	local var_12_0 = {}
	
	for iter_12_0 = 1, table.count(arg_12_1), 2 do
		local var_12_1 = arg_12_1[iter_12_0]
		local var_12_2 = arg_12_1[iter_12_0 + 1]
		
		var_12_0[var_12_1] = to_n(var_12_2)
	end
	
	return var_12_0
end

function CoopUtil.makeSaveTeamString(arg_13_0, arg_13_1)
	local var_13_0 = ""
	local var_13_1 = table.count(arg_13_1)
	
	for iter_13_0 = 1, var_13_1, 2 do
		var_13_0 = var_13_0 .. arg_13_1[iter_13_0] .. ":" .. arg_13_1[iter_13_0 + 1]
		
		if var_13_1 > iter_13_0 + 1 then
			var_13_0 = var_13_0 .. ":"
		end
	end
	
	return var_13_0
end

function CoopUtil.getTeamIdx(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Account:getCoopMissionBosses()
	local var_14_1 = var_14_0 and var_14_0[arg_14_1] or {}
	local var_14_2 = var_14_1.sort
	local var_14_3 = var_14_1.image or arg_14_2
	local var_14_4 = Account:getConfigData("coop_team_idx")
	local var_14_5 = {}
	
	if var_14_4 then
		local var_14_6 = string.split(var_14_4, ":")
		
		var_14_5 = arg_14_0:makeTeamHashTbl(var_14_6)
	end
	
	local var_14_7 = {
		17,
		18,
		19,
		21,
		22
	}
	
	return var_14_5[var_14_3] or var_14_7[to_n(var_14_2)]
end

function CoopUtil.saveTeamIdx(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = Account:getCoopMissionBosses()
	local var_15_1 = (var_15_0 and var_15_0[arg_15_1] or {}).image or arg_15_3
	
	if not var_15_1 then
		Log.e("NOT SAVE KEY! CHECK BOSS CODE!")
		
		return 
	end
	
	local var_15_2 = Account:getConfigData("coop_team_idx")
	local var_15_3 = {}
	
	if var_15_2 and var_15_2 ~= "" then
		var_15_3 = string.split(var_15_2, ":")
	end
	
	local var_15_4
	
	for iter_15_0 = 1, table.count(var_15_3), 2 do
		if var_15_3[iter_15_0] == var_15_1 then
			var_15_4 = iter_15_0
		end
	end
	
	if var_15_4 then
		var_15_3[var_15_4 + 1] = arg_15_2
	else
		local var_15_5 = table.count(var_15_3)
		
		var_15_3[var_15_5 + 1] = var_15_1
		var_15_3[var_15_5 + 2] = arg_15_2
	end
	
	local var_15_6 = table.count(var_15_3)
	
	if var_15_6 % 2 == 1 then
		var_15_3 = {}
		var_15_6 = 0
	end
	
	local var_15_7 = 10
	local var_15_8 = var_15_7 * 2
	
	if var_15_8 < var_15_6 then
		local var_15_9 = var_15_6 - var_15_8 + 1
		local var_15_10 = {}
		
		for iter_15_1 = var_15_9, var_15_6 do
			var_15_10[iter_15_1 - var_15_9 + 1] = var_15_3[iter_15_1]
		end
		
		var_15_3 = var_15_10
		
		local var_15_11 = table.count(var_15_10)
	end
	
	local var_15_12 = CoopUtil:makeSaveTeamString(var_15_3)
	
	Account:setConfigData("coop_team_idx", var_15_12)
end

function CoopUtil._createRewardPreviewCache(arg_16_0)
	if arg_16_0._reward_preview_cache then
		return 
	end
	
	arg_16_0._reward_preview_cache = {}
	
	for iter_16_0 = 1, 999 do
		local var_16_0, var_16_1, var_16_2, var_16_3, var_16_4 = DBN("expedition_reward_preview", iter_16_0, {
			"id",
			"boss_group_table_id",
			"item_id",
			"type",
			"sort"
		})
		
		if not var_16_0 or not var_16_1 or not var_16_3 then
			break
		end
		
		if not arg_16_0._reward_preview_cache[var_16_1] then
			arg_16_0._reward_preview_cache[var_16_1] = {}
		end
		
		if not arg_16_0._reward_preview_cache[var_16_1][var_16_3] then
			arg_16_0._reward_preview_cache[var_16_1][var_16_3] = {}
		end
		
		arg_16_0._reward_preview_cache[var_16_1][var_16_3][to_n(var_16_4)] = {
			id = var_16_0,
			boss_group_table_id = var_16_1,
			item_id = var_16_2,
			type = var_16_3,
			sort = var_16_4
		}
	end
end

function CoopUtil.getRewardPreviewItem(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:_createRewardPreviewCache()
	
	if not arg_17_0._reward_preview_cache[arg_17_1] then
		return 
	end
	
	return arg_17_0._reward_preview_cache[arg_17_1][arg_17_2]
end

function CoopUtil._createMaxRewardCache(arg_18_0, arg_18_1)
	if arg_18_0._max_reward_point_cache then
		return 
	end
	
	if not arg_18_0._max_reward_point_cache then
		arg_18_0._max_reward_point_cache = {}
	end
	
	for iter_18_0 = 1, 9999 do
		local var_18_0, var_18_1, var_18_2 = DBN("expedition_supply", iter_18_0, {
			"id",
			"supply_group_id",
			"point"
		})
		
		if not var_18_0 or not var_18_1 or not var_18_2 then
			break
		end
		
		if not arg_18_0._max_reward_point_cache[var_18_1] then
			arg_18_0._max_reward_point_cache[var_18_1] = 0
		end
		
		arg_18_0._max_reward_point_cache[var_18_1] = math.max(var_18_2, arg_18_0._max_reward_point_cache[var_18_1])
	end
end

function CoopUtil.getMaxRewardPoint(arg_19_0, arg_19_1)
	arg_19_0:_createMaxRewardCache()
	
	return arg_19_0._max_reward_point_cache[arg_19_1]
end

function CoopUtil.removeRewardInfoDlg(arg_20_0)
	local var_20_0 = SceneManager:getRunningNativeScene():findChildByName("expedition_ready_reward_info")
	
	if var_20_0 then
		var_20_0:removeFromParent()
	end
	
	BackButtonManager:pop()
end

function CoopUtil.openRewardPreviewItem(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = string.format("%s_%d", arg_21_1.boss_code, arg_21_1.difficulty)
	local var_21_1 = arg_21_0:getRewardPreviewItem(var_21_0, "camp") or arg_21_0:getRewardPreviewItem(arg_21_1.boss_code, "camp")
	local var_21_2 = load_dlg("expedition_ready_reward_info", true, "wnd", function()
		arg_21_0:removeRewardInfoDlg()
	end)
	
	var_21_2:setName("expedition_ready_reward_info")
	
	local var_21_3 = var_21_2:findChildByName("n_reward")
	
	for iter_21_0 = 1, 4 do
		if var_21_1[iter_21_0] then
			local var_21_4 = var_21_3:findChildByName("n_item" .. iter_21_0)
			local var_21_5 = var_21_1[iter_21_0].item_id
			
			if get_cocos_refid(var_21_4) then
				var_21_4:setVisible(true)
				UIUtil:getRewardIcon(nil, var_21_5, {
					parent = var_21_4
				})
			end
		end
	end
	
	local var_21_6 = table.count(var_21_1)
	
	if var_21_6 > 2 then
		var_21_3:setPositionX(var_21_3:getPositionX() - 50 * (var_21_6 - 2))
	end
	
	UIUtil:getRewardIcon(nil, arg_21_2.character_id, {
		no_popup = true,
		hide_star = true,
		show_color_right = true,
		no_grade = true,
		parent = var_21_2:findChildByName("mob_icon")
	})
	
	local var_21_7 = arg_21_0:getConfigDBValue("expedition_tm_bonus")
	local var_21_8 = arg_21_0:getConfigDBValue("expire_tm")
	
	if_set(var_21_2, "t_time_save_info", T("expedition_timeattack_desc", {
		expedition_tm_bonus = math.floor(var_21_7 / 60)
	}))
	if_set(var_21_2, "t_disc", T("expedition_reward_pop_desc", {
		expire_tm = math.floor(var_21_8 / 60 / 60)
	}))
	SceneManager:getRunningPopupScene():addChild(var_21_2)
end

function CoopUtil.getRankList(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return {}
	end
	
	if table.empty(arg_23_1) then
		return {}
	end
	
	local var_23_0 = 1
	local var_23_1 = table.clone(arg_23_1)
	
	table.sort(var_23_1, function(arg_24_0, arg_24_1)
		local var_24_0 = tonumber(arg_24_0.total_score)
		local var_24_1 = tonumber(arg_24_1.total_score)
		
		if var_24_0 and var_24_1 and var_24_0 ~= var_24_1 then
			return var_24_1 < var_24_0
		end
		
		local var_24_2 = tonumber(arg_24_0.max_score)
		local var_24_3 = tonumber(arg_24_1.max_score)
		
		if var_24_2 and var_24_3 and var_24_2 ~= var_24_3 then
			return var_24_3 < var_24_2
		end
		
		return to_n(arg_24_0.uid) > to_n(arg_24_1.uid)
	end)
	
	for iter_23_0 = 1, table.count(var_23_1) do
		local var_23_2 = var_23_1[iter_23_0 - 1 > 0 and iter_23_0 - 1 or 1]
		local var_23_3 = var_23_1[iter_23_0]
		
		if to_n(var_23_3.total_score) ~= to_n(var_23_2.total_score) then
			var_23_0 = var_23_0 + 1
		end
		
		var_23_3.rank = var_23_0
	end
	
	return var_23_1
end

function CoopUtil.getFormatIntComma(arg_25_0, arg_25_1)
	local var_25_0, var_25_1, var_25_2, var_25_3, var_25_4 = tostring(arg_25_1):find("([-]?)(%d+)([.]?%d*)")
	local var_25_5 = var_25_3:reverse():gsub("(%d%d%d)", "%1,")
	
	return var_25_2 .. var_25_5:reverse():gsub("^,", "") .. var_25_4
end

function CoopUtil.getConfigDBValue(arg_26_0, arg_26_1)
	if not CoopUtil._db_cache then
		CoopUtil._db_cache = {}
		
		for iter_26_0 = 1, 999 do
			local var_26_0, var_26_1 = DBN("expedition_config", iter_26_0, {
				"id",
				"client_value"
			})
			
			if not var_26_0 then
				break
			end
			
			CoopUtil._db_cache[var_26_0] = var_26_1
		end
	end
	
	return CoopUtil._db_cache[arg_26_1]
end

function CoopUtil.getClearTime(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_1 - arg_27_2
	local var_27_1 = math.floor(var_27_0 / 3600)
	local var_27_2 = math.floor(var_27_0 / 60)
	local var_27_3 = math.floor(var_27_0)
	
	if var_27_1 > 0 then
		var_27_2 = math.floor((var_27_0 - var_27_1 * 60 * 60) / 60)
	end
	
	return var_27_2, var_27_1, var_27_3
end

function CoopUtil.getDisplayLeftTime(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = (arg_28_1 or 0) - arg_28_2
	local var_28_1 = math.floor(var_28_0 / 60)
	local var_28_2 = math.floor(var_28_1 / 60)
	local var_28_3 = var_28_1 - var_28_2 * 60
	
	if arg_28_3 then
		return var_28_0, var_28_3, var_28_2
	else
		return var_28_3, var_28_2
	end
end

function CoopUtil.getLastMonth(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = ({
		31,
		28,
		31,
		30,
		31,
		30,
		31,
		31,
		30,
		31,
		30,
		31
	})[arg_29_1]
	
	if arg_29_1 == 2 and math.mod(arg_29_2, 4) == 0 then
		if math.mod(arg_29_2, 100) == 0 then
			if math.mod(arg_29_2, 400) == 0 then
				var_29_0 = 29
			end
		else
			var_29_0 = 29
		end
	end
	
	return var_29_0
end

function CoopUtil.getRewardDateTime(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or "current"
	
	local var_30_0 = Account:getCoopMissionSchedule().start_time
	local var_30_1, var_30_2 = Account:getCoopMissionSchedule().end_time, var_30_0
	
	if arg_30_1 == "previous" then
		if not CoopMission.vars.custom_season_data then
			return 
		end
		
		local var_30_3 = DB("expedition_main", os.date("%Y%m", CoopMission.vars.custom_season_data.coop_mission_schedule.start_time), {
			"start_date_c"
		})
		local var_30_4 = string.sub(var_30_3, 5, 6)
		local var_30_5 = string.sub(var_30_3, 7, 8)
		local var_30_6 = string.sub(var_30_3, 9, 10)
		local var_30_7 = string.sub(var_30_3, 11, 12)
		local var_30_8 = os.date("%m", var_30_1)
		local var_30_9 = os.date("%d", var_30_1)
		local var_30_10 = os.date("%H", var_30_1)
		local var_30_11 = os.date("%M", var_30_1)
		
		return T("expedition_reward_date", {
			start_month = var_30_4,
			start_day = var_30_5,
			start_hour = var_30_6,
			start_min = var_30_7,
			end_month = var_30_8,
			end_day = var_30_9,
			end_hour = var_30_10,
			end_min = var_30_11
		})
	elseif arg_30_1 == "current" then
		local var_30_12 = os.date("%Y%m", var_30_0 + 86400 * (2 + CoopUtil:getLastMonth(tonumber(os.date("%m", var_30_0)), tonumber(os.date("%Y", var_30_0)))))
		local var_30_13 = DB("expedition_main", var_30_12, {
			"end_date_c"
		})
		local var_30_14 = string.sub(var_30_13, 5, 6)
		local var_30_15 = string.sub(var_30_13, 7, 8)
		local var_30_16 = string.sub(var_30_13, 9, 10)
		local var_30_17 = string.sub(var_30_13, 11, 12)
		local var_30_18 = os.date("%m", var_30_0)
		local var_30_19 = os.date("%d", var_30_0)
		local var_30_20 = os.date("%H", var_30_0)
		local var_30_21 = os.date("%M", var_30_0)
		
		return T("expedition_reward_date", {
			start_month = var_30_18,
			start_day = var_30_19,
			start_hour = var_30_20,
			start_min = var_30_21,
			end_month = var_30_14,
			end_day = var_30_15,
			end_hour = var_30_16,
			end_min = var_30_17
		})
	end
	
	local var_30_22 = os.date("%m", var_30_2)
	local var_30_23 = os.date("%d", var_30_2)
	local var_30_24 = os.date("%H", var_30_2)
	local var_30_25 = os.date("%M", var_30_2)
	local var_30_26 = os.date("%m", var_30_1)
	local var_30_27 = os.date("%d", var_30_1)
	local var_30_28 = os.date("%H", var_30_1)
	local var_30_29 = os.date("%M", var_30_1)
	
	return T("expedition_reward_date", {
		start_month = var_30_22,
		start_day = var_30_23,
		start_hour = var_30_24,
		start_min = var_30_25,
		end_month = var_30_26,
		end_day = var_30_27,
		end_hour = var_30_28,
		end_min = var_30_29
	})
end

function CoopUtil.getLevelData(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1.boss_info or arg_31_1
	local var_31_1 = var_31_0.boss_code
	local var_31_2 = tostring(var_31_0.difficulty)
	
	return ((((Account:getCoopMissionData().coop_mission_schedule or {}).boss or {})[var_31_1] or {}).level_info or {})[var_31_2] or {}
end

function CoopUtil.isShowBattleMenuRedDot(arg_32_0)
	return arg_32_0:isShowIconRedDot() == true
end

function CoopUtil.isShowIcon(arg_33_0)
	if not Account:getCoopMissionData() or not Account:getCoopMissionData().latest_invite_tm then
		return false
	end
	
	local var_33_0 = table.count(Account:getCoopMissionData().ticket_list) ~= 0
	
	if (Account:getCoopMissionData().my_room_count or 0) > 0 then
		return true
	end
	
	if tonumber(Account:getCoopMissionData().latest_invite_tm) == 0 and not var_33_0 then
		return false
	end
	
	if var_33_0 or Account:getCoopMissionData().latest_invite_tm and Account:getCoopMissionData().latest_invite_tm ~= 0 then
		return true
	end
	
	return false
end

function CoopUtil.isShowIconRedDot(arg_34_0)
	if not Account:getCoopMissionData() or not Account:getCoopMissionData().latest_invite_tm then
		return false
	end
	
	if table.count(Account:getCoopMissionData().ticket_list) > 0 then
		return true
	end
	
	if Account:getCoopMissionData().latest_invite_tm and Account:getCoopMissionData().latest_invite_tm ~= 0 then
		return true
	end
	
	return false
end

function CoopUtil.getTextLeftTime(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_3 = arg_35_3 or "expedition_left_time"
	
	local var_35_0, var_35_1, var_35_2 = arg_35_0:getDisplayLeftTime(arg_35_1, arg_35_2, true)
	
	if var_35_0 < 60 then
		return T(arg_35_3, {
			hour = "",
			min = T("remain_sec", {
				sec = math.max(var_35_0, 0)
			})
		})
	else
		return T(arg_35_3, {
			hour = T("remain_hour", {
				hour = math.max(var_35_2, 0)
			}),
			min = T("remain_min", {
				min = math.max(var_35_1, 0)
			})
		})
	end
end

function CoopUtil.isExpired(arg_36_0, arg_36_1, arg_36_2)
	return arg_36_1 < arg_36_2
end

function CoopUtil.isUsableBonusTime(arg_37_0)
	return false
end

function CoopUtil.isBonusTime(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0:isUsableBonusTime() then
		return false
	end
	
	return arg_38_2 <= arg_38_1 + DB("expedition_config", "expedition_tm_bonus", {
		"client_value"
	})
end

function CoopUtil.getMaxBossDifficulty(arg_39_0, arg_39_1)
	local var_39_0 = Account:getCoopMissionSchedule()
	
	if not var_39_0 then
		return 0
	end
	
	if not var_39_0.boss then
		return 0
	end
	
	if not var_39_0.boss[arg_39_1] then
		return 0
	end
	
	if not var_39_0.boss[arg_39_1].level_info then
		return 0
	end
	
	return table.count(var_39_0.boss[arg_39_1].level_info)
end

function CoopUtil.getDifficultyInfo(arg_40_0, arg_40_1)
	local var_40_0 = CoopUtil:getMaxBossDifficulty(arg_40_1)
	
	if var_40_0 == 0 then
		return nil
	end
	
	return Account:getCoopMissionSchedule().boss[arg_40_1].level_info[tostring(var_40_0)]
end

function CoopUtil.get_boss_img_from_id(arg_41_0, arg_41_1)
	arg_41_1 = arg_41_1 or {}
	arg_41_1.node = arg_41_1.node or load_dlg("expedition_map_boss", true, "wnd")
	
	if not get_cocos_refid(arg_41_1.node) then
		print("error : CoopMission.get_boss_img_from_id , node == nil ")
		Log.e(debug.traceback())
		
		return 
	end
	
	if not arg_41_1.boss_code and not arg_41_1.boss_id then
		Log.e(debug.traceback())
		
		return 
	end
	
	local var_41_0 = {
		id = arg_41_1.id or arg_41_1.boss_code
	}
	
	var_41_0.character_id = ""
	var_41_0.node = arg_41_1.node
	var_41_0.name = ""
	var_41_0.attribute = ""
	var_41_0.count = arg_41_1.count
	var_41_0.image = ""
	CoopMission.drop_boss_slot = arg_41_1.boss_slot
	var_41_0.character_id = Account:getCoopMissionSchedule().boss[var_41_0.id].character_id
	var_41_0.image = Account:getCoopMissionSchedule().boss[var_41_0.id].image
	var_41_0.name, var_41_0.attribute = DB("character", var_41_0.character_id, {
		"name",
		"ch_attribute"
	})
	
	if_set(var_41_0.node, "t_name", T(var_41_0.name))
	if_set_sprite(var_41_0.node, "boss", "face/" .. var_41_0.image .. ".png")
	if_set_sprite(var_41_0.node, "icon", "img/cm_icon_pro" .. var_41_0.attribute .. ".png")
	
	return var_41_0
end

function CoopUtil.getBossInfo(arg_42_0, arg_42_1)
	return arg_42_1.boss_info ~= nil and arg_42_1.boss_info or arg_42_1
end

function CoopUtil.getBossHpRate(arg_43_0, arg_43_1, arg_43_2)
	if not arg_43_1 or not arg_43_2 then
		return 0
	end
	
	return math.max(0, arg_43_2 / arg_43_1)
end

function CoopUtil.onUpdate(arg_44_0)
	arg_44_0.refresh_cool_time = arg_44_0.refresh_cool_time or 10
	
	if arg_44_0.refresh_cool_time < 10 then
		arg_44_0.refresh_cool_time = arg_44_0.refresh_cool_time + 1
	end
end

function CoopUtil.getBossRoomCount(arg_45_0, arg_45_1, arg_45_2)
	if not Account:getCoopMissionData() or arg_45_2 and arg_45_2.type and arg_45_2.type == "open" then
		return nil
	end
	
	arg_45_2 = arg_45_2 or {
		type = "share"
	}
	
	local var_45_0 = Account:getCoopListByType(arg_45_2.type)
	local var_45_1 = 0
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		if iter_45_1.boss_code == arg_45_1 and iter_45_1.season_no == Account:getCoopMissionSchedule().season_number then
			var_45_1 = var_45_1 + 1
		end
	end
	
	return var_45_1
end

function CoopUtil.getBossLevelFromLevelData(arg_46_0, arg_46_1)
	local var_46_0
	local var_46_1
	
	for iter_46_0 = 1, 40 do
		local var_46_2, var_46_3, var_46_4 = DB("level_enter_drops", arg_46_1.level_enter, {
			"monster" .. iter_46_0,
			"lv" .. iter_46_0,
			"power" .. iter_46_0
		})
		
		if var_46_2 == arg_46_1.character_id then
			return var_46_3
		end
	end
end

function CoopUtil.isClearedRooms(arg_47_0, arg_47_1)
	local var_47_0 = {}
	
	table.merge(var_47_0, Account:getCoopMissionData().my_lists)
	table.merge(var_47_0, Account:getCoopMissionData().invite_list)
	
	local var_47_1 = false
	local var_47_2 = 0
	
	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		if iter_47_1.boss_code == arg_47_1 then
			local var_47_3 = iter_47_1.boss_info or iter_47_1
			local var_47_4 = var_47_3.expire_tm or 0
			local var_47_5 = os.time()
			
			var_47_2 = ((var_47_3.last_hp or 0) <= 0 or CoopUtil:isExpired(var_47_4, var_47_5)) == true and var_47_2 + 1 or var_47_2
		end
	end
	
	return var_47_2 > 0, var_47_2
end

function CoopUtil.getCoopInviteAllSaveTable()
	local var_48_0 = SAVE:get("coop.invite_all", "")
	local var_48_1 = json.decode(var_48_0)
	
	if type(var_48_1) ~= "table" then
		var_48_1 = {}
	end
	
	return var_48_1
end

function CoopUtil.isExistsInviteAllList(arg_49_0, arg_49_1)
	return arg_49_0:getCoopInviteAllSaveTable()[tostring(arg_49_1)] ~= nil
end

function CoopUtil.addSaveInviteAllList(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0:getCoopInviteAllSaveTable()
	
	var_50_0[tostring(arg_50_1)] = arg_50_2 or os.time()
	
	SAVE:set("coop.invite_all", json.encode(var_50_0))
end

function CoopUtil.removeSaveInviteAllList(arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0:getCoopInviteAllSaveTable()
	
	var_51_0[tostring(arg_51_1)] = nil
	
	SAVE:set("coop.invite_all", json.encode(var_51_0))
end

function CoopUtil.updateSaveInviteAllList(arg_52_0)
	local var_52_0 = arg_52_0:getCoopInviteAllSaveTable()
	
	if table.empty(var_52_0) then
		return 
	end
	
	local var_52_1 = DB("expedition_config", "expire_tm", "client_value")
	local var_52_2 = tonumber(var_52_1)
	local var_52_3 = os.time()
	
	for iter_52_0, iter_52_1 in pairs(var_52_0) do
		if var_52_3 > tonumber(iter_52_1) + var_52_2 then
			var_52_0[iter_52_0] = nil
		end
	end
	
	SAVE:set("coop.invite_all", json.encode(var_52_0))
end

function CoopUtil.isUnlockOpenDifficulty(arg_53_0, arg_53_1)
	if not arg_53_1 then
		return 
	end
	
	local var_53_0 = arg_53_0:getUnlockOpenId(arg_53_1)
	
	if not var_53_0 then
		return 
	end
	
	local var_53_1 = UnlockSystem:isUnlockSystem(var_53_0, {
		is_link = true
	})
	local var_53_2
	local var_53_3
	
	if not var_53_1 then
		var_53_2, var_53_3 = DB("system_achievement_effect", var_53_0, {
			"effect_title",
			"btn_before_text"
		})
	end
	
	return var_53_1, var_53_2, var_53_3
end

function CoopUtil.getUnlockOpenId(arg_54_0, arg_54_1)
	if not arg_54_1 then
		return 
	end
	
	local var_54_0, var_54_1 = DB("expedition_boss_additional_info", arg_54_1, {
		"id",
		"unlock_id"
	})
	
	if not var_54_0 or not var_54_1 then
		return 
	end
	
	return var_54_1
end

function CoopUtil.openInviteResultDialog(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = {
		failed = "expendition_party_call_failed_desc",
		both = "expendition_party_call_both_desc",
		complete = "expedition_party_call_complete_desc"
	}
	
	if arg_55_2 then
		var_55_0.complete = "expedition_party_call_complete_desc_all"
		var_55_0.both = "expendition_party_call_both_desc_all"
	end
	
	local var_55_1 = "complete"
	local var_55_2 = table.count(arg_55_1.invitee_user_list)
	local var_55_3 = table.count(arg_55_1.invited_user_list)
	
	if var_55_2 ~= var_55_3 then
		var_55_1 = var_55_3 == 0 and "failed" or "both"
	end
	
	local var_55_4 = T(var_55_0[var_55_1])
	
	Dialog:msgBox(var_55_4, {
		title = T("expedition_party_call_title")
	})
end
