LotaLegacyChangeUI = {}

function HANDLER.clan_heritage_legacy_change(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_slot") then
		local var_1_0 = tonumber(string.sub(arg_1_1, -1, -1))
		
		LotaLegacyChangeUI:select(var_1_0)
	end
	
	if arg_1_1 == "btn_change" then
		LotaLegacyChangeUI:confirmChange()
	end
	
	if arg_1_1 == "btn_my_cancel" then
		LotaLegacyChangeUI:cancel()
	end
end

function LotaLegacyChangeUI.select(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.vars.legacies[arg_2_1]
	
	if not var_2_0 then
		balloon_message_with_sound("msg_clan_heritage_select_legacy")
		
		return 
	end
	
	if var_2_0:isStartLegacy() then
		balloon_message_with_sound("msg_clan_heritage_cant_change_starting")
		
		return 
	end
	
	if arg_2_0:get5GradeLegacyIndex() and arg_2_0.vars.change_target_legacy:getGrade() == 5 and var_2_0:getGrade() ~= 5 then
		balloon_message_with_sound("msg_clan_heritage_legend_legacy_error")
		
		return 
	end
	
	if arg_2_0:getSameEffectLegacyIndex() and arg_2_0.vars.change_target_legacy:getSkillEffect() ~= var_2_0:getSkillEffect() then
		balloon_message_with_sound("msg_clan_heritage_dupl_effect")
		
		return 
	end
	
	arg_2_0:deSelect()
	arg_2_0:setFlagNodeSelect(arg_2_1, true)
	arg_2_0:updateSelected(true)
	
	local var_2_1 = arg_2_0.vars.dlg:findChildByName("n_selected"):findChildByName("n_sel_legacy")
	
	LotaUtil:updateLegacyTooltip(var_2_1, var_2_0, {
		dont_size = true
	})
	
	arg_2_0.vars.selected_idx = arg_2_1
end

function LotaLegacyChangeUI.cancel(arg_3_0)
	arg_3_0:close()
end

function LotaLegacyChangeUI.isOpen(arg_4_0)
	return arg_4_0.vars ~= nil
end

function LotaLegacyChangeUI.getSelectLegacy(arg_5_0)
	return arg_5_0.vars.legacies[arg_5_0.vars.selected_idx]
end

function LotaLegacyChangeUI.confirmChange(arg_6_0)
	if not arg_6_0.vars.selected_idx then
		balloon_message_with_sound("msg_clan_heritage_change_legacy_error")
		
		return 
	end
	
	Dialog:msgBox(T("ui_msg_change_legacy_ok"), {
		yesno = true,
		handler = function()
			LotaNetworkSystem:sendQuery("lota_confirm_legacy_select", {
				select_replace_inventory_idx = arg_6_0.vars.selected_idx,
				select_confirm_legacy_idx = arg_6_0.vars.change_target_legacy_idx
			})
		end
	})
end

function HANDLER.clan_heritage_legacy_change_confirm(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_close" then
		local var_8_0 = LotaSystem:getUIDialogLayer():findChildByName("clan_heritage_legacy_change_confirm")
		
		if var_8_0 then
			var_8_0:removeFromParent()
		end
		
		LotaSystem:requestAutoHandlingEffects()
		LotaSystem:setBlockCoolTime()
	end
end

function LotaLegacyChangeUI.makeConfirmDlg(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = LotaUtil:getUIDlg("clan_heritage_legacy_change_confirm")
	local var_9_1 = var_9_0:findChildByName("n_sel_legacy")
	
	LotaUtil:updateLegacyTooltip(var_9_1, arg_9_2, {
		dont_size = true
	})
	
	local var_9_2 = var_9_0:findChildByName("n_apply_legacy")
	
	LotaUtil:updateLegacyTooltip(var_9_2, arg_9_1, {
		dont_size = true
	})
	
	local var_9_3, var_9_4 = var_9_2:findChildByName("n_grade"):getPosition()
	
	EffectManager:Play({
		z = -1,
		fn = "ui_eff_legacy_select.cfx",
		layer = var_9_2,
		x = var_9_3,
		y = var_9_4
	})
	LotaSystem:getUIDialogLayer():addChild(var_9_0)
end

function LotaLegacyChangeUI.open(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0.vars = {}
	arg_10_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_legacy_change")
	arg_10_0.vars.change_target_legacy = arg_10_2
	arg_10_0.vars.change_target_legacy_idx = arg_10_3
	
	arg_10_1:addChild(arg_10_0.vars.dlg)
	
	arg_10_0.vars.legacies = LotaUserData:getArtifacts()
	
	arg_10_0:updateUI(arg_10_2)
	arg_10_0:selectAuto()
	BackButtonManager:push({
		check_id = "lota_legacy_change",
		back_func = function()
			arg_10_0:cancel()
		end
	})
end

function LotaLegacyChangeUI.get5GradeLegacyIndex(arg_12_0)
	return LotaUtil:get5GradeLegacyIndex()
end

function LotaLegacyChangeUI.getSameEffectLegacyIndex(arg_13_0)
	return LotaUtil:getSameEffectLegacyIndex(arg_13_0.vars.change_target_legacy)
end

function LotaLegacyChangeUI.selectAuto(arg_14_0)
	if arg_14_0.vars.change_target_legacy:getGrade() == 5 then
		local var_14_0 = arg_14_0:get5GradeLegacyIndex()
		
		if var_14_0 then
			arg_14_0:select(var_14_0)
			
			return 
		end
	end
	
	local var_14_1 = arg_14_0:getSameEffectLegacyIndex()
	
	if var_14_1 then
		arg_14_0:select(var_14_1)
	end
end

function LotaLegacyChangeUI.isOpen(arg_15_0)
	return arg_15_0.vars and get_cocos_refid(arg_15_0.vars.dlg)
end

function LotaLegacyChangeUI.close(arg_16_0)
	if not arg_16_0:isOpen() then
		return 
	end
	
	arg_16_0.vars.dlg:removeFromParent()
	
	arg_16_0.vars = nil
	
	BackButtonManager:pop("lota_legacy_change")
end

function LotaLegacyChangeUI.updateSelected(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.vars.dlg:findChildByName("n_selected")
	
	if_set_visible(var_17_0, "n_not_select", not arg_17_1)
	if_set_visible(var_17_0, "n_sel_legacy", arg_17_1)
	
	local var_17_1 = cc.c3b(255, 255, 255)
	
	if not arg_17_1 then
		var_17_1 = cc.c3b(136, 136, 136)
	end
	
	if_set_color(arg_17_0.vars.dlg, "btn_change", var_17_1)
end

function LotaLegacyChangeUI.updateUI(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.dlg
	local var_18_1 = LotaUserData:getLegacyInventoryMax()
	
	LotaUtil:updateLegacySlots(var_18_0, arg_18_0.vars.legacies, var_18_1, LotaUserData:getExp())
	arg_18_0:updateSelected(false)
	
	local var_18_2 = arg_18_0.vars.dlg:findChildByName("n_apply_legacy")
	
	LotaUtil:updateLegacyTooltip(var_18_2, arg_18_1, {
		dont_size = true
	})
end

function LotaLegacyChangeUI.setFlagNodeSelect(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.vars.dlg:findChildByName("n_slot" .. arg_19_1)
	
	if_set_visible(var_19_0, "n_select", arg_19_2)
	LotaUtil:onSelectAnimation(var_19_0, "n_select")
end

function LotaLegacyChangeUI.deSelect(arg_20_0)
	if not arg_20_0.vars.selected_idx then
		return 
	end
	
	arg_20_0:setFlagNodeSelect(arg_20_0.vars.selected_idx, false)
end
