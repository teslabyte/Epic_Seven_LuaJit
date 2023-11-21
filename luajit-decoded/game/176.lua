ViewBase = ClassDef()

function ViewBase.constructor(arg_1_0)
	arg_1_0.finished = false
end

function ViewBase.Enter(arg_2_0)
end

function ViewBase.Update(arg_3_0)
end

function ViewBase.Leave(arg_4_0)
end

ViewHandle = ClassDef(ViewBase)

function ViewHandle.constructor(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0._ID = arg_5_3
	arg_5_0._STATE = "HANDLE"
	arg_5_0._CHILDS = {}
	arg_5_0.viewer = arg_5_1
	arg_5_0.owner = arg_5_2
	arg_5_0.snap_data = {}
	arg_5_0.executed = {}
end

function ViewHandle.setSnapData(arg_6_0, arg_6_1)
	arg_6_0.snap_data[arg_6_1._id] = arg_6_1
end

function ViewHandle.getSnapData(arg_7_0, arg_7_1)
	return arg_7_0.snap_data[arg_7_1._id]
end

function ViewHandle.getRoot(arg_8_0)
	return arg_8_0._CHILDS[1]
end

function ViewHandle.Update(arg_9_0)
	local var_9_0 = {}
	
	for iter_9_0, iter_9_1 in ipairs(arg_9_0._execute_action_list) do
		iter_9_1:Update(arg_9_0)
		
		if iter_9_1.isFinished and iter_9_1:isFinished() then
			table.insert(var_9_0, 1, iter_9_0)
		end
	end
	
	for iter_9_2, iter_9_3 in ipairs(var_9_0) do
		local var_9_1 = arg_9_0._execute_action_list[iter_9_3]
		
		table.remove(arg_9_0._execute_action_list, iter_9_3)
		var_9_1:Leave()
	end
end

function ViewHandle.Leave(arg_10_0)
end

function ViewHandle.executeAction(arg_11_0, arg_11_1)
	if arg_11_0.executed[arg_11_1] then
		return 
	end
	
	arg_11_0.executed[arg_11_1] = true
	arg_11_0._execute_action_list = arg_11_0._execute_action_list or {}
	
	if arg_11_1.Enter then
		arg_11_1:Enter(arg_11_0)
		table.insert(arg_11_0._execute_action_list, arg_11_1)
	else
		arg_11_0.viewer:applySnapData(arg_11_0:getSnapData(arg_11_1))
		arg_11_0.viewer:addInfo(arg_11_1)
	end
end

function ViewHandle.addChild(arg_12_0, arg_12_1)
	table.insert(arg_12_0._CHILDS, arg_12_1)
end

function ViewHandle.IsFinished(arg_13_0)
	return #arg_13_0._execute_action_list <= 0
end

ViewState = ClassDef(ViewBase)

function ViewState.constructor(arg_14_0, arg_14_1)
	arg_14_0._STATE = arg_14_1 or "STATE"
	arg_14_0._CHILDS = {}
end

function ViewState.Enter(arg_15_0, arg_15_1)
	for iter_15_0 = 1, #arg_15_0._CHILDS do
		local var_15_0 = arg_15_0._CHILDS[iter_15_0]
		
		arg_15_1:executeAction(var_15_0)
	end
end

function ViewState.Update(arg_16_0)
	arg_16_0.finished = true
end

function ViewState.isFinished(arg_17_0)
	for iter_17_0 = 1, #arg_17_0._CHILDS do
		if arg_17_0._CHILDS[iter_17_0].isFinished and not arg_17_0._CHILDS[iter_17_0]:isFinished() then
			return false
		end
	end
	
	if Battle:isPlayingBattleAction() then
		return false
	end
	
	return arg_17_0.finished
end

function ViewState.addChild(arg_18_0, arg_18_1)
	table.insert(arg_18_0._CHILDS, arg_18_1)
end

ViewAction = ClassDef(ViewBase)

function ViewAction.constructor(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._STATE = arg_19_1 or "ACTION"
end

function ViewAction.Enter(arg_20_0, arg_20_1)
	if arg_20_0.onEnter then
		arg_20_0:onEnter(arg_20_1)
	end
end

function ViewAction.Update(arg_21_0)
	arg_21_0.finished = true
end

function ViewAction.isFinished(arg_22_0)
	return arg_22_0.finished
end

ViewDef = {}
ViewDef.STATE = {}
ViewDef.STATE.ACTION = ClassDef(ViewState)
ViewDef.ROOT = {}
ViewDef.ROOT.ACTION = ClassDef(ViewState)

function ViewDef.ROOT.ACTION.Enter(arg_23_0, arg_23_1)
	arg_23_0.cur = 1
	
	local var_23_0 = false
	local var_23_1 = -1
	
	for iter_23_0 = #arg_23_0._CHILDS, 1, -1 do
		local var_23_2 = arg_23_0._CHILDS[iter_23_0] or {}
		local var_23_3 = var_23_2._STATE or ""
		
		if var_23_3 == "ATTACK" then
			if var_23_1 < iter_23_0 then
				var_23_1 = iter_23_0
			end
		elseif var_23_3 == "READY" then
			for iter_23_1, iter_23_2 in pairs(var_23_2._CHILDS) do
				if iter_23_2.type == "@ready_attack" and not iter_23_2.is_provoker then
					var_23_0 = true
					
					break
				end
			end
		end
	end
	
	if var_23_0 and var_23_1 ~= -1 then
		arg_23_0._CHILDS[var_23_1].send_ready = true
	end
end

function ViewDef.ROOT.ACTION.Update(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._CHILDS[arg_24_0.cur]
	
	if not var_24_0 then
		return 
	end
	
	arg_24_1:executeAction(var_24_0)
	
	if var_24_0:isFinished() then
		arg_24_0.cur = arg_24_0.cur + 1
	end
end

function ViewDef.ROOT.ACTION.isFinished(arg_25_0)
	return arg_25_0.cur > #arg_25_0._CHILDS
end

ViewDef.START_TURN = {}
ViewDef.START_TURN.ACTION = ClassDef(ViewState)
ViewDef.READY = {}
ViewDef.READY.ACTION = ClassDef(ViewState)
ViewDef.END_TURN = {}
ViewDef.END_TURN.ACTION = ClassDef(ViewState)
ViewDef.NEXT_TURN = {}
ViewDef.NEXT_TURN.ACTION = ClassDef(ViewState)
ViewDef.SKILL_START = {}
ViewDef.SKILL_START.ACTION = ClassDef(ViewState)
ViewDef.ATTACK = {}
ViewDef.ATTACK.ACTION = ClassDef(ViewState)

function ViewDef.ATTACK.ACTION.Enter(arg_26_0, arg_26_1)
	Log.i("ATTACK")
	
	arg_26_0.handle = arg_26_1
	arg_26_0.skills = {}
	arg_26_0.hits = {}
	arg_26_0.hit_map = {}
	arg_26_0.cur_hit = 1
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0._CHILDS) do
		if iter_26_1._STATE == "SKILL_START" then
			table.insert(arg_26_0.skills, iter_26_1)
		elseif iter_26_1._STATE == "SKILL_HIT" then
			table.insert(arg_26_0.hits, iter_26_1)
		else
			arg_26_1:executeAction(iter_26_1)
		end
	end
	
	LuaEventDispatcher:addEventListener("battle.event", LISTENER(arg_26_0.onEvent, arg_26_0), "view.action")
end

function ViewDef.ATTACK.ACTION.Update(arg_27_0, arg_27_1)
	for iter_27_0, iter_27_1 in pairs(arg_27_0.skills) do
		arg_27_1:executeAction(iter_27_1)
	end
end

function ViewDef.ATTACK.ACTION.Leave(arg_28_0)
	LuaEventDispatcher:removeEventListenerByKey("view.action")
end

function ViewDef.ATTACK.ACTION.isFinished(arg_29_0)
	return arg_29_0.cur_hit > #arg_29_0.hits and not Battle:isPlayingBattleAction()
end

function ViewDef.ATTACK.ACTION.onEvent(arg_30_0, arg_30_1, ...)
	if arg_30_1 == "Hit" then
		local var_30_0 = ({
			...
		})[1]
		
		if not var_30_0 or not var_30_0.unit then
			return 
		end
		
		local var_30_1 = arg_30_0.hits[arg_30_0.cur_hit]
		
		if not var_30_1 then
			return 
		end
		
		local var_30_2 = Battle.viewer:getAttackInfo(var_30_0.unit)
		
		if var_30_2 then
			var_30_2.cur_hit = var_30_2.cur_hit + 1
		end
		
		local var_30_3 = Battle.vars.skill_hit_info_map[var_30_0.unit] or {}
		
		if var_30_2 and var_30_3 and not var_30_2.tot_hit then
			var_30_2.tot_hit = var_30_3.tot_hit
			var_30_2.tot_soul = tonumber(var_30_2.soul_gain) or 0
			var_30_2.hit_soul = math.floor(var_30_2.tot_soul / var_30_2.tot_hit)
		end
		
		for iter_30_0, iter_30_1 in pairs(var_30_1._CHILDS or {}) do
			if iter_30_1 and iter_30_1.type == "attack" then
				if iter_30_1.cur_hit == 1 or not arg_30_0.hit_map[iter_30_1.target] then
					arg_30_0.hit_map[iter_30_1.target] = table.clone(iter_30_1)
				end
				
				local var_30_4 = arg_30_0.hit_map[iter_30_1.target]
				
				if var_30_4 then
					iter_30_1.from = var_30_4.from
					iter_30_1.tot_hit = var_30_4.tot_hit
					iter_30_1.miss = var_30_4.miss
					iter_30_1.smite = var_30_4.smite
					iter_30_1.resist = var_30_4.resist
					iter_30_1.critical = var_30_4.critical
					iter_30_1.shield = var_30_4.shield
					iter_30_1.antiskilldamage = var_30_4.antiskilldamage
				end
				
				iter_30_1.tag = {
					eff_info = var_30_0.info
				}
			end
		end
		
		arg_30_0.cur_hit = arg_30_0.cur_hit + 1
		
		arg_30_0.handle:executeAction(var_30_1)
	else
		Log.i("BATTLE", "unsupport event key " .. tostring(arg_30_1))
	end
end

ViewDef.SKILL_HIT = {}
ViewDef.SKILL_HIT.ACTION = ClassDef(ViewState)
