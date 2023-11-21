SeasonPass = SeasonPass or {}
SeasonPass.vars = {}
SeasonPass.onRefreshData = Delegate.new()
SeasonPass.onGetRankReward = Delegate.new()
SeasonPass.onGetBonusReward = Delegate.new()
SeasonPass.onGetCompleteReward = Delegate.new()
SeasonPass.onAddSeasonPassRank = Delegate.new()
SeasonPass.onUpgrade = Delegate.new()
SeasonPass.onUpdateRankExp = Delegate.new()

function MsgHandler.get_season_pass_reward(arg_1_0)
	if not arg_1_0 or arg_1_0.res ~= "ok" then
		return 
	end
	
	local var_1_0 = {
		title = T("clear_gg_quest_title"),
		desc = T(SeasonPass:isModeEpic(arg_1_0.event_id) and "season_reward_popup_desc" or "substory_reward_popup_desc")
	}
	local var_1_1 = Account:addReward(arg_1_0.rewards)
	
	Dialog:msgScrollRewards(T("season_reward_popup_desc"), {
		open_effect = true,
		title = T("ui_msgbox_rewards_title"),
		rewards = {
			new_items = var_1_1.rewards
		}
	})
	
	AccountData.season_pass[arg_1_0.event_id] = AccountData.season_pass[arg_1_0.event_id] or {}
	AccountData.season_pass[arg_1_0.event_id] = arg_1_0.season_pass_info
	
	SeasonPass:updateReward(arg_1_0.event_id, arg_1_0.season_pass_info)
	TutorialNotice:updateSpecific("user_border_01")
end

function MsgHandler.refresh_season_pass_data(arg_2_0)
	if not arg_2_0 or arg_2_0.res ~= "ok" then
		return 
	end
	
	if not AccountData.season_pass then
		return 
	end
	
	if AccountData.season_pass_schedules[arg_2_0.event_id] then
		AccountData.season_pass[arg_2_0.event_id] = arg_2_0.season_pass_info
		
		SeasonPass.onRefreshData(arg_2_0.event_id)
	else
		SubStoryLobby:updateUI()
	end
	
	TopBarNew:updateSeasonPass()
end

function MsgHandler.add_season_pass_rank(arg_3_0)
	if not arg_3_0 or arg_3_0.res ~= "ok" then
		return 
	end
	
	if arg_3_0.update_currency then
		Account:updateCurrencies(arg_3_0.update_currency)
	end
	
	if not SeasonPass.vars.schedules then
		return 
	end
	
	SeasonPass:setRank(arg_3_0.event_id, arg_3_0.season_pass_info.rank, arg_3_0.season_pass_info.exp)
	SeasonPass.onAddSeasonPassRank(arg_3_0.prev_rank, arg_3_0.season_pass_info.rank)
end

function MsgHandler.unlock_season_pass_grade(arg_4_0)
	local function var_4_0()
		Account:updateCurrencies(arg_4_0.update_currency)
		TopBarNew:topbarUpdate(true)
	end
	
	SeasonPassPack:show(arg_4_0.season_pass_doc, function()
		var_4_0(true)
	end)
	SeasonPassPromotion:close()
end

function SeasonPass.updateSchdule(arg_7_0, arg_7_1)
	arg_7_0.vars.schedules[arg_7_1.id] = arg_7_1
	
	local var_7_0 = arg_7_0.vars.schedules[arg_7_1.id].reward_db
	
	arg_7_0.vars.schedules[arg_7_1.id].rank_rewards = {}
	
	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		local var_7_1 = tonumber(iter_7_0)
		
		if var_7_1 then
			arg_7_0.vars.schedules[arg_7_1.id].rank_rewards[var_7_1] = {
				rank = iter_7_1.rank,
				free = {
					is_rewarded = false,
					id = iter_7_1.free_rank_reward_id,
					count = iter_7_1.free_rank_reward_count,
					grade_rate = iter_7_1.grade_rate1,
					set_drop = iter_7_1.set_drop_rate_id1
				},
				pass01 = {
					is_rewarded = false,
					id = iter_7_1.common_rank_reward1_id,
					count = iter_7_1.common_rank_reward1_count,
					grade_rate = iter_7_1.grade_rate2,
					set_drop = iter_7_1.set_drop_rate_id2
				},
				pass02 = {
					is_rewarded = false,
					id = iter_7_1.common_rank_reward2_id,
					count = iter_7_1.common_rank_reward2_count,
					grade_rate = iter_7_1.grade_rate3,
					set_drop = iter_7_1.set_drop_rate_id3
				}
			}
		elseif iter_7_0 == "complete" then
			arg_7_0.vars.schedules[arg_7_1.id].complete_rewards = {
				rank = iter_7_1.rank,
				free = {
					is_rewarded = false,
					id = iter_7_1.free_rank_reward_id,
					count = iter_7_1.free_rank_reward_count,
					grade_rate = iter_7_1.grade_rate1,
					set_drop = iter_7_1.set_drop_rate_id1
				},
				pass01 = {
					is_rewarded = false,
					id = iter_7_1.common_rank_reward1_id,
					count = iter_7_1.common_rank_reward1_count,
					grade_rate = iter_7_1.grade_rate2,
					set_drop = iter_7_1.set_drop_rate_id2
				},
				pass02 = {
					is_rewarded = false,
					id = iter_7_1.common_rank_reward2_id,
					count = iter_7_1.common_rank_reward2_count,
					grade_rate = iter_7_1.grade_rate3,
					set_drop = iter_7_1.set_drop_rate_id3
				}
			}
		elseif iter_7_0 == "bonus" then
			arg_7_0.vars.schedules[arg_7_1.id].bonus_reward = {
				is_rewarded = false,
				rank = iter_7_1.rank,
				id = iter_7_1.common_rank_reward1_id,
				count = iter_7_1.common_rank_reward1_count,
				grade_rate = iter_7_1.grade_rate2,
				set_drop = iter_7_1.set_drop_rate_id2
			}
		end
	end
end

function SeasonPass.addSchedule(arg_8_0, arg_8_1)
	if arg_8_0.vars.schedules[arg_8_1.id] then
		return 
	end
	
	arg_8_0:updateSchdule(arg_8_1)
end

function SeasonPass.initSubstoryData(arg_9_0, arg_9_1)
	arg_9_0.vars.schedules = arg_9_0.vars.schedules or {}
	
	local var_9_0 = Account:getSubstoryPassData()
	
	if var_9_0 then
		arg_9_0:updateSchdule(var_9_0)
	end
	
	if not arg_9_1 then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		arg_9_0:updateReward(iter_9_0, iter_9_1)
	end
end

function SeasonPass.initSchedules(arg_10_0)
	arg_10_0.vars.schedules = arg_10_0.vars.schedules or {}
	
	local var_10_0 = Account:getSeasonPassSchedules()
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		arg_10_0:addSchedule(iter_10_1)
	end
	
	if not AccountData.season_pass then
		return 
	end
	
	for iter_10_2, iter_10_3 in pairs(AccountData.season_pass) do
		arg_10_0:updateReward(iter_10_2, iter_10_3)
	end
end

function SeasonPass.updateRankReward(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_1 then
		return 
	end
	
	if not arg_11_2 then
		return 
	end
	
	local var_11_0 = false
	
	if arg_11_2.normal_reward_rank then
		for iter_11_0 = 1, arg_11_2.normal_reward_rank do
			if not arg_11_1.rank_rewards[iter_11_0].free.is_rewarded then
				var_11_0 = true
				arg_11_1.rank_rewards[iter_11_0].free.is_rewarded = true
			end
		end
	end
	
	if arg_11_2.upgrade_reward_rank then
		for iter_11_1 = 1, arg_11_2.upgrade_reward_rank do
			if not arg_11_1.rank_rewards[iter_11_1].pass01.is_rewarded then
				var_11_0 = true
				arg_11_1.rank_rewards[iter_11_1].pass01.is_rewarded = true
				arg_11_1.rank_rewards[iter_11_1].pass02.is_rewarded = true
			end
		end
	end
	
	if var_11_0 then
		arg_11_0.onGetRankReward(arg_11_2.normal_reward_rank)
	end
end

function SeasonPass.updateCompleteReward(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 then
		return 
	end
	
	if not arg_12_2 then
		return 
	end
	
	local var_12_0 = false
	
	if arg_12_1.max_rank == arg_12_2.normal_reward_rank and not arg_12_1.complete_rewards.free.is_rewarded then
		var_12_0 = true
		arg_12_1.complete_rewards.free.is_rewarded = true
	end
	
	if arg_12_1.max_rank == arg_12_2.upgrade_reward_rank and not arg_12_1.complete_rewards.pass01.is_rewarded then
		var_12_0 = true
		arg_12_1.complete_rewards.pass01.is_rewarded = true
		arg_12_1.complete_rewards.pass02.is_rewarded = true
	end
	
	if var_12_0 then
		arg_12_0.onGetCompleteReward()
	end
end

function SeasonPass.updateBonusReward(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 then
		return 
	end
	
	if not arg_13_2 then
		return 
	end
	
	if arg_13_1.bonus_reward.is_rewarded then
		return 
	end
	
	if arg_13_2.special_reward_state ~= 1 then
		return 
	end
	
	arg_13_1.bonus_reward.is_rewarded = true
	
	arg_13_0.onGetBonusReward()
end

function SeasonPass.updateReward(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0:getSchedule(arg_14_1)
	
	if not var_14_0 then
		return 
	end
	
	arg_14_0:updateRankReward(var_14_0, arg_14_2)
	arg_14_0:updateCompleteReward(var_14_0, arg_14_2)
	arg_14_0:updateBonusReward(var_14_0, arg_14_2)
end

function SeasonPass.setGrade(arg_15_0, arg_15_1, arg_15_2)
	AccountData.season_pass[arg_15_1] = AccountData.season_pass[arg_15_1] or {}
	AccountData.season_pass[arg_15_1].grade = AccountData.season_pass[arg_15_1].grade or 0
	
	if arg_15_2 > AccountData.season_pass[arg_15_1].grade then
		AccountData.season_pass[arg_15_1].grade = arg_15_2
		
		SeasonPass.onUpgrade(arg_15_1)
	end
end

function SeasonPass.getGrade(arg_16_0, arg_16_1)
	AccountData.season_pass[arg_16_1] = AccountData.season_pass[arg_16_1] or {}
	AccountData.season_pass[arg_16_1].grade = AccountData.season_pass[arg_16_1].grade or 0
	
	return AccountData.season_pass[arg_16_1].grade
end

function SeasonPass.getSchedules(arg_17_0)
	if not arg_17_0.vars.schedules then
		arg_17_0:initSchedules()
	end
	
	return arg_17_0.vars.schedules
end

function SeasonPass.getSchedule(arg_18_0, arg_18_1)
	return arg_18_0:getSchedules()[arg_18_1]
end

function SeasonPass.getName(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:getSchedule(arg_19_1)
	
	if not var_19_0 then
		return ""
	end
	
	return T(var_19_0.main_db.name)
end

function SeasonPass.getMode(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:getSchedule(arg_20_1)
	
	if not var_20_0 then
		return ""
	end
	
	return var_20_0.main_db.mode
end

function SeasonPass.isModeEpic(arg_21_0, arg_21_1)
	return arg_21_0:getMode(arg_21_1) == "season"
end

function SeasonPass.getPreviousSeasonPassID(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return nil
	end
	
	local var_22_0 = arg_22_0:getSchedule(arg_22_1)
	
	if not var_22_0 then
		return nil
	end
	
	return var_22_0.main_db.prev_season_id
end

function SeasonPass.isPrevSeasonPass(arg_23_0, arg_23_1)
	return arg_23_0:isModeEpic(arg_23_1) and arg_23_1 ~= arg_23_0:getOpenSeasonID()
end

function SeasonPass.isExchangePeriod(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0:getEndTime(arg_24_1)
	local var_24_1 = var_24_0 + 604800
	
	return var_24_0 < os.time() and var_24_1 > os.time()
end

function SeasonPass.getType(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:getSchedule(arg_25_1)
	
	if not var_25_0 then
		return ""
	end
	
	return var_25_0.main_db.pass_type
end

function SeasonPass.isTypeRank(arg_26_0, arg_26_1)
	return arg_26_0:getType(arg_26_1) == "rank"
end

function SeasonPass.getStartTime(arg_27_0, arg_27_1)
	if not arg_27_0:isModeEpic(arg_27_1) then
		local var_27_0, var_27_1, var_27_2 = SubstoryManager:getEventTimeInfo()
		
		return var_27_1
	end
	
	local var_27_3 = arg_27_0:getSchedule(arg_27_1)
	
	if not var_27_3 then
		return 0
	end
	
	return var_27_3.start_time
end

function SeasonPass.getEndTime(arg_28_0, arg_28_1)
	if not arg_28_0:isModeEpic(arg_28_1) then
		local var_28_0, var_28_1, var_28_2 = SubstoryManager:getEventTimeInfo()
		
		return var_28_2
	end
	
	local var_28_3 = arg_28_0:getSchedule(arg_28_1)
	
	if not var_28_3 then
		return 0
	end
	
	return var_28_3.end_time
end

local function var_0_0(arg_29_0)
	if not arg_29_0 then
		return {}
	end
	
	local function var_29_0(arg_30_0)
		if arg_30_0 == "n" or arg_30_0 == "false" then
			return false
		end
		
		if arg_30_0 == "y" or arg_30_0 == "true" then
			return true
		end
		
		if arg_30_0 == "nil" or arg_30_0 == "" then
			return nil
		end
		
		local var_30_0 = tonumber(arg_30_0)
		
		if var_30_0 then
			return var_30_0
		end
		
		return arg_30_0
	end
	
	arg_29_0 = string.gsub(arg_29_0, " ", "")
	
	local var_29_1 = totable(arg_29_0)
	
	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		var_29_1[iter_29_0] = var_29_0(iter_29_1)
	end
	
	return var_29_1
end

function SeasonPass.getBackgroundData(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0:getSchedule(arg_31_1)
	
	if not var_31_0 then
		return nil
	end
	
	return var_0_0(var_31_0.main_db.bg)
end

function SeasonPass.getPortraitData(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:getSchedule(arg_32_1)
	
	if not var_32_0 then
		return nil
	end
	
	return var_0_0(var_32_0.main_db.portrait)
end

function SeasonPass.getBalloonData(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0:getSchedule(arg_33_1)
	
	if not var_33_0 then
		return nil
	end
	
	return var_33_0.main_db.npc_balloon
end

function SeasonPass.isRemainReward(arg_34_0, arg_34_1)
	if not arg_34_1 then
		return false
	end
	
	if arg_34_0:getLowestRewardableRank(arg_34_1) then
		return true
	end
	
	if arg_34_0:isMaxRank(arg_34_1) and not arg_34_0:isCompleteRewarded(arg_34_1) then
		return true
	end
	
	if arg_34_0:isPaidSpecial(arg_34_1) and not arg_34_0:isBonusRewarded(arg_34_1) then
		return true
	end
	
	return false
end

function SeasonPass.getRewardRemainTime(arg_35_0, arg_35_1)
	local var_35_0 = 86400
	local var_35_1 = arg_35_0:getEndTime(arg_35_1)
	local var_35_2 = 7 * var_35_0 - (os.time() - var_35_1)
	local var_35_3 = math.floor(var_35_2 / 60)
	local var_35_4 = math.floor(var_35_3 / 60)
	
	return math.floor(var_35_4 / 24), var_35_4, var_35_3, var_35_2
end

function SeasonPass.isRewardableSeason(arg_36_0, arg_36_1)
	if not arg_36_1 then
		return false
	end
	
	if not arg_36_0:isModeEpic(arg_36_1) then
		return false
	end
	
	local var_36_0 = arg_36_0:getRewardRemainTime(arg_36_1)
	
	return var_36_0 >= 0 and var_36_0 < 7
end

function SeasonPass.getSeasonRemainTime(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0:getEndTime(arg_37_1) - os.time()
	local var_37_1 = math.floor(var_37_0 / 60)
	local var_37_2 = math.floor(var_37_1 / 60)
	
	return math.floor(var_37_2 / 24), var_37_2, var_37_1, var_37_0
end

function SeasonPass.isOpenSeason(arg_38_0, arg_38_1)
	if not arg_38_1 then
		return false
	end
	
	if not arg_38_0:isModeEpic(arg_38_1) then
		return false
	end
	
	local var_38_0 = arg_38_0:getStartTime(arg_38_1)
	local var_38_1 = arg_38_0:getEndTime(arg_38_1)
	
	return var_38_0 < os.time() and var_38_1 > os.time()
end

function SeasonPass.getOpenSeasonID(arg_39_0)
	if arg_39_0.open_season_id and arg_39_0:isOpenSeason(arg_39_0.open_season_id) then
		return arg_39_0.open_season_id
	end
	
	local var_39_0 = arg_39_0:getSchedules()
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if arg_39_0:isOpenSeason(iter_39_1.id) == true then
			arg_39_0.open_season_id = iter_39_1.id
			
			return arg_39_0.open_season_id
		end
	end
	
	return nil
end

function SeasonPass.getRewardableSeasonID(arg_40_0)
	if arg_40_0.open_season_id and arg_40_0:isOpenSeason(arg_40_0.open_season_id) then
		return arg_40_0.open_season_id
	end
	
	local var_40_0 = arg_40_0:getSchedules()
	
	for iter_40_0, iter_40_1 in pairs(var_40_0) do
		if arg_40_0:isRewardableSeason(iter_40_1.id) == true then
			arg_40_0.open_season_id = iter_40_1.id
			
			return arg_40_0.open_season_id
		end
	end
	
	return nil
end

function SeasonPass.setRank(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not AccountData.season_pass then
		return 
	end
	
	if not AccountData.season_pass[arg_41_1] then
		return 
	end
	
	arg_41_3 = arg_41_3 or arg_41_0:getAccumRankExp(arg_41_1, arg_41_2)
	AccountData.season_pass[arg_41_1].exp = arg_41_3
	AccountData.season_pass[arg_41_1].rank = arg_41_2
	
	SeasonPass.onUpdateRankExp()
end

function SeasonPass.getRank(arg_42_0, arg_42_1)
	if not AccountData.season_pass then
		return 1
	end
	
	if not AccountData.season_pass[arg_42_1] then
		return 1
	end
	
	return AccountData.season_pass[arg_42_1].rank or 1
end

function SeasonPass.setRankExp(arg_43_0, arg_43_1, arg_43_2)
	if not AccountData.season_pass then
		return 
	end
	
	if not AccountData.season_pass[arg_43_1] then
		return 
	end
	
	AccountData.season_pass[arg_43_1].exp = arg_43_2
	AccountData.season_pass[arg_43_1].rank = arg_43_0:getRankByExp(arg_43_2)
	
	SeasonPass.onUpdateRankExp()
end

function SeasonPass.getRankByExp(arg_44_0, arg_44_1, arg_44_2)
	for iter_44_0 = arg_44_0:getMaxRank(arg_44_1), 1 do
		if arg_44_2 < arg_44_0:getAccumRankExp(arg_44_1, iter_44_0) then
			return iter_44_0
		end
	end
	
	return 0
end

function SeasonPass.getRankExp(arg_45_0, arg_45_1)
	if not AccountData.season_pass then
		return 0
	end
	
	if not AccountData.season_pass[arg_45_1] then
		return 0
	end
	
	return AccountData.season_pass[arg_45_1].exp or 0
end

function SeasonPass.getAccumRankExp(arg_46_0, arg_46_1, arg_46_2)
	arg_46_2 = math.min(math.max(0, arg_46_2), arg_46_0:getMaxRank(arg_46_1))
	
	if arg_46_2 == 0 then
		return 0
	end
	
	local var_46_0 = arg_46_0:getSchedule(arg_46_1)
	
	if not var_46_0 then
		return 0
	end
	
	return var_46_0.rank_db[tostring(arg_46_2)].accum_exp
end

function SeasonPass.getRankUpPrice(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0:getSchedule(arg_47_1)
	
	if not var_47_0 then
		return 0
	end
	
	return var_47_0.main_db.rankup_price
end

function SeasonPass.getPackageItem(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0:getSchedule(arg_48_1)
	
	if not var_48_0 then
		return 0
	end
	
	return var_48_0.shop_db[arg_48_2]
end

function SeasonPass.getMaxRank(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0:getSchedule(arg_49_1)
	
	if not var_49_0 then
		return 0
	end
	
	return var_49_0.max_rank
end

function SeasonPass.isMaxRank(arg_50_0, arg_50_1)
	return arg_50_0:getRank(arg_50_1) == arg_50_0:getMaxRank(arg_50_1)
end

function SeasonPass.getRankRewards(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0:getSchedule(arg_51_1)
	
	if not var_51_0 then
		return {}
	end
	
	if arg_51_2 then
		return var_51_0.rank_rewards[tonumber(arg_51_2) or arg_51_2]
	end
	
	return var_51_0.rank_rewards
end

function SeasonPass.getCompleteRewards(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0:getSchedule(arg_52_1)
	
	if not var_52_0 then
		return nil
	end
	
	return var_52_0.complete_rewards
end

function SeasonPass.getBonusReward(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0:getSchedule(arg_53_1)
	
	if not var_53_0 then
		return nil
	end
	
	return var_53_0.bonus_reward
end

function SeasonPass.isPaidPremium(arg_54_0, arg_54_1)
	return arg_54_0:getGrade(arg_54_1) > 0
end

function SeasonPass.isPaidSpecial(arg_55_0, arg_55_1)
	return arg_55_0:getGrade(arg_55_1) > 1
end

function SeasonPass.isRemainPackage(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0:getSchedule(arg_56_1)
	
	if not var_56_0 then
		return false
	end
	
	local var_56_1 = arg_56_0:getGrade(arg_56_1)
	
	if var_56_1 == 2 then
		return false
	end
	
	if not var_56_0.main_db.high_price and var_56_1 == 1 then
		return false
	end
	
	return true
end

function SeasonPass.getBuyPackages(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0:getSchedule(arg_57_1)
	
	if not var_57_0 then
		return nil
	end
	
	local var_57_1 = var_57_0.main_db
	local var_57_2 = {
		type = "common",
		banner = var_57_1.common_bg_image,
		price = var_57_1.common_price,
		rank = var_57_1.common_rank,
		tooltip = var_57_1.common_item_tooltip
	}
	local var_57_3 = {
		type = "upgrade",
		banner = var_57_1.upgrade_bg_image,
		price = var_57_1.upgrade_price,
		rank = var_57_1.upgrade_rank,
		tooltip = var_57_1.upgrade_item_tooltip
	}
	local var_57_4 = {
		type = "high",
		banner = var_57_1.high_bg_image,
		price = var_57_1.high_price,
		rank = var_57_1.high_rank,
		tooltip = var_57_1.high_item_tooltip
	}
	local var_57_5 = arg_57_0:getGrade(arg_57_1)
	
	if var_57_1.common_price and var_57_5 == 1 and var_57_1.upgrade_price then
		return var_57_3
	end
	
	if var_57_1.common_price and var_57_1.high_price then
		return var_57_2, var_57_4
	end
	
	if var_57_1.common_price then
		return var_57_2
	end
	
	if var_57_1.high_price then
		return var_57_4
	end
end

function SeasonPass.isRewarded(arg_58_0, arg_58_1, arg_58_2)
	if arg_58_2.free.id and (arg_58_2.free.is_rewarded == nil or arg_58_2.free.is_rewarded == false) then
		return false
	end
	
	if arg_58_0:isPaidPremium(arg_58_1) and arg_58_2.pass01.id and (arg_58_2.pass01.is_rewarded == nil or arg_58_2.pass01.is_rewarded == false) then
		return false
	end
	
	return true
end

function SeasonPass.isBonusRewarded(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0:getBonusReward(arg_59_1)
	
	if not var_59_0 then
		return false
	end
	
	local var_59_1 = var_59_0.is_rewarded
	
	if var_59_1 == nil or var_59_1 == false then
		return false
	end
	
	return true
end

function SeasonPass.isCompleteRewarded(arg_60_0, arg_60_1)
	return arg_60_0:isRewarded(arg_60_1, arg_60_0:getCompleteRewards(arg_60_1))
end

function SeasonPass.getLowestRewardableRank(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0:getRank(arg_61_1)
	local var_61_1 = arg_61_0:getRankRewards(arg_61_1)
	
	for iter_61_0 = 1, var_61_0 do
		if not arg_61_0:isRewarded(arg_61_1, var_61_1[iter_61_0]) then
			return iter_61_0
		end
	end
	
	return nil
end

function SeasonPass.isHaveBonusReward(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_0:getSchedule(arg_62_1)
	
	if not var_62_0 then
		return false
	end
	
	return var_62_0.reward_db.bonus ~= nil
end

function SeasonPass.getExpDatas(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0:getSchedule(arg_63_1)
	
	if not var_63_0 then
		return 0
	end
	
	return var_63_0.exp_db
end

function SeasonPass.getIntroStoryID(arg_64_0, arg_64_1)
	local var_64_0 = arg_64_0:getSchedule(arg_64_1)
	
	if not var_64_0 then
		return nil
	end
	
	return var_64_0.main_db.intro_story_id
end

function SeasonPass.getEndStoryID(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0:getSchedule(arg_65_1)
	
	if not var_65_0 then
		return nil
	end
	
	return var_65_0.main_db.end_story_id
end

function SeasonPass.deleteExpire(arg_66_0, arg_66_1, arg_66_2)
	if not PRODUCTION_MODE and arg_66_2 then
		SAVE:setTempConfigData("epic_pass", nil)
		SAVE:setTempConfigData("substory_pass", nil)
		
		return 
	end
	
	local var_66_0 = arg_66_1 and "epic_pass" or "substory_pass"
	local var_66_1 = arg_66_0:getSchedules()
	local var_66_2 = {}
	
	for iter_66_0, iter_66_1 in pairs(var_66_1) do
		table.insert(var_66_2, iter_66_1.id)
	end
	
	local var_66_3 = Account:getConfigData(var_66_0) or {}
	
	for iter_66_2, iter_66_3 in pairs(var_66_3) do
		if not table.find(var_66_2, iter_66_2) then
			var_66_3[iter_66_2] = nil
		end
	end
	
	SAVE:setTempConfigData(var_66_0, var_66_3)
end

function SeasonPass.load(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_0:isModeEpic(arg_67_1) and "epic_pass" or "substory_pass"
	local var_67_1 = Account:getConfigData(var_67_0) or {}
	
	if not arg_67_1 then
		return var_67_1
	end
	
	local var_67_2 = var_67_1[arg_67_1]
	
	if var_67_2 and arg_67_2 then
		return var_67_2[arg_67_2]
	end
	
	return var_67_2
end

function SeasonPass.save(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	local var_68_0 = arg_68_0:isModeEpic(arg_68_1) and "epic_pass" or "substory_pass"
	local var_68_1 = {
		[arg_68_1] = {}
	}
	
	var_68_1[arg_68_1][arg_68_2] = arg_68_3
	
	SAVE:setTempConfigData(var_68_0, var_68_1)
end

if not PRODUCTION_MODE then
	SeasonPass.shedules = {
		["1"] = {
			end_time = 1577199600,
			start_time = 1559487600,
			max_rank = 30,
			id = "season1",
			main_db = {
				export_id = "iceblingc_190725_19009",
				start_date = 190603,
				start_time = 300,
				buy_type = "all",
				end_date = 191225,
				rankup_price = 100,
				end_time = 300,
				reward_db = "season1_reward",
				id = "season1",
				scene_title = "ui_season_title",
				rank_db = "season1_rank",
				name = "ui_season1_name",
				mode = "season",
				portrait = "portrait=c1076,offset_y= -350,scale_x=0.5, scale_y=0.5",
				face = "0 : 보통",
				complete = "y",
				bg = "img=banner/ss_v3012a_home",
				condition = "rank",
				exp_db = "season1_exp",
				show_exp = "Y",
				buy_reward_rank = 10,
				shop_db = "season1_shop"
			},
			shop_db = {
				season1_common = {
					export_id = "iceblingc_190725_19009",
					name = "ns_season1_common",
					complete = "y",
					type = "sp_season1_common",
					value = 1,
					image = "sp_season1_common",
					imit_count = 1,
					token = "cash",
					shop_type = "common",
					id = "season1_common",
					price = 33000
				},
				season1_upgrade = {
					export_id = "iceblingc_190725_19009",
					name = "ns_season1_upgrade",
					complete = "y",
					type = "sp_season1_upgrade",
					value = 1,
					image = "sp_season1_upgrade",
					imit_count = 1,
					token = "cash",
					shop_type = "upgrade",
					id = "season1_upgrade",
					price = 22000
				},
				season1_high = {
					export_id = "iceblingc_190725_19009",
					name = "ns_season1_high",
					complete = "y",
					type = "sp_season1_high",
					value = 1,
					image = "sp_season1_high",
					imit_count = 1,
					token = "cash",
					shop_type = "high",
					id = "season1_high",
					price = 55000
				}
			},
			rank_db = {
				["1"] = {
					id = 1,
					export_id = "iceblingc_190725_19009",
					accum_exp = 5959,
					complete = "y"
				},
				["3"] = {
					id = 3,
					export_id = "iceblingc_190725_19009",
					accum_exp = 17877,
					complete = "y"
				},
				["2"] = {
					id = 2,
					export_id = "iceblingc_190725_19009",
					accum_exp = 11918,
					complete = "y"
				}
			},
			exp_db = {
				["1"] = {
					export_id = "iceblingc_190725_19009",
					value = "stamina",
					exp = 5,
					type = "tokentype",
					id = 1
				},
				["2"] = {
					export_id = "iceblingc_190725_19009",
					value = "pvpkey",
					exp = 60,
					type = "tokentype",
					id = 2
				},
				["3"] = {
					export_id = "iceblingc_190725_19009",
					value = "mazekey",
					exp = 480,
					type = "tokentype",
					id = 3
				}
			},
			reward_db = {
				bonus = {
					export_id = "iceblingc_190725_19009",
					common_rank_reward1_id = "c1006",
					rank = 30,
					common_rank_reward1_count = 1,
					id = "bonus",
					complete = "y"
				},
				complete = {
					export_id = "iceblingc_190725_19009",
					common_rank_reward1_id = "ma_border9",
					free_rank_reward_count = 10,
					common_rank_reward1_count = 1,
					complete = "y",
					common_rank_reward2_count = 3,
					common_rank_reward2_id = "to_hero2",
					rank = 30,
					free_rank_reward_id = "to_ticketrare",
					id = "complete"
				},
				["1"] = {
					export_id = "iceblingc_190725_19009",
					common_rank_reward1_id = "ma_moragora1",
					rank = 1,
					complete = "y",
					id = 1,
					free_rank_reward_count = 3,
					free_rank_reward_id = "to_light",
					common_rank_reward1_count = 1
				},
				["3"] = {
					export_id = "iceblingc_190725_19009",
					common_rank_reward1_id = "est6w",
					rank = 3,
					complete = "y",
					id = 3,
					grade_rate2 = "grade5",
					common_rank_reward1_count = 2
				},
				["2"] = {
					export_id = "iceblingc_190725_19009",
					free_rank_reward_id = "to_dungeonkey",
					rank = 2,
					complete = "y",
					id = 2,
					free_rank_reward_count = 100
				}
			}
		}
	}
end
