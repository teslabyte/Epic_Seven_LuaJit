UnitMain = {}

function UnitMain.onPushBackground(arg_1_0)
	if not arg_1_0.vars or not arg_1_0.vars.mode then
		return 
	end
	
	local var_1_0 = arg_1_0.vars.mode_list[arg_1_0.vars.mode]
	
	if not var_1_0 or not var_1_0.onPushBackground then
		return 
	end
	
	if var_1_0 == arg_1_0 then
		return arg_1_0.vars.mode_list.Team:onPushBackground()
	end
	
	return var_1_0:onPushBackground()
end

function UnitMain.unitPopScene(arg_2_0)
	local var_2_0 = SceneManager:getNextFlowSceneName()
	
	if var_2_0 and (SubstoryManager:isRejectBackButtonNextFlowScene(var_2_0) or var_2_0 == "battle" or var_2_0 == "lota" or var_2_0 == "lota_lobby") then
		SceneManager:nextScene("lobby")
	else
		SceneManager:popScene()
	end
end

function UnitMain.onMainModePushBackButton(arg_3_0)
	arg_3_0.vars.mode_list.Team:saveTeamInfo()
	
	if arg_3_0.vars.opts.pvp_info then
		arg_3_0:endPVPMode(arg_3_0.vars.opts.pvp_info.pop_scene)
	elseif arg_3_0.vars.is_coop then
		arg_3_0:endCoopMode()
	elseif arg_3_0.vars.is_automaton then
		arg_3_0:endAutomatonMode()
	else
		arg_3_0:onLeave()
	end
end

function UnitMain.onStartModePushBackButton(arg_4_0)
	local var_4_0 = arg_4_0.vars.mode_list[arg_4_0.vars.mode]
	
	if not var_4_0 then
		return 
	end
	
	if not var_4_0.onLeave then
		return 
	end
	
	var_4_0:onLeave()
	
	arg_4_0.vars.leaving = true
	
	arg_4_0:procSideBarEnter(arg_4_0.vars.mode, nil)
	
	if arg_4_0.vars.popup_mode then
		UIAction:Add(SEQ(DELAY(300), CALL(arg_4_0.destroy, arg_4_0, true)), arg_4_0.vars.base_wnd, "block")
	else
		UIAction:Add(SEQ(DELAY(300), CALL(UnitMain.unitPopScene, UnitMain)), arg_4_0, "block")
	end
end

function UnitMain.onPushBackButton(arg_5_0)
	if arg_5_0.vars == nil then
		return 
	end
	
	arg_5_0.vars.unit_dock:closeToggleSorter()
	
	if arg_5_0.vars.mode == "Main" then
		arg_5_0:onMainModePushBackButton()
		
		return TopBarNew.BACK_BUTTON_RESULT.BACK_BUTTON_MANAGER_NEED_POP
	end
	
	if arg_5_0.vars.mode == arg_5_0.vars.start_mode then
		arg_5_0:onStartModePushBackButton()
		
		return TopBarNew.BACK_BUTTON_RESULT.BACK_BUTTON_MANAGER_NEED_POP
	end
	
	local var_5_0 = arg_5_0.vars.mode_list[arg_5_0.vars.mode]
	
	if var_5_0 and var_5_0.onPushBackButton then
		return var_5_0:onPushBackButton()
	end
end

function UnitMain.onUrgentTouchUp(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0.vars or not arg_6_0.vars.mode then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.mode_list[arg_6_0.vars.mode]
	
	if not var_6_0 or not var_6_0.onTouchUp then
		return 
	end
	
	if var_6_0 == arg_6_0 then
		return arg_6_0.vars.mode_list.Team:checkModelTouch(arg_6_1, arg_6_2)
	end
end

function UnitMain.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.vars or not arg_7_0.vars.mode then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.mode_list[arg_7_0.vars.mode]
	
	if not var_7_0 or not var_7_0.onTouchUp then
		return 
	end
	
	if var_7_0 == arg_7_0 then
		return arg_7_0.vars.mode_list.Team:onTouchUp(arg_7_1, arg_7_2)
	end
	
	return var_7_0:onTouchUp(arg_7_1, arg_7_2)
end

function UnitMain.onTouchDown(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars or not arg_8_0.vars.mode then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.mode_list[arg_8_0.vars.mode]
	
	if not var_8_0 or not var_8_0.onTouchDown then
		return 
	end
	
	if var_8_0 == arg_8_0 then
		return arg_8_0.vars.mode_list.Team:onTouchDown(arg_8_1, arg_8_2)
	end
	
	return var_8_0:onTouchDown(arg_8_1, arg_8_2)
end

function UnitMain.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars or not arg_9_0.vars.mode then
		return 
	end
	
	local var_9_0 = arg_9_0.vars.mode_list[arg_9_0.vars.mode]
	
	if not var_9_0 or not var_9_0.onTouchMove then
		return 
	end
	
	if var_9_0 == arg_9_0 then
		return arg_9_0.vars.mode_list.Team:onTouchMove(arg_9_1, arg_9_2)
	end
	
	return var_9_0:onTouchMove(arg_9_1, arg_9_2)
end

function UnitMain.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_0.vars or not arg_10_0.vars.mode then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.mode_list[arg_10_0.vars.mode]
	
	if not var_10_0 or not var_10_0.onGestureZoom then
		return 
	end
	
	if var_10_0 == arg_10_0 then
		return 
	end
	
	return var_10_0:onGestureZoom(arg_10_1, arg_10_2, arg_10_3)
end

function UnitMain.onMouseWheel(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.vars or not arg_11_0.vars.mode then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.mode_list[arg_11_0.vars.mode]
	
	if not var_11_0 or not var_11_0.onMouseWheel then
		return 
	end
	
	if var_11_0 == arg_11_0 then
		return 
	end
	
	return var_11_0:onMouseWheel(arg_11_1, arg_11_2)
end

function UnitMain.onChangeResolution(arg_12_0)
	if not arg_12_0.vars or not arg_12_0.vars.mode then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.mode_list[arg_12_0.vars.mode]
	
	if not var_12_0 or not var_12_0.onChangeResolution then
		return 
	end
	
	if var_12_0 == arg_12_0 or var_12_0 == UnitDetail then
		return 
	end
	
	return var_12_0:onChangeResolution()
end

function UnitMain.isPvpMode(arg_13_0)
	if not arg_13_0.vars then
		return false
	end
	
	return arg_13_0.vars.pvp_mode
end

function UnitMain.isDisableTopRight(arg_14_0)
	if not arg_14_0.vars then
		return false
	end
	
	return arg_14_0.vars.disable_top_right
end

function UnitMain.isCoopMode(arg_15_0)
	if not arg_15_0.vars then
		return false
	end
	
	return arg_15_0.vars.is_coop
end

function UnitMain.isAutomatonMode(arg_16_0)
	if not arg_16_0.vars then
		return false
	end
	
	return arg_16_0.vars.is_automaton
end

function UnitMain.getUsablePopupScene(arg_17_0, arg_17_1)
	if not HeroBelt:CanUseMultipleInstance() then
		return {}
	end
	
	return {
		coop = true,
		worldmap_scene = true,
		clan_war_close = true,
		world_sub = true,
		world_custom = true,
		substory_album = true,
		clan_war = true,
		substory_lobby = true,
		DungeonList = true,
		pvp_test = true
	}
end

function UnitMain.isUsablePopupScene(arg_18_0, arg_18_1)
	return arg_18_0:getUsablePopupScene()[arg_18_1]
end

function UnitMain.updatePvpCurrency(arg_19_0)
	UnitTeam:updatePvpKey()
end

function UnitMain.beginPVPMode(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_2 = arg_20_2 or {}
	
	arg_20_0:show({
		parent = arg_20_1,
		pvp_info = arg_20_2,
		hide_layer = arg_20_3,
		disable_top_right = arg_20_4
	})
	
	arg_20_0.vars.pvp_currency_updater = arg_20_0.vars.pvp_currency_updater or Scheduler:addSlow(arg_20_0.vars.wnd, arg_20_0.updatePvpCurrency, arg_20_0)
	
	arg_20_0.vars.pvp_currency_updater:setName("UnitMain.pvp_currency_updater")
end

function UnitMain.beginTournamentMode(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	arg_21_2 = arg_21_2 or {}
	
	arg_21_0:show({
		is_tournament = true,
		parent = arg_21_1,
		pvp_info = arg_21_2,
		hide_layer = arg_21_3,
		currencies = arg_21_4
	})
end

function UnitMain.beginCoopMode(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if ContentDisable:byAlias("hero") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_22_0:show({
		is_coop = true,
		parent = arg_22_1,
		hide_layer = arg_22_2,
		coop_leave_callback = arg_22_3
	})
end

function UnitMain.beginAutomatonMode(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if ContentDisable:byAlias("hero") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_23_0:show({
		is_automaton = true,
		parent = arg_23_1,
		hide_layer = arg_23_2,
		coop_leave_callback = arg_23_3
	})
end

function UnitMain.beginPopupMode(arg_24_0, arg_24_1, arg_24_2)
	if ContentDisable:byAlias("hero") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_24_1 = arg_24_1 or {}
	
	local var_24_0 = cc.Node:create()
	
	var_24_0:setName("unit_main")
	
	local var_24_1 = SceneManager:getRunningNativeScene()
	
	for iter_24_0, iter_24_1 in pairs(var_24_1:getChildren()) do
		iter_24_1._old_visible_flag = iter_24_1:isVisible()
		
		iter_24_1:setVisible(false)
	end
	
	var_24_1:addChild(var_24_0)
	
	arg_24_2 = arg_24_2 or function()
		LuaEventDispatcher:dispatchEvent("formation.res", "unit_popup_detail.update")
		LuaEventDispatcher:dispatchEvent("unit_popup_detail.close", "unit_popup_detail")
	end
	
	TouchBlocker:pushBlockingScene(SceneManager:getCurrentSceneName(), function()
		return not arg_24_0:isValid()
	end)
	TouchBlocker:pushInterrupter(SceneManager:getCurrentSceneName(), function(arg_27_0, arg_27_1, arg_27_2)
		UnitMain:popupModeTouchEventHandler(arg_27_1, arg_27_2)
	end)
	
	local var_24_2 = {
		popup_mode = true,
		mode = "Detail",
		parent = var_24_0,
		popup_leave_callback = arg_24_2
	}
	
	table.merge(var_24_2, arg_24_1)
	arg_24_0:show(var_24_2)
end

function UnitMain.popupModeTouchEventHandler(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_2 or not UnitMain:isValid() then
		return 
	end
	
	local var_28_0
	
	arg_28_2 = arg_28_2 or {}
	
	for iter_28_0, iter_28_1 in pairs(arg_28_2) do
		if iter_28_1:getId() == 0 then
			var_28_0 = iter_28_1
			
			break
		end
	end
	
	if arg_28_2 and get_cocos_refid(arg_28_2[1]) and get_cocos_refid(arg_28_2[2]) then
		local var_28_1 = arg_28_2[1]:getStartLocationInView()
		local var_28_2 = arg_28_2[1]:getLocationInView()
		local var_28_3 = arg_28_2[2]:getStartLocationInView()
		local var_28_4 = arg_28_2[2]:getLocationInView()
		local var_28_5 = math.sqrt(math.pow(var_28_3.x - var_28_1.x, 2) + math.pow(var_28_3.y - var_28_1.y, 2))
		local var_28_6 = math.sqrt(math.pow(var_28_4.x - var_28_2.x, 2) + math.pow(var_28_4.y - var_28_2.y, 2))
		local var_28_7 = arg_28_2[1]:getLocation()
		local var_28_8 = arg_28_2[2]:getLocation()
		local var_28_9 = {
			x = (var_28_7.x + var_28_8.x) * 0.5,
			y = (var_28_7.y + var_28_8.y) * 0.5
		}
		
		UnitMain:onGestureZoom(arg_28_0._gestureFactor or var_28_6, var_28_6, var_28_9)
		
		arg_28_0._gestureFactor = var_28_6
	else
		arg_28_0._gestureFactor = nil
		
		if var_28_0 then
			Scene.unit_ui:fireTouchEvent(var_28_0, arg_28_1)
		end
	end
end

function UnitMain.endPVPMode(arg_29_0, arg_29_1)
	arg_29_0:onLeave("PvP")
	TopBarNew:pop()
	UIAction:Add(SEQ(FADE_OUT(300), CALL(arg_29_0.destroy, arg_29_0, arg_29_1)), arg_29_0.vars.base_wnd, "block")
end

function UnitMain.endCoopMode(arg_30_0)
	arg_30_0:onLeave("Coop")
	TopBarNew:pop()
	UIAction:Add(SEQ(FADE_OUT(300), CALL(arg_30_0.destroy, arg_30_0, false)), arg_30_0.vars.base_wnd, "block")
	
	if arg_30_0.vars.coop_leave_callback then
		arg_30_0.vars.coop_leave_callback()
	end
end

function UnitMain.endAutomatonMode(arg_31_0)
	arg_31_0:onLeave("Automaton")
	TopBarNew:pop()
	UIAction:Add(SEQ(FADE_OUT(300), CALL(arg_31_0.destroy, arg_31_0, false)), arg_31_0.vars.base_wnd, "block")
end

function UnitMain.isValid(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_32_0.vars.base_wnd)
end

function UnitMain.isPopupMode(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	return arg_33_0.vars.popup_mode
end

function UnitMain.isLeaving(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	return arg_34_0.vars.leaving ~= nil
end

function UnitMain.show(arg_35_0, arg_35_1)
	arg_35_1 = arg_35_1 or {}
	arg_35_1.mode = arg_35_1.mode or "Main"
	arg_35_0.vars = {}
	arg_35_0.vars.mode_list = {
		Detail = UnitDetail,
		Sell = UnitSell,
		Equip = UnitEquip,
		EquipUpgrade = UnitEquipUpgrade,
		Zodiac = UnitZodiac,
		Skill = UnitSkill,
		Story = UnitStory,
		Review = UnitReview,
		Team = UnitTeam,
		Main = UnitMain,
		Upgrade = UnitUpgrade,
		Support = UnitSupport,
		Bistro = UnitBistro,
		Zoom = UnitZoom,
		Build = UnitBuild,
		MultiPromote = UnitMultiPromote,
		LevelUp = UnitLevelUp,
		Unfold = UnitUnfold,
		NewPromote = UnitNewPromote
	}
	
	if arg_35_1.is_tournament then
		arg_35_0.vars.is_tournament = true
		arg_35_0.vars.mode_list.Team = TournamentTeam
	end
	
	arg_35_0.vars.objs = {}
	arg_35_0.vars.opts = arg_35_1
	arg_35_0.vars.parent = arg_35_1.parent or SceneManager:getDefaultLayer()
	
	if SceneManager:getCurrentSceneName() == "lobby" and Lobby:getLayer() and arg_35_1.popup_mode and BattleReady:isShow() then
		arg_35_0.vars.parent = Lobby:getLayer()
	end
	
	arg_35_0.vars.prev_mode = arg_35_1.prev_mode
	arg_35_0.vars.base_wnd = load_dlg("unit_base", true, "wnd")
	
	local var_35_0 = arg_35_0.vars.base_wnd:getChildByName("port_pos")
	
	if get_cocos_refid(var_35_0) and not arg_35_0.vars.origin_port_pos then
		arg_35_0.vars.origin_port_pos = {
			x = var_35_0:getPositionX(),
			y = var_35_0:getPositionY()
		}
	end
	
	arg_35_0.vars.parent:addChild(arg_35_0.vars.base_wnd)
	
	if arg_35_0.vars.opts.hide_layer then
		arg_35_0.vars.opts.hide_layer:setVisible(false)
	end
	
	if arg_35_1.mode == "Main" then
		SoundEngine:play("event:/ui/main_hud/btn_hero")
	end
	
	arg_35_1.lobbyTeam = true
	arg_35_0.vars.start_mode = arg_35_1.start_mode or arg_35_1.mode
	arg_35_0.vars.pvp_mode = arg_35_1.pvp_info ~= nil
	arg_35_0.vars.is_coop = arg_35_1.is_coop
	arg_35_0.vars.is_automaton = arg_35_1.is_automaton
	arg_35_0.vars.coop_leave_callback = arg_35_1.coop_leave_callback
	arg_35_0.vars.popup_leave_callback = arg_35_1.popup_leave_callback
	arg_35_0.vars.popup_mode = arg_35_1.popup_mode
	arg_35_0.vars.disable_top_right = arg_35_1.disable_top_right
	
	local var_35_1 = arg_35_0.vars.base_wnd:findChildByName("bg_pack")
	
	if_set_visible(var_35_1, nil, true)
	
	arg_35_0.vars.ui_bg = UIBackground:create(var_35_1, 1, "bg_position_hero", "bg_scale_hero", {
		default_scale = 1.2,
		default_poses = {
			0,
			0,
			0
		}
	})
	
	arg_35_0:createUnitList(arg_35_1.mode, arg_35_1.unit)
	arg_35_0:initTopbar(arg_35_1)
	arg_35_0:setMode(arg_35_1.mode, arg_35_1)
	arg_35_0:initHandler()
	
	if arg_35_0.vars.popup_mode then
		DescentReady:setNormalMode()
		BurningReady:setNormalMode()
		
		if BattleReady:isValid() then
			BattleReady:setNormalMode()
		end
	end
end

function um_bsp(arg_36_0, arg_36_1)
	UnitMain:_debug_bg_setPosition(arg_36_0, arg_36_1)
end

function um_bss(arg_37_0)
	UnitMain:_debug_bg_setScale(arg_37_0)
end

function UnitMain._debug_bg_setPosition(arg_38_0, arg_38_1, arg_38_2)
	if not get_cocos_refid(arg_38_0.vars.new_bg) then
		print("CHECK BG!")
		
		return 
	end
	
	if arg_38_1 then
		arg_38_0.vars.new_bg:setPositionX(arg_38_1)
	end
	
	if arg_38_2 then
		arg_38_0.vars.new_bg:setPositionY(arg_38_2)
	end
	
	print("SET POSITION, ", arg_38_0.vars.new_bg:getPosition())
end

function UnitMain._debug_bg_setScale(arg_39_0, arg_39_1)
	if not get_cocos_refid(arg_39_0.vars.new_bg) then
		print("CHECK BG!")
		
		return 
	end
	
	if arg_39_1 then
		arg_39_0.vars.new_bg:setScale(arg_39_1)
	end
	
	print("SET SCALE, ", arg_39_0.vars.new_bg:getScale())
end

function UnitMain.setVisibleBackground(arg_40_0, arg_40_1)
	if get_cocos_refid(arg_40_0.vars.new_bg) then
		if_set_visible(arg_40_0.vars.base_wnd, "CENTER", arg_40_1)
		arg_40_0.vars.new_bg:setVisible(arg_40_1)
	end
end

function UnitMain.fadeInBackground(arg_41_0)
	arg_41_0.vars.ui_bg:fadeInBackground()
end

function UnitMain.offBackground(arg_42_0)
	arg_42_0.vars.ui_bg:offBackground()
end

function UnitMain.fadeOutBackground(arg_43_0)
	arg_43_0.vars.ui_bg:fadeOutBackground()
end

function UnitMain.isVisibleBackground(arg_44_0)
	return arg_44_0.vars.ui_bg:isVisibleBackground()
end

function UnitMain.isExistBackground(arg_45_0)
	return arg_45_0.vars.ui_bg:isExistBackground()
end

function UnitMain.getUIBackground(arg_46_0)
	if not arg_46_0:isValid() then
		return 
	end
	
	return arg_46_0.vars.ui_bg
end

function UnitMain.setBackground(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_1.bg_id and arg_47_1.id then
		arg_47_1.bg_id = DB("item_material_bgpack", arg_47_1.id, "background_id")
	end
	
	arg_47_0.vars.ui_bg:setBackground(arg_47_1, arg_47_2)
end

function UnitMain.fadeInOut(arg_48_0)
	arg_48_0.vars.ui_bg:fadeInOut()
end

function UnitMain.initTopbar(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_1 or {}
	local var_49_1 = T("hero")
	
	if arg_49_0.vars.is_tournament then
		var_49_1 = T("ui_dungeon_tournament_title")
	elseif var_49_0.pvp_info then
		var_49_1 = T("arena")
	elseif var_49_0.is_coop then
		var_49_1 = T("coop_title")
	end
	
	TopBarNew:createFromPopup(var_49_1, arg_49_0.vars.base_wnd, function()
		return arg_49_0:onPushBackButton()
	end, var_49_0.currencies)
	
	if var_49_0.info_mode and var_49_0.info_mode == "Story" then
		TopBarNew:checkhelpbuttonID("infounit1_2")
	end
	
	if var_49_0.bg then
		arg_49_0.vars.base_wnd:getChildByName("bg"):addChild(var_49_0.bg)
	end
	
	if var_49_0.unit and not arg_49_0.vars.is_tournament then
		arg_49_0.vars.unit_dock:scrollToUnit(var_49_0.unit)
		TopBarNew:setTitleName(var_49_0.unit:getName())
	end
	
	if var_49_0.pvp_info and var_49_0.pvp_info.defend_mode then
		TopBarNew:setDisableTopRight()
		
		arg_49_0.vars.block_pvp_top_bar = true
	end
end

function UnitMain.initHandler(arg_51_0)
	local function var_51_0(arg_52_0, arg_52_1)
		return true
	end
	
	local function var_51_1(arg_53_0, arg_53_1)
		return arg_51_0:onUrgentTouchUp(arg_53_0, arg_53_1)
	end
	
	local var_51_2 = SceneManager:getRunningNativeScene()
	local var_51_3 = cc.EventListenerTouchOneByOne:create()
	local var_51_4 = var_51_2:getEventDispatcher()
	
	var_51_3:registerScriptHandler(var_51_0, cc.Handler.EVENT_TOUCH_BEGAN)
	var_51_3:registerScriptHandler(var_51_1, cc.Handler.EVENT_TOUCH_ENDED)
	var_51_4:addEventListenerWithSceneGraphPriority(var_51_3, arg_51_0.vars.base_wnd)
	Scheduler:add(arg_51_0.vars.base_wnd, arg_51_0.onUpdate, arg_51_0)
end

function UnitMain.onSelectEquip(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0.vars.mode_list[arg_54_0.vars.mode]
	
	if var_54_0 and var_54_0.onSelectEquip then
		var_54_0:onSelectEquip(arg_54_1, arg_54_2)
	end
end

function UnitMain.getMode(arg_55_0)
	if arg_55_0.vars then
		return arg_55_0.vars.mode
	end
end

function UnitMain.onCreate(arg_56_0, ...)
	arg_56_0:createTeamUI()
end

function UnitMain.getStartMode(arg_57_0)
	if not arg_57_0.vars then
		return 
	end
	
	return arg_57_0.vars.start_mode
end

function UnitMain.setMode(arg_58_0, arg_58_1, arg_58_2)
	if arg_58_1 then
		Analytics:toggleTab(string.lower(arg_58_1))
	end
	
	Account:saveTeamInfo()
	set_high_fps_tick(5000)
	
	local var_58_0 = arg_58_1 == "Detail"
	
	if var_58_0 or arg_58_1 == "Upgrade" or arg_58_1 == "Zoom" or arg_58_1 == "LevelUp" then
		set_scene_fps(30)
	else
		set_scene_fps(15)
	end
	
	arg_58_2 = arg_58_2 or {}
	
	if var_58_0 and not arg_58_2.detail_mode then
		arg_58_2.detail_mode = SAVE:getKeep("unit_detail_mode") or arg_58_0:getDetailMode(arg_58_1) or "Growth"
	end
	
	local var_58_1 = (arg_58_0.vars or {}).mode
	
	if var_58_1 == arg_58_1 then
		return 
	end
	
	local var_58_2 = arg_58_0.vars.mode_list[var_58_1]
	
	if var_58_2 and var_58_2.isCanLeave and var_58_2:isCanLeave() == false then
		return 
	end
	
	local var_58_3 = arg_58_0.vars.mode_list[arg_58_1]
	
	arg_58_0.vars.start_mode = arg_58_2.set_start_mode and arg_58_1 or arg_58_0.vars.start_mode
	arg_58_0.vars.next_mode = {
		arg_58_1,
		arg_58_2
	}
	
	if var_58_3 then
		arg_58_0.vars.objs[var_58_3] = true
		
		if var_58_3.onCreate then
			var_58_3:onCreate(arg_58_2)
		end
	end
	
	arg_58_0:procMode()
	
	if var_58_0 then
		TutorialGuide:startEquipGuide()
		
		if not TopBarNew:isEnabledTopRight() and not arg_58_0.vars.block_pvp_top_bar then
			TopBarNew:setEnableTopRight()
		end
	end
	
	if arg_58_1 == "Support" then
		local var_58_4 = UnitMain:getHeroBelt()
		
		if var_58_4:isValid() then
			var_58_4:resetData(Account:getUnits(), "Support")
		end
	end
	
	GrowthGuideNavigator:proc()
end

function UnitMain.onEnter(arg_59_0, arg_59_1, arg_59_2)
	if arg_59_2.pvp_info ~= nil and arg_59_2.is_tournament then
		TopBarNew:setTitleName(T("ui_dungeon_tournament_title"))
		TopBarNew:setCurrencies(arg_59_2.currencies)
	elseif arg_59_2.pvp_info ~= nil then
		TopBarNew:setTitleName(T("arena"))
		TopBarNew:setCurrencies({
			"crystal",
			"gold",
			"pvpgold",
			"pvpkey"
		})
	elseif arg_59_2.is_coop then
		TopBarNew:setTitleName(T("coop_title"))
	else
		TopBarNew:setTitleName(T("hero"))
	end
	
	if arg_59_0.vars.mode == "Main" then
		arg_59_0.vars.mode_list.Team:onEnter(arg_59_1, arg_59_2)
		
		arg_59_0.vars.start_mode = "Main"
		
		TutorialGuide:procGuide("artifact_install")
		TutorialGuide:procGuide("pet_team")
	end
end

function UnitMain.onEnterFinished(arg_60_0)
	if arg_60_0.vars.mode == "Main" then
		TutorialGuide:procGuide("system_059")
	end
end

function UnitMain.createTeamUI(arg_61_0)
	if arg_61_0.vars.unit_team then
		return 
	end
	
	arg_61_0.vars.mode_list.Team:create(arg_61_0.vars.opts)
	
	arg_61_0.vars.unit_team = arg_61_0.vars.mode_list.Team
	
	arg_61_0.vars.unit_team.vars.wnd:setLocalZOrder(100)
	arg_61_0.vars.base_wnd:addChild(arg_61_0.vars.unit_team.vars.wnd)
	arg_61_0.vars.mode_list.Team:updateFormation()
end

function UnitMain.updateFormation(arg_62_0)
	if not arg_62_0.vars then
		return 
	end
	
	if arg_62_0.vars.mode_list and arg_62_0.vars.mode_list.Team then
		arg_62_0.vars.mode_list.Team:updateFormation()
	end
end

function UnitMain.onUpdate(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	arg_63_0:procMode()
	
	if arg_63_0.vars.mode and arg_63_0.vars.mode ~= "Main" then
		local var_63_0 = arg_63_0.vars.mode_list[arg_63_0.vars.mode]
		
		if var_63_0 and var_63_0.onAfterUpdate then
			var_63_0:onAfterUpdate()
		end
		
		return 
	end
	
	if arg_63_0.vars.mode == "Main" then
	end
end

function UnitMain.getPortraitPosition(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = arg_64_0.vars.origin_port_pos
	local var_64_1 = 1
	local var_64_2 = {
		Skill = "port_pos_skill",
		Story = "port_relationship",
		Emotion = "port_expresstion",
		Zoom = "port_zoom_h",
		Upgrade = "port_upgrade",
		DetailProfile = "port_menu3",
		DetailEquip = "port_menu2",
		DetailGrowth = "port_menu1",
		SubStory = "port_story",
		Review = "port_vote",
		DetailProfileSkin = "port_meun3_skin"
	}
	
	if var_64_2[arg_64_1] then
		local var_64_3 = arg_64_0.vars.base_wnd:getChildByName(var_64_2[arg_64_1])
		
		if get_cocos_refid(var_64_3) then
			if arg_64_2 then
				var_64_0.x = var_64_3:getPositionX()
			else
				var_64_0 = {
					x = var_64_3:getPositionX(),
					y = var_64_3:getPositionY()
				}
				var_64_1 = var_64_3:getScale()
			end
		end
	end
	
	return var_64_0, var_64_1
end

function UnitMain.movePortrait(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	if not arg_65_0.vars or not get_cocos_refid(arg_65_0.vars.base_wnd) then
		return 
	end
	
	local var_65_0 = arg_65_0.vars.base_wnd:getChildByName("port_pos")
	local var_65_1, var_65_2 = arg_65_0:getPortraitPosition(arg_65_1 or arg_65_0.vars.mode, arg_65_3)
	
	if not get_cocos_refid(var_65_0) or not var_65_1 then
		return 
	end
	
	if UIAction:Find("port_move") then
		UIAction:Remove("port_move")
	end
	
	if arg_65_2 then
		var_65_0:setPosition(var_65_1.x, var_65_1.y)
		var_65_0:setScale(var_65_2)
		
		return 
	end
	
	UIAction:Add(SPAWN(LOG(MOVE_TO(180, var_65_1.x, var_65_1.y)), LOG(SCALE_TO(180, var_65_2))), var_65_0, "port_move")
end

function UnitMain.resetPortraitPos(arg_66_0, arg_66_1)
	arg_66_0:movePortrait("Detail", arg_66_1)
end

function UnitMain.procMode(arg_67_0)
	if not arg_67_0.vars.next_mode then
		return 
	end
	
	local var_67_0 = arg_67_0.vars.next_mode[1]
	local var_67_1 = arg_67_0.vars.next_mode[2]
	
	arg_67_0.vars.next_mode = nil
	
	if arg_67_0.vars.opts then
		if arg_67_0.vars.opts.pvp_info then
			var_67_1.pvp_info = arg_67_0.vars.opts.pvp_info
		end
		
		if arg_67_0.vars.opts.is_coop then
			var_67_1.is_coop = arg_67_0.vars.opts.is_coop
		end
		
		if arg_67_0.vars.opts.is_automaton then
			var_67_1.is_automaton = arg_67_0.vars.opts.is_automaton
		end
		
		if arg_67_0.vars.opts.currencies then
			var_67_1.currencies = arg_67_0.vars.opts.currencies
		end
		
		if arg_67_0.vars.opts.is_tournament then
			var_67_1.is_tournament = arg_67_0.vars.opts.is_tournament
		end
	end
	
	if arg_67_0.vars.mode then
		local var_67_2 = arg_67_0.vars.mode_list[arg_67_0.vars.mode]
		
		if var_67_2 and var_67_2.onLeave then
			var_67_2:onLeave(var_67_0, arg_67_0.vars.mode)
		end
		
		arg_67_0.vars.prev_mode = arg_67_0.vars.mode
		arg_67_0.vars.mode = nil
	end
	
	local var_67_3 = arg_67_0.vars.prev_mode
	
	arg_67_0.vars.prev_mode = nil
	arg_67_0.vars.mode = var_67_0 or "Detail"
	
	local var_67_4 = arg_67_0.vars.mode_list[var_67_0]
	
	arg_67_0:procSideBarEnter(var_67_3, var_67_0)
	
	if var_67_4 and var_67_4.onEnter then
		var_67_4:onEnter(var_67_3, var_67_1)
		
		if var_67_0 ~= "Detail" and var_67_0 ~= "Zoom" then
			arg_67_0:movePortrait(var_67_0)
		end
	end
	
	if_set_visible(arg_67_0.vars.base_wnd, "bg", not arg_67_0:isOldBackgroundMode(var_67_0))
	arg_67_0.vars.base_wnd:sortAllChildren()
	
	arg_67_0.vars.needToShowUnitList = arg_67_0:needToShowUnitList(var_67_0)
end

function UnitMain.getDetailMode(arg_68_0, arg_68_1)
	if not arg_68_1 or not string.find(arg_68_1, "Detail") then
		return nil
	end
	
	local var_68_0 = string.len("Detail")
	local var_68_1 = string.sub(arg_68_1, var_68_0 + 1, -1)
	
	if var_68_1 == "" then
		var_68_1 = "Growth"
	end
	
	return var_68_1
end

function UnitMain.needToShowUnitList(arg_69_0, arg_69_1)
	if arg_69_1 and string.find(arg_69_1, "Detail") then
		local var_69_0 = arg_69_0:getDetailMode(arg_69_1) or UnitDetail:getCurDetailMode() or "Growth"
		
		return UnitDetail:needToShowUnitList(var_69_0)
	end
	
	return arg_69_1 == "Main" or arg_69_1 == "Sell" or arg_69_1 == "Upgrade" or arg_69_1 == "Bistro" or arg_69_1 == "Support" or arg_69_1 == "MultiPromote"
end

function UnitMain.needToShowEquipList(arg_70_0, arg_70_1)
	arg_70_1 = arg_70_1 or arg_70_0.vars.mode
	
	return arg_70_1 == "Equip" or arg_70_1 == "EquipUpgrade"
end

function UnitMain.isOldBackgroundMode(arg_71_0, arg_71_1)
	return arg_71_1 == "Main" or arg_71_1 == "Support"
end

function UnitMain.destroyOnPopupMode(arg_72_0, arg_72_1)
	TopBarNew:pop()
	
	local var_72_0
	
	for iter_72_0, iter_72_1 in pairs(SceneManager:getRunningNativeScene():getChildren()) do
		if iter_72_1._old_visible_flag then
			iter_72_1:setVisible(iter_72_1._old_visible_flag)
		else
			iter_72_1:setVisible(true)
		end
		
		iter_72_1._old_visible_flag = nil
		
		if iter_72_1:getName() == "unit_main" then
			var_72_0 = iter_72_1
		end
	end
	
	if get_cocos_refid(var_72_0) then
		var_72_0:removeFromParent()
	end
	
	if arg_72_1 then
		arg_72_1()
	end
end

function UnitMain.destroy(arg_73_0, arg_73_1)
	if not arg_73_0.vars then
		return 
	end
	
	ShareChatPopup:close()
	UnitDetailGrowth:closeGrowthBoostTooltip()
	UnitDetailGrowth:closeMoonlightDestinyTooltip()
	UnitDetailGrowth:closeBGPacks()
	arg_73_0.vars.mode_list.Team:saveTeamInfo()
	
	if SceneManager:getCurrentSceneName() ~= "waitingroom" then
		arg_73_0.vars.unit_dock:destroy()
	end
	
	if get_cocos_refid(arg_73_0.vars.base_wnd) then
		BackButtonManager:pop({
			dlg = arg_73_0.vars.base_wnd
		})
		arg_73_0.vars.base_wnd:removeFromParent()
	end
	
	for iter_73_0, iter_73_1 in pairs(arg_73_0.vars.objs) do
		if iter_73_0 ~= arg_73_0 then
			iter_73_0.vars = nil
		end
	end
	
	local var_73_0 = arg_73_0.vars.popup_mode
	local var_73_1 = arg_73_0.vars.popup_leave_callback
	
	arg_73_0.vars = nil
	
	Scheduler:remove(arg_73_0.onUpdate)
	
	if var_73_0 then
		arg_73_0:destroyOnPopupMode(var_73_1)
		
		return 
	end
	
	if arg_73_1 then
		SceneManager:popScene()
	end
end

function UnitMain.onLeave(arg_74_0, arg_74_1)
	arg_74_0.vars.mode_list.Team:onLeave(arg_74_1)
	
	if not arg_74_0:needToShowUnitList(arg_74_1) then
		arg_74_0:showUnitList(false)
	end
	
	if not arg_74_1 and get_cocos_refid(arg_74_0.vars.base_wnd) then
		arg_74_0.vars.leaving = true
		
		UIAction:Add(SEQ(DELAY(80), FADE_OUT(100), DELAY(40), CALL(arg_74_0.destroy, arg_74_0, true)), arg_74_0.vars.base_wnd, "block")
	end
	
	if arg_74_1 ~= "Detail" and arg_74_1 ~= "Build" and arg_74_0.vars.opts.hide_layer and get_cocos_refid(arg_74_0.vars.opts.hide_layer) then
		arg_74_0.vars.opts.hide_layer:setVisible(true)
	end
	
	if arg_74_1 == "PvP" then
		arg_74_0.vars.pvp_mode = false
	end
	
	if arg_74_1 == "Coop" then
		arg_74_0.vars.is_coop = false
	end
	
	if arg_74_1 == "Automaton" then
		arg_74_0.vars.is_automaton = false
		
		set_high_fps_tick(10000)
		set_scene_fps(15)
	end
	
	Scheduler:remove(arg_74_0.updatePvpCurrency)
	
	arg_74_0.vars.pvp_currency_updater = nil
end

function UnitMain.onGameEvent(arg_75_0, arg_75_1, arg_75_2)
	if arg_75_1 == "inc_equip_inven" or arg_75_1 == "inc_artifact_inven" then
		EquipBelt:UpdateEquipListCounter()
	end
	
	if not arg_75_0.vars then
		return 
	end
	
	if arg_75_0.vars.mode == "Main" then
		return 
	end
	
	local var_75_0 = arg_75_0.vars.mode_list[arg_75_0.vars.mode]
	
	if not var_75_0 then
		return 
	end
	
	if var_75_0.onGameEvent then
		var_75_0:onGameEvent(arg_75_1, arg_75_2)
	end
end

function UnitMain.leavePortrait(arg_76_0, arg_76_1, arg_76_2)
	if not arg_76_0.vars.portrait then
		return 
	end
	
	local var_76_0
	local var_76_1
	
	if arg_76_1 == "right" then
		var_76_0 = SLIDE_OUT(200, 1200)
	else
		var_76_0 = SLIDE_OUT_Y(200, -1200)
	end
	
	if arg_76_2 then
		var_76_1 = MOVE_TO(0, arg_76_0.vars.portrait:getPosition())
	elseif arg_76_0.vars.portrait.is_model then
		var_76_1 = REMOVE()
	else
		var_76_1 = REMOVE_SPRITE()
	end
	
	UIAction:Add(SEQ(var_76_0, var_76_1), arg_76_0.vars.portrait, "block")
	
	if not arg_76_2 then
		UnitMain.vars.portrait = nil
	end
end

function UnitMain.enterPortrait(arg_77_0, arg_77_1)
	if not arg_77_0.vars.portrait then
		return 
	end
	
	local var_77_0
	
	if arg_77_1 == "right" then
		var_77_0 = SLIDE_IN(200, -1200)
	else
		var_77_0 = SLIDE_IN_Y(200, 1200)
	end
	
	UIAction:Add(var_77_0, arg_77_0.vars.portrait, "block")
end

function UnitMain.getPortrait(arg_78_0, arg_78_1)
	if not arg_78_1 or arg_78_0.vars.portrait then
		return arg_78_0.vars.portrait
	end
	
	return arg_78_0:changePortrait(arg_78_1, true)
end

function UnitMain.testPortrait(arg_79_0, arg_79_1)
	if arg_79_0.vars.portrait.is_model then
		arg_79_0.vars.portrait:setSkin(arg_79_1)
	end
end

function UnitMain.testBlack(arg_80_0, arg_80_1)
	local var_80_0 = cc.c3b(60, 60, 60)
	local var_80_1 = cc.c3b(255, 255, 255)
	
	if arg_80_0.vars.portrait.is_model and arg_80_1 then
		arg_80_0.vars.portrait:setColor(var_80_0)
	else
		arg_80_0.vars.portrait:setColor(var_80_1)
	end
end

function UnitMain.removePortrait(arg_81_0)
	if not arg_81_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_81_0.vars.portrait) then
		arg_81_0.vars.portrait:removeFromParent()
		
		arg_81_0.vars.portrait = nil
	end
end

function UnitMain.changePortrait(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	if not arg_82_0.vars then
		return 
	end
	
	local var_82_0 = arg_82_0.vars.portrait
	
	if var_82_0 then
		if arg_82_1 == var_82_0.unit then
			return 
		end
		
		if arg_82_2 then
			var_82_0:removeFromParent()
		else
			local var_82_1 = arg_82_3 == "right" and -600 or 600
			
			if var_82_0.is_model then
				UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, var_82_1), 300), FADE_OUT(250)), REMOVE()), var_82_0)
			else
				UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, var_82_1), 300), FADE_OUT(250)), REMOVE_SPRITE()), var_82_0)
			end
		end
	end
	
	local var_82_2 = arg_82_0.vars.base_wnd:getChildByName("port_pos")
	
	if not arg_82_0.vars.origin_port_pos then
		arg_82_0.vars.origin_port_pos = {
			x = var_82_2:getPositionX(),
			y = var_82_2:getPositionY()
		}
	end
	
	arg_82_0.vars.portrait = nil
	
	local var_82_3 = UIUtil:getPortraitAni(arg_82_1.db.face_id, {
		parent_pos_y = arg_82_0.vars.origin_port_pos.y
	})
	
	arg_82_0:setPortraitEmotion(arg_82_1, var_82_3)
	var_82_3:setAnchorPoint(0.5, 0)
	var_82_3:setLocalZOrder(1)
	var_82_3:setPositionX(0)
	var_82_2:addChild(var_82_3)
	
	arg_82_0.vars.portrait = var_82_3
	arg_82_0.vars.portrait.unit = arg_82_1
	
	if not arg_82_2 then
		local var_82_4 = arg_82_3 == "right" and -1600 or 1600
		
		var_82_3:setOpacity(0)
		UIAction:Add(SEQ(SPAWN(LOG(SCALE(250, 0, 0.8), 300), LOG(SLIDE_IN(250, var_82_4, false), 300), FADE_IN(250))), var_82_3)
	else
		var_82_3:setScale(0.8)
	end
	
	return arg_82_0.vars.portrait
end

function UnitMain.getPortraitOriginPos(arg_83_0)
	return arg_83_0.vars and arg_83_0.vars.origin_port_pos
end

function UnitMain.playPortraitWhiteEffect(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
	arg_84_3 = arg_84_3 or "port_pos"
	
	local var_84_0, var_84_1 = UIUtil:getPortraitAni(arg_84_1)
	
	arg_84_0.vars.base_wnd:getChildByName(arg_84_3):addChild(var_84_0)
	var_84_0:setLocalZOrder(2)
	
	local var_84_2 = arg_84_0:getPortrait():getScale()
	
	var_84_0:setScale(var_84_2)
	
	local var_84_3 = var_84_0:getContentSize().height * var_84_2 / 2
	
	if var_84_1 then
		var_84_0:setPositionY(-460)
	else
		var_84_0:setPositionY(0)
	end
	
	local var_84_4
	local var_84_5
	
	if arg_84_2 then
		var_84_5 = 30
		var_84_4 = OPACITY(500, 1, 0)
	else
		var_84_5 = 5
		var_84_4 = LOG(OPACITY(300, 1, 0))
	end
	
	UIAction:Add(SEQ(SPAWN(BLEND(10, "white", 0, 1), RLOG(SCALE(590, 0.8, var_84_5)), var_84_4), REMOVE()), var_84_0)
end

function UnitMain.isPortraitUseMode(arg_85_0, arg_85_1)
	local var_85_0 = {
		"Upgrade",
		"Zoom",
		"Review",
		"Detail",
		"Skill",
		"LevelUp",
		"NewPromote",
		"DetailGrowth",
		"DetailEquip",
		"DetailProfile",
		"DetailProfileSkin"
	}
	
	for iter_85_0, iter_85_1 in pairs(var_85_0) do
		if iter_85_1 == arg_85_1 then
			return true
		end
	end
	
	return false
end

function UnitMain.getSceneState(arg_86_0)
	if not arg_86_0.vars then
		return 
	end
	
	local var_86_0 = {}
	
	if arg_86_0.vars.mode == "Main" then
	else
		local var_86_1 = arg_86_0.vars.mode_list[arg_86_0.vars.mode]
		
		if var_86_1 and var_86_1.getSceneState then
			var_86_0 = var_86_1:getSceneState()
		end
	end
	
	var_86_0.mode = arg_86_0.vars.mode
	
	return var_86_0
end

function UnitMain.showUnitList(arg_87_0, arg_87_1)
	local var_87_0 = arg_87_0.vars.unit_dock:getWindow()
	
	if not get_cocos_refid(var_87_0) then
		return 
	end
	
	local var_87_1 = var_87_0.ox or var_87_0:getPositionX()
	
	if UIAction:Find("unit_list_show") then
		UIAction:Remove("unit_list_show")
	end
	
	if arg_87_1 then
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, var_87_1 - 300), 100)), var_87_0, "unit_list_show")
	else
		UIAction:Add(SEQ(MOVE_TO(200, var_87_1 + 300), SHOW(false)), var_87_0, "unit_list_show")
	end
end

function UnitMain.procSideBarEnter(arg_88_0, arg_88_1, arg_88_2)
	if arg_88_2 == "Detail" then
		return 
	end
	
	if not arg_88_0:needToShowUnitList(arg_88_1) and arg_88_0:needToShowUnitList(arg_88_2) then
		arg_88_0:showUnitList(true)
	end
	
	if not arg_88_0:needToShowUnitList(arg_88_2) and arg_88_0:needToShowUnitList(arg_88_1) then
		arg_88_0:showUnitList(false)
	end
	
	if arg_88_1 == nil and arg_88_2 and not arg_88_0:needToShowUnitList(arg_88_2) then
		arg_88_0.vars.unit_dock:getWindow():setVisible(false)
	end
end

function UnitMain.getHeroBelt(arg_89_0)
	return arg_89_0.vars.unit_dock
end

function UnitMain.createUnitList(arg_90_0, arg_90_1, arg_90_2)
	arg_90_0.vars.unit_dock = HeroBelt:createInstance(arg_90_1, true)
	
	arg_90_0.vars.unit_dock:setEventHandler(arg_90_0.onHeroListEvent, arg_90_0)
	
	local var_90_0 = arg_90_0.vars.unit_dock:getWindow()
	
	var_90_0:setLocalZOrder(9999)
	arg_90_0.vars.base_wnd:addChild(arg_90_0.vars.unit_dock:getWindow())
	
	local var_90_1 = SceneManager:getCurrentSceneName()
	local var_90_2 = table.shallow_clone(Account:getUnits())
	local var_90_3 = {}
	
	if var_90_1 == "pvp_team" then
		for iter_90_0, iter_90_1 in pairs(var_90_2) do
			if not iter_90_1:isGrowthBoostRegistered() then
				table.insert(var_90_3, iter_90_1)
			end
		end
	else
		var_90_3 = var_90_2
	end
	
	arg_90_0.vars.unit_dock:resetData(var_90_3, arg_90_1, arg_90_2)
	
	if not var_90_0.ox then
		local var_90_4 = var_90_0:getPositionX() + 300
		
		var_90_0:setPositionX(var_90_4)
		
		var_90_0.ox = var_90_4
	end
end

function UnitMain.disableUnitList(arg_91_0)
	if arg_91_0.vars.unit_dock then
		arg_91_0.vars.unit_dock:removeEventHandler()
	end
end

function UnitMain.onHeroListEvent(arg_92_0, arg_92_1, arg_92_2, arg_92_3)
	if arg_92_1 == "select" then
		arg_92_0:onSelectUnit(arg_92_2, arg_92_3)
	end
	
	if arg_92_1 == "change" then
		if arg_92_0.vars.mode == "Detail" then
			UnitDetail:onChangeUnit(arg_92_3)
		elseif arg_92_0.vars.mode == "Skill" then
			UnitSkill:onChangeUnit(arg_92_3)
		end
		
		if arg_92_0.vars.unit_dock:isScrolling() then
			vibrate(VIBRATION_TYPE.Select)
		end
	end
	
	if arg_92_0.vars.mode then
		local var_92_0 = arg_92_0.vars.mode_list[arg_92_0.vars.mode]
		
		if var_92_0 and var_92_0.onHeroListEventForFormationEditor then
			var_92_0:onHeroListEventForFormationEditor(arg_92_1, arg_92_2, arg_92_3)
		end
	end
end

function UnitMain.onHeroListEventForFormationEditor(arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	arg_93_0.vars.mode_list.Team:onHeroListEventForFormationEditor(arg_93_1, arg_93_2, arg_93_3)
end

function UnitMain.onSelectUnit(arg_94_0, arg_94_1, arg_94_2)
	if arg_94_0.vars.mode == "Main" then
		if not arg_94_0.vars.unit_team:onSelectUnit(arg_94_1, arg_94_2) and arg_94_2 then
			local var_94_0 = arg_94_0.vars.unit_team.vars.pvp_info ~= nil
			
			arg_94_0:setMode("Detail", {
				unit = arg_94_1,
				pvp_mode = var_94_0
			})
		end
	else
		local var_94_1 = arg_94_0.vars.mode_list[arg_94_0.vars.mode]
		
		if var_94_1 and var_94_1.onSelectUnit then
			if var_94_1.onSelectUnitViaTouch then
				var_94_1:onSelectUnitViaTouch(arg_94_1, arg_94_2)
			else
				var_94_1:onSelectUnit(arg_94_1, arg_94_2)
			end
		end
	end
end

function UnitMain.isShow(arg_95_0)
	if not arg_95_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_95_0.vars.base_wnd)
end

function UnitMain.getWnd(arg_96_0)
	if not arg_96_0.vars then
		return nil
	end
	
	return arg_96_0.vars.base_wnd
end

function UnitMain.isVisible(arg_97_0)
	return arg_97_0.vars ~= nil
end

function UnitMain.setPortraitEmotion(arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	arg_98_3 = arg_98_3 or arg_98_1:getFaceID()
	
	if arg_98_3 and arg_98_2 and arg_98_2.setSkin then
		arg_98_2:setSkin(arg_98_3)
	end
end

function UnitMain.setMainUnitSkin(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	if not arg_99_1 or not arg_99_2 or not arg_99_3 then
		return 
	end
	
	local var_99_0 = DB("character", arg_99_1, "emotion_id")
	
	if var_99_0 then
		local var_99_1 = arg_99_3 + 1
		local var_99_2 = DB("character_intimacy_level", var_99_0 .. "_" .. var_99_1, {
			"emotion"
		})
		
		if var_99_2 then
			arg_99_0:setPortraitEmotion(nil, arg_99_2, var_99_2)
		end
	end
end

function UnitMain.updateGrow(arg_100_0, arg_100_1)
	if not arg_100_0.vars then
		return 
	end
	
	if_set_visible(arg_100_0.vars.base_wnd, "_grow_1_2", arg_100_1)
end
