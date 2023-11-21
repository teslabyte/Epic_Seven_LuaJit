EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.Part = {}
EquipCraftEvent.Part.UI = {}
EquipCraftEvent.Part.Data = {}

function MsgHandler.equip_craft_step2(arg_1_0)
	EquipCraftEvent.Part:onResponse(arg_1_0)
end

local var_0_0 = EquipCraftEvent.Part

function EquipCraftEvent.Part.onHandler(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 == "btn_decide" then
		arg_2_0:onDecide()
	elseif string.starts(arg_2_2, "btn_part") then
		arg_2_0:onSetPart(arg_2_2)
	end
end

function EquipCraftEvent.Part.onResponse(arg_3_0, arg_3_1)
	EquipCraftEvent:updateByResponse(arg_3_1)
	EquipCraftEvent:nextProgress()
end

function EquipCraftEvent.Part.getButtonStatus(arg_4_0)
	return arg_4_0.Data:isExistSelect() and arg_4_0.Data:isChanged()
end

function EquipCraftEvent.Part.procChange(arg_5_0)
	EquipCraftEvent:query("equip_craft_step2", {
		equip_type = arg_5_0.Data:getSelectPart()
	})
end

function EquipCraftEvent.Part.makeConfirmDialog(arg_6_0)
	if get_cocos_refid(arg_6_0.vars.confirm_dlg) then
		return 
	end
	
	local var_6_0 = EquipCraftEventUtil:makeConfirmDialog("equip_craft_event_confirm_part", arg_6_0.Data:getRequirePoint(), "equip_craft_event_msg_set_confirm", function()
		arg_6_0:procChange()
	end)
	local var_6_1 = arg_6_0.Data:getSelectPart()
	local var_6_2 = EQUIP.getEquipPositionName(nil, var_6_1)
	local var_6_3 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	local var_6_4 = "n_change_select_icon"
	local var_6_5 = arg_6_0.Data:getSelectEquipId()
	local var_6_6 = arg_6_0.Data:getSelectedEquipId()
	local var_6_7 = var_6_5 and not var_6_6
	local var_6_8 = "equip_craft_event_part_change_txt"
	
	if var_6_7 then
		var_6_4 = "n_contents"
		var_6_8 = "equip_craft_event_part_select_txt"
	end
	
	if_set(var_6_0, "t_selected_info", T(var_6_8, {
		set_name = var_6_2
	}))
	
	local var_6_9 = "equip_craft_event_confirm_part_desc1"
	
	if not var_6_7 then
		var_6_9 = "equip_craft_event_confirm_part_desc2"
	end
	
	if_set(var_6_0, "t_disc_select", T(var_6_9))
	arg_6_0.UI:updatePart(var_6_3, var_6_5, arg_6_0.Data:getSelectedEquipId(), {
		n_change_select_name = "n_change_select_icon",
		n_btn_parent_name = var_6_4,
		target_layer = var_6_0
	})
	
	arg_6_0.vars.confirm_dlg = var_6_0
end

function EquipCraftEvent.Part.onDecide(arg_8_0)
	local var_8_0 = {
		not_exist_select = "equip_craft_event_msg_part_select",
		not_point_enough = "equip_craft_event_msg_part_point",
		not_changed = "equip_craft_event_msg_part_select"
	}
	
	if not EquipCraftEventUtil:checkDecide(arg_8_0.Data:isExistSelect(), arg_8_0.Data:isChanged(), arg_8_0.Data:isPointEnough(), var_8_0) then
		return 
	end
	
	arg_8_0:makeConfirmDialog()
end

function EquipCraftEvent.Part.onSetPart(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.Data:getSelectPart()
	local var_9_1 = arg_9_0.Data:getNameToPart(arg_9_1)
	local var_9_2 = arg_9_0.Data:getSelectedPart()
	
	if var_9_1 == var_9_2 and var_9_2 ~= nil then
		return 
	end
	
	arg_9_0.Data:onHandler(arg_9_1)
	arg_9_0.UI:selectPart(var_9_0, arg_9_0.Data:getSelectPart())
	
	local var_9_3 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	local var_9_4 = arg_9_0.Data:getSelectEquipId()
	local var_9_5 = arg_9_0.Data:getSelectedEquipId()
	
	arg_9_0.UI:updatePart(var_9_3, var_9_4, var_9_5)
	EquipCraftEvent.Base:updateButtonStatus(arg_9_0:getButtonStatus(), arg_9_0.Data:getRequirePoint())
end

function EquipCraftEvent.Part.onEnter(arg_10_0, arg_10_1)
	arg_10_0.vars = {}
	
	local var_10_0 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	
	arg_10_0.Data:onEnter(var_10_0)
	
	local var_10_1 = EquipCraftEvent.Data:getEquipDatas(var_10_0.set_fx)
	
	arg_10_0.UI:onEnter(arg_10_1, var_10_0, var_10_1)
end

function EquipCraftEvent.Part.onLeave(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	arg_11_0.Data:onLeave()
	arg_11_0.UI:onLeave()
end

local var_0_1 = var_0_0.UI

function var_0_1.onEnter(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0.vars = {}
	arg_12_0.vars.target_layer = arg_12_1
	
	if_set_visible(arg_12_0.vars.target_layer, nil, true)
	arg_12_0:uiSetting(arg_12_2, arg_12_3)
end

function var_0_1.onLeave(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.target_layer) then
		return 
	end
	
	EquipCraftEventUtil:removeAllSprites(arg_13_0.vars.target_layer, "n_change_select")
	
	for iter_13_0 = 1, 6 do
		local var_13_0 = arg_13_0.vars.target_layer:findChildByName("part_icon" .. iter_13_0)
		
		if get_cocos_refid(var_13_0) then
			var_13_0:removeFromParent()
		end
	end
	
	if_set_visible(arg_13_0.vars.target_layer, nil, false)
	
	arg_13_0.vars = nil
end

function var_0_1.uiSetting(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.vars.target_layer
	
	arg_14_0:iconSetting(arg_14_1, arg_14_2)
	
	local var_14_1 = arg_14_1.code
	
	if var_14_1 then
		arg_14_0:updatePart(arg_14_1, nil, var_14_1)
	end
end

function var_0_1.iconSetting(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.vars.target_layer
	local var_15_1 = EquipCraftEvent.Data:getEquipParts()
	local var_15_2 = var_0_0.Data:getPartToUIName()
	local var_15_3 = var_0_0.Data:getSelectedEquipId()
	
	for iter_15_0, iter_15_1 in pairs(var_15_1) do
		local var_15_4 = var_15_2[iter_15_1]
		local var_15_5 = var_15_0:findChildByName(var_15_4)
		
		if_set_visible(var_15_5, "img_select", false)
		
		local var_15_6 = var_15_5:findChildByName("item")
		local var_15_7 = arg_15_2[iter_15_1]
		local var_15_8 = UIUtil:getRewardIcon("equip", var_15_7.equip_id, {
			no_tooltip = true,
			parent = var_15_5,
			set_fx = arg_15_1.set_fx,
			grade = arg_15_1.equip_grade
		})
		
		if_set_visible(var_15_5, "img_selected", var_15_7.equip_id == var_15_3)
		var_15_8:setName("part_icon" .. iter_15_0)
		var_15_8:setPosition(var_15_6:getPosition())
		if_set_visible(var_15_6, nil, false)
	end
end

function var_0_1.createIcon(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	EquipCraftEventUtil:removeSprite(arg_16_1, arg_16_4)
	
	local var_16_0 = UIUtil:getRewardIcon("equip", arg_16_3, {
		no_tooltip = true,
		parent = arg_16_1,
		set_fx = arg_16_2.set_fx,
		grade = arg_16_2.equip_grade
	})
	local var_16_1 = arg_16_1:findChildByName("item")
	
	if not var_16_1 then
		return 
	end
	
	var_16_1:setVisible(false)
	var_16_0:setName("icon_sprite_" .. arg_16_4)
	var_16_0:setPosition(var_16_1:getPosition())
end

function var_0_1.updatePart(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_4 = arg_17_4 or {}
	
	local var_17_0 = arg_17_4.target_layer or arg_17_0.vars.target_layer
	local var_17_1 = arg_17_4.n_change_select_name or "n_change_select"
	local var_17_2 = arg_17_4.n_btn_parent_name or "n_after_select"
	
	arg_17_2 = DB("equip_item", arg_17_2, "id")
	arg_17_3 = DB("equip_item", arg_17_3, "id")
	
	EquipCraftEventUtil:setVisibleSelects(var_17_0, arg_17_2, arg_17_3)
	EquipCraftEventUtil:updateResultDisplay(var_17_0, arg_17_1, arg_17_2, arg_17_3, var_17_1, var_17_2, function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		arg_17_0:createIcon(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	end)
	
	local var_17_3 = var_17_0:findChildByName(var_17_2)
	
	if var_17_3 then
		EquipCraftEventUtil:updateResultDisplayText(var_17_3:findChildByName("t_selected_info"), arg_17_2, arg_17_3, "equip_craft_event_part_select_txt", "equip_craft_event_part_change_txt", "set_name", function(arg_19_0)
			local var_19_0 = DB("equip_item", arg_19_0, {
				"type"
			})
			
			if not var_19_0 then
				return 
			end
			
			return EQUIP.getEquipPositionName(nil, var_19_0)
		end)
	end
end

function var_0_1.selectPart(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = var_0_0.Data:getPartToUIName()
	local var_20_1 = arg_20_0.vars.target_layer:findChildByName("n_btn_part")
	
	if not var_20_1 then
		print("ERROR NO BTN PART")
		
		return 
	end
	
	if arg_20_1 then
		local var_20_2 = var_20_0[arg_20_1]
		local var_20_3 = var_20_1:findChildByName(var_20_2)
		
		if_set_visible(var_20_3, "img_select", false)
	end
	
	if arg_20_2 == nil then
		return 
	end
	
	local var_20_4 = var_20_0[arg_20_2]
	local var_20_5 = var_20_1:findChildByName(var_20_4)
	
	if_set_visible(var_20_5, "img_select", true)
end

local var_0_2 = var_0_0.Data

function var_0_2.onEnter(arg_21_0, arg_21_1)
	arg_21_0.vars = {}
	arg_21_0.vars.part_to_ui_naming = {
		weapon = "btn_part_weapon",
		armor = "btn_part_armor",
		boot = "btn_part_boots",
		ring = "btn_part_ring",
		helm = "btn_part_helmet",
		neck = "btn_part_necklace"
	}
	arg_21_0.vars.ui_naming_to_part = {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.part_to_ui_naming) do
		arg_21_0.vars.ui_naming_to_part[iter_21_1] = iter_21_0
	end
	
	arg_21_0.vars.select_part = nil
	
	local var_21_0 = arg_21_1.code
	
	if var_21_0 then
		arg_21_0.vars.selected_part = DB("equip_item", var_21_0, "type")
	end
end

function var_0_2.onLeave(arg_22_0)
	arg_22_0.vars = nil
end

function var_0_2.isExistSelect(arg_23_0)
	return arg_23_0.vars.select_part ~= nil
end

function var_0_2.isChanged(arg_24_0)
	return arg_24_0.vars.select_part ~= arg_24_0.vars.selected_part
end

function var_0_2.useCraftPoint(arg_25_0)
	EquipCraftEvent.Data:useCraftPoint(arg_25_0:getRequirePoint())
end

function var_0_2.isPointEnough(arg_26_0)
	return EquipCraftEvent.Data:isCanUseCraftPoint(arg_26_0:getRequirePoint())
end

function var_0_2.getPartToUIName(arg_27_0)
	return arg_27_0.vars.part_to_ui_naming
end

function var_0_2.getUiNameToPart(arg_28_0)
	return arg_28_0.vars.ui_naming_to_part
end

function var_0_2.getSelectedPart(arg_29_0)
	return arg_29_0.vars.selected_part
end

function var_0_2.getNameToPart(arg_30_0, arg_30_1)
	return arg_30_0.vars.ui_naming_to_part[arg_30_1]
end

function var_0_2.getSelectPart(arg_31_0)
	return arg_31_0.vars.select_part
end

function var_0_2.partToEquipId(arg_32_0, arg_32_1)
	return EquipCraftEventUtil:partToEquipId(arg_32_1)
end

function var_0_2.getRequirePoint(arg_33_0)
	local var_33_0 = EquipCraftEvent.Data:getEventId()
	
	return DB("event_equip_craft", var_33_0, "part_point")
end

function var_0_2.getSelectEquipId(arg_34_0)
	return arg_34_0:partToEquipId(arg_34_0.vars.select_part)
end

function var_0_2.getSelectedEquipId(arg_35_0)
	return arg_35_0:partToEquipId(arg_35_0.vars.selected_part)
end

function var_0_2.onHandler(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.vars.ui_naming_to_part[arg_36_1]
	
	if not var_36_0 then
		Log.e("NO PART : ", arg_36_1)
		
		return 
	end
	
	if arg_36_0.vars.select_part == var_36_0 then
		arg_36_0.vars.select_part = nil
	else
		arg_36_0.vars.select_part = var_36_0
	end
end
