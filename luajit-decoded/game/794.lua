RumbleSynergy = {}

local var_0_0 = {
	ALL = 1,
	HIGHEST_ATK = 2
}

function RumbleSynergy.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.synergy_tbl = {}
	arg_1_0.db = {}
	
	for iter_1_0 = 1, 999 do
		local var_1_0, var_1_1 = DBN("rumble_synergy", iter_1_0, {
			"id",
			"target"
		})
		
		if not var_1_0 then
			break
		end
		
		local var_1_2 = {}
		
		for iter_1_1 = 1, 4 do
			local var_1_3, var_1_4 = DBN("rumble_synergy", iter_1_0, {
				"cs_id_" .. iter_1_1,
				"need_" .. iter_1_1
			})
			
			if not var_1_3 then
				break
			end
			
			table.insert(var_1_2, {
				id = var_1_0,
				cs = var_1_3,
				cnt = var_1_4,
				target = var_0_0[var_1_1]
			})
		end
		
		arg_1_0.db[var_1_0] = var_1_2
	end
end

function RumbleSynergy.unload(arg_2_0)
	arg_2_0.vars = nil
	arg_2_0.db = nil
end

function RumbleSynergy.update(arg_3_0, arg_3_1)
	if not arg_3_0.vars then
		return 
	end
	
	local var_3_0 = RumbleBoard:getUnits({
		team = arg_3_1 and 2 or 1
	}) or {}
	local var_3_1 = {}
	
	local function var_3_2(arg_4_0)
		if not arg_4_0 then
			return 
		end
		
		if not var_3_1[arg_4_0] then
			var_3_1[arg_4_0] = 1
		else
			var_3_1[arg_4_0] = var_3_1[arg_4_0] + 1
		end
	end
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		var_3_2(iter_3_1:getCamp())
		var_3_2(iter_3_1:getRole())
		iter_3_1:resetBuff()
	end
	
	arg_3_0.vars.synergy_tbl = var_3_1
	
	arg_3_0:applySynergyEffect(arg_3_1)
	
	for iter_3_2, iter_3_3 in pairs(var_3_0) do
		iter_3_3:updateStat()
	end
end

function RumbleSynergy.getCurrentSynergy(arg_5_0)
	return arg_5_0.vars and arg_5_0.vars.synergy_tbl
end

function RumbleSynergy.getSynergyIcon(arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = DB("rumble_synergy", arg_6_1, {
		"icon",
		"type"
	})
	
	if not var_6_0 then
		return 
	end
	
	if var_6_1 == "role" then
		return "img/" .. var_6_0 .. "_b.png"
	else
		return "img/" .. var_6_0 .. ".png"
	end
end

function RumbleSynergy.getSynergyName(arg_7_0, arg_7_1)
	return DB("rumble_synergy", arg_7_1, "name")
end

function RumbleSynergy.getSynergyEffect(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	if not arg_8_0.db[arg_8_1] then
		return 
	end
	
	local var_8_0 = arg_8_0:getSynergyLevel(arg_8_1)
	
	return arg_8_0.db[arg_8_1][var_8_0]
end

function RumbleSynergy.getSynergyLevel(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return 0
	end
	
	if not arg_9_0.db[arg_9_1] then
		return 0
	end
	
	local var_9_0 = arg_9_0.vars.synergy_tbl[arg_9_1] or 0
	
	for iter_9_0, iter_9_1 in ipairs(arg_9_0.db[arg_9_1] or {}) do
		if var_9_0 < iter_9_1.cnt then
			return iter_9_0 - 1
		end
	end
	
	return #arg_9_0.db[arg_9_1]
end

function RumbleSynergy.getSynergyMaxLevel(arg_10_0, arg_10_1)
	return #arg_10_0.db[arg_10_1]
end

function RumbleSynergy.getSynergyCount(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 0
	end
	
	return arg_11_0.vars.synergy_tbl and arg_11_0.vars.synergy_tbl[arg_11_1] or 0
end

function RumbleSynergy.getSynergyMaxCount(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:getSynergyMaxLevel(arg_12_1)
	
	if var_12_0 == 0 then
		return 0
	end
	
	return arg_12_0.db[arg_12_1] and arg_12_0.db[arg_12_1][var_12_0].cnt or 0
end

function RumbleSynergy.applySynergyEffect(arg_13_0, arg_13_1)
	if not arg_13_0.vars then
		return 
	end
	
	local var_13_0 = arg_13_0:getCurrentSynergy() or {}
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_1 = arg_13_0:getSynergyEffect(iter_13_0)
		
		if var_13_1 then
			local var_13_2 = arg_13_0:getTargets(var_13_1, arg_13_1) or {}
			
			for iter_13_2, iter_13_3 in ipairs(var_13_2) do
				if var_13_1.cs then
					iter_13_3:addBuff(var_13_1.cs)
				end
			end
		end
	end
end

function RumbleSynergy.applySynergyToUnit(arg_14_0, arg_14_1)
	if not arg_14_0.vars then
		return 
	end
	
	if not arg_14_1 then
		return 
	end
	
	local function var_14_0(arg_15_0)
		local var_15_0 = arg_14_0:getSynergyEffect(arg_15_0)
		
		if var_15_0 then
			local var_15_1 = arg_14_0:getTargets(var_15_0, arg_14_1:isEnemy()) or {}
			
			for iter_15_0, iter_15_1 in ipairs(var_15_1) do
				if iter_15_1 == arg_14_1 and var_15_0.cs then
					arg_14_1:addBuff(var_15_0.cs)
				end
			end
		end
	end
	
	var_14_0(arg_14_1:getRole())
	var_14_0(arg_14_1:getCamp())
end

function RumbleSynergy.getTargets(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = RumbleBoard:getUnits({
		team = arg_16_2 and 2 or 1,
		synergy = arg_16_1.id
	})
	
	if not var_16_0 then
		return 
	end
	
	if arg_16_1.target == var_0_0.HIGHEST_ATK then
		table.sort(var_16_0, function(arg_17_0, arg_17_1)
			return arg_17_0:getStatAttack() > arg_17_1:getStatAttack()
		end)
		
		return {
			var_16_0[1]
		}
	end
	
	return var_16_0
end
