local var_0_0 = {}

UNIT = {}
var_0_0.maxInstId = var_0_0.maxInstId or 1
var_0_0.maxUid = var_0_0.maxUid or 1
var_0_0.CORE_NODE_NUM = 3
g_UNIT_CONVIC = {}

local function var_0_1(arg_1_0)
	if not arg_1_0 then
		return 
	end
	
	local var_1_0, var_1_1 = string.unpack(arg_1_0, ",")
	
	if var_1_1 == "hidden" then
		return nil, var_1_0
	end
	
	return var_1_0, var_1_0
end

local function var_0_2(arg_2_0, arg_2_1)
	return DBT("character", arg_2_0, {
		"bra",
		"int",
		"fai",
		"des"
	})
end

local var_0_3 = {}

local function var_0_4(arg_3_0, arg_3_1)
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
	
	local var_3_0 = math.random(268435456, 4294967295)
	
	local function var_3_1(arg_4_0, arg_4_1)
		if not arg_4_1 then
			return 
		end
		
		var_0_3[arg_4_0] = var_0_3[arg_4_0] or math.random(1, 1000)
		
		return bit.bhash64(arg_4_1 + var_0_3[arg_4_0])
	end
	
	local function var_3_2(arg_5_0, arg_5_1)
		if not arg_5_0 then
			return 
		end
		
		if arg_5_1 then
			if not arg_5_0 then
				return 
			end
			
			return bit.bxor64(arg_5_0[1] or 0, arg_5_0[2])
		end
		
		return {
			bit.bxor64(arg_5_0, var_3_0),
			var_3_0
		}
	end
	
	local function var_3_3(arg_6_0)
		local var_6_0 = {
			__index = function(arg_7_0, arg_7_1)
				local var_7_0 = getmetatable(arg_7_0)
				local var_7_1 = var_7_0.hash[arg_7_1]
				
				if var_7_1 then
					local var_7_2 = var_3_2(var_7_0.enval[arg_7_1], true)
					local var_7_3 = var_3_1(arg_7_1, var_7_2)
					
					if var_7_3 == var_7_1 then
					elseif not var_7_0.error[arg_7_1] then
						var_7_0.error[arg_7_1] = true
						
						if #g_UNIT_CONVIC < 5 then
							local var_7_4 = var_7_0.enval[arg_7_1] and var_7_0.enval[arg_7_1][1]
							local var_7_5 = var_7_0.enval[arg_7_1] and var_7_0.enval[arg_7_1][2]
							
							table.insert(g_UNIT_CONVIC, {
								reason = "mem." .. tostring(arg_7_1),
								k0 = arg_7_1,
								k1 = var_7_4,
								k2 = var_7_5,
								v0 = var_7_2,
								c0 = var_7_1,
								c1 = var_7_3
							})
						end
					end
					
					return var_7_2
				end
				
				return rawget(arg_7_0, arg_7_1)
			end,
			__newindex = function(arg_8_0, arg_8_1, arg_8_2)
				local var_8_0 = getmetatable(arg_8_0)
				
				if var_8_0.hash[arg_8_1] then
					var_8_0.enval[arg_8_1] = var_3_2(arg_8_2)
					var_8_0.hash[arg_8_1] = var_3_1(arg_8_1, arg_8_2)
					
					return 
				else
					rawset(arg_8_0, arg_8_1, arg_8_2)
				end
			end,
			__pairs = function(arg_9_0)
				local function var_9_0(arg_10_0, arg_10_1)
					local var_10_0
					local var_10_1
					
					arg_10_1, var_10_1 = next(arg_10_0, arg_10_1)
					
					if var_10_1 then
						return arg_10_1, var_10_1
					end
				end
				
				local var_9_1
				local var_9_2
				local var_9_3 = {}
				
				repeat
					local var_9_4
					
					var_9_1, var_9_4 = next(arg_9_0, var_9_1)
					
					if var_9_1 then
						var_9_3[var_9_1] = var_9_4
					end
				until not var_9_4
				
				local var_9_5 = getmetatable(arg_9_0)
				local var_9_6
				
				repeat
					local var_9_7
					
					var_9_6, var_9_7 = next(var_9_5.enval, var_9_6)
					
					if var_9_6 then
						var_9_3[var_9_6] = var_3_2(var_9_7, true)
					end
				until not var_9_7
				
				return var_9_0, var_9_3, nil
			end
		}
		
		if getmetatable(arg_6_0) then
			return arg_6_0
		end
		
		local var_6_1 = {}
		local var_6_2 = {}
		local var_6_3 = {}
		
		for iter_6_0, iter_6_1 in pairs(arg_6_0) do
			if type(iter_6_1) == "number" then
				var_6_3[iter_6_0] = var_3_2(iter_6_1)
				var_6_2[iter_6_0] = var_3_1(iter_6_0, iter_6_1)
			else
				var_6_1[iter_6_0] = iter_6_1
			end
		end
		
		var_6_0.error = {}
		var_6_0.enval = var_6_3
		var_6_0.hash = var_6_2
		
		setmetatable(var_6_1, var_6_0)
		
		return var_6_1
	end
	
	local function var_3_4(arg_11_0)
		local var_11_0 = getmetatable(arg_11_0, nil)
		
		setmetatable(arg_11_0, nil)
		
		if var_11_0 and var_11_0.enval then
			for iter_11_0, iter_11_1 in pairs(var_11_0.enval) do
				arg_11_0[iter_11_0] = var_3_2(iter_11_1, true)
			end
		end
		
		return arg_11_0
	end
	
	if arg_3_1 then
		arg_3_0(var_3_3)
	else
		arg_3_0(var_3_4)
	end
end

local function var_0_5(arg_12_0, arg_12_1)
	if ignore_crc32 then
		return 
	end
	
	local var_12_0 = math.random(268435456, 4294967295)
	
	local function var_12_1(arg_13_0, arg_13_1)
		return crc32_string(tostring(arg_13_0), arg_13_1)
	end
	
	local function var_12_2(arg_14_0, arg_14_1)
		if not arg_14_0 then
			return 
		end
		
		if arg_14_1 then
			if not arg_14_0 then
				return 
			end
			
			local var_14_0, var_14_1 = math.modf(tonumber(arg_14_0[2]) or 0)
			
			return bit.bxor(arg_14_0[1] or 0, arg_14_0[3]) + var_14_1
		end
		
		local var_14_2, var_14_3 = math.modf(arg_14_0)
		
		return {
			bit.bxor(var_14_2, var_12_0),
			var_14_3,
			var_12_0
		}
	end
	
	local function var_12_3(arg_15_0)
		local var_15_0 = {
			__index = function(arg_16_0, arg_16_1)
				local var_16_0 = getmetatable(arg_16_0)
				local var_16_1 = var_16_0.crc32[arg_16_1]
				
				if var_16_1 then
					local var_16_2 = var_12_2(var_16_0.enval[arg_16_1], true)
					
					if var_12_1(arg_16_1, var_16_2) == var_16_1 then
					elseif not var_16_0.error[arg_16_1] then
						var_16_0.error[arg_16_1] = true
						
						if #g_UNIT_CONVIC < 5 then
							if var_16_0.enval[arg_16_1] then
								local var_16_3 = var_16_0.enval[arg_16_1][1]
							end
							
							if var_16_0.enval[arg_16_1] then
								local var_16_4 = var_16_0.enval[arg_16_1][2]
							end
							
							if var_16_0.enval[arg_16_1] then
								local var_16_5 = var_16_0.enval[arg_16_1][3]
							end
						end
					end
					
					return var_16_2
				elseif var_16_0.over_range[arg_16_1] then
					return var_16_0.over_range[arg_16_1]
				end
				
				return rawget(arg_16_0, arg_16_1)
			end,
			__newindex = function(arg_17_0, arg_17_1, arg_17_2)
				local var_17_0 = getmetatable(arg_17_0)
				
				if crc32_range_over(arg_17_2) then
					var_17_0.enval[arg_17_1] = nil
					var_17_0.crc32[arg_17_1] = nil
					var_17_0.over_range[arg_17_1] = arg_17_2
				elseif var_17_0.crc32[arg_17_1] or var_17_0.over_range[arg_17_1] then
					var_17_0.enval[arg_17_1] = var_12_2(arg_17_2)
					var_17_0.crc32[arg_17_1] = var_12_1(arg_17_1, arg_17_2)
					var_17_0.over_range[arg_17_1] = nil
				else
					rawset(arg_17_0, arg_17_1, arg_17_2)
				end
			end,
			__pairs = function(arg_18_0)
				local function var_18_0(arg_19_0, arg_19_1)
					local var_19_0
					local var_19_1
					
					arg_19_1, var_19_1 = next(arg_19_0, arg_19_1)
					
					if var_19_1 then
						return arg_19_1, var_19_1
					end
				end
				
				local var_18_1
				local var_18_2
				local var_18_3 = {}
				
				repeat
					local var_18_4
					
					var_18_1, var_18_4 = next(arg_18_0, var_18_1)
					
					if var_18_1 then
						var_18_3[var_18_1] = var_18_4
					end
				until not var_18_4
				
				local var_18_5 = getmetatable(arg_18_0)
				local var_18_6
				
				repeat
					local var_18_7
					
					var_18_6, var_18_7 = next(var_18_5.enval, var_18_6)
					
					if var_18_6 then
						var_18_3[var_18_6] = var_12_2(var_18_7, true)
					end
				until not var_18_7
				
				local var_18_8
				
				repeat
					local var_18_9
					
					var_18_8, var_18_9 = next(var_18_5.over_range, var_18_8)
					
					if var_18_8 then
						var_18_3[var_18_8] = var_18_9
					end
				until not var_18_9
				
				return var_18_0, var_18_3, nil
			end
		}
		
		if getmetatable(arg_15_0) then
			return arg_15_0
		end
		
		local var_15_1 = {}
		local var_15_2 = {}
		local var_15_3 = {}
		local var_15_4 = {}
		local var_15_5 = {}
		
		for iter_15_0, iter_15_1 in pairs(arg_15_0) do
			if type(iter_15_1) == "number" then
				if crc32_range_over(iter_15_1) then
					var_15_5[iter_15_0] = iter_15_1
				else
					var_15_4[iter_15_0] = var_12_2(iter_15_1)
					var_15_2[iter_15_0] = var_12_1(iter_15_0, iter_15_1)
				end
			else
				var_15_1[iter_15_0] = iter_15_1
			end
		end
		
		var_15_0.error = {}
		var_15_0.enval = var_15_4
		var_15_0.crc32 = var_15_2
		var_15_0.over_range = var_15_5
		
		setmetatable(var_15_1, var_15_0)
		
		return var_15_1
	end
	
	local function var_12_4(arg_20_0)
		local var_20_0 = getmetatable(arg_20_0, nil)
		
		setmetatable(arg_20_0, nil)
		
		if var_20_0 and var_20_0.enval then
			for iter_20_0, iter_20_1 in pairs(var_20_0.enval) do
				arg_20_0[iter_20_0] = var_12_2(iter_20_1, true)
			end
		end
		
		if var_20_0 and var_20_0.over_range then
			for iter_20_2, iter_20_3 in pairs(var_20_0.over_range) do
				arg_20_0[iter_20_2] = iter_20_3
			end
		end
		
		return arg_20_0
	end
	
	if arg_12_1 then
		arg_12_0.inst = var_12_3(arg_12_0.inst)
		arg_12_0.status = var_12_3(arg_12_0.status)
	else
		arg_12_0.inst = var_12_4(arg_12_0.inst)
		arg_12_0.status = var_12_4(arg_12_0.status)
	end
end

function var_0_0.getStartHP(arg_21_0)
	if GAME_STATIC_VARIABLE.hp_continue_mode then
		local var_21_0 = arg_21_0.inst.start_hp_r / 1000
		local var_21_1 = math.min(arg_21_0.status.max_hp, math.floor(arg_21_0.status.max_hp * var_21_0))
		
		if arg_21_0.inst.start_hp_r ~= 0 and var_21_1 == 0 then
			var_21_1 = 1
		end
		
		return var_21_1
	end
	
	return arg_21_0.status.max_hp
end

function var_0_0.normalize(arg_22_0)
	arg_22_0.status.max_hp = math.floor(arg_22_0.status.max_hp)
	arg_22_0.inst.dhp = math.min(math.floor(arg_22_0:getRawMaxHP() * 0.5), arg_22_0:getBrokenHP())
	arg_22_0.inst.hp = math.min(arg_22_0:getMaxHP(), arg_22_0.inst.hp or arg_22_0:getStartHP())
	arg_22_0.inst.elapsed_ut = arg_22_0.inst.elapsed_ut or 0
	arg_22_0.status = FORMULA.normalizeStatus(arg_22_0.status)
end

function var_0_0.clampStatus(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or arg_23_0.status
	arg_23_1 = FORMULA.clampStatus(table.clone(arg_23_1))
	
	return arg_23_1
end

function var_0_0.calcOverStatus(arg_24_0, arg_24_1)
	arg_24_1 = arg_24_1 or arg_24_0.status
	
	return (FORMULA.calcOverStatus(table.clone(arg_24_1)))
end

function var_0_0.encode(arg_25_0)
	local var_25_0 = {
		inst = arg_25_0.inst,
		state_list = arg_25_0.states.List,
		equips = arg_25_0.equips
	}
	
	return json.encode(var_25_0)
end

function var_0_0.decode(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1.decode(arg_26_1)
	local var_26_1 = var_0_0:create({
		code = var_26_0.inst.code,
		lv = var_26_0.inst.lv,
		exp = var_26_0.inst.exp,
		g = var_26_0.inst.grade,
		uid = var_26_0.inst.uid
	})
	
	var_26_1.inst = var_26_0.inst
	var_26_1.states.List = var_26_0.state_list
	var_26_1.equips = var_26_0.equips
	var_26_1.external_passive = var_26_0.external_passive
	
	return var_26_1
end

function var_0_0.bindFunctions(arg_27_0)
	copy_functions(var_0_0, arg_27_0)
end

function var_0_0.clone(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0:getHPRatio(true)
	local var_28_1 = var_0_0:create({
		l = false,
		code = arg_28_0.inst.code,
		skin_code = arg_28_0.inst.skin_code,
		lv = arg_28_0.inst.lv,
		exp = arg_28_0.inst.exp,
		g = arg_28_0.inst.grade,
		uid = arg_28_0.inst.uid,
		s = table.clone(arg_28_0.inst.skill_lv),
		z = arg_28_0.inst.zodiac,
		awake = arg_28_0.inst.awake,
		f = arg_28_0.inst.fav,
		d = arg_28_0.inst.devote,
		h = var_28_0,
		m = arg_28_0:getMP(),
		stree = arg_28_0:getSTreeInfos(),
		ct = arg_28_0.inst.ct,
		unit_option = arg_28_0.inst.unit_option
	}, arg_28_0.apply_crc)
	
	var_28_1.skill_bundle = arg_28_0.skill_bundle:clone(var_28_1)
	var_28_1.equips = table.clone(arg_28_0.equips)
	var_28_1.external_passive = table.clone(arg_28_0.external_passive)
	var_28_1.inst.power = arg_28_0.inst.power
	var_28_1.inst.disabled_skill = table.clone(arg_28_0.inst.disabled_skill)
	var_28_1.inst.disable_auto = arg_28_0.inst.disable_auto
	var_28_1.inst.dead = arg_28_0.inst.dead
	var_28_1.inst.automaton_hp_r = arg_28_0.inst.automaton_hp_r
	var_28_1.inst.unit_option = arg_28_0.inst.unit_option
	
	if not arg_28_1 then
		var_28_1.states = table.clone(arg_28_0.states)
		
		var_28_1.states:resetOwner(var_28_1)
	end
	
	if not arg_28_2 then
		var_28_1:calc()
	end
	
	return var_28_1
end

function var_0_0.isClassUnit(arg_29_0)
	return true
end

function var_0_0.exportPureData(arg_30_0)
	return {
		max_hp = arg_30_0:getRawMaxHP(),
		dhp = arg_30_0:getBrokenHP(),
		hp = arg_30_0:getHP(),
		sp = arg_30_0:getSP(),
		dead = arg_30_0:isDead(),
		et = round(arg_30_0.inst.elapsed_ut, 2)
	}
end

function var_0_0.restorePureData(arg_31_0, arg_31_1)
	arg_31_0.status.max_hp = arg_31_1.max_hp
	arg_31_0.inst.hp = arg_31_1.hp
	arg_31_0.inst[arg_31_0:getSPName()] = arg_31_1.sp
	arg_31_0.inst.dead = arg_31_1.dead
	arg_31_0.inst.elapsed_ut = arg_31_1.et
end

function var_0_0.swapState(arg_32_0, arg_32_1)
	local var_32_0 = table.find(arg_32_0.states.List, function(arg_33_0, arg_33_1)
		return arg_32_1.guid == arg_33_1.guid
	end)
	
	if var_32_0 then
		arg_32_0.states.List[var_32_0] = arg_32_1
	end
end

function var_0_0.getAlly(arg_34_0)
	return arg_34_0.inst.ally or FRIEND
end

function var_0_0.getRawSkillIds(arg_35_0, arg_35_1)
	arg_35_1 = arg_35_1 or arg_35_0.inst.code
	
	local var_35_0 = {
		DB("character", arg_35_1, {
			"skill1",
			"skill2",
			"skill3",
			"skill4",
			"skill5",
			"skill6",
			"skill7",
			"skill8",
			"skill9",
			"skill_immune",
			"pskill_1",
			"pskill_2",
			"pskill_3"
		})
	}
	
	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		local var_35_1, var_35_2 = var_0_1(iter_35_1)
		
		var_35_0[iter_35_0] = var_35_1
	end
	
	return var_35_0
end

function var_0_0.getSkillIndex(arg_36_0, arg_36_1)
	local var_36_0 = DB("skill", arg_36_1, "base_skill") or arg_36_1
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0.db.skills) do
		local var_36_1 = DB("skill", iter_36_1, "base_skill") or iter_36_1
		
		if var_36_1 == var_36_0 or var_36_1 == arg_36_1 then
			return iter_36_0
		end
	end
	
	return nil
end

function var_0_0.getReferSkillIndex(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0:getSkillIndex(arg_37_1)
	
	return tonumber(DB("skill", arg_37_1, "sklvup_refer") or nil) or var_37_0, var_37_0
end

function var_0_0.mergeSkill(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_1 then
		return 
	end
	
	local var_38_0 = DB("skill", arg_38_1, "base_skill")
	local var_38_1
	
	if var_38_0 then
		var_38_1 = arg_38_0:getSkillIndex(var_38_0)
	end
	
	if var_38_1 then
		arg_38_0.db.skills[var_38_1] = arg_38_1
		
		if arg_38_0.skill_bundle then
			arg_38_0.skill_bundle:load(var_38_1, arg_38_1)
		end
	elseif not table.find(arg_38_0.db.skills, arg_38_1) then
		arg_38_2 = arg_38_2 or #arg_38_0.db.skills + 1
		arg_38_0.db.skills[arg_38_2] = arg_38_1
		
		if arg_38_0.skill_bundle then
			arg_38_0.skill_bundle:load(arg_38_2, arg_38_1)
		end
	end
end

function var_0_0.mergeSkillCool(arg_39_0, arg_39_1, arg_39_2)
	if arg_39_0.inst.skill_cool[arg_39_2] then
		arg_39_0.inst.skill_cool[arg_39_1] = arg_39_0.inst.skill_cool[arg_39_2]
		arg_39_0.inst.skill_cool[arg_39_2] = nil
	end
end

function var_0_0.bindGameDB(arg_40_0, arg_40_1, arg_40_2)
	arg_40_0.db = {}
	arg_40_0.db.skills = {}
	
	local var_40_0 = arg_40_2 or arg_40_1
	
	arg_40_0.db = DBT("character", var_40_0, {
		"name",
		"class",
		"resource",
		"type",
		"att_remark",
		"role",
		"monster_tier",
		"race",
		"grade",
		"size",
		"face_id",
		"face_id2",
		"face_id_camp",
		"model_id",
		"model_id2",
		"model_opt",
		"scale",
		"skin",
		"skin_check",
		"atlas",
		"ch_attribute",
		"variation_group",
		"exp",
		"moonlight",
		"zodiac_sphere2",
		"sphere_bonus_id",
		"subtask_mission_skill",
		"randomability",
		"grade",
		"use_power_stat",
		"show_cool",
		"topic_1",
		"topic_2",
		"personality_1",
		"personality_2",
		"ordinary",
		"chief_skill",
		"set_group",
		"force_lock",
		"designed_appear",
		"skin_group",
		"priority_skill",
		"allykill",
		"custom_group"
	})
	
	if not arg_40_0.db or arg_40_0.db.grade == nil then
		Log.e("ERROR : NO UNIT -", arg_40_1)
		
		return nil
	end
	
	arg_40_0.db.tier = arg_40_0.db.monster_tier
	arg_40_0.db.color = arg_40_0.db.ch_attribute
	arg_40_0.db.zodiac = arg_40_0.db.zodiac_sphere2
	arg_40_0.db.model_id = arg_40_0.db.model_id or "slime"
	arg_40_0.db.model_id2 = arg_40_0.db.model_id2 or "slime"
	arg_40_0.db.name = arg_40_0.db.name
	arg_40_0.db.code = arg_40_1
	
	if not arg_40_0.db.name then
		error("no found character data : " .. arg_40_1)
	end
	
	if arg_40_0.db.name and Text then
		arg_40_0.db.sort_name = Text:getSortName(arg_40_0.db.name)
	end
	
	arg_40_0.db.skills = {}
	
	local var_40_1 = UNIT.getRawSkillIds(arg_40_0, arg_40_1)
	
	for iter_40_0, iter_40_1 in pairs(var_40_1) do
		if iter_40_1 then
			arg_40_0:mergeSkill(iter_40_1, iter_40_0)
		end
	end
	
	for iter_40_2 = 1, 10 do
		if arg_40_0.db.skills[iter_40_2] then
			if DB("skill", arg_40_0.db.skills[iter_40_2], "flying") ~= nil then
				arg_40_0.db.fly_skill = arg_40_0.db.skills[iter_40_2]
			end
			
			local var_40_2, var_40_3 = DB("skill", arg_40_0.db.skills[iter_40_2], {
				"eff_flyatk",
				"eff_flyeffect"
			})
			
			if var_40_2 then
				arg_40_0.db.flyatk_skill = arg_40_0.db.skills[iter_40_2]
				arg_40_0.db.flyatk_strike = var_40_2 == "strike"
				arg_40_0.db.flyatk_range = var_40_2 == "missile"
				arg_40_0.db.flyatk_explosion = var_40_2 == "explosion"
				arg_40_0.db.flyatk_effect = var_40_3
			end
		end
	end
	
	if arg_40_0.db.skills[1] == nil then
		arg_40_0.db.skills[1] = "sk_10101_1"
	end
	
	return true
end

function var_0_0.setPassiveSkill(arg_41_0, arg_41_1)
	if not arg_41_0:isSkillEnabled(arg_41_1) then
		Log.d("패시브 적용", "조디악 스킬 오픈 안됨", arg_41_0.db.name, arg_41_1)
		
		return 
	end
	
	if not DB("skill", arg_41_1, "sk_passive") then
		return 
	end
	
	local var_41_0 = arg_41_0:getSkillDB(arg_41_1, "sk_passive")
	
	arg_41_0:setPassiveState(var_41_0, arg_41_1)
end

function var_0_0.setPassiveState(arg_42_0, arg_42_1, arg_42_2)
	arg_42_0:addState(arg_42_1, 1, arg_42_0, {
		ignore_calc = true,
		skill_id = arg_42_2
	})
end

function var_0_0.addState(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	arg_43_4 = arg_43_4 or {}
	
	local var_43_0, var_43_1, var_43_2, var_43_3 = arg_43_0.states:add(arg_43_1, arg_43_2, arg_43_3, arg_43_4.turn, arg_43_4.skill_id, arg_43_4.force_apply, arg_43_4)
	
	if var_43_1 then
		if var_43_1:checkEff("CSP_GAUGE_WEAK") then
			arg_43_0.inst.week_gauge = 0
		elseif var_43_1:checkEff("CSP_GAUGE_BERSERK") then
			arg_43_0.inst.berserk_gauge = 0
		elseif var_43_1:checkEff("CSP_PASSIVEBLOCK") then
			arg_43_0.logic:onAddedPassiveBlock(arg_43_0, arg_43_4.limit_depth)
		elseif var_43_1:checkEff("CSP_CONTENT_ENHANCE") then
			if arg_43_0.contetns_origins and arg_43_0.states:isExistEffect("CSP_CONTENT_ENHANCE") then
				return 
			end
			
			if arg_43_0.logic then
				arg_43_0.logic:addContentEnhance(arg_43_0)
			else
				arg_43_0:addContentEnhance(true)
			end
		elseif var_43_1:checkEff("CSP_TRANSFORM") then
			arg_43_0:checkTransform()
		end
		
		if arg_43_0.logic then
			arg_43_0.logic:addUnitStateCondition({
				unit = arg_43_0,
				state_id = var_43_2
			})
		end
	end
	
	if not arg_43_4.ignore_calc then
		arg_43_0:calc()
	end
	
	return var_43_0, var_43_1, var_43_2, var_43_3
end

function var_0_0.getStateTurn(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0.states:findByUId(arg_44_1)
	
	if var_44_0 then
		return var_44_0.turn
	end
	
	return 0
end

function var_0_0.getSkillBundle(arg_45_0)
	if arg_45_0:isTransformed() then
		return arg_45_0.transform_vars.skill_bundle
	end
	
	return arg_45_0.skill_bundle
end

function var_0_0.getSkillCoolData(arg_46_0)
	if arg_46_0:isTransformed() then
		return arg_46_0.transform_vars.skill_cool
	end
	
	return arg_46_0.inst.skill_cool
end

function var_0_0.getActiveSkillIds(arg_47_0)
	return arg_47_0:getSkillBundle():toSkillIds()
end

function var_0_0.addExp(arg_48_0, arg_48_1)
	if arg_48_0:isNPC() then
		return false
	end
	
	arg_48_0.inst.exp = arg_48_0.inst.exp + arg_48_1
	
	return arg_48_0:updateLevel(true)
end

function var_0_0.setExp(arg_49_0, arg_49_1)
	arg_49_0.inst.exp = arg_49_1
	
	return arg_49_0:updateLevel()
end

function var_0_0.updateLevel(arg_50_0, arg_50_1)
	local var_50_0 = 1
	
	for iter_50_0 = 1, arg_50_0:getMaxLevel() do
		var_50_0 = iter_50_0
		
		local var_50_1 = arg_50_0:getNextExp(iter_50_0)
		
		if var_50_1 == nil or var_50_1 > arg_50_0.inst.exp then
			break
		end
	end
	
	local var_50_2 = arg_50_0.inst.lv ~= var_50_0
	
	arg_50_0.inst.lv = var_50_0
	
	if not arg_50_0:isDead() and arg_50_1 and var_50_2 then
		arg_50_0.inst.start_hp_r = 1000
		arg_50_0.inst.hp = math.min(arg_50_0:getStartHP(), arg_50_0:getMaxHP())
		arg_50_0.inst.mp = GAME_STATIC_VARIABLE.mana_default
	end
	
	return var_50_2
end

function var_0_0.makeInstData(arg_51_0, arg_51_1)
	local var_51_0 = {}
	local var_51_1 = arg_51_1.skill_lv or arg_51_1.s
	
	if var_51_1 == nil then
		var_51_1 = {}
		
		for iter_51_0 = 1, 10 do
			if arg_51_0.db.skills[iter_51_0] then
				var_51_0[arg_51_0.db.skills[iter_51_0]] = 0
			end
		end
	end
	
	arg_51_0.inst = {}
	arg_51_0.inst.code = arg_51_1.code
	arg_51_0.inst.skin_code = arg_51_1.skin_code
	arg_51_0.inst.lv = 1
	arg_51_0.inst.exp = arg_51_1.exp or 0
	arg_51_0.inst.line = arg_51_1.line or FRONT
	arg_51_0.inst.ally = arg_51_1.ally or FRIEND
	arg_51_0.inst.skill_cool = var_51_0
	arg_51_0.inst.skill_lv = var_51_1
	arg_51_0.inst.disabled_skill = {}
	arg_51_0.inst.add_skill = {}
	arg_51_0.inst.skill_soul_flag = {}
	arg_51_0.inst.zodiac = to_n(arg_51_1.zodiac or arg_51_1.z)
	arg_51_0.inst.awake = to_n(arg_51_1.awake)
	arg_51_0.inst.use_skill = nil
	arg_51_0.inst.ignore_hit_action = nil
	arg_51_0.inst.use_equip_skill = nil
	arg_51_0.inst.start_hp_r = 1000
	arg_51_0.inst.fav = arg_51_1.f or 0
	arg_51_0.inst.devote = arg_51_1.d or 0
	arg_51_0.inst.stree = arg_51_1.stree or {}
	arg_51_0.inst.exclusive_effect = {}
	arg_51_0.inst.ct = arg_51_1.ct
	arg_51_0.inst.unit_option = arg_51_1.opt
	arg_51_0.skill_bundle = SkillBundle(arg_51_0)
	arg_51_0.skill_sequencer = UnitSkillSequencer:get(arg_51_0)
	
	if arg_51_1.chp then
		arg_51_0.inst.server_curr_hp = arg_51_1.chp
	end
	
	if arg_51_1.mhp then
		arg_51_0.inst.server_max_hp = arg_51_1.mhp
	end
	
	if arg_51_1.h then
		arg_51_0.inst.start_hp_r = arg_51_1.h
	end
	
	if arg_51_1.automaton_hp_r then
		arg_51_0.inst.automaton_hp_r = arg_51_1.automaton_hp_r
	end
	
	if arg_51_1.cat and (arg_51_1.ca == nil or arg_51_1.ca == "h") then
		arg_51_0.inst.eating_end_time = arg_51_1.cat
	end
	
	arg_51_0.inst.subtask_end_time = arg_51_1.stet
	
	local var_51_2 = arg_51_1.grade or arg_51_1.g or arg_51_0.db.grade
	
	arg_51_0.inst.grade = var_51_2
	arg_51_0.states = StateList:create(arg_51_0)
	arg_51_0.inst.power = arg_51_1.power or arg_51_1.p
	arg_51_0.inst.power = to_n(arg_51_0.inst.power)
	
	if arg_51_1.ability then
		local var_51_3 = DBT("character_randomability", arg_51_1.ability, {
			"prefix_name",
			"skills"
		})
		
		arg_51_0.inst.prefix_name = T(var_51_3.prefix_name)
		
		local var_51_4 = string.split(var_51_3.skills, ",")
		
		for iter_51_1, iter_51_2 in pairs(var_51_4) do
			arg_51_0:mergeSkill(iter_51_2)
		end
	end
	
	arg_51_0:updateZodiacSkills()
	arg_51_0:applyNpcSkillLevel()
	
	for iter_51_3, iter_51_4 in pairs(arg_51_0.db.skills) do
		arg_51_0.skill_bundle:load(iter_51_3, iter_51_4)
	end
	
	if to_n(arg_51_1.gb_lv) > 0 then
		arg_51_0.inst.growth_boost_info = {
			gb_lv = arg_51_1.gb_lv,
			gb_passive = arg_51_1.gb_p
		}
	end
end

function var_0_0.clearVars(arg_52_0, arg_52_1)
	arg_52_0.ui_vars = {}
	arg_52_0.tmp_vars = {}
	arg_52_0.model_vars = nil
	
	if not arg_52_1 then
		arg_52_0.transform_vars = nil
	end
end

function var_0_0.clearInstData(arg_53_0)
	arg_53_0:clearVars()
	
	arg_53_0.inst.proc_cnt = 0
	arg_53_0.inst.elapsed_ut = 0
	arg_53_0.inst.bp = 0
	arg_53_0.inst.mp = GAME_STATIC_VARIABLE.mana_default
	arg_53_0.inst.cp = 0
	arg_53_0.inst.dhp = 0
	arg_53_0.inst.week_gauge = 0
	arg_53_0.inst.berserk_gauge = 0
	arg_53_0.inst.use_skill = nil
	arg_53_0.inst.ignore_hit_action = nil
	arg_53_0.inst.use_equip_skill = nil
	arg_53_0.inst.dead = nil
	
	local var_53_0 = 0
	local var_53_1
	
	if arg_53_0.db and arg_53_0.db.skills then
		var_53_1 = arg_53_0.db.chief_skill
		
		for iter_53_0, iter_53_1 in pairs(arg_53_0.db.skills) do
			arg_53_0.inst.skill_cool[iter_53_1] = 0
			
			if arg_53_0.db.show_cool == "y" then
				local var_53_2, var_53_3 = arg_53_0:getSkillDB(iter_53_1, {
					"pre_cool",
					"turn_cool"
				})
				local var_53_4 = to_n(var_53_3)
				
				if var_53_2 == "y" then
					arg_53_0.inst.skill_cool[iter_53_1] = var_53_4
				end
				
				if var_53_1 and arg_53_0.db.chief_skill == iter_53_1 or var_53_0 <= var_53_4 then
					var_53_0 = var_53_4
					arg_53_0.inst.monster_skill = iter_53_1
					arg_53_0.inst.monster_skill_cool = var_53_4
				end
			end
		end
	end
end

local function var_0_6(arg_54_0)
	arg_54_0.grade = arg_54_0.grade or arg_54_0.g or 1
	arg_54_0.zodiac = math.min(6, arg_54_0.zodiac or arg_54_0.z or 0)
	arg_54_0.awake = math.min(6, arg_54_0.awake or 0)
	arg_54_0.params = arg_54_0.params or {}
	arg_54_0.uid = arg_54_0.uid or arg_54_0.id
	arg_54_0.locked = arg_54_0.locked or arg_54_0.l
	arg_54_0.disable_auto = arg_54_0.a
end

function var_0_0.create(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = {
		is_unit = true,
		apply_crc = arg_55_2,
		_id = var_0_0.maxInstId
	}
	
	var_0_0.maxInstId = var_0_0.maxInstId + 1
	var_55_0.tmp_vars = {}
	
	var_0_0.bindFunctions(var_55_0)
	
	if not var_0_0.bindGameDB(var_55_0, arg_55_1.code, arg_55_1.skin_code) then
		return nil
	end
	
	var_0_0.clearTurnVars(var_55_0)
	var_0_6(arg_55_1)
	
	var_55_0.equips = {}
	var_55_0.external_passive = {}
	
	if arg_55_1.lv and arg_55_1.lv > 1 and (arg_55_1.exp == nil or arg_55_1.exp < 1) then
		arg_55_1.exp = tonumber(DB("exp", tostring(arg_55_1.lv - 1), "tier" .. var_55_0.db.grade))
	end
	
	var_0_0.makeInstData(var_55_0, arg_55_1)
	var_55_0:updateLevel(false)
	Log.d("UNIT info.code=", arg_55_1.code, ",info.id=", arg_55_1.id, ",info.uid=", arg_55_1.uid)
	
	if arg_55_1.uid == nil then
		var_55_0.inst.uid = var_0_0.maxUid
		var_0_0.maxUid = var_0_0.maxUid + 1
	else
		var_55_0.inst.uid = arg_55_1.uid
		
		if var_0_0.maxUid < arg_55_1.uid then
			var_0_0.maxUid = arg_55_1.uid + 1
		end
	end
	
	var_55_0.inst.locked = arg_55_1.locked
	var_55_0.inst.disable_auto = arg_55_1.disable_auto
	var_55_0.inst.expedition_info = arg_55_1.expedition_info
	var_55_0.ignore_stat = arg_55_4
	
	var_55_0:reset(nil, arg_55_3)
	
	return var_55_0
end

function var_0_0.changeSkin(arg_56_0, arg_56_1)
	arg_56_0.inst.skin_code = arg_56_1
	
	arg_56_0:bindGameDB(arg_56_0.inst.code, arg_56_0.inst.skin_code)
	arg_56_0:updateZodiacSkills()
end

function var_0_0.getSkinCode(arg_57_0)
	return arg_57_0.inst.skin_code
end

function var_0_0.getSkinCheck(arg_58_0)
	local var_58_0
	
	if arg_58_0:isTransformed() then
		var_58_0 = arg_58_0:getTransformVars().code
	end
	
	return (DB("character", var_58_0 or arg_58_0:getDisplayCode(), "skin_check"))
end

function var_0_0.getDisplayCode(arg_59_0)
	return arg_59_0.inst.skin_code or arg_59_0.db.code
end

function var_0_0.getBooster(arg_60_0, arg_60_1)
	local var_60_0 = {}
	
	for iter_60_0, iter_60_1 in pairs(arg_60_1) do
		var_60_0[iter_60_0] = 1
	end
	
	return var_60_0
end

function var_0_0.reset(arg_61_0, arg_61_1, arg_61_2)
	if arg_61_0.ignore_stat then
		return 
	end
	
	arg_61_0:clearInstData()
	
	if not arg_61_1 then
		arg_61_0.states:clear()
	end
	
	arg_61_0.base_stat = var_0_2(arg_61_0.inst.code, arg_61_0:getGrade())
	arg_61_0.base_status = FORMULA.calcStatus(arg_61_0.base_stat, arg_61_0.inst)
	arg_61_0.base_status = arg_61_0:adjustStatus(arg_61_0.base_status)
	arg_61_0.status_booster = arg_61_0:getBooster(arg_61_0.base_status)
	arg_61_0.stat = table.clone(arg_61_0.base_stat)
	arg_61_0.status = table.clone(arg_61_0.base_status)
	arg_61_0.status_without_states = table.clone(arg_61_0.base_status)
	arg_61_0.cheat_status = {}
	
	arg_61_0:normalize()
	
	if not arg_61_2 then
		arg_61_0:calc()
	end
	
	arg_61_0.inst.hp = math.min(arg_61_0:getStartHP(), arg_61_0:getMaxHP())
	
	if arg_61_0:getSPName() ~= "mp" then
		arg_61_0.inst.mp = GAME_STATIC_VARIABLE.mana_default
	end
	
	if arg_61_0.inst.server_curr_hp then
		arg_61_0.inst.hp = arg_61_0.inst.server_curr_hp
	end
end

function var_0_0.isNPC(arg_62_0)
	return (tonumber(arg_62_0.inst.uid) or -1) < 0
end

function var_0_0.isSummon(arg_63_0)
	return arg_63_0.db.type == "summon"
end

function var_0_0.isEmptyHP(arg_64_0)
	return arg_64_0.inst.hp <= 0
end

function var_0_0.isDead(arg_65_0)
	return arg_65_0.inst.dead
end

function var_0_0.isNeedToShowSkillCoolTime(arg_66_0)
	return arg_66_0.db.show_cool == "y"
end

function var_0_0.isAllyKiller(arg_67_0)
	return arg_67_0.db.allykill == "y"
end

function var_0_0.adjustStatus(arg_68_0, arg_68_1)
	arg_68_1 = arg_68_0:overwritePowerStatus(arg_68_1)
	arg_68_1 = arg_68_0:adjustCharacterStatus(arg_68_1)
	
	return arg_68_1
end

function var_0_0.adjustCharacterStatus(arg_69_0, arg_69_1)
	local var_69_0, var_69_1, var_69_2, var_69_3 = DB("character", arg_69_0.db.code, {
		"att_rate",
		"def_rate",
		"speed_rate",
		"max_hp_rate"
	})
	
	if var_69_0 then
		arg_69_1.att = math.floor(arg_69_1.att * var_69_0)
	end
	
	if var_69_1 then
		arg_69_1.def = math.floor(arg_69_1.def * var_69_1)
	end
	
	if var_69_2 then
		arg_69_1.speed = math.floor(arg_69_1.speed * var_69_2)
	end
	
	if var_69_3 then
		arg_69_1.max_hp = math.floor(arg_69_1.max_hp * var_69_3)
	end
	
	local var_69_4 = arg_69_0.inst.expedition_info
	
	if var_69_4 and var_69_4.max_hp then
		arg_69_1.max_hp = var_69_4.max_hp
	end
	
	if arg_69_0.inst.server_max_hp then
		arg_69_1.max_hp = arg_69_0.inst.server_max_hp
	end
	
	return arg_69_1
end

function var_0_0.overwritePowerStatus(arg_70_0, arg_70_1)
	if arg_70_0.db.use_power_stat == "y" then
		arg_70_1.max_hp = arg_70_1.power_max_hp
		arg_70_1.att = arg_70_1.power_att
		arg_70_1.def = arg_70_1.power_def
		arg_70_1.speed = arg_70_1.power_speed
		arg_70_1.cri = arg_70_1.power_cri
		arg_70_1.res = arg_70_1.power_res
	end
	
	return arg_70_1
end

function var_0_0.setExpeditionInfo(arg_71_0, arg_71_1)
	arg_71_0.inst.expedition_info = arg_71_1
end

function var_0_0.calcEquipStat(arg_72_0, arg_72_1)
	if arg_72_1 == nil then
		for iter_72_0, iter_72_1 in pairs(arg_72_0.equips) do
			arg_72_0:calcEquipStat(iter_72_1)
		end
		
		return 
	end
	
	arg_72_1:applyStat(arg_72_0)
end

function var_0_0.calcExteranlPassive(arg_73_0)
	for iter_73_0, iter_73_1 in pairs(arg_73_0.external_passive) do
		arg_73_0:setPassiveSkill(iter_73_1.skill_id)
	end
end

function var_0_0.calcTeamPassiveSkills(arg_74_0)
	if arg_74_0.team then
		for iter_74_0, iter_74_1 in pairs(arg_74_0.team.passive_skills) do
			arg_74_0:setPassiveSkill(iter_74_0)
		end
	end
end

function var_0_0.calcEquipSetSkills(arg_75_0)
	arg_75_0:eachSetItemApply(function(arg_76_0)
		local var_76_0 = DBT("item_set", arg_76_0, {
			"type1",
			"effect1",
			"type2",
			"effect2"
		})
		
		for iter_76_0 = 1, 2 do
			local var_76_1 = var_76_0["type" .. iter_76_0]
			local var_76_2 = var_76_0["effect" .. iter_76_0]
			
			if var_76_1 == "skill" then
				arg_75_0:setPassiveSkill(var_76_2)
			end
		end
	end, function(arg_77_0)
		local var_77_0 = DBT("item_set", arg_77_0, {
			"type1",
			"effect1",
			"type2",
			"effect2"
		})
		
		for iter_77_0 = 1, 2 do
			local var_77_1 = var_77_0["type" .. iter_77_0]
			local var_77_2 = var_77_0["effect" .. iter_77_0]
			
			if var_77_1 == "skill" and var_77_2 then
				local var_77_3 = arg_75_0:getSkillDB(var_77_2, "sk_passive")
				
				if var_77_3 and arg_75_0:getCSDB(var_77_3, "cs_overlap") == "y" then
					return arg_75_0.states:countById(var_77_3)
				end
			end
		end
		
		return 0
	end)
end

function var_0_0.calcEquipSetEffectsStatus(arg_78_0)
	arg_78_0:eachSetItemApply(function(arg_79_0)
		local var_79_0 = DBT("item_set", arg_79_0, {
			"type1",
			"effect1",
			"type2",
			"effect2"
		})
		
		for iter_79_0 = 1, 2 do
			local var_79_1 = var_79_0["type" .. iter_79_0]
			local var_79_2 = var_79_0["effect" .. iter_79_0]
			
			if var_79_1 and var_79_1 ~= "skill" then
				local var_79_3 = {
					var_79_1,
					var_79_2
				}
				
				arg_78_0:applyStatus({
					var_79_3
				})
				arg_78_0:applyBooster({
					var_79_3
				})
			end
		end
	end)
end

function var_0_0.calcEquipSkills(arg_80_0, arg_80_1)
	if arg_80_1 == nil then
		for iter_80_0, iter_80_1 in pairs(arg_80_0.equips) do
			arg_80_0:calcEquipSkills(iter_80_1)
		end
		
		return 
	end
	
	local var_80_3
	
	if arg_80_1:isExclusive() then
		arg_80_1:applyExclusiveSkill(arg_80_0)
	else
		local var_80_0, var_80_1, var_80_2 = arg_80_1:getPassiveSkill()
		
		var_80_3 = arg_80_1:getSkillLevel()
		
		for iter_80_2, iter_80_3 in pairs({
			var_80_0,
			var_80_1,
			var_80_2
		}) do
			if iter_80_3 then
				local var_80_4 = DB("skill", iter_80_3, "sk_passive")
				
				if var_80_4 then
					if var_80_3 > 0 then
						var_80_4 = var_80_4 .. var_80_3
					end
					
					arg_80_0:setPassiveState(var_80_4)
				end
			end
		end
	end
end

function var_0_0.applyStat(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	arg_81_2 = arg_81_2 or 1
	arg_81_3 = arg_81_3 or {}
	
	for iter_81_0, iter_81_1 in pairs(arg_81_1) do
		if arg_81_0.stat[iter_81_1[1]] then
			local var_81_0 = 1
			
			if arg_81_3.is_eqiuip then
				var_81_0 = arg_81_0:getEquipContentsRate(iter_81_1[1])
			end
			
			arg_81_0.stat[iter_81_1[1]] = arg_81_0.stat[iter_81_1[1]] + iter_81_1[2] * arg_81_2 * var_81_0
		end
	end
end

function var_0_0.applyStatus(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	arg_82_2 = arg_82_2 or 1
	arg_82_3 = arg_82_3 or {}
	
	local var_82_0 = arg_82_3.status or arg_82_0.status
	
	for iter_82_0, iter_82_1 in pairs(arg_82_1) do
		if var_82_0[iter_82_1[1]] then
			local var_82_1 = 1
			
			if arg_82_3.is_eqiuip then
				var_82_1 = arg_82_0:getEquipContentsRate(iter_82_1[1])
			end
			
			var_82_0[iter_82_1[1]] = var_82_0[iter_82_1[1]] + iter_82_1[2] * arg_82_2 * var_82_1
		end
	end
end

function var_0_0.applyExclusiveSkill(arg_83_0, arg_83_1)
	if not arg_83_1 then
		return 
	end
	
	local var_83_0, var_83_1, var_83_2, var_83_3, var_83_4, var_83_5, var_83_6, var_83_7, var_83_8, var_83_9 = DB("skill_equip", arg_83_1, {
		"exc_number",
		"exc_number_ext",
		"exc_effect",
		"exc_desc",
		"exc_change_desc",
		"exc_explain1",
		"exc_explain2",
		"exc_explain3",
		"exc_explain4",
		"exc_showcooltimeskill_desc"
	})
	local var_83_10 = to_n(var_83_0)
	local var_83_11
	
	if var_83_10 > 0 and var_83_2 then
		var_83_11 = {
			skill_num = var_83_10,
			effect = var_83_2,
			desc = var_83_3,
			skill_desc = var_83_4,
			explain = {
				var_83_5,
				var_83_6,
				var_83_7,
				var_83_8
			},
			showcooltimeskill_de = var_83_9
		}
		arg_83_0.inst.exclusive_effect[var_83_10] = var_83_11
		
		if var_83_1 then
			local var_83_12 = tostring(var_83_1)
			local var_83_13 = string.split(var_83_12, ",")
			
			for iter_83_0, iter_83_1 in pairs(var_83_13) do
				local var_83_14 = tonumber(iter_83_1)
				
				if var_83_14 and var_83_14 > 0 then
					arg_83_0.inst.exclusive_effect[var_83_14] = var_83_11
				end
			end
		end
	end
end

function var_0_0.applyBooster(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
	arg_84_2 = arg_84_2 or 1
	arg_84_3 = arg_84_3 or {}
	
	for iter_84_0, iter_84_1 in pairs(arg_84_1) do
		if iter_84_1[1] and string.sub(iter_84_1[1], -5, -1) == "_rate" then
			local var_84_0 = 1
			
			if arg_84_3.is_eqiuip then
				var_84_0 = arg_84_0:getEquipContentsRate(iter_84_1[1])
			end
			
			local var_84_1 = string.sub(iter_84_1[1], 1, -6)
			
			arg_84_0.status_booster[var_84_1] = arg_84_0.status_booster[var_84_1] + iter_84_1[2] * (arg_84_2 * var_84_0)
		end
	end
end

function var_0_0.isLotaMode(arg_85_0)
	if arg_85_0.logic and arg_85_0.logic:isLotaContents() or arg_85_0.ui_vars.lota_mode and LotaSystem:isActive() then
		return true
	end
	
	return false
end

function var_0_0.calcContentsStatus(arg_86_0, arg_86_1, arg_86_2)
	local var_86_6
	
	if arg_86_0:isLotaMode() and (arg_86_0.inst.ally == FRIEND or arg_86_0.ui_vars.lota_mode) then
		local var_86_0
		
		if arg_86_0.ui_vars.lota_mode and not arg_86_0.logic then
			var_86_0 = {
				job_levels = {}
			}
			var_86_0.job_levels[arg_86_0.db.role] = LotaUserData:getRoleLevelByRole(arg_86_0.db.role)
		else
			var_86_0 = arg_86_0.logic:getLotaInfo()
		end
		
		local var_86_1 = (var_86_0.job_levels or {})[arg_86_0.db.role] or 1
		local var_86_2 = DB("clan_heritage_config", "max_role_level", "client_value") or 15
		local var_86_3 = math.min(math.max(var_86_1, 1), var_86_2)
		local var_86_4 = string.format("rank_%d_%s", var_86_3, arg_86_0.db.role)
		local var_86_5 = {}
		
		for iter_86_0, iter_86_1 in pairs(arg_86_1) do
			table.insert(var_86_5, iter_86_0)
		end
		
		var_86_6 = DBT("clan_heritage_role_stat_data", var_86_4, var_86_5)
		
		for iter_86_2, iter_86_3 in pairs(arg_86_1) do
			local var_86_7 = to_n(var_86_6[iter_86_2])
			
			if iter_86_2 == "coop" then
				var_86_7 = to_n(var_86_6.coop_rate)
			end
			
			if var_86_7 > 0 then
				if table.isInclude({
					"speed",
					"cri",
					"cri_dmg",
					"coop",
					"acc",
					"res"
				}, iter_86_2) then
					arg_86_1[iter_86_2] = arg_86_1[iter_86_2] + var_86_7
				else
					arg_86_1[iter_86_2] = arg_86_1[iter_86_2] + arg_86_2[iter_86_2] * var_86_7
				end
			end
		end
	end
end

function var_0_0.getEquipContentsRate(arg_87_0, arg_87_1)
	local var_87_0 = 1
	
	if arg_87_0:isLotaMode() then
		local var_87_1 = string.format("equip_stat_%s", arg_87_0.db.role)
		
		var_87_0 = DB("clan_heritage_equip_stat_data", var_87_1, arg_87_1)
	end
	
	return var_87_0 or 1
end

function var_0_0.getExclusiveEffect(arg_88_0, arg_88_1)
	local var_88_0 = to_n(arg_88_1)
	
	if var_88_0 <= 0 then
		return {}
	end
	
	return arg_88_0.inst.exclusive_effect[var_88_0] or {}
end

function var_0_0.setExclusiveSkillForVerify(arg_89_0, arg_89_1)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_89_0.tmp_vars.exclusive_verify = true
	
	arg_89_0:applyExclusiveSkill(arg_89_1)
	arg_89_0:calc()
end

function var_0_0.calcZodiacStat(arg_90_0)
	local var_90_0 = arg_90_0:getZodiacBonus()
	
	arg_90_0:applyStat(var_90_0)
end

function var_0_0.calcAwakeStatus(arg_91_0, arg_91_1)
	local var_91_0 = arg_91_0:getAwakeBonus()
	
	arg_91_0:applyStatus(var_91_0, 1, {
		status = arg_91_1
	})
end

function var_0_0.calcAwakeBooster(arg_92_0)
	local var_92_0 = arg_92_0:getAwakeBonus()
	
	arg_92_0:applyBooster(var_92_0)
end

function var_0_0.calcAwakeCoreStatus(arg_93_0, arg_93_1)
	local var_93_0 = arg_93_0:getAwakeCoreBonus()
	
	arg_93_0:applyStatus(var_93_0, 1, {
		status = arg_93_1
	})
end

function var_0_0.calcAwakeCoreBooster(arg_94_0)
	local var_94_0 = arg_94_0:getAwakeCoreBonus()
	
	arg_94_0:applyBooster(var_94_0)
end

function var_0_0.calcZodiacStatus(arg_95_0, arg_95_1)
	local var_95_0 = arg_95_0:getZodiacBonus()
	
	arg_95_0:applyStatus(var_95_0, 1, {
		status = arg_95_1
	})
end

function var_0_0.calcZodiacBooster(arg_96_0)
	local var_96_0 = arg_96_0:getZodiacBonus()
	
	arg_96_0:applyBooster(var_96_0)
end

function var_0_0.calcRuneStatus(arg_97_0, arg_97_1)
	local var_97_0 = arg_97_0:getRuneBonus()
	
	arg_97_0:applyStatus(var_97_0, 1, {
		status = arg_97_1
	})
end

function var_0_0.calcRuneBooster(arg_98_0)
	local var_98_0 = arg_98_0:getRuneBonus()
	
	arg_98_0:applyBooster(var_98_0)
end

function var_0_0.calcEquipStatus(arg_99_0, arg_99_1)
	if arg_99_1 == nil then
		for iter_99_0, iter_99_1 in pairs(arg_99_0.equips) do
			arg_99_0:calcEquipStatus(iter_99_1)
		end
		
		return 
	end
	
	arg_99_1:applyStatus(arg_99_0)
end

function var_0_0.calcEquipBooster(arg_100_0, arg_100_1)
	if arg_100_1 == nil then
		for iter_100_0, iter_100_1 in pairs(arg_100_0.equips) do
			arg_100_0:calcEquipBooster(iter_100_1)
		end
		
		return 
	end
	
	arg_100_1:applyBooster(arg_100_0)
end

function var_0_0.calcStatusBooster(arg_101_0, arg_101_1, arg_101_2)
	for iter_101_0, iter_101_1 in pairs(arg_101_0.status_booster) do
		local var_101_0 = 1e-09
		local var_101_1 = 0
		
		if iter_101_1 - 1 ~= 0 then
			var_101_1 = math.floor((iter_101_1 - 1 + var_101_0) * 1000000000) / 1000000000
		end
		
		arg_101_1[iter_101_0] = arg_101_1[iter_101_0] + arg_101_2[iter_101_0] * var_101_1
	end
end

function var_0_0.calcCheatStatus(arg_102_0)
	for iter_102_0, iter_102_1 in pairs(arg_102_0.cheat_status) do
		local var_102_0 = to_n(iter_102_1)
		
		if arg_102_0.status[iter_102_0] and var_102_0 then
			arg_102_0.status[iter_102_0] = var_102_0
		end
	end
end

function var_0_0.setCheatStatus(arg_103_0, arg_103_1, arg_103_2, arg_103_3)
	local var_103_0, var_103_1 = string.gsub(arg_103_2 or "", "%%", "")
	
	arg_103_2 = tonumber(var_103_0)
	
	if not arg_103_2 then
		return 
	end
	
	if var_103_1 > 0 then
		arg_103_2 = arg_103_2 / 100
	end
	
	arg_103_0.cheat_status[arg_103_1] = arg_103_2
	
	if not arg_103_3 then
		arg_103_0:calc()
	end
end

local function var_0_7(arg_104_0, arg_104_1, arg_104_2, arg_104_3)
	if arg_104_1 then
		arg_104_0.inst.dhp = arg_104_1 * arg_104_3 * (arg_104_0:getRawMaxHP() / arg_104_1)
	end
	
	arg_104_0:normalize()
	
	arg_104_0.over_status = arg_104_0:calcOverStatus(arg_104_0.status)
	arg_104_0.status = arg_104_0:clampStatus(arg_104_0.status)
	
	if arg_104_1 then
		if arg_104_1 < arg_104_0:getRawMaxHP() then
			if arg_104_0.inst.hp_revise_block then
				arg_104_0.inst.hp_revise_block = nil
			elseif not arg_104_0.tmp_vars.hp_down_dirty then
				arg_104_0.inst.hp = math.floor(arg_104_2 * arg_104_0:getMaxHP() + 0.5)
			else
				arg_104_0.tmp_vars.hp_down_dirty = nil
			end
		end
		
		arg_104_0.inst.hp = math.min(arg_104_0:getMaxHP(), arg_104_0.inst.hp)
	end
end

function var_0_0.calc(arg_105_0, arg_105_1)
	if arg_105_0.apply_crc then
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_4(function(arg_106_0)
				arg_105_0.inst = arg_106_0(arg_105_0.inst)
				arg_105_0.status = arg_106_0(arg_105_0.status)
			end, false)
		elseif arg_105_0.apply_crc then
			var_0_5(arg_105_0, false)
		end
	end
	
	local var_105_0
	local var_105_1
	
	if arg_105_0.inst.hp then
		var_105_0 = math.min(1, (arg_105_0.inst.hp or 0) / arg_105_0:getMaxHP())
		var_105_1 = arg_105_0:getRawMaxHP()
	end
	
	local var_105_2
	
	if arg_105_0.inst.dhp then
		var_105_2 = math.min(1, arg_105_0:getBrokenHPRatio())
	end
	
	arg_105_0.stat = table.clone(arg_105_0.base_stat)
	
	if not PRODUCTION_MODE and arg_105_0.tmp_vars.exclusive_verify then
	else
		arg_105_0.inst.exclusive_effect = {}
	end
	
	arg_105_0:calc_step_override1(arg_105_1)
	arg_105_0:calcGrowthBoost()
	
	if not arg_105_0:isTransformed() or not arg_105_0.transform_vars.skills then
		local var_105_3 = arg_105_0.db.skills
	end
	
	for iter_105_0, iter_105_1 in pairs(arg_105_0.db.skills) do
		if iter_105_1 then
			arg_105_0:setPassiveSkill(iter_105_1)
		end
	end
	
	if not arg_105_1 then
		arg_105_0:calcEquipSetSkills()
	end
	
	arg_105_0:calcTeamPassiveSkills()
	arg_105_0:calcExteranlPassive()
	arg_105_0:calcAwakeCoreNodeSkills()
	
	arg_105_0.base_status = FORMULA.calcStatus(arg_105_0.stat, arg_105_0.inst)
	arg_105_0.base_status = arg_105_0:adjustStatus(arg_105_0.base_status)
	arg_105_0.base_status = FORMULA.normalizeStatus(arg_105_0.base_status)
	arg_105_0.status_booster = arg_105_0:getBooster(arg_105_0.base_status)
	arg_105_0.status = table.clone(arg_105_0.base_status)
	arg_105_0.status.acc = to_n(arg_105_0.status.acc)
	arg_105_0.status.dmg = 1
	arg_105_0.status.pen_rate = 0
	arg_105_0.status.self_dmg = 1
	arg_105_0.status.team_att_point_damage = 0
	arg_105_0.status.team_pow_point_damage = 0
	
	arg_105_0:calcZodiacBooster()
	arg_105_0:calcRuneBooster()
	arg_105_0:calcAwakeBooster()
	
	arg_105_0.character_status = table.clone(arg_105_0.status)
	
	arg_105_0:calcZodiacStatus(arg_105_0.character_status)
	arg_105_0:calcRuneStatus(arg_105_0.character_status)
	arg_105_0:calcAwakeStatus(arg_105_0.character_status)
	arg_105_0:calcStatusBooster(arg_105_0.character_status, arg_105_0.base_status)
	
	arg_105_0.status_booster = arg_105_0:getBooster(arg_105_0.base_status)
	arg_105_0.character_status = FORMULA.normalizeStatus(arg_105_0.character_status)
	arg_105_0.status = table.clone(arg_105_0.character_status)
	
	arg_105_0:calc_step_override2(arg_105_1)
	
	arg_105_0.base_status = FORMULA.normalizeStatus(arg_105_0.base_status)
	arg_105_0.status_without_states = arg_105_0:clampStatus(table.clone(arg_105_0.status))
	
	arg_105_0.states:onCalcStatus()
	arg_105_0:calcCheatStatus()
	var_0_7(arg_105_0, var_105_1, var_105_0, var_105_2)
	
	if arg_105_0.apply_crc then
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_4(function(arg_107_0)
				arg_105_0.inst = arg_107_0(arg_105_0.inst)
				arg_105_0.status = arg_107_0(arg_105_0.status)
			end, true)
		elseif arg_105_0.apply_crc then
			var_0_5(arg_105_0, true)
		end
	end
end

function var_0_0.calc_step_override1(arg_108_0, arg_108_1)
	if not arg_108_1 then
		arg_108_0:calcEquipSkills()
	end
end

function var_0_0.calc_step_override2(arg_109_0, arg_109_1)
	arg_109_0:calcDevoteStatus()
	
	if not arg_109_1 then
		arg_109_0:calcEquipStatus()
	end
	
	arg_109_0:calcAwakeCoreStatus()
	arg_109_0:calcAwakeCoreBooster()
	
	if not arg_109_1 then
		arg_109_0:calcEquipSetEffectsStatus()
		arg_109_0:calcEquipBooster()
	end
	
	arg_109_0:calcStatusBooster(arg_109_0.status, arg_109_0.character_status)
	arg_109_0:calcContentsStatus(arg_109_0.status, arg_109_0.character_status)
end

function var_0_0.recalcHP(arg_110_0)
	if arg_110_0.inst.start_hp_r <= 0 or arg_110_0.inst.start_hp_r >= 1000 then
		return 
	end
	
	arg_110_0.inst.hp = math.min(arg_110_0:getMaxHP(), (arg_110_0:getStartHP()))
end

function var_0_0.buildgdh(arg_111_0)
end

function c_check_db(arg_112_0)
	local function var_112_0(arg_113_0, arg_113_1)
		arg_113_0 = arg_113_0 or ""
		
		if arg_113_1 then
			for iter_113_0, iter_113_1 in pairs(arg_113_1) do
				arg_113_0 = arg_113_0 .. tostring(iter_113_1)
			end
		end
		
		return arg_113_0
	end
	
	local function var_112_1(arg_114_0, arg_114_1)
		if not arg_114_1 then
			return 
		end
		
		for iter_114_0, iter_114_1 in pairs(arg_114_0) do
			if iter_114_1 == arg_114_1 then
				return 
			end
		end
		
		table.insert(arg_114_0, tostring(arg_114_1))
	end
	
	local var_112_2 = {
		skill = {},
		cs = {},
		sklv = {},
		tree = {},
		rune = {},
		zodiac = {}
	}
	local var_112_3 = {
		DB("character", arg_112_0, {
			"skill1",
			"skill2",
			"skill3",
			"skill4",
			"skill5",
			"skill6",
			"skill7",
			"skill8",
			"skill9",
			"skill_immune",
			"pskill_1",
			"pskill_2",
			"pskill_3"
		})
	}
	local var_112_4 = {}
	
	for iter_112_0, iter_112_1 in pairs(var_112_3) do
		table.insert(var_112_4, iter_112_1)
		
		local var_112_5 = DB("skill", iter_112_1, "soulburn_skill")
		
		if var_112_5 then
			table.insert(var_112_4, var_112_5)
		end
		
		table.insert(var_112_4, iter_112_1 .. "u")
		
		local var_112_6 = DB("skill", iter_112_1 .. "u", "soulburn_skill")
		
		if var_112_6 then
			table.insert(var_112_4, var_112_6)
		end
	end
	
	for iter_112_2, iter_112_3 in pairs(var_112_4) do
		if DB("skill", iter_112_3, "id") then
			var_112_1(var_112_2.skill, iter_112_3)
			
			for iter_112_4 = 1, 9 do
				local var_112_7 = {
					DB("skill", iter_112_3, {
						"sk_add_eff" .. iter_112_4,
						"sk_eff_value" .. iter_112_4
					})
				}
				
				if var_112_7[1] and (var_112_7[1] == "CS_ADD" or var_112_7[1] == "CS_RANDOM" or var_112_7[1] == "CS_ADD_ABSOLUTE") and var_112_7[2] then
					var_112_1(var_112_2.cs, tostring(var_112_7[2]))
				end
			end
			
			local var_112_8 = DB("skill", iter_112_3, "sk_passive")
			local var_112_9
			
			for iter_112_5 = 1, 10 do
				local var_112_10 = DB("skill", iter_112_3, "sk_lv_eff" .. iter_112_5)
				
				if var_112_8 then
					if var_112_10 == "*ps_up" then
						var_112_9 = (var_112_9 or 0) + 1
					end
				else
					var_112_1(var_112_2.sklv, var_112_10)
				end
			end
			
			if var_112_8 then
				var_112_1(var_112_2.cs, var_112_8 .. (var_112_9 or ""))
			end
		end
	end
	
	local var_112_11 = string.format("st_%s_", arg_112_0)
	local var_112_12 = {}
	local var_112_13 = {}
	local var_112_14 = 0
	
	for iter_112_6 = 1, 5 do
		local var_112_15 = var_112_11 .. iter_112_6
		local var_112_16 = {
			DB("skill_tree", var_112_15, {
				"id",
				"skill_point"
			})
		}
		local var_112_17 = {
			DB("skill_tree", var_112_15, {
				"pos_1",
				"req_1",
				"pos_2",
				"req_2",
				"pos_3",
				"req_3"
			})
		}
		
		var_112_1(var_112_2.tree, var_112_15)
		
		if var_112_16[1] then
			for iter_112_7, iter_112_8 in pairs(var_112_17) do
				for iter_112_9 = 0, 20 do
					local var_112_18 = DB("skill_tree_rune", iter_112_8 .. "_" .. iter_112_9, "id")
					
					print(var_112_18)
					
					if not var_112_18 then
						break
					end
					
					var_112_1(var_112_2.rune, var_112_18)
				end
			end
		end
	end
	
	local var_112_19 = DB("character", arg_112_0, {
		"sphere_bonus_id"
	})
	
	if var_112_19 then
		for iter_112_10 = 1, 6 do
			var_112_1(var_112_2.zodiac, var_112_19 .. "_" .. iter_112_10)
		end
	end
	
	for iter_112_11, iter_112_12 in pairs(var_112_2) do
		table.sort(iter_112_12, function(arg_115_0, arg_115_1)
			return arg_115_0 < arg_115_1
		end)
	end
	
	print("--skill")
	
	local var_112_20
	
	for iter_112_13, iter_112_14 in pairs(var_112_2.skill) do
		local var_112_21 = {
			DB("skill", iter_112_14, {
				"max_lv",
				"att_rate",
				"deal_damage",
				"turn_cool",
				"target",
				"soul_gain",
				"sk_show",
				"ai",
				"pow"
			})
		}
		
		var_112_20 = var_112_0(var_112_20, var_112_21)
		
		for iter_112_15 = 1, 9 do
			local var_112_22 = {
				DB("skill", iter_112_14, {
					"sk_add_con" .. iter_112_15,
					"sk_add_con_target" .. iter_112_15,
					"sk_add_con_value" .. iter_112_15,
					"sk_add_rate" .. iter_112_15,
					"sk_add_resist" .. iter_112_15,
					"sk_add_target" .. iter_112_15,
					"sk_add_eff" .. iter_112_15,
					"sk_eff_value" .. iter_112_15,
					"sk_eff_turn" .. iter_112_15
				})
			}
			
			var_112_20 = var_112_0(var_112_20, var_112_22)
		end
	end
	
	for iter_112_16, iter_112_17 in pairs(var_112_2.cs) do
		local var_112_23 = {
			DB("cs", tostring(iter_112_17), {
				"cs_con1",
				"cs_con_value1",
				"cs_con2",
				"cs_con_value2",
				"cs_con3",
				"cs_con_value3",
				"cs_eff1",
				"cs_eff_value1",
				"cs_eff2",
				"cs_eff_value2",
				"cs_eff3",
				"cs_eff_value3",
				"cs_eff4",
				"cs_eff_value4",
				"cs_target",
				"cs_timing",
				"cs_remove",
				"cs_type",
				"cs_turn",
				"cs_attribute",
				"cs_addmax",
				"cs_con_rate",
				"cs_timing_target"
			})
		}
		
		var_112_20 = var_112_0(var_112_20, var_112_23)
	end
	
	for iter_112_18, iter_112_19 in pairs(var_112_2.sklv) do
		local var_112_24 = SLOW_DB_ALL("sklv", tostring(iter_112_19))
		
		for iter_112_20 = 1, 9 do
			local var_112_25 = {
				DB("sklv", iter_112_19, {
					"type" .. iter_112_20,
					"add" .. iter_112_20,
					"mul" .. iter_112_20
				})
			}
			
			if not var_112_25[1] then
				break
			end
			
			var_112_20 = var_112_0(var_112_20, var_112_25)
		end
	end
	
	for iter_112_21, iter_112_22 in pairs(var_112_2.tree) do
		local var_112_26 = {
			DB("skill_tree", iter_112_22, {
				"skill_point",
				"pos_1",
				"req_1",
				"pos_2",
				"req_2",
				"pos_3",
				"req_3"
			})
		}
		
		var_112_20 = var_112_0(var_112_20, var_112_26)
	end
	
	for iter_112_23, iter_112_24 in pairs(var_112_2.rune) do
		local var_112_27 = {
			DB("skill_tree_rune", iter_112_24, {
				"name",
				"type",
				"icon_rune",
				"icon_mark",
				"stat",
				"value",
				"skill_number",
				"skill_lv",
				"tooltip",
				"tooltip_up"
			})
		}
		
		var_112_20 = var_112_0(var_112_20, var_112_27)
	end
	
	for iter_112_25, iter_112_26 in pairs(var_112_2.zodiac) do
		local var_112_28 = {
			DB("zodiac_stone_2", iter_112_26, {
				"skill_up",
				"main_stat_type",
				"main_stat",
				"sub_stat_type1",
				"sub_stat1",
				"sub_stat_type2",
				"sub_stat2",
				"sub_stat_type3",
				"sub_stat3"
			})
		}
		
		var_112_20 = var_112_0(var_112_20, var_112_28)
	end
	
	local var_112_29 = string_tomd5(var_112_20)
	
	print(var_112_29)
	
	return var_112_29
end

function var_0_0.getAtt(arg_116_0)
	return arg_116_0.status.att
end

function var_0_0.getRawMaxHP(arg_117_0)
	return arg_117_0.status.max_hp
end

function var_0_0.getBrokenHP(arg_118_0)
	return math.floor(math.max(arg_118_0.inst.dhp or 0, 0))
end

function var_0_0.getMaxHP(arg_119_0)
	return arg_119_0:getRawMaxHP() - arg_119_0:getBrokenHP()
end

function var_0_0.getSpeed(arg_120_0)
	return arg_120_0.status.speed
end

function var_0_0.getDiff(arg_121_0, arg_121_1)
	return arg_121_0.status[arg_121_1] - arg_121_0.character_status[arg_121_1]
end

function var_0_0.getBrokenHPRatio(arg_122_0, arg_122_1)
	local var_122_0 = arg_122_0:getBrokenHP() / arg_122_0:getRawMaxHP()
	
	if arg_122_1 then
		var_122_0 = math.floor(var_122_0 * 1000)
		
		while var_122_0 / 1000 * arg_122_0:getRawMaxHP() < arg_122_0:getBrokenHP() do
			var_122_0 = var_122_0 + 1
		end
	end
	
	return var_122_0
end

function var_0_0.getRawHPRatio(arg_123_0)
	return arg_123_0:getHP() / arg_123_0:getRawMaxHP()
end

function var_0_0.increaseBrokenHP(arg_124_0, arg_124_1)
	local var_124_0 = arg_124_0.inst.dhp or 0
	local var_124_1 = math.floor(arg_124_0:getRawMaxHP() * 0.5)
	
	if var_124_1 > arg_124_0.inst.dhp then
		arg_124_0.inst.dhp = (arg_124_0.inst.dhp or 0) + math.floor(arg_124_1)
		arg_124_0.inst.dhp = math.min(var_124_1, arg_124_0.inst.dhp)
	end
	
	if arg_124_0:getMaxHP() < arg_124_0.inst.hp then
		arg_124_0.inst.hp = arg_124_0:getMaxHP()
	end
	
	return arg_124_0.inst.dhp - var_124_0
end

function var_0_0.onDead(arg_125_0, arg_125_1)
	arg_125_0.inst.dead = true
	
	if arg_125_0.states:findByEff("CSP_TRANSFORM") then
		arg_125_0:resetTransform()
	end
	
	arg_125_0:onCalcExtinct("die")
end

function var_0_0.onSomeoneDead(arg_126_0, arg_126_1, arg_126_2)
	arg_126_0.states:onSomeoneDead(arg_126_1, "before", arg_126_2)
end

function var_0_0.onAfterSomeoneDead(arg_127_0, arg_127_1, arg_127_2)
	arg_127_0.states:onSomeoneDead(arg_127_1, "after", arg_127_2)
end

local var_0_8 = {
	{
		1
	},
	{
		0.4,
		0.6
	},
	{
		0.25,
		0.35,
		0.4
	},
	{
		0.1,
		0.2,
		0.3,
		0.4
	},
	{
		0.1,
		0.2,
		0.2,
		0.2,
		0.3
	},
	{
		0.1,
		0.1,
		0.2,
		0.2,
		0.2,
		0.2
	}
}

function var_0_0.onSetupTeam(arg_128_0, arg_128_1)
	arg_128_0.team = arg_128_1
end

function var_0_0.onSetupStage(arg_129_0, arg_129_1)
	arg_129_0.logic = arg_129_1
	arg_129_0.inst.toggled_cs = nil
end

function var_0_0.onCalcDamage(arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4, arg_130_5, arg_130_6)
	local var_130_0 = {}
	
	for iter_130_0, iter_130_1 in pairs(arg_130_0.logic.units) do
		if not iter_130_1:isDead() then
			local var_130_1 = iter_130_1.states:onCalcDamage(arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4, arg_130_5, arg_130_0, arg_130_6)
			
			if var_130_1 then
				table.add(var_130_0, var_130_1)
			end
		end
	end
	
	return var_130_0
end

function var_0_0.getBaseStat(arg_131_0)
	return arg_131_0.base_stat
end

function var_0_0.getStat(arg_132_0)
	return arg_132_0.stat
end

function var_0_0.getBaseStatus(arg_133_0)
	return arg_133_0.base_status
end

function var_0_0.getStatusWithoutStates(arg_134_0)
	return arg_134_0.status_without_states
end

function var_0_0.getCharacterStatus(arg_135_0)
	return arg_135_0.character_status
end

function var_0_0.getStatus(arg_136_0)
	return arg_136_0.status
end

function var_0_0.getOverStatus(arg_137_0)
	return arg_137_0.over_status or {}
end

function var_0_0.isMajorSkill(arg_138_0, arg_138_1)
	if arg_138_0:isTransformed() then
		return arg_138_0.transform_vars.skills[1] == arg_138_1
	end
	
	return arg_138_0.db.skills[1] == arg_138_1
end

function var_0_0.initTurnVars(arg_139_0)
	arg_139_0:clearTurnVars()
end

function var_0_0.clearTurnVars(arg_140_0)
	arg_140_0.turn_vars = {
		proc_dead_dirty = false,
		damage_tags = {},
		first_damage_tags = {},
		eff_counts = {},
		add_states = {},
		accum_damage = {}
	}
end

function var_0_0.dealDamage(arg_141_0, arg_141_1)
	local var_141_0 = false
	
	if not arg_141_0.skill_inst_vars then
		arg_141_0.skill_inst_vars = {}
		var_141_0 = true
	end
	
	local var_141_1 = arg_141_1.logs or {}
	local var_141_2 = arg_141_1.target
	local var_141_3 = arg_141_1.skill_id
	local var_141_4 = arg_141_1.random or getRandom(0)
	local var_141_5 = arg_141_1.cur_hit or 1
	local var_141_6 = arg_141_1.tot_hit or 1
	local var_141_7 = arg_141_1.half
	local var_141_8 = arg_141_1.selected_target
	local var_141_9 = arg_141_1.mul_dmg or 1
	local var_141_10 = arg_141_1.add_dmg or 0
	local var_141_11 = arg_141_1.add_pow or 0
	local var_141_12 = arg_141_0:getSkillLevel(var_141_3)
	local var_141_13
	local var_141_14
	local var_141_15
	local var_141_16
	local var_141_17
	local var_141_18
	local var_141_19
	local var_141_20
	local var_141_21
	local var_141_22
	local var_141_23
	local var_141_24
	local var_141_25
	local var_141_26
	local var_141_27 = arg_141_0:isStrongAgainst(var_141_2, var_141_3)
	local var_141_28 = arg_141_0:isWeaknessAgainst(var_141_2, var_141_3)
	local var_141_29 = not arg_141_1.is_coop and not arg_141_1.is_hidden
	local var_141_30 = arg_141_1.is_counter
	local var_141_31 = "normal"
	
	if arg_141_1.is_coop then
		var_141_31 = "coop"
	elseif arg_141_1.is_counter then
		var_141_31 = "counter"
	elseif arg_141_1.is_hidden then
		var_141_31 = "hidden"
	end
	
	local var_141_32, var_141_33 = arg_141_0:getSkillDB(var_141_3, {
		"ignore_critical",
		"ignore_smite"
	})
	local var_141_34 = var_141_32 == "y"
	local var_141_35 = var_141_33 == "y"
	
	if var_141_5 == 1 then
		Log.d("damage", "## attacker: ", arg_141_0.db.name, "target: ", var_141_2.db.name)
		
		var_141_2.turn_vars.skill_source_dirty = var_141_31
		var_141_25 = table.clone(arg_141_0:getStatus())
		var_141_26 = table.clone(var_141_2:getStatus())
		
		SkillProc.onPreCalcDamage_Skill(var_141_1, var_141_4, arg_141_0, var_141_2, var_141_3, var_141_25, var_141_26)
		arg_141_0.states:onPreCalcDamage(var_141_1, arg_141_0, var_141_3, var_141_2, var_141_25, var_141_26)
		
		if arg_141_0.skill_inst_vars.ignore_attribute then
			var_141_27 = true
			var_141_28 = false
		end
		
		var_141_2.states:onPreCalcTarget(var_141_1, arg_141_0, var_141_3, var_141_2, var_141_25, var_141_26)
		
		var_141_34 = var_141_25.ignore_critical or var_141_34
		var_141_35 = var_141_25.ignore_smite or var_141_35
		
		local var_141_36 = false
		local var_141_37 = false
		local var_141_38 = false
		local var_141_39 = false
		local var_141_40 = false
		local var_141_41 = false
		local var_141_42 = false
		local var_141_43 = 0
		local var_141_44 = 0
		local var_141_45 = 0
		
		if not arg_141_0:isSummon() then
			if var_141_27 then
				var_141_45 = FORMULA.weak_smite_rate(var_141_25, var_141_26)
				var_141_44 = FORMULA.weak_cri_rate(var_141_25, var_141_26)
			end
			
			if var_141_28 then
				var_141_43 = FORMULA.weak_dodge_rate(var_141_25, var_141_26)
			end
			
			if not DEBUG.MOVIE_MODE and var_141_4:get() + var_141_43 > FORMULA.hit(var_141_25, var_141_26) then
				var_141_37 = true
			elseif DEBUG.TEST_CRITICAL then
				if type(DEBUG.TEST_CRITICAL) == "number" then
					var_141_38 = math.random() < DEBUG.TEST_CRITICAL
				else
					var_141_38 = true
				end
			elseif DEBUG.TEST_SMITE then
				var_141_39 = true
			elseif var_141_4:get() < var_141_25.cri - var_141_26.cri_res + var_141_44 and not var_141_34 then
				var_141_38 = true
			elseif var_141_4:get() < var_141_25.smite + var_141_45 and not var_141_35 then
				var_141_39 = true
			end
			
			if DEBUG.TEST_NORMAL_DAMAGE then
				var_141_37 = false
				var_141_38 = false
				var_141_39 = false
			end
		end
		
		local var_141_46 = arg_141_0:onCalcDamage(var_141_3, var_141_2, var_141_37, var_141_38, var_141_39, var_141_8)
		
		table.add(var_141_1, var_141_46)
		
		if var_141_9 ~= 1 then
			print("=====================================================================================")
			print(" mul_dmg is ", var_141_9)
		end
		
		if var_141_11 > 0 then
			print("=====================================================================================")
			print(" add_pow is ", var_141_11)
		end
		
		if var_141_10 > 0 then
			print("=====================================================================================")
			print(" add_dmg is ", var_141_10)
		end
		
		var_141_25.att = var_141_25.att * arg_141_0:getSkillAttRate(var_141_3)
		
		local var_141_47 = (var_141_2.states:isExistEffect("CSP_IMMUNE_DEFPEN") and 0 or arg_141_0:getSkillDefPenRate(var_141_3)) + var_141_25.pen_rate
		
		var_141_26.def = var_141_26.def * math.max(0, 1 - var_141_47)
		
		local var_141_48 = FORMULA.dmg(var_141_25, var_141_26) * (arg_141_0:getSkillPow(var_141_3) + var_141_11)
		
		Log.d("damage", "기본 데미지", var_141_48)
		
		local var_141_49 = var_141_48 * var_141_9 + var_141_10
		
		Log.d("damage", "멀티 데미지? 적용 후 :", var_141_49)
		
		local var_141_50 = var_141_49 * var_141_25.dmg
		
		Log.d("damage", "상대 피해 증가(cs_eff=115) 후 :", var_141_50)
		
		if var_141_27 then
			var_141_50 = var_141_50 * FORMULA.weak_inc_dmg(var_141_25, var_141_26)
		elseif var_141_28 then
			var_141_50 = var_141_50 * FORMULA.weak_dec_dmg(var_141_25, var_141_26)
		end
		
		Log.d("damage", "속성 처리 후 :", var_141_50)
		
		if var_141_38 then
			var_141_50 = var_141_50 * (var_141_25.cri_dmg + arg_141_0.states:getOnAttackCriticalDamageRatio())
		end
		
		Log.d("damage", "크리티컬 적용 후:", var_141_50)
		
		if var_141_39 then
			var_141_50 = var_141_50 * var_141_25.smite_dmg
		end
		
		Log.d("damage", "강타 적용 후:", var_141_50)
		
		if var_141_37 then
			var_141_50 = var_141_50 * 0.75
			
			Log.d("damage", "회피 데미지 반감 후:", var_141_50)
		end
		
		local var_141_51 = var_141_50 + var_141_25.team_att_point_damage
		
		Log.d("damage", "파티 공격력 비례 피해 증가(before_eff=2302) 후:", var_141_51)
		
		local var_141_52 = var_141_51 + var_141_25.team_pow_point_damage
		
		Log.d("damage", "파티 전투력 비례 피해 증가(BF_DMG_UP_PARTY_POWER) 후:", var_141_52)
		
		local var_141_53 = math.max(var_141_6, var_141_52)
		
		if arg_141_0.logic:isProtectedByTanker(var_141_2) and var_141_2.team:getUnitIndex(var_141_2) ~= 1 then
			var_141_53 = math.max(1, var_141_53 * 0.7)
			var_141_7 = true
		end
		
		Log.d("damage", "후방 진형 피해량 감소 후:", var_141_53)
		
		local var_141_54 = math.floor(var_141_53)
		
		if arg_141_0.logic:isSkillPreview() then
			var_141_54 = 100
		end
		
		if DEBUG.DEBUG_DAMAGE_1 then
			var_141_54 = 1
		end
		
		if not var_141_2:isInvincible() and var_141_2:isAntiSkillDamage() then
			var_141_36 = true
			
			var_141_2:decAntiDamageCount(var_141_1)
		end
		
		if arg_141_0.skill_inst_vars.ignore_guard or var_141_2.states:isExistEffect("CSP_GUARD_BLOCK") then
			var_141_40 = true
		end
		
		local var_141_55 = var_141_2.states:isExistEffect("CSP_IGNORE_DAMAGE_REDUCE")
		
		if arg_141_0.skill_inst_vars.ignore_damage_reduce or var_141_55 then
			var_141_41 = true
			
			if not arg_141_0.skill_inst_vars.ignore_damage_reduce and var_141_55 then
				var_141_42 = true
			end
		end
		
		local var_141_56 = var_141_54
		local var_141_57 = var_141_54 * var_141_26.self_dmg
		
		Log.d("damage", "상대의 받는 피해 증가 후 :", var_141_57)
		
		var_141_2.turn_vars.skill_source_dirty = nil
		var_141_13 = var_141_2:setSkillDamageTag({
			attacker = arg_141_0,
			skill_id = var_141_3,
			original_damage = var_141_56,
			damage = var_141_57,
			miss = var_141_37,
			critical = var_141_38,
			smite = var_141_39,
			cur_hit = var_141_5,
			tot_hit = var_141_6,
			half = var_141_7,
			is_normal = var_141_29,
			antiskilldamage = var_141_36,
			ignore_guard = var_141_40,
			ignore_damage_reduce = var_141_41,
			is_counter = var_141_30,
			source = var_141_31,
			ignore_reduce_effect_by_target = var_141_42
		})
		
		local var_141_58 = var_141_2:onBeforeDamage(var_141_3, var_141_2, var_141_37, var_141_38, var_141_39, arg_141_0)
		
		Log.d("damage", "상대의 피격 전 패시브 발동 후:", var_141_13.damage)
		table.join(var_141_1, var_141_58)
		
		local var_141_59 = var_141_2:onBeforeModifiedDamage(var_141_3, var_141_2, var_141_37, var_141_38, var_141_39, arg_141_0)
		
		table.join(var_141_1, var_141_59)
		
		local var_141_60 = var_141_13.damage
		
		Log.d("damage", "TotalDamage: ", var_141_13.damage, "Miss: ", var_141_13.miss, "Critical: ", var_141_13, var_141_38)
	else
		var_141_13 = var_141_2:skillDamageTag(arg_141_0)
		
		if not var_141_13 then
			Log.e("damage", "damage_tag is nil ", "cur_hit: ", var_141_5, "tot_hit: ", var_141_6)
		end
	end
	
	var_141_13.cur_hit = var_141_5
	
	local var_141_61 = var_141_13.damage
	local var_141_62 = var_141_13.miss
	local var_141_63 = var_141_13.critical
	local var_141_64 = var_141_13.smite
	local var_141_65 = var_141_13.antiskilldamage
	local var_141_66 = arg_141_0:getCurrentDamage(var_141_5, var_141_6, var_141_61)
	local var_141_67
	local var_141_68
	
	if arg_141_0:getAlly() == FRIEND then
		arg_141_0.logic:setMaxDamage(var_141_13.damage)
	end
	
	local var_141_69, var_141_70, var_141_71 = var_141_2:decHP(var_141_1, var_141_66, {
		attacker = arg_141_0,
		skill_id = var_141_3,
		antiskilldamage = var_141_65
	}, var_141_13)
	
	var_141_13.dec_hp = (var_141_13.dec_hp or 0) + (var_141_71 or 0)
	
	if var_141_71 and var_141_69 - var_141_71 < 0 then
		arg_141_0.logic:insertRateSSR(var_141_69, var_141_71, var_141_3)
	end
	
	if var_141_5 == var_141_6 and not arg_141_1.coop_order then
		var_141_24 = DB("skill", var_141_3, "flying") ~= nil
	end
	
	local var_141_72 = {
		type = "attack",
		from = arg_141_0,
		target = var_141_2,
		damage = var_141_69,
		critical = var_141_63,
		smite = var_141_64,
		miss = var_141_62,
		cur_hit = var_141_5,
		tot_hit = var_141_6,
		fly = var_141_24,
		half = var_141_7,
		total_damage = var_141_61,
		shield = var_141_70,
		weak = var_141_27,
		resist = var_141_28,
		dec_hp = var_141_71,
		antiskilldamage = var_141_65
	}
	
	if var_141_25 and var_141_26 and DEBUG._TEST_MODE then
		var_141_72.debug_info = {
			attacker_status = var_141_25,
			target_status = var_141_26
		}
	end
	
	table.insert(var_141_1, var_141_72)
	
	if var_141_0 then
		arg_141_0.skill_inst_vars = nil
	end
	
	return var_141_72
end

function var_0_0.getCurrentDamage(arg_142_0, arg_142_1, arg_142_2, arg_142_3)
	if arg_142_2 == 1 then
		return math.max(1, math.floor(arg_142_3))
	end
	
	if arg_142_1 == arg_142_2 then
		local var_142_0 = 0
		
		for iter_142_0 = 1, arg_142_2 - 1 do
			var_142_0 = var_142_0 + arg_142_0:getCurrentDamage(iter_142_0, arg_142_2, arg_142_3)
		end
		
		return math.max(1, math.floor(arg_142_3 - var_142_0))
	end
	
	local var_142_1 = arg_142_3 * 0.5
	local var_142_2 = 0
	
	for iter_142_1 = 1, arg_142_2 do
		var_142_2 = var_142_2 + iter_142_1
	end
	
	return math.max(1, math.floor(arg_142_3 / arg_142_2 * 0.5 + arg_142_1 / var_142_2 * var_142_1))
end

function var_0_0.onBeforeDamage(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5, arg_143_6)
	local var_143_0 = {}
	
	for iter_143_0, iter_143_1 in pairs(arg_143_0.logic.units) do
		if not iter_143_1:isDead() then
			local var_143_1 = iter_143_1.states:onPreBeforeDamage(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5, arg_143_6)
			
			table.join(var_143_0, var_143_1)
		end
	end
	
	for iter_143_2, iter_143_3 in pairs(arg_143_0.logic.units) do
		if not iter_143_3:isDead() then
			local var_143_2 = iter_143_3.states:onBeforeDamage(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5, arg_143_6)
			
			table.join(var_143_0, var_143_2)
		end
	end
	
	return var_143_0
end

function var_0_0.onBeforeModifiedDamage(arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4, arg_144_5, arg_144_6)
	local var_144_0 = {}
	
	for iter_144_0, iter_144_1 in pairs(arg_144_0.logic.units) do
		if not iter_144_1:isDead() then
			local var_144_1 = iter_144_1.states:onBeforeModifiedDamage(arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4, arg_144_5, arg_144_6)
			
			table.join(var_144_0, var_144_1)
		end
	end
	
	return var_144_0
end

function var_0_0.onAfterDamage(arg_145_0, arg_145_1, arg_145_2)
	arg_145_0.states:onAfterDamage(arg_145_1, arg_145_2)
end

function var_0_0.onAfterAttacked(arg_146_0, arg_146_1, arg_146_2, arg_146_3)
	local var_146_0 = {}
	
	for iter_146_0, iter_146_1 in pairs(arg_146_0.logic.units) do
		if not iter_146_1:isDead() then
			local var_146_1 = iter_146_1.states:onAfterAttacked(arg_146_0, arg_146_1, arg_146_2, arg_146_3)
			
			table.join(var_146_0, var_146_1)
		end
	end
	
	return var_146_0
end

function var_0_0.onDamageFinishedAll(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
	local var_147_0 = {}
	
	for iter_147_0, iter_147_1 in pairs(arg_147_0.logic.units) do
		if not iter_147_1:isDead() then
			local var_147_1 = iter_147_1.states:onDamageFinishedAll(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
			
			table.join(var_147_0, var_147_1)
		end
	end
	
	return var_147_0
end

function var_0_0.onAfterAttacked_ContainDead(arg_148_0, arg_148_1, arg_148_2, arg_148_3)
	local var_148_0 = {}
	
	for iter_148_0, iter_148_1 in pairs(arg_148_0.logic.units) do
		if not iter_148_1:isDead() then
			local var_148_1 = iter_148_1.states:onAfterAttacked_ContainDead(arg_148_0, arg_148_1, arg_148_2, arg_148_3)
			
			table.join(var_148_0, var_148_1)
		end
	end
	
	return var_148_0
end

function var_0_0.resetVariablePassiveDirty(arg_149_0)
	arg_149_0.tmp_vars.prev_hp = nil
end

function var_0_0.isExistVariablePassive(arg_150_0)
	return arg_150_0.states:isExistEffectTiming(31)
end

function var_0_0.onToggleVariablePassive(arg_151_0)
	if not arg_151_0:isDead() and arg_151_0.tmp_vars.prev_hp ~= arg_151_0:getHP() then
		arg_151_0.tmp_vars.prev_hp = arg_151_0:getHP()
		
		if arg_151_0:isExistVariablePassive() then
			arg_151_0:calc()
		end
	end
end

function var_0_0.onBeforeSkillDamage(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4, arg_152_5)
	local var_152_0 = {}
	
	for iter_152_0, iter_152_1 in pairs(arg_152_0.logic.units) do
		if not iter_152_1:isDead() then
			local var_152_1 = iter_152_1.states:onBeforeSkillDamage(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4, arg_152_5)
			
			table.join(var_152_0, var_152_1)
		end
	end
	
	return var_152_0
end

function var_0_0.onAfterSkill(arg_153_0, arg_153_1, arg_153_2, arg_153_3, arg_153_4, arg_153_5)
	local var_153_0 = {}
	
	arg_153_0:removeAfterSkill(var_153_0, arg_153_4)
	
	for iter_153_0, iter_153_1 in pairs(arg_153_0.logic.units) do
		if not iter_153_1:isDead() then
			local var_153_1 = iter_153_1.states:onAfterSkill(arg_153_0, arg_153_1, arg_153_2, arg_153_3, arg_153_4, arg_153_5)
			
			table.join(var_153_0, var_153_1)
		end
	end
	
	return var_153_0
end

function var_0_0.onAfterEffects(arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4, arg_154_5)
	local var_154_0 = {}
	
	for iter_154_0 = 1, 5 do
		for iter_154_1, iter_154_2 in pairs(arg_154_0.logic.units) do
			if not iter_154_2:isDead() then
				local var_154_1 = iter_154_2.states:onAfterEffects(iter_154_0, arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4, arg_154_5)
				
				table.join(var_154_0, var_154_1)
				
				if iter_154_2:isEmptyHP() and iter_154_2:getReserveResurrectBlock() and not iter_154_2.inst.resurrect_block then
					iter_154_2:setResurrectBlock(var_154_0)
				end
			end
		end
	end
	
	return var_154_0
end

function var_0_0.onSimilarDamageFinished(arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4, arg_155_5)
	local var_155_0 = {}
	
	for iter_155_0, iter_155_1 in pairs(arg_155_0.logic.units) do
		if not iter_155_1:isDead() then
			local var_155_1 = iter_155_1.states:onSimilarDamageFinished(arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4, arg_155_5)
			
			table.join(var_155_0, var_155_1)
		end
	end
	
	return var_155_0
end

function var_0_0.onSimilarDamageFinished_ContainDead(arg_156_0, arg_156_1, arg_156_2, arg_156_3, arg_156_4)
	return arg_156_0:onSimilarDamageFinished(arg_156_1, arg_156_2, arg_156_3, arg_156_4, true)
end

function var_0_0.onDamageFinished(arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4, arg_157_5)
	local var_157_0 = {}
	
	for iter_157_0, iter_157_1 in pairs(arg_157_0.logic.units) do
		if not iter_157_1:isDead() then
			local var_157_1 = iter_157_1.states:onDamageFinished(arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4, arg_157_5)
			
			table.join(var_157_0, var_157_1)
		end
	end
	
	return var_157_0
end

function var_0_0.onDamageFinished_ContainDead(arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4)
	return arg_158_0:onDamageFinished(arg_158_1, arg_158_2, arg_158_3, arg_158_4, true)
end

function var_0_0.onBeforeDead(arg_159_0, arg_159_1)
	if arg_159_0.turn_vars.proc_dead_dirty then
		return 
	end
	
	for iter_159_0, iter_159_1 in pairs(arg_159_0.logic.units) do
		iter_159_1.states:onBeforeDead(arg_159_1, arg_159_0)
	end
end

function var_0_0.onRemoveAuraState(arg_160_0, arg_160_1, arg_160_2)
	arg_160_1 = arg_160_1 or {}
	
	arg_160_0.states:removeAuraState(arg_160_1, arg_160_2)
	
	return arg_160_1
end

function var_0_0.setFlagDeadDirty(arg_161_0, arg_161_1)
	arg_161_0.turn_vars.proc_dead_dirty = arg_161_1
end

function var_0_0.removeAfterSkill(arg_162_0, arg_162_1, arg_162_2)
	arg_162_0.states:removeAfterSkill(arg_162_1, arg_162_2)
end

function var_0_0.isInvincible(arg_163_0)
	return arg_163_0.states:findByEff("CSP_INVINCIBLE")
end

function var_0_0.isAntiSkillDamage(arg_164_0)
	return arg_164_0.states:findByEff("CSP_ANTI_SKILLDAMAGE")
end

function var_0_0.isModelChange(arg_165_0)
	return arg_165_0.states:findByEff("CSP_MODELCHANGE")
end

function var_0_0.checkTransform(arg_166_0)
	if arg_166_0:isTransformed() then
		arg_166_0:setTransform()
	end
end

function var_0_0.getTransformVars(arg_167_0)
	return arg_167_0.transform_vars or {}
end

function var_0_0.isTransformed(arg_168_0)
	return arg_168_0.states:findByEff("CSP_TRANSFORM")
end

function var_0_0.setTransform(arg_169_0)
	local var_169_0 = arg_169_0:isTransformed()
	
	if not var_169_0 then
		return 
	end
	
	arg_169_0:_removeAllPassive()
	
	local var_169_1 = var_169_0:getEffValue("CSP_TRANSFORM")
	local var_169_2, var_169_3, var_169_4, var_169_5 = DB("character", var_169_1, {
		"model_id",
		"model_opt",
		"face_id",
		"skin"
	})
	local var_169_6 = {
		DB("character", var_169_1, {
			"skill1",
			"skill2",
			"skill3",
			"skill4",
			"skill5",
			"skill6",
			"skill7",
			"skill8",
			"skill9",
			"skill_immune",
			"pskill_1",
			"pskill_2",
			"pskill_3"
		})
	}
	
	for iter_169_0, iter_169_1 in pairs(var_169_6) do
		local var_169_7, var_169_8 = var_0_1(iter_169_1)
		
		var_169_6[iter_169_0] = var_169_7
	end
	
	local var_169_9 = {}
	local var_169_10 = {}
	
	for iter_169_2 = 1, 10 do
		if var_169_6[iter_169_2] then
			var_169_9[var_169_6[iter_169_2]] = 0
		end
	end
	
	local var_169_11 = SkillBundle(arg_169_0)
	
	for iter_169_3, iter_169_4 in pairs(var_169_6) do
		var_169_11:load(iter_169_3, iter_169_4)
	end
	
	arg_169_0.transform_vars = {
		code = var_169_1,
		model_id = var_169_2,
		model_opt = var_169_3,
		skills = var_169_6,
		skill_bundle = var_169_11,
		skill_cool = var_169_9,
		face_id = var_169_4,
		skin = var_169_5
	}
	
	arg_169_0.transform_vars.skill_bundle:initTurn()
	arg_169_0:onRemoveAuraState({}, "before")
	arg_169_0:onRemoveAuraState({}, "after")
	arg_169_0:calc()
	
	if arg_169_0.logic then
		arg_169_0.logic:onInfos({
			type = "transform",
			target = arg_169_0
		})
	end
end

function var_0_0.resetTransform(arg_170_0)
	if arg_170_0.transform_vars and arg_170_0.transform_vars.skills then
		for iter_170_0, iter_170_1 in pairs(arg_170_0.transform_vars.skills) do
			if iter_170_1 then
				local var_170_0 = arg_170_0:getSkillDB(iter_170_1, "sk_passive")
				
				if var_170_0 then
					arg_170_0.states:removePassiveById(var_170_0)
				end
			end
		end
	end
	
	arg_170_0.transform_vars = nil
	
	local var_170_1 = arg_170_0.states:findByEff("CSP_TRANSFORM")
	
	if var_170_1 then
		var_170_1:setValid(false)
		
		if arg_170_0.states:canRemoveStateInfo(var_170_1) then
			var_170_1:removeState(logs)
		end
	end
	
	arg_170_0:calc()
	
	if arg_170_0.logic then
		arg_170_0.logic:onInfos({
			type = "transform",
			target = arg_170_0
		})
	end
end

function var_0_0.decAntiDamageCount(arg_171_0, arg_171_1)
	return arg_171_0.states:decAntiDamageCount(arg_171_1)
end

function var_0_0.getResourceRateValue(arg_172_0)
	return arg_172_0.states:getResourceRateValue()
end

function var_0_0.getActionBarUpRate(arg_173_0)
	local var_173_0 = arg_173_0.states:findByEffWithoutBlock("CSP_IMMUNE_AB_UP_RATE_DOWN")
	local var_173_1 = arg_173_0.states:getSumEffValue("AB_UP_RATE", function(arg_174_0)
		if var_173_0 then
			return math.max(arg_174_0, 0)
		end
		
		return arg_174_0
	end)
	
	if arg_173_0.states:findByEffWithoutBlock("CSP_AB_UP_RATE_FIX") then
		return (arg_173_0.states:getSumEffValue("CSP_AB_UP_RATE_FIX"))
	end
	
	return math.max(var_173_1, -1)
end

function var_0_0.getActionBarDownRate(arg_175_0)
	local var_175_0 = arg_175_0.states:getSumEffValue("AB_DOWN_RATE")
	
	return math.max(var_175_0, -1)
end

function var_0_0.getHpUpDamageRate(arg_176_0)
	local var_176_0 = arg_176_0.states:getSumEffValue("HPUP_DAMAGE_RATE")
	
	return math.max(0, 1 + var_176_0)
end

function var_0_0.getDamageShareInfo(arg_177_0)
	local var_177_0 = arg_177_0.logic:pickUnits(arg_177_0, FRIEND, arg_177_0)
	local var_177_1
	local var_177_2
	
	for iter_177_0, iter_177_1 in pairs(var_177_0) do
		local var_177_3, var_177_4 = iter_177_1.states:findBestOneByEffWithPos("CSP_ALLY_GUARD", "owner")
		
		if var_177_3 and (not var_177_2 or var_177_2 == var_177_4 and to_n(var_177_3.owner.inst.pos) < to_n(var_177_1.owner.inst.pos) or var_177_2 < var_177_4) then
			var_177_1 = var_177_3
			var_177_2 = var_177_4
		end
	end
	
	local var_177_5, var_177_6 = arg_177_0.states:findBestOneByEffWithPos("CSP_GUARD", "giver")
	local var_177_7, var_177_8 = arg_177_0.states:findBestOneByEffWithPos("CSP_DAMAGELINK_FRONT", "giver")
	
	local function var_177_9(arg_178_0, arg_178_1)
		return 0.001 > math.abs(to_n(arg_178_0) - to_n(arg_178_1))
	end
	
	if to_n(var_177_2) > to_n(var_177_6) then
		var_177_6 = var_177_2
		var_177_5 = var_177_1
	elseif var_177_9(var_177_2, var_177_6) and var_177_1 and var_177_5 and (((var_177_1.owner or {}).inst or {}).pos or 999) < (((var_177_5.giver or {}).inst or {}).pos or 999) then
		var_177_6 = var_177_2
		var_177_5 = var_177_1
	end
	
	local var_177_10
	local var_177_11
	local var_177_12
	local var_177_13
	
	if (to_n(var_177_8) > to_n(var_177_6) or var_177_9(var_177_8, var_177_6)) and arg_177_0.inst.line ~= FRONT then
		local var_177_14 = arg_177_0.logic:pickUnits(arg_177_0, FRIEND, arg_177_0)
		
		for iter_177_2, iter_177_3 in pairs(var_177_14) do
			if iter_177_3.inst.line == FRONT then
				var_177_10 = iter_177_3
				
				break
			end
		end
		
		if var_177_10 and not var_177_10:isDead() then
			var_177_11 = var_177_7
			var_177_12 = var_177_8
			var_177_13 = true
		end
	end
	
	if not var_177_13 then
		var_177_11 = var_177_5
		var_177_12 = var_177_6
		
		if var_177_5 then
			if var_177_5:checkEff("CSP_ALLY_GUARD") then
				var_177_10 = var_177_5.owner
			else
				var_177_10 = var_177_5.giver
			end
		end
	end
	
	return var_177_10, var_177_11, var_177_12
end

function var_0_0.decHP(arg_179_0, arg_179_1, arg_179_2, arg_179_3, arg_179_4)
	if arg_179_0.logic:isSkillPreview() and not arg_179_4 then
		arg_179_2 = 10
	end
	
	arg_179_4 = arg_179_4 or {}
	arg_179_3 = arg_179_3 or {}
	
	local var_179_0 = arg_179_0:getHP()
	
	if arg_179_0:isInvincible() then
		return 0
	end
	
	if arg_179_3.antiskilldamage then
		return 0
	end
	
	local var_179_1 = arg_179_0.states:isExistEffect("CSP_GUARD_BLOCK")
	
	if not arg_179_3.ignore_guard and not arg_179_4.ignore_guard and not var_179_1 then
		local var_179_2, var_179_3, var_179_4 = arg_179_0:getDamageShareInfo()
		
		if var_179_3 and var_179_2 and not var_179_2:isDead() then
			local var_179_5
			
			if arg_179_4 and arg_179_4.cur_hit then
				var_179_5 = arg_179_0:getCurrentDamage(arg_179_4.cur_hit, arg_179_4.tot_hit, arg_179_4.damage * var_179_4)
			else
				var_179_5 = math.floor(arg_179_2 * var_179_4)
			end
			
			if var_179_5 > 0 then
				arg_179_2 = arg_179_2 - var_179_5
				
				local var_179_6, var_179_7, var_179_8 = var_179_2:decHP(arg_179_1, var_179_5, {
					ignore_guard = true,
					ignore_shield = arg_179_3.ignore_shield
				}, arg_179_4)
				
				table.insert(arg_179_1, {
					type = "attack",
					from = arg_179_3.attacker,
					target = var_179_2,
					cur_hit = arg_179_4.cur_hit or 1,
					tot_hit = arg_179_4.tot_hit or 1,
					damage = var_179_6,
					shield = var_179_7,
					dec_hp = var_179_8
				})
			end
		end
	end
	
	local var_179_9
	local var_179_10 = to_n(DB("skill", arg_179_3.skill_id, "target"))
	
	if not arg_179_3.ignore_shield then
		var_179_9 = arg_179_0.states:decShield(arg_179_1, arg_179_2)
		
		if var_179_9 then
			arg_179_2 = arg_179_2 - var_179_9
			
			arg_179_0:setAccumDamage(var_179_10, var_179_9)
		end
		
		if arg_179_2 <= 0 then
			return arg_179_2, var_179_9
		end
	end
	
	local var_179_11, var_179_12 = arg_179_0.states:isExistEffect("CSP_HP_FIXED")
	
	if var_179_11 then
		local var_179_13 = arg_179_0:getHP() - arg_179_2
		local var_179_14 = math.floor(arg_179_0:getMaxHP() * var_179_12)
		
		if var_179_13 <= var_179_14 then
			arg_179_2 = math.floor(math.max(1, arg_179_0:getHP() - var_179_14))
		end
	end
	
	if arg_179_0.logic:isScoringUnit(arg_179_0) then
		arg_179_0.logic:setDamageScore(arg_179_2)
	end
	
	local var_179_15 = arg_179_0.inst.hp
	
	arg_179_0.inst.hp = math.max(0, arg_179_0.inst.hp - arg_179_2)
	
	local var_179_16 = var_179_15 - arg_179_0.inst.hp
	local var_179_17 = arg_179_0.states:findByEff("CSP_UNDYING")
	
	if var_179_17 or DEBUG.DEMONSTRATION and arg_179_0.inst.ally == FRIEND or DEBUG.INVINCIBLE == arg_179_0.inst.ally or arg_179_0.logic:isSkillPreview() or DEBUG.DEBUG_ALL_INVINCIBLE or arg_179_0.inst.INVINSIBLE or type(DEBUG.INVINCIBLE) == "table" and table.find(DEBUG.INVINCIBLE, arg_179_0.inst.ally) then
		if arg_179_0.inst.hp < 1 and arg_179_4.cur_hit == arg_179_4.tot_hit and (not var_179_17 or var_179_17.db.system_text_hide ~= "y") then
			table.insert(arg_179_1, {
				text = "sk_undying",
				type = "text",
				target = arg_179_0
			})
		end
		
		arg_179_0.inst.hp = math.max(1, arg_179_0.inst.hp)
	end
	
	if arg_179_2 > 0 then
		arg_179_0:setAccumDamage(var_179_10, arg_179_2)
	end
	
	if not arg_179_4 or arg_179_4 and arg_179_4.cur_hit == arg_179_4.tot_hit then
		arg_179_0:onAfterDamage(arg_179_1, arg_179_3)
	end
	
	if var_179_15 > 0 and not arg_179_0:isDead() then
		if arg_179_0:isStunned() then
			arg_179_0:onCalcExtinct("stun")
		else
			arg_179_0:onCalcExtinct("hit")
		end
	end
	
	local var_179_18 = not table.empty(arg_179_4)
	
	if not arg_179_0:isDead() and arg_179_0:isEmptyHP() and (not var_179_18 and var_179_15 > 0 or var_179_18 and arg_179_4.cur_hit == arg_179_4.tot_hit) then
		arg_179_0.inst.dead_from = arg_179_3.attacker
		
		arg_179_0:onBeforeDead(arg_179_1)
	end
	
	return arg_179_2, var_179_9, var_179_16
end

function var_0_0.getSkillByIndex(arg_180_0, arg_180_1)
	if arg_180_0:isTransformed() then
		return arg_180_0.transform_vars.skills[arg_180_1]
	end
	
	return arg_180_0.db.skills[arg_180_1]
end

function var_0_0.getSkillLevelByIndex(arg_181_0, arg_181_1)
	if arg_181_0:isTransformed() then
		return 0
	end
	
	return arg_181_0.inst.skill_lv[arg_181_1] or 0
end

function var_0_0.getMaxSkillLevelByIndex(arg_182_0, arg_182_1)
	local var_182_0 = arg_182_0:getSkillByIndex(arg_182_1)
	local var_182_1 = GAME_STATIC_VARIABLE.skill_max_level
	
	for iter_182_0 = 1, var_182_1 do
		if not DB("skill", var_182_0, "sk_lv_eff" .. iter_182_0) then
			return iter_182_0 - 1
		end
	end
	
	return var_182_1
end

function var_0_0.isSkillUpgradable(arg_183_0)
	for iter_183_0 = 1, 3 do
		if not arg_183_0:getSkillByIndex(iter_183_0) then
			break
		end
		
		if arg_183_0:getSkillLevelByIndex(iter_183_0) ~= arg_183_0:getMaxSkillLevelByIndex(iter_183_0) then
			return true
		end
	end
	
	return false
end

function var_0_0.getUsableSkillIndexList(arg_184_0)
	local var_184_0 = {}
	
	for iter_184_0, iter_184_1 in pairs(arg_184_0.db.skills) do
		if SkillFactory.create(iter_184_1, arg_184_0):checkUseSkill() then
			var_184_0[#var_184_0] = iter_184_0
		end
	end
	
	return var_184_0
end

function var_0_0.getSkillIdForSkillTurn(arg_185_0, arg_185_1)
	local var_185_0 = arg_185_1
	
	if arg_185_0:getSkillCoolData()[arg_185_1] == nil then
		local var_185_1 = arg_185_0:getSkillDB(arg_185_1, "parent_skill")
		
		if var_185_1 then
			var_185_0 = var_185_1
		end
	end
	
	return var_185_0 or arg_185_1
end

function var_0_0.onUseSkill(arg_186_0, arg_186_1, arg_186_2)
	local var_186_0, var_186_1, var_186_2, var_186_3, var_186_4 = arg_186_0:getSkillDB(arg_186_1, {
		"point_gain",
		"point_require",
		"turn_cool",
		"soul_gain",
		"soul_req"
	})
	
	if not arg_186_2 then
		local var_186_5 = arg_186_0:getSkillIdForSkillTurn(arg_186_1)
		
		if not var_186_5 then
			Log.e("skill", "skill_cool_id is nil " .. arg_186_1)
		end
		
		arg_186_0:getSkillCoolData()[var_186_5] = var_186_2 or 0
	end
	
	arg_186_0.skill_inst_vars = {}
	arg_186_0.skill_inst_vars.res_ratio = arg_186_0:getSPRatio()
	
	if var_186_1 then
		arg_186_0:addRes(0 - var_186_1, nil, true)
	end
	
	if var_186_0 then
		arg_186_0:addRes(var_186_0)
	end
	
	arg_186_0.turn_vars.eff_list = nil
	arg_186_0.inst.use_skill = arg_186_1
	
	if arg_186_0.states:isExistEffect("CSP_SOULLOCK") then
		var_186_3 = 0
	end
	
	local var_186_6 = arg_186_0.states:isExistEffect("CSP_FREE_SOULBURN")
	
	if var_186_4 and not var_186_6 then
		arg_186_0:addTeamRes("soul_piece", 0 - var_186_4)
	end
	
	arg_186_0.turn_vars.soul_gain = var_186_3
	
	return {
		point_gain = var_186_0,
		point_require = var_186_1,
		soul_req = var_186_4,
		soul_gain = var_186_3
	}
end

function var_0_0.removeEquip(arg_187_0, arg_187_1)
	if arg_187_1.parent == arg_187_0:getUID() then
		for iter_187_0, iter_187_1 in pairs(arg_187_0.equips) do
			if iter_187_1.id == arg_187_1.id then
				table.remove(arg_187_0.equips, iter_187_0)
				
				if arg_187_1:isExclusive() then
					arg_187_0.inst.exclusive_effect = {}
				end
				
				break
			end
		end
		
		arg_187_0:reset()
	end
	
	arg_187_1:putOff(arg_187_0)
end

function var_0_0.getEquipByIndex(arg_188_0, arg_188_1)
	return arg_188_0:getEquipByPos(EQUIP:getEquipPositionByIndex(arg_188_1))
end

function var_0_0.getEquipByPos(arg_189_0, arg_189_1)
	for iter_189_0, iter_189_1 in pairs(arg_189_0.equips) do
		if iter_189_1.db.type == arg_189_1 then
			return iter_189_1
		end
	end
	
	return nil
end

function var_0_0.isWearedEquipID(arg_190_0, arg_190_1)
	for iter_190_0, iter_190_1 in pairs(arg_190_0.equips) do
		if iter_190_1.id == arg_190_1 then
			return true
		end
	end
	
	return false
end

function var_0_0.addExternalPassive(arg_191_0, arg_191_1, arg_191_2)
	print("##### addExternalPassive", arg_191_1, arg_191_2)
	table.insert(arg_191_0.external_passive, {
		skill_id = arg_191_1,
		skill_lv = arg_191_2
	})
end

function var_0_0.getExternalPassive(arg_192_0)
	return arg_192_0.external_passive
end

function var_0_0.addEquip(arg_193_0, arg_193_1, arg_193_2)
	if arg_193_0:getEquipByPos(arg_193_1.db.type) then
		return false
	end
	
	arg_193_0.equips[#arg_193_0.equips + 1] = arg_193_1
	
	if not arg_193_2 then
		arg_193_0:calc()
	end
	
	arg_193_1:putOn(arg_193_0)
	
	return true
end

function var_0_0.hasArtifact(arg_194_0)
	for iter_194_0, iter_194_1 in pairs(arg_194_0.equips) do
		if iter_194_1:isArtifact() then
			return true
		end
	end
end

function var_0_0.getArtifact(arg_195_0)
	for iter_195_0, iter_195_1 in pairs(arg_195_0.equips) do
		if iter_195_1:isArtifact() then
			return iter_195_1
		end
	end
	
	return nil
end

function var_0_0.addRes(arg_196_0, arg_196_1, arg_196_2, arg_196_3)
	if arg_196_0:isSummon() or arg_196_0:getSPName() == "none" then
		return 
	end
	
	arg_196_2 = arg_196_2 or arg_196_0:getSPName()
	
	local var_196_0 = arg_196_1
	
	if not arg_196_3 then
		var_196_0 = arg_196_0:getResourceRateValue() * var_196_0
	end
	
	arg_196_0.inst[arg_196_2] = math.max(0, math.min(arg_196_0:getMaxSP(arg_196_2), arg_196_0.inst[arg_196_2] + var_196_0))
end

function var_0_0.getTeamRes(arg_197_0, arg_197_1)
	if arg_197_0.team then
		return arg_197_0.team:getRes(arg_197_1)
	end
end

function var_0_0.addTeamRes(arg_198_0, arg_198_1, arg_198_2)
	if arg_198_0.team then
		arg_198_0.team:addRes(arg_198_1, arg_198_2)
	end
end

function var_0_0.setTeamRes(arg_199_0, arg_199_1, arg_199_2)
	if arg_199_0.team then
		return arg_199_0.team:setRes(arg_199_1, arg_199_2)
	end
end

function var_0_0.incTurn(arg_200_0, arg_200_1)
	if arg_200_0:isDead() then
		return false
	end
	
	if arg_200_0.logic:isSkillPreview() then
		if arg_200_0.inst.ally ~= FRIEND then
			return false
		end
		
		if arg_200_0.db.code == "m9201" then
			return false
		end
	end
	
	local var_200_0 = math.clamp(to_n(arg_200_0.states:getSumEffValue("CSP_AB_SPEED_RATE_DOWN")), 0, 0.9999)
	local var_200_1 = math.max(0, arg_200_0.status.speed * (1 - var_200_0))
	
	arg_200_0.inst.elapsed_ut = arg_200_0.inst.elapsed_ut + var_200_1 * arg_200_1
	
	return arg_200_0.inst.elapsed_ut >= MAX_UNIT_TICK
end

function var_0_0.getTurnTick(arg_201_0)
	local var_201_0 = math.clamp(to_n(arg_201_0.states:getSumEffValue("CSP_AB_SPEED_RATE_DOWN")), 0, 0.9999)
	local var_201_1 = arg_201_0.status.speed * (1 - var_201_0)
	
	return MAX_UNIT_TICK / (arg_201_0.status.speed * (1 - var_201_0))
end

function var_0_0.getRestTimeAndTick(arg_202_0)
	local var_202_0 = math.clamp(to_n(arg_202_0.states:getSumEffValue("CSP_AB_SPEED_RATE_DOWN")), 0, 0.9999)
	local var_202_1 = arg_202_0.status.speed * (1 - var_202_0)
	local var_202_2 = MAX_UNIT_TICK - arg_202_0.inst.elapsed_ut
	local var_202_3 = var_202_2 / (arg_202_0.status.speed * (1 - var_202_0))
	
	return var_202_2, var_202_3
end

function var_0_0.proc(arg_203_0, arg_203_1)
	if arg_203_0:isDead() then
		Log.e("HIT", "죽은 영웅이 공격을 시도함", arg_203_0.db.name)
		
		return nil
	end
	
	if arg_203_0.skill_inst_vars == nil then
		arg_203_0.skill_inst_vars = {}
		arg_203_0.skill_inst_vars.res_ratio = arg_203_0:getSPRatio()
	end
	
	arg_203_0.skill_inst_vars = arg_203_0.skill_inst_vars or {}
	
	local var_203_0 = {}
	
	arg_203_1.logs = var_203_0
	
	arg_203_0:procSkill(arg_203_1)
	
	if arg_203_0.skill_inst_vars.clear_res then
		arg_203_0:setSPRatio(0)
	end
	
	arg_203_0.skill_inst_vars = nil
	
	return var_203_0
end

function var_0_0.decTurn(arg_204_0)
	arg_204_0.inst.elapsed_ut = 0
	
	Log.d("turn", "턴소비", arg_204_0.db.name, arg_204_0.inst.elapsed_ut)
end

function var_0_0.getSkillAddEffectList(arg_205_0, arg_205_1)
	local var_205_0 = {}
	
	for iter_205_0 = 1, GAME_STATIC_VARIABLE.max_skill_add_eff do
		local var_205_1 = {}
		
		var_205_1.sk_add_con, var_205_1.sk_add_con_target, var_205_1.sk_add_con_value, var_205_1.sk_add_rate, var_205_1.sk_add_resist, var_205_1.sk_add_target, var_205_1.eff, var_205_1.eff_value, var_205_1.eff_turn, var_205_1.sk_add_resist_ignore = arg_205_0:getSkillDB(arg_205_1, {
			"sk_add_con" .. iter_205_0,
			"sk_add_con_target" .. iter_205_0,
			"sk_add_con_value" .. iter_205_0,
			"sk_add_rate" .. iter_205_0,
			"sk_add_resist" .. iter_205_0,
			"sk_add_target" .. iter_205_0,
			"sk_add_eff" .. iter_205_0,
			"sk_eff_value" .. iter_205_0,
			"sk_eff_turn" .. iter_205_0,
			"sk_add_resist_ignore" .. iter_205_0
		})
		
		if var_205_1.eff then
			table.insert(var_205_0, var_205_1)
		end
	end
	
	return var_205_0
end

function var_0_0.prepareSkillAddEffect(arg_206_0, arg_206_1)
	arg_206_0.turn_vars.eff_list = arg_206_0.turn_vars.eff_list or {}
	
	local var_206_0 = arg_206_0:getSkillAddEffectList(arg_206_1)
	
	for iter_206_0, iter_206_1 in pairs(var_206_0) do
		table.insert(arg_206_0.turn_vars.eff_list, iter_206_1)
	end
	
	return arg_206_0.turn_vars.eff_list
end

function var_0_0.procSkill(arg_207_0, arg_207_1)
	if arg_207_1.targets and type(arg_207_1.targets) == "table" then
		arg_207_1.targets = logic_shuffle(arg_207_1.targets, arg_207_1.logic.random:clone())
	end
	
	local var_207_0 = table.shallow_clone(arg_207_1)
	local var_207_1 = {}
	local var_207_2 = arg_207_0:getSkillDB(arg_207_1.skill_id, "deal_damage")
	local var_207_3 = 0
	local var_207_4 = arg_207_1.logic:pickEnemies(arg_207_0)
	
	for iter_207_0, iter_207_1 in pairs(var_207_4) do
		if not iter_207_1:isDead() and iter_207_1.inst.line == FRONT then
			var_207_3 = var_207_3 + 1
		end
	end
	
	arg_207_0.inst.prev_damaged_targets = {}
	
	local var_207_5 = {}
	local var_207_6 = 0
	local var_207_7 = {}
	
	if var_207_2 and var_207_2 ~= "n" then
		table.sort(arg_207_1.targets, function(arg_208_0, arg_208_1)
			local function var_208_0(arg_209_0)
				local var_209_0 = 0
				
				if arg_209_0 and arg_209_0.getDamageShareInfo then
					local var_209_1, var_209_2, var_209_3 = arg_209_0:getDamageShareInfo()
					
					if var_209_1 then
						var_209_0 = var_209_0 + 100
					end
				end
				
				return var_209_0
			end
			
			return var_208_0(arg_208_0) > var_208_0(arg_208_1)
		end)
		
		for iter_207_2, iter_207_3 in ipairs(arg_207_1.targets) do
			local var_207_8
			
			var_207_8 = var_207_3 > 0 and iter_207_3.inst.line == BACK
			var_207_0.target = iter_207_3
			
			local var_207_9 = arg_207_0:dealDamage(var_207_0)
			
			if arg_207_1.cur_hit == arg_207_1.tot_hit then
				if not arg_207_0:isDead() then
					if iter_207_3:isEmptyHP() then
						arg_207_0.turn_vars.global_kill_flag = true
						
						if not iter_207_3.turn_vars.global_kill_first then
							iter_207_3.turn_vars.global_kill_first = arg_207_0:getUID()
						end
						
						table.insert(var_207_5, iter_207_3)
					else
						local var_207_10 = iter_207_3:onAfterAttacked(arg_207_1.skill_id, iter_207_3, arg_207_0)
						
						table.join(var_207_0.logs, var_207_10)
					end
				end
				
				local var_207_11 = iter_207_3:onAfterAttacked_ContainDead(arg_207_1.skill_id, iter_207_3, arg_207_0)
				
				table.join(var_207_0.logs, var_207_11)
			end
			
			if arg_207_1.cur_hit == 1 then
				if var_207_9.critical then
					arg_207_0.turn_vars.global_critical_count = to_n(arg_207_0.turn_vars.global_critical_count) + 1
				end
				
				if var_207_9.miss then
					arg_207_0.turn_vars.global_miss_count = to_n(arg_207_0.turn_vars.global_miss_count) + 1
				end
				
				if not var_207_9.miss then
					arg_207_0.turn_vars.global_hit_flag = true
				end
			end
			
			var_207_1[iter_207_3] = var_207_9
			var_207_6 = var_207_6 + var_207_9.total_damage
		end
		
		if arg_207_1.cur_hit == arg_207_1.tot_hit then
			arg_207_0.inst.prev_damaged_targets = table.shallow_clone(arg_207_1.targets)
		end
	end
	
	if arg_207_1.cur_hit and arg_207_1.tot_hit and arg_207_1.cur_hit == arg_207_1.tot_hit then
		arg_207_1.logic:addSkillHistory(arg_207_0, arg_207_1.skill_id, var_207_6)
	end
	
	arg_207_1.logic:flushUniqueFlag("each")
	
	local var_207_12 = arg_207_1.cur_hit == arg_207_1.tot_hit
	
	if var_207_12 then
		local var_207_13 = arg_207_0:getSkillDB(arg_207_1.skill_id, "soul_gain")
		
		if var_207_13 then
			arg_207_0:addTeamRes("soul_piece", var_207_13)
		end
		
		for iter_207_4, iter_207_5 in pairs(arg_207_0.logic.units) do
			iter_207_5:onToggleVariablePassive()
		end
		
		local var_207_14 = arg_207_0.states:findByEff("CSP_FREE_SOULBURN")
		
		if var_207_14 then
			local var_207_15 = arg_207_0:getSkillDB(arg_207_1.skill_id, "base_skill")
			local var_207_16 = arg_207_0:getSkillDB(var_207_15, "soulburn_skill")
			local var_207_17 = arg_207_0:getSkillDB(arg_207_1.skill_id, "parent_skill")
			local var_207_18 = arg_207_0:getSkillDB(var_207_17, "soulburn_skill")
			
			if var_207_16 == arg_207_1.skill_id or var_207_18 == arg_207_1.skill_id then
				arg_207_0.states:removeByUId(var_207_14.uid, arg_207_1.logs)
			end
		end
		
		if not arg_207_0.states:isExistEffect("CSP_SOULLOCK") and arg_207_0.turn_vars.soul_gain ~= var_207_13 then
			table.insert(var_207_0.logs, {
				type = "gain_soul_by_battle",
				unit = arg_207_0,
				soul_gain = var_207_13
			})
			
			arg_207_0.turn_vars.soul_gain = var_207_13
		end
		
		local var_207_19 = arg_207_0:onAfterSkill(arg_207_1.skill_id, arg_207_1.targets, arg_207_0, var_207_2 and var_207_2 ~= "n", arg_207_1.selected_target)
		
		table.join(var_207_0.logs, var_207_19)
	end
	
	arg_207_1.tot_hit = arg_207_1.tot_hit or 1
	
	local var_207_20 = arg_207_1.cur_hit == arg_207_1.tot_hit
	local var_207_22
	
	if var_207_20 then
		arg_207_0:prepareSkillAddEffect(arg_207_1.skill_id)
		
		local var_207_21 = arg_207_0.turn_vars.eff_list
		
		arg_207_0.turn_vars.eff_list = {}
		var_207_22 = {}
		
		for iter_207_6, iter_207_7 in pairs(var_207_21) do
			arg_207_0:procEffect(arg_207_1, "add", var_207_1, iter_207_6, iter_207_7, var_207_22, var_207_6)
			SkillProc.onAfterAllEffect(arg_207_1.logs, arg_207_0)
		end
	end
	
	if var_207_12 then
		local var_207_23 = arg_207_0:onAfterEffects(arg_207_1.skill_id, arg_207_1.targets, arg_207_0, var_207_2 and var_207_2 ~= "n", arg_207_1.selected_target)
		
		table.join(var_207_0.logs, var_207_23)
	end
	
	if var_207_20 then
		SkillProc.onAfterAllEffect(arg_207_1.logs, arg_207_0)
	end
	
	if var_207_20 and var_207_2 and var_207_2 ~= "n" then
		for iter_207_8, iter_207_9 in ipairs(arg_207_1.targets) do
			if not iter_207_9:isEmptyHP() then
				local var_207_24 = iter_207_9:onSimilarDamageFinished(arg_207_1.skill_id, arg_207_1.targets, arg_207_0, var_207_2 and var_207_2 ~= "n")
				
				table.join(var_207_0.logs, var_207_24)
			end
			
			local var_207_25 = iter_207_9:onSimilarDamageFinished_ContainDead(arg_207_1.skill_id, arg_207_1.targets, arg_207_0, var_207_2 and var_207_2 ~= "n")
			
			table.join(var_207_0.logs, var_207_25)
		end
		
		for iter_207_10, iter_207_11 in ipairs(arg_207_1.targets) do
			if not iter_207_11:isEmptyHP() then
				local var_207_26 = iter_207_11:onDamageFinished(arg_207_1.skill_id, arg_207_1.targets, arg_207_0, var_207_2 and var_207_2 ~= "n")
				
				table.join(var_207_0.logs, var_207_26)
			end
			
			local var_207_27 = iter_207_11:onDamageFinished_ContainDead(arg_207_1.skill_id, arg_207_1.targets, arg_207_0, var_207_2 and var_207_2 ~= "n")
			
			table.join(var_207_0.logs, var_207_27)
		end
		
		for iter_207_12, iter_207_13 in ipairs(arg_207_1.targets) do
			local var_207_28 = iter_207_13:onDamageFinishedAll(arg_207_1.skill_id, iter_207_13, arg_207_0)
			
			table.join(var_207_0.logs, var_207_28)
		end
	end
	
	for iter_207_14, iter_207_15 in pairs(var_207_5) do
		iter_207_15:setFlagDeadDirty(true)
	end
end

function var_0_0.initSkillEffectHistory(arg_210_0)
	arg_210_0.tmp_vars.skill_effect_history = {}
end

function var_0_0.addSkillEffectHistory(arg_211_0, arg_211_1, arg_211_2, arg_211_3)
	if arg_211_0.tmp_vars.skill_effect_history then
		table.insert(arg_211_0.tmp_vars.skill_effect_history, {
			eff_id = arg_211_1,
			rate = arg_211_2,
			active = arg_211_3
		})
	end
end

function var_0_0.getSkillEffectHistory(arg_212_0)
	return arg_212_0.tmp_vars.skill_effect_history
end

function var_0_0.findSkillEffectHistory(arg_213_0, arg_213_1)
	for iter_213_0, iter_213_1 in pairs(arg_213_0.tmp_vars.skill_effect_history) do
		if iter_213_1.eff_id == arg_213_1 then
			return iter_213_1
		end
	end
end

function var_0_0.procEffect(arg_214_0, arg_214_1, arg_214_2, arg_214_3, arg_214_4, arg_214_5, arg_214_6, arg_214_7)
	local var_214_0 = arg_214_3 or {}
	local var_214_1 = arg_214_4 or 0
	local var_214_2 = arg_214_5 or {}
	local var_214_3 = arg_214_6 or {}
	local var_214_4 = arg_214_7 or 0
	local var_214_5 = arg_214_2 or "add"
	local var_214_6
	local var_214_7
	local var_214_8
	local var_214_9
	local var_214_10
	local var_214_11
	local var_214_12
	local var_214_13
	local var_214_14
	local var_214_15
	
	if var_214_5 == "start" then
		arg_214_0:initSkillEffectHistory()
		
		local var_214_16 = {
			"sk_start_con",
			"sk_start_con_target",
			"sk_start_con_value",
			"sk_start_rate",
			"sk_start_resist",
			"sk_start_eff",
			"sk_start_eff_value",
			"sk_start_eff_turn",
			"sk_start_target",
			"sk_start_resist_ignore"
		}
		local var_214_17
		
		var_214_6, var_214_7, var_214_8, var_214_9, var_214_17, var_214_11, var_214_12, var_214_13, var_214_14, var_214_15 = arg_214_0:getSkillDB(arg_214_1.skill_id, var_214_16)
	else
		var_214_6 = var_214_2.sk_add_con
		var_214_7 = var_214_2.sk_add_con_target
		var_214_8 = var_214_2.sk_add_con_value
		
		local var_214_18 = var_214_2.sk_add_resist
		
		var_214_9 = var_214_2.sk_add_rate
		var_214_11 = var_214_2.eff
		var_214_12 = var_214_2.eff_value
		var_214_13 = var_214_2.eff_turn
		var_214_14 = var_214_2.sk_add_target
		var_214_15 = var_214_2.sk_add_resist_ignore
	end
	
	if not var_214_11 then
		return 
	end
	
	arg_214_1.logic:wasteUnitPickerRandom()
	Log.d("skill", "skill eff 들어간다.", "giver: " .. arg_214_0.db.name, "skill_id: " .. arg_214_1.skill_id, var_214_1, "eff_value: " .. tostring(var_214_12))
	
	local var_214_19 = arg_214_0:getEffectTarget(var_214_14, arg_214_1.logic, arg_214_1.targets)
	local var_214_20 = table.shallow_clone(var_214_19)
	
	table.convert(var_214_20, function(arg_215_0, arg_215_1)
		return ("%s[%d]"):format(arg_215_1.db.name, arg_215_1.inst.uid)
	end)
	Log.d("skill", "-- sk_add_target", table.toCommaStr(var_214_20))
	
	local var_214_21 = var_214_6 == "IGNORE_MISS"
	
	for iter_214_0, iter_214_1 in pairs(var_214_19 or {}) do
		local var_214_22 = true
		
		if var_214_9 then
			local var_214_23 = arg_214_1.random:get()
			
			var_214_9 = not PRODUCTION_MODE and var_214_9 > 0 and arg_214_0:getSkillRate() or var_214_9
			
			local var_214_24 = var_214_23 < var_214_9
			
			arg_214_0:addSkillEffectHistory(var_214_11, var_214_9, var_214_24)
			
			if var_214_24 and (var_214_21 or not var_214_0[iter_214_1] or var_214_0[iter_214_1] and var_214_0[iter_214_1].miss ~= true) then
				local var_214_25 = true
				local var_214_26 = iter_214_1:skillDamageTag(arg_214_0) or {}
				
				if var_214_6 and not SkillProc.checkCommonCon(arg_214_0, arg_214_1.skill_id, var_214_6, var_214_7, var_214_8, iter_214_1, arg_214_1.targets, var_214_26.miss, var_214_26.critical, var_214_26.smite, arg_214_0) then
					var_214_25 = false
				end
				
				if var_214_6 == "ADD_EFF_ACTION" then
					var_214_25 = var_214_3[tonumber(string.sub(var_214_8, -1, -1))]
				end
				
				if var_214_25 then
					local var_214_27 = 1
					local var_214_28 = SkillProc.checkResistDB(var_214_11) or var_214_15 == "y"
					
					if arg_214_0.inst.ally ~= iter_214_1.inst.ally and not var_214_28 then
						var_214_27 = 1 + arg_214_0.status.acc - iter_214_1.status.res
						
						local var_214_29 = 0.85
						
						if DEBUG.ABSOLUTE_RESIST_VALUE then
							var_214_29 = math.clamp(1 - DEBUG.ABSOLUTE_RESIST_VALUE, 0, 1)
						end
						
						var_214_27 = math.clamp(var_214_27, 0, var_214_29)
					end
					
					if not (var_214_27 > arg_214_1.random:get()) then
						local var_214_30 = false
						
						if var_214_11 == "BUFF_REMOVE" and iter_214_1.states:getRemovableTypeCount("buff") <= 0 then
							var_214_30 = true
						end
						
						local var_214_31 = CS_Util.isApplyStateOnlyHeroByEff(var_214_11, var_214_12 or 0, iter_214_1)
						
						if not var_214_30 and var_214_31 then
							table.insert(arg_214_1.logs, {
								type = "resist_state",
								target = iter_214_1
							})
							Log.d("skill", "!!저항으로 스킬효과 피함, target:", iter_214_1.db.name, var_214_9, iter_214_1.status.res, var_214_5)
						end
					elseif SkillProc.procEffect(arg_214_1.logs, {
						skill_id = arg_214_1.skill_id,
						random = arg_214_1.random,
						attacker = arg_214_0,
						eff_target = iter_214_1,
						eff = var_214_11,
						pow = var_214_12 or 0,
						cs_eff_turn = var_214_13,
						target_total_damage = var_214_4,
						eff_con_flags = var_214_3,
						eff_idx = var_214_1
					}) then
						var_214_3[var_214_1] = true
						arg_214_0.turn_vars.eff_counts[var_214_1] = to_n(arg_214_0.turn_vars.eff_counts[var_214_1]) + 1
					end
				end
			end
		end
	end
end

function var_0_0.getEffectTarget(arg_216_0, arg_216_1, arg_216_2, arg_216_3)
	local var_216_0
	
	if type(arg_216_1) == "number" then
		if arg_216_1 == 13 then
			var_216_0 = arg_216_2:pickEnemies(arg_216_0)
		elseif arg_216_1 == 3 then
			var_216_0 = arg_216_2:pickUnits(arg_216_0, FRIEND)
		elseif arg_216_1 == 1 then
			var_216_0 = {
				arg_216_0
			}
		elseif arg_216_1 == 15 then
			var_216_0 = arg_216_3
			
			local var_216_1 = true
			
			for iter_216_0, iter_216_1 in pairs(var_216_0) do
				if iter_216_1 == arg_216_0 then
					var_216_1 = false
				end
			end
			
			if var_216_1 then
				table.insert(var_216_0, arg_216_0)
			end
		elseif arg_216_1 == 16 then
			var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, ENEMY, 1, arg_216_3[1])
			
			table.insert(var_216_0, 1, arg_216_3[1])
		elseif arg_216_1 == 17 then
			var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, ENEMY, 2, arg_216_3[1])
			
			table.insert(var_216_0, 1, arg_216_3[1])
		elseif arg_216_1 == 18 then
			var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, 1, arg_216_0)
		elseif arg_216_1 == 19 then
			var_216_0 = arg_216_2:pickUnits(arg_216_0, FRIEND, arg_216_0)
		elseif arg_216_1 == 20 then
			var_216_0 = arg_216_2:pickUnits(arg_216_0, FRIEND, arg_216_3[1])
		elseif arg_216_1 >= 21 and arg_216_1 <= 26 then
			if arg_216_1 == 21 then
				var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, 1)
			elseif arg_216_1 == 22 then
				var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, 2)
			elseif arg_216_1 == 23 then
				var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, 3)
			elseif arg_216_1 == 24 then
				var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, ENEMY, 1)
			elseif arg_216_1 == 25 then
				var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, ENEMY, 2)
			elseif arg_216_1 == 26 then
				var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, ENEMY, 3)
			end
		elseif arg_216_1 == 95 then
			var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, ENEMY, 1)
		elseif arg_216_1 == 27 then
			var_216_0 = table.shallow_clone(arg_216_3)
		elseif arg_216_1 == 32 then
			var_216_0 = arg_216_2:pickDeadUnitsForSummon(arg_216_0, FRIEND, 1, arg_216_0)
		elseif arg_216_1 == 33 then
			var_216_0 = arg_216_2:pickDeadUnitsForSummon(arg_216_0, FRIEND, nil, arg_216_0)
		elseif arg_216_1 == 92 then
			var_216_0 = arg_216_2:pickDeadUnits(arg_216_0, FRIEND, 1, arg_216_0)
		elseif arg_216_1 == 93 then
			var_216_0 = arg_216_2:pickDeadUnits(arg_216_0, FRIEND, nil, arg_216_0)
		elseif arg_216_1 == 94 then
			var_216_0 = arg_216_2:pickRandomDeadUnits(arg_216_0, FRIEND, 1, arg_216_0)
		elseif arg_216_1 == 36 then
			var_216_0 = arg_216_2:pickEnemies(arg_216_0, arg_216_3[1])
		elseif arg_216_1 == 37 then
			local var_216_2 = arg_216_2:getTurnOwner()
			
			if var_216_2 ~= arg_216_0 then
				var_216_0 = {
					var_216_2
				}
			else
				local var_216_3 = arg_216_2:getAttackInfo(var_216_2)
				
				if var_216_3 then
					var_216_0 = {
						var_216_3.d_unit
					}
				end
			end
		elseif arg_216_1 == 38 then
			local var_216_4 = arg_216_2:getTurnOwner()
			
			if var_216_4 ~= arg_216_0 then
				var_216_0 = {
					var_216_4
				}
			else
				local var_216_5 = arg_216_2:getAttackInfo(var_216_4)
				
				if var_216_5 then
					var_216_0 = {
						var_216_5.d_unit
					}
				end
			end
		elseif arg_216_1 == 79 then
			local var_216_6 = {}
			local var_216_7 = arg_216_2:pickUnits(arg_216_0, FRIEND, arg_216_0)
			
			for iter_216_2, iter_216_3 in pairs(var_216_7) do
				if table.empty(var_216_6) then
					table.insert(var_216_6, iter_216_3)
				else
					local var_216_8 = var_216_6[1].status.att
					
					if var_216_8 <= iter_216_3.status.att then
						if var_216_8 < iter_216_3.status.att then
							var_216_6 = {}
						end
						
						table.insert(var_216_6, iter_216_3)
					end
				end
			end
			
			local var_216_9 = arg_216_2.random:get(1, #var_216_6)
			
			var_216_0 = {
				var_216_6[var_216_9]
			}
		elseif arg_216_1 >= 40 and arg_216_1 <= 42 then
			local var_216_10 = arg_216_1 - 39
			
			var_216_0 = arg_216_2:pickUnits(arg_216_0, FRIEND)
			
			while var_216_10 < #var_216_0 do
				local var_216_11 = 0
				local var_216_12
				
				for iter_216_4, iter_216_5 in pairs(var_216_0) do
					local var_216_13 = iter_216_5:getHPRatio()
					
					if var_216_11 < var_216_13 then
						var_216_11 = var_216_13
						var_216_12 = iter_216_4
					end
				end
				
				table.remove(var_216_0, var_216_12)
			end
		elseif arg_216_1 == 2 or arg_216_1 == 4 then
			var_216_0 = arg_216_3
		elseif arg_216_1 == 43 then
			var_216_0 = arg_216_2:pickEnemies(arg_216_0)
			
			local var_216_14 = {}
			
			for iter_216_6, iter_216_7 in pairs(var_216_0) do
				if table.empty(var_216_14) then
					table.insert(var_216_14, iter_216_7)
				else
					local var_216_15 = var_216_14[1]:getHPRatio()
					local var_216_16 = iter_216_7:getHPRatio()
					
					if var_216_15 <= var_216_16 then
						if var_216_15 < var_216_16 then
							var_216_14 = {}
						end
						
						table.insert(var_216_14, iter_216_7)
					end
				end
			end
			
			local var_216_17 = arg_216_2.random:get(1, #var_216_14)
			
			var_216_0 = {
				var_216_14[var_216_17]
			}
		elseif arg_216_1 == 44 then
			var_216_0 = arg_216_2:pickEnemies(arg_216_0)
			
			local var_216_18 = {}
			
			for iter_216_8, iter_216_9 in pairs(var_216_0) do
				if table.empty(var_216_18) then
					table.insert(var_216_18, iter_216_9)
				else
					local var_216_19 = var_216_18[1]:getHPRatio()
					local var_216_20 = iter_216_9:getHPRatio()
					
					if var_216_19 <= var_216_20 then
						if var_216_19 < var_216_20 then
							var_216_18 = {}
						end
						
						table.insert(var_216_18, iter_216_9)
					end
				end
			end
			
			local var_216_21 = arg_216_2.random:get(1, #var_216_18)
			
			var_216_0 = {
				var_216_18[var_216_21]
			}
		elseif arg_216_1 >= 61 and arg_216_1 < 63 then
			var_216_0 = arg_216_2:pickEnemies(arg_216_0)
			
			table.sort(var_216_0, function(arg_217_0, arg_217_1)
				return arg_217_0.inst.elapsed_ut > arg_217_1.inst.elapsed_ut
			end)
			
			for iter_216_10 = arg_216_1 - 60 + 1, #var_216_0 do
				var_216_0[iter_216_10] = nil
			end
		elseif arg_216_1 >= 51 and arg_216_1 < 54 then
			local var_216_22 = arg_216_1 - 50
			
			var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, var_216_22, nil, nil, function(arg_218_0)
				return arg_218_0.states:getTypeCount("debuff") > 0
			end)
		elseif arg_216_1 >= 71 and arg_216_1 <= 78 then
			var_216_0 = arg_216_2:pickUnitsByStatus(arg_216_0, FRIEND, arg_216_1, 1)
		elseif arg_216_1 >= 81 and arg_216_1 <= 88 then
			var_216_0 = arg_216_2:pickUnitsByStatus(arg_216_0, ENEMY, arg_216_1, 1)
		elseif arg_216_1 >= 171 and arg_216_1 <= 178 then
			var_216_0 = arg_216_2:pickUnitsByStatus(arg_216_0, FRIEND, arg_216_1, 1, arg_216_0)
		elseif arg_216_1 == 151 then
			local var_216_23 = arg_216_2:pickUnits(arg_216_0, FRIEND, arg_216_0)
			local var_216_24 = {}
			
			for iter_216_11, iter_216_12 in pairs(var_216_23) do
				if iter_216_12.states:getTypeCount("debuff") > 0 then
					table.insert(var_216_24, iter_216_12)
				end
			end
			
			local var_216_25 = arg_216_2.random:get(1, #var_216_24)
			
			var_216_0 = {
				var_216_24[var_216_25]
			}
		elseif arg_216_1 == 89 then
			local var_216_26 = arg_216_2:pickEnemies(arg_216_0.owner, nil, true)
			
			var_216_0 = {}
			
			for iter_216_13, iter_216_14 in pairs(var_216_26) do
				if iter_216_14 and iter_216_14:isDead() then
					table.insert(var_216_0, iter_216_14)
				end
			end
		elseif arg_216_1 >= 101 and arg_216_1 <= 104 then
			local var_216_27 = arg_216_1 - 100
			local var_216_28 = arg_216_2:pickUnits(arg_216_0, FRIEND)
			
			for iter_216_15, iter_216_16 in pairs(var_216_28) do
				if not iter_216_16:isDead() and to_n(iter_216_16.inst.pos) == var_216_27 then
					var_216_0 = {
						iter_216_16
					}
					
					break
				end
			end
			
			var_216_0 = var_216_0 or {}
		elseif arg_216_1 == 105 then
			var_216_0 = {}
			
			local var_216_29 = arg_216_2:pickUnits(arg_216_0, FRIEND)
			
			for iter_216_17, iter_216_18 in pairs(var_216_29) do
				if not iter_216_18:isEmptyHP() then
					table.insert(var_216_0, iter_216_18)
				end
			end
		elseif arg_216_1 == 114 then
			var_216_0 = arg_216_2:pickUnits(arg_216_0, FRIEND)
			
			for iter_216_19 = #var_216_0, 1, -1 do
				if var_216_0[iter_216_19] ~= arg_216_0 and to_n(var_216_0[iter_216_19].inst.pos) ~= 4 then
					table.remove(var_216_0, iter_216_19)
				end
			end
		else
			var_216_0 = arg_216_3
		end
	elseif arg_216_1 == "ALLY_AB_HIGHEST" then
		local var_216_30 = {}
		local var_216_31 = arg_216_2:pickUnits(arg_216_0, FRIEND, arg_216_0)
		
		for iter_216_20, iter_216_21 in pairs(var_216_31) do
			if table.empty(var_216_30) then
				table.insert(var_216_30, iter_216_21)
			else
				local var_216_32 = var_216_30[1].inst.elapsed_ut
				
				if var_216_32 <= iter_216_21.inst.elapsed_ut then
					if var_216_32 < iter_216_21.inst.elapsed_ut then
						var_216_30 = {}
					end
					
					table.insert(var_216_30, iter_216_21)
				end
			end
		end
		
		local var_216_33 = arg_216_2.random:get(1, #var_216_30)
		
		var_216_0 = {
			var_216_30[var_216_33]
		}
	elseif arg_216_1 == "ENEMY_ALL_LESS_ATT" then
		var_216_0 = arg_216_2:pickEnemies(arg_216_0)
		
		for iter_216_22 = #var_216_0, 1, -1 do
			if arg_216_0.status.att <= var_216_0[iter_216_22].status.att then
				table.remove(var_216_0, iter_216_22)
			end
		end
	elseif arg_216_1 == "ENEMY_ALL_LESS_ATT_NOT" then
		var_216_0 = arg_216_2:pickEnemies(arg_216_0)
		
		for iter_216_23 = #var_216_0, 1, -1 do
			if arg_216_0.status.att > var_216_0[iter_216_23].status.att then
				table.remove(var_216_0, iter_216_23)
			end
		end
	elseif arg_216_1 == "ALLY_RANDOM_2_WITHOUT_SELF" then
		var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, 2, arg_216_0)
	elseif arg_216_1 == "ALLY_RANDOM_3_WITHOUT_SELF" then
		var_216_0 = arg_216_2:pickRandomUnits(arg_216_0, FRIEND, 3, arg_216_0)
	else
		var_216_0 = arg_216_3
	end
	
	for iter_216_24 = #var_216_0, 1, -1 do
		if not var_216_0[iter_216_24]:isSkillEffectTargetable() then
			table.remove(var_216_0, iter_216_24)
		end
	end
	
	return var_216_0
end

function var_0_0.getTotalSkillLevel(arg_219_0)
	if type(arg_219_0.inst.skill_lv) ~= "table" then
		return 0
	end
	
	local var_219_0 = 0
	
	for iter_219_0, iter_219_1 in pairs(arg_219_0.inst.skill_lv) do
		var_219_0 = var_219_0 + iter_219_1
	end
	
	return var_219_0
end

function var_0_0.getSkillLevel(arg_220_0, arg_220_1)
	local var_220_0 = arg_220_0.inst.add_skill[arg_220_1]
	
	if var_220_0 then
		return var_220_0
	end
	
	arg_220_1 = SkillFactory.create(arg_220_1, arg_220_0):getSkillIdForSkillLevel()
	
	local var_220_1 = arg_220_0:getSkillIndex(arg_220_1)
	local var_220_2 = tonumber(DB("skill", arg_220_1, "sklvup_refer") or nil)
	
	if var_220_2 then
		var_220_1 = var_220_2
	end
	
	if type(arg_220_0.inst.skill_lv) == "table" then
		return arg_220_0.inst.skill_lv[var_220_1] or 0
	else
		return 0
	end
end

function var_0_0.getSkillReqPoint(arg_221_0, arg_221_1)
	if DEBUG.DEBUG_SKILL then
		return 0
	end
	
	return arg_221_0:getSkillDB(arg_221_1, "point_require")
end

function var_0_0.getSkillAttRate(arg_222_0, arg_222_1)
	return arg_222_0:getSkillDB(arg_222_1, "att_rate") or 1
end

function var_0_0.getSkillDefPenRate(arg_223_0, arg_223_1)
	return arg_223_0:getSkillDB(arg_223_1, "def_pen") or 0
end

function var_0_0.getSkillPow(arg_224_0, arg_224_1)
	local var_224_0, var_224_1 = arg_224_0:getSkillDB(arg_224_1, {
		"pow",
		"pow_growth"
	})
	
	var_224_0 = var_224_0 or 1
	
	return var_224_0 + arg_224_0:getSkillLevel(arg_224_1) * (var_224_1 or 0)
end

function var_0_0.getSkillBeforePow(arg_225_0, arg_225_1)
	local var_225_0, var_225_1 = arg_225_0:getSkillDB(arg_225_1, {
		"pow",
		"pow_growth"
	})
	
	var_225_0 = var_225_0 or 1
	
	return var_225_0 + arg_225_0:getSkillLevel(arg_225_1) * var_225_1
end

function var_0_0.getHealUpRate(arg_226_0)
	local var_226_0, var_226_1 = arg_226_0.states:findBestOneByEff("CSP_HEAL_INC")
	
	return var_226_1
end

function var_0_0.getHealDownRate(arg_227_0)
	local var_227_0, var_227_1 = arg_227_0.states:findBestOneByEff("CSP_HEAL_DEC")
	
	return var_227_1
end

function var_0_0.getHealRate(arg_228_0)
	return 1 + (arg_228_0:getHealUpRate() - arg_228_0:getHealDownRate())
end

function var_0_0.heal(arg_229_0, arg_229_1, arg_229_2, arg_229_3)
	if not arg_229_2 and arg_229_0.states:isExistEffect("CSP_NOHEAL") then
		return 0
	end
	
	if not arg_229_3 and not arg_229_2 and arg_229_0:isEmptyHP() then
		return 0
	end
	
	local var_229_0 = arg_229_0:getHealRate()
	
	if arg_229_2 then
		var_229_0 = 1
	end
	
	arg_229_1 = math.floor(arg_229_1 * math.min(2, math.max(0, var_229_0)))
	arg_229_1 = math.min(arg_229_1, arg_229_0:getMaxHP() - arg_229_0.inst.hp)
	arg_229_0.inst.hp = arg_229_0.inst.hp + arg_229_1
	
	return arg_229_1
end

function var_0_0.perHeal(arg_230_0, arg_230_1, arg_230_2, arg_230_3)
	local var_230_0 = math.floor(arg_230_0:getMaxHP() * arg_230_1)
	
	return arg_230_0:heal(var_230_0, arg_230_2, arg_230_3), var_230_0
end

function var_0_0.onEndTurn(arg_231_0)
	arg_231_0.inst.proc_cnt = arg_231_0.inst.proc_cnt + 1
	
	local var_231_0 = {}
	local var_231_1 = arg_231_0.logic:getTurnOwner()
	local var_231_2 = {}
	local var_231_3 = {}
	
	for iter_231_0, iter_231_1 in pairs(arg_231_0.logic.units) do
		if iter_231_1 and iter_231_1.getDamageShareInfo then
			local var_231_4, var_231_5, var_231_6 = iter_231_1:getDamageShareInfo()
			
			if var_231_4 then
				var_231_3[var_231_4:getUID()] = var_231_3[var_231_4:getUID()] or 0
				var_231_3[var_231_4:getUID()] = var_231_3[var_231_4:getUID()] + 100
			end
		end
		
		var_231_3[iter_231_1:getUID()] = var_231_3[iter_231_1:getUID()] or 0
		var_231_3[iter_231_1:getUID()] = var_231_3[iter_231_1:getUID()] + to_n(iter_231_1.inst.pos)
		
		table.insert(var_231_2, iter_231_1)
	end
	
	table.sort(var_231_2, function(arg_232_0, arg_232_1)
		return to_n(var_231_3[arg_232_0:getUID()]) > to_n(var_231_3[arg_232_1:getUID()])
	end)
	
	for iter_231_2, iter_231_3 in pairs(var_231_2) do
		if not iter_231_3:isDead() then
			local var_231_7 = iter_231_3.states:onEndTurn(arg_231_0, var_231_1)
			
			table.join(var_231_0, var_231_7)
		end
	end
	
	local function var_231_8(arg_233_0)
		if not arg_231_0:getSkillCoolData()[arg_233_0] then
			return false
		end
		
		local var_233_0, var_233_1, var_233_2 = arg_231_0:getSkillDB(arg_233_0, {
			"sk_add_con1",
			"sk_add_target1",
			"sk_eff_value1"
		})
		
		if var_233_0 == 1 and var_233_1 == 1 and var_233_2 then
			local var_233_3, var_233_4, var_233_5, var_233_6, var_233_7, var_233_8, var_233_9 = arg_231_0:getCSDB(tostring(var_233_2), {
				"cs_type",
				"cs_eff1",
				"cs_eff2",
				"cs_eff3",
				"cs_eff4",
				"cs_eff5",
				"cs_eff6"
			}, {
				skill_id = arg_233_0
			})
			
			if (var_233_4 == "CSP_CONCENTRATION" or var_233_5 == "CSP_CONCENTRATION" or var_233_6 == "CSP_CONCENTRATION" or var_233_7 == "CSP_CONCENTRATION" or var_233_8 == "CSP_CONCENTRATION" or var_233_9 == "CSP_CONCENTRATION") and arg_231_0:checkState(var_233_2) then
				Log.d("skill_cool", "해당스킬이 사용시 자신에게 버프를 걸고 그 버프가 정신집중( P_CONCENTRATION ) 이라면, 캔슬되거나 버프가 종료되어야만 쿨타임이 계산되어야 한다.")
				
				return false
			end
		end
		
		return true
	end
	
	if not arg_231_0:isTransformed() or not arg_231_0.transform_vars.skills then
		local var_231_9 = arg_231_0.db.skills
	end
	
	for iter_231_4, iter_231_5 in pairs(arg_231_0.db.skills) do
		if arg_231_0:getSkillCoolData()[iter_231_5] then
			local var_231_10 = arg_231_0:getSkillCoolData()[iter_231_5]
			local var_231_11 = var_231_10
			
			if var_231_8(iter_231_5) then
				var_231_11 = math.max(0, var_231_10 - 1)
				arg_231_0:getSkillCoolData()[iter_231_5] = var_231_11
			end
			
			Log.d("skill_cool", "스킬턴 감소", arg_231_0.db.name, iter_231_4, iter_231_5, var_231_10 .. "->" .. var_231_11)
		end
	end
	
	if arg_231_0.occurrenceAfterDecTurn then
		for iter_231_6, iter_231_7 in pairs(arg_231_0.occurrenceAfterDecTurn) do
			iter_231_7(var_231_0)
		end
		
		arg_231_0.occurrenceAfterDecTurn = {}
	end
	
	table.add(var_231_0, arg_231_0.states:procTurn(arg_231_0.turn_vars.no_turn_cs, false))
	
	arg_231_0.inst.use_skill = nil
	arg_231_0.inst.use_equip_skill = nil
	
	return var_231_0
end

function var_0_0.onTurnEndAfter(arg_234_0)
	arg_234_0.inst.proc_cnt = arg_234_0.inst.proc_cnt + 1
	
	local var_234_0 = {}
	local var_234_1 = arg_234_0.logic:getTurnOwner()
	
	for iter_234_0, iter_234_1 in pairs(arg_234_0.logic.units) do
		if not iter_234_1:isDead() then
			local var_234_2 = iter_234_1.states:onTurnEndAfter(arg_234_0, var_234_1)
			
			table.join(var_234_0, var_234_2)
		end
	end
	
	return var_234_0
end

function var_0_0.setIgnoreHitAction(arg_235_0, arg_235_1)
	arg_235_0.inst.ignore_hit_action = arg_235_1
end

function var_0_0.isIgnoreHitAction(arg_236_0)
	return arg_236_0.inst.ignore_hit_action
end

function var_0_0.isUsingSkill(arg_237_0)
	return arg_237_0.inst.use_skill ~= nil
end

function var_0_0.isUsingEquipSkill(arg_238_0)
	return arg_238_0.inst.use_equip_skill ~= nil
end

function var_0_0.occurAfterDecTurn(arg_239_0, arg_239_1)
	arg_239_0.occurrenceAfterDecTurn = arg_239_0.occurrenceAfterDecTurn or {}
	
	table.push(arg_239_0.occurrenceAfterDecTurn, arg_239_1)
end

function var_0_0.isSkillSilence(arg_240_0)
	return arg_240_0.states:isExistEffect("CSP_SILENCE")
end

function var_0_0.isStunned(arg_241_0)
	return arg_241_0:checkStateAttribute(1)
end

function var_0_0.isExistStealthEffect(arg_242_0)
	return arg_242_0.states:isExistEffect("CSP_STEALTH") or arg_242_0.states:isExistEffect("CSP_STEALTH_STILL")
end

function var_0_0.isValidTarget(arg_243_0, arg_243_1, arg_243_2)
	if not arg_243_0.logic then
		return 
	end
	
	if not arg_243_1 then
		local var_243_0 = arg_243_0.logic:getAttackOrder()
		
		if not var_243_0 or not var_243_0.attacker then
			return 
		end
		
		arg_243_1 = var_243_0.attacker
	end
	
	if arg_243_0.states:isExistEffect("CSP_CANTTARGET") or arg_243_0:isExistStealthEffect() and arg_243_1.inst.ally ~= arg_243_0.inst.ally and not arg_243_2 then
		return false
	end
	
	return true
end

function var_0_0.isSkillEffectTargetable(arg_244_0)
	return not arg_244_0.states:isExistEffect("CSP_CANTTARGET")
end

function var_0_0.isConcentration(arg_245_0)
	return arg_245_0.states:isExistEffect("CSP_CONCENTRATION")
end

function var_0_0.checkState(arg_246_0, arg_246_1)
	return arg_246_0.states:isExistById(arg_246_1)
end

function var_0_0.checkStateGroup(arg_247_0, arg_247_1)
	return arg_247_0.states:isExistByGroupId(arg_247_1)
end

function var_0_0.checkStateEffect(arg_248_0, arg_248_1)
	return arg_248_0.states:isExistEffect(arg_248_1)
end

function var_0_0.checkStateAttribute(arg_249_0, arg_249_1, arg_249_2)
	return arg_249_0.states:isExistAttribute(arg_249_1, arg_249_2)
end

function var_0_0.getInvokeStackCount(arg_250_0, arg_250_1)
	return arg_250_0.states:getInvokeStackCount(arg_250_1)
end

function var_0_0.setInvokeStackCount(arg_251_0, arg_251_1, arg_251_2)
	return arg_251_0.states:setInvokeStackCount(arg_251_1, arg_251_2)
end

function var_0_0.resetInvokeStackCountWave(arg_252_0)
	arg_252_0.states:resetInvokeStackCountWave()
end

function var_0_0.getName(arg_253_0)
	local var_253_0 = T(arg_253_0.db.name)
	
	if arg_253_0.inst.prefix_name then
		var_253_0 = T("desc_name", {
			desc = arg_253_0.inst.prefix_name,
			name = var_253_0
		})
	end
	
	return var_253_0
end

function var_0_0.getSPName(arg_254_0)
	if arg_254_0.states:isExistEffect("CSP_GAUGE_WEAK") then
		return "week_gauge"
	elseif arg_254_0.states:isExistEffect("CSP_GAUGE_BERSERK") then
		return "berserk_gauge"
	end
	
	return arg_254_0.db.resource or ""
end

function var_0_0.getShieldDecreaseRate(arg_255_0)
	return arg_255_0.states:getShieldDecreaseRate()
end

function var_0_0.getShieldRatio(arg_256_0, arg_256_1)
	local var_256_0 = arg_256_0.states:getShield() / arg_256_0.states:getMaxShield()
	
	if arg_256_1 then
		var_256_0 = math.floor(var_256_0 * 1000)
		
		while var_256_0 / 1000 * arg_256_0:getMaxHP() < arg_256_0.inst.hp do
			var_256_0 = var_256_0 + 1
		end
	end
	
	return var_256_0
end

function var_0_0.getHPRatio(arg_257_0, arg_257_1)
	local var_257_0 = arg_257_0.inst.hp / arg_257_0:getMaxHP()
	
	if arg_257_1 then
		var_257_0 = math.floor(var_257_0 * 1000)
		
		while var_257_0 / 1000 * arg_257_0:getMaxHP() < arg_257_0.inst.hp do
			var_257_0 = var_257_0 + 1
		end
	end
	
	return var_257_0
end

function var_0_0.getHPShieldRatio(arg_258_0, arg_258_1)
	local var_258_0 = arg_258_0.inst.hp + arg_258_0.states:getShield()
	local var_258_1 = arg_258_0:getMaxHP() + arg_258_0.states:getMaxShield()
	local var_258_2 = var_258_0 / var_258_1
	
	if arg_258_1 then
		var_258_2 = math.floor(var_258_2 * 1000)
		
		while var_258_0 > var_258_2 / 1000 * var_258_1 do
			var_258_2 = var_258_2 + 1
		end
	end
	
	return var_258_2
end

function var_0_0.resetAutomatonHPRatio(arg_259_0)
	arg_259_0.inst.automaton_hp_r = 1000
end

function var_0_0.setAutomatonHPRatio(arg_260_0, arg_260_1)
	arg_260_0.inst.automaton_hp_r = arg_260_1
end

function var_0_0.getAutomatonHPRatio(arg_261_0)
	return arg_261_0.inst.automaton_hp_r or 1000
end

function var_0_0.getHP(arg_262_0)
	return arg_262_0.inst.hp
end

function var_0_0.getExpString(arg_263_0, arg_263_1)
	arg_263_1 = arg_263_1 or 0
	
	if arg_263_0:isMaxLevel() then
		return "Max", 1
	end
	
	local var_263_0 = math.max(0, arg_263_0:getRestExp() - arg_263_1)
	local var_263_1 = arg_263_0:getNeedExp()
	local var_263_2 = (var_263_1 - var_263_0) / var_263_1
	local var_263_3 = math.max(0, var_263_1 - arg_263_0:getRestExp() + arg_263_1)
	
	return comma_value(var_263_3) .. "/" .. comma_value(var_263_1), var_263_2
end

function var_0_0.getEXP(arg_264_0)
	return arg_264_0.inst.exp
end

function var_0_0.getLv(arg_265_0)
	return arg_265_0.inst.lv
end

function var_0_0.getFav(arg_266_0)
	return arg_266_0.inst.fav or 0
end

function var_0_0.getFavLevel(arg_267_0, arg_267_1)
	local var_267_0 = arg_267_1 or arg_267_0:getFav()
	local var_267_1 = 1
	local var_267_2 = 0
	local var_267_3
	
	for iter_267_0 = 1, 99 do
		local var_267_4 = DB("character_intimacy", tostring(iter_267_0), "exp")
		
		if not var_267_4 then
			break
		end
		
		var_267_1 = iter_267_0
		
		if var_267_0 < var_267_4 then
			var_267_3 = var_267_4
			
			break
		else
			var_267_2 = var_267_4
		end
	end
	
	local var_267_5 = math.max(1, (var_267_3 or var_267_2) - var_267_2)
	local var_267_6 = not var_267_3 and 1 or math.min(1, math.max(0, (var_267_0 - var_267_2) / var_267_5))
	
	return var_267_1, var_267_6
end

function var_0_0.canUseIntimacy(arg_268_0)
	if not arg_268_0.db or not arg_268_0.inst then
		return false
	end
	
	if DB("character_reference", arg_268_0.inst.code, "detail_block") or false then
		return false
	end
	
	local var_268_0 = DB("character", arg_268_0.inst.code, "grade") or 3
	
	if arg_268_0.db.role == "material" or var_268_0 <= 2 then
		return false
	end
	
	return true
end

function var_0_0.getMinDevoteGrade(arg_269_0)
	local var_269_0 = DB("character", arg_269_0.inst.code, "grade") or 3
	
	return math.max(3, var_269_0) - 3
end

function var_0_0.isHaveDevote(arg_270_0)
	if arg_270_0:isSpecialUnit() or arg_270_0:isPromotionUnit() or not arg_270_0.db.variation_group or arg_270_0.db.role == "material" then
		return false
	end
	
	local var_270_0, var_270_1 = DB("character", arg_270_0.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	
	return var_270_0 and var_270_1 and true or false
end

function var_0_0.getDevote(arg_271_0)
	return arg_271_0.inst.devote or 0
end

function var_0_0.getDevoteGrade(arg_272_0, arg_272_1)
	local var_272_0 = DB("character", arg_272_0.inst.code, "grade") or 3
	local var_272_1 = math.max(3, var_272_0) - 2
	local var_272_2 = arg_272_1 or arg_272_0:getDevote()
	local var_272_3 = math.min(7, var_272_2 + (var_272_1 - 1))
	
	return DB("devotion_skill_grade", tostring(var_272_3), "grade"), var_272_3, var_272_1
end

function var_0_0.getPresentDevote(arg_273_0)
	local var_273_0, var_273_1, var_273_2 = arg_273_0:getDevoteGrade()
	
	return var_273_2 - 1 == var_273_1 and 0 or var_273_1
end

function var_0_0.getClampedDevote(arg_274_0, arg_274_1)
	local var_274_0 = DB("character", arg_274_0.inst.code, "grade") or 3
	local var_274_1 = 0
	local var_274_2 = arg_274_1 or arg_274_0:getDevote()
	
	if var_274_0 > 2 then
		var_274_1 = 10 - var_274_0
	end
	
	return math.min(var_274_1, var_274_2)
end

function var_0_0.getDevoteColor(arg_275_0, arg_275_1)
	if not arg_275_1 then
		return cc.c3b(0, 0, 0)
	end
	
	local var_275_0 = {
		z = cc.c3b(130, 130, 130),
		d = cc.c3b(169, 169, 169),
		c = cc.c3b(122, 179, 37),
		b = cc.c3b(66, 164, 255),
		a = cc.c3b(186, 105, 247),
		s = cc.c3b(255, 40, 35)
	}
	
	return var_275_0[string.lower(arg_275_1)] or var_275_0.s
end

function var_0_0.isPromotionEffectSimple(arg_276_0)
	return DB("character", arg_276_0.db.code, "promotion_effect_simplify") == "y"
end

function var_0_0.getDevoteSkill(arg_277_0, arg_277_1)
	arg_277_1 = arg_277_1 or {}
	
	local var_277_0, var_277_1, var_277_2 = DB("character", arg_277_0.db.code, {
		"devotion_skill",
		"devotion_skill_slot",
		"devotion_skill_self"
	})
	
	if not var_277_0 or not var_277_1 then
		return 
	end
	
	local var_277_3 = false
	local var_277_4 = var_277_0
	
	if not arg_277_0:isSupporter() and arg_277_0:getUnitOptionValue("imprint_focus") == 2 then
		var_277_3 = true
		var_277_4 = var_277_2
	end
	
	if arg_277_1.self_effect == true then
		var_277_3 = true
		var_277_4 = var_277_2
	elseif arg_277_1.self_effect == false then
		var_277_3 = false
		var_277_4 = var_277_0
	end
	
	if not var_277_4 then
		return 
	end
	
	local var_277_5, var_277_6 = DB("devotion_skill", var_277_4, {
		"type",
		"effect"
	})
	local var_277_7 = arg_277_0:getFavLevel()
	local var_277_8 = DB("character_intimacy", tostring(var_277_7), "devotion_skill_base")
	local var_277_9, var_277_10, var_277_11 = arg_277_0:getDevoteGrade(arg_277_1.devote)
	local var_277_12 = DB("devotion_skill_grade", tostring(var_277_10), "weight_" .. var_277_11)
	local var_277_13 = (var_277_6 or 0) * (1 + var_277_8) * var_277_12
	
	return var_277_5, var_277_13, var_277_3
end

function var_0_0.getEnhancePrice(arg_278_0)
	return (3 + arg_278_0:getBaseGrade()) * (GAME_STATIC_VARIABLE.unit_enhance_price or 150)
end

function var_0_0.getEnhanceExp(arg_279_0, arg_279_1)
	local var_279_0 = DB("character", arg_279_0.inst.code, "exp")
	local var_279_1 = 1
	local var_279_2 = GAME_STATIC_VARIABLE[string.format("bonus_exp_%s", arg_279_1.db.code)]
	
	if arg_279_1.db.color == arg_279_0.db.color and not arg_279_0:isRecallExpUnit() then
		var_279_1 = 1.5
	end
	
	if var_279_2 then
		var_279_1 = var_279_1 + var_279_2
	end
	
	if var_279_0 then
		return math.floor(var_279_0 * var_279_1), var_279_1
	end
	
	return math.floor(var_279_1 * (arg_279_0:getBaseGrade() * 50 * (arg_279_0:getBaseGrade() / 5 + 2) + 10 * math.pow(arg_279_0:getLv(), 2))), var_279_1
end

function var_0_0.getEXPRatio(arg_280_0)
	if arg_280_0:isMaxLevel() then
		return 1
	end
	
	local var_280_0 = math.max(0, arg_280_0:getRestExp())
	local var_280_1 = arg_280_0:getNeedExp()
	
	return (var_280_1 - var_280_0) / var_280_1
end

function var_0_0.setPos(arg_281_0, arg_281_1, arg_281_2)
	arg_281_0.inst.pos = arg_281_1
	
	if not arg_281_2 then
		arg_281_0.inst.line = arg_281_0.inst.pos == 1 and FRONT or BACK
	end
end

function var_0_0.getSP(arg_282_0)
	if arg_282_0:getSPName() == "none" then
		return 0
	end
	
	return arg_282_0.inst[arg_282_0:getSPName()]
end

function var_0_0.getMaxSP(arg_283_0, arg_283_1)
	arg_283_1 = arg_283_1 or arg_283_0:getSPName()
	
	if arg_283_1 == "bp" then
		return GAME_STATIC_VARIABLE.fighting_max
	end
	
	if arg_283_1 == "rp" then
		return GAME_STATIC_VARIABLE.fighting_max
	end
	
	if arg_283_1 == "cp" then
		return GAME_STATIC_VARIABLE.concentration_max
	end
	
	if arg_283_1 == "week_gauge" or arg_283_1 == "berserk_gauge" then
		return 100
	end
	
	if arg_283_1 == "none" then
		return 1
	end
	
	return GAME_STATIC_VARIABLE.mana_max
end

function var_0_0.setSPRatio(arg_284_0, arg_284_1, arg_284_2)
	arg_284_2 = arg_284_2 or arg_284_0:getSPName()
	
	if arg_284_2 == "none" then
		return 
	end
	
	local var_284_0 = arg_284_0:getMaxSP(arg_284_2)
	
	arg_284_0.inst[arg_284_2] = math.floor(math.max(0, math.min(var_284_0, arg_284_1 * var_284_0)))
end

function var_0_0.addSPRatio(arg_285_0, arg_285_1, arg_285_2)
	arg_285_2 = arg_285_2 or arg_285_0:getSPName()
	
	if arg_285_2 == "none" then
		return 
	end
	
	local var_285_0 = arg_285_0:getMaxSP(arg_285_2)
	local var_285_1 = arg_285_1 * arg_285_0:getResourceRateValue()
	
	arg_285_0.inst[arg_285_2] = math.floor(math.max(0, math.min(var_285_0, arg_285_0.inst[arg_285_2] + var_285_1 * var_285_0)))
end

function var_0_0.getSPRatio(arg_286_0, arg_286_1)
	arg_286_1 = arg_286_1 or arg_286_0:getSPName()
	
	if arg_286_1 == "none" then
		return 0
	end
	
	return (arg_286_0.inst[arg_286_1] or 0) / arg_286_0:getMaxSP(arg_286_1)
end

function var_0_0.getMP(arg_287_0, arg_287_1)
	if arg_287_0:getSPName() ~= "mp" then
		return arg_287_1
	end
	
	return arg_287_0.inst.mp or 0
end

function var_0_0.getMPRatio(arg_288_0, arg_288_1)
	if arg_288_0:getSPName() ~= "mp" then
		return arg_288_1
	end
	
	return (arg_288_0.inst.mp or 0) / arg_288_0:getMaxSP("mp")
end

function var_0_0.getSkillSequencer(arg_289_0)
	return arg_289_0.skill_sequencer
end

function var_0_0.onStartStage(arg_290_0, arg_290_1)
	return (arg_290_0.states:onStartStage(arg_290_0, arg_290_1))
end

function var_0_0.onSkillBundleInit(arg_291_0)
	arg_291_0.skill_bundle:initTurn()
	
	if arg_291_0:isTransformed() then
		arg_291_0.transform_vars.skill_bundle:initTurn()
	end
end

function var_0_0.onStartTurn(arg_292_0)
	arg_292_0:addBattleTurnCount()
	
	if arg_292_0.turn_vars.cur_attack_cnt == nil then
		arg_292_0.turn_vars.cur_attack_cnt = 1
	else
		arg_292_0.turn_vars.cur_attack_cnt = arg_292_0.turn_vars.cur_attack_cnt + 1
	end
	
	local var_292_0
	
	if arg_292_0:getSPName() == "mp" then
		var_292_0 = arg_292_0.inst.mp
		arg_292_0.inst.mp = math.min(GAME_STATIC_VARIABLE.mana_max, arg_292_0.inst.mp + GAME_STATIC_VARIABLE.mana_rate)
		var_292_0 = arg_292_0.inst.mp - var_292_0
	end
	
	arg_292_0:onSkillBundleInit()
	
	local var_292_1 = {}
	
	if arg_292_0.turn_vars.cur_attack_cnt == 1 then
		for iter_292_0, iter_292_1 in pairs(arg_292_0.logic.units) do
			if not iter_292_1:isDead() then
				local var_292_2 = iter_292_1.states:onStartTurn(arg_292_0, "before")
				
				table.join(var_292_1, var_292_2)
			end
		end
		
		for iter_292_2, iter_292_3 in pairs(arg_292_0.logic.units) do
			if not iter_292_3:isDead() then
				local var_292_3 = iter_292_3.states:onStartTurn(arg_292_0, "default")
				
				table.join(var_292_1, var_292_3)
			end
		end
		
		for iter_292_4, iter_292_5 in pairs(arg_292_0.logic.units) do
			if not iter_292_5:isDead() then
				local var_292_4 = iter_292_5.states:onStartTurn(arg_292_0, "after")
				
				table.join(var_292_1, var_292_4)
			end
		end
		
		arg_292_0.states:startTurn(var_292_1)
		table.add(var_292_1, arg_292_0.states:procTurn(arg_292_0.turn_vars.no_turn_cs, true))
		arg_292_0:decTurn()
	end
	
	if var_292_0 and var_292_0 > 0 then
		table.insert(var_292_1, {
			no_effect = true,
			type = "sp_heal",
			from = arg_292_0,
			target = arg_292_0,
			sp_heal = var_292_0
		})
	end
	
	return var_292_1
end

function var_0_0.getProvoker(arg_293_0)
	if not arg_293_0.logic then
		return 
	end
	
	local var_293_0 = arg_293_0.states:findByEff("CSP_TAUNT")
	
	if var_293_0 and var_293_0.giver and not var_293_0.giver:isDead() then
		local var_293_1 = arg_293_0.logic:pickEnemies(arg_293_0)
		
		for iter_293_0, iter_293_1 in pairs(var_293_1) do
			if not iter_293_1:isDead() and var_293_0.giver == iter_293_1 then
				return iter_293_1
			end
		end
	elseif arg_293_0.states:findByEff("CSP_TAUNT_MAXHP") then
		local var_293_2 = arg_293_0.logic:pickEnemies(arg_293_0)
		local var_293_3
		local var_293_4
		
		for iter_293_2, iter_293_3 in pairs(var_293_2) do
			if not iter_293_3:isDead() then
				local var_293_5 = iter_293_3:getMaxHP()
				
				if not var_293_3 or var_293_3 < var_293_5 then
					var_293_3 = var_293_5
					var_293_4 = iter_293_3
				end
			end
		end
		
		if var_293_4 then
			return var_293_4
		end
	end
end

function var_0_0.getAutoSkillFlag(arg_294_0)
	return not arg_294_0.inst.disable_auto
end

function var_0_0.setAutoSkillFlag(arg_295_0, arg_295_1)
	arg_295_0.inst.disable_auto = not arg_295_1
end

function var_0_0.getGrowthBoostPoint(arg_296_0)
	local var_296_0 = arg_296_0:clone()
	
	GrowthBoost:apply(var_296_0)
	
	return var_296_0:getPoint()
end

function var_0_0.getGrowthBoostLv(arg_297_0)
	local var_297_0 = arg_297_0:clone()
	
	GrowthBoost:apply(var_297_0)
	
	return var_297_0:getLv()
end

function var_0_0.getGrowthBoostLvAndMaxLv(arg_298_0)
	local var_298_0 = arg_298_0:clone()
	
	GrowthBoost:apply(var_298_0)
	
	return var_298_0:getLv(), var_298_0:getMaxLevel()
end

function var_0_0.getGrowthBoostGrade(arg_299_0)
	local var_299_0 = arg_299_0:clone()
	
	GrowthBoost:apply(var_299_0)
	
	return var_299_0:getGrade()
end

function var_0_0.getGrowthBoostZodiac(arg_300_0)
	local var_300_0 = arg_300_0:clone()
	
	GrowthBoost:apply(var_300_0)
	
	return var_300_0:getZodiacGrade()
end

function var_0_0.getGrowthBoostTotalSkillLv(arg_301_0)
	local var_301_0 = arg_301_0:clone()
	
	GrowthBoost:apply(var_301_0)
	
	return var_301_0:getTotalSkillLevel()
end

function var_0_0.getGrowthBoostStatus(arg_302_0)
	local var_302_0 = arg_302_0:clone()
	
	GrowthBoost:apply(var_302_0)
	
	return var_302_0:getStatus()
end

function var_0_0.getPoint(arg_303_0, arg_303_1)
	if arg_303_1 == nil then
		arg_303_1 = arg_303_0.status
	end
	
	local var_303_0 = 0
	local var_303_1 = 0
	local var_303_2 = 0
	local var_303_3 = 0
	
	for iter_303_0 = 1, 3 do
		local var_303_4 = arg_303_0:getSkillByIndex(iter_303_0)
		local var_303_5 = arg_303_0:getSkillLevelByIndex(iter_303_0)
		local var_303_6 = {}
		
		for iter_303_1 = 1, var_303_5 do
			table.push(var_303_6, "sk_lv_eff" .. iter_303_1)
		end
		
		local var_303_7 = 0
		local var_303_8 = {
			DB("skill", var_303_4, var_303_6)
		}
		
		for iter_303_2, iter_303_3 in pairs(var_303_8) do
			if DB("skill", var_303_4, "sk_passive") then
				if iter_303_3 == "*ps_up" then
					var_303_7 = var_303_7 + 1
				else
					local var_303_9 = DB("cslv", iter_303_3, "power")
					
					var_303_0 = var_303_0 + to_n(var_303_9)
				end
			else
				local var_303_10 = DB("sklv", iter_303_3, "power")
				
				var_303_0 = var_303_0 + to_n(var_303_10)
			end
		end
		
		if var_303_7 > 0 then
			local var_303_11 = DB("combat_power", "sk_" .. var_303_7, "value")
			
			var_303_0 = var_303_0 + to_n(var_303_11)
		end
	end
	
	for iter_303_4, iter_303_5 in pairs(arg_303_0.equips) do
		if iter_303_5:isArtifact() then
			local var_303_12 = iter_303_5.grade
			local var_303_13 = iter_303_5:getSkillLevel() + 1
			local var_303_14 = string.format("art_%d_%d", var_303_12, var_303_13)
			local var_303_15 = DB("combat_power", var_303_14, "value")
			
			var_303_1 = var_303_1 + to_n(var_303_15)
			
			if DEBUG.CP_PRINT then
				print("=========== Artifact =============")
				print("grade :", var_303_12)
				print("eq_sk :", var_303_13)
				print("eq_id :", var_303_14)
				print("eq_power :", var_303_15)
			end
		elseif iter_303_5:isExclusive() then
			local var_303_16 = DB("combat_power", "exc", "value")
			
			var_303_3 = var_303_3 + to_n(var_303_16)
		end
	end
	
	local var_303_17 = 0
	local var_303_18, var_303_19 = arg_303_0:getRuneBonus()
	
	for iter_303_6, iter_303_7 in pairs(var_303_19) do
		if iter_303_7[1] and iter_303_7[2] then
			var_303_17 = var_303_17 + 1
		end
	end
	
	if var_303_17 > 0 then
		local var_303_20 = DB("combat_power", "rune_" .. var_303_17, "value")
		
		var_303_2 = var_303_2 + to_n(var_303_20)
	end
	
	local var_303_21 = 1 + var_303_0 + var_303_1 + var_303_2 + var_303_3
	local var_303_22 = 1.6
	local var_303_23 = 9.3
	local var_303_24 = 0.024
	local var_303_25 = 5
	local var_303_26 = -20
	local var_303_27 = 225
	local var_303_28 = arg_303_1.att * var_303_22 * (1 - arg_303_1.cri) + arg_303_1.att * var_303_22 * arg_303_1.cri * arg_303_1.cri_dmg
	local var_303_29 = arg_303_1.max_hp + arg_303_1.def * var_303_23
	local var_303_30 = 1 + (arg_303_1.res + arg_303_1.acc) / var_303_25
	local var_303_31 = 1 + (arg_303_1.speed - 45) * var_303_24
	local var_303_32 = 1 + (arg_303_1.speed + var_303_26) / var_303_27
	local var_303_33 = (var_303_28 * var_303_31 + var_303_29 * var_303_32) * var_303_30
	
	if DEBUG.CP_PRINT then
		print("=========== stat PRINT =============")
		print("status.att", arg_303_1.att)
		print("status.cri", arg_303_1.cri)
		print("status.cri_dmg", arg_303_1.cri_dmg)
		print("status.speed", arg_303_1.speed)
		print("status.max_hp", arg_303_1.max_hp)
		print("status.def", arg_303_1.def)
		print("status.acc", arg_303_1.acc)
		print("status.res", arg_303_1.res)
		print("=========== CP PRINT =============")
		print("stat_point :", var_303_33)
		print("skill_point :", var_303_0)
		print("artifact_point :", var_303_1)
		print("rune_point :", var_303_2)
		print("exclusive_point :", var_303_3)
	end
	
	return math.floor(var_303_33 * var_303_21)
end

function var_0_0.isLocked(arg_304_0)
	return arg_304_0.inst.locked
end

function var_0_0.isFavoriteUnit(arg_305_0)
	return arg_305_0:getUnitOptionValue("favorite_unit") == 1
end

function var_0_0.getUID(arg_306_0)
	return arg_306_0.inst.uid
end

function var_0_0.getUnitType(arg_307_0)
	return arg_307_0:isSummon() and "summon" or "unit"
end

function var_0_0.getArenaUID(arg_308_0)
	return arg_308_0.inst.arena_uid
end

function var_0_0.onCalcExtinct(arg_309_0, arg_309_1, arg_309_2)
	return arg_309_0.states:onCalcExtinct(arg_309_1, arg_309_2)
end

function var_0_0.checkFinishCallback(arg_310_0, arg_310_1)
	return arg_310_0.states:checkFinishCallback(arg_310_1)
end

function var_0_0.getBaseGrade(arg_311_0)
	return arg_311_0.db.grade
end

function var_0_0.getGrade(arg_312_0)
	return arg_312_0.inst.grade
end

function var_0_0.getMaxGrade(arg_313_0)
	return 6
end

function var_0_0.getZodiacGrade(arg_314_0, arg_314_1)
	arg_314_1 = arg_314_1 or arg_314_0.inst.zodiac
	
	return math.min(6, arg_314_1)
end

function var_0_0.getType(arg_315_0)
	return arg_315_0.db.type
end

function var_0_0.getMaxLevel(arg_316_0, arg_316_1)
	if arg_316_0.db.type == "xpup" or arg_316_0.db.type == "skillup" then
		return 1
	end
	
	if arg_316_0.db.type ~= "character" and arg_316_0.db.type ~= "promotion" and arg_316_0.db.type ~= "limited" then
		return GAME_STATIC_VARIABLE.monster_max_level
	end
	
	arg_316_1 = arg_316_1 or arg_316_0:getGrade()
	
	return arg_316_1 * 10
end

function var_0_0.isMaxLevel(arg_317_0)
	return arg_317_0.inst.lv >= arg_317_0:getMaxLevel()
end

function var_0_0.getRestExp(arg_318_0, arg_318_1)
	arg_318_1 = arg_318_1 or arg_318_0.inst.lv
	
	return to_n(DB("exp", tostring(arg_318_1), "tier" .. arg_318_0:getBaseGrade())) - arg_318_0:getEXP()
end

function var_0_0.getNextExp(arg_319_0, arg_319_1)
	arg_319_1 = arg_319_1 or arg_319_0.inst.lv
	
	return DB("exp", tostring(arg_319_1), "tier" .. arg_319_0:getBaseGrade())
end

function var_0_0.getNeedExp(arg_320_0, arg_320_1)
	arg_320_1 = arg_320_1 or arg_320_0.inst.lv
	
	local var_320_0 = DB("exp", tostring(arg_320_1), "tier" .. arg_320_0:getBaseGrade())
	
	if arg_320_1 <= 1 then
		return var_320_0
	end
	
	return var_320_0 - DB("exp", tostring(arg_320_1 - 1), "tier" .. arg_320_0:getBaseGrade())
end

function var_0_0.isMaxFavoriteLevel(arg_321_0)
	return arg_321_0:getFavLevel() >= arg_321_0:getMaxFavoriteLevel()
end

function var_0_0.getMaxFavoriteLevel(arg_322_0)
	return 10
end

function var_0_0.getRoleCaption(arg_323_0, arg_323_1)
	arg_323_1 = arg_323_1 or arg_323_0.db.role or ""
	
	return T("db_character_role_" .. arg_323_1)
end

function var_0_0.getSkillDB(arg_324_0, arg_324_1, arg_324_2, arg_324_3, arg_324_4)
	local var_324_0 = {
		DB("skill", arg_324_1, arg_324_2)
	}
	local var_324_1 = table.clone(var_324_0)
	local var_324_2 = arg_324_0
	local var_324_3 = arg_324_3 or {}
	local var_324_4 = arg_324_4 and arg_324_4.effect
	
	if type(var_324_2) == "table" then
		var_324_2 = arg_324_0:getSkillLevel(arg_324_1)
		
		local var_324_5, var_324_6 = arg_324_0:getReferSkillIndex(arg_324_1)
		
		var_324_3 = arg_324_0:getRuneSkillBonusByIndex(var_324_5, var_324_6)
		var_324_4 = arg_324_0:getExclusiveEffect(var_324_5).effect
	end
	
	local var_324_7 = {}
	
	for iter_324_0 = 1, var_324_2 do
		table.push(var_324_7, "sk_lv_eff" .. iter_324_0)
	end
	
	local var_324_8 = {
		DB("skill", arg_324_1, var_324_7)
	}
	local var_324_9 = arg_324_2
	
	if type(var_324_9) ~= "table" then
		var_324_9 = {
			var_324_9
		}
	end
	
	local var_324_10 = 0
	
	for iter_324_1 = #var_324_8, 1, -1 do
		if var_324_8[iter_324_1] == "*ps_up" then
			var_324_10 = var_324_10 + 1
			
			table.remove(var_324_8, iter_324_1)
		end
	end
	
	for iter_324_2 = #var_324_3, 1, -1 do
		if var_324_3[iter_324_2] == "*ps_up" then
			var_324_10 = var_324_10 + 1
			
			table.remove(var_324_3, iter_324_2)
		end
	end
	
	if var_324_4 == "*ps_up" then
		var_324_10 = var_324_10 + 1
		var_324_4 = nil
	end
	
	local function var_324_11(arg_325_0, arg_325_1, arg_325_2, arg_325_3)
		for iter_325_0, iter_325_1 in pairs(arg_325_3) do
			if not iter_325_1 then
				break
			end
			
			local var_325_0 = SLOW_DB_ALL("sklv", tostring(iter_325_1))
			
			for iter_325_2 = 1, #arg_325_0 do
				for iter_325_3 = 1, 6 do
					local var_325_1 = var_325_0["type" .. iter_325_3]
					
					if not var_325_1 then
						break
					end
					
					if arg_325_1[iter_325_2] and (arg_325_0[iter_325_2] == var_325_1 or var_325_1 == "sk_add_rate" and string.starts(arg_325_0[iter_325_2], "sk_add_rate")) then
						if var_325_0["change" .. iter_325_3] then
							arg_325_1[iter_325_2] = var_325_0["change" .. iter_325_3]
						end
						
						if var_325_0["add" .. iter_325_3] then
							arg_325_1[iter_325_2] = arg_325_1[iter_325_2] + to_n(var_325_0["add" .. iter_325_3])
						end
						
						if var_325_0["mul" .. iter_325_3] then
							arg_325_1[iter_325_2] = arg_325_1[iter_325_2] + arg_325_2[iter_325_2] * to_n(var_325_0["mul" .. iter_325_3])
						end
					end
				end
			end
		end
	end
	
	var_324_11(var_324_9, var_324_0, var_324_1, var_324_8)
	var_324_11(var_324_9, var_324_0, var_324_1, var_324_3)
	
	if var_324_4 then
		var_324_11(var_324_9, var_324_0, var_324_1, {
			var_324_4
		})
	end
	
	if var_324_10 > 0 then
		for iter_324_3, iter_324_4 in pairs(var_324_9) do
			if iter_324_4 == "sk_passive" then
				var_324_0[iter_324_3] = var_324_0[iter_324_3] .. var_324_10
			end
		end
	end
	
	if type(arg_324_2) == "string" then
		return var_324_0[1]
	end
	
	return argument_unpack(var_324_0)
end

function var_0_0.getCSDB_All(arg_326_0, arg_326_1, arg_326_2, arg_326_3)
	local var_326_0 = arg_326_1 or SLOW_DB_ALL("cs", tostring(arg_326_2))
	local var_326_1 = {}
	local var_326_2 = {}
	
	for iter_326_0, iter_326_1 in pairs(var_326_0) do
		table.push(var_326_1, iter_326_0)
		table.push(var_326_2, iter_326_1)
	end
	
	local var_326_3 = {
		UNIT.getCSDB(arg_326_0, arg_326_2, var_326_1, {
			db = var_326_2,
			skill_id = arg_326_3
		})
	}
	local var_326_4 = {}
	
	for iter_326_2, iter_326_3 in pairs(var_326_1) do
		var_326_4[iter_326_3] = var_326_3[iter_326_2]
	end
	
	return var_326_4
end

function var_0_0.getCSDB(arg_327_0, arg_327_1, arg_327_2, arg_327_3)
	local var_327_0 = arg_327_3 or {}
	local var_327_1 = var_327_0.skill_id
	local var_327_2 = var_327_0.db or {
		DB("cs", arg_327_1, arg_327_2)
	}
	local var_327_3 = table.clone(var_327_2)
	
	if not var_327_1 or not DB("skill", var_327_1, "sk_passive") then
		return argument_unpack(var_327_2)
	end
	
	local var_327_4 = arg_327_0 or 0
	local var_327_5 = {}
	local var_327_6
	
	if var_327_0.exclusive_bonus then
		if type(var_327_0.exclusive_bonus) == "table" then
			var_327_6 = var_327_0.exclusive_bonus.effect
		else
			var_327_6 = var_327_0.exclusive_bonus
		end
	end
	
	if type(var_327_4) == "table" then
		var_327_4 = arg_327_0:getSkillLevel(var_327_1)
		
		local var_327_7, var_327_8 = arg_327_0:getReferSkillIndex(var_327_1)
		
		var_327_5 = arg_327_0:getRuneSkillBonusByIndex(var_327_7, var_327_8)
		var_327_6 = arg_327_0:getExclusiveEffect(var_327_7).effect
	end
	
	local var_327_9 = {}
	
	for iter_327_0 = 1, var_327_4 do
		table.push(var_327_9, "sk_lv_eff" .. iter_327_0)
	end
	
	local var_327_10 = {
		DB("skill", var_327_1, var_327_9)
	}
	local var_327_11 = arg_327_2
	
	if type(var_327_11) ~= "table" then
		var_327_11 = {
			var_327_11
		}
	end
	
	local function var_327_12(arg_328_0, arg_328_1, arg_328_2, arg_328_3)
		for iter_328_0, iter_328_1 in pairs(arg_328_3) do
			if not iter_328_1 then
				break
			end
			
			local var_328_0
			
			if DB("cslv", tostring(iter_328_1), "id") then
				var_328_0 = SLOW_DB_ALL("cslv", tostring(iter_328_1))
				
				for iter_328_2 = 1, #arg_328_0 do
					for iter_328_3 = 1, 18 do
						if var_328_0["cs_id" .. iter_328_3] == arg_327_1 then
							local var_328_1 = var_328_0["type" .. iter_328_3]
							
							if not var_328_1 then
								break
							end
							
							if arg_328_1[iter_328_2] and arg_328_0[iter_328_2] == var_328_1 then
								if var_328_0["add" .. iter_328_3] then
									arg_328_1[iter_328_2] = arg_328_1[iter_328_2] + to_n(var_328_0["add" .. iter_328_3])
								end
								
								if var_328_0["mul" .. iter_328_3] then
									arg_328_1[iter_328_2] = arg_328_1[iter_328_2] + arg_328_2[iter_328_2] * to_n(var_328_0["mul" .. iter_328_3])
								end
							end
						end
					end
				end
			end
		end
	end
	
	if var_327_6 == "*ps_up" then
		var_327_6 = nil
	end
	
	if var_327_6 then
		var_327_12(var_327_11, var_327_2, var_327_3, {
			var_327_6
		})
	end
	
	var_327_12(var_327_11, var_327_2, var_327_3, var_327_5)
	
	if not table.find(var_327_10, "*ps_up") then
		var_327_12(var_327_11, var_327_2, var_327_3, var_327_10)
	end
	
	if type(arg_327_2) == "string" then
		return var_327_2[1]
	end
	
	return argument_unpack(var_327_2)
end

function var_0_0.getPassiveSkill(arg_329_0)
	return var_0_1(DB("character", arg_329_0.inst.code, "pskill_1"))
end

function var_0_0.is_percentage_stat(arg_330_0)
	if arg_330_0 == "con" or arg_330_0 == "dodge" or arg_330_0 == "cri" or arg_330_0 == "res" or arg_330_0 == "cri_dmg" or arg_330_0 == "pen" or arg_330_0 == "res_stun" or arg_330_0 == "acc" or arg_330_0 == "coop" or arg_330_0 == "redu" then
		return true
	end
	
	if arg_330_0 and string.len(arg_330_0) > 5 and string.sub(arg_330_0, -5, -1) == "_rate" then
		return true, true
	end
end

function var_0_0.setSkillLevelInfo(arg_331_0, arg_331_1)
	arg_331_0.inst.skill_lv = arg_331_1
	
	arg_331_0:calc()
end

function var_0_0.getEquipCountOfSetItem(arg_332_0, arg_332_1)
	if arg_332_1 == nil then
		return 0
	end
	
	local var_332_0 = 0
	
	for iter_332_0, iter_332_1 in pairs(arg_332_0.equips) do
		if iter_332_1.set_fx == arg_332_1 then
			var_332_0 = var_332_0 + 1
		end
	end
	
	return var_332_0
end

function var_0_0.getEquipIndexOfSetItem(arg_333_0, arg_333_1, arg_333_2)
	if arg_333_1 == nil then
		return 0
	end
	
	local var_333_0 = 0
	
	for iter_333_0, iter_333_1 in pairs(arg_333_0.equips) do
		if iter_333_1.set_fx == arg_333_1 then
			var_333_0 = var_333_0 + 1
			
			if iter_333_1 == arg_333_2 then
				break
			end
		end
	end
	
	local var_333_1 = EQUIP:getSetItemTotalCount(arg_333_1)
	local var_333_2 = arg_333_0:getEquipCountOfSetItem(arg_333_1)
	
	if var_333_0 <= math.floor(var_333_2 / var_333_1) * var_333_1 then
		var_333_0 = var_333_1
	else
		var_333_0 = var_333_2 % var_333_1
	end
	
	return var_333_0
end

function var_0_0.eachSetItemApply(arg_334_0, arg_334_1, arg_334_2)
	local var_334_0 = {}
	local var_334_1 = {}
	
	for iter_334_0, iter_334_1 in pairs(arg_334_0.equips) do
		if iter_334_1:isSetItem() then
			if not table.find(var_334_1, iter_334_1.set_fx) then
				table.insert(var_334_1, iter_334_1.set_fx)
			end
			
			var_334_0[iter_334_1.set_fx] = var_334_0[iter_334_1.set_fx] or {}
			
			table.insert(var_334_0[iter_334_1.set_fx], iter_334_1)
		end
	end
	
	for iter_334_2, iter_334_3 in pairs(var_334_1) do
		local var_334_2 = var_334_0[iter_334_3] or {}
		local var_334_3 = EQUIP:getSetItemTotalCount(iter_334_3)
		local var_334_4 = #var_334_2 / var_334_3
		local var_334_5 = math.if_nan_or_inf(var_334_4, 0)
		local var_334_6 = 0
		
		if arg_334_2 then
			var_334_6 = arg_334_2(iter_334_3)
		end
		
		for iter_334_4 = 1 + var_334_6, var_334_5 do
			arg_334_1(iter_334_3)
		end
	end
end

function var_0_0.makeUnitLog(arg_335_0)
	if arg_335_0:getLv() < 50 then
		return 
	end
	
	if arg_335_0:isSpecialUnit() and not arg_335_0:isPromotionUnit() then
		return 
	end
	
	if (DB("character", arg_335_0.inst.code, "grade") or 3) < 3 then
		return 
	end
	
	local var_335_0
	local var_335_1
	local var_335_2
	local var_335_3 = {}
	local var_335_4 = 0
	
	for iter_335_0, iter_335_1 in pairs(arg_335_0.equips) do
		var_335_3[iter_335_1.db.type] = true
		
		if iter_335_1:isExclusive() then
			var_335_0 = iter_335_1.db.exclusive_skill
			var_335_1 = to_n(string.sub(iter_335_1.exclusive_id, -2, -1))
		elseif iter_335_1:isArtifact() then
			var_335_2 = iter_335_1.code
		else
			var_335_4 = var_335_4 + iter_335_1:getEquipPoint()
		end
	end
	
	local var_335_5 = {
		"weapon",
		"helm",
		"neck",
		"armor",
		"boot",
		"ring",
		"artifact"
	}
	
	for iter_335_2, iter_335_3 in pairs(var_335_5) do
		if not var_335_3[iter_335_3] then
			return 
		end
	end
	
	if arg_335_0:isExclusiveEquip_exist() and not var_335_3.exclusive then
		return 
	end
	
	local var_335_6 = arg_335_0:clone(true)
	
	var_335_6.states:clear({
		ignore_passives = true
	})
	
	local var_335_7 = {}
	
	var_335_6:eachSetItemApply(function(arg_336_0)
		local var_336_0 = string.sub(arg_336_0 or "", 5, -1)
		
		table.insert(var_335_7, var_336_0)
	end)
	
	local var_335_8 = {}
	local var_335_9 = var_335_6.status
	
	var_335_8.code = arg_335_0.inst.code
	var_335_8.att = var_335_9.att
	var_335_8.def = var_335_9.def
	var_335_8.hp = var_335_9.max_hp
	var_335_8.spd = var_335_9.speed
	var_335_8.cri = var_335_9.cri
	var_335_8.cri_dmg = var_335_9.cri_dmg
	var_335_8.acc = var_335_9.acc
	var_335_8.res = var_335_9.res
	var_335_8.set_effs = var_335_7
	var_335_8.lv = arg_335_0:getLv()
	var_335_8.z = to_n(arg_335_0:getZodiacGrade())
	var_335_8.aw = to_n(arg_335_0:getAwakeGrade())
	var_335_8.ex_c = var_335_0
	var_335_8.ex_n = var_335_1
	var_335_8.at_c = var_335_2
	var_335_8.eqp = var_335_4
	
	return var_335_8
end

function var_0_0.makeZlongUnitLog(arg_337_0)
	local var_337_0
	local var_337_1
	
	for iter_337_0, iter_337_1 in pairs(arg_337_0.equips) do
		if iter_337_1:isArtifact() then
			var_337_0 = iter_337_1.code
			var_337_1 = iter_337_1.enhance
		end
	end
	
	return {
		code = arg_337_0.inst.code,
		at_c = var_337_0,
		at_e = var_337_1
	}
end

function var_0_0.isSameVariationGroupOnlyPlayer(arg_338_0, arg_338_1)
	if MoonlightDestiny:isRelationCharacterCode(arg_338_0.db.code, arg_338_1.db.code) then
		return true
	end
	
	return arg_338_0.db.set_group and arg_338_0.db.set_group == arg_338_1.db.set_group or arg_338_0.db.code == arg_338_1.db.code
end

function var_0_0.isSameVariationGroup(arg_339_0, arg_339_1)
	if not arg_339_1 or not arg_339_1.db.code then
		return false
	end
	
	return arg_339_0.db.variation_group and arg_339_0.db.variation_group == arg_339_1.db.variation_group
end

function var_0_0.greaterThanTime(arg_340_0, arg_340_1)
	return arg_340_0.inst.elapsed_ut > arg_340_1.inst.elapsed_ut
end

function var_0_0.greaterThanTeam(arg_341_0, arg_341_1)
	local var_341_0 = Account:isInTeam(arg_341_0) ~= false
	
	if var_341_0 ~= (Account:isInTeam(arg_341_1) ~= false) then
		return var_341_0
	end
end

function var_0_0.greaterThanLevel(arg_342_0, arg_342_1)
	if arg_342_0.inst.lv == arg_342_1.inst.lv then
		return var_0_0.greaterThanExp(arg_342_0, arg_342_1)
	end
	
	return arg_342_0.inst.lv > arg_342_1.inst.lv
end

function var_0_0.greaterThanExp(arg_343_0, arg_343_1)
	if arg_343_0.inst.exp == arg_343_1.inst.exp then
		return var_0_0.greaterThanGrade(arg_343_0, arg_343_1)
	end
	
	return arg_343_0.inst.exp > arg_343_1.inst.exp
end

function var_0_0.greaterThanSubTaskPoint(arg_344_0, arg_344_1)
	local var_344_0 = arg_344_0:isDoingSubTask()
	local var_344_1 = arg_344_1:isDoingSubTask()
	
	if var_344_0 ~= var_344_1 then
		return var_344_1 == true
	end
	
	local var_344_2 = arg_344_0:getSubTaskSkillPoint()
	local var_344_3 = arg_344_1:getSubTaskSkillPoint()
	
	if var_344_2 == var_344_3 then
		return var_0_0.greaterThanUID(arg_344_0, arg_344_1)
	end
	
	return var_344_3 < var_344_2
end

function var_0_0.greaterThanUID(arg_345_0, arg_345_1)
	return arg_345_0.inst.uid < arg_345_1.inst.uid
end

function var_0_0.greaterThanGrade(arg_346_0, arg_346_1)
	if arg_346_0.inst.grade == arg_346_1.inst.grade then
		return var_0_0.greaterThanBaseGrade(arg_346_0, arg_346_1)
	end
	
	return arg_346_0.inst.grade > arg_346_1.inst.grade
end

function var_0_0.greaterThanBaseGrade(arg_347_0, arg_347_1)
	if arg_347_0.db.grade == arg_347_1.db.grade then
		return var_0_0.greaterThanCode(arg_347_0, arg_347_1)
	end
	
	return arg_347_0.db.grade > arg_347_1.db.grade
end

function var_0_0.greaterThanCode(arg_348_0, arg_348_1)
	if arg_348_0.inst.code == arg_348_1.inst.code then
		return var_0_0.greaterThanPoint(arg_348_0, arg_348_1)
	end
	
	return arg_348_0.inst.code > arg_348_1.inst.code
end

var_0_0.ROLE_SORT_ORDER = {
	manauser = 2,
	knight = 6,
	material = 1,
	assassin = 5,
	warrior = 7,
	ranger = 4,
	mage = 3
}

function var_0_0.greaterThanRole(arg_349_0, arg_349_1)
	if arg_349_0.db.role == arg_349_1.db.role then
		return var_0_0.greaterThanCode(arg_349_0, arg_349_1)
	end
	
	return var_0_0.ROLE_SORT_ORDER[arg_349_0.db.role] > var_0_0.ROLE_SORT_ORDER[arg_349_1.db.role]
end

function var_0_0.greaterThanName(arg_350_0, arg_350_1)
	local var_350_0 = arg_350_0:getName()
	local var_350_1 = arg_350_1:getName()
	
	if var_350_0 == var_350_1 then
		return var_0_0.greaterThanCode(arg_350_0, arg_350_1)
	end
	
	return var_350_0 < var_350_1
end

function var_0_0.greaterThanPoint(arg_351_0, arg_351_1)
	if arg_351_0:getPoint() == arg_351_1:getPoint() then
		return var_0_0.greaterThanUID(arg_351_0, arg_351_1)
	end
	
	return arg_351_0:getPoint() > arg_351_1:getPoint()
end

IS_STRONG_COLOR_AGAINST = {
	fire = {
		wind = true
	},
	ice = {
		fire = true
	},
	wind = {
		ice = true
	},
	light = {
		dark = true
	},
	dark = {
		light = true
	},
	none = {}
}

function var_0_0.isWeaknessAgainst(arg_352_0, arg_352_1, arg_352_2)
	if arg_352_0.db.color == "dark" or arg_352_0.db.color == "light" then
		return false
	end
	
	if not IS_STRONG_COLOR_AGAINST[arg_352_1.db.color][arg_352_0.db.color] then
		return false
	end
	
	if arg_352_2 and DB("skill", arg_352_2, "attribute_advantage") then
		return false
	end
	
	if arg_352_0.states:getEffValue(2004) then
		return false
	end
	
	if arg_352_0.skill_inst_vars and arg_352_0.skill_inst_vars.ignore_attribute then
		return false
	end
	
	return true
end

function var_0_0.isStrongAgainst(arg_353_0, arg_353_1, arg_353_2)
	if IS_STRONG_COLOR_AGAINST[arg_353_0.db.color][arg_353_1.db.color] then
		return true
	end
	
	if arg_353_2 and DB("skill", arg_353_2, "attribute_advantage") == "all_strong" then
		return true
	end
	
	if arg_353_0.states:getEffValue(2004) == "all_strong" then
		return true
	end
	
	if arg_353_0.skill_inst_vars and arg_353_0.skill_inst_vars.ignore_attribute then
		return true
	end
	
	return false
end

local var_0_9 = {
	wind = 3,
	fire = 1,
	none = 6,
	light = 4,
	dark = 5,
	ice = 2
}

function var_0_0.greaterThanColor(arg_354_0, arg_354_1)
	if arg_354_0.db.color == arg_354_1.db.color then
		return var_0_0.greaterThanGrade(arg_354_0, arg_354_1)
	end
	
	return var_0_9[arg_354_0.db.color] < var_0_9[arg_354_1.db.color]
end

function var_0_0.getColor(arg_355_0)
	return arg_355_0.db.color
end

function var_0_0.isMoonlight(arg_356_0)
	return arg_356_0.db.moonlight == "y"
end

function var_0_0.getConsumeExp(arg_357_0, arg_357_1)
	return arg_357_1.db.exp
end

function var_0_0.getRuneSkillBonusByIndex(arg_358_0, arg_358_1, arg_358_2)
	local var_358_0, var_358_1 = arg_358_0:getRuneBonus()
	local var_358_2 = {}
	
	arg_358_2 = tonumber(arg_358_2)
	
	if arg_358_2 then
		for iter_358_0, iter_358_1 in pairs(var_358_1) do
			if arg_358_2 == iter_358_1[1] or arg_358_1 == iter_358_1[1] then
				table.insert(var_358_2, iter_358_1[2])
			end
		end
	end
	
	return var_358_2
end

function var_0_0.getRuneBonus(arg_359_0)
	local var_359_0 = string.match(arg_359_0.db.code, "%l%d+") or arg_359_0.db.code
	local var_359_1 = string.format("st_%s_", var_359_0)
	local var_359_2 = {}
	local var_359_3 = {}
	local var_359_4 = 0
	
	for iter_359_0 = 1, 5 do
		local var_359_5 = var_359_1 .. iter_359_0
		local var_359_6 = DBT("skill_tree", var_359_5, {
			"id",
			"skill_point",
			"pos_1",
			"req_1",
			"pos_2",
			"req_2",
			"pos_3",
			"req_3"
		})
		
		if not var_359_6 or not var_359_6.id then
			return var_359_2, var_359_3
		end
		
		for iter_359_1 = 1, 3 do
			local var_359_7 = var_359_6["pos_" .. iter_359_1]
			
			if var_359_7 then
				var_359_4 = var_359_4 + 1
				
				local var_359_8 = var_359_4
				local var_359_9 = arg_359_0:getSTreeLevel(var_359_8)
				
				if var_359_9 > 0 then
					for iter_359_2 = 1, var_359_9 do
						local var_359_10 = var_359_7 .. "_" .. iter_359_2
						local var_359_11 = DBT("skill_tree_rune", var_359_10, {
							"type",
							"stat",
							"value",
							"skill_number",
							"skill_lv"
						})
						
						if var_359_11.type == "stat" then
							if var_359_11.stat then
								table.insert(var_359_2, {
									var_359_11.stat,
									var_359_11.value
								})
							end
						elseif var_359_11.skill_number then
							table.insert(var_359_3, {
								var_359_11.skill_number,
								var_359_11.skill_lv
							})
						end
					end
				end
			end
		end
	end
	
	return var_359_2, var_359_3
end

function var_0_0.getZodiacBonus(arg_360_0, arg_360_1, arg_360_2, arg_360_3)
	arg_360_2 = arg_360_2 or arg_360_0.db.sphere_bonus_id
	arg_360_1 = arg_360_1 or to_n(arg_360_0:getZodiacGrade())
	
	local var_360_0 = {}
	local var_360_1 = 0
	local var_360_2 = 1
	
	if arg_360_3 then
		var_360_2 = arg_360_1
	end
	
	for iter_360_0 = var_360_2, arg_360_1 do
		local var_360_3, var_360_4, var_360_5, var_360_6, var_360_7, var_360_8 = DB("zodiac_stone_2", arg_360_2 .. "_" .. iter_360_0, {
			"main_stat_type",
			"main_stat",
			"sub_stat_type1",
			"sub_stat1",
			"sub_stat_type2",
			"sub_stat2",
			"sub_stat_type3",
			"sub_stat3"
		})
		local var_360_9 = {
			var_360_3,
			var_360_5,
			var_360_7
		}
		local var_360_10 = {
			var_360_4,
			var_360_6,
			var_360_8
		}
		
		for iter_360_1 = 1, 3 do
			if var_360_9[iter_360_1] then
				var_360_1 = var_360_1 + 1
				var_360_0[var_360_1] = {
					var_360_9[iter_360_1],
					var_360_10[iter_360_1]
				}
			end
		end
	end
	
	return var_360_0
end

function var_0_0.isAwakeUnit(arg_361_0)
	return not table.empty(arg_361_0:getAwakeBonus(1, true))
end

function var_0_0.getAwakeBonus(arg_362_0, arg_362_1, arg_362_2)
	arg_362_1 = arg_362_1 or to_n(arg_362_0:getAwakeGrade())
	
	local var_362_0 = "ca_" .. arg_362_0.db.code
	local var_362_1 = {}
	local var_362_2 = 1
	
	if arg_362_2 then
		var_362_2 = arg_362_1
	end
	
	for iter_362_0 = var_362_2, arg_362_1 do
		local var_362_3 = var_0_0.CORE_NODE_NUM == iter_362_0
		local var_362_4, var_362_5, var_362_6, var_362_7, var_362_8, var_362_9, var_362_10, var_362_11 = DB("char_awake", var_362_0 .. "_" .. iter_362_0, {
			"main_stat_type",
			"main_stat",
			"sub_stat_type1",
			"sub_stat1",
			"sub_stat_type2",
			"sub_stat2",
			"sub_stat_type3",
			"sub_stat3"
		})
		local var_362_12 = {
			var_362_4,
			var_362_6,
			var_362_8,
			var_362_10
		}
		local var_362_13 = {
			var_362_5,
			var_362_7,
			var_362_9,
			var_362_11
		}
		
		for iter_362_1 = 1, 4 do
			if var_362_12[iter_362_1] and var_362_13[iter_362_1] and (not var_362_3 or iter_362_1 ~= 1) then
				table.insert(var_362_1, {
					var_362_12[iter_362_1],
					var_362_13[iter_362_1]
				})
			end
		end
	end
	
	return var_362_1
end

function var_0_0.getAwakeCoreSkills(arg_363_0)
	local var_363_0 = {}
	
	for iter_363_0 = 1, 6 do
		local var_363_1 = string.format("ca_%s_%d", arg_363_0.db.code, iter_363_0)
		local var_363_2 = DB("char_awake", var_363_1, "skill_up")
		
		if var_363_2 then
			table.insert(var_363_0, var_363_2)
			
			for iter_363_1 = 1, 7 do
				local var_363_3 = string.format("%s_%d", var_363_1, iter_363_1)
				local var_363_4 = DB("char_awake", var_363_3, {
					"skill_up"
				})
				
				if var_363_4 then
					table.insert(var_363_0, var_363_4)
				end
			end
		end
	end
	
	return var_363_0
end

function var_0_0._getAwakeCoreNode(arg_364_0, arg_364_1)
	arg_364_1 = arg_364_1 or to_n(arg_364_0:getAwakeGrade())
	
	local var_364_0 = {}
	local var_364_1 = {}
	
	if arg_364_1 < var_0_0.CORE_NODE_NUM then
		return var_364_1, var_364_0
	end
	
	local function var_364_2(arg_365_0, arg_365_1, arg_365_2)
		local var_365_0, var_365_1, var_365_2, var_365_3 = DB("char_awake", arg_365_0, {
			"id",
			"skill_up",
			"main_stat_type",
			"main_stat"
		})
		
		if var_365_0 then
			if var_365_2 and var_365_3 then
				table.insert(arg_365_2, {
					var_365_2,
					var_365_3
				})
			end
			
			if var_365_1 then
				table.insert(arg_365_1, var_365_1)
			end
		end
	end
	
	local var_364_3 = string.format("ca_%s_%d", arg_364_0.db.code, var_0_0.CORE_NODE_NUM)
	
	var_364_2(var_364_3, var_364_1, var_364_0)
	
	local var_364_4 = arg_364_0:getPresentDevote()
	
	for iter_364_0 = 1, var_364_4 do
		local var_364_5 = string.format("%s_%d", var_364_3, to_n(iter_364_0))
		
		var_364_2(var_364_5, var_364_1, var_364_0)
	end
	
	return var_364_1, var_364_0
end

function var_0_0.getAwakeSkill(arg_366_0, arg_366_1)
	local var_366_0, var_366_1 = arg_366_0:_getAwakeCoreNode(arg_366_1)
	
	return var_366_0
end

function var_0_0.getAwakeCoreBonus(arg_367_0, arg_367_1)
	local var_367_0, var_367_1 = arg_367_0:_getAwakeCoreNode(arg_367_1)
	
	return var_367_1
end

function var_0_0.getAwakeGrade(arg_368_0)
	if not arg_368_0.inst then
		return 0
	end
	
	return math.min(to_n(arg_368_0.inst.awake), 6)
end

function var_0_0.isUpgradable(arg_369_0)
	return not arg_369_0:isSpecialUnit() and arg_369_0:isMaxLevel() and arg_369_0:getGrade() < 6
end

function var_0_0.isZodiacUpgradable(arg_370_0)
	if not arg_370_0.db.zodiac then
		return false
	end
	
	if arg_370_0:isPromotionUnit() or arg_370_0:isExpUnit() or arg_370_0:isDevotionUnit() then
		return false
	end
	
	if arg_370_0:getZodiacGrade() >= 1 and arg_370_0:getZodiacGrade() >= math.floor(arg_370_0:getLv() / 10) then
		return false
	end
	
	local var_370_0 = arg_370_0:getZodiacGrade()
	local var_370_1, var_370_2, var_370_3, var_370_4 = DB("rune_req", arg_370_0:getRuneDBKey(), {
		"req" .. var_370_0 + 1 .. "_1",
		"req" .. var_370_0 + 1 .. "_2",
		"count" .. var_370_0 + 1 .. "_1",
		"count" .. var_370_0 + 1 .. "_2"
	})
	
	if var_370_1 and var_370_3 and Account:getItemCount(var_370_1) < to_n(var_370_3) then
		return false
	end
	
	if var_370_2 and var_370_4 and Account:getItemCount(var_370_2) < to_n(var_370_4) then
		return false
	end
	
	return true
end

function var_0_0.isAwakeUpgradable(arg_371_0)
	if not arg_371_0:isAwakeUnit() then
		return false
	end
	
	if arg_371_0:isGrowthBoostRegistered() then
		return false
	end
	
	if arg_371_0:getZodiacGrade() < 6 then
		return false
	end
	
	if arg_371_0:getAwakeGrade() >= math.floor(arg_371_0:getLv() / 10) then
		return false
	end
	
	local var_371_0 = arg_371_0:getAwakeGrade() + 1
	local var_371_1 = "ca_" .. arg_371_0.db.code .. "_" .. var_371_0
	local var_371_2, var_371_3, var_371_4, var_371_5, var_371_6, var_371_7 = DB("char_awake", var_371_1, {
		"req1",
		"req2",
		"req3",
		"count1",
		"count2",
		"count3"
	})
	
	if var_371_2 and var_371_5 and Account:getItemCount(var_371_2) < to_n(var_371_5) then
		return false
	end
	
	if var_371_3 and var_371_6 and Account:getItemCount(var_371_3) < to_n(var_371_6) then
		return false
	end
	
	if var_371_4 and var_371_7 and Account:getItemCount(var_371_4) < to_n(var_371_7) then
		return false
	end
	
	return true
end

function var_0_0.getDevoteCountFromUnits(arg_372_0, arg_372_1)
	local var_372_0 = 0
	
	for iter_372_0, iter_372_1 in pairs(arg_372_1) do
		if arg_372_0:isDevotionUpgradable(iter_372_1) then
			var_372_0 = var_372_0 + iter_372_1:getDevote() + 1
		end
	end
	
	return var_372_0
end

function var_0_0.isDevotionUpgradable(arg_373_0, arg_373_1, arg_373_2)
	if not arg_373_2 and arg_373_0:isMaxDevoteLevel() then
		return false
	end
	
	if arg_373_0:isSpecialUnit() or arg_373_0:isPromotionUnit() or not arg_373_0.db.variation_group or not arg_373_1.db.variation_group then
		return false
	end
	
	if arg_373_1.db.code ~= arg_373_0.db.code and arg_373_1:isActiveSellType("devotion_block") then
		return false
	end
	
	if string.starts(arg_373_1.db.variation_group, "*grade_") or string.starts(arg_373_1.db.variation_group, "*ordinary_grade_") and arg_373_0:isOrdinaryUnit() then
		return arg_373_0:getBaseGrade() == to_n(string.sub(arg_373_1.db.variation_group, -1, -1))
	end
	
	if string.starts(arg_373_1.db.variation_group, "*custom_group_") and string.sub(arg_373_1.db.variation_group, string.len("*custom_group_") + 1, -1) == arg_373_0.db.custom_group then
		return true
	end
	
	return arg_373_0.db.variation_group == arg_373_1.db.variation_group
end

function var_0_0.isDevotionUpgradableFragment(arg_374_0, arg_374_1, arg_374_2)
	if not arg_374_1 then
		return false
	end
	
	if arg_374_1.ma_type ~= "fragment" then
		return false
	end
	
	if not arg_374_2 and arg_374_0:isMaxDevoteLevel() then
		return false
	end
	
	if arg_374_0:isSpecialUnit() or arg_374_0:isPromotionUnit() or not arg_374_0.db.variation_group or not arg_374_1.devotion_target then
		return false
	end
	
	if arg_374_1.ma_type2 == "char" then
		if arg_374_0.db.code == arg_374_1.devotion_target then
			return true
		end
	elseif arg_374_0.db.variation_group == arg_374_1.devotion_target then
		return true
	end
	
	if string.starts(arg_374_1.devotion_target, "*grade_") and arg_374_0:getBaseGrade() == to_n(string.sub(arg_374_1.devotion_target, -1, -1)) then
		return true
	end
	
	if arg_374_0:isOrdinaryUnit() and string.starts(arg_374_1.devotion_target, "*ordinary_grade_") and arg_374_0:getBaseGrade() == to_n(string.sub(arg_374_1.devotion_target, -1, -1)) then
		return true
	end
	
	if string.starts(arg_374_1.devotion_target, "*custom_group_") and string.sub(arg_374_1.devotion_target, string.len("*custom_group_") + 1, -1) == arg_374_0.db.custom_group then
		return true
	end
	
	return false
end

function var_0_0.isUpgradeableByUnits(arg_375_0)
	return Account:getSameUnitCount(arg_375_0) > 1
end

function var_0_0.isUpgradeableByPrivateFragments(arg_376_0)
	local var_376_0 = ItemMaterial:getPrivateFragments(arg_376_0)
	
	if not var_376_0 then
		return false
	end
	
	for iter_376_0, iter_376_1 in pairs(var_376_0) do
		if iter_376_1.devotion_need_count <= (Account.items[iter_376_1.code] or 0) then
			return true
		end
	end
	
	return false
end

function var_0_0.isUpgradeable(arg_377_0)
	if not arg_377_0:isHaveDevote() then
		return false
	end
	
	if arg_377_0:isDevotionUnit() then
		return false
	end
	
	if arg_377_0:isMaxDevoteLevel() then
		return false
	end
	
	if arg_377_0:isMoonlightDestinyUnit() then
		return false
	end
	
	if arg_377_0:isUpgradeableByUnits() then
		return true
	end
	
	if arg_377_0:isUpgradeableByPrivateFragments() then
		return true
	end
	
	return false
end

function var_0_0.isSameGroup(arg_378_0, arg_378_1)
	if not arg_378_1 then
		return 
	end
	
	return not arg_378_0:isSpecialUnit() and not arg_378_0:isPromotionUnit() and arg_378_0.db.variation_group and arg_378_0.db.variation_group == arg_378_1.db.variation_group
end

function var_0_0.isPromotionUnit(arg_379_0)
	return arg_379_0.db.type == "promotion"
end

function var_0_0.isOrganizable(arg_380_0)
	if DEBUG.OLD_PROMOTION_RULE then
		return not arg_380_0:isPromotionUnit() and not arg_380_0:isSpecialUnit() and not arg_380_0:isDevotionUnit()
	end
	
	return not arg_380_0:isSpecialUnit() and not arg_380_0:isDevotionUnit()
end

function var_0_0.isDevotionUnit(arg_381_0)
	return arg_381_0.db.type == "devotion"
end

function var_0_0.isLimitedUnit(arg_382_0)
	return arg_382_0.db.type == "limited"
end

function var_0_0.isClassChangeableUnit(arg_383_0)
	if string.starts(arg_383_0.db.code, "c4") or string.starts(arg_383_0.db.code, "c5") then
		return arg_383_0.db.set_group
	end
	
	if DB("classchange_category", "cc_" .. (arg_383_0.db.code or ""), {
		"char_id_cc"
	}) == nil then
		return false
	end
	
	return arg_383_0.db.code
end

function var_0_0.isGrowthBoostRegistered(arg_384_0)
	return GrowthBoost:isRegistered(arg_384_0)
end

function var_0_0.isMoonlightDestinyUnit(arg_385_0)
	return MoonlightDestiny:isDestinyCharacter(arg_385_0.db.code)
end

function var_0_0.isLockWorldArena(arg_386_0)
	return MoonlightDestiny:isDestinyCharacter(arg_386_0.db.code)
end

function var_0_0.isLockUpgrade6(arg_387_0)
	if arg_387_0:isMoonlightDestinyUnit() and not MoonlightDestiny:isQuestUnlocked(1) then
		return true
	end
	
	return false
end

function var_0_0.isLockSkillUpgrade(arg_388_0)
	if arg_388_0:isMoonlightDestinyUnit() and not MoonlightDestiny:isQuestUnlocked(2) then
		return true
	end
	
	return false
end

function var_0_0.isLockZodiacUpgrade5(arg_389_0)
	if arg_389_0:isMoonlightDestinyUnit() and not MoonlightDestiny:isQuestUnlocked(3) then
		return true
	end
	
	return false
end

function var_0_0.isLockArenaAndClan(arg_390_0)
	if arg_390_0:isMoonlightDestinyUnit() and not MoonlightDestiny:isQuestUnlocked(4) then
		return true
	end
	
	return false
end

function var_0_0.exclusive_noti(arg_391_0)
	if not arg_391_0:canEquip_Exclusive() then
		return 
	end
	
	return arg_391_0:canEquip_Exclusive() and arg_391_0:isExclusiveEquip_exist() and not arg_391_0:getEquipByIndex(8)
end

function var_0_0.canEquip_Exclusive(arg_392_0)
	local var_392_0 = GrowthBoost:isRegisteredUnit(arg_392_0)
	
	if var_392_0 and to_n(var_392_0.zodiac) >= 5 then
		return true
	end
	
	return arg_392_0:getZodiacGrade() >= 5
end

function var_0_0.isExclusiveEquip_exist(arg_393_0)
	return DB("equip_item", arg_393_0:getExclusiveEquip(), "id") ~= nil
end

function var_0_0.getExclusiveEquip(arg_394_0)
	return (DB("character_reference", arg_394_0.db.code, {
		"skillequip_check"
	}))
end

function var_0_0.isDoingClassChange(arg_395_0)
	local var_395_0 = Account:getClassChangeInfoByCode(arg_395_0.db.code)
	
	if not var_395_0 then
		return false
	end
	
	return var_395_0.reg_uid and var_395_0.reg_uid == arg_395_0:getUID() and var_395_0.state == 1
end

function var_0_0.isSpecialUnit(arg_396_0)
	return arg_396_0.db.type == "skillup" or arg_396_0.db.type == "xpup"
end

function var_0_0.isExpUnit(arg_397_0)
	return arg_397_0.db.type == "xpup"
end

function var_0_0.isRecallExpUnit(arg_398_0)
	return arg_398_0.db.type == "xpup" and arg_398_0.db.att_remark == "y"
end

function var_0_0.isOrdinaryUnit(arg_399_0)
	return arg_399_0.db.ordinary == "y"
end

function var_0_0.isFreeSaleUnit(arg_400_0)
	return arg_400_0:isActiveSellType("token_block")
end

function var_0_0.isSoulEnabled(arg_401_0, arg_401_1)
	return DB("skill", arg_401_1, "soulburn_skill") or arg_401_0:isSummon()
end

function var_0_0.isSkillEnabled(arg_402_0, arg_402_1)
	return not arg_402_0.inst.disabled_skill[arg_402_1]
end

function var_0_0.isGetInjured(arg_403_0)
	return arg_403_0:getHPRatio() < 0.3
end

function var_0_0.getRestEatingEndTime(arg_404_0, arg_404_1)
	arg_404_1 = arg_404_1 or os.time()
	
	if not arg_404_0.inst.eating_end_time and arg_404_0:getHPRatio() == 1 then
		return nil
	end
	
	return math.max(0, to_n(arg_404_0.inst.eating_end_time) - arg_404_1)
end

function var_0_0.isEating(arg_405_0)
	return arg_405_0:getHPRatio() < 1 or arg_405_0.inst.eating_end_time ~= nil
end

function var_0_0.doneEating(arg_406_0)
	arg_406_0.inst.start_hp_r = 1000
	arg_406_0.inst.eating_end_time = nil
	
	arg_406_0:reset()
end

function var_0_0.isMainUnit(arg_407_0)
	return Account:getMainUnitId() == arg_407_0:getUID()
end

function var_0_0.getZodiacReward(arg_408_0, arg_408_1)
end

function var_0_0.getZodiacGrade(arg_409_0, arg_409_1)
	return math.min(arg_409_0.inst.zodiac, 6)
end

function var_0_0.calcAwakeCoreNodeSkills(arg_410_0)
	local var_410_0 = arg_410_0:getAwakeSkill()
	
	if var_410_0 then
		for iter_410_0, iter_410_1 in pairs(var_410_0) do
			arg_410_0:setPassiveSkill(iter_410_1)
		end
	end
end

function var_0_0._updateZodiacSkills(arg_411_0, arg_411_1, arg_411_2)
	for iter_411_0 = 1, arg_411_1 do
		local var_411_0 = DB("zodiac_stone_2", arg_411_0.db.sphere_bonus_id .. "_" .. iter_411_0, "skill_up")
		
		if var_411_0 then
			local var_411_1, var_411_2 = var_0_1(DB("character", arg_411_0.inst.code, "skill" .. var_411_0))
			
			if var_411_2 then
				arg_411_0:mergeSkill(var_411_2 .. "u")
				
				if arg_411_2 then
					arg_411_0:mergeSkillCool(var_411_2 .. "u", var_411_2)
				end
			end
		end
	end
end

function var_0_0.updateZodiacSkills(arg_412_0, arg_412_1)
	arg_412_0.inst.keystone = 0
	
	local var_412_0 = arg_412_0:getZodiacGrade()
	
	arg_412_0:_updateZodiacSkills(var_412_0, arg_412_1)
end

function var_0_0.getSubTaskSkillPoint(arg_413_0, arg_413_1)
	arg_413_1 = arg_413_1 or SubTask:getCurrentSubTask()
	
	return SubTask:getEffectUnitPoint(arg_413_1, arg_413_0)
end

function var_0_0.getSubTaskSkillName(arg_414_0)
	local var_414_0 = DB("subtask_mission_skill", arg_414_0.db.subtask_mission_skill, {
		"name"
	})
	
	if var_414_0 then
		return "#" .. T(var_414_0)
	else
		return nil
	end
end

function var_0_0.getSubTaskSkillIcon(arg_415_0)
	return (DB("subtask_mission_skill", arg_415_0.db.subtask_mission_skill, {
		"icon"
	}))
end

function var_0_0.getSubTaskMissionSkill(arg_416_0)
	if not arg_416_0.db.subtask_mission_skill then
		return nil
	end
	
	return SubTask:getSubtaskSkillDB(arg_416_0.db.subtask_mission_skill)
end

function var_0_0.isDoingSubTask(arg_417_0)
	return arg_417_0.inst.subtask_end_time ~= nil
end

function var_0_0.getRestSubtaskEndTime(arg_418_0, arg_418_1)
	arg_418_1 = arg_418_1 or os.time()
	
	if not arg_418_0.inst.subtask_end_time then
		return nil
	end
	
	return math.max(0, arg_418_0.inst.subtask_end_time - arg_418_1)
end

function var_0_0.getSubtaskTotalTime(arg_419_0, arg_419_1, arg_419_2)
	arg_419_2 = arg_419_2 or os.time()
	
	if not arg_419_0.inst.subtask_end_time then
		return nil
	end
	
	arg_419_1 = arg_419_1 or SubTask:getCurrentSubTask()
	
	if not arg_419_1 then
		return nil
	end
	
	return SubTask:getSubtaskMissionDB(arg_419_1).time * 60
end

function var_0_0.getBattleTurnCount(arg_420_0)
	return to_n(arg_420_0.tmp_vars.battle_turn_count) or 0
end

function var_0_0.addBattleTurnCount(arg_421_0)
	arg_421_0.tmp_vars.battle_turn_count = to_n(arg_421_0.tmp_vars.battle_turn_count) + 1
end

function var_0_0.isReplaced(arg_422_0)
	return arg_422_0.tmp_vars.is_replaced
end

function var_0_0.setReplace(arg_423_0, arg_423_1)
	arg_423_0.tmp_vars.is_replaced = arg_423_1 == true
end

function var_0_0.isElite(arg_424_0)
	return arg_424_0.db.tier == "elite"
end

function var_0_0.isBoss(arg_425_0)
	return arg_425_0.db.tier == "boss"
end

function var_0_0.reserveResurrection(arg_426_0, arg_426_1, arg_426_2)
	arg_426_2 = arg_426_2 or {}
	arg_426_0.inst.resurrect_hp_ratio = arg_426_1
	
	if not arg_426_0.inst.resurrect_cs then
		arg_426_0.inst.resurrect_cs = {}
	end
	
	if arg_426_2.cs then
		for iter_426_0, iter_426_1 in pairs(arg_426_2.cs or {}) do
			local var_426_0, var_426_1, var_426_2 = DB("cs", iter_426_1, {
				"name",
				"cs_type",
				"cs_turn"
			})
			
			table.insert(arg_426_0.inst.resurrect_cs, {
				cs_id = iter_426_1,
				cs_type = var_426_1,
				cs_turn = var_426_2
			})
		end
	end
end

function var_0_0.setReserveResurrectBlock(arg_427_0)
	if arg_427_0.states:isExistEffect("CSP_IMMUNE_REVIVE_BLOCK") then
		return 
	end
	
	arg_427_0.turn_vars.resurrect_block = true
end

function var_0_0.getReserveResurrectBlock(arg_428_0)
	return (arg_428_0.turn_vars or {}).resurrect_block
end

function var_0_0.clearReserveResurrectBlock(arg_429_0)
	(arg_429_0.turn_vars or {}).resurrect_block = nil
end

function var_0_0.setResurrectBlock(arg_430_0, arg_430_1)
	if arg_430_0.states:isExistEffect("CSP_IMMUNE_REVIVE_BLOCK") then
		return arg_430_1
	end
	
	local var_430_0 = arg_430_1 or {}
	
	arg_430_0.inst.resurrect_block = true
	
	table.insert(var_430_0, {
		text = "stic_reviveblock_skeffnm",
		type = "text",
		target = arg_430_0
	})
	
	return var_430_0
end

function var_0_0.getResurrectBlock(arg_431_0, arg_431_1)
	if arg_431_0.states:isExistEffect("CSP_IMMUNE_REVIVE_BLOCK") then
		return false
	end
	
	return arg_431_0:getReserveResurrectBlock() or arg_431_0.inst.resurrect_block or arg_431_0.inst.code == "cleardummy" or not arg_431_1 and arg_431_0.states:findByEff("REVIVE_FORBID")
end

function var_0_0.checkResurrectBlockEffect(arg_432_0)
	local var_432_0 = arg_432_0:getResurrectBlock()
	
	if var_432_0 and var_432_0 == arg_432_0.states:findByEff("REVIVE_FORBID") then
		return false
	end
	
	return var_432_0
end

function var_0_0.isResurrectionReserved(arg_433_0)
	if arg_433_0:getResurrectBlock() then
		return false
	end
	
	return arg_433_0.inst.resurrect_hp_ratio ~= nil
end

function var_0_0.resurrect(arg_434_0, arg_434_1, arg_434_2)
	if arg_434_0:getResurrectBlock() then
		arg_434_0.inst.resurrect_hp_ratio = nil
		
		return false
	end
	
	local var_434_0 = {}
	
	arg_434_0.states:clear({
		ignore_passives = true,
		revive_hold = true,
		except_eff = var_434_0,
		logs = arg_434_2
	})
	arg_434_0.logic:updateRtaPenalty({
		arg_434_0
	})
	
	local var_434_1 = arg_434_0.inst.resurrect_hp_ratio
	
	arg_434_0.inst.dead = nil
	arg_434_0.inst.resurrect_hp_ratio = nil
	arg_434_0.inst.resurrect = true
	arg_434_1 = arg_434_1 or to_n(var_434_1)
	
	arg_434_0:calc()
	
	if arg_434_1 > 0 then
		arg_434_0.inst.hp = math.floor(arg_434_0:getMaxHP() * arg_434_1)
	else
		arg_434_0.inst.hp = 1
	end
	
	for iter_434_0, iter_434_1 in pairs(arg_434_0.logic.units) do
		if not iter_434_1:isDead() then
			local var_434_2 = iter_434_1.states:onResurrectNotify(arg_434_0)
			
			table.join(arg_434_2, var_434_2)
		end
	end
end

function var_0_0.afterResurrect(arg_435_0, arg_435_1)
	if not arg_435_0.inst.resurrect_cs then
		arg_435_0.inst.resurrect_cs = {}
	end
	
	for iter_435_0, iter_435_1 in pairs(arg_435_0.inst.resurrect_cs or {}) do
		local var_435_0, var_435_1 = arg_435_0:addState(iter_435_1.cs_id, 1, arg_435_0, {
			turn = iter_435_1.cs_turn
		})
		
		if var_435_0 then
		end
	end
	
	arg_435_0.states:onAfterResurrect(arg_435_1)
	
	arg_435_0.inst.resurrect_cs = nil
end

function var_0_0.isPassiveBlock(arg_436_0)
	return arg_436_0.states:findByEff("CSP_PASSIVEBLOCK")
end

function var_0_0.setSkillDamageTag(arg_437_0, arg_437_1)
	if arg_437_0.turn_vars.damage_tags[arg_437_1.attacker] and not arg_437_0.turn_vars.first_damage_tags[arg_437_1.attacker] then
		arg_437_0.turn_vars.first_damage_tags[arg_437_1.attacker] = arg_437_0.turn_vars.damage_tags[arg_437_1.attacker]
	end
	
	arg_437_0.turn_vars.damage_tags[arg_437_1.attacker] = arg_437_1
	
	return arg_437_1
end

function var_0_0.skillDamageTag(arg_438_0, arg_438_1)
	return arg_438_0.turn_vars.damage_tags[arg_438_1]
end

function var_0_0.firstSkillDamageTag(arg_439_0, arg_439_1)
	return arg_439_0.turn_vars.first_damage_tags[arg_439_1]
end

function var_0_0.getTargetAccumDamage(arg_440_0, arg_440_1)
	local var_440_0 = 0
	
	local function var_440_1(arg_441_0)
		var_440_0 = var_440_0 + (arg_440_0.turn_vars.accum_damage[arg_441_0] or 0)
	end
	
	if type(arg_440_1) == "table" then
		for iter_440_0, iter_440_1 in pairs(arg_440_1) do
			local var_440_2 = tonumber(iter_440_1)
			
			if var_440_2 then
				var_440_1(var_440_2)
			end
		end
	else
		local var_440_3 = tonumber(arg_440_1)
		
		if var_440_3 then
			var_440_1(var_440_3)
		end
	end
	
	return var_440_0
end

function var_0_0.setAccumDamage(arg_442_0, arg_442_1, arg_442_2)
	if not arg_442_0.turn_vars.accum_damage then
		arg_442_0.turn_vars.accum_damage = {}
	end
	
	local var_442_0 = tonumber(arg_442_1)
	
	if var_442_0 then
		arg_442_0.turn_vars.accum_damage[var_442_0] = (arg_442_0.turn_vars.accum_damage[var_442_0] or 0) + arg_442_2
	end
end

function var_0_0.isDamageFinished(arg_443_0)
	if not arg_443_0.turn_vars or not arg_443_0.turn_vars.damage_tags then
		return true
	end
	
	for iter_443_0, iter_443_1 in pairs(arg_443_0.turn_vars.damage_tags) do
		if iter_443_1.cur_hit < iter_443_1.tot_hit then
			return false
		end
	end
	
	return true
end

function var_0_0.setFriendNPC(arg_444_0, arg_444_1)
	arg_444_0.inst.is_friend_npc = arg_444_1
end

function var_0_0.isFriendNPC(arg_445_0)
	return arg_445_0.inst.is_friend_npc == true
end

function var_0_0.setFriendSelect(arg_446_0, arg_446_1)
	arg_446_0.inst.is_friend_selected = arg_446_1
	
	return arg_446_0.inst.is_friend_selected
end

function var_0_0.isFriendSelected(arg_447_0)
	return arg_447_0.inst.is_friend_selected == true
end

function var_0_0.autoHeal(arg_448_0, arg_448_1)
	local var_448_0 = GAME_STATIC_VARIABLE.auto_hp_heal
	local var_448_1 = GAME_STATIC_VARIABLE.auto_mp_heal
	
	if arg_448_0:getHPRatio() == 0 then
		var_448_0 = GAME_STATIC_VARIABLE.auto_hp_heal_sick
		var_448_1 = GAME_STATIC_VARIABLE.auto_mp_heal_sick
	end
	
	if arg_448_0.inst.hp ~= arg_448_0.status.max_hp then
		local var_448_2, var_448_3 = arg_448_0:perHeal(var_448_0, nil, true)
		
		table.insert(arg_448_1, {
			from = "logic",
			type = "heal",
			target = arg_448_0,
			heal = var_448_2
		})
	end
	
	if arg_448_0:getSPName() == "mp" and arg_448_0.inst.mp ~= GAME_STATIC_VARIABLE.mana_max then
		local var_448_4 = math.min(math.floor(var_448_1 * GAME_STATIC_VARIABLE.mana_max), GAME_STATIC_VARIABLE.mana_max - arg_448_0.inst.mp)
		
		arg_448_0.inst.mp = arg_448_0.inst.mp + var_448_4
		
		table.insert(arg_448_1, {
			type = "sp_heal",
			from = arg_448_0,
			target = arg_448_0,
			sp_heal = var_448_4
		})
	end
end

function var_0_0.setSupporter(arg_449_0, arg_449_1)
	arg_449_0.inst.supporter = arg_449_1
end

function var_0_0.isSupporter(arg_450_0)
	return arg_450_0.inst.supporter
end

function var_0_0.summary(arg_451_0)
	return arg_451_0.db.name .. "  dead:" .. tostring(arg_451_0.inst.dead) .. "  hp:(" .. arg_451_0.inst.hp .. "/" .. arg_451_0.status.max_hp .. ")" .. "  speed:" .. arg_451_0.status.speed .. "  tm:" .. arg_451_0.inst.elapsed_ut
end

function var_0_0.addToTeam(arg_452_0, arg_452_1)
	if Account:isInTeamRange(arg_452_1) then
		arg_452_0.inst.team_idx = arg_452_1
	end
end

function var_0_0.removeFromTeam(arg_453_0, arg_453_1)
	if Account:isInTeamRange(arg_453_1) then
		for iter_453_0, iter_453_1 in pairs(Account:getReservedTeamSlot({
			exclude_svrteam = true
		})) do
			if arg_453_1 ~= iter_453_1 and Account and Account:isInTeam(arg_453_0, iter_453_1) then
				arg_453_0.inst.team_idx = iter_453_1
				
				return 
			end
		end
	end
	
	arg_453_0.inst.team_idx = nil
end

function var_0_0.isInNormalTeam(arg_454_0)
	return arg_454_0.inst.team_idx ~= nil and Account:isInTeamRange(to_n(arg_454_0.inst.team_idx))
end

function var_0_0.isInTeam(arg_455_0)
	return arg_455_0.inst.team_idx ~= nil
end

function var_0_0.getPreCoolSkillId(arg_456_0)
	return arg_456_0.inst.monster_skill
end

function var_0_0.getPreCoolSkillTime(arg_457_0)
	if not arg_457_0.inst.monster_skill then
		return 
	end
	
	return arg_457_0:getSkillCoolData()[arg_457_0.inst.monster_skill], arg_457_0.inst.monster_skill_cool
end

function var_0_0.isStoryPlayable(arg_458_0)
	if not arg_458_0:check_relationUI() then
		return false
	end
	
	return UnitStory:getPlayableStoryCount(arg_458_0) > 0
end

function var_0_0.getSkillMaxCool(arg_459_0, arg_459_1)
	if arg_459_0:getSkillDB(arg_459_1, "sk_passive") then
		return arg_459_0.states:getPassiveSkillMaxCool(arg_459_1)
	end
	
	arg_459_1 = arg_459_0:getSkillIdForSkillTurn(arg_459_1)
	
	local var_459_0, var_459_1 = arg_459_0:getSkillDB(arg_459_1, {
		"pre_cool",
		"turn_cool"
	})
	
	return to_n(var_459_1)
end

function var_0_0.getSkillCool(arg_460_0, arg_460_1)
	if arg_460_0:getSkillDB(arg_460_1, "sk_passive") then
		return arg_460_0.states:getPassiveSkillCool(arg_460_1)
	end
	
	arg_460_1 = arg_460_0:getSkillIdForSkillTurn(arg_460_1)
	
	return arg_460_0:getSkillCoolData()[arg_460_1]
end

function var_0_0.setSkillCool(arg_461_0, arg_461_1, arg_461_2)
	if arg_461_0:getSkillDB(arg_461_1, "sk_passive") then
		return arg_461_0.states:setPassiveSkillCool(arg_461_1, arg_461_2)
	end
	
	arg_461_1 = arg_461_0:getSkillIdForSkillTurn(arg_461_1)
	arg_461_0:getSkillCoolData()[arg_461_1] = arg_461_2
end

function var_0_0.getRuneDBKey(arg_462_0)
	local var_462_0 = arg_462_0:getBaseGrade()
	
	return arg_462_0.db.color .. var_462_0 .. "_" .. arg_462_0.db.zodiac
end

function var_0_0.isCanBeMaterial(arg_463_0, arg_463_1, arg_463_2, arg_463_3)
	if arg_463_3[arg_463_0.inst.uid] then
		return false
	end
	
	if arg_463_0:isLimitedUnit() and not arg_463_0:isSameGroup(arg_463_1) and arg_463_2 ~= "Sell" then
		return false
	elseif arg_463_0:isForceLockCharacter() and arg_463_2 == "Sell" then
		if not arg_463_0:checkForceLockUnitCanSell() then
			return false
		end
	elseif arg_463_0:isForceLockCharacter() and (not arg_463_1 or arg_463_1.db.code ~= arg_463_0.db.code) then
		return false
	end
	
	if arg_463_0:isLocked() then
		return false
	end
	
	if arg_463_0:isDoingSubTask() then
		return false
	end
	
	if arg_463_0:isDoingClassChange() then
		return false
	end
	
	if arg_463_0:isMainUnit() then
		return false
	end
	
	if arg_463_0:isGrowthBoostRegistered() then
		return false
	end
	
	if Account:isIn_worldbossSupporterTeam(arg_463_0.inst.uid) then
		return false
	end
	
	if Account:isLotaRegistrationUnit(arg_463_0.inst.uid) then
		return false
	end
	
	if BackPlayManager:isInBackPlayTeam(arg_463_0.inst.uid) then
		return false
	end
	
	return true
end

local function var_0_10(arg_464_0)
	local var_464_0 = 0
	local var_464_1 = Account:getUnitsByVariationGroupCode(arg_464_0)
	
	for iter_464_0, iter_464_1 in pairs(var_464_1) do
		if iter_464_1 and iter_464_1:isMaxDevoteLevel() then
			var_464_0 = var_464_0 + 1
		end
	end
	
	return var_464_0
end

function var_0_0.getSellTypeTbl(arg_465_0)
	if arg_465_0.db.sell_type_tbl then
		return table.clone(arg_465_0.db.sell_type_tbl)
	end
	
	local var_465_0 = DB("character", arg_465_0.db.code, "sell_type")
	
	if not var_465_0 or var_465_0 == "" then
		var_465_0 = "normal"
	end
	
	local var_465_1 = DBT("character_sell_type", var_465_0, {
		"id",
		"remove_block",
		"devotion_sell_release",
		"devotion_block",
		"token_block"
	})
	
	if not var_465_1 or table.empty(var_465_1) then
		error("It can't be sell, but try sell it. CHECK DB CODE/SELL_TYPE : " .. tostring(arg_465_0.db.code) .. "/" .. tostring(var_465_0) .. "/CHK.")
		
		return nil
	end
	
	if not arg_465_0.db.sell_type_tbl then
		arg_465_0.db.sell_type_tbl = var_465_1
	end
	
	return var_465_1
end

function var_0_0.isActiveSellType(arg_466_0, arg_466_1)
	local var_466_0 = arg_466_0:getSellTypeTbl()
	
	if not var_466_0 then
		return false
	end
	
	return var_466_0[arg_466_1] == "y"
end

function var_0_0.checkForceLockUnitCanSell(arg_467_0)
	if not UnitSell:isValid() then
		return false
	end
	
	if not arg_467_0:isActiveSellType("devotion_sell_release") then
		return false
	end
	
	local var_467_0 = var_0_10(arg_467_0.db.variation_group)
	local var_467_1 = var_467_0 > 0
	
	if var_467_1 and arg_467_0:isMaxDevoteLevel() then
		if var_467_0 > 1 then
			local var_467_2 = UnitSell:getItemList()
			local var_467_3 = 0
			
			for iter_467_0, iter_467_1 in pairs(var_467_2) do
				if iter_467_1.db.code == arg_467_0.db.code and iter_467_1:isMaxDevoteLevel() and iter_467_1.inst.uid ~= arg_467_0.inst.uid then
					var_467_3 = var_467_3 + 1
				end
			end
			
			return var_467_0 - var_467_3 > 1
		else
			return false
		end
	end
	
	return var_467_1
end

function var_0_0.checkDevotionUnitCanSell(arg_468_0)
	if not UnitSell:isValid() then
		return false
	end
	
	if not DB("character", arg_468_0.db.variation_group, "id") then
		return false
	end
	
	return var_0_10(arg_468_0.db.variation_group) ~= 0
end

function var_0_0.isSellableDevotionUnit(arg_469_0)
	return var_0_10(arg_469_0.db.variation_group) ~= 0
end

function var_0_0.getUsableCodeList(arg_470_0, arg_470_1, arg_470_2)
	local var_470_0 = {}
	
	if arg_470_2 ~= "Storage" and arg_470_0:isLocked() then
		table.push(var_470_0, "lock")
	end
	
	if arg_470_0:isDoingSubTask() then
		table.push(var_470_0, "subtask")
	end
	
	if arg_470_0:isDoingClassChange() then
		table.push(var_470_0, "class_change")
	end
	
	if arg_470_0:isLimitedUnit() and not arg_470_0:isSameGroup(arg_470_1) and arg_470_2 ~= "Sell" and arg_470_2 ~= "Storage" and arg_470_2 ~= "growth_boost" then
		table.push(var_470_0, "force_lock")
	elseif arg_470_0:isForceLockCharacter() and arg_470_2 == "Sell" then
		if not arg_470_0:checkForceLockUnitCanSell() then
			table.push(var_470_0, "force_lock")
		end
	elseif arg_470_0:isDevotionUnit() and arg_470_2 == "Sell" then
		if not arg_470_0:checkDevotionUnitCanSell() then
			table.push(var_470_0, "devotion")
		end
	elseif arg_470_0:isForceLockCharacter() and arg_470_2 ~= "Storage" and arg_470_2 ~= "growth_boost" and (not arg_470_1 or arg_470_1.db.code ~= arg_470_0.db.code) and arg_470_2 ~= "AttributeChange" then
		table.push(var_470_0, "force_lock")
	end
	
	if arg_470_2 == "Storage" then
		if arg_470_0:isEating() then
			table.push(var_470_0, "heal")
		end
		
		if arg_470_0:isDevotionUnit() then
			table.push(var_470_0, "devotion")
		end
	end
	
	if arg_470_2 == "growth_boost_except" and arg_470_0:isGrowthBoostRegistered() then
		return {
			"growth_boost"
		}
	end
	
	if arg_470_2 ~= "growth_boost" and arg_470_0:isGrowthBoostRegistered() then
		table.push(var_470_0, "growth_boost")
	end
	
	local var_470_1 = Account:getPublicReservedTeamSlot()
	
	for iter_470_0, iter_470_1 in pairs(var_470_1) do
		local var_470_2 = Account:isInTeam(arg_470_0, iter_470_1)
		
		if var_470_2 then
			table.push(var_470_0, "team_" .. var_470_2)
		end
	end
	
	local var_470_3 = {
		11,
		12,
		20,
		29
	}
	
	for iter_470_2, iter_470_3 in pairs(var_470_3) do
		local var_470_4 = Account:isInTeam(arg_470_0, iter_470_3)
		
		if var_470_4 then
			table.push(var_470_0, "team_" .. var_470_4)
		end
	end
	
	for iter_470_4 = 13, 16 do
		if Account:isInTeam(arg_470_0, iter_470_4) then
			table.push(var_470_0, "clan_war")
		end
	end
	
	for iter_470_5 = 17, 19 do
		local var_470_5 = Account:isInTeam(arg_470_0, iter_470_5)
		
		if var_470_5 then
			table.push(var_470_0, "coop_" .. Account:getCoopTeamIdx(var_470_5))
		end
	end
	
	for iter_470_6 = 21, 22 do
		local var_470_6 = Account:isInTeam(arg_470_0, iter_470_6)
		
		if var_470_6 then
			table.push(var_470_0, "coop_" .. Account:getCoopTeamIdx(var_470_6))
		end
	end
	
	for iter_470_7 = 23, 25 do
		if Account:isInTeam(arg_470_0, iter_470_7) then
			table.push(var_470_0, "descent")
		end
	end
	
	for iter_470_8 = 27, 28 do
		if Account:isInTeam(arg_470_0, iter_470_8) and not table.isInclude(var_470_0, "burning") then
			table.push(var_470_0, "burning")
		end
	end
	
	if Account:isIn_worldbossSupporterTeam(arg_470_0.inst.uid) then
		table.push(var_470_0, "worldboss")
	end
	
	if Account:isLotaRegistrationUnit(arg_470_0.inst.uid) then
		table.push(var_470_0, "lota")
	end
	
	if arg_470_0:isMainUnit() then
		table.push(var_470_0, "leader")
	end
	
	if BackPlayManager:isInBackPlayTeam(arg_470_0.inst.uid) then
		table.push(var_470_0, "bg_battle")
	end
	
	if #var_470_0 == 0 then
		return nil
	end
	
	return var_470_0
end

function var_0_0.isForceLockCharacter(arg_471_0)
	return arg_471_0:isActiveSellType("remove_block")
end

function var_0_0.calcDevoteStat(arg_472_0)
	local var_472_0 = arg_472_0:getDevoteBonus()
	
	arg_472_0:applyStat(var_472_0)
end

function var_0_0.calcDevoteStatus(arg_473_0, arg_473_1)
	local var_473_0 = arg_473_0:getDevoteBonus(nil, arg_473_1)
	
	arg_473_0:applyStatus(var_473_0)
	arg_473_0:applyBooster(var_473_0)
end

function var_0_0.calcDevoteSkill(arg_474_0)
	local var_474_0 = arg_474_0:getDevoteBonus(true)
	
	for iter_474_0, iter_474_1 in pairs(var_474_0) do
		arg_474_0:setPassiveSkill(iter_474_1)
	end
end

function var_0_0.getDevoteBonus(arg_475_0, arg_475_1, arg_475_2)
	local var_475_0 = {}
	
	if not arg_475_0.team or not arg_475_0.team.getDevoteStats then
		local var_475_1 = {}
		local var_475_2 = {}
		
		Team:getUnitDevoteStats(arg_475_0, var_475_1)
		
		for iter_475_0, iter_475_1 in pairs(var_475_1 or {}) do
			for iter_475_2, iter_475_3 in pairs(iter_475_1) do
				if iter_475_3.self_effect and arg_475_0.inst.uid == iter_475_3.uid then
					table.insert(var_475_2, {
						iter_475_3.type,
						iter_475_3.stat
					})
				end
			end
		end
		
		return var_475_2
	end
	
	local var_475_3 = arg_475_0.team:getDevoteStats()
	
	for iter_475_4, iter_475_5 in pairs(arg_475_0.team.units) do
		if iter_475_5.inst.uid == arg_475_0.inst.uid then
			local var_475_4 = arg_475_0.inst.pos or 0
			
			for iter_475_6, iter_475_7 in pairs(var_475_3[tostring(var_475_4)] or {}) do
				if arg_475_0.inst.uid ~= iter_475_7.uid or not arg_475_2 and iter_475_7.self_effect and arg_475_0.inst.uid == iter_475_7.uid then
					table.insert(var_475_0, {
						iter_475_7.type,
						iter_475_7.stat
					})
				end
			end
			
			break
		end
	end
	
	return var_475_0
end

function var_0_0.getCounterSkillId(arg_476_0)
	if arg_476_0.turn_vars.counter_attack_skill_idx then
		return arg_476_0:getSkillBundle():slot(arg_476_0.turn_vars.counter_attack_skill_idx):getSkillId()
	end
	
	local var_476_0 = DB("character", arg_476_0.inst.code, "counterskill")
	
	if var_476_0 then
		return SkillFactory.create(var_476_0, arg_476_0):getSkillId()
	end
	
	return arg_476_0:getSkillBundle():selectAvailable():slot(1):getSkillId()
end

function var_0_0.getCoopSkillId(arg_477_0)
	local var_477_0 = DB("character", arg_477_0.inst.code, "coopskill")
	
	if var_477_0 then
		return SkillFactory.create(var_477_0, arg_477_0):getSkillId()
	end
	
	local var_477_1
	
	if arg_477_0:isTransformed() then
		var_477_1 = arg_477_0.transform_vars.skill_bundle
	else
		var_477_1 = arg_477_0.skill_bundle
	end
	
	return var_477_1:slot(1):getSkillId()
end

function var_0_0.onAddUnit(arg_478_0, arg_478_1, arg_478_2)
	return arg_478_0.states:onAddUnit(arg_478_1, arg_478_2)
end

function var_0_0.modifyElapsedTime(arg_479_0, arg_479_1, arg_479_2, arg_479_3)
	if arg_479_2 < 0 and arg_479_0.states:findByEff("CSP_IMMUNE_AB_DOWN") then
		table.insert(arg_479_1, {
			type = "resist_time",
			from = arg_479_3,
			target = arg_479_0
		})
		
		return 
	end
	
	if arg_479_2 > 0 and arg_479_0.states:findByEff("CSP_IMMUNE_AB_UP") then
		table.insert(arg_479_1, {
			type = "immune_ab_up",
			from = arg_479_3,
			target = arg_479_0
		})
		
		return 
	end
	
	local var_479_0 = 0
	
	if arg_479_2 > 0 then
		var_479_0 = arg_479_0:getActionBarUpRate()
	elseif arg_479_2 < 0 then
		var_479_0 = arg_479_0:getActionBarDownRate()
	else
		return 
	end
	
	if arg_479_0.states:findByEff("CSP_IMMUNE_AB_MODIFY") then
		return 
	end
	
	local var_479_1 = arg_479_2 + arg_479_2 * var_479_0
	
	arg_479_0.inst.elapsed_ut = arg_479_0.inst.elapsed_ut + var_479_1
	arg_479_0.inst.elapsed_ut = math.max(arg_479_0.inst.elapsed_ut, 0)
	
	table.insert(arg_479_1, {
		type = "add_tick",
		from = arg_479_3,
		target = arg_479_0,
		tick = arg_479_2
	})
	
	return true
end

function var_0_0.modifySkillCool(arg_480_0, arg_480_1, arg_480_2, arg_480_3, arg_480_4, arg_480_5, arg_480_6)
	if arg_480_3 > 0 and arg_480_0.states:findByEff("CSP_IMMUNE_CD_DOWN") and not arg_480_6 then
		table.insert(arg_480_1, {
			type = "resist_cool",
			from = arg_480_4,
			target = arg_480_0
		})
		
		return 
	end
	
	local var_480_0
	local var_480_1
	
	for iter_480_0, iter_480_1 in ipairs(arg_480_0:getSkillBundle():toSkills()) do
		if iter_480_1:assigned() and (arg_480_2 == nil or iter_480_0 == arg_480_2) then
			local var_480_2 = false
			
			if not arg_480_2 and not arg_480_6 then
				local var_480_3 = {}
				
				if arg_480_3 > 0 then
					var_480_3 = arg_480_0.states:findAllEffValues("CSP_CDUPIMMUNE")
				else
					var_480_3 = arg_480_0.states:findAllEffValues("CSP_CDDOWNIMMUNE")
				end
				
				if table.find(var_480_3, iter_480_0) then
					var_480_2 = true
				end
			end
			
			if not var_480_2 then
				local var_480_4 = iter_480_1:getOriginSkillId()
				local var_480_5 = to_n(arg_480_0:getSkillCoolData()[var_480_4])
				local var_480_6 = iter_480_1:getTurnCool()
				local var_480_7 = math.clamp(var_480_5 + arg_480_3, 0, to_n(var_480_6))
				
				if var_480_5 ~= var_480_7 then
					local var_480_8 = var_480_7 - var_480_5
					
					if not var_480_1 or math.abs(var_480_1) < math.abs(var_480_8) then
						var_480_1 = var_480_8
						var_480_0 = var_480_4
					end
				end
				
				arg_480_0:setSkillCool(var_480_4, var_480_7)
				Log.d("skill_eff=1502", arg_480_0.db.name, var_480_4, var_480_5, arg_480_3, var_480_7, var_480_6)
			end
		end
	end
	
	if var_480_1 then
		table.insert(arg_480_1, {
			type = "add_skill_cool",
			target = arg_480_0,
			skill_id = var_480_0,
			inc_turn = var_480_1,
			state = arg_480_5
		})
	end
	
	return var_480_1
end

function var_0_0.check_relationUI(arg_481_0)
	local var_481_0 = "re_" .. arg_481_0.db.code .. "_1"
	
	return (DB("character_relationship_ui", var_481_0, {
		"relation_ui"
	}))
end

function var_0_0.checkStory(arg_482_0)
	return arg_482_0:check_relationUI() ~= nil and not arg_482_0:isSpecialUnit() and not arg_482_0:isPromotionUnit() and arg_482_0.db.role ~= "material"
end

function var_0_0.checkZodiac(arg_483_0)
	return arg_483_0.db.zodiac ~= nil and not arg_483_0:isSpecialUnit() and not arg_483_0:isPromotionUnit() and arg_483_0.db.role ~= "material"
end

function var_0_0.checkUpgrade(arg_484_0)
	if DEBUG.OLD_PROMOTION_RULE then
		if arg_484_0:isPromotionUnit() then
			return arg_484_0:isMaxLevel() and arg_484_0:getGrade() == arg_484_0:getBaseGrade()
		end
		
		if arg_484_0:isSpecialUnit() or arg_484_0:isPromotionUnit() or arg_484_0.db.role == "material" then
			return false
		end
	end
	
	if arg_484_0:isDevotionUnit() then
		return false
	end
	
	if arg_484_0:isSpecialUnit() then
		return false
	end
	
	if arg_484_0:getGrade() < 6 or arg_484_0:getLv() < 60 then
		return true
	end
	
	return not arg_484_0:isMaxDevoteLevel()
end

function var_0_0.isMaxDevoteLevel(arg_485_0, arg_485_1)
	return arg_485_0:getDevoteGrade(arg_485_0:getDevote() + to_n(arg_485_1)) == "SSS"
end

function var_0_0.isSkinViewable(arg_486_0)
	local var_486_0 = 0
	local var_486_2
	
	if arg_486_0.db.skin_group then
		local var_486_1 = {}
		
		for iter_486_0 = 1, GAME_STATIC_VARIABLE.max_skin_count or 3 do
			table.insert(var_486_1, string.format("skin%02d", iter_486_0))
		end
		
		var_486_2 = DBT("character_skin", arg_486_0.db.skin_group, var_486_1) or {}
		
		for iter_486_1 = 1, GAME_STATIC_VARIABLE.max_skin_count or 3 do
			local var_486_3 = var_486_2[string.format("skin%02d", iter_486_1)]
			
			if var_486_3 and Account:isPublishedSkin(var_486_3) then
				var_486_0 = var_486_0 + 1
			end
		end
	end
	
	return var_486_0 > 0
end

function var_0_0.isBlockedUpdateEating(arg_487_0)
	return arg_487_0.tmp_vars.eating_dirty
end

function var_0_0.setBlockUpdateEating(arg_488_0, arg_488_1)
	arg_488_0.tmp_vars.eating_dirty = arg_488_1
end

function var_0_0.updateHPInfo(arg_489_0, arg_489_1)
	arg_489_0.inst.start_hp_r = arg_489_1.h or 1000
	arg_489_0.inst.eating_end_time = nil
	
	arg_489_0:setBlockUpdateEating(nil)
	
	if arg_489_1.cat then
		arg_489_0.inst.eating_end_time = arg_489_1.cat
	end
end

function var_0_0.isImmuneEff(arg_490_0, arg_490_1)
	return arg_490_0.states:isImmuneEff(arg_490_1)
end

function var_0_0.isBlock_Eff(arg_491_0, arg_491_1)
	return arg_491_0.states:isBlock_Eff(arg_491_1)
end

function var_0_0.isMaxHP(arg_492_0)
	return arg_492_0.inst.hp == arg_492_0.status.max_hp
end

function var_0_0.setSTreeInfos(arg_493_0, arg_493_1)
	arg_493_0.inst.stree = arg_493_1
end

function var_0_0.getSTreeInfos(arg_494_0)
	return arg_494_0.inst.stree
end

function var_0_0.setSTreeLevel(arg_495_0, arg_495_1, arg_495_2)
	arg_495_1 = tonumber(arg_495_1)
	
	if not arg_495_1 then
		return 
	end
	
	for iter_495_0, iter_495_1 in pairs(arg_495_0.inst.stree or {}) do
		if iter_495_0 == arg_495_1 then
			arg_495_0.inst.stree[iter_495_0] = arg_495_2
		end
	end
end

function var_0_0.getSTreeLevel(arg_496_0, arg_496_1)
	arg_496_1 = tonumber(arg_496_1)
	
	if not arg_496_1 then
		return 0
	end
	
	return (arg_496_0.inst.stree or {})[arg_496_1] or 0
end

function var_0_0.getSTreeTotalPoint(arg_497_0)
	local var_497_0 = 0
	
	for iter_497_0, iter_497_1 in pairs(arg_497_0.inst.stree or {}) do
		var_497_0 = var_497_0 + iter_497_1
	end
	
	return var_497_0
end

function var_0_0.encodeEquip(arg_498_0)
	local var_498_0 = {}
	
	for iter_498_0, iter_498_1 in pairs(arg_498_0.equips) do
		local var_498_1 = iter_498_1.db.type
		local var_498_2 = ""
		
		for iter_498_2, iter_498_3 in pairs(iter_498_1.op) do
			local var_498_3 = iter_498_3[1]
			local var_498_4 = iter_498_3[2]
			local var_498_5 = string.format("%s:%s", var_498_3, var_498_4)
			
			var_498_2 = var_498_2 .. var_498_5
		end
		
		local var_498_6 = string.format(";g:%s;c:%s", iter_498_1.grade, iter_498_1.code)
		local var_498_7 = var_498_2 .. var_498_6
		
		var_498_0[string.sub(var_498_1, 1, 3)] = var_498_7
	end
	
	local var_498_8 = ""
	
	for iter_498_4, iter_498_5 in pairs({
		"wea",
		"hel",
		"arm",
		"nec",
		"rin",
		"boo",
		"art",
		"exc"
	}) do
		var_498_8 = var_498_8 .. (var_498_0[iter_498_5] or "x")
	end
	
	return (string_tomd5(var_498_8))
end

function var_0_0.getFaceIDForCamp(arg_499_0)
	return arg_499_0.db.face_id_camp or arg_499_0.db.face_id
end

function var_0_0.getEmotion_id(arg_500_0)
	local var_500_0 = arg_500_0.db.code
	
	if arg_500_0.inst.skin_code ~= nil and arg_500_0.inst.skin_code ~= "" then
		var_500_0 = arg_500_0.inst.skin_code
	end
	
	return DB("character", var_500_0, "emotion_id")
end

function var_0_0.getFaceID(arg_501_0)
	local var_501_0 = arg_501_0:getUnitOptionValue("face_num")
	
	if not var_501_0 or var_501_0 < 0 or var_501_0 > 10 then
		return 
	end
	
	local var_501_1 = var_501_0 + 1
	local var_501_2 = arg_501_0:getEmotion_id()
	
	if not var_501_2 then
		return 
	end
	
	for iter_501_0 = 1, 10 do
		local var_501_3, var_501_4 = DB("character_intimacy_level", var_501_2 .. "_" .. iter_501_0, {
			"intimacy_level",
			"emotion"
		})
		
		if var_501_3 and var_501_3 == var_501_1 then
			return var_501_4
		end
	end
end

function var_0_0.updateUnitOptionValue(arg_502_0, arg_502_1)
	arg_502_0.inst.unit_option = to_n(arg_502_1)
end

function var_0_0.setUnitOptionValue(arg_503_0, arg_503_1, arg_503_2)
	local var_503_0 = arg_503_0:getUnitOptionIndex(arg_503_1)
	local var_503_1 = string.format("%010d", to_n(arg_503_0.inst.unit_option))
	local var_503_2 = string.sub(var_503_1, 0, var_503_0 - 1)
	local var_503_3 = string.sub(var_503_1, var_503_0 + 1)
	
	arg_503_0.inst.unit_option = to_n(string.format("%s%s%s", var_503_2, to_n(arg_503_2), var_503_3))
end

function var_0_0.getUnitOptionIndex(arg_504_0, arg_504_1)
	local var_504_0 = 0
	
	if arg_504_1 == "stigma_skill_enhance" then
		var_504_0 = 10
	elseif arg_504_1 == "imprint_focus" then
		var_504_0 = 9
	elseif arg_504_1 == "face_num" then
		var_504_0 = 8
	elseif arg_504_1 == "used_skill_point" then
		var_504_0 = 7
	elseif arg_504_1 == "favorite_unit" then
		var_504_0 = 6
	end
	
	return var_504_0
end

function var_0_0.getUnitOptionValue(arg_505_0, arg_505_1)
	local var_505_0 = arg_505_0:getUnitOptionIndex(arg_505_1)
	
	if var_505_0 > 0 then
		return to_n(string.sub(string.format("%010d", to_n(arg_505_0.inst.unit_option)), var_505_0, var_505_0))
	end
	
	return nil
end

function var_0_0.getRestSkillPoint(arg_506_0)
	if (DB("character", arg_506_0.inst.code, "grade") or 3) <= 3 then
		return 0
	end
	
	local var_506_0 = 0
	local var_506_1 = arg_506_0:getUnitOptionValue("used_skill_point") or 0
	
	if var_506_1 >= 3 or arg_506_0:getFavLevel() < 10 then
		return 0
	end
	
	local var_506_2 = 3 - var_506_1
	
	if var_506_2 <= 0 then
		return 0
	end
	
	return var_506_2
end

function var_0_0.canRequest_skillPoint(arg_507_0)
	if not arg_507_0.inst then
		return 
	end
	
	local var_507_0 = 15
	
	if (DB("character", arg_507_0.inst.code, "grade") or 3) <= 3 then
		return false
	end
	
	local var_507_1 = 0
	local var_507_2 = arg_507_0:getUnitOptionValue("used_skill_point") or 0
	
	for iter_507_0 = 1, 3 do
		var_507_1 = var_507_1 + arg_507_0:getSkillLevelByIndex(iter_507_0)
	end
	
	if arg_507_0:getFavLevel() >= 10 and var_507_2 < 3 and var_507_1 == var_507_0 then
		return true
	end
	
	return false
end

function var_0_0.skillPointNoti(arg_508_0)
	if (DB("character", arg_508_0.inst.code, "grade") or 3) <= 3 then
		return false
	end
	
	if arg_508_0:getFavLevel() < 10 then
		return false
	end
	
	if (arg_508_0:getUnitOptionValue("used_skill_point") or 0) >= 3 then
		return false
	end
	
	if arg_508_0:isMoonlightDestinyUnit() then
		return false
	end
	
	return true
end

function var_0_0.setSkillRate(arg_509_0, arg_509_1)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_509_0:setCheatStatus("sk_skillrate", arg_509_1)
end

function var_0_0.getSkillRate(arg_510_0)
	if PRODUCTION_MODE then
		return 
	end
	
	return arg_510_0.cheat_status.sk_skillrate
end

function var_0_0.procLotaContents(arg_511_0, arg_511_1, arg_511_2)
	if not arg_511_1 then
		return 
	end
	
	if not arg_511_1.is_lota_contents then
		return 
	end
	
	arg_511_0:addContentEnhance(nil, arg_511_2)
end

function var_0_0.isContentEnhance(arg_512_0)
	return arg_512_0.contetns_origins and arg_512_0.states:isExistEffect("CSP_CONTENT_ENHANCE")
end

function var_0_0.addContentEnhanceExp(arg_513_0, arg_513_1)
	if not arg_513_0.content_exp then
		arg_513_0.content_exp = 0
	end
	
	arg_513_0.content_exp = arg_513_0.content_exp + arg_513_1
end

function var_0_0.resetContentEnhanceExp(arg_514_0)
	arg_514_0.content_exp = nil
end

function var_0_0.getContentEnhanceExp(arg_515_0, arg_515_1)
	return arg_515_0.content_exp or 0
end

function var_0_0.addContentEnhance(arg_516_0, arg_516_1, arg_516_2)
	arg_516_0.contetns_origins = {
		lv = arg_516_0.inst.lv,
		grade = arg_516_0.inst.grade,
		zodiac = arg_516_0.inst.zodiac,
		skill_lv = arg_516_0.inst.skill_lv
	}
	arg_516_0.inst.lv = 60
	arg_516_0.inst.grade = 6
	arg_516_0.inst.zodiac = 6
	arg_516_0.inst.stree = {
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3
	}
	
	if not arg_516_2 then
		arg_516_0:_removeAllPassive()
		
		arg_516_0.inst.skill_lv = {}
		
		for iter_516_0 = 1, 3 do
			local var_516_0 = arg_516_0:getMaxSkillLevelByIndex(iter_516_0)
			
			table.insert(arg_516_0.inst.skill_lv, var_516_0)
		end
	end
	
	arg_516_0:updateZodiacSkills(true)
	
	if not arg_516_1 then
		arg_516_0:calc()
	end
end

function var_0_0.isApplyGrowthBoost(arg_517_0)
	return arg_517_0.is_apply_growth_boost
end

function var_0_0.applyGrowthBoost(arg_518_0)
	arg_518_0.is_apply_growth_boost = true
end

function var_0_0.disapplyGrowthBoost(arg_519_0)
	arg_519_0.is_apply_growth_boost = false
	
	arg_519_0:resetGrowthBoost()
end

function var_0_0.resetGrowthBoost(arg_520_0)
	if arg_520_0.growth_boost_origins and arg_520_0.growth_boost_origins.lv then
		arg_520_0.inst.lv = arg_520_0.growth_boost_origins.lv
		arg_520_0.growth_boost_origins.lv = nil
	end
	
	if arg_520_0.growth_boost_origins and arg_520_0.growth_boost_origins.grade then
		arg_520_0.inst.grade = arg_520_0.growth_boost_origins.grade
		arg_520_0.growth_boost_origins.grade = nil
	end
	
	if arg_520_0.growth_boost_origins and arg_520_0.growth_boost_origins.skill_lv then
		arg_520_0.inst.skill_lv = arg_520_0.growth_boost_origins.skill_lv
		arg_520_0.growth_boost_origins.skill_lv = nil
	end
	
	if arg_520_0.growth_boost_origins and arg_520_0.growth_boost_origins.zodiac then
		arg_520_0.inst.zodiac = arg_520_0.growth_boost_origins.zodiac
		arg_520_0.growth_boost_origins.zodiac = nil
		
		arg_520_0:updateZodiacSkills(true)
	end
	
	local var_520_0 = arg_520_0.states:findByEff("CSP_LEVEL_ENHANCE")
	
	if var_520_0 and var_520_0:isValid() then
		var_520_0:setValid(false)
	end
	
	local var_520_1 = arg_520_0.states:findByEff("CSP_GRADE_ENHANCE")
	
	if var_520_1 and var_520_1:isValid() then
		var_520_1:setValid(false)
	end
	
	local var_520_2 = arg_520_0.states:findByEff("CSP_SKLV_ENHANCE")
	
	if var_520_2 and var_520_2:isValid() then
		var_520_2:setValid(false)
	end
	
	local var_520_3 = arg_520_0.states:findByEff("CSP_ZODIAC_ENHANCE")
	
	if var_520_3 and var_520_3:isValid() then
		var_520_3:setValid(false)
	end
end

function var_0_0.calcGrowthBoost(arg_521_0)
	local var_521_0 = arg_521_0.inst.growth_boost_info
	
	if var_521_0 and var_521_0.gb_passive and not arg_521_0.states:find(var_521_0.gb_passive) then
		arg_521_0:setPassiveState(var_521_0.gb_passive)
	end
	
	if not arg_521_0.is_apply_growth_boost then
		if arg_521_0.growth_boost_origins and not table.empty(arg_521_0.growth_boost_origins) then
			arg_521_0:resetGrowthBoost()
		end
		
		return 
	end
	
	local var_521_1 = arg_521_0.growth_boost_origins or {}
	local var_521_2, var_521_3 = arg_521_0.states:isExistForceEffect("CSP_LEVEL_ENHANCE")
	
	if var_521_2 then
		local var_521_4 = arg_521_0.inst.lv
		
		arg_521_0.inst.lv = math.max(to_n(var_521_3), arg_521_0.inst.lv)
		
		if var_521_4 ~= arg_521_0.inst.lv then
			var_521_1.lv = var_521_4
		end
	elseif arg_521_0.growth_boost_origins and arg_521_0.growth_boost_origins.lv then
		arg_521_0.inst.lv = arg_521_0.growth_boost_origins.lv
		arg_521_0.growth_boost_origins.lv = nil
	end
	
	local var_521_5, var_521_6 = arg_521_0.states:isExistForceEffect("CSP_GRADE_ENHANCE")
	
	if var_521_5 then
		local var_521_7 = arg_521_0.inst.grade
		
		arg_521_0.inst.grade = math.max(to_n(var_521_6), arg_521_0.inst.grade)
		
		if var_521_7 ~= arg_521_0.inst.grade then
			var_521_1.grade = var_521_7
		end
	elseif arg_521_0.growth_boost_origins and arg_521_0.growth_boost_origins.grade then
		arg_521_0.inst.grade = arg_521_0.growth_boost_origins.grade
		arg_521_0.growth_boost_origins.grade = nil
	end
	
	local var_521_8, var_521_9 = arg_521_0.states:isExistForceEffect("CSP_SKLV_ENHANCE")
	
	if var_521_8 then
		local var_521_10 = to_n(var_521_9)
		local var_521_11 = 0
		
		for iter_521_0 = 1, 3 do
			var_521_11 = var_521_11 + arg_521_0:getSkillLevelByIndex(iter_521_0)
		end
		
		if var_521_11 < var_521_10 then
			var_521_1.skill_lv = arg_521_0.inst.skill_lv
			
			arg_521_0:_removeAllPassive()
			
			arg_521_0.inst.skill_lv = {}
			
			for iter_521_1 = 3, 1, -1 do
				if var_521_10 > 0 then
					local var_521_12 = arg_521_0:getSkillLevelByIndex(iter_521_1)
					local var_521_13 = arg_521_0:getMaxSkillLevelByIndex(iter_521_1)
					
					if var_521_12 < var_521_13 then
						local var_521_14 = math.min(var_521_10, var_521_13)
						
						table.insert(arg_521_0.inst.skill_lv, iter_521_1, var_521_14)
						
						var_521_10 = var_521_10 - var_521_14
					end
				end
			end
		end
	elseif arg_521_0.growth_boost_origins and arg_521_0.growth_boost_origins.skill_lv then
		arg_521_0.inst.skill_lv = arg_521_0.growth_boost_origins.skill_lv
		arg_521_0.growth_boost_origins.skill_lv = nil
	end
	
	local var_521_15, var_521_16 = arg_521_0.states:isExistForceEffect("CSP_ZODIAC_ENHANCE")
	
	if var_521_15 then
		local var_521_17 = arg_521_0.inst.zodiac
		
		arg_521_0.inst.zodiac = math.max(to_n(var_521_16), arg_521_0.inst.zodiac)
		
		arg_521_0:updateZodiacSkills(true)
		
		if var_521_17 ~= arg_521_0.inst.zodiac then
			var_521_1.zodiac = var_521_17
		end
	elseif arg_521_0.growth_boost_origins and arg_521_0.growth_boost_origins.zodiac then
		arg_521_0.inst.zodiac = arg_521_0.growth_boost_origins.zodiac
		arg_521_0.growth_boost_origins.zodiac = nil
		
		arg_521_0:updateZodiacSkills(true)
	end
	
	arg_521_0.growth_boost_origins = var_521_1
end

function var_0_0._removeAllPassive(arg_522_0)
	if not arg_522_0.states or not arg_522_0.states.List then
		return 
	end
	
	for iter_522_0, iter_522_1 in pairs(arg_522_0.db.skills) do
		if iter_522_1 and arg_522_0:isSkillEnabled(iter_522_1) then
			local var_522_0 = arg_522_0:getSkillDB(iter_522_1, "sk_passive")
			
			if var_522_0 then
				arg_522_0.states:removePassiveById(var_522_0)
			end
		end
	end
end

function var_0_0.removeContentEnhance(arg_523_0)
end

function var_0_0.hasEmptyEquip(arg_524_0)
	if not arg_524_0.equips then
		return true
	end
	
	local var_524_0 = {
		"weapon",
		"helm",
		"neck",
		"armor",
		"boot",
		"ring",
		"artifact"
	}
	
	for iter_524_0, iter_524_1 in pairs(var_524_0) do
		if arg_524_0:getEquipByPos(iter_524_1) == nil then
			return true
		end
	end
	
	return false
end

function var_0_0.applyLevelBaseBuff(arg_525_0, arg_525_1, arg_525_2)
	if not arg_525_1 then
		return 
	end
	
	arg_525_2 = arg_525_2 or 1
	
	local var_525_0 = string.split(arg_525_1, ",")
	local var_525_1 = string.split(tostring(arg_525_2), ",")
	
	for iter_525_0, iter_525_1 in pairs(var_525_0) do
		arg_525_0:addState(iter_525_1, tonumber(var_525_1[iter_525_0]) or 1, arg_525_0)
	end
end

function var_0_0.applyNpcSkillLevel(arg_526_0, arg_526_1)
	if DB("character", arg_526_0.db.code, "apply_npc_skill") == "y" then
		if not arg_526_1 then
			arg_526_0.inst.stree = {
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3,
				3
			}
			
			arg_526_0:_removeAllPassive()
			
			arg_526_0.inst.skill_lv = {}
			
			for iter_526_0 = 1, 3 do
				local var_526_0 = arg_526_0:getMaxSkillLevelByIndex(iter_526_0)
				
				table.insert(arg_526_0.inst.skill_lv, var_526_0)
			end
		end
		
		arg_526_0:_updateZodiacSkills(6, true)
	end
end

function is_enhanced_mer(arg_527_0)
	return arg_527_0 == "c0001" or arg_527_0 == "c0002"
end

function is_mer_series(arg_528_0)
	return arg_528_0 == "c1005" or arg_528_0 == "c0001" or arg_528_0 == "c0002"
end

function get_origin_mer()
	return "c1005"
end

function var_0_0.isMerEnhanceProceeding(arg_530_0)
	return arg_530_0.db.code == "c0001"
end

function change_mer_code()
	if Account:isMapCleared("poe017") then
		return "c0002"
	elseif Account:isMapCleared("poe010") then
		return "c0001"
	else
		return "c1005"
	end
end

function var_0_0.isMoverPaused(arg_532_0)
	return arg_532_0.inst.mover_pause
end

function var_0_0.makeEquipFormat(arg_533_0)
	local var_533_0 = {}
	
	for iter_533_0, iter_533_1 in pairs(arg_533_0.equips) do
		if iter_533_1 then
			var_533_0[iter_533_1.db.type] = {
				iter_533_1.code,
				iter_533_1.enhance
			}
		end
	end
	
	return json.encode(var_533_0)
end

function var_0_0.makeEquipChangeData(arg_534_0, arg_534_1, arg_534_2)
	return {
		equip = {
			[tostring(arg_534_0:getUID())] = {
				arg_534_1
			}
		},
		unequip = {
			[tostring(arg_534_0:getUID())] = {
				arg_534_2
			}
		}
	}
end

function var_0_0.calcEquipChangePoints(arg_535_0, arg_535_1)
	local var_535_0 = arg_535_1 or {
		equip = {},
		unequip = {}
	}
	local var_535_1 = arg_535_0:getPoint()
	local var_535_2 = arg_535_0:clone()
	local var_535_3 = tostring(arg_535_0:getUID())
	
	for iter_535_0, iter_535_1 in pairs(var_535_0.unequip[var_535_3] or {}) do
		for iter_535_2 = 1, #var_535_2.equips do
			local var_535_4 = var_535_2.equips[iter_535_2]
			
			if var_535_4 and iter_535_1 == var_535_4.id then
				if var_535_4:isExclusive() then
					var_535_2.inst.exclusive_effect = {}
				end
				
				var_535_2.equips[iter_535_2] = nil
			end
		end
	end
	
	for iter_535_3, iter_535_4 in pairs(var_535_0.equip[var_535_3] or {}) do
		local var_535_5 = Account:getEquip(iter_535_4)
		
		if var_535_5 then
			table.insert(var_535_2.equips, var_535_5)
		end
	end
	
	var_535_2:reset()
	var_535_2:calc()
	
	local var_535_6 = var_535_2:getPoint()
	local var_535_7 = arg_535_0:makeEquipFormat()
	local var_535_8 = var_535_2:makeEquipFormat()
	
	return var_535_1, var_535_6, var_535_7, var_535_8
end

UNIT_TEMPLATE_OVERIDES = UNIT_TEMPLATE_OVERIDES or {}

function UNIT_TEMPLATE_OVERIDES.calc_step_override1(arg_536_0, arg_536_1)
	if not arg_536_1 then
		arg_536_0:calcEquipSkills()
		
		if arg_536_0.template_exc_id then
			arg_536_0:applyExclusiveSkill(arg_536_0.template_exc_id)
		end
	end
end

function UNIT_TEMPLATE_OVERIDES.calc_step_override2(arg_537_0, arg_537_1)
	for iter_537_0, iter_537_1 in pairs(arg_537_0.cheat_status) do
		if arg_537_0.status[iter_537_0] and iter_537_1 and iter_537_1 > 0 then
			arg_537_0.status[iter_537_0] = iter_537_1
		end
	end
	
	arg_537_0:calcDevoteStatus(true)
	arg_537_0:calcStatusBooster(arg_537_0.status, arg_537_0.character_status)
	
	for iter_537_2, iter_537_3 in pairs(arg_537_0._cheat_option_stat_booster or {}) do
		arg_537_0.status[iter_537_2] = arg_537_0.status[iter_537_2] + arg_537_0.character_status[iter_537_2] * iter_537_3
	end
	
	for iter_537_4, iter_537_5 in pairs(arg_537_0._cheat_option_equip_fx or {}) do
		local var_537_0 = DBT("item_set", iter_537_4, {
			"type1",
			"effect1",
			"type2",
			"effect2"
		})
		
		for iter_537_6 = 1, 2 do
			local var_537_1 = var_537_0["type" .. iter_537_6]
			local var_537_2 = var_537_0["effect" .. iter_537_6]
			
			if not var_537_1 or string.sub(var_537_1, -5, -1) == "_rate" then
			elseif var_537_1 ~= "skill" then
				arg_537_0:applyStatus({
					{
						var_537_1,
						var_537_2
					}
				})
			else
				local function var_537_3(arg_538_0, arg_538_1)
					local var_538_0 = arg_537_0:getSkillDB(arg_538_1, "sk_passive")
					
					if var_538_0 and arg_537_0:getCSDB(var_538_0, "cs_overlap") == "y" then
						return arg_537_0.states:countById(var_538_0)
					end
					
					return 0
				end
				
				local var_537_4 = math.if_nan_or_inf(iter_537_5, 0)
				
				for iter_537_7 = 1 + var_537_3(iter_537_4, var_537_2), var_537_4 do
					arg_537_0:setPassiveSkill(var_537_2)
				end
			end
		end
	end
end

function UNIT_TEMPLATE_OVERIDES.calcCheatStatus(arg_539_0)
end

function UNIT_TEMPLATE_OVERIDES.apply_template_setBooster(arg_540_0, arg_540_1)
	arg_540_0._cheat_option_stat_booster = {}
	
	for iter_540_0, iter_540_1 in pairs(arg_540_1) do
		if iter_540_0 and string.sub(iter_540_0, -5, -1) == "_rate" then
			local var_540_0 = string.sub(iter_540_0, 1, -6)
			
			arg_540_0._cheat_option_stat_booster[var_540_0] = iter_540_1 / 100
		end
	end
end

function UNIT_TEMPLATE_OVERIDES.apply_template_setEquipFx(arg_541_0, arg_541_1)
	arg_541_1 = arg_541_1 or {}
	arg_541_0._cheat_option_equip_fx = {}
	
	for iter_541_0, iter_541_1 in pairs(arg_541_1) do
		local var_541_0 = DBT("item_set", iter_541_1, {
			"type1",
			"effect1",
			"type2",
			"effect2"
		})
		
		arg_541_0._cheat_option_equip_fx[iter_541_1] = arg_541_0._cheat_option_equip_fx[iter_541_1] or 0
		arg_541_0._cheat_option_equip_fx[iter_541_1] = arg_541_0._cheat_option_equip_fx[iter_541_1] + 1
		
		for iter_541_2 = 1, 2 do
			local var_541_1 = var_541_0["type" .. iter_541_2]
			local var_541_2 = var_541_0["effect" .. iter_541_2]
			
			if var_541_1 and string.sub(var_541_1, -5, -1) == "_rate" then
				local var_541_3 = string.sub(var_541_1, 1, -6)
				
				arg_541_0._cheat_option_stat_booster[var_541_3] = arg_541_0._cheat_option_stat_booster[var_541_3] or 0
				arg_541_0._cheat_option_stat_booster[var_541_3] = arg_541_0._cheat_option_stat_booster[var_541_3] + var_541_2
			end
		end
	end
end

copy_functions(var_0_0, UNIT)

local function var_0_11()
	local var_542_0 = {}
	
	for iter_542_0, iter_542_1 in pairs(var_0_0) do
		if type(iter_542_1) == "function" and string.format("%p", iter_542_1) ~= string.format("%p", UNIT[iter_542_0]) then
			table.insert(var_542_0, iter_542_0)
		end
	end
	
	return var_542_0
end

Slapstick = Slapstick or {}

function Slapstick.comedy(arg_543_0)
	return var_0_11()
end
