LotaGuideUI = {}

function HANDLER.clan_heritage_guide(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaGuideUI:close()
	end
	
	if arg_1_1 == "btn_minimap" then
		LotaGuideUI:close()
		LotaMinimapRenderer:convertToFullScreen()
	end
end

function LotaGuideUI.init(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_guide")
	arg_2_0.vars.quest_summary_key = LotaUserData:getQuestSummaryKey()
	
	arg_2_1:addChild(arg_2_0.vars.dlg)
	BackButtonManager:push({
		check_id = "lota_guide",
		back_func = function()
			arg_2_0:close()
		end
	})
	arg_2_0:uiSetting()
	TutorialGuide:procGuide("tuto_heritage_quest")
end

function LotaGuideUI.getDBData(arg_4_0, arg_4_1)
	return DB("clan_heritage_quest_summary", arg_4_0.vars.quest_summary_key, arg_4_1)
end

function LotaGuideUI.setupInformation(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0, var_5_1, var_5_2, var_5_3 = arg_5_0:getDBData({
		"quest_" .. arg_5_2 .. "_target_icon",
		"quest_" .. arg_5_2 .. "_target_title",
		"quest_" .. arg_5_2 .. "_target_desc2",
		"quest_" .. arg_5_2 .. "_target_img"
	})
	
	if_set(arg_5_1, "t_goal", T(var_5_1))
	if_set(arg_5_1, "t_mission_disc", T(var_5_2))
	
	local var_5_4 = arg_5_1:findChildByName("n_img")
	local var_5_5 = SpriteCache:getSprite("clanheritage/" .. tostring(var_5_3) .. ".png")
	
	var_5_4:addChild(var_5_5)
	
	local var_5_6 = {
		"icon_guardian",
		"icon_boss",
		"icon_portal"
	}
	local var_5_7 = arg_5_1:findChildByName(var_5_6[arg_5_2])
	
	if var_5_7 then
		SpriteCache:resetSprite(var_5_7, "img/" .. tostring(var_5_0) .. ".png")
	end
end

function LotaGuideUI.uiSettingStep1(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1:findChildByName("n_step1")
	local var_6_1 = arg_6_1:findChildByName("img_clear_step1")
	local var_6_2 = LotaClanInfo:getKeeperDeadCount(LotaUserData:getFloor())
	local var_6_3 = LotaClanInfo:getRequireKeeperDeadCount(LotaUserData:getFloor())
	local var_6_4, var_6_5 = arg_6_0:getDBData({
		"quest_1_target_desc",
		"quest_1_value_max"
	})
	
	if arg_6_0.vars.step1_status then
		var_6_3 = var_6_5
	end
	
	if_set(var_6_0, "t_mission", T(var_6_4, {
		count = var_6_2,
		count1 = var_6_3
	}))
	if_set_visible(var_6_1, nil, arg_6_0.vars.step1_status)
	
	if arg_6_0.vars.step1_status then
		var_6_0:setColor(cc.c3b(77, 77, 77))
	else
		var_6_0:setColor(cc.c3b(255, 255, 255))
	end
	
	arg_6_0:setupInformation(var_6_0, 1)
end

function LotaGuideUI.uiSettingStep2(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1:findChildByName("n_step2")
	local var_7_1 = arg_7_1:findChildByName("img_clear_step2")
	
	if_set_visible(var_7_1, nil, arg_7_0.vars.step2_status)
	
	if not arg_7_0.vars.step1_status or arg_7_0.vars.step2_status then
		var_7_0:setColor(cc.c3b(77, 77, 77))
	else
		var_7_0:setColor(cc.c3b(255, 255, 255))
	end
	
	local var_7_2, var_7_3, var_7_4 = arg_7_0:getDBData({
		"quest_2_target_desc",
		"quest_2_value_need",
		"quest_2_value_max"
	})
	local var_7_5 = arg_7_0.vars.step2_status and 1 or 0
	local var_7_6 = var_7_3
	
	if arg_7_0.vars.step2_status then
		var_7_6 = var_7_4
	end
	
	if_set(var_7_0, "t_mission", T(var_7_2, {
		count = var_7_5,
		count1 = var_7_6
	}))
	arg_7_0:setupInformation(var_7_0, 2)
end

function LotaGuideUI.uiSettingStep3(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1:findChildByName("n_step3")
	local var_8_1 = arg_8_1:findChildByName("img_clear_step3")
	local var_8_2, var_8_3, var_8_4, var_8_5, var_8_6 = arg_8_0:getDBData({
		"quest_3_target_desc",
		"quest_3_value_need",
		"quest_3_value_max",
		"quest_3_target",
		"quest_3_target_icon"
	})
	local var_8_7 = arg_8_0.vars.step3_status and 1 or 0
	local var_8_8 = var_8_3
	local var_8_9 = var_8_5 == "boss_portal"
	
	if arg_8_0.vars.step3_status then
		var_8_8 = var_8_4
	end
	
	local var_8_10 = false
	
	if var_8_9 then
		if_set(var_8_0, "t_mission", T(var_8_2, {
			count = var_8_7,
			count1 = var_8_8
		}))
	else
		if_set(var_8_0, "t_mission", T(var_8_2, {
			count = math.min(LotaClanInfo:getBossDeadCount(), 3)
		}))
		
		var_8_10 = LotaClanInfo:getBossDeadCount() > 1
	end
	
	if_set_visible(var_8_0, "icon_potal", var_8_9)
	if_set_visible(var_8_0, "icon_boss", not var_8_9)
	if_set_sprite(var_8_0, var_8_9 and "icon_potal" or "icon_boss", "img/" .. var_8_6 .. ".png")
	if_set_visible(var_8_1, nil, var_8_10)
	
	if not arg_8_0.vars.step1_status or not arg_8_0.vars.step2_status or var_8_10 then
		var_8_0:setColor(cc.c3b(77, 77, 77))
	else
		var_8_0:setColor(cc.c3b(255, 255, 255))
	end
	
	arg_8_0:setupInformation(var_8_0, 3)
end

function LotaGuideUI.uiSetting(arg_9_0)
	local var_9_0 = DB("clan_heritage_quest_summary", arg_9_0.vars.quest_summary_key, "floor_title")
	
	if_set(arg_9_0.vars.dlg, "t_title", T(var_9_0))
	
	local var_9_1 = LotaClanInfo:getCurrentQuestProgress()
	
	arg_9_0.vars.step1_status = var_9_1 > 1
	arg_9_0.vars.step2_status = var_9_1 > 2
	arg_9_0.vars.step3_status = var_9_1 > 3
	
	arg_9_0:uiSettingStep1(arg_9_0.vars.dlg)
	arg_9_0:uiSettingStep2(arg_9_0.vars.dlg)
	arg_9_0:uiSettingStep3(arg_9_0.vars.dlg)
end

function LotaGuideUI.close(arg_10_0)
	if arg_10_0.vars and get_cocos_refid(arg_10_0.vars.dlg) then
		arg_10_0.vars.dlg:removeFromParent()
		
		arg_10_0.vars = nil
		
		BackButtonManager:pop("lota_guide")
		LotaSystem:setBlockCoolTime()
	end
end
