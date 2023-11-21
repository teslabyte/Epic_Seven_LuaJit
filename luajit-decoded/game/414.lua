EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.SetFx = {}
EquipCraftEvent.SetFx.UI = {}
EquipCraftEvent.SetFx.Data = {}

function MsgHandler.equip_craft_step1(arg_1_0)
	EquipCraftEvent.SetFx:onResponse(arg_1_0)
end

local function var_0_0(arg_2_0)
	return EquipCraftEventUtil:isDataEmpty(arg_2_0)
end

local var_0_1 = EquipCraftEvent.SetFx

function EquipCraftEvent.SetFx.onHandler(arg_3_0, arg_3_1, arg_3_2)
	if string.find(arg_3_2, "btn_set%d") then
		local var_3_0 = true
		local var_3_1 = arg_3_1.id
		local var_3_2 = arg_3_1
		local var_3_3 = arg_3_0.Data:getSelectedId()
		
		if var_3_1 == var_3_3 and not var_0_0(var_3_3) then
			return 
		end
		
		if arg_3_0.Data:isAlreadySelectedControl(arg_3_1) then
			var_3_1 = nil
			var_3_2 = nil
			var_3_0 = false
		elseif arg_3_0.Data:isExistSelect() then
			arg_3_0.UI:setSelect(arg_3_0.Data:getSelectControl(), false, nil, true)
		end
		
		if false then
		end
		
		arg_3_0.Data:setSelectId(var_3_1)
		arg_3_0.Data:setSelectControl(var_3_2)
		arg_3_0.UI:setSelect(arg_3_1, var_3_0, arg_3_0.Data:getSelectId())
		EquipCraftEvent.Base:updateButtonStatus(arg_3_0:getButtonStatus(), arg_3_0.Data:getRequirePoint())
	end
	
	if arg_3_2 == "btn_decide" then
		local var_3_4 = {
			not_exist_select = "equip_craft_event_msg_set_select",
			not_point_enough = "equip_craft_event_msg_set_point",
			not_changed = "equip_craft_event_msg_set_select"
		}
		
		if not EquipCraftEventUtil:checkDecide(arg_3_0.Data:isExistSelect(), arg_3_0.Data:isChanged(), arg_3_0.Data:isPointEnough(), var_3_4) then
			return 
		end
		
		arg_3_0.UI:makeConfirmDialog()
	end
end

function EquipCraftEvent.SetFx.onResponse(arg_4_0, arg_4_1)
	EquipCraftEvent:updateByResponse(arg_4_1)
	EquipCraftEvent:nextProgress()
end

function EquipCraftEvent.SetFx.onEnter(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	
	local var_5_0 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	
	arg_5_0.Data:onEnter(var_5_0)
	arg_5_0.UI:onEnter(arg_5_1, arg_5_0.Data:getSelectId())
	EquipCraftEvent.Base:setRequirePoint(arg_5_0.Data:getRequirePoint())
end

function EquipCraftEvent.SetFx.getButtonStatus(arg_6_0)
	return arg_6_0.Data:isExistSelect() and arg_6_0.Data:isChanged()
end

function EquipCraftEvent.SetFx.procChange(arg_7_0)
	EquipCraftEvent:query("equip_craft_step1", {
		set_fx = arg_7_0.Data:getSelectId()
	})
end

function EquipCraftEvent.SetFx.onLeave(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_0.Data:onLeave()
	arg_8_0.UI:onLeave()
end

local var_0_2 = EquipCraftEvent.SetFx.UI

function var_0_2.onEnter(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.vars = {}
	arg_9_0.vars.n_set_step = arg_9_1
	
	if_set_visible(arg_9_0.vars.n_set_step, nil, true)
	arg_9_0:updateUI(arg_9_0.vars.n_set_step, arg_9_2)
end

function var_0_2.onLeave(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	arg_10_0:removeAllSprites(arg_10_0.vars.n_set_step, "n_change_select")
	if_set_visible(arg_10_0.vars.n_set_step, nil, false)
	
	arg_10_0.vars = nil
end

function var_0_2.updateUI(arg_11_0, arg_11_1, arg_11_2)
	if_set_visible(arg_11_1, nil, true)
	
	local var_11_0 = UIUtil:getSetItemListExtention()
	local var_11_1 = arg_11_1:findChildByName("n_btn_set")
	
	for iter_11_0 = 1, 16 do
		if_set_visible(var_11_1, "btn_set" .. iter_11_0, false)
	end
	
	for iter_11_1, iter_11_2 in pairs(var_11_0) do
		local var_11_2 = var_11_1:findChildByName("btn_set" .. iter_11_1)
		
		if var_11_2 then
			if_set_visible(var_11_2, nil, true)
			if_set_visible(var_11_2, "img_select", false)
			
			local var_11_3 = DB("item_set", iter_11_2, "icon")
			
			if_set_sprite(var_11_2, "icon", "item/" .. var_11_3 .. ".png")
			
			var_11_2.id = iter_11_2
			
			if_set_visible(var_11_2, "img_selected", iter_11_2 == arg_11_2)
		end
	end
	
	arg_11_0:updateSelect()
end

function var_0_2.removeSprite(arg_12_0, arg_12_1, arg_12_2)
	EquipCraftEventUtil:removeSprite(arg_12_1, arg_12_2)
end

function var_0_2.updateSelect(arg_13_0, arg_13_1)
	local var_13_0 = var_0_1.Data:getSelectedId()
	local var_13_1
	
	if not var_0_0(arg_13_1) then
		var_13_1 = arg_13_1
	elseif not var_0_0(var_13_0) then
		var_13_1 = var_13_0
	end
	
	local var_13_2 = arg_13_0.vars.n_set_step:findChildByName("n_after_select")
	
	if_set_visible(arg_13_0.vars.n_set_step, "n_before_select", var_13_1 == nil)
	if_set_visible(var_13_2, nil, var_13_1 ~= nil)
	
	if var_0_0(arg_13_1) and var_0_0(var_13_0) then
		return 
	end
	
	arg_13_0:updateIcons(var_13_2, var_13_0, arg_13_1, "n_change_select")
end

function var_0_2.makeSprite(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = cc.Sprite:create("img/icon_menu_" .. arg_14_1 .. ".png")
	
	var_14_0:setName("icon_sprite_" .. arg_14_2)
	
	return var_14_0
end

function var_0_2.getSelectIcon(arg_15_0, arg_15_1)
	return EquipCraftEventUtil:getSelectIcon(arg_15_1)
end

function var_0_2.getSelectedIcons(arg_16_0, arg_16_1, arg_16_2)
	return EquipCraftEventUtil:getSelectedIcons(arg_16_1, arg_16_2)
end

function var_0_2.removeAllSprites(arg_17_0, arg_17_1, arg_17_2)
	EquipCraftEventUtil:removeAllSprites(arg_17_1, arg_17_2)
end

function var_0_2.updateIcons(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0
	
	if not var_0_0(arg_18_3) then
		var_18_0 = arg_18_3
	elseif not var_0_0(arg_18_2) then
		var_18_0 = arg_18_2
	end
	
	local var_18_1 = arg_18_0:getSelectIcon(arg_18_1)
	local var_18_2, var_18_3, var_18_4 = arg_18_0:getSelectedIcons(arg_18_1, arg_18_4)
	local var_18_5 = var_0_1.Data:isSingleSelect()
	
	if_set_visible(var_18_1, nil, var_18_5)
	if_set_visible(var_18_2, nil, not var_18_5)
	if_set_visible(var_18_3, nil, not var_18_5)
	if_set_visible(var_18_4, nil, not var_18_5)
	arg_18_0:removeAllSprites(arg_18_1, arg_18_4)
	
	local var_18_6 = "equip_craft_event_set_select_txt"
	
	if var_18_5 then
		var_18_1:addChild(arg_18_0:makeSprite(var_18_0, 1))
	elseif not var_0_0(arg_18_2) and not var_0_0(arg_18_3) then
		var_18_6 = "equip_craft_event_set_change_txt"
		
		var_18_3:addChild(arg_18_0:makeSprite(arg_18_2, 1))
		var_18_4:addChild(arg_18_0:makeSprite(arg_18_3, 2))
	end
	
	local var_18_7 = DB("item_set", var_18_0, "name")
	
	arg_18_5 = arg_18_5 or arg_18_0.vars.n_set_step
	
	if_set(arg_18_5, "t_selected_info", T(var_18_6, {
		set_name = T(var_18_7)
	}))
end

function var_0_2.setSelect(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if_set_visible(arg_19_1, "img_select", arg_19_2)
	
	if arg_19_4 then
		return 
	end
	
	arg_19_0:updateSelect(arg_19_3)
end

function var_0_2.makeConfirmDialog(arg_20_0)
	if get_cocos_refid(arg_20_0.vars.confirm_dlg) then
		return 
	end
	
	local var_20_0 = EquipCraftEventUtil:makeConfirmDialog("equip_craft_event_confirm_set", var_0_1.Data:getRequirePoint(), "equip_craft_event_msg_set_confirm", function()
		var_0_1:procChange()
	end)
	
	arg_20_0:updateIcons(var_20_0, var_0_1.Data:getSelectedId(), var_0_1.Data:getSelectId(), "n_change_select_icon", var_20_0:findChildByName("n_contents"))
	
	local var_20_1 = var_0_1.Data:isSingleSelect()
	local var_20_2 = "equip_craft_event_confirm_set_desc1"
	
	if not var_20_1 then
		var_20_2 = "equip_craft_event_confirm_set_desc2"
	end
	
	if_set(var_20_0, "t_disc_select", T(var_20_2))
	
	arg_20_0.vars.confirm_dlg = var_20_0
end

local var_0_3 = EquipCraftEvent.SetFx.Data

function var_0_3.onEnter(arg_22_0, arg_22_1)
	arg_22_0.vars = {}
	arg_22_0.vars.craft_info = arg_22_1
	arg_22_0.vars.select_id = arg_22_1.set_fx
	
	if not var_0_0(arg_22_0.vars.select_id) then
		arg_22_0.vars.selected_id = arg_22_0.vars.select_id
	end
end

function var_0_3.onLeave(arg_23_0)
	arg_23_0.vars = nil
end

function var_0_3.isExistSelect(arg_24_0)
	return not var_0_0(arg_24_0.vars.select_id)
end

function var_0_3.isAlreadySelectedControl(arg_25_0, arg_25_1)
	return arg_25_1.id == arg_25_0.vars.select_id
end

function var_0_3.isSingleSelect(arg_26_0)
	return var_0_0(arg_26_0.vars.select_id) or var_0_0(arg_26_0.vars.selected_id) or arg_26_0.vars.select_id == arg_26_0.vars.selected_id
end

function var_0_3.isChanged(arg_27_0)
	return arg_27_0.vars.selected_id ~= arg_27_0.vars.select_id
end

function var_0_3.setSelectControl(arg_28_0, arg_28_1)
	arg_28_0.vars.select_cont = arg_28_1
end

function var_0_3.setSelectId(arg_29_0, arg_29_1)
	arg_29_0.vars.select_id = arg_29_1
end

function var_0_3.getSelectControl(arg_30_0)
	return arg_30_0.vars.select_cont
end

function var_0_3.getSelectId(arg_31_0)
	return arg_31_0.vars.select_id
end

function var_0_3.getSelectedId(arg_32_0)
	return arg_32_0.vars.selected_id
end

function var_0_3.onLeave(arg_33_0)
	arg_33_0.vars = nil
end

function var_0_3.useCraftPoint(arg_34_0)
	EquipCraftEvent.Data:useCraftPoint(arg_34_0:getRequirePoint())
end

function var_0_3.isPointEnough(arg_35_0)
	return EquipCraftEvent.Data:isCanUseCraftPoint(arg_35_0:getRequirePoint())
end

function var_0_3.getRequirePoint(arg_36_0)
	local var_36_0 = EquipCraftEvent.Data:getEventId()
	
	return DB("event_equip_craft", var_36_0, "set_point")
end
