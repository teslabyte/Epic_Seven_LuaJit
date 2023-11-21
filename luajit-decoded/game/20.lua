LoginState.ZLONG_PRE_STANDBY_DOWNLOAD = "ZLONG_PRE_STANDBY_DOWNLOAD"
LoginState.ZLONG_PRE_STANDBY_MAINTENANCE = "ZLONG_PRE_STANDBY_MAINTENANCE"
LoginState.ZLONG_CHECK_LOGIN = "ZLONG_CHECK_LOGIN"
LoginState.ZLONG_WAIT_LOGIN = "ZLONG_WAIT_LOGIN"
LoginState.ZLONG_LOGIN = "ZLONG_LOGIN"
LoginState.ZLONG_SELECT_WORLD = "ZLONG_SELECT_WORLD"
LoginState.QUERY_ZLONG_LOGIN = "QUERY_ZLONG_LOGIN"
LoginState.ZLONG_LOGOUT = "ZLONG_LOGOUT"
LoginState.ZLONG_GENERAL_WEBVIEW = "ZLONG_GENERAL_WEBVIEW"
LoginState.ZLONG_SHARE = "ZLONG_SHARE"
LoginState.ZLONG_EXIT_GAME = "ZLONG_EXIT_GAME"
ZLONG_CODE = {
	DOSHARE_SUCCESS = 1200,
	GAME_EXIT_SUCCESS = 1103,
	BASEWEBVIEW_CANCEL = 1602,
	DOSAVEIMAGETOPHOTOLIBRARY_FAILED = 1501,
	PAY_HISTORY_FAILED = 601,
	LOGIN_CANCEL = 302,
	VERIFY_TOKEN_SUCCESS = 901,
	GOODS_SUCCESS = 800,
	BIND_GUEST_FAILED = 1901,
	REQUEST_PERMISSION_FAILED = 2201,
	DOQUESTION_FAILED = 1301,
	GAMELOGUPLOAD_SUCCESS = 2301,
	SWITCH_USER_SUCCESS = 500,
	SWITCH_USER_FAILED = 501,
	INIT_FAILED = 401,
	BASEWEBVIEW_FAILED = 1601,
	DOSETEXTDATA_SUCCESS = 1105,
	PGVOICE_FAILED = 1701,
	QRCODE_LOGIN_FAILED = 1801,
	PAY_SUCCESS = 100,
	QRCODE_LOGIN_CANCEL = 1802,
	BIND_GUEST_SUCCESS = 1900,
	LOGIN_SUCCESS = 300,
	SWITCH_USER_CANCEL = 502,
	CHANGE_LANGUAGE_SUCCESS = 2000,
	UNBIND_GUEST_FAILED = 2101,
	GAME_EXIT_FAILED = 1104,
	LOGIN_FAILED = 301,
	REQUEST_PERMISSION_SUCCESS = 2200,
	PAY_FAILED = 101,
	BASEWEBVIEW_SUCCESS = 1600,
	INIT_SUCCESS = 400,
	GAMELOGUPLOAD_FAILED = 2302,
	LOGOUT_SUCCESS = 200,
	GETIMAGEPATH_FAILED = 1401,
	HOST_FAILED = 1102,
	REQUEST_NOTICENODE_SUCCESS = 2400,
	DOSETEXTDATA_FAILED = 1106,
	DOSHARE_FAILED = 1201,
	LOGOUT_CANCEL = 201,
	LOGOUT_FAILED = 202,
	REQUEST_NOTICENODE_FAILED = 2401,
	UNBIND_GUEST_SUCCESS = 2100,
	GETIMAGEPATH_SUCCESS = 1400,
	PAY_HISTORY_SUCCESS = 600,
	QRCODE_LOGIN_SUCCESS = 1800,
	DOSHARE_CANCEL = 1202,
	GOODS_FAILED = 801,
	UNBIND_GUEST_CANCEL = 2102,
	BIND_GUEST_CANCEL = 1902,
	VERIFY_TOKEN_FAILED = 902,
	HOST_SUCCESS = 1101,
	DOSAVEIMAGETOPHOTOLIBRARY_SUCCESS = 1500,
	CHANGE_LANGUAGE_FAILED = 2001,
	PGVOICE_SUCCESS = 1700,
	PAY_CANCEL = 102,
	DOQUESTION_SUCCESS = 1300
}
ZLONG_LOG_CODE = {
	SELECT_WORLD = "23",
	LOGIN_BUTTON_SHOW = "18",
	CDN_PATCH_START = "31",
	MINIMAL_PATCH_COMPLETE = "16",
	CDN_PATCH_FAILED = "33",
	MINIMAL_PATCH_FAILED = "17",
	CDN_PATCH_FINISH = "34",
	APP_START = "1",
	CDN_PATCH_COMPLETE = "32",
	FORCE_CDN_PATCH_POPUP = "30",
	POPUP_NOTICE = "21",
	INTRO_TUTORIAL_04 = "27",
	LOBBY_ENTER = "38",
	INTRO_TUTORIAL_02 = "25",
	INTRO_TUTORIAL_03 = "26",
	WORLD_SELECT_BUTTON = "22",
	INTRO_TUTORIAL_01 = "24",
	LOGIN_SUCCESS = "19",
	INTRO_TUTORIAL_06 = "29",
	TAP_TO_START = "35",
	LOGIN_FAILED = "20",
	STORY_1_1_START = "36",
	INTRO_TUTORIAL_05 = "28",
	MINIMAL_PATCH_START = "15"
}
ZLONG_SHARE_PLATFORM = {
	TWITTER = 7,
	QQ = 5,
	SINA_WEIBO = 3,
	ALL_PLATFORMS = 0,
	KAKAO = 9,
	LINE = 10,
	WE_CHAT = 1,
	QQ_CIRCLE = 6,
	INSTAGRAM = 8,
	FACEBOOK = 4,
	WE_CHAT_MOMENTS = 2
}
Zlong = Zlong or {}
Zlong.enable = getenv("zlong.enable") == "true" and PLATFORM ~= "win32"

function Zlong.handleZlongError(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_2.state_code or arg_1_2.return_code or arg_1_2.code or arg_1_2.status
	local var_1_1 = tostring(var_1_0 or "")
	local var_1_2 = arg_1_2.message or arg_1_2.errorMessage or arg_1_2.return_message or arg_1_2.exception or ""
	
	Log.e("handleZlongError " .. (arg_1_1 or "") .. ", " .. var_1_1 .. ", " .. var_1_2)
	
	local var_1_3 = var_1_2
	
	if var_1_0 ~= nil then
		var_1_3 = string.format("%s 错误状态:%s", arg_1_1 or "", var_1_1)
	end
	
	Dialog:msgBox(var_1_2, {
		title = "错误",
		dont_proc_tutorial = true,
		txt_tab = T("tab_to_title"),
		txt_code = var_1_3,
		handler = arg_1_3 or function()
			restart_contents()
		end
	})
end

function Zlong.isUseGlobalResource(arg_3_0)
	local var_3_0 = cc.FileUtils:getInstance():getStringFromFile("global.pack")
	
	if not var_3_0 or string.len(var_3_0) == 0 then
		local var_3_1 = cc.FileUtils:getInstance():getWritablePath() .. "global.pack"
		
		var_3_0 = cc.FileUtils:getInstance():getStringFromFile(var_3_1)
	end
	
	if string_tomd5(var_3_0) ~= ZL_MD5_HEX then
		return false
	end
	
	local var_3_2 = cc.FileUtils:getInstance():getStringFromFile("resource.ini")
	
	if not var_3_2 or string.len(var_3_2) == 0 then
		local var_3_3 = cc.FileUtils:getInstance():getWritablePath() .. "resource.ini"
		
		var_3_2 = cc.FileUtils:getInstance():getStringFromFile(var_3_3)
	end
	
	if var_3_2 ~= ZL_INI_KEY then
		return false
	end
	
	return true
end

function Zlong.gameEventLog(arg_4_0, arg_4_1, arg_4_2)
	if not IS_PUBLISHER_ZLONG then
		return 
	end
	
	if not Zlong.enable then
		return 
	end
	
	call_zlong_async_api("ZlongGameEventLog", json.encode({
		eventID = arg_4_1 or "",
		remark = arg_4_2 or ""
	}))
end

function Zlong.pollingForLog(arg_5_0)
	if not IS_PUBLISHER_ZLONG then
		return 
	end
	
	if not Zlong.enable then
		return 
	end
	
	if not arg_5_0.patch_completed and getenv("patch.status") == "complete" and tonumber(getenv("patch.download_total", 0)) ~= 0 then
		arg_5_0.patch_completed = true
		
		Zlong:gameEventLog(ZLONG_LOG_CODE.CDN_PATCH_COMPLETE)
		Zlong:gameEventLog(ZLONG_LOG_CODE.CDN_PATCH_FINISH)
	end
end

function Zlong.getZlongServerId(arg_6_0)
	if arg_6_0.vars then
		return arg_6_0.vars.server_id or ""
	else
		return ""
	end
end

function Zlong.getZlongServerName(arg_7_0)
	if arg_7_0.vars then
		return arg_7_0.vars.server_name or ""
	else
		return ""
	end
end

function Zlong.getZlongVipLevel(arg_8_0)
	if arg_8_0.vars then
		return tonumber(arg_8_0.vars.channelVipLevel or 0)
	else
		return 0
	end
end

function Zlong.getZlongVipName(arg_9_0)
	if arg_9_0.vars then
		return arg_9_0.vars.channelVipName or ""
	else
		return ""
	end
end

function Zlong.isCreated(arg_10_0)
	return arg_10_0.vars and arg_10_0.vars.is_created
end

function Zlong.getZlongCreateTime(arg_11_0)
	return arg_11_0.vars and arg_11_0.vars.created_at or 0
end

function Zlong.exitGame(arg_12_0, arg_12_1)
	if not Zlong.enable then
		return 
	end
	
	Login.FSM:changeState(LoginState.STANDBY)
	Login.FSM:changeState(LoginState.ZLONG_EXIT_GAME, arg_12_1)
end

function Zlong.startGame(arg_13_0)
	local var_13_0 = {
		RoleId = Account:getUserId() or "",
		GameUid = arg_13_0:getZlongId() or "",
		RoleLevel = Account:getLevel() or 0,
		ServerId = arg_13_0:getZlongServerId(),
		ServerName = arg_13_0:getZlongServerName(),
		RoleName = Account:getName(),
		Balance = Account:getCurrency("crystal"),
		PartyName = Account:getClanId() or "",
		VipLevel = arg_13_0:getZlongVipLevel(),
		RoleCreateTime = arg_13_0:getZlongCreateTime()
	}
	local var_13_1 = json.encode(var_13_0)
	
	call_zlong_async_api("ZlongStartGame", var_13_1)
end

function Zlong.getZlongId(arg_14_0)
	return Zlong.vars and Zlong.vars.zlong_id
end

function Zlong.openUserCenter(arg_15_0)
	if not Zlong.enable then
		return 
	end
	
	call_zlong_async_api("ZlongOpenUserCenter", "")
end

function Zlong.openGeneralWebView(arg_16_0, arg_16_1)
	if not Zlong.enable then
		return 
	end
	
	if not Login.FSM:isCurrentState(LoginState.STANDBY) then
		return 
	end
	
	Login.FSM:changeState(LoginState.ZLONG_GENERAL_WEBVIEW, arg_16_1)
end

function Zlong.openTitleNoticeWebView(arg_17_0)
	if not Zlong.enable then
		return 
	end
	
	print("openTitleNoticeWebView")
	
	function onZlongBaseWebview(arg_18_0)
	end
	
	call_zlong_async_api("ZlongGeneralWebview", json.encode({
		customparams = "",
		action = "notice",
		title_flag = 2,
		title = "",
		fullscreen_flag = 2
	}))
end

function Zlong.cleanPrivacy(arg_19_0)
	if not Zlong.enable then
		return 
	end
	
	call_zlong_async_api("ZlongDoSetExtData", json.encode({
		type = "cleanPrivacy",
		data = ""
	}))
end

function Zlong.doShare(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if not Zlong.enable then
		return 
	end
	
	local var_20_0 = json.encode({
		Url = "",
		shareType = 2,
		SiteUrl = "",
		Text = T("gacha_share_text"),
		Title = T("gacha_share_title"),
		ImagePath = arg_20_1,
		thumbImagePath = arg_20_2,
		sharePlatform = arg_20_3
	})
	
	call_zlong_async_api("ZlongDoShare", var_20_0)
end

function onZlongDoShare(arg_21_0)
	if not Zlong.vars then
		return 
	end
	
	if not arg_21_0 then
		return 
	end
	
	local var_21_0 = json.decode(arg_21_0)
	
	if not var_21_0 then
		return 
	end
	
	if var_21_0.state_code == ZLONG_CODE.DOSHARE_SUCCESS then
	elseif var_21_0.state_code == ZLONG_CODE.DOSHARE_FAILED then
	elseif var_21_0.state_code == ZLONG_CODE.DOSHARE_CANCEL then
	end
end

function Zlong.createRole(arg_22_0)
	if not Zlong.enable then
		return 
	end
	
	local var_22_0 = {
		Balance = 0,
		PushInfo = "",
		PartyName = "",
		RoleId = Account:getUserId(),
		RoleName = Account:getName(),
		RoleLevel = Account:getLevel(),
		GameUid = arg_22_0:getZlongId(),
		ServerId = arg_22_0:getZlongServerId(),
		ServerName = arg_22_0:getZlongServerName(),
		VipLevel = arg_22_0:getZlongVipLevel(),
		RoleCreateTime = arg_22_0:getZlongCreateTime()
	}
	
	call_zlong_async_api("ZlongDoSetExtData", json.encode({
		type = "CreateRole",
		data = json.encode(var_22_0)
	}))
end

function Zlong.roleLevelUp(arg_23_0, arg_23_1)
	if not Zlong.enable then
		return 
	end
	
	local var_23_0 = {
		PushInfo = "",
		RoleId = Account:getUserId(),
		RoleName = Account:getName(),
		RoleLevel = arg_23_1,
		GameUid = arg_23_0:getZlongId(),
		ServerId = arg_23_0:getZlongServerId(),
		ServerName = arg_23_0:getZlongServerName(),
		Balance = Account:getCurrency("crystal"),
		PartyName = Account:getClanId() or "",
		VipLevel = arg_23_0:getZlongVipLevel()
	}
	
	call_zlong_async_api("ZlongDoSetExtData", json.encode({
		type = "RoleLevelUp",
		data = json.encode(var_23_0)
	}))
end

function Zlong.setRoleName(arg_24_0)
	if not Zlong.enable then
		return 
	end
	
	local var_24_0 = {
		RoleId = Account:getUserId(),
		RoleName = Account:getName(),
		GameUid = arg_24_0:getZlongId()
	}
	
	call_zlong_async_api("ZlongDoSetExtData", json.encode({
		type = "SetRoleName",
		data = json.encode(var_24_0)
	}))
end

function Zlong.openStickFaceWebView(arg_25_0)
	if not Zlong.enable then
		return 
	end
	
	call_zlong_async_api("ZlongOpenStickFaceWebView")
end

local function var_0_0(arg_26_0, arg_26_1)
	if arg_26_0 == nil then
		return false
	end
	
	arg_26_1 = arg_26_1 or 60
	
	if arg_26_1 < os.time() - arg_26_0 then
		return false
	end
	
	return true
end

local function var_0_1(arg_27_0)
	arg_27_0 = tonumber(arg_27_0)
	
	if IS_ANDROID_BASED_PLATFORM and arg_27_0 == ZLONG_CODE.REQUEST_NOTICENODE_SUCCESS then
		return true
	end
	
	if PLATFORM == "iphoneos" and arg_27_0 == 1 then
		return true
	end
	
	return false
end

function onZlongRequestNoticeNode(arg_28_0)
	if not Zlong.vars then
		return 
	end
	
	if not arg_28_0 then
		return 
	end
	
	local var_28_0 = json.decode(arg_28_0)
	
	if not var_28_0 then
		return 
	end
	
	if not var_0_1(var_28_0.state_code) then
		Log.e("ZlongError " .. (var_28_0.state_code or " ") .. ", message: " .. (var_28_0.message or " "))
		
		return 
	end
	
	local var_28_1 = json.decode(var_28_0.data)
	
	if not var_28_1 then
		return 
	end
	
	if not var_28_1.redInfo then
		return 
	end
	
	if var_28_1.redInfo.root_usercenter then
		local var_28_2 = var_28_1.redInfo.root_usercenter
		
		if var_28_2.nodeId == "root_usercenter" then
			Zlong.vars.is_red_dot_faq = var_28_2.status == 1
			
			if Zlong.vars.red_dot_faq_callback then
				Zlong.vars.red_dot_faq_callback(Zlong.vars.is_red_dot_faq)
			end
		end
	elseif var_28_1.redInfo.root_activity then
		local var_28_3 = var_28_1.redInfo.root_activity
		
		if var_28_3.nodeId == "root_activity" then
			Zlong.vars.is_red_dot_web_event = var_28_3.status == 1
			
			if Zlong.vars.red_dot_event_callback then
				Zlong.vars.red_dot_event_callback(Zlong.vars.is_red_dot_web_event)
			end
		end
	end
end

function Zlong.reqIsRedDotFaq(arg_29_0, arg_29_1)
	if not arg_29_0.vars then
		return 
	end
	
	if not arg_29_0.enable then
		return 
	end
	
	if var_0_0(arg_29_0.vars.last_req_time_is_red_dot_faq, arg_29_1.repeat_limit_duration) then
		if arg_29_1.callback then
			arg_29_1.callback(arg_29_0.vars.is_red_dot_faq or false)
		end
		
		return 
	end
	
	arg_29_0.vars.last_req_time_is_red_dot_faq = os.time()
	arg_29_0.vars.red_dot_faq_callback = arg_29_1.callback
	
	call_zlong_async_api("ZlongGetNoticeNodeState", json.encode({
		notice_id = "root_usercenter",
		mode = 0
	}))
end

function Zlong.reqIsRedDotWebEvent(arg_30_0, arg_30_1)
	if not arg_30_0.vars then
		return 
	end
	
	if not arg_30_0.enable then
		return 
	end
	
	if var_0_0(arg_30_0.vars.last_req_time_is_red_dot_web_event, arg_30_1.repeat_limit_duration) then
		if arg_30_1.callback then
			arg_30_1.callback(arg_30_0.vars.is_red_dot_web_event or false)
		end
		
		return 
	end
	
	arg_30_0.vars.last_req_time_is_red_dot_web_event = os.time()
	arg_30_0.vars.red_dot_event_callback = arg_30_1.callback
	
	call_zlong_async_api("ZlongGetNoticeNodeState", json.encode({
		notice_id = "root_activity",
		mode = 0
	}))
end

function Zlong.doOpenRequestReview(arg_31_0)
	if not Zlong.enable then
		return 
	end
	
	if not Login.FSM:isCurrentState(LoginState.STANDBY) then
		return 
	end
	
	call_zlong_async_api("ZlongDoOpenRequestReview", "")
end

Login.FSM.STATES[LoginState.ZLONG_PRE_STANDBY_DOWNLOAD] = {}
Login.FSM.STATES[LoginState.ZLONG_PRE_STANDBY_DOWNLOAD].onUpdate = function(arg_32_0)
	if getenv("patch.status") == "complete" then
		Login.FSM:changeState(LoginState.ZLONG_CHECK_LOGIN)
	end
end
Login.FSM.STATES[LoginState.ZLONG_PRE_STANDBY_MAINTENANCE] = {}
Login.FSM.STATES[LoginState.ZLONG_CHECK_LOGIN] = {}
Login.FSM.STATES[LoginState.ZLONG_CHECK_LOGIN].onEnter = function(arg_33_0, arg_33_1)
	if cc.UserDefault:getInstance():getStringForKey("ZlongLastLoginState", "") == "LOGIN_SUCCESS" then
		Login.FSM:changeState(LoginState.ZLONG_LOGIN)
	else
		Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
	end
end
Login.FSM.STATES[LoginState.ZLONG_WAIT_LOGIN] = {}
Login.FSM.STATES[LoginState.ZLONG_WAIT_LOGIN].onEnter = function(arg_34_0, arg_34_1)
	arg_34_0.show_ui = false
end
Login.FSM.STATES[LoginState.ZLONG_WAIT_LOGIN].onUpdate = function(arg_35_0)
	if not arg_35_0.show_ui and SceneManager:getCurrentSceneName() == "title" then
		local var_35_0 = SceneManager:getCurrentScene()
		
		if get_cocos_refid(var_35_0.layer) then
			setenv("patch.background", true)
			var_35_0:setTouchMode(false)
			var_35_0:showStoveLoginUI(true)
			var_35_0:setMessage("")
			
			arg_35_0.show_ui = true
			
			Zlong:gameEventLog(ZLONG_LOG_CODE.LOGIN_BUTTON_SHOW)
		end
	end
end
Login.FSM.STATES[LoginState.ZLONG_WAIT_LOGIN].onExit = function(arg_36_0)
	local var_36_0 = SceneManager:getCurrentScene()
	
	if get_cocos_refid(var_36_0.layer) then
		setenv("patch.background", false)
		var_36_0:showStoveLoginUI(false)
	end
end
Login.FSM.STATES[LoginState.ZLONG_LOGIN] = {}
Login.FSM.STATES[LoginState.ZLONG_LOGIN].onEnter = function(arg_37_0, arg_37_1)
	function onZlongLogin(arg_38_0)
		arg_37_0:onReceive(arg_38_0)
	end
	
	Zlong.vars = {}
	
	call_zlong_async_api("ZlongLogin", "")
end
Login.FSM.STATES[LoginState.ZLONG_LOGIN].onReceive = function(arg_39_0, arg_39_1)
	print("Login.FSM.ZLONG_LOGIN.onReceive.")
	
	local var_39_0 = json.decode(arg_39_1)
	
	table.print(var_39_0)
	
	if var_39_0.state_code == ZLONG_CODE.LOGIN_SUCCESS then
		cc.UserDefault:getInstance():setStringForKey("ZlongLastLoginState", "LOGIN_SUCCESS")
		Zlong:gameEventLog(ZLONG_LOG_CODE.LOGIN_SUCCESS)
		
		var_39_0.action = "notice"
		var_39_0.fullscreen_flag = 2
		var_39_0.title_flag = 2
		
		if getenv("verinfo.status") == "pre_standby" then
			var_39_0.webview_next_state = LoginState.ZLONG_PRE_STANDBY_MAINTENANCE
		else
			var_39_0.webview_next_state = LoginState.ZLONG_SELECT_WORLD
		end
		
		Login.FSM:changeState(LoginState.ZLONG_GENERAL_WEBVIEW, var_39_0)
		
		return 
	elseif var_39_0.state_code == ZLONG_CODE.LOGIN_CANCEL then
		Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
		
		return 
	elseif var_39_0.state_code == ZLONG_CODE.LOGIN_FAILED then
		balloon_message((var_39_0.message or "") .. " (" .. tostring(var_39_0.state_code) .. ")")
		Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
		
		return 
	else
		Zlong:handleZlongError(LoginState.ZLONG_LOGIN, var_39_0)
		Zlong:gameEventLog(ZLONG_LOG_CODE.LOGIN_FAILED)
		
		return 
	end
end
Login.FSM.STATES[LoginState.ZLONG_SELECT_WORLD] = {}
Login.FSM.STATES[LoginState.ZLONG_SELECT_WORLD].onEnter = function(arg_40_0, arg_40_1)
	arg_40_0.params = arg_40_1
	
	local var_40_0 = getenv("zlong.recommend_region", "zlong1")
	
	print("default_region : ", var_40_0)
	
	local var_40_1 = Login:getLocalSavedRegion(var_40_0)
	
	print("selected_region : ", var_40_1)
	arg_40_0:onSelectRegion(var_40_1)
end
Login.FSM.STATES[LoginState.ZLONG_SELECT_WORLD].onSelectRegion = function(arg_41_0, arg_41_1)
	print("Login.FSM.ZLONG_SELECT_WORLD.onSelectRegion", arg_41_1)
	Login:setLocalSavedRegion(arg_41_1)
	
	local var_41_0 = "world_" .. tostring(arg_41_1)
	local var_41_1 = "world_" .. arg_41_1
	
	if getenv("is_review", "") == "1" then
		var_41_1 = "review_zlong1"
	end
	
	if getenv("verinfo.status." .. var_41_1, "") == "maintenance" then
		Login.FSM:changeState(LoginState.MAINTENANCE_REGION, {
			region = arg_41_1
		})
		
		return 
	end
	
	local var_41_2 = getenv("app.api." .. var_41_0, "")
	
	if not PRODUCTION_MODE and getenv("develoment.enable", "") == "true" then
		print("[app] Enabled Flags : develoment.enable = true ")
		
		local var_41_3 = getenv("develoment.app.api", "")
		
		if var_41_3 ~= "" then
			print("develoment.app.api : " .. var_41_3)
			
			var_41_2 = var_41_3
		end
	end
	
	setenv("app.api", var_41_2)
	print("set app.api : ", var_41_2)
	
	arg_41_0.params.world_id = var_41_0
	arg_41_0.params.api_world_id = var_41_0
	arg_41_0.params.next_login_state = LoginState.QUERY_ZLONG_LOGIN
	
	Login.FSM:changeState(LoginState.TICKET_WAIT, arg_41_0.params)
end
Login.FSM.STATES[LoginState.QUERY_ZLONG_LOGIN] = {}
Login.FSM.STATES[LoginState.QUERY_ZLONG_LOGIN].onEnter = function(arg_42_0, arg_42_1)
	arg_42_0.params = arg_42_1
	
	table.print(arg_42_1)
	
	MsgHandler.login_zlong = MsgHandler.login_zlong or function(arg_43_0)
		arg_42_0:onReceive(arg_43_0)
	end
	ErrHandler.login_zlong = ErrHandler.login_zlong or function(arg_44_0, arg_44_1, arg_44_2)
		arg_42_0:onReceiveError(arg_44_0, arg_44_1, arg_44_2)
	end
	Zlong.vars.zlong_id = nil
	Zlong.vars.channel_id = arg_42_1.channel_id
	
	query("login_zlong", {
		opcode = arg_42_1.opcode,
		data = arg_42_1.data,
		channel_id = arg_42_1.channel_id,
		operators = arg_42_1.operators
	})
end
Login.FSM.STATES[LoginState.QUERY_ZLONG_LOGIN].onReceive = function(arg_45_0, arg_45_1)
	print("Login.FSM.QUERY_ZLONG_LOGIN.onReceive ")
	table.print(arg_45_1)
	
	if arg_45_1.response then
		if arg_45_1.response.state == 200 then
			if arg_45_1.response.data then
				if tostring(arg_45_1.response.data.status) == "1" then
					Zlong.vars.is_created = arg_45_1.is_created
					Zlong.vars.created_at = arg_45_1.created_at
					Zlong.vars.server_id = arg_45_1.server_id
					Zlong.vars.server_name = arg_45_1.server_name
					Zlong.vars.channelVipLevel = arg_45_1.response.data.channelVipLevel
					Zlong.vars.channelVipName = arg_45_1.response.data.channelVipName
					Zlong.vars.zlong_id = arg_45_1.response.data.userid
					
					Login.FSM:changeState(LoginState.SYNC_TIME, {
						world_id = arg_45_0.params.world_id,
						id = arg_45_1.id,
						password = arg_45_1.password,
						zlong_id = arg_45_1.response.data.userid,
						tag = arg_45_1.response.tag
					})
					ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_INITIALIZE)
					TitleBackground:updateVersionInfo()
					
					return 
				else
					local var_45_0 = {}
					
					var_45_0["-1"] = "验证TOKEN失败"
					var_45_0["1001"] = "接口访问频率已达上限"
					var_45_0["1002"] = "服务器内部错误"
					var_45_0["1099"] = "其他错误"
					var_45_0["1101"] = "尊敬的用户，您所在的渠道由于违规操作，已经无法登录,请联系客服。"
					var_45_0["1102"] = "尊敬的用户，您所在的游戏渠道暂不开放新晋用户的登记注册。"
					var_45_0["1103"] = "尊敬的用户，本次测试为限量测试，目前人数已满，暂不开放新晋用户登记注册。"
					var_45_0["1104"] = "由于您的账户存在异常的游戏行为，您的账号已经被禁用。"
					var_45_0["1105"] = "由于您的账户存在异常的游戏行为，您的账号已经被禁用。"
					var_45_0["1106"] = "您的商店退款已成功完成，为保障游戏环境的公平，我们已限制了该账号登录，若您希望继续游戏，请登录退款账号对应的商店最新客户端进行补款，感谢您的支持"
					var_45_0["1107"] = "亲爱的玩家，您的账号未激活，请激活后登录游戏。"
					
					Log.e("QUERY_ZLONG_LOGIN ", arg_45_1.response.data.status)
					
					local var_45_1 = tostring(arg_45_1.response.data.status)
					
					Zlong:handleZlongError(LoginState.QUERY_ZLONG_LOGIN, {
						status = var_45_1,
						message = var_45_0[var_45_1] or "status : " .. var_45_1
					}, function()
						Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
					end)
					
					return 
				end
			else
				Log.e("QUERY_ZLONG_LOGIN : response data is nil")
				Zlong:handleZlongError(LoginState.QUERY_ZLONG_LOGIN, {
					message = "response data: nil",
					status = "nil"
				}, function()
					Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
				end)
				
				return 
			end
		else
			Log.e("QUERY_ZLONG_LOGIN failed. state: " .. tostring(arg_45_1.response.state or "") .. " error : " .. tostring(arg_45_1.response.error or ""))
			Zlong:handleZlongError(LoginState.QUERY_ZLONG_LOGIN, {
				message = "state: " .. tostring(arg_45_1.response.state or "") .. " error: " .. tostring(arg_45_1.response.error or "")
			}, function()
				Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
			end)
			
			return 
		end
	else
		Log.e("QUERY_ZLONG_LOGIN : response response is nil")
		Zlong:handleZlongError(LoginState.QUERY_ZLONG_LOGIN, {
			message = "response: nil"
		}, function()
			Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
		end)
		
		return 
	end
end
Login.FSM.STATES[LoginState.QUERY_ZLONG_LOGIN].onReceiveError = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	print("Login.FSM.QUERY_ZLONG_LOGIN.onReceiveError ", arg_50_1, arg_50_2)
	Zlong:handleZlongError(LoginState.QUERY_ZLONG_LOGIN, {
		message = "err: " .. tostring(arg_50_2 or "")
	}, function()
		Login.FSM:changeState(LoginState.ZLONG_WAIT_LOGIN)
	end)
end
Login.FSM.STATES[LoginState.ZLONG_LOGOUT] = {}
Login.FSM.STATES[LoginState.ZLONG_LOGOUT].onEnter = function(arg_52_0, arg_52_1)
	arg_52_0.params = arg_52_1
	
	function onZlongLogout(arg_53_0)
		arg_52_0:onReceive(arg_53_0)
	end
	
	if SceneManager:getCurrentSceneName() == "title" then
		local var_52_0 = SceneManager:getCurrentScene()
		
		if get_cocos_refid(var_52_0.layer) then
			SAVE:setUserDefaultData("zlong_check_terms", false)
			var_52_0:setZlongTermsCheckbox(false)
		end
	end
	
	call_zlong_async_api("ZlongLogout", "")
end
Login.FSM.STATES[LoginState.ZLONG_LOGOUT].onReceive = function(arg_54_0, arg_54_1)
	print("Login.FSM.ZLONG_LOGOUT.onReceive ")
	
	local var_54_0 = json.decode(arg_54_1)
	
	table.print(var_54_0)
	
	if var_54_0.state_code == ZLONG_CODE.LOGOUT_SUCCESS then
		Login:setLocalSavedRegion("")
		cc.UserDefault:getInstance():setStringForKey("ZlongLastLoginState", "LOGOUT_SUCCESS")
		Login:removeLocalData()
		restart_contents()
	else
		Zlong:handleZlongError(LoginState.ZLONG_LOGOUT, var_54_0)
	end
end
Login.FSM.STATES[LoginState.ZLONG_GENERAL_WEBVIEW] = {}
Login.FSM.STATES[LoginState.ZLONG_GENERAL_WEBVIEW].onEnter = function(arg_55_0, arg_55_1)
	print("FSM.STATES[LoginState.ZLONG_GENERAL_WEBVIEW].onEnter")
	
	function onZlongBaseWebview(arg_56_0)
		arg_55_0:onReceive(arg_56_0)
	end
	
	arg_55_0.params = arg_55_1 or {}
	
	Zlong:gameEventLog(ZLONG_LOG_CODE.POPUP_NOTICE)
	call_zlong_async_api("ZlongGeneralWebview", json.encode({
		title = arg_55_0.params.title or "",
		fullscreen_flag = arg_55_0.params.fullscreen_flag or 0,
		title_flag = arg_55_0.params.title_flag or 0,
		action = arg_55_0.params.action or "",
		customparams = arg_55_0.params.customparams or ""
	}))
end
Login.FSM.STATES[LoginState.ZLONG_GENERAL_WEBVIEW].onReceive = function(arg_57_0, arg_57_1)
	if not Login.FSM.isCurrentState(LoginState.ZLONG_GENERAL_WEBVIEW) then
		return 
	end
	
	print("Login.FSM.STATES[LoginState.ZLONG_GENERAL_WEBVIEW].onReceive")
	
	local var_57_0 = json.decode(arg_57_1)
	
	table.print(var_57_0)
	
	if var_57_0.state_code == ZLONG_CODE.BASEWEBVIEW_FAILED then
		Log.e("ZlongError " .. (var_57_0.state_code or " ") .. ", message: " .. (var_57_0.message or " "))
		
		if arg_57_0.params.webview_next_state then
			Login.FSM:changeState(arg_57_0.params.webview_next_state, arg_57_0.params)
		else
			Login.FSM:changeState(LoginState.STANDBY)
		end
		
		return 
	end
	
	local var_57_1 = json.decode(var_57_0.data)
	
	if arg_57_0.params.webview_next_state then
		Login.FSM:changeState(arg_57_0.params.webview_next_state, arg_57_0.params)
	else
		Login.FSM:changeState(LoginState.STANDBY)
	end
	
	if var_57_1.action == "faq" then
		Zlong:reqIsRedDotFaq({
			repeat_limit_duration = 0,
			callback = arg_57_0.params.callback
		})
	elseif var_57_1.action == "activity" then
		Zlong:reqIsRedDotWebEvent({
			repeat_limit_duration = 0,
			callback = arg_57_0.params.callback
		})
	end
end
Login.FSM.STATES[LoginState.ZLONG_EXIT_GAME] = {}
Login.FSM.STATES[LoginState.ZLONG_EXIT_GAME].onEnter = function(arg_58_0, arg_58_1)
	print("Login.FSM.STATES[LoginState.ZLONG_EXIT_GAME].onEnter")
	
	function onZlongExit(arg_59_0)
		arg_58_0:onReceive(arg_59_0)
	end
	
	arg_58_0.params = arg_58_1
	
	call_zlong_async_api("ZlongExitGame")
	Login.FSM:changeState(LoginState.STANDBY)
end
Login.FSM.STATES[LoginState.ZLONG_EXIT_GAME].onReceive = function(arg_60_0, arg_60_1)
	print("Login.FSM.STATES[LoginState.ZLONG_EXIT_GAME].onReceive")
	
	local var_60_0 = json.decode(arg_60_1)
	
	table.print(var_60_0)
	
	if var_60_0.state_code == ZLONG_CODE.GAME_EXIT_SUCCESS and arg_60_0.params and arg_60_0.params.callback then
		arg_60_0.params.callback()
	end
end
