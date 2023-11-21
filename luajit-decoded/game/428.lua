PetUtil = {}

function PetUtil.isPetEnableMap(arg_1_0, arg_1_1)
	if not arg_1_1 then
		return 
	end
	
	local var_1_0, var_1_1, var_1_2 = DB("level_enter", arg_1_1, {
		"type",
		"sub_type",
		"auto_battle_able"
	})
	
	if var_1_2 and var_1_2 == "y" then
		return false
	end
	
	if var_1_0 == "defense_quest" or var_1_0 == "dungeon_quest" or var_1_0 == "quest" or var_1_0 == "extra_quest" or var_1_0 == "genie" or var_1_0 == "hunt" or var_1_0 == "urgent" or var_1_0 == "descent" or var_1_0 == "burning" then
		return true
	end
	
	return false
end

function PetUtil.isRepeatBattleEnableMap(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return 
	end
	
	local var_2_0, var_2_1, var_2_2 = DB("level_enter", arg_2_1, {
		"type",
		"sub_type",
		"auto_battle_able"
	})
	
	if var_2_2 and var_2_2 == "y" then
		return false
	end
	
	if var_2_1 and var_2_1 == "crack" or var_2_0 == "defense_quest" or var_2_0 == "quest" or var_2_0 == "extra_quest" or var_2_0 == "genie" or var_2_0 == "hunt" or var_2_0 == "descent" or var_2_0 == "burning" then
		return true
	end
	
	return false
end

function PetUtil.set_repeatBattle(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3 or {}
	
	arg_3_1 = arg_3_1 or BattleRepeat.map_id
	
	if not arg_3_1 then
		Log.e("맵아이디가 없을 수 없다.")
		
		return false
	end
	
	if not BattleRepeat:getCheckBoxValue() then
		return false
	end
	
	if var_3_0.is_npc_team then
		return false
	end
	
	if not Account:isMapCleared(arg_3_1) or not arg_3_2 or string.starts(arg_3_1, "tot") or not BattleRepeat:check_cleared_ije005() then
		BattleRepeat:setConfigRepeatPlay(false)
		
		return false
	end
	
	if BackPlayManager:isRunning() then
		return false
	end
	
	local var_3_1, var_3_2 = DB("level_enter", arg_3_1, {
		"type",
		"contents_type"
	})
	
	if arg_3_0:isRepeatBattleEnableMap(arg_3_1) and arg_3_2:getType() == "battle" then
		local var_3_3, var_3_4 = BattleRepeat:getConfigRepeatBattleCount(var_3_0.team_idx)
		local var_3_5 = arg_3_2:getRepeat_count()
		
		if var_3_5 < var_3_3 or var_3_4 then
			var_3_3 = var_3_5
			
			BattleRepeat:setConfigRepeatBattleCount(var_3_3, var_3_0.is_descent and Account:getDescentPetTeamIdx() or var_3_0.is_burning and Account:getBurningPetTeamIdx() or var_3_0.is_crehunt and Account:getCrehuntTeamIndex())
		end
		
		BattleRepeat:set_repeatMaxCount(var_3_3)
		
		return true
	else
		BattleRepeat:setConfigRepeatPlay(false)
		
		return false
	end
	
	return false
end

function PetUtil.getLayoutPosition(arg_4_0, arg_4_1)
	local var_4_0
	local var_4_1
	local var_4_2
	local var_4_3, var_4_4 = DB("pet_character", arg_4_1, {
		"location",
		"pet_offset"
	})
	local var_4_5
	
	if var_4_3 == "ground" then
		var_4_0 = 1.6
		var_4_1 = -1
		var_4_5 = 101
	else
		var_4_0 = -1.4
		var_4_1 = 3
		var_4_5 = -101
	end
	
	if var_4_4 then
		local var_4_6 = string.split(var_4_4)
		
		var_4_0 = var_4_0 + to_n(var_4_6[1])
		var_4_1 = var_4_1 + to_n(var_4_6[2])
		var_4_5 = var_4_5 + to_n(var_4_6[3])
	end
	
	return var_4_0, var_4_1, var_4_5
end

function PetUtil.isRecognizable(arg_5_0, arg_5_1, arg_5_2)
	if not PetUtil:isEnableAutoClick() then
		return false
	end
	
	if not arg_5_2 then
		return false
	end
	
	local var_5_0 = {
		"gate_cross",
		"gate_portal",
		"clear",
		"npc",
		"npc_shop",
		"warp",
		"obstacle",
		"item_crystal",
		"switch",
		"switch_mel"
	}
	
	if table.isInclude(var_5_0, arg_5_2) then
		return false
	end
	
	return true
end

function PetUtil.isEnableAutoClick(arg_6_0)
	if SAVE:getKeep("app.auto_battle") == true or BattleRepeat:isPlayingRepeatPlay() or BackPlayManager:isRunning() then
		return true
	end
	
	return false
end

function PetUtil.getPatGachaEventTbl(arg_7_0, arg_7_1)
	local var_7_0 = DBT("pet_gacha_event", arg_7_1, {
		"id",
		"npc_offset",
		"main_pet",
		"background",
		"npc_text"
	})
	
	if var_7_0 == nil or var_7_0.id == nil then
		return nil
	end
	
	return var_7_0
end

function PetUtil.getComposeAddPercents(arg_8_0, arg_8_1)
	return (DB("pet_grade", "pg_" .. arg_8_1, "add_per"))
end

function PetUtil.getCurrentSynthesisPercent(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2:isMaxGrade() then
		return nil
	end
	
	local var_9_0 = PetUtil:getComposeAddPercents(arg_9_2:getComposeTargetGrade())
	
	if not var_9_0 then
		return nil
	end
	
	local var_9_1 = PetUtil:getComposeBasePercent(arg_9_2:getComposeTargetGrade())
	local var_9_2 = var_9_0 * arg_9_1
	
	return var_9_1, var_9_2
end

function PetUtil.getComposeBasePercent(arg_10_0, arg_10_1)
	return (DB("pet_grade", "pg_" .. arg_10_1, "compose"))
end

function PetUtil.getComposeSynPoint(arg_11_0, arg_11_1)
	return (DB("pet_grade", "pg_" .. arg_11_1, "syn_point"))
end

function PetUtil.getUsableComposeMaxMaterial(arg_12_0, arg_12_1)
	local var_12_0 = "ma_petpoint"
	local var_12_1 = arg_12_1:getComposeTargetGrade()
	
	return arg_12_0:getComposeSynPoint(var_12_1) or 0
end
