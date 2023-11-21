HTBUtil = {}

function HTBUtil.callInterface(arg_1_0, arg_1_1, arg_1_2, arg_1_3, ...)
	if not arg_1_1 then
		if arg_1_3 then
			error("This interface must require : " .. arg_1_2)
		end
		
		Log.e(arg_1_2 .. "not exist (if you want disable this error_report, value insert true)")
		
		return 
	end
	
	if arg_1_1[arg_1_2] then
		return arg_1_1[arg_1_2](arg_1_1.self, ...)
	elseif arg_1_3 then
		error("This interface must require : " .. arg_1_2)
	end
end

function HTBUtil.ClassDef(arg_2_0, arg_2_1)
	local var_2_0 = {}
	
	copy_functions(arg_2_1, var_2_0)
	
	if arg_2_1.Interface then
		var_2_0.Interface = {}
		
		copy_functions(arg_2_1.Interface, var_2_0.Interface)
	end
	
	return var_2_0
end
