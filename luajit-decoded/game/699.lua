LotaUIMainLayer = {}

function HANDLER.clan_heritage_main(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_current_location" then
		LotaCameraSystem:setCameraPlayerPos()
		
		if LotaInteractiveUI:isActive() then
			LotaInteractiveUI:close()
		end
	end
	
	if arg_1_1 == "btn_relices" then
		LotaStatusLegacyUI:open(LotaSystem:getUIDialogLayer(), LotaUtil:getMyUserInfo())
	end
	
	if arg_1_1 == "btn_status" then
		LotaStatusUI:open(LotaSystem:getUIPopupLayer(), LotaUtil:getMyUserInfo())
	end
	
	if arg_1_1 == "btn_noti" then
		LotaReminderUI:init()
	end
	
	if arg_1_1 == "btn_map" then
		LotaMinimapRenderer:convertToFullScreen()
	end
	
	if arg_1_1 == "btn_hero" then
		LotaHeroInformationUI:open(LotaSystem:getUIPopupLayer())
	end
	
	if arg_1_1 == "btn_guid" then
		LotaGuideUI:init(LotaSystem:getUIDialogLayer())
	end
	
	if arg_1_1 == "btn_member" then
		LotaNetworkSystem:sendQuery("lota_clan_status")
	end
end

function LotaUIMainLayer.init(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.layer = LotaUtil:getUIDlg("clan_heritage_main")
	arg_2_0.vars.icon = nil
	
	local var_2_0 = LotaSystem:getWorldId()
	local var_2_1 = DB("clan_heritage_world", var_2_0, "name")
	
	TopBarNew:create(T(var_2_1), arg_2_0.vars.layer, function()
		LotaUIMainLayer:onPushBackButton()
	end)
	TopBarNew:checkhelpbuttonID("heritage")
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:setDisableLobbyAuto()
	arg_2_1:addChild(arg_2_0.vars.layer)
	arg_2_0:updateUI()
end

function LotaUIMainLayer.setVisible(arg_4_0, arg_4_1)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.layer) then
		return 
	end
	
	if_set_visible(arg_4_0.vars.layer, nil, arg_4_1)
end

function LotaUIMainLayer.updateSetVisibleNoti(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.layer) then
		return 
	end
	
	local var_5_0 = LotaUtil:getMyUserInfo()
	local var_5_1 = arg_5_0.vars.layer:findChildByName("btn_noti")
	
	if_set_visible(var_5_1, "icon_noti", LotaBattleDataSystem:isActiveRewardExist() or LotaBoxSystem:isActiveRewardExist())
	
	local var_5_2 = arg_5_0.vars.layer:findChildByName("btn_status")
	local var_5_3 = LotaRegistrationUI:isAvailableEnter() and table.count(var_5_0.hero_register_list) < LotaUtil:getMaxHeroCount(var_5_0.exp)
	
	if_set_visible(var_5_2, "icon_noti", LotaUserData:isUpgradeable() or var_5_3)
end

function LotaUIMainLayer.updateUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.layer) then
		return 
	end
	
	arg_6_0:updateExplorePoint()
	arg_6_0:updateActionPoint()
	arg_6_0:updateSetVisibleNoti()
	arg_6_0:updateHeroButton()
end

function LotaUIMainLayer.updateHeroButton(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.layer) then
		return 
	end
	
	local var_7_0 = #LotaUserData:getRegistrationList()
	
	if_set_color(arg_7_0.vars.layer, "btn_hero", var_7_0 > 0 and cc.c3b(255, 255, 255) or cc.c3b(76, 76, 76))
end

function LotaUIMainLayer.updateVisibleButtons(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.layer) then
		return 
	end
	
	if_set_visible(arg_8_0.vars.layer, "btn_current_location", arg_8_1)
end

function LotaUIMainLayer.updateActionPoint(arg_9_0)
end

function LotaUIMainLayer.updateExplorePoint(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.layer) then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.layer
	
	LotaUtil:updateUserInfoUI(var_10_0, LotaUtil:getMyUserInfo(), {
		n_expedition_level_name = "n_expedition_progress",
		t_level_name = "t_lv",
		level_bg_name = "lv_bg"
	})
	
	local var_10_1 = var_10_0:findChildByName("RIGHT")
	local var_10_2 = false
	local var_10_3 = LotaClanInfo:getCurrentQuestDesc()
	local var_10_4 = LotaClanInfo:getCurrentQuestProgress()
	local var_10_5 = LotaClanInfo:getCurrentQuestIcon()
	local var_10_6 = LotaClanInfo:getCurrentQuestType()
	
	if var_10_4 ~= arg_10_0.vars.progress then
		arg_10_0.vars.progress = var_10_4
		var_10_2 = true
	end
	
	if var_10_4 == 1 then
		local var_10_7 = LotaClanInfo:getKeeperDeadCount()
		local var_10_8 = LotaClanInfo:getRequireKeeperDeadCount()
		
		if var_10_7 ~= arg_10_0.vars.point then
			arg_10_0.vars.point = var_10_7
			var_10_2 = true
		end
		
		if_set(var_10_1, "t_mission", T(var_10_3, {
			count = var_10_7,
			count1 = var_10_8
		}))
	elseif var_10_4 == 2 then
		if_set(var_10_1, "t_mission", T(var_10_3, {
			count = 0,
			count1 = 1
		}))
	elseif var_10_4 == 3 then
		if LotaSystem:isFinalFloor() then
			if_set(var_10_1, "t_mission", T(var_10_3, {
				count = LotaClanInfo:getBossDeadCount()
			}))
		else
			if_set(var_10_1, "t_mission", T(var_10_3, {
				count = 0,
				count1 = 1
			}))
		end
	elseif var_10_4 == 4 then
		if_set(var_10_1, "t_mission", T(var_10_3))
	end
	
	if var_10_5 and var_10_5 ~= arg_10_0.vars.icon then
		local var_10_9 = var_10_0:findChildByName("n_mob_grade_icon")
		local var_10_10 = var_10_6 == "boss_portal"
		
		if_set_visible(var_10_9, "icon_potal", var_10_10 and var_10_4 < 4)
		if_set_visible(var_10_9, "icon_boss", not var_10_10 and var_10_4 < 4)
		if_set_sprite(var_10_9, var_10_10 and "icon_potal" or "icon_boss", "img/" .. var_10_5 .. ".png")
		
		arg_10_0.vars.icon = var_10_5
	end
	
	if var_10_2 then
		arg_10_0:addGuideEffect()
	end
	
	LotaUtil:updateLegacySlotsInMainUI(var_10_0:findChildByName("n_my_legacy"), LotaUserData:getArtifactItems())
end

function LotaUIMainLayer.addGuideEffect(arg_11_0)
	if not arg_11_0.vars or not arg_11_0.vars.layer then
		return 
	end
	
	EffectManager:Play({
		pivot_x = -160,
		fn = "ui_eff_heritage_quest_guide.cfx",
		pivot_y = 2,
		scale = 0.9,
		layer = arg_11_0.vars.layer:getChildByName("n_goal")
	})
end

function LotaUIMainLayer.onPushBackButton(arg_12_0)
	TopBarNew:pop()
	LotaNetworkSystem:sendQuery("lota_enter")
	SceneManager:resetSceneFlow()
end

function LotaUIMainLayer.close(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	arg_13_0.vars.layer:removeFromParent()
	
	arg_13_0.vars = nil
end
