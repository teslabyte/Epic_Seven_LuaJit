function GachaUnit.isEnabledGachaCustomGroup(arg_1_0)
	local var_1_0 = Account:getGachaShopInfo()
	local var_1_1
	local var_1_2 = os.time()
	local var_1_3 = var_1_0.gacha_customgroup
	
	if var_1_3 then
		if to_n(var_1_3.summon_count) > 0 then
			if var_1_2 <= to_n(var_1_3.user_end_tm) then
				var_1_1 = to_n(var_1_3.user_end_tm)
			end
		elseif var_1_2 >= to_n(var_1_3.start_time) and var_1_2 <= to_n(var_1_3.end_time) then
			var_1_1 = to_n(var_1_3.end_time)
		end
	end
	
	return var_1_1
end

function GachaUnit.enterGachaCustomGroup(arg_2_0, arg_2_1)
	local var_2_0 = os.time()
	local var_2_1 = Account:getGachaShopInfo()
	local var_2_2 = var_2_1.gacha_customgroup
	
	arg_2_0.vars.gacha_mode = "gacha_customgroup"
	
	arg_2_0:saveSceneState(arg_2_0.vars.gacha_mode)
	
	arg_2_0.vars.element_mode = nil
	arg_2_0.vars.gsp_id = nil
	arg_2_1 = arg_2_1 or var_2_2
	
	if not arg_2_1 then
		arg_2_0:enterGachaRare()
		
		return 
	end
	
	if arg_2_0:isEnabledGachaCustomGroup() == nil then
		balloon_message_with_sound("buy_gacha.invalid_time")
		arg_2_0:showRightMenu(false, true)
		arg_2_0:enterGachaRare()
		
		return 
	end
	
	local var_2_3 = arg_2_0.vars.ui_wnd:getChildByName("n_before")
	local var_2_4 = var_2_3:getChildByName("n_pickup_pos")
	
	var_2_4:removeAllChildren()
	var_2_3:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_2_0:prepareEnterGachaVisibleOff(var_2_3)
	arg_2_0:updateGachaTempInventoryCount()
	if_set_visible(var_2_3, "n_btn_summon_2", true)
	if_set_visible(var_2_3, "n_btn_rate", true)
	if_set_visible(var_2_3, "n_pickup", true)
	
	if get_cocos_refid(arg_2_0.vars.intro.m_biblika_node) then
		arg_2_0.vars.intro.m_biblika_node:setVisible(false)
	end
	
	if get_cocos_refid(arg_2_0.vars.intro.m_biblio_node) then
		arg_2_0.vars.intro.m_biblio_node:setVisible(false)
	end
	
	GachaIntroduceBG:setup("customGroup", var_2_4, {
		nb = var_2_3,
		gacha_shop_info = var_2_1,
		pickup_data = arg_2_1
	})
	arg_2_0:showRightMenu(false)
	arg_2_0:updateGachaCustomGroupSelected()
	arg_2_0:updateGachaCustomGroupTime()
	Analytics:toggleTab("gacha_customgroup")
end

function GachaUnit.updateGachaCustomGroupTime(arg_3_0)
	if not arg_3_0.vars or arg_3_0.vars.gacha_mode ~= "gacha_customgroup" then
		return 
	end
	
	if not get_cocos_refid(arg_3_0.vars.ui_wnd) then
		return 
	end
	
	local var_3_0 = arg_3_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos"):getChildByName("n_date")
	
	if not get_cocos_refid(var_3_0) then
		return 
	end
	
	local var_3_1 = Account:getGachaShopInfo()
	
	if not var_3_1 or not var_3_1.gacha_customgroup then
		return 
	end
	
	local var_3_2 = var_3_1.gacha_customgroup
	
	if not var_3_2.start_time or not var_3_2.end_time then
		return 
	end
	
	if to_n(var_3_2.summon_count) > 0 then
		local var_3_3 = to_n(var_3_2.user_end_tm) - os.time()
		
		if var_3_3 > 0 then
			if_set(var_3_0, "disc", T("ui_gacha_customgroup_left_time_01", {
				time = sec_to_string(var_3_3)
			}))
		else
			if_set(var_3_0, "disc", T("expired"))
		end
		
		if_set_color(var_3_0, "disc", tocolor("#6bc11b"))
	else
		if_set(var_3_0, "disc", T("time_slash_period_y_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_3_2.start_time,
			end_time = var_3_2.end_time
		})))
		
		if to_n(var_3_2.end_time) - os.time() > (GAME_STATIC_VARIABLE.summon_expire_info_time or 172800) then
			if_set_color(var_3_0, "disc", tocolor("#c89b60"))
		else
			if_set_color(var_3_0, "disc", tocolor("#6bc11b"))
		end
	end
end

function GachaUnit.updateGachaCustomData(arg_4_0, arg_4_1)
	local var_4_0 = Account:getGachaShopInfo().gacha_customgroup
	
	var_4_0.summon_count = to_n(arg_4_1.count)
	
	if var_4_0.gacha_time_check == "y" then
		var_4_0.user_end_tm = to_n(var_4_0.end_time)
	else
		var_4_0.user_end_tm = math.min(to_n(arg_4_1.start_tm), to_n(var_4_0.end_time)) + to_n(var_4_0.gacha_time)
	end
end

function GachaUnit.updateGachaCustomGroupSelected(arg_5_0, arg_5_1)
	local var_5_0 = Account:getGachaShopInfo()
	local var_5_1 = var_5_0.gacha_customgroup
	local var_5_2 = {}
	local var_5_3 = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_1.select_list or {}) do
		for iter_5_2, iter_5_3 in pairs(var_5_1.raw_list) do
			if iter_5_3.id == iter_5_1 then
				table.push(var_5_2, iter_5_3.id)
				table.push(var_5_2, iter_5_3.pid)
				table.push(var_5_3, {
					id = iter_5_3.id,
					pid = iter_5_3.pid,
					limit = iter_5_3.limit,
					pd = iter_5_3.pd
				})
				
				break
			end
		end
	end
	
	local var_5_4 = arg_5_0.vars.ui_wnd:getChildByName("n_before")
	local var_5_5 = var_5_4:getChildByName("n_pickup_pos")
	
	if #var_5_2 ~= 6 then
		if var_5_1.deco_layer_image then
			if_set_sprite(var_5_5, "bg_deco", "banner/" .. var_5_1.deco_layer_image .. ".png")
			if_set_visible(var_5_5, "bg_deco", true)
		end
		
		if var_5_1.text_layer_image then
			if_set_sprite(var_5_5, "img_pickup_info", "banner/" .. var_5_1.text_layer_image .. ".png")
			if_set_visible(var_5_5, "img_pickup_info", true)
		end
		
		return 
	else
		if_set_visible(var_5_5, "bg_deco", false)
		if_set_visible(var_5_5, "img_pickup_info", false)
	end
	
	arg_5_0:updateGachaCustomGroupPickupList(var_5_2)
	
	local var_5_6 = var_5_5:getChildByName("n_hero_portrait_custom")
	local var_5_7 = var_5_5:getChildByName("n_selected_info_custom")
	
	var_5_6:setVisible(true)
	var_5_7:setVisible(true)
	
	for iter_5_4 = 1, 3 do
		var_5_3[iter_5_4].pd = var_5_3[iter_5_4].pd or "1;0;0"
		
		if arg_5_1 and (not arg_5_1.idx or arg_5_1.idx == iter_5_4) then
			if arg_5_1.code then
				var_5_3[iter_5_4].id = arg_5_1.code
			end
			
			if arg_5_1.pd then
				var_5_3[iter_5_4].pd = arg_5_1.pd
			end
		end
		
		arg_5_0:setPickupPortrait(var_5_6:getChildByName("n_portrait" .. iter_5_4), var_5_3[iter_5_4].id, var_5_3[iter_5_4].pd)
		
		local var_5_8 = var_5_7:getChildByName("selected_0" .. iter_5_4)
		local var_5_9, var_5_10, var_5_11, var_5_12, var_5_13 = DB("character", var_5_3[iter_5_4].id, {
			"name",
			"role",
			"grade",
			"moonlight",
			"ch_attribute"
		})
		
		if var_5_8:getChildByName("star1") then
			for iter_5_5 = 1, 6 do
				if_set_visible(var_5_8, "star" .. iter_5_5, iter_5_5 <= var_5_11)
			end
		end
		
		if_set(var_5_8, "txt_name_hero", T(var_5_9))
		if_set_sprite(var_5_8, "role", "img/cm_icon_role_" .. var_5_10 .. ".png")
		
		local var_5_14 = "img/cm_icon_pro"
		
		if var_5_12 then
			var_5_14 = var_5_14 .. "m"
		end
		
		if_set_sprite(var_5_8, "color", var_5_14 .. var_5_13 .. ".png")
		
		local var_5_15 = DB("equip_item", var_5_3[iter_5_4].pid, {
			"artifact_grade"
		})
		local var_5_16 = var_5_8:getChildByName("item_art_icon")
		
		UIUtil:getRewardIcon(nil, var_5_3[iter_5_4].pid, {
			show_color = true,
			no_tooltip = true,
			show_name = true,
			hide_type = true,
			role = true,
			no_popup = true,
			scale = 1,
			parent = var_5_16,
			txt_name = var_5_8:getChildByName("txt_name_arti"),
			grade = var_5_15
		})
	end
	
	GachaIntroduceBG.CustomGroup:updateUIByGroupSelected(var_5_4, var_5_1, var_5_0)
end

function GachaUnit.updateGachaCustomGroupPickupList(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos")
	local var_6_1 = var_6_0:getChildByName("n_pickup_info")
	
	if not get_cocos_refid(var_6_1) then
		return 
	end
	
	if not arg_6_0:checkGachaCustomGroupSelectCompleted({
		no_msg = true
	}) then
		return 
	end
	
	local var_6_2 = var_6_0:getChildByName("n_pickup_infolist"):getChildByName("ListView_infolist")
	local var_6_3 = ItemListView_v2:bindControl(var_6_2)
	local var_6_4 = load_control("wnd/gacha_popup_infolist_item.csb")
	
	if var_6_2.STRETCH_INFO then
		local var_6_5 = var_6_2:getContentSize()
		
		resetControlPosAndSize(var_6_4, var_6_5.width, var_6_2.STRETCH_INFO.width_prev)
	end
	
	local var_6_6 = {
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = string.starts(arg_7_3, "c")
			local var_7_1 = var_7_0 and "n_info" or "n_info_arti"
			
			if_set_visible(arg_7_1, "n_info", var_7_0)
			if_set_visible(arg_7_1, "n_info_arti", not var_7_0)
			
			local var_7_2 = arg_7_1:getChildByName(var_7_1)
			local var_7_3 = var_7_2:getChildByName("btn_pickup_info")
			
			var_7_3:setName("btn_pickup_info" .. ":" .. arg_7_3)
			
			if var_7_0 then
				local var_7_4, var_7_5, var_7_6, var_7_7, var_7_8 = DB("character", arg_7_3, {
					"name",
					"role",
					"grade",
					"moonlight",
					"ch_attribute"
				})
				
				if var_7_2:getChildByName("star1") then
					for iter_7_0 = 1, 6 do
						if_set_visible(var_7_2, "star" .. iter_7_0, iter_7_0 <= var_7_6)
					end
				end
				
				if_set(var_7_2, "txt_name", T(var_7_4))
				
				local var_7_9 = var_7_2:getChildByName("n_element")
				
				var_7_9:setVisible(true)
				
				local var_7_10 = "img/cm_icon_pro"
				
				if var_7_7 then
					var_7_10 = var_7_10 .. "m"
				end
				
				if_set_sprite(var_7_9, "icon_element", var_7_10 .. var_7_8 .. ".png")
				
				local var_7_11 = var_7_2:getChildByName("n_icon")
				
				UIUtil:getRewardIcon("c", arg_7_3, {
					no_popup = true,
					name = false,
					role = true,
					scale = 1,
					no_grade = true,
					parent = var_7_11
				})
				WidgetUtils:setupPopup({
					control = var_7_3,
					creator = function()
						return UIUtil:getGachaCharacterPopup({
							skill_preview = true,
							code = arg_7_3,
							grade = var_7_6
						})
					end
				})
			else
				if_set_visible(var_7_2, "n_element", false)
				
				local var_7_12, var_7_13 = DB("equip_item", arg_7_3, {
					"name",
					"artifact_grade"
				})
				
				if_set(var_7_2, "txt_name", T(var_7_12))
				
				if var_7_2:getChildByName("star1") then
					for iter_7_1 = 1, 6 do
						if_set_visible(var_7_2, "star" .. iter_7_1, iter_7_1 <= var_7_13)
					end
				end
				
				local var_7_14 = var_7_2:getChildByName("n_icon_arti")
				
				UIUtil:getRewardIcon(nil, arg_7_3, {
					no_popup = true,
					name = false,
					role = true,
					scale = 1,
					no_grade = true,
					parent = var_7_14
				})
				
				local var_7_15 = EQUIP:createByInfo({
					code = arg_7_3
				})
				
				WidgetUtils:setupPopup({
					control = var_7_3,
					creator = function()
						return ItemTooltip:getItemTooltip({
							show_max_check_box = true,
							artifact_popup = true,
							code = arg_7_3,
							grade = var_7_13,
							equip = var_7_15,
							equip_stat = var_7_15.stats
						})
					end
				})
			end
		end
	}
	
	var_6_3:setRenderer(var_6_4, var_6_6)
	var_6_3:removeAllChildren()
	var_6_3:setDataSource(arg_6_1)
end

function GachaUnit.isUnlockCustomGroup(arg_10_0)
	local var_10_0 = Account:getGachaShopInfo().gacha_customgroup
	local var_10_1 = totable(var_10_0.value)
	
	if var_10_0.condition == "stage_clear" then
		return Account:isMapCleared(var_10_1.map_id)
	end
	
	return false
end

function GachaUnit.popupCustomGroupSelect(arg_11_0)
	GachaCustomGroupSelector:show()
end
