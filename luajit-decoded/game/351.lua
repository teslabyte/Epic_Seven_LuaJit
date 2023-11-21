UnitBuild = {}

local var_0_0 = {
	"weapon",
	"armor",
	"neck",
	"helm",
	"boot",
	"ring"
}

function MsgHandler.puton_equip_mass(arg_1_0)
	if arg_1_0.caller == "storage" then
		Storage:uniUniequipped(arg_1_0)
	elseif arg_1_0.caller == "unit_equip" then
		UnitEquip:resTotalChange(arg_1_0)
	elseif arg_1_0.caller == "unit_detail_equip" then
		UnitDetailEquip:resUnitUnEquip(arg_1_0)
	else
		UnitBuild:resTotalChange(arg_1_0)
	end
end

function HANDLER_BEFORE.equip_base(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == "btn_select" or arg_2_1 == "btn_cancle" or string.starts(arg_2_1, "btn_item") or string.starts(arg_2_1, "btn_slot") then
		arg_2_0.touch_tick = systick()
	end
end

function HANDLER.equip_base(arg_3_0, arg_3_1)
	if string.starts(arg_3_1, "btn_equip_tab") then
		UnitBuild:selectItemTab(to_n(string.sub(arg_3_1, -1, -1)))
	elseif arg_3_1 == "btn_select" then
		local var_3_0 = arg_3_0:getParent().datasource
		
		if var_3_0 and systick() - to_n(arg_3_0.touch_tick) < 180 then
			UnitBuild:onSelect(var_3_0)
		end
	elseif arg_3_1 == "btn_reset" then
		UnitBuild:resetItems()
	elseif arg_3_1 == "btn_change" then
		UnitBuild:openEquipChangePopup()
	elseif arg_3_1 == "btn_enhance" then
		UnitBuild:equipEnhance()
	end
	
	if arg_3_1 == "btn_set" or arg_3_1 == "btn_set_done" or arg_3_1 == "btn_mainstat" or arg_3_1 == "btn_mainstat_done" or arg_3_1 == "btn_substat1" or arg_3_1 == "btn_substat1_done" or arg_3_1 == "btn_substat2" or arg_3_1 == "btn_substat2_done" then
		UnitBuild:setFilterPopup(arg_3_1)
	elseif arg_3_1 == "btn_cancle" and systick() - to_n(arg_3_0.touch_tick) < 180 then
		UnitBuild:closeItemTooltip()
		UnitBuild:close_substatBox(2)
		UnitBuild:close_substatBox(1)
		UnitBuild:close_mainstatBox()
		UnitBuild:close_setBox()
	end
	
	if string.starts(arg_3_1, "btn_sort") then
		if to_n(string.sub(arg_3_1, -2, -2)) == 0 then
			UnitBuild:setFilter(to_n(string.sub(arg_3_1, -1, -1)))
		elseif to_n(string.sub(arg_3_1, -2, -2)) == 1 then
			UnitBuild:setFilter(to_n(string.sub(arg_3_1, -2, -1)))
		end
	end
	
	if string.starts(arg_3_1, "btn_slot") and systick() - to_n(arg_3_0.touch_tick) < 180 then
		UnitBuild:click_slots(to_n(string.sub(arg_3_1, -1, -1)))
	end
	
	if string.starts(arg_3_1, "btn_item_") and systick() - to_n(arg_3_0.touch_tick) < 180 then
		UnitBuild:click_slots(to_n(string.sub(arg_3_1, -1, -1)), true)
	end
	
	if arg_3_1 == "btn_cancle_tooltip" then
		UnitBuild:closeItemTooltip()
	end
	
	if arg_3_1 == "btn_equip_arti" then
		if ContentDisable:byAlias("eq_arti_statistics") then
			balloon_message(T("content_disable"))
		elseif UnitBuild.vars and UnitBuild.vars.unit and UnitBuild.vars.unit.db and UnitBuild.vars.unit.db.code then
			Stove:openHeroEquipStatisticsPage(UnitBuild.vars.unit.db.code, STOVE_HERO_URL_PTYPE.hero_equip)
		end
	end
	
	if arg_3_1 == "btn_recom" then
		UnitBuild:openRecommendPopup()
	end
end

function HANDLER.equip_change_popup(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 == "btn_buy" then
		UnitBuild:reqTotalChange()
	elseif arg_4_1 == "btn_cancel" then
		UnitBuild:closeEquipChangePopup()
	end
end

function UnitBuild.onEnter(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	arg_5_0.vars.prev_mode = arg_5_1
	
	local var_5_0 = arg_5_0.vars.unit
	local var_5_1 = UnitBuild:_getSetList()
	
	if not get_cocos_refid(arg_5_0.vars.wnd) or not get_cocos_refid(UnitMain.vars.base_wnd) then
		arg_5_0.vars.wnd = load_dlg("equip_base", true, "wnd", function()
			UnitBuild:onPushBackButton()
		end)
		
		arg_5_0.vars.wnd:setLocalZOrder(10)
		
		arg_5_0.vars.back_layers = {}
		
		UnitMain.vars.base_wnd:addChild(arg_5_0.vars.wnd)
		
		arg_5_0.vars.cancle_wnd = arg_5_0.vars.wnd:getChildByName("btn_cancle")
		
		if_set_visible(arg_5_0.vars.cancle_wnd, nil, false)
		
		local var_5_2 = arg_5_0.vars.wnd:getChildByName("CENTER")
		local var_5_3 = var_5_2:getChildByName("n_head")
		local var_5_4
		
		TopBarNew:setTitleName(T("ui_equip_base_title"), "infoitem")
		
		local var_5_5 = var_5_2:getChildByName("txt_name")
		
		var_5_5:setString(T(var_5_0.db.name))
		UIUserData:proc(var_5_5)
		
		if var_5_3 then
			var_5_4 = getChildByPath(var_5_3, "star1")
		end
		
		if get_cocos_refid(var_5_4) then
			var_5_4:setPositionX(10 + var_5_5:getContentSize().width * var_5_5:getScaleX() + var_5_5:getPositionX())
			UIUtil:setStarsByUnit(var_5_3, var_5_0)
		end
		
		UIUtil:getRewardIcon("c", var_5_0:getDisplayCode(), {
			no_popup = true,
			no_grade = true,
			parent = arg_5_0.vars.wnd:getChildByName("mob_icon")
		})
		
		local var_5_6 = not ContentDisable:byAlias("eq_arti_statistics") and IS_PUBLISHER_STOVE
		
		if_set_visible(arg_5_0.vars.wnd, "btn_equip_arti", var_5_6)
		
		local var_5_7 = getChildByPath(var_5_3, "n_info")
		
		if_set_position_x(var_5_7, nil, var_5_6 and 279 or 430)
		UnitBuild:setUnitInfo(var_5_2, var_5_7, var_5_0)
		arg_5_0:getAllItems()
		arg_5_0:initListViewl()
		arg_5_0:setItemSlot(var_5_2, var_5_0)
		arg_5_0:update_currentStat(var_5_2, var_5_0)
		arg_5_0:update_changeStat({
			first = true
		})
		arg_5_0:setFilter(1, true)
		arg_5_0:selectItemTab(1)
		TopBarNew:setDisableTopRight()
		
		if not arg_5_0.vars.uiAction_off then
			local var_5_8 = arg_5_0.vars.wnd.c.CENTER
			local var_5_9 = arg_5_0.vars.wnd.c.n_side
			local var_5_10 = var_5_8:getPositionX()
			local var_5_11 = var_5_9:getPositionX()
			
			var_5_9:setPositionX(300 - VIEW_BASE_LEFT)
			var_5_8:setPositionX(-300 + VIEW_BASE_LEFT)
			UIAction:Add(LOG(MOVE_TO(400, var_5_11, 0)), var_5_9, "block")
			UIAction:Add(LOG(MOVE_TO(400, var_5_10, 0)), var_5_8, "block")
		end
		
		arg_5_0:setChangeButton()
		
		local var_5_12 = arg_5_0.vars.wnd:getChildByName("n_set_box")
		local var_5_13 = 2
		
		for iter_5_0, iter_5_1 in pairs(var_5_1) do
			local var_5_14 = DB("item_set", iter_5_1, {
				"name"
			})
			local var_5_15 = var_5_12:getChildByName("btn_sort" .. var_5_13)
			
			if var_5_15 == nil then
				break
			end
			
			if_set(var_5_15, "txt_sort" .. var_5_13, T(var_5_14))
			
			var_5_13 = var_5_13 + 1
		end
		
		local var_5_16 = arg_5_0.vars.wnd:getChildByName("n_substat_box")
		
		for iter_5_2 = 2, 12 do
			local var_5_17 = var_5_16:getChildByName("btn_sort" .. iter_5_2)
			
			if var_5_17 then
				if_set_visible(var_5_17:getChildByName("cursor"), "n_updown", true)
				if_set_visible(var_5_17:getChildByName("cursor_other"), "n_updown", true)
				if_set_visible(var_5_17:getChildByName("cursor"), "btn_up", false)
				if_set_visible(var_5_17:getChildByName("cursor"), "btn_down", true)
				if_set_visible(var_5_17:getChildByName("cursor_other"), "btn_up", false)
				if_set_visible(var_5_17:getChildByName("cursor_other"), "btn_down", true)
				var_5_17:getChildByName("cursor"):getChildByName("btn_up"):setTouchEnabled(false)
				var_5_17:getChildByName("cursor"):getChildByName("btn_down"):setTouchEnabled(false)
				var_5_17:getChildByName("cursor_other"):getChildByName("btn_up"):setTouchEnabled(false)
				var_5_17:getChildByName("cursor_other"):getChildByName("btn_down"):setTouchEnabled(false)
			end
		end
		
		local var_5_18 = arg_5_0.vars.wnd:getChildByName("n_mainstat_box")
		
		for iter_5_3 = 2, 12 do
			local var_5_19 = var_5_18:getChildByName("btn_sort" .. iter_5_3)
			
			if var_5_19 then
				if_set_visible(var_5_19:getChildByName("cursor"), "n_updown", true)
				if_set_visible(var_5_19:getChildByName("cursor_other"), "n_updown", true)
				if_set_visible(var_5_19:getChildByName("cursor"), "btn_up", false)
				if_set_visible(var_5_19:getChildByName("cursor"), "btn_down", true)
				if_set_visible(var_5_19:getChildByName("cursor_other"), "btn_up", false)
				if_set_visible(var_5_19:getChildByName("cursor_other"), "btn_down", true)
				var_5_19:getChildByName("cursor"):getChildByName("btn_up"):setTouchEnabled(false)
				var_5_19:getChildByName("cursor"):getChildByName("btn_down"):setTouchEnabled(false)
				var_5_19:getChildByName("cursor_other"):getChildByName("btn_up"):setTouchEnabled(false)
				var_5_19:getChildByName("cursor_other"):getChildByName("btn_down"):setTouchEnabled(false)
			end
		end
		
		arg_5_0.vars.is_active_booster = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
		
		if arg_5_0.vars.is_active_booster then
			if_set_visible(arg_5_0.vars.wnd, "event_badge", true)
		else
			if_set_visible(arg_5_0.vars.wnd, "event_badge", false)
		end
		
		local var_5_20 = var_5_2:getChildByName("n_change")
		
		if get_cocos_refid(var_5_20) then
			local var_5_21 = var_5_20:getChildByName("stat_down")
			local var_5_22 = var_5_20:getChildByName("stat_up")
			
			if get_cocos_refid(var_5_21) and get_cocos_refid(var_5_22) then
				arg_5_0.vars.change_power_pos_x = {}
				arg_5_0.vars.change_power_pos_x.stat_down = var_5_21:getPositionX()
				arg_5_0.vars.change_power_pos_x.stat_up = var_5_22:getPositionX()
			end
		end
	end
end

function UnitBuild.changeUnit(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	if not arg_7_1:isOrganizable() then
		Log.e("Error 장비 장착할 수 없는 영웅")
		
		return 
	end
	
	local var_7_0 = arg_7_1
	local var_7_1 = {
		uiAction_off = true,
		unit = var_7_0
	}
	local var_7_2 = {}
	
	if not table.empty(arg_7_0.vars.selected_equips) then
		var_7_2 = arg_7_0.vars.selected_equips
	end
	
	local var_7_3 = arg_7_0.vars.prev_mode
	
	arg_7_0.vars.wnd:removeFromParent()
	
	arg_7_0.vars = {}
	
	arg_7_0:onCreate(var_7_1)
	
	arg_7_0.vars.prev_mode = var_7_3
	
	if not table.empty(var_7_2) then
		for iter_7_0, iter_7_1 in pairs(var_7_2) do
			if arg_7_0.vars.allItems[iter_7_1.db.type] then
				for iter_7_2, iter_7_3 in pairs(arg_7_0.vars.allItems[iter_7_1.db.type]) do
					if iter_7_3:getUID() == iter_7_1:getUID() then
						UnitBuild:onSelect(iter_7_3)
						
						break
					end
				end
			end
		end
	end
	
	arg_7_0:closeItemTooltip()
end

function UnitBuild.cloneUnit(arg_8_0, arg_8_1)
	if arg_8_1:isGrowthBoostRegistered() then
		local var_8_0 = arg_8_1:clone()
		
		GrowthBoost:apply(var_8_0)
		
		return var_8_0
	end
	
	return arg_8_1:clone()
end

function UnitBuild.getSceneState(arg_9_0)
	if not arg_9_0.vars then
		return {}
	end
	
	return {
		unit_uid = arg_9_0.vars.unit:getUID()
	}
end

function UnitBuild.onCreate(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.unit
	
	if arg_10_1.unit_uid then
		var_10_0 = var_10_0 or Account:getUnit(arg_10_1.unit_uid)
	end
	
	if not var_10_0 then
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	local var_10_1 = arg_10_1 or {}
	
	arg_10_0.vars = {}
	arg_10_0.vars.changeIcons = {}
	arg_10_0.vars.curIcons = {}
	arg_10_0.vars.Original_equips = {}
	arg_10_0.vars.selected_equips = {}
	arg_10_0.vars.unit = arg_10_0:cloneUnit(var_10_0)
	arg_10_0.vars.prevStatus = arg_10_0.vars.unit:getStatus()
	arg_10_0.vars.items = {}
	arg_10_0.vars.showEquip_item = true
	arg_10_0.vars.filter = {}
	
	arg_10_0:initSetFilterOpts()
	
	arg_10_0.vars.filter.mainstat = var_10_1.mainstat or "all"
	arg_10_0.vars.filter.substat1 = var_10_1.substat1 or "all"
	arg_10_0.vars.filter.substat2 = var_10_1.substat2 or "all"
	arg_10_0.vars.filter.mainstat_isDesending = var_10_1.mainstat_isDesending or true
	arg_10_0.vars.filter.substat1_isDesending = var_10_1.substat1_isDesending or true
	arg_10_0.vars.filter.substat2_isDesending = var_10_1.substat2_isDesending or true
	arg_10_0.vars.filter.substat1_num = 1
	arg_10_0.vars.filter.substat2_num = 1
	arg_10_0.vars.filtersubstatPopup = 1
	arg_10_0.vars.portrait_scale = 0.6
	arg_10_0.vars.allItems = {}
	
	for iter_10_0, iter_10_1 in pairs(var_0_0) do
		arg_10_0.vars.allItems[iter_10_1] = {}
	end
	
	local var_10_2 = UnitBuild:_getSetList()
	
	arg_10_0.vars.itemsetCount = {}
	
	for iter_10_2, iter_10_3 in pairs(var_0_0) do
		arg_10_0.vars.itemsetCount[iter_10_3] = {}
		
		for iter_10_4, iter_10_5 in pairs(var_10_2) do
			arg_10_0.vars.itemsetCount[iter_10_3][iter_10_5] = 0
		end
	end
	
	arg_10_0.vars.uiAction_off = var_10_1.uiAction_off
	
	arg_10_0:onEnter()
	TutorialGuide:_startGuideFromCallback("equipmanager")
end

function UnitBuild.setUnitInfo(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not arg_11_1 or not get_cocos_refid(arg_11_1) or not arg_11_2 or not get_cocos_refid(arg_11_2) or not arg_11_3 then
		return 
	end
	
	if_set(arg_11_1, "txt_color", T("hero_ele_" .. tostring(arg_11_3.db.color)))
	if_set(arg_11_1, "txt_role", T("ui_hero_role_" .. arg_11_3.db.role))
	if_set(arg_11_1, "txt_zodiac", T(DB("zodiac_sphere_2", arg_11_3.db.zodiac, "name")))
	if_set_sprite(arg_11_2, "role", "img/cm_icon_role_" .. tostring(arg_11_3.db.role) .. ".png")
	if_set_sprite(arg_11_2, "color", "img/cm_icon_pro" .. tostring(arg_11_3.db.color) .. ".png")
	if_set_sprite(arg_11_2, "icon_zodiac", "img/cm_icon_zodiac_" .. string.split(arg_11_3.db.zodiac, "_")[1] .. ".png")
	
	local var_11_0 = arg_11_2:getChildByName("color")
	local var_11_1 = arg_11_2:getChildByName("role")
	
	if not var_11_0 or not var_11_1 then
		return 
	end
end

function UnitBuild.setItemSlot(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 then
		return 
	end
	
	local var_12_0 = arg_12_1:getChildByName("n_now")
	local var_12_1 = var_12_0:getChildByName("n_item")
	local var_12_2 = arg_12_1:getChildByName("n_change")
	local var_12_3 = var_12_2:getChildByName("n_item")
	
	for iter_12_0 = 1, 6 do
		local var_12_4 = arg_12_2:getEquipByIndex(iter_12_0)
		
		if var_12_4 then
			var_12_4.OriParent = var_12_4.parent
			arg_12_0.vars.Original_equips[var_12_4.db.type] = var_12_4
			var_12_4.cloneParent = arg_12_0.vars.unit
		end
		
		local var_12_5 = var_12_0:getChildByName("item_slot" .. iter_12_0):getChildByName("n_item1")
		
		var_12_5:removeAllChildren()
		
		local var_12_6 = var_12_2:getChildByName("item_slot" .. iter_12_0)
		local var_12_7 = var_12_6:getChildByName("n_item" .. iter_12_0)
		
		var_12_7:removeAllChildren()
		
		if var_12_4 ~= nil then
			UIUtil:getRewardIcon("equip", var_12_4.code, {
				scale = 1,
				tooltip_delay = 120,
				parent = var_12_5,
				equip = var_12_4
			}):setName("item" .. iter_12_0)
			
			local var_12_8 = UIUtil:getRewardIcon("equip", var_12_4.code, {
				scale = 1,
				tooltip_delay = 120,
				parent = var_12_7,
				equip = var_12_4
			})
			
			var_12_8:setName("item" .. iter_12_0)
			var_12_8:setOpacity(76.5)
			if_set_visible(var_12_6, "icon_" .. iter_12_0, false)
		end
	end
end

function UnitBuild.onPushBackButton(arg_13_0)
	if arg_13_0.vars.prev_mode ~= nil then
		local var_13_0
		
		if arg_13_0.vars.prev_mode == "Detail" then
			var_13_0 = UnitDetail:getPrevDetailMode() or "Equip"
		end
		
		UnitMain:setMode(arg_13_0.vars.prev_mode, {
			unit = Account:getUnit(arg_13_0.vars.unit:getUID()),
			detail_mode = var_13_0
		})
	else
		SceneManager:nextScene("lobby")
	end
end

function UnitBuild.update_currentStat(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_1:getChildByName("n_stat_now")
	local var_14_1 = arg_14_1:getChildByName("n_now")
	local var_14_2 = arg_14_1:getChildByName("n_set_now")
	local var_14_3 = arg_14_2:getStat()
	local var_14_4 = arg_14_2:getStatus()
	
	if_set(var_14_1, "label", T("unit_power"))
	if_set(var_14_0, "txt_name_stat_att", getStatName("att"))
	if_set(var_14_0, "txt_name_stat_def", getStatName("def"))
	if_set(var_14_0, "txt_name_stat_maxhp", getStatName("max_hp"))
	if_set(var_14_0, "txt_name_stat_spd", getStatName("speed"))
	if_set(var_14_0, "txt_name_stat_cri", getStatName("cri"))
	if_set(var_14_0, "txt_name_stat_cridmg", getStatName("cri_dmg"))
	if_set(var_14_0, "txt_name_stat_con", getStatName("acc"))
	if_set(var_14_0, "txt_name_stat_res", getStatName("res"))
	if_set(var_14_0, "txt_name_stat_coop", getStatName("coop"))
	if_set(var_14_1, "txt_stat", comma_value(arg_14_2:getPoint(var_14_4)))
	if_set(var_14_0, "txt_stat_att", var_14_4.att)
	if_set(var_14_0, "txt_stat_def", var_14_4.def)
	if_set(var_14_0, "txt_stat_maxhp", var_14_4.max_hp)
	if_set(var_14_0, "txt_stat_spd", var_14_4.speed)
	if_set(var_14_0, "txt_stat_cri", var_14_4.cri, false, "ratioExpand")
	if_set(var_14_0, "txt_stat_cridmg", var_14_4.cri_dmg, false, "ratioExpand")
	if_set(var_14_0, "txt_stat_con", var_14_4.acc, false, "ratioExpand")
	if_set(var_14_0, "txt_stat_res", var_14_4.res, false, "ratioExpand")
	if_set(var_14_0, "txt_stat_coop", var_14_4.coop, false, "ratioExpand")
	
	if FORMULA.isMoreThanStatLimit("cri", var_14_4.cri) then
		if_set_color(var_14_0, "txt_stat_cri", UIUtil.ORANGE)
	else
		if_set_color(var_14_0, "txt_stat_cri", UIUtil.WHITE)
	end
	
	if FORMULA.isMoreThanStatLimit("cri_dmg", var_14_4.cri_dmg) then
		if_set_color(var_14_0, "txt_stat_cridmg", UIUtil.ORANGE)
	else
		if_set_color(var_14_0, "txt_stat_cridmg", UIUtil.WHITE)
	end
	
	if FORMULA.isMoreThanStatLimit("coop", var_14_4.coop) then
		if_set_color(var_14_0, "txt_stat_coop", UIUtil.ORANGE)
	else
		if_set_color(var_14_0, "txt_stat_coop", UIUtil.WHITE)
	end
	
	UnitBuild.vars.setCount = 1
	
	arg_14_2:eachSetItemApply(function(arg_15_0)
		local var_15_0 = UnitBuild.vars.setCount
		
		SpriteCache:resetSprite(var_14_2:getChildByName("set_" .. var_15_0), EQUIP:getSetItemIconPath(arg_15_0))
		if_set(var_14_2, "label_set_" .. var_15_0, T(DB("item_set", arg_15_0, "name")))
		if_set_opacity(var_14_2, "set_" .. var_15_0, 255)
		
		UnitBuild.vars.setCount = UnitBuild.vars.setCount + 1
	end)
	
	for iter_14_0 = UnitBuild.vars.setCount, 3 do
		SpriteCache:resetSprite(var_14_2:getChildByName("set_" .. iter_14_0), "img/cm_icon_etcbattle.png")
		if_set(var_14_2, "label_set_" .. iter_14_0, T("no_set"))
		if_set_opacity(var_14_2, "set_" .. iter_14_0, 76.5)
	end
end

function UnitBuild.selectItemTab(arg_16_0, arg_16_1)
	arg_16_0:moveTabSelector(arg_16_0.vars.wnd:getChildByName("n_tab"), arg_16_1)
	
	if arg_16_0.tab ~= arg_16_1 then
		arg_16_0:setCurrentMaxUid(arg_16_0.tab)
	end
	
	arg_16_0.tab = arg_16_1
	
	arg_16_0:setItemSetCount()
	arg_16_0:closeItemTooltip()
	arg_16_0:refreshItems({
		reset = true
	})
	arg_16_0:showEquipItem()
	
	local var_16_0 = UnitBuild:getCurrentCategoryName() or nil
	
	if arg_16_0.vars.selected_equips and var_16_0 and arg_16_0.vars.selected_equips[var_16_0] then
		arg_16_0.vars.cur_item = arg_16_0.vars.selected_equips[var_16_0]
	else
		arg_16_0.vars.cur_item = nil
	end
	
	arg_16_0:set_equipEnhanceButton()
end

function UnitBuild.refreshItems(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1 or {}
	
	if not arg_17_0.vars then
		return 
	end
	
	if arg_17_0.vars and not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_1 = arg_17_0:getCurrentCategoryName()
	
	if not arg_17_0.vars.items[var_17_1] or var_17_0.reset == true then
		arg_17_0.vars.items[var_17_1] = arg_17_0:selectItems()
	end
	
	if not arg_17_0.vars.sorter or arg_17_0.vars.sorter == nil then
		arg_17_0.vars.sorter = Sorter:create(arg_17_0.vars.wnd:getChildByName("n_sort"))
		
		arg_17_0.vars.sorter:setSorter({
			checkboxs = {
				{
					id = "equip_item",
					is_filter = true,
					name = T("sort_hide_equipped"),
					checked = not arg_17_0.vars.showEquip_item
				}
			},
			default_sort_index = Account:getConfigData("inven_equip_sort_index") or 3,
			menus = {
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
			},
			callback_sort = function(arg_18_0, arg_18_1)
				SAVE:setTempConfigData("inven_equip_sort_index", arg_18_1)
				arg_17_0:resetListView()
			end,
			callback_checkbox = function(arg_19_0, arg_19_1, arg_19_2)
				if arg_19_0 == "equip_item" then
					arg_17_0.vars.showEquip_item = not arg_17_0.vars.showEquip_item
					
					arg_17_0:showEquipItem()
				end
			end
		})
	end
	
	arg_17_0.vars.sorter:setItems(arg_17_0.vars.items[var_17_1])
	arg_17_0:resetListView()
end

function UnitBuild.showEquipItem(arg_20_0)
	if arg_20_0.vars.showEquip_item == true then
		for iter_20_0, iter_20_1 in pairs(var_0_0) do
			if arg_20_0.vars.items[iter_20_1] and arg_20_0.vars.allItems[iter_20_1] then
				for iter_20_2, iter_20_3 in pairs(arg_20_0.vars.allItems[iter_20_1]) do
					if iter_20_3.OriParent and iter_20_3.OriParent ~= nil and arg_20_0:checkoverlap(iter_20_3) and arg_20_0:checkFilterOptions(iter_20_3) == true then
						table.insert(arg_20_0.vars.items[iter_20_1], iter_20_3)
					end
				end
			end
		end
	elseif arg_20_0.vars.showEquip_item == false then
		for iter_20_4, iter_20_5 in pairs(var_0_0) do
			if arg_20_0.vars.items[iter_20_5] then
				for iter_20_6 = #arg_20_0.vars.items[iter_20_5], 1, -1 do
					if arg_20_0.vars.items[iter_20_5][iter_20_6] and arg_20_0.vars.items[iter_20_5][iter_20_6].OriParent and arg_20_0.vars.items[iter_20_5][iter_20_6].OriParent ~= nil then
						table.remove(arg_20_0.vars.items[iter_20_5], iter_20_6)
					end
				end
			end
		end
	end
	
	arg_20_0:resetListView()
	arg_20_0.vars.sorter:sort()
end

function UnitBuild.checkoverlap(arg_21_0, arg_21_1)
	if not arg_21_1 or not arg_21_0.vars.items[arg_21_1.db.type] then
		return 
	end
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.items[arg_21_1.db.type]) do
		if arg_21_1:getUID() == iter_21_1:getUID() then
			return false
		end
	end
	
	return true
end

function UnitBuild.initSetFilterOpts(arg_22_0)
	if not arg_22_0.vars or not arg_22_0.vars.filter then
		return 
	end
	
	arg_22_0.vars.filter.set = {}
	
	local var_22_0 = UnitBuild:_getSetList(true)
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		arg_22_0.vars.filter.set[iter_22_1] = false
	end
	
	arg_22_0.vars.filter.set.all = true
end

function UnitBuild.toggle_setFilterOpts(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return 
	end
	
	if arg_23_1 == "all" then
		arg_23_0:initSetFilterOpts()
		
		return false
	end
	
	arg_23_0.vars.filter.set.all = false
	
	if arg_23_0.vars.filter.set[arg_23_1] ~= nil then
		arg_23_0.vars.filter.set[arg_23_1] = not arg_23_0.vars.filter.set[arg_23_1]
	end
	
	return arg_23_0.vars.filter.set[arg_23_1]
end

function UnitBuild.check_setFilterOpts(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return false
	end
	
	if arg_24_0.vars.filter.set.all == true or arg_24_0.vars.filter.set[arg_24_1] then
		return true
	end
	
	return false
end

function UnitBuild.checkDescendingOptions(arg_25_0, arg_25_1)
	if arg_25_1 and table.empty(arg_25_1) then
	end
	
	table.sort(arg_25_1, function(arg_26_0, arg_26_1)
		return UnitBuild.checkSubStat_DescendingOptions(arg_26_0, arg_26_1, UnitBuild.vars.filter.substat1, UnitBuild.vars.filter.substat2)
	end)
end

function UnitBuild.checkSubStat_DescendingOptions(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_0 == arg_27_1 then
		return false
	end
	
	local var_27_0 = not UnitBuild.vars.filter.mainstat_isDesending
	local var_27_1 = not UnitBuild.vars.filter.substat1_isDesending
	local var_27_2 = not UnitBuild.vars.filter.substat2_isDesending
	local var_27_3 = false
	local var_27_4 = 0
	local var_27_5 = 0
	
	for iter_27_0 = 2, 99 do
		if arg_27_0.op[iter_27_0] then
			local var_27_6 = arg_27_0.op[iter_27_0][1]
			local var_27_7 = arg_27_0.op[iter_27_0][2]
			
			if var_27_6 == arg_27_2 then
				var_27_4 = var_27_4 + (var_27_7 or 0)
			elseif var_27_6 == arg_27_3 then
				var_27_5 = var_27_5 + (var_27_7 or 0)
			end
		elseif not arg_27_0.op[iter_27_0] then
			break
		end
	end
	
	local var_27_8 = 0
	local var_27_9 = 0
	
	for iter_27_1 = 2, 99 do
		if arg_27_1.op[iter_27_1] then
			local var_27_10 = arg_27_1.op[iter_27_1][1]
			local var_27_11 = arg_27_1.op[iter_27_1][2]
			
			if var_27_10 == arg_27_2 then
				var_27_8 = var_27_8 + (var_27_11 or 0)
			elseif var_27_10 == arg_27_3 then
				var_27_9 = var_27_9 + (var_27_11 or 0)
			end
		elseif not arg_27_1.op[iter_27_1] then
			break
		end
	end
	
	local var_27_12 = 0
	local var_27_13 = 0
	
	if UnitBuild.vars.filter.mainstat ~= "all" then
		local var_27_14, var_27_15 = arg_27_0:getMainStat()
		local var_27_16, var_27_17 = arg_27_1:getMainStat()
		local var_27_18
		
		var_27_18 = string.find(var_27_15, "_rate") ~= nil
		
		local var_27_19
		
		var_27_19 = string.find(var_27_17, "_rate") ~= nil
		
		if var_27_14 ~= var_27_16 then
			if var_27_0 then
				if var_27_16 < var_27_14 then
					var_27_13 = var_27_13 + 1000
				else
					var_27_12 = var_27_12 + 1000
				end
			elseif var_27_16 < var_27_14 then
				var_27_12 = var_27_12 + 1000
			else
				var_27_13 = var_27_13 + 1000
			end
		end
	end
	
	if arg_27_2 ~= "all" and var_27_4 ~= var_27_8 then
		if var_27_1 then
			if var_27_8 < var_27_4 then
				var_27_13 = var_27_13 + 100
			else
				var_27_12 = var_27_12 + 100
			end
		elseif var_27_8 < var_27_4 then
			var_27_12 = var_27_12 + 100
		else
			var_27_13 = var_27_13 + 100
		end
	end
	
	if arg_27_3 ~= "all" and var_27_5 ~= var_27_9 then
		if var_27_2 then
			if var_27_9 < var_27_5 then
				var_27_13 = var_27_13 + 10
			else
				var_27_12 = var_27_12 + 10
			end
		elseif var_27_9 < var_27_5 then
			var_27_12 = var_27_12 + 10
		else
			var_27_13 = var_27_13 + 10
		end
	end
	
	if UnitBuild.vars.sorter and UnitBuild.vars.sorter.vars.index ~= nil then
		local var_27_20 = UnitBuild.vars.sorter.vars.index or 0
		
		if var_27_20 < 0 then
			var_27_3 = true
			var_27_20 = var_27_20 * -1
		end
		
		if UnitBuild.vars.sorter.vars.menus[var_27_20] then
			local var_27_21 = UnitBuild.vars.sorter.vars.menus[var_27_20].func(arg_27_0, arg_27_1)
			
			if var_27_3 then
				if var_27_21 then
					var_27_13 = var_27_13 + 1
				else
					var_27_12 = var_27_12 + 1
				end
			elseif var_27_21 then
				var_27_12 = var_27_12 + 1
			else
				var_27_13 = var_27_13 + 1
			end
		end
	end
	
	if var_27_12 == var_27_13 then
		return false
	end
	
	return var_27_13 < var_27_12
end

function UnitBuild.checkFilterOptions(arg_28_0, arg_28_1)
	if arg_28_1 == nil then
		return false
	end
	
	if arg_28_0.vars.filter.set.all and arg_28_0.vars.filter.mainstat == "all" and arg_28_0.vars.filter.substat1 == "all" and arg_28_0.vars.filter.substat2 == "all" then
		return true
	end
	
	if arg_28_0:check_setFilterOpts(arg_28_1.set_fx) then
		local var_28_0, var_28_1 = arg_28_1:getMainStat()
		
		if arg_28_0.vars.filter.mainstat == "all" or arg_28_0.vars.filter.mainstat == var_28_1 then
			if arg_28_0.vars.filter.substat1 == "all" and arg_28_0.vars.filter.substat2 == "all" then
				return true
			end
			
			if arg_28_0.vars.filter.substat1 == "all" or arg_28_0.vars.filter.substat2 == "all" then
				for iter_28_0, iter_28_1 in pairs(arg_28_1.op) do
					if iter_28_0 ~= 1 and iter_28_1[1] and (iter_28_1[1] == arg_28_0.vars.filter.substat1 or iter_28_1[1] == arg_28_0.vars.filter.substat2) then
						return true
					end
				end
			end
			
			local var_28_2 = false
			local var_28_3 = false
			
			if arg_28_0.vars.filter.substat1 ~= "all" and arg_28_0.vars.filter.substat2 ~= "all" then
				for iter_28_2, iter_28_3 in pairs(arg_28_1.op) do
					if iter_28_2 ~= 1 and iter_28_3[1] then
						if iter_28_3[1] == arg_28_0.vars.filter.substat1 then
							var_28_2 = true
						elseif iter_28_3[1] == arg_28_0.vars.filter.substat2 then
							var_28_3 = true
						end
					end
				end
			end
			
			if var_28_2 and var_28_3 then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

local var_0_1 = {
	"att",
	"def",
	"max_hp",
	"att_rate",
	"def_rate",
	"max_hp_rate",
	"speed",
	"cri",
	"cri_dmg",
	"acc",
	"res"
}
local var_0_2 = {
	"att",
	"def",
	"max_hp",
	"att",
	"def",
	"max_hp",
	"speed",
	"cri",
	"cri_dmg",
	"acc",
	"res"
}

function UnitBuild.setFilter(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_2 == nil then
		arg_29_2 = false
	elseif arg_29_2 == true then
		arg_29_1 = 1
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("n_set_box")
	local var_29_1 = arg_29_0.vars.wnd:getChildByName("n_mainstat_box")
	local var_29_2 = arg_29_0.vars.wnd:getChildByName("n_substat_box")
	local var_29_3 = arg_29_0.vars.filter.substat1
	local var_29_4 = arg_29_0.vars.filter.substat2
	local var_29_5 = arg_29_0.vars.filter.substat1_num
	local var_29_6 = arg_29_0.vars.filter.substat2_num
	local var_29_7 = "all"
	local var_29_8 = UnitBuild:_getSetList()
	
	if var_29_0:isVisible() or arg_29_2 == true then
		local var_29_9 = false
		
		if arg_29_1 == 1 then
			arg_29_0:toggle_setFilterOpts("all")
		elseif arg_29_1 > 1 then
			local var_29_10 = var_29_8[arg_29_1 - 1]
			
			var_29_7, var_29_9 = string.split(var_29_10, "_")[2], arg_29_0:toggle_setFilterOpts(var_29_10)
		end
		
		local var_29_11 = true
		
		for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.filter.set) do
			if iter_29_1 == true then
				var_29_11 = false
			end
		end
		
		if arg_29_1 == 1 or var_29_11 then
			arg_29_0:toggle_setFilterOpts("all")
			
			var_29_7 = "all"
			arg_29_1 = 1
			
			if_set_visible(var_29_0:getChildByName("btn_sort" .. 1), "cursor", true)
			if_set_opacity(var_29_0, "txt_sort1", 255)
			if_set_color(var_29_0, "txt_sort1", tocolor("#6bc11b"))
			if_set_color(var_29_0, "icon_sort1", tocolor("#6bc11b"))
			
			for iter_29_2 = 2, table.count(var_29_8) + 1 do
				if_set_visible(var_29_0:getChildByName("btn_sort" .. iter_29_2), "cursor", false)
				if_set_opacity(var_29_0, "txt_sort" .. iter_29_2, 76.5)
				if_set_color(var_29_0, "txt_sort" .. iter_29_2, tocolor("#FFFFFF"))
			end
			
			for iter_29_3 = 1, table.count(var_29_8) + 1 do
				local var_29_12 = var_29_0:getChildByName("checkbox_set_" .. iter_29_3)
				
				if var_29_12 then
					var_29_12:setSelected(iter_29_3 == 1)
				end
			end
		else
			if_set_visible(var_29_0:getChildByName("btn_sort" .. 1), "cursor", false)
			if_set_visible(var_29_0:getChildByName("btn_sort" .. arg_29_1), "cursor", var_29_9)
			
			local var_29_13 = var_29_0:getChildByName("checkbox_set_" .. arg_29_1)
			
			if var_29_13 then
				var_29_13:setSelected(var_29_9)
			end
			
			if var_29_9 then
				if_set_opacity(var_29_0, "txt_sort" .. arg_29_1, 255)
				if_set_color(var_29_0, "txt_sort" .. arg_29_1, tocolor("#6bc11b"))
			else
				if_set_opacity(var_29_0, "txt_sort" .. arg_29_1, 76.5)
				if_set_color(var_29_0, "txt_sort" .. arg_29_1, tocolor("#FFFFFF"))
			end
			
			local var_29_14 = var_29_0:getChildByName("checkbox_set_1")
			
			if var_29_14 then
				var_29_14:setSelected(false)
			end
			
			if_set_color(var_29_0, "icon_sort1", tocolor("#FFFFFF"))
			if_set_color(var_29_0, "txt_sort1", tocolor("#FFFFFF"))
		end
		
		arg_29_0:setFilter_setIcons()
	end
	
	if var_29_1:isVisible() or arg_29_2 == true then
		local var_29_15 = ""
		
		if arg_29_1 == 1 then
			var_29_15 = "all"
		elseif arg_29_1 > 1 then
			var_29_15 = var_0_1[arg_29_1 - 1]
			var_29_7 = var_0_2[arg_29_1 - 1]
		end
		
		if var_29_15 == arg_29_0.vars.filter.mainstat then
			arg_29_0.vars.filter.mainstat_isDesending = not arg_29_0.vars.filter.mainstat_isDesending
		else
			arg_29_0.vars.filter.mainstat_isDesending = true
		end
		
		local var_29_16 = var_29_1:getChildByName("btn_sort" .. arg_29_1)
		
		if var_29_16 then
			if_set_visible(var_29_16:getChildByName("cursor"), "btn_up", not arg_29_0.vars.filter.mainstat_isDesending)
			if_set_visible(var_29_16:getChildByName("cursor"), "btn_down", arg_29_0.vars.filter.mainstat_isDesending)
			if_set_visible(var_29_16:getChildByName("cursor_other"), "btn_up", not arg_29_0.vars.filter.mainstat_isDesending)
			if_set_visible(var_29_16:getChildByName("cursor_other"), "btn_down", arg_29_0.vars.filter.mainstat_isDesending)
		end
		
		arg_29_0.vars.filter.mainstat = var_29_15
		
		for iter_29_4 = 1, 12 do
			if arg_29_1 == iter_29_4 then
				if_set_visible(var_29_1:getChildByName("btn_sort" .. iter_29_4), "cursor", true)
			else
				if_set_visible(var_29_1:getChildByName("btn_sort" .. iter_29_4), "cursor", false)
			end
		end
		
		local var_29_17 = arg_29_0.vars.wnd:getChildByName("btn_mainstat")
		local var_29_18 = arg_29_0.vars.wnd:getChildByName("btn_mainstat_done")
		
		if arg_29_0.vars.filter.mainstat == "all" then
			if_set_visible(var_29_17, "icon_all", true)
			if_set_visible(var_29_17, "icon_stat", false)
			if_set_visible(var_29_18, "icon_all", true)
			if_set_visible(var_29_18, "icon_stat", false)
		else
			if_set_visible(var_29_17, "icon_all", false)
			if_set_visible(var_29_17, "icon_stat", true)
			if_set_visible(var_29_18, "icon_all", false)
			if_set_visible(var_29_18, "icon_stat", true)
			if_set_sprite(var_29_17, "icon_stat", "img/icon_menu_" .. var_29_7 .. ".png")
			if_set_sprite(var_29_18, "icon_stat", "img/icon_menu_" .. var_29_7 .. ".png")
		end
		
		if string.find(arg_29_0.vars.filter.mainstat, "rate") then
			if_set_visible(var_29_17, "icon_pers", true)
			if_set_visible(var_29_18, "icon_pers", true)
		else
			if_set_visible(var_29_17, "icon_pers", false)
			if_set_visible(var_29_18, "icon_pers", false)
		end
		
		arg_29_0:close_mainstatBox()
	end
	
	if var_29_2:isVisible() or arg_29_2 == true then
		if arg_29_0.vars.filtersubstatPopup == 1 or arg_29_2 == true then
			if arg_29_1 == 1 then
				arg_29_0.vars.filter.substat1 = "all"
			elseif arg_29_1 > 1 then
				arg_29_0.vars.filter.substat1 = var_0_1[arg_29_1 - 1]
				var_29_7 = var_0_2[arg_29_1 - 1]
			end
			
			local var_29_19 = arg_29_0.vars.wnd:getChildByName("btn_substat1")
			local var_29_20 = arg_29_0.vars.wnd:getChildByName("btn_substat1_done")
			
			if arg_29_0.vars.filter.substat1 == "all" then
				if_set_visible(var_29_19, "icon_all", true)
				if_set_visible(var_29_19, "icon_stat", false)
				if_set_visible(var_29_20, "icon_all", true)
				if_set_visible(var_29_20, "icon_stat", false)
			else
				if_set_visible(var_29_19, "icon_all", false)
				if_set_visible(var_29_19, "icon_stat", true)
				if_set_visible(var_29_20, "icon_all", false)
				if_set_visible(var_29_20, "icon_stat", true)
				if_set_sprite(var_29_19, "icon_stat", "img/icon_menu_" .. var_29_7 .. ".png")
				if_set_sprite(var_29_20, "icon_stat", "img/icon_menu_" .. var_29_7 .. ".png")
			end
			
			arg_29_0:setSubFilterPercentIcon(1)
			
			if arg_29_0.vars.filter.substat1_num == arg_29_1 then
				arg_29_0.vars.filter.substat1_isDesending = not arg_29_0.vars.filter.substat1_isDesending
			else
				arg_29_0.vars.filter.substat1_isDesending = true
			end
			
			local var_29_21 = var_29_2:getChildByName("btn_sort" .. arg_29_1)
			
			if var_29_21 then
				if_set_visible(var_29_21:getChildByName("cursor"), "btn_up", not arg_29_0.vars.filter.substat1_isDesending)
				if_set_visible(var_29_21:getChildByName("cursor"), "btn_down", arg_29_0.vars.filter.substat1_isDesending)
				if_set_visible(var_29_21:getChildByName("cursor_other"), "btn_up", not arg_29_0.vars.filter.substat1_isDesending)
				if_set_visible(var_29_21:getChildByName("cursor_other"), "btn_down", arg_29_0.vars.filter.substat1_isDesending)
			end
			
			arg_29_0.vars.filter.substat1_num = arg_29_1
			
			arg_29_0:close_substatBox(arg_29_0.vars.filtersubstatPopup)
		end
		
		if arg_29_0.vars.filtersubstatPopup == 2 or arg_29_2 == true then
			if arg_29_1 == 1 then
				arg_29_0.vars.filter.substat2 = "all"
			elseif arg_29_1 > 1 then
				arg_29_0.vars.filter.substat2 = var_0_1[arg_29_1 - 1]
				var_29_7 = var_0_2[arg_29_1 - 1]
			end
			
			local var_29_22 = arg_29_0.vars.wnd:getChildByName("btn_substat2")
			local var_29_23 = arg_29_0.vars.wnd:getChildByName("btn_substat2_done")
			
			if arg_29_0.vars.filter.substat2 == "all" then
				if_set_visible(var_29_22, "icon_all", true)
				if_set_visible(var_29_22, "icon_stat", false)
				if_set_visible(var_29_23, "icon_all", true)
				if_set_visible(var_29_23, "icon_stat", false)
			else
				if_set_visible(var_29_22, "icon_all", false)
				if_set_visible(var_29_22, "icon_stat", true)
				if_set_visible(var_29_23, "icon_all", false)
				if_set_visible(var_29_23, "icon_stat", true)
				if_set_sprite(var_29_22, "icon_stat", "img/icon_menu_" .. var_29_7 .. ".png")
				if_set_sprite(var_29_23, "icon_stat", "img/icon_menu_" .. var_29_7 .. ".png")
			end
			
			arg_29_0:setSubFilterPercentIcon(2)
			
			if arg_29_0.vars.filter.substat2_num == arg_29_1 then
				arg_29_0.vars.filter.substat2_isDesending = not arg_29_0.vars.filter.substat2_isDesending
			else
				arg_29_0.vars.filter.substat2_isDesending = true
			end
			
			local var_29_24 = var_29_2:getChildByName("btn_sort" .. arg_29_1)
			
			if var_29_24 then
				if_set_visible(var_29_24:getChildByName("cursor"), "btn_up", not arg_29_0.vars.filter.substat2_isDesending)
				if_set_visible(var_29_24:getChildByName("cursor"), "btn_down", arg_29_0.vars.filter.substat2_isDesending)
				if_set_visible(var_29_24:getChildByName("cursor_other"), "btn_up", not arg_29_0.vars.filter.substat2_isDesending)
				if_set_visible(var_29_24:getChildByName("cursor_other"), "btn_down", arg_29_0.vars.filter.substat2_isDesending)
			end
			
			arg_29_0.vars.filter.substat2_num = arg_29_1
			
			if arg_29_2 == true then
				arg_29_0:close_substatBox(2)
			else
				arg_29_0:close_substatBox(arg_29_0.vars.filtersubstatPopup)
			end
		end
		
		if arg_29_0.vars.filter.substat1 == arg_29_0.vars.filter.substat2 and arg_29_0.vars.filter.substat1 ~= "all" and arg_29_0.vars.filter.substat2 ~= "all" then
			local var_29_25
			
			for iter_29_5, iter_29_6 in pairs(var_0_1) do
				if var_29_3 == iter_29_6 then
					var_29_25 = var_0_2[iter_29_5]
				end
			end
			
			local var_29_26
			
			for iter_29_7, iter_29_8 in pairs(var_0_1) do
				if var_29_4 == iter_29_8 then
					var_29_26 = var_0_2[iter_29_7]
				end
			end
			
			arg_29_0.vars.filter.substat1 = var_29_4
			arg_29_0.vars.filter.substat2 = var_29_3
			arg_29_0.vars.filter.substat1_num = var_29_6
			arg_29_0.vars.filter.substat2_num = var_29_5
			
			local var_29_27 = arg_29_0.vars.wnd:getChildByName("btn_substat1")
			local var_29_28 = arg_29_0.vars.wnd:getChildByName("btn_substat1_done")
			local var_29_29 = arg_29_0.vars.wnd:getChildByName("btn_substat2")
			local var_29_30 = arg_29_0.vars.wnd:getChildByName("btn_substat2_done")
			
			if var_29_25 and var_29_26 then
				if_set_sprite(var_29_29, "icon_stat", "img/icon_menu_" .. var_29_25 .. ".png")
				if_set_sprite(var_29_30, "icon_stat", "img/icon_menu_" .. var_29_25 .. ".png")
				if_set_sprite(var_29_27, "icon_stat", "img/icon_menu_" .. var_29_26 .. ".png")
				if_set_sprite(var_29_28, "icon_stat", "img/icon_menu_" .. var_29_26 .. ".png")
			end
			
			arg_29_0:setSubFilterPercentIcon(1)
			arg_29_0:setSubFilterPercentIcon(2)
			
			if arg_29_0.vars.filter.substat1 == "all" then
				if_set_visible(var_29_27, "icon_all", true)
				if_set_visible(var_29_27, "icon_stat", false)
				if_set_visible(var_29_28, "icon_all", true)
				if_set_visible(var_29_28, "icon_stat", false)
			end
			
			if arg_29_0.vars.filter.substat2 == "all" then
				if_set_visible(var_29_29, "icon_all", true)
				if_set_visible(var_29_29, "icon_stat", false)
				if_set_visible(var_29_30, "icon_all", true)
				if_set_visible(var_29_30, "icon_stat", false)
			end
		end
	end
	
	arg_29_0:refreshItems({
		reset = true
	})
end

function UnitBuild.setSubFilterPercentIcon(arg_30_0, arg_30_1)
	if not arg_30_1 then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("btn_substat" .. arg_30_1)
	local var_30_1 = arg_30_0.vars.wnd:getChildByName("btn_substat" .. arg_30_1 .. "_done")
	
	if not get_cocos_refid(var_30_0) or not get_cocos_refid(var_30_1) then
		return 
	end
	
	local var_30_2
	
	if arg_30_1 == 1 then
		var_30_2 = arg_30_0.vars.filter.substat1
	else
		var_30_2 = arg_30_0.vars.filter.substat2
	end
	
	if string.find(var_30_2, "rate") then
		if_set_visible(var_30_0, "icon_pers", true)
		if_set_visible(var_30_1, "icon_pers", true)
	else
		if_set_visible(var_30_0, "icon_pers", false)
		if_set_visible(var_30_1, "icon_pers", false)
	end
end

function UnitBuild.setFilter_setIcons(arg_31_0)
	if not arg_31_0.vars or not arg_31_0.vars.wnd or not get_cocos_refid(arg_31_0.vars.wnd) or not arg_31_0.vars.filter or not arg_31_0.vars.filter.set then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.filter.set.all
	local var_31_1 = arg_31_0.vars.wnd:getChildByName("btn_set")
	local var_31_2 = arg_31_0.vars.wnd:getChildByName("btn_set_done")
	local var_31_3 = 14
	local var_31_4 = 0
	local var_31_5 = T("ui_equip_base_filter_set")
	
	if var_31_0 then
		if_set_visible(var_31_1, "icon_all", true)
		if_set_visible(var_31_2, "icon_all", true)
		
		for iter_31_0 = 1, var_31_3 do
			if_set_visible(var_31_1, "icon_stat_" .. iter_31_0, false)
			if_set_visible(var_31_2, "icon_stat_" .. iter_31_0, false)
		end
		
		if_set(var_31_1, "label", var_31_5)
		if_set(var_31_2, "label", var_31_5)
	else
		if_set_visible(var_31_1, "icon_all", false)
		if_set_visible(var_31_2, "icon_all", false)
		
		local var_31_6 = UnitBuild:_getSetList()
		
		for iter_31_1, iter_31_2 in pairs(var_31_6) do
			if arg_31_0.vars.filter.set[iter_31_2] == true then
				var_31_4 = var_31_4 + 1
				
				if var_31_4 <= var_31_3 then
					local var_31_7 = string.gsub(iter_31_2, "set_", "") or ""
					
					if_set_sprite(var_31_1, "icon_stat_" .. var_31_4, "item/icon_set_" .. var_31_7 .. ".png")
					if_set_sprite(var_31_2, "icon_stat_" .. var_31_4, "item/icon_set_" .. var_31_7 .. ".png")
					if_set_visible(var_31_1, "icon_stat_" .. var_31_4, true)
					if_set_visible(var_31_2, "icon_stat_" .. var_31_4, true)
				end
			end
		end
		
		if var_31_3 >= var_31_4 + 1 then
			for iter_31_3 = var_31_4 + 1, var_31_3 do
				if_set_visible(var_31_1, "icon_stat_" .. iter_31_3, false)
				if_set_visible(var_31_2, "icon_stat_" .. iter_31_3, false)
			end
		end
	end
	
	if not arg_31_0.vars.setLabel_oriPosX then
		arg_31_0.vars.setLabel_oriPosX = var_31_1:getChildByName("label"):getPositionX()
	end
	
	if var_31_4 > 1 then
		local var_31_8 = var_31_4 - 1
		
		if var_31_3 < var_31_4 then
			var_31_8 = var_31_3 - 1
			var_31_5 = "⋯ " .. var_31_5
		end
		
		if_set(var_31_1, "label", var_31_5)
		if_set(var_31_2, "label", var_31_5)
		var_31_1:getChildByName("label"):setPositionX(arg_31_0.vars.setLabel_oriPosX + var_31_8 * 33.5)
		var_31_2:getChildByName("label"):setPositionX(arg_31_0.vars.setLabel_oriPosX + var_31_8 * 33.5)
	else
		var_31_1:getChildByName("label"):setPositionX(arg_31_0.vars.setLabel_oriPosX)
		var_31_2:getChildByName("label"):setPositionX(arg_31_0.vars.setLabel_oriPosX)
	end
end

function UnitBuild.resetAllFilter(arg_32_0)
	arg_32_0.vars.filter = {}
	
	arg_32_0:initSetFilterOpts()
	
	arg_32_0.vars.filter.mainstat = "all"
	arg_32_0.vars.filter.substat1 = "all"
	arg_32_0.vars.filter.substat2 = "all"
	arg_32_0.vars.filter.mainstat_isDesending = true
	arg_32_0.vars.filter.substat1_isDesending = true
	arg_32_0.vars.filter.substat2_isDesending = true
	arg_32_0.vars.filter.substat1_num = 1
	arg_32_0.vars.filter.substat2_num = 1
	arg_32_0.vars.filtersubstatPopup = 1
	
	arg_32_0:setFilter(1, true)
end

function UnitBuild.setFilterPopup(arg_33_0, arg_33_1)
	UnitBuild:closeItemTooltip()
	
	if arg_33_1 == "btn_set" then
		arg_33_0:open_setBox()
	elseif arg_33_1 == "btn_set_done" then
		arg_33_0:close_setBox()
	elseif arg_33_1 == "btn_mainstat" then
		arg_33_0:open_mainstatBox()
	elseif arg_33_1 == "btn_mainstat_done" then
		arg_33_0:close_mainstatBox()
	elseif arg_33_1 == "btn_substat1" then
		arg_33_0:open_substatBox(1)
	elseif arg_33_1 == "btn_substat2" then
		arg_33_0:open_substatBox(2)
	elseif arg_33_1 == "btn_substat1_done" then
		arg_33_0:close_substatBox(1)
	elseif arg_33_1 == "btn_substat2_done" then
		arg_33_0:close_substatBox(2)
	end
end

function UnitBuild.open_setBox(arg_34_0)
	UIAction:Add(SEQ(FADE_IN(200)), arg_34_0.vars.wnd:getChildByName("n_set_box"))
	if_set_visible(arg_34_0.vars.wnd, "n_mainstat_box", false)
	if_set_visible(arg_34_0.vars.wnd, "n_substat_box", false)
	if_set_visible(arg_34_0.vars.wnd, "btn_set_done", true)
	if_set_visible(arg_34_0.vars.wnd, "btn_set", false)
	if_set_visible(arg_34_0.vars.wnd, "btn_mainstat_done", false)
	if_set_visible(arg_34_0.vars.wnd, "btn_substat1_done", false)
	if_set_visible(arg_34_0.vars.wnd, "btn_substat2_done", false)
	if_set_visible(arg_34_0.vars.wnd, "btn_mainstat", true)
	if_set_visible(arg_34_0.vars.wnd, "btn_substat1", true)
	if_set_visible(arg_34_0.vars.wnd, "btn_substat2", true)
	if_set_visible(arg_34_0.vars.cancle_wnd, nil, true)
	
	if arg_34_0.vars.sorter:isShow() then
		arg_34_0.vars.sorter:show(false)
	end
	
	BackButtonManager:pop({
		id = "n_substat_box"
	})
	BackButtonManager:pop({
		id = "n_mainstat_box"
	})
	BackButtonManager:push({
		id = "n_set_box",
		back_func = function()
			UnitBuild:close_setBox()
		end
	})
end

function UnitBuild.close_setBox(arg_36_0)
	if arg_36_0.vars.wnd:getChildByName("n_set_box"):isVisible() == true then
		UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), arg_36_0.vars.wnd:getChildByName("n_set_box"))
		BackButtonManager:pop({
			id = "n_set_box"
		})
	end
	
	if_set_visible(arg_36_0.vars.wnd, "btn_set_done", false)
	if_set_visible(arg_36_0.vars.wnd, "btn_set", true)
	if_set_visible(arg_36_0.vars.cancle_wnd, nil, false)
end

function UnitBuild.open_mainstatBox(arg_37_0)
	UIAction:Add(SEQ(FADE_IN(200)), arg_37_0.vars.wnd:getChildByName("n_mainstat_box"))
	if_set_visible(arg_37_0.vars.wnd, "n_set_box", false)
	if_set_visible(arg_37_0.vars.wnd, "n_substat_box", false)
	if_set_visible(arg_37_0.vars.wnd, "btn_mainstat", false)
	if_set_visible(arg_37_0.vars.wnd, "btn_mainstat_done", true)
	if_set_visible(arg_37_0.vars.wnd, "btn_set_done", false)
	if_set_visible(arg_37_0.vars.wnd, "btn_substat1_done", false)
	if_set_visible(arg_37_0.vars.wnd, "btn_substat2_done", false)
	if_set_visible(arg_37_0.vars.wnd, "btn_set", true)
	if_set_visible(arg_37_0.vars.wnd, "btn_substat1", true)
	if_set_visible(arg_37_0.vars.wnd, "btn_substat2", true)
	if_set_visible(arg_37_0.vars.cancle_wnd, nil, true)
	
	if arg_37_0.vars.sorter:isShow() then
		arg_37_0.vars.sorter:show(false)
	end
	
	BackButtonManager:pop({
		id = "n_substat_box"
	})
	BackButtonManager:pop({
		id = "n_set_box"
	})
	BackButtonManager:push({
		id = "n_mainstat_box",
		back_func = function()
			UnitBuild:close_mainstatBox()
		end
	})
end

function UnitBuild.close_mainstatBox(arg_39_0)
	if arg_39_0.vars.wnd:getChildByName("n_mainstat_box"):isVisible() == true then
		UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), arg_39_0.vars.wnd:getChildByName("n_mainstat_box"))
		BackButtonManager:pop({
			id = "n_mainstat_box"
		})
	end
	
	if_set_visible(arg_39_0.vars.wnd, "btn_mainstat", true)
	if_set_visible(arg_39_0.vars.wnd, "btn_mainstat_done", false)
	if_set_visible(arg_39_0.vars.cancle_wnd, nil, false)
end

function UnitBuild.open_substatBox(arg_40_0, arg_40_1)
	if_set_visible(arg_40_0.vars.cancle_wnd, nil, true)
	BackButtonManager:pop({
		id = "n_substat_box"
	})
	BackButtonManager:pop({
		id = "n_mainstat_box"
	})
	BackButtonManager:pop({
		id = "n_set_box"
	})
	if_set_visible(arg_40_0.vars.wnd, "n_set_box", false)
	if_set_visible(arg_40_0.vars.wnd, "n_mainstat_box", false)
	if_set_visible(arg_40_0.vars.wnd, "btn_set", true)
	if_set_visible(arg_40_0.vars.wnd, "btn_mainstat", true)
	if_set_visible(arg_40_0.vars.wnd, "btn_set_done", false)
	if_set_visible(arg_40_0.vars.wnd, "btn_mainstat_done", false)
	
	local var_40_0 = arg_40_0.vars.wnd:getChildByName("n_substat_box")
	
	UIAction:Add(SEQ(FADE_IN(200)), var_40_0)
	
	local var_40_1 = arg_40_1 == 1
	
	if_set_visible(arg_40_0.vars.wnd, "btn_substat1", not var_40_1)
	if_set_visible(arg_40_0.vars.wnd, "btn_substat1_done", var_40_1)
	if_set_visible(arg_40_0.vars.wnd, "btn_substat2_done", not var_40_1)
	if_set_visible(arg_40_0.vars.wnd, "btn_substat2", var_40_1)
	
	arg_40_0.vars.filtersubstatPopup = arg_40_1
	
	if arg_40_0.vars.filtersubstatPopup == 1 then
		for iter_40_0 = 1, 12 do
			if arg_40_0.vars.filter.substat2_num == iter_40_0 then
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_0), "cursor", false)
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_0), "cursor_other", true)
			elseif arg_40_0.vars.filter.substat1_num == iter_40_0 then
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_0), "cursor", true)
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_0), "cursor_other", false)
			else
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_0), "cursor", false)
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_0), "cursor_other", false)
			end
		end
	elseif arg_40_0.vars.filtersubstatPopup == 2 then
		for iter_40_1 = 1, 12 do
			if arg_40_0.vars.filter.substat1_num == iter_40_1 then
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_1), "cursor", false)
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_1), "cursor_other", true)
			elseif arg_40_0.vars.filter.substat2_num == iter_40_1 then
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_1), "cursor", true)
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_1), "cursor_other", false)
			else
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_1), "cursor", false)
				if_set_visible(var_40_0:getChildByName("btn_sort" .. iter_40_1), "cursor_other", false)
			end
		end
	end
	
	if arg_40_0.vars.filter.substat1_num == 1 and arg_40_0.vars.filter.substat2_num == 1 then
		if_set_visible(var_40_0:getChildByName("btn_sort1"), "cursor", true)
		if_set_visible(var_40_0:getChildByName("btn_sort1"), "cursor_other", false)
	end
	
	if arg_40_0.vars.sorter:isShow() then
		arg_40_0.vars.sorter:show(false)
	end
	
	BackButtonManager:push({
		id = "n_substat_box",
		back_func = function()
			UnitBuild:close_substatBox()
		end
	})
end

function UnitBuild.close_substatBox(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1 or arg_42_0.vars.filtersubstatPopup
	
	if_set_visible(arg_42_0.vars.cancle_wnd, nil, false)
	
	if arg_42_0.vars.wnd:getChildByName("n_substat_box"):isVisible() == true then
		UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), arg_42_0.vars.wnd:getChildByName("n_substat_box"))
		BackButtonManager:pop({
			id = "n_substat_box"
		})
	end
	
	if var_42_0 == 1 then
		if_set_visible(UnitBuild.vars.wnd, "btn_substat1", true)
		if_set_visible(UnitBuild.vars.wnd, "btn_substat1_done", false)
	elseif var_42_0 == 2 then
		if_set_visible(UnitBuild.vars.wnd, "btn_substat2", true)
		if_set_visible(UnitBuild.vars.wnd, "btn_substat2_done", false)
	end
end

local function var_0_3(arg_43_0, arg_43_1, arg_43_2)
	if_set_visible(arg_43_1, "n_select", false)
	if_set_visible(arg_43_1, "icon_type", arg_43_2.isEquip ~= nil)
	
	local var_43_0 = arg_43_1:getChildByName("bg_item")
	local var_43_1 = arg_43_1:getChildByName("txt_value")
	local var_43_2 = arg_43_1:getChildByName("n_txt_value")
	local var_43_3 = arg_43_1:getChildByName("n_img_value")
	
	var_43_3:setVisible(true)
	var_43_2:setVisible(false)
	
	if arg_43_2.isEquip then
		local var_43_4 = UIUtil:getRewardIcon("equip", arg_43_2.code, {
			tooltip_delay = 130,
			parent = var_43_0,
			equip = arg_43_2
		})
		
		if arg_43_2.parent then
			if_set_visible(var_43_4, "locked", false)
		end
		
		local var_43_5, var_43_6, var_43_7, var_43_8 = arg_43_2:getMainStat()
		local var_43_9 = var_43_5 or 0
		local var_43_10 = false
		
		if UNIT.is_percentage_stat(var_43_6) then
			var_43_5 = to_var_str(var_43_5, var_43_6)
			var_43_10 = true
		else
			var_43_5 = comma_value(math.floor(var_43_5))
		end
		
		local var_43_11 = arg_43_1:getChildByName("icon_type")
		
		if get_cocos_refid(var_43_11) then
			var_43_11:setVisible(true)
			SpriteCache:resetSprite(var_43_11, "img/cm_icon_stat_" .. string.gsub(var_43_6, "_rate", "") .. ".png")
		end
		
		UIUtil:resetImageNumber(var_43_3, var_43_5)
		
		local var_43_12 = 0
		local var_43_13 = tonumber(var_43_9) or 0
		
		if var_43_10 then
			var_43_13 = var_43_9 * 100
		end
		
		if var_43_13 <= 999 and var_43_13 >= 100 or var_43_10 and var_43_13 >= 10 and var_43_13 <= 99 then
			var_43_12 = 3
		elseif var_43_13 <= 9999 and var_43_13 >= 1000 or var_43_10 and var_43_13 >= 100 and var_43_13 <= 999 then
			var_43_12 = 5
		elseif var_43_13 >= 10000 then
			var_43_12 = 8
		end
		
		if not var_43_11.originPosX or not var_43_3.originPosX then
			var_43_11.originPosX = var_43_11:getPositionX()
			var_43_3.originPosX = var_43_3:getPositionX()
		end
		
		var_43_11:setPositionX(var_43_11.originPosX - var_43_12)
		var_43_3:setPositionX(var_43_3.originPosX - var_43_12)
	end
	
	if arg_43_2.OriParent then
		local var_43_14 = Account:getUnit(arg_43_2.OriParent)
		
		if var_43_14 ~= nil then
			UIUtil:getRewardIcon("c", var_43_14:getDisplayCode(), {
				no_popup = true,
				no_grade = true,
				parent = arg_43_1:getChildByName("n_mob_icon")
			})
			if_set_visible(arg_43_1, "n_mob_icon", true)
			if_set_visible(arg_43_1, "equip", true)
		end
	else
		if_set_visible(arg_43_1, "n_mob_icon", false)
		if_set_visible(arg_43_1, "equip", false)
	end
	
	if UnitBuild.vars.selected_equips[arg_43_2.db.type] and UnitBuild.vars.selected_equips[arg_43_2.db.type] ~= nil and arg_43_2 == UnitBuild.vars.selected_equips[arg_43_2.db.type] then
		if_set_visible(arg_43_1, "bg_select_in_equip", true)
	end
	
	arg_43_1.datasource = arg_43_2
end

function UnitBuild.initListViewl(arg_44_0)
	arg_44_0.vars.listview = ItemListView:bindControl(arg_44_0.vars.wnd:getChildByName("listview"))
	
	local var_44_0 = {
		onUpdate = var_0_3
	}
	
	arg_44_0.vars.listview:setRenderer(load_control("wnd/inventory_card.csb"), var_44_0)
end

function UnitBuild.resetListView(arg_45_0)
	local var_45_0 = arg_45_0:getCurrentCategoryName()
	
	arg_45_0:checkDescendingOptions(arg_45_0.vars.items[var_45_0])
	arg_45_0.vars.listview:removeAllChildren()
	arg_45_0.vars.listview:addItems(arg_45_0.vars.items[var_45_0])
	
	if #arg_45_0.vars.items[var_45_0] == 0 then
		if_set_visible(arg_45_0.vars.wnd, "n_nodata", true)
	else
		if_set_visible(arg_45_0.vars.wnd, "n_nodata", false)
	end
	
	arg_45_0.vars.listview:jumpToTop()
end

function UnitBuild.getAllItems(arg_46_0)
	for iter_46_0, iter_46_1 in pairs(Account.equips) do
		if not iter_46_1:isArtifact() and not iter_46_1:isStone() and not iter_46_1:isExclusive() then
			local var_46_0 = iter_46_1:clone()
			
			var_46_0.OriParent = var_46_0.parent
			
			table.insert(arg_46_0.vars.allItems[iter_46_1.db.type], var_46_0)
			
			if (iter_46_1.parent == nil or iter_46_1.parent ~= arg_46_0.vars.unit:getUID()) and arg_46_0.vars.itemsetCount[iter_46_1.db.type] and arg_46_0.vars.itemsetCount[iter_46_1.db.type][iter_46_1.set_fx] and iter_46_1.parent == nil then
				arg_46_0.vars.itemsetCount[iter_46_1.db.type][iter_46_1.set_fx] = arg_46_0.vars.itemsetCount[iter_46_1.db.type][iter_46_1.set_fx] + 1
			end
			
			if iter_46_1.parent and iter_46_1.parent == arg_46_0.vars.unit:getUID() then
				arg_46_0.vars.Original_equips[iter_46_1.db.type] = var_46_0
			end
		end
	end
end

function UnitBuild.selectItems(arg_47_0)
	local var_47_0 = {}
	
	for iter_47_0, iter_47_1 in pairs(arg_47_0.vars.allItems[arg_47_0:getCurrentCategoryName()]) do
		if not iter_47_1:isArtifact() and not iter_47_1:isStone() and (arg_47_0.tab == 0 or arg_47_0:isCorrectTab(iter_47_1.db.type) or iter_47_1:isCompatibleCategoryStone(arg_47_0:getCurrentCategoryName())) then
			local var_47_1 = iter_47_1
			
			if iter_47_1.OriParent == nil then
				if arg_47_0:checkFilterOptions(var_47_1) == true then
					table.insert(var_47_0, var_47_1)
				end
			elseif arg_47_0.vars.showEquip_item and arg_47_0:checkFilterOptions(var_47_1) == true then
				table.insert(var_47_0, var_47_1)
			end
		end
	end
	
	return var_47_0
end

function UnitBuild.onSelect(arg_48_0, arg_48_1)
	if not arg_48_1.isEquip then
		return 
	end
	
	if arg_48_0:IsSelected(arg_48_1) == false then
		arg_48_0:setSelect(arg_48_1, true)
		arg_48_0:update_changeStat({
			itemdata = arg_48_1
		})
		arg_48_0:openItemTooltip(arg_48_1)
	else
		arg_48_0:closeItemTooltip()
		arg_48_0:setSelect(arg_48_1, false)
		
		local var_48_0 = arg_48_0.vars.Original_equips[arg_48_1.db.type]
		
		if var_48_0 then
			arg_48_0:update_changeStat({
				itemdata = var_48_0
			})
		else
			arg_48_0:update_changeStat({
				prevItem = arg_48_1
			})
		end
	end
	
	arg_48_0:setChangeButton()
end

function UnitBuild.openItemTooltip(arg_49_0, arg_49_1)
	if not arg_49_0.vars.wnd or not get_cocos_refid(arg_49_0.vars.wnd) then
		return 
	end
	
	if not arg_49_0.vars.itemToolTip_wnd or not get_cocos_refid(arg_49_0.vars.itemToolTip_wnd) then
		arg_49_0.vars.itemToolTip_wnd = load_dlg("equip_item_tooltip", true, "wnd", function()
			UnitBuild:closeItemTooltip()
		end)
		
		arg_49_0.vars.wnd:getChildByName("n_equip_item_tooltip"):addChild(arg_49_0.vars.itemToolTip_wnd)
		arg_49_0.vars.itemToolTip_wnd:setPosition(160, 280)
	end
	
	local var_49_0 = arg_49_0.vars.itemToolTip_wnd:getChildByName("bg_item")
	local var_49_1 = arg_49_0.vars.itemToolTip_wnd
	
	ItemTooltip:updateItemFrame(var_49_1, arg_49_1)
	ItemTooltip:updateItemInformation({
		detail = true,
		no_resize = true,
		wnd = var_49_1,
		equip = arg_49_1
	})
	
	local var_49_2 = var_49_1:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_49_2) then
		local var_49_3 = var_49_2:getStringNumLines()
		local var_49_4 = var_49_1:getChildByName("frame_grade")
		local var_49_5 = var_49_1:getChildByName("n_detail")
		local var_49_6 = var_49_1:getChildByName("n_wear")
		
		if get_cocos_refid(var_49_4) and get_cocos_refid(var_49_5) and get_cocos_refid(var_49_6) then
			if not var_49_4.origin_height then
				var_49_4.origin_height = var_49_4:getContentSize().height
			end
			
			if not var_49_5.origin_y then
				var_49_5.origin_y = var_49_5:getPositionY()
			end
			
			if not var_49_6.origin_y then
				var_49_6.origin_y = var_49_6:getPositionY()
			end
			
			local var_49_7 = var_49_4:getContentSize()
			
			if var_49_3 and var_49_3 >= 4 then
				var_49_4:setContentSize({
					width = var_49_7.width,
					height = var_49_4.origin_height + 20
				})
				var_49_5:setPositionY(var_49_5.origin_y + 20)
				var_49_6:setPositionY(var_49_6.origin_y - 20)
			else
				var_49_4:setContentSize({
					width = var_49_7.width,
					height = var_49_4.origin_height
				})
				var_49_5:setPositionY(var_49_5.origin_y)
				var_49_6:setPositionY(var_49_6.origin_y)
			end
		end
	end
	
	local var_49_8 = var_49_1:getChildByName("n_wear")
	
	if arg_49_1.OriParent then
		if_set_visible(var_49_8, "n_hero", true)
		if_set_visible(var_49_8, "n_no_data", false)
		
		local var_49_9 = Account:getUnit(arg_49_1.OriParent)
		
		if var_49_9 == nil then
			if_set_visible(var_49_8, "n_hero", false)
			if_set_visible(var_49_8, "n_no_data", true)
			
			return 
		end
		
		local var_49_10 = {
			no_popup = true,
			name = false,
			no_lv = true,
			no_grade = false,
			parent = var_49_8:getChildByName("mob_icon"),
			border_code = var_49_9.border_code,
			zodiac = var_49_9:getZodiacGrade()
		}
		
		UIUtil:getUserIcon(var_49_9, var_49_10)
		
		local var_49_11 = var_49_8:getChildByName("n_hero")
		local var_49_12 = getChildByPath(var_49_11, "icon_element")
		local var_49_13 = getChildByPath(var_49_11, "role")
		
		if_set_sprite(var_49_12, nil, "img/cm_icon_pro" .. var_49_9.db.color .. ".png")
		if_set_sprite(var_49_13, nil, "img/cm_icon_role_" .. var_49_9.db.role .. ".png")
		UIUtil:setLevelDetail(getChildByPath(var_49_11, "n_lv"), var_49_9:getLv(), var_49_9:getMaxLevel())
		
		local var_49_14 = DB("character", var_49_9.inst.code, {
			"name"
		})
		
		if_set(getChildByPath(var_49_11, "txt_name"), nil, T(var_49_14))
	else
		if_set_visible(var_49_8, "n_hero", false)
		if_set_visible(var_49_8, "n_no_data", true)
	end
end

function UnitBuild.update_changeStat(arg_51_0, arg_51_1)
	local var_51_0 = arg_51_1 or {}
	local var_51_1 = arg_51_0.vars.wnd:getChildByName("CENTER")
	local var_51_2 = var_51_1:getChildByName("n_stat_change")
	local var_51_3 = var_51_1:getChildByName("n_change")
	local var_51_4 = var_51_1:getChildByName("n_set_change")
	local var_51_5 = var_51_0.itemdata
	local var_51_6 = arg_51_0.vars.unit
	
	GrowthBoost:apply(var_51_6)
	
	if var_51_0.first then
		local var_51_7 = var_51_6:getStatus()
		
		if_set(var_51_3, "txt_stat", comma_value(var_51_6:getPoint(var_51_7)))
		if_set_visible(var_51_2, "stat_att", false)
		if_set_visible(var_51_2, "stat_def", false)
		if_set_visible(var_51_2, "stat_maxhp", false)
		if_set_visible(var_51_2, "stat_spd", false)
		if_set_visible(var_51_2, "stat_cri", false)
		if_set_visible(var_51_2, "stat_cridmg", false)
		if_set_visible(var_51_2, "stat_con", false)
		if_set_visible(var_51_2, "stat_res", false)
		if_set_visible(var_51_2, "stat_coop", false)
		if_set_visible(var_51_1, "n_set_change", false)
		if_set_visible(var_51_1, "txt_no_select", true)
		if_set_visible(var_51_1, "stat_up", false)
		if_set_visible(var_51_1, "stat_down", false)
	elseif var_51_5 then
		local var_51_8 = var_51_1:getChildByName("n_change")
		local var_51_9 = var_51_8:getChildByName("n_item")
		local var_51_10 = var_51_5:getEquipPositionIndex()
		local var_51_11 = var_51_8:getChildByName("item_slot" .. var_51_10):getChildByName("n_item" .. var_51_10)
		
		var_51_11:removeAllChildren()
		
		local var_51_12 = UIUtil:getRewardIcon("equip", var_51_5.code, {
			scale = 1,
			tooltip_delay = 120,
			parent = var_51_11,
			equip = var_51_5
		})
		
		var_51_12:setName("item" .. var_51_10)
		
		if var_51_5.OriParent and arg_51_0.vars.unit:getUID() ~= var_51_5.OriParent then
			if_set_visible(var_51_12, "locked", false)
		end
		
		if arg_51_0.vars.changeIcons[var_51_10] == nil then
			arg_51_0.vars.changeIcons[var_51_10] = var_51_12
		else
			arg_51_0.vars.changeIcons[var_51_10] = nil
			arg_51_0.vars.changeIcons[var_51_10] = var_51_12
		end
		
		UnitBuild.vars.setCount = 1
		
		var_51_6:eachSetItemApply(function(arg_52_0)
			local var_52_0 = UnitBuild.vars.setCount
			
			SpriteCache:resetSprite(var_51_4:getChildByName("set_" .. var_52_0), EQUIP:getSetItemIconPath(arg_52_0))
			if_set(var_51_4, "label_set_" .. var_52_0, T(DB("item_set", arg_52_0, "name")))
			if_set_opacity(var_51_4, "set_" .. var_52_0, 255)
			
			UnitBuild.vars.setCount = UnitBuild.vars.setCount + 1
		end)
		
		for iter_51_0 = UnitBuild.vars.setCount, 3 do
			SpriteCache:resetSprite(var_51_4:getChildByName("set_" .. iter_51_0), "img/cm_icon_etcbattle.png")
			if_set(var_51_4, "label_set_" .. iter_51_0, T("no_set"))
			if_set_opacity(var_51_4, "set_" .. iter_51_0, 76.5)
		end
		
		local var_51_13 = {}
		
		for iter_51_1, iter_51_2 in pairs(var_51_5.opts) do
			local var_51_14 = iter_51_2[1]
			local var_51_15 = iter_51_2[2]
			
			if var_51_13[var_51_14] then
				var_51_13[var_51_14] = var_51_13[var_51_14] + var_51_15
			else
				var_51_13[var_51_14] = var_51_15
			end
		end
		
		var_51_6:calc()
		
		if arg_51_0.vars.Original_equips[var_51_5.db.type] and arg_51_0.vars.Original_equips[var_51_5.db.type]:getUID() == var_51_5:getUID() then
			arg_51_0.vars.changeIcons[var_51_10]:setOpacity(76.5)
		end
		
		if var_51_5.OriParent then
			local var_51_16 = Account:getUnit(var_51_5.OriParent)
			
			if var_51_16 ~= nil and arg_51_0.vars.unit:getUID() ~= var_51_16:getUID() then
				UIUtil:getRewardIcon("c", var_51_16:getDisplayCode(), {
					no_popup = true,
					x = 15,
					y = 15,
					no_grade = true,
					parent = var_51_12,
					scale = arg_51_0.vars.portrait_scale
				})
			end
		end
		
		arg_51_0:setChangeStat(var_51_6, var_51_3, var_51_2, var_51_1, var_51_4)
	elseif var_51_5 == nil and var_51_0.prevItem then
		var_51_6:calc()
		arg_51_0:setChangeStat(var_51_6, var_51_3, var_51_2, var_51_1, var_51_4)
		
		local var_51_17 = var_51_0.prevItem:getEquipPositionIndex()
		
		arg_51_0.vars.changeIcons[var_51_17]:removeFromParent()
	end
	
	arg_51_0:calChangeCost()
end

function UnitBuild.setChangeStat(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	local var_53_0 = arg_53_0.vars.prevStatus
	local var_53_1 = arg_53_1:getStatus()
	
	arg_53_0.vars.curStatus = var_53_1
	
	if_set_visible(arg_53_3, nil, true)
	if_set(arg_53_2, "txt_stat", comma_value(arg_53_1:getPoint(var_53_1)))
	if_set(arg_53_3, "txt_stat_att", var_53_1.att)
	if_set(arg_53_3, "txt_stat_def", var_53_1.def)
	if_set(arg_53_3, "txt_stat_maxhp", var_53_1.max_hp)
	if_set(arg_53_3, "txt_stat_spd", var_53_1.speed)
	if_set(arg_53_3, "txt_stat_cri", var_53_1.cri, false, "ratioExpand")
	if_set(arg_53_3, "txt_stat_cridmg", var_53_1.cri_dmg, false, "ratioExpand")
	
	if FORMULA.isMoreThanStatLimit("cri", var_53_1.cri) then
		if_set_color(arg_53_3, "txt_stat_cri", UIUtil.ORANGE)
	else
		if_set_color(arg_53_3, "txt_stat_cri", UIUtil.WHITE)
	end
	
	if FORMULA.isMoreThanStatLimit("cri_dmg", var_53_1.cri_dmg) then
		if_set_color(arg_53_3, "txt_stat_cridmg", UIUtil.ORANGE)
	else
		if_set_color(arg_53_3, "txt_stat_cridmg", UIUtil.WHITE)
	end
	
	if FORMULA.isMoreThanStatLimit("coop", var_53_1.coop) then
		if_set_color(arg_53_3, "txt_stat_coop", UIUtil.ORANGE)
	else
		if_set_color(arg_53_3, "txt_stat_coop", UIUtil.WHITE)
	end
	
	if_set(arg_53_3, "txt_stat_con", var_53_1.acc, false, "ratioExpand")
	if_set(arg_53_3, "txt_stat_res", var_53_1.res, false, "ratioExpand")
	if_set(arg_53_3, "txt_stat_coop", var_53_1.coop, false, "ratioExpand")
	if_set_visible(arg_53_3, "stat_att", true)
	if_set_visible(arg_53_3, "stat_def", true)
	if_set_visible(arg_53_3, "stat_maxhp", true)
	if_set_visible(arg_53_3, "stat_spd", true)
	if_set_visible(arg_53_3, "stat_cri", true)
	if_set_visible(arg_53_3, "stat_cridmg", true)
	if_set_visible(arg_53_3, "stat_con", true)
	if_set_visible(arg_53_3, "stat_res", true)
	if_set_visible(arg_53_3, "stat_coop", true)
	if_set_visible(arg_53_4, "n_set_change", true)
	if_set_visible(arg_53_4, "txt_no_select", false)
	
	UnitBuild.vars.setCount = 1
	
	arg_53_1:eachSetItemApply(function(arg_54_0)
		local var_54_0 = UnitBuild.vars.setCount
		
		SpriteCache:resetSprite(arg_53_5:getChildByName("set_" .. var_54_0), EQUIP:getSetItemIconPath(arg_54_0))
		if_set(arg_53_5, "label_set_" .. var_54_0, T(DB("item_set", arg_54_0, "name")))
		if_set_opacity(arg_53_5, "set_" .. var_54_0, 255)
		
		UnitBuild.vars.setCount = UnitBuild.vars.setCount + 1
	end)
	
	for iter_53_0 = UnitBuild.vars.setCount, 3 do
		SpriteCache:resetSprite(arg_53_5:getChildByName("set_" .. iter_53_0), "img/cm_icon_etcbattle.png")
		if_set(arg_53_5, "label_set_" .. iter_53_0, T("no_set"))
		if_set_opacity(arg_53_5, "set_" .. iter_53_0, 76.5)
	end
	
	if var_53_0 then
		local var_53_2 = arg_53_3:getChildByName("n_stat_att")
		
		if var_53_1.att == var_53_0.att then
			arg_53_0:setStatUpDown(var_53_2, {
				none = true
			})
		else
			arg_53_0:setStatUpDown(var_53_2, {
				prevstatus = var_53_0.att,
				status = var_53_1.att
			})
		end
		
		local var_53_3 = arg_53_3:getChildByName("n_stat_def")
		
		if var_53_1.def == var_53_0.def then
			arg_53_0:setStatUpDown(var_53_3, {
				none = true
			})
		else
			arg_53_0:setStatUpDown(var_53_3, {
				prevstatus = var_53_0.def,
				status = var_53_1.def
			})
		end
		
		local var_53_4 = arg_53_3:getChildByName("n_stat_maxhp")
		
		if var_53_1.max_hp == var_53_0.max_hp then
			arg_53_0:setStatUpDown(var_53_4, {
				none = true
			})
		else
			arg_53_0:setStatUpDown(var_53_4, {
				prevstatus = var_53_0.max_hp,
				status = var_53_1.max_hp
			})
		end
		
		local var_53_5 = arg_53_3:getChildByName("n_stat_spd")
		
		if var_53_1.speed == var_53_0.speed then
			arg_53_0:setStatUpDown(var_53_5, {
				none = true
			})
		else
			arg_53_0:setStatUpDown(var_53_5, {
				prevstatus = var_53_0.speed,
				status = var_53_1.speed
			})
		end
		
		local var_53_6 = arg_53_3:getChildByName("n_stat_cri")
		
		if var_53_1.cri == var_53_0.cri then
			arg_53_0:setStatUpDown(var_53_6, {
				none = true
			})
			arg_53_0:setOverStatUp(var_53_6, "cri")
		else
			arg_53_0:setStatUpDown(var_53_6, {
				ratioExpand = true,
				prevstatus = var_53_0.cri,
				status = var_53_1.cri
			})
			arg_53_0:setOverStatUp(var_53_6, "cri")
		end
		
		local var_53_7 = arg_53_3:getChildByName("n_stat_cridmg")
		
		if var_53_1.cri_dmg == var_53_0.cri_dmg then
			arg_53_0:setStatUpDown(var_53_7, {
				none = true
			})
			arg_53_0:setOverStatUp(var_53_7, "cri_dmg")
		else
			arg_53_0:setStatUpDown(var_53_7, {
				ratioExpand = true,
				prevstatus = var_53_0.cri_dmg,
				status = var_53_1.cri_dmg
			})
			arg_53_0:setOverStatUp(var_53_7, "cri_dmg")
		end
		
		local var_53_8 = arg_53_3:getChildByName("n_stat_con")
		
		if tostring(var_53_1.acc) == tostring(var_53_0.acc) then
			arg_53_0:setStatUpDown(var_53_8, {
				none = true
			})
		else
			arg_53_0:setStatUpDown(var_53_8, {
				ratioExpand = true,
				prevstatus = var_53_0.acc,
				status = var_53_1.acc
			})
		end
		
		local var_53_9 = arg_53_3:getChildByName("n_stat_res")
		
		if tostring(var_53_1.res) == tostring(var_53_0.res) then
			arg_53_0:setStatUpDown(var_53_9, {
				none = true
			})
		else
			arg_53_0:setStatUpDown(var_53_9, {
				ratioExpand = true,
				prevstatus = var_53_0.res,
				status = var_53_1.res
			})
		end
		
		local var_53_10 = arg_53_3:getChildByName("n_stat_coop")
		
		if var_53_1.coop == var_53_0.coop then
			arg_53_0:setStatUpDown(var_53_10, {
				none = true
			})
			arg_53_0:setOverStatUp(var_53_10, "coop")
		else
			arg_53_0:setStatUpDown(var_53_10, {
				ratioExpand = true,
				prevstatus = var_53_0.coop,
				status = var_53_1.coop
			})
			arg_53_0:setOverStatUp(var_53_10, "coop")
		end
		
		local var_53_11
		
		if arg_53_1:getPoint(var_53_0) > arg_53_1:getPoint(var_53_1) then
			if_set_visible(arg_53_2, "stat_down", true)
			if_set_visible(arg_53_2, "stat_up", false)
			
			var_53_11 = "stat_down"
			
			if_set(arg_53_2, "txt_stat_down", comma_value(arg_53_1:getPoint(var_53_0) - arg_53_1:getPoint(var_53_1)))
		elseif arg_53_1:getPoint(var_53_0) == arg_53_1:getPoint(var_53_1) then
			if_set_visible(arg_53_2, "stat_down", false)
			if_set_visible(arg_53_2, "stat_up", false)
		else
			if_set_visible(arg_53_2, "stat_down", false)
			if_set_visible(arg_53_2, "stat_up", true)
			
			var_53_11 = "stat_up"
			
			if_set(arg_53_2, "txt_stat_up", comma_value(arg_53_1:getPoint(var_53_1) - arg_53_1:getPoint(var_53_0)))
		end
		
		if var_53_11 and arg_53_0.vars.change_power_pos_x and arg_53_0.vars.change_power_pos_x[var_53_11] then
			if_set_position_x(arg_53_2, var_53_11, arg_53_0.vars.change_power_pos_x[var_53_11])
			
			if arg_53_1:getPoint(var_53_1) >= 100000 then
				if_set_add_position_x(arg_53_2, var_53_11, 14)
			end
		end
	end
end

function UnitBuild.setStatUpDown(arg_55_0, arg_55_1, arg_55_2)
	if arg_55_2.none == true then
		if_set_visible(arg_55_1, "stat_up", false)
		if_set_visible(arg_55_1, "stat_down", false)
		
		return 
	end
	
	if arg_55_2.prevstatus < arg_55_2.status then
		if_set_visible(arg_55_1, "stat_up", true)
		if_set_visible(arg_55_1, "stat_down", false)
		
		local var_55_0 = arg_55_1:getChildByName("stat_up")
		
		if get_cocos_refid(var_55_0) then
			if arg_55_2.ratioExpand then
				if_set(var_55_0, "txt_stat_up", arg_55_2.status - arg_55_2.prevstatus, false, "ratioExpand")
			else
				if_set(var_55_0, "txt_stat_up", arg_55_2.status - arg_55_2.prevstatus)
			end
		end
	else
		if_set_visible(arg_55_1, "stat_up", false)
		if_set_visible(arg_55_1, "stat_down", true)
		
		local var_55_1 = arg_55_1:getChildByName("stat_down")
		
		if get_cocos_refid(var_55_1) then
			if arg_55_2.ratioExpand then
				if_set(var_55_1, "txt_stat_down", arg_55_2.prevstatus - arg_55_2.status, false, "ratioExpand")
			else
				if_set(var_55_1, "txt_stat_down", arg_55_2.prevstatus - arg_55_2.status)
			end
		end
	end
end

function UnitBuild.setOverStatUp(arg_56_0, arg_56_1, arg_56_2)
	if not get_cocos_refid(arg_56_1) or not arg_56_2 then
		return 
	end
	
	if_set_visible(arg_56_1, "over_stat_up", false)
	
	if arg_56_0.vars.unit then
		local var_56_0 = arg_56_0.vars.unit:getOverStatus()
		
		if var_56_0 and var_56_0[arg_56_2] and var_56_0[arg_56_2] > 0 then
			if_set_visible(arg_56_1, "over_stat_up", true)
			
			local var_56_1 = arg_56_1:getChildByName("over_stat_up")
			
			if get_cocos_refid(var_56_1) then
				if_set(var_56_1, "txt_stat_up", var_56_0[arg_56_2], false, "ratioExpand")
			end
		end
	end
end

function UnitBuild.setSelect(arg_57_0, arg_57_1, arg_57_2)
	if not arg_57_0.vars.selected_equips then
		arg_57_0.vars.selected_equips = {}
	end
	
	if arg_57_0.vars.selected_equips[arg_57_1.db.type] ~= nil then
		local var_57_0 = arg_57_0.vars.listview:getControl(arg_57_0.vars.selected_equips[arg_57_1.db.type])
		
		if_set_visible(var_57_0, "bg_select_in_equip", false)
	end
	
	local var_57_1 = arg_57_0.vars.listview:getControl(arg_57_1)
	
	if arg_57_2 == true then
		arg_57_0.vars.selected_equips[arg_57_1.db.type] = arg_57_1
		
		if_set_visible(var_57_1, "bg_select_in_equip", true)
	else
		arg_57_0.vars.selected_equips[arg_57_1.db.type] = nil
		
		if_set_visible(var_57_1, "bg_select_in_equip", false)
	end
	
	if arg_57_1.OriParent and arg_57_1.OriParent == arg_57_0.vars.unit:getUID() then
		balloon_message_with_sound("cannot_change_already_equipped")
		
		arg_57_0.vars.selected_equips[arg_57_1.db.type] = nil
		arg_57_0.vars.cur_item = nil
		
		arg_57_0:set_equipEnhanceButton()
		if_set_visible(var_57_1, "bg_select_in_equip", false)
	end
	
	local var_57_2 = arg_57_0.vars.unit
	
	if arg_57_2 == true then
		local var_57_3 = var_57_2:getEquipByPos(arg_57_1.db.type)
		
		if var_57_3 ~= nil then
			var_57_2:removeEquip(var_57_3)
			
			var_57_3.parent = var_57_3.OriParent
			var_57_3.cloneParent = Account:getUnit(var_57_3.OriParent)
		end
		
		arg_57_1.cloneParent = arg_57_0.vars.unit
		
		var_57_2:addEquip(arg_57_1)
		
		if arg_57_0.vars.Original_equips[arg_57_1.db.type] and arg_57_1:getUID() ~= arg_57_0.vars.Original_equips[arg_57_1.db.type]:getUID() then
			arg_57_0.vars.Original_equips[arg_57_1.db.type].cloneParent = nil
			arg_57_0.vars.Original_equips[arg_57_1.db.type].parent = nil
			
			local var_57_4 = arg_57_0.vars.listview:getControl(arg_57_0.vars.Original_equips[arg_57_1.db.type])
			
			for iter_57_0, iter_57_1 in pairs(arg_57_0.vars.items[arg_57_1.db.type] or {}) do
				if iter_57_1:getUID() == arg_57_0.vars.Original_equips[arg_57_1.db.type]:getUID() then
					local var_57_5 = arg_57_0.vars.listview:getControl(iter_57_1)
					
					if var_57_5 ~= nil then
						var_57_5.datasource.parent = nil
						var_57_5.datasource.cloneParent = nil
					end
				end
			end
		end
		
		if arg_57_0.vars.Original_equips[arg_57_1.db.type] and arg_57_0.vars.Original_equips[arg_57_1.db.type]:getUID() == arg_57_1:getUID() then
			var_57_2:addEquip(arg_57_0.vars.Original_equips[arg_57_1.db.type])
			
			arg_57_0.vars.Original_equips[arg_57_1.db.type].cloneParent = arg_57_0.vars.unit
		else
			arg_57_0.vars.cur_item = arg_57_1
			
			arg_57_0:set_equipEnhanceButton()
		end
		
		if not arg_57_1.OriParent and arg_57_1.OriParent ~= arg_57_0.vars.unit:getUID() then
			UIUtil:playEquipSetEffect(arg_57_0.vars.wnd:getChildByName("n_change"), arg_57_0.vars.unit, arg_57_1)
		end
	elseif arg_57_2 == false then
		var_57_2:removeEquip(arg_57_1)
		
		arg_57_1.parent = arg_57_1.OriParent
		arg_57_1.cloneParent = Account:getUnit(arg_57_1.OriParent)
		
		if arg_57_0.vars.Original_equips[arg_57_1.db.type] then
			var_57_2:addEquip(arg_57_0.vars.Original_equips[arg_57_1.db.type])
			
			arg_57_0.vars.Original_equips[arg_57_1.db.type].cloneParent = arg_57_0.vars.unit
			
			for iter_57_2, iter_57_3 in pairs(arg_57_0.vars.items[arg_57_1.db.type] or {}) do
				if iter_57_3:getUID() == arg_57_0.vars.Original_equips[arg_57_1.db.type]:getUID() then
					local var_57_6 = arg_57_0.vars.listview:getControl(iter_57_3)
					
					if var_57_6 ~= nil then
						var_57_6.datasource.parent = var_57_6.datasource.OriParent
						var_57_6.datasource.cloneParent = arg_57_0.vars.unit
					end
				end
			end
		end
		
		arg_57_0.vars.cur_item = nil
		
		arg_57_0:set_equipEnhanceButton()
	end
end

function UnitBuild.IsSelected(arg_58_0, arg_58_1)
	if not arg_58_0.vars.selected_equips then
		return false
	end
	
	local var_58_0 = arg_58_0.vars.selected_equips[arg_58_1.db.type]
	
	if var_58_0 == nil then
		return false
	elseif var_58_0:getUID() == arg_58_1:getUID() then
		return true
	end
	
	return false
end

function UnitBuild.resetItems(arg_59_0)
	for iter_59_0, iter_59_1 in pairs(var_0_0) do
		if arg_59_0.vars.selected_equips[iter_59_1] then
			local var_59_0 = arg_59_0.vars.selected_equips[iter_59_1]
			
			arg_59_0:setSelect(var_59_0, false)
			arg_59_0:update_changeStat({
				prevItem = var_59_0
			})
		end
		
		if arg_59_0.vars.Original_equips[iter_59_1] then
			local var_59_1 = arg_59_0.vars.Original_equips[iter_59_1]
			
			arg_59_0:update_changeStat({
				itemdata = var_59_1
			})
		end
	end
	
	arg_59_0:resetAllFilter()
	arg_59_0:closeItemTooltip()
	
	if arg_59_0.vars.showEquip_item == true then
		arg_59_0:showEquipItem()
	end
	
	if_set_visible(arg_59_0.vars.wnd, "n_stat_change", false)
	if_set_visible(arg_59_0.vars.wnd, "n_set_change", false)
	if_set_visible(arg_59_0.vars.wnd, "txt_no_select", true)
	arg_59_0:setChangeButton()
end

function UnitBuild.closeItemTooltip(arg_60_0)
	if get_cocos_refid(arg_60_0.vars.itemToolTip_wnd) then
		BackButtonManager:pop("equip_item_tooltip")
		arg_60_0.vars.itemToolTip_wnd:removeFromParent()
		
		arg_60_0.vars.itemToolTip_wnd = nil
	end
end

function UnitBuild.setCurrentMaxUid(arg_61_0, arg_61_1)
	if UnitBuild.equipMaxUids == nil then
		UnitBuild:checkLastInventoryEnter()
	end
	
	if arg_61_1 ~= nil then
		local var_61_0 = -1
		
		for iter_61_0, iter_61_1 in pairs(Account.equips) do
			if not iter_61_1:isArtifact() and (arg_61_1 == 0 or arg_61_0:isCorrectTab(iter_61_1.db.type) or iter_61_1:isCompatibleCategoryStone(arg_61_0:getCurrentCategoryName())) then
				var_61_0 = math.max(var_61_0, iter_61_1:getUID())
			end
		end
		
		UnitBuild.equipMaxUids[arg_61_1] = var_61_0
		UnitBuild.equipMaxUids[0] = var_61_0 > UnitBuild.equipMaxUids[0] and var_61_0 or UnitBuild.equipMaxUids[0]
	end
end

function UnitBuild.checkLastInventoryEnter(arg_62_0)
	arg_62_0.equipMaxUids = {}
	
	for iter_62_0 = 0, 6 do
		local var_62_0 = SAVE:get("equip_maxUid" .. iter_62_0)
		
		if var_62_0 ~= nil then
			arg_62_0.equipMaxUids[iter_62_0] = tonumber(var_62_0)
		end
		
		if false then
		end
	end
end

function UnitBuild.moveTabSelector(arg_63_0, arg_63_1, arg_63_2)
	if not arg_63_1 then
		return 
	end
	
	local var_63_0 = arg_63_1:getChildByName("btn_equip_tab" .. arg_63_2)
	
	if not var_63_0 then
		return 
	end
	
	local var_63_1 = arg_63_1:getChildByName("n_tab" .. arg_63_2)
	
	if var_63_1 then
		var_63_0:setPositionX(var_63_1:getPositionX())
	end
	
	for iter_63_0 = 1, 6 do
		local var_63_2 = arg_63_1:getChildByName("btn_equip_tab" .. iter_63_0)
		
		if iter_63_0 == arg_63_2 then
			if_set_visible(var_63_2, "bg_tab", true)
		else
			if_set_visible(var_63_2, "bg_tab", false)
		end
	end
end

function UnitBuild.isCorrectTab(arg_64_0, arg_64_1)
	local var_64_0 = {
		weapon = 1,
		armor = 2,
		ring = 6,
		boot = 5,
		helm = 4,
		neck = 3
	}
	
	return arg_64_0.tab == var_64_0[arg_64_1]
end

function UnitBuild.getCurrentCategoryName(arg_65_0)
	if arg_65_0.tab then
		return var_0_0[arg_65_0.tab]
	else
		return var_0_0[1]
	end
end

function UnitBuild.updateRecall(arg_66_0)
	local var_66_0 = arg_66_0.vars.detail_wnd
	local var_66_1 = arg_66_0.vars.equip
	local var_66_2 = UIUtil:isEquipRecallable(var_66_1)
	
	if_set_visible(var_66_0, "btn_recall", var_66_2)
end

function UnitBuild.openEquipChangePopup(arg_67_0)
	if not UnitMain.vars or not get_cocos_refid(UnitMain.vars.base_wnd) then
		return 
	end
	
	if not arg_67_0.vars.prevStatus or not arg_67_0.vars.curStatus then
		return 
	end
	
	local var_67_0 = 0
	
	for iter_67_0, iter_67_1 in pairs(arg_67_0.vars.selected_equips) do
		if iter_67_1 ~= nil then
			var_67_0 = var_67_0 + 1
			
			break
		end
	end
	
	if var_67_0 == 0 then
		return 
	end
	
	arg_67_0.vars.changeCost = arg_67_0:calChangeCost()
	
	if Account:getCurrency("gold") < arg_67_0.vars.changeCost then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	if UnitBuild:checkChangeItems() == false then
		return 
	end
	
	arg_67_0.vars.changePopup_wnd = load_dlg("equip_change_popup", true, "wnd", function()
		UnitBuild:closeEquipChangePopup()
	end)
	
	UnitMain.vars.base_wnd:addChild(arg_67_0.vars.changePopup_wnd)
	arg_67_0.vars.changePopup_wnd:bringToFront()
	arg_67_0:initEquipChangePopup()
end

function UnitBuild.setChangeButton(arg_69_0)
	local var_69_0 = arg_69_0.vars.wnd:getChildByName("btn_change")
	
	if not arg_69_0.vars.prevStatus or not arg_69_0.vars.curStatus then
		if_set_visible(arg_69_0.vars.wnd, "n_stat_change", false)
		if_set_visible(arg_69_0.vars.wnd, "n_set_change", false)
		if_set_visible(arg_69_0.vars.wnd, "txt_no_select", true)
		if_set_opacity(var_69_0, nil, 76.5)
		var_69_0:setTouchEnabled(false)
		
		return 
	end
	
	local var_69_1 = 0
	
	for iter_69_0, iter_69_1 in pairs(arg_69_0.vars.selected_equips) do
		if iter_69_1 ~= nil then
			var_69_1 = var_69_1 + 1
			
			break
		end
	end
	
	if var_69_1 == 0 then
		if_set_visible(arg_69_0.vars.wnd, "n_stat_change", false)
		if_set_visible(arg_69_0.vars.wnd, "n_set_change", false)
		if_set_visible(arg_69_0.vars.wnd, "txt_no_select", true)
		if_set_opacity(var_69_0, nil, 76.5)
		var_69_0:setTouchEnabled(false)
		
		return 
	end
	
	if UnitBuild:checkChangeItems() == false then
		if_set_visible(arg_69_0.vars.wnd, "n_stat_change", false)
		if_set_visible(arg_69_0.vars.wnd, "n_set_change", false)
		if_set_visible(arg_69_0.vars.wnd, "txt_no_select", true)
		if_set_opacity(var_69_0, nil, 76.5)
		var_69_0:setTouchEnabled(false)
		
		return 
	end
	
	if_set_opacity(var_69_0, nil, 255)
	var_69_0:setTouchEnabled(true)
end

function UnitBuild.initEquipChangePopup(arg_70_0)
	local var_70_0 = arg_70_0.vars.unit:getPoint(arg_70_0.vars.prevStatus)
	local var_70_1 = arg_70_0.vars.unit:getPoint(arg_70_0.vars.curStatus)
	local var_70_2 = arg_70_0.vars.changePopup_wnd
	local var_70_3 = var_70_2:findChildByName("n_stat1")
	local var_70_4 = var_70_2:findChildByName("n_stat2")
	local var_70_5 = var_70_2:findChildByName("stat_up")
	local var_70_6 = var_70_2:findChildByName("stat_down")
	
	if_set(var_70_3, "txt_stat", comma_value(var_70_0))
	if_set(var_70_4, "txt_stat", comma_value(var_70_1))
	
	if var_70_0 < var_70_1 then
		if_set_visible(var_70_2, "stat_up", true)
		if_set_visible(var_70_2, "stat_down", false)
		if_set(var_70_5, "txt_stat_up", comma_value(var_70_1 - var_70_0))
	elseif var_70_1 < var_70_0 then
		if_set_visible(var_70_2, "stat_up", false)
		if_set_visible(var_70_2, "stat_down", true)
		if_set(var_70_6, "txt_stat_down", comma_value(var_70_0 - var_70_1))
	elseif var_70_0 == var_70_1 then
		if_set_visible(var_70_2, "stat_up", false)
		if_set_visible(var_70_2, "stat_down", false)
	end
	
	if_set(var_70_2, "txt_price", comma_value(arg_70_0.vars.changeCost))
	
	if arg_70_0.vars.is_active_booster then
		if_set_visible(var_70_2, "event_badge", true)
	else
		if_set_visible(var_70_2, "event_badge", false)
	end
end

function UnitBuild.calChangeCost(arg_71_0)
	local var_71_0 = 0
	local var_71_1 = 0
	
	if not arg_71_0.vars.selected_equips then
		return var_71_0
	end
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0.vars.selected_equips) do
		if arg_71_0.vars.Original_equips[iter_71_0] and arg_71_0.vars.Original_equips[iter_71_0]:getUID() == iter_71_1:getUID() then
		elseif arg_71_0.vars.Original_equips[iter_71_0] then
			var_71_0 = var_71_0 + arg_71_0.vars.Original_equips[iter_71_0]:getUnequipCost()
			
			if iter_71_1.OriParent and iter_71_1.OriParent ~= nil then
				var_71_0 = var_71_0 + iter_71_1:getUnequipCost()
			end
		elseif iter_71_1.OriParent and iter_71_1.OriParent ~= nil then
			var_71_0 = var_71_0 + iter_71_1:getUnequipCost()
		end
	end
	
	local var_71_2 = arg_71_0.vars.wnd:findChildByName("btn_change")
	
	if_set(var_71_2, "t_token", comma_value(var_71_0))
	
	return var_71_0
end

function UnitBuild.checkChangeItems(arg_72_0)
	local var_72_0 = tostring(arg_72_0.vars.unit:getUID())
	local var_72_1 = false
	
	arg_72_0.vars.sendData = {}
	arg_72_0.vars.sendData.unequip = {}
	arg_72_0.vars.sendData.equip = {}
	arg_72_0.vars.sendData.equip[var_72_0] = {}
	
	for iter_72_0, iter_72_1 in pairs(arg_72_0.vars.selected_equips) do
		if iter_72_1.OriParent and iter_72_1.OriParent ~= nil then
			local var_72_2 = tostring(Account:getUnit(iter_72_1.OriParent):getUID())
			
			if not arg_72_0.vars.sendData.unequip[var_72_2] then
				arg_72_0.vars.sendData.unequip[var_72_2] = {}
			end
			
			if arg_72_0.vars.unit:getUID() ~= var_72_2 then
				table.insert(arg_72_0.vars.sendData.unequip[var_72_2], iter_72_1.id)
				
				var_72_1 = true
			end
		end
		
		if arg_72_0.vars.Original_equips[iter_72_0] and arg_72_0.vars.Original_equips[iter_72_0] ~= nil then
			if not arg_72_0.vars.sendData.unequip[var_72_0] then
				arg_72_0.vars.sendData.unequip[var_72_0] = {}
			end
			
			if tonumber(iter_72_1.id) ~= tonumber(arg_72_0.vars.Original_equips[iter_72_0].id) then
				table.insert(arg_72_0.vars.sendData.unequip[var_72_0], arg_72_0.vars.Original_equips[iter_72_0].id)
				
				var_72_1 = true
			end
		end
		
		if arg_72_0.vars.Original_equips[iter_72_0] == nil or tonumber(iter_72_1.id) ~= tonumber(arg_72_0.vars.Original_equips[iter_72_0].id) then
			table.insert(arg_72_0.vars.sendData.equip[var_72_0], iter_72_1.id)
			
			var_72_1 = true
		end
	end
	
	if var_72_1 == false then
		return false
	end
end

function UnitBuild.reqTotalChange(arg_73_0)
	query("puton_equip_mass", {
		putons = json.encode(arg_73_0.vars.sendData)
	})
end

function UnitBuild.resTotalChange(arg_74_0, arg_74_1)
	Account:updateCurrencies(arg_74_1)
	TopBarNew:topbarUpdate(true)
	
	for iter_74_0, iter_74_1 in pairs(arg_74_1.putons.unequip) do
		local var_74_0 = Account:getUnit(tonumber(iter_74_0))
		
		for iter_74_2, iter_74_3 in pairs(iter_74_1) do
			local var_74_1 = Account:getEquip(tonumber(iter_74_3))
			
			if var_74_0 ~= nil and var_74_1 ~= nil then
				var_74_0:removeEquip(var_74_1)
			end
		end
	end
	
	for iter_74_4, iter_74_5 in pairs(arg_74_1.putons.equip) do
		for iter_74_6, iter_74_7 in pairs(iter_74_5) do
			local var_74_2 = Account:getEquip(tonumber(iter_74_7))
			local var_74_3 = Account:getUnit(tonumber(iter_74_4))
			
			if var_74_3 ~= nil and var_74_2 ~= nil then
				if var_74_3:addEquip(var_74_2) == false then
					return 
				end
				
				UnitEquip:updateCondition(var_74_3, var_74_2)
			end
		end
	end
	
	arg_74_0.vars.items = {}
	arg_74_0.vars.Original_equips = {}
	arg_74_0.vars.selected_equips = {}
	arg_74_0.vars.allItems = {}
	arg_74_0.vars.sendData = {}
	
	for iter_74_8, iter_74_9 in pairs(var_0_0) do
		arg_74_0.vars.allItems[iter_74_9] = {}
	end
	
	arg_74_0.vars.filter.substat1_num = 1
	arg_74_0.vars.filter.substat2_num = 1
	arg_74_0.vars.filtersubstatPopup = 1
	arg_74_0.vars.changeCost = 0
	arg_74_0.vars.itemsetCount = {}
	
	local var_74_4 = UnitBuild:_getSetList()
	
	for iter_74_10, iter_74_11 in pairs(var_0_0) do
		arg_74_0.vars.itemsetCount[iter_74_11] = {}
		
		for iter_74_12, iter_74_13 in pairs(var_74_4) do
			arg_74_0.vars.itemsetCount[iter_74_11][iter_74_13] = 0
		end
	end
	
	arg_74_0.vars.unit = arg_74_0:cloneUnit(Account:getUnit(arg_74_0.vars.unit:getUID()))
	
	arg_74_0:getAllItems()
	arg_74_0:selectItemTab(1)
	
	arg_74_0.vars.prevStatus = arg_74_0.vars.unit:getStatus()
	
	arg_74_0:setChangeButton()
	arg_74_0:setItemSlot(arg_74_0.vars.wnd:getChildByName("CENTER"), arg_74_0.vars.unit)
	arg_74_0:update_currentStat(arg_74_0.vars.wnd:getChildByName("CENTER"), arg_74_0.vars.unit)
	arg_74_0:update_changeStat({
		first = true
	})
	arg_74_0:closeItemTooltip()
	arg_74_0:closeEquipChangePopup()
end

function UnitBuild.resetAll(arg_75_0)
	arg_75_0:selectItemTab(1)
	
	arg_75_0.vars.prevStatus = arg_75_0.vars.unit:getStatus()
	
	arg_75_0:setItemSlot(arg_75_0.vars.wnd:getChildByName("CENTER"), arg_75_0.vars.unit)
	arg_75_0:update_currentStat(arg_75_0.vars.wnd:getChildByName("CENTER"), arg_75_0.vars.unit)
	arg_75_0:update_changeStat({
		first = true
	})
	arg_75_0:closeItemTooltip()
	arg_75_0:closeEquipChangePopup()
end

function UnitBuild.setItemSetCount(arg_76_0)
	if not arg_76_0.vars.wnd or not arg_76_0:getCurrentCategoryName() then
		return 
	end
	
	local var_76_0 = arg_76_0.vars.wnd:getChildByName("n_set_box")
	local var_76_1 = arg_76_0:getCurrentCategoryName() or "weapon"
	local var_76_2 = UnitBuild:_getSetList()
	local var_76_3 = 2
	
	for iter_76_0, iter_76_1 in pairs(var_76_2) do
		local var_76_4 = var_76_0:getChildByName("btn_sort" .. var_76_3)
		local var_76_5 = arg_76_0.vars.itemsetCount[var_76_1][iter_76_1] or 0
		
		if var_76_4 == nil then
			break
		end
		
		if var_76_5 == 0 then
			if_set_visible(var_76_4, "txt_amount" .. var_76_3, false)
		else
			if_set_visible(var_76_4, "txt_amount" .. var_76_3, true)
			if_set(var_76_4, "txt_amount" .. var_76_3, var_76_5)
		end
		
		var_76_3 = var_76_3 + 1
	end
end

function UnitBuild.click_slots(arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = "weapon"
	local var_77_1 = arg_77_1 or 1
	local var_77_2 = arg_77_2 or false
	
	if arg_77_1 == 1 then
		var_77_0 = "weapon"
	elseif arg_77_1 == 2 then
		var_77_0 = "helm"
		var_77_1 = 4
	elseif arg_77_1 == 3 then
		var_77_0 = "neck"
	elseif arg_77_1 == 4 then
		var_77_0 = "armor"
		var_77_1 = 2
	elseif arg_77_1 == 5 then
		var_77_0 = "boot"
	elseif arg_77_1 == 6 then
		var_77_0 = "ring"
	end
	
	local var_77_3
	
	if arg_77_0.vars.selected_equips and arg_77_0.vars.selected_equips[var_77_0] and arg_77_0.vars.selected_equips[var_77_0] ~= nil and not var_77_2 then
		var_77_3 = arg_77_0.vars.selected_equips[var_77_0]
	end
	
	if var_77_3 == nil then
		arg_77_0:selectItemTab(var_77_1)
		
		return 
	end
	
	UnitBuild:onSelect(var_77_3)
end

function UnitBuild.set_equipEnhanceButton(arg_78_0)
	if not arg_78_0.vars.cur_item or not arg_78_0.vars.cur_item:isUpgradable() then
		if_set_opacity(arg_78_0.vars.wnd, "btn_enhance", 76.5)
	else
		if_set_opacity(arg_78_0.vars.wnd, "btn_enhance", 255)
	end
end

function UnitBuild.equipEnhance(arg_79_0)
	if not arg_79_0.vars or not arg_79_0.vars.cur_item then
		balloon_message_with_sound("ui_btn_enhance_no_equip")
		
		return 
	end
	
	if not arg_79_0.vars.cur_item:isUpgradable() then
		balloon_message_with_sound("cannot_enchant_exclusive_de")
		
		return 
	end
	
	local var_79_0
	
	for iter_79_0, iter_79_1 in pairs(Account.equips) do
		if not iter_79_1:isArtifact() and not iter_79_1:isStone() and not iter_79_1:isExclusive() and iter_79_1:getUID() == arg_79_0.vars.cur_item:getUID() then
			var_79_0 = iter_79_1
			
			break
		end
	end
	
	if not var_79_0 then
		Log.e("err no item data")
		
		return 
	end
	
	UnitEquipUpgrade:OpenPopup(var_79_0, {
		exit_callback = function()
			arg_79_0:equipEnhance_closeCallBack()
		end
	})
end

function UnitBuild.equipEnhance_closeCallBack(arg_81_0)
	TopBarNew:topbarUpdate(true)
	
	arg_81_0.vars.items = {}
	arg_81_0.vars.allItems = {}
	
	for iter_81_0, iter_81_1 in pairs(var_0_0) do
		arg_81_0.vars.allItems[iter_81_1] = {}
	end
	
	local var_81_0 = UnitBuild:_getSetList()
	
	arg_81_0.vars.itemsetCount = {}
	
	for iter_81_2, iter_81_3 in pairs(var_0_0) do
		arg_81_0.vars.itemsetCount[iter_81_3] = {}
		
		for iter_81_4, iter_81_5 in pairs(var_81_0) do
			arg_81_0.vars.itemsetCount[iter_81_3][iter_81_5] = 0
		end
	end
	
	arg_81_0:getAllItems2()
	arg_81_0:setItemSetCount()
	arg_81_0:refreshItems({
		reset = true
	})
	
	local var_81_1 = arg_81_0:getCurrentCategoryName()
	
	for iter_81_6, iter_81_7 in pairs(var_0_0) do
		if not arg_81_0.vars.items[iter_81_7] then
			arg_81_0.vars.items[iter_81_7] = arg_81_0:selectItems()
		end
	end
	
	arg_81_0:showEquipItem()
	
	local var_81_2 = arg_81_0.vars.selected_equips[arg_81_0.vars.cur_item.db.type]
	
	UnitBuild:onSelect(var_81_2)
	UnitBuild:onSelect(var_81_2)
	arg_81_0:closeItemTooltip()
	arg_81_0:openItemTooltip(var_81_2)
end

function UnitBuild.getAllItems2(arg_82_0)
	for iter_82_0, iter_82_1 in pairs(Account.equips) do
		if not iter_82_1:isArtifact() and not iter_82_1:isStone() and not iter_82_1:isExclusive() then
			local var_82_0 = iter_82_1:clone()
			
			var_82_0.OriParent = var_82_0.parent
			
			table.insert(arg_82_0.vars.allItems[iter_82_1.db.type], var_82_0)
			
			if (iter_82_1.parent == nil or iter_82_1.parent ~= arg_82_0.vars.unit:getUID()) and arg_82_0.vars.itemsetCount[iter_82_1.db.type] and arg_82_0.vars.itemsetCount[iter_82_1.db.type][iter_82_1.set_fx] and iter_82_1.parent == nil then
				arg_82_0.vars.itemsetCount[iter_82_1.db.type][iter_82_1.set_fx] = arg_82_0.vars.itemsetCount[iter_82_1.db.type][iter_82_1.set_fx] + 1
			end
			
			if arg_82_0.vars.selected_equips then
				for iter_82_2, iter_82_3 in pairs(arg_82_0.vars.selected_equips) do
					if iter_82_3:getUID() == var_82_0:getUID() then
						arg_82_0.vars.selected_equips[var_82_0.db.type] = var_82_0
						arg_82_0.vars.selected_equips[var_82_0.db.type].parent = arg_82_0.vars.unit:getUID()
						
						break
					end
				end
			end
			
			if iter_82_1.parent and iter_82_1.parent == arg_82_0.vars.unit:getUID() then
				arg_82_0.vars.Original_equips[iter_82_1.db.type] = var_82_0
			end
		end
	end
end

function UnitBuild.openRecommendPopup(arg_83_0)
	if not arg_83_0.vars or not get_cocos_refid(arg_83_0.vars.wnd) then
		return 
	end
	
	EquipRecommenderUI:open({
		unit = arg_83_0.vars.unit,
		equips = arg_83_0.vars.allItems,
		recommend_opts = arg_83_0.vars.recommend_opts
	})
end

function UnitBuild.recommendEquips(arg_84_0, arg_84_1)
	if not arg_84_0.vars or not get_cocos_refid(arg_84_0.vars.wnd) then
		return 
	end
	
	for iter_84_0, iter_84_1 in pairs(arg_84_1) do
		arg_84_0:setSelect(iter_84_1, true)
		arg_84_0:update_changeStat({
			itemdata = iter_84_1
		})
	end
	
	local var_84_0 = UnitBuild:getCurrentCategoryName() or nil
	
	if arg_84_0.vars.selected_equips and var_84_0 and arg_84_0.vars.selected_equips[var_84_0] then
		arg_84_0.vars.cur_item = arg_84_0.vars.selected_equips[var_84_0]
	else
		arg_84_0.vars.cur_item = nil
	end
	
	arg_84_0:set_equipEnhanceButton()
	arg_84_0:setChangeButton()
	arg_84_0:closeItemTooltip()
end

function UnitBuild.saveRecommendOptions(arg_85_0, arg_85_1)
	if not arg_85_0.vars or not get_cocos_refid(arg_85_0.vars.wnd) then
		return 
	end
	
	arg_85_0.vars.recommend_opts = arg_85_1
end

function UnitBuild._getSetList(arg_86_0, arg_86_1)
	return UIUtil:getSetItemListExtention(arg_86_1)
end

function UnitBuild.closeEquipChangePopup(arg_87_0)
	if not arg_87_0.vars.changePopup_wnd or not get_cocos_refid(arg_87_0.vars.changePopup_wnd) then
		return 
	end
	
	BackButtonManager:pop("equip_change_popup")
	arg_87_0.vars.changePopup_wnd:removeFromParent()
	
	arg_87_0.vars.changePopup_wnd = nil
end

function UnitBuild.onLeave(arg_88_0, arg_88_1)
	if not UnitMain:isDisableTopRight() then
		TopBarNew:setEnableTopRight()
	end
	
	UIAction:Add(SEQ(SPAWN(TARGET(arg_88_0.vars.wnd:getChildByName("bg_black"), FADE_OUT(50)), TARGET(arg_88_0.vars.wnd:getChildByName("n_space"), SCALE(250, 1, 0))), DELAY(30), REMOVE()), arg_88_0.vars.wnd, "block")
	BackButtonManager:pop({
		dlg = arg_88_0.vars.wnd
	})
end

function UnitBuild._devEnhanceEquip(arg_89_0)
	arg_89_0:equipEnhance()
end

function UnitBuild._devChagneUnit(arg_90_0, arg_90_1)
	if not arg_90_1 then
		return 
	end
	
	local var_90_0 = Account:getUnits()
	
	for iter_90_0, iter_90_1 in pairs(var_90_0) do
		if arg_90_1 == iter_90_1.db.code then
			unit = iter_90_1
		end
	end
	
	if not unit then
		Log.e("없는 영웅입니다.")
		
		return 
	end
	
	arg_90_0:changeUnit(unit)
end
