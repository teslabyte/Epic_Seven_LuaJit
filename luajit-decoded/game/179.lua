VerifySpec = {}
VerifySpecManager = {}
VerifySpecFactory = {}
VSE = {
	deal = 2,
	status = 1
}
VERIFY_LOCAL_TEST = false

local function var_0_0(arg_1_0, ...)
	local var_1_0 = {}
	
	if VerifySpec[arg_1_0] then
		copy_functions(VerifySpec[arg_1_0], var_1_0)
		
		var_1_0.name = arg_1_0
	else
		Log.e("invalid spec name", arg_1_0)
		
		var_1_0 = nil
	end
	
	return var_1_0
end

function VerifySpecManager.create(arg_2_0, arg_2_1)
	local var_2_0 = {}
	
	copy_functions(VerifySpecManager, var_2_0)
	var_2_0:init(arg_2_1)
	
	return var_2_0
end

function VerifySpecManager.init(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	arg_3_0.logic = arg_3_1.logic
	arg_3_0.vs_list = BattleLogger:new()
end

function VerifySpecManager.addSpec(arg_4_0, arg_4_1, arg_4_2, ...)
	local var_4_0 = var_0_0(arg_4_1)
	
	if var_4_0 and var_4_0:is_active() then
		var_4_0:before(...)
		var_4_0:after(arg_4_2())
		
		if arg_4_0.logic:checkVSM() then
			arg_4_0.vs_list:add(var_4_0)
		elseif VERIFY_LOCAL_TEST and var_4_0:is_can_self_verify() then
			local var_4_1 = var_4_0:self_verify()
			
			Log.e("self verify_success", var_4_1)
		end
	end
end

function VerifySpecManager.flush(arg_5_0)
	if VERIFY_LOCAL_TEST then
		return 
	end
	
	local var_5_0 = arg_5_0.vs_list:popAll()
	
	if not table.empty(var_5_0) then
		query("verify_partial", {
			battle_uid = arg_5_0.logic:getBattleUID(),
			vs_datas = json.encode(var_5_0)
		})
	end
end

VerifySpecBase = {}

function VerifySpecBase.before(arg_6_0, ...)
	arg_6_0.state = {
		...
	}
	
	return arg_6_0.state
end

function VerifySpecBase.after(arg_7_0, ...)
	arg_7_0.client_result = {
		...
	}
	
	return arg_7_0.client_result
end

function VerifySpecBase.is_active(arg_8_0)
	return false
end

function VerifySpecBase.proc(arg_9_0, ...)
	Log.e("******************** not implemented proc **********************")
	
	return false, "not implemented proc"
end

function VerifySpecBase.self_verify(arg_10_0, ...)
	return (arg_10_0:proc(nil, arg_10_0.state, arg_10_0.client_result))
end

VerifySpecClient = copy_functions(VerifySpecBase)

function VerifySpecClient.is_can_self_verify(arg_11_0)
	return true
end

function VerifySpecClient.is_use_server_data(arg_12_0)
	return false
end

VerifySpecServer = copy_functions(VerifySpecBase)

function VerifySpecServer.is_can_self_verify(arg_13_0)
	return true
end

function VerifySpecServer.is_use_server_data(arg_14_0)
	return true
end

VerifySpec[VSE.status] = copy_functions(VerifySpecClient)
VerifySpec[VSE.status].is_active = function(arg_15_0)
	return false
end
VerifySpec[VSE.deal] = copy_functions(VerifySpecServer)
VerifySpec[VSE.deal].is_active = function(arg_16_0)
	return true
end
VerifySpec[VSE.deal].before = function(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0.state = {}
	arg_17_0.state.args_data = {}
	arg_17_0.state.logic_data = {}
	
	return arg_17_0.state
end
VerifySpec[VSE.deal].after = function(arg_18_0, arg_18_1)
	arg_18_0.client_result = {}
	arg_18_0.client_result.atk_result = {}
	
	return arg_18_0.client_result
end
VerifySpec[VSE.deal].self_verify = function(arg_19_0, ...)
	local var_19_0
	
	return (arg_19_0:proc(var_19_0, arg_19_0.state, arg_19_0.client_result))
end
