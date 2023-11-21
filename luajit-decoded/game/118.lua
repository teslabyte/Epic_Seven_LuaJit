SubstoryPiece = SubstoryPiece or {}

function SubstoryPiece.getCountOpenPiece(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Account:getSubStoryPiecesByBoardID(arg_1_1, arg_1_2)
	local var_1_1 = 0
	
	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		if iter_1_1.state >= SubstoryPieceState.OPEN then
			var_1_1 = var_1_1 + 1
		end
	end
	
	return var_1_1
end

function SubstoryPiece.isComplete(arg_2_0, arg_2_1, arg_2_2)
	return arg_2_2.piece_total_num <= SubstoryPiece:getCountOpenPiece(arg_2_1, arg_2_2.id)
end

function SubstoryPiece.getCompleteRewardDatas(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Account:getSubStoryPiecesByBoardID(arg_3_1, arg_3_2)
	local var_3_1 = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if iter_3_1.state >= SubstoryPieceState.COMPLETE then
			local var_3_2 = DBT("substory_piece_reward", iter_3_1.piece_id, {
				"id",
				"item_id",
				"item_count"
			})
			
			if var_3_2.id and var_3_2.item_id and var_3_2.item_count then
				local var_3_3 = var_3_2.item_id .. "_" .. var_3_2.item_count
				
				var_3_1[var_3_3] = var_3_1[var_3_3] or {}
				var_3_1[var_3_3].count = (var_3_1[var_3_3].count or 0) + 1
			end
		end
	end
	
	return var_3_1
end

function SubstoryPiece.checkEnterCondition(arg_4_0, arg_4_1)
	local var_4_0 = {}
	
	var_4_0.is_schedule_on = true
	var_4_0.is_unlock = true
	var_4_0.remain_time = nil
	var_4_0.is_time_over = nil
	
	if DEBUG.MAP_DEBUG then
		return var_4_0
	end
	
	if arg_4_1.schedule then
		var_4_0.remain_time, var_4_0.is_time_over = SubstoryManager:getRemainEnterTime(arg_4_1.schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
		
		if var_4_0.remain_time > 0 or var_4_0.is_time_over then
			var_4_0.is_schedule_on = false
		end
	end
	
	if arg_4_1.unlock_type and arg_4_1.unlock_value then
		if arg_4_1.unlock_type == "enter" and not Account:isMapCleared(arg_4_1.unlock_value) then
			var_4_0.is_unlock = false
		elseif arg_4_1.unlock_type == "achieve" and ((Account:getSubStoryAchievement(arg_4_1.unlock_value) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE) < SUBSTORY_ACHIEVE_STATE.CLEAR then
			var_4_0.is_unlock = false
		end
	end
	
	return var_4_0
end

function SubstoryPiece.loadDBData(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {}
	
	for iter_5_0 = 1, arg_5_2 do
		local var_5_1 = DBT("substory_piece", arg_5_1 .. "_" .. iter_5_0, {
			"id",
			"piece_total_num",
			"illust",
			"silhouette",
			"schedule",
			"unlock_type",
			"unlock_value",
			"unlock_msg",
			"remove_item",
			"remove_item_count",
			"complete_reward_id",
			"complete_reward_count",
			"story",
			"sort"
		})
		
		if not var_5_1.id then
			break
		end
		
		table.insert(var_5_0, var_5_1)
	end
	
	return var_5_0
end

function SubstoryPiece.startTutorial(arg_6_0)
	if not TutorialGuide:isClearedTutorial("vfm0ba_piece") then
		local var_6_0 = false
		local var_6_1 = SubstoryManager:getInfoID()
		local var_6_2 = SubstoryManager:getContents2CommonDB({
			"piece_max"
		}).piece_max or 0
		local var_6_3 = arg_6_0:loadDBData(var_6_1, var_6_2)
		
		for iter_6_0, iter_6_1 in pairs(var_6_3) do
			local var_6_4 = SubstoryPiece:checkEnterCondition(iter_6_1)
			
			if var_6_4.is_unlock and var_6_4.is_schedule_on then
				var_6_0 = true
				
				break
			end
		end
		
		if var_6_0 and TutorialGuide:startGuide("vfm0ba_piece") then
			return true
		end
	end
end

SubstoryPieceBoardList = SubstoryPieceBoardList or {}

copy_functions(ScrollView, SubstoryPieceBoardList)

SubstoryPieceState = {
	OPEN = 1,
	COMPLETE = 2,
	LOCK = 0
}

function MsgHandler.substory_issue_piece_board(arg_7_0)
	if arg_7_0.substory_id and arg_7_0.board_id and arg_7_0.substory_piece_infos then
		Account:setSubStoryPieceBoardInfos(arg_7_0.substory_id, arg_7_0.substory_piece_infos)
		
		local var_7_0 = SubstoryPieceBoardList:getBoardData(arg_7_0.board_id)
		
		SubstoryPieceBoard:show(nil, var_7_0)
	else
		Log.e("substory_issue_piece_board", "no_rtn_data")
	end
end

function MsgHandler.unlock_piece(arg_8_0)
	if arg_8_0.rewards then
		Account:addReward(arg_8_0.rewards, {
			effect = true,
			single = true,
			no_randombox_eff = true,
			parent = SubstoryPieceBoard:getWnd()
		})
	end
	
	if arg_8_0.no_effect_rewards then
		Account:addReward(arg_8_0.no_effect_rewards)
	end
	
	if arg_8_0.piece and arg_8_0.piece_info then
		Account:setSubStoryPieceInfo(arg_8_0.piece_info.substory_id, arg_8_0.piece_info.board_id, arg_8_0.piece, arg_8_0.piece_info)
	end
	
	local var_8_0 = 167
	local var_8_1 = SubstoryPieceBoard:getBoardInfo()
	
	if SubstoryPiece:isComplete(arg_8_0.piece_info.substory_id, var_8_1) then
		var_8_0 = 334
	end
	
	UIAction:Add(SEQ(DELAY(var_8_0), CALL(function()
		SubstoryPieceBoard:updateData()
		SubstoryPieceBoard:updateSortRewardData()
	end)), SubstoryPieceBoard:getWnd(), "block")
	SubstoryPieceBoard:playEffect(arg_8_0.piece)
end

function HANDLER.dungeon_story_piece_list(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_close" then
		SubstoryPieceBoardList:close()
	end
end

function HANDLER.dungeon_story_piece(arg_11_0, arg_11_1)
	if arg_11_1 == "btn_close" then
		Dialog:close("dungeon_story_piece")
	elseif arg_11_1 == "btn_reward_list" then
		SubstoryPieceBoard:showAllRewardList()
	elseif string.starts(arg_11_1, "btn_piece") then
		local var_11_0 = string.sub(arg_11_1, 10)
		
		SubstoryPieceBoard:PieceOpenQuery(var_11_0)
	elseif arg_11_1 == "btn_story" then
		SubstoryPieceBoard:playStory()
	end
end

function HANDLER.dungeon_story_piece_reward(arg_12_0, arg_12_1)
	if arg_12_1 == "btn_close" then
		Dialog:close("dungeon_story_piece_reward")
	end
end

function HANDLER.dungeon_story_piece_list_item(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_select" then
		local var_13_0 = SubstoryPiece:checkEnterCondition(arg_13_0.board_info)
		local var_13_1 = var_13_0.is_schedule_on
		local var_13_2 = var_13_0.is_unlock
		
		if not var_13_0.is_schedule_on and ((var_13_0.remain_time or 0) > 0 or var_13_0.is_time_over) then
			balloon_message_with_sound("err_msg_tournament_time", {
				time = sec_to_string(var_13_0.remain_time)
			})
			
			return 
		end
		
		if not var_13_2 then
			balloon_message_with_sound(arg_13_0.board_info.unlock_msg)
			
			return 
		end
		
		local var_13_3 = SubstoryManager:getInfoID()
		
		if Account:isRequestSubStoryPieceBoard(var_13_3, arg_13_0.board_info.id) then
			query("substory_issue_piece_board", {
				substory_id = var_13_3,
				board_id = arg_13_0.board_info.id
			})
		else
			SubstoryPieceBoard:show(nil, arg_13_0.board_info)
		end
	end
end

function SubstoryPieceBoardList.show(arg_14_0, arg_14_1)
	arg_14_0.vars = {}
	arg_14_0.vars.wnd = Dialog:open("wnd/dungeon_story_piece_list", arg_14_0)
	arg_14_0.vars.board_key = SubstoryManager:getInfoID()
	
	local var_14_0 = SubstoryManager:getContents2CommonDB({
		"piece_max"
	})
	
	arg_14_0.vars.board_max = var_14_0.piece_max
	
	if not arg_14_0.vars.board_key then
		return 
	end
	
	if not arg_14_0.vars.board_max then
		return 
	end
	
	;(arg_14_1 or SceneManager:getRunningPopupScene()):addChild(arg_14_0.vars.wnd)
	UIUtil:slideOpen(arg_14_0.vars.wnd, arg_14_0.vars.wnd:getChildByName("cm_tooltipbox"), true)
	
	arg_14_0.vars.scrollview = arg_14_0.vars.wnd:getChildByName("scrollview")
	
	arg_14_0:initScrollView(arg_14_0.vars.scrollview, 236, 150)
	
	arg_14_0.vars.list_data = SubstoryPiece:loadDBData(arg_14_0.vars.board_key, arg_14_0.vars.board_max)
	arg_14_0.vars.list_data_count = table.count(arg_14_0.vars.list_data)
	
	arg_14_0:createScrollView()
	TutorialGuide:procGuide()
end

function SubstoryPieceBoardList.getFirstScrollItem(arg_15_0)
	local var_15_0 = ((arg_15_0.ScrollViewItems or {})[1] or {}).control
	
	if not var_15_0 then
		return 
	end
	
	return var_15_0
end

function SubstoryPieceBoardList.close(arg_16_0)
	BackButtonManager:pop()
	UIUtil:slideOpen(arg_16_0.vars.wnd, arg_16_0.vars.wnd:getChildByName("cm_tooltipbox"), false)
	TutorialGuide:onEnterSubstory()
end

function SubstoryPieceBoardList.createScrollView(arg_17_0)
	local var_17_0 = SubstoryManager:getInfoID()
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.list_data) do
		local var_17_1 = SubstoryPiece:checkEnterCondition(iter_17_1)
		
		if var_17_1.is_unlock == false or var_17_1.is_schedule_on == false then
			iter_17_1.score_sort = iter_17_1.sort + 100000
		elseif SubstoryPiece:isComplete(var_17_0, iter_17_1) then
			iter_17_1.score_sort = iter_17_1.sort + 100
		else
			iter_17_1.score_sort = iter_17_1.sort
		end
	end
	
	table.sort(arg_17_0.vars.list_data, function(arg_18_0, arg_18_1)
		return (tonumber(arg_18_0.score_sort) or 999) < (tonumber(arg_18_1.score_sort) or 999)
	end)
	arg_17_0:createScrollViewItems(arg_17_0.vars.list_data)
end

function SubstoryPieceBoardList.getBoardData(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.list_data) do
		if iter_19_1.id == arg_19_1 then
			return iter_19_1
		end
	end
end

function SubstoryPieceBoardList.refresh(arg_20_0)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.ScrollViewItems or {}) do
		arg_20_0:updateItem(iter_20_1.control, iter_20_1.item)
	end
end

function SubstoryPieceBoardList.getScrollViewItem(arg_21_0, arg_21_1)
	local var_21_0 = load_dlg("dungeon_story_piece_list_item", true, "wnd")
	local var_21_1 = SubstoryManager:getInfoID()
	local var_21_2 = var_21_0:getChildByName("btn_select")
	local var_21_3 = SubstoryPiece:checkEnterCondition(arg_21_1)
	local var_21_4 = var_21_3.is_schedule_on
	local var_21_5 = var_21_3.is_unlock
	
	var_21_2.board_info = arg_21_1
	
	if_set_visible(var_21_0, "n_locked", not var_21_4 or not var_21_5)
	
	local var_21_6 = var_21_0:getChildByName("n_progress")
	
	if var_21_4 and var_21_5 then
		local var_21_7 = WidgetUtils:createCircleProgress("img/cm_hero_circool1.png")
		
		var_21_7:setCascadeOpacityEnabled(true)
		
		local var_21_8 = var_21_0:getChildByName("progress_bar")
		
		var_21_8:setVisible(false)
		var_21_7:setScale(var_21_8:getScale())
		var_21_7:setPositionX(var_21_8:getPositionX())
		var_21_7:setPositionY(var_21_8:getPositionY())
		var_21_7:setOpacity(var_21_8:getOpacity())
		var_21_7:setColor(var_21_8:getColor())
		var_21_7:setReverseDirection(false)
		var_21_7:setName("_progress")
		var_21_6:addChild(var_21_7)
	else
		var_21_0:getChildByName("progress_bar"):setVisible(false)
	end
	
	arg_21_0:updateItem(var_21_0, arg_21_1)
	
	return var_21_0
end

function SubstoryPieceBoardList.updateItem(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1:getChildByName("n_illust")
	local var_22_1 = SubstoryManager:getInfoID()
	local var_22_2 = SubstoryPiece:checkEnterCondition(arg_22_2)
	local var_22_3 = var_22_2.is_schedule_on
	local var_22_4 = var_22_2.is_unlock
	local var_22_5 = arg_22_2.piece_total_num
	local var_22_6 = SubstoryPiece:getCountOpenPiece(var_22_1, arg_22_2.id)
	local var_22_7 = var_22_5 <= var_22_6
	local var_22_8 = var_22_6 / var_22_5 * 100
	local var_22_9 = math.floor(var_22_8)
	local var_22_10 = arg_22_1:getChildByName("n_progress")
	local var_22_11 = var_22_10:getChildByName("_progress")
	
	if var_22_11 then
		var_22_11:setPercentage(var_22_9)
	end
	
	if var_22_3 and var_22_4 then
		if_set(arg_22_1, "t_progress", T("piece_progress", {
			progress = var_22_9
		}))
		
		local var_22_12 = var_22_10:getChildByName("n_item")
		
		if_set_visible(var_22_12, nil, true)
		UIUtil:getRewardIcon(nil, arg_22_2.remove_item, {
			no_popup = true,
			no_bg = true,
			parent = var_22_12
		})
	else
		if_set_visible(var_22_10, "n_item", false)
		if_set_color(arg_22_1, "n_illust", cc.c3b(136, 136, 136))
	end
	
	if var_22_3 and var_22_4 and var_22_7 then
		if_set_sprite(arg_22_1, "img", "story/bg/" .. arg_22_2.illust .. ".webp")
		if_set(arg_22_1, "t_complete", T("piece_progress", {
			progress = var_22_9
		}))
	end
	
	if_set_visible(var_22_0, "img", var_22_3 and var_22_4 and var_22_7)
	if_set_visible(arg_22_1, "n_complete", var_22_3 and var_22_4 and var_22_7)
	if_set_visible(arg_22_1, "n_progress", var_22_3 and var_22_4 and not var_22_7)
end

SubstoryPieceBoard = SubstoryPieceBoard or {}

function SubstoryPieceBoard.show(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.vars = {}
	arg_23_0.vars.wnd = Dialog:open("wnd/dungeon_story_piece", arg_23_0)
	arg_23_0.vars.board_info = arg_23_2
	
	;(arg_23_1 or SceneManager:getRunningPopupScene()):addChild(arg_23_0.vars.wnd)
	
	local function var_23_0()
		SubstoryPieceBoard:close()
	end
	
	local var_23_1 = SubstoryManager:getInfo()
	
	TopBarNew:createFromPopup(T("piece_btn_enter"), arg_23_0.vars.wnd, var_23_0, nil, nil, "SubstoryPieceBoard")
	
	local var_23_2 = {}
	
	for iter_23_0 = 1, 3 do
		local var_23_3 = var_23_1["token_id" .. iter_23_0]
		
		if var_23_3 then
			table.insert(var_23_2, var_23_3)
		end
	end
	
	TopBarNew:setCurrencies(var_23_2)
	arg_23_0:updateData()
	arg_23_0:initRewardData()
	arg_23_0:setCoreRewardUI()
	if_set_visible(arg_23_0.vars.wnd, "btn_story", arg_23_0.vars.board_info.story ~= nil)
	TutorialGuide:procGuide()
end

function SubstoryPieceBoard.updateData(arg_25_0)
	local var_25_0 = SubstoryManager:getInfoID()
	local var_25_1 = arg_25_0.vars.board_info
	
	arg_25_0.vars.current_reward_datas = SubstoryPiece:getCompleteRewardDatas(var_25_0, var_25_1.id)
	
	arg_25_0:updateUI()
end

function SubstoryPieceBoard.updateUI(arg_26_0)
	local var_26_0 = arg_26_0.vars.board_info
	local var_26_1 = SubstoryManager:getInfoID()
	local var_26_2 = var_26_0.piece_total_num
	local var_26_3 = SubstoryPiece:getCountOpenPiece(var_26_1, var_26_0.id)
	local var_26_4 = arg_26_0.vars.wnd:getChildByName("progress_bg")
	local var_26_5 = var_26_2 <= var_26_3
	local var_26_6 = var_26_3 / var_26_2 * 100
	local var_26_7 = math.floor(var_26_6)
	
	if_set(arg_26_0.vars.wnd, "t_percent", var_26_7 .. "%")
	if_set(var_26_4, "txt", var_26_3 .. " / " .. var_26_2)
	
	if var_26_5 then
		if_set_sprite(arg_26_0.vars.wnd, "img", "story/bg/" .. var_26_0.illust .. ".webp")
		if_set_color(var_26_4, "progress_bar", cc.c3b(107, 193, 27))
	else
		if_set_sprite(arg_26_0.vars.wnd, "img_silhouette", UIUtil:getIllustPath("story/bg/", var_26_0.silhouette))
	end
	
	if_set_percent(var_26_4, "progress_bar", var_26_3 / var_26_2)
	if_set_visible(arg_26_0.vars.wnd, "img", var_26_5)
	if_set_visible(arg_26_0.vars.wnd, "img_silhouette", not var_26_5)
	
	local var_26_8 = arg_26_0.vars.wnd:getChildByName("n_piece")
	
	for iter_26_0 = 1, 24 do
		local var_26_9 = Account:getStateSubStoryPiece(var_26_1, var_26_0.id, tostring(iter_26_0))
		local var_26_10 = var_26_8:getChildByName("n_piece_" .. iter_26_0)
		
		if var_26_9 == SubstoryPieceState.LOCK then
			var_26_10:setVisible(true)
		else
			var_26_10:setVisible(false)
		end
	end
	
	if_set_opacity(arg_26_0.vars.wnd, "btn_story", var_26_5 and 255 or 76.5)
end

function SubstoryPieceBoard.playStoryEffect(arg_27_0)
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("btn_story")
	
	arg_27_0.vars.story_eff = EffectManager:Play({
		node_name = "@STORY_EFFECT",
		fn = "ui_puzzle_story_bt_eff.cfx",
		layer = var_27_0,
		x = var_27_0:getContentSize().width / 2,
		y = var_27_0:getContentSize().height / 2
	})
end

function SubstoryPieceBoard.removeStoryEffect(arg_28_0)
	if arg_28_0.vars.story_eff and get_cocos_refid(arg_28_0.vars.story_eff) and arg_28_0.vars.story_eff.sd and get_cocos_refid(arg_28_0.vars.story_eff.sd) then
		arg_28_0.vars.story_eff.sd:stop()
	end
end

function SubstoryPieceBoard.close(arg_29_0)
	SubstoryPieceBoardList:createScrollView()
	TopBarNew:pop()
	BackButtonManager:pop()
	BackButtonManager:pop()
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_29_0.vars.wnd, "block")
	SubstoryPieceBoard:removeStoryEffect()
end

function SubstoryPieceBoard.getBoardInfo(arg_30_0)
	return arg_30_0.vars.board_info
end

function SubstoryPieceBoard.updateSortRewardData(arg_31_0)
	for iter_31_0, iter_31_1 in pairs(arg_31_0.vars.reward_datas) do
		local var_31_0 = (arg_31_0.vars.current_reward_datas[iter_31_1.id] or {}).count or 0
		
		if var_31_0 >= iter_31_1.count then
			arg_31_0.vars.reward_datas[iter_31_0].sort = iter_31_1.original_sort + 10000
		elseif var_31_0 < 1 then
			arg_31_0.vars.reward_datas[iter_31_0].sort = iter_31_1.original_sort - 100
		else
			arg_31_0.vars.reward_datas[iter_31_0].sort = iter_31_1.original_sort
		end
	end
	
	table.sort(arg_31_0.vars.reward_datas, function(arg_32_0, arg_32_1)
		return (tonumber(arg_32_0.sort) or 999) < (tonumber(arg_32_1.sort) or 999)
	end)
end

function SubstoryPieceBoard.initRewardData(arg_33_0)
	arg_33_0.vars.reward_datas = {}
	arg_33_0.vars.core_datas = {}
	
	local var_33_0 = {}
	local var_33_1 = arg_33_0.vars.board_info.piece_total_num
	
	for iter_33_0 = 1, var_33_1 do
		local var_33_2 = DBT("substory_piece_reward", arg_33_0.vars.board_info.id .. "_" .. iter_33_0, {
			"id",
			"group_id",
			"item_id",
			"item_count",
			"grade_rate",
			"set_rate",
			"sort",
			"show_core_sort"
		})
		
		if not var_33_2.id then
			break
		end
		
		if var_33_2.show_core_sort then
			table.insert(arg_33_0.vars.core_datas, var_33_2)
		end
		
		local var_33_3 = var_33_2.item_id .. "_" .. var_33_2.item_count
		
		var_33_0[var_33_3] = var_33_0[var_33_3] or {}
		var_33_0[var_33_3].data = var_33_0[var_33_3].data or var_33_2
		var_33_0[var_33_3].data.count = (var_33_0[var_33_3].data.count or 0) + 1
		var_33_0[var_33_3].data.original_sort = var_33_2.sort
	end
	
	for iter_33_1, iter_33_2 in pairs(var_33_0) do
		iter_33_2.data.id = iter_33_1
		
		table.insert(arg_33_0.vars.reward_datas, iter_33_2.data)
	end
	
	arg_33_0:updateSortRewardData()
	table.sort(arg_33_0.vars.core_datas, function(arg_34_0, arg_34_1)
		return (tonumber(arg_34_0.show_core_sort) or 999) < (tonumber(arg_34_1.show_core_sort) or 999)
	end)
end

function SubstoryPieceBoard.setCoreRewardUI(arg_35_0)
	for iter_35_0 = 1, 4 do
		local var_35_0 = arg_35_0.vars.wnd:getChildByName("reward_item" .. iter_35_0)
		local var_35_1 = arg_35_0.vars.core_datas[iter_35_0]
		
		if var_35_1 then
			UIUtil:getRewardIcon(nil, var_35_1.item_id, {
				hero_multiply_scale = 1.12,
				artifact_multiply_scale = 0.82,
				pet_multiply_scale = 1.12,
				parent = var_35_0,
				grade_rate = var_35_1.grade_rate,
				set_drop = var_35_1.set_rate
			})
		end
	end
end

function SubstoryPieceBoard.showAllRewardList(arg_36_0, arg_36_1)
	local var_36_0 = Dialog:open("wnd/dungeon_story_piece_reward", arg_36_0)
	
	;(arg_36_1 or SceneManager:getRunningPopupScene()):addChild(var_36_0)
	
	local var_36_1 = var_36_0:getChildByName("listview")
	local var_36_2 = load_control("wnd/dungeon_story_piece_reward_item.csb")
	local var_36_3 = ItemListView_v2:bindControl(var_36_1)
	
	if var_36_1.STRETCH_INFO then
		local var_36_4 = var_36_1:getContentSize()
		
		resetControlPosAndSize(var_36_2, var_36_4.width, var_36_1.STRETCH_INFO.width_prev)
	end
	
	local var_36_5 = var_36_2:getChildByName("t_available")
	local var_36_6 = var_36_2:getChildByName("t_count")
	
	if var_36_5 and var_36_6 and var_36_5:getStringNumLines() >= 2 then
		var_36_6:setPositionY(var_36_6:getPositionY() - 12)
	end
	
	local var_36_7 = {
		onUpdate = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
			arg_36_0:updateRewardListItem(arg_37_1, arg_37_3, arg_37_2)
			
			return arg_37_3.item_id
		end
	}
	
	var_36_3:setRenderer(var_36_2, var_36_7)
	var_36_3:removeAllChildren()
	var_36_3:setDataSource(arg_36_0.vars.reward_datas)
	var_36_3:jumpToTop()
end

function SubstoryPieceBoard.updateRewardListItem(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_1:getChildByName("reward_item")
	local var_38_1 = arg_38_1:getChildByName("txt_name")
	local var_38_2 = arg_38_1:getChildByName("txt_type")
	
	UIUtil:getRewardIcon(arg_38_2.item_count, arg_38_2.item_id, {
		show_name = true,
		hero_multiply_scale = 1.12,
		artifact_multiply_scale = 0.75,
		show_small_count = true,
		pet_multiply_scale = 1.12,
		no_resize_name = true,
		right_hero_type = true,
		show_equip_type = true,
		right_hero_name = true,
		detail = true,
		parent = var_38_0,
		grade_rate = arg_38_2.grade_rate,
		set_drop = arg_38_2.set_rate,
		txt_type = var_38_2,
		txt_name = var_38_1
	})
	UIUserData:call(var_38_2, "SINGLE_WSCALE(238)")
	UIUserData:call(var_38_1, "MULTI_SCALE(2, 50)")
	
	local var_38_3 = (arg_38_0.vars.current_reward_datas[arg_38_2.id] or {}).count or 0
	
	if_set(arg_38_1, "t_count", var_38_3 .. "/" .. arg_38_2.count)
	if_set_visible(arg_38_1, "icon_check", var_38_3 >= arg_38_2.count)
	
	if var_38_3 >= arg_38_2.count then
		if_set_opacity(arg_38_1, "n_item", 76.5)
	end
end

function SubstoryPieceBoard.PieceOpenQuery(arg_39_0, arg_39_1)
	local var_39_0 = SubstoryManager:getInfoID()
	local var_39_1 = arg_39_0.vars.board_info.id
	local var_39_2 = arg_39_0.vars.board_info.remove_item
	local var_39_3 = arg_39_0.vars.board_info.remove_item_count
	
	local function var_39_4()
		if Account:getItemCount(var_39_2) < var_39_3 then
			balloon_message_with_sound("need_token")
			
			return 
		end
		
		local var_40_0 = arg_39_0.vars.board_info.piece_total_num
		local var_40_1 = SubstoryPiece:getCountOpenPiece(var_39_0, var_39_1) >= var_40_0 - 1
		
		query("unlock_piece", {
			substory_id = var_39_0,
			board_id = var_39_1,
			piece = arg_39_1,
			is_complete = var_40_1 or nil
		})
	end
	
	Dialog:msgBox(T("piece_unlock_desc"), {
		title = T("piece_unlock_title"),
		handler = var_39_4,
		material = var_39_2,
		cost = var_39_3
	})
end

function SubstoryPieceBoard.getWnd(arg_41_0)
	return arg_41_0.vars.wnd
end

function SubstoryPieceBoard.playEffect(arg_42_0, arg_42_1)
	local var_42_0 = SubstoryManager:getInfoID()
	
	if arg_42_0.vars.board_info.piece_total_num <= SubstoryPiece:getCountOpenPiece(var_42_0, arg_42_0.vars.board_info.id) then
		local var_42_1 = arg_42_0.vars.wnd:getChildByName("n_screen_eff")
		
		EffectManager:Play({
			node_name = "@PIECE_COMPLTE_EFFECT",
			delay = 0,
			fn = "ui_puzzle_screen_eff.cfx",
			layer = var_42_1
		})
		
		local var_42_2 = 1400
		
		UIAction:Add(SEQ(DELAY(var_42_2), CALL(function()
			SubstoryPieceBoard:playStoryEffect()
		end)), SubstoryPieceBoard:getWnd(), "block")
	elseif arg_42_1 then
		local var_42_3 = arg_42_0.vars.wnd:getChildByName("n_piece_" .. arg_42_1)
		local var_42_4 = var_42_3:getChildByName("btn_piece" .. arg_42_1)
		local var_42_5 = var_42_3:getPositionX() + var_42_4:getPositionX()
		local var_42_6 = var_42_3:getPositionY() + var_42_4:getPositionY()
		
		EffectManager:Play({
			node_name = "@PIECE_EFFECT",
			fn = "ui_puzzle_piece_eff.cfx",
			delay = 0,
			layer = arg_42_0.vars.wnd,
			x = var_42_5,
			y = var_42_6
		})
	end
end

function SubstoryPieceBoard.playStory(arg_44_0)
	local var_44_0 = SubstoryManager:getInfoID()
	local var_44_1 = SubstoryPiece:getCountOpenPiece(var_44_0, arg_44_0.vars.board_info.id)
	
	if var_44_1 < arg_44_0.vars.board_info.piece_total_num then
		balloon_message_with_sound("piece_story_lock")
		
		return 
	end
	
	local var_44_2 = arg_44_0.vars.board_info.story
	local var_44_3 = totable(var_44_2)[tostring(var_44_1)]
	
	start_new_story(nil, var_44_3, {
		force = true
	})
end
