TouchBlocker = {}

function TouchBlocker.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.scene_map = {}
	arg_1_0.vars.interrupt_func_map = {}
	arg_1_0.vars.destroy_check_func_map = {}
	arg_1_0.vars._last_event_tm = 0
end

function TouchBlocker.pushBlockingScene(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_2 then
		return 
	end
	
	if not arg_2_0.vars then
		arg_2_0:init()
	end
	
	if not arg_2_0.vars.destroy_check_func_map[arg_2_1] then
		arg_2_0.vars.destroy_check_func_map[arg_2_1] = {}
		arg_2_0.vars.scene_map[arg_2_1] = {}
	end
	
	table.insert(arg_2_0.vars.destroy_check_func_map[arg_2_1], {
		name = arg_2_1,
		destroy_check_func = arg_2_2
	})
	table.insert(arg_2_0.vars.scene_map[arg_2_1], true)
	
	return true
end

function TouchBlocker.pushInterrupter(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_1 or not arg_3_2 then
		return 
	end
	
	if not arg_3_0.vars then
		arg_3_0:init()
	end
	
	if not arg_3_0.vars.interrupt_func_map[arg_3_1] then
		arg_3_0.vars.interrupt_func_map[arg_3_1] = {}
	end
	
	table.insert(arg_3_0.vars.interrupt_func_map[arg_3_1], arg_3_2)
end

function TouchBlocker.removeBlockingScene(arg_4_0, arg_4_1)
	if not arg_4_0.vars then
		arg_4_0:init()
	end
	
	arg_4_0.vars.scene_map[arg_4_1] = nil
end

function TouchBlocker.clear(arg_5_0)
	arg_5_0.vars = nil
end

function TouchBlocker.getCurrentDestroyCheckObj(arg_6_0, arg_6_1)
	if not arg_6_0.vars.destroy_check_func_map[arg_6_1] then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.destroy_check_func_map[arg_6_1]
	local var_6_1 = table.count(var_6_0)
	
	if var_6_1 == 0 then
		return 
	end
	
	return var_6_0[var_6_1]
end

function TouchBlocker.getCurrentInterruptFunc(arg_7_0, arg_7_1)
	if not arg_7_0.vars.interrupt_func_map[arg_7_1] then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.interrupt_func_map[arg_7_1]
	local var_7_1 = table.count(var_7_0)
	
	if var_7_1 == 0 then
		return 
	end
	
	return var_7_0[var_7_1]
end

function TouchBlocker.popInterruptStack(arg_8_0, arg_8_1)
	if arg_8_0.vars.scene_map and arg_8_0.vars.scene_map[arg_8_1] and not table.empty(arg_8_0.vars.scene_map[arg_8_1]) then
		table.remove(arg_8_0.vars.scene_map[arg_8_1])
	end
	
	if arg_8_0.vars.destroy_check_func_map and arg_8_0.vars.destroy_check_func_map[arg_8_1] and not table.empty(arg_8_0.vars.destroy_check_func_map[arg_8_1]) then
		table.remove(arg_8_0.vars.destroy_check_func_map[arg_8_1])
	end
	
	if arg_8_0.vars.interrupt_func_map and arg_8_0.vars.interrupt_func_map[arg_8_1] and not table.empty(arg_8_0.vars.interrupt_func_map[arg_8_1]) then
		table.remove(arg_8_0.vars.interrupt_func_map[arg_8_1])
	end
end

function TouchBlocker._checkDestroyedBlocking(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:getCurrentDestroyCheckObj(arg_9_1)
	
	if not var_9_0 then
		Log.e("Destory Check Func Map Was NIL.")
		
		return false
	end
	
	local var_9_1 = var_9_0.destroy_check_func
	
	if not var_9_1 then
		Log.e("Function Was Nil. Data is Valid?")
		
		return false
	end
	
	if var_9_1() then
		arg_9_0:popInterruptStack(arg_9_1)
	end
	
	return true
end

function allSceneSetVisibleFlag(arg_10_0)
	local var_10_0 = SceneManager:getRunningNativeScene()
	local var_10_1 = SceneManager:getRunningPopupScene()
	local var_10_2 = SceneManager:getRunningUIScene()
	
	local function var_10_3(arg_11_0, arg_11_1)
		for iter_11_0, iter_11_1 in pairs(arg_11_0:getChildren()) do
			if arg_11_1 == false and iter_11_1.__last_flag == nil then
				iter_11_1.__last_flag = iter_11_1:isVisible()
			end
			
			if arg_11_1 == true then
				if iter_11_1.__last_flag ~= nil then
					iter_11_1:setVisible(iter_11_1.__last_flag)
					
					iter_11_1.__last_flag = nil
				end
			else
				iter_11_1:setVisible(arg_11_1)
			end
		end
	end
	
	var_10_3(var_10_0, arg_10_0)
	
	if var_10_0 ~= var_10_1 then
		var_10_3(var_10_1, arg_10_0)
	end
	
	if var_10_0 ~= var_10_2 and var_10_1 ~= var_10_2 then
		var_10_3(var_10_2, arg_10_0)
	end
end

function TouchBlocker.isBlockingScene(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if not arg_12_0.vars then
		arg_12_0:init()
	end
	
	if arg_12_0:getCurrentDestroyCheckObj(arg_12_1) ~= nil then
		if not arg_12_0:_checkDestroyedBlocking(arg_12_1) then
			return false
		end
	else
		return false
	end
	
	if not arg_12_0.vars.scene_map[arg_12_1] or table.empty(arg_12_0.vars.scene_map[arg_12_1]) then
		return false
	end
	
	local var_12_0 = uitick()
	
	if var_12_0 - arg_12_0.vars._last_event_tm > 10000 then
		arg_12_0.vars._last_event_tm = var_12_0
		
		print("[DEBUG] Scene " .. arg_12_1 .. " TouchEvent was Blocking! Check TouchBlocker:pushBlockingScene.")
		print("[DEBUG] This Message appear last touch event after 10Sec.")
	end
	
	if not arg_12_4 then
		return true
	end
	
	local var_12_1 = arg_12_0:getCurrentInterruptFunc(arg_12_1)
	
	if var_12_1 and arg_12_2 then
		var_12_1(arg_12_2, arg_12_3, arg_12_5)
	end
	
	return true
end
