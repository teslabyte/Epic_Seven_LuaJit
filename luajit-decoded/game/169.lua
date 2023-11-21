ignore_crc32 = false

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
							if var_14_0.enval[arg_14_1] then
								local var_14_3 = var_14_0.enval[arg_14_1][1]
							end
							
							if var_14_0.enval[arg_14_1] then
								local var_14_4 = var_14_0.enval[arg_14_1][2]
							end
							
							if var_14_0.enval[arg_14_1] then
								local var_14_5 = var_14_0.enval[arg_14_1][3]
							end
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
				
				Log.e("logic encrypt 추가는 init 에서 미리 명시할것")
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
	
	if arg_10_0 and arg_10_0.encrypt then
		if arg_10_1 then
			arg_10_0.encrypt = var_10_3(arg_10_0.encrypt)
		else
			arg_10_0.encrypt = var_10_4(arg_10_0.encrypt)
		end
	end
end

function GET_SKILL_TIME_SCALE()
	return DEBUG.TIME_SCALE_SKILL_ACTION or 1.5
end

function GET_MOVE_TIME_SCALE()
	return DEBUG.TIME_SCALE_MOVE or 2.2
end

function GET_EVENT_TIME_SCALE()
	return DEBUG.TIME_SCALE_EVENT or 1.5
end

local var_0_3 = {}

CALL_PROCINFO = false
ENABLE_REPLAY_DATA = true
UID_SUPPORTER_PREFIX = -100000
UID_MAPNPCMOB_PREFIX = -200000
USE_STATE_DIFF = true
USE_STATE_COMPACT = true
CACHE_HIT_COUNT_DB = {}
ENEMY = "enemy"
FRIEND = "friend"
ROAD_INSIGHT_RANGE = 1
LIMIT_CAMPING_TOPIC = 2

local var_0_4 = 1e-07

local function var_0_5(arg_22_0, arg_22_1)
	if arg_22_0.attacker.elapsed_ut == arg_22_1.attacker.elapsed_ut then
		return arg_22_0.attacker.status.speed > arg_22_1.attacker.status.speed
	end
	
	return arg_22_0.attacker.elapsed_ut > arg_22_1.attacker.elapsed_ut
end

local function var_0_6(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.status.speed
	local var_23_1 = arg_23_1.status.speed
	
	if var_23_0 == var_23_1 then
		var_23_1 = arg_23_0.logic:findUnitIndex(arg_23_0)
		var_23_0 = arg_23_1.logic:findUnitIndex(arg_23_1)
	end
	
	return var_23_1 < var_23_0
end

local function var_0_7(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.attacker
	local var_24_1 = arg_24_1.attacker
	local var_24_2 = var_24_0.status.speed
	local var_24_3 = var_24_1.status.speed
	
	if var_24_2 == var_24_3 then
		var_24_3 = var_24_0.logic:findUnitIndex(var_24_0)
		var_24_2 = var_24_1.logic:findUnitIndex(var_24_1)
	end
	
	return var_24_3 < var_24_2
end

local function var_0_8(arg_25_0)
	return arg_25_0.db.name .. " (" .. arg_25_0.inst.hp .. "/" .. arg_25_0:getMaxHP() .. ")"
end

function countDead(arg_26_0)
	local var_26_0 = 0
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0) do
		if iter_26_1:isDead() then
			var_26_0 = var_26_0 + 1
		end
	end
	
	return var_26_0
end

local function var_0_9(arg_27_0)
	local var_27_0 = {}
	
	for iter_27_0, iter_27_1 in ipairs(arg_27_0) do
		if not iter_27_1:isDead() then
			var_27_0[#var_27_0 + 1] = iter_27_1
		end
	end
	
	table.sort(var_27_0, UNIT.greaterThanTime)
	
	for iter_27_2, iter_27_3 in ipairs(var_27_0) do
		iter_27_3.inst.team_order = iter_27_2
	end
end

local function var_0_10(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1.hide
	local var_28_1 = arg_28_1.drop
	
	if var_28_1 and var_28_1.code then
		local var_28_2 = ({
			to = "tokens",
			pa = "items",
			ma = "items"
		})[string.split(var_28_1.code, "_")[1]]
		
		if not var_28_2 then
			if string.starts(var_28_1.code, "e") then
				var_28_2 = "equip"
			elseif DB("character", var_28_1.code, "name") then
				var_28_2 = "character"
			end
		end
		
		if var_28_0 then
			local var_28_3 = {
				"to_gold",
				"to_dungeonkey"
			}
			
			if table.isInclude(var_28_3, var_28_1.code) then
				var_28_0 = false
			end
		end
		
		var_28_2 = var_28_0 and "items" or var_28_2
		
		if not arg_28_0[var_28_2] then
			arg_28_0[var_28_2] = {}
		end
		
		if var_28_0 then
			local var_28_4 = "ma_unidentified"
			local var_28_5 = DB("item_material", var_28_4, "grade")
			
			table.insert(arg_28_0[var_28_2], {
				count = 1,
				t = var_28_2,
				code = var_28_4,
				grade = var_28_5
			})
		else
			table.insert(arg_28_0[var_28_2], {
				t = var_28_1.t,
				code = var_28_1.code,
				count = var_28_1.count,
				grade = var_28_1.grade,
				temp = var_28_1.temp
			})
		end
	end
	
	if arg_28_1.gold then
		arg_28_0.gold = (arg_28_0.gold or 0) + arg_28_1.gold
	end
	
	if arg_28_1.stigma then
		arg_28_0.stigma = (arg_28_0.stigma or 0) + arg_28_1.stigma
	end
	
	return arg_28_0
end

local function var_0_11(arg_29_0, arg_29_1)
	return arg_29_0 == "battle_raidboss" or arg_29_1 == "raid"
end

function error_report(arg_30_0)
end

function error_summary()
end

function to_reverse_dir(arg_32_0)
	return ({
		down = "up",
		up = "down",
		left = "right",
		right = "left"
	})[arg_32_0]
end

function is_reverse_dir(arg_33_0)
	return arg_33_0 == "up" or arg_33_0 == "left"
end

function appy_template_status(arg_34_0, arg_34_1)
	for iter_34_0, iter_34_1 in pairs(UNIT_TEMPLATE_OVERIDES) do
		arg_34_0[iter_34_0] = iter_34_1
	end
	
	if table.count(arg_34_1.status) > 0 then
		local var_34_0 = arg_34_1.status
		
		for iter_34_2, iter_34_3 in pairs(var_34_0) do
			if not arg_34_0.status[iter_34_2] then
				print("NOT UNIT STATUS. CHECK : ", iter_34_2)
			else
				arg_34_0:setCheatStatus(iter_34_2, arg_34_0.status[iter_34_2] + iter_34_3, true)
			end
		end
	end
	
	if table.count(arg_34_1.rate) > 0 then
		arg_34_0:apply_template_setBooster(arg_34_1.rate)
	end
	
	if arg_34_1.set_op_id then
		arg_34_0:apply_template_setEquipFx(arg_34_1.set_op_id)
	end
	
	if arg_34_1.arti_id then
		local var_34_1 = EQUIP:createByInfo({
			code = arg_34_1.arti_id
		})
		local var_34_2 = EQUIP:createByInfo({
			dup_pt = 5,
			code = arg_34_1.arti_id,
			exp = EQUIP.getMaxExp(var_34_1, 5)
		})
		
		arg_34_0:addEquip(var_34_2, true)
	end
	
	if arg_34_1.exc_id then
		arg_34_0.template_exc_id = arg_34_1.exc_id
	end
end

function make_template_unit(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = {
		ct = 1575102592,
		z = 6,
		opt = 11,
		d = 7,
		exp = 5000000000,
		f = 10,
		g = 6,
		id = 13640955,
		code = "",
		st = 0,
		s = {
			0,
			0,
			0
		},
		stree = {
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
	}
	local var_35_1 = table.clone(var_35_0)
	
	var_35_1.id = arg_35_0
	var_35_1.code = arg_35_2
	var_35_1.template_id = arg_35_1
	
	return var_35_1
end

function make_action_data_ext(arg_36_0)
	arg_36_0 = arg_36_0 or {}
	
	print("make action data ext begin.", arg_36_0.stg_path)
	
	local function var_36_0(arg_37_0)
		if arg_36_0.skill_id then
			local var_37_0 = "stagept/" .. arg_37_0 .. ".stg"
			local var_37_1 = cc.FileUtils:getInstance():getStringFromFile(var_37_0)
			
			if var_37_1 and string.len(var_37_1) > 0 then
				return (json.decode(var_37_1))
			end
		else
			local var_37_2 = arg_36_0.stg_path .. "/" .. arg_37_0 .. ".stg"
			local var_37_3 = io.open(var_37_2)
			
			if var_37_3 then
				local var_37_4 = var_37_3:read("*a")
				
				return (json.decode(var_37_4))
			end
		end
	end
	
	local function var_36_1(arg_38_0)
		local var_38_0 = 0
		
		if arg_38_0 then
			local var_38_1 = var_36_0(arg_38_0)
			
			if var_38_1 and var_38_1.entities then
				for iter_38_0, iter_38_1 in pairs(var_38_1.entities) do
					if iter_38_1.etty == "HIT" then
						var_38_0 = var_38_0 + 1
					end
				end
			end
		end
		
		return var_38_0
	end
	
	local function var_36_2(arg_39_0, arg_39_1, arg_39_2)
		local var_39_0, var_39_1, var_39_2, var_39_3 = DB("skillact", arg_39_1, {
			"action",
			"skin01",
			"skin02",
			"skin03"
		})
		local var_39_4 = {
			hit_count = var_36_1(var_39_0),
			skin01 = var_36_1(var_39_1),
			skin02 = var_36_1(var_39_2),
			skin03 = var_36_1(var_39_3)
		}
		
		arg_39_2(arg_39_0, var_39_4)
	end
	
	if arg_36_0.skill_id then
		local var_36_3, var_36_4 = DB("skill", arg_36_0.skill_id, {
			"id",
			"skillact"
		})
		
		if var_36_3 then
			var_36_2(var_36_3, var_36_4, arg_36_0.callback)
		end
	else
		for iter_36_0 = 1, 99999 do
			local var_36_5, var_36_6 = DBN("skill", iter_36_0, {
				"id",
				"skillact"
			})
			
			if not var_36_5 then
				break
			end
			
			if arg_36_0.only_hero then
				if string.starts(var_36_5, "sk") then
					var_36_2(var_36_5, var_36_6, arg_36_0.callback)
				end
			else
				var_36_2(var_36_5, var_36_6, arg_36_0.callback)
			end
		end
	end
	
	print("make action data ext finish.")
end

BattleLogger = {}

function BattleLogger.new()
	local var_40_0 = {
		logs = {}
	}
	
	var_40_0.rpos = 1
	
	copy_functions(BattleLogger, var_40_0)
	
	return var_40_0
end

function BattleLogger.add(arg_41_0, ...)
	local var_41_0 = {
		...
	}
	
	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		if type(iter_41_1) ~= "table" and iter_41_1.type then
			error("errr not log type ")
		end
		
		table.insert(arg_41_0.logs, iter_41_1)
	end
end

function BattleLogger.pop(arg_42_0)
	if arg_42_0.rpos > #arg_42_0.logs then
		return 
	end
	
	local var_42_0 = arg_42_0.logs[arg_42_0.rpos]
	
	arg_42_0.rpos = arg_42_0.rpos + 1
	
	return var_42_0
end

function BattleLogger.popAll(arg_43_0)
	local var_43_0 = {}
	
	while arg_43_0.rpos <= #arg_43_0.logs do
		table.insert(var_43_0, arg_43_0.logs[arg_43_0.rpos])
		
		arg_43_0.rpos = arg_43_0.rpos + 1
	end
	
	return var_43_0
end

function BattleLogger.isEmpty(arg_44_0)
	return arg_44_0.rpos > #arg_44_0.logs
end

RoadEvent = {}

function RoadEvent.create(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = {}
	
	copy_functions(RoadEvent, var_45_0)
	
	var_45_0.id = arg_45_1.id
	var_45_0.type = arg_45_1.type
	var_45_0.value = arg_45_1.value
	var_45_0.name_tag = (var_45_0.value or {}).name_tag
	var_45_0.drop = arg_45_1.drop
	var_45_0.exp = arg_45_1.exp
	var_45_0.team = arg_45_1.team
	
	if var_45_0.team then
		var_45_0.team.setup_line = true
	end
	
	var_45_0.flag_info = arg_45_1.flag_info
	var_45_0.group_expired = arg_45_1.group_expired
	var_45_0.event_id = arg_45_1.id
	var_45_0.stage_idx = tonumber(arg_45_1.stage_idx) or 1
	
	if arg_45_2 then
		var_45_0.road_id = arg_45_2.road_id
		var_45_0.is_last = arg_45_2.is_last
		var_45_0.group_no = tonumber(arg_45_1.room)
		
		if not tonumber(arg_45_1.room) then
			Log.e(arg_45_0.name, "DB ERROR room 데이터 값이 비어 있습니다.")
			error("error missing db data")
		end
		
		var_45_0.sector_no = arg_45_2.sector_no
		var_45_0.story_id = arg_45_2.road_id .. "^" .. tostring(var_45_0.group_no)
		var_45_0.group_id = arg_45_2.road_id .. "_" .. tostring(var_45_0.group_no)
		var_45_0.sector_id = arg_45_2.road_id .. "_" .. tostring(var_45_0.sector_no)
		
		Log.d(arg_45_0.name, "= Load Event", var_45_0.group_id)
		
		if type(arg_45_1.mobs) == "table" then
			var_45_0.mobs = {}
			
			for iter_45_0, iter_45_1 in pairs(arg_45_1.mobs) do
				arg_45_2.unit_mobsid_prefix = arg_45_2.unit_mobsid_prefix - 1
				
				local var_45_1 = table.clone(iter_45_1)
				
				var_45_1.id = arg_45_2.unit_mobsid_prefix
				var_45_0.mobs[iter_45_0] = var_45_1
				
				Log.d(arg_45_0.name, "gen mob.id", var_45_1.id)
			end
		end
		
		var_45_0.contents_type = arg_45_2.contents_type
	end
	
	if string.starts(var_45_0.type, "battle") then
		var_45_0["-main-type"] = "battle"
	elseif var_45_0.type == "empty" or var_45_0.type == "start" then
		var_45_0["-main-type"] = "entry"
	else
		var_45_0["-main-type"] = "object"
		var_45_0.touchable = true
		
		if var_45_0.type == "npc" or var_45_0.type == "npc_shop" or var_45_0.type == "warp" then
			var_45_0.always_fire = true
		end
		
		if var_45_0.type == "obstacle" then
			var_45_0.is_obstacle = true
		end
	end
	
	var_45_0.data = arg_45_1
	
	var_45_0:calc_reward()
	table.set_readonly(var_45_0)
	
	return var_45_0
end

function RoadEvent.isTouchable(arg_46_0)
	return arg_46_0.touchable
end

function RoadEvent.isAlwayseFire(arg_47_0)
	return arg_47_0.always_fire
end

function RoadEvent.isObstacleType(arg_48_0)
	return object.is_obstacle
end

function RoadEvent.isObjectType(arg_49_0)
	return arg_49_0["-main-type"] == "object"
end

function RoadEvent.isBattleType(arg_50_0)
	return arg_50_0["-main-type"] == "battle"
end

function RoadEvent.calc_reward(arg_51_0)
	arg_51_0.reward = nil
	
	local var_51_0 = arg_51_0.data
	local var_51_1 = var_0_11(var_51_0.type, arg_51_0.contents_type)
	local var_51_2 = {}
	
	if var_51_0.exp then
		var_51_2.exp = var_51_0.exp
	end
	
	if var_51_0.mobs then
		for iter_51_0, iter_51_1 in pairs(var_51_0.mobs) do
			var_51_2 = var_0_10(var_51_2, {
				drop = iter_51_1.drop,
				hide = var_51_1
			})
		end
	end
	
	if var_51_0.drop then
		var_51_2 = var_0_10(var_51_2, {
			drop = var_51_0.drop,
			hide = var_51_1
		})
	end
	
	if var_51_0.base_drop then
		for iter_51_2, iter_51_3 in pairs(var_51_0.base_drop) do
			var_51_2 = var_0_10(var_51_2, {
				drop = iter_51_3
			})
		end
	end
	
	if arg_51_0.value and arg_51_0.value.npc then
		for iter_51_4, iter_51_5 in pairs(arg_51_0.value.npc_drop or {}) do
			arg_51_0.value.npc_drop[iter_51_4] = var_0_10({}, {
				drop = iter_51_5,
				hide = var_51_1
			})
		end
	end
	
	if not table.empty(var_51_2) then
		arg_51_0.reward = var_51_2
	end
end

function RoadEvent.proc(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_1.logic
	
	if not var_52_0 then
		return 
	end
	
	local var_52_1 = {}
	
	if arg_52_0.type == "hp_heal" then
		for iter_52_0, iter_52_1 in pairs(var_52_0.friends) do
			if not iter_52_1:isDead() then
				local var_52_2, var_52_3 = iter_52_1:perHeal(arg_52_0.value.hp, nil, true)
				
				if var_52_2 > 0 then
					table.insert(var_52_1, {
						type = "heal",
						road_event_id = arg_52_0.event_id,
						target_uid = iter_52_1.inst.uid,
						heal = var_52_3,
						add_hp = var_52_2
					})
				end
			end
		end
	elseif arg_52_0.type == "sp_heal" then
		for iter_52_2, iter_52_3 in pairs(var_52_0.friends) do
			if not iter_52_3:isDead() then
				local var_52_4 = arg_52_0.value.sp
				local var_52_5 = iter_52_3:getSP()
				local var_52_6 = iter_52_3:getSPName()
				local var_52_7 = GAME_STATIC_VARIABLE.mana_max
				
				if var_52_6 == "cp" then
					var_52_7 = GAME_STATIC_VARIABLE.concentration_max
				end
				
				if var_52_6 == "rp" then
					var_52_7 = GAME_STATIC_VARIABLE.fighting_max
				end
				
				if var_52_6 == "bp" then
					var_52_7 = GAME_STATIC_VARIABLE.fighting_max
				end
				
				local var_52_8 = math.floor(math.min(var_52_7 - var_52_5, var_52_7 * var_52_4))
				
				iter_52_3:addRes(var_52_8, nil, true)
				table.insert(var_52_1, {
					type = "sp_heal",
					road_event_id = arg_52_0.event_id,
					target_uid = iter_52_3.inst.uid,
					rate = arg_52_0.value,
					sp_heal = var_52_8
				})
			end
		end
	elseif arg_52_0.type == "soul_heal" then
		var_52_0:addTeamRes(FRIEND, "soul_piece", arg_52_0.value.soul or 1)
		table.insert(var_52_1, {
			type = "gain_soul_piece_by_field",
			road_event_id = arg_52_0.event_id,
			count = arg_52_0.value or 1
		})
	elseif arg_52_0.type == "gate_chaos" or arg_52_0.type == "gate_treasure" then
		if var_52_0.is_back_ground then
			var_52_0:command({
				cmd = "EnterRoad",
				road_id = arg_52_0.value.info_id,
				road_event_id = arg_52_0.event_id
			})
		else
			table.insert(var_52_1, {
				type = "move_stage",
				road_event_id = arg_52_0.event_id,
				value = arg_52_0.value.info_id
			})
		end
	elseif arg_52_0.type == "item_crystal" then
		table.insert(var_52_1, {
			type = "crystal_drop",
			road_event_id = arg_52_0.event_id
		})
	elseif arg_52_0.type == "box_normal" or arg_52_0.type == "box_rare" or arg_52_0.type == "box_rarefix" or arg_52_0.type == "box_normal_gold" then
		table.insert(var_52_1, {
			type = "box_open",
			road_event_id = arg_52_0.event_id
		})
	elseif arg_52_0.type == "box_monster" then
		table.insert(var_52_1, {
			type = "mimic_transform",
			road_event_id = arg_52_0.event_id
		})
	elseif arg_52_0.type == "npc" then
		local var_52_9 = var_52_0.battle_info.results_road_event_tbl[arg_52_0.event_id] or {}
		local var_52_10 = var_52_0.battle_info.npc_road_event_tbl[arg_52_0.event_id]
		
		table.insert(var_52_1, {
			type = "field_npc",
			road_event_id = arg_52_0.event_id,
			counting = var_52_9[var_52_10] or 1
		})
		
		if var_52_9[var_52_10] == 1 and arg_52_0.value and arg_52_0.value.npc_drop then
			local var_52_11 = arg_52_0.value.npc_drop[var_52_10]
			
			if var_52_11 then
				table.insert(var_52_1, {
					type = "drop_reward",
					road_event_id = arg_52_0.event_id,
					reward = var_52_11
				})
			end
		end
	elseif arg_52_0.type == "switch" or arg_52_0.type == "switch_mel" then
		table.insert(var_52_1, {
			type = arg_52_0.type,
			road_event_id = arg_52_0.event_id
		})
	elseif arg_52_0.type == "obstacle" then
		table.insert(var_52_1, {
			type = "obstacle",
			road_event_id = arg_52_0.event_id
		})
	elseif arg_52_0.type == "npc_shop" then
		table.insert(var_52_1, {
			type = "field_npc_shop",
			road_event_id = arg_52_0.event_id,
			shop_id = arg_52_0.value.shop_id
		})
	elseif arg_52_0.type == "warp" then
		table.insert(var_52_1, {
			type = "warp_portal",
			road_event_id = arg_52_0.event_id,
			target_road_id = arg_52_0.value.info_id,
			value = arg_52_0.value
		})
	end
	
	if arg_52_0.reward then
		table.insert(var_52_1, {
			type = "drop_reward",
			road_event_id = arg_52_0.event_id,
			reward = arg_52_0.reward
		})
	end
	
	return var_52_1
end

BattleStageMap = {}

function BattleStageMap.new(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_2 or {}
	local var_53_1 = {}
	
	copy_functions(BattleStageMap, var_53_1)
	var_53_1:init(arg_53_1, var_53_0)
	
	return var_53_1
end

function BattleStageMap.init(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_2 or {}
	
	arg_54_0.map_data = table.shallow_clone(arg_54_1)
	
	local var_54_1 = arg_54_1.ways
	
	arg_54_0.init_opts = var_54_0
	arg_54_0.cross_road_tbl = {}
	arg_54_0.road_object_tbl = {}
	arg_54_0.road_sector_object_tbl = {}
	arg_54_0.road_event_object_tbl = {}
	arg_54_0.replace_road_event_object_tbl = {}
	arg_54_0.initial_pass_sector = {}
	
	if arg_54_1.opts then
		local var_54_2 = {}
		
		for iter_54_0, iter_54_1 in pairs(arg_54_1.opts) do
			local var_54_3 = {}
			
			if type(iter_54_1) == "string" then
				var_54_3 = totable(iter_54_1)
			elseif type(iter_54_1) == "table" then
				for iter_54_2, iter_54_3 in pairs(iter_54_1) do
					table.insert(var_54_3, totable(iter_54_3))
				end
			end
			
			var_54_2[iter_54_0] = var_54_3
		end
		
		arg_54_0.parsed_opts = var_54_2
	else
		arg_54_0.parsed_opts = {}
	end
	
	arg_54_0.maze_object_tbl = {}
	arg_54_0.start_opt = totable(arg_54_1.start or "") or {}
	
	local var_54_4, var_54_5, var_54_6, var_54_7, var_54_8 = DB("level_enter", arg_54_1.enter, {
		"type",
		"atlas_id",
		"info_id",
		"contents_type",
		"single_sector"
	})
	
	arg_54_0.type = var_54_4
	arg_54_0.enter_road_id = arg_54_1.enter
	arg_54_0.main_type = GET_BATTLE_MODE[var_54_4]
	arg_54_0.contents_type = var_54_7
	arg_54_0.weak_info = {}
	
	local var_54_9 = to_n(arg_54_1.weak_lv)
	
	arg_54_0.weak_info.weak_lv = var_54_9
	
	if var_54_9 > 0 and arg_54_1.lota_info and arg_54_1.lota_info.nerf_cs then
		arg_54_0.weak_info.weak_cs = arg_54_1.lota_info.nerf_cs
	end
	
	arg_54_0.select_map_data = arg_54_1.select_map_data
	arg_54_0.is_single_sector_stage = arg_54_1.skill_preview or arg_54_1.pvp or arg_54_0.main_type == "tow" or arg_54_0.main_type == "def" or var_54_8 == "y"
	
	for iter_54_4, iter_54_5 in pairs(var_54_1) do
		local var_54_10 = DB("level_stage_1_info", iter_54_4, {
			"type"
		})
		local var_54_11 = {
			road_id = iter_54_4,
			road_type = var_54_10,
			is_goblin = var_54_10 == "goblin"
		}
		
		arg_54_0.road_object_tbl[iter_54_4] = var_54_11
	end
	
	if not var_54_5 then
		arg_54_0.start_road_id = var_54_6
		arg_54_0.prev_road_id = nil
	else
		arg_54_0.map_atlas_id = var_54_5
		arg_54_0.start_road_id = arg_54_0.start_opt.start_info or arg_54_0.start_opt.info or var_54_6
		arg_54_0.prev_road_id = arg_54_0.start_opt.prev_info
		
		local var_54_12 = json.decode(DB("level_atlas", var_54_5, "maze"))
		
		var_54_12.road_list = var_54_12.rooms
		
		for iter_54_6, iter_54_7 in pairs(var_54_12.road_list) do
			local var_54_13 = iter_54_7.id
			
			iter_54_7.road_id = var_54_13
			arg_54_0.maze_object_tbl[var_54_13] = iter_54_7
			
			local var_54_14 = assert(arg_54_0.road_object_tbl[var_54_13])
			
			var_54_14.is_cross = true
			arg_54_0.cross_road_tbl[var_54_13] = var_54_14
		end
		
		for iter_54_8, iter_54_9 in pairs(var_54_12.grid) do
			local var_54_15 = string.split(iter_54_9, ".")
			local var_54_16 = var_54_15[1]
			local var_54_17 = tonumber(var_54_15[2])
			
			if not var_54_17 or var_54_17 == 0 then
				local var_54_18 = assert(arg_54_0.road_object_tbl[var_54_16])
				local var_54_19 = string.split(string.sub(iter_54_8, 2, -2) or "", ",")
				local var_54_20 = tonumber(var_54_19[1])
				local var_54_21 = tonumber(var_54_19[2])
				
				var_54_18.grid = {
					x = var_54_20,
					y = var_54_21
				}
			end
		end
		
		arg_54_0.maze_data = var_54_12
		
		local var_54_22 = {}
		
		for iter_54_10, iter_54_11 in pairs(arg_54_0.maze_object_tbl) do
			for iter_54_12, iter_54_13 in pairs(iter_54_11.dirs) do
				if iter_54_13.road_id then
					if not var_54_22[iter_54_13.road_id] then
						var_54_22[iter_54_13.road_id] = {}
					end
					
					var_54_22[iter_54_13.road_id][to_reverse_dir(iter_54_12)] = {
						road_reverse = iter_54_13.road_reverse,
						goal_id = iter_54_10
					}
				end
			end
		end
		
		arg_54_0.initial_pass_sector = {}
		
		for iter_54_14, iter_54_15 in pairs(arg_54_0.road_object_tbl) do
			if not arg_54_0.maze_object_tbl[iter_54_14] and var_54_22[iter_54_14] then
				arg_54_0.maze_object_tbl[iter_54_14] = {
					id = iter_54_14,
					dirs = var_54_22[iter_54_14]
				}
			end
			
			if arg_54_0.maze_object_tbl[iter_54_14] then
				iter_54_15.dirs = assert(arg_54_0.maze_object_tbl[iter_54_14].dirs)
			end
		end
		
		if not arg_54_0.prev_road_id then
			local var_54_23 = arg_54_0.maze_object_tbl[arg_54_0.start_road_id]
			
			if var_54_23 then
				for iter_54_16, iter_54_17 in pairs(var_54_23.dirs) do
					local var_54_24 = arg_54_0.maze_object_tbl[iter_54_17.goal_id]
					
					if table.count(var_54_24.dirs) == 1 then
						arg_54_0.prev_road_id = iter_54_17.goal_id
					end
				end
			end
		end
	end
	
	for iter_54_18, iter_54_19 in pairs(arg_54_0.road_object_tbl) do
		iter_54_19.is_single_sector = arg_54_0.is_single_sector_stage or iter_54_19.is_cross or iter_54_19.road_type == "goblin"
	end
	
	local function var_54_25(arg_55_0, arg_55_1)
		if type(arg_55_0) ~= "table" then
			return 
		end
		
		if type(arg_55_0.info_group) == "table" then
			return table.isInclude(arg_55_0.info_group, arg_55_1), arg_55_0
		else
			for iter_55_0, iter_55_1 in pairs(arg_55_0) do
				if iter_55_1.info_group then
					return table.isInclude(iter_55_1.info_group, arg_55_1), iter_55_1
				end
			end
		end
	end
	
	local var_54_26 = arg_54_0.init_opts.ignore_road_events or {}
	local var_54_27 = (arg_54_0.init_opts.clear_event_list or {})[arg_54_0.enter_road_id] or {}
	local var_54_28 = UID_MAPNPCMOB_PREFIX
	
	for iter_54_20, iter_54_21 in pairs(var_54_1) do
		local var_54_29 = assert(arg_54_0.road_object_tbl[iter_54_20])
		local var_54_30 = {}
		local var_54_31 = {}
		local var_54_32 = 0
		local var_54_33 = 0
		
		for iter_54_22, iter_54_23 in pairs(iter_54_21) do
			var_54_28 = var_54_28 - 100
			
			local var_54_34 = var_54_29.is_single_sector and 1 or #var_54_30 + 1
			local var_54_35 = {
				road_id = iter_54_20,
				sector_no = var_54_34,
				is_last = iter_54_22 == #iter_54_21,
				unit_mobsid_prefix = var_54_28,
				is_single_sector = var_54_29.is_single_sector,
				contents_type = arg_54_0.contents_type
			}
			local var_54_36 = table.clone(iter_54_23)
			
			if var_54_26[iter_54_20] then
				local var_54_37 = string.gsub(var_54_36.id or "", "#", "_")
				
				if not var_54_27[var_54_37] then
					var_54_36.id = var_54_37
					var_54_36.type = "empty"
					var_54_36.exp = 0
					var_54_36.base_drop = {}
					var_54_36.mobs = {}
					var_54_36.value = {}
				end
			end
			
			local var_54_38 = RoadEvent:create(var_54_36, var_54_35)
			
			if arg_54_0.road_event_object_tbl[var_54_38.event_id] then
				error(road_info_id, "duplicate road_event_object.event_id ", var_54_38.event_id)
			end
			
			arg_54_0.road_event_object_tbl[var_54_38.event_id] = var_54_38
			
			local var_54_39 = arg_54_0.parsed_opts.group
			local var_54_40, var_54_41 = var_54_25(var_54_39, var_54_38.sector_id)
			
			if var_54_40 then
				local var_54_42 = var_54_39.group_name or "default"
				
				if not arg_54_0.replace_road_event_object_tbl[var_54_42 .. var_54_36.id] then
					local var_54_43 = {
						group_expired = true,
						type = "npc",
						id = var_54_36.id,
						room = var_54_36.room,
						value = {
							npc = var_54_41.change_npc
						}
					}
					
					arg_54_0.replace_road_event_object_tbl[var_54_42 .. var_54_36.id] = RoadEvent:create(var_54_43, var_54_35)
				end
			end
			
			local var_54_44 = arg_54_0.road_sector_object_tbl[var_54_38.sector_id]
			
			if not var_54_44 then
				var_54_44 = {
					road_id = iter_54_20,
					sector_no = #var_54_30 + 1,
					sector_id = var_54_38.sector_id,
					event_list = {}
				}
				arg_54_0.road_sector_object_tbl[var_54_38.sector_id] = var_54_44
				
				table.insert(var_54_30, var_54_44)
				
				var_54_33 = math.max(var_54_33, var_54_38.group_no)
			end
			
			var_54_32 = var_54_32 + 1
			
			table.insert(var_54_44.event_list, var_54_38)
			table.insert(var_54_31, var_54_38)
		end
		
		var_54_29.main_sector_object = var_54_30[1]
		var_54_29.event_count = var_54_32
		var_54_29.event_object_list = var_54_31
		var_54_29.sector_count = #var_54_30
		var_54_29.sector_object_list = var_54_30
	end
	
	local var_54_45 = arg_54_0.parsed_opts.lock_door
	
	if var_54_45 then
		local var_54_46 = {}
		
		for iter_54_24, iter_54_25 in pairs(var_54_45) do
			if var_54_46[iter_54_25.info] then
				table.insert(var_54_46[iter_54_25.info], iter_54_25)
			else
				var_54_46[iter_54_25.info] = {
					iter_54_25
				}
			end
		end
		
		for iter_54_26, iter_54_27 in pairs(var_54_46) do
			local var_54_47 = assert(arg_54_0.road_object_tbl[iter_54_26])
			
			var_54_47.lock_info = iter_54_27
			var_54_47.main_sector_object.lock_info = iter_54_27
		end
	end
	
	if arg_54_0.prev_road_id then
		local var_54_48 = assert(arg_54_0.road_object_tbl[arg_54_0.prev_road_id]).main_sector_object.sector_id
		
		arg_54_0.initial_pass_sector[var_54_48] = true
	end
	
	arg_54_0.total_road_sector_count = 0
	
	for iter_54_28, iter_54_29 in pairs(arg_54_0.road_object_tbl) do
		arg_54_0.total_road_sector_count = arg_54_0.total_road_sector_count + iter_54_29.sector_count
	end
	
	local var_54_49 = table.clone(arg_54_1.trial_info or {})
	
	if not table.empty(var_54_49) then
		arg_54_0.trial_info = var_54_49
		arg_54_0.trial_info.benefit = string.split(arg_54_0.trial_info.benefit or "", ";")
		arg_54_0.trial_info.penalty = string.split(arg_54_0.trial_info.penalty or "", ";")
	end
	
	local var_54_50 = arg_54_1.expedition_info
	
	if var_54_50 then
		arg_54_0.expedition_info = var_54_50
	end
	
	arg_54_0.lota_info = arg_54_1.lota_info
end

function BattleStageMap.getRoadEventObject(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_1 then
		return 
	end
	
	local var_56_0 = arg_56_0.road_event_object_tbl[arg_56_1]
	
	if arg_56_2 then
		return arg_56_0.replace_road_event_object_tbl[arg_56_2 .. arg_56_1]
	end
	
	return var_56_0
end

function BattleStageMap.getCrossRoadList(arg_57_0)
	local var_57_0 = {}
	
	for iter_57_0, iter_57_1 in pairs(arg_57_0.cross_road_tbl) do
		table.insert(var_57_0, iter_57_1)
	end
	
	return var_57_0
end

function BattleStageMap.isCrossRoad(arg_58_0, arg_58_1)
	return arg_58_0.cross_road_tbl[arg_58_1]
end

function BattleStageMap.getRoadObjectList(arg_59_0)
	local var_59_0 = {}
	
	for iter_59_0, iter_59_1 in pairs(arg_59_0.road_object_tbl) do
		table.insert(var_59_0, iter_59_1)
	end
	
	return var_59_0
end

function BattleStageMap.getRoadObject(arg_60_0, arg_60_1)
	if not arg_60_1 then
		return 
	end
	
	return arg_60_0.road_object_tbl[arg_60_1]
end

function BattleStageMap.getRoadMazeData(arg_61_0, arg_61_1)
	if not arg_61_1 then
		return 
	end
	
	return arg_61_0.maze_object_tbl[arg_61_1]
end

function BattleStageMap.getRoadEventObjectList(arg_62_0, arg_62_1)
	if not arg_62_1 then
		return 
	end
	
	local var_62_0 = arg_62_0.road_object_tbl[arg_62_1]
	
	return var_62_0 and var_62_0.event_object_list or {}
end

function BattleStageMap.getRoadSectorObject(arg_63_0, arg_63_1)
	if not arg_63_1 then
		return 
	end
	
	return arg_63_0.road_sector_object_tbl[arg_63_1]
end

function BattleStageMap.getRoadSectorObjectList(arg_64_0, arg_64_1)
	if not arg_64_1 then
		return 
	end
	
	local var_64_0 = arg_64_0.road_object_tbl[arg_64_1]
	
	return var_64_0 and var_64_0.sector_object_list or {}
end

function var_0_3.makeLogic(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	return (var_0_3:new(arg_65_1, arg_65_2, arg_65_3 or {}))
end

function var_0_3.insertAttackOrder(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7)
	if arg_66_1:isSummon() then
		return 
	end
	
	if arg_66_1.states:isExistEffect("CSP_ADDSKILL_BLOCK") then
		return 
	end
	
	local var_66_0 = arg_66_7 or {}
	local var_66_1 = var_66_0.trigger_eff
	local var_66_2 = var_66_0.unique_group
	
	if var_66_2 then
		for iter_66_0, iter_66_1 in pairs(arg_66_0.turn_info.attack_order) do
			if iter_66_1.attacker == arg_66_1 and iter_66_1.skill_id == arg_66_3 and string.starts(iter_66_1.trigger_eff or "", var_66_2) then
				return false
			end
		end
	end
	
	local var_66_3 = 2
	
	for iter_66_2, iter_66_3 in pairs(arg_66_0.turn_info.attack_order) do
		if var_66_3 <= iter_66_2 and iter_66_3.insert_block and iter_66_3.attacker == arg_66_1 then
			var_66_3 = iter_66_2 + 1
		end
	end
	
	local var_66_4 = math.min(#arg_66_0.turn_info.attack_order + 1, var_66_3)
	local var_66_5 = (DB("skill", arg_66_3, "point_require") or 0) > 0
	
	if not arg_66_2 then
		local var_66_6 = arg_66_0:getAttackInfo(arg_66_1)
		
		if var_66_6 then
			arg_66_2 = var_66_6.d_unit
		end
	end
	
	table.insert(arg_66_0.turn_info.attack_order, var_66_4, {
		attacker = arg_66_1,
		target = arg_66_2,
		skill_id = arg_66_3,
		hidden = arg_66_4,
		insert_block = var_66_5,
		invokers = arg_66_5,
		counter = arg_66_6,
		trigger_eff = var_66_1
	})
	
	return var_66_4
end

function var_0_3.getAttackOrder(arg_67_0)
	if not arg_67_0.turn_info.attack_order then
		return {}
	end
	
	return arg_67_0.turn_info.attack_order[1]
end

function var_0_3.isPVP(arg_68_0)
	return arg_68_0.pvp
end

function var_0_3.isDescent(arg_69_0)
	return arg_69_0.map.is_descent
end

function var_0_3.isBurning(arg_70_0)
	return arg_70_0.map.is_burning
end

function var_0_3.isTournament(arg_71_0)
	if arg_71_0.tournament_id then
		return true
	end
	
	return false
end

function var_0_3.getTournamentID(arg_72_0)
	return arg_72_0.tournament_id
end

function var_0_3.isClanWar(arg_73_0)
	return arg_73_0.clan_war
end

function var_0_3.isSkillPreview(arg_74_0)
	return arg_74_0.skill_preview
end

function var_0_3.isAutomaton(arg_75_0)
	return arg_75_0.stageMap.contents_type == "automaton"
end

function var_0_3.isAbyss(arg_76_0)
	return DB("level_enter", arg_76_0.map.enter, "type") == "abyss"
end

function var_0_3.isDungeonType(arg_77_0)
	return string.starts(arg_77_0.type, "dungeon")
end

function var_0_3.isCoop(arg_78_0)
	return string.starts(arg_78_0.type, "coop")
end

function var_0_3.isCreviceHunt(arg_79_0)
	return arg_79_0.map.crehunt_difficulty ~= nil
end

function var_0_3.getCreviceHuntDifficulty(arg_80_0)
	if not arg_80_0.map then
		return nil
	end
	
	return arg_80_0.map.crehunt_difficulty
end

function var_0_3.isPreviewQuest(arg_81_0)
	if arg_81_0.battle_info.force_preview_mode then
		return true
	end
	
	return string.starts(arg_81_0.type, "preview_quest")
end

function var_0_3.isNeedToUpdateHP(arg_82_0)
	if string.find(arg_82_0.map.enter, "auto") then
		return false
	end
	
	return DB("level_enter", arg_82_0.map.enter, "full_hp") ~= "y"
end

function var_0_3.getContentsType(arg_83_0)
	return arg_83_0.type, arg_83_0.stageMap.contents_type
end

function var_0_3.getBattleCheckUID(arg_84_0)
	local var_84_0 = arg_84_0:getBattleUID()
	
	return (tonumber(string.sub(tostring(var_84_0), 7, -1)))
end

function var_0_3.getBattleUID(arg_85_0)
	if arg_85_0.map and arg_85_0.map.battle_uid then
		return arg_85_0.map.battle_uid
	end
	
	return 0
end

function var_0_3.isSequenceType(arg_86_0, arg_86_1)
	return assert(arg_86_0:getRoadObject(arg_86_1)).is_single_sector
end

function var_0_3.isDestiny(arg_87_0)
	if arg_87_0.map and arg_87_0.map.enter then
		return string.starts(arg_87_0.map.enter, "sbc")
	end
	
	return false
end

function var_0_3.isSavable(arg_88_0)
	if arg_88_0:isTutorial() then
		return 
	end
	
	if arg_88_0:isPVP() then
		return 
	end
	
	if arg_88_0:isDestiny() then
		return 
	end
	
	if arg_88_0:isNPCTeam() then
		return 
	end
	
	return true
end

function var_0_3.isNeedToStartWithFullHP(arg_89_0)
	return not arg_89_0:isNeedToUpdateHP()
end

function var_0_3.isTutorial(arg_90_0)
	return arg_90_0.mode == "tutorial"
end

function var_0_3.isViewPlayerActive(arg_91_0)
	return arg_91_0:isRealtimeMode() or arg_91_0:isViewerMode()
end

function var_0_3.isRealtimeMode(arg_92_0)
	return arg_92_0.mode == "net_rank" or arg_92_0.mode == "net_friend" or arg_92_0.mode == "net_event_rank" or arg_92_0.mode == "net_server" or arg_92_0.mode == "net_local_test" or arg_92_0.mode == "ai_agent"
end

function var_0_3.isViewerMode(arg_93_0)
	return arg_93_0.mode == "replay" or arg_93_0.mode == "spectator"
end

function var_0_3.isEnableRtaPenalty(arg_94_0)
	return arg_94_0.service and arg_94_0.service:isEnableRtaPenalty()
end

function var_0_3.isDualControl(arg_95_0)
	return arg_95_0.dual_control
end

function var_0_3.getBuffTargetHero(arg_96_0)
	return arg_96_0.map.buff_target_hero
end

function var_0_3.getKeySlotPos(arg_97_0)
	return arg_97_0.map.key_slot_pos
end

function var_0_3.getKeySlotUnit(arg_98_0)
	if arg_98_0.map.key_slot_pos then
		for iter_98_0, iter_98_1 in pairs(arg_98_0.friends) do
			if iter_98_1.inst.pos == arg_98_0.map.key_slot_pos then
				return iter_98_1
			end
		end
	end
end

function var_0_3.getStageMainType(arg_99_0)
	return arg_99_0.stageMap.main_type
end

function var_0_3.isHiddenTurn(arg_100_0)
	if arg_100_0.road_event_run_info.state_name ~= "running" then
		return 
	end
	
	if not arg_100_0.turn_info or not arg_100_0.turn_info.attack_order then
		return 
	end
	
	return #arg_100_0.turn_info.attack_order > 0 and arg_100_0.turn_info.attack_order[1].hidden == true
end

function var_0_3.getFinalResult(arg_101_0)
	if arg_101_0.last_stage_result == "lose" then
		return "lose"
	end
	
	if arg_101_0.force_finish_target then
		return arg_101_0.last_stage_result
	end
	
	if not arg_101_0:isCompletedLastRoadEvent() then
		return nil
	end
	
	return arg_101_0.last_stage_result
end

function var_0_3.isEnded(arg_102_0)
	return arg_102_0.last_stage_result == "lose" or arg_102_0:isCompletedLastRoadEvent()
end

function var_0_3.nextStage(arg_103_0)
	return false
end

function var_0_3.setCompleteRoadEvent(arg_104_0, arg_104_1)
	local var_104_0 = arg_104_0:getRoadEventObject(arg_104_1)
	
	if not var_104_0 then
		return 
	end
	
	if not var_104_0.group_expired then
		arg_104_0.battle_info.completed_road_event_tbl[arg_104_1] = true
	end
	
	if var_104_0.type == "npc" then
		local var_104_1 = arg_104_0.battle_info.npc_road_event_tbl[arg_104_1]
		
		if var_104_1 then
			local var_104_2 = arg_104_0.battle_info.results_road_event_tbl[arg_104_1]
			
			if not var_104_2 then
				var_104_2 = {}
				arg_104_0.battle_info.results_road_event_tbl[arg_104_1] = var_104_2
			end
			
			var_104_2[var_104_1] = (var_104_2[var_104_1] or 0) + 1
		end
	end
	
	arg_104_0:onInfos({
		type = "@complete_road_event",
		road_event_id = arg_104_1
	})
end

function var_0_3.getLastRoadEventObject(arg_105_0)
	if not arg_105_0.battle_info.road_info.road_id then
		return 
	end
	
	local var_105_0 = arg_105_0:getRoadEventObjectList(arg_105_0.battle_info.road_info.road_id)
	
	return var_105_0[#var_105_0]
end

function var_0_3.isLastRoadEvent(arg_106_0)
	local var_106_0 = arg_106_0:getRoadEventObject(arg_106_0.road_event_run_info.road_event_id)
	
	return var_106_0 and var_106_0.is_last
end

function var_0_3.getRoadEventExtraInfo(arg_107_0, arg_107_1)
	return {
		results = arg_107_0.battle_info.results_road_event_tbl[arg_107_1],
		npc_id = arg_107_0.battle_info.npc_road_event_tbl[arg_107_1],
		completed = arg_107_0.battle_info.completed_road_event_tbl[arg_107_1]
	}
end

function var_0_3.isCompletedLastRoadEvent(arg_108_0)
	if string.starts(arg_108_0.type, "dungeon") then
		return 
	end
	
	local var_108_0 = arg_108_0.battle_info.road_info.road_type
	
	if var_108_0 == "goblin" or var_108_0 == "chaos" then
		return 
	end
	
	local var_108_1 = arg_108_0:getLastRoadEventObject()
	
	if not var_108_1 then
		return 
	end
	
	return arg_108_0:isCompletedRoadEvent(var_108_1.event_id)
end

function var_0_3.isExistBattle(arg_109_0, arg_109_1)
	local var_109_0 = arg_109_0:getRoadEventObjectList(arg_109_1)
	
	for iter_109_0, iter_109_1 in pairs(var_109_0) do
		if iter_109_1:isBattleType() then
			return not arg_109_0:isCompletedRoadEvent(iter_109_1.event_id)
		end
	end
end

function var_0_3.isCompletedRoadBattle(arg_110_0, arg_110_1)
	local var_110_0 = arg_110_0:getRoadEventObjectList(arg_110_1)
	local var_110_1 = false
	local var_110_2 = true
	
	for iter_110_0, iter_110_1 in pairs(var_110_0) do
		if iter_110_1:isBattleType() then
			var_110_1 = true
			
			if not arg_110_0:isCompletedRoadEvent(iter_110_1.event_id) then
				var_110_2 = false
			end
		end
	end
	
	return var_110_1 and var_110_2
end

function var_0_3.getElapsedTick(arg_111_0)
	return arg_111_0.tick
end

function var_0_3.getStageCounter(arg_112_0)
	return arg_112_0.stage_counter or 0
end

function var_0_3.getTeamStageCounter(arg_113_0, arg_113_1)
	return arg_113_0.team_stage_counter[arg_113_1 or FRIEND] or 0
end

function var_0_3.getStageUserCounter(arg_114_0, arg_114_1)
	return (arg_114_0.user_turn_counter or {})[arg_114_1]
end

local function var_0_12(arg_115_0, arg_115_1)
	return arg_115_0[2] < arg_115_1[2]
end

function var_0_3.getAliveUnitMap(arg_116_0)
	local var_116_0 = {}
	
	for iter_116_0, iter_116_1 in pairs(arg_116_0.units) do
		if not iter_116_1:isDead() then
			var_116_0[iter_116_1] = true
		end
	end
	
	return var_116_0
end

function var_0_3.predictAttackers(arg_117_0)
	local var_117_0 = {}
	
	for iter_117_0, iter_117_1 in pairs(arg_117_0.units) do
		if not iter_117_1:isDead() then
			local var_117_1, var_117_2 = iter_117_1:getRestTimeAndTick()
			
			table.push(var_117_0, {
				iter_117_1,
				var_117_2 + iter_117_1:getTurnTick() * 0
			})
		end
	end
	
	table.sort(var_117_0, var_0_12)
	
	for iter_117_2 = 1, #var_117_0 do
		var_117_0[iter_117_2] = var_117_0[iter_117_2][1]
	end
	
	return var_117_0
end

function var_0_3.getTurnOwner(arg_118_0)
	return arg_118_0.turn_info.turn_owner
end

function var_0_3.fatalStop(arg_119_0, arg_119_1)
	arg_119_0:stopBattleFSM()
	
	arg_119_0.road_event_run_info.state_name = "finish"
	arg_119_0.road_event_run_info.pending_list = {}
	arg_119_0.last_stage_result = arg_119_1 or "lose"
end

function var_0_3.resume(arg_120_0, arg_120_1)
	local var_120_0 = arg_120_1 or "default"
	
	arg_120_0._paused[var_120_0] = nil
end

function var_0_3.pause(arg_121_0, arg_121_1)
	local var_121_0 = arg_121_1 or "default"
	
	arg_121_0._paused[var_121_0] = true
end

function var_0_3.proc(arg_122_0)
	if arg_122_0:isEnded() then
		return 
	end
	
	if not arg_122_0._paused.default and arg_122_0.road_event_run_info then
		if arg_122_0.road_event_run_info.state_name == "running" then
			arg_122_0:processRoadEvent()
		elseif not table.empty(arg_122_0.road_event_run_info.pending_list) then
			arg_122_0:executeRoadEvent()
		end
	end
	
	if arg_122_0.pre_road_event_state ~= arg_122_0.road_event_run_info.state_name then
		arg_122_0.pre_road_event_state = arg_122_0.road_event_run_info.state_name
	end
	
	if arg_122_0.pre_turn_state ~= arg_122_0:getTurnState() then
		arg_122_0.pre_turn_state = arg_122_0:getTurnState()
	end
end

function var_0_3.executeRoadEvent(arg_123_0)
	local var_123_0 = table.remove(arg_123_0.road_event_run_info.pending_list, 1)
	
	arg_123_0.road_event_run_info.road_event_id = var_123_0
	
	local var_123_1 = arg_123_0:getRoadEventObject(var_123_0)
	
	if not var_123_1 then
		return 
	end
	
	local var_123_2 = var_123_1.type
	local var_123_3, var_123_4 = arg_123_0:isExpiredGroupEvent(var_123_1.sector_id)
	
	if var_123_3 then
		arg_123_0:onInfos({
			type = "@encounter_road_event",
			road_event_id = var_123_0,
			event_param = {
				npc_id = var_123_4.change_npc
			}
		})
	elseif var_123_1:isBattleType() then
		arg_123_0:onInfos({
			type = "@encounter_road_event",
			road_event_id = var_123_0
		})
		arg_123_0:onEncounterEnemy(var_123_0)
	elseif var_123_2 == "empty" or var_123_2 == "start" then
		arg_123_0:onInfos({
			type = "@encounter_road_event",
			road_event_id = var_123_0
		})
	elseif var_123_2 == "npc" then
		local var_123_5 = assert(var_123_1.value.npc)
		local var_123_6
		local var_123_7
		
		for iter_123_0 = 1, 20 do
			var_123_6 = string.format("%s_%d", var_123_5, iter_123_0)
			
			local var_123_8 = DB("level_npc", var_123_6, "mission_id")
			local var_123_9 = arg_123_0:getMissionState(var_123_8)
			
			if not var_123_8 or var_123_9 == "clear" or var_123_9 == "received" then
				break
			end
		end
		
		arg_123_0.battle_info.npc_road_event_tbl[var_123_0] = var_123_6
		
		arg_123_0:onInfos({
			type = "@encounter_road_event",
			road_event_id = var_123_0,
			event_param = {
				npc_id = var_123_6
			}
		})
	elseif arg_123_0:isObjectType(var_123_2) then
		arg_123_0:onInfos({
			type = "@encounter_road_event",
			road_event_id = var_123_0
		})
	end
	
	return var_123_1
end

function var_0_3.procEvent(arg_124_0)
	if not arg_124_0.stateProc then
		arg_124_0.stateProc = {
			next = function()
				local var_125_0 = arg_124_0:next_turn()
				
				if (arg_124_0:getAttackOrder() or {}).skill_id then
					arg_124_0:procBattleEvent("next_attack_order")
				else
					arg_124_0:procBattleEvent("pending_start")
				end
			end,
			pending_start = function()
				arg_124_0:doStartTurn()
			end,
			pending_ready = function()
				arg_124_0:doReadyAttack()
			end,
			pending_end = function()
				arg_124_0:doEndTurn()
			end,
			next_attack_order = function()
				arg_124_0:doNextAttackOrder()
			end,
			attack = function()
			end,
			ended = function()
				arg_124_0:doNextTurn()
			end,
			ready = function()
				arg_124_0:doPlayUnit()
			end
		}
	end
	
	local var_124_0 = arg_124_0.stateProc[arg_124_0.turn_info.state]
	
	if var_124_0 then
		var_124_0()
	end
	
	arg_124_0:sortUnitStates("proc")
end

function var_0_3.processRoadEvent(arg_133_0)
	if not arg_133_0.turn_info.state then
		return 
	end
	
	if arg_133_0.mode == "net_local_test" or arg_133_0.mode == "net_rank" or arg_133_0.mode == "net_event_rank" or arg_133_0.mode == "net_friend" or arg_133_0.mode == "replay" then
		return 
	end
	
	arg_133_0:procEvent()
end

function var_0_3.procBattleEvent(arg_134_0, arg_134_1)
	arg_134_0.turn_info.state = arg_134_1
end

function var_0_3.proc_until_by_turn(arg_135_0)
	local var_135_0 = {}
	
	while true do
		repeat
			arg_135_0:proc()
		until arg_135_0:getTurnState() ~= "ended"
		
		local var_135_1 = arg_135_0.logger:popAll()
		
		if table.empty(var_135_1) then
			break
		end
		
		for iter_135_0, iter_135_1 in pairs(var_135_1) do
			table.insert(var_135_0, iter_135_1)
		end
	end
	
	return var_135_0
end

function var_0_3.proc_until_by_turn_state(arg_136_0, arg_136_1)
	local var_136_0 = 1
	
	while arg_136_0.turn_info and arg_136_0.turn_info.state and arg_136_0.turn_info.state ~= arg_136_1 do
		arg_136_0:proc()
		
		var_136_0 = var_136_0 + 1
		
		if var_136_0 > 1000 then
			Log.e(arg_136_0.name, arg_136_1 .. " 상태가 오질 않네요. 다른 상태 이름을 지정해 보세요 ")
			
			break
		end
	end
end

function var_0_3.next_turn(arg_137_0)
	if arg_137_0:getStageCounter() == 0 then
		local var_137_0 = {}
		
		for iter_137_0, iter_137_1 in pairs(arg_137_0.units) do
			local var_137_1 = MAX_UNIT_TICK * iter_137_1.states:getAllEffValue("CSP_BATTLESTART_AB_UP_PLAYABLE")
			
			if var_137_1 > 0 then
				iter_137_1:modifyElapsedTime(var_137_0, var_137_1, iter_137_1)
			end
			
			local var_137_2 = MAX_UNIT_TICK * iter_137_1.states:getAllEffValue("CSP_BATTLESTART_AB_UP")
			
			if var_137_2 > 0 then
				iter_137_1.inst.elapsed_ut = iter_137_1.inst.elapsed_ut + var_137_2
			end
		end
		
		arg_137_0:onInfos(table.unpack(var_137_0))
	end
	
	local var_137_3 = {}
	local var_137_4 = table.remove(arg_137_0.turn_info.next_queue, 1)
	local var_137_5 = math.huge
	local var_137_6
	local var_137_7
	local var_137_8
	
	if var_137_4 then
		var_137_5 = 0
		var_137_6 = var_137_4.unit
		var_137_7 = var_137_4.skill_id
		var_137_8 = var_137_4.add_more
	else
		for iter_137_2, iter_137_3 in pairs(arg_137_0.units) do
			if not iter_137_3:isDead() then
				local var_137_9, var_137_10 = iter_137_3:getRestTimeAndTick()
				
				if var_137_9 <= 0 then
					table.push(var_137_3, {
						unit = iter_137_3,
						ut = var_137_9,
						tick = var_137_10
					})
				end
				
				if var_137_10 < var_137_5 then
					var_137_5 = var_137_10
					var_137_6 = iter_137_3
				end
			end
		end
		
		if #var_137_3 > 0 then
			table.sort(var_137_3, function(arg_138_0, arg_138_1)
				if arg_138_0.ut == arg_138_1.ut then
					return arg_138_0.unit.status.speed > arg_138_1.unit.status.speed
				end
				
				return arg_138_0.ut < arg_138_1.ut
			end)
			
			var_137_5 = var_137_3[1].tick
			var_137_6 = var_137_3[1].unit
		end
	end
	
	local var_137_11 = math.max(0, var_137_5)
	
	for iter_137_4, iter_137_5 in pairs(arg_137_0.units) do
		if not iter_137_5:isDead() then
			iter_137_5:incTurn(var_137_11)
		end
	end
	
	arg_137_0.turn_info.turn_owner = var_137_6
	arg_137_0.turn_info.rest_tick = var_137_5
	arg_137_0.turn_info.is_add_more = var_137_8
	arg_137_0.turn_info.attack_order = {
		{
			attacker = var_137_6,
			skill_id = var_137_7
		}
	}
	arg_137_0.turn_info.attack_stats = {}
	arg_137_0.turn_info.skill_history = {}
	arg_137_0.turn_info.unique_flag = {}
	arg_137_0.tick = arg_137_0.tick + var_137_11
	
	var_0_9(arg_137_0.friends)
	var_0_9(arg_137_0.enemies)
	
	return var_137_5
end

function var_0_3.makeUniqueFlagKey(arg_139_0, arg_139_1, arg_139_2)
	if not arg_139_1 then
		return 
	end
	
	local var_139_0 = string.split(arg_139_1, ",")
	local var_139_1 = var_139_0[1]
	local var_139_2 = var_139_0[2] or "each"
	
	return string.format("%s:%s:%s", var_139_1, var_139_2, arg_139_2)
end

function var_0_3.checkUniqueFlag(arg_140_0, arg_140_1, arg_140_2)
	if not arg_140_1 or not arg_140_2 then
		return true
	end
	
	arg_140_0.turn_info.unique_flag[arg_140_1] = arg_140_0.turn_info.unique_flag[arg_140_1] or {}
	
	return not arg_140_0.turn_info.unique_flag[arg_140_1][arg_140_2:getUID()]
end

function var_0_3.setUniqueFlag(arg_141_0, arg_141_1, arg_141_2)
	if not arg_141_1 or not arg_141_2 then
		return 
	end
	
	arg_141_0.turn_info.unique_flag[arg_141_1] = arg_141_0.turn_info.unique_flag[arg_141_1] or {}
	arg_141_0.turn_info.unique_flag[arg_141_1][arg_141_2:getUID()] = true
end

function var_0_3.flushUniqueFlag(arg_142_0, arg_142_1)
	if not arg_142_1 then
		return 
	end
	
	local var_142_0 = {}
	
	for iter_142_0, iter_142_1 in pairs(arg_142_0.turn_info.unique_flag or {}) do
		if (string.split(iter_142_0, ":")[2] or "") == arg_142_1 then
			table.insert(var_142_0, iter_142_0)
		end
	end
	
	for iter_142_2, iter_142_3 in pairs(var_142_0) do
		arg_142_0.turn_info.unique_flag[iter_142_3] = nil
	end
end

function var_0_3.findUnit(arg_143_0, arg_143_1)
	for iter_143_0, iter_143_1 in ipairs(arg_143_0.units) do
		if iter_143_1.inst.uid == arg_143_1 then
			return iter_143_1
		end
	end
	
	return nil
end

function var_0_3.findUnitIndex(arg_144_0, arg_144_1)
	for iter_144_0, iter_144_1 in ipairs(arg_144_0.units) do
		if iter_144_1 == arg_144_1 then
			return iter_144_0
		end
	end
	
	return nil
end

function var_0_3.getTurnInfoSkillHistory(arg_145_0)
	if arg_145_0.turn_info then
		return arg_145_0.turn_info.skill_history
	end
end

function var_0_3.procExp(arg_146_0)
	local var_146_0 = assert(arg_146_0:getRunningRoadEventObject())
	local var_146_1 = false
	
	if arg_146_0.stageMap and arg_146_0.stageMap.contents_type then
		var_146_1 = arg_146_0.stageMap.contents_type == "adventure" or arg_146_0.stageMap.contents_type == "substory"
	end
	
	local var_146_2 = var_146_0.exp or 0
	local var_146_3 = #arg_146_0.starting_friends
	local var_146_4 = var_146_2 / var_146_3
	local var_146_5 = 0
	local var_146_6 = 0
	local var_146_7 = {}
	local var_146_8 = {}
	
	for iter_146_0, iter_146_1 in pairs(arg_146_0.starting_friends) do
		local var_146_9 = GAME_STATIC_VARIABLE[string.format("bonus_exp_%s", iter_146_1.db.code)]
		local var_146_10 = 1
		
		if var_146_9 then
			var_146_10 = var_146_10 + var_146_9
		end
		
		local var_146_11 = math.floor(var_146_4 * var_146_10) or 0
		
		if iter_146_1:isMaxLevel() and not var_146_1 then
			var_146_5 = var_146_5 + 1
			var_146_6 = var_146_6 + var_146_11
			var_146_8[iter_146_1.db.code] = var_146_11
		else
			var_146_7[iter_146_1.db.code] = var_146_11
		end
	end
	
	local var_146_12 = 0
	
	if var_146_3 - var_146_5 > 0 then
		var_146_12 = var_146_6 * 0.5 / (var_146_3 - var_146_5)
	end
	
	for iter_146_2, iter_146_3 in pairs(arg_146_0.starting_friends) do
		local var_146_13 = iter_146_3:getEXPRatio()
		local var_146_14 = iter_146_3.inst.exp
		local var_146_15 = iter_146_3:isContentEnhance()
		local var_146_16 = iter_146_3:isMaxLevel()
		local var_146_17 = var_146_7[iter_146_3.db.code]
		local var_146_18 = var_146_8[iter_146_3.db.code]
		
		if var_146_17 and not var_146_16 then
			local var_146_19 = var_146_17 + var_146_12
			
			if var_146_15 and not arg_146_0:isEnded() then
				iter_146_3:addContentEnhanceExp(var_146_19)
			else
				if var_146_15 then
					var_146_19 = var_146_19 + iter_146_3:getContentEnhanceExp()
					
					iter_146_3:resetContentEnhanceExp()
				end
				
				local var_146_20 = iter_146_3:addExp(var_146_19)
				local var_146_21 = iter_146_3:getEXPRatio()
				
				if var_146_20 or var_146_13 ~= var_146_21 then
					arg_146_0:onInfos({
						type = "exp",
						target = iter_146_3,
						levelup = var_146_20,
						exp = var_146_19,
						from = var_146_13,
						to = var_146_21,
						prev_exp = var_146_14,
						dist_exp = var_146_12
					})
				end
			end
		elseif var_146_17 and var_146_16 then
			if var_146_17 > 0 and iter_146_3:getGrade() < 5 and not iter_146_3:isNPC() then
				arg_146_0:onInfos({
					text = "max_exp",
					type = "text",
					target = iter_146_3
				})
			end
		elseif var_146_18 and var_146_18 > 0 and iter_146_3:getGrade() < 5 and not iter_146_3:isNPC() then
			arg_146_0:onInfos({
				text = "max_exp",
				type = "text",
				target = iter_146_3
			})
		end
	end
end

function var_0_3.getHPRatio(arg_147_0, arg_147_1)
	local var_147_0 = arg_147_0.friends
	
	if arg_147_1 == ENEMY then
		var_147_0 = arg_147_0.enemies
	end
	
	local var_147_1 = 0
	local var_147_2 = 0
	
	for iter_147_0, iter_147_1 in pairs(var_147_0) do
		var_147_2 = var_147_2 + iter_147_1.inst.hp
		var_147_1 = var_147_1 + iter_147_1:getMaxHP()
	end
	
	return var_147_2 / var_147_1
end

function var_0_3.procResurrect(arg_148_0)
	local var_148_0 = {}
	local var_148_1 = {}
	
	for iter_148_0, iter_148_1 in pairs(arg_148_0.units) do
		if iter_148_1:isDead() then
			if not iter_148_1.states:isExistEffect("CSP_IMMUNE_REVIVE_BLOCK") and iter_148_1.states:findByEff("REVIVE_FORBID") then
				iter_148_1.inst.resurrect_hp_ratio = nil
			end
			
			if iter_148_1:isResurrectionReserved() then
				local var_148_2, var_148_3 = arg_148_0:spawnUnit(iter_148_1, nil, true)
				
				iter_148_1:resurrect(nil, var_148_0)
				table.insert(var_148_0, {
					type = "resurrect",
					dead_unit = var_148_2,
					unit = iter_148_1,
					dead_index = var_148_3
				})
				table.insert(var_148_1, iter_148_1)
			end
		end
	end
	
	for iter_148_2, iter_148_3 in pairs(var_148_1) do
		iter_148_3.turn_vars.actionbar_dirty = true
		
		arg_148_0:updateAura(var_148_0)
		iter_148_3:afterResurrect(var_148_0)
	end
	
	arg_148_0:onInfos(table.unpack(var_148_0))
end

function var_0_3.onAddedPassiveBlock(arg_149_0, arg_149_1, arg_149_2)
	local var_149_0 = {}
	local var_149_1 = arg_149_2 or 0
	
	arg_149_0:updateAura(var_149_0, nil, var_149_1)
	arg_149_0:onInfos(table.unpack(var_149_0))
end

function var_0_3.onRemovedPassiveBlock(arg_150_0, arg_150_1)
	local var_150_0 = {}
	
	arg_150_0:updateAura(var_150_0)
	
	for iter_150_0, iter_150_1 in pairs(arg_150_0.units) do
		table.add(var_150_0, iter_150_1.states:onToggle())
	end
	
	arg_150_0:onInfos(table.unpack(var_150_0))
end

function var_0_3.updateAura(arg_151_0, arg_151_1, arg_151_2, arg_151_3)
	local var_151_0 = {}
	
	if arg_151_3 then
		arg_151_3 = arg_151_3 + 1
		
		if arg_151_3 > 2 then
			return 
		end
	end
	
	for iter_151_0, iter_151_1 in pairs(arg_151_0.units) do
		for iter_151_2 = 1, #iter_151_1.states.List do
			local var_151_1 = iter_151_1.states.List[iter_151_2]
			
			if not iter_151_1:isDead() and (var_151_1.db.cs_timing == 19 or var_151_1.db.cs_timing == 119) then
				local var_151_2 = arg_151_0:getAuraTargetInfo(var_151_1, iter_151_1)
				
				if var_151_2 then
					var_151_2.aura = var_151_1
					
					if var_151_1:isPassiveBlocked() then
						var_151_2.isPassiveBlock = true
					end
					
					table.insert(var_151_0, var_151_2)
				end
			end
		end
	end
	
	local var_151_3 = {}
	
	for iter_151_3, iter_151_4 in pairs(var_151_0) do
		for iter_151_5, iter_151_6 in pairs(iter_151_4.targets) do
			local var_151_4 = iter_151_6:checkState(iter_151_4.aura_code)
			
			if iter_151_4.isPassiveBlock then
				if var_151_4 then
					local var_151_5, var_151_6 = iter_151_6.states:removeStates(-1, function(arg_152_0)
						return arg_152_0:getId() == tostring(iter_151_4.aura_code) and arg_152_0.db.cs_remove == "y"
					end)
					
					if var_151_5 and #var_151_5 > 0 then
						table.add(arg_151_1, var_151_5)
					end
				end
			else
				local var_151_7, var_151_8, var_151_9, var_151_10 = iter_151_6:addState(iter_151_4.aura_code, nil, iter_151_4.aura.owner, {
					skill_id = iter_151_4.aura.skill_id,
					limit_depth = arg_151_3
				})
				
				if var_151_7 then
					for iter_151_7, iter_151_8 in pairs(var_151_10) do
						var_151_3[iter_151_8:getId()] = nil
					end
					
					var_151_3[iter_151_4.aura_code] = iter_151_4.aura
					
					table.insert(arg_151_1, {
						type = "add_state",
						by_aura = true,
						from = iter_151_4.aura.owner,
						target = iter_151_6,
						state = var_151_8
					})
				end
			end
		end
	end
	
	if arg_151_2 then
		for iter_151_9, iter_151_10 in pairs(var_151_3) do
			if iter_151_10 then
				table.push(arg_151_1, {
					type = "invoke_passive",
					target = iter_151_10.owner,
					state = iter_151_10,
					text = iter_151_10.db.name
				})
			end
		end
	end
end

function var_0_3.getAuraTargetInfo(arg_153_0, arg_153_1, arg_153_2)
	local var_153_0 = arg_153_1.db
	local var_153_1 = var_153_0.cs_target
	local var_153_2 = var_153_0.cs_target
	
	if type(var_153_1) == "number" then
		if var_153_1 == 1 then
			return {
				targets = {
					arg_153_2
				},
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 3 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 6 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, nil, "fire"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 7 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, nil, "ice"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 8 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, nil, "wind"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 9 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, nil, "light"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 10 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, nil, "dark"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 13 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 19 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, arg_153_2),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 31 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, nil, "fire"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 32 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, nil, "ice"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 33 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, nil, "wind"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 34 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, nil, "light"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 35 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, nil, "dark"),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 >= 56 and var_153_1 <= 60 then
			local var_153_3 = ({
				"fire",
				"ice",
				"wind",
				"light",
				"dark"
			})[var_153_1 - 55]
			local var_153_4 = arg_153_2.logic:pickUnits(arg_153_2, ENEMY)
			
			for iter_153_0 = #var_153_4, 1, -1 do
				if var_153_4[iter_153_0].db.color == var_153_3 then
					table.remove(var_153_4, iter_153_0)
				end
			end
			
			return {
				targets = var_153_4,
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 >= 101 and var_153_1 <= 104 then
			local var_153_5 = var_153_1 - 100
			local var_153_6 = arg_153_2.logic:pickUnits(arg_153_2, FRIEND)
			
			for iter_153_1, iter_153_2 in pairs(var_153_6) do
				if not iter_153_2:isDead() and to_n(iter_153_2.inst.pos) == var_153_5 then
					return {
						targets = {
							iter_153_2
						},
						aura_code = var_153_0.cs_eff_value1
					}
				end
			end
		elseif var_153_1 == 16 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, true, nil, true),
				aura_code = var_153_0.cs_eff_value1
			}
		elseif var_153_1 == 17 then
			return {
				targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, true, nil, true),
				aura_code = var_153_0.cs_eff_value1
			}
		end
	elseif var_153_0.cs_target == "ALLY_ATTRIBUTE" then
		return {
			targets = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, nil, nil, var_153_2),
			aura_code = var_153_0.cs_eff_value1
		}
	elseif var_153_0.cs_target == "ENEMY_ATTRIBUTE" then
		return {
			targets = arg_153_2.logic:pickUnits(arg_153_2, ENEMY, nil, nil, var_153_2),
			aura_code = var_153_0.cs_eff_value1
		}
	elseif var_153_0.cs_target == "ENEMY_ALL_WITHOUT_BOSS" then
		local var_153_7 = arg_153_2.logic:pickUnits(arg_153_2, ENEMY)
		
		for iter_153_3 = #var_153_7, 1, -1 do
			if table.isInclude({
				"elite",
				"subboss",
				"boss"
			}, var_153_7[iter_153_3].db.tier) then
				table.remove(var_153_7, iter_153_3)
			end
		end
		
		return {
			targets = var_153_7,
			aura_code = var_153_0.cs_eff_value1
		}
	elseif var_153_0.cs_target == "ALL_DEAD_ALLIES" then
		local var_153_8 = arg_153_2.logic:pickUnits(arg_153_2, FRIEND, arg_153_2, true, nil, true)
		
		eff_targets = {}
		
		for iter_153_4, iter_153_5 in pairs(var_153_8) do
			if iter_153_5 and iter_153_5:isDead() then
				table.insert(eff_targets, iter_153_5)
			end
		end
	end
	
	return nil
end

function var_0_3.procHiddenUnit(arg_154_0, arg_154_1)
	local var_154_0 = {}
	local var_154_1 = false
	
	if arg_154_1 then
		if arg_154_1 and arg_154_0:getDeadCount(arg_154_1.inst.ally) > 0 then
			local var_154_2 = arg_154_0:getDeadUnits(arg_154_1.inst.ally)
			local var_154_3, var_154_4 = arg_154_0:spawnUnit(arg_154_1, var_154_2[1])
			
			table.insert(var_154_0, {
				type = "appear",
				dead_unit = var_154_3,
				unit = arg_154_1,
				dead_index = var_154_4
			})
			
			var_154_1 = true
		end
	else
		if arg_154_0.enemy_hidden and arg_154_0:procHiddenUnit(arg_154_0.enemy_hidden) then
			arg_154_0.enemy_hidden = nil
			var_154_1 = true
		end
		
		if arg_154_0.friend_hidden and arg_154_0:procHiddenUnit(arg_154_0.friend_hidden) then
			arg_154_0.friend_hidden = nil
			var_154_1 = true
		end
	end
	
	arg_154_0:onInfos(table.unpack(var_154_0))
	
	return var_154_1
end

function var_0_3.appendCounterAttack(arg_155_0, arg_155_1)
	if arg_155_1:isSummon() then
		return 
	end
	
	local var_155_0 = false
	
	if SkillFactory.create(arg_155_1.inst.use_skill, arg_155_1):getDealDamage() ~= "y" then
		return false
	end
	
	local var_155_1 = arg_155_0:getAttackInfo(arg_155_1)
	local var_155_2 = var_155_1.skill_id
	
	if arg_155_1:getSkillDB(var_155_2, {
		"ignore_counter"
	}) == "y" then
		return 
	end
	
	local var_155_3 = var_155_1.d_units
	local var_155_4 = arg_155_0:pickEnemies(arg_155_1)
	local var_155_5 = {}
	
	for iter_155_0, iter_155_1 in pairs(var_155_4) do
		local var_155_6 = arg_155_1.inst.ally == iter_155_1.inst.ally
		local var_155_7 = not iter_155_1:isEmptyHP()
		local var_155_8 = not iter_155_1:isStunned()
		local var_155_9 = iter_155_1.turn_vars.invoke_counter_stage ~= arg_155_0:getStageCounter()
		local var_155_10 = iter_155_1.states:isExistEffect("CSP_UNABLE_COUNTER")
		
		if not var_155_6 and var_155_7 and var_155_8 and var_155_9 and not var_155_10 then
			local var_155_11 = 0
			
			if table.find(var_155_3, iter_155_1) then
				var_155_11 = iter_155_1.states:getAllEffValue("CSP_COUNTER", function(arg_156_0)
					if arg_156_0:isPassiveBlocked() then
						return false
					end
					
					return true
				end)
			end
			
			if iter_155_1.turn_vars.invoke_counter_attack or var_155_11 > 0 then
				local var_155_12 = var_155_11 > arg_155_0.random:get()
				
				if iter_155_1.turn_vars.invoke_counter_attack or var_155_12 then
					table.insert(var_155_5, {
						attacker = iter_155_1,
						target = arg_155_1
					})
					
					var_155_0 = true
					
					Log.d(arg_155_0.name, "반격 발동(counter_attack)", iter_155_1.db.name, "->", arg_155_1.db.name)
					arg_155_0:onInfos({
						text = "sk_counter",
						type = "text",
						target = iter_155_1
					})
				end
			end
		end
	end
	
	if #var_155_5 > 0 then
		table.sort(var_155_5, var_0_7)
		table.each_reverse(var_155_5, function(arg_157_0, arg_157_1)
			arg_157_1.attacker:onSkillBundleInit()
			
			local var_157_0 = arg_157_1.attacker:getCounterSkillId()
			
			arg_157_1.attacker.turn_vars.invoke_counter_stage = arg_155_0:getStageCounter()
			
			arg_155_0:insertAttackOrder(arg_157_1.attacker, arg_157_1.target, var_157_0, true, nil, true)
		end)
	end
	
	return var_155_0
end

function var_0_3.newUnit(arg_158_0, arg_158_1)
	arg_158_0.battle_info.proc_info.next_unit_uid = arg_158_0.battle_info.proc_info.next_unit_uid - 1
	arg_158_1.uid = arg_158_0.battle_info.proc_info.next_unit_uid
	
	local var_158_0 = UNIT:create(arg_158_1, true)
	
	if not arg_158_0:isPVP() and arg_158_1.ally == ENEMY then
		local var_158_1 = arg_158_0.stageMap.weak_info
		
		if var_158_1 and var_158_1.weak_cs then
			for iter_158_0 = 1, var_158_1.weak_lv do
				var_158_0:addState(var_158_1.weak_cs, 1, var_158_0)
			end
		end
		
		local var_158_2, var_158_3, var_158_4 = DB("level_enter", arg_158_0.map.enter, {
			"mob_buff",
			"mob_buff_lv",
			"summon_mob_buff"
		})
		
		if var_158_4 == "y" and var_158_2 then
			var_158_0:applyLevelBaseBuff(var_158_2, var_158_3)
		end
		
		local var_158_5 = arg_158_0:getTrialHallInfo()
		
		if var_158_5 and var_158_5.boss_id == var_158_0.inst.code then
			if var_158_5.benefit then
				for iter_158_1, iter_158_2 in pairs(var_158_5.benefit) do
					var_158_0:addState(iter_158_2, 1, var_158_0)
				end
			end
			
			if var_158_5.penalty then
				for iter_158_3, iter_158_4 in pairs(var_158_5.penalty) do
					var_158_0:addState(iter_158_4, 1, var_158_0)
				end
			end
		end
		
		if arg_158_0:isAutomaton() then
			arg_158_0:addAutomatonEnemyDevice(var_158_0)
		end
	end
	
	return var_158_0
end

function var_0_3.addAllocatedUnit(arg_159_0, arg_159_1)
	arg_159_0.allocated_unit_tbl[arg_159_1.inst.uid] = arg_159_1
end

function var_0_3.getUnit(arg_160_0, arg_160_1)
	return arg_160_0.allocated_unit_tbl[arg_160_1]
end

function var_0_3.isInReserveTeam(arg_161_0, arg_161_1)
	for iter_161_0, iter_161_1 in pairs(arg_161_0.reserve_teams or {}) do
		if table.find(iter_161_1, function(arg_162_0, arg_162_1)
			return arg_162_1 == arg_161_1
		end) then
			return true
		end
	end
	
	return false
end

function var_0_3.onHitEvent(arg_163_0, arg_163_1, arg_163_2, arg_163_3)
	local var_163_0 = arg_163_0:getUnit(arg_163_1)
	
	if not var_163_0 then
		arg_163_0.error_info = "not_create_unit_attack"
		
		Log.e(arg_163_0.name, "생성되지 않은 영웅이 공격을 시도함", arg_163_1)
		
		return 
	end
	
	if var_163_0:isDead() then
		arg_163_0.error_info = "dead_unit_attack : " .. tostring(var_163_0.inst.code)
		
		Log.e(arg_163_0.name, "죽은 영웅이 공격을 시도함", arg_163_1)
		
		return 
	end
	
	local var_163_1 = arg_163_0:getAttackInfo(var_163_0)
	
	if not var_163_1 then
		for iter_163_0, iter_163_1 in pairs(arg_163_0.att_info_map) do
			print(iter_163_0.inst.uid, iter_163_0.db.code, iter_163_1.tot_hit)
		end
		
		Log.d(arg_163_0.name, "att_info_map", var_163_0.inst.uid, var_163_0.db.code)
		error("error not att_info")
	end
	
	arg_163_0:onInfos({
		state = "SKILL_HIT",
		parent = "ATTACK",
		type = "STATE"
	})
	
	if not var_163_1.tot_hit then
		arg_163_0:setSkillHitInfo(arg_163_1, arg_163_2.tot_hit)
	end
	
	if var_163_1.cur_hit > (var_163_1.tot_hit or 1) then
		Log.e(arg_163_0.name, string.format("-- TO MANY HIT : %s : %s : %d > %d ", T(var_163_0.db.name), var_163_1.skill_id, var_163_1.cur_hit, var_163_1.tot_hit))
		arg_163_0:onInfos({
			type = "@overhit",
			unit_uid = arg_163_1,
			cur_hit = var_163_1.cur_hit,
			tot_hit = var_163_1.tot_hit
		})
		
		return 
	end
	
	var_163_1.cur_hit = var_163_1.cur_hit + 1
	
	local var_163_2 = arg_163_0:makeUnitProcInfo(var_163_1, arg_163_3)
	local var_163_3 = var_163_0:proc(var_163_2)
	
	if not var_163_3 then
		return 
	end
	
	for iter_163_2, iter_163_3 in pairs(var_163_3) do
		iter_163_3.tag = arg_163_3
	end
	
	arg_163_0:onInfos(table.unpack(var_163_3))
	
	local var_163_4 = {}
	
	if var_163_2.cur_hit == var_163_2.tot_hit then
		table.insert(var_163_4, {
			type = "@end_hit",
			unit = var_163_0,
			skill_id = var_163_1.skill_id
		})
		arg_163_0:doEndHit(var_163_4, var_163_0)
	end
	
	arg_163_0:doAfterHeal(var_163_4)
	
	for iter_163_4, iter_163_5 in pairs(arg_163_0.units) do
		table.add(var_163_4, iter_163_5.states:onToggle())
	end
	
	arg_163_0:onInfos(table.unpack(var_163_4))
end

function var_0_3.doAfterHeal(arg_164_0, arg_164_1)
	local var_164_0 = 1
	
	for iter_164_0, iter_164_1 in pairs(arg_164_0.units) do
		if not iter_164_1:isEmptyHP() and not iter_164_1:isDead() and iter_164_1.turn_vars.hpup_per_damage then
			for iter_164_2, iter_164_3 in pairs(iter_164_1.turn_vars.hpup_per_damage) do
				local var_164_1 = math.min(math.floor(iter_164_1:getMaxHP() * var_164_0), iter_164_3)
				local var_164_2 = iter_164_1:heal(var_164_1)
				
				if var_164_2 > 0 then
					table.insert(arg_164_1, {
						type = "heal",
						from = iter_164_2,
						target = iter_164_1,
						heal = var_164_2
					})
				end
			end
			
			iter_164_1.turn_vars.hpup_per_damage = nil
		end
	end
end

function var_0_3.popInfo(arg_165_0)
	return (arg_165_0.logger:pop())
end

function var_0_3.popInfoAll(arg_166_0)
	return (arg_166_0.logger:popAll())
end

function var_0_3.onInfos(arg_167_0, ...)
	local function var_167_0(...)
		local var_168_0 = {
			...
		}
		
		for iter_168_0, iter_168_1 in pairs(var_168_0) do
			arg_167_0.battle_info.proc_info.counter = arg_167_0.battle_info.proc_info.counter + 1
			iter_168_1.proc_counter = arg_167_0.battle_info.proc_info.counter
			
			arg_167_0.logger:add(iter_168_1)
			
			if not arg_167_0.init_data.is_verify then
				if arg_167_0.result_stat then
					arg_167_0.result_stat:addStatistics(iter_168_1)
				end
				
				if arg_167_0:isRestoreViewInfo(iter_168_1) then
					table.insert(arg_167_0.restore_view_infos, iter_168_1)
				end
				
				if arg_167_0.mode == "net_server" or arg_167_0.mode == "ai_agent" and arg_167_0.make_view_data then
					local var_168_1 = arg_167_0.snap:createViewDatas(table.shallow_clone(iter_168_1))
					
					for iter_168_2, iter_168_3 in pairs(var_168_1 or {}) do
						arg_167_0.view_logger:add(iter_168_3)
					end
				end
			end
		end
	end
	
	if not arg_167_0.INFO_FILTER then
		arg_167_0.INFO_FILTER = {
			attack = function(arg_169_0, arg_169_1)
				if arg_169_1.from and not arg_169_0.att_info_map[arg_169_1.from] then
					arg_169_0.att_info_map[arg_169_1.from] = {
						attacker = arg_169_1.from
					}
				end
			end,
			add_state = function(arg_170_0, arg_170_1)
				local var_170_0 = arg_170_1.target
				local var_170_1 = arg_170_1.state
				local var_170_2 = var_170_0.inst.uid
				local var_170_3 = var_170_1.id
				local var_170_4 = var_170_1.db.cs_type
				local var_170_5 = var_170_1.effect
				local var_170_6 = var_170_1.eff_bone
				local var_170_9
				
				if var_170_4 == "concentration" then
					local var_170_7 = arg_170_0:getAttackInfo(var_170_0)
					local var_170_8 = {
						skill_id = var_170_7.skill_id,
						d_units = {}
					}
					
					for iter_170_0, iter_170_1 in pairs(var_170_7.d_units) do
						table.insert(var_170_8.d_units, iter_170_1.inst.uid)
					end
					
					arg_170_0.battle_info.concentration_info[var_170_2] = arg_170_0.battle_info.concentration_info[var_170_2] or {}
					var_170_9 = arg_170_0.battle_info.concentration_info[var_170_2]
					
					for iter_170_2, iter_170_3 in pairs(var_170_8) do
						var_170_9[iter_170_2] = iter_170_3
					end
				end
			end,
			remove_state = function(arg_171_0, arg_171_1)
				local var_171_0 = arg_171_1.target
				local var_171_1 = arg_171_1.state
				local var_171_2 = var_171_0.inst.uid
				local var_171_3 = var_171_1.id
				local var_171_4 = var_171_1.db.cs_type
				local var_171_5 = var_171_1.effect
				local var_171_6 = var_171_1.eff_bone
				
				if var_171_4 and var_171_4 == "concentration" and not var_171_0:isDead() then
					local var_171_7 = arg_171_0.battle_info.concentration_info[var_171_2]
					
					if var_171_7 then
						var_167_0({
							type = "@skill_stop",
							unit = var_171_0,
							skill_info = var_171_7
						})
					else
						var_167_0({
							type = "@skill_stop",
							unit = var_171_0
						})
					end
				end
			end,
			obstacle = function(arg_172_0, arg_172_1)
				local var_172_0 = arg_172_1.target
				local var_172_1 = arg_172_0:getRoadEventObject(arg_172_1.road_event_id).value or {}
				
				if var_172_1.attack then
					local var_172_2 = var_172_1.damage or 0
					
					arg_172_1.damage_msg = var_172_1.damage_msg
					
					local var_172_3 = {}
					
					for iter_172_0, iter_172_1 in pairs(arg_172_0.friends) do
						local var_172_4 = iter_172_1:getHP()
						local var_172_5 = math.floor(math.min(var_172_4 - 1, math.max(1, var_172_4 * var_172_2)))
						local var_172_6, var_172_7, var_172_8 = iter_172_1:decHP(var_172_3, var_172_5)
						
						var_167_0({
							attack_type = "obstacle",
							type = "attack",
							target = iter_172_1,
							damage = var_172_6,
							shield = var_172_7,
							dec_hp = var_172_8
						})
					end
					
					var_167_0(table.unpack(var_172_3))
				end
			end,
			drop_reward = function(arg_173_0, arg_173_1)
				table.insert(arg_173_0.battle_info.reward_list, arg_173_1.reward)
			end,
			add_turn = function(arg_174_0, arg_174_1)
				for iter_174_0 = 1, arg_174_1.pow do
					arg_174_0:addNextTurnOwner(arg_174_1.target, arg_174_1)
				end
			end,
			summon = function(arg_175_0, arg_175_1)
			end,
			replace = function(arg_176_0, arg_176_1)
				local var_176_0 = arg_176_1.dead_unit
				
				if var_176_0 and var_176_0.drop then
					arg_176_0:setReserveDrops(var_176_0.inst.ally, var_176_0.drop)
				end
			end
		}
	end
	
	for iter_167_0, iter_167_1 in pairs({
		...
	}) do
		local var_167_1 = arg_167_0.INFO_FILTER[iter_167_1.type]
		
		if var_167_1 then
			var_167_1(arg_167_0, iter_167_1)
		end
		
		var_167_0(iter_167_1)
	end
end

function var_0_3.isAIPlayer(arg_177_0, arg_177_1)
	if arg_177_1:getProvoker() then
		return true
	end
	
	if arg_177_0:isDualControl() then
		return false
	end
	
	return arg_177_1.inst.ally == ENEMY
end

function var_0_3.wasteUnitPickerRandom(arg_178_0)
	arg_178_0.random:shuffleSeed()
end

function var_0_3.doStartTurn(arg_179_0)
	local var_179_0 = {}
	
	if arg_179_0:checkCreviceTeamReturn(var_179_0) then
		arg_179_0:procBattleEvent("finish")
		arg_179_0:onCreviceReturn()
		arg_179_0:checkFinishedEvent(var_179_0)
		arg_179_0:onInfos(table.unpack(var_179_0))
		
		return 
	end
	
	arg_179_0.vsm:flush()
	arg_179_0.random:shuffleSeed()
	Log.d(arg_179_0.name, "AIRandom Shuffle")
	arg_179_0:setPeakSpeed()
	
	arg_179_0.stage_counter = arg_179_0.stage_counter + 1
	
	for iter_179_0, iter_179_1 in pairs(arg_179_0.units) do
		iter_179_1:initTurnVars()
		iter_179_1:resetVariablePassiveDirty()
	end
	
	local var_179_1 = arg_179_0.turn_info.turn_owner
	local var_179_2 = arg_179_0.turn_info.rest_tick
	local var_179_3 = {}
	
	arg_179_0:onInfos({
		state = "START_TURN",
		type = "STATE"
	})
	arg_179_0:updateAura(var_179_3, arg_179_0.stage_counter == 1)
	arg_179_0:onInfos(table.unpack(var_179_3))
	
	local var_179_4 = {}
	
	if arg_179_0.stage_counter == 1 then
		local var_179_5 = table.alignment_clone(arg_179_0.units)
		
		table.sort(var_179_5, var_0_6)
		
		arg_179_0.first_sorted_action_gauges = {}
		
		for iter_179_2, iter_179_3 in pairs(arg_179_0.units) do
			local var_179_6 = math.min(iter_179_3.inst.elapsed_ut, MAX_UNIT_TICK) * 100 / MAX_UNIT_TICK
			
			arg_179_0.first_sorted_action_gauges[iter_179_3] = math.clamp(math.floor(var_179_6 + var_0_4), 0, 100)
		end
		
		for iter_179_4, iter_179_5 in pairs(var_179_5) do
			if not iter_179_5:isDead() then
				local var_179_7 = iter_179_5:onStartStage("before")
				
				table.join(var_179_4, var_179_7)
			end
		end
		
		for iter_179_6, iter_179_7 in pairs(var_179_5) do
			if not iter_179_7:isDead() then
				local var_179_8 = iter_179_7:onStartStage("after")
				
				table.join(var_179_4, var_179_8)
			end
		end
	end
	
	if arg_179_0:isRealtimeMode() then
		local var_179_9 = var_179_1:getArenaUID()
		
		arg_179_0.user_turn_counter = arg_179_0.user_turn_counter or {}
		arg_179_0.user_turn_counter[var_179_9] = arg_179_0.user_turn_counter[var_179_9] or 0
		arg_179_0.user_turn_counter[var_179_9] = arg_179_0.user_turn_counter[var_179_9] + 1
	end
	
	local var_179_10 = var_179_1:onStartTurn()
	
	table.join(var_179_4, var_179_10)
	arg_179_0:updateUnitPeakStat()
	
	for iter_179_8, iter_179_9 in pairs(arg_179_0.units) do
		table.join(var_179_4, iter_179_9.states:onToggle())
		iter_179_9:onToggleVariablePassive()
	end
	
	arg_179_0:procDeadUnits(var_179_4)
	arg_179_0:onInfos(table.unpack(var_179_4))
	
	local var_179_11 = {}
	
	if arg_179_0:checkFinishedEvent(var_179_11) then
		arg_179_0:onInfos(table.unpack(var_179_11))
		
		return 
	end
	
	local var_179_12 = arg_179_0.turn_info.next_queue[1]
	
	AIManager:procUnitAI(arg_179_0.enemies, "start_turn", var_179_11)
	
	local var_179_13 = false
	
	if var_179_12 ~= arg_179_0.turn_info.next_queue[1] then
		var_179_13 = true
	elseif var_179_1:isEmptyHP() then
		var_179_13 = true
	elseif var_179_1:isStunned() then
		var_179_13 = true
		
		table.insert(var_179_11, {
			reason = "stun",
			type = "skip_turn",
			target = var_179_1
		})
	elseif var_179_1:isConcentration() then
		var_179_13 = true
	end
	
	if not var_179_13 then
		local var_179_14
		
		if arg_179_0:isPVP() and not arg_179_0.stage_unit_order_info[var_179_1] then
			arg_179_0.stage_unit_order_info[var_179_1] = arg_179_0.stage_unit_order_count
			arg_179_0.stage_unit_order_count = arg_179_0.stage_unit_order_count + 1
			var_179_14 = arg_179_0.stage_unit_order_info[var_179_1]
		end
		
		var_179_1:addTeamRes("turn", 1)
		table.insert(var_179_11, 1, {
			type = "@start_turn",
			unit = var_179_1,
			order = var_179_14
		})
	end
	
	arg_179_0:onInfos(table.unpack(var_179_11))
	
	if var_179_13 then
		arg_179_0:procBattleEvent("pending_end")
	else
		arg_179_0:procBattleEvent("pending_ready")
	end
end

function var_0_3.doReadyAttack(arg_180_0)
	arg_180_0:onInfos({
		state = "READY",
		type = "STATE"
	})
	
	local var_180_0 = arg_180_0.turn_info.turn_owner
	local var_180_1 = arg_180_0.turn_info.rest_tick
	
	arg_180_0:onInfos({
		type = "@ready_attack",
		unit = var_180_0,
		is_provoker = var_180_0:getProvoker() ~= nil
	})
	arg_180_0:procBattleEvent("ready")
end

function var_0_3.doEndHit(arg_181_0, arg_181_1, arg_181_2)
	local var_181_0 = arg_181_0:getAttackInfo(arg_181_2)
	local var_181_1 = var_181_0.hidden
	
	for iter_181_0, iter_181_1 in pairs(var_181_0.d_units or {}) do
		if iter_181_1 and iter_181_1:isEmptyHP() and not iter_181_1:isResurrectionReserved() and not iter_181_1:isReplaced() then
			for iter_181_2 = #arg_181_0.turn_info.attack_order, 1, -1 do
				if arg_181_0.turn_info.attack_order[iter_181_2] and arg_181_0.turn_info.attack_order[iter_181_2].attacker == iter_181_1 then
					table.remove(arg_181_0.turn_info.attack_order, iter_181_2)
				end
			end
		end
	end
	
	if not var_181_1 then
		arg_181_0:appendCounterAttack(arg_181_2)
	end
	
	if (var_181_0.coop_order or 0) < 2 then
		table.remove(arg_181_0.turn_info.attack_order, 1)
	end
	
	arg_181_0.turn_info.attack_stats[arg_181_2.inst.uid] = nil
	
	if not table.empty(arg_181_0.turn_info.attack_stats) then
		return 
	end
	
	if var_181_0.coop_order == 1 then
		return 
	end
	
	if table.empty(arg_181_0.turn_info.attack_order) then
		arg_181_0:procBattleEvent("pending_end")
	else
		arg_181_0:procBattleEvent("next_attack_order")
	end
end

function var_0_3.doEndTurn(arg_182_0)
	if arg_182_0.turn_info.state ~= "pending_end" then
		return 
	end
	
	arg_182_0:onInfos({
		state = "END_TURN",
		type = "STATE"
	})
	
	for iter_182_0, iter_182_1 in pairs(arg_182_0.units) do
		iter_182_1:clearReserveResurrectBlock()
	end
	
	local var_182_0 = {}
	local var_182_1, var_182_2 = arg_182_0:checkBurningPhaseFinish()
	local var_182_3 = arg_182_0:getTurnOwner()
	
	if var_182_3 then
		arg_182_0.team_stage_counter[var_182_3:getAlly()] = to_n(arg_182_0.team_stage_counter[var_182_3:getAlly()]) + 1
	end
	
	if arg_182_0.reserver_swapteam then
		arg_182_0:swapTeam(arg_182_0.reserver_swapteam)
		
		arg_182_0.reserver_swapteam = nil
	elseif var_182_1 then
		arg_182_0:procDeadUnits(var_182_0)
		arg_182_0:onInfos(table.unpack(var_182_0))
		arg_182_0:onBurning("finish", var_182_2)
	else
		arg_182_0:procDeadUnits(var_182_0)
		arg_182_0:onInfos(table.unpack(var_182_0))
		UnitSkillSequencer:onEndTurn(var_182_3)
		
		local var_182_4 = var_182_3:onEndTurn()
		
		for iter_182_2, iter_182_3 in pairs(arg_182_0.units) do
			table.add(var_182_4, iter_182_3.states:onToggle())
			iter_182_3:onToggleVariablePassive()
		end
		
		AIManager:procUnitAI(arg_182_0.enemies, "end_turn", var_182_4)
		arg_182_0:onInfos(table.unpack(var_182_4))
		
		local var_182_5 = {}
		
		if arg_182_0:isPVP() then
			arg_182_0:procPVP()
		end
		
		arg_182_0:procDeadUnits(var_182_5)
		arg_182_0:onInfos(table.unpack(var_182_5))
		
		local var_182_6 = {}
		
		arg_182_0:onInfos({
			type = "@end_turn",
			unit = var_182_3
		})
		
		local var_182_7 = {}
		local var_182_8 = var_182_3:onTurnEndAfter()
		
		arg_182_0:onInfos(table.unpack(var_182_8))
	end
	
	local var_182_9 = {}
	
	if arg_182_0:checkFinishedEvent(var_182_9) then
		arg_182_0:onInfos(table.unpack(var_182_9))
		
		return 
	end
	
	arg_182_0:procBattleEvent("ended")
end

function var_0_3.doPlayUnit(arg_183_0)
	local var_183_0 = arg_183_0.turn_info.turn_owner
	
	if not arg_183_0:isAIPlayer(var_183_0) then
		return 
	end
	
	if not arg_183_0:isRealtimeMode() and arg_183_0._paused.banner then
		return 
	end
	
	arg_183_0:doAutoSkill()
end

function var_0_3.doAutoSkill(arg_184_0)
	local var_184_0 = arg_184_0:getTurnOwner()
	
	if var_184_0 == nil then
		return false
	end
	
	if arg_184_0:isEnded() then
		return false, var_184_0
	end
	
	local var_184_1, var_184_2, var_184_3, var_184_4 = arg_184_0:AI_SelectSkillIdxAndTarget(arg_184_0.random:clone(), var_184_0)
	local var_184_5 = arg_184_0:doStartSkill(var_184_0, var_184_2, var_184_4)
	
	if table.empty(var_184_5) then
		arg_184_0:procBattleEvent("pending_end")
		
		return false, var_184_0, var_184_2
	end
	
	arg_184_0:procBattleEvent("attack")
	
	return true, var_184_0, var_184_2
end

function var_0_3.doNextAttackOrder(arg_185_0)
	arg_185_0:onInfos({
		type = "do_next_attack_order"
	})
	
	local var_185_0 = arg_185_0:getAttackOrder()
	
	if not var_185_0 then
		arg_185_0:procBattleEvent("pending_end")
		
		return 
	end
	
	if var_185_0.attacker:isEmptyHP() or not var_185_0.skill_id then
		table.remove(arg_185_0.turn_info.attack_order, 1)
		arg_185_0:procBattleEvent("next_attack_order")
		
		return 
	end
	
	if arg_185_0.reserver_swapteam then
		arg_185_0:procBattleEvent("pending_end")
		
		return 
	end
	
	if var_185_0.attacker.states:isExistEffect("CSP_UNABLE_ACTION_TURN_OTHER") then
		local var_185_1 = arg_185_0:getTurnOwner()
		
		if var_185_1 and var_185_1 ~= var_185_0.attacker then
			table.remove(arg_185_0.turn_info.attack_order, 1)
			arg_185_0:procBattleEvent("next_attack_order")
			
			return 
		end
	end
	
	if var_185_0.attacker:checkStateAttribute(1) then
		table.remove(arg_185_0.turn_info.attack_order, 1)
		arg_185_0:procBattleEvent("next_attack_order")
		
		return 
	end
	
	local var_185_2 = {}
	
	arg_185_0:procDeadUnits(var_185_2)
	arg_185_0:onInfos(table.unpack(var_185_2))
	
	local var_185_3 = {}
	
	if arg_185_0:getFinishedBattleResult() then
		arg_185_0:procBattleEvent("pending_end")
		
		return 
	end
	
	for iter_185_0, iter_185_1 in pairs(arg_185_0.units) do
		iter_185_1:clearReserveResurrectBlock()
	end
	
	local var_185_4 = arg_185_0:getTargetCandidates(var_185_0.skill_id, var_185_0.attacker, var_185_0.target, nil, true)
	
	for iter_185_2 = #var_185_4, 1, -1 do
		local var_185_5 = var_185_4[iter_185_2]
		
		if var_185_5.inst.ally ~= var_185_0.attacker.inst.ally and (var_185_5:isDead() or not var_185_5:isSkillEffectTargetable()) then
			table.remove(var_185_4, iter_185_2)
		end
	end
	
	if table.empty(var_185_4) then
		if table.empty(arg_185_0.turn_info.attack_order) then
			arg_185_0:procBattleEvent("pending_end")
		else
			table.remove(arg_185_0.turn_info.attack_order, 1)
			arg_185_0:procBattleEvent("next_attack_order")
		end
		
		return 
	end
	
	local var_185_6 = var_185_0.attacker
	
	if var_185_6 and var_185_6.turn_vars then
		var_185_6.turn_vars.global_critical_count = nil
		var_185_6.turn_vars.global_miss_count = nil
		var_185_6.turn_vars.global_miss_flag = nil
		var_185_6.turn_vars.global_kill_flag = nil
		var_185_6.turn_vars.global_kill_first = nil
	end
	
	arg_185_0.turn_info.unique_flag = {}
	
	local var_185_7 = arg_185_0:doStartSkill(var_185_0.attacker, var_185_0.skill_id, var_185_0.target, nil, {
		hidden = true
	})
	
	if table.empty(var_185_7) then
		arg_185_0:procBattleEvent("pending_end")
		
		return 
	end
	
	arg_185_0:procBattleEvent("attack")
end

function var_0_3.onSwapTagSupporter(arg_186_0)
	if not arg_186_0.friend_hidden then
		return 
	end
	
	local var_186_0 = arg_186_0:getTurnOwner()
	local var_186_1, var_186_2 = arg_186_0:spawnUnit(arg_186_0.friend_hidden, var_186_0)
	
	arg_186_0:onInfos({
		type = "disappear_by_tag",
		unit = var_186_1
	})
	arg_186_0:onInfos({
		type = "appear_by_tag",
		dead_unit = var_186_1,
		unit = arg_186_0.friend_hidden,
		dead_index = var_186_2
	})
	
	local var_186_3 = arg_186_0.friend_hidden
	local var_186_4, var_186_5 = arg_186_0.friend_hidden:getRestTimeAndTick()
	
	arg_186_0.turn_info.next_queue = {}
	arg_186_0.turn_info.turn_owner = var_186_3
	arg_186_0.turn_info.rest_tick = var_186_5
	arg_186_0.turn_info.attack_order = {
		{
			attacker = var_186_3
		}
	}
	arg_186_0.friend_hidden = nil
	
	var_0_9(arg_186_0.friends)
	arg_186_0:procBattleEvent("pending_start")
end

function var_0_3.doDead(arg_187_0, arg_187_1, arg_187_2)
	local function var_187_0(arg_188_0, arg_188_1)
		local var_188_0 = {}
		local var_188_1 = arg_188_0:pickUnits(arg_188_1, FRIEND)
		
		for iter_188_0, iter_188_1 in pairs(var_188_1) do
			if not iter_188_1:isEmptyHP() and not iter_188_1:isDead() then
				table.insert(var_188_0, iter_188_1.inst.uid)
			end
		end
		
		return var_188_0
	end
	
	if arg_187_1:isDead() then
		return 
	end
	
	local var_187_1 = var_187_0(arg_187_0, arg_187_1)
	
	arg_187_1:onDead(arg_187_2)
	table.insert(arg_187_2, {
		type = "dead",
		target_uid = arg_187_1.inst.uid,
		from = arg_187_1.inst.dead_from,
		remain_units = var_187_1
	})
	
	if not arg_187_1:isResurrectionReserved() then
		local var_187_2 = arg_187_0:getRunningRoadEventObject()
		local var_187_3 = var_0_11(var_187_2.type, arg_187_0.stageMap.contents_type)
		
		arg_187_1.hide = var_187_3
		
		local var_187_4 = var_0_10({}, arg_187_1)
		
		table.insert(arg_187_2, {
			type = "drop_reward",
			target_uid = arg_187_1.inst.uid,
			reward = var_187_4
		})
		
		local var_187_5 = 0
		
		for iter_187_0, iter_187_1 in pairs(arg_187_0.units) do
			if not iter_187_1:isDead() and iter_187_1 ~= arg_187_1 and iter_187_1.inst.ally == arg_187_1.inst.ally and iter_187_1.inst.code ~= "cleardummy" then
				var_187_5 = var_187_5 + 1
			end
		end
		
		if var_187_5 < 1 then
			local var_187_6 = arg_187_0:getReserveDrops(arg_187_1.inst.ally)
			
			if var_187_6 then
				local var_187_7 = var_0_10({}, {
					drop = var_187_6,
					hide = var_187_3
				})
				
				table.insert(arg_187_2, {
					type = "drop_reward",
					target_uid = arg_187_1.inst.uid,
					reward = var_187_7
				})
			end
		end
		
		if arg_187_1:isAllyKiller() then
			local var_187_8 = arg_187_0:pickUnits(arg_187_1, FRIEND, arg_187_1, true, nil, true)
			
			for iter_187_2, iter_187_3 in pairs(var_187_8) do
				iter_187_3.states:clear()
				
				iter_187_3.inst.hp = 0
				iter_187_3.inst.resurrect_hp_ratio = nil
				iter_187_3.inst.resurrect_cs = nil
				
				arg_187_0:doDead(iter_187_3, arg_187_2)
			end
		end
	end
	
	arg_187_1:onRemoveAuraState(arg_187_2, "before")
	
	for iter_187_4, iter_187_5 in pairs(arg_187_0.units) do
		if not iter_187_5:isDead() then
			iter_187_5:onSomeoneDead(arg_187_1, arg_187_2)
		end
	end
	
	arg_187_1:onRemoveAuraState(arg_187_2, "after")
	arg_187_0:removeDeadAttackers()
end

function var_0_3.getFinishedBattleResult(arg_189_0)
	local var_189_0 = table.icount(arg_189_0.enemies)
	
	if arg_189_0.enemy_hidden then
		var_189_0 = var_189_0 + 1
	end
	
	local var_189_1 = countDead(arg_189_0.enemies) == var_189_0
	local var_189_2 = arg_189_0.battle_info.road_info.road_type
	
	if not string.starts(arg_189_0.type, "dungeon") and var_189_2 ~= "goblin" and var_189_2 ~= "chaos" and arg_189_0:isLastRoadEvent() and var_189_1 then
		return "win"
	end
	
	if countDead(arg_189_0.friends) == table.icount(arg_189_0.friends) then
		return "lose"
	elseif var_189_1 then
		return "win"
	end
end

function var_0_3.checkFinishedEvent(arg_190_0, arg_190_1)
	arg_190_0:procResurrect()
	arg_190_0:procHiddenUnit()
	arg_190_0:updateRtaPenalty()
	
	local var_190_0 = arg_190_0:getFinishedBattleResult()
	local var_190_1 = false
	
	if var_190_0 == "win" then
		var_190_1 = true
		arg_190_0.last_stage_result = "win"
		
		arg_190_0:setCompleteRoadEvent(arg_190_0.road_event_run_info.road_event_id)
		
		if arg_190_0:getMoraleVariant() >= 170 then
			query("convic", {
				reason = "absurd_morale",
				convic = 3
			})
		end
		
		arg_190_0:decMorale(arg_190_0:getMoraleValue("battle"))
		
		local var_190_2 = arg_190_0:getRoadEventObject(arg_190_0.road_event_run_info.road_event_id)
		
		arg_190_0:postLevelFlag(var_190_2)
		arg_190_0:checkGroupEventFlag(var_190_2)
	elseif var_190_0 == "lose" then
		var_190_1 = true
		arg_190_0.last_stage_result = "lose"
	elseif arg_190_0.burning_phase == "finish" then
		var_190_1 = true
		arg_190_0.burning_phase = nil
		
		arg_190_0:setCompleteRoadEvent(arg_190_0.road_event_run_info.road_event_id)
	elseif arg_190_0.is_crevice_return then
		var_190_1 = true
		arg_190_0.last_stage_result = "win"
		
		arg_190_0:setCompleteRoadEvent(arg_190_0.road_event_run_info.road_event_id)
	end
	
	if var_190_1 then
		for iter_190_0, iter_190_1 in pairs(arg_190_0.friends) do
			local var_190_3, var_190_4 = iter_190_1.states:removeStates(-1, function(arg_191_0)
				return arg_191_0.db.cs_attribute == 1 or arg_191_0.db.cs_type == "concentration"
			end)
			
			arg_190_0:onInfos(table.unpack(var_190_3))
			arg_190_0:onInfos(var_190_4)
			
			local var_190_5 = iter_190_1.states:procTurn()
			
			arg_190_0:onInfos(table.unpack(var_190_5))
		end
		
		if arg_190_0:isEnded() and arg_190_0:isNeedToUpdateHP() then
			arg_190_0:procAutoHeal()
		end
		
		if arg_190_0.last_stage_result == "win" then
			arg_190_0:procExp()
			arg_190_0:setEnemiesDeadUnitUIDList()
			arg_190_0:clearEnemies()
		end
		
		arg_190_0:onInfos({
			type = "@end_road_event",
			road_event_id = arg_190_0.road_event_run_info.road_event_id
		})
		Log.i(arg_190_0.name, "end road event")
		
		if arg_190_0:isEnded() then
			Log.i(arg_190_0.name, "end battle")
			
			if arg_190_0:isNeedToUpdateHP() then
				arg_190_0:procAutoHeal()
			end
			
			arg_190_0:onInfos({
				type = "@end_battle"
			})
		end
		
		arg_190_0:stopBattleFSM()
		
		arg_190_0.road_event_run_info.state_name = "finished"
		
		LuaEventDispatcher:dispatchEvent("begginner_log", arg_190_0.map.enter .. "/" .. arg_190_0.encounter_enemy_count .. "/" .. arg_190_0.road_event_run_info.road_event_id, 1)
	end
	
	return var_190_1
end

function var_0_3.doNextTurn(arg_192_0)
	arg_192_0:onInfos({
		state = "NEXT_TURN",
		type = "STATE"
	})
	
	local var_192_0 = {}
	
	arg_192_0:procDeadUnits(var_192_0)
	arg_192_0:onInfos(table.unpack(var_192_0))
	arg_192_0:procBattleEvent("next")
	
	return true
end

function var_0_3.getTargetCandidates(arg_193_0, arg_193_1, arg_193_2, arg_193_3, arg_193_4, arg_193_5)
	local var_193_0 = {}
	local var_193_1 = arg_193_2:getAlly() == FRIEND and ENEMY or FRIEND
	local var_193_2, var_193_3 = DB("skill", arg_193_1, {
		"target",
		"ignore_stealth"
	})
	local var_193_4 = to_n(var_193_2)
	local var_193_5 = var_193_3 == "y"
	
	local function var_193_6(arg_194_0)
		return arg_194_0 == arg_193_3 or not arg_194_0:isSkillEffectTargetable()
	end
	
	if var_193_4 == 13 then
		var_193_0 = arg_193_0:pickEnemies(arg_193_2)
	elseif var_193_4 == 14 then
		var_193_0 = arg_193_0:pickEnemies(arg_193_2)
		
		if arg_193_3 then
			for iter_193_0 = #var_193_0, 1, -1 do
				if var_193_0[iter_193_0].inst.line ~= arg_193_3.inst.line then
					table.remove(var_193_0, iter_193_0)
				end
			end
		end
	elseif var_193_4 == 3 then
		var_193_0 = arg_193_0:pickUnits(arg_193_2, FRIEND)
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 == 2 or var_193_4 == 15 then
		if arg_193_3 and arg_193_3:getAlly() == arg_193_2:getAlly() then
			var_193_0 = {
				arg_193_3
			}
		else
			var_193_0 = arg_193_0:pickUnits(arg_193_2, FRIEND)
		end
		
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 == 12 then
		if arg_193_3 and arg_193_3:getAlly() ~= arg_193_2:getAlly() then
			var_193_0 = {
				arg_193_3
			}
		else
			var_193_0 = arg_193_0:pickEnemies(arg_193_2)
		end
	elseif var_193_4 == 1 then
		var_193_0 = {
			arg_193_2
		}
		var_193_1 = FRIEND
	elseif var_193_4 == 16 then
		if arg_193_3 then
			var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, ENEMY, 1, var_193_6, arg_193_4)
			
			table.insert(var_193_0, 1, arg_193_3)
		else
			var_193_0 = arg_193_0:pickEnemies(arg_193_2)
		end
	elseif var_193_4 == 17 then
		if arg_193_3 then
			var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, ENEMY, 2, var_193_6, arg_193_4)
			
			table.insert(var_193_0, 1, arg_193_3)
		else
			var_193_0 = arg_193_0:pickEnemies(arg_193_2)
		end
	elseif var_193_4 == 18 then
		if arg_193_3 and arg_193_3:getAlly() == arg_193_2:getAlly() then
			var_193_0 = {
				arg_193_3
			}
		else
			var_193_0 = arg_193_0:pickUnits(arg_193_2, FRIEND, arg_193_2)
		end
		
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 == 19 then
		var_193_0 = arg_193_0:pickUnits(arg_193_2, FRIEND, arg_193_2)
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 >= 21 and var_193_4 <= 26 then
		if arg_193_3 then
			if var_193_4 == 21 then
				var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, FRIEND, 1)
			elseif var_193_4 == 22 then
				var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, FRIEND, 2)
			elseif var_193_4 == 23 then
				var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, FRIEND, 3)
			elseif var_193_4 == 24 then
				var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, ENEMY, 1)
			elseif var_193_4 == 25 then
				var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, ENEMY, 2)
			elseif var_193_4 == 26 then
				var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, ENEMY, 3)
			end
		elseif var_193_4 >= 21 and var_193_4 <= 23 then
			var_193_0 = arg_193_0:pickUnits(arg_193_2, FRIEND)
		elseif var_193_4 >= 24 and var_193_4 <= 26 then
			var_193_0 = arg_193_0:pickUnits(arg_193_2, ENEMY)
		end
	elseif var_193_4 == 95 then
		var_193_0 = arg_193_0:pickRandomUnits(arg_193_2, ENEMY, 1)
	elseif var_193_4 == 32 then
		if arg_193_3 and arg_193_3:getAlly() == arg_193_2:getAlly() then
			var_193_0 = {
				arg_193_3
			}
		else
			var_193_0 = arg_193_0:pickDeadUnitsForSummon(arg_193_2, FRIEND)
		end
		
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 == 33 then
		var_193_0 = arg_193_0:pickDeadUnitsForSummon(arg_193_2, FRIEND)
	elseif var_193_4 == 34 then
		var_193_0 = arg_193_0:pickDeadUnits(arg_193_2, FRIEND)
	elseif var_193_4 == 4 then
		var_193_0 = arg_193_0:pickUnits(arg_193_2, FRIEND, nil, true)
		
		if arg_193_3 and arg_193_3:getAlly() == arg_193_2:getAlly() then
			var_193_0 = {
				arg_193_3
			}
		end
		
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 == 35 then
		var_193_0 = arg_193_0:pickRandomFromPrevDamagedTargets(arg_193_2, var_193_5)
	elseif var_193_4 == 36 then
		var_193_0 = arg_193_0:pickEnemies(arg_193_2, arg_193_3)
	elseif var_193_4 == 37 then
		local var_193_7 = arg_193_0:getTurnOwner()
		
		if var_193_7 ~= arg_193_2 and var_193_7.inst.ally ~= arg_193_2.inst.ally then
			var_193_0 = {
				var_193_7
			}
		else
			local var_193_8 = arg_193_0:getAttackInfo(var_193_7)
			
			if var_193_8 then
				var_193_0 = {
					var_193_8.d_unit
				}
			end
		end
	elseif var_193_4 == 38 then
		local var_193_9 = arg_193_0:getTurnOwner()
		
		if var_193_9 ~= arg_193_2 and var_193_9.inst.ally == arg_193_2.inst.ally then
			var_193_0 = {
				var_193_9
			}
		else
			local var_193_10 = arg_193_0:getAttackInfo(var_193_9)
			
			if var_193_10 then
				var_193_0 = {
					var_193_10.d_unit
				}
			end
		end
	elseif var_193_4 == 39 then
		local var_193_11 = arg_193_0:getAttackOrder().invokers
		
		if var_193_11 then
			local var_193_12 = table.select(var_193_11, function(arg_195_0, arg_195_1)
				return arg_195_1
			end)[1]
			local var_193_13
			
			if var_193_12 then
				var_193_13 = arg_193_0:pickUnits(var_193_12, FRIEND)
				
				for iter_193_1 = #var_193_11, 1, -1 do
					local var_193_14 = var_193_11[iter_193_1]
					local var_193_15 = false
					
					for iter_193_2, iter_193_3 in pairs(var_193_13) do
						if iter_193_3:getUID() == var_193_14:getUID() then
							var_193_15 = true
						end
					end
					
					if not var_193_15 then
						local var_193_16
						
						for iter_193_4, iter_193_5 in pairs(var_193_13) do
							if iter_193_5.inst.pos == var_193_14.inst.pos then
								var_193_11[iter_193_1] = iter_193_5
								
								break
							end
						end
						
						if var_193_16 then
							var_193_11[iter_193_1] = var_193_16
						end
					end
				end
			end
			
			arg_193_5 = true
			var_193_0 = var_193_11
		end
	elseif var_193_4 == 43 then
		var_193_0 = arg_193_0:pickEnemies(arg_193_2)
		
		local var_193_17 = {}
		
		for iter_193_6, iter_193_7 in pairs(var_193_0) do
			if table.empty(var_193_17) then
				table.insert(var_193_17, iter_193_7)
			else
				local var_193_18 = var_193_17[1]:getHPRatio()
				local var_193_19 = iter_193_7:getHPRatio()
				
				if var_193_18 <= var_193_19 then
					if var_193_18 < var_193_19 then
						var_193_17 = {}
					end
					
					table.insert(var_193_17, iter_193_7)
				end
			end
		end
		
		local var_193_20 = arg_193_0.random:get(1, #var_193_17)
		
		var_193_0 = {
			var_193_17[var_193_20]
		}
	elseif var_193_4 == 44 then
		var_193_0 = arg_193_0:pickEnemies(arg_193_2)
		
		local var_193_21 = {}
		
		for iter_193_8, iter_193_9 in pairs(var_193_0) do
			if table.empty(var_193_21) then
				table.insert(var_193_21, iter_193_9)
			else
				local var_193_22 = var_193_21[1]:getHPRatio()
				local var_193_23 = iter_193_9:getHPRatio()
				
				if var_193_23 <= var_193_22 then
					if var_193_23 < var_193_22 then
						var_193_21 = {}
					end
					
					table.insert(var_193_21, iter_193_9)
				end
			end
		end
		
		local var_193_24 = arg_193_0.random:get(1, #var_193_21)
		
		var_193_0 = {
			var_193_21[var_193_24]
		}
	elseif var_193_4 >= 71 and var_193_4 <= 78 then
		var_193_0 = arg_193_0:pickUnitsByStatus(arg_193_2, FRIEND, var_193_4, 1)
	elseif var_193_4 >= 81 and var_193_4 <= 88 then
		var_193_0 = arg_193_0:pickUnitsByStatus(arg_193_2, ENEMY, var_193_4, 1)
	elseif var_193_4 >= 171 and var_193_4 <= 178 then
		var_193_0 = arg_193_0:pickUnitsByStatus(arg_193_2, FRIEND, var_193_4, 1, arg_193_2)
	elseif var_193_4 == 151 then
		local var_193_25 = arg_193_0:pickUnits(arg_193_2, FRIEND, arg_193_2)
		local var_193_26 = {}
		
		for iter_193_10, iter_193_11 in pairs(var_193_25) do
			if iter_193_11.states:getTypeCount("debuff") > 0 then
				table.insert(var_193_26, iter_193_11)
			end
		end
		
		local var_193_27 = arg_193_0.random:get(1, #var_193_26)
		
		var_193_0 = {
			var_193_26[var_193_27]
		}
	elseif var_193_4 == 92 then
		if arg_193_3 and arg_193_3:getAlly() == arg_193_2:getAlly() then
			var_193_0 = {
				arg_193_3
			}
		else
			var_193_0 = arg_193_0:pickDeadUnits(arg_193_2, arg_193_2:getAlly())
		end
		
		var_193_1 = arg_193_2:getAlly()
	elseif var_193_4 == 93 then
		var_193_0 = arg_193_0:pickDeadUnits(arg_193_2, FRIEND)
	elseif var_193_4 == 94 then
		var_193_0 = arg_193_0:pickRandomDeadUnits(arg_193_2, FRIEND, 1)
	else
		var_193_0 = arg_193_0:pickEnemies(arg_193_2)
	end
	
	if arg_193_3 == nil and var_193_4 == 12 then
		local var_193_28 = arg_193_2:getProvoker()
		
		if var_193_28 then
			var_193_0 = {
				var_193_28
			}
		end
	end
	
	local var_193_29 = false
	
	for iter_193_12, iter_193_13 in pairs(arg_193_0:pickEnemies(arg_193_2)) do
		if not iter_193_13:isDead() and not iter_193_13:isEmptyHP() and iter_193_13:isExistStealthEffect() then
			var_193_29 = true
		else
			var_193_29 = false
			
			break
		end
	end
	
	local var_193_30
	
	for iter_193_14 = #var_193_0, 1, -1 do
		local var_193_31 = var_193_0[iter_193_14]:isValidTarget(arg_193_2, var_193_5)
		local var_193_32 = var_193_0[iter_193_14]:isSkillEffectTargetable()
		
		if (not arg_193_5 and not arg_193_3 and not var_193_31 and not var_193_29 or not var_193_32) and #var_193_0 > 0 then
			var_193_30 = table.remove(var_193_0, iter_193_14)
		end
	end
	
	if table.empty(var_193_0) then
		var_193_0 = {
			arg_193_3 or var_193_30
		}
	end
	
	return var_193_0, var_193_1
end

function var_0_3.AI_SelectSkillIdxAndTarget(arg_196_0, arg_196_1, arg_196_2, arg_196_3, arg_196_4, arg_196_5)
	return AIManager:selectSkillIdxAndTarget(arg_196_1, arg_196_2, arg_196_3, arg_196_4, arg_196_5)
end

function var_0_3.getSkill_AI_ID(arg_197_0, arg_197_1, arg_197_2)
	local var_197_0 = "_m"
	
	if arg_197_0:isPVP() or arg_197_1.inst.ally == FRIEND then
		var_197_0 = "_p"
	end
	
	local var_197_1 = DB("skill", arg_197_2, "ai")
	
	if not var_197_1 then
		local var_197_2 = DB("skill", arg_197_2, "base_skill")
		
		var_197_1 = DB("skill", var_197_2, "ai") or "default"
	end
	
	return var_197_1 .. var_197_0
end

function var_0_3.onStartSkill(arg_198_0, arg_198_1, arg_198_2, arg_198_3)
	local var_198_0 = arg_198_0:getUnit(arg_198_1)
	local var_198_1 = arg_198_0:getUnit(arg_198_3)
	
	arg_198_0:doStartSkill(var_198_0, arg_198_2, var_198_1)
	
	arg_198_0.turn_info.attack_stats[arg_198_1] = "skill"
	
	arg_198_0:procBattleEvent("attack")
end

function var_0_3.setSkillHitInfo(arg_199_0, arg_199_1, arg_199_2)
	local var_199_0 = arg_199_0:getUnit(arg_199_1)
	local var_199_1 = arg_199_0:getAttackInfo(var_199_0)
	
	if not var_199_1 then
		Log.e(arg_199_0.name, "-----------------------------> att_info is nil <-----------------------------", arg_199_1, arg_199_2)
		
		return 
	end
	
	var_199_1.tot_hit = arg_199_2
	var_199_1.tot_soul = tonumber(var_199_1.soul_gain) or 0
	var_199_1.hit_soul = math.floor(var_199_1.tot_soul / (var_199_1.tot_hit or 1))
	
	arg_199_0:onInfos({
		type = "@skill_hitinfo",
		unit_uid = arg_199_1,
		att_info = var_199_1
	})
	
	arg_199_0.turn_info.attack_stats[arg_199_1] = "hitinfo"
end

function var_0_3.makeUnitProcInfo(arg_200_0, arg_200_1, arg_200_2)
	return {
		battle = arg_200_0,
		logic = arg_200_0,
		random = arg_200_0.random,
		skill_id = arg_200_1.skill_id,
		cur_hit = arg_200_1.cur_hit,
		tot_hit = arg_200_1.tot_hit,
		logic = arg_200_0,
		targets = table.alignment_clone(arg_200_1.d_units),
		selected_target = arg_200_1.selected_target,
		is_hidden = arg_200_1.is_hidden,
		is_counter = arg_200_1.is_counter,
		is_coop = arg_200_1.coop,
		tag = arg_200_2
	}
end

function var_0_3.makeHitEventInfos(arg_201_0, arg_201_1, arg_201_2)
	local var_201_0 = arg_201_0:getUnit(arg_201_1)
	
	if not var_201_0 then
		Log.e(arg_201_0.name, "생성되지 않은 영웅이 공격을 시도함", arg_201_1)
		
		return 
	end
	
	if var_201_0:isDead() then
		Log.e(arg_201_0.name, "죽은 영웅이 공격을 시도함", arg_201_1)
		
		return 
	end
	
	local var_201_1 = arg_201_0:getAttackInfo(var_201_0)
	
	if not var_201_1 then
		return 
	end
	
	arg_201_0:onInfos({
		state = "SKILL_HIT",
		parent = "ATTACK",
		type = "STATE"
	})
	
	if var_201_1.cur_hit > var_201_1.tot_hit then
		return 
	end
	
	var_201_1.cur_hit = var_201_1.cur_hit + 1
	
	local var_201_2 = arg_201_0:makeUnitProcInfo(var_201_1, arg_201_2)
	local var_201_3 = var_201_0:proc(var_201_2)
	
	if not var_201_3 then
		return 
	end
	
	for iter_201_0, iter_201_1 in pairs(var_201_3) do
		iter_201_1.tag = arg_201_2
	end
	
	arg_201_0:doAfterHeal(var_201_3)
	arg_201_0:onInfos(table.unpack(var_201_3))
	
	if var_201_2.cur_hit == var_201_2.tot_hit then
		arg_201_0:doEndHit(var_201_3, var_201_0)
	end
	
	return var_201_3
end

function var_0_3.getViewSeqId(arg_202_0)
	return #arg_202_0.view_history
end

function var_0_3.stopBattleFSM(arg_203_0)
	arg_203_0:procBattleEvent(nil)
end

function var_0_3.execute(arg_204_0, arg_204_1)
	local var_204_0 = arg_204_0.view_logger:popAll()
	
	if not var_204_0 or table.empty(var_204_0) then
		return 
	end
	
	arg_204_0.view_history[arg_204_0.turn_info.turn_num] = arg_204_0.view_history[arg_204_0.turn_info.turn_num] or {}
	arg_204_0.view_history[arg_204_0.turn_info.turn_num] = arg_204_1 and json.encode(var_204_0) or var_204_0
	arg_204_0.snap_history[arg_204_0.turn_info.turn_num] = arg_204_0.snap_history[arg_204_0.turn_info.turn_num] or {}
	arg_204_0.snap_history[arg_204_0.turn_info.turn_num] = table.clone(arg_204_0.snap:getData())
	arg_204_0.turn_info.turn_num = arg_204_0.turn_info.turn_num + 1
	
	LuaEventDispatcher:dispatchEvent("player.event", {
		type = "EXECUTE",
		infos = var_204_0
	})
end

function var_0_3.sortUnitStates(arg_205_0, arg_205_1)
	arg_205_0.unit_states_counter = arg_205_0.unit_states_counter or {}
	
	local var_205_0 = false
	
	for iter_205_0, iter_205_1 in pairs(arg_205_0.allocated_unit_tbl or {}) do
		if (arg_205_0:isViewPlayerActive() or not arg_205_0.unit_states_counter[iter_205_0] or arg_205_0.unit_states_counter[iter_205_0] ~= (iter_205_1.states.counter or 0)) and not iter_205_1:isEmptyHP() and not iter_205_1:isDead() then
			arg_205_0.unit_states_counter[iter_205_0] = iter_205_1.states.counter or 0
			
			iter_205_1.states:sort()
			
			var_205_0 = true
		end
	end
	
	if var_205_0 then
		arg_205_0:onInfos({
			type = "sort_order"
		})
	end
end

function var_0_3.doStartSkill(arg_206_0, arg_206_1, arg_206_2, arg_206_3, arg_206_4, arg_206_5)
	local var_206_0 = {}
	
	arg_206_1 = assert(arg_206_1)
	
	if not arg_206_4 then
		if not arg_206_5 or not arg_206_5.hidden then
			local var_206_1 = arg_206_0.turn_info.turn_owner and arg_206_0.turn_info.turn_owner:getUID() or -1
			
			arg_206_0:onInfos({
				type = "HANDLE",
				turn_count = arg_206_0.stage_counter,
				turn_owner = var_206_1
			})
		end
		
		arg_206_0:onInfos({
			state = "ATTACK",
			type = "STATE"
		})
	end
	
	arg_206_0:onInfos({
		state = "SKILL_START",
		parent = "ATTACK",
		type = "STATE"
	})
	
	local var_206_2
	
	if (arg_206_4 or 0) == 0 then
		var_206_2 = arg_206_0:checkCoopAttack(arg_206_1, arg_206_2, arg_206_3)
		arg_206_4 = var_206_2 and 1 or nil
	end
	
	arg_206_0:onInfos({
		flag = true,
		type = "set_ignore_hit_action",
		target = arg_206_1
	})
	
	local var_206_3 = arg_206_1:onUseSkill(arg_206_2, arg_206_0:isHiddenTurn())
	local var_206_4 = arg_206_0:_setupAttackInfo({
		attacker = arg_206_1,
		skill_id = arg_206_2,
		hit_info = var_206_3,
		selected_target = arg_206_3,
		coop_order = arg_206_4,
		coop_info = var_206_2
	}, arg_206_5 or {})
	
	table.insert(var_206_0, var_206_4)
	
	if arg_206_0:isAIPlayer(arg_206_1) then
		local var_206_5, var_206_6 = arg_206_1.states:isExistEffect("CSP_PHASESSWITCH")
		
		if var_206_5 then
			arg_206_0:onInfos({
				type = "@delay_skill",
				delay = to_n(var_206_6)
			})
		end
	end
	
	arg_206_0:onInfos({
		type = "sp_use",
		target = arg_206_1,
		sp_get = var_206_3.point_gain or 0,
		sp_use = var_206_3.point_require or 0
	})
	arg_206_0:onInfos({
		type = "@skill_start",
		unit = arg_206_1,
		att_info = var_206_4
	})
	table.insert(arg_206_0.turn_info.skill_history, {
		attacker = arg_206_1,
		att_info = var_206_4
	})
	
	local var_206_7 = {
		battle = arg_206_0,
		logic = arg_206_0,
		random = arg_206_0.random,
		skill_id = var_206_4.skill_id,
		logic = arg_206_0,
		targets = table.alignment_clone(var_206_4.d_units),
		is_hidden = arg_206_0:isHiddenTurn(),
		is_counter = (arg_206_0:getAttackOrder() or {}).counter,
		is_coop = var_206_4.coop,
		logs = {}
	}
	
	arg_206_1:procEffect(var_206_7, "start")
	arg_206_0:onInfos(table.unpack(var_206_7.logs))
	
	local var_206_8 = arg_206_1:getSkillDB(var_206_7.skill_id, "deal_damage")
	local var_206_9 = arg_206_1:onBeforeSkillDamage(var_206_7.skill_id, logic_shuffle(var_206_7.targets, arg_206_0.random:clone()), arg_206_1, var_206_8 and var_206_8 ~= "n", arg_206_3)
	
	arg_206_0:onInfos(table.unpack(var_206_9))
	
	for iter_206_0, iter_206_1 in pairs(arg_206_0.units) do
		arg_206_0:onInfos(iter_206_1.states:onToggle())
	end
	
	arg_206_0:onInfos({
		flag = false,
		type = "set_ignore_hit_action",
		target = arg_206_1
	})
	
	if var_206_2 then
		Log.d(arg_206_0.name, "협동기 발동!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", arg_206_1.inst.uid, arg_206_2)
		
		local var_206_10 = arg_206_3
		local var_206_11 = false
		
		for iter_206_2, iter_206_3 in pairs(var_206_4.d_units or {}) do
			if iter_206_3 == arg_206_3 then
				var_206_11 = true
				
				break
			end
		end
		
		if not var_206_11 then
			var_206_10 = var_206_4.d_unit
		end
		
		local var_206_12 = arg_206_0:doStartSkill(var_206_2.attacker, var_206_2.skill_id, var_206_10, arg_206_4 + 1, {
			coop = true
		})
		
		table.join(var_206_0, var_206_12)
	end
	
	return var_206_0
end

TEST_COOP = 0

function var_0_3.checkCoopAttack(arg_207_0, arg_207_1, arg_207_2, arg_207_3, arg_207_4)
	if arg_207_0:isHiddenTurn() then
		return 
	end
	
	local var_207_0, var_207_1 = DB("skill", arg_207_2, {
		"coop_con",
		"coop_value"
	})
	
	if not var_207_0 then
		return 
	end
	
	if arg_207_1.states:isExistEffect("CSP_COOP_BLOCK") then
		return 
	end
	
	local var_207_2 = arg_207_3
	
	if not var_207_2 then
		for iter_207_0, iter_207_1 in pairs(arg_207_0.allocated_unit_tbl) do
			Log.e(arg_207_0.name, "unit ", iter_207_1.inst.uid)
		end
	end
	
	if arg_207_1.inst.ally == var_207_2.inst.ally then
		return 
	end
	
	local var_207_3 = arg_207_0:pickUnits(arg_207_1, FRIEND, arg_207_1)
	local var_207_4 = arg_207_0.random:clone()
	local var_207_5 = {}
	local var_207_6 = 0
	local var_207_7
	local var_207_8 = {}
	
	for iter_207_2, iter_207_3 in pairs(var_207_3) do
		local var_207_9 = not iter_207_3:isDead()
		local var_207_10 = not iter_207_3:isStunned()
		local var_207_11 = iter_207_3.states:isExistEffect("CSP_UNABLE_ACTION_TURN_OTHER")
		local var_207_12 = iter_207_3.inst.code == "m9201"
		
		if var_207_9 and var_207_10 and not iter_207_3:isConcentration() and not var_207_12 and not var_207_11 then
			table.insert(var_207_8, iter_207_3)
		end
	end
	
	local var_207_13
	
	if TargetSelectUtil[var_207_0] then
		local var_207_14 = TargetSelectUtil[var_207_0](arg_207_1, var_207_8, var_207_1)
		
		if #var_207_14 > 1 then
			for iter_207_4, iter_207_5 in pairs(var_207_14) do
				if iter_207_5.states:isExistEffect("CSP_COOP_REACTION") then
					var_207_13 = var_207_13 or {}
					
					table.insert(var_207_13, iter_207_5)
				end
			end
			
			if var_207_13 then
				var_207_7 = var_207_13[var_207_4:get(1, #var_207_13)]
			else
				var_207_7 = var_207_14[var_207_4:get(1, #var_207_14)]
			end
		else
			var_207_7 = var_207_14[1]
		end
	else
		for iter_207_6, iter_207_7 in pairs(var_207_8) do
			if arg_207_1 ~= iter_207_7 then
				var_207_6 = var_207_6 + ((iter_207_7.status.coop or 0) + (TEST_COOP or 0))
				
				table.insert(var_207_5, {
					unit = iter_207_7,
					chance = var_207_6
				})
				
				if iter_207_7.states:isExistEffect("CSP_COOP_REACTION") then
					var_207_13 = var_207_13 or {}
					
					table.insert(var_207_13, iter_207_7)
				end
			end
		end
	end
	
	if var_207_6 > 1 then
		for iter_207_8, iter_207_9 in pairs(var_207_5) do
			iter_207_9.chance = iter_207_9.chance / var_207_6
			
			if iter_207_8 == table.count(var_207_5) then
				iter_207_9.chance = iter_207_9.chance + 1e-05
			end
		end
		
		var_207_6 = 1
	end
	
	local var_207_15 = var_207_4:get()
	
	if not arg_207_4 then
		if not var_207_7 then
			if var_207_13 then
				var_207_7 = var_207_13[var_207_4:get(1, #var_207_13)]
			else
				if #var_207_5 == 0 or var_207_6 == 0 then
					return 
				end
				
				if var_207_6 < var_207_15 then
					return 
				end
				
				for iter_207_10, iter_207_11 in ipairs(var_207_5) do
					if var_207_15 <= iter_207_11.chance then
						var_207_7 = iter_207_11.unit
						
						break
					end
				end
			end
		end
	else
		var_207_7 = arg_207_4
	end
	
	if not var_207_7 then
		Log.e(arg_207_0.name, "협광 확률 계산 실패. 디버그 요망", var_207_13)
		
		return 
	end
	
	if var_207_7 == arg_207_1 then
		Log.e(arg_207_0.name, "자기 자신에 대한 협공. 디버그 요망")
		
		return 
	end
	
	local var_207_16 = var_207_7.states:findByEff("CSP_COOP_REACTION")
	
	if var_207_16 then
		local var_207_17 = {}
		
		var_207_7.states:removeByUId(var_207_16.uid, var_207_17)
		arg_207_0:onInfos(table.unpack(var_207_17))
	end
	
	arg_207_0.random:shuffleSeed()
	var_207_7:onSkillBundleInit()
	
	local var_207_18 = var_207_7:getCoopSkillId()
	local var_207_19 = arg_207_0:getTargetCandidates(var_207_18, var_207_7, arg_207_3)
	
	return {
		attacker = var_207_7,
		skill_id = var_207_18,
		targets = var_207_19
	}
end

function var_0_3.encode(arg_208_0)
end

function var_0_3.decode(arg_209_0, arg_209_1)
end

function var_0_3.pickEnemies(arg_210_0, arg_210_1, arg_210_2, arg_210_3, arg_210_4, arg_210_5)
	return arg_210_0:pickUnits(arg_210_1, ENEMY, arg_210_2, arg_210_3, arg_210_4, arg_210_5)
end

function var_0_3.pickUnits(arg_211_0, arg_211_1, arg_211_2, arg_211_3, arg_211_4, arg_211_5, arg_211_6)
	local var_211_0
	
	if arg_211_1.inst.ally == arg_211_2 then
		var_211_0 = table.alignment_clone(arg_211_0.friends)
	else
		var_211_0 = table.alignment_clone(arg_211_0.enemies)
	end
	
	local function var_211_1(arg_212_0, arg_212_1)
		local var_212_0 = string.split(arg_212_0 or "", ",")
		
		for iter_212_0, iter_212_1 in pairs(var_212_0) do
			if iter_212_1 == arg_212_1 then
				return true
			end
		end
		
		return false
	end
	
	for iter_211_0 = #var_211_0, 1, -1 do
		if not arg_211_4 and var_211_0[iter_211_0]:isDead() or var_211_0[iter_211_0] == arg_211_3 or arg_211_5 and not var_211_1(arg_211_5, var_211_0[iter_211_0].db.color) or var_211_0[iter_211_0]:isDead() and not arg_211_6 and var_211_0[iter_211_0]:getResurrectBlock() or var_211_0[iter_211_0].inst.code == "cleardummy" then
			table.remove(var_211_0, iter_211_0)
		end
	end
	
	if #var_211_0 == 0 then
		return {}
	end
	
	return var_211_0
end

function var_0_3.pickDeadUnits(arg_213_0, arg_213_1, arg_213_2, arg_213_3, arg_213_4, arg_213_5)
	local var_213_0
	
	if arg_213_1.inst.ally == arg_213_2 then
		var_213_0 = table.alignment_clone(arg_213_0.friends)
	else
		var_213_0 = table.alignment_clone(arg_213_0.enemies)
	end
	
	for iter_213_0 = #var_213_0, 1, -1 do
		if not var_213_0[iter_213_0]:isDead() or var_213_0[iter_213_0] == arg_213_4 or not arg_213_5 and var_213_0[iter_213_0]:getResurrectBlock() then
			table.remove(var_213_0, iter_213_0)
		end
	end
	
	if arg_213_3 then
		while arg_213_3 < #var_213_0 do
			table.remove(var_213_0, #var_213_0)
		end
	end
	
	if #var_213_0 == 0 then
		return {}
	end
	
	return var_213_0
end

function var_0_3.pickDeadUnitsForSummon(arg_214_0, arg_214_1, arg_214_2, arg_214_3, arg_214_4)
	return arg_214_0:pickDeadUnits(arg_214_1, arg_214_2, arg_214_3, arg_214_4, true)
end

function var_0_3.pickRandomUnits(arg_215_0, arg_215_1, arg_215_2, arg_215_3, arg_215_4, arg_215_5, arg_215_6)
	local var_215_0
	
	if arg_215_1.inst.ally == arg_215_2 then
		var_215_0 = table.alignment_clone(arg_215_0.friends)
	else
		var_215_0 = table.alignment_clone(arg_215_0.enemies)
	end
	
	local var_215_1 = arg_215_0.random:clone()
	local var_215_2
	
	if type(arg_215_4) == "function" then
		var_215_2 = arg_215_4
		arg_215_4 = nil
	end
	
	if arg_215_6 and type(arg_215_6) == "function" then
		for iter_215_0 = #var_215_0, 1, -1 do
			if not arg_215_6(var_215_0[iter_215_0]) then
				table.remove(var_215_0, iter_215_0)
			end
		end
	end
	
	for iter_215_1 = #var_215_0, 1, -1 do
		if var_215_0[iter_215_1]:isDead() or var_215_0[iter_215_1] == arg_215_4 or var_215_0[iter_215_1].inst.code == "cleardummy" or var_215_2 and var_215_2(var_215_0[iter_215_1]) then
			table.remove(var_215_0, iter_215_1)
		end
	end
	
	if arg_215_3 then
		while arg_215_3 < #var_215_0 do
			table.remove(var_215_0, var_215_1:get(1, #var_215_0, arg_215_5))
		end
	else
		local var_215_3 = {}
		
		for iter_215_2 = #var_215_0, 1, -1 do
			local var_215_4 = var_215_1:get(1, #var_215_0, arg_215_5)
			local var_215_5 = var_215_0[var_215_4]
			
			table.push(var_215_3, var_215_5)
			table.remove(var_215_0, var_215_4)
		end
		
		var_215_0 = var_215_3
	end
	
	return var_215_0
end

function var_0_3.pickRandomDeadUnits(arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4, arg_216_5)
	local var_216_0 = arg_216_0:pickDeadUnits(arg_216_1, arg_216_2, nil, arg_216_4, arg_216_5)
	local var_216_1 = arg_216_0.random:clone()
	
	if arg_216_3 then
		while arg_216_3 < #var_216_0 do
			table.remove(var_216_0, var_216_1:get(1, #var_216_0, arg_216_4))
		end
	end
	
	return var_216_0
end

function var_0_3.pickRandomDeadUnitsForSummon(arg_217_0, arg_217_1, arg_217_2, arg_217_3, arg_217_4)
	return arg_217_0:pickRandomDeadUnits(arg_217_1, arg_217_2, arg_217_3, arg_217_4, true)
end

function var_0_3.pickRandomFromPrevDamagedTargets(arg_218_0, arg_218_1, arg_218_2)
	local var_218_0
	local var_218_1 = arg_218_0.random:clone()
	local var_218_2 = arg_218_1.inst.prev_damaged_targets or {}
	local var_218_3 = table.select(var_218_2, function(arg_219_0, arg_219_1)
		return not arg_219_1:isDead()
	end)
	
	if #var_218_3 == 0 then
		local var_218_4
		
		if arg_218_1.inst.ally == ENEMY then
			var_218_4 = table.alignment_clone(arg_218_0.friends)
		else
			var_218_4 = table.alignment_clone(arg_218_0.enemies)
		end
		
		local var_218_5 = false
		
		for iter_218_0 = #var_218_4, 1, -1 do
			local var_218_6 = var_218_4[iter_218_0]
			
			if not var_218_6:isDead() and not var_218_6:isEmptyHP() then
				if arg_218_1.inst.ally ~= var_218_6.inst.ally and (var_218_6.states:isExistEffect("CSP_STEALTH") or var_218_6.states:isExistEffect("CSP_STEALTH_STILL")) then
					var_218_5 = true
				else
					var_218_5 = false
					
					break
				end
			end
		end
		
		var_218_0 = arg_218_0:pickRandomUnits(arg_218_1, ENEMY, 1, function(arg_220_0)
			local var_220_0 = arg_220_0:isValidTarget(arg_218_1, arg_218_2)
			local var_220_1 = arg_220_0:isSkillEffectTargetable()
			local var_220_2 = false
			
			if not var_218_5 then
				var_220_2 = not var_220_0
			end
			
			return arg_220_0:isDead() or arg_220_0:isEmptyHP() or not var_220_1 or var_220_2
		end)
	else
		local var_218_7 = var_218_1:get(1, #var_218_3)
		
		var_218_0 = {
			var_218_3[var_218_7]
		}
	end
	
	return var_218_0
end

function var_0_3.pickUnitsByStatus(arg_221_0, arg_221_1, arg_221_2, arg_221_3, arg_221_4, arg_221_5, arg_221_6)
	local var_221_0
	
	if arg_221_1.inst.ally == arg_221_2 then
		var_221_0 = table.alignment_clone(arg_221_0.friends)
	else
		var_221_0 = table.alignment_clone(arg_221_0.enemies)
	end
	
	for iter_221_0 = #var_221_0, 1, -1 do
		if var_221_0[iter_221_0]:isDead() or arg_221_5 == var_221_0[iter_221_0] then
			table.remove(var_221_0, iter_221_0)
		end
	end
	
	local function var_221_1(arg_222_0, arg_222_1)
		return arg_222_1 < arg_222_0
	end
	
	local var_221_2 = {
		function(arg_223_0, arg_223_1)
			return arg_223_1 < arg_223_0
		end,
		function(arg_224_0, arg_224_1)
			return arg_224_0 < arg_224_1
		end
	}
	
	if arg_221_3 == 71 or arg_221_3 == 81 or arg_221_3 == 171 then
		function var_221_1(arg_225_0, arg_225_1)
			return var_221_2[1](arg_225_0.status.att, arg_225_1.status.att)
		end
	elseif arg_221_3 == 72 or arg_221_3 == 82 or arg_221_3 == 172 then
		function var_221_1(arg_226_0, arg_226_1)
			return var_221_2[2](arg_226_0.status.att, arg_226_1.status.att)
		end
	elseif arg_221_3 == 73 or arg_221_3 == 83 or arg_221_3 == 173 then
		function var_221_1(arg_227_0, arg_227_1)
			return var_221_2[1](arg_227_0.status.speed, arg_227_1.status.speed)
		end
	elseif arg_221_3 == 74 or arg_221_3 == 84 or arg_221_3 == 174 then
		function var_221_1(arg_228_0, arg_228_1)
			return var_221_2[2](arg_228_0.status.speed, arg_228_1.status.speed)
		end
	elseif arg_221_3 == 75 or arg_221_3 == 85 or arg_221_3 == 175 then
		function var_221_1(arg_229_0, arg_229_1)
			return var_221_2[1](arg_229_0.status.def, arg_229_1.status.def)
		end
	elseif arg_221_3 == 76 or arg_221_3 == 86 or arg_221_3 == 176 then
		function var_221_1(arg_230_0, arg_230_1)
			return var_221_2[2](arg_230_0.status.def, arg_230_1.status.def)
		end
	elseif arg_221_3 == 77 or arg_221_3 == 87 or arg_221_3 == 177 then
		function var_221_1(arg_231_0, arg_231_1)
			return var_221_2[1](arg_231_0:getMaxHP(), arg_231_1:getMaxHP())
		end
	elseif arg_221_3 == 78 or arg_221_3 == 88 or arg_221_3 == 178 then
		function var_221_1(arg_232_0, arg_232_1)
			return var_221_2[2](arg_232_0:getMaxHP(), arg_232_1:getMaxHP())
		end
	end
	
	table.sort(var_221_0, var_221_1)
	
	for iter_221_1 = arg_221_4 + 1, #var_221_0 do
		var_221_0[iter_221_1] = nil
	end
	
	return var_221_0
end

function var_0_3.new(arg_233_0, arg_233_1, arg_233_2, arg_233_3)
	local var_233_0 = {}
	
	if BattleLogic.mode then
		Log.e("ERROR : Battle Logic Mode is Not Nil", BattleLogic.mode)
		
		BattleLogic.mode = nil
	end
	
	if arg_233_3.mode == "net_rank" or arg_233_3.mode == "net_event_rank" or arg_233_3.mode == "net_friend" or arg_233_3.mode == "replay" or arg_233_3.mode == "net_local_test" then
		copy_functions(BattleLogicClient, var_233_0)
	elseif arg_233_3.mode == "net_server" then
		copy_functions(BattleLogicServer, var_233_0)
	elseif arg_233_3.mode == "ai_agent" then
		copy_functions(BattleLogicAIAgent, var_233_0)
	elseif arg_233_3.is_sync then
		copy_functions(BattleLogicSync, var_233_0)
	elseif arg_233_3.is_verify then
		copy_functions(BattleLogicVerify, var_233_0)
	else
		copy_functions(BattleLogic, var_233_0)
	end
	
	var_233_0:init(arg_233_1, arg_233_2, arg_233_3)
	
	return var_233_0
end

function var_0_3.init(arg_234_0, arg_234_1, arg_234_2, arg_234_3)
	assert(BattleLogic ~= arg_234_0)
	
	arg_234_0.name = "LOGIC"
	arg_234_0.mode = arg_234_3.mode
	arg_234_0.map = table.shallow_clone(arg_234_1)
	arg_234_0.service = arg_234_3.service
	arg_234_0.snap = BattleLogicSnap:create(arg_234_0)
	
	local var_234_0 = ((arg_234_3 or {}).started_data or {}).clear_event or {}
	
	arg_234_0.stageMap = BattleStageMap:new(arg_234_0.map, {
		ignore_road_events = arg_234_3.ignore_road_events,
		clear_event_list = var_234_0
	})
	arg_234_0._paused = {}
	arg_234_0.encounter_enemy_count = 0
	arg_234_0.stage = 1
	arg_234_0.stage_counter = 0
	arg_234_0.team_stage_counter = {
		[FRIEND] = 0,
		[ENEMY] = 0
	}
	arg_234_0.stage_unit_order_count = 1
	arg_234_0.stage_unit_order_info = {}
	arg_234_0.prepend_stage = ""
	arg_234_0.tick = 0
	arg_234_0.round_tick = 0
	arg_234_0.seed = arg_234_1.seed
	arg_234_1.logic_seed = arg_234_1.logic_seed or arg_234_1.seed
	arg_234_0.logic_seed = arg_234_1.logic_seed
	arg_234_0.pvp = arg_234_1.pvp
	arg_234_0.tournament_id = arg_234_1.tournament_id
	arg_234_0.clan_war = arg_234_1.clan_war
	arg_234_0.skill_preview = arg_234_1.skill_preview
	arg_234_0.unit_states_counter = {}
	arg_234_0.random = getRandom(arg_234_1.logic_seed, "logic")
	arg_234_0.type, arg_234_0.auto_battle_able = DB("level_enter", arg_234_0.map.enter, {
		"type",
		"auto_battle_able"
	})
	
	if not arg_234_0.type then
		arg_234_0.type = ""
	end
	
	if arg_234_0.auto_battle_able and arg_234_0.auto_battle_able == "y" then
		arg_234_0.auto_battle_able = true
	end
	
	arg_234_0.logger = BattleLogger:new()
	arg_234_0.view_logger = BattleLogger:new()
	arg_234_0.view_history = {}
	arg_234_0.snap_history = {}
	arg_234_0.units = {}
	arg_234_0.friends = {}
	arg_234_0.enemies = {}
	arg_234_0.latest_enemies = {}
	arg_234_0.world_arena_season_id = arg_234_3.world_arena_season_id
	arg_234_0.home_arena_uid = arg_234_3.home_arena_uid
	arg_234_0.away_arena_uid = arg_234_3.away_arena_uid
	arg_234_0.dual_control = arg_234_3.dual_control
	arg_234_0.pet = nil
	arg_234_0.starting_friends = {}
	arg_234_0.allocated_unit_tbl = {}
	arg_234_0.peak_stats = {}
	arg_234_0.last_stage_result = nil
	arg_234_0.teams = {}
	arg_234_0.team_data = arg_234_2
	arg_234_0.restore_view_infos = {}
	arg_234_0.statistic_view_infos = {}
	arg_234_0.make_view_data = arg_234_3.make_view_data
	arg_234_0.vsm = VerifySpecManager:create({
		logic = arg_234_0
	})
	arg_234_0.battle_info = {
		proc_info = {
			counter = 0,
			next_unit_uid = -400000,
			skill_uid = 0
		},
		replay_data = {},
		group_flags = {},
		level_flags = {},
		already_completed_road_event_tbl = {},
		completed_road_event_tbl = {},
		results_road_event_tbl = {},
		count_road_event_tbl = {},
		destoryed_road_event_tbl = {},
		npc_road_event_tbl = {},
		mission_state_tbl = {},
		road_info = {},
		entered_road_sector_tbl = {},
		insight_road_sector_tbl = {},
		back_point_stack = {},
		using_potion = {},
		camping_data = {},
		morale_tbl = {},
		concentration_info = {},
		reward_list = {},
		substory_info = {},
		morale_log = {},
		rta_penalty_info = {},
		played_story_list = {},
		condition_datas = {},
		state_invoke_info = {},
		skill_history = {}
	}
	arg_234_0.road_event_run_info = {
		pending_list = {}
	}
	arg_234_0.turn_info = {}
	
	if arg_234_0.stageMap.initial_pass_sector then
		for iter_234_0, iter_234_1 in pairs(arg_234_0.stageMap.initial_pass_sector) do
			arg_234_0.battle_info.entered_road_sector_tbl[iter_234_0] = iter_234_1
		end
	end
	
	arg_234_0.att_info_map = {}
	arg_234_0.logDiffDamage = {}
	arg_234_0.encrypt = {
		expedition_score_delivered = 0,
		clock_tick = 0,
		last_tick = 0,
		trial_score = 0,
		expedition_score = 0,
		expedition_total_score = 0,
		accum_delta = 0,
		logMaxDamage = 0,
		logPeakSpeed = 0
	}
	arg_234_0.init_battle_info = arg_234_3.init_battle_info
	
	arg_234_0:setMonsterDevice(arg_234_3.monster_device)
	arg_234_0:setUserDevice(arg_234_3.user_device)
	arg_234_0:setRTA_passive_info(arg_234_3.rta_passive_info or {})
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_235_0)
			arg_234_0.encrypt = arg_235_0(arg_234_0.encrypt)
		end, true)
	else
		var_0_2(arg_234_0, true)
	end
	
	arg_234_0:setAccumulateDelta(true)
	
	if arg_234_3 then
		arg_234_0:initLogicData(arg_234_3)
	end
end

function var_0_3.initLogicData(arg_236_0, arg_236_1)
	arg_236_1.service = nil
	arg_236_0.init_data = arg_236_1
	
	local var_236_0 = arg_236_1.started_data
	local var_236_1 = {}
	
	if var_236_0 then
		arg_236_0.battle_info.substory_info.id = var_236_0.substory_id
		arg_236_0.battle_info.quest_m_id = var_236_0.quest_m_id
		
		for iter_236_0, iter_236_1 in pairs(var_236_0.quest_mission or {}) do
			arg_236_0.battle_info.mission_state_tbl[iter_236_0] = iter_236_1.state
		end
		
		for iter_236_2, iter_236_3 in pairs(var_236_0.battle_mission or {}) do
			arg_236_0.battle_info.mission_state_tbl[iter_236_2] = iter_236_3.state
		end
		
		if arg_236_0:isDungeonType() then
			var_236_1 = table.clone(var_236_0.pass_event or {})
		end
		
		for iter_236_4, iter_236_5 in pairs(var_236_0.clear_event or {}) do
			for iter_236_6, iter_236_7 in pairs(iter_236_5) do
				arg_236_0.battle_info.already_completed_road_event_tbl[iter_236_6] = iter_236_7
				arg_236_0.battle_info.completed_road_event_tbl[iter_236_6] = iter_236_7
			end
		end
		
		for iter_236_8 = 1, arg_236_0:getMoraleMaxStep() do
			local var_236_2 = 0
			
			if arg_236_0.stageMap.contents_type == "raid" then
				var_236_2 = 10
			end
			
			local var_236_3 = DBT("morale", tostring(iter_236_8 + var_236_2), {
				"morale_level",
				"morale_num",
				"buff_id",
				"range_desc",
				"morale_title",
				"morale_desc",
				"morale_detail_desc"
			})
			
			var_236_3.passive_id = DB("skill", var_236_3.buff_id, "sk_passive")
			arg_236_0.battle_info.morale_tbl[iter_236_8] = var_236_3
		end
		
		arg_236_0:setPracticeMode(var_236_0.practice_mode)
		arg_236_0:setMoonlightTheaterEpisodeID(var_236_0.mt_episode_id)
		arg_236_0:setBurningStoryID(var_236_0.burning_story_id)
		arg_236_0:setForcePreviewMode(var_236_0.force_preview_mode)
		arg_236_0:setSplInfo(var_236_0.spl_info)
	end
	
	table.merge(arg_236_0.battle_info.entered_road_sector_tbl, var_236_1)
	
	local var_236_4 = Team:makeTeam(arg_236_0.team_data)
	
	var_236_4:alignTeam(FRIEND)
	arg_236_0:setupTeamUnits(var_236_4)
	
	arg_236_0.teams[FRIEND] = var_236_4
	
	arg_236_0:addZlongBattleData(FRIEND, var_236_4.units)
	
	arg_236_0.result_stat = BattleStat:create(arg_236_0)
	arg_236_0.group_teams = {}
	arg_236_0.group_teams[1] = var_236_4
	
	for iter_236_9, iter_236_10 in pairs(arg_236_0.team_data.subteams or {}) do
		local var_236_5 = table.find(iter_236_10.units, function(arg_237_0, arg_237_1)
			return arg_237_1.pos == arg_236_0:getKeySlotPos()
		end)
		
		if var_236_5 then
			table.remove(iter_236_10.units, var_236_5)
		end
		
		local var_236_6 = Team:makeTeam(iter_236_10)
		
		var_236_6:alignTeam(FRIEND)
		
		arg_236_0.group_teams[iter_236_9 + 1] = var_236_6
	end
	
	arg_236_0:setTeamRes(FRIEND, "morale", arg_236_0:getMoraleValue("start"))
	
	for iter_236_11, iter_236_12 in pairs(arg_236_0.friends) do
		if arg_236_0:isViewPlayerActive() then
			if arg_236_0.service and arg_236_0.service:isDummy() then
				if GrowthBoost and GrowthBoost.apply then
					GrowthBoost:apply(iter_236_12, arg_236_0.init_data.grooth_boost_info)
				end
			else
				iter_236_12:applyGrowthBoost()
				iter_236_12:calc()
			end
		elseif GrowthBoost and GrowthBoost.apply then
			GrowthBoost:apply(iter_236_12, arg_236_0.init_data.grooth_boost_info)
		end
	end
	
	local var_236_7 = arg_236_1.restore_data
	
	if var_236_7 then
		arg_236_0:loadRestoreData(var_236_7)
	else
		if arg_236_0:isNeedToUpdateHP() then
			arg_236_0:procAutoHeal(true)
		end
		
		if arg_236_0:isAutomaton() then
			arg_236_0:calcAutomatonAllyHP(arg_236_1.automaton_ally_info)
		end
	end
	
	arg_236_0:checkLevelFlagCondition(true)
	arg_236_0:updateMoralePassive()
	arg_236_0:makeRtaPenaltyInfo()
	arg_236_0:updateRtaPenalty()
	
	local var_236_8 = {}
	
	for iter_236_13, iter_236_14 in pairs(arg_236_0.friends) do
		iter_236_14:resetVariablePassiveDirty()
		iter_236_14:procLotaContents(arg_236_0:getLotaInfo())
		table.add(var_236_8, iter_236_14.states:onEnterMap())
		table.add(var_236_8, iter_236_14.states:onToggle(nil, true))
		iter_236_14:onToggleVariablePassive()
	end
	
	if arg_236_0:isSkillPreview() then
		arg_236_0:setTeamRes(FRIEND, "soul_piece", GAME_STATIC_VARIABLE.max_soul_point * 8)
	end
	
	if arg_236_0:isSkillPreview() then
		arg_236_0:setTeamRes(FRIEND, "soul_piece", GAME_STATIC_VARIABLE.max_soul_point * 8)
	end
	
	if arg_236_0:isSkillPreview() then
		arg_236_0:setTeamRes(FRIEND, "soul_piece", GAME_STATIC_VARIABLE.max_soul_point * 8)
	end
	
	arg_236_0:sortUnitStates("init")
	arg_236_0:onInfos(table.unpack(var_236_8))
end

function var_0_3.getInitData(arg_238_0)
	return arg_238_0.init_data or {}
end

function var_0_3.getStartedData(arg_239_0)
	return (arg_239_0.init_data or {}).started_data or {}
end

function var_0_3.loadRestoreData(arg_240_0, arg_240_1)
	local var_240_0 = arg_240_1.team_info
	local var_240_1 = 0
	
	for iter_240_0, iter_240_1 in pairs(var_240_0.layout) do
		if assert(arg_240_0.friends[iter_240_0]).inst.id ~= iter_240_1.id then
			arg_240_0.friends[iter_240_0] = arg_240_0:getUnit(iter_240_1.id)
		end
		
		if arg_240_0.friends[iter_240_0] then
			arg_240_0.friends[iter_240_0]:setPos(iter_240_1.pos)
			
			if arg_240_0.friend_hidden == arg_240_0.friends[iter_240_0] then
				arg_240_0.friend_hidden = nil
			end
		end
		
		var_240_1 = math.max(iter_240_0, var_240_1)
	end
	
	for iter_240_2 = var_240_1, 1, -1 do
		if not arg_240_0.friends[iter_240_2] then
			table.remove(arg_240_0.friends, iter_240_2)
		end
	end
	
	for iter_240_3, iter_240_4 in pairs(var_240_0.units) do
		local var_240_2 = assert(arg_240_0:getUnit(iter_240_4.id))
		local var_240_3 = var_240_2:getSPName()
		
		var_240_2.inst.hp = iter_240_4.hp
		var_240_2.inst.exp = iter_240_4.exp
		var_240_2.inst[var_240_3] = iter_240_4.sp
		var_240_2.inst.skill_cool = iter_240_4.skill_cool
		
		var_240_2.states:restorePureData(iter_240_4.states)
		var_240_2:calc()
	end
	
	for iter_240_5, iter_240_6 in pairs(arg_240_0.friends) do
		if iter_240_6:getHP() <= 0 then
			iter_240_6:onDead()
		end
	end
	
	arg_240_0:setTeamRes(FRIEND, "turn", var_240_0.turn or 0)
	arg_240_0:setTeamRes(FRIEND, "soul_piece", var_240_0.soul_piece or 0)
	arg_240_0:setTeamRes(FRIEND, "morale", var_240_0.morale or 0)
	
	local var_240_4 = arg_240_1.battle_info
	
	for iter_240_7, iter_240_8 in pairs(arg_240_0.battle_info) do
		if type(var_240_4[iter_240_7]) == "table" then
			arg_240_0.battle_info[iter_240_7] = table.shallow_clone(var_240_4[iter_240_7])
		end
	end
end

function var_0_3.checkVSM(arg_241_0)
	if VERIFY_LOCAL_TEST then
		return 
	end
	
	if arg_241_0.init_data.is_verify then
		return 
	end
	
	if arg_241_0:isRealtimeMode() then
		return 
	end
	
	return arg_241_0.map.check_partial_verify
end

function var_0_3.getBattleReplayData(arg_242_0)
	if arg_242_0.map.check_entire_verify then
		return json.encode({
			start_data = arg_242_0:getStartedData(),
			replay = arg_242_0.battle_info.replay_data
		})
	end
end

function var_0_3.getRemoteReplayData(arg_243_0)
	return {
		snap_data = arg_243_0.snap_history
	}
end

function var_0_3.getRestoreViewInfos(arg_244_0)
	return arg_244_0.restore_view_infos
end

function var_0_3.getStatisticViewInfos(arg_245_0)
	return arg_245_0.statistic_view_infos
end

function var_0_3.getWebRecordDataFirstActionGauge(arg_246_0)
	return arg_246_0.first_sorted_action_gauges
end

function var_0_3.getWebRecordDataImprint(arg_247_0, arg_247_1)
	local var_247_0 = 0
	local var_247_1 = {}
	
	if arg_247_1 then
		local var_247_2, var_247_3, var_247_4 = DB("character", arg_247_1.db.code, {
			"devotion_skill",
			"devotion_skill_slot",
			"devotion_skill_self"
		})
		local var_247_5, var_247_6, var_247_7 = arg_247_1:getDevoteSkill()
		local var_247_8
		
		if var_247_2 and var_247_3 and var_247_4 and var_247_6 > 0 then
			function var_247_8(arg_248_0, arg_248_1)
				if not arg_248_1[arg_248_0] then
					arg_248_1[arg_248_0] = {}
				end
				
				if var_247_5 then
					table.insert(arg_248_1[arg_248_0], {
						type = var_247_5,
						stat = var_247_6
					})
				end
			end
			
			if var_247_7 then
				var_247_0 = 2
				
				local var_247_9 = tostring(arg_247_1.inst.pos or 0)
				
				var_247_8(var_247_9, var_247_1)
			else
				var_247_0 = 1
				
				local var_247_10 = string.split(var_247_3, ";")
				
				for iter_247_0, iter_247_1 in pairs(var_247_10) do
					if not var_247_1[iter_247_1] then
						var_247_1[iter_247_1] = {}
					end
					
					var_247_8(iter_247_1, var_247_1)
				end
			end
		end
	end
	
	return var_247_0, var_247_1
end

function var_0_3.exportPureLogicData(arg_249_0, arg_249_1)
	local function var_249_0(arg_250_0)
		if not arg_250_0 then
			return 
		end
		
		return {
			id = arg_250_0:getUID(),
			hp = arg_250_0:getHP(),
			sp = arg_250_0:getSP(),
			exp = arg_250_0:getEXP(),
			pos = arg_250_0.inst.pos,
			skill_cool = arg_250_0.inst.skill_cool,
			external_passive = arg_250_0:getExternalPassive(),
			supporter = arg_250_0:isSupporter(),
			states = arg_250_0.states:exportPureData()
		}
	end
	
	local var_249_1 = {}
	local var_249_2 = {}
	local var_249_3 = {}
	local var_249_4 = {}
	
	for iter_249_0, iter_249_1 in pairs(arg_249_0.friends) do
		var_249_3[iter_249_0] = {
			id = iter_249_1:getUID(),
			pos = iter_249_1.inst.pos
		}
		var_249_4[iter_249_1:getUID()] = iter_249_1
	end
	
	for iter_249_2, iter_249_3 in pairs(arg_249_0.starting_friends) do
		var_249_4[iter_249_3:getUID()] = iter_249_3
	end
	
	for iter_249_4, iter_249_5 in pairs(var_249_4) do
		var_249_2[iter_249_5:getUID()] = var_249_0(iter_249_5)
	end
	
	var_249_1.leader_idx = arg_249_0.teams[FRIEND].leader_idx
	var_249_1.layout = var_249_3
	var_249_1.units = var_249_2
	var_249_1.turn = arg_249_0:getTeamRes(FRIEND, "turn") or 0
	var_249_1.soul_piece = arg_249_0:getTeamRes(FRIEND, "soul_piece") or 0
	var_249_1.morale = arg_249_0:getTeamRes(FRIEND, "morale") or 0
	
	local var_249_5 = arg_249_1 or {}
	
	var_249_5.map = arg_249_0.map
	var_249_5.team = arg_249_0.team_data
	var_249_5.team_info = var_249_1
	var_249_5.started_data = arg_249_0.init_data.started_data
	var_249_5.battle_info = arg_249_0.battle_info
	
	return table.filter_pure_value(var_249_5)
end

function var_0_3.debug(arg_251_0)
	do return  end
	
	print("FRIENDS:")
	
	for iter_251_0, iter_251_1 in pairs(arg_251_0.friends) do
		print(iter_251_1:getName(), iter_251_1.inst.lv, math.floor(iter_251_1.inst.elapsed_ut), iter_251_1.inst.hp)
	end
	
	print("ENEMIES:")
	
	for iter_251_2, iter_251_3 in pairs(arg_251_0.enemies) do
		print(iter_251_3:getName(), iter_251_3.inst.lv, math.floor(iter_251_3.inst.elapsed_ut), iter_251_3.inst.hp)
	end
	
	print("----------")
end

function var_0_3._setupAttackInfo(arg_252_0, arg_252_1, arg_252_2)
	local var_252_0
	local var_252_1 = arg_252_0:getTargetCandidates(arg_252_1.skill_id, arg_252_1.attacker, arg_252_1.selected_target, nil, arg_252_2.hidden)
	local var_252_2 = arg_252_0:getTargetCandidates(arg_252_1.skill_id, arg_252_1.attacker)
	local var_252_3 = tonumber(arg_252_1.hit_info.soul_gain) or 0
	
	if table.find(var_252_1, arg_252_1.selected_target) then
		local var_252_4 = arg_252_1.selected_target
	else
		local var_252_5 = var_252_1[1]
	end
	
	local var_252_6
	local var_252_7
	local var_252_8
	local var_252_9
	
	var_252_9 = arg_252_1.attacker:getSkinCheck() or "hit_count"
	
	local var_252_10 = (arg_252_0.battle_info.proc_info.skill_uid or 0) + 1
	local var_252_11 = {
		mul_dmg = 1,
		cur_hit = 0,
		skill_uid = var_252_10,
		skill_id = arg_252_1.skill_id,
		attacker = arg_252_1.attacker,
		a_unit = arg_252_1.attacker,
		d_unit = var_252_1[1],
		d_units = var_252_1,
		selected_target = arg_252_1.selected_target,
		soul_gain = var_252_3,
		coop_order = arg_252_1.coop_order,
		target_candidates = var_252_2,
		tot_hit = var_252_6,
		tot_soul = var_252_7,
		hit_soul = var_252_8,
		hit_info = arg_252_1.hit_info,
		is_hidden = arg_252_0:isHiddenTurn(),
		is_counter = (arg_252_0:getAttackOrder() or {}).counter
	}
	
	for iter_252_0, iter_252_1 in pairs(arg_252_2 or {}) do
		if not var_252_11[iter_252_0] then
			var_252_11[iter_252_0] = iter_252_1
		end
	end
	
	arg_252_0.att_info_map[arg_252_1.attacker] = var_252_11
	
	return var_252_11
end

function var_0_3.isScoreType(arg_253_0)
	return arg_253_0.type == "trial_hall"
end

function var_0_3.isExpeditionType(arg_254_0)
	return (arg_254_0.type == "coop" or arg_254_0.type == "heritage" or arg_254_0:isLotaContents()) and arg_254_0.stageMap.expedition_info
end

function var_0_3.isLotaExpeditionType(arg_255_0)
	return arg_255_0:isExpeditionType() and arg_255_0:isLotaContents()
end

function var_0_3.isLotaContents(arg_256_0)
	return arg_256_0:getLotaInfo().is_lota_contents
end

function var_0_3.setSplInfo(arg_257_0, arg_257_1)
	arg_257_0.battle_info.spl_info = arg_257_1
end

function var_0_3.getSplInfo(arg_258_0)
	return arg_258_0.battle_info.spl_info
end

function var_0_3.isSplType(arg_259_0)
	return arg_259_0.type == "tile_sub" and arg_259_0:getSplInfo() ~= nil
end

function var_0_3.getLotaInfo(arg_260_0)
	return arg_260_0.stageMap.lota_info or {}
end

function var_0_3.isScoringUnit(arg_261_0, arg_261_1)
	if not arg_261_0:isScoreType() and not arg_261_0:isExpeditionType() then
		return 
	end
	
	local function var_261_0(arg_262_0, arg_262_1)
		if arg_261_1 and arg_261_1.inst.ally == ENEMY and arg_261_1.db.code == arg_262_1 then
			local var_262_0 = arg_262_0:getRunningRoadEventObject()
			
			for iter_262_0, iter_262_1 in pairs(var_262_0.mobs or {}) do
				if arg_262_1 == iter_262_1.code then
					return true
				end
			end
		end
		
		return false
	end
	
	local var_261_1 = arg_261_0:getExpeditionInfo().boss_info
	
	if var_261_1 then
		return var_261_0(arg_261_0, var_261_1.character_id)
	end
	
	local var_261_2 = arg_261_0:getTrialHallInfo()
	
	if var_261_2 then
		return var_261_0(arg_261_0, var_261_2.boss_id)
	end
end

function var_0_3.setDamageScore(arg_263_0, arg_263_1)
	if arg_263_0:isScoreType() then
		arg_263_0:setTrialScore(arg_263_1)
	end
	
	if arg_263_0:isExpeditionType() then
		arg_263_0:setExpeditionScore(arg_263_1)
	end
end

function var_0_3.getExpeditionBoss(arg_264_0)
	local var_264_0 = {}
	local var_264_1 = arg_264_0:getExpeditionInfo().boss_info or {}
	
	for iter_264_0, iter_264_1 in pairs(arg_264_0.enemies or {}) do
		if iter_264_1.db.code == var_264_1.character_id then
			var_264_0.max_hp = iter_264_1:getMaxHP()
			var_264_0.hp = iter_264_1:getHP()
			
			return var_264_0, iter_264_1
		end
	end
end

function var_0_3.updateExpeditionInfo(arg_265_0, arg_265_1, arg_265_2)
	local var_265_0 = arg_265_0.stageMap.expedition_info
	local var_265_1, var_265_2 = arg_265_0:getExpeditionBoss()
	
	if not var_265_1 then
		return 
	end
	
	local var_265_3 = arg_265_1.last_hp
	
	if var_265_2 then
		if not arg_265_1.max_hp and arg_265_1.boss_info then
			arg_265_1.max_hp = arg_265_1.boss_info.max_hp
		end
		
		var_265_2:setExpeditionInfo(arg_265_1)
		
		if arg_265_2 then
			var_265_2:calc()
		end
		
		local var_265_4 = var_265_2.inst.hp
		
		var_265_2.inst.hp = math.max(0, var_265_3 - arg_265_0:getExpeditionScore())
		
		arg_265_0:onInfos({
			type = "expedition_update",
			target = var_265_2
		})
	end
	
	arg_265_0.stageMap.expedition_info = arg_265_1
end

function var_0_3.getExpeditionInfo(arg_266_0)
	return arg_266_0.stageMap.expedition_info or {}
end

function var_0_3.deliveredExpeditionScore(arg_267_0)
	local var_267_0 = arg_267_0.encrypt.expedition_score_delivered or 0
	
	arg_267_0.encrypt.expedition_score_delivered = var_267_0 + arg_267_0.encrypt.expedition_score
	arg_267_0.encrypt.expedition_score = 0
end

function var_0_3.clearExpeditionScore(arg_268_0)
	arg_268_0.encrypt.expedition_score_delivered = 0
end

function var_0_3.setExpeditionScore(arg_269_0, arg_269_1)
	arg_269_0.encrypt.expedition_score = to_n(arg_269_0.encrypt.expedition_score) + to_n(arg_269_1)
	arg_269_0.encrypt.expedition_total_score = to_n(arg_269_0.encrypt.expedition_total_score) + to_n(arg_269_1)
end

function var_0_3.getExpeditionScore(arg_270_0)
	return (arg_270_0.encrypt.expedition_score or 0) + (arg_270_0.encrypt.expedition_score_delivered or 0)
end

function var_0_3.getExpeditionTotalScore(arg_271_0)
	return arg_271_0.encrypt.expedition_total_score or 0
end

function var_0_3.setTrialScore(arg_272_0, arg_272_1)
	arg_272_0.encrypt.trial_score = to_n(arg_272_0.encrypt.trial_score) + to_n(arg_272_1)
end

function var_0_3.getTrialHallInfo(arg_273_0)
	return arg_273_0.stageMap.trial_info
end

function var_0_3.getTrialScore(arg_274_0)
	return arg_274_0.encrypt.trial_score
end

function var_0_3.getPeakSpeed(arg_275_0)
	return arg_275_0.encrypt.logPeakSpeed
end

function var_0_3.setPeakSpeed(arg_276_0, arg_276_1)
	if not getenv then
		return 
	end
	
	local var_276_0 = arg_276_1 or getenv("time_scale")
	
	if not arg_276_0.encrypt.logPeakSpeed or arg_276_0.encrypt.logPeakSpeed < to_n(var_276_0) then
		arg_276_0.encrypt.logPeakSpeed = to_n(var_276_0)
	end
end

function var_0_3.setAccumulateDelta(arg_277_0, arg_277_1)
	arg_277_0.accum_delta_flag = arg_277_1
	
	if arg_277_1 then
		arg_277_0.encrypt.accum_delta = 0
		arg_277_0.encrypt.last_tick = LAST_TICK
		arg_277_0.encrypt.clock_tick = os.clock()
		arg_277_0.os_time = os.time()
	end
end

function var_0_3.getOmegaData(arg_278_0)
	local var_278_0 = arg_278_0.encrypt.accum_delta
	local var_278_1 = (LAST_TICK - arg_278_0.encrypt.last_tick) / 1000
	local var_278_2 = os.clock() - arg_278_0.encrypt.clock_tick
	local var_278_3 = round(var_278_0, 4)
	local var_278_4 = round(var_278_1, 4)
	local var_278_5 = round(var_278_2, 4)
	
	return var_278_3, var_278_4, var_278_5
end

function var_0_3.updateProcessDelta(arg_279_0)
	arg_279_0.encrypt.accum_delta = arg_279_0.encrypt.accum_delta + CUR_PROCESS_DELTA
end

function var_0_3.setPracticeMode(arg_280_0, arg_280_1)
	arg_280_0.practice_mode = arg_280_1
end

function var_0_3.isPracticeMode(arg_281_0)
	return arg_281_0.practice_mode
end

function var_0_3.getTurnState(arg_282_0)
	return arg_282_0.turn_info.state
end

function var_0_3.isTurnAddMore(arg_283_0)
	return arg_283_0.turn_info.is_add_more
end

function var_0_3.getRunningEventState(arg_284_0)
	return arg_284_0.road_event_run_info.state_name
end

function var_0_3.getAttackInfo(arg_285_0, arg_285_1)
	if not arg_285_1 or not arg_285_0.att_info_map then
		return 
	end
	
	return arg_285_0.att_info_map[arg_285_1]
end

function var_0_3.getMissionState(arg_286_0, arg_286_1)
	return arg_286_0.battle_info.mission_state_tbl[arg_286_1]
end

function var_0_3.setTeamRes(arg_287_0, arg_287_1, arg_287_2, arg_287_3)
	return arg_287_0.teams[arg_287_1]:setRes(arg_287_2, arg_287_3)
end

function var_0_3.getTeamRes(arg_288_0, arg_288_1, arg_288_2)
	if arg_288_0.teams and arg_288_0.teams[arg_288_1] then
		return arg_288_0.teams[arg_288_1]:getRes(arg_288_2)
	end
end

function var_0_3.addTeamRes(arg_289_0, arg_289_1, arg_289_2, arg_289_3)
	if arg_289_0:isScoreType() and arg_289_2 == "soul_piece" then
		return 
	end
	
	return arg_289_0.teams[arg_289_1]:addRes(arg_289_2, arg_289_3)
end

function var_0_3.setReserveDrops(arg_290_0, arg_290_1, arg_290_2)
	return arg_290_0.teams[arg_290_1]:setReserveDrops(arg_290_2)
end

function var_0_3.getReserveDrops(arg_291_0, arg_291_1)
	return arg_291_0.teams[arg_291_1]:getReserveDrops()
end

function var_0_3.getSummon(arg_292_0, arg_292_1)
	return arg_292_0.teams[arg_292_1].summon
end

function var_0_3.getSummonSkillUseInfo(arg_293_0, arg_293_1)
	local var_293_0 = arg_293_0:getSummon(arg_293_1)
	
	if not var_293_0 then
		return {}
	end
	
	local var_293_1 = to_n(arg_293_0:getTeamRes(arg_293_1, "soul_piece"))
	local var_293_2 = to_n(var_293_0:getSkillReqPoint(var_293_0:getSkillByIndex(1)))
	
	return {
		summon = var_293_0,
		req_point = var_293_2,
		cur_point = var_293_1,
		useable = var_293_2 <= var_293_1
	}
end

function var_0_3.onSummonSkill(arg_294_0)
	local var_294_0 = arg_294_0:getTurnOwner().inst.ally
	local var_294_1 = arg_294_0:getSummonSkillUseInfo(var_294_0)
	
	if var_294_1.useable then
		local var_294_2 = var_294_1.summon
		
		var_294_2:onSetupStage(arg_294_0)
		arg_294_0:addTeamRes(var_294_0, "soul_piece", -var_294_1.req_point)
		arg_294_0:onInfos({
			type = "@summon_skill",
			summon = var_294_2
		})
		
		local var_294_3 = var_294_2:getSkillByIndex(1)
		
		arg_294_0:doStartSkill(var_294_2, var_294_3)
		arg_294_0:procBattleEvent("attack")
	end
end

function var_0_3.createUnit(arg_295_0, arg_295_1)
end

function var_0_3.setupTeamUnits(arg_296_0, arg_296_1)
	local var_296_0 = arg_296_1.units
	
	if arg_296_0.map.friend_data and arg_296_0.map.friend_data.unit then
		local var_296_1 = table.clone(arg_296_0.map.friend_data.unit)
		local var_296_2 = var_296_1.id
		
		if not var_296_1.id then
			var_296_1.id = UID_SUPPORTER_PREFIX
			var_296_2 = var_296_1.id
		end
		
		local var_296_3 = UNIT:create(var_296_1, true)
		
		var_296_3:setSupporter(true)
		
		for iter_296_0, iter_296_1 in pairs(arg_296_0.map.friend_data.external_passive or {}) do
			var_296_3:addExternalPassive(iter_296_1.passive_id, iter_296_1.passive_lv)
		end
		
		if var_296_2 then
			for iter_296_2, iter_296_3 in pairs(arg_296_0.map.friend_data.equips) do
				if iter_296_3.p == var_296_2 then
					local var_296_4 = EQUIP:createByInfo(iter_296_3)
					
					if var_296_4 then
						var_296_3:addEquip(var_296_4, true)
					end
				end
			end
		end
		
		var_296_3:calc()
		
		arg_296_0.friend_hidden = var_296_3
	end
	
	arg_296_1:addManuallyDevoteStats(arg_296_0.friend_hidden)
	
	local var_296_5
	
	if arg_296_0.friend_hidden then
		if arg_296_0.map.supporter_pos then
			var_296_0[arg_296_0.map.supporter_pos] = arg_296_0.friend_hidden
			
			arg_296_0.friend_hidden:setPos(arg_296_0.map.supporter_pos)
			
			arg_296_0.friend_hidden = nil
		else
			var_296_5 = {}
			
			local var_296_6 = {}
			
			for iter_296_4, iter_296_5 in pairs(var_296_0) do
				var_296_5[iter_296_5.inst.pos] = true
				var_296_6[iter_296_5.db.code] = true
			end
			
			if true or not var_296_6[arg_296_0.friend_hidden.db.code] then
				for iter_296_6 = 1, 4 do
					if not var_296_5[iter_296_6] then
						var_296_0[#var_296_0 + 1] = arg_296_0.friend_hidden
						
						arg_296_0.friend_hidden:setPos(iter_296_6)
						
						arg_296_0.friend_hidden = nil
						
						break
					end
				end
			end
		end
	end
	
	local var_296_7, var_296_8 = DB("level_enter", arg_296_0.map.enter, {
		"ally_buff",
		"ally_buff_lv"
	})
	
	for iter_296_7, iter_296_8 in pairs(var_296_0) do
		iter_296_8:onSetupTeam(arg_296_1)
		table.insert(arg_296_0.friends, iter_296_8)
		table.insert(arg_296_0.units, iter_296_8)
		arg_296_0:addAllocatedUnit(iter_296_8)
		
		if arg_296_0:isNeedToStartWithFullHP() then
			iter_296_8.inst.hp = iter_296_8:getRawMaxHP()
			
			if iter_296_8:getSPName() == "mp" then
				iter_296_8.inst.mp = GAME_STATIC_VARIABLE.mana_max
			end
		end
		
		if var_296_7 then
			iter_296_8:addState(var_296_7, var_296_8 or 1, iter_296_8)
		end
		
		arg_296_0:addAutomatonAllyDevice(iter_296_8)
	end
	
	arg_296_0:addRTA_passive(arg_296_0.friends, arg_296_0.rta_passive_info[FRIEND])
	
	if arg_296_0.friend_hidden then
		local var_296_9 = arg_296_0.friend_hidden
		
		var_296_9:onSetupTeam(arg_296_1)
		arg_296_0:addAllocatedUnit(var_296_9)
	end
	
	for iter_296_9, iter_296_10 in pairs(var_296_0) do
		iter_296_10:calc()
		
		iter_296_10.inst.no = iter_296_9
		iter_296_10.inst.arena_uid = arg_296_0.home_arena_uid
		
		if not iter_296_10:isSummon() and not iter_296_10:isSupporter() then
			table.insert(arg_296_0.starting_friends, iter_296_10)
		end
	end
	
	if arg_296_1.summon then
		local var_296_10 = arg_296_1.summon
		
		arg_296_0:addAllocatedUnit(var_296_10)
	end
	
	for iter_296_11, iter_296_12 in pairs(arg_296_0.units) do
		iter_296_12:onSetupStage(arg_296_0)
	end
	
	if arg_296_1.pet and PetUtil:isPetEnableMap(arg_296_0.map.enter) then
		arg_296_0.pet = PET:create(arg_296_1.pet)
	end
	
	if arg_296_0.enemy_hidden then
		arg_296_0.enemy_hidden:onSetupStage(arg_296_0)
	end
	
	if arg_296_0.friend_hidden then
		arg_296_0.friend_hidden:onSetupStage(arg_296_0)
	end
end

function var_0_3.addAutomatonAllyDevice(arg_297_0, arg_297_1)
	if not arg_297_1 or not arg_297_0:isAutomaton() then
		return 
	end
	
	local var_297_0 = arg_297_0:getUserDevice() or {}
	
	if table.empty(var_297_0) then
		return 
	end
	
	for iter_297_0, iter_297_1 in pairs(var_297_0) do
		local var_297_1 = iter_297_0
		local var_297_2 = "skill_" .. iter_297_1
		local var_297_3, var_297_4, var_297_5, var_297_6, var_297_7 = DB("level_automaton_device", var_297_1, {
			"category",
			"category_sub",
			"character",
			"skill_origin",
			var_297_2
		})
		
		if var_297_7 then
			if var_297_6 and var_297_3 == "hero" and var_297_5 and var_297_5 == arg_297_1.db.code then
				local var_297_8 = arg_297_1:getSkillIndex(var_297_6)
				
				if var_297_8 then
					arg_297_1:mergeSkill(var_297_7, var_297_8)
					arg_297_1:mergeSkillCool(var_297_7, var_297_6)
				end
			else
				local var_297_9 = DB("skill", var_297_7, {
					"sk_passive"
				})
				
				if var_297_5 then
					if arg_297_1.db and var_297_5 == arg_297_1.db.code then
						arg_297_1:addState(var_297_9, 1, arg_297_1)
					end
				else
					arg_297_1:addState(var_297_9, 1, arg_297_1)
				end
			end
		end
	end
end

function var_0_3.setRTA_passive_info(arg_298_0, arg_298_1)
	arg_298_0.rta_passive_info = arg_298_1
end

function var_0_3.addRTA_passive(arg_299_0, arg_299_1, arg_299_2)
	for iter_299_0, iter_299_1 in pairs(arg_299_1 or {}) do
		for iter_299_2, iter_299_3 in pairs(arg_299_2 or {}) do
			if not iter_299_1:checkState(iter_299_3) then
				local var_299_0, var_299_1 = iter_299_1:addState(iter_299_3, 1, nil, {
					turn = 9999
				})
				
				if var_299_1 then
					arg_299_0:onInfos({
						type = "add_state",
						target = iter_299_1,
						state = var_299_1
					})
				end
			end
		end
	end
end

function var_0_3.getSideRoadDir(arg_300_0, arg_300_1)
	if not arg_300_0.battle_info.road_info then
		return 
	end
	
	local var_300_0 = arg_300_0.battle_info.road_info.road_id
	local var_300_1 = arg_300_0.stageMap:getRoadObject(arg_300_1)
	
	if var_300_1 and var_300_1.dirs then
		for iter_300_0, iter_300_1 in pairs(var_300_1.dirs) do
			if iter_300_1.goal_id and iter_300_1.goal_id == var_300_0 or iter_300_1.road_id and iter_300_1.road_id == var_300_0 then
				return to_reverse_dir(iter_300_0)
			end
		end
	end
end

function var_0_3.onMissionStates(arg_301_0, arg_301_1)
	for iter_301_0, iter_301_1 in pairs(arg_301_1) do
		arg_301_0.battle_info.mission_state_tbl[iter_301_0] = iter_301_1
	end
end

function var_0_3.onEnterRoad(arg_302_0, arg_302_1, arg_302_2)
	arg_302_2 = arg_302_2 or {}
	
	local var_302_0 = {}
	local var_302_1
	local var_302_2
	local var_302_3
	
	if arg_302_1 then
		var_302_2 = (arg_302_0.battle_info.road_info or {}).road_id
	else
		var_302_3 = true
		var_302_0 = arg_302_0.battle_info.road_info or {}
		
		if var_302_0 and var_302_0.road_id then
			arg_302_1 = var_302_0.road_id
			var_302_2 = var_302_0.prev_road_id
			var_302_1 = arg_302_0.battle_info.road_info.current_sector_id
		else
			arg_302_1 = arg_302_0.stageMap.start_road_id
			var_302_2 = arg_302_0.stageMap.prev_road_id
		end
	end
	
	local var_302_4 = arg_302_0.stageMap:getRoadObject(arg_302_1)
	local var_302_5 = 0
	
	for iter_302_0, iter_302_1 in pairs(var_302_4.event_object_list) do
		if iter_302_1:isBattleType() then
			var_302_5 = var_302_5 + 1
		end
	end
	
	local var_302_6 = false
	local var_302_7 = "right"
	
	if var_302_4.dirs then
		local var_302_8
		
		for iter_302_2, iter_302_3 in pairs(var_302_4.dirs) do
			var_302_8 = to_reverse_dir(iter_302_2)
			
			if iter_302_3.goal_id and iter_302_3.goal_id == var_302_2 or iter_302_3.road_id and iter_302_3.road_id == var_302_2 then
				var_302_7 = var_302_8
				var_302_6 = true
				
				break
			end
		end
		
		if not var_302_6 and table.count(var_302_4.dirs) == 1 then
			var_302_7 = var_302_8
		end
	elseif arg_302_0.battle_info.road_info then
		local var_302_9 = false
		
		for iter_302_4, iter_302_5 in pairs(arg_302_0.battle_info.back_point_stack) do
			if iter_302_5.road_id == arg_302_1 then
				var_302_9 = true
				
				break
			end
		end
		
		if not var_302_9 then
			local var_302_10 = {
				road_id = arg_302_1,
				return_road_info = table.clone(arg_302_0.battle_info.road_info)
			}
			
			if arg_302_2.road_event_id then
				local var_302_11 = arg_302_0:getRoadEventObject(arg_302_2.road_event_id)
				
				if var_302_10.return_road_info.current_sector_id ~= var_302_11.sector_id then
					var_302_10.return_road_info.current_sector_id = var_302_11.sector_id
				end
			end
			
			table.insert(arg_302_0.battle_info.back_point_stack, var_302_10)
		end
	end
	
	if var_302_6 then
	end
	
	if false then
	end
	
	var_302_7 = arg_302_2.road_dir or var_302_7
	var_302_1 = arg_302_2.road_sector_id or var_302_1
	
	local var_302_12 = var_302_7 == "up" or var_302_7 == "left"
	
	var_302_0.road_id = arg_302_1
	var_302_0.road_type = var_302_4.road_type
	var_302_0.is_cross = var_302_4.is_cross
	var_302_0.is_single_sector = var_302_4.is_single_sector
	var_302_0.is_sideroad = var_302_6
	var_302_0.road_reverse = var_302_12
	var_302_0.battle_count = var_302_5
	var_302_0.road_dir = var_302_7
	var_302_0.current_sector_id = var_302_1
	var_302_0.prev_road_id = var_302_2
	
	if not var_302_3 and not arg_302_2.retry_play then
		arg_302_0:processMorale(var_302_4, arg_302_2.is_portal)
	end
	
	arg_302_0.battle_info.road_info = var_302_0
	arg_302_0.battle_info.prepared_road_event_tbl = {}
	
	arg_302_0:updateUnitPeakStat()
	arg_302_0:onInfos({
		type = "@enter_road",
		is_enter_start = var_302_3,
		road_id = arg_302_1,
		road_sector_id = var_302_1
	})
end

function var_0_3.onEnterRoadSector(arg_303_0, arg_303_1)
	local var_303_0 = arg_303_0:getRoadSectorObject(arg_303_1)
	
	if not var_303_0 then
		Log.e("logic", "road_sector_object is nil ", arg_303_1)
		
		return 
	end
	
	arg_303_0.battle_info.entered_road_sector_tbl[arg_303_1] = true
	
	local var_303_1 = arg_303_0.battle_info.road_info.current_sector_id
	
	arg_303_0.battle_info.road_info.current_sector_id = arg_303_1
	
	if var_303_1 and arg_303_0.battle_info.proc_info.pre_road_sector_id ~= var_303_1 then
		arg_303_0.battle_info.proc_info.pre_road_sector_id = var_303_1
		arg_303_0.battle_info.proc_info.pre_road_id = arg_303_0.battle_info.road_info.road_id
		arg_303_0.battle_info.proc_info.pre_road_dir = arg_303_0.battle_info.road_info.road_dir
	end
	
	local var_303_2 = var_303_0.sector_no
	local var_303_3 = arg_303_0:getRoadObject(var_303_0.road_id)
	
	for iter_303_0 = var_303_2 - ROAD_INSIGHT_RANGE, var_303_2 + ROAD_INSIGHT_RANGE do
		local var_303_4 = var_303_3.sector_object_list[iter_303_0]
		
		if var_303_4 then
			arg_303_0:doInSightRoadSector(var_303_4.sector_id)
			
			for iter_303_1, iter_303_2 in pairs(var_303_4.event_list) do
				arg_303_0:doPrepareRoadEvent(iter_303_2.event_id)
			end
		end
	end
	
	arg_303_0:onInfos({
		type = "@enter_road_sector",
		road_sector_id = arg_303_1
	})
end

function var_0_3.onReturnRoad(arg_304_0)
	if #arg_304_0.battle_info.back_point_stack == 0 then
		error("empty backpoint")
		
		return 
	end
	
	local var_304_0 = table.remove(arg_304_0.battle_info.back_point_stack)
	
	if arg_304_0.battle_info.road_info.road_id ~= var_304_0.road_id then
		error("invalid backpoint  ,  self.battle_info.road_info.road_id ~= back_point.road_id ")
		
		return 
	end
	
	local var_304_1 = var_304_0.return_road_info
	
	arg_304_0.battle_info.road_info = var_304_1
	arg_304_0.battle_info.prepared_road_event_tbl = {}
	
	arg_304_0:onInfos({
		type = "@enter_road",
		road_id = var_304_1.road_id,
		road_sector_id = var_304_1.current_sector_id
	})
	arg_304_0:onEnterRoadSector(var_304_1.current_sector_id)
end

function var_0_3.onRetryPlay(arg_305_0)
	arg_305_0:stopBattleFSM()
	
	arg_305_0.road_event_run_info.state_name = "finish"
	arg_305_0.road_event_run_info.pending_list = {}
	arg_305_0.last_stage_result = nil
	
	arg_305_0:clearEnemies()
	
	local var_305_0 = {}
	
	for iter_305_0, iter_305_1 in pairs(arg_305_0.friends) do
		local var_305_1 = iter_305_1.inst.bp
		local var_305_2 = iter_305_1.inst.cp
		
		iter_305_1:reset()
		iter_305_1:resetVariablePassiveDirty()
		
		if GrowthBoost and GrowthBoost.apply then
			GrowthBoost:apply(iter_305_1, arg_305_0.init_data.grooth_boost_info)
		end
		
		if arg_305_0:isNeedToStartWithFullHP() then
			iter_305_1.inst.hp = iter_305_1:getRawMaxHP()
			
			if iter_305_1:getSPName() == "mp" then
				iter_305_1.inst.mp = GAME_STATIC_VARIABLE.mana_max
			end
		end
		
		table.add(var_305_0, iter_305_1.states:onEnterMap())
		table.add(var_305_0, iter_305_1.states:onToggle(nil, true))
		iter_305_1:onToggleVariablePassive()
	end
	
	arg_305_0:onInfos(table.unpack(var_305_0))
	
	local var_305_3 = arg_305_0.battle_info.road_info.current_sector_id
	local var_305_4 = arg_305_0:getRoadSectorObject(var_305_3)
	local var_305_5 = arg_305_0:getRoadObject(var_305_4.road_id)
	local var_305_6
	
	if arg_305_0.battle_info.road_info.road_reverse then
		var_305_6 = var_305_5.sector_object_list[var_305_4.sector_no + 1]
	else
		var_305_6 = var_305_5.sector_object_list[var_305_4.sector_no - 1]
	end
	
	if var_305_6 then
		arg_305_0.battle_info.prepared_road_event_tbl = {}
		
		arg_305_0:onInfos({
			type = "@enter_road",
			road_id = var_305_6.road_id,
			road_sector_id = var_305_6.sector_id
		})
		arg_305_0:onEnterRoadSector(var_305_6.sector_id)
		
		return 
	end
	
	local var_305_7 = to_reverse_dir(arg_305_0.battle_info.road_info.road_dir)
	local var_305_8 = var_305_5.dirs[var_305_7]
	
	if not var_305_8 then
		return 
	end
	
	local var_305_9
	
	if arg_305_0.battle_info.road_info.is_cross then
		var_305_9 = arg_305_0:getRoadObject(var_305_8.road_id) or arg_305_0:getRoadObject(var_305_8.goal_id)
	else
		var_305_9 = arg_305_0:getRoadObject(var_305_8.goal_id)
	end
	
	local var_305_10 = #var_305_9.sector_object_list
	local var_305_11 = {
		var_305_9.sector_object_list[1],
		var_305_9.sector_object_list[var_305_10]
	}
	local var_305_12 = arg_305_0:getSideRoadDir(var_305_9.road_id)
	
	if table.count(var_305_9.dirs) > 1 then
		var_305_12 = to_reverse_dir(var_305_12)
	end
	
	local var_305_13
	
	if is_reverse_dir(var_305_12) then
		var_305_13 = var_305_11[1].sector_id
	else
		var_305_13 = var_305_11[2].sector_id
	end
	
	arg_305_0:onEnterRoad(var_305_9.road_id, {
		retry_play = true,
		road_dir = var_305_12,
		road_sector_id = var_305_13
	})
	arg_305_0:onEnterRoadSector(var_305_13)
end

function var_0_3.onDestroyRoadEvent(arg_306_0, arg_306_1)
	if arg_306_0:getRoadEventObject(arg_306_1) then
		arg_306_0.battle_info.destoryed_road_event_tbl[arg_306_1] = true
		
		arg_306_0:onInfos({
			type = "@destroyed_road_event",
			road_event_id = arg_306_1
		})
	end
end

function var_0_3.getCurrentRoadInfo(arg_307_0)
	return arg_307_0.battle_info.road_info
end

function var_0_3.getCurrentRoadType(arg_308_0)
	return arg_308_0.battle_info.road_info.road_type
end

function var_0_3.getQuestMissionId(arg_309_0)
	return arg_309_0.battle_info.quest_m_id
end

function var_0_3.isRoadEventRunning(arg_310_0)
	local var_310_0 = arg_310_0:getRunningRoadEventObject()
	local var_310_1 = false
	local var_310_2 = false
	
	if var_310_0 then
		var_310_1 = var_310_0:isBattleType()
		var_310_2 = arg_310_0:isCompletedRoadEvent(var_310_0.event_id)
	end
	
	return not table.empty(arg_310_0.road_event_run_info.pending_list) or var_310_1 and not var_310_2
end

function var_0_3.getRunningRoadEventObject(arg_311_0)
	return arg_311_0:getRoadEventObject(arg_311_0.road_event_run_info.road_event_id)
end

function var_0_3.getCurrentRoadEventObjectList(arg_312_0)
	return arg_312_0.stageMap:getRoadEventObjectList(arg_312_0.battle_info.road_info.road_id)
end

function var_0_3.getCurrentRoadSectorObjectList(arg_313_0)
	return arg_313_0.stageMap:getRoadSectorObjectList(arg_313_0.battle_info.road_info.road_id)
end

function var_0_3.getCompletedRoadEvent(arg_314_0)
	return arg_314_0.battle_info.completed_road_event_tbl
end

function var_0_3.isCompletedRoadEvent(arg_315_0, arg_315_1)
	if arg_315_0.stageMap.contents_type == "raid" or arg_315_0.stageMap.contents_type == "automaton" then
		local var_315_0 = arg_315_1
		
		if var_315_0 and string.find(var_315_0, "#") then
			local var_315_1 = string.replace(var_315_0, "#", "_")
			
			return arg_315_0.battle_info.completed_road_event_tbl[arg_315_1] or arg_315_0.battle_info.completed_road_event_tbl[var_315_1]
		end
	end
	
	return arg_315_0.battle_info.completed_road_event_tbl[arg_315_1]
end

function var_0_3.isFirstCompletedRoadEvent(arg_316_0, arg_316_1)
	if arg_316_0.battle_info.completed_road_event_tbl[arg_316_1] then
		if arg_316_0.battle_info.already_completed_road_event_tbl[arg_316_1] then
			return false
		end
		
		return true
	end
	
	return false
end

function var_0_3.getRoadMazeData(arg_317_0, arg_317_1)
	return arg_317_0.stageMap:getRoadMazeData(arg_317_1)
end

function var_0_3.getInSightRoadSectorTbl(arg_318_0)
	return arg_318_0.battle_info.insight_road_sector_tbl
end

function var_0_3.isInSightRoadSector(arg_319_0, arg_319_1)
	return arg_319_0.battle_info.insight_road_sector_tbl[arg_319_1]
end

function var_0_3.getRoadSectorEventObjectList(arg_320_0, arg_320_1)
	local var_320_0 = arg_320_0:getRoadSectorObject(arg_320_1)
	local var_320_1 = {}
	
	for iter_320_0, iter_320_1 in pairs(var_320_0.event_list) do
		table.insert(var_320_1, iter_320_1)
		
		if not arg_320_0:isCompletedRoadEvent(iter_320_1.event_id) then
			break
		end
	end
	
	return var_320_1
end

function var_0_3.getRoadSectorProgress(arg_321_0)
	local var_321_0 = arg_321_0:getEnteredRoadSectorCount()
	local var_321_1 = arg_321_0:getTotalRoadSectorCount()
	
	return (math.floor(math.min(1, var_321_0 / var_321_1) * 100))
end

function var_0_3.getCurrentRoadSectorId(arg_322_0)
	return arg_322_0.battle_info.road_info.current_sector_id
end

function var_0_3.getEnteredRoadSectorCount(arg_323_0)
	return table.count(arg_323_0.battle_info.entered_road_sector_tbl)
end

function var_0_3.getEnteredRoadSectorTbl(arg_324_0)
	return arg_324_0.battle_info.entered_road_sector_tbl
end

function var_0_3.getTotalRoadSectorCount(arg_325_0)
	return arg_325_0.stageMap.total_road_sector_count
end

function var_0_3.getRoadEventCountingValue(arg_326_0, arg_326_1)
	return arg_326_0.battle_info.count_road_event_tbl[arg_326_1] or 0
end

function var_0_3.isEnteredRoadSector(arg_327_0, arg_327_1)
	return arg_327_0.battle_info.entered_road_sector_tbl[arg_327_1]
end

function var_0_3.isDestroyedRoadEvent(arg_328_0, arg_328_1)
	return arg_328_0.battle_info.destoryed_road_event_tbl[arg_328_1]
end

function var_0_3.getRoadObject(arg_329_0, arg_329_1)
	return arg_329_0.stageMap:getRoadObject(arg_329_1)
end

function var_0_3.getRoadObjectList(arg_330_0)
	return arg_330_0.stageMap:getRoadObjectList()
end

function var_0_3.getCrossRoadList(arg_331_0)
	return arg_331_0.stageMap:getCrossRoadList()
end

function var_0_3.getRoadSectorObject(arg_332_0, arg_332_1)
	return arg_332_0.stageMap:getRoadSectorObject(arg_332_1)
end

function var_0_3.getRoadEventObject(arg_333_0, arg_333_1)
	local var_333_0 = arg_333_0.stageMap:getRoadEventObject(arg_333_1)
	
	if var_333_0 then
		local var_333_1, var_333_2 = arg_333_0:isExpiredGroupEvent(var_333_0.sector_id)
		
		if var_333_1 then
			local var_333_3 = var_333_2.group_name or "default"
			
			return arg_333_0.stageMap:getRoadEventObject(arg_333_1, var_333_3)
		end
	end
	
	return var_333_0
end

function var_0_3.getRoadEventObjectList(arg_334_0, arg_334_1)
	return arg_334_0.stageMap:getRoadEventObjectList(arg_334_1)
end

function var_0_3.getRoadSectorObjectList(arg_335_0, arg_335_1)
	return arg_335_0.stageMap:getRoadSectorObjectList(arg_335_1)
end

function var_0_3.getUsingPotionLimit(arg_336_0)
	if arg_336_0.stageMap.main_type == "adv" then
		return GAME_STATIC_VARIABLE.adv_mode_potion_count_max
	end
	
	return GAME_STATIC_VARIABLE.nor_mode_potion_count_max
end

function var_0_3.getUsingPotionCount(arg_337_0, arg_337_1)
	arg_337_1 = arg_337_1 or "default_potion"
	
	return arg_337_0.battle_info.using_potion[arg_337_1] or 0
end

local function var_0_13(arg_338_0, arg_338_1)
	arg_338_1 = arg_338_1 or 0
	
	local var_338_0 = 1
	
	for iter_338_0, iter_338_1 in pairs(arg_338_0) do
		if type(iter_338_1) == "table" then
			error("error is table ")
		end
	end
	
	return var_338_0
end

if not DEBUG then
	DEBUG = {}
end

DEBUG.BATTLE_LOGIC_COMMAND = false
DEBUG.BATTLE_DISABLE_REPLAY_DATA = false

function var_0_3.getVerifyInfo(arg_339_0)
	local var_339_0 = {
		hp_infos = {},
		state_infos = {}
	}
	
	for iter_339_0, iter_339_1 in pairs(arg_339_0.units) do
		var_339_0.hp_infos[tostring(iter_339_1:getUID())] = {
			hp = iter_339_1:getHP()
		}
		var_339_0.state_infos[tostring(iter_339_1:getUID())] = {}
		
		for iter_339_2, iter_339_3 in pairs(iter_339_1.states.List or {}) do
			table.insert(var_339_0.state_infos[tostring(iter_339_1:getUID())], {
				id = iter_339_3.id
			})
		end
	end
	
	return var_339_0
end

function var_0_3.addReplayData(arg_340_0, arg_340_1, arg_340_2)
	if not arg_340_2 then
		return 
	end
	
	if not ENABLE_REPLAY_DATA then
		return 
	end
	
	if DEBUG.BATTLE_DISABLE_REPLAY_DATA then
		return 
	end
	
	if arg_340_0:isViewerMode() then
		return 
	end
	
	if arg_340_0.mode == "net_friend" then
		return 
	end
	
	local var_340_0 = {
		command = function(arg_341_0)
			if not arg_341_0 then
				return false
			elseif arg_341_0 == "HitEvent" then
				return false
			elseif arg_341_0 == "PetRecognizeRoadEvent" then
				return false
			end
			
			return true
		end
	}
	
	local function var_340_1(arg_342_0, arg_342_1)
		local var_342_0 = table.clone(arg_342_1)
		
		var_342_0.cmd_uid = arg_342_0.battle_info.proc_info.counter
		
		for iter_342_0, iter_342_1 in pairs(var_342_0) do
			if string.sub(iter_342_0, 1, 1) == "*" then
				var_342_0[iter_342_0] = nil
			end
		end
		
		if PRODUCTION_MODE then
			return {
				var_342_0,
				arg_340_0.random.X1,
				arg_340_0.random.X2
			}
		else
			return {
				var_342_0,
				arg_340_0.random.X1,
				arg_340_0.random.X2,
				arg_340_0:getVerifyInfo()
			}
		end
	end
	
	if arg_340_1 == "command" then
		if not var_340_0[arg_340_1](arg_340_2.cmd) then
			return 
		end
		
		local var_340_2 = var_340_1(arg_340_0, arg_340_2)
		
		if var_340_2 then
			table.insert(arg_340_0.battle_info.replay_data, var_340_2)
		end
	end
end

function var_0_3.command(arg_343_0, arg_343_1)
	if DEBUG.BATTLE_LOGIC_COMMAND then
		table.print(arg_343_1)
	end
	
	arg_343_0:addReplayData("command", arg_343_1)
	
	if arg_343_1.cmd == "FireRoadEvent" then
		arg_343_0:onFireRoadEvent(arg_343_1.road_event_id, arg_343_1.is_pet_fired)
	elseif arg_343_1.cmd == "UsePotion" then
		arg_343_0:onUsePotion()
	elseif arg_343_1.cmd == "CampingTopic" then
		arg_343_0:onCampingTopic(arg_343_1.unit_uid, arg_343_1.topic_idx)
	elseif arg_343_1.cmd == "HitEvent" then
		arg_343_0:onHitEvent(arg_343_1.unit_uid, arg_343_1, arg_343_1["*tag"])
	elseif arg_343_1.cmd == "SummonSkill" then
		arg_343_0:onSummonSkill()
	elseif arg_343_1.cmd == "StartSkill" then
		arg_343_0:onStartSkill(arg_343_1.attacker_uid, arg_343_1.skill_id, arg_343_1.target_uid, arg_343_1.skill_idx, arg_343_1.is_soul)
	elseif arg_343_1.cmd == "SwapTagSupporter" then
		arg_343_0:onSwapTagSupporter()
	elseif arg_343_1.cmd == "MissionStates" then
		arg_343_0:onMissionStates(arg_343_1.mission_states)
	elseif arg_343_1.cmd == "EnterRoad" then
		arg_343_0:onEnterRoad(arg_343_1.road_id, arg_343_1)
	elseif arg_343_1.cmd == "ReturnRoad" then
		arg_343_0:onReturnRoad()
	elseif arg_343_1.cmd == "RetryPlay" then
		arg_343_0:onRetryPlay()
	elseif arg_343_1.cmd == "DestroyRoadEvent" then
		arg_343_0:onDestroyRoadEvent(arg_343_1.road_event_id)
	elseif arg_343_1.cmd == "EnterRoadSector" then
		arg_343_0:onEnterRoadSector(arg_343_1.road_sector_id)
	elseif arg_343_1.cmd == "ExecuteRoadEvent" then
		arg_343_0:onExecuteRoadEvent()
	elseif arg_343_1.cmd == "TestRunRoadEvent" then
		arg_343_0:onTestRunRoadEvent(arg_343_1.road_event_id)
	elseif arg_343_1.cmd == "MazeClear" then
		arg_343_0:onMazeClear(arg_343_1.road_id)
	elseif arg_343_1.cmd == "PetRecognizeRoadEvent" then
		arg_343_0:onPetRecognizeRoadEvent()
	elseif arg_343_1.cmd == "Snapshot" then
		arg_343_0:onSnapData(arg_343_1.snap_data, arg_343_1.opts)
	end
	
	arg_343_0:sortUnitStates("command")
end

function var_0_3.getProcCounter(arg_344_0)
	return arg_344_0.battle_info.proc_info.counter
end

function var_0_3.getInvokeStackCount(arg_345_0, arg_345_1)
	return arg_345_0.battle_info.state_invoke_info[arg_345_1] or 0
end

function var_0_3.setInvokeStackCount(arg_346_0, arg_346_1, arg_346_2)
	local var_346_0 = arg_346_2 or 1
	
	arg_346_0.battle_info.state_invoke_info[arg_346_1] = (arg_346_0.battle_info.state_invoke_info[arg_346_1] or 0) + var_346_0
end

function var_0_3.onUsePotion(arg_347_0, arg_347_1)
	arg_347_1 = arg_347_1 or "default_potion"
	
	local var_347_0 = arg_347_0.battle_info.using_potion[arg_347_1] or 0
	
	if var_347_0 < arg_347_0:getUsingPotionLimit() then
		arg_347_0:healFriends(GAME_STATIC_VARIABLE.potion_party_heal / 100)
		
		arg_347_0.battle_info.using_potion[arg_347_1] = var_347_0 + 1
		
		arg_347_0:onInfos({
			type = "@use_potion",
			potion_id = arg_347_1
		})
	end
end

function var_0_3.onCampingTopic(arg_348_0, arg_348_1, arg_348_2)
	if LIMIT_CAMPING_TOPIC <= arg_348_0:getCampingTopicCount() then
		arg_348_0:onInfos({
			type = "@camping_topic"
		})
		
		return 
	end
	
	local var_348_0 = assert(arg_348_0:getUnit(arg_348_1))
	local var_348_1 = var_348_0.db["topic_" .. arg_348_2]
	local var_348_2 = 0
	local var_348_3 = 0
	local var_348_4 = 0
	local var_348_5 = {}
	local var_348_6 = {}
	
	for iter_348_0, iter_348_1 in pairs(arg_348_0.starting_friends) do
		if iter_348_1 ~= var_348_0 and iter_348_1 and not iter_348_1:isDead() then
			local var_348_7 = 0
			
			for iter_348_2 = 1, 2 do
				local var_348_8 = iter_348_1.db["personality_" .. iter_348_2]
				
				if var_348_8 then
					local var_348_9 = DB("camp_utterance", var_348_1, var_348_8) or 0
					
					if var_348_9 < 0 then
						var_348_9 = 0
					end
					
					var_348_7 = var_348_7 + var_348_9
				end
			end
			
			if var_348_7 ~= 0 then
				table.insert(var_348_5, {
					unit_code = iter_348_1.db.code,
					skin_code = iter_348_1.inst.skin_code,
					unit_pos = iter_348_1.inst.pos,
					point = var_348_7
				})
				
				var_348_6[iter_348_1:getUID()] = var_348_7
			end
			
			var_348_2 = math.min(var_348_2, var_348_7)
			var_348_3 = math.max(var_348_3, var_348_7)
			var_348_4 = var_348_4 + math.max(0, var_348_7)
		end
	end
	
	local var_348_10 = arg_348_0:getTeamRes(FRIEND, "morale")
	
	arg_348_0:setMorale(var_348_10 + var_348_4)
	
	local var_348_11 = arg_348_0:getTeamRes(FRIEND, "morale")
	local var_348_12 = var_348_11 - var_348_10
	local var_348_13 = {
		before_morale = var_348_10,
		after_morale = var_348_11,
		changed_morale = var_348_12
	}
	local var_348_14 = {
		talker = var_348_0:getUID(),
		topic = var_348_1,
		fav_info = var_348_6,
		morale_info = var_348_13
	}
	
	table.insert(arg_348_0.battle_info.camping_data, var_348_14)
	arg_348_0:updateMoralePassive()
	
	local var_348_15 = {
		unit_list = var_348_5,
		topic_count = #arg_348_0.battle_info.camping_data,
		morale_info = var_348_13,
		max_point = var_348_3,
		min_point = var_348_2
	}
	
	arg_348_0:onInfos({
		type = "@camping_topic",
		result_info = var_348_15
	})
	arg_348_0:onInfos({
		type = "dec_morale"
	})
end

function var_0_3.onTestRunRoadEvent(arg_349_0, arg_349_1)
	arg_349_0:onEnterRoad()
	arg_349_0:doEncounterRoadEvent(arg_349_1)
end

function var_0_3.onMazeClear(arg_350_0, arg_350_1)
	local var_350_0 = arg_350_0:getCurrentRoadInfo()
	
	if var_350_0 and var_350_0.road_id == arg_350_1 then
		local var_350_1 = arg_350_0:getOption("clear", {
			info = arg_350_1
		})
		
		if not table.empty(var_350_1) then
			arg_350_0.last_stage_result = "win"
			
			if arg_350_0.type == "dungeon_quest" and arg_350_0:isNeedToUpdateHP() then
				arg_350_0:procAutoHeal()
			end
			
			arg_350_0.force_finish_target = "maze"
		end
	end
end

function var_0_3.onExecuteRoadEvent(arg_351_0)
	local var_351_0 = arg_351_0.battle_info.road_info.current_sector_id
	local var_351_1 = arg_351_0:getRoadSectorObject(var_351_0)
	
	if not var_351_1 then
		return 
	end
	
	for iter_351_0, iter_351_1 in pairs(var_351_1.event_list) do
		arg_351_0:doEncounterRoadEvent(iter_351_1.event_id)
	end
	
	local var_351_2
	
	if not table.empty(arg_351_0.road_event_run_info.pending_list) then
		var_351_2 = arg_351_0:executeRoadEvent()
	end
	
	local var_351_3 = arg_351_0.battle_info.road_info.execute_sector_id
	
	if (not var_351_2 or not var_351_2:isBattleType()) and var_351_0 ~= var_351_3 and not arg_351_0.battle_info.road_info.is_cross then
		arg_351_0:decMorale(arg_351_0:getMoraleValue("move"))
		
		arg_351_0.battle_info.road_info.execute_sector_id = var_351_0
	end
end

function var_0_3.onPetRecognizeRoadEvent(arg_352_0)
	local var_352_0 = arg_352_0.battle_info.road_info.current_sector_id
	local var_352_1 = arg_352_0:getRoadSectorObject(var_352_0)
	
	if not var_352_1 then
		return 
	end
	
	if arg_352_0:isSequenceType(var_352_1.road_id) and arg_352_0:isExistBattle(var_352_1.road_id) then
		return 
	end
	
	for iter_352_0, iter_352_1 in pairs(var_352_1.event_list) do
		if iter_352_1:isObjectType() and not arg_352_0:isCompletedRoadEvent(iter_352_1.event_id) and PetUtil:isRecognizable(arg_352_0.pet, iter_352_1.type) then
			local var_352_2 = iter_352_1.event_id
			
			arg_352_0:onInfos({
				type = "@pet_fire",
				road_event_id = var_352_2
			})
			arg_352_0:onFireRoadEvent(var_352_2, true)
		end
	end
end

function var_0_3.onSnapData(arg_353_0, arg_353_1, arg_353_2)
	if not arg_353_1 and arg_353_0.snap then
		return 
	end
	
	arg_353_2 = arg_353_2 or {}
	
	arg_353_0.snap:onSnapData(arg_353_1, arg_353_2)
end

function var_0_3.doInSightRoadSector(arg_354_0, arg_354_1)
	if arg_354_0.battle_info.insight_road_sector_tbl[arg_354_1] then
		return 
	end
	
	arg_354_0.battle_info.insight_road_sector_tbl[arg_354_1] = true
	
	arg_354_0:onInfos({
		type = "@insight_road_sector",
		road_sector_id = arg_354_1
	})
end

function var_0_3.doPrepareRoadEvent(arg_355_0, arg_355_1)
	if arg_355_0.battle_info.prepared_road_event_tbl[arg_355_1] then
		return 
	end
	
	arg_355_0.battle_info.prepared_road_event_tbl[arg_355_1] = true
	
	local var_355_0 = arg_355_0:getRoadEventObject(arg_355_1)
	
	if not var_355_0 then
		return 
	end
	
	local var_355_1 = var_355_0.type
	local var_355_2
	
	if var_355_1 == "npc" then
		local var_355_3 = assert(var_355_0.value.npc)
		local var_355_4
		local var_355_5
		
		for iter_355_0 = 1, 20 do
			var_355_4 = string.format("%s_%d", var_355_3, iter_355_0)
			
			if var_355_0.group_expired then
				break
			end
			
			local var_355_6 = DB("level_npc", var_355_4, "mission_id")
			local var_355_7 = arg_355_0:getMissionState(var_355_6)
			
			if not var_355_6 or var_355_7 == "clear" or var_355_7 == "received" then
				break
			end
		end
		
		arg_355_0.battle_info.npc_road_event_tbl[arg_355_1] = var_355_4
	end
	
	arg_355_0:onInfos({
		type = "@prepare_road_event",
		road_event_id = arg_355_1
	})
end

function var_0_3.doEncounterRoadEvent(arg_356_0, arg_356_1)
	local var_356_0 = arg_356_0:getRoadEventObject(arg_356_1)
	
	if not var_356_0 then
		return 
	end
	
	local var_356_1 = var_356_0.type
	
	if not arg_356_0:isCompletedRoadEvent(arg_356_1) and not table.find(arg_356_0.road_event_run_info.pending_list, arg_356_1) then
		table.insert(arg_356_0.road_event_run_info.pending_list, arg_356_1)
	end
end

function var_0_3.incEncounterEnemyCount(arg_357_0)
	if not arg_357_0.encounter_enemy_count then
		return 
	end
	
	arg_357_0.encounter_enemy_count = arg_357_0.encounter_enemy_count + 1
end

function var_0_3.onEncounterEnemy(arg_358_0, arg_358_1)
	if arg_358_0:isCompletedRoadEvent(arg_358_1) then
		return 
	end
	
	Log.d("LOGIC", "== EncounterEnemy == ", arg_358_1)
	
	arg_358_0.turn_info = {
		turn_num = 1,
		state = "next",
		next_queue = {}
	}
	arg_358_0.stage_counter = 0
	arg_358_0.team_stage_counter = {
		[FRIEND] = 0,
		[ENEMY] = 0
	}
	arg_358_0.round_tick = 0
	arg_358_0.enemies = arg_358_0:makeEventEnemy(arg_358_1)
	arg_358_0.latest_enemies = {}
	
	for iter_358_0, iter_358_1 in pairs(arg_358_0.enemies) do
		arg_358_0.result_stat:initContribution(iter_358_1)
	end
	
	if arg_358_0:isExpeditionType() then
		arg_358_0:updateExpeditionInfo(arg_358_0:getExpeditionInfo(), true)
	end
	
	for iter_358_2, iter_358_3 in pairs(arg_358_0.enemies) do
		iter_358_3:calc()
		arg_358_0:addAllocatedUnit(iter_358_3)
		
		if not iter_358_3:isSummon() and not iter_358_3:isSupporter() then
			table.insert(arg_358_0.latest_enemies, iter_358_3)
		end
	end
	
	arg_358_0:genUnits()
	arg_358_0:applyPassive(arg_358_0)
	arg_358_0:addRTA_passive(arg_358_0.enemies, arg_358_0.rta_passive_info[ENEMY])
	
	for iter_358_4, iter_358_5 in pairs(arg_358_0.units) do
		iter_358_5:onSetupStage(arg_358_0)
		iter_358_5:resetInvokeStackCountWave()
	end
	
	arg_358_0:procPenaltyInfo()
	
	if arg_358_0:isRealtimeMode() then
		arg_358_0:updateRtaPenalty()
	end
	
	local var_358_0 = {}
	
	for iter_358_6, iter_358_7 in pairs(arg_358_0.enemies) do
		if arg_358_0:isViewPlayerActive() then
			iter_358_7:applyGrowthBoost()
			iter_358_7:calc()
		end
		
		table.add(var_358_0, iter_358_7.states:onEnterMap())
	end
	
	arg_358_0:onInfos(table.unpack(var_358_0))
	arg_358_0:onInfos({
		type = "@encounter_enemy",
		road_event_id = arg_358_1,
		burning_phase_count = arg_358_0.burning_phase_count
	})
	
	arg_358_0.road_event_run_info.state_name = "running"
	
	arg_358_0:sortUnitStates("encounter")
	
	local var_358_1, var_358_2 = arg_358_0:checkBurningPhaseEnter(arg_358_1)
	
	if var_358_1 then
		arg_358_0:onBurning("enter", var_358_2)
	end
	
	arg_358_0:onInfos({
		turn_owner = -1,
		turn_count = 0,
		type = "HANDLE"
	})
	arg_358_0:incEncounterEnemyCount()
	LuaEventDispatcher:dispatchEvent("begginner_log", arg_358_0.map.enter .. "/" .. arg_358_0.encounter_enemy_count .. "/" .. arg_358_0.road_event_run_info.road_event_id, 0)
end

function var_0_3.onFireRoadEvent(arg_359_0, arg_359_1, arg_359_2)
	local var_359_0 = arg_359_0:getRoadEventObject(arg_359_1)
	
	if not var_359_0 then
		return 
	end
	
	if arg_359_0:checkLevelFlag(var_359_0) then
		return 
	end
	
	arg_359_0:onInfos({
		type = "@fire_road_event",
		road_event_id = arg_359_1,
		is_pet_fired = arg_359_2
	})
	
	if var_359_0:isObjectType() then
		arg_359_0:procObject(arg_359_1)
	end
	
	arg_359_0.battle_info.count_road_event_tbl[arg_359_1] = (arg_359_0.battle_info.count_road_event_tbl[arg_359_1] or 0) + 1
	
	arg_359_0:postLevelFlag(var_359_0)
	
	if var_359_0.is_last and arg_359_0:isCompletedRoadEvent(arg_359_1) then
	end
end

function var_0_3.checkLevelFlag(arg_360_0, arg_360_1)
	local var_360_0 = arg_360_1.flag_info
	
	if var_360_0 then
		for iter_360_0 = 1, 3 do
			local var_360_1 = var_360_0["flag_lock_" .. iter_360_0]
			
			if var_360_1 and not arg_360_0:isExistFlag(var_360_1) then
				arg_360_0:onInfos({
					type = "@require_level_flag",
					road_event_id = arg_360_1.event_id,
					flag = var_360_1
				})
				
				return true
			end
		end
	end
end

function var_0_3._postLevelFlag(arg_361_0, arg_361_1)
	local var_361_0
	local var_361_1
	local var_361_2
	
	if arg_361_1:isBattleType() then
		var_361_2 = arg_361_1.flag_info
	else
		var_361_2 = arg_361_1.value
	end
	
	if var_361_2 then
		var_361_0 = var_361_2.flag_on
		var_361_1 = var_361_2.msg_flag_on
	end
	
	if not var_361_0 then
		local var_361_3 = arg_361_0.battle_info.npc_road_event_tbl[arg_361_1.event_id]
		
		if var_361_3 then
			var_361_0, var_361_1 = DB("level_npc", var_361_3, {
				"flag_on",
				"msg_flag_on"
			})
		end
	end
	
	if not var_361_0 then
		return 
	end
	
	local var_361_4 = tostring(var_361_0)
	
	arg_361_0.battle_info.level_flags[var_361_4] = true
	
	arg_361_0:onInfos({
		type = "@set_level_flag",
		road_event_id = arg_361_1.event_id,
		flag_on = var_361_4,
		msg_flag_on = var_361_1
	})
end

function var_0_3.postLevelFlag(arg_362_0, arg_362_1)
	arg_362_0:_postLevelFlag(arg_362_1)
	arg_362_0:checkLevelFlagCondition()
end

function var_0_3.checkLevelFlagCondition(arg_363_0, arg_363_1)
	if not arg_363_0:isDungeonType() then
		return 
	end
	
	local var_363_0 = arg_363_0:getOption("flag_cond")
	
	for iter_363_0, iter_363_1 in pairs(var_363_0 or {}) do
		if not arg_363_0:isExistFlag(iter_363_1.flag_on) and iter_363_1.type == "plural_battle" then
			local var_363_1 = {}
			
			for iter_363_2, iter_363_3 in pairs(iter_363_1.list or {}) do
				for iter_363_4, iter_363_5 in pairs(arg_363_0.battle_info.completed_road_event_tbl) do
					if iter_363_5 and string.starts(iter_363_4, iter_363_3) then
						var_363_1[iter_363_3] = true
					end
				end
			end
			
			if table.count(var_363_1) >= to_n(iter_363_1.clear) then
				arg_363_0.battle_info.level_flags[iter_363_1.flag_on] = true
				
				local var_363_2
				
				if not arg_363_1 then
					var_363_2 = iter_363_1.msg_flag_on
				end
				
				arg_363_0:onInfos({
					type = "@set_level_flag",
					flag_on = iter_363_1.flag_on,
					msg_flag_on = var_363_2
				})
			end
		end
	end
end

function var_0_3.isExpiredGroupEvent(arg_364_0, arg_364_1)
	local var_364_0 = arg_364_0:getOption("group")
	
	local function var_364_1(arg_365_0)
		if not table.isInclude(arg_365_0.info_group, arg_364_1) then
			return 
		end
		
		local var_365_0 = false
		local var_365_1 = arg_364_0:getRoadSectorObject(arg_364_1)
		
		if var_365_1 then
			for iter_365_0, iter_365_1 in pairs(var_365_1.event_list) do
				if iter_365_1:isBattleType() and not arg_364_0:isCompletedRoadEvent(iter_365_1.event_id) then
					var_365_0 = true
				end
			end
		end
		
		if var_365_0 then
			local var_365_2 = false
			local var_365_3 = false
			
			for iter_365_2, iter_365_3 in pairs(arg_365_0.info_group) do
				if iter_365_3 == arg_364_1 then
					var_365_2 = true
				end
				
				if arg_364_0.battle_info.group_flags[iter_365_3] then
					var_365_3 = true
				end
			end
			
			return var_365_2 and var_365_3
		end
		
		return false
	end
	
	if var_364_0 then
		if type(var_364_0.info_group) == "table" then
			return var_364_1(var_364_0), var_364_0
		elseif type(var_364_0) == "table" then
			local var_364_2 = false
			local var_364_3
			
			for iter_364_0, iter_364_1 in pairs(var_364_0) do
				if var_364_1(iter_364_1) then
					var_364_2 = true
					var_364_3 = var_364_0
				end
			end
			
			return var_364_2, var_364_3
		end
	end
end

function var_0_3.checkGroupEventFlag(arg_366_0, arg_366_1)
	local var_366_0 = arg_366_0:getOption("group")
	local var_366_1 = arg_366_1.sector_id
	
	local function var_366_2(arg_367_0)
		if not arg_367_0.info_group then
			return 
		end
		
		if table.isInclude(arg_367_0.info_group, var_366_1) then
			arg_366_0.battle_info.group_flags[var_366_1] = true
			
			local var_367_0 = true
			
			for iter_367_0, iter_367_1 in pairs(arg_367_0.info_group) do
				if iter_367_1 ~= var_366_1 then
					local var_367_1 = arg_366_0:getRoadSectorObject(iter_367_1)
					
					for iter_367_2, iter_367_3 in pairs(var_367_1.event_list or {}) do
						if string.starts(iter_367_3.type, "battle") and not arg_366_0:isCompletedRoadEvent(iter_367_3.id) then
							var_367_0 = false
						end
					end
				end
			end
			
			local var_367_2 = var_367_0 and arg_367_0.msg_allclear or arg_367_0.msg_clear
			
			arg_366_0:onInfos({
				type = "@set_group_flag",
				road_sector_id = var_366_1,
				msg = var_367_2
			})
		end
	end
	
	if var_366_0 then
		if type(var_366_0.info_group) == "table" then
			var_366_2(var_366_0)
		elseif type(var_366_0) == "table" then
			for iter_366_0, iter_366_1 in pairs(var_366_0) do
				var_366_2(iter_366_1)
			end
		end
	end
end

function var_0_3.isLockedRoadEvent(arg_368_0, arg_368_1)
	local var_368_0 = assert(arg_368_0:getRoadEventObject(arg_368_1)).flag_info
	
	if type(var_368_0) == "table" then
		for iter_368_0, iter_368_1 in pairs(var_368_0) do
			local var_368_1 = var_368_0["flag_lock_" .. iter_368_0]
			
			if not arg_368_0:isExistFlag(iter_368_1) then
				return true
			end
		end
	end
end

function var_0_3.isExistFlag(arg_369_0, arg_369_1)
	if not arg_369_1 then
		return false
	end
	
	arg_369_1 = tostring(arg_369_1)
	
	return arg_369_0.battle_info.level_flags[arg_369_1]
end

function var_0_3.forecastReward(arg_370_0, arg_370_1)
	local function var_370_0(arg_371_0, arg_371_1)
		arg_371_1 = arg_371_1 or {}
		
		for iter_371_0, iter_371_1 in pairs(arg_371_0 or {}) do
			if type(iter_371_1) == "number" then
				arg_371_1[iter_371_0] = (arg_371_1[iter_371_0] or 0) + arg_371_0[iter_371_0]
			end
			
			if type(iter_371_1) == "table" then
				if not arg_371_1[iter_371_0] then
					arg_371_1[iter_371_0] = {}
				end
				
				for iter_371_2, iter_371_3 in pairs(arg_371_0[iter_371_0]) do
					table.insert(arg_371_1[iter_371_0], iter_371_3)
				end
			end
		end
		
		return arg_371_1
	end
	
	local var_370_1 = {}
	
	for iter_370_0, iter_370_1 in pairs(arg_370_0.stageMap.road_event_object_tbl) do
		if arg_370_1 or arg_370_0:isFirstCompletedRoadEvent(iter_370_0) then
			var_370_0(iter_370_1.reward, var_370_1)
			
			local var_370_2 = iter_370_1.value or {}
			
			for iter_370_2, iter_370_3 in pairs(var_370_2.npc_drop or {}) do
				local var_370_3 = arg_370_0.battle_info.results_road_event_tbl[iter_370_0] or {}
				
				if arg_370_1 or (var_370_3[iter_370_2] or 0) > 0 then
					var_370_0(iter_370_3, var_370_1)
				end
			end
		end
	end
	
	return var_370_1
end

function var_0_3.getOldTypeCompletedRoadEventList(arg_372_0)
	local var_372_0 = {}
	
	for iter_372_0, iter_372_1 in pairs(arg_372_0.battle_info.completed_road_event_tbl) do
		local var_372_1 = arg_372_0:getRoadEventObject(iter_372_0)
		
		if var_372_1 and var_372_1.group_id then
			table.insert(var_372_0, var_372_1.group_id)
		end
	end
	
	return var_372_0
end

function var_0_3.getCompletedRoadEventList(arg_373_0, arg_373_1)
	local var_373_0 = {}
	
	for iter_373_0, iter_373_1 in pairs(arg_373_0.battle_info.completed_road_event_tbl) do
		if iter_373_1 and (not arg_373_1 or arg_373_0:isFirstCompletedRoadEvent(iter_373_0)) then
			table.insert(var_373_0, iter_373_0)
		end
	end
	
	return var_373_0
end

function var_0_3.getRoadEventResults(arg_374_0, arg_374_1)
	return arg_374_0.battle_info.results_road_event_tbl[arg_374_1]
end

function var_0_3.getRoadEventResultsAll(arg_375_0)
	return arg_375_0.battle_info.results_road_event_tbl or {}
end

function var_0_3.isObjectType(arg_376_0, arg_376_1)
	return (string.starts(arg_376_1, "battle") or arg_376_1 == "empty" or arg_376_1 == "start") == false
end

function var_0_3.applyPassive(arg_377_0)
	for iter_377_0, iter_377_1 in pairs(arg_377_0.units) do
		if not iter_377_1:isDead() then
		end
	end
end

function var_0_3.genUnits(arg_378_0)
	arg_378_0.units = table.alignment_clone(arg_378_0.friends)
	
	for iter_378_0, iter_378_1 in pairs(arg_378_0.enemies) do
		table.insert(arg_378_0.units, iter_378_1)
	end
	
	for iter_378_2, iter_378_3 in pairs(arg_378_0.units) do
		iter_378_3.inst.elapsed_ut = 0.05 * MAX_UNIT_TICK * arg_378_0.random:get()
	end
	
	arg_378_0:checkTestSkill()
end

function var_0_3.checkTestSkill(arg_379_0)
	if DEBUG.TEST_SKILL then
		local var_379_0 = arg_379_0.friends
		local var_379_1 = arg_379_0.enemies
		
		if DEBUG.TEST_SKILL == ENEMY then
			var_379_1 = arg_379_0.friends
			var_379_0 = arg_379_0.enemies
		end
		
		for iter_379_0, iter_379_1 in pairs(var_379_0) do
			iter_379_1.inst.elapsed_ut = MAX_UNIT_TICK - (iter_379_0 - 1) * 10
		end
		
		for iter_379_2, iter_379_3 in pairs(var_379_1) do
			iter_379_3.inst.elapsed_ut = 0
		end
	end
end

function var_0_3.makeEventEnemy(arg_380_0, arg_380_1)
	local var_380_0 = assert(arg_380_0:getRoadEventObject(arg_380_1))
	local var_380_1
	local var_380_2 = {
		front = FRONT,
		back = BACK
	}
	local var_380_3
	local var_380_4
	local var_380_5
	
	if var_380_0.mobs then
		var_380_4, var_380_5 = DB("level_enter", arg_380_0.map.enter, {
			"mob_buff",
			"mob_buff_lv"
		})
		
		local var_380_6 = {}
		
		for iter_380_0, iter_380_1 in pairs(var_380_0.mobs) do
			local var_380_7 = {
				code = DEBUG.TEST_ENEMY_CODE or iter_380_1.code,
				lv = iter_380_1.lv,
				exp = iter_380_1.exp,
				grade = iter_380_1.g,
				h = iter_380_1.h,
				id = iter_380_1.id,
				ally = ENEMY,
				line = var_380_2[iter_380_1.line],
				power = iter_380_1.p,
				ability = iter_380_1.ability,
				chp = iter_380_1.chp,
				mhp = iter_380_1.mhp,
				external_passive = iter_380_1.external_passive,
				reward = {
					drop = iter_380_1.drop,
					gold = iter_380_1.gold
				}
			}
			
			var_380_6[iter_380_1.pos] = var_380_7
		end
		
		var_380_3 = Team:makeTeamData(var_380_6)
	elseif var_380_0.team then
		var_380_3 = var_380_0.team
		
		if var_380_3.equips then
			local var_380_8 = var_380_0.team
			local var_380_9 = {}
			
			for iter_380_2, iter_380_3 in pairs(var_380_8.units) do
				local var_380_10 = UNIT:create(table.clone(iter_380_3), true)
				
				if var_380_10 then
					for iter_380_4, iter_380_5 in pairs(var_380_8.equips) do
						if iter_380_5.p == iter_380_3.id then
							local var_380_11 = EQUIP:createByInfo(iter_380_5)
							
							if var_380_11 then
								var_380_10:addEquip(var_380_11, true)
							end
						end
					end
					
					var_380_10:calc()
					
					var_380_9[iter_380_2] = var_380_10
				end
			end
			
			local var_380_12 = Team:makeTeamData(var_380_9)
		end
	end
	
	local var_380_13 = Team:makeTeam(var_380_3)
	
	var_380_13:alignTeam(ENEMY)
	
	arg_380_0.teams[ENEMY] = var_380_13
	
	arg_380_0:addZlongBattleData(ENEMY, var_380_13.units)
	
	if arg_380_0.init_data.is_sync then
		arg_380_0.enemy_team_info = arg_380_0.enemy_team_info or {}
		arg_380_0.enemy_team_info[var_380_0.sector_id] = var_380_13:serialize()
		arg_380_0.enemy_team_units = arg_380_0.enemy_team_units or {}
		arg_380_0.enemy_team_units[var_380_0.sector_id] = var_380_13.units
	elseif arg_380_0.init_battle_info and arg_380_0.init_battle_info.enemy_team_info and arg_380_0.init_battle_info.enemy_team_info[arg_380_1] then
		local var_380_14 = arg_380_0.init_battle_info.enemy_team_info[var_380_0.sector_id]
		
		var_380_13:deserialize(var_380_14)
	else
		Log.i("use client enemy info", arg_380_1)
	end
	
	arg_380_0.enemy_team_data = var_380_3
	
	local var_380_15 = var_380_13.units
	local var_380_16 = arg_380_0.stageMap.weak_info
	local var_380_17 = arg_380_0:getTrialHallInfo()
	
	for iter_380_6, iter_380_7 in ipairs(var_380_15) do
		iter_380_7.inst.no = iter_380_6
		iter_380_7.inst.arena_uid = arg_380_0.away_arena_uid
		
		if iter_380_7.inst.code == "cleardummy" then
			iter_380_7.inst.hp = 0
			iter_380_7.inst.dead = true
		end
		
		if var_380_4 then
			iter_380_7:applyLevelBaseBuff(var_380_4, var_380_5)
		end
		
		if var_380_16 and var_380_16.weak_cs then
			for iter_380_8 = 1, var_380_16.weak_lv do
				iter_380_7:addState(var_380_16.weak_cs, 1, iter_380_7)
			end
		end
		
		if var_380_17 and var_380_17.boss_id == iter_380_7.inst.code then
			if var_380_17.benefit then
				for iter_380_9, iter_380_10 in pairs(var_380_17.benefit) do
					iter_380_7:addState(iter_380_10, 1, iter_380_7)
				end
			end
			
			if var_380_17.penalty then
				for iter_380_11, iter_380_12 in pairs(var_380_17.penalty) do
					iter_380_7:addState(iter_380_12, 1, iter_380_7)
				end
			end
		end
		
		if iter_380_7.inst.code ~= "cleardummy" and arg_380_0:isAutomaton() then
			arg_380_0:addAutomatonEnemyDevice(iter_380_7)
			iter_380_7:recalcHP()
		end
		
		AIManager:bindUnitAIHandler(iter_380_7)
	end
	
	return var_380_15
end

function var_0_3.getGroupTeams(arg_381_0)
	return arg_381_0.group_teams
end

function var_0_3.reserveSwapTeam(arg_382_0, arg_382_1)
	arg_382_0.reserver_swapteam = arg_382_1
end

function var_0_3.swapTeam(arg_383_0, arg_383_1)
	arg_383_1 = arg_383_1 or {}
	arg_383_0.current_group_team_idx = arg_383_0.current_group_team_idx or 1
	arg_383_0.reserve_teams = arg_383_0.reserve_teams or {}
	
	local var_383_0 = arg_383_1.team
	local var_383_1 = arg_383_1.sp_time
	local var_383_2 = arg_383_1.in_time
	local var_383_3 = arg_383_1.out_time
	local var_383_4 = arg_383_1.mid_time
	local var_383_5 = tonumber(var_383_0)
	
	if not var_383_5 or not arg_383_0.group_teams[var_383_5] then
		Log.e("invalid team idx", type(var_383_5), var_383_5)
		
		return 
	end
	
	if arg_383_0.current_group_team_idx == var_383_5 then
		return 
	end
	
	local var_383_6 = arg_383_0.current_group_team_idx
	
	arg_383_0.current_group_team_idx = var_383_5
	
	local var_383_7 = arg_383_0:getTeamRes(FRIEND, "soul_piece") or 0
	local var_383_8 = {}
	local var_383_9 = arg_383_0.friends
	
	if var_383_6 then
		arg_383_0.reserve_teams[var_383_6] = var_383_9
	end
	
	for iter_383_0, iter_383_1 in pairs(arg_383_0.units) do
		if iter_383_1:getAlly() == FRIEND then
			table.insert(var_383_8, 1, iter_383_0)
		end
	end
	
	for iter_383_2, iter_383_3 in ipairs(var_383_8) do
		table.remove(arg_383_0.units, iter_383_3)
	end
	
	arg_383_0.friends = {}
	
	local var_383_10 = arg_383_0.group_teams[var_383_5]
	
	arg_383_0:setupTeamUnits(var_383_10)
	
	arg_383_0.teams[FRIEND] = var_383_10
	
	var_0_9(arg_383_0.friends)
	arg_383_0:setTeamRes(FRIEND, "soul_piece", var_383_7)
	
	for iter_383_4, iter_383_5 in pairs(arg_383_0.friends) do
		if arg_383_0:isViewPlayerActive() then
			if arg_383_0.service and arg_383_0.service:isDummy() then
				if GrowthBoost and GrowthBoost.apply then
					GrowthBoost:apply(iter_383_5, arg_383_0.init_data.grooth_boost_info)
				end
			else
				iter_383_5:applyGrowthBoost()
				iter_383_5:calc()
			end
		elseif GrowthBoost and GrowthBoost.apply then
			GrowthBoost:apply(iter_383_5, arg_383_0.init_data.grooth_boost_info)
		end
		
		iter_383_5:resetVariablePassiveDirty()
		iter_383_5.states:onEnterMap()
		iter_383_5.states:onToggle(nil, true)
		iter_383_5:onToggleVariablePassive()
	end
	
	local var_383_11 = arg_383_0.friends
	
	for iter_383_6, iter_383_7 in pairs(arg_383_0.units) do
		iter_383_7.inst.elapsed_ut = 0
	end
	
	arg_383_0.stage_counter = 0
	arg_383_0.team_stage_counter = {
		[FRIEND] = 0,
		[ENEMY] = 0
	}
	arg_383_0.round_tick = 0
	arg_383_0.turn_info = {
		turn_num = 1,
		state = "next",
		next_queue = {}
	}
	
	arg_383_0:next_turn()
	arg_383_0:onInfos({
		type = "swap_team",
		appear_units = var_383_11,
		disappear_units = var_383_9,
		st_time = var_383_1,
		in_time = var_383_2,
		out_time = var_383_3,
		mid_time = var_383_4
	})
end

function var_0_3.checkBurningPhaseEnter(arg_384_0, arg_384_1)
	local var_384_0 = arg_384_0:getRoadEventObject(arg_384_1)
	
	if not PRODUCTION_MODE and DEBUG_CHANGE_TEAM_RESERVE then
		return true, {
			road_event_id = arg_384_1,
			team = DEBUG_CHANGE_TEAM_RESERVE
		}
	elseif var_384_0.data and var_384_0.data.change_team then
		return true, {
			road_event_id = arg_384_1,
			team = var_384_0.data.change_team
		}
	else
		return false
	end
end

function var_0_3.checkBurningPhaseFinish(arg_385_0)
	return arg_385_0:getTurnOwner().states:isExistEffect("CS_BURNING_PHASE_END")
end

function var_0_3.getCreviceTeamReturnAdd(arg_386_0)
	local var_386_0 = 0
	
	for iter_386_0, iter_386_1 in pairs(arg_386_0.friends) do
		local var_386_1 = iter_386_1.states:findByEff("CSP_RETURN_UP")
		
		if var_386_1 then
			var_386_0 = to_n(var_386_1:getEffValue("CSP_RETURN_UP"))
			
			break
		end
	end
	
	return var_386_0
end

function var_0_3.checkCreviceTeamReturn(arg_387_0, arg_387_1)
	if not arg_387_0:isCreviceHunt() then
		return 
	end
	
	local var_387_0 = (GAME_CONTENT_VARIABLE.crevicehunt_limit_turn or 40) + arg_387_0:getCreviceTeamReturnAdd()
	
	if not PRODUCTION_MODE and DEBUG.CREVICE_LIMIT_TURN then
		var_387_0 = DEBUG.CREVICE_LIMIT_TURN
	end
	
	arg_387_0:procDeadUnits(arg_387_1)
	
	if arg_387_0:getFinishedBattleResult() then
		return false
	end
	
	return var_387_0 <= arg_387_0:getTeamStageCounter()
end

function var_0_3.getCreviceLastHP(arg_388_0)
	return arg_388_0.crevice_last_hp
end

function var_0_3.getCreviceReturn(arg_389_0)
	return arg_389_0.is_crevice_return
end

function var_0_3.onCreviceReturn(arg_390_0)
	if arg_390_0:isCreviceHunt() then
		arg_390_0.is_crevice_return = true
		
		local var_390_0 = to_n(arg_390_0.map.creboss_mhp)
		
		if arg_390_0:isCreviceHunt() then
			for iter_390_0, iter_390_1 in pairs(arg_390_0.enemies) do
				if iter_390_1.db.tier == "boss" then
					var_390_0 = iter_390_1:getHP()
				end
			end
		end
		
		arg_390_0.crevice_last_hp = var_390_0
		
		arg_390_0:onInfos({
			type = "@crevice_return"
		})
	end
end

function var_0_3.onBurning(arg_391_0, arg_391_1, arg_391_2)
	arg_391_2 = arg_391_2 or {}
	
	if not arg_391_0:isBurning() then
		return 
	end
	
	if arg_391_0:isCompletedRoadEvent(arg_391_2.road_event_id) then
		return 
	end
	
	arg_391_0.burning_phase = arg_391_1
	arg_391_0.burning_phase_count = arg_391_0.burning_phase_count or 1
	arg_391_0.current_group_team_idx = arg_391_0.current_group_team_idx or 1
	arg_391_0.reserve_teams = arg_391_0.reserve_teams or {}
	
	if arg_391_1 == "finish" then
		local var_391_0 = {}
		local var_391_1 = {}
		local var_391_2 = {}
		
		for iter_391_0, iter_391_1 in pairs(arg_391_0.units) do
			if iter_391_1 and (iter_391_1.inst.pos ~= arg_391_0:getKeySlotPos() or iter_391_1.inst.ally == ENEMY) then
				table.insert(var_391_0, 1, iter_391_0)
			end
		end
		
		for iter_391_2, iter_391_3 in ipairs(var_391_0) do
			table.remove(arg_391_0.units, iter_391_3)
		end
		
		local var_391_3 = {}
		
		for iter_391_4, iter_391_5 in pairs(arg_391_0.friends) do
			if iter_391_5 and iter_391_5.inst.pos ~= arg_391_0:getKeySlotPos() then
				table.insert(var_391_1, iter_391_5)
				table.insert(var_391_3, 1, iter_391_4)
			end
		end
		
		for iter_391_6, iter_391_7 in ipairs(var_391_3) do
			table.remove(arg_391_0.friends, iter_391_7)
		end
		
		for iter_391_8, iter_391_9 in pairs(arg_391_0.enemies) do
			table.insert(var_391_2, iter_391_9)
		end
		
		arg_391_0.enemies = {}
		arg_391_0.burning_phase_count = arg_391_0.burning_phase_count + 1
		
		arg_391_0:onInfos({
			type = "@burning_phase_action",
			phase = arg_391_1,
			enemy_list = var_391_2,
			disappear_units = var_391_1,
			params = totable(arg_391_2)
		})
	elseif arg_391_1 == "enter" then
		local var_391_4 = tonumber(arg_391_2.team)
		
		if not var_391_4 or not arg_391_0.group_teams[var_391_4] then
			Log.e("invalid team idx", type(var_391_4), var_391_4)
			
			return 
		end
		
		if arg_391_0.current_group_team_idx == var_391_4 then
			return 
		end
		
		local var_391_5 = arg_391_0.current_group_team_idx
		
		arg_391_0.current_group_team_idx = var_391_4
		
		local var_391_6 = arg_391_0.group_teams[var_391_4]
		local var_391_7 = table.shallow_clone(var_391_6.units)
		local var_391_8 = table.shallow_clone(arg_391_0.friends)
		
		for iter_391_10, iter_391_11 in pairs(var_391_8 or {}) do
			iter_391_11.remain = true
		end
		
		arg_391_0:setupTeamUnits(var_391_6)
		
		local var_391_9 = arg_391_0.teams[FRIEND]
		local var_391_10 = arg_391_0:getKeySlotUnit()
		
		var_391_10.group_team_idx = arg_391_0.current_group_team_idx
		
		table.insert(var_391_6.units, var_391_10)
		
		local var_391_11 = var_391_10.team
		
		var_391_6:setRes("soul_piece", var_391_11:getRes("soul_piece"))
		var_391_10:onSetupTeam(var_391_6)
		
		arg_391_0.teams[FRIEND] = var_391_6
		
		var_0_9(arg_391_0.friends)
		
		for iter_391_12, iter_391_13 in pairs(arg_391_0.friends) do
			if arg_391_0:isViewPlayerActive() then
				if arg_391_0.service and arg_391_0.service:isDummy() then
					if GrowthBoost and GrowthBoost.apply then
						GrowthBoost:apply(iter_391_13, arg_391_0.init_data.grooth_boost_info)
					end
				else
					iter_391_13:applyGrowthBoost()
					iter_391_13:calc()
				end
			elseif GrowthBoost and GrowthBoost.apply then
				GrowthBoost:apply(iter_391_13, arg_391_0.init_data.grooth_boost_info)
			end
			
			iter_391_13:resetVariablePassiveDirty()
			iter_391_13.states:onEnterMap()
			iter_391_13.states:onToggle(nil, true)
			iter_391_13:onToggleVariablePassive()
		end
		
		for iter_391_14, iter_391_15 in pairs(arg_391_0.units) do
			iter_391_15.inst.elapsed_ut = 0
		end
		
		arg_391_0:onInfos({
			type = "@burning_phase_action",
			phase = arg_391_1,
			appear_units = var_391_7,
			remain_units = var_391_8,
			params = totable(arg_391_2)
		})
	else
		Log.e("invalid style", arg_391_1)
	end
end

function var_0_3.removeDeadAttackers(arg_392_0)
	for iter_392_0 = #arg_392_0.turn_info.attack_order, 1, -1 do
		local var_392_0 = arg_392_0.turn_info.attack_order[iter_392_0].attacker
		
		if var_392_0:isDead() and (var_392_0 ~= arg_392_0:getTurnOwner() or not var_392_0:isResurrectionReserved()) then
			table.remove(arg_392_0.turn_info.attack_order, iter_392_0)
		end
	end
end

function var_0_3.procDeadUnits(arg_393_0, arg_393_1)
	local var_393_0
	local var_393_1 = {}
	
	for iter_393_0, iter_393_1 in pairs(arg_393_0.units) do
		if not iter_393_1:isDead() and iter_393_1:isEmptyHP() then
			table.insert(var_393_1, iter_393_1)
			arg_393_0:doDead(iter_393_1, arg_393_1)
			
			var_393_0 = true
		end
	end
	
	for iter_393_2, iter_393_3 in pairs(var_393_1) do
		for iter_393_4, iter_393_5 in pairs(arg_393_0.units) do
			if not iter_393_5:isDead() then
				iter_393_5:onAfterSomeoneDead(iter_393_3, arg_393_1)
			end
		end
	end
	
	return var_393_0
end

function var_0_3.procObject(arg_394_0, arg_394_1)
	local var_394_0 = arg_394_0:getRoadEventObject(arg_394_1)
	
	if not var_394_0 then
		return 
	end
	
	if not var_394_0:isAlwayseFire() and arg_394_0:isCompletedRoadEvent(arg_394_1) then
		return 
	end
	
	arg_394_0:setCompleteRoadEvent(arg_394_1)
	
	if arg_394_0:isCompletedLastRoadEvent() then
		arg_394_0.last_stage_result = "win"
	end
	
	local var_394_1 = arg_394_0.battle_info.count_road_event_tbl[arg_394_1] or 0
	local var_394_2 = {
		logic = arg_394_0,
		counting = var_394_1
	}
	local var_394_3 = var_394_0:proc(var_394_2)
	
	arg_394_0:onInfos(table.unpack(var_394_3))
	
	return var_394_0
end

function var_0_3.getLastRoadEventState(arg_395_0)
	return arg_395_0.road_event_run_info.state_name
end

function var_0_3.getDeadUnitUIDList(arg_396_0)
	local var_396_0 = {}
	
	for iter_396_0, iter_396_1 in pairs(arg_396_0.friends) do
		if iter_396_1 and iter_396_1:isDead() then
			table.insert(var_396_0, iter_396_1.inst.uid)
		end
	end
	
	return var_396_0
end

function var_0_3.removeEnemiesDeadUnitUIDList(arg_397_0)
	if not arg_397_0:isClanWar() then
		return 
	end
	
	arg_397_0.enemy_dead_units = {}
end

function var_0_3.setEnemiesDeadUnitUIDList(arg_398_0)
	if not arg_398_0:isClanWar() then
		return 
	end
	
	arg_398_0:removeEnemiesDeadUnitUIDList()
	
	for iter_398_0, iter_398_1 in pairs(arg_398_0.enemies) do
		if iter_398_1 and iter_398_1:isDead() then
			table.insert(arg_398_0.enemy_dead_units, iter_398_1.inst.uid)
		end
	end
end

function var_0_3.getEnemiesDeadUnitUIDList(arg_399_0)
	if not arg_399_0:isClanWar() then
		return 
	end
	
	local var_399_0 = {}
	
	if table.empty(arg_399_0.enemies) then
		var_399_0 = arg_399_0.enemy_dead_units or {}
	else
		for iter_399_0, iter_399_1 in pairs(arg_399_0.enemies) do
			if iter_399_1 and iter_399_1:isDead() then
				table.insert(var_399_0, iter_399_1.inst.uid)
			end
		end
	end
	
	return var_399_0
end

function var_0_3.getAliveCount(arg_400_0, arg_400_1)
	local var_400_0 = 0
	
	for iter_400_0, iter_400_1 in pairs(arg_400_0.units) do
		if not iter_400_1:isEmptyHP() and (not arg_400_1 or arg_400_1 == iter_400_1.inst.ally) and iter_400_1.inst.code ~= "cleardummy" then
			var_400_0 = var_400_0 + 1
		end
	end
	
	return var_400_0
end

function var_0_3.getDeadCount(arg_401_0, arg_401_1)
	local var_401_0 = 0
	
	for iter_401_0, iter_401_1 in pairs(arg_401_0.units) do
		if iter_401_1:isDead() and (not arg_401_1 or arg_401_1 == iter_401_1.inst.ally) and iter_401_1.inst.code ~= "cleardummy" then
			var_401_0 = var_401_0 + 1
		end
	end
	
	return var_401_0
end

function var_0_3.getDeadUnits(arg_402_0, arg_402_1)
	local var_402_0 = table.alignment_clone(arg_402_0.units)
	local var_402_1 = {}
	
	for iter_402_0, iter_402_1 in pairs(var_402_0) do
		if iter_402_1:isDead() and (not arg_402_1 or arg_402_1 == iter_402_1.inst.ally) and iter_402_1.inst.code ~= "cleardummy" then
			table.insert(var_402_1, iter_402_1)
		end
	end
	
	return var_402_1
end

function var_0_3.spawnUnit(arg_403_0, arg_403_1, arg_403_2, arg_403_3)
	if arg_403_2 == nil then
		for iter_403_0, iter_403_1 in pairs(arg_403_0.units) do
			if iter_403_1.inst.ally == arg_403_1.inst.ally then
				if iter_403_1:isDead() or iter_403_1:isEmptyHP() or arg_403_1 == iter_403_1 then
					arg_403_2 = iter_403_1
				end
				
				if arg_403_1 == iter_403_1 then
					break
				end
			end
		end
	end
	
	if arg_403_2 and not arg_403_3 and (arg_403_0:isPVP() or arg_403_2.inst.ally == FRIEND) then
		local var_403_0 = arg_403_2:onRemoveAuraState()
		
		arg_403_0:onInfos(table.unpack(var_403_0))
	end
	
	local var_403_1
	
	for iter_403_2, iter_403_3 in pairs(arg_403_0.units) do
		if arg_403_2 == iter_403_3 then
			var_403_1 = iter_403_2
			
			break
		end
	end
	
	if not var_403_1 then
		return 
	end
	
	arg_403_1.inst.no = arg_403_2.inst.no
	arg_403_1.inst.pos = arg_403_2.inst.pos
	arg_403_1.inst.line = arg_403_2.inst.line
	
	if arg_403_0:getTurnOwner() == arg_403_2 then
		arg_403_0.turn_info.turn_owner = arg_403_1
	end
	
	local var_403_2
	
	if arg_403_1.inst.ally == FRIEND then
		var_403_2 = arg_403_0.friends
		
		local var_403_3, var_403_4 = DB("level_enter", arg_403_0.map.enter, {
			"ally_buff",
			"ally_buff_lv"
		})
		
		if var_403_3 then
			arg_403_1:addState(var_403_3, var_403_4 or 1, arg_403_1)
		end
	else
		var_403_2 = arg_403_0.enemies
	end
	
	for iter_403_4, iter_403_5 in pairs(var_403_2) do
		if arg_403_2 == iter_403_5 then
			var_403_2[iter_403_4] = arg_403_1
			
			break
		end
	end
	
	arg_403_0.units[var_403_1] = arg_403_1
	
	arg_403_0:addAllocatedUnit(arg_403_1)
	arg_403_1:onSetupStage(arg_403_0)
	arg_403_0:updateRtaPenalty()
	arg_403_0:updateMoralePassive()
	
	local var_403_5 = {}
	
	if not arg_403_3 then
		table.add(var_403_5, arg_403_1.states:onEnterMap())
	end
	
	arg_403_0:onInfos(table.unpack(var_403_5))
	
	if arg_403_1.inst.ally == FRIEND then
		arg_403_1:procLotaContents(arg_403_0:getLotaInfo(), arg_403_3)
		arg_403_0:addAutomatonAllyDevice(arg_403_1)
	end
	
	return arg_403_2, var_403_1
end

function var_0_3.getWayDataByPrepend(arg_404_0, arg_404_1)
	arg_404_1 = arg_404_1 or arg_404_0.prepend_stage
	
	if arg_404_1 == "" then
		return arg_404_0.map
	else
		local var_404_0 = string.split(arg_404_1, "_")
		local var_404_1 = table.shallow_clone(arg_404_0.map)
		
		for iter_404_0 = 1, #var_404_0 do
			local var_404_2 = tonumber(var_404_0[iter_404_0])
			
			var_404_1 = var_404_1.way[var_404_2]
		end
		
		return var_404_1
	end
end

function var_0_3.healFriends(arg_405_0, arg_405_1)
	for iter_405_0, iter_405_1 in pairs(arg_405_0.friends) do
		if not iter_405_1:isDead() then
			local var_405_0, var_405_1 = iter_405_1:perHeal(arg_405_1, nil, true)
			
			arg_405_0:onInfos({
				from = "logic",
				type = "heal",
				target = iter_405_1,
				heal = var_405_0,
				add_hp = var_405_0
			})
		end
	end
end

function var_0_3.getOption(arg_406_0, arg_406_1, arg_406_2)
	if not arg_406_0.stageMap.parsed_opts then
		return 
	end
	
	if not arg_406_1 then
		return 
	end
	
	local var_406_0 = arg_406_0.stageMap.parsed_opts[arg_406_1]
	
	if not var_406_0 then
		return 
	end
	
	if arg_406_2 then
		local var_406_1 = {}
		
		for iter_406_0, iter_406_1 in pairs(var_406_0) do
			if type(arg_406_2) == "table" then
				if type(iter_406_1) == "table" then
					local var_406_2 = false
					
					for iter_406_2, iter_406_3 in pairs(iter_406_1) do
						if arg_406_2[iter_406_2] then
							if arg_406_2[iter_406_2] ~= iter_406_3 then
								var_406_2 = false
								
								break
							end
							
							var_406_2 = true
						end
					end
					
					if var_406_2 then
						table.insert(var_406_1, iter_406_1)
					end
				elseif iter_406_1 == arg_406_2[iter_406_0] then
					table.insert(var_406_1, iter_406_1)
				end
			elseif type(arg_406_2) == "string" and iter_406_0 == arg_406_2 then
				table.insert(var_406_1, iter_406_1)
			end
		end
		
		return var_406_1
	else
		return var_406_0
	end
end

function var_0_3.procAutoHeal(arg_407_0, arg_407_1)
	local var_407_0 = {}
	
	for iter_407_0, iter_407_1 in pairs(arg_407_0.friends) do
		if not arg_407_1 or iter_407_1:isEmptyHP() then
			iter_407_1.states:removeStates(-1, function(arg_408_0)
				return arg_408_0.db.cs_type == "debuff"
			end)
			iter_407_1:autoHeal(var_407_0)
		end
	end
	
	arg_407_0:onInfos(table.unpack(var_407_0))
end

function var_0_3.calcAutomatonAllyHP(arg_409_0, arg_409_1)
	if not arg_409_0.friends or not arg_409_1 or table.empty(arg_409_1) then
		return 
	end
	
	for iter_409_0, iter_409_1 in pairs(arg_409_0.friends) do
		local var_409_0 = 1000
		local var_409_1 = iter_409_1:getUID() or 0
		local var_409_2 = arg_409_1[tostring(var_409_1)]
		
		if var_409_2 then
			var_409_0 = var_409_2
		end
		
		local var_409_3 = var_409_0 / 1000
		local var_409_4 = math.min(iter_409_1.status.max_hp, math.floor(iter_409_1.status.max_hp * var_409_3))
		
		iter_409_1.inst.hp = var_409_4
	end
end

function var_0_3.setMonsterDevice(arg_410_0, arg_410_1)
	arg_410_0.encrypt.monster_device = arg_410_1
end

function var_0_3.getMonsterDevice(arg_411_0)
	return arg_411_0.encrypt.monster_device or {}
end

function var_0_3.setUserDevice(arg_412_0, arg_412_1)
	arg_412_0.encrypt.user_device = arg_412_1
end

function var_0_3.getUserDevice(arg_413_0)
	return arg_413_0.encrypt.user_device or {}
end

function var_0_3.addAutomatonEnemyDevice(arg_414_0, arg_414_1)
	if not arg_414_1 or table.empty(arg_414_0.encrypt.monster_device) or not arg_414_0:isAutomaton() then
		return 
	end
	
	for iter_414_0, iter_414_1 in pairs(arg_414_0.encrypt.monster_device) do
		arg_414_1:addState(iter_414_1)
	end
end

function var_0_3.clearEnemies(arg_415_0)
	for iter_415_0 = #arg_415_0.units, 1, -1 do
		if arg_415_0.units[iter_415_0].inst.ally == ENEMY then
			table.remove(arg_415_0.units, iter_415_0)
		end
	end
	
	arg_415_0.enemies = {}
	arg_415_0.enemy_hidden = nil
end

function var_0_3.isProtectedByTanker(arg_416_0, arg_416_1)
	do return false end
	
	if not arg_416_1.team then
		return false
	end
	
	local var_416_0
	
	if arg_416_1.inst.ally == FRIEND then
		var_416_0 = arg_416_0.friends
	else
		var_416_0 = arg_416_0.enemies
	end
	
	return arg_416_1.team.units[1] and not var_416_0[1]:isDead() and arg_416_1 ~= var_416_0[1]
end

local function var_0_14(arg_417_0, arg_417_1)
	local var_417_0
	
	for iter_417_0 = 1, 999 do
		local var_417_1, var_417_2 = DB("pvp_penalty", tostring(iter_417_0), {
			"turn",
			"damage"
		})
		
		if var_417_1 and arg_417_0 < var_417_1 then
			return tostring(iter_417_0), var_417_1 - arg_417_0, var_417_1 - (var_417_0 or 0), var_417_2
		end
		
		if var_417_1 then
			var_417_0 = var_417_1
		end
	end
end

function var_0_3.procPenaltyInfo(arg_418_0)
	if not arg_418_0:isPVP() then
		return 
	end
	
	if arg_418_0:isTournament() then
		return 
	end
	
	if arg_418_0:isClanWar() then
		return 
	end
	
	local var_418_0 = arg_418_0:getStageCounter()
	
	if arg_418_0:isViewPlayerActive() then
		local var_418_1 = arg_418_0:getStageCounter()
		
		if arg_418_0:isViewPlayerActive() then
			if arg_418_0:isEnableRtaPenalty() then
				local var_418_2
				
				for iter_418_0 = 1, 10 do
					local var_418_3 = arg_418_0.rta_penalty_db[iter_418_0]
					
					if not var_418_3 or not var_418_3.id then
						break
					end
					
					if var_418_1 < to_n(var_418_3.turn) then
						break
					end
					
					var_418_2 = var_418_3
				end
				
				if var_418_2 then
					if arg_418_0.battle_info.rta_penalty_info and to_n(arg_418_0.battle_info.rta_penalty_info.turn) < to_n(var_418_2.turn) then
						arg_418_0:onInfos({
							type = "banner",
							info = {
								type = "warning",
								textid = var_418_2.cs_desc
							}
						})
						arg_418_0:onInfos({
							check_type = "rta",
							type = "smart_bg",
							check_value = var_418_2.cs_id
						})
					end
					
					arg_418_0.battle_info.rta_penalty_info = var_418_2
				end
			end
			
			return 
		end
	end
	
	local var_418_4, var_418_5, var_418_6, var_418_7 = var_0_14(var_418_0)
	
	arg_418_0:onInfos({
		type = "pvp_penalty_info",
		db_turn = var_418_4,
		rest = var_418_5,
		cool = var_418_6,
		damage = var_418_7
	})
end

function var_0_3.procPVP(arg_419_0)
	if not arg_419_0:isPVP() then
		return 
	end
	
	if arg_419_0:isTournament() then
		return 
	end
	
	if arg_419_0:isClanWar() then
		if arg_419_0.limit_time and arg_419_0.limit_time < os.time() then
			arg_419_0:onInfos({
				type = "clanwar_penalty"
			})
		end
		
		arg_419_0:updateClanWar()
		
		return 
	end
	
	arg_419_0:procPenaltyInfo()
	
	if arg_419_0:isRealtimeMode() then
		arg_419_0:updateRtaPenalty()
		
		return 
	end
	
	local var_419_0 = arg_419_0:getStageCounter()
	local var_419_1 = SLOW_DB_ALL("pvp_penalty", tostring(var_419_0)) or {}
	local var_419_2 = tonumber(var_419_1.damage) or 0
	
	if var_419_2 > 0 then
		local var_419_3 = {}
		
		for iter_419_0, iter_419_1 in pairs(arg_419_0.friends) do
			if iter_419_1 and not iter_419_1:isDead() then
				local var_419_4, var_419_5, var_419_6 = iter_419_1:decHP(var_419_3, var_419_2, {
					ignore_guard = true
				})
				
				arg_419_0:onInfos({
					cur_hit = 1,
					type = "attack",
					tot_hit = 1,
					attack_type = "pvp_penalty",
					target = iter_419_1,
					damage = var_419_4,
					shield = var_419_5,
					dec_hp = var_419_6
				})
			end
		end
		
		arg_419_0:onInfos(table.unpack(var_419_3))
		arg_419_0:onInfos({
			type = "pvp_penalty"
		})
	end
end

function var_0_3.makeRtaPenaltyInfo(arg_420_0)
	if not arg_420_0:isViewPlayerActive() then
		return 
	end
	
	if not arg_420_0.world_arena_season_id then
		return 
	end
	
	arg_420_0.rta_penalty_db = arg_420_0.rta_penalty_db or {}
	
	local var_420_0 = DB("pvp_rta_season", arg_420_0.world_arena_season_id, {
		"group_id"
	}) or DB("pvp_rta_season_event", arg_420_0.world_arena_season_id, {
		"group_id"
	})
	
	for iter_420_0 = 1, 999999 do
		local var_420_1, var_420_2 = DBN("pvp_rta_penalty", tostring(iter_420_0), {
			"id",
			"group_id"
		})
		
		if not var_420_1 or not var_420_2 then
			break
		end
		
		if var_420_0 == var_420_2 then
			local var_420_3 = DBT("pvp_rta_penalty", tostring(iter_420_0), {
				"id",
				"group_id",
				"order",
				"turn",
				"cs_id",
				"cs_id2",
				"cs_desc",
				"cs_good1",
				"cs_good1_value",
				"cs_good2",
				"cs_good2_value",
				"cs_good3",
				"cs_good3_value",
				"cs_harm1",
				"cs_harm1_value",
				"cs_harm2",
				"cs_harm2_value",
				"cs_harm3",
				"cs_harm3_value"
			})
			
			if var_420_3 then
				arg_420_0.rta_penalty_db[var_420_3.order] = var_420_3
			end
		end
	end
end

function var_0_3.getRtaPenaltyDB(arg_421_0, arg_421_1)
	return arg_421_0.rta_penalty_db[arg_421_1]
end

function var_0_3.updateRtaPenalty(arg_422_0, arg_422_1)
	if not arg_422_0:isRealtimeMode() then
		return 
	end
	
	if not arg_422_0:isEnableRtaPenalty() then
		return 
	end
	
	local var_422_0 = arg_422_1 or arg_422_0.units or {}
	local var_422_1 = arg_422_0.battle_info.rta_penalty_info
	
	for iter_422_0 = 10000, 10010 do
		local var_422_2 = arg_422_0.rta_penalty_db[iter_422_0]
		
		if not var_422_2 then
			break
		end
		
		for iter_422_1, iter_422_2 in pairs(var_422_0) do
			if not iter_422_2:checkState(var_422_2.cs_id) then
				local var_422_3, var_422_4 = iter_422_2:addState(var_422_2.cs_id, 1, nil, {
					turn = 9999
				})
				
				if var_422_4 then
					arg_422_0:onInfos({
						type = "add_state",
						target = iter_422_2,
						state = var_422_4
					})
				end
			end
		end
	end
	
	if var_422_1 and not table.empty(var_422_1) then
		for iter_422_3, iter_422_4 in pairs(var_422_0) do
			for iter_422_5 = 1, 10 do
				if var_422_1.id ~= tostring(iter_422_5) then
					local var_422_5 = arg_422_0.rta_penalty_db[iter_422_5]
					
					if var_422_5 then
						iter_422_4.tmp_vars.hp_down_dirty = true
						
						if var_422_5.cs_id then
							iter_422_4.states:removeById(var_422_5.cs_id)
						end
						
						iter_422_4.tmp_vars.hp_down_dirty = true
						
						if var_422_5.cs_id2 then
							iter_422_4.states:removeById(var_422_5.cs_id2)
						end
						
						iter_422_4.tmp_vars.hp_down_dirty = nil
					end
				end
			end
			
			if not iter_422_4:checkState(var_422_1.cs_id) then
				local var_422_6, var_422_7 = iter_422_4:addState(var_422_1.cs_id, 1, nil, {
					turn = 9999
				})
				
				if var_422_7 then
					arg_422_0:onInfos({
						type = "add_state",
						target = iter_422_4,
						state = var_422_7
					})
				end
			end
			
			if not iter_422_4:checkState(var_422_1.cs_id2) then
				local var_422_8, var_422_9 = iter_422_4:addState(var_422_1.cs_id2, 1, nil, {
					turn = 9999
				})
				
				if var_422_9 then
					arg_422_0:onInfos({
						type = "add_state",
						target = iter_422_4,
						state = var_422_9
					})
				end
			end
		end
	end
end

function var_0_3.updateClanWar(arg_423_0)
	if arg_423_0:isOptionalDraw() then
		arg_423_0:onInfos({
			type = "draw_notify",
			stage_count = stage_count
		})
	else
		local var_423_0 = arg_423_0:getStageCounter()
		
		arg_423_0:onInfos({
			type = "draw_notify",
			stage_count = var_423_0
		})
	end
end

function var_0_3.isOptionalDraw(arg_424_0)
	local var_424_0 = arg_424_0:getStageCounter()
	
	if not PRODUCTION_MODE and DEBUG.CLANWAR_DRAW_ALWAYS then
		return true
	end
	
	return var_424_0 >= (GAME_STATIC_VARIABLE.clan_draw_turn or 20)
end

function var_0_3.getCampingData(arg_425_0)
	return arg_425_0.battle_info.camping_data
end

function var_0_3.getCampingTopicCount(arg_426_0)
	return #arg_426_0.battle_info.camping_data
end

function var_0_3.getMoraleLevel(arg_427_0, arg_427_1)
	local var_427_0 = arg_427_1 or arg_427_0:getTeamRes(FRIEND, "morale")
	local var_427_1 = arg_427_0:getMoraleMaxStep()
	local var_427_2 = arg_427_0.battle_info.morale_tbl
	
	for iter_427_0, iter_427_1 in pairs(var_427_2) do
		if var_427_0 >= iter_427_1.morale_num then
			var_427_1 = iter_427_0
			
			break
		end
	end
	
	return var_427_1
end

function var_0_3.setMorale(arg_428_0, arg_428_1, arg_428_2)
	if not arg_428_2 and arg_428_0.battle_info.road_info.road_type == "goblin" then
		return 
	end
	
	local var_428_0 = arg_428_0:getTeamRes(FRIEND, "morale")
	local var_428_1 = math.clamp(arg_428_1, arg_428_0:getMoraleValue("min"), arg_428_0:getMoraleValue("max"))
	
	if var_428_0 > arg_428_0:getMoraleValue("min") and var_428_1 < var_428_0 then
		local var_428_2 = var_428_0 - var_428_1
		
		table.insert(arg_428_0.battle_info.morale_log, var_428_2)
	end
	
	arg_428_0:setTeamRes(FRIEND, "morale", var_428_1)
end

function var_0_3.getMoraleVariant(arg_429_0)
	local var_429_0 = 0
	
	for iter_429_0, iter_429_1 in pairs(arg_429_0.battle_info.morale_log) do
		var_429_0 = var_429_0 + iter_429_1
	end
	
	return var_429_0
end

function var_0_3.addNextTurnOwner(arg_430_0, arg_430_1, arg_430_2)
	arg_430_2 = arg_430_2 or {}
	
	if arg_430_2.is_front then
		table.insert(arg_430_0.turn_info.next_queue, 1, {
			unit = arg_430_1,
			skill_id = arg_430_2.skill_id,
			add_more = arg_430_2.add_more
		})
	else
		table.insert(arg_430_0.turn_info.next_queue, {
			unit = arg_430_1,
			skill_id = arg_430_2.skill_id,
			add_more = arg_430_2.add_more
		})
	end
end

function var_0_3.processMorale(arg_431_0, arg_431_1, arg_431_2)
	local var_431_0 = 0
	
	if arg_431_2 then
		var_431_0 = GAME_STATIC_VARIABLE.dungeon_waypoint_morale
	elseif arg_431_1.is_cross then
		var_431_0 = 1
	end
	
	if var_431_0 > 0 then
		arg_431_0:decMorale(var_431_0)
	end
end

function var_0_3.decMorale(arg_432_0, arg_432_1)
	arg_432_1 = arg_432_1 or 1
	
	local var_432_0 = arg_432_0:getTeamRes(FRIEND, "morale")
	
	arg_432_0:setMorale(var_432_0 - math.abs(arg_432_1))
	arg_432_0:updateMoralePassive()
	
	local var_432_1 = arg_432_0:getTeamRes(FRIEND, "morale")
	
	arg_432_0:onInfos({
		type = "dec_morale",
		dec_value = arg_432_1,
		value = var_432_1
	})
end

function var_0_3.updateMoralePassive(arg_433_0)
	if not string.starts(arg_433_0.type, "dungeon") then
		return 
	end
	
	local var_433_0 = arg_433_0:getMoraleLevel()
	local var_433_1 = arg_433_0.battle_info.morale_tbl
	local var_433_2 = arg_433_0.teams[FRIEND]
	local var_433_3 = false
	local var_433_4
	local var_433_5 = {}
	
	for iter_433_0, iter_433_1 in pairs(var_433_1) do
		if var_433_0 == iter_433_0 then
			if not var_433_2.passive_skills[iter_433_1.buff_id] then
				var_433_2.passive_skills[iter_433_1.buff_id] = 1
			end
			
			var_433_4 = iter_433_1.buff_id
		else
			var_433_2.passive_skills[iter_433_1.buff_id] = nil
			
			for iter_433_2, iter_433_3 in pairs(arg_433_0.friends) do
				iter_433_3.states:removeById(iter_433_1.passive_id)
			end
		end
	end
	
	for iter_433_4, iter_433_5 in pairs(arg_433_0.friends) do
		if var_433_4 and not iter_433_5.states:getPassiveSkillState(var_433_4) then
			iter_433_5:calc()
		end
	end
end

function var_0_3.getCurrentSubstoryID(arg_434_0)
	if not arg_434_0.battle_info then
		return 
	end
	
	if not arg_434_0.battle_info.substory_info then
		return 
	end
	
	return arg_434_0.battle_info.substory_info.id
end

function var_0_3.setMoonlightTheaterEpisodeID(arg_435_0, arg_435_1)
	arg_435_0.battle_info.moonlight_theater_episode_id = arg_435_1
end

function var_0_3.setForcePreviewMode(arg_436_0, arg_436_1)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_436_0.battle_info.force_preview_mode = arg_436_1
end

function var_0_3.getMoonlightTheaterEpisodeID(arg_437_0)
	return arg_437_0.battle_info.moonlight_theater_episode_id
end

function var_0_3.setBurningStoryID(arg_438_0, arg_438_1)
	arg_438_0.battle_info.burning_story_id = arg_438_1
end

function var_0_3.getBurningStoryID(arg_439_0)
	return arg_439_0.battle_info.burning_story_id
end

function var_0_3.isNPCTeam(arg_440_0)
	return ((arg_440_0.init_data or {}).started_data or {}).npcteam_id ~= nil
end

function var_0_3.isAutoBattleAble(arg_441_0)
	return arg_441_0.auto_battle_able
end

function var_0_3.getMoraleData(arg_442_0)
	return arg_442_0.battle_info.morale_tbl
end

function var_0_3.addContentEnhance(arg_443_0, arg_443_1)
	arg_443_1:addContentEnhance()
	
	local var_443_0 = {}
	
	table.insert(var_443_0, {
		type = "content_enhance",
		target_uid = arg_443_1.inst.uid
	})
	arg_443_0:onInfos(table.unpack(var_443_0))
end

function var_0_3.addUnitStateCondition(arg_444_0, arg_444_1)
	arg_444_0:onInfos({
		type = "dispatch_conditoin",
		target = arg_444_1.unit,
		state_id = arg_444_1.state_id
	})
end

function var_0_3.getMoraleMaxStep(arg_445_0)
	local var_445_0
	
	if arg_445_0.stageMap.contents_type == "raid" then
		var_445_0 = GAME_STATIC_VARIABLE.raid_morale_max_step
	else
		var_445_0 = GAME_STATIC_VARIABLE.morale_max_step
	end
	
	return var_445_0 or 5
end

function var_0_3.getMoraleValue(arg_446_0, arg_446_1, arg_446_2)
	if not arg_446_1 then
		return 
	end
	
	local var_446_0
	
	if arg_446_0.stageMap.contents_type == "raid" then
		var_446_0 = GAME_STATIC_VARIABLE["raid_morale_" .. arg_446_1]
	else
		var_446_0 = GAME_STATIC_VARIABLE["dungeon_morale_" .. arg_446_1]
	end
	
	return var_446_0 or arg_446_2
end

function var_0_3.clearMaxDamage(arg_447_0)
	arg_447_0.encrypt.logMaxDamage = 0
end

function var_0_3.setMaxDamage(arg_448_0, arg_448_1)
	if arg_448_1 and arg_448_1 > arg_448_0.encrypt.logMaxDamage then
		arg_448_0.encrypt.logMaxDamage = arg_448_1
	end
end

function var_0_3.getMaxDamage(arg_449_0)
	return arg_449_0.encrypt.logMaxDamage
end

function var_0_3.clearRateSSR(arg_450_0)
	arg_450_0.logDiffDamage = {}
end

function var_0_3.insertRateSSR(arg_451_0, arg_451_1, arg_451_2, arg_451_3)
	if #arg_451_0.logDiffDamage < 3 then
		table.insert(arg_451_0.logDiffDamage, {
			display = arg_451_1,
			damage = arg_451_2,
			skill = arg_451_3
		})
	end
end

function var_0_3.getRateSSR(arg_452_0)
	if #arg_452_0.logDiffDamage > 0 then
		return array_to_json(arg_452_0.logDiffDamage)
	end
	
	return nil
end

function var_0_3.getLatte(arg_453_0)
	local var_453_0 = {}
	
	for iter_453_0, iter_453_1 in pairs(arg_453_0.starting_friends) do
		table.insert(var_453_0, {
			c = iter_453_1.db.code,
			s = iter_453_1:encodeEquip()
		})
	end
	
	return var_453_0
end

function var_0_3.getUnitPeakStat(arg_454_0)
	return arg_454_0.peak_stats
end

function var_0_3.updateUnitPeakStat(arg_455_0)
	if not arg_455_0.peak_stats then
		arg_455_0.peak_stats = {}
	end
	
	for iter_455_0, iter_455_1 in pairs(arg_455_0.friends) do
		if not iter_455_1:isSupporter() then
			if not arg_455_0.peak_stats[iter_455_1:getUID()] then
				arg_455_0.peak_stats[iter_455_1:getUID()] = iter_455_1.stat
			else
				local var_455_0 = arg_455_0.peak_stats[iter_455_1:getUID()]
				local var_455_1 = iter_455_1.stat
				local var_455_2 = false
				
				for iter_455_2, iter_455_3 in pairs({
					"bra",
					"int",
					"fai",
					"des"
				}) do
					if to_n(var_455_0[iter_455_3]) < to_n(var_455_1[iter_455_3]) then
						var_455_2 = true
					end
				end
				
				if var_455_2 then
					arg_455_0.peak_stats[iter_455_1:getUID()] = iter_455_1.stat
				end
			end
		end
	end
end

function var_0_3.getSelectMapData(arg_456_0)
	return arg_456_0.stageMap.select_map_data
end

function var_0_3.checkUnitStat(arg_457_0)
	if not arg_457_0.peak_stats then
		arg_457_0.peak_stats = {}
	end
	
	local var_457_0 = {}
	
	for iter_457_0, iter_457_1 in pairs(arg_457_0.starting_friends) do
		if iter_457_1 and not iter_457_1:isSupporter() then
			local var_457_1 = iter_457_1.db.code
			local var_457_2 = DBT("character", var_457_1, {
				"bra",
				"int",
				"fai",
				"des"
			})
			local var_457_3 = arg_457_0.peak_stats[iter_457_1:getUID()]
			local var_457_4 = false
			
			for iter_457_2, iter_457_3 in pairs({
				"bra",
				"int",
				"fai",
				"des"
			}) do
				if to_n(var_457_2[iter_457_3]) < to_n(var_457_3[iter_457_3]) then
					var_457_4 = true
				end
			end
			
			if var_457_4 then
				var_457_0[iter_457_1:getUID()] = var_457_3
			end
		end
	end
	
	return var_457_0
end

function var_0_3.addPlayedStoryList(arg_458_0, arg_458_1)
	if not arg_458_0.battle_info.played_story_list[arg_458_1] then
		arg_458_0.battle_info.played_story_list[arg_458_1] = {
			activate = false
		}
	end
end

function var_0_3.setPlayedStoryList(arg_459_0, arg_459_1)
	for iter_459_0, iter_459_1 in pairs(arg_459_1 or {}) do
		if not arg_459_0.battle_info.played_story_list[iter_459_1] then
			arg_459_0.battle_info.played_story_list[iter_459_1] = {
				activate = false
			}
		end
	end
end

function var_0_3.getPlayedStoryList(arg_460_0)
	return arg_460_0.battle_info.played_story_list
end

function var_0_3.getProcInfoDelay(arg_461_0, arg_461_1)
	if BattleDelay[arg_461_1.type] then
		return BattleDelay[arg_461_1.type]:getDelay(arg_461_0, arg_461_1) or 0
	end
	
	return 0
end

function var_0_3.procState(arg_462_0)
	while arg_462_0:getFinalResult() == nil do
		local var_462_0 = arg_462_0:getTurnState()
		
		arg_462_0:proc()
		
		if var_462_0 == arg_462_0:getTurnState() then
			break
		end
	end
end

function var_0_3.isRestoreViewInfo(arg_463_0, arg_463_1)
	if arg_463_1.type == "@enter_road" then
		return true
	elseif arg_463_1.type == "@enter_road_sector" then
		return true
	elseif arg_463_1.type == "@end_road_event" then
		return true
	elseif arg_463_1.type == "@prepare_road_event" then
		return true
	elseif arg_463_1.type == "@encounter_road_event" then
		return true
	elseif arg_463_1.type == "@encounter_enemy" then
		return true
	elseif arg_463_1.type == "@end_battle" then
		return true
	end
end

function var_0_3.isStatisticViewInfo(arg_464_0, arg_464_1)
	return arg_464_1.type == "heal" or arg_464_1.type == "resurrect" or arg_464_1.type == "shield" or arg_464_1.dec_hp and arg_464_1.from ~= arg_464_1.target
end

function var_0_3.procinfos(arg_465_0, arg_465_1, arg_465_2)
	arg_465_2 = arg_465_2 or {}
	
	local var_465_0 = {}
	local var_465_1 = {}
	
	while arg_465_0:getFinalResult() == nil do
		arg_465_0:procState()
		
		local var_465_2 = arg_465_0:popInfoAll()
		
		if table.empty(var_465_2) then
			break
		end
		
		for iter_465_0, iter_465_1 in pairs(var_465_2) do
			arg_465_0:procInfo(iter_465_1, arg_465_1, arg_465_2)
			table.insert(var_465_1, iter_465_1)
			
			local var_465_3 = arg_465_0:getProcInfoDelay(iter_465_1)
			
			if iter_465_1.type and var_465_3 > 0 then
				var_465_0[iter_465_1.type] = var_465_0[iter_465_1.type] or 0
				
				if var_465_3 > var_465_0[iter_465_1.type] then
					var_465_0[iter_465_1.type] = var_465_3
				end
			end
		end
	end
	
	arg_465_0:execute()
	
	return var_465_0, var_465_1
end

function var_0_3.procReady(arg_466_0)
	local var_466_0 = arg_466_0:getTurnOwner()
	
	if not var_466_0 then
		return 
	end
	
	if arg_466_0:isAIPlayer(var_466_0) then
		arg_466_0:doAutoSkill()
	else
		if not arg_466_0.ai_random then
			arg_466_0.ai_random = getRandom(os.time())
		end
		
		local var_466_1, var_466_2, var_466_3, var_466_4 = AIManager:selectSkillIdxAndTarget(arg_466_0.ai_random, var_466_0, nil)
		
		arg_466_0:command({
			is_soul = false,
			cmd = "StartSkill",
			attacker_uid = var_466_0.inst.uid,
			skill_id = var_466_2,
			target_uid = var_466_4.inst.uid,
			skill_idx = var_466_1,
			ally = var_466_0:getAlly()
		})
	end
end

function var_0_3.procInfo(arg_467_0, arg_467_1, arg_467_2, arg_467_3)
	if arg_467_1.type == "@enter_road" then
		if arg_467_3 and arg_467_3.battle_instance then
			arg_467_3.battle_instance:command(arg_467_1.type, arg_467_1)
		end
		
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.replay", {
			type = arg_467_1.type
		})
	elseif arg_467_1.type == "@encounter_enemy" then
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.replay", {
			type = arg_467_1.type
		})
	elseif arg_467_1.type == "@ready_attack" then
		if arg_467_2 then
			return 
		end
		
		arg_467_0:procReady()
	elseif arg_467_1.type == "@end_turn" then
		if arg_467_0:isCompletedLastRoadEvent() then
			print("logic:isCompletedLastRoadEvent()", arg_467_0:isCompletedLastRoadEvent())
		end
	elseif arg_467_1.type == "@skill_start" then
		local var_467_0 = arg_467_1.unit:getSkinCheck() or "hit_count"
		local var_467_1 = arg_467_0:getTotalHitCount(arg_467_1.att_info.skill_id, var_467_0)
		
		for iter_467_0 = 1, var_467_1 do
			arg_467_0:command({
				cmd = "HitEvent",
				unit_uid = arg_467_1.unit.inst.uid,
				tot_hit = var_467_1
			})
		end
		
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.replay", {
			type = arg_467_1.type,
			attacker = arg_467_1.unit,
			skill_id = arg_467_1.att_info.skill_id,
			is_coop = arg_467_1.att_info.coop_order == 2,
			is_hidden = arg_467_1.att_info.is_hidden or false,
			is_counter = arg_467_1.att_info.is_counter or false,
			X1 = arg_467_0.random.X1,
			X2 = arg_467_0.random.X2
		})
	elseif arg_467_1.type == "set_ignore_hit_action" then
		(arg_467_1.target or arg_467_0:getUnit(arg_467_1.target_uid)):setIgnoreHitAction(arg_467_1.flag)
	elseif arg_467_1.type == "@end_road_event" then
		local var_467_2 = arg_467_0:getRoadEventObject(arg_467_1.road_event_id) or {}
		local var_467_3 = arg_467_0:getFinalResult() == "lose"
		
		if not arg_467_2 and not var_467_3 and var_467_2.is_last and arg_467_0:getCurrentRoadType() == "chaos" then
			arg_467_0:command({
				cmd = "ReturnRoad"
			})
		end
		
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.replay", {
			type = arg_467_1.type
		})
	elseif arg_467_1.type == "@end_battle" then
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.replay", {
			type = arg_467_1.type,
			proc_counter = Battle.logic.battle_info.proc_info.counter
		})
	end
	
	arg_467_0:procConditions(arg_467_1, arg_467_2, arg_467_3)
end

function var_0_3.procConditions(arg_468_0, arg_468_1, arg_468_2, arg_468_3)
	local var_468_0 = arg_468_0:getBattleUID()
	
	if arg_468_1.type == "@fire_road_event" then
		local var_468_1 = arg_468_0:getRoadEventObject(arg_468_1.road_event_id)
		
		if var_468_1 and var_468_1:isTouchable() then
			ConditionContentsManager:dispatch("battle.touchObject", {
				unique_id = var_468_0,
				event_type = var_468_1.type,
				enter_id = arg_468_0.map.enter,
				entertype = arg_468_0.type
			})
		end
	elseif arg_468_1.type == "dead" then
		local var_468_2 = arg_468_0:getUnit(arg_468_1.target_uid)
		
		if var_468_2 and var_468_2.inst.ally == ENEMY then
			ConditionContentsManager:dispatch("battle.killed", {
				unique_id = var_468_0,
				targetid = var_468_2.db.code,
				enter_id = arg_468_0.map.enter,
				entertype = arg_468_0.type
			})
		end
	elseif arg_468_1.type == "dispatch_conditoin" then
		ConditionContentsManager:dispatch("battle.cs", {
			unique_id = var_468_0,
			target_unit = arg_468_1.target,
			state_id = arg_468_1.state_id,
			entertype = arg_468_0.type
		})
	end
end

function var_0_3.getTotalHitCount(arg_469_0, arg_469_1, arg_469_2)
	if not CACHE_HIT_COUNT_DB[arg_469_1] then
		make_action_data_ext({
			skill_id = arg_469_1,
			callback = function(arg_470_0, arg_470_1)
				CACHE_HIT_COUNT_DB[arg_470_0] = arg_470_1
			end
		})
	end
	
	print("hit count", arg_469_1, arg_469_2, CACHE_HIT_COUNT_DB[arg_469_1][arg_469_2])
	
	if not CACHE_HIT_COUNT_DB[arg_469_1][arg_469_2] or CACHE_HIT_COUNT_DB[arg_469_1][arg_469_2] < 1 then
		return 1
	else
		return CACHE_HIT_COUNT_DB[arg_469_1][arg_469_2]
	end
end

function var_0_3.getStoryIdList(arg_471_0)
	local var_471_0 = {}
	
	for iter_471_0, iter_471_1 in pairs(arg_471_0.stageMap.road_event_object_tbl) do
		if iter_471_1 then
			table.insert(var_471_0, iter_471_1.road_id)
			
			if iter_471_1.story_id then
				table.insert(var_471_0, iter_471_1.story_id)
			end
		end
	end
	
	return var_471_0
end

function var_0_3.make_replay_data(arg_472_0, arg_472_1)
	if not arg_472_1 then
		Log.e("require save mode")
		
		return 
	end
	
	local var_472_0 = {
		init_data = arg_472_0.init_data,
		team_data = arg_472_0.team_data,
		map_data = arg_472_0.map
	}
	
	var_472_0.init_data.service = nil
	var_472_0.init_record = arg_472_0.view_history[1]
	
	if arg_472_1 == "view" then
		var_472_0.snap_data = arg_472_0.snap_history
		var_472_0.record_data = arg_472_0.view_history
	elseif arg_472_1 == "command" then
		var_472_0.command_data = arg_472_0.battle_info.replay_data
	end
	
	var_472_0.result_info = {
		net_pvp = true,
		map_id = "pvp001",
		net_pvp_result = {}
	}
	
	local var_472_1 = json.encode(var_472_0)
	
	Log.i("save command data to json", string.len(var_472_1))
	
	return var_472_1
end

function var_0_3.changeStageBG(arg_473_0, arg_473_1)
	arg_473_0:onInfos({
		type = "@change_bg",
		value = arg_473_1
	})
end

function var_0_3.SkillConditionIntegrityTest(arg_474_0, arg_474_1)
	local var_474_0 = {
		"id",
		"att_rate",
		"target"
	}
	
	for iter_474_0 = 1, 8 do
		table.insert(var_474_0, "sk_add_con" .. iter_474_0)
		table.insert(var_474_0, "sk_add_con" .. iter_474_0 .. "_before")
		table.insert(var_474_0, "sk_add_target" .. iter_474_0)
		table.insert(var_474_0, "sk_add_eff" .. iter_474_0)
	end
	
	local var_474_1 = {
		12,
		13,
		16,
		24,
		27,
		81,
		"ENEMY_ALL_LESS_ATT",
		"ENEMY_ALL_LESS_ATT_NOT"
	}
	local var_474_2 = {
		"AB_DOWN",
		"AB_DOWN_RANDOM",
		"BUFF_DOWN",
		"BUFF_REMOVE",
		"BUFF_STEAL",
		"BUFF_STEAL_ALLY",
		"CD_UP",
		"CS_ADD",
		"CS_EXTEND",
		"CS_RANDOM",
		"DEBUFF_EXTEND",
		"DEBUFF_TRANSFER",
		"DEBUFF_TRANSFER_SEQ"
	}
	
	print("===== SKill DB Integrity Test =====")
	
	for iter_474_1 = 1, 999999 do
		local var_474_3, var_474_4, var_474_5 = DBN("skill", iter_474_1, {
			"id",
			"att_rate",
			"target"
		})
		
		if not var_474_3 then
			break
		end
		
		local var_474_6
		
		if to_n(var_474_4) ~= 0 and table.isInclude({
			12,
			13,
			16,
			17,
			24,
			25,
			35
		}, var_474_5) then
			var_474_6 = DBT("skill", var_474_3, var_474_0)
			
			for iter_474_2 = 1, 8 do
				local var_474_7 = var_474_6["sk_add_target" .. iter_474_2]
				local var_474_8 = var_474_6["sk_add_eff" .. iter_474_2]
				local var_474_9 = var_474_6["sk_add_con" .. iter_474_2]
				local var_474_10 = var_474_6["sk_add_con" .. iter_474_2 .. "_before"]
				
				if var_474_10 == "ALWAYS" and table.isInclude(var_474_1, var_474_7) and table.isInclude(var_474_2, var_474_8) and (var_474_9 ~= "ATTACK_HIT" or arg_474_1) then
					local var_474_11 = ""
					
					if arg_474_1 and var_474_9 ~= "ATTACK_HIT" then
						var_474_11 = "error"
					end
					
					print(string.format("%s - %s(%d) : Target(%s), EFF(%s) = %s -> %s", var_474_11, var_474_3, iter_474_2, var_474_7, var_474_8, var_474_10, var_474_9))
				end
			end
		end
	end
end

function var_0_3.addSkillHistory(arg_475_0, arg_475_1, arg_475_2, arg_475_3)
end

function var_0_3.getSkillHistoryInfo(arg_476_0, arg_476_1, arg_476_2)
	local var_476_0 = {}
	
	if arg_476_1 and arg_476_0.battle_info.skill_history[arg_476_1] then
		local var_476_1 = arg_476_1:getSkillBundle():slot(arg_476_2)
		
		if var_476_1:getSkillId() and arg_476_0.battle_info.skill_history[arg_476_1][var_476_1:getSkillId()] then
			var_476_0 = arg_476_0.battle_info.skill_history[arg_476_1][var_476_1:getSkillId()]
		end
	end
	
	return var_476_0
end

function var_0_3.getJoinUnitLog(arg_477_0, arg_477_1)
	local var_477_0 = {}
	local var_477_1 = arg_477_0:isPVP() or arg_477_0:isRealtimeMode()
	
	if not arg_477_1 then
		for iter_477_0, iter_477_1 in pairs(arg_477_0.starting_friends) do
			if not var_477_1 or iter_477_1:getLv() >= 60 then
				local var_477_2 = iter_477_1:makeUnitLog()
				
				if var_477_2 then
					table.insert(var_477_0, var_477_2)
				end
			end
		end
	else
		var_477_0 = {
			f = {},
			e = {}
		}
		
		for iter_477_2, iter_477_3 in pairs(arg_477_0.starting_friends) do
			if not var_477_1 or iter_477_3:getLv() >= 60 then
				local var_477_3 = iter_477_3:makeUnitLog()
				
				if var_477_3 then
					table.insert(var_477_0.f, var_477_3)
				end
			end
		end
		
		for iter_477_4, iter_477_5 in pairs(arg_477_0.latest_enemies) do
			if not var_477_1 or iter_477_5:getLv() >= 60 then
				local var_477_4 = iter_477_5:makeUnitLog()
				
				if var_477_4 then
					table.insert(var_477_0.e, var_477_4)
				end
			end
		end
	end
	
	if table.empty(var_477_0) then
		return 
	end
	
	return Base64.encode(json.encode(var_477_0))
end

function var_0_3.addZlongBattleData(arg_478_0, arg_478_1, arg_478_2)
	local function var_478_0(arg_479_0)
		local var_479_0 = 0
		
		for iter_479_0, iter_479_1 in pairs(arg_479_0 or {}) do
			var_479_0 = var_479_0 + iter_479_1:getPoint()
		end
		
		return var_479_0
	end
	
	local function var_478_1(arg_480_0, arg_480_1, arg_480_2, arg_480_3)
		for iter_480_0, iter_480_1 in pairs(arg_480_1 or {}) do
			local var_480_0 = iter_480_1:makeZlongUnitLog()
			
			if var_480_0 then
				table.insert(arg_480_0[arg_480_2], var_480_0)
			end
		end
		
		arg_480_0[arg_480_3] = var_478_0(arg_480_1)
	end
	
	if not (arg_478_0:isPVP() or arg_478_0:isRealtimeMode()) then
		return 
	end
	
	arg_478_0.zl_battle_log = arg_478_0.zl_battle_log or {
		ep = 0,
		fp = 0,
		f = {},
		e = {}
	}
	
	if arg_478_1 == FRIEND then
		var_478_1(arg_478_0.zl_battle_log, arg_478_2, "f", "fp")
	else
		var_478_1(arg_478_0.zl_battle_log, arg_478_2, "e", "ep")
	end
end

function var_0_3.getZlongBattleData(arg_481_0, arg_481_1)
	local function var_481_0(arg_482_0, arg_482_1, arg_482_2, arg_482_3, arg_482_4)
		if not arg_482_1 then
			return 
		end
		
		local var_482_0 = arg_482_1.preban_units[arg_482_2]
		local var_482_1 = arg_482_1.ban_units[arg_482_2]
		
		if var_482_0 and var_482_0[1] then
			arg_482_0[arg_482_3] = var_482_0[1].code
		end
		
		if var_482_1 and var_482_1[1] then
			arg_482_0[arg_482_4] = var_482_1[1].code
		end
	end
	
	if not (arg_481_0:isPVP() or arg_481_0:isRealtimeMode()) then
		return 
	end
	
	local var_481_1
	local var_481_2
	
	for iter_481_0, iter_481_1 in pairs(arg_481_0.starting_friends) do
		var_481_1 = iter_481_1:getArenaUID()
	end
	
	for iter_481_2, iter_481_3 in pairs(arg_481_0.latest_enemies) do
		var_481_2 = iter_481_3:getArenaUID()
	end
	
	arg_481_0.zl_battle_log = arg_481_0.zl_battle_log or {
		ep = 0,
		fp = 0,
		f = {},
		e = {}
	}
	
	var_481_0(arg_481_0.zl_battle_log, arg_481_1, var_481_1, "fpre", "fban")
	var_481_0(arg_481_0.zl_battle_log, arg_481_1, var_481_2, "epre", "eban")
	
	return Base64.encode(json.encode(arg_481_0.zl_battle_log))
end

DRAFT_DB_NAME = "pvp_rta_draft_character"
DRAFT_DB_STAT = "pvp_rta_draft_character_stat"
DRAFT_DB_STAGE = "pvp_rta_draft_tier"
DRAFT_SELECT_COUNT = 6

function var_0_3.makeDraftPool(arg_483_0, arg_483_1, arg_483_2, arg_483_3, arg_483_4)
	local var_483_0 = {}
	local var_483_1 = {}
	local var_483_2 = {}
	
	local function var_483_3(arg_484_0, arg_484_1, arg_484_2, arg_484_3)
		local var_484_0 = {}
		local var_484_1 = {}
		local var_484_2
		local var_484_3 = 100
		local var_484_4 = getRandom(os.time() + arg_484_1 * 100)
		
		for iter_484_0 = 1, var_484_3 do
			local var_484_5 = {}
			local var_484_6 = 0
			
			var_484_2 = iter_484_0
			var_484_1 = {}
			
			for iter_484_1 = 1, arg_484_0 do
				local var_484_7 = var_484_4:get(arg_484_2, arg_484_3)
				
				for iter_484_2 = 1, 10 do
					if #var_483_0[var_484_7] > 0 then
						break
					end
					
					var_484_7 = var_484_4:get(arg_484_2, arg_484_3)
				end
				
				var_484_1[var_484_7] = var_484_1[var_484_7] or {}
				
				local var_484_8 = var_484_4:get(1, #var_483_0[var_484_7])
				local var_484_9 = var_483_0[var_484_7][var_484_8]
				
				if var_484_9 and not table.find(var_484_1[var_484_7], var_484_8) then
					var_484_6 = var_484_6 + var_484_9.draft_rate
					
					table.insert(var_484_1[var_484_7], var_484_8)
					table.insert(var_484_5, var_484_9)
				end
			end
			
			var_484_0[arg_483_1] = {}
			var_484_0[arg_483_2] = {}
			
			if table.count(var_484_5) == arg_484_0 then
				if var_484_6 >= 17 then
					local var_484_10 = var_484_4:get(1, 100)
					
					for iter_484_3 = 1, arg_484_0 do
						local var_484_11 = (var_484_10 + iter_484_3) % 2 == 1 and arg_483_1 or arg_483_2
						
						table.insert(var_484_0[var_484_11], var_484_5[iter_484_3])
					end
					
					break
				else
					local var_484_12 = {
						[arg_483_1] = 0,
						[arg_483_2] = 0
					}
					
					table.sort(var_484_5, function(arg_485_0, arg_485_1)
						return arg_485_0.draft_rate > arg_485_1.draft_rate
					end)
					
					local var_484_13 = var_484_4:get(1, 100)
					
					for iter_484_4 = 1, arg_484_0 do
						local var_484_14 = (var_484_13 + iter_484_4) % 2 == 1 and arg_483_1 or arg_483_2
						
						var_484_12[var_484_14] = var_484_12[var_484_14] + var_484_5[iter_484_4].draft_rate
						
						table.insert(var_484_0[var_484_14], var_484_5[iter_484_4])
					end
					
					if math.abs(var_484_12[arg_483_1] - var_484_12[arg_483_2]) <= 2 then
						break
					end
				end
			end
		end
		
		if arg_483_4 then
			for iter_484_5, iter_484_6 in pairs(var_484_0) do
				for iter_484_7, iter_484_8 in pairs(iter_484_6 or {}) do
					if iter_484_8.uid == arg_483_4 then
						Log.e("find unit", arg_484_1, arg_483_4)
					end
				end
			end
		end
		
		return var_484_2 < var_484_3, var_484_0, var_484_1
	end
	
	for iter_483_0 = 1, 99999 do
		local var_483_4, var_483_5, var_483_6, var_483_7, var_483_8, var_483_9, var_483_10, var_483_11, var_483_12 = DBN(DRAFT_DB_NAME, tostring(iter_483_0), {
			"id",
			"character_id",
			"stat_id",
			"set_op_id",
			"arti_id",
			"exc_id",
			"tier",
			"draft_rate",
			"memory"
		})
		
		if not var_483_4 then
			break
		end
		
		var_483_0[var_483_10] = var_483_0[var_483_10] or {}
		
		local var_483_13 = {
			uid = var_483_4,
			tier = var_483_10,
			draft_rate = var_483_11,
			code = var_483_5,
			stat_id = var_483_6,
			set_op_id = var_483_7,
			arti_id = var_483_8,
			exc_id = var_483_9,
			memory = var_483_12
		}
		
		table.insert(var_483_0[var_483_10], var_483_13)
	end
	
	for iter_483_1 = 1, 99 do
		local var_483_14, var_483_15, var_483_16 = DBN(DRAFT_DB_STAGE, tostring(iter_483_1), {
			"id",
			"draft_tier_min",
			"draft_tier_max"
		})
		
		if not var_483_14 then
			break
		end
		
		table.insert(var_483_1, {
			var_483_15,
			var_483_16
		})
	end
	
	for iter_483_2, iter_483_3 in pairs(var_483_1 or {}) do
		local var_483_17, var_483_18, var_483_19 = var_483_3(DRAFT_SELECT_COUNT, iter_483_2, iter_483_3[1], iter_483_3[2])
		
		if var_483_17 then
			var_483_2[iter_483_2] = var_483_18
			
			for iter_483_4, iter_483_5 in pairs(var_483_19 or {}) do
				table.sort(iter_483_5, function(arg_486_0, arg_486_1)
					return arg_486_1 < arg_486_0
				end)
				
				for iter_483_6 = 1, table.count(iter_483_5) do
					table.remove(var_483_0[iter_483_4], iter_483_5[iter_483_6])
				end
			end
		else
			Log.e("draft pool create fail !!!!!!!", iter_483_2)
		end
	end
	
	if arg_483_3 then
		for iter_483_7, iter_483_8 in pairs(var_483_2 or {}) do
			for iter_483_9, iter_483_10 in pairs(iter_483_8 or {}) do
				local var_483_20 = UNIT:create({
					code = iter_483_10[1].code
				})
				local var_483_21 = UNIT:create({
					code = iter_483_10[2].code
				})
				local var_483_22 = UNIT:create({
					code = iter_483_10[3].code
				})
				
				Log.e("draft unit info", iter_483_7, iter_483_9, var_483_20:getName(), var_483_21:getName(), var_483_22:getName())
			end
		end
	end
	
	return var_483_2
end

function var_0_3.make_template_team(arg_487_0, arg_487_1, arg_487_2)
	local var_487_0 = {
		units = {}
	}
	
	for iter_487_0, iter_487_1 in pairs(arg_487_1) do
		local var_487_1 = DBT("ai_simulation", tostring(iter_487_1), {
			"character_id",
			"stat_id",
			"set_op_id",
			"arti_id",
			"exc_id",
			"awake_type"
		})
		local var_487_2 = DBT("ref_stat_id", var_487_1.stat_id, {
			"att",
			"max_hp",
			"def",
			"speed",
			"att_rate",
			"max_hp_rate",
			"def_rate",
			"cri",
			"cri_dmg",
			"acc",
			"res"
		})
		local var_487_3 = var_487_1.character_id
		local var_487_4 = make_template_unit(iter_487_0 + (arg_487_2 - 1), iter_487_1, var_487_3)
		local var_487_5 = {
			set_op_id = string.split(var_487_1.set_op_id, ","),
			arti_id = var_487_1.arti_id,
			exc_id = var_487_1.exc_id,
			status = {},
			rate = {}
		}
		
		for iter_487_2, iter_487_3 in pairs(var_487_2) do
			if string.sub(iter_487_2, -5, -1) == "_rate" then
				var_487_5.rate[iter_487_2] = iter_487_3
			else
				var_487_5.status[iter_487_2] = iter_487_3
			end
		end
		
		var_487_4.awake = var_487_1.awake_type == "Y" and 6 or nil
		
		local var_487_6 = UNIT:create({
			code = var_487_3
		})
		
		var_487_4.s[1] = var_487_6:getMaxSkillLevelByIndex(1)
		var_487_4.s[2] = var_487_6:getMaxSkillLevelByIndex(2)
		var_487_4.s[3] = var_487_6:getMaxSkillLevelByIndex(3)
		var_487_0.units[iter_487_0] = {}
		var_487_0.units[iter_487_0].unit = var_487_4
		var_487_0.units[iter_487_0].pos = iter_487_0
		var_487_0.units[iter_487_0].template_status = var_487_5
	end
	
	return var_487_0
end

function var_0_3.make_draft_team(arg_488_0, arg_488_1, arg_488_2)
	local var_488_0 = {
		units = {}
	}
	
	for iter_488_0, iter_488_1 in pairs(arg_488_1) do
		local var_488_1 = DBT(DRAFT_DB_NAME, tostring(iter_488_1), {
			"character_id",
			"stat_id",
			"set_op_id",
			"arti_id",
			"exc_id",
			"memory"
		})
		local var_488_2 = DBT(DRAFT_DB_STAT, var_488_1.stat_id, {
			"att",
			"max_hp",
			"def",
			"speed",
			"att_rate",
			"max_hp_rate",
			"def_rate",
			"cri",
			"cri_dmg",
			"acc",
			"res"
		})
		local var_488_3 = var_488_1.character_id
		local var_488_4 = make_template_unit(iter_488_0 + (arg_488_2 - 1), iter_488_1, var_488_3)
		local var_488_5 = {
			set_op_id = string.split(var_488_1.set_op_id, ","),
			arti_id = var_488_1.arti_id,
			exc_id = var_488_1.exc_id,
			status = {},
			rate = {}
		}
		
		for iter_488_2, iter_488_3 in pairs(var_488_2) do
			if string.sub(iter_488_2, -5, -1) == "_rate" then
				var_488_5.rate[iter_488_2] = iter_488_3
			else
				var_488_5.status[iter_488_2] = iter_488_3
			end
		end
		
		local var_488_6 = UNIT:create({
			code = var_488_3
		})
		
		var_488_4.s[1] = var_488_6:getMaxSkillLevelByIndex(1)
		var_488_4.s[2] = var_488_6:getMaxSkillLevelByIndex(2)
		var_488_4.s[3] = var_488_6:getMaxSkillLevelByIndex(3)
		var_488_0.units[iter_488_0] = {}
		var_488_0.units[iter_488_0].unit = var_488_4
		var_488_0.units[iter_488_0].pos = iter_488_0
		var_488_0.units[iter_488_0].template_status = var_488_5
		
		if var_488_1.memory then
			if var_488_1.memory == 1 then
				var_488_0.units[iter_488_0].unit.opt = 11
			elseif var_488_1.memory == 2 then
				var_488_0.units[iter_488_0].unit.opt = 22
			end
		end
	end
	
	return var_488_0
end

VERIFY_TURN_TEST = false

function var_0_3.verifyAll(arg_489_0, arg_489_1)
	arg_489_1 = arg_489_1 or {}
	
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local var_489_0 = {
		is_verify = true,
		use_one_hit = arg_489_1.use_one_hit
	}
	local var_489_1 = table.clone(arg_489_0.map)
	local var_489_2 = table.clone(arg_489_0.team_data)
	local var_489_3 = arg_489_1.command_data or table.clone(arg_489_0.battle_info.replay_data)
	
	arg_489_0.verify_logic = BattleLogic:makeLogic(var_489_1, var_489_2, var_489_0)
	
	local var_489_4 = {
		limit_turn = 9999,
		check_seed = true,
		over_turn = 9999,
		check_info = true
	}
	local var_489_5 = {}
	
	var_489_5.success, var_489_5.reason, var_489_5.info = arg_489_0.verify_logic:verify(var_489_3, var_489_4)
	
	if arg_489_1.detail then
		Log.e("verfiy entire result detail info", table.print(var_489_5))
	else
		Log.e("verfiy entire result summer info", var_489_5.success, table.print(var_489_5.reason))
	end
	
	return var_489_5
end

function var_0_3.verifyTurn(arg_490_0)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	if not VERIFY_TURN_TEST then
		return 
	end
	
	local var_490_0 = {
		limit_turn = 9999,
		check_seed = true,
		over_turn = 9999,
		check_info = true
	}
	
	if not arg_490_0.verify_logic then
		local var_490_1 = table.clone(arg_490_0.init_data)
		local var_490_2 = table.clone(arg_490_0.map)
		local var_490_3 = table.clone(arg_490_0.team_data)
		local var_490_4 = table.clone(arg_490_0.battle_info.replay_data)
		
		var_490_1.is_verify = true
		arg_490_0.verify_logic = BattleLogic:makeLogic(var_490_2, var_490_3, var_490_1)
		arg_490_0.verify_logic.owner = arg_490_0
		arg_490_0.verify_logic.verify_proc_count = #arg_490_0.battle_info.replay_data
		
		arg_490_0.verify_logic:verifyTurn(var_490_4, var_490_0)
		
		return 
	end
	
	local var_490_5 = arg_490_0.verify_logic.verify_proc_count + 1
	local var_490_6 = #arg_490_0.battle_info.replay_data
	
	for iter_490_0 = var_490_5, var_490_6 do
		local var_490_7 = table.clone(arg_490_0.battle_info.replay_data[iter_490_0])
		
		arg_490_0.verify_logic.verify_proc_count = arg_490_0.verify_logic.verify_proc_count + 1
		
		local var_490_8 = {}
		
		var_490_8.success, var_490_8.reason, var_490_8.info = arg_490_0.verify_logic:verifyTurn({
			var_490_7
		}, var_490_0)
		
		Log.e("verfiy turn result info", table.print(var_490_8))
	end
end

function var_0_3.serialTest(arg_491_0)
	local var_491_0 = {
		seed = arg_491_0.seed,
		stage_counter = arg_491_0.stage_counter,
		encounter_enemy_count = arg_491_0.encounter_enemy_count,
		random = arg_491_0.random:encode(),
		turn_info = table.filter_pure_value2(arg_491_0.turn_info),
		team_data = table.filter_pure_value2(arg_491_0.team_data),
		friends = {},
		enemies = {},
		units = {}
	}
	
	Log.e("xxxx", table.print(var_491_0))
	
	return var_491_0
end

function var_0_3.deserialTest(arg_492_0, arg_492_1)
	arg_492_0.turn_info = table.assign_pure_value2(arg_492_0.turn_info, arg_492_1.turn_info)
end

function logic_print()
	table.print(Battle.logic.stageMap.parsed_opts.lock_door)
	
	local var_493_0 = Battle.logic:getRoadEventObjectList()
	
	for iter_493_0, iter_493_1 in pairs(var_493_0) do
		if iter_493_1.value.npc then
			print("road_event_object.value.npc")
			table.print(iter_493_1.value.npc)
		end
	end
end

local function var_0_15()
	local var_494_0 = {}
	
	for iter_494_0, iter_494_1 in pairs(var_0_3) do
		if type(iter_494_1) == "function" and string.format("%p", iter_494_1) ~= string.format("%p", BattleLogic[iter_494_0]) then
			table.insert(var_494_0, iter_494_0)
		end
	end
	
	return var_494_0
end

BattleLogic = {}

copy_functions(var_0_3, BattleLogic)

Slapstick = Slapstick or {}

function Slapstick.tragedy(arg_495_0)
	return var_0_15()
end
