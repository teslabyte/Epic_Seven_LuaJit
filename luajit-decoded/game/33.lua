BackPlayControlBox = {}

function HANDLER.pet_auto_control_bgplay(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_time" then
		BattleTopBarUrgentPopup:open_urgentMissionPopup({
			is_back_play = true
		})
	elseif arg_1_1 == "btn_expedition" then
		BattleTopBarCoopPopup:open_coopMissionPopup({
			is_back_play = true
		})
	elseif arg_1_1 == "btn_item" then
		BattleRepeatPopup:openItemListPopup({
			is_back_play = true
		})
	elseif arg_1_1 == "btn_setting" then
		BackPlayControlBox:openSettingPopup(arg_1_0.team_idx, arg_1_0.pet_data, {
			is_back_play = true
		})
	elseif arg_1_1 == "btn_end" then
		if not NetWaiting:isWaiting() then
			BackPlayControlBox:endBattle()
		end
	elseif arg_1_1 == "btn_restart" then
		BackPlayControlBox:restartBattle()
	elseif arg_1_1 == "btn_open_auto" then
		BackPlayControlBox:restore()
	elseif arg_1_1 == "btn_close" then
		BackPlayControlBox:close()
	end
end

function BackPlayControlBox.show(arg_2_0, arg_2_1)
	if not BackPlayManager:isActive() then
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.opts = arg_2_1 or arg_2_0.vars.opts or {}
	
	local var_2_0 = Dialog:open("wnd/pet_auto_control_bgplay", arg_2_0, {
		back_func = function()
			BackPlayControlBox:close()
		end
	})
	
	arg_2_0.vars.parent = arg_2_0.vars.opts.parent or SceneManager:getRunningPopupScene()
	arg_2_0.vars.wnd = var_2_0
	arg_2_0.vars.bgs = {}
	arg_2_0.vars.models = {}
	arg_2_0.vars.cur_action = nil
	arg_2_0.vars.end_action = false
	
	arg_2_0.vars.parent:addChild(var_2_0)
	arg_2_0:createDim()
	
	if BackPlayManager:isRunning() then
		arg_2_0:setState("running")
	end
	
	arg_2_0:initUI()
	arg_2_0:createBG()
	Scheduler:add(arg_2_0.vars.wnd, arg_2_0.update, arg_2_0)
	arg_2_0:update()
	UIUtil:slideOpen(var_2_0, var_2_0, true)
end

function BackPlayControlBox.createDim(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	local var_4_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	arg_4_0.vars.dim = var_4_0
	
	var_4_0:setPositionX(VIEW_BASE_LEFT)
	var_4_0:setContentSize({
		width = VIEW_WIDTH,
		height = VIEW_HEIGHT
	})
	var_4_0:setOpacity(0)
	arg_4_0.vars.parent:addChild(var_4_0)
	var_4_0:setLocalZOrder(99999)
	arg_4_0.vars.wnd:bringToFront()
	UIAction:Add(SEQ(LOG(OPACITY(400, 0, 0.8))), var_4_0, "block")
end

function BackPlayControlBox.removeDim(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.dim) then
		return 
	end
	
	arg_5_0.vars.dim:removeFromParent()
end

function BackPlayControlBox.initUI(arg_6_0, arg_6_1)
	local var_6_0 = BackPlayManager:getRunningMapId()
	local var_6_1 = BackPlayManager:isRunning()
	
	if var_6_1 and var_6_0 then
		local var_6_2, var_6_3, var_6_4 = DB("level_enter", var_6_0, {
			"name",
			"type",
			"local"
		})
		
		if_set(arg_6_0.vars.wnd, "txt_contents", T(var_6_4))
		if_set(arg_6_0.vars.wnd, "txt_stage", T(var_6_2))
	end
	
	if_set_visible(arg_6_0.vars.wnd, "txt_stage", var_6_1)
	if_set_visible(arg_6_0.vars.wnd, "txt_contents", var_6_1)
	if_set_visible(arg_6_0.vars.wnd, "btn_end", true)
	if_set_visible(arg_6_0.vars.wnd, "btn_restart", false)
	if_set_opacity(arg_6_0.vars.wnd, "btn_open_auto", arg_6_0:canRestore() and 255 or 76.5)
	if_set_opacity(arg_6_0.vars.wnd, "btn_end", arg_6_0:canEndBattle() and 255 or 76.5)
	if_set(arg_6_0.vars.wnd, "txt_title", T("ui_pet_auto_bgbattle_title"))
	
	local var_6_5 = arg_6_0.vars.wnd:getChildByName("btn_setting")
	
	if get_cocos_refid(var_6_5) then
		local var_6_6
		
		if BackPlayManager:isDescent() then
			var_6_6 = Account:getDescentPetTeamIdx()
		else
			var_6_6 = BackPlayManager:getRunningTeamIdx()
		end
		
		var_6_6 = var_6_6 or BackPlayManager:getRunningTeamIdxRaw()
		var_6_5.team_idx = var_6_6
		var_6_5.pet_data = Account:getPetInTeam(var_6_6)
	end
	
	upgradeLabelToRichLabel(arg_6_0.vars.wnd, "txt_count", true)
	
	local var_6_7 = arg_6_0.vars.wnd:getChildByName("eff_result")
	local var_6_8
	
	if BackPlayManager:getLastResult() == "win" then
		var_6_8 = "img/auto_eff_clear.png"
	elseif BackPlayManager:getLastResult() == "lose" then
		var_6_8 = "img/auto_eff_fail.png"
	end
	
	if var_6_8 then
		var_6_7:setVisible(true)
		SpriteCache:resetSprite(var_6_7, var_6_8)
	else
		var_6_7:setVisible(false)
	end
	
	arg_6_0:setEndBattleTextUI()
end

function BackPlayControlBox.createBG(arg_7_0)
	arg_7_0.vars.content_size_x = 520
	arg_7_0.vars.content_size_y = 270
	
	local var_7_0 = BackPlayManager:getCurrentTeam()
	local var_7_1 = arg_7_0.vars.wnd:getChildByName("n_panel")
	local var_7_2 = var_7_1:getChildByName("n_eff")
	
	arg_7_0.vars.n_result = var_7_1:getChildByName("eff_result")
	
	local var_7_3 = SpriteCache:getSprite("worldmap/bgbattle.png")
	
	var_7_3:setPosition(0, arg_7_0.vars.content_size_y * 0.5)
	var_7_3:setContentSize(arg_7_0.vars.content_size_x, arg_7_0.vars.content_size_y)
	var_7_2:addChild(var_7_3)
	
	arg_7_0.vars.bgs[1] = var_7_3
	
	local var_7_4 = SpriteCache:getSprite("worldmap/bgbattle.png")
	
	var_7_4:setPosition(arg_7_0.vars.content_size_x, arg_7_0.vars.content_size_y * 0.5)
	var_7_4:setContentSize(arg_7_0.vars.content_size_x, arg_7_0.vars.content_size_y)
	var_7_2:addChild(var_7_4)
	
	arg_7_0.vars.bgs[2] = var_7_4
	
	for iter_7_0, iter_7_1 in pairs(var_7_0 or {}) do
		local var_7_5 = iter_7_1.isPet and CACHE:getModel(iter_7_1:getModelID(), nil) or CACHE:getModel(iter_7_1.db.model_id, iter_7_1.db.skin, nil, iter_7_1.db.atlas, iter_7_1.db.model_opt)
		local var_7_6 = iter_7_1.isPet and var_7_1:getChildByName("n_pet") or var_7_1:getChildByName("pos" .. tostring(iter_7_0))
		
		if var_7_5 and var_7_6 and not string.starts(iter_7_1.db.code, "s") then
			var_7_6:addChild(var_7_5)
			
			local var_7_7 = var_7_5:createShadow()
			
			if get_cocos_refid(var_7_7) then
				var_7_7:setGlobalZOrder(0)
				var_7_7:setLocalZOrder(-10)
			end
			
			table.insert(arg_7_0.vars.models, var_7_5)
		end
	end
end

function BackPlayControlBox.close(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "pet_auto_control_bgplay",
		dlg = arg_8_0.vars.wnd
	})
	Scheduler:remove(BackPlayControlBox.update)
	arg_8_0:removeDim()
	UIUtil:slideOpen(arg_8_0.vars.wnd, arg_8_0.vars.wnd, false)
	
	if not BackPlayManager:isRunning() then
		BackPlayControlBox:resetValue()
		ConditionContentsManager:clearSubStoryContents()
	end
	
	arg_8_0.vars = nil
end

function BackPlayControlBox.setForceEndPlay(arg_9_0)
	arg_9_0.is_force_end_play = true
end

function BackPlayControlBox.isForceEndPlay(arg_10_0)
	return arg_10_0.is_force_end_play
end

function BackPlayControlBox.endBattle(arg_11_0)
	if not BackPlayManager:isRunning() then
		return 
	end
	
	arg_11_0:setState("finished")
	arg_11_0:updateAnimation({
		forced_end = true
	})
	arg_11_0:setEndBattleUI()
	BackPlayManager:stop()
	BattleRepeat:stop_repeatPlay()
	TopBarNew:updateBackGround()
end

function BackPlayControlBox.restore(arg_12_0)
	if not arg_12_0:canRestore() then
		if arg_12_0:isFinished() then
			balloon_message_with_sound("msg_bgbattle_already_end")
		elseif BackPlayManager:isRestoreDelayTime() then
			balloon_message_with_sound("msg_bgbattle_waiting_time_2")
		else
			balloon_message_with_sound("msg_bgbattle_waiting_time")
		end
		
		return 
	end
	
	if BackPlayManager:getCurrentRoadType() == "goblin" or BackPlayManager:getCurrentRoadType() == "chaos" then
		balloon_message_with_sound("msg_bgbattle_waiting_time_2")
		
		return 
	end
	
	UIAction:RemoveAll()
	Scheduler:remove(BackPlayControlBox.update)
	UIAction:Add(DELAY(1500), arg_12_0, "block")
	
	if BackPlayManager:restore() then
		arg_12_0:setState(nil)
	end
	
	arg_12_0.is_force_end_play = nil
end

function BackPlayControlBox.openSettingPopup(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_1 or not arg_13_2 then
		return 
	end
	
	PetHelper:open_petSetting(arg_13_2, arg_13_1, arg_13_3)
end

function BackPlayControlBox.update(arg_14_0)
	set_high_fps_tick()
	arg_14_0:updateUI()
	arg_14_0:updateAnimation()
	arg_14_0:updateScore()
end

function BackPlayControlBox.updateUI(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	BattleRepeat:update_missionCount(arg_15_0.vars.wnd)
	
	if arg_15_0:isFinished() and not arg_15_0.is_end then
		arg_15_0:setEndBattleUI()
	else
		local var_15_0 = true
		
		if not arg_15_0:canRestore() or BackPlayManager:getCurrentRoadType() == "goblin" or BackPlayManager:getCurrentRoadType() == "chaos" then
			var_15_0 = false
		end
		
		if_set_opacity(arg_15_0.vars.wnd, "btn_open_auto", var_15_0 and 255 or 76.5)
		if_set_opacity(arg_15_0.vars.wnd, "btn_end", arg_15_0:canEndBattle() and 255 or 76.5)
	end
end

function BackPlayControlBox.getAnimState(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0
	
	if arg_16_0:isFinished() then
		if arg_16_0.vars.end_action then
			var_16_0 = "idle"
		elseif BackPlayManager:getLastResult() == "lose" then
			var_16_0 = "groggy"
		else
			var_16_0 = "idle"
		end
	elseif BackPlayManager:hasBattle() then
		var_16_0 = "run"
	elseif BackPlayManager:getLastResult() == "win" then
		var_16_0 = "idle"
	elseif BackPlayManager:getLastResult() == "lose" then
		var_16_0 = "groggy"
	end
	
	return var_16_0
end

function BackPlayControlBox.getResultImage(arg_17_0, arg_17_1)
	local var_17_0
	local var_17_1
	
	if arg_17_0:isForceEndPlay() and BackPlayManager:getLastResult() == "" then
		var_17_0 = "img/auto_eff_complete.png"
		var_17_1 = false
	elseif arg_17_0:isFinished() or arg_17_1 then
		var_17_0 = "img/auto_eff_complete.png"
		var_17_1 = true
		
		if arg_17_1 then
			var_17_1 = false
		end
	elseif BackPlayManager:hasBattle() then
		var_17_0 = nil
	elseif BackPlayManager:getLastResult() == "win" then
		var_17_0 = "img/auto_eff_clear.png"
	elseif BackPlayManager:getLastResult() == "lose" then
		var_17_0 = "img/auto_eff_fail.png"
	end
	
	return var_17_0, var_17_1
end

function BackPlayControlBox.updateAnimation(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	local var_18_0 = (arg_18_1 or {}).forced_end
	local var_18_1 = arg_18_0:getAnimState()
	local var_18_2 = var_18_1 == "run" and 3 or 0
	
	if arg_18_0.vars.cur_action ~= var_18_1 then
		arg_18_0.vars.cur_action = var_18_1
		
		for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.models or {}) do
			iter_18_1:setAnimation(0, arg_18_0.vars.cur_action, true)
		end
	end
	
	local var_18_3, var_18_4 = arg_18_0:getResultImage(var_18_0)
	
	if var_18_3 then
		arg_18_0.vars.n_result:setVisible(true)
		
		if var_18_4 then
			UIAction:Add(SEQ(DELAY(2000), CALL(function()
				if not arg_18_0.vars then
					return 
				end
				
				SpriteCache:resetSprite(arg_18_0.vars.n_result, var_18_3)
				
				arg_18_0.vars.end_action = true
			end)), arg_18_0.vars.n_result, "finish_delay")
		else
			SpriteCache:resetSprite(arg_18_0.vars.n_result, var_18_3)
		end
	else
		arg_18_0.vars.n_result:setVisible(false)
	end
	
	for iter_18_2, iter_18_3 in pairs(arg_18_0.vars.bgs or {}) do
		iter_18_3:setPositionX(iter_18_3:getPositionX() - var_18_2)
	end
	
	if arg_18_0.vars.bgs[1]:getPositionX() < arg_18_0.vars.content_size_x * -1 then
		arg_18_0.vars.bgs[1]:setPositionX(arg_18_0.vars.bgs[2]:getPositionX() + arg_18_0.vars.content_size_x)
	elseif arg_18_0.vars.bgs[2]:getPositionX() < arg_18_0.vars.content_size_x * -1 then
		arg_18_0.vars.bgs[2]:setPositionX(arg_18_0.vars.bgs[1]:getPositionX() + arg_18_0.vars.content_size_x)
	end
end

function BackPlayControlBox.updateScore(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	local var_20_0, var_20_1 = BattleRepeat:getScores()
	
	if not var_20_0 or not var_20_1 then
		return 
	end
	
	local var_20_2 = T("ui_pet_auto_battle_desc", {
		count = BattleRepeat:getCurRepeatCount(),
		max = BattleRepeat:get_repeatMaxCount()
	})
	local var_20_3 = T("ui_pet_auto_battle_winrate", {
		win = var_20_0,
		lose = var_20_1
	})
	
	if_set(arg_20_0.vars.wnd, "txt_count", var_20_2)
	if_set(arg_20_0.vars.wnd, "txt_win", var_20_3)
	
	if not arg_20_0.is_end and BattleRepeat:getCurRepeatCount() == 0 then
		if_set(arg_20_0.vars.wnd, "txt_count", T("ui_pet_auto_battle_ready"))
	elseif arg_20_0.is_end then
		local var_20_4 = arg_20_0.vars.wnd:getChildByName("txt_count")
		
		if get_cocos_refid(var_20_4) then
			if not var_20_4.count or not var_20_4.max then
				var_20_4.count = BattleRepeat:getCurRepeatCount()
				var_20_4.max = BattleRepeat:get_repeatMaxCount()
				var_20_4.is_left_none = BattleRepeat:getCurRepeatCount() == 0
			end
			
			local var_20_5
			
			if var_20_4.is_left_none then
				var_20_5 = T("ui_pet_auto_battle_off_desc", {
					count = var_20_4.count,
					max = var_20_4.max
				})
			else
				var_20_5 = T("ui_pet_auto_battle_off_desc", {
					count = var_20_4.count,
					max = var_20_4.max
				}) .. T("ui_pet_auto_battle_winrate", {
					win = var_20_0,
					lose = var_20_1
				})
			end
			
			if_set(arg_20_0.vars.wnd, "txt_count", var_20_5)
		end
	else
		local var_20_6 = T("ui_pet_auto_bgbattle_desc", {
			count = BattleRepeat:getCurRepeatCount(),
			max = BattleRepeat:get_repeatMaxCount()
		}) .. T("ui_pet_auto_battle_winrate", {
			win = var_20_0,
			lose = var_20_1
		})
		
		if_set(arg_20_0.vars.wnd, "txt_count", var_20_6)
	end
end

function BackPlayControlBox.setState(arg_21_0, arg_21_1)
	arg_21_0.state = arg_21_1
end

function BackPlayControlBox.canOpen(arg_22_0)
	return BackPlayManager:isRunning() or BackPlayManager:hasLastBattle() and arg_22_0:isFinished() or arg_22_0:isForceEndPlay()
end

function BackPlayControlBox.canRestore(arg_23_0)
	if arg_23_0:isForceEndPlay() then
		return false
	end
	
	return BackPlayManager:hasBattle() and BackPlayManager:canRestore() or BackPlayManager:hasLastBattle() and arg_23_0:isFinished()
end

function BackPlayControlBox.canEndBattle(arg_24_0)
	return BackPlayManager:isRunning() and not arg_24_0:isFinished()
end

function BackPlayControlBox.hasNoti(arg_25_0)
	return BackPlayManager:hasLastBattle() and arg_25_0:isFinished()
end

function BackPlayControlBox.isFinished(arg_26_0)
	return arg_26_0.state == "finished"
end

function BackPlayControlBox.setEndBattleUI(arg_27_0, arg_27_1)
	if arg_27_0.vars and get_cocos_refid(arg_27_0.vars.wnd) then
		if_set(arg_27_0.vars.wnd, "txt_title", T("ui_pet_auto_bgbattle_off"))
		if_set_opacity(arg_27_0.vars.wnd, "btn_open_auto", BackPlayManager:hasLastBattle() and 255 or 76.5)
		if_set_opacity(arg_27_0.vars.wnd, "btn_end", 76.5)
	end
	
	arg_27_0.is_end = true
	arg_27_0.t_reason = arg_27_1
	
	arg_27_0:setEndBattleTextUI()
end

function BackPlayControlBox.getWnd(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	return arg_28_0.vars.wnd
end

function BackPlayControlBox.setEndBattleTextUI(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("n_panel"):getChildByName("n_info")
	
	if not get_cocos_refid(var_29_0) then
		return 
	end
	
	var_29_0:setVisible(true)
	
	if arg_29_0.t_reason then
		local var_29_1 = {
			no_genie_enter = "msg_bgbattle_altar_buff_ended",
			max_inven = "msg_bgbattle_equip_max",
			max_unit = "msg_bgbattle_hero_max"
		}
		
		var_29_1.classchange_add = "ui_bgbattle_new_mission_add"
		var_29_1.classchange_stop = "ui_bgbattle_new_mission_add"
		var_29_1.growthguide = "ui_bgbattle_new_mission_add"
		var_29_1.chapter_shop_force = "ui_bgbattle_new_mission_add"
		var_29_1.chapter_shop = "ui_bgbattle_new_mission_add"
		var_29_1.substory_end = "ui_bgbattle_new_substory_end"
		
		local var_29_2 = T(var_29_1[arg_29_0.t_reason])
		
		if_set(var_29_0, "label", var_29_2)
	elseif arg_29_0.is_end then
		if_set(var_29_0, "label", T("ui_pet_auto_battle_off_count"))
	else
		var_29_0:setVisible(false)
		
		return 
	end
	
	if_set(arg_29_0.vars.wnd, "txt_title", T("ui_pet_auto_bgbattle_off"))
end

function BackPlayControlBox.resetValue(arg_30_0)
	arg_30_0.t_reason = nil
	arg_30_0.state = nil
	arg_30_0.is_end = nil
	arg_30_0.is_force_end_play = nil
end
