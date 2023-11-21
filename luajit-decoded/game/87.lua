GrowthGuideInfo = {}

function HANDLER.growth_guide_unlocked(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ignore" then
		GrowthGuideInfo:closeUnlockGroupDialog()
	end
end

function HANDLER.growth_guide_fin(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_ignore" then
		GrowthGuideInfo:closeFinishDialog()
		SceneManager:nextScene("lobby")
	end
end

function GrowthGuideInfo.setPortrait(arg_3_0, arg_3_1)
	if not get_cocos_refid(arg_3_1) then
		return 
	end
	
	local var_3_0 = arg_3_1:getChildByName("n_portrait")
	
	if not get_cocos_refid(var_3_0) then
		return 
	end
	
	local var_3_1 = DB("character", "npc1003", "face_id") or "no_image"
	local var_3_2 = UIUtil:getPortraitAni(var_3_1, {
		pin_sprite_position_y = true
	})
	
	if not get_cocos_refid(var_3_2) then
		return 
	end
	
	var_3_2:setScale(1)
	var_3_2:setAnchorPoint(0.5, 0)
	var_3_0:removeAllChildren()
	var_3_0:addChild(var_3_2)
end

function GrowthGuideInfo.openFinishDialog(arg_4_0)
	arg_4_0:closeFinishDialog()
	
	arg_4_0.finish_dialog = load_dlg("growth_guide_fin", true, "wnd", function()
		arg_4_0:closeFinishDialog()
	end)
	
	SceneManager:getRunningUIScene():addChild(arg_4_0.finish_dialog)
	arg_4_0.finish_dialog:bringToFront()
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		layer = arg_4_0.finish_dialog:getChildByName("n_show_eff")
	})
	arg_4_0:setPortrait(arg_4_0.finish_dialog)
end

function GrowthGuideInfo.closeFinishDialog(arg_6_0)
	if not get_cocos_refid(arg_6_0.finish_dialog) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_6_0.finish_dialog, "block")
	BackButtonManager:pop("growth_guide_fin")
	
	arg_6_0.finish_dialog = nil
end

function GrowthGuideInfo.openUnlockGroupDialog(arg_7_0, arg_7_1)
	arg_7_0:closeUnlockGroupDialog()
	
	arg_7_0.unlock_group_dialog = load_dlg("growth_guide_unlocked", true, "wnd", function()
		arg_7_0:closeUnlockGroupDialog()
	end)
	
	SceneManager:getRunningUIScene():addChild(arg_7_0.unlock_group_dialog)
	arg_7_0.unlock_group_dialog:bringToFront()
	EffectManager:Play({
		fn = "growth_guide_unlock.cfx",
		layer = arg_7_0.unlock_group_dialog:getChildByName("n_show_eff")
	})
	arg_7_0:setPortrait(arg_7_0.unlock_group_dialog)
	
	local var_7_0 = GrowthGuide:getGroupDB(arg_7_1)
	
	if not var_7_0 then
		Log.e("Invalid unlock_group_id", arg_7_1)
		
		return 
	end
	
	if_set_sprite(arg_7_0.unlock_group_dialog, "emblem", var_7_0.group_icon)
	if_set(arg_7_0.unlock_group_dialog, "txt_desc", T("guidequest_group_unlock_title", {
		guidequest_group_name = T(var_7_0.group_name)
	}))
	if_set_arrow(arg_7_0.unlock_group_dialog)
	GrowthGuide:setIsOpenedUnlockGroupDialog(arg_7_1, true)
end

function GrowthGuideInfo.closeUnlockGroupDialog(arg_9_0)
	if not get_cocos_refid(arg_9_0.unlock_group_dialog) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), CALL(function()
		BackButtonManager:pop({
			check_id = "growth_guide_unlocked",
			dlg = arg_9_0.unlock_group_dialog
		})
	end), REMOVE(), CALL(function()
		if not arg_9_0:procUnlock() then
			SAVE:sendQueryServerConfig()
		end
	end)), arg_9_0.unlock_group_dialog, "block")
end

function GrowthGuideInfo.procUnlock(arg_12_0)
	if get_cocos_refid(arg_12_0.unlock_group_dialog) then
		return 
	end
	
	local var_12_0 = false
	local var_12_1, var_12_2 = GrowthGuide:getGroupDB()
	
	for iter_12_0, iter_12_1 in pairs(var_12_2) do
		if not GrowthGuide:isOpenedUnlockGroupDialog(iter_12_1.group_id) and not GrowthGuide:isGroupLocked(iter_12_1) then
			arg_12_0:openUnlockGroupDialog(iter_12_1.group_id)
			
			var_12_0 = true
		end
	end
	
	if var_12_0 then
		BackPlayManager:forceStopPlay("growthguide")
		
		local var_12_3 = ConditionContentsManager:getGrowthGuideQuest()
		
		if var_12_3 then
			var_12_3:initConditionListner()
		end
	end
	
	return var_12_0
end
