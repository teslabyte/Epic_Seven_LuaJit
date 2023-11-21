RumbleStat = {}

function RumbleStat.init(arg_1_0)
	arg_1_0.statistics = {}
end

function RumbleStat.reset(arg_2_0)
	if not arg_2_0.statistics then
		return 
	end
	
	arg_2_0.statistics.round = RumbleSystem:getStage()
	arg_2_0.statistics.atk = {}
	arg_2_0.statistics.def = {}
	
	RumbleUI:resetStatNode()
end

function RumbleStat.addData(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if not arg_3_0.statistics then
		return 
	end
	
	if not arg_3_1 or arg_3_1:isEnemy() or arg_3_1:isCreature() then
		return 
	end
	
	local var_3_0 = arg_3_0.statistics[arg_3_2]
	local var_3_1 = arg_3_1:getUID()
	
	local function var_3_2(arg_4_0)
		local var_4_0 = var_3_0[arg_4_0]
		local var_4_1 = arg_4_0 - 1
		
		while var_4_1 > 0 and var_3_0[var_4_1].value < var_4_0.value do
			var_3_0[var_4_1 + 1] = var_3_0[var_4_1]
			var_4_1 = var_4_1 - 1
		end
		
		var_3_0[var_4_1 + 1] = var_4_0
	end
	
	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		if iter_3_1.uid == var_3_1 then
			iter_3_1.value = iter_3_1.value + arg_3_3
			
			var_3_2(iter_3_0)
			RumbleUI:updateStatistics()
			
			return 
		end
	end
	
	table.insert(var_3_0, {
		uid = var_3_1,
		unit = arg_3_1,
		value = arg_3_3
	})
	var_3_2(#var_3_0)
	RumbleUI:updateStatistics()
end

function RumbleStat.onHit(arg_5_0, arg_5_1)
	if not arg_5_0.statistics then
		return 
	end
	
	if not arg_5_1 then
		return 
	end
	
	arg_5_0:addData(arg_5_1.caster, "atk", arg_5_1.damage)
end

function RumbleStat.getStatistics(arg_6_0, arg_6_1)
	if not arg_6_0.statistics then
		return 
	end
	
	return arg_6_0.statistics[arg_6_1]
end
