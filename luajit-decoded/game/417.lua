EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.SubStat = {}
EquipCraftEvent.SubStat.UI = {}
EquipCraftEvent.SubStat.Data = {}

local var_0_0 = EquipCraftEvent.SubStat

function MsgHandler.equip_craft_add_optional_substats(arg_1_0)
	EquipCraftEvent.SubStat:onResponseOptionalSubStat(arg_1_0)
end

function MsgHandler.equip_craft_select_substat(arg_2_0)
	EquipCraftEvent.SubStat:onResponseConfirmSubStat(arg_2_0)
end

function EquipCraftEvent.SubStat.onHandler(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 == "btn_decide" then
		if not EquipCraftEventUtil:checkDecide(true, true, arg_3_0.Data:isPointEnough()) then
			return 
		end
		
		arg_3_0:procOptionalSubStat()
	end
	
	if arg_3_2 == "btn_sub_stat_select" then
		local var_3_0 = {
			not_exist_select = "equip_craft_event_msg_sub_select"
		}
		
		if not EquipCraftEventUtil:checkDecide(arg_3_0.Data:isExistSelect(), true, true, var_3_0) then
			return 
		end
		
		arg_3_0:procConfirmSubStat()
	end
	
	if string.starts(arg_3_2, "btn_sub_stat_detail") then
		local var_3_1 = string.sub(arg_3_2, #"btn_sub_stat_detail" + 1, -1)
		local var_3_2 = tonumber(var_3_1)
		
		arg_3_0.Data:selectSubOption(var_3_2)
		arg_3_0.UI:selectSubOption(arg_3_0.Data:getSubOption())
		EquipCraftEvent.Base:setOptionalButtonActive(arg_3_0.Data:isExistSelect())
	end
end

function EquipCraftEvent.SubStat.getButtonStatus(arg_4_0)
	return true
end

function EquipCraftEvent.SubStat.onResponseOptionalSubStat(arg_5_0, arg_5_1)
	EquipCraftEvent:updateByResponse(arg_5_1)
	EquipCraftEvent.Base:updateConfirmButtonStatus()
	arg_5_0.UI:uiUpdate()
end

function EquipCraftEvent.SubStat.onResponseConfirmSubStat(arg_6_0, arg_6_1)
	EquipCraftEvent:updateByResponse(arg_6_1)
	EquipCraftEvent.Base:updateConfirmButtonStatus()
	arg_6_0.Data:selectSubOption(nil)
	arg_6_0.UI:selectSubOption(arg_6_0.Data:getSubOption())
	arg_6_0.UI:uiUpdate()
	EquipCraftEvent.Base:updateButtonStatus(true, arg_6_0.Data:getRequirePoint())
end

function EquipCraftEvent.SubStat.procConfirmSubStat(arg_7_0)
	EquipCraftEvent:query("equip_craft_select_substat", {
		select_new = arg_7_0.Data:isSelectNew()
	})
end

function EquipCraftEvent.SubStat.procOptionalSubStat(arg_8_0)
	EquipCraftEvent:query("equip_craft_add_optional_substats")
end

function EquipCraftEvent.SubStat.makeConfirmDialog(arg_9_0)
end

function EquipCraftEvent.SubStat.onDecide(arg_10_0)
end

function EquipCraftEvent.SubStat.onSetSubStat(arg_11_0, arg_11_1)
end

function EquipCraftEvent.SubStat.onEnter(arg_12_0, arg_12_1)
	arg_12_0.vars = {}
	
	local var_12_0 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	
	arg_12_0.Data:onEnter(var_12_0)
	
	local var_12_1 = EquipCraftEvent.Data:getEquipDatas(var_12_0.set_fx)
	
	arg_12_0.UI:onEnter(arg_12_1, var_12_0, var_12_1)
end

function EquipCraftEvent.SubStat.onLeave(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	arg_13_0.Data:onLeave()
	arg_13_0.UI:onLeave()
	EquipCraftEvent.Base:setDefaultDecideMode()
end

local var_0_1 = var_0_0.UI

function var_0_1.onEnter(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0.vars = {}
	arg_14_0.vars.target_layer = arg_14_1
	
	if_set_visible(arg_14_0.vars.target_layer, nil, true)
	arg_14_0:uiUpdate(arg_14_2, arg_14_3)
end

function var_0_1.onLeave(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	if_set_visible(arg_15_0.vars.target_layer, nil, false)
	
	arg_15_0.vars = nil
end

function var_0_1.selectInit(arg_16_0)
	for iter_16_0 = 1, 2 do
		local var_16_0 = arg_16_0.vars.target_layer:findChildByName("btn_sub_stat_detail" .. iter_16_0)
		
		if_set_visible(var_16_0, "img_select", false)
	end
end

function var_0_1.uiUpdate(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = EquipCraftEvent.Data:getEventPreviewEquip()
	local var_17_1 = EquipCraftEvent.Data:getEventOptionalEquip()
	local var_17_2 = arg_17_0.vars.target_layer:findChildByName("n_sub_stat_detail_only")
	local var_17_3 = var_17_0 and var_17_1 == nil
	
	if_set_visible(arg_17_0.vars.target_layer, "n_sub_stat_detail_only", var_17_3)
	if_set_visible(arg_17_0.vars.target_layer, "t_disc", not var_17_3)
	if_set_visible(arg_17_0.vars.target_layer, "n_sub_stat_change", not var_17_3)
	arg_17_0:selectInit()
	
	if not var_17_3 then
		var_17_2 = arg_17_0.vars.target_layer:findChildByName("n_sub_stat_change")
	end
	
	arg_17_0:updatePreviewItems(var_17_2, var_17_3)
	
	if not var_17_3 then
		EquipCraftEvent.Base:setOptionalSelectMode()
		EquipCraftEvent.Base:setOptionalButtonActive(false)
	else
		EquipCraftEvent.Base:setDefaultDecideMode()
	end
	
	EquipCraftEvent.Base:updatePoint()
end

function var_0_1.activeSubOption(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.vars.target_layer:findChildByName("btn_sub_stat_detail" .. arg_18_1)
	
	if_set_visible(var_18_0, "img_select", arg_18_2)
end

function var_0_1.selectSubOption(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.vars.prv_idx
	
	if var_19_0 then
		arg_19_0:activeSubOption(var_19_0, false)
	end
	
	if arg_19_1 then
		arg_19_0:activeSubOption(arg_19_1, true)
	end
	
	arg_19_0.vars.prv_idx = arg_19_1
end

function var_0_1.setEquipInfo(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = UIUtil:makeUnitEquipItemTooltipOpts(arg_20_2, arg_20_1, true)
	
	ItemTooltip:updateItemInformation(var_20_0)
end

function var_0_1.updatePreviewItems(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = EquipCraftEvent.Data:getEventPreviewEquip()
	local var_21_1 = EquipCraftEvent.Data:getEventOptionalEquip()
	
	if arg_21_2 then
		arg_21_0:setEquipInfo(EQUIP:createByInfo(var_21_0), arg_21_1)
	else
		arg_21_0:setEquipInfo(EQUIP:createByInfo(var_21_0), arg_21_1:findChildByName("btn_sub_stat_detail1"))
		arg_21_0:setEquipInfo(EQUIP:createByInfo(var_21_1), arg_21_1:findChildByName("btn_sub_stat_detail2"))
	end
end

function var_0_1.selectSubStat(arg_22_0, arg_22_1, arg_22_2)
end

local var_0_2 = var_0_0.Data

function var_0_2.onEnter(arg_23_0, arg_23_1)
	arg_23_0.vars = {}
	arg_23_0.vars.craft_info = arg_23_1
end

function var_0_2.onLeave(arg_24_0)
	arg_24_0.vars = nil
end

function var_0_2.isExistSelect(arg_25_0)
	return arg_25_0.vars.select_idx ~= nil
end

function var_0_2.isChanged(arg_26_0)
	return true
end

function var_0_2.getRequirePoint(arg_27_0)
	local var_27_0 = EquipCraftEvent.Data:getEventId()
	
	return DB("event_equip_craft", var_27_0, "sub_stat_point")
end

function var_0_2.useCraftPoint(arg_28_0)
	EquipCraftEvent.Data:useCraftPoint(arg_28_0:getRequirePoint())
	EquipCraftEvent.Base:updatePoint()
end

function var_0_2.isPointEnough(arg_29_0)
	return EquipCraftEvent.Data:isCanUseCraftPoint(arg_29_0:getRequirePoint())
end

function var_0_2.getSubOption(arg_30_0)
	return arg_30_0.vars.select_idx
end

function var_0_2.selectSubOption(arg_31_0, arg_31_1)
	if arg_31_1 == arg_31_0.vars.select_idx then
		arg_31_0.vars.select_idx = nil
	else
		arg_31_0.vars.select_idx = arg_31_1
	end
end

function var_0_2.getSelectSubStat(arg_32_0)
	return arg_32_0.vars.select_idx
end

function var_0_2.isSelectNew(arg_33_0)
	return arg_33_0.vars.select_idx == 2
end

function var_0_2.onHandler(arg_34_0, arg_34_1)
end
