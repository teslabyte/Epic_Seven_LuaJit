BattleStat = {}

function BattleStat.create(arg_1_0, arg_1_1)
	local var_1_0 = {}
	
	copy_functions(BattleStat, var_1_0)
	var_1_0:initStatistics(arg_1_1)
	
	return var_1_0
end

function BattleStat.initStatistics(arg_2_0, arg_2_1)
	arg_2_0.logic = arg_2_1
	arg_2_0.statistics = {}
	
	arg_2_0:initStartingUnit(arg_2_1)
end

function BattleStat.initStartingUnit(arg_3_0, arg_3_1)
	if arg_3_1 then
		arg_3_0.is_use_multi_team = false
		
		if arg_3_1.team_data and arg_3_1.team_data.subteams and not table.empty(arg_3_1.team_data.subteams) then
			arg_3_0.is_use_multi_team = true
			
			for iter_3_0, iter_3_1 in pairs(arg_3_1.team_data.subteams) do
				for iter_3_2, iter_3_3 in pairs(iter_3_1.units or {}) do
					if iter_3_3 and iter_3_3.unit then
						if not iter_3_3.unit then
							local var_3_0 = {}
						end
						
						local var_3_1 = Account:getUnit(iter_3_3.unit.id or 0)
						
						if var_3_1 then
							arg_3_0.statistics[var_3_1] = {
								shield = 0,
								def = 0,
								resurrect = 0,
								buff = 0,
								speed = 0,
								kill = 0,
								debuff = 0,
								heal = 0,
								att = 0,
								order = 0,
								unit = var_3_1,
								team_idx = iter_3_0 + 1
							}
						end
					end
				end
			end
		end
		
		for iter_3_4, iter_3_5 in pairs(arg_3_1.starting_friends or {}) do
			if iter_3_5 and not arg_3_0.statistics[iter_3_5] then
				local var_3_2
				
				if arg_3_0:isUseMultiTeam() then
					var_3_2 = 1
				end
				
				arg_3_0.statistics[iter_3_5] = {
					shield = 0,
					def = 0,
					resurrect = 0,
					buff = 0,
					speed = 0,
					kill = 0,
					debuff = 0,
					heal = 0,
					att = 0,
					order = 0,
					unit = iter_3_5,
					team_idx = var_3_2
				}
			end
		end
		
		local var_3_3 = arg_3_1.friend_hidden
		
		if arg_3_1.friend_hidden and not arg_3_0.statistics[var_3_3] then
			arg_3_0.statistics[var_3_3] = {
				shield = 0,
				def = 0,
				resurrect = 0,
				buff = 0,
				speed = 0,
				kill = 0,
				debuff = 0,
				heal = 0,
				att = 0,
				order = 0,
				unit = var_3_3
			}
		end
	end
end

function BattleStat.initContribution(arg_4_0, arg_4_1)
	if not arg_4_1 or type(arg_4_1) ~= "table" then
		return 
	end
	
	if not arg_4_1.db then
		return 
	end
	
	if arg_4_1.db.type ~= "character" and arg_4_1.db.type ~= "limited" and (arg_4_1.db.type ~= "monster" or arg_4_1.inst.ally ~= FRIEND) then
		return 
	end
	
	if arg_4_1 and not arg_4_0.statistics[arg_4_1] then
		local var_4_0
		
		if arg_4_0:isUseMultiTeam() then
			var_4_0 = arg_4_0:getTeamIndexFromMultiTeam(arg_4_1)
			
			arg_4_0:findAndRemove(arg_4_1, var_4_0)
		end
		
		arg_4_0.statistics[arg_4_1] = arg_4_0.statistics[arg_4_1] or {
			shield = 0,
			def = 0,
			resurrect = 0,
			buff = 0,
			speed = 0,
			kill = 0,
			debuff = 0,
			heal = 0,
			att = 0,
			order = 0,
			unit = arg_4_1,
			team_idx = var_4_0
		}
	end
end

function BattleStat.calc(arg_5_0, arg_5_1)
	local function var_5_0()
		if arg_5_0.logic:getFinalResult() == "win" then
			return FRIEND
		else
			return ENEMY
		end
	end
	
	local function var_5_1(arg_7_0)
		if arg_7_0 == 1 then
			return GAME_STATIC_VARIABLE.statistics_def_speed1 or 1
		elseif arg_7_0 == 2 then
			return GAME_STATIC_VARIABLE.statistics_def_speed2 or 1
		elseif arg_7_0 == 3 then
			return GAME_STATIC_VARIABLE.statistics_def_speed3 or 1
		end
		
		return 0
	end
	
	local function var_5_2()
		local var_8_0 = arg_5_0.logic:getStageCounter()
		
		if var_8_0 < 8 then
			return GAME_STATIC_VARIABLE.statistics_def_rev1 or 1
		elseif var_8_0 < 14 then
			return GAME_STATIC_VARIABLE.statistics_def_rev2 or 1
		elseif var_8_0 < 21 then
			return GAME_STATIC_VARIABLE.statistics_def_rev3 or 1
		elseif var_8_0 < 28 then
			return GAME_STATIC_VARIABLE.statistics_def_rev4 or 1
		elseif var_8_0 < 35 then
			return GAME_STATIC_VARIABLE.statistics_def_rev5 or 1
		else
			return GAME_STATIC_VARIABLE.statistics_def_rev6 or 1
		end
		
		return 0
	end
	
	arg_5_1 = arg_5_1 or arg_5_0.statistics or {}
	
	local var_5_3 = {}
	local var_5_4 = {}
	local var_5_5 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		if iter_5_0.db.code ~= "cleardummy" then
			var_5_4[iter_5_0] = {}
			var_5_4[iter_5_0].att = iter_5_1.att * (GAME_STATIC_VARIABLE.statistics_def_att or 1)
			var_5_4[iter_5_0].def = iter_5_1.def * (GAME_STATIC_VARIABLE.statistics_def_def or 1)
			var_5_4[iter_5_0].heal = (iter_5_1.heal + iter_5_1.shield) * (GAME_STATIC_VARIABLE.statistics_def_heal or 1)
			var_5_4[iter_5_0].resurrect = iter_5_1.resurrect * (GAME_STATIC_VARIABLE.statistics_def_resurrect or 3000)
			var_5_4[iter_5_0].base_contribution = var_5_4[iter_5_0].att + var_5_4[iter_5_0].def + var_5_4[iter_5_0].heal + var_5_4[iter_5_0].resurrect
		end
	end
	
	for iter_5_2, iter_5_3 in pairs(arg_5_1) do
		var_5_5[iter_5_2:getAlly()] = var_5_5[iter_5_2:getAlly()] or {
			all = 0,
			base = 0
		}
		var_5_5[iter_5_2:getAlly()].base = var_5_5[iter_5_2:getAlly()].base + var_5_4[iter_5_2].base_contribution
	end
	
	for iter_5_4, iter_5_5 in pairs(arg_5_1) do
		local var_5_6 = var_5_5[iter_5_4:getAlly()].base
		local var_5_7 = var_5_2()
		
		var_5_4[iter_5_4].debuff_count = iter_5_5.debuff
		var_5_4[iter_5_4].buff_count = iter_5_5.buff
		var_5_4[iter_5_4].kill_count = iter_5_5.kill
		var_5_4[iter_5_4].resurrect_count = iter_5_5.resurrect
		var_5_4[iter_5_4].debuff_bonus = var_5_6 * iter_5_5.debuff * (GAME_STATIC_VARIABLE.statistics_def_debuff or 1) * var_5_7
		var_5_4[iter_5_4].buff_bonus = var_5_6 * iter_5_5.buff * (GAME_STATIC_VARIABLE.statistics_def_buff or 1) * var_5_7
		var_5_4[iter_5_4].kill_bonus = var_5_6 * iter_5_5.kill * (GAME_STATIC_VARIABLE.statistics_def_kill or 1)
		var_5_4[iter_5_4].speed_bonus = var_5_6 * var_5_1(iter_5_5.order) * var_5_7
		
		if arg_5_0.logic:getStageCounter() < 16 then
			var_5_4[iter_5_4].speed_order = iter_5_5.order
		end
		
		var_5_4[iter_5_4].att_contribution = var_5_4[iter_5_4].att + var_5_4[iter_5_4].def + var_5_4[iter_5_4].heal
		var_5_4[iter_5_4].def_contribution = var_5_4[iter_5_4].buff_count + var_5_4[iter_5_4].debuff_count + var_5_4[iter_5_4].resurrect_count
		var_5_4[iter_5_4].all_contribution_att = var_5_4[iter_5_4].att + var_5_4[iter_5_4].debuff_bonus + var_5_4[iter_5_4].kill_bonus + var_5_4[iter_5_4].speed_bonus
		var_5_4[iter_5_4].all_contribution_def = var_5_4[iter_5_4].def + var_5_4[iter_5_4].heal + var_5_4[iter_5_4].resurrect + var_5_4[iter_5_4].buff_bonus
		var_5_4[iter_5_4].all_contribution = var_5_4[iter_5_4].all_contribution_att + var_5_4[iter_5_4].all_contribution_def
		var_5_4[iter_5_4].team_idx = iter_5_5.team_idx
		var_5_5[iter_5_4:getAlly()].all = var_5_5[iter_5_4:getAlly()].all + var_5_4[iter_5_4].all_contribution
	end
	
	for iter_5_6, iter_5_7 in pairs(var_5_4) do
		iter_5_7.uid = iter_5_6:getUID()
		iter_5_7.arena_uid = iter_5_6:getArenaUID()
		iter_5_7.code = iter_5_6.db.code
		iter_5_7.face_id = iter_5_6.db.face_id
		iter_5_7.ally = iter_5_6.inst.ally
		iter_5_7.is_supporter = iter_5_6:isSupporter()
		iter_5_7.team_base = var_5_5[iter_5_6:getAlly()].base
		iter_5_7.team_all = var_5_5[iter_5_6:getAlly()].all
		iter_5_7.total_turn = arg_5_0.logic:getStageCounter()
		
		table.push(var_5_3, iter_5_7)
	end
	
	table.sort(var_5_3, function(arg_9_0, arg_9_1)
		if arg_9_0.ally ~= arg_9_1.ally then
			return arg_9_0.ally == FRIEND
		end
		
		return arg_9_0.all_contribution > arg_9_1.all_contribution
	end)
	
	local var_5_8 = {
		att_contribution = 0,
		def_contribution = 0,
		all_contribution = 0
	}
	local var_5_9 = 0
	local var_5_10
	local var_5_11
	local var_5_12 = var_5_0()
	
	for iter_5_8, iter_5_9 in pairs(var_5_3) do
		local var_5_13 = math.max(iter_5_9.all_contribution_att, iter_5_9.all_contribution_def)
		
		if var_5_13 > var_5_8.all_contribution then
			var_5_8.all_contribution = var_5_13
		end
		
		local var_5_14 = iter_5_9.att_contribution
		
		if var_5_14 > var_5_8.att_contribution then
			var_5_8.att_contribution = var_5_14
		end
		
		local var_5_15 = iter_5_9.def_contribution
		
		if var_5_15 > var_5_8.def_contribution then
			var_5_8.def_contribution = var_5_15
		end
		
		if var_5_9 < iter_5_9.all_contribution and not iter_5_9.is_supporter and iter_5_9.ally == var_5_12 then
			var_5_9 = iter_5_9.all_contribution
			var_5_11 = iter_5_9.uid
			var_5_10 = iter_5_8
		end
	end
	
	if var_5_10 then
		var_5_3[var_5_10].is_mvp = true
	end
	
	return {
		highest_score = var_5_8,
		infos = var_5_3,
		mvp_uid = var_5_11
	}
end

function BattleStat.addStatistics(arg_10_0, arg_10_1)
	local var_10_0
	local var_10_1
	local var_10_2
	local var_10_3
	local var_10_4
	local var_10_5
	local var_10_6
	local var_10_7
	local var_10_8
	local var_10_9
	
	if arg_10_1.dec_hp then
		var_10_0 = to_n(arg_10_1.dec_hp) + to_n(arg_10_1.shield)
		
		local var_10_10 = FORMULA.dmg({
			att = 10000,
			bonus_att = 0
		}, {
			def = arg_10_1.target.status.def
		}) / 10000
		
		var_10_1 = to_n(arg_10_1.dec_hp) * (1 / var_10_10)
	end
	
	if arg_10_1.type == "heal" then
		var_10_2 = arg_10_1.heal
	end
	
	if arg_10_1.type == "resurrect" or arg_10_1.type == "resurrect_self" then
		var_10_3 = 1
	end
	
	if arg_10_1.type == "shield" then
		var_10_4 = arg_10_1.shield
	end
	
	if arg_10_1.type == "add_state" and arg_10_1.state and arg_10_1.state.db and arg_10_1.state.db.cs_icon then
		if arg_10_1.state.db.cs_type == "buff" then
			var_10_6 = 1
		elseif arg_10_1.state.db.cs_type == "debuff" then
			var_10_5 = 1
		end
	end
	
	if arg_10_1.type == "dead" then
		var_10_7 = 1
	end
	
	if arg_10_1.type == "@start_turn" and arg_10_1.order and arg_10_1.order < 4 then
		var_10_9 = arg_10_1.order
	end
	
	if var_10_0 and arg_10_1.from ~= arg_10_1.target then
		if var_10_0 then
			arg_10_0:addUnitStatistics(arg_10_1.from, "att", var_10_0)
		end
		
		if var_10_1 then
			arg_10_0:addUnitStatistics(arg_10_1.target, "def", var_10_1)
		end
	end
	
	if var_10_4 then
		arg_10_0:addUnitStatistics(arg_10_1.from, "shield", var_10_4)
	end
	
	if var_10_2 then
		arg_10_0:addUnitStatistics(arg_10_1.from, "heal", var_10_2)
	end
	
	if var_10_3 then
		arg_10_0:addUnitStatistics(arg_10_1.from, "resurrect", var_10_3)
	end
	
	if var_10_7 then
		arg_10_0:addUnitStatistics(arg_10_1.from, "kill", var_10_7)
	end
	
	if var_10_5 then
		arg_10_0:addUnitStatistics(arg_10_1.from, "debuff", var_10_5)
	end
	
	if var_10_6 then
		arg_10_0:addUnitStatistics(arg_10_1.from, "buff", var_10_6)
	end
	
	if var_10_9 then
		arg_10_0:addUnitStatistics(arg_10_1.unit, "order", var_10_9)
	end
end

function BattleStat.addUnitStatistics(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not arg_11_1 or not arg_11_3 or type(arg_11_1) ~= "table" then
		return 
	end
	
	local var_11_0 = arg_11_1
	
	if not var_11_0.db then
		return 
	end
	
	if var_11_0.inst.summon_by then
		local var_11_1 = arg_11_0.logic:findUnit(var_11_0.inst.summon_by)
		
		if not var_11_1 then
			return 
		end
		
		var_11_0 = var_11_1
	end
	
	if var_11_0.db.type ~= "character" and var_11_0.db.type ~= "limited" and (var_11_0.db.type ~= "monster" or var_11_0.inst.ally ~= FRIEND) then
		return 
	end
	
	if not arg_11_0.statistics[var_11_0] then
		local var_11_2
		
		if arg_11_0:isUseMultiTeam() then
			var_11_2 = arg_11_0:getTeamIndexFromMultiTeam(var_11_0)
			
			arg_11_0:findAndRemove(var_11_0, var_11_2)
		end
		
		arg_11_0.statistics[var_11_0] = {
			shield = 0,
			def = 0,
			resurrect = 0,
			buff = 0,
			speed = 0,
			kill = 0,
			debuff = 0,
			heal = 0,
			att = 0,
			order = 0,
			unit = var_11_0,
			team_idx = var_11_2
		}
	end
	
	if arg_11_0.logic and arg_11_0.logic:getKeySlotUnit() and arg_11_0.logic:getKeySlotUnit():getUID() == var_11_0:getUID() then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.statistics) do
			if iter_11_1.team_idx == var_11_0.group_team_idx and iter_11_1.unit:getUID() == var_11_0:getUID() then
				var_11_0 = iter_11_0
			end
		end
		
		arg_11_0.statistics[var_11_0][arg_11_2] = arg_11_0.statistics[var_11_0][arg_11_2] + arg_11_3
	else
		arg_11_0.statistics[var_11_0][arg_11_2] = arg_11_0.statistics[var_11_0][arg_11_2] + arg_11_3
	end
end

function BattleStat.getContribution(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.vars = arg_12_0.vars or {}
	arg_12_0.vars.highest_score, arg_12_0.vars.infos = arg_12_0:SelectMVP()
	
	local var_12_0 = {}
	local var_12_1 = {}
	local var_12_2 = {}
	local var_12_3 = {}
	local var_12_4 = 0
	local var_12_5 = 0
	local var_12_6
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.infos) do
		if iter_12_1.unit.inst.ally == arg_12_1 and iter_12_1[arg_12_2] and not math.is_nan_or_inf(iter_12_1[arg_12_2]) then
			var_12_4 = var_12_4 + iter_12_1[arg_12_2]
			
			if var_12_5 < iter_12_1[arg_12_2] then
				var_12_5 = iter_12_1[arg_12_2]
				var_12_6 = iter_12_1.unit.inst.code
			end
			
			table.insert(var_12_3, iter_12_1)
		end
	end
	
	for iter_12_2, iter_12_3 in pairs(var_12_3 or {}) do
		local var_12_7 = var_12_4 > 0 and math.floor(iter_12_3[arg_12_2] * 100 / var_12_4 + 0.5) or 0
		
		table.insert(var_12_0, {
			code = iter_12_3.unit.inst.code,
			score = var_12_7
		})
	end
	
	table.sort(var_12_0, function(arg_13_0, arg_13_1)
		return arg_13_0.score > arg_13_1.score
	end)
	
	for iter_12_4, iter_12_5 in pairs(var_12_0) do
		table.insert(var_12_1, iter_12_5.code)
		table.insert(var_12_2, iter_12_5.score)
	end
	
	return var_12_1, var_12_2, var_12_6
end

function BattleStat.isUseMultiTeam(arg_14_0)
	return arg_14_0.is_use_multi_team
end

function BattleStat.findAndRemove(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0:isUseMultiTeam() or not arg_15_1 or not arg_15_2 then
		return 
	end
	
	local var_15_0 = arg_15_1:getUID()
	local var_15_1
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.statistics) do
		if iter_15_1.unit then
			local var_15_2 = iter_15_1.unit:getUID()
			
			if iter_15_1.team_idx == arg_15_2 and var_15_2 == var_15_0 then
				var_15_1 = iter_15_0
				
				break
			end
		end
	end
	
	if var_15_1 then
		arg_15_0.statistics[var_15_1] = nil
	end
end

function BattleStat.getTeamIndexFromMultiTeam(arg_16_0, arg_16_1)
	if not arg_16_0:isUseMultiTeam() or not arg_16_0.logic then
		return 
	end
	
	local var_16_0 = arg_16_1:getUID()
	
	if not var_16_0 then
		return 
	end
	
	local var_16_1 = arg_16_0.logic:getGroupTeams()
	
	if not var_16_1 or table.empty(var_16_1) then
		return 
	end
	
	local var_16_2 = 1
	
	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		local var_16_3 = iter_16_1.units
		
		if var_16_3 and not table.empty(var_16_3) then
			for iter_16_2, iter_16_3 in pairs(var_16_3) do
				if iter_16_3 and iter_16_3.getUID and iter_16_3:getUID() == var_16_0 then
					var_16_2 = tonumber(iter_16_0)
					
					break
				end
			end
		end
	end
	
	return var_16_2
end

function BattleStat.SelectMVP(arg_17_0)
	local var_17_0 = arg_17_0:calc()
	
	return var_17_0.highest_score, var_17_0.infos, var_17_0.mvp_uid
end

function BattleStat.SelectMVP_multi(arg_18_0)
	local var_18_0 = {}
	local var_18_1 = {}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.statistics) do
		if iter_18_1.team_idx then
			if not var_18_1[iter_18_1.team_idx] then
				var_18_1[iter_18_1.team_idx] = {}
			end
			
			var_18_1[iter_18_1.team_idx][iter_18_0] = iter_18_1
		end
	end
	
	local var_18_2 = table.count(var_18_1)
	
	for iter_18_2 = 1, var_18_2 do
		if var_18_1[iter_18_2] then
			local var_18_3 = arg_18_0:calc(var_18_1[iter_18_2])
			
			if var_18_3 then
				var_18_0[iter_18_2] = var_18_3.mvp_uid
			end
		end
	end
	
	return var_18_0
end

function BattleStat.getContribution(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local function var_19_0(arg_20_0, arg_20_1)
		local var_20_0 = {}
		local var_20_1 = {}
		local var_20_2 = {}
		local var_20_3 = {}
		local var_20_4 = 0
		local var_20_5
		local var_20_6 = 0
		
		for iter_20_0, iter_20_1 in pairs(arg_20_1 or {}) do
			if iter_20_1[arg_20_0] and not math.is_nan_or_inf(iter_20_1[arg_20_0]) then
				var_20_4 = var_20_4 + iter_20_1[arg_20_0]
				
				if var_20_6 < iter_20_1[arg_20_0] then
					var_20_5 = iter_20_1.code
					var_20_6 = iter_20_1[arg_20_0]
				end
			end
		end
		
		for iter_20_2, iter_20_3 in pairs(arg_20_1 or {}) do
			local var_20_7 = var_20_4 > 0 and math.floor(iter_20_3[arg_20_0] * 100 / var_20_4 + 0.5) or 0
			
			table.insert(var_20_0, {
				code = iter_20_3.code,
				percent = var_20_7,
				score = iter_20_3[arg_20_0],
				contribution = iter_20_3.all_contribution
			})
		end
		
		table.sort(var_20_0, function(arg_21_0, arg_21_1)
			return arg_21_0.contribution > arg_21_1.contribution
		end)
		
		for iter_20_4, iter_20_5 in pairs(var_20_0) do
			table.insert(var_20_1, iter_20_5.code)
			table.insert(var_20_2, iter_20_5.score)
			table.insert(var_20_3, iter_20_5.percent)
		end
		
		return var_20_1, var_20_2, var_20_3, var_20_5, var_20_6
	end
	
	local var_19_1 = {}
	local var_19_2 = {}
	local var_19_3
	local var_19_4
	
	if arg_19_3 == FRIEND then
		for iter_19_0, iter_19_1 in pairs(arg_19_4.infos) do
			if iter_19_1.arena_uid == arg_19_2 then
				table.insert(var_19_2, iter_19_1)
			end
		end
	else
		for iter_19_2, iter_19_3 in pairs(arg_19_4.infos) do
			if iter_19_3.arena_uid ~= arg_19_2 then
				table.insert(var_19_2, iter_19_3)
			end
		end
	end
	
	if arg_19_1 == "all" then
		var_19_1.contributionHeroList, _, var_19_1.contributionPercentList, var_19_3, var_19_4 = var_19_0("all_contribution", var_19_2)
		_, var_19_1.contributionDamageInflictedList, var_19_1.contributionDamageInflictedPercentList = var_19_0("att", var_19_2)
		_, var_19_1.contributionDamageReceivedList, var_19_1.contributionDamageReceivedPercentList = var_19_0("def", var_19_2)
		_, var_19_1.contributionRecoveryList, var_19_1.contributionRecoveryPercentList = var_19_0("heal", var_19_2)
		_, var_19_1.contributionKillCountList = var_19_0("kill_count", var_19_2)
	elseif arg_19_1 == "att" then
		var_19_1.contributionHeroList, var_19_1.contributionPercentList = var_19_0("att_contribution", var_19_2)
	elseif arg_19_1 == "def" then
		var_19_1.contributionHeroList, var_19_1.contributionPercentList = var_19_0("def_contribution", var_19_2)
	end
	
	return var_19_1, var_19_3, var_19_4
end
