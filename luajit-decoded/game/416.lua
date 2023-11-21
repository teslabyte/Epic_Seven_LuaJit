EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.MainStat = {}
EquipCraftEvent.MainStat = {}
EquipCraftEvent.MainStat.UI = {}
EquipCraftEvent.MainStat.Data = {}

function MsgHandler.equip_craft_step3(arg_1_0)
	EquipCraftEvent.MainStat:onResponse(arg_1_0)
end

local var_0_0 = EquipCraftEvent.MainStat

function EquipCraftEvent.MainStat.onResponse(arg_2_0, arg_2_1)
	EquipCraftEvent:updateByResponse(arg_2_1)
	EquipCraftEvent:nextProgress()
end

function EquipCraftEvent.MainStat.getButtonStatus(arg_3_0)
	return arg_3_0.Data:isExistSelect() and arg_3_0.Data:isChanged()
end

function EquipCraftEvent.MainStat.onEnter(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	
	local var_4_0 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	
	arg_4_0.Data:onEnter(var_4_0)
	
	local var_4_1 = EquipCraftEvent.Data:getEquipDatas(var_4_0.set_fx)
	
	arg_4_0.UI:onEnter(arg_4_1, var_4_0, var_4_1)
end

function EquipCraftEvent.MainStat.onLeave(arg_5_0)
	arg_5_0.Data:onLeave()
	arg_5_0.UI:onLeave()
end

function EquipCraftEvent.MainStat.onHandler(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_2 == "btn_decide" then
		arg_6_0:onDecide()
	end
	
	if string.starts(arg_6_2, "btn_main_stat") then
		if not arg_6_0.Data:isSelectableAnotherMainStat() then
			balloon_message_with_sound("equip_craft_event_msg_stat_select1")
			
			return 
		end
		
		local var_6_0, var_6_1 = string.find(arg_6_2, "%d+")
		local var_6_2 = string.sub(arg_6_2, var_6_0, var_6_1)
		local var_6_3 = tonumber(var_6_2)
		local var_6_4 = arg_6_0.Data:numberToStat(var_6_3)
		
		if not arg_6_0.Data:isSelectableMainStat(var_6_4) then
			balloon_message_with_sound("equip_craft_event_msg_stat_select1")
			
			return 
		end
		
		local var_6_5 = arg_6_0.Data:getSelectedMainStat()
		
		if var_6_4 == var_6_5 and var_6_5 ~= nil then
			return 
		end
		
		arg_6_0.Data:selectMainStat(var_6_3)
		arg_6_0.UI:selectMainStat(arg_6_0.Data:getSelectButtonName())
		arg_6_0.UI:updateSelectDisplay(arg_6_0.Data:getSelectMainStat(), var_6_5)
		EquipCraftEvent.Base:updateButtonStatus(arg_6_0:getButtonStatus(), arg_6_0.Data:getRequirePoint())
	end
end

function EquipCraftEvent.MainStat.onDecide(arg_7_0)
	local var_7_0 = {
		not_exist_select = "equip_craft_event_msg_stat_select",
		not_point_enough = "equip_craft_event_msg_stat_point",
		not_changed = "equip_craft_event_msg_stat_select"
	}
	
	if not EquipCraftEventUtil:checkDecide(arg_7_0.Data:isExistSelect(), arg_7_0.Data:isChanged(), arg_7_0.Data:isPointEnough(), var_7_0) then
		return 
	end
	
	arg_7_0:makeConfirmDialog()
end

function EquipCraftEvent.MainStat.makeConfirmDialog(arg_8_0)
	if get_cocos_refid(arg_8_0.vars.confirm_dlg) then
		return 
	end
	
	local var_8_0 = EquipCraftEventUtil:makeConfirmDialog("equip_craft_event_confirm_main_stat", arg_8_0.Data:getRequirePoint(), "equip_craft_event_msg_main_stat_confirm", function()
		arg_8_0:procChange()
	end)
	local var_8_1 = arg_8_0.Data:getSelectMainStat()
	local var_8_2 = ""
	
	if var_8_1 then
		var_8_2 = T("ui_equip_base_stat_filter_" .. var_8_1)
		var_8_2 = string.gsub(var_8_2, "%%", "%%%%")
	end
	
	if_set(var_8_0, "t_selected_info", T("equip_craft_event_msg_main_stat_confirm", {
		main_stat_name = var_8_2
	}))
	
	local var_8_3 = arg_8_0.Data:getSelectedMainStat()
	
	arg_8_0.UI:updateSelectDisplay(var_8_1, var_8_3, {
		n_btn_parent_name = "n_contents",
		target_layer = var_8_0
	})
	
	local var_8_4 = var_8_1 and not var_8_3
	local var_8_5 = "equip_craft_event_confirm_stat_desc1"
	
	if not var_8_4 then
		var_8_5 = "equip_craft_event_confirm_stat_desc2"
	end
	
	if_set(var_8_0, "t_disc_select", T(var_8_5))
	
	arg_8_0.vars.confirm_dlg = var_8_0
end

function EquipCraftEvent.MainStat.procChange(arg_10_0)
	EquipCraftEvent:query("equip_craft_step3", {
		main_stat = arg_10_0.Data:getSelectMainStat()
	})
end

local var_0_1 = var_0_0.UI

function var_0_1.onEnter(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0.vars = {}
	arg_11_0.vars.target_layer = arg_11_1
	
	if_set_visible(arg_11_0.vars.target_layer, nil, true)
	arg_11_0:uiSetting(arg_11_2, arg_11_3)
end

function var_0_1.onLeave(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	EquipCraftEventUtil:removeAllSprites(arg_12_0.vars.target_layer, "n_change_select")
	EquipCraftEventUtil:removeAllSprites(arg_12_0.vars.target_layer, "n_not_select")
	if_set_visible(arg_12_0.vars.target_layer, nil, false)
	
	arg_12_0.vars = nil
end

function var_0_1.uiSetting(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = var_0_0.Data:getSelectMainStat()
	local var_13_1 = var_0_0.Data:getSelectedMainStat()
	
	for iter_13_0 = 1, 11 do
		local var_13_2 = var_0_0.Data:numberToStat(iter_13_0)
		local var_13_3 = var_0_0.Data:isSelectableMainStat(var_13_2)
		local var_13_4 = 255
		
		if not var_13_3 then
			var_13_4 = var_13_4 * 0.3
		end
		
		local var_13_5 = arg_13_0.vars.target_layer:findChildByName("btn_main_stat" .. iter_13_0)
		
		if_set_opacity(var_13_5, nil, var_13_4)
		if_set_visible(var_13_5, "img_select", var_13_0 == var_13_2)
		if_set_visible(var_13_5, "img_selected", var_13_1 == var_13_2)
	end
	
	arg_13_0:updateSelectDisplay(var_13_0, var_0_0.Data:getSelectedMainStat())
end

function var_0_1.createIcon(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	EquipCraftEventUtil:removeSprite(arg_14_1, arg_14_3)
	
	local var_14_0 = string.gsub(arg_14_2, "_rate", "")
	local var_14_1 = cc.Sprite:create("img/icon_menu_" .. var_14_0 .. ".png")
	
	var_14_1:setName("icon_sprite_" .. arg_14_3)
	arg_14_1:addChild(var_14_1)
	
	local var_14_2 = string.find(arg_14_2, "_rate") ~= nil
	local var_14_3 = "t_percent"
	
	if arg_14_5 == 2 then
		local var_14_4 = 1
		
		if arg_14_3 == 1 then
			var_14_4 = 2
		end
		
		var_14_3 = var_14_3 .. "_" .. var_14_4
	end
	
	if_set_visible(arg_14_4, var_14_3, var_14_2)
end

function var_0_1.updateSelectDisplay(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_3 = arg_15_3 or {}
	
	local var_15_0 = arg_15_3.target_layer or arg_15_0.vars.target_layer
	local var_15_1 = arg_15_1 ~= nil
	local var_15_2 = var_0_0.Data:isSelectableAnotherMainStat()
	
	if_set_visible(var_15_0, "n_after_select", var_15_1 and var_15_2)
	if_set_visible(var_15_0, "n_before_select", not var_15_1 and var_15_2)
	if_set_visible(var_15_0, "n_not_select", not var_15_2)
	
	local var_15_3 = "n_after_select"
	
	if not var_15_2 then
		var_15_3 = "n_not_select"
	end
	
	if arg_15_3.n_btn_parent_name then
		var_15_3 = arg_15_3.n_btn_parent_name
	end
	
	local var_15_4 = var_15_0:findChildByName(var_15_3)
	local var_15_5 = 1
	
	if arg_15_2 ~= nil and arg_15_1 ~= nil then
		var_15_5 = 2
	end
	
	if_set_visible(var_15_4, "t_percent", var_15_5 ~= 2)
	EquipCraftEventUtil:updateResultDisplay(var_15_0, nil, arg_15_1, arg_15_2, nil, var_15_3, function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		arg_15_0:createIcon(arg_16_0, arg_16_2, arg_16_3, var_15_4, var_15_5)
	end)
	EquipCraftEventUtil:updateResultDisplayText(var_15_4:findChildByName("t_selected_info"), arg_15_1, arg_15_2, "equip_craft_event_stat_select_txt", "equip_craft_event_stat_change_txt", "main_stat_name", function(arg_17_0)
		local var_17_0 = T("ui_equip_base_stat_filter_" .. arg_17_0)
		
		return (string.gsub(var_17_0, "%%", "%%%%"))
	end)
end

function var_0_1.selectMainStat(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.prv_select_btn_name
	
	if var_18_0 then
		local var_18_1 = arg_18_0.vars.target_layer:findChildByName(var_18_0)
		
		if_set_visible(var_18_1, "img_select", false)
	end
	
	if arg_18_1 == nil then
		arg_18_0.vars.prv_select_btn_name = nil
		
		return 
	end
	
	if arg_18_1 then
		local var_18_2 = arg_18_0.vars.target_layer:findChildByName(arg_18_1)
		
		if_set_visible(var_18_2, "img_select", true)
	end
	
	arg_18_0.vars.prv_select_btn_name = arg_18_1
end

local var_0_2 = var_0_0.Data

function var_0_2.onEnter(arg_19_0, arg_19_1)
	arg_19_0.vars = {}
	arg_19_0.vars.btn_num_to_stat = {
		"att",
		"att_rate",
		"def",
		"def_rate",
		"acc",
		"max_hp",
		"max_hp_rate",
		"cri",
		"cri_dmg",
		"speed",
		"res"
	}
	arg_19_0.vars.selected_main_stat = arg_19_1.main_stat
	arg_19_0.vars.select_main_stat = nil
	arg_19_0.vars.part = arg_19_1.part
	arg_19_0.vars.stat_to_btn_num = {}
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.btn_num_to_stat) do
		arg_19_0.vars.stat_to_btn_num[iter_19_1] = iter_19_0
	end
	
	arg_19_0.vars.equip_id = arg_19_1.code
	arg_19_0.vars.main_stat_id = DB("equip_item", arg_19_0.vars.equip_id, "main_stat")
	
	if not arg_19_0.vars.main_stat_id then
		Log.e("NOT MAIN STAT ID!")
		
		return 
	end
	
	arg_19_0.vars.selectable_main_stats = {}
	
	local var_19_0 = arg_19_0.vars.main_stat_id
	
	for iter_19_2 = 1, 20 do
		local var_19_1 = var_19_0 .. "_" .. iter_19_2
		local var_19_2 = DB("equip_stat", var_19_1, "stat_type")
		
		if not var_19_2 then
			break
		end
		
		table.insert(arg_19_0.vars.selectable_main_stats, var_19_2)
	end
	
	if not arg_19_0:isSelectableAnotherMainStat() then
		arg_19_0.vars.select_main_stat = arg_19_0.vars.selectable_main_stats[1]
	end
end

function var_0_2.onLeave(arg_20_0)
	arg_20_0.vars = nil
end

function var_0_2.numberToStat(arg_21_0, arg_21_1)
	return arg_21_0.vars.btn_num_to_stat[arg_21_1]
end

function var_0_2.getSelectableMainStats(arg_22_0)
	return arg_22_0.vars.selectable_main_stats
end

function var_0_2.isSelectableAnotherMainStat(arg_23_0)
	return table.count(arg_23_0.vars.selectable_main_stats) > 1
end

function var_0_2.isSelectableMainStat(arg_24_0, arg_24_1)
	return table.find(arg_24_0.vars.selectable_main_stats, arg_24_1) ~= nil
end

function var_0_2.isExistSelect(arg_25_0)
	return arg_25_0.vars.select_main_stat ~= nil
end

function var_0_2.isChanged(arg_26_0)
	return arg_26_0.vars.select_main_stat ~= arg_26_0.vars.selected_main_stat
end

function var_0_2.isPointEnough(arg_27_0)
	return EquipCraftEvent.Data:isCanUseCraftPoint(arg_27_0:getRequirePoint())
end

function var_0_2.useCraftPoint(arg_28_0)
	EquipCraftEvent.Data:useCraftPoint(arg_28_0:getRequirePoint())
end

function var_0_2.getRequirePoint(arg_29_0)
	local var_29_0 = EquipCraftEvent.Data:getEventId()
	
	return DB("event_equip_craft", var_29_0, "main_stat_point")
end

function var_0_2.getSelectedButtonName(arg_30_0)
	local var_30_0 = arg_30_0:getSelectedMainStat()
	local var_30_1 = arg_30_0.vars.stat_to_btn_num[var_30_0]
	
	if not var_30_1 then
		return 
	end
	
	return "btn_main_stat" .. var_30_1
end

function var_0_2.getSelectButtonName(arg_31_0)
	local var_31_0 = arg_31_0:getSelectMainStat()
	local var_31_1 = arg_31_0.vars.stat_to_btn_num[var_31_0]
	
	if not var_31_1 then
		return 
	end
	
	return "btn_main_stat" .. var_31_1
end

function var_0_2.getSelectedMainStat(arg_32_0)
	return arg_32_0.vars.selected_main_stat
end

function var_0_2.getSelectMainStat(arg_33_0)
	return arg_33_0.vars.select_main_stat
end

function var_0_2.selectMainStat(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.vars.btn_num_to_stat[arg_34_1]
	
	if arg_34_0.vars.select_main_stat ~= var_34_0 then
		arg_34_0.vars.select_main_stat = var_34_0
	else
		arg_34_0.vars.select_main_stat = nil
	end
end
