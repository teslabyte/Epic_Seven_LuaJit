UnitMultiPromote = {}
DEBUG.DEBUG_UNIT_MULTI_PROMOTE = nil

function HANDLER.unit_bulk_upgrade(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_material" then
		if arg_1_0.unit then
			UnitMultiPromoteTargetList:remove(arg_1_0)
		else
			UnitMultiPromoteTargetList:selected(arg_1_0)
		end
	end
	
	if arg_1_1 == "btn_target" then
		UnitMultiPromoteTargetList:selected(arg_1_0, true)
	end
	
	if arg_1_1 == "btn_setting" then
		TutorialGuide:procGuide("bulk_upgrade")
		UnitMultiPromote:openSettingPopup()
	end
	
	if arg_1_1 == "btn_reinforce" then
		UnitMultiPromote:query(DEBUG.DEBUG_UNIT_MULTI_PROMOTE)
	end
end

function MsgHandler.upgrade_multi_units(arg_2_0)
	UnitMultiPromote:onReceive(arg_2_0)
end

function UnitMultiPromote.onReceive(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.del_unit_list
	local var_3_1 = arg_3_1.gold
	local var_3_2 = arg_3_1.total_price
	local var_3_3 = arg_3_1.targets
	local var_3_4 = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_3) do
		local var_3_5 = arg_3_0.vars.target_units[tostring(iter_3_1.id)]
		
		if not var_3_5 then
			Log.e("NOT IN A TARGET UNITS!")
			
			return 
		end
		
		local var_3_6 = var_3_5:getGrade()
		local var_3_7 = var_3_5:getLv()
		
		UnitUpgradeLogic:UpdateLevelInfo(var_3_5, iter_3_1, var_3_6)
		UnitUpgradeLogic:UpdateAccountUnitInfo(var_3_5, iter_3_1, var_3_7)
		table.insert(var_3_4, {
			unit = var_3_5
		})
	end
	
	UnitUpgradeLogic:UpdateAccountData(arg_3_1, var_3_0)
	arg_3_0.vars.hero_belt:clearPoppedItems()
	
	local var_3_8 = Dialog:msgRewards(T("ui_bulkup_result_desc"), {
		no_db_grade = true,
		rewards = var_3_4,
		handler = function()
			arg_3_0:onPushBackButton()
		end
	})
	
	if var_3_8 then
		local var_3_9 = var_3_8:findChildByName("n_top")
		
		if get_cocos_refid(var_3_9) then
			if_set(var_3_9, "txt_title", T("promotion_up_title"))
		end
	end
	
	UnitMultiPromoteTargetList:setList({}, {})
	vibrate(VIBRATION_TYPE.Success)
end

function UnitMultiPromote.query(arg_5_0, arg_5_1)
	local var_5_0 = UnitMultiPromoteTargetList:getList()
	local var_5_1 = arg_5_0:getPrice(var_5_0)
	
	if var_5_1 == 0 then
		balloon_message_with_sound("ui_bulkup_upgrade_none")
		
		return 
	end
	
	if Account:getCurrency("gold") - var_5_1 < 0 then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	local var_5_2 = {}
	local var_5_3 = {}
	
	arg_5_0.vars.target_units = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		local var_5_4 = iter_5_1.target
		
		if not var_5_4 then
			Log.e("UnitMultiPromote : INVALID TARGET")
			
			return 
		end
		
		local var_5_5 = iter_5_1.materials
		
		if not var_5_5 then
			return 
		end
		
		local var_5_6 = {}
		local var_5_7 = {}
		
		for iter_5_2, iter_5_3 in pairs(var_5_5) do
			if iter_5_3:getGrade() ~= var_5_4:getGrade() then
				Log.e("UnitMultiPromote : INVALID material")
				
				return 
			end
			
			for iter_5_4, iter_5_5 in pairs(iter_5_3.equips) do
				table.insert(var_5_7, iter_5_5:getUID())
			end
			
			table.insert(var_5_6, iter_5_3:getUID())
		end
		
		if table.count(var_5_5) == var_5_4:getGrade() then
			var_5_2[tostring(var_5_4:getUID())] = var_5_6
			arg_5_0.vars.target_units[tostring(var_5_4:getUID())] = var_5_4
			
			for iter_5_6, iter_5_7 in pairs(var_5_7) do
				table.insert(var_5_3, iter_5_7)
			end
		end
	end
	
	if arg_5_1 then
		arg_5_0:_debug_promote(var_5_2, var_5_0, var_5_3)
	else
		Dialog:msgBox(T("ui_bulkup_upgrade_check", {
			count = table.count(var_5_2)
		}), {
			yesno = true,
			handler = function()
				query("upgrade_multi_units", {
					units = json.encode(var_5_2),
					equips = array_to_json(var_5_3)
				})
			end,
			yes_text = T("ui_msgbox_ok")
		})
	end
end

function UnitMultiPromote.getPrice(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or UnitMultiPromoteTargetList:getList()
	
	local var_7_0 = {
		5000,
		10000,
		20000,
		40000,
		150000,
		99999999
	}
	local var_7_1 = 0
	local var_7_2 = 0
	
	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		if iter_7_1.target:getGrade() == table.count(iter_7_1.materials) then
			var_7_1 = var_7_1 + var_7_0[iter_7_1.target:getGrade()]
			var_7_2 = var_7_2 + 1
		end
	end
	
	return var_7_1, var_7_2
end

function UnitMultiPromote.updateText(arg_8_0)
	local var_8_0 = UnitMultiPromoteTargetList:getList()
	local var_8_1, var_8_2 = arg_8_0:getPrice(var_8_0)
	local var_8_3 = arg_8_0.vars.RIGHT:findChildByName("btn_reinforce")
	
	if_set(var_8_3, "labe_gold", comma_value(var_8_1))
	
	if var_8_1 == 0 then
		if_set_opacity(arg_8_0.vars.RIGHT, "btn_reinforce", 76.5)
	else
		if_set_opacity(arg_8_0.vars.RIGHT, "btn_reinforce", 255)
	end
	
	if_set(arg_8_0.vars.LEFT, "text_total", T("ui_bulkup_total_hero_list", {
		count = table.count(var_8_0)
	}))
	if_set(arg_8_0.vars.LEFT, "txt_choosing", T("ui_bulkup_choosing_hero_list", {
		count = var_8_2
	}))
	if_set(var_8_3, "label", T("ui_bulkup_upgrade_btn", {
		count = var_8_2
	}))
end

function UnitMultiPromote.onSelectUnit(arg_9_0, arg_9_1, arg_9_2)
	UnitMultiPromoteTargetList:addMaterial(arg_9_1)
end

function UnitMultiPromote.onPushBackground(arg_10_0)
	UnitMultiPromoteTargetList:selectOff()
end

function UnitMultiPromote.heroBeltEvent(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_1 == "select" then
		arg_11_0:onSelectUnit(arg_11_2)
	end
end

function UnitMultiPromote.openSettingPopup(arg_12_0)
	UnitMultiPromoteSetting:open(SceneManager:getRunningPopupScene(), MultiPromoteSelector:getOption())
end

function UnitMultiPromote.endSettingPopup(arg_13_0, arg_13_1)
	local var_13_0 = Account:getUnits()
	
	arg_13_0.vars.hero_belt:resetData(var_13_0, "MultiPromote", nil, nil, 1)
	MultiPromoteSelector:setOption(arg_13_1)
	
	local var_13_1 = MultiPromoteSelectorSave:save(arg_13_1)
	
	SAVE:setTempConfigData("multi_promote.config", var_13_1)
	
	arg_13_0.vars.targets = MultiPromoteSelector:findUpgradeableTargets()
	arg_13_0.vars.materials = MultiPromoteSelector:findMaterials(arg_13_0.vars.targets)
	
	UnitMultiPromoteTargetList:setList(arg_13_0.vars.targets, arg_13_0.vars.materials)
	arg_13_0:setInfoMessage()
end

function UnitMultiPromote.edit(arg_14_0, arg_14_1)
	local var_14_0 = Account:getUnits()
	
	arg_14_0.vars.hero_belt:resetData(var_14_0, "MultiPromote", arg_14_1, nil, 1)
end

function UnitMultiPromote.editEnd(arg_15_0)
	local var_15_0 = Account:getUnits()
	
	arg_15_0.vars.hero_belt:resetData(var_15_0, "MultiPromote", nil, nil, 1)
end

function UnitMultiPromote.setInfoMessage(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.wnd:findChildByName("n_infor")
	
	if_set(var_16_0, "label", T("ui_bulkup_upgrade_none"))
	if_set_visible(var_16_0, nil, table.count(arg_16_0.vars.materials) == 0)
end

function UnitMultiPromote.onCreate(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or {}
	arg_17_0.vars = {}
	arg_17_0.vars.wnd = load_dlg("unit_bulk_upgrade", true, "wnd")
	arg_17_0.vars.LEFT = arg_17_0.vars.wnd:findChildByName("LEFT")
	arg_17_0.vars.RIGHT = arg_17_0.vars.wnd:findChildByName("RIGHT")
	arg_17_0.vars.start_unit = arg_17_1.start_unit
	
	arg_17_0.vars.LEFT:setOpacity(0)
	arg_17_0.vars.RIGHT:setOpacity(0)
	arg_17_0.vars.LEFT:setVisible(false)
	arg_17_0.vars.RIGHT:setVisible(false)
	
	local var_17_0 = Account:getUnits()
	local var_17_1 = UnitMain.vars.base_wnd
	
	arg_17_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	arg_17_0.vars.prv_sort_index = arg_17_0.vars.hero_belt:getSortIndex()
	
	arg_17_0.vars.hero_belt:resetData(var_17_0, "MultiPromote", nil, nil, 1)
	TopBarNew:setTitleName(T("ui_bulkup_title"))
	TopBarNew:forcedHelp_OnOff(false)
	MultiPromoteSelector:init()
	MultiPromoteSelector:setDataSource(var_17_0)
	
	local var_17_2 = Account:getConfigData("multi_promote.config")
	
	if var_17_2 then
		local var_17_3 = MultiPromoteSelectorSave:load(var_17_2)
		
		MultiPromoteSelector:setOption(var_17_3)
	end
	
	arg_17_0.vars.opts = arg_17_1
	arg_17_0.vars.targets = MultiPromoteSelector:findUpgradeableTargets()
	arg_17_0.vars.materials = MultiPromoteSelector:findMaterials(arg_17_0.vars.targets)
	arg_17_0.vars.parent_wnd = var_17_1
	
	if not UnitMultiPromoteTargetList:init(arg_17_0.vars.wnd:findChildByName("listview"), arg_17_0.vars.targets, arg_17_0.vars.materials) then
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	arg_17_0:setInfoMessage()
	var_17_1:addChild(arg_17_0.vars.wnd)
	arg_17_0.vars.wnd:setLocalZOrder(1)
	arg_17_0.vars.hero_belt:scrollToFirstUnit()
	TutorialGuide:startGuide("bulk_upgrade")
	
	if arg_17_1.use_scene_state then
		arg_17_0.vars.use_scene_state = true
		arg_17_0.vars.prev_mode = arg_17_1.prev_mode
	end
end

function UnitMultiPromote.getSceneState(arg_18_0)
	if not arg_18_0.vars then
		return {}
	end
	
	return {
		use_scene_state = true,
		prev_mode = arg_18_0.vars.prev_mode,
		start_mode = UnitMain.vars.start_mode
	}
end

function UnitMultiPromote.onPushBackButton(arg_19_0)
	if arg_19_0.vars.start_unit and not Account:getUnit(arg_19_0.vars.start_unit:getUID()) then
		arg_19_0.vars.start_unit = nil
	end
	
	UnitMain:setMode(arg_19_0.vars.prev_mode, {
		unit = arg_19_0.vars.start_unit
	})
end

function UnitMultiPromote.onEnter(arg_20_0, arg_20_1)
	if not arg_20_0.vars.use_scene_state then
		arg_20_0.vars.prev_mode = arg_20_1
	else
		UnitMain:showUnitList(true)
	end
	
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_20_0.vars.LEFT, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 600)), arg_20_0.vars.RIGHT, "block")
end

function UnitMultiPromote.onLeave(arg_21_0, arg_21_1)
	UIAction:Add(SEQ(SLIDE_OUT(200, 600)), arg_21_0.vars.LEFT, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, 600)), arg_21_0.vars.RIGHT, "block")
	UIAction:Add(SEQ(DELAY(200), REMOVE()), arg_21_0.vars.wnd)
	arg_21_0.vars.wnd:removeFromParent()
	arg_21_0.vars.hero_belt:revertPoppedItem()
	
	if arg_21_1 then
		TopBarNew:forcedHelp_OnOff(true)
		arg_21_0.vars.hero_belt:resetData(Account.units, arg_21_1)
		arg_21_0.vars.hero_belt:sort(arg_21_0.vars.prv_sort_index, true)
	end
end

if not PRODUCTION_MODE then
	UnitMultiPromoteDebug = {}
	
	function UnitMultiPromoteDebug.start(arg_22_0)
		arg_22_0.vars = {}
		arg_22_0.vars.unit_list = {}
	end
	
	function UnitMultiPromoteDebug.addUnit(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		table.insert(arg_23_0.vars.unit_list, UNIT:create({
			code = arg_23_1,
			g = arg_23_2,
			exp = arg_23_3
		}))
	end
	
	function UnitMultiPromoteDebug.show(arg_24_0)
		DEBUG.DEBUG_UNIT_MULTI_PROMOTE = true
		
		local var_24_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_24_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		SceneManager:getRunningPopupScene():addChild(var_24_0)
		UnitMultiPromote:onCreate({
			_debug_units = arg_24_0.vars.unit_list,
			_debug_layer = var_24_0
		})
	end
	
	UMPD = UnitMultiPromoteDebug
end

function UnitMultiPromote._debug_promote(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = {}
	
	local function var_25_1(arg_26_0)
		return {
			g = arg_26_0:getGrade(),
			name = arg_26_0:getName(),
			lv = arg_26_0:getLv(),
			uid = arg_26_0:getUID()
		}
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_2) do
		local var_25_2 = iter_25_1
		
		if arg_25_1[tostring(var_25_2.target:getUID())] then
			local var_25_3 = var_25_2.materials
			local var_25_4 = {}
			
			for iter_25_2, iter_25_3 in pairs(var_25_3) do
				table.insert(var_25_4, var_25_1(iter_25_3))
			end
			
			table.insert(var_25_0, {
				materials = var_25_4,
				target = var_25_1(var_25_2.target)
			})
		end
	end
	
	var_25_0.equips_count = table.count(arg_25_3 or {})
	
	if MTV then
		MTV:setTbl(var_25_0)
	else
		table.print(var_25_0)
	end
end
