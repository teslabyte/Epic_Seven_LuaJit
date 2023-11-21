function MsgHandler.coop_battle_sync(arg_1_0)
	if not CoopUtil:isValidRtn(arg_1_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		Battle:responseExpedition(arg_1_0)
		Battle:updateExpeditionSyncDirty()
	else
		CoopMission:responseExpedition(arg_1_0)
	end
end

function Battle.updateExpeditionSyncDirty(arg_2_0)
	arg_2_0.vars.expedition_sync_wait = nil
	arg_2_0.vars.last_expedition_sync_tm = os.time()
end

function Battle.updateExpedition(arg_3_0)
	local var_3_0 = os.time()
	local var_3_1 = var_3_0 - (arg_3_0.vars.last_expedition_sync_tm or var_3_0)
	local var_3_2 = arg_3_0:getExpeditionSyncTime()
	
	if arg_3_0.vars.pointless_sync_tm then
		local var_3_3 = var_3_0 - arg_3_0.vars.pointless_sync_tm
		
		if var_3_3 >= 600 then
			if arg_3_0:isPlayingBattleAction() then
				return 
			end
			
			if not arg_3_0.logic:isEnded() then
				arg_3_0:doEndBattle({
					fatal_stop = true,
					resume = true,
					giveup = true
				})
			end
		elseif var_3_3 >= 90 then
			var_3_2 = var_3_2 * 10
		elseif var_3_3 >= 30 then
			var_3_2 = var_3_2 * 3
		elseif var_3_3 >= 10 then
			var_3_2 = var_3_2 * 1.5
		end
	end
	
	if not arg_3_0.vars.expedition_sync_wait and (not arg_3_0.vars.last_expedition_sync_tm or var_3_2 <= var_3_1) then
		arg_3_0:requestExpedition()
	end
end

function Battle.requestExpedition(arg_4_0)
	local var_4_0 = arg_4_0.logic:getExpeditionInfo()
	local var_4_1, var_4_2 = arg_4_0.logic:getExpeditionBoss()
	
	if not var_4_1 then
		return 
	end
	
	local var_4_3 = arg_4_0.logic:getExpeditionScore()
	local var_4_4 = {
		boss_id = var_4_0.boss_id,
		battle_id = var_4_0.battle_id,
		accum_damage = var_4_3,
		boss_info = json.encode(var_4_1),
		map = arg_4_0.logic.map.enter,
		battle_uid = arg_4_0.logic:getBattleUID(),
		convic = array_to_json(g_UNIT_CONVIC),
		ur_rate = arg_4_0.logic:getMaxDamage(),
		ssr_rate = arg_4_0.logic:getRateSSR()
	}
	
	if to_n(var_4_3) > 0 then
		arg_4_0.vars.pointless_sync_tm = nil
	elseif not arg_4_0.vars.pointless_sync_tm then
		arg_4_0.vars.pointless_sync_tm = os.time()
	end
	
	g_UNIT_CONVIC = {}
	
	arg_4_0.logic:deliveredExpeditionScore()
	
	arg_4_0.vars.expedition_sync_wait = os.time()
	
	if arg_4_0.logic:isLotaContents() then
		query("lota_battle_sync", var_4_4)
	else
		query("coop_battle_sync", var_4_4)
	end
	
	return true
end

function Battle.responseExpedition(arg_5_0, arg_5_1)
	arg_5_0.logic:clearRateSSR()
	arg_5_0.logic:clearMaxDamage()
	arg_5_0.logic:clearExpeditionScore()
	
	if arg_5_1.user_info or arg_5_1.expedition_users then
		arg_5_0:updateExpeditionUserList(arg_5_1.user_info or arg_5_1.expedition_users)
	end
	
	if arg_5_1.expedition_info then
		arg_5_0.logic:updateExpeditionInfo(arg_5_1.expedition_info)
	end
	
	if arg_5_1.expired then
		arg_5_0:doEndBattle({
			fatal_stop = true,
			resume = true
		})
	end
end

function Battle.updateExpeditionUserList(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return 
	end
	
	if not arg_6_0.vars then
		return 
	end
	
	arg_6_0.vars.expedition_users = arg_6_1
end

function Battle.getExpeditionUserList(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	return arg_7_0.vars.expedition_users
end

function Battle.setExpeditionSyncTime(arg_8_0, arg_8_1)
	arg_8_0.vars.expedition_sync_time = math.max(arg_8_1 or 3, 3)
end

function Battle.getExpeditionSyncTime(arg_9_0)
	return arg_9_0.vars.expedition_sync_time or 3
end
