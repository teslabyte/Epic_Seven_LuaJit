function HANDLER.clan_heritage_noti(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaReminderUI:close()
	end
	
	if arg_1_1 == "btn_category_event" then
		LotaReminderUI:showCategory("event")
	end
	
	if arg_1_1 == "btn_category_reward" then
		LotaReminderUI:showCategory("reward")
	end
end

function HANDLER.clan_heritage_noti_reward_item(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_get" then
		LotaReminderUI:receiveReward(arg_2_0.data)
	end
	
	if arg_2_1 == "btn_detail" then
		LotaReminderUI:showDetail(arg_2_0.data)
	end
end

LotaReminderUI = {}

function LotaReminderUI.showCategory(arg_3_0, arg_3_1)
	if arg_3_0.vars.mode == arg_3_1 then
		return 
	end
	
	arg_3_0.vars.mode = arg_3_1
	
	arg_3_0:updateUI()
	
	local var_3_0 = systick()
	
	if arg_3_1 == "event" then
		if var_3_0 - arg_3_0.vars.last_history_sync > arg_3_0.vars.cool_time then
			LotaNetworkSystem:sendQuery("lota_get_history")
		end
	elseif SceneManager:getCurrentSceneName() == "lota_lobby" and LotaEnterUI:isUserInfoExist() and var_3_0 - arg_3_0.vars.last_move_sync > arg_3_0.vars.cool_time then
		LotaNetworkSystem:sendQuery("lota_get_reward_list")
	end
end

function LotaReminderUI.init(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_noti")
	arg_4_1 = arg_4_1 or LotaSystem:getUIDialogLayer()
	
	arg_4_1:addChild(arg_4_0.vars.dlg)
	
	arg_4_0.vars.mode = "event"
	arg_4_0.vars.layer = arg_4_1
	arg_4_0.vars.cool_time = 3000
	arg_4_0.vars.last_move_sync = 0
	arg_4_0.vars.last_history_sync = 0
	
	arg_4_0:buildUI()
	LotaNetworkSystem:sendQuery("lota_get_history")
	BackButtonManager:push({
		check_id = "lota_noti",
		back_func = function()
			arg_4_0:close()
		end
	})
end

function LotaReminderUI.buildUI(arg_6_0)
	local var_6_0 = arg_6_0.vars.dlg:findChildByName("n_event")
	local var_6_1 = arg_6_0.vars.dlg:findChildByName("n_reward")
	
	LotaReminderEventScrollView:init(var_6_0)
	LotaReminderRewardScrollView:init(var_6_1)
	arg_6_0:updateUI()
end

function LotaReminderUI.updateUI(arg_7_0)
	if_set_visible(arg_7_0.vars.dlg, "bg_category_reward", arg_7_0.vars.mode == "reward")
	if_set_visible(arg_7_0.vars.dlg, "bg_category_event", arg_7_0.vars.mode == "event")
	
	local var_7_0 = 0
	
	if arg_7_0.vars.mode == "reward" then
		var_7_0 = LotaReminderRewardScrollView:open()
	else
		LotaReminderEventScrollView:open(arg_7_0.vars.last_response_logs or {}, true)
		
		var_7_0 = table.count(arg_7_0.vars.last_response_logs or {})
	end
	
	if_set_visible(arg_7_0.vars.dlg, "n_reward", arg_7_0.vars.mode == "reward")
	if_set_visible(arg_7_0.vars.dlg, "n_event", arg_7_0.vars.mode == "event")
	
	local var_7_1 = arg_7_0.vars.dlg:findChildByName("n_no_data")
	
	if get_cocos_refid(var_7_1) then
		var_7_1:setVisible(var_7_0 == 0)
		
		local var_7_2 = "ui_heritage_no_event"
		
		if arg_7_0.vars.mode == "reward" then
			var_7_2 = "ui_heritage_no_reward"
		end
		
		if_set(var_7_1, "label", T(var_7_2))
	end
	
	if_set_visible(arg_7_0.vars.dlg, "n_no_data", var_7_0 == 0)
	
	local var_7_3 = arg_7_0.vars.dlg:findChildByName("n_category_reward")
	
	if_set_visible(var_7_3, "icon_noti", LotaBattleDataSystem:isActiveRewardExist() or LotaBoxSystem:isActiveRewardExist())
end

function LotaReminderUI.receiveReward(arg_8_0, arg_8_1)
	if not arg_8_1:isActiveReward() then
		balloon_message_with_sound("msg_clan_heritage_alarm_not_killed")
		
		return 
	end
	
	LotaNetworkSystem:sendQuery("lota_get_box_reward", {
		target_id = arg_8_1:getRewardId()
	})
end

function LotaReminderUI.showDetail(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1:getBattleId()
	
	LotaNetworkSystem:sendQuery("lota_show_coop_detail", {
		battle_id = var_9_0
	})
end

function LotaReminderUI.onShowCoopDetail(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.expedition_info.battle_id
	local var_10_1 = LotaBattleDataSystem:getBattleData(var_10_0)
	local var_10_2 = LotaSystem.vars and LotaSystem:getUIDialogLayer() or SceneManager:getRunningNativeScene()
	
	arg_10_0.vars.detail = LotaCoopStatusUI(var_10_1, arg_10_1.expedition_users, var_10_1:getObjectId())
	
	arg_10_0.vars.detail:onShow(arg_10_0.vars.layer or var_10_2)
end

function LotaReminderUI.onResponse(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.dlg) then
		return 
	end
	
	LotaReminderRewardScrollView:open()
	arg_11_0:updateUI()
	
	if SceneManager:getCurrentSceneName() == "lota_lobby" then
		arg_11_0.vars.last_move_sync = systick()
		
		if arg_11_1 and arg_11_1.rewards then
			local var_11_0 = arg_11_1.rewards
			
			for iter_11_0, iter_11_1 in pairs(var_11_0.new_equips or {}) do
				if iter_11_1.code then
					LotaEnterUI:addLimitData(iter_11_1.code)
				end
			end
		end
	end
end

function LotaReminderUI.onResponseLogs(arg_12_0, arg_12_1)
	arg_12_0.vars.last_response_logs = arg_12_1
	
	LotaReminderEventScrollView:open(arg_12_0.vars.last_response_logs)
	arg_12_0:updateUI()
	
	arg_12_0.vars.last_history_sync = systick()
end

function LotaReminderUI.closeDetail(arg_13_0)
	if arg_13_0.vars.detail then
		local var_13_0 = arg_13_0.vars.detail
		
		arg_13_0.vars.detail = nil
		
		var_13_0:close()
	end
end

function LotaReminderUI.close(arg_14_0)
	if arg_14_0.vars and get_cocos_refid(arg_14_0.vars.dlg) then
		arg_14_0.vars.dlg:removeFromParent()
		
		arg_14_0.vars = nil
		
		if LotaSystem:isActive() then
			LotaSystem:setBlockCoolTime()
			LotaUserData:procLevelUp()
		end
		
		BackButtonManager:pop("lota_noti")
	end
end

LotaReminderEventScrollView = {}

copy_functions(ScrollView, LotaReminderEventScrollView)

function LotaReminderEventScrollView.init(arg_15_0, arg_15_1)
	arg_15_0.vars = {}
	arg_15_0.vars.parent_dlg = arg_15_1
	arg_15_0.vars.scroll_view = arg_15_1:findChildByName("ScrollView")
	
	arg_15_0:initScrollView(arg_15_0.vars.scroll_view, 762, 111)
end

function LotaReminderEventScrollView.open(arg_16_0, arg_16_1)
	local var_16_0 = table.clone(arg_16_1)
	
	arg_16_0:clearScrollViewItems()
	
	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if iter_16_1.history_id == "ch_clan_pve_boss_clear" and iter_16_1.v2 then
			local var_16_1 = DB("clan_heritage_object_data", iter_16_1.v2, "map_icon_before")
			local var_16_2 = DB("character", var_16_1, "name")
			
			iter_16_1.v2 = T(var_16_2)
		end
	end
	
	ClanHistory:setDatas(arg_16_0.vars.scroll_view, var_16_0, "heritage")
end

function LotaReminderEventScrollView.close(arg_17_0)
	arg_17_0:clearScrollViewItems()
end

function LotaReminderEventScrollView.getScrollViewItem(arg_18_0, arg_18_1)
	print(arg_18_1)
end

LotaReminderRewardData = ClassDef()
LotaReminderRewardDataInterface = {
	inst = {
		object_id = "",
		floor = "",
		tile_id = ""
	}
}

function LotaReminderRewardData.constructor(arg_19_0, arg_19_1)
	arg_19_0.inst = arg_19_1
end

function LotaReminderRewardData.getObjectId(arg_20_0)
	return arg_20_0.inst.object_id
end

function LotaReminderRewardData.getType(arg_21_0)
	return (DB("clan_heritage_object_data", arg_21_0:getObjectId(), "type_2"))
end

function LotaReminderRewardData.getBattleId(arg_22_0)
	local var_22_0 = DB("clan_heritage_object_data", arg_22_0:getObjectId(), "after_kill")
	local var_22_1 = DB("clan_heritage_object_data", var_22_0, "type_2")
	
	if var_22_0 and string.find(var_22_1, "monster") then
		return arg_22_0.inst.floor .. ":" .. arg_22_0.inst.tile_id .. ":" .. arg_22_0:getObjectId()
	end
	
	return arg_22_0.inst.floor .. ":" .. arg_22_0.inst.tile_id
end

function LotaReminderRewardData.getRewardId(arg_23_0)
	local var_23_0 = arg_23_0:getBattleId()
	
	if arg_23_0.inst.object_id and not arg_23_0:isMonster() then
		return var_23_0 .. ":" .. arg_23_0.inst.object_id
	end
	
	return var_23_0
end

function LotaReminderRewardData.isMonster(arg_24_0)
	local var_24_0 = DB("clan_heritage_object_data", arg_24_0:getObjectId(), "type_2")
	
	return string.find(var_24_0, "monster")
end

function LotaReminderRewardData.isActiveReward(arg_25_0)
	if arg_25_0:isMonster() and arg_25_0.inst.battle_data then
		return arg_25_0.inst.battle_data:isBossDead()
	end
	
	return true
end

LotaReminderRewardScrollView = {}

copy_functions(ScrollView, LotaReminderRewardScrollView)

function LotaReminderRewardScrollView.init(arg_26_0, arg_26_1)
	arg_26_0.vars = {}
	arg_26_0.vars.parent_dlg = arg_26_1
	arg_26_0.vars.scroll_view = arg_26_1:findChildByName("ScrollView")
	
	arg_26_0:initScrollView(arg_26_0.vars.scroll_view, 762, 111)
end

function LotaReminderRewardScrollView.open(arg_27_0)
	local var_27_0 = LotaBattleDataSystem:getActiveRewardList()
	local var_27_1 = LotaBoxSystem:getActiveRewardList()
	local var_27_2 = {}
	
	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		table.insert(var_27_2, LotaReminderRewardData(iter_27_1))
	end
	
	for iter_27_2, iter_27_3 in pairs(var_27_1) do
		table.insert(var_27_2, LotaReminderRewardData(iter_27_3))
	end
	
	arg_27_0:clearScrollViewItems()
	arg_27_0:setScrollViewItems(var_27_2)
	
	return table.count(var_27_2)
end

function LotaReminderRewardScrollView.close(arg_28_0)
	arg_28_0:clearScrollViewItems()
end

function LotaReminderRewardScrollView.getScrollViewItem(arg_29_0, arg_29_1)
	local var_29_0 = LotaUtil:getUIControl("clan_heritage_noti_reward_item")
	local var_29_1, var_29_2, var_29_3 = DB("clan_heritage_object_data", arg_29_1:getObjectId(), {
		"type_2",
		"name",
		"category"
	})
	local var_29_4 = string.find(var_29_1, "monster")
	
	if_set_visible(var_29_0, "lv", false)
	if_set_visible(var_29_0, "grade_icon", false)
	
	local var_29_5 = var_29_0:getChildByName("txt_name")
	local var_29_6 = var_29_0:getChildByName("t_type")
	
	UIUtil:getRewardIcon(nil, arg_29_1:getObjectId(), {
		no_popup = true,
		detail = true,
		no_resize_name = true,
		no_grade = true,
		parent = var_29_0:findChildByName("mob_icon"),
		txt_name = var_29_5,
		txt_type = var_29_6
	})
	
	if not var_29_4 then
		if_set(var_29_5, nil, T(var_29_2))
		if_set_visible(var_29_0, "txt_big_count", false)
		if_set(var_29_6, nil, T(var_29_3))
	end
	
	local var_29_7 = var_29_0:findChildByName("btn_detail")
	
	if_set_visible(var_29_7, nil, var_29_4)
	
	var_29_0:findChildByName("btn_get").data = arg_29_1
	var_29_7.data = arg_29_1
	
	local var_29_8 = cc.c3b(255, 255, 255)
	
	if not arg_29_1:isActiveReward() then
		var_29_8 = cc.c3b(77, 77, 77)
	end
	
	if_set_color(var_29_0, "btn_get", var_29_8)
	
	return var_29_0
end
