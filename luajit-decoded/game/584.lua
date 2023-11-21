Tournament = Tournament or {}

local var_0_0 = 3

function HANDLER.dungeon_tournament(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_main_tab") then
		local var_1_0 = string.split(arg_1_1, "btn_main_tab")[2]
		
		Tournament:changeGroupByIdx(var_1_0)
	end
	
	if arg_1_1 == "btn_go" then
		Tournament:onReady(Tournament:getSelectIdx())
	end
end

function HANDLER.dungeon_tournament_item(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_select" then
		Tournament:setSelectItem(arg_2_0.idx)
	end
end

function MsgHandler.tournament_enter(arg_3_0)
	set_high_fps_tick(6000)
	TransitionScreen:show({
		on_show_before = function(arg_4_0)
			SoundEngine:play("event:/ui/pvp/door_close")
			
			return EffectManager:Play({
				fn = "war_gate_close.cfx",
				pivot_z = 99998,
				layer = arg_4_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_hide_before = function(arg_5_0)
			arg_5_0:removeAllChildren()
			SoundEngine:play("event:/ui/pvp/door_open")
			
			return EffectManager:Play({
				fn = "war_gate_open.cfx",
				pivot_z = 99998,
				layer = arg_5_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_show = function()
			Tournament:startBattle(arg_3_0)
		end
	})
end

function ErrHandler.tournament_enter(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = T(arg_7_1)
	
	Dialog:msgBox(var_7_0)
end

function MsgHandler.tournament_clear(arg_8_0)
	Tournament:battleClear(arg_8_0)
end

function Tournament.clear(arg_9_0)
	arg_9_0.vars = nil
end

function Tournament.battleClear(arg_10_0, arg_10_1)
	local var_10_0 = {}
	
	if arg_10_1.rewards then
		var_10_0 = Account:addReward(arg_10_1.rewards).new_units or {}
	end
	
	if arg_10_1.doc_tournament_attri then
		arg_10_0:setTournametInfo(arg_10_1.doc_tournament_attri)
	end
	
	if arg_10_1.tournament_id and arg_10_1.result_info.is_win == true then
		ConditionContentsManager:dispatch("tournament.clear", {
			touranment_id = arg_10_1.tournament_id
		})
		arg_10_0:saveNextTarget(arg_10_1.substory_id, arg_10_1.tournament_id)
	end
	
	ClearResult:show(Battle.logic, {
		map_id = "tournament00100",
		tournament_id = arg_10_1.tournament_id,
		tournament_result = arg_10_1.result_info,
		tournament_reward = arg_10_1.rewards_info,
		first_get_units = var_10_0
	})
end

function Tournament.getNpcList(arg_11_0)
	return arg_11_0.npc_list
end

function Tournament.setNpcList(arg_12_0, arg_12_1)
	arg_12_0.npc_list = arg_12_1
end

function Tournament.setTournametInfos(arg_13_0, arg_13_1)
	arg_13_0.tournament_infos = arg_13_1
end

function Tournament.setTournametInfo(arg_14_0, arg_14_1)
	arg_14_0.tournament_infos[arg_14_1.tournament_id] = arg_14_1
end

function Tournament.getTournamentInfos(arg_15_0)
	return arg_15_0.tournament_infos
end

function Tournament.show(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.vars = {}
	
	local var_16_0 = load_dlg("dungeon_tournament", true, "wnd")
	
	arg_16_1:addChild(var_16_0)
	
	arg_16_0.vars.wnd = var_16_0
	arg_16_0.vars.tournament_layer = var_16_0:getChildByName("tournament_layer")
	arg_16_0.vars.team_layer = var_16_0:getChildByName("team_layer")
	
	local var_16_1 = var_16_0:getChildByName("tree")
	
	arg_16_0.vars.n_lines_active = var_16_1:getChildByName("lines_active")
	
	ConditionContentsManager:tournamentForceUpdateConditions()
	
	local var_16_2 = SubstoryManager:getInfo()
	
	arg_16_0.vars.sub_story = var_16_2
	
	local var_16_3 = arg_16_0:getContentsDB()
	
	arg_16_0.vars.DB = arg_16_0:getDB()
	arg_16_0.vars.item_wnds = {}
	arg_16_0.vars.select_idx = nil
	
	local var_16_4 = arg_16_0:getTargetGroupID(var_16_2.id)
	
	if var_16_4 then
		arg_16_0:changeGroup(var_16_4)
	else
		arg_16_0:changeGroupByIdx(1)
	end
	
	local var_16_5 = {}
	
	for iter_16_0 = 1, 3 do
		local var_16_6 = var_16_2["token_id" .. iter_16_0]
		
		if var_16_6 then
			table.insert(var_16_5, var_16_6)
		end
	end
	
	arg_16_0.vars.currencies = var_16_5
	
	TopBarNew:create(T("ui_dungeon_tournament_title"), arg_16_0.vars.tournament_layer, function()
		SceneManager:popScene()
	end)
	TopBarNew:setCurrencies(var_16_5)
	
	for iter_16_1 = 1, var_0_0 do
		local var_16_7 = arg_16_0.vars.wnd:getChildByName("btn_main_tab" .. iter_16_1)
		
		if get_cocos_refid(var_16_7) then
			arg_16_0:setTabText(var_16_7, iter_16_1)
		end
	end
end

function Tournament.setTabText(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0:getContentsDB()["tab_title_" .. tostring(arg_18_2)]
	
	if_set(arg_18_1, "txt", T(var_18_0))
end

function Tournament.getLeaderUnit(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_1 then
		return 
	end
	
	if not arg_19_1.npc_info then
		return 
	end
	
	local var_19_0 = arg_19_1.npc_info
	
	for iter_19_0, iter_19_1 in pairs(var_19_0.units) do
		if tonumber(iter_19_1.pos) == tonumber(arg_19_2) then
			return iter_19_1
		end
	end
end

function Tournament.changeGroupByIdx(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:getContentsDB()
	local var_20_1 = var_20_0["tournament_" .. tostring(arg_20_1)]
	local var_20_2 = var_20_0["tournament_schedule_" .. tostring(arg_20_1)]
	
	if var_20_2 and not DEBUG.MAP_DEBUG then
		local var_20_3, var_20_4 = SubstoryManager:getRemainEnterTime(var_20_2, SUBSTORY_CONSTANTS.ONE_WEEK)
		
		if var_20_3 > 0 then
			balloon_message_with_sound("err_msg_tournament_time", {
				time = sec_to_full_string(var_20_3)
			})
			
			return 
		elseif var_20_4 then
			balloon_message_with_sound("err_schedule_end")
			
			return 
		end
	end
	
	arg_20_0:changeGroup(var_20_1, arg_20_1)
end

function Tournament.changeGroup(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0.vars.group_id == arg_21_1 then
		return 
	end
	
	local var_21_0
	
	if not arg_21_2 then
		var_21_0 = arg_21_0:getContentsDB()
		
		for iter_21_0 = 1, var_0_0 do
			if var_21_0["tournament_" .. iter_21_0] == arg_21_1 then
				arg_21_2 = iter_21_0
			end
		end
	end
	
	if not arg_21_2 then
		Log.e("Tournament.changeGroup", "no_group_idx")
	end
	
	for iter_21_1 = 1, var_0_0 do
		local var_21_1 = arg_21_0.vars.wnd:getChildByName("n_tab" .. iter_21_1)
		
		if get_cocos_refid(var_21_1) then
			if_set_visible(var_21_1, "n_selected", iter_21_1 == tonumber(arg_21_2))
		end
	end
	
	arg_21_0.vars.group_id = arg_21_1
	
	arg_21_0:setGroupItems(arg_21_0.vars.group_id)
end

function Tournament.setGroupItems(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0:getFocusIdx(arg_22_0.vars.sub_story.id, arg_22_1)
	local var_22_1 = arg_22_0.vars.DB[arg_22_1]
	
	arg_22_0.vars.item_wnds = {}
	
	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		local var_22_2 = arg_22_0.vars.wnd:getChildByName("n_" .. iter_22_1.idx)
		local var_22_3 = load_control("wnd/dungeon_tournament_item.csb")
		
		var_22_2:removeAllChildren()
		var_22_2:addChild(var_22_3)
		
		if DEBUG.DEBUG_MAP_ID then
			if_set(var_22_3, "test_label", iter_22_1.id)
		end
		
		if_set_visible(var_22_3, "test_label", DEBUG.DEBUG_MAP_ID)
		
		var_22_3:getChildByName("btn_select").idx = iter_22_1.idx
		
		local var_22_4 = var_22_3:getChildByName("mob_icon")
		local var_22_5 = arg_22_0:getTournamentInfos()[iter_22_1.id] or {}
		local var_22_6 = var_22_5.result and var_22_5.result >= 1
		
		if_set_visible(arg_22_0.vars.n_lines_active, tostring(iter_22_1.idx), var_22_6)
		if_set_visible(var_22_3, "ing_win", var_22_6)
		
		local var_22_7 = var_22_3:getChildByName("n_hero_tint")
		local var_22_8 = arg_22_0:isUnlock(iter_22_1)
		
		if var_22_6 or not var_22_8 then
			var_22_7:setColor(cc.c3b(153, 153, 153))
		end
		
		if iter_22_1.top_team then
			local var_22_9 = var_22_1[iter_22_1.top_team]
			
			if_set_visible(arg_22_0.vars.n_lines_active, "for" .. tostring(var_22_9.idx), arg_22_0:isUnlock(var_22_9))
		end
		
		local var_22_10 = arg_22_0:getLeaderUnit(arg_22_0.npc_list[iter_22_1.id], iter_22_1.team_leader)
		
		if var_22_10 then
			local var_22_11 = UNIT:create(var_22_10.unit)
			
			UIUtil:getUserIcon(var_22_11, {
				no_popup = true,
				no_zodiac = true,
				character_type = "monster",
				parent = var_22_4
			})
		end
		
		if_set_visible(var_22_3, "boss", iter_22_1.team_tier == 1)
		
		if iter_22_1.team_tier == 1 then
			var_22_4:setScale(1.25)
			var_22_3:getChildByName("bg"):setScale(0.89)
			var_22_3:getChildByName("n_select"):setScale(1)
		end
		
		arg_22_0.vars.item_wnds[iter_22_1.idx] = var_22_2
	end
	
	arg_22_0:setSelectItem(var_22_0, true)
end

function Tournament.setSelectItem(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_2 and arg_23_1 == arg_23_0.vars.select_idx then
		return 
	end
	
	arg_23_0.vars.select_idx = arg_23_1 or arg_23_0:getFocusIdx(arg_23_0.vars.sub_story.id, arg_23_0.vars.group_id)
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.item_wnds) do
		if_set_visible(iter_23_1, "n_select", tonumber(iter_23_0) == tonumber(arg_23_1))
		
		if iter_23_0 == arg_23_1 then
			local var_23_0 = iter_23_1:getChildByName("dungeon_tournament_item")
			
			UIAction:Remove("tournament_select")
			UIAction:Add(LOOP(ROTATE(8000, -360, 0)), var_23_0:getChildByName("img_in"), "tournament_select")
		end
	end
	
	arg_23_0.vars.select_idx = arg_23_1
	
	arg_23_0:setDetailUI(arg_23_0.vars.select_idx)
end

function Tournament.setDetailUI(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("contents")
	local var_24_1 = var_24_0:getChildByName("mob_icon")
	local var_24_2 = arg_24_0:getTournamentDataByIdx(arg_24_1)
	local var_24_3 = arg_24_0:getLeaderUnit(arg_24_0.npc_list[var_24_2.id], var_24_2.team_leader)
	
	if var_24_3 then
		local var_24_4 = UNIT:create(var_24_3.unit)
		
		UIUtil:getUserIcon(var_24_4, {
			no_popup = true,
			no_zodiac = true,
			character_type = "monster",
			parent = var_24_1
		})
		if_set(var_24_0, "label", T(var_24_2.name))
		if_set(var_24_0, "label_name", T(var_24_4.db.name))
		if_set(var_24_0, "label_disc", T(var_24_2.team_desc))
	end
	
	local var_24_5 = arg_24_0:isUnlock(var_24_2)
	local var_24_6 = arg_24_0:isWinResult(var_24_2.id)
	
	if_set_visible(var_24_0, "ON", not var_24_6)
	if_set_visible(var_24_0, "OFF", var_24_6)
	
	if not var_24_5 or var_24_6 then
		if_set_opacity(var_24_0, "btn_go", 76.5)
	else
		if_set_opacity(var_24_0, "btn_go", 255)
	end
	
	local var_24_7 = var_24_2.reward1
	local var_24_8 = var_24_2.reward2
	local var_24_9 = var_24_0:getChildByName("n_item1")
	local var_24_10 = var_24_0:getChildByName("n_item2")
	local var_24_11 = var_24_0:getChildByName("n_one_reward")
	
	var_24_9:removeAllChildren()
	var_24_10:removeAllChildren()
	var_24_11:removeAllChildren()
	
	if var_24_7 and not var_24_8 then
		UIUtil:getRewardIcon(var_24_2.count1, var_24_7, {
			hero_multiply_scale = 1.12,
			skill_preview = true,
			parent = var_24_0:getChildByName("n_one_reward")
		})
	end
	
	if var_24_7 and var_24_8 then
		UIUtil:getRewardIcon(var_24_2.count1, var_24_7, {
			hero_multiply_scale = 1.12,
			skill_preview = true,
			parent = var_24_0:getChildByName("n_item1")
		})
		UIUtil:getRewardIcon(var_24_2.count2, var_24_8, {
			hero_multiply_scale = 1.12,
			skill_preview = true,
			parent = var_24_0:getChildByName("n_item2")
		})
	end
end

function Tournament.getSearchFocusIdx(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:getGroupDB(arg_25_1)
	
	for iter_25_0 = 1, 99 do
		local var_25_1 = string.format("%s_%02d", arg_25_1, iter_25_0)
		
		if not var_25_0[var_25_1] then
			break
		end
		
		local var_25_2 = arg_25_0:searchFocus(var_25_0, var_25_1)
		
		if var_25_2 then
			return var_25_2
		end
	end
	
	return arg_25_0:getFinalTournamentData(arg_25_1).idx
end

function Tournament.searchFocus(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1[arg_26_2]
	
	if not var_26_0 then
		return nil
	end
	
	if arg_26_0:isWinResult(var_26_0.id) then
		if var_26_0.top_team then
			local var_26_1 = arg_26_0:searchFocus(arg_26_1, var_26_0.top_team)
			
			if var_26_1 then
				return var_26_1
			end
		end
	elseif arg_26_0:isUnlock(var_26_0) then
		return var_26_0.idx
	end
	
	return nil
end

function Tournament.getFocusIdx(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_1 or not arg_27_2 then
		Log.e("tournament.getGroupTarget", arg_27_1 .. "." .. arg_27_2)
	end
	
	return SAVE:get("game.tournament." .. arg_27_1 .. "." .. arg_27_2 .. ".target") or arg_27_0:getSearchFocusIdx(arg_27_2) or 1
end

function Tournament.getSelectIdx(arg_28_0)
	return arg_28_0.vars.select_idx
end

function Tournament.saveNextTarget(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_1 or not arg_29_2 then
		return 
	end
	
	local var_29_0 = arg_29_0:getTournamentDB(arg_29_2)
	local var_29_1 = var_29_0.group_id
	
	if var_29_0.top_team then
		local var_29_2 = arg_29_0:getGroupDB(var_29_1)
		local var_29_3 = arg_29_0:searchFocus(var_29_2, arg_29_2)
		
		SAVE:set("game.tournament." .. arg_29_1 .. "." .. var_29_1 .. ".target", var_29_3)
	else
		SAVE:set("game.tournament." .. arg_29_1 .. "." .. var_29_1 .. ".target", nil)
	end
	
	SAVE:set("game.tournament." .. arg_29_1 .. ".group", var_29_1)
	SAVE:save()
end

function Tournament.getTargetGroupID(arg_30_0, arg_30_1)
	return (SAVE:get("game.tournament." .. arg_30_1 .. ".group"))
end

function Tournament.getDB(arg_31_0)
	if not arg_31_0.vars.DB then
		arg_31_0.vars.DB = {}
		
		for iter_31_0 = 1, 99 do
			local var_31_0 = {}
			
			var_31_0.id, var_31_0.group_id, var_31_0.team_tier, var_31_0.top_team, var_31_0.unlock_id, var_31_0.type_enterpoint, var_31_0.use_enterpoint, var_31_0.name, var_31_0.team_desc, var_31_0.team_id, var_31_0.team_leader, var_31_0.reward1, var_31_0.count1, var_31_0.reward2, var_31_0.count2, var_31_0.story_start, var_31_0.story_win, var_31_0.story_lose = DBN("substory_tournament", iter_31_0, {
				"id",
				"group_id",
				"team_tier",
				"top_team",
				"unlock_id",
				"type_enterpoint",
				"use_enterpoint",
				"name",
				"team_desc",
				"team_id",
				"team_leader",
				"reward1",
				"count1",
				"reward2",
				"count2",
				"story_start",
				"story_win",
				"story_lose"
			})
			
			if not var_31_0.id then
				break
			end
			
			local var_31_1 = string.split(var_31_0.id, "_")
			
			var_31_0.idx = tonumber(var_31_1[3])
			
			if not arg_31_0.vars.DB[var_31_0.group_id] then
				arg_31_0.vars.DB[var_31_0.group_id] = {}
			end
			
			arg_31_0.vars.DB[var_31_0.group_id][var_31_0.id] = var_31_0
			
			if var_31_0.team_tier == 1 then
				arg_31_0.vars.DB[var_31_0.group_id].final = var_31_0
			end
		end
	end
	
	return arg_31_0.vars.DB
end

function Tournament.getTournamentDB(arg_32_0, arg_32_1)
	local var_32_0 = string.split(arg_32_1, "_")
	local var_32_1 = var_32_0[1] .. "_" .. var_32_0[2]
	
	return (arg_32_0:getGroupDB(var_32_1) or {})[arg_32_1] or {}
end

function Tournament.getGroupDB(arg_33_0, arg_33_1)
	return arg_33_0:getDB()[arg_33_1]
end

function Tournament.getFinalTournamentData(arg_34_0, arg_34_1)
	return arg_34_0:getGroupDB(arg_34_1)
end

function Tournament.isUnlock(arg_35_0, arg_35_1)
	if not arg_35_1.unlock_id then
		return true
	end
	
	local var_35_0 = string.split(arg_35_1.unlock_id, ";")
	
	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		if arg_35_0:isWinResult(iter_35_1) then
			return true
		end
	end
	
	return false
end

function Tournament.isWinResult(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0:getTournamentInfos()[arg_36_1] or {}
	
	if var_36_0.result and var_36_0.result >= 1 then
		return true
	end
	
	return false
end

function Tournament.getItemWnd(arg_37_0)
	return self.vars.item_wnds[arg_37_0]
end

function Tournament.getItemIconWnd(arg_38_0)
	local var_38_0 = self.vars.item_wnds[arg_38_0]
	
	if not var_38_0 then
		return nil
	end
	
	return var_38_0:getChildByName("dungeon_tournament_item")
end

function Tournament.getTournamentDataByIdx(arg_39_0, arg_39_1)
	for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.DB[arg_39_0.vars.group_id]) do
		if iter_39_1.idx == arg_39_1 then
			return iter_39_1
		end
	end
	
	return nil
end

function Tournament.getNpcDataByIdx(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0:getTournamentDataByIdx(arg_40_1)
	
	return arg_40_0.npc_list[var_40_0.id]
end

function Tournament.getContentsDB(arg_41_0)
	local var_41_0 = {
		"enter_btn_icon",
		"enter_btn_text",
		"tournament_1",
		"tab_title_1",
		"tournament_schedule_1",
		"tournament_2",
		"tab_title_2",
		"tournament_schedule_2",
		"tournament_3",
		"tab_title_3",
		"tournament_schedule_3"
	}
	local var_41_1 = {}
	local var_41_2 = SubstoryManager:findContentsTypeColumn("content_tournament")
	
	if var_41_2 then
		var_41_1 = SubstoryManager:getContentsDB(var_41_2, var_41_0)
	end
	
	return var_41_1
end

function Tournament.createTeamUI(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = TournamentTeam:create(arg_42_1, arg_42_2)
	
	arg_42_0.vars.tournament_team = TournamentTeam
	
	arg_42_0.vars.wnd:addChild(var_42_0)
	TournamentTeam:updateFormation()
end

function Tournament.onReady(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0:getTournamentDataByIdx(arg_43_1)
	local var_43_1 = arg_43_0:isUnlock(var_43_0)
	local var_43_2 = arg_43_0:isWinResult(var_43_0.id)
	
	if not var_43_1 and not DEBUG.MAP_DEBUG then
		balloon_message_with_sound("err_enter_tournament")
		
		return 
	end
	
	if var_43_2 and not DEBUG.MAP_DEBUG then
		balloon_message_with_sound("err_already_clear_tournament")
		
		return 
	end
	
	local var_43_3 = arg_43_0:getNpcDataByIdx(arg_43_1)
	
	TournamentTeam:show({
		mode = "tournament",
		enemy_uid = -1,
		enemy_score = 0,
		my_info = {
			score = 1,
			repeat_reward_period = 1,
			battle_count = 1,
			league = 0,
			repeat_reward_type_max = 1
		},
		enemy_info = var_43_3.npc_info
	}, {
		parent = arg_43_0.vars.team_layer,
		hide_layer = arg_43_0.vars.tournament_layer,
		currencies = arg_43_0.vars.currencies,
		tournament_id = var_43_3.tournament_id
	})
end

function Tournament.getSceneState(arg_44_0)
	return {}
end

function Tournament.startBattle(arg_45_0, arg_45_1)
	UnitMain:endPVPMode()
	
	local var_45_0 = {}
	
	if arg_45_1.substory_id then
		var_45_0.substory_id = arg_45_1.substory_id
	end
	
	if PLATFORM == "win32" then
		SAVE:set("game.started_battle_data", {
			map = arg_45_1.battle.map,
			team = arg_45_1.my_team,
			started_data = {
				mode = "pvp"
			}
		})
	end
	
	local var_45_1 = BattleLogic:makeLogic(arg_45_1.battle.map, arg_45_1.my_team, {
		mode = "pvp",
		started_data = var_45_0
	})
	
	var_45_1.enemy_uid = arg_45_1.enemy_uid
	
	local var_45_2 = string.split(arg_45_1.enemy_uid, ":")
	
	if arg_45_1.tournament_id then
		local var_45_3 = DB("substory_tournament", arg_45_1.tournament_id, "name")
		
		var_45_1.enemy_name = T(var_45_3)
	end
	
	PreLoad:beforeEnterBattle(var_45_1)
	SceneManager:nextScene("battle", {
		logic = var_45_1
	})
end

function Tournament.onTouchDown(arg_46_0, arg_46_1, arg_46_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchDown(arg_46_1, arg_46_2)
	end
end

function Tournament.onTouchUp(arg_47_0, arg_47_1, arg_47_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchUp(arg_47_1, arg_47_2)
	end
end

function Tournament.onTouchMove(arg_48_0, arg_48_1, arg_48_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchMove(arg_48_1, arg_48_2)
	end
end

function Tournament.onPushBackground(arg_49_0)
	if UnitMain:isVisible() then
		return UnitMain:onPushBackground()
	end
end

function Tournament.setButtonEnterInfo(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0
	local var_50_1
	local var_50_2
	
	if arg_50_1:getChildByName("n_counter") == nil then
		return 
	end
	
	local var_50_3 = arg_50_0:getTournamentDB(arg_50_2)
	local var_50_4 = var_50_3.type_enterpoint
	local var_50_5 = var_50_3.use_enterpoint
	
	if to_n(var_50_5) > 0 then
		local var_50_6 = 0
		local var_50_7 = DB("item_material", var_50_4, {
			"icon"
		})
		
		SpriteCache:resetSprite(arg_50_1:getChildByName("icon_res"), "item/" .. var_50_7 .. ".png")
		if_set_visible(arg_50_1, "icon_res", true)
		
		local var_50_8 = Account:getItemCount(var_50_4)
		
		if_set(arg_50_1, "cost", var_50_5)
		
		var_50_0 = var_50_5 <= var_50_8
	end
	
	if not rest and to_n(var_50_5) == 0 then
		local var_50_9 = arg_50_1:getChildByName("label")
		
		if var_50_9 and get_cocos_refid(var_50_9) then
			arg_50_1:getChildByName("label"):setPositionX(var_50_9:getPositionX() - 50)
		end
		
		if_set_visible(arg_50_1, "n_counter", false)
		if_call(arg_50_1, "txt_go", "setPositionX", 140)
		
		var_50_0 = enter_id ~= nil
	end
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		return true
	end
	
	return var_50_0, var_50_4
end
