GachaUnit = GachaUnit or {}

function GachaUnit.gachaRate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if not arg_1_0.gacha_rate then
		arg_1_0.gacha_rate = {}
	end
	
	arg_1_1 = arg_1_1 or arg_1_0.vars.gacha_mode
	
	local var_1_0
	local var_1_1
	
	arg_1_1, var_1_1 = arg_1_0:parseGachaId(arg_1_1)
	
	if arg_1_2 then
		arg_1_1 = var_1_1[arg_1_2]
	end
	
	local var_1_2 = Account:getGachaShopInfo()
	local var_1_3
	
	for iter_1_0, iter_1_1 in pairs(var_1_2.pickup) do
		if iter_1_1.gacha_id == arg_1_1 then
			var_1_3 = T(iter_1_1.name)
			
			break
		end
	end
	
	if arg_1_1 == "gacha_customgroup" and arg_1_0:checkGachaCustomGroupSelectCompleted({
		err_text = "gacha_customgroup_unlock_info_msg"
	}) ~= true then
		return 
	elseif arg_1_1 == "gacha_customspecial" and arg_1_0:checkGachaCustomSpecialSelectCompleted({
		err_text = "ui_ct_gacha_rate_err"
	}) ~= true then
		return 
	end
	
	if arg_1_1 == "gacha_substory" and var_1_2.gacha_substory and var_1_2.gacha_substory.right_character then
		local var_1_4 = DB("character", var_1_2.gacha_substory.right_character, {
			"name"
		})
		
		var_1_3 = T("gacha_substory_rate", {
			char_name = T(var_1_4)
		})
	end
	
	if not arg_1_3 then
		arg_1_0.gacha_rate[arg_1_1] = {}
		
		local var_1_5 = {
			item = arg_1_1
		}
		
		if arg_1_0:isMoonlightBonus() then
			var_1_5.gacha_moonlight_bonus = 1
		end
		
		query("gacha_rate_info", var_1_5)
		
		return 
	end
	
	arg_1_0.wnd_gacha_rate_info = nil
	
	if arg_1_1 == "gacha_special" then
		arg_1_0.wnd_gacha_rate_info = load_dlg("gacha_info_special", true, "wnd")
		
		if_set(arg_1_0.wnd_gacha_rate_info, "txt_title", T(arg_1_1 .. "_rate"))
		
		local var_1_6 = arg_1_0.wnd_gacha_rate_info:getChildByName("scrollview")
		
		var_1_6:setContentSize(350, 565)
		var_1_6:setInnerContainerSize({
			width = 350,
			height = 300
		})
		
		local var_1_7 = load_control("wnd/gacha_info_header_bar.csb")
		
		var_1_7:setPosition(0, 20)
		
		for iter_1_2 = 1, 6 do
			if_set_visible(var_1_7, "n_item" .. iter_1_2, false)
		end
		
		if_set_visible(var_1_7, "txt_title", false)
		if_set_visible(var_1_7, "bg", false)
		if_set_visible(var_1_7, "t_h1", false)
		if_set_visible(var_1_7, "t_h2", false)
		if_set_visible(var_1_7, "txt_random_shop", true)
		
		local var_1_8 = var_1_7:getChildByName("txt_random_shop")
		
		if_set(var_1_7, "txt_random_shop", T("ui_gacha_special_rate_ceiling_desc"))
		
		local var_1_9 = var_1_8:getContentSize().height * var_1_8:getScaleY() - 60
		
		var_1_8:setPositionY(var_1_8:getPositionY() - var_1_9 / 2)
		var_1_6:addChild(var_1_7)
		
		local var_1_10 = var_1_7:getChildByName("bar")
		local var_1_11 = var_1_7:getChildByName("n_item1"):getPositionY() + (40 - var_1_9)
		
		var_1_10:setPositionY(var_1_11)
		
		local var_1_12 = var_1_6:getInnerContainerSize()
		local var_1_13 = arg_1_0:gachaRateInfoItem(nil, arg_1_1, {
			"cn",
			"e"
		}, nil, nil, true) + 20 + 100 + var_1_9
		
		var_1_7:setPosition(0, var_1_13 - 370)
		arg_1_0:gachaRateInfoItem(var_1_6, arg_1_1, {
			"cn",
			"e"
		}, var_1_13 - 100 - var_1_9, 0, true)
		var_1_6:setInnerContainerSize({
			width = var_1_12.width,
			height = var_1_13 + 10
		})
	elseif string.starts(arg_1_1, "sp_") then
		arg_1_0.wnd_gacha_rate_info = load_dlg("gacha_info_special", true, "wnd")
		
		if_set(arg_1_0.wnd_gacha_rate_info, "txt_title", T("ui_randomitem_included_list"))
		
		local var_1_14 = arg_1_0.gacha_rate[arg_1_1].view_list_sum
		local var_1_15 = arg_1_0.wnd_gacha_rate_info:getChildByName("scrollview")
		
		var_1_15:setContentSize(350, 565)
		var_1_15:setInnerContainerSize({
			width = 750,
			height = 300
		})
		
		local var_1_16, var_1_17 = arg_1_0:gachaRateInfoBar(nil, {
			"cn",
			"cm",
			"e"
		}, var_1_14)
		
		var_1_16:setContentSize({
			width = 350,
			height = 200
		})
		var_1_15:addChild(var_1_16)
		
		local var_1_18 = var_1_17
		local var_1_19 = var_1_16:getChildByName("bar")
		local var_1_20 = var_1_16:getChildByName("n_item" .. var_1_18):getPositionY() - 30
		
		var_1_19:setPositionY(var_1_20)
		
		local var_1_21 = var_1_15:getInnerContainerSize()
		local var_1_22 = arg_1_0:gachaRateInfoItem(nil, arg_1_1, {
			"cn",
			"cm",
			"e"
		}) + 80
		
		arg_1_0:gachaRateInfoItem(var_1_15, arg_1_1, {
			"cn",
			"cm",
			"e"
		}, var_1_22, 0)
		var_1_16:setPosition(0, var_1_22 - (255 - var_1_18 * 30))
		var_1_15:setInnerContainerSize({
			width = var_1_21.width,
			height = var_1_22 + 110 + var_1_18 * 30
		})
	elseif string.starts(arg_1_1, "gacha_select") then
		arg_1_0.wnd_gacha_rate_info = load_dlg("gacha_info_select", true, "wnd")
		
		if_set(arg_1_0.wnd_gacha_rate_info, "txt_title", T(arg_1_1 .. "_rate"))
		if_set(arg_1_0.wnd_gacha_rate_info, "txt_bottom", T("selectgacha_rate_info"))
		
		local var_1_23 = arg_1_0.wnd_gacha_rate_info:getChildByName("scrollview")
		
		var_1_23:setInnerContainerSize({
			width = 750,
			height = 300
		})
		
		local var_1_24 = var_1_23:getInnerContainerSize()
		local var_1_25 = arg_1_0:gachaRateInfoItem(nil, arg_1_1, {
			"cn"
		})
		local var_1_26 = arg_1_0:gachaRateInfoItem(nil, arg_1_1, {
			"e"
		})
		local var_1_27 = math.max(var_1_25, var_1_26) + 90
		
		arg_1_0:gachaRateInfoItem(var_1_23, arg_1_1, {
			"cn"
		}, var_1_27, 15, false, true)
		arg_1_0:gachaRateInfoItem(var_1_23, arg_1_1, {
			"e"
		}, var_1_27, 395, false, true)
		var_1_23:setInnerContainerSize({
			width = var_1_24.width,
			height = var_1_27
		})
	else
		if string.starts(arg_1_1, "gacha_start") or string.starts(arg_1_1, "gacha_story") then
			arg_1_0.wnd_gacha_rate_info = load_dlg("gacha_infor_dash", true, "wnd")
		elseif arg_1_1 == "gacha_spdash" then
			arg_1_0.wnd_gacha_rate_info = load_dlg("gacha_info_tab", true, "wnd")
		else
			arg_1_0.wnd_gacha_rate_info = load_dlg("gacha_info", true, "wnd")
		end
		
		if var_1_3 then
			if_set(arg_1_0.wnd_gacha_rate_info, "txt_title", var_1_3)
		elseif arg_1_1 == "gacha_moonlight" and arg_1_0:isMoonlightBonus() then
			if_set(arg_1_0.wnd_gacha_rate_info, "txt_title", T("gacha_moonlight_upgraded_title"))
		else
			if_set(arg_1_0.wnd_gacha_rate_info, "txt_title", T(arg_1_1 .. "_rate"))
		end
		
		local var_1_28 = arg_1_0.gacha_rate[arg_1_1].view_list_sum
		
		arg_1_0:setGachaRateItems(arg_1_1, var_1_28)
	end
	
	if arg_1_0.wnd_gacha_rate_info then
		Dialog:msgBox(nil, {
			dlg = arg_1_0.wnd_gacha_rate_info,
			handler = function(arg_2_0, arg_2_1, arg_2_2)
				if arg_2_1 == "btn_tab1" then
					if string.starts(arg_1_1, "gacha_start") then
						query("gacha_rate_info", {
							item = "gacha_start"
						})
					elseif string.starts(arg_1_1, "gacha_story") then
						query("gacha_rate_info", {
							item = arg_1_1
						})
					elseif arg_1_1 == "gacha_spdash" then
						query("gacha_rate_info", {
							item = arg_1_1
						})
					end
					
					return "dont_close"
				elseif arg_2_1 == "btn_tab2" then
					if string.starts(arg_1_1, "gacha_start") then
						query("gacha_rate_info", {
							item = "gacha_start_9"
						})
					elseif string.starts(arg_1_1, "gacha_story") then
						query("gacha_rate_info", {
							item = arg_1_1 .. "_9"
						})
					elseif arg_1_1 == "gacha_spdash" then
						query("gacha_rate_info", {
							item = arg_1_1 .. "_7"
						})
					end
					
					return "dont_close"
				elseif arg_2_1 == "btn_tab3" then
					if string.starts(arg_1_1, "gacha_start") then
						query("gacha_rate_info", {
							item = "gacha_start_10"
						})
					elseif string.starts(arg_1_1, "gacha_story") then
						query("gacha_rate_info", {
							item = arg_1_1 .. "_10"
						})
					elseif arg_1_1 == "gacha_spdash" then
						query("gacha_rate_info", {
							item = arg_1_1 .. "_8"
						})
					end
					
					return "dont_close"
				elseif arg_2_1 == "btn_tab4" then
					if arg_1_1 == "gacha_spdash" then
						query("gacha_rate_info", {
							item = arg_1_1 .. "_9"
						})
					end
					
					return "dont_close"
				elseif arg_2_1 == "btn_tab5" then
					if arg_1_1 == "gacha_spdash" then
						query("gacha_rate_info", {
							item = arg_1_1 .. "_10"
						})
					end
					
					return "dont_close"
				end
			end
		})
		SoundEngine:play("event:/ui/popup/tap")
	end
end

function GachaUnit.setGachaRateItems(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1 = arg_3_1 or arg_3_0.vars.gacha_mode
	
	local var_3_0, var_3_1 = arg_3_0:parseGachaId(arg_3_1)
	
	if string.starts(arg_3_1, "gacha_start") or string.starts(arg_3_1, "gacha_story") then
		local var_3_2 = string.split(var_3_0, "_")
		
		if var_3_2[#var_3_2] == "9" then
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", true)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", false)
		elseif var_3_2[#var_3_2] == "10" then
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", true)
		else
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", true)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", false)
		end
	elseif string.starts(arg_3_1, "gacha_spdash") then
		local var_3_3 = string.split(var_3_0, "_")
		
		if var_3_3[#var_3_3] == "7" then
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", true)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected4", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected5", false)
		elseif var_3_3[#var_3_3] == "8" then
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", true)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected4", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected5", false)
		elseif var_3_3[#var_3_3] == "9" then
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected4", true)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected5", false)
		elseif var_3_3[#var_3_3] == "10" then
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected4", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected5", true)
		else
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected1", true)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected2", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected3", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected4", false)
			if_set_visible(arg_3_0.wnd_gacha_rate_info, "n_selected5", false)
		end
	end
	
	local var_3_4 = arg_3_0.wnd_gacha_rate_info:getChildByName("scrollview")
	
	var_3_4:removeAllChildren()
	var_3_4:setVisible(true)
	var_3_4:setInnerContainerSize({
		width = 750,
		height = 300
	})
	
	local var_3_5, var_3_6 = arg_3_0:gachaRateInfoBar("hero", {
		"cn",
		"cm"
	}, arg_3_2)
	
	var_3_5:setContentSize({
		width = 350,
		height = 200
	})
	var_3_4:addChild(var_3_5)
	
	local var_3_7, var_3_8 = arg_3_0:gachaRateInfoBar("item_type_artifact", {
		"e"
	}, arg_3_2)
	
	var_3_7:setContentSize({
		width = 350,
		height = 200
	})
	var_3_4:addChild(var_3_7)
	
	local var_3_9 = math.max(var_3_6, var_3_8)
	local var_3_10 = var_3_5:getChildByName("bar")
	local var_3_11 = var_3_5:getChildByName("n_item" .. var_3_9):getPositionY() - 30
	
	var_3_10:setPositionY(var_3_11)
	
	local var_3_12 = var_3_7:getChildByName("bar")
	local var_3_13 = var_3_7:getChildByName("n_item" .. var_3_9):getPositionY() - 30
	
	var_3_12:setPositionY(var_3_13)
	
	local var_3_14 = var_3_4:getInnerContainerSize()
	local var_3_15 = arg_3_0:gachaRateInfoItem(nil, arg_3_1, {
		"cn",
		"cm"
	})
	local var_3_16 = arg_3_0:gachaRateInfoItem(nil, arg_3_1, {
		"e"
	})
	local var_3_17 = math.max(var_3_15, var_3_16) + 90
	
	arg_3_0:gachaRateInfoItem(var_3_4, arg_3_1, {
		"cn",
		"cm"
	}, var_3_17 + var_3_9 * 10, 15)
	arg_3_0:gachaRateInfoItem(var_3_4, arg_3_1, {
		"e"
	}, var_3_17 + var_3_9 * 10, 395)
	var_3_5:setPosition(15, var_3_17 - (255 - var_3_9 * 40))
	var_3_7:setPosition(395, var_3_17 - (255 - var_3_9 * 40))
	var_3_4:setInnerContainerSize({
		width = var_3_14.width,
		height = var_3_17 + 110 + var_3_9 * 40
	})
end

function GachaUnit.gachaRateInfoItem(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	arg_4_3 = arg_4_3 or {
		"cn",
		"cm",
		"e",
		"g"
	}
	
	local var_4_0 = 0
	local var_4_1
	
	for iter_4_0, iter_4_1 in pairs(arg_4_3) do
		for iter_4_2 = 5, 1, -1 do
			local var_4_2 = iter_4_1 .. iter_4_2
			local var_4_3 = arg_4_0.gacha_rate[arg_4_2].view_list[var_4_2]
			
			if var_4_3 then
				local var_4_4
				
				if arg_4_1 and arg_4_6 ~= true then
					var_4_0 = var_4_0 + 1
					
					local var_4_5 = load_control("wnd/gacha_info_item_bar.csb")
					
					if_set_visible(var_4_5, "n_grade", true)
					if_set_visible(var_4_5, "txt_grade_ratio", false)
					if_set_visible(var_4_5, "n_item", false)
					
					if iter_4_1 == "cm" then
						if_set(var_4_5, "txt_grade_name", T("gacha_category_rate_moonlight_hero_grade", {
							grade = iter_4_2
						}))
					elseif iter_4_1 == "cn" then
						if_set(var_4_5, "txt_grade_name", T("gacha_category_rate_hero_grade", {
							grade = iter_4_2
						}))
					elseif iter_4_1 == "mo" then
						if_set(var_4_5, "txt_grade_name", T("gacha_category_rate_monster_grade", {
							grade = iter_4_2
						}))
					elseif iter_4_1 == "e" then
						if_set(var_4_5, "txt_grade_name", T("gacha_category_rate_artifact_grade", {
							grade = iter_4_2
						}))
					elseif iter_4_1 == "g" then
						if_set(var_4_5, "txt_grade_name", T("gacha_category_rate_grade", {
							grade = iter_4_2
						}))
					end
					
					var_4_5:setPosition(arg_4_5, arg_4_4 - 25 * var_4_0)
					arg_4_1:addChild(var_4_5)
				end
				
				for iter_4_3, iter_4_4 in pairs(var_4_3) do
					var_4_0 = var_4_0 + 1
					
					local var_4_6
					
					if arg_4_1 then
						local var_4_7 = load_control("wnd/gacha_info_item_bar.csb")
						
						if_set_visible(var_4_7, "n_grade", false)
						if_set_visible(var_4_7, "n_item", true)
						
						if iter_4_1 == "cm" or iter_4_1 == "cn" or iter_4_1 == "mo" then
							if_set(var_4_7, "txt_item_name", T(DB("character", iter_4_4.code, "name")))
						elseif iter_4_1 == "e" then
							if_set(var_4_7, "txt_item_name", T(DB("equip_item", iter_4_4.code, "name")))
						elseif iter_4_1 == "g" then
							if string.starts(iter_4_4.code, "c") then
								if_set(var_4_7, "txt_item_name", T(DB("character", iter_4_4.code, "name")))
							else
								if_set(var_4_7, "txt_item_name", T(DB("equip_item", iter_4_4.code, "name")))
							end
						end
						
						if not arg_4_7 then
							if_set(var_4_7, "txt_item_ratio", (iter_4_4.ratio or "-") .. "%")
						else
							if_set_visible(var_4_7, "txt_item_ratio", false)
						end
						
						var_4_7:setPosition(arg_4_5, arg_4_4 - 25 * var_4_0)
						arg_4_1:addChild(var_4_7)
					end
				end
			end
		end
	end
	
	if var_4_0 < 25 then
		var_4_0 = 25
	end
	
	return 25 * var_4_0
end

function GachaUnit.gachaRateInfoBar(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = load_control("wnd/gacha_info_header_bar.csb")
	
	var_5_0:setPosition(0, 20)
	
	for iter_5_0 = 1, 6 do
		if_set_visible(var_5_0, "n_item" .. iter_5_0, false)
	end
	
	local var_5_1 = 1
	local var_5_2 = 0
	
	arg_5_2 = arg_5_2 or {
		"cn",
		"cm",
		"e",
		"g"
	}
	
	local var_5_3 = {
		e = 0,
		c = 0,
		g = 0
	}
	
	for iter_5_1, iter_5_2 in pairs(arg_5_2) do
		for iter_5_3 = 5, 1, -1 do
			local var_5_4 = iter_5_2 .. iter_5_3
			
			if arg_5_3[var_5_4] then
				local var_5_5 = var_5_0:getChildByName("n_item" .. var_5_1)
				
				if var_5_5 then
					if iter_5_2 == "cm" then
						var_5_3.c = var_5_3.c + 1
						
						if_set(var_5_5, "txt_name", T("gacha_category_rate_moonlight_hero_grade", {
							grade = iter_5_3
						}))
					elseif iter_5_2 == "cn" then
						var_5_3.c = var_5_3.c + 1
						
						if_set(var_5_5, "txt_name", T("gacha_category_rate_hero_grade", {
							grade = iter_5_3
						}))
					elseif iter_5_2 == "mo" then
						var_5_3.c = var_5_3.c + 1
						
						if_set(var_5_5, "txt_name", T("gacha_category_rate_monster_grade", {
							grade = iter_5_3
						}))
					elseif iter_5_2 == "e" then
						var_5_3.e = var_5_3.e + 1
						
						if_set(var_5_5, "txt_name", T("gacha_category_rate_artifact_grade", {
							grade = iter_5_3
						}))
					elseif iter_5_2 == "g" then
						var_5_3.g = var_5_3.g + 1
						
						if_set(var_5_5, "txt_name", T("gacha_category_rate_grade", {
							grade = iter_5_3
						}))
					end
					
					if_set(var_5_5, "txt_ratio", arg_5_3[var_5_4] .. "%")
					
					var_5_2 = var_5_2 + arg_5_3[var_5_4]
					
					var_5_5:setVisible(true)
					
					var_5_1 = var_5_1 + 1
				end
			end
		end
	end
	
	if_set_visible(var_5_0, "txt_title", true)
	if_set_visible(var_5_0, "txt_random_shop", false)
	
	if arg_5_1 then
		if_set(var_5_0, "txt_title", T(arg_5_1) .. " : " .. var_5_2 .. "%")
	elseif var_5_3.g > 0 then
		if_set_visible(var_5_0, "txt_title", false)
	elseif var_5_3.c > 0 and var_5_3.e == 0 then
		if_set(var_5_0, "txt_title", T("hero") .. " : " .. var_5_2 .. "%")
	elseif var_5_3.e > 0 and var_5_3.c == 0 then
		if_set(var_5_0, "txt_title", T("item_type_artifact") .. " : " .. var_5_2 .. "%")
	elseif var_5_3.e > 0 and var_5_3.c > 0 then
		if_set(var_5_0, "txt_title", T("hero_and_arti") .. " : " .. var_5_2 .. "%")
	end
	
	return var_5_0, var_5_1 - 1
end
