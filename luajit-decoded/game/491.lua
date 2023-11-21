SanctuaryOrbis = SanctuaryOrbis or {}
SanctuaryMain.MODE_LIST.Orbis = SanctuaryOrbis

function HANDLER.sanctuary_orbis(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_collect" then
		if not arg_1_0.active_flag then
			balloon_message_with_sound("too_fast_harvest")
			
			return 
		end
		
		SanctuaryOrbis:Collect(true)
	end
end

function MsgHandler.orbis(arg_2_0)
	AccountData.sanc_orbis_tm_res1 = arg_2_0.sanc_orbis_tm_res1
	AccountData.sanc_orbis_tm_res2 = arg_2_0.sanc_orbis_tm_res2
	
	if arg_2_0.mode == "collect" then
		SanctuaryOrbis:onCollectOrbis(arg_2_0)
	else
		SanctuaryOrbis:UpdateOrbis()
	end
end

function SanctuaryOrbis.onEnter(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("sanctuary_orbis", true, "wnd")
	
	arg_3_1:addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(300), arg_3_0.vars.wnd, "block")
	UIUtil:getRewardIcon(nil, "to_gold", {
		parent = arg_3_0.vars.wnd:getChildByName("n_res1")
	})
	UIUtil:getRewardIcon(nil, "to_crystal", {
		parent = arg_3_0.vars.wnd:getChildByName("n_res2")
	})
	arg_3_0:update(true)
	Scheduler:addSlow(arg_3_0.vars.wnd, arg_3_0.update, arg_3_0)
	SoundEngine:play("event:/ui/sanctuary/enter_orbis")
end

function SanctuaryOrbis.showBoostDialog(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = load_dlg("sanctuary_orbis_result", true, "wnd")
	
	UIAction:Add(INC_NUMBER(500, arg_4_2), var_4_0:getChildByName("txt_res1"), "block")
	
	if to_n(arg_4_3) > 0 then
		UIAction:Add(INC_NUMBER(500, to_n(arg_4_3)), var_4_0:getChildByName("txt_res2"), "block")
	else
		var_4_0:getChildByName("item1"):setPositionX(VIEW_WIDTH / 2)
		if_set_visible(var_4_0, "item2", false)
	end
	
	if_set_visible(var_4_0, "boost", arg_4_4 ~= nil)
	
	local var_4_1 = GAME_STATIC_VARIABLE.orbis_bonus_scale or 100
	
	if type(arg_4_4) == "number" then
		var_4_1 = to_n(arg_4_4) - 100
	end
	
	for iter_4_0 = 1, 3 do
		local var_4_2 = string.sub(var_4_1, iter_4_0, iter_4_0)
		
		if_set_sprite(var_4_0, "n" .. iter_4_0, "game_eff_dmg_p" .. var_4_2 .. ".png")
	end
	
	if arg_4_1 ~= "collect" then
		balloon_message_with_sound("auto_harvest", {
			gold = arg_4_2,
			stamina = to_n(arg_4_3)
		})
	end
	
	Dialog:msgBox("", {
		dlg = var_4_0
	})
end

function SanctuaryOrbis.onCollectOrbis(arg_5_0, arg_5_1)
	if arg_5_1.orbis_result then
		AccountData.sanc_orbis_tm_res1 = arg_5_1.orbis_result.sanc_orbis_tm_res1
		AccountData.sanc_orbis_tm_res2 = arg_5_1.orbis_result.sanc_orbis_tm_res2
		
		Account:updateCurrencies(arg_5_1, {
			content = "orbis"
		})
		TopBarNew:topbarUpdate(true)
		arg_5_0:showBoostDialog(arg_5_1.mode, arg_5_1.orbis_result.add_gold, arg_5_1.orbis_result.add_crystal, arg_5_1.orbis_result.boost)
	elseif arg_5_1.mode == "collect" then
		balloon_message_with_sound("too_fast_harvest")
	end
	
	SanctuaryOrbis:UpdateOrbis(true)
end

function SanctuaryOrbis.UpdateOrbis(arg_6_0, arg_6_1)
	arg_6_0.levels = SanctuaryMain:GetLevels("Orbis")
	
	if arg_6_0.db == nil or arg_6_1 then
		arg_6_0.db = {}
		
		for iter_6_0 = 1, 3 do
			arg_6_0.db[iter_6_0] = SLOW_DB_ALL("sanctuary_upgrade", "orbis_" .. iter_6_0 - 1 .. "_" .. to_n(arg_6_0.levels[iter_6_0]))
		end
		
		if UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_ORBIS) and not AccountData.sanc_orbis_tm_res2 and to_n(arg_6_0.levels[2]) > 0 then
			query("orbis")
		end
	end
	
	arg_6_0.res1_per_hour = arg_6_0.db[2].value_1
	arg_6_0.res2_per_hour = arg_6_0.db[2].value_2
	arg_6_0.res1_max = arg_6_0.db[1].value_1
	arg_6_0.res2_max = arg_6_0.db[1].value_2
	
	local var_6_0 = 0
	local var_6_1 = 0
	
	if to_n(AccountData.sanc_orbis_tm_res1) == 0 then
		arg_6_0.res1 = 0
		arg_6_0.res1_percent = 0
	else
		var_6_0 = math.max(0, os.time() - AccountData.sanc_orbis_tm_res1)
		arg_6_0.res1 = math.max(0, math.min(arg_6_0.res1_per_hour * var_6_0 / 3600, arg_6_0.res1_max))
		arg_6_0.res1_percent = math.min(1, math.max(0, arg_6_0.res1_per_hour * var_6_0 / 3600 / arg_6_0.res1_max))
	end
	
	if to_n(AccountData.sanc_orbis_tm_res2) == 0 then
		arg_6_0.res2 = 0
		arg_6_0.res2_percent = 0
	else
		var_6_1 = math.max(0, os.time() - AccountData.sanc_orbis_tm_res2)
		arg_6_0.res2 = math.max(0, math.min(arg_6_0.res2_per_hour * var_6_1 / 3600, arg_6_0.res2_max))
		arg_6_0.res2_percent = math.min(1, math.max(0, arg_6_0.res2_per_hour * var_6_1 / 3600 / arg_6_0.res2_max))
	end
	
	if to_n(AccountData.sanc_orbis_tm_res1) + to_n(AccountData.sanc_orbis_tm_res2) == 0 then
		arg_6_0.rest_tm_to_collect = -1
		arg_6_0.rest_tm_to_100 = 0
	else
		local var_6_2 = 0
		local var_6_3 = 0
		
		if arg_6_0.res1_per_hour > 0 then
			var_6_2 = (arg_6_0.res1_max - arg_6_0.res1) / arg_6_0.res1_per_hour
		end
		
		if arg_6_0.res2_per_hour > 0 then
			var_6_3 = (arg_6_0.res2_max - arg_6_0.res2) / arg_6_0.res2_per_hour
		end
		
		arg_6_0.rest_tm_to_collect = math.max(0, 600 - math.min(var_6_0, var_6_1))
		arg_6_0.rest_tm_to_100 = math.max(0, math.floor(math.max(var_6_2, var_6_3) * 3600))
		
		if arg_6_1 and arg_6_0.rest_tm_to_100 > 0 then
			add_local_push("ORBIS_COLLECT", arg_6_0.rest_tm_to_100)
		end
	end
	
	arg_6_0.res1 = math.floor(arg_6_0.res1)
	arg_6_0.res2 = math.floor(arg_6_0.res2)
	
	return arg_6_0.res1, arg_6_0.res2, arg_6_0.res1_max, arg_6_0.res2_max
end

function SanctuaryOrbis.update(arg_7_0, arg_7_1)
	arg_7_0:UpdateOrbis(arg_7_1)
	
	if not arg_7_0.vars then
		return 
	end
	
	if arg_7_0.levels[2] > 0 and not arg_7_0.vars.eff_started then
		arg_7_0.vars.eff_started = true
		
		UIAction:Add(LOOP(ROTATE(1600, 0, -360), 100), arg_7_0.vars.wnd:getChildByName("circle1"), "orbis_eff")
		UIAction:Add(LOOP(ROTATE(1600, 0, 360), 100), arg_7_0.vars.wnd:getChildByName("circle2"), "orbis_eff")
	end
	
	local var_7_0 = T("orbis_res_gold_time") .. " " .. comma_value(arg_7_0.res1_per_hour)
	
	if_set(arg_7_0.vars.wnd, "txt_res1_per_hour", var_7_0)
	if_set_scale_fit_width(arg_7_0.vars.wnd, "txt_res1_per_hour", 256)
	
	local var_7_1 = T("orbis_res_gold_value") .. " " .. comma_value(arg_7_0.res1_max)
	
	if_set(arg_7_0.vars.wnd, "txt_res1_max", var_7_1)
	if_set_scale_fit_width(arg_7_0.vars.wnd, "txt_res1_max", 256)
	
	local var_7_2 = T("orbis_res_crystal_time") .. " " .. comma_value(arg_7_0.res2_per_hour)
	
	if_set(arg_7_0.vars.wnd, "txt_res2_hour_title", var_7_2)
	if_set_scale_fit_width(arg_7_0.vars.wnd, "txt_res2_hour_title", 256)
	
	local var_7_3 = T("orbis_res_crystal_value") .. " " .. comma_value(arg_7_0.res2_max)
	
	if_set(arg_7_0.vars.wnd, "txt_res2_max_title", var_7_3)
	if_set_scale_fit_width(arg_7_0.vars.wnd, "txt_res2_max_title", 256)
	if_set_visible(arg_7_0.vars.wnd, "n_rest_tm", arg_7_0.rest_tm_to_collect > 0)
	if_set_visible(arg_7_0.vars.wnd, "btn_collect", arg_7_0.rest_tm_to_collect >= 0)
	if_set_visible(arg_7_0.vars.wnd, "noti_collect", arg_7_0.rest_tm_to_collect == 0)
	UIUtil:changeButtonState(arg_7_0.vars.wnd:getChildByName("btn_collect"), arg_7_0.rest_tm_to_collect == 0)
	
	if arg_7_0.rest_tm_to_collect >= 0 then
		if_set(arg_7_0.vars.wnd, "txt_rest_tm", sec_to_string(arg_7_0.rest_tm_to_collect, true))
	end
	
	if_set_visible(arg_7_0.vars.wnd, "n_until_100", arg_7_0.rest_tm_to_100 > 0)
	
	if arg_7_0.rest_tm_to_100 > 0 then
		if_set(arg_7_0.vars.wnd, "txt_time_to_100", sec_to_string(arg_7_0.rest_tm_to_100, true))
	end
	
	local var_7_4 = math.floor(math.max(0, arg_7_0.res1 * 100 / arg_7_0.res1_max))
	local var_7_5 = math.floor(math.max(0, arg_7_0.res2 * 100 / arg_7_0.res2_max))
	
	arg_7_0.vars.wnd:getChildByName("progress_res1"):setPercent(arg_7_0.res1_percent * 100)
	arg_7_0.vars.wnd:getChildByName("progress_res2"):setPercent(arg_7_0.res2_percent * 100)
	if_set(arg_7_0.vars.wnd, "txt_res1_percent", math.floor(arg_7_0.res1_percent * 100) .. "%")
	if_set(arg_7_0.vars.wnd, "txt_res2_percent", math.floor(arg_7_0.res2_percent * 100) .. "%")
	
	local var_7_6 = arg_7_0.vars.wnd:getChildByName("txt_res1")
	local var_7_7 = arg_7_0.vars.wnd:getChildByName("txt_res2")
	
	if arg_7_0.prev_res1 then
		UIAction:Add(INC_NUMBER(500, arg_7_0.res1, nil, arg_7_0.prev_res1), var_7_6)
	else
		var_7_6:setString(comma_value(arg_7_0.res1))
	end
	
	arg_7_0.prev_res1 = arg_7_0.res1
	
	var_7_7:setString(comma_value(arg_7_0.res2))
	if_set(arg_7_0.vars.wnd, "txt_hit_percent", arg_7_0.db[3].value_1 * 100 .. "%")
end

function SanctuaryOrbis.onLeave(arg_8_0, arg_8_1)
	UIAction:Remove("orbis_eff")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE()), arg_8_0.vars.wnd, "block")
	
	arg_8_0.vars = nil
end

function SanctuaryOrbis.CheckCollect(arg_9_0)
	if to_n(AccountData.sanc_orbis_tm_res1) == 0 or os.time() - AccountData.sanc_orbis_tm_res1 <= 600 then
		return false, 0, 0
	end
	
	arg_9_0:UpdateOrbis()
	
	return arg_9_0.res2 > 0 and arg_9_0.res2 == arg_9_0.res2_max, arg_9_0.res1, arg_9_0.res2
end

function SanctuaryOrbis.Collect(arg_10_0, arg_10_1)
	if os.time() - to_n(AccountData.sanc_orbis_tm_res1) <= 600 then
		balloon_message_with_sound("too_fast_harvest")
		
		return 
	end
	
	if arg_10_1 then
		EffectManager:Play({
			x = 640,
			y = 380,
			fn = "ui_orbis_heart_get_in.cfx",
			layer = arg_10_0.vars.wnd
		})
		UIAction:Add(SEQ(DELAY(1000), CALL(SanctuaryOrbis.Collect, arg_10_0)), arg_10_0, "block")
		
		return 
	end
	
	query("orbis", {
		mode = "collect"
	})
end

function SanctuaryOrbis.CheckNotification(arg_11_0)
	arg_11_0:UpdateOrbis()
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_ORBIS) then
		return false
	end
	
	if arg_11_0.res2 > 0 and arg_11_0.res2 == arg_11_0.res2_max then
		return true
	end
	
	return SanctuaryMain:GetTotalLevel("Orbis") < 9 and Account:getCurrency("stone") > 0
end

function SanctuaryOrbis.onUpdateUpgrade(arg_12_0)
	arg_12_0:update(true)
end
