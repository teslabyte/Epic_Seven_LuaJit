BeforeErrHandler = BeforeErrHandler or {}
ErrHandler = ErrHandler or {}
MsgHandler = MsgHandler or {}
QueryHistory = QueryHistory or {}
QueryList = {}
QueryList.count = 0
QueryList.processing = false
QueryConfig = QueryConfig or {}
DEBUG.SLOW_QUERY = nil

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	table.insert(QueryHistory, {
		dir = arg_1_0,
		query = arg_1_1,
		success = arg_1_2,
		result = arg_1_3
	})
	
	while #QueryHistory > 5 do
		table.remove(QueryHistory, 1)
	end
end

local function var_0_1(arg_2_0)
	if not arg_2_0 then
		return 
	end
	
	local var_2_0
	
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		var_2_0 = (var_2_0 and var_2_0 .. "; " or "") .. tostring(iter_2_0) .. "=" .. tostring(iter_2_1)
	end
	
	return var_2_0
end

function query(arg_3_0, arg_3_1)
	return query2({
		cmd = arg_3_0,
		params = arg_3_1,
		success = function(arg_4_0, arg_4_1)
			QueryList.processing = true
			
			if MsgHandler[arg_3_0] then
				if ConditionContentsManager:getContentsList() then
					ConditionContentsManager:setIgnoreQuery(true)
				end
				
				MsgHandler[arg_3_0](arg_4_0, arg_4_1)
				
				if ConditionContentsManager:getContentsList() then
					ConditionContentsManager:setIgnoreQuery(false)
					ConditionContentsManager:queryUpdateConditions("mh:" .. arg_3_0)
				end
			end
			
			QueryList.processing = false
			
			if arg_4_0 then
				if arg_4_0.rolling_notice then
					Announcement:setData(arg_4_0.rolling_notice)
				end
				
				if arg_4_0.event_flags then
					setenv("g.event.finish", arg_4_0.event_flags)
				end
			end
		end,
		fail = function(arg_5_0, arg_5_1, arg_5_2)
			QueryList.processing = true
			
			if BeforeErrHandler[arg_5_0] then
				BeforeErrHandler[arg_5_0](arg_5_0, arg_5_1, arg_5_2)
			end
			
			if ErrHandler[arg_5_0] then
				ErrHandler[arg_5_0](arg_5_0, arg_5_1, arg_5_2)
			else
				on_net_error(arg_5_0, arg_5_1, arg_5_2)
			end
			
			QueryList.processing = false
		end
	})
end

function query2(arg_6_0)
	if IS_TOOL_MODE then
		return 
	end
	
	print("QUERY", arg_6_0.cmd)
	
	arg_6_0.time = os.time()
	arg_6_0.params = arg_6_0.params or {}
	QueryList.count = QueryList.count + 1
	
	local var_6_0 = getenv("g.event.result", "")
	
	if var_6_0 ~= "" then
		setenv("g.event.result", "")
		
		arg_6_0.params.event_vresult = var_6_0
	end
	
	for iter_6_0, iter_6_1 in ipairs(QueryList) do
		if arg_6_0.cmd == iter_6_1.cmd and PLATFORM == "win32" then
			print("error DUPLICATED QUERY!!!!!!!!********!!!!!1<<<pkyeesl call", arg_6_0.cmd)
			print("error DUPLICATED QUERY!!!!!!!!********!!!!!2<<<pkyeesl call", arg_6_0.cmd)
			print("error DUPLICATED QUERY!!!!!!!!********!!!!!3<<<pkyeesl call", arg_6_0.cmd)
			table.print(arg_6_0)
		end
	end
	
	QueryList[#QueryList + 1] = arg_6_0
	
	var_0_0("request", arg_6_0)
	
	if #QueryList > 1 then
		return arg_6_0.qid
	end
	
	reqNextQuery()
	
	return arg_6_0.qid
end

function removeAllQuery()
	QueryList = {
		count = QueryList.count
	}
end

function onReadyStateChange(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_1 then
		Log.e("ONREADYSTATECHANGE query is nil", #QueryList)
		NetWaiting:onNetworkError(arg_8_3)
		
		return 
	end
	
	if arg_8_1 ~= QueryList[1] then
		Log.e("Lost Query")
		NetWaiting:onLostQueryHandler(arg_8_1)
		
		return 
	end
	
	local var_8_0 = arg_8_1.fail
	
	if arg_8_0 == nil or arg_8_0 == "" then
		Log.e("NO RESPONSE  err: ", arg_8_3)
		NetWaiting:onNetworkError(arg_8_3)
		
		return 
	end
	
	if arg_8_2 then
		arg_8_0 = json.decode(arg_8_0)
	end
	
	arg_8_0 = Net:resultFilter(arg_8_0)
	
	local var_8_1 = arg_8_1.success
	local var_8_2 = arg_8_0.err
	
	var_0_0("response", arg_8_1, not var_8_2, arg_8_0)
	
	if var_8_2 then
		print("err:" .. arg_8_1.cmd .. ":" .. var_8_2)
		
		local var_8_3 = string.split(tostring(var_8_2), "invalid_save_all_complete_confirm")
		
		if var_8_3 and #var_8_3 > 1 then
			var_8_2 = "session_error"
		end
		
		if isMaintenanceError(var_8_2) then
			removeAllQuery()
			NetWaiting:clear()
			handleMaintenance(var_8_2, arg_8_0)
			
			return 
		end
		
		if var_8_2 == "server_busy" then
			NetWaiting:onServerBusy(arg_8_0)
			
			return 
		elseif var_8_0 then
			var_8_0(arg_8_1.cmd, var_8_2, arg_8_0)
		else
			on_net_error(arg_8_1.cmd, var_8_2, arg_8_0)
		end
		
		table.remove(QueryList, 1)
		reqNextQuery()
	else
		if DEBUG.SLOW_QUERY then
			SysAction:Add(SEQ(DELAY(DEBUG.SLOW_QUERY), CALL(function()
				if var_8_1 then
					var_8_1(arg_8_0, arg_8_1)
				end
				
				table.remove(QueryList, 1)
				reqNextQuery()
			end)), {})
		else
			if var_8_1 then
				var_8_1(arg_8_0, arg_8_1)
			end
			
			table.remove(QueryList, 1)
			reqNextQuery()
		end
		
		if var_8_1 then
			if arg_8_0.debug_dialog then
				Dialog:msgBox(arg_8_0.debug_dialog)
			elseif arg_8_0.debug_title then
				local var_8_4 = T("debug_reload_data")
				
				if type(arg_8_0.debug_title) == "string" then
					var_8_4 = arg_8_0.debug_title
				end
				
				Dialog:msgBox(var_8_4, {
					handler = function()
						removeAllQuery()
						NetWaiting:clear()
						restart_contents()
					end
				})
			end
		end
	end
end

function reqNextQuery()
	if #QueryList < 1 then
		NetWaiting:clear()
		
		return 
	end
	
	local var_11_0 = QueryList[1]
	local var_11_1 = os.time()
	
	if var_11_1 > var_11_0.time + 3 then
		var_11_0.time = var_11_1 - 4
	end
	
	Net:query(var_11_0.cmd, var_11_0.params, {
		callback = onReadyStateChange,
		query = var_11_0
	})
	NetWaiting:onQuery(var_11_0)
end

function parse_cookie(arg_12_0)
	local var_12_0 = {}
	local var_12_1 = string.split(arg_12_0, ";")
	
	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		local var_12_2 = string.split(string.trim(iter_12_1), "=")
		
		var_12_0[var_12_2[1]] = var_12_2[2] or true
	end
	
	return var_12_0
end

function urlencode(arg_13_0)
	arg_13_0 = string.gsub(arg_13_0, "\r?\n", "\r\n")
	arg_13_0 = string.gsub(arg_13_0, "([^%w%-%.%_%~ ])", function(arg_14_0)
		return string.format("%%%02X", string.byte(arg_14_0))
	end)
	arg_13_0 = string.gsub(arg_13_0, " ", "+")
	
	return arg_13_0
end

function urldecode(arg_15_0)
	arg_15_0 = string.gsub(arg_15_0, "+", " ")
	arg_15_0 = string.gsub(arg_15_0, "%%(%x%x)", function(arg_16_0)
		return string.char(tonumber(arg_16_0, 16))
	end)
	arg_15_0 = string.gsub(arg_15_0, "\r\n", "\n")
	
	return arg_15_0
end

Net = Net or {
	vars = {}
}

function Net.init(arg_17_0)
	arg_17_0.vars.cookie = nil
	arg_17_0.vars.seqnum = 0
	arg_17_0.vars.counter = 0
end

function Net.genVersionInfo(arg_18_0)
	local var_18_0 = 0
	
	if IS_ANDROID_BASED_PLATFORM then
		local var_18_1 = getenv("android.distribution_format")
		
		var_18_0 = var_18_1 == "aab" and 1 or var_18_1 == "apk" and 2 or getenv("build.aab") and 1 or 2
	end
	
	local var_18_2 = 0
	
	if PLATFORM == "android" then
		var_18_2 = 1
		
		if IS_ANDROID_PC then
			var_18_2 = 8
		end
	elseif PLATFORM == "iphoneos" then
		var_18_2 = 2
	elseif PLATFORM == "win32" then
		var_18_2 = 3
	elseif PLATFORM == "mycard" then
		var_18_2 = 5
	elseif PLATFORM == "amazon" then
		var_18_2 = 6
	elseif PLATFORM == "huawei" then
		var_18_2 = 7
	else
		Log.e("undefined os id : " .. tostring(PLATFORM))
	end
	
	local var_18_3 = getenv("patch.version", 0)
	local var_18_4 = tonumber(getenv("build.number", 0)) or 0
	
	arg_18_0.vars.AppVersion = var_18_0
	arg_18_0.vars.AppVersion = arg_18_0.vars.AppVersion + var_18_2 * 10
	arg_18_0.vars.AppVersion = arg_18_0.vars.AppVersion + tonumber(var_18_3) * 100
	arg_18_0.vars.AppVersion = arg_18_0.vars.AppVersion + tonumber(var_18_4) * 100000000
	
	Log.i("AppVersion", arg_18_0.vars.AppVersion)
	
	local var_18_5 = tonumber(getenv("patch.res.version", 0)) or 0
	local var_18_6 = tonumber(getenv("patch.text.version", 0)) or 0
	local var_18_7 = tonumber(getenv("patch.media.version", 0)) or 0
	
	arg_18_0.vars.PatchVersion = string.format("%08x%08x%08x", var_18_5, var_18_6, var_18_7)
	
	Log.i("PatchVersion", arg_18_0.vars.PatchVersion)
	
	arg_18_0.vars.device_uid = get_udid() or "get_udid_is_nil"
	arg_18_0.vars.patch_status = getenv("patch.status")
end

function Net.resultFilter(arg_19_0, arg_19_1)
	if arg_19_1 and arg_19_1.cookie then
		arg_19_0.vars.cookie = parse_cookie(arg_19_1.cookie)
	end
	
	return arg_19_1
end

function Net.assignAuthInfo(arg_20_0, arg_20_1)
	if not arg_20_0.vars.AppVersion or not arg_20_0.vars.PatchVersion or not arg_20_0.vars.device_uid or arg_20_0.vars.patch_status ~= getenv("patch.status") then
		arg_20_0:genVersionInfo()
	end
	
	arg_20_1.version_info = arg_20_0.vars.AppVersion
	
	if getenv("patch.status") == "complete" then
		arg_20_1.patch_info = "0" .. arg_20_0.vars.PatchVersion
	else
		arg_20_1.patch_info = "1" .. arg_20_0.vars.PatchVersion
	end
	
	arg_20_1.device_uid = arg_20_0.vars.device_uid
	arg_20_1._ct = os.time()
	arg_20_1.world_id = arg_20_1.world_id or Login:getWorldID()
	arg_20_1.server_region = Login:getRegion()
	
	local var_20_0 = Login:getLoginResult()
	
	if var_20_0 and var_20_0.id then
		arg_20_1.id = var_20_0.id
		arg_20_1.session = var_20_0.session
	end
	
	local var_20_1 = ""
	local var_20_2 = string.format("%x", string_hash(string_hash(math.floor(arg_20_1._ct / 10) + 1535565600)))
	local var_20_3 = var_20_1 .. string.format("%x", string.len(var_20_2)) .. var_20_2
	local var_20_4 = 0
	local var_20_5 = 0
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		if string.starts(iter_20_0, "_") ~= true and iter_20_1 ~= nil and string.len(tostring(iter_20_1)) > 0 then
			var_20_4 = var_20_4 + string_hash(string_tomd5(tostring(iter_20_0)))
			
			if type(iter_20_1) == "number" then
				if iter_20_1 >= 4200000000 then
					var_20_5 = var_20_5 + string_hash(string_tomd5(tostring(math.floor(iter_20_1) % 4200000000)))
					
					if arg_20_0.vars._debug_oac_value == 1 then
						print("oc=" .. iter_20_0 .. " " .. type(iter_20_1), string_hash(string_tomd5(tostring(math.floor(iter_20_1) % 4200000000))), iter_20_1)
					end
				else
					var_20_5 = var_20_5 + string_hash(string_tomd5(tostring(math.floor(iter_20_1))))
					
					if arg_20_0.vars._debug_oac_value == 1 then
						print("oc=" .. iter_20_0 .. " " .. type(iter_20_1), string_hash(string_tomd5(tostring(math.floor(iter_20_1)))), iter_20_1)
					end
				end
			else
				var_20_5 = var_20_5 + string_hash(string_tomd5(tostring(iter_20_1)))
				
				if arg_20_0.vars._debug_oac_value == 1 then
					print("oc=" .. iter_20_0 .. " " .. type(iter_20_1), string_hash(string_tomd5(tostring(iter_20_1))), iter_20_1)
				end
			end
		end
	end
	
	arg_20_1._oc = var_20_3 .. string.format("%x", var_20_5 + math.floor(to_n(arg_20_1._ct) / 3) + 1598724000) .. string.format("%x", var_20_4 + math.floor(to_n(arg_20_1._ct) / 2) + 1567101600)
end

QueryConfig = {}

function Net.init_query_config(arg_21_0, arg_21_1)
	QueryConfig.method, QueryConfig.host, QueryConfig.port = string.match(arg_21_1, "(%a+)://(.+):([0-9]+)")
	QueryConfig.tag = string.match(arg_21_1, "%a+://.+:[0-9]+(/.+/)")
end

function Net.query(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_3 = arg_22_3 or {}
	arg_22_2 = arg_22_2 or {}
	
	local var_22_0 = arg_22_3.callback
	local var_22_1 = arg_22_3.err_callback
	local var_22_2 = arg_22_3.read_timeout or 10000
	local var_22_3 = arg_22_3.uri
	local var_22_4 = arg_22_3.query
	
	var_22_3 = var_22_3 or getenv("app.api")
	
	if not QueryConfig.method then
		arg_22_0:init_query_config(var_22_3)
	end
	
	arg_22_0:assignAuthInfo(arg_22_2)
	
	if tonumber(arg_22_0.vars.counter) then
		arg_22_2._qctr = arg_22_0.vars.counter * math.floor(arg_22_2._ct / 2) * 79
		arg_22_0.vars.counter = arg_22_0.vars.counter + 1
	end
	
	if QueryConfig.method == "msg" then
		local var_22_5 = var_0_1(arg_22_0.vars.cookie)
		local var_22_6 = {
			cmd = arg_22_1,
			params = arg_22_2,
			path = QueryConfig.tag .. arg_22_1,
			cookie = var_22_5
		}
		
		if var_22_4 then
			var_22_6._qid = var_22_4.qid
		end
		
		local var_22_7 = MSGPack.pack(var_22_6)
		local var_22_8 = su.TCPRequest:new("tcp://" .. QueryConfig.host .. ":" .. QueryConfig.port)
		
		if var_22_8.setReadTimeout then
			var_22_8:setReadTimeout(var_22_2)
		end
		
		if var_22_8.setReuseAddr then
			var_22_8:setReuseAddr(1)
		end
		
		var_22_8:setResponseCallback(function(arg_23_0, arg_23_1)
			local var_23_0
			
			if arg_23_1:getErrorCode() == 0 then
				local var_23_1 = arg_23_1:getResponseData()
				
				REPORT_PACKET = {
					cmd = arg_22_1,
					packet = var_23_1
				}
				var_23_0 = MSGPack.unpack(arg_23_1:getResponseData())
				REPORT_PACKET = nil
			end
			
			if PLATFORM == "win32" then
				print(arg_22_1, arg_23_1:getErrorCode())
			end
			
			if var_22_0 then
				var_22_0(var_23_0, var_22_4, false, arg_23_1:getErrorCode())
			end
		end)
		var_22_8:send(var_22_7)
		
		return 
	end
	
	local var_22_9 = ""
	
	for iter_22_0, iter_22_1 in pairs(arg_22_2) do
		if string.len(var_22_9) > 0 then
			var_22_9 = var_22_9 .. "&"
		end
		
		var_22_9 = var_22_9 .. iter_22_0
		var_22_9 = var_22_9 .. "="
		var_22_9 = var_22_9 .. urlencode(tostring(iter_22_1))
	end
	
	local var_22_10 = cc.XMLHttpRequest:new()
	
	var_22_10:setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	
	local var_22_11 = var_0_1(arg_22_0.vars.cookie)
	
	if var_22_11 then
		var_22_10:setRequestHeader("Cookie", var_22_11)
	end
	
	var_22_10.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	
	var_22_10:registerScriptHandler(function()
		if PLATFORM == "win32" then
			print(arg_22_1, 0)
		end
		
		if var_22_0 then
			var_22_0(var_22_10.response, var_22_4, true)
		end
		
		var_22_10:release()
	end)
	
	local var_22_12 = string.format("%s%s", var_22_3, arg_22_1)
	
	if var_22_4 then
		var_22_12 = var_22_12 .. "?_qid=" .. QueryList.count
	end
	
	var_22_10:open("POST", var_22_12)
	var_22_10:send(var_22_9)
end

function Net.direct_query(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_3 = arg_25_3 or {}
	arg_25_2 = arg_25_2 or {}
	
	local var_25_0 = arg_25_3.callback
	local var_25_1 = arg_25_3.err_callback
	local var_25_2 = arg_25_3.read_timeout or 10000
	local var_25_3 = arg_25_3.uri
	local var_25_4 = arg_25_3.query
	
	var_25_3 = var_25_3 or getenv("app.api")
	
	local var_25_5, var_25_6, var_25_7 = string.match(var_25_3, "(%a+)://(.+):([0-9]+)")
	local var_25_8 = string.match(var_25_3, "%a+://.+:[0-9]+(/.+/)")
	
	arg_25_0:assignAuthInfo(arg_25_2)
	
	if tonumber(arg_25_0.vars.counter) then
		arg_25_2._qctr = arg_25_0.vars.counter * math.floor(arg_25_2._ct / 2) * 79
		
		if not arg_25_3.no_qctl then
			arg_25_0.vars.counter = arg_25_0.vars.counter + 1
		end
	end
	
	if var_25_5 == "msg" then
		local var_25_9 = {
			cmd = arg_25_1,
			params = arg_25_2,
			path = (var_25_8 or "") .. arg_25_1
		}
		
		if var_25_4 then
			var_25_9._qid = var_25_4.qid
		end
		
		local var_25_10 = MSGPack.pack(var_25_9)
		local var_25_11 = su.TCPRequest:new("tcp://" .. var_25_6 .. ":" .. var_25_7)
		
		if var_25_11.setReadTimeout then
			var_25_11:setReadTimeout(var_25_2)
		end
		
		if var_25_11.setReuseAddr then
			var_25_11:setReuseAddr(1)
		end
		
		var_25_11:setResponseCallback(function(arg_26_0, arg_26_1)
			local var_26_0
			
			if arg_26_1:getErrorCode() == 0 then
				var_26_0 = MSGPack.unpack(arg_26_1:getResponseData())
			end
			
			if PLATFORM == "win32" then
				print(arg_25_1, arg_26_1:getErrorCode())
			end
			
			if var_25_0 then
				var_25_0(var_26_0, var_25_4, false, arg_26_1:getErrorCode())
			end
		end)
		var_25_11:send(var_25_10)
		
		return 
	end
	
	local var_25_12 = ""
	
	for iter_25_0, iter_25_1 in pairs(arg_25_2) do
		if string.len(var_25_12) > 0 then
			var_25_12 = var_25_12 .. "&"
		end
		
		var_25_12 = var_25_12 .. iter_25_0
		var_25_12 = var_25_12 .. "="
		var_25_12 = var_25_12 .. urlencode(tostring(iter_25_1))
	end
	
	local var_25_13 = cc.XMLHttpRequest:new()
	
	var_25_13:setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	
	var_25_13.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	
	var_25_13:registerScriptHandler(function()
		if PLATFORM == "win32" then
			print(arg_25_1, 0)
		end
		
		if var_25_0 then
			var_25_0(var_25_13.response, var_25_4, true)
		end
		
		var_25_13:release()
	end)
	
	local var_25_14 = string.format("%s%s", var_25_3, arg_25_1)
	
	if var_25_4 then
		var_25_14 = var_25_14 .. "?_qid=" .. QueryList.count
	end
	
	var_25_13:open("POST", var_25_14)
	var_25_13:send(var_25_12)
end

function Net.arena_queue_start(arg_28_0)
	arg_28_0.vars.arena_queue = Queue.new()
end

function Net.arena_queue_reset(arg_29_0)
	arg_29_0.vars.arena_queue = nil
end

function Net.arena_query(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if not arg_30_0.vars.arena_queue then
		return false
	end
	
	local var_30_0 = not Queue.empty(arg_30_0.vars.arena_queue)
	
	if var_30_0 and Queue.exist(arg_30_0.vars.arena_queue, function(arg_31_0)
		return arg_31_0.cmd == arg_30_1 and arg_31_0.params.payload == arg_30_2.payload
	end) then
		return false
	end
	
	Queue.push(arg_30_0.vars.arena_queue, {
		cmd = arg_30_1,
		params = arg_30_2,
		opts = arg_30_3
	})
	
	if not var_30_0 then
		Net:arena_do_write()
	end
	
	return true
end

function Net.arena_do_write(arg_32_0)
	if not arg_32_0.vars.arena_queue then
		return 
	end
	
	local var_32_0 = Queue.top(arg_32_0.vars.arena_queue)
	
	if var_32_0 then
		Net:direct_query_v2(var_32_0.cmd, var_32_0.params, {
			uri = var_32_0.opts.uri,
			no_qctl = var_32_0.opts.no_qctl,
			read_timeout = var_32_0.opts.read_timeout,
			keep_alive = var_32_0.opts.keep_alive,
			conn_reset = var_32_0.opts.conn_reset,
			content_type = var_32_0.opts.content_type,
			callback = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				Net:arena_write_done(arg_33_0, var_32_0, arg_33_2, arg_33_3)
			end
		})
	end
end

function Net.arena_write_done(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	if not arg_34_0.vars.arena_queue then
		return 
	end
	
	if arg_34_2.opts.retry > 0 and arg_34_4 > 0 then
		arg_34_2.opts.retry = arg_34_2.opts.retry - 1
		
		arg_34_0:arena_do_write()
	else
		if arg_34_2.opts.callback then
			arg_34_2.opts.callback(arg_34_1, arg_34_2, arg_34_3, arg_34_4)
		end
		
		if arg_34_0.vars.arena_queue then
			Queue.pop(arg_34_0.vars.arena_queue)
			
			if not Queue.empty(arg_34_0.vars.arena_queue) then
				Net:arena_do_write()
			end
		end
	end
end

function Net.direct_query_v2(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_3 = arg_35_3 or {}
	arg_35_2 = arg_35_2 or {}
	
	local var_35_0 = arg_35_3.callback
	local var_35_1 = arg_35_3.err_callback
	local var_35_2 = arg_35_3.uri
	local var_35_3 = arg_35_3.query
	local var_35_4 = arg_35_3.read_timeout or 30000
	local var_35_5 = arg_35_3.keep_alive or true
	local var_35_6 = arg_35_3.conn_reset or false
	
	var_35_2 = var_35_2 or getenv("app.api")
	
	local var_35_7, var_35_8, var_35_9 = string.match(var_35_2, "(%a+)://(.+):([0-9]+)")
	local var_35_10 = string.match(var_35_2, "%a+://.+:[0-9]+(/.+/)")
	
	arg_35_0:assignAuthInfo(arg_35_2)
	
	if var_35_7 == "msg" then
		local var_35_11 = {
			cmd = arg_35_1,
			params = arg_35_2,
			path = (var_35_10 or "") .. arg_35_1
		}
		
		if var_35_3 then
			var_35_11._qid = var_35_3.qid
		end
		
		local var_35_12 = MSGPack.pack(var_35_11)
		local var_35_13 = su.TCPRequestV2:new("tcp://" .. var_35_8 .. ":" .. var_35_9)
		
		var_35_13:setReadTimeout(var_35_4)
		var_35_13:setKeepAlive(var_35_5)
		
		if var_35_13.setConnReset then
			var_35_13:setConnReset(var_35_6)
		end
		
		var_35_13:setResponseCallback(function(arg_36_0, arg_36_1)
			local var_36_0
			
			if arg_36_1:getErrorCode() == 0 then
				var_36_0 = MSGPack.unpack(arg_36_1:getResponseData())
			end
			
			if PLATFORM == "win32" then
				print(arg_35_1, arg_36_1:getErrorCode())
			end
			
			if var_35_0 then
				var_35_0(var_36_0, var_35_3, false, arg_36_1:getErrorCode())
			end
		end)
		var_35_13:send(var_35_12)
		
		return 
	end
	
	local var_35_14 = ""
	
	for iter_35_0, iter_35_1 in pairs(arg_35_2) do
		if string.len(var_35_14) > 0 then
			var_35_14 = var_35_14 .. "&"
		end
		
		var_35_14 = var_35_14 .. iter_35_0
		var_35_14 = var_35_14 .. "="
		var_35_14 = var_35_14 .. urlencode(tostring(iter_35_1))
	end
	
	local var_35_15 = "application/x-www-form-urlencoded"
	
	if arg_35_3.content_type then
		var_35_15 = arg_35_3.content_type
		var_35_14 = json.encode(arg_35_2)
	end
	
	local var_35_16 = cc.XMLHttpRequest:new()
	
	var_35_16:setRequestHeader("Content-Type", var_35_15)
	
	var_35_16.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	var_35_16.timeout = var_35_4
	
	var_35_16:registerScriptHandler(function()
		if PLATFORM == "win32" then
			print(arg_35_1, 0)
		end
		
		if var_35_0 then
			if var_35_16.response then
				var_35_0(var_35_16.response, var_35_3, true, 0)
			else
				var_35_0(var_35_16.response, var_35_3, true, 1)
			end
		end
		
		var_35_16:release()
	end)
	
	local var_35_17 = string.format("%s%s", var_35_2, arg_35_1)
	
	if var_35_3 then
		var_35_17 = var_35_17 .. "?_qid=" .. QueryList.count
	end
	
	var_35_16:open("POST", var_35_17)
	var_35_16:send(var_35_14)
end
