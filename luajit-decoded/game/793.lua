RumbleSummon = {}

function HANDLER.gacha_rumble(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		RumbleSummon:closeGachaResult()
	end
end

function RumbleSummon.getGachaPrice(arg_2_0, arg_2_1)
	return RumbleSystem:getConfig("rumble_gacha_price_" .. arg_2_1) or 9999
end

function RumbleSummon.isAvailable(arg_3_0, arg_3_1)
	if RumblePlayer:getGold() < arg_3_0:getGachaPrice(arg_3_1) then
		return false, "rumble_main_msg_goldneed"
	end
	
	if RumblePlayer:isBenchFull() then
		return false, "rumble_main_msg_roommax"
	end
	
	return true
end

function RumbleSummon.onGacha(arg_4_0, arg_4_1)
	if get_cocos_refid(arg_4_0.result_dlg) then
		return 
	end
	
	local var_4_0, var_4_1 = arg_4_0:isAvailable(arg_4_1)
	
	if not var_4_0 then
		balloon_message_with_sound(var_4_1)
		
		return 
	end
	
	RumblePlayer:addGold(-1 * arg_4_0:getGachaPrice(arg_4_1))
	
	local var_4_2 = arg_4_0:gacha(arg_4_1)
	
	if var_4_2 then
		RumblePlayer:onSummonUnit(var_4_2)
	end
	
	TutorialGuide:procGuide()
end

function RumbleSummon.gacha(arg_5_0, arg_5_1)
	local var_5_0 = {}
	local var_5_1 = 0
	
	arg_5_1 = arg_5_1 or 1
	
	local var_5_2 = arg_5_0:getUnitLineUp()
	
	if not var_5_2 then
		return 
	end
	
	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		local var_5_3, var_5_4, var_5_5, var_5_6 = DB("rumble_gacha", iter_5_0, {
			"id",
			"char_id",
			"btn_grade",
			"rate"
		})
		
		if not var_5_3 then
			break
		end
		
		if arg_5_1 == var_5_5 then
			var_5_1 = var_5_1 + var_5_6
			
			table.insert(var_5_0, {
				id = var_5_4,
				acc = var_5_1
			})
		end
	end
	
	local var_5_7 = RumbleSystem:getRandom(1, var_5_1)
	
	for iter_5_2, iter_5_3 in ipairs(var_5_0) do
		if var_5_7 <= iter_5_3.acc then
			return iter_5_3.id
		end
	end
	
	Log.e("RumbleGacha.error", var_5_1, var_5_7)
	table.print(var_5_0)
	
	return nil
end

function RumbleSummon.showGachaResult(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 then
		return 
	end
	
	local var_6_0 = arg_6_2.layer or RumbleSystem:getUILayer() or SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	arg_6_2 = arg_6_2 or {}
	
	local var_6_1 = load_dlg("gacha_rumble", true, "wnd", function()
		arg_6_0:closeGachaResult()
	end)
	
	var_6_0:addChild(var_6_1)
	
	local var_6_2 = arg_6_1:getGrade()
	local var_6_3 = var_6_2 < 5 and "img/z_rumble_gacha_bg3.png" or "img/z_rumble_gacha_bg5.png"
	local var_6_4 = var_6_1:getChildByName("n_bg")
	
	if_set_sprite(var_6_4, nil, var_6_3)
	
	local var_6_5 = var_6_2 < 5 and "img/z_rumble_gacha_bg3_s.png" or "img/z_rumble_gacha_bg5_s.png"
	local var_6_6 = var_6_1:getChildByName("n_txt_bg")
	
	if_set_sprite(var_6_6, nil, var_6_5)
	RumbleUtil:setBaseInfo(var_6_1, arg_6_1)
	
	local var_6_7 = var_6_1:getChildByName("n_eff")
	
	if get_cocos_refid(var_6_7) then
		if var_6_2 == 3 then
			SoundEngine:play("event:/effect/rumble_summon_3")
		elseif var_6_2 == 4 then
			EffectManager:Play({
				fn = "ui_super_battle_summons_4s.cfx",
				layer = var_6_7
			})
			SoundEngine:play("event:/effect/rumble_summon_4")
		elseif var_6_2 >= 5 then
			EffectManager:Play({
				fn = "ui_super_battle_summons_5s.cfx",
				layer = var_6_7
			})
			SoundEngine:play("event:/effect/rumble_summon_5")
		end
	end
	
	local var_6_8 = var_6_1:getChildByName("rumble.portrait")
	
	if get_cocos_refid(var_6_8) then
		setBlendColor2(var_6_8, "def", cc.c4f(1, 1, 1, 1), 1)
		UIAction:Add(SEQ(LOG(SCALE(100, 0.8, 1.05)), LOG(SPAWN(SCALE(140, 1.05, 1), BLEND(140, "white", 1, 0)))), var_6_8, "block")
	end
	
	for iter_6_0 = 1, 2 do
		local var_6_9 = var_6_1:getChildByName("n_skll" .. iter_6_0)
		local var_6_10 = arg_6_1:getSkill(iter_6_0)
		
		if var_6_10 then
			local var_6_11 = RumbleUtil:getSkillIcon(var_6_10:getId(), {
				show_tooltip = true
			})
			
			if get_cocos_refid(var_6_11) then
				var_6_9:addChild(var_6_11)
			end
		end
	end
	
	if not arg_6_2.auto_sell then
		local var_6_12 = var_6_1:getChildByName("n_info")
		local var_6_13 = arg_6_1:getDevote(true)
		
		if var_6_13 > 0 then
			local var_6_14 = var_6_1:getChildByName("n_after")
			
			RumbleUtil:setStatInfo(var_6_12, arg_6_1, var_6_13 - 1)
			RumbleUtil:setStatInfo(var_6_14, arg_6_1, var_6_13)
			
			local var_6_15 = string.lower(arg_6_1:getDevoteGrade(var_6_13 - 1))
			local var_6_16 = string.lower(arg_6_1:getDevoteGrade(var_6_13))
			
			if_set_sprite(var_6_12, "icon_dedi", "img/hero_dedi_a_" .. var_6_15 .. ".png")
			if_set_sprite(var_6_14, "icon_dedi", "img/hero_dedi_a_" .. var_6_16 .. ".png")
			if_set_visible(var_6_14, "n_2", false)
			if_set_visible(var_6_14, "n_4", false)
			if_set_visible(var_6_14, "n_5", false)
			if_set_visible(var_6_14, "n_6", false)
			if_set_visible(var_6_14, nil, true)
			
			function arg_6_0.on_close()
				arg_6_1:playDevoteEffect()
			end
		else
			RumbleUtil:setStatInfo(var_6_12, arg_6_1)
		end
	else
		if_set_visible(var_6_1, "n_info", false)
		if_set_visible(var_6_1, "n_coin", true)
		
		local var_6_17 = var_6_1:getChildByName("n_item")
		
		if get_cocos_refid(var_6_17) then
			local var_6_18 = RumbleUtil:getTokenIcon({
				count = arg_6_1:getSellPrice(0)
			})
			
			var_6_17:addChild(var_6_18)
		end
	end
	
	if_set_arrow(var_6_1, "n_arrow")
	
	arg_6_0.result_dlg = var_6_1
	
	arg_6_0.result_dlg:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_6_0.result_dlg, "block")
end

function RumbleSummon.closeGachaResult(arg_9_0)
	if get_cocos_refid(arg_9_0.result_dlg) then
		UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_9_0.result_dlg, "block")
	end
	
	BackButtonManager:pop("gacha_rumble")
	TutorialGuide:startGuide("rumble_round1_2")
	
	if type(arg_9_0.on_close) == "function" then
		arg_9_0.on_close()
	end
	
	arg_9_0.result_dlg = nil
	arg_9_0.on_close = nil
end

function RumbleSummon.getUnitLineUp(arg_10_0)
	local var_10_0 = RumbleUtil:getRumbleSchedule()
	
	if not var_10_0 then
		Log.e("RumbleSummon.no_schedule")
		
		return 
	end
	
	local var_10_1 = {}
	
	for iter_10_0 = 1, 9999 do
		local var_10_2, var_10_3, var_10_4 = DBN("rumble_gacha", iter_10_0, {
			"id",
			"char_id",
			"rumble_schedule"
		})
		
		if not var_10_2 then
			break
		end
		
		if var_10_4 == var_10_0 then
			var_10_1[var_10_2] = var_10_3
		end
	end
	
	return var_10_1
end
