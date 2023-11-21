function GachaUnit.enterGachaSpecial(arg_1_0, arg_1_1)
	if not arg_1_0.vars.gacha_special then
		arg_1_0:enterGachaRare()
		
		return 
	end
	
	arg_1_0:setTitle(nil, nil)
	
	arg_1_0.vars.gacha_mode = "gacha_special"
	
	arg_1_0:saveSceneState(arg_1_0.vars.gacha_mode)
	
	arg_1_0.vars.element_mode = nil
	
	local var_1_0 = Account:getGachaShopInfo()
	local var_1_1 = var_1_0.gacha.gacha_special
	local var_1_2 = arg_1_0.vars.ui_wnd:getChildByName("n_before")
	local var_1_3 = var_1_2:getChildByName("n_pickup_pos")
	
	var_1_3:removeAllChildren()
	var_1_2:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_1_0:prepareEnterGachaVisibleOff(var_1_2)
	arg_1_0:updateGachaTempInventoryCount()
	if_set_visible(var_1_2, "n_btn_summon_2", true)
	if_set_visible(var_1_2, "n_btn_rate", true)
	if_set_visible(var_1_2, "n_special", true)
	if_set_visible(var_1_2, "n_btn_book", true)
	
	if get_cocos_refid(arg_1_0.vars.intro.m_biblika_node) then
		arg_1_0.vars.intro.m_biblika_node:setVisible(false)
	end
	
	if get_cocos_refid(arg_1_0.vars.intro.m_biblio_node) then
		arg_1_0.vars.intro.m_biblio_node:setVisible(false)
	end
	
	arg_1_1 = arg_1_1 or var_1_0.gacha_special.current
	arg_1_0.vars.gsp_id = arg_1_1.gacha_special_id
	
	GachaIntroduceBG:setup("special", var_1_3, {
		nb = var_1_2,
		sp_info = arg_1_1,
		gacha_special = var_1_1
	})
	arg_1_0:showRightMenu(false)
	TopBarNew:checkhelpbuttonID("infogach_3")
	Analytics:toggleTab(arg_1_0.vars.gacha_mode)
end

function GachaUnit.selectGachaSpecialCeiling(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Account:getGachaShopInfo().gacha_special.current
	
	if arg_2_2 then
		if var_2_0.ceiling_character == arg_2_1 then
			balloon_message_with_sound("ui_gacha_special_hero_select_err")
			
			return false
		end
		
		return true
	end
	
	local var_2_1 = load_dlg("gacha_special_hero_get_p", true, "wnd")
	
	if_set(var_2_1, "disc", T("ui_gacha_special_hero_select_desc"))
	if_set(var_2_1, "t_gacha_info", T("summon_change_time_left", timeToStringDef({
		preceding_with_zeros = true,
		time = var_2_0.moonlight_end_time
	})))
	
	local var_2_2, var_2_3 = DB("character", arg_2_1, {
		"name",
		"grade"
	})
	
	if_set(var_2_1, "t_name", T(var_2_2))
	UIUtil:getRewardIcon("c", arg_2_1, {
		no_popup = true,
		name = false,
		show_color_with_role = true,
		no_tooltip = true,
		scale = 1,
		parent = var_2_1:getChildByName("n_mob_icon"),
		grade = var_2_3
	})
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_2_1,
		handler = function(arg_3_0, arg_3_1, arg_3_2)
			if arg_3_1 == "btn_yes" then
				query("select_gacha_special", {
					select_id = arg_2_1
				})
			elseif arg_3_1 == "btn_close" then
				return "dont_close"
			end
		end
	})
	if_set_visible(var_2_1, "n_title", true)
	if_set(var_2_1, "t_title", T("ui_gacha_special_hero_select_title"))
end

function GachaUnit.popupChangeSpecialCeiling(arg_4_0)
	query("select_gacha_special_list", {
		caller = "gacha_special"
	})
end

function GachaUnit.updateSpecialGachaSelected(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Account:getGachaShopInfo().gacha_special.current
	
	if not arg_5_1 then
		arg_5_1 = var_5_0.gs_grade
	else
		var_5_0.gs_grade = arg_5_1
	end
	
	if arg_5_2 then
		var_5_0.ceiling_character = arg_5_2
	end
	
	arg_5_0:updateSpecialInfo()
	
	local var_5_1 = arg_5_0.vars.ui_wnd:getChildByName("n_before")
	local var_5_2 = var_5_1:getChildByName("n_pickup_pos"):getChildByName("n_special")
	local var_5_3 = var_5_2:getChildByName("n_list")
	local var_5_4 = var_5_3:getChildByName("n_info_list_s01")
	
	if_set_visible(var_5_3, "n_info_list_s01", true)
	
	for iter_5_0 = 1, 2 do
		local var_5_5 = false
		
		if arg_5_1 == 5 and iter_5_0 == 1 then
			var_5_5 = true
		end
		
		if arg_5_1 == 4 and iter_5_0 == 2 then
			var_5_5 = true
		end
		
		local var_5_6 = var_5_4:getChildByName("n_info" .. iter_5_0 .. "/2")
		local var_5_7 = var_5_6:getChildByName("n_select_" .. iter_5_0)
		
		if get_cocos_refid(var_5_7) then
			var_5_7:removeAllChildren()
		end
		
		if var_5_5 then
			var_5_6:setColor(tocolor("#ffffff"))
			if_set_visible(var_5_6, "n_select_" .. iter_5_0, true)
			
			if get_cocos_refid(var_5_7) then
				EffectManager:Play({
					loop = true,
					scale = 1,
					fn = "gacha_special_ceiling_select.cfx",
					layer = var_5_7
				})
			end
		else
			var_5_6:setColor(tocolor("#888888"))
		end
	end
	
	local var_5_8 = arg_5_0:getCeilingData("gacha_special")
	local var_5_9 = var_5_1:getChildByName("n_pickup_ceiling_info")
	
	if var_5_9 then
		if var_5_8.ceiling_character and var_5_8.ceiling_count and to_n(var_5_8.ceiling_count) > 0 then
			local var_5_10 = to_n(var_5_8.ceiling_count) - to_n(var_5_8.ceiling_current)
			
			if tolua:type(var_5_9:getChildByName("txt_count")) ~= "ccui.RichText" then
				upgradeLabelToRichLabel(var_5_9, "txt_count"):ignoreContentAdaptWithSize(true)
			end
			
			local var_5_11 = DB("character", var_5_8.ceiling_character, {
				"name"
			})
			
			if var_5_10 == 0 then
				if_set(var_5_9, "txt_count", T(var_5_8.ceiling_text_full, {
					character_name = T(var_5_11)
				}))
				if_set_width_from(var_5_9, "tooltip_info", "txt_count", {
					add = 60,
					ratio = 1
				})
			else
				if_set(var_5_9, "txt_count", T(var_5_8.ceiling_text, {
					count = var_5_10,
					character_name = T(var_5_11)
				}))
				if_set_width_from(var_5_9, "tooltip_info", "txt_count", {
					add = 60,
					ratio = 1
				})
			end
			
			var_5_9:setVisible(true)
		else
			var_5_9:setVisible(false)
		end
	end
	
	if var_5_8.ceiling_character and var_5_8.ceiling_portrait_data then
		arg_5_0:setPickupPortrait(var_5_2:getChildByName("n_portrait_r"), var_5_8.ceiling_character, var_5_8.ceiling_portrait_data)
	end
	
	if var_5_8.ceiling_character then
		if_set(var_5_2, "selected_hero_name", T(DB("character", var_5_8.ceiling_character, {
			"name"
		})))
	end
	
	if var_5_8.ceiling_character then
		arg_5_0:setRecommendTag(var_5_1, var_5_8.ceiling_character)
	end
	
	if arg_5_2 then
		GachaIntroduceBG.Special:updateSelectedList({
			var_5_0.ceiling_character,
			var_5_0.ceiling_character_cm4
		})
	end
end

function GachaUnit.setSpecialGachaCeillingGrade(arg_6_0, arg_6_1)
	local var_6_0 = Account:getGachaShopInfo()
	local var_6_1 = var_6_0.gacha_special.current
	local var_6_2 = to_n(var_6_1.gs_grade or 5)
	
	if var_6_2 == 0 or var_6_2 == arg_6_1 then
		return 
	end
	
	if os.time() < to_n(var_6_1.gs4_unlock_tm) then
		balloon_message_with_sound("err_gacha_special_not_available_now")
		
		return 
	end
	
	local var_6_3 = load_dlg("gacha_special_hero_get_p", true, "wnd")
	local var_6_4
	local var_6_5
	local var_6_6
	
	if arg_6_1 == 4 then
		var_6_4 = var_6_1.ceiling_character_cm4
		
		if_set(var_6_3, "disc", T("ui_popup_ceiling_character_ml4_confirm_desc"))
		
		var_6_5 = var_6_0.pickup_ceiling[var_6_1.ceiling_group_cm4]
		var_6_6 = to_n(var_6_1.ceiling_count_cm4)
	elseif arg_6_1 == 5 then
		var_6_4 = var_6_1.ceiling_character
		
		if_set(var_6_3, "disc", T("ui_popup_ceiling_character_ml5_confirm_desc"))
		
		var_6_5 = var_6_0.pickup_ceiling[var_6_1.ceiling_group]
		var_6_6 = to_n(var_6_1.ceiling_count)
	else
		return 
	end
	
	if var_6_5 then
		var_6_6 = var_6_6 - to_n(var_6_5.current)
	end
	
	if var_6_6 == 0 then
		if_set(var_6_3, "t_gacha_info", T("ui_popup_ceiling_character_count_full"))
	else
		if_set(var_6_3, "t_gacha_info", T("ui_popup_ceiling_character_count", {
			count = var_6_6
		}))
	end
	
	local var_6_7, var_6_8 = DB("character", var_6_4, {
		"name",
		"grade"
	})
	
	if_set(var_6_3, "t_name", T(var_6_7))
	UIUtil:getRewardIcon("c", var_6_4, {
		no_popup = true,
		name = false,
		show_color_with_role = true,
		no_tooltip = true,
		scale = 1,
		parent = var_6_3:getChildByName("n_mob_icon"),
		grade = var_6_8
	})
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_6_3,
		handler = function(arg_7_0, arg_7_1, arg_7_2)
			if arg_7_1 == "btn_yes" then
				query("select_gacha_special_grade", {
					gsp_id = var_6_1.gacha_special_id,
					grade = var_6_8
				})
			elseif arg_7_1 == "btn_close" then
				return "dont_close"
			end
		end
	})
	if_set_visible(var_6_3, "n_title", true)
	if_set(var_6_3, "t_title", T("ui_popup_ceiling_character_confirm_title"))
end

function GachaUnit.changeSpecialInfo(arg_8_0, arg_8_1)
	if not arg_8_0.vars.gacha_special_preview then
		arg_8_0.vars.gacha_special_preview = 1
	end
	
	local var_8_0 = arg_8_0.vars.gacha_special_preview
	
	if arg_8_1 then
		arg_8_0.vars.gacha_special_preview = arg_8_0.vars.gacha_special_preview + 1
	else
		arg_8_0.vars.gacha_special_preview = arg_8_0.vars.gacha_special_preview - 1
	end
	
	if arg_8_0.vars.gacha_special_preview > 2 then
		arg_8_0.vars.gacha_special_preview = 2
	end
	
	if arg_8_0.vars.gacha_special_preview < 1 then
		arg_8_0.vars.gacha_special_preview = 1
	end
	
	if var_8_0 ~= arg_8_0.vars.gacha_special_preview then
		arg_8_0:updateSpecialInfo()
		arg_8_0:toggleSpecialInfo(true)
	end
end

function GachaUnit.updateSpecialInfo(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos"):getChildByName("n_special")
	local var_9_1 = var_9_0:getChildByName("n_special_info")
	local var_9_2
	
	if arg_9_1 then
		if get_cocos_refid(arg_9_0.vars.gacha_special_info_p) then
			var_9_2 = arg_9_0.vars.gacha_special_info_p:getChildByName("n_special_infolist")
		end
	else
		var_9_2 = var_9_0:getChildByName("n_list")
	end
	
	local var_9_3 = var_9_2:getChildByName("btn_special_next")
	local var_9_4 = var_9_2:getChildByName("btn_special_return")
	local var_9_5 = var_9_2:getChildByName("txt_disc")
	local var_9_6 = Account:getGachaShopInfo()
	
	if not var_9_6 then
		return 
	end
	
	local var_9_7
	local var_9_8
	
	if arg_9_1 then
		if not arg_9_0.vars.gacha_special_preview then
			arg_9_0.vars.gacha_special_preview = 1
		end
		
		local var_9_9 = arg_9_0.vars.gacha_special_preview
		local var_9_10 = ""
		local var_9_11 = ""
		local var_9_12
		
		if var_9_9 == 1 then
			var_9_10 = "current"
			var_9_12 = "ui_gacha_special_now_lineup"
		else
			var_9_10 = "next"
			var_9_12 = "ui_gacha_special_next_lineup"
		end
		
		var_9_7 = var_9_6.gacha_special[var_9_10]
		var_9_8 = var_9_6.gacha_special_detail[var_9_10]
		
		if_set_visible(var_9_0, "n_btn_special_info", true)
		if_set_visible(var_9_0, "n_special_infolist", false)
		if_set_visible(var_9_2, "btn_special_next", var_9_9 == 1)
		if_set_visible(var_9_2, "btn_special_return", var_9_9 == 2)
		if_set(var_9_2, "txt_disc", T(var_9_12))
	else
		var_9_7 = var_9_6.gacha_special.current
		var_9_8 = var_9_6.gacha_special_detail.current
	end
	
	if not var_9_7 or not var_9_8 then
		return 
	end
	
	local var_9_13 = os.time()
	local var_9_14
	
	if arg_9_0.vars.gacha_special_preview == 1 and arg_9_1 then
		var_9_14 = T("special_until_time", {
			remain_time = sec_to_full_string(var_9_7.end_time - var_9_13)
		})
	else
		var_9_14 = T("ui_gacha_special_change_time", timeToStringDef({
			preceding_with_zeros = true,
			time = var_9_7.start_time
		}))
	end
	
	if_set(var_9_2, "txt_hero_time", var_9_14)
	if_set(var_9_2, "t_hero_time", T("special_until_time", {
		remain_time = sec_to_full_string(var_9_7.moonlight_end_time - var_9_13)
	}))
	if_set(var_9_2, "txt_hero_time1", T("special_until_time", {
		remain_time = sec_to_full_string(var_9_7.moonlight_end_time - var_9_13)
	}))
	if_set(var_9_2, "txt_hero_time2", T("special_until_time", {
		remain_time = sec_to_full_string(var_9_7.moonlight4_end_time - var_9_13)
	}))
	if_set(var_9_2, "txt_time_s02", T("special_until_time", {
		remain_time = sec_to_full_string(var_9_7.end_time - var_9_13)
	}))
	
	local var_9_15 = var_9_2:getChildByName("n_info_list_s01")
	
	if_set_visible(var_9_2, "n_info_list_s01", true)
	arg_9_0:setSpecialGradeMoonlight(var_9_15, var_9_8, arg_9_1)
	
	local var_9_16 = var_9_2:getChildByName("n_info_list_s02")
	
	if get_cocos_refid(var_9_16) then
		arg_9_0:setSpecialGradeNormals(var_9_16, var_9_2, var_9_8)
	end
end

function GachaUnit.updateSpecialGachaTime(arg_10_0, arg_10_1)
	if arg_10_0.vars == nil or arg_10_0.vars.gacha_mode ~= "gacha_special" then
		return 
	end
	
	local var_10_0 = Account:getGachaShopInfo()
	
	if not var_10_0 or not var_10_0.gacha_special or not var_10_0.gacha_special.current then
		return 
	end
	
	local var_10_1
	
	if arg_10_1 then
		var_10_1 = var_10_0.gacha_special.next
	else
		var_10_1 = var_10_0.gacha_special.current
	end
	
	if not var_10_1 then
		return 
	end
	
	local var_10_2 = arg_10_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos"):getChildByName("n_special")
	local var_10_3 = var_10_2:getChildByName("n_special_info")
	local var_10_4
	
	if arg_10_1 then
		var_10_4 = var_10_2:getChildByName("n_special_infolist")
	else
		var_10_4 = var_10_2:getChildByName("n_list")
	end
	
	local var_10_5 = os.time()
	
	if var_10_1.moonlight_end_time - var_10_5 > 0 then
		if_set(var_10_4, "t_hero_time", T("special_until_time", {
			remain_time = sec_to_full_string(var_10_1.moonlight_end_time - var_10_5)
		}))
		if_set(var_10_4, "txt_hero_time1", T("special_until_time", {
			remain_time = sec_to_full_string(var_10_1.moonlight_end_time - var_10_5)
		}))
	else
		if_set(var_10_4, "t_hero_time", T("expired"))
		if_set(var_10_4, "txt_hero_time1", T("expired"))
	end
	
	if var_10_1.moonlight4_end_time - var_10_5 > 0 then
		if_set(var_10_4, "txt_hero_time2", T("special_until_time", {
			remain_time = sec_to_full_string(var_10_1.moonlight4_end_time - var_10_5)
		}))
	else
		if_set(var_10_4, "txt_hero_time2", T("expired"))
	end
	
	if var_10_1.end_time - var_10_5 > 0 then
		if_set(var_10_4, "txt_time_s02", T("special_until_time", {
			remain_time = sec_to_full_string(var_10_1.end_time - var_10_5)
		}))
	else
		if_set(var_10_4, "txt_time_s02", T("expired"))
	end
	
	local var_10_6 = var_10_0.gacha_special.current
	local var_10_7 = var_10_2:getChildByName("n_date_special")
	
	if var_10_6.end_time - var_10_5 > 0 then
		if_set(var_10_7, "disc", T("special_normal_remain", {
			remain_time = sec_to_full_string(var_10_6.end_time - var_10_5)
		}))
	else
		if_set(var_10_7, "disc", T("expired"))
	end
end

function GachaUnit.setSpecialGradeNormals(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	for iter_11_0 = 1, 16 do
		if_set_visible(arg_11_1, "n_info" .. iter_11_0, false)
	end
	
	local var_11_0 = {}
	
	for iter_11_1 = 5, 1, -1 do
		local var_11_1 = arg_11_3["cn" .. iter_11_1]
		
		if var_11_1 then
			for iter_11_2, iter_11_3 in pairs(var_11_1) do
				if DB("character", iter_11_3.code, {
					"moonlight"
				}) ~= "y" then
					table.push(var_11_0, {
						code = iter_11_3.code,
						np = iter_11_3.np
					})
				end
			end
		end
		
		local var_11_2 = arg_11_3["e" .. iter_11_1]
		
		if var_11_2 then
			for iter_11_4, iter_11_5 in pairs(var_11_2) do
				table.push(var_11_0, {
					code = iter_11_5.code,
					np = iter_11_5.np
				})
			end
		end
	end
	
	for iter_11_6, iter_11_7 in pairs(var_11_0) do
		local var_11_3 = arg_11_1:getChildByName("n_info" .. iter_11_6)
		
		if var_11_3 then
			var_11_3:setVisible(true)
			arg_11_0:setSpecial(var_11_3, iter_11_7, {
				use_grade = true
			})
		end
	end
end

function GachaUnit.getGachaSpecialMoonlightCodes(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = {}
	local var_12_1 = {}
	
	table.push(var_12_1, arg_12_1.ceiling_character)
	
	if arg_12_3 then
		for iter_12_0, iter_12_1 in pairs(arg_12_1.change_list or {}) do
			if iter_12_1 ~= arg_12_1.ceiling_character then
				table.push(var_12_1, iter_12_1)
			end
		end
	end
	
	table.push(var_12_1, arg_12_1.ceiling_character_cm4)
	
	for iter_12_2, iter_12_3 in pairs(var_12_1) do
		local var_12_2
		
		for iter_12_4 = 5, 4, -1 do
			local var_12_3 = arg_12_2["cn" .. iter_12_4]
			
			if var_12_3 then
				for iter_12_5, iter_12_6 in pairs(var_12_3) do
					if iter_12_3 == iter_12_6.code then
						var_12_2 = iter_12_6.np
						
						break
					end
				end
			end
		end
		
		table.push(var_12_0, {
			code = iter_12_3,
			np = var_12_2
		})
	end
	
	return var_12_0
end

function GachaUnit.setSpecialGradeMoonlight(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0
	local var_13_1 = Account:getGachaShopInfo()
	local var_13_9, var_13_10
	
	if arg_13_3 then
		local var_13_2 = arg_13_0.vars.gacha_special_preview
		local var_13_3 = ""
		local var_13_4 = var_13_2 == 1 and "current" or "next"
		local var_13_5 = var_13_1.gacha_special[var_13_4]
		
		var_13_0 = arg_13_0:getGachaSpecialMoonlightCodes(var_13_5, arg_13_2, true)
		
		for iter_13_0 = 1, 5 do
			if_set_visible(arg_13_1, "n_info0" .. iter_13_0, false)
		end
		
		for iter_13_1 = 1, 5 do
			if var_13_0[iter_13_1] then
				local var_13_6 = arg_13_1:getChildByName("n_info0" .. iter_13_1)
				
				if get_cocos_refid(var_13_6) then
					var_13_6:setVisible(true)
					
					local var_13_7
					local var_13_8 = arg_13_1:getChildByName("btn_hero_info_" .. iter_13_1)
					
					if not arg_13_3 and get_cocos_refid(var_13_8) then
						var_13_7 = var_13_8
					end
					
					arg_13_0:setSpecial(var_13_6, var_13_0[iter_13_1], {
						use_grade = true,
						idx = iter_13_1,
						popup_control = var_13_7,
						special_select = not arg_13_3,
						sp_info = var_13_5
					})
				end
			end
		end
	else
		var_13_9 = var_13_1.gacha_special.current
		var_13_10 = to_n(var_13_9.gs_grade or 5)
		var_13_0 = arg_13_0:getGachaSpecialMoonlightCodes(var_13_9, arg_13_2)
		
		for iter_13_2 = 1, 2 do
			local var_13_11 = arg_13_1:getChildByName("n_info" .. iter_13_2 .. "/2")
			
			var_13_11:setVisible(true)
			
			local var_13_12
			local var_13_13 = arg_13_1:getChildByName("btn_hero_info_" .. iter_13_2)
			
			arg_13_0:setSpecial(var_13_11, var_13_0[iter_13_2], {
				use_grade = true,
				idx = iter_13_2,
				popup_control = var_13_12,
				special_select = not arg_13_3,
				selected_gs_grade = var_13_10,
				sp_info = var_13_9
			})
		end
	end
	
	return var_13_0
end

function GachaUnit.popupSpecialCeilingCharacter(arg_14_0, arg_14_1)
	local var_14_0 = Account:getGachaShopInfo().gacha_special.current
	
	if not var_14_0 then
		return 
	end
	
	local var_14_1
	local var_14_2
	
	if arg_14_1 == 1 then
		var_14_1 = var_14_0.ceiling_character
		var_14_2 = 5
	elseif arg_14_1 == 2 then
		var_14_1 = var_14_0.ceiling_character_cm4
		var_14_2 = 4
	end
	
	if not var_14_1 then
		return 
	end
	
	local var_14_3 = UIUtil:getGachaCharacterPopup({
		skill_preview = true,
		code = var_14_1,
		grade = var_14_2
	})
	
	WidgetUtils:showPopup({
		popup = var_14_3
	})
end

function GachaUnit.setSpecial(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_3 = arg_15_3 or {}
	
	local var_15_0 = arg_15_2.code
	local var_15_1 = arg_15_3.no_preview or arg_15_2.np == "y"
	local var_15_2 = arg_15_3.is_new
	local var_15_3 = arg_15_3.count
	local var_15_4 = arg_15_3.use_grade
	local var_15_5 = arg_15_3.popup_delay
	local var_15_6 = arg_15_3.idx
	local var_15_7 = arg_15_3.no_skill_preview ~= true
	local var_15_8 = arg_15_3.sp_info
	
	if_set_visible(arg_15_1, "n_element", false)
	if_set_visible(arg_15_1, "btn_select", arg_15_3.use_btn_select)
	if_set_visible(arg_15_1, "img_new", var_15_2 == true)
	if_set_visible(arg_15_1, "txt_count", var_15_3)
	
	if var_15_3 and to_n(var_15_3) > 0 then
		if_set(arg_15_1, "txt_count", var_15_3)
	end
	
	if string.starts(var_15_0, "c") then
		local var_15_9, var_15_10, var_15_11, var_15_12, var_15_13 = DB("character", var_15_0, {
			"name",
			"role",
			"grade",
			"moonlight",
			"ch_attribute"
		})
		
		if_set(arg_15_1, "txt_name", T(var_15_9))
		
		local var_15_14
		local var_15_15 = var_15_11 == 5 and "t_hero_name_1" or "t_hero_name_2"
		
		if_set(arg_15_1, var_15_15, T(var_15_9))
		
		local var_15_16 = arg_15_1:getChildByName("n_icon_hero")
		local var_15_17 = UIUtil:getRewardIcon("c", var_15_0, {
			no_popup = true,
			name = false,
			show_color_with_role = true,
			no_tooltip = true,
			scale = 1,
			parent = var_15_16,
			no_grade = var_15_4 ~= true,
			grade = var_15_11
		})
		
		if not var_15_1 then
			if_set_visible(arg_15_1, "btn_preview", false)
			WidgetUtils:setupPopup({
				control = arg_15_3.popup_control or var_15_17,
				creator = function()
					return UIUtil:getGachaCharacterPopup({
						code = var_15_0,
						grade = var_15_11,
						skill_preview = var_15_7
					})
				end,
				delay = var_15_5
			})
		else
			if_set_visible(arg_15_1, "btn_preview", true)
		end
		
		if arg_15_3.selected_gs_grade then
			if arg_15_3.selected_gs_grade == var_15_11 then
				arg_15_1:setColor(tocolor("#ffffff"))
			else
				arg_15_1:setColor(tocolor("#888888"))
			end
		end
		
		if arg_15_3.special_select then
			if_set_visible(arg_15_1, "btn_select", true)
			
			local var_15_18 = arg_15_1:getChildByName("btn_select")
			
			if get_cocos_refid(var_15_18) then
				var_15_18:setName("btn_select:" .. var_15_11)
			end
			
			if var_15_0 == var_15_8.ceiling_character then
				if var_15_8.change_list then
					if_set_visible(arg_15_1, "btn_change", true)
					if_set_visible(arg_15_1, "n_badge", false)
				else
					if_set_visible(arg_15_1, "btn_change", false)
					if_set_visible(arg_15_1, "n_badge", true)
					if_set_visible(arg_15_1:getChildByName("n_badge"), "new", true)
				end
			end
		end
	else
		local var_15_19, var_15_20 = DB("equip_item", var_15_0, {
			"name",
			"artifact_grade"
		})
		local var_15_21 = arg_15_1:getChildByName("n_icon_arti")
		local var_15_22 = UIUtil:getRewardIcon(nil, var_15_0, {
			no_popup = true,
			name = false,
			no_tooltip = true,
			role = true,
			scale = 1,
			parent = var_15_21,
			no_grade = var_15_4 ~= true,
			grade = var_15_20
		})
		local var_15_23 = EQUIP:createByInfo({
			code = var_15_0
		})
		
		if not var_15_1 then
			if_set_visible(arg_15_1, "btn_preview", false)
			WidgetUtils:setupPopup({
				control = arg_15_3.popup_control or var_15_22,
				creator = function()
					return ItemTooltip:getItemTooltip({
						artifact_popup = true,
						code = var_15_0,
						grade = var_15_20,
						equip = var_15_23,
						equip_stat = var_15_23.stats,
						show_max_check_box = not GachaTempInventory:isOpen()
					})
				end,
				delay = var_15_5
			})
		else
			if_set_visible(arg_15_1, "btn_preview", true)
		end
	end
end

function GachaUnit.toggleSpecialInfo(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.vars.ui_wnd or not get_cocos_refid(arg_18_0.vars.ui_wnd) then
		return 
	end
	
	local var_18_0 = Account:getGachaShopInfo()
	
	if not var_18_0 or not var_18_0.gacha_special then
		return 
	end
	
	if not var_18_0.gacha_special.next then
		balloon_message_with_sound("gacha_special_nonextdata")
		
		return 
	end
	
	if not get_cocos_refid(arg_18_0.vars.gacha_special_info_p) then
		local var_18_1 = load_control("wnd/gacha_special_info_p.csb", true)
		
		BackButtonManager:push({
			check_id = "gacha_special_info_p",
			back_func = function()
				arg_18_0:closeSpecialInfo()
			end,
			dlg = var_18_1
		})
		SceneManager:getRunningNativeScene():addChild(var_18_1)
		var_18_1:setPosition(0, 0)
		
		arg_18_0.vars.gacha_special_info_p = var_18_1
		arg_18_0.vars.gacha_special_preview = 1
	end
	
	if not arg_18_2 then
		arg_18_0:updateSpecialInfo(true)
	end
end

function GachaUnit.closeSpecialInfo(arg_20_0)
	if not arg_20_0.vars.ui_wnd or not get_cocos_refid(arg_20_0.vars.ui_wnd) then
		return 
	end
	
	if get_cocos_refid(arg_20_0.vars.gacha_special_info_p) then
		BackButtonManager:pop({
			check_id = "gacha_special_info_p",
			dlg = arg_20_0.vars.gacha_special_info_p
		})
		arg_20_0.vars.gacha_special_info_p:removeFromParent()
		
		arg_20_0.vars.gacha_special_info_p = nil
	end
end
