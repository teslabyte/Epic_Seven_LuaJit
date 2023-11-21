SPLMissionData = SPLMissionData or {}
SPLMissionData.vars = {}

function SPLMissionData.init(arg_1_0)
	arg_1_0.vars.db_mission_groups = {}
	arg_1_0.vars.db_missions = {}
	arg_1_0.vars.show_missions = {}
	
	for iter_1_0 = 1, 99999 do
		local var_1_0 = DBNFields("tile_sub_mission", iter_1_0, {
			"id",
			"group",
			"index",
			"mission_type",
			"mission_value",
			"mission_desc",
			"use_object"
		})
		
		if not var_1_0.id then
			break
		end
		
		arg_1_0.vars.db_mission_groups[var_1_0.group] = arg_1_0.vars.db_mission_groups[var_1_0.group] or {}
		
		if #arg_1_0.vars.db_mission_groups ~= var_1_0.group then
			Log.e("SPLMissionData", "data 에러, group index가 유효하지 않습니다.")
			
			break
		end
		
		local var_1_1 = var_1_0.mission_value:split(",")
		
		for iter_1_1 = 1, #var_1_1 do
			var_1_1[iter_1_1] = string.trim(var_1_1[iter_1_1])
		end
		
		var_1_0.mission_object_ids = var_1_1
		var_1_0.mission_value = nil
		arg_1_0.vars.db_mission_groups[var_1_0.group][var_1_0.index] = var_1_0
		
		if #arg_1_0.vars.db_mission_groups[var_1_0.group] ~= var_1_0.index then
			Log.e("SPLMissionData", "data 에러, group[" .. index .. "] 가 유효하지 않습니다.")
			
			break
		end
		
		arg_1_0.vars.db_missions[var_1_0.id] = var_1_0
	end
end

function SPLMissionData.getMissionGroups(arg_2_0)
	if not arg_2_0.vars.db_mission_groups then
		arg_2_0:init()
	end
	
	return arg_2_0.vars.db_mission_groups
end

function SPLMissionData.getObjectsCompleteCount(arg_3_0, arg_3_1)
	if not arg_3_0.vars.db_mission_groups then
		arg_3_0:init()
	end
	
	local var_3_0 = arg_3_0.vars.db_missions[arg_3_1]
	
	if not var_3_0 then
		return false
	end
	
	local var_3_1 = 0
	
	for iter_3_0, iter_3_1 in pairs(var_3_0.mission_object_ids) do
		if SPLObjectSystem:isObjectCompleted(iter_3_1) then
			var_3_1 = var_3_1 + 1
		end
	end
	
	return var_3_1
end

function SPLMissionData.isMissionCompleted(arg_4_0, arg_4_1)
	if not arg_4_0.vars.db_mission_groups then
		arg_4_0:init()
	end
	
	local var_4_0 = arg_4_0.vars.db_missions[arg_4_1]
	
	if not var_4_0 then
		return false
	end
	
	for iter_4_0, iter_4_1 in pairs(var_4_0.mission_object_ids) do
		if not SPLObjectSystem:isObjectCompleted(iter_4_1) then
			return false
		end
	end
	
	return true
end

function SPLMissionData.getShowMissions(arg_5_0)
	return arg_5_0.vars.show_missions
end

function SPLMissionData.updateShowMissions(arg_6_0)
	local var_6_0 = arg_6_0:getMissionGroups()
	
	arg_6_0.vars.show_missions = {}
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		local var_6_1 = {}
		
		for iter_6_2, iter_6_3 in pairs(iter_6_1) do
			var_6_1.id = iter_6_3.id
			var_6_1.object_complete_count = arg_6_0:getObjectsCompleteCount(iter_6_3.id)
			var_6_1.object_ids = iter_6_3.mission_object_ids
			var_6_1.is_complete = var_6_1.object_complete_count == #var_6_1.object_ids
			var_6_1.desc = T(iter_6_3.mission_desc)
			
			if not var_6_1.is_complete then
				break
			end
		end
		
		table.insert(arg_6_0.vars.show_missions, var_6_1)
	end
	
	if arg_6_0.onUpdateShowMissions then
		arg_6_0.onUpdateShowMissions(arg_6_0.vars.show_missions)
	end
end

function SPLMissionData.updateMissionCompletes(arg_7_0)
	if not arg_7_0.vars.show_missions then
		arg_7_0:updateShowMissions()
	end
	
	local var_7_0 = {}
	local var_7_1 = false
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.show_missions) do
		if iter_7_1.is_complete == false then
			local var_7_2 = arg_7_0:getObjectsCompleteCount(iter_7_1.id)
			
			if iter_7_1.object_complete_count ~= var_7_2 then
				var_7_1 = true
				
				if var_7_2 == #iter_7_1.object_ids then
					table.insert(var_7_0, iter_7_1.id)
				end
			end
		end
	end
	
	if var_7_1 then
		arg_7_0:updateShowMissions()
		
		for iter_7_2, iter_7_3 in pairs(var_7_0) do
			arg_7_0:onMissionComplete(iter_7_3)
		end
	end
end

function SPLMissionData.onMissionComplete(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.db_missions[arg_8_1]
	
	if not var_8_0 then
		return 
	end
	
	if var_8_0.use_object then
		SPLObjectSystem:onUseObjectByKey(var_8_0.use_object)
	end
end
