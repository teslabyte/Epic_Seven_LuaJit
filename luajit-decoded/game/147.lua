DungeonCrevice = {}
DungeonCreviceMain = {}
DungeonCreviceMain.bg = {}
DungeonCreviceMain.set = {}
DungeonCreviceMain.rune = {}
DungeonCreviceMain.exploit = {}
DungeonCreviceMain.reward = {}

copy_functions(ScrollView, DungeonCreviceMain.exploit)

MAX_SET_COUNT = 4
MAX_RUNE_COUNT = 4

function HANDLER.dungeon_crevice(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_set" then
		DungeonCreviceMain.set:openPopup()
	elseif arg_1_1 == "btn_set_tooltip" then
		DungeonCreviceMain.set:showSeletedSetInfos(false)
	elseif arg_1_1 == "btn_stone" then
		DungeonCreviceMain.rune:openPopup()
	elseif arg_1_1 == "btn_pass" then
		DungeonCreviceMain.exploit:openPopup()
	elseif arg_1_1 == "btn_discussion" then
	elseif arg_1_1 == "btn_simple_info" then
		DungeonCreviceMain:showSimpleInfo(true, 360, true)
	elseif arg_1_1 == "btn_go" then
		DungeonCreviceMain:goReady()
	end
end

function HANDLER_BEFORE.dungeon_crevice(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_set_tooltip" then
		DungeonCreviceMain.set:showSeletedSetInfos(true)
	elseif arg_2_1 == "btn_simple_info" then
		DungeonCreviceMain:showSimpleInfo(true)
	end
end

function HANDLER_CANCEL.dungeon_crevice(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_set_tooltip" then
		DungeonCreviceMain.set:showSeletedSetInfos(false)
	elseif arg_3_1 == "btn_simple_info" then
		DungeonCreviceMain:showSimpleInfo(false)
	end
end

function HANDLER.crevice_set_choose(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_cancel" then
		DungeonCreviceMain.set:closePopup()
	elseif arg_4_1 == "btn_yes" then
		DungeonCreviceMain.set:sendSeletedSetInfos()
	end
end

function HANDLER.crevice_runestone_item(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_skill" then
		DungeonCreviceMain.rune:onSelectRuneSkill(arg_5_0)
	end
end

function HANDLER.crevice_pass_base(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_get_all" then
		DungeonCreviceMain.exploit:getAllRemainRewardItems()
	end
end

function HANDLER.crevice_pass_item(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_reward" then
		DungeonCreviceMain.exploit:getAllRemainRewardItems(arg_7_0.item)
	end
end

function MsgHandler.crevice_lobby(arg_8_0)
	if arg_8_0 and arg_8_0.res == "ok" then
		DungeonCreviceMain:open(arg_8_0)
	end
end

function MsgHandler.crevice_setfx_save(arg_9_0)
	if arg_9_0 and arg_9_0.res == "ok" and not table.empty(arg_9_0.season_info) then
		DungeonCreviceMain.set:onSetSeletedSetInfos(arg_9_0.season_info)
	end
end

function MsgHandler.crevice_rune_save(arg_10_0)
	if arg_10_0 and arg_10_0.res == "ok" and not table.empty(arg_10_0.season_info) then
		DungeonCreviceMain.rune:onSetSeletedRuneInfos(arg_10_0.season_info)
	end
end

function MsgHandler.crevice_exploit_reward_get(arg_11_0)
	if arg_11_0 and arg_11_0.res == "ok" and not table.empty(arg_11_0.season_info) then
		DungeonCreviceMain.exploit:onSetReceivedRewardItems(arg_11_0)
	end
end

function DungeonCrevice.create(arg_12_0, arg_12_1)
	arg_12_0:release()
	
	arg_12_0.vars = {}
	arg_12_0.vars.parent_wnd = arg_12_1
	
	arg_12_0:initUI()
	
	local var_12_0 = arg_12_0:createBgEffect()
	
	TutorialGuide:ifStartGuide("crehunt_start")
	
	return var_12_0, true
end

function DungeonCrevice.release(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	arg_13_0.vars.loop_eff = nil
	arg_13_0.vars.parent_wnd = nil
	arg_13_0.vars = nil
end

function DungeonCrevice.getSceneState(arg_14_0)
	return DungeonCreviceMain:getSceneState()
end

function DungeonCrevice.getSeasonScheduleInfo(arg_15_0, arg_15_1)
	if table.empty(arg_15_0.season_infos) or not arg_15_1 then
		return nil
	end
	
	return arg_15_0.season_infos[arg_15_1]
end

function DungeonCrevice.getParentWnd(arg_16_0)
	if not arg_16_0.vars then
		return nil
	end
	
	return arg_16_0.vars.parent_wnd
end

function DungeonCrevice.initUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.parent_wnd) then
		return 
	end
	
	local var_17_0 = Account:getCrehuntSeasonScheduleInfo()
	
	if table.empty(var_17_0) then
		return nil
	end
	
	local var_17_1 = arg_17_0.vars.parent_wnd:getChildByName("LEFT")
	
	if get_cocos_refid(var_17_1) then
		local var_17_2 = DB("level_crevicehunt", var_17_0.id, {
			"name",
			"bg_crevicehunt"
		})
		local var_17_3 = var_17_1:getChildByName("n_title")
		
		if_set(var_17_3, "txt_title", T(var_17_2))
		
		local var_17_4 = var_17_1:getChildByName("n_crevice")
		
		if get_cocos_refid(var_17_4) then
			local var_17_5 = var_17_0.attribute
			local var_17_6 = var_17_4:getChildByName("n_pro")
			
			if get_cocos_refid(var_17_6) then
				for iter_17_0, iter_17_1 in pairs(var_17_6:getChildren()) do
					if_set_visible(iter_17_1, nil, false)
				end
				
				if_set_visible(var_17_6, "icon_" .. var_17_5, true)
			end
			
			if_set(var_17_4, "txt_desc", T("crevicehunt_use_" .. var_17_5))
			if_set(var_17_4, "txt_season", T("ui_crevicehunt_season_end"))
			
			local var_17_7 = Account:getCrehuntRemainTimeText()
			
			if_set(var_17_4, "txt_count", var_17_7)
			if_set(var_17_4, "txt_reward", T("ui_crevicehunt_season_reward"))
		end
	end
	
	local var_17_8 = getChildByPath(arg_17_0.vars.parent_wnd, "RIGHT")
	
	if get_cocos_refid(var_17_8) then
		local var_17_9 = var_17_8:getChildByName("sub_Crevice")
		
		if get_cocos_refid(var_17_9) then
			if_set_visible(var_17_9, "btn_normal", var_17_0.normal_enter_id ~= nil)
			if_set_visible(var_17_9, "btn_hard", var_17_0.hard_enter_id ~= nil)
		end
	end
end

function DungeonCrevice.createBgEffect(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.parent_wnd) then
		return nil
	end
	
	local var_18_0 = Account:getCrehuntSeasonScheduleInfo()
	
	if table.empty(var_18_0) then
		return nil
	end
	
	local var_18_1
	local var_18_2 = arg_18_0.vars.parent_wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_18_2) then
		local var_18_3 = DB("level_crevicehunt", var_18_0.id, "bg_crevicehunt")
		
		if var_18_3 then
			arg_18_0.vars.loop_eff = EffectManager:Play({
				fn = var_18_3 .. ".cfx",
				layer = var_18_2
			})
		end
		
		var_18_2:removeChildByName("crehunt_bg_effect")
		
		var_18_1 = EffectManager:Play({
			fn = "uieff_rift_portal_lobi_menu_idle.cfx",
			layer = var_18_2
		})
		
		var_18_1:setName("crehunt_bg_effect")
		EffectManager:AttachEffect(var_18_1, "uieff_rift_bg/portal", arg_18_0.vars.loop_eff)
		
		var_18_1.loop_eff = arg_18_0.vars.loop_eff
	end
	
	return var_18_1
end

function DungeonCrevice.createWhiteBg(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.parent_wnd) then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.parent_wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_19_0) then
		local var_19_1 = cc.LayerColor:create(cc.c3b(255, 255, 255))
		
		var_19_1:setContentSize(3000, 3000)
		var_19_1:setPosition(-1500, -1500)
		var_19_1:setName("white_bg")
		var_19_0:addChild(var_19_1)
	end
end

function DungeonCrevice.removeWhiteBg(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.parent_wnd) then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.parent_wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_20_0) then
		var_20_0:removeChildByName("white_bg")
	end
end

function DungeonCrevice.CheckNotification(arg_21_0)
	return DungeonCreviceUtil:isRemainRewardItems()
end

function DungeonCrevice.onEnter(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.parent_wnd) then
		return 
	end
	
	arg_22_2 = arg_22_2 or {}
	
	if arg_22_2.no_act then
		query("crevice_lobby", {
			difficulty = arg_22_2.is_hard_mode and 1 or 0
		})
	else
		local var_22_0 = arg_22_0.vars.parent_wnd:getChildByName("n_bg")
		
		if get_cocos_refid(var_22_0) then
			local var_22_1 = 1000
			
			UIAction:Add(SEQ(DELAY(400), CALL(function()
				arg_22_0:createWhiteBg()
				
				local var_23_0 = EffectManager:Play({
					fn = "uieff_rift_portal_lobi_menu_iin.cfx",
					layer = var_22_0
				})
				
				EffectManager:AttachEffect(var_23_0, "uieff_rift_bg/portal", arg_22_0.vars.loop_eff)
				var_23_0:setName("crehunt_in_effect")
			end), DELAY(var_22_1), CALL(function()
				arg_22_2 = arg_22_2 or {}
				
				query("crevice_lobby", {
					difficulty = arg_22_2.is_hard_mode and 1 or 0
				})
			end)), var_22_0, "block")
		end
	end
end

function DungeonCrevice.onLeave(arg_25_0)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.parent_wnd) then
		return 
	end
	
	DungeonCreviceMain:close()
end

function DungeonCreviceMain.open(arg_26_0, arg_26_1)
	if arg_26_0.vars and get_cocos_refid(arg_26_0.vars.wnd) then
		arg_26_0:close()
	end
	
	arg_26_0.vars = {}
	arg_26_0.vars.parent_wnd = DungeonCrevice:getParentWnd()
	arg_26_0.vars.wnd = load_dlg("dungeon_crevice", true, "wnd")
	
	TopBarNew:checkhelpbuttonID("infocrevice_1")
	
	arg_26_0.vars.top_bar_cocos_uid = DungeonList:getTopBarCocosUid()
	
	arg_26_0:initDB(arg_26_1)
	arg_26_0:initUI()
	UIAction:Add(SEQ(DELAY(800), CALL(arg_26_0.slideIn, arg_26_0)), arg_26_0.vars.wnd, "block")
	arg_26_0:removeAllEvents()
	arg_26_0:addTickUpdateEvent()
	
	if get_cocos_refid(arg_26_0.vars.parent_wnd) then
		arg_26_0.vars.parent_wnd:addChild(arg_26_0.vars.wnd)
	end
end

function DungeonCreviceMain.close(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	arg_27_0:releaseAllObjects()
	arg_27_0.vars.wnd:removeFromParent()
	
	arg_27_0.vars.wnd = nil
	
	arg_27_0:removeAllEvents()
end

function DungeonCreviceMain.isOpen(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return false
	end
	
	return true
end

function DungeonCreviceMain.getParentWnd(arg_29_0)
	if not arg_29_0.vars then
		return nil
	end
	
	return arg_29_0.vars.parent_wnd
end

function DungeonCreviceMain.getWnd(arg_30_0)
	if not arg_30_0.vars then
		return nil
	end
	
	return arg_30_0.vars.wnd
end

function DungeonCreviceMain.getLeft(arg_31_0)
	if not arg_31_0.vars then
		return nil
	end
	
	return arg_31_0.vars.left
end

function DungeonCreviceMain.getRight(arg_32_0)
	if not arg_32_0.vars then
		return nil
	end
	
	return arg_32_0.vars.right
end

function DungeonCreviceMain.getEnterID(arg_33_0)
	if not arg_33_0.vars then
		return nil
	end
	
	return arg_33_0.vars.enter_id
end

function DungeonCreviceMain.isHardMode(arg_34_0)
	if not arg_34_0.vars then
		return false
	end
	
	return arg_34_0.vars.is_hard_mode
end

function DungeonCreviceMain.slideIn(arg_35_0)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.wnd) or not get_cocos_refid(arg_35_0.vars.right) or not get_cocos_refid(arg_35_0.vars.left) then
		return 
	end
	
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, NotchStatus:getNotchBaseRight()))), arg_35_0.vars.right, "block")
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, NotchStatus:getNotchBaseLeft()))), arg_35_0.vars.left, "block")
end

function DungeonCreviceMain.slideOut(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) or not get_cocos_refid(arg_36_0.vars.right) or not get_cocos_refid(arg_36_0.vars.left) then
		return 
	end
	
	UIAction:Add(SEQ(RLOG(MOVE_BY(200, 800 - NotchStatus:getNotchSafeRight())), SHOW(false)), arg_36_0.vars.right, "block")
	UIAction:Add(SEQ(RLOG(MOVE_BY(200, -600 - NotchStatus:getNotchSafeLeft())), SHOW(false)), arg_36_0.vars.left, "block")
end

function DungeonCreviceMain.createAllObjects(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0.vars.obj = {
		bg = arg_37_0.bg,
		set = arg_37_0.set,
		rune = arg_37_0.rune,
		exploit = arg_37_0.exploit,
		reward = arg_37_0.reward
	}
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.obj) do
		if not table.empty(iter_37_1) and iter_37_1.create and type(iter_37_1.create) == "function" then
			iter_37_1:create()
		end
	end
end

function DungeonCreviceMain.releaseAllObjects(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.wnd) or table.empty(arg_38_0.vars.obj) then
		return 
	end
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.obj) do
		if not table.empty(iter_38_1) and iter_38_1.release and type(iter_38_1.release) == "function" then
			iter_38_1:release()
		end
	end
end

function DungeonCreviceMain.initDB(arg_39_0, arg_39_1)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.wnd) then
		return 
	end
	
	arg_39_1 = arg_39_1 or {}
	
	if not table.empty(arg_39_1.crevice_hunt_schedules) then
		Account:setCrehuntSeasonScheduleInfo(arg_39_1.crevice_hunt_schedules)
	end
	
	if not table.empty(arg_39_1.season_info) then
		DungeonCreviceUtil:setSeasonInfo(arg_39_1.season_info)
	end
	
	if not table.empty(arg_39_1.boss_info) then
		DungeonCreviceUtil:setBossInfo(arg_39_1.boss_info)
		
		if arg_39_1.boss_info.difficulty then
			arg_39_0.vars.is_hard_mode = arg_39_1.boss_info.difficulty == 1
		end
	end
	
	arg_39_0.vars.enter_id = Account:getCrehuntSeasonEnterIDBydifficulty(arg_39_0.vars.is_hard_mode)
	arg_39_0.vars.right = arg_39_0.vars.wnd:getChildByName("RIGHT")
	arg_39_0.vars.left = arg_39_0.vars.wnd:getChildByName("LEFT")
	
	arg_39_0:createAllObjects()
end

function DungeonCreviceMain.initUI(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	if get_cocos_refid(arg_40_0.vars.right) then
		local var_40_0 = DB("level_enter", "crehunts1001", "tag_icon")
		
		arg_40_0.vars.tag_icon_name = decodeTownTagIcon(var_40_0)
		
		if arg_40_0.vars.tag_icon_name then
			arg_40_0:showSimpleInfo(true, 360, true)
		end
		
		local var_40_1 = arg_40_0.vars.right:getChildByName("n_boss")
		
		if get_cocos_refid(var_40_1) then
			local var_40_2 = arg_40_0.vars.is_hard_mode and 1 or 0
			local var_40_3 = DungeonCreviceUtil:getBossInfoWnd(var_40_2)
			
			var_40_1:addChild(var_40_3)
		end
		
		local var_40_4 = arg_40_0.vars.right:getChildByName("btn_go")
		
		if get_cocos_refid(var_40_4) then
			UIUtil:setButtonEnterInfo(var_40_4, arg_40_0.vars.enter_id, {
				use_icon_res = true
			})
		end
		
		arg_40_0:updateReadyButton()
		if_set_add_position_x(arg_40_0.vars.right, nil, 800 - NotchStatus:getNotchSafeRight())
	end
	
	if get_cocos_refid(arg_40_0.vars.left) then
		local var_40_5 = Account:getCrehuntSeasonAttribute()
		
		if var_40_5 then
			local var_40_6 = arg_40_0.vars.left:getChildByName("n_pro")
			
			if get_cocos_refid(var_40_6) then
				for iter_40_0, iter_40_1 in pairs(var_40_6:getChildren()) do
					if_set_visible(iter_40_1, nil, false)
				end
				
				if_set_visible(var_40_6, "icon_" .. var_40_5, true)
			end
			
			if_set(arg_40_0.vars.left, "txt_desc", T("crevicehunt_use_" .. var_40_5))
			if_set_add_position_x(arg_40_0.vars.left, nil, -600 - NotchStatus:getNotchSafeLeft())
		end
		
		local var_40_7 = arg_40_0.vars.left:getChildByName("n_set_tooltip")
		
		if get_cocos_refid(var_40_7) then
			var_40_7:removeAllChildren()
			var_40_7:setName("n_set_position")
			
			local var_40_8 = load_control("wnd/equip_set_info.csb")
			
			var_40_8:setName("n_set_tooltip")
			var_40_8:setVisible(false)
			var_40_8:setPositionY(var_40_8:getPositionY() + 150)
			var_40_7:addChild(var_40_8)
		end
		
		for iter_40_2, iter_40_3 in pairs(arg_40_0.vars.obj or {}) do
			if not table.empty(iter_40_3) and iter_40_3.setInfos and type(iter_40_3.setInfos) == "function" then
				iter_40_3:setInfos()
			end
		end
	end
	
	local var_40_9 = arg_40_0.vars.is_hard_mode and 1 or 0
	
	DungeonCreviceUtil:openBossResetPopup(var_40_9)
end

function DungeonCreviceMain.showSimpleInfo(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not arg_41_0.vars or not get_cocos_refid(arg_41_0.vars.wnd) then
		return 
	end
	
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_simple_info")
	
	if get_cocos_refid(var_41_0) then
		var_41_0:setVisible(false)
		UIAction:Remove(var_41_0)
		
		if arg_41_1 then
			var_41_0:setVisible(true)
			var_41_0:setScale(0)
			
			local var_41_1 = 1
			local var_41_2 = NONE()
			
			if arg_41_3 then
				var_41_2 = SEQ(DELAY(3000), RLOG(SCALE(80, 1, 0)), SHOW(false))
			end
			
			UIAction:Add(SEQ(DELAY(to_n(arg_41_2)), LOG(SCALE(150, 0, var_41_1 * 1.1)), DELAY(50), RLOG(SCALE(80, var_41_1 * 1.1, var_41_1)), var_41_2), var_41_0)
			
			local var_41_3 = T(arg_41_0.vars.tag_icon_name)
			local var_41_4 = string.replace(var_41_3, "\n", " ")
			
			if_set(var_41_0, "txt_simple_info", var_41_4)
			if_set(var_41_0, "txt_simple_info", var_41_4)
		else
			UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false)), var_41_0)
		end
	end
end

function DungeonCreviceMain.updateReadyButton(arg_42_0)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.wnd) or not get_cocos_refid(arg_42_0.vars.right) then
		return 
	end
	
	local var_42_0 = DungeonCreviceUtil:getSelectedSetIds()
	local var_42_1 = not table.empty(var_42_0) and table.count(var_42_0) == MAX_SET_COUNT
	
	if_set_opacity(arg_42_0.vars.right, "btn_go", var_42_1 and 255 or 76.5)
	
	arg_42_0.vars.is_enable_ready = var_42_1
end

function DungeonCreviceMain.goReady(arg_43_0, arg_43_1)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	if not arg_43_0.vars.is_enable_ready then
		balloon_message_with_sound("msg_crevicehunt_search_nonok")
		
		return 
	end
	
	arg_43_0:removeAllEvents()
	
	arg_43_1 = arg_43_1 or {
		enter_id = arg_43_0.vars.enter_id
	}
	
	BattleReady:show({
		skip_intro = arg_43_1.enter,
		enter_id = arg_43_1.enter_id,
		callback = arg_43_0
	})
end

function DungeonCreviceMain.getSceneState(arg_44_0)
	if not arg_44_0.vars then
		return nil
	end
	
	local var_44_0 = {
		is_hard_mode = arg_44_0.vars.is_hard_mode
	}
	
	var_44_0.no_act = true
	
	return var_44_0
end

function DungeonCreviceMain.onCloseBattleReadyDialog(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) or table.empty(arg_45_0.vars.obj) then
		return 
	end
	
	arg_45_0:removeAllEvents()
	arg_45_0:addTickUpdateEvent()
	
	local var_45_0 = arg_45_0.vars.obj.bg
	
	if not var_45_0 then
		return 
	end
	
	if var_45_0 and var_45_0.setInfos and type(var_45_0.setInfos) == "function" then
		var_45_0:setInfos()
	end
	
	if arg_45_0.vars.tag_icon_name then
		arg_45_0:showSimpleInfo(true, 360, true)
	end
end

function DungeonCreviceMain.onStartBattle(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_1 or {}
	
	startBattle(var_46_0.enter_id, {
		is_crehunt = var_46_0.is_crehunt
	})
end

function DungeonCreviceMain.onTickUpdate(arg_47_0)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.wnd) or not arg_47_0.vars.top_bar_cocos_uid then
		return 
	end
	
	if arg_47_0.vars.top_bar_cocos_uid ~= TopBarNew:getTopBarCocosUid() then
		return 
	end
	
	local var_47_0 = SceneManager:getRunningPopupScene()
	
	if var_47_0 and var_47_0:getChildByName("util.character.popup") then
		return 
	end
	
	local var_47_1 = SceneManager:getRunningScene()
	
	if not var_47_1 or not var_47_1.getTouchEventTime then
		return 
	end
	
	local var_47_2 = var_47_1:getTouchEventTime()
	
	if not var_47_2 then
		return 
	end
	
	if not (not TutorialGuide:isPlayingTutorial() and not arg_47_0.set:isOpenPopup() and not arg_47_0.rune:isOpenPopup() and not arg_47_0.exploit:isOpenPopup() and not BattleReady:getDlg() and not TopBarNew:getQuickMenuWnd()) then
		return 
	end
	
	local var_47_3 = os.time()
	local var_47_4 = 15
	
	if var_47_4 <= var_47_3 - var_47_2 and not arg_47_0.vars.fade_out then
		arg_47_0:onHideInOut(false)
		
		arg_47_0.vars.fade_out = true
	elseif var_47_4 > var_47_3 - var_47_2 and arg_47_0.vars.fade_out then
		arg_47_0:onHideInOut(true)
		
		arg_47_0.vars.fade_out = false
	end
end

function DungeonCreviceMain.onHideInOut(arg_48_0, arg_48_1)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) then
		return 
	end
	
	local var_48_0 = 1000
	local var_48_1 = "crehunt_hide_event"
	local var_48_2 = arg_48_1 and 1 or 1.3
	local var_48_3 = arg_48_1 and 0 or -200
	local var_48_4 = arg_48_1 and 0 or -100
	local var_48_5 = arg_48_1 and SEQ(SHOW(true), LOG(FADE_IN(var_48_0))) or SEQ(LOG(FADE_OUT(var_48_0)), SHOW(false))
	local var_48_6 = arg_48_0.vars.obj.bg
	
	if not var_48_6 then
		return 
	end
	
	UIAction:Remove(var_48_1)
	UIAction:Add(SPAWN(LOG(SCALE_TO(var_48_0, var_48_2)), LOG(MOVE_TO(var_48_0, var_48_3, var_48_4))), var_48_6:getWnd(), var_48_1)
	UIAction:Add(var_48_5, arg_48_0.vars.right, var_48_1)
	UIAction:Add(var_48_5, arg_48_0.vars.left, var_48_1)
	UIAction:Add(var_48_5, arg_48_0.vars.wnd:getChildByName("_grow_s"), var_48_1)
	TopBarNew:fadeInOutByCocosUid(arg_48_1, var_48_0, arg_48_0.vars.top_bar_cocos_uid)
end

function DungeonCreviceMain.addTickUpdateEvent(arg_49_0)
	if not arg_49_0.vars or not get_cocos_refid(arg_49_0.vars.wnd) then
		return 
	end
	
	Scheduler:removeByName("crehunt.onTickUpdate")
	Scheduler:add(arg_49_0.vars.wnd, arg_49_0.onTickUpdate, arg_49_0):setName("crehunt.onTickUpdate")
end

function DungeonCreviceMain.removeAllEvents(arg_50_0)
	Scheduler:removeByName("crehunt.onTickUpdate")
	UIAction:Remove("crehunt_hide_event")
	
	if arg_50_0.vars and get_cocos_refid(arg_50_0.vars.wnd) then
		if get_cocos_refid(arg_50_0.vars.right) then
			arg_50_0.vars.right:setOpacity(255)
		end
		
		if get_cocos_refid(arg_50_0.vars.left) then
			arg_50_0.vars.left:setOpacity(255)
		end
		
		local var_50_0 = arg_50_0.vars.wnd:getChildByName("_grow_s")
		
		if get_cocos_refid(var_50_0) then
			var_50_0:setOpacity(255)
		end
		
		local var_50_1 = arg_50_0.vars.obj.bg
		
		if var_50_1 then
			local var_50_2 = var_50_1:getWnd()
			
			if get_cocos_refid(var_50_2) then
				var_50_2:setPosition(0, 0)
				var_50_2:setScale(1)
			end
		end
		
		TopBarNew:fadeInOutByCocosUid(true, 0, arg_50_0.vars.top_bar_cocos_uid)
	end
end

function DungeonCreviceMain.bg.create(arg_51_0)
	if not DungeonCreviceMain:isOpen() then
		return 
	end
	
	arg_51_0.vars = {}
	arg_51_0.vars.wnd = load_control("wnd/dungeon_crevice_base.csb")
	arg_51_0.vars.layout_data = {
		{
			bone_name = "uieff_rift_bg/rift_chpos_left_02"
		},
		{
			bone_name = "uieff_rift_bg/rift_chpos_right_02",
			flip = true
		},
		{
			bone_name = "uieff_rift_bg/rift_chpos_left_01"
		},
		{
			bone_name = "uieff_rift_bg/rift_chpos_right_01",
			flip = true
		}
	}
	
	local var_51_0 = arg_51_0.vars.wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_51_0) then
		DungeonCrevice:removeWhiteBg()
		var_51_0:removeChildByName("lobby_effect")
		
		local var_51_1 = EffectManager:Play({
			fn = "uieff_rift_portal_lobi_portal_01.cfx",
			layer = var_51_0
		})
		
		arg_51_0.vars.lobby_eff = EffectManager:Play({
			fn = "uieff_rift_portal_lobi.cfx",
			layer = var_51_0
		})
		
		arg_51_0.vars.lobby_eff:setName("lobby_effect")
		EffectManager:AttachEffect(arg_51_0.vars.lobby_eff, "uieff_rift_bg/portal", var_51_1)
	end
	
	local var_51_2 = DungeonCreviceMain:getParentWnd()
	
	if get_cocos_refid(var_51_2) then
		var_51_2:addChild(arg_51_0.vars.wnd)
	end
end

function DungeonCreviceMain.bg.release(arg_52_0)
	if not arg_52_0.vars or not get_cocos_refid(arg_52_0.vars.wnd) then
		return 
	end
	
	arg_52_0.vars.wnd:removeFromParent()
	
	arg_52_0.vars.wnd = nil
	arg_52_0.vars = nil
end

function DungeonCreviceMain.bg.getWnd(arg_53_0)
	if not arg_53_0.vars then
		return nil
	end
	
	return arg_53_0.vars.wnd
end

function DungeonCreviceMain.bg.getLayoutData(arg_54_0, arg_54_1)
	if not arg_54_0.vars or not get_cocos_refid(arg_54_0.vars.wnd) then
		return nil
	end
	
	if not arg_54_1 then
		return nil
	end
	
	return arg_54_0.vars.layout_data[arg_54_1]
end

function DungeonCreviceMain.bg.getLayoutDataCount(arg_55_0)
	if not arg_55_0.vars or not get_cocos_refid(arg_55_0.vars.wnd) then
		return 0
	end
	
	return table.count(arg_55_0.vars.layout_data)
end

function DungeonCreviceMain.bg.layoutModel(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0.vars or not get_cocos_refid(arg_56_0.vars.wnd) or not get_cocos_refid(arg_56_0.vars.lobby_eff) then
		return 
	end
	
	if not get_cocos_refid(arg_56_1) or not arg_56_2 then
		return 
	end
	
	local var_56_0 = arg_56_0:getLayoutData(arg_56_2)
	
	if var_56_0 then
		if var_56_0.bone_name then
			local var_56_1 = arg_56_0.vars.lobby_eff:getPrimitiveNode(var_56_0.bone_name)
			
			if get_cocos_refid(var_56_1) then
				var_56_1:addChild(arg_56_1)
			end
		end
		
		if var_56_0.flip then
			arg_56_1:setScaleX(-arg_56_1:getScaleX())
		end
	end
end

function DungeonCreviceMain.bg.setCreviceTeamUnits(arg_57_0)
	if not arg_57_0.vars or not get_cocos_refid(arg_57_0.vars.wnd) or not get_cocos_refid(arg_57_0.vars.lobby_eff) then
		return 
	end
	
	local var_57_0 = arg_57_0:getLayoutDataCount()
	local var_57_1 = Account:getTeam(Account:getCrehuntTeamIndex())
	
	for iter_57_0 = 1, var_57_0 do
		local var_57_2 = var_57_1[iter_57_0]
		
		arg_57_0:addUnit(var_57_2, iter_57_0)
	end
end

function DungeonCreviceMain.bg.addUnit(arg_58_0, arg_58_1, arg_58_2)
	if not arg_58_0.vars or not get_cocos_refid(arg_58_0.vars.wnd) or not get_cocos_refid(arg_58_0.vars.lobby_eff) then
		return 
	end
	
	if not arg_58_1 or not arg_58_2 or arg_58_2 > arg_58_0:getLayoutDataCount() then
		return 
	end
	
	arg_58_0:removeUnit(arg_58_2)
	
	local var_58_0 = Account:getCrehuntSeasonAttribute()
	
	if not var_58_0 or var_58_0 ~= arg_58_1:getColor() then
		return 
	end
	
	local var_58_1 = CACHE:getModelWithCheckAnim(arg_58_1.db.model_id, arg_58_1.db.skin, "camping", "idle", arg_58_1.db.atlas, arg_58_1.db.model_opt)
	
	if not get_cocos_refid(var_58_1) then
		return 
	end
	
	arg_58_0:layoutModel(var_58_1, arg_58_2)
	var_58_1:setName("model_" .. arg_58_2)
	
	return var_58_1
end

function DungeonCreviceMain.bg.removeUnit(arg_59_0, arg_59_1)
	if not arg_59_0.vars or not get_cocos_refid(arg_59_0.vars.wnd) or not get_cocos_refid(arg_59_0.vars.lobby_eff) then
		return 
	end
	
	local var_59_0 = arg_59_0:getLayoutData(arg_59_1)
	
	if var_59_0 and var_59_0.bone_name then
		local var_59_1 = arg_59_0.vars.lobby_eff:getPrimitiveNode(var_59_0.bone_name)
		
		if get_cocos_refid(var_59_1) then
			local var_59_2 = var_59_1:getChildByName("model_" .. arg_59_1)
			
			if get_cocos_refid(var_59_2) then
				var_59_2:cleanupReferencedObject()
				var_59_2:removeFromParent()
			end
		end
	end
end

function DungeonCreviceMain.bg.removeAllUnit(arg_60_0)
	if not arg_60_0.vars or not get_cocos_refid(arg_60_0.vars.wnd) then
		return 
	end
	
	if table.empty(arg_60_0.vars.layout_data) then
		return 
	end
	
	local var_60_0 = arg_60_0:getLayoutDataCount()
	
	for iter_60_0 = 1, var_60_0 do
		arg_60_0:removeUnit(iter_60_0)
	end
end

function DungeonCreviceMain.bg.setInfos(arg_61_0)
	if not arg_61_0.vars or not get_cocos_refid(arg_61_0.vars.wnd) then
		return 
	end
	
	arg_61_0:removeAllUnit()
	arg_61_0:setCreviceTeamUnits()
end

function DungeonCreviceMain.set.create(arg_62_0)
	arg_62_0.vars = {}
	arg_62_0.vars.all_set_infos = DungeonCreviceUtil:getAllSetInfos()
end

function DungeonCreviceMain.set.release(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	arg_63_0:closePopup()
	
	arg_63_0.vars.all_set_infos = nil
	arg_63_0.vars.selected_sets = nil
end

function DungeonCreviceMain.set.openPopup(arg_64_0)
	if not DungeonCreviceMain:isOpen() then
		return 
	end
	
	if not arg_64_0.vars or table.empty(arg_64_0.vars.all_set_infos) then
		return 
	end
	
	if arg_64_0:isOpenPopup() then
		arg_64_0:closePopup()
	end
	
	arg_64_0.vars.wnd = load_dlg("crevice_set_choose", true, "wnd", function()
		arg_64_0:closePopup()
	end)
	
	arg_64_0:updateSetInfo()
	arg_64_0:initPopupUI()
	arg_64_0:setSelectedSetPreview()
	DungeonCreviceMain:removeAllEvents()
	TutorialGuide:procGuide()
	SceneManager:getRunningPopupScene():addChild(arg_64_0.vars.wnd)
end

function DungeonCreviceMain.set.closePopup(arg_66_0)
	if not arg_66_0.vars or not get_cocos_refid(arg_66_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		id = "crevice_set_choose",
		dlg = arg_66_0.vars.wnd
	})
	arg_66_0.vars.wnd:removeFromParent()
	
	arg_66_0.vars.wnd = nil
	
	DungeonCreviceMain:addTickUpdateEvent()
	arg_66_0:setInfos()
end

function DungeonCreviceMain.set.isOpenPopup(arg_67_0)
	if not arg_67_0.vars or not get_cocos_refid(arg_67_0.vars.wnd) then
		return false
	end
	
	return true
end

function DungeonCreviceMain.set.initPopupUI(arg_68_0)
	if not arg_68_0.vars or not get_cocos_refid(arg_68_0.vars.wnd) then
		return 
	end
	
	local var_68_0 = arg_68_0.vars.wnd:getChildByName("cm_box")
	
	if get_cocos_refid(var_68_0) then
		for iter_68_0, iter_68_1 in pairs(arg_68_0.vars.all_set_infos) do
			local var_68_1 = var_68_0:getChildByName("n_" .. tostring(iter_68_0))
			
			if get_cocos_refid(var_68_1) then
				local var_68_2 = load_control("wnd/crevice_set_choose_item.csb")
				
				var_68_1:addChild(var_68_2)
				
				if get_cocos_refid(var_68_2) then
					local var_68_3 = var_68_2:getChildByName("btn_pick")
					
					if get_cocos_refid(var_68_3) then
						var_68_3.set_info = iter_68_1
						
						var_68_3:addTouchEventListener(function(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
							if not arg_68_0.vars or not get_cocos_refid(arg_68_0.vars.wnd) then
								return 
							end
							
							if arg_69_1 == 2 then
								SoundEngine:play("event:/ui/ok")
								
								local var_69_0 = var_68_2:getChildByName("n_select")
								
								if get_cocos_refid(var_69_0) then
									local var_69_1 = arg_69_0.set_info
									
									if var_69_0:isVisible() then
										arg_68_0:deleteTempSelectedSets(var_69_1)
										var_69_0:setVisible(false)
									else
										arg_68_0:addTempSelectedSets(var_69_1, var_69_0)
									end
								end
							end
						end)
					end
					
					if_set_sprite(var_68_2, "icon_set", "item/" .. iter_68_1.icon .. ".png")
					
					for iter_68_2, iter_68_3 in pairs(arg_68_0.vars.selected_sets or {}) do
						if iter_68_1.id == iter_68_3.id then
							if_set_visible(var_68_2, "n_select", true)
						end
					end
				end
			end
		end
	end
end

function DungeonCreviceMain.set.updateSetInfo(arg_70_0)
	if not arg_70_0.vars then
		return 
	end
	
	local var_70_0 = DungeonCreviceUtil:getSelectedSetIds()
	
	arg_70_0.vars.selected_sets = {}
	
	for iter_70_0, iter_70_1 in pairs(var_70_0 or {}) do
		local var_70_1 = arg_70_0:getSetInfo(iter_70_1)
		
		if not table.empty(var_70_1) then
			table.insert(arg_70_0.vars.selected_sets, table.clone(var_70_1))
		end
	end
	
	if not table.empty(arg_70_0.vars.selected_sets) then
		table.sort(arg_70_0.vars.selected_sets, function(arg_71_0, arg_71_1)
			return arg_71_0.sort < arg_71_1.sort
		end)
	end
end

function DungeonCreviceMain.set.setInfos(arg_72_0)
	if not arg_72_0.vars then
		return 
	end
	
	arg_72_0:updateSetInfo()
	
	local var_72_0 = DungeonCreviceMain:getLeft()
	
	if not get_cocos_refid(var_72_0) then
		return 
	end
	
	local var_72_1 = var_72_0:getChildByName("n_set")
	
	if get_cocos_refid(var_72_1) then
		if_set_visible(var_72_1, "n_info", false)
		if_set_visible(var_72_1, "n_picked", false)
		
		if not table.empty(arg_72_0.vars.selected_sets) then
			local var_72_2 = var_72_1:getChildByName("n_picked")
			
			if get_cocos_refid(var_72_2) then
				var_72_2:setVisible(true)
				
				for iter_72_0, iter_72_1 in pairs(var_72_2:getChildren()) do
					if string.find(iter_72_1:getName(), "icon_set") and get_cocos_refid(iter_72_1) then
						local var_72_3 = string.len("icon_set")
						local var_72_4 = string.sub(iter_72_1:getName(), var_72_3 + 1, -1)
						local var_72_5 = tonumber(var_72_4)
						
						if arg_72_0.vars.selected_sets[var_72_5] then
							iter_72_1:setVisible(true)
							if_set_sprite(iter_72_1, nil, "item/" .. arg_72_0.vars.selected_sets[var_72_5].icon .. ".png")
						else
							iter_72_1:setVisible(false)
						end
					end
				end
			end
		else
			if_set_visible(var_72_1, "n_info", true)
		end
	end
	
	DungeonCreviceMain:updateReadyButton()
end

function DungeonCreviceMain.set.showSeletedSetInfos(arg_73_0, arg_73_1)
	UIUtil:showObtainableSetTooltip(DungeonCreviceMain:getWnd(), arg_73_0:getSelectedSetIds(), arg_73_1)
end

function DungeonCreviceMain.set.getSetInfo(arg_74_0, arg_74_1)
	if not arg_74_0.vars or table.empty(arg_74_0.vars.all_set_infos) or not arg_74_1 then
		return nil
	end
	
	for iter_74_0, iter_74_1 in pairs(arg_74_0.vars.all_set_infos) do
		if iter_74_1 and iter_74_1.id and iter_74_1.id == arg_74_1 then
			return iter_74_1
		end
	end
end

function DungeonCreviceMain.set.getSelectedSetIds(arg_75_0)
	if not arg_75_0.vars or table.empty(arg_75_0.vars.selected_sets) then
		return nil
	end
	
	local var_75_0 = {}
	
	for iter_75_0, iter_75_1 in pairs(arg_75_0.vars.selected_sets) do
		if iter_75_1 and iter_75_1.id then
			table.insert(var_75_0, iter_75_1.id)
		end
	end
	
	return var_75_0
end

function DungeonCreviceMain.set.addTempSelectedSets(arg_76_0, arg_76_1, arg_76_2)
	if not arg_76_0.vars or not get_cocos_refid(arg_76_0.vars.wnd) or not get_cocos_refid(arg_76_0.vars.wnd) then
		return 
	end
	
	if not arg_76_0.vars.selected_sets or not arg_76_1 or not get_cocos_refid(arg_76_2) then
		return 
	end
	
	if table.count(arg_76_0.vars.selected_sets) >= MAX_SET_COUNT then
		balloon_message_with_sound("msg_crevicehunt_search_popup_maxsetcount")
		
		return 
	end
	
	table.insert(arg_76_0.vars.selected_sets, arg_76_1)
	
	if not table.empty(arg_76_0.vars.selected_sets) then
		table.sort(arg_76_0.vars.selected_sets, function(arg_77_0, arg_77_1)
			return arg_77_0.sort < arg_77_1.sort
		end)
	end
	
	arg_76_2:setVisible(true)
	arg_76_0:setSelectedSetPreview()
end

function DungeonCreviceMain.set.deleteTempSelectedSets(arg_78_0, arg_78_1)
	if not arg_78_0.vars or not get_cocos_refid(arg_78_0.vars.wnd) or not get_cocos_refid(arg_78_0.vars.wnd) then
		return 
	end
	
	if not arg_78_0.vars.selected_sets or not arg_78_1 then
		return 
	end
	
	for iter_78_0, iter_78_1 in pairs(arg_78_0.vars.selected_sets) do
		if iter_78_1.id == arg_78_1.id then
			table.remove(arg_78_0.vars.selected_sets, iter_78_0)
			
			break
		end
	end
	
	arg_78_0:setSelectedSetPreview()
end

function DungeonCreviceMain.set.setSelectedSetPreview(arg_79_0)
	if not arg_79_0.vars or not get_cocos_refid(arg_79_0.vars.wnd) or not get_cocos_refid(arg_79_0.vars.wnd) then
		return 
	end
	
	if not arg_79_0.vars.selected_sets then
		return 
	end
	
	local var_79_0 = arg_79_0.vars.wnd:getChildByName("cm_box")
	
	if get_cocos_refid(var_79_0) then
		for iter_79_0 = 1, MAX_SET_COUNT do
			local var_79_1 = var_79_0:getChildByName("n_set" .. tostring(iter_79_0))
			
			if get_cocos_refid(var_79_1) then
				local var_79_2 = arg_79_0.vars.selected_sets[iter_79_0]
				
				var_79_1:setVisible(var_79_2 ~= nil)
				
				if var_79_2 and var_79_2.icon then
					SpriteCache:resetSprite(var_79_1, "item/" .. var_79_2.icon .. ".png")
				end
			end
		end
	end
	
	arg_79_0:updateSelectCompleteButton()
end

function DungeonCreviceMain.set.updateSelectCompleteButton(arg_80_0)
	if not arg_80_0.vars or not get_cocos_refid(arg_80_0.vars.wnd) or not get_cocos_refid(arg_80_0.vars.wnd) then
		return 
	end
	
	local var_80_0 = table.count(arg_80_0.vars.selected_sets) >= MAX_SET_COUNT
	
	if_set_opacity(arg_80_0.vars.wnd, "btn_yes", var_80_0 and 255 or 76.5)
end

function DungeonCreviceMain.set.sendSeletedSetInfos(arg_81_0)
	if not arg_81_0.vars or not get_cocos_refid(arg_81_0.vars.wnd) or not get_cocos_refid(arg_81_0.vars.wnd) then
		return 
	end
	
	if table.count(arg_81_0.vars.selected_sets) < MAX_SET_COUNT then
		balloon_message_with_sound("msg_crevicehunt_search_popup_nonok")
		
		return 
	end
	
	if arg_81_0:isSameBefore() then
		arg_81_0:closePopup()
		
		return 
	end
	
	query("crevice_setfx_save", {
		select_setfx = json.encode(arg_81_0:getSelectedSetIds())
	})
end

function DungeonCreviceMain.set.isSameBefore(arg_82_0)
	if not arg_82_0.vars or not get_cocos_refid(arg_82_0.vars.wnd) then
		return true
	end
	
	local var_82_0 = true
	local var_82_1 = DungeonCreviceUtil:getSelectedSetIds()
	
	if table.empty(var_82_1) then
		return false
	end
	
	for iter_82_0, iter_82_1 in pairs(var_82_1) do
		if arg_82_0.vars.selected_sets[iter_82_0] and iter_82_1 and arg_82_0.vars.selected_sets[iter_82_0].id ~= iter_82_1 then
			var_82_0 = false
		end
	end
	
	return var_82_0
end

function DungeonCreviceMain.set.onSetSeletedSetInfos(arg_83_0, arg_83_1)
	if not arg_83_0.vars or not get_cocos_refid(arg_83_0.vars.wnd) then
		return 
	end
	
	arg_83_1 = arg_83_1 or {}
	
	DungeonCreviceUtil:setSeasonInfo(arg_83_1)
	arg_83_0:closePopup()
end

function DungeonCreviceMain.rune.create(arg_84_0)
	arg_84_0.vars = {}
	arg_84_0.vars.rune_level_infos = DungeonCreviceUtil:getRuenLevelInfos()
	arg_84_0.vars.rune_unlock_infos = DungeonCreviceUtil:getRuenUnlockInfos()
	arg_84_0.vars.rune_groups = DungeonCreviceUtil:getRuneGrouplInfos()
end

function DungeonCreviceMain.rune.release(arg_85_0)
	if not arg_85_0.vars then
		return 
	end
	
	arg_85_0:closePopup()
	
	arg_85_0.vars.rune_level_infos = nil
	arg_85_0.vars.rune_unlock_infos = nil
	arg_85_0.vars.rune_groups = nil
	arg_85_0.vars.selected_runes = nil
	arg_85_0.vars.rune_exp = nil
	arg_85_0.vars.rune_level = nil
end

function DungeonCreviceMain.rune.openPopup(arg_86_0)
	if not DungeonCreviceMain:isOpen() then
		return 
	end
	
	if not arg_86_0.vars or table.empty(arg_86_0.vars.rune_groups) then
		return 
	end
	
	if arg_86_0:isOpenPopup() then
		arg_86_0:closePopup()
	end
	
	DungeonCreviceMain:slideOut()
	
	arg_86_0.vars.cur_seleted_runes = {}
	arg_86_0.vars.wnd = load_dlg("crevice_runestone", true, "wnd", function()
		arg_86_0:closePopup()
	end)
	
	arg_86_0:initPopupUI()
	
	local var_86_0 = arg_86_0.vars.wnd:getChildByName("LEFT")
	
	if get_cocos_refid(var_86_0) then
		var_86_0:setPositionX(-600 - NotchStatus:getNotchSafeLeft())
		UIAction:Add(SEQ(RLOG(MOVE_TO(400, NotchStatus:getNotchBaseLeft()))), var_86_0, "block")
	end
	
	arg_86_0:startRuneEffectAction()
	
	local var_86_1 = arg_86_0.vars.wnd:getChildByName("n_runestone")
	
	if get_cocos_refid(var_86_1) then
		var_86_1:setOpacity(0)
		UIAction:Add(SEQ(DELAY(400), FADE_IN(300)), var_86_1, "block")
	end
	
	DungeonCreviceMain:removeAllEvents()
	TutorialGuide:procGuide()
	
	local var_86_2 = DungeonCreviceMain:getParentWnd()
	
	if get_cocos_refid(var_86_2) then
		var_86_2:addChild(arg_86_0.vars.wnd)
	end
end

function DungeonCreviceMain.rune.closePopup(arg_88_0)
	if not arg_88_0.vars or not get_cocos_refid(arg_88_0.vars.wnd) then
		return 
	end
	
	DungeonCreviceMain:addTickUpdateEvent()
	DungeonCreviceMain:slideIn()
	UIAction:Add(SEQ(FADE_OUT(300), DELAY(300), REMOVE(), CALL(function()
		BackButtonManager:pop({
			id = "crevice_runestone",
			dlg = arg_88_0.vars.wnd
		})
		
		arg_88_0.vars.wnd = nil
	end)), arg_88_0.vars.wnd, "block")
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if arg_88_0:isSameBefore() then
		return 
	end
	
	local var_88_0 = {}
	
	for iter_88_0 = 1, MAX_RUNE_COUNT do
		var_88_0[iter_88_0] = arg_88_0.vars.selected_runes[iter_88_0] or 0
	end
	
	query("crevice_rune_save", {
		rune_skill = json.encode(var_88_0)
	})
end

function DungeonCreviceMain.rune.isSameBefore(arg_90_0)
	if not arg_90_0.vars then
		return true
	end
	
	local var_90_0 = true
	local var_90_1 = DungeonCreviceUtil:getSelectedRunes()
	
	if table.empty(var_90_1) then
		return false
	end
	
	for iter_90_0, iter_90_1 in pairs(arg_90_0.vars.selected_runes or {}) do
		if not var_90_1[iter_90_0] or var_90_1[iter_90_0] ~= iter_90_1 then
			var_90_0 = false
		end
	end
	
	return var_90_0
end

function DungeonCreviceMain.rune.initPopupUI(arg_91_0)
	if not arg_91_0.vars or not get_cocos_refid(arg_91_0.vars.wnd) then
		return 
	end
	
	local var_91_0 = arg_91_0.vars.wnd:getChildByName("n_energy")
	
	if get_cocos_refid(var_91_0) then
		local var_91_1 = (GAME_CONTENT_VARIABLE.crevicehunt_limit_turn or 40) + DungeonCreviceUtil:getTeamReturnAdd()
		
		if_set(var_91_0, "txt_count", T("ui_crevicehunt_limit_turn_count", {
			value = var_91_1
		}))
	end
	
	local var_91_2 = arg_91_0.vars.wnd:getChildByName("n_level")
	
	if get_cocos_refid(var_91_2) then
		local var_91_3 = GAME_CONTENT_VARIABLE.crevicehunt_runstone_maxlv or 21
		local var_91_4 = arg_91_0.vars.rune_level
		
		if var_91_4 < var_91_3 then
			UIUtil:setLevel(var_91_2:getChildByName("n_lv"), var_91_4, var_91_3, 2, false, nil, 18)
			
			local var_91_5, var_91_6 = DungeonCreviceUtil:getLevelUpInfoByExp(arg_91_0.vars.rune_exp)
			
			if var_91_5 and var_91_6 then
				if_set_percent(var_91_2, "progress", var_91_6 / var_91_5)
				if_set(var_91_2, "txt_exp", tostring(var_91_6) .. "/" .. tostring(var_91_5))
			end
		else
			if_set_visible(var_91_2, "n_max", true)
			if_set_visible(var_91_2, "n_lv", false)
			if_set_percent(var_91_2, "progress", 1)
			if_set(var_91_2, "txt_exp", "Max")
		end
		
		if_set(var_91_2, "txt_info", T("ui_crevicehunt_runestone_desc"))
		if_set(var_91_2, "txt_damage", T("ui_crevicehunt_runestone_baseskill"))
		
		local var_91_7 = DungeonCreviceUtil:getExtraDamageByExp(arg_91_0.vars.rune_exp)
		
		if_set(var_91_2, "txt_count", T("ui_crevicehunt_runestone_baseskill_count", {
			value = var_91_7
		}))
	end
	
	local var_91_8 = arg_91_0.vars.wnd:getChildByName("n_runestone")
	
	if get_cocos_refid(var_91_8) and not table.empty(arg_91_0.vars.rune_groups) and not table.empty(arg_91_0.vars.rune_unlock_infos) and arg_91_0.vars.rune_level then
		for iter_91_0, iter_91_1 in pairs(arg_91_0.vars.rune_groups) do
			local var_91_9 = var_91_8:getChildByName("n_" .. tostring(iter_91_0))
			
			if get_cocos_refid(var_91_9) then
				local var_91_10 = false
				local var_91_11 = arg_91_0.vars.rune_unlock_infos[iter_91_0]
				
				if var_91_11 and var_91_11.level then
					var_91_10 = arg_91_0.vars.rune_level >= var_91_11.level
					
					if_set_visible(var_91_9, "n_lock", not var_91_10)
					if_set(var_91_9, "txt_lock", T("ui_crevicehunt_runestone_lock_" .. tostring(iter_91_0)))
				end
				
				local var_91_12 = false
				
				for iter_91_2, iter_91_3 in pairs(iter_91_1 or {}) do
					local var_91_13 = var_91_9:getChildByName("n_rune" .. tostring(iter_91_2))
					
					if get_cocos_refid(var_91_13) then
						local var_91_14 = load_control("wnd/crevice_runestone_item.csb")
						local var_91_15 = arg_91_0:getRuneSkillIcon({
							skill_id = iter_91_3.id
						})
						
						if_set_visible(var_91_14, "n_select", false)
						
						local var_91_16 = var_91_14:getChildByName("btn_skill")
						
						if get_cocos_refid(var_91_16) then
							var_91_16.rune_info = iter_91_3
							
							var_91_16:setVisible(var_91_10)
						end
						
						local var_91_17 = var_91_14:getChildByName("n_skill")
						
						if get_cocos_refid(var_91_17) then
							var_91_17:addChild(var_91_15)
						end
						
						var_91_13:addChild(var_91_14)
						
						if not var_91_10 then
							local var_91_18 = var_91_14:getChildByName("icon")
							local var_91_19 = cc.GLProgramCache:getInstance():getGLProgram("sprite_grayscale")
							
							if var_91_19 then
								local var_91_20 = cc.GLProgramState:create(var_91_19)
								
								if var_91_20 then
									var_91_20:setUniformFloat("u_ratio", 1)
									var_91_18:setDefaultGLProgramState(var_91_20)
									var_91_18:setGLProgramState(var_91_20)
								end
							end
							
							if_set_color(var_91_14, nil, tocolor("#888888"))
						else
							if_set_color(var_91_14, nil, tocolor("#5B5B5B"))
							
							if arg_91_0.vars.selected_runes and arg_91_0.vars.selected_runes[iter_91_0] and arg_91_0.vars.selected_runes[iter_91_0] > 0 and arg_91_0.vars.selected_runes[iter_91_0] <= 3 and iter_91_3.uid == arg_91_0.vars.selected_runes[iter_91_0] then
								arg_91_0.vars.cur_seleted_runes[iter_91_0] = var_91_14
								
								if_set_visible(var_91_14, "n_select", true)
								
								var_91_12 = true
								
								local var_91_21 = var_91_9:getChildByName("n_desc")
								
								if get_cocos_refid(var_91_21) then
									var_91_21:setVisible(var_91_12)
									if_set(var_91_21, "txt_name", T(iter_91_3.name))
									if_set(var_91_21, "txt_info", T(iter_91_3.desc))
								end
								
								if_set_color(var_91_14, nil, tocolor("#FFFFFF"))
							end
						end
						
						function var_91_14.onCancel(arg_92_0)
							if_set_visible(arg_92_0, "n_select", false)
							if_set_color(arg_92_0, nil, tocolor("#5B5B5B"))
						end
						
						function var_91_14.onSelect(arg_93_0)
							if not arg_91_0.vars or not get_cocos_refid(arg_91_0.vars.wnd) or not arg_91_0.vars.selected_runes then
								return 
							end
							
							arg_91_0.vars.selected_runes[iter_91_3.group] = iter_91_3.uid
							
							if_set_visible(arg_93_0, "n_select", true)
							if_set_color(arg_93_0, nil, tocolor("#FFFFFF"))
							
							if not get_cocos_refid(var_91_9) then
								return 
							end
							
							local var_93_0 = var_91_9:getChildByName("n_desc")
							
							if get_cocos_refid(var_93_0) then
								var_93_0:setVisible(true)
								if_set(var_93_0, "txt_name", T(iter_91_3.name))
								if_set(var_93_0, "txt_info", T(iter_91_3.desc))
							end
							
							if_set_visible(var_91_9, "n_info", false)
							if_set_visible(var_91_9, "icon_noti", false)
						end
					end
				end
				
				local var_91_22 = var_91_9:getChildByName("n_info")
				
				if_set(var_91_22, "txt_info", T("ui_crevicehunt_runestone_non"))
				if_set_visible(var_91_22, nil, var_91_10 and not var_91_12)
				if_set_visible(var_91_9, "icon_noti", var_91_10 and not var_91_12)
			end
		end
	end
end

function DungeonCreviceMain.rune.onSetSeletedRuneInfos(arg_94_0, arg_94_1)
	if not arg_94_0.vars then
		return 
	end
	
	arg_94_1 = arg_94_1 or {}
	
	DungeonCreviceUtil:setSeasonInfo(arg_94_1)
	arg_94_0:setInfos()
end

function DungeonCreviceMain.rune.getRuneSkillIcon(arg_95_0, arg_95_1)
	arg_95_1 = arg_95_1 or {}
	
	local var_95_0 = arg_95_1.skill_id
	
	if not var_95_0 then
		return 
	end
	
	local var_95_1 = arg_95_1.no_tooltip
	local var_95_2 = UIUtil:getSkillIcon(nil, var_95_0, {
		hud_skill = true,
		skill_id = var_95_0,
		no_tooltip = var_95_1,
		tooltip_opts = {
			no_tooltip = true,
			skill_id = var_95_0
		}
	})
	
	var_95_2:setAnchorPoint(0, 0)
	
	for iter_95_0, iter_95_1 in pairs(var_95_2:getChildren()) do
		if iter_95_1:getName() ~= "icon" and iter_95_1:getName() ~= "" then
			iter_95_1:setVisible(false)
		end
	end
	
	return var_95_2
end

function DungeonCreviceMain.rune.getRuneSkillIdByUid(arg_96_0, arg_96_1, arg_96_2)
	if not arg_96_0.vars or not arg_96_1 or not arg_96_2 or arg_96_2 <= 0 or arg_96_2 > 3 then
		return nil
	end
	
	local var_96_0 = arg_96_0.vars.rune_groups[arg_96_1]
	
	for iter_96_0, iter_96_1 in pairs(var_96_0 or {}) do
		if iter_96_1.uid == arg_96_2 then
			return iter_96_1.id
		end
	end
end

function DungeonCreviceMain.rune.setRuneSkillIcon(arg_97_0, arg_97_1)
	if not arg_97_0.vars or not get_cocos_refid(arg_97_1) then
		return 
	end
	
	for iter_97_0 = 1, MAX_RUNE_COUNT do
		local var_97_0 = arg_97_1:getChildByName("n_skill" .. tostring(iter_97_0))
		
		if get_cocos_refid(var_97_0) then
			var_97_0:removeAllChildren()
			
			if arg_97_0.vars.selected_runes[iter_97_0] and arg_97_0.vars.selected_runes[iter_97_0] > 0 and arg_97_0.vars.selected_runes[iter_97_0] <= 3 then
				local var_97_1 = load_control("wnd/crevice_runestone_item.csb")
				local var_97_2 = false
				local var_97_3 = arg_97_0:getRuneSkillIdByUid(iter_97_0, arg_97_0.vars.selected_runes[iter_97_0])
				local var_97_4 = arg_97_0:getRuneSkillIcon({
					skill_id = var_97_3,
					no_tooltip = var_97_2
				})
				
				if_set_visible(var_97_1, "n_select", var_97_2)
				if_set_visible(var_97_1, "btn_skill", var_97_2)
				
				local var_97_5 = var_97_1:getChildByName("n_skill")
				
				if get_cocos_refid(var_97_5) then
					var_97_5:addChild(var_97_4)
				end
				
				var_97_0:setVisible(true)
				var_97_0:addChild(var_97_1)
			else
				var_97_0:setVisible(true)
			end
		end
	end
end

function DungeonCreviceMain.rune.updateRuneInfo(arg_98_0)
	if not arg_98_0.vars then
		return 
	end
	
	arg_98_0.vars.selected_runes = table.clone(DungeonCreviceUtil:getSelectedRunes() or {})
	arg_98_0.vars.rune_exp = DungeonCreviceUtil:getRuneExp()
	arg_98_0.vars.rune_level = DungeonCreviceUtil:getLevelInfoByExp(arg_98_0.vars.rune_exp)
end

function DungeonCreviceMain.rune.setInfos(arg_99_0)
	if not arg_99_0.vars then
		return 
	end
	
	arg_99_0:updateRuneInfo()
	
	local var_99_0 = DungeonCreviceMain:getLeft()
	
	if not get_cocos_refid(var_99_0) then
		return 
	end
	
	local var_99_1 = var_99_0:getChildByName("n_stone")
	
	if get_cocos_refid(var_99_1) then
		arg_99_0:setRuneSkillIcon(var_99_1)
		
		local var_99_2 = (GAME_CONTENT_VARIABLE.crevicehunt_limit_turn or 40) + DungeonCreviceUtil:getTeamReturnAdd()
		
		if_set(var_99_1, "txt_turn", var_99_2)
		
		local var_99_3 = DungeonCreviceUtil:getExtraDamageByExp(arg_99_0.vars.rune_exp)
		
		if_set(var_99_1, "txt_strong", T("ui_crevicehunt_runestone_baseskill_count", {
			value = var_99_3
		}))
		
		local var_99_4 = (GAME_CONTENT_VARIABLE.crevicehunt_runstone_maxlv or 21) <= arg_99_0.vars.rune_level and "Max" or arg_99_0.vars.rune_level
		
		if_set(var_99_1, "txt_stone", T("btn_crevicehunt_runestone", {
			value = var_99_4
		}))
		
		local var_99_5 = var_99_1:getChildByName("btn_stone")
		
		if get_cocos_refid(var_99_5) then
			if_set_visible(var_99_5, "n_noti", DungeonCreviceUtil:isRemainNotSelectedRuneGroup())
		end
	end
end

function DungeonCreviceMain.rune.isOpenPopup(arg_100_0)
	if not arg_100_0.vars or not get_cocos_refid(arg_100_0.vars.wnd) then
		return false
	end
	
	return true
end

function DungeonCreviceMain.rune.startRuneEffectAction(arg_101_0)
	if not arg_101_0.vars or not get_cocos_refid(arg_101_0.vars.wnd) then
		return 
	end
	
	local var_101_0 = arg_101_0.vars.wnd:getChildByName("LEFT")
	
	if get_cocos_refid(var_101_0) then
		local var_101_1 = var_101_0:getChildByName("n_eff")
		
		if get_cocos_refid(var_101_1) then
			var_101_1:setScale(0.7)
			var_101_1:setOpacity(0)
			if_set_opacity(var_101_1, "crevice_eff_b_l", 0)
			UIAction:Add(SEQ(DELAY(400), SPAWN(SPAWN(SCALE(300, 0.7, 1), SEQ(SPAWN(FADE_IN(300), CALL(function()
				UIAction:Add(SEQ(DELAY(270), SPAWN(SCALE(380, 1.5, 2), SEQ(LOG(OPACITY(30, 0, 1)), LOG(OPACITY(350, 1, 0))))), var_101_1:getChildByName("crevice_eff_b_l"))
			end)), LOG(OPACITY(850, 1, 0.6)))), LOOP(ROTATE(50000, 0, 360)))), var_101_1, "rune_eff")
		end
	end
end

function DungeonCreviceMain.rune.onSelectRuneSkill(arg_103_0, arg_103_1)
	if not arg_103_0.vars or not get_cocos_refid(arg_103_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_103_1) or not arg_103_0.vars.cur_seleted_runes or table.empty(arg_103_1.rune_info) then
		return 
	end
	
	local var_103_0 = arg_103_1.rune_info
	local var_103_1 = arg_103_1:getParent()
	local var_103_2 = var_103_0.group
	local var_103_3 = arg_103_0.vars.cur_seleted_runes[var_103_2]
	
	if var_103_3 == var_103_1 then
		return 
	end
	
	if get_cocos_refid(var_103_3) and var_103_3.onCancel and type(var_103_3.onCancel) == "function" then
		var_103_3:onCancel()
	end
	
	arg_103_0.vars.cur_seleted_runes[var_103_2] = var_103_1
	
	if var_103_1.onSelect and type(var_103_1.onSelect) == "function" then
		var_103_1:onSelect()
	end
end

function DungeonCreviceMain.exploit.create(arg_104_0)
	arg_104_0.vars = {}
end

function DungeonCreviceMain.exploit.release(arg_105_0)
	if not arg_105_0.vars then
		return 
	end
	
	arg_105_0:closePopup()
	
	arg_105_0.vars.cur_exploit_count = nil
	arg_105_0.vars.cur_exploit_reward_count = nil
end

function DungeonCreviceMain.exploit.updateExploitInfo(arg_106_0)
	DungeonCreviceUtil:updateRewardItems()
	
	arg_106_0.vars.cur_exploit_count = DungeonCreviceUtil:getExploitPoint()
	arg_106_0.vars.cur_exploit_reward_count = DungeonCreviceUtil:getExploitRewardPoint()
end

function DungeonCreviceMain.exploit.openPopup(arg_107_0)
	if not DungeonCreviceMain:isOpen() then
		return 
	end
	
	if not arg_107_0.vars then
		return 
	end
	
	if arg_107_0:isOpenPopup() then
		arg_107_0:closePopup()
	end
	
	DungeonCreviceMain:slideOut()
	
	arg_107_0.vars.wnd = load_dlg("crevice_pass_base", true, "wnd", function()
		arg_107_0:closePopup()
	end)
	
	arg_107_0.vars.wnd:setOpacity(0)
	arg_107_0:initPopupUI()
	UIAction:Add(FADE_IN(300), arg_107_0.vars.wnd, "block")
	DungeonCreviceMain:removeAllEvents()
	
	local var_107_0 = DungeonCreviceMain:getParentWnd()
	
	if get_cocos_refid(var_107_0) then
		var_107_0:addChild(arg_107_0.vars.wnd)
	end
end

function DungeonCreviceMain.exploit.closePopup(arg_109_0)
	if not arg_109_0.vars or not get_cocos_refid(arg_109_0.vars.wnd) then
		return 
	end
	
	DungeonCreviceMain:addTickUpdateEvent()
	arg_109_0:clearScrollViewItems()
	DungeonCreviceMain:slideIn()
	UIAction:Add(SEQ(FADE_OUT(300), DELAY(300), REMOVE(), CALL(function()
		BackButtonManager:pop({
			id = "crevice_pass_base",
			dlg = arg_109_0.vars.wnd
		})
		
		arg_109_0.vars.wnd = nil
	end)), arg_109_0.vars.wnd, "block")
end

function DungeonCreviceMain.exploit.isOpenPopup(arg_111_0)
	if not arg_111_0.vars or not get_cocos_refid(arg_111_0.vars.wnd) then
		return false
	end
	
	return true
end

function DungeonCreviceMain.exploit.initPopupUI(arg_112_0)
	if not arg_112_0.vars or not get_cocos_refid(arg_112_0.vars.wnd) then
		return 
	end
	
	local var_112_0 = arg_112_0.vars.wnd:getChildByName("n_top")
	local var_112_1 = Account:getCrehuntSeasonName()
	
	if var_112_1 then
		if_set(var_112_0, "txt_title", T(var_112_1))
	end
	
	local var_112_2 = Account:getCrehuntRemainTimeText()
	
	if_set(var_112_0, "txt_time", var_112_2)
	if_set(var_112_0, "txt_info", T("ui_crevicehunt_season_reward_desc"))
	if_set(var_112_0, "txt_accrue", T("ui_crevicehunt_season_score"))
	
	local var_112_3 = tostring(arg_112_0.vars.cur_exploit_count)
	
	if (GAME_CONTENT_VARIABLE.crevicehunt_season_score_max or 2000) <= arg_112_0.vars.cur_exploit_count then
		var_112_3 = "Max"
	end
	
	if_set(var_112_0, "txt_count", var_112_3)
	
	local var_112_4 = arg_112_0.vars.wnd:getChildByName("scroll_rewards")
	
	if get_cocos_refid(var_112_4) then
		local var_112_5 = load_control("wnd/crevice_pass_item.csb"):getContentSize()
		
		arg_112_0:initScrollView(var_112_4, var_112_5.width, var_112_5.height, {
			force_horizontal = true,
			fit_height = true
		})
		arg_112_0:updateRewardItems()
	end
	
	arg_112_0:updateReceiveAllButton()
end

function DungeonCreviceMain.exploit.updateRewardItems(arg_113_0)
	if not arg_113_0.vars or not get_cocos_refid(arg_113_0.vars.wnd) then
		return 
	end
	
	if not arg_113_0.vars.cur_exploit_count or not arg_113_0.vars.cur_exploit_reward_count then
		return 
	end
	
	arg_113_0:clearScrollViewItems()
	
	local var_113_0 = DungeonCreviceUtil:getExploitRewardItems()
	
	if not table.empty(var_113_0) then
		arg_113_0:setScrollViewItems(var_113_0)
	end
end

function DungeonCreviceMain.exploit.updateReceiveAllButton(arg_114_0)
	if not arg_114_0.vars or not get_cocos_refid(arg_114_0.vars.wnd) then
		return 
	end
	
	local var_114_0 = arg_114_0.vars.wnd:getChildByName("btn_get_all")
	
	if get_cocos_refid(var_114_0) then
		local var_114_1 = DungeonCreviceUtil:isRemainRewardItems()
		
		var_114_0:setOpacity(var_114_1 and 255 or 76.5)
		if_set_visible(var_114_0, "icon_noti", var_114_1)
	end
end

function DungeonCreviceMain.exploit.getScrollViewItem(arg_115_0, arg_115_1)
	if table.empty(arg_115_1) then
		return 
	end
	
	local var_115_0 = load_control("wnd/crevice_pass_item.csb")
	
	if_set(var_115_0, "txt_point", arg_115_1.point)
	
	local var_115_1 = var_115_0:getChildByName("btn_reward")
	
	if get_cocos_refid(var_115_1) then
		var_115_1:setVisible(not arg_115_1.is_received)
		
		if not arg_115_1.is_received then
			var_115_1.item = arg_115_1
		end
	end
	
	if_set_visible(var_115_0, "icon_locked", arg_115_1.point > arg_115_0.vars.cur_exploit_count)
	if_set_visible(var_115_0, "icon_check", arg_115_1.is_received)
	
	local var_115_2 = var_115_0:getChildByName("reward_icon")
	
	if get_cocos_refid(var_115_2) then
		local var_115_3 = 0
		
		if arg_115_1.type then
			var_115_3 = arg_115_1.type
		else
			var_115_3 = arg_115_1.reward_count
		end
		
		UIUtil:getRewardIcon(var_115_3, arg_115_1.reward_id, {
			parent = var_115_2,
			set_fx = arg_115_1.set_drop,
			grade_rate = arg_115_1.grade_rate
		})
		if_set_color(var_115_2, nil, arg_115_1.is_received and tocolor("#5B5B5B") or tocolor("#FFFFFF"))
	end
	
	return var_115_0
end

function DungeonCreviceMain.exploit.getAllRemainRewardItems(arg_116_0, arg_116_1)
	if not arg_116_0.vars or not arg_116_0.vars.cur_exploit_count then
		return 
	end
	
	if arg_116_1 and arg_116_1.point > arg_116_0.vars.cur_exploit_count then
		balloon_message_with_sound("msg_crevicehunt_season_reward_cant", {
			value = arg_116_1.point
		})
		
		return 
	end
	
	if not DungeonCreviceUtil:isRemainRewardItems() then
		balloon_message_with_sound("msg_crevicehunt_season_reward_cant2")
		
		return 
	end
	
	query("crevice_exploit_reward_get", {})
end

function DungeonCreviceMain.exploit.onSetReceivedRewardItems(arg_117_0, arg_117_1)
	if not arg_117_0.vars then
		return 
	end
	
	arg_117_1 = arg_117_1 or {}
	
	local var_117_0 = Account:addReward(arg_117_1.rewards)
	
	Dialog:msgScrollRewards(T("ui_crevicehunt_seasonreward_popup_desc"), {
		open_effect = true,
		title = T("ui_crevicehunt_seasonreward_popup_name"),
		rewards = var_117_0.rewards
	})
	DungeonCreviceUtil:setSeasonInfo(arg_117_1.season_info)
	arg_117_0:setInfos()
	arg_117_0:updateRewardItems()
	arg_117_0:updateReceiveAllButton()
end

function DungeonCreviceMain.exploit.setInfos(arg_118_0)
	if not arg_118_0.vars then
		return 
	end
	
	arg_118_0:updateExploitInfo()
	
	local var_118_0 = DungeonCreviceMain:getWnd()
	
	if not get_cocos_refid(var_118_0) then
		return 
	end
	
	local var_118_1 = var_118_0:getChildByName("btn_pass")
	
	if get_cocos_refid(var_118_1) then
		if_set_visible(var_118_1, "n_noti", DungeonCreviceUtil:isRemainRewardItems())
	end
end

function DungeonCreviceMain.reward.create(arg_119_0)
	local var_119_0 = DungeonCreviceMain:getEnterID()
	
	if not var_119_0 then
		return 
	end
	
	local var_119_1 = Account:getCrehuntSeasonScheduleID()
	
	if not var_119_1 then
		return 
	end
	
	arg_119_0.vars = {}
	arg_119_0.vars.reward_gruops = {}
	
	local var_119_2 = {}
	
	for iter_119_0 = 1, 40 do
		local var_119_3, var_119_4, var_119_5, var_119_6 = DB("level_enter_drops", var_119_0, {
			"item" .. iter_119_0,
			"type" .. iter_119_0,
			"set" .. iter_119_0,
			"grade_rate" .. iter_119_0
		})
		
		if not var_119_3 then
			break
		end
		
		local var_119_7 = {
			type = var_119_4,
			reward_id = var_119_3,
			grade_rate = var_119_6,
			set_drop = var_119_5
		}
		
		table.insert(var_119_2, var_119_7)
	end
	
	local var_119_8 = {
		type = "clear",
		id = T("ui_crevicehunt_reward")
	}
	local var_119_9 = {
		category = var_119_8,
		data = var_119_2
	}
	
	if not table.empty(var_119_2) then
		table.insert(arg_119_0.vars.reward_gruops, var_119_9)
	end
	
	local var_119_10 = {}
	
	for iter_119_1 = 1, 999 do
		local var_119_11, var_119_12, var_119_13, var_119_14, var_119_15, var_119_16, var_119_17 = DBN("crevicehunt_kill_reward_preview", iter_119_1, {
			"id",
			"season_id",
			"type",
			"reward_count",
			"show_reward_id",
			"show_grade_rate",
			"show_set_drop"
		})
		
		if not var_119_12 then
			break
		end
		
		if var_119_1 == var_119_12 then
			local var_119_18 = {
				id = var_119_11,
				type = var_119_13,
				reward_count = var_119_14,
				reward_id = var_119_15,
				grade_rate = var_119_16,
				set_drop = var_119_17
			}
			
			table.insert(var_119_10, var_119_18)
		end
	end
	
	local var_119_19 = {
		type = "kill",
		id = T("ui_crevicehunt_reward_kill")
	}
	local var_119_20 = {
		category = var_119_19,
		data = var_119_10
	}
	
	table.insert(arg_119_0.vars.reward_gruops, var_119_20)
	arg_119_0:initGroupListView()
end

function DungeonCreviceMain.reward.release(arg_120_0)
	if not arg_120_0.vars or not get_cocos_refid(arg_120_0.vars.wnd) then
		return 
	end
	
	arg_120_0.vars.reward_gruops = nil
	
	arg_120_0.vars.wnd:removeFromParent()
	
	arg_120_0.vars.wnd = nil
	arg_120_0.vars = nil
end

function DungeonCreviceMain.reward.initGroupListView(arg_121_0)
	local var_121_0 = DungeonCreviceMain:getRight()
	
	if not get_cocos_refid(var_121_0) then
		return 
	end
	
	local var_121_1 = var_121_0:getChildByName("listview_reward")
	
	if get_cocos_refid(var_121_1) then
		arg_121_0.listview = GroupListView:bindControl(var_121_1)
		
		arg_121_0.listview:setListViewCascadeOpacityEnabled(true)
		arg_121_0.listview:setEnableMargin(true)
		
		local var_121_2 = load_control("wnd/crevice_info_header.csb")
		local var_121_3 = {
			onUpdate = function(arg_122_0, arg_122_1, arg_122_2)
				if not arg_122_2 then
					return 
				end
				
				if_set_visible(arg_122_1, "n_icon", arg_122_2.type == "kill")
				if_set_visible(arg_122_1, "n_icon2", arg_122_2.type == "clear")
				if_set(arg_122_1, "txt_title", arg_122_2.id)
				UIUserData:call(arg_122_1:getChildByName("txt_name"), "SINGLE_WSCALE(320)")
			end
		}
		local var_121_4 = {
			onUpdate = function(arg_123_0, arg_123_1, arg_123_2)
				arg_121_0:updateListViewItem(arg_123_1, arg_123_2)
			end
		}
		local var_121_5 = load_control("wnd/crevice_info_item.csb")
		
		arg_121_0.listview:setRenderer(var_121_2, var_121_5, var_121_3, var_121_4)
		arg_121_0.listview:clear()
	end
end

function DungeonCreviceMain.reward.updateListViewItem(arg_124_0, arg_124_1, arg_124_2)
	if not get_cocos_refid(arg_124_1) or table.empty(arg_124_2) then
		return 
	end
	
	local var_124_0 = arg_124_1:getChildByName("n_item")
	
	if get_cocos_refid(var_124_0) then
		var_124_0:removeAllChildren()
		
		local var_124_1 = 0
		
		if arg_124_2.type then
			var_124_1 = arg_124_2.type
		else
			var_124_1 = arg_124_2.reward_count
		end
		
		UIUtil:getRewardIcon(var_124_1, arg_124_2.reward_id, {
			parent = var_124_0,
			set_fx = arg_124_2.set_drop,
			grade_rate = arg_124_2.grade_rate
		}):setAnchorPoint(0, 0)
	end
end

function DungeonCreviceMain.reward.setInfos(arg_125_0)
	if not arg_125_0.vars then
		return 
	end
	
	arg_125_0.listview:clear()
	
	for iter_125_0, iter_125_1 in pairs(arg_125_0.vars.reward_gruops) do
		arg_125_0.listview:addGroup(iter_125_1.category, iter_125_1.data)
	end
	
	local var_125_0 = DungeonCreviceMain:getRight()
	
	if not get_cocos_refid(var_125_0) then
		return 
	end
end
