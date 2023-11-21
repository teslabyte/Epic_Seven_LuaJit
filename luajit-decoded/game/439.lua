PetUIMain = {}

function PetUIMain.setModes(arg_1_0)
	arg_1_0.Modes = {
		House = PetHouse,
		Detail = PetDetail,
		Upgrade = PetUpgrade,
		Synthesis = PetSynthesis,
		Transform = PetTransform,
		Transfer = PetTransfer
	}
end

function PetUIMain.pushMode(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars.next_mode = {
		mode = arg_2_1,
		opts = arg_2_2
	}
	
	if arg_2_0.vars.mode and arg_2_0.Modes[arg_2_0.vars.mode].onPause then
		arg_2_0.Modes[arg_2_0.vars.mode]:onPause()
		
		arg_2_0.Modes[arg_2_0.vars.mode].back_func_infos = arg_2_0.vars.back_func
	end
	
	arg_2_0.vars.back_func = nil
	
	if arg_2_0.Modes[arg_2_1].Presenter then
		arg_2_0.Modes[arg_2_1].Presenter:onCreate(arg_2_2)
	end
	
	arg_2_0.Modes[arg_2_1]:onCreate(arg_2_2)
	BackButtonManager:push({
		back_func = function()
			PetUIMain:popMode()
		end,
		check_id = arg_2_1,
		dlg = arg_2_0.Modes[arg_2_1]:getWnd()
	})
	
	arg_2_0.vars.mode_stack[#arg_2_0.vars.mode_stack + 1] = arg_2_1
	arg_2_0.vars.mode = arg_2_1
	
	Analytics:toggleTab(arg_2_0.vars.mode)
end

function PetUIMain.popMode(arg_4_0)
	local var_4_0 = #arg_4_0.vars.mode_stack
	
	if var_4_0 == 0 then
		Log.e("WARNING! MODE STACK UNDERFLOW!")
		
		return 
	end
	
	local var_4_1 = arg_4_0.vars.mode_stack[var_4_0]
	
	BackButtonManager:pop({
		dlg = arg_4_0.Modes[var_4_1]:getWnd()
	})
	
	local var_4_2 = arg_4_0.Modes[var_4_1]:onLeave()
	
	if arg_4_0.Modes[var_4_1].Presenter then
		arg_4_0.Modes[var_4_1].Presenter:onLeave()
	end
	
	arg_4_0.vars.mode_stack[var_4_0] = nil
	
	local var_4_3 = #arg_4_0.vars.mode_stack
	
	if var_4_3 <= 0 then
		arg_4_0:release()
		
		return 
	end
	
	local var_4_4 = arg_4_0.vars.mode_stack[var_4_3]
	local var_4_5 = arg_4_0.Modes[var_4_4]
	
	arg_4_0.vars.mode = var_4_4
	
	if var_4_5.onResume then
		var_4_5:onResume(var_4_2)
		
		arg_4_0.vars.back_func = var_4_5.back_func_infos
		var_4_5.back_func_infos = nil
	end
	
	Analytics:toggleTab(arg_4_0.vars.mode)
end

function PetUIMain.onLeave(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.mode_stack) do
		if arg_5_0.Modes[iter_5_1].onLeave then
			arg_5_0.Modes[iter_5_1]:onLeave()
		end
	end
	
	arg_5_0.vars.mode_stack = nil
end

function PetUIMain.addValue(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0.vars then
		return 
	end
	
	arg_6_0.vars.white_board[arg_6_1] = arg_6_2
end

function PetUIMain.getValue(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	local var_7_0 = table.copy(arg_7_0.vars.white_board[arg_7_1])
	
	arg_7_0.vars.white_board[arg_7_1] = nil
	
	return var_7_0
end

function PetUIMain.addBackFunc(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_0.vars then
		return 
	end
	
	if not arg_8_0.vars.back_func then
		arg_8_0.vars.back_func = {}
	end
	
	BackButtonManager:push({
		check_id = arg_8_1,
		dlg = arg_8_2,
		back_func = arg_8_3
	})
	
	arg_8_0.vars.back_func[#arg_8_0.vars.back_func + 1] = {
		id = arg_8_1,
		back_func = arg_8_3
	}
end

function PetUIMain.popBackFunc(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars.back_func then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.back_func) do
		if iter_9_1.id == arg_9_1 then
			BackButtonManager:pop({
				dlg = arg_9_2
			})
			table.remove(arg_9_0.vars.back_func, iter_9_0)
		end
	end
end

function PetUIMain.onPushBackButton(arg_10_0)
	if arg_10_0.vars.back_func then
		local var_10_0 = arg_10_0.vars.back_func[#arg_10_0.vars.back_func]
		
		if var_10_0 then
			var_10_0.back_func()
			
			arg_10_0.vars.back_func[#arg_10_0.vars.back_func] = nil
			
			return 
		end
	end
	
	PetUIMain:popMode()
end

function PetUIMain.procNextMode(arg_11_0)
	local var_11_0 = arg_11_0.vars.next_mode.mode
	local var_11_1 = arg_11_0.vars.next_mode.opts
	
	arg_11_0.Modes[var_11_0]:onEnter(var_11_1)
end

function PetUIMain.procOptions(arg_12_0)
	local var_12_0 = arg_12_0.vars.opts
	
	if var_12_0.start_mode and not var_12_0.mode then
		var_12_0.mode = var_12_0.start_mode
	end
	
	if not var_12_0.mode then
		var_12_0.mode = "House"
	end
	
	if var_12_0.mode then
		arg_12_0:pushMode(var_12_0.mode, var_12_0)
		
		arg_12_0.vars.last_mode = var_12_0.mode
	end
	
	if var_12_0.start_mode then
		arg_12_0.vars.last_mode = var_12_0.mode
	end
end

function PetUIMain.onAfterUpdate(arg_13_0)
	if not arg_13_0.vars.mode then
		return 
	end
	
	if arg_13_0.vars.next_mode then
		arg_13_0:procNextMode()
		
		arg_13_0.vars.next_mode = nil
	end
	
	local var_13_0 = arg_13_0.Modes[arg_13_0.vars.mode]
	
	if var_13_0.onAfterUpdate then
		var_13_0:onAfterUpdate()
	end
end

function PetUIMain.onTouchUp(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.Modes[arg_14_0.vars.mode]
	
	if var_14_0 and var_14_0.onTouchUp then
		return var_14_0:onTouchUp(arg_14_1, arg_14_2)
	else
		return false
	end
end

function PetUIMain.onPushBackground(arg_15_0)
	local var_15_0 = arg_15_0.Modes[arg_15_0.vars.mode]
	
	if var_15_0 and var_15_0.onPushBackground then
		return var_15_0:onPushBackground()
	end
end

function PetUIMain.openBaseUI(arg_16_0, arg_16_1)
	PetUIBase:onCreate({
		layer = arg_16_1,
		update_func = arg_16_0.onAfterUpdate,
		update_self = arg_16_0
	})
end

function PetUIMain.init(arg_17_0, arg_17_1, arg_17_2)
	arg_17_2 = arg_17_2 or {}
	arg_17_0.vars = {}
	arg_17_0.vars.opts = arg_17_2
	arg_17_0.vars.mode_stack = {}
	arg_17_0.vars.white_board = {}
	
	arg_17_0:setModes()
	arg_17_0:openBaseUI(arg_17_1)
	arg_17_0:procOptions()
end

function PetUIMain.release(arg_18_0, arg_18_1)
	SceneManager:popScene()
end

function PetUIMain.show(arg_19_0)
	PetUIBase:onEnter()
end
