DungeonCreviceUtil = {}

function DungeonCreviceUtil.setSeasonInfo(arg_1_0, arg_1_1)
	if table.empty(arg_1_1) then
		return 
	end
	
	if not arg_1_0.season_info then
		arg_1_0.season_info = {}
	end
	
	if not arg_1_0.pre_season_info then
		arg_1_0.pre_season_info = {}
	end
	
	local var_1_0 = arg_1_1.season_id
	
	if not table.empty(arg_1_0.season_info[var_1_0]) then
		arg_1_0.pre_season_info[var_1_0] = table.clone(arg_1_0.season_info[var_1_0])
		
		table.merge(arg_1_0.season_info[var_1_0], arg_1_1)
	else
		arg_1_0.season_info[var_1_0] = arg_1_1
	end
end

function DungeonCreviceUtil.getSeasonInfo(arg_2_0)
	if table.empty(arg_2_0.season_info) then
		return nil
	end
	
	local var_2_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_2_0 then
		return nil
	end
	
	return arg_2_0.season_info[var_2_0]
end

function DungeonCreviceUtil.getSelectedSetIds(arg_3_0)
	local var_3_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_3_0 then
		return nil
	end
	
	if table.empty(arg_3_0.season_info) or table.empty(arg_3_0.season_info[var_3_0]) then
		return nil
	end
	
	return arg_3_0.season_info[var_3_0].select_setfx
end

function DungeonCreviceUtil.getSelectedRunes(arg_4_0)
	local var_4_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_4_0 then
		return nil
	end
	
	if table.empty(arg_4_0.season_info) or table.empty(arg_4_0.season_info[var_4_0]) then
		return nil
	end
	
	return arg_4_0.season_info[var_4_0].rune_skill
end

function DungeonCreviceUtil.getRuneExp(arg_5_0)
	local var_5_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_5_0 then
		return 0
	end
	
	if table.empty(arg_5_0.season_info) or table.empty(arg_5_0.season_info[var_5_0]) then
		return 0
	end
	
	return arg_5_0.season_info[var_5_0].rune_exp or 0
end

function DungeonCreviceUtil.getPreRuneExp(arg_6_0)
	local var_6_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_6_0 then
		return 0
	end
	
	if table.empty(arg_6_0.pre_season_info) or table.empty(arg_6_0.pre_season_info[var_6_0]) then
		return 0
	end
	
	return arg_6_0.pre_season_info[var_6_0].rune_exp or 0
end

function DungeonCreviceUtil.getDiffRuneExp(arg_7_0)
	if table.empty(arg_7_0.season_info) or table.empty(arg_7_0.pre_season_info) then
		return 0
	end
	
	local var_7_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_7_0 then
		return 0
	end
	
	if table.empty(arg_7_0.season_info[var_7_0]) or table.empty(arg_7_0.pre_season_info[var_7_0]) then
		return 0
	end
	
	return (arg_7_0.season_info[var_7_0].rune_exp or 0) - (arg_7_0.pre_season_info[var_7_0].rune_exp or 0)
end

function DungeonCreviceUtil.getExploitPoint(arg_8_0)
	local var_8_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_8_0 then
		return 0
	end
	
	if table.empty(arg_8_0.season_info) or table.empty(arg_8_0.season_info[var_8_0]) then
		local var_8_1 = Account:getCrehuntSeasonInfo()
		
		if var_8_1 then
			return var_8_1.exploit_point or 0
		end
		
		return 0
	end
	
	return arg_8_0.season_info[var_8_0].exploit_point or 0
end

function DungeonCreviceUtil.getDiffExploitPoint(arg_9_0)
	if table.empty(arg_9_0.season_info) or table.empty(arg_9_0.pre_season_info) then
		return 0
	end
	
	local var_9_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_9_0 then
		return 0
	end
	
	if table.empty(arg_9_0.season_info[var_9_0]) or table.empty(arg_9_0.pre_season_info[var_9_0]) then
		return 0
	end
	
	return (arg_9_0.season_info[var_9_0].exploit_point or 0) - (arg_9_0.pre_season_info[var_9_0].exploit_point or 0)
end

function DungeonCreviceUtil.getExploitRewardPoint(arg_10_0)
	local var_10_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_10_0 then
		return 0
	end
	
	if table.empty(arg_10_0.season_info) or table.empty(arg_10_0.season_info[var_10_0]) then
		local var_10_1 = Account:getCrehuntSeasonInfo()
		
		if var_10_1 then
			return var_10_1.reward_point or 0
		end
		
		return 0
	end
	
	return arg_10_0.season_info[var_10_0].reward_point or 0
end

function DungeonCreviceUtil.setBossInfo(arg_11_0, arg_11_1, arg_11_2)
	if table.empty(arg_11_1) then
		return 
	end
	
	if not arg_11_0.boss_info then
		arg_11_0.boss_info = {}
	end
	
	if not arg_11_0.pre_boss_info then
		arg_11_0.pre_boss_info = {}
	end
	
	local var_11_0 = arg_11_1.season_id
	
	if table.empty(arg_11_0.boss_info[var_11_0]) then
		arg_11_0.boss_info[var_11_0] = {}
	end
	
	if table.empty(arg_11_0.pre_boss_info[var_11_0]) then
		arg_11_0.pre_boss_info[var_11_0] = {}
	end
	
	local var_11_1 = arg_11_1.difficulty or 0
	local var_11_2 = GAME_CONTENT_VARIABLE.crevicehunt_maxtrycount or 5
	local var_11_3 = "crehunt_reset_" .. tostring(var_11_1)
	
	if not table.empty(arg_11_0.boss_info[var_11_0][var_11_1]) then
		arg_11_0.pre_boss_info[var_11_0][var_11_1] = table.clone(arg_11_0.boss_info[var_11_0][var_11_1])
	end
	
	if arg_11_0.pre_boss_info and arg_11_0.pre_boss_info[var_11_0] and arg_11_0.pre_boss_info[var_11_0][var_11_1] then
		local var_11_4 = arg_11_0.pre_boss_info[var_11_0][var_11_1].enter_count
		
		if arg_11_2 and var_11_2 <= var_11_4 and var_11_2 <= arg_11_1.enter_count then
			SAVE:setKeep(var_11_3, true)
		end
	end
	
	if not table.empty(arg_11_0.boss_info[var_11_0][var_11_1]) then
		table.merge(arg_11_0.boss_info[var_11_0][var_11_1], arg_11_1)
	else
		arg_11_0.boss_info[var_11_0][var_11_1] = arg_11_1
	end
end

function DungeonCreviceUtil.getBossInfo(arg_12_0, arg_12_1)
	local var_12_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_12_0 then
		return nil
	end
	
	if table.empty(arg_12_0.boss_info) or table.empty(arg_12_0.boss_info[var_12_0]) then
		return nil
	end
	
	arg_12_1 = arg_12_1 or 0
	
	return arg_12_0.boss_info[var_12_0][arg_12_1]
end

function DungeonCreviceUtil.getCurrentTurnCount(arg_13_0, arg_13_1)
	local var_13_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_13_0 then
		return 0
	end
	
	if table.empty(arg_13_0.boss_info) or table.empty(arg_13_0.boss_info[var_13_0]) then
		return 0
	end
	
	arg_13_1 = arg_13_1 or 0
	
	if table.empty(arg_13_0.boss_info[var_13_0][arg_13_1]) then
		return 0
	end
	
	return arg_13_0.boss_info[var_13_0][arg_13_1].enter_count or 0
end

function DungeonCreviceUtil.getBossState(arg_14_0, arg_14_1)
	local var_14_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_14_0 then
		return 0
	end
	
	if table.empty(arg_14_0.boss_info) or table.empty(arg_14_0.boss_info[var_14_0]) then
		return 0
	end
	
	arg_14_1 = arg_14_1 or 0
	
	if table.empty(arg_14_0.boss_info[var_14_0][arg_14_1]) then
		return 0
	end
	
	return arg_14_0.boss_info[var_14_0][arg_14_1].state or 0
end

function DungeonCreviceUtil.getBossLastHp(arg_15_0, arg_15_1)
	local var_15_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_15_0 then
		return 0
	end
	
	if table.empty(arg_15_0.boss_info) or table.empty(arg_15_0.boss_info[var_15_0]) then
		return 0
	end
	
	arg_15_1 = arg_15_1 or 0
	
	if table.empty(arg_15_0.boss_info[var_15_0][arg_15_1]) then
		return 0
	end
	
	return arg_15_0.boss_info[var_15_0][arg_15_1].last_hp or 0
end

function DungeonCreviceUtil.getPreBossLastHp(arg_16_0, arg_16_1)
	local var_16_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_16_0 then
		return 0
	end
	
	if table.empty(arg_16_0.pre_boss_info) or table.empty(arg_16_0.pre_boss_info[var_16_0]) then
		return 0
	end
	
	arg_16_1 = arg_16_1 or 0
	
	if table.empty(arg_16_0.pre_boss_info[var_16_0][arg_16_1]) then
		return 0
	end
	
	return arg_16_0.pre_boss_info[var_16_0][arg_16_1].last_hp or 0
end

function DungeonCreviceUtil.getBossMaxHp(arg_17_0, arg_17_1)
	local var_17_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_17_0 then
		return 0
	end
	
	if table.empty(arg_17_0.boss_info) or table.empty(arg_17_0.boss_info[var_17_0]) then
		return 0
	end
	
	arg_17_1 = arg_17_1 or 0
	
	if table.empty(arg_17_0.boss_info[var_17_0][arg_17_1]) then
		return 0
	end
	
	return arg_17_0.boss_info[var_17_0][arg_17_1].max_hp or 0
end

function DungeonCreviceUtil.initAllSetInfos(arg_18_0)
	arg_18_0.all_set_infos = {}
	
	for iter_18_0 = 1, 999 do
		local var_18_0, var_18_1, var_18_2 = DBN("item_set", iter_18_0, {
			"id",
			"icon",
			"sort"
		})
		
		if not var_18_0 then
			break
		end
		
		local var_18_3 = {
			id = var_18_0,
			icon = var_18_1,
			sort = var_18_2
		}
		
		if not table.empty(var_18_3) then
			table.insert(arg_18_0.all_set_infos, var_18_3)
		end
	end
	
	if not table.empty(arg_18_0.all_set_infos) then
		table.sort(arg_18_0.all_set_infos, function(arg_19_0, arg_19_1)
			return arg_19_0.sort < arg_19_1.sort
		end)
	end
end

function DungeonCreviceUtil.getAllSetInfos(arg_20_0)
	if not arg_20_0.all_set_infos then
		arg_20_0:initAllSetInfos()
	end
	
	return arg_20_0.all_set_infos
end

function DungeonCreviceUtil.initRuneLevelInfos(arg_21_0)
	arg_21_0.rune_level_infos = {}
	arg_21_0.rune_unlock_infos = {}
	
	for iter_21_0 = 1, 999 do
		local var_21_0, var_21_1, var_21_2, var_21_3 = DBN("level_crevicehunt_runestone", iter_21_0, {
			"id",
			"cumulative_exp",
			"stone_cs",
			"unlock_rune_group"
		})
		
		if not var_21_0 then
			break
		end
		
		local var_21_4 = {
			level = var_21_0,
			accumulate_exp = var_21_1,
			stone_cs = var_21_2
		}
		
		table.insert(arg_21_0.rune_level_infos, var_21_4)
		table.sort(arg_21_0.rune_level_infos, function(arg_22_0, arg_22_1)
			return arg_22_0.level < arg_22_1.level
		end)
		
		if var_21_3 then
			local var_21_5 = {
				level = iter_21_0
			}
			
			arg_21_0.rune_unlock_infos[var_21_3] = var_21_5
		end
	end
end

function DungeonCreviceUtil.getRuenLevelInfos(arg_23_0)
	if not arg_23_0.rune_level_infos then
		arg_23_0:initRuneLevelInfos()
	end
	
	return arg_23_0.rune_level_infos
end

function DungeonCreviceUtil.getRuenUnlockInfos(arg_24_0)
	if not arg_24_0.rune_unlock_infos then
		arg_24_0:initRuneLevelInfos()
	end
	
	return arg_24_0.rune_unlock_infos
end

function DungeonCreviceUtil.initRuneGrouplInfos(arg_25_0)
	local var_25_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_25_0 then
		return 
	end
	
	if not arg_25_0.rune_groups then
		arg_25_0.rune_groups = {}
	end
	
	local var_25_1, var_25_2, var_25_3, var_25_4 = DB("level_crevicehunt", var_25_0, {
		"rune_group1",
		"rune_group2",
		"rune_group3",
		"rune_group4"
	})
	local var_25_5 = {
		var_25_1,
		var_25_2,
		var_25_3,
		var_25_4
	}
	
	for iter_25_0, iter_25_1 in pairs(var_25_5) do
		local var_25_6 = string.split(iter_25_1, ",")
		
		if var_25_6 then
			var_25_5[iter_25_0] = var_25_6
		end
	end
	
	arg_25_0.rune_groups[var_25_0] = {}
	
	for iter_25_2, iter_25_3 in pairs(var_25_5 or {}) do
		local var_25_7 = {}
		
		for iter_25_4, iter_25_5 in pairs(iter_25_3 or {}) do
			local var_25_8, var_25_9, var_25_10 = DB("skill", iter_25_5, {
				"id",
				"name",
				"sk_description"
			})
			local var_25_11 = {
				group = iter_25_2,
				uid = iter_25_4,
				id = var_25_8,
				name = var_25_9,
				desc = var_25_10
			}
			
			table.insert(var_25_7, var_25_11)
		end
		
		if not arg_25_0.rune_groups[var_25_0][iter_25_2] then
			arg_25_0.rune_groups[var_25_0][iter_25_2] = var_25_7
		end
	end
end

function DungeonCreviceUtil.getRuneGrouplInfos(arg_26_0)
	local var_26_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_26_0 then
		return nil
	end
	
	if not arg_26_0.rune_groups or not arg_26_0.rune_groups[var_26_0] then
		arg_26_0:initRuneGrouplInfos()
	end
	
	return arg_26_0.rune_groups[var_26_0]
end

function DungeonCreviceUtil.getTeamReturnAdd(arg_27_0)
	local var_27_0 = 0
	local var_27_1 = arg_27_0:getSelectedRunes()
	
	if table.empty(var_27_1) then
		return var_27_0
	end
	
	local var_27_2 = arg_27_0:getRuneGrouplInfos()
	
	for iter_27_0, iter_27_1 in pairs(var_27_1 or {}) do
		if var_27_2[iter_27_0] and var_27_2[iter_27_0][iter_27_1] and var_27_2[iter_27_0][iter_27_1].id == "cre_return_up" then
			var_27_0 = DB("cs", var_27_2[iter_27_0][iter_27_1].id, "cs_eff_value1") or 0
			
			break
		end
	end
	
	return var_27_0
end

function DungeonCreviceUtil.getLevelUpInfoByExp(arg_28_0, arg_28_1)
	if not arg_28_0.rune_level_infos then
		arg_28_0:initRuneLevelInfos()
	end
	
	arg_28_1 = arg_28_1 or 0
	
	local var_28_0 = arg_28_0:getLevelInfoByExp(arg_28_1)
	local var_28_1 = arg_28_0.rune_level_infos[var_28_0 + 1]
	
	if not var_28_1 then
		return nil, nil
	end
	
	local var_28_2 = arg_28_0.rune_level_infos[var_28_0]
	
	if not var_28_2 then
		return nil, nil
	end
	
	return var_28_1.accumulate_exp - var_28_2.accumulate_exp, arg_28_1 - var_28_2.accumulate_exp
end

function DungeonCreviceUtil.getCurrentLevelInfo(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0.rune_level_infos then
		arg_29_0:initRuneLevelInfos()
	end
	
	arg_29_2 = arg_29_2 or 0
	arg_29_1 = arg_29_1 or 1
	
	local var_29_0 = arg_29_0.rune_level_infos[arg_29_1 + 1]
	
	if not var_29_0 then
		return nil, nil
	end
	
	local var_29_1 = arg_29_0.rune_level_infos[arg_29_1]
	
	if not var_29_1 then
		return nil, nil
	end
	
	local var_29_2 = var_29_0.accumulate_exp - var_29_1.accumulate_exp
	
	if arg_29_2 >= var_29_0.accumulate_exp then
		return var_29_2, var_29_2
	end
	
	return var_29_2, arg_29_2 - var_29_1.accumulate_exp
end

function DungeonCreviceUtil.getLevelInfoByExp(arg_30_0, arg_30_1)
	if not arg_30_0.rune_level_infos then
		arg_30_0:initRuneLevelInfos()
	end
	
	arg_30_1 = arg_30_1 or 0
	
	local var_30_0 = 1
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.rune_level_infos) do
		if arg_30_1 < iter_30_1.accumulate_exp then
			break
		end
		
		var_30_0 = iter_30_1.level
	end
	
	return var_30_0
end

function DungeonCreviceUtil.checkLevelUP(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0.rune_level_infos then
		arg_31_0:initRuneLevelInfos()
	end
	
	arg_31_2 = arg_31_2 or 0
	arg_31_1 = arg_31_1 or 1
	
	local var_31_0 = false
	local var_31_1 = arg_31_0.rune_level_infos[arg_31_1 + 1]
	
	if not var_31_1 then
		return var_31_0
	end
	
	if arg_31_2 >= var_31_1.accumulate_exp then
		var_31_0 = true
	end
	
	return var_31_0
end

function DungeonCreviceUtil.getExtraDamageByExp(arg_32_0, arg_32_1)
	if not arg_32_0.rune_level_infos then
		arg_32_0:initRuneLevelInfos()
	end
	
	arg_32_1 = arg_32_1 or 0
	
	local var_32_0 = arg_32_0:getLevelInfoByExp(arg_32_1)
	local var_32_1 = arg_32_0.rune_level_infos[var_32_0]
	
	if not var_32_1 or not var_32_1.stone_cs then
		return 0
	end
	
	return (DB("cs", var_32_1.stone_cs, "cs_eff_value1") or 0) * 100
end

function DungeonCreviceUtil.isRemainNotSelectedRuneGroup(arg_33_0)
	if not arg_33_0.rune_level_infos then
		arg_33_0:initRuneLevelInfos()
	end
	
	local var_33_0 = arg_33_0:getRuneExp()
	local var_33_1 = arg_33_0:getLevelInfoByExp(var_33_0)
	local var_33_2 = arg_33_0:getRuenUnlockInfos()
	
	if table.empty(var_33_2) then
		return false
	end
	
	local var_33_3 = arg_33_0:getSelectedRunes()
	local var_33_4 = arg_33_0:getRuneGrouplInfos()
	
	for iter_33_0, iter_33_1 in pairs(var_33_4 or {}) do
		local var_33_5 = false
		local var_33_6 = var_33_2[iter_33_0]
		
		if var_33_6 and var_33_6.level then
			var_33_5 = var_33_1 >= var_33_6.level
		end
		
		if var_33_5 and not table.empty(var_33_3) and var_33_3[iter_33_0] == 0 then
			return true
		end
	end
	
	return false
end

function DungeonCreviceUtil.initExploitRewardItems(arg_34_0)
	if not arg_34_0.exploit_rewards then
		arg_34_0.exploit_rewards = {}
	end
	
	local var_34_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_34_0 then
		return 
	end
	
	arg_34_0.exploit_rewards[var_34_0] = {}
	
	for iter_34_0 = 1, 999 do
		local var_34_1, var_34_2, var_34_3, var_34_4, var_34_5, var_34_6, var_34_7, var_34_8 = DBN("crevicehunt_season_reward", iter_34_0, {
			"id",
			"season_id",
			"type",
			"point",
			"reward_count",
			"reward_id",
			"grade_rate",
			"set_drop"
		})
		
		if not var_34_2 then
			break
		end
		
		if var_34_0 == var_34_2 then
			local var_34_9 = {
				id = var_34_1,
				type = var_34_3,
				point = var_34_4,
				reward_count = var_34_5,
				reward_id = var_34_6,
				grade_rate = var_34_7,
				set_drop = var_34_8
			}
			
			table.insert(arg_34_0.exploit_rewards[var_34_0], var_34_9)
		end
	end
	
	if not table.empty(arg_34_0.exploit_rewards[var_34_0]) then
		table.sort(arg_34_0.exploit_rewards[var_34_0], function(arg_35_0, arg_35_1)
			return arg_35_0.point < arg_35_1.point
		end)
	end
	
	arg_34_0:updateRewardItems()
end

function DungeonCreviceUtil.getExploitRewardItems(arg_36_0)
	local var_36_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_36_0 then
		return nil
	end
	
	if not arg_36_0.exploit_rewards or not arg_36_0.exploit_rewards[var_36_0] then
		arg_36_0:initExploitRewardItems()
	end
	
	return arg_36_0.exploit_rewards[var_36_0]
end

function DungeonCreviceUtil.updateRewardItems(arg_37_0)
	local var_37_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_37_0 then
		return 
	end
	
	if not arg_37_0.exploit_rewards or not arg_37_0.exploit_rewards[var_37_0] then
		return 
	end
	
	local var_37_1 = arg_37_0:getExploitRewardPoint()
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.exploit_rewards[var_37_0]) do
		iter_37_1.is_received = var_37_1 >= iter_37_1.point
	end
end

function DungeonCreviceUtil.isRemainRewardItems(arg_38_0)
	local var_38_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_38_0 then
		return false
	end
	
	if not arg_38_0.exploit_rewards or not arg_38_0.exploit_rewards[var_38_0] then
		arg_38_0:initExploitRewardItems()
	end
	
	local var_38_1 = arg_38_0:getExploitPoint()
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.exploit_rewards[var_38_0] or {}) do
		if var_38_1 >= iter_38_1.point and not iter_38_1.is_received then
			return true
		end
	end
	
	return false
end

function DungeonCreviceUtil.isFirstEnter(arg_39_0, arg_39_1)
	local var_39_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_39_0 then
		return false
	end
	
	if table.empty(arg_39_0.boss_info) or table.empty(arg_39_0.boss_info[var_39_0]) then
		return false
	end
	
	arg_39_1 = arg_39_1 or 0
	
	if table.empty(arg_39_0.boss_info[var_39_0][arg_39_1]) then
		return false
	end
	
	local var_39_1 = GAME_CONTENT_VARIABLE.crevicehunt_maxtrycount or 5
	
	return arg_39_0.boss_info[var_39_0][arg_39_1].state ~= 1 or var_39_1 <= arg_39_0.boss_info[var_39_0][arg_39_1].enter_count
end

function DungeonCreviceUtil.isCanBossRetry(arg_40_0, arg_40_1)
	local var_40_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_40_0 then
		return false
	end
	
	if table.empty(arg_40_0.boss_info) or table.empty(arg_40_0.boss_info[var_40_0]) then
		return false
	end
	
	arg_40_1 = arg_40_1 or 0
	
	if table.empty(arg_40_0.boss_info[var_40_0][arg_40_1]) then
		return false
	end
	
	return arg_40_0.boss_info[var_40_0][arg_40_1].state == 1
end

function DungeonCreviceUtil.isResetBossInfo(arg_41_0, arg_41_1)
	arg_41_1 = arg_41_1 or 0
	
	local var_41_0 = "crehunt_reset_" .. tostring(arg_41_1)
	
	return SAVE:getKeep(var_41_0)
end

function DungeonCreviceUtil.openBossResetPopup(arg_42_0, arg_42_1)
	arg_42_1 = arg_42_1 or 0
	
	local var_42_0 = Account:getCrehuntSeasonScheduleID()
	
	if not var_42_0 then
		return 
	end
	
	if table.empty(arg_42_0.boss_info) or table.empty(arg_42_0.boss_info[var_42_0]) or table.empty(arg_42_0.boss_info[var_42_0][arg_42_1]) then
		return 
	end
	
	local var_42_1 = arg_42_0.boss_info[var_42_0][arg_42_1]
	local var_42_2 = arg_42_0:isResetBossInfo(arg_42_1)
	local var_42_3 = GAME_CONTENT_VARIABLE.crevicehunt_maxtrycount or 5
	
	if var_42_2 and var_42_3 <= var_42_1.enter_count then
		var_42_1.last_hp = var_42_1.max_hp
		var_42_1.enter_count = 0
		var_42_1.state = 0
		
		Dialog:msgBox(T("ui_crevicehunt_tryreset_popup_desc"), {
			title = T("ui_crevicehunt_tryreset_popup_name")
		})
		
		local var_42_4 = "crehunt_reset_" .. tostring(arg_42_1)
		
		SAVE:setKeep(var_42_4, false)
	end
end

function DungeonCreviceUtil.getBossInfoWnd(arg_43_0, arg_43_1)
	arg_43_1 = arg_43_1 or 0
	
	local var_43_0 = DungeonCreviceUtil:getBossInfo(arg_43_1)
	
	if table.empty(var_43_0) then
		return 
	end
	
	local var_43_1 = load_control("wnd/crevice_boss_info.csb")
	
	if_set_visible(var_43_1, "icon_pro", false)
	if_set_visible(var_43_1, "btn_boss", false)
	
	local var_43_2 = var_43_1:getChildByName("n_mob_icon")
	
	if get_cocos_refid(var_43_2) then
		local var_43_3 = Account:getCrehuntSeasonEnterIDBydifficulty(arg_43_1)
		local var_43_4
		
		for iter_43_0 = 1, 40 do
			local var_43_5, var_43_6 = DB("level_enter_drops", var_43_3, {
				"monster" .. iter_43_0,
				"lv" .. iter_43_0
			})
			
			if var_43_5 and var_43_0.boss_code and var_43_5 == var_43_0.boss_code then
				var_43_4 = var_43_6
			end
		end
		
		UIUtil:getRewardIcon("c", var_43_0.boss_code, {
			hide_lv = true,
			tier = "boss",
			hide_star = true,
			show_color_right = true,
			monster = true,
			scale = 1,
			parent = var_43_2,
			lv = var_43_4
		}):setAnchorPoint(0, 0)
	end
	
	local var_43_7 = DB("character", var_43_0.boss_code, {
		"name"
	})
	
	if_set(var_43_1, "txt_name", T(var_43_7))
	
	local var_43_8 = 1
	
	if var_43_0.last_hp and var_43_0.max_hp and var_43_0.max_hp ~= 0 then
		var_43_8 = var_43_0.last_hp / var_43_0.max_hp
	end
	
	local var_43_9 = var_43_0.enter_count
	local var_43_10 = GAME_CONTENT_VARIABLE.crevicehunt_maxtrycount or 5
	
	if var_43_0.state == 2 or var_43_10 <= var_43_9 then
		var_43_8 = 1
		var_43_9 = 0
	end
	
	if_set_percent(var_43_1, "progress_hp", var_43_8)
	if_set(var_43_1, "txt_dare", T("ui_crevicehunt_limit_left"))
	
	local var_43_11 = GAME_CONTENT_VARIABLE.crevicehunt_maxtrycount or 5
	
	if_set(var_43_1, "txt_count", T("ui_crevicehunt_limit_leftcount", {
		value = var_43_11 - var_43_9
	}))
	
	return var_43_1
end

function DungeonCreviceUtil.getBossFuPath(arg_44_0, arg_44_1)
	if not arg_44_1 then
		return nil
	end
	
	local var_44_0
	local var_44_1 = DB("character", arg_44_1, {
		"face_id"
	})
	
	if var_44_1 then
		var_44_0 = "face/" .. var_44_1 .. "_fu.png"
	end
	
	return var_44_0
end

function DungeonCreviceUtil.isCrehuntMode(arg_45_0, arg_45_1)
	if not arg_45_1 then
		return false
	end
	
	return DB("level_enter", arg_45_1, "contents_type") == "crehunt"
end
