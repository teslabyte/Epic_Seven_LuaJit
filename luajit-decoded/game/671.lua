LotaEventSystem = {}

function LotaEventSystem.onResponseEventData(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.event_complete = false
	arg_1_0.vars.tile_id = arg_1_1
	arg_1_0.vars.res_event_id = arg_1_2
	arg_1_0.vars.event_data = SLOW_DB_ALL("clan_heritage_event_data", arg_1_0.vars.res_event_id)
	
	if not arg_1_0.vars.event_data then
		error("CLAN HERITAGE EVENT LOAD FAILED. CHECK EVENT ID : " .. tostring(arg_1_0.vars.res_event_id))
	end
	
	local var_1_0 = arg_1_0.vars.event_data.select_group
	
	arg_1_0.vars.event_list = {}
	
	for iter_1_0 = 1, 3 do
		local var_1_1 = var_1_0 .. string.format("_%02d", iter_1_0)
		
		if DB("clan_heritage_event_select", var_1_1, "id") ~= nil then
			arg_1_0.vars.event_list[iter_1_0] = var_1_1
		end
	end
	
	SoundEngine:play("event:/effect/anc_eff_event")
	start_new_story(nil, arg_1_0.vars.event_data.event_story, {
		is_lota_event = true,
		on_clear = function()
			if arg_1_0.vars.select_battle_event then
				return 
			end
			
			local var_2_0 = arg_1_0:makeEventResultPopup()
			
			local function var_2_1()
				if arg_1_0.vars.result_response and arg_1_0.vars.result_response.exp then
					arg_1_0.vars.event_complete = true
					
					LotaSystem:requestAutoHandlingEffects()
				end
			end
			
			if var_2_0 then
				Dialog:msgBox(nil, {
					dlg = var_2_0,
					handler = var_2_1
				})
			end
		end,
		layer = LotaSystem:getUIPopupLayer()
	})
end

function LotaEventSystem.isEventCompleted(arg_4_0)
	return arg_4_0.vars.event_complete
end

function LotaEventSystem.selectBattleEvent(arg_5_0)
	arg_5_0.vars.select_battle_event = true
end

function LotaEventSystem.setupResultReward(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = {}
	
	if arg_6_3.job_levels then
		table.insert(var_6_0, {
			item = {
				code = arg_6_5.event_reward_icon
			}
		})
	end
	
	if arg_6_4.rewards and not table.empty(arg_6_4.rewards) then
		for iter_6_0, iter_6_1 in pairs(arg_6_4.rewards) do
			table.insert(var_6_0, iter_6_1)
		end
	end
	
	if not table.empty(var_6_0) then
		local var_6_1 = arg_6_1:findChildByName("n_result_item")
		
		if_set_visible(var_6_1, nil, true)
		
		local var_6_2 = table.count(var_6_0)
		local var_6_3 = "odd"
		
		if var_6_2 % 2 == 0 then
			var_6_3 = "even"
		end
		
		for iter_6_2, iter_6_3 in pairs(var_6_0) do
			local var_6_4 = iter_6_2
			local var_6_5 = var_6_1:findChildByName("reward_item" .. var_6_4 .. "_" .. var_6_3)
			
			if get_cocos_refid(var_6_5) then
				local var_6_6 = {
					show_small_count = true,
					no_remove_prev_icon = true,
					touch_block = true,
					no_detail_popup = true,
					parent = var_6_5,
					equip = iter_6_3.equip
				}
				local var_6_7 = iter_6_3.count
				local var_6_8 = iter_6_3.token
				local var_6_9 = Account:getCurrencyCodes()
				
				if table.find(var_6_9, iter_6_3.token) then
					var_6_8 = "to_" .. iter_6_3.token
				end
				
				if iter_6_3.equip then
					var_6_7 = "equip"
					var_6_8 = iter_6_3.equip.code
				end
				
				if iter_6_3.unit then
					var_6_7 = "c"
					var_6_8 = iter_6_3.unit.db.code
					var_6_6.lv = iter_6_3.unit:getLv()
					var_6_6.hide_lv = iter_6_3.unit:getType() == "xpup" or iter_6_3.unit:getType() == "devotion"
				end
				
				if iter_6_3.item then
					var_6_8 = iter_6_3.item.code
					var_6_7 = iter_6_3.item.diff
				end
				
				if iter_6_3.account_skill then
					var_6_8 = iter_6_3.account_skill
				end
				
				if iter_6_3.lota_arti_bonus then
					var_6_6.lota_arti_bonus = iter_6_3.lota_arti_bonus
				end
				
				local var_6_10 = UIUtil:getRewardIcon(var_6_7, var_6_8, var_6_6)
				
				if_set_visible(var_6_5, nil, true)
			else
				Log.e("NOT FIND : " .. "reward_item" .. var_6_4 .. "_" .. var_6_3)
			end
		end
		
		var_6_1:setPosition(arg_6_2:getPosition())
	end
end

function LotaEventSystem.setupResultPenalty(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_3.goddess then
		local var_7_0 = arg_7_1:findChildByName("n_result_blessing")
		
		if_set_visible(var_7_0, nil, true)
		if_set(var_7_0, "txt_desc_blessing", T("ui_clan_heritage_event_lucky"))
		var_7_0:setPosition(arg_7_2:getPosition())
	elseif arg_7_3.hero_disable_count then
		local var_7_1 = arg_7_3.hero_disable_count
		local var_7_2 = arg_7_1:findChildByName("n_result_hero")
		
		if_set_visible(var_7_2, nil, true)
		
		if var_7_1.data and type(var_7_1.data) == "table" then
			local var_7_3 = table.count(var_7_1.data)
			local var_7_4 = "odd"
			
			if var_7_3 % 2 == 0 then
				var_7_4 = "even"
			end
			
			for iter_7_0 = 1, var_7_3 do
				local var_7_5 = var_7_1.data[iter_7_0]
				local var_7_6 = Account:getUnit(tonumber(var_7_5))
				
				if not var_7_6 then
					Log.e("CHK UID : " .. var_7_5 .. " type " .. type(var_7_5))
				end
				
				local var_7_7 = UIUtil:getRewardIcon(nil, var_7_6.db.code, {
					no_popup = true,
					zodiac = 6,
					role = true,
					no_db_grade = true,
					grade = 6,
					lv = 60
				})
				
				if_set_visible(var_7_7, "n_state_mask", true)
				
				local var_7_8 = var_7_2:findChildByName("n_hero" .. iter_7_0 .. "_" .. var_7_4)
				
				var_7_8:addChild(var_7_7)
				if_set_visible(var_7_8, nil, true)
			end
			
			if_set(var_7_2, "txt_desc_hero", T("ui_clan_heritage_event_hero_cant_use"))
		else
			if_set(var_7_2, "txt_desc_hero", T("ui_clan_heritage_event_no_hero_penalty"))
		end
		
		var_7_2:setPosition(arg_7_2:getPosition())
	elseif arg_7_3.add_consumption_token then
		local var_7_9 = arg_7_3.add_consumption_token
		local var_7_10 = arg_7_1:findChildByName("n_result_token")
		local var_7_11 = var_7_10:findChildByName("n_token")
		
		if_set_visible(var_7_10, nil, true)
		
		local var_7_12 = UIUtil:getRewardIcon(var_7_9.data, "to_clanheritage", {
			parent = var_7_11
		})
		
		if_set(var_7_12, "txt_small_count", "-" .. tostring(var_7_9.data))
		if_set(var_7_10, "txt_desc_token", T("ui_clan_heritage_event_add_consumption"))
		var_7_10:setPosition(arg_7_2:getPosition())
	elseif arg_7_3.decrease_role_level or arg_7_3.decrease_random_role_level then
		local var_7_13 = arg_7_3.decrease_role_level or arg_7_3.decrease_random_role_level
		local var_7_14 = arg_7_1:findChildByName("n_result_etc")
		
		if_set_visible(var_7_14, nil, true)
		
		if var_7_13.role then
			local var_7_15 = arg_7_0:getPenaltyIconForDecreaseRoleLvByRole(var_7_13.role)
			
			if get_cocos_refid(var_7_15) then
				var_7_14:findChildByName("n_etc_icon"):addChild(var_7_15)
			else
				Log.e("REPORT. ICON NOT EXIST ", var_7_13.role)
			end
		end
		
		if var_7_13.data ~= "not_changed" then
			if_set(var_7_14, "txt_desc_etc", T("ui_clan_heritage_event_decrease_role_level", {
				role = T(CollectionUtil.ROLE_COMP_TO_KEY_DATA_STRING[var_7_13.role]),
				value = var_7_13.diff
			}))
		else
			if_set(var_7_14, "txt_desc_etc", T("ui_clan_heritage_event_not_decrease", {
				role = T(CollectionUtil.ROLE_COMP_TO_KEY_DATA_STRING[var_7_13.role])
			}))
		end
		
		var_7_14:setPosition(arg_7_2:getPosition())
	end
end

function LotaEventSystem.makeEventResultPopup(arg_8_0)
	if arg_8_0.vars.select_event_id == "close" then
		return 
	end
	
	local var_8_0 = SLOW_DB_ALL("clan_heritage_event_select", arg_8_0.vars.select_event_id)
	local var_8_1 = LotaUtil:getEventPenaltyInfo(var_8_0, arg_8_0.vars.current, arg_8_0.vars.result_response)
	local var_8_2 = var_8_1 ~= nil
	local var_8_3 = LotaUtil:getEventRewardInfo(arg_8_0.vars.rewards, arg_8_0.vars.current, arg_8_0.vars.result_response)
	local var_8_4 = var_8_3 ~= nil
	local var_8_5 = 0
	
	if var_8_2 then
		var_8_5 = var_8_5 + 1
	end
	
	if var_8_4 then
		var_8_5 = var_8_5 + 1
	end
	
	if var_8_5 == 0 then
		Log.e("DATA NOT EXIST!")
		
		return 
	end
	
	local var_8_6 = arg_8_0.vars.reward_dlg_opts or {}
	local var_8_7 = load_dlg("clan_heritage_event_result", true, "wnd")
	
	if var_8_5 == 1 then
		local var_8_8 = var_8_7:findChildByName("n_result_1_1")
		
		if var_8_2 then
			arg_8_0:setupResultPenalty(var_8_7, var_8_8, var_8_1, var_8_0)
		else
			arg_8_0:setupResultReward(var_8_7, var_8_8, var_8_3, var_8_6, var_8_0)
		end
	else
		local var_8_9 = var_8_7:findChildByName("n_result_1_2")
		local var_8_10 = var_8_7:findChildByName("n_result_2_2")
		
		arg_8_0:setupResultPenalty(var_8_7, var_8_9, var_8_1, var_8_0)
		arg_8_0:setupResultReward(var_8_7, var_8_10, var_8_3, var_8_6, var_8_0)
	end
	
	if_set_visible(var_8_7, "window_frame_1", var_8_5 == 1)
	if_set_visible(var_8_7, "window_frame_2", var_8_5 == 2)
	if_set_arrow(var_8_7:getChildByName("window_frame_" .. var_8_5))
	
	return var_8_7
end

function LotaEventSystem.getTileId(arg_9_0)
	return arg_9_0.vars.tile_id
end

function LotaEventSystem.onResponseEventResultData(arg_10_0, arg_10_1)
	if arg_10_1.close then
		STORY.cut_opts.select_wait = nil
		
		step_next({
			force = true
		})
		
		return 
	end
	
	arg_10_0.vars.rewards_response = arg_10_1.rewards or {}
	arg_10_0.vars.event_status = arg_10_1.event
	
	if arg_10_1.user_registration_data then
		LotaUserData:updateRegistration(arg_10_1.user_registration_data)
	end
	
	arg_10_0.vars.reward_dlg_opts, arg_10_0.vars.popup_data = LotaUtil:makeMsgRewardsParam(arg_10_1, T("WIP-TEXT EVENT 결과에요"), T("WIP-TEXT 이건 본문이고요"))
	arg_10_0.vars.rewards = arg_10_1.rewards
	arg_10_0.vars.result_response = arg_10_1
	
	LotaUserData:updateExp(arg_10_1.exp, true)
	
	local var_10_0 = DB("clan_heritage_event_select", arg_10_0.vars.select_event_id, "event_story_after")
	
	if not var_10_0 then
		print(" WIP WIP WIP WHAT THE HACK!? ", arg_10_0.vars.select_event_id, "STORY LOAD FAILED! ")
		
		return 
	end
	
	if table.empty(STORY.story[#STORY.story]) then
		table.pop(STORY.story)
	end
	
	local var_10_1 = load_story(var_10_0)
	
	if var_10_1 then
		table.add(STORY.story, var_10_1)
	end
	
	LotaEventSelectUI:close()
end

function LotaEventSystem.sendQuery(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.vars.select_event_id = arg_11_2 or "close"
	arg_11_0.vars.current = {}
	arg_11_0.vars.current.job_levels = table.clone(LotaUserData:getJobLevels())
	arg_11_0.vars.current.exp = LotaUserData:getExp()
	arg_11_0.vars.current.user_registration_data = table.clone(LotaUserData:getRegistration())
	arg_11_0.vars.current.action_point = LotaUserData:getActionPoint()
	
	LotaNetworkSystem:sendQuery("lota_event_select", {
		tile_id = arg_11_1,
		select_id = arg_11_2
	})
end

function LotaEventSystem.stringToHashData(arg_12_0, arg_12_1)
	if not string.find(arg_12_1, ",") and not string.find(arg_12_1, "=") then
		return arg_12_1
	end
	
	local var_12_0 = string.split(arg_12_1, ",")
	local var_12_1 = {}
	
	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		local var_12_2 = string.split(iter_12_1, "=")
		
		var_12_1[var_12_2[1]] = var_12_2[2]
	end
	
	return var_12_1
end

function LotaEventSystem.isExistEvent(arg_13_0, arg_13_1)
	return arg_13_0.vars.event_list[to_n(arg_13_1)] ~= nil
end

function LotaEventSystem.getEventData(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.event_list[to_n(arg_14_1)]
	local var_14_1 = SLOW_DB_ALL("clan_heritage_event_select", var_14_0)
	
	if var_14_1.req_value then
		var_14_1.req_value = arg_14_0:stringToHashData(var_14_1.req_value)
	end
	
	if var_14_1.penalty_value then
		var_14_1.penalty_value = arg_14_0:stringToHashData(var_14_1.penalty_value)
	end
	
	if var_14_1.event_reward_value then
		var_14_1.event_reward_value = arg_14_0:stringToHashData(var_14_1.event_reward_value)
	end
	
	return var_14_1
end

function LotaEventSystem.checkExploreLevelCount(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1.req_value.count
	
	if not var_15_0 then
		if arg_15_2 then
			error(" CONDITION EXIST, BUT NOT EXIST VALID VALUE IN REQ_VALUE COLUMN. CHK." .. arg_15_1.id)
		end
		
		return true
	end
	
	return LotaUserData:getUserLevel() >= to_n(var_15_0)
end

function LotaEventSystem.checkRoleLevelCount(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.req_value.role
	local var_16_1 = arg_16_1.req_value.count
	
	if not var_16_0 or not var_16_1 then
		if arg_16_2 then
			error(" CONDITION EXIST, BUT NOT EXIST VALID VALUE IN REQ_VALUE COLUMN. CHK." .. arg_16_1.id)
		end
		
		return true
	end
	
	return LotaUserData:getRoleLevelByRole(var_16_0) >= to_n(var_16_1)
end

function LotaEventSystem.isEventTokenEnough(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.need_token
	
	return LotaUserData:getActionPoint() >= to_n(var_17_0)
end

function LotaEventSystem.isEventConditionAvailable(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.req_condition
	
	if var_18_0 then
		if var_18_0 == "explore_level_count" then
			return arg_18_0:checkExploreLevelCount(arg_18_1, true)
		elseif var_18_0 == "role_level_count" then
			return arg_18_0:checkRoleLevelCount(arg_18_1, true)
		end
	end
	
	return true
end

function LotaEventSystem.isEventBattleAvailable(arg_19_0, arg_19_1)
	if arg_19_1.penalty_type ~= "battle" then
		return true
	end
	
	local var_19_0 = LotaUserData:getUsableUIDList()
	
	return table.count(var_19_0) > 0
end

function LotaEventSystem.isEventAddConsumptionAvailable(arg_20_0, arg_20_1)
	if arg_20_1.penalty_condition ~= "add_consumption_token" then
		return true
	end
	
	local var_20_0 = to_n(arg_20_1.need_token)
	local var_20_1 = to_n(arg_20_1.penalty_value.value)
	
	return LotaUserData:getActionPoint() >= var_20_0 + var_20_1
end

function LotaEventSystem.isEventAvailableGetReward(arg_21_0, arg_21_1)
	if arg_21_1.event_reward_type ~= "job_level_up" then
		return true
	end
	
	local var_21_0 = arg_21_1.event_reward_value.role
	local var_21_1 = to_n(arg_21_1.event_reward_value.count)
	local var_21_2 = LotaUserData:getRoleLevelWithoutArtifactByRole(var_21_0)
	
	return LotaUserData:getMaxRoleLevel() >= var_21_2 + var_21_1
end

function LotaEventSystem.isEventAvailable(arg_22_0, arg_22_1)
	return arg_22_0:isEventTokenEnough(arg_22_1) and arg_22_0:isEventConditionAvailable(arg_22_1) and arg_22_0:isEventBattleAvailable(arg_22_1) and arg_22_0:isEventAddConsumptionAvailable(arg_22_1) and arg_22_0:isEventAvailableGetReward(arg_22_1)
end

function LotaEventSystem.getPenaltyIconForBattle(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.penalty_value
	
	return UIUtil:getRewardIcon(nil, var_23_0), "mob_icon"
end

function LotaEventSystem.getPenaltyIconForHeroDisable(arg_24_0, arg_24_1)
	return SpriteCache:getSprite("img/icon_menu_dead.png"), "n_etc_icon"
end

function LotaEventSystem.getPenaltyIconForAddConsumption(arg_25_0, arg_25_1)
	local var_25_0 = "to_clanheritage"
	local var_25_1 = DB("item_token", var_25_0, "icon")
	
	return SpriteCache:getSprite("item/" .. var_25_1 .. ".png"), "n_token"
end

function LotaEventSystem.getPenaltyIconForDecreaseRoleLvByRole(arg_26_0, arg_26_1)
	local var_26_0 = ({
		manauser = "icon_menu_rolemanauser_down",
		knight = "icon_menu_roleknight_down",
		assassin = "icon_menu_roleassassin_down",
		warrior = "icon_menu_rolewarrior_down",
		ranger = "icon_menu_roleranger_down",
		mage = "icon_menu_rolemage_down"
	})[arg_26_1]
	
	if not var_26_0 then
		return 
	end
	
	return SpriteCache:getSprite("img/" .. var_26_0 .. ".png"), "n_etc_icon"
end

function LotaEventSystem.getPenaltyIconForDecreaseRoleLv(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.penalty_value
	
	return arg_27_0:getPenaltyIconForDecreaseRoleLvByRole(var_27_0.role)
end

function LotaEventSystem.getPenaltyIconForDecreaseRandomRoleLv(arg_28_0, arg_28_1)
	return SpriteCache:getSprite("img/icon_menu_hero_weak.png"), "n_etc_icon"
end

function LotaEventSystem.isPenaltyExist(arg_29_0, arg_29_1)
	return arg_29_1.penalty_type ~= "none"
end

function LotaEventSystem.getPenaltyIcon(arg_30_0, arg_30_1)
	local var_30_0 = ({
		battle_clan_object = arg_30_0.getPenaltyIconForBattle,
		hero_disable_count = arg_30_0.getPenaltyIconForHeroDisable,
		add_consumption_token = arg_30_0.getPenaltyIconForAddConsumption,
		decrease_role_level = arg_30_0.getPenaltyIconForDecreaseRoleLevel,
		decrease_random_role_level = arg_30_0.getPenaltyIconForDecreaseRandomRoleLv
	})[arg_30_1.penalty_condition]
	
	if not var_30_0 then
		return 
	end
	
	return var_30_0(arg_30_0, arg_30_1)
end

function LotaEventSystem.getEventReward(arg_31_0, arg_31_1)
	local var_31_0 = LotaUtil:getRewardData(arg_31_1.reward_id)
	
	if arg_31_1.event_reward_icon then
		table.insert(var_31_0, {
			item_id = arg_31_1.event_reward_icon
		})
	end
	
	return var_31_0
end
