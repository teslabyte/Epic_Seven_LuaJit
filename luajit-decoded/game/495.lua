local var_0_0 = {
	"weapon",
	"armor",
	"neck",
	"helm",
	"boot",
	"ring"
}
local var_0_1 = {
	"knight",
	"warrior",
	"ranger",
	"assassin",
	"manauser",
	"mage"
}

AlchemistSelect = {}

function MsgHandler.alchemist_combine(arg_1_0)
	AlchemistSelect:combined(arg_1_0)
end

function HANDLER.sanctuary_alchemy_equip_tooltip(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		AlchemistSelect:closeInfoPopup()
	end
end

function HANDLER_BEFORE.sanctuary_alchemy_sel(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "btn_select" or string.starts(arg_3_1, "btn_item") or arg_3_1 == "btn_catalyst" then
		arg_3_0.touch_tick = systick()
	end
end

function HANDLER.sanctuary_alchemy_sel(arg_4_0, arg_4_1)
	if string.starts(arg_4_1, "btn_equip_tab") then
		AlchemistSelect:selectItemTab(to_n(string.sub(arg_4_1, -1, -1)))
	elseif string.starts(arg_4_1, "btn_job_tab") then
		AlchemistSelect:selectItemTab(to_n(string.sub(arg_4_1, -1, -1)), true)
	elseif arg_4_1 == "btn_select" then
		local var_4_0 = arg_4_0:getParent().datasource
		
		if var_4_0 and systick() - to_n(arg_4_0.touch_tick) < 180 then
			if var_4_0.iscatalyst and var_4_0.count <= 0 then
				return 
			end
			
			if AlchemistSelect:isAutoInsert() and var_4_0 and var_4_0.selected then
				AlchemistSelect:selectItem(var_4_0, {
					clickCenter = true
				})
			else
				AlchemistSelect:selectItem(var_4_0, {
					clickCenter = false
				})
			end
			
			if var_4_0.iscatalyst then
				AlchemistSelect:updateCenterCatalyst(var_4_0)
			end
			
			if AlchemistSelect.vars and AlchemistSelect.vars.iscatalyst then
				AlchemistSelect:closeInfoPopup()
			end
		end
	elseif arg_4_1 == "btn_produce" then
		AlchemistSelect:Manufacture()
	elseif arg_4_1 == "btn_catalyst" then
		if systick() - to_n(arg_4_0.touch_tick) < 180 then
			AlchemistSelect:showCatalystList()
			AlchemistSelect:unSelectCatalyst()
		end
	elseif arg_4_1 == "btn_item_set_tooltip" then
	elseif arg_4_1 == "btn_close" then
		AlchemistSelect:closeInfoPopup()
	elseif arg_4_1 == "btn_next" then
		AlchemistSelect:showItemList()
	end
	
	for iter_4_0 = 1, 10 do
		if arg_4_1 == "btn_item" .. iter_4_0 and systick() - to_n(arg_4_0.touch_tick) < 180 then
			AlchemistSelect:selectCenterItem(iter_4_0)
		end
	end
	
	if string.starts(arg_4_1, "btn_skill") then
		AlchemistSelect:select_exclusiveSkill(to_n(string.sub(arg_4_1, -1, -1)))
	end
	
	if arg_4_1 == "btn_sel_stat" then
		AlchemistSelect:onSelectStat()
	end
	
	if arg_4_1 == "btn_selected_stat" then
		AlchemistSelect:onSelectedStat()
	end
	
	local var_4_1 = arg_4_0:getParent()
	
	if get_cocos_refid(var_4_1) and var_4_1:getName() == "n_mainstat_box" then
		AlchemistSelect:mainStatBoxHandler(arg_4_0, arg_4_1)
	end
	
	if arg_4_1 == "btn_sel_bulk" then
		AlchemistSelect:toggleAutoInsert()
	end
end

function HANDLER.sanctuary_alchemy_quantity(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_go" or arg_5_1 == "btn_close" then
		AlchemistSelect:closeCountPopup(arg_5_1)
	end
	
	if arg_5_1 == "btn_min" then
		AlchemistSelect:min()
	end
	
	if arg_5_1 == "btn_max" then
		AlchemistSelect:max()
	end
	
	if arg_5_1 == "btn_minus" then
		AlchemistSelect:minus()
	end
	
	if arg_5_1 == "btn_plus" then
		AlchemistSelect:plus()
	end
end

function HANDLER.sanctuary_alchemy_result(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_lock" or arg_6_1 == "btn_lock_done" then
		AlchemistSelect:LockUnLock_resultItem(arg_6_1)
	elseif arg_6_1 == "btn_sell" then
		AlchemistSelect:sellResultItem()
	elseif arg_6_1 == "btn_extract" then
		AlchemistSelect:extractResultItem()
	else
		AlchemistSelect:closeResultPopup()
	end
end

function HANDLER.sanctuary_alchemy_conversion_confirm(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_produce" then
		AlchemistSelect:req_manufacture()
		AlchemistSelect:closeCatalyst_confirmUI()
	elseif arg_7_1 == "btn_item_set_tooltip" then
	elseif arg_7_1 == "btn_cancel" then
		AlchemistSelect:closeCatalyst_confirmUI()
	end
end

function AlchemistSelect.onEnter(arg_8_0, arg_8_1)
	TutorialGuide:procGuide("system_071")
	
	arg_8_0.vars = {}
	arg_8_0.vars.selectedItems = {}
	arg_8_0.vars.qualityPoint = 0
	arg_8_0.vars.curQuality = 0
	
	local var_8_0 = load_dlg("sanctuary_alchemy_sel", true, "wnd", function()
		AlchemistSelect:onLeave()
	end)
	
	arg_8_0.vars.wnd = var_8_0
	
	if arg_8_0.vars.wnd then
		SanctuaryArchemist.vars.wnd:addChild(var_8_0)
	end
	
	arg_8_0:initAutoInsert()
	
	local var_8_1 = UIUtil:getPortraitAni("npc1089", {})
	
	if var_8_1 then
		arg_8_0.vars.wnd:getChildByName("n_portrait"):addChild(var_8_1)
		var_8_1:setName("@portrait")
		var_8_1:setScale(0.7)
	end
	
	arg_8_0.vars.cur_itemdata = arg_8_1
	arg_8_0.vars.res_excludes = string.split(arg_8_0.vars.cur_itemdata.res_exclude, ";")
	
	local var_8_2 = string.split(arg_8_0.vars.cur_itemdata.quality_standard, ";")
	
	arg_8_0.vars.quality_standard = var_8_2
	
	if #var_8_2 < 3 then
		arg_8_0.vars.quality_standard = {
			80,
			120,
			320
		}
	end
	
	arg_8_0.vars.qualityPoint_max = tonumber(var_8_2[3]) or 320
	
	arg_8_0:init(arg_8_1, var_8_0)
	arg_8_0:setProgressPos()
	arg_8_0:updateQuality_progBar()
	arg_8_0:updateCenterSlots()
	if_set_visible(SanctuaryMain.vars.parent, "n_upgrade_bar", false)
	
	if arg_8_0.vars.isExclusive then
		EffectManager:Play({
			fn = "ui_town_alchemy_bg_effect2.cfx",
			layer = arg_8_0.vars.wnd:getChildByName("bg_effect")
		})
	elseif arg_8_0.vars.iscatalyst then
		arg_8_0.vars.effect_1 = EffectManager:Play({
			fn = "ui_town_alchemy_bg_effect.cfx",
			layer = arg_8_0.vars.wnd:getChildByName("bg_effect")
		})
		arg_8_0.vars.effect_3 = EffectManager:Play({
			fn = "ui_town_alchemy_bg_effect3.cfx",
			layer = arg_8_0.vars.wnd:getChildByName("bg_effect")
		})
		
		arg_8_0.vars.effect_3:setVisible(false)
	else
		EffectManager:Play({
			fn = "ui_town_alchemy_bg_effect.cfx",
			layer = arg_8_0.vars.wnd:getChildByName("bg_effect")
		})
	end
	
	local var_8_3 = var_8_0:getChildByName("LEFT")
	local var_8_4 = var_8_0:getChildByName("RIGHT")
	local var_8_5 = var_8_0:getChildByName("CENTER")
	
	var_8_3:setPositionX(-300 + VIEW_BASE_LEFT)
	var_8_4:setPositionX(300 - VIEW_BASE_LEFT)
	var_8_5:setPositionY(-700)
	
	local var_8_6 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
	local var_8_7 = DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left"
	local var_8_8 = var_8_7 and 0 or  / 2
	local var_8_9 = not var_8_7 and 0 or  / 2
	
	UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT + var_8_8, 0)), var_8_3, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0 - VIEW_BASE_LEFT - var_8_9, 0)), var_8_4, "block")
	UIAction:Add(LOG(MOVE_TO(250, 608, 0)), var_8_5, "block")
	if_set_visible(arg_8_0.vars.wnd, "txt_balloon", false)
	
	if arg_8_0.vars.iscatalyst then
		UIUtil:playNPCSoundAndTextRandomly("alchemy_equip.select", arg_8_0.vars.wnd, "txt_balloon", 3000, "alchemy_equip.select")
	elseif arg_8_0.vars.isExclusive then
		UIUtil:playNPCSoundAndTextRandomly("alchemy_exclusive.craft", arg_8_0.vars.wnd, "txt_balloon", 3000, "alchemy_exclusive.craft")
	elseif arg_8_1.category == "alchemy_stone" then
		UIUtil:playNPCSoundAndTextRandomly("alchemy_stone.craft", arg_8_0.vars.wnd, "txt_balloon", 3000, "alchemy_stone.craft")
	elseif arg_8_1.category == "alchemy_material" then
		UIUtil:playNPCSoundAndTextRandomly("alchemy_material.craft", arg_8_0.vars.wnd, "txt_balloon", 3000, "alchemy_material.craft")
	elseif arg_8_1.category == "alchemy_essence" then
		UIUtil:playNPCSoundAndTextRandomly("alchemy_essence.craft", arg_8_0.vars.wnd, "txt_balloon", 3000, "alchemy_essence.craft")
	else
		UIUtil:playNPCSoundAndTextRandomly("alchemy.idle", arg_8_0.vars.wnd, "txt_balloon", 3000, "alchemy.idle")
	end
	
	GrowthGuideNavigator:proc()
	arg_8_0:checkAutoInsertCheckBox()
end

function AlchemistSelect.onLeave(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.wnd
	local var_10_1 = var_10_0:getChildByName("LEFT")
	local var_10_2 = var_10_0:getChildByName("RIGHT")
	local var_10_3 = var_10_0:getChildByName("CENTER")
	
	UIAction:Add(RLOG(MOVE_TO(200, VIEW_BASE_LEFT + -500, 0)), var_10_1, "block")
	UIAction:Add(RLOG(MOVE_TO(200, 500, 0)), var_10_2, "block")
	UIAction:Add(RLOG(MOVE_TO(200, 0, -700)), var_10_3, "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), var_10_0, "block")
	arg_10_0:closeCountPopup()
	arg_10_0:closeInfoPopup()
	BackButtonManager:pop()
	arg_10_0.vars.wnd:removeFromParent()
	
	arg_10_0.vars.wnd = nil
	arg_10_0.vars = nil
	
	if_set_visible(SanctuaryMain.vars.parent, "n_upgrade_bar", true)
	SanctuaryArchemist:updateCurScrollview()
end

function AlchemistSelect.reset_catalystCenterUI(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) or not arg_11_0.vars.iscatalyst then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.wnd
	
	if_set_visible(var_11_0:getChildByName("n_conversion"), "t_count", false)
	if_set_visible(var_11_0:getChildByName("n_conversion"), "icon_stat", false)
	if_set_opacity(var_11_0:getChildByName("n_conversion"), "btn_next", 76.5)
	if_set_visible(var_11_0:getChildByName("n_normal"), "txt_conversion_disc", true)
	if_set_visible(var_11_0:getChildByName("n_normal"), "txt_conversion_sel", false)
	if_set_visible(var_11_0:getChildByName("n_normal"), "txt_required", false)
	if_set_visible(var_11_0:getChildByName("n_normal"), "txt_material", false)
	
	if arg_11_0.vars.effect_1 then
		arg_11_0.vars.effect_1:setVisible(true)
	end
	
	if arg_11_0.vars.effect_3 then
		arg_11_0.vars.effect_3:setVisible(false)
	end
	
	local var_11_1 = arg_11_0.vars.wnd:getChildByName("n_conversion")
	
	var_11_1:getChildByName("node_conversion"):removeAllChildren()
	if_set_visible(var_11_1, "t_count", false)
	if_set(var_11_1, "t_main_stat", T("ui_alchemist_equip_catalyst_none"))
	if_set_visible(arg_11_0.vars.wnd, "n_normal", true)
	if_set_visible(arg_11_0.vars.wnd, "n_conversion", true)
	if_set_visible(arg_11_0.vars.wnd, "n_equip", false)
	if_set_visible(arg_11_0.vars.wnd, "btn_produce", false)
	
	local var_11_2 = arg_11_0.vars.wnd:findChildByName("CENTER")
	
	getChildByPath(var_11_2, "slot_5"):setVisible(false)
end

function AlchemistSelect.init(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 == nil or not get_cocos_refid(arg_12_2) then
		arg_12_0:onLeave()
		
		return 
	end
	
	local var_12_3, var_12_4, var_12_5
	
	if arg_12_1.category == "alchemy_change" then
		arg_12_0:initChangeStone(arg_12_1, arg_12_2)
	else
		local var_12_0 = arg_12_2:findChildByName("ListView_578_519")
		
		arg_12_0.vars.listview = var_12_0
		arg_12_0.vars.listview_catalyst = arg_12_2:getChildByName("ListView_catalyst")
		arg_12_0.vars.items = {}
		
		local var_12_1 = arg_12_2:getChildByName("CENTER")
		
		if arg_12_1.category == "alchemy_exclusive" then
			arg_12_0.vars.isExclusive = true
		elseif arg_12_1.category == "alchemy_equip" then
			arg_12_0.vars.iscatalyst = true
		end
		
		arg_12_0:initListViewl()
		
		arg_12_1 = arg_12_0:updateRequireGold(arg_12_1)
		
		if_set(arg_12_0.vars.wnd:getChildByName("no_data"), "label", T("msg_alchemist_no_resource"))
		
		if arg_12_1.category == "alchemy_stone" then
			if (string.split(arg_12_1.res_condition, "=") or " ")[2] == "alchemypoint" then
				arg_12_0.vars.isEuips_alchemyPoint = true
				arg_12_0.vars.itemMax_count = 5
				arg_12_0.vars.catalysts = {}
				
				arg_12_0:selectItemTab(1)
				getChildByPath(var_12_1, "slot_10"):setVisible(false)
				getChildByPath(var_12_1, "slot_private"):setVisible(false)
				if_set_visible(arg_12_0.vars.wnd, "btn_sorting", true)
				if_set_visible(arg_12_2, "n_tab_job", false)
			else
				arg_12_0.vars.isEquips = true
				arg_12_0.vars.itemMax_count = 10
				
				arg_12_0:selectItemTab(1)
				getChildByPath(var_12_1, "slot_5"):setVisible(false)
				getChildByPath(var_12_1, "slot_private"):setVisible(false)
				if_set_visible(arg_12_0.vars.wnd, "btn_sorting", true)
				if_set_visible(arg_12_2, "n_tab_job", false)
			end
			
			var_12_0:setContentSize({
				height = 526,
				width = var_12_0:getContentSize().width
			})
		elseif arg_12_0.vars.iscatalyst then
			arg_12_0.vars.itemMax_count = 5
			
			arg_12_0:refreshItems(true)
			getChildByPath(var_12_1, "slot_10"):setVisible(false)
			getChildByPath(var_12_1, "slot_private"):setVisible(false)
			if_set_visible(arg_12_2, "n_tab", false)
			if_set_visible(arg_12_2, "n_tab_job", false)
			if_set_visible(arg_12_0.vars.wnd, "btn_sorting", true)
			if_set_visible(arg_12_2, "n_tab_job", false)
			var_12_0:setVisible(false)
			if_set_visible(arg_12_0.vars.wnd, "ListView_catalyst", true)
			if_set_visible(var_12_1, "n_stat", false)
			
			local var_12_2 = getChildByPath(var_12_1, "slot_5")
			
			var_12_2:setVisible(false)
			var_12_2:setOpacity(76.5)
			if_set_visible(arg_12_0.vars.wnd, "no_data", #arg_12_0.vars.catalysts == 0)
			arg_12_0:setInfoPopup_tooltip(1)
		elseif arg_12_0.vars.isExclusive then
			arg_12_0.vars.isExclusive = true
			arg_12_0.vars.selected_skill = nil
			arg_12_0.vars.itemMax_count = 8
			
			arg_12_0:selectItemTab(1, true)
			getChildByPath(var_12_1, "slot_private"):setVisible(true)
			getChildByPath(var_12_1, "slot_5"):setVisible(false)
			getChildByPath(var_12_1, "slot_10"):setVisible(false)
			if_set_visible(arg_12_0.vars.wnd, "btn_sorting", true)
			if_set_visible(arg_12_2, "n_tab", false)
			if_set_visible(arg_12_2, "n_tab_job", true)
			var_12_0:setContentSize({
				height = 526,
				width = var_12_0:getContentSize().width
			})
		else
			arg_12_0.vars.isEquips = false
			arg_12_0.vars.itemMax_count = 5
			
			if_set_visible(arg_12_2, "n_tab", false)
			if_set_visible(arg_12_2, "n_tab_job", false)
			arg_12_0:refreshItems()
			getChildByPath(var_12_1, "slot_10"):setVisible(false)
			getChildByPath(var_12_1, "slot_private"):setVisible(false)
			if_set_visible(arg_12_0.vars.wnd, "btn_sorting", false)
			if_set_visible(arg_12_0.vars.wnd, "no_data", #arg_12_0.vars.items == 0)
		end
		
		if_set(arg_12_2, "cost", comma_value(arg_12_1.req_gold))
		if_set(getChildByPath(var_12_1, "n_normal/txt_name"), nil, T(arg_12_1.recipe_name))
		if_set(arg_12_2, "txt_material", T(arg_12_1.req_res_desc))
		if_set(arg_12_2:getChildByName("btn_produce"), "label", T("ui_alchemist_popup_btn"))
		
		if arg_12_0.vars.iscatalyst then
			if_set_visible(arg_12_0.vars.wnd, "n_normal", true)
			if_set_visible(arg_12_0.vars.wnd, "n_private", false)
			if_set_visible(arg_12_0.vars.wnd, "n_equip", false)
			UIUtil:getRewardIcon(nil, arg_12_1.icon, {
				no_tooltip = false,
				parent = arg_12_2:getChildByName("n_equip"):getChildByName("n_target")
			})
			UIUtil:getRewardIcon(nil, arg_12_1.icon, {
				no_tooltip = false,
				parent = arg_12_2:getChildByName("n_normal"):getChildByName("n_target")
			})
			if_set(getChildByPath(var_12_1, "n_normal/txt_name"), nil, T(arg_12_1.recipe_name))
			if_set(getChildByPath(var_12_1, "n_equip/txt_name"), nil, T(arg_12_1.recipe_name))
			if_set_visible(arg_12_2, "n_conversion", true)
			if_set(arg_12_0.vars.wnd, "t_set_none", T("ui_alchemist_equip_set_none"))
			arg_12_0:reset_catalystCenterUI()
		elseif not arg_12_0.vars.isExclusive then
			if_set_visible(arg_12_0.vars.wnd, "n_normal", true)
			if_set_visible(arg_12_0.vars.wnd, "n_private", false)
			if_set_visible(arg_12_0.vars.wnd, "n_equip", false)
			UIUtil:getRewardIcon(nil, arg_12_1.icon, {
				no_tooltip = false,
				parent = arg_12_2:getChildByName("n_target")
			})
		else
			if_set_visible(arg_12_0.vars.wnd, "n_normal", false)
			if_set_visible(arg_12_0.vars.wnd, "n_private", true)
			if_set_visible(arg_12_0.vars.wnd, "n_equip", false)
			UIUtil:getRewardIcon(nil, arg_12_1.id, {
				parent = arg_12_2:getChildByName("n_target_private")
			})
			
			var_12_3 = UNIT:create({
				code = arg_12_1.exclusive_unit
			})
			var_12_4 = arg_12_1.exclusive_skill
			var_12_5 = arg_12_0.vars.wnd:getChildByName("n_private")
			
			if_set(var_12_5, "txt_name_private", T(arg_12_1.name))
			
			for iter_12_0 = 1, 3 do
				local var_12_6, var_12_7 = DB("skill_equip", var_12_4 .. "_0" .. iter_12_0, {
					"exc_number",
					"exc_desc"
				})
				local var_12_8 = UIUtil:getSkillIcon(var_12_3, var_12_6, {
					no_tooltip = false,
					exclusive_tooltip = true,
					exclusive_skill = var_12_4 .. "_0" .. iter_12_0,
					show_exclusive_target = iter_12_0
				})
				
				if_set_visible(var_12_8, "soul1", false)
				if_set_visible(var_12_8, "exclusive", true)
				
				local var_12_9 = var_12_5:getChildByName("btn_skill" .. iter_12_0)
				
				if get_cocos_refid(var_12_9) then
					var_12_9:getChildByName("n_skill_icon"):addChild(var_12_8)
				end
				
				if_set_visible(var_12_5, "select" .. iter_12_0, false)
			end
		end
	end
end

local function var_0_2(arg_13_0, arg_13_1, arg_13_2)
	if_set_visible(arg_13_1, "icon_check", false)
	if_set_visible(arg_13_1, "equip", false)
	if_set_visible(arg_13_1, "select", false)
	if_set_visible(arg_13_1, "n_num", false)
	
	local var_13_0 = UIUtil:getRewardIcon(nil, arg_13_2.code, {
		parent = arg_13_1:getChildByName("bg_item")
	})
	
	if arg_13_2.count > 0 then
		UIUserData:call(arg_13_1:getChildByName("t_count"), "SINGLE_WSCALE(91)", {
			origin_scale_x = 0.88
		})
		if_set(arg_13_1, "t_count", arg_13_2.count)
		if_set_visible(arg_13_1, "t_count", true)
		if_set_visible(arg_13_1, "t_none", false)
	else
		if_set_visible(arg_13_1, "t_count", false)
		if_set_visible(arg_13_1, "t_none", true)
		var_13_0:setOpacity(76.5)
	end
	
	local var_13_1, var_13_2, var_13_3 = AlchemistSelect:getStatIcon(arg_13_2.code)
	
	if_set_sprite(arg_13_1, "icon_stat", var_13_1)
	if_set_visible(arg_13_1, "icon_pers", var_13_3)
	if_set(arg_13_1, "t_main_stat", var_13_2)
	
	arg_13_1.datasource = arg_13_2
end

local function var_0_3(arg_14_0, arg_14_1, arg_14_2)
	if_set_visible(arg_14_1, "n_select_equipment", false)
	if_set_visible(arg_14_1, "icon_check_material", false)
	if_set_visible(arg_14_1, "equip", false)
	if_set_visible(arg_14_1, "select_material", false)
	if_set_visible(arg_14_1, "n_num", false)
	if_set_visible(arg_14_1, "icon_type", arg_14_2.isEquip ~= nil)
	if_set_visible(arg_14_1, "n_text_value", arg_14_2.isEquip == nil)
	
	local var_14_0 = arg_14_1:getChildByName("bg_item")
	local var_14_1 = arg_14_1:getChildByName("txt_value")
	local var_14_2 = arg_14_1:getChildByName("n_txt_value")
	local var_14_3 = arg_14_1:getChildByName("n_img_value")
	local var_14_4 = false
	
	for iter_14_0, iter_14_1 in pairs(AlchemistSelect.vars.selectedItems) do
		if iter_14_1 == arg_14_2 or iter_14_1.getUID and iter_14_1:getUID() == arg_14_2:getUID() then
			if_set_visible(arg_14_1, "n_select_equipment", true)
			if_set_visible(arg_14_1, "icon_check_material", true)
			if_set_visible(arg_14_1, "select_material", true)
			
			var_14_4 = true
		end
	end
	
	if arg_14_2 and arg_14_2.code and not arg_14_2.isEquip then
		local var_14_5 = UIUtil:getRewardIcon(nil, arg_14_2.code, {
			tooltip_delay = 130,
			no_detail_popup = true,
			parent = var_14_0
		})
		local var_14_6 = arg_14_2.o_maxcount or arg_14_2.count
		
		if AlchemistSelect.vars.isEuips_alchemyPoint then
			local var_14_7 = cc.c3b(255, 255, 255)
			
			if var_14_4 then
				var_14_6 = arg_14_2.o_maxcount - arg_14_2.count .. "(-" .. arg_14_2.count .. ")"
				var_14_7 = cc.c3b(107, 193, 27)
			end
			
			if_set_color(var_14_2, "txt_value", var_14_7)
		end
		
		if_set(var_14_2, "txt_value", var_14_6)
		if_set_visible(arg_14_1, "n_txt_value", true)
		if_set_visible(arg_14_1, "n_img_value", false)
	else
		if_set_visible(arg_14_1, "n_txt_value", false)
		if_set_visible(arg_14_1, "n_img_value", false)
		
		if arg_14_2.isEquip then
			local var_14_8 = UIUtil:getRewardIcon("equip", arg_14_2.code, {
				tooltip_delay = 130,
				parent = var_14_0,
				equip = arg_14_2
			})
			local var_14_9, var_14_10, var_14_11, var_14_12 = arg_14_2:getMainStat()
			
			if UNIT.is_percentage_stat(var_14_10) then
				var_14_9 = to_var_str(var_14_9, var_14_10)
			else
				var_14_9 = comma_value(math.floor(var_14_9))
			end
			
			local var_14_13 = arg_14_1:getChildByName("icon_type")
			
			if_set_visible(arg_14_1, "icon_type", true)
			if_set_visible(arg_14_1, "n_img_value", true)
			
			if var_14_13 then
				SpriteCache:resetSprite(var_14_13, "img/cm_icon_stat_" .. string.gsub(var_14_10, "_rate", "") .. ".png")
			end
			
			local var_14_14
			
			if arg_14_2:isExclusive() then
				var_14_14 = "right"
			end
			
			if var_14_3 then
				UIUtil:resetImageNumber(var_14_3, var_14_9, {
					align = var_14_14
				})
			end
		end
	end
	
	if AlchemistSelect.vars.isExclusive then
		local var_14_15 = UNIT:create({
			z = 6,
			code = arg_14_2.db.exclusive_unit
		})
		
		SpriteCache:resetSprite(arg_14_1:getChildByName("img_hero_l"), "face/" .. var_14_15.db.face_id .. "_l.png")
		
		local var_14_16 = arg_14_2.op[2][2]
		local var_14_17 = DB("skill_equip", arg_14_2.db.exclusive_skill .. "_0" .. var_14_16, {
			"exc_number"
		})
		local var_14_18 = UIUtil:getSkillIcon(var_14_15, var_14_17, {
			no_tooltip = true,
			show_exclusive_target = var_14_16
		})
		
		if_set_visible(var_14_18, "soul1", false)
		if_set_visible(var_14_18, "exclusive", true)
		arg_14_1:getChildByName("n_skill_icon1"):addChild(var_14_18)
	end
	
	arg_14_1.datasource = arg_14_2
end

function AlchemistSelect.initListViewl(arg_15_0, arg_15_1)
	arg_15_0.vars.listview = ItemListView:bindControl(arg_15_0.vars.listview)
	
	local var_15_0 = {
		onUpdate = var_0_3
	}
	
	arg_15_0.vars.listview_catalyst = ItemListView:bindControl(arg_15_0.vars.listview_catalyst)
	
	local var_15_1
	
	if arg_15_0.vars.isExclusive then
		var_15_1 = load_control("wnd/sanctuary_alchemy_private_card.csb")
	else
		var_15_1 = load_control("wnd/sanctuary_alchemy_material_card.csb")
	end
	
	arg_15_0.vars.listview:setRenderer(var_15_1, var_15_0)
	
	if arg_15_0.vars.iscatalyst then
		local var_15_2 = load_control("wnd/sanctuary_alchemy_conversion_card.csb")
		local var_15_3 = {
			onUpdate = var_0_2
		}
		
		arg_15_0.vars.listview_catalyst:setRenderer(var_15_2, var_15_3)
	end
end

function AlchemistSelect.showCatalystList(arg_16_0)
	if not arg_16_0.vars.iscatalyst then
		return 
	end
	
	if not arg_16_0.vars or not arg_16_0.vars.listview or not arg_16_0.vars.listview_catalyst or arg_16_0.vars.listview_catalyst:isVisible() then
		return 
	end
	
	arg_16_0.vars.listview:setVisible(false)
	arg_16_0.vars.listview_catalyst:setVisible(true)
	if_set(arg_16_0.vars.wnd:getChildByName("no_data"), "label", T("msg_alchemist_no_catalyst_desc"))
	if_set_visible(arg_16_0.vars.wnd, "no_data", #arg_16_0.vars.catalysts == 0)
	if_set_visible(arg_16_0.vars.wnd, "no_data", false)
	UIUtil:playNPCSoundAndTextRandomly("alchemy_equip.select", arg_16_0.vars.wnd, "txt_balloon", 3000, "alchemy_equip.select")
	arg_16_0:reset_catalystCenterUI()
	arg_16_0:checkAutoInsertCheckBox()
end

function AlchemistSelect.updateCenterCatalyst(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("n_conversion")
	local var_17_1 = UIUtil:getRewardIcon(nil, arg_17_1.code, {
		parent = var_17_0:getChildByName("node_conversion")
	})
	
	if_set_visible(var_17_0, "t_count", true)
	
	local var_17_2, var_17_3, var_17_4 = AlchemistSelect:getStatIcon(arg_17_1.code)
	
	if_set_sprite(var_17_0, "icon_stat", var_17_2)
	if_set_visible(var_17_0, "icon_stat", true)
	if_set_visible(var_17_0, "icon_pers", var_17_4)
	if_set(var_17_0, "t_main_stat", var_17_3)
	if_set_visible(arg_17_0.vars.wnd:getChildByName("n_normal"), "txt_conversion_disc", false)
	if_set_visible(arg_17_0.vars.wnd:getChildByName("n_normal"), "txt_conversion_sel", true)
	if_set(arg_17_0.vars.wnd:getChildByName("n_normal"), "txt_conversion_sel", T(arg_17_1.name))
	if_set_opacity(var_17_0, "btn_next", 255)
end

function AlchemistSelect.checkAutoInsertCheckBox(arg_18_0)
	if arg_18_0.vars.iscatalyst and arg_18_0.vars.selectCatalyst then
		arg_18_0:setVisibleAutoInsertCheckBox(true)
	elseif arg_18_0.vars.iscatalyst and not arg_18_0.vars.selectCatalyst then
		arg_18_0:setVisibleAutoInsertCheckBox(false)
	elseif not arg_18_0.vars.iscatalyst and not arg_18_0.vars.isExclusive then
		arg_18_0:setVisibleAutoInsertCheckBox(true)
	end
end

function AlchemistSelect.showItemList(arg_19_0)
	if not arg_19_0.vars.iscatalyst then
		return 
	end
	
	if not arg_19_0.vars or not arg_19_0.vars.listview or not arg_19_0.vars.listview_catalyst then
		return 
	end
	
	if not arg_19_0.vars.selectCatalyst then
		balloon_message_with_sound("msg_alchemist_no_catalyst")
		
		return 
	end
	
	arg_19_0:checkAutoInsertCheckBox()
	UIUtil:playNPCSoundAndTextRandomly("alchemy_equip.craft", arg_19_0.vars.wnd, "txt_balloon", 3000, "alchemy_equip.craft")
	
	local var_19_0 = arg_19_0.vars.wnd:getChildByName("CENTER")
	
	var_19_0:setPositionY(-700)
	UIAction:Add(LOG(MOVE_TO(250, 608, 0)), var_19_0, "block")
	arg_19_0.vars.listview:setVisible(not arg_19_0.vars.listview:isVisible())
	arg_19_0.vars.listview_catalyst:setVisible(not arg_19_0.vars.listview_catalyst:isVisible())
	
	if arg_19_0.vars.listview:isVisible() then
		if_set(arg_19_0.vars.wnd:getChildByName("no_data"), "label", T("msg_alchemist_no_resource"))
		if_set_visible(arg_19_0.vars.wnd, "no_data", #arg_19_0.vars.items == 0)
	elseif arg_19_0.vars.listview_catalyst:isVisible() then
		if_set_visible(arg_19_0.vars.wnd, "no_data", #arg_19_0.vars.catalysts == 0)
	end
	
	if_set_visible(arg_19_0.vars.wnd, "n_normal", false)
	if_set_visible(arg_19_0.vars.wnd, "n_conversion", false)
	if_set_visible(arg_19_0.vars.wnd, "n_equip", true)
	
	local var_19_1 = arg_19_0.vars.wnd:findChildByName("CENTER")
	
	getChildByPath(var_19_1, "slot_5"):setVisible(true)
	
	if get_cocos_refid(arg_19_0.vars.effect_1) then
		arg_19_0.vars.effect_1:setVisible(false)
	end
	
	if get_cocos_refid(arg_19_0.vars.effect_3) then
		arg_19_0.vars.effect_3:removeFromParent()
		
		arg_19_0.vars.effect_3 = nil
	end
	
	arg_19_0.vars.effect_3 = EffectManager:Play({
		fn = "ui_town_alchemy_bg_effect3.cfx",
		layer = arg_19_0.vars.wnd:getChildByName("bg_effect")
	})
	
	if_set_visible(arg_19_0.vars.wnd, "btn_produce", true)
	arg_19_0:checkManufactureButton()
end

function AlchemistSelect.selectItems(arg_20_0, arg_20_1)
	local var_20_0 = {}
	local var_20_1 = {}
	local var_20_2 = UIUtil:getSetItemSortList()
	
	if arg_20_0.vars.isEquips == true then
		for iter_20_0, iter_20_1 in pairs(Account.equips) do
			if not iter_20_1:isArtifact() and not iter_20_1:isStone() and not iter_20_1:isExclusive() and (arg_20_0.tab == 0 or arg_20_0:isCorrectTab(iter_20_1.db.type) or iter_20_1:isCompatibleCategoryStone(arg_20_1.itemType)) and iter_20_1:isUsable() == true then
				local var_20_3 = iter_20_1:clone()
				
				var_20_3.selected = false
				var_20_3.enhance_point = iter_20_1.enhance
				
				table.push(var_20_0, var_20_3)
			end
		end
	elseif arg_20_0.vars.isEuips_alchemyPoint then
		for iter_20_2 = 1, 9999 do
			local var_20_4, var_20_5, var_20_6, var_20_7, var_20_8, var_20_9 = DBN("item_material", iter_20_2, {
				"id",
				"name",
				"ma_type",
				"ma_type2",
				"icon",
				"quality_point"
			})
			
			if not var_20_4 then
				break
			end
			
			if string.split(arg_20_0.vars.cur_itemdata.res_condition, "=")[2] == var_20_6 and string.find(var_20_4, arg_20_1.itemType) and Account:getItemCount(var_20_4) > 0 then
				local var_20_10 = {
					code = var_20_4
				}
				
				var_20_10.count = 1
				var_20_10.o_quality_point = var_20_9
				var_20_10.quality_point = arg_20_0:additional_qualityPoint(var_20_9)
				var_20_10.maxcount = Account:getItemCount(var_20_4)
				var_20_10.o_maxcount = Account:getItemCount(var_20_4)
				var_20_10.selected = false
				var_20_10.set_fx = "set_" .. string.split(var_20_7, ";")[2]
				var_20_10.set_order = var_20_2[var_20_10.set_fx] or 0
				
				table.push(var_20_0, var_20_10)
			end
			
			table.sort(var_20_0, function(arg_21_0, arg_21_1)
				if arg_21_0.maxcount == arg_21_1.maxcount then
					return arg_21_0.set_order > arg_21_1.set_order
				end
				
				return arg_21_0.maxcount > arg_21_1.maxcount
			end)
		end
	elseif arg_20_0.vars.iscatalyst then
		local var_20_11 = string.split(arg_20_0.vars.cur_itemdata.res_condition, ",")
		local var_20_12 = string.split(var_20_11[1], "=")[2]
		local var_20_13 = string.split(var_20_11[2], "=")[2]
		
		for iter_20_3 = 1, 9999 do
			local var_20_14, var_20_15, var_20_16, var_20_17, var_20_18 = DBN("item_material", iter_20_3, {
				"id",
				"name",
				"ma_type",
				"ma_type2",
				"icon"
			})
			
			if not var_20_14 then
				break
			end
			
			if var_20_12 == var_20_16 and arg_20_0:checkExcludeItems(var_20_14) == false then
				local var_20_19 = {
					code = var_20_14,
					name = var_20_15,
					count = Account.items[var_20_14] or 0
				}
				
				var_20_19.iscatalyst = true
				var_20_19.icon = var_20_18
				
				table.push(var_20_1, var_20_19)
			elseif var_20_16 == "alchemypoint" and Account:getItemCount(var_20_14) > 0 and string.find(var_20_14, var_20_13) then
				local var_20_20 = {
					code = var_20_14
				}
				
				var_20_20.count = 1
				var_20_20.o_quality_point = 1
				var_20_20.quality_point = arg_20_0:additional_qualityPoint(1)
				var_20_20.maxcount = Account:getItemCount(var_20_14)
				var_20_20.o_maxcount = Account:getItemCount(var_20_14)
				var_20_20.selected = false
				var_20_20.set_fx = "set_" .. string.split(var_20_17, ";")[2]
				var_20_20.set_order = var_20_2[var_20_20.set_fx] or 0
				
				table.push(var_20_0, var_20_20)
			end
		end
		
		table.sort(var_20_1, function(arg_22_0, arg_22_1)
			return arg_22_0.count > arg_22_1.count
		end)
		table.sort(var_20_0, function(arg_23_0, arg_23_1)
			if arg_23_0.maxcount == arg_23_1.maxcount then
				return arg_23_0.set_order > arg_23_1.set_order
			end
			
			return arg_23_0.maxcount > arg_23_1.maxcount
		end)
	elseif arg_20_0.vars.isExclusive then
		for iter_20_4, iter_20_5 in pairs(Account.equips) do
			if not iter_20_5:isArtifact() and not iter_20_5:isStone() and iter_20_5:isExclusive() and iter_20_5.db.role == arg_20_1.itemType and iter_20_5:isUsable() == true and arg_20_0:isCorrectTab(iter_20_5.db.role) then
				local var_20_21 = iter_20_5:clone()
				
				var_20_21.selected = false
				var_20_21.enhance_point = iter_20_5.enhance
				
				table.push(var_20_0, var_20_21)
			end
		end
	elseif arg_20_0.vars.cur_itemdata.category == "alchemy_change" then
		var_20_0 = arg_20_0:selectItemsChangeStone()
	else
		local var_20_22 = string.split(arg_20_0.vars.cur_itemdata.res_condition, ",")
		local var_20_23 = 999
		
		if var_20_22[2] == nil then
			var_20_22 = string.split(arg_20_0.vars.cur_itemdata.res_condition, "=")
		else
			local var_20_24 = string.split(var_20_22[1], "=")
			local var_20_25 = string.split(var_20_22[2], "=")
			
			var_20_22[2] = var_20_24[2]
			var_20_23 = var_20_25[2]
		end
		
		for iter_20_6, iter_20_7 in pairs(Account.items) do
			local var_20_26, var_20_27, var_20_28, var_20_29 = DB("item_material", iter_20_6, {
				"ma_type",
				"grade",
				"quality_point",
				"sort"
			})
			
			if iter_20_7 > 0 and var_20_26 == var_20_22[2] and iter_20_6 ~= arg_20_0.vars.cur_itemdata.res_exclude and (var_20_22[2] == "material" and tonumber(var_20_23) > tonumber(var_20_27) or var_20_22[2] == "essence") and AlchemistSelect:checkExcludeItems(iter_20_6) == false then
				local var_20_30 = {
					code = iter_20_6
				}
				
				var_20_30.count = 1
				var_20_30.grade = var_20_27
				var_20_30.quality_point = var_20_28
				var_20_30.o_quality_point = var_20_28
				var_20_30.quality_point = arg_20_0:additional_qualityPoint(var_20_30.quality_point)
				var_20_30.maxcount = iter_20_7
				var_20_30.o_maxcount = iter_20_7
				var_20_30.selected = false
				var_20_30.sort = var_20_29
				
				table.push(var_20_0, var_20_30)
			end
		end
		
		if not table.empty(var_20_0) then
			table.sort(var_20_0, function(arg_24_0, arg_24_1)
				if arg_24_0.grade == arg_24_1.grade then
					if arg_24_0.maxcount ~= arg_24_1.maxcount then
						return arg_24_0.maxcount > arg_24_1.maxcount
					else
						return arg_24_0.sort < arg_24_1.sort
					end
				end
				
				return arg_24_0.grade > arg_24_1.grade
			end)
		end
	end
	
	return var_20_0, var_20_1
end

function AlchemistSelect.checkExcludeItems(arg_25_0, arg_25_1)
	if arg_25_1 == nil or not arg_25_0.vars.res_excludes or arg_25_0.vars.res_excludes[1] == nil then
		return false
	end
	
	local var_25_0 = #arg_25_0.vars.res_excludes
	
	for iter_25_0 = 1, var_25_0 do
		if arg_25_1 == arg_25_0.vars.res_excludes[iter_25_0] then
			return true
		end
	end
	
	return false
end

function AlchemistSelect.selectCenterItem(arg_26_0, arg_26_1)
	if arg_26_0.vars.iscatalyst and not arg_26_0.vars.selectCatalyst then
		return 
	end
	
	if arg_26_0.vars.iscatalyst then
		arg_26_0:closeInfoPopup()
	end
	
	AlchemistSelect:selectItem(arg_26_0.vars.selectedItems[arg_26_1], {
		clickCenter = true
	})
	AlchemistSelect:updateCenterSlots()
end

function AlchemistSelect.initAutoInsert(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	arg_27_0.vars.auto_insert = SAVE:getKeep("alchemy_auto_select") or false
	
	arg_27_0:updateAutoInsertCheckBox()
	
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_sel_bulk")
	
	if get_cocos_refid(var_27_0) then
		var_27_0:getChildByName("check_box"):addEventListener(function()
			arg_27_0:toggleAutoInsert()
		end)
	end
end

function AlchemistSelect.toggleAutoInsert(arg_29_0)
	arg_29_0.vars.auto_insert = not arg_29_0.vars.auto_insert
	
	SAVE:setKeep("alchemy_auto_select", arg_29_0.vars.auto_insert)
	arg_29_0:updateAutoInsertCheckBox()
end

function AlchemistSelect.setVisibleAutoInsertCheckBox(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("n_sel_bulk")
	
	if get_cocos_refid(var_30_0) then
		var_30_0:setVisible(arg_30_1)
	end
end

function AlchemistSelect.updateAutoInsertCheckBox(arg_31_0)
	local var_31_0 = arg_31_0.vars.wnd:getChildByName("n_sel_bulk")
	
	if get_cocos_refid(var_31_0) then
		var_31_0:getChildByName("check_box"):setSelected(arg_31_0.vars.auto_insert)
	end
end

function AlchemistSelect.isAutoInsert(arg_32_0)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	if arg_32_0.vars.isExclusive or arg_32_0.vars.iscatalyst and not arg_32_0.vars.selectCatalyst then
		return 
	end
	
	return arg_32_0.vars.auto_insert
end

function AlchemistSelect.selectItem(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_1 == nil or not arg_33_0.vars.listview then
		return 
	end
	
	arg_33_2 = arg_33_2 or {}
	
	local var_33_0 = arg_33_0.vars.listview:getControl(arg_33_1)
	local var_33_1 = true
	local var_33_2 = arg_33_2.blockChange
	local var_33_3 = arg_33_2.blockCount
	local var_33_4 = arg_33_2.clickCenter
	local var_33_5 = arg_33_1.iscatalyst
	local var_33_6
	
	if var_33_5 then
		var_33_0 = arg_33_0.vars.listview_catalyst:getControl(arg_33_1)
	end
	
	if not var_33_0 then
		if var_33_5 then
			for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.listview.vars.controls) do
				if get_cocos_refid(iter_33_0) and iter_33_1.item:getUID() == arg_33_1:getUID() then
					var_33_0 = iter_33_0
					arg_33_1 = iter_33_1.item
					
					break
				end
			end
		elseif arg_33_0.vars.isEuips_alchemyPoint then
			for iter_33_2, iter_33_3 in pairs(arg_33_0.vars.listview.vars.controls) do
				if iter_33_3.item.code == arg_33_1.code then
					var_33_0 = iter_33_2
					arg_33_1 = iter_33_3.item
					
					break
				end
			end
		end
	end
	
	if var_33_2 == nil then
		var_33_1 = not arg_33_1.selected
		
		if #arg_33_0.vars.selectedItems >= arg_33_0.vars.itemMax_count and var_33_1 == true and not var_33_5 then
			balloon_message_with_sound("msg_alchemist_no_slot")
			
			return 
		end
		
		if arg_33_1.quality_point ~= nil and var_33_1 == true and arg_33_0.vars.qualityPoint >= arg_33_0.vars.qualityPoint_max and not var_33_5 then
			balloon_message_with_sound("msg_alchemist_no_slot")
			
			return 
		end
		
		if var_33_1 == true then
			if arg_33_0:calcEQUIPQuality(arg_33_1, true) == true then
				if not var_33_5 then
					table.insert(arg_33_0.vars.selectedItems, arg_33_1)
				end
			else
				return 
			end
		elseif not var_33_5 then
			for iter_33_4, iter_33_5 in pairs(arg_33_0.vars.selectedItems) do
				if iter_33_5 == arg_33_1 or iter_33_5.getUID and iter_33_5:getUID() == arg_33_1:getUID() then
					arg_33_0:calcEQUIPQuality(arg_33_1, false)
					
					if not var_33_3 then
						arg_33_0:calcOtherQuality(iter_33_5, false)
					end
					
					if iter_33_5.count then
						var_33_6 = iter_33_5
						
						if_set(var_33_0, "txt_value", iter_33_5.o_maxcount)
						if_set_color(var_33_0, "txt_value", cc.c3b(255, 255, 255))
					end
					
					table.remove(arg_33_0.vars.selectedItems, iter_33_4)
				end
			end
		end
	end
	
	if var_33_5 and arg_33_0.vars.selectCatalyst == arg_33_1 then
		var_33_1 = true
	end
	
	arg_33_1.selected = var_33_1
	
	if not var_33_0 then
		return 
	end
	
	if_set_visible(var_33_0, "icon_check_material", var_33_1)
	if_set_visible(var_33_0, "select_material", var_33_1)
	
	if var_33_5 then
		if_set_visible(var_33_0, "select", var_33_1)
		if_set_visible(var_33_0, "icon_check", var_33_1)
	end
	
	if arg_33_0.vars.isEquips == true or arg_33_0.vars.isExclusive or var_33_5 then
		if_set_visible(var_33_0, "n_select_equipment", var_33_1)
		arg_33_0:updateCenterSlots()
	else
		if_set_visible(var_33_0, "n_select_equipment", false)
		
		if arg_33_1.selected == true then
			if arg_33_0:isAutoInsert() then
				local var_33_7 = arg_33_0:calcUsableMaxCount(arg_33_1)
				
				arg_33_1.count = var_33_7
				
				if arg_33_0:calcOtherQuality(arg_33_1, true) then
					arg_33_0:updateCenterSlots()
					
					local var_33_8 = arg_33_0.vars.listview:getControl(arg_33_1)
					
					if_set(var_33_8, "txt_value", arg_33_1.o_maxcount - var_33_7 .. "(-" .. var_33_7 .. ")")
					if_set_color(var_33_8, "txt_value", cc.c3b(107, 193, 27))
				end
			else
				arg_33_0:openCountPopup(arg_33_1)
			end
		else
			if var_33_4 == false then
				if AlchemistSelect:isAutoInsert() and arg_33_1 and arg_33_1.selected then
					Log.e("Err: wrong logic")
					
					return 
				else
					AlchemistSelect:selectItem(arg_33_1)
				end
			elseif var_33_6 ~= nil then
				var_33_6.count = 1
			end
			
			arg_33_0:updateCenterSlots()
		end
	end
end

function AlchemistSelect.unSelectCatalyst(arg_34_0)
	if not arg_34_0.vars or not arg_34_0.vars.selectCatalyst then
		return 
	end
	
	local var_34_0 = arg_34_0.vars.listview_catalyst:getControl(arg_34_0.vars.selectCatalyst)
	
	if var_34_0 then
		if_set_visible(var_34_0, "select", false)
		if_set_visible(var_34_0, "icon_check", false)
		
		if var_34_0.datasource then
			var_34_0.datasource.selected = false
		end
	end
	
	arg_34_0.vars.wnd:getChildByName("n_equip"):getChildByName("n_item_catalyst"):removeAllChildren()
	
	arg_34_0.vars.selectCatalyst = nil
	
	arg_34_0:closeInfoPopup()
	arg_34_0:checkManufactureButton()
end

function AlchemistSelect.changePreCatalystUI(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not arg_35_0.vars.selectCatalyst or not arg_35_1 then
		arg_35_0.vars.wnd:getChildByName("n_equip"):getChildByName("n_item_catalyst"):removeAllChildren()
		
		return 
	end
	
	if not arg_35_0.vars.selectCatalyst or arg_35_0.vars.selectCatalyst == arg_35_1 then
		return 
	end
	
	local var_35_0 = arg_35_0.vars.listview_catalyst:getControl(arg_35_0.vars.selectCatalyst)
	
	if var_35_0 then
		if_set_visible(var_35_0, "select", false)
		if_set_visible(var_35_0, "icon_check", false)
		
		if var_35_0.datasource.selected then
			var_35_0.datasource.selected = false
		end
	end
	
	arg_35_0.vars.selectCatalyst = nil
end

function AlchemistSelect.getStatIcon(arg_36_0, arg_36_1)
	if not arg_36_1 then
		return 
	end
	
	local var_36_0 = string.find(arg_36_1, "att_rate") or string.find(arg_36_1, "def_rate") or string.find(arg_36_1, "max_hp_rate")
	local var_36_1 = "ui_equip_base_stat_filter_"
	
	if string.find(arg_36_1, "att") or string.find(arg_36_1, "att_rate") then
		arg_36_1 = "att"
		var_36_1 = var_36_1 .. "att"
	elseif string.find(arg_36_1, "def") or string.find(arg_36_1, "def_rate") then
		arg_36_1 = "def"
		var_36_1 = var_36_1 .. "def"
	elseif string.find(arg_36_1, "max_hp") or string.find(arg_36_1, "max_hp_rate") then
		arg_36_1 = "max_hp"
		var_36_1 = var_36_1 .. "max_hp"
	elseif string.find(arg_36_1, "speed") then
		arg_36_1 = "speed"
		var_36_1 = var_36_1 .. "speed"
	elseif string.find(arg_36_1, "cri_dmg") then
		arg_36_1 = "cri_dmg"
		var_36_1 = var_36_1 .. "cri_dmg"
	elseif string.find(arg_36_1, "cri") then
		arg_36_1 = "cri"
		var_36_1 = var_36_1 .. "cri"
	elseif string.find(arg_36_1, "acc") then
		arg_36_1 = "acc"
		var_36_1 = var_36_1 .. "acc"
	elseif string.find(arg_36_1, "res") then
		arg_36_1 = "res"
		var_36_1 = var_36_1 .. "res"
	end
	
	local var_36_2 = "img/icon_menu_" .. arg_36_1 .. ".png"
	
	if var_36_0 then
		var_36_1 = var_36_1 .. "_rate"
	end
	
	return var_36_2, T(var_36_1), var_36_0
end

function AlchemistSelect.calcEQUIPQuality(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars.cur_itemdata or arg_37_0.vars.cur_itemdata == nil then
		return true
	end
	
	if arg_37_1.iscatalyst then
		arg_37_0:changePreCatalystUI(arg_37_1)
		
		arg_37_0.vars.selectCatalyst = arg_37_1
		
		local var_37_0 = arg_37_0.vars.wnd:getChildByName("n_equip")
		local var_37_1 = UIUtil:getRewardIcon(nil, arg_37_1.icon, {
			no_tooltip = false,
			no_name = true,
			parent = var_37_0:getChildByName("n_item_catalyst")
		})
		local var_37_2, var_37_3, var_37_4 = arg_37_0:getStatIcon(arg_37_1.code)
		local var_37_5 = var_37_0:getChildByName("t_main_stat")
		
		if_set_sprite(var_37_5, "icon_stat", var_37_2)
		if_set_visible(var_37_5, "icon_pers", var_37_4)
		if_set(var_37_5, nil, var_37_3)
		if_set_visible(var_37_0, "n_stat", true)
		
		local var_37_6 = arg_37_0.vars.wnd:findChildByName("CENTER")
		
		getChildByPath(var_37_6, "slot_5"):setOpacity(255)
		
		return true
	end
	
	if arg_37_0.vars.isEquips or arg_37_0.vars.isExclusive then
		local var_37_7 = 0
		local var_37_8 = arg_37_1.db.tier
		local var_37_9 = arg_37_1.grade
		local var_37_10, var_37_11, var_37_12, var_37_13, var_37_14, var_37_15 = DB("alchemy_equip_quality", "equip_tier_" .. var_37_8, {
			"grade1",
			"grade2",
			"grade3",
			"grade4",
			"grade5",
			"enchant_bonus"
		})
		
		if var_37_9 == 1 then
			var_37_7 = var_37_7 + var_37_10 + arg_37_1.enhance_point * var_37_15
		elseif var_37_9 == 2 then
			var_37_7 = var_37_7 + var_37_11 + arg_37_1.enhance_point * var_37_15
		elseif var_37_9 == 3 then
			var_37_7 = var_37_7 + var_37_12 + arg_37_1.enhance_point * var_37_15
		elseif var_37_9 == 4 then
			var_37_7 = var_37_7 + var_37_13 + arg_37_1.enhance_point * var_37_15
		elseif var_37_9 == 5 then
			var_37_7 = var_37_7 + var_37_14 + arg_37_1.enhance_point * var_37_15
		end
		
		local var_37_16 = arg_37_0:additional_qualityPoint(var_37_7)
		
		if arg_37_2 then
			if arg_37_0.vars.qualityPoint < arg_37_0.vars.qualityPoint_max and arg_37_0.vars.qualityPoint + var_37_16 > arg_37_0.vars.qualityPoint_max then
				arg_37_0.vars.qualityPoint = arg_37_0.vars.qualityPoint + var_37_16
			elseif arg_37_0.vars.qualityPoint + var_37_16 > arg_37_0.vars.qualityPoint_max then
				balloon_message_with_sound("msg_alchemist_quality_limit")
				
				return false
			else
				arg_37_0.vars.qualityPoint = arg_37_0.vars.qualityPoint + var_37_16
			end
		elseif arg_37_0.vars.qualityPoint - var_37_16 < 0 then
			arg_37_0.vars.qualityPoint = 0
			
			return false
		else
			arg_37_0.vars.qualityPoint = arg_37_0.vars.qualityPoint - var_37_16
		end
		
		if arg_37_0.vars.isExclusive then
			local var_37_17 = arg_37_0.vars.wnd:getChildByName("n_private")
			
			if arg_37_0.vars.qualityPoint >= arg_37_0.vars.qualityPoint_max then
				arg_37_0:select_exclusiveSkill(1)
			else
				arg_37_0:select_exclusiveSkill(0)
				
				arg_37_0.vars.selected_skill = nil
			end
		end
		
		arg_37_0:updateQuality_progBar()
	end
	
	return true
end

function AlchemistSelect.calcOtherQuality(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars.cur_itemdata or arg_38_0.vars.cur_itemdata == nil or arg_38_0.vars.isEquips or arg_38_0.vars.isExclusive or arg_38_1.iscatalyst then
		return 
	end
	
	if not arg_38_1.quality_point or arg_38_1.quality_point == nil then
		Log.e("잘못된 데이터")
	end
	
	local var_38_0 = arg_38_1.quality_point * 10 * arg_38_1.count / 10
	
	if arg_38_2 then
		if arg_38_0.vars.qualityPoint < arg_38_0.vars.qualityPoint_max and arg_38_0.vars.qualityPoint + var_38_0 > arg_38_0.vars.qualityPoint_max then
			arg_38_0.vars.qualityPoint = arg_38_0.vars.qualityPoint + var_38_0
		elseif arg_38_0.vars.qualityPoint + var_38_0 > arg_38_0.vars.qualityPoint_max then
			balloon_message_with_sound("msg_alchemist_quality_limit")
			
			return false
		else
			arg_38_0.vars.qualityPoint = arg_38_0.vars.qualityPoint + var_38_0
		end
	elseif arg_38_0.vars.qualityPoint - var_38_0 < 0 then
		arg_38_0.vars.qualityPoint = 0
		
		return false
	else
		arg_38_0.vars.qualityPoint = arg_38_0.vars.qualityPoint - var_38_0
	end
	
	arg_38_0:updateQuality_progBar()
	
	return true
end

function AlchemistSelect.updateQuality_progBar(arg_39_0)
	local var_39_0 = arg_39_0.vars.wnd:getChildByName("n_quality")
	local var_39_1 = var_39_0:findChildByName("progress_bar")
	
	if_set_percent(var_39_1, nil, arg_39_0.vars.qualityPoint / arg_39_0.vars.qualityPoint_max)
	
	local var_39_2 = arg_39_0.vars.qualityPoint / arg_39_0.vars.qualityPoint_max * 100
	
	if var_39_2 >= 100 then
		if_set_color(var_39_1, nil, cc.c3b(255, 180, 0))
		arg_39_0.vars.n_no:setVisible(false)
		if_set_visible(var_39_0, "n_possible", false)
		if_set_visible(var_39_0, "n_high", false)
		if_set_visible(var_39_0, "n_super", true)
		if_set(var_39_0:getChildByName("n_super"), "disc", T("ui_alchemist_quality_grade4"))
		
		if arg_39_0.vars.curQuality ~= 3 then
			arg_39_0.vars.curQuality = 3
			
			UIUtil:playNPCSoundAndTextRandomly("alchemy.epic", arg_39_0.vars.wnd, "txt_balloon", 3000, "alchemy.epic")
		end
	elseif var_39_2 < arg_39_0.vars.quality_standard[1] / arg_39_0.vars.qualityPoint_max * 100 then
		if_set_color(var_39_1, nil, cc.c3b(99, 99, 99))
		arg_39_0.vars.n_no:setVisible(true)
		if_set_visible(var_39_0, "n_possible", false)
		if_set_visible(var_39_0, "n_high", false)
		if_set_visible(var_39_0, "n_super", false)
		if_set(arg_39_0.vars.n_no, "disc", T("ui_alchemist_quality_grade1"))
		
		if arg_39_0.vars.curQuality ~= 0 then
			arg_39_0.vars.curQuality = 0
			
			UIUtil:playNPCSoundAndTextRandomly("alchemy.idle", arg_39_0.vars.wnd, "txt_balloon", 3000, "alchemy.idle")
		end
	elseif var_39_2 < arg_39_0.vars.quality_standard[2] / arg_39_0.vars.qualityPoint_max * 100 then
		if_set_color(var_39_1, nil, cc.c3b(134, 81, 231))
		arg_39_0.vars.n_no:setVisible(false)
		if_set_visible(var_39_0, "n_possible", true)
		if_set_visible(var_39_0, "n_high", false)
		if_set_visible(var_39_0, "n_super", false)
		if_set(var_39_0:getChildByName("n_possible"), "disc", T("ui_alchemist_quality_grade2"))
		
		if arg_39_0.vars.curQuality ~= 1 then
			arg_39_0.vars.curQuality = 1
			
			UIUtil:playNPCSoundAndTextRandomly("alchemy.lesser", arg_39_0.vars.wnd, "txt_balloon", 3000, "alchemy.lesser")
		end
	elseif var_39_2 < arg_39_0.vars.quality_standard[3] / arg_39_0.vars.qualityPoint_max * 100 then
		if_set_color(var_39_1, nil, cc.c3b(20, 151, 211))
		arg_39_0.vars.n_no:setVisible(false)
		if_set_visible(var_39_0, "n_possible", false)
		if_set_visible(var_39_0, "n_high", true)
		if_set_visible(var_39_0, "n_super", false)
		if_set(var_39_0:getChildByName("n_high"), "disc", T("ui_alchemist_quality_grade3"))
		
		if arg_39_0.vars.curQuality ~= 2 then
			arg_39_0.vars.curQuality = 2
			
			UIUtil:playNPCSoundAndTextRandomly("alchemy.good", arg_39_0.vars.wnd, "txt_balloon", 3000, "alchemy.good")
		end
	end
	
	if arg_39_0.vars.cur_itemdata.category == "alchemy_change" then
		arg_39_0:updateQualityChangeStone()
	end
	
	arg_39_0:checkManufactureButton()
end

function AlchemistSelect.checkManufactureButton(arg_40_0)
	if arg_40_0.vars.cur_itemdata == nil then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.cur_itemdata.req_gold
	local var_40_1 = Account:getPropertyCount("gold")
	local var_40_2 = tonumber(arg_40_0.vars.quality_standard[1]) <= arg_40_0.vars.qualityPoint
	local var_40_3 = var_40_0 <= var_40_1
	local var_40_4 = arg_40_0.vars.cur_itemdata.category ~= "alchemy_change" or arg_40_0.vars.curQuality ~= 3 or arg_40_0.vars.select_change_stone_stat ~= nil
	local var_40_5 = var_40_2 and var_40_3 and var_40_4 and 255 or 76.5
	
	if_set_opacity(arg_40_0.vars.wnd, "btn_produce", var_40_5)
	
	if arg_40_0.vars.iscatalyst and not arg_40_0.vars.selectCatalyst then
		if_set_opacity(arg_40_0.vars.wnd, "btn_produce", 76.5)
	end
end

function AlchemistSelect.setProgressPos(arg_41_0)
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_quality")
	local var_41_1 = arg_41_0.vars.quality_standard[1] / arg_41_0.vars.qualityPoint_max * 100
	local var_41_2 = arg_41_0.vars.quality_standard[2] / arg_41_0.vars.qualityPoint_max * 100
	local var_41_3 = var_41_0:getChildByName("Img_dot_2"):getPositionX() - var_41_0:getChildByName("Img_dot"):getPositionX()
	local var_41_4 = var_41_0:getChildByName("Img_dot"):getPositionX()
	local var_41_5 = var_41_3 / 100 * var_41_1 + var_41_4
	local var_41_6 = var_41_0:getChildByName("n_no")
	local var_41_7 = var_41_0:getChildByName("n_no_50")
	local var_41_8 = var_41_0:getChildByName("Img_dot_0")
	
	arg_41_0.vars.n_no = var_41_6
	
	var_41_0:getChildByName("icon_1"):setPositionX(var_41_5)
	var_41_8:setPositionX(var_41_5)
	var_41_0:getChildByName("n_possible"):setPositionX(var_41_5 - 0.5)
	
	if var_41_1 >= 50 then
		local var_41_9 = (var_41_8:getPositionX() - var_41_7:getPositionX()) / 2
		
		var_41_7:setPositionX(var_41_9)
		var_41_6:setVisible(false)
		var_41_7:setVisible(true)
		
		arg_41_0.vars.n_no = var_41_7
	end
	
	local var_41_10 = var_41_3 / 100 * var_41_2 + var_41_4
	
	var_41_0:getChildByName("icon_2"):setPositionX(var_41_10)
	var_41_0:getChildByName("Img_dot_1"):setPositionX(var_41_10)
	var_41_0:getChildByName("n_high"):setPositionX(var_41_10 - 1.5)
end

function AlchemistSelect.calcUsableMaxCount(arg_42_0, arg_42_1)
	if not arg_42_1 then
		return 
	end
	
	local var_42_0 = arg_42_1.o_maxcount * arg_42_1.quality_point
	local var_42_1 = 1
	
	if arg_42_0.vars.qualityPoint + var_42_0 > arg_42_0.vars.qualityPoint_max then
		local var_42_2 = 0
		
		for iter_42_0 = 1, arg_42_1.o_maxcount do
			local var_42_3 = arg_42_1.quality_point * var_42_1
			
			if arg_42_0.vars.qualityPoint + var_42_3 >= arg_42_0.vars.qualityPoint_max then
				break
			else
				var_42_1 = var_42_1 + 1
			end
		end
	else
		return arg_42_1.o_maxcount
	end
	
	return var_42_1
end

function AlchemistSelect.openCountPopup(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.vars.wnd
	
	arg_43_0.vars.curmat = arg_43_1
	arg_43_0.vars.count_wnd = load_dlg("sanctuary_alchemy_quantity", true, "wnd", function()
		AlchemistSelect:closeCountPopup()
	end)
	
	SanctuaryMain.vars.wnd:addChild(arg_43_0.vars.count_wnd, 9999998)
	arg_43_0.vars.count_wnd:bringToFront()
	
	arg_43_0.vars.curmat.maxcount = arg_43_0.vars.curmat.o_maxcount
	
	local var_43_1 = arg_43_0.vars.curmat.o_maxcount * arg_43_0.vars.curmat.quality_point
	local var_43_2
	
	if arg_43_0.vars.qualityPoint + var_43_1 > arg_43_0.vars.qualityPoint_max then
		var_43_2 = 1
		
		local var_43_3 = 0
		
		for iter_43_0 = 1, arg_43_0.vars.curmat.o_maxcount do
			local var_43_4 = arg_43_0.vars.curmat.quality_point * var_43_2
			
			if arg_43_0.vars.qualityPoint + var_43_4 >= arg_43_0.vars.qualityPoint_max then
				arg_43_0.vars.curmat.maxcount = var_43_2
				
				break
			else
				var_43_2 = var_43_2 + 1
			end
		end
	end
	
	if arg_43_0.vars.curmat.maxcount == 0 then
		arg_43_0.vars.curmat.maxcount = 1
	end
	
	local function var_43_5(arg_45_0, arg_45_1, arg_45_2)
		local var_45_0 = arg_43_0.vars.curmat.maxcount / 1
		
		arg_43_0.vars.curmat.count = arg_45_1 * 1
		
		arg_43_0:updateCountPopup()
	end
	
	local var_43_6 = arg_43_0.vars.count_wnd:getChildByName("slider")
	
	var_43_6:addEventListener(Dialog.defaultSliderEventHandler)
	
	var_43_6.handler = var_43_5
	var_43_6.slider_pos = arg_43_0.vars.curmat.count
	var_43_6.min = 1
	var_43_6.max = arg_43_0.vars.curmat.maxcount / 1
	
	var_43_6:setMaxPercent(var_43_6.max)
	var_43_6:setPercent(arg_43_0.vars.curmat.count)
	
	var_43_6.parent = arg_43_0.vars.count_wnd
	
	var_43_6.handler(arg_43_0.vars.count_wnd, arg_43_0.vars.curmat.count or 0, 0)
	
	arg_43_0.vars.slider = var_43_6
end

function AlchemistSelect.updateCountPopup(arg_46_0)
	if_set(arg_46_0.vars.count_wnd, "t_count", arg_46_0.vars.curmat.count .. "/" .. arg_46_0.vars.curmat.maxcount)
end

function AlchemistSelect.plus(arg_47_0)
	if arg_47_0.vars.curmat.count + 1 > arg_47_0.vars.curmat.maxcount then
		return 
	end
	
	arg_47_0.vars.curmat.count = arg_47_0.vars.curmat.count + 1
	
	arg_47_0.vars.slider:setPercent(arg_47_0.vars.slider:getPercent() + 1)
	Dialog.defaultSliderEventHandler(arg_47_0.vars.slider, 2)
	arg_47_0:updateCountPopup()
end

function AlchemistSelect.minus(arg_48_0)
	if arg_48_0.vars.curmat.count - 1 < 1 then
		return 
	end
	
	arg_48_0.vars.curmat.count = arg_48_0.vars.curmat.count - 1
	
	arg_48_0.vars.slider:setPercent(arg_48_0.vars.slider:getPercent() - 1)
	Dialog.defaultSliderEventHandler(arg_48_0.vars.slider, 2)
	arg_48_0:updateCountPopup()
end

function AlchemistSelect.min(arg_49_0)
	arg_49_0.vars.curmat.count = 1
	
	arg_49_0.vars.slider:setPercent(arg_49_0.vars.slider.min)
	Dialog.defaultSliderEventHandler(arg_49_0.vars.slider, 2)
	arg_49_0:updateCountPopup()
end

function AlchemistSelect.max(arg_50_0)
	arg_50_0.vars.curmat.count = arg_50_0.vars.curmat.maxcount
	
	arg_50_0.vars.slider:setPercent(arg_50_0.vars.slider.max)
	arg_50_0:updateCountPopup()
end

function AlchemistSelect.closeCountPopup(arg_51_0, arg_51_1)
	if not arg_51_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_51_0.vars.count_wnd) then
		BackButtonManager:pop("sanctuary_alchemy_quantity")
		arg_51_0.vars.count_wnd:removeFromParent()
		
		arg_51_0.vars.count_wnd = nil
	end
	
	if arg_51_1 and arg_51_1 == "btn_go" and arg_51_0:calcOtherQuality(arg_51_0.vars.curmat, true) == true then
		arg_51_0:updateCenterSlots()
		
		local var_51_0 = arg_51_0.vars.listview:getControl(arg_51_0.vars.curmat)
		
		if arg_51_0.vars.curmat.count == arg_51_0.vars.curmat.o_maxcount then
			if_set_visible(var_51_0, "n_select_equipment", true)
		end
		
		if_set(var_51_0, "txt_value", arg_51_0.vars.curmat.o_maxcount - arg_51_0.vars.curmat.count .. "(-" .. arg_51_0.vars.curmat.count .. ")")
		if_set_color(var_51_0, "txt_value", cc.c3b(107, 193, 27))
	else
		arg_51_0:selectItem(arg_51_0.vars.curmat, {
			blockCount = true
		})
	end
	
	arg_51_0.vars.curmat = nil
end

function AlchemistSelect.updateCenterSlots(arg_52_0)
	if arg_52_0.vars.cur_itemdata.category == "alchemy_change" then
		arg_52_0:updateCenterSlotChangeStone()
	else
		local var_52_0 = arg_52_0.vars.wnd:findChildByName("CENTER")
		local var_52_7, var_52_10
		
		if arg_52_0.vars.isEquips then
			local var_52_1 = getChildByPath(var_52_0, "slot_10")
			
			for iter_52_0 = 1, 10 do
				var_52_1:getChildByName("node_" .. iter_52_0):removeAllChildren()
			end
			
			local var_52_2 = 1
			
			for iter_52_1, iter_52_2 in pairs(arg_52_0.vars.selectedItems) do
				local var_52_3 = var_52_1:getChildByName("node_" .. var_52_2)
				
				var_52_3:removeAllChildren()
				
				UIUtil:getRewardIcon("equip", iter_52_2.code, {
					no_detail_popup = true,
					tooltip_delay = 130,
					parent = var_52_3,
					equip = iter_52_2
				}).item = iter_52_2
				var_52_2 = var_52_2 + 1
			end
		elseif arg_52_0.vars.isExclusive then
			local var_52_4 = getChildByPath(var_52_0, "slot_private")
			
			for iter_52_3 = 1, 8 do
				var_52_4:getChildByName("node_" .. iter_52_3):removeAllChildren()
			end
			
			local var_52_5 = 1
			
			for iter_52_4, iter_52_5 in pairs(arg_52_0.vars.selectedItems) do
				local var_52_6 = var_52_4:getChildByName("node_" .. var_52_5)
				
				var_52_6:removeAllChildren()
				
				UIUtil:getRewardIcon("equip", iter_52_5.code, {
					no_detail_popup = true,
					tooltip_delay = 130,
					parent = var_52_6,
					equip = iter_52_5
				}).item = iter_52_5
				var_52_5 = var_52_5 + 1
			end
		else
			var_52_7 = getChildByPath(var_52_0, "slot_5")
			
			for iter_52_6 = 1, 5 do
				local var_52_8 = var_52_7:getChildByName("node_" .. iter_52_6)
				local var_52_9 = var_52_7:getChildByName("slot_" .. iter_52_6)
				
				if_set_visible(var_52_9, "t_count", false)
				var_52_8:removeAllChildren()
			end
			
			var_52_10 = 1
			
			for iter_52_7, iter_52_8 in pairs(arg_52_0.vars.selectedItems) do
				local var_52_11 = var_52_7:getChildByName("node_" .. var_52_10)
				local var_52_12 = var_52_7:getChildByName("slot_" .. var_52_10)
				
				var_52_11:removeAllChildren()
				
				local var_52_13 = UIUtil:getRewardIcon(nil, iter_52_8.code, {
					no_detail_popup = true,
					parent = var_52_11
				})
				
				if_set_visible(var_52_12, "t_count", true)
				if_set(var_52_12, "t_count", iter_52_8.count)
				
				var_52_13.item = iter_52_8
				var_52_10 = var_52_10 + 1
			end
		end
		
		if arg_52_0.vars.iscatalyst then
			arg_52_0:updateCatalystCenterInfo()
		end
	end
end

function AlchemistSelect.updateCatalystCenterInfo(arg_53_0)
	arg_53_0.vars.item_sets = {}
	
	local var_53_0 = arg_53_0.vars.wnd:getChildByName("n_equip")
	
	if #arg_53_0.vars.selectedItems <= 0 then
		if_set_visible(var_53_0, "n_none", true)
		if_set_visible(var_53_0, "n_item_set", false)
		if_set_visible(var_53_0, "btn_item_set_tooltip", false)
		
		return 
	end
	
	if_set_visible(var_53_0, "n_none", false)
	if_set_visible(var_53_0, "n_item_set", true)
	if_set_visible(var_53_0, "btn_item_set_tooltip", true)
	
	local var_53_1 = false
	local var_53_2 = 0
	
	arg_53_0:calcItemSetInfo()
	
	if arg_53_0:setCatalyst_setIcon() >= 2 then
		var_53_1 = true
	end
	
	if_set_visible(var_53_0, "btn_item_set_tooltip", var_53_1)
end

function AlchemistSelect.calcItemSetInfo(arg_54_0)
	local var_54_0 = {}
	local var_54_1 = {}
	local var_54_2 = UIUtil:getSetItemNameList()
	local var_54_3 = UIUtil:getSetItemSortList()
	
	for iter_54_0, iter_54_1 in pairs(var_54_2) do
		var_54_0[iter_54_1] = false
		var_54_1[iter_54_1] = 0
	end
	
	local var_54_4 = 0
	
	for iter_54_2, iter_54_3 in pairs(arg_54_0.vars.selectedItems) do
		if var_54_0[iter_54_3.set_fx] ~= nil then
			var_54_0[iter_54_3.set_fx] = true
			var_54_1[iter_54_3.set_fx] = iter_54_3.count
			var_54_4 = var_54_4 + iter_54_3.count
		end
	end
	
	local var_54_5 = {}
	
	for iter_54_4, iter_54_5 in pairs(var_54_1) do
		local var_54_6 = {
			set = iter_54_4,
			count = iter_54_5
		}
		
		table.insert(var_54_5, var_54_6)
	end
	
	table.sort(var_54_5, function(arg_55_0, arg_55_1)
		if arg_55_0.count == arg_55_1.count then
			return var_54_3[arg_55_0.set] < var_54_3[arg_55_1.set]
		end
		
		return arg_55_0.count > arg_55_1.count
	end)
	
	local var_54_7 = {}
	
	for iter_54_6, iter_54_7 in pairs(var_54_5) do
		var_54_7[iter_54_7.set] = iter_54_7.count
	end
	
	local var_54_8 = var_54_4
	
	for iter_54_8, iter_54_9 in pairs(var_54_5) do
		if iter_54_9.count > 0 then
			iter_54_9.percent = round(iter_54_9.count / var_54_8 * 100, 1)
		else
			iter_54_9.percent = 0
		end
	end
	
	arg_54_0.vars.item_sets = var_54_5
end

function AlchemistSelect.setCatalyst_setIcon(arg_56_0)
	if not arg_56_0.vars or not arg_56_0.vars.item_sets then
		return 
	end
	
	local var_56_0 = arg_56_0.vars.item_sets
	local var_56_1 = 0
	local var_56_2 = arg_56_0.vars.wnd:getChildByName("n_equip")
	
	for iter_56_0, iter_56_1 in pairs(var_56_0) do
		if var_56_1 >= 2 then
			break
		end
		
		if iter_56_1.count > 0 then
			if var_56_1 == 0 then
				if_set_visible(var_56_2, "n_set_only_one", true)
				if_set_visible(var_56_2, "n_set_top2", false)
				if_set_sprite(var_56_2:getChildByName("n_set_only_one"), "set_icon1", EQUIP:getSetItemIconPath(iter_56_1.set))
				if_set_sprite(var_56_2:getChildByName("n_set_top2"), "set_icon1", EQUIP:getSetItemIconPath(iter_56_1.set))
				if_set(var_56_2:getChildByName("n_set_only_one"), "t_set_icon1_percent", iter_56_1.percent .. "%")
				if_set(var_56_2:getChildByName("n_set_top2"), "t_set_icon1_percent", iter_56_1.percent .. "%")
			else
				if_set_visible(var_56_2, "n_set_only_one", false)
				if_set_visible(var_56_2, "n_set_top2", true)
				if_set_sprite(var_56_2:getChildByName("n_set_top2"), "set_icon2", EQUIP:getSetItemIconPath(iter_56_1.set))
				if_set(var_56_2:getChildByName("n_set_top2"), "t_set_icon2_percent", iter_56_1.percent .. "%")
			end
			
			var_56_1 = var_56_1 + 1
		end
	end
	
	return var_56_1
end

function AlchemistSelect.toggleInfoPopup(arg_57_0, arg_57_1)
	if not arg_57_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_57_0.vars.setInfoPopup) then
		arg_57_0:openInfoPopup(arg_57_1)
	else
		arg_57_0:closeInfoPopup()
	end
end

function AlchemistSelect.setInfoPopup_tooltip(arg_58_0, arg_58_1)
	if not arg_58_0.vars or not get_cocos_refid(arg_58_0.vars.wnd) then
		return 
	end
	
	if arg_58_1 == 1 then
		WidgetUtils:setupTooltip({
			delay = 0,
			control = arg_58_0.vars.wnd:getChildByName("btn_item_set_tooltip"),
			creator = function()
				return AlchemistSelect:openInfoPopup()
			end,
			adjust_x = arg_58_0.vars.wnd:getChildByName("n_equip_tooltip"):getPositionX() / 2 + 120,
			adjust_y = arg_58_0.vars.wnd:getChildByName("n_equip_tooltip"):getPositionY() / 2
		})
	else
		if not get_cocos_refid(arg_58_0.vars.confirm_dlg) then
			return 
		end
		
		WidgetUtils:setupTooltip({
			delay = 0,
			control = arg_58_0.vars.confirm_dlg:getChildByName("btn_item_set_tooltip"),
			creator = function()
				return AlchemistSelect:openInfoPopup()
			end,
			adjust_x = arg_58_0.vars.confirm_dlg:getChildByName("n_equip_tooltip"):getPositionX() / 2 + 40,
			adjust_y = arg_58_0.vars.confirm_dlg:getChildByName("n_equip_tooltip"):getPositionY() / 2
		})
	end
end

function AlchemistSelect.openInfoPopup(arg_61_0, arg_61_1)
	if not arg_61_0.vars or not arg_61_0.vars.item_sets then
		return 
	end
	
	arg_61_0.vars.setInfoPopup = load_dlg("sanctuary_alchemy_equip_tooltip", true, "wnd")
	
	arg_61_0.vars.setInfoPopup:setAnchorPoint(0, 0)
	arg_61_0.vars.setInfoPopup:setPosition(0, 0)
	
	local var_61_0 = 1
	
	for iter_61_0, iter_61_1 in pairs(arg_61_0.vars.item_sets) do
		local var_61_1 = arg_61_0.vars.setInfoPopup:getChildByName("set_icon" .. var_61_0)
		local var_61_2 = arg_61_0.vars.setInfoPopup:getChildByName("txt_pers" .. var_61_0)
		
		if not var_61_1 or not var_61_2 then
			break
		end
		
		if iter_61_1.count > 0 then
			if_set_sprite(var_61_1, nil, EQUIP:getSetItemIconPath(iter_61_1.set))
			
			var_61_0 = var_61_0 + 1
			
			local var_61_3 = iter_61_1.percent
			
			if_set(var_61_2, nil, round(var_61_3, 1) .. "%")
		end
	end
	
	for iter_61_2 = var_61_0, 10 do
		if_set_visible(arg_61_0.vars.setInfoPopup, "set_icon" .. iter_61_2, false)
	end
	
	for iter_61_3 = 1, 10 do
		if_set_visible(arg_61_0.vars.setInfoPopup, "level" .. iter_61_3, false)
	end
	
	arg_61_0:_setInfoPopupBG_size(arg_61_0.vars.setInfoPopup, var_61_0 - 1)
	
	return arg_61_0.vars.setInfoPopup
end

function AlchemistSelect._setInfoPopupBG_size(arg_62_0, arg_62_1, arg_62_2)
	if not get_cocos_refid(arg_62_1) or not arg_62_2 or arg_62_2 <= 0 then
		return 
	end
	
	if arg_62_2 >= 5 then
		return 
	end
	
	arg_62_2 = math.ceil(arg_62_2 / 2)
	
	local var_62_0 = arg_62_1:getChildByName("bg_tooltip")
	local var_62_1 = var_62_0:getContentSize().height
	local var_62_2 = var_62_0:getContentSize().width
	local var_62_3 = arg_62_1:getChildByName("set_icon1"):getContentSize().height
	
	var_62_0:setContentSize({
		height = 140 + var_62_3 * arg_62_2,
		width = var_62_2
	})
end

function AlchemistSelect.closeInfoPopup(arg_63_0)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.setInfoPopup) then
		return 
	end
	
	arg_63_0.vars.setInfoPopup:removeFromParent()
	
	arg_63_0.vars.setInfoPopup = nil
end

function AlchemistSelect.selectItemTab(arg_64_0, arg_64_1, arg_64_2)
	arg_64_0:moveTabSelector(arg_64_1, arg_64_2)
	
	if arg_64_0.tab ~= arg_64_1 then
		arg_64_0:setCurrentMaxUid(arg_64_0.tab)
	end
	
	arg_64_0.tab = arg_64_1
	
	arg_64_0:refreshItems()
	arg_64_0:_setNodata_text(arg_64_1)
end

function AlchemistSelect._setNodata_text(arg_65_0, arg_65_1)
	if not arg_65_1 then
		return 
	end
	
	if arg_65_0.vars.isEquips then
		if not var_0_0[arg_65_1] or not arg_65_0.vars.items[var_0_0[arg_65_1]] then
			return 
		end
		
		if_set_visible(arg_65_0.vars.wnd, "no_data", #arg_65_0.vars.items[var_0_0[arg_65_1]] == 0)
	else
		if not var_0_1[arg_65_1] or not arg_65_0.vars.items[var_0_1[arg_65_1]] then
			return 
		end
		
		if_set_visible(arg_65_0.vars.wnd, "no_data", #arg_65_0.vars.items[var_0_1[arg_65_1]] == 0)
	end
end

function AlchemistSelect.moveTabSelector(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0
	local var_66_1
	local var_66_2
	
	if arg_66_2 then
		var_66_0 = arg_66_0.vars.wnd:getChildByName("n_tab_job")
		var_66_2 = "btn_job_tab"
	else
		var_66_0 = arg_66_0.vars.wnd:getChildByName("n_tab")
		var_66_2 = "btn_equip_tab"
	end
	
	if not var_66_0 then
		return 
	end
	
	local var_66_3 = var_66_0:getChildByName(var_66_2 .. arg_66_1)
	
	if not var_66_3 then
		return 
	end
	
	local var_66_4 = var_66_0:getChildByName("n_tab" .. arg_66_1)
	
	if var_66_4 then
		var_66_3:setPositionX(var_66_4:getPositionX())
	end
	
	for iter_66_0 = 1, 6 do
		local var_66_5 = var_66_0:getChildByName(var_66_2 .. iter_66_0)
		
		if iter_66_0 == arg_66_1 then
			if_set_visible(var_66_5, "bg_tab", true)
		else
			if_set_visible(var_66_5, "bg_tab", false)
		end
	end
end

function AlchemistSelect.isCorrectTab(arg_67_0, arg_67_1)
	if arg_67_0.vars.isEquips then
		local var_67_0 = {
			weapon = 1,
			armor = 2,
			ring = 6,
			boot = 5,
			helm = 4,
			neck = 3
		}
		
		return arg_67_0.tab == var_67_0[arg_67_1]
	else
		local var_67_1 = {
			manauser = 5,
			knight = 1,
			assassin = 4,
			warrior = 2,
			ranger = 3,
			mage = 6
		}
		
		return arg_67_0.tab == var_67_1[arg_67_1]
	end
end

function AlchemistSelect.getCurrentCategoryName(arg_68_0)
	if arg_68_0.tab then
		if arg_68_0.vars.isEquips or arg_68_0.vars.isEuips_alchemyPoint then
			return var_0_0[arg_68_0.tab]
		else
			return var_0_1[arg_68_0.tab]
		end
	else
		arg_68_0.tab = 1
		
		if arg_68_0.vars.isEquips or arg_68_0.vars.isEuips_alchemyPoint then
			return var_0_0[1]
		else
			return var_0_1[1]
		end
	end
end

function AlchemistSelect.setCurrentMaxUid(arg_69_0, arg_69_1)
	if AlchemistSelect.equipMaxUids == nil then
		AlchemistSelect:checkLastInventoryEnter()
	end
	
	if arg_69_1 ~= nil then
		local var_69_0 = -1
		
		for iter_69_0, iter_69_1 in pairs(Account.equips) do
			if not iter_69_1:isArtifact() then
				local var_69_1
				
				if arg_69_0.vars.isEquips then
					var_69_1 = iter_69_1.db.type
				elseif arg_69_0.vars.isExclusive then
					var_69_1 = iter_69_1.db.role
				end
				
				if arg_69_1 == 0 or arg_69_0:isCorrectTab(var_69_1) or iter_69_1:isCompatibleCategoryStone(arg_69_0:getCurrentCategoryName()) then
					var_69_0 = math.max(var_69_0, iter_69_1:getUID())
				end
			end
		end
		
		AlchemistSelect.equipMaxUids[arg_69_1] = var_69_0
		AlchemistSelect.equipMaxUids[0] = var_69_0 > AlchemistSelect.equipMaxUids[0] and var_69_0 or AlchemistSelect.equipMaxUids[0]
	end
end

function AlchemistSelect.checkLastInventoryEnter(arg_70_0)
	arg_70_0.equipMaxUids = {}
	
	for iter_70_0 = 0, 6 do
		local var_70_0 = SAVE:get("equip_maxUid" .. iter_70_0)
		
		if var_70_0 ~= nil then
			arg_70_0.equipMaxUids[iter_70_0] = tonumber(var_70_0)
		else
			Log.e("ERROR : equip_maxUid" .. iter_70_0 .. " Can`t Found.")
		end
	end
end

function AlchemistSelect.refreshItems(arg_71_0, arg_71_1)
	if not arg_71_0.vars then
		return 
	end
	
	if arg_71_0.vars and not get_cocos_refid(arg_71_0.vars.wnd) then
		return 
	end
	
	if arg_71_0.vars.isEquips == true or arg_71_0.vars.isExclusive then
		local var_71_0 = arg_71_0:getCurrentCategoryName()
		
		if not arg_71_0.vars.items[var_71_0] or arg_71_0.vars.items[var_71_0] == nil then
			arg_71_0.vars.items[var_71_0] = arg_71_0:selectItems({
				itemType = var_71_0
			})
		end
		
		local var_71_1 = arg_71_0.vars.isEquips
		
		arg_71_0.vars.wnd:getChildByName("btn_sorting"):bringToFront()
		
		if not arg_71_0.vars.sorter then
			arg_71_0.vars.sorter = Sorter:create(arg_71_0.vars.wnd:getChildByName("btn_sorting"), {
				useExtention = var_71_1
			})
			
			local var_71_2
			
			if arg_71_0.vars.isEquips then
				var_71_2 = {
					{
						name = T("ui_inventory_sort_10"),
						func = EQUIP.greaterThanEnhance
					},
					{
						name = T("ui_inventory_sort_4"),
						func = EQUIP.greaterThanUID
					},
					{
						name = T("ui_inventory_sort_1"),
						func = EQUIP.greaterThanGrade
					},
					{
						name = T("ui_inventory_sort_8"),
						func = EQUIP.greaterThanStat
					},
					{
						name = T("ui_inventory_sort_2"),
						func = EQUIP.greaterThanItemLevel
					},
					{
						name = T("ui_inventory_sort_5"),
						func = EQUIP.greaterThanSet
					},
					{
						name = T("ui_equip_score"),
						func = EQUIP.greaterThanPoint
					}
				}
			elseif arg_71_0.vars.isExclusive then
				var_71_2 = {
					{
						name = T("ui_inventory_sort_4"),
						func = EQUIP.greaterThanUID
					},
					{
						name = T("ui_inventory_sort_8"),
						func = EQUIP.greaterThanStat
					},
					{
						name = T("ui_inventory_sort_9"),
						func = EQUIP.greaterThanID
					}
				}
			end
			
			local var_71_3 = 3
			
			if arg_71_0.vars.isEquips then
				var_71_3 = Account:getConfigData("inven_equip_sort_index") or 3
			else
				var_71_3 = Account:getConfigData("inven_exclusive_sort_index") or 3
			end
			
			arg_71_0.vars.sorter:setSorter({
				default_sort_index = var_71_3,
				menus = var_71_2,
				close_callback = function()
					arg_71_0:refreshItems()
				end,
				callback_sort = function(arg_73_0, arg_73_1)
					if arg_71_0.vars.isEquips then
						SAVE:setTempConfigData("inven_equip_sort_index", arg_73_1)
					else
						SAVE:setTempConfigData("inven_exclusive_sort_index", arg_73_1)
					end
					
					arg_71_0:resetListView(true)
				end
			})
		end
		
		if var_71_1 then
			if not arg_71_0.vars.original_items then
				arg_71_0.vars.original_items = {}
			end
			
			if not arg_71_0.vars.original_items[var_71_0] then
				arg_71_0.vars.original_items[var_71_0] = arg_71_0.vars.items[var_71_0]
			end
			
			arg_71_0.vars.items[var_71_0] = arg_71_0.vars.original_items[var_71_0]
			
			if arg_71_0.vars.sorter.sorter_extention then
				SorterExtentionUtil:set_itemSetCounts(arg_71_0.vars.sorter.sorter_extention:get_setBox(), arg_71_0.vars.items[var_71_0])
			end
		end
		
		arg_71_0.vars.sorter:setItems(arg_71_0.vars.items[var_71_0])
		
		arg_71_0.vars.items[var_71_0] = arg_71_0.vars.sorter:sort()
		
		arg_71_0.vars.sorter:setVisible(true)
	elseif arg_71_0.vars.iscatalyst then
		arg_71_0.vars.items, arg_71_0.vars.catalysts = arg_71_0:selectItems()
		
		arg_71_0.vars.wnd:getChildByName("btn_sorting"):bringToFront()
		
		if not arg_71_1 and arg_71_0.vars.selectedItems and table.count(arg_71_0.vars.selectedItems) > 0 then
			arg_71_0:refreshSelectedItems()
		end
		
		if_set_visible(arg_71_0.vars.wnd, "no_data", #arg_71_0.vars.items == 0)
		
		if arg_71_1 then
			arg_71_0:showCatalystList()
			arg_71_0:changePreCatalystUI()
		end
	elseif arg_71_0.vars.isEuips_alchemyPoint then
		local var_71_4 = arg_71_0:getCurrentCategoryName()
		
		if not arg_71_0.vars.items[var_71_4] or arg_71_0.vars.items[var_71_4] == nil then
			arg_71_0.vars.items[var_71_4] = arg_71_0:selectItems({
				itemType = var_71_4
			})
		end
		
		if_set_visible(arg_71_0.vars.wnd, "no_data", #arg_71_0.vars.items[var_71_4] == 0)
	else
		arg_71_0.vars.items = arg_71_0:selectItems()
	end
	
	arg_71_0:resetListView()
end

function AlchemistSelect.refreshSelectedItems(arg_74_0)
	for iter_74_0, iter_74_1 in pairs(arg_74_0.vars.selectedItems) do
		for iter_74_2, iter_74_3 in pairs(arg_74_0.vars.items) do
			if iter_74_1:getUID() == iter_74_3:getUID() then
				iter_74_3.selected = true
				
				break
			end
		end
	end
	
	arg_74_0:updateCenterSlots()
	arg_74_0.vars.listview:refresh()
end

function AlchemistSelect.resetListView(arg_75_0, arg_75_1)
	arg_75_0.vars.listview:removeAllChildren()
	
	if arg_75_0.vars.isEquips == true or arg_75_0.vars.isExclusive == true then
		local var_75_0 = arg_75_0:getCurrentCategoryName()
		
		arg_75_0.vars.listview:addItems(arg_75_0.vars.items[var_75_0])
		arg_75_0:_setNodata_text(arg_75_0.tab)
	elseif arg_75_0.vars.iscatalyst then
		arg_75_0.vars.listview:addItems(arg_75_0.vars.items)
		
		if not arg_75_1 then
			arg_75_0.vars.listview_catalyst:removeAllChildren()
			arg_75_0.vars.listview_catalyst:addItems(arg_75_0.vars.catalysts)
		end
	elseif arg_75_0.vars.isEuips_alchemyPoint then
		local var_75_1 = arg_75_0:getCurrentCategoryName()
		
		arg_75_0.vars.listview:addItems(arg_75_0.vars.items[var_75_1])
	else
		arg_75_0.vars.listview:addItems(arg_75_0.vars.items)
	end
	
	arg_75_0.vars.listview:jumpToTop()
end

function AlchemistSelect.select_exclusiveSkill(arg_76_0, arg_76_1)
	if not arg_76_0.vars.isExclusive then
		return 
	end
	
	local var_76_0 = arg_76_0.vars.wnd:getChildByName("n_private")
	
	if not get_cocos_refid(var_76_0) then
		return 
	end
	
	if arg_76_0.vars.qualityPoint < arg_76_0.vars.qualityPoint_max or arg_76_1 == 0 then
		if_set_visible(var_76_0, "n_info", true)
		
		for iter_76_0 = 1, 3 do
			if_set_visible(var_76_0, "select" .. iter_76_0, false)
		end
		
		var_76_0:getChildByName("select1"):setPosition(var_76_0:getChildByName("btn_skill1"):getPosition())
		
		return 
	end
	
	if_set_visible(var_76_0, "n_info", false)
	
	arg_76_0.vars.selected_skill = arg_76_1
	
	if_set_visible(var_76_0, "select1", true)
	UIAction:Add(LOG(MOVE_TO(100, var_76_0:getChildByName("btn_skill" .. arg_76_1):getPosition())), var_76_0:getChildByName("select1"), "block")
end

function AlchemistSelect.Manufacture(arg_77_0)
	local var_77_0 = arg_77_0.vars.cur_itemdata.req_gold
	local var_77_1 = Account:getPropertyCount("gold")
	
	if arg_77_0.vars.iscatalyst and not arg_77_0.vars.selectCatalyst then
		balloon_message_with_sound("msg_alchemist_no_catalyst")
		
		return 
	end
	
	if arg_77_0.vars.qualityPoint < tonumber(arg_77_0.vars.quality_standard[1]) then
		balloon_message_with_sound("msg_alchemist_low_quality")
		
		return 
	elseif var_77_1 < var_77_0 then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	if arg_77_0.vars.isExclusive and arg_77_0.vars.qualityPoint < arg_77_0.vars.qualityPoint_max then
		arg_77_0.vars.selected_skill = nil
	end
	
	if arg_77_0.vars.iscatalyst then
		AlchemistSelect:closeInfoPopup()
		arg_77_0:openCatalyst_confirmUI()
		
		return 
	end
	
	if arg_77_0.vars.cur_itemdata.category == "alchemy_change" then
		if arg_77_0.vars.curQuality == 3 and arg_77_0.vars.select_change_stone_stat == nil then
			balloon_message_with_sound("ui_alchemy_stat_msg")
			
			return 
		end
		
		arg_77_0:openChangeStoneConfirmUI()
		
		return 
	end
	
	Dialog:msgBox(T("ui_alchemist_popup_desc"), {
		yesno = true,
		yes_text = T("ui_alchemist_popup_btn"),
		handler = function()
			AlchemistSelect:req_manufacture()
		end
	})
end

function AlchemistSelect.req_manufacture(arg_79_0)
	if not arg_79_0.vars then
		return 
	end
	
	local var_79_0 = arg_79_0.vars.cur_itemdata.id
	
	if arg_79_0.vars.isExclusive then
		var_79_0 = arg_79_0.vars.cur_itemdata.db_id
	end
	
	local var_79_1 = {
		equips = {},
		materials = {},
		catalyst = {}
	}
	
	for iter_79_0, iter_79_1 in pairs(arg_79_0.vars.selectedItems) do
		if iter_79_1.code then
			if string.starts(iter_79_1.code, "e") then
				table.push(var_79_1.equips, iter_79_1.id)
			elseif string.starts(iter_79_1.code, "ma_") then
				table.push(var_79_1.materials, {
					code = iter_79_1.code,
					count = iter_79_1.count
				})
			end
		end
	end
	
	if arg_79_0.vars.iscatalyst then
		var_79_1.catalyst.code = arg_79_0.vars.selectCatalyst.code
		var_79_1.catalyst.count = 1
	end
	
	query("alchemist_combine", {
		alchemy_id = var_79_0,
		use_items = json.encode(var_79_1),
		quality = arg_79_0.vars.qualityPoint,
		selected_skill = tonumber(arg_79_0.vars.selected_skill)
	})
end

function AlchemistSelect.openCatalyst_confirmUI(arg_80_0)
	arg_80_0.vars.confirm_dlg = load_dlg("sanctuary_alchemy_conversion_confirm", true, "wnd", function()
		AlchemistSelect:closeCatalyst_confirmUI()
	end)
	
	arg_80_0:setCatalyst_confirmUI()
	arg_80_0.vars.wnd:addChild(arg_80_0.vars.confirm_dlg)
	arg_80_0:setInfoPopup_tooltip(2)
	GrowthGuideNavigator:proc()
end

function AlchemistSelect.setCatalyst_confirmUI(arg_82_0)
	if not arg_82_0.vars or not get_cocos_refid(arg_82_0.vars.wnd) or not get_cocos_refid(arg_82_0.vars.confirm_dlg) then
		return 
	end
	
	local var_82_0 = arg_82_0.vars.confirm_dlg
	local var_82_1 = arg_82_0.vars.cur_itemdata
	local var_82_2 = arg_82_0.vars.selectCatalyst
	local var_82_3 = true
	
	if not var_82_1 or not var_82_2 then
		return 
	end
	
	local var_82_4 = UIUtil:getRewardIcon(nil, var_82_1.icon, {
		no_tooltip = false,
		parent = var_82_0:getChildByName("n_item")
	})
	
	if_set(var_82_0, "t_item_name", T(var_82_1.recipe_name))
	if_set(var_82_0, "cost", comma_value(arg_82_0.vars.cur_itemdata.req_gold))
	
	local var_82_5, var_82_6, var_82_7 = arg_82_0:getStatIcon(var_82_2.code)
	local var_82_8 = var_82_0:getChildByName("t_main_stat")
	
	if_set_sprite(var_82_8, "icon_stat", var_82_5)
	if_set_visible(var_82_8, "icon_pers", var_82_7)
	if_set(var_82_8, nil, var_82_6)
	
	local var_82_9 = 1
	
	for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.item_sets) do
		if var_82_9 >= 3 then
			break
		end
		
		if iter_82_1.count > 0 then
			if_set_sprite(var_82_0:getChildByName("n_item_set"), "set_icon" .. var_82_9, EQUIP:getSetItemIconPath(iter_82_1.set))
			if_set_visible(var_82_0:getChildByName("n_item_set"), "set_icon" .. var_82_9, true)
			
			local var_82_10 = iter_82_1.percent
			
			if_set(var_82_0, "t_set_icon" .. var_82_9 .. "_percent", round(var_82_10, 1) .. "%")
			
			var_82_9 = var_82_9 + 1
		end
	end
	
	if var_82_9 < 3 then
		if_set_visible(var_82_0, "t_set_icon2_percent", false)
		if_set_visible(var_82_0, "set_icon2", false)
		if_set_visible(var_82_0:getChildByName("n_item_set"), "cm_icon_etcarrow", false)
		
		var_82_3 = false
	end
	
	if_set_visible(var_82_0, "btn_item_set_tooltip", var_82_3)
	
	local var_82_11 = T("ui_alchemist_equip_confirm_grade1")
	
	if arg_82_0.vars.curQuality == 2 then
		var_82_11 = T("ui_alchemist_equip_confirm_grade2")
	elseif arg_82_0.vars.curQuality >= 3 then
		var_82_11 = T("ui_alchemist_equip_confirm_grade3")
	end
	
	if_set(var_82_0, "t_item_grade", var_82_11)
end

function AlchemistSelect.getCatalystConfirmUI_tooltip(arg_83_0)
	if not arg_83_0.vars or not get_cocos_refid(arg_83_0.vars.confirm_dlg) then
		return 
	end
	
	return arg_83_0.vars.confirm_dlg:getChildByName("n_equip_tooltip")
end

function AlchemistSelect.closeCatalyst_confirmUI(arg_84_0)
	if not arg_84_0.vars or not get_cocos_refid(arg_84_0.vars.wnd) or not get_cocos_refid(arg_84_0.vars.confirm_dlg) then
		return 
	end
	
	BackButtonManager:pop("sanctuary_alchemy_conversion_confirm")
	arg_84_0.vars.confirm_dlg:removeFromParent()
	
	arg_84_0.vars.confirm_dlg = nil
end

function AlchemistSelect.combined(arg_85_0, arg_85_1)
	if arg_85_1.limits then
		Account:updateLimits(arg_85_1.limits)
	end
	
	if arg_85_1.removed_equip_id_list then
		for iter_85_0, iter_85_1 in pairs(arg_85_1.removed_equip_id_list) do
			local var_85_0 = tonumber(iter_85_1)
			local var_85_1 = Account:getEquip(var_85_0)
			
			Account:removeEquip(var_85_0)
		end
	end
	
	Account:addReward(arg_85_1.consumed_items, {
		content = "alchemy"
	})
	Account:addReward(arg_85_1.rewards, {
		content = "alchemy"
	})
	ConditionContentsManager:dispatch("alchemy.use")
	
	local var_85_2 = (arg_85_1.rewards or {}).new_equips or {}
	
	for iter_85_2, iter_85_3 in pairs(var_85_2) do
		if iter_85_3.id then
			local var_85_3 = Account:getEquip(iter_85_3.id)
			
			if var_85_3 and var_85_3.db and not var_85_3:isArtifact() then
				ConditionContentsManager:dispatch("alchemy.equip", {
					equiptype = var_85_3.db.type
				})
				
				if not var_85_3:isExclusive() then
					ConditionContentsManager:dispatch("equip.craft", {
						equiptype = var_85_3.db.type,
						code = var_85_3.db.code
					})
				end
			end
		end
	end
	
	local var_85_4 = SceneManager:getDefaultLayer()
	local var_85_5 = cc.c3b(0, 0, 0)
	local var_85_6 = cc.LayerColor:create(var_85_5)
	
	var_85_6:setContentSize(VIEW_WIDTH, VIEW_WIDTH)
	var_85_6:setPosition(VIEW_BASE_LEFT, 0)
	var_85_6:setLocalZOrder(99999)
	var_85_6:setOpacity(153)
	var_85_4:addChild(var_85_6)
	
	local var_85_7 = ccui.Button:create()
	
	var_85_7:setTouchEnabled(true)
	var_85_7:ignoreContentAdaptWithSize(false)
	var_85_7:setContentSize(999999, 999999)
	var_85_7:setPosition(-1000, 360)
	var_85_7:setName("btn_block")
	var_85_6:addChild(var_85_7)
	
	local var_85_8 = EffectManager:Play({
		z = 99999,
		fn = "ui_town_alchemy_npc_eff.cfx",
		layer = var_85_4,
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	
	UIAction:Add(SEQ(DELAY(3200), CALL(AlchemistSelect.openResultPopup, arg_85_0, arg_85_1), DELAY(400), TARGET(var_85_8, REMOVE()), TARGET(var_85_6, REMOVE()), REMOVE()), var_85_6, "block")
	arg_85_0:resetAll()
end

function AlchemistSelect.getNewEquip(arg_86_0, arg_86_1)
	if not arg_86_1 then
		return nil
	end
	
	for iter_86_0, iter_86_1 in pairs(arg_86_1) do
		if iter_86_1.id then
			return Account:getEquip(iter_86_1.id)
		end
	end
	
	return nil
end

function AlchemistSelect.arrangeResultWndPosition(arg_87_0)
	local var_87_0 = arg_87_0.vars.result_wnd:getChildByName("txt_set_info")
	
	if not get_cocos_refid(var_87_0) then
		return 
	end
	
	local var_87_1 = var_87_0:getStringNumLines()
	
	if not var_87_1 then
		return 
	end
	
	if var_87_1 < 5 then
		return 
	end
	
	local var_87_2 = arg_87_0.vars.result_wnd:getChildByName("cm_tooltipbox")
	
	if not get_cocos_refid(var_87_2) then
		return 
	end
	
	local var_87_3 = arg_87_0.vars.result_wnd:getChildByName("block")
	
	if not get_cocos_refid(var_87_3) then
		return 
	end
	
	local var_87_4 = arg_87_0.vars.result_wnd:getChildByName("n_btn")
	
	if not get_cocos_refid(var_87_4) then
		return 
	end
	
	local var_87_5 = var_87_2:getContentSize()
	local var_87_6 = var_87_3:getContentSize()
	
	var_87_2:setContentSize({
		width = var_87_5.width,
		height = var_87_5.height + 20
	})
	var_87_3:setContentSize({
		width = var_87_6.width,
		height = var_87_6.height + 20
	})
	var_87_4:setPositionY(var_87_4:getPositionY() - 20)
end

function AlchemistSelect.openCatalystResultPopup(arg_88_0, arg_88_1)
	if not arg_88_1 or not arg_88_1.rewards then
		return 
	end
	
	local var_88_0 = arg_88_0:getNewEquip(arg_88_1.rewards.new_equips)
	
	if not var_88_0 or var_88_0 == nil or not var_88_0.code then
		Log.e("구매결과아이템이 없다.")
		
		return 
	end
	
	arg_88_0.vars.result_item = var_88_0
	
	local var_88_1 = load_dlg("item_detail_sub", true, "wnd")
	
	if not get_cocos_refid(var_88_1) then
		return 
	end
	
	arg_88_0.vars.result_wnd = load_dlg("sanctuary_alchemy_result", true, "wnd", function()
		AlchemistSelect:closeResultPopup()
	end)
	
	if not get_cocos_refid(arg_88_0.vars.result_wnd) then
		return 
	end
	
	if_set_visible(arg_88_0.vars.result_wnd, "n_equip", true)
	var_88_1:setAnchorPoint(0.5, 0.5)
	var_88_1:setPosition(0, 0)
	
	local var_88_2 = arg_88_0.vars.result_wnd:getChildByName("n_equip")
	
	if not get_cocos_refid(var_88_2) then
		return 
	end
	
	local var_88_3 = var_88_2:getChildByName("n_pos_detail")
	
	if not get_cocos_refid(var_88_3) then
		return 
	end
	
	var_88_3:addChild(var_88_1)
	SanctuaryMain.vars.wnd:addChild(arg_88_0.vars.result_wnd, 9999998)
	arg_88_0.vars.result_wnd:bringToFront()
	
	local var_88_4 = var_88_1:getContentSize()
	local var_88_5 = EffectManager:Play({
		fn = "ui_equip_pack_eff.cfx",
		layer = var_88_1,
		x = var_88_4.width * 0.5,
		y = var_88_4.height * 0.5
	})
	
	UIAction:Add(SEQ(DELAY(800)), arg_88_0.vars.result_wnd, "block")
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = var_88_1,
		equip = arg_88_0.vars.result_item
	})
	ItemTooltip:updateItemFrame(var_88_2, arg_88_0.vars.result_item, "cm_tooltipbox", "frame_grade")
	
	local var_88_6 = var_88_1:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_88_6) then
		local var_88_7 = var_88_6:getStringNumLines()
		
		if var_88_7 and var_88_7 >= 4 then
			local var_88_8 = var_88_2:getChildByName("frame_grade")
			
			if get_cocos_refid(var_88_8) then
				local var_88_9 = var_88_8:getContentSize()
				
				var_88_8:setContentSize({
					width = var_88_9.width,
					height = var_88_9.height + 20
				})
				
				if var_88_5 then
					var_88_5:setScaleY(1.03)
					var_88_5:setPositionY(var_88_5:getPositionY() - 12)
					var_88_5:setPositionX(var_88_5:getPositionX() - 5)
				end
			end
		end
	end
	
	arg_88_0:arrangeResultWndPosition()
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(AlchemistSelect.updateEquipLock, arg_88_0), "alchemist.equip.result.popup")
end

function AlchemistSelect.LockUnLock_resultItem(arg_90_0, arg_90_1)
	if not arg_90_0.vars or not arg_90_0.vars.result_item then
		return 
	end
	
	if arg_90_1 == "btn_lock" then
		query("lock_equip", {
			equip = arg_90_0.vars.result_item.id
		})
	elseif arg_90_1 == "btn_lock_done" then
		query("unlock_equip", {
			equip = arg_90_0.vars.result_item.id
		})
	end
end

function AlchemistSelect.updateEquipLock(arg_91_0, arg_91_1)
	if not arg_91_0.vars or not arg_91_0.vars.result_wnd or not get_cocos_refid(arg_91_0.vars.result_wnd) or not arg_91_0.vars.result_item then
		return 
	end
	
	local var_91_0 = arg_91_0.vars.result_wnd
	
	if_set_visible(var_91_0, "btn_lock", not arg_91_1)
	if_set_visible(var_91_0, "btn_lock_done", arg_91_1)
	if_set_visible(var_91_0, "locked", arg_91_1)
end

function AlchemistSelect.sellResultItem(arg_92_0)
	if not arg_92_0.vars or not get_cocos_refid(arg_92_0.vars.result_wnd) or not arg_92_0.vars.result_item then
		return 
	end
	
	if arg_92_0.vars.result_item.lock then
		balloon_message_with_sound("equip_sell_locked")
		
		return 
	end
	
	if arg_92_0.vars.result_item:isForceLock() then
		balloon_message_with_sound("err_cannot_sell_equip")
		
		return 
	end
	
	local var_92_0 = 0
	local var_92_1 = calcEquipSellPrice(arg_92_0.vars.result_item)
	local var_92_2 = var_92_1 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_92_1)
	local var_92_3 = {}
	
	table.push(var_92_3, arg_92_0.vars.result_item.id)
	GlobalGetSellDialog(var_92_2, nil, var_92_3, "alchemy_result"):bringToFront()
end

function AlchemistSelect.extractResultItem(arg_93_0)
	if not arg_93_0.vars or not get_cocos_refid(arg_93_0.vars.result_wnd) or not arg_93_0.vars.result_item then
		return 
	end
	
	if arg_93_0.vars.result_item.lock then
		balloon_message_with_sound("equip_extract_locked")
		
		return 
	end
	
	if not arg_93_0.vars.result_item:isExtractable() then
		balloon_message_with_sound("msg_extraction_level_error")
		
		return 
	end
	
	Inventory:extractUtil({
		arg_93_0.vars.result_item
	}, "alchemy_result", function()
		AlchemistSelect:closeResultPopup()
	end)
end

function AlchemistSelect.updateTargetitemInfo(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	ItemTooltip:updateItemInformation({
		detail = true,
		no_resize = true,
		wnd = arg_95_1,
		code = arg_95_2,
		set_fx = arg_95_3
	})
end

function AlchemistSelect.openResultPopup(arg_96_0, arg_96_1)
	if arg_96_0.vars.isExclusive then
		ShopExclusiveEquip_result:open_resultPopup(arg_96_1, {
			type = "sanctuary_alchemy"
		})
		
		return 
	elseif arg_96_0.vars.iscatalyst then
		arg_96_0:openCatalystResultPopup(arg_96_1)
		
		return 
	end
	
	arg_96_0.vars.result_wnd = load_dlg("sanctuary_alchemy_result", true, "wnd", function()
		AlchemistSelect:closeResultPopup()
	end)
	
	TopBarNew:topbarUpdate(true)
	
	local var_96_0
	local var_96_1 = arg_96_1.rewards
	
	arg_96_0.vars.result_wnd:getChildByName("CENTER"):bringToFront()
	SanctuaryMain.vars.wnd:addChild(arg_96_0.vars.result_wnd, 9999998)
	arg_96_0.vars.result_wnd:bringToFront()
	
	local var_96_2 = {}
	
	if arg_96_1.rewards.new_items then
		local var_96_3 = arg_96_1.rewards.new_items
		
		for iter_96_0, iter_96_1 in pairs(var_96_3) do
			table.insert(var_96_2, iter_96_1)
		end
	end
	
	if arg_96_1.rewards.new_equips then
		local var_96_4 = arg_96_1.rewards.new_equips
		
		for iter_96_2, iter_96_3 in pairs(var_96_4) do
			table.insert(var_96_2, iter_96_3)
		end
	end
	
	local var_96_5
	
	if #var_96_2 < 4 then
		var_96_5 = arg_96_0.vars.result_wnd:getChildByName("n_item_3/3")
		
		if_set_visible(arg_96_0.vars.result_wnd, "n_item_3/3", true)
		if_set_visible(arg_96_0.vars.result_wnd, "n_item_4/6", false)
	else
		var_96_5 = arg_96_0.vars.result_wnd:getChildByName("n_item_4/6")
		
		if_set_visible(arg_96_0.vars.result_wnd, "n_item_3/3", false)
		if_set_visible(arg_96_0.vars.result_wnd, "n_item_4/6", true)
	end
	
	for iter_96_4, iter_96_5 in pairs(var_96_2) do
		local var_96_6 = iter_96_5
		
		if_set_visible(var_96_5, iter_96_4, true)
		
		if string.starts(iter_96_5.code, "e") then
			var_96_6 = Account:getEquip(iter_96_5.id)
			
			UIUtil:getRewardIcon("equip", var_96_6.code, {
				no_count = true,
				show_name = true,
				parent = var_96_5:getChildByName(iter_96_4),
				equip = var_96_6,
				grade = var_96_6.grade
			})
		else
			UIUtil:getRewardIcon(nil, var_96_6.code, {
				no_tooltip = true,
				show_name = true,
				no_name = false,
				parent = var_96_5:getChildByName(iter_96_4)
			})
		end
		
		EffectManager:Play({
			pivot_z = 99998,
			fn = "ui_town_alchemy_ui_eff.cfx",
			layer = var_96_5:getChildByName(iter_96_4)
		})
		if_set(var_96_5:getChildByName(iter_96_4), "txt_count", var_96_6.diff)
		if_set_visible(var_96_5:getChildByName(iter_96_4), "txt_count", false)
		UIAction:Add(SEQ(DELAY(500), FADE_IN(150)), var_96_5:getChildByName(iter_96_4):getChildByName("txt_count"), arg_96_0)
	end
end

function AlchemistSelect.closeResultPopup(arg_98_0)
	if get_cocos_refid(arg_98_0.vars.result_wnd) then
		BackButtonManager:pop({
			id = "sanctuary_alchemy_result",
			dlg = arg_98_0.vars.result_wnd
		})
		arg_98_0.vars.result_wnd:removeFromParent()
		
		arg_98_0.vars.result_wnd = nil
		arg_98_0.vars.result_item = nil
	end
	
	local var_98_0, var_98_1 = SanctuaryArchemist:getRestCount(arg_98_0.vars.cur_itemdata)
	
	if not var_98_0 and not var_98_1 then
		return 
	end
	
	if var_98_0 <= 0 then
		balloon_message_with_sound("msg_alchemist_count_limit")
		arg_98_0:onLeave()
	end
end

function AlchemistSelect.additional_qualityPoint(arg_99_0, arg_99_1)
	if arg_99_1 == nil then
		Log.e("퀄리티포인트가 nil값일수가없습니다., 잘못된 DB")
		
		return 
	end
	
	local var_99_0 = SanctuaryMain:GetLevels("Archemist")[3]
	local var_99_1 = DB("sanctuary_upgrade", "archemist_2_" .. var_99_0, "value_1") or 100
	
	if var_99_1 == 100 then
		return arg_99_1
	end
	
	local var_99_2 = 0
	
	return arg_99_1 * var_99_1
end

function AlchemistSelect.updateRequireGold(arg_100_0, arg_100_1)
	local var_100_0 = SanctuaryMain:GetLevels("Archemist")[1]
	local var_100_1 = DB("sanctuary_upgrade", "archemist_0_" .. var_100_0, "value_1") or 1
	
	arg_100_1.req_gold = math.floor(arg_100_1.o_req_gold * tonumber(var_100_1) + 0.5)
	
	return arg_100_1
end

function AlchemistSelect.resetAll(arg_101_0)
	if arg_101_0.vars.isExclusive then
		for iter_101_0 = 1, #var_0_1 do
			if arg_101_0.vars.items[var_0_1[iter_101_0]] then
				arg_101_0.vars.items[var_0_1[iter_101_0]] = nil
			end
		end
		
		arg_101_0:select_exclusiveSkill(0)
	else
		for iter_101_1 = 1, #var_0_0 do
			if arg_101_0.vars.items[var_0_0[iter_101_1]] then
				arg_101_0.vars.items[var_0_0[iter_101_1]] = nil
			end
		end
	end
	
	arg_101_0.vars.selectedItems = {}
	arg_101_0.vars.qualityPoint = 0
	arg_101_0.vars.selectCatalyst = nil
	
	arg_101_0:refreshItems(true)
	arg_101_0:updateCenterSlots()
	arg_101_0:updateQuality_progBar()
end

function AlchemistSelect.initChangeStone(arg_102_0, arg_102_1)
	arg_102_1 = arg_102_0:updateRequireGold(arg_102_1)
	arg_102_0.vars.listview = arg_102_0.vars.wnd:findChildByName("ListView_578_519")
	arg_102_0.vars.listview_catalyst = arg_102_0.vars.wnd:getChildByName("ListView_catalyst")
	arg_102_0.vars.items = {}
	arg_102_0.vars.isEquips = false
	arg_102_0.vars.itemMax_count = 5
	
	arg_102_0:initListViewl()
	arg_102_0:refreshItems()
	if_set_visible(arg_102_0.vars.wnd, "n_tab", false)
	if_set_visible(arg_102_0.vars.wnd, "n_tab_job", false)
	
	local var_102_0 = arg_102_0.vars.wnd:getChildByName("CENTER")
	
	if_set_visible(getChildByPath(var_102_0, "slot_1"), nil, true)
	if_set_visible(getChildByPath(var_102_0, "slot_5"), nil, false)
	if_set_visible(getChildByPath(var_102_0, "slot_10"), nil, false)
	if_set_visible(getChildByPath(var_102_0, "slot_private"), nil, false)
	if_set_visible(arg_102_0.vars.wnd, "n_normal", false)
	if_set_visible(arg_102_0.vars.wnd, "n_mainstat_box", false)
	if_set_visible(arg_102_0.vars.wnd, "btn_sorting", false)
	if_set_visible(arg_102_0.vars.wnd, "no_data", table.empty(arg_102_0.vars.items))
	if_set_visible(arg_102_0.vars.wnd, "n_private", false)
	if_set_visible(arg_102_0.vars.wnd, "n_equip", false)
	if_set(arg_102_0.vars.wnd, "cost", comma_value(arg_102_1.req_gold))
	if_set(arg_102_0.vars.wnd, "txt_material", T(arg_102_1.req_res_desc))
	if_set(arg_102_0.vars.wnd:getChildByName("btn_produce"), "label", T("ui_alchemist_popup_btn"))
	if_set(arg_102_0.vars.wnd:getChildByName("no_data"), "label", T("msg_alchemist_no_resource"))
	
	local var_102_1 = getChildByPath(var_102_0, "n_stone")
	
	if_set_visible(var_102_1, nil, true)
	if_set(var_102_1, "txt_name", T(arg_102_1.recipe_name))
end

function AlchemistSelect.selectItemsChangeStone(arg_103_0)
	local var_103_0 = {}
	local var_103_1 = "ma_change_point"
	local var_103_2 = Account.items[var_103_1]
	
	if not var_103_2 then
		return var_103_0
	end
	
	local var_103_3, var_103_4, var_103_5, var_103_6 = DB("item_material", var_103_1, {
		"ma_type",
		"grade",
		"quality_point",
		"sort"
	})
	
	if var_103_3 == "alchemychange" and AlchemistSelect:checkExcludeItems(var_103_1) == false then
		local var_103_7 = {
			code = var_103_1
		}
		
		var_103_7.count = 1
		var_103_7.grade = var_103_4
		var_103_7.quality_point = var_103_5
		var_103_7.o_quality_point = var_103_5
		var_103_7.quality_point = arg_103_0:additional_qualityPoint(var_103_7.quality_point)
		var_103_7.maxcount = var_103_2
		var_103_7.o_maxcount = var_103_2
		var_103_7.selected = false
		var_103_7.sort = var_103_6
		
		table.push(var_103_0, var_103_7)
	end
	
	return var_103_0
end

function AlchemistSelect.getChangeStoneResultInfo(arg_104_0)
	if not arg_104_0.vars or not arg_104_0.vars.cur_itemdata then
		return 
	end
	
	local var_104_0 = arg_104_0.vars.curQuality == 3
	local var_104_1 = arg_104_0.vars.select_change_stone_stat ~= nil
	local var_104_2 = DB("alchemy_change_result", arg_104_0.vars.cur_itemdata.result_0, {
		"set"
	})
	
	if not var_104_2 then
		Log.e("AlchemistSelect.getChangeStoneResultInfo", "alchemy_change_result: " .. (arg_104_0.vars.cur_itemdata.result_0 or "nil") .. "의 set 이 없습니다.")
		
		return 
	end
	
	local var_104_3 = string.sub(arg_104_0.vars.cur_itemdata.set_id, 5, -1)
	local var_104_4
	local var_104_5 = arg_104_0.vars.curQuality > 1 and "ma_dummy_change" or "ma_dummy_change_1"
	
	if var_104_0 and var_104_1 then
		local var_104_6 = DB("alchemy_change_stat", arg_104_0.vars.select_change_stone_stat, "stat_name")
		
		if not var_104_6 then
			Log.e("AlchemistSelect.getChangeStoneResultInfo", "alchemy_change_stat: " .. (arg_104_0.vars.select_change_stone_stat or "nil") .. "의 stat_name 이 없습니다.")
			
			return 
		end
		
		var_104_5 = "ma_ext_2_" .. var_104_6 .. "_" .. var_104_2
	end
	
	return {
		code = var_104_5,
		set_id = arg_104_0.vars.cur_itemdata.set_id,
		set = var_104_3,
		stat = arg_104_0.vars.select_change_stone_stat
	}
end

function AlchemistSelect.updateQualityChangeStone(arg_105_0)
	if not arg_105_0.vars then
		return 
	end
	
	if not arg_105_0.vars.cur_itemdata then
		return 
	end
	
	if arg_105_0.vars.cur_itemdata.category ~= "alchemy_change" then
		return 
	end
	
	local var_105_0 = getChildByPath(arg_105_0.vars.wnd, "CENTER/n_stone")
	
	if not get_cocos_refid(var_105_0) then
		return 
	end
	
	local var_105_1 = arg_105_0:getChangeStoneResultInfo()
	
	if not var_105_1 then
		return 
	end
	
	UIUtil:getRewardIcon(nil, var_105_1.code, {
		no_tooltip = false,
		parent = var_105_0:getChildByName("n_target"),
		set_fx = var_105_1.set_id
	})
	
	local var_105_2 = arg_105_0.vars.curQuality == 3
	
	if not var_105_2 then
		arg_105_0.vars.select_change_stone_stat = nil
	end
	
	local var_105_3 = arg_105_0.vars.select_change_stone_stat ~= nil
	
	if_set_visible(var_105_0, "txt_stone_info", not var_105_2)
	if_set_visible(var_105_0, "btn_sel_stat", var_105_2 and not var_105_3)
	if_set_visible(var_105_0, "btn_selected_stat", var_105_2 and var_105_3)
	
	if var_105_3 then
		local var_105_4 = "_rate"
		local var_105_5 = string.ends(arg_105_0.vars.select_change_stone_stat, var_105_4)
		local var_105_6 = arg_105_0.vars.select_change_stone_stat
		
		if var_105_5 then
			var_105_6 = string.sub(arg_105_0.vars.select_change_stone_stat, 1, -(string.len(var_105_4) + 1))
		end
		
		local var_105_7 = var_105_0:getChildByName("t_stat")
		local var_105_8 = var_105_0:getChildByName("icon_stat")
		local var_105_9 = var_105_0:getChildByName("icon_pers")
		
		var_105_7._origin_scale_x = var_105_7._origin_scale_x or var_105_7:getScaleX()
		var_105_8._origin_scale_x = var_105_8._origin_scale_x or var_105_8:getScaleX()
		var_105_9._origin_scale_x = var_105_9._origin_scale_x or var_105_9:getScaleX()
		
		if_set(var_105_7, nil, T("ui_equip_base_stat_filter_" .. arg_105_0.vars.select_change_stone_stat))
		
		local var_105_10 = var_105_7._origin_scale_x / var_105_7:getScaleX()
		
		var_105_8:setScaleX(var_105_8._origin_scale_x * var_105_10)
		var_105_9:setScaleX(var_105_9._origin_scale_x * var_105_10)
		if_set_sprite(var_105_8, nil, "img/icon_menu_" .. var_105_6 .. ".png")
		if_set_visible(var_105_9, nil, var_105_5)
	end
end

function AlchemistSelect.updateCenterSlotChangeStone(arg_106_0)
	local var_106_0 = arg_106_0.vars.selectedItems[1]
	local var_106_1 = var_106_0 == nil or var_106_0.count == nil or var_106_0.count == 0
	local var_106_2 = getChildByPath(arg_106_0.vars.wnd, "CENTER/slot_1")
	local var_106_3 = var_106_2:getChildByName("node_1")
	local var_106_4 = var_106_2:getChildByName("slot_1")
	
	if_set_visible(var_106_4, "t_count", not var_106_1)
	
	if var_106_1 then
		var_106_3:removeAllChildren()
	else
		UIUtil:getRewardIcon(nil, var_106_0.code, {
			no_detail_popup = true,
			parent = var_106_3
		}).item = var_106_0
		
		if_set(var_106_4, "t_count", var_106_0.count)
	end
end

function AlchemistSelect.openMainStatBox(arg_107_0)
	local var_107_0 = arg_107_0.vars.wnd:getChildByName("n_mainstat_box")
	
	if not get_cocos_refid(var_107_0) then
		return 
	end
	
	var_107_0:setOpacity(0)
	UIAction:Add(FADE_IN(150), var_107_0, "block")
	BackButtonManager:push({
		check_id = "main_stat_box",
		back_func = function()
			arg_107_0:closeMainStatBox()
		end,
		dlg = var_107_0
	})
end

function AlchemistSelect.closeMainStatBox(arg_109_0)
	local var_109_0 = arg_109_0.vars.wnd:getChildByName("n_mainstat_box")
	
	if not get_cocos_refid(var_109_0) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(150), SHOW(false)), var_109_0, "block")
	BackButtonManager:pop({
		check_id = "main_stat_box",
		dlg = var_109_0
	})
end

function AlchemistSelect.onSelectStat(arg_110_0)
	arg_110_0:openMainStatBox()
end

function AlchemistSelect.onSelectedStat(arg_111_0)
	arg_111_0:openMainStatBox()
end

function AlchemistSelect.mainStatBoxHandler(arg_112_0, arg_112_1, arg_112_2)
	if arg_112_2 == "btn_cancel" then
		AlchemistSelect:closeMainStatBox()
		
		return 
	end
	
	local var_112_0 = "btn_stat_"
	
	if string.starts(arg_112_2, var_112_0) then
		arg_112_0.vars.select_change_stone_stat = string.sub(arg_112_2, string.len(var_112_0) + 1, -1)
		
		arg_112_0:closeMainStatBox()
		arg_112_0:updateQualityChangeStone()
		arg_112_0:checkManufactureButton()
		
		return 
	end
end

local function var_0_4(arg_113_0, arg_113_1, arg_113_2)
	return ((((((("ma" .. "_") .. (arg_113_0 and "ch1" or "ch2")) .. "_") .. arg_113_1) .. "_") .. (arg_113_2 and arg_113_2 or "random")) .. "_") .. "name"
end

function AlchemistSelect.openChangeStoneConfirmUI(arg_114_0)
	if not arg_114_0.vars then
		return 
	end
	
	if not arg_114_0.vars.cur_itemdata or table.empty(arg_114_0.vars.selectedItems) then
		return 
	end
	
	local var_114_0 = arg_114_0:getChangeStoneResultInfo()
	
	if not var_114_0 then
		return 
	end
	
	local var_114_1 = load_dlg("sanctuary_alchemy_stone_confirm", true, "wnd")
	
	if not get_cocos_refid(var_114_1) then
		return 
	end
	
	local var_114_2 = var_114_1:getChildByName("reward_item")
	
	if not get_cocos_refid(var_114_2) then
		return 
	end
	
	UIUtil:getRewardIcon(nil, var_114_0.code, {
		tooltip_delay = 130,
		parent = var_114_2,
		set_fx = var_114_0.set_id
	})
	if_set(var_114_1, "txt_title", T("set_change_nm"))
	if_set(var_114_1, "infor", T("ui_alchemist_change_confirm_desc"))
	if_set(var_114_1, "t_item_name", T(var_0_4(arg_114_0.vars.curQuality == 1, var_114_0.set, var_114_0.stat)))
	if_set(var_114_1, "txt_price", comma_value(arg_114_0.vars.cur_itemdata.req_gold))
	if_set_sprite(var_114_1, "Sprite_41", "item/token_gold.png")
	Dialog:msgBox(T("ui_alchemist_change_confirm_desc"), {
		yesno = true,
		dlg = var_114_1,
		handler = function()
			local var_115_0 = arg_114_0.vars.selectedItems[1]
			
			if var_115_0 == nil or var_115_0.count == nil or var_115_0.count == 0 then
				return 
			end
			
			local var_115_1 = {
				alchemy_id = arg_114_0.vars.cur_itemdata.id,
				use_items = json.encode({
					materials = {
						{
							code = var_115_0.code,
							count = var_115_0.count
						}
					}
				}),
				quality = arg_114_0.vars.qualityPoint,
				selected_stat = arg_114_0.vars.select_change_stone_stat
			}
			
			query("alchemist_combine", var_115_1)
		end
	})
end
