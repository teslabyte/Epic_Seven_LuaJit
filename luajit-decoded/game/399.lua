SubStoryControlBoard = SubStoryControlBoard or {}
SubStoryControlBoardUtil = SubStoryControlBoardUtil or {}
ControlBoardScriptManager = ControlBoardScriptManager or {}

copy_functions(ScrollView, SubStoryControlBoard)
copy_functions(ScrollView, ControlBoardScriptManager)

CB_REWARD_STATE = {}
CB_REWARD_STATE.LOCKED = 1
CB_REWARD_STATE.CANRECIVE = 2
CB_REWARD_STATE.REWARDED = 3

function MsgHandler.get_substory_control_board_reward(arg_1_0)
	if arg_1_0 then
		if arg_1_0.rewards then
			local var_1_0 = {}
			
			Account:addReward(arg_1_0.rewards, {
				play_reward_data = var_1_0
			})
		end
		
		if arg_1_0.control_board_data then
			Account:setSubStoryControlBoard(arg_1_0.control_board_data)
		end
		
		SubStoryControlBoard:res_reward(arg_1_0)
	end
end

function MsgHandler.test_reset_all_control_board_reward_data(arg_2_0)
end

function HANDLER.dungeon_story_aespa_reward(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_reward" then
		SubStoryControlBoard:req_reward(arg_3_0.state)
		
		return 
	end
end

function HANDLER.dungeon_story_aespa(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_choose" then
		SubStoryControlBoard:onSelect(arg_4_0.idx)
	elseif arg_4_1 == "btn_receive" then
		SubStoryControlBoard:req_reward()
	elseif arg_4_1 == "btn_point" then
		SubStoryControlBoardInfo:show()
	elseif arg_4_1 == "btn_info_close" then
		SubStoryControlBoardInfo:close()
	elseif arg_4_1 == "btn_go" and arg_4_0.move_path then
		SubStoryControlBoard:moveToPath(arg_4_0.move_path)
	end
end

local var_0_0 = {
	"win",
	"ning",
	"gi",
	"ka"
}
local var_0_1 = {
	"#ff7800",
	"#00adfe",
	"#d800ca",
	"#00c574"
}
local var_0_2 = {
	"#ffd83e",
	"#75faff",
	"#f38bff",
	"#89ff9f"
}
local var_0_3 = "board_score"

function SubStoryControlBoard.getContentsDB(arg_5_0)
	local var_5_0 = {
		"enter_btn_icon",
		"enter_btn_text",
		"background"
	}
	local var_5_1 = {}
	local var_5_2 = SubstoryManager:findContentsTypeColumn("content_travel")
	
	if var_5_2 then
		var_5_1 = SubstoryManager:getContentsDB(var_5_2, var_5_0)
	end
	
	return var_5_1
end

function SubStoryControlBoard.moveToPath(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) or not arg_6_1 then
		return 
	end
	
	local var_6_0 = SubstoryManager:getInfo()
	
	if not var_6_0 or not SubstoryManager:isActiveSchedule(var_6_0.id) then
		balloon_message_with_sound("end_sub_story_event")
		
		return 
	end
	
	SubStoryControlBoard:close()
	SubStoryControlBoardUtil:moveToPath(arg_6_1)
end

function SubStoryControlBoard.show(arg_7_0, arg_7_1)
	if arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	local var_7_0 = SubstoryManager:getInfo()
	
	if not var_7_0 then
		return 
	end
	
	local var_7_1 = (arg_7_1 or {}).parent_layer or SceneManager:getRunningNativeScene()
	
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg("dungeon_story_aespa", true, "wnd")
	
	var_7_1:addChild(arg_7_0.vars.wnd)
	TopBarNew:createFromPopup(T("pass_vae2aa_btn"), arg_7_0.vars.wnd, function()
		arg_7_0:close()
	end)
	
	local var_7_2 = {
		"crystal",
		"gold",
		"stamina"
	}
	
	TopBarNew:setCurrencies(var_7_2)
	
	arg_7_0.vars.id = var_7_0.id
	arg_7_0.vars.progress_sounds = {}
	
	ControlBoardScriptManager:init(arg_7_0.vars.wnd:getChildByName("n_log_scrollview"))
	arg_7_0:initData()
	arg_7_0:initUI()
	
	if not TutorialGuide:isPlayingTutorial() and Account:isMapCleared("vae2ab001") and TutorialGuide:isClearedTutorial("tuto_board_a") and not TutorialGuide:isClearedTutorial("tuto_board_b") and SubStoryControlBoardUtil:canEnterableContentsByIdx(arg_7_0.vars.id, 2) then
		TutorialGuide:startGuide("tuto_board_b")
		
		arg_7_0.vars.select_idx = nil
		
		arg_7_0:onSelect(2, true)
		arg_7_0.scrollview:scrollToTop(0.01, false)
	else
		local var_7_3 = arg_7_0.vars.select_idx or 1
		
		arg_7_0.vars.select_idx = nil
		
		arg_7_0:onSelect(var_7_3, true)
	end
	
	TutorialGuide:procGuide("tuto_board_a")
end

function SubStoryControlBoard.initData(arg_9_0)
	if not Account:getSubStoryControlBoard(arg_9_0.vars.id) then
		return 
	end
	
	arg_9_0.vars.data = {}
	arg_9_0.vars.select_idx = nil
	
	local var_9_0 = 1
	
	for iter_9_0 = 1, 9999 do
		local var_9_1 = arg_9_0.vars.id .. "_" .. iter_9_0
		local var_9_2 = DBT("substory_board", var_9_1, {
			"id",
			"name",
			"portrait",
			"board_talk_id",
			"btn_move",
			"unlock_condition",
			"point_item",
			"point_max",
			"point_reward_id"
		})
		
		if not var_9_2 or not var_9_2.id then
			break
		end
		
		local var_9_3 = SubStoryControlBoardUtil:_getRewardedPointByIdx(arg_9_0.vars.id, iter_9_0)
		local var_9_4 = Account:getItemCount(var_9_2.point_item)
		local var_9_5 = {}
		local var_9_6
		local var_9_7
		
		for iter_9_1 = 1, 99999 do
			local var_9_8 = var_9_2.point_reward_id .. "_" .. iter_9_1
			local var_9_9 = DBT("substory_board_reward", var_9_8, {
				"id",
				"point",
				"item_id",
				"item_count",
				"grade_rate",
				"set_rate"
			})
			
			if not var_9_9 or not var_9_9.id then
				break
			end
			
			if var_9_3 >= var_9_9.point then
				var_9_9.state = CB_REWARD_STATE.REWARDED
				var_9_7 = iter_9_1
			elseif var_9_4 >= var_9_9.point then
				var_9_9.state = CB_REWARD_STATE.CANRECIVE
				var_9_6 = iter_9_1
			else
				var_9_9.state = CB_REWARD_STATE.LOCKED
			end
			
			table.insert(var_9_5, var_9_9)
		end
		
		var_9_2.reward_data = var_9_5
		var_9_2.rewardable_idx = var_9_6
		var_9_2.last_rewarded_idx = var_9_7
		var_9_2.last_rewarded_score = tonumber(var_9_3)
		var_9_2.cur_score = var_9_4
		
		if var_9_2.unlock_condition then
			local var_9_10 = true
			local var_9_11 = string.split(var_9_2.unlock_condition, "=")
			local var_9_12 = var_9_11[1]
			local var_9_13 = var_9_11[2]
			
			if var_9_12 == "enter" then
				var_9_10 = not Account:isMapCleared(var_9_13)
			elseif var_9_12 == "schedule" then
				var_9_10 = not SubstoryManager:isActiveSchedule(var_9_13, SUBSTORY_CONSTANTS.ONE_WEEK)
			end
			
			var_9_2.is_locked = var_9_10
		end
		
		if DEBUG.SUB_OPEN_ALL_BOARD then
			var_9_2.is_locked = false
		end
		
		if not var_9_2.is_locked and var_9_2.cur_score < var_9_2.point_max then
			arg_9_0.vars.select_idx = var_9_0
		end
		
		var_9_0 = var_9_0 + 1
		
		local var_9_14 = math.floor(100 * (var_9_2.cur_score / var_9_2.point_max))
		
		var_9_2.cur_percent = math.min(var_9_14, 100)
		
		ControlBoardScriptManager:initTalkData(var_9_2.board_talk_id)
		table.insert(arg_9_0.vars.data, var_9_2)
	end
	
	if not arg_9_0.vars.select_idx then
		arg_9_0.vars.select_idx = 1
	end
end

function SubStoryControlBoard.refreshDataById(arg_10_0, arg_10_1)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) or not arg_10_1 then
		return 
	end
	
	if not Account:getSubStoryControlBoard(arg_10_0.vars.id) then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.select_idx
	
	if not arg_10_0.vars.data[var_10_0] then
		return 
	end
	
	local var_10_1 = DBT("substory_board", arg_10_1, {
		"id",
		"name",
		"portrait",
		"board_talk_id",
		"btn_move",
		"unlock_condition",
		"point_item",
		"point_max",
		"point_reward_id"
	})
	
	if not var_10_1 or not var_10_1.id then
		return 
	end
	
	local var_10_2 = SubStoryControlBoardUtil:_getRewardedPointByIdx(arg_10_0.vars.id, var_10_0)
	local var_10_3 = Account:getItemCount(var_10_1.point_item)
	local var_10_4 = {}
	local var_10_5
	local var_10_6
	
	for iter_10_0 = 1, 99999 do
		local var_10_7 = var_10_1.point_reward_id .. "_" .. iter_10_0
		local var_10_8 = DBT("substory_board_reward", var_10_7, {
			"id",
			"point",
			"item_id",
			"item_count",
			"grade_rate",
			"set_rate"
		})
		
		if not var_10_8 or not var_10_8.id then
			break
		end
		
		if var_10_2 >= var_10_8.point then
			var_10_8.state = CB_REWARD_STATE.REWARDED
			var_10_6 = iter_10_0
		elseif var_10_3 >= var_10_8.point then
			var_10_8.state = CB_REWARD_STATE.CANRECIVE
			var_10_5 = iter_10_0
		else
			var_10_8.state = CB_REWARD_STATE.LOCKED
		end
		
		table.insert(var_10_4, var_10_8)
	end
	
	var_10_1.reward_data = var_10_4
	var_10_1.rewardable_idx = var_10_5
	var_10_1.last_rewarded_idx = var_10_6
	
	if var_10_1.unlock_condition then
		local var_10_9 = true
		local var_10_10 = string.split(var_10_1.unlock_condition, "=")
		local var_10_11 = var_10_10[1]
		local var_10_12 = var_10_10[2]
		
		if var_10_11 == "enter" then
			var_10_9 = not Account:isMapCleared(var_10_12)
		elseif var_10_11 == "schedule" then
			var_10_9 = not SubstoryManager:isActiveSchedule(var_10_12, SUBSTORY_CONSTANTS.ONE_WEEK)
		end
		
		var_10_1.is_locked = var_10_9
	end
	
	if DEBUG.SUB_OPEN_ALL_BOARD then
		var_10_1.is_locked = false
	end
	
	var_10_1.last_rewarded_score = tonumber(var_10_2)
	var_10_1.cur_score = var_10_3
	
	local var_10_13 = math.floor(100 * (var_10_1.cur_score / var_10_1.point_max))
	
	var_10_1.cur_percent = math.min(var_10_13, 100)
	arg_10_0.vars.data[var_10_0] = var_10_1
end

function SubStoryControlBoard.initUI(arg_11_0)
	arg_11_0:initLeftPortraitUI()
	arg_11_0:initCenterUIAnimation()
	arg_11_0:updateLeftRewardNotiRedDot()
end

DEBUG_SPEED = {
	10000,
	8000,
	300000,
	10000
}
DEBUG_DIR = {
	360,
	-360,
	360,
	-360
}

function SubStoryControlBoard.initCenterUIAnimation(arg_12_0)
	local var_12_0 = {
		10000,
		8000,
		300000,
		10000
	}
	local var_12_1 = {
		360,
		-360,
		360,
		-360
	}
	
	for iter_12_0 = 1, 4 do
		local var_12_2 = arg_12_0.vars.wnd:getChildByName("n_spin_" .. iter_12_0)
		
		if get_cocos_refid(var_12_2) then
			local var_12_3 = DEBUG_SPEED[iter_12_0] or var_12_0[iter_12_0]
			local var_12_4 = DEBUG_DIR[iter_12_0] or var_12_1[iter_12_0]
			
			UIAction:Add(LOOP(ROTATE(var_12_3, 0, var_12_4)), var_12_2, "center_spin_" .. iter_12_0)
		end
	end
end

function SubStoryControlBoard.initLeftPortraitUI(arg_13_0)
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_access_info")
	local var_13_1 = arg_13_0.vars.wnd:getChildByName("n_access_port")
	local var_13_2 = arg_13_0.vars.wnd:getChildByName("n_lag")
	
	for iter_13_0, iter_13_1 in pairs(var_0_0) do
		local var_13_3 = var_13_0:getChildByName("n_" .. iter_13_1)
		local var_13_4 = var_13_1:getChildByName("n_" .. iter_13_1)
		local var_13_5 = var_13_4:getChildByName("n_port")
		local var_13_6 = var_13_2:getChildByName("n_" .. iter_13_1)
		
		if not get_cocos_refid(var_13_3) then
			break
		end
		
		local var_13_7 = arg_13_0.vars.data[iter_13_0]
		
		if not var_13_7 then
			break
		end
		
		local var_13_8 = var_13_3:getChildByName("btn_choose")
		
		if_set_visible(var_13_3, "n_on", false)
		if_set_visible(var_13_3, "n_off", true)
		if_set_visible(var_13_3, "icon_noti", false)
		
		if not var_13_7.is_locked then
			var_13_3:setVisible(true)
			if_set(var_13_3, "txt_name", T(var_13_7.name))
			if_set(var_13_3, "txt_point", var_13_7.cur_percent .. "%")
			
			local var_13_9 = var_13_3:getChildByName("progress_bar")
			
			if not var_13_3:getChildByName("@progress") then
				var_13_9:setVisible(false)
				
				local var_13_10 = WidgetUtils:createCircleProgress("img/z_aespa_gauge_bar.png")
				
				var_13_10:setCascadeOpacityEnabled(true)
				var_13_10:setScale(var_13_9:getScale())
				var_13_10:setPosition(var_13_9:getPosition())
				var_13_10:setOpacity(var_13_9:getOpacity())
				var_13_10:setColor(var_13_9:getColor())
				var_13_10:setReverseDirection(false)
				var_13_10:setName("@progress")
				var_13_10:setPercentage(var_13_7.cur_percent)
				var_13_3:addChild(var_13_10)
				var_13_10:setLocalZOrder(-1)
			end
			
			var_13_4:setVisible(true)
			
			local var_13_11 = UIUtil:getPortraitAni(var_13_7.portrait)
			
			var_13_5:addChild(var_13_11)
			if_set_visible(var_13_2, "n_" .. iter_13_1, false)
		else
			var_13_3:setVisible(false)
			if_set_visible(var_13_2, "n_" .. iter_13_1, true)
		end
		
		var_13_8.idx = iter_13_0
		
		local var_13_12 = {
			8000,
			12000,
			15000
		}
		local var_13_13 = table.count(var_13_12)
		local var_13_14 = var_13_3:getChildByName("n_on"):getChildByName("n_spin")
		local var_13_15 = var_13_3:getChildByName("n_off"):getChildByName("n_spin")
		
		UIAction:Add(LOOP(ROTATE(6000, 0, 360)), var_13_14, "left_on_spin_" .. iter_13_0)
		
		local var_13_16 = math.random(1, var_13_13)
		
		UIAction:Add(LOOP(ROTATE(var_13_12[var_13_16], 0, 360)), var_13_15, "left_off_spin_" .. iter_13_0)
		
		if var_13_6 then
			var_13_6:getChildByName("btn_choose").idx = iter_13_0
		end
	end
end

function SubStoryControlBoard.updateRewardUI(arg_14_0)
	local var_14_0 = SubStoryControlBoard:getCurData().reward_data
	
	if not var_14_0 then
		return 
	end
	
	if not arg_14_0.vars.scrollview_reward then
		arg_14_0.vars.scrollview_reward = arg_14_0.vars.wnd:getChildByName("scrollview_reward")
		
		arg_14_0:initScrollView(arg_14_0.vars.scrollview_reward, 196, 97)
		arg_14_0:createScrollViewItems(var_14_0)
	else
		arg_14_0:setScrollViewItems(var_14_0)
	end
	
	arg_14_0:_autoScrollRewardUI()
end

function SubStoryControlBoard._autoScrollRewardUI(arg_15_0)
	local var_15_0 = SubStoryControlBoard:getCurData()
	
	if not var_15_0 then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if var_15_0.rewardable_idx then
		arg_15_0:scrollToIndex(var_15_0.rewardable_idx)
	elseif var_15_0.last_rewarded_idx then
		arg_15_0:scrollToIndex(var_15_0.last_rewarded_idx)
	else
		arg_15_0:jumpToIndex(0)
	end
end

function SubStoryControlBoard.getScrollViewItem(arg_16_0, arg_16_1)
	local var_16_0 = load_control("wnd/dungeon_story_aespa_reward.csb")
	
	if_set_visible(var_16_0, "btn_reward", true)
	if_set(var_16_0, "txt_point", T("pass_vae2aa_point_pt", {
		point = arg_16_1.point
	}))
	if_set_visible(var_16_0, "icon_check", arg_16_1.state == CB_REWARD_STATE.REWARDED)
	if_set_opacity(var_16_0, "n_point", arg_16_1.state == CB_REWARD_STATE.REWARDED and 76.5 or 255)
	
	local var_16_1 = not (arg_16_1.state ~= CB_REWARD_STATE.REWARDED and arg_16_1.state ~= CB_REWARD_STATE.LOCKED) and 76.5 or 255
	
	if_set_opacity(var_16_0, "n_reward", var_16_1)
	if_set_visible(var_16_0, "icon_lock", arg_16_1.state == CB_REWARD_STATE.LOCKED)
	if_set_visible(var_16_0, "reward_icon", true)
	
	local var_16_2 = {
		tooltip_delay = 300,
		popup_delay = 100,
		parent = var_16_0:findChildByName("reward_icon"),
		grade_rate = arg_16_1.grade_rate,
		set_drop = arg_16_1.set_rate
	}
	local var_16_3 = UIUtil:getRewardIcon(arg_16_1.item_count, arg_16_1.item_id, var_16_2)
	
	if DB("equip_item", arg_16_1.item_id, "type") == "artifact" then
		if_set_sprite(var_16_3, "bg", "img/_blank.png")
	end
	
	UIUserData:call(var_16_0:getChildByName("txt_point"), "SINGLE_WSCALE(70)")
	
	local var_16_4 = var_16_0:getChildByName("btn_reward")
	
	if get_cocos_refid(var_16_4) then
		var_16_4.state = arg_16_1.state
	end
	
	return var_16_0
end

function SubStoryControlBoard.updateAllUI(arg_17_0)
	arg_17_0:updateLeftPortraitUI()
	arg_17_0:updateCenterUI()
end

function SubStoryControlBoard.updateLeftPortraitUI(arg_18_0)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_access_info")
	local var_18_1 = arg_18_0.vars.wnd:getChildByName("n_lag")
	
	for iter_18_0, iter_18_1 in pairs(var_0_0) do
		local var_18_2 = arg_18_0:getDataByIndex(iter_18_0)
		local var_18_3 = var_18_0:getChildByName("n_" .. iter_18_1)
		
		if not var_18_2 or not get_cocos_refid(var_18_3) then
			break
		end
		
		if arg_18_0.vars.select_idx == iter_18_0 then
			if_set_visible(var_18_3, "n_on", true)
			if_set_visible(var_18_3, "n_off", false)
		elseif not var_18_2.is_locked then
			if_set_visible(var_18_3, "n_on", false)
			if_set_visible(var_18_3, "n_off", true)
		end
		
		if false then
		end
	end
end

function SubStoryControlBoard.updateCenterUI(arg_19_0)
	local var_19_0 = arg_19_0:getCurData()
	local var_19_1 = arg_19_0.vars.wnd:getChildByName("n_select_info")
	local var_19_2 = var_19_1:getChildByName("btn_go")
	local var_19_3 = var_19_1:getChildByName("txt_name")
	local var_19_4 = getChildByPath(arg_19_0.vars.wnd, "n_port")
	
	if_set(var_19_3, nil, T(var_19_0.name))
	if_set(var_19_1, "txt_count", T("pass_vae2aa_point_progress", {
		now = var_19_0.cur_score,
		max = var_19_0.point_max
	}))
	if_set_color(var_19_1, "txt_count", tocolor(var_0_2[arg_19_0.vars.select_idx]))
	var_19_3:enableShadow(tocolor(var_0_1[arg_19_0.vars.select_idx]))
	
	var_19_2.move_path = var_19_0.btn_move
	
	local var_19_5 = SubstoryManager:getInfo()
	
	if not SubstoryManager:isActiveSchedule(var_19_5.id) then
		var_19_2:setOpacity(76.5)
	end
	
	for iter_19_0, iter_19_1 in pairs(var_0_0) do
		local var_19_6 = var_19_4:getChildByName("n_" .. iter_19_1)
		
		if get_cocos_refid(var_19_6) then
			var_19_6:setVisible(arg_19_0.vars.select_idx == iter_19_0)
			
			if arg_19_0.vars.select_idx == iter_19_0 and not var_19_6.portrait then
				var_19_6.portrait = UIUtil:getPortraitAni(var_19_0.portrait)
				
				var_19_6:addChild(var_19_6.portrait)
			end
		end
	end
	
	arg_19_0:centerPortraitChangeAction()
end

function SubStoryControlBoard.centerPortraitChangeAction(arg_20_0)
	if not arg_20_0.vars.prev_select or not arg_20_0.vars.select_idx then
		return 
	end
	
	UIAction:Remove("prev_port_act")
	UIAction:Remove("cur_port_act")
	
	local var_20_0 = getChildByPath(arg_20_0.vars.wnd, "n_port")
	local var_20_1
	local var_20_2
	
	for iter_20_0, iter_20_1 in pairs(var_0_0) do
		local var_20_3 = var_20_0:getChildByName("n_" .. iter_20_1)
		
		if get_cocos_refid(var_20_3) then
			if iter_20_0 == arg_20_0.vars.prev_select then
				var_20_1 = var_20_3
			elseif iter_20_0 == arg_20_0.vars.select_idx then
				var_20_2 = var_20_3
			end
		end
	end
	
	if not var_20_1.origin_x then
		var_20_1.origin_x = var_20_1:getPositionX()
		var_20_1.origin_y = var_20_1:getPositionY()
		var_20_1.origin_scale = var_20_1:getScaleX()
	end
	
	if not var_20_2.origin_x then
		var_20_2.origin_x = var_20_2:getPositionX()
		var_20_2.origin_y = var_20_2:getPositionY()
		var_20_2.origin_scale = var_20_2:getScaleX()
	end
	
	local var_20_4 = var_20_1.origin_x
	local var_20_5 = var_20_1.origin_y
	local var_20_6 = var_20_2.origin_x
	local var_20_7 = var_20_2.origin_y
	
	var_20_1:setPosition(var_20_4, var_20_5)
	var_20_2:setPosition(var_20_6, var_20_7)
	
	local var_20_8 = 400
	local var_20_9 = 600
	
	UIAction:Add(SEQ(SPAWN(RLOG(SCALE(var_20_8, var_20_1.origin_scale, 0), 300), RLOG(MOVE_BY(var_20_8, var_20_9), 300), FADE_OUT(var_20_8))), var_20_1, "prev_port_act")
	
	local var_20_10 = 1600
	
	var_20_2:setOpacity(0)
	UIAction:Add(SEQ(SPAWN(LOG(SCALE(var_20_8, 0, var_20_2.origin_scale), 300), LOG(SLIDE_IN(var_20_8, var_20_10, false), 300), FADE_IN(var_20_8))), var_20_2, "cur_port_act")
end

function SubStoryControlBoard.onSelect(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0.vars.select_idx == arg_21_1 then
		return 
	end
	
	if arg_21_0.vars.select_idx and arg_21_0:getDataByIndex(arg_21_1).is_locked then
		SubStoryControlBoardUtil:canEnterableContentsByIdx(arg_21_0.vars.id, arg_21_1, true)
		
		return 
	end
	
	if arg_21_2 then
		arg_21_0.vars.select_idx = arg_21_1
	else
		arg_21_0.vars.prev_select = arg_21_0.vars.select_idx
		arg_21_0.vars.select_idx = arg_21_1
	end
	
	local var_21_0 = arg_21_0:getCurData()
	
	ControlBoardScriptManager:change_talk(var_21_0.board_talk_id)
	arg_21_0:checkRewardableState()
	arg_21_0:updateAllUI()
	arg_21_0:onSelectUIAction(arg_21_1)
	arg_21_0:updateRewardBtnRedDot()
	
	arg_21_0.vars.wnd:getChildByName("btn_go").move_path = var_21_0.btn_move
	
	UIAction:Add(DELAY(300), arg_21_0, "block")
end

function SubStoryControlBoard.onSelectUIAction(arg_22_0, arg_22_1)
	arg_22_0:onSelectRewardUIAction(arg_22_1)
	arg_22_0:onSelectProgressUIAction(arg_22_1)
end

function SubStoryControlBoard.stopAnyProgressSounds(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if not arg_23_0.vars.progress_sounds then
		return 
	end
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.progress_sounds) do
		if get_cocos_refid(iter_23_1) and iter_23_1.stop then
			iter_23_1:stop()
		end
	end
	
	if get_cocos_refid(arg_23_0.vars.char_sound) and arg_23_0.vars.char_sound.stop then
		arg_23_0.vars.char_sound:stop()
	end
end

function SubStoryControlBoard.onSelectProgressUIAction(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("n_access_info")
	local var_24_1 = arg_24_0.vars.data[arg_24_1]
	
	if not var_24_1 or var_24_1.is_locked then
		return 
	end
	
	arg_24_0:stopAnyProgressSounds()
	
	for iter_24_0, iter_24_1 in pairs(var_0_0) do
		if iter_24_0 == arg_24_1 then
			UIAction:Remove("left_prog_" .. iter_24_0)
			
			local var_24_2 = var_24_0:getChildByName("n_" .. iter_24_1)
			
			if not get_cocos_refid(var_24_2) then
				break
			end
			
			local var_24_3 = var_24_2:getChildByName("@progress")
			
			if get_cocos_refid(var_24_3) then
				var_24_3:setPercentage(0)
				
				local var_24_4 = 0.06
				local var_24_5 = var_24_1.cur_percent / var_24_4
				local var_24_6 = SoundEngine:play("event:/effect/uieff_espa_board_gauge")
				
				arg_24_0.vars.progress_sounds[iter_24_0] = var_24_6
				
				UIAction:Add(SEQ(PERCENTAGE(var_24_5, 0, var_24_1.cur_percent)), var_24_3, "left_prog_" .. iter_24_0)
				
				if get_cocos_refid(var_24_6) then
					UIAction:Add(SEQ(DELAY(var_24_5), CALL(function()
						if get_cocos_refid(var_24_6) and var_24_6.stop then
							var_24_6:stop()
						end
					end)), var_24_6)
				end
				
				if get_cocos_refid(var_24_2._eff) then
					var_24_2._eff:removeFromParent()
					
					var_24_2._eff = nil
				end
				
				local var_24_7 = EffectManager:Play({
					pivot_x = 0,
					fn = "uieff_espa_board_btn.cfx",
					pivot_y = 0,
					pivot_z = 99998,
					scale = 1,
					layer = var_24_2
				})
				
				var_24_7:setAnchorPoint(0.5, 0.5)
				var_24_7:setPosition(var_24_3:getPosition())
				
				var_24_2._eff = var_24_7
			end
		end
	end
end

function SubStoryControlBoard.onSelectRewardUIAction(arg_26_0, arg_26_1)
	if not arg_26_0.vars.prev_select then
		arg_26_0:updateRewardUI()
		
		return 
	end
	
	local var_26_0 = arg_26_0.vars.wnd:getChildByName("scrollview_reward")
	
	if not arg_26_0.vars.origin_reward_x then
		arg_26_0.vars.origin_reward_x = var_26_0:getPositionX()
		arg_26_0.vars.origin_reward_y = var_26_0:getPositionY()
	end
	
	if UIAction:Find("reward_ui_action") then
		UIAction:Remove("reward_ui_action")
		var_26_0:setPosition(arg_26_0.vars.origin_reward_x, arg_26_0.vars.origin_reward_y)
		arg_26_0:updateRewardUI()
	end
	
	var_26_0:setOpacity(255)
	
	local var_26_1 = 550
	local var_26_2 = 200
	
	UIAction:Add(SEQ(LOG(MOVE_TO(var_26_2, nil, arg_26_0.vars.origin_reward_y - var_26_1)), CALL(function()
		arg_26_0:updateRewardUI()
	end), LOG(MOVE_TO(0, nil, arg_26_0.vars.origin_reward_y + var_26_1)), LOG(MOVE_TO(var_26_2, nil, arg_26_0.vars.origin_reward_y))), var_26_0, "reward_ui_action")
	UIAction:Add(SEQ(LOG(OPACITY(var_26_2, 1, 0)), LOG(OPACITY(var_26_2, 0, 1))), var_26_0, "reward_ui_action")
end

function SubStoryControlBoard.onSelectLeftUIAction(arg_28_0, arg_28_1)
	if not arg_28_1 then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_access_info")
	local var_28_1 = arg_28_0.vars.wnd:getChildByName("n_lag")
	
	for iter_28_0, iter_28_1 in pairs(var_0_0) do
		local var_28_2 = var_28_0:getChildByName("n_" .. iter_28_1)
		
		if not get_cocos_refid(var_28_2) then
			break
		end
		
		local var_28_3 = arg_28_0.vars.data[iter_28_0]
		
		if not var_28_3 then
			break
		end
		
		if not var_28_3.is_locked then
			local var_28_4
			local var_28_5 = false
			
			if arg_28_1 == iter_28_0 then
				var_28_4 = var_28_2:getChildByName("n_on"):getChildByName("n_spin")
				
				local var_28_6 = true
			else
				var_28_4 = var_28_2:getChildByName("n_off"):getChildByName("n_spin")
			end
			
			var_28_4:setRotation(0)
		end
	end
end

function SubStoryControlBoard.updateRewardBtnRedDot(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("n_access_info")
	local var_29_1 = arg_29_0.vars.wnd:getChildByName("n_lag")
	local var_29_2 = arg_29_0.vars.wnd:getChildByName("btn_receive")
	
	for iter_29_0, iter_29_1 in pairs(var_0_0) do
		local var_29_3 = var_29_0:getChildByName("n_" .. iter_29_1)
		
		if not get_cocos_refid(var_29_3) then
			break
		end
		
		local var_29_4 = arg_29_0.vars.data[iter_29_0]
		
		if not var_29_4 then
			break
		end
		
		if not var_29_4.is_locked and iter_29_0 == arg_29_0.vars.select_idx then
			local var_29_5 = SubStoryControlBoardUtil:_getRewardNoti(arg_29_0.vars.id, iter_29_0)
			
			if_set_visible(var_29_2, "icon_noti", var_29_5)
		end
	end
end

function SubStoryControlBoard.updateLeftRewardNotiRedDot(arg_30_0)
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("n_access_info")
	local var_30_1 = arg_30_0.vars.wnd:getChildByName("n_lag")
	
	for iter_30_0, iter_30_1 in pairs(var_0_0) do
		local var_30_2 = var_30_0:getChildByName("n_" .. iter_30_1)
		
		if not get_cocos_refid(var_30_2) then
			break
		end
		
		local var_30_3 = arg_30_0.vars.data[iter_30_0]
		
		if not var_30_3 then
			break
		end
		
		if not var_30_3.is_locked then
			local var_30_4 = SubStoryControlBoardUtil:_getRewardNoti(arg_30_0.vars.id, iter_30_0)
			
			if_set_visible(var_30_2, "icon_noti", var_30_4)
		end
	end
end

function SubStoryControlBoard.checkRewardableState(arg_31_0)
	arg_31_0.vars.can_req_reward = false
	
	local var_31_0 = arg_31_0:getCurData()
	
	for iter_31_0, iter_31_1 in pairs(var_31_0.reward_data) do
		if iter_31_1.state == CB_REWARD_STATE.CANRECIVE then
			arg_31_0.vars.can_req_reward = true
			
			break
		end
	end
end

function SubStoryControlBoard.getDataByIndex(arg_32_0, arg_32_1)
	return arg_32_0.vars.data[arg_32_1]
end

function SubStoryControlBoard.getCurData(arg_33_0)
	return arg_33_0.vars.data[arg_33_0.vars.select_idx]
end

function SubStoryControlBoard.req_reward(arg_34_0, arg_34_1)
	if arg_34_1 and arg_34_1 == CB_REWARD_STATE.LOCKED then
		balloon_message_with_sound("pass_vae2aa_point_shortage")
		
		return 
	end
	
	if not arg_34_0.vars.can_req_reward then
		balloon_message_with_sound("expedition_reward_get_faile")
		
		return 
	end
	
	local var_34_0 = arg_34_0:getCurData()
	local var_34_1 = var_34_0.id
	local var_34_2 = var_34_0.cur_score
	
	arg_34_0.vars.req_reward_id = var_34_1
	
	query("get_substory_control_board_reward", {
		substory_id = arg_34_0.vars.id,
		board_id = var_34_1,
		score = var_34_2
	})
	TutorialGuide:procGuide("tuto_board_a")
end

function SubStoryControlBoard.res_reward(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.vars.req_reward_id
	
	arg_35_0.vars.req_reward_id = nil
	
	arg_35_0:refreshDataById(var_35_0)
	arg_35_0:updateRewardUI()
	arg_35_0:checkRewardableState()
	arg_35_0:updateLeftRewardNotiRedDot()
	SubStoryLobbyUIDefault:updateUI()
	arg_35_0:updateRewardBtnRedDot()
end

function SubStoryControlBoard.getInfoNode(arg_36_0)
	return arg_36_0.vars.wnd:getChildByName("n_point_info")
end

function SubStoryControlBoard.close(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0:stopAnyProgressSounds()
	ControlBoardScriptManager:removeAll()
	TopBarNew:pop()
	BackButtonManager:pop("dungeon_story_aespa")
	arg_37_0.vars.wnd:removeFromParent()
	
	arg_37_0.vars = nil
end

function SubStoryControlBoardUtil._getRewardedPointByIdx(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_1 or not arg_38_2 then
		return 
	end
	
	return Account:getSubStoryControlBoard(arg_38_1)[var_0_3 .. arg_38_2] or 0
end

function SubStoryControlBoardUtil.isAlreadyGetRewardedBefore(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return 
	end
	
	local var_39_0 = Account:getSubStoryControlBoard(arg_39_1)
	
	if not var_39_0 then
		return 
	end
	
	return var_39_0.board_score1 > 0
end

function SubStoryControlBoardUtil.getRewardNoti(arg_40_0, arg_40_1, arg_40_2)
	if not SubstoryManager:getInfo() then
		return 
	end
	
	if arg_40_2 == nil then
		for iter_40_0 = 1, 4 do
			if arg_40_0:_getRewardNoti(arg_40_1, iter_40_0) then
				return true
			end
		end
	else
		return arg_40_0:_getRewardNoti(arg_40_1, arg_40_2)
	end
	
	return false
end

function SubStoryControlBoardUtil._getRewardNoti(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_1 or SubstoryManager:getInfo().id
	local var_41_1 = var_41_0 .. "_" .. arg_41_2
	local var_41_2 = DBT("substory_board", var_41_1, {
		"id",
		"name",
		"portrait",
		"board_talk_id",
		"btn_move",
		"unlock_condition",
		"point_item",
		"point_max",
		"point_reward_id"
	})
	
	if not var_41_2 or not var_41_2.id then
		return 
	end
	
	local var_41_3 = SubStoryControlBoardUtil:_getRewardedPointByIdx(var_41_0, arg_41_2)
	local var_41_4 = Account:getItemCount(var_41_2.point_item)
	
	for iter_41_0 = 1, 99999 do
		local var_41_5 = var_41_2.point_reward_id .. "_" .. iter_41_0
		local var_41_6 = DBT("substory_board_reward", var_41_5, {
			"id",
			"point",
			"item_id",
			"item_count",
			"grade_rate",
			"set_rate"
		})
		
		if not var_41_6 or not var_41_6.id then
			break
		end
		
		if var_41_3 >= var_41_6.point then
		elseif var_41_4 >= var_41_6.point then
			return true
		end
		
		if false then
		end
	end
end

function SubStoryControlBoardUtil.canEnterableContents(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_1 then
		return 
	end
	
	local var_42_0
	local var_42_1 = arg_42_1 .. "_1"
	local var_42_2, var_42_3 = DB("substory_board", var_42_1, {
		"id",
		"unlock_condition"
	})
	
	if not var_42_2 or not var_42_3 then
		return 
	end
	
	local var_42_4 = true
	local var_42_5 = string.split(var_42_3, "=")
	local var_42_6 = var_42_5[1]
	local var_42_7 = var_42_5[2]
	
	if var_42_6 == "enter" then
		var_42_4 = not Account:isMapCleared(var_42_7)
	elseif var_42_6 == "schedule" then
		var_42_4 = not SubstoryManager:isActiveSchedule(var_42_7, SUBSTORY_CONSTANTS.ONE_WEEK)
	end
	
	if var_42_4 and arg_42_2 then
		local var_42_8
		
		if var_42_6 == "enter" then
			local var_42_9 = T(DB("level_enter", var_42_7, "name"))
			
			var_42_8 = T("req_prev_map", {
				enter = var_42_9
			})
		elseif var_42_6 == "schedule" then
			local var_42_10 = Account:getSubStoryScheduleDBById(var_42_7)
			local var_42_11 = var_42_10.start_time
			local var_42_12 = var_42_10.end_time
			
			if var_42_10 and var_42_11 and var_42_12 then
				local var_42_13 = os.time()
				
				if var_42_13 < var_42_11 or var_42_12 < var_42_13 then
					var_42_8 = T("req_prev_time", {
						time = sec_to_full_string(var_42_11 - os.time())
					})
				end
			end
		end
		
		if var_42_8 then
			balloon_message_with_sound_raw_text(var_42_8)
		end
	end
	
	return not var_42_4
end

function SubStoryControlBoardUtil.moveToPath(arg_43_0, arg_43_1)
	if not arg_43_1 then
		return 
	end
	
	movetoPath(arg_43_1)
end

function SubStoryControlBoardUtil.canEnterableContentsByIdx(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if not arg_44_1 or not arg_44_2 then
		return 
	end
	
	local var_44_0
	local var_44_1 = arg_44_1 .. "_" .. arg_44_2
	local var_44_2, var_44_3 = DB("substory_board", var_44_1, {
		"id",
		"unlock_condition"
	})
	
	if not var_44_2 or not var_44_3 then
		return 
	end
	
	local var_44_4 = true
	local var_44_5 = string.split(var_44_3, "=")
	local var_44_6 = var_44_5[1]
	local var_44_7 = var_44_5[2]
	
	if var_44_6 == "enter" then
		var_44_4 = not Account:isMapCleared(var_44_7)
	elseif var_44_6 == "schedule" then
		var_44_4 = not SubstoryManager:isActiveSchedule(var_44_7, SUBSTORY_CONSTANTS.ONE_WEEK)
	end
	
	if var_44_4 and arg_44_3 then
		local var_44_8
		
		if var_44_6 == "enter" then
			local var_44_9 = T(DB("level_enter", var_44_7, "name"))
			
			var_44_8 = T("req_prev_map", {
				enter = var_44_9
			})
		elseif var_44_6 == "schedule" then
			local var_44_10 = Account:getSubStoryScheduleDBById(var_44_7)
			local var_44_11 = var_44_10.start_time
			local var_44_12 = var_44_10.end_time
			
			if var_44_10 and var_44_11 and var_44_12 then
				local var_44_13 = os.time()
				
				if var_44_13 < var_44_11 or var_44_12 < var_44_13 then
					var_44_8 = T("req_prev_time", {
						time = sec_to_full_string(var_44_11 - os.time())
					})
				end
			end
		end
		
		if var_44_8 then
			balloon_message_with_sound_raw_text(var_44_8)
		end
	end
	
	return not var_44_4
end

local var_0_4 = 186
local var_0_5 = 14

function ControlBoardScriptManager.init(arg_45_0, arg_45_1)
	arg_45_0.vars = {}
	arg_45_0.vars.data = {}
	arg_45_0.vars.wnd = arg_45_1
	arg_45_0.vars.talk_id = nil
	arg_45_0.vars.talk_items = {}
	arg_45_0.vars.is_night = UIUtil:IsNight()
	
	local var_45_0 = cc.CSLoader:createNode("wnd/dungeon_story_aespa_log.csb"):getContentSize()
	
	arg_45_0:initScrollView(arg_45_0.vars.wnd, var_0_4, var_0_5)
	arg_45_0:setScrollViewItems(arg_45_0.vars.talk_items)
end

function ControlBoardScriptManager.initTalkData(arg_46_0, arg_46_1)
	if not arg_46_1 then
		return 
	end
	
	arg_46_0.vars.data[arg_46_1] = {}
	
	for iter_46_0 = 1, 999999 do
		local var_46_0 = arg_46_1 .. "_" .. iter_46_0
		local var_46_1 = DBT("substory_board_talk", var_46_0, {
			"id",
			"type",
			"name",
			"condition",
			"text",
			"voice"
		})
		
		if not var_46_1 or not var_46_1.id then
			break
		end
		
		local var_46_2 = false
		
		if var_46_1.type == "morning" and not arg_46_0.vars.is_night then
			var_46_2 = true
		elseif var_46_1.type == "night" and arg_46_0.vars.is_night then
			var_46_2 = true
		elseif var_46_1.type == "story" and var_46_1.condition and Account:isPlayedStory(var_46_1.condition) then
			var_46_2 = true
		elseif var_46_1.type == "idle" then
			var_46_2 = true
		end
		
		if var_46_2 then
			table.insert(arg_46_0.vars.data[arg_46_1], var_46_1)
		end
	end
end

function ControlBoardScriptManager.change_talk(arg_47_0, arg_47_1)
	arg_47_0.vars.talk_id = arg_47_1
	
	if UIAction:Find("add_talk") then
		UIAction:Remove("add_talk")
	end
	
	local var_47_0 = {
		1000,
		2000
	}
	local var_47_1 = math.random(1, 2)
	
	arg_47_0.vars.talk_delta_time = 0
	arg_47_0.vars.talk_delay = 0
	
	arg_47_0:_changeTalkDelay()
	UIAction:Add(SEQ(DELAY(var_47_0[var_47_1]), CALL(function()
		ControlBoardScriptManager:addTalk()
	end)), arg_47_0, "add_talk")
end

function ControlBoardScriptManager.getCurTalkData(arg_49_0)
	return arg_49_0.vars.data[arg_49_0.vars.talk_id]
end

function ControlBoardScriptManager.addTalk(arg_50_0)
	if arg_50_0.vars.show_talk_schedule then
		Scheduler:remove(arg_50_0.vars.show_talk_schedule)
		
		arg_50_0.vars.show_talk_schedule = nil
	end
	
	arg_50_0:showTalk(true)
	
	arg_50_0.vars.show_talk_schedule = Scheduler:addSlow(arg_50_0.vars.wnd, ControlBoardScriptManager.showTalk, ControlBoardScriptManager)
end

function ControlBoardScriptManager._changeTalkDelay(arg_51_0)
	if not arg_51_0.vars then
		return 
	end
	
	local var_51_0 = {
		10000,
		11000
	}
	
	arg_51_0.vars.talk_delay = var_51_0[math.random(1, table.count(var_51_0))]
end

function ControlBoardScriptManager.showTalk(arg_52_0, arg_52_1)
	if not arg_52_0.vars or not get_cocos_refid(arg_52_0.vars.wnd) or table.empty(arg_52_0.vars.data) or not arg_52_0.vars.talk_id or table.empty(arg_52_0:getCurTalkData()) then
		return 
	end
	
	if not arg_52_1 then
		arg_52_0.vars.talk_delta_time = arg_52_0.vars.talk_delta_time + 1000
		
		if arg_52_0.vars.talk_delta_time >= arg_52_0.vars.talk_delay then
			arg_52_0.vars.talk_delta_time = 0
			
			arg_52_0:_changeTalkDelay()
		else
			return 
		end
	end
	
	local var_52_0 = arg_52_0:getCurTalkData()
	local var_52_1 = table.count(var_52_0)
	local var_52_2 = math.random(1, var_52_1)
	
	if arg_52_0.vars.prev_idx and arg_52_0.vars.prev_idx == var_52_2 then
		for iter_52_0 = 1, 9999999 do
			var_52_2 = math.random(1, var_52_2)
			
			if arg_52_0.vars.prev_idx ~= var_52_2 then
				break
			end
		end
	end
	
	arg_52_0.vars.prev_idx = var_52_2
	
	local var_52_3 = var_52_0[var_52_2]
	
	if var_52_3.voice then
		if get_cocos_refid(arg_52_0.vars.char_sound) and arg_52_0.vars.char_sound.stop then
			arg_52_0.vars.char_sound:stop()
		end
		
		arg_52_0.vars.char_sound = SoundEngine:play("event:/voc/" .. var_52_3.voice)
	end
	
	arg_52_0:addItem(var_52_3)
	arg_52_0:arrangeChat()
end

function ControlBoardScriptManager.arrangeChat(arg_53_0)
	local var_53_0 = 0
	local var_53_1 = var_0_4
	local var_53_2 = 4
	local var_53_3 = false
	
	while #arg_53_0.vars.talk_items > 4 do
		local var_53_4 = table.remove(arg_53_0.vars.talk_items, 1)
		
		if get_cocos_refid(var_53_4) then
			var_53_4:removeFromParent()
			
			var_53_3 = true
		end
	end
	
	local var_53_5 = table.count(arg_53_0.vars.talk_items)
	
	for iter_53_0 = 1, var_53_5 do
		local var_53_6 = var_53_5 - iter_53_0 + 1
		local var_53_7 = arg_53_0.vars.talk_items[var_53_6]
		
		var_53_7:setPositionY(var_53_0)
		
		var_53_0 = var_53_0 + var_53_7.node_height * var_53_7:getScaleY()
		
		if var_53_6 ~= 1 then
			var_53_0 = var_53_0 + var_53_2
		end
	end
	
	local var_53_8 = arg_53_0.scrollview:getInnerContainer():getPositionY()
	
	arg_53_0.scrollview:setInnerContainerSize({
		width = var_53_1,
		height = var_53_0
	})
	
	local var_53_9 = arg_53_0.vars.talk_items[var_53_5]
	local var_53_10 = var_53_9.node_height * var_53_9:getScaleY()
	
	if not var_53_3 and var_53_8 < -50 then
		var_53_8 = var_53_8 - (var_53_10 + var_53_2)
	elseif var_53_3 and var_53_8 < -50 then
		if var_53_0 - arg_53_0.scrollview:getContentSize().height + (var_53_8 - var_53_10) < 0 then
			var_53_8 = -(var_53_0 - arg_53_0.scrollview:getContentSize().height)
		else
			var_53_8 = var_53_8 - (var_53_10 + var_53_2)
		end
	end
	
	if var_53_8 > -50 then
		var_53_8 = 0
	end
	
	arg_53_0.scrollview:getInnerContainer():setPositionY(var_53_8)
end

function ControlBoardScriptManager.addItem(arg_54_0, arg_54_1)
	local var_54_0 = var_0_5
	local var_54_1 = var_0_5
	local var_54_2 = load_control("wnd/dungeon_story_aespa_log.csb")
	
	upgradeLabelToRichLabel(var_54_2, "txt_msg")
	if_set(var_54_2, "txt_msg", T(arg_54_1.text))
	arg_54_0.scrollview:getInnerContainer():addChild(var_54_2)
	
	local var_54_3 = var_54_2:getChildByName("txt_msg"):getStringNumLines()
	
	if var_54_3 >= 2 then
		var_54_0 = var_54_0 + (var_54_3 - 1) * var_54_1
	end
	
	var_54_2.node_height = var_54_0
	var_54_2.line_num = var_54_3 - 1
	
	table.push(arg_54_0.vars.talk_items, var_54_2)
end

function ControlBoardScriptManager.removeAll(arg_55_0)
	if not arg_55_0.vars then
		return 
	end
	
	UIAction:Remove("add_talk")
	
	if arg_55_0.vars.show_talk_schedule then
		Scheduler:remove(arg_55_0.vars.show_talk_schedule)
	end
	
	arg_55_0.vars = nil
end

SubStoryControlBoardInfo = SubStoryControlBoardInfo or {}

function SubStoryControlBoardInfo.show(arg_56_0, arg_56_1)
	if arg_56_0.vars and get_cocos_refid(arg_56_0.vars.wnd) then
		return 
	end
	
	if not (arg_56_1 or {}).parent_layer then
		local var_56_0 = SceneManager:getRunningNativeScene()
	end
	
	arg_56_0.vars = {}
	arg_56_0.vars.wnd = SubStoryControlBoard:getInfoNode()
	
	if not get_cocos_refid(arg_56_0.vars.wnd) then
		return 
	end
	
	arg_56_0.vars.wnd:setOpacity(0)
	UIAction:Add(SEQ(SHOW(true), FADE_IN(150)), arg_56_0.vars.wnd, "block")
	
	local var_56_1 = arg_56_0.vars.wnd:getChildByName("txt_info")
	
	if get_cocos_refid(var_56_1) and not (var_56_1 == "ccui.RichText") then
		upgradeLabelToRichLabel(var_56_1)
		var_56_1:setLineSpacing(5)
	end
	
	BackButtonManager:push({
		check_id = "SubStoryControlBoardInfo",
		back_func = function()
			arg_56_0:close()
		end
	})
	
	arg_56_0.vars.id = SubStoryControlBoard.vars.id
	
	arg_56_0:initData()
	arg_56_0:initUI()
	TutorialGuide:procGuide("tuto_board_a")
end

function SubStoryControlBoardInfo.initData(arg_58_0)
	arg_58_0.vars.data = {}
	
	for iter_58_0 = 1, 9999 do
		local var_58_0 = arg_58_0.vars.id .. "_" .. iter_58_0
		local var_58_1 = DBT("substory_board", var_58_0, {
			"id",
			"point_desc_before",
			"point_desc_after"
		})
		
		if not var_58_1 or not var_58_1.id then
			break
		end
		
		var_58_1.is_locked = SubStoryControlBoard:getDataByIndex(iter_58_0).is_locked
		
		table.insert(arg_58_0.vars.data, var_58_1)
	end
end

function SubStoryControlBoardInfo.initUI(arg_59_0)
	local var_59_0 = ""
	
	for iter_59_0, iter_59_1 in pairs(arg_59_0.vars.data) do
		local var_59_1
		
		if iter_59_1.is_locked then
			var_59_1 = T(iter_59_1.point_desc_before)
		else
			var_59_1 = T(iter_59_1.point_desc_after)
		end
		
		var_59_0 = var_59_0 .. var_59_1 .. "\n"
	end
	
	if_set(arg_59_0.vars.wnd, "txt_info", var_59_0)
	
	local var_59_2 = arg_59_0.vars.wnd:getChildByName("txt_info")
	
	if get_cocos_refid(var_59_2) then
		local var_59_3 = var_59_2:getStringNumLines()
		
		if var_59_3 > 4 then
			local var_59_4 = var_59_3 - 4
			local var_59_5 = arg_59_0.vars.wnd:getChildByName("n_bg")
			local var_59_6 = arg_59_0.vars.wnd:getChildByName("n_bottom")
			
			if get_cocos_refid(var_59_5) and get_cocos_refid(var_59_6) then
				var_59_6:setPositionY(var_59_6:getPositionY() - var_59_4 * 15)
				
				local var_59_7 = var_59_5:getContentSize()
				
				var_59_5:setContentSize({
					width = var_59_7.width,
					height = var_59_7.height + var_59_4 * 15
				})
			end
		end
	end
end

function SubStoryControlBoardInfo.close(arg_60_0)
	if not arg_60_0.vars or not get_cocos_refid(arg_60_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(150), SHOW(false)), arg_60_0.vars.wnd, "block")
	
	arg_60_0.vars = nil
	
	BackButtonManager:pop("SubStoryControlBoardInfo")
end

function SubStoryControlBoard.test_reset_reward(arg_61_0)
	query("test_reset_all_control_board_reward_data")
end

function SubStoryControlBoard.test_req_reward(arg_62_0)
	arg_62_0:show()
	arg_62_0:req_reward()
end
