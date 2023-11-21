UnitLevelUp = {}

function HANDLER.unit_level_up(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_upgrade" then
		if UnitLevelUp.vars.unit:isLockUpgrade6() then
			balloon_message_with_sound("character_star_cannot_grade_upgrade")
			
			return 
		end
		
		UnitMain:setMode("NewPromote", {
			unit = UnitLevelUp.vars.unit
		})
	elseif string.starts(arg_1_1, "btn_peng") then
		local var_1_0 = tonumber(string.sub(arg_1_1, 9))
		local var_1_1, var_1_2 = UnitLevelUp:get_all_penguin_count()
		
		if not UnitLevelUp.vars.next_unit:isMaxLevel() and var_1_2[var_1_0].count > (UnitLevelUp.vars.selected_penguin[var_1_0] or 0) then
			UnitLevelUp.vars.selected_penguin[var_1_0] = (UnitLevelUp.vars.selected_penguin[var_1_0] or 0) + 1
			
			UnitLevelUp:request_update_exp()
			
			local var_1_3 = UnitLevelUp.vars.ui.btn[var_1_0]:getChildByName("mob_icon")
			
			UIAction:Add(SEQ(RLOG(SCALE(50, 1, 1.2)), RLOG(SCALE(20, 1.2, 1))), var_1_3, "block")
		end
	elseif string.starts(arg_1_1, "btn_remove") then
		local var_1_4 = tonumber(string.sub(arg_1_1, 11))
		local var_1_5 = UnitLevelUp.vars.selected_penguin[var_1_4] or 0
		
		if var_1_5 > 0 then
			UnitLevelUp.vars.selected_penguin[var_1_4] = var_1_5 - 1
			
			UnitLevelUp:request_update_exp()
		end
	elseif arg_1_1 == "btn_up" then
		UnitLevelUp:send_level_up_request()
	elseif arg_1_1 == "btn_reset" then
		UnitLevelUp.vars.selected_penguin = {}
		
		UnitLevelUp:request_update_exp()
	elseif arg_1_1 == "btn_auto" then
		local var_1_6, var_1_7 = UnitLevelUp:get_all_penguin_count()
		
		if var_1_6 == 0 then
			balloon_message_with_sound("need_penguin")
			
			return 
		end
		
		UnitLevelUp:auto_select_penguin()
	elseif arg_1_1 == "btn_left" then
		local var_1_8 = UnitLevelUp:findLeftGetUnit()
		
		if not var_1_8 then
			return 
		end
		
		UnitLevelUp:change_unit(var_1_8, "left")
	elseif arg_1_1 == "btn_right" then
		local var_1_9 = UnitLevelUp:findRightGetUnit()
		
		if not var_1_9 then
			return 
		end
		
		UnitLevelUp:change_unit(var_1_9, "right")
	end
end

local function var_0_0(arg_2_0, arg_2_1)
	local var_2_0
	
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		if iter_2_1:getUID() == arg_2_0:getUID() then
			var_2_0 = iter_2_0
			
			break
		end
	end
	
	return var_2_0
end

local function var_0_1(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0[arg_3_1]
	
	if not var_3_0 then
		return nil
	end
	
	if BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(var_3_0:getUID()) then
		return false
	end
	
	if not var_3_0:isMaxLevel() and not var_3_0:isDevotionUnit() then
		return var_3_0
	end
	
	return false
end

function UnitLevelUp.findLeftGetUnit(arg_4_0)
	local var_4_0 = UnitDetail.vars.hero_belt:getItems()
	local var_4_1 = var_0_0(arg_4_0.vars.unit, var_4_0)
	
	if not var_4_1 then
		print("NOTHING! CHECK UNIT EXIST!")
		
		return 
	end
	
	local var_4_2
	
	for iter_4_0 = var_4_1 - 1, 1, -1 do
		local var_4_3 = var_0_1(var_4_0, iter_4_0)
		
		if var_4_3 == nil then
			return 
		end
		
		if var_4_3 ~= false then
			var_4_2 = var_4_3
			
			break
		end
	end
	
	return var_4_2
end

function UnitLevelUp.findRightGetUnit(arg_5_0)
	local var_5_0 = UnitDetail.vars.hero_belt:getItems()
	local var_5_1 = var_0_0(arg_5_0.vars.unit, var_5_0)
	
	if not var_5_1 then
		print("NOTHING! CHECK UNIT EXIST!")
		
		return 
	end
	
	local var_5_2
	
	for iter_5_0 = var_5_1 + 1, table.count(var_5_0) do
		local var_5_3 = var_0_1(var_5_0, iter_5_0)
		
		if var_5_3 == nil then
			return 
		end
		
		if var_5_3 ~= false then
			var_5_2 = var_5_3
			
			break
		end
	end
	
	return var_5_2
end

function UnitLevelUp.onCreate(arg_6_0, arg_6_1)
end

function UnitLevelUp.onEnter(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	UnitLevelUp.unit = arg_7_2.unit or UnitLevelUp.unit
	arg_7_0.vars = {}
	arg_7_0.vars.unit = UnitLevelUp.unit
	arg_7_0.vars.selected_penguin = {}
	arg_7_0.vars.prev_mode = arg_7_1
	
	arg_7_0:create_ui()
	
	if not UnitMain:isPortraitUseMode(arg_7_1) then
		UnitMain:enterPortrait()
	end
	
	SoundEngine:play("event:/ui/unit_upgrade/enter")
end

function UnitLevelUp.onLeave(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	UnitDetail:updateUnitInfo(arg_8_0.vars.unit)
	
	if UnitLevelUp.unit then
		UnitLevelUp.unit = nil
	end
	
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_8_0.vars.eff_bg, "block")
	arg_8_0:close_ui()
	
	if ClassChangeMainList and ClassChangeMainList.vars and get_cocos_refid(ClassChangeMainList.vars.listView) then
		ClassChangeMainList:refresh(arg_8_0.vars.unit.db.code)
	end
	
	TopBarNew:setEnableTopRight()
end

function UnitLevelUp.onPushBackButton(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	if arg_9_0.vars.prev_mode then
		UnitMain:setMode(arg_9_0.vars.prev_mode, {
			unit = arg_9_0.vars.unit
		})
	end
end

function UnitLevelUp.auto_select_penguin(arg_10_0)
	if arg_10_0.vars.unit:isMaxLevel() then
		return 
	end
	
	local var_10_0 = arg_10_0:get_auto_penguins()
	
	for iter_10_0, iter_10_1 in pairs(var_10_0 or {}) do
		arg_10_0.vars.selected_penguin[iter_10_1.grade] = iter_10_1.used_count or 0
		
		EffectManager:Play({
			fn = "ui_unit_level_up_penguin.cfx",
			y = 0,
			delay = 0,
			pivot_z = 99998,
			x = 0,
			layer = arg_10_0.vars.ui.slot[iter_10_0]:getChildByName("mob_icon")
		})
	end
	
	arg_10_0:request_update_exp()
end

function UnitLevelUp.get_auto_penguins(arg_11_0, arg_11_1)
	local var_11_0 = (arg_11_1 or arg_11_0.vars.unit):clone()
	local var_11_1, var_11_2 = arg_11_0:get_all_penguin_count()
	local var_11_3 = table.clone(var_11_2)
	
	for iter_11_0 = 1, 3 do
		for iter_11_1 = 1, var_11_3[iter_11_0].count or 0 do
			if var_11_0.inst.lv < var_11_0:getMaxLevel() then
				local var_11_4 = PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.ENHANCE_HERO_EXP, var_11_2[iter_11_0].exp_up)
				
				var_11_0:addExp(var_11_2[iter_11_0].exp_up + var_11_4)
				var_11_0:reset()
				var_11_0:calc(true)
				
				var_11_3[iter_11_0].count = var_11_3[iter_11_0].count - 1
			end
		end
		
		var_11_3[iter_11_0].used_count = var_11_2[iter_11_0].count - var_11_3[iter_11_0].count
	end
	
	return var_11_3
end

function UnitLevelUp.request_update_exp(arg_12_0)
	local var_12_0 = 0
	local var_12_1 = 0
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.selected_penguin or {}) do
		local var_12_2 = PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.ENHANCE_HERO_EXP, arg_12_0.vars.match_table[iter_12_0].exp_up)
		
		var_12_0 = var_12_0 + (arg_12_0.vars.match_table[iter_12_0].exp_up + var_12_2) * iter_12_1
		var_12_1 = var_12_1 + arg_12_0.vars.match_table[iter_12_0].cost * iter_12_1
	end
	
	local var_12_3 = arg_12_0.vars.unit:clone()
	
	var_12_3:addExp(var_12_0)
	var_12_3:reset()
	var_12_3:calc(true)
	
	arg_12_0.vars.next_unit = var_12_3
	arg_12_0.vars.selected_price = var_12_1
	
	UIUtil:setUpgradeInfo(arg_12_0.vars.wnd, {
		mode = "Pro",
		reverse_upgrade_star = true,
		unit = var_12_3,
		price = var_12_1,
		exp = var_12_3:getEXP(),
		origin_unit = arg_12_0.vars.unit
	})
	if_set(arg_12_0.vars.wnd, "txt_exp", "exp " .. arg_12_0.vars.next_unit:getExpString())
	
	local var_12_4, var_12_5 = arg_12_0.vars.next_unit:getExpString()
	local var_12_6, var_12_7 = arg_12_0.vars.unit:getExpString()
	
	arg_12_0.vars.wnd:getChildByName("exp_gauge"):setPercent(var_12_7 * 100)
	arg_12_0.vars.wnd:getChildByName("up_exp_gauge"):setPercent(var_12_5 * 100)
	arg_12_0:update_level_up_ui(var_12_3)
end

function UnitLevelUp.change_unit(arg_13_0, arg_13_1, arg_13_2)
	UnitMain:changePortrait(arg_13_1, nil, arg_13_2)
	
	arg_13_0.vars.unit = arg_13_1
	
	TopBarNew:setTitleName(T(arg_13_1.db.name))
	UIUtil:setUnitAllInfo(arg_13_0.vars.wnd:getChildByName("LEFT"), arg_13_0.vars.unit)
	UIUtil:setLevel(arg_13_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_lv"), arg_13_0.vars.unit:getLv(), MAX_ACCOUNT_LEVEL, 2)
	
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("LEFT"):getChildByName("txt_name")
	local var_13_1 = get_word_wrapped_name(var_13_0, arg_13_1:getName())
	
	if_set(var_13_0, nil, var_13_1)
	
	arg_13_0.vars.selected_penguin = {}
	
	arg_13_0:request_update_exp()
end

function UnitLevelUp.get_all_penguin_count(arg_14_0)
	local var_14_0 = 0
	local var_14_1
	
	if not arg_14_0.vars then
		local var_14_2 = 1
		local var_14_3 = {}
		local var_14_4 = arg_14_0:get_sorted_penguin_table()
		
		for iter_14_0, iter_14_1 in pairs(var_14_4 or {}) do
			var_14_3[var_14_2] = iter_14_1
			var_14_3[var_14_2].id = iter_14_1.id
			var_14_2 = var_14_2 + 1
		end
		
		table.reverse(var_14_3)
		
		var_14_1 = var_14_3
	else
		var_14_1 = table.clone(arg_14_0.vars.match_table)
	end
	
	var_14_1[1].uids = {}
	var_14_1[2].uids = {}
	var_14_1[3].uids = {}
	
	for iter_14_2, iter_14_3 in pairs(Account:getUnits()) do
		if iter_14_3:isExpUnit() then
			var_14_0 = var_14_0 + 1
			
			local var_14_5 = iter_14_3:getBaseGrade()
			
			if var_14_1[var_14_5] then
				var_14_1[var_14_5].count = var_14_1[var_14_5].count or 0
				var_14_1[var_14_5].count = var_14_1[var_14_5].count + 1
				var_14_1[var_14_5].uids[table.count(var_14_1[var_14_5].uids or {}) + 1] = iter_14_3.inst.uid
			end
		end
	end
	
	local var_14_6 = arg_14_0:get_sorted_penguin_table()
	
	for iter_14_4, iter_14_5 in pairs(var_14_6 or {}) do
		local var_14_7 = Account:getItemCount(iter_14_5.id)
		
		var_14_0 = var_14_0 + var_14_7
		var_14_1[iter_14_5.grade].count = var_14_1[iter_14_5.grade].count or 0
		var_14_1[iter_14_5.grade].count = var_14_1[iter_14_5.grade].count + var_14_7
	end
	
	return var_14_0, var_14_1
end

function UnitLevelUp.update_level_up_ui(arg_15_0, arg_15_1)
	local var_15_0, var_15_1 = arg_15_0:get_all_penguin_count()
	
	for iter_15_0 = 1, 3 do
		if iter_15_0 == 1 then
			if_set_visible(arg_15_0.vars.ui.slot[iter_15_0], "txt_name", false)
		end
		
		local var_15_2 = arg_15_0.vars.selected_penguin[iter_15_0] or 0
		local var_15_3 = var_15_1[iter_15_0].count or 0
		
		if_set(arg_15_0.vars.ui.slot[iter_15_0], "txt_value", var_15_2)
		if_set(arg_15_0.vars.ui.btn[iter_15_0], "t_count_selected", var_15_3 - var_15_2 .. "(-" .. var_15_2 .. ")")
		if_set(arg_15_0.vars.ui.btn[iter_15_0], "t_count", var_15_3)
		if_set_visible(arg_15_0.vars.ui.btn[iter_15_0], "t_count", var_15_2 == 0 and var_15_3 > 0)
		if_set_visible(arg_15_0.vars.ui.btn[iter_15_0], "t_count_selected", var_15_2 > 0)
		if_set_visible(arg_15_0.vars.ui.btn[iter_15_0], "t_none", var_15_3 == 0)
		if_set_opacity(arg_15_0.vars.ui.btn[iter_15_0], nil, var_15_3 == 0 and 76.5 or 255)
		if_set_opacity(arg_15_0.vars.ui.slot[iter_15_0], "mob_icon", var_15_2 ~= 0 and 255 or 76.5)
		if_set_opacity(arg_15_0.vars.ui.slot[iter_15_0], "txt_value", var_15_2 ~= 0 and 255 or 76.5)
		
		local var_15_4 = 255
		
		if var_15_3 < 1 or arg_15_0.vars.unit:isMaxLevel() == true then
			var_15_4 = var_15_4 * 0.3
		end
		
		if_set_opacity(arg_15_0.vars.ui.btn[iter_15_0], nil, var_15_4)
	end
	
	local var_15_5 = arg_15_0.vars.unit:isMaxLevel() ~= true and var_15_0 > 0
	
	if_set_opacity(arg_15_0.vars.wnd, "btn_auto", var_15_5 == false and 76.5 or 255)
	
	if arg_15_1 then
		if_set(arg_15_0.vars.wnd, "label_up", "+" .. arg_15_1.inst.lv - arg_15_0.vars.unit.inst.lv)
		if_set_visible(arg_15_0.vars.wnd, "upgrade", arg_15_1.inst.lv > arg_15_0.vars.unit.inst.lv)
		
		local var_15_6 = arg_15_1.inst.exp - arg_15_0.vars.unit.inst.exp
		local var_15_7 = 1
		local var_15_8 = "EXP +" .. comma_value(var_15_6)
		local var_15_9 = var_15_7 + PetSkill:getEffectiveDBValue(SKILL_CONDITION.ENHANCE_HERO_EXP)
		
		if var_15_9 > 1 then
			var_15_8 = var_15_8 .. " (" .. var_15_9 * 100 - 100 .. "%)"
		end
		
		local var_15_10 = arg_15_0.vars.wnd:getChildByName("n_add_exp")
		
		if_set(var_15_10, "txt_add_exp", var_15_8)
		var_15_10:setVisible(true)
		var_15_10:setOpacity(0)
		var_15_10:setPositionY(0)
		UIAction:Remove("add_exp")
		UIAction:Add(SEQ(SPAWN(FADE_IN(200), LOG(MOVE_BY(200, 0, 40))), DELAY(300), FADE_OUT(1000), SHOW(false)), var_15_10, "add_exp")
		if_set_visible(arg_15_0.vars.wnd:getChildByName("exp_gauge"), nil, arg_15_0.vars.unit.inst.lv >= arg_15_1.inst.lv)
	end
	
	if_set_opacity(arg_15_0.vars.wnd, "btn_auto", var_15_5 == false and 76.5 or 255)
	if_set_visible(arg_15_0.vars.wnd, "btn_upgrade", arg_15_0.vars.unit:isMaxLevel() and arg_15_0.vars.unit:getGrade() < 6)
	if_set_visible(arg_15_0.vars.wnd, "btn_up", not arg_15_0.vars.unit:isMaxLevel())
	if_set_visible(arg_15_0.vars.wnd, "btn_reset", not arg_15_0.vars.unit:isMaxLevel())
	if_set(arg_15_0.vars.wnd:getChildByName("n_info"), "label", T(arg_15_0.vars.unit:isMaxLevel() == true and "ui_levelup_max" or "ui_levelup_desc_refund"))
	if_set(arg_15_0.vars.wnd:getChildByName("btn_up"), "txt_enhance", T("ui_level_up"))
	if_set_visible(arg_15_0.vars.wnd, "txt_add_exp", arg_15_1 ~= nil and arg_15_1.inst.exp > arg_15_0.vars.unit.inst.exp and table.count(arg_15_0.vars.selected_penguin) > 0)
	if_set(arg_15_0.vars.wnd, "t_1_title", T("ui_levelup_penguin_number", {
		count = arg_15_0:get_all_penguin_count()
	}))
	
	for iter_15_1 = 1, 3 do
		if_set_visible(arg_15_0.vars.ui.slot[iter_15_1], nil, true)
	end
end

function UnitLevelUp.create_ui(arg_16_0)
	if not arg_16_0.vars.unit then
		return 
	end
	
	arg_16_0.vars.wnd = load_dlg("unit_level_up", true, "wnd")
	
	if_set_opacity(arg_16_0.vars.wnd, nil, 0)
	UnitMain.vars.base_wnd:addChild(arg_16_0.vars.wnd)
	UnitMain:changePortrait(arg_16_0.vars.unit)
	TopBarNew:setTitleName(T(arg_16_0.vars.unit.db.name), "growth_1_1")
	
	arg_16_0.vars.match_table = arg_16_0:get_match_table()
	arg_16_0.vars.ui = {}
	arg_16_0.vars.ui.slot = {}
	arg_16_0.vars.ui.btn = {}
	
	if arg_16_0.vars.eff_bg then
		arg_16_0.vars.eff_bg:removeFromParent()
	end
	
	arg_16_0.vars.eff_bg = EffectManager:Play({
		pivot_x = 0,
		fn = "hero_enchant_circle.cfx",
		pivot_y = 0,
		pivot_z = 0,
		scale = 1,
		layer = UnitMain.vars.base_wnd:getChildByName("eff_pos_level")
	})
	
	if_set_visible(arg_16_0.vars.wnd, "btn_upgrade", arg_16_0.vars.unit:isMaxLevel())
	if_set_visible(arg_16_0.vars.wnd, "btn_up", not arg_16_0.vars.unit:isMaxLevel())
	if_set_visible(arg_16_0.vars.wnd, "btn_reset", not arg_16_0.vars.unit:isMaxLevel())
	UIUtil:setUnitAllInfo(arg_16_0.vars.wnd, arg_16_0.vars.unit)
	arg_16_0:request_update_exp()
	
	local var_16_0, var_16_1 = arg_16_0:get_all_penguin_count()
	
	for iter_16_0 = 1, 3 do
		arg_16_0.vars.ui.slot[iter_16_0] = arg_16_0.vars.wnd:getChildByName("slot" .. iter_16_0)
		arg_16_0.vars.ui.btn[iter_16_0] = arg_16_0.vars.wnd:getChildByName("btn_peng" .. iter_16_0)
		
		local var_16_2 = Account:getItemCount(arg_16_0.vars.match_table[iter_16_0].id)
		local var_16_3 = UIUtil:getRewardIcon(nil, arg_16_0.vars.match_table[iter_16_0].id, {
			show_name = false,
			tooltip_delay = 130,
			scale = 0.9,
			parent = arg_16_0.vars.ui.slot[iter_16_0]:getChildByName("mob_icon"),
			grade = arg_16_0.vars.match_table[iter_16_0].grade
		})
		local var_16_4 = UIUtil:getRewardIcon(nil, arg_16_0.vars.match_table[iter_16_0].id, {
			show_name = false,
			tooltip_delay = 130,
			scale = 0.9,
			parent = arg_16_0.vars.ui.btn[iter_16_0]:getChildByName("mob_icon"),
			grade = arg_16_0.vars.match_table[iter_16_0].grade
		})
		
		if_set(arg_16_0.vars.ui.btn[iter_16_0], "t_exp", "+" .. comma_value(arg_16_0.vars.match_table[iter_16_0].exp_up))
		if_set(arg_16_0.vars.ui.btn[iter_16_0], "t_up", T(arg_16_0.vars.match_table[iter_16_0].id .. "_name"))
		if_set_opacity(arg_16_0.vars.ui.btn[iter_16_0], nil, var_16_2 > 0 and 255 or 76.5)
		if_set_visible(arg_16_0.vars.ui.btn[iter_16_0], "t_none", var_16_2 == 0)
		if_set(arg_16_0.vars.ui.btn[iter_16_0], "t_count", var_16_2 + (var_16_1[iter_16_0].count or 0))
		if_set(arg_16_0.vars.ui.btn[iter_16_0], "t_have", T("ui_alchemy_catalyst_have_txt"))
		if_set(arg_16_0.vars.ui.btn[iter_16_0], "t_none", T("ui_levelup_card_none"))
		if_set_visible(arg_16_0.vars.ui.btn[iter_16_0], "t_count", var_16_2 > 0)
		if_set_visible(arg_16_0.vars.ui.btn[iter_16_0], "t_count_selected", false)
	end
	
	arg_16_0:update_level_up_ui()
	arg_16_0:play_ui_animation(true)
	if_set(arg_16_0.vars.wnd, "txt_exp", "exp " .. arg_16_0.vars.unit:getExpString())
	if_set(arg_16_0.vars.wnd:getChildByName("btn_auto"), "label", T("ui_levelup_autofill"))
	if_set(arg_16_0.vars.wnd:getChildByName("btn_up"), "txt_enhance", T("ui_level_up"))
	if_set(arg_16_0.vars.wnd:getChildByName("btn_upgrade"), "label", T("promote"))
	if_set_visible(arg_16_0.vars.wnd, "btn_left", UnitDetail.vars)
	if_set_visible(arg_16_0.vars.wnd, "btn_right", UnitDetail.vars)
	TopBarNew:setDisableTopRight()
end

function UnitLevelUp.receive_level_up(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	SoundEngine:play("event:/ui/hero_grow_02_levelup")
	vibrate(VIBRATION_TYPE.Success)
	
	local var_17_0
	local var_17_1 = arg_17_1.exp_ratio > 1.5 and "ui_enchant_ultimate.cfx" or "ui_enchant_bonus.cfx"
	local var_17_2 = {
		1,
		2,
		3
	}
	
	table.shuffle(var_17_2)
	
	local var_17_3 = 0
	
	for iter_17_0, iter_17_1 in pairs(var_17_2) do
		if (arg_17_0.vars.selected_penguin[iter_17_1] or 0) > 0 then
			local var_17_4 = arg_17_0.vars.ui.slot[iter_17_1]:getChildByName("penguin_eff") or cc.Node:create()
			
			if not get_cocos_refid(arg_17_0.vars.ui.slot[iter_17_1]:getChildByName("penguin_eff")) then
				var_17_4:setName("penguin_eff")
				arg_17_0.vars.ui.slot[iter_17_1]:addChild(var_17_4)
				var_17_4:setPositionX(arg_17_0.vars.ui.slot[iter_17_1]:getChildByName("mob_icon"):getPositionX())
				var_17_4:setPositionY(arg_17_0.vars.ui.slot[iter_17_1]:getChildByName("mob_icon"):getPositionY())
			end
			
			EffectManager:Play({
				fn = "ui_unit_level_up_penguin.cfx",
				y = 0,
				pivot_z = 99998,
				x = 0,
				layer = var_17_4,
				delay = (iter_17_0 - 1) * 200
			})
			
			var_17_3 = var_17_3 + 200
			
			UIAction:Add(SEQ(DELAY((iter_17_0 - 1) * 200), CALL(function()
				UnitLevelUp.vars.selected_penguin[iter_17_1] = 0
				
				UnitLevelUp:request_update_exp()
			end)), arg_17_0.vars.wnd, "block")
		end
	end
	
	local var_17_5 = to_n(arg_17_1.exp_ratio)
	
	if var_17_5 > 1 then
		EffectManager:Play({
			x = 0,
			y = 420,
			fn = var_17_1,
			layer = arg_17_0.vars.wnd:getChildByName("CENTER")
		})
	end
	
	local var_17_6 = #arg_17_0.vars.selected_penguin
	local var_17_7 = 70
	local var_17_8 = 0
	local var_17_9 = NONE()
	local var_17_10 = NONE()
	
	arg_17_0.vars.base_wnd = arg_17_0.vars.wnd
	
	if not arg_17_0.vars.unit:isPromotionEffectSimple() or var_17_5 > 1.5 then
		var_17_8 = 600
		var_17_9 = CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_17_0.vars.unit, true)
		var_17_10 = SHAKE_UI(500 + var_17_6 * var_17_7 + var_17_8, 10)
	else
		var_17_9 = CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_17_0.vars.unit)
	end
	
	local var_17_11 = EffectManager:Play({
		pivot_x = 0,
		fn = "hero_enchant_circle.cfx",
		pivot_y = 0,
		pivot_z = 0,
		scale = 1,
		layer = UnitMain.vars.base_wnd:getChildByName("eff_pos_level")
	})
	
	UIAction:Add(SEQ(DELAY(1000), FADE_OUT(200), REMOVE()), var_17_11)
	UIAction:Add(SEQ(DELAY(0), SPAWN(SEQ(LOG(BLEND(500, "white", 0, 1), 100), DELAY(var_17_6 * var_17_7 + var_17_8), RLOG(BLEND(200, "white", 1, 0), 100), LOG(BLEND(0))), var_17_10, SEQ(LOG(SCALE(500, 0.8, 0.85)), DELAY(var_17_6 * var_17_7 + var_17_8), var_17_9, RLOG(SCALE(100, 0.8, 0.75)), RLOG(SCALE(100, 0.75, 0.8)), CALL(function()
		local var_19_0 = arg_17_3:getLv()
		
		if UnitUpgradeLogic:UpdateImprintFocus(arg_17_0.vars.unit, arg_17_1.target) then
			Dialog:msgBox(T("m_stamp_s_unlock_pa"), {
				dont_proc_tutorial = true,
				title = T("m_stamp_self_unlock")
			})
		end
		
		UnitUpgradeLogic:UpdateAccountUnitInfo(arg_17_0.vars.unit, arg_17_1.target, var_19_0)
		HeroBelt:getInst("UnitMain"):updateUnit(nil, arg_17_3)
		UnitUpgrade:updateBaseUnitInfo(arg_17_3, arg_17_2)
		arg_17_0:request_update_exp()
		HeroBelt:getInst("UnitMain"):updateUnit(nil, arg_17_0.vars.unit)
		
		if arg_17_0.vars.unit:isMaxLevel() then
			arg_17_0:update_level_up_ui()
		end
		
		arg_17_0.vars.unit = Account:getUnit(arg_17_1.target.id)
		
		UIUtil:setLevel(arg_17_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_lv"), arg_17_0.vars.unit:getLv(), MAX_ACCOUNT_LEVEL, 2)
		if_set(arg_17_0.vars.wnd, "txt_exp", "exp " .. arg_17_0.vars.unit:getExpString())
		arg_17_0:request_update_exp()
		
		if arg_17_5 ~= arg_17_0.vars.unit:getLv() then
			SoundEngine:play("event:/voc/character/" .. arg_17_0.vars.unit.db.model_id .. "/evt/lvup")
		end
		
		arg_17_0:open_extra_penguin_dlg(arg_17_1.extra_penguins)
	end)))), UnitMain:getPortrait(), "block")
end

function MsgHandler.penguin_enhance_unit(arg_20_0)
	Account:addReward(arg_20_0.use_rewards)
	Account:addReward(arg_20_0.rewards)
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.p_units_deleted or {}) do
		Account:removeUnit(iter_20_1)
	end
	
	TopBarNew:topbarUpdate(true)
	
	local var_20_0 = 0
	
	if UnitLevelUp.vars and UnitLevelUp.vars.selected_penguin then
		for iter_20_2, iter_20_3 in pairs(UnitLevelUp.vars.selected_penguin) do
			var_20_0 = var_20_0 + iter_20_3
		end
	end
	
	local var_20_1 = UnitLevelUp.vars.unit:getLv()
	
	UnitUpgradeLogic:UpdateLevelInfo(UnitLevelUp.vars.unit, arg_20_0.target, var_20_0, "penguin")
	UnitLevelUp:receive_level_up(arg_20_0, UnitLevelUp.vars.wnd, UnitLevelUp.vars.unit, var_20_0, var_20_1)
end

function UnitLevelUp.open_extra_penguin_dlg(arg_21_0, arg_21_1)
	if not arg_21_1 or table.count(arg_21_1) == 0 then
		return 
	end
	
	local var_21_0 = {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		table.insert(var_21_0, {
			code = iter_21_0,
			count = iter_21_1
		})
	end
	
	Dialog:msgRewards(T("ui_popup_desc_penguin_refund"), {
		rewards = var_21_0,
		title = T("ui_popup_title_penguin_refund")
	})
end

function UnitLevelUp.get_match_table(arg_22_0)
	local var_22_0 = 1
	local var_22_1 = {}
	local var_22_2 = arg_22_0:get_sorted_penguin_table()
	
	for iter_22_0, iter_22_1 in pairs(var_22_2 or {}) do
		var_22_1[var_22_0] = iter_22_1
		var_22_1[var_22_0].id = iter_22_1.id
		var_22_0 = var_22_0 + 1
	end
	
	table.reverse(var_22_1)
	
	return var_22_1
end

function UnitLevelUp.get_penguin_sell_data(arg_23_0, arg_23_1)
	local var_23_0, var_23_1 = arg_23_0:get_all_penguin_count()
	local var_23_2 = {}
	local var_23_3 = {}
	local var_23_4 = arg_23_0:get_match_table()
	
	for iter_23_0, iter_23_1 in pairs(arg_23_1 or {}) do
		local var_23_5 = iter_23_1
		
		for iter_23_2 = 1, iter_23_1 do
			if var_23_1[iter_23_0].uids ~= nil and #var_23_1[iter_23_0].uids - 1 >= 0 then
				var_23_1[iter_23_0].count = var_23_1[iter_23_0].count - 1
				
				table.insert(var_23_3, var_23_1[iter_23_0].uids[#var_23_1[iter_23_0].uids])
				
				var_23_1[iter_23_0].uids[#var_23_1[iter_23_0].uids] = nil
				var_23_5 = var_23_5 - 1
			else
				table.insert(var_23_2, {
					var_23_4[iter_23_0].id,
					var_23_5
				})
				
				break
			end
		end
	end
	
	return var_23_2, var_23_3
end

function UnitLevelUp.send_level_up_request(arg_24_0)
	if not arg_24_0.vars.selected_price or arg_24_0.vars.selected_price == 0 then
		balloon_message_with_sound("levelup_penguin_select")
		
		return 
	elseif BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(arg_24_0.vars.unit:getUID()) then
		balloon_message_with_sound("msg_bgbattle_cant_levelup")
		
		return 
	end
	
	if Account:getCurrency("gold") >= arg_24_0.vars.selected_price then
		local var_24_0, var_24_1 = arg_24_0:get_penguin_sell_data(arg_24_0.vars.selected_penguin)
		local var_24_2 = arg_24_0.vars.unit.inst.uid
		local var_24_3 = json.encode(var_24_1)
		local var_24_4 = json.encode(var_24_0)
		local var_24_5
		local var_24_6
		
		if IS_PUBLISHER_ZLONG then
			var_24_5 = arg_24_0.vars.unit:getPoint()
			
			if arg_24_0.vars.next_unit then
				var_24_6 = arg_24_0.vars.next_unit:getPoint()
			end
		end
		
		query("penguin_enhance_unit", {
			target = var_24_2,
			p_units = var_24_3,
			p_items = var_24_4,
			begin_point = var_24_5,
			after_point = var_24_6
		})
	else
		UIUtil:checkCurrencyDialog("to_gold", arg_24_0.vars.selected_price)
	end
end

function UnitLevelUp.get_sorted_penguin_table(arg_25_0)
	local var_25_0 = {}
	
	for iter_25_0 = 1, 9999 do
		local var_25_1, var_25_2, var_25_3, var_25_4, var_25_5, var_25_6 = DBN("item_material", iter_25_0, {
			"id",
			"ma_type",
			"get_xp",
			"price",
			"icon",
			"grade"
		})
		
		if not var_25_1 then
			break
		end
		
		if var_25_2 == "xpup" and string.starts(var_25_1, "ma_m") then
			local var_25_7 = {
				price = var_25_4,
				exp_up = to_n(var_25_3),
				icon = var_25_5,
				grade = var_25_6,
				cost = (3 + var_25_6) * (GAME_STATIC_VARIABLE.unit_enhance_price or 150),
				id = var_25_1
			}
			
			table.insert(var_25_0, var_25_7)
		end
	end
	
	table.sort(var_25_0, function(arg_26_0, arg_26_1)
		return arg_26_0.exp_up > arg_26_1.exp_up
	end)
	
	return var_25_0
end

function UnitLevelUp.close_ui(arg_27_0)
	if not UnitMain:isPortraitUseMode(arg_27_0.vars.prev_mode) then
		UnitMain:leavePortrait()
	end
	
	arg_27_0:play_ui_animation(false)
end

function UnitLevelUp.play_ui_animation(arg_28_0, arg_28_1)
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_1 == true and FADE_IN or FADE_OUT
	local var_28_1 = arg_28_1 == false and function()
		arg_28_0.vars.wnd:removeFromParent()
		
		arg_28_0.vars.wnd = nil
		arg_28_0.vars = nil
	end or function()
	end
	
	UIAction:Add(SEQ(var_28_0(150), CALL(var_28_1)), arg_28_0.vars.wnd, "block")
end

function UnitLevelUp.get_unit_penguins_count(arg_31_0)
	local var_31_0, var_31_1 = UnitLevelUp:get_all_penguin_count()
	local var_31_2 = 0
	
	for iter_31_0, iter_31_1 in pairs(var_31_1 or {}) do
		var_31_2 = var_31_2 + table.count(iter_31_1.uids)
	end
	
	return var_31_2
end

function lvup_voice_check()
	if PRODUCTION_MODE then
		return 
	end
	
	for iter_32_0 = 1, 9999 do
		local var_32_0, var_32_1 = DBN("dic_data", iter_32_0, {
			"id",
			"show"
		})
		
		if not string.starts(var_32_0, "c") then
			break
		end
		
		local var_32_2, var_32_3, var_32_4 = DB("character", var_32_0, {
			"type",
			"model_id",
			"grade"
		})
		
		if (var_32_2 == "character" or var_32_2 == "limited") and var_32_4 >= 3 and not SoundEngine:createEvent("event:/voc/character/" .. tostring(var_32_3) .. "/evt/lvup") then
			Log.e("levelup voice not exist", var_32_0, var_32_3)
		end
	end
end
