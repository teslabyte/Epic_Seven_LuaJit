EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.Base = {}
EquipCraftEvent.Base.Data = {}
EquipCraftEvent.Base.UI = {}

function HANDLER.equip_craft_event_base(arg_1_0, arg_1_1)
	EquipCraftEvent.Base:onEvent(arg_1_0, arg_1_1)
end

function EquipCraftEvent.Base.isRingButton(arg_2_0, arg_2_1)
	return ({
		btn_sub_stat = true,
		btn_part = true,
		btn_set = true,
		btn_main_stat = true
	})[arg_2_1]
end

function EquipCraftEvent.Base.onEvent(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0:isRingButton(arg_3_2) then
		EquipCraftEvent.Ring:onBaseHandler(arg_3_0.vars.mode, arg_3_1, arg_3_2)
		
		return 
	end
	
	if arg_3_2 == "btn_craft" then
		EquipCraftEvent.Ring:commitCraft()
	else
		EquipCraftEvent.MODE_INTERFACES.onHandler(arg_3_0.vars.mode, arg_3_1, arg_3_2)
	end
end

function EquipCraftEvent.Base.create(arg_4_0, arg_4_1)
	if arg_4_0:isExist() then
		Log.e("BASE ALREADY EXISTS")
		
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.titles = {
		Part = "equip_craft_event_part_title",
		MainStat = "equip_craft_event_main_stat_title",
		SetFx = "equip_craft_event_set_title",
		SubStat = "equip_craft_event_sub_stat_title"
	}
	arg_4_0.vars.desc = {
		Part = "equip_craft_event_part_desc",
		MainStat = "equip_craft_event_main_stat_desc",
		SetFx = "equip_craft_event_set_desc",
		SubStat = "equip_craft_event_sub_stat_desc"
	}
	arg_4_0.vars.btn_name = {
		Part = "equip_craft_event_part_btn",
		MainStat = "equip_craft_event_main_stat_btn",
		SetFx = "equip_craft_event_set_btn",
		SubStat = "equip_craft_event_sub_stat_btn"
	}
	
	arg_4_0.UI:create(arg_4_1)
end

function EquipCraftEvent.Base.remove(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	arg_5_0.UI:remove()
	
	arg_5_0.vars = nil
end

function EquipCraftEvent.Base.isExist(arg_6_0)
	return arg_6_0.UI:isExist()
end

function EquipCraftEvent.Base.getLayerForMode(arg_7_0, arg_7_1)
	return arg_7_0.UI:getLayerForMode(arg_7_1)
end

function EquipCraftEvent.Base.setMode(arg_8_0, arg_8_1)
	arg_8_0.vars.mode = arg_8_1
	
	arg_8_0.UI:setTitleLabel(arg_8_0.vars.titles[arg_8_1])
	arg_8_0.UI:setDescLabel(arg_8_0.vars.desc[arg_8_1])
	arg_8_0.UI:setButtonLabel(arg_8_0.vars.btn_name[arg_8_1])
end

function EquipCraftEvent.Base.getMode(arg_9_0)
	return arg_9_0.vars.mode
end

function EquipCraftEvent.Base.setRequirePoint(arg_10_0, arg_10_1)
	arg_10_0.UI:setRequirePoint(arg_10_1)
end

function EquipCraftEvent.Base.updateButtonStatus(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.UI:updateButtonStatus(arg_11_1, arg_11_2)
end

function EquipCraftEvent.Base.setDefaultDecideMode(arg_12_0)
	arg_12_0.UI:setDefaultDecideMode()
end

function EquipCraftEvent.Base.setOptionalSelectMode(arg_13_0)
	arg_13_0.UI:setOptionalSelectMode()
end

function EquipCraftEvent.Base.setOptionalButtonActive(arg_14_0, arg_14_1)
	arg_14_0.UI:setOptionalButtonActive(arg_14_1)
end

function EquipCraftEvent.Base.updateRing(arg_15_0, arg_15_1)
	EquipCraftEvent.Ring:setMode(arg_15_1)
	EquipCraftEvent.UI:updateRing(arg_15_0.UI:getBase(), EquipCraftEvent.Data:getEquipCraftEventInfo())
end

function EquipCraftEvent.Base.updatePoint(arg_16_0)
	EquipCraftEvent.Ring:updatePoint(arg_16_0.UI:getBase())
end

function EquipCraftEvent.Base.updateConfirmButtonStatus(arg_17_0)
	EquipCraftEvent.Ring.UI:updateConfirmButtonStatus(arg_17_0.UI:getBase())
end

local var_0_0 = EquipCraftEvent.Base.UI

function var_0_0.create(arg_18_0, arg_18_1)
	arg_18_0.vars = {}
	arg_18_0.vars.base = load_dlg("equip_craft_event_base", true, EquipCraftEvent:getUIFolder())
	arg_18_0.vars.mode_to_node_name = {
		Part = "n_part_step",
		MainStat = "n_main_stat_step",
		SetFx = "n_set_step",
		SubStat = "n_sub_stat_step"
	}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.mode_to_node_name) do
		if_set_visible(arg_18_0.vars.base, iter_18_1, false)
	end
	
	arg_18_1:addChild(arg_18_0.vars.base)
end

function var_0_0.remove(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.base) then
		return 
	end
	
	arg_19_0.vars.base:removeFromParent()
end

function var_0_0.getLayerForMode(arg_20_0, arg_20_1)
	return arg_20_0.vars.base:findChildByName(arg_20_0.vars.mode_to_node_name[arg_20_1])
end

function var_0_0.getBase(arg_21_0)
	return arg_21_0.vars.base
end

function var_0_0.isExist(arg_22_0)
	return arg_22_0.vars and get_cocos_refid(arg_22_0.vars.base)
end

function var_0_0.updateButtonStatus(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_2 > EquipCraftEvent.Data:getCraftPoint() then
		arg_23_1 = false
	end
	
	local var_23_0 = cc.c3b(255, 255, 255)
	
	if not arg_23_1 then
		var_23_0 = cc.c3b(76, 76, 76)
	end
	
	if_set_color(arg_23_0.vars.base, "btn_decide", var_23_0)
end

function var_0_0.setOptionalButtonActive(arg_24_0, arg_24_1)
	local var_24_0 = cc.c3b(255, 255, 255)
	
	if not arg_24_1 then
		var_24_0 = cc.c3b(76, 76, 76)
	end
	
	if_set_color(arg_24_0.vars.base, "btn_sub_stat_select", var_24_0)
end

function var_0_0.setRequirePoint(arg_25_0, arg_25_1)
	if_set(arg_25_0.vars.base, "label_point", arg_25_1)
end

function var_0_0.setDefaultDecideMode(arg_26_0)
	if_set_visible(arg_26_0.vars.base, "btn_decide", true)
	if_set_visible(arg_26_0.vars.base, "btn_sub_stat_select", false)
end

function var_0_0.setOptionalSelectMode(arg_27_0)
	if_set_visible(arg_27_0.vars.base, "btn_decide", false)
	if_set_visible(arg_27_0.vars.base, "btn_sub_stat_select", true)
end

function var_0_0.setTitleLabel(arg_28_0, arg_28_1)
	if_set(arg_28_0.vars.base, "txt_step_title", T(arg_28_1))
end

function var_0_0.setDescLabel(arg_29_0, arg_29_1)
	if_set(arg_29_0.vars.base, "t_step_disc", T(arg_29_1))
end

function var_0_0.setButtonLabel(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.vars.base:findChildByName("btn_decide")
	
	if_set(var_30_0, "label", T(arg_30_1))
end
