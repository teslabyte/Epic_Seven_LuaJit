Bistro = {}

function HANDLER.bistro_bar(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_fast_start" then
		Bistro:ReqFastHeal(getParentWindow(arg_1_0).unit)
	end
end

function HANDLER.bistro(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_start" then
		Bistro:startEating()
	elseif arg_2_1 == "btn_start" then
		Bistro:finishEating()
	elseif arg_2_1 == "btn_end" then
		Bistro:ReqFinishEating()
	end
end

function MsgHandler.bistro(arg_3_0)
	SoundEngine:play("event:/ui/heal/quick")
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.hp_infos) do
		local var_3_0 = Account:getUnit(iter_3_1.id)
		
		var_3_0:updateHPInfo(iter_3_1)
		var_3_0:reset()
		
		if Bistro:isVisible() then
			Bistro:removeUnitFromWaitingListById(iter_3_1.id)
		end
	end
	
	Account:updateCurrencies(arg_3_0)
	TopBarNew:topbarUpdate(true)
	
	if Bistro:isVisible() then
		UIUtil:playNPCSoundAndTextRandomly("heal.recovery", Bistro.vars.wnd, "txt_ballon", nil, "heal.idle")
		Bistro:updateHeroBelt()
		Bistro:updateTables()
	elseif HeroBelt:isValid() then
		HeroBelt:resetData(Bistro:_getUnits())
	end
end

function MsgHandler.fin_eating(arg_4_0)
	SoundEngine:play("event:/ui/heal/quick")
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.units) do
		Account:updateUnitByInfo(iter_4_1)
	end
	
	Account:updateCurrencies(arg_4_0)
	TopBarNew:topbarUpdate(true)
	
	if Bistro:isVisible() then
		UIUtil:playNPCSoundAndTextRandomly("heal.recovery", Bistro.vars.wnd, "txt_ballon", nil, "heal.idle")
		Bistro:updateHeroBelt()
		Bistro:updateTables()
		Bistro:setAniPortrait("action_01")
	elseif HeroBelt:isValid() then
		if BattleReady:isShow() then
			HeroBelt:resetDataUseFilter(Bistro:_getUnits(), nil, nil, true)
		else
			HeroBelt:resetData(Bistro:_getUnits())
		end
	end
	
	if BattleReady:isShow() then
		LuaEventDispatcher:dispatchEvent("formation.res", "bistro.update")
	end
end

copy_functions(ScrollView, Bistro)

function Bistro.getScrollViewItem(arg_5_0, arg_5_1)
	local var_5_0 = load_control("wnd/bistro_bar.csb")
	
	if_set_visible(var_5_0, "btn_fast_start", false)
	if_set_visible(var_5_0, "n_unit", false)
	
	return var_5_0
end

function Bistro.onSelectScrollViewItem(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0
	
	if type(arg_6_0.vars.tables[arg_6_1]) ~= "number" then
		var_6_0 = arg_6_0.vars.tables[arg_6_1]
	end
	
	if var_6_0 then
		arg_6_0:popUnitFromFreeTable(arg_6_2.control, arg_6_2.item)
		
		return 
	else
		if var_6_0 then
			arg_6_0:ReqFastHeal(var_6_0)
		end
		
		if arg_6_1 <= GAME_STATIC_VARIABLE.bed_free then
			balloon_message_with_sound("touch_unit_to_eat")
		end
	end
end

function Bistro.ReqFastHeal(arg_7_0, arg_7_1)
	if arg_7_1 and arg_7_1:isEating() then
		Dialog:msgBox(T("wanna_fin_eating"), {
			token = "to_gold",
			yesno = true,
			cost = arg_7_0:GetFinishCost(arg_7_1),
			handler = function()
				local var_8_0 = {
					[tostring(arg_7_1:getUID())] = "hp"
				}
				
				query("fin_eating", {
					units = json.encode(var_8_0)
				})
			end
		})
		
		return 
	end
end

function Bistro.ReqFinishEating(arg_9_0, arg_9_1)
	if arg_9_1 == nil then
		arg_9_1 = {}
		
		for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.eating_units) do
			table.push(arg_9_1, iter_9_1)
		end
	end
	
	if table.count(arg_9_1) < 1 then
		balloon_message_with_sound("no_eating_units")
		
		return 
	end
	
	local var_9_0 = {}
	
	for iter_9_2, iter_9_3 in pairs(arg_9_1) do
		if iter_9_3:isEating() then
			table.push(var_9_0, iter_9_3:getUID())
		end
	end
	
	if #var_9_0 == 0 then
		balloon_message_with_sound("no_eating_units")
		
		return 
	end
	
	Dialog:msgBox(T("fin_eating"), {
		token = "to_gold",
		title = T("fin_eating_title"),
		cost = arg_9_0:GetTotalFinishCost(arg_9_1),
		handler = function()
			query("fin_eating", {
				units = json.encode(var_9_0)
			})
		end
	})
end

function Bistro.updateUnitBar(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0
	local var_11_1
	
	if type(arg_11_2) == "number" then
		local var_11_2 = arg_11_2
		
		arg_11_1.unit = nil
		
		if_set_visible(arg_11_1, "lock", false)
		if_set_visible(arg_11_1, "n_unit", false)
	else
		if not arg_11_1.n_unit then
			arg_11_1.n_unit = cc.CSLoader:createNode("wnd/unit_bar.csb")
			
			arg_11_1:getChildByName("n_unit"):addChild(arg_11_1.n_unit)
		end
		
		local var_11_3 = arg_11_2
		
		if_set_visible(arg_11_1, "n_unit", true)
		UIUtil:updateUnitBarColor(arg_11_1, var_11_3, "Bistro")
		UIUtil:updateUnitBar("Bistro", var_11_3, {
			force_update = true,
			wnd = arg_11_1,
			lv = var_11_3:getLv(),
			max_lv = var_11_3:getMaxLevel()
		})
		
		if var_11_3:isEating() then
			if_set_visible(arg_11_1, "btn_fast_start", true)
		end
		
		local var_11_4 = arg_11_1.n_unit:getChildByName("main_bg")
		
		if var_11_4 and var_11_4:isVisible() then
			if_set(var_11_4, "txt", T("ui_unit_bar_mainhero"))
		end
		
		arg_11_1.unit = var_11_3
	end
end

function Bistro.show(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0.vars and arg_12_0.vars.wnd and get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	arg_12_2 = arg_12_2 or {}
	arg_12_0.vars = {}
	arg_12_0.vars.waiting_units = {}
	arg_12_0.vars.eating_units = {}
	arg_12_0.vars.close_handler = arg_12_2.close_handler
	arg_12_0.vars.parent = arg_12_1
	arg_12_0.vars.wnd = load_dlg("bistro", true, "wnd")
	
	arg_12_0.vars.wnd:setOpacity(0)
	
	arg_12_0.vars.prev_hero_belt = arg_12_2.hero_belt
	
	local var_12_0 = NONE()
	
	if arg_12_2.hero_belt then
		if_set_visible(arg_12_0.vars.wnd, "unit_base", false)
		if_set_visible(arg_12_0.vars.wnd, "touch", false)
		
		var_12_0 = CALL(arg_12_0.linkHeroBelt, arg_12_0)
	else
		var_12_0 = CALL(arg_12_0.hideParent, arg_12_0)
		
		TopBarNew:createFromPopup(T("quick_launch_btn_heal"), arg_12_0.vars.wnd, function()
			Bistro:close()
			BackButtonManager:pop("TopBarNew." .. T("quick_launch_btn_heal"))
		end)
		arg_12_0:createHeroBelt()
	end
	
	arg_12_0.vars.wnd:getChildByName("ballon"):setScale(0)
	UIUtil:playNPCSoundAndTextRandomly("heal.enter", arg_12_0.vars.wnd, "txt_ballon", nil, "heal.idle")
	if_set_visible(arg_12_0.vars.wnd, "n_no_units", HeroBelt:getItemCount() == 0)
	
	local var_12_1 = arg_12_0.vars.wnd:getChildByName("RIGHT")
	local var_12_2 = arg_12_0.vars.wnd:getChildByName("LEFT")
	local var_12_3 = var_12_1:getPositionX()
	
	var_12_1:setPositionX(600)
	UIAction:Add(SEQ(DELAY(200), LOG(MOVE_TO(200, var_12_3))), var_12_1, "block")
	
	local var_12_4 = var_12_2:getPositionX()
	
	var_12_2:setPositionX(-600)
	UIAction:Add(LOG(MOVE_TO(250, var_12_4)), var_12_2, "block")
	UIAction:Add(SEQ(OPACITY(200, 0, 1), var_12_0), arg_12_0.vars.wnd, "block")
	arg_12_0:initScrollView(var_12_1:getChildByName("scrollview"), 380, 96)
	arg_12_0:updateTables()
	arg_12_0.vars.unit_dock.dock:scrollToIndex(1, 0.7)
	arg_12_1:addChild(arg_12_0.vars.wnd)
	Scheduler:add(arg_12_0.vars.wnd, arg_12_0.onUpdate, arg_12_0)
	
	local var_12_5 = UIUtil:getPortraitAni("npc1035", {
		layer = arg_12_0.vars.wnd
	})
	
	if var_12_5 then
		arg_12_0.vars.wnd:getChildByName("n_portrait"):addChild(var_12_5)
		var_12_5:setPositionX(var_12_5:getPositionX() + 10)
		var_12_5:setPositionY(var_12_5:getPositionY() - 250)
		var_12_5:setScale(0.9)
	end
	
	arg_12_0.vars.portrait = var_12_5
	
	SoundEngine:play("event:/ui/main_hud/btn_heal")
	TutorialGuide:startGuide(UNLOCK_ID.BISTRO)
end

function Bistro.setAniPortrait(arg_14_0, arg_14_1)
	if Action:Find("portrait") then
		return 
	end
	
	if arg_14_0.vars and get_cocos_refid(arg_14_0.vars.portrait) and arg_14_0.vars.portrait.is_model then
		Action:Add(SEQ(DMOTION(arg_14_1), MOTION("idle", true)), arg_14_0.vars.portrait, "portrait")
	end
end

function Bistro.findUnit(arg_15_0, arg_15_1, arg_15_2)
	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		if iter_15_1 == arg_15_2 then
			return arg_15_2
		end
	end
end

function Bistro.updateTables(arg_16_0)
	arg_16_0.vars.tables = {}
	
	for iter_16_0 = 1, GAME_STATIC_VARIABLE.bed_max do
		table.insert(arg_16_0.vars.tables, iter_16_0)
	end
	
	local var_16_0 = 0
	local var_16_1 = 0
	
	arg_16_0.vars.eating_units = arg_16_0:getEatingUnits()
	
	for iter_16_1, iter_16_2 in pairs(arg_16_0.vars.eating_units) do
		if iter_16_2:isEating() then
			var_16_1 = var_16_1 + arg_16_0:GetFinishCost(iter_16_2)
		end
	end
	
	for iter_16_3, iter_16_4 in pairs(arg_16_0.vars.waiting_units) do
		var_16_0 = var_16_0 + 1
		arg_16_0.vars.tables[var_16_0] = iter_16_4
	end
	
	local var_16_2 = #arg_16_0.vars.waiting_units
	
	arg_16_0:updateScrollViewItems(arg_16_0.vars.tables)
	
	for iter_16_5, iter_16_6 in pairs(arg_16_0.ScrollViewItems) do
		arg_16_0:updateUnitBar(iter_16_6.control, iter_16_6.item)
	end
	
	if_set(arg_16_0.vars.wnd, "cost_end_eating", comma_value(var_16_1))
	if_set(arg_16_0.vars.wnd, "cost_start_eating", comma_value(arg_16_0:GetStartCost()))
	if_set(arg_16_0.vars.wnd, "cost_start_fast_eating", comma_value(arg_16_0:GetStartCost() * 2))
	if_set_visible(arg_16_0.vars.wnd, "btn_add_bed", false)
	UIUtil:changeButtonState(arg_16_0.vars.wnd:getChildByName("btn_start"), #arg_16_0.vars.waiting_units > 0)
	UIUtil:changeButtonState(arg_16_0.vars.wnd:getChildByName("btn_end"), #arg_16_0.vars.eating_units > 0)
end

function Bistro.popUnitFromFreeTable(arg_17_0, arg_17_1, arg_17_2)
	HeroBelt:revertPoppedItem(arg_17_2)
	HeroBelt:updateUnit(nil, arg_17_2)
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.waiting_units) do
		if iter_17_1:getUID() == arg_17_2:getUID() then
			table.remove(arg_17_0.vars.waiting_units, iter_17_0)
			SoundEngine:play("event:/ui/upgrade/slot_out")
			
			break
		end
	end
	
	arg_17_0:updateTables()
end

function Bistro.onSelectUnitList(arg_18_0, arg_18_1)
	if #arg_18_0.vars.waiting_units >= GAME_STATIC_VARIABLE.bed_free then
		balloon_message_with_sound("no_empty_table")
		
		return 
	end
	
	if arg_18_1:getHPRatio() == 1 then
		balloon_message_with_sound("not_sick_unit")
		
		return 
	end
	
	arg_18_0:pushUnitToFreeTable(arg_18_1)
	SoundEngine:play("event:/ui/upgrade/slot_in")
end

function Bistro.pushUnitToFreeTable(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.tables) do
		if type(iter_19_1) == "number" then
			arg_19_0.vars.tables[iter_19_0] = arg_19_1
		end
	end
	
	table.push(arg_19_0.vars.waiting_units, arg_19_1)
	HeroBelt:popItem(arg_19_1)
	HeroBelt:updateUnit(nil, arg_19_1)
	arg_19_0:updateTables()
end

function Bistro.onHeroListEvent(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_1 == "select" then
		arg_20_0:onSelectUnitList(arg_20_2, arg_20_3)
	end
end

function Bistro.createHeroBelt(arg_21_0)
	arg_21_0.vars.unit_dock = HeroBelt:create("Bistro")
	
	arg_21_0.vars.unit_dock:setEventHandler(arg_21_0.onHeroListEvent, arg_21_0)
	arg_21_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_21_0.vars.wnd:addChild(arg_21_0.vars.unit_dock:getWindow())
	HeroBelt:resetData(Bistro:_getUnits(), "Bistro")
	
	local var_21_0 = arg_21_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_21_0.vars.unit_dock:getWindow():setPositionX(var_21_0 + 300)
	UIAction:Add(SEQ(DELAY(150), LOG(MOVE_TO(200, var_21_0), 100)), arg_21_0.vars.unit_dock:getWindow(), "block")
end

function Bistro.linkHeroBelt(arg_22_0)
	arg_22_0.vars.prev_hero_belt:retain()
	arg_22_0.vars.prev_hero_belt:removeFromParent()
	arg_22_0.vars.wnd:addChild(arg_22_0.vars.prev_hero_belt)
	arg_22_0.vars.prev_hero_belt:release()
end

function Bistro.hideParent(arg_23_0)
	local var_23_0 = {
		arg_23_0.vars.wnd
	}
	
	arg_23_0.vars.parent_childs = UIUtil:hideChilds(arg_23_0.vars.parent, var_23_0)
end

function Bistro.close(arg_24_0)
	TopBarNew:pop()
	UIUtil:playNPCSound("heal.leave", 250)
	Scheduler:remove(arg_24_0.onUpdate)
	UIUtil:showChilds(arg_24_0.vars.parent_childs)
	
	if arg_24_0.vars.unit_dock then
		local var_24_0 = arg_24_0.vars.unit_dock:getWindow():getPositionX()
		
		UIAction:Add(SEQ(RLOG(MOVE_TO(200, var_24_0 + 300), 100)), arg_24_0.vars.unit_dock:getWindow(), "block")
	end
	
	UIAction:Add(RLOG(MOVE_TO(200, 600)), arg_24_0.vars.wnd:getChildByName("RIGHT"), "block")
	UIAction:Add(SEQ(DELAY(80), RLOG(MOVE_TO(200, -600))), arg_24_0.vars.wnd:getChildByName("LEFT"), "block")
	UIAction:Add(SEQ(DELAY(300), CALL(arg_24_0.fin_close, arg_24_0), REMOVE()), arg_24_0.vars.wnd, "block")
	
	if not arg_24_0.vars.prev_hero_belt then
		UIAction:Add(SEQ(FADE_OUT(400)), arg_24_0.vars.wnd, "block")
	end
	
	if arg_24_0.vars.close_handler then
		arg_24_0.vars.close_handler()
	end
	
	if SceneManager:getCurrentScene():getName() == "lobby" then
		Lobby:updateTopBar()
		TopBarNew:updateFeedButton()
		Lobby:updateUnitInfo()
	end
end

function Bistro.isVisible(arg_25_0)
	return arg_25_0.vars and get_cocos_refid(arg_25_0.vars.wnd)
end

function Bistro.fin_close(arg_26_0)
	if arg_26_0.vars.prev_hero_belt then
		arg_26_0.vars.prev_hero_belt:retain()
		arg_26_0.vars.prev_hero_belt:removeFromParent()
		arg_26_0.vars.parent:addChild(arg_26_0.vars.prev_hero_belt)
	end
	
	arg_26_0.vars = nil
end

function Bistro.getWaitingUnit(arg_27_0, arg_27_1)
	if not arg_27_0.vars then
		return nil
	end
	
	return arg_27_0.vars.waiting_units[arg_27_1]
end

function Bistro.GetFinishCost(arg_28_0, arg_28_1)
	return arg_28_0:GetStartCost(arg_28_1)
end

function Bistro.GetStartCost(arg_29_0, arg_29_1)
	if not arg_29_1 then
		local var_29_0 = 0
		
		for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.waiting_units) do
			if iter_29_1 then
				var_29_0 = var_29_0 + arg_29_0:GetStartCost(iter_29_1)
			end
		end
		
		return var_29_0
	end
	
	local var_29_1 = (1000 - math.min(arg_29_1.inst.start_hp_r, arg_29_1:getMPRatio(1) * 1000)) / 10
	local var_29_2 = math.floor(var_29_1 * math.pow(arg_29_1:getGrade(), arg_29_1:getLv() * 0.03) * 5)
	local var_29_3 = var_29_2 - Booster:getAddCalcValue(BOOSTERSKILL_EFFECT_TYPE.HEAL_GOLD_REDUCE, var_29_2)
	
	if arg_29_1:isEmptyHP() then
		return var_29_3 * (GAME_STATIC_VARIABLE.auto_hp_penalty_dead or 1)
	end
	
	if arg_29_1:isGetInjured() then
		return var_29_3 * (GAME_STATIC_VARIABLE.auto_hp_penalty_sick or 1)
	end
	
	return var_29_3
end

function Bistro.startEating(arg_30_0)
	if #arg_30_0.vars.waiting_units == 0 then
		balloon_message_with_sound("no_waiting_units")
		
		return 
	end
	
	local var_30_0 = {}
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.waiting_units) do
		var_30_0[tostring(iter_30_1:getUID())] = "hp"
	end
	
	arg_30_0:setAniPortrait("action_00")
	Dialog:msgBox(T("wanna_fin_eating"), {
		token = "to_gold",
		yesno = true,
		cost = arg_30_0:GetTotalFinishCost(arg_30_0.vars.waiting_units),
		handler = function()
			SoundEngine:play("event:/ui/heal/start")
			query("fin_eating", {
				units = json.encode(var_30_0)
			})
		end
	})
end

function Bistro.finishEating(arg_32_0)
	if #arg_32_0.vars.eating_units == 0 then
		balloon_message_with_sound("no_eating_units")
		
		return 
	end
end

function Bistro.onUpdate(arg_33_0)
	set_high_fps_tick()
	
	local var_33_0 = os.time()
	
	if arg_33_0.vars.tm == var_33_0 then
		return 
	end
	
	arg_33_0.vars.tm = var_33_0
	
	local var_33_1 = {}
	local var_33_2
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.ScrollViewItems) do
		if type(iter_33_1.item) == "table" and UIUtil:updateEatingEndTime(iter_33_1.control, iter_33_1.item) == 0 then
			var_33_2 = true
		end
	end
	
	for iter_33_2 = #arg_33_0.vars.waiting_units, 1, -1 do
		if not arg_33_0.vars.waiting_units[iter_33_2]:isEating() then
			table.remove(arg_33_0.vars.waiting_units, iter_33_2)
		end
	end
	
	if var_33_2 then
		arg_33_0:updateTables()
	end
	
	local var_33_3 = HeroBelt:getItems()
	
	for iter_33_3, iter_33_4 in pairs(var_33_3) do
		if not iter_33_4:isEating() then
			HeroBelt:popItem(iter_33_4)
		end
	end
end

function Bistro.getEatingUnits(arg_34_0)
	local var_34_0 = {}
	
	for iter_34_0, iter_34_1 in pairs(Bistro:_getUnits()) do
		if iter_34_1:isEating() then
			table.push(var_34_0, iter_34_1)
		end
	end
	
	table.sort(var_34_0, function(arg_35_0, arg_35_1)
		return arg_35_0.inst.eating_end_time < arg_35_1.inst.eating_end_time
	end)
	
	return var_34_0
end

function Bistro.test(arg_36_0)
	local var_36_0 = {}
	
	for iter_36_0, iter_36_1 in pairs(Bistro:_getUnits()) do
		if iter_36_1:getLv() > 10 then
			iter_36_1.inst.hp = math.random(1, iter_36_1.status.max_hp)
			iter_36_1.inst.start_hp_r = iter_36_1:getHPRatio(true)
			
			table.push(var_36_0, iter_36_1)
		end
	end
	
	Account:updateUnitHPs(var_36_0)
end

function Bistro.removeUnitFromWaitingListById(arg_37_0, arg_37_1)
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.waiting_units) do
		if iter_37_1:getUID() == arg_37_1 then
			table.remove(arg_37_0.vars.waiting_units, iter_37_0)
			
			return 
		end
	end
end

function Bistro.GetTotalFinishCost(arg_38_0, arg_38_1)
	local var_38_0 = 0
	
	for iter_38_0, iter_38_1 in pairs(arg_38_1) do
		var_38_0 = var_38_0 + arg_38_0:GetFinishCost(iter_38_1)
	end
	
	return var_38_0
end

function Bistro.updateHeroBelt(arg_39_0)
	local var_39_0 = {}
	
	for iter_39_0, iter_39_1 in pairs(Bistro:_getUnits()) do
		if not table.find(arg_39_0.vars.waiting_units, iter_39_1) then
			table.push(var_39_0, iter_39_1)
		end
	end
	
	HeroBelt:resetData(var_39_0)
end

function Bistro._getUnits(arg_40_0)
	local var_40_0 = {}
	
	for iter_40_0, iter_40_1 in pairs(Account.units) do
		table.push(var_40_0, iter_40_1)
	end
	
	return var_40_0
end
