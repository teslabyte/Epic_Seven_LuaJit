Log = Log or {
	LEVEL_DEBUG = 4,
	LEVEL_ERROR = 16,
	LEVEL_INFO = 8
}
Log._filter = {
	level = Log.LEVEL_INFO,
	tag = {
		exclude = {},
		include = {}
	}
}
DEBUG_INFO = {
	addLog_e = function(arg_1_0, arg_1_1)
		arg_1_0.log_e = arg_1_0.log_e or {}
		arg_1_0.log_e_begin_idx = arg_1_0.log_e_begin_idx or 1
		arg_1_0.log_e[arg_1_0.log_e_begin_idx % 10] = arg_1_1
		arg_1_0.log_e_begin_idx = arg_1_0.log_e_begin_idx + 1
	end,
	getLog_e = function(arg_2_0)
		local var_2_0 = ""
		
		if arg_2_0.log_e and arg_2_0.log_e_begin_idx then
			for iter_2_0 = arg_2_0.log_e_begin_idx, arg_2_0.log_e_begin_idx + 9 do
				local var_2_1 = iter_2_0 % 10
				
				if arg_2_0.log_e[var_2_1] then
					var_2_0 = var_2_0 .. arg_2_0.log_e[var_2_1] .. "\n"
				end
			end
		end
		
		return var_2_0
	end
}

function Log.d(arg_3_0, ...)
	if Log._filter.level <= Log.LEVEL_DEBUG then
		Log._print("DEBUG", arg_3_0, ...)
	end
end

function Log.i(arg_4_0, ...)
	if Log._filter.level <= Log.LEVEL_INFO then
		Log._print("INFO ", arg_4_0, ...)
	end
end

function Log.e(arg_5_0, ...)
	local var_5_0 = tostring(arg_5_0) or ""
	
	for iter_5_0, iter_5_1 in ipairs({
		...
	}) do
		var_5_0 = var_5_0 .. " " .. tostring(iter_5_1)
	end
	
	DEBUG_INFO:addLog_e("[Log.e] " .. var_5_0)
	
	if analytics_lua_event then
		analytics_lua_event("log.e", var_5_0)
	end
	
	if PLATFORM == "win32" and balloon_message then
		balloon_message("ERROR " .. var_5_0)
	end
	
	if Log._filter.level <= Log.LEVEL_ERROR then
		Log._print("ERROR", arg_5_0, ...)
	end
end

function Log._print(arg_6_0, arg_6_1, ...)
	arg_6_1 = arg_6_1 or ""
	
	if (function()
		if table.find(Log._filter.tag.exclude, arg_6_1) then
			return false
		end
		
		if #Log._filter.tag.include == 0 then
			return true
		end
		
		if table.find(Log._filter.tag.include, arg_6_1) then
			return true
		end
		
		return false
	end)() then
		print(string.format("[%s] [%s]", arg_6_0, arg_6_1), ...)
	end
end

function Log.setLevel(arg_8_0)
	Log._filter.level = arg_8_0
end

function Log.setLevelDebug()
	Log._filter.level = Log.LEVEL_DEBUG
end

function Log.setLevelInfo()
	Log._filter.level = Log.LEVEL_INFO
end

function Log.setLevelError()
	Log._filter.level = Log.LEVEL_ERROR
end

function Log.dd()
	Log.setLevelDebug()
end

function Log.ii()
	Log.setLevelInfo()
end

function Log.ee()
	Log.setLevelError()
end

function Log.setTagInclude(...)
	Log._filter.tag.include = {}
	
	for iter_15_0, iter_15_1 in ipairs({
		...
	}) do
		table.insert(Log._filter.tag.include, tostring(iter_15_1))
	end
end

function Log.setTagExclude(...)
	Log._filter.tag.exclude = {}
	
	for iter_16_0, iter_16_1 in ipairs({
		...
	}) do
		table.insert(Log._filter.tag.exclude, tostring(iter_16_1))
	end
end
