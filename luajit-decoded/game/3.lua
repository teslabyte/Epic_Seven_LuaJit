ProFi = {}

local var_0_0
local var_0_1
local var_0_2
local var_0_3
local var_0_4 = 0
local var_0_5 = "| %-50s: %-40s: %-20s: %-12s: %-12s: %-12s|\n"
local var_0_6 = "| %s: %-12s: %-12s: %-12s|\n"
local var_0_7 = "> %s: %-12s\n"
local var_0_8 = "| TOTAL TIME = %f\n"
local var_0_9 = "| %-20s: %-16s: %-16s| %s\n"
local var_0_10 = "H %-20s: %-16s: %-16sH %s\n"
local var_0_11 = "L %-20s: %-16s: %-16sL %s\n"
local var_0_12 = "%-50.50s: %-40.40s: %-20s"
local var_0_13 = "%4i"
local var_0_14 = "%04.3f"
local var_0_15 = "%03.2f%%"
local var_0_16 = "%7i"
local var_0_17 = "%7i Kbytes"
local var_0_18 = "%7.1f Mbytes"
local var_0_19 = "\n=== HIGH & LOW MEMORY USAGE ===============================\n"
local var_0_20 = "=== MEMORY USAGE ==========================================\n"
local var_0_21 = "###############################################################################################################\n#####  ProFi, a lua profiler. This profile was generated on: %s\n#####  ProFi is created by Luke Perkin 2012 under the MIT Licence, www.locofilm.co.uk\n#####  Version 1.3. Get the most recent version at this gist: https://gist.github.com/2838755\n###############################################################################################################\n\n"

function ProFi.start(arg_1_0, arg_1_1)
	if arg_1_1 == "once" then
		if arg_1_0:shouldReturn() then
			return 
		else
			arg_1_0.should_run_once = true
		end
	end
	
	arg_1_0.has_started = true
	arg_1_0.has_finished = false
	
	arg_1_0:resetReports(arg_1_0.reports)
	arg_1_0:startHooks()
	
	arg_1_0.startTime = var_0_3()
end

function ProFi.stop(arg_2_0)
	if arg_2_0:shouldReturn() then
		return 
	end
	
	arg_2_0.stopTime = var_0_3()
	
	arg_2_0:stopHooks()
	
	arg_2_0.has_finished = true
	
	arg_2_0:writeReport()
end

function ProFi.checkMemory(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_3()
	local var_3_1 = arg_3_1 or 0
	
	if arg_3_0.lastCheckMemoryTime and var_3_0 < arg_3_0.lastCheckMemoryTime + var_3_1 then
		return 
	end
	
	arg_3_0.lastCheckMemoryTime = var_3_0
	
	local var_3_2 = {
		time = var_3_0,
		memory = collectgarbage("count"),
		note = arg_3_2 or ""
	}
	
	table.insert(arg_3_0.memoryReports, var_3_2)
	arg_3_0:setHighestMemoryReport(var_3_2)
	arg_3_0:setLowestMemoryReport(var_3_2)
end

function ProFi.writeReport(arg_4_0, arg_4_1)
	if #arg_4_0.reports > 0 or #arg_4_0.memoryReports > 0 then
		arg_4_0:sortReportsWithSortMethod(arg_4_0.reports, arg_4_0.sortMethod)
		arg_4_0:writeReportsToFilename(arg_4_1)
	end
end

function ProFi.reset(arg_5_0)
	arg_5_0.reports = {}
	arg_5_0.reportsByTitle = {}
	arg_5_0.memoryReports = {}
	arg_5_0.highestMemoryReport = nil
	arg_5_0.lowestMemoryReport = nil
	arg_5_0.has_started = false
	arg_5_0.has_finished = false
	arg_5_0.should_run_once = false
	arg_5_0.lastCheckMemoryTime = nil
	arg_5_0.hookCount = arg_5_0.hookCount or var_0_4
	arg_5_0.sortMethod = arg_5_0.sortMethod or var_0_1
	arg_5_0.inspect = nil
end

function ProFi.setHookCount(arg_6_0, arg_6_1)
	arg_6_0.hookCount = arg_6_1
end

function ProFi.setSortMethod(arg_7_0, arg_7_1)
	if arg_7_1 == "duration" then
		arg_7_0.sortMethod = var_0_1
	elseif arg_7_1 == "count" then
		arg_7_0.sortMethod = var_0_2
	end
end

function ProFi.setGetTimeMethod(arg_8_0, arg_8_1)
	var_0_3 = arg_8_1
end

function ProFi.setInspect(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0.inspect then
		arg_9_0.inspect.methodName = arg_9_1
		arg_9_0.inspect.levels = arg_9_2 or 1
	else
		arg_9_0.inspect = {
			methodName = arg_9_1,
			levels = arg_9_2 or 1
		}
	end
end

function ProFi.shouldReturn(arg_10_0)
	return arg_10_0.should_run_once and arg_10_0.has_finished
end

function ProFi.getFuncReport(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getTitleFromFuncInfo(arg_11_1)
	local var_11_1 = arg_11_0.reportsByTitle[var_11_0]
	
	if not var_11_1 then
		var_11_1 = arg_11_0:createFuncReport(arg_11_1)
		arg_11_0.reportsByTitle[var_11_0] = var_11_1
		
		table.insert(arg_11_0.reports, var_11_1)
	end
	
	return var_11_1
end

function ProFi.getTitleFromFuncInfo(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.name or "anonymous"
	local var_12_1 = arg_12_1.short_src or "C_FUNC"
	local var_12_2 = arg_12_1.linedefined or 0
	local var_12_3 = string.format(var_0_13, var_12_2)
	
	return string.format(var_0_12, var_12_1, var_12_0, var_12_3)
end

function ProFi.createFuncReport(arg_13_0, arg_13_1)
	if not arg_13_1.name then
		local var_13_0 = "anonymous"
	end
	
	if not arg_13_1.source then
		local var_13_1 = "C Func"
	end
	
	if not arg_13_1.linedefined then
		local var_13_2 = 0
	end
	
	return {
		timer = 0,
		count = 0,
		title = arg_13_0:getTitleFromFuncInfo(arg_13_1)
	}
end

function ProFi.startHooks(arg_14_0)
	debug.sethook(var_0_0, "cr", arg_14_0.hookCount)
end

function ProFi.stopHooks(arg_15_0)
	debug.sethook()
end

function ProFi.sortReportsWithSortMethod(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_1 then
		table.sort(arg_16_1, arg_16_2)
	end
end

function ProFi.writeReportsToFilename(arg_17_0, arg_17_1)
	local var_17_0
	
	if arg_17_1 then
		var_17_0 = assert(io.open(arg_17_1, "w"))
	else
		var_17_0 = {
			write = function(...)
				print(...)
			end
		}
	end
	
	arg_17_0:writeBannerToFile(var_17_0)
	
	if #arg_17_0.reports > 0 then
		arg_17_0:writeProfilingReportsToFile(arg_17_0.reports, var_17_0)
	end
	
	if #arg_17_0.memoryReports > 0 then
		arg_17_0:writeMemoryReportsToFile(arg_17_0.memoryReports, var_17_0)
	end
	
	if arg_17_1 then
		var_17_0:close()
	end
end

function ProFi.writeProfilingReportsToFile(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.stopTime - arg_19_0.startTime
	local var_19_1 = string.format(var_0_8, var_19_0)
	
	arg_19_2:write(var_19_1)
	
	local var_19_2 = string.format(var_0_5, "FILE", "FUNCTION", "LINE", "TIME", "RELATIVE", "CALLED")
	
	arg_19_2:write(var_19_2)
	
	for iter_19_0, iter_19_1 in ipairs(arg_19_1) do
		local var_19_3 = string.format(var_0_14, iter_19_1.timer)
		local var_19_4 = string.format(var_0_16, iter_19_1.count)
		local var_19_5 = string.format(var_0_15, iter_19_1.timer / var_19_0 * 100)
		local var_19_6 = string.format(var_0_6, iter_19_1.title, var_19_3, var_19_5, var_19_4)
		
		arg_19_2:write(var_19_6)
		
		if iter_19_1.inspections then
			arg_19_0:writeInpsectionsToFile(iter_19_1.inspections, arg_19_2)
		end
	end
end

function ProFi.writeMemoryReportsToFile(arg_20_0, arg_20_1, arg_20_2)
	arg_20_2:write(var_0_19)
	arg_20_0:writeHighestMemoryReportToFile(arg_20_2)
	arg_20_0:writeLowestMemoryReportToFile(arg_20_2)
	arg_20_2:write(var_0_20)
	
	for iter_20_0, iter_20_1 in ipairs(arg_20_1) do
		local var_20_0 = arg_20_0:formatMemoryReportWithFormatter(iter_20_1, var_0_9)
		
		arg_20_2:write(var_20_0)
	end
end

function ProFi.writeHighestMemoryReportToFile(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.highestMemoryReport
	local var_21_1 = arg_21_0:formatMemoryReportWithFormatter(var_21_0, var_0_10)
	
	arg_21_1:write(var_21_1)
end

function ProFi.writeLowestMemoryReportToFile(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.lowestMemoryReport
	local var_22_1 = arg_22_0:formatMemoryReportWithFormatter(var_22_0, var_0_11)
	
	arg_22_1:write(var_22_1)
end

function ProFi.formatMemoryReportWithFormatter(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = string.format(var_0_14, arg_23_1.time)
	local var_23_1 = string.format(var_0_17, arg_23_1.memory)
	local var_23_2 = string.format(var_0_18, arg_23_1.memory / 1024)
	
	return (string.format(arg_23_2, var_23_0, var_23_1, var_23_2, arg_23_1.note))
end

function ProFi.writeBannerToFile(arg_24_0, arg_24_1)
	local var_24_0 = string.format(var_0_21, os.date())
	
	arg_24_1:write(var_24_0)
end

function ProFi.writeInpsectionsToFile(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0:sortInspectionsIntoList(arg_25_1)
	
	arg_25_2:write("\n==^ INSPECT ^======================================================================================================== COUNT ===\n")
	
	for iter_25_0, iter_25_1 in ipairs(var_25_0) do
		local var_25_1 = string.format(var_0_13, iter_25_1.line)
		local var_25_2 = string.format(var_0_12, iter_25_1.source, iter_25_1.name, var_25_1)
		local var_25_3 = string.format(var_0_16, iter_25_1.count)
		local var_25_4 = string.format(var_0_7, var_25_2, var_25_3)
		
		arg_25_2:write(var_25_4)
	end
	
	arg_25_2:write("===============================================================================================================================\n\n")
end

function ProFi.sortInspectionsIntoList(arg_26_0, arg_26_1)
	local var_26_0 = {}
	
	for iter_26_0, iter_26_1 in pairs(arg_26_1) do
		var_26_0[#var_26_0 + 1] = iter_26_1
	end
	
	table.sort(var_26_0, var_0_2)
	
	return var_26_0
end

function ProFi.resetReports(arg_27_0, arg_27_1)
	for iter_27_0, iter_27_1 in ipairs(arg_27_1) do
		iter_27_1.timer = 0
		iter_27_1.count = 0
		iter_27_1.inspections = nil
	end
end

function ProFi.shouldInspect(arg_28_0, arg_28_1)
	return arg_28_0.inspect and arg_28_0.inspect.methodName == arg_28_1.name
end

function ProFi.getInspectionsFromReport(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.inspections
	
	if not var_29_0 then
		var_29_0 = {}
		arg_29_1.inspections = var_29_0
	end
	
	return var_29_0
end

function ProFi.getInspectionWithKeyFromInspections(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_2[arg_30_1]
	
	if not var_30_0 then
		var_30_0 = {
			count = 0
		}
		arg_30_2[arg_30_1] = var_30_0
	end
	
	return var_30_0
end

function ProFi.doInspection(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0:getInspectionsFromReport(arg_31_2)
	local var_31_1 = 5 + arg_31_1.levels
	local var_31_2 = 5
	
	while var_31_2 < var_31_1 do
		local var_31_3 = debug.getinfo(var_31_2, "nS")
		
		if var_31_3 then
			local var_31_4 = var_31_3.short_src or "[C]"
			local var_31_5 = var_31_3.name or "anonymous"
			local var_31_6 = var_31_3.linedefined
			local var_31_7 = var_31_4 .. var_31_5 .. var_31_6
			local var_31_8 = arg_31_0:getInspectionWithKeyFromInspections(var_31_7, var_31_0)
			
			var_31_8.source = var_31_4
			var_31_8.name = var_31_5
			var_31_8.line = var_31_6
			var_31_8.count = var_31_8.count + 1
			var_31_2 = var_31_2 + 1
		else
			break
		end
	end
end

function ProFi.onFunctionCall(arg_32_0, arg_32_1)
	local var_32_0 = ProFi:getFuncReport(arg_32_1)
	
	var_32_0.callTime = var_0_3()
	var_32_0.count = var_32_0.count + 1
	
	if arg_32_0:shouldInspect(arg_32_1) then
		arg_32_0:doInspection(arg_32_0.inspect, var_32_0)
	end
end

function ProFi.onFunctionReturn(arg_33_0, arg_33_1)
	local var_33_0 = ProFi:getFuncReport(arg_33_1)
	
	if var_33_0.callTime then
		var_33_0.timer = var_33_0.timer + (var_0_3() - var_33_0.callTime)
	end
end

function ProFi.setHighestMemoryReport(arg_34_0, arg_34_1)
	if not arg_34_0.highestMemoryReport then
		arg_34_0.highestMemoryReport = arg_34_1
	elseif arg_34_1.memory > arg_34_0.highestMemoryReport.memory then
		arg_34_0.highestMemoryReport = arg_34_1
	end
end

function ProFi.setLowestMemoryReport(arg_35_0, arg_35_1)
	if not arg_35_0.lowestMemoryReport then
		arg_35_0.lowestMemoryReport = arg_35_1
	elseif arg_35_1.memory < arg_35_0.lowestMemoryReport.memory then
		arg_35_0.lowestMemoryReport = arg_35_1
	end
end

var_0_3 = os.clock

function var_0_0(arg_36_0)
	local var_36_0 = debug.getinfo(2, "nS")
	
	if arg_36_0 == "call" then
		ProFi:onFunctionCall(var_36_0)
	elseif arg_36_0 == "return" then
		ProFi:onFunctionReturn(var_36_0)
	end
end

function var_0_1(arg_37_0, arg_37_1)
	return arg_37_0.timer > arg_37_1.timer
end

function var_0_2(arg_38_0, arg_38_1)
	return arg_38_0.count > arg_38_1.count
end

ProFi:reset()

return ProFi
