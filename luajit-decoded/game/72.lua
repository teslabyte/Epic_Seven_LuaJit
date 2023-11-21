URGENT_MISSION_STATE = {}
URGENT_MISSION_STATE.INACTIVE = 0
URGENT_MISSION_STATE.READY = 1
URGENT_MISSION_STATE.ACTIVE = 2
URGENT_MISSION_STATE.CLEAR = 3

function MsgHandler.open_urgent_mission_system(arg_1_0)
	ConditionContentsManager:getUrgentMissions():setUpdate(arg_1_0.ug_m_list, arg_1_0.condition_group_list)
	ConditionContentsManager:getUrgentMissions():openSystem()
end

function MsgHandler.remove_urgent_mission(arg_2_0)
	if arg_2_0.missionid and arg_2_0.ug_m then
		ConditionContentsManager:getUrgentMissions():removeMission(arg_2_0.missionid, arg_2_0.ug_m)
	end
end

function MsgHandler.push_urgent_mission(arg_3_0)
	if arg_3_0.ug_m and arg_3_0.mission_id then
		local var_3_0 = ConditionContentsManager:getUrgentMissions()
		
		var_3_0:setMissionData(arg_3_0.mission_id, arg_3_0.ug_m)
		
		if arg_3_0.condition_group then
			var_3_0:setConditionGroupData(arg_3_0.mission_id, arg_3_0.condition_group)
		end
		
		var_3_0:updateMissionConditions()
	end
end

UrgentMissions = UrgentMissions or {}

copy_functions(ConditionContents, UrgentMissions)

function UrgentMissions.init(arg_4_0)
	arg_4_0._isOpenSystem = nil
	arg_4_0.noti_urgent_missions = nil
	arg_4_0.contents_type = CONTENTS_TYPE.URGENT_MISSION
	
	if UnlockSystem:isUnlockUrgentSystem() then
		arg_4_0._isOpenSystem = true
		
		arg_4_0:updateMissionConditions()
	end
end

function UrgentMissions.openSystem(arg_5_0)
	arg_5_0._isOpenSystem = true
end

function UrgentMissions.setUpdate(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_1 then
		for iter_6_0, iter_6_1 in pairs(arg_6_1) do
			for iter_6_2, iter_6_3 in pairs(iter_6_1) do
				arg_6_0:setMissionData(iter_6_2, iter_6_3)
			end
		end
	end
	
	arg_6_0:updateMissionConditions()
	
	if AdvMissionNavigator then
		AdvMissionNavigator:updateUrgentMissionList()
	end
end

function UrgentMissions.setMissionData(arg_7_0, arg_7_1, arg_7_2)
	Account:setUrgentMission(arg_7_1, arg_7_2)
end

function UrgentMissions.getScore(arg_8_0, arg_8_1)
	local var_8_0 = Account:getUrgentMissions()
	
	if var_8_0[arg_8_1] == nil then
		return 0
	end
	
	local var_8_1, var_8_2 = DB("mission_data", arg_8_1, {
		"condition",
		"value"
	})
	
	return arg_8_0:getScore_datas(var_8_0, arg_8_1, var_8_1, var_8_2)
end

function UrgentMissions.getConditionScore(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or 1
	
	local var_9_0 = Account:getUrgentMissions()
	
	return arg_9_0:getConditionScore_datas(var_9_0, arg_9_1, arg_9_2)
end

function UrgentMissions.createMission(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0, var_10_1 = DB("mission_data", arg_10_1, {
		"condition",
		"value"
	})
	
	if var_10_0 and var_10_1 then
		local var_10_2 = arg_10_0:getMissionData(arg_10_1)
		
		if var_10_2 and var_10_2.state == URGENT_MISSION_STATE.ACTIVE and not arg_10_0:createGroupHandler(arg_10_1, var_10_0, var_10_1, arg_10_2) then
			Log.e("UrgentMissions error - function() createMission", arg_10_1, var_10_0, var_10_1)
		end
	end
	
	AdvWorldMapController:refreshUrgentMissionIcon(arg_10_1)
end

function UrgentMissions.clear(arg_11_0)
	arg_11_0.events_map = {}
	arg_11_0.condition_groups = {}
end

function UrgentMissions.updateMissionConditions(arg_12_0)
	arg_12_0:clear()
	
	local var_12_0 = Account:getUrgentMissions() or {}
	
	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_1.state == URGENT_MISSION_STATE.ACTIVE then
			arg_12_0:createMission(iter_12_0, arg_12_0:getScore(iter_12_0))
		end
	end
end

function UrgentMissions.isOpenSystem(arg_13_0)
	return arg_13_0._isOpenSystem
end

function UrgentMissions.update(arg_14_0, arg_14_1)
	if not arg_14_1.doc_urgent_mission_attri then
		return 
	end
	
	arg_14_0:setMissionData(arg_14_1.contents_id, arg_14_1.doc_urgent_mission_attri)
	arg_14_0:setUpdateConditionCurScore(arg_14_1.contents_id, nil, arg_14_1.doc_urgent_mission_attri.score1)
	
	if arg_14_1.doc_urgent_mission_attri.state == URGENT_MISSION_STATE.CLEAR then
		arg_14_0:removeGroup(arg_14_1.contents_id)
	end
end

function UrgentMissions.expireMission(arg_15_0)
	local var_15_0, var_15_1 = arg_15_0:getOverRemainTimeMissionData()
	
	if var_15_0 and var_15_1 then
		local var_15_2 = arg_15_0:getMissionData(var_15_0)
		
		if var_15_2 then
			var_15_2.state = URGENT_MISSION_STATE.READY
			
			query("remove_urgent_mission", {
				urgent_m = var_15_0
			})
			print(var_15_0, "remove!!!!!")
		end
	end
end

function UrgentMissions.getOverRemainTimeMissionData(arg_16_0)
	local var_16_0 = Account:getUrgentMissions()
	
	for iter_16_0, iter_16_1 in pairs(var_16_0 or {}) do
		if iter_16_1.end_time <= os.time() and iter_16_1.state ~= URGENT_MISSION_STATE.READY and iter_16_1.state ~= URGENT_MISSION_STATE.INACTIVE then
			return iter_16_0, iter_16_1
		end
	end
end

function UrgentMissions.removeMission(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:setMissionData(arg_17_1, arg_17_2)
	arg_17_0:removeGroup(arg_17_1)
	
	if AdvMissionNavigator then
		AdvMissionNavigator:updateUrgentMissionList()
	end
	
	arg_17_0:updateMissionConditions()
end

function UrgentMissions.updateTime(arg_18_0)
	if not arg_18_0._isOpenSystem then
		return 
	end
	
	arg_18_0:expireMission()
	arg_18_0:setNotiTimeUpdate()
end

function UrgentMissions.getRemainTime(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:getMissionData(arg_19_1)
	
	if not var_19_0 then
		return 0
	end
	
	if var_19_0.end_time <= os.time() then
		return 0
	end
	
	return var_19_0.end_time - os.time()
end

function UrgentMissions.getInBattleMissions(arg_20_0, arg_20_1)
	local var_20_0 = {}
	local var_20_1 = {}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.condition_groups or {}) do
		if DB("mission_data", iter_20_0, {
			"area_enter_id"
		}) == arg_20_1 then
			local var_20_2 = {
				ukey = iter_20_1:getUniqueKey(),
				contents_type = iter_20_1:getContentsType()
			}
			
			table.insert(var_20_0, var_20_2)
			
			for iter_20_2, iter_20_3 in pairs(iter_20_1:getHandlerList()) do
				local var_20_3 = {}
				
				var_20_3.score, var_20_3.ukey = iter_20_3:getAddCount(), iter_20_3:getUniqueKey()
				var_20_3.group_ukey = iter_20_1:getUniqueKey()
				
				table.insert(var_20_1, var_20_3)
			end
		end
	end
	
	if #var_20_0 <= 0 then
		return 
	end
	
	return var_20_0, var_20_1
end

function UrgentMissions.checkUrgentMissionsInDungeon(arg_21_0, arg_21_1)
	local var_21_0 = Account:getUrgentMissions()
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		if iter_21_1.state == URGENT_MISSION_STATE.ACTIVE and DB("mission_data", iter_21_0, {
			"area_enter_id"
		}) == arg_21_1 then
			return iter_21_0, arg_21_0:getRemainTime(iter_21_0)
		end
	end
	
	return nil
end

function UrgentMissions.getActiveMissionCount(arg_22_0)
	local var_22_0 = 0
	local var_22_1 = Account:getUrgentMissions()
	
	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		if iter_22_1.state == URGENT_MISSION_STATE.ACTIVE then
			var_22_0 = var_22_0 + 1
		end
	end
	
	return var_22_0
end

function UrgentMissions.getMissionData(arg_23_0, arg_23_1)
	return (Account:getUrgentMissions() or {})[arg_23_1]
end

function UrgentMissions.isCleared(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0:getMissionData(arg_24_1)
	
	if var_24_0 then
		return var_24_0.clear_count > 0
	end
end

function UrgentMissions.pushUrgentMission(arg_25_0, arg_25_1)
	query("push_urgent_mission", {
		mission_id = arg_25_1
	})
end

function UrgentMissions.setNoti(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0, var_26_1, var_26_2, var_26_3, var_26_4 = DB("mission_data", arg_26_2, {
		"icon",
		"name",
		"desc2",
		"icon2",
		"area_enter_id"
	})
	
	print("mission_id", arg_26_2, var_26_0)
	if_set(arg_26_1, "txt_title", T(var_26_1))
	if_set(arg_26_1, "txt_desc", T(var_26_2))
	if_set_sprite(arg_26_1, "img_face", "face/" .. var_26_0 .. "_s.png")
	
	local var_26_5 = arg_26_0:getRemainTime(arg_26_2)
	
	if_set(arg_26_1, "txt_time", T("remain_time") .. " :" .. sec_to_full_string(var_26_5, true))
	if_set_sprite(arg_26_1, "cm_icon_battleraid_76", "map/" .. var_26_3 .. ".png")
	if_set(arg_26_1, "label_name", sec_to_string(var_26_5))
	
	arg_26_0.noti_lb = arg_26_1:getChildByName("txt_time")
	arg_26_0.noti_simbol_lb = arg_26_1:getChildByName("label_name")
	arg_26_0.noti_mission_id = arg_26_2
	
	local var_26_6 = arg_26_1:getChildByName("btn_move")
	
	if get_cocos_refid(var_26_6) then
		var_26_6.enter_id = var_26_4
	end
end

function UrgentMissions.setNotiTimeUpdate(arg_27_0)
	if get_cocos_refid(arg_27_0.noti_lb) and get_cocos_refid(arg_27_0.noti_simbol_lb) and arg_27_0.noti_mission_id then
		local var_27_0 = arg_27_0:getRemainTime(arg_27_0.noti_mission_id)
		
		if var_27_0 <= 0 then
			arg_27_0.noti_lb:setString(T("urgent_time_expire"))
			arg_27_0.noti_simbol_lb:setString(T("urgent_time_expire"))
		else
			arg_27_0.noti_lb:setString(T("remain_time") .. " :" .. sec_to_full_string(var_27_0, true))
			arg_27_0.noti_simbol_lb:setString(sec_to_string(var_27_0))
		end
	end
end

function UrgentMissions.initNoti(arg_28_0)
	arg_28_0.noti = false
	arg_28_0.noti_lb = nil
	arg_28_0.noti_simbol_lb = nil
	arg_28_0.noti_mission_id = nil
	arg_28_0.area_enter_id = nil
end

function UrgentMissions.showNoti(arg_29_0, arg_29_1, arg_29_2)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	arg_29_0:initNoti()
	
	local var_29_0 = DB("mission_data", arg_29_2, {
		"name"
	})
	local var_29_1 = Dialog:open("wnd/cm_timemission", arg_29_0, {})
	
	arg_29_0:setNoti(var_29_1, arg_29_2)
	var_29_1:getChildByName("window_frame"):setScale(0.5)
	arg_29_1:addChild(var_29_1)
	UIAction:Add(LOG(SCALE_TO(200, 1)), var_29_1:getChildByName("window_frame"), "block")
end

UrgentMissionMove = UrgentMissionMove or {}

function UrgentMissionMove.showReady(arg_30_0, arg_30_1)
	if BackPlayManager:isRunning() then
		local var_30_0, var_30_1 = BackPlayUtil:checkAdventureInBackPlay()
		
		if not var_30_0 then
			balloon_message_with_sound(var_30_1)
			
			return 
		end
	end
	
	BattleTopBarUrgentPopup:close_urgentMissionPopup()
	BackPlayControlBox:close()
	MusicBoxUI:close()
	BattleReady:hide(true)
	BattleReady:show({
		ignore_block = true,
		enter_id = arg_30_1,
		callback = arg_30_0
	})
end

function UrgentMissionMove.onStartBattle(arg_31_0, arg_31_1)
	Dialog:closeAll()
	print("입장:" .. arg_31_1.enter_id)
	startBattle(arg_31_1.enter_id, arg_31_1)
	BattleReady:hide()
end

function HANDLER.cm_timemission(arg_32_0, arg_32_1)
	local var_32_0 = ConditionContentsManager:getUrgentMissions()
	
	if arg_32_1 == "btn_ok" then
		Dialog:close("cm_timemission")
		var_32_0:initNoti()
	elseif arg_32_1 == "btn_move" then
		Dialog:close("cm_timemission")
		UrgentMissionMove:showReady(arg_32_0.enter_id)
		var_32_0:initNoti()
	end
end
