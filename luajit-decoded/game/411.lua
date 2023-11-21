EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.Ring = {}
EquipCraftEvent.Ring.Data = {}
EquipCraftEvent.Ring.UI = {}

function MsgHandler.equip_craft_complete(arg_1_0)
	EquipCraftEvent.Ring:onResponse(arg_1_0)
end

function EquipCraftEvent.Ring.onResponse(arg_2_0, arg_2_1)
	Account:addReward(arg_2_1.rewards)
	EquipCraftEvent:onEquipCraftResult(arg_2_1)
	EquipCraftEvent:updateByResponse(arg_2_1)
end

function EquipCraftEvent.Ring.onBaseHandler(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = ({
		btn_sub_stat = "SubStat",
		btn_part = "Part",
		btn_set = "SetFx",
		btn_main_stat = "MainStat"
	})[arg_3_3]
	
	if not var_3_0 then
		return 
	end
	
	if not EquipCraftEvent:isAvailableMode(var_3_0) then
		balloon_message_with_sound("equip_craft_event_msg_next_step")
		
		return 
	end
	
	if arg_3_1 == var_3_0 then
		return 
	end
	
	EquipCraftEvent:jumpToMode(var_3_0)
end

function EquipCraftEvent.Ring.create(arg_4_0)
	arg_4_0.Data:create()
end

function EquipCraftEvent.Ring.remove(arg_5_0)
	arg_5_0.Data:remove()
end

function EquipCraftEvent.Ring.setMode(arg_6_0, arg_6_1)
	arg_6_0.Data:setMode(arg_6_1)
	arg_6_0.UI:setMode(arg_6_1)
end

function EquipCraftEvent.Ring.updateRing(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.UI:updateRing(arg_7_1, arg_7_2)
end

function EquipCraftEvent.Ring.procCommit(arg_8_0)
	EquipCraftEvent:query("equip_craft_complete")
end

function EquipCraftEvent.Ring.makeCraftConfirmDialog(arg_9_0)
	local var_9_0 = EquipCraftEventUtil:makeConfirmDialog("equip_craft_event_confirm_final", 0, "", function()
		arg_9_0:procCommit()
	end)
	local var_9_1 = EquipCraftEvent.Data:getEventPreviewEquip()
	local var_9_2 = EQUIP:createByInfo(var_9_1)
	local var_9_3 = ItemTooltip:updateEquipSubWindow(var_9_2)
	
	if_set_visible(var_9_3, "n_btn", false)
	if_set_visible(var_9_3, "n_set_data", false)
	var_9_3:setPosition(156, 240)
	var_9_0:findChildByName("n_item"):addChild(var_9_3)
end

function EquipCraftEvent.Ring.commitCraft(arg_11_0)
	if not arg_11_0.Data:isCraftStatusOk() then
		balloon_message_with_sound("equip_craft_event_msg_cant_craft")
		
		return 
	end
	
	arg_11_0:makeCraftConfirmDialog()
end

function EquipCraftEvent.Ring.updatePoint(arg_12_0, arg_12_1)
	local var_12_0 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	local var_12_1 = EquipCraftEvent.Data:isGenerated()
	
	arg_12_0.UI:updatePointInfo(arg_12_1:findChildByName(arg_12_0.Data:getRingParentNodeName(var_12_1)), var_12_0)
end

local var_0_0 = EquipCraftEvent.Ring
local var_0_1 = EquipCraftEvent.Ring.UI

function var_0_1.updateRing(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = EquipCraftEvent.Data:isGenerated()
	
	if var_0_0.Data:isCheckComplete() then
		if not var_13_0 then
			arg_13_0:updateRingForCraftBefore(arg_13_1:findChildByName(var_0_0.Data:getRingParentNodeName(var_13_0)), arg_13_2)
			arg_13_0:updatePointInfo(arg_13_1:findChildByName(var_0_0.Data:getRingParentNodeName(var_13_0)), arg_13_2)
		else
			arg_13_0:updateRingForCraftAfter(arg_13_1:findChildByName(var_0_0.Data:getRingParentNodeName(var_13_0)), arg_13_2)
			arg_13_0:updatePointInfo(arg_13_1:findChildByName(var_0_0.Data:getRingParentNodeName(var_13_0)), arg_13_2)
		end
	else
		arg_13_0:updateRingForCraftBefore(arg_13_1:findChildByName(var_0_0.Data:getRingParentNodeName()), arg_13_2)
		arg_13_0:updatePointInfo(arg_13_1:findChildByName(var_0_0.Data:getRingParentNodeName(var_13_0)), arg_13_2)
	end
	
	if var_0_0.Data:isRequireAnimation() then
		arg_13_0:updateRingAnimation(arg_13_1)
		arg_13_0:updateButtonAnimation(arg_13_1)
	end
	
	if var_0_0.Data:isRequireUpdateConfirmStatus() then
		arg_13_0:updateConfirmButtonStatus(arg_13_1)
	end
end

function var_0_1.updateRingForCraftBefore(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_1 then
		return 
	end
	
	local var_14_0 = arg_14_1:findChildByName("n_lv")
	
	UIUtil:setRewardLevelDetail(var_14_0, arg_14_2.lvl, {})
	arg_14_0:updateRingBeforeItemIcon(arg_14_1, arg_14_2)
	
	if var_0_0.Data:isRequireDrawArrow() then
		arg_14_0:updateProgress(arg_14_1, arg_14_2.progress)
	end
	
	local var_14_1 = arg_14_1:findChildByName("btn_craft")
	
	if get_cocos_refid(var_14_1) then
		local var_14_2 = cc.c3b(255, 255, 255)
		
		if arg_14_2.progress ~= 5 then
			var_14_2 = cc.c3b(76, 76, 76)
		end
		
		if_set_color(var_14_1, nil, var_14_2)
	end
	
	if var_0_0.Data:isRequireDrawInfosToButton() then
		arg_14_0:updateStatusByInfo(arg_14_1, arg_14_2)
		arg_14_0:updateMainStatStatus(arg_14_1, arg_14_2)
	end
	
	local var_14_3 = arg_14_1:findChildByName("btn_part")
	
	if var_14_3 then
		if arg_14_2.code and DB("equip_item", arg_14_2.code, "id") then
			arg_14_0:updatePartStatus(var_14_3, arg_14_2)
		else
			arg_14_0:updatePartDefaultViewFlag(var_14_3, true)
		end
	end
end

function var_0_1.updateConfirmButtonStatus(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1:findChildByName("btn_craft")
	local var_15_1 = cc.c3b(76, 76, 76)
	
	if var_0_0.Data:isCraftStatusOk() then
		var_15_1 = cc.c3b(255, 255, 255)
	end
	
	if_set_color(var_15_0, nil, var_15_1)
end

function var_0_1.createItemPartSprite(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = ({
		weapon = "cm_icon_parweapon",
		armor = "cm_icon_pararmor",
		ring = "cm_icon_parring",
		boot = "cm_icon_parboots",
		helm = "cm_icon_parhelm",
		neck = "cm_icon_parneck"
	})[arg_16_2]
	local var_16_1 = arg_16_1:findChildByName("_sprite_part_icon_create")
	
	if get_cocos_refid(var_16_1) then
		var_16_1:removeFromParent()
	end
	
	local var_16_2 = arg_16_1:findChildByName("n_part_selected")
	
	if not var_16_2 then
		return 
	end
	
	if var_16_0 then
		local var_16_3 = cc.Sprite:create("img/" .. var_16_0 .. ".png")
		
		if var_16_3 then
			var_16_3:setName("_sprite_part_icon_create")
			var_16_2:addChild(var_16_3)
			
			return var_16_3
		end
	end
end

function var_0_1.updatePartDefaultViewFlag(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_1:getChildByName("icon_part")
	
	if get_cocos_refid(var_17_0) then
		if_set_visible(arg_17_1, "icon_part", arg_17_2)
		if_set_visible(arg_17_1, "n_part_selected", not arg_17_2)
	end
end

function var_0_1.updatePartStatus(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 then
		return 
	end
	
	local var_18_0 = arg_18_2.code
	local var_18_1 = DB("equip_item", var_18_0, "type")
	
	if not var_18_1 then
		return 
	end
	
	local var_18_2 = arg_18_0:createItemPartSprite(arg_18_1, var_18_1)
	local var_18_3 = true
	
	if var_18_2 then
		var_18_3 = false
	end
	
	arg_18_0:updatePartDefaultViewFlag(arg_18_1, var_18_3)
end

function var_0_1.updateMainStatStatus(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_3 or arg_19_1:findChildByName("btn_main_stat")
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = arg_19_2.main_stat
	local var_19_2 = var_19_0:findChildByName("icon_main")
	local var_19_3 = var_19_0:findChildByName("n_main_selected")
	
	if_set_visible(var_19_3, nil, var_19_1 ~= nil)
	if_set_visible(var_19_2, nil, var_19_1 == nil)
	
	if get_cocos_refid(var_19_3) then
		var_19_3:removeAllChildren()
		
		if var_19_1 then
			local var_19_4 = string.gsub(var_19_1, "_rate", "")
			local var_19_5 = cc.Sprite:create("img/icon_menu_" .. var_19_4 .. ".png")
			
			var_19_3:addChild(var_19_5)
			
			local var_19_6 = string.find(var_19_1, "_rate") ~= nil
			
			if_set_visible(var_19_0, "t_percent", var_19_6)
		else
			if_set_visible(var_19_0, "t_percent", false)
		end
	end
end

function var_0_1.updateSetFxStatus(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1:findChildByName("btn_set")
	
	if not var_20_0 then
		return 
	end
	
	arg_20_0:updateRingBeforeItemSetFx(var_20_0, arg_20_2)
end

function var_0_1.updateStatusByInfo(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0:updateSetFxStatus(arg_21_1, arg_21_2)
end

function var_0_1.updateProgress(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_2 - 1
	local var_22_1 = {
		"icon_set",
		"icon_part",
		"icon_main",
		"icon_sub"
	}
	local var_22_2 = 76.5
	
	for iter_22_0 = 1, 4 do
		if_set_visible(arg_22_1, "arrow" .. iter_22_0, iter_22_0 <= var_22_0)
		
		local var_22_3 = 76.5
		
		if iter_22_0 <= arg_22_2 then
			var_22_3 = 255
		end
		
		if_set_opacity(arg_22_1, var_22_1[iter_22_0], var_22_3)
	end
end

function var_0_1.updateRingBeforeItemIcon(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_2.code
	local var_23_1 = DB("equip_item", var_23_0, "id")
	local var_23_2 = arg_23_2.set_fx
	local var_23_3 = arg_23_1:findChildByName(var_0_0.Data:getIconParentNodeName())
	local var_23_4 = arg_23_1:findChildByName(var_0_0.Data:getIconReplaceNodeName())
	local var_23_5 = var_23_3:findChildByName("equip_icon_sprite")
	
	if not var_23_4 then
		Log.e("NOT ICON REAPLCE NODE : CHECK!")
		
		return 
	end
	
	if get_cocos_refid(var_23_5) then
		var_23_5:removeFromParent()
	end
	
	local var_23_6 = var_23_3:findChildByName("n_lv")
	
	if var_23_6 then
		var_23_6:setLocalZOrder(1)
	end
	
	if var_23_1 then
		local var_23_7 = DB("equip_item", var_23_1, "icon")
		
		if var_23_7 then
			local var_23_8 = "item/" .. var_23_7 .. ".png"
			local var_23_9 = cc.Sprite:create(var_23_8)
			
			var_23_9:setName("equip_icon_sprite")
			var_23_3:addChild(var_23_9)
			var_23_9:setPosition(48, 48)
			var_23_9:setAnchorPoint(0.5, 0.5)
			var_23_9:setLocalZOrder(0)
		end
	end
	
	local var_23_10 = arg_23_0:createItemSetFxSprite(var_23_3, arg_23_2)
	
	if var_23_10 then
		var_23_10:setPosition(86, 6)
		var_23_10:setLocalZOrder(2)
	end
	
	if not EquipCraftEventUtil:isDataEmpty(var_23_2) then
		local var_23_11 = DB("item_set", var_23_2, "icon")
		
		if_set_sprite(var_23_3, "icon_set", "item/" .. var_23_11 .. ".png")
	end
	
	if var_0_0.Data:isRequireShowReplaceNode() then
		if_set_visible(var_23_4, nil, not var_23_1)
	else
		if_set_visible(var_23_4, nil, false)
	end
end

function var_0_1.createItemSetFxSprite(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_2.set_fx
	local var_24_1 = arg_24_1:findChildByName("_sprite_set_fx_icon_create")
	
	if get_cocos_refid(var_24_1) then
		var_24_1:removeFromParent()
	end
	
	if not EquipCraftEventUtil:isDataEmpty(var_24_0) then
		local var_24_2 = DB("item_set", var_24_0, "icon")
		local var_24_3 = cc.Sprite:create("item/" .. var_24_2 .. ".png")
		
		var_24_3:setName("_sprite_set_fx_icon_create")
		arg_24_1:addChild(var_24_3)
		
		return var_24_3
	end
end

function var_0_1.updateRingBeforeItemSetFx(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_2.set_fx
	local var_25_1 = arg_25_1:findChildByName("icon_set")
	local var_25_2 = arg_25_1:findChildByName("n_set_selected")
	
	if_set_visible(var_25_2, nil, not EquipCraftEventUtil:isDataEmpty(var_25_0))
	if_set_visible(var_25_1, nil, EquipCraftEventUtil:isDataEmpty(var_25_0))
	arg_25_0:createItemSetFxSprite(var_25_2, arg_25_2)
	arg_25_0:updateMainStatStatus(arg_25_1, arg_25_2, arg_25_1:findChildByName("main_stat"))
end

function var_0_1.createPointInfo(arg_26_0)
	local var_26_0 = load_dlg("equip_craft_event_point_tooltip", true, EquipCraftEvent:getUIFolder())
	local var_26_1 = EquipCraftEvent.Data:getEventId()
	local var_26_2, var_26_3 = DB("event_equip_craft", var_26_1, {
		"info_desc1",
		"info_desc2"
	})
	
	if var_26_2 ~= "" then
		var_26_2 = T(var_26_2)
	else
		var_26_2 = ""
	end
	
	if var_26_3 ~= "" then
		var_26_3 = T(var_26_3)
	else
		var_26_3 = ""
	end
	
	if_set(var_26_0, "txt_point_info1", var_26_2)
	if_set(var_26_0, "txt_point_info2", var_26_3)
	
	return var_26_0
end

function var_0_1.updatePointInfo(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_1 then
		return 
	end
	
	if_set(arg_27_1, "t_point_count", comma_value(arg_27_2.craft_point))
	
	local var_27_0 = arg_27_1:findChildByName("btn_point_info")
	
	if var_27_0 then
		WidgetUtils:setupTooltip({
			delay = 30,
			control = var_27_0,
			creator = function()
				return arg_27_0:createPointInfo()
			end
		})
	end
end

function var_0_1.updateRingForCraftAfter(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0:updateStatusByInfo(arg_29_1, arg_29_2)
	arg_29_0:updateRingBeforeItemSetFx(arg_29_1, arg_29_2)
	arg_29_0:updatePartStatus(arg_29_1:findChildByName("part"), arg_29_2)
	
	local var_29_0 = arg_29_1:findChildByName("n_reward_item")
	local var_29_1 = arg_29_2.code
	local var_29_2 = arg_29_2.set_fx
	
	UIUtil:getRewardIcon("equip", var_29_1, {
		grade = 5,
		no_tooltip = true,
		parent = var_29_0,
		set_fx = var_29_2
	})
end

function var_0_1.updateRingAnimation(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_1:findChildByName("n_cir")
	
	if not var_30_0 then
		Log.e("REQ ANI BUT NOT HAVE N_CIR")
	end
	
	local var_30_1 = var_30_0:findChildByName("cir")
	local var_30_2 = var_30_0:findChildByName("sq1")
	local var_30_3 = var_30_0:findChildByName("sq2")
	
	UIAction:Add(LOOP(ROTATE(12000, 0, -360)), var_30_1, "ring.animation_spin")
	UIAction:Add(LOOP(ROTATE(10000, 0, 360)), var_30_3, "ring.animation_spin")
	UIAction:Add(LOOP(ROTATE(20000, 0, -360)), var_30_2, "ring.animation_spin")
end

function var_0_1.updateButtonAnimation(arg_31_0, arg_31_1)
	local var_31_0 = {
		Part = "btn_part",
		MainStat = "btn_main_stat",
		SetFx = "btn_set",
		SubStat = "btn_sub_stat"
	}
	local var_31_1 = var_0_0.Data:getMode()
	local var_31_2 = 1
	local var_31_3 = arg_31_1:findChildByName(var_31_0[var_31_1])
	
	UIAction:Add(LOOP(SEQ(SCALE_TO(500, 0.86), SCALE_TO(500, var_31_2))), var_31_3, "ring.button_animation")
end

function var_0_1.setMode(arg_32_0)
	UIAction:Remove("ring.button_animation")
end

local var_0_2 = EquipCraftEvent.Ring.Data

function var_0_2.create(arg_33_0)
	arg_33_0.vars = {}
end

function var_0_2.remove(arg_34_0)
	arg_34_0.vars = nil
end

function var_0_2.setMode(arg_35_0, arg_35_1)
	arg_35_0.vars.mode = arg_35_1
end

function var_0_2.isCheckComplete(arg_36_0)
	if arg_36_0.vars.mode == "Main" then
		return true
	else
		return false
	end
end

function var_0_2.isRequireShowReplaceNode(arg_37_0)
	return arg_37_0.vars.mode == "Main"
end

function var_0_2.isRequireAnimation(arg_38_0)
	return arg_38_0.vars.mode ~= "Main"
end

function var_0_2.isRequireUpdateConfirmStatus(arg_39_0)
	return arg_39_0.vars.mode ~= "Main"
end

function var_0_2.isRequireEffect(arg_40_0)
	return arg_40_0.vars.mode == "Main"
end

function var_0_2.isRequireDrawArrow(arg_41_0)
	return arg_41_0.vars.mode ~= "Main"
end

function var_0_2.isRequireDrawInfosToButton(arg_42_0)
	return arg_42_0.vars.mode ~= "Main"
end

function var_0_2.getIconParentNodeName(arg_43_0)
	if arg_43_0.vars.mode == "Main" then
		return "item"
	else
		return "item"
	end
end

function var_0_2.getRingParentNodeName(arg_44_0, arg_44_1)
	if arg_44_0.vars.mode == "Main" then
		if arg_44_1 then
			return "n_craft_complete"
		else
			return "n_craft_before"
		end
	else
		return "RIGHT"
	end
end

function var_0_2.getIconReplaceNodeName(arg_45_0)
	if arg_45_0.vars.mode == "Main" then
		return "icon_craft"
	else
		return "icon_item"
	end
end

function var_0_2.isCraftStatusOk(arg_46_0)
	local var_46_0 = EquipCraftEvent.Data:getEquipCraftProgress()
	local var_46_1 = EquipCraftEvent.Data:getEventOptionalEquip()
	
	return var_46_0 == 4 and var_46_1 == nil
end

function var_0_2.getMode(arg_47_0)
	return arg_47_0.vars.mode
end
