SubstoryAlbumPieceState = {
	OPEN = 1,
	COMPLETE = 2,
	LOCK = 0
}

local var_0_0 = 24

function HANDLER.dungeon_story_album_mission(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ok" then
		Dialog:close("dungeon_story_album_mission")
	elseif arg_1_1 == "btn_renew" then
		Dialog:close("dungeon_story_album_mission")
		SubstoryAlbumMain:showRefreshMission(arg_1_0.piece_num)
	end
end

function HANDLER.dungeon_story_album_mission_renew(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_renew" then
		SubstoryAlbumMain:queryRefresh(arg_2_0.piece_num)
	elseif arg_2_1 == "btn_cancel" then
		Dialog:close("dungeon_story_album_mission_renew")
	end
end

function HANDLER.quick_menu_album_info(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_move" then
		Dialog:close("quick_menu_album_info")
		
		if SceneManager:getCurrentSceneName() == "substory_album" then
			TopBarNew:closeQuickMenu()
			
			return 
		else
			SceneManager:reserveResetSceneFlow()
			GlobalSubstoryManager:enterQuery(arg_3_0.substory_id)
		end
	elseif arg_3_1 == "btn_close" then
		Dialog:close("quick_menu_album_info")
	end
end

function HANDLER.dungeon_story_album(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		Dialog:close("dungeon_story_piece")
	elseif arg_4_1 == "btn_reward_list" then
		SubstoryAlbumMain:showAllRewardList()
	elseif arg_4_1 == "btn_start" then
		local var_4_0 = SubstoryAlbumMain:getInfo()
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = var_4_0.unlock
		}, function()
			SubstoryAlbum:query_issue_album()
		end)
	elseif string.starts(arg_4_1, "btn_piece") then
		local var_4_1 = string.split(arg_4_1, "btn_piece")[2]
		
		SubstoryAlbumMain:onEventBtnPiece(var_4_1)
	elseif arg_4_1 == "btn_renew" then
		SubstoryAlbumMain:showRefreshMission(arg_4_0.piece_num)
	elseif arg_4_1 == "btn_progress_prologue" then
		SubstoryAlbumMain:onEventPrologue()
	elseif string.starts(arg_4_1, "btn_progress") then
		local var_4_2 = string.split(arg_4_1, "btn_progress")[2]
		
		SubstoryAlbumMain:onEventProgress(tonumber(var_4_2))
	elseif string.starts(arg_4_1, "btn_mission") and arg_4_0.info and arg_4_0.info.piece then
		SubstoryAlbumMain:onEventBtnMission(arg_4_0.info.piece)
	end
end

function MsgHandler.issue_substory_piece_album(arg_6_0)
	if arg_6_0.substory_id and arg_6_0.substory_piece_infos then
		Account:setSubStoryAlbumPieces(arg_6_0.substory_piece_infos)
		SubstoryAlbumMain:startAlbum()
		SubstoryAlbumMain:updateUI()
	else
		Log.e("issue_substory_piece_album", "no_rtn_data")
	end
end

function MsgHandler.substory_album_progress_event(arg_7_0)
	if arg_7_0.global_substory_info then
		Account:setGlobalSubstory(arg_7_0.global_substory_info)
		SubstoryAlbumMain:updateUI()
		SubstoryAlbumMain:onPlayEvent(arg_7_0.event_num)
	else
		Log.e("issue_substory_piece_album", "no_rtn_data")
	end
end

function MsgHandler.substory_issue_mission_album(arg_8_0)
	if arg_8_0.mission_info and arg_8_0.issued_mission_id and arg_8_0.piece_info then
		Account:setSubStoryAlbumMissions(arg_8_0.mission_info)
		SubstoryAlbumMain:showIssuedMissionDlg(arg_8_0.piece_num)
		Account:updateSubStoryAlbumPiece(arg_8_0.piece_num, arg_8_0.piece_info)
		SubstoryAlbumMain:updateUI()
		SubstoryAlbumMain:updateMissionUI(SubstoryAlbumMain:getWnd(), SubstoryAlbumMain:getSubstoryID())
		ConditionContentsManager:initSubStoryAlbumConditions()
	else
		Log.e("substory_issue_mission_album", "no_rtn_data")
	end
end

function MsgHandler.refresh_substory_album_mission(arg_9_0)
	if arg_9_0.mission_info and arg_9_0.issued_mission_id and arg_9_0.piece_info then
		Account:setSubStoryAlbumMissions(arg_9_0.mission_info)
		Account:updateSubStoryAlbumPiece(arg_9_0.piece_num, arg_9_0.piece_info)
		SubstoryAlbumMain:updateMissionUI(SubstoryAlbumMain:getWnd(), SubstoryAlbumMain:getSubstoryID())
		ConditionContentsManager:initSubStoryAlbumConditions()
		SubstoryAlbumMain:updateRenewDlg(arg_9_0.piece_num)
		balloon_message_with_sound("substory_album_popup2_msg")
	else
		Log.e("refresh_substory_album_mission", "no_rtn_data")
	end
	
	if arg_9_0.result then
		Account:addReward(arg_9_0.result)
	end
end

function MsgHandler.unlock_piece_album(arg_10_0)
	if arg_10_0.rewards then
		Account:addReward(arg_10_0.rewards, {
			effect = true,
			single = true,
			no_randombox_eff = true,
			parent = SceneManager:getRunningPopupScene()
		})
	end
	
	if arg_10_0.no_effect_rewards then
		Account:addReward(arg_10_0.no_effect_rewards)
	end
	
	if arg_10_0.piece_num and arg_10_0.piece_info then
		Account:updateSubStoryAlbumPiece(arg_10_0.piece_num, arg_10_0.piece_info)
	end
	
	if arg_10_0.mission_info then
		Account:setSubStoryAlbumMissions(arg_10_0.mission_info)
	end
	
	local var_10_0 = 167
	
	if SubstoryAlbum:isComplete(arg_10_0.piece_info.substory_id) then
		var_10_0 = 334
	end
	
	UIAction:Add(SEQ(DELAY(var_10_0), CALL(function()
		SubstoryAlbumMain:updateData()
		SubstoryAlbumMain:updateSortRewardData()
	end)), SubstoryAlbumMain:getWnd(), "block")
	SubstoryAlbumMain:playEffect(arg_10_0.piece_num)
end

local function var_0_1(arg_12_0, arg_12_1)
	if not arg_12_0 or is_playing_story() then
		return 
	end
	
	local var_12_0 = arg_12_1 or {}
	
	var_12_0.force = true
	
	start_new_story(nil, arg_12_0, var_12_0)
end

SubstoryAlbum = SubstoryAlbum or {}

function SubstoryAlbum.query_issue_album(arg_13_0)
	if not SubstoryManager:isActiveSchedule(SubstoryAlbumMain:getSubstoryID()) then
		balloon_message_with_sound("over_schedule_substory_album")
		
		return 
	end
	
	query("issue_substory_piece_album", {
		substory_id = SubstoryAlbumMain:getSubstoryID()
	})
end

function SubstoryAlbum.getCountOpenPiece(arg_14_0, arg_14_1)
	local var_14_0 = Account:getSubStoryAlbumPiecesBySubstoryID(arg_14_1) or {}
	local var_14_1 = 0
	
	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if iter_14_1.state >= SubstoryAlbumPieceState.COMPLETE then
			var_14_1 = var_14_1 + 1
		end
	end
	
	return var_14_1
end

function SubstoryAlbum.isComplete(arg_15_0, arg_15_1)
	return var_0_0 <= SubstoryAlbum:getCountOpenPiece(arg_15_1)
end

function SubstoryAlbum.canReceiveMissionReward(arg_16_0, arg_16_1)
	local var_16_0 = Account:getSubStoryAlbumMissionInfo(arg_16_1)
	
	if not var_16_0 then
		return false
	end
	
	for iter_16_0 = 1, 3 do
		local var_16_1 = var_16_0["piece" .. tostring(iter_16_0)]
		local var_16_2 = var_16_0["mission_id" .. tostring(iter_16_0)]
		local var_16_3 = var_16_0["mission_state" .. tostring(iter_16_0)]
		
		if var_16_1 and var_16_2 and var_16_3 == SUBSTORY_ALBUM_STATE.CLEAR then
			return true
		end
	end
	
	return false
end

function SubstoryAlbum.getEventPercent(arg_17_0, arg_17_1, arg_17_2)
	return math.floor(100 / arg_17_1 * tonumber(arg_17_2))
end

function SubstoryAlbum.isProgressEvent(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = Account:getGlobalSubstoryByID(arg_18_1).board_state
	
	if arg_18_3 <= var_18_0 then
		return "clear", false
	end
	
	local var_18_1 = SubstoryAlbum:getCountOpenPiece(arg_18_1) / var_0_0
	
	if arg_18_0:getEventPercent(arg_18_2, arg_18_3) > var_18_1 * 100 then
		return "lack", false
	end
	
	if arg_18_3 > var_18_0 + 1 then
		return "prev", false
	end
	
	return nil, true
end

function SubstoryAlbum.isEmptyAllMissions(arg_19_0, arg_19_1)
	local var_19_0 = true
	local var_19_1 = Account:getSubStoryAlbumMissionInfo(arg_19_1)
	
	for iter_19_0 = 1, 3 do
		local var_19_2 = var_19_1["piece" .. tostring(iter_19_0)]
		local var_19_3 = var_19_1["mission_id" .. tostring(iter_19_0)]
		local var_19_4 = var_19_1["mission_state" .. tostring(iter_19_0)]
		
		if var_19_2 ~= nil and var_19_3 ~= nil then
			var_19_0 = false
			
			break
		end
	end
	
	return var_19_0
end

SubstoryAlbumMain = SubstoryAlbumMain or {}

function SubstoryAlbumMain.getSubstoryID(arg_20_0)
	return arg_20_0.vars.info.id
end

function SubstoryAlbumMain.getInfo(arg_21_0)
	return arg_21_0.vars.info
end

function SubstoryAlbumMain.getWnd(arg_22_0)
	return arg_22_0.vars.wnd
end

function SubstoryAlbumMain.onEventBtnPiece(arg_23_0, arg_23_1)
	if not arg_23_0.vars.is_start then
		return 
	end
	
	local var_23_0 = Account:getSubStoryAlbumPiece(arg_23_0.vars.info.id, arg_23_1)
	
	if var_23_0.state == SubstoryAlbumPieceState.LOCK then
		if not GlobalSubstoryManager:isActiveSchedule(arg_23_0.vars.info.id) then
			balloon_message_with_sound("over_schedule_substory_album")
			
			return 
		end
		
		local var_23_1 = false
		local var_23_2 = Account:getSubStoryAlbumMissionInfo(arg_23_0.vars.info.id)
		
		for iter_23_0 = 1, 3 do
			local var_23_3 = var_23_2["piece" .. tostring(iter_23_0)]
			local var_23_4 = var_23_2["mission_id" .. tostring(iter_23_0)]
			local var_23_5 = var_23_2["mission_state" .. tostring(iter_23_0)]
			
			if var_23_3 == nil and var_23_4 == nil then
				var_23_1 = true
			end
		end
		
		if not var_23_1 then
			balloon_message_with_sound("substory_album_error3")
			
			return 
		end
		
		query("substory_issue_mission_album", {
			substory_id = SubstoryAlbumMain:getSubstoryID(),
			piece_num = arg_23_1
		})
	elseif var_23_0.state == SubstoryAlbumPieceState.OPEN then
		local var_23_6 = Account:getSubStoryAlbumMissionByPieceNum(arg_23_0.vars.info.id, arg_23_1)
		
		if var_23_6 and var_23_6.state == SUBSTORY_ALBUM_STATE.CLEAR then
			local var_23_7 = var_0_0
			local var_23_8 = SubstoryAlbum:getCountOpenPiece(SubstoryAlbumMain:getSubstoryID()) >= var_23_7 - 1
			
			query("unlock_piece_album", {
				substory_id = arg_23_0.vars.info.id,
				piece = arg_23_1,
				is_complete = var_23_8
			})
		elseif var_23_6 then
			SubstoryAlbumMain:playEffectLink(arg_23_1)
		end
	end
end

function SubstoryAlbumMain.onEventPrologue(arg_24_0, arg_24_1)
	if not arg_24_0.vars.is_start then
		balloon_message_with_sound("substory_album_error4")
		
		return 
	end
	
	local var_24_0 = DB("substory_album", arg_24_0.vars.info.id, {
		"start_story"
	})
	
	var_0_1(var_24_0)
end

function SubstoryAlbumMain.onEventProgress(arg_25_0, arg_25_1)
	local var_25_0, var_25_1 = SubstoryAlbum:isProgressEvent(arg_25_0.vars.info.id, arg_25_0.vars.event_count, arg_25_1)
	
	if var_25_1 then
		query("substory_album_progress_event", {
			substory_id = arg_25_0.vars.info.id,
			event_num = arg_25_1
		})
	elseif var_25_0 == "lack" then
		balloon_message_with_sound("substory_album_error1")
	elseif var_25_0 == "prev" then
		balloon_message_with_sound("substory_album_error2")
	elseif var_25_0 == "clear" then
		SubstoryAlbumMain:onPlayEvent(arg_25_1)
	end
end

function SubstoryAlbumMain.onPlayEvent(arg_26_0, arg_26_1)
	local var_26_0 = DBT("substory_album", arg_26_0.vars.info.id, {
		"event_" .. tostring(arg_26_1) .. "_type",
		"event_" .. tostring(arg_26_1) .. "_value"
	})
	local var_26_1 = var_26_0["event_" .. tostring(arg_26_1) .. "_type"]
	local var_26_2 = var_26_0["event_" .. tostring(arg_26_1) .. "_value"]
	
	if var_26_1 == "story" then
		var_0_1(var_26_2)
	elseif var_26_1 == "quest" then
		BattleReady:show({
			enter_id = var_26_2,
			callback = SubstoryAlbumMain
		})
	end
end

function SubstoryAlbumMain.onStartBattle(arg_27_0, arg_27_1)
	if Account:getCurrentTeam()[1] == nil and Account:getCurrentTeam()[2] == nil and Account:getCurrentTeam()[3] == nil and Account:getCurrentTeam()[4] == nil and not arg_27_1.npcteam_id then
		message(T("worldmap_town_lua_1523"))
		
		return 
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_27_1.enter_id)
	startBattle(arg_27_1.enter_id, arg_27_1)
	BattleReady:hide()
end

function SubstoryAlbumMain.isRequestSubStoryPieceAlbum(arg_28_0, arg_28_1)
	local var_28_0 = Account:getSubStoryAlbumPiecesBySubstoryID(arg_28_1) or {}
	
	if table.count(var_28_0) <= 0 then
		return true
	end
	
	return false
end

function SubstoryAlbumMain.show(arg_29_0, arg_29_1, arg_29_2)
	arg_29_2 = arg_29_2 or {}
	arg_29_0.vars = {}
	
	local var_29_0 = load_dlg("dungeon_story_album", true, "wnd")
	
	arg_29_1:addChild(var_29_0)
	
	arg_29_0.vars.wnd = var_29_0
	arg_29_0.vars.info = arg_29_2.info
	
	TopBarNew:create(T("substory_title"), var_29_0, function()
		SubstoryAlbumMain:onPushBack()
	end)
	TopBarNew:forcedHelp_OnOff(false)
	
	arg_29_0.vars.is_start = not arg_29_0:isRequestSubStoryPieceAlbum(arg_29_0.vars.info.id)
	arg_29_0.vars.event_count = 0
	
	for iter_29_0 = 1, 4 do
		if DB("substory_album", arg_29_0.vars.info.id, "event_" .. tostring(iter_29_0) .. "_type") then
			arg_29_0.vars.event_count = arg_29_0.vars.event_count + 1
		else
			break
		end
	end
	
	for iter_29_1 = 2, 4 do
		if_set_visible(arg_29_0.vars.wnd, "n_" .. tostring(iter_29_1) .. "event", iter_29_1 == arg_29_0.vars.event_count)
	end
	
	arg_29_0:initUI()
	arg_29_0:updateData()
	arg_29_0:initRewardData()
	arg_29_0:setCoreRewardUI()
	
	if arg_29_0.vars.is_start then
		TutorialGuide:startGuide("tuto_album")
	else
		if_set_opacity(arg_29_0.vars.wnd, "btn_progress_prologue", 76.5)
	end
	
	local var_29_1 = arg_29_0.vars.wnd:getChildByName("icon_btn_strat_locked")
	local var_29_2 = arg_29_0.vars.info.unlock == nil or UnlockSystem:isUnlockSystem(arg_29_0.vars.info.unlock)
	local var_29_3 = SubstoryManager:isActiveSchedule(arg_29_0.vars.info.id)
	
	if_set_visible(arg_29_0.vars.wnd, "icon_btn_strat_locked", not var_29_2 or not var_29_3)
	if_set_visible(arg_29_0.vars.wnd, "icon_check_prologue", arg_29_0.vars.is_start)
end

function SubstoryAlbumMain.onPushBack(arg_31_0)
	SubStoryEntrance:show("SUBSTORY_LIST")
end

function SubstoryAlbumMain.initUI(arg_32_0)
	if_set_sprite(arg_32_0.vars.wnd, "spr_bi", arg_32_0.vars.info.banner_icon .. ".png")
	
	local var_32_0 = arg_32_0.vars.wnd:getChildByName("n_progress")
	local var_32_1 = arg_32_0.vars.wnd:getChildByName("n_4event")
	local var_32_2 = arg_32_0.vars.wnd:getChildByName("n_3event")
	local var_32_3 = arg_32_0.vars.wnd:getChildByName("n_2event")
	
	if_set_visible(var_32_1, "tip1", false)
	if_set_visible(var_32_2, "tip1", false)
	if_set_visible(var_32_3, "tip1", false)
	
	local var_32_4 = arg_32_0.vars.wnd:getChildByName("n_" .. tostring(arg_32_0.vars.event_count) .. "event")
	
	if_set_visible(arg_32_0.vars.wnd, "n_start", not arg_32_0.vars.is_start)
	if_set_visible(arg_32_0.vars.wnd, "n_bi", arg_32_0.vars.is_start)
	
	if not arg_32_0.vars.is_start then
		local var_32_5 = arg_32_0.vars.info.background_battle
		
		if_set_sprite(arg_32_0.vars.wnd, "spr_start_bi", arg_32_0.vars.info.banner_icon .. ".png")
		
		local var_32_6 = arg_32_0.vars.wnd:getChildByName("n_start")
		local var_32_7 = DB("substory_bg", var_32_5, "desc")
		local var_32_8 = totable(var_32_7 or {})
		
		if_set(arg_32_0.vars.wnd, "txt_desc", T(var_32_8.txt))
	else
		local var_32_9 = Account:getGlobalSubstoryByID(arg_32_0.vars.info.id).board_state or 0
		local var_32_10, var_32_11 = SubstoryAlbum:isProgressEvent(arg_32_0.vars.info.id, arg_32_0.vars.event_count, 1)
		local var_32_12 = var_32_4:getChildByName("tip1")
		
		var_32_12:setVisible(var_32_9 == 0 and not var_32_11)
		
		if var_32_9 == 0 and not var_32_11 then
			var_32_12:setScale(0)
			
			local var_32_13 = 360
			local var_32_14 = 1
			local var_32_15 = SEQ(DELAY(3000), RLOG(SCALE(80, 1, 0)), SHOW(false))
			
			UIAction:Add(SEQ(DELAY(to_n(var_32_13)), LOG(SCALE(150, 0, var_32_14 * 1.1)), DELAY(50), RLOG(SCALE(80, var_32_14 * 1.1, var_32_14)), var_32_15), var_32_12)
		end
	end
	
	local var_32_16 = DB("substory_main", arg_32_0.vars.info.id, "name")
	
	if_set(arg_32_0.vars.wnd, "txt_title", T(var_32_16))
	
	for iter_32_0 = 1, arg_32_0.vars.event_count do
		local var_32_17 = DBT("substory_album", arg_32_0.vars.info.id, {
			"event_" .. tostring(iter_32_0) .. "_type",
			"event_" .. tostring(iter_32_0) .. "_value"
		})
		local var_32_18 = var_32_17["event_" .. tostring(iter_32_0) .. "_type"]
		local var_32_19 = var_32_17["event_" .. tostring(iter_32_0) .. "_value"]
		local var_32_20 = var_32_4:getChildByName("btn_progress" .. tostring(iter_32_0))
		
		if var_32_18 == "story" and var_32_20 then
			if_set_sprite(var_32_20, "spr_event_icon", "img/icon_menu_story.png")
		elseif var_32_18 == "quest" and var_32_20 then
			if_set_sprite(var_32_20, "spr_event_icon", "img/icon_menu_battle.png")
		end
	end
end

function SubstoryAlbumMain.startAlbum(arg_33_0)
	local var_33_0 = DB("substory_album", arg_33_0.vars.info.id, "start_story")
	
	var_0_1(var_33_0, {
		force = true,
		on_finish = function()
			TutorialGuide:startGuide("tuto_album")
		end
	})
	arg_33_0.vars.wnd:getChildByName("n_start"):setVisible(false)
	
	arg_33_0.vars.is_start = true
	
	if_set_opacity(arg_33_0.vars.wnd, "btn_progress_prologue", 255)
	if_set_visible(arg_33_0.vars.wnd, "icon_check_prologue", true)
end

function SubstoryAlbumMain.getSceneState(arg_35_0)
	return {
		info = arg_35_0.vars.info
	}
end

function SubstoryAlbumMain.onUpdateUI(arg_36_0)
	if SceneManager:getCurrentSceneName() ~= "substory_album" then
		return 
	end
	
	if not arg_36_0.vars then
		return 
	end
	
	if not arg_36_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	arg_36_0:updateUI()
	arg_36_0:updateMissionUI(arg_36_0:getWnd(), arg_36_0:getSubstoryID())
end

function SubstoryAlbumMain.updateUI(arg_37_0)
	local var_37_0 = Account:getGlobalSubstoryByID(arg_37_0.vars.info.id).board_state
	local var_37_1 = SubstoryAlbum:getCountOpenPiece(arg_37_0.vars.info.id) / var_0_0
	local var_37_2 = arg_37_0.vars.wnd:getChildByName("n_progress")
	local var_37_3 = var_37_2:getChildByName("n_" .. tostring(arg_37_0.vars.event_count) .. "event")
	
	for iter_37_0 = 1, arg_37_0.vars.event_count do
		local var_37_4 = var_37_3:getChildByName("btn_progress" .. tostring(iter_37_0))
		
		if_set_visible(var_37_3, "icon_check" .. tostring(iter_37_0), iter_37_0 <= var_37_0)
		
		local var_37_5, var_37_6 = SubstoryAlbum:isProgressEvent(arg_37_0.vars.info.id, arg_37_0.vars.event_count, iter_37_0)
		local var_37_7 = var_37_4:getChildByName("n_eff")
		
		var_37_7:removeAllChildren()
		
		if var_37_6 then
			if_set_opacity(var_37_3, "btn_progress" .. tostring(iter_37_0), 255)
			EffectManager:Play({
				node_name = "@PIECE_PROGRESS",
				fn = "ui_help_btn_glow.cfx",
				layer = var_37_7
			})
		elseif var_37_6 == false and var_37_5 == "clear" then
			if_set_opacity(var_37_3, "btn_progress" .. tostring(iter_37_0), 255)
		else
			if_set_opacity(var_37_3, "btn_progress" .. tostring(iter_37_0), 76.5)
		end
	end
	
	local var_37_8, var_37_9, var_37_10 = DB("substory_album", arg_37_0.vars.info.id, {
		"piece_ambient_color",
		"illust",
		"silhouette"
	})
	local var_37_11 = SubstoryAlbum:isComplete(arg_37_0.vars.info.id)
	local var_37_12 = arg_37_0.vars.wnd:getChildByName("n_illust")
	local var_37_13 = string.find(var_37_9, ".cfx")
	
	if var_37_11 and var_37_13 then
		if var_37_12:findChildByName("spine_img") then
			var_37_12:findChildByName("spine_img"):removeFromParent()
		end
		
		local var_37_14 = var_37_12:findChildByName("img")
		local var_37_15 = EffectManager:Play({
			fn = var_37_9,
			layer = var_37_12,
			x = var_37_14:getPositionX(),
			y = var_37_14:getPositionY()
		})
		
		var_37_15:setAnchorPoint(var_37_14:getAnchorPoint())
		
		local var_37_16 = 0.7493670886075949
		
		var_37_15:setScale(var_37_14:getScale() * var_37_16)
		var_37_15:setName("spine_img")
	elseif var_37_11 then
		if_set_sprite(var_37_12, UIUtil:getIllustPath("story/bg/", var_37_9))
	else
		if_set_sprite(var_37_12, "img_silhouette", UIUtil:getIllustPath("story/bg/", var_37_9))
	end
	
	if_set_visible(arg_37_0.vars.wnd, "spine_img", var_37_11 and var_37_13)
	if_set_visible(arg_37_0.vars.wnd, "img", var_37_11 and not var_37_13)
	if_set_visible(arg_37_0.vars.wnd, "img_silhouette", not var_37_11)
	if_set_visible(arg_37_0.vars.wnd, "n_bi", arg_37_0.vars.is_start and not var_37_11)
	if_set_percent(var_37_2, "progress_bar", var_37_1)
	if_set(var_37_2, "t_percent", math.floor(var_37_1 * 100) .. "%")
	
	local var_37_17 = arg_37_0.vars.wnd:getChildByName("n_piece")
	local var_37_18 = totable(var_37_8)
	
	for iter_37_1 = 1, 24 do
		local var_37_19 = var_37_17:getChildByName("n_piece_" .. tostring(iter_37_1))
		local var_37_20 = var_37_19:getChildByName("n_normal")
		local var_37_21 = var_37_19:getChildByName("img_base")
		local var_37_22 = Account:getSubStoryAlbumPiece(arg_37_0.vars.info.id, iter_37_1) or {}
		local var_37_23 = var_37_22.state or SubstoryAlbumPieceState.LOCK
		local var_37_24 = var_37_19:getChildByName("reward_item")
		
		if_set_color(var_37_19, "img_base", cc.c3b(var_37_18.r, var_37_18.g, var_37_18.b))
		if_set_visible(var_37_19, "img_base", var_37_23 == SubstoryAlbumPieceState.LOCK)
		if_set_visible(var_37_19, "n_normal", var_37_23 ~= SubstoryAlbumPieceState.LOCK)
		
		if var_37_23 == SubstoryAlbumPieceState.OPEN then
			local var_37_25 = Account:getSubStoryAlbumMissionByPieceNum(arg_37_0.vars.info.id, iter_37_1)
			
			if var_37_25.state == SUBSTORY_ALBUM_STATE.ACTIVE then
				if_set_color(var_37_20, "img_normal", cc.c3b(177, 143, 101))
			elseif var_37_25.state == SUBSTORY_ALBUM_STATE.CLEAR then
				if_set_color(var_37_20, "img_normal", cc.c3b(127, 193, 65))
			end
			
			local var_37_26 = var_37_22.piece_id
			local var_37_27, var_37_28, var_37_29, var_37_30 = DB("substory_album_reward", var_37_26, {
				"item_id",
				"item_count",
				"grade_rate",
				"set_rate"
			})
			
			var_37_24:removeAllChildren()
			UIUtil:getRewardIcon(var_37_28, var_37_27, {
				hero_multiply_scale = 1.12,
				artifact_multiply_scale = 0.82,
				pet_multiply_scale = 1.12,
				parent = var_37_24,
				grade_rate = var_37_29,
				set_drop = var_37_30
			})
		elseif var_37_23 == SubstoryAlbumPieceState.COMPLETE then
			var_37_20:setVisible(false)
		end
		
		if false then
		end
	end
end

function SubstoryAlbumMain.updateMissionUI(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	arg_38_3 = arg_38_3 or {}
	
	local var_38_0 = {}
	
	if not arg_38_3.is_topbar then
		arg_38_0.vars.btn_mission_controls = {}
	end
	
	local var_38_1 = Account:getSubStoryAlbumMissionInfo(arg_38_2)
	
	for iter_38_0 = 1, 3 do
		if var_38_1["mission_id" .. tostring(iter_38_0)] and var_38_1["piece" .. tostring(iter_38_0)] then
			table.insert(var_38_0, {
				mission_id = var_38_1["mission_id" .. tostring(iter_38_0)],
				piece = var_38_1["piece" .. tostring(iter_38_0)]
			})
		end
	end
	
	local var_38_2 = arg_38_1:getChildByName("n_mission_info")
	
	arg_38_1:getChildByName("n_none"):setVisible(#var_38_0 == 0)
	
	for iter_38_1 = 1, 3 do
		local var_38_3 = var_38_0[iter_38_1]
		local var_38_4 = var_38_2:getChildByName("n_mission" .. tostring(iter_38_1))
		
		var_38_4:setVisible(var_38_3 ~= nil)
		
		if var_38_3 then
			local var_38_5, var_38_6 = DB("substory_album_mission", var_38_3.mission_id, {
				"mission_desc",
				"value"
			})
			local var_38_7 = totable(var_38_6)
			local var_38_8 = var_38_4:getChildByName("reward_item")
			local var_38_9 = var_38_4:getChildByName("n_reward_item_eff")
			
			if not arg_38_3.is_topbar then
				var_38_8:removeAllChildren()
				var_38_9:removeAllChildren()
				
				local var_38_10 = arg_38_1:getChildByName("btn_mission" .. tostring(iter_38_1))
				
				var_38_10.info = var_38_3
				var_38_10.idx = iter_38_1
				arg_38_0.vars.btn_mission_controls[var_38_3.mission_id] = var_38_10
			end
			
			local var_38_11 = var_38_4:getChildByName("progress_bg")
			local var_38_12 = Account:getSubStoryAlbumMissionInfoData("score", arg_38_2, var_38_3.mission_id)
			local var_38_13 = Account:getSubStoryAlbumMissionInfoData("state", arg_38_2, var_38_3.mission_id)
			local var_38_14 = totable(var_38_6).count
			
			if_set_percent(var_38_11, "progress_bar", var_38_12 / var_38_14)
			if_set(var_38_11, "txt", comma_value(math.min(var_38_12, var_38_14)) .. " / " .. comma_value(var_38_14))
			
			local var_38_15 = var_38_4:getChildByName("btn_renew")
			
			if var_38_15 and get_cocos_refid(var_38_15) then
				var_38_15.piece_num = var_38_3.piece
				
				var_38_15:setVisible(var_38_13 == SUBSTORY_ALBUM_STATE.ACTIVE)
			end
			
			local var_38_16 = var_38_4:getChildByName("t_mission_contents")
			
			if DEBUG.DEBUG_MAP_ID then
				var_38_16:setString(var_38_3.mission_id)
			else
				var_38_16:setString(T(var_38_5, {
					count = comma_value(var_38_7.count)
				}))
			end
			
			local var_38_17 = var_38_11:getChildByName("progress_bar")
			
			if var_38_13 == SUBSTORY_ALBUM_STATE.ACTIVE then
				var_38_16:setColor(cc.c3b(136, 136, 136))
				var_38_17:setColor(cc.c3b(146, 109, 62))
			elseif var_38_13 == SUBSTORY_ALBUM_STATE.CLEAR then
				var_38_16:setColor(cc.c3b(107, 193, 27))
				var_38_17:setColor(cc.c3b(107, 193, 27))
				
				if not arg_38_3.is_topbar then
					local var_38_18 = Account:getSubStoryAlbumPiece(arg_38_2, var_38_3.piece).piece_id
					local var_38_19, var_38_20, var_38_21, var_38_22 = DB("substory_album_reward", var_38_18, {
						"item_id",
						"item_count",
						"grade_rate",
						"set_rate"
					})
					
					UIUtil:getRewardIcon(var_38_20, var_38_19, {
						hero_multiply_scale = 1.12,
						artifact_multiply_scale = 0.82,
						pet_multiply_scale = 1.12,
						parent = var_38_8,
						grade_rate = var_38_21,
						set_drop = var_38_22
					})
				end
			end
		end
	end
	
	if not arg_38_3.is_topbar and SubstoryAlbum:isComplete(arg_38_0.vars.info.id) then
		local var_38_23 = var_38_2:getChildByName("n_none")
		
		if_set(var_38_23, "label", T("substory_album_list_msg2"))
	end
	
	if_set(var_38_2, "t_mission_title", T("substory_album_list_title", {
		cnt = #var_38_0
	}))
end

function SubstoryAlbumMain.showAllRewardList(arg_39_0, arg_39_1)
	local var_39_0 = Dialog:open("wnd/dungeon_story_piece_reward", arg_39_0)
	
	;(arg_39_1 or SceneManager:getRunningPopupScene()):addChild(var_39_0)
	
	local var_39_1 = var_39_0:getChildByName("listview")
	local var_39_2 = load_control("wnd/dungeon_story_piece_reward_item.csb")
	local var_39_3 = ItemListView_v2:bindControl(var_39_1)
	
	if var_39_1.STRETCH_INFO then
		local var_39_4 = var_39_1:getContentSize()
		
		resetControlPosAndSize(var_39_2, var_39_4.width, var_39_1.STRETCH_INFO.width_prev)
	end
	
	local var_39_5 = var_39_2:getChildByName("t_available")
	local var_39_6 = var_39_2:getChildByName("t_count")
	
	if var_39_5 and var_39_6 and var_39_5:getStringNumLines() >= 2 then
		var_39_6:setPositionY(var_39_6:getPositionY() - 12)
	end
	
	local var_39_7 = {
		onUpdate = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
			arg_39_0:updateRewardListItem(arg_40_1, arg_40_3, arg_40_2)
			
			return arg_40_3.item_id
		end
	}
	
	var_39_3:setRenderer(var_39_2, var_39_7)
	var_39_3:removeAllChildren()
	var_39_3:setDataSource(arg_39_0.vars.reward_datas)
	var_39_3:jumpToTop()
end

function SubstoryAlbumMain.initRewardData(arg_41_0)
	arg_41_0.vars.reward_datas = {}
	arg_41_0.vars.core_datas = {}
	
	local var_41_0 = {}
	
	for iter_41_0 = 1, var_0_0 do
		local var_41_1 = DBT("substory_album_reward", arg_41_0.vars.info.id .. "_" .. iter_41_0, {
			"id",
			"item_id",
			"item_count",
			"grade_rate",
			"set_rate",
			"sort",
			"show_core_sort"
		})
		
		if not var_41_1.id then
			break
		end
		
		if var_41_1.show_core_sort then
			table.insert(arg_41_0.vars.core_datas, var_41_1)
		end
		
		local var_41_2 = var_41_1.item_id .. "_" .. var_41_1.item_count
		
		var_41_0[var_41_2] = var_41_0[var_41_2] or {}
		var_41_0[var_41_2].data = var_41_0[var_41_2].data or var_41_1
		var_41_0[var_41_2].data.count = (var_41_0[var_41_2].data.count or 0) + 1
		var_41_0[var_41_2].data.original_sort = var_41_1.sort
	end
	
	for iter_41_1, iter_41_2 in pairs(var_41_0) do
		iter_41_2.data.id = iter_41_1
		
		table.insert(arg_41_0.vars.reward_datas, iter_41_2.data)
	end
	
	arg_41_0:updateSortRewardData()
	table.sort(arg_41_0.vars.core_datas, function(arg_42_0, arg_42_1)
		return (tonumber(arg_42_0.show_core_sort) or 999) < (tonumber(arg_42_1.show_core_sort) or 999)
	end)
end

function SubstoryAlbumMain.playEffect(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.vars.info.id
	local var_43_1 = var_0_0
	
	if SubstoryAlbum:isComplete(var_43_0) then
		local var_43_2 = arg_43_0.vars.wnd:getChildByName("n_screen_eff")
		
		EffectManager:Play({
			node_name = "@PIECE_COMPLTE_EFFECT",
			delay = 0,
			fn = "ui_puzzle_screen_eff.cfx",
			layer = var_43_2
		})
	elseif arg_43_1 then
		local var_43_3 = arg_43_0.vars.wnd:getChildByName("n_piece_" .. arg_43_1)
		local var_43_4 = var_43_3:getChildByName("btn_piece" .. arg_43_1)
		local var_43_5 = var_43_3:getPositionX() + var_43_4:getPositionX()
		local var_43_6 = var_43_3:getPositionY() + var_43_4:getPositionY()
		
		EffectManager:Play({
			node_name = "@PIECE_EFFECT",
			fn = "ui_puzzle_piece_eff.cfx",
			delay = 0,
			layer = arg_43_0.vars.wnd,
			x = var_43_5,
			y = var_43_6
		})
	end
end

function SubstoryAlbumMain.onEventBtnMission(arg_44_0, arg_44_1)
	if Account:getSubStoryAlbumMissionByPieceNum(arg_44_0.vars.info.id, arg_44_1).state == SUBSTORY_ALBUM_STATE.CLEAR then
		SubstoryAlbumMain:onEventBtnPiece(arg_44_1)
	else
		SubstoryAlbumMain:playEffectLink(arg_44_1)
	end
end

function SubstoryAlbumMain.playEffectLink(arg_45_0, arg_45_1)
	arg_45_1 = tostring(arg_45_1)
	
	local var_45_0 = Account:getSubStoryAlbumMissionByPieceNum(arg_45_0.vars.info.id, arg_45_1)
	local var_45_1 = 1
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.btn_mission_controls or {}) do
		if iter_45_0 == var_45_0.mission_id then
			var_45_1 = iter_45_1.idx
		end
	end
	
	local var_45_2 = arg_45_0.vars.wnd:getChildByName("n_piece_" .. arg_45_1)
	local var_45_3 = arg_45_0.vars.wnd:getChildByName("n_mission" .. var_45_1)
	local var_45_4 = var_45_2:getChildByName("btn_piece" .. arg_45_1)
	local var_45_5 = var_45_2:getPositionX() + var_45_4:getPositionX()
	local var_45_6 = var_45_2:getPositionY() + var_45_4:getPositionY()
	
	EffectManager:Play({
		node_name = "@PIECE_EFFECT_P",
		fn = "ui_puzzle_piece_fx.cfx",
		delay = 0,
		layer = arg_45_0.vars.wnd,
		x = var_45_5,
		y = var_45_6
	})
	
	local var_45_7 = var_45_3:getChildByName("n_eff")
	
	EffectManager:Play({
		node_name = "@PIECE_EFFECT_M",
		delay = 0,
		fn = "ui_puzzle_content_fx.cfx",
		layer = var_45_7
	})
end

function SubstoryAlbumMain.setCoreRewardUI(arg_46_0)
	for iter_46_0 = 1, 4 do
		local var_46_0 = arg_46_0.vars.wnd:getChildByName("reward_item" .. iter_46_0)
		local var_46_1 = arg_46_0.vars.core_datas[iter_46_0]
		
		if var_46_1 then
			UIUtil:getRewardIcon(nil, var_46_1.item_id, {
				hero_multiply_scale = 1.12,
				artifact_multiply_scale = 0.82,
				pet_multiply_scale = 1.12,
				parent = var_46_0,
				grade_rate = var_46_1.grade_rate,
				set_drop = var_46_1.set_rate
			})
		end
	end
end

function SubstoryAlbumMain.getCompleteRewardDatas(arg_47_0, arg_47_1)
	local var_47_0 = Account:getSubStoryAlbumPiecesBySubstoryID(arg_47_1) or {}
	local var_47_1 = {}
	
	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		if iter_47_1.state >= SubstoryAlbumPieceState.COMPLETE then
			local var_47_2 = DBT("substory_album_reward", iter_47_1.piece_id, {
				"id",
				"item_id",
				"item_count"
			})
			
			if var_47_2.id and var_47_2.item_id and var_47_2.item_count then
				local var_47_3 = var_47_2.item_id .. "_" .. var_47_2.item_count
				
				var_47_1[var_47_3] = var_47_1[var_47_3] or {}
				var_47_1[var_47_3].count = (var_47_1[var_47_3].count or 0) + 1
			end
		end
	end
	
	return var_47_1
end

function SubstoryAlbumMain.updateData(arg_48_0)
	arg_48_0.vars.current_reward_datas = arg_48_0:getCompleteRewardDatas(arg_48_0.vars.info.id)
	
	arg_48_0:updateUI()
	arg_48_0:updateMissionUI(arg_48_0.vars.wnd, arg_48_0.vars.info.id)
end

function SubstoryAlbumMain.updateSortRewardData(arg_49_0)
	for iter_49_0, iter_49_1 in pairs(arg_49_0.vars.reward_datas) do
		local var_49_0 = (arg_49_0.vars.current_reward_datas[iter_49_1.id] or {}).count or 0
		
		if var_49_0 >= iter_49_1.count then
			arg_49_0.vars.reward_datas[iter_49_0].sort = iter_49_1.original_sort + 10000
		elseif var_49_0 < 1 then
			arg_49_0.vars.reward_datas[iter_49_0].sort = iter_49_1.original_sort - 100
		else
			arg_49_0.vars.reward_datas[iter_49_0].sort = iter_49_1.original_sort
		end
	end
	
	table.sort(arg_49_0.vars.reward_datas, function(arg_50_0, arg_50_1)
		return (tonumber(arg_50_0.sort) or 999) < (tonumber(arg_50_1.sort) or 999)
	end)
end

function SubstoryAlbumMain.updateRewardListItem(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = arg_51_1:getChildByName("reward_item")
	local var_51_1 = arg_51_1:getChildByName("txt_name")
	local var_51_2 = arg_51_1:getChildByName("txt_type")
	
	UIUtil:getRewardIcon(arg_51_2.item_count, arg_51_2.item_id, {
		show_small_count = true,
		hero_multiply_scale = 1.12,
		artifact_multiply_scale = 0.75,
		show_name = true,
		pet_multiply_scale = 1.12,
		no_resize_name = true,
		right_hero_type = true,
		show_equip_type = true,
		right_hero_name = true,
		detail = true,
		parent = var_51_0,
		grade_rate = arg_51_2.grade_rate,
		set_drop = arg_51_2.set_rate,
		txt_type = var_51_2,
		txt_name = var_51_1
	})
	UIUserData:call(var_51_1, "MULTI_SCALE(2, 50)")
	UIUserData:call(var_51_2, "SINGLE_WSCALE(238)")
	
	local var_51_3 = (arg_51_0.vars.current_reward_datas[arg_51_2.id] or {}).count or 0
	
	if_set(arg_51_1, "t_count", var_51_3 .. "/" .. arg_51_2.count)
	if_set_visible(arg_51_1, "icon_check", var_51_3 >= arg_51_2.count)
	
	if var_51_3 >= arg_51_2.count then
		if_set_opacity(arg_51_1, "n_item", 76.5)
	end
end

function SubstoryAlbumMain.showIssuedMissionDlg(arg_52_0, arg_52_1)
	local var_52_0 = SceneManager:getRunningPopupScene()
	local var_52_1 = Dialog:open("wnd/dungeon_story_album_mission", arg_52_0)
	local var_52_2 = var_52_1:getChildByName("reward_item")
	local var_52_3 = Account:getSubStoryAlbumMissionInfo(arg_52_0.vars.info.id)
	local var_52_4
	
	for iter_52_0 = 1, 3 do
		if var_52_3["piece" .. tostring(iter_52_0)] == tonumber(arg_52_1) then
			var_52_4 = var_52_3["mission_id" .. tostring(iter_52_0)]
			
			break
		end
	end
	
	if not var_52_4 then
		Log.e("SubstoryAlbumMain", "no_mission_id")
		
		return 
	end
	
	local var_52_5, var_52_6 = DB("substory_album_mission", var_52_4, {
		"mission_desc",
		"value"
	})
	local var_52_7 = totable(var_52_6)
	
	if_set(var_52_1, "t_mission_contents", T(var_52_5, {
		count = comma_value(var_52_7.count)
	}))
	
	var_52_1:getChildByName("btn_renew").piece_num = arg_52_1
	
	local var_52_8 = (Account:getSubStoryAlbumPiece(arg_52_0.vars.info.id, arg_52_1) or {}).piece_id
	local var_52_9, var_52_10, var_52_11, var_52_12 = DB("substory_album_reward", var_52_8, {
		"item_id",
		"item_count",
		"grade_rate",
		"set_rate"
	})
	
	UIUtil:getRewardIcon(var_52_10, var_52_9, {
		hero_multiply_scale = 1.12,
		artifact_multiply_scale = 0.82,
		pet_multiply_scale = 1.12,
		parent = var_52_2,
		grade_rate = var_52_11,
		set_drop = var_52_12
	})
	var_52_0:addChild(var_52_1)
end

function SubstoryAlbumMain.getRefreshPrice(arg_53_0, arg_53_1)
	local var_53_0 = 0
	local var_53_1 = Account:getSubStoryAlbumPiece(arg_53_0.vars.info.id, arg_53_1)
	local var_53_2 = GAME_STATIC_VARIABLE.substory_album_reset_token
	
	if var_53_1.refresh_count >= GAME_STATIC_VARIABLE.substory_album_reset_free then
		local var_53_3 = GAME_STATIC_VARIABLE.substory_album_reset_free
		local var_53_4 = GAME_STATIC_VARIABLE.substory_album_reset_add_cost
		local var_53_5 = GAME_STATIC_VARIABLE.substory_album_reset_cost
		local var_53_6 = GAME_STATIC_VARIABLE.substory_album_reset_limit - 1
		
		var_53_0 = var_53_5 + (var_53_1.refresh_count - var_53_3) * var_53_5 * var_53_4
		var_53_0 = math.floor(var_53_0)
		max_price = var_53_5 + (var_53_6 - var_53_3) * var_53_5 * var_53_4
		var_53_0 = math.min(var_53_0, max_price)
	end
	
	return var_53_0
end

function SubstoryAlbumMain.queryRefresh(arg_54_0, arg_54_1)
	if not GlobalSubstoryManager:isActiveSchedule(arg_54_0.vars.info.id) then
		balloon_message_with_sound("over_schedule_substory_album")
		
		return 
	end
	
	local var_54_0 = arg_54_0:getRefreshPrice(arg_54_1)
	local var_54_1 = GAME_STATIC_VARIABLE.substory_album_reset_token
	
	if var_54_0 > Account:getCurrency(var_54_1) then
		UIUtil:checkCurrencyDialog(var_54_1)
		
		return 
	end
	
	query("refresh_substory_album_mission", {
		substory_id = arg_54_0.vars.info.id,
		piece_num = arg_54_1
	})
end

function SubstoryAlbumMain.updateRenewDlg(arg_55_0, arg_55_1)
	if not get_cocos_refid(arg_55_0.vars.renew_dlg) then
		return 
	end
	
	popup_dlg = arg_55_0.vars.renew_dlg
	
	local var_55_0 = Account:getSubStoryAlbumMissionInfo(arg_55_0.vars.info.id)
	local var_55_1 = GAME_STATIC_VARIABLE.substory_album_reset_free
	local var_55_2
	
	for iter_55_0 = 1, 3 do
		if var_55_0["piece" .. tostring(iter_55_0)] == tonumber(arg_55_1) then
			var_55_2 = var_55_0["mission_id" .. tostring(iter_55_0)]
			
			break
		end
	end
	
	if not var_55_2 then
		Log.e("SubstoryAlbumMain", "no_mission_id")
		
		return 
	end
	
	local var_55_3 = Account:getSubStoryAlbumPiece(arg_55_0.vars.info.id, arg_55_1)
	local var_55_4 = arg_55_0:getRefreshPrice(arg_55_1)
	local var_55_5 = GAME_STATIC_VARIABLE.substory_album_reset_token
	local var_55_6 = popup_dlg:getChildByName("n_token")
	
	UIUtil:getRewardIcon(nil, var_55_5, {
		no_bg = true,
		parent = var_55_6
	})
	
	if var_55_4 == 0 then
		if_set(popup_dlg, "price", T("shop_price_free"))
	else
		if_set(popup_dlg, "price", comma_value(var_55_4))
	end
	
	local var_55_7, var_55_8 = DB("substory_album_mission", var_55_2, {
		"mission_desc",
		"value"
	})
	local var_55_9 = totable(var_55_8)
	
	if_set(popup_dlg, "t_mission_contents", T(var_55_7, {
		count = comma_value(var_55_9.count)
	}))
	UIAction:Add(DELAY(500), arg_55_0.vars.wnd, "block")
	
	local var_55_10 = arg_55_0.vars.renew_dlg:getChildByName("n_free_tip")
	
	var_55_10:setVisible(var_55_1 > var_55_3.refresh_count)
	if_set(var_55_10, "t_count", T("substory_album_popup2_desc4", {
		curr = var_55_3.refresh_count,
		max = var_55_1
	}))
end

function SubstoryAlbumMain.showRefreshMission(arg_56_0, arg_56_1)
	if not GlobalSubstoryManager:isActiveSchedule(arg_56_0.vars.info.id) then
		balloon_message_with_sound("over_schedule_substory_album")
		
		return 
	end
	
	local var_56_0 = SceneManager:getRunningPopupScene()
	local var_56_1 = Dialog:open("wnd/dungeon_story_album_mission_renew", arg_56_0)
	
	arg_56_0.vars.renew_dlg = var_56_1
	var_56_1:getChildByName("btn_renew").piece_num = arg_56_1
	
	local var_56_2 = GAME_STATIC_VARIABLE.substory_album_reset_free
	
	if_set(var_56_1, "t_renew_info", T("substory_album_popup2_desc2", {
		free = var_56_2
	}))
	arg_56_0:updateRenewDlg(arg_56_1)
	var_56_0:addChild(var_56_1)
end

SubStoryAlbumQuickPopup = SubStoryAlbumQuickPopup or {}

function SubStoryAlbumQuickPopup.show(arg_57_0, arg_57_1)
	local var_57_0 = SceneManager:getRunningPopupScene()
	local var_57_1 = Dialog:open("wnd/quick_menu_album_info", arg_57_0)
	
	var_57_1:getChildByName("btn_move").substory_id = arg_57_1
	
	SubstoryAlbumMain:updateMissionUI(var_57_1, arg_57_1, {
		is_topbar = true
	})
	var_57_0:addChild(var_57_1)
end
