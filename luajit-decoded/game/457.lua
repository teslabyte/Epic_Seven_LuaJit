function MsgHandler.open_unit_imprint_focus(arg_1_0)
	local var_1_0 = Account:getUnit(arg_1_0.target)
	
	var_1_0:updateUnitOptionValue(arg_1_0.unit_opt)
	DevoteTooltip:updateUnitInfo(var_1_0)
	Account:addReward(arg_1_0.result)
	Dialog:msgBox(T("m_stamp_s_unlock_pa"), {
		dont_proc_tutorial = true,
		title = T("m_stamp_self_unlock")
	}):bringToFront()
	
	if not UnitDetail:updateUnitDevoteInfo(var_1_0) then
		var_1_0:calc()
	end
	
	if ArenaNetReady.updateUnitInfo then
		ArenaNetReady:updateUnitInfo(var_1_0)
	end
	
	if var_1_0.db.code == "c3026" then
		ConditionContentsManager:dispatch("c3026.dvt.self", {
			unit = var_1_0
		})
	end
	
	DevoteTooltip:updateHeroBelt()
	UnitUpgrade:updateUpgradeInfo()
end

function MsgHandler.switch_unit_imprint_focus(arg_2_0)
	local var_2_0 = Account:getUnit(arg_2_0.target)
	
	var_2_0:updateUnitOptionValue(arg_2_0.unit_opt)
	DevoteTooltip:updateUnitInfo(var_2_0)
	
	if not UnitDetail:updateUnitDevoteInfo(var_2_0) then
		var_2_0:calc()
	end
	
	EpisodeAdinUI:updateDevoteStat(var_2_0)
	
	if ArenaNetReady.updateUnitInfo then
		ArenaNetReady:updateUnitInfo(var_2_0)
	end
	
	if var_2_0.db.code == "c3026" then
		ConditionContentsManager:dispatch("c3026.dvt.self", {
			unit = var_2_0
		})
	end
	
	DevoteTooltip:updateHeroBelt()
	UnitUpgrade:updateUpgradeInfo()
end

function HANDLER.unit_detail_memory(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		DevoteTooltip:close()
	elseif arg_3_1 == "btn_type1_selected" then
	elseif arg_3_1 == "btn_type1" then
		if DevoteTooltip.vars and DevoteTooltip.vars.unit then
			DevoteTooltip:req_switchImprintFocus(DevoteTooltip.vars.unit)
		end
	elseif arg_3_1 == "btn_type2_selected" then
	elseif arg_3_1 == "btn_type2" then
		if DevoteTooltip.vars and DevoteTooltip.vars.unit then
			DevoteTooltip:req_switchImprintFocus(DevoteTooltip.vars.unit)
		end
	elseif arg_3_1 == "btn_type2_unlock" and DevoteTooltip.vars and DevoteTooltip.vars.unit then
		DevoteTooltip:req_openImprintFocus(DevoteTooltip.vars.unit)
	end
end

DevoteTooltip = {}

copy_functions(ScrollView, DevoteTooltip)

function DevoteTooltip.initTooltip(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = load_dlg("unit_detail_memory", true, "wnd")
	local var_4_1 = var_4_0:getChildByName("tooltip")
	local var_4_2 = var_4_0:getChildByName("back_short"):getContentSize()
	
	arg_4_0:set_buttonsImg(var_4_0, arg_4_1)
	arg_4_0:_newinitPopup(arg_4_1, var_4_0, arg_4_2)
	SceneManager:getRunningPopupScene():addChild(var_4_0)
	
	if arg_4_2.force_front_show then
		var_4_0:bringToFront()
	end
	
	TutorialGuide:procGuide()
	
	if not TutorialGuide:isPlayingTutorial() then
		var_4_0:bringToFront()
	end
	
	if_set_opacity(var_4_0, nil, 0)
	UIAction:Add(LOG(FADE_IN(200)), var_4_0, "block")
	
	arg_4_0.vars.unit_detail_memory = var_4_0
	
	if arg_4_1 and arg_4_1.db and arg_4_1.db.name then
		var_4_0.guide_tag = arg_4_1.db.name
	end
	
	GrowthGuideNavigator:proc()
end

function DevoteTooltip.close(arg_5_0)
	if not arg_5_0.vars or TutorialGuide:isPlayingTutorial("memorization") then
		return 
	end
	
	if not get_cocos_refid(arg_5_0.vars.unit_detail_memory) then
		return 
	end
	
	local var_5_0 = SceneManager:getRunningNativeScene():getChildByName("hero_config_dedication")
	
	if get_cocos_refid(var_5_0) then
		var_5_0.updateFormation_popup(var_5_0.self, var_5_0)
		var_5_0.self:updateFormation()
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_5_0.vars.unit_detail_memory, "block")
	BackButtonManager:pop("unit_detail_memory")
	
	arg_5_0.vars = nil
end

function DevoteTooltip.showDevoteDetail(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_1 then
		return 
	end
	
	if not arg_6_1:isHaveDevote() then
		return 
	end
	
	if not get_cocos_refid(arg_6_2) then
		return 
	end
	
	arg_6_3 = arg_6_3 or {}
	
	local var_6_0 = arg_6_2:getChildByName(arg_6_3.child_name or "n_tooltip_memory_imprint") or arg_6_2
	
	if not get_cocos_refid(var_6_0) and (not arg_6_3.x or not arg_6_3.y) then
		return 
	end
	
	arg_6_0.vars = {}
	arg_6_0.vars.unit = arg_6_1
	arg_6_3.x = arg_6_3.x or var_6_0:getPositionX()
	arg_6_3.y = arg_6_3.y or var_6_0:getPositionY()
	
	arg_6_0:initTooltip(arg_6_1, arg_6_3)
	BackButtonManager:push({
		check_id = "unit_detail_memory",
		back_func = function()
			DevoteTooltip:close()
		end
	})
end

function DevoteTooltip._newinitPopup(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_3 or {}
	local var_8_1 = arg_8_1:getMinDevoteGrade()
	local var_8_2 = var_8_0.not_my_unit and 0 or arg_8_1:getDevote()
	local var_8_3 = math.min(var_8_2, 7 - var_8_1)
	
	arg_8_0.vars.min_devote = var_8_1
	arg_8_0.vars.unit_devote = var_8_3
	arg_8_0.vars.not_my_unit = var_8_0.not_my_unit
	
	arg_8_0:set_buttons(arg_8_2, arg_8_1, var_8_0)
	
	arg_8_0.vars.devote_list = {}
	
	local var_8_4, var_8_5 = DB("character", arg_8_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	
	if not (var_8_4 and var_8_5 and true or false) then
		return 
	end
	
	local var_8_6 = 0
	
	for iter_8_0 = 1, 7 do
		local var_8_7 = {}
		
		if iter_8_0 > arg_8_0.vars.min_devote then
			var_8_6 = var_8_6 + 1
			var_8_7.index = var_8_6
			var_8_7.bg_current = var_8_3 == var_8_6
			
			table.insert(arg_8_0.vars.devote_list, var_8_7)
		end
	end
	
	arg_8_0.vars.scrollview = arg_8_2:getChildByName("scrollview")
	
	arg_8_0:initScrollView(arg_8_0.vars.scrollview, 700, 56, {
		fit_height = true
	})
	arg_8_0:createScrollViewItems(arg_8_0.vars.devote_list)
	arg_8_0:jumpToIndex(var_8_3)
end

function DevoteTooltip.set_buttonsImg(arg_9_0, arg_9_1, arg_9_2)
	if not get_cocos_refid(arg_9_1) or not arg_9_2 then
		return 
	end
	
	local var_9_0, var_9_1 = DB("character", arg_9_2.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	local var_9_2 = string.split(var_9_1, ";")
	local var_9_3 = ""
	
	for iter_9_0, iter_9_1 in pairs(var_9_2) do
		var_9_3 = var_9_3 .. (iter_9_1 or "")
	end
	
	local var_9_4 = string.format("img/hero_dedi_p_%s.png", var_9_3)
	local var_9_5 = arg_9_1:getChildByName("n_type1_title")
	
	if_set_sprite(var_9_5, "icon_type1", var_9_4)
	
	local var_9_6 = arg_9_1:getChildByName("btn_type1")
	local var_9_7 = arg_9_1:getChildByName("btn_type1_selected")
	
	if_set_sprite(var_9_6, "icon_type1", var_9_4)
	if_set_sprite(var_9_7, "icon_type1", var_9_4)
end

function DevoteTooltip.set_buttons(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_3 or {}
	
	if var_10_0.not_my_unit then
		if_set_visible(arg_10_1, "n_btn_type1", false)
		if_set_visible(arg_10_1, "n_btn_type2", false)
		if_set_visible(arg_10_1, "n_btn_type2_unlock", false)
		if_set_visible(arg_10_1, "n_nodata", true)
		
		local var_10_1 = arg_10_1:getChildByName("n_type2_title")
		
		if_set_opacity(var_10_1, nil, 255)
		if_set_visible(var_10_1, "locked", false)
		
		return 
	end
	
	if not arg_10_2 or arg_10_2 and arg_10_2:getDevote() == 0 then
		if_set_visible(arg_10_1, "n_btn_type1", false)
		if_set_visible(arg_10_1, "n_btn_type2", false)
		if_set_visible(arg_10_1, "n_btn_type2_unlock", false)
		if_set_visible(arg_10_1, "n_nodata", true)
		
		local var_10_2 = arg_10_1:getChildByName("n_type1_title")
		
		if_set_opacity(var_10_2, nil, 76.5)
		if_set_visible(var_10_2, "locked", true)
		
		local var_10_3 = arg_10_1:getChildByName("n_type2_title")
		
		if_set_opacity(var_10_3, nil, 76.5)
		if_set_visible(var_10_3, "locked", true)
		
		return 
	end
	
	if_set_visible(arg_10_1, "n_btn_type1", true)
	if_set_visible(arg_10_1, "n_btn_type2", true)
	if_set_visible(arg_10_1, "n_nodata", false)
	if_set_visible(arg_10_1, "locked", false)
	if_set_opacity(arg_10_1, "n_type2_title", 255)
	
	if arg_10_2:getUnitOptionValue("imprint_focus") == 0 then
		if_set_visible(arg_10_1, "btn_type1_selected", true)
		if_set_visible(arg_10_1, "btn_type1", false)
		if_set_visible(arg_10_1, "btn_type2_selected", false)
		if_set_visible(arg_10_1, "btn_type2", false)
		
		local var_10_4 = arg_10_1:getChildByName("n_type2_title")
		
		if_set_opacity(var_10_4, nil, 76.5)
		if_set_visible(var_10_4, "locked", true)
		if_set_visible(arg_10_1, "n_btn_type2_unlock", true)
		
		local var_10_5 = arg_10_1:getChildByName("n_btn_type2_unlock")
		
		if var_10_5 then
			local var_10_6 = UIUtil:getRewardIcon(GAME_STATIC_VARIABLE.imprint_focus_unlock_count, "ma_devotion1", {
				no_bg = true,
				show_small_count = true,
				no_tooltip = true,
				parent = var_10_5:getChildByName("reward_item")
			})
			
			if_set(var_10_6, "txt_small_count", GAME_STATIC_VARIABLE.imprint_focus_unlock_count)
		end
	elseif arg_10_2:getUnitOptionValue("imprint_focus") == 1 then
		if_set_visible(arg_10_1, "btn_type1_selected", true)
		if_set_visible(arg_10_1, "btn_type1", false)
		if_set_visible(arg_10_1, "btn_type2_selected", false)
		if_set_visible(arg_10_1, "btn_type2", true)
		
		local var_10_7 = arg_10_1:getChildByName("n_type2_title")
		
		if_set_opacity(var_10_7, nil, 255)
		if_set_visible(var_10_7, "locked", false)
		if_set_visible(arg_10_1, "n_btn_type2_unlock", false)
	elseif arg_10_2:getUnitOptionValue("imprint_focus") == 2 then
		if_set_visible(arg_10_1, "btn_type1_selected", false)
		if_set_visible(arg_10_1, "btn_type1", true)
		if_set_visible(arg_10_1, "btn_type2_selected", true)
		if_set_visible(arg_10_1, "btn_type2", false)
		
		local var_10_8 = arg_10_1:getChildByName("n_type2_title")
		
		if_set_opacity(var_10_8, nil, 255)
		if_set_visible(var_10_8, "locked", false)
		if_set_visible(arg_10_1, "n_btn_type2_unlock", false)
	end
	
	if var_10_0.block_button then
		if_set_visible(arg_10_1, "n_btn_type1", false)
		if_set_visible(arg_10_1, "n_btn_type2", false)
		if_set_visible(arg_10_1, "n_btn_type2_unlock", false)
	end
end

function DevoteTooltip.updateUnitInfo(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.unit_detail_memory) or not arg_11_1 then
		return 
	end
	
	arg_11_0.vars.unit = arg_11_1
	
	arg_11_0:set_buttons(arg_11_0.vars.unit_detail_memory, arg_11_1)
	arg_11_0:_newinitPopup(arg_11_1, arg_11_0.vars.unit_detail_memory)
end

function DevoteTooltip.getScrollViewItem(arg_12_0, arg_12_1)
	local var_12_0 = load_control("wnd/unit_detail_memory_item.csb")
	local var_12_1 = arg_12_0.vars.not_my_unit or false
	
	UIUtil:setDevoteDetail_new(var_12_0, arg_12_0.vars.unit, {
		self_effect = false,
		new = true,
		target = "n_type1",
		devote = arg_12_1.index or 0,
		not_my_unit = var_12_1,
		bg_current = arg_12_1.bg_current
	})
	UIUtil:setDevoteDetail_new(var_12_0, arg_12_0.vars.unit, {
		self_effect = true,
		new = true,
		target = "n_type2",
		devote = arg_12_1.index or 0,
		not_my_unit = var_12_1,
		bg_current = arg_12_1.bg_current
	})
	UIUtil:set_devoteItemOpacity(var_12_0, arg_12_0.vars.unit, {
		new = true,
		devote = arg_12_1.index or 0,
		not_my_unit = var_12_1,
		bg_current = arg_12_1.bg_current
	})
	
	return var_12_0
end

function DevoteTooltip.req_openImprintFocus(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1 or arg_13_0.vars.unit
	
	if not var_13_0 then
		return 
	end
	
	if Account:getPropertyCount("ma_devotion1") <= 0 and ArenaNetReady:isShow() then
		balloon_message(T("lack_token", {
			token = T("ma_devotion1_name")
		}))
		
		return 
	end
	
	if Account:getPropertyCount("ma_devotion1") <= 0 then
		local function var_13_1()
			Shop:open("normal", "herocoin")
		end
		
		local var_13_2 = load_dlg("shop_nocurrency", true, "wnd")
		
		UIUtil:getRewardIcon(nil, "ma_devotion1", {
			no_bg = true,
			show_name = true,
			detail = true,
			parent = var_13_2:getChildByName("n_item_pos")
		})
		Dialog:msgBox(T("buy_token_desc", {
			token = T("ma_devotion1_name")
		}), {
			yesno = true,
			dlg = var_13_2,
			handler = var_13_1,
			title = T("lack_token", {
				token = T("ma_devotion1_name")
			}),
			txt_shop_comment = T("shop_nocurrency")
		})
		var_13_2:bringToFront()
		
		return 
	elseif var_13_0:getUnitOptionValue("imprint_focus") == 2 then
		return 
	end
	
	local function var_13_3()
		query("open_unit_imprint_focus", {
			flag = true,
			target = var_13_0:getUID()
		})
	end
	
	local var_13_4 = load_dlg("msgbox_goods_consum", true, "wnd")
	
	if_set(var_13_4, "txt_have", T("ui_msgbox_monster_weak_have", {
		have = Account:getPropertyCount("ma_devotion1")
	}))
	UIUtil:getRewardIcon(GAME_STATIC_VARIABLE.imprint_focus_unlock_count, "ma_devotion1", {
		show_small_count = true,
		show_name = true,
		detail = true,
		parent = var_13_4:getChildByName("n_item")
	})
	Dialog:msgBox(T("m_stamp_s_unlock_de"), {
		code = "ma_devotion1",
		material = true,
		yesno = true,
		dlg = var_13_4,
		handler = var_13_3,
		title = T("m_stamp_self_unlock"),
		cost = GAME_STATIC_VARIABLE.imprint_focus_unlock_count
	})
	UIUtil:getRewardIcon(nil, "ma_devotion1", {
		no_bg = true,
		show_name = false,
		detail = false,
		parent = var_13_4:getChildByName("n_token_icon")
	})
	var_13_4:bringToFront()
end

function DevoteTooltip.req_switchImprintFocus(arg_16_0, arg_16_1)
	if not arg_16_1 then
		return 
	end
	
	local var_16_0 = false
	
	if arg_16_1:getUnitOptionValue("imprint_focus") == 0 then
		return 
	elseif arg_16_1:getUnitOptionValue("imprint_focus") == 1 then
		var_16_0 = true
	elseif arg_16_1:getUnitOptionValue("imprint_focus") == 2 then
		var_16_0 = false
	end
	
	query("switch_unit_imprint_focus", {
		target = arg_16_1:getUID(),
		flag = var_16_0
	})
end

function DevoteTooltip.updateHeroBelt(arg_17_0)
	local var_17_0 = HeroBelt:getInst(UnitMain:isValid() and "UnitMain" or "")
	
	if var_17_0 and var_17_0:isValid() then
		var_17_0:resetDataByImprintSwitch()
	end
end
