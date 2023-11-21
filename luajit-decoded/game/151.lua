DeviceInventory = {}
AutomatonUtil = {}
DeviceSelector = {}

copy_functions(ScrollView, DeviceInventory)

function MsgHandler.set_selected_device(arg_1_0)
	table.print(arg_1_0)
	DungeonAutomaton:updateDeviceIcon()
end

function MsgHandler.get_selected_device_list(arg_2_0)
	table.print(arg_2_0)
	Log.e("버프정보")
end

function HANDLER.result_automtn_device_sel(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_confirm" then
		DeviceSelector:confirmDevice()
	elseif arg_3_1 == "btn_device1_sel" then
		DeviceSelector:selectDevice(1)
	elseif arg_3_1 == "btn_device2_sel" then
		DeviceSelector:selectDevice(2)
	elseif arg_3_1 == "btn_device3_sel" then
		DeviceSelector:selectDevice(3)
	elseif arg_3_1 == "btn_my_device" then
		DeviceInventory:openDeviceInventory()
	end
end

function HANDLER.device_inventory(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		DeviceInventory:closeDeviceInventory()
	elseif arg_4_1 == "btn_check" then
		DeviceInventory:toggleShowUserHave()
	end
end

function DeviceInventory.openDeviceInventory(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 or SceneManager:getRunningPopupScene()
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("device_inventory", true, "wnd", function()
		DeviceInventory:closeDeviceInventory()
	end)
	
	var_5_0:addChild(arg_5_0.vars.wnd)
	
	arg_5_0.vars.onlyShowUserHave = SAVE:get("game.atmt_inven_check_1") or false
	arg_5_0.vars.checkBox = arg_5_0.vars.wnd:getChildByName("check_box")
	
	arg_5_0.vars.checkBox:setSelected(arg_5_0.vars.onlyShowUserHave)
	arg_5_0.vars.checkBox:addEventListener(DeviceInventory.toggleShowUserHave)
	arg_5_0:refreshScrollviewItems()
	
	arg_5_0.vars.scrollview = arg_5_0.vars.wnd:getChildByName("ScrollView")
	
	arg_5_0:initScrollView(arg_5_0.vars.scrollview, 845, 101, {
		fit_height = true
	})
	arg_5_0:updateScrollViewItems(arg_5_0.vars.scrollviewDeviceItems)
end

function DeviceInventory.toggleShowUserHave(arg_7_0)
	arg_7_0.vars.onlyShowUserHave = not arg_7_0.vars.onlyShowUserHave
	
	arg_7_0.vars.wnd:getChildByName("check_box"):setSelected(arg_7_0.vars.onlyShowUserHave)
	arg_7_0:refreshScrollviewItems()
	arg_7_0:updateScrollViewItems(arg_7_0.vars.scrollviewDeviceItems)
	if_set_visible(arg_7_0.vars.wnd, "n_none", table.empty(arg_7_0.vars.scrollviewDeviceItems))
end

function DeviceInventory.refreshScrollviewItems(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	arg_8_0.vars.device_rotate_id = DungeonAutomaton:getAutomatonDeviceRotateId()
	arg_8_0.vars.all_device_info = AutomatonUtil:getAllDeviceInfo(arg_8_0.vars.device_rotate_id, {
		isInventory = true
	})
	arg_8_0.vars.user_devices = Account:getAutomatonDeviceList()
	arg_8_0.vars.scrollviewDeviceItems = {}
	
	local var_8_0 = AutomatonUtil:getDeviceTypes()
	local var_8_1 = table.shallow_clone(arg_8_0.vars.all_device_info)
	
	if arg_8_0.vars.onlyShowUserHave then
		for iter_8_0, iter_8_1 in pairs(var_8_1) do
			for iter_8_2 = #iter_8_1, 1, -1 do
				if not arg_8_0.vars.user_devices[var_8_1[iter_8_0][iter_8_2].id] then
					table.remove(var_8_1[iter_8_0], iter_8_2)
				end
			end
		end
	end
	
	local var_8_2 = 0
	
	for iter_8_3, iter_8_4 in pairs(var_8_1) do
		var_8_2 = math.max(var_8_2, table.count(iter_8_4))
	end
	
	local var_8_3 = math.ceil(var_8_2 / 2)
	local var_8_4 = 1
	
	for iter_8_5 = 1, var_8_3 do
		local var_8_5 = 2
		local var_8_6 = {}
		
		for iter_8_6, iter_8_7 in pairs(var_8_0) do
			var_8_6[iter_8_7] = {}
		end
		
		for iter_8_8, iter_8_9 in pairs(var_8_0) do
			local var_8_7 = var_8_1[iter_8_9]
			
			if var_8_7[var_8_4] or var_8_7[var_8_4 + 1] then
				if var_8_7[var_8_4] and arg_8_0.vars.user_devices[var_8_7[var_8_4].id] then
					var_8_7[var_8_4].level = arg_8_0.vars.user_devices[var_8_7[var_8_4].id]
				end
				
				if var_8_7[var_8_4 + 1] and arg_8_0.vars.user_devices[var_8_7[var_8_4 + 1].id] then
					var_8_7[var_8_4 + 1].level = arg_8_0.vars.user_devices[var_8_7[var_8_4 + 1].id]
				end
				
				table.insert(var_8_6[iter_8_9], var_8_7[var_8_4])
				table.insert(var_8_6[iter_8_9], var_8_7[var_8_4 + 1])
			end
		end
		
		table.insert(arg_8_0.vars.scrollviewDeviceItems, var_8_6)
		
		var_8_4 = var_8_4 + 2
	end
	
	if_set_visible(arg_8_0.vars.wnd, "n_none", table.empty(arg_8_0.vars.scrollviewDeviceItems))
end

function DeviceInventory.getScrollViewItem(arg_9_0, arg_9_1)
	local var_9_0 = load_dlg("device_inventory_item", true, "wnd")
	local var_9_1 = AutomatonUtil:getDeviceTypes()
	local var_9_2 = {
		"n_public",
		"n_job",
		"n_pro",
		"n_hero"
	}
	local var_9_3 = 1
	
	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		local var_9_4 = arg_9_1[iter_9_1]
		
		if not var_9_4 then
			break
		end
		
		for iter_9_2, iter_9_3 in pairs(var_9_4) do
			local var_9_5 = var_9_2[var_9_3] .. iter_9_2
			local var_9_6 = var_9_0:getChildByName(var_9_5)
			local var_9_7 = arg_9_0.vars.user_devices[iter_9_3.id]
			local var_9_8 = 0
			
			if var_9_7 then
				var_9_8 = var_9_7
			end
			
			if var_9_5 then
				iter_9_3.level = var_9_8
				iter_9_3.grade = iter_9_3["grade_" .. var_9_8] or iter_9_3.grade_1 or 1
				iter_9_3.isInventory = true
				
				local var_9_9 = iter_9_3["skill_" .. var_9_8] or iter_9_3.skill_1
				local var_9_10 = UIUtil:getDeviceIcon(var_9_9, iter_9_3)
				
				if not var_9_7 then
					if_set_color(var_9_10, nil, tocolor("#505050"))
				end
				
				var_9_6:addChild(var_9_10)
				var_9_10:setAnchorPoint(0.5, 0.5)
			end
		end
		
		var_9_3 = var_9_3 + 1
	end
	
	return var_9_0
end

function DeviceInventory.isOpenDeviceInventory(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	return true
end

function DeviceInventory.closeDeviceInventory(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	SAVE:set("game.atmt_inven_check_1", arg_11_0.vars.onlyShowUserHave)
	SAVE:save()
	BackButtonManager:pop("device_inventory")
	arg_11_0.vars.wnd:removeFromParent()
	
	arg_11_0.vars = {}
end

function DeviceSelector.showDeviceSelector(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2 or {}
	local var_12_1 = arg_12_1 or SceneManager:getRunningPopupScene()
	
	arg_12_0.vars = {}
	arg_12_0.vars.device_infos = var_12_0.device_infos
	arg_12_0.vars.floor = var_12_0.floor
	arg_12_0.vars.show_result_free_tip = var_12_0.show_result_free_tip
	arg_12_0.vars.select_device_idx = 0
	
	if table.empty(arg_12_0.vars.device_infos) then
		return 
	end
	
	arg_12_0.vars.show_reward_tutorial = var_12_0.show_reward_tutorial
	arg_12_0.vars.n_tooltips = {}
	arg_12_0.vars.wnd = load_dlg("result_automtn_device_sel", true, "wnd")
	
	var_12_1:addChild(arg_12_0.vars.wnd)
	if_set_opacity(arg_12_0.vars.wnd, "btn_confirm", 76.5)
	
	for iter_12_0 = 1, 3 do
		local var_12_2 = arg_12_0.vars.wnd:getChildByName("n_device" .. iter_12_0)
		local var_12_3 = arg_12_0.vars.device_infos[iter_12_0]
		
		if_set_visible(arg_12_0.vars.wnd, "n_select" .. iter_12_0, false)
		if_set_visible(arg_12_0.vars.wnd, "btn_device" .. iter_12_0 .. "_sel" .. iter_12_0, false)
		
		if not get_cocos_refid(var_12_2) or not var_12_3 then
			break
		end
		
		var_12_3.result_tooltip = true
		var_12_3.wnd = var_12_2
		
		local var_12_4 = UIUtil:getDevicetoolTip(var_12_3.skill_id, var_12_3)
		
		if get_cocos_refid(var_12_4) then
			local var_12_5 = var_12_4:getChildByName("txt_device_info_scroll_view")
			
			if get_cocos_refid(var_12_5) then
				copy_functions(ScrollView, var_12_5)
				
				var_12_5.scrollview = var_12_5
				
				var_12_5:registerTouchHandler()
			end
		end
		
		if_set_visible(arg_12_0.vars.wnd, "btn_device" .. iter_12_0 .. "_sel" .. iter_12_0, true)
		table.insert(arg_12_0.vars.n_tooltips, var_12_2)
	end
	
	local var_12_6 = arg_12_0.vars.wnd:getChildByName("dim")
	local var_12_7 = arg_12_0.vars.wnd:getChildByName("n_bottom")
	
	var_12_6:setOpacity(0)
	var_12_7:setOpacity(0)
	UIAction:Add(SEQ(DELAY(100), OPACITY(150, 0, 1)), var_12_6, "block")
	UIAction:Add(SEQ(DELAY(100), SLIDE_IN_Y(200, -1200, true)), var_12_6, "block")
	UIAction:Add(SEQ(DELAY(100), OPACITY(150, 0, 1)), var_12_7, "block")
	UIAction:Add(SEQ(DELAY(100), SLIDE_IN_Y(300, 600, true)), var_12_7, "block")
	
	local var_12_8 = arg_12_0.vars.wnd:getChildByName("n_device1")
	local var_12_9 = arg_12_0.vars.wnd:getChildByName("n_device2")
	local var_12_10 = arg_12_0.vars.wnd:getChildByName("n_device3")
	
	var_12_10:setOpacity(0)
	var_12_8:setOpacity(0)
	var_12_9:setOpacity(0)
	UIAction:Add(SEQ(OPACITY(0, 0, 1), MOVE(400, 168, 1200, 168, 190, true), MOVE(100, 168, 190, 168, 232)), var_12_10, "block")
	UIAction:Add(SEQ(DELAY(50), OPACITY(0, 0, 1), MOVE(400, -572, 1200, -572, 190, true), MOVE(100, -572, 190, -572, 232)), var_12_8, "block")
	UIAction:Add(SEQ(DELAY(80), OPACITY(0, 0, 1), MOVE(400, -202, 1200, -202, 190, true), MOVE(100, -202, 190, -202, 232)), var_12_9, "block")
	TutorialGuide:startGuide("auto_device")
end

function DeviceSelector.isShow(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	return true
end

function DeviceSelector.selectDevice(arg_14_0, arg_14_1)
	if arg_14_1 > table.count(arg_14_0.vars.device_infos) then
		return 
	end
	
	UIAction:Remove("select_in")
	UIAction:Remove("select_out")
	
	for iter_14_0 = 1, 3 do
		local var_14_0 = arg_14_0.vars.n_tooltips[iter_14_0]
		
		if not var_14_0 then
			break
		end
		
		if_set_visible(arg_14_0.vars.wnd, "n_select" .. iter_14_0, arg_14_1 == iter_14_0)
		
		local var_14_1 = tocolor("#888888")
		
		if arg_14_1 == iter_14_0 then
			var_14_1 = tocolor("#FFFFFF")
		end
		
		if_set_color(var_14_0, nil, var_14_1)
		
		if arg_14_1 == iter_14_0 then
			local var_14_2 = arg_14_0.vars.wnd:getChildByName("n_select" .. iter_14_0)
			
			if var_14_2 then
				UIAction:Add(LOOP(ROTATE(10000, 0, -360)), var_14_2:getChildByName("img_in"), "select_in")
				UIAction:Add(LOOP(ROTATE(10000, 0, 360)), var_14_2:getChildByName("img_out"), "select_out")
			end
		end
	end
	
	arg_14_0.vars.select_device_idx = arg_14_1
	
	if_set_opacity(arg_14_0.vars.wnd, "btn_confirm", 255)
end

function DeviceSelector.confirmDevice(arg_15_0)
	local var_15_0 = table.count(arg_15_0.vars.device_infos)
	
	if not arg_15_0.vars.select_device_idx or arg_15_0.vars.select_device_idx <= 0 or var_15_0 < arg_15_0.vars.select_device_idx then
		balloon_message_with_sound("automtn_skill_select_error")
		
		return 
	end
	
	local var_15_1 = arg_15_0.vars.device_infos[arg_15_0.vars.select_device_idx]
	
	if not DEBUG.USE_DEVICE_CHEAT then
		Account:addAutomatonDevice(var_15_1.id, var_15_1.level)
	else
		Log.e("using_device_cheat // ignore selection")
	end
	
	local var_15_2 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.device_infos) do
		table.insert(var_15_2, {
			id = iter_15_1.id,
			level = iter_15_1.level
		})
	end
	
	local var_15_3 = json.encode(var_15_2 or {})
	
	query("set_selected_device", {
		floor = arg_15_0.vars.floor,
		idx = arg_15_0.vars.select_device_idx,
		log_datas = var_15_3
	})
	
	if arg_15_0.vars.show_result_free_tip then
		ClearResult:showFreeTipUI()
	end
	
	arg_15_0:closeDeviceSelector()
end

function DeviceSelector.closeDeviceSelector(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	arg_16_0.vars.wnd:removeFromParent()
	
	arg_16_0.vars = {}
	
	Account:clearUnselectDeviceInfo()
	ClearResult:playAutomatonResultFavorite()
end

function AutomatonUtil._is_skill_max_level(arg_17_0, arg_17_1, arg_17_2)
	return arg_17_2 > DB("level_automaton_device", arg_17_1, "max_lv")
end

function AutomatonUtil.getMonsterDeviceGrade(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return 1
	end
	
	for iter_18_0 = 1, 9999 do
		local var_18_0, var_18_1, var_18_2 = DBN("level_automaton_device", iter_18_0, {
			"category",
			"skill_1",
			"grade_1"
		})
		
		if not var_18_0 then
			break
		end
		
		if var_18_0 == "monster" and var_18_1 == arg_18_1 then
			return var_18_2
		end
	end
	
	return 1
end

function AutomatonUtil.setSelectLevelUI(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2 or {}
	
	if not get_cocos_refid(arg_19_1) or not var_19_0.level_scrollview or not var_19_0.level_scrollview_wnd then
		return 
	end
	
	local var_19_1 = arg_19_0:getMaxSelectableLevel()
	local var_19_2 = arg_19_0:getMaxSelectableLevel()
	local var_19_3 = {}
	local var_19_4 = arg_19_0:getAutomatonMaxLevel()
	
	for iter_19_0 = 1, var_19_4 do
		local var_19_5 = {
			level = iter_19_0,
			isEnterable = iter_19_0 <= var_19_1,
			isClear = Account:isMapCleared(arg_19_0:getFloorMapID(25, iter_19_0))
		}
		
		table.insert(var_19_3, var_19_5)
	end
	
	local var_19_6 = var_19_0.level_scrollview
	local var_19_7 = var_19_0.level_scrollview_wnd
	local var_19_8 = var_19_0.select_level_item_callbackFunc
	
	copy_functions(ScrollView, var_19_6)
	
	function var_19_6.getScrollViewItem(arg_20_0, arg_20_1)
		local var_20_0 = load_control("wnd/dungeon_automtn_difficulty_item.csb")
		local var_20_1 = AutomatonUtil:getMaxSelectableLevel()
		
		if_set_visible(var_20_0, "btn_selected", false)
		if_set_visible(var_20_0, "selected", false)
		if_set_visible(var_20_0, "n_locked", not arg_20_1.isEnterable)
		if_set_visible(var_20_0, "n_completed", arg_20_1.isEnterable and arg_20_1.isClear)
		if_set_visible(var_20_0, "t_progressable", arg_20_1.isEnterable and not arg_20_1.isClear)
		
		if var_20_1 == arg_20_1.level and not arg_20_1.isEnterable then
			if_set_visible(var_20_0, "n_locked", false)
			if_set_visible(var_20_0, "t_progressable", true)
		end
		
		if_set(var_20_0, "t_level", T("automaton_level_" .. arg_20_1.level))
		
		return var_20_0
	end
	
	function var_19_6.onSelectScrollViewItem(arg_21_0, arg_21_1, arg_21_2)
		local var_21_0 = AutomatonUtil:getMaxSelectableLevel()
		
		if var_19_8 then
			var_19_8(arg_21_1)
		end
	end
	
	var_19_6:initScrollView(var_19_7, 185, 80, {
		fit_height = true
	})
	var_19_6:updateScrollViewItems(var_19_3)
end

function AutomatonUtil.setSelectLevelInfoUI(arg_22_0, arg_22_1, arg_22_2)
	if not get_cocos_refid(arg_22_1) then
		return 
	end
	
	local var_22_0 = arg_22_2 or {}
	local var_22_1 = var_22_0.level or 1
	local var_22_2 = var_22_0.isLocked
	local var_22_3 = arg_22_1:getChildByName("n_enemy_device"):getChildByName("n_device")
	local var_22_4 = arg_22_1:getChildByName("reward")
	local var_22_5 = DungeonAutomaton:getDeviceRound()
	local var_22_6 = DungeonAutomaton:getRewardRound()
	
	if_set_visible(arg_22_1, "n_device", true)
	
	local var_22_7 = arg_22_1:getChildByName("reward")
	local var_22_8 = "level_info_device_" .. var_22_5
	local var_22_9 = "level_info_reward_" .. var_22_6
	local var_22_10, var_22_11, var_22_12, var_22_13 = DB("level_automaton_config", "automtn_info_" .. var_22_1, {
		var_22_8,
		var_22_9,
		"level_info_power",
		"level_info_unlock_msg"
	})
	
	var_22_10 = var_22_10 or ""
	var_22_11 = var_22_11 or ""
	
	local var_22_14
	
	var_22_14 = var_22_13 or ""
	
	local var_22_15 = string.split(var_22_10, ",")
	local var_22_16 = string.split(var_22_11, ",")
	
	for iter_22_0 = 1, 20 do
		local var_22_17 = arg_22_1:getChildByName("device_" .. iter_22_0)
		local var_22_18 = var_22_7:getChildByName("n_item" .. iter_22_0)
		
		if get_cocos_refid(var_22_17) then
			var_22_17:removeAllChildren()
		end
		
		if get_cocos_refid(var_22_18) then
			var_22_18:removeAllChildren()
		end
	end
	
	for iter_22_1 = 1, 20 do
		local var_22_19 = var_22_15[iter_22_1]
		local var_22_20 = arg_22_1:getChildByName("device_" .. iter_22_1)
		
		if not var_22_19 or var_22_19 == "" or not get_cocos_refid(var_22_20) then
			break
		end
		
		local var_22_21, var_22_22 = DB("level_automaton_device", var_22_19, {
			"skill_1",
			"grade_1"
		})
		
		var_22_22 = var_22_22 or 1
		
		if var_22_21 then
			local var_22_23 = UIUtil:getDeviceIcon(var_22_21, {
				category = "monster",
				grade = var_22_22,
				id = var_22_19
			})
			
			var_22_20:addChild(var_22_23)
			var_22_23:setAnchorPoint(0.5, 0.5)
		end
	end
	
	for iter_22_2 = 1, 99 do
		local var_22_24 = var_22_16[iter_22_2]
		local var_22_25 = var_22_7:getChildByName("n_item" .. iter_22_2)
		
		if not var_22_24 or var_22_24 == "" or not get_cocos_refid(var_22_25) then
			break
		end
		
		UIUtil:getRewardIcon(nil, var_22_24, {
			parent = var_22_25
		})
	end
	
	if_set(arg_22_1, "txt_power", comma_value(var_22_12))
	if_set_visible(arg_22_1, "txt_level_info", var_22_2)
	if_set_visible(arg_22_1, "n_device", not var_22_2)
	
	if var_22_2 then
		local var_22_26 = AutomatonUtil:getLockedLevelText(var_22_1)
		
		if_set(arg_22_1, "txt_level_info", T(var_22_26))
	end
	
	if var_22_10 == "" then
		if_set_visible(arg_22_1, "txt_level_info", true)
		if_set_visible(arg_22_1, "n_device", false)
		if_set(arg_22_1, "txt_level_info", T("level_info_no_device"))
	end
end

function AutomatonUtil.getLockedLevelText(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return 
	end
	
	return (DB("level_automaton_config", "automtn_info_" .. arg_23_1, {
		"level_info_unlock_msg"
	}))
end

function AutomatonUtil.getMaxSelectableLevel(arg_24_0)
	local var_24_0 = arg_24_0:getAutomatonMaxLevel()
	
	for iter_24_0 = 2, var_24_0 do
		local var_24_1 = "auto_unlock_" .. iter_24_0
		local var_24_2 = DB("level_automaton_config", var_24_1, {
			"client_value"
		})
		
		if not var_24_2 then
			Log.e("wrong automaton map unlock value: ", var_24_1)
			
			return 1
		end
		
		local var_24_3 = string.split(var_24_2, ",")
		local var_24_4 = 0
		
		for iter_24_1, iter_24_2 in pairs(var_24_3) do
			if Account:isMapCleared(iter_24_2) then
				var_24_4 = var_24_4 + 1
				
				break
			end
		end
		
		if var_24_4 <= 0 then
			local var_24_5 = math.max(iter_24_0 - 1, 1)
			
			return (math.min(var_24_5, var_24_0))
		end
	end
	
	return var_24_0
end

function AutomatonUtil.getAutomatonLevelAlphabet(arg_25_0)
	return {
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g"
	}
end

function AutomatonUtil.getAutomatonMaxLevel(arg_26_0)
	if AutomatonUtil:canSelect5Level() then
		return DB("level_automaton_config", "auto_level_max", {
			"client_value"
		}) or 5
	else
		return math.min(DB("level_automaton_config", "auto_level_max", {
			"client_value"
		}) or 4, 4)
	end
end

function AutomatonUtil.getBGIndex(arg_27_0, arg_27_1)
	if arg_27_1 <= 2 then
		return 1
	elseif arg_27_1 <= 4 then
		return 2
	elseif arg_27_1 <= 6 then
		return 3
	else
		return 4
	end
end

function AutomatonUtil.getAllDeviceInfo(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_1 then
		return 
	end
	
	local var_28_0 = {}
	local var_28_1 = arg_28_2 or {}
	
	for iter_28_0 = 1, 99 do
		local var_28_2 = arg_28_1 .. "_" .. iter_28_0
		local var_28_3 = DBT("level_automaton_device", var_28_2, {
			"id",
			"category",
			"category_sub",
			"character",
			"type",
			"skill_origin",
			"hero_skill_name",
			"hero_skill_desc",
			"max_lv",
			"skill_1",
			"grade_1",
			"skill_2",
			"grade_2",
			"skill_3",
			"grade_3"
		})
		
		if not var_28_3 or table.empty(var_28_3) then
			break
		end
		
		if not var_28_0[var_28_3.category] then
			var_28_0[var_28_3.category] = {}
		end
		
		if not var_28_3.grade_1 then
			var_28_3.grade_1 = 1
		end
		
		if not var_28_3.grade_2 then
			var_28_3.grade_2 = 1
		end
		
		if not var_28_3.grade_3 then
			var_28_3.grade_3 = 1
		end
		
		var_28_3.level = 0
		
		table.insert(var_28_0[var_28_3.category], var_28_3)
	end
	
	if var_28_1.isInventory then
		var_28_0.monster = {}
	end
	
	return var_28_0
end

function AutomatonUtil.getDeviceTypes(arg_29_0)
	return {
		"common",
		"job",
		"attribute",
		"hero"
	}
end

function AutomatonUtil.getFloorMapID(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0:getAutomatonLevelAlphabet()
	
	if not arg_30_2 or arg_30_2 == 0 then
		arg_30_2 = 1
	end
	
	return string.format("autom" .. var_30_0[arg_30_2] .. "%03d", arg_30_1)
end

function AutomatonUtil.isAllFloorClear(arg_31_0)
	return Account:getAutomatonFloor() > DungeonAutomaton:getMaxFloor()
end

function AutomatonUtil.unitResurrection(arg_32_0, arg_32_1)
	if not arg_32_1 or not arg_32_1.getAutomatonHPRatio then
		Log.e("wrong automaton heal unit")
		
		return 
	end
	
	if arg_32_1:getAutomatonHPRatio() >= 1000 then
		Log.e("err: atomaton_full_hp")
		
		return 
	end
	
	if DungeonAutomaton:checkAutomatonWeekChange() then
		return 
	end
	
	local var_32_0 = Account:getUnitReserrectionCount()
	local var_32_1 = DB("level_automaton_config", "auto_revival_price_" .. var_32_0, {
		"client_value"
	})
	local var_32_2 = DB("level_automaton_config", "auto_revival_token", {
		"client_value"
	})
	local var_32_3 = Account:getCurrency(var_32_2)
	
	if var_32_1 <= var_32_3 then
		local var_32_4 = Dialog:msgBox(T("automtn_hero_rebirth_desc"), {
			ignore_text_alignment = true,
			yesno = true,
			dlg = load_dlg("dungeon_automtn_resurrection", true, "wnd"),
			title = T("automtn_hero_rebirth_title"),
			cost = var_32_1,
			token = var_32_2,
			handler = function()
				query("inc_unit_automaton_hp", {
					uid = arg_32_1:getUID()
				})
			end
		})
		
		UIUtil:getUserIcon(arg_32_1, {
			no_popup = true,
			no_tooltip = true,
			parent = var_32_4:getChildByName("face_icon")
		})
		if_set(var_32_4, "txt_hero_name", arg_32_1:getName())
	elseif var_32_3 < var_32_1 then
		balloon_message_with_sound("need_stigma")
	end
end

function AutomatonUtil.canSelect5Level(arg_34_0)
	if DEBUG.ATMT_5_LV then
		return true
	end
	
	return Account:serverTimeWeekLocalDetail() >= arg_34_0:get_level_5_open_week_id()
end

function AutomatonUtil.get_level_5_open_week_id(arg_35_0)
	return GAME_STATIC_VARIABLE.atmt_5_week_id or 192
end

function AutomatonUtil._dev_get_cheat_rotation(arg_36_0)
	if not DEBUG.AUTOMATON_ROATION_CHEAT then
		return 
	end
	
	local var_36_0 = SAVE:get("automaton.rotation")
	
	if var_36_0 == nil or var_36_0 <= 0 then
		return 
	end
	
	Log.e("AUTOMATON_ROATION_CHEAT_ON", var_36_0)
	
	return var_36_0
end

function AutomatonUtil.getSeasonLeftTimeText(arg_37_0)
	local var_37_0 = Account:getCurrentAtmtSeason()
	
	if not var_37_0 or not var_37_0.end_time then
		return 
	end
	
	local function var_37_1(arg_38_0)
		local var_38_0 = math.floor(arg_38_0 / 86400)
		
		arg_38_0 = arg_38_0 - var_38_0 * 86400
		
		local var_38_1 = math.floor(arg_38_0 / 3600)
		
		arg_38_0 = arg_38_0 - var_38_1 * 3600
		
		local var_38_2 = math.floor(arg_38_0 / 60)
		
		arg_38_0 = arg_38_0 - var_38_2 * 60
		
		if var_38_0 > 0 then
			return T("remain_day", {
				day = var_38_0
			})
		end
		
		if var_38_1 > 0 then
			return T("remain_hour", {
				hour = var_38_1
			})
		end
		
		if var_38_2 > 0 then
			return T("remain_min", {
				min = var_38_2
			})
		end
		
		return T("remain_sec", {
			sec = arg_38_0
		})
	end
	
	return T("ui_autom_next_season", {
		time = var_37_1(var_37_0.end_time - os.time())
	})
end

function AutomatonUtil.getUserDevicePoint(arg_39_0, arg_39_1)
	local var_39_0 = Account:getAutomatonDeviceList()
	
	if not arg_39_1 or not var_39_0 or table.empty(var_39_0) then
		return 0
	end
	
	local var_39_1 = {
		common = 0.06,
		hero = 0.5,
		job = 0.12,
		attribute = 0.1
	}
	local var_39_2 = {
		"light",
		"dark"
	}
	local var_39_3 = 0
	local var_39_4 = arg_39_1:getPoint()
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		local var_39_5 = iter_39_1 or 1
		local var_39_6, var_39_7, var_39_8, var_39_9 = DB("level_automaton_device", iter_39_0, {
			"category",
			"category_sub",
			"character",
			"skill_" .. var_39_5
		})
		
		if not var_39_6 then
			Log.e("error")
		end
		
		local var_39_10 = 0
		local var_39_11 = false
		
		if var_39_6 == "common" then
			var_39_11 = true
		elseif var_39_6 == "job" and var_39_7 and arg_39_1.db.role == var_39_7 then
			var_39_11 = true
		elseif var_39_6 == "hero" and var_39_8 and arg_39_1.db.code == var_39_8 then
			var_39_11 = true
		elseif var_39_6 == "attribute" and var_39_7 and (arg_39_1:getColor() == var_39_7 or var_39_7 == "moonlight" and table.isInclude(var_39_2, arg_39_1:getColor())) then
			var_39_11 = true
		end
		
		if var_39_11 then
			var_39_10 = var_39_4 * var_39_1[var_39_6]
		end
		
		var_39_3 = var_39_3 + var_39_10
	end
	
	return math.floor(var_39_3)
end
