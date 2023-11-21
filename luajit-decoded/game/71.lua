DUNGEON_MISSION_STATE = {}
DUNGEON_MISSION_STATE.ACTIVE = 0
DUNGEON_MISSION_STATE.CLEAR = 1
DungeonMissions = DungeonMissions or {}

copy_functions(ConditionContents, DungeonMissions)

function DungeonMissions.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.BATTLE_MISSION
end

function DungeonMissions.clear(arg_2_0)
	local var_2_0 = BackPlayManager:getBattles()
	local var_2_1 = {}
	
	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if iter_2_1.logic and iter_2_1.logic.map and iter_2_1.logic.map.enter then
			table.insert(var_2_1, iter_2_1.logic.map.enter)
		end
	end
	
	local var_2_2 = BackPlayManager:getLastBattle()
	
	if var_2_2 and var_2_2.logic and var_2_2.logic.map and var_2_2.logic.map.enter and not table.find(var_2_1, var_2_2.logic.map.enter) then
		table.insert(var_2_1, var_2_2.logic.map.enter)
	end
	
	if SceneManager:getCurrentSceneName() == "battle" and Battle.logic then
		table.insert(var_2_1, Battle.logic.map.enter)
	end
	
	local function var_2_3(arg_3_0)
		if not arg_3_0 then
			return false
		end
		
		local var_3_0 = arg_3_0:getAreaEnterID()
		
		if not var_3_0 then
			return false
		end
		
		if table.find(var_2_1, var_3_0) then
			return true
		end
		
		return false
	end
	
	local var_2_4 = {}
	
	for iter_2_2, iter_2_3 in pairs(arg_2_0.condition_groups or {}) do
		if not var_2_3(iter_2_3) then
			arg_2_0:removeGroup(iter_2_2)
		end
	end
end

function DungeonMissions.startMissions(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:clear()
	
	for iter_4_0 = 1, 3 do
		local var_4_0 = DB("level_enter", arg_4_1, "mission" .. iter_4_0)
		
		if var_4_0 and var_4_0 and not Account:isDungeonMissionClearedByMissionId(arg_4_1, var_4_0) then
			local var_4_1, var_4_2, var_4_3 = DB("mission_data", var_4_0, {
				"condition",
				"value",
				"force_clear_quest"
			})
			
			if var_4_1 and var_4_2 then
				local var_4_4 = arg_4_0:createGroupHandler(var_4_0, var_4_1, var_4_2)
				
				if var_4_4 then
					var_4_4:setAreaEnterID(arg_4_1)
					
					if var_4_3 then
						var_4_4:setLinkQuest(var_4_3)
					end
					
					if arg_4_2 then
						var_4_4:setSubStoryID(arg_4_2)
					end
				end
			end
		end
	end
	
	for iter_4_1 = 1, 10 do
		local var_4_5 = DB("level_enter", arg_4_1, "hide_mission" .. iter_4_1)
		
		if var_4_5 and var_4_5 and not Account:isDungeonMissionClearedByMissionId(arg_4_1, var_4_5) then
			local var_4_6, var_4_7, var_4_8 = DB("mission_data", var_4_5, {
				"condition",
				"value",
				"force_clear_quest"
			})
			
			if var_4_6 and var_4_7 then
				local var_4_9 = arg_4_0:createGroupHandler(var_4_5, var_4_6, var_4_7)
				
				if var_4_9 then
					var_4_9:setAreaEnterID(arg_4_1)
					
					if var_4_8 then
						var_4_9:setLinkQuest(var_4_8)
					end
					
					if arg_4_2 then
						var_4_9:setSubStoryID(arg_4_2)
					end
				end
			end
		end
	end
end

function DungeonMissions.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	Account:setDungeonMissionState(arg_5_3, arg_5_1, arg_5_2)
end

function DungeonMissions.isMissionClearExpected(arg_6_0, arg_6_1)
	local var_6_0
	
	if Battle.logic then
		var_6_0 = Battle.logic:getBattleUID()
	end
	
	if not var_6_0 then
		return false
	end
	
	if not arg_6_0.condition_groups then
		return false
	end
	
	local var_6_1 = arg_6_0.condition_groups[arg_6_1]
	
	if var_6_1 then
		return var_6_1:isDoneExpectedCount(var_6_0) > 0
	end
end

function DungeonMissions.isCleared(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	
	local var_7_0 = arg_7_2.enter_id or DB("mission_data", arg_7_1, {
		"area_enter_id"
	})
	
	if var_7_0 and arg_7_1 then
		return Account:isDungeonMissionClearedByMissionId(var_7_0, arg_7_1)
	end
	
	return false
end

function DungeonMissions.getStageScore(arg_8_0, arg_8_1)
	local var_8_0 = 0
	
	for iter_8_0 = 1, 3 do
		local var_8_1 = DB("level_enter", arg_8_1, "mission" .. iter_8_0)
		
		if var_8_1 and var_8_1 and Account:isDungeonMissionClearedByMissionId(arg_8_1, var_8_1) then
			var_8_0 = var_8_0 + 1
		end
	end
	
	return var_8_0
end

TestConditionMissions = TestConditionMissions or {}

copy_functions(ConditionContents, TestConditionMissions)

function TestConditionMissions.init(arg_9_0)
	arg_9_0.contents_type = "test"
end

function TestConditionMissions.clear(arg_10_0)
	arg_10_0.events_map = {}
	arg_10_0.condition_groups = {}
end

function TestConditionMissions.addMission(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 and arg_11_2 then
		arg_11_0.id_num = arg_11_0.id_num or 1
		
		local var_11_0 = "test_cond_" .. tostring(arg_11_0.id_num)
		
		if arg_11_0:createGroupHandler(var_11_0, arg_11_1, arg_11_2) then
			arg_11_0.id_num = arg_11_0.id_num + 1
		end
	end
end

function TestConditionMissions.update(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
end
