LotaClanInfo = {}
LotaClanInfoInterface = {
	season_id = "heritage001",
	boss_dead_count = 0,
	clan_id = 0,
	keeper_dead_count = 0,
	map_config = {
		floor_config = {
			{
				map_id = "",
				tile_count = 0
			}
		}
	},
	ping_status = {}
}

function LotaClanInfo.documentToInterface(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = table.clone(LotaClanInfoInterface)
	
	var_1_0.map_config = arg_1_1.map_config
	var_1_0.clan_id = arg_1_1.clan_id
	var_1_0.end_day_id = arg_1_1.end_day_id
	var_1_0.start_day_id = arg_1_1.start_day_id
	var_1_0.season_id = arg_1_1.season_id
	var_1_0.keeper_dead_count = arg_1_2.keeper_dead_count
	var_1_0.boss_dead_count = arg_1_2.boss_dead_count
	
	return var_1_0
end

function LotaClanInfo.init(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.info = arg_2_1
end

function LotaClanInfo.getCurrentQuestProgress(arg_3_0)
	local var_3_0 = LotaUserData:getFloor()
	
	if not (arg_3_0:getKeeperDeadCount(var_3_0) >= arg_3_0:getRequireKeeperDeadCount(var_3_0)) then
		return 1
	end
	
	if not (LotaClanInfo:getBossDeadCount(var_3_0) > 0) then
		return 2
	end
	
	if not (LotaClanInfo:getBossDeadCount(var_3_0) > 3) then
		return 3
	end
	
	return 4
end

function LotaClanInfo.getSeasonId(arg_4_0)
	return LotaSystem:getCurrentSeasonDB().id
end

function LotaClanInfo.getCurrentSummaryData(arg_5_0, arg_5_1)
	local var_5_0 = LotaUserData:getQuestSummaryKey()
	local var_5_1 = arg_5_0:getCurrentQuestProgress()
	
	if var_5_1 == 4 then
		return "clan_heritage_quest_f4_desc_allclear"
	end
	
	return (DB("clan_heritage_quest_summary", var_5_0, "quest_" .. tostring(var_5_1) .. "_" .. arg_5_1))
end

function LotaClanInfo.getCurrentQuestDesc(arg_6_0)
	return arg_6_0:getCurrentSummaryData("target_desc")
end

function LotaClanInfo.getCurrentQuestTitle(arg_7_0)
	return arg_7_0:getCurrentSummaryData("target_title")
end

function LotaClanInfo.getCurrentQuestIcon(arg_8_0)
	return arg_8_0:getCurrentSummaryData("target_icon")
end

function LotaClanInfo.getCurrentQuestType(arg_9_0)
	return arg_9_0:getCurrentSummaryData("target")
end

function LotaClanInfo.getKeeperDeadCount(arg_10_0)
	return arg_10_0.vars.info.keeper_dead_count or 0
end

function LotaClanInfo.getBossDeadCount(arg_11_0)
	return arg_11_0.vars.info.boss_dead_count or 0
end

function LotaClanInfo.getRequireKeeperDeadCount(arg_12_0)
	local var_12_0 = LotaSystem:getWorldId()
	
	return DB("clan_heritage_world", var_12_0, "need_keeper_kill")
end

function LotaClanInfo.isAvailableBossBattle(arg_13_0, arg_13_1)
	return arg_13_0:getRequireKeeperDeadCount(arg_13_1) <= arg_13_0:getKeeperDeadCount(arg_13_1)
end

function LotaClanInfo.updateKeeperDeadCount(arg_14_0, arg_14_1)
	arg_14_0.vars.info.keeper_dead_count = arg_14_1
end

function LotaClanInfo.updateBossDeadCount(arg_15_0, arg_15_1)
	arg_15_0.vars.info.boss_dead_count = arg_15_1
end

function LotaClanInfo.updateExplorePoint(arg_16_0, arg_16_1)
end

function LotaClanInfo.getExplorePoint(arg_17_0)
	return 0
end

function LotaClanInfo.getRequireExplorePoint(arg_18_0)
	return 765
end

function LotaClanInfo.close(arg_19_0)
	arg_19_0.vars = nil
end
