ExclusiveRecallPopup = {}

function HANDLER.recall_choose_private_op(arg_1_0, arg_1_1, arg_1_2)
	if string.starts(arg_1_1, "btn_select") then
		ExclusiveRecallPopup:selectSkill(tonumber(string.sub(arg_1_1, -1, -1)))
	elseif arg_1_1 == "btn_complete" then
		ExclusiveRecallPopup:openRecallConfirmPopup()
	elseif arg_1_1 == "btn_cancel" then
		ExclusiveRecallPopup:closeExclusiveRecallPopup()
	end
end

function HANDLER.recall_confirm_private_p(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == "btn_recall" then
		ExclusiveRecallPopup:req_RecallExclusiveEquip()
	elseif arg_2_1 == "btn_cancel" then
		ExclusiveRecallPopup:closeRecallConfirmPopup()
	end
end

function MsgHandler.exchange_equip(arg_3_0)
	ExclusiveRecallPopup:res_recallExclusiveEquip(arg_3_0)
end

function ExclusiveRecallPopup.openExclusiveRecallPopup(arg_4_0)
	if not InventoryPopupDetail.vars or not get_cocos_refid(InventoryPopupDetail.vars.dlg) or not InventoryPopupDetail:getEquip() then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.equip = InventoryPopupDetail:getEquip()
	arg_4_0.vars.wnd = load_dlg("recall_choose_private_op", true, "wnd", function()
		ExclusiveRecallPopup:closeExclusiveRecallPopup()
	end)
	
	local var_4_0 = load_dlg("recall_choose_private_card", true, "wnd")
	
	arg_4_0.vars.wnd:getChildByName("n_detail_card"):addChild(var_4_0)
	var_4_0:setPosition(0, 0)
	var_4_0:setAnchorPoint(0, 0)
	SceneManager:getRunningPopupScene():addChild(arg_4_0.vars.wnd)
	EffectManager:Play({
		fn = "ui_town_alchemy_bg_effect2.cfx",
		layer = var_4_0:getChildByName("bg_effect")
	})
	
	local var_4_1 = UIUtil:getRewardIcon(nil, arg_4_0.vars.equip.code, {
		no_popup = true,
		scale = 1,
		no_tooltip = true,
		parent = var_4_0:getChildByName("n_item_bg")
	})
	
	if_set(var_4_0, "txt_name_item", arg_4_0.vars.equip:getName())
	
	local var_4_2, var_4_3, var_4_4, var_4_5 = arg_4_0.vars.equip:getMainStat()
	local var_4_6 = false
	
	if UNIT.is_percentage_stat(var_4_3) then
		var_4_2 = to_var_str(var_4_2, var_4_3)
		
		local var_4_7 = true
	else
		var_4_2 = comma_value(math.floor(var_4_2))
	end
	
	if_set(var_4_0, "txt_main_name", T(var_4_3))
	if_set(var_4_0, "txt_main_stat", var_4_2)
	SpriteCache:resetSprite(var_4_0:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_4_3, "_rate", "") .. ".png")
	
	arg_4_0.vars.curSkillIdx = arg_4_0.vars.equip.op[2][2]
	arg_4_0.vars.exclusive_unit = arg_4_0.vars.equip.db.exclusive_unit
	arg_4_0.vars.exclusive_skill = arg_4_0.vars.equip.db.exclusive_skill
	arg_4_0.vars.cur_unit = UNIT:create({
		z = 6,
		code = arg_4_0.vars.exclusive_unit
	})
	
	for iter_4_0 = 1, 3 do
		local var_4_8 = arg_4_0.vars.wnd:getChildByName("n_" .. iter_4_0)
		
		if not get_cocos_refid(var_4_8) then
			break
		end
		
		local var_4_9 = arg_4_0.vars.wnd:getChildByName("btn_select_" .. iter_4_0)
		
		if_set_enabled(arg_4_0.vars.wnd, "btn_select_" .. iter_4_0, iter_4_0 ~= arg_4_0.vars.curSkillIdx)
		if_set_opacity(var_4_8, nil, iter_4_0 ~= arg_4_0.vars.curSkillIdx and 255 or 76.5)
		
		local var_4_10, var_4_11 = DB("skill_equip", arg_4_0.vars.exclusive_skill .. "_0" .. iter_4_0, {
			"exc_number",
			"exc_desc"
		})
		local var_4_12 = UIUtil:getSkillIcon(arg_4_0.vars.cur_unit, var_4_10, {
			notMyUnit = true,
			no_tooltip = true
		})
		
		if_set_visible(var_4_12, "soul1", false)
		
		local var_4_13 = var_4_8:getChildByName("n_icon_" .. iter_4_0)
		
		if get_cocos_refid(var_4_13) then
			var_4_13:addChild(var_4_12)
		end
		
		local var_4_14 = UIUtil:getSkillByUIIdx(arg_4_0.vars.cur_unit, var_4_10)
		local var_4_15 = DB("skill", var_4_14, "name")
		
		if_set_scale_fit_width_long_word(var_4_8, "txt_name_" .. iter_4_0, T(var_4_15), 450)
		if_set_visible(var_4_12, "exclusive", true)
		
		local var_4_16 = var_4_8:getChildByName("txt_desc_" .. iter_4_0)
		local var_4_17 = upgradeLabelToRichLabel(var_4_8, "txt_desc_" .. iter_4_0)
		
		if_set(var_4_17, nil, T(var_4_11))
		var_4_17:formatText()
	end
	
	arg_4_0.vars.selectedIdx = 0
	
	arg_4_0:selectSkill(0)
end

function ExclusiveRecallPopup.selectSkill(arg_6_0, arg_6_1)
	if arg_6_1 == arg_6_0.vars.curSkillIdx then
		return 
	end
	
	arg_6_0.vars.selectedIdx = arg_6_1
	
	for iter_6_0 = 1, 3 do
		local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_" .. iter_6_0)
		
		if not get_cocos_refid(var_6_0) then
			break
		end
		
		if_set_visible(var_6_0, "selected_" .. iter_6_0, iter_6_0 == arg_6_1)
	end
	
	if_set_opacity(arg_6_0.vars.wnd, "btn_complete", arg_6_0.vars.selectedIdx == 0 and 76.5 or 255)
end

function ExclusiveRecallPopup.openRecallConfirmPopup(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) or arg_7_0.vars.selectedIdx == 0 or arg_7_0.vars.selectedIdx == arg_7_0.vars.curSkillIdx then
		return 
	end
	
	arg_7_0.vars.confirmPopup = load_dlg("recall_confirm_private_p", true, "wnd", function()
		ExclusiveRecallPopup:closeRecallConfirmPopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_7_0.vars.confirmPopup)
	
	local var_7_0 = arg_7_0.vars.confirmPopup:getChildByName("n_before")
	local var_7_1 = arg_7_0.vars.confirmPopup:getChildByName("n_after")
	local var_7_2 = arg_7_0.vars.curSkillIdx
	local var_7_3 = arg_7_0.vars.selectedIdx
	local var_7_4, var_7_5 = DB("skill_equip", arg_7_0.vars.exclusive_skill .. "_0" .. var_7_2, {
		"exc_number",
		"exc_desc"
	})
	local var_7_6 = UIUtil:getSkillIcon(arg_7_0.vars.cur_unit, var_7_4, {
		notMyUnit = true,
		no_tooltip = true
	})
	
	if_set_visible(var_7_6, "soul1", false)
	
	local var_7_7 = UIUtil:getSkillByUIIdx(arg_7_0.vars.cur_unit, var_7_4)
	local var_7_8 = DB("skill", var_7_7, "name")
	
	if_set_scale_fit_width_long_word(var_7_0, "txt_name", T(var_7_8), 450)
	
	local var_7_9 = var_7_0:getChildByName("n_icon")
	
	if get_cocos_refid(var_7_9) then
		var_7_9:addChild(var_7_6)
	end
	
	if_set_visible(var_7_6, "exclusive", true)
	
	local var_7_10 = var_7_0:getChildByName("txt_desc")
	local var_7_11 = upgradeLabelToRichLabel(var_7_0, "txt_desc")
	
	if_set(var_7_11, nil, T(var_7_5))
	var_7_11:formatText()
	
	local var_7_12, var_7_13 = DB("skill_equip", arg_7_0.vars.exclusive_skill .. "_0" .. var_7_3, {
		"exc_number",
		"exc_desc"
	})
	local var_7_14 = UIUtil:getSkillIcon(arg_7_0.vars.cur_unit, var_7_12, {
		notMyUnit = true,
		no_tooltip = true
	})
	
	if_set_visible(var_7_14, "soul1", false)
	
	local var_7_15 = UIUtil:getSkillByUIIdx(arg_7_0.vars.cur_unit, var_7_12)
	local var_7_16 = DB("skill", var_7_15, "name")
	
	if_set_scale_fit_width_long_word(var_7_1, "txt_name", T(var_7_16), 450)
	
	local var_7_17 = var_7_1:getChildByName("n_icon")
	
	if get_cocos_refid(var_7_17) then
		var_7_17:addChild(var_7_14)
	end
	
	if_set_visible(var_7_14, "exclusive", true)
	
	local var_7_18 = var_7_1:getChildByName("txt_desc")
	local var_7_19 = upgradeLabelToRichLabel(var_7_1, "txt_desc")
	
	if_set(var_7_19, nil, T(var_7_13))
	var_7_19:formatText()
end

function ExclusiveRecallPopup.req_RecallExclusiveEquip(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) or arg_9_0.vars.selectedIdx == 0 or arg_9_0.vars.selectedIdx == arg_9_0.vars.curSkillIdx then
		return 
	end
	
	query("exchange_equip", {
		id = Account:getUserId(),
		equip_id = arg_9_0.vars.equip:getUID(),
		skill_equip_id = arg_9_0.vars.exclusive_skill .. "_0" .. arg_9_0.vars.selectedIdx
	})
end

function ExclusiveRecallPopup.res_recallExclusiveEquip(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return 
	end
	
	if arg_10_1.err then
		balloon_message_with_sound(arg_10_1.err)
		
		return 
	end
	
	if arg_10_1.recall_info then
		AccountData.recall_info = arg_10_1.recall_info
	end
	
	arg_10_0:closeRecallConfirmPopup()
	arg_10_0:closeExclusiveRecallPopup()
	InventoryPopupDetail:Close()
	
	if arg_10_1.recall_info then
		AccountData.recall_info = arg_10_1.recall_info
	end
	
	if arg_10_1.updated_equip then
		local var_10_0 = Account:getEquip(arg_10_1.updated_equip.id)
		
		if var_10_0 then
			var_10_0.exp = arg_10_1.updated_equip.e or 0
			var_10_0.op = arg_10_1.updated_equip.op
			var_10_0.dup_pt = arg_10_1.updated_equip.sk or 0
			
			var_10_0:update()
			
			if var_10_0.parent then
				local var_10_1 = Account:getUnit(var_10_0.parent)
				
				if var_10_1 then
					var_10_1:removeEquip(var_10_0)
				end
			end
		end
	end
	
	if arg_10_1.rewards then
		Account:addReward(arg_10_1.rewards)
	end
	
	Dialog:msgBox(T("exc_change_complete"), {
		handler = function()
			SceneManager:nextScene("lobby")
		end,
		title = T("exc_change_done")
	})
end

function ExclusiveRecallPopup.closeRecallConfirmPopup(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.confirmPopup) then
		return 
	end
	
	arg_12_0.vars.confirmPopup:removeFromParent()
	BackButtonManager:pop("recall_confirm_private_p")
end

function ExclusiveRecallPopup.closeExclusiveRecallPopup(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("recall_choose_private_op")
	arg_13_0.vars.wnd:removeFromParent()
	
	arg_13_0.vars = nil
end
