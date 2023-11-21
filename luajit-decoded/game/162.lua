Team = {}
TeamUtil = TeamUtil or {}

local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	if ignore_crc32 then
		return 
	end
	
	if not bit then
		return 
	end
	
	if not bit.bxor64 then
		return 
	end
	
	if not bit.bhash64 then
		return 
	end
	
	local var_1_0 = math.random(268435456, 4294967295)
	
	local function var_1_1(arg_2_0, arg_2_1)
		if not arg_2_1 then
			return 
		end
		
		var_0_0[arg_2_0] = var_0_0[arg_2_0] or math.random(1, 1000)
		
		return bit.bhash64(arg_2_1 + var_0_0[arg_2_0])
	end
	
	local function var_1_2(arg_3_0, arg_3_1)
		if not arg_3_0 then
			return 
		end
		
		if arg_3_1 then
			if not arg_3_0 then
				return 
			end
			
			return bit.bxor64(arg_3_0[1] or 0, arg_3_0[2])
		end
		
		return {
			bit.bxor64(arg_3_0, var_1_0),
			var_1_0
		}
	end
	
	local function var_1_3(arg_4_0)
		local var_4_0 = {
			__index = function(arg_5_0, arg_5_1)
				local var_5_0 = getmetatable(arg_5_0)
				local var_5_1 = var_5_0.hash[arg_5_1]
				
				if var_5_1 then
					local var_5_2 = var_1_2(var_5_0.enval[arg_5_1], true)
					local var_5_3 = var_1_1(arg_5_1, var_5_2)
					
					if var_5_3 == var_5_1 then
					elseif not var_5_0.error[arg_5_1] then
						var_5_0.error[arg_5_1] = true
						
						if #g_UNIT_CONVIC < 5 then
							local var_5_4 = var_5_0.enval[arg_5_1] and var_5_0.enval[arg_5_1][1]
							local var_5_5 = var_5_0.enval[arg_5_1] and var_5_0.enval[arg_5_1][2]
							
							table.insert(g_UNIT_CONVIC, {
								reason = "mem." .. tostring(arg_5_1),
								k0 = arg_5_1,
								k1 = var_5_4,
								k2 = var_5_5,
								v0 = var_5_2,
								c0 = var_5_1,
								c1 = var_5_3
							})
						end
					end
					
					return var_5_2
				end
				
				return rawget(arg_5_0, arg_5_1)
			end,
			__newindex = function(arg_6_0, arg_6_1, arg_6_2)
				local var_6_0 = getmetatable(arg_6_0)
				
				if var_6_0.hash[arg_6_1] then
					var_6_0.enval[arg_6_1] = var_1_2(arg_6_2)
					var_6_0.hash[arg_6_1] = var_1_1(arg_6_1, arg_6_2)
					
					return 
				else
					Log.e("Team 리소스 추가는 makeTeam 에 인덱스 추가가 필요함")
					rawset(arg_6_0, arg_6_1, arg_6_2)
				end
			end,
			__pairs = function(arg_7_0)
				local function var_7_0(arg_8_0, arg_8_1)
					local var_8_0
					local var_8_1
					
					arg_8_1, var_8_1 = next(arg_8_0, arg_8_1)
					
					if var_8_1 then
						return arg_8_1, var_8_1
					end
				end
				
				local var_7_1
				local var_7_2
				local var_7_3 = {}
				
				repeat
					local var_7_4
					
					var_7_1, var_7_4 = next(arg_7_0, var_7_1)
					
					if var_7_1 then
						var_7_3[var_7_1] = var_7_4
					end
				until not var_7_4
				
				local var_7_5 = getmetatable(arg_7_0)
				local var_7_6
				
				repeat
					local var_7_7
					
					var_7_6, var_7_7 = next(var_7_5.enval, var_7_6)
					
					if var_7_6 then
						var_7_3[var_7_6] = var_1_2(var_7_7, true)
					end
				until not var_7_7
				
				return var_7_0, var_7_3, nil
			end
		}
		
		if getmetatable(arg_4_0) then
			return arg_4_0
		end
		
		local var_4_1 = {}
		local var_4_2 = {}
		local var_4_3 = {}
		
		for iter_4_0, iter_4_1 in pairs(arg_4_0) do
			if type(iter_4_1) == "number" then
				var_4_3[iter_4_0] = var_1_2(iter_4_1)
				var_4_2[iter_4_0] = var_1_1(iter_4_0, iter_4_1)
			else
				var_4_1[iter_4_0] = iter_4_1
			end
		end
		
		var_4_0.error = {}
		var_4_0.enval = var_4_3
		var_4_0.hash = var_4_2
		
		setmetatable(var_4_1, var_4_0)
		
		return var_4_1
	end
	
	local function var_1_4(arg_9_0)
		local var_9_0 = getmetatable(arg_9_0, nil)
		
		setmetatable(arg_9_0, nil)
		
		if var_9_0 and var_9_0.enval then
			for iter_9_0, iter_9_1 in pairs(var_9_0.enval) do
				arg_9_0[iter_9_0] = var_1_2(iter_9_1, true)
			end
		end
		
		return arg_9_0
	end
	
	if arg_1_1 then
		arg_1_0(var_1_3)
	else
		arg_1_0(var_1_4)
	end
end

local function var_0_2(arg_10_0, arg_10_1)
	if ignore_crc32 then
		return 
	end
	
	local var_10_0 = math.random(268435456, 4294967295)
	
	local function var_10_1(arg_11_0, arg_11_1)
		return crc32_string(tostring(arg_11_0), arg_11_1)
	end
	
	local function var_10_2(arg_12_0, arg_12_1)
		if not arg_12_0 then
			return 
		end
		
		if arg_12_1 then
			if not arg_12_0 then
				return 
			end
			
			local var_12_0, var_12_1 = math.modf(tonumber(arg_12_0[2]) or 0)
			
			return bit.bxor(arg_12_0[1] or 0, arg_12_0[3]) + var_12_1
		end
		
		local var_12_2, var_12_3 = math.modf(arg_12_0)
		
		return {
			bit.bxor(var_12_2, var_10_0),
			var_12_3,
			var_10_0
		}
	end
	
	local function var_10_3(arg_13_0)
		local var_13_0 = {
			__index = function(arg_14_0, arg_14_1)
				local var_14_0 = getmetatable(arg_14_0)
				local var_14_1 = var_14_0.crc32[arg_14_1]
				
				if var_14_1 then
					local var_14_2 = var_10_2(var_14_0.enval[arg_14_1], true)
					
					if var_10_1(arg_14_1, var_14_2) == var_14_1 then
					elseif not var_14_0.error[arg_14_1] then
						var_14_0.error[arg_14_1] = true
						
						if #g_UNIT_CONVIC < 5 then
						end
					end
					
					return var_14_2
				end
				
				return rawget(arg_14_0, arg_14_1)
			end,
			__newindex = function(arg_15_0, arg_15_1, arg_15_2)
				local var_15_0 = getmetatable(arg_15_0)
				
				if var_15_0.crc32[arg_15_1] then
					var_15_0.enval[arg_15_1] = var_10_2(arg_15_2)
					var_15_0.crc32[arg_15_1] = var_10_1(arg_15_1, arg_15_2)
					
					return 
				end
				
				Log.e("Team 리소스 추가는 makeTeam 에 인덱스 추가가 필요함")
				rawset(arg_15_0, arg_15_1, arg_15_2)
			end,
			__pairs = function(arg_16_0)
				local function var_16_0(arg_17_0, arg_17_1)
					local var_17_0
					local var_17_1
					
					arg_17_1, var_17_1 = next(arg_17_0, arg_17_1)
					
					if var_17_1 then
						return arg_17_1, var_17_1
					end
				end
				
				local var_16_1
				local var_16_2
				local var_16_3 = {}
				
				repeat
					local var_16_4
					
					var_16_1, var_16_4 = next(arg_16_0, var_16_1)
					
					if var_16_1 then
						var_16_3[var_16_1] = var_16_4
					end
				until not var_16_4
				
				local var_16_5 = getmetatable(arg_16_0)
				local var_16_6
				
				repeat
					local var_16_7
					
					var_16_6, var_16_7 = next(var_16_5.enval, var_16_6)
					
					if var_16_6 then
						var_16_3[var_16_6] = var_10_2(var_16_7, true)
					end
				until not var_16_7
				
				return var_16_0, var_16_3, nil
			end
		}
		
		if getmetatable(arg_13_0) then
			return arg_13_0
		end
		
		local var_13_1 = {}
		local var_13_2 = {}
		local var_13_3 = {}
		local var_13_4 = {}
		
		for iter_13_0, iter_13_1 in pairs(arg_13_0) do
			if type(iter_13_1) == "number" then
				var_13_4[iter_13_0] = var_10_2(iter_13_1)
				var_13_2[iter_13_0] = var_10_1(iter_13_0, iter_13_1)
			else
				var_13_1[iter_13_0] = iter_13_1
			end
		end
		
		var_13_0.error = {}
		var_13_0.enval = var_13_4
		var_13_0.crc32 = var_13_2
		
		setmetatable(var_13_1, var_13_0)
		
		return var_13_1
	end
	
	local function var_10_4(arg_18_0)
		local var_18_0 = getmetatable(arg_18_0, nil)
		
		setmetatable(arg_18_0, nil)
		
		if var_18_0 and var_18_0.enval then
			for iter_18_0, iter_18_1 in pairs(var_18_0.enval) do
				arg_18_0[iter_18_0] = var_10_2(iter_18_1, true)
			end
		end
		
		return arg_18_0
	end
	
	if arg_10_0 and arg_10_0.vars then
		if arg_10_1 then
			arg_10_0.vars = var_10_3(arg_10_0.vars)
		else
			arg_10_0.vars = var_10_4(arg_10_0.vars)
		end
	end
end

function TeamUtil.getTeamPoint(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_3 = arg_19_3 or {}
	
	local var_19_0 = arg_19_3.team or Account:getTeam(arg_19_1)
	local var_19_1 = 0
	local var_19_2 = 0
	
	for iter_19_0 = 1, 10 do
		local var_19_3 = var_19_0[iter_19_0]
		
		if var_19_3 and var_19_3.is_unit then
			if iter_19_0 <= 4 and not var_19_3:isSummon() then
				var_19_2 = var_19_2 + 1
			end
			
			local var_19_4 = Team:makeTeamData(var_19_0)
			local var_19_5 = Team:makeTeam(var_19_4)
			
			for iter_19_1, iter_19_2 in pairs(var_19_5.units) do
				if not var_19_3:isNPC() and var_19_3:getUID() == iter_19_2:getUID() then
					var_19_3.inst.pos = iter_19_2.inst.pos
				end
			end
			
			if arg_19_3.formation and arg_19_2 then
				var_19_5:addManuallyDevoteStats(arg_19_2)
			end
			
			var_19_3:onSetupTeam(var_19_5)
			
			if var_19_3.calc then
				var_19_3:calc()
			end
			
			if (arg_19_3.no_summon or SceneManager:getCurrentSceneName() == "pvp") and var_19_3:isSummon() then
			else
				local var_19_6 = var_19_3:getPoint()
				
				if var_19_3:isGrowthBoostRegistered() then
					var_19_6 = var_19_3:getGrowthBoostPoint()
				end
				
				var_19_1 = var_19_1 + var_19_6
			end
			
			var_19_3:onSetupTeam(nil)
			
			var_19_3.inst.pos = nil
			
			if var_19_3.calc then
				var_19_3:calc()
			end
		end
	end
	
	if arg_19_3.formation and arg_19_2 and var_19_2 <= 4 then
		var_19_1 = var_19_1 + arg_19_2:getPoint()
	end
	
	return var_19_1
end

function Team.makeTeamData(arg_20_0, arg_20_1)
	local var_20_0 = {
		passive = {},
		units = {}
	}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		local var_20_1 = iter_20_1.code or iter_20_1.db and iter_20_1.db.code
		
		if DB("character", var_20_1, "id") then
			table.insert(var_20_0.units, {
				unit = iter_20_1,
				pos = iter_20_0,
				reward = iter_20_1.reward,
				external_passive = iter_20_1.external_passive
			})
		else
			var_20_0.pet = iter_20_1
		end
	end
	
	return var_20_0
end

function Team.makeTeam(arg_21_0, arg_21_1, arg_21_2)
	local function var_21_0(arg_22_0, arg_22_1)
		if not arg_22_0:isSummon() and not arg_22_0:isOrganizable() then
			return 
		end
		
		if arg_22_1.equips then
			for iter_22_0, iter_22_1 in pairs(arg_22_1.equips) do
				local var_22_0 = EQUIP:createByInfo(iter_22_1)
				
				if var_22_0 then
					arg_22_0:addEquip(var_22_0, true)
				end
			end
		end
		
		if arg_22_1.external_passive then
			for iter_22_2, iter_22_3 in pairs(arg_22_1.external_passive) do
				arg_22_0:addExternalPassive(iter_22_3.passive_id, iter_22_3.passive_lv)
			end
		end
		
		if arg_22_1.reward then
			for iter_22_4, iter_22_5 in pairs(arg_22_1.reward) do
				arg_22_0[iter_22_4] = iter_22_5
			end
		end
		
		return arg_22_0
	end
	
	local var_21_1 = {}
	
	var_21_1.summon_spoint = 0
	var_21_1.units = {}
	var_21_1.pet = arg_21_1.pet
	var_21_1.passive_skills = table.shallow_clone(arg_21_1.passive or {})
	
	for iter_21_0, iter_21_1 in pairs(arg_21_1.units) do
		local var_21_2
		local var_21_3 = tonumber(iter_21_1.pos)
		
		if var_21_3 and iter_21_1.unit then
			if iter_21_1.unit.db and iter_21_1.unit.db.code and type(iter_21_1.unit.clone) == "function" then
				var_21_2 = iter_21_1.unit:clone(true, arg_21_2)
			elseif iter_21_1.unit.code then
				local var_21_4 = not arg_21_2
				
				var_21_2 = UNIT:create(table.clone(iter_21_1.unit), var_21_4, arg_21_2)
			end
			
			local var_21_5 = var_21_0(var_21_2, iter_21_1)
			
			if var_21_5 then
				var_21_5:onSetupTeam(var_21_1)
				var_21_5:setPos(var_21_3, not arg_21_1.setup_line)
				
				if var_21_5:isSummon() then
					var_21_1.summon = var_21_5
				else
					table.insert(var_21_1.units, var_21_5)
				end
				
				if iter_21_1.template_status then
					appy_template_status(var_21_5, iter_21_1.template_status)
					
					var_21_5.template_id = iter_21_1.unit.template_id
				end
				
				if var_21_5.inst.code == "cleardummy" then
					var_21_5.inst.hp = 0
					var_21_5.inst.dead = true
				end
			end
		end
	end
	
	if not arg_21_2 then
		for iter_21_2, iter_21_3 in pairs(var_21_1.units) do
			iter_21_3:calc()
		end
	end
	
	copy_functions(Team, var_21_1)
	var_21_1:makeDevoteStats()
	
	var_21_1.vars = var_21_1.vars or {}
	
	local var_21_6 = {
		"morale",
		"turn",
		"soul_piece"
	}
	
	for iter_21_4, iter_21_5 in pairs(var_21_6) do
		var_21_1.vars[iter_21_5] = 0
	end
	
	if not arg_21_2 then
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_23_0)
				var_21_1.vars = arg_23_0(var_21_1.vars)
			end, true)
		else
			var_0_2(var_21_1, true)
		end
	end
	
	return var_21_1
end

function Team.alignTeam(arg_24_0, arg_24_1)
	arg_24_0.ally = arg_24_1
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.units) do
		iter_24_1.inst.ally = arg_24_1
	end
	
	if arg_24_1 == FRIEND then
		for iter_24_2, iter_24_3 in pairs(arg_24_0.units) do
			iter_24_3.inst.line = iter_24_3.inst.pos == 1 and FRONT or BACK
		end
	end
end

function Team.addRes(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars then
		arg_25_0.vars = {}
	end
	
	if arg_25_2 > 0 and arg_25_1 == "soul_piece" and arg_25_0:isLockGainSoulpiece() then
		return 
	end
	
	if LIMIT_TEAM_RES[arg_25_1] then
		arg_25_0.vars[arg_25_1] = math.max(0, math.min(LIMIT_TEAM_RES[arg_25_1] or 0, (arg_25_0.vars[arg_25_1] or 0) + (arg_25_2 or 1)))
	else
		arg_25_0.vars[arg_25_1] = (tonumber(arg_25_0.vars[arg_25_1]) or 0) + (arg_25_2 or 1)
	end
end

function Team.setRes(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0.vars then
		arg_26_0.vars = {}
	end
	
	arg_26_0.vars[arg_26_1] = arg_26_2
end

function Team.getRes(arg_27_0, arg_27_1)
	if not arg_27_0.vars then
		return 
	end
	
	return arg_27_0.vars[arg_27_1]
end

function Team.getPoint(arg_28_0)
	local var_28_0 = 0
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.units) do
		var_28_0 = var_28_0 + iter_28_1:getPoint()
	end
	
	return var_28_0
end

function Team.getUnit(arg_29_0, arg_29_1)
	for iter_29_0, iter_29_1 in pairs(arg_29_0.units) do
		if iter_29_0 == arg_29_1 then
			return iter_29_1
		end
	end
end

function Team.getUnitIndex(arg_30_0, arg_30_1)
	for iter_30_0, iter_30_1 in pairs(arg_30_0.units) do
		if iter_30_1 == arg_30_1 then
			return iter_30_0
		end
	end
end

function Team.getUnitDevoteStats(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1 or not arg_31_1.db then
		return 
	end
	
	local var_31_0, var_31_1, var_31_2 = DB("character", arg_31_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot",
		"devotion_skill_self"
	})
	
	if var_31_0 and var_31_1 and var_31_2 then
		local var_31_3, var_31_4, var_31_5 = arg_31_1:getDevoteSkill()
		
		local function var_31_6(arg_32_0, arg_32_1)
			if not arg_32_1[arg_32_0] then
				arg_32_1[arg_32_0] = {}
			end
			
			if var_31_3 then
				table.insert(arg_32_1[arg_32_0], {
					type = var_31_3,
					stat = var_31_4,
					uid = arg_31_1.inst.uid,
					self_effect = var_31_5
				})
			end
		end
		
		if var_31_5 then
			local var_31_7 = tostring(arg_31_1.inst.pos or 0)
			
			var_31_6(var_31_7, arg_31_2)
		else
			local var_31_8 = string.split(var_31_1, ";")
			
			for iter_31_0, iter_31_1 in pairs(var_31_8) do
				if not arg_31_2[iter_31_1] then
					arg_31_2[iter_31_1] = {}
				end
				
				var_31_6(iter_31_1, arg_31_2)
			end
		end
	end
end

function Team.makeDevoteStats(arg_33_0)
	local var_33_0 = {}
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.units or {}) do
		if not iter_33_1:isSupporter() and not iter_33_1:isSummon() then
			arg_33_0:getUnitDevoteStats(iter_33_1, var_33_0)
		end
	end
	
	arg_33_0.devote_stats = var_33_0
end

function Team.addManuallyDevoteStats(arg_34_0, arg_34_1)
	arg_34_0:getUnitDevoteStats(arg_34_1, arg_34_0:getDevoteStats())
end

function Team.getDevoteStats(arg_35_0)
	return arg_35_0.devote_stats or {}
end

function Team.setReserveDrops(arg_36_0, arg_36_1)
	if arg_36_1 then
		arg_36_0.reserved_drops = arg_36_1
	end
end

function Team.getReserveDrops(arg_37_0)
	return arg_37_0.reserved_drops
end

function Team.getArtifacts(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_1 or Account:getTeam()
	
	if not var_38_0 then
		return {}
	end
	
	local var_38_1 = {}
	
	for iter_38_0, iter_38_1 in pairs(var_38_0) do
		if iter_38_1 and iter_38_1.is_unit then
			local var_38_2 = iter_38_1:getArtifact()
			
			if var_38_2 then
				var_38_2.owner = iter_38_1
				
				table.insert(var_38_1, var_38_2)
			end
		end
	end
	
	return var_38_1
end

function Team.getSubStoryCurrencyBonusArtifactsCount(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0, var_39_1 = arg_39_0:getSubStoryCurrencyBonusArtifacts(arg_39_1, arg_39_2, arg_39_3)
	
	return table.count(var_39_0)
end

function Team.isLockGainSoulpiece(arg_40_0)
	for iter_40_0, iter_40_1 in pairs(arg_40_0.units or {}) do
		if not iter_40_1:isDead() and iter_40_1.states:isExistEffect("CSP_SOULLOCK") then
			return true
		end
	end
	
	return false
end

local function var_0_3(arg_41_0, arg_41_1)
	if not arg_41_1 then
		return false
	end
	
	if tolua.type(arg_41_1) == "string" then
		arg_41_1 = {
			arg_41_1
		}
	end
	
	if table.empty(arg_41_1) then
		return false
	end
	
	local var_41_0, var_41_1, var_41_2 = BattleReady:GetReqPointAndRewards(arg_41_0)
	
	if table.empty(var_41_2) then
		return false
	end
	
	for iter_41_0, iter_41_1 in pairs(arg_41_1) do
		for iter_41_2, iter_41_3 in pairs(var_41_2) do
			if iter_41_1 == iter_41_3[1] then
				return true
			end
		end
	end
	
	return false
end

function Team.getSubStoryCurrencyBonusArtifacts(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if not arg_42_2 then
		Log.e("서브스토리 아티펙트 정보가 없습니다.")
		
		return {}, {}
	end
	
	local var_42_0 = {}
	local var_42_1 = {}
	local var_42_2 = arg_42_0:getArtifacts(arg_42_1)
	
	for iter_42_0, iter_42_1 in pairs(arg_42_2) do
		local var_42_3
		
		for iter_42_2, iter_42_3 in pairs(var_42_2) do
			if iter_42_0 == iter_42_3.code and (not var_42_3 or var_42_3.dup_pt < iter_42_3.dup_pt) then
				var_42_3 = iter_42_3
			end
		end
		
		local var_42_4 = {
			info = iter_42_1
		}
		
		if var_42_3 then
			local var_42_5 = var_0_3(arg_42_3, iter_42_1.token)
			
			var_42_4.unit = var_42_3.owner
			var_42_4.equip = var_42_3
			var_42_4.exp = var_42_3.exp
			var_42_4.dup_pt = var_42_3.dup_pt
			var_42_4.is_apply = var_42_5
			var_42_0[iter_42_0] = var_42_4
		else
			var_42_4.equip = EQUIP:createByInfo({
				code = iter_42_0
			}) or {}
			var_42_4.is_apply = false
			var_42_1[iter_42_0] = var_42_4
		end
	end
	
	return var_42_0, var_42_1
end

function Team.getGrowthBonusArtifactsCount(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0:getGrowthBonusArtifacts(arg_43_1, arg_43_2)
	
	return table.count(var_43_0)
end

function Team.getGrowthBonusApplyArtifactsCount(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0:getGrowthBonusArtifacts(arg_44_1, arg_44_2)
	local var_44_1 = 0
	
	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		if iter_44_1.is_apply then
			var_44_1 = var_44_1 + 1
		end
	end
	
	return var_44_1
end

function Team.getSubStoryCurrencyBonusApplyArtifactsCount(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0, var_45_1 = arg_45_0:getSubStoryCurrencyBonusArtifacts(arg_45_1, arg_45_2, arg_45_3)
	local var_45_2 = 0
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		if iter_45_1.is_apply then
			var_45_2 = var_45_2 + 1
		end
	end
	
	return var_45_2
end

function Team.getGrowthBonusArtifacts(arg_46_0, arg_46_1, arg_46_2)
	local function var_46_0(arg_47_0)
		local var_47_0 = arg_47_0.db.content_opts
		
		if not var_47_0 then
			return false
		end
		
		return ({
			exp = true,
			intimacy = true
		})[var_47_0.type]
	end
	
	local function var_46_1(arg_48_0)
		local var_48_0 = arg_48_0.db.content_opts
		
		if not var_48_0.level_type then
			return true
		end
		
		return arg_46_2 and var_48_0.level_type[arg_46_2]
	end
	
	local function var_46_2(arg_49_0)
		if not arg_49_0.db.content_opts.target then
			return false
		end
		
		return arg_49_0.db.content_opts.target:lower() == "self"
	end
	
	local var_46_3 = {}
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0:getArtifacts(arg_46_1)) do
		if var_46_0(iter_46_1) then
			local var_46_4 = {
				unit = iter_46_1.owner,
				equip = iter_46_1,
				is_apply = var_46_1(iter_46_1),
				type = iter_46_1.db.content_opts.type,
				is_target_self = var_46_2(iter_46_1),
				value = iter_46_1.db.content_opts.value or 0
			}
			
			table.insert(var_46_3, var_46_4)
		end
	end
	
	local function var_46_5(arg_50_0)
		if not arg_50_0.is_apply then
			return false
		end
		
		if arg_50_0.is_target_self then
			return false
		end
		
		if arg_50_0.type ~= "exp" then
			return false
		end
		
		return true
	end
	
	local var_46_6 = 0
	local var_46_7 = 0
	
	for iter_46_2, iter_46_3 in pairs(var_46_3) do
		if var_46_5(iter_46_3) then
			if var_46_6 < iter_46_3.value then
				var_46_6 = iter_46_3.value
				
				if var_46_7 ~= 0 then
					var_46_3[var_46_7].is_apply = false
				end
				
				var_46_7 = iter_46_2
				iter_46_3.is_apply = true
			else
				iter_46_3.is_apply = false
			end
		end
	end
	
	return var_46_3
end

function Team.serialize(arg_51_0)
	local var_51_0 = {
		units = {}
	}
	
	for iter_51_0, iter_51_1 in pairs(arg_51_0.units or {}) do
		var_51_0.units[iter_51_1:getUID()] = iter_51_1:exportData()
	end
	
	return var_51_0
end

function Team.deserialize(arg_52_0, arg_52_1)
	for iter_52_0, iter_52_1 in pairs(arg_52_1.units or {}) do
		for iter_52_2, iter_52_3 in pairs(arg_52_0.units or {}) do
			if iter_52_3:getUID() == tonumber(iter_52_0) then
				iter_52_3:restoreData(iter_52_1)
			end
		end
	end
end
