function HANDLER.dungeon_story_shop_item(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_buy" then
		local var_1_0 = getParentWindow(arg_1_0)
		
		var_1_0.parent_class:showBuyPopup(var_1_0.info)
	end
end

function HANDLER.dungeon_story_shop(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
	end
end

function HANDLER.dungeon_story_home(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_video" then
		SubstoryUIUtil:onBtnVideo(arg_3_0)
	elseif arg_3_1 == "btn_core_reward" then
		SubstoryManager:showCoreRewardPopup(arg_3_0.popup_parent, arg_3_0.substory_id)
	end
end

function HANDLER.dungeon_story_bg(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_video" then
		SubstoryUIUtil:onBtnVideo(arg_4_0)
	elseif arg_4_1 == "btn_event" and arg_4_0.link then
		movetoPath(arg_4_0.link)
	end
end

function HANDLER.dungeon_story(arg_5_0, arg_5_1)
	local var_5_0, var_5_1, var_5_2 = SubstoryManager:getEventTimeInfo()
	
	if arg_5_1 == "btn_prologue" then
		SubstoryManager:playPrologue()
		
		return 
	end
	
	if SUBSTORY_CONSTANTS.STATE_READY == var_5_0 then
		balloon_message_with_sound("ready_sub_story_event")
		
		return 
	end
	
	if arg_5_1 == "btn_achieve" then
		SubstoryAchievePopup:show()
	elseif arg_5_1 == "btn_contents2" then
		SubstoryManager:nextContent_type2()
	elseif arg_5_1 == "btn_shop" then
		SubStoryLobby:hideBG()
		SubstoryManager:openStoryShop()
	elseif arg_5_1 == "btn_help" then
		if arg_5_0.help_id then
			HelpGuide:open({
				contents_id = arg_5_0.help_id .. "_1_1"
			})
		end
	elseif arg_5_1 == "btn_bonus" then
		Substory_ArtBouns:open()
	elseif arg_5_1 == "btn_go_change" then
		Account:showServerResUI("system_story", {
			backtype = "close"
		})
	elseif arg_5_1 == "btn_pass" then
		SeasonPassBase:openSubstoryPass(function()
			SubStoryLobby:updateUI()
		end)
	end
end

function HANDLER.dungeon_story_bar2(arg_7_0, arg_7_1)
	local var_7_0 = getParentWindow(arg_7_0)
	
	if arg_7_1 == "btn_go" or arg_7_1 == "btn_closing_soon" or arg_7_1 == "btn_pre" then
		DungeonList:enterDungeon({
			info = var_7_0.info
		})
		
		return 
	end
	
	var_7_0.parent:onSelectScrollViewItem(var_7_0.idx, {
		item = var_7_0.info,
		control = arg_7_0
	})
end

function HANDLER.dungeon_story_base_info(arg_8_0, arg_8_1)
	local var_8_0, var_8_1, var_8_2 = SubstoryManager:getEventTimeInfo()
	
	if arg_8_1 == "btn_go" then
		if SUBSTORY_CONSTANTS.STATE_OPEN ~= var_8_0 then
			balloon_message_with_sound("end_sub_story_event")
			
			return 
		end
		
		SubstoryManager:nextContent_type1()
	elseif arg_8_1 == "btn_core_reward" then
		SubstoryManager:showCoreRewardPopup(arg_8_0.popup_parent)
	elseif arg_8_1 == "btn_end" then
		SubStoryLobbyUIDefault:showTutorialEndPopup()
	end
end

SubStoryLobbyMain = SubStoryLobbyMain or {}

function SubStoryLobbyMain.show(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.vars = {}
	arg_9_0.vars.wnd = load_dlg("story_sub_main", true, "wnd")
	
	if arg_9_2.substory_id then
		SubstoryManager:setInfo(arg_9_2.substory_id)
	end
	
	local var_9_0 = SubstoryManager:getInfo()
	
	if not var_9_0 then
		Log.e("SubStoryLobbyMain.show", "invalid_info")
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	SubstoryManager:initLobbyCond()
	
	if SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.INFERENCE) then
		SubStoryInferenceNote:initNewNoteNoti()
	end
	
	arg_9_2 = arg_9_2 or {}
	
	if arg_9_0.vars == nil then
		arg_9_0:create(arg_9_1)
	end
	
	arg_9_0.vars.info = var_9_0
	
	local var_9_1 = arg_9_0.vars.info.csb_name or "dungeon_story"
	
	arg_9_0.vars.wnd = load_dlg(var_9_1, true, "wnd")
	arg_9_0.vars.wnd.guide_tag = var_9_0.id
	
	arg_9_1:addChild(arg_9_0.vars.wnd)
	
	local var_9_2 = "infosubs"
	
	if var_9_0.id == "vewrda" then
		var_9_2 = "infosubs_6"
	end
	
	TopBarNew:createFromPopup(T("substory_title"), arg_9_0.vars.wnd, function()
		if var_9_0.id == "vewrda" then
			SubStoryEntrance:show("HOME")
		else
			SubStoryEntrance:show("SUBSTORY_LIST")
		end
	end, nil, var_9_2)
	SubStoryLobby:onEnterUI(var_9_1, arg_9_0.vars.wnd, var_9_0)
	
	local var_9_3, var_9_4, var_9_5 = SubStoryUtil:getEventTimeInfoByID(arg_9_0.vars.info.id)
	
	if arg_9_2.s_event_state == "ready" and var_9_3 ~= "ready" then
		Dialog:msgBox(T("substory_reload_msg"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end
		})
		
		return 
	end
	
	SubstoryManager:initVilliageCraftManager(var_9_0.id)
	SubStoryLobby:updateEnterQueryUI()
	SubStoryLobby:updateUI()
	GrowthGuideNavigator:proc()
	TutorialGuide:procGuide()
	TutorialGuide:onEnterSubstory()
	
	arg_9_0.vars.pathParams = arg_9_2.pathParams
end

function SubStoryLobbyMain.movePathParms(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not arg_12_0.vars.pathParams then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	local var_12_0, var_12_1, var_12_2 = SubStoryUtil:getEventTimeInfoByID(arg_12_0.vars.info.id)
	
	if SUBSTORY_CONSTANTS.STATE_READY == var_12_0 then
		balloon_message_with_sound("ready_sub_story_event")
	elseif SUBSTORY_CONSTANTS.STATE_OPEN == var_12_0 then
		if arg_12_0.vars.pathParams.contents == 2 then
			SubstoryManager:nextContent_type2({
				pathParams = arg_12_0.vars.pathParams
			})
		elseif arg_12_0.vars.pathParams.contents == 1 then
			SubstoryManager:nextContent_type1({
				pathParams = arg_12_0.vars.pathParams
			})
		end
	else
		balloon_message_with_sound("substory_wait_msg")
	end
end

function SubStoryLobbyMain.close(arg_13_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_13_0.vars.wnd, "block")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("substory_title"))
end

function SubStoryLobbyMain.getSceneState(arg_14_0)
	if not arg_14_0.vars then
		return {}
	end
	
	return {
		info = arg_14_0.vars.info
	}
end

function SubStoryLobbyMain.CheckNotification(arg_15_0)
	return GlobalSubstoryManager:isNotiAblum()
end

function SubStoryLobbyMain.onLeave(arg_16_0)
	arg_16_0.vars = nil
end

function SubStoryLobbyMain.getFirstDungeonControl(arg_17_0)
	return SubStoryList.ScrollViewItems[1].control
end

function SubStoryLobbyMain.isShow(arg_18_0)
	if not arg_18_0.vars then
		return false
	end
	
	if not get_cocos_refid(arg_18_0.vars.wnd) then
		return false
	end
	
	return arg_18_0.vars.wnd:isVisible()
end

SubStoryLobby = SubStoryLobby or {}

function SubStoryLobby.updateUI(arg_19_0)
	local var_19_0 = SubstoryManager:getInfo().csb_name or "dungeon_story"
	local var_19_1 = arg_19_0:getObj(var_19_0)
	
	if var_19_1 and var_19_1.updateUI then
		var_19_1:updateUI()
	end
end

function SubStoryLobby.onEnterUI(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0:getObj(arg_20_1)
	
	if var_20_0 and var_20_0.onEnterUI then
		var_20_0:onEnterUI(arg_20_2, arg_20_3)
	end
end

function SubStoryLobby.getObj(arg_21_0, arg_21_1)
	if not arg_21_0.lobby_obj then
		arg_21_0.lobby_obj = {}
		arg_21_0.lobby_obj.dungeon_story = SubStoryLobbyUIDefault
		arg_21_0.lobby_obj.dungeon_story_challenge = SubStoryLobbyUIChallenge
		arg_21_0.lobby_obj.dungeon_story_challenge2 = SubStoryLobbyUIDescent
		arg_21_0.lobby_obj.dungeon_story_festival = SubStoryLobbyUIFestival
		arg_21_0.lobby_obj.dungeon_story_paradise_main = SubStoryLobbyUIBurning
	end
	
	return arg_21_0.lobby_obj[arg_21_1] or SubStoryLobbyUIDefault
end

function SubStoryLobby.refreshBGM(arg_22_0, arg_22_1)
	local var_22_0 = SubstoryManager:getInfo()
	
	if not var_22_0 then
		return 
	end
	
	local var_22_1 = var_22_0.csb_name or "dungeon_story"
	local var_22_2 = arg_22_0:getObj(var_22_1)
	
	if var_22_2 and var_22_2.refreshBGM then
		if arg_22_1 then
			var_22_2:refreshBGM()
		else
			if var_22_2.pauseSound then
				var_22_2:pauseSound()
			end
			
			SoundEngine:playBGM("event:/bgm/default")
		end
	end
end

function SubStoryLobby.hideBG(arg_23_0)
	local var_23_0 = SubstoryManager:getInfo().csb_name or "dungeon_story"
	local var_23_1 = arg_23_0:getObj(var_23_0)
	
	if var_23_1 and var_23_1.hideBG then
		var_23_1:hideBG()
	end
end

function SubStoryLobby.showBG(arg_24_0)
	local var_24_0 = SubstoryManager:getInfo().csb_name or "dungeon_story"
	local var_24_1 = arg_24_0:getObj(var_24_0)
	
	if var_24_1 and var_24_1.showBG then
		var_24_1:showBG()
	end
end

function SubStoryLobby.getWnd(arg_25_0)
	local var_25_0 = SubstoryManager:getInfo().csb_name or "dungeon_story"
	local var_25_1 = arg_25_0:getObj(var_25_0)
	
	if var_25_1 and var_25_1.getWnd then
		return var_25_1:getWnd()
	end
end

function SubStoryLobby.updateEnterQueryUI(arg_26_0)
	local var_26_0 = SubstoryManager:getInfo()
	local var_26_1 = var_26_0.csb_name or "dungeon_story"
	local var_26_2 = arg_26_0:getObj(var_26_1)
	
	if var_26_2 and var_26_2.updateEnterQueryUI then
		var_26_2:updateEnterQueryUI(var_26_0)
	end
end

SubStoryLobbyCommon = SubStoryLobbyCommon or {}

function SubStoryLobbyCommon.getWnd(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	return arg_27_0.vars.wnd
end

function SubStoryLobbyCommon.hideBG(arg_28_0)
	if not arg_28_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(400)), arg_28_0.vars.wnd, "block")
end

function SubStoryLobbyCommon.showBG(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("list_view")
	
	UIAction:Add(SEQ(FADE_IN(440)), arg_29_0.vars.wnd, "block")
end

function SubStoryLobbyCommon.updateRemainTime(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0, var_30_1, var_30_2 = SubstoryManager:getEventTimeInfo()
	local var_30_3 = os.time()
	local var_30_4 = SUBSTORY_CONSTANTS.ONE_WEEK
	
	if SUBSTORY_CONSTANTS.STATE_READY == var_30_0 then
		local var_30_5 = var_30_1 - var_30_3
		
		if_set(arg_30_0.vars.wnd, "label_remine_time", T("time_wait", {
			time = sec_to_string(var_30_5)
		}))
	elseif SUBSTORY_CONSTANTS.STATE_OPEN == var_30_0 then
		local var_30_6 = var_30_2 - var_30_3
		local var_30_7 = arg_30_0.vars.wnd:getChildByName("label_remine_time")
		
		if get_cocos_refid(var_30_7) and var_30_7:isVisible() == true then
			if_set(arg_30_0.vars.wnd, "label_remine_time", T("time_remain", {
				time = sec_to_string(var_30_6)
			}))
		end
	elseif SUBSTORY_CONSTANTS.STATE_CLOSE_SOON == var_30_0 then
		local var_30_8 = var_30_2 + var_30_4 - var_30_3
		
		if_set(arg_30_0.vars.wnd, "label_remine_time", T("time_remain", {
			time = sec_to_string(var_30_8)
		}))
	else
		if_set(arg_30_0.vars.wnd, "label_remine_time", "")
	end
end

function SubStoryLobbyCommon.exceptionHandling(arg_31_0, arg_31_1)
end

function SubStoryLobbyCommon.addBaseInfo(arg_32_0, arg_32_1)
	local var_32_0 = load_control("wnd/dungeon_story_base_info.csb", true)
	local var_32_1 = arg_32_0.vars.wnd:getChildByName("n_base_info")
	
	if get_cocos_refid(var_32_1) then
		var_32_1:addChild(var_32_0)
	end
	
	local var_32_2 = arg_32_0.vars.wnd:getChildByName("contents")
	
	if get_cocos_refid(var_32_2) then
		UnlockSystem:setUnlockUIState(arg_32_0.vars.wnd:getChildByName("contents"), "btn_go", arg_32_1.unlock)
	end
	
	if not SubstoryManager:isSystemSubStory() then
		arg_32_0:updateRemainTime()
		Scheduler:addSlow(arg_32_0.vars.wnd, arg_32_0.updateRemainTime, arg_32_0)
	end
	
	SubstoryUIUtil:updateLobbyRightBaseInfo(arg_32_0.vars.wnd, arg_32_1)
	
	local var_32_3 = var_32_0:getChildByName("ON")
	local var_32_4 = SubstoryManager:getWorldMapContentsDB() or {}
	
	if var_32_4 and var_32_4.hide_hero_info and get_cocos_refid(var_32_3) then
		local var_32_5 = var_32_0:getChildByName("txt_summary")
		local var_32_6 = var_32_0:getChildByName("txt_summary2")
		
		if get_cocos_refid(var_32_5) and get_cocos_refid(var_32_6) then
			if_set_visible(var_32_3, "list_view", false)
			if_set_visible(var_32_3, "label_title", false)
			if_set_visible(var_32_3, "img_buff_story", false)
			if_set_visible(arg_32_0.vars.wnd, "n_title", false)
			
			local var_32_7 = SubstoryUIUtil:getBGInfo(arg_32_1.background_summary, arg_32_1.id)
			local var_32_8
			local var_32_9, var_32_10 = SubstoryManager:getNotIncludeHideAchieveDatas({
				hide_not_include = true
			})
			
			if var_32_9 > 0 then
				var_32_8 = var_32_6
			else
				var_32_8 = var_32_5
			end
			
			var_32_8:setVisible(true)
			
			if var_32_7 and var_32_7.desc and var_32_7.desc.txt then
				if_set(var_32_8, nil, T(var_32_7.desc.txt))
			end
		end
	end
end

function SubStoryLobbyCommon.setVisibleArtiEffectBtn(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0.vars.wnd:getChildByName("btn_bonus")
	
	if get_cocos_refid(var_33_0) then
		local var_33_1 = (arg_33_2.bonus_artifact1 or arg_33_2.bonus_artifact2 or arg_33_2.bonus_artifact3 or arg_33_2.bonus_artifact4) ~= nil
		
		if arg_33_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON or arg_33_1 == SUBSTORY_CONSTANTS.STATE_CLOSE or arg_33_1 == SUBSTORY_CONSTANTS.STATE_READY then
			var_33_1 = false
		end
		
		var_33_0:setVisible(var_33_1)
	end
end

function SubStoryLobbyCommon.setVisiblePrologueBtn(arg_34_0, arg_34_1, arg_34_2)
	if_set_visible(arg_34_0.vars.wnd, "btn_prologue", arg_34_2.prologue_story ~= nil and (arg_34_1 == SUBSTORY_CONSTANTS.STATE_OPEN or arg_34_1 == SUBSTORY_CONSTANTS.STATE_READY))
end

SubStoryLobbyUIDefault = SubStoryLobbyUIDefault or {}

copy_functions(SubStoryLobbyCommon, SubStoryLobbyUIDefault)

function SubStoryLobbyUIDefault.onEnterUI(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0.vars = {}
	arg_35_0.vars.wnd = arg_35_1
	
	local var_35_0 = SubstoryUIUtil:getBackground(arg_35_2.id, arg_35_2.background_summary, {
		isEnter = true
	})
	
	var_35_0:setAnchorPoint(0.5, 0.5)
	var_35_0:setLocalZOrder(-1)
	arg_35_0.vars.wnd:addChild(var_35_0)
	arg_35_0:addBaseInfo(arg_35_2)
	arg_35_0:updateEventInfo(arg_35_2)
end

function SubStoryLobbyUIDefault.updateUI(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	local var_36_0 = SubstoryManager:getInfo()
	
	SubstoryUIUtil:updateAchieveUI(arg_36_0.vars.wnd)
	SubstoryUIUtil:updateQuestUI(arg_36_0.vars.wnd)
	
	if var_36_0.contents_type_2 then
		SubstoryUIUtil:updateContents2Noti(arg_36_0.vars.wnd, var_36_0.id, var_36_0.contents_type_2)
	end
	
	local var_36_1 = arg_36_0.vars.wnd:getChildByName("btn_pass")
	local var_36_2 = Account:getSubstoryPassData()
	
	if var_36_0.pass_id and var_36_2 then
		if_set(var_36_1, "label", T(var_36_2.main_db.scene_title))
		if_set_visible(var_36_1, "icon_achieve_noti", SeasonPass:isRemainReward(var_36_0.pass_id))
	end
end

function SubStoryLobbyUIDefault.updateEventInfo(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.vars.wnd:getChildByName("btn_achieve")
	
	if_set_visible(var_37_0, "icon_achieve_noti", false)
	
	local var_37_1 = SubStoryUtil:getEventState(arg_37_1.start_time, arg_37_1.end_time)
	local var_37_2 = arg_37_1.start_time
	local var_37_3 = arg_37_1.end_time
	
	if var_37_1 == SUBSTORY_CONSTANTS.STATE_OPEN then
		if_set_opacity(var_37_0, nil, 255)
		UnlockSystem:setUnlockUIState(arg_37_0.vars.wnd, "btn_achieve", arg_37_1.unlock)
	elseif var_37_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON or var_37_1 == SUBSTORY_CONSTANTS.STATE_CLOSE then
		if_set_opacity(var_37_0, nil, 76.5)
	end
	
	if_set_visible(var_37_0, nil, arg_37_1.achieve_flag and arg_37_1.achieve_flag == "y" and var_37_1 == SUBSTORY_CONSTANTS.STATE_OPEN)
	arg_37_0:setVisiblePrologueBtn(var_37_1, arg_37_1)
	
	local var_37_4 = SubstoryManager:getContents2CommonDB()
	local var_37_5 = var_37_4 == nil or var_37_4.enter_btn_hide_lobby == "y"
	
	if_set_visible(arg_37_0.vars.wnd, "btn_contents2", arg_37_1.contents_type_2 ~= nil and not var_37_5 and (var_37_1 == SUBSTORY_CONSTANTS.STATE_OPEN or var_37_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON))
	
	if arg_37_1.contents_type_2 and arg_37_1.contents_type_2 == SUBSTORY_CONTENTS_TYPE.INFERENCE and var_37_4 and var_37_4.rumble_show_btn == "y" then
		if_set_visible(arg_37_0.vars.wnd, "btn_contents2", true)
		
		local var_37_6 = var_37_4.unlock_clear_stage
		local var_37_7 = Account:isMapCleared(var_37_6) and 255 or 76.5
		
		if_set_opacity(arg_37_0.vars.wnd, "btn_contents2", var_37_7)
	end
	
	if arg_37_1.contents_type_2 and arg_37_1.contents_type_2 == "content_board" then
		local var_37_8 = SubStoryControlBoardUtil:canEnterableContents(arg_37_1.id)
		
		if_set_opacity(arg_37_0.vars.wnd, "btn_contents2", var_37_8 and 255 or 76.5)
	end
	
	local var_37_9 = arg_37_1.shop_schedule == nil or SubstoryManager:isOpenSubstoryShop(arg_37_1.shop_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	local var_37_10 = var_37_1 ~= SUBSTORY_CONSTANTS.STATE_READY and arg_37_1.category and var_37_9
	
	if_set_visible(arg_37_0.vars.wnd, "btn_shop", var_37_10)
	if_set_visible(arg_37_0.vars.wnd, "btn_pass", arg_37_1.pass_id ~= nil and var_37_1 ~= SUBSTORY_CONSTANTS.STATE_READY)
	
	local var_37_11 = arg_37_0.vars.wnd:getChildByName("btn_prologue")
	local var_37_12 = arg_37_0.vars.wnd:getChildByName("btn_shop")
	local var_37_13 = arg_37_0.vars.wnd:getChildByName("btn_contents2")
	local var_37_14 = arg_37_0.vars.wnd:getChildByName("n_prologue")
	
	if arg_37_1.contents_type_2 == nil and arg_37_1.pass_id == nil and arg_37_1.prologue_story or arg_37_1.pass_id == nil and var_37_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON and arg_37_1.prologue_story or var_37_1 == SUBSTORY_CONSTANTS.STATE_READY then
		local var_37_15 = var_37_14:getChildByName("no_pass_contents")
		
		if get_cocos_refid(var_37_15) then
			var_37_11:setPosition(var_37_15:getPosition())
		end
	end
	
	local var_37_16 = arg_37_0.vars.wnd:getChildByName("n_contents")
	
	if get_cocos_refid(var_37_16) and arg_37_1.pass_id == nil and arg_37_1.contents_type_2 then
		local var_37_17 = var_37_16:getChildByName("no_pass")
		
		if get_cocos_refid(var_37_17) then
			var_37_13:setPosition(var_37_17:getPosition())
		end
	end
	
	local var_37_18 = arg_37_0.vars.wnd:getChildByName("n_achieve")
	
	if not var_37_10 and arg_37_1.achieve_flag then
		local var_37_19 = var_37_18:getChildByName("no_exchange")
		
		if get_cocos_refid(var_37_19) and get_cocos_refid(var_37_0) then
			var_37_0:setPosition(var_37_19:getPosition())
		end
	end
	
	local var_37_20 = SubstoryManager:getContents2CommonDB()
	
	if var_37_20 and var_37_20.enter_btn_text and var_37_20.enter_btn_icon then
		if_set(var_37_13, "label", T(var_37_20.enter_btn_text))
		if_set_sprite(var_37_13, "icon", var_37_20.enter_btn_icon)
	end
	
	for iter_37_0 = 1, 2 do
		if_set_visible(arg_37_0.vars.wnd, string.format("n_buff_list%02d", iter_37_0), false)
	end
	
	local var_37_21 = arg_37_0.vars.wnd:getChildByName("btn_help")
	
	if get_cocos_refid(var_37_21) then
		var_37_21:setVisible(arg_37_1.help_id ~= nil)
		
		var_37_21.help_id = arg_37_1.help_id
	end
	
	arg_37_0:setVisibleArtiEffectBtn(var_37_1, arg_37_1)
	
	local var_37_22 = {}
	
	if var_37_1 ~= SUBSTORY_CONSTANTS.STATE_READY then
		var_37_22 = SubStoryUtil:getTopbarCurrencies(arg_37_1)
		
		if table.empty(var_37_22) then
			var_37_22 = {
				"crystal",
				"gold",
				"stamina"
			}
		end
	end
	
	local var_37_23 = SubstoryManager:isSystemSubStory()
	
	if_set_visible(arg_37_0.vars.wnd, "n_change_story", var_37_23)
	
	if var_37_23 then
		local var_37_24 = SubStoryUtil:getRemainTimeToChangeSystemSubstory()
		local var_37_25 = var_37_24 <= 0
		local var_37_26 = arg_37_0.vars.wnd:getChildByName("n_not_availble")
		
		if_set_visible(arg_37_0.vars.wnd, "btn_go_change", var_37_25)
		if_set_visible(var_37_26, nil, not var_37_25)
		
		if not var_37_25 then
			if_set(var_37_26, "t_time_left", T("systemsubstory_change_time_info", {
				time = sec_to_full_string(var_37_24, false, {
					count = 2
				})
			}))
		end
	end
	
	TopBarNew:setCurrencies(var_37_22)
	TopBarNew:setVisible(true)
end

function SubStoryLobbyUIDefault.updateEnterQueryUI(arg_38_0, arg_38_1)
	if not arg_38_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	arg_38_0:exceptionHandling(arg_38_1)
end

function HANDLER.dungeon_story_challenge_item(arg_39_0, arg_39_1)
	if arg_39_1 == "btn_banner" then
		SubStoryLobbyUIChallenge:showReady(arg_39_0.enter_id, arg_39_0.difficulty_level)
	end
end

function HANDLER.dungeon_story_challenge(arg_40_0, arg_40_1)
	if arg_40_1 == "btn_shop" then
		SubStoryLobby:hideBG()
		SubstoryManager:openStoryShop()
		
		return 
	elseif arg_40_1 == "btn_achieve" then
		SubstoryAchievePopup:show()
		
		return 
	end
end

SubStoryLobbyUIChallenge = SubStoryLobbyUIChallenge or {}

copy_functions(SubStoryLobbyCommon, SubStoryLobbyUIChallenge)

function SubStoryLobbyUIChallenge.getLeftParentNode(arg_41_0, arg_41_1)
	if not get_cocos_refid(arg_41_0.vars.wnd) then
		return 
	end
	
	if get_cocos_refid(arg_41_0.vars.p_node) then
		return arg_41_0.vars.p_node
	end
	
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_1")
	local var_41_1 = arg_41_0.vars.wnd:getChildByName("n_2")
	local var_41_2 = var_41_0
	local var_41_3 = arg_41_1.achieve_flag == "y" and arg_41_1.category
	
	if_set_visible(var_41_0, nil, not var_41_3)
	if_set_visible(var_41_1, nil, var_41_3)
	
	if var_41_3 then
		var_41_2 = var_41_1
	end
	
	arg_41_0.vars.p_node = var_41_2
	
	return arg_41_0.vars.p_node
end

function SubStoryLobbyUIChallenge.onEnterUI(arg_42_0, arg_42_1, arg_42_2)
	arg_42_0.vars = {}
	arg_42_0.vars.wnd = arg_42_1
	
	local var_42_0 = arg_42_0:getContentsDB(arg_42_2.id)
	
	arg_42_0:updateBG(arg_42_2, var_42_0)
	if_set_visible(arg_42_0.vars.wnd, "icon_achieve_noti", false)
	
	local var_42_1 = arg_42_0:getLeftParentNode(arg_42_2)
	
	if_set(var_42_1, "t_boss_name", T(arg_42_2.name))
	
	local var_42_2 = var_42_1:getChildByName("n_core_reward")
	local var_42_3 = {
		hero_multiply_scale = 0.85,
		artifact_multiply_scale = 0.6,
		multiply_scale = 0.8
	}
	
	SubstoryManager:setCoreRewardIcons(var_42_2, arg_42_2.id, var_42_3)
	
	local var_42_4 = SubStoryUtil:getEventState(arg_42_2.start_time, arg_42_2.end_time)
	local var_42_5 = arg_42_2.start_time
	local var_42_6 = arg_42_2.end_time
	
	if_set(var_42_1, "label_period", T("ui_dungeon_story_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_42_5,
		end_time = var_42_6
	})))
	TopBarNew:setVisible(true)
	
	local var_42_7 = SubStoryUtil:getTopbarCurrencies(arg_42_2, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:setCurrencies(var_42_7)
	
	if not var_42_0 then
		Log.e("no_contents_db", "need_data")
	end
	
	if_set(arg_42_0.vars.wnd, "chall_title", T(var_42_0.btn_title))
	arg_42_0:updateRemainTime()
	if_set_visible(arg_42_0.vars.wnd, "btn_achieve", arg_42_2.achieve_flag and arg_42_2.achieve_flag == "y" and var_42_4 == SUBSTORY_CONSTANTS.STATE_OPEN)
	if_set_visible(var_42_1, "n_core_reward", var_42_4 == SUBSTORY_CONSTANTS.STATE_OPEN)
end

function SubStoryLobbyUIChallenge.updateBG(arg_43_0, arg_43_1, arg_43_2)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) or not arg_43_1 or not arg_43_2 then
		return 
	end
	
	if arg_43_0.vars.wnd.bg then
		arg_43_0.vars.wnd.bg:removeFromParent()
	end
	
	local var_43_0 = arg_43_1.background_summary
	
	for iter_43_0 = 1, 4 do
		local var_43_1 = arg_43_2["enter_id_" .. iter_43_0]
		local var_43_2 = arg_43_2["change_bg_sum_" .. iter_43_0]
		
		if var_43_1 and var_43_2 and Account:isMapCleared(var_43_1) then
			var_43_0 = var_43_2
		end
	end
	
	local var_43_3 = SubstoryUIUtil:getBackground(arg_43_1.id, var_43_0, {
		isEnter = true,
		isCenter = true
	})
	
	var_43_3:setAnchorPoint(0.5, 0.5)
	var_43_3:setLocalZOrder(-1)
	arg_43_0.vars.wnd:addChild(var_43_3)
	
	arg_43_0.vars.wnd.bg = var_43_3
end

function SubStoryLobbyUIChallenge.updateUI(arg_44_0)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	if not arg_44_0.vars.p_node then
		return 
	end
	
	SubstoryUIUtil:updateNotifier(arg_44_0.vars.p_node)
	
	local var_44_0 = SubstoryManager:getInfo()
	local var_44_1 = arg_44_0:getContentsDB(var_44_0.id)
	
	arg_44_0:updateBG(var_44_0, var_44_1)
end

function SubStoryLobbyUIChallenge.createCard(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	local var_45_0 = load_control("wnd/dungeon_story_challenge_item.csb")
	
	arg_45_1:addChild(var_45_0)
	
	if not arg_45_3 then
		var_45_0:setVisible(false)
		
		return 
	end
	
	local var_45_1 = var_45_0:getChildByName("n_icon_difficulty")
	
	if arg_45_4 then
		if_set_sprite(var_45_0, "img_banner", "banner/" .. arg_45_4 .. ".png")
	end
	
	for iter_45_0 = 1, 4 do
		if_set_visible(var_45_1, tostring(iter_45_0), arg_45_2 == iter_45_0)
	end
	
	local var_45_2 = var_45_0:getChildByName("btn_banner")
	
	var_45_2.enter_id = arg_45_3
	var_45_2.difficulty_level = arg_45_2 - 1
	
	local var_45_3 = {
		"ui_battle_ready_difficulty_easy",
		"ui_battle_ready_difficulty_normal",
		"ui_battle_ready_difficulty_hard",
		"ui_battle_ready_difficulty_hell"
	}
	
	if_set(var_45_0, "t_difficulty", T(var_45_3[arg_45_2]))
	
	local var_45_4 = DB("level_enter", arg_45_3, "use_enterpoint")
	local var_45_5 = BattleReady:GetReqPointAndRewards(arg_45_3)
	
	if_set(var_45_0, "label_0", tostring(var_45_4))
	if_set(var_45_0, "t_power", comma_value(var_45_5))
	
	local var_45_6 = var_45_0:getChildByName("card")
	local var_45_7 = SubstoryManager:getInfo()
	local var_45_8 = SubStoryUtil:getEventState(var_45_7.start_time, var_45_7.end_time)
	
	if not Account:checkEnterMap(arg_45_3) or var_45_8 ~= SUBSTORY_CONSTANTS.STATE_OPEN then
		if_set_color(var_45_0, "n_limit", tocolor("#888888"))
		var_45_6:setOpacity(76.5)
	end
	
	local var_45_9 = var_45_0:getPositionX()
	
	var_45_0:setPositionX(var_45_0:getPositionX() + var_45_0:getContentSize().width)
	UIAction:Add(SPAWN(LOG(OPACITY(arg_45_2 * 150, 0, 1)), LOG(MOVE_TO(50 * arg_45_2, var_45_9, 0))), var_45_0, "block")
	
	if Account:isMapCleared(arg_45_3) then
		local var_45_10 = var_45_0:getChildByName("icon_clear")
		
		var_45_10:setPositionX(var_45_0:getChildByName("t_difficulty"):getContentSize().width + var_45_10:getContentSize().width - 15)
		UIAction:Add(SEQ(DELAY(arg_45_2 * 100), SPAWN(SHOW(true), LOG(SCALE(100, 0, 1.6)))), var_45_10, "")
	end
	
	if_set_visible(var_45_0, "n_limit", false)
	BattleSelectDiffcultyUtil:updateLimit(var_45_0, arg_45_3)
end

function SubStoryLobbyUIChallenge.getContentsDB(arg_46_0, arg_46_1)
	return (DBT("substory_challenge", arg_46_1, {
		"id",
		"enter_id_1",
		"enter_id_2",
		"enter_id_3",
		"enter_id_4",
		"btn_bg_1",
		"btn_bg_2",
		"btn_bg_3",
		"btn_bg_4",
		"change_bg_sum_1",
		"change_bg_sum_2",
		"change_bg_sum_3",
		"change_bg_sum_4",
		"btn_title"
	}))
end

function SubStoryLobbyUIChallenge.showReady(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = SubstoryManager:getInfo()
	local var_47_1 = SubStoryUtil:getEventState(var_47_0.start_time, var_47_0.end_time)
	
	if var_47_1 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON or var_47_1 == SUBSTORY_CONSTANTS.STATE_CLOSE then
		balloon_message_with_sound("end_sub_story_event")
		
		return 
	end
	
	if var_47_1 ~= SUBSTORY_CONSTANTS.STATE_OPEN then
		balloon_message_with_sound("battle_cant_getin")
		
		return 
	end
	
	if not Account:checkEnterMap(arg_47_1) then
		balloon_message_with_sound("ui_battle_ready_difficulty_error")
		
		return 
	end
	
	BattleReady:show({
		hide_open_difficulty = true,
		enter_id = arg_47_1,
		callback = arg_47_0,
		difficulty_level = arg_47_2
	})
end

function SubStoryLobbyUIChallenge.onStartBattle(arg_48_0, arg_48_1)
	if Account:getCurrentTeam()[1] == nil and Account:getCurrentTeam()[2] == nil and Account:getCurrentTeam()[3] == nil and Account:getCurrentTeam()[4] == nil and not arg_48_1.npcteam_id then
		message(T("ui_need_hero"))
		
		return 
	end
	
	local var_48_0 = DB("level_enter", arg_48_1.enter_id, {
		"type"
	})
	
	Dialog:closeAll()
	startBattle(arg_48_1.enter_id, arg_48_1)
	BattleReady:hide()
end

function SubStoryLobbyUIChallenge.updateRemainTime(arg_49_0)
	if not arg_49_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_49_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_49_0.vars.p_node) then
		return 
	end
	
	local var_49_0, var_49_1, var_49_2 = SubstoryManager:getEventTimeInfo()
	local var_49_3 = os.time()
	local var_49_4 = arg_49_0.vars.p_node:getChildByName("label_remine_time")
	
	if get_cocos_refid(var_49_4) and var_49_4:isVisible() == true then
		if SUBSTORY_CONSTANTS.STATE_OPEN == var_49_0 then
			local var_49_5 = var_49_2 - var_49_3
			
			if_set(var_49_4, nil, T("time_remain", {
				time = sec_to_string(var_49_5)
			}))
		elseif SUBSTORY_CONSTANTS.STATE_CLOSE_SOON == var_49_0 then
			local var_49_6 = var_49_2 + SUBSTORY_CONSTANTS.ONE_WEEK - var_49_3
			
			if_set(var_49_4, nil, T("time_remain", {
				time = sec_to_string(var_49_6)
			}))
		end
	end
end

function SubStoryLobbyUIChallenge.updateEnterQueryUI(arg_50_0, arg_50_1)
	if not arg_50_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_50_0.vars.wnd) then
		return 
	end
	
	local var_50_0 = arg_50_0:getContentsDB(arg_50_1.id)
	
	if not var_50_0 then
		Log.e("no_contents_db", "need_data")
	end
	
	for iter_50_0 = 1, 4 do
		local var_50_1 = var_50_0["enter_id_" .. tostring(iter_50_0)]
		local var_50_2 = var_50_0["btn_bg_" .. tostring(iter_50_0)]
		local var_50_3 = arg_50_0.vars.wnd:getChildByName("n_difficulty_card" .. iter_50_0)
		
		if var_50_3 then
			arg_50_0:createCard(var_50_3, iter_50_0, var_50_1, var_50_2)
		end
	end
	
	arg_50_0:updateUI()
end
