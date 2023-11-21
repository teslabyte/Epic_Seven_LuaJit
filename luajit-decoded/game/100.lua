HIDDEN_MISSION_STATE = {}
HIDDEN_MISSION_STATE.ACTIVE = 0
HIDDEN_MISSION_STATE.CLEAR = 1
HIDDEN_MISSION_STATE.COMPLETE = 2
HIDDEN_MISSION_TYPE = {}
HIDDEN_MISSION_TYPE.CUSTOM_PROFILE = "custom_profile"

function MsgHandler.complete_hidden_mission(arg_1_0)
	local var_1_0 = ConditionContentsManager:getContents(CONTENTS_TYPE.HIDDEN_MISSION)
	
	if not var_1_0 then
		Log.e("HiddenMission", "not found HIDDEN_MISSION content.")
		
		return 
	end
	
	local var_1_1 = {}
	
	for iter_1_0, iter_1_1 in pairs(arg_1_0.complete_missions or {}) do
		var_1_0:update(iter_1_1)
		
		if iter_1_1 and iter_1_1.mission_data and iter_1_1.mission_data.mission_id then
			table.insert(var_1_1, iter_1_1.mission_data.mission_id)
		end
	end
	
	if arg_1_0.mission_type == HIDDEN_MISSION_TYPE.CUSTOM_PROFILE then
		CustomProfileCardEditor:showMissionRewardPopup(var_1_1)
	end
end

HiddenMission = HiddenMission or {}

copy_functions(ConditionContents, HiddenMission)

function HiddenMission.init(arg_2_0)
	arg_2_0.contents_type = CONTENTS_TYPE.HIDDEN_MISSION
end

function HiddenMission.initConditionListner(arg_3_0)
	arg_3_0:clear()
	
	for iter_3_0 = 1, 99999 do
		local var_3_0, var_3_1, var_3_2 = DBN("mission_contents", iter_3_0, {
			"id",
			"condition",
			"value"
		})
		
		if not var_3_0 then
			break
		end
		
		arg_3_0:addConditionListner(var_3_0, var_3_1, var_3_2)
	end
end

function HiddenMission.addConditionListner(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if string.empty(arg_4_1) then
		Log.e("HiddenMission", "invalid id.")
		
		return 
	end
	
	if string.empty(arg_4_2) or string.empty(arg_4_3) then
		Log.e("HiddenMission", "empty condition or value. id = " .. arg_4_1)
		
		return 
	end
	
	local var_4_0 = Account:getHiddenMission(arg_4_1)
	
	if not var_4_0.state or to_n(var_4_0.state) < HIDDEN_MISSION_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1)
		
		if not arg_4_0:createGroupHandler(arg_4_1, arg_4_2, arg_4_3) then
			Log.e("HiddenMission", "failed create group. id = " .. arg_4_1)
			
			return 
		end
	end
end

function HiddenMission.update(arg_5_0, arg_5_1)
	if not arg_5_1 or not arg_5_1.mission_data then
		Log.e("HiddenMission", "not found mission_data.")
		
		return 
	end
	
	local var_5_0 = arg_5_1.mission_data
	
	Account:setHiddenMission(var_5_0)
	arg_5_0:setUpdateConditionCurScore(var_5_0.mission_id, nil, to_n(var_5_0.score1))
	
	if to_n(var_5_0.state) >= HIDDEN_MISSION_STATE.CLEAR then
		arg_5_0:removeGroup(var_5_0.mission_id)
	end
end

function HiddenMission.getState(arg_6_0, arg_6_1)
	local var_6_0 = Account:getHiddenMission(arg_6_1)
	
	if not var_6_0.state then
		return HIDDEN_MISSION_STATE.ACTIVE
	end
	
	return to_n(var_6_0.state)
end

function HiddenMission.isCleared(arg_7_0, arg_7_1)
	return arg_7_0:getState(arg_7_1) >= HIDDEN_MISSION_STATE.CLEAR
end

function HiddenMission.isCompleted(arg_8_0, arg_8_1)
	return arg_8_0:getState(arg_8_1) >= HIDDEN_MISSION_STATE.COMPLETE
end

function HiddenMission.isExistClearedMission(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(Account:getHiddenMissions()) do
		if arg_9_0:getState(iter_9_0) == HIDDEN_MISSION_STATE.CLEAR and DB("mission_contents", iter_9_0, "type") == arg_9_1 then
			return true
		end
	end
	
	return false
end

function HiddenMission.getClearedMissionIds(arg_10_0, arg_10_1)
	local var_10_0 = {}
	
	for iter_10_0, iter_10_1 in pairs(Account:getHiddenMissions()) do
		if arg_10_0:getState(iter_10_0) == HIDDEN_MISSION_STATE.CLEAR and DB("mission_contents", iter_10_0, "type") == arg_10_1 then
			table.insert(var_10_0, iter_10_0)
		end
	end
	
	return var_10_0
end

function HiddenMission.getScore(arg_11_0, arg_11_1)
	local var_11_0 = Account:getHiddenMission(arg_11_1)
	
	return to_n(var_11_0.score1)
end

function HiddenMission.getConditionScore(arg_12_0, arg_12_1, arg_12_2)
	return arg_12_0:getScore(arg_12_1)
end

function HiddenMission.getNotifierControl(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0:isCleared(arg_13_2.contents_id) then
		return nil
	end
	
	local var_13_0, var_13_1, var_13_2 = DB("mission_contents", arg_13_2.contents_id, {
		"id",
		"type",
		"profile_id"
	})
	
	if not var_13_0 then
		Log.e("HiddenMission", "not found row of mission_contents. id = " .. arg_13_2.contents_id)
		
		return nil
	end
	
	local var_13_3
	
	if var_13_1 == HIDDEN_MISSION_TYPE.CUSTOM_PROFILE then
		local var_13_4, var_13_5, var_13_6 = DB("item_material_profile", var_13_2, {
			"id",
			"material_id",
			"bg_img"
		})
		
		if not var_13_4 then
			Log.e("HiddenMission", "not found row of item_material_profile. id = " .. var_13_2)
			
			return nil
		end
		
		local var_13_7, var_13_8, var_13_9 = DB("item_material", var_13_5, {
			"id",
			"icon",
			"desc"
		})
		
		if not var_13_7 then
			Log.e("HiddenMission", "not found row of item_material. id = " .. var_13_5)
			
			return nil
		end
		
		var_13_3 = arg_13_0:createNotifyControl(#arg_13_1, var_13_1, var_13_9, var_13_8, var_13_6)
		
		if get_cocos_refid(var_13_3) then
			var_13_3.args = {
				var_13_1,
				var_13_9,
				var_13_8,
				var_13_6
			}
			
			table.insert(arg_13_1, var_13_3)
		end
	end
	
	return var_13_3
end

function HiddenMission.createNotifyControl(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = cc.CSLoader:createNode("wnd/achievement_complete_etc.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_14_0)
	var_14_0:setAnchorPoint(0, 0)
	var_14_0:setName("achivnoti_" .. arg_14_1)
	var_14_0:setGlobalZOrder(999999)
	var_14_0:setLocalZOrder(999999)
	if_set_visible(var_14_0, "spr_emblem", false)
	
	if arg_14_2 == HIDDEN_MISSION_TYPE.CUSTOM_PROFILE then
		UIUtil:setNotifyTextControl(var_14_0, T("ma_badge_name"), T(arg_14_3))
		if_set_visible(var_14_0, "n_badge", true)
		
		if not string.empty(arg_14_4) then
			if_set_sprite(var_14_0, "img_badge", "profile/badge/" .. arg_14_4 .. ".png")
		end
		
		if not string.empty(arg_14_5) then
			if_set_sprite(var_14_0, "n_bg", "img/" .. arg_14_5 .. ".png")
		end
	end
	
	return var_14_0
end
