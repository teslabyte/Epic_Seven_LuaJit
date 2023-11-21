CustomProfileCardHero = {}
CustomProfileCardHero.face_list = {}
CustomProfileCardHero.skin_list = {}
CustomProfileCardHero.sd_list = {}

function HANDLER.profile_custom_face_card(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_face" then
		CustomProfileCardHero.face_list:onSelectItem(arg_1_0)
	end
end

function CustomProfileCardHero.create(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.hero_tab = arg_2_1.n_tab
	arg_2_0.vars.hero_wnd = arg_2_1.category_wnd
	
	arg_2_0:initDB()
	arg_2_0:initUI()
end

function CustomProfileCardHero.release(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.hero_tab) or not get_cocos_refid(arg_3_0.vars.hero_wnd) then
		return 
	end
	
	if not arg_3_0.sorter or not arg_3_0.listview then
		return 
	end
	
	arg_3_0.sorter:release()
	arg_3_0.listview:release()
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.sub_tab_list) do
		iter_3_1:release()
	end
	
	arg_3_0.vars.sub_tab_list = nil
	arg_3_0.vars.hero_tab = nil
	arg_3_0.vars.hero_wnd = nil
	arg_3_0.vars = nil
end

function CustomProfileCardHero.initDB(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	arg_4_0.vars.hero_list = {}
	
	local var_4_0 = Account:getUnits()
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		if not arg_4_0.vars.hero_list[iter_4_1.db.code] then
			arg_4_0.vars.hero_list[iter_4_1.db.code] = UNIT:create({
				code = iter_4_1.db.code,
				g = iter_4_1.db.grade
			})
			arg_4_0.vars.hero_list[iter_4_1.db.code].type = "hero"
			arg_4_0.vars.hero_list[iter_4_1.db.code].is_sd = false
			arg_4_0.vars.hero_list[iter_4_1.db.code].face_id = 0
			arg_4_0.vars.hero_list[iter_4_1.db.code].id = iter_4_1.db.code
		end
	end
	
	arg_4_0.vars.sd_model_list = {}
	
	for iter_4_2 = 1, 9999 do
		local var_4_1, var_4_2, var_4_3 = DBN("item_material_profile", iter_4_2, {
			"id",
			"material_id",
			"type"
		})
		
		if not var_4_1 then
			break
		end
		
		local var_4_4 = CustomProfileCardEditor:isNeedHideCheckLayerItem(var_4_1)
		
		if var_4_3 == "sd" and var_4_2 and (not var_4_4 or Account:getItemCount(var_4_2) > 0) then
			local var_4_5 = DBT("profile_sd_character", var_4_2, {
				"char_id",
				"sort_ignore"
			})
			local var_4_6 = DBT("item_material", var_4_2, {
				"name",
				"sort",
				"icon",
				"desc"
			})
			local var_4_7
			
			if var_4_5.char_id then
				var_4_7 = UNIT:create({
					code = var_4_5.char_id
				})
			end
			
			arg_4_0.vars.sd_model_list[var_4_1] = {
				type = "hero",
				is_sd = true,
				id = var_4_1,
				material_id = var_4_2,
				name = T(var_4_6.name),
				bind_unit_id = var_4_5.char_id,
				bind_unit_info = var_4_7,
				is_sort_ignore = var_4_5.sort_ignore ~= nil,
				sort = var_4_6.sort,
				icon = var_4_6.icon,
				desc = var_4_6.desc
			}
		end
	end
	
	arg_4_0.vars.is_show_sd_hero = false
	arg_4_0.vars.sub_tab_list = {}
	arg_4_0.vars.sub_tab_list[1] = arg_4_0.face_list
	arg_4_0.vars.sub_tab_list[2] = arg_4_0.skin_list
	arg_4_0.vars.sub_tab_list[3] = arg_4_0.sd_list
end

function CustomProfileCardHero.initUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.hero_tab) or not get_cocos_refid(arg_5_0.vars.hero_wnd) then
		return 
	end
	
	if table.empty(arg_5_0.vars.sub_tab_list) then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.hero_wnd:getChildByName("btn_check_sd")
	
	if get_cocos_refid(var_5_0) then
		var_5_0:getChildByName("checkbox"):setSelected(arg_5_0.vars.is_show_sd_hero)
	end
	
	arg_5_0.listview:create(arg_5_0.vars.hero_wnd)
	arg_5_0.sorter:create(arg_5_0.vars.hero_wnd)
	
	arg_5_0.vars.n_main = arg_5_0.vars.hero_wnd:getChildByName("n_main")
	
	if_set_visible(arg_5_0.vars.n_main, nil, false)
	
	arg_5_0.vars.n_sub = arg_5_0.vars.hero_wnd:getChildByName("n_sub")
	
	if_set_visible(arg_5_0.vars.n_sub, nil, false)
	arg_5_0.vars.sub_tab_list[1]:create(arg_5_0.vars.hero_wnd:getChildByName("n_expression"))
	arg_5_0.vars.sub_tab_list[2]:create(arg_5_0.vars.hero_wnd:getChildByName("listview_skin"))
	arg_5_0.vars.sub_tab_list[3]:create(arg_5_0.vars.hero_wnd:getChildByName("listview_hero"))
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.n_sub:getChildren()) do
		if get_cocos_refid(iter_5_1) and tolua.type(iter_5_1) == "ccui.Button" then
			iter_5_1:addTouchEventListener(function(arg_6_0, arg_6_1)
				if not get_cocos_refid(arg_6_0) then
					return 
				end
				
				if arg_6_1 == 0 or arg_6_1 == 1 then
					return 
				end
				
				arg_5_0:onTouchSubTab(arg_6_0)
			end)
			
			local var_5_1 = iter_5_1:getName()
			local var_5_2 = string.len("tab_")
			local var_5_3 = string.sub(var_5_1, var_5_2 + 1, -1)
			
			iter_5_1.sub_tab = arg_5_0.vars.sub_tab_list[tonumber(var_5_3)]
		end
	end
	
	local var_5_4 = arg_5_0.vars.hero_wnd:getChildByName("n_flip")
	
	if get_cocos_refid(var_5_4) then
		for iter_5_2, iter_5_3 in pairs(var_5_4:getChildren()) do
			if get_cocos_refid(iter_5_3) and tolua.type(iter_5_3) == "ccui.Button" then
				iter_5_3:addTouchEventListener(function(arg_7_0, arg_7_1)
					if not get_cocos_refid(arg_7_0) then
						return 
					end
					
					if arg_7_1 == 0 or arg_7_1 == 1 then
						return 
					end
					
					local var_7_0 = arg_7_0:getName()
					local var_7_1 = string.len("btn_toggle_box")
					local var_7_2 = string.sub(var_7_0, var_7_1 + 1, -1)
					local var_7_3 = true
					
					if var_7_2 == "_active" then
						var_7_3 = false
					end
					
					arg_5_0:setFlipModel(var_7_3)
				end)
			end
		end
		
		if_set_visible(var_5_4, "btn_toggle_box", true)
		if_set_opacity(var_5_4, "btn_toggle_box", 76.5)
		if_set_visible(var_5_4, "btn_toggle_box_active", false)
		if_set_opacity(var_5_4, "btn_toggle_box_active", 76.5)
	end
end

function CustomProfileCardHero.resetUI(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.hero_tab) or not get_cocos_refid(arg_8_0.vars.hero_wnd) then
		return 
	end
	
	if_set_visible(arg_8_0.vars.hero_tab, "bg_tab", false)
	if_set_visible(arg_8_0.vars.hero_wnd, nil, false)
	arg_8_0:clearKeyWord()
	arg_8_0:showNoData(false)
	arg_8_0.sorter:clearSetting()
	
	arg_8_0.vars.is_show_sd_hero = false
	
	local var_8_0 = arg_8_0.vars.hero_wnd:getChildByName("btn_check_sd")
	
	if get_cocos_refid(var_8_0) then
		var_8_0:getChildByName("checkbox"):setSelected(arg_8_0.vars.is_show_sd_hero)
	end
	
	if_set_visible(arg_8_0.vars.n_main, nil, false)
	arg_8_0:setMainTabUI(true)
	if_set_visible(arg_8_0.vars.n_sub, nil, false)
	
	arg_8_0.vars.cur_sub_tab = nil
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.n_sub:getChildren()) do
		if_set_visible(iter_8_1, "bg_sel", false)
		if_set_opacity(iter_8_1, nil, 76.5)
	end
	
	for iter_8_2, iter_8_3 in pairs(arg_8_0.vars.sub_tab_list) do
		iter_8_3:close()
	end
end

function CustomProfileCardHero.setUI(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.hero_tab) or not get_cocos_refid(arg_9_0.vars.hero_wnd) then
		return 
	end
	
	if_set_visible(arg_9_0.vars.hero_tab, "bg_tab", true)
	if_set_visible(arg_9_0.vars.hero_wnd, nil, true)
	
	local var_9_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_9_0 and var_9_0:getType() == "hero" then
		local var_9_1 = var_9_0:getId()
		local var_9_2 = var_9_0:isSDModel()
		
		if var_9_2 then
			if_set_visible(arg_9_0.vars.n_main, nil, true)
			if_set_visible(arg_9_0.vars.hero_wnd, "listview_hero", true)
			arg_9_0:toggleShowSDHero()
		else
			arg_9_0:openSubTab(var_9_0)
		end
		
		local var_9_3 = arg_9_0.vars.hero_wnd:getChildByName("n_flip")
		
		if get_cocos_refid(var_9_3) then
			local var_9_4 = var_9_0:isFlip()
			
			if_set_visible(var_9_3, "btn_toggle_box", not var_9_4)
			if_set_visible(var_9_3, "btn_toggle_box_active", var_9_4)
			
			local var_9_5 = arg_9_0:isEnabledFlip(var_9_1, var_9_2)
			
			if_set_opacity(var_9_3, "btn_toggle_box", var_9_5 and 255 or 76.5)
			if_set_opacity(var_9_3, "btn_toggle_box_active", var_9_5 and 255 or 76.5)
		end
	else
		if_set_visible(arg_9_0.vars.n_main, nil, true)
		if_set_visible(arg_9_0.vars.hero_wnd, "listview_hero", true)
		arg_9_0.sorter:resetData()
		
		local var_9_6 = arg_9_0.vars.hero_wnd:getChildByName("n_flip")
		
		if get_cocos_refid(var_9_6) then
			if_set_visible(var_9_6, "btn_toggle_box", true)
			if_set_opacity(var_9_6, "btn_toggle_box", 76.5)
			if_set_visible(var_9_6, "btn_toggle_box_active", false)
			if_set_opacity(var_9_6, "btn_toggle_box_active", 76.5)
		end
	end
end

function CustomProfileCardHero.openSubTab(arg_10_0, arg_10_1)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.hero_wnd) or not get_cocos_refid(arg_10_0.vars.n_sub) then
		return 
	end
	
	if not arg_10_1 then
		return 
	end
	
	if_set_visible(arg_10_0.vars.n_sub, nil, true)
	
	local var_10_0 = arg_10_1:getId()
	
	if_set_visible(arg_10_0.vars.hero_wnd, "listview_hero", false)
	
	local var_10_1 = false
	local var_10_2 = {}
	
	var_10_2[1] = "isExistFace"
	var_10_2[2] = "isExistSkin"
	var_10_2[3] = "isExistBindSDModel"
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.n_sub:getChildren()) do
		if get_cocos_refid(iter_10_1) then
			local var_10_3 = iter_10_1:getName()
			local var_10_4 = string.len("tab_")
			local var_10_5 = string.sub(var_10_3, var_10_4 + 1, -1)
			local var_10_6 = arg_10_0[var_10_2[tonumber(var_10_5)]](arg_10_0, var_10_0)
			
			if_set_visible(iter_10_1, "bg_sel", false)
			if_set_opacity(iter_10_1, nil, var_10_6 and 255 or 76.5)
			
			if var_10_6 then
				var_10_1 = var_10_6
			end
		end
	end
	
	if var_10_1 then
		arg_10_0:onTouchSubTab(arg_10_0.vars.n_sub:getChildByName("tab_1"))
	end
end

function CustomProfileCardHero.onTouchSubTab(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.hero_wnd) or not get_cocos_refid(arg_11_1) then
		return 
	end
	
	local var_11_0 = CustomProfileCardEditor:getFocusLayer()
	
	if not var_11_0 or var_11_0:getType() ~= "hero" or var_11_0:isLock() then
		return 
	end
	
	if arg_11_0.vars.cur_sub_tab == arg_11_1 then
		return 
	end
	
	if arg_11_1.sub_tab and arg_11_1.sub_tab:open(var_11_0) then
		if arg_11_0.vars.cur_sub_tab and arg_11_0.vars.cur_sub_tab.sub_tab then
			if_set_visible(arg_11_0.vars.cur_sub_tab, "bg_sel", false)
			arg_11_0.vars.cur_sub_tab.sub_tab:close()
		end
		
		arg_11_0.vars.cur_sub_tab = arg_11_1
		
		if_set_visible(arg_11_0.vars.cur_sub_tab, "bg_sel", true)
	end
end

function CustomProfileCardHero.getCurrentSubTab(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.hero_wnd) then
		return nil
	end
	
	return arg_12_0.vars.cur_sub_tab
end

function CustomProfileCardHero.showNoData(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.hero_wnd) then
		return 
	end
	
	if_set_visible(arg_13_0.vars.hero_wnd, "listview_hero", not arg_13_1)
	if_set_visible(arg_13_0.vars.hero_wnd, "n_info", arg_13_1)
end

function CustomProfileCardHero.setMainTabUI(arg_14_0, arg_14_1)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.hero_wnd) or not get_cocos_refid(arg_14_0.vars.n_main) then
		return 
	end
	
	if_set_visible(arg_14_0.vars.n_main, "btn_check_sd", arg_14_1)
	if_set_visible(arg_14_0.vars.n_main, "n_sort", arg_14_1)
	if_set_visible(arg_14_0.vars.n_main, "btn_open_search", arg_14_1)
	if_set_visible(arg_14_0.vars.n_main, "btn_open_search_active", not arg_14_1)
end

function CustomProfileCardHero.setFlipModel(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.hero_wnd) then
		return 
	end
	
	local var_15_0 = CustomProfileCardEditor:getFocusLayer()
	
	if not var_15_0 then
		balloon_message_with_sound("msg_profile_layer_cant_use")
		
		return 
	end
	
	if var_15_0 and var_15_0:getType() == "hero" then
		local var_15_1 = var_15_0:getId()
		local var_15_2 = var_15_0:isSDModel()
		
		if not arg_15_0:isEnabledFlip(var_15_1, var_15_2) then
			balloon_message_with_sound("msg_profile_cant_flip")
			
			return 
		end
		
		var_15_0:setFlip(arg_15_1)
		
		local var_15_3 = arg_15_0.vars.hero_wnd:getChildByName("n_flip")
		
		if get_cocos_refid(var_15_3) then
			if_set_visible(var_15_3, "btn_toggle_box", not arg_15_1)
			if_set_visible(var_15_3, "btn_toggle_box_active", arg_15_1)
		end
	end
end

function CustomProfileCardHero.isFlip(arg_16_0)
	if not arg_16_0.vars or not arg_16_0.vars.pre_data then
		return false
	end
	
	return arg_16_0.vars.pre_data.is_flip
end

function CustomProfileCardHero.getHeroList(arg_17_0)
	if not arg_17_0.vars or table.empty(arg_17_0.vars.hero_list) then
		return nil
	end
	
	return arg_17_0.vars.hero_list
end

function CustomProfileCardHero.getHeroDataByCode(arg_18_0, arg_18_1)
	if not arg_18_0.vars or table.empty(arg_18_0.vars.hero_list) then
		return nil
	end
	
	return arg_18_0.vars.hero_list[arg_18_1]
end

function CustomProfileCardHero.isClassChangeHero(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return nil, nil
	end
	
	for iter_19_0 = 1, 999 do
		local var_19_0, var_19_1 = DBN("classchange_category", iter_19_0, {
			"char_id",
			"char_id_cc"
		})
		
		if not var_19_0 then
			break
		end
		
		if arg_19_1 == var_19_1 then
			return true, var_19_0
		end
	end
	
	return false, nil
end

function CustomProfileCardHero.getSDModelList(arg_20_0)
	if not arg_20_0.vars or table.empty(arg_20_0.vars.sd_model_list) then
		return nil
	end
	
	return arg_20_0.vars.sd_model_list
end

function CustomProfileCardHero.getSDModelDataById(arg_21_0, arg_21_1)
	if not arg_21_0.vars or table.empty(arg_21_0.vars.sd_model_list) then
		return nil
	end
	
	return arg_21_0.vars.sd_model_list[arg_21_1]
end

function CustomProfileCardHero.getFaceList(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return nil
	end
	
	local var_22_0 = {}
	
	for iter_22_0 = 1, 10 do
		local var_22_1 = SLOW_DB_ALL("character_intimacy_level", (DB("character", arg_22_1, "emotion_id") or arg_22_1) .. "_" .. iter_22_0)
		
		if not var_22_1 then
			break
		end
		
		if not var_22_1.id then
			break
		end
		
		table.push(var_22_0, var_22_1)
	end
	
	local var_22_2 = {}
	
	if string.find(arg_22_1, "_s%d") then
		local var_22_3 = string.find(arg_22_1, "_s%d")
		
		arg_22_1 = string.sub(arg_22_1, 1, var_22_3 - 1)
	end
	
	local var_22_4
	
	if arg_22_1 == "c1005" then
		var_22_4 = Account:getUnitsByVariationGroupCode(arg_22_1)
	else
		var_22_4 = Account:getUnitsByCode(arg_22_1)
	end
	
	local var_22_5 = 0
	
	for iter_22_1, iter_22_2 in pairs(var_22_4 or {}) do
		var_22_5 = math.max(var_22_5, iter_22_2:getFavLevel())
	end
	
	for iter_22_3, iter_22_4 in pairs(var_22_0) do
		if iter_22_4.emotion then
			local var_22_6 = table.clone(iter_22_4)
			
			if var_22_5 < iter_22_4.intimacy_level then
				var_22_6.locked = true
			end
			
			table.insert(var_22_2, var_22_6)
		end
	end
	
	return var_22_2
end

function CustomProfileCardHero.isExistFace(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return false
	end
	
	return not table.empty(arg_23_0:getFaceList(arg_23_1))
end

function CustomProfileCardHero.getSkinList(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return nil
	end
	
	return UIUtil:getSkinList(arg_24_1)
end

function CustomProfileCardHero.isExistSkin(arg_25_0, arg_25_1)
	if not arg_25_1 then
		return false
	end
	
	return table.count(arg_25_0:getSkinList(arg_25_1) or {}) > 1
end

function CustomProfileCardHero.getBindSDModel(arg_26_0, arg_26_1)
	if table.empty(arg_26_0.vars.sd_model_list) or not arg_26_1 then
		return nil
	end
	
	if string.find(arg_26_1, "_s%d") then
		local var_26_0 = string.find(arg_26_1, "_s%d")
		
		arg_26_1 = string.sub(arg_26_1, 1, var_26_0 - 1)
	end
	
	local var_26_1, var_26_2 = arg_26_0:isClassChangeHero(arg_26_1)
	
	if var_26_1 then
		arg_26_1 = var_26_2
	end
	
	if is_mer_series(arg_26_1) then
		arg_26_1 = "c1005"
	end
	
	local var_26_3 = {}
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.sd_model_list) do
		if iter_26_1.bind_unit_id and iter_26_1.bind_unit_id == arg_26_1 then
			table.insert(var_26_3, iter_26_1)
		end
	end
	
	if not table.empty(var_26_3) then
		table.sort(var_26_3, function(arg_27_0, arg_27_1)
			return arg_27_0.sort < arg_27_1.sort
		end)
	end
	
	return var_26_3
end

function CustomProfileCardHero.getBindHeroId(arg_28_0, arg_28_1)
	if table.empty(arg_28_0.vars.sd_model_list) then
		return nil
	end
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.sd_model_list) do
		if iter_28_0 == arg_28_1 then
			return iter_28_1.bind_unit_id
		end
	end
	
	return nil
end

function CustomProfileCardHero.isExistBindSDModel(arg_29_0, arg_29_1)
	if not arg_29_1 then
		return false
	end
	
	return not table.empty(arg_29_0:getBindSDModel(arg_29_1))
end

function CustomProfileCardHero.isEnabledFlip(arg_30_0, arg_30_1, arg_30_2)
	if table.empty(ProfileCardConfigData.flip_not_allowed) or not arg_30_1 then
		return true
	end
	
	if arg_30_2 then
		arg_30_1 = arg_30_0:getBindHeroId(arg_30_1)
		
		if not arg_30_1 then
			return true
		end
	end
	
	local var_30_0 = ProfileCardConfigData.flip_not_allowed
	
	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		if iter_30_1 == arg_30_1 then
			return false
		end
	end
	
	return true
end

function CustomProfileCardHero.getShowSDHero(arg_31_0)
	if not arg_31_0.vars or arg_31_0.vars.is_show_sd_hero == nil then
		return false
	end
	
	return arg_31_0.vars.is_show_sd_hero
end

function CustomProfileCardHero.toggleShowSDHero(arg_32_0)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.hero_wnd) or not arg_32_0.sorter then
		return 
	end
	
	if table.empty(arg_32_0.vars.sd_model_list) or table.empty(arg_32_0.vars.hero_list) then
		return 
	end
	
	if arg_32_0.vars.is_show_sd_hero == nil then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.hero_wnd:getChildByName("btn_check_sd")
	
	if get_cocos_refid(var_32_0) then
		arg_32_0.vars.is_show_sd_hero = not arg_32_0.vars.is_show_sd_hero
		
		var_32_0:getChildByName("checkbox"):setSelected(arg_32_0.vars.is_show_sd_hero)
		arg_32_0:clearKeyWord()
		arg_32_0.sorter:clearSetting()
		arg_32_0.sorter:resetData()
	end
end

function CustomProfileCardHero.showHeroSearchPopup(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.hero_wnd) or arg_33_0.vars.hero_wnd:isVisible() == false then
		return 
	end
	
	local var_33_0 = arg_33_0.vars.hero_wnd:getChildByName("layer_search")
	
	if get_cocos_refid(var_33_0) then
		var_33_0:setVisible(arg_33_1)
		
		if arg_33_1 then
			if_set(var_33_0, "input_search", "")
			arg_33_0:clearKeyWord()
		end
	end
end

function CustomProfileCardHero.resetSearch(arg_34_0)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.hero_wnd) or arg_34_0.vars.hero_wnd:isVisible() == false then
		return 
	end
	
	if not get_cocos_refid(arg_34_0.vars.n_main) then
		return 
	end
	
	arg_34_0:clearKeyWord()
	arg_34_0:showNoData(false)
	arg_34_0.sorter:resetData()
	arg_34_0:setMainTabUI(true)
end

function CustomProfileCardHero.clearKeyWord(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	arg_35_0.vars.search_keyword = nil
end

function CustomProfileCardHero.searchHero(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.hero_wnd) or arg_36_0.vars.hero_wnd:isVisible() == false then
		return 
	end
	
	if not get_cocos_refid(arg_36_0.vars.n_main) then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.hero_wnd:getChildByName("layer_search")
	
	if get_cocos_refid(var_36_0) then
		local var_36_1 = var_36_0:getChildByName("input_search"):getString()
		local var_36_2 = CollectionUtil:removeRegexCharacters(var_36_1)
		
		if var_36_2 ~= nil and var_36_2 ~= "" then
			arg_36_0.vars.search_keyword = var_36_2
		end
		
		arg_36_0.sorter:resetData()
		arg_36_0:showHeroSearchPopup(false)
		arg_36_0:setMainTabUI(false)
	end
end

function CustomProfileCardHero.checkSearchHero(arg_37_0, arg_37_1)
	if not arg_37_0.vars.search_keyword or not arg_37_1 then
		return true
	end
	
	return string.find(arg_37_1, arg_37_0.vars.search_keyword) ~= nil
end

function CustomProfileCardHero.createHeroLayer(arg_38_0, arg_38_1)
	if table.empty(arg_38_1) or not arg_38_1.type or arg_38_1.type ~= "hero" or not arg_38_1.id then
		return 
	end
	
	CustomProfileCardEditor:createLayer({
		type = arg_38_1.type,
		id = arg_38_1.id,
		is_sd = arg_38_1.is_sd,
		face_id = arg_38_1.face_id
	})
end

CustomProfileCardHero.sorter = {}
CustomProfileCardHero.sorter.OrderTable = {
	"Grade",
	"Color",
	"Role",
	"Name"
}
CustomProfileCardHero.sorter.UnOrderTable = {
	Role = 3,
	Grade = 1,
	Name = 4,
	Color = 2
}
CustomProfileCardHero.sorter.ROLE_SORT_ORDER = {
	manauser = 1,
	knight = 5,
	assassin = 4,
	warrior = 6,
	ranger = 3,
	mage = 2
}
CustomProfileCardHero.sorter.UNIT_COLOR_TABLE = {
	wind = 3,
	fire = 1,
	none = 6,
	light = 4,
	dark = 5,
	ice = 2
}

function CustomProfileCardHero.sorter.create(arg_39_0, arg_39_1)
	if not get_cocos_refid(arg_39_1) then
		return 
	end
	
	arg_39_0.vars = {}
	
	local var_39_0 = arg_39_1:getChildByName("n_sort")
	
	arg_39_0.vars.sorter = Sorter:create(var_39_0, {
		btn_toggle_box = true,
		profile_edit_mode = true,
		sorting_unit = true,
		not_use_skill_filter = true
	})
	
	arg_39_0:setFilterValue()
	
	arg_39_0.vars.sorters = {
		{
			key = "Grade",
			name = T("ui_unit_list_sort_1_label"),
			func = arg_39_0.greaterThanGrade
		},
		{
			key = "Color",
			name = T("ui_unit_list_sort_3_label"),
			func = arg_39_0.greaterThanColor
		},
		{
			key = "Role",
			name = T("ui_unit_list_sort_6_label"),
			func = arg_39_0.greaterThanRole
		},
		{
			key = "Name",
			name = T("ui_unit_list_sort_7_label"),
			func = arg_39_0.greaterThanName
		}
	}
	arg_39_0.vars.sort_index = 1
	
	arg_39_0.vars.sorter:setSorter({
		default_sort_index = arg_39_0.vars.sort_index,
		menus = arg_39_0.vars.sorters,
		filters = arg_39_0:getFilterTable(arg_39_0.vars.filters),
		callback_sort = function(arg_40_0, arg_40_1, arg_40_2)
			arg_39_0:updateListView()
			
			arg_39_0.vars.sort_index = arg_40_1
		end,
		callback_on_add_filter = function(arg_41_0, arg_41_1, arg_41_2)
			arg_39_0:addFilter(arg_41_0, arg_41_1, arg_41_2)
		end,
		callback_on_commit_filter = function()
			arg_39_0:resetData()
		end,
		resetDataByCall = function()
			arg_39_0:resetData()
		end,
		callback_filter = function(arg_44_0, arg_44_1, arg_44_2)
			arg_39_0:addFilter(arg_44_0, arg_44_1, arg_44_2)
			arg_39_0:resetData()
		end
	})
	arg_39_0.vars.sorter:starUIDictMode(5, 2)
	arg_39_0.vars.sorter:roleUIDictMode()
	
	local var_39_1 = arg_39_0.vars.sorter:getWnd()
	local var_39_2 = var_39_1:getChildByName("btn_toggle_box")
	local var_39_3 = var_39_1:getChildByName("btn_toggle_box_active")
	
	if get_cocos_refid(var_39_2) and get_cocos_refid(var_39_3) then
		local var_39_4 = var_39_0:getChildByName("btn_toggle_box")
		
		if get_cocos_refid(var_39_4) then
			var_39_4:setVisible(false)
			var_39_2:setPosition(var_39_4:getPosition())
			var_39_2:setContentSize(var_39_4:getContentSize())
		end
		
		local var_39_5 = var_39_0:getChildByName("btn_toggle_box_active")
		
		if get_cocos_refid(var_39_4) then
			var_39_5:setVisible(false)
			var_39_3:setAnchorPoint(var_39_5:getAnchorPoint())
			var_39_3:setPosition(var_39_5:getPosition())
			var_39_3:setContentSize(var_39_5:getContentSize())
		end
	end
	
	arg_39_0:resetData()
end

function CustomProfileCardHero.sorter.release(arg_45_0)
	if not arg_45_0.vars or not arg_45_0.vars.sorter then
		return 
	end
	
	arg_45_0.vars.sorter:destroy()
	
	arg_45_0.vars = nil
end

function CustomProfileCardHero.sorter.clearSetting(arg_46_0)
	if not arg_46_0.vars or not arg_46_0.vars.sorter then
		return 
	end
	
	arg_46_0.vars.sorter:sort(1)
	arg_46_0.vars.sorter:setFilters(arg_46_0:getFilterTable())
	arg_46_0:resetFilters()
end

function CustomProfileCardHero.sorter.resetFilters(arg_47_0)
	if not arg_47_0.vars or not arg_47_0.vars.sorter or not arg_47_0.vars.filters then
		return 
	end
	
	for iter_47_0, iter_47_1 in pairs(arg_47_0.vars.filters) do
		for iter_47_2, iter_47_3 in pairs(iter_47_1) do
			if not iter_47_3 then
				iter_47_1[iter_47_2] = true
			end
		end
	end
end

function CustomProfileCardHero.sorter.makeList(arg_48_0, arg_48_1)
	local var_48_0 = table.clone(arg_48_0.OrderTable)
	
	if arg_48_1 then
		var_48_0[arg_48_0.UnOrderTable[arg_48_1]] = nil
	end
	
	local var_48_1 = {}
	
	for iter_48_0 = 1, #arg_48_0.OrderTable do
		table.insert(var_48_1, var_48_0[iter_48_0])
	end
	
	return var_48_1
end

function CustomProfileCardHero.sorter.procNext(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = table.remove(arg_49_3, 1)
	
	if not var_49_0 then
		if arg_49_1.is_sd and arg_49_2.is_sd then
			return arg_49_1.sort < arg_49_2.sort
		end
		
		return arg_49_1.inst.uid < arg_49_2.inst.uid
	end
	
	return arg_49_0["greaterThan" .. var_49_0](arg_49_1, arg_49_2, arg_49_3)
end

function CustomProfileCardHero.sorter.greaterThanGrade(arg_50_0, arg_50_1, arg_50_2)
	if arg_50_0.is_sort_ignore and arg_50_1.is_sort_ignore then
		return arg_50_0.sort < arg_50_1.sort
	end
	
	arg_50_2 = arg_50_2 or CustomProfileCardHero.sorter:makeList("Grade")
	
	if arg_50_0.is_sd and arg_50_1.is_sd then
		local var_50_0, var_50_1 = CustomProfileCardEditor:checkLayerItemUnlock(arg_50_0.id)
		local var_50_2, var_50_3 = CustomProfileCardEditor:checkLayerItemUnlock(arg_50_1.id)
		
		if var_50_0 == true and var_50_2 == false then
			return true
		end
		
		if var_50_0 == false and var_50_2 == true then
			return false
		end
	end
	
	if arg_50_0.is_sort_ignore or arg_50_1.is_sort_ignore then
		return arg_50_0.is_sort_ignore and not arg_50_1.is_sort_ignore
	end
	
	local var_50_4 = arg_50_0.is_sd and arg_50_0.bind_unit_info:getBaseGrade() or arg_50_0.db.grade
	local var_50_5 = arg_50_1.is_sd and arg_50_1.bind_unit_info:getBaseGrade() or arg_50_1.db.grade
	
	if var_50_4 == var_50_5 then
		return CustomProfileCardHero.sorter:procNext(arg_50_0, arg_50_1, arg_50_2)
	end
	
	return var_50_5 < var_50_4
end

function CustomProfileCardHero.sorter.greaterThanColor(arg_51_0, arg_51_1, arg_51_2)
	if arg_51_0.is_sort_ignore and arg_51_1.is_sort_ignore then
		return arg_51_0.sort < arg_51_1.sort
	end
	
	arg_51_2 = arg_51_2 or CustomProfileCardHero.sorter:makeList("Color")
	
	if arg_51_0.is_sd and arg_51_1.is_sd then
		local var_51_0, var_51_1 = CustomProfileCardEditor:checkLayerItemUnlock(arg_51_0.id)
		local var_51_2, var_51_3 = CustomProfileCardEditor:checkLayerItemUnlock(arg_51_1.id)
		
		if var_51_0 == true and var_51_2 == false then
			return true
		end
		
		if var_51_0 == false and var_51_2 == true then
			return false
		end
	end
	
	if arg_51_0.is_sort_ignore or arg_51_1.is_sort_ignore then
		return arg_51_0.is_sort_ignore and not arg_51_1.is_sort_ignore
	end
	
	local var_51_4 = arg_51_0.is_sd and arg_51_0.bind_unit_info:getColor() or arg_51_0.db.color
	local var_51_5 = arg_51_1.is_sd and arg_51_1.bind_unit_info:getColor() or arg_51_1.db.color
	
	if var_51_4 == var_51_5 then
		return CustomProfileCardHero.sorter:procNext(arg_51_0, arg_51_1, arg_51_2)
	end
	
	return CustomProfileCardHero.sorter.UNIT_COLOR_TABLE[var_51_4] < CustomProfileCardHero.sorter.UNIT_COLOR_TABLE[var_51_5]
end

function CustomProfileCardHero.sorter.greaterThanRole(arg_52_0, arg_52_1, arg_52_2)
	if arg_52_0.is_sort_ignore and arg_52_1.is_sort_ignore then
		return arg_52_0.sort < arg_52_1.sort
	end
	
	arg_52_2 = arg_52_2 or CustomProfileCardHero.sorter:makeList("Role")
	
	if arg_52_0.is_sd and arg_52_1.is_sd then
		local var_52_0, var_52_1 = CustomProfileCardEditor:checkLayerItemUnlock(arg_52_0.id)
		local var_52_2, var_52_3 = CustomProfileCardEditor:checkLayerItemUnlock(arg_52_1.id)
		
		if var_52_0 == true and var_52_2 == false then
			return true
		end
		
		if var_52_0 == false and var_52_2 == true then
			return false
		end
	end
	
	if arg_52_0.is_sort_ignore or arg_52_1.is_sort_ignore then
		return arg_52_0.is_sort_ignore and not arg_52_1.is_sort_ignore
	end
	
	local var_52_4 = arg_52_0.is_sd and arg_52_0.bind_unit_info.db.role or arg_52_0.db.role
	local var_52_5 = arg_52_1.is_sd and arg_52_1.bind_unit_info.db.role or arg_52_1.db.role
	
	if var_52_4 == var_52_5 then
		return CustomProfileCardHero.sorter:procNext(arg_52_0, arg_52_1, arg_52_2)
	end
	
	return CustomProfileCardHero.sorter.ROLE_SORT_ORDER[var_52_4] > CustomProfileCardHero.sorter.ROLE_SORT_ORDER[var_52_5]
end

function CustomProfileCardHero.sorter.greaterThanName(arg_53_0, arg_53_1, arg_53_2)
	arg_53_2 = arg_53_2 or CustomProfileCardHero.sorter:makeList("Name")
	
	local var_53_0 = arg_53_0.is_sd and arg_53_0.name or arg_53_0:getName()
	local var_53_1 = arg_53_1.is_sd and arg_53_1.name or arg_53_1:getName()
	
	if arg_53_0.is_sd and arg_53_1.is_sd then
		local var_53_2, var_53_3 = CustomProfileCardEditor:checkLayerItemUnlock(arg_53_0.id)
		local var_53_4, var_53_5 = CustomProfileCardEditor:checkLayerItemUnlock(arg_53_1.id)
		
		if var_53_2 == true and var_53_4 == false then
			return true
		end
		
		if var_53_2 == false and var_53_4 == true then
			return false
		end
	end
	
	if var_53_0 == var_53_1 then
		return CustomProfileCardHero.sorter:procNext(arg_53_0, arg_53_1, arg_53_2)
	end
	
	if isLatinAccentLanguage() then
		return utf8LatinAccentCompare(var_53_0, var_53_1)
	end
	
	return string.lower(var_53_0) < string.lower(var_53_1)
end

function CustomProfileCardHero.sorter.setFilterValue(arg_54_0)
	if not arg_54_0.vars or not arg_54_0.vars.sorter then
		return 
	end
	
	local var_54_0 = {}
	
	arg_54_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_54_0.vars.filter_un_hash_tbl.star = {
		5,
		4,
		3,
		2,
		all = "all"
	}
	arg_54_0.vars.filter_un_hash_tbl.role = {
		"warrior",
		"knight",
		"assassin",
		"ranger",
		"mage",
		"manauser",
		all = "all"
	}
	arg_54_0.vars.filters = {}
	
	arg_54_0:loadFilterValue(var_54_0.star, "star")
	arg_54_0:loadFilterValue(var_54_0.role, "role")
	arg_54_0:loadFilterValue(var_54_0.element, "element")
end

function CustomProfileCardHero.sorter.loadFilterValue(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_0.vars or not arg_55_0.vars.filters then
		return 
	end
	
	arg_55_1 = arg_55_1 or {}
	arg_55_0.vars.filters[arg_55_2] = {}
	
	for iter_55_0 = 1, 10 do
		local var_55_0 = arg_55_0.vars.filter_un_hash_tbl[arg_55_2][iter_55_0]
		
		if not var_55_0 then
			break
		end
		
		if arg_55_1[var_55_0] ~= nil then
			arg_55_0.vars.filters[arg_55_2][var_55_0] = arg_55_1[var_55_0]
		else
			arg_55_0.vars.filters[arg_55_2][var_55_0] = true
		end
	end
end

function CustomProfileCardHero.sorter.getFilterTable(arg_56_0, arg_56_1)
	arg_56_1 = arg_56_1 or {}
	
	return {
		star = {
			id = "star",
			check_list = arg_56_0:getFilterCheckList("star")
		},
		role = {
			id = "role",
			check_list = arg_56_0:getFilterCheckList("role")
		},
		element = {
			id = "element",
			check_list = arg_56_0:getFilterCheckList("element")
		}
	}
end

function CustomProfileCardHero.sorter.getFilterCheckList(arg_57_0, arg_57_1)
	if not arg_57_0.vars or table.empty(arg_57_0.vars.filter_un_hash_tbl) then
		return nil
	end
	
	return ItemFilterUtil:getFilterCheckList(arg_57_0.vars.filter_un_hash_tbl, arg_57_1)
end

function CustomProfileCardHero.sorter.addFilter(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	if not arg_58_0.vars.filter_un_hash_tbl[arg_58_1][arg_58_2] then
		return 
	end
	
	local var_58_0 = arg_58_0.vars.filter_un_hash_tbl[arg_58_1][arg_58_2]
	
	arg_58_0.vars.filters[arg_58_1][var_58_0] = arg_58_3
end

function CustomProfileCardHero.sorter.checkFilterValue(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = arg_59_1:getBaseGrade()
	
	if not arg_59_2.star[var_59_0] then
		return false
	end
	
	local var_59_1 = arg_59_1.db.role
	
	if not arg_59_2.role[var_59_1] then
		return false
	end
	
	local var_59_2 = arg_59_1:getColor()
	
	if not arg_59_2.element[var_59_2] then
		return false
	end
	
	return true
end

function CustomProfileCardHero.sorter.resetData(arg_60_0)
	if not arg_60_0.vars or not arg_60_0.vars.sorter then
		return 
	end
	
	local var_60_0 = CustomProfileCardHero:getShowSDHero()
	local var_60_1
	
	if var_60_0 then
		var_60_1 = CustomProfileCardHero:getSDModelList()
	else
		var_60_1 = CustomProfileCardHero:getHeroList()
	end
	
	if table.empty(var_60_1) then
		return 
	end
	
	local var_60_2 = {}
	local var_60_3
	
	for iter_60_0, iter_60_1 in pairs(var_60_1) do
		if iter_60_1.is_sd then
			if iter_60_1.bind_unit_id and not table.empty(iter_60_1.bind_unit_info) then
				var_60_3 = arg_60_0:checkFilterValue(iter_60_1.bind_unit_info, arg_60_0.vars.filters)
				
				if var_60_3 and iter_60_1.bind_unit_info:getBaseGrade() == 1 then
					var_60_3 = false
				end
			elseif iter_60_1.is_sort_ignore then
				var_60_3 = true
			end
		else
			var_60_3 = arg_60_0:checkFilterValue(iter_60_1, arg_60_0.vars.filters)
			
			if var_60_3 and iter_60_1:isMoonlightDestinyUnit() then
				var_60_3 = false
			end
			
			if var_60_3 and iter_60_1:getBaseGrade() == 1 then
				var_60_3 = false
			end
		end
		
		if var_60_3 then
			local var_60_4
			
			if iter_60_1.is_sd then
				var_60_4 = iter_60_1.name
			else
				var_60_4 = iter_60_1:getName()
			end
			
			var_60_3 = CustomProfileCardHero:checkSearchHero(var_60_4)
		end
		
		if var_60_3 then
			table.insert(var_60_2, iter_60_1)
		end
	end
	
	if var_60_0 and not table.empty(var_60_2) then
		table.sort(var_60_2, function(arg_61_0, arg_61_1)
			return arg_61_0.sort < arg_61_1.sort
		end)
	end
	
	arg_60_0.vars.sorter:setItems(var_60_2)
	arg_60_0.vars.sorter:sort()
	arg_60_0.vars.sorter:updateToggleButton()
	arg_60_0:updateListView()
end

function CustomProfileCardHero.sorter.updateListView(arg_62_0)
	if not arg_62_0.vars then
		return 
	end
	
	if arg_62_0.vars.sorter then
		local var_62_0 = arg_62_0.vars.sorter:getSortedList()
		
		CustomProfileCardHero:showNoData(table.empty(var_62_0))
		CustomProfileCardHero.listview:setListViewMode("hero", var_62_0)
		arg_62_0.vars.sorter:updateToggleButton()
	end
end

CustomProfileCardHero.listview = {}
CustomProfileCardHero.listview.hero = {}
CustomProfileCardHero.listview.skin = {}

function CustomProfileCardHero.listview.create(arg_63_0, arg_63_1)
	if not get_cocos_refid(arg_63_1) then
		return 
	end
	
	arg_63_0.listview = {
		hero = arg_63_0.hero,
		skin = arg_63_0.skin
	}
	
	for iter_63_0, iter_63_1 in pairs(arg_63_0.listview) do
		iter_63_1:create(arg_63_1)
	end
end

function CustomProfileCardHero.listview.release(arg_64_0)
	if table.empty(arg_64_0.listview) then
		return 
	end
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0.listview) do
		iter_64_1:release()
	end
	
	arg_64_0.listview = nil
end

function CustomProfileCardHero.listview.setListViewMode(arg_65_0, arg_65_1, arg_65_2)
	if table.empty(arg_65_0.listview) or not arg_65_1 then
		return 
	end
	
	if not arg_65_0.listview[arg_65_1] then
		return 
	end
	
	local var_65_0 = arg_65_0.listview[arg_65_1]:getListView()
	
	if not get_cocos_refid(var_65_0) then
		return 
	end
	
	var_65_0:removeAllChildren()
	var_65_0:jumpToTop()
	
	local var_65_1 = {
		onUpdate = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
			arg_65_0.listview[arg_65_1]:updateListViewItem(arg_66_1, arg_66_3)
			
			return arg_66_3.id
		end
	}
	local var_65_2 = arg_65_0.listview[arg_65_1]:getItemRenderer()
	
	var_65_0:setRenderer(var_65_2, var_65_1)
	var_65_0:setDataSource(arg_65_2)
end

function CustomProfileCardHero.listview.hero.create(arg_67_0, arg_67_1)
	if not get_cocos_refid(arg_67_1) then
		return 
	end
	
	arg_67_0.listview = ItemListView_v2:bindControl(arg_67_1:getChildByName("listview_hero"))
end

function CustomProfileCardHero.listview.hero.release(arg_68_0)
	if not get_cocos_refid(arg_68_0.listview) then
		return 
	end
	
	arg_68_0.listview:removeAllChildren()
	arg_68_0.listview:setDataSource(nil)
	
	arg_68_0.listview = nil
end

function CustomProfileCardHero.listview.hero.getListView(arg_69_0)
	return arg_69_0.listview
end

function CustomProfileCardHero.listview.hero.getItemRenderer(arg_70_0)
	return load_control("wnd/profile_custom_hero_card.csb")
end

function CustomProfileCardHero.listview.hero.updateListViewItem(arg_71_0, arg_71_1, arg_71_2)
	if not get_cocos_refid(arg_71_1) or not arg_71_2 then
		return 
	end
	
	local var_71_0 = arg_71_1:getChildByName("mob_icon")
	
	if get_cocos_refid(var_71_0) then
		local var_71_1 = arg_71_1:getChildByName("btn_select")
		
		var_71_1.item = arg_71_2
		
		local var_71_2
		
		if arg_71_2.is_sd then
			local var_71_3 = arg_71_2.bind_unit_id ~= nil
			local var_71_4 = UIUtil:getUserIcon(arg_71_2.bind_unit_info or UNIT:create({
				code = "c1001"
			}), {
				no_lv = true,
				scale = 1.3,
				parent = var_71_0,
				base_grade = var_71_3,
				no_grade = not var_71_3,
				show_color = var_71_3,
				no_role = not var_71_3
			})
			
			if_set_visible(var_71_4, "n_element", var_71_3)
			if_set_sprite(var_71_4, "icon_element", var_71_3 and UIUtil:getColorIcon(arg_71_2.bind_unit_info))
			if_set_sprite(var_71_4, "face", arg_71_2.icon .. ".png")
			
			local var_71_5, var_71_6 = CustomProfileCardEditor:checkLayerItemUnlock(arg_71_2.id)
			
			if var_71_5 then
				var_71_1.callback = CustomProfileCardHero.createHeroLayer
			end
			
			var_71_0:setColor(var_71_5 and cc.c3b(255, 255, 255) or tocolor("#5b5b5b"))
			if_set_visible(arg_71_1, "icon_locked", not var_71_5)
			
			if var_71_6 then
				if_set_visible(arg_71_1, "n_shop", var_71_6 == "purchase" and not var_71_5)
				
				if var_71_6 == "purchase" and not var_71_5 then
					function var_71_1.after_buy_callback()
						if CustomProfileCardHero:getCurrentSubTab() then
							local var_72_0 = CustomProfileCardEditor:getFocusLayer()
							local var_72_1 = var_72_0:getId()
							
							if var_72_0 and var_72_0:getType() == "hero" and not var_72_0:isSDModel() then
								local var_72_2 = {}
								local var_72_3 = CustomProfileCardHero:getBindSDModel(var_72_1)
								
								CustomProfileCardHero.listview:setListViewMode("hero", var_72_3)
							end
						else
							CustomProfileCardHero.sorter:resetData()
						end
					end
				end
			end
		else
			local var_71_7 = UIUtil:getUserIcon(arg_71_2, {
				no_lv = true,
				scale = 1.3,
				show_color = true,
				parent = var_71_0
			})
			
			if_set_visible(var_71_7, "n_element", true)
			if_set_sprite(var_71_7, "icon_element", UIUtil:getColorIcon(arg_71_2))
			
			var_71_1.item.face_id = 0
			var_71_1.callback = CustomProfileCardHero.createHeroLayer
		end
		
		local var_71_8 = CustomProfileCardEditor:getTargetCard()
		local var_71_9 = false
		
		if var_71_8 then
			if arg_71_2.is_sd then
				var_71_9 = var_71_8:checkDuplicationLayer("hero", arg_71_2.id)
			else
				local var_71_10 = CustomProfileCardHero:getSkinList(arg_71_2.id)
				
				for iter_71_0, iter_71_1 in pairs(var_71_10 or {}) do
					if iter_71_1.code then
						var_71_9 = var_71_8:checkDuplicationLayer("hero", iter_71_1.code)
						
						if var_71_9 then
							break
						end
					end
				end
			end
		end
		
		if_set_visible(arg_71_1, "n_select", var_71_9)
		if_set_visible(arg_71_1, "icon_check", var_71_9)
	end
end

function CustomProfileCardHero.listview.skin.create(arg_73_0, arg_73_1)
	if not get_cocos_refid(arg_73_1) then
		return 
	end
	
	arg_73_0.listview = ItemListView_v2:bindControl(arg_73_1:getChildByName("listview_skin"))
end

function CustomProfileCardHero.listview.skin.release(arg_74_0)
	if not get_cocos_refid(arg_74_0.listview) then
		return 
	end
	
	arg_74_0.listview:removeAllChildren()
	arg_74_0.listview:setDataSource(nil)
	
	arg_74_0.listview = nil
end

function CustomProfileCardHero.listview.skin.getListView(arg_75_0)
	return arg_75_0.listview
end

function CustomProfileCardHero.listview.skin.getItemRenderer(arg_76_0)
	return load_control("wnd/lobby_custom_skin_card.csb")
end

function CustomProfileCardHero.listview.skin.updateListViewItem(arg_77_0, arg_77_1, arg_77_2)
	if not get_cocos_refid(arg_77_1) or not arg_77_2 then
		return 
	end
	
	local var_77_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_77_0 and var_77_0:getType() == "hero" and not var_77_0:isSDModel() then
		local var_77_1 = var_77_0:getId()
		
		if_set_visible(arg_77_1, "selected", var_77_1 == arg_77_2.code)
		
		local var_77_2 = DB("character", arg_77_2.code, "face_id")
		
		replaceSprite(arg_77_1, "face", "face/" .. var_77_2 .. "_s.png")
		
		local var_77_3 = DB("item_material", arg_77_2.material, "grade") or 1
		local var_77_4 = UIUtil:getSkinGradeBorder(var_77_3)
		local var_77_5 = UIUtil:getSkinGradeBG(var_77_3)
		
		replaceSprite(arg_77_1, "frame", "item/border/" .. var_77_4 .. ".png")
		replaceSprite(arg_77_1, "frame_bg", "img/" .. var_77_5 .. ".png")
		
		if arg_77_2.material then
			arg_77_1:setColor(Account:getItemCount(arg_77_2.material) > 0 and cc.c3b(255, 255, 255) or tocolor("#5b5b5b"))
		end
		
		local var_77_6, var_77_7, var_77_8, var_77_9 = DB("item_material", arg_77_2.material, {
			"id",
			"name",
			"grade",
			"desc_category"
		})
		
		if var_77_6 then
			if_set(arg_77_1, "txt_subtitle", T(var_77_9))
			if_set(arg_77_1, "txt_title", T(var_77_7))
		else
			if_set(arg_77_1, "txt_subtitle", T("item_category_skin_normal"))
			if_set(arg_77_1, "txt_title", T("item_skin_normal_name"))
		end
		
		if_set_color(arg_77_1, "txt_subtitle", UIUtil:getGradeColor(nil, var_77_8 or 1))
		
		local var_77_10 = arg_77_1:getChildByName("btn_select")
		
		if get_cocos_refid(var_77_10) then
			var_77_10.is_skin = true
			
			function var_77_10.callback()
				if arg_77_2.material and Account:getItemCount(arg_77_2.material) <= 0 then
					balloon_message_with_sound("msg_lobby_custom_not_own_skin")
					
					return 
				end
				
				var_77_0:setSkin({
					face_id = 0,
					skin_id = arg_77_2.code
				})
				
				if var_77_0.sync_layer_view_callback and type(var_77_0.sync_layer_view_callback) == "function" then
					var_77_0:sync_layer_view_callback()
				end
				
				local var_78_0 = CustomProfileCardHero:getSkinList(var_77_1)
				
				CustomProfileCardHero.listview:setListViewMode("skin", var_78_0)
			end
		end
	end
end

CustomProfileCardHero.face_list = {}
CustomProfileCardHero.skin_list = {}
CustomProfileCardHero.sd_list = {}

function CustomProfileCardHero.face_list.create(arg_79_0, arg_79_1)
	if not get_cocos_refid(arg_79_1) then
		return 
	end
	
	arg_79_0.wnd = arg_79_1
end

function CustomProfileCardHero.face_list.release(arg_80_0)
	arg_80_0.wnd = nil
end

function CustomProfileCardHero.face_list.open(arg_81_0, arg_81_1)
	if not get_cocos_refid(arg_81_0.wnd) or not arg_81_1 then
		return false
	end
	
	if arg_81_1:isSDModel() then
		return false
	end
	
	local var_81_0 = arg_81_1:getId()
	local var_81_1 = CustomProfileCardHero:getFaceList(var_81_0)
	
	if table.empty(var_81_1) then
		balloon_message_with_sound("no_detail_info")
		
		return false
	end
	
	arg_81_0.cur_face_item = nil
	
	local var_81_2 = 1
	
	for iter_81_0, iter_81_1 in pairs(arg_81_0.wnd:getChildren()) do
		if get_cocos_refid(iter_81_1) then
			iter_81_1:removeAllChildren()
			
			if var_81_1[var_81_2] then
				local var_81_3 = arg_81_0:createFaceItem(var_81_1[var_81_2], arg_81_1)
				
				if get_cocos_refid(var_81_3) then
					iter_81_1:addChild(var_81_3)
				end
			end
			
			var_81_2 = var_81_2 + 1
		end
	end
	
	if_set_visible(arg_81_0.wnd, nil, true)
	
	return true
end

function CustomProfileCardHero.face_list.close(arg_82_0)
	if_set_visible(arg_82_0.wnd, nil, false)
end

function CustomProfileCardHero.face_list.createFaceItem(arg_83_0, arg_83_1, arg_83_2)
	if not get_cocos_refid(arg_83_0.wnd) or not arg_83_1 or not arg_83_2 then
		return nil
	end
	
	local var_83_0 = load_control("wnd/profile_custom_face_card.csb")
	local var_83_1 = arg_83_1.emotion
	
	if string.starts(var_83_1, "special") then
		var_83_1 = "special"
	end
	
	local var_83_2 = "img/cm_icon_face_" .. var_83_1 .. ".png"
	
	if_set_sprite(var_83_0, "icon", var_83_2)
	if_set_color(var_83_0, "icon", arg_83_1.locked and tocolor("#5b5b5b") or cc.c3b(255, 255, 255))
	if_set_color(var_83_0, "txt_name", arg_83_1.locked and tocolor("#5b5b5b") or cc.c3b(255, 255, 255))
	if_set(var_83_0, "txt_name", T("emo_" .. arg_83_1.emotion))
	
	local var_83_3 = arg_83_2:getFaceId()
	
	if arg_83_1.intimacy_level == var_83_3 + 1 then
		if_set_visible(var_83_0, "n_select", true)
		if_set_visible(var_83_0, "icon_check", true)
		if_set_color(var_83_0, "txt_name", tocolor("#6bc11b"))
		
		arg_83_0.cur_face_item = var_83_0
	end
	
	if_set_visible(var_83_0, "icon_locked", arg_83_1.locked)
	
	local var_83_4 = var_83_0:getChildByName("btn_face")
	
	var_83_4.item = arg_83_1
	var_83_4.face_wnd = var_83_0
	
	return var_83_0
end

function CustomProfileCardHero.face_list.onSelectItem(arg_84_0, arg_84_1)
	if not get_cocos_refid(arg_84_0.wnd) or not get_cocos_refid(arg_84_1) or not get_cocos_refid(arg_84_1.face_wnd) then
		return 
	end
	
	if table.empty(arg_84_1.item) then
		return 
	end
	
	local var_84_0 = CustomProfileCardEditor:getFocusLayer()
	
	if not var_84_0 or var_84_0:getType() ~= "hero" or var_84_0:isSDModel() then
		return 
	end
	
	if arg_84_1.item.locked then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	if arg_84_0.cur_face_item == arg_84_1.face_wnd then
		return 
	end
	
	if arg_84_0.cur_face_item then
		if_set_visible(arg_84_0.cur_face_item, "n_select", false)
		if_set_visible(arg_84_0.cur_face_item, "icon_check", false)
		if_set_color(arg_84_0.cur_face_item, "txt_name", cc.c3b(255, 255, 255))
	end
	
	arg_84_0.cur_face_item = arg_84_1.face_wnd
	
	if arg_84_0.cur_face_item then
		if_set_visible(arg_84_0.cur_face_item, "n_select", true)
		if_set_visible(arg_84_0.cur_face_item, "icon_check", true)
		if_set_color(arg_84_0.cur_face_item, "txt_name", tocolor("#6bc11b"))
		
		local var_84_1 = arg_84_1.item.intimacy_level - 1
		
		var_84_0:setFace(var_84_1)
	end
end

function CustomProfileCardHero.skin_list.create(arg_85_0, arg_85_1)
	if not get_cocos_refid(arg_85_1) then
		return 
	end
	
	arg_85_0.wnd = arg_85_1
end

function CustomProfileCardHero.skin_list.release(arg_86_0)
	arg_86_0.wnd = nil
end

function CustomProfileCardHero.skin_list.open(arg_87_0, arg_87_1)
	if not get_cocos_refid(arg_87_0.wnd) or not arg_87_1 then
		return false
	end
	
	if arg_87_1:isSDModel() then
		return false
	end
	
	local var_87_0 = arg_87_1:getId()
	local var_87_1 = CustomProfileCardHero:getSkinList(var_87_0)
	
	if table.empty(var_87_1) or table.count(var_87_1) < 2 then
		balloon_message_with_sound("msg_profile_no_skin")
		
		return false
	end
	
	CustomProfileCardHero.listview:setListViewMode("skin", var_87_1)
	if_set_visible(arg_87_0.wnd, nil, true)
	
	return true
end

function CustomProfileCardHero.skin_list.close(arg_88_0)
	if_set_visible(arg_88_0.wnd, nil, false)
end

function CustomProfileCardHero.sd_list.create(arg_89_0, arg_89_1)
	if not get_cocos_refid(arg_89_1) then
		return 
	end
	
	arg_89_0.wnd = arg_89_1
end

function CustomProfileCardHero.sd_list.release(arg_90_0)
	arg_90_0.wnd = nil
end

function CustomProfileCardHero.sd_list.open(arg_91_0, arg_91_1)
	if not get_cocos_refid(arg_91_0.wnd) or not arg_91_1 then
		return false
	end
	
	if arg_91_1:isSDModel() then
		return false
	end
	
	local var_91_0 = arg_91_1:getId()
	local var_91_1 = {}
	local var_91_2 = CustomProfileCardHero:getBindSDModel(var_91_0)
	
	if table.empty(var_91_2) then
		balloon_message_with_sound("msg_profile_no_sdmodel")
		
		return false
	end
	
	CustomProfileCardHero.listview:setListViewMode("hero", var_91_2)
	if_set_visible(arg_91_0.wnd, nil, true)
	
	return true
end

function CustomProfileCardHero.sd_list.close(arg_92_0)
	if_set_visible(arg_92_0.wnd, nil, false)
end
