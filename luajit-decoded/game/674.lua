LotaUserData = {}
LotaUserDataInfoInterface = {
	season_id = "",
	last_recharge_ap_tm = 0,
	req_start_point_setting = true,
	explore_exp = 0,
	floor_reward_step = 0,
	start_legacy_refresh_count = 0,
	max_action_point = 0,
	unregister_count = 0,
	user_floor = 1,
	action_point = 0,
	artifact_items = {},
	artifact_select_pool = {},
	user_registration_data = {},
	user_unregister_data = {},
	job_levels = {}
}

function LotaUserData.documentToInterface(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = table.clone(LotaUserDataInfoInterface)
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		var_1_0[iter_1_0] = iter_1_1
	end
	
	local var_1_1 = {}
	local var_1_2 = arg_1_2.artifact_items or {}
	
	for iter_1_2 = 1, 6 do
		local var_1_3 = var_1_2[tostring(iter_1_2)]
		
		if var_1_3 then
			table.insert(var_1_1, var_1_3)
		end
	end
	
	var_1_0.artifact_items = var_1_1
	var_1_0.artifact_select_pool = arg_1_2.artifact_select_pool
	
	if arg_1_3 then
		var_1_0.user_registration_data = arg_1_3.user_registration_data or {}
		var_1_0.user_unregister_data = arg_1_3.user_unregister_data or {}
		var_1_0.unregister_count = to_n(arg_1_3.unregister_count)
	end
	
	return var_1_0
end

function LotaUserData.init(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.info = {}
	arg_2_0.vars.artifact_items = {}
	arg_2_0.vars.artifact_select_pool = {}
	
	if arg_2_1 then
		arg_2_0:setInfo(arg_2_1)
	end
end

function LotaUserData.setInfo(arg_3_0, arg_3_1)
	arg_3_0.vars.info = arg_3_1
	arg_3_0.vars.artifact_items = arg_3_0:createLegacyDataByInfo(arg_3_0.vars.info.artifact_items)
	
	local var_3_0 = {}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.info.artifact_select_pool or {}) do
		table.insert(var_3_0, {
			id = iter_3_1
		})
	end
	
	arg_3_0.vars.artifact_select_pool = arg_3_0:createLegacyDataByInfo(var_3_0)
	
	arg_3_0:generateRegistrationCodeMap()
	arg_3_0:generateRegistrationGroupMap()
end

function LotaUserData.isActive(arg_4_0)
	return arg_4_0.vars ~= nil
end

function LotaUserData.createLegacyDataByInfo(arg_5_0, arg_5_1)
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		local var_5_1 = LotaLegacyData:create(iter_5_1.id, {
			use_count = iter_5_1.use_count
		})
		
		table.insert(var_5_0, var_5_1)
	end
	
	return var_5_0
end

function LotaUserData.updateSelectArtifacts(arg_6_0, arg_6_1)
	if not table.empty(arg_6_0.vars.info.artifact_select_pool) then
		error("NOT SELECT ARTIFACTS(REMAIN!), BUT ACCESS UPDATE SELECT ARTIFACTS. PLEASE CLEAR BEFORE UPDATE")
		
		return 
	end
	
	local var_6_0 = {}
	
	for iter_6_0 = 1, 6 do
		local var_6_1 = arg_6_1[tostring(iter_6_0)]
		
		if var_6_1 then
			table.insert(var_6_0, var_6_1)
		end
	end
	
	arg_6_0.vars.info.artifact_select_pool = var_6_0
	
	local var_6_2 = {}
	
	for iter_6_1, iter_6_2 in pairs(arg_6_1) do
		var_6_2[iter_6_1] = {
			id = iter_6_2
		}
	end
	
	arg_6_0.vars.artifact_select_pool = arg_6_0:createLegacyDataByInfo(var_6_2)
end

function LotaUserData.updateStartLegacyRefreshCount(arg_7_0, arg_7_1)
	arg_7_0.vars.info.start_legacy_refresh_count = arg_7_1
end

function LotaUserData.useArtifactEffects(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		for iter_8_2, iter_8_3 in pairs(arg_8_0.vars.artifact_items) do
			if iter_8_3:getSkillEffect() == iter_8_0 and iter_8_3:getSkillEffect() ~= "start_add_token" then
				iter_8_3:addUseCount()
			end
		end
	end
end

function LotaUserData.updateFloorKey(arg_9_0, arg_9_1)
	arg_9_0.vars.info.user_floor = arg_9_1
end

function LotaUserData.getRankingRewardToken(arg_10_0)
	return "to_crystal", DB("clan_heritage_config", "rankingboard_crystal", "client_value")
end

function LotaUserData.getLastRewardFloor(arg_11_0)
	return tonumber(arg_11_0.vars.info.floor_reward_step)
end

function LotaUserData.responseLastRewardFloor(arg_12_0, arg_12_1)
	arg_12_0.vars.info.floor_reward_step = arg_12_1
end

function LotaUserData.getFloorKey(arg_13_0)
	return tostring(arg_13_0.vars.info.user_floor)
end

function LotaUserData.getFloor(arg_14_0)
	if not arg_14_0.vars or not arg_14_0.vars.info or not arg_14_0.vars.info.user_floor then
		return 0
	end
	
	return tonumber(arg_14_0.vars.info.user_floor)
end

function LotaUserData.getJobLevels(arg_15_0)
	return arg_15_0.vars.info.job_levels
end

function LotaUserData.getRolePointDiffValue(arg_16_0)
	if not arg_16_0.vars then
		return 0
	end
	
	return arg_16_0.vars.diff_mat_value or 0
end

function LotaUserData.clearRolePointDiffValue(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	arg_17_0.vars.diff_mat_value = nil
end

function LotaUserData.getEnhanceMaterialCount(arg_18_0)
	local var_18_0 = arg_18_0:getJobLevels()
	
	if not var_18_0 then
		return nil
	end
	
	return var_18_0.mat or 0
end

function LotaUserData.isRequireSelectArtifacts(arg_19_0)
	return table.count(arg_19_0.vars.info.artifact_select_pool or {}) > 0
end

function LotaUserData.clearSelectArtifacts(arg_20_0)
	arg_20_0.vars.info.artifact_select_pool = {}
	arg_20_0.vars.artifact_select_pool = {}
end

function LotaUserData.confirmArtifactSelect(arg_21_0, arg_21_1)
	arg_21_0:clearSelectArtifacts()
	
	arg_21_0.vars.artifact_items = {}
	
	local var_21_0 = {}
	
	for iter_21_0 = 1, 6 do
		local var_21_1 = arg_21_1[tostring(iter_21_0)]
		
		if var_21_1 then
			table.insert(var_21_0, var_21_1)
		end
	end
	
	arg_21_0.vars.info.artifact_items = var_21_0
	arg_21_0.vars.artifact_items = arg_21_0:createLegacyDataByInfo(arg_21_0.vars.info.artifact_items)
end

function LotaUserData.getLegacyInventoryMax(arg_22_0)
	return LotaUtil:getLegacyInventoryMax(arg_22_0.vars.info.explore_exp)
end

function LotaUserData.getMaxHeroCount(arg_23_0)
	return LotaUtil:getMaxHeroCount(arg_23_0.vars.info.explore_exp)
end

function LotaUserData.getUnregisterCount(arg_24_0)
	return arg_24_0.vars.info.unregister_count
end

function LotaUserData.getStartLegacyRefreshCount(arg_25_0)
	return arg_25_0.vars.info.start_legacy_refresh_count or 0
end

function LotaUserData.getLimitFreeUnRegistrationCount(arg_26_0)
	return DB("clan_heritage_config", "free_unregist_hero", "client_value")
end

function LotaUserData.getUnregisterCostToken(arg_27_0)
	return DB("clan_heritage_config", "pay_unregist_token", "client_value")
end

function LotaUserData.getUnregisterCost(arg_28_0)
	return DB("clan_heritage_config", "pay_unregist_value", "client_value")
end

function LotaUserData.getEffectArtifactRoleLevel(arg_29_0, arg_29_1)
	local var_29_0 = {
		manauser = "enhance_manauser_role_level",
		knight = "enhance_knight_role_level",
		assassin = "enhance_assassin_role_level",
		warrior = "enhance_warrior_role_level",
		ranger = "enhance_ranger_role_level",
		mage = "enhance_mage_role_level"
	}
	local var_29_1 = arg_29_0:getArtifacts()
	local var_29_2 = 0
	
	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		local var_29_3 = iter_29_1:getSkillEffect()
		
		if var_29_3 == var_29_0[arg_29_1] or var_29_3 == "enhance_all_role_level" then
			var_29_2 = var_29_2 + iter_29_1:getSkillValue()
		end
	end
	
	return var_29_2
end

function LotaUserData.getRoleLevelByRole(arg_30_0, arg_30_1)
	return (arg_30_0:getJobLevels()[arg_30_1] or 1) + arg_30_0:getEffectArtifactRoleLevel(arg_30_1)
end

function LotaUserData.getRoleLevelWithoutArtifactByRole(arg_31_0, arg_31_1)
	return arg_31_0:getJobLevels()[arg_31_1] or 1
end

function LotaUserData.getArtifactInventoryCount(arg_32_0)
	return table.count(arg_32_0.vars.artifact_items)
end

function LotaUserData.isArtifactInventoryFull(arg_33_0)
	return table.count(arg_33_0.vars.artifact_items) >= arg_33_0:getLegacyInventoryMax()
end

function LotaUserData.getArtifactItems(arg_34_0)
	return arg_34_0.vars.artifact_items
end

function LotaUserData.getArtifactItemById(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.vars.artifact_items
	
	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		if iter_35_1:getID() == arg_35_1 then
			return iter_35_1
		end
	end
end

function LotaUserData.getSelectableArtifacts(arg_36_0)
	return arg_36_0.vars.artifact_select_pool
end

function LotaUserData.updateActionPoint(arg_37_0, arg_37_1)
	if not arg_37_0.vars or not arg_37_0.vars.info then
		return 
	end
	
	arg_37_0.vars.info.action_point = arg_37_1
end

function LotaUserData.getRegistrationList(arg_38_0)
	local var_38_0 = {}
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.info.user_registration_data) do
		table.insert(var_38_0, tonumber(iter_38_0))
	end
	
	return var_38_0
end

function LotaUserData.getQuestSummaryKey(arg_39_0)
	local var_39_0 = arg_39_0:getFloorKey()
	local var_39_1 = LotaSystem:getWorldId()
	local var_39_2 = DB("clan_heritage_world", var_39_1, {
		"map_id"
	})
	
	if not var_39_2 then
		return nil
	end
	
	for iter_39_0 = 1, 99 do
		local var_39_3, var_39_4, var_39_5 = DBN("clan_heritage_quest_summary", iter_39_0, {
			"id",
			"map_id",
			"floor"
		})
		
		if not var_39_3 then
			break
		end
		
		if var_39_4 == var_39_2 and tostring(var_39_5) == tostring(var_39_0) then
			return var_39_3
		end
	end
	
	return nil
end

function LotaUserData.getRegistrationListByRole(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0:getRegistrationList()
	local var_40_1 = {}
	
	for iter_40_0, iter_40_1 in pairs(var_40_0) do
		local var_40_2 = Account:getUnit(iter_40_1)
		
		if var_40_2.db.role == arg_40_1 then
			table.insert(var_40_1, var_40_2)
		end
	end
	
	return var_40_1
end

function LotaUserData.onConfirmRegistration(arg_41_0, arg_41_1)
	if arg_41_1 then
		arg_41_0.vars.info.user_registration_data = arg_41_1.user_registration_data or {}
		arg_41_0.vars.info.user_unregister_data = arg_41_1.user_unregister_data or {}
		arg_41_0.vars.info.unregister_count = to_n(arg_41_1.unregister_count)
		
		Account:updateLotaRegistration(arg_41_0.vars.info.user_registration_data)
		arg_41_0:generateRegistrationCodeMap()
		arg_41_0:generateRegistrationGroupMap()
	end
end

function LotaUserData.isExistRegistrationByCode(arg_42_0, arg_42_1)
	if not arg_42_0.vars.user_registration_code_map then
		return 
	end
	
	return arg_42_0.vars.user_registration_code_map[arg_42_1]
end

function LotaUserData.generateRegistrationCodeMap(arg_43_0)
	arg_43_0.vars.user_registration_code_map = {}
	
	for iter_43_0, iter_43_1 in pairs(arg_43_0.vars.info.user_registration_data or {}) do
		local var_43_0 = Account:getUnit(tonumber(iter_43_0))
		
		if var_43_0 then
			arg_43_0.vars.user_registration_code_map[var_43_0.db.code] = true
		end
	end
end

function LotaUserData.isExistRegistrationByGroup(arg_44_0, arg_44_1)
	if not arg_44_0.vars.user_registration_group_map then
		return 
	end
	
	if not arg_44_1 then
		return 
	end
	
	return arg_44_0.vars.user_registration_group_map[arg_44_1]
end

function LotaUserData.generateRegistrationGroupMap(arg_45_0)
	arg_45_0.vars.user_registration_group_map = {}
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.info.user_registration_data or {}) do
		local var_45_0 = Account:getUnit(tonumber(iter_45_0))
		
		if var_45_0 and var_45_0.db.set_group then
			arg_45_0.vars.user_registration_group_map[var_45_0.db.set_group] = true
		end
	end
end

function LotaUserData.updateRegistration(arg_46_0, arg_46_1)
	if not arg_46_0.vars then
		return 
	end
	
	arg_46_0.vars.info.user_registration_data = arg_46_1
	
	Account:updateLotaRegistration(arg_46_1)
	arg_46_0:generateRegistrationCodeMap()
	arg_46_0:generateRegistrationGroupMap()
end

function LotaUserData.updateUnregisterCount(arg_47_0, arg_47_1)
	if not arg_47_0.vars then
		return 
	end
	
	arg_47_0.vars.info.unregister_count = tonumber(arg_47_1)
end

function LotaUserData.getRegistration(arg_48_0)
	return table.clone(arg_48_0.vars.info.user_registration_data)
end

function LotaUserData.updateJobLevels(arg_49_0, arg_49_1)
	if arg_49_1 and arg_49_1.mat then
		local var_49_0 = to_n(arg_49_1.mat)
		local var_49_1 = arg_49_0.vars.info.job_levels
		local var_49_2 = to_n(var_49_1.mat)
		
		arg_49_0.vars.diff_mat_value = var_49_0 - var_49_2
	end
	
	arg_49_0.vars.info.job_levels = arg_49_1
end

function LotaUserData.isRegistration(arg_50_0, arg_50_1)
	if not arg_50_1 or not arg_50_1.getUID then
		return 
	end
	
	return arg_50_0.vars.info.user_registration_data[tostring(arg_50_1:getUID())] ~= nil
end

function LotaUserData.getUsableUIDList(arg_51_0)
	local var_51_0 = {}
	
	for iter_51_0, iter_51_1 in pairs(arg_51_0.vars.info.user_registration_data) do
		if arg_51_0:isUsableUnitByUID(iter_51_0) then
			table.insert(var_51_0, iter_51_0)
		end
	end
	
	return var_51_0
end

function LotaUserData.isUsableUnitByUID(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.vars.info.user_registration_data[tostring(arg_52_1)]
	
	if not var_52_0 then
		return 
	end
	
	if var_52_0 == "not_use" then
		return true
	end
	
	local var_52_1 = Account:serverTimeDayLocalDetail()
	
	return tonumber(var_52_1) > tonumber(var_52_0)
end

function LotaUserData.isUnregisteredCurrentDay(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0.vars.info.user_unregister_data[tostring(arg_53_1)]
	
	if not var_53_0 then
		return false
	end
	
	if var_53_0 == "not_use" then
		return false
	end
	
	local var_53_1 = Account:serverTimeDayLocalDetail()
	
	return tonumber(var_53_1) <= tonumber(var_53_0)
end

function LotaUserData.isUsableUnit(arg_54_0, arg_54_1, arg_54_2)
	if not arg_54_1 or not arg_54_1.getUID then
		return 
	end
	
	if not arg_54_0:isRegistration(arg_54_1) then
		return arg_54_2
	end
	
	return arg_54_0:isUsableUnitByUID(arg_54_1:getUID())
end

function LotaUserData.isUpgradeable(arg_55_0)
	local var_55_0 = arg_55_0:getEnhanceMaterialCount()
	
	for iter_55_0, iter_55_1 in pairs(LotaUtil:getListRoles()) do
		local var_55_1 = LotaUtil:getLevelupRequirePoint(iter_55_1)
		
		if var_55_1 ~= nil and var_55_1 < var_55_0 then
			return true
		end
	end
	
	return false
end

function LotaUserData.setReqStartPointSetting(arg_56_0, arg_56_1)
	arg_56_0.vars.info.req_start_point_setting = arg_56_1
end

function LotaUserData.onConfirmStartPoint(arg_57_0)
	arg_57_0.vars.info.req_start_point_setting = false
end

function LotaUserData.isLevelUpExp(arg_58_0, arg_58_1)
	local var_58_0 = LotaUtil:getUserLevel(tonumber(arg_58_0.vars.info.explore_exp))
	
	return LotaUtil:getUserLevel(tonumber(arg_58_1)) ~= var_58_0
end

function LotaUserData.getBenefitMatPoint(arg_59_0, arg_59_1)
	local var_59_0 = LotaUtil:getUserLevel(tonumber(arg_59_1))
	local var_59_1 = LotaUtil:getBenefitInfo(var_59_0)
	
	if not var_59_1 or not var_59_1.enhance_material then
		return 0
	end
	
	return to_n(var_59_1.enhance_material.count) or 0
end

function LotaUserData.updateExp(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = LotaUtil:getUserLevel(tonumber(arg_60_0.vars.info.explore_exp))
	
	arg_60_0.vars.info.explore_exp = arg_60_1
	
	local var_60_1 = LotaUtil:getUserLevel(tonumber(arg_60_0.vars.info.explore_exp))
	
	if var_60_1 ~= var_60_0 then
		if arg_60_2 then
			arg_60_0.vars.level_gap = var_60_1 - var_60_0
		else
			LotaUserData:procLevelUp(var_60_1 - var_60_0)
		end
		
		return true
	end
	
	return false
end

function LotaUserData.procLevelUp(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_1 or arg_61_0.vars.level_gap
	
	if var_61_0 then
		local var_61_1 = LotaMovableSystem:getPlayerMovable()
		
		LotaMovableRenderer:addLevelUpEffect(var_61_1, var_61_0)
		var_61_1:updateExp(arg_61_0.vars.info.explore_exp)
		LotaMovableRenderer:updateMovableExp(var_61_1)
	end
	
	arg_61_0.vars.level_gap = nil
end

function LotaUserData.getMaxRoleLevel(arg_62_0)
	return 15
end

function LotaUserData.getUserLevel(arg_63_0)
	return LotaUtil:getUserLevel(tonumber(arg_63_0.vars.info.explore_exp))
end

function LotaUserData.openUserLevelUpPopup(arg_64_0, arg_64_1)
	arg_64_1 = arg_64_1 or 1
	
	local var_64_0 = LotaUtil:getUserLevel(tonumber(arg_64_0.vars.info.explore_exp)) - (arg_64_1 - 1)
	
	LotaUtil:openUserLevelUpPopup(var_64_0, tonumber(arg_64_0.vars.info.explore_exp))
end

function LotaUserData.getActionPoint(arg_65_0)
	return arg_65_0.vars.info.action_point
end

function LotaUserData.getMaxActionPoint(arg_66_0)
	local var_66_0 = LotaUtil:getUserLevel(tonumber(arg_66_0.vars.info.explore_exp))
	
	return tonumber(DB("clan_heritage_rank_data", tostring(var_66_0), "max_charge_token"))
end

function LotaUserData.getConfigMaxActionPoint(arg_67_0)
	return DB("clan_heritage_config", "max_token_stack", "client_value")
end

function LotaUserData.getExp(arg_68_0)
	return tonumber(arg_68_0.vars.info.explore_exp)
end

function LotaUserData.isRequireSettingStartPoint(arg_69_0)
	return arg_69_0.vars.info.req_start_point_setting
end

function LotaUserData.getArtifacts(arg_70_0)
	return arg_70_0.vars.artifact_items
end

function LotaUserData.getCurrentSeasonDB(arg_71_0, arg_71_1)
	if not arg_71_1 then
		return 
	end
	
	return SLOW_DB_ALL("clan_heritage_season", arg_71_1.id)
end
