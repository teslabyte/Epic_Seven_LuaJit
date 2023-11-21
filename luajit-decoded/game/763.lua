SPLMovableData = ClassDef(HTBMovableData)

function SPLMovableData.constructor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:base_constructor(arg_1_1, arg_1_2)
	
	if arg_1_1.preset_id then
		arg_1_0:setPreset(arg_1_1.preset_id)
	end
end

function SPLMovableData.getLevel(arg_2_0)
	arg_2_0:base_getLevel()
end

function SPLMovableData.setLeaderCode(arg_3_0, arg_3_1)
	arg_3_0.leader_code = arg_3_1
end

function SPLMovableData.setMoveCell(arg_4_0, arg_4_1)
	arg_4_0.move_cell = to_n(arg_4_1)
end

function SPLMovableData.getMoveCell(arg_5_0)
	return arg_5_0.move_cell or SPLWhiteboard:get("map_move_cell")
end

function SPLMovableData.setSightCell(arg_6_0, arg_6_1)
	arg_6_0.sight_cell = to_n(arg_6_1)
end

function SPLMovableData.getSightCell(arg_7_0)
	local var_7_0 = 3
	local var_7_1 = arg_7_0.sight_cell or SPLWhiteboard:get("map_sight_cell")
	
	return math.min(var_7_1, var_7_0)
end

function SPLMovableData.setNpcTeam(arg_8_0, arg_8_1)
	arg_8_0.npc_team = arg_8_1
end

function SPLMovableData.getNpcTeam(arg_9_0)
	return arg_9_0.npc_team
end

function SPLMovableData.setMoveSpeed(arg_10_0, arg_10_1)
	arg_10_0.move_speed = to_n(arg_10_1)
end

function SPLMovableData.getMoveSpeed(arg_11_0)
	local var_11_0 = 0.1
	local var_11_1 = arg_11_0.move_speed or 1
	
	return math.max(var_11_1, var_11_0)
end

function SPLMovableData.getPresetId(arg_12_0)
	return arg_12_0.preset_id
end

function SPLMovableData.setPreset(arg_13_0, arg_13_1)
	local var_13_0 = DBT("tile_sub_preset", arg_13_1, {
		"id",
		"leader_id",
		"npcteam_id",
		"sight_cell",
		"move_cell",
		"move_speed"
	})
	
	if not var_13_0 or not var_13_0.id then
		return 
	end
	
	arg_13_0.leader_code = var_13_0.leader_id
	arg_13_0.npc_team = var_13_0.npcteam_id
	arg_13_0.sight_cell = var_13_0.sight_cell
	arg_13_0.move_cell = var_13_0.move_cell
	arg_13_0.move_speed = var_13_0.move_speed
	arg_13_0.preset_id = arg_13_1
end
