EquipCraftEventUtil = {}

function EquipCraftEventUtil.getSelectIcon(arg_1_0, arg_1_1)
	if not arg_1_1 or not get_cocos_refid(arg_1_1) then
		return 
	end
	
	return arg_1_1:findChildByName("n_selected_icon")
end

function EquipCraftEventUtil.getSelectedIcons(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_1 or not get_cocos_refid(arg_2_1) then
		return 
	end
	
	local var_2_0 = arg_2_1:findChildByName(arg_2_2)
	local var_2_1 = var_2_0:findChildByName("n_selected_icon_1")
	local var_2_2 = var_2_0:findChildByName("n_selected_icon_2")
	
	return var_2_0, var_2_1, var_2_2
end

function EquipCraftEventUtil.removeAllSprites(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0:getSelectIcon(arg_3_1)
	local var_3_1, var_3_2, var_3_3 = arg_3_0:getSelectedIcons(arg_3_1, arg_3_2)
	
	arg_3_0:removeSprite(var_3_0, 1)
	arg_3_0:removeSprite(var_3_2, 1)
	arg_3_0:removeSprite(var_3_2, 2)
	arg_3_0:removeSprite(var_3_3, 1)
	arg_3_0:removeSprite(var_3_3, 2)
end

function EquipCraftEventUtil.removeSprite(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 or not get_cocos_refid(arg_4_1) then
		return 
	end
	
	local var_4_0 = arg_4_1:findChildByName("icon_sprite_" .. arg_4_2)
	
	if get_cocos_refid(var_4_0) then
		var_4_0:removeFromParent()
	end
end

function EquipCraftEventUtil.makeConfirmDialog(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = load_dlg(arg_5_1, true, EquipCraftEvent:getUIFolder())
	
	if_set(var_5_0, "label_0", arg_5_2)
	Dialog:msgBox(T(arg_5_3), {
		yesno = true,
		dlg = var_5_0,
		handler = function(arg_6_0, arg_6_1)
			if arg_6_1 == "btn_yes" then
				arg_5_4()
				
				return 
			end
			
			return "dont_close"
		end
	})
	
	return var_5_0
end

function EquipCraftEventUtil.partToEquipId(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = EquipCraftEvent.Data:getEquipCraftEventInfo()
	local var_7_1 = EquipCraftEvent.Data:getEquipDatas(var_7_0.set_fx)[arg_7_1]
	
	if var_7_1 then
		return var_7_1.equip_id
	end
	
	return nil
end

function EquipCraftEventUtil.checkDecide(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_4 = arg_8_4 or {}
	
	if not arg_8_1 then
		local var_8_0 = arg_8_4.not_exist_select or "equip_craft_event_msg_not_select"
		
		balloon_message_with_sound(var_8_0)
		
		return false
	end
	
	if not arg_8_2 then
		local var_8_1 = arg_8_4.not_changed or "equip_craft_event_msg_not_change"
		
		balloon_message_with_sound(var_8_1)
		
		return false
	end
	
	if not arg_8_3 then
		local var_8_2 = arg_8_4.not_point_enough or "equip_craft_event_msg_sub_point"
		
		balloon_message_with_sound(var_8_2)
		
		return false
	end
	
	return true
end

function EquipCraftEventUtil.setVisibleSelects(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_1
	local var_9_1 = arg_9_2 ~= nil or arg_9_3 ~= nil
	
	if_set_visible(var_9_0, "n_before_select", not var_9_1)
	if_set_visible(var_9_0, "n_after_select", var_9_1)
end

function EquipCraftEventUtil.updateResultDisplayText(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	local var_10_0 = arg_10_2 or arg_10_3
	local var_10_1 = (arg_10_2 == nil or arg_10_3 == nil) and (arg_10_2 ~= nil or arg_10_3 ~= nil)
	local var_10_2 = arg_10_4
	
	if not var_10_1 then
		var_10_2 = arg_10_5
	end
	
	if not arg_10_2 and not arg_10_3 then
		if_set_visible(arg_10_1, nil, false)
	else
		local var_10_3 = arg_10_7(var_10_0)
		
		if_set_visible(arg_10_1, nil, true)
		if_set(arg_10_1, nil, T(var_10_2, {
			[arg_10_6] = var_10_3
		}))
	end
end

function EquipCraftEventUtil.updateResultDisplay(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	if not (arg_11_3 ~= nil or arg_11_4 ~= nil) then
		return 
	end
	
	arg_11_6 = arg_11_6 or "n_after_select"
	
	local var_11_0 = arg_11_1:findChildByName(arg_11_6)
	local var_11_1 = arg_11_4 and arg_11_3 and arg_11_4 ~= arg_11_3
	local var_11_2 = var_11_0:findChildByName("n_selected_icon")
	local var_11_3 = arg_11_3
	
	if var_11_1 then
		var_11_2 = var_11_0:findChildByName("n_selected_icon_2")
	end
	
	if arg_11_4 and not arg_11_3 then
		var_11_3 = arg_11_4
	end
	
	arg_11_7(var_11_2, arg_11_2, var_11_3, 1)
	
	arg_11_5 = arg_11_5 or "n_change_select"
	
	if_set_visible(arg_11_1, "n_selected_icon", not var_11_1)
	if_set_visible(arg_11_1, arg_11_5, var_11_1)
	
	if not var_11_1 then
		return 
	end
	
	local var_11_4 = var_11_0:findChildByName("n_selected_icon_1")
	
	arg_11_7(var_11_4, arg_11_2, arg_11_4, 2)
end

function EquipCraftEventUtil.findScheduleByAccountData(arg_12_0)
	return arg_12_0:findActiveCraftEventSchedule(AccountData.equip_craft_event_schedules)
end

function EquipCraftEventUtil.getRemainTimeBase(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 or not arg_13_2 then
		return 
	end
	
	return arg_13_2.end_time - os.time()
end

function EquipCraftEventUtil.getRemainTime(arg_14_0)
	local var_14_0, var_14_1 = arg_14_0:findScheduleByAccountData()
	
	return arg_14_0:getRemainTimeBase(var_14_0, var_14_1)
end

function EquipCraftEventUtil.isEventGraceTimeBase(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return false
	end
	
	return arg_15_1 < 604800
end

function EquipCraftEventUtil.isEventGraceTime(arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or arg_16_0:getRemainTime()
	
	return arg_16_0:isEventGraceTimeBase(arg_16_1)
end

function EquipCraftEventUtil.getRemainDateByStringBase(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return 
	end
	
	return sec_to_string(arg_17_1)
end

function EquipCraftEventUtil.getRemainDateByString(arg_18_0)
	local var_18_0 = arg_18_0:getRemainTime()
	
	return arg_18_0:getRemainDateByStringBase(var_18_0)
end

function EquipCraftEventUtil.updateTimeTooltip(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = false
	
	if arg_19_2 then
		var_19_0 = arg_19_0:isEventGraceTimeBase(arg_19_2)
	else
		var_19_0 = arg_19_0:isEventGraceTime()
	end
	
	if_set_visible(arg_19_1, nil, var_19_0)
	
	if var_19_0 then
		local var_19_1
		
		if arg_19_2 then
			var_19_1 = arg_19_0:getRemainDateByStringBase(arg_19_2)
		else
			var_19_1 = arg_19_0:getRemainDateByString()
		end
		
		if_set(arg_19_1, "txt_time", T("equip_craft_event_main_close_time", {
			remain_time = var_19_1
		}))
	end
end

function EquipCraftEventUtil.findActiveCraftEventSchedule(arg_20_0, arg_20_1)
	local var_20_0
	local var_20_1
	local var_20_2 = os.time()
	
	arg_20_1 = arg_20_1 or {}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		if var_20_2 >= iter_20_1.start_time and var_20_2 <= iter_20_1.end_time then
			if var_20_1 then
				Log.e("ALREADY EXIST ACTIVE EVENT, BUT ITS TWICE! CHECK : " .. iter_20_0, var_20_1)
				
				return 
			end
			
			var_20_1 = iter_20_0
			var_20_0 = iter_20_1
		end
	end
	
	return var_20_1, var_20_0
end

function EquipCraftEventUtil.isDataEmpty(arg_21_0, arg_21_1)
	return arg_21_1 == nil or arg_21_1 == ""
end
