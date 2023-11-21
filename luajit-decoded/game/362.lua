UnitSell = {}

local var_0_0 = -7
local var_0_1 = 2

function MsgHandler.sell_unit(arg_1_0)
	UnitSell:doSell(arg_1_0)
end

function HANDLER.unit_sell(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_sell" then
		UnitSell:reqSell()
	end
	
	if arg_2_1 == "btn_1" then
		UnitSell:fillBy2GradeUnits()
	end
	
	if string.starts(arg_2_1, "btn_remove") then
		UnitSell:removeItemByIndex(tonumber(string.sub(arg_2_1, -2, -1)))
	end
end

function UnitSell.beginSellMode(arg_3_0)
	arg_3_0:onCreate({})
	arg_3_0:onEnter()
end

function UnitSell.endSellMode(arg_4_0)
	arg_4_0:onLeave()
end

function UnitSell.onCreate(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.items = {}
	arg_5_0.vars.wnd = load_dlg("unit_sell", true, "wnd")
	
	if_set(arg_5_0.vars.wnd, "txt_price", "0")
	if_set(arg_5_0.vars.wnd, "txt_rune", "0")
	
	local var_5_0 = arg_5_0.vars.wnd:getChildByName("btn_1")
	
	if get_cocos_refid(var_5_0) then
		if_set(var_5_0, "label", T("ui_unit_sell_2star_select"))
	end
	
	arg_5_0:updateSellInfo()
	
	local var_5_1 = SceneManager:getCurrentSceneName() == "unit_ui"
	
	if UnitMain:isValid() then
		var_5_1 = true
	end
	
	if var_5_1 then
		UnitMain.vars.base_wnd:addChild(arg_5_0.vars.wnd)
	else
		SceneManager:getDefaultLayer():addChild(arg_5_0.vars.wnd)
	end
	
	if_set_opacity(arg_5_0.vars.wnd, "info1", 0)
	if_set_opacity(arg_5_0.vars.wnd, "bar", 0)
	if_set_opacity(arg_5_0.vars.wnd, "info2", 0)
	if_set_opacity(arg_5_0.vars.wnd, "gold", 0)
	if_set_opacity(arg_5_0.vars.wnd, "btn_sell", 0)
	if_set_opacity(arg_5_0.vars.wnd, "btn_1", 0)
	
	for iter_5_0 = 1, 12 do
		if_set_opacity(arg_5_0.vars.wnd, "slot" .. iter_5_0, 0)
	end
	
	if not var_5_1 then
		arg_5_0.vars.hero_belt = HeroBelt:create("Sell")
		
		arg_5_0.vars.hero_belt:setEventHandler(arg_5_0.onHeroListEvent, arg_5_0)
		arg_5_0.vars.hero_belt.wnd:setLocalZOrder(9999)
		SceneManager:getDefaultLayer():addChild(arg_5_0.vars.hero_belt.wnd)
	else
		if_set_visible(arg_5_0.vars.wnd, "black", false)
		
		arg_5_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
		
		arg_5_0.vars.hero_belt:resetData(Account.units, "Sell")
		
		if arg_5_1.unit then
			arg_5_0.vars.hero_belt:scrollToUnit(arg_5_1.unit, 0)
		end
	end
	
	TopBarNew:checkhelpbuttonID("infounit1_8")
end

function UnitSell.onHeroListEvent(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_1 == "select" then
		arg_6_0:onSelectUnit(arg_6_2, arg_6_3)
	end
end

function UnitSell.onEnter(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	
	arg_7_0.vars.wnd:setLocalZOrder(1)
	
	if arg_7_1 then
		arg_7_0.vars.prev_mode = arg_7_1
		
		TopBarNew:setTitleName(T("hero"))
	end
	
	eff_slide_in(arg_7_0.vars.wnd, "info1", 200, 40)
	eff_slide_in(arg_7_0.vars.wnd, "bar", 200, 80)
	eff_slide_in(arg_7_0.vars.wnd, "info2", 200, 120)
	eff_slide_in(arg_7_0.vars.wnd, "gold", 200, 40)
	eff_slide_in(arg_7_0.vars.wnd, "rune", 200, 40)
	eff_slide_in(arg_7_0.vars.wnd, "btn_sell", 200, 80)
	eff_slide_in(arg_7_0.vars.wnd, "btn_1", 200, 120)
	
	for iter_7_0 = 1, 12 do
		eff_slide_in(arg_7_0.vars.wnd, "slot" .. iter_7_0, 200, iter_7_0 * 20)
	end
	
	TutorialGuide:startGuide(UNLOCK_ID.SELL_UNIT)
	TutorialGuide:procGuide()
	SoundEngine:play("event:/ui/menu/menu_1")
	UnitMain:showUnitList(true)
end

function UnitSell.onLeave(arg_8_0, arg_8_1)
	UIAction:Add(SEQ(DELAY(340), REMOVE()), arg_8_0.vars.wnd, "block")
	eff_slide_out(arg_8_0.vars.wnd, "info1", 200, 120)
	eff_slide_out(arg_8_0.vars.wnd, "bar", 200, 80)
	eff_slide_out(arg_8_0.vars.wnd, "info2", 200, 40)
	eff_slide_out(arg_8_0.vars.wnd, "gold", 200, 120)
	eff_slide_out(arg_8_0.vars.wnd, "rune", 200, 120)
	eff_slide_out(arg_8_0.vars.wnd, "btn_sell", 200, 80)
	eff_slide_out(arg_8_0.vars.wnd, "btn_1", 200, 40)
	
	for iter_8_0 = 12, 1, -1 do
		eff_slide_out(arg_8_0.vars.wnd, "slot" .. iter_8_0, 200, iter_8_0 * 10)
		eff_slide_out(arg_8_0.vars.wnd, "item" .. iter_8_0, 200, iter_8_0 * 10)
	end
	
	if arg_8_1 then
		arg_8_0.vars.hero_belt:revertPoppedItem()
		arg_8_0.vars.hero_belt:resetData(Account.units, arg_8_1)
	end
	
	if false then
	end
end

function UnitSell.onPushBackButton(arg_9_0)
	if arg_9_0.vars.prev_mode ~= nil then
		local var_9_0
		
		if arg_9_0.vars.prev_mode == "Detail" then
			var_9_0 = UnitDetail:getPrevDetailMode() or "Growth"
		end
		
		UnitMain:setMode(arg_9_0.vars.prev_mode, {
			unit = arg_9_0.vars.hero_belt:getCurrentItem(),
			detail_mode = var_9_0
		})
	else
		UnitMain:setMode("Main")
	end
end

function UnitSell.onSelectUnit(arg_10_0, arg_10_1, arg_10_2)
	if #arg_10_0.vars.items >= 12 then
		balloon_message_with_sound("cant_sell")
		
		return 
	end
	
	if arg_10_1:isLocked() then
		balloon_message_with_sound("character_locked")
		
		return 
	end
	
	if arg_10_1:isDevotionUnit() then
	end
	
	local var_10_0 = arg_10_1:getUsableCodeList(nil, "Sell")
	
	if var_10_0 then
		Dialog:msgUnitLock(var_10_0)
		
		return 
	end
	
	vibrate(VIBRATION_TYPE.Select)
	arg_10_0:updateItems(arg_10_1)
	SoundEngine:play("event:/ui/upgrade/slot_in")
end

function UnitSell.isValid(arg_11_0)
	return arg_11_0.vars ~= nil
end

function UnitSell.getItemList(arg_12_0)
	if arg_12_0.vars then
		return arg_12_0.vars.items
	end
end

function UnitSell.removeItemByIndex(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.items[arg_13_1]
	
	if not var_13_0 then
		return 
	end
	
	vibrate(VIBRATION_TYPE.Select)
	arg_13_0:updateItems(var_13_0, true)
	SoundEngine:play("event:/ui/upgrade/slot_out")
end

function UnitSell.updateSellInfo(arg_14_0)
	local var_14_0 = 0
	local var_14_1 = {
		0,
		0,
		1,
		3,
		5,
		8
	}
	local var_14_2 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.items) do
		local var_14_3 = iter_14_1:getClampedDevote()
		local var_14_4 = DB("character", iter_14_1.inst.code, "price")
		
		var_14_0 = var_14_0 + (var_14_4 + math.floor(iter_14_1:getLv() * var_14_4 * 0.2)) * (var_14_3 + 1)
		
		if not iter_14_1:isFreeSaleUnit() then
			local var_14_5 = iter_14_1:getBaseGrade()
			
			if iter_14_1.inst.code == "m8041" then
				if iter_14_1:getGrade() <= 2 then
					var_14_2.ma_elemental_1 = to_n(var_14_2.ma_elemental_1) + 1
				end
			else
				local var_14_6, var_14_7 = DB("rune_sell", tostring(var_14_5), {
					"token",
					"reward"
				})
				
				if var_14_6 and var_14_7 > 0 then
					local var_14_8 = var_14_7 * (var_14_3 + 1)
					
					var_14_2[var_14_6] = to_n(var_14_2[var_14_6]) + var_14_8
				end
			end
			
			local var_14_9, var_14_10 = DB("char_promotion_sell", tostring(iter_14_1:getGrade()), {
				"item_id",
				"reward"
			})
			
			if var_14_9 and to_n(var_14_10) > 0 then
				var_14_2[var_14_9] = to_n(var_14_2[var_14_9]) + to_n(var_14_10)
			end
		end
	end
	
	if not arg_14_0.vars.reward_gold then
		arg_14_0.vars.reward_gold = UIUtil:getRewardIcon(0, "to_gold", {
			show_count = true,
			no_frame = false,
			parent = arg_14_0.vars.wnd:getChildByName("n_pos_reward_gold"),
			count = var_14_0
		})
		arg_14_0.vars.prev_tokens = {}
	end
	
	if var_14_0 ~= arg_14_0.vars.price then
		arg_14_0.vars.price = arg_14_0.vars.price or 0
		
		local var_14_11 = arg_14_0.vars.reward_gold:getChildByName("txt_small_count")
		
		UIAction:Remove(var_14_11)
		UIAction:Add(INC_NUMBER(250, var_14_0, nil, arg_14_0.vars.price), var_14_11)
		
		arg_14_0.vars.price = var_14_0
	end
	
	for iter_14_2 = 1, 5 do
		local var_14_12 = arg_14_0.vars.wnd:getChildByName("n_pos_reward_" .. iter_14_2)
		
		if not get_cocos_refid(var_14_12) then
			break
		end
		
		var_14_12:removeAllChildren()
	end
	
	local var_14_13 = {}
	
	for iter_14_3, iter_14_4 in pairs(var_14_2) do
		table.insert(var_14_13, {
			iter_14_3,
			iter_14_4
		})
	end
	
	local var_14_14 = {
		ma_elemental_1 = 3,
		ma_elemental_3 = 5,
		ma_elemental_2 = 4,
		to_stigma = 1,
		to_hero1 = 2
	}
	
	table.sort(var_14_13, function(arg_15_0, arg_15_1)
		local var_15_0 = arg_15_0[1]
		local var_15_1 = arg_15_1[1]
		
		return (var_14_14[var_15_0] or 99) < (var_14_14[var_15_1] or 99)
	end)
	
	for iter_14_5, iter_14_6 in pairs(var_14_13) do
		local var_14_15 = iter_14_6[1]
		local var_14_16 = iter_14_6[2]
		local var_14_17 = arg_14_0.vars.wnd:getChildByName("n_pos_reward_" .. iter_14_5)
		
		if not get_cocos_refid(var_14_17) then
			break
		end
		
		icon = UIUtil:getRewardIcon(0, var_14_15, {
			show_count = true,
			count = 0
		})
		
		var_14_17:addChild(icon)
		
		local var_14_18 = icon:getChildByName("txt_small_count")
		
		UIAction:Remove(var_14_18)
		
		local var_14_19 = arg_14_0.vars.prev_tokens[var_14_15]
		
		if_set(icon, "txt_small_count", var_14_19 or var_14_16)
		
		if var_14_19 ~= var_14_16 then
			UIAction:Add(INC_NUMBER(250, var_14_16, nil, var_14_19), var_14_18)
		else
			if_set(icon, "txt_small_count", var_14_16)
		end
	end
	
	arg_14_0.vars.prev_tokens = var_14_2
end

function UnitSell.removeAllItems(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	if arg_16_1 then
		for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.items) do
			arg_16_0.vars.hero_belt:revertPoppedItem(iter_16_1)
		end
	end
	
	arg_16_0.vars.items = {}
	
	for iter_16_2 = 1, 12 do
		local var_16_0 = arg_16_0.vars.wnd:getChildByName("item" .. iter_16_2)
		
		if var_16_0 then
			var_16_0:setName("")
			
			if anim then
				UIAction:Add(SEQ(DELAY(iter_16_2 * 40), SLIDE_OUT(150, -100), REMOVE()), var_16_0)
			else
				var_16_0:removeFromParent()
			end
		end
	end
	
	arg_16_0:updateSellInfo()
	
	arg_16_0.vars.price = 0
	arg_16_0.vars.rune = 0
end

function UnitSell.updateItems(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if not arg_17_2 then
		if not arg_17_3 then
			arg_17_0.vars.hero_belt:popItem(arg_17_1)
		end
		
		table.push(arg_17_0.vars.items, arg_17_1)
		
		local var_17_0 = arg_17_0.vars.wnd:getChildByName("slot" .. #arg_17_0.vars.items)
		local var_17_1 = UIUtil:updateUnitBar("Sell", arg_17_1, {
			lv = arg_17_1:getLv(),
			max_lv = arg_17_1:getMaxLevel()
		})
		
		var_17_1:setAnchorPoint(0.5, 0.5)
		var_17_1:setName("item" .. #arg_17_0.vars.items)
		var_17_1:setScale(var_17_0:getScale())
		
		local var_17_2, var_17_3 = var_17_0:getPosition()
		
		arg_17_0.vars.wnd:getChildByName("slot"):addChild(var_17_1)
		var_17_1:setPosition(var_17_2 + var_0_0, var_17_3 + var_0_1)
		var_17_1:setOpacity(0)
		Action:Add(SLIDE_IN(150, -800), var_17_1)
		arg_17_0:updateSellInfo()
		
		if arg_17_1:isForceLockCharacter() then
			arg_17_0.vars.hero_belt:update()
		end
		
		return 
	end
	
	local var_17_4
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.items) do
		if iter_17_1 == arg_17_1 then
			var_17_4 = iter_17_0
			
			arg_17_0.vars.hero_belt:revertPoppedItem(arg_17_1)
			table.remove(arg_17_0.vars.items, iter_17_0)
			
			break
		end
	end
	
	if var_17_4 then
		for iter_17_2 = var_17_4, 12 do
			local var_17_5 = arg_17_0.vars.wnd:getChildByName("item" .. iter_17_2)
			
			if not var_17_5 then
				break
			end
			
			if iter_17_2 == var_17_4 then
				var_17_5:setName("")
				UIAction:Add(SEQ(SLIDE_OUT(150, -100), REMOVE()), var_17_5, "block")
			else
				var_17_5:setName("item" .. iter_17_2 - 1)
				
				local var_17_6 = arg_17_0.vars.wnd:getChildByName("slot" .. iter_17_2 - 1):getPositionX() + var_0_0
				local var_17_7 = arg_17_0.vars.wnd:getChildByName("slot" .. iter_17_2 - 1):getPositionY() + var_0_1
				
				UIAction:Add(LOG(MOVE_TO(100, var_17_6, var_17_7), 1.5), var_17_5, "block")
			end
		end
	end
	
	arg_17_0:updateSellInfo()
	
	if arg_17_1:isForceLockCharacter() then
		arg_17_0.vars.hero_belt:update()
	end
end

function UnitSell.reqSell(arg_18_0, arg_18_1)
	local var_18_0 = {}
	local var_18_1 = {}
	local var_18_2
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.items) do
		table.push(var_18_0, iter_18_1:getUID())
		
		if iter_18_1:getBaseGrade() >= 4 and not iter_18_1:isFreeSaleUnit() then
			var_18_2 = true
		end
		
		for iter_18_2, iter_18_3 in pairs(iter_18_1.equips) do
			table.push(var_18_1, iter_18_3:getUID())
		end
	end
	
	if #var_18_0 == 0 then
		balloon_message_with_sound("send_char_select")
		
		return 
	end
	
	if var_18_2 and not arg_18_1 then
		Dialog:msgBox(T("confirm_sell_unit"), {
			yesno = true,
			handler = function()
				arg_18_0:reqSell(true)
			end,
			yes_text = T("unit_sell_yes"),
			no_text = T("unit_sell_no")
		})
		
		return 
	end
	
	Dialog:msgBox(T("confirm_sell_equip", {
		num = #arg_18_0.vars.items
	}), {
		yesno = true,
		handler = function()
			query("sell_unit", {
				units = array_to_json(var_18_0),
				equips = array_to_json(var_18_1)
			})
		end,
		yes_text = T("unit_sell_yes"),
		no_text = T("unit_sell_no")
	})
end

function UnitSell.doSell(arg_21_0, arg_21_1)
	arg_21_0:removeAllItems()
	UIAction:AddSync(SEQ(DELAY(100), CALL(UnitSell.doSell_1, arg_21_0, arg_21_1)), arg_21_0, "block")
end

function UnitSell.doSell_1(arg_22_0, arg_22_1)
	ConditionContentsManager:setIgnoreQuery(true)
	
	local var_22_0 = {}
	
	if arg_22_1.currency then
		for iter_22_0, iter_22_1 in pairs(arg_22_1.currency) do
			table.push(var_22_0, {
				token = iter_22_0,
				count = to_n(iter_22_1) - Account:getPropertyCount(iter_22_0)
			})
		end
	end
	
	if arg_22_1.items then
		for iter_22_2, iter_22_3 in pairs(arg_22_1.items) do
			table.push(var_22_0, {
				token = iter_22_2,
				count = to_n(iter_22_3) - Account:getPropertyCount(iter_22_2)
			})
		end
	end
	
	Account:updateCurrencies(arg_22_1.currency)
	Account:updateProperties(arg_22_1.items)
	TopBarNew:topbarUpdate(true)
	arg_22_0:removeAllItems()
	Account:removeUnits(arg_22_1.sell_list)
	arg_22_0.vars.hero_belt:clearPoppedItems()
	arg_22_0:updateSellInfo()
	Dialog:msgRewards(T("sell_unit_txt"), {
		rewards = var_22_0,
		title = T("sell_unit_title")
	})
	ConditionContentsManager:setIgnoreQuery(false)
	ConditionContentsManager:queryUpdateConditions("h:doSell_1")
end

function UnitSell.fillBy2GradeUnits(arg_23_0)
	if not arg_23_0.vars or not arg_23_0.vars.hero_belt then
		return 
	end
	
	if #arg_23_0.vars.items >= 12 then
		balloon_message_with_sound("cant_sell")
		
		return 
	end
	
	local var_23_0 = {}
	
	for iter_23_0, iter_23_1 in pairs(Account.units or {}) do
		if iter_23_1:getGrade() == 2 and not iter_23_1:isLocked() and iter_23_1:getUsableCodeList(nil, "Sell") == nil then
			local var_23_1 = iter_23_1:getUID()
			local var_23_2 = false
			
			if table.find(var_23_0, function(arg_24_0, arg_24_1)
				return arg_24_1:getUID() == var_23_1
			end) then
				var_23_2 = true
			end
			
			if table.find(arg_23_0.vars.items, function(arg_25_0, arg_25_1)
				return arg_25_1:getUID() == var_23_1
			end) then
				var_23_2 = true
			end
			
			if var_23_2 == false then
				table.insert(var_23_0, iter_23_1)
				
				if #arg_23_0.vars.items + #var_23_0 >= 12 then
					break
				end
			end
		end
	end
	
	arg_23_0.vars.hero_belt:popItems(var_23_0)
	
	for iter_23_2, iter_23_3 in pairs(var_23_0) do
		arg_23_0:updateItems(iter_23_3, false, true)
	end
	
	if #var_23_0 > 0 then
		vibrate(VIBRATION_TYPE.Select)
		SoundEngine:play("event:/ui/upgrade/slot_in")
	else
		balloon_message_with_sound("sell_2star_not_exist")
	end
end
