SanctuaryMain = SanctuaryMain or {}
SanctuaryMain.MODE_LIST = {
	Main = SanctuaryMain
}
SanctuaryArchemist = {}

function HANDLER.sanctuary(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	UIUtil:checkBtnTouchPos(arg_1_0, arg_1_3, arg_1_4)
	
	if arg_1_1 == "btn_collect_orbis" then
		SanctuaryMain:collectOrbis()
		
		return 
	end
	
	if arg_1_1 == "btn_upgrade" then
		SanctuaryMain:ToggleUpgradeMode()
		TutorialGuide:procGuide("system_068")
		TutorialGuide:procGuide("system_069")
		TutorialGuide:procGuide("system_070")
		TutorialGuide:procGuide("system_071")
		TutorialGuide:procGuide("sanctuary_start")
		
		return 
	end
	
	if arg_1_1 == "check_box" then
		SanctuaryMain:showBuildingLevel(arg_1_0:isSelected())
		
		return 
	end
	
	local var_1_0
	
	if string.starts(arg_1_1, "mode_") then
		var_1_0 = string.sub(arg_1_1, 6, -1)
	end
	
	if var_1_0 then
		SanctuaryMain:setMode(var_1_0)
	end
end

function HANDLER.sanctuary_upgrade(arg_2_0, arg_2_1)
	if string.starts(arg_2_1, "btn_upgrade") then
		SanctuaryMain:confirmUpgrade(tonumber(string.sub(arg_2_1, -1, -1)))
		TutorialGuide:procGuide()
		
		return 
	end
	
	if string.starts(arg_2_1, "btn_reset") then
		SanctuaryMain:confirmReset(tonumber(string.sub(arg_2_1, -1, -1)))
		
		return 
	end
	
	if string.starts(arg_2_1, "btn_info") then
		SanctuaryMain:showBuildingDetail(tonumber(string.sub(arg_2_1, -1, -1)))
		
		return 
	end
end

function HANDLER.sanctuary_preview(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		SanctuaryMain:closeBuildingDetail()
		
		return 
	end
	
	if string.starts(arg_3_1, "btn_lv") then
		SanctuaryMain:showBuildingDetail(nil, tonumber(string.sub(arg_3_1, -1, -1)))
	end
end

function MsgHandler.sanctuary_change(arg_4_0)
	SanctuaryMain:onChangeUpgrade(arg_4_0)
end

function SanctuaryMain.open(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_1.mode = arg_5_1.mode or "Main"
	arg_5_0.vars.wnd = load_dlg("sanctuary", true, "wnd")
	arg_5_0.vars.parent = arg_5_1.parent or SceneManager:getDefaultLayer()
	
	arg_5_0.vars.parent:addChild(arg_5_0.vars.wnd)
	
	arg_5_0.vars.content_layer = arg_5_0.vars.parent:getChildByName("n_content")
	arg_5_0.vars.ui_layer = arg_5_0.vars.wnd:getChildByName("n_ui")
	
	if_set_visible(arg_5_0.vars.wnd, "n_base", false)
	
	local var_5_0 = arg_5_1.mode ~= "Main"
	
	arg_5_0:createBackground(var_5_0)
	TopBarNew:create(T("sanc_main"), arg_5_0.vars.wnd, function()
		SanctuaryMain:onPushBackButton()
	end, {
		"crystal",
		"gold",
		"stone"
	}, nil, "sanc_main")
	
	if arg_5_1.mode ~= "Orbis" then
		SanctuaryOrbis:UpdateOrbis()
	end
	
	Scheduler:addSlow(arg_5_0.vars.wnd, arg_5_0.update, arg_5_0)
	
	if arg_5_1.mode == "Main" then
		arg_5_0.vars.mode = "Main"
		
		arg_5_0:onEnter(arg_5_0.vars.content_layer, nil, true)
		arg_5_0:update()
		SoundEngine:play("event:/ui/main_hud/btn_town")
	else
		arg_5_0:onLeave(arg_5_1.mode, true)
		arg_5_0:setMode(arg_5_1.mode, arg_5_1)
	end
	
	arg_5_0:show_recommend_noti()
end

function SanctuaryMain.onPushBackButton(arg_7_0)
	if arg_7_0.vars.upgrade_wnd then
		arg_7_0:ToggleUpgradeMode()
		
		if arg_7_0:GetLevels("Forest")[2] >= 1 and arg_7_0.vars.mode == "Forest" then
			TutorialGuide:ifStartGuide("system_068_new")
		end
		
		return 
	end
	
	if arg_7_0.vars.mode == "Main" then
		arg_7_0:onExit()
	else
		local var_7_0 = arg_7_0.MODE_LIST[arg_7_0.vars.mode]
		
		if var_7_0.onPushBackButton then
			var_7_0:onPushBackButton(var_7_0)
		else
			arg_7_0:setMode("Main")
		end
	end
end

function SanctuaryMain.playUnlockEffect(arg_8_0, arg_8_1)
	local var_8_0 = cc.c3b(255, 255, 255)
	
	set_high_fps_tick(4000)
	;(function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.modes) do
			local var_9_0 = iter_9_1.obj:getChildByName(iter_9_1.tag .. "_model")
			
			if var_9_0 and get_cocos_refid(var_9_0) and iter_9_1.tag ~= arg_9_4 then
				UIAction:Add(SEQ(BLEND(600, "black", 0, 0.5), DELAY(3333), BLEND(1000, "black", 0.5, 0)), var_9_0, "block")
			end
		end
		
		for iter_9_2, iter_9_3 in pairs(arg_9_0.vars.childs) do
			UIAction:Add(SEQ(BLEND(600, "black", 0, 0.5), DELAY(3333), BLEND(1000, "black", 0.5, 0)), iter_9_3.obj, "block")
		end
	end)(arg_8_0, 70, 70, 70, arg_8_1)
	
	local var_8_1 = arg_8_0.vars.modes[arg_8_1].obj
	local var_8_2 = arg_8_0.vars.wnd:getChildByName(arg_8_1)
	local var_8_3 = var_8_2:getChildByName("icon_locked")
	local var_8_4 = var_8_2:getChildByName("bg")
	local var_8_5 = var_8_2:getChildByName("t_title")
	
	var_8_3:setVisible(true)
	var_8_4:setOpacity(90)
	var_8_5:setOpacity(90)
	EffectManager:Play({
		fn = "ui_sanctuary_unlock.cfx",
		layer = var_8_2
	})
	UIAction:Add(SEQ(DELAY(2000), TARGET(var_8_3, SHOW(false)), TARGET(var_8_4, OPACITY(0, 0.3, 1)), TARGET(var_8_5, OPACITY(0, 0.3, 1))), var_8_2, "block")
end

function SanctuaryMain.onEnter(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("n_glow")
	
	if arg_10_3 then
		if_set_visible(arg_10_0.vars.wnd, "n_base", false)
		if_set_visible(arg_10_0.vars.wnd, "n_bg", true)
		var_10_0:setOpacity(0)
	else
		UIAction:Add(SEQ(FADE_OUT(300), SHOW(false)), arg_10_0.vars.wnd:getChildByName("n_base"), "block")
		
		if not arg_10_4 then
			UIAction:Add(SEQ(SHOW(true), FADE_IN(300)), arg_10_0.vars.wnd:getChildByName("n_bg"), "block")
		end
		
		UIAction:Add(SEQ(OPACITY(300, 0.5, 0)), var_10_0, "block")
	end
	
	show_ani(arg_10_0.vars.parent:getChildByName("n_ui"), true)
	arg_10_0.vars.parent:getChildByName("n_upgrade_bar"):setVisible(false)
	TutorialGuide:procGuide("system_068")
	TutorialGuide:procGuide("system_069")
	TutorialGuide:procGuide("system_126")
	TutorialGuide:ifStartGuide("sanctuary_start")
end

function SanctuaryMain.onLeave(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.vars.wnd:getChildByName("n_base")
	local var_11_1 = arg_11_0.vars.wnd:getChildByName("n_glow")
	
	var_11_0:setVisible(true)
	var_11_0:setOpacity(255)
	
	if arg_11_2 then
		if_set_visible(arg_11_0.vars.wnd, "n_bg", false)
		var_11_1:setOpacity(120)
	else
		UIAction:Add(SEQ(FADE_OUT(300), SHOW(false)), arg_11_0.vars.wnd:getChildByName("n_bg"), "block")
		UIAction:Add(SEQ(OPACITY(300, 0, 0.5)), var_11_1, "block")
	end
	
	show_ani(arg_11_0.vars.parent:getChildByName("n_ui"), false)
	show_ani(arg_11_0.vars.parent:getChildByName("n_upgrade_bar"), true)
end

function SanctuaryMain.showUpgradeBar(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.parent) then
		return 
	end
	
	if_set_visible(arg_12_0.vars.parent, "n_upgrade_bar", arg_12_1)
end

function SanctuaryMain.setMode(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.vars.mode
	
	if var_13_0 == arg_13_1 then
		return 
	end
	
	if arg_13_1 ~= "Main" then
		local var_13_1 = DB("sanctuary_upgrade", string.lower(arg_13_1) .. "_0_0", "system")
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = var_13_1
		}, function()
			arg_13_0:enterMode(var_13_0, arg_13_1, arg_13_2)
		end)
		
		return 
	end
	
	arg_13_0:enterMode(var_13_0, arg_13_1)
end

function SanctuaryMain.getMode(arg_15_0)
	if not arg_15_0.vars then
		return nil
	end
	
	return arg_15_0.vars.mode
end

function SanctuaryMain.enterMode(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_1 and arg_16_0.MODE_LIST[arg_16_1] and arg_16_0.MODE_LIST[arg_16_1].onLeave then
		BackButtonManager:pop("SanctuaryMain." .. arg_16_1)
		Analytics:saveCurTabTime()
		arg_16_0.MODE_LIST[arg_16_1]:onLeave(arg_16_2)
	end
	
	BackButtonManager:push({
		back_func = function()
			arg_16_0:onPushBackButton()
		end,
		check_id = "SanctuaryMain." .. arg_16_2
	})
	
	if arg_16_0.MODE_LIST[arg_16_2] and arg_16_0.MODE_LIST[arg_16_2].onEnter then
		arg_16_0.MODE_LIST[arg_16_2]:onEnter(arg_16_0.vars.content_layer, arg_16_1)
		
		if arg_16_2 ~= "Main" then
			Analytics:setMode(arg_16_2)
		end
		
		if arg_16_2 == "Orbis" then
			if SanctuaryMain:GetSumLevels("Orbis") == 0 then
				TutorialGuide:procGuide("sanctuary_start")
			end
		elseif arg_16_2 == "Forest" then
			if SanctuaryMain:GetSumLevels("Forest") == 0 then
				TutorialGuide:ifStartGuide("system_068")
			else
				TutorialGuide:forceClearTutorials({
					"system_068"
				})
			end
		elseif arg_16_2 == "SubTask" then
			if SanctuaryMain:GetSumLevels("SubTask") == 0 then
				TutorialGuide:ifStartGuide("system_069")
			else
				TutorialGuide:forceClearTutorials({
					"system_069"
				})
			end
		elseif arg_16_2 == "Craft" then
			if SanctuaryMain:GetSumLevels("Craft") == 0 then
				TutorialGuide:ifStartGuide("system_070")
			elseif not TutorialGuide:ifStartGuide("item_reforge") and not TutorialGuide:isClearedTutorial("system_070") then
				TutorialGuide:forceClearTutorials({
					"system_070"
				})
			end
		elseif arg_16_2 == "Archemist" then
			if SanctuaryMain:GetSumLevels("Archemist") == 0 then
				TutorialGuide:ifStartGuide("system_071")
			else
				TutorialGuide:forceClearTutorials({
					"system_071"
				})
			end
		end
	end
	
	arg_16_0.vars.mode = arg_16_2
	
	if arg_16_2 ~= "Main" then
		arg_16_0:updateUpgradeBar()
	end
	
	TopBarNew:setTitleName(T("sanc_" .. string.lower(arg_16_2)), "sanc_" .. string.lower(arg_16_2))
	
	if not TutorialGuide:isPlayingTutorial() and arg_16_3 and arg_16_0.MODE_LIST[arg_16_2] and arg_16_0.MODE_LIST[arg_16_2].procArgs then
		arg_16_0.MODE_LIST[arg_16_2]:procArgs(arg_16_3)
	end
end

function SanctuaryMain.CheckNotification(arg_18_0)
	if TutorialCondition:isEnable("sanctuary_start") then
		return true
	end
	
	return #arg_18_0:GetNotificationNodes() > 0
end

function SanctuaryMain.GetNotificationNodes(arg_19_0)
	local var_19_0 = {
		"Orbis",
		"Forest",
		"SubTask",
		"Craft",
		"Archemist"
	}
	local var_19_1 = {}
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		local var_19_2 = arg_19_0.MODE_LIST[iter_19_1]
		local var_19_3 = var_19_2.CheckNotification
		
		if var_19_3 and var_19_3(var_19_2) then
			table.push(var_19_1, iter_19_1)
		end
	end
	
	return var_19_1
end

function SanctuaryMain.update(arg_20_0)
	local var_20_0 = arg_20_0:GetNotificationNodes()
	
	if arg_20_0.vars then
		for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.modes) do
			local var_20_1 = arg_20_0.vars.wnd:getChildByName(iter_20_1.tag)
			local var_20_2 = table.find(var_20_0, iter_20_1.tag) ~= nil
			
			if_set_visible(var_20_1, "icon_noti", var_20_2)
			
			if iter_20_1.tag == "Orbis" then
				local var_20_3, var_20_4, var_20_5 = SanctuaryOrbis:CheckCollect()
				
				if_set_visible(arg_20_0.vars.wnd, "btn_collect_orbis", var_20_3)
				if_set(arg_20_0.vars.wnd, "t_orbis_count1", comma_value(var_20_4))
				if_set(arg_20_0.vars.wnd, "t_orbis_count2", comma_value(var_20_5))
			end
			
			if iter_20_1.tag == "Craft" then
				local var_20_6, var_20_7 = EquipCraftEventUtil:findScheduleByAccountData()
				
				if_set_visible(var_20_1, "badge_event", var_20_6 ~= nil)
				
				if var_20_7 then
					local var_20_8 = EquipCraftEventUtil:getRemainTimeBase(var_20_6, var_20_7)
					
					EquipCraftEventUtil:updateTimeTooltip(var_20_1:findChildByName("cm_time_tooltip"), var_20_8)
				else
					if_set_visible(var_20_1, "cm_time_tooltip", false)
				end
			end
			
			local var_20_9 = SanctuaryMain:get_recommend_info()
			
			if var_20_9 then
				local var_20_10 = var_20_9.mode or ""
				
				if not var_20_9.building then
					local var_20_11 = 1
				end
				
				if not var_20_9.level then
					local var_20_12 = 1
				end
				
				if var_20_10 == iter_20_1.tag then
					if_set_visible(var_20_1, "n_improve", true)
				else
					if_set_visible(var_20_1, "n_improve", false)
				end
			else
				if_set_visible(var_20_1, "n_improve", false)
			end
		end
		
		UIAction:Add(SEQ(DELAY(900), CALL(function()
			TutorialNotice:update("sanctuary")
		end)), "delay")
	end
end

function SanctuaryMain.updateUpgradeBar(arg_22_0)
	if arg_22_0.vars.mode == "Main" then
		return 
	end
	
	local var_22_0 = arg_22_0:GetLevels()
	local var_22_1 = arg_22_0.vars.wnd:getChildByName("n_upgrade_bar")
	local var_22_2 = var_22_1:getChildByName("n_state")
	
	if_set(var_22_1, "t_lv1", var_22_0[1])
	if_set(var_22_1, "t_lv2", var_22_0[2])
	if_set(var_22_1, "t_lv3", var_22_0[3])
	if_set_visible(var_22_1, "noti_upgrade", Account:getCurrency("stone") > 0 and arg_22_0:GetTotalLevel() < 9)
	if_set_visible(var_22_1, "n_improve", false)
	
	local var_22_3 = SanctuaryMain:get_recommend_info()
	
	if var_22_3 then
		local var_22_4 = var_22_3.mode or ""
		
		if not var_22_3.building then
			local var_22_5 = 1
		end
		
		if not var_22_3.level then
			local var_22_6 = 1
		end
		
		if arg_22_0.vars.mode == var_22_4 then
			if_set_visible(var_22_1, "n_improve", true)
			
			if var_22_2 then
				if not var_22_2.origin_x then
					var_22_2.origin_x = var_22_2:getPositionX()
				end
				
				var_22_2:setPositionX(var_22_2.origin_x + 28)
			end
		elseif var_22_2 and var_22_2.origin_x then
			var_22_2:setPositionX(var_22_2.origin_x)
		end
	end
end

function SanctuaryMain.GetTotalLevel(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = 0
	
	arg_23_2 = arg_23_0:GetLevels(arg_23_1, arg_23_2)
	
	for iter_23_0, iter_23_1 in pairs(arg_23_2) do
		var_23_0 = var_23_0 + to_n(iter_23_1)
	end
	
	return var_23_0
end

function SanctuaryMain.GetLevels(arg_24_0, arg_24_1, arg_24_2)
	arg_24_1 = arg_24_1 or arg_24_0.vars.mode
	arg_24_2 = arg_24_2 or AccountData.sanc_lv or {}
	
	local var_24_0
	
	if arg_24_1 == "Orbis" then
		var_24_0 = arg_24_2[1]
	elseif arg_24_1 == "Forest" then
		var_24_0 = arg_24_2[2]
	elseif arg_24_1 == "SubTask" then
		var_24_0 = arg_24_2[3]
	elseif arg_24_1 == "Craft" then
		var_24_0 = arg_24_2[4]
	elseif arg_24_1 == "Archemist" then
		var_24_0 = arg_24_2[5]
	end
	
	var_24_0 = var_24_0 or {}
	var_24_0[1] = var_24_0[1] or 0
	var_24_0[2] = var_24_0[2] or 0
	var_24_0[3] = var_24_0[3] or 0
	
	return var_24_0
end

function SanctuaryMain.GetSumLevels(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:GetLevels(arg_25_1)
	
	return var_25_0[1] + var_25_0[2] + var_25_0[3]
end

function SanctuaryMain.ToggleUpgradeMode(arg_26_0, arg_26_1)
	if SanctuaryForest:isShowPopUp() then
		return 
	end
	
	if arg_26_0.vars.upgrade_wnd then
		arg_26_0:closeBuildingDetail()
		show_ani(arg_26_0.vars.wnd:getChildByName("n_content"), true, {
			tm = 200
		})
		show_ani(arg_26_0.vars.wnd:getChildByName("n_upgrade_bar"), true, {
			tm = 200
		})
		
		for iter_26_0 = 0, 2 do
			local var_26_0 = arg_26_0.vars.upgrade_wnd:getChildByName(tostring(iter_26_0))
			
			UIAction:Add(SEQ(DELAY(iter_26_0 * 80), SPAWN(FADE_OUT(230), SEQ(RLOG(MOVE_TO(230, (3 - iter_26_0) * 500), 150), DELAY(200), TARGET(arg_26_0.vars.upgrade_wnd, REMOVE())))), var_26_0, "block")
		end
		
		BackButtonManager:pop("sanctuary_upgrade")
		
		arg_26_0.vars.upgrade_wnd = nil
		
		return 
	end
	
	show_ani(arg_26_0.vars.wnd:getChildByName("n_content"), false, {
		tm = 200
	})
	show_ani(arg_26_0.vars.wnd:getChildByName("n_upgrade_bar"), false, {
		tm = 200
	})
	
	arg_26_0.vars.upgrade_wnd = load_dlg("sanctuary_upgrade", true, "wnd", function()
		arg_26_0:onPushBackButton()
	end)
	
	for iter_26_1 = 0, 2 do
		local var_26_1 = arg_26_0.vars.upgrade_wnd:getChildByName(tostring(iter_26_1))
		
		upgradeLabelToRichLabel(var_26_1, "txt_desc")
		
		local var_26_2 = var_26_1:getChildByName("txt_desc")
		
		if get_cocos_refid(var_26_2) and var_26_2.setAlignment then
			var_26_2:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
		end
	end
	
	for iter_26_2 = 0, 2 do
		local var_26_3 = arg_26_0.vars.upgrade_wnd:getChildByName(tostring(iter_26_2))
		
		var_26_3:setOpacity(0)
		var_26_3:setPositionX(0 - (iter_26_2 + 1) * 600)
		UIAction:Add(SEQ(DELAY(iter_26_2 * 100), SPAWN(FADE_IN(260), LOG(MOVE_TO(260, 0), 150))), var_26_3, "block")
	end
	
	arg_26_0:updateUpgradeWindow(arg_26_0)
	arg_26_0.vars.wnd:getChildByName("n_upgrade"):addChild(arg_26_0.vars.upgrade_wnd)
	arg_26_0:playReqUpgradeEffect(arg_26_1)
	SoundEngine:play("event:/ui/menu/menu_2")
end

function SanctuaryMain.onChangeUpgrade(arg_28_0, arg_28_1)
	local var_28_0 = {}
	
	if arg_28_1.mode == "reset" then
		var_28_0.ignore_get_condition = true
	end
	
	Account:updateCurrencies(arg_28_1, var_28_0)
	TopBarNew:topbarUpdate(true)
	
	local var_28_1 = arg_28_0:GetLevels()
	
	AccountData.sanc_lv = arg_28_1.sanc_lv
	
	local var_28_2 = arg_28_0:GetLevels()
	local var_28_3
	local var_28_4
	
	for iter_28_0 = 1, 3 do
		if var_28_1[iter_28_0] < var_28_2[iter_28_0] then
			var_28_3 = iter_28_0
			var_28_4 = var_28_2[iter_28_0]
			
			break
		end
	end
	
	if var_28_3 then
		arg_28_0:procUpgrade_step1(arg_28_1, var_28_3, var_28_4)
	else
		arg_28_0:procUpgrade_step_fin(arg_28_1)
		arg_28_0:updateBuildings()
	end
	
	if SubTask:setMode("List") == false then
		SubTaskList:refresh()
	end
	
	if arg_28_0.vars.mode == "Archemist" then
		SanctuaryArchemist:updateAll()
		SanctuaryArchemistMain:updateUI()
	end
	
	if arg_28_0.vars.mode == "Craft" then
		SanctuaryCraftMain:updateUI()
	end
	
	if arg_28_1.forest_attributes then
		Account:setForestState(arg_28_1.forest_attributes)
		SanctuaryForest:updateUI()
		SanctuaryForest:updatePushNoti(true, LOCAL_PUSH_IDS.FOREST_PENGUIN)
		SanctuaryForest:updatePushNoti(true, LOCAL_PUSH_IDS.FOREST_SPIRIT)
	end
	
	if arg_28_0.vars.mode == "Forest" and var_28_1[3] ~= var_28_2[3] then
		SanctuaryForest:updatePushNoti(true, LOCAL_PUSH_IDS.FOREST_PENGUIN)
		SanctuaryForest:updatePushNoti(true, LOCAL_PUSH_IDS.FOREST_SPIRIT)
	end
	
	arg_28_0:stopReqUpgradeEffects()
	arg_28_0:update_recommend_noti_data()
end

function SanctuaryMain.procUpgrade_step1(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_3 == 1 then
		arg_29_0:procUpgrade_step2_building_effect(arg_29_1, arg_29_2, arg_29_3)
	else
		arg_29_0:procUpgrade_step2_ui_effect(arg_29_1, arg_29_2, arg_29_3)
	end
end

function SanctuaryMain.procUpgrade_step2_building_effect(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = 300
	local var_30_1 = 3800
	local var_30_2 = arg_30_0.vars.wnd:getChildByName("n_glow")
	local var_30_3 = arg_30_0.vars.wnd:getChildByName("n_content")
	local var_30_4 = arg_30_0.vars.wnd:getChildByName("n_base")
	local var_30_5 = arg_30_0.vars.wnd:getChildByName("n_upgrade")
	local var_30_6 = arg_30_0.vars.wnd:getChildByName("n_bg")
	
	local function var_30_7(arg_31_0, arg_31_1, arg_31_2)
		local var_31_0 = arg_31_0:getOpacity()
		
		UIAction:Add(SEQ(OPACITY(arg_31_1, var_31_0 / 255, 0), DELAY(arg_31_2), OPACITY(arg_31_1, 0, var_31_0 / 255)), arg_31_0, "block")
	end
	
	var_30_7(var_30_2, var_30_0, var_30_1)
	var_30_7(var_30_3, var_30_0, var_30_1)
	var_30_7(var_30_4, var_30_0, var_30_1)
	var_30_7(var_30_5, var_30_0, var_30_1)
	UIAction:Add(SEQ(OPACITY(0, 0, 2), SHOW(true), DELAY(var_30_1 + var_30_0 + var_30_0), SHOW(false), OPACITY(0, 0, 0)), var_30_6, "block")
	
	local var_30_8 = 667
	
	arg_30_0:updateBuildings()
	
	local var_30_9 = arg_30_0.vars.modes[arg_30_0:getMode()].obj.buildings[arg_30_2]
	
	var_30_9:setOpacity(0)
	UIAction:Add(SEQ(DELAY(var_30_8), LOG(OPACITY(500, 0, 1))), var_30_9, "block")
	EffectManager:Play({
		fn = "sanc_addon_eff.cfx",
		layer = var_30_9:getBoneNode("eff")
	})
	UIAction:Add(SEQ(DELAY(var_30_1 + var_30_0 + var_30_0), CALL(SanctuaryMain.procUpgrade_step_fin, arg_30_0, arg_30_1)), arg_30_0, "block")
end

function SanctuaryMain.procUpgrade_step2_ui_effect(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = {
		"yellow",
		"blue",
		"green"
	}
	
	EffectManager:Play({
		fn = "ui_sanctuary_upgrade_" .. var_32_0[arg_32_2] .. ".cfx",
		layer = arg_32_0.vars.upgrade_wnd:getChildByName(tostring(arg_32_2 - 1)):getChildByName("pos_upgrade_eff")
	})
	UIAction:Add(SEQ(DELAY(3000), CALL(SanctuaryMain.updateBuildings, arg_32_0), CALL(SanctuaryMain.procUpgrade_step_fin, arg_32_0, arg_32_1)), arg_32_0, "block")
end

function SanctuaryMain.procUpgrade_step_fin(arg_33_0, arg_33_1)
	arg_33_0:updateUpgradeWindow()
	arg_33_0:updateUpgradeBar()
	
	if arg_33_1.orbis_result then
		SanctuaryOrbis:onCollectOrbis(arg_33_1)
	end
	
	local var_33_0 = arg_33_0.MODE_LIST[arg_33_0.vars.mode]
	
	if var_33_0.onUpdateUpgrade then
		var_33_0:onUpdateUpgrade()
	end
end

function SanctuaryMain.updateUpgradeWindow(arg_34_0)
	local var_34_0 = arg_34_0:GetLevels()
	
	for iter_34_0 = 1, 3 do
		local var_34_1 = arg_34_0.vars.upgrade_wnd:getChildByName(tostring(iter_34_0 - 1))
		
		arg_34_0:setBuildingDetail(var_34_1, iter_34_0 - 1, var_34_0[iter_34_0])
	end
end

function SanctuaryMain.setBuildingDetail(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_35_0.vars.mode) .. "_1_0")
	local var_35_1 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_35_0.vars.mode) .. "_" .. arg_35_2 .. "_" .. arg_35_3)
	local var_35_2, var_35_3 = DB("sanctuary_upgrade", string.lower(arg_35_0.vars.mode) .. "_" .. arg_35_2 .. "_" .. arg_35_3 + 1, {
		"token_value_2",
		"rank"
	})
	local var_35_4 = arg_35_0:GetLevels(arg_35_0.vars.mode)
	
	if_set(arg_35_1, "txt_name", T(var_35_1.name))
	if_set(arg_35_1, "txt_desc", T(var_35_1.desc))
	if_set(arg_35_1, "txt_detail", T(var_35_1.detail))
	
	if arg_35_3 < 3 then
		if_set(arg_35_1, "cost", comma_value(var_35_2))
	else
		if_set(arg_35_1, "cost", "-")
	end
	
	local var_35_5 = arg_35_1:getChildByName("n_img")
	
	if var_35_5 then
		local var_35_6 = getSprite("sanctuary/" .. var_35_1.icon .. ".png")
		
		var_35_6:setLocalZOrder(-1)
		
		if var_35_5.spr then
			var_35_5.spr:removeFromParent()
		end
		
		var_35_5:addChild(var_35_6)
		
		var_35_5.spr = var_35_6
	end
	
	local var_35_7 = arg_35_1:getChildByName("btn_upgrade" .. arg_35_2)
	
	if var_35_7 then
		local var_35_8 = true
		
		if arg_35_3 >= 3 or Account:getLevel() < to_n(var_35_3) then
			var_35_8 = false
		end
		
		if var_35_4[2] < to_n(var_35_0.level_min) and arg_35_2 ~= 1 then
			var_35_8 = false
		end
		
		UIUtil:changeButtonState(var_35_7, var_35_8)
	end
	
	local var_35_9 = arg_35_1:getChildByName("btn_reset" .. arg_35_2)
	
	if arg_35_2 == 1 and var_35_4[arg_35_2 + 1] <= to_n(var_35_0.level_min) or arg_35_2 ~= 1 and var_35_4[arg_35_2 + 1] == 0 then
		if_set_opacity(arg_35_1, "btn_reset" .. arg_35_2, 30)
	else
		if_set_opacity(arg_35_1, "btn_reset" .. arg_35_2, 255)
	end
	
	if_set(arg_35_1, "t_lv", arg_35_3)
	if_set_visible(arg_35_1, "not_installed", arg_35_3 == 0)
	if_set_visible(arg_35_1, "t_lv", arg_35_3 ~= 0)
	if_set_visible(arg_35_1, "icon_improve_" .. arg_35_2, false)
	
	local var_35_10 = SanctuaryMain:get_recommend_info()
	
	if var_35_10 then
		local var_35_11 = var_35_10.mode or ""
		local var_35_12 = var_35_10.building or 1
		
		if not var_35_10.level then
			local var_35_13 = 1
		end
		
		if arg_35_0.vars.mode == var_35_11 and arg_35_2 == var_35_12 then
			if_set_visible(arg_35_0.vars.upgrade_wnd, "icon_improve_" .. arg_35_2, true)
		end
	end
end

function SanctuaryMain.showLackOrbisStoneDialog(arg_36_0)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	local var_36_0 = UIUtil:getRewardIcon(nil, "to_stone", {
		no_detail_popup = true
	})
	local var_36_1 = Dialog:msgBox(T("no_orbis_desc"), {
		yesno = true,
		title = T("no_orbis_title"),
		image = var_36_0,
		handler = function()
			local var_37_0 = SceneManager:getDefaultLayer()
			local var_37_1 = Material_Tooltip:getMaterialTooltip(SceneManager:getDefaultLayer(), "to_stone")
			
			if var_37_1 then
				WidgetUtils:showPopup({
					popup = var_37_1,
					control = var_37_0
				})
			end
		end
	})
	
	if_set(var_36_1, "txt_yes", T("no_orbis_btn"))
end

function SanctuaryMain.confirmUpgrade(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0:GetLevels()[2]
	local var_38_1 = arg_38_0:GetLevels()[arg_38_1 + 1]
	local var_38_2 = var_38_1 + 1
	
	if var_38_1 >= 3 then
		balloon_message_with_sound("sanc_max_level")
		
		return 
	end
	
	local var_38_3 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_38_0.vars.mode) .. "_1_0")
	local var_38_4 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_38_0.vars.mode) .. "_" .. arg_38_1 .. "_" .. var_38_1)
	local var_38_5 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_38_0.vars.mode) .. "_" .. arg_38_1 .. "_" .. var_38_2)
	local var_38_6 = to_n(var_38_3.level_min)
	
	if to_n(var_38_5.token_value_1) > Account:getCurrency(Account:isCurrencyType(var_38_5.token_type_1)) then
		arg_38_0:showLackOrbisStoneDialog()
		
		return 
	end
	
	if Account:getLevel() < var_38_5.rank then
		balloon_message_with_sound("sanc_rank_limit", {
			rank = var_38_5.rank
		})
		
		return 
	end
	
	if var_38_0 < to_n(var_38_3.level_min) and arg_38_1 ~= 1 then
		balloon_message_with_sound("sanc_upgrade_mid_first")
		
		return 
	end
	
	local var_38_7 = load_dlg("sanctuary_upgrade_confirm", true, "wnd")
	
	upgradeLabelToRichLabel(var_38_7, "desc_before")
	upgradeLabelToRichLabel(var_38_7, "desc_after")
	
	local var_38_8 = var_38_7.c.before.c["up" .. arg_38_1]
	
	var_38_8:setVisible(true)
	upgradeLabelToRichLabel(var_38_8, "txt_up_before")
	if_set(var_38_8, "lv_before", var_38_1)
	var_38_8:getChildByName("txt_up_before"):ignoreContentAdaptWithSize(true)
	
	local var_38_9 = var_38_1 == 0 and "<#FFFFFF>" .. T("sanctuary_not_installed") .. "</>" or T("sanctuary_upgrade_bar", {
		value = var_38_1
	})
	
	if_set(var_38_8, "txt_up_before", var_38_9)
	UIUserData:proc(var_38_8)
	if_set(var_38_7, "name_before", T(var_38_4.name))
	if_set(var_38_7, "desc_before", T(var_38_4.desc))
	
	local var_38_10 = var_38_7.c.after.c["up" .. arg_38_1]
	
	var_38_10:setVisible(true)
	upgradeLabelToRichLabel(var_38_10, "txt_up_after")
	var_38_10:getChildByName("txt_up_after"):ignoreContentAdaptWithSize(true)
	if_set(var_38_10, "txt_up_after", T("sanctuary_upgrade_bar", {
		value = var_38_2
	}))
	UIUserData:proc(var_38_10)
	if_set(var_38_7, "name_after", T(var_38_5.name))
	if_set(var_38_7, "desc_after", T(var_38_5.desc))
	
	if arg_38_1 == 1 and var_38_2 <= var_38_6 then
		local var_38_11 = var_38_7:getChildByName("window_frame")
		local var_38_12 = var_38_7:getChildByName("n_info")
		local var_38_13 = var_38_11:getContentSize()
		
		var_38_11:setContentSize(var_38_13.width, 500)
		var_38_12:setPositionY(-110)
		if_set_visible(var_38_7, "n_cost", false)
	end
	
	if_set(var_38_7, "t_orbis_count", T("use_count", {
		num = var_38_5.token_value_1
	}))
	if_set(var_38_7, "cost", comma_value(var_38_5.token_value_2))
	
	if to_n(var_38_5.token_value_2) == 0 then
		var_38_7:getChildByName("txt_yes"):setPositionX(0)
		if_set_visible(var_38_7, "n_gold", false)
	end
	
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_38_7,
		handler = function()
			query("sanctuary_change", {
				type = arg_38_0.vars.mode,
				index = arg_38_1
			})
			TutorialGuide:procGuide("system_068")
			TutorialGuide:procGuide("system_069")
			TutorialGuide:procGuide("system_070")
			TutorialGuide:procGuide("system_071")
			TutorialGuide:procGuide("sanctuary_start")
		end
	})
end

function SanctuaryMain.confirmReset(arg_40_0, arg_40_1)
	local var_40_0 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_40_0.vars.mode) .. "_" .. arg_40_1 .. "_0")
	
	if arg_40_0:GetLevels()[arg_40_1 + 1] < to_n(var_40_0.level_min) + 1 then
		balloon_message_with_sound("sanc_no_level")
		
		return 
	end
	
	local var_40_1 = arg_40_0:GetLevels()
	local var_40_2 = SLOW_DB_ALL("sanctuary_upgrade", string.lower(arg_40_0.vars.mode) .. "_" .. arg_40_1 .. "_" .. var_40_1[arg_40_1 + 1])
	local var_40_3 = 0
	
	for iter_40_0 = to_n(var_40_0.level_min) + 1, var_40_1[arg_40_1 + 1] do
		var_40_3 = var_40_3 + to_n(DB("sanctuary_upgrade", string.lower(arg_40_0.vars.mode) .. "_" .. arg_40_1 .. "_" .. iter_40_0, "token_value_1"))
	end
	
	local var_40_4 = load_dlg("sanctuary_upgrade_reset", true, "wnd")
	
	if_set(var_40_4, "cost", comma_value(to_n(var_40_2.reset_value)))
	if_set(var_40_4, "txt_stone", T("sanc_refund_num", {
		num = var_40_3
	}))
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_40_4,
		handler = function()
			arg_40_0:resetUpgrade(arg_40_1)
		end
	})
end

function SanctuaryMain.resetUpgrade(arg_42_0, arg_42_1)
	if arg_42_0.vars.mode == "SubTask" then
		local var_42_0 = SubTask:checkResetAutoCancelMissions(arg_42_1)
		
		if #var_42_0 > 0 then
			local var_42_1 = T("subtask_reset_lock_list", {
				subtask_list = table.concat(var_42_0, ", ")
			})
			
			Dialog:msgBox(T("subtask_reset_lock_desc"), {
				warning = var_42_1,
				title = T("sanctuary_upgrade_reset")
			})
			
			return 
		end
	end
	
	query("sanctuary_change", {
		mode = "reset",
		type = arg_42_0.vars.mode,
		index = arg_42_1
	})
end

function SanctuaryMain.createBackground(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.vars.wnd:getChildByName("n_bg")
	
	var_43_0:setCascadeOpacityEnabled(true)
	
	local var_43_1 = arg_43_0.vars.ui_layer
	local var_43_2 = {
		{
			fn = "main.scsp"
		},
		{
			fn = "light_1.scsp"
		},
		{
			fn = "light_2.scsp"
		},
		{
			fn = "light_3.scsp"
		},
		{
			fn = "light_4.scsp"
		},
		{
			fn = "light_5.scsp"
		},
		{
			tag = "Archemist"
		},
		{
			fn = "middlecloud.scsp"
		},
		{
			tag = "Forest"
		},
		{
			tag = "Craft"
		},
		{
			tag = "SubTask"
		},
		{
			fn = "left_crystal_1.scsp"
		},
		{
			fn = "left_crystal_2.scsp"
		},
		{
			fn = "right_crystal_1.scsp"
		},
		{
			fn = "right_crystal_2.scsp"
		},
		{
			fn = "right_crystal_3.scsp"
		},
		{
			tag = "Orbis"
		},
		{
			fn = "frontcloud.scsp"
		}
	}
	
	arg_43_0.vars.childs = {}
	arg_43_0.vars.modes = {}
	
	local var_43_3 = arg_43_0.vars.childs
	local var_43_4 = cc.Node:create()
	
	var_43_4:setCascadeOpacityEnabled(true)
	
	local var_43_5 = Account:getCurrentLobbyData()
	
	if var_43_5 and var_43_5.id == "christmas" then
		arg_43_0.vars.is_night = true
	else
		arg_43_0.vars.is_night = UIUtil:IsNight()
	end
	
	local var_43_6
	
	if arg_43_0.vars.is_night then
		var_43_6 = cc.Sprite:create("img/base_bnsanc.jpg")
	else
		var_43_6 = cc.Sprite:create("img/base_bdsanc.jpg")
	end
	
	var_43_6:setAnchorPoint(0.5, 0.5)
	var_43_6:setPosition(640, 360)
	var_43_6:setScale(5 * VIEW_WIDTH_RATIO)
	arg_43_0.vars.wnd:getChildByName("n_base"):addChild(var_43_6)
	
	for iter_43_0, iter_43_1 in pairs(var_43_2) do
		if iter_43_1.fn and not DEBUG.SANCTUARY then
			local var_43_7 = iter_43_1.fn
			
			if arg_43_0.vars.is_night then
				var_43_7 = "n_" .. iter_43_1.fn
			end
			
			local var_43_8 = arg_43_0:getModel(var_43_7)
			
			var_43_8:setCascadeOpacityEnabled(true)
			var_43_4:addChild(var_43_8)
			
			var_43_3[iter_43_1.fn] = {
				obj = var_43_8
			}
		end
		
		if iter_43_1.tag then
			local var_43_9 = cc.Node:create()
			
			var_43_9:setCascadeOpacityEnabled(true)
			var_43_4:addChild(var_43_9)
			
			arg_43_0.vars.modes[iter_43_1.tag] = {
				tag = iter_43_1.tag,
				obj = var_43_9
			}
		end
	end
	
	var_43_4:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_43_0:addChild(var_43_4)
	
	arg_43_0.vars.bg_content_layer = var_43_4
	
	arg_43_0:updateBuildings(true)
	
	if not arg_43_1 then
		UIAction:Add(CALL(arg_43_0.playEnterEffect, arg_43_0), arg_43_0, "block")
	end
end

function SanctuaryMain.stopReqUpgradeEffects(arg_44_0)
	if not arg_44_0.vars.upgrade_effects then
		return 
	end
	
	for iter_44_0, iter_44_1 in pairs(arg_44_0.vars.upgrade_effects) do
		if get_cocos_refid(iter_44_1) then
			iter_44_1:stop()
		end
	end
	
	arg_44_0.vars.upgrade_effects = nil
end

function SanctuaryMain.playReqUpgradeEffect(arg_45_0, arg_45_1)
	if not arg_45_1 then
		return 
	end
	
	local var_45_0 = arg_45_0:getMode()
	
	if var_45_0 == nil then
		return 
	end
	
	local var_45_1 = arg_45_0:GetLevels(arg_45_0.vars.modes[var_45_0].tag)
	
	arg_45_0.vars.upgrade_effects = {}
	
	for iter_45_0 = 1, 3 do
		if var_45_1[iter_45_0] < arg_45_1[iter_45_0] then
			local var_45_2 = arg_45_0.vars.upgrade_wnd:findChildByName("btn_upgrade" .. iter_45_0 - 1)
			
			if get_cocos_refid(var_45_2) then
				local var_45_3 = EffectManager:Play({
					fn = "ui_town_upgrade_bt_glow.cfx",
					layer = var_45_2
				})
				local var_45_4 = var_45_2:getContentSize()
				
				var_45_3:setPosition(var_45_4.width * 0.5, var_45_4.height * 0.5)
				table.insert(arg_45_0.vars.upgrade_effects, var_45_3)
			end
		end
	end
end

function SanctuaryMain.playEnterEffect(arg_46_0)
	local var_46_0 = arg_46_0.vars.ui_layer
	local var_46_1 = arg_46_0.vars.childs
	local var_46_2 = arg_46_0.vars.modes
	local var_46_3 = 0
	local var_46_4 = 700
	local var_46_5 = "day"
	
	if arg_46_0.vars.is_night then
		var_46_5 = "night"
	end
	
	if arg_46_0.BattleCount == Battle:GetBattleCount() then
		EffectManager:Play({
			fn = "sanctuary_" .. var_46_5 .. "_idle_eff.cfx",
			layer = arg_46_0.vars.bg_content_layer
		})
	else
		var_46_3 = 100
		var_46_4 = 1800
		
		EffectManager:Play({
			fn = "sanctuary_" .. var_46_5 .. "_intro.cfx",
			layer = arg_46_0.vars.bg_content_layer
		})
		
		arg_46_0.BattleCount = Battle:GetBattleCount()
	end
	
	local var_46_6 = 1
	local var_46_7 = 1
	
	arg_46_0.vars.bg_content_layer:setScale(0.87)
	UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.87, var_46_7 * 1), 10)), arg_46_0.vars.bg_content_layer, "block")
	var_46_2.Forest.obj:setScale(0.92)
	UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.92, var_46_7 * 1), 10)), var_46_2.Forest.obj, "block")
	
	if not DEBUG.SANCTUARY then
		var_46_1["left_crystal_1.scsp"].obj:setScale(0.8)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.8, var_46_7 * 1), 10)), var_46_1["left_crystal_1.scsp"].obj, "block")
		var_46_1["left_crystal_2.scsp"].obj:setScale(0.9)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.9, var_46_7 * 1), 10)), var_46_1["left_crystal_2.scsp"].obj, "block")
		var_46_1["right_crystal_1.scsp"].obj:setScale(0.7)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.7, var_46_7 * 1), 10)), var_46_1["right_crystal_1.scsp"].obj, "block")
		var_46_1["right_crystal_2.scsp"].obj:setScale(0.8)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.8, var_46_7 * 1), 10)), var_46_1["right_crystal_2.scsp"].obj, "block")
		var_46_1["right_crystal_3.scsp"].obj:setScale(0.9)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.9, var_46_7 * 1), 10)), var_46_1["right_crystal_3.scsp"].obj, "block")
		var_46_1["middlecloud.scsp"].obj:setScale(0.8)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.8, var_46_7 * 1), 10)), var_46_1["middlecloud.scsp"].obj, "block")
		var_46_1["frontcloud.scsp"].obj:setScale(0.8)
		UIAction:Add(SEQ(DELAY(var_46_3), LOG(SCALE(var_46_4, var_46_6 * 0.8, var_46_7 * 1), 10)), var_46_1["frontcloud.scsp"].obj, "block")
	end
	
	var_46_0:setOpacity(0)
	UIAction:Add(SEQ(DELAY(var_46_3), DELAY(var_46_4 * 0.5), FADE_IN(var_46_4 * 0.5)), var_46_0, "block")
end

function SanctuaryMain.getModel(arg_47_0, arg_47_1)
	local var_47_0 = CACHE:getEffect(arg_47_1, "sanctuary")
	
	var_47_0:setScaleFactor(1)
	var_47_0:setCascadeOpacityEnabled(true)
	var_47_0:setAnimation(0, "idle", true)
	
	return var_47_0
end

function SanctuaryMain.updateBuildings(arg_48_0, arg_48_1)
	if not arg_48_0.vars then
		return 
	end
	
	local var_48_0 = ""
	
	if arg_48_0.vars.is_night then
		var_48_0 = "n_"
	end
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.modes) do
		local var_48_1 = arg_48_0:GetLevels(iter_48_1.tag)
		
		if iter_48_1.obj.model == nil then
			local var_48_2 = arg_48_0:getModel(var_48_0 .. string.lower(iter_48_1.tag) .. "_main.scsp")
			
			var_48_2:setName(iter_48_1.tag .. "_model")
			iter_48_1.obj:addChild(var_48_2)
			
			iter_48_1.obj.model = var_48_2
			iter_48_1.obj.buildings = {}
		end
		
		for iter_48_2 = 1, 3 do
			local var_48_3 = string.lower(iter_48_1.tag) .. "_" .. iter_48_2
			local var_48_4 = iter_48_1.obj:getChildByName(var_48_3)
			
			if var_48_1[iter_48_2] > 0 then
				if not var_48_4 then
					local var_48_5 = arg_48_0:getModel(var_48_0 .. var_48_3 .. ".scsp")
					
					var_48_5:setName(var_48_3)
					
					if var_48_5 then
						iter_48_1.obj:addChild(var_48_5)
						
						iter_48_1.obj.buildings[iter_48_2] = var_48_5
					else
						Log.e("NO SANCTUARY BUILDING", var_48_0 .. var_48_3 .. ".scsp")
					end
				end
			elseif var_48_4 then
				var_48_4:removeFromParent()
				
				iter_48_1.obj.buildings[iter_48_2] = nil
			end
		end
		
		local var_48_6 = DB("sanctuary_upgrade", string.lower(iter_48_1.tag) .. "_0_0", "system")
		local var_48_7 = UnlockSystem:isUnlockSystem(var_48_6)
		local var_48_8 = arg_48_0.vars.wnd:getChildByName(iter_48_1.tag)
		
		if_set_visible(var_48_8, "icon_locked", not var_48_7)
		if_set_visible(var_48_8, "n_improve", false)
		
		local var_48_9 = SanctuaryMain:get_recommend_info()
		
		if var_48_9 then
			local var_48_10 = var_48_9.mode or ""
			
			if not var_48_9.building then
				local var_48_11 = 1
			end
			
			if not var_48_9.level then
				local var_48_12 = 1
			end
			
			if var_48_10 == iter_48_1.tag then
				if_set_visible(var_48_8, "n_improve", true)
			end
		end
		
		if var_48_7 then
			for iter_48_3 = 1, 3 do
				if_set(var_48_8, "t_lv" .. iter_48_3, var_48_1[iter_48_3])
				
				if var_48_1[iter_48_3] > 0 then
					if_set_opacity(var_48_8, "up" .. iter_48_3, 255)
				else
					if_set_opacity(var_48_8, "up" .. iter_48_3, 70)
				end
			end
			
			if_set_visible(var_48_8, "icon_noti", false)
			if_set_opacity(var_48_8, "t_title", 255)
		else
			if_set_opacity(var_48_8, "t_title", 90)
			if_set_visible(var_48_8, "icon_noti", false)
		end
	end
end

function SanctuaryMain.onExit(arg_49_0)
	SceneManager:popScene()
	BackButtonManager:pop("TopBarNew." .. T("sanc_main"))
	
	arg_49_0.vars = nil
end

function SanctuaryMain.showBuildingDetail(arg_50_0, arg_50_1, arg_50_2)
	if not arg_50_0.vars.preview_wnd then
		arg_50_0.vars.preview_wnd = load_dlg("sanctuary_preview", true, "wnd", function()
			SanctuaryMain:closeBuildingDetail()
		end)
		arg_50_0.vars.preview_wnd.idx = arg_50_1
		
		upgradeLabelToRichLabel(arg_50_0.vars.preview_wnd, "txt_desc")
		arg_50_0.vars.wnd:getChildByName("n_upgrade"):addChild(arg_50_0.vars.preview_wnd)
	end
	
	for iter_50_0 = 0, 2 do
		local var_50_0 = arg_50_0.vars.preview_wnd:getChildByName("up" .. iter_50_0)
		
		if arg_50_1 and var_50_0 and iter_50_0 ~= arg_50_1 then
			var_50_0:removeFromParent()
		end
	end
	
	arg_50_1 = arg_50_1 or arg_50_0.vars.preview_wnd.idx
	arg_50_2 = arg_50_2 or arg_50_0:GetLevels()[arg_50_1 + 1]
	
	arg_50_0:setBuildingDetail(arg_50_0.vars.preview_wnd, arg_50_1, arg_50_2)
	
	for iter_50_1 = 0, 4 do
		local var_50_1 = arg_50_0.vars.preview_wnd:getChildByName("btn_lv" .. iter_50_1)
		
		if var_50_1 then
			UIUtil:changeButtonState(var_50_1, iter_50_1 == arg_50_2)
		end
	end
	
	local var_50_2 = arg_50_0.vars.preview_wnd:getChildByName("up" .. arg_50_1)
	local var_50_3 = upgradeLabelToRichLabel(var_50_2, "txt_up")
	local var_50_4 = {
		"<#FFFFFF>" .. T("sanctuary_not_installed") .. "</>",
		T("sanctuary_upgrade_bar", {
			value = 1
		}),
		T("sanctuary_upgrade_bar", {
			value = 2
		}),
		T("sanctuary_upgrade_bar", {
			value = 3
		})
	}
	
	var_50_3:ignoreContentAdaptWithSize(true)
	var_50_3:setString(var_50_4[arg_50_2 + 1])
	UIUserData:proc(var_50_2)
	SoundEngine:play("event:/ui/popup/tap")
end

function SanctuaryMain.closeBuildingDetail(arg_52_0)
	if arg_52_0.vars.preview_wnd then
		arg_52_0:stopReqUpgradeEffects()
		arg_52_0.vars.preview_wnd:removeFromParent()
		BackButtonManager:pop("sanctuary_preview")
		
		arg_52_0.vars.preview_wnd = nil
	end
end

function SanctuaryMain.showBuildingLevel(arg_53_0, arg_53_1)
	for iter_53_0, iter_53_1 in pairs(arg_53_0.vars.modes) do
		if iter_53_1.tag then
			local var_53_0 = arg_53_0.vars.wnd:getChildByName(iter_53_1.tag)
			local var_53_1
			local var_53_2
			
			var_53_2 = arg_53_1 and 255 or 0
		end
	end
end

function SanctuaryMain.collectOrbis(arg_54_0, arg_54_1)
	if arg_54_1 == 1 then
		SanctuaryOrbis:Collect()
		SanctuaryMain:update()
	else
		EffectManager:Play({
			x = 650,
			y = 500,
			fn = "ui_orbis_heart_get_out.cfx",
			layer = arg_54_0.vars.wnd
		})
		UIAction:Add(SEQ(DELAY(600), CALL(SanctuaryMain.collectOrbis, arg_54_0, 1)), arg_54_0, "block")
	end
end

function SanctuaryMain.show_recommend_noti(arg_55_0)
	if not arg_55_0.vars or not get_cocos_refid(arg_55_0.vars.wnd) then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	local var_55_0 = arg_55_0:need_recommend_noti()
	
	if not var_55_0 then
		return 
	end
	
	if_set_visible(arg_55_0.vars.wnd, "n_improve_noti", var_55_0)
	arg_55_0:update_recommend_noti_data()
	
	arg_55_0.vars.recommend_delay_max = 5
	arg_55_0.vars.recommend_delay_time = 0
	
	Scheduler:addSlow(arg_55_0.vars.wnd, arg_55_0.update_recommend_noti_banner, arg_55_0):setName("sanctuary_rcmd_popup")
end

function SanctuaryMain.update_recommend_noti_data(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	arg_56_0.vars.recommend_info = nil
	
	if not arg_56_0:need_recommend_noti() then
		return 
	end
	
	local var_56_0
	local var_56_1
	local var_56_2
	local var_56_3
	
	for iter_56_0 = 1, 99999 do
		local var_56_4, var_56_5 = DBN("sanctuary_upgrade_guide", iter_56_0, {
			"id",
			"sanctuary_id"
		})
		
		if not var_56_4 then
			break
		end
		
		local var_56_6 = string.split(var_56_5, "_") or {}
		
		if not var_56_6 or table.empty(var_56_6) or var_56_6[1] and (var_56_6[1] == nil or var_56_6[1] == "nil") then
			return 
		end
		
		local var_56_7 = var_56_6[1]
		local var_56_8 = tonumber(var_56_6[2])
		local var_56_9 = tonumber(var_56_6[3])
		local var_56_10 = arg_56_0:GetLevels(var_56_7)[var_56_8 + 1]
		
		if var_56_9 > tonumber(var_56_10) then
			var_56_0 = var_56_4
			var_56_1 = var_56_7
			var_56_2 = var_56_8
			var_56_3 = var_56_9
			
			break
		end
	end
	
	if not var_56_0 or not var_56_1 then
		return 
	end
	
	local var_56_11 = arg_56_0.vars.wnd:getChildByName(var_56_1)
	
	if not get_cocos_refid(var_56_11) then
		return 
	end
	
	arg_56_0:set_recommend_info({
		id = var_56_0,
		mode = var_56_1,
		building = var_56_2,
		level = var_56_3
	})
end

function SanctuaryMain.set_recommend_info(arg_57_0, arg_57_1)
	if not arg_57_0.vars then
		return 
	end
	
	arg_57_0.vars.recommend_info = arg_57_1
end

function SanctuaryMain.get_recommend_info(arg_58_0)
	if not arg_58_0.vars or not arg_58_0.vars.recommend_info then
		return 
	end
	
	return arg_58_0.vars.recommend_info
end

function SanctuaryMain.update_recommend_noti_banner(arg_59_0)
	if not arg_59_0.vars then
		return 
	end
	
	arg_59_0.vars.recommend_delay_time = arg_59_0.vars.recommend_delay_time + 1
	
	if arg_59_0.vars.recommend_delay_time >= arg_59_0.vars.recommend_delay_max then
		arg_59_0:hide_recommend_noti()
		Scheduler:removeByName("sanctuary_rcmd_popup")
	end
end

function SanctuaryMain.hide_recommend_noti(arg_60_0)
	if not arg_60_0.vars or not get_cocos_refid(arg_60_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(SHOW(true), FADE_OUT(300)), arg_60_0.vars.wnd:getChildByName("n_improve_noti"), "sanctuary_rcmd_popup")
end

function SanctuaryMain.need_recommend_noti(arg_61_0)
	if Account:getLevel() >= 40 then
		return 
	end
	
	local var_61_0 = 17
	
	if (Account:getCurrency("to_stone") or 0) <= 0 then
		return 
	end
	
	local var_61_1 = AccountData.sanc_lv or {}
	
	if table.empty(var_61_1) then
		return true
	end
	
	local var_61_2 = 0
	
	for iter_61_0, iter_61_1 in pairs(var_61_1) do
		for iter_61_2, iter_61_3 in pairs(iter_61_1) do
			var_61_2 = var_61_2 + iter_61_3
		end
	end
	
	if var_61_0 <= var_61_2 then
		return 
	end
	
	return true
end
