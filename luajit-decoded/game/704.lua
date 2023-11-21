LotaEventSelectUI = {}

function HANDLER.story_select_heritage(arg_1_0, arg_1_1)
	if string.find(arg_1_1, "btn_choice_") then
		LotaEventSelectUI:selectChoice(arg_1_0.idx, arg_1_0.data)
	end
	
	if arg_1_1 == "btn_exite" then
		LotaEventSelectUI:sendCloseQuery()
	end
end

function HANDLER.clan_heritage_event_confirm(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_cancel" then
		LotaEventSelectUI:closeConfirmUI()
	elseif arg_2_1 == "btn_ok" then
		LotaEventSelectUI:onConfirmed()
	end
end

function LotaEventSelectUI.sendCloseQuery(arg_3_0)
	Dialog:msgBox(T("ui_clan_heritage_event_cancel"), {
		yesno = true,
		handler = function()
			LotaEventSystem:sendQuery(LotaEventSystem:getTileId(), nil)
		end
	})
end

function LotaEventSelectUI.onConfirmed(arg_5_0)
	local var_5_0 = arg_5_0.vars.confirm_check_data
	
	arg_5_0.vars.confirm_check_data = nil
	
	LotaEventSystem:sendQuery(LotaEventSystem:getTileId(), var_5_0.id)
end

function LotaEventSelectUI.closeConfirmUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.confirm_dlg) then
		return 
	end
	
	BackButtonManager:pop()
	arg_6_0.vars.confirm_dlg:removeFromParent()
	
	arg_6_0.vars.confirm_dlg = nil
end

function LotaEventSelectUI.makeConfirmUI(arg_7_0, arg_7_1)
	arg_7_0.vars.confirm_check_data = arg_7_1
	
	local var_7_0 = load_dlg("clan_heritage_event_confirm", nil, "wnd")
	
	arg_7_0.vars.confirm_dlg = var_7_0
	
	BackButtonManager:push({
		back_func = function()
			arg_7_0:closeConfirmUI()
		end
	})
	arg_7_0:setElement(var_7_0:findChildByName("balloon"), arg_7_1)
	SceneManager:getRunningNativeScene():addChild(var_7_0)
end

function LotaEventSelectUI.selectChoice(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0.vars and arg_9_0.vars.confirm_dlg and get_cocos_refid(arg_9_0.vars.confirm_dlg) then
		return 
	end
	
	if arg_9_2.penalty_type == "battle" then
		if not LotaEventSystem:isEventBattleAvailable(arg_9_2) then
			balloon_message_with_sound("msg_clanheritage_event_cant_battle")
			
			return 
		end
		
		LotaBattleReady:show({
			tile_id = LotaEventSystem:getTileId(),
			event = arg_9_2,
			object_id = arg_9_2.penalty_value
		})
		
		return 
	end
	
	if not LotaEventSystem:isEventTokenEnough(arg_9_2) then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return 
	end
	
	if not LotaEventSystem:isEventConditionAvailable(arg_9_2) then
		balloon_message_with_sound("msg_clanheritage_event_condition_yet")
		
		return 
	end
	
	if not LotaEventSystem:isEventAddConsumptionAvailable(arg_9_2) then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return 
	end
	
	if not LotaEventSystem:isEventAvailableGetReward(arg_9_2) then
		balloon_message_with_sound("msg_clan_heritage_event_max_rolelevel")
		
		return 
	end
	
	if not LotaEventSystem:isEventAvailable(arg_9_2) then
		Log.e("ALL CHECK CONDITION BUT NOT EVENT AVAilABLE. CHECK.")
		
		return 
	end
	
	LotaEventSelectUI:makeConfirmUI(arg_9_2)
	
	arg_9_0.vars.selected_idx = arg_9_1
end

function LotaEventSelectUI.open(arg_10_0)
	local var_10_0 = LotaUtil:getUIDlg("story_select_heritage")
	
	arg_10_0.vars = {}
	arg_10_0.vars.dlg = var_10_0
	
	arg_10_0:setupElements()
	
	local var_10_1 = LotaUserData:getConfigMaxActionPoint()
	local var_10_2 = LotaUserData:getActionPoint()
	local var_10_3 = arg_10_0.vars.dlg:findChildByName("t_token_count")
	
	if_set(var_10_3, nil, var_10_2 .. "/" .. var_10_1)
	
	local var_10_4 = var_10_2 .. "/" .. var_10_1
	local var_10_5 = string.len(var_10_4)
	local var_10_6 = var_10_3:findChildByName("n_token")
	local var_10_7 = 14
	
	var_10_6:setPositionX(3 * var_10_7 + var_10_5 * -var_10_7)
	
	return arg_10_0.vars.dlg
end

function LotaEventSelectUI.close(arg_11_0)
	if arg_11_0.vars and get_cocos_refid(arg_11_0.vars.dlg) then
		arg_11_0:closeConfirmUI()
		
		local var_11_0 = arg_11_0.vars.selected_idx
		
		for iter_11_0 = 1, 3 do
			if iter_11_0 ~= var_11_0 then
				if_set_visible(arg_11_0.vars.dlg, "balloon_" .. iter_11_0, false)
			end
		end
		
		local var_11_1 = arg_11_0.vars.dlg:findChildByName("balloon_" .. var_11_0)
		local var_11_2 = var_11_1:getChildByName("btn_choice_" .. var_11_0)
		
		if get_cocos_refid(var_11_2) then
			var_11_2:setTouchEnabled(false)
		end
		
		UIAction:Add(SEQ(CALL(SoundEngine.play, SoundEngine, "event:/ui/story_select"), REPEAT(3, SEQ(TARGET(var_11_1, OPACITY(400, 1, 0.3)), TARGET(var_11_1, OPACITY(400, 0.3, 1)))), FADE_OUT(300), CALL(function()
			STORY.cut_opts.select_wait = nil
			
			if_set_visible(STORY.layer, "n_auto", true)
			if_set_visible(STORY.layer:getParent(), "skip_front", true)
			if_set_visible(STORY.layer:getChildByName("n_return_dict"), "bar__", true)
		end), CALL(step_next, {
			force = true
		}), REMOVE()), arg_11_0.vars.dlg, "block")
		
		arg_11_0.vars = nil
	end
end

function LotaEventSelectUI.setupElements(arg_13_0)
	for iter_13_0 = 1, 3 do
		local var_13_0 = LotaEventSystem:isExistEvent(iter_13_0)
		
		if_set_visible(arg_13_0.vars.dlg, "balloon_" .. iter_13_0, var_13_0)
		
		if var_13_0 then
			arg_13_0:setElement(arg_13_0.vars.dlg:findChildByName("balloon_" .. iter_13_0), LotaEventSystem:getEventData(iter_13_0), iter_13_0)
		end
	end
end

function LotaEventSelectUI.setElement(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_1:findChildByName("n_contents")
	local var_14_1 = arg_14_1:findChildByName("n_normal")
	local var_14_2 = arg_14_1:findChildByName("n_locked")
	
	if_set(var_14_1, "txt_choice", T(arg_14_2.select_name))
	if_set_visible(var_14_1, "t_consum_count", arg_14_2.need_token ~= nil)
	
	if arg_14_2.need_token then
		if_set(var_14_1, "t_consum_count", "-" .. arg_14_2.need_token)
	end
	
	local var_14_3 = LotaEventSystem:isPenaltyExist(arg_14_2)
	local var_14_4 = arg_14_2.req_desc ~= nil
	
	if_set_visible(arg_14_1, "n_top", var_14_3 or var_14_4)
	
	if LotaEventSystem:isEventConditionAvailable(arg_14_2) then
		if_set_visible(var_14_0, nil, true)
		if_set_visible(var_14_2, nil, false)
		if_set_opacity(var_14_1, nil, 255)
		
		if var_14_3 then
			if_set(var_14_1, "t_event", T(arg_14_2.penalty_desc))
		elseif var_14_4 then
			if_set_visible(var_14_1, "t_event", false)
			if_set(var_14_1, "t_condition", T(arg_14_2.req_desc))
		end
		
		local var_14_5, var_14_6 = LotaEventSystem:getPenaltyIcon(arg_14_2)
		
		if var_14_5 then
			local var_14_7 = var_14_1:findChildByName("n_event_icon")
			
			if_set_visible(var_14_7, nil, true)
			
			local var_14_8 = var_14_7:findChildByName(var_14_6)
			
			if get_cocos_refid(var_14_8) then
				if_set_visible(var_14_8, nil, true)
				var_14_8:addChild(var_14_5)
			else
				print("CANT FIND!!!!", arg_14_2.penalty_condition, var_14_6)
			end
		end
		
		local var_14_9 = LotaEventSystem:getEventReward(arg_14_2)
		local var_14_10 = arg_14_1:findChildByName("n_reward")
		
		for iter_14_0 = 1, 3 do
			local var_14_11 = var_14_10:findChildByName("reward_item" .. iter_14_0)
			local var_14_12 = var_14_9[iter_14_0]
			
			if var_14_12 then
				UIUtil:getRewardIcon(var_14_12.count, var_14_12.item_id, {
					no_detail_popup = true,
					parent = var_14_11
				})
			end
		end
		
		if not var_14_3 and not var_14_4 then
			local var_14_13 = arg_14_1:findChildByName("n_reward_move")
			
			var_14_10:setPosition(var_14_13:getPosition())
		end
	else
		if_set_visible(var_14_0, nil, false)
		if_set_visible(var_14_2, nil, true)
		if_set_opacity(var_14_1, nil, 76.5)
		if_set(var_14_2, "txt_locked", T(arg_14_2.req_desc))
	end
	
	if not LotaEventSystem:isEventAvailable(arg_14_2) then
		if_set_opacity(var_14_1, nil, 76.5)
	end
	
	if arg_14_3 then
		local var_14_14 = arg_14_1:findChildByName("btn_choice_" .. arg_14_3)
		
		var_14_14.data = arg_14_2
		var_14_14.idx = arg_14_3
	end
end
