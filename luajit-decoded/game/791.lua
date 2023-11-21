RumblePlayer = {}

function RumblePlayer.init(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.team = arg_1_1.team or {}
	arg_1_0.vars.team_max = RumbleSystem:getConfig("rumble_battlefield")
	arg_1_0.vars.bench = arg_1_1.bench or {}
	arg_1_0.vars.bench_max = RumbleSystem:getConfig("rumble_waitingroom_limit")
	arg_1_0.vars.gold = RumbleSystem:getConfig("rumble_start_gold")
	arg_1_0.vars.life = RumbleSystem:getConfig("rumble_start_life")
end

function RumblePlayer.addToTeam(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.vars then
		return 
	end
	
	if #arg_2_0.vars.team >= arg_2_0.vars.team_max then
	end
	
	if arg_2_0:removeFromBench(arg_2_1) then
		table.insert(arg_2_0.vars.team, arg_2_1)
		RumbleBoard:addUnit(arg_2_1, arg_2_2)
		RumbleSynergy:update()
		RumbleUI:update()
	end
end

function RumblePlayer.removeFromTeam(arg_3_0, arg_3_1)
	if not arg_3_0.vars then
		return 
	end
	
	for iter_3_0, iter_3_1 in ipairs(arg_3_0.vars.team) do
		if iter_3_1 == arg_3_1 then
			table.remove(arg_3_0.vars.team, iter_3_0)
			RumbleBoard:removeUnit(arg_3_1)
			RumbleSynergy:update()
			RumbleUI:update()
			arg_3_1:updateStat()
			
			return true
		end
	end
end

function RumblePlayer.addToBench(arg_4_0, arg_4_1)
	if not arg_4_0.vars then
		return 
	end
	
	if #arg_4_0.vars.bench >= arg_4_0.vars.bench_max then
	end
	
	table.insert(arg_4_0.vars.bench, arg_4_1)
	RumbleBench:revertUnit(arg_4_1)
end

function RumblePlayer.removeFromBench(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	for iter_5_0, iter_5_1 in ipairs(arg_5_0.vars.bench) do
		if iter_5_1 == arg_5_1 then
			table.remove(arg_5_0.vars.bench, iter_5_0)
			RumbleBench:removeUnit(arg_5_1)
			
			return true
		end
	end
end

function RumblePlayer.revertToBench(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	if arg_6_0:removeFromTeam(arg_6_1) then
		arg_6_0:addToBench(arg_6_1)
	end
end

function RumblePlayer.isBenchFull(arg_7_0)
	if not arg_7_0.vars then
		return true
	end
	
	return #arg_7_0.vars.bench >= arg_7_0.vars.bench_max
end

function RumblePlayer.isFieldFull(arg_8_0)
	if not arg_8_0.vars then
		return true
	end
	
	return #arg_8_0.vars.team >= arg_8_0.vars.team_max
end

function RumblePlayer.onSummonUnit(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return 
	end
	
	if not arg_9_1 then
		return 
	end
	
	local var_9_0 = false
	local var_9_1 = arg_9_0:getUnit(arg_9_1)
	
	if not var_9_1 then
		var_9_1 = RumbleUnit(arg_9_1)
		
		table.insert(arg_9_0.vars.bench, var_9_1)
	elseif not var_9_1:isMaxDevoteLevel() then
		var_9_1:addDevote()
	else
		arg_9_0:addGold(var_9_1:getSellPrice(0))
		
		var_9_0 = true
	end
	
	if arg_9_0:getBenchUnit(arg_9_1) then
		RumbleBench:onSummonUnit(var_9_1)
	end
	
	if not var_9_0 then
		RumbleUI:updateToken({
			no_sound = true
		})
	end
	
	RumbleSynergy:update()
	RumbleUI:update()
	RumbleSummon:showGachaResult(var_9_1, {
		layer = RumbleSystem:getUILayer(),
		auto_sell = var_9_0
	})
end

function RumblePlayer.sellUnit(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	if arg_10_1:isActive() then
		arg_10_0:removeFromTeam(arg_10_1)
	else
		arg_10_0:removeFromBench(arg_10_1)
	end
	
	arg_10_0:addGold(arg_10_1:getSellPrice())
	RumbleUI:update()
end

function RumblePlayer.getTeamUnits(arg_11_0)
	return arg_11_0.vars and arg_11_0.vars.team
end

function RumblePlayer.getTeamMax(arg_12_0)
	return to_n(arg_12_0.vars and arg_12_0.vars.team_max)
end

function RumblePlayer.getBenchUnits(arg_13_0)
	return arg_13_0.vars and arg_13_0.vars.bench
end

function RumblePlayer.getBenchMax(arg_14_0)
	return to_n(arg_14_0.vars and arg_14_0.vars.bench_max)
end

function RumblePlayer.getTeamUnit(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	for iter_15_0, iter_15_1 in ipairs(arg_15_0.vars.team) do
		if iter_15_1:getCode() == arg_15_1 then
			return iter_15_1
		end
	end
end

function RumblePlayer.getBenchUnit(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	for iter_16_0, iter_16_1 in ipairs(arg_16_0.vars.bench) do
		if iter_16_1:getCode() == arg_16_1 then
			return iter_16_1
		end
	end
end

function RumblePlayer.getUnit(arg_17_0, arg_17_1)
	return arg_17_0:getTeamUnit(arg_17_1) or arg_17_0:getBenchUnit(arg_17_1)
end

function RumblePlayer.getGold(arg_18_0)
	return arg_18_0.vars and arg_18_0.vars.gold or 0
end

function RumblePlayer.addGold(arg_19_0, arg_19_1)
	if not arg_19_0.vars then
		return 
	end
	
	arg_19_0.vars.gold = to_n(arg_19_0.vars.gold) + to_n(arg_19_1)
end

function RumblePlayer.getLife(arg_20_0)
	return arg_20_0.vars and arg_20_0.vars.life or 0
end

function RumblePlayer.addLife(arg_21_0, arg_21_1)
	if not arg_21_0.vars then
		return 
	end
	
	arg_21_0.vars.life = to_n(arg_21_0.vars.life) + to_n(arg_21_1)
	
	RumbleUI:updateLife()
end

function RumblePlayer.getSlotCost(arg_22_0)
	local var_22_0 = RumbleSystem:getConfig("rumble_battlefield") or 0
	local var_22_1 = RumbleSystem:getConfig("rumble_battlefield_add_value") or 1
	local var_22_2 = 1 + (arg_22_0:getTeamMax() - var_22_0) / var_22_1
	
	return RumbleSystem:getConfig("rumble_battlefield_add_price" .. var_22_2) or 9999
end

function RumblePlayer.addSlot(arg_23_0)
	local var_23_0 = RumbleSystem:getConfig("rumble_battlefield_add_value") or 1
	
	arg_23_0.vars.team_max = to_n(arg_23_0.vars.team_max) + var_23_0
end
