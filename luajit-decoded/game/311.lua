function GachaUnit.isEnabledGachaCustomSpecial(arg_1_0)
	local var_1_0 = Account:getGachaShopInfo()
	local var_1_1
	local var_1_2 = os.time()
	local var_1_3 = var_1_0.gacha_customspecial
	
	if var_1_3 and var_1_2 >= to_n(var_1_3.start_time) and var_1_2 <= to_n(var_1_3.end_time) then
		var_1_1 = to_n(var_1_3.end_time)
	end
	
	return var_1_1
end

function GachaUnit.getGachaCustomSpecialSelectList(arg_2_0)
	if arg_2_0.vars.gacha_mode ~= "gacha_customspecial" then
		return nil
	end
	
	local var_2_0 = Account:getGachaShopInfo()
	
	if not var_2_0 or not var_2_0.gacha_customspecial then
		return nil
	end
	
	local var_2_1 = os.time()
	local var_2_2 = var_2_0.gacha_customspecial
	
	if not var_2_2.select_list then
		return nil
	end
	
	local var_2_3 = {}
	
	if DB("character", tostring(var_2_2.select_list[1]), "id") then
		table.push(var_2_3, var_2_2.select_list[1])
	end
	
	if DB("character", tostring(var_2_2.select_list[2]), "id") then
		table.push(var_2_3, var_2_2.select_list[2])
	end
	
	if #var_2_3 ~= 2 then
		return nil
	end
	
	return var_2_3
end

function GachaUnit.checkGachaCustomSpecialSelectCompleted(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	arg_3_1.err_text = arg_3_1.err_text or "msg_ct_gachaspecial_select_before"
	
	local var_3_0 = Account:getGachaShopInfo()
	
	if not var_3_0 or not var_3_0.gacha_customspecial then
		return false
	end
	
	local var_3_1 = var_3_0.gacha_customspecial
	local var_3_2 = arg_3_0:isGachaCustomSpecialSecondHalf()
	local var_3_3 = 0
	
	for iter_3_0, iter_3_1 in pairs(var_3_1.select_list or {}) do
		if DB("character", iter_3_1, "id") then
			var_3_3 = var_3_3 + 1
		end
	end
	
	local var_3_4 = 4
	
	if var_3_2 then
		var_3_4 = 6
	end
	
	if arg_3_1.check_summon_count then
		if to_n(var_3_1.start_tm) > 0 then
			return true
		end
		
		if not arg_3_1.no_msg then
			balloon_message_with_sound(arg_3_1.err_text)
		end
		
		return false
	elseif var_3_4 <= var_3_3 then
		return true
	end
	
	if not arg_3_1.no_msg then
		balloon_message_with_sound(arg_3_1.err_text)
	end
	
	return false
end

function GachaUnit.enterGachaCustomSpecial(arg_4_0, arg_4_1)
	local var_4_0 = Account:getGachaShopInfo()
	local var_4_1 = var_4_0.gacha_customspecial
	
	arg_4_0.vars.last_gacha_customspecial_port1 = nil
	arg_4_0.vars.last_gacha_customspecial_port_id1 = nil
	arg_4_0.vars.last_gacha_customspecial_port2 = nil
	arg_4_0.vars.last_gacha_customspecial_port_id2 = nil
	arg_4_0.vars.gacha_mode = "gacha_customspecial"
	
	arg_4_0:saveSceneState(arg_4_0.vars.gacha_mode)
	
	arg_4_0.vars.element_mode = nil
	arg_4_0.vars.gsp_id = nil
	arg_4_1 = arg_4_1 or var_4_1
	
	if not arg_4_1 then
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	if arg_4_0:isEnabledGachaCustomSpecial() == nil then
		balloon_message_with_sound("buy_gacha.invalid_time")
		arg_4_0:showRightMenu(false, true)
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	local var_4_2 = arg_4_0.vars.ui_wnd:getChildByName("n_before")
	local var_4_3 = var_4_2:getChildByName("n_pickup_pos")
	
	var_4_3:removeAllChildren()
	var_4_2:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_4_0:prepareEnterGachaVisibleOff(var_4_2)
	arg_4_0:updateGachaTempInventoryCount()
	if_set_visible(var_4_2, "n_btn_summon_2", true)
	if_set_visible(var_4_2, "n_btn_rate", true)
	if_set_visible(var_4_2, "n_pickup", true)
	
	if get_cocos_refid(arg_4_0.vars.intro.m_biblika_node) then
		arg_4_0.vars.intro.m_biblika_node:setVisible(false)
	end
	
	if get_cocos_refid(arg_4_0.vars.intro.m_biblio_node) then
		arg_4_0.vars.intro.m_biblio_node:setVisible(false)
	end
	
	GachaIntroduceBG:setup("customSpecial", var_4_3, {
		nb = var_4_2,
		pickup_data = arg_4_1,
		gacha_shop_info = var_4_0
	})
	arg_4_0:showRightMenu(false)
	arg_4_0:updateGachaCustomSpecialSelected()
	arg_4_0:updateGachaCustomSpecialTime()
	Analytics:toggleTab("gacha_customspecial")
end

function GachaUnit.updateGachaCustomSpecialTime(arg_5_0)
	if not arg_5_0.vars or arg_5_0.vars.gacha_mode ~= "gacha_customspecial" then
		return 
	end
	
	if not get_cocos_refid(arg_5_0.vars.ui_wnd) then
		return 
	end
	
	local var_5_0 = os.time()
	local var_5_1 = arg_5_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos")
	local var_5_2 = Account:getGachaShopInfo()
	
	if not var_5_2 or not var_5_2.gacha_customspecial then
		return 
	end
	
	local var_5_3 = var_5_2.gacha_customspecial
	
	if not var_5_3.start_time or not var_5_3.end_time then
		return 
	end
	
	if not arg_5_0:isGachaCustomSpecialSecondHalf() and to_n(var_5_3.half_time) < to_n(var_5_3.end_time) then
		local var_5_4 = var_5_1:getChildByName("n_hero_time_info")
		local var_5_5 = to_n(var_5_3.half_time) - var_5_0
		
		if_set(var_5_4, "t_hero_time_info", T("ui_ct_gachaspecial_next_period_title", {
			remain_time = sec_to_string(var_5_5)
		}))
	end
end

function GachaUnit.popupChangeCustomSpecialSelect(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return 
	end
	
	local var_6_0 = 5
	
	if arg_6_1 == 4 or arg_6_1 == 6 then
		var_6_0 = 4
	end
	
	query("select_gacha_customspecial_list", {
		caller = "gacha_customspecial",
		grade = var_6_0,
		select_idx = arg_6_1
	})
end

function GachaUnit.changeCustomSpecialSelect(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = Account:getGachaShopInfo().gacha_customspecial
	
	if not var_7_0 or not var_7_0.select_list then
		return 
	end
	
	local var_7_1 = var_7_0.select_list[arg_7_1]
	
	if not var_7_1 or var_7_1 == "" then
		return 
	end
	
	for iter_7_0 = 1, 2 do
		if var_7_0.select_list[iter_7_0] == var_7_1 then
			return 
		end
	end
	
	query("change_gacha_customspecial", {
		caller = "gacha_customspecial",
		select_idx = arg_7_1
	})
end

function GachaUnit.updateGachaCustomSpecialSelectedInfo(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = Account:getGachaShopInfo().gacha_customspecial
	
	if arg_8_3 then
		for iter_8_0, iter_8_1 in pairs(var_8_0.select_list or {}) do
			if iter_8_1 == arg_8_1 then
				balloon_message_with_sound("ui_ct_char_select_info")
				
				return false
			end
		end
		
		return true
	end
	
	query("select_gacha_customspecial", {
		select_idx = arg_8_2,
		select_id = arg_8_1
	})
end

function GachaUnit.isGachaCustomSpecialSecondHalf(arg_9_0)
	local var_9_0 = Account:getGachaShopInfo().gacha_customspecial
	local var_9_1 = os.time()
	
	return to_n(var_9_0.half_time) > 0 and var_9_1 > to_n(var_9_0.half_time)
end

function GachaUnit.updateGachaCusomSpecialSelected(arg_10_0, arg_10_1)
	local var_10_0 = Account:getGachaShopInfo().gacha_customspecial
	
	var_10_0.select_list = arg_10_1
	
	if arg_10_1[1] and DB("character", arg_10_1[1], "id") then
		var_10_0.ceiling_character = arg_10_1[1]
	end
	
	if arg_10_1[2] and DB("character", arg_10_1[2], "id") then
		var_10_0.ceiling_character_cm4 = arg_10_1[2]
	end
	
	arg_10_0:updateGachaCustomSpecialSelected()
end

function GachaUnit.getGachaCustomRawListCode(arg_11_0, arg_11_1)
	local var_11_0 = Account:getGachaShopInfo().gacha_customspecial
	
	if not var_11_0 then
		return nil
	end
	
	for iter_11_0, iter_11_1 in pairs(var_11_0.raw_list or {}) do
		if iter_11_1.id == arg_11_1 then
			return iter_11_1
		end
	end
	
	return nil
end

function GachaUnit.updateGachaCustomSpecialSelected(arg_12_0, arg_12_1)
	local var_12_0 = Account:getGachaShopInfo().gacha_customspecial
	local var_12_1 = os.time()
	local var_12_2 = arg_12_0:isGachaCustomSpecialSecondHalf()
	local var_12_3 = arg_12_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos")
	local var_12_4 = var_12_3:getChildByName("n_hero_info_01")
	local var_12_5 = var_12_3:getChildByName("n_hero_info_02")
	local var_12_6 = {}
	
	if var_12_0.select_list then
		for iter_12_0 = 1, 6 do
			local var_12_7 = DB("character", var_12_0.select_list[iter_12_0], "name")
			
			if var_12_7 then
				var_12_6[iter_12_0] = var_12_7
			end
		end
	end
	
	local var_12_8 = to_n(var_12_0.start_tm) == 0
	local var_12_9 = to_n(var_12_0.start_tm2) == 0
	
	if_set_visible(var_12_4, "n_hero_01", true)
	if_set_visible(var_12_5, "n_hero_01", true)
	
	if var_12_6[3] then
		local var_12_10 = var_12_4:getChildByName("n_hero_01")
		
		UIUtil:getRewardIcon("c", var_12_0.select_list[3], {
			no_popup = true,
			name = false,
			show_color_with_role = true,
			grade = 5,
			no_tooltip = true,
			scale = 1,
			parent = var_12_10:getChildByName("n_hero_icon")
		})
		if_set_visible(var_12_10, "btn_click", false)
		if_set_visible(var_12_10, "btn_change", var_12_8)
		
		var_12_10:getChildByName("btn_change").select_idx = 3
		var_12_10:getChildByName("btn_select").select_idx = 3
		
		if var_12_6[1] == var_12_6[3] then
			var_12_10:setColor(tocolor("#ffffff"))
			if_set_visible(var_12_10, "n_select_eff", true)
			var_12_10:getChildByName("n_select_eff"):removeAllChildren()
			EffectManager:Play({
				loop = true,
				scale = 1,
				fn = "gacha_special_ceiling_select.cfx",
				layer = var_12_10:getChildByName("n_select_eff")
			})
		else
			if_set_visible(var_12_10, "n_select_eff", false)
			var_12_10:setColor(tocolor("#888888"))
		end
	else
		local var_12_11 = var_12_4:getChildByName("n_hero_01")
		
		UIUtil:getRewardIcon("c", "c2049", {
			no_popup = true,
			name = false,
			no_tooltip = true,
			grade = 5,
			face_question = true,
			scale = 1,
			parent = var_12_11:getChildByName("n_hero_icon")
		})
		if_set_visible(var_12_11, "btn_click", true)
		
		var_12_11:getChildByName("btn_click").select_idx = 3
		
		if_set_visible(var_12_11, "btn_change", false)
		
		var_12_11:getChildByName("btn_select").select_idx = 3
	end
	
	if var_12_6[4] then
		local var_12_12 = var_12_5:getChildByName("n_hero_01")
		
		UIUtil:getRewardIcon("c", var_12_0.select_list[4], {
			no_popup = true,
			name = false,
			show_color_with_role = true,
			grade = 4,
			no_tooltip = true,
			scale = 1,
			parent = var_12_12:getChildByName("n_hero_icon")
		})
		if_set_visible(var_12_12, "btn_click", false)
		if_set_visible(var_12_12, "btn_change", var_12_8)
		
		var_12_12:getChildByName("btn_change").select_idx = 4
		var_12_12:getChildByName("btn_select").select_idx = 4
		
		if var_12_6[2] == var_12_6[4] then
			var_12_12:setColor(tocolor("#ffffff"))
			if_set_visible(var_12_12, "n_select_eff", true)
			var_12_12:getChildByName("n_select_eff"):removeAllChildren()
			EffectManager:Play({
				loop = true,
				scale = 1,
				fn = "gacha_special_ceiling_select.cfx",
				layer = var_12_12:getChildByName("n_select_eff")
			})
		else
			if_set_visible(var_12_12, "n_select_eff", false)
			var_12_12:setColor(tocolor("#888888"))
		end
	else
		local var_12_13 = var_12_5:getChildByName("n_hero_01")
		
		UIUtil:getRewardIcon("c", "c6062", {
			no_popup = true,
			name = false,
			no_tooltip = true,
			grade = 4,
			face_question = true,
			scale = 1,
			parent = var_12_13:getChildByName("n_hero_icon")
		})
		if_set_visible(var_12_13, "btn_click", true)
		
		var_12_13:getChildByName("btn_click").select_idx = 4
		
		if_set_visible(var_12_13, "btn_change", false)
		
		var_12_13:getChildByName("btn_select").select_idx = 4
	end
	
	if var_12_2 then
		var_12_4:getChildByName("n_hero_01"):setPositionX(var_12_4:getChildByName("n_move_hero_01"):getPositionX())
		var_12_5:getChildByName("n_hero_01"):setPositionX(var_12_5:getChildByName("n_move_hero_01"):getPositionX())
		if_set_visible(var_12_4, "n_hero_02", true)
		if_set_visible(var_12_5, "n_hero_02", true)
		
		if var_12_6[5] then
			local var_12_14 = var_12_4:getChildByName("n_hero_02")
			
			UIUtil:getRewardIcon("c", var_12_0.select_list[5], {
				no_popup = true,
				name = false,
				show_color_with_role = true,
				grade = 5,
				no_tooltip = true,
				scale = 1,
				parent = var_12_14:getChildByName("n_hero_icon")
			})
			if_set_visible(var_12_14, "btn_click", false)
			if_set_visible(var_12_14, "btn_change", var_12_9)
			
			var_12_14:getChildByName("btn_change").select_idx = 5
			var_12_14:getChildByName("btn_select").select_idx = 5
			
			if var_12_6[1] == var_12_6[5] then
				var_12_14:setColor(tocolor("#ffffff"))
				if_set_visible(var_12_14, "n_select_eff", true)
				var_12_14:getChildByName("n_select_eff"):removeAllChildren()
				EffectManager:Play({
					loop = true,
					scale = 1,
					fn = "gacha_special_ceiling_select.cfx",
					layer = var_12_14:getChildByName("n_select_eff")
				})
			else
				if_set_visible(var_12_14, "n_select_eff", false)
				var_12_14:setColor(tocolor("#888888"))
			end
		else
			local var_12_15 = var_12_4:getChildByName("n_hero_02")
			
			UIUtil:getRewardIcon("c", "c2049", {
				no_popup = true,
				name = false,
				no_tooltip = true,
				grade = 5,
				face_question = true,
				scale = 1,
				parent = var_12_15:getChildByName("n_hero_icon")
			})
			if_set_visible(var_12_15, "btn_click", true)
			
			var_12_15:getChildByName("btn_click").select_idx = 5
			
			if_set_visible(var_12_15, "btn_change", false)
			
			var_12_15:getChildByName("btn_select").select_idx = 5
		end
		
		if var_12_6[6] then
			local var_12_16 = var_12_5:getChildByName("n_hero_02")
			
			UIUtil:getRewardIcon("c", var_12_0.select_list[6], {
				no_popup = true,
				name = false,
				show_color_with_role = true,
				grade = 4,
				no_tooltip = true,
				scale = 1,
				parent = var_12_16:getChildByName("n_hero_icon")
			})
			if_set_visible(var_12_16, "btn_click", false)
			if_set_visible(var_12_16, "btn_change", var_12_9)
			
			var_12_16:getChildByName("btn_change").select_idx = 6
			var_12_16:getChildByName("btn_select").select_idx = 6
			
			if var_12_6[2] == var_12_6[6] then
				var_12_16:setColor(tocolor("#ffffff"))
				if_set_visible(var_12_16, "n_select_eff", true)
				var_12_16:getChildByName("n_select_eff"):removeAllChildren()
				EffectManager:Play({
					loop = true,
					scale = 1,
					fn = "gacha_special_ceiling_select.cfx",
					layer = var_12_16:getChildByName("n_select_eff")
				})
			else
				if_set_visible(var_12_16, "n_select_eff", false)
				var_12_16:setColor(tocolor("#888888"))
			end
		else
			local var_12_17 = var_12_5:getChildByName("n_hero_02")
			
			UIUtil:getRewardIcon("c", "c6062", {
				no_popup = true,
				name = false,
				no_tooltip = true,
				grade = 4,
				face_question = true,
				scale = 1,
				parent = var_12_17:getChildByName("n_hero_icon")
			})
			if_set_visible(var_12_17, "btn_click", true)
			
			var_12_17:getChildByName("btn_click").select_idx = 6
			
			if_set_visible(var_12_17, "btn_change", false)
			
			var_12_17:getChildByName("btn_select").select_idx = 6
		end
	else
		if_set_visible(var_12_4, "n_hero_02", false)
		if_set_visible(var_12_5, "n_hero_02", false)
	end
	
	if var_12_6[1] then
		local var_12_18 = var_12_4:getChildByName("n_name")
		
		if_set(var_12_18, "t_name", T(var_12_6[1]))
		WidgetUtils:setupPopup({
			control = var_12_4:getChildByName("btn_hero_info"),
			creator = function()
				return UIUtil:getGachaCharacterPopup({
					grade = 5,
					skill_preview = true,
					code = var_12_0.select_list[1]
				})
			end
		})
		
		local var_12_19 = arg_12_0:getGachaCustomRawListCode(var_12_0.select_list[1])
		
		if var_12_19 and arg_12_1 and arg_12_1.idx == 1 then
			if arg_12_1.code then
				var_12_19.id = arg_12_1.code
			end
			
			if arg_12_1.pd then
				var_12_19.pd = arg_12_1.pd
			end
		end
		
		if_set_visible(var_12_4, "n_select_info", false)
		if_set_visible(var_12_4, "n_name", true)
	else
		if_set_visible(var_12_4, "n_select_info", true)
		if_set_visible(var_12_4, "n_name", false)
	end
	
	if var_12_6[2] then
		local var_12_20 = var_12_5:getChildByName("n_name")
		
		if_set(var_12_20, "t_name", T(var_12_6[2]))
		WidgetUtils:setupPopup({
			control = var_12_5:getChildByName("btn_hero_info"),
			creator = function()
				return UIUtil:getGachaCharacterPopup({
					grade = 4,
					skill_preview = true,
					code = var_12_0.select_list[2]
				})
			end
		})
		
		local var_12_21 = arg_12_0:getGachaCustomRawListCode(var_12_0.select_list[2])
		
		if var_12_21 and arg_12_1 and arg_12_1.idx == 2 then
			if arg_12_1.code then
				var_12_21.id = arg_12_1.code
			end
			
			if arg_12_1.pd then
				var_12_21.pd = arg_12_1.pd
			end
		end
		
		if_set_visible(var_12_5, "n_select_info", false)
		if_set_visible(var_12_5, "n_name", true)
	else
		if_set_visible(var_12_5, "n_select_info", true)
		if_set_visible(var_12_5, "n_name", false)
	end
	
	GachaIntroduceBG.CustomSpecial:updateSelectedList(var_12_0)
end

function GachaUnit.updateGachaCustomSpecialData(arg_15_0, arg_15_1)
	local var_15_0 = Account:getGachaShopInfo().gacha_customspecial
	
	if var_15_0 then
		var_15_0.summon_count = to_n(arg_15_1.count)
		var_15_0.start_tm = to_n(arg_15_1.start_tm)
		var_15_0.start_tm2 = to_n(arg_15_1.start_tm2)
	end
end
