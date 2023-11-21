LotaLegacySelectUI = {}

function HANDLER.clan_heritage_legacy_sel(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_legacy") then
		local var_1_0 = #"btn_legacy"
		local var_1_1 = tonumber(string.sub(arg_1_1, var_1_0 + 1, var_1_0 + 1))
		
		LotaLegacySelectUI:selectLegacy(var_1_1)
	end
	
	if arg_1_1 == "btn_confirm" or arg_1_1 == "btn_ok" then
		LotaLegacySelectUI:confirm()
	end
	
	if arg_1_1 == "btn_refresh" then
		LotaLegacySelectUI:startLegacyRefresh()
	end
	
	if arg_1_1 == "btn_cancel" then
		LotaLegacySelectUI:onCancel()
	end
	
	if arg_1_1 == "btn_my_legacy" then
		LotaStatusLegacyUI:open(LotaSystem:getUIDialogLayer(), LotaUtil:getMyUserInfo())
	end
end

function LotaLegacySelectUI.onDeselect(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.vars.dlg:findChildByName("n_select" .. arg_2_1)
	
	LotaUtil:onDeselectAnimation(var_2_0, "legacy_select")
end

function LotaLegacySelectUI.onSelectAnimation(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.vars.dlg:findChildByName("n_select" .. arg_3_1)
	
	LotaUtil:onSelectAnimation(var_3_0, "legacy_select")
end

function LotaLegacySelectUI.selectLegacy(arg_4_0, arg_4_1)
	if arg_4_0.vars.select_idx then
		arg_4_0:onDeselect(arg_4_0.vars.select_idx)
	end
	
	arg_4_0:onSelectAnimation(arg_4_1)
	
	arg_4_0.vars.select_idx = arg_4_1
	
	arg_4_0:updateListUI(arg_4_0.vars.dlg, arg_4_0.vars.legacy_list)
end

function LotaLegacySelectUI.confirm(arg_5_0)
	if not arg_5_0.vars.select_idx then
		balloon_message_with_sound("msg_clan_heritage_change_legacy_error")
		
		return 
	end
	
	local var_5_0 = arg_5_0.vars.legacy_list[arg_5_0.vars.select_idx]:getSkillEffect()
	local var_5_1 = LotaUtil:getRoleLevelByLegacyEffectValue(var_5_0)
	local var_5_2 = 0
	
	if var_5_1 then
		var_5_2 = LotaUserData:getRoleLevelWithoutArtifactByRole(var_5_1) or 0
	end
	
	if not var_5_1 or var_5_2 < LotaUserData:getMaxRoleLevel() then
		arg_5_0:realConfirm()
		
		return 
	end
	
	Dialog:msgBox(T("msg_clan_heritage_roleup_max_legacy"), {
		yesno = true,
		handler = function()
			arg_5_0:realConfirm()
		end
	})
end

function LotaLegacySelectUI.realConfirm(arg_7_0)
	local var_7_0 = arg_7_0.vars.legacy_list[arg_7_0.vars.select_idx]
	
	if LotaUserData:isArtifactInventoryFull() or LotaUtil:isRequireArtifactChange(var_7_0) then
		print("LotaLegacyChangeUI?")
		LotaLegacyChangeUI:open(LotaSystem:getUIDialogLayer(), var_7_0, arg_7_0.vars.select_idx)
	else
		LotaNetworkSystem:sendQuery("lota_confirm_legacy_select", {
			select_confirm_legacy_idx = arg_7_0.vars.select_idx
		})
	end
end

function LotaLegacySelectUI.startLegacyRefresh(arg_8_0)
	if LotaUserData:getStartLegacyRefreshCount() > 0 then
		balloon_message_with_sound("msg_clan_heritage_legacy_refresh_error")
		
		return 
	end
	
	LotaNetworkSystem:sendQuery("lota_refresh_start_legacy_pool")
end

function LotaLegacySelectUI.onCancel(arg_9_0)
	Dialog:msgBox(T("ui_clanheritage_get_skill_cancel"), {
		yesno = true,
		handler = function()
			arg_9_0.vars.cancel = true
			
			LotaNetworkSystem:sendQuery("lota_confirm_legacy_select", {
				clear = true
			})
		end
	})
end

function LotaLegacySelectUI.onConfirmArtifactSelect(arg_11_0)
	if LotaLegacyChangeUI:isOpen() then
		LotaLegacyChangeUI:makeConfirmDlg(arg_11_0.vars.legacy_list[arg_11_0.vars.select_idx], LotaLegacyChangeUI:getSelectLegacy())
	elseif not arg_11_0.vars.cancel then
		arg_11_0:showSelectedArtifact()
	end
	
	arg_11_0:close()
end

function LotaLegacySelectUI.showSelectedArtifact(arg_12_0)
	local var_12_0 = arg_12_0.vars.legacy_list[arg_12_0.vars.select_idx]
	local var_12_1 = cc.Node:create()
	
	var_12_1:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	var_12_1:setLocalZOrder(99999)
	
	if var_12_1:findChildByName("legacy_result") then
		LotaUtil:updateLegacyTooltip(var_12_1:findChildByName("legacy_result"), var_12_0)
	else
		local var_12_2 = LotaUtil:getLegacyTooltip(var_12_0)
		
		var_12_2:setName("legacy_result")
		var_12_2:setAnchorPoint(0.5, 0.5)
		EffectManager:Play({
			fn = "ui_eff_legacy_select.cfx",
			layer = var_12_1
		})
		var_12_1:addChild(var_12_2)
		Dialog:setBack(var_12_1)
		
		local var_12_3 = ccui.Button:create()
		
		var_12_3:setTouchEnabled(true)
		var_12_3:ignoreContentAdaptWithSize(false)
		var_12_3:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_12_3:addTouchEventListener(function(arg_13_0, arg_13_1)
			if arg_13_1 == 2 then
				arg_13_0:getParent():removeFromParent()
				LotaSystem:setBlockCoolTime()
				LotaSystem:requestAutoHandlingEffects()
			end
		end)
		var_12_1:addChild(var_12_3)
		UIAction:Add(DELAY(1000), arg_12_0, "block")
	end
	
	arg_12_0.vars.parent_layer:addChild(var_12_1)
end

function LotaLegacySelectUI.open(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.vars = {}
	arg_14_0.vars.parent_layer = arg_14_1
	arg_14_0.vars.legacy_list = arg_14_2
	arg_14_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_legacy_sel")
	arg_14_0.vars.is_start_legacy_select = nil
	
	for iter_14_0, iter_14_1 in pairs(arg_14_2) do
		if iter_14_1:isStartLegacy() then
			arg_14_0.vars.is_start_legacy_select = true
			
			break
		end
	end
	
	arg_14_0:buildUI()
	arg_14_1:addChild(arg_14_0.vars.dlg)
	
	if not arg_14_0.vars.is_start_legacy_select then
		BackButtonManager:push({
			check_id = "lota_legacy_select",
			back_func = function()
				arg_14_0:onCancel()
			end
		})
	end
	
	if arg_14_0.vars.is_start_legacy_select then
		TutorialGuide:startGuide("tuto_heritage_legacy")
	end
end

function LotaLegacySelectUI.isOpen(arg_16_0)
	return arg_16_0.vars and get_cocos_refid(arg_16_0.vars.dlg)
end

function LotaLegacySelectUI.close(arg_17_0)
	if not arg_17_0:isOpen() then
		return 
	end
	
	LotaLegacyChangeUI:close()
	
	if arg_17_0.vars.cancel and not LotaLegacyChangeUI:isOpen() then
		LotaSystem:requestAutoHandlingEffects()
	end
	
	if arg_17_0.vars.is_start_legacy_select then
	else
		BackButtonManager:pop("lota_legacy_select")
	end
	
	arg_17_0.vars.dlg:removeFromParent()
	
	arg_17_0.vars = nil
end

function LotaLegacySelectUI.updateListUI(arg_18_0, arg_18_1, arg_18_2)
	for iter_18_0 = 1, 3 do
		local var_18_0 = arg_18_1:findChildByName("n_legacy" .. iter_18_0)
		local var_18_1 = arg_18_2[iter_18_0]
		
		if var_18_0:findChildByName("legacy_tooltip") then
			LotaUtil:updateLegacyTooltip(var_18_0:findChildByName("legacy_tooltip"), var_18_1)
		else
			local var_18_2 = LotaUtil:getLegacyTooltip(var_18_1)
			
			var_18_2:setName("legacy_tooltip")
			var_18_0:addChild(var_18_2)
		end
		
		if not arg_18_0.vars.select_idx then
			if_set_color(var_18_0, nil, cc.c3b(255, 255, 255))
		else
			local var_18_3 = cc.c3b(136, 136, 136)
			
			if tonumber(arg_18_0.vars.select_idx) == iter_18_0 then
				var_18_3 = cc.c3b(255, 255, 255)
			end
			
			if_set_color(var_18_0, nil, var_18_3)
		end
	end
end

function LotaLegacySelectUI.buildUI(arg_19_0)
	arg_19_0:updateListUI(arg_19_0.vars.dlg, arg_19_0.vars.legacy_list)
	if_set_visible(arg_19_0.vars.dlg, "btn_confirm", not arg_19_0.vars.is_start_legacy_select)
	if_set_visible(arg_19_0.vars.dlg, "btn_cancel", not arg_19_0.vars.is_start_legacy_select)
	if_set_visible(arg_19_0.vars.dlg, "btn_my_legacy", not arg_19_0.vars.is_start_legacy_select)
	if_set_visible(arg_19_0.vars.dlg, "n_starting", arg_19_0.vars.is_start_legacy_select)
	
	if arg_19_0.vars.is_start_legacy_select then
		local var_19_0 = arg_19_0.vars.dlg:findChildByName("btn_refresh")
		
		if_set(var_19_0, "label", T("btn_clanheritage_legacy_refresh", {
			count1 = 1,
			count = LotaUserData:getStartLegacyRefreshCount()
		}))
		
		local var_19_1 = cc.c3b(255, 255, 255)
		
		if LotaUserData:getStartLegacyRefreshCount() > 0 then
			var_19_1 = cc.c3b(76, 76, 76)
		end
		
		if_set_color(var_19_0, nil, var_19_1)
	end
end

function LotaLegacySelectUI.updateSelectableArtifacts(arg_20_0, arg_20_1)
	arg_20_0.vars.legacy_list = arg_20_1
	
	if arg_20_0.vars.select_idx then
		arg_20_0:onDeselect(arg_20_0.vars.select_idx)
	end
	
	arg_20_0.vars.select_idx = nil
	
	arg_20_0:buildUI()
end
