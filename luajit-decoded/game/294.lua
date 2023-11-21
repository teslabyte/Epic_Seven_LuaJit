EVENT = {
	EVT = function(arg_1_0, arg_1_1)
		return {
			type = EVENT.EVT,
			name = arg_1_0,
			target = arg_1_1
		}
	end,
	ANI = function(arg_2_0, arg_2_1, arg_2_2)
		return {
			type = EVENT.ANI,
			name = arg_2_0,
			target = arg_2_1,
			ani = arg_2_2
		}
	end,
	TEXT = function(arg_3_0)
		return {
			type = EVENT.TEXT,
			name = arg_3_0
		}
	end
}

local var_0_0 = {
	__call = function(arg_4_0, ...)
		if arg_4_0.cotr then
			arg_4_0.func(arg_4_0.cotr, ...)
		else
			arg_4_0.func(...)
		end
	end
}

function LISTENER(arg_5_0, arg_5_1)
	local var_5_0 = {
		cotr = arg_5_1,
		func = arg_5_0
	}
	
	setmetatable(var_5_0, var_0_0)
	
	return var_5_0
end

LuaEventDispatcher = LuaEventDispatcher or {}
LuaEventDispatcher._listener = {}
LuaEventDispatcher._delay_remove_list = {}

function LuaEventDispatcher._getEventListeners(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._listener[arg_6_1] then
		arg_6_0._listener[arg_6_1] = {}
	end
	
	local var_6_0 = arg_6_0._listener[arg_6_1] or {}
	local var_6_1 = var_6_0
	
	if arg_6_2 and arg_6_0._paused_listeners_list and arg_6_0._paused_listeners_list[arg_6_1] then
		var_6_1 = {}
		
		for iter_6_0, iter_6_1 in pairs(var_6_0) do
			if not arg_6_0._paused_listeners_list[arg_6_1][iter_6_1.key] then
				table.insert(var_6_1, iter_6_1)
			end
		end
	end
	
	return var_6_1
end

function LuaEventDispatcher.addEventListener(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_2 then
		return 
	end
	
	if not arg_7_3 then
		Log.e("****************** need regist event key *********************")
		
		return 
	end
	
	if type(arg_7_2) ~= "function" and var_0_0 ~= getmetatable(arg_7_2) then
		return 
	end
	
	local var_7_0 = arg_7_0:_getEventListeners(arg_7_1)
	
	table.insert(var_7_0, {
		id = arg_7_1,
		listener = arg_7_2,
		key = arg_7_3
	})
	print("Add Listener ", arg_7_1, arg_7_3)
	
	return arg_7_2
end

function LuaEventDispatcher.addIfNotEventListener(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_1 or not arg_8_2 or not arg_8_3 then
		return 
	end
	
	if type(arg_8_2) ~= "function" and var_0_0 ~= getmetatable(arg_8_2) then
		return 
	end
	
	local var_8_0 = arg_8_0:_getEventListeners(arg_8_1)
	
	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if arg_8_3 == iter_8_1.key then
			return 
		end
	end
	
	table.insert(var_8_0, {
		id = arg_8_1,
		listener = arg_8_2,
		key = arg_8_3
	})
end

function LuaEventDispatcher.removeEventListenerByEventIdAndKey(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1 or not arg_9_2 or not arg_9_0._listener[arg_9_1] then
		return 
	end
	
	local var_9_0 = arg_9_0._listener[arg_9_1]
	
	for iter_9_0 = #var_9_0, 1, -1 do
		if arg_9_2 == var_9_0[iter_9_0].key then
			table.remove(var_9_0, iter_9_0)
		end
	end
end

function LuaEventDispatcher.removeEventListener(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0._listener) do
		for iter_10_2 = #iter_10_1, 1, -1 do
			if arg_10_1 == iter_10_1[iter_10_2].listener then
				table.remove(iter_10_1, iter_10_2)
			end
		end
	end
end

function LuaEventDispatcher.delayRemoveEventListenerByKey(arg_11_0, arg_11_1)
	table.insert(arg_11_0._delay_remove_list, arg_11_1)
end

function LuaEventDispatcher.removeEventListenerByKey(arg_12_0, arg_12_1)
	if not arg_12_1 then
		return 
	end
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0._listener) do
		for iter_12_2 = #iter_12_1, 1, -1 do
			if arg_12_1 == iter_12_1[iter_12_2].key then
				table.remove(iter_12_1, iter_12_2)
			end
		end
	end
end

function LuaEventDispatcher.pauseSendEventToListenerByKey(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0._paused_listeners_list then
		arg_13_0._paused_listeners_list = {}
	end
	
	if not arg_13_0._paused_listeners_list[arg_13_1] then
		arg_13_0._paused_listeners_list[arg_13_1] = {}
	end
	
	arg_13_0._paused_listeners_list[arg_13_1][arg_13_2] = true
end

function LuaEventDispatcher.resumeSendEventToListenerByKey(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0._paused_listeners_list then
		return 
	end
	
	if not arg_14_0._paused_listeners_list[arg_14_1] then
		return 
	end
	
	arg_14_0._paused_listeners_list[arg_14_1][arg_14_2] = nil
end

function LuaEventDispatcher.removeAllEventListeners(arg_15_0)
	arg_15_0._listener = {}
	arg_15_0._delay_remove_list = {}
end

function LuaEventDispatcher.dispatchEvent(arg_16_0, arg_16_1, ...)
	local var_16_0 = arg_16_0:_getEventListeners(arg_16_1, true)
	
	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		xpcall(iter_16_1.listener, __G__TRACKBACK__, ...)
	end
	
	for iter_16_2, iter_16_3 in pairs(arg_16_0._delay_remove_list) do
		arg_16_0:removeEventListenerByKey(iter_16_3)
	end
	
	arg_16_0._delay_remove_list = {}
end

function LuaEventDispatcher.dispatchActionEvent(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_2 = arg_17_2 or Action
	
	local var_17_0 = arg_17_1.TARGET
	local var_17_1 = arg_17_1.EVENTS
	local var_17_2 = arg_17_1.NAME
	local var_17_3 = arg_17_1.MOTION
	local var_17_4 = arg_17_1.TIME_SCALE
	local var_17_5 = arg_17_3
	
	var_17_4 = var_17_4 or 1
	
	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		if var_17_5 and (string.starts(iter_17_1[1], "hit") or string.starts(iter_17_1[1], "fire")) then
			print("[WRANNING] ighoreFire ", iter_17_1[1])
		else
			arg_17_2:Add(SEQ(DELAY(iter_17_1[2] * 1000 * var_17_4), CALL(LuaEventDispatcher.dispatchEvent, LuaEventDispatcher, "spine.ani", EVENT.ANI(iter_17_1[1], var_17_0, var_17_3, {
				integer = iter_17_1[3],
				float = iter_17_1[4],
				str = iter_17_1[5]
			}))), var_17_0, var_17_2)
		end
	end
end
