SPLEventData = ClassDef()

function SPLEventData.constructor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.db = DBT("tile_sub_event", arg_1_2, {
		"id",
		"trigger",
		"condition_type",
		"condition_value",
		"action_true",
		"action_false"
	})
	arg_1_0.inst = {}
	arg_1_0.inst.actor = arg_1_1
end

function SPLEventData.getType(arg_2_0)
	return "spl_event"
end

function SPLEventData.getActor(arg_3_0)
	if not arg_3_0.inst then
		return 
	end
	
	return arg_3_0.inst.actor
end

function SPLEventData.getEventKey(arg_4_0)
	if not arg_4_0.db then
		return 
	end
	
	return arg_4_0.db.id
end

function SPLEventData.getTrigger(arg_5_0)
	if not arg_5_0.db then
		return 
	end
	
	return arg_5_0.db.trigger
end

function SPLEventData.getConditionType(arg_6_0)
	if not arg_6_0.db then
		return 
	end
	
	return arg_6_0.db.condition_type
end

function SPLEventData.getConditionValue(arg_7_0)
	if not arg_7_0.db then
		return 
	end
	
	return arg_7_0.db.condition_value
end

function SPLEventData.getActionKey(arg_8_0)
	if SPLEventSystem:checkCondition(arg_8_0) then
		return arg_8_0:getActionSucceed()
	else
		return arg_8_0:getActionFailed()
	end
end

function SPLEventData.getActionSucceed(arg_9_0)
	if not arg_9_0.db then
		return 
	end
	
	return string.sub(arg_9_0.db.action_true or "", 1, -4)
end

function SPLEventData.getActionFailed(arg_10_0)
	if not arg_10_0.db then
		return 
	end
	
	return string.sub(arg_10_0.db.action_false or "", 1, -4)
end

function SPLEventData.initActionList(arg_11_0)
	if not arg_11_0.inst then
		return 
	end
	
	arg_11_0.inst.act_queue = {}
	arg_11_0.inst.concurrency = true
	
	local var_11_0 = arg_11_0:getActionKey()
	
	if not var_11_0 then
		return 
	end
	
	for iter_11_0 = 1, 99 do
		local var_11_1 = SPLActionData(var_11_0, iter_11_0)
		local var_11_2 = var_11_1:getType()
		
		if not var_11_2 then
			break
		end
		
		if not SPLEventSystem:getProcedureFunc(var_11_2) then
			arg_11_0.inst.concurrency = false
		end
		
		arg_11_0:enqueueAction(var_11_1)
	end
	
	arg_11_0.inst.action_cnt = #arg_11_0.inst.act_queue
	
	return true
end

function SPLEventData.enqueueAction(arg_12_0, arg_12_1)
	if not arg_12_0.inst then
		return 
	end
	
	if #arg_12_0.inst.act_queue == 0 then
		arg_12_0.inst.act_queue = {
			{
				arg_12_1
			}
		}
		
		return 
	end
	
	if arg_12_1:isSpawnAction() then
		local var_12_0 = #arg_12_0.inst.act_queue
		
		if not arg_12_0.inst.act_queue[var_12_0] then
			arg_12_0.inst.act_queue[var_12_0] = {}
		end
		
		table.insert(arg_12_0.inst.act_queue[var_12_0], arg_12_1)
	else
		table.insert(arg_12_0.inst.act_queue, {
			arg_12_1
		})
	end
end

function SPLEventData.nextAction(arg_13_0)
	if not arg_13_0.inst then
		return 
	end
	
	if #arg_13_0.inst.act_queue == 0 then
		return 
	end
	
	return table.remove(arg_13_0.inst.act_queue, 1)
end

function SPLEventData.getActionCount(arg_14_0)
	return arg_14_0.inst and arg_14_0.inst.action_cnt or 0
end

function SPLEventData.isConcurrentEvent(arg_15_0)
	return arg_15_0.inst and arg_15_0.inst.concurrency
end

function SPLEventData.isMainEvent(arg_16_0)
	if not arg_16_0.inst then
		return 
	end
	
	return arg_16_0.inst.actor:getMainEventKey() == arg_16_0:getEventKey()
end

SPLActionData = ClassDef()

function SPLActionData.constructor(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = DBT("tile_sub_action", string.format("%s_%02d", arg_17_1, arg_17_2), {
		"id",
		"eff_type",
		"eff_value",
		"time",
		"after"
	})
	
	if not var_17_0 or not var_17_0.id then
		return 
	end
	
	arg_17_0.db = var_17_0
	arg_17_0.act_params = var_17_0.eff_value and totable(var_17_0.eff_value, "=", ";") or {}
	arg_17_0.act_params.total_time = arg_17_0:getTotalTime()
end

function SPLActionData.getType(arg_18_0)
	if not arg_18_0.db then
		return 
	end
	
	return arg_18_0.db.eff_type
end

function SPLActionData.getParams(arg_19_0)
	return arg_19_0.act_params
end

function SPLActionData.getTotalTime(arg_20_0)
	if not arg_20_0.db then
		return 
	end
	
	return arg_20_0.db.time or 2000
end

function SPLActionData.isSpawnAction(arg_21_0)
	if not arg_21_0.db then
		return 
	end
	
	return arg_21_0.db.after ~= "y"
end
