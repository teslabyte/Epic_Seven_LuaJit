BOOSTERSKILL_EFFECT_TYPE = {
	UNDRESS_ALLEQUIP_REDUCE = "undress_allequip_reduce",
	ENHANCE_GREAT_RATE_CHARACTER = "enhance_great_rate_character",
	BATTLE_MATERIAL_RUNE = "battle_material_rune",
	ABYSS_PURIFICATION_REWARD = "abyss_purification_reward",
	OPEN_ALTAR_DARK = "open_altar_dark",
	UNDRESS_ARTIFACT_REDUCE = "undress_artifact_reduce",
	HEAL_GOLD_REDUCE = "heal_gold_reduce",
	BATTLE_TOKEN_GOLD = "battle_token_gold",
	BATTLE_TOKEN_PVPGOLD = "battle_token_pvpgold",
	OPEN_ALL_ALTAR = "open_all_altar",
	OPEN_ALTAR_FIRE = "open_altar_fire",
	TOKEN_MAX_STAMINA = "token_max_stamina",
	ENHANCE_EQUIP_EXP = "enhance_equip_exp",
	OPEN_ALTAR_LIGHT = "open_altar_light",
	UNDRESS_EQUIP_REDUCE = "undress_equip_reduce",
	BATTLE_ACCOUNT_EXP = "battle_account_exp",
	OPEN_ALTAR_WIND = "open_altar_wind",
	BATTLE_MATERIAL_HUNT = "battle_material_hunt",
	ENHANCE_GREAT_RATE_EQIP = "enhance_great_rate_equip",
	FRIEND_SUPPORT_TOKEN = "friend_support_friend",
	BATTLE_HERO_EXP = "battle_hero_exp",
	HEAL_TIME_REDUCE = "heal_time_reduce",
	OPEN_ALTAR_ICE = "open_altar_ice"
}
EVENT_BOOSTER_SUB_TYPE = {
	HUNT_EVENT = "hunt_event",
	EQUIP_ARTI_FREE = "arti_free",
	EQUIP_NO_ARTI_FREE = "equip_free",
	EXPEDITION_POINT = "expedition_point",
	RUNE_EVENT = "rune_event",
	EQUIP_ALL_FREE_EVENT = "allequip_free",
	EXPEDITION_DETECT = "expedition_detect",
	CREHUNT_EVENT = "crehunt_event"
}
EVENT_BOOSTER_NOT_RATIO_VALUE = {
	"as_svcrehunt_1"
}
Booster = Booster or {}

function Booster.getBoosters(arg_1_0)
	boosters = {}
	
	local var_1_0 = AccountSkill:getBoosters()
	local var_1_1 = EventBooster:getActiveBoosters()
	
	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		iter_1_1.type = "account_skill"
		
		table.insert(boosters, iter_1_1)
	end
	
	for iter_1_2, iter_1_3 in pairs(var_1_1) do
		iter_1_3.type = "event_booster"
		
		table.insert(boosters, iter_1_3)
	end
	
	return boosters
end

function Booster.isActiveBoosterSubType(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0, var_2_1 = EventBooster:isActiveBoosterSubType(arg_2_1, arg_2_2)
	
	if var_2_0 then
		return true, var_2_1
	end
	
	return false
end

function Booster.hasNewBooster(arg_3_0)
	local var_3_0 = arg_3_0:getUIBoosters()
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if iter_3_1.new and iter_3_1.type == "event_booster" then
			return true
		end
	end
	
	return false
end

function Booster.hasHotTimeBooster(arg_4_0)
	local var_4_0 = arg_4_0:getUIBoosters()
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		if iter_4_1.hottime then
			return true
		end
	end
	
	return false
end

function Booster.getUIBoosters(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = AccountSkill:getBoosters()
	local var_5_2 = EventBooster:getActiveBoosters()
	local var_5_3 = Account:getActiveClanBuffs()
	
	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		iter_5_1.type = "account_skill"
		
		local var_5_4 = SAVE:get("game.booster.new." .. iter_5_1.skill_id)
		
		if not var_5_4 or var_5_4 ~= iter_5_1.expire_time then
			iter_5_1.new = true
		else
			iter_5_1.new = nil
		end
		
		if not iter_5_1.skill_icon then
			iter_5_1.skill_icon = AccountSkill:getSkillDB(iter_5_1.skill_id .. "_" .. iter_5_1.level).icon
		end
		
		table.insert(var_5_0, iter_5_1)
	end
	
	for iter_5_2, iter_5_3 in pairs(var_5_2) do
		iter_5_3.type = "event_booster"
		
		local var_5_5 = SAVE:get("game.booster.new." .. iter_5_3.id)
		
		if not var_5_5 or var_5_5 ~= iter_5_3.end_time then
			iter_5_3.new = true
		else
			iter_5_3.new = nil
		end
		
		if not iter_5_3.skill_icon then
			iter_5_3.skill_icon = EventBooster:getSkillDB(iter_5_3.skill_id).icon
		end
		
		if not iter_5_3.hide then
			table.insert(var_5_0, iter_5_3)
		end
	end
	
	for iter_5_4, iter_5_5 in pairs(var_5_3) do
		iter_5_5.type = "clan_buff"
		
		local var_5_6 = SAVE:get("game.booster.new." .. iter_5_5.skill_id)
		
		if not var_5_6 or var_5_6 ~= iter_5_5.expire_time then
			iter_5_5.new = true
		else
			iter_5_5.new = nil
		end
		
		if not iter_5_5.skill_icon then
			iter_5_5.skill_icon = AccountSkill:getSkillDB(iter_5_5.skill_id).icon
		end
		
		if not iter_5_5.hide then
			table.insert(var_5_0, iter_5_5)
		end
	end
	
	local function var_5_7(arg_6_0)
		local var_6_0 = os.time()
		local var_6_1 = 0
		
		if arg_6_0.type == "account_skill" then
			var_6_1 = arg_6_0.expire_time - var_6_0
		elseif arg_6_0.type == "event_booster" then
			for iter_6_0, iter_6_1 in pairs(arg_6_0.tm) do
				local var_6_2 = iter_6_1[1]
				local var_6_3 = iter_6_1[2]
				
				if var_6_2 <= var_6_0 and var_6_0 < var_6_3 then
					var_6_1 = var_6_3 - var_6_0
					
					break
				end
			end
		end
		
		return var_6_1
	end
	
	table.sort(var_5_0, function(arg_7_0, arg_7_1)
		local var_7_0 = var_5_7(arg_7_0)
		local var_7_1 = var_5_7(arg_7_1)
		
		if arg_7_0.new and not arg_7_1.new then
			return true
		end
		
		return var_7_0 < var_7_1 and not arg_7_1.new
	end)
	
	return var_5_0
end

function Booster.getApplyEffectPercent(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:getUIBoosters()
	local var_8_1 = 0
	
	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		local var_8_2
		
		if iter_8_1.type == "account_skill" then
			local var_8_3 = iter_8_1.skill_id .. "_" .. iter_8_1.level
			
			var_8_2 = AccountSkill:getSkillDB(var_8_3)
		elseif iter_8_1.type == "event_booster" then
			local var_8_4 = iter_8_1.skill_id
			
			var_8_2 = EventBooster:getSkillDB(var_8_4)
		elseif iter_8_1.type == "clan_buff" then
			local var_8_5 = iter_8_1.skill_id
			
			var_8_2 = AccountSkill:getSkillDB(var_8_5)
		end
		
		if var_8_2 and var_8_2.effect_type == arg_8_1 and var_8_2.calc_type == "multiply" then
			var_8_1 = var_8_1 + tonumber(var_8_2.value)
		end
	end
	
	return var_8_1 * 100
end

function Booster.calcValue(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = AccountSkill:getAddCalcValue(arg_9_1, arg_9_2)
	local var_9_1 = EventBooster:getAddCalcValue(arg_9_1, arg_9_2)
	local var_9_2 = Clan:getAddCalcValue(arg_9_1, arg_9_2)
	
	return arg_9_2 + var_9_0 + var_9_1 + var_9_2
end

function Booster.getAddCalcValue(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = AccountSkill:getAddCalcValue(arg_10_1, arg_10_2)
	local var_10_1 = EventBooster:getAddCalcValue(arg_10_1, arg_10_2)
	local var_10_2 = Clan:getAddCalcValue(arg_10_1, arg_10_2)
	
	return var_10_0 + var_10_1 + var_10_2
end

function Booster.getEnabledTime(arg_11_0, arg_11_1)
	local var_11_0 = EventBooster:getEnabledTime(arg_11_1)
	
	if var_11_0 then
		return var_11_0
	end
	
	local var_11_1 = AccountSkill:getEnabledTime(arg_11_1)
	
	if var_11_1 then
		return var_11_1
	end
	
	return nil
end

function Booster.updateBoosters(arg_12_0)
	AccountSkill:updateBoosters()
end

function Booster.getEventBoosterUIDesc(arg_13_0, arg_13_1)
	return EventBooster:getEventBoosterUIDesc(arg_13_1)
end

function Booster.getEventBoosterValueDesc(arg_14_0, arg_14_1)
	return EventBooster:getEventBoosterValueDesc(arg_14_1)
end

function Booster.isActiveBattleEvent(arg_15_0)
	return arg_15_0:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.RUNE_EVENT) or arg_15_0:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.HUNT_EVENT) or arg_15_0:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.CREHUNT_EVENT)
end

EventBooster = EventBooster or {}

function EventBooster.isActiveBoosterSubType(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	
	var_16_0 = arg_16_2 or {}
	
	local var_16_1 = os.time()
	local var_16_2 = arg_16_0:getActiveBoosters()
	
	if not var_16_2 then
		return false
	end
	
	for iter_16_0, iter_16_1 in pairs(var_16_2) do
		if iter_16_1.sub_type and iter_16_1.sub_type == arg_16_1 then
			return true, iter_16_1.id
		end
	end
	
	return false
end

function EventBooster.getAddCalcValue(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = os.time()
	local var_17_1 = arg_17_0:getActiveBoosters()
	local var_17_2 = 0
	
	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		local var_17_3 = arg_17_0:getSkillDB(iter_17_1.skill_id)
		
		if var_17_3 and var_17_3.effect_type == arg_17_1 then
			if var_17_3.calc_type == "multiply" then
				var_17_2 = var_17_2 + arg_17_2 * var_17_3.value
			elseif var_17_3.calc_type == "sum" then
				var_17_2 = var_17_2 + var_17_3.value
			end
		end
	end
	
	return (math.floor(var_17_2))
end

function EventBooster.getEnabledTime(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:getActiveBoosters()
	
	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		local var_18_1 = arg_18_0:getSkillDB(iter_18_1.skill_id)
		
		if var_18_1 and var_18_1.effect_type == arg_18_1 and to_n(var_18_1.value) > 0 and iter_18_1.tm then
			return iter_18_1.tm
		end
	end
	
	return nil
end

function EventBooster.getEventBoosterUIDesc(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0, var_19_1 = DB("boost_event_schedule", arg_19_1, {
		"id",
		"account_skill_id"
	})
	
	if not var_19_0 then
		return 
	end
	
	if not var_19_1 then
		return 
	end
	
	local var_19_2, var_19_3, var_19_4, var_19_5 = DB("account_skill", var_19_1, {
		"id",
		"event_ui_desc",
		"value",
		"calc_type"
	})
	
	if not var_19_3 then
		return 
	end
	
	if not var_19_4 then
		return 
	end
	
	if not var_19_5 then
		return 
	end
	
	local var_19_6 = to_n(var_19_4)
	
	if var_19_5 == "multiply" then
		var_19_6 = var_19_6 * 100
	elseif var_19_5 == "sum" then
	else
		return 
	end
	
	return T(var_19_3, {
		value = var_19_6
	})
end

function EventBooster.getEventBoosterValueDesc(arg_20_0, arg_20_1)
	if not arg_20_1 then
		return 
	end
	
	local var_20_0, var_20_1 = DB("boost_event_schedule", arg_20_1, {
		"id",
		"account_skill_id"
	})
	
	if not var_20_0 then
		return 
	end
	
	if not var_20_1 then
		return 
	end
	
	local var_20_2 = AccountSkill:getSkillDB(var_20_1)
	
	if not var_20_2 then
		return 
	end
	
	if not var_20_2.value then
		return 
	end
	
	if not var_20_2.effect_type then
		return 
	end
	
	if not var_20_2.effect_value_desc then
		return 
	end
	
	local var_20_3 = to_n(var_20_2.value) * 100
	
	if var_20_2.effect_type and var_20_2.effect_type == "expedition_detect_up" and var_20_2.calc_type and var_20_2.calc_type == "sum" then
		var_20_3 = var_20_3 / 100
	end
	
	if var_20_2.id and table.isInclude(EVENT_BOOSTER_NOT_RATIO_VALUE or {}, var_20_2.id) then
		var_20_3 = var_20_3 / 100
	end
	
	return T(var_20_2.effect_value_desc, {
		value = var_20_3
	})
end

function EventBooster.getSkillDB(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	return (DBT("account_skill", arg_21_1, {
		"id",
		"level",
		"effect_type",
		"effect_detail",
		"effect_desc",
		"value",
		"value_desc",
		"calc_type",
		"icon",
		"name"
	}))
end

function EventBooster.getActiveBoosters(arg_22_0)
	local var_22_0 = os.time()
	local var_22_1 = Account:getEventBoosters() or {}
	local var_22_2 = {}
	
	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		if var_22_0 >= iter_22_1.start_time and var_22_0 < iter_22_1.end_time then
			if iter_22_1.user_type == "return" then
				local var_22_3 = Account:getEventTicket("7days_return")
				
				if var_22_3 then
					local var_22_4 = GAME_CONTENT_VARIABLE.return_user_buff_duration or 14
					local var_22_5 = var_22_3.issued_tm + var_22_4 * 60 * 60 * 24
					local var_22_6 = iter_22_1.tm[1]
					
					if var_22_0 > var_22_3.issued_tm and var_22_0 < var_22_5 then
						var_22_6[1] = var_22_3.issued_tm
						var_22_6[2] = var_22_5
						
						table.insert(var_22_2, iter_22_1)
					end
				end
			elseif iter_22_1.user_type == "new" then
				local var_22_7 = Account:getEventTicket("7days_new")
				
				if var_22_7 then
					local var_22_8 = GAME_CONTENT_VARIABLE.new_user_buff_duration or 14
					local var_22_9 = var_22_7.issued_tm + var_22_8 * 60 * 60 * 24
					local var_22_10 = iter_22_1.tm[1]
					
					if var_22_0 > var_22_7.issued_tm and var_22_0 < var_22_9 then
						var_22_10[1] = var_22_7.issued_tm
						var_22_10[2] = var_22_9
						
						table.insert(var_22_2, iter_22_1)
					end
				end
			else
				for iter_22_2, iter_22_3 in pairs(iter_22_1.tm) do
					local var_22_11 = iter_22_3[1]
					local var_22_12 = iter_22_3[2]
					
					if var_22_11 <= var_22_0 and var_22_0 < var_22_12 then
						table.insert(var_22_2, iter_22_1)
						
						break
					end
				end
			end
		end
	end
	
	return var_22_2
end

BoosterUI = BoosterUI or {}

function HANDLER.booster_tooltip(arg_23_0, arg_23_1)
	BoosterUI:close()
end

function BoosterUI.show(arg_24_0, arg_24_1)
	if table.count(Booster:getUIBoosters()) == 0 then
		balloon_message_with_sound("has_not_booster")
		
		return 
	end
	
	if arg_24_0.vars and get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	arg_24_0.vars = {}
	arg_24_1 = arg_24_1 or SceneManager:getRunningPopupScene()
	arg_24_0.vars.parents = arg_24_1
	arg_24_0.vars.wnd = Dialog:open("wnd/booster_tooltip", arg_24_0)
	
	arg_24_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_24_0.vars.wnd, "block")
	arg_24_1:addChild(arg_24_0.vars.wnd)
	arg_24_0:createListView()
	TutorialGuide:forceProcGuide()
	arg_24_0:updateBoosterPercent(arg_24_0.vars.wnd)
end

function BoosterUI.updateLobbyUI(arg_25_0, arg_25_1)
	local var_25_0 = Booster:getUIBoosters()
	
	for iter_25_0 = 1, 5 do
		if iter_25_0 == 5 then
			if_set_visible(arg_25_1, "boost_more_icon", var_25_0[iter_25_0])
		elseif var_25_0[iter_25_0] and var_25_0[iter_25_0].skill_icon then
			if_set_visible(arg_25_1, "boost_icon_" .. iter_25_0, true)
			if_set_sprite(arg_25_1, "boost_icon_" .. iter_25_0, "shop/" .. var_25_0[iter_25_0].skill_icon)
		else
			if_set_visible(arg_25_1, "boost_icon_" .. iter_25_0, false)
		end
	end
	
	arg_25_0:updateBoosterPercent(arg_25_1)
	
	local var_25_1 = Booster:isActiveBattleEvent()
	local var_25_2 = arg_25_1:getChildByName("btn_battle")
	
	if get_cocos_refid(var_25_2) then
		if_set_visible(var_25_2, "icon_event", var_25_1)
		
		if var_25_1 then
			if_set_visible(var_25_2, "icon_new", false)
		end
	end
	
	local var_25_3 = arg_25_1:getChildByName("btn_booster")
	
	if get_cocos_refid(var_25_3) then
		if Booster:hasHotTimeBooster() then
			if get_cocos_refid(var_25_3) and not var_25_3.n_booster_eff then
				var_25_3.n_booster_eff = EffectManager:Play({
					pivot_x = 0,
					fn = "ui_boost_wing.cfx",
					pivot_y = 0,
					pivot_z = -99998,
					layer = var_25_3
				})
				
				local var_25_4 = var_25_3:getChildByName("img")
				
				if get_cocos_refid(var_25_4) then
					var_25_3.n_booster_eff:setAnchorPoint(var_25_4:getAnchorPoint().x, var_25_4:getAnchorPoint().y)
					var_25_3.n_booster_eff:setPosition(var_25_4:getPositionX(), var_25_4:getPositionY())
				end
			end
		elseif get_cocos_refid(var_25_3.n_booster_eff) then
			var_25_3.n_booster_eff:removeFromParent()
		end
	end
end

function BoosterUI.updateBoosterPercent(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = Booster:getApplyEffectPercent(BOOSTERSKILL_EFFECT_TYPE.BATTLE_HERO_EXP)
	local var_26_1 = Booster:getApplyEffectPercent(BOOSTERSKILL_EFFECT_TYPE.BATTLE_TOKEN_GOLD)
	local var_26_2 = Booster:getApplyEffectPercent(BOOSTERSKILL_EFFECT_TYPE.BATTLE_TOKEN_PVPGOLD)
	local var_26_3 = var_26_2 > 0
	local var_26_4 = arg_26_1
	local var_26_5 = var_26_4:getChildByName("booster_1")
	
	if get_cocos_refid(var_26_5) then
		if_set(var_26_4, "txt_booster1", "+" .. var_26_1 .. "%")
		
		if not arg_26_2 then
			if not var_26_5.origin_pos_x then
				var_26_5.origin_pos_x = var_26_5:getPositionX()
			end
			
			if var_26_3 then
				var_26_5:setPositionX(var_26_5.origin_pos_x - 114)
			else
				var_26_5:setPositionX(var_26_5.origin_pos_x)
			end
		end
	end
	
	local var_26_6 = arg_26_1:getChildByName("booster_2")
	
	if get_cocos_refid(var_26_6) then
		if_set(arg_26_1, "txt_booster2", "+" .. var_26_0 .. "%")
		
		if not arg_26_2 then
			if not var_26_6.origin_pos_x then
				var_26_6.origin_pos_x = var_26_6:getPositionX()
			end
			
			if var_26_3 then
				var_26_6:setPositionX(var_26_6.origin_pos_x - 114)
			else
				var_26_6:setPositionX(var_26_6.origin_pos_x)
			end
		end
	end
	
	local var_26_7 = arg_26_1
	
	if arg_26_2 then
		var_26_7 = arg_26_1:getChildByName("n_pvp")
	end
	
	local var_26_8 = var_26_7:getChildByName("booster_3")
	
	if get_cocos_refid(var_26_8) then
		local var_26_9 = false
		
		if ClearResult.vars and ClearResult.vars.result and ClearResult.vars.result.pvp_reward then
			var_26_9 = true
		end
		
		local var_26_10 = arg_26_2 == nil or arg_26_2 == true and var_26_9
		
		if_set_visible(var_26_7, "booster_3", var_26_10 and var_26_3)
		
		if var_26_10 and var_26_3 then
			if_set(var_26_7, "txt_booster3", "+" .. var_26_2 .. "%")
		end
	end
end

function BoosterUI.close(arg_27_0)
	Dialog:close("booster_tooltip")
	
	local var_27_0 = SceneManager:getCurrentSceneName()
	local var_27_1
	local var_27_2 = Booster:getUIBoosters()
	
	for iter_27_0, iter_27_1 in pairs(var_27_2) do
		if iter_27_1.new then
			if iter_27_1.type == "account_skill" then
				SAVE:set("game.booster.new." .. iter_27_1.skill_id, iter_27_1.expire_time)
				SAVE:save()
			elseif iter_27_1.type == "event_booster" then
				SAVE:set("game.booster.new." .. iter_27_1.id, iter_27_1.end_time)
				SAVE:save()
			elseif iter_27_1.type == "clan_buff" then
				SAVE:set("game.booster.new." .. iter_27_1.skill_id, iter_27_1.expire_time)
				SAVE:save()
			end
			
			var_27_1 = true
		end
	end
	
	if var_27_0 == "lobby" and var_27_1 then
		Lobby:nextNoti()
	elseif var_27_0 == "battle" and var_27_1 and not BattleReady:getDlg() then
		ClearResult:nextSeq()
	end
end

function BoosterUI.updateListItem(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = os.time()
	local var_28_1
	local var_28_2
	local var_28_3 = 0
	
	if arg_28_2.type == "account_skill" then
		var_28_1 = arg_28_2.skill_id .. "_" .. arg_28_2.level
		var_28_2 = AccountSkill:getSkillDB(var_28_1)
		var_28_3 = arg_28_2.expire_time - var_28_0
	elseif arg_28_2.type == "event_booster" then
		var_28_1 = arg_28_2.skill_id
		var_28_2 = EventBooster:getSkillDB(var_28_1)
		
		for iter_28_0, iter_28_1 in pairs(arg_28_2.tm) do
			local var_28_4 = iter_28_1[1]
			local var_28_5 = iter_28_1[2]
			
			if var_28_4 <= var_28_0 and var_28_0 < var_28_5 then
				var_28_3 = var_28_5 - var_28_0
				
				break
			end
		end
	elseif arg_28_2.type == "clan_buff" then
		var_28_1 = arg_28_2.skill_id
		var_28_2 = AccountSkill:getSkillDB(var_28_1)
		var_28_3 = arg_28_2.expire_time - var_28_0
	end
	
	if not var_28_1 or not var_28_2 or not var_28_2.id then
		return 
	end
	
	local var_28_6 = AccountSkill:getSkillDB(var_28_1)
	local var_28_7 = arg_28_1:getChildByName("txt_title")
	
	if get_cocos_refid(var_28_7) then
		UIUserData:call(var_28_7, "SINGLE_WSCALE(330)")
		if_set(var_28_7, nil, T(var_28_6.name))
	end
	
	local var_28_8 = to_n(var_28_6.value) * 100
	
	if var_28_6.effect_type and var_28_6.effect_type == "expedition_detect_up" and var_28_6.calc_type and var_28_6.calc_type == "sum" then
		var_28_8 = var_28_8 / 100
	end
	
	if arg_28_2.type == "event_booster" and var_28_6.id and table.isInclude(EVENT_BOOSTER_NOT_RATIO_VALUE or {}, var_28_6.id) then
		var_28_8 = var_28_8 / 100
	end
	
	if_set(arg_28_1, "txt_desc", T(var_28_6.effect_value_desc, {
		value = var_28_8
	}))
	if_set_sprite(arg_28_1, "icon", "shop/" .. var_28_6.icon)
	
	if var_28_3 < 0 then
		if_set(arg_28_1, "txt_time", T("urgent_time_expire"))
	else
		if_set(arg_28_1, "txt_time", T("remain_time") .. " :" .. sec_to_full_string(var_28_3, true))
	end
	
	if_set_visible(arg_28_1, "icon_new", arg_28_2.new)
end

function BoosterUI.update(arg_29_0, arg_29_1)
	Booster:updateBoosters()
	
	if arg_29_1 and get_cocos_refid(arg_29_1) then
		local var_29_0 = table.count(Booster:getUIBoosters())
		local var_29_1 = SceneManager:getCurrentSceneName() == "lobby"
		local var_29_2 = arg_29_1:getChildByName("btn_booster")
		
		if var_29_0 <= 0 then
			if_set_visible(var_29_2, "n_cnt", false)
			var_29_2:setOpacity(102)
			if_set_color(var_29_2, "icon_order", cc.c3b(255, 255, 255))
		else
			if_set_visible(var_29_2, "n_cnt", true)
			var_29_2:setOpacity(255)
			if_set(var_29_2, "txt_booster_cnt", "+" .. var_29_0)
			if_set_color(var_29_2, "icon_order", cc.c3b(255, 120, 0))
		end
		
		if var_29_1 then
			arg_29_0:updateLobbyUI(arg_29_1)
		end
		
		arg_29_0:refreshListView(var_29_0)
		TopBarNew:checkEquipFreeEvent()
	end
end

function BoosterUI.refreshListView(arg_30_0, arg_30_1)
	if arg_30_0.vars and arg_30_0.vars.wnd and get_cocos_refid(arg_30_0.vars.wnd) then
		if arg_30_0.vars.list_data_count ~= arg_30_1 then
			arg_30_0:createListView()
		else
			arg_30_0.vars.listView:refresh()
			arg_30_0:updateBoosterPercent(arg_30_0.vars.wnd)
		end
	end
end

function BoosterUI.createListView(arg_31_0)
	local var_31_0 = Booster:getUIBoosters()
	
	arg_31_0.vars.list_data = var_31_0
	arg_31_0.vars.list_data_count = table.count(arg_31_0.vars.list_data)
	
	local var_31_1 = arg_31_0.vars.wnd:getChildByName("listview")
	local var_31_2 = load_control("wnd/booster_item.csb")
	
	arg_31_0.vars.listView = ItemListView_v2:bindControl(var_31_1)
	
	if var_31_1.STRETCH_INFO then
		local var_31_3 = var_31_1:getContentSize()
		
		resetControlPosAndSize(var_31_2, var_31_3.width, var_31_1.STRETCH_INFO.width_prev)
	end
	
	local var_31_4 = {
		onUpdate = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
			BoosterUI:updateListItem(arg_32_1, arg_32_3, arg_32_2)
			
			return arg_32_3.skill_id
		end
	}
	
	arg_31_0.vars.listView:setRenderer(var_31_2, var_31_4)
	arg_31_0.vars.listView:removeAllChildren()
	arg_31_0.vars.listView:setDataSource(arg_31_0.vars.list_data)
	arg_31_0.vars.listView:jumpToTop()
end
