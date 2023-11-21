SubstoryFestivalInn = SubstoryFestivalInn or {}

function HANDLER.dungeon_story_festival_inn(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_choice_1" then
		SubstoryFestivalInn:onButtonNextDay()
	elseif arg_1_1 == "btn_choice_2" then
		SubstoryFestivalInn:close()
	end
end

function HANDLER.dungeon_story_day_change(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_ok" then
		SubstoryFestivalInn:queryNextDay()
	elseif arg_2_1 == "btn_cancel" then
		Dialog:close("dungeon_story_day_change")
	end
end

function MsgHandler.substory_festival_next_day(arg_3_0)
	if arg_3_0.substory_id and arg_3_0.info then
		Account:setSubStoryFestivals(arg_3_0.substory_id, arg_3_0.info)
		Dialog:close("dungeon_story_day_change")
		SubstoryFestivalInn:onNextDay()
		ConditionContentsManager:initSubStoryFestival(arg_3_0.substory_id)
		
		local var_3_0 = SubStoryLobby:getWnd()
		
		SubStoryFestivalUIUtil:updateNotiBalloon(arg_3_0.substory_id, var_3_0, true)
	else
		Log.e("substory_festival_next_day", "no_rtn_data")
	end
end

function SubstoryFestivalInn.show(arg_4_0)
	if not SubStoryFestival:isOpenEvent() then
		balloon_message_with_sound("fm_error_4")
		
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.info = SubstoryManager:getInfo()
	
	local var_4_0 = SceneManager:getRunningPopupScene()
	local var_4_1 = Dialog:open("wnd/dungeon_story_festival_inn", arg_4_0)
	
	arg_4_0.vars.wnd = var_4_1
	
	local var_4_2 = DB("substory_festival_fm", arg_4_0.vars.info.id, "npc_inn")
	local var_4_3 = arg_4_0:setNPCPortrait(var_4_2)
	
	arg_4_0:setNPCTextAndFace(var_4_2, var_4_3)
	
	if arg_4_0:isSchedulable() then
		if_set_opacity(var_4_1, "balloon_1", 255)
	else
		if_set_opacity(var_4_1, "balloon_1", 76.5)
	end
	
	var_4_0:addChild(var_4_1)
	arg_4_0.vars.wnd:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(300)), arg_4_0.vars.wnd, "block")
	
	if arg_4_0.vars.info.id == "vma1ba" and TutorialGuide:isPlayingTutorial() then
		TutorialGuide:procGuide("tuto_vma1ba_nextday")
	end
end

function SubstoryFestivalInn.setNPCPortrait(arg_5_0, arg_5_1)
	local var_5_0 = UIUtil:getPortraitAni(arg_5_1, {})
	local var_5_1 = arg_5_0.vars.wnd:getChildByName("portrait")
	
	if var_5_0 and get_cocos_refid(var_5_1) then
		var_5_1:addChild(var_5_0)
		var_5_0:setName("@portrait")
		var_5_0:setScale(1.2)
		var_5_1:setVisible(true)
	end
	
	return var_5_0
end

function SubstoryFestivalInn.setNPCTextAndFace(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_talk")
	local var_6_1 = DB("character", arg_6_1, "name")
	local var_6_2, var_6_3 = arg_6_0:isSchedulable()
	local var_6_4 = arg_6_0.vars.info.id
	local var_6_5 = ""
	local var_6_6 = ""
	
	if var_6_3 == "max" then
		var_6_5 = DB("substory_festival_fm", var_6_4, "inn_text_end")
		var_6_6 = DB("substory_festival_fm", var_6_4, "inn_face_end")
	elseif not var_6_2 then
		var_6_5 = DB("substory_festival_fm", var_6_4, "inn_text_imposs")
		var_6_6 = DB("substory_festival_fm", var_6_4, "inn_face_imposs")
	else
		var_6_5 = DB("substory_festival_fm", var_6_4, "inn_text_poss")
		var_6_6 = DB("substory_festival_fm", var_6_4, "inn_face_poss")
	end
	
	if get_cocos_refid(var_6_0) then
		if_set(var_6_0, "txt_name", T(var_6_1))
		if_set(var_6_0, "txt_info", T(var_6_5))
	end
	
	if get_cocos_refid(arg_6_2) then
		local var_6_7 = StoryFace:getFaceAni(var_6_6)
		
		if var_6_7 then
			arg_6_2:setSkin(var_6_7)
		end
	end
end

function SubstoryFestivalInn.onButtonNextDay(arg_7_0)
	local var_7_0, var_7_1 = arg_7_0:isSchedulable()
	
	if not var_7_0 then
		if var_7_1 == "max" then
			balloon_message_with_sound("fm_last_day_msg")
			
			return 
		elseif var_7_1 == "mission" then
			balloon_message_with_sound("fm_error_3")
			
			return 
		end
	end
	
	arg_7_0:showDialogNextDay()
end

function SubstoryFestivalInn.showDialogNextDay(arg_8_0)
	local var_8_0 = arg_8_0.vars.wnd or SceneManager:getRunningPopupScene()
	local var_8_1 = Dialog:open("wnd/dungeon_story_day_change", arg_8_0)
	local var_8_2 = arg_8_0.vars.info.id
	local var_8_3 = Account:getSubStoryFestivalInfo(var_8_2).day
	local var_8_4 = DB("substory_festival", var_8_2 .. string.format("_%02d", var_8_3), "progress_date_ui")
	local var_8_5 = var_8_1:getChildByName("n_before")
	
	if_set(var_8_5, "t_day", T(var_8_4))
	
	local var_8_6 = var_8_3 + 1
	local var_8_7 = DB("substory_festival", var_8_2 .. string.format("_%02d", var_8_6), "progress_date_ui")
	local var_8_8 = var_8_1:getChildByName("n_after")
	
	if_set(var_8_8, "t_day", T(var_8_7))
	var_8_0:addChild(var_8_1)
end

function SubstoryFestivalInn.isSchedulable(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or arg_9_0.vars.info
	
	local var_9_0 = Account:getSubStoryFestivalInfo(arg_9_1.id).day
	
	if arg_9_0:isLastDay(var_9_0, arg_9_1) then
		return false, "max"
	end
	
	if not arg_9_0:isDailyMissionCleared(arg_9_1) then
		return false, "mission"
	end
	
	return true, nil
end

function SubstoryFestivalInn.isLastDay(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or arg_10_0.vars.info
	arg_10_1 = arg_10_1 or Account:getSubStoryFestivalInfo(arg_10_2.id).day
	
	return arg_10_1 >= DB("substory_festival_fm", arg_10_2.id, "fm_max_day")
end

function SubstoryFestivalInn.isDailyMissionCleared(arg_11_0, arg_11_1)
	arg_11_1 = arg_11_1 or arg_11_0.vars.info
	
	return Account:getSubStoryFestivalInfo(arg_11_1.id).mission_state1 == SUBSTORY_FESTIVAL_STATE.REWARDED
end

function SubstoryFestivalInn.onNextDay(arg_12_0)
	local var_12_0 = SubStoryLobbyUIFestival.vars.wnd
	
	EffectManager:Play({
		fn = "stagechange_cloud.cfx",
		delay = 0,
		pivot_z = 99998,
		layer = arg_12_0.vars.wnd,
		pivot_x = VIEW_WIDTH / 2 + 90,
		pivot_y = VIEW_HEIGHT / 2
	})
	SubstoryFestivalInn:close(200)
	SubStoryFestivalUIUtil:updateFestivalDateUI(var_12_0)
end

function SubstoryFestivalInn.queryNextDay(arg_13_0)
	if not SubStoryFestival:isOpenEvent() then
		balloon_message_with_sound("fm_error_4")
		
		return 
	end
	
	query("substory_festival_next_day", {
		substory_id = arg_13_0.vars.info.id
	})
end

function SubstoryFestivalInn.close(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or 0
	
	UIAction:Add(SEQ(DELAY(arg_14_1), FADE_OUT(300), CALL(function()
		if not arg_14_0.vars then
			return 
		end
		
		if arg_14_0.vars and get_cocos_refid(arg_14_0.vars.wnd) then
			arg_14_0.vars.wnd:removeFromParent()
		end
		
		BackButtonManager:pop({
			check_id = "Dialog.dungeon_story_festival_inn"
		})
		
		arg_14_0.vars.wnd = nil
		arg_14_0.vars = nil
	end)), arg_14_0.vars.wnd, "block")
end
