LoginState.STOVE_INITIALIZE = "STOVE_INITIALIZE"
LoginState.STOVE_WAIT_LOGIN = "STOVE_WAIT_LOGIN"
LoginState.STOVE_FETCH_GPGS_ACCOUNT = "STOVE_FETCH_GPGS_ACCOUNT"
LoginState.STOVE_LOGIN = "STOVE_LOGIN"
LoginState.STOVE_CHECK_GUEST_LOGIN = "STOVE_CHECK_GUEST_LOGIN"
LoginState.STOVE_GUEST_LOGIN = "STOVE_GUEST_LOGIN"
LoginState.STOVE_SELECT_WORLD = "STOVE_SELECT_WORLD"
LoginState.STOVE_FETCH_CHARACTER_LIST = "STOVE_FETCH_CHARACTER_LIST"
LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID = "STOVE_SERVER_GET_GAME_ACCOUNT_ID"
LoginState.STOVE_SET_GAME_PROFILE = "STOVE_SET_GAME_PROFILE"
LoginState.STOVE_FETCH_PUSH_SETTING = "STOVE_FETCH_PUSH_SETTING"
LoginState.STOVE_UPDATE_PUSH_SETTING = "STOVE_UPDATE_PUSH_SETTING"
LoginState.STOVE_LOGOUT = "STOVE_LOGOUT"
LoginState.STOVE_SERVER_UNREGISTER = "STOVE_SERVER_UNREGISTER"
LoginState.STOVE_SERVER_DELETE_CHARACTER = "STOVE_SERVER_DELETE_CHARACTER"
LoginState.STOVE_REFRESH_TOKEN = "STOVE_REFRESH_TOKEN"
LoginState.STOVE_VIEW_AUTO = "STOVE_VIEW_AUTO"
LoginState.STOVE_VIEW_NEWS = "STOVE_VIEW_NEWS"
LoginState.STOVE_VIEW_MANUAL = "STOVE_VIEW_MANUAL"
LoginState.STOVE_VIEW_COMMUNITY = "STOVE_VIEW_COMMUNITY"
LoginState.STOVE_VIEW_COMMUNITY_URL = "STOVE_VIEW_COMMUNITY_URL"
LoginState.STOVE_VIEW_URL = "STOVE_VIEW_URL"
LoginState.STOVE_MANAGE_ACCOUNT = "STOVE_MANAGE_ACCOUNT"
LoginState.STOVE_CUSTOMER_SUPPORT = "STOVE_CUSTOMER_SUPPORT"
LoginState.STOVE_SET_PROPERTIES = "STOVE_SET_PROPERTIES"
StoveAPI = {
	viewCommunity = 10,
	fetchPushSetting = 12,
	fetchProduct = 15,
	fetchCharacter = 4,
	viewManual = 9,
	resetGuestAccessToken = 22,
	initializeIap = 14,
	viewAuto = 7,
	manageAccount = 18,
	startPurchaseWithServiceOrderId = 25,
	excuteStoveDeepLink = 20,
	updatePushSetting = 13,
	checkGuestLogin = 2,
	refreshToken = 21,
	setGameProfile = 5,
	logout = 6,
	viewNews = 8,
	setProperties = 24,
	flushIAP = 17,
	viewUrl = 11,
	googlePlayGamesFetch = 26,
	googlePlayGamesLink = 27,
	startPurchase = 16,
	initialize = 0,
	viewCommunityUrl = 23,
	guestLogin = 3,
	login = 1,
	customerSupport = 19
}
Stove = Stove or {}
Stove.user_data = {}
Stove.vars = {}
Stove.gs = {}
Stove.enable = (getenv("stove.enable") == "true" or getenv("app.stove") == "true") and PLATFORM ~= "win32"

function onStoveCS(arg_1_0)
	local var_1_0 = json.decode(arg_1_0)
	
	Stove.gs.cs = var_1_0.cs
	
	Stove:queryStoveCS()
end

function Stove.checkLoginStoveCS(arg_2_0)
	if not Stove.enable then
		return 
	end
	
	arg_2_0.gs.queryable = true
	
	arg_2_0:queryStoveCS()
end

function Stove.queryStoveCS(arg_3_0)
	if not Stove.enable then
		return 
	end
	
	if arg_3_0.gs.queryable and arg_3_0.gs.cs then
		local var_3_0 = {
			cs = json.encode(arg_3_0.gs.cs)
		}
		
		query("stove_gs", var_3_0)
		
		arg_3_0.gs.cs = nil
	end
end

function Stove.isTokenError(arg_4_0, arg_4_1)
	if arg_4_1 == 40101 or arg_4_1 == 40103 or arg_4_1 == 40104 or arg_4_1 == 40301 or arg_4_1 == 40303 then
		return true
	end
end

function Stove.setTokenRefreshedTime(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	arg_5_0.vars.token_refreshed_time = arg_5_1
end

function Stove.getTokenRefreshedTime(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	return arg_6_0.vars.token_refreshed_time
end

function Stove.handleStoveError(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.errorCode or arg_7_2.return_code or arg_7_2.code
	local var_7_1 = tostring(var_7_0 or "")
	local var_7_2 = arg_7_2.errorMessage or arg_7_2.return_message or arg_7_2.message or arg_7_2.exception or ""
	
	if var_7_0 == 40103 then
		var_7_2 = var_7_2 .. "\nRefresh token. Please try again."
	end
	
	Log.e("handleStoveError " .. (arg_7_1 or "") .. ", " .. var_7_1 .. ", " .. var_7_2)
	
	local var_7_3 = string.format("Cmd:%s Code:%s", arg_7_1 or "", var_7_1)
	
	Dialog:msgBox(var_7_2, {
		title = "STOVE ERROR",
		dont_proc_tutorial = true,
		txt_tab = T("tab_to_title"),
		txt_code = var_7_3,
		handler = arg_7_3 or function()
			if var_7_0 == 40301 then
				restart_contents()
			elseif var_7_0 == 40303 then
				Login.FSM:changeState(LoginState.STOVE_LOGOUT)
			elseif var_7_0 == 40103 then
				Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN)
			elseif var_7_0 == 40104 then
				Login.FSM:changeState(LoginState.STOVE_LOGOUT)
			elseif var_7_0 == 40101 then
				restart_contents()
			elseif arg_7_4 then
				arg_7_4()
			else
				restart_contents()
			end
		end
	})
end

function Stove.handlePaymentError(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:handleStoveError(arg_9_1, arg_9_2)
end

Login.FSM.STATES[LoginState.STOVE_INITIALIZE] = {}
Login.FSM.STATES[LoginState.STOVE_INITIALIZE].onEnter = function(arg_10_0, arg_10_1)
	Stove.vars = {}
	
	function onStoveInitialize(arg_11_0)
		arg_10_0:onReceive(arg_11_0)
	end
	
	call_stove_platform(StoveAPI.initialize, "")
end
Login.FSM.STATES[LoginState.STOVE_INITIALIZE].onReceive = function(arg_12_0, arg_12_1)
	print("Login.FSM.STOVE_INITIALIZE.onReceive ")
	
	local var_12_0 = json.decode(arg_12_1)
	
	table.print(var_12_0)
	print("STOVE_INITIALIZE success")
	
	local var_12_1 = getUserLanguage()
	
	if set_stove_language then
		print("set stove language : ", var_12_1)
		set_stove_language(var_12_1)
	end
	
	if var_12_0 and var_12_0.check_auto_login then
		Login.FSM:changeState(LoginState.STOVE_LOGIN)
	elseif Stove:isSupportGPGS() then
		Login.FSM:changeState(LoginState.STOVE_FETCH_GPGS_ACCOUNT)
	else
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
	end
end
Login.FSM.STATES[LoginState.STOVE_WAIT_LOGIN] = {}
Login.FSM.STATES[LoginState.STOVE_WAIT_LOGIN].onEnter = function(arg_13_0, arg_13_1)
	Stove.user_data = {}
	arg_13_0.show_ui = false
end
Login.FSM.STATES[LoginState.STOVE_WAIT_LOGIN].onUpdate = function(arg_14_0)
	if not arg_14_0.show_ui and SceneManager:getCurrentSceneName() == "title" then
		local var_14_0 = SceneManager:getCurrentScene()
		
		if get_cocos_refid(var_14_0.layer) then
			setenv("patch.background", true)
			var_14_0:setTouchMode(false)
			var_14_0:showStoveLoginUI(true)
			var_14_0:setMessage("")
			
			arg_14_0.show_ui = true
		end
	end
end
Login.FSM.STATES[LoginState.STOVE_WAIT_LOGIN].onExit = function(arg_15_0)
	local var_15_0 = SceneManager:getCurrentScene()
	
	if get_cocos_refid(var_15_0.layer) then
		setenv("patch.background", false)
		var_15_0:showStoveLoginUI(false)
	end
end

function Stove.isSupportGPGS(arg_16_0)
	return IS_ANDROID_BASED_PLATFORM and PLATFORM ~= "amazon"
end

Login.FSM.STATES[LoginState.STOVE_FETCH_GPGS_ACCOUNT] = {}
Login.FSM.STATES[LoginState.STOVE_FETCH_GPGS_ACCOUNT].onEnter = function(arg_17_0)
	function onStoveFetchGPGSAccount(arg_18_0)
		arg_17_0:onReceive(arg_18_0)
	end
	
	if is_gpgs_recall_auth_completed and get_gpgs_recall_session_id then
		arg_17_0.gpgs_auth_completed = is_gpgs_recall_auth_completed()
	else
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
		
		return 
	end
	
	if arg_17_0.gpgs_auth_completed then
		arg_17_0.gpgs_recall_session_id = get_gpgs_recall_session_id()
		
		call_stove_platform(StoveAPI.googlePlayGamesFetch, arg_17_0.gpgs_recall_session_id)
	end
	
	arg_17_0.time_out = os.time() + 3
end
Login.FSM.STATES[LoginState.STOVE_FETCH_GPGS_ACCOUNT].onUpdate = function(arg_19_0)
	if arg_19_0.time_out < os.time() then
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
		
		return 
	end
	
	if not arg_19_0.gpgs_auth_completed and is_gpgs_recall_auth_completed and get_gpgs_recall_session_id then
		arg_19_0.gpgs_auth_completed = is_gpgs_recall_auth_completed()
		
		if arg_19_0.gpgs_auth_completed then
			arg_19_0.gpgs_recall_session_id = get_gpgs_recall_session_id()
			
			call_stove_platform(StoveAPI.googlePlayGamesFetch, arg_19_0.gpgs_recall_session_id)
		end
	end
end
Login.FSM.STATES[LoginState.STOVE_FETCH_GPGS_ACCOUNT].onReceive = function(arg_20_0, arg_20_1)
	print("Login.FSM.STOVE_FETCH_GPGS_ACCOUNT.onReceive ")
	
	local var_20_0 = json.decode(arg_20_1)
	
	table.print(var_20_0)
	
	if var_20_0 and var_20_0.domain == "com.stove.success" and var_20_0.gpgs_linked_account then
		Login.FSM:changeState(LoginState.STOVE_LOGIN, {
			gpgs_recall_session_id = arg_20_0.gpgs_recall_session_id
		})
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
end
Login.FSM.STATES[LoginState.STOVE_LOGIN] = {}
Login.FSM.STATES[LoginState.STOVE_LOGIN].onEnter = function(arg_21_0, arg_21_1)
	arg_21_0.params = arg_21_1
	
	table.print(arg_21_1)
	
	function onStoveLogin(arg_22_0)
		arg_21_0:onReceive(arg_22_0)
	end
	
	Stove.user_data = {}
	Stove.user_data.user_info = nil
	Stove.user_data.game_id = nil
	Stove.user_data.cs = nil
	
	print("IPCountry : " .. getIPCountry())
	
	if Stove:isChina_ip() and getenv("allow.disable_china_ip_block", "false") ~= "true" then
		balloon_message_with_sound("not_allowed_ip")
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
		
		return 
	end
	
	call_stove_platform(StoveAPI.login, json.encode(arg_21_1 or {}))
end
Login.FSM.STATES[LoginState.STOVE_LOGIN].onReceive = function(arg_23_0, arg_23_1)
	print("Login.FSM.STOVE_LOGIN.onReceive ")
	
	local var_23_0 = json.decode(arg_23_1)
	
	table.print(var_23_0)
	
	if var_23_0 and var_23_0.domain == "com.stove.success" then
		Stove.user_data.user_info = var_23_0.accessToken
		Stove.user_data.game_id = var_23_0.game_id or ""
		Stove.user_data.cs = var_23_0.cs
		
		Login.FSM:changeState(LoginState.STOVE_FETCH_CHARACTER_LIST)
		Stove:setTokenRefreshedTime(os.time())
	else
		if Stove:isTokenError(var_23_0 and var_23_0.errorCode) then
			Stove:handleStoveError(LoginState.STOVE_LOGIN, var_23_0)
			
			return 
		end
		
		if var_23_0.errorCode == 44008 then
			Login.FSM:changeState(LoginState.STOVE_LOGOUT, {
				is_unregister = true
			})
			
			return 
		end
		
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
	end
end
Login.FSM.STATES[LoginState.STOVE_CHECK_GUEST_LOGIN] = {}
Login.FSM.STATES[LoginState.STOVE_CHECK_GUEST_LOGIN].onEnter = function(arg_24_0, arg_24_1)
	function onStoveCheckGuestLogin(arg_25_0)
		arg_24_0:onReceive(arg_25_0)
	end
	
	call_stove_platform(StoveAPI.checkGuestLogin, "")
end
Login.FSM.STATES[LoginState.STOVE_CHECK_GUEST_LOGIN].onReceive = function(arg_26_0, arg_26_1)
	print("Login.FSM.STOVE_CHECK_GUEST_LOGIN.onReceive ")
	
	local var_26_0 = json.decode(arg_26_1)
	
	table.print(var_26_0)
	
	if var_26_0 and var_26_0.restored_guest_token then
		Login.FSM:changeState(LoginState.STOVE_LOGIN, {
			restored_guest_token = true
		})
	else
		Login.FSM:changeState(LoginState.STOVE_GUEST_LOGIN)
	end
end
Login.FSM.STATES[LoginState.STOVE_GUEST_LOGIN] = {}
Login.FSM.STATES[LoginState.STOVE_GUEST_LOGIN].onEnter = function(arg_27_0, arg_27_1)
	function onStoveGuestLogin(arg_28_0)
		arg_27_0:onReceive(arg_28_0)
	end
	
	print("IPCountry : " .. getIPCountry())
	
	if Stove:isChina_ip() and getenv("allow.disable_china_ip_block", "false") ~= "true" then
		balloon_message_with_sound("not_allowed_ip")
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
		
		return 
	end
	
	local var_27_0 = T("login_guest_warning_aos")
	
	if PLATFORM == "iphoneos" then
		var_27_0 = T("login_guest_warning_ios")
	end
	
	Dialog:msgBox(var_27_0, {
		yesno = true,
		handler = function()
			Stove.user_data = {}
			Stove.user_data.user_info = nil
			Stove.user_data.game_id = nil
			Stove.user_data.cs = nil
			
			call_stove_platform(StoveAPI.guestLogin, "")
		end,
		cancel_handler = function()
			Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
		end
	})
end
Login.FSM.STATES[LoginState.STOVE_GUEST_LOGIN].onReceive = function(arg_31_0, arg_31_1)
	print("Login.FSM.STOVE_GUEST_LOGIN.onReceive ")
	
	local var_31_0 = json.decode(arg_31_1)
	
	table.print(var_31_0)
	
	if var_31_0 and var_31_0.domain == "com.stove.success" then
		Stove.user_data.user_info = var_31_0.accessToken
		Stove.user_data.game_id = var_31_0.game_id or ""
		Stove.user_data.cs = var_31_0.cs
		
		Login.FSM:changeState(LoginState.STOVE_FETCH_CHARACTER_LIST)
		Stove:setTokenRefreshedTime(os.time())
	else
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
	end
end
Login.FSM.STATES[LoginState.STOVE_FETCH_CHARACTER_LIST] = {}
Login.FSM.STATES[LoginState.STOVE_FETCH_CHARACTER_LIST].onEnter = function(arg_32_0, arg_32_1)
	arg_32_0.params = arg_32_1
	
	function onStoveFetchCharacter(arg_33_0)
		arg_32_0:onReceive(arg_33_0)
	end
	
	Stove.user_data.character_list = nil
	
	call_stove_platform(StoveAPI.fetchCharacter, "")
end
Login.FSM.STATES[LoginState.STOVE_FETCH_CHARACTER_LIST].onReceive = function(arg_34_0, arg_34_1)
	print("Login.FSM.STOVE_FETCH_CHARACTER_LIST.onReceive ")
	
	local var_34_0 = json.decode(arg_34_1)
	
	table.print(var_34_0)
	
	if var_34_0.domain == "com.stove.success" then
		Stove.user_data.character_list = var_34_0.character_info_list or {}
		
		if arg_34_0.params and arg_34_0.params.callback then
			arg_34_0.params.callback()
		else
			Login.FSM:changeState(LoginState.STOVE_SELECT_WORLD)
		end
	elseif var_34_0.errorCode == 10126 then
		Stove.user_data.character_list = {}
		
		Login.FSM:changeState(LoginState.STOVE_SELECT_WORLD)
	else
		Login.FSM:changeState(LoginState.STOVE_WAIT_LOGIN)
	end
end
Login.FSM.STATES[LoginState.STOVE_SELECT_WORLD] = {}
Login.FSM.STATES[LoginState.STOVE_SELECT_WORLD].onEnter = function(arg_35_0)
	local var_35_0 = "stove_epic7qa"
	local var_35_1 = "stove_epic7live"
	local var_35_2 = getenv("app.id")
	
	Stove.vars.stove_qa_world_postfix = ""
	
	if var_35_2 ~= var_35_0 and string.sub(var_35_2, 1, #var_35_0) == var_35_0 then
		Stove.vars.stove_qa_world_postfix = string.sub(var_35_2, #var_35_0 + 1, -1)
	elseif var_35_2 ~= "stove_epic7live" and string.sub(var_35_2, 1, #var_35_1) == var_35_1 then
		Stove.vars.stove_qa_world_postfix = string.sub(var_35_2, #var_35_1 + 1, -1) .. "_live"
	end
	
	print("stove_qa_world_postfix : ", Stove.vars.stove_qa_world_postfix)
	
	if getenv("is_review", "") == "1" then
		print("is_review : ", getenv("is_review", "") == "1")
		arg_35_0:onSelectRegion("kor")
		
		return 
	end
	
	local var_35_3 = getenv("needChangeRegion", "")
	
	if var_35_3 ~= "" and not Stove:isGuestAccount() then
		print("need chagne region : ", var_35_3)
		setenv("needChangeRegion", "")
		arg_35_0:onSelectRegion(var_35_3)
		
		return 
	end
	
	local var_35_4 = Stove.user_data.user_info.user.gameProfile
	
	print("local game profile : ")
	table.print(var_35_4)
	
	if var_35_4 and var_35_4.characterNumber and var_35_4.world then
		for iter_35_0, iter_35_1 in pairs(Stove.user_data.character_list) do
			if iter_35_1.nickname_no == var_35_4.characterNumber and iter_35_1.world_id == var_35_4.world then
				arg_35_0:onSelectRegion(Login:worldToRegion(iter_35_1.world_id))
				
				return 
			end
		end
	end
	
	if Stove:isGuestAccount() then
		if Stove.user_data.character_list[1] ~= nil then
			arg_35_0:onSelectRegion(Login:worldToRegion(Stove.user_data.character_list[1].world_id))
			
			return 
		elseif Stove:isJPN_ip() then
			arg_35_0:onSelectRegion("jpn")
			
			return 
		end
	end
	
	if table.count(Stove.user_data.character_list) == 1 then
		arg_35_0:onSelectRegion(Login:worldToRegion(Stove.user_data.character_list[1].world_id))
		
		return 
	end
	
	local var_35_5 = SceneManager:getCurrentScene()
	
	if var_35_5 and var_35_5:getName() == "title" then
		var_35_5:showStoveWorldSelectUI(true)
	end
end
Login.FSM.STATES[LoginState.STOVE_SELECT_WORLD].onSelectRegion = function(arg_36_0, arg_36_1)
	print("STOVE_SELECT_WORLD onSelectRegion : ", arg_36_1)
	
	local var_36_0 = "world_" .. arg_36_1
	
	if getenv("is_review", "") == "1" then
		var_36_0 = "review_kor"
	end
	
	if getenv("verinfo.status." .. var_36_0, "") == "maintenance" then
		Login.FSM:changeState(LoginState.MAINTENANCE_REGION, {
			region = arg_36_1
		})
		
		return 
	end
	
	local var_36_1 = getenv("app.api." .. var_36_0, "")
	
	if not PRODUCTION_MODE and getenv("develoment.enable", "") == "true" then
		print("[app] Enabled Flags : develoment.enable = true ")
		
		local var_36_2 = getenv("develoment.app.api", "")
		
		if var_36_2 ~= "" then
			print("develoment.app.api : " .. var_36_2)
			
			var_36_1 = var_36_2
		end
	end
	
	setenv("app.api", var_36_1)
	print("set app.api : ", var_36_1)
	print("app.id : ", app_id)
	print("api_world_id : ", var_36_0)
	
	local var_36_3 = var_36_0 .. Stove.vars.stove_qa_world_postfix
	
	print("stove_world_id : ", var_36_3)
	Login.FSM:changeState(LoginState.TICKET_WAIT, {
		world_id = var_36_3,
		api_world_id = var_36_0
	})
end
Login.FSM.STATES[LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID] = {}
Login.FSM.STATES[LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID].onEnter = function(arg_37_0, arg_37_1)
	MsgHandler.stove_req_get_character = MsgHandler.stove_req_get_character or function(arg_38_0)
		arg_37_0:onReceive(arg_38_0)
	end
	ErrHandler.stove_req_get_character = ErrHandler.stove_req_get_character or function(arg_39_0, arg_39_1, arg_39_2)
		arg_37_0:onReceiveError(arg_39_0, arg_39_1, arg_39_2)
	end
	
	local var_37_0 = {
		member_no = Stove.user_data.user_info.user.memberNumber,
		game_id = Stove.game_id,
		world_id = arg_37_1.world_id,
		cs = Stove.user_data.cs,
		game_access_token = Stove.user_data.user_info.token,
		device_uid = getDeviceID(),
		platform = getOSVersion(),
		account_type = Stove:getStoveAccountType(),
		device_name = getDeviceName(),
		country = getCompositiveCountry()
	}
	
	print("stove_req_get_character query params :")
	table.print(var_37_0)
	query("stove_req_get_character", var_37_0)
end
Login.FSM.STATES[LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID].onReceive = function(arg_40_0, arg_40_1)
	print("Login.FSM.STOVE_SERVER_GET_GAME_ACCOUNT_ID.onReceive ")
	table.print(arg_40_1)
	
	if arg_40_1.response and arg_40_1.response.return_code == 0 then
		if arg_40_1.response.add_character then
			Login.FSM:changeState(LoginState.STOVE_FETCH_CHARACTER_LIST, {
				callback = function()
					Login.FSM:changeState(LoginState.STOVE_SET_GAME_PROFILE, {
						id = arg_40_1.response.id,
						password = arg_40_1.response.password,
						world_id = arg_40_1.response.world_id,
						character_no = arg_40_1.response.nickname_no,
						nickname = arg_40_1.response.nickname
					})
				end
			})
		else
			Login.FSM:changeState(LoginState.STOVE_SET_GAME_PROFILE, {
				id = arg_40_1.response.id,
				password = arg_40_1.response.password,
				world_id = arg_40_1.response.world_id,
				character_no = arg_40_1.response.nickname_no,
				nickname = arg_40_1.response.nickname
			})
		end
	elseif arg_40_1.response then
		Stove:handleStoveError(LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID, arg_40_1.response)
	else
		Stove:handleStoveError(LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID, {
			return_code = -2,
			return_message = arg_40_1.res
		})
	end
end
Login.FSM.STATES[LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID].onReceiveError = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	print("Login.FSM.STOVE_SERVER_GET_GAME_ACCOUNT_ID.onReceiveError ")
	table.print(arg_42_3)
	
	local var_42_0 = T(tostring(arg_42_2))
	
	if var_42_0 == "nil" then
		var_42_0 = "unknown_error"
	end
	
	Stove:handleStoveError(LoginState.STOVE_SERVER_GET_GAME_ACCOUNT_ID, {
		return_code = -1,
		return_message = var_42_0
	})
end
Login.FSM.STATES[LoginState.STOVE_SET_GAME_PROFILE] = {}
Login.FSM.STATES[LoginState.STOVE_SET_GAME_PROFILE].onEnter = function(arg_43_0, arg_43_1)
	arg_43_0.params = arg_43_1
	
	table.print(arg_43_1)
	
	function onStoveSetGameProfile(arg_44_0)
		arg_43_0:onReceive(arg_44_0)
	end
	
	if not arg_43_1.world_id or arg_43_1.world_id == "" then
		Stove:handleStoveError(LoginState.STOVE_SET_GAME_PROFILE, {
			return_message = "invalid world id",
			return_code = -1
		})
		
		return 
	end
	
	if type(arg_43_1.character_no) ~= "number" then
		Stove:handleStoveError(LoginState.STOVE_SET_GAME_PROFILE, {
			return_message = "invalid character no",
			return_code = -1
		})
		
		return 
	end
	
	call_stove_platform(StoveAPI.setGameProfile, string.format("{\"character_no\":%d,\"world_id\":\"%s\"}", arg_43_1.character_no, tostring(arg_43_1.world_id)))
end
Login.FSM.STATES[LoginState.STOVE_SET_GAME_PROFILE].onReceive = function(arg_45_0, arg_45_1)
	print("Login.FSM.STOVE_SET_GAME_PROFILE.onReceive ")
	
	local var_45_0 = json.decode(arg_45_1)
	
	table.print(var_45_0)
	
	if var_45_0.result then
		print("STOVE_SET_GAME_PROFILE success")
	else
		Stove:handleStoveError(LoginState.STOVE_SET_GAME_PROFILE, {
			return_message = "Failed",
			return_code = -1
		})
		
		return 
	end
	
	Stove.user_data.character_info = {
		character_no = arg_45_0.params.character_no,
		world_id = arg_45_0.params.world_id,
		nickname = arg_45_0.params.nickname
	}
	
	Login.FSM:changeState(LoginState.STOVE_FETCH_PUSH_SETTING, arg_45_0.params)
end
Login.FSM.STATES[LoginState.STOVE_FETCH_PUSH_SETTING] = {}
Login.FSM.STATES[LoginState.STOVE_FETCH_PUSH_SETTING].onEnter = function(arg_46_0, arg_46_1)
	arg_46_0.params = arg_46_1
	
	function onStoveFetchPushSetting(arg_47_0)
		arg_46_0:onReceive(arg_47_0)
	end
	
	Stove.user_data.push_settings = {}
	
	call_stove_platform(StoveAPI.fetchPushSetting, "")
end
Login.FSM.STATES[LoginState.STOVE_FETCH_PUSH_SETTING].onReceive = function(arg_48_0, arg_48_1)
	print("Login.FSM.STOVE_FETCH_PUSH_SETTING.onReceive ")
	
	local var_48_0 = json.decode(arg_48_1)
	
	table.print(var_48_0)
	
	if var_48_0.push_settings then
		Stove.user_data.push_settings = var_48_0.push_settings
	end
	
	Login.FSM:changeState(LoginState.SYNC_TIME, {
		id = arg_48_0.params.id,
		password = arg_48_0.params.password,
		world_id = arg_48_0.params.world_id,
		stove_id = arg_48_0.params.character_no,
		stove_member_no = Stove.user_data.user_info.user.memberNumber,
		user_access_token = Stove.user_data.user_info.token
	})
	StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_INITIALIZE, {
		character_no = arg_48_0.params.character_no
	})
end
Login.FSM.STATES[LoginState.STOVE_UPDATE_PUSH_SETTING] = {}
Login.FSM.STATES[LoginState.STOVE_UPDATE_PUSH_SETTING].onEnter = function(arg_49_0, arg_49_1)
	arg_49_0.params = arg_49_1
	
	function onStoveUpdatePushSetting(arg_50_0)
		arg_49_0:onReceive(arg_50_0)
	end
	
	if not arg_49_1.push_settings then
		Log.e("STOVE_UPDATE_PUSH_SETTING : invalied pushSetting data")
		
		return 
	end
	
	table.print(arg_49_1)
	
	local var_49_0 = json.encode(arg_49_1.push_settings)
	
	call_stove_platform(StoveAPI.updatePushSetting, var_49_0)
end
Login.FSM.STATES[LoginState.STOVE_UPDATE_PUSH_SETTING].onReceive = function(arg_51_0, arg_51_1)
	print("Login.FSM.STOVE_UPDATE_PUSH_SETTING.onReceive ")
	
	local var_51_0 = json.decode(arg_51_1)
	
	table.print(var_51_0)
	
	if var_51_0.push_settings then
		Stove.user_data.push_settings = var_51_0.push_settings
	end
	
	if var_51_0.return_code == -1 then
		balloon_message_with_sound("[STOVE_UPDATE_PUSH_SETTING]" .. (var_51_0.return_message or ""))
	end
	
	if arg_51_0.params.callback then
		arg_51_0.params.callback()
	else
		Login.FSM:changeState(LoginState.STANDBY)
	end
end
Login.FSM.STATES[LoginState.STOVE_LOGOUT] = {}
Login.FSM.STATES[LoginState.STOVE_LOGOUT].onEnter = function(arg_52_0, arg_52_1)
	arg_52_0.params = arg_52_1
	
	function onStoveLogout(arg_53_0)
		arg_52_0:onReceive(arg_53_0)
	end
	
	if arg_52_1 and arg_52_1.is_unregister then
		call_stove_platform(StoveAPI.logout, "{\"is_unregister\":true}")
	else
		call_stove_platform(StoveAPI.logout, "{\"is_unregister\":false}")
	end
end
Login.FSM.STATES[LoginState.STOVE_LOGOUT].onReceive = function(arg_54_0, arg_54_1)
	print("Login.FSM.STOVE_LOGOUT.onReceive ")
	
	local var_54_0 = json.decode(arg_54_1)
	
	table.print(var_54_0)
	Login:removeLocalData()
	
	if arg_54_0.params and arg_54_0.params.callback then
		arg_54_0.params.callback()
	else
		restart_contents()
	end
end
Login.FSM.STATES[LoginState.STOVE_SERVER_UNREGISTER] = {}
Login.FSM.STATES[LoginState.STOVE_SERVER_UNREGISTER].onEnter = function(arg_55_0, arg_55_1)
	MsgHandler.stove_unregister = MsgHandler.stove_unregister or function(arg_56_0)
		arg_55_0:onReceive(arg_56_0)
	end
	ErrHandler.stove_unregister = ErrHandler.stove_unregister or function(arg_57_0, arg_57_1, arg_57_2)
		arg_55_0:onReceiveError(arg_57_0, arg_57_1, arg_57_2)
	end
	
	local var_55_0 = {
		member_no = Stove.user_data.user_info.user.memberNumber,
		game_access_token = get_stove_game_access_token(),
		nickname_no = Stove.user_data.character_info.character_no,
		world_id = Stove.user_data.character_info.world_id,
		market_game_id = getenv("app.package", "")
	}
	
	print("stove_unregister query params :")
	table.print(var_55_0)
	query("stove_unregister", var_55_0)
end
Login.FSM.STATES[LoginState.STOVE_SERVER_UNREGISTER].onReceive = function(arg_58_0, arg_58_1)
	print("Login.FSM.STOVE_SERVER_UNREGISTER.onReceive ")
	table.print(arg_58_1)
	
	if arg_58_1.response and arg_58_1.response.return_code == 0 then
		Login.FSM:changeState(LoginState.STOVE_LOGOUT, {
			is_unregister = true
		})
	elseif arg_58_1.response then
		Stove:handleStoveError(LoginState.STOVE_SERVER_UNREGISTER, arg_58_1.response)
	else
		Stove:handleStoveError(LoginState.STOVE_SERVER_UNREGISTER, {
			return_code = -2,
			return_message = arg_58_1.res
		})
	end
end
Login.FSM.STATES[LoginState.STOVE_SERVER_UNREGISTER].onReceiveError = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	print("Login.FSM.STOVE_SERVER_UNREGISTER.onReceiveError ")
	table.print(arg_59_3)
	
	local var_59_0 = T(tostring(arg_59_2))
	
	if var_59_0 == "nil" then
		var_59_0 = "unknown_error"
	end
	
	Stove:handleStoveError(LoginState.STOVE_SERVER_UNREGISTER, {
		return_code = -1,
		return_message = var_59_0
	})
end
Login.FSM.STATES[LoginState.STOVE_SERVER_DELETE_CHARACTER] = {}
Login.FSM.STATES[LoginState.STOVE_SERVER_DELETE_CHARACTER].onEnter = function(arg_60_0, arg_60_1)
	MsgHandler.stove_delete_character = MsgHandler.stove_delete_character or function(arg_61_0)
		arg_60_0:onReceive(arg_61_0)
	end
	ErrHandler.stove_delete_character = ErrHandler.stove_delete_character or function(arg_62_0, arg_62_1, arg_62_2)
		arg_60_0:onReceiveError(arg_62_0, arg_62_1, arg_62_2)
	end
	
	local var_60_0 = {
		member_no = Stove.user_data.user_info.user.memberNumber,
		game_access_token = get_stove_game_access_token(),
		nickname_no = Stove.user_data.character_info.character_no,
		world_id = Stove.user_data.character_info.world_id,
		game_id = Stove.user_data.game_id,
		country = getCompositiveCountry()
	}
	
	print("stove_delete_character query params :")
	table.print(var_60_0)
	query("stove_delete_character", var_60_0)
end
Login.FSM.STATES[LoginState.STOVE_SERVER_DELETE_CHARACTER].onReceive = function(arg_63_0, arg_63_1)
	print("Login.FSM.STOVE_SERVER_DELETE_CHARACTER.onReceive ")
	table.print(arg_63_1)
	
	if arg_63_1.response and arg_63_1.response.return_code == 0 then
		Login.FSM:changeState(LoginState.STOVE_LOGOUT)
	elseif arg_63_1.response then
		Stove:handleStoveError(LoginState.STOVE_SERVER_DELETE_CHARACTER, arg_63_1.response)
	else
		Stove:handleStoveError(LoginState.STOVE_SERVER_DELETE_CHARACTER, {
			return_code = -2,
			return_message = arg_63_1.res
		})
	end
end
Login.FSM.STATES[LoginState.STOVE_SERVER_DELETE_CHARACTER].onReceiveError = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	print("Login.FSM.STOVE_SERVER_DELETE_CHARACTER.onReceiveError ")
	table.print(arg_64_3)
	
	local var_64_0 = T(tostring(arg_64_2))
	
	if var_64_0 == "nil" then
		var_64_0 = "unknown_error"
	end
	
	Stove:handleStoveError(LoginState.STOVE_SERVER_DELETE_CHARACTER, {
		return_code = -1,
		return_message = var_64_0
	})
end
Login.FSM.STATES[LoginState.STOVE_REFRESH_TOKEN] = {}
Login.FSM.STATES[LoginState.STOVE_REFRESH_TOKEN].onEnter = function(arg_65_0, arg_65_1)
	arg_65_0.params = arg_65_1 or {}
	
	function onStoveRefreshToken(arg_66_0)
		arg_65_0:onReceive(arg_66_0)
	end
	
	call_stove_platform(StoveAPI.refreshToken, "")
end
Login.FSM.STATES[LoginState.STOVE_REFRESH_TOKEN].onReceive = function(arg_67_0, arg_67_1)
	print("Login.FSM.STOVE_REFRESH_TOKEN.onReceive ")
	
	local var_67_0 = json.decode(arg_67_1)
	
	table.print(var_67_0)
	
	if var_67_0.domain == "com.stove.success" then
		Stove:setTokenRefreshedTime(os.time())
		
		if arg_67_0.params.callback_state then
			Login.FSM:changeState(arg_67_0.params.callback_state, arg_67_0.params)
		else
			Login.FSM:changeState(LoginState.STANDBY)
		end
	else
		Stove:handleStoveError(LoginState.STOVE_REFRESH_TOKEN, arg_67_1)
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_AUTO] = {}
Login.FSM.STATES[LoginState.STOVE_VIEW_AUTO].onEnter = function(arg_68_0, arg_68_1)
	arg_68_0.params = arg_68_1
	
	function onStoveViewAuto(arg_69_0)
		arg_68_0:onReceive(arg_69_0)
	end
	
	call_stove_platform(StoveAPI.viewAuto, "")
end
Login.FSM.STATES[LoginState.STOVE_VIEW_AUTO].onReceive = function(arg_70_0, arg_70_1)
	print("Login.FSM.STOVE_VIEW_AUTO.onReceive ")
	
	local var_70_0 = json.decode(arg_70_1)
	
	table.print(var_70_0)
	
	if Stove:isTokenError(var_70_0 and var_70_0.errorCode) then
		if var_70_0.errorCode == 40103 then
			arg_70_0.params.callback_state = LoginState.STOVE_VIEW_AUTO
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_70_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_VIEW_AUTO, var_70_0)
		end
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_70_0.params and arg_70_0.params.callback then
		arg_70_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_NEWS] = {}
Login.FSM.STATES[LoginState.STOVE_VIEW_NEWS].onEnter = function(arg_71_0, arg_71_1)
	arg_71_0.params = arg_71_1
	
	function onStoveViewNews(arg_72_0)
		arg_71_0:onReceive(arg_72_0)
	end
	
	call_stove_platform(StoveAPI.viewNews, "")
end
Login.FSM.STATES[LoginState.STOVE_VIEW_NEWS].onReceive = function(arg_73_0, arg_73_1)
	print("Login.FSM.STOVE_VIEW_NEWS.onReceive ")
	
	local var_73_0 = json.decode(arg_73_1)
	
	table.print(var_73_0)
	
	if Stove:isTokenError(var_73_0 and var_73_0.errorCode) then
		if var_73_0.errorCode == 40103 then
			arg_73_0.params.callback_state = LoginState.STOVE_VIEW_NEWS
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_73_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_VIEW_NEWS, var_73_0)
		end
		
		return 
	end
	
	if var_73_0.received_data == "showRewardedVideo" then
		UIAction:Add(SEQ(DELAY(100), CALL(function()
			AdNetworks:showRewardedVideo()
		end)), "block")
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	Lobby:checkMail(true)
	
	if arg_73_0.params and arg_73_0.params.callback then
		arg_73_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_MANUAL] = {}
Login.FSM.STATES[LoginState.STOVE_VIEW_MANUAL].onEnter = function(arg_75_0, arg_75_1)
	arg_75_0.params = arg_75_1
	
	table.print(arg_75_1)
	
	if not arg_75_0.params or not arg_75_0.params.location then
		Login.FSM:changeState(LoginState.STANDBY)
		
		return 
	end
	
	function onStoveViewManual(arg_76_0)
		arg_75_0:onReceive(arg_76_0)
	end
	
	call_stove_platform(StoveAPI.viewManual, tostring(arg_75_0.params.location))
	
	if arg_75_0.params and arg_75_0.params.mode == "youtube" then
		SoundEngine:pause()
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_MANUAL].onReceive = function(arg_77_0, arg_77_1)
	print("Login.FSM.STOVE_VIEW_MANUAL.onReceive ")
	
	local var_77_0 = json.decode(arg_77_1)
	
	table.print(var_77_0)
	
	if Stove:isTokenError(var_77_0 and var_77_0.errorCode) then
		if var_77_0.errorCode == 40103 then
			arg_77_0.params.callback_state = LoginState.STOVE_VIEW_MANUAL
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_77_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_VIEW_MANUAL, var_77_0)
		end
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_77_0.params and arg_77_0.params.mode == "youtube" then
		SoundEngine:resume()
	end
	
	Lobby:checkMail(true)
	
	if arg_77_0.params and arg_77_0.params.callback then
		arg_77_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_COMMUNITY] = {}
Login.FSM.STATES[LoginState.STOVE_VIEW_COMMUNITY].onEnter = function(arg_78_0, arg_78_1)
	arg_78_0.params = arg_78_1
	
	function onStoveViewCommunity(arg_79_0)
		arg_78_0:onReceive(arg_79_0)
	end
	
	call_stove_platform(StoveAPI.viewCommunity, "")
end
Login.FSM.STATES[LoginState.STOVE_VIEW_COMMUNITY].onReceive = function(arg_80_0, arg_80_1)
	print("Login.FSM.STOVE_VIEW_COMMUNITY.onReceive ")
	
	local var_80_0 = json.decode(arg_80_1)
	
	table.print(var_80_0)
	
	if Stove:isTokenError(var_80_0 and var_80_0.errorCode) then
		if var_80_0.errorCode == 40103 then
			arg_80_0.params.callback_state = LoginState.STOVE_VIEW_COMMUNITY
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_80_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_VIEW_COMMUNITY, var_80_0)
		end
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_80_0.params and arg_80_0.params.callback then
		arg_80_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_COMMUNITY_URL] = {}
Login.FSM.STATES[LoginState.STOVE_VIEW_COMMUNITY_URL].onEnter = function(arg_81_0, arg_81_1)
	table.print(arg_81_1)
	
	arg_81_0.params = arg_81_1
	
	function onStoveViewCommunityUrl(arg_82_0)
		arg_81_0:onReceive(arg_82_0)
	end
	
	call_stove_platform(StoveAPI.viewCommunityUrl, tostring(arg_81_1.url))
end
Login.FSM.STATES[LoginState.STOVE_VIEW_COMMUNITY_URL].onReceive = function(arg_83_0, arg_83_1)
	print("Login.FSM.STOVE_VIEW_COMMUNITY_URL.onReceive ")
	
	local var_83_0 = json.decode(arg_83_1)
	
	table.print(var_83_0)
	
	if Stove:isTokenError(var_83_0 and var_83_0.errorCode) then
		if var_83_0.errorCode == 40103 then
			arg_83_0.params.callback_state = LoginState.STOVE_VIEW_COMMUNITY_URL
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_83_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_VIEW_COMMUNITY_URL, var_83_0)
		end
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_83_0.params and arg_83_0.params.callback then
		arg_83_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_URL] = {}
Login.FSM.STATES[LoginState.STOVE_VIEW_URL].onEnter = function(arg_84_0, arg_84_1)
	arg_84_0.params = arg_84_1
	
	function onStoveViewUrl(arg_85_0)
		arg_84_0:onReceive(arg_85_0)
	end
	
	if PRODUCTION_MODE and to_n(getenv("build.number", 0)) < 702 then
		call_stove_platform(StoveAPI.viewUrl, tostring(arg_84_1.url))
	else
		call_stove_platform(StoveAPI.viewUrl, json.encode(arg_84_1))
	end
end
Login.FSM.STATES[LoginState.STOVE_VIEW_URL].onReceive = function(arg_86_0, arg_86_1)
	print("Login.FSM.STOVE_VIEW_URL.onReceive ")
	
	local var_86_0 = json.decode(arg_86_1)
	
	table.print(var_86_0)
	
	if Stove:isTokenError(var_86_0 and var_86_0.errorCode) then
		if var_86_0.errorCode == 40103 then
			arg_86_0.params.callback_state = LoginState.STOVE_VIEW_URL
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_86_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_VIEW_URL, var_86_0)
		end
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_86_0.params and arg_86_0.params.callback then
		arg_86_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_MANAGE_ACCOUNT] = {}
Login.FSM.STATES[LoginState.STOVE_MANAGE_ACCOUNT].onEnter = function(arg_87_0, arg_87_1)
	arg_87_0.params = arg_87_1
	
	function onStoveManageAccount(arg_88_0)
		arg_87_0:onReceive(arg_88_0)
	end
	
	call_stove_platform(StoveAPI.manageAccount, "")
end
Login.FSM.STATES[LoginState.STOVE_MANAGE_ACCOUNT].onReceive = function(arg_89_0, arg_89_1)
	print("Login.FSM.STOVE_MANAGE_ACCOUNT.onReceive ")
	
	local var_89_0 = json.decode(arg_89_1)
	
	table.print(var_89_0)
	
	if Stove:isTokenError(var_89_0 and var_89_0.errorCode) then
		if var_89_0.errorCode == 40103 then
			arg_89_0.params.callback_state = LoginState.STOVE_MANAGE_ACCOUNT
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_89_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_MANAGE_ACCOUNT, var_89_0)
		end
		
		return 
	end
	
	if var_89_0 and var_89_0.withdraw then
		Login:removeLocalData()
		restart_contents()
		
		return 
	end
	
	if var_89_0 and var_89_0.accessToken then
		Stove.user_data.user_info = var_89_0.accessToken
		
		Stove:googlePlayGamesAccountLink()
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_89_0.params and arg_89_0.params.callback then
		arg_89_0.params.callback()
	end
end
Login.FSM.STATES[LoginState.STOVE_CUSTOMER_SUPPORT] = {}
Login.FSM.STATES[LoginState.STOVE_CUSTOMER_SUPPORT].onEnter = function(arg_90_0, arg_90_1)
	arg_90_0.params = arg_90_1
	
	function onStoveCustomerSupport(arg_91_0)
		arg_90_0:onReceive(arg_91_0)
	end
	
	call_stove_platform(StoveAPI.customerSupport, "")
end
Login.FSM.STATES[LoginState.STOVE_CUSTOMER_SUPPORT].onReceive = function(arg_92_0, arg_92_1)
	print("Login.FSM.STOVE_CUSTOMER_SUPPORT.onReceive ")
	
	local var_92_0 = json.decode(arg_92_1)
	
	table.print(var_92_0)
	
	if Stove:isTokenError(var_92_0 and var_92_0.errorCode) then
		if var_92_0.errorCode == 40103 then
			arg_92_0.params.callback_state = LoginState.STOVE_CUSTOMER_SUPPORT
			
			Login.FSM:changeState(LoginState.STOVE_REFRESH_TOKEN, arg_92_0.params)
		else
			Stove:handleStoveError(LoginState.STOVE_CUSTOMER_SUPPORT, var_92_0)
		end
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	
	if arg_92_0.params and arg_92_0.params.callback then
		arg_92_0.params.callback()
	end
end

function Stove.isJPN_ip(arg_93_0)
	return getIPCountry() == "JP"
end

function Stove.isChina_ip(arg_94_0)
	return getIPCountry() == "CN"
end

function Stove.toStoveNickname(arg_95_0, arg_95_1, arg_95_2)
	return tostring(arg_95_1) .. "_" .. tostring(arg_95_2)
end

function Stove.isGuestAccount(arg_96_0)
	if not Stove.enable then
		return false
	end
	
	if Stove.user_data and Stove.user_data.user_info.user and Stove.user_data.user_info.user.providerUsers and table.count(Stove.user_data.user_info.user.providerUsers) == 0 then
		return true
	else
		return false
	end
end

function Stove.getNickNameNo(arg_97_0)
	return Stove.user_data and Stove.user_data.character_info and Stove.user_data.character_info.character_no
end

function Stove.getStoveAccountType(arg_98_0, arg_98_1)
	if Stove.user_data and Stove.user_data.user_info and Stove.user_data.user_info.user and Stove.user_data.user_info.user.providerUsers then
		local var_98_0 = Stove.user_data.user_info.user.providerUsers[1]
		
		if var_98_0 then
			if var_98_0.type == 1 then
				return "Stove"
			elseif var_98_0.type == 2 then
				return "Facebook"
			elseif var_98_0.type == 9 then
				return "Google"
			elseif var_98_0.type == 3 then
				return "Twitter"
			elseif var_98_0.type == 12 then
				return "Apple"
			elseif var_98_0.type == 6 then
				return "Naver"
			elseif var_98_0.type == 13 then
				return "Line"
			elseif var_98_0.type == 14 then
				return "LineGame"
			end
		elseif arg_98_1 then
			return T("guest", "Guest")
		else
			return "Guest"
		end
	end
	
	return "Development"
end

MAX_REGION_COUNT = 5

function Stove.getServerList(arg_99_0)
	local var_99_0 = {
		default = {
			"global",
			"asia",
			"eu",
			"kor",
			"jpn"
		},
		kor = {
			"kor",
			"asia",
			"global",
			"eu",
			"jpn"
		},
		asia = {
			"asia",
			"global",
			"eu",
			"kor",
			"jpn"
		},
		global = {
			"global",
			"eu",
			"asia",
			"kor",
			"jpn"
		},
		eu = {
			"eu",
			"global",
			"asia",
			"kor",
			"jpn"
		},
		jpn = {
			"jpn",
			"asia",
			"eu",
			"global",
			"kor"
		}
	}
	local var_99_1 = getRecommendRegion()
	
	print("recommend_region : ", var_99_1)
	print("character list :")
	table.print(Stove.user_data.character_list)
	
	local function var_99_2(arg_100_0)
		if not Stove.user_data.character_list then
			return nil
		end
		
		local var_100_0 = "world_" .. arg_100_0 .. (Stove.vars.stove_qa_world_postfix or "")
		
		for iter_100_0, iter_100_1 in pairs(Stove.user_data.character_list) do
			if iter_100_1.world_id == var_100_0 then
				return iter_100_1
			end
		end
		
		return nil
	end
	
	local var_99_3 = {}
	local var_99_4 = var_99_0[var_99_1] or var_99_0.default
	
	for iter_99_0, iter_99_1 in pairs(var_99_4) do
		local var_99_5 = var_99_2(iter_99_1)
		
		table.insert(var_99_3, {
			region = iter_99_1,
			character_info = var_99_5 or {}
		})
	end
	
	return var_99_3
end

function Stove.checkStandbyAndBalloonMessage(arg_101_0)
	if not Stove.enable then
		return true
	end
	
	if Login.FSM:isCurrentState("STANDBY") then
		return true
	else
		balloon_message_with_sound("waiting_for_stove_api_retry", {
			code = Login.FSM:getCurrentStateString()
		})
	end
end

function Stove.setCommunityUrls(arg_102_0, arg_102_1, arg_102_2)
	print("Stove setCommunityUrls : ", arg_102_1)
	table.print(arg_102_2)
	
	arg_102_0.vars = arg_102_0.vars or {}
	arg_102_0.vars.community_urls = arg_102_0.vars.community_urls or {}
	arg_102_0.vars.community_urls[arg_102_1] = arg_102_2
end

function Stove.getCommunityUrls(arg_103_0, arg_103_1)
	if not arg_103_1 then
		return 
	end
	
	if not arg_103_0.vars then
		return 
	end
	
	if not arg_103_0.vars.community_urls then
		return 
	end
	
	return arg_103_0.vars.community_urls[arg_103_1]
end

function Stove.openCommunityUI(arg_104_0, arg_104_1)
	print("openCommunityUI : " .. tostring(arg_104_1))
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_104_0 = "https://sdk-page.onstove.com"
	
	if getenv("stove.environment") ~= "live" then
		var_104_0 = "https://sdk-page.gate8.com"
	end
	
	if arg_104_1 == "notice" or arg_104_1 == "patchnote" or arg_104_1 == "developer" then
		local var_104_1 = arg_104_0:getCommunityUrls(arg_104_1)
		
		table.print(var_104_1)
		
		if var_104_1 then
			local var_104_2 = var_104_1[getUserLanguage()]
			
			if var_104_2 then
				if not PRODUCTION_MODE then
					print("replace url for sandbox")
					print("from url : ", var_104_2)
					
					var_104_2 = string.replace(var_104_2, "onstove", "gate8")
					
					print("to url : ", var_104_2)
				end
				
				Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
					url = var_104_2
				})
			end
		end
	elseif arg_104_1 == "event" then
		Login.FSM:changeState(LoginState.STOVE_VIEW_NEWS)
	elseif arg_104_1 == "note" then
		local var_104_3
		
		if getUserLanguage() == "ko" then
			var_104_3 = var_104_0 .. "/epicseven/kr/board/list/e7kr003"
		elseif getUserLanguage() == "zht" then
			var_104_3 = var_104_0 .. "/epicseven/tw/board/list/e7tw003"
		else
			var_104_3 = var_104_0 .. "/epicseven/global/board/list/e7en003"
		end
		
		Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
			url = var_104_3
		})
	elseif arg_104_1 == "stove" then
		arg_104_0:openStove(var_104_0)
	elseif arg_104_1 == "offer_wall" then
		balloon_message_with_sound("notyet_con")
	elseif arg_104_1 == "youtube" then
		Login.FSM:changeState(LoginState.STOVE_VIEW_MANUAL, {
			location = Account:isJPN() and 23 or 1,
			mode = arg_104_1
		})
	elseif arg_104_1 == "facebook" then
		Login.FSM:changeState(LoginState.STOVE_VIEW_MANUAL, {
			location = 2
		})
	elseif arg_104_1 == "twitter" then
		Login.FSM:changeState(LoginState.STOVE_VIEW_MANUAL, {
			location = 24
		})
	elseif arg_104_1 == "gacha_rate_info" then
		local var_104_4 = "https://sdk-page.gate8.com/epicseven/kr/view/1785412"
		local var_104_5 = "https://sdk-page.onstove.com/epicseven/kr/view/1785412"
		
		if getUserLanguage() == "ja" then
			var_104_4 = "https://page.gate8.com/epicseven/jp/view/4998468"
			var_104_5 = "https://page.onstove.com/epicseven/jp/view/4998468"
		end
		
		local var_104_6 = PRODUCTION_MODE and var_104_5 or var_104_4
		
		Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
			url = var_104_6
		})
	else
		balloon_message_with_sound("notyet_con")
	end
end

function Stove.openEquipGachaRateInfo()
	local var_105_0 = "https://sdk-page.onstove.com/epicseven/kr/view/1785412"
	
	if getenv("stove.environment") ~= "live" then
		var_105_0 = "https://sdk-page.gate8.com/epicseven/kr/view/1785412"
	end
	
	if getUserLanguage() == "ja" then
		var_105_0 = "https://page.onstove.com/epicseven/jp/view/4998468"
		
		if getenv("stove.environment") ~= "live" then
			var_105_0 = "https://page.gate8.com/epicseven/jp/view/4998468"
		end
	end
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
		url = var_105_0
	})
end

function Stove.openStove(arg_106_0, arg_106_1)
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	local var_106_0 = {
		ko = arg_106_1 .. "/epicseven/kr",
		en = arg_106_1 .. "/epicseven/global",
		ja = arg_106_1 .. "/epicseven/jp",
		zht = arg_106_1 .. "/epicseven/tw"
	}
	
	var_106_0.zhs = var_106_0.zht
	
	local var_106_1 = var_106_0[getUserLanguage()] or var_106_0.en
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
		url = var_106_1
	})
end

function Stove.openGuerrillaRateInfo(arg_107_0)
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	local var_107_0 = {}
	
	var_107_0.ko = "https://sdk-page.onstove.com/epicseven/kr/view/8103142"
	var_107_0.en = "https://sdk-page.onstove.com/epicseven/global/view/8216965"
	var_107_0.ja = "https://sdk-page.onstove.com/epicseven/jp/view/8103105"
	var_107_0.zht = "https://sdk-page.onstove.com/epicseven/tw/view/8103153"
	var_107_0.zhs = var_107_0.zht
	
	local var_107_1 = var_107_0[getUserLanguage()] or var_107_0.en
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
		url = var_107_1
	})
end

function Stove.openEquipPackageRenewalRateInfo(arg_108_0)
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	local var_108_0 = {}
	
	var_108_0.ko = "https://sdk-page.onstove.com/epicseven/kr/view/1785412"
	var_108_0.en = "https://sdk-page.onstove.com/epicseven/global/view/8579473"
	var_108_0.ja = "https://sdk-page.onstove.com/epicseven/jp/view/4998468"
	var_108_0.zht = "https://sdk-page.onstove.com/epicseven/tw/view/8579475"
	var_108_0.zhs = var_108_0.zht
	
	local var_108_1 = var_108_0[getUserLanguage()] or var_108_0.en
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
		url = var_108_1
	})
end

function Stove.getEquipEnhanceRateInfoUrl()
	local var_109_0 = Stove:getCommunityUrls("enhance_rate_info")
	
	if not var_109_0 then
		Log.e("getEquipEnhanceRateInfoUrl", "enhance_rate_info 값을 찾을 수 없습니다.")
		
		return 
	end
	
	local var_109_1 = getUserLanguage()
	local var_109_2 = var_109_0[var_109_1]
	
	if not var_109_2 then
		Log.e("getEquipEnhanceRateInfoUrl", var_109_1 .. "의 enhance_rate_info 값을 찾을 수 없습니다.")
		
		return 
	end
	
	return var_109_2
end

function Stove.openEquipEnhanceRateInfo()
	print("openEquipEnhanceRateInfo")
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	local var_110_0 = Stove:getEquipEnhanceRateInfoUrl()
	
	if not var_110_0 then
		Log.e("openEquipEnhanceRateInfo", "enhance_rate_info 값을 찾을 수 없습니다.")
		
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
		url = var_110_0
	})
end

function Stove.openExpeditionGuidePage(arg_111_0)
	print("openExpeditionGuidePage")
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_111_0 = "https://epic7.smilegatemegaport.com/guide/expedition"
	
	if getenv("stove.environment") ~= "live" then
		var_111_0 = "https://sandbox-epic7.smilegatemegaport.com/guide/expedition"
	end
	
	local var_111_1 = ((var_111_0 .. "?world=" .. "world_" .. Login:getRegion()) .. "&lang=" .. getUserLanguage()) .. "&ingame=y"
	
	print("URL : " .. var_111_1)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		url = var_111_1
	})
end

function Stove.openHellGuidePage(arg_112_0, arg_112_1, arg_112_2)
	print("openHellGuidePage floor: " .. tostring(arg_112_1))
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_112_0
	
	if not arg_112_2 then
		var_112_0 = "https://epic7.smilegatemegaport.com/guide/abyss"
		
		if getenv("stove.environment") ~= "live" then
			var_112_0 = "https://sandbox-epic7.smilegatemegaport.com/guide/abyss"
		end
	else
		var_112_0 = "https://epic7.smilegatemegaport.com/guide/abysschallenge"
		
		if getenv("stove.environment") ~= "live" then
			var_112_0 = "https://sandbox-epic7.smilegatemegaport.com/guide/abysschallenge"
		end
	end
	
	local var_112_1 = (((var_112_0 .. "?world=" .. "world_" .. Login:getRegion()) .. "&floor=" .. tostring(arg_112_1)) .. "&lang=" .. getUserLanguage()) .. "&ingame=y"
	local var_112_2 = arg_112_2 and DungeonHell:getNormalFloor() or math.min(Account:getHardHellFloor() + 1, DungeonHell:getMaxChallengeFloor())
	local var_112_3 = var_112_1 .. "&" .. (arg_112_2 and "normalfloor=" or "challengefloor=") .. var_112_2
	
	print("URL : " .. var_112_3)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		url = var_112_3
	})
end

function Stove.openHuntGuidePage(arg_113_0, arg_113_1, arg_113_2)
	print("openDungeonGuidePage dungeon_id: " .. tostring(arg_113_1) .. ", floor: " .. tostring(arg_113_2))
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_113_0 = "https://epic7.smilegatemegaport.com/guide/hunt"
	
	if getenv("stove.environment") ~= "live" then
		var_113_0 = "https://sandbox-epic7.smilegatemegaport.com/guide/hunt"
	end
	
	local var_113_1 = ((((var_113_0 .. "?world=" .. "world_" .. Login:getRegion()) .. "&dungeon=" .. tostring(arg_113_1)) .. "&stage=" .. tostring(arg_113_2)) .. "&lang=" .. getUserLanguage()) .. "&ingame=y"
	
	print("URL : " .. var_113_1)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		url = var_113_1
	})
end

function Stove.openArtifactUsagePage(arg_114_0, arg_114_1)
	if not arg_114_1 or type(arg_114_1) ~= "string" then
		return 
	end
	
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_114_0 = "https://epic7.smilegatemegaport.com/guide/wearingStatus"
	
	if getenv("stove.environment") ~= "live" then
		var_114_0 = "https://sandbox-epic7.smilegatemegaport.com/guide/wearingStatus"
	end
	
	local var_114_1 = ((((var_114_0 .. "?ptype=att") .. "&artifact=" .. arg_114_1) .. "&world=" .. "world_" .. Login:getRegion()) .. "&lang=" .. getUserLanguage()) .. "&ingame=y"
	
	print("url : ", var_114_1)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove.checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		url = var_114_1
	})
end

function Stove.openWorldChampionInterview(arg_115_0, arg_115_1)
	if not arg_115_1 or type(arg_115_1) ~= "string" then
		return 
	end
	
	SoundEngine:play("event:/ui/whoosh_a")
	print("url : ", arg_115_1)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove.checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		is_full = true,
		url = arg_115_1
	})
end

STOVE_HERO_URL_PTYPE = {
	artifact = "att",
	hero_artifact = "ath",
	hero_equip = "eqh"
}

function Stove.openHeroEquipStatisticsPage(arg_116_0, arg_116_1, arg_116_2)
	if not arg_116_1 or type(arg_116_1) ~= "string" then
		return 
	end
	
	if MoonlightDestiny:isDestinyCharacter(arg_116_1) then
		arg_116_1 = MoonlightDestiny:getRelationCharacterCode(arg_116_1)
	end
	
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_116_0 = "https://epic7.smilegatemegaport.com/guide/wearingStatus"
	
	if getenv("stove.environment") ~= "live" then
		var_116_0 = "https://sandbox-epic7.smilegatemegaport.com/guide/wearingStatus"
	end
	
	local var_116_1 = ((((var_116_0 .. "?ptype=" .. arg_116_2) .. "&hero=" .. arg_116_1) .. "&world=" .. "world_" .. Login:getRegion()) .. "&lang=" .. getUserLanguage()) .. "&ingame=y"
	
	print("url : ", var_116_1)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove.checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		url = var_116_1
	})
end

function Stove.openVideoPage(arg_117_0, arg_117_1)
	if not arg_117_1 then
		Log.e("Stove.openVideoPage", "url이 nil 입니다.")
		
		return 
	end
	
	if not tolua.type(arg_117_1) == "string" then
		Log.e("Stove.openVideoPage", "url이 유효하지 않습니다.")
		
		return 
	end
	
	local var_117_0 = "^https://www.youtube.com/embed/[a-zA-Z%d_-]+$"
	
	if not string.match(arg_117_1, var_117_0) then
		Log.e("Stove.openVideoPage", string.format("url은 '%s' 패턴이어야 합니다. url: '%s'", var_117_0, arg_117_1))
		
		return 
	end
	
	print("openVideoPage : " .. arg_117_1)
	
	if PLATFORM == "wind32" then
		openURL(arg_117_1)
		
		return 
	end
	
	if not Stove.enable then
		Log.e("Stove.openVideoPage", "stove 기능이 비활성화되어 있습니다.")
		openURL(arg_117_1)
		
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		is_full = true,
		url = arg_117_1
	})
end

function Stove.openEssenceGuidePage(arg_118_0, arg_118_1)
	local var_118_0 = arg_118_1
	
	if MoonlightDestiny:isDestinyCharacter(var_118_0) then
		var_118_0 = MoonlightDestiny:getRelationCharacterCode(var_118_0)
	end
	
	print("openEssenceGuidePage character: " .. tostring(var_118_0))
	SoundEngine:play("event:/ui/whoosh_a")
	
	local var_118_1 = "https://epic7.smilegatemegaport.com/guide/catalyst"
	
	if getenv("stove.environment") ~= "live" then
		var_118_1 = "https://sandbox-epic7.smilegatemegaport.com/guide/catalyst"
	end
	
	local var_118_2 = (((var_118_1 .. "?world=" .. "world_" .. Login:getRegion()) .. "&hero=" .. tostring(var_118_0)) .. "&lang=" .. getUserLanguage()) .. "&ingame=y"
	
	print("URL : " .. var_118_2)
	
	if not Stove.enable then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
		url = var_118_2
	})
end

function Stove.openAppleStoreTireErrorFAQ()
	local var_119_0 = getUserLanguage()
	local var_119_1
	
	if var_119_0 == "ko" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/kr/view/9065081"
	elseif var_119_0 == "en" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/global/view/9065022"
	elseif var_119_0 == "fr" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/fr/view/9062575"
	elseif var_119_0 == "de" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/de/view/9061974"
	elseif var_119_0 == "es" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/es/view/9064750"
	elseif var_119_0 == "pt" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/pt/view/9061617"
	elseif var_119_0 == "ja" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/jp/view/9064683"
	elseif var_119_0 == "th" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/th/view/9061778"
	elseif var_119_0 == "zht" or var_119_0 == "zhs" then
		var_119_1 = "https://sdk-page.onstove.com/epicseven/tw/view/9061645"
	end
	
	if not Stove.enable or not var_119_1 then
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
		url = var_119_1
	})
end

function Stove.setProperties(arg_120_0, arg_120_1)
	if not Stove.enable then
		return 
	end
	
	local var_120_0 = json.encode(arg_120_1)
	
	call_stove_platform(StoveAPI.setProperties, var_120_0)
end

Stove.web_channels = {
	ko = "kr",
	zhs = "tw",
	de = "de",
	zht = "tw",
	es = "es",
	fr = "fr",
	ja = "jp",
	en = "global",
	th = "th",
	pt = "pt"
}
Stove.web_clan_board_keys = {
	ko = "e7kr008",
	zhs = "e7tw006",
	de = "e7de012",
	zht = "e7tw006",
	es = "e7es009",
	fr = "e7fr009",
	ja = "e7jp007",
	en = "e7en008",
	th = "e7th007",
	pt = "e7pt009"
}

function Stove.openClanPromotionBoardForWrite(arg_121_0, arg_121_1)
	local var_121_0 = getUserLanguage()
	local var_121_1 = PRODUCTION_MODE and "onstove" or "gate8"
	local var_121_2 = arg_121_0.web_channels[var_121_0] or arg_121_0.web_channels.en
	local var_121_3 = arg_121_0.web_clan_board_keys[var_121_0] or arg_121_0.web_clan_board_keys.en
	local var_121_4 = string.format("https://sdk-page.%s.com/epicseven/%s/write?boardKey=%s", var_121_1, var_121_2, var_121_3)
	
	print("open clan promotion board for write: ", var_121_4)
	
	if Stove.enable and Login.FSM:isCurrentState(LoginState.STANDBY) then
		arg_121_0:setProperties(arg_121_1)
		Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
			url = var_121_4
		})
	end
end

function Stove.openClanPromotionBoard(arg_122_0)
	local var_122_0 = getUserLanguage()
	local var_122_1 = PRODUCTION_MODE and "onstove" or "gate8"
	local var_122_2 = arg_122_0.web_channels[var_122_0] or arg_122_0.web_channels.en
	local var_122_3 = arg_122_0.web_clan_board_keys[var_122_0] or arg_122_0.web_clan_board_keys.en
	local var_122_4 = string.format("https://sdk-page.%s.com/epicseven/%s/list/%s", var_122_1, var_122_2, var_122_3)
	
	print("open clan promotion board: ", var_122_4)
	
	if Stove.enable and Login.FSM:isCurrentState(LoginState.STANDBY) then
		Login.FSM:changeState(LoginState.STOVE_VIEW_COMMUNITY_URL, {
			url = var_122_4
		})
	end
end

function Stove.excuteStoveDeepLink(arg_123_0)
	if Stove.enable and Stove.user_data and Stove.user_data.character_info and Stove.user_data.character_info.character_no then
		print("excuteStoveDeepLink")
		call_stove_platform(StoveAPI.excuteStoveDeepLink, "")
	else
		print("excuteStoveDeepLink : character_no is nil. cant execute before login")
	end
end

function onStoveDeepLinkHandler(arg_124_0)
	print("onStoveDeepLinkHandler")
	
	local var_124_0 = json.decode(arg_124_0) or {}
	
	table.print(var_124_0)
	
	if var_124_0.domain == "com.stove.success" then
		Lobby:checkMail(true)
	end
end

function Stove.googlePlayGamesAccountLink(arg_125_0)
	if not Stove.enable then
		return 
	end
	
	if Stove:isSupportGPGS() and get_gpgs_recall_session_id then
		print("Stove.googlePlayGamesAccountLink")
		
		local var_125_0 = get_gpgs_recall_session_id()
		
		call_stove_platform(StoveAPI.googlePlayGamesLink, var_125_0)
	end
end
