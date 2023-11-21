SPLMissionUI = SPLMissionUI or {}
SPLMissionUI.MAX_MISSION = 5
SPLMissionUI.vars = {}

function SPLMissionUI.initUI(arg_1_0, arg_1_1)
	if not get_cocos_refid(arg_1_1) then
		return 
	end
	
	arg_1_0.vars.n_goal = arg_1_1
	arg_1_0.vars.n_missions = {}
	
	for iter_1_0 = 1, arg_1_0.MAX_MISSION do
		arg_1_0.vars.n_missions[iter_1_0] = arg_1_0.vars.n_goal:getChildByName(string.format("n_mission%02d", iter_1_0))
		
		if_set_visible(arg_1_0.vars.n_missions[iter_1_0], nil, false)
	end
	
	function SPLMissionData.onUpdateShowMissions(arg_2_0)
		SPLEventSystem:addCallbackOnFinish(function()
			SPLMissionUI:updateMissions(arg_2_0)
		end, "update_missions")
	end
end

function SPLMissionUI.onEnter(arg_4_0)
	if not get_cocos_refid(arg_4_0.vars.n_goal) then
		return 
	end
	
	local function var_4_0(arg_5_0)
		local var_5_0 = arg_4_0.vars.n_goal:getChildByName(arg_5_0)
		
		if get_cocos_refid(var_5_0) then
			local var_5_1 = var_5_0:getOpacity() / 255
			
			var_5_0:setOpacity(0)
			SPLEventSystem:addCallbackOnFinish(function()
				UIAction:Add(OPACITY(400, 0, var_5_1), var_5_0)
			end, arg_5_0)
		end
	end
	
	var_4_0("t_goal")
	var_4_0("bar1_l_0")
	var_4_0("grow")
end

function SPLMissionUI.close(arg_7_0)
	if not get_cocos_refid(arg_7_0.vars.n_goal) then
		return 
	end
	
	UIAction:Add(FADE_OUT(400), arg_7_0.vars.n_goal)
	
	arg_7_0.vars.n_missions = nil
end

function SPLMissionUI.isMissionChanged(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == nil and arg_8_2 == nil then
		return false
	end
	
	if arg_8_1 == nil and arg_8_2 ~= nil then
		return true
	end
	
	if arg_8_1 ~= nil and arg_8_2 == nil then
		return true
	end
	
	if arg_8_1.is_complete ~= arg_8_2.is_complete then
		return true
	end
	
	if arg_8_1.object_complete_count ~= arg_8_2.object_complete_count then
		return true
	end
	
	if arg_8_1.desc ~= arg_8_2.desc then
		return true
	end
	
	return false
end

function SPLMissionUI._setMissionUI(arg_9_0, arg_9_1, arg_9_2)
	if not get_cocos_refid(arg_9_1) then
		return 
	end
	
	local var_9_0 = arg_9_1:getChildByName("t_mission")
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	if not arg_9_1.data then
		return 
	end
	
	local var_9_1 = tocolor("#6bc11b")
	local var_9_2 = tocolor("#ffe795")
	local var_9_3 = arg_9_1:getChildByName("icon")
	
	if get_cocos_refid(var_9_3) then
		local var_9_4, var_9_5 = var_9_3:getPosition()
		
		if get_cocos_refid(var_9_3.effect) then
			var_9_3.effect:removeFromParent()
			
			var_9_3.effect = nil
		end
		
		var_9_3.effect = EffectManager:Play({
			fn = arg_9_1.data.is_complete and "ui_tile_mission_check" or "ui_tile_mission_compass",
			layer = arg_9_1,
			x = var_9_4,
			y = var_9_5
		})
		
		SoundEngine:play("event:/effect/tile_mission_clear_eff")
		var_9_3:setVisible(false)
	end
	
	local var_9_6 = arg_9_1.data.desc
	
	if #arg_9_1.data.object_ids > 1 then
		var_9_6 = var_9_6 .. string.format(" (%d/%d)", arg_9_1.data.object_complete_count, #arg_9_1.data.object_ids)
	end
	
	if_set(var_9_0, nil, var_9_6)
	if_set_color(var_9_0, nil, arg_9_1.data.is_complete and var_9_1 or var_9_2)
	
	arg_9_1.next_y = arg_9_2 - (var_9_0:getStringNumLines() - 1) * 19
end

function SPLMissionUI.setMissionUI(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not get_cocos_refid(arg_10_1) then
		return 
	end
	
	if not arg_10_2 then
		if_set_visible(arg_10_1, nil, false)
		
		return 
	end
	
	if_set_visible(arg_10_1, nil, true)
	
	arg_10_1._origin_pos_y = arg_10_1._origin_pos_y or arg_10_1:getPositionY()
	
	if_set_position_y(arg_10_1, nil, arg_10_1._origin_pos_y + arg_10_3)
	
	if arg_10_0:isMissionChanged(arg_10_1.data, arg_10_2) then
		local var_10_0 = arg_10_1:getChildByName("t_mission")
		
		if not get_cocos_refid then
			return 
		end
		
		local var_10_1 = arg_10_1.data and var_10_0:clone() or nil
		
		arg_10_1.data = arg_10_2
		
		arg_10_0:_setMissionUI(arg_10_1, arg_10_3)
		arg_10_0:slideMission(var_10_1, var_10_0)
	end
end

function SPLMissionUI.setMissionUIWithIndex(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.vars.n_missions then
		return 
	end
	
	arg_11_0:setMissionUI(arg_11_0, arg_11_0.vars.n_missions[arg_11_1], arg_11_2)
end

function SPLMissionUI.updateMissions(arg_12_0, arg_12_1)
	if not arg_12_1 then
		return 
	end
	
	if not arg_12_0.vars.n_missions then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.n_missions[1]) then
		return 
	end
	
	arg_12_0:setMissionUI(arg_12_0.vars.n_missions[1], arg_12_1[1], 0)
	
	for iter_12_0 = 2, arg_12_0.MAX_MISSION do
		local var_12_0 = arg_12_0.vars.n_missions[iter_12_0 - 1]
		local var_12_1 = arg_12_0.vars.n_missions[iter_12_0]
		
		arg_12_0:setMissionUI(var_12_1, arg_12_1[iter_12_0], var_12_0.next_y or 0)
	end
end

function SPLMissionUI.slideMission(arg_13_0, arg_13_1, arg_13_2)
	if not get_cocos_refid(arg_13_2) then
		return 
	end
	
	arg_13_2:setOpacity(0)
	
	arg_13_2.origin_pos_x = arg_13_2.origin_pos_x or arg_13_2:getPositionX()
	
	local var_13_0 = 100
	local var_13_1 = 300
	
	arg_13_2:setPosition(arg_13_2.origin_pos_x - var_13_0, arg_13_2:getPositionY())
	UIAction:Add(LOG(SPAWN(FADE_IN(var_13_1), MOVE_BY(var_13_1, var_13_0, 0))), arg_13_2, "mission_ui_effect")
	
	if get_cocos_refid(arg_13_1) then
		arg_13_2:getParent():addChild(arg_13_1)
		
		if arg_13_1:isVisible() then
			UIAction:Add(SEQ(LOG(SPAWN(FADE_OUT(var_13_1), MOVE_BY(var_13_1, var_13_0 * 0.2, 0))), REMOVE()), arg_13_1, "mission_ui_effect")
		else
			arg_13_1:removeFromParent()
			
			arg_13_1 = nil
		end
	end
end
