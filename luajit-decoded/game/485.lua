SubTask = {}

function HANDLER.subtask_v2_card(arg_1_0, arg_1_1)
	local var_1_0 = string.split(arg_1_1, ":")
	
	if var_1_0 and var_1_0[1] == "btn_list" and var_1_0[2] then
		SubTaskList:selectItem(var_1_0[2])
	end
	
	if arg_1_1 == "btn_upgrade_subtask" then
		SanctuaryMain:ToggleUpgradeMode(arg_1_0.req_levels)
	end
end

function HANDLER.subtask_v2_ready(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_slot1" then
		SubTask:cancelHero(1)
	elseif arg_2_1 == "btn_slot2" then
		SubTask:cancelHero(2)
	elseif arg_2_1 == "btn_slot3" then
		SubTask:cancelHero(3)
	elseif arg_2_1 == "btn_slot4" then
		SubTask:cancelHero(4)
	elseif arg_2_1 == "btn_start" then
		SubTask:startMission()
	elseif arg_2_1 == "btn_cancel" then
		SubTask:cancelMission()
	end
end

function HANDLER.subtask_result(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ignore" then
		SubTask:skipResultUI()
	elseif arg_3_1 == "btn_ok" then
		SubTask:closeResultUI()
	elseif arg_3_1 == "btn_retry" then
		SubTask:retryLast()
	end
end

function HANDLER.subtask_v2_group(arg_4_0, arg_4_1)
	local var_4_0 = string.split(arg_4_1, ":")
	
	if var_4_0 and var_4_0[1] == "btn_group_detail" and var_4_0[2] then
		SubTaskList:selectItemByGroups(var_4_0[2])
	end
end

function MsgHandler.subtask_start(arg_5_0)
	Account:updateCurrencies(arg_5_0, {
		content = "subtask"
	})
	Account:addSubtaskMission(arg_5_0.mission)
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.team_units) do
		Account:updateUnitByInfo(iter_5_1)
	end
	
	if SceneManager:getCurrentSceneName() == "sanctuary" and SanctuaryMain:getMode() == "SubTask" and SubTask:setMode("List") == false then
		SubTaskList:refresh()
	end
	
	SubTask:updateLocalPush()
end

function MsgHandler.subtask_cancel(arg_6_0)
	Account:updateCurrencies(arg_6_0, {
		content = "subtask"
	})
	Account:deleteSubtaskMission(arg_6_0.mission_id)
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.team_units) do
		Account:updateUnitByInfo(iter_6_1)
	end
	
	if SubTask:setMode("List") == false then
		SubTaskList:refresh()
	end
	
	SubTask:resetHeroBelt()
	SubTask:updateLocalPush()
end

function MsgHandler.subtask_complete(arg_7_0)
	Account:deleteSubtaskMission(arg_7_0.mission_id)
	ConditionContentsManager:dispatch("subtask.clear")
	
	local var_7_0 = Account:addReward(arg_7_0.rewards, {
		content = "subtask"
	})
	local var_7_1 = {}
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.team_units) do
		local var_7_2 = Account:getUnit(iter_7_1.id)
		local var_7_3
		
		if var_7_2 then
			var_7_3 = var_7_2:getLv()
			var_7_1[iter_7_1.id] = {
				var_7_2:getEXP(),
				var_7_2:getEXPRatio(),
				var_7_2:getLv()
			}
		end
		
		local var_7_4 = Account:updateUnitByInfo(iter_7_1)
		
		if var_7_3 and var_7_4 and var_7_4:getLv() ~= var_7_3 then
			ConditionContentsManager:dispatch("unit.levelup", {
				level = var_7_4:getLv(),
				prev_level = var_7_3,
				grade = var_7_4:getGrade(),
				chrid = var_7_4.db.code
			})
			ConditionContentsManager:dispatch("growthboost.sync.lv")
			
			if var_7_4.db.code == "c3026" then
				ConditionContentsManager:dispatch("c3026.levelup", {
					unit = var_7_4
				})
			end
		end
	end
	
	arg_7_0.old_unit_exp = var_7_1
	
	SceneManager:updateTouchEventTime()
	SubTask:resultUI(arg_7_0)
	
	if SceneManager:getCurrentSceneName() == "sanctuary" and SanctuaryMain:getMode() == "SubTask" and SubTask:setMode("List") == false then
		SubTaskList:refresh()
	end
	
	SubTask:updateLocalPush()
end

function ErrHandler.subtask_complete(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == "not_end_time" then
		if SceneManager:getCurrentSceneName() == "lobby" then
			Dialog:msgBox(T("subtask_complete.not_end_time"), {
				handler = function()
					Lobby:nextNoti()
				end
			})
			
			return 
		elseif SceneManager:getCurrentSceneName() == "sanctuary" then
			balloon_message_with_sound("error_try_again")
			
			return 
		end
	end
	
	on_net_error(arg_8_0, arg_8_1, arg_8_2)
end

function ErrHandler.subtask_start(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 == "already_accepted_mission" and SceneManager:getCurrentSceneName() == "sanctuary" then
		Dialog:msgBox(T("subtask_start.already_accepted_mission"), {
			handler = function()
				local var_11_0 = SubTask:getCurrentSubTask()
				
				if var_11_0 then
					query("subtask_complete", {
						mission_id = var_11_0
					})
				end
			end
		})
		
		return 
	end
	
	on_net_error(arg_10_0, arg_10_1, arg_10_2)
end

function SubTask.updateLocalPush(arg_12_0)
	cancel_local_push(LOCAL_PUSH_IDS.SUBTASK_COMPLETE_1)
	cancel_local_push(LOCAL_PUSH_IDS.SUBTASK_COMPLETE_2)
	cancel_local_push(LOCAL_PUSH_IDS.SUBTASK_COMPLETE_3)
	
	local var_12_0 = 0
	
	for iter_12_0, iter_12_1 in pairs(AccountData.subtask or {}) do
		var_12_0 = var_12_0 + 1
		
		add_local_push("SUBTASK_COMPLETE_" .. var_12_0, iter_12_1.end_time - os.time())
	end
end

function SubTask.show(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.vars = {}
	arg_13_0.vars.args = arg_13_2
	
	local var_13_0 = {}
	
	for iter_13_0 = 1, 9999 do
		local var_13_1, var_13_2, var_13_3, var_13_4, var_13_5, var_13_6, var_13_7, var_13_8, var_13_9, var_13_10, var_13_11, var_13_12, var_13_13, var_13_14, var_13_15, var_13_16, var_13_17 = DBN("subtask_mission", iter_13_0, {
			"id",
			"num",
			"name",
			"category",
			"type",
			"faction",
			"faction_level",
			"time",
			"req_level",
			"condition1",
			"condition2",
			"npc",
			"script",
			"reward1",
			"reward2",
			"unlock_condition1",
			"unlock_condition2"
		})
		
		if var_13_1 == nil then
			break
		end
		
		if var_13_0[var_13_4] == nil then
			var_13_0[var_13_4] = {}
		end
		
		local var_13_18 = #var_13_0[var_13_4] + 1
		
		var_13_0[var_13_4][var_13_18] = {
			id = var_13_1,
			num = var_13_2,
			name = var_13_3,
			category = var_13_4,
			type = var_13_5,
			faction = var_13_6,
			faction_level = var_13_7,
			time = var_13_8,
			req_level = var_13_9,
			condition1 = var_13_10,
			condition2 = var_13_11,
			npc = var_13_12,
			script = var_13_13,
			reward1 = var_13_14,
			reward2 = var_13_15,
			unlock_condition1 = var_13_16,
			unlock_condition2 = var_13_17
		}
	end
	
	arg_13_0.vars.mission_list = var_13_0
	
	local var_13_19 = {}
	
	arg_13_0.vars.category_list_by_id = {}
	
	for iter_13_1 = 1, 9999 do
		local var_13_20, var_13_21, var_13_22, var_13_23, var_13_24, var_13_25 = DBN("subtask_mission_category", iter_13_1, {
			"id",
			"name",
			"desc",
			"sort",
			"unlock_condition",
			"icon"
		})
		
		if var_13_20 == nil then
			break
		end
		
		arg_13_0.vars.category_list_by_id[var_13_20] = {
			id = var_13_20,
			name = var_13_21,
			desc = var_13_22,
			sort = var_13_23,
			icon = var_13_25,
			unlock_condition = var_13_24
		}
		var_13_19[tonumber(var_13_23)] = arg_13_0.vars.category_list_by_id[var_13_20]
	end
	
	arg_13_0.vars.category_list = var_13_19
	arg_13_0.vars.wnd = load_dlg("subtask_v2", true, "wnd")
	
	arg_13_1:addChild(arg_13_0.vars.wnd)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stone",
		"stamina"
	})
	arg_13_0:setMode("List")
	
	if SceneManager:getCurrentSceneName() == "subtask" then
		TopBarNew:create(T("game_log_subtask"), arg_13_0.vars.wnd, function()
			arg_13_0:onPushBackButton()
			BackButtonManager:pop("TopBarNew." .. T("game_log_subtask"))
		end)
	else
		if_set_visible(arg_13_0.vars.wnd, "background")
	end
	
	Action:Add(SEQ(DELAY(2000), CALL(arg_13_0.startAutoUpdate, arg_13_0)), arg_13_0.vars.wnd)
	SubTaskList:autoUpdate()
	arg_13_0:autoUpdateList()
	
	if arg_13_2 and arg_13_2.test then
		arg_13_0:resultUI(nil, arg_13_2.test)
	end
	
	LuaEventDispatcher:removeEventListenerByKey("subtask.update_unit_popup")
	LuaEventDispatcher:addEventListener("unit_popup_detail.close", LISTENER(arg_13_0.updateOnLeaveUnitPopupMode, arg_13_0), "subtask.update_unit_popup")
	
	return arg_13_0.vars.wnd
end

function SubTask.getCategoryListByID(arg_15_0, arg_15_1)
	return arg_15_0.vars.category_list_by_id[arg_15_1]
end

function SubTask.onPushBackButton(arg_16_0)
	if arg_16_0.vars.mode == "List" then
		if SceneManager:getCurrentSceneName() == "subtask" then
			SceneManager:popScene()
		else
			return true
		end
	end
	
	arg_16_0:setMode("List", {
		cancel_all_hero = true
	})
end

function SubTask.getCurrentSubTask(arg_17_0)
	if not arg_17_0.vars then
		return nil
	end
	
	return arg_17_0.vars.subtask
end

function SubTask.startAutoUpdate(arg_18_0)
	Scheduler:addSlow(arg_18_0.vars.wnd, arg_18_0.autoUpdate, arg_18_0, true):setName("subtask_update_slow")
end

function SubTask.autoUpdate(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	if arg_19_0.vars.mode == "List" then
		SubTaskList:autoUpdate()
		arg_19_0:autoUpdateList()
	elseif arg_19_0.vars.mode == "Ready" then
		arg_19_0:autoUpdateReady()
	end
	
	if os.time() % 2 == 0 then
		if not TopBarNew:isToday() then
			return 
		end
		
		if arg_19_0:checkComplete() then
			arg_19_0:complete()
		end
	end
end

function SubTask.getMissionListByCategory(arg_20_0, arg_20_1)
	return arg_20_0.vars.mission_list[arg_20_1]
end

function SubTask.setMode(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0.vars then
		return nil
	end
	
	if arg_21_0.vars.mode == arg_21_1 then
		return false
	end
	
	if arg_21_0.vars.mode then
		local var_21_0 = arg_21_0["onLeave" .. arg_21_0.vars.mode .. "Mode"]
		
		if var_21_0 then
			var_21_0(arg_21_0, arg_21_1, arg_21_2)
		end
	end
	
	local var_21_1 = arg_21_0["onEnter" .. arg_21_1 .. "Mode"]
	
	if var_21_1 then
		var_21_1(arg_21_0, arg_21_2)
	end
	
	if arg_21_0.vars.mode and arg_21_1 == "List" then
		TopBarNew:setEnableTopRight()
		BackButtonManager:pop("SubTask.setMode")
	elseif arg_21_1 == "Ready" then
		TopBarNew:setDisableTopRight()
		BackButtonManager:push({
			check_id = "SubTask.setMode",
			back_func = function()
				SubTask:onPushBackButton()
			end
		})
	end
	
	arg_21_0.vars.mode = arg_21_1
	
	return true
end

function SubTask.updateGroups(arg_23_0)
	local var_23_0 = arg_23_0.vars.wnd.c.LEFT
	
	for iter_23_0 = 1, 4 do
		var_23_0:getChildByName("n_group" .. iter_23_0):removeChildByName("subtask_v2_group")
	end
	
	local var_23_1 = {}
	
	for iter_23_1, iter_23_2 in pairs(AccountData.subtask) do
		table.push(var_23_1, {
			id = iter_23_1,
			start_time = iter_23_2.start_time
		})
	end
	
	table.sort(var_23_1, function(arg_24_0, arg_24_1)
		return arg_24_0.start_time < arg_24_1.start_time
	end)
	
	for iter_23_3, iter_23_4 in pairs(var_23_1) do
		local var_23_2 = var_23_0:getChildByName("n_group" .. iter_23_3)
		local var_23_3 = load_dlg("subtask_v2_group", true, "wnd")
		
		var_23_3:setAnchorPoint(0, 0)
		var_23_3:setPosition(0, 0)
		var_23_3.c.btn_group_detail:setName("btn_group_detail:" .. iter_23_4.id)
		
		local var_23_4 = SubTask:getSubtaskMissionDB(iter_23_4.id)
		local var_23_5 = Account:getSubtaskMission(iter_23_4.id)
		
		var_23_3.subtask_mission_id = iter_23_4.id
		
		if_set(var_23_3, "txt_title", T(var_23_4.num))
		
		local var_23_6 = os.time()
		
		if var_23_6 < var_23_5.end_time then
			if_set(var_23_3, "txt_time", sec_to_full_string(var_23_5.end_time - var_23_6))
		else
			if_set(var_23_3, "txt_time", T("complete_text"))
		end
		
		arg_23_0:setPercent(var_23_3, var_23_5, var_23_6)
		
		if var_23_4.reward1 then
			if_set_visible(var_23_3, "n_item1", true)
			UIUtil:getRewardIcon(var_23_4.reward_count1, var_23_4.reward1, {
				scale = 0.65,
				parent = var_23_3.c.n_item1
			})
		else
			if_set_visible(var_23_3, "n_item1", false)
		end
		
		if var_23_4.reward2 then
			if_set_visible(var_23_3, "n_item2", true)
			UIUtil:getRewardIcon(var_23_4.reward_count2, var_23_4.reward2, {
				scale = 0.65,
				parent = var_23_3.c.n_item2
			})
		else
			if_set_visible(var_23_3, "n_item2", false)
		end
		
		var_23_2:addChild(var_23_3)
	end
end

function SubTask.onEnterListMode(arg_25_0)
	local var_25_0 = arg_25_0.vars.wnd.c.LEFT
	local var_25_1 = arg_25_0.vars.wnd.c.CENTER
	local var_25_2 = arg_25_0.vars.wnd.c.RIGHT
	
	if not arg_25_0.vars.center_created then
		SubTaskList:show(var_25_1)
		
		arg_25_0.vars.center_created = true
	else
		SubTaskList:refresh()
	end
	
	if not arg_25_0.vars.right_created then
		SubTaskRight:show(var_25_2, arg_25_0.vars.category_list)
		
		arg_25_0.vars.right_created = true
	end
	
	var_25_2:setPositionX(500)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(250, 0 - VIEW_BASE_LEFT + NotchStatus:getNotchSafeRight()))), var_25_2, "block")
	var_25_1:setPositionY(-650)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(250, 0, 0))), var_25_1, "block")
	var_25_0:setPositionX(-400)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(250, NotchStatus:getNotchBaseLeft()))), var_25_0, "block")
	SanctuaryMain:showUpgradeBar(true)
end

function SubTask.onLeaveListMode(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0.vars.wnd.c.LEFT
	local var_26_1 = arg_26_0.vars.wnd.c.CENTER
	local var_26_2 = arg_26_0.vars.wnd.c.RIGHT
	
	UIAction:Add(SEQ(RLOG(MOVE_TO(250, -400 + VIEW_BASE_LEFT)), SHOW(false)), var_26_0, "block")
	UIAction:Add(SEQ(RLOG(MOVE_TO(250, 500 - VIEW_BASE_LEFT)), SHOW(false)), var_26_2, "block")
	UIAction:Add(SEQ(RLOG(MOVE_TO(250, 0, -650)), SHOW(false)), var_26_1, "block")
end

function SubTask.onEnterReadyMode(arg_27_0, arg_27_1)
	arg_27_0.vars.ready_heroes = {}
	arg_27_0.vars.ready_mission_data = Account:getSubtaskMission(arg_27_1)
	arg_27_0.vars.subtask = arg_27_1
	
	local var_27_0 = SubTask:getSubtaskMissionDB(arg_27_0.vars.subtask)
	
	arg_27_0.vars.ready_st_db = var_27_0
	
	local var_27_1 = arg_27_0.vars.wnd.c.n_ready
	local var_27_2 = load_dlg("subtask_v2_ready", true, "wnd")
	
	var_27_1:addChild(var_27_2)
	var_27_1:setOpacity(0)
	UIAction:Add(SEQ(SHOW(true), FADE_IN(200)), var_27_1, "block")
	var_27_2.c.LEFT:setOpacity(0)
	UIAction:Add(SEQ(DELAY(100), SLIDE_IN(200)), var_27_2.c.LEFT, "block")
	arg_27_0:showHeroBelt(arg_27_0.vars.wnd.c.n_ready_herobelt)
	
	local var_27_3 = var_27_2.c.LEFT
	
	arg_27_0:updateConcurrent(var_27_3)
	
	local var_27_4 = var_27_2.c.CENTER
	local var_27_5 = var_27_4.c.n_title
	
	if_set(var_27_5, "txt_category_type", T(arg_27_0:getCategoryListByID(var_27_0.category).name))
	if_set(var_27_5, "txt_title", T(var_27_0.num) .. " " .. T(var_27_0.name))
	if_set(var_27_5, "txt_lv", T("subtask_need_lv", {
		level = var_27_0.req_level
	}))
	UIUtil:setLevel(var_27_4.c.n_lv, var_27_0.req_level, nil, 2)
	
	local var_27_6 = var_27_4.c.n_condition
	
	if var_27_0.condition1 then
		local var_27_7 = var_27_6.c.n_condition1
		local var_27_8 = DB("subtask_mission_condition", var_27_0.condition1, {
			"name"
		})
		
		if_set(var_27_7, "txt_name", T(var_27_8))
		if_set_sprite(var_27_7, "icon", "emblem/" .. var_27_0.condition1 .. ".png")
		if_set_visible(var_27_6, "n_condition1", true)
		
		for iter_27_0 = 1, 4 do
			if_set_visible(var_27_7, "img_skill" .. iter_27_0, false)
		end
		
		WidgetUtils:setupTooltip({
			delay = 0,
			control = var_27_7.c.btn_cond_tooltip1,
			creator = function()
				return UIUtil:getSubtaskConditionTooltip({
					condition = var_27_0.condition1
				})
			end
		})
	else
		if_set_visible(var_27_6, "n_condition1", false)
	end
	
	if var_27_0.condition2 then
		local var_27_9 = var_27_6.c.n_condition2
		local var_27_10 = DB("subtask_mission_condition", var_27_0.condition2, {
			"name"
		})
		
		if_set(var_27_9, "txt_name", T(var_27_10))
		if_set_sprite(var_27_9, "icon", "emblem/" .. var_27_0.condition2 .. ".png")
		if_set_visible(var_27_6, "n_condition2", true)
		
		for iter_27_1 = 1, 4 do
			if_set_visible(var_27_9, "img_skill" .. iter_27_1, false)
		end
		
		WidgetUtils:setupTooltip({
			delay = 0,
			control = var_27_9.c.btn_cond_tooltip2,
			creator = function()
				return UIUtil:getSubtaskConditionTooltip({
					condition = var_27_0.condition2
				})
			end
		})
	else
		if_set_visible(var_27_6, "n_condition2", false)
	end
	
	local var_27_11 = var_27_4.c.n_reward
	local var_27_12 = var_27_11.c.n_reward1
	local var_27_13 = var_27_11.c.n_reward2
	
	if_set_visible(var_27_12, "txt_bonus", false)
	if_set_visible(var_27_13, "txt_bonus", false)
	if_set_visible(var_27_11, "txt_time_bonus", false)
	if_set_visible(var_27_11, "btn_start", true)
	if_set_visible(var_27_11, "btn_cancel", false)
	if_set(var_27_11, "txt_time", sec_to_full_string(var_27_0.time * 60))
	
	if var_27_0.reward1 then
		UIUtil:getRewardIcon(var_27_0.reward_count1, var_27_0.reward1, {
			scale = 1,
			parent = var_27_12
		})
	end
	
	if var_27_0.reward2 then
		UIUtil:getRewardIcon(var_27_0.reward_count2, var_27_0.reward2, {
			scale = 1,
			parent = var_27_13
		})
	end
	
	local var_27_14, var_27_15 = DB("character", var_27_0.npc, {
		"face_id",
		"name"
	})
	
	var_27_14 = var_27_14 or "c1007"
	
	if var_27_14 then
		if_set(var_27_2, "txt_npc_name", T(var_27_15))
		
		local var_27_16 = var_27_2.c.n_portrait
		local var_27_17 = UIUtil:getPortraitAni(var_27_14, {
			pin_sprite_position_y = true
		})
		
		if var_27_17 then
			var_27_17:setScale(var_27_14 == "npc1034" and 0.65 or 0.7)
			var_27_17:setAnchorPoint(0.5, 0)
			var_27_16:removeAllChildren()
			var_27_16:addChild(var_27_17)
		end
		
		local var_27_18, var_27_19 = var_27_16:getPosition()
		
		if var_27_14 == "npc1034" then
			local var_27_20 = var_27_19 - 30
			
			var_27_16:setPosition(var_27_18, var_27_20)
		end
		
		local var_27_21 = arg_27_0.vars.wnd.c.n_balloon
		local var_27_22 = arg_27_0.vars.wnd.c.ballon
		local var_27_23 = arg_27_0.vars.wnd.c.txt_script
		
		if var_27_23.getTextBoxSize then
			var_27_23:setString(T(var_27_0.script))
			
			local var_27_24 = 62
			local var_27_25 = 38
			local var_27_26 = var_27_24 + 3
			
			var_27_22:setContentSize(var_27_23:getTextBoxSize().width, var_27_23:getTextBoxSize().height + var_27_24)
			var_27_23:setPositionX(var_27_22:getContentSize().width * 0.5)
			var_27_23:setPositionY((var_27_22:getContentSize().height - var_27_24 - var_27_25) * 0.5 + var_27_26)
		end
		
		var_27_21:setScale(0)
		var_27_23:setString("")
		UIAction:Add(SEQ(DELAY(180), LOG(SCALE(150, 0, 1.1)), DELAY(50), RLOG(SCALE(80, 1.1, 1))), var_27_21)
		UIAction:Add(SEQ(DELAY(500), TEXT(T(var_27_0.script))), var_27_23)
	end
	
	if arg_27_0.vars.ready_mission_data then
		if_set_visible(var_27_11, "btn_start", false)
		if_set_visible(var_27_11, "btn_cancel", true)
		
		local var_27_27 = arg_27_0.vars.ready_mission_data
		
		for iter_27_2 = 1, 4 do
			arg_27_0.vars.ready_heroes[iter_27_2] = Account:getUnit(var_27_27.units[iter_27_2])
		end
		
		local var_27_28 = os.time()
		
		if var_27_28 < var_27_27.end_time then
			if_set(var_27_11, "txt_time", sec_to_full_string(var_27_27.end_time - var_27_28))
		else
			if_set(var_27_11, "txt_time", T("complete_text"))
		end
		
		arg_27_0:setHero()
	else
		local var_27_29 = var_27_11.c.btn_start.c.n_cost
		local var_27_30, var_27_31 = DB("item_token", var_27_0.use_token_type, {
			"type",
			"icon"
		})
		
		if_set_sprite(var_27_29, "icon_res", var_27_31 .. ".png")
		if_set(var_27_29, "cost", var_27_0.use_token_count .. "/" .. Account:getCurrency(var_27_30))
	end
	
	SanctuaryMain:showUpgradeBar(false)
	TutorialGuide:procGuide("system_069")
end

function SubTask.updateReadyButton(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0 = SubTask:getSubtaskMissionDB(arg_30_0.vars.subtask)
	local var_30_1 = arg_30_0.vars.wnd.c.n_ready
	
	if not get_cocos_refid(var_30_1) then
		return 
	end
	
	local var_30_2 = var_30_1.c.CENTER
	
	if not get_cocos_refid(var_30_2) then
		return 
	end
	
	local var_30_3 = var_30_2.c.n_reward
	
	if not get_cocos_refid(var_30_3) then
		return 
	end
	
	local var_30_4 = var_30_3.c.btn_start
	
	if not get_cocos_refid(var_30_4) then
		return 
	end
	
	local var_30_5 = var_30_4.c.n_cost
	
	if not get_cocos_refid(var_30_5) then
		return 
	end
	
	local var_30_6, var_30_7 = DB("item_token", var_30_0.use_token_type, {
		"type",
		"icon"
	})
	
	if_set_sprite(var_30_5, "icon_res", var_30_7 .. ".png")
	if_set(var_30_5, "cost", var_30_0.use_token_count .. "/" .. Account:getCurrency(var_30_6))
end

function SubTask.onLeaveReadyMode(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_2 and arg_31_2.cancel_all_hero and arg_31_0.vars.ready_heroes then
		for iter_31_0, iter_31_1 in pairs(arg_31_0.vars.ready_heroes) do
			HeroBelt:revertPoppedItem(iter_31_1)
		end
	end
	
	local var_31_0 = arg_31_0.vars.wnd:getChildByName("n_ready")
	
	if get_cocos_refid(var_31_0) then
		UIAction:Add(SEQ(FADE_OUT(300), CALL(function()
			var_31_0:removeChildByName("subtask_v2_ready")
		end)), var_31_0, "block")
	end
	
	if arg_31_0.vars.unit_dock:getWindow() then
		UIAction:Add(SEQ(RLOG(MOVE_TO(200, 1040), 100), SHOW(false)), arg_31_0.vars.unit_dock:getWindow(), "block")
	end
end

function SubTask.listSelectedRight(arg_33_0, arg_33_1)
	SubTaskList:refresh(arg_33_1)
end

function SubTask.getSubtaskSkillDB(arg_34_0, arg_34_1)
	local var_34_0, var_34_1, var_34_2, var_34_3, var_34_4, var_34_5, var_34_6, var_34_7, var_34_8 = DB("subtask_mission_skill", arg_34_1, {
		"id",
		"name",
		"effect_type",
		"effect_value",
		"relate_type",
		"relate_type_detail",
		"desc",
		"skill_detail",
		"icon"
	})
	
	return {
		id = var_34_0,
		name = var_34_1,
		effect_type = var_34_2,
		effect_value = var_34_3,
		relate_type = var_34_4,
		relate_type_detail = var_34_5,
		desc = var_34_6,
		skill_detail = var_34_7,
		icon = var_34_8
	}
end

function SubTask.getSubtaskMissionDB(arg_35_0, arg_35_1)
	local var_35_0, var_35_1, var_35_2, var_35_3, var_35_4, var_35_5, var_35_6, var_35_7, var_35_8, var_35_9, var_35_10, var_35_11, var_35_12, var_35_13, var_35_14, var_35_15, var_35_16, var_35_17, var_35_18, var_35_19, var_35_20 = DB("subtask_mission", arg_35_1, {
		"id",
		"name",
		"category",
		"type",
		"faction",
		"faction_level",
		"time",
		"condition1",
		"condition2",
		"req_level",
		"npc",
		"script",
		"reward1",
		"reward_count1",
		"reward2",
		"reward_count2",
		"unlock_condition1",
		"unlock_condition2",
		"num",
		"use_token_type",
		"use_token_count"
	})
	
	if var_35_1 == nil then
		return nil
	end
	
	return {
		id = var_35_0,
		name = var_35_1,
		category = var_35_2,
		type = var_35_3,
		faction = var_35_4,
		faction_level = var_35_5,
		time = var_35_6,
		condition1 = var_35_7,
		condition2 = var_35_8,
		req_level = var_35_9,
		npc = var_35_10,
		script = var_35_11,
		reward1 = var_35_12,
		reward_count1 = var_35_13,
		reward2 = var_35_14,
		reward_count2 = var_35_15,
		unlock_condition1 = var_35_16,
		unlock_condition2 = var_35_17,
		num = var_35_18,
		use_token_type = var_35_19,
		use_token_count = var_35_20
	}
end

function SubTask.checkResetAutoCancelMissions(arg_36_0, arg_36_1)
	local var_36_0 = DB("sanctuary_upgrade", "subtask_" .. arg_36_1 .. "_0", "level_min")
	local var_36_1 = {}
	
	for iter_36_0, iter_36_1 in pairs(AccountData.subtask) do
		local var_36_2 = SubTask:getSubtaskMissionDB(iter_36_0)
		
		for iter_36_2 = 1, 2 do
			local var_36_3 = var_36_2["unlock_condition" .. iter_36_2]
			
			if var_36_3 then
				local var_36_4, var_36_5 = SubTaskList:parseUnlockCondition(var_36_3)
				
				if var_36_4 == arg_36_1 and var_36_0 < var_36_5 then
					table.push(var_36_1, T(var_36_2.num))
				end
			end
		end
	end
	
	return var_36_1
end

function SubTask.getEffectUnitPoint(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0:getSubtaskMissionDB(arg_37_1)
	local var_37_1 = arg_37_0:affectUnitSkill(var_37_0, arg_37_2)
	
	if not var_37_1 then
		return 0
	end
	
	local var_37_2 = 0
	
	if var_37_1.effect_type == "reward_bonus" then
		var_37_2 = var_37_2 + var_37_1.effect_value * 100 * 3
	elseif var_37_1.effect_type == "time_reduce" then
		var_37_2 = var_37_2 + var_37_1.effect_value * 100 * 2
	else
		var_37_2 = var_37_2 + var_37_1.effect_value * 100
	end
	
	return var_37_2
end

local function var_0_0(arg_38_0, arg_38_1)
	if string.starts(arg_38_0, "to_") then
		return string.split(arg_38_0, "_")[2] == arg_38_1
	else
		return arg_38_0 == arg_38_1
	end
end

local function var_0_1(arg_39_0, arg_39_1)
	if arg_39_0.effect_type == "reward_bonus" or arg_39_0.effect_type == "time_reduce" then
		return true
	end
	
	local var_39_0 = string.split(arg_39_0.effect_type, "_")
	
	if var_39_0[2] == "bonus" and (var_0_0(arg_39_1.reward1, var_39_0[1]) or var_0_0(arg_39_1.reward2, var_39_0[1])) then
		return true
	end
	
	return false
end

function SubTask.affectUnitSkill(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_2:getSubTaskMissionSkill()
	
	if not var_40_0 or not var_40_0.relate_type or not var_40_0.effect_type then
		return nil
	end
	
	if not var_0_1(var_40_0, arg_40_1) then
		return nil
	end
	
	local var_40_1 = false
	local var_40_2
	local var_40_3
	
	if var_40_0.relate_type == "all" then
		var_40_1 = true
	elseif var_40_0.relate_type_detail then
		local var_40_4 = string.split(var_40_0.relate_type_detail, ";")
		
		for iter_40_0, iter_40_1 in pairs(var_40_4) do
			if arg_40_1[var_40_0.relate_type] == iter_40_1 then
				var_40_1 = true
			elseif arg_40_1.condition1 == iter_40_1 then
				var_40_2 = iter_40_1
				var_40_1 = true
			elseif arg_40_1.condition2 == iter_40_1 then
				var_40_3 = iter_40_1
				var_40_1 = true
			end
		end
	end
	
	if var_40_1 then
		return {
			effect_type = var_40_0.effect_type,
			effect_value = var_40_0.effect_value,
			relate_type = var_40_0.relate_type,
			condition1 = var_40_2,
			condition2 = var_40_3,
			unit_uid = arg_40_2.inst.uid
		}
	else
		return nil
	end
end

function SubTask.onHeroListEventForSubtask(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_1 == "select" and arg_41_3 == true then
		arg_41_0:setHero(arg_41_2)
	end
end

function SubTask.cancelHero(arg_42_0, arg_42_1)
	if arg_42_0.vars.ready_mission_data then
		return 
	end
	
	if arg_42_0.vars.ready_heroes[arg_42_1] == nil then
		return 
	end
	
	HeroBelt:revertPoppedItem(arg_42_0.vars.ready_heroes[arg_42_1])
	table.remove(arg_42_0.vars.ready_heroes, arg_42_1)
	arg_42_0:setHero()
end

function SubTask.setHero(arg_43_0, arg_43_1)
	if arg_43_1 then
		if arg_43_1:isDoingSubTask() then
			return 
		end
		
		if arg_43_0.vars.ready_mission_data then
			return 
		end
		
		for iter_43_0 = 1, 4 do
			if arg_43_0.vars.ready_heroes[iter_43_0] and arg_43_0.vars.ready_heroes[iter_43_0]:isSameVariationGroupOnlyPlayer(arg_43_1) then
				balloon_message_with_sound("subtask_same_hero")
				
				return 
			end
		end
		
		local var_43_0 = 0
		
		for iter_43_1 = 1, 4 do
			if arg_43_0.vars.ready_heroes[iter_43_1] == nil then
				var_43_0 = iter_43_1
				
				break
			end
		end
		
		if var_43_0 == 0 then
			return 
		end
		
		arg_43_0.vars.ready_heroes[var_43_0] = arg_43_1
		
		HeroBelt:popItem(arg_43_1)
	end
	
	local var_43_1 = arg_43_0:getSubtaskMissionDB(arg_43_0.vars.subtask)
	local var_43_2 = arg_43_0.vars.wnd.c.n_ready.c.CENTER
	local var_43_3 = var_43_2.c.n_slots
	local var_43_4 = var_43_2.c.n_condition
	local var_43_5 = var_43_4.c.n_condition1
	local var_43_6 = var_43_5.c.n_icons
	local var_43_7 = var_43_4.c.n_condition2
	local var_43_8 = var_43_7.c.n_icons
	local var_43_9 = var_43_2.c.n_reward
	local var_43_10 = var_43_9.c.n_reward1
	local var_43_11 = var_43_9.c.n_reward2
	
	if_set_visible(var_43_10, "txt_bonus", false)
	if_set_visible(var_43_11, "txt_bonus", false)
	if_set_visible(var_43_9, "txt_time_bonus", false)
	
	for iter_43_2 = 1, 4 do
		if_set_visible(var_43_5, "img_skill" .. iter_43_2, false)
		if_set_visible(var_43_7, "img_skill" .. iter_43_2, false)
	end
	
	local var_43_12 = 0
	local var_43_13 = 0
	local var_43_14 = 0
	local var_43_15 = 0
	local var_43_16 = 0
	
	for iter_43_3 = 1, 4 do
		local var_43_17 = var_43_3:getChildByName("bg" .. iter_43_3)
		
		var_43_17:removeChildByName("unit_bar")
		
		if arg_43_0.vars.ready_heroes[iter_43_3] then
			local var_43_18 = arg_43_0.vars.ready_heroes[iter_43_3]
			local var_43_19 = UIUtil:updateUnitBar("SubTask", var_43_18)
			
			if_set_visible(var_43_19, "n_tasking", false)
			if_set_visible(var_43_19, "n_info", var_43_18:getSubTaskSkillName() ~= nil)
			if_set_visible(var_43_19, "team", false)
			UIUtil:setLevel(var_43_19.c.n_subtask_skill.c.n_lv, var_43_18:getLv(), var_43_18:getMaxLevel(), 4)
			var_43_19:setPosition(-3, 13)
			if_set_visible(var_43_19, "n_subtask_skill", true)
			var_43_17:addChild(var_43_19)
			
			local var_43_20 = arg_43_0:affectUnitSkill(var_43_1, var_43_18)
			
			if var_43_20 and var_43_20.relate_type == "condition" then
				if arg_43_1 and arg_43_1 == var_43_18 then
					local var_43_21 = CACHE:getEffect("ui_dis_check.cfx")
					
					var_43_21:start()
					var_43_19.c.n_effect_check:addChild(var_43_21)
					if_set_visible(var_43_19, "icon_checked", false)
				else
					if_set_visible(var_43_19, "icon_checked", true)
				end
				
				if var_43_20.condition1 then
					local var_43_22 = var_43_18:getSubTaskMissionSkill()
					
					var_43_12 = var_43_12 + 1
					
					if_set_visible(var_43_5, "img_skill" .. var_43_12, true)
					
					local var_43_23 = var_43_5:getChildByName("img_skill" .. var_43_12)
					
					if arg_43_1 and arg_43_1 == var_43_18 then
						local var_43_24 = CACHE:getEffect("ui_dis_check.cfx")
						
						var_43_24:start()
						
						local var_43_25 = var_43_23:getChildByName("n_effect_check")
						
						if get_cocos_refid(var_43_25) then
							var_43_25:addChild(var_43_24)
						end
						
						if_set_visible(var_43_23, "icon_checked", false)
					else
						if_set_visible(var_43_23, "icon_checked", true)
					end
					
					if_set_sprite(var_43_5, "img_skill" .. var_43_12, "skill/" .. var_43_22.icon)
					var_43_6:setPositionX((var_43_12 - 1) * -30)
					
					if var_43_23._TOUCH_LISTENER then
						var_43_23._TOUCH_LISTENER = nil
					end
					
					WidgetUtils:setupTooltip({
						delay = 0,
						control = var_43_23,
						creator = function()
							return UIUtil:getSubtaskSkillTooltip(var_43_18)
						end
					})
				elseif var_43_20.condition2 then
					local var_43_26 = var_43_18:getSubTaskMissionSkill()
					
					var_43_13 = var_43_13 + 1
					
					if_set_visible(var_43_7, "img_skill" .. var_43_13, true)
					
					local var_43_27 = var_43_7:getChildByName("img_skill" .. var_43_13)
					
					if arg_43_1 and arg_43_1 == var_43_18 then
						local var_43_28 = CACHE:getEffect("ui_dis_check.cfx")
						
						var_43_28:start()
						
						local var_43_29 = var_43_27:getChildByName("n_effect_check")
						
						if get_cocos_refid(var_43_29) then
							var_43_29:addChild(var_43_28)
						end
						
						if_set_visible(var_43_27, "icon_checked", false)
					else
						if_set_visible(var_43_27, "icon_checked", true)
					end
					
					if_set_sprite(var_43_7, "img_skill" .. var_43_13, "skill/" .. var_43_26.icon)
					var_43_8:setPositionX((var_43_13 - 1) * -30)
					
					if var_43_27._TOUCH_LISTENER then
						var_43_27._TOUCH_LISTENER = nil
					end
					
					WidgetUtils:setupTooltip({
						delay = 0,
						control = var_43_27,
						creator = function()
							return UIUtil:getSubtaskSkillTooltip(var_43_18)
						end
					})
				end
			end
			
			if var_43_20 then
				if var_43_20.effect_type == "reward_bonus" and var_43_20.effect_value and var_43_20.effect_value > 0 then
					var_43_14 = var_43_14 + var_43_20.effect_value * 100
					var_43_15 = var_43_15 + var_43_20.effect_value * 100
				elseif var_43_20.effect_type == "time_reduce" and var_43_20.effect_value and var_43_20.effect_value > 0 then
					var_43_16 = var_43_16 + var_43_20.effect_value * 100
				else
					local var_43_30 = string.split(var_43_20.effect_type, "_")
					
					if var_43_30[2] == "bonus" then
						if var_0_0(var_43_1.reward1, var_43_30[1]) then
							var_43_14 = var_43_14 + var_43_20.effect_value * 100
						elseif var_0_0(var_43_1.reward2, var_43_30[1]) then
							var_43_15 = var_43_15 + var_43_20.effect_value * 100
						end
					end
				end
				
				if var_43_14 > 0 then
					if_set_visible(var_43_10, "txt_bonus", true)
					if_set(var_43_10, "txt_bonus", "+" .. var_43_14 .. "%")
				end
				
				if var_43_15 > 0 then
					if_set_visible(var_43_11, "txt_bonus", true)
					if_set(var_43_11, "txt_bonus", "+" .. var_43_15 .. "%")
				end
				
				if var_43_16 > 0 then
					if_set_visible(var_43_9, "txt_time_bonus", true)
					
					local var_43_31 = var_43_9.c.txt_time
					
					var_43_9.c.txt_time_bonus:setPositionX(var_43_31:getContentSize().width + 5)
					if_set(var_43_9, "txt_time_bonus", "-" .. var_43_16 .. "%")
				end
			end
		end
	end
end

function SubTask.setPercent(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	arg_46_3 = arg_46_3 or os.time()
	
	local var_46_0 = math.max(0, arg_46_3 - arg_46_2.start_time) / (arg_46_2.end_time - arg_46_2.start_time)
	
	if_set(arg_46_1, "t_percent", string.format("%d%%", math.min(var_46_0, 1) * 100))
	if_set_percent(arg_46_1, "progress_bar", math.min(var_46_0, 1))
	
	local var_46_1 = arg_46_1.c.n_circle_cool
	
	if var_46_1 then
		local var_46_2 = var_46_1.img_cool
		
		if not var_46_2 then
			var_46_2 = WidgetUtils:createCircleProgress("img/cm_cool_hero.png")
			
			var_46_2:setOpacity(150)
			var_46_1:addChild(var_46_2)
			
			var_46_1.img_cool = var_46_2
		end
		
		var_46_2:setPercentage(var_46_0 * 100)
	end
end

function SubTask.autoUpdateList(arg_47_0)
	local var_47_0 = arg_47_0.vars.wnd.c.LEFT
	
	for iter_47_0 = 1, 4 do
		local var_47_1 = var_47_0.c["n_group" .. iter_47_0]
		local var_47_2 = var_47_1.c.group_card
		
		if var_47_2 and var_47_2:getParent() then
			local var_47_3 = Account:getSubtaskMission(var_47_2:getParent().subtask_mission_id)
			local var_47_4 = os.time()
			
			if var_47_3 then
				arg_47_0:setPercent(var_47_1, var_47_3, var_47_4)
				
				if var_47_4 < var_47_3.end_time then
					if_set(var_47_1, "txt_time", sec_to_full_string(var_47_3.end_time - var_47_4))
				else
					if_set(var_47_1, "txt_time", T("complete_text"))
				end
			end
		end
	end
end

function SubTask.autoUpdateReady(arg_48_0)
	if not arg_48_0.vars or not arg_48_0.vars.ready_mission_data then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.ready_mission_data
	
	if not var_48_0 then
		return 
	end
	
	local var_48_1 = arg_48_0.vars.wnd.c.n_ready.c.CENTER.c.n_reward
	local var_48_2 = var_48_1.c.txt_time
	local var_48_3 = var_48_1.c.txt_time_bonus
	local var_48_4 = os.time()
	
	if var_48_4 < var_48_0.end_time then
		if_set(var_48_1, "txt_time", sec_to_full_string(var_48_0.end_time - var_48_4))
		var_48_3:setPositionX(var_48_2:getContentSize().width + 5)
	else
		if_set(var_48_1, "txt_time", T("complete_text"))
	end
end

function SubTask.updateSubtaskInfos(arg_49_0)
	if not arg_49_0.vars.unit_dock then
		return 
	end
	
	for iter_49_0, iter_49_1 in pairs(Account.units) do
		iter_49_1:clearVars()
		HeroBelt:updateUnit(nil, iter_49_1)
	end
end

function SubTask.updateOnLeaveUnitPopupMode(arg_50_0)
	if not arg_50_0.vars or not get_cocos_refid(arg_50_0.vars.wnd) then
		return 
	end
	
	local var_50_0 = arg_50_0.vars.wnd:findChildByName("subtask_v2_ready")
	
	if not get_cocos_refid(var_50_0) then
		return 
	end
	
	arg_50_0:setHero()
	arg_50_0:updateSubtaskInfos()
end

function SubTask.showHeroBelt(arg_51_0, arg_51_1)
	if not arg_51_0.vars.unit_dock then
		arg_51_0.vars.unit_dock = HeroBelt:create("SubTask")
		
		HeroBelt:resetData(Account.units, "SubTask", nil, nil, nil, nil, "SubTask")
		arg_51_0.vars.unit_dock:setEventHandler(arg_51_0.onHeroListEventForSubtask, arg_51_0)
		arg_51_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
		arg_51_0.vars.unit_dock:getWindow():setVisible(true)
		arg_51_0.vars.unit_dock:getWindow():setPositionX(1040)
		arg_51_1:addChild(arg_51_0.vars.unit_dock:getWindow())
	end
	
	HeroBelt:setToggle("hide_max", false)
	HeroBelt:closeToggleSorter()
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, 640), 100)), arg_51_0.vars.unit_dock:getWindow(), "block")
	arg_51_0:updateSubtaskInfos()
	HeroBelt:instant_sort_by_key("SubTask")
end

function SubTask.getConcurrentCount(arg_52_0)
	return table.count(AccountData.subtask or {}), GAME_STATIC_VARIABLE.subtask_count_default or 2
end

function SubTask.updateConcurrent(arg_53_0, arg_53_1)
	arg_53_1 = arg_53_1 or arg_53_0.vars.wnd.c.LEFT
	
	local var_53_0, var_53_1 = arg_53_0:getConcurrentCount()
	
	if_set(arg_53_1, "txt_count", T("subtask_teams", {
		curr = var_53_0,
		max = var_53_1
	}))
end

function SubTask.checkComplete(arg_54_0, arg_54_1)
	if not AccountData.subtask then
		return nil
	end
	
	if BattleReady:isShow() then
		return nil
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return nil
	end
	
	local var_54_0 = SceneManager:getCurrentSceneName()
	
	if var_54_0 ~= "lobby" and var_54_0 ~= "sanctuary" then
		return nil
	end
	
	local var_54_1 = os.time()
	
	for iter_54_0, iter_54_1 in pairs(AccountData.subtask) do
		if var_54_1 >= iter_54_1.end_time then
			if arg_54_1 then
				AccountData.subtask[iter_54_0] = nil
			end
			
			return iter_54_1.id
		end
	end
	
	return nil
end

function SubTask.complete(arg_55_0)
	if arg_55_0.result_vars and get_cocos_refid(arg_55_0.result_vars.result) then
		return false
	end
	
	local var_55_0 = arg_55_0:checkComplete(true)
	
	if var_55_0 then
		query("subtask_complete", {
			mission_id = var_55_0
		})
		
		return true
	end
	
	return false
end

function SubTask.startMission(arg_56_0)
	if not arg_56_0.vars or not arg_56_0.vars.ready_st_db then
		return 
	end
	
	if not arg_56_0.vars.ready_heroes or table.count(arg_56_0.vars.ready_heroes) < 1 then
		balloon_message_with_sound("subtask_hero_required")
		
		return 
	end
	
	local var_56_0, var_56_1 = arg_56_0:getConcurrentCount()
	
	if var_56_1 <= var_56_0 then
		balloon_message_with_sound("subtask_cant_together")
		
		return 
	end
	
	local var_56_2 = 0
	local var_56_3 = {}
	
	for iter_56_0 = 1, 4 do
		local var_56_4 = arg_56_0.vars.ready_heroes[iter_56_0]
		
		if var_56_4 then
			if var_56_4:isDoingSubTask() then
				balloon_message_with_sound("subtask_cant_just")
				
				return 
			end
			
			if var_56_4:getLv() >= arg_56_0.vars.ready_st_db.req_level then
				var_56_2 = var_56_2 + 1
			end
			
			table.push(var_56_3, var_56_4.inst.uid)
		end
	end
	
	if var_56_2 < 1 then
		balloon_message_with_sound("subtask_cant_leader_lv")
		
		return 
	end
	
	if #var_56_3 < 1 then
		balloon_message_with_sound("subtask_hero_required")
		
		return 
	end
	
	local var_56_5 = DB("item_token", arg_56_0.vars.ready_st_db.use_token_type, "type")
	
	if arg_56_0.vars.ready_st_db.use_token_count > Account:getCurrency(var_56_5) then
		UIUtil:wannaBuyStamina("subtask.ready")
		
		return 
	end
	
	query("subtask_start", {
		mission_id = arg_56_0.vars.ready_st_db.id,
		units = json.encode(var_56_3)
	})
end

function SubTask.cancelMission(arg_57_0)
	if not arg_57_0.vars or not arg_57_0.vars.ready_mission_data then
		return 
	end
	
	local var_57_0 = arg_57_0.vars.ready_mission_data
	
	if not var_57_0 then
		return 
	end
	
	Dialog:msgBox(T("subtask_cancle", {
		name = T(arg_57_0.vars.ready_st_db.name)
	}), {
		yesno = true,
		handler = function()
			query("subtask_cancel", {
				mission_id = var_57_0.id
			})
		end
	})
end

function SubTask.updateRetryButton(arg_59_0)
	if not arg_59_0.result_vars or not get_cocos_refid(arg_59_0.result_vars.result) then
		return 
	end
	
	local var_59_0 = arg_59_0:getSubtaskMissionDB(arg_59_0.result_vars.result_data.mission_id)
	local var_59_1 = arg_59_0.result_vars.result.c.btn_retry
	
	if not get_cocos_refid(var_59_1) then
		return 
	end
	
	local var_59_2 = var_59_1.c.n_cost
	local var_59_3, var_59_4 = DB("item_token", var_59_0.use_token_type, {
		"type",
		"icon"
	})
	
	if_set_sprite(var_59_2, "icon_res", var_59_4 .. ".png")
	if_set(var_59_2, "cost", var_59_0.use_token_count .. "/" .. Account:getCurrency(var_59_3))
end

function SubTask.resultUI(arg_60_0, arg_60_1, arg_60_2)
	SanctuaryMain:showUpgradeBar(false)
	
	local var_60_0
	
	if arg_60_0.result_vars and arg_60_0.result_vars.after_use_stamina then
		var_60_0 = arg_60_0.result_vars.after_use_stamina
	end
	
	arg_60_0.result_vars = {}
	
	set_high_fps_tick(1500)
	
	local var_60_1 = {
		[12933368] = {
			212980,
			0.45,
			35
		},
		[12960195] = {
			1384450,
			1,
			60
		},
		[12960217] = {
			371610,
			0.7,
			45
		},
		[12995631] = {
			1384450,
			1,
			60
		}
	}
	
	arg_60_0.result_vars.result_data = arg_60_1 or {
		mission_id = "sanctuary_1",
		test_team = true,
		reward_info = {
			reward1 = {
				to_gold = 5000
			},
			reward1_bonus = {
				to_gold = 1000
			},
			reward2 = {
				to_crystal = 10
			},
			reward2_bonus = {}
		},
		success_level = arg_60_2 or 3,
		team_units = {
			{
				id = 12933368,
				code = "c1049",
				exp = 213980
			},
			{
				id = 12960195,
				code = "c1016",
				exp = 1384450
			},
			{
				id = 12960217,
				code = "c1017",
				exp = 372860
			},
			{
				id = 12995631,
				code = "c1066",
				exp = 1384450
			}
		},
		old_unit_exp = var_60_1
	}
	arg_60_0.result_vars.result = load_dlg("subtask_result", false, "wnd")
	
	local var_60_2 = arg_60_0:getSubtaskMissionDB(arg_60_0.result_vars.result_data.mission_id)
	local var_60_3, var_60_4 = DB("character", var_60_2.npc, {
		"face_id",
		"name"
	})
	
	var_60_3 = var_60_3 or "c1005"
	
	if var_60_3 then
		local var_60_5 = arg_60_0.result_vars.result.c.n_portrait
		local var_60_6 = UIUtil:getPortraitAni(var_60_3, {
			pin_sprite_position_y = true,
			parent_pos_y = var_60_5:getPositionY()
		})
		
		if var_60_6 then
			var_60_6:setScale(var_60_3 == "npc1034" and 0.68 or 0.8)
			var_60_6:setAnchorPoint(0.5, 0)
			var_60_5:removeAllChildren()
			var_60_5:addChild(var_60_6)
		end
	end
	
	local var_60_7 = arg_60_0.result_vars.result.c.btn_retry.c.n_cost
	local var_60_8, var_60_9 = DB("item_token", var_60_2.use_token_type, {
		"type",
		"icon"
	})
	
	if_set_sprite(var_60_7, "icon_res", var_60_9 .. ".png")
	
	var_60_0 = var_60_0 or Account:getCurrency(var_60_8)
	
	if_set(var_60_7, "cost", var_60_2.use_token_count .. "/" .. var_60_0)
	if_set(arg_60_0.result_vars.result, "txt_desc", T(var_60_2.num) .. " " .. T(var_60_2.name))
	if_set(arg_60_0.result_vars.result, "txt_title", T("subtask_mission_accomplished_title"))
	
	arg_60_0.result_vars.result_data.success_level = arg_60_0.result_vars.result_data.success_level or 1
	
	if arg_60_0.result_vars.result_data.success_level == 3 then
		if_set(arg_60_0.result_vars.result, "txt_reward_title", T("subtask_mission_accomplished_perfect"))
	elseif arg_60_0.result_vars.result_data.success_level == 2 then
		if_set(arg_60_0.result_vars.result, "txt_reward_title", T("subtask_mission_accomplished_great"))
	else
		if_set(arg_60_0.result_vars.result, "txt_reward_title", T("subtask_mission_accomplished_good"))
	end
	
	for iter_60_0, iter_60_1 in pairs(arg_60_0.result_vars.result_data.reward_info.reward1) do
		UIUtil:getRewardIcon(iter_60_1, iter_60_0, {
			show_small_count = true,
			show_name = true,
			scale = 0.8,
			detail = true,
			parent = arg_60_0.result_vars.result.c.n_res1,
			count = iter_60_1,
			bonus_count = arg_60_0.result_vars.result_data.reward_info.reward1_bonus[iter_60_0]
		})
		
		break
	end
	
	for iter_60_2, iter_60_3 in pairs(arg_60_0.result_vars.result_data.reward_info.reward2) do
		UIUtil:getRewardIcon(iter_60_3, iter_60_2, {
			show_small_count = true,
			show_name = true,
			scale = 0.8,
			detail = true,
			parent = arg_60_0.result_vars.result.c.n_res2,
			count = iter_60_3,
			bonus_count = arg_60_0.result_vars.result_data.reward_info.reward2_bonus[iter_60_2]
		})
		
		break
	end
	
	if_set_visible(arg_60_0.result_vars.result, "window_frame", false)
	
	if arg_60_0.result_vars.result_data.success_level == 2 then
		arg_60_0.result_vars.result_effect = CACHE:getEffect("ui_dispatch_great.cfx")
		
		SoundEngine:play("event:/effect/ui_dispatch_great")
	elseif arg_60_0.result_vars.result_data.success_level == 3 then
		arg_60_0.result_vars.result_effect = CACHE:getEffect("ui_dispatch_perfect.cfx")
		
		SoundEngine:play("event:/effect/ui_dispatch_perfect")
	else
		arg_60_0.result_vars.result_effect = CACHE:getEffect("ui_dispatch_good.cfx")
		
		SoundEngine:play("event:/effect/ui_dispatch_good")
	end
	
	arg_60_0.result_vars.result_effect:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	arg_60_0.result_vars.result_effect:start()
	arg_60_0.result_vars.result:addChild(arg_60_0.result_vars.result_effect, 9999999)
	
	if SceneManager:getCurrentSceneName() == "sanctuary" then
		SanctuaryMain.vars.wnd:addChild(arg_60_0.result_vars.result, 9999998)
		arg_60_0.result_vars.result:bringToFront()
	elseif SceneManager:getCurrentSceneName() == "lobby" then
		if SceneManager:getRunningUIRootScene():getOpacity() == 0 then
			if Lobby.vars.noti_layer then
				Lobby.vars.noti_layer:addChild(arg_60_0.result_vars.result, 9999998)
			end
		else
			SceneManager:getRunningPopupScene():addChild(arg_60_0.result_vars.result)
			arg_60_0.result_vars.result:bringToFront()
		end
	end
	
	Action:Add(SEQ(DELAY(4500), CALL(SubTask.resultUI2, arg_60_0)), arg_60_0.result_vars.result, "subtask_result_next")
end

function SubTask.skipResultUI(arg_61_0)
	if Action:Find("subtask_result") then
		return 
	end
	
	if not Action:Find("subtask_result_next") then
		return 
	end
	
	if not get_cocos_refid(arg_61_0.result_vars.result) then
		return 
	end
	
	Action:Remove("subtask_result_next")
	arg_61_0.result_vars.result_effect:stop()
	arg_61_0:resultUI2()
	arg_61_0.result_vars.result:removeChild(arg_61_0.result_vars.result_effect)
end

function SubTask.closeResultUI(arg_62_0, arg_62_1)
	if not arg_62_0.result_vars then
		return 
	end
	
	if not get_cocos_refid(arg_62_0.result_vars.result) then
		arg_62_0.result_vars = nil
		
		return 
	end
	
	SanctuaryMain:showUpgradeBar(true)
	arg_62_0.result_vars.result:removeChild(arg_62_0.result_vars.result_effect)
	arg_62_0.result_vars.result:removeFromParent()
	
	if (not arg_62_0:complete() or arg_62_1) and arg_62_0.result_vars then
		arg_62_0.result_vars = nil
		
		if SceneManager:getCurrentSceneName() == "lobby" then
			Lobby:nextNoti()
			TopBarNew:updateAchieveButton()
		end
	end
end

function SubTask.resetHeroBelt(arg_63_0)
	HeroBelt:revertPoppedItem()
end

function SubTask.retryLast(arg_64_0)
	local var_64_0 = arg_64_0.result_vars.result_data.mission_id
	local var_64_1 = SubTask:getSubtaskMissionDB(var_64_0)
	local var_64_2 = DB("item_token", var_64_1.use_token_type, "type")
	
	if var_64_1.use_token_count > Account:getCurrency(var_64_2) then
		UIUtil:wannaBuyStamina("subtask.retry")
		
		return 
	end
	
	local var_64_3 = {}
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0.result_vars.result_data.team_units) do
		table.push(var_64_3, iter_64_1.id)
	end
	
	local var_64_4 = {}
	
	for iter_64_2, iter_64_3 in pairs(var_64_3) do
		local var_64_5 = Account:getUnit(iter_64_3)
		
		if var_64_5 then
			for iter_64_4, iter_64_5 in pairs(var_64_4) do
				if var_64_5:isSameVariationGroupOnlyPlayer(iter_64_5) then
					balloon_message_with_sound("subtask_same_hero")
					
					return 
				end
			end
			
			table.insert(var_64_4, var_64_5)
		end
	end
	
	arg_64_0:closeResultUI()
	
	if var_64_0 and #var_64_3 > 0 then
		if arg_64_0.result_vars then
			arg_64_0.result_vars.after_use_stamina = Account:getCurrency(var_64_2) - var_64_1.use_token_count
		end
		
		query("subtask_start", {
			mission_id = var_64_0,
			units = json.encode(var_64_3)
		})
	end
end

function SubTask.resultUI2(arg_65_0)
	if not get_cocos_refid(arg_65_0.result_vars.result_effect) then
		return 
	end
	
	arg_65_0.result_vars.result_effect:stop()
	
	if arg_65_0.result_vars.result_data.team_units then
		if_set_visible(arg_65_0.result_vars.result, "n_exp", true)
		
		local var_65_0 = arg_65_0.result_vars.result.c.n_exp
		
		for iter_65_0 = 1, 4 do
			if not arg_65_0.result_vars.result_data.team_units[iter_65_0] then
				var_65_0.c["hero" .. iter_65_0]:setVisible(false)
			else
				local var_65_1 = Account:getUnit(arg_65_0.result_vars.result_data.team_units[iter_65_0].id)
				
				if arg_65_0.result_vars.result_data.test_team then
					var_65_1 = Account:getTeam(1)[iter_65_0]
				end
				
				local var_65_2 = var_65_0.c["hero" .. iter_65_0]
				
				if var_65_1 then
					local var_65_3 = arg_65_0.result_vars.result_data.old_unit_exp[var_65_1.inst.uid]
					
					if var_65_3 then
						local var_65_4 = var_65_1:getEXP() - var_65_3[1]
						
						if var_65_4 > 0 then
							if_set(var_65_2, "txt_exp", "exp +" .. comma_value(var_65_4))
							if_set_visible(var_65_2, "txt_exp", true)
						else
							if_set_visible(var_65_2, "txt_exp", false)
						end
						
						UIUtil:playGetExpEffect(var_65_2, var_65_1, var_65_3[2], nil, var_65_3[3] < var_65_1:getLv(), {
							delay = 100,
							no_new_exp_progress_block = true
						})
					else
						UIUtil:playGetExpEffect(var_65_2, var_65_1, var_65_1:getEXPRatio(), nil, false, {
							delay = 100,
							no_new_exp_progress_block = true
						})
						if_set_visible(var_65_2, "txt_exp", false)
					end
					
					local var_65_5 = var_65_2:getChildByName("txt_name")
					local var_65_6 = get_word_wrapped_name(var_65_5, var_65_1:getName())
					
					if_set(var_65_2, "txt_name", var_65_6)
					UIUtil:setLevelDetail(var_65_2.c.n_lv, var_65_1:getLv(), var_65_1:getMaxLevel(), {
						hide_ml_when_max_level = true
					})
					UIUtil:getRewardIcon("c", var_65_1:getDisplayCode(), {
						no_db_grade = true,
						name = false,
						scale = 1.3,
						no_popup = true,
						parent = var_65_2.c.n_face,
						grade = var_65_1:getGrade(),
						zodiac = var_65_1:getZodiacGrade(),
						awake = var_65_1:getAwakeGrade()
					})
					var_65_2:setVisible(true)
				else
					var_65_2:setVisible(false)
				end
			end
		end
	else
		if_set_visible(arg_65_0.result_vars.result, "n_exp", false)
	end
	
	arg_65_0.result_vars.result.c.window_frame:setVisible(true)
end

function SubTask.resultEffect(arg_66_0)
	arg_66_0.result_vars.eff_result = CACHE:getEffect("ui_dispatch_good.cfx")
	
	arg_66_0.result_vars.eff_result:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	arg_66_0.result_vars.eff_result:start()
	arg_66_0.result_vars.result:addChild(arg_66_0.result_vars.eff_result, 99999)
end

SubTaskList = {}

copy_functions(ScrollView, SubTaskList)

function SubTaskList.show(arg_67_0, arg_67_1)
	arg_67_0.vars = {}
	arg_67_0.vars.parent = arg_67_1
	arg_67_0.vars.scrollview = arg_67_1.c.scrollview_subtasks
	
	arg_67_0:initScrollView(arg_67_0.vars.scrollview, 696, 117, {
		fit_height = true
	})
end

function SubTaskList.parseUnlockCondition(arg_68_0, arg_68_1)
	if not arg_68_1 then
		return nil, nil
	end
	
	local var_68_0 = string.split(arg_68_1, "_")
	
	if #var_68_0 == 3 and var_68_0[1] == "subtask" then
		return tonumber(var_68_0[2]), tonumber(var_68_0[3])
	end
	
	return nil, nil
end

function SubTaskList.isLocked(arg_69_0, arg_69_1, arg_69_2)
	arg_69_2 = arg_69_2 or SanctuaryMain:GetLevels("SubTask")
	
	local var_69_0 = {
		0,
		0,
		0
	}
	local var_69_1 = 0
	local var_69_2, var_69_3 = arg_69_0:parseUnlockCondition(SubTask:getCategoryListByID(arg_69_1.category).unlock_condition)
	
	if var_69_2 and var_69_3 then
		var_69_0[var_69_2 + 1] = math.max(var_69_0[var_69_2 + 1], var_69_3)
	end
	
	for iter_69_0 = 1, 2 do
		local var_69_4 = arg_69_1["unlock_condition" .. iter_69_0]
		local var_69_5, var_69_6 = arg_69_0:parseUnlockCondition(arg_69_1["unlock_condition" .. iter_69_0])
		
		if var_69_5 and var_69_6 then
			var_69_0[var_69_5 + 1] = math.max(var_69_0[var_69_5 + 1], var_69_6)
		end
	end
	
	if var_69_0[1] > arg_69_2[1] or var_69_0[2] > arg_69_2[2] or var_69_0[3] > arg_69_2[3] then
		return true, var_69_0
	else
		return false, var_69_0
	end
end

function SubTaskList.refresh(arg_70_0, arg_70_1)
	if not arg_70_0.vars or not get_cocos_refid(arg_70_0.vars.parent) then
		return 
	end
	
	if arg_70_1 then
		arg_70_0.vars.category = arg_70_1
	end
	
	local var_70_0 = SanctuaryMain:GetLevels("SubTask")
	local var_70_1 = SubTask:getCategoryListByID(arg_70_0.vars.category)
	
	if_set(arg_70_0.vars.parent, "txt_title", T(var_70_1.name))
	
	local var_70_2 = SubTask:getMissionListByCategory(arg_70_0.vars.category)
	
	arg_70_0.vars.list = {}
	
	local var_70_3 = {}
	local var_70_4 = {}
	local var_70_5 = {}
	
	for iter_70_0, iter_70_1 in pairs(var_70_2) do
		local var_70_6 = SubTask:getSubtaskMissionDB(iter_70_1.id)
		
		if Account:getSubtaskMission(iter_70_1.id) then
			table.push(var_70_3, iter_70_1)
		elseif arg_70_0:isLocked(var_70_6, var_70_0) then
			table.push(var_70_4, iter_70_1)
		else
			table.push(var_70_5, iter_70_1)
		end
	end
	
	for iter_70_2, iter_70_3 in pairs(var_70_3) do
		table.push(arg_70_0.vars.list, iter_70_3)
	end
	
	for iter_70_4, iter_70_5 in pairs(var_70_5) do
		table.push(arg_70_0.vars.list, iter_70_5)
	end
	
	for iter_70_6, iter_70_7 in pairs(var_70_4) do
		table.push(arg_70_0.vars.list, iter_70_7)
	end
	
	arg_70_0:createScrollViewItems(arg_70_0.vars.list)
	SubTask:updateConcurrent()
	SubTask:updateGroups()
end

function SubTaskList.autoUpdate(arg_71_0)
	if not arg_71_0.vars or not arg_71_0.ScrollViewItems then
		return 
	end
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0.ScrollViewItems) do
		if iter_71_1.item.mission_data and get_cocos_refid(iter_71_1.control) then
			local var_71_0 = os.time()
			local var_71_1 = iter_71_1.control:getChildByName("n_condition_started")
			
			SubTask:setPercent(var_71_1, iter_71_1.item.mission_data, var_71_0)
			
			if var_71_0 < iter_71_1.item.mission_data.end_time then
				if_set(var_71_1, "txt_time", T("subtask_time_remain", {
					time = sec_to_full_string(iter_71_1.item.mission_data.end_time - var_71_0)
				}))
			else
				if_set(var_71_1, "txt_time", T("complete_text"))
			end
		end
	end
end

function SubTaskList.getScrollViewItem(arg_72_0, arg_72_1)
	local var_72_0 = load_dlg("subtask_v2_card", true, "wnd")
	
	if_set(var_72_0, "txt_lv", T("subtask_need_lv", {
		level = arg_72_1.req_level
	}))
	
	local var_72_1, var_72_2 = DB("character", arg_72_1.npc, {
		"face_id",
		"name"
	})
	
	if var_72_1 then
		local var_72_3 = var_72_0.c.n_face
		
		UIUtil:getRewardIcon("c", arg_72_1.npc, {
			no_popup = true,
			name = false,
			grade = 0,
			scale = 1.2,
			no_grade = true,
			parent = var_72_3
		})
	end
	
	local var_72_4 = SubTask:getSubtaskMissionDB(arg_72_1.id)
	
	if var_72_4.reward1 then
		if_set_visible(var_72_0, "n_item1", true)
		UIUtil:getRewardIcon(var_72_4.reward_count1, var_72_4.reward1, {
			scale = 0.8,
			parent = var_72_0.c.n_item1
		})
	else
		if_set_visible(var_72_0, "n_item1", false)
	end
	
	if var_72_4.reward2 then
		if_set_visible(var_72_0, "n_item2", true)
		UIUtil:getRewardIcon(var_72_4.reward_count2, var_72_4.reward2, {
			scale = 0.8,
			parent = var_72_0.c.n_item2
		})
	else
		if_set_visible(var_72_0, "n_item2", false)
	end
	
	arg_72_1.mission_data = Account:getSubtaskMission(arg_72_1.id)
	
	local var_72_5
	local var_72_6 = os.time()
	local var_72_7, var_72_8 = arg_72_0:isLocked(var_72_4)
	
	if var_72_7 then
		if_set_visible(var_72_0, "n_condition_ready", true)
		if_set_visible(var_72_0, "n_condition_started", false)
		if_set_visible(var_72_0, "n_condition_locked", true)
		if_set_visible(var_72_0, "n_condition_on", false)
		if_set_opacity(var_72_0, "n_card", 120)
		
		var_72_5 = var_72_0.c.n_condition_ready
		
		if_set(var_72_5, "txt_name", "")
		if_set_visible(var_72_5, "btn_detail", false)
		if_set(var_72_5, "txt_time", T("subtask_time", {
			time = sec_to_full_string(arg_72_1.time * 60)
		}))
		
		local var_72_9 = var_72_0.c.n_condition_locked
		
		if_set_visible(var_72_9, "btn_upgrade_subtask", true)
		
		var_72_9.c.btn_upgrade_subtask.req_levels = var_72_8
		
		local var_72_10 = var_72_9.c.n_required
		
		if_set_visible(var_72_10, "img_up1", false)
		if_set_visible(var_72_10, "img_up2", false)
		if_set_visible(var_72_10, "img_up3", false)
		
		local var_72_11 = {
			"img/_upgrade_num_orange.png",
			"img/_upgrade_num_blue.png",
			"img/_upgrade_num_green.png"
		}
		local var_72_12 = {
			cc.c3b(135, 56, 9),
			cc.c3b(24, 101, 160),
			cc.c3b(50, 114, 19)
		}
		local var_72_13 = 0
		
		for iter_72_0 = 1, 3 do
			if var_72_8[iter_72_0] > 0 then
				var_72_13 = var_72_13 + 1
				
				local var_72_14 = "img_up" .. var_72_13
				local var_72_15 = var_72_10:getChildByName(var_72_14)
				local var_72_16 = var_72_15:getCapInsets()
				
				if_set_visible(var_72_10, var_72_14, true)
				if_set_sprite(var_72_10, var_72_14, var_72_11[iter_72_0])
				var_72_15:setCapInsets(var_72_16)
				
				local var_72_17 = var_72_10.c[var_72_14]:findChildByName("txt_lv")
				
				if get_cocos_refid(var_72_17) then
					if_set(var_72_17, nil, var_72_8[iter_72_0])
					var_72_17:enableOutline(var_72_12[iter_72_0], 2)
				end
			end
		end
		
		var_72_10.c.txt_required:setPositionX(var_72_13 * 35)
	else
		if_set_visible(var_72_0, "n_condition_ready", arg_72_1.mission_data == nil)
		if_set_visible(var_72_0, "n_condition_started", arg_72_1.mission_data ~= nil)
		if_set_visible(var_72_0, "n_condition_locked", false)
		if_set_visible(var_72_0, "n_condition_on", true)
		
		local var_72_18
		
		if arg_72_1.mission_data == nil then
			var_72_5 = var_72_0.c.n_condition_ready
			
			if_set(var_72_5, "txt_time", T("subtask_time", {
				time = sec_to_full_string(arg_72_1.time * 60)
			}))
			
			local var_72_19 = var_72_5.c.btn_detail
			
			var_72_19:setName("btn_list:" .. arg_72_1.id)
			
			local var_72_20 = var_72_19.c.n_cost
			
			if_set(var_72_20, "cost", var_72_4.use_token_count)
		else
			var_72_5 = var_72_0.c.n_condition_started
			
			var_72_5.c.btn_detail:setName("btn_list:" .. arg_72_1.id)
			
			if var_72_6 < arg_72_1.mission_data.end_time then
				if_set(var_72_5, "txt_time", T("subtask_time_remain", {
					time = sec_to_full_string(arg_72_1.mission_data.end_time - var_72_6)
				}))
				SubTask:setPercent(var_72_5, arg_72_1.mission_data, var_72_6)
			else
				if_set(var_72_5, "txt_time", T("complete_text"))
			end
		end
		
		if_set(var_72_5, "txt_name", T(arg_72_1.num) .. " " .. T(arg_72_1.name))
	end
	
	return var_72_0
end

function SubTaskList.onSelectScrollViewItem(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = SubTask:getSubtaskMissionDB(arg_73_2.item.id)
	
	if arg_73_0:isLocked(var_73_0) then
		balloon_message_with_sound("subtask_unlock_req_sanc")
		
		return 
	end
end

function SubTaskList.selectedScrollViewItem(arg_74_0, arg_74_1)
	SubTask:setMode("Ready", arg_74_1.item.id)
end

function SubTaskList.selectItemByGroups(arg_75_0, arg_75_1)
	SubTask:setMode("Ready", arg_75_1)
end

function SubTaskList.selectItem(arg_76_0, arg_76_1)
	for iter_76_0, iter_76_1 in pairs(arg_76_0.ScrollViewItems) do
		if iter_76_1.item.id == arg_76_1 then
			arg_76_0:selectedScrollViewItem(iter_76_1)
			
			return 
		end
	end
end

SubTaskRight = {}

copy_functions(ScrollView, SubTaskRight)

function SubTaskRight.show(arg_77_0, arg_77_1, arg_77_2)
	arg_77_0.vars = {}
	arg_77_0.vars.parent = arg_77_1
	arg_77_0.vars.last_index = 1
	arg_77_0.vars.category_list = arg_77_2
	arg_77_0.vars.scrollview = arg_77_1.c.scrollview_categories
	
	arg_77_0:initScrollView(arg_77_0.vars.scrollview, 294, 92, {
		fit_height = true
	})
	arg_77_0:refresh()
end

function SubTaskRight.refresh(arg_78_0)
	arg_78_0:createScrollViewItems(arg_78_0.vars.category_list)
	arg_78_0:selectMenu(arg_78_0.vars.last_index)
end

function SubTaskRight.selectMenu(arg_79_0, arg_79_1)
	arg_79_0.vars.last_index = arg_79_1
	
	for iter_79_0, iter_79_1 in pairs(arg_79_0.ScrollViewItems) do
		if iter_79_0 == arg_79_1 then
			if_set_visible(iter_79_1.control, "bg", true)
		else
			if_set_visible(iter_79_1.control, "bg", false)
		end
	end
	
	SubTask:listSelectedRight(arg_79_0.ScrollViewItems[arg_79_1].item.id)
end

function SubTaskRight.getScrollViewItem(arg_80_0, arg_80_1)
	local var_80_0 = cc.CSLoader:createNode("wnd/subtask_category.csb")
	
	if_set_visible(var_80_0, "bg", false)
	if_set_visible(var_80_0, "n_locked", false)
	if_set_sprite(var_80_0, "icon_menu", "img/" .. tostring(arg_80_1.icon) .. ".png")
	if_set(var_80_0, "title", T(arg_80_1.name))
	
	return var_80_0
end

function SubTaskRight.onSelectScrollViewItem(arg_81_0, arg_81_1, arg_81_2)
	arg_81_0:selectMenu(arg_81_1)
	SoundEngine:play("event:/ui/category/select")
end
