ClanWar = ClanWar or {}
CLAN_WAR_MODE = {
	READY = "ready",
	WAR = "war",
	NONE = "none"
}

function MsgHandler.clan_war_enter(arg_1_0)
	ClanWar:init()
	
	if arg_1_0.err_msg == "match_failed" then
		SceneManager:nextScene("clan_war_close", {
			state = "matching_failed"
		})
		
		return 
	end
	
	ClanWar:setInfo(arg_1_0)
	
	local var_1_0 = Account:serverTimeDayLocalDetail()
	local var_1_1 = ClanWar:getWarInfo()
	local var_1_2 = Account:getPvpScheduleToDay()
	
	if ClanWar:getMode() == CLAN_WAR_MODE.WAR and (var_1_1 == nil or var_1_1.war_day_id ~= var_1_2.war_day_id or var_1_1.enemy_clan_id == nil and var_1_1.final_result == nil) then
		SceneManager:nextScene("clan_war_close", {
			state = "matching_failed"
		})
		
		return 
	end
	
	if ClanWar:getMode() == CLAN_WAR_MODE.WAR and var_1_1.enemy_clan_id == nil and var_1_1.final_result == 1 then
		SceneManager:nextScene("clan_war_close", {
			state = "unearned_win"
		})
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		SceneManager:popScene()
	elseif SceneManager:getCurrentSceneName() ~= "clan_war" then
		SceneManager:nextScene("clan_war")
	end
	
	ClanWarMain:refresh()
end

function MsgHandler.get_clan_war_view_info(arg_2_0)
	ClanHome:logicHallofFame_seasonReward(arg_2_0)
	ClanWar:setInfo(arg_2_0)
	ClanBattleList:initData(arg_2_0)
	ClanWarMain:refresh()
	TutorialGuide:procGuide()
end

function MsgHandler.refresh_clan_war_info(arg_3_0)
	if not arg_3_0.no_change then
		ClanWar:setInfo(arg_3_0)
		ClanWarMain:refresh()
	end
end

function MsgHandler.clan_war_building_refresh(arg_4_0)
	if arg_4_0.building_info then
		ClanWar:updateBuildingMember(arg_4_0.building_info.slot, arg_4_0.building_info, false)
		ClanWarMain:updateEmtpyEquipSlotUI()
		balloon_message_with_sound("clanwar_renew_apply_msg")
	end
end

function MsgHandler.get_clan_war_day_id(arg_5_0)
	if arg_5_0.schedule then
		table.print(arg_5_0.schedule)
	end
	
	if arg_5_0.war_day_id then
		Dialog:msgBox("war_day_id: " .. arg_5_0.war_day_id)
	end
end

function MsgHandler.get_clan_war_result_record_list(arg_6_0)
	if arg_6_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	if arg_6_0.list then
		ClanWar:setClanWarResultRecords(arg_6_0.list)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_result_record_list then
			ClanWar.vars.onGetQueryResult.get_clan_war_result_record_list()
			
			ClanWar.vars.onGetQueryResult.get_clan_war_result_record_list = nil
		end
	end
end

function MsgHandler.get_clan_war_hall_of_fames(arg_7_0)
	if arg_7_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	if arg_7_0.fame_infos then
		ClanWar:setClanWarHallOfFameInfo(arg_7_0.fame_infos)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_hall_of_fames then
			ClanWar.vars.onGetQueryResult.get_clan_war_hall_of_fames()
			
			ClanWar.vars.onGetQueryResult.get_clan_war_hall_of_fames = nil
		end
	end
end

function MsgHandler.check_clan_war_reward(arg_8_0)
	if arg_8_0.member_info then
		Clan:updateClanUserInfo(arg_8_0.member_info)
	end
	
	if arg_8_0.rewards then
		Account:addReward(arg_8_0.rewards)
	end
	
	if arg_8_0.prev_clan_war_doc_attri then
		ClanWar:setPrevWarInfo(arg_8_0.prev_clan_war_doc_attri)
	end
	
	if arg_8_0.result and arg_8_0.rtn_reward_datas and arg_8_0.rtn_reward_datas.reward_count and arg_8_0.rtn_reward_datas.reward_count > 0 then
		Dialog:close("clan_war_sel")
		ClanWarResult:show(arg_8_0)
		
		return 
	else
		ClanBattleList.ClanWar:enter_clan_war()
	end
end

function ErrHandler.set_clan_war_building_member_list(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2.err == "duplication_set_user_id" then
		Dialog:msgBox(T("duplication_set_user_id"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end
		})
		
		return 
	end
end

function MsgHandler.set_clan_war_building_member_list(arg_11_0)
	if arg_11_0.building_docs_attri then
		ClanWar:updateBuildingMembers(arg_11_0.building_docs_attri)
	end
	
	if arg_11_0.clan_war_doc_attri then
		ClanWar:setWarInfo(arg_11_0.clan_war_doc_attri)
	end
	
	ClanWar:setIsInMatchList(arg_11_0.is_in_match_list or false)
	
	if arg_11_0.none_slot_msg then
		if arg_11_0.none_slot_msg == "castle" then
			Dialog:msgBox(T("war_err_msg007"), {
				handler = function()
					SceneManager:nextScene("lobby")
				end
			})
		elseif arg_11_0.none_slot_msg == "tower" then
			Dialog:msgBox(T("clanwar_matching_err_msg2"), {
				handler = function()
					SceneManager:nextScene("lobby")
				end
			})
		else
			Dialog:msgBox(T("war_err_msg008"), {
				handler = function()
					SceneManager:nextScene("lobby")
				end
			})
		end
	else
		Dialog:msgBox(T("war_ui_desc10"))
	end
	
	ClanWarMain:refresh()
end

function MsgHandler.get_clan_war_slot_info(arg_15_0)
	if arg_15_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	local var_15_0 = arg_15_0.clan_id ~= Account:getClanId()
	
	if arg_15_0.slot and arg_15_0.building_doc_attri then
		ClanWar:updateBuildingMember(arg_15_0.slot, arg_15_0.building_doc_attri, var_15_0)
	end
	
	if arg_15_0.building_attacker_attri then
		ClanWar:updateAttackerInfo(tostring(arg_15_0.building_attacker_attri.user_id), arg_15_0.building_attacker_attri, var_15_0)
	end
	
	if arg_15_0.logs then
		ClanWar:setBuildingBattleLogs(arg_15_0.slot, arg_15_0.logs, var_15_0)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_slot_info then
			ClanWar.vars.onGetQueryResult.get_clan_war_slot_info({
				updated = true,
				page = arg_15_0.page,
				logs = arg_15_0.logs
			})
			
			ClanWar.vars.onGetQueryResult.get_clan_war_slot_info = nil
		end
	end
	
	ClanWarMain:refresh()
	
	if not arg_15_0.building_doc_attri or not arg_15_0.building_doc_attri.defense_user_info then
		Dialog:msgBox(T("get_clan_war_slot_info.no_defense_user_id"), {
			handler = function()
				ClanWarDetail:focusOut()
			end
		})
	end
end

function MsgHandler.get_clan_war_defense_infos(arg_17_0)
	if arg_17_0.defense_able_member_docs then
		ClanWar:setDefenseAbleMemberList(arg_17_0.defense_able_member_docs)
	end
end

function MsgHandler.get_battle_log_by_clan(arg_18_0)
	if arg_18_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	if arg_18_0.logs then
		ClanWar:setClanBattleLogs(arg_18_0.logs)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_battle_log_by_clan then
			ClanWar.vars.onGetQueryResult.get_battle_log_by_clan({
				updated = true,
				page = arg_18_0.page,
				logs = arg_18_0.logs
			})
			
			ClanWar.vars.onGetQueryResult.get_battle_log_by_clan = nil
		end
	end
end

function MsgHandler.get_clan_war_ranking(arg_19_0)
	if arg_19_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	ClanWar:setClanWarRankingInfo(arg_19_0)
	
	if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_ranking then
		ClanWar.vars.onGetQueryResult.get_clan_war_ranking()
		
		ClanWar.vars.onGetQueryResult.get_clan_war_ranking = nil
	end
end

function ClanWar.init(arg_20_0)
	arg_20_0.vars = {}
end

function ClanWar.initClanVars(arg_21_0, arg_21_1)
	arg_21_0.vars.building_battle_logs = arg_21_0.vars.building_battle_logs or {}
	arg_21_0.vars.building_members = arg_21_0.vars.building_members or {}
	arg_21_0.vars.attacker_infos = arg_21_0.vars.attacker_infos or {}
	arg_21_0.vars.user_id_to_slot = arg_21_0.vars.user_id_to_slot or {}
	arg_21_0.vars.slot_to_user_id = arg_21_0.vars.slot_to_user_id or {}
	arg_21_0.vars.building_battle_logs[arg_21_1] = arg_21_0.vars.building_battle_logs[arg_21_1] or {}
	arg_21_0.vars.building_members[arg_21_1] = arg_21_0.vars.building_members[arg_21_1] or {}
	arg_21_0.vars.slot_to_user_id[arg_21_1] = arg_21_0.vars.slot_to_user_id[arg_21_1] or {}
	arg_21_0.vars.user_id_to_slot[arg_21_1] = arg_21_0.vars.user_id_to_slot[arg_21_1] or {}
	arg_21_0.vars.attacker_infos[arg_21_1] = arg_21_0.vars.attacker_infos[arg_21_1] or {}
end

function ClanWar.initQueryVars(arg_22_0)
	arg_22_0.vars.query_time_secs = {}
	arg_22_0.vars.query_interval_secs = {
		set_clan_war_building_member_list = 3,
		get_battle_log_by_clan = 5,
		refresh_clan_war_info = 5,
		get_clan_war_result_record_list = -1,
		get_clan_war_hall_of_fames = 5,
		get_clan_war_defense_infos = 10,
		get_clan_war_slot_info = 5,
		get_clan_war_ranking = -1,
		get_clan_war_token_datas = 5
	}
	arg_22_0.vars.onGetQueryResult = {}
end

function ClanWar.setInfo(arg_23_0, arg_23_1)
	if arg_23_1.redis_cache_key then
		arg_23_0.cache_key = arg_23_1.redis_cache_key
	end
	
	arg_23_0.vars = arg_23_0.vars or {}
	
	arg_23_0:initQueryVars()
	arg_23_0:initClanVars(arg_23_0:getClanId(false))
	
	if not arg_23_1 then
		return 
	end
	
	if arg_23_1.clan_war_doc then
		arg_23_0:setWarInfo(arg_23_1.clan_war_doc)
	end
	
	if arg_23_1.enemy_clan_war_doc then
		arg_23_0:setEnemyWarInfo(arg_23_1.enemy_clan_war_doc)
	end
	
	if arg_23_1.enemy_clan_doc then
		ClanWar:setEnemyClanInfo(arg_23_1.enemy_clan_doc)
	end
	
	if arg_23_1.clan_war_building_docs then
		arg_23_0:setBuildingMembers(arg_23_1.clan_war_building_docs)
	end
	
	if arg_23_1.enemy_building_docs then
		arg_23_0:setBuildingMembers(arg_23_1.enemy_building_docs, true)
	end
	
	if arg_23_1.defense_able_member_docs then
		arg_23_0:setDefenseAbleMemberList(arg_23_1.defense_able_member_docs)
	end
	
	if arg_23_1.clan_doc then
		Clan:setClanInfo(arg_23_1.clan_doc)
	end
	
	if arg_23_1.clan_war_enemy_attacker_docs then
		ClanWar:setAttackerInfos(arg_23_1.clan_war_enemy_attacker_docs, true)
	end
	
	if arg_23_1.clan_war_attacker_docs then
		ClanWar:setAttackerInfos(arg_23_1.clan_war_attacker_docs)
	end
	
	if arg_23_1.enemy_user_infos then
		ClanWar:setEnemyUserInfos(arg_23_1.enemy_user_infos)
	end
	
	if arg_23_1.dead_doc_units then
		ClanWar:setDeadUnits(arg_23_1.dead_doc_units)
	end
	
	ClanWar:setIsInMatchList(arg_23_1.is_in_match_list or false)
	
	local var_23_0 = Account:serverTimeDayLocalDetail()
	local var_23_1 = Account:getPvpScheduleToDay()
	
	arg_23_0.vars.mode = var_23_1.war_mode
	
	print("------------ CLAN_PVP_MODE -------------", arg_23_0.vars.mode)
end

function ClanWar.setIsInMatchList(arg_24_0, arg_24_1)
	arg_24_0.vars.isInMatchList = arg_24_1
end

function ClanWar.getIsInMatchList(arg_25_0)
	return arg_25_0.vars.isInMatchList or false
end

function ClanWar.setDefenseAbleMemberList(arg_26_0, arg_26_1)
	arg_26_0.vars.defense_able_member_list = arg_26_1
end

function ClanWar.getDefenseAbleMemberNumber(arg_27_0)
	if not arg_27_0.vars or not arg_27_0.vars.defense_able_member_list then
		return 
	end
	
	return table.count(arg_27_0.vars.defense_able_member_list)
end

function ClanWar.getDefenseAbleMemberList(arg_28_0)
	return arg_28_0.vars.defense_able_member_list
end

function ClanWar.setBuildingMembers(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0:getClanId(arg_29_2)
	
	arg_29_0.vars.building_members[var_29_0] = arg_29_1
	arg_29_0.vars.slot_to_user_id[var_29_0] = {}
	arg_29_0.vars.user_id_to_slot[var_29_0] = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		if iter_29_1.defense_user_info then
			local var_29_1 = iter_29_1.defense_user_info.id
			local var_29_2 = tostring(iter_29_1.slot)
			
			arg_29_0.vars.slot_to_user_id[var_29_0][var_29_2] = var_29_1
			arg_29_0.vars.user_id_to_slot[var_29_0][var_29_1] = var_29_2
		end
	end
end

function ClanWar.getBuildingMembers(arg_30_0, arg_30_1)
	return arg_30_0.vars.building_members[arg_30_0:getClanId(arg_30_1)]
end

function ClanWar.updateBuildingMembers(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0:getClanId(arg_31_2)
	
	for iter_31_0, iter_31_1 in pairs(arg_31_1) do
		arg_31_0:updateBuildingMember(iter_31_0, iter_31_1, arg_31_2)
	end
end

function ClanWar.isEmptyEquipUser(arg_32_0, arg_32_1)
	if Account:getCurrentWarUId() < 12 then
		return false
	end
	
	if arg_32_1.team1 and arg_32_1.team2 then
		for iter_32_0, iter_32_1 in pairs(arg_32_1.team1) do
			if iter_32_1:hasEmptyEquip() then
				return true
			end
		end
		
		for iter_32_2, iter_32_3 in pairs(arg_32_1.team2) do
			if iter_32_3:hasEmptyEquip() then
				return true
			end
		end
		
		return 
	end
	
	local var_32_0 = arg_32_1.defense_info1
	local var_32_1 = arg_32_1.defense_info2
	
	if not (arg_32_1.defense_user_id and var_32_0 and var_32_1) then
		return false
	end
	
	return var_32_0.empty_equip == true or var_32_1.empty_equip == true
end

function ClanWar.userIdToSlot(arg_33_0, arg_33_1, arg_33_2)
	return arg_33_0.vars.user_id_to_slot[arg_33_0:getClanId(arg_33_2)][arg_33_1]
end

function ClanWar.slotToUserId(arg_34_0, arg_34_1, arg_34_2)
	return arg_34_0.vars.slot_to_user_id[arg_34_0:getClanId(arg_34_2)][tostring(arg_34_1)]
end

function ClanWar.updateBuildingMember(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if not arg_35_0.vars then
		return 
	end
	
	local var_35_0 = tostring(arg_35_1)
	local var_35_1 = arg_35_0:getClanId(arg_35_3)
	
	arg_35_0.vars.building_members[var_35_1][var_35_0] = arg_35_2
	
	local var_35_2 = arg_35_0.vars.slot_to_user_id[var_35_1][var_35_0]
	
	if var_35_2 then
		arg_35_0.vars.slot_to_user_id[var_35_1][var_35_0] = nil
		arg_35_0.vars.user_id_to_slot[var_35_1][var_35_2] = nil
	end
	
	if arg_35_2.defense_user_info then
		arg_35_0.vars.user_id_to_slot[var_35_1][arg_35_2.defense_user_info.id] = var_35_0
		arg_35_0.vars.slot_to_user_id[var_35_1][var_35_0] = arg_35_2.defense_user_info.id
	end
end

function ClanWar.getInfo(arg_36_0)
	if not arg_36_0.vars then
		return {}
	end
	
	return arg_36_0.vars
end

function ClanWar.getCacheKey(arg_37_0)
	return arg_37_0.cache_key
end

function ClanWar.setWarInfo(arg_38_0, arg_38_1)
	arg_38_0.vars.war_info = arg_38_1
end

function ClanWar.setPrevWarInfo(arg_39_0, arg_39_1)
	arg_39_0.vars.prev_war_info = arg_39_1
end

function ClanWar.getWarInfo(arg_40_0)
	return arg_40_0.vars.war_info
end

function ClanWar.getPrevWarInfo(arg_41_0)
	return arg_41_0.vars.prev_war_info
end

function ClanWar.setEnemyWarInfo(arg_42_0, arg_42_1)
	arg_42_0.vars.enemy_war_info = arg_42_1
end

function ClanWar.getEnemyWarInfo(arg_43_0)
	return arg_43_0.vars.enemy_war_info
end

function ClanWar.setEnemyClanInfo(arg_44_0, arg_44_1)
	arg_44_0.vars.enemy_clan_doc = arg_44_1
	
	arg_44_0:initClanVars(arg_44_0:getClanId(true))
end

function ClanWar.getEnemyClanInfo(arg_45_0)
	if not arg_45_0.vars then
		return {}
	end
	
	return arg_45_0.vars.enemy_clan_doc or {}
end

function ClanWar.getWarDay(arg_46_0)
	return arg_46_0.vars.war_info.day_id
end

function ClanWar.getWarID(arg_47_0)
	return Account:getCurrentWarId()
end

function ClanWar.setDeadUnits(arg_48_0, arg_48_1)
	arg_48_0.vars.dead_units = arg_48_1
end

function ClanWar.getDeadUnits(arg_49_0)
	return arg_49_0.vars.dead_units
end

function ClanWar.isInDeadUnits(arg_50_0, arg_50_1)
	if not arg_50_0.vars or not arg_50_0.vars.dead_units then
		return false
	end
	
	local var_50_0 = Account:serverTimeDayLocalDetail()
	local var_50_1 = arg_50_0.vars.dead_units.day_id
	
	if not var_50_1 then
		return false
	end
	
	if var_50_1 < var_50_0 then
		return false
	end
	
	for iter_50_0, iter_50_1 in pairs(arg_50_0.vars.dead_units.unit_uids or {}) do
		if iter_50_1 == arg_50_1:getUID() then
			return true
		end
	end
	
	return false
end

function ClanWar.isRewardAble(arg_51_0)
	local var_51_0 = Account:getPvpScheduleToDay()
	local var_51_1
	
	var_51_1 = not ContentDisable:byAlias("clan_war") and Account:getClanId()
	
	local var_51_2 = Clan:getUserMemberInfo() or {}
	local var_51_3 = var_51_2.reward_war_day_id
	local var_51_4 = Account:serverTimeDayLocalDetail(var_51_2.join_time)
	local var_51_5 = Account:getPrevWarDayId(var_51_0.war_day_id)
	local var_51_6 = var_51_4 < var_51_5 and (var_51_3 == nil or var_51_3 < var_51_5)
	local var_51_7 = ClanWar:getPrevWarInfo()
	
	if var_51_6 and (var_51_7 or {}).day_id then
		return true
	end
	
	return false
end

function ClanWar.isWarReady(arg_52_0)
	local var_52_0 = Account:getPvpScheduleToDay()
	local var_52_1 = not ContentDisable:byAlias("clan_war") and Account:getClanId()
	
	if var_52_1 and var_52_0 then
		var_52_1 = Account:getCurrency("clanpvpkey") > 0 and var_52_0.war_mode == "war"
	end
	
	local var_52_2, var_52_3 = arg_52_0:isCompleteWarReady()
	
	if var_52_1 and var_52_3 then
		var_52_1 = false
	end
	
	return var_52_1
end

function ClanWar.getClanBattleLogs(arg_53_0)
	return arg_53_0.vars.clan_battle_logs
end

function ClanWar.setClanBattleLogs(arg_54_0, arg_54_1)
	arg_54_0.vars.clan_battle_logs = arg_54_1
end

function ClanWar.getClanWarRankingInfo(arg_55_0)
	return arg_55_0.vars.clan_war_ranking_info or {}
end

function ClanWar.setClanWarRankingInfo(arg_56_0, arg_56_1)
	arg_56_0.vars.clan_war_ranking_info = arg_56_1
end

function ClanWar.getClanWarResultRecords(arg_57_0)
	return arg_57_0.vars.clan_war_records or {}
end

function ClanWar.setClanWarResultRecords(arg_58_0, arg_58_1)
	arg_58_0.vars.clan_war_records = arg_58_1
end

function ClanWar.getClanWarMemberRecords(arg_59_0)
	return arg_59_0.vars.clan_war_member_records or {}
end

function ClanWar.setClanWarHallOfFameInfo(arg_60_0, arg_60_1)
	arg_60_0.vars.clan_war_hall_of_fame_info = arg_60_1
end

function ClanWar.getClanWarHallOfFameInfo(arg_61_0)
	return arg_61_0.vars.clan_war_hall_of_fame_info or {}
end

function ClanWar.setClanWarMemberRecords(arg_62_0, arg_62_1)
	arg_62_0.vars.clan_war_member_records = arg_62_1
end

function ClanWar.getClanWarMemberSeasonRecords(arg_63_0)
	return arg_63_0.vars.clan_war_member_season_records or {}
end

function ClanWar.setClanWarMemberSeasonRecords(arg_64_0, arg_64_1)
	arg_64_0.vars.clan_war_member_season_records = arg_64_1
end

function ClanWar.getClanWarMemberPrevSeasonRecords(arg_65_0, arg_65_1)
	if not arg_65_0.vars.clan_war_member_prev_season_records or not arg_65_0.vars.clan_war_member_prev_season_records[arg_65_1] then
		return {}
	end
	
	return arg_65_0.vars.clan_war_member_prev_season_records[arg_65_1] or {}
end

function ClanWar.setClanWarMemberPrevSeasonRecords(arg_66_0, arg_66_1, arg_66_2)
	if not arg_66_0.vars.clan_war_member_prev_season_records then
		arg_66_0.vars.clan_war_member_prev_season_records = {}
	end
	
	if not arg_66_0.vars.clan_war_member_prev_season_records[arg_66_1] then
		arg_66_0.vars.clan_war_member_prev_season_records[arg_66_1] = {}
	end
	
	arg_66_0.vars.clan_war_member_prev_season_records[arg_66_1] = arg_66_2
end

function ClanWar.query(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	if not arg_67_0.vars.query_time_secs then
		arg_67_0:initQueryVars()
	end
	
	arg_67_4 = arg_67_4 or ""
	
	local var_67_0 = arg_67_0.vars.query_time_secs[arg_67_1 .. arg_67_4] or 0
	local var_67_1 = arg_67_0.vars.query_interval_secs[arg_67_1] or -1
	
	if var_67_1 > os.time() - var_67_0 and not arg_67_5 then
		if arg_67_2 then
			arg_67_2()
		end
		
		return 
	end
	
	if var_67_1 == -1 then
		arg_67_0.vars.query_interval_secs[arg_67_1] = math.huge
	end
	
	arg_67_0.vars.query_time_secs[arg_67_1 .. arg_67_4] = os.time()
	arg_67_0.vars.onGetQueryResult[arg_67_1] = arg_67_2
	
	query(arg_67_1, arg_67_3)
end

function ClanWar.clearData(arg_68_0)
	arg_68_0:clearClanBattleLogs()
	
	arg_68_0.vars.query_time_secs = {}
end

function ClanWar.clearClanBattleLogs(arg_69_0)
	arg_69_0.vars.clan_battle_logs = nil
end

function ClanWar.setAttackerInfos(arg_70_0, arg_70_1, arg_70_2)
	arg_70_0.vars.attacker_infos[arg_70_0:getClanId(arg_70_2)] = arg_70_1
end

function ClanWar.getAttackerInfos(arg_71_0, arg_71_1)
	return arg_71_0.vars.attacker_infos[arg_71_0:getClanId(arg_71_1)]
end

function ClanWar.updateAttackerInfo(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
	arg_72_0.vars.attacker_infos[arg_72_0:getClanId(arg_72_3)][arg_72_1] = arg_72_2
end

function ClanWar.setEnemyUserInfos(arg_73_0, arg_73_1)
	arg_73_0.vars.enemy_user_infos = arg_73_1
end

function ClanWar.getEnemyUserInfos(arg_74_0)
	return arg_74_0.vars.enemy_user_infos
end

function ClanWar.setBuildingBattleLogs(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	local var_75_0 = arg_75_2 or {}
	
	if arg_75_0.vars and arg_75_0.vars.building_battle_logs and arg_75_0.vars.building_battle_logs[arg_75_0:getClanId(arg_75_3)] and arg_75_0.vars.building_battle_logs[arg_75_0:getClanId(arg_75_3)][tostring(arg_75_1)] and not ClanWarReady:isFirstPage() then
		for iter_75_0, iter_75_1 in pairs(var_75_0) do
			table.insert(arg_75_0.vars.building_battle_logs[arg_75_0:getClanId(arg_75_3)][tostring(arg_75_1)], iter_75_1)
		end
	else
		arg_75_0.vars.building_battle_logs[arg_75_0:getClanId(arg_75_3)][tostring(arg_75_1)] = var_75_0
	end
end

function ClanWar.getBuildingBattleLogs(arg_76_0, arg_76_1, arg_76_2)
	return arg_76_0.vars.building_battle_logs[arg_76_0:getClanId(arg_76_2)][tostring(arg_76_1)]
end

function ClanWar.isObserver(arg_77_0)
	local var_77_0 = ClanWar:getBuildingMembers(false) or {}
	
	for iter_77_0, iter_77_1 in pairs(var_77_0) do
		if iter_77_1.defense_user_id == Account:getUserId() then
			return false
		end
	end
	
	return true
end

function ClanWar.isCompleteWarReady(arg_78_0)
	if not arg_78_0.vars then
		return 
	end
	
	local var_78_0 = arg_78_0:getWarID()
	local var_78_1 = arg_78_0:getWarInfo()
	local var_78_2 = Account:getPvpScheduleToDay()
	
	if not var_78_0 then
		return false
	end
	
	local var_78_3 = arg_78_0:getDefenseAbleMemberNumber()
	local var_78_4 = DB("clan_war", var_78_0, "need_defense_count")
	local var_78_5 = arg_78_0.vars.mode or var_78_2.war_mode
	
	if var_78_5 == CLAN_WAR_MODE.NONE then
		return false, "time"
	elseif var_78_5 == CLAN_WAR_MODE.WAR and (var_78_1 == nil or var_78_1.war_day_id ~= var_78_2.war_day_id or tonumber(var_78_1.member_count or 0) < tonumber(var_78_4)) then
		return false, "matching_failed"
	elseif var_78_5 == CLAN_WAR_MODE.WAR and var_78_1.final_result == 1 then
		return false, "unearned_win"
	elseif var_78_5 == "ready" and var_78_4 > (var_78_3 or 0) then
		return false, "member_count"
	elseif var_78_5 == CLAN_WAR_MODE.READY then
		return true, "ready"
	else
		return true
	end
end

function ClanWar.getMode(arg_79_0)
	if not arg_79_0.vars then
		return CLAN_WAR_MODE.READY
	end
	
	return arg_79_0.vars.mode
end

function ClanWar.getSubTowerAttackers(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0 = {}
	local var_80_1 = (ClanWar:getBuildingMembers(arg_80_2) or {})[tostring(arg_80_1)]
	
	if not var_80_1 then
		return var_80_0
	end
	
	local var_80_2 = {
		var_80_1.attacker_user_id1,
		var_80_1.attacker_user_id2,
		var_80_1.attacker_user_id3
	}
	local var_80_3 = {
		var_80_1.attacker_time1,
		var_80_1.attacker_time2,
		var_80_1.attacker_time3
	}
	local var_80_4 = 3300
	
	for iter_80_0 = 1, 3 do
		if var_80_2[iter_80_0] and var_80_3[iter_80_0] and os.time() < var_80_3[iter_80_0] + var_80_4 then
			table.insert(var_80_0, {
				id = var_80_2[iter_80_0],
				time = var_80_3[iter_80_0]
			})
		end
	end
	
	return var_80_0
end

function ClanWar.getRemainTime(arg_81_0)
	local var_81_0 = Account:getPvpScheduleToDay()
	
	if not var_81_0 then
		return -1
	end
	
	local var_81_1 = var_81_0.end_time
	
	if var_81_0.war_mode == "none" then
		local var_81_2 = Account:getPvpClanCurrentSchedule()[tostring(var_81_0.war_day_id)]
		
		if not var_81_2 then
			return -1
		end
		
		var_81_1 = var_81_2.start_time
	end
	
	return var_81_1 - os.time()
end

function ClanWar.getAttackerInfo(arg_82_0, arg_82_1, arg_82_2)
	local var_82_0 = arg_82_0:getAttackerInfos(arg_82_2)
	
	if not var_82_0 then
		return 
	end
	
	return var_82_0[tostring(arg_82_1)]
end

function ClanWar.getAttackerWarPoint(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = arg_83_0:getAttackerInfo(arg_83_1, arg_83_2)
	
	if not var_83_0 then
		return 0
	end
	
	return var_83_0.destroy_score
end

function ClanWar.getClanId(arg_84_0, arg_84_1)
	return arg_84_1 and arg_84_0:getEnemyClanInfo().clan_id or Account:getClanId()
end

function ClanWar.getPvpKeyTokenMax(arg_85_0)
	return DB("item_token", "to_clanpvpkey", {
		"max"
	})
end

function ClanWar.getRemainAttackCounter(arg_86_0, arg_86_1, arg_86_2)
	if not arg_86_0.vars.max_attack_counter then
		arg_86_0.vars.max_attack_counter = DB("item_token", "to_clanpvpkey", {
			"max"
		})
	end
	
	local var_86_0 = 0
	local var_86_1 = arg_86_0:getAttackerInfo(arg_86_1, arg_86_2)
	
	if var_86_1 then
		local var_86_2 = Account:serverTimeDayLocalDetail()
		
		if var_86_1.day_id == var_86_2 then
			var_86_0 = var_86_1.today_attack_count
		end
	end
	
	return arg_86_0.vars.max_attack_counter - var_86_0, arg_86_0.vars.max_attack_counter
end

function ClanWar.getRemainAttackCountPerEnemy(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = arg_87_0:getAttackerInfo(arg_87_1) or {
		arg_87_2
	}
	
	if table.find(var_87_0.attack_slot, arg_87_2) then
		return 0
	else
		return 1
	end
end

function ClanWar.isBuildingMember(arg_88_0, arg_88_1)
	local var_88_0 = arg_88_0:getBuildingMembers() or {}
	
	for iter_88_0, iter_88_1 in pairs(var_88_0) do
		if iter_88_1.defense_user_id == arg_88_1 then
			return true
		end
	end
	
	return false
end
