DungeonAutomaton = DungeonAutomaton or {}
AutomatonLevelPopup = {}
TOWER_OFFSET_X = 670

function HANDLER.dungeon_automtn(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		DungeonAutomaton:ready()
	elseif arg_1_1 == "btn_device_inven" then
		DeviceInventory:openDeviceInventory()
	elseif arg_1_1 == "btn_tooltip_close" then
		DungeonAutomaton:closeTipTextUI()
	end
end

function HANDLER.dungeon_tower_season_info(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		AutomatonNewSeasonPopup:close()
	end
end

function HANDLER.dungeon_tower_season_popup(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		AutomatonSeasonInfoPopup:close()
	end
end

function MsgHandler.get_automaton_info_all(arg_4_0)
	DungeonAutomaton:res_automaton_hp(arg_4_0)
	DungeonAutomaton:updateSidePanel()
end

function MsgHandler.reset_automaton_level(arg_5_0)
	Account:initAutomatonData(arg_5_0.automaton_info)
	DungeonAutomaton:updateSidePanel()
	DungeonAutomaton:updateLevelResetButton()
	AutomatonLevelPopup:close()
end

function MsgHandler.set_automaton_level(arg_6_0)
	local var_6_0 = tonumber(arg_6_0.last_enter_time or 1)
	
	Account:set_automaton_last_enter_time(var_6_0)
end

function MsgHandler.inc_unit_automaton_hp(arg_7_0)
	if not arg_7_0.uid then
		Log.e("err: wrong unit uid")
		
		return 
	end
	
	local var_7_0 = tonumber(arg_7_0.uid)
	local var_7_1 = Account:getUnit(var_7_0)
	
	if not var_7_1 then
		Log.e("err: empty unit")
		
		return 
	end
	
	var_7_1:resetAutomatonHPRatio()
	Account:setAutomatonHPInfo(var_7_1:getUID(), 1000)
	Account:setUnitReserrectionCount(var_7_1:getUID(), arg_7_0.reserrection_count)
	
	local var_7_2 = arg_7_0.result
	
	Account:updateCurrencies(var_7_2)
	
	if HeroBelt:isValid() then
		HeroBelt:update()
		
		local var_7_3 = HeroBelt:getCurrentControl()
		
		if var_7_3 then
			if_set_visible(var_7_3, "resurrection", false)
			if_set_visible(var_7_3, "add", true)
		end
	end
	
	if BattleReady:isShow() then
		LuaEventDispatcher:dispatchEvent("formation.res", "automaton_hp.update")
	end
end

function DungeonAutomaton.GetCurFloor(arg_8_0)
	local var_8_0 = Account:getAutomatonFloor()
	local var_8_1 = Account:getAutomatonLevel()
	local var_8_2 = AutomatonUtil:getFloorMapID(var_8_0, var_8_1)
	
	if not DB("level_automaton", var_8_2, "id") then
		var_8_0 = var_8_0 - 1
	end
	
	return var_8_0
end

function DungeonAutomaton.getMaxFloor(arg_9_0)
	return 25
end

function DungeonAutomaton.getLeftDayRound(arg_10_0, arg_10_1)
	return arg_10_0:getRewardRound(arg_10_1)
end

function DungeonAutomaton.getRewardRound(arg_11_0, arg_11_1)
	if not PRODUCTION_MODE and DEBUG.AUTOMATON_ROATION_CHEAT then
		local var_11_0 = AutomatonUtil:_dev_get_cheat_rotation()
		
		if var_11_0 then
			return var_11_0
		end
	end
	
	local var_11_1 = arg_11_1 or Account:serverTimeWeekLocalDetail()
	
	return math.floor(var_11_1 / 2) % 5 + 1
end

function DungeonAutomaton.getDeviceRound(arg_12_0, arg_12_1)
	if not PRODUCTION_MODE and DEBUG.AUTOMATON_ROATION_CHEAT then
		local var_12_0 = AutomatonUtil:_dev_get_cheat_rotation()
		
		if var_12_0 then
			return var_12_0
		end
	end
	
	local var_12_1 = (arg_12_1 or Account:serverTimeWeekLocalDetail()) + 6
	
	return math.floor(var_12_1 / 10) % 3 + 1
end

function DungeonAutomaton.getRound(arg_13_0, arg_13_1)
	if not PRODUCTION_MODE and DEBUG.AUTOMATON_ROATION_CHEAT then
		local var_13_0 = AutomatonUtil:_dev_get_cheat_rotation()
		
		if var_13_0 then
			return var_13_0
		end
	end
	
	local var_13_1 = (arg_13_1 or Account:serverTimeWeekLocalDetail()) + 6
	
	return math.floor(var_13_1 / 10) % 3 + 1
end

function DungeonAutomaton.getAutomatonMonsterDeviceRotateId(arg_14_0)
	if not PRODUCTION_MODE and DEBUG.AUTOMATON_ROATION_CHEAT then
		local var_14_0 = AutomatonUtil:_dev_get_cheat_rotation()
		
		if var_14_0 then
			return "device_" .. var_14_0
		end
	end
	
	return "device_" .. arg_14_0:getRound()
end

function DungeonAutomaton.getAutomatonDeviceRotateId(arg_15_0)
	local var_15_0 = Account:getAutomatonLevel() or 1
	local var_15_1 = AutomatonUtil:getAutomatonLevelAlphabet()[var_15_0] or "a"
	local var_15_2 = "autom" .. var_15_1 .. "001"
	
	return DB("level_automaton", var_15_2, {
		"device_" .. arg_15_0:getDeviceRound()
	}) or "device_1"
end

function DungeonAutomaton.getMonth(arg_16_0)
	local var_16_0 = AccountData.server_time.server_time_month.start_time
	
	return (to_n(os.date("%m", var_16_0)))
end

function DungeonAutomaton.getCurrFloorReward(arg_17_0)
	if not Account:isUserSelectAutomatonLevel() then
		return {}
	end
	
	local var_17_0 = {}
	local var_17_1 = arg_17_0:GetCurFloor()
	local var_17_2 = Account:getAutomatonLevel()
	local var_17_3 = AutomatonUtil:getAutomatonLevelAlphabet()
	local var_17_4 = arg_17_0:getRound() or 1
	local var_17_5 = arg_17_0:getRewardRound()
	
	if Account:getAutomatonFloor() - 1 < arg_17_0:getMaxFloor() then
		for iter_17_0 = 1, 2 do
			local var_17_6 = "autom" .. var_17_3[var_17_2] .. string.format("%03d@%d@%d", var_17_1, var_17_4, var_17_5)
			local var_17_7, var_17_8, var_17_9, var_17_10 = DB("level_enter_drops", var_17_6, {
				"item" .. iter_17_0,
				"type" .. iter_17_0,
				"set" .. iter_17_0,
				"grade_rate" .. iter_17_0
			})
			
			if var_17_7 then
				local var_17_11 = iter_17_0
				
				if var_17_11 > 1 and not var_17_0[var_17_11] then
					var_17_11 = 1
				end
				
				var_17_0[var_17_11] = {
					code = var_17_7,
					type = var_17_8,
					set_drop = var_17_9,
					grade_rate = var_17_10
				}
			end
		end
	end
	
	if var_17_1 <= Account:getAutomatonClearedFloor() then
		return {}
	end
	
	return var_17_0
end

function DungeonAutomaton.updateSidePanel(arg_18_0)
	local var_18_0 = not Account:isUserSelectAutomatonLevel()
	
	if_set_visible(arg_18_0.vars.parent_wnd, "n_before", var_18_0)
	if_set_visible(arg_18_0.vars.parent_wnd, "n_change_difficulty", true)
	if_set_visible(arg_18_0.vars.parent_wnd, "n_after", not var_18_0)
	if_set_visible(arg_18_0.vars.parent_wnd, "btn_change_difficulty", not var_18_0)
	if_set_visible(arg_18_0.vars.parent_wnd, "btn_formation", var_18_0)
	
	local var_18_1 = arg_18_0.vars.parent_wnd:getChildByName("n_change_difficulty")
	local var_18_2 = DungeonAutomaton:getCurSeasonData()
	local var_18_3 = AutomatonUtil:getSeasonLeftTimeText()
	
	if_set(var_18_1, "t_floor_boss", var_18_3)
	if_set(var_18_1, "t_season", T("ui_autom_season_info_btn", {
		season_name = T(var_18_2.name)
	}))
	
	if var_18_0 then
		local var_18_4 = arg_18_0.vars.parent_wnd:getChildByName("n_change_difficulty_move")
		
		if get_cocos_refid(var_18_1) and get_cocos_refid(var_18_4) then
			var_18_1.originY = var_18_1:getPositionY()
			
			var_18_1:setPosition(var_18_4:getPosition())
		end
		
		arg_18_0:initLevelSelectUI()
	else
		if get_cocos_refid(var_18_1) and var_18_1.originY then
			var_18_1:setPositionY(var_18_1.originY)
		end
		
		arg_18_0:initCurLevelUI()
		arg_18_0:updateLevelResetButton()
	end
end

function DungeonAutomaton.updateLevelResetButton(arg_19_0)
	local var_19_0 = Account:getAutomatonResetLevelCount() < 3
	local var_19_1 = 3 - Account:getAutomatonResetLevelCount()
	local var_19_2 = arg_19_0.vars.parent_wnd:getChildByName("btn_change_difficulty")
	
	if_set_opacity(arg_19_0.vars.parent_wnd, "btn_change_difficulty", var_19_0 and 255 or 76.5)
	
	if var_19_1 > 0 then
		if_set(var_19_2, "label", T("automtn_level_reset_btn", {
			count = var_19_1
		}))
		if_set_opacity(arg_19_0.vars.parent_wnd, "btn_change_difficulty", 255)
	else
		if_set(var_19_2, "label", T("automtn_level_reset_btn", {
			count = 0
		}))
		if_set_opacity(arg_19_0.vars.parent_wnd, "btn_change_difficulty", 76.5)
	end
	
	if AutomatonUtil:isAllFloorClear() or ContentDisable:byAlias(string.lower("automaton")) then
		if_set_opacity(arg_19_0.vars.parent_wnd, "btn_change_difficulty", 76.5)
	end
	
	local var_19_3 = DungeonList:getWndControl("n_before")
	local var_19_4 = DungeonList:getWndControl("n_after")
	
	if ContentDisable:byAlias(string.lower("automaton")) then
		if_set_opacity(var_19_3, "btn_automaton", 76.5)
		if_set_opacity(var_19_4, "btn_automaton", 76.5)
	else
		TutorialGuide:startGuide("auto_reset")
	end
end

function DungeonAutomaton.initLevelSelectUI(arg_20_0)
	if not get_cocos_refid(arg_20_0.vars.parent_wnd) then
		return 
	end
	
	arg_20_0.vars.level_scrollview = {}
	arg_20_0.vars.max_selectable_level = AutomatonUtil:getMaxSelectableLevel()
	
	local var_20_0 = {
		level_scrollview = arg_20_0.vars.level_scrollview,
		level_scrollview_wnd = arg_20_0.vars.parent_wnd:getChildByName("level_scrollview"),
		select_level_item_callbackFunc = function(arg_21_0)
			DungeonAutomaton:selectAutomatonLevel(arg_21_0)
		end
	}
	
	AutomatonUtil:setSelectLevelUI(arg_20_0.vars.parent_wnd, var_20_0)
	DungeonAutomaton:selectAutomatonLevel(arg_20_0.vars.max_selectable_level)
	
	local var_20_1 = DungeonList:getWndControl("n_before")
	
	if ContentDisable:byAlias(string.lower("automaton")) then
		if_set_opacity(var_20_1, "btn_automaton", 76.5)
	end
end

function DungeonAutomaton.selectAutomatonLevel(arg_22_0, arg_22_1)
	local var_22_0 = true
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.level_scrollview.ScrollViewItems) do
		local var_22_1 = iter_22_1.item
		
		if_set_visible(iter_22_1.control, "selected", arg_22_1 == iter_22_1.item.level)
		
		if arg_22_1 == iter_22_1.item.level then
			var_22_0 = not var_22_1.isEnterable and arg_22_0.vars.max_selectable_level ~= iter_22_1.item.level
		end
	end
	
	if get_cocos_refid(arg_22_0.vars.parent_wnd) then
		local var_22_2 = arg_22_0.vars.parent_wnd:getChildByName("automaton_level_title")
		
		if get_cocos_refid(var_22_2) then
			local var_22_3 = AutomatonUtil:getBGIndex(arg_22_1)
			
			if_set_sprite(var_22_2, "bg", "img/automaton_title_bg_" .. var_22_3 .. ".png")
			if_set(var_22_2, "label_level", T("automtn_level", {
				level = arg_22_1
			}))
		end
	end
	
	arg_22_0.vars.selected_level = arg_22_1
	
	AutomatonUtil:setSelectLevelInfoUI(DungeonList:getWndControl("n_before"), {
		level = arg_22_1,
		isLocked = var_22_0
	})
	if_set_opacity(arg_22_0.vars.parent_wnd, "btn_automaton", var_22_0 and 76.5 or 255)
	
	local var_22_4 = DungeonList:getWndControl("n_before")
	local var_22_5 = getChildByPath(var_22_4, "icon_locked")
	
	if var_22_5 then
		var_22_5:setVisible(var_22_0)
	end
	
	if ContentDisable:byAlias(string.lower("automaton")) then
		if_set_opacity(var_22_4, "btn_automaton", 76.5)
	end
end

function DungeonAutomaton.getParentWnd(arg_23_0)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.parent_wnd) then
		return 
	end
	
	return arg_23_0.vars.parent_wnd
end

function DungeonAutomaton.getAutomatonSelectLevel(arg_24_0)
	if not arg_24_0.vars or not arg_24_0.vars.selected_level then
		return 
	end
	
	return arg_24_0.vars.selected_level
end

function DungeonAutomaton.initCurLevelUI(arg_25_0)
	local var_25_0 = arg_25_0.vars.parent_wnd:getChildByName("n_after")
	local var_25_1 = not Account:isUserSelectAutomatonLevel()
	local var_25_2 = Account:getAutomatonLevel() or 1
	local var_25_3 = Account:getAutomatonFloor()
	
	if var_25_1 then
		return 
	end
	
	local var_25_4 = arg_25_0.vars.parent_wnd:getChildByName("automaton_level")
	local var_25_5 = AutomatonUtil:getBGIndex(var_25_2)
	
	if_set_sprite(var_25_4, "bg", "img/automaton_title_bg_" .. var_25_5 .. ".png")
	if_set(var_25_4, "label_level", T("automtn_level", {
		level = var_25_2
	}))
	if_set(var_25_0, "label_level", T("automtn_level", {
		level = var_25_2
	}))
	if_set_sprite(var_25_0, "bg", "img/automaton_title_bg_" .. var_25_5 .. ".png")
	
	local var_25_6 = arg_25_0:getResetTM()
	
	if_set(var_25_0, "t_count", T("time_remain", {
		time = sec_to_string(var_25_6 - os.time())
	}))
	
	local var_25_7 = arg_25_0:GetCurFloor() <= Account:getAutomatonClearedFloor()
	
	if Account:getAutomatonFloor() <= arg_25_0:getMaxFloor() then
		if_set(var_25_0, "txt_tower_floor", T("atuomtn_floor", {
			floor = var_25_3
		}))
		if_set_visible(var_25_0, "n_conquer", false)
		if_set_visible(var_25_0, "n_reward", true)
		
		if not var_25_7 then
			local var_25_8 = AutomatonUtil:getAutomatonLevelAlphabet()
			local var_25_9 = arg_25_0:getRound()
			local var_25_10 = arg_25_0:getRewardRound()
			
			for iter_25_0 = 1, 2 do
				local var_25_11 = "autom" .. var_25_8[var_25_2] .. string.format("%03d@%d@%d", var_25_3, var_25_9, var_25_10)
				local var_25_12, var_25_13, var_25_14, var_25_15 = DB("level_enter_drops", var_25_11, {
					"item" .. iter_25_0,
					"type" .. iter_25_0,
					"set" .. iter_25_0,
					"grade_rate" .. iter_25_0
				})
				
				if var_25_12 then
					local var_25_16 = iter_25_0
					
					if var_25_16 > 1 and not reward[var_25_16] then
						local var_25_17 = 1
					end
					
					UIUtil:getRewardIcon(var_25_13, var_25_12, {
						show_small_count = true,
						show_name = true,
						right_hero_name = true,
						detail = true,
						parent = var_25_0:getChildByName("n_atmt_reward" .. iter_25_0),
						count = var_25_12,
						set_drop = var_25_14,
						grade_rate = var_25_15
					})
				end
			end
		else
			if_set_visible(var_25_0, "n_conquer", true)
			if_set_visible(var_25_0, "txt_conquer", false)
			if_set_visible(var_25_0, "n_reward", false)
			if_set(var_25_0, "txt_conquer_desc", T("automtn_reset_reward_desc2"))
		end
		
		if_set_visible(var_25_0, "txt_tower_floor", true)
	else
		if_set_visible(var_25_0, "txt_tower_floor", false)
		if_set_visible(var_25_0, "n_conquer", true)
		if_set_visible(var_25_0, "n_reward", false)
	end
	
	arg_25_0.vars.cur_floor = Account:getAutomatonFloor()
	arg_25_0.vars.i_floor = arg_25_0.vars.cur_floor
end

function DungeonAutomaton.ready(arg_26_0, arg_26_1)
	if arg_26_0.vars.i_floor == arg_26_0.vars.cur_floor or arg_26_1 then
		local var_26_0 = Account:getAutomatonLevel()
		local var_26_1 = AutomatonUtil:getAutomatonLevelAlphabet()
		local var_26_2 = AutomatonUtil:getFloorMapID(arg_26_0.vars.cur_floor, var_26_0)
		
		if DungeonAutomaton:checkAutomatonWeekChange() then
			return 
		end
		
		BattleReady:show({
			is_automaton = true,
			skip_intro = arg_26_1,
			callback = arg_26_0,
			enter_id = var_26_2,
			currencies = DungeonList:getCurrentCurrencies()
		})
		
		DungeonList.vars.enter_info = {
			show_ready_dialog = true
		}
	elseif arg_26_0.vars.i_floor ~= arg_26_0.vars.cur_floor then
		if arg_26_0.vars.i_floor == arg_26_0:getMaxFloor() and arg_26_0.vars.cur_floor > arg_26_0:getMaxFloor() and not UnitMain:isValid() then
			UnitMain:beginAutomatonMode(nil, arg_26_0:getParentWnd(), function()
			end)
		else
			arg_26_0:moveToFloor(arg_26_0.vars.cur_floor, true, 1)
		end
	end
end

function DungeonAutomaton.removeScrollEventListener(arg_28_0, arg_28_1)
	if not arg_28_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_28_0.vars.listener) then
		return 
	end
	
	if not get_cocos_refid(arg_28_0.vars.scrollview) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_28_0) then
		var_28_0:removeEventListener(arg_28_0.vars.listener)
	end
	
	arg_28_0.vars.listener:setEnabled(false)
	
	arg_28_0.vars.listener = nil
end

function DungeonAutomaton.create(arg_29_0, arg_29_1)
	arg_29_0.vars = {}
	arg_29_0.vars.layer = cc.Layer:create()
	
	local var_29_0 = cc.Layer:create()
	
	arg_29_0.vars.layer:addChild(var_29_0)
	
	arg_29_0.vars.parent_wnd = arg_29_1
	arg_29_0.vars.cur_floor = Account:getAutomatonFloor()
	arg_29_0.vars.i_floor = arg_29_0.vars.cur_floor
	
	if Account:needToRequestAutomatonData() then
		arg_29_0.vars.cur_floor = 1
		arg_29_0.vars.i_floor = 1
	end
	
	local function var_29_1(arg_30_0, arg_30_1)
		DungeonAutomaton:updateBackground(arg_30_0, arg_30_1)
	end
	
	arg_29_0.vars.bg_effect = EffectManager:Play({
		fn = "ui_bg_automaton.cfx",
		pivot_y = 0,
		pivot_z = 0,
		layer = var_29_0,
		pivot_x = -(VIEW_BASE_LEFT - 160)
	})
	arg_29_0.vars.wnd_scrollview = load_control("wnd/dungeon_automaton_tower.csb")
	
	arg_29_0.vars.layer:addChild(arg_29_0.vars.wnd_scrollview)
	arg_29_0.vars.wnd_scrollview:setAnchorPoint(0.5, 0.5)
	
	local var_29_2 = arg_29_0.vars.wnd_scrollview:getChildByName("n_tower")
	
	if get_cocos_refid(var_29_2) then
		var_29_2:setPosition(0 - VIEW_BASE_LEFT * 2, 0)
		var_29_2:setVisible(false)
	end
	
	arg_29_0.vars.scrollview = arg_29_0.vars.wnd_scrollview:getChildByName("scrollview")
	arg_29_0.vars.scrollview.parent = arg_29_0
	
	arg_29_0.vars.scrollview:addEventListener(var_29_1)
	arg_29_0:update_automaton_data()
	arg_29_0:checkAutomatonSeasonChange()
	
	return arg_29_0.vars.layer
end

function DungeonAutomaton.check_device_info(arg_31_0)
	local var_31_0 = Account:getAutomatonFloor() - 1
	
	if var_31_0 <= 0 or var_31_0 > DungeonAutomaton:getMaxFloor() then
		return 
	end
	
	local var_31_1 = Account:getAutomatonDeviceList()
	local var_31_2 = 0
	
	for iter_31_0, iter_31_1 in pairs(var_31_1) do
		var_31_2 = var_31_2 + tonumber(iter_31_1)
	end
	
	if var_31_0 ~= var_31_2 then
		return true
	end
end

function DungeonAutomaton.update_automaton_data(arg_32_0)
	local var_32_0 = Account:getAutomatonHPInfo()
	local var_32_1 = Account:getAutomatonDeviceList()
	
	if Account:needToRequestAutomatonData() or DungeonAutomaton:check_device_info() then
		arg_32_0:updateSidePanel()
		query("get_automaton_info_all")
		
		local var_32_2 = not Account:isUserSelectAutomatonLevel()
		
		if_set_visible(arg_32_0.vars.parent_wnd, "n_before", var_32_2)
		
		return 
	end
	
	Account:updateAutomatonHPInfo()
	arg_32_0:updateSidePanel()
end

function DungeonAutomaton.res_automaton_hp(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1 or {}
	local var_33_1 = var_33_0.automaton_info or {}
	
	var_33_1.device_list_id = var_33_0.device_list_id or {}
	
	table.print(var_33_0)
	print("automaton_sever_data")
	Account:initAutomatonData(var_33_1)
	
	local var_33_2 = Account:getAutomatonFloor() - 1
	
	if var_33_0.selectable_devices and not table.empty(var_33_0.selectable_devices) then
		local var_33_3 = {
			device_infos = var_33_0.selectable_devices,
			floor = var_33_2,
			floor_level = Account:getAutomatonLevel()
		}
		
		Account:setUnselectDeviceInfo(var_33_3)
	end
end

function DungeonAutomaton.onStartBattle(arg_34_0, arg_34_1)
	DungeonList.vars.enter_info = {
		show_ready_dialog = true
	}
	
	startBattle(arg_34_1.enter_id, {
		is_automaton = true,
		is_already_cleared = arg_34_1.is_already_cleared
	})
end

function DungeonAutomaton.createEnterWindow(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0.vars.wnd = load_control("wnd/dungeon_automtn.csb")
	
	arg_35_0.vars.wnd:setAnchorPoint(0.5, 0.5)
	arg_35_0.vars.wnd:setScale(1)
	arg_35_0.vars.wnd:setPosition(0 - VIEW_BASE_LEFT * 2, 0)
	arg_35_0.vars.wnd:setVisible(false)
	arg_35_0.vars.wnd:setLocalZOrder(1)
	arg_35_0.vars.layer:addChild(arg_35_0.vars.wnd)
	arg_35_0.vars.layer:sortAllChildren()
	
	arg_35_0.vars.floor_info_node = arg_35_0.vars.wnd:getChildByName("floor_info")
	arg_35_0.vars.enter_btn = arg_35_0.vars.wnd:getChildByName("btn_go")
	
	if_set(arg_35_0.vars.wnd, "txt_req_floor", T("hell_needto", {
		floor = Account:getHellFloor()
	}))
	if_set(arg_35_0.vars.wnd, "txt_title", arg_35_2.title)
	if_set(arg_35_0.vars.wnd, "txt_desc", arg_35_2.desc)
	
	local var_35_0 = Account:getAutomatonLevel()
	local var_35_1 = arg_35_0.vars.wnd:getChildByName("automaton_level")
	local var_35_2 = AutomatonUtil:getBGIndex(var_35_0)
	
	if_set(var_35_1, "label_level", T("automtn_level", {
		level = var_35_0
	}))
	if_set_sprite(var_35_1, "bg", "img/automaton_title_bg_" .. var_35_2 .. ".png")
	
	local var_35_3 = tocolor("#2E2E2E")
	
	if var_35_0 <= 2 then
		var_35_3 = tocolor("#1f5200")
	elseif var_35_0 <= 4 then
		var_35_3 = tocolor("#00316d")
	elseif var_35_0 <= 6 then
		var_35_3 = tocolor("#6d2c00")
	else
		var_35_3 = tocolor("#8a0000")
	end
	
	local var_35_4 = arg_35_0.vars.wnd:getChildByName("RIGHT"):getChildByName("g_color")
	
	if_set_color(arg_35_0.vars.wnd, "g_color", var_35_3)
	
	local var_35_5 = arg_35_0:getResetTM()
	
	if_set(arg_35_0.vars.wnd, "t_count", T("time_remain", {
		time = sec_to_string(var_35_5 - os.time())
	}))
	arg_35_0:createTower(arg_35_1)
	arg_35_0:updateDeviceIcon()
	arg_35_0:initTipTextUI()
	
	local var_35_6 = Account:getUnselectDeviceInfo()
	
	if var_35_6 then
		DeviceSelector:showDeviceSelector(nil, var_35_6)
	end
	
	if get_cocos_refid(arg_35_0.vars.listener) then
		arg_35_0:removeScrollEventListener(arg_35_0.vars.scrollview)
	end
	
	local var_35_7 = arg_35_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_35_7) then
		arg_35_0.vars.listener = cc.EventListenerTouchOneByOne:create()
		
		arg_35_0.vars.listener:registerScriptHandler(function(arg_36_0, arg_36_1)
			return arg_35_0:onTouchDown(arg_36_0, arg_36_1)
		end, cc.Handler.EVENT_TOUCH_BEGAN)
		arg_35_0.vars.listener:registerScriptHandler(function(arg_37_0, arg_37_1)
			return arg_35_0:onTouchUp(arg_37_0, arg_37_1)
		end, cc.Handler.EVENT_TOUCH_ENDED)
		arg_35_0.vars.listener:registerScriptHandler(function(arg_38_0, arg_38_1)
			return arg_35_0:onTouchMove(arg_38_0, arg_38_1)
		end, cc.Handler.EVENT_TOUCH_MOVED)
		
		local var_35_8 = cc.Node:create()
		
		var_35_8:setName("priority_node")
		arg_35_0.vars.scrollview:addChild(var_35_8)
		var_35_7:addEventListenerWithSceneGraphPriority(arg_35_0.vars.listener, var_35_8)
	end
end

function DungeonAutomaton.initTipTextUI(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.wnd) then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.wnd:getChildByName("n_tooltip_info")
	
	if_set(var_39_0, "txt_disc", T("automtn_save_hp_info"))
	
	if var_39_0 then
		var_39_0:setVisible(true)
		UIAction:Add(SEQ(DELAY(3000), LOG(FADE_OUT(500)), REMOVE()), var_39_0, "atmt_tip_text")
	end
end

function DungeonAutomaton.closeTipTextUI(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	UIAction:Remove("atmt_tip_text")
	
	local var_40_0 = arg_40_0.vars.wnd:getChildByName("n_tooltip_info")
	
	if var_40_0 then
		var_40_0:setVisible(false)
	end
end

function DungeonAutomaton.getStartTM(arg_41_0)
	local var_41_0 = 604800
	local var_41_1, var_41_2, var_41_3 = Account:serverTimeWeekLocalDetail()
	local var_41_4 = arg_41_0:getLeftDayRound(var_41_1)
	local var_41_5 = var_41_2
	
	for iter_41_0 = 1, 2 do
		local var_41_6 = var_41_1 - iter_41_0
		
		if var_41_4 ~= arg_41_0:getLeftDayRound(var_41_6) then
			var_41_5 = var_41_5 - var_41_0 * (iter_41_0 - 1)
			
			break
		end
	end
	
	return var_41_5
end

function DungeonAutomaton.getResetTM(arg_42_0)
	local var_42_0 = 604800
	local var_42_1, var_42_2, var_42_3 = Account:serverTimeWeekLocalDetail()
	local var_42_4 = arg_42_0:getLeftDayRound(var_42_1)
	local var_42_5 = var_42_3
	
	for iter_42_0 = 1, 2 do
		local var_42_6 = var_42_1 + iter_42_0
		
		if var_42_4 ~= arg_42_0:getLeftDayRound(var_42_6) then
			var_42_5 = var_42_5 + var_42_0 * (iter_42_0 - 1)
			
			break
		end
	end
	
	return var_42_5
end

function DungeonAutomaton.updateDeviceIcon(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	local var_43_0 = arg_43_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_left_bottom")
	local var_43_1 = Account:getAutomatonDeviceList()
	local var_43_2 = AutomatonUtil:getAllDeviceInfo(DungeonAutomaton:getAutomatonDeviceRotateId(), {
		isInventory = true
	})
	
	if table.empty(var_43_1) then
		if_set_visible(var_43_0, "n_none_device", true)
		
		local var_43_3 = var_43_0:getChildByName("n_1")
		local var_43_4 = var_43_0:getChildByName("n_device_preview")
		
		if get_cocos_refid(var_43_3) then
			var_43_4:setPositionY(var_43_3:getPositionY())
		end
		
		if_set(var_43_0, "txt_properties", T("automtn_device_list_info", {
			count = "0",
			all = "24"
		}))
		
		return 
	end
	
	if_set_visible(var_43_0, "n_none_device", false)
	
	local var_43_5 = 1
	
	for iter_43_0, iter_43_1 in pairs(var_43_1) do
		local var_43_6 = "device_" .. string.format("%02d", var_43_5)
		local var_43_7 = var_43_0:getChildByName(tostring(var_43_6))
		
		if not get_cocos_refid(var_43_7) then
			break
		end
		
		local var_43_8, var_43_9 = DB("level_automaton_device", iter_43_0, {
			"max_lv",
			"skill_" .. iter_43_1
		})
		local var_43_10 = UIUtil:getDeviceIcon(var_43_9, {
			id = iter_43_0,
			max_lv = var_43_8,
			level = tonumber(iter_43_1)
		})
		
		if var_43_10 then
			var_43_7:addChild(var_43_10)
			var_43_10:setAnchorPoint(0.5, 0.5)
		end
		
		var_43_5 = var_43_5 + 1
	end
	
	local var_43_11 = 0
	
	for iter_43_2, iter_43_3 in pairs(var_43_2) do
		var_43_11 = var_43_11 + table.count(iter_43_3)
	end
	
	local var_43_12 = table.count(var_43_1)
	local var_43_13 = math.ceil(var_43_12 / 6)
	local var_43_14 = var_43_0:getChildByName("n_" .. var_43_13)
	local var_43_15 = var_43_0:getChildByName("n_device_preview")
	
	if get_cocos_refid(var_43_14) then
		var_43_15:setPositionY(var_43_14:getPositionY())
	end
	
	if_set(var_43_0, "txt_properties", T("automtn_device_list_info", {
		all = "24",
		count = var_43_12
	}))
end

function DungeonAutomaton.CheckNotification(arg_44_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.AUTOMATON) then
		return false
	end
	
	if ContentDisable:byAlias(string.lower("automaton")) then
		return false
	end
	
	local var_44_0
	local var_44_1 = AutomatonUtil:getAutomatonMaxLevel()
	local var_44_2 = Account:getAutomatonLevel() or 0
	
	if var_44_2 <= 0 then
		return true
	end
	
	local var_44_3 = AutomatonUtil:getFloorMapID(1, var_44_2)
	
	if not Account:getDungeonBaseInfo(var_44_3) then
		return true
	end
	
	return false
end

function DungeonAutomaton.getTowerPart(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0
	local var_45_1 = "autotower_stage"
	
	if not arg_45_1 then
		var_45_1 = arg_45_2 and "autotower_boss_stage_end" or "autotower_floor_stage"
	else
		var_45_0 = arg_45_1 % 5 == 0
		
		if var_45_0 then
			var_45_1 = "autotower_boss_stage"
		end
	end
	
	local var_45_2 = ur.Model:create("bg/automaton/" .. var_45_1 .. ".scsp", "bg/automaton/automaton.atlas")
	
	var_45_2:setAnimation(0, "idle", true)
	var_45_2:setLocalZOrder((arg_45_1 or 0) * -1)
	
	return var_45_2, var_45_0
end

function DungeonAutomaton.createBGModel(arg_46_0)
	local var_46_0 = {
		"autotower_light1",
		"autotower_light2",
		"autotower_light3",
		"autotower_front"
	}
	
	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		local var_46_1 = ur.Model:create("bg/automaton/" .. iter_46_1 .. ".scsp", "bg/automaton/automaton.atlas")
		
		var_46_1:setAnimation(0, "idle", true)
		var_46_1:setAnchorPoint(1, 0)
		var_46_1:setPosition(VIEW_WIDTH * 0.4, VIEW_HEIGHT * 0.5)
		arg_46_0.vars.wnd_scrollview:addChild(var_46_1)
	end
end

function DungeonAutomaton.createTower(arg_47_0, arg_47_1)
	arg_47_0.vars.part_offset = 236
	arg_47_0.vars.part_count = 0
	arg_47_0.vars.start_gap = 600
	arg_47_0.vars.end_gap = 300
	arg_47_0.vars.parts = {}
	
	arg_47_0.vars.scrollview:setScrollStep(arg_47_0.vars.part_offset)
	arg_47_0.vars.scrollview:setScrollSpeed(5)
	
	local var_47_0 = arg_47_0.vars.start_gap
	
	arg_47_0.vars.infos = {}
	
	local var_47_1 = Account:getAutomatonLevel()
	
	for iter_47_0 = 1, 999 do
		local var_47_2 = {}
		local var_47_3 = AutomatonUtil:getFloorMapID(iter_47_0, var_47_1)
		
		var_47_2.id, var_47_2.name, var_47_2.reward = DB("level_enter", var_47_3, {
			"id",
			"name",
			"automt_reward"
		})
		
		if not var_47_2.id then
			break
		end
		
		table.push(arg_47_0.vars.infos, var_47_2)
	end
	
	arg_47_0.vars.part_count = #arg_47_0.vars.infos
	
	arg_47_0.vars.scrollview:setLocalZOrder(1)
	
	for iter_47_1 = 1, arg_47_0.vars.part_count do
		local var_47_4, var_47_5 = arg_47_0:getTowerPart(iter_47_1)
		local var_47_6 = var_47_5 and 310 or 300
		
		var_47_4:setPosition(TOWER_OFFSET_X, var_47_0 - var_47_6)
		arg_47_0.vars.scrollview:addChild(var_47_4)
		
		if iter_47_1 > Account:getAutomatonFloor() then
			local var_47_7 = cc.Sprite:create("img/cm_icon_etclock.png")
			
			var_47_7:setScale(2)
			var_47_7:setColor(cc.c3b(160, 160, 160))
			var_47_7:setPositionY(40)
			var_47_4:addChild(var_47_7)
			var_47_4:setColor(cc.c3b(160, 160, 160))
		end
		
		var_47_0 = var_47_0 + arg_47_0.vars.part_offset
		arg_47_0.vars.parts[iter_47_1] = var_47_4
	end
	
	local var_47_8 = arg_47_0:getTowerPart(nil, true)
	
	var_47_8:setPosition(TOWER_OFFSET_X, var_47_0 - 540)
	var_47_8:setLocalZOrder(-101)
	
	if Account:getAutomatonFloor() < arg_47_0.vars.part_count then
		var_47_8:setColor(cc.c3b(160, 160, 160))
	end
	
	arg_47_0.vars.scrollview:addChild(var_47_8)
	
	local var_47_9 = arg_47_0:getTowerPart()
	
	var_47_9:setPosition(TOWER_OFFSET_X, 66)
	arg_47_0.vars.scrollview:addChild(var_47_9)
	
	arg_47_0.vars.view_height = var_47_0
	
	arg_47_0.vars.scrollview:setInnerContainerSize({
		width = "840",
		height = arg_47_0.vars.view_height
	})
	
	arg_47_0.vars.height = var_47_0
	
	if_set_visible(arg_47_0.vars.wnd_scrollview, "n_tower", false)
	
	local var_47_10 = cc.Sprite:create("bg/automaton/automaton_back.png")
	
	var_47_10:setAnchorPoint(1, 0)
	var_47_10:setPositionX(VIEW_WIDTH)
	var_47_10:setLocalZOrder(-99)
	
	arg_47_0.vars.bg_sprite = var_47_10
	
	arg_47_0.vars.wnd_scrollview:addChild(var_47_10)
	arg_47_0:createBGModel()
	arg_47_0:updateBackground()
end

function DungeonAutomaton.onEnter(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	set_high_fps_tick(10000)
	
	arg_48_2 = arg_48_2 or {}
	
	arg_48_0:createEnterWindow(arg_48_2, arg_48_3)
	arg_48_0:showWindow(arg_48_2)
	
	local var_48_0 = DungeonList:getModeInfo()
	
	DungeonList:updateLimitInfo(nil, arg_48_0.vars.layer, var_48_0.enter_limit)
	TopBarNew:checkhelpbuttonID("infoauto")
end

function DungeonAutomaton.showWindow(arg_49_0, arg_49_1)
	arg_49_0.vars.wnd:setVisible(true)
	if_set_visible(arg_49_0.vars.wnd_scrollview, "n_tower", true)
	
	local var_49_0 = arg_49_0.vars.wnd:getChildByName("LEFT")
	local var_49_1 = arg_49_0.vars.wnd:getChildByName("RIGHT")
	
	if not arg_49_1.enter then
		var_49_0:setPositionX(VIEW_BASE_LEFT - 400)
		var_49_1:setPositionX(VIEW_BASE_RIGHT + 600)
		UIAction:Add(LOG(MOVE_TO(400, VIEW_BASE_LEFT + NOTCH_WIDTH / 2)), var_49_0, "block")
		UIAction:Add(LOG(MOVE_TO(400, VIEW_BASE_RIGHT - NOTCH_WIDTH / 2)), var_49_1, "block")
		UIAction:Add(SPAWN(LOG(SCALE(500, 6, 1))), arg_49_0.vars.scrollview, "block")
		UIAction:Add(SPAWN(LOG(OPACITY(500, 0, 1))), arg_49_0.vars.bg_sprite, "block")
	end
	
	arg_49_0:moveToFloor(1)
	arg_49_0:moveToFloor(Account:getAutomatonFloor(), not arg_49_1.enter, 1.5)
end

function DungeonAutomaton.onLeave(arg_50_0)
	arg_50_0:removeScrollEventListener()
	TopBarNew:checkhelpbuttonID("infodung")
	
	local var_50_0 = not Account:isUserSelectAutomatonLevel()
	local var_50_1 = DungeonList:getWndControl("n_before")
	local var_50_2 = DungeonList:getWndControl("n_after")
	
	if get_cocos_refid(var_50_1) and get_cocos_refid(var_50_2) then
		var_50_1:setVisible(not var_50_0)
		var_50_2:setVisible(var_50_0 ~= nil)
	end
end

function DungeonAutomaton.moveToFloor(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	arg_51_3 = arg_51_3 or 2
	arg_51_1 = math.max(0, math.min(arg_51_0.vars.part_count, arg_51_1))
	
	local var_51_0 = 100 - (arg_51_1 - 1) * arg_51_0.vars.part_offset / (arg_51_0.vars.view_height - VIEW_HEIGHT) * 100
	
	if arg_51_2 then
		arg_51_0.vars.scrollview:scrollToPercentVertical(var_51_0, arg_51_3, true)
	else
		arg_51_0.vars.scrollview:jumpToPercentVertical(var_51_0)
	end
end

function DungeonAutomaton.updateBackground(arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_0.vars.view_height then
		return 
	end
	
	local var_52_0 = arg_52_0.vars.scrollview:getInnerContainerPosition().y
	local var_52_1 = arg_52_0.vars.i_floor
	
	arg_52_0.vars.f_floor = (0 - var_52_0) / ((arg_52_0.vars.view_height - arg_52_0.vars.start_gap) / arg_52_0.vars.part_count) + 1
	arg_52_0.vars.f_floor = math.max(1, math.min(arg_52_0.vars.f_floor, arg_52_0.vars.view_height - VIEW_HEIGHT))
	arg_52_0.vars.i_floor = math.floor(arg_52_0.vars.f_floor + 0.5)
	arg_52_0.vars.i_floor = math.max(1, math.min(arg_52_0.vars.i_floor, arg_52_0.vars.part_count))
	
	arg_52_0.vars.floor_info_node:setPositionY((arg_52_0.vars.f_floor - arg_52_0.vars.i_floor) * -103)
	
	if var_52_1 ~= arg_52_0.vars.i_floor then
		local var_52_2 = arg_52_0.vars.i_floor == arg_52_0.vars.cur_floor
		local var_52_3 = var_52_1 and var_52_1 == arg_52_0.vars.cur_floor
		
		arg_52_0.vars.enter_btn.guide_tag = nil
		
		if var_52_2 ~= var_52_3 then
			if var_52_2 then
				if_set(arg_52_0.vars.wnd, "txt_go", T("hell_ready"))
				
				arg_52_0.vars.enter_btn.guide_tag = tostring(arg_52_0.vars.i_floor)
			elseif arg_52_0.vars.i_floor < arg_52_0:getMaxFloor() then
				if_set(arg_52_0.vars.wnd, "txt_go", T("hell_moveto", {
					floor = arg_52_0.vars.cur_floor
				}))
			else
				if_set(arg_52_0.vars.wnd, "txt_go", T("ui_lobby_character_formation"))
			end
		end
		
		if arg_52_0.vars.cur_floor > arg_52_0:getMaxFloor() then
			if arg_52_0.vars.i_floor < arg_52_0:getMaxFloor() then
				if_set(arg_52_0.vars.wnd, "txt_go", T("hell_moveto", {
					floor = arg_52_0:getMaxFloor()
				}))
			else
				if_set(arg_52_0.vars.wnd, "txt_go", T("ui_lobby_character_formation"))
			end
		end
		
		if_set(arg_52_0.vars.wnd, "label_floor", T(arg_52_0.vars.infos[arg_52_0.vars.i_floor].name))
		arg_52_0:updateFloorRewardInfo()
		
		if arg_52_2 then
			vibrate(VIBRATION_TYPE.Select)
		end
		
		for iter_52_0 = -3, 3 do
			local var_52_4 = arg_52_0.vars.i_floor + iter_52_0
			local var_52_5 = arg_52_0.vars.floor_info_node:getChildByName("F" .. iter_52_0)
			
			var_52_5.guide_tag = tostring(var_52_4)
			
			if var_52_4 < 1 or var_52_4 > arg_52_0.vars.part_count then
				var_52_5:setVisible(false)
			else
				var_52_5:setVisible(true)
				if_set(var_52_5, "floor", T("atuomtn_floor", {
					floor = var_52_4
				}))
				
				local var_52_6 = var_52_5:getChildByName("floor")
				local var_52_7 = var_52_5:getChildByName("desc")
				
				if_set_visible(var_52_5, "completed", var_52_4 < arg_52_0.vars.cur_floor)
				if_set_visible(var_52_5, "lock", var_52_4 > arg_52_0.vars.cur_floor)
				
				if var_52_4 == arg_52_0.vars.cur_floor then
					var_52_6:setTextColor(cc.c3b(255, 255, 255))
					var_52_7:setTextColor(cc.c3b(171, 135, 89))
					var_52_7:setOpacity(100)
					var_52_7:setString(T("ui_dungeon_hell_floorinfo_desc2"))
				elseif var_52_4 < arg_52_0.vars.cur_floor then
					var_52_6:setTextColor(cc.c3b(255, 255, 255))
					var_52_7:setTextColor(cc.c3b(107, 193, 27))
					var_52_7:setOpacity(100)
					var_52_7:setString(T("ui_dungeon_hell_floorinfo_desc1"))
				else
					var_52_6:setTextColor(cc.c3b(180, 180, 180))
					var_52_7:setTextColor(cc.c3b(180, 180, 180))
					var_52_7:setOpacity(70)
					var_52_7:setString(T("ui_dungeon_hell_floorinfo_desc3"))
				end
			end
		end
		
		GrowthGuideNavigator:proc()
	end
end

function DungeonAutomaton.updateFloorRewardInfo(arg_53_0)
	local var_53_0 = {
		arg_53_0.vars.wnd:getChildByName("n_item1"),
		arg_53_0.vars.wnd:getChildByName("n_item2")
	}
	local var_53_1 = arg_53_0:getRound()
	local var_53_2 = arg_53_0:getRewardRound()
	local var_53_3 = Account:getAutomatonLevel()
	local var_53_4 = AutomatonUtil:getAutomatonLevelAlphabet()
	local var_53_5 = "autom" .. var_53_4[var_53_3] .. string.format("%03d@%d@%d", arg_53_0.vars.i_floor, var_53_1, var_53_2)
	local var_53_6 = arg_53_0.vars.i_floor <= Account:getAutomatonClearedFloor()
	
	for iter_53_0 = 1, 2 do
		local var_53_7, var_53_8, var_53_9, var_53_10, var_53_11 = DB("level_enter_drops", var_53_5, {
			"id",
			"item" .. iter_53_0,
			"type" .. iter_53_0,
			"set" .. iter_53_0,
			"grade_rate" .. iter_53_0
		})
		
		if var_53_0[iter_53_0] then
			var_53_0[iter_53_0]:removeAllChildren()
			
			if var_53_8 and not var_53_6 then
				local var_53_12 = {
					show_small_count = true,
					show_name = true,
					right_hero_name = true,
					tooltip_y = -200,
					no_resize_name = false,
					tooltip_x = -400,
					detail = true,
					parent = var_53_0[iter_53_0],
					count = var_53_8,
					set_drop = var_53_10,
					grade_rate = var_53_11
				}
				local var_53_13 = UIUtil:getRewardIcon(var_53_9, var_53_8, var_53_12):getChildByName("n_root")
				
				if var_53_13 then
					var_53_13:setScale(0.9)
				end
			end
			
			if_set_visible(arg_53_0.vars.wnd, "OFF", var_53_6)
			
			if var_53_6 then
				local var_53_14 = arg_53_0.vars.wnd:getChildByName("OFF")
				
				if_set(var_53_14, "label", T("automtn_reset_reward_desc2"))
			end
		end
	end
end

function DungeonAutomaton.arrangeBackgroundOffset(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	local var_54_0 = arg_54_3 * arg_54_4
	
	if var_54_0 > 0 then
		var_54_0 = var_54_0 - arg_54_2
	end
	
	while var_54_0 < 0 - arg_54_2 do
		var_54_0 = var_54_0 + arg_54_2
	end
	
	arg_54_1:setPositionY(var_54_0)
end

function DungeonAutomaton.onTouchDown(arg_55_0, arg_55_1, arg_55_2)
	if UIAction:Find("block") then
		return false
	end
	
	arg_55_0.vars.touchdown_dirty = arg_55_1:getLocation()
	
	return true
end

function DungeonAutomaton.onTouchMove(arg_56_0, arg_56_1, arg_56_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_56_0.vars.touchdown_dirty then
		return 
	end
	
	if math.abs(arg_56_0.vars.touchdown_dirty.x - arg_56_1:getLocation().x) > DESIGN_HEIGHT * 0.03 or math.abs(arg_56_0.vars.touchdown_dirty.y - arg_56_1:getLocation().y) > DESIGN_HEIGHT * 0.03 then
		arg_56_0.vars.touchdown_dirty = nil
	end
	
	return true
end

function DungeonAutomaton.onTouchUp(arg_57_0, arg_57_1, arg_57_2)
	if UIAction:Find("block") then
		return false
	end
	
	if DungeonCommon:isOverlapped() or DeviceSelector:isShow() or DeviceInventory:isOpenDeviceInventory() then
		return 
	end
	
	local var_57_0
	
	if arg_57_0.vars.touchdown_dirty and get_cocos_refid(arg_57_0.vars.floor_info_node) then
		var_57_0 = arg_57_1:getLocation()
		
		for iter_57_0 = -3, 3 do
			local var_57_1 = iter_57_0 + arg_57_0.vars.i_floor
			local var_57_2 = arg_57_0.vars.floor_info_node:getChildByName("F" .. iter_57_0)
			
			if var_57_1 < 1 or var_57_1 > arg_57_0.vars.part_count then
			else
				local var_57_3 = var_57_2:getChildByName("panel")
				
				if checkCollision(var_57_3, var_57_0.x, var_57_0.y) then
					arg_57_0:moveToFloor(var_57_1)
					arg_57_2:stopPropagation()
				end
			end
		end
	end
	
	return true
end

function DungeonAutomaton.checkAutomatonWeekChange(arg_58_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.AUTOMATON) or ContentDisable:byAlias(string.lower("automaton")) then
		return false
	end
	
	local var_58_0 = Account:serverTimeWeekLocalDetail()
	local var_58_1 = Account:get_automaton_week_id()
	
	if math.floor(var_58_0 / 2) % 5 + 1 ~= math.floor(var_58_1 / 2) % 5 + 1 then
		local function var_58_2()
			query("reset_automaton_data")
		end
		
		Dialog:msgBox(T("reset_automtn_data_desc"), {
			title = T("reset_automtn_data_title"),
			yes_text = T("reest_data_yes"),
			handler = var_58_2
		})
		
		return true
	end
	
	return false
end

function DungeonAutomaton.getCurSeasonData(arg_60_0)
	return (Account:getCurrentAtmtSeason())
end

function DungeonAutomaton.checkAutomatonSeasonChange(arg_61_0)
	if TutorialGuide:isPlayingTutorial() or not TutorialGuide:isClearedTutorial("system_100") then
		return 
	end
	
	local var_61_0 = (arg_61_0:getCurSeasonData() or {}).id or ""
	local var_61_1 = SAVE:getKeep("atmt_new_season_popup", nil)
	
	if not var_61_1 or var_61_0 ~= var_61_1 then
		AutomatonNewSeasonPopup:show()
		SAVE:setKeep("atmt_new_season_popup", var_61_0)
	end
end

AutomatonNewSeasonPopup = {}

function AutomatonNewSeasonPopup.show(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_1 or SceneManager:getRunningPopupScene()
	
	arg_62_0.vars = {}
	arg_62_0.vars.wnd = load_dlg("dungeon_tower_season_info", true, "wnd", function()
		AutomatonNewSeasonPopup:close()
	end)
	
	var_62_0:addChild(arg_62_0.vars.wnd)
	if_set_visible(arg_62_0.vars.wnd, "btn_close", true)
	arg_62_0:init()
end

function AutomatonNewSeasonPopup.init(arg_64_0)
	local var_64_0 = 1
	local var_64_1 = DungeonAutomaton:getRound()
	local var_64_2 = DungeonAutomaton:getRewardRound()
	local var_64_3 = AutomatonUtil:getAutomatonLevelAlphabet()
	local var_64_4 = "autom" .. var_64_3[var_64_0] .. string.format("%03d@%d@%d", 25, var_64_1, var_64_2)
	local var_64_5 = {}
	
	for iter_64_0 = 1, 40 do
		local var_64_6, var_64_7 = DB("level_enter_drops", var_64_4, {
			"monster" .. iter_64_0,
			"lv" .. iter_64_0
		})
		
		if var_64_6 and var_64_6 ~= "cleardummy" then
			local var_64_8, var_64_9 = DB("character", var_64_6, {
				"monster_tier",
				"name"
			})
			
			var_64_8 = var_64_8 or "normal"
			
			local var_64_10 = var_64_6 .. ":" .. var_64_8
			
			if not var_64_5[var_64_10] then
				var_64_5[var_64_10] = {
					m = var_64_6,
					lv = var_64_7,
					tier = var_64_8,
					name = var_64_9
				}
			elseif var_64_7 > var_64_5[var_64_10].lv then
				var_64_5[var_64_10].lv = var_64_7
			end
		end
	end
	
	local var_64_11 = {}
	
	for iter_64_1, iter_64_2 in pairs(var_64_5) do
		table.push(var_64_11, {
			iter_64_2.m,
			iter_64_2.lv,
			iter_64_2.tier,
			iter_64_2.name
		})
	end
	
	table.sort(var_64_11, function(arg_65_0, arg_65_1)
		if arg_65_0[3] ~= arg_65_1[3] then
			if arg_65_0[3] == "boss" then
				return true
			end
			
			if arg_65_1[3] == "boss" then
				return false
			end
			
			if arg_65_0[3] == "subboss" then
				return true
			end
			
			if arg_65_1[3] == "subboss" then
				return false
			end
			
			if arg_65_0[3] == "elite" then
				return true
			end
			
			if arg_65_1[3] == "elite" then
				return false
			end
			
			return false
		end
		
		return arg_65_0[2] > arg_65_1[2]
	end)
	
	local var_64_12 = arg_64_0.vars.wnd:getChildByName("monster_info")
	
	for iter_64_3 = 1, 3 do
		local var_64_13 = var_64_11[iter_64_3]
		local var_64_14 = string.format("n_monster_%02d", iter_64_3)
		local var_64_15 = var_64_12:getChildByName(var_64_14)
		
		if var_64_13 and get_cocos_refid(var_64_15) then
			if_set(var_64_15, "t_name", T(var_64_13[4]))
			UIUtil:getRewardIcon("c", var_64_13[1], {
				no_db_grade = true,
				monster = true,
				hide_star = true,
				parent = var_64_15:getChildByName("monster_icon"),
				lv = var_64_13[2],
				tier = var_64_13[3]
			})
		end
	end
	
	local var_64_16 = Account:getCurrentAtmtSeason()
	local var_64_17 = AutomatonUtil:getSeasonLeftTimeText()
	
	if not var_64_16 then
		return 
	end
	
	if_set(arg_64_0.vars.wnd, "t_season_period", T("autom_season_label_time2", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_64_16.start_time,
		end_time = var_64_16.end_time
	})))
	if_set(arg_64_0.vars.wnd, "t_season", T(var_64_16.name))
end

function AutomatonNewSeasonPopup.close(arg_66_0)
	if not arg_66_0.vars or not get_cocos_refid(arg_66_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("dungeon_tower_season_info")
	arg_66_0.vars.wnd:removeFromParent()
	
	arg_66_0.vars = {}
end

AutomatonSeasonInfoPopup = {}

copy_functions(ScrollView, AutomatonSeasonInfoPopup)

function AutomatonSeasonInfoPopup.show(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_1 or SceneManager:getRunningPopupScene()
	
	arg_67_0.vars = {}
	arg_67_0.vars.wnd = load_dlg("dungeon_tower_season_popup", true, "wnd", function()
		AutomatonSeasonInfoPopup:close()
	end)
	
	var_67_0:addChild(arg_67_0.vars.wnd)
	if_set_visible(arg_67_0.vars.wnd, "btn_close", true)
	arg_67_0:init()
end

function AutomatonSeasonInfoPopup.init(arg_69_0)
	arg_69_0:initData()
	arg_69_0:initUI()
end

function AutomatonSeasonInfoPopup.initData(arg_70_0)
	local var_70_0 = {
		5,
		10,
		15,
		20,
		25
	}
	local var_70_1 = 1
	local var_70_2 = DungeonAutomaton:getRound()
	local var_70_3 = DungeonAutomaton:getRewardRound()
	local var_70_4 = AutomatonUtil:getAutomatonLevelAlphabet()
	local var_70_5 = {}
	
	for iter_70_0, iter_70_1 in pairs(var_70_0) do
		local var_70_6 = "autom" .. var_70_4[var_70_1] .. string.format("%03d@%d@%d", iter_70_1, var_70_2, var_70_3)
		local var_70_7 = {}
		
		for iter_70_2 = 1, 40 do
			local var_70_8, var_70_9 = DB("level_enter_drops", var_70_6, {
				"monster" .. iter_70_2,
				"lv" .. iter_70_2
			})
			
			if var_70_8 and var_70_8 ~= "cleardummy" then
				local var_70_10, var_70_11 = DB("character", var_70_8, {
					"monster_tier",
					"name"
				})
				
				var_70_10 = var_70_10 or "normal"
				
				local var_70_12 = var_70_8 .. ":" .. var_70_10
				
				if not var_70_7[var_70_12] then
					var_70_7[var_70_12] = {
						m = var_70_8,
						lv = var_70_9,
						tier = var_70_10,
						name = var_70_11
					}
				elseif var_70_9 > var_70_7[var_70_12].lv then
					var_70_7[var_70_12].lv = var_70_9
				end
			end
		end
		
		local var_70_13 = {}
		
		for iter_70_3, iter_70_4 in pairs(var_70_7) do
			table.push(var_70_13, {
				iter_70_4.m,
				iter_70_4.lv,
				iter_70_4.tier,
				iter_70_4.name,
				iter_70_1
			})
		end
		
		table.sort(var_70_13, function(arg_71_0, arg_71_1)
			if arg_71_0[3] ~= arg_71_1[3] then
				if arg_71_0[3] == "boss" then
					return true
				end
				
				if arg_71_1[3] == "boss" then
					return false
				end
				
				if arg_71_0[3] == "subboss" then
					return true
				end
				
				if arg_71_1[3] == "subboss" then
					return false
				end
				
				if arg_71_0[3] == "elite" then
					return true
				end
				
				if arg_71_1[3] == "elite" then
					return false
				end
				
				return false
			end
			
			return arg_71_0[2] > arg_71_1[2]
		end)
		table.insert(var_70_5, var_70_13)
	end
	
	arg_70_0.vars.floor_mob_info = var_70_5
end

function AutomatonSeasonInfoPopup.initUI(arg_72_0)
	local var_72_0 = arg_72_0.vars.wnd:getChildByName("n_floor_monster")
	
	arg_72_0:initScrollView(var_72_0, 406, 114)
	arg_72_0:setScrollViewItems(arg_72_0.vars.floor_mob_info)
	
	local var_72_1 = Account:getCurrentAtmtSeason()
	
	if not var_72_1 then
		return 
	end
	
	if_set(arg_72_0.vars.wnd, "t_season", T("automaton_current_season"))
	if_set(arg_72_0.vars.wnd, "t_floor_boss", T(var_72_1.name))
	
	local var_72_2 = AutomatonUtil:getSeasonLeftTimeText()
	
	if_set(arg_72_0.vars.wnd, "t_time", var_72_2)
	if_set(arg_72_0.vars.wnd, "t_season_period", T("autom_season_label_time", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_72_1.start_time,
		end_time = var_72_1.end_time
	})))
end

function AutomatonSeasonInfoPopup.getScrollViewItem(arg_73_0, arg_73_1)
	local var_73_0 = cc.CSLoader:createNode("wnd/dungeon_tower_season_popup_item.csb")
	local var_73_1 = 0
	
	for iter_73_0 = 1, 3 do
		local var_73_2 = arg_73_1[iter_73_0]
		local var_73_3 = string.format("monster_%02d", iter_73_0)
		local var_73_4 = var_73_0:getChildByName(var_73_3)
		
		if var_73_2 and get_cocos_refid(var_73_4) then
			var_73_1 = var_73_2[5]
			
			UIUtil:getRewardIcon("c", var_73_2[1], {
				no_db_grade = true,
				monster = true,
				hide_star = true,
				parent = var_73_4,
				lv = var_73_2[2],
				tier = var_73_2[3]
			})
		end
	end
	
	if_set(var_73_0, "t_floor", var_73_1)
	
	return var_73_0
end

function AutomatonSeasonInfoPopup.close(arg_74_0)
	if not arg_74_0.vars or not get_cocos_refid(arg_74_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("dungeon_tower_season_popup")
	arg_74_0.vars.wnd:removeFromParent()
	
	arg_74_0.vars = {}
end

function MsgHandler.reset_automaton_data(arg_75_0)
	Account:initAutomatonData(arg_75_0.automaton_info)
	movetoPath("epic7://DungeonList?mode=Automaton&unlock=system_100")
end

function MsgHandler.reset_automaton_data(arg_76_0)
	Account:initAutomatonData(arg_76_0.automaton_info)
	movetoPath("epic7://DungeonList?mode=Automaton&unlock=system_100")
end

function HANDLER.dungeon_automtn_difficulty_popup(arg_77_0, arg_77_1)
	if arg_77_1 == "btn_close" then
		AutomatonLevelPopup:close()
	elseif arg_77_1 == "btn_automaton" then
		AutomatonLevelPopup:confirmLevel()
	end
end

function AutomatonLevelPopup.show(arg_78_0, arg_78_1)
	if arg_78_0.vars and get_cocos_refid(arg_78_0.vars.wnd) then
		return 
	end
	
	if (Account:getAutomatonResetLevelCount() or 0) >= 3 then
		balloon_message_with_sound("automtn_level_reset_over")
		
		return 
	end
	
	local var_78_0 = arg_78_1 or SceneManager:getRunningPopupScene()
	
	arg_78_0.vars = {}
	arg_78_0.vars.wnd = load_dlg("dungeon_automtn_difficulty_popup", true, "wnd", function()
		AutomatonLevelPopup:close()
	end)
	
	var_78_0:addChild(arg_78_0.vars.wnd)
	
	arg_78_0.vars.level_scrollview = {}
	arg_78_0.vars.max_selectable_level = AutomatonUtil:getMaxSelectableLevel()
	
	local var_78_1 = {
		level_scrollview = arg_78_0.vars.level_scrollview,
		level_scrollview_wnd = arg_78_0.vars.wnd:getChildByName("level_scrollview"),
		select_level_item_callbackFunc = function(arg_80_0)
			AutomatonLevelPopup:selectAutomatonLevel(arg_80_0)
		end
	}
	
	AutomatonUtil:setSelectLevelUI(arg_78_0.vars.wnd, var_78_1)
	AutomatonLevelPopup:selectAutomatonLevel(arg_78_0.vars.max_selectable_level)
end

function AutomatonLevelPopup.selectAutomatonLevel(arg_81_0, arg_81_1)
	if not get_cocos_refid(arg_81_0.vars.wnd) then
		return 
	end
	
	local var_81_0 = true
	
	for iter_81_0, iter_81_1 in pairs(arg_81_0.vars.level_scrollview.ScrollViewItems) do
		local var_81_1 = iter_81_1.item
		
		if_set_visible(iter_81_1.control, "selected", arg_81_1 == iter_81_1.item.level)
		
		if arg_81_1 == var_81_1.level then
			var_81_0 = not var_81_1.isEnterable and arg_81_0.vars.max_selectable_level ~= var_81_1.level
		end
	end
	
	local var_81_2 = arg_81_0.vars.wnd:getChildByName("automaton_level_title")
	
	if get_cocos_refid(var_81_2) then
		local var_81_3 = AutomatonUtil:getBGIndex(arg_81_1)
		
		if_set_sprite(var_81_2, "bg", "img/automaton_title_bg_" .. var_81_3 .. ".png")
		if_set(var_81_2, "t_level", T("automtn_level", {
			level = arg_81_1
		}))
	end
	
	arg_81_0.vars.locked_level = var_81_0
	arg_81_0.vars.selected_level = arg_81_1
	
	AutomatonUtil:setSelectLevelInfoUI(arg_81_0.vars.wnd, {
		level = arg_81_1,
		isLocked = var_81_0
	})
	if_set_opacity(arg_81_0.vars.wnd, "btn_automaton", var_81_0 and 76.5 or 255)
	
	local var_81_4 = arg_81_0.vars.wnd:getChildByName("n_popup")
	local var_81_5 = getChildByPath(var_81_4, "frame/icon_locked")
	
	if var_81_5 then
		var_81_5:setVisible(var_81_0)
	end
end

function AutomatonLevelPopup.confirmLevel(arg_82_0)
	if arg_82_0.vars.locked_level then
		local var_82_0 = AutomatonUtil:getLockedLevelText(arg_82_0.vars.selected_level)
		
		balloon_message_with_sound(var_82_0)
		
		return 
	end
	
	if AutomatonUtil:isAllFloorClear() then
		balloon_message_with_sound("automtn_level_reset_clear")
		
		return 
	end
	
	if DungeonAutomaton:checkAutomatonWeekChange() then
		return 
	end
	
	Dialog:msgBox(T("automtn_level_reset_pop_desc"), {
		yesno = true,
		handler = function()
			query("reset_automaton_level", {
				level = arg_82_0.vars.selected_level
			})
			SAVE:set("atmt_week_popup", 1)
		end,
		title = T("automtn_level_reset_pop_title", {
			level = arg_82_0.vars.selected_level
		})
	})
end

function AutomatonLevelPopup.close(arg_84_0)
	if not arg_84_0.vars or not get_cocos_refid(arg_84_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("dungeon_automtn_difficulty_popup")
	arg_84_0.vars.wnd:removeFromParent()
	
	arg_84_0.vars = {}
end
