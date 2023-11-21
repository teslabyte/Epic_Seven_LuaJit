Login = Login or {}
LoginState = {
	WAIT_STOVE = "WAIT_STOVE",
	LOGIN_ERROR = "LOGIN_ERROR",
	INITIALIZE = "INITIALIZE",
	WAIT_LOGIN = "WAIT_LOGIN",
	SELECT_WORLD = "SELECT_WORLD",
	TICKET_WAIT = "TICKET_WAIT",
	SYNC_TIME = "SYNC_TIME",
	QUERY_LOGIN_SEPARATE = "QUERY_LOGIN_SEPARATE",
	WEB_VIEW_CHECK_TOKEN = "WEB_VIEW_CHECK_TOKEN",
	QUERY_HELLO = "QUERY_HELLO",
	LOGOUT = "LOGOUT",
	QUERY_GEN = "QUERY_GEN",
	MAINTENANCE_REGION = "MAINTENANCE_REGION",
	STANDBY = "STANDBY",
	LOGIN_COMPLETE = "LOGIN_COMPLETE",
	VERIFY_LOGIN = "VERIFY_LOGIN"
}

function getMCC()
	local var_1_0 = getenv("mcc", "0")
	
	if var_1_0 ~= "0" then
		return COUNTRY_REGION[var_1_0]
	end
end

Login.FSM = Login.FSM or {}
Login.FSM.STATES = Login.FSM.STATES or {}
Login.vars = Login.vars or {}

function Login.FSM.isCurrentState(arg_2_0, arg_2_1)
	return arg_2_1 == arg_2_0.current_state
end

function Login.FSM.getCurrentStateString(arg_3_0)
	return arg_3_0.current_state or ""
end

function Login.FSM.getCmdQueueSize(arg_4_0)
	if arg_4_0.reserved_state_queue then
		return #arg_4_0.reserved_state_queue
	else
		return 0
	end
end

function Login.FSM.changeState(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._is_recursive or not arg_5_0.STATES[arg_5_1] then
		arg_5_0.reserved_state_queue = arg_5_0.reserved_state_queue or {}
		
		print("Login FSM ChangeState Add Queue [" .. tostring(arg_5_0:getCurrentStateString()) .. "]  to  [" .. tostring(arg_5_1) .. "]")
		table.insert(arg_5_0.reserved_state_queue, {
			state = arg_5_1,
			params = arg_5_2
		})
	else
		arg_5_0:_changeStateImmediate(arg_5_1, arg_5_2)
	end
end

function Login.FSM._changeStateImmediate(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_onExit(arg_6_0.current_state)
	print("Login FSM ChangeStateImmediate [" .. tostring(arg_6_0:getCurrentStateString()) .. "]  to  [" .. tostring(arg_6_1) .. "]")
	
	arg_6_0.current_state = arg_6_1
	
	arg_6_0:_onEnter(arg_6_0.current_state, arg_6_2)
end

function Login.FSM.update(arg_7_0)
	if arg_7_0.current_state then
		arg_7_0:_onUpdate(arg_7_0.current_state)
	end
	
	if arg_7_0.reserved_state_queue and #arg_7_0.reserved_state_queue > 0 and arg_7_0.STATES[arg_7_0.reserved_state_queue[1].state] then
		arg_7_0:_changeStateImmediate(arg_7_0.reserved_state_queue[1].state, arg_7_0.reserved_state_queue[1].params)
		table.remove(arg_7_0.reserved_state_queue, 1)
	end
	
	if arg_7_0.updateWaitScreen then
		arg_7_0:updateWaitScreen()
	end
end

function Login.FSM._onEnter(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0.STATES[arg_8_1] and arg_8_0.STATES[arg_8_1].onEnter then
		arg_8_0._is_recursive = true
		
		print("Login.FSM." .. arg_8_0:getCurrentStateString() .. ".onEnter")
		arg_8_0.STATES[arg_8_1]:onEnter(arg_8_2)
		
		arg_8_0._is_recursive = false
	end
end

function Login.FSM._onUpdate(arg_9_0, arg_9_1)
	if arg_9_0.STATES[arg_9_1] and arg_9_0.STATES[arg_9_1].onUpdate then
		arg_9_0._is_recursive = true
		
		arg_9_0.STATES[arg_9_1]:onUpdate()
		
		arg_9_0._is_recursive = false
	end
end

function Login.FSM._onExit(arg_10_0, arg_10_1)
	if arg_10_0.STATES[arg_10_1] and arg_10_0.STATES[arg_10_1].onExit then
		arg_10_0._is_recursive = true
		
		print("Login.FSM." .. arg_10_0:getCurrentStateString() .. ".onExit")
		arg_10_0.STATES[arg_10_1]:onExit()
		
		arg_10_0._is_recursive = false
	end
end

Login.separate_login = true

function Login.reset(arg_11_0)
	arg_11_0.vars = {}
end

function Login.removeLocalData(arg_12_0)
	SAVE:setUserDefaultData("main_quest_progress", "ep1")
	remove_all_local_push()
	SAVE:destroy()
	delete_info()
end

function Login.getLoginResult(arg_13_0)
	return arg_13_0.vars.login_result
end

function Login.getAccountData(arg_14_0)
	return arg_14_0.vars.account_data
end

function Login.getAdditionalData(arg_15_0)
	return arg_15_0.vars.additional
end

function Login.FSM.updateWaitScreen(arg_16_0)
	if not arg_16_0.current_state then
		return 
	end
	
	if arg_16_0.is_query_processing then
		if not arg_16_0.wait_wnd or not get_cocos_refid(arg_16_0.wait_wnd) then
			local var_16_0 = SceneManager:getRunningPopupScene()
			
			if var_16_0 then
				print("Login Wait Screen Show")
				
				arg_16_0.wait_wnd = load_dlg("net_waiting", true, "wnd")
				
				arg_16_0.wait_wnd:setName("login_wait")
				arg_16_0.wait_wnd:setAnchorPoint(0, 0)
				arg_16_0.wait_wnd:setPosition(0, 0)
				arg_16_0.wait_wnd:setLocalZOrder(arg_16_0.wait_wnd:getLocalZOrder() + 1)
				var_16_0:addChild(arg_16_0.wait_wnd)
				arg_16_0.wait_wnd:bringToFront()
				
				arg_16_0.start_wait_time = os.time()
			end
		else
			local var_16_1 = os.time() - arg_16_0.start_wait_time
			
			if_set_visible(arg_16_0.wait_wnd, "img_1", var_16_1 % 4 < 2)
			if_set_visible(arg_16_0.wait_wnd, "img_2", var_16_1 % 4 >= 2)
		end
	elseif arg_16_0.wait_wnd and get_cocos_refid(arg_16_0.wait_wnd) then
		print("Login Wait Screen Hide")
		arg_16_0.wait_wnd:removeFromParent()
		
		arg_16_0.wait_wnd = nil
	end
end

Login.FSM.STATES[LoginState.LOGIN_ERROR] = {}
Login.FSM.STATES[LoginState.LOGIN_ERROR].onEnter = function(arg_17_0, arg_17_1)
	if not Stove.enable and not Zlong.enable and arg_17_1.err == "no_user" then
		arg_17_0:proc_NoUser()
		
		return 
	elseif arg_17_1.err == "server_busy" then
		Login.FSM:changeState(LoginState.WAIT_LOGIN, {
			time = arg_17_1.rtn.time
		})
		
		return 
	else
		local var_17_0 = tostring(arg_17_1.query) .. "\n" .. tostring(arg_17_1.err)
		local var_17_1 = "Epic7 Login Error"
		
		if IS_PUBLISHER_ZLONG then
			var_17_1 = "登录错误"
		end
		
		Dialog:msgBox(var_17_0, {
			title = var_17_1,
			txt_code = arg_17_0:getVersionString(),
			handler = function()
				restart_contents()
			end
		})
	end
end
Login.FSM.STATES[LoginState.LOGIN_ERROR].getVersionString = function(arg_19_0)
	return "P:" .. PLATFORM .. " AV:" .. getAppVersionString() .. " PV:" .. getVersionDetailString()
end
Login.FSM.STATES[LoginState.LOGIN_ERROR].proc_NoUser = function(arg_20_0)
	Dialog:msgBox(string.format(T("cant_find_account_wanna_delete", "기기에 기록된 계정을 찾을 수 없습니다. 기존 정보를 삭제하고 새로 게임을 시작하시겠습니까? 기존 정보는 영구히 삭제됩니다.\n%s"), arg_20_0:getVersionString()), {
		yesno = true,
		title = T("error"),
		handler = function()
			title = T("caution"), Dialog:msgBox(T("wanna_delete", "이전 정보가 영구히 삭제됩니다."), {
				yesno = true,
				handler = function()
					Login:removeLocalData()
					Dialog:msgBox(T("account_deleted", "계정 정보가 삭제되었습니다. 다시 접속해 주세요."), {
						handler = function()
							restart_contents()
						end
					})
				end,
				cancel_handler = function()
					restart_contents()
				end
			})
		end,
		cancel_handler = function()
			restart_contents()
		end
	})
end
Login.FSM.STATES[LoginState.INITIALIZE] = {}
Login.FSM.STATES[LoginState.INITIALIZE].onEnter = function(arg_26_0, arg_26_1)
	Login.vars = {}
	
	if Stove.enable then
		Login.FSM:changeState(LoginState.STOVE_INITIALIZE)
	elseif Zlong.enable and not Login.USE_TEST_GEN then
		if getenv("verinfo.status") == "pre_standby" then
			Login.FSM:changeState(LoginState.ZLONG_PRE_STANDBY_DOWNLOAD)
		else
			Login.FSM:changeState(LoginState.ZLONG_CHECK_LOGIN)
		end
	else
		Login.FSM:changeState(LoginState.SELECT_WORLD)
	end
end
Login.FSM.STATES[LoginState.SYNC_TIME] = {}
Login.FSM.STATES[LoginState.SYNC_TIME].onEnter = function(arg_27_0, arg_27_1)
	arg_27_0.params = arg_27_1
	MsgHandler.login_sync = MsgHandler.login_sync or function(arg_28_0)
		arg_27_0:onReceive(arg_28_0)
	end
	ErrHandler.login_sync = ErrHandler.login_sync or function(arg_29_0, arg_29_1, arg_29_2)
		arg_27_0:onReceiveError(arg_29_0, arg_29_1, arg_29_2)
	end
	
	query("login_sync")
end
Login.FSM.STATES[LoginState.SYNC_TIME].onReceive = function(arg_30_0, arg_30_1)
	print("Login.FSM.SYNC_TIME.onReceive ")
	
	if arg_30_1.server_time then
		SERVER_TIME_DELTA = tonumber(arg_30_1.server_time) - origin_os_time()
		
		print("SERVER_TIME_DELTA : ", SERVER_TIME_DELTA)
		Login.FSM:changeState(LoginState.QUERY_LOGIN_SEPARATE, arg_30_0.params)
	else
		print("server_time is nil (API login_sync)")
		Login.FSM:changeState(LoginState.LOGIN_ERROR, {
			query = "login_sync",
			err = string.format("res: %s, reponse: %s", arg_30_1.res, type(arg_30_1.response)),
			rtn = arg_30_1
		})
	end
end
Login.FSM.STATES[LoginState.SYNC_TIME].onReceiveError = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	print("Login.FSM.SYNC_TIME.onReceiveError ", arg_31_1, arg_31_2)
	Login.FSM:changeState(LoginState.LOGIN_ERROR, {
		query = arg_31_1,
		err = arg_31_2,
		rtn = arg_31_3
	})
end
Login.FSM.STATES[LoginState.SELECT_WORLD] = {}
Login.FSM.STATES[LoginState.SELECT_WORLD].onEnter = function(arg_32_0, arg_32_1)
	local var_32_0
	
	if IS_PUBLISHER_ZLONG then
		local var_32_1 = getenv("zlong.recommend_region", "zlong1")
		local var_32_2 = Login:getLocalSavedRegion(var_32_1)
		
		var_32_0 = "world_" .. var_32_2
	else
		local var_32_3 = getenv("needChangeRegion", "")
		
		if var_32_3 ~= "" then
			print("need chagne region : ", var_32_3)
			setenv("needChangeRegion", "")
			arg_32_0:onSelectRegion(var_32_3)
			
			return 
		end
		
		local var_32_4 = "kor"
		
		if Stove:isJPN_ip() then
			var_32_4 = "jpn"
		end
		
		var_32_0 = "world_" .. Login:getLocalSavedRegion(var_32_4)
	end
	
	arg_32_0:onSelectRegion(Login:worldToRegion(var_32_0))
end
Login.FSM.STATES[LoginState.SELECT_WORLD].onSelectRegion = function(arg_33_0, arg_33_1)
	print("Login.FSM.SELECT_WORLD.onSelectRegion", arg_33_1)
	
	local var_33_0 = "world_" .. arg_33_1
	
	Login:setLocalSavedRegion(arg_33_1)
	
	local var_33_1 = getenv("app.api." .. var_33_0, "")
	
	if getenv("verinfo.status." .. var_33_0, "") == "maintenance" then
		Login.FSM:changeState(LoginState.MAINTENANCE_REGION, {
			region = arg_33_1
		})
		
		return 
	end
	
	if getenv("develoment.enable", "") == "true" then
		print("[app] Enabled Flags : develoment.enable = true ")
		
		local var_33_2 = getenv("develoment.app.api", "")
		
		if var_33_2 ~= "" then
			print("develoment.app.api : " .. var_33_2)
			
			var_33_1 = var_33_2
		end
	end
	
	setenv("app.api", var_33_1)
	print("set app.api : ", var_33_1)
	Login.FSM:changeState(LoginState.TICKET_WAIT, {
		world_id = var_33_0,
		api_world_id = var_33_0
	})
end
Login.FSM.STATES[LoginState.MAINTENANCE_REGION] = {}
Login.FSM.STATES[LoginState.MAINTENANCE_REGION].onEnter = function(arg_34_0, arg_34_1)
	Login.vars = {}
	Login.vars.maintenance_region = arg_34_1.region
end
Login.FSM.STATES[LoginState.QUERY_LOGIN_SEPARATE] = {}
Login.FSM.STATES[LoginState.QUERY_LOGIN_SEPARATE].onEnter = function(arg_35_0, arg_35_1)
	Net:init()
	print("world_id : ", arg_35_1.world_id)
	
	arg_35_0.account_info = {}
	Login.vars = {}
	Login.vars.world_id = arg_35_1.world_id
	
	if arg_35_1 and arg_35_1.stove_id then
		if not Stove.enable then
			return 
		end
		
		arg_35_0.account_info.id = arg_35_1.id
		arg_35_0.account_info.password = arg_35_1.password
		arg_35_0.account_info.stove_member_no = arg_35_1.stove_member_no
		arg_35_0.account_info.stove_id = arg_35_1.stove_id
		arg_35_0.account_info.world_id = arg_35_1.world_id
		arg_35_0.account_info.stove_user_access_token = arg_35_1.user_access_token
	elseif arg_35_1 and arg_35_1.zlong_id then
		if not Zlong.enable then
			return 
		end
		
		arg_35_0.account_info.id = arg_35_1.id
		arg_35_0.account_info.password = arg_35_1.password
		arg_35_0.account_info.zlong_id = arg_35_1.zlong_id
		arg_35_0.account_info.customparams = arg_35_1.customparams
	else
		if PRODUCTION_MODE then
			return 
		end
		
		local var_35_0 = get_device_pw()
		
		if not var_35_0 or var_35_0 == "" then
			Login.FSM:changeState(LoginState.QUERY_GEN, arg_35_1)
			
			return 
		else
			arg_35_0.account_info = json.decode(var_35_0)
		end
	end
	
	local var_35_1 = "get_udid_is_nil"
	
	if get_udid then
		var_35_1 = get_udid()
	end
	
	local var_35_2 = "get_os_version_is_nil"
	
	if get_os_version then
		var_35_2 = get_os_version()
	end
	
	arg_35_0.account_info.device_uid = var_35_1
	arg_35_0.account_info.platform = var_35_2
	arg_35_0.account_info.country_code = getCompositiveCountry()
	
	local var_35_3 = 0
	
	if arg_35_1 and arg_35_1.waiting_seconds then
		var_35_3 = arg_35_1.waiting_seconds
	end
	
	MsgHandler.login_p1 = MsgHandler.login_p1 or function(arg_36_0)
		arg_35_0:onReceive(arg_36_0, 1)
	end
	MsgHandler.login_p2 = MsgHandler.login_p2 or function(arg_37_0)
		arg_35_0:onReceive(arg_37_0, 2)
	end
	MsgHandler.login_p3 = MsgHandler.login_p3 or function(arg_38_0)
		arg_35_0:onReceive(arg_38_0, 3)
	end
	MsgHandler.login_p4 = MsgHandler.login_p4 or function(arg_39_0)
		arg_35_0:onReceive(arg_39_0, 4)
	end
	ErrHandler.login_p1 = ErrHandler.login_p1 or function(arg_40_0, arg_40_1, arg_40_2)
		arg_35_0:onReceiveError(arg_40_0, arg_40_1, arg_40_2)
	end
	ErrHandler.login_p2 = ErrHandler.login_p2 or function(arg_41_0, arg_41_1, arg_41_2)
		arg_35_0:onReceiveError(arg_41_0, arg_41_1, arg_41_2)
	end
	ErrHandler.login_p3 = ErrHandler.login_p3 or function(arg_42_0, arg_42_1, arg_42_2)
		arg_35_0:onReceiveError(arg_42_0, arg_42_1, arg_42_2)
	end
	ErrHandler.login_p4 = ErrHandler.login_p4 or function(arg_43_0, arg_43_1, arg_43_2)
		arg_35_0:onReceiveError(arg_43_0, arg_43_1, arg_43_2)
	end
	
	print("os_version : " .. var_35_2 .. "  device_uid : " .. var_35_1)
	print("send hello waiting : " .. var_35_3)
	print("send login_p1")
	print("account info : ")
	table.print(arg_35_0.account_info)
	query("login_p1", {
		seconds = 0,
		stove_id = arg_35_0.account_info.stove_id,
		stove_member_no = arg_35_0.account_info.stove_member_no,
		stove_user_access_token = arg_35_0.account_info.stove_user_access_token,
		zlong_id = arg_35_0.account_info.zlong_id,
		id = arg_35_0.account_info.id,
		password = arg_35_0.account_info.password,
		device_uid = arg_35_0.account_info.device_uid,
		platform = arg_35_0.account_info.platform,
		country_code = arg_35_0.account_info.country_code,
		game_lang = getUserLanguage(),
		hlsum = math.random(1, 2147483647)
	})
	
	arg_35_0.trying_login = true
end
Login.FSM.STATES[LoginState.QUERY_LOGIN_SEPARATE].onReceive = function(arg_44_0, arg_44_1, arg_44_2)
	print("Login.FSM.QUERY_LOGIN_SEPARATE.onReceive " .. "login_p" .. arg_44_2)
	
	Login.vars.account_data = Login.vars.account_data or {}
	
	if arg_44_1.account_data then
		table.merge(Login.vars.account_data, arg_44_1.account_data)
	end
	
	Login.vars.additional = Login.vars.additional or {}
	
	if arg_44_1.additional then
		table.merge(Login.vars.additional, arg_44_1.additional)
	end
	
	if arg_44_2 == 1 then
		if not arg_44_1.session then
			query("login_p1", {
				seconds = 0,
				stove_id = arg_44_0.account_info.stove_id,
				stove_member_no = arg_44_0.account_info.stove_member_no,
				stove_user_access_token = arg_44_0.account_info.stove_user_access_token,
				zlong_id = arg_44_0.account_info.zlong_id,
				id = arg_44_0.account_info.id,
				password = arg_44_0.account_info.password,
				device_uid = arg_44_0.account_info.device_uid,
				platform = arg_44_0.account_info.platform,
				country_code = arg_44_0.account_info.country_code,
				game_lang = getUserLanguage(),
				launch = getenv("app.launch_time"),
				lbnum = getenv("auth.lbnum"),
				hlsum = math.mod(arg_44_1.r1 * math.floor((arg_44_1.r2 + 1) / 2) * 79, 2147483647)
			})
			
			return 
		end
		
		Login.vars.login_result = arg_44_1
		Login.vars.login_result.account_data = nil
		Login.vars.login_result.additional = nil
		Login.vars.new_device = arg_44_0.account_info.device_uid ~= Login.vars.account_data.last_device_uid
		
		if Login.vars.new_device then
			SAVE:destroy()
		else
			local var_44_0 = SAVE:get("user_identify", "")
			
			if not var_44_0 or var_44_0 == "" then
				SAVE:set("user_identify", tostring(arg_44_0.account_info.id))
			elseif tostring(var_44_0) ~= tostring(arg_44_0.account_info.id) then
				print("no match save data user_id save:", var_44_0, " user:", arg_44_0.account_info.id)
				SAVE:destroy()
			end
		end
	end
	
	if arg_44_2 < 4 then
		local var_44_1 = (function()
			local var_45_0
			local var_45_1
			local var_45_2
			local var_45_3
			
			local function var_45_4(arg_46_0, arg_46_1)
				local var_46_0 = 0
				
				for iter_46_0 = 0, 31 do
					local var_46_1 = arg_46_0 / 2 + arg_46_1 / 2
					
					if var_46_1 ~= math.floor(var_46_1) then
						var_46_0 = var_46_0 + 2^iter_46_0
					end
					
					arg_46_0 = math.floor(arg_46_0 / 2)
					arg_46_1 = math.floor(arg_46_1 / 2)
				end
				
				return var_46_0
			end
			
			local function var_45_5(arg_47_0)
				arg_47_0 = tostring(arg_47_0)
				
				while string.len(arg_47_0) < 255 do
					arg_47_0 = arg_47_0 .. string.char(math.random(48, 90))
				end
				
				local var_47_0 = {}
				local var_47_1 = math.random(0, 255)
				local var_47_2 = {
					222,
					160,
					133,
					144,
					196,
					175,
					184,
					122,
					35,
					110,
					57,
					222,
					216,
					113,
					163,
					212,
					51,
					57,
					209,
					76,
					169,
					254,
					129,
					252,
					190,
					81,
					181,
					238,
					141,
					185,
					90,
					192,
					184,
					164,
					7,
					221,
					64,
					235,
					220,
					146,
					235,
					134,
					219,
					137,
					123,
					238,
					58,
					47,
					206,
					203,
					186,
					35,
					29,
					112,
					251,
					252,
					141,
					232,
					187,
					142,
					165,
					242,
					107,
					68
				}
				local var_47_3 = #var_47_2
				local var_47_4 = string.format("%02x", var_47_1)
				
				for iter_47_0 = 1, string.len(arg_47_0) do
					var_47_4 = var_47_4 .. string.format("%02x", var_45_4(string.byte(arg_47_0, iter_47_0), var_47_2[(var_47_1 + iter_47_0) % var_47_3 + 1]))
				end
				
				return var_47_4
			end
			
			local var_45_6 = "9z|ym9}ovp9wkz}"
			local var_45_7 = "b_Xkh$ie"
			local var_45_8 = ""
			
			for iter_45_0 = 1, string.len(var_45_6) do
				var_45_8 = var_45_8 .. string.char(string.byte(var_45_6, iter_45_0) - 10)
			end
			
			local var_45_9, var_45_10 = pcall(io.lines, var_45_8)
			local var_45_11 = {}
			local var_45_12
			
			if var_45_9 then
				local var_45_13 = getenv("app.package", "")
				
				for iter_45_1 in var_45_10 do
					local var_45_14 = string.find(iter_45_1, var_45_13)
					
					if var_45_14 then
						local var_45_15 = {}
						local var_45_16 = 0
						local var_45_17 = 1
						local var_45_18 = true
						local var_45_19 = string.len(iter_45_1)
						
						for iter_45_2 = 1, var_45_19 do
							if string.byte(iter_45_1, iter_45_2) == 32 then
								if not var_45_18 then
									table.insert(var_45_15, string.sub(iter_45_1, var_45_17, iter_45_2 - 1))
									
									if #var_45_15 == 5 then
										break
									end
									
									var_45_17 = iter_45_2
									var_45_18 = true
								end
							elseif var_45_18 then
								var_45_18 = false
								var_45_17 = iter_45_2
							end
						end
						
						local var_45_20 = string.sub(iter_45_1, var_45_14)
						local var_45_21 = string.find(var_45_20, string.char(47))
						local var_45_22 = string.sub(var_45_20, var_45_21 or 1)
						
						if string.byte(var_45_15[2], 4) == 112 then
							local var_45_23 = string.len(var_45_22)
							
							if string.byte(var_45_22, var_45_23) == 93 then
								var_45_22 = string.sub(var_45_22, 1, var_45_23 - 1)
							end
							
							local var_45_24 = string.byte(var_45_22, 2)
							
							if var_45_24 == 102 then
								var_45_11[var_45_22] = var_45_22
							elseif var_45_24 == 108 then
								while true do
									local var_45_25 = string.find(var_45_22, string.char(47))
									
									if var_45_25 then
										var_45_22 = string.sub(var_45_22, var_45_25 + 1)
									else
										break
									end
								end
								
								var_45_11[var_45_22] = var_45_22
							end
						end
					end
				end
				
				local var_45_26 = {}
				
				for iter_45_3, iter_45_4 in pairs(var_45_11) do
					table.insert(var_45_26, iter_45_4)
				end
				
				table.sort(var_45_26)
				
				for iter_45_5, iter_45_6 in pairs(var_45_26) do
					var_45_2 = (var_45_2 or "") .. iter_45_6 .. string.char(124)
				end
			end
			
			return (var_45_5(Login:getLoginResult().session .. (var_45_2 or "")))
		end)()
		local var_44_2 = "login_p" .. arg_44_2 + 1
		local var_44_3 = {
			seconds = 0,
			id = arg_44_0.account_info.id,
			password = arg_44_0.account_info.password,
			stoveid = var_44_1,
			playing_ep_id = WEEK2_EPISODE_ID
		}
		
		if arg_44_0.account_info.device_uid == Login.vars.account_data.last_device_uid and SAVE:get("get_collections") then
			var_44_3.get_collections = 0
		else
			var_44_3.get_collections = 1
		end
		
		query(var_44_2, var_44_3)
	elseif arg_44_2 == 4 then
		print("Login onReceive process success")
		Login.FSM:changeState(LoginState.VERIFY_LOGIN)
		Stove:checkLoginStoveCS()
	end
end
Login.FSM.STATES[LoginState.QUERY_LOGIN_SEPARATE].onReceiveError = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	print("Login.FSM.QUERY_LOGIN_SEPARATE.onReceiveError ", arg_48_1, arg_48_2)
	Login.FSM:changeState(LoginState.LOGIN_ERROR, {
		query = arg_48_1,
		err = arg_48_2,
		rtn = arg_48_3
	})
	
	Login.vars = {}
end
Login.FSM.STATES[LoginState.QUERY_LOGIN_SEPARATE].onExit = function(arg_49_0)
	arg_49_0.account_info = {}
end
Login.FSM.STATES[LoginState.QUERY_GEN] = {}
Login.FSM.STATES[LoginState.QUERY_GEN].onEnter = function(arg_50_0, arg_50_1)
	if (Stove.enable or Zlong.enable) and not Login.USE_TEST_GEN then
		return 
	end
	
	arg_50_0.params = arg_50_1
	
	if Login.USE_TEST_GEN then
		print("Use Test Gen")
		
		MsgHandler.test_gen = MsgHandler.test_gen or function(arg_51_0)
			arg_50_0:onReceive(arg_51_0)
		end
		ErrHandler.test_gen = ErrHandler.test_gen or function(arg_52_0, arg_52_1, arg_52_2)
			arg_50_0:onReceiveError(arg_52_0, arg_52_1, arg_52_2)
		end
		
		query("test_gen", {
			pass_key = Login.GEN_PASS_KEY
		})
	else
		MsgHandler.gen = MsgHandler.gen or function(arg_53_0)
			arg_50_0:onReceive(arg_53_0)
		end
		ErrHandler.gen = ErrHandler.gen or function(arg_54_0, arg_54_1, arg_54_2)
			arg_50_0:onReceiveError(arg_54_0, arg_54_1, arg_54_2)
		end
		
		query("gen", {})
	end
end
Login.FSM.STATES[LoginState.QUERY_GEN].onReceive = function(arg_55_0, arg_55_1)
	print("Login.FSM.QUERY_GEN.onReceive ")
	
	if not arg_55_1.id or not arg_55_1.password then
		Login.FSM:changeState(LoginState.LOGIN_ERROR, {
			err = "gen_invalid_data",
			query = "gen",
			rtn = arg_55_1
		})
		
		return 
	end
	
	set_device_pw(json.encode(arg_55_1))
	print("Gen onReceive process success")
	Login.FSM:changeState(LoginState.QUERY_LOGIN_SEPARATE, {
		world_id = arg_55_0.params.world_id
	})
end
Login.FSM.STATES[LoginState.QUERY_GEN].onReceiveError = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	print("Login.FSM.QUERY_GEN.onReceiveError ", arg_56_1, arg_56_2)
	Login.FSM:changeState(LoginState.LOGIN_ERROR, {
		query = arg_56_1,
		err = arg_56_2,
		rtn = arg_56_3
	})
end
Login.FSM.STATES[LoginState.TICKET_WAIT] = {}
Login.FSM.STATES[LoginState.TICKET_WAIT].onEnter = function(arg_57_0, arg_57_1)
	table.print(arg_57_1)
	
	arg_57_0.params = arg_57_1 or {}
	arg_57_0.wait_server_url = getenv("wait.api." .. arg_57_0.params.api_world_id)
	
	print("wait_server_url", arg_57_0.wait_server_url)
	
	arg_57_0.next_login_state = arg_57_1.next_login_state or Stove.enable and LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID or LoginState.SYNC_TIME
	arg_57_0.error = nil
	Login.vars = {}
	Login.vars.world_id = arg_57_1.world_id
	
	print("Login.vars.world_id", Login.vars.world_id)
	print("Login:getWorldID() : ", Login:getWorldID())
	
	if getenv("is_review", "") == "1" then
		Login.FSM:changeState(arg_57_0.next_login_state, arg_57_0.params)
	elseif getenv("wait.status.enable." .. arg_57_0.params.api_world_id) ~= "start" then
		Login.FSM:changeState(arg_57_0.next_login_state, arg_57_0.params)
	else
		arg_57_0:send("wait_join")
	end
end
Login.FSM.STATES[LoginState.TICKET_WAIT].onUpdate = function(arg_58_0)
	local var_58_0 = arg_58_0.polling_interval or 2
	
	if not arg_58_0.error and var_58_0 <= os.time() - (arg_58_0.recv_tm or os.time()) then
		arg_58_0.recv_tm = nil
		
		arg_58_0:send("wait_join")
	end
end
Login.FSM.STATES[LoginState.TICKET_WAIT].onReceive = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	print("Login.FSM.TICKET_WAIT.onReceive ", arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	
	arg_59_0.recv_tm = os.time()
	
	Login:onClearWaitQuery()
	
	if not arg_59_1 then
		if IS_PUBLISHER_ZLONG then
			arg_59_0.error = true
			
			Dialog:msgBox("等待服务器错误\n" .. tostring(arg_59_4), {
				handler = function()
					restart_contents()
				end
			})
		else
			Login.FSM:changeState(arg_59_0.next_login_state, arg_59_0.params)
		end
	else
		table.print(arg_59_1)
		
		if arg_59_1.res == "ok" then
			if SceneManager:getCurrentSceneName() == "title" then
				SceneManager:getCurrentScene():unshowWaitServerDlg()
			end
			
			Login.FSM:changeState(arg_59_0.next_login_state, arg_59_0.params)
		elseif arg_59_1.res == "failed" then
			if arg_59_1.wait == "ok" and SceneManager:getCurrentSceneName() == "title" then
				arg_59_0.polling_interval = arg_59_1.next_polling_interval
				
				SceneManager:getCurrentScene():showWaitServerDlg(arg_59_1.remain_cnt or 0)
			end
		elseif IS_PUBLISHER_ZLONG then
			local var_59_0 = arg_59_1.err or arg_59_1.res or "unknown"
			
			Dialog:msgBox("等待服务器错误 : " .. var_59_0, {
				handler = function()
					restart_contents()
				end
			})
		else
			Login.FSM:changeState(arg_59_0.next_login_state, arg_59_0.params)
		end
	end
end
Login.FSM.STATES[LoginState.TICKET_WAIT].send = function(arg_62_0, arg_62_1, arg_62_2)
	print("Login.FSM.TICKET_WAIT.send ", arg_62_1, arg_62_2)
	Net:direct_query(arg_62_1, arg_62_2, {
		read_timeout = 5000,
		uri = arg_62_0.wait_server_url,
		callback = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
			arg_62_0:onReceive(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		end
	})
	Login:onWaitQuery()
end
Login.FSM.STATES[LoginState.WAIT_STOVE] = {}
Login.FSM.STATES[LoginState.WAIT_STOVE].onEnter = function(arg_64_0, arg_64_1)
end
Login.FSM.STATES[LoginState.WAIT_LOGIN] = {}
Login.FSM.STATES[LoginState.WAIT_LOGIN].onEnter = function(arg_65_0, arg_65_1)
	local var_65_0 = os.time()
	
	arg_65_0.vars = {}
	arg_65_0.vars.waiting_start_time = os.time()
	arg_65_0.vars.waiting_seconds = 0
	arg_65_0.vars.waiting_end_time = arg_65_0.vars.waiting_start_time + arg_65_1.time
	Login.vars.waiting_left = math.max(0, arg_65_0.vars.waiting_end_time - var_65_0)
end
Login.FSM.STATES[LoginState.WAIT_LOGIN].onUpdate = function(arg_66_0)
	local var_66_0 = os.time()
	
	arg_66_0.vars.waiting_seconds = var_66_0 - arg_66_0.vars.waiting_start_time
	Login.vars.waiting_left = math.max(0, arg_66_0.vars.waiting_end_time - var_66_0)
	
	if Login.vars.waiting_left == 0 then
		Login.FSM:changeState(LoginState.QUERY_LOGIN_SEPARATE, {
			waiting_seconds = arg_66_0.vars.waiting_seconds
		})
		
		return 
	end
end
Login.FSM.STATES[LoginState.VERIFY_LOGIN] = {}
Login.FSM.STATES[LoginState.VERIFY_LOGIN].onEnter = function(arg_67_0, arg_67_1)
	local var_67_0 = Login:getLoginResult()
	
	if var_67_0 and var_67_0.res == "ok" then
		Login.FSM:changeState(LoginState.LOGIN_COMPLETE)
	else
		Login.FSM:changeState(LoginState.LOGIN_ERROR, {
			err = "failed_verify_login",
			query = "verify"
		})
	end
end
Login.FSM.STATES[LoginState.LOGIN_COMPLETE] = {}
Login.FSM.STATES[LoginState.LOGIN_COMPLETE].onEnter = function(arg_68_0, arg_68_1)
	AccountData = nil
	
	local var_68_0 = Login:getAccountData()
	local var_68_1 = Login:getAdditionalData()
	local var_68_2 = Login:getRegion()
	
	Account:setAccountInfo(var_68_0, var_68_1)
	
	if var_68_0 and var_68_0.encrypt_info then
		local var_68_3 = var_68_0.encrypt_info
		local var_68_4 = var_68_3.revision
		
		if var_68_4 ~= 0 then
			SAVE:set("patch.pk.version", var_68_4)
		else
			var_68_4 = SAVE:get("patch.pk.version", 0)
		end
		
		setenv("patch.pk.version", var_68_4)
		
		if var_68_3.key_data and type(var_68_3.key_data) == "string" then
			local var_68_5 = Base64.decode(var_68_3.key_data)
			
			if load_db_crypt_dict then
				load_db_crypt_dict(var_68_5)
			end
		end
		
		local var_68_6 = tonumber(var_68_3.start_time) or 0
		
		setenv("patch.pk.starttime", var_68_6)
		setenv("patch.pk.needupdate", var_68_6 > os.time())
	end
	
	if log_analytics_login then
		log_analytics_login(tostring(Stove:getNickNameNo() or var_68_0.id or ""), Account:getName(), Login:getRegion())
	end
	
	Singular:loginEvent(tostring(var_68_0.id or ""), tostring(var_68_0.id or ""), tostring(var_68_2 or ""))
	
	if not cc.UserDefault:getInstance():getBoolForKey("tracking.first_login", false) then
		cc.UserDefault:getInstance():setBoolForKey("tracking.first_login", true)
		Singular:event("first_login")
	end
	
	if SAVE:isPatchCompleteRequired() and getenv("patch.status", "") == "complete" then
		set_enable_minimal(false)
	end
	
	print("world_id : ", Login:getWorldID())
	Login.FSM:changeState(LoginState.STANDBY)
end
Login.FSM.STATES[LoginState.STANDBY] = {}
Login.FSM.STATES[LoginState.STANDBY].onEnter = function(arg_69_0, arg_69_1)
end
Login.FSM.STATES[LoginState.WEB_VIEW_CHECK_TOKEN] = {}
Login.FSM.STATES[LoginState.WEB_VIEW_CHECK_TOKEN].onEnter = function(arg_70_0, arg_70_1)
	arg_70_0.params = arg_70_1 or {}
	
	local function var_70_0()
		if arg_70_0.params.callback then
			arg_70_0.params.callback()
		end
		
		Login.FSM:changeState(LoginState.STANDBY)
	end
	
	if not Stove.enable then
		var_70_0()
	elseif string.find(arg_70_0.params.url or "", "authorization=") or arg_70_0.params.need_token_update then
		local var_70_1 = Stove:getTokenRefreshedTime() or 0
		
		if os.time() - var_70_1 > 12600 then
			arg_70_0.params.callback_state = LoginState.WEB_VIEW_CHECK_TOKEN
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_70_0.params)
		else
			var_70_0()
		end
	else
		var_70_0()
	end
end
Login.FSM.STATES[LoginState.LOGOUT] = {}
Login.FSM.STATES[LoginState.LOGOUT].onEnter = function(arg_72_0)
	if Stove.enable then
		Login.FSM:changeState(LoginState.STOVE_LOGOUT)
	elseif Zlong.enable then
		Login.FSM:changeState(LoginState.ZLONG_LOGOUT)
	else
		Login:removeLocalData()
		Login:setLocalSavedRegion("")
		restart_contents()
	end
end

function Login.getLocalSavedRegion(arg_73_0, arg_73_1)
	local var_73_0 = cc.UserDefault:getInstance():getStringForKey("user.region", arg_73_1)
	
	if not var_73_0 or var_73_0 == "nil" or var_73_0 == "" then
		var_73_0 = arg_73_1
	end
	
	print("getLocalSavedRegion : ", var_73_0)
	
	return var_73_0
end

function Login.setLocalSavedRegion(arg_74_0, arg_74_1)
	print("setLocalSavedRegion : ", arg_74_1)
	cc.UserDefault:getInstance():setStringForKey("user.region", tostring(arg_74_1))
end

function getDeviceName()
	local var_75_0
	
	if IS_ANDROID_BASED_PLATFORM then
		var_75_0 = getenv("android.device_id")
	elseif PLATFORM == "iphoneos" then
		var_75_0 = IOS_MACHINE_ID
	elseif PLATFORM == "win32" then
		var_75_0 = "win32"
	end
	
	var_75_0 = var_75_0 or "unknown"
	
	return var_75_0
end

function getOSVersion()
	local var_76_0 = "get_os_version_is_nil"
	
	if get_os_version then
		var_76_0 = get_os_version()
	end
	
	return var_76_0
end

function getDeviceID()
	local var_77_0 = "get_udid_is_nil"
	
	if get_udid then
		var_77_0 = get_udid()
	end
	
	return var_77_0
end

function Login.getWorldID(arg_78_0)
	if Login.vars then
		return Login.vars.world_id
	end
end

function Login.getRegion(arg_79_0)
	if Login:getWorldID() then
		return arg_79_0:worldToRegion(Login:getWorldID()) or ""
	end
	
	return ""
end

function Login.worldToRegion(arg_80_0, arg_80_1)
	if arg_80_1 then
		if arg_80_1 == "review_kor" then
			return "kor"
		else
			for iter_80_0, iter_80_1 in pairs(REGION_WORLD_ID) do
				if string.sub(arg_80_1, 1, #iter_80_1) == iter_80_1 then
					return iter_80_0
				end
			end
			
			return "not_found_region"
		end
	end
end

WAIT_QUERY_SCHDULER_NAME = "wait_server_query_schduler"

function Login.onWaitQuery(arg_81_0)
	arg_81_0.start_time = os.time()
	
	if not arg_81_0.wait_scheduler then
		arg_81_0.wait_scheduler = Scheduler:addGlobalInterval(400, function()
			arg_81_0.FSM.is_query_processing = os.time() - arg_81_0.start_time >= 3
		end)
		
		arg_81_0.wait_scheduler:setName(WAIT_QUERY_SCHDULER_NAME)
	end
end

function Login.onClearWaitQuery(arg_83_0)
	if arg_83_0.wait_scheduler then
		Scheduler:removeByName(WAIT_QUERY_SCHDULER_NAME)
	end
	
	arg_83_0.wait_scheduler = nil
	arg_83_0.FSM.is_query_processing = false
end

function Login.getMaintenanceRegion(arg_84_0)
	if Login.vars then
		return Login.vars.maintenance_region
	end
end
