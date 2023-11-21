function HANDLER.battle_map(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	UIUtil:checkBtnTouchPos(arg_1_0, arg_1_3, arg_1_4)
	
	if arg_1_1 == "btn_zoom_out" then
		if WorldMapManager:getNavigator():isOpenNavi() then
			return 
		end
		
		local var_1_0 = WorldMapManager:getController()
		
		if var_1_0:getCustomContinent() == "slide" then
			WorldMapLandSlideUI:create(var_1_0)
			
			return 
		end
		
		var_1_0:zoom("OUT")
		
		local var_1_1 = var_1_0:getBGM()
		
		SoundEngine:playBGM(var_1_1)
		TutorialGuide:procGuide()
		
		if TutorialGuide:isPlayingTutorial() then
			UIAction:Add(DELAY(500), SceneManager:getDefaultLayer(), "block")
		end
		
		return 
	end
	
	if arg_1_1 == "btn_start" then
		if not getParentWindow(arg_1_0).controller:isPlayCloudEffect() then
			getParentWindow(arg_1_0).controller:showMapDialog(getParentWindow(arg_1_0).controller:getTargetTown() or getParentWindow(arg_1_0).controller:getCurrentTown())
			TutorialGuide:procGuide()
		end
		
		return 
	end
	
	if arg_1_1 == "btn_last_location" then
		local var_1_2 = getParentWindow(arg_1_0).controller.vars.town:getLastClearTown()
		
		getParentWindow(arg_1_0).controller:showMapDialog(var_1_2, {
			no_info = true
		})
		
		return 
	end
	
	if arg_1_1 == "btn_star_reward" then
		if arg_1_0.state == 3 then
			balloon_message_with_sound("not_yet_take_star_reward")
		elseif arg_1_0.state == 2 then
			local var_1_3 = SubstoryManager:getInfo()
			local var_1_4
			
			if var_1_3 then
				var_1_4 = var_1_3.id
			end
			
			local var_1_5 = WorldMapManager:getController():getMapKey()
			local var_1_6 = getParentWindow(arg_1_0).parent
			
			query("set_worldmap_reward", {
				map_key = var_1_5,
				count = var_1_6.star_data.cur_count,
				substory_id = var_1_4
			})
		else
			balloon_message_with_sound("taked_all")
		end
		
		return 
	end
	
	if arg_1_1 == "btn_help" then
		local var_1_7 = SubstoryManager:getInfo()
		
		if var_1_7 then
			HelpGuide:open({
				contents_id = var_1_7.help_id .. "_1_1"
			})
		end
		
		return 
	end
	
	if arg_1_1 == "btn_spread" or arg_1_1 == "btn_fold" then
		SubstoryCustomItemPopup:toggleCustomItemUI()
		
		return 
	end
	
	if arg_1_1 == "btn_force" then
		ShopChapterForceDetail:show()
		
		return 
	end
	
	if arg_1_1 == "btn_adin" then
		if TutorialGuide:isPlayingTutorial() then
			TutorialGuide:procGuide()
		end
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.ADIN
		}, function()
			EpisodeAdinUI:show()
		end)
	end
end

function MsgHandler.set_worldmap_reward(arg_3_0)
	if arg_3_0.rewards then
		local var_3_0 = {
			title = T("star_reward_title"),
			desc = T("star_reward_desc")
		}
		
		Account:addReward(arg_3_0.rewards, {
			play_reward_data = var_3_0
		})
	end
	
	local var_3_1 = SceneManager:getCurrentScene()
	local var_3_2 = WorldMapManager:getController()
	local var_3_3 = var_3_2:getMapKey()
	
	Account:setWorldmapRwards(var_3_3, tonumber(arg_3_0.count))
	var_3_2:getWorldMapUI():setRewardStar(var_3_3)
	var_3_2:getWorldMapUI():update(var_3_3)
	
	local var_3_4 = SubstoryManager:getInfo()
	
	if var_3_4 then
		ConditionContentsManager:dispatch("substory.star.reward", {
			substory_id = var_3_4.id
		})
	end
end

WorldMapUICommon = WorldMapUICommon or {}

function WorldMapUICommon.setRewardStar(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or arg_4_0.controller:getMapKey()
	arg_4_0.reward_star = AccountData.worldmap_rewards[arg_4_1] or 0
	
	arg_4_0:update(arg_4_1)
end

function WorldMapUICommon.create(arg_5_0, arg_5_1)
	arg_5_0.controller = arg_5_1
	
	local var_5_0 = arg_5_0:initUI()
	
	arg_5_0.navi = AdvMissionNavigator
	
	arg_5_0.navi:init(arg_5_0.RIGHT, arg_5_0.controller, arg_5_0)
	arg_5_0.navi:updateQuest()
	
	return var_5_0
end

function WorldMapUICommon._createTopbar(arg_6_0, arg_6_1)
end

function WorldMapUICommon.initUI(arg_7_0)
	local var_7_0 = cc.Layer:create()
	
	arg_7_0.layer = var_7_0
	arg_7_0.reward_star = 0
	arg_7_0.touched = false
	
	local var_7_1
	local var_7_2 = load_dlg("battle_map", true, "wnd")
	
	if_set_visible(var_7_2, "n_right_back", false)
	
	var_7_2.parent = arg_7_0
	var_7_2.controller = arg_7_0.controller
	
	var_7_2:setAnchorPoint(0, 0)
	var_7_2:setPosition(0, 0)
	var_7_0:addChild(var_7_2)
	
	arg_7_0.wnd = var_7_2
	arg_7_0.LEFT = arg_7_0.wnd:getChildByName("LEFT")
	arg_7_0.RIGHT = arg_7_0.wnd:getChildByName("RIGHT")
	arg_7_0.CENTER = var_7_2:getChildByName("CENTER")
	
	arg_7_0.CENTER:setVisible(false)
	
	local var_7_3 = arg_7_0.CENTER:getChildByName("n_content"):getChildByName("n_change")
	
	WorldMapUIButtons:addButtons(var_7_3)
	if_set_visible(arg_7_0.RIGHT, "n_normal_lv", true)
	if_set_visible(var_7_2, "btn_achieve", false)
	if_set_visible(var_7_2, "btn_shop", false)
	arg_7_0:setEnableContentsUI()
	arg_7_0:setCustomItemUI()
	if_set_visible(var_7_2, "dim_img", false)
	Scheduler:addSlow(arg_7_0.wnd, arg_7_0.onAfterUpdate, arg_7_0)
	if_set_visible(var_7_2, "n_world_lv", false)
	Scheduler:addSlow(arg_7_0.wnd, arg_7_0.onAfterUpdate, arg_7_0)
	if_set_visible(arg_7_0.wnd, "n_force", false)
	if_set_visible(arg_7_0.wnd, "n_adin", false)
	if_set_visible(arg_7_0.wnd, "n_npc_force", false)
	if_set_visible(arg_7_0.wnd, "n_npc_portrait", false)
	
	return var_7_0
end

function WorldMapUICommon.updateStarRewardUI(arg_8_0, arg_8_1)
	if not get_cocos_refid(arg_8_0.wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0.wnd:getChildByName("n_star_rewards")
	local var_8_1 = false
	
	if not get_cocos_refid(var_8_0) then
		return 
	end
	
	if get_cocos_refid(var_8_0.reward_eff) then
		var_8_0.reward_eff:removeFromParent()
		
		var_8_0.reward_eff = nil
	end
	
	local var_8_2 = var_8_0:getChildByName("n_reward")
	local var_8_3 = var_8_2:getChildByName("n_star_reward_count")
	local var_8_4 = arg_8_0.star_data.cur_count
	local var_8_5 = arg_8_0.star_data.max_count
	
	if_set(var_8_0, "label_star_num", var_8_4 .. "/" .. var_8_5)
	
	local var_8_6 = var_8_2:getChildByName("btn_star_reward")
	
	var_8_6.state = 0
	
	for iter_8_0 = 1, 3 do
		local var_8_7 = var_8_2:getChildByName("n_reward_item" .. iter_8_0)
		local var_8_8 = var_8_2:getChildByName("icon_noti_reward" .. iter_8_0)
		local var_8_9 = var_8_2:getChildByName("icon_check_reward" .. iter_8_0)
		
		if not get_cocos_refid(var_8_7) or not get_cocos_refid(var_8_8) or not get_cocos_refid(var_8_9) then
			break
		end
		
		if_set(var_8_3, "label_star_num" .. iter_8_0, arg_8_0.star_data.needs[iter_8_0])
		UIUtil:getRewardIcon(arg_8_0.star_data.rewardDB[iter_8_0].count, arg_8_0.star_data.rewardDB[iter_8_0].id, {
			show_small_count = true,
			no_hero_name = true,
			scale = 0.8,
			detail = true,
			parent = var_8_7
		})
		
		local var_8_10 = arg_8_0.star_data.state[iter_8_0] == 1
		local var_8_11 = arg_8_0.star_data.state[iter_8_0] == 2
		
		if_set_visible(var_8_9, nil, var_8_10)
		if_set_visible(var_8_8, nil, var_8_11)
		if_set_color(var_8_7, nil, var_8_10 and tocolor("#888888") or tocolor("#FFFFFF"))
		if_set_visible(var_8_8, nil, var_8_11)
		
		if var_8_6.state ~= 2 then
			var_8_6.state = arg_8_0.star_data.state[iter_8_0]
		end
		
		if var_8_11 and not var_8_1 then
			var_8_1 = true
			var_8_0.reward_eff = EffectManager:Play({
				pivot_x = 185,
				fn = "uieff_chapter_reward.cfx",
				pivot_y = 69,
				pivot_z = 99998,
				layer = var_8_0
			})
			
			var_8_0.reward_eff:setAnchorPoint(0.5, 0.5)
		end
	end
	
	local var_8_12 = var_8_0:getChildByName("n_star_progress")
	
	if var_8_12 and not var_8_12.gauge then
		var_8_12:setVisible(true)
		
		local var_8_13 = WidgetUtils:createCircleProgress("img/cm_hero_circool1.png")
		
		var_8_13:setCascadeOpacityEnabled(true)
		
		local var_8_14 = var_8_12:getChildByName("progress_bar")
		
		var_8_14:setVisible(false)
		var_8_13:setScale(var_8_14:getScale())
		var_8_13:setPositionX(var_8_14:getPositionX())
		var_8_13:setPositionY(var_8_14:getPositionY())
		var_8_13:setOpacity(var_8_14:getOpacity())
		var_8_13:setColor(var_8_14:getColor())
		var_8_13:setReverseDirection(false)
		var_8_13:setName("_progress")
		var_8_12:addChild(var_8_13)
		
		var_8_12.gauge = var_8_13
	end
	
	if not var_8_1 and get_cocos_refid(var_8_0.reward_eff) then
		var_8_0.reward_eff:removeFromParent()
		
		var_8_0.reward_eff = nil
	end
	
	local var_8_15 = var_8_4 / var_8_5 * 100
	local var_8_16 = math.floor(var_8_15)
	
	var_8_12.gauge:setPercentage(var_8_16)
end

function WorldMapUICommon.setEnableContentsUI(arg_9_0)
end

function WorldMapUICommon.setCustomItemUI(arg_10_0)
end

function WorldMapUICommon.setVisibleWorldMapUI(arg_11_0, arg_11_1)
	if_set_visible(arg_11_0.wnd, "LEFT", arg_11_1)
	if_set_visible(arg_11_0.wnd, "n_zoom", arg_11_1)
	if_set_visible(arg_11_0.wnd, "n_quest_navi", arg_11_1)
	arg_11_0:updateCustomUI()
end

function WorldMapUICommon.setVisibleDefault(arg_12_0)
	if arg_12_0.controller.vars.mode == "TOWN" then
		if_set_visible(arg_12_0.wnd, "RIGHT", true)
		if_set_visible(arg_12_0.wnd, "LEFT", true)
	elseif arg_12_0.controller.vars.mode == "LAND" then
		if_set_visible(arg_12_0.wnd, "RIGHT", true)
		if_set_visible(arg_12_0.wnd, "LEFT", false)
	else
		if_set_visible(arg_12_0.wnd, "RIGHT", false)
		if_set_visible(arg_12_0.wnd, "LEFT", false)
		arg_12_0.wnd:getChildByName("n_quest_navi"):setVisible(false)
	end
	
	arg_12_0:setBattleEnterBtn()
end

function WorldMapUICommon.setMapMagnifier(arg_13_0, arg_13_1)
	if arg_13_1 == "TOWN" then
		if_set_opacity(arg_13_0.wnd, "btn_zoom_out", 255)
	elseif arg_13_1 == "LAND" then
		if_set_opacity(arg_13_0.wnd, "btn_zoom_out", 255)
		
		local var_13_0 = arg_13_0.wnd:getChildByName("n_npc_info")
		
		if get_cocos_refid(var_13_0) then
			var_13_0:setVisible(false)
		end
	else
		if_set_opacity(arg_13_0.wnd, "btn_zoom_out", 80)
	end
	
	arg_13_0:setVisibleDefault()
end

function WorldMapUICommon.sliderTouchEvent(arg_14_0, arg_14_1)
	if arg_14_1 == 2 then
		if Action:Find("worldmap_action") then
			self:setMapMagnifier(self.controller.vars.mode)
			
			return 
		end
		
		if arg_14_0:getPercent() > 75 and arg_14_0:getPercent() <= 100 then
			self.controller:changeMode("TOWN")
		elseif arg_14_0:getPercent() > 50 and arg_14_0:getPercent() <= 75 then
			self.controller:changeMode("LAND")
			self.controller:stopSoundCharacterWalk()
		elseif arg_14_0:getPercent() > 25 and arg_14_0:getPercent() <= 50 then
			self.controller:changeMode("LAND")
			self.controller:stopSoundCharacterWalk()
		else
			self.controller:changeMode("WORLD")
			self.controller:stopSoundCharacterWalk()
		end
	end
end

function WorldMapUICommon.onBackButton(arg_15_0)
	local var_15_0 = WorldMapManager:getNavigator()
	
	if var_15_0 and var_15_0:isOpenNavi() then
		var_15_0:backNavi()
	else
		BackButtonManager:pop()
		SceneManager:popScene()
	end
end

function WorldMapUICommon.onTouchDown(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_0.vars and arg_16_0.vars.navi and arg_16_0.vars.navi.isOpen then
		return 
	end
end

function WorldMapUICommon.onTouchUp(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0.touched = false
end

function WorldMapUICommon.getWnd(arg_18_0)
	return arg_18_0.wnd
end

function WorldMapUICommon.update(arg_19_0, arg_19_1)
	if not get_cocos_refid(arg_19_0.wnd) then
		print("=====================================update????")
		
		return 
	end
	
	local var_19_0 = 0
	
	for iter_19_0 = 1, 999 do
		local var_19_1 = arg_19_1 .. string.format("%03d", iter_19_0)
		
		if not DB("level_enter", var_19_1, {
			"id"
		}) then
			break
		end
		
		local var_19_2 = Account:getStageScore(var_19_1)
		
		if var_19_2 then
			var_19_0 = var_19_0 + var_19_2
		end
	end
	
	arg_19_0.reward_star = arg_19_0.reward_star or 0
	
	local var_19_3 = 0
	
	arg_19_0.star_data = {}
	arg_19_0.star_data.noti_flag = nil
	arg_19_0.star_data.needs = {}
	arg_19_0.star_data.state = {}
	arg_19_0.star_data.cur_count = var_19_0
	arg_19_0.star_data.rewardDB = {}
	arg_19_0.star_data.rewardable = false
	
	local var_19_4
	
	for iter_19_1 = 1, 3 do
		local var_19_5, var_19_6, var_19_7, var_19_8 = DB("level_world_3_chapter", arg_19_1, {
			"world_id",
			"reward_star" .. iter_19_1,
			"reward_id" .. iter_19_1,
			"reward_num" .. iter_19_1
		})
		
		var_19_4 = var_19_4 or var_19_5
		var_19_3 = var_19_6
		arg_19_0.star_data.needs[iter_19_1] = var_19_6
		arg_19_0.star_data.rewardDB[iter_19_1] = {}
		arg_19_0.star_data.rewardDB[iter_19_1].id = var_19_7
		arg_19_0.star_data.rewardDB[iter_19_1].count = var_19_8
		arg_19_0.star_data.world_id = var_19_5
		
		if arg_19_0.reward_star and var_19_6 <= arg_19_0.reward_star then
			arg_19_0.star_data.state[iter_19_1] = 1
		elseif var_19_6 <= arg_19_0.star_data.cur_count then
			arg_19_0.star_data.noti_flag = true
			arg_19_0.star_data.state[iter_19_1] = 2
			arg_19_0.star_data.rewardable = true
		elseif var_19_6 > arg_19_0.star_data.cur_count then
			arg_19_0.star_data.state[iter_19_1] = 3
		end
	end
	
	arg_19_0.star_data.max_count = var_19_3
	
	if arg_19_0.controller.vars.mode == "TOWN" then
		arg_19_0.wnd:getChildByName("CENTER"):setVisible(true)
	end
	
	if_set(arg_19_0.wnd, "label_star_num", arg_19_0.star_data.cur_count .. "/" .. arg_19_0.star_data.max_count)
	arg_19_0:updateStarRewardUI(arg_19_1)
	StarMissionManager:updateChapterDataByMapId(arg_19_1, arg_19_0.star_data)
	if_set_visible(arg_19_0.RIGHT, "n_normal_lv", true)
	
	arg_19_0.wnd.guide_tag = arg_19_1
	
	GrowthGuideNavigator:proc()
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		TutorialNotice:update("worldmap_scene")
	end)), "delay")
	arg_19_0:updateZoomNoti(arg_19_1, var_19_4)
	TutorialGuide:ifStartGuide("sidonia_start")
	TutorialGuide:ifStartGuide("eureka_start")
end

function WorldMapUICommon.updateZoomNoti(arg_21_0, arg_21_1, arg_21_2)
	if not get_cocos_refid(arg_21_0.wnd) or not arg_21_1 then
		return 
	end
	
	local var_21_0 = arg_21_0.wnd:getChildByName("n_zoom")
	
	if get_cocos_refid(var_21_0) then
		local var_21_1 = StarMissionManager:checkRewardExist(arg_21_1, arg_21_2)
		
		if_set_visible(var_21_0, "icon_noti", var_21_1)
	end
end

function WorldMapUICommon.visibleZoomNoti(arg_22_0, arg_22_1)
	if not get_cocos_refid(arg_22_0.wnd) then
		return 
	end
	
	local var_22_0 = arg_22_0.wnd:getChildByName("n_zoom")
	
	if get_cocos_refid(var_22_0) then
		if_set_visible(var_22_0, "icon_noti", arg_22_1)
	end
end

function WorldMapUICommon.UpdateAfterShowTown(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1 or arg_23_0.controller:getMapKey()
	
	arg_23_0:setRewardStar(var_23_0)
	arg_23_0.navi:UpdateAfterShowTown(var_23_0)
	arg_23_0:createQuestNavi()
	arg_23_0:createQuestNPC(var_23_0)
	arg_23_0:updateCustomUI()
end

function WorldMapUICommon.setTreeIcons(arg_24_0, arg_24_1)
	if not arg_24_0.navi then
		return 
	end
	
	arg_24_0.navi:setTreeIcons(arg_24_1)
end

function WorldMapUICommon.updateCustomUI(arg_25_0)
end

function WorldMapUICommon.hideNPC(arg_26_0)
	if not get_cocos_refid(arg_26_0.wnd) then
		return 
	end
	
	if_set_visible(arg_26_0.wnd, "n_npc_info", false)
end

function WorldMapUICommon.showNPC(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	arg_27_1 = arg_27_1 or "c1007"
	arg_27_2 = arg_27_2 or "vyupia.guide1"
	
	local var_27_0 = arg_27_0.wnd:getChildByName("n_npc_info")
	local var_27_1
	
	if arg_27_5 then
		var_27_1 = arg_27_0.wnd:getChildByName("n_npc_aespa")
		
		local var_27_2 = var_27_1:getChildByName("img_cursor")
		
		if get_cocos_refid(var_27_2) then
			UIAction:Remove("npc_blink")
			
			local var_27_3 = 400
			
			UIAction:Add(LOOP(SEQ(SHOW(false), DELAY(var_27_3), SHOW(true), DELAY(var_27_3))), var_27_2, "npc_blink")
		end
	else
		var_27_1 = arg_27_0.wnd:getChildByName("n_npc_normal")
	end
	
	var_27_0:setVisible(true)
	var_27_1:setVisible(true)
	
	local var_27_4 = var_27_1:getChildByName("n_pos")
	local var_27_5 = UIUtil:getPortraitAni(arg_27_1)
	
	if var_27_5 then
		var_27_4:removeAllChildren()
		var_27_4:addChild(var_27_5)
		
		if arg_27_3 and not DEBUG.IGNORE_NPC then
			UIUtil:setOffsetInfo(var_27_5, arg_27_3)
		end
	end
	
	local var_27_6 = var_27_1:getChildByName("n_balloon")
	
	if get_cocos_refid(var_27_6) then
		var_27_6:setVisible(true)
		var_27_6:setScale(0)
		
		if not var_27_6.original_pos then
			local var_27_7, var_27_8 = var_27_6:getPosition()
			
			var_27_6.original_pos = {}
			var_27_6.original_pos.x = var_27_7
			var_27_6.original_pos.y = var_27_8
		end
		
		if var_27_6.original_pos then
			var_27_6:setPosition(var_27_6.original_pos.x, var_27_6.original_pos.y)
		end
		
		UIUtil:playNPCSoundAndTextRandomly(arg_27_2, var_27_6, "disc", 300, arg_27_2, var_27_5)
		
		if arg_27_4 then
			UIUtil:setOffsetInfo(var_27_6, arg_27_4)
		end
	elseif arg_27_5 then
		local var_27_9 = var_27_1:getChildByName("txt_in")
		local var_27_10 = var_27_1:getChildByName("txt_out")
		
		var_27_9:setVisible(true)
		var_27_10:setVisible(true)
		UIUtil:playNPCSoundAndTextCustom(arg_27_2, var_27_9, var_27_10, 300, var_27_5)
	end
end

function WorldMapUICommon.createQuestNPC(arg_28_0, arg_28_1)
end

function WorldMapUICommon.hideNPC(arg_29_0)
	if not get_cocos_refid(arg_29_0.wnd) then
		return 
	end
	
	arg_29_0.wnd:getChildByName("n_npc_info"):setVisible(false)
end

function WorldMapUICommon.UpdateAfterShowLand(arg_30_0)
	arg_30_0:createQuestNavi()
end

function WorldMapUICommon.onAfterUpdate(arg_31_0)
	local var_31_0 = ConditionContentsManager:getUrgentMissions()
	
	if var_31_0 then
		var_31_0:updateTime()
	end
	
	if arg_31_0.navi then
		arg_31_0.navi:update()
	end
end

function WorldMapUICommon.setBattleEnterBtn(arg_32_0)
	if get_cocos_refid(arg_32_0.wnd) then
		if arg_32_0.controller:getMode() == "TOWN" and Account:checkEnterMap(arg_32_0.controller:getCurrentTown() or "ije001") or DEBUG.MAP_DEBUG then
			if_set_visible(arg_32_0.wnd, "btn_last_location", false)
			if_set_visible(arg_32_0.wnd, "btn_start", true)
			
			return 
		end
		
		if_set_visible(arg_32_0.wnd, "btn_last_location", true)
		if_set_visible(arg_32_0.wnd, "btn_start", false)
	end
end

WorldMapIcon = {}

function WorldMapIcon.create(arg_33_0, arg_33_1)
	arg_33_1 = arg_33_1 or {}
	
	local var_33_0
	
	if arg_33_1.no_userdata then
		var_33_0 = cc.CSLoader:createNode("wnd/battle_map_enter_icon.csb")
	else
		var_33_0 = load_control("wnd/battle_map_enter_icon.csb")
	end
	
	var_33_0:setLocalZOrder(9999)
	if_set_visible(var_33_0, "n_land", false)
	if_set_visible(var_33_0, "label_bg_world", false)
	if_set_visible(var_33_0, "n_urgent", false)
	if_set_visible(var_33_0, "n_urgent_othere", false)
	if_set_visible(var_33_0, "n_limit", false)
	copy_functions(WorldMapIcon, var_33_0)
	UIUserData:parse(var_33_0:findChildByName("talk_small_bg"))
	UIUserData:parse(var_33_0:findChildByName("disc"))
	UIUserData:procAfterLoadDlg()
	
	return var_33_0
end

function WorldMapIcon.setTitle(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	arg_34_5 = arg_34_5 or {}
	
	local var_34_0 = arg_34_0:getChildByName("label_name")
	
	if_set(var_34_0, nil, arg_34_1)
	
	arg_34_3 = arg_34_3 or arg_34_0:getChildByName("label_bg")
	
	local var_34_1 = var_34_0:getContentSize().width * var_34_0:getScaleX()
	
	if var_34_1 > 0 then
		local var_34_2 = arg_34_3:getContentSize()
		
		if not arg_34_0.original_width then
			arg_34_0.original_width = var_34_2.width
		end
		
		var_34_2.width = arg_34_0.original_width + (var_34_1 - 100)
		
		if arg_34_2 then
			var_34_2.width = math.max(var_34_2.width, arg_34_2)
		end
		
		arg_34_3:setContentSize(var_34_2)
		
		local var_34_3 = arg_34_0:getChildByName("noti_icon")
		
		if get_cocos_refid(var_34_3) then
			var_34_3:setPositionX(var_34_3:getPositionX() - (var_34_1 - 100) / 2)
		end
	end
	
	if_set_sprite(arg_34_0, "label_bg", arg_34_5.name_tag_img or "img/_titlebg_radder.png")
	
	if arg_34_5.name_tag_tint then
		if_set_color(arg_34_0, "label_bg", cc.c3b(arg_34_5.name_tag_tint.r, arg_34_5.name_tag_tint.g, arg_34_5.name_tag_tint.b))
	end
	
	if arg_34_5.name_tag_icon then
		if_set_visible(arg_34_0, "n_emblem", true)
		if_set_visible(arg_34_0, "_em_grow", true)
		if_set_sprite(arg_34_0, "n_emblem", arg_34_5.name_tag_icon)
		if_set_color(arg_34_0, "n_emblem", cc.c3b(255, 255, 255))
	end
	
	if_set_opacity(arg_34_0, "label_bg", arg_34_4 or 255)
	if_set_opacity(arg_34_0, "label_name", arg_34_4 or 255)
	
	return var_34_0
end

function WorldMapIcon.setLandTitle(arg_35_0, arg_35_1)
	local var_35_0 = T(arg_35_1.name)
	local var_35_1 = string.split(var_35_0, ".")
	
	if var_35_1[2] then
		if_set_visible(arg_35_0, "n_land", true)
		
		local var_35_2 = arg_35_0:getChildByName("n_land")
		
		if_set_sprite(var_35_2, "land_img", "img/_box_r_yellowline.png")
		if_set(arg_35_0, "label_num", var_35_1[1])
		
		var_35_0 = string.trim(var_35_1[2])
	end
	
	local var_35_3 = arg_35_0:getChildByName("label_name")
	
	if arg_35_1.is_world then
		arg_35_0:setScale(1.1)
		arg_35_0:setAnchorPoint(0.5, 0.2)
		
		local var_35_4 = arg_35_0:getChildByName("label_bg_world")
		
		var_35_4:setVisible(true)
		if_set_visible(arg_35_0, "label_bg", false)
		var_35_3:enableOutline(cc.c3b(26, 26, 26, 255), 1)
		var_35_3:setScale(0.77)
		var_35_3:setAnchorPoint(0.5, 0.83)
		arg_35_0:setTitle(var_35_0, 160, var_35_4)
	else
		arg_35_0:setAnchorPoint(0.5, 0)
		
		local var_35_5
		local var_35_6
		local var_35_7
		
		if arg_35_1.name_tag_img then
			var_35_5 = "img/" .. arg_35_1.name_tag_img .. ".png"
		end
		
		if arg_35_1.name_tag_icon then
			var_35_7 = "img/" .. arg_35_1.name_tag_icon .. ".png"
		end
		
		if arg_35_1.name_tag_tint then
			var_35_6 = totable(arg_35_1.name_tag_tint)
		end
		
		arg_35_0:setAnchorPoint(0.5, 0)
		arg_35_0:setTitle(var_35_0, nil, nil, nil, {
			name_tag_img = var_35_5,
			name_tag_icon = var_35_7,
			name_tag_tint = var_35_6
		})
	end
	
	if_set_visible(arg_35_0, "img", false)
	if_set_visible(arg_35_0, "center", false)
	if_set_visible(arg_35_0, "spr_tag_icon", false)
	if_set_visible(arg_35_0, "argent_m", false)
	if_set_visible(arg_35_0, "spr_tag_seal", false)
end

AdvWorldMapUI = AdvWorldMapUI or {}

copy_functions(WorldMapUICommon, AdvWorldMapUI)

function AdvWorldMapUI.create(arg_36_0, arg_36_1)
	arg_36_0.controller = arg_36_1
	
	local var_36_0 = arg_36_0:initUI()
	
	arg_36_0:_createTopbar(var_36_0)
	arg_36_0:updateCustomUI(var_36_0, arg_36_1)
	
	arg_36_0.navi = AdvMissionNavigator
	
	arg_36_0.navi:init(arg_36_0.RIGHT, arg_36_0.controller, arg_36_0)
	arg_36_0.navi:updateQuest()
	LuaEventDispatcher:removeEventListenerByKey("AdvWorldMapUI.unit")
	LuaEventDispatcher:addEventListener("unit_popup_detail.close", LISTENER(function(arg_37_0)
		AdvWorldMapUI:updateCustomUI(var_36_0, arg_36_1)
	end), "AdvWorldMapUI.unit")
	
	return var_36_0
end

function AdvWorldMapUI._createTopbar(arg_38_0, arg_38_1)
	if not arg_38_1 then
		return 
	end
	
	local var_38_0 = arg_38_0.controller:getContinentID()
	
	TopBarNew:create(T("map_world"), arg_38_1, function()
		arg_38_0:onBackButton()
	end, {
		"crystal",
		"gold",
		"stamina"
	}, nil, "infoadve1")
	TopBarNew:setTitleName(T(DB("level_world_2_continent", var_38_0, "name")), "infoadve1")
end

function AdvWorldMapUI.offAdinNode(arg_40_0)
	if not arg_40_0.wnd then
		return 
	end
	
	if_set_visible(arg_40_0.wnd, "n_adin", false)
end

function AdvWorldMapUI.updateCustomUI(arg_41_0, arg_41_1, arg_41_2)
	arg_41_1 = arg_41_1 or arg_41_0.wnd
	arg_41_2 = arg_41_2 or arg_41_0.controller
	
	if not get_cocos_refid(arg_41_1) or not arg_41_2 then
		return 
	end
	
	if to_n(arg_41_2:getWorldIDByMapKey()) == 5 and arg_41_2:getMode() == "TOWN" then
		local var_41_0 = arg_41_1:getChildByName("n_adin")
		
		if get_cocos_refid(var_41_0) then
			var_41_0:setVisible(true)
			
			if UnlockSystem:isUnlockSystem(UNLOCK_ID.ADIN) then
				if_set_color(var_41_0, "n_btn", cc.c3b(255, 255, 255))
				if_set_visible(var_41_0, "icon_noti", EpisodeAdinUI:isChapterAvailable() or EpisodeAdinUI:getReceivableRewards() or EpisodeAdinUI:isChapterCleared())
				if_set_visible(var_41_0, "icon_lock", false)
			else
				if_set_color(var_41_0, "n_btn", cc.c3b(136, 136, 136))
				if_set_visible(var_41_0, "icon_noti", false)
				if_set_visible(var_41_0, "icon_lock", true)
			end
		end
	else
		if_set_visible(arg_41_1, "n_adin", false)
	end
	
	local var_41_1 = WorldMapManager:getNavigator()
	
	if var_41_1 and var_41_1:isOpenNavi() then
		if_set_visible(arg_41_1, "n_adin", false)
	end
end

function AdvWorldMapUI.updateContentButtons(arg_42_0, arg_42_1)
end

function AdvWorldMapUI.createQuestNavi(arg_43_0)
	local var_43_0 = arg_43_0.wnd:getChildByName("n_quest_navi")
	
	var_43_0:setVisible(true)
	var_43_0:removeAllChildren()
	
	local var_43_1 = ConditionContentsManager:getQuestMissions()
	
	if arg_43_0.controller:getMode() == "TOWN" and var_43_1:hasNextQuest() and not var_43_1:isActiveQuestInChapter(arg_43_0.controller:getMapKey()) then
		local var_43_2 = UIUtil:makeNavigatorAni({
			scale = 0.55
		})
		
		var_43_0:addChild(var_43_2)
	elseif arg_43_0.controller:getMode() == "LAND" and var_43_1:hasNextQuest() and not var_43_1:isActiveQuestInWorld(arg_43_0.controller:getKeyContinent()) then
		local var_43_3 = UIUtil:makeNavigatorAni({
			scale = 0.55
		})
		
		var_43_0:addChild(var_43_3)
	end
end

StarMissionManager = {}

function StarMissionManager.initStoryStarData(arg_44_0)
	if arg_44_0.vars then
		return 
	end
	
	arg_44_0.vars = {}
	
	arg_44_0:initData()
end

function StarMissionManager.canGetReward(arg_45_0, arg_45_1)
	if not arg_45_1 then
		return 
	end
	
	return arg_45_0.vars.star_data[arg_45_1].rewardable
end

function StarMissionManager.getContinentStarData(arg_46_0, arg_46_1)
	if not arg_46_1 then
		return 
	end
	
	return arg_46_0.vars.star_data[arg_46_1]
end

function StarMissionManager.checkRewardExist(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_0.vars or not arg_47_0.vars.star_data or not arg_47_1 then
		return 
	end
	
	local var_47_0 = SceneManager:getCurrentSceneName()
	local var_47_1 = var_47_0 == "world_custom" or var_47_0 == "world_sub"
	local var_47_2
	
	if arg_47_1 then
		arg_47_2 = arg_47_2 or arg_47_1
		var_47_2 = tonumber(arg_47_2)
		
		for iter_47_0, iter_47_1 in pairs(arg_47_0.vars.star_data) do
			local var_47_3 = tonumber(iter_47_1.world_id)
			
			if var_47_1 then
				local var_47_4 = SubstoryManager:getChapterIDList() or {}
				
				if table.count(var_47_4) <= 1 then
					return 
				else
					local var_47_5 = (SubstoryManager:getWorldMapContentsDB() or {}).star_mission_hide
					
					if var_47_5 and var_47_5 == "y" then
						return 
					end
					
					for iter_47_2, iter_47_3 in pairs(var_47_4) do
						if iter_47_3 ~= arg_47_1 and arg_47_0:canGetReward(iter_47_3) then
							return true
						end
					end
				end
			elseif var_47_3 == var_47_2 and iter_47_0 ~= arg_47_1 and arg_47_0:canGetReward(iter_47_0) then
				return true
			end
		end
	end
end

function StarMissionManager.initData(arg_48_0)
	if not arg_48_0.vars then
		return 
	end
	
	arg_48_0.vars.star_data = {}
	
	for iter_48_0 = 1, 9999 do
		local var_48_0 = 0
		local var_48_1 = 0
		local var_48_2, var_48_3, var_48_4 = DBN("level_world_3_chapter", iter_48_0, {
			"id",
			"world_id",
			"reward_star1"
		})
		
		if not var_48_2 then
			break
		end
		
		var_48_3 = var_48_3 or var_48_2
		
		if var_48_3 and var_48_4 then
			for iter_48_1 = 1, 999 do
				local var_48_5 = var_48_2 .. string.format("%03d", iter_48_1)
				
				if not DB("level_enter", var_48_5, {
					"id"
				}) then
					break
				end
				
				local var_48_6 = Account:getStageScore(var_48_5)
				
				if var_48_6 then
					var_48_0 = var_48_0 + var_48_6
				end
			end
			
			arg_48_0.vars.star_data[var_48_2] = {}
			arg_48_0.vars.star_data[var_48_2].needs = {}
			arg_48_0.vars.star_data[var_48_2].rewardDB = {}
			arg_48_0.vars.star_data[var_48_2].state = {}
			arg_48_0.vars.star_data[var_48_2].cur_count = var_48_0
			arg_48_0.vars.star_data[var_48_2].world_id = var_48_3
			arg_48_0.vars.star_data[var_48_2].reward_star = AccountData.worldmap_rewards[var_48_2] or 0
			
			for iter_48_2 = 1, 3 do
				local var_48_7, var_48_8, var_48_9 = DB("level_world_3_chapter", var_48_2, {
					"reward_star" .. iter_48_2,
					"reward_id" .. iter_48_2,
					"reward_num" .. iter_48_2
				})
				
				var_48_1 = var_48_7
				arg_48_0.vars.star_data[var_48_2].needs[iter_48_2] = var_48_7
				arg_48_0.vars.star_data[var_48_2].rewardDB[iter_48_2] = {}
				arg_48_0.vars.star_data[var_48_2].rewardDB[iter_48_2].id = var_48_8
				arg_48_0.vars.star_data[var_48_2].rewardDB[iter_48_2].count = var_48_9
				
				if arg_48_0.vars.star_data[var_48_2].reward_star and var_48_7 <= arg_48_0.vars.star_data[var_48_2].reward_star then
					arg_48_0.vars.star_data[var_48_2].state[iter_48_2] = 1
				elseif var_48_7 <= arg_48_0.vars.star_data[var_48_2].cur_count then
					arg_48_0.vars.star_data[var_48_2].noti_flag = true
					arg_48_0.vars.star_data[var_48_2].state[iter_48_2] = 2
					arg_48_0.vars.star_data[var_48_2].rewardable = true
				elseif var_48_7 > arg_48_0.vars.star_data[var_48_2].cur_count then
					arg_48_0.vars.star_data[var_48_2].state[iter_48_2] = 3
				end
			end
			
			arg_48_0.vars.star_data[var_48_2].max_count = var_48_1
		end
	end
end

function StarMissionManager.updateChapterDataByMapId(arg_49_0, arg_49_1, arg_49_2)
	arg_49_0:initStoryStarData()
	
	if not arg_49_0.vars or not arg_49_1 or not arg_49_2 then
		return 
	end
	
	local var_49_0 = 0
	local var_49_1 = 0
	local var_49_2 = DB("level_world_3_chapter", arg_49_1, {
		"id"
	})
	
	if not var_49_2 then
		return 
	end
	
	arg_49_0.vars.star_data[var_49_2] = arg_49_2
end

StarMissionUI = {}

function StarMissionUI.updateContinentUI(arg_50_0, arg_50_1, arg_50_2)
	if not arg_50_1 or not arg_50_2 then
		return 
	end
	
	StarMissionManager:initStoryStarData()
	
	local var_50_0 = StarMissionManager:getContinentStarData(arg_50_1)
	
	if not var_50_0 then
		return 
	end
	
	local var_50_1 = var_50_0.cur_count
	local var_50_2 = var_50_0.max_count
	local var_50_3 = StarMissionManager:canGetReward(arg_50_1)
	local var_50_4 = arg_50_2:getChildByName("n_star_progress")
	
	if var_50_4 then
		var_50_4:setVisible(true)
		
		local var_50_5 = WidgetUtils:createCircleProgress("img/cm_hero_circool1.png")
		
		var_50_5:setCascadeOpacityEnabled(true)
		
		local var_50_6 = arg_50_2:getChildByName("progress_bar")
		
		var_50_6:setVisible(false)
		var_50_5:setScale(var_50_6:getScale())
		var_50_5:setPositionX(var_50_6:getPositionX())
		var_50_5:setPositionY(var_50_6:getPositionY())
		var_50_5:setOpacity(var_50_6:getOpacity())
		var_50_5:setColor(var_50_6:getColor())
		var_50_5:setReverseDirection(false)
		var_50_5:setName("_progress")
		var_50_4:addChild(var_50_5)
		
		local var_50_7 = var_50_1 / var_50_2 * 100
		local var_50_8 = math.floor(var_50_7)
		
		var_50_5:setPercentage(var_50_8)
		
		if var_50_8 >= 100 then
			if_set_visible(arg_50_2, "icon_check_reward", true)
			if_set_opacity(arg_50_2, "img_star", 76.5)
		end
		
		if_set_visible(arg_50_2, "icon_noti", var_50_3)
	end
end

function StarMissionUI.updateEpisodeDetailUI(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_1 or not arg_51_2 then
		return 
	end
	
	StarMissionManager:initStoryStarData()
	
	local var_51_0 = StarMissionManager:getContinentStarData(arg_51_1)
	
	if not var_51_0 then
		return 
	end
	
	local var_51_1 = var_51_0.cur_count
	local var_51_2 = var_51_0.max_count
	local var_51_3 = StarMissionManager:canGetReward(arg_51_1)
	local var_51_4 = arg_51_2:getChildByName("label_star_num")
	
	if get_cocos_refid(var_51_4) then
		if_set(var_51_4, nil, var_51_1 .. "/" .. var_51_2)
		
		if var_51_1 == var_51_2 then
			var_51_4:setTextColor(cc.c3b(255, 255, 255))
			if_set_color(var_51_4, nil, tocolor("#6bc11b"))
		end
	end
	
	if_set_visible(arg_51_2, "icon_noti", var_51_3)
end
