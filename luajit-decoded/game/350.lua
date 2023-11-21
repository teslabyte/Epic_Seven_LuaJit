UnitPromotePopup = {}

function MsgHandler.upgrade_unit_jump(arg_1_0)
	if arg_1_0 then
		UnitPromotePopup:res_promote_unit(arg_1_0)
	end
end

function MsgHandler.upgrade_unit_awake(arg_2_0)
	if arg_2_0 then
		UnitPromotePopup:res_promote_unit(arg_2_0)
	end
end

function HANDLER.unit_max_level_upgrad(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_select" and arg_3_0.itemData then
		UnitPromotePopup:selectItem(arg_3_0.itemData)
	elseif arg_3_1 == "btn_choice_complete" then
		UnitPromotePopup:open_confirm()
	elseif arg_3_1 == "btn_close" or arg_3_1 == "btn_cancel" then
		UnitPromotePopup:close()
	end
end

function HANDLER.unit_max_level_upgrad_confirm(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_recall" then
		UnitPromotePopup:promote_unit()
	elseif arg_4_1 == "btn_cancel" then
		UnitPromotePopup:close_confirm()
	end
end

function UnitPromotePopup.create(arg_5_0, arg_5_1)
	if arg_5_1 == "gradejump" then
		copy_functions(UnitPromoteGradePopup, arg_5_0)
	elseif arg_5_1 == "awakenjump" then
		copy_functions(UnitPromoteAwakePopup, arg_5_0)
	end
	
	arg_5_0:open()
end

UnitPromoteGradePopup = {}

function UnitPromoteGradePopup.open(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.units = {}
	arg_6_0.vars.select_unit = nil
	
	arg_6_0:updateUnits()
	
	local var_6_0, var_6_1 = arg_6_0:checkCanOpen()
	
	if not var_6_0 then
		balloon_message_with_sound(var_6_1)
		
		arg_6_0.vars = nil
		
		return 
	end
	
	arg_6_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_6_0.vars.filters = {}
	arg_6_0.vars.sort_team_first = false
	arg_6_0.vars.show_only_lock = false
	
	arg_6_0:setFilterValue()
	
	local var_6_2 = arg_6_1 or SceneManager:getRunningPopupScene()
	
	arg_6_0.vars.wnd = load_dlg("unit_max_level_upgrad", true, "wnd", function()
		UnitPromotePopup:close()
	end)
	
	var_6_2:addChild(arg_6_0.vars.wnd)
	arg_6_0.vars.wnd:bringToFront()
	arg_6_0:createListView()
	arg_6_0:createSorter()
	arg_6_0:createSorterAfter()
	arg_6_0:updateUI()
	
	if arg_6_0.vars.units and arg_6_0.vars.units[1] then
		arg_6_0:selectItem(arg_6_0.vars.units[1])
	end
end

function UnitPromoteGradePopup.checkCanOpen(arg_8_0)
	local var_8_0 = Account:getUnits()
	
	if table.empty(var_8_0) then
		return false, "ui_bulkup_btn_off"
	elseif table.empty(arg_8_0.vars.units) then
		return false, "ui_bulkup_btn_off"
	end
	
	return true
end

function UnitPromoteGradePopup.createListView(arg_9_0)
	arg_9_0.vars.listview = ItemListView:bindControl(arg_9_0.vars.wnd:getChildByName("card_listview"))
	
	local var_9_0 = {
		onUpdate = function(arg_10_0, arg_10_1, arg_10_2)
			UIUtil:getUserIcon(arg_10_2, {
				parent = arg_10_1:getChildByName("n_mob_icon")
			})
			if_set_visible(arg_10_1, "selected", false)
			
			local var_10_0 = arg_10_1:getChildByName("btn_select")
			
			if var_10_0 then
				var_10_0.itemData = arg_10_2
			end
			
			if arg_9_0.vars.select_unit then
				if_set_visible(arg_10_1, "selected", arg_10_2:getUID() == arg_9_0.vars.select_unit:getUID())
			end
		end
	}
	
	arg_9_0.vars.listview:setRenderer(load_control("wnd/unit_max_level_upgrad_card.csb"), var_9_0)
	arg_9_0.vars.listview:setItems(arg_9_0.vars.units)
end

function UnitPromoteGradePopup.getSorterOption(arg_11_0)
	return {
		btn_toggle_box = true,
		promote_popup = true,
		sorting_unit = true,
		stat_menu_idx = 7
	}
end

function UnitPromoteGradePopup.createSorter(arg_12_0)
	arg_12_0.vars.sorter = Sorter:create(arg_12_0.vars.wnd:findChildByName("n_filter_unit"), arg_12_0:getSorterOption())
	
	local var_12_0 = {
		star = {
			id = "star",
			check_list = arg_12_0:getFilterCheckList("star")
		},
		role = {
			id = "role",
			check_list = arg_12_0:getFilterCheckList("role")
		},
		element = {
			id = "element",
			check_list = arg_12_0:getFilterCheckList("element")
		},
		skill = {
			id = "skill",
			check_list = arg_12_0:getFilterCheckList("skill")
		}
	}
	
	arg_12_0.vars.sorter:setSorter({
		menus = arg_12_0:getMenus(arg_12_0.vars.sorter),
		filters = var_12_0,
		checkboxs = arg_12_0:getCheckbox(),
		callback_on_add_filter = function(arg_13_0, arg_13_1, arg_13_2)
			arg_12_0:addFilter(arg_13_0, arg_13_1, arg_13_2)
		end,
		callback_checkbox = function(arg_14_0, arg_14_1, arg_14_2)
			if arg_14_0 == "team_first" then
				arg_12_0:toggleSortTeamFirst(arg_14_2)
			end
			
			if arg_14_0 == "show_only_lock" then
				arg_12_0:toggleShowOnlyLock(arg_14_2)
			end
		end,
		callback_on_commit_filter = function()
			arg_12_0:setFilter()
		end,
		resetDataByCall = function()
			arg_12_0:setFilter()
		end,
		callback_sort = function(arg_17_0, arg_17_1, arg_17_2)
			arg_12_0.vars.sorter:setItems(arg_12_0.vars.units)
			arg_12_0.vars.listview:setItems(arg_12_0.vars.units)
			arg_12_0:setConfirmButton()
			
			if arg_12_0.vars.units[1] then
				arg_12_0:selectItem(arg_12_0.vars.units[1])
			end
		end
	})
	arg_12_0.vars.sorter:setItems(arg_12_0.vars.units)
	arg_12_0.vars.sorter:sort(1)
end

function UnitPromoteGradePopup.createSorterAfter(arg_18_0)
	local var_18_0 = arg_18_0.vars.sorter:getWnd()
	
	if var_18_0 then
		local var_18_1 = var_18_0:getChildByName("n_star")
		
		if var_18_1 then
			for iter_18_0 = 1, 6 do
				local var_18_2 = "n_check_box_" .. iter_18_0
				
				if_set_visible(var_18_1, var_18_2, iter_18_0 ~= 1 and iter_18_0 ~= 6)
				
				if iter_18_0 > 1 then
					local var_18_3 = var_18_1:getChildByName(var_18_2)
					
					if var_18_3 then
						var_18_3:setPositionY(var_18_3:getPositionY() + 51)
					end
				end
			end
		end
		
		local var_18_4 = var_18_0:getChildByName("n_role")
		
		if var_18_4 then
			if_set_visible(var_18_4, "n_check_box_7", false)
		end
	end
end

function UnitPromoteGradePopup.updateUI(arg_19_0)
end

function UnitPromoteGradePopup.setConfirmButton(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("btn_choice_complete")
	local var_20_1 = getChildByPath(arg_20_0.vars.wnd:getChildByName("cm_box"), "n_info")
	
	if get_cocos_refid(var_20_0) and get_cocos_refid(var_20_1) then
		if_set(var_20_1, "txt_info", T("ui_unit_list_none"))
		
		if table.empty(arg_20_0.vars.units) then
			var_20_0:setTouchEnabled(false)
			var_20_0:setOpacity(76.5)
			var_20_1:setVisible(true)
		else
			var_20_0:setTouchEnabled(true)
			var_20_0:setOpacity(255)
			var_20_1:setVisible(false)
		end
	end
end

function UnitPromoteGradePopup.setFilterValue(arg_21_0)
	local var_21_0 = {
		"star",
		"role",
		"element",
		"skill"
	}
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		arg_21_0.vars.filters[iter_21_1] = {}
		
		for iter_21_2 = 1, 10 do
			local var_21_1 = arg_21_0.vars.filter_un_hash_tbl[iter_21_1][iter_21_2]
			
			if not var_21_1 then
				break
			end
			
			arg_21_0.vars.filters[iter_21_1][var_21_1] = true
		end
	end
end

function UnitPromoteGradePopup.getFilterCheckList(arg_22_0, arg_22_1)
	return ItemFilterUtil:getFilterCheckList(arg_22_0.vars.filter_un_hash_tbl, arg_22_1)
end

function UnitPromoteGradePopup.toggleSortTeamFirst(arg_23_0, arg_23_1)
	if arg_23_1 == nil then
		arg_23_0.vars.sort_team_first = not arg_23_0.vars.sort_team_first
	else
		arg_23_0.vars.sort_team_first = arg_23_1
	end
	
	arg_23_0:setFilter()
end

function UnitPromoteGradePopup.toggleShowOnlyLock(arg_24_0, arg_24_1)
	if arg_24_1 == nil then
		arg_24_0.vars.show_only_lock = not arg_24_0.vars.show_only_lock
	else
		arg_24_0.vars.show_only_lock = arg_24_1
	end
	
	arg_24_0:setFilter()
end

function UnitPromoteGradePopup.getCheckbox(arg_25_0)
	local var_25_0 = {
		{
			id = "team_first",
			name = T("sort_team_first"),
			checked = arg_25_0.vars.sort_team_first
		},
		{
			id = "show_only_lock",
			is_filter = true,
			name = T("sort_only_lockhero"),
			checked = arg_25_0.vars.show_only_lock
		}
	}
	
	arg_25_0.vars.checkbox_tbl = var_25_0
	
	return var_25_0
end

function UnitPromoteGradePopup.updateUnits(arg_26_0)
	arg_26_0.vars.units = {}
	
	local var_26_0 = Account:getUnits() or {}
	
	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		if arg_26_0:_check_promotable_unit(iter_26_1) then
			if arg_26_0.vars.filters and arg_26_0:checkFilterValue(iter_26_1, arg_26_0.vars.filters) then
				table.insert(arg_26_0.vars.units, iter_26_1)
			elseif arg_26_0.vars.filters == nil then
				table.insert(arg_26_0.vars.units, iter_26_1)
			end
		end
	end
end

function UnitPromoteGradePopup.setFilter(arg_27_0)
	arg_27_0:updateUnits()
	
	if arg_27_0.vars.sort_team_first then
		table.sort(arg_27_0.vars.units, function(arg_28_0, arg_28_1)
			local var_28_0 = arg_28_0:isInTeam()
			
			if var_28_0 ~= arg_28_1:isInTeam() then
				return var_28_0
			end
		end)
	end
	
	arg_27_0.vars.sorter:setItems(arg_27_0.vars.units)
	arg_27_0.vars.listview:setItems(arg_27_0.vars.units)
	arg_27_0.vars.sorter:sort()
end

function UnitPromoteGradePopup.checkFilterValue(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_1:getGrade()
	
	if not arg_29_2.star[var_29_0] then
		return false
	end
	
	local var_29_1 = arg_29_1.db.role
	
	if not arg_29_2.role[var_29_1] then
		return false
	end
	
	local var_29_2 = arg_29_1:getColor()
	
	if not arg_29_2.element[var_29_2] then
		return false
	end
	
	if arg_29_0.vars.show_only_lock and not arg_29_1:isLocked() then
		return false
	end
	
	local var_29_3 = arg_29_0.vars.sorter:getSkillFilter()
	
	if var_29_3 then
		return var_29_3:checkUnit(arg_29_1:getUID())
	end
	
	return true
end

function UnitPromoteGradePopup.getMenus(arg_30_0, arg_30_1)
	return {
		{
			column = "grade",
			name = T("ui_unit_list_sort_1_label"),
			func = UnitSortOrder.greaterThanGrade
		},
		{
			column = "level",
			name = T("ui_unit_list_sort_2_label"),
			func = UnitSortOrder.greaterThanLevel
		},
		{
			column = "ch_attribute",
			name = T("ui_unit_list_sort_3_label"),
			func = UnitSortOrder.greaterThanColor
		},
		{
			column = "UID",
			name = T("ui_unit_list_sort_4_label"),
			func = UnitSortOrder.greaterThanUID
		},
		{
			column = "role",
			name = T("ui_unit_list_sort_6_label"),
			func = UnitSortOrder.greaterThanRole
		},
		{
			column = "name",
			name = T("ui_unit_list_sort_7_label"),
			func = UnitSortOrder.greaterThanName
		},
		{
			key = "Stat",
			name = T("ui_unit_list_sort_stat_label"),
			func = UnitSortOrder.makeStatSortFuncSelector(arg_30_1)
		}
	}
end

function UnitPromoteGradePopup.addFilter(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_0.vars.filter_un_hash_tbl[arg_31_1][arg_31_2]
	
	arg_31_0.vars.filters[arg_31_1][var_31_0] = arg_31_3
end

function UnitPromoteGradePopup.selectItem(arg_32_0, arg_32_1)
	if not arg_32_1 then
		return 
	end
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.listview.vars.controls) do
		if get_cocos_refid(iter_32_0) then
			if iter_32_1.item:getUID() == arg_32_1:getUID() then
				arg_32_0.vars.select_unit = arg_32_1
			end
			
			if_set_visible(iter_32_0, "selected", iter_32_1.item:getUID() == arg_32_1:getUID())
		end
	end
	
	arg_32_0.vars.select_unit = arg_32_1
	
	if not arg_32_0.vars.select_unit then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.wnd:getChildByName("n_info")
	local var_32_1 = arg_32_0.vars.wnd:getChildByName("txt_name")
	
	UIUtil:setUnitSimpleInfo(var_32_0, arg_32_0.vars.select_unit)
	UIUtil:setUnitSkillInfo(var_32_0, arg_32_0.vars.select_unit, {
		tooltip_opts = {
			show_effs = "right"
		}
	})
	
	local var_32_2 = arg_32_0.vars.wnd:getChildByName("txt_story")
	local var_32_3 = DB("character", arg_32_0.vars.select_unit.db.code, "2line")
	
	if var_32_2 and var_32_3 then
		var_32_2:setString(T(var_32_3, "text"))
	end
	
	UIUtil:setStars(var_32_0, arg_32_0.vars.select_unit:getGrade(), arg_32_0.vars.select_unit:getZodiacGrade())
	if_call(var_32_0, "star1", "setPositionX", 10 + var_32_1:getContentSize().width * var_32_1:getScaleX() + var_32_1:getPositionX())
	
	local var_32_4 = var_32_0:getChildByName("txt_stat")
	
	if get_cocos_refid(var_32_4) then
		if_set(var_32_4, nil, comma_value(arg_32_0.vars.select_unit:getPoint()))
	end
	
	local var_32_5, var_32_6 = arg_32_0.vars.select_unit:getDevoteSkill()
	
	if_set_visible(var_32_0, "grade", var_32_6 and var_32_6 > 0)
	
	if var_32_6 and var_32_6 > 0 then
		local var_32_7, var_32_8 = arg_32_0.vars.select_unit:getDevoteGrade()
		local var_32_9 = string.format("img/hero_dedi_a_%s.png", string.lower(var_32_7 or ""))
		
		if_set_sprite(var_32_0, "grade", var_32_9)
	end
	
	local var_32_10 = arg_32_0.vars.wnd:getChildByName("CENTER")
	local var_32_11, var_32_12 = UIUtil:getPortraitAni(arg_32_0.vars.select_unit.db.face_id, {
		pin_sprite_position_y = true,
		parent_pos_y = arg_32_0.vars.wnd:getChildByName("portrait"):getPositionY()
	})
	
	if var_32_11 then
		var_32_10:getChildByName("portrait"):removeAllChildren()
		var_32_10:getChildByName("portrait"):addChild(var_32_11)
		
		if not var_32_12 then
			var_32_11:setPositionY(-900)
			var_32_11:setScale(0.5)
		else
			var_32_11:setScale(0.8)
		end
	end
end

function UnitPromoteGradePopup.open_confirm(arg_33_0)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) or not arg_33_0.vars.select_unit then
		return 
	end
	
	if table.empty(arg_33_0.vars.units) then
		return 
	end
	
	arg_33_0.vars.confirm_wnd = load_dlg("unit_max_level_upgrad_confirm", true, "wnd", function()
		UnitPromotePopup:close_confirm()
	end)
	
	upgradeLabelToRichLabel(arg_33_0.vars.confirm_wnd, "disc", true)
	if_set(arg_33_0.vars.confirm_wnd, "disc", T("ui_desc_level_jump_result", {
		name = arg_33_0.vars.select_unit:getName()
	}))
	arg_33_0.vars.wnd:addChild(arg_33_0.vars.confirm_wnd)
	
	local var_33_0 = arg_33_0.vars.confirm_wnd:getChildByName("n_before")
	local var_33_1 = arg_33_0.vars.confirm_wnd:getChildByName("n_after")
	
	if var_33_0 and var_33_1 then
		UIUtil:getUserIcon(arg_33_0.vars.select_unit, {
			parent = var_33_0:getChildByName("n_mob_icon")
		})
		UIUtil:getUserIcon(arg_33_0.vars.select_unit, {
			parent = var_33_1:getChildByName("n_mob_icon"),
			grade = arg_33_0.vars.select_unit:getMaxGrade()
		})
		UIUtil:getRewardIcon(nil, "ma_gradejump_1", {
			parent = var_33_0:getChildByName("n_item")
		})
	end
end

function UnitPromoteGradePopup._check_promotable_unit(arg_35_0, arg_35_1)
	if not arg_35_1 or arg_35_1:isSpecialUnit() or arg_35_1:isPromotionUnit() or arg_35_1:isLockUpgrade6() or arg_35_1.db and arg_35_1.db.role == "material" or arg_35_1:getGrade() >= 6 then
		return false
	end
	
	return true
end

function UnitPromoteGradePopup.promote_unit(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) or not arg_36_0.vars.select_unit then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.select_unit
	
	if not arg_36_0:_check_promotable_unit(var_36_0) then
		Log.e("wrong promote grade unit")
		
		return 
	end
	
	query("upgrade_unit_jump", {
		target = var_36_0:getUID()
	})
end

function UnitPromoteGradePopup.res_promote_unit(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.vars.select_unit:clone()
	
	UnitUpgradeLogic:UpdateLevelInfo(arg_37_0.vars.select_unit, arg_37_1.target, 0)
	Account:updateUnitByInfo(arg_37_1.target)
	
	if arg_37_1.rewards then
		Account:addReward(arg_37_1.rewards)
	end
	
	local var_37_1 = arg_37_0.vars.select_unit:clone()
	
	Inventory:ResetItems()
	arg_37_0:close_confirm()
	arg_37_0:close()
	arg_37_0:showPromoteRewardPopup(var_37_0, var_37_1)
	
	local var_37_2 = SceneManager:getCurrentSceneName()
	local var_37_3 = Account:getUnit(arg_37_1.target.id)
	
	if var_37_3 and UnitMain:isValid() and (var_37_2 == "unit_ui" or UnitMain:isPopupMode()) then
		local var_37_4 = UnitMain:getMode()
		
		if var_37_4 == "Main" then
			HeroBelt:getInst("UnitMain"):updateUnit(nil, var_37_3)
			UnitDetail:updateUnitInfo(var_37_3)
			UnitMain:setMode("Detail", {
				unit = var_37_3
			})
		elseif var_37_4 == "Sell" then
			UnitSell:removeAllItems(true)
		elseif var_37_4 == "Support" then
			UnitSupport:updateUI()
		end
	end
	
	if var_37_2 == "waitingroom" then
		Storage:reset()
	end
	
	if HeroBelt:isValid() then
		if BattleReady:isShow() then
			HeroBelt:resetDataUseFilter(Account.units, nil, nil, true)
		else
			HeroBelt:resetData(Account.units)
		end
	end
	
	if UnitMain:isValid() and (var_37_2 == "unit_ui" or UnitMain:isPopupMode()) and var_37_3 then
		UnitMain:removePortrait()
		HeroBelt:getInst("UnitMain"):updateUnit(nil, var_37_3)
		HeroBelt:getInst("UnitMain"):scrollToUnit(var_37_3)
		UnitDetail:updateUnitInfo(var_37_3)
		UnitMain:changePortrait(var_37_3)
		UnitMain:setMode("Detail", {
			unit = var_37_3
		})
	end
end

function UnitPromoteGradePopup.showPromoteRewardPopup(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_1 or not arg_38_2 then
		return 
	end
	
	local var_38_0 = arg_38_1
	local var_38_1 = arg_38_2
	local var_38_2 = var_38_1:getCharacterStatus()
	local var_38_3 = var_38_0:getCharacterStatus()
	local var_38_4 = load_dlg("dlg_promote_reward_stat", true, "wnd")
	
	Dialog:msgBox({
		delay = 0,
		fade_in = 500,
		dont_proc_tutorial = true,
		dlg = var_38_4,
		title = T("promotion_up_title")
	})
	if_set(var_38_4, "txt_stat_name0", T("promote_stat_maxlv"))
	if_set(var_38_4, "txt_stat0_before", var_38_0:getMaxLevel())
	if_set(var_38_4, "txt_stat0", var_38_1:getMaxLevel())
	
	local var_38_5 = var_38_1:getMaxLevel() - var_38_0:getMaxLevel()
	
	if_set_visible(var_38_4, "diff_icon", var_38_5 ~= 0)
	if_set(var_38_4, "txt_diff0", var_38_5)
	if_set_sprite(var_38_4, "stat_icon1", "img/cm_icon_etcbp.png")
	if_set(var_38_4, "txt_stat_name1", T("unit_power"))
	if_set(var_38_4, "txt_stat1_before", var_38_0:getPoint())
	if_set(var_38_4, "txt_stat1", var_38_1:getPoint())
	
	local var_38_6 = var_38_1:getPoint() - var_38_0:getPoint()
	
	if_set_visible(var_38_4, "diff_icon1", var_38_6 ~= 0)
	if_set(var_38_4, "txt_diff1", var_38_6)
	if_set_sprite(var_38_4, "stat_icon2", "img/cm_icon_stat_att.png")
	if_set(var_38_4, "txt_stat_name2", getStatName("att"))
	if_set(var_38_4, "txt_stat2_before", var_38_3.att)
	if_set(var_38_4, "txt_stat2", var_38_2.att)
	
	local var_38_7 = var_38_2.att - var_38_3.att
	
	if_set_visible(var_38_4, "diff_icon2", var_38_7 ~= 0)
	if_set(var_38_4, "txt_diff2", var_38_7)
	if_set_sprite(var_38_4, "stat_icon3", "img/cm_icon_stat_def.png")
	if_set(var_38_4, "txt_stat_name3", getStatName("def"))
	if_set(var_38_4, "txt_stat3_before", var_38_3.def)
	if_set(var_38_4, "txt_stat3", var_38_2.def)
	
	local var_38_8 = var_38_2.def - var_38_3.def
	
	if_set_visible(var_38_4, "diff_icon3", var_38_8 ~= 0)
	if_set(var_38_4, "txt_diff3", var_38_8)
	if_set_sprite(var_38_4, "stat_icon4", "img/cm_icon_stat_max_hp.png")
	if_set(var_38_4, "txt_stat_name4", getStatName("max_hp"))
	if_set(var_38_4, "txt_stat4_before", var_38_3.max_hp)
	if_set(var_38_4, "txt_stat4", var_38_2.max_hp)
	
	local var_38_9 = var_38_2.max_hp - var_38_3.max_hp
	
	if_set_visible(var_38_4, "diff_icon4", var_38_9 ~= 0)
	if_set_diff(var_38_4, "txt_diff4", var_38_9)
end

function UnitPromoteGradePopup.close_confirm(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.confirm_wnd) then
		return 
	end
	
	BackButtonManager:pop("unit_max_level_upgrad_confirm")
	arg_39_0.vars.confirm_wnd:removeFromParent()
	
	arg_39_0.vars.confirm_wnd = nil
end

function UnitPromoteGradePopup.close(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("unit_max_level_upgrad")
	arg_40_0.vars.wnd:removeFromParent()
	
	arg_40_0.vars = nil
end

UnitPromoteAwakePopup = {}

copy_functions(UnitPromoteGradePopup, UnitPromoteAwakePopup)

function UnitPromoteAwakePopup.updateUI(arg_41_0)
	if_set(arg_41_0.vars.wnd, "txt_title", T("ui_title_awaken_jump_select"))
	if_set(arg_41_0.vars.wnd, "txt_desc", T("ui_desc_awaken_jump_select"))
end

function UnitPromoteAwakePopup.checkCanOpen(arg_42_0)
	local var_42_0 = Account:getUnits()
	
	if table.empty(var_42_0) then
		return false, "msg_cannot_awaken_jump"
	elseif table.empty(arg_42_0.vars.units) then
		return false, "msg_cannot_awaken_jump"
	end
	
	return true
end

function UnitPromoteAwakePopup.createSorterAfter(arg_43_0)
	local var_43_0 = arg_43_0.vars.sorter:getWnd()
	
	if var_43_0 then
		var_43_0:setPosition(-70, -16)
	end
end

function UnitPromoteAwakePopup.getMenus(arg_44_0, arg_44_1)
	return {
		{
			column = "ch_attribute",
			name = T("ui_unit_list_sort_3_label"),
			func = UnitSortOrder.greaterThanColor
		},
		{
			column = "UID",
			name = T("ui_unit_list_sort_4_label"),
			func = UnitSortOrder.greaterThanUID
		},
		{
			column = "role",
			name = T("ui_unit_list_sort_6_label"),
			func = UnitSortOrder.greaterThanRole
		},
		{
			column = "name",
			name = T("ui_unit_list_sort_7_label"),
			func = UnitSortOrder.greaterThanName
		},
		{
			key = "Stat",
			name = T("ui_unit_list_sort_stat_label"),
			func = UnitSortOrder.makeStatSortFuncSelector(arg_44_1)
		}
	}
end

function UnitPromoteAwakePopup.getSorterOption(arg_45_0)
	return {
		stat_menu_idx = 5,
		awake_upgrade = true,
		btn_toggle_box = true,
		promote_popup = true,
		sorting_unit = true
	}
end

function UnitPromoteAwakePopup.getCheckbox(arg_46_0)
	return nil
end

function UnitPromoteAwakePopup.updateUnits(arg_47_0)
	arg_47_0.vars.units = {}
	
	local var_47_0 = Account:getUnits() or {}
	
	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		if arg_47_0:_check_promotable_unit(iter_47_1) then
			if arg_47_0.vars.filters and arg_47_0:checkFilterValue(iter_47_1, arg_47_0.vars.filters) then
				table.insert(arg_47_0.vars.units, iter_47_1)
			elseif arg_47_0.vars.filters == nil then
				table.insert(arg_47_0.vars.units, iter_47_1)
			end
		end
	end
end

function UnitPromoteAwakePopup.open_confirm(arg_48_0)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) or not arg_48_0.vars.select_unit then
		return 
	end
	
	if table.empty(arg_48_0.vars.units) then
		return 
	end
	
	arg_48_0.vars.confirm_wnd = load_dlg("unit_max_level_upgrad_confirm", true, "wnd", function()
		UnitPromotePopup:close_confirm()
	end)
	
	upgradeLabelToRichLabel(arg_48_0.vars.confirm_wnd, "disc", true)
	if_set(arg_48_0.vars.confirm_wnd, "txt_title", T("ui_title_awaken_jump_confirm"))
	if_set(arg_48_0.vars.confirm_wnd, "disc", T("ui_desc_awaken_jump_confirm", {
		name = arg_48_0.vars.select_unit:getName()
	}))
	arg_48_0.vars.wnd:addChild(arg_48_0.vars.confirm_wnd)
	
	local var_48_0 = arg_48_0.vars.confirm_wnd:getChildByName("n_before")
	local var_48_1 = arg_48_0.vars.confirm_wnd:getChildByName("n_after")
	
	if var_48_0 and var_48_1 then
		UIUtil:getUserIcon(arg_48_0.vars.select_unit, {
			parent = var_48_0:getChildByName("n_mob_icon")
		})
		UIUtil:getUserIcon(arg_48_0.vars.select_unit, {
			zodiac = 6,
			parent = var_48_1:getChildByName("n_mob_icon"),
			grade = arg_48_0.vars.select_unit:getMaxGrade()
		})
		UIUtil:getRewardIcon(nil, "ma_awakenjump_1", {
			parent = var_48_0:getChildByName("n_item")
		})
	end
end

function UnitPromoteAwakePopup._check_promotable_unit(arg_50_0, arg_50_1)
	if not arg_50_1 or arg_50_1:isSpecialUnit() or arg_50_1:isPromotionUnit() or arg_50_1:isLockUpgrade6() or arg_50_1.db and arg_50_1.db.role == "material" or arg_50_1:getGrade() < 6 or arg_50_1:getLv() < 60 or arg_50_1:getZodiacGrade() > 5 then
		return false
	end
	
	return true
end

function UnitPromoteAwakePopup.promote_unit(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.wnd) or not arg_51_0.vars.select_unit then
		return 
	end
	
	local var_51_0 = arg_51_0.vars.select_unit
	
	if not arg_51_0:_check_promotable_unit(var_51_0) then
		Log.e("wrong promote awake unit")
		
		return 
	end
	
	query("upgrade_unit_awake", {
		target = var_51_0:getUID()
	})
end

function UnitPromoteAwakePopup.res_promote_unit(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.vars.select_unit:clone()
	local var_52_1 = var_52_0:getZodiacGrade()
	
	UnitUpgradeLogic:UpdateZodiacInfo(arg_52_0.vars.select_unit, arg_52_1.target, arg_52_1.target.z - var_52_1)
	Account:updateUnitByInfo(arg_52_1.target)
	
	if arg_52_1.rewards then
		Account:addReward(arg_52_1.rewards)
	end
	
	local var_52_2 = arg_52_0.vars.select_unit:clone()
	
	Inventory:ResetItems()
	arg_52_0:close_confirm()
	arg_52_0:close()
	ConditionContentsManager:dispatch("unit.zodiac", {
		unit = var_52_2,
		grade = var_52_2:getBaseGrade(),
		pre_level = var_52_1,
		level = arg_52_1.target.z
	})
	ConditionContentsManager:dispatch("hero.awaken.count", {
		grade = var_52_2:getBaseGrade(),
		level = arg_52_1.target.z
	})
	
	if var_52_2.db.code == "c3026" then
		ConditionContentsManager:dispatch("c3026.zodiac", {
			unit = var_52_2
		})
	end
	
	if var_52_1 < 3 then
		arg_52_0:showRewardSkill(var_52_0, var_52_2)
	else
		arg_52_0:showPromoteRewardPopup(var_52_0, var_52_2)
	end
	
	local var_52_3 = SceneManager:getCurrentSceneName()
	local var_52_4 = Account:getUnit(arg_52_1.target.id)
	
	if var_52_4 and UnitMain:isValid() and (var_52_3 == "unit_ui" or UnitMain:isPopupMode()) then
		local var_52_5 = UnitMain:getMode()
		
		if var_52_5 == "Main" then
			HeroBelt:getInst("UnitMain"):updateUnit(nil, var_52_4)
			UnitDetail:updateUnitInfo(var_52_4)
			UnitMain:setMode("Detail", {
				unit = var_52_4
			})
		elseif var_52_5 == "Sell" then
			UnitSell:removeAllItems(true)
		elseif var_52_5 == "Support" then
			UnitSupport:updateUI()
		end
	end
	
	if var_52_3 == "waitingroom" then
		Storage:reset()
	end
	
	if HeroBelt:isValid() then
		if BattleReady:isShow() then
			HeroBelt:resetDataUseFilter(Account.units, nil, nil, true)
		else
			HeroBelt:resetData(Account.units)
		end
	end
	
	if UnitMain:isValid() and (var_52_3 == "unit_ui" or UnitMain:isPopupMode()) and var_52_4 then
		UnitMain:removePortrait()
		HeroBelt:getInst("UnitMain"):updateUnit(nil, var_52_4)
		HeroBelt:getInst("UnitMain"):scrollToUnit(var_52_4)
		UnitDetail:updateUnitInfo(var_52_4)
		UnitMain:changePortrait(var_52_4)
		UnitMain:setMode("Detail", {
			unit = var_52_4
		})
	end
end

function UnitPromoteAwakePopup.showRewardSkill(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = UnitZodiac:getSkillIDByUnit(arg_53_1, 3)
	local var_53_1 = DB("skill", var_53_0, "base_skill")
	local var_53_2 = load_dlg("dlg_zodiac_reward_skill", true, "wnd")
	local var_53_3 = var_53_2:getChildByName("skill_01")
	local var_53_4 = var_53_2:getChildByName("skill_02")
	
	UIUtil:getSkillDetail(arg_53_1, var_53_1, {
		ignore_check = true,
		wnd = var_53_3,
		skill_id = var_53_1
	})
	UIUtil:getSkillDetail(arg_53_2, var_53_0, {
		ignore_check = true,
		wnd = var_53_4,
		skill_id = var_53_0
	})
	if_set(var_53_2, "txt_title", T("ui_cc_skill_popup_title"))
	if_set(var_53_2, "txt_top", T("ui_cc_skill_popup_desc"))
	Dialog:msgBox({
		fade_in = 500,
		dlg = var_53_2,
		handler = function()
			arg_53_0:showPromoteRewardPopup(arg_53_1, arg_53_2)
		end
	})
end

function UnitPromoteAwakePopup.showPromoteRewardPopup(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_1 or not arg_55_2 then
		return 
	end
	
	local var_55_0 = arg_55_1:getCharacterStatus()
	local var_55_1 = arg_55_2:getCharacterStatus()
	local var_55_2 = {}
	
	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		if iter_55_1 ~= var_55_1[iter_55_0] then
			table.insert(var_55_2, {
				stat = iter_55_0,
				before = iter_55_1,
				after = var_55_1[iter_55_0]
			})
		end
	end
	
	local var_55_3 = table.count(var_55_2)
	local var_55_4 = load_dlg("dlg_zodiac_reward_stat", true, "wnd")
	
	Dialog:msgBox({
		delay = 0,
		fade_in = 500,
		dont_proc_tutorial = true,
		dlg = var_55_4,
		title = T("zodiac_awakening_reward_title")
	})
	if_set(var_55_4, "txt_disc", T("zodiac_awakening_reward_desc"))
	if_set_visible(var_55_4, "n_bonus_stat0", false)
	
	local function var_55_5(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
		local var_56_0 = "n_bonus_stat" .. tostring(arg_56_0)
		
		if_set_visible(var_55_4, var_56_0, true)
		if_set_sprite(var_55_4, "stat_icon" .. tostring(arg_56_0), "img/cm_icon_stat_" .. string.gsub(arg_56_1, "_rate", "") .. ".png")
		if_set(var_55_4, "txt_stat_name" .. tostring(arg_56_0), getStatName(arg_56_1))
		if_set(var_55_4, "txt_stat" .. tostring(arg_56_0) .. "_before", to_var_str(arg_56_2, arg_56_1))
		if_set(var_55_4, "txt_stat" .. tostring(arg_56_0), to_var_str(arg_56_3, arg_56_1))
		
		local var_56_1 = arg_56_3 - arg_56_2
		
		if_set_visible(var_55_4, "diff_icon" .. tostring(arg_56_0), var_56_1 ~= 0)
		if_set(var_55_4, "txt_diff" .. tostring(arg_56_0), to_var_str(var_56_1, arg_56_1))
	end
	
	for iter_55_2, iter_55_3 in pairs({
		1,
		2,
		3,
		4,
		5
	}) do
		local var_55_6 = "n_bonus_stat" .. tostring(iter_55_3)
		
		if_set_visible(var_55_4, var_55_6, false)
	end
	
	local var_55_7 = {
		[2] = {
			1,
			2
		},
		[3] = {
			1,
			2,
			4
		},
		[4] = {
			1,
			2,
			4,
			5
		},
		[5] = {
			1,
			2,
			3,
			4,
			5
		}
	}
	
	for iter_55_4, iter_55_5 in pairs(var_55_7[var_55_3] or {}) do
		var_55_5(iter_55_5, var_55_2[iter_55_4].stat, var_55_2[iter_55_4].before, var_55_2[iter_55_4].after)
	end
end
