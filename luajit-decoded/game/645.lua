EquipRecommenderUI = {}

local var_0_0 = {
	"weapon",
	"armor",
	"neck",
	"helm",
	"boot",
	"ring"
}

function HANDLER.equip_base_autosel(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		EquipRecommenderUI:onPushBackButton()
	elseif arg_1_1 == "btn_Help" then
		HelpGuide:open({
			contents_id = "infoitem_4_1"
		})
	elseif arg_1_1 == "checkbox_g" then
		EquipRecommenderUI:updateEquipped()
	elseif arg_1_1 == "btn_checkbox_g" then
		EquipRecommenderUI:toggleEquipped()
	elseif arg_1_1 == "btn_set" then
		EquipRecommenderUI:onButtonFilter(arg_1_0)
	elseif arg_1_1 == "btn_set_sel" then
		EquipRecommenderUI:onButtonFilter(arg_1_0:getParent())
	elseif arg_1_1 == "btn_auto_sel" then
		EquipRecommenderUI:resetFilter()
	elseif arg_1_1 == "btn_sel_complete" then
		EquipRecommenderUI:recommend()
	elseif arg_1_1 == "btn_equip_arti" then
		if ContentDisable:byAlias("eq_arti_statistics") then
			balloon_message(T("content_disable"))
		elseif UnitBuild.vars and UnitBuild.vars.unit and UnitBuild.vars.unit.db and UnitBuild.vars.unit.db.code then
			Stove:openHeroEquipStatisticsPage(UnitBuild.vars.unit.db.code, STOVE_HERO_URL_PTYPE.hero_equip)
		end
	end
end

function HANDLER.autoequip_n_set_box(arg_2_0, arg_2_1)
	if string.starts(arg_2_1, "btn_sort") then
		EquipRecommenderUI:onSetFilter(arg_2_0)
	elseif arg_2_1 == "btn_toggle" then
		EquipRecommenderUI:updateSetFilter()
		EquipRecommenderUI:closeFilter()
	end
end

function HANDLER.autoequip_n_stat_box(arg_3_0, arg_3_1)
	if string.starts(arg_3_1, "btn_sort") then
		EquipRecommenderUI:onStatFilter(arg_3_0)
	elseif arg_3_1 == "btn_toggle" then
		EquipRecommenderUI:updateStatFilter()
		EquipRecommenderUI:closeFilter()
	end
end

function EquipRecommenderUI.open(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or {}
	
	if arg_4_1.recommend_opts then
		arg_4_1.priority = arg_4_1.recommend_opts.priority
		arg_4_1.set_filter = arg_4_1.recommend_opts.set_filter
		arg_4_1.stat_filter = arg_4_1.recommend_opts.stat_filter
		arg_4_1.include_equipped = arg_4_1.recommend_opts.include_equipped
	end
	
	local var_4_0 = arg_4_1.layer or SceneManager:getRunningNativeScene()
	
	if not get_cocos_refid(var_4_0) then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.wnd = load_dlg("equip_base_autosel", true, "wnd", function()
		EquipRecommenderUI:onPushBackButton()
	end)
	arg_4_0.vars.unit = arg_4_1.unit
	arg_4_0.vars.equips = arg_4_1.equips
	arg_4_0.vars.slot_remain = 6
	
	arg_4_0:setItemSetCount()
	arg_4_0:initSliders(arg_4_1)
	arg_4_0:initButtons(arg_4_1)
	arg_4_0:updateEquipped(arg_4_1.include_equipped or false)
	arg_4_0:updateSetFilter()
	arg_4_0:updateStatFilter()
	var_4_0:addChild(arg_4_0.vars.wnd)
end

function EquipRecommenderUI.setItemSetCount(arg_6_0)
	local var_6_0 = arg_6_0.vars.equips
	
	arg_6_0.vars.item_set_count = {}
	arg_6_0.vars.unequipped_count = {}
	
	for iter_6_0, iter_6_1 in pairs(var_0_0) do
		for iter_6_2, iter_6_3 in pairs(var_6_0[iter_6_1]) do
			local var_6_1 = iter_6_3.set_fx or "default"
			
			if not arg_6_0.vars.item_set_count[var_6_1] then
				arg_6_0.vars.item_set_count[var_6_1] = 0
				arg_6_0.vars.unequipped_count[var_6_1] = 0
			end
			
			if not iter_6_3.parent or iter_6_3.parent == arg_6_0.vars.unit then
				arg_6_0.vars.unequipped_count[var_6_1] = arg_6_0.vars.unequipped_count[var_6_1] + 1
			end
			
			arg_6_0.vars.item_set_count[var_6_1] = arg_6_0.vars.item_set_count[var_6_1] + 1
		end
	end
end

function EquipRecommenderUI.initSliders(arg_7_0, arg_7_1)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	local var_7_0 = {
		"att_rate",
		"def_rate",
		"max_hp_rate",
		"speed",
		"cri",
		"cri_dmg",
		"acc",
		"res"
	}
	local var_7_1 = {
		"-",
		T("ui_equip_recommand_low"),
		T("ui_equip_recommand_normal"),
		T("ui_equip_recommand_high")
	}
	
	arg_7_0.vars.sliders = {}
	arg_7_0.vars.priority = {}
	
	for iter_7_0 = 1, #var_7_0 do
		local var_7_2 = arg_7_0.vars.wnd:getChildByName("n_" .. iter_7_0)
		local var_7_3 = var_7_0[iter_7_0]
		
		local function var_7_4(arg_8_0, arg_8_1, arg_8_2)
			arg_7_0.vars.priority[var_7_3] = arg_8_1 / 2 + 1
			
			local var_8_0 = var_7_2:getChildByName("im")
			
			if_set(var_8_0, nil, var_7_1[arg_7_0.vars.priority[var_7_3]])
			
			if arg_8_1 == 0 then
				var_8_0:setTextColor(cc.c3b(136, 136, 136))
				if_set_color(var_7_2, "icon_stat", cc.c3b(93, 93, 93))
			else
				var_8_0:setTextColor(cc.c3b(171, 135, 89))
				if_set_color(var_7_2, "icon_stat", cc.c3b(255, 255, 255))
			end
		end
		
		local var_7_5 = var_7_2:getChildByName("slider")
		
		var_7_5:addEventListener(function(arg_9_0, arg_9_1)
			local var_9_0 = arg_9_0:getPercent()
			
			if var_9_0 % 2 == 1 then
				var_9_0 = var_9_0 + 1
			end
			
			if arg_9_0.min and var_9_0 < arg_9_0.min then
				var_9_0 = arg_9_0.min
			end
			
			if arg_9_0.max and var_9_0 > arg_9_0.max then
				var_9_0 = arg_9_0.max
			end
			
			arg_9_0:setPercent(var_9_0)
			
			if arg_9_0.handler then
				set_high_fps_tick()
				arg_9_0.handler(arg_9_0.parent or getParentWindow(arg_9_0), arg_9_0:getPercent(), arg_9_1)
			end
		end)
		
		var_7_5.handler = var_7_4
		var_7_5.slider_pos = 2
		var_7_5.min = 0
		var_7_5.max = 6
		
		var_7_5:setMaxPercent(6)
		
		var_7_5.parent = var_7_2
		
		if arg_7_1.priority then
			var_7_5:setPercent((arg_7_1.priority[var_7_3] - 1) * 2)
			var_7_5:handler((arg_7_1.priority[var_7_3] - 1) * 2)
		else
			var_7_5:setPercent(2)
			var_7_5:handler(2)
		end
		
		table.insert(arg_7_0.vars.sliders, var_7_5)
	end
end

function EquipRecommenderUI.initButtons(arg_10_0, arg_10_1)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	local var_10_0 = IS_PUBLISHER_STOVE and not ContentDisable:byAlias("eq_arti_statistics")
	
	if_set_visible(arg_10_0.vars.wnd, "btn_equip_arti", var_10_0)
	
	arg_10_0.vars.n_set_filter = {}
	
	local var_10_1 = arg_10_0.vars.wnd:getChildByName("n_set_sel")
	
	for iter_10_0 = 1, 3 do
		local var_10_2 = var_10_1:getChildByName("n_btn_set" .. iter_10_0)
		
		if get_cocos_refid(var_10_2) then
			var_10_2.index = iter_10_0
			var_10_2.is_set = true
			var_10_2.filter = arg_10_1.set_filter and arg_10_1.set_filter[iter_10_0] or "all"
			arg_10_0.vars.n_set_filter[iter_10_0] = var_10_2
			
			if_set(var_10_2, "label", arg_10_0:getSetItemName("all"))
		end
	end
	
	arg_10_0.vars.n_stat_filter = {}
	
	local var_10_3 = {
		"neck",
		"ring",
		"boot"
	}
	local var_10_4 = arg_10_0.vars.wnd:getChildByName("n_main_stat_sel")
	
	for iter_10_1 = 1, 3 do
		local var_10_5 = var_10_4:getChildByName("n_btn_set" .. iter_10_1)
		local var_10_6 = var_10_3[iter_10_1]
		
		if get_cocos_refid(var_10_5) then
			var_10_5.parts = var_10_6
			var_10_5.filter = arg_10_1.stat_filter and arg_10_1.stat_filter[var_10_6] or "all"
			arg_10_0.vars.n_stat_filter[var_10_6] = var_10_5
			
			if_set(var_10_5, "label", arg_10_0:getStatName("all"))
		end
	end
end

function EquipRecommenderUI.toggleEquipped(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	arg_11_0:updateEquipped(not arg_11_0.vars.include_equipped)
end

function EquipRecommenderUI.updateEquipped(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.wnd:findChildByName("checkbox_g")
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	if arg_12_1 ~= nil then
		var_12_0:setSelected(arg_12_1)
	end
	
	arg_12_0.vars.include_equipped = var_12_0:isSelected()
end

function EquipRecommenderUI.onButtonSlider(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	arg_13_1 = to_n(arg_13_1)
	arg_13_2 = to_n(arg_13_2) - 1
	
	local var_13_0 = arg_13_0.vars.sliders[arg_13_1]
	
	var_13_0:setPercent(arg_13_2)
	var_13_0:handler(arg_13_2)
end

function EquipRecommenderUI.onButtonFilter(arg_14_0, arg_14_1)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	if get_cocos_refid(arg_14_0.vars.filter_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_14_1) then
		return 
	end
	
	local var_14_0 = arg_14_1:getParent()
	
	arg_14_0.vars.n_selected = var_14_0
	
	if var_14_0.is_set then
		if var_14_0.filter == "all" and arg_14_0.vars.slot_remain == 0 then
			balloon_message_with_sound("ui_equip_recommand_select_more_err_msg")
			
			arg_14_0.vars.n_selected = nil
			
			return 
		end
		
		local var_14_1 = arg_14_0.vars.wnd:getChildByName("n_set_box_" .. var_14_0.index)
		
		arg_14_0:updateSetFilter()
		
		if var_14_0.filter then
			local var_14_2 = EquipRecommender:getSetNumber(var_14_0.filter)
			
			arg_14_0.vars.slot_remain = arg_14_0.vars.slot_remain + var_14_2
		end
		
		arg_14_0:openSetFilter(var_14_1)
	else
		arg_14_0:updateStatFilter()
		arg_14_0:openStatFilter(var_14_0)
	end
	
	if_set_visible(arg_14_1, nil, false)
	if_set_visible(var_14_0, "btn_set_done", true)
	BackButtonManager:push({
		check_id = "equip_base_autosel_filter",
		back_func = function()
			EquipRecommenderUI:updateSetFilter()
			EquipRecommenderUI:updateStatFilter()
			EquipRecommenderUI:closeFilter()
		end
	})
end

function EquipRecommenderUI.openSetFilter(arg_16_0, arg_16_1)
	local var_16_0 = load_control("wnd/sorting_filter_equip_set.csb")
	local var_16_1 = UIUtil:getSetItemListExtention(true)
	
	for iter_16_0 = 1, #var_16_1 do
		local var_16_2 = var_16_0:getChildByName("btn_sort_" .. iter_16_0)
		local var_16_3 = var_16_1[iter_16_0]
		local var_16_4 = EquipRecommender:getSetNumber(var_16_3)
		
		var_16_2.filter = var_16_3
		var_16_2.number = var_16_4
		
		if_set(var_16_2, "txt_sort" .. iter_16_0, arg_16_0:getSetItemName(var_16_3))
		if_set(var_16_2, "txt_amount" .. iter_16_0, arg_16_0.vars.include_equipped and arg_16_0.vars.item_set_count[var_16_3] or arg_16_0.vars.unequipped_count[var_16_3])
		if_set_opacity(var_16_2, nil, var_16_4 > arg_16_0.vars.slot_remain and 76.5 or 255)
	end
	
	var_16_0:setName("autoequip_n_set_box")
	arg_16_1:addChild(var_16_0)
	
	arg_16_0.vars.filter_wnd = var_16_0
end

function EquipRecommenderUI.openStatFilter(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.parts
	local var_17_1 = arg_17_1.filter
	local var_17_2 = load_control("wnd/sorting_filter_acc_stat.csb")
	local var_17_3 = arg_17_0.vars.wnd:getChildByName("n_stat_box")
	local var_17_4 = UIUtil:getMainStatListByParts(var_17_0, true)
	
	for iter_17_0 = 1, #var_17_4 do
		local var_17_5 = var_17_2:getChildByName("btn_sort_" .. iter_17_0)
		local var_17_6 = var_17_4[iter_17_0]
		local var_17_7 = UIUtil:getStatIconPath(var_17_6)
		
		var_17_5.filter = var_17_6
		
		if_set(var_17_5, "txt_sort2", arg_17_0:getStatName(var_17_6))
		if_set_sprite(var_17_5, "icon_sort2", var_17_7)
		if_set_visible(var_17_5, "icon_pers", string.sub(var_17_6, -4, -1) == "rate")
		if_set_visible(var_17_5, "cursor", var_17_6 == var_17_1)
	end
	
	if var_17_0 == "boot" then
		if_set_visible(var_17_2, "btn_sort_9", false)
		
		local var_17_8 = var_17_2:getChildByName("bg")
		
		var_17_8:setContentSize(var_17_8:getContentSize().width, var_17_8:getContentSize().height - 44)
	end
	
	var_17_2:setName("autoequip_n_stat_box")
	var_17_3:addChild(var_17_2)
	
	arg_17_0.vars.filter_wnd = var_17_2
end

function EquipRecommenderUI.onSetFilter(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not arg_18_1 then
		return 
	end
	
	if arg_18_1.number > arg_18_0.vars.slot_remain then
		balloon_message_with_sound("ui_equip_recommand_select_more_err_msg")
		
		return 
	end
	
	arg_18_0.vars.n_selected.filter = arg_18_1.filter
	
	arg_18_0:updateSetFilter()
	arg_18_0:closeFilter()
end

function EquipRecommenderUI.updateSetFilter(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	arg_19_0.vars.slot_remain = 6
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.n_set_filter) do
		local var_19_0 = iter_19_1.filter
		local var_19_1 = EQUIP:getSetItemIconPath(var_19_0)
		
		if arg_19_0.vars.n_selected == iter_19_1 then
			local var_19_2 = iter_19_1:getChildByName("btn_set_done")
			
			if_set(var_19_2, "label", arg_19_0:getSetItemName(var_19_0))
			if_set_sprite(var_19_2, "icon_stat", var_19_1)
			if_set_visible(var_19_2, "icon_all", var_19_0 == "all")
			if_set_visible(var_19_2, "icon_stat", var_19_0 ~= "all")
		end
		
		if var_19_0 ~= "all" then
			local var_19_3 = iter_19_1:getChildByName("btn_set_sel")
			local var_19_4 = EquipRecommender:getSetNumber(iter_19_1.filter)
			
			arg_19_0.vars.slot_remain = arg_19_0.vars.slot_remain - var_19_4
			
			if_set(var_19_3, "label_sel", arg_19_0:getSetItemName(var_19_0))
			if_set_sprite(var_19_3, "icon_stat", var_19_1)
		end
		
		if_set_visible(iter_19_1, "btn_set_done", arg_19_0.vars.n_selected == iter_19_1)
		if_set_visible(iter_19_1, "btn_set", iter_19_1.filter == "all")
		if_set_visible(iter_19_1, "btn_set_sel", iter_19_1.filter ~= "all")
	end
	
	for iter_19_2, iter_19_3 in pairs(arg_19_0.vars.n_set_filter) do
		if iter_19_3.filter == "all" then
			if_set_opacity(iter_19_3, nil, arg_19_0.vars.slot_remain == 0 and 76.5 or 255)
		end
	end
end

function EquipRecommenderUI.onStatFilter(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not arg_20_1 then
		return 
	end
	
	arg_20_0.vars.n_selected.filter = arg_20_1.filter
	
	arg_20_0:updateStatFilter()
	arg_20_0:closeFilter()
end

function EquipRecommenderUI.updateStatFilter(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.n_stat_filter) do
		local var_21_0 = iter_21_1.filter
		local var_21_1 = UIUtil:getStatIconPath(var_21_0)
		
		if arg_21_0.vars.n_selected == iter_21_1 then
			local var_21_2 = iter_21_1:getChildByName("btn_set_done")
			
			if_set(var_21_2, "label", arg_21_0:getStatName(var_21_0))
			if_set_sprite(var_21_2, "icon_stat", var_21_1)
			if_set_visible(var_21_2, "icon_all", var_21_0 == "all")
			if_set_visible(var_21_2, "icon_stat", var_21_0 ~= "all")
			if_set_visible(var_21_2, "icon_per", string.sub(var_21_0, -4, -1) == "rate")
		end
		
		if var_21_0 ~= "all" then
			local var_21_3 = iter_21_1:getChildByName("btn_set_sel")
			
			if_set(var_21_3, "label_sel", arg_21_0:getStatName(var_21_0))
			if_set_sprite(var_21_3, "icon_stat", var_21_1)
			if_set_visible(var_21_3, "icon_per", string.sub(var_21_0, -4, -1) == "rate")
		end
		
		if_set_visible(iter_21_1, "btn_set_done", arg_21_0.vars.n_selected == iter_21_1)
		if_set_visible(iter_21_1, "btn_set", iter_21_1.filter == "all")
		if_set_visible(iter_21_1, "btn_set_sel", iter_21_1.filter ~= "all")
	end
end

function EquipRecommenderUI.recommend(arg_22_0)
	local var_22_0 = EquipRecommender:getBestEquips(arg_22_0:getRecommendOptions())
	
	if not var_22_0 or table.count(var_22_0) < 6 then
		balloon_message_with_sound("ui_equip_recommand_not_enough_err_msg")
		
		return 
	end
	
	UnitBuild:recommendEquips(var_22_0)
	EquipRecommenderUI:onPushBackButton()
end

function EquipRecommenderUI.getRecommendOptions(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	return {
		unit = arg_23_0.vars.unit,
		equips = arg_23_0.vars.equips,
		include_equipped = arg_23_0.vars.include_equipped,
		set_filter = arg_23_0:getSetFilter(),
		stat_filter = arg_23_0:getStatFilter(),
		priority = arg_23_0.vars.priority
	}
end

function EquipRecommenderUI.getSetFilter(arg_24_0)
	local var_24_0 = {}
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.n_set_filter) do
		table.insert(var_24_0, iter_24_1.filter)
	end
	
	return var_24_0
end

function EquipRecommenderUI.getStatFilter(arg_25_0)
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.n_stat_filter) do
		if iter_25_1.filter ~= "all" then
			var_25_0[iter_25_0] = iter_25_1.filter
		end
	end
	
	return var_25_0
end

function EquipRecommenderUI.resetFilter(arg_26_0)
	if not arg_26_0.vars then
		return 
	end
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.n_set_filter) do
		iter_26_1.filter = "all"
	end
	
	arg_26_0:updateSetFilter()
	
	for iter_26_2, iter_26_3 in pairs(arg_26_0.vars.n_stat_filter) do
		iter_26_3.filter = "all"
	end
	
	arg_26_0:updateStatFilter()
	
	for iter_26_4, iter_26_5 in pairs(arg_26_0.vars.sliders) do
		iter_26_5:handler(2)
		iter_26_5:setPercent(2)
	end
	
	arg_26_0:updateEquipped(false)
end

function EquipRecommenderUI.closeFilter(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.filter_wnd) then
		return 
	end
	
	arg_27_0.vars.filter_wnd:removeFromParent()
	
	arg_27_0.vars.filter_wnd = nil
	
	if_set_visible(arg_27_0.vars.n_selected, "btn_set_done", false)
	
	arg_27_0.vars.n_selected = nil
	
	BackButtonManager:pop("equip_base_autosel_filter")
end

function EquipRecommenderUI.onPushBackButton(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	UnitBuild:saveRecommendOptions(arg_28_0:getRecommendOptions())
	arg_28_0.vars.wnd:removeFromParent()
	
	arg_28_0.vars = nil
	
	BackButtonManager:pop("equip_base_autosel")
end

function EquipRecommenderUI.getSetItemName(arg_29_0, arg_29_1)
	return T(DB("item_set", arg_29_1, {
		"name"
	}) or "ui_equip_base_stat_filter_all")
end

function EquipRecommenderUI.getStatName(arg_30_0, arg_30_1)
	if not arg_30_1 or arg_30_1 == "all" then
		return T("ui_equip_base_stat_filter_all")
	else
		return getStatName(arg_30_1)
	end
end

EquipRecommender = {}

function EquipRecommender.getBestEquips(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1.unit:clone()
	
	for iter_31_0 = table.count(var_31_0.equips), 1, -1 do
		if not var_31_0.equips[iter_31_0]:isExclusive() then
			table.remove(var_31_0.equips, iter_31_0)
		end
	end
	
	var_31_0:calc()
	
	local var_31_1 = var_31_0:getStatus()
	local var_31_2 = {}
	local var_31_3 = {
		cri = (FORMULA.getStatLimit("cri") or 1) - var_31_1.cri,
		cri_dmg = (FORMULA.getStatLimit("cri_dmg") or 3.5) - var_31_1.cri_dmg
	}
	
	arg_31_1.unit = var_31_0
	
	local var_31_4 = arg_31_0:calcEquips(arg_31_1)
	local var_31_5 = var_31_4.equips
	local var_31_6 = var_31_4.point
	
	for iter_31_1 = 1, 4 do
		local var_31_7 = math.pow(0.5, iter_31_1 + 1)
		
		for iter_31_2, iter_31_3 in pairs(var_31_3) do
			if var_31_4.stats[iter_31_2] then
				if iter_31_3 < var_31_4.stats[iter_31_2] then
					var_31_2[iter_31_2] = (var_31_2[iter_31_2] or 1) - var_31_7
				elseif var_31_2[iter_31_2] then
					var_31_2[iter_31_2] = var_31_2[iter_31_2] + var_31_7
				end
			end
		end
		
		if table.empty(var_31_2) then
			break
		end
		
		arg_31_1.mod_value = var_31_2
		var_31_4 = arg_31_0:calcEquips(arg_31_1)
		
		if var_31_6 < var_31_4.point then
			var_31_5 = var_31_4.equips
			var_31_6 = var_31_4.point
		end
	end
	
	return var_31_5
end

function EquipRecommender.calcEquips(arg_32_0, arg_32_1)
	arg_32_1 = arg_32_1 or {}
	
	local var_32_0 = arg_32_1.equips
	local var_32_1 = arg_32_1.unit
	local var_32_2 = arg_32_1.priority
	local var_32_3 = {}
	local var_32_4 = {}
	local var_32_5 = {}
	local var_32_6 = {
		0.01,
		0.66,
		1,
		1.33
	}
	local var_32_7 = var_32_1:getCharacterStatus()
	local var_32_8 = var_32_1:getStatus()
	local var_32_9 = (FORMULA.getStatLimit("cri") or 1) - var_32_8.cri
	local var_32_10 = (FORMULA.getStatLimit("cri_dmg") or 3.5) - var_32_8.cri_dmg
	
	local function var_32_11(arg_33_0, arg_33_1)
		local var_33_0 = {}
		local var_33_1 = 0
		
		for iter_33_0, iter_33_1 in pairs(arg_33_0 or {}) do
			local var_33_2 = iter_33_0
			local var_33_3 = iter_33_1
			
			if var_33_2 == "att" or var_33_2 == "def" or var_33_2 == "max_hp" then
				var_33_3 = var_33_3 / var_32_7[var_33_2]
				var_33_2 = var_33_2 .. "_rate"
			elseif var_33_2 == "speed" then
				var_33_3 = var_33_3 * 0.02
			elseif var_33_2 == "speed_rate" then
				var_33_3 = var_33_3 * var_32_7.speed * 0.02
				var_33_2 = "speed"
			elseif var_33_2 == "cri" then
				if var_33_3 > var_32_9 then
					var_33_3 = var_32_9
				end
				
				var_33_3 = var_33_3 * 1.5
			elseif var_33_2 == "cri_dmg" then
				if var_33_3 > var_32_10 then
					var_33_3 = var_32_10
				end
				
				var_33_3 = var_33_3 * 1.1
			elseif var_33_2 == "coop" then
				var_33_3 = 0
			end
			
			if var_33_0[var_33_2] then
				var_33_3 = var_33_0[var_33_2] + var_33_3
			end
			
			var_33_0[var_33_2] = var_33_3
		end
		
		for iter_33_2, iter_33_3 in pairs(var_32_2 or {}) do
			if var_33_0[iter_33_2] then
				var_33_0[iter_33_2] = var_33_0[iter_33_2] * var_32_6[iter_33_3]
			end
		end
		
		for iter_33_4, iter_33_5 in pairs(arg_33_1 or {}) do
			if var_33_0[iter_33_4] then
				var_33_0[iter_33_4] = var_33_0[iter_33_4] * iter_33_5
			end
		end
		
		for iter_33_6, iter_33_7 in pairs(var_33_0) do
			var_33_1 = var_33_1 + iter_33_7
		end
		
		return var_33_1
	end
	
	local function var_32_12(arg_34_0, arg_34_1)
		local var_34_0, var_34_1 = arg_34_0:getMainStat()
		local var_34_2 = arg_34_0.op
		local var_34_3 = arg_34_1 or {}
		
		var_34_3[var_34_1] = (var_34_3[var_34_1] or 0) + var_34_0
		
		for iter_34_0 = 2, #var_34_2 do
			local var_34_4 = var_34_2[iter_34_0][1]
			local var_34_5 = var_34_2[iter_34_0][2]
			
			var_34_3[var_34_4] = (var_34_3[var_34_4] or 0) + var_34_5
		end
		
		return var_34_3
	end
	
	local function var_32_13(arg_35_0)
		local var_35_0 = var_32_12(arg_35_0)
		
		return var_32_11(var_35_0, arg_32_1.mod_value)
	end
	
	local var_32_14 = arg_32_1.stat_filter
	
	for iter_32_0, iter_32_1 in pairs(var_0_0) do
		if var_32_0[iter_32_1] then
			var_32_3[iter_32_1] = {}
			
			for iter_32_2, iter_32_3 in pairs(var_32_0[iter_32_1]) do
				local var_32_15 = iter_32_3.set_fx or "default"
				local var_32_16, var_32_17 = iter_32_3:getMainStat()
				local var_32_18 = true
				
				if not var_32_4[var_32_15] then
					var_32_4[var_32_15] = {}
				end
				
				if iter_32_3.OriParent and iter_32_3.OriParent ~= var_32_1:getUID() then
					var_32_18 = arg_32_1.include_equipped
				end
				
				if var_32_14[iter_32_1] and var_32_14[iter_32_1] ~= var_32_17 then
					var_32_18 = false
				end
				
				if var_32_18 then
					local var_32_19 = {
						equip = iter_32_3,
						point = var_32_13(iter_32_3)
					}
					
					if not var_32_3[iter_32_1][var_32_15] or var_32_3[iter_32_1][var_32_15].point < var_32_19.point then
						var_32_3[iter_32_1][var_32_15] = var_32_19
						
						if not var_32_5[iter_32_1] or var_32_19.point > var_32_5[iter_32_1].point then
							var_32_5[iter_32_1] = var_32_19
						end
					end
				end
			end
		end
		
		if not var_32_5[iter_32_1] then
			return {
				point = 0,
				equips = {},
				stats = {}
			}
		end
	end
	
	local var_32_20 = {}
	local var_32_21 = {}
	
	local function var_32_22(arg_36_0, arg_36_1)
		local var_36_0 = {}
		
		for iter_36_0 = 1, #var_0_0 - 1 do
			for iter_36_1 = iter_36_0 + 1, #var_0_0 do
				local var_36_1 = iter_36_0 .. "/" .. iter_36_1
				local var_36_2 = {}
				local var_36_3 = arg_36_1
				
				for iter_36_2 = 1, #var_0_0 do
					if iter_36_2 ~= iter_36_0 and iter_36_2 ~= iter_36_1 then
						if var_32_3[var_0_0[iter_36_2]][arg_36_0] then
							var_36_2[var_0_0[iter_36_2]] = var_32_3[var_0_0[iter_36_2]][arg_36_0].equip
							var_36_3 = var_36_3 + var_32_3[var_0_0[iter_36_2]][arg_36_0].point
						else
							var_36_2 = nil
							
							break
						end
					end
				end
				
				if var_36_2 then
					var_36_0[var_36_1] = {
						equips = var_36_2,
						point = var_36_3
					}
					
					if not var_32_20[var_36_1] or var_36_3 > var_32_20[var_36_1].point then
						var_32_20[var_36_1] = {
							set_fx = arg_36_0,
							equips = var_36_2,
							point = var_36_3
						}
					end
				end
			end
		end
		
		return var_36_0
	end
	
	local function var_32_23(arg_37_0, arg_37_1)
		local var_37_0 = {}
		
		for iter_37_0 = 1, #var_0_0 - 1 do
			for iter_37_1 = iter_37_0 + 1, #var_0_0 do
				local var_37_1 = iter_37_0 .. "/" .. iter_37_1
				local var_37_2 = {}
				
				if var_32_3[var_0_0[iter_37_0]][arg_37_0] and var_32_3[var_0_0[iter_37_1]][arg_37_0] then
					var_37_2[var_0_0[iter_37_0]] = var_32_3[var_0_0[iter_37_0]][arg_37_0].equip
					var_37_2[var_0_0[iter_37_1]] = var_32_3[var_0_0[iter_37_1]][arg_37_0].equip
					
					local var_37_3 = var_32_3[var_0_0[iter_37_0]][arg_37_0].point + var_32_3[var_0_0[iter_37_1]][arg_37_0].point + arg_37_1
					
					var_37_0[var_37_1] = {
						equips = var_37_2,
						point = var_37_3
					}
					
					if not var_32_21[var_37_1] or var_37_3 > var_32_21[var_37_1].point then
						var_32_21[var_37_1] = {
							set_fx = arg_37_0,
							equips = var_37_2,
							point = var_37_3
						}
					end
				end
			end
		end
		
		return var_37_0
	end
	
	local function var_32_24(arg_38_0, arg_38_1)
		for iter_38_0, iter_38_1 in pairs(arg_38_1) do
			arg_38_0[iter_38_0] = iter_38_1
		end
		
		return arg_38_0
	end
	
	local function var_32_25(arg_39_0, arg_39_1)
		local var_39_0 = {}
		local var_39_1 = string.split(arg_39_0, "/")
		local var_39_2 = to_n(var_39_1[1])
		local var_39_3 = to_n(var_39_1[2])
		local var_39_4 = 0
		
		if arg_39_1 == 4 then
			for iter_39_0 = 1, 6 do
				if iter_39_0 ~= var_39_2 and iter_39_0 ~= var_39_3 then
					var_39_0[var_0_0[iter_39_0]] = var_32_5[var_0_0[iter_39_0]].equip
					var_39_4 = var_39_4 + var_32_5[var_0_0[iter_39_0]].point
				end
			end
			
			if var_32_20[arg_39_0] and var_39_4 < var_32_20[arg_39_0].point then
				return var_32_20[arg_39_0].equips, var_32_20[arg_39_0].point
			end
		elseif arg_39_1 == 2 then
			var_39_0[var_0_0[var_39_2]] = var_32_5[var_0_0[var_39_2]].equip
			var_39_0[var_0_0[var_39_3]] = var_32_5[var_0_0[var_39_3]].equip
			var_39_4 = var_32_5[var_0_0[var_39_2]].point + var_32_5[var_0_0[var_39_3]].point
			
			if var_32_21[arg_39_0] and var_39_4 < var_32_21[arg_39_0].point then
				return var_32_21[arg_39_0].equips, var_32_21[arg_39_0].point
			end
		end
		
		return var_39_0, var_39_4
	end
	
	local function var_32_26(arg_40_0, arg_40_1)
		for iter_40_0, iter_40_1 in pairs(arg_40_0) do
			var_32_12(iter_40_1, arg_40_1)
		end
		
		return arg_40_1
	end
	
	local function var_32_27(arg_41_0, arg_41_1, arg_41_2)
		if arg_41_0 then
			if arg_41_0.equip_hash[arg_41_1] then
				return arg_41_0.equip_hash[arg_41_1].equips, arg_41_0.equip_hash[arg_41_1].point
			elseif not arg_41_2 then
				local var_41_0, var_41_1 = var_32_25(arg_41_1, arg_41_0.n)
				
				return var_41_0, var_41_1
			end
		end
		
		return nil, 0
	end
	
	local var_32_28 = {}
	local var_32_29 = {}
	local var_32_30 = arg_32_1.set_filter
	local var_32_31 = 6
	local var_32_32
	local var_32_33 = {}
	
	for iter_32_4, iter_32_5 in pairs(var_32_30) do
		local var_32_34 = arg_32_0:getSetNumber(iter_32_5)
		
		var_32_31 = var_32_31 - var_32_34
		
		if var_32_34 == 4 then
			var_32_32 = iter_32_5
		elseif var_32_34 == 2 then
			table.insert(var_32_33, iter_32_5)
		end
	end
	
	for iter_32_6, iter_32_7 in pairs(var_32_4) do
		local var_32_35 = DBT("item_set", iter_32_6, {
			"set_number",
			"type1",
			"effect1",
			"type2",
			"effect2"
		})
		local var_32_36 = {}
		
		if var_32_35.type1 and var_32_35.type1 ~= "skill" then
			var_32_36[var_32_35.type1] = var_32_35.effect1
		end
		
		if var_32_35.type2 and var_32_35.type2 ~= "skill" then
			var_32_36[var_32_35.type2] = var_32_35.effect2
		end
		
		if var_32_35.set_number == 4 and (var_32_31 >= 4 or var_32_32 == iter_32_6) then
			var_32_28[iter_32_6] = {}
			var_32_28[iter_32_6].n = 4
			var_32_28[iter_32_6].effects = var_32_36
			var_32_28[iter_32_6].equip_hash = var_32_22(iter_32_6, var_32_11(var_32_36, arg_32_1.mod_value))
		elseif var_32_35.set_number == 2 and (var_32_31 >= 2 or table.isInclude(var_32_33, iter_32_6)) then
			var_32_29[iter_32_6] = {}
			var_32_29[iter_32_6].n = 2
			var_32_29[iter_32_6].effects = var_32_36
			var_32_29[iter_32_6].equip_hash = var_32_23(iter_32_6, var_32_11(var_32_36, arg_32_1.mod_value))
		end
	end
	
	local var_32_37 = {}
	local var_32_38 = 0
	local var_32_39 = table.count(var_32_33)
	
	if var_32_39 < 2 then
		for iter_32_8 = 1, #var_0_0 - 1 do
			for iter_32_9 = iter_32_8 + 1, #var_0_0 do
				local var_32_40 = iter_32_8 .. "/" .. iter_32_9
				local var_32_41 = {}
				local var_32_42
				local var_32_43
				local var_32_44
				local var_32_45
				
				if var_32_32 then
					var_32_42, var_32_43 = var_32_27(var_32_28[var_32_32], var_32_40, true)
				else
					var_32_42, var_32_43 = var_32_25(var_32_40, 4)
				end
				
				if var_32_42 then
					var_32_24(var_32_41, var_32_42)
					
					if var_32_39 == 1 then
						var_32_44, var_32_45 = var_32_27(var_32_29[var_32_33[1]], var_32_40, true)
					else
						var_32_44, var_32_45 = var_32_25(var_32_40, 2)
					end
					
					if var_32_44 then
						var_32_24(var_32_41, var_32_44)
						
						local var_32_46 = var_32_43 + var_32_45
						
						if var_32_38 < var_32_46 then
							var_32_37 = var_32_41
							var_32_38 = var_32_46
						end
					end
				end
			end
		end
	end
	
	local var_32_47 = {
		{
			"1/2",
			"3/4",
			"5/6"
		},
		{
			"1/2",
			"3/5",
			"4/6"
		},
		{
			"1/2",
			"3/6",
			"4/5"
		},
		{
			"1/3",
			"2/4",
			"5/6"
		},
		{
			"1/3",
			"2/5",
			"4/6"
		},
		{
			"1/3",
			"2/6",
			"4/5"
		},
		{
			"1/4",
			"2/3",
			"5/6"
		},
		{
			"1/4",
			"2/5",
			"3/6"
		},
		{
			"1/4",
			"2/6",
			"3/5"
		},
		{
			"1/5",
			"3/4",
			"2/6"
		},
		{
			"1/5",
			"2/3",
			"4/6"
		},
		{
			"1/5",
			"3/6",
			"2/4"
		},
		{
			"1/6",
			"3/4",
			"2/5"
		},
		{
			"1/6",
			"2/3",
			"4/5"
		},
		{
			"1/6",
			"3/5",
			"2/4"
		}
	}
	
	local function var_32_48(arg_42_0, arg_42_1)
		local var_42_0 = 0
		local var_42_1 = {}
		
		for iter_42_0 = 1, 3 do
			local var_42_2 = arg_42_0[iter_42_0]
			local var_42_3
			local var_42_4
			
			if arg_42_1[iter_42_0] then
				var_42_3, var_42_4 = var_32_27(var_32_29[arg_42_1[iter_42_0]], var_42_2, true)
			else
				var_42_3, var_42_4 = var_32_25(var_42_2, 2)
			end
			
			if not var_42_3 then
				return {}, 0
			end
			
			var_42_0 = var_42_0 + var_42_4
			
			var_32_24(var_42_1, var_42_3)
		end
		
		return var_42_1, var_42_0
	end
	
	if not var_32_32 then
		local var_32_49 = {}
		
		if table.count(var_32_33) == 0 then
			table.insert(var_32_49, {})
		elseif table.count(var_32_33) == 1 then
			for iter_32_10 = 1, 3 do
				local var_32_50 = {
					[iter_32_10] = var_32_33[1]
				}
				
				table.insert(var_32_49, var_32_50)
			end
		elseif table.count(var_32_33) >= 2 then
			for iter_32_11 = 0, 2 do
				local var_32_51 = {
					[iter_32_11 + 1] = var_32_33[1]
				}
				
				for iter_32_12 = 1, 2 do
					local var_32_52 = (iter_32_11 + iter_32_12) % 3
					local var_32_53 = (var_32_52 + iter_32_12) % 3
					
					var_32_51[var_32_52 + 1] = var_32_33[2]
					var_32_51[var_32_53 + 1] = var_32_33[3]
					
					table.insert(var_32_49, var_32_51)
				end
			end
		end
		
		for iter_32_13, iter_32_14 in pairs(var_32_49) do
			for iter_32_15, iter_32_16 in pairs(var_32_47) do
				local var_32_54, var_32_55 = var_32_48(iter_32_16, iter_32_14)
				
				if var_32_38 < var_32_55 then
					var_32_37 = var_32_54
					var_32_38 = var_32_55
				end
			end
		end
	end
	
	local var_32_56 = var_32_26(var_32_37, {})
	local var_32_57 = {}
	
	for iter_32_17, iter_32_18 in pairs(var_32_37) do
		var_32_57[iter_32_18.set_fx] = (var_32_57[iter_32_18.set_fx] or 0) + 1
	end
	
	for iter_32_19, iter_32_20 in pairs(var_32_57) do
		if var_32_28[iter_32_19] and iter_32_20 >= 4 then
			for iter_32_21, iter_32_22 in pairs(var_32_28[iter_32_19].effects) do
				var_32_56[iter_32_21] = (var_32_56[iter_32_21] or 0) + iter_32_22
			end
		elseif var_32_29[iter_32_19] and iter_32_20 >= 2 then
			for iter_32_23, iter_32_24 in pairs(var_32_29[iter_32_19].effects) do
				var_32_56[iter_32_23] = (var_32_56[iter_32_23] or 0) + iter_32_24
			end
		end
	end
	
	local var_32_58 = var_32_11(var_32_56)
	
	return {
		equips = var_32_37,
		point = var_32_58,
		stats = var_32_56
	}
end

function EquipRecommender.getSetNumber(arg_43_0, arg_43_1)
	return DB("item_set", arg_43_1, "set_number") or 0
end
