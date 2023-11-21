NetWaiting = NetWaiting or {}

local var_0_0 = "net_waiting_schduler"
local var_0_1 = 4000
local var_0_2 = 2000

local function var_0_3(arg_1_0, arg_1_1)
	reqNextQuery()
end

local function var_0_4(arg_2_0, arg_2_1)
	reqNextQuery()
end

local function var_0_5(arg_3_0, arg_3_1)
	removeAllQuery()
	
	if SceneManager:getCurrentSceneName() ~= "title" then
		restart_contents()
	else
		Login.FSM:changeState(LoginState.INITIALIZE)
	end
end

function onNetWaitingCreateNode(arg_4_0)
	local var_4_0 = tolua.type(arg_4_0)
	
	if var_4_0 == "ccui.Text" or var_4_0 == "ccui.TextField" then
		if DEBUG.TEST_UI_TEXT and string.len(arg_4_0:getString()) > 2 then
			arg_4_0:setString("ui:" .. arg_4_0:getName())
		end
		
		local var_4_1 = getUIControlTextData(arg_4_0)
		local var_4_2 = T(var_4_1, var_4_1)
		
		if DEBUG.TEST_UI_TEXT and var_4_1 and string.len(arg_4_0:getString()) > 2 then
			print("UI TEXT:", arg_4_0:getString(), var_4_1, var_4_2)
		end
		
		if var_4_1 then
			if var_4_0 == "ccui.TextField" then
				arg_4_0:setPlaceHolder(var_4_2)
			else
				arg_4_0:setString(var_4_2)
			end
		elseif var_4_0 == "ccui.TextField" then
			arg_4_0:setPlaceHolder("")
		else
			arg_4_0:setString("")
		end
	elseif var_4_0 == "ccui.Button" or var_4_0 == "ccui.CheckBox" then
		arg_4_0:addTouchEventListener(function(arg_5_0, arg_5_1)
			onNetWaitingEventEnter(arg_5_0, arg_5_1)
		end)
	end
end

function onNetWaitingEventEnter(arg_6_0, arg_6_1)
	if ccui.TouchEventType.ended == arg_6_1 then
		local var_6_0 = getParentWindow(arg_6_0)["--handler"]
		
		if var_6_0 then
			NetWaiting:hideWatting()
			var_6_0()
		end
	end
end

function NetWaiting.updateOffsetDlg(arg_7_0)
	if get_cocos_refid(arg_7_0.wnd_running) then
		arg_7_0.wnd_running:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
		arg_7_0.wnd_running:getChildByName("btn_close"):setContentSize(SCREEN_WIDTH, SCREEN_HEIGHT)
	end
	
	if get_cocos_refid(arg_7_0.err_dialog) then
		arg_7_0.err_dialog:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	end
end

function NetWaiting.createDialog(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or {}
	
	local var_8_0 = cc.CSLoader:createNode(arg_8_1, onNetWaitingCreateNode)
	
	var_8_0:setUserObject(get_CSB_CHECK_NODE())
	var_8_0:setAnchorPoint(0.5, 0.5)
	var_8_0:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	var_8_0:setScale(WIDGET_SCALE_FACTOR)
	
	for iter_8_0, iter_8_1 in pairs(var_8_0:getChildren()) do
		local var_8_1 = iter_8_1:getContentSize()
		
		var_8_1.width = VIEW_WIDTH
		
		iter_8_1:setContentSize(var_8_1)
	end
	
	local var_8_2 = var_8_0:getChildByName("window_frame")
	
	if var_8_2 then
		local var_8_3 = var_8_2:getContentSize()
		
		var_8_3.width = VIEW_WIDTH
		
		var_8_2:setContentSize(var_8_3)
	end
	
	var_8_0["--handler"] = arg_8_2.handler
	
	if_set_visible(var_8_0, "n_title", false)
	if_set_visible(var_8_0, "txt_title", false)
	if_set_visible(var_8_0, "btn_yes", arg_8_2.yesno)
	if_set_visible(var_8_0, "txt_yes", arg_8_2.yesno)
	if_set_visible(var_8_0, "btn_cancel", arg_8_2.yesno)
	if_set_visible(var_8_0, "txt_cancel", arg_8_2.yesno)
	if_set_visible(var_8_0, "btn_ok", not arg_8_2.yesno)
	if_set_visible(var_8_0, "txt_ok", not arg_8_2.yesno)
	if_set_visible(var_8_0, "n_buttons", false)
	if_set_visible(var_8_0, "n_cost_buttons", false)
	
	local var_8_4 = var_8_0:getChildByName("text")
	
	if get_cocos_refid(var_8_4) then
		var_8_4:setString(PROC_KR(arg_8_2.text))
	end
	
	if arg_8_2.tab_txt then
		if_set(var_8_0, "txt_tab", arg_8_2.tab_txt)
	end
	
	if SceneManager:getCurrentSceneName() == "title" then
		local var_8_5 = var_8_0:getChildByName("dim_msgbox")
		
		if var_8_5 then
			local var_8_6 = var_8_5:getContentSize()
			
			var_8_5:setContentSize(var_8_6.width, var_8_6.height * 2)
		end
		
		local var_8_7 = var_8_0:getChildByName("btn_default")
		
		if var_8_7 then
			local var_8_8 = var_8_7:getContentSize()
			
			var_8_7:setContentSize(var_8_8.width, var_8_8.height * 2)
		end
	end
	
	SceneManager:addAlertControl(var_8_0)
	var_8_0:setOpacity(0)
	UIAction:Add(OPACITY(100, 0, 1), var_8_0, "block")
	
	return var_8_0
end

function NetWaiting.onNetworkError(arg_9_0, arg_9_1)
	arg_9_0:hideWatting()
	
	arg_9_0.retry_count = arg_9_0.retry_count + 1
	
	if arg_9_0.retry_count < 3 then
		local var_9_0 = T("game_connect_try")
		
		arg_9_0.err_dialog = assert(arg_9_0:createDialog("wnd/msgbox.csb", {
			text = var_9_0,
			handler = var_0_3,
			tab_txt = T("tab_to_retry")
		}))
		arg_9_0.err_dialog_end_tm = systick() + var_0_1 + (arg_9_0.retry_count - 1) * var_0_2
		
		if arg_9_1 then
			local var_9_1 = arg_9_0.err_dialog:getChildByName("txt_code")
			
			if var_9_1 then
				var_9_1:setString(T("code") .. " : " .. tostring(arg_9_1))
			end
		end
		
		local function var_9_2(arg_10_0)
			if not arg_10_0.err_dialog then
				return 
			end
			
			local var_10_0 = arg_10_0.err_dialog_end_tm - systick()
			local var_10_1 = math.floor(var_10_0 / 1000)
			
			if_set(arg_10_0.err_dialog, "txt_warning", tostring(var_10_1))
			if_set_visible(arg_10_0.err_dialog, "txt_warning", var_10_1 > 0)
			if_set_visible(arg_10_0.err_dialog, "btn_ok", var_10_1 <= 0)
			if_set_visible(arg_10_0.err_dialog, "btn_default", var_10_1 <= 0)
		end
		
		var_9_2(arg_9_0)
		Scheduler:addSlow(arg_9_0.err_dialog, var_9_2, arg_9_0)
	else
		arg_9_0.err_dialog = assert(arg_9_0:createDialog("wnd/msgbox.csb", {
			text = T("game_connect_lost"),
			handler = var_0_5,
			tab_txt = T("tab_to_retry")
		}))
		
		if_set(arg_9_0.err_dialog, "txt_warning", "")
	end
end

function NetWaiting.onServerBusy(arg_11_0, arg_11_1)
	arg_11_0:hideWatting()
	
	local var_11_0 = T("server_busy_msg")
	
	arg_11_0.err_dialog = assert(arg_11_0:createDialog("wnd/msgbox.csb", {
		text = var_11_0,
		handler = var_0_4,
		tab_txt = T("tab_to_retry")
	}))
	arg_11_0.err_dialog_end_tm = systick() + tonumber(arg_11_1.time) * 1000
	
	local function var_11_1(arg_12_0)
		if not arg_12_0.err_dialog then
			return 
		end
		
		local var_12_0 = arg_12_0.err_dialog_end_tm - systick()
		local var_12_1 = math.floor(var_12_0 / 1000)
		
		if_set(arg_12_0.err_dialog, "txt_warning", tostring(var_12_1))
		if_set_visible(arg_12_0.err_dialog, "txt_warning", var_12_1 > 0)
		if_set_visible(arg_12_0.err_dialog, "btn_ok", var_12_1 <= 0)
		if_set_visible(arg_12_0.err_dialog, "btn_default", var_12_1 <= 0)
	end
	
	var_11_1(arg_11_0)
	Scheduler:addSlow(arg_11_0.err_dialog, var_11_1, arg_11_0)
end

function NetWaiting.onLostQueryHandler(arg_13_0)
	arg_13_0:hideWatting()
	
	arg_13_0.err_dialog = assert(arg_13_0:createDialog("wnd/msgbox.csb", {
		text = T("game_connect_error"),
		handler = var_0_5,
		tab_txt = T("tab_to_retry")
	}))
end

function NetWaiting.onQuery(arg_14_0)
	if not arg_14_0.scheduler then
		arg_14_0.scheduler = Scheduler:addGlobalInterval(400, arg_14_0.onUpdate, arg_14_0)
		
		arg_14_0.scheduler:setName(var_0_0)
		
		arg_14_0.retry_count = 0
	end
	
	arg_14_0.start_time = os.time()
end

function NetWaiting.onUpdate(arg_15_0)
	if #QueryList < 1 then
		arg_15_0:clear()
		
		return 
	end
	
	arg_15_0:onUpdateWndRunning()
end

function NetWaiting.onUpdateWndRunning(arg_16_0)
	if get_cocos_refid(arg_16_0.wnd_running) then
		arg_16_0.tick = to_n(arg_16_0.tick) + 1
		
		if_set_visible(arg_16_0.wnd_running, "img_1", arg_16_0.tick % 2 == 0)
		if_set_visible(arg_16_0.wnd_running, "img_2", arg_16_0.tick % 2 ~= 0)
	end
	
	if get_cocos_refid(arg_16_0.err_dialog) then
		return 
	end
	
	local var_16_0 = os.time() - arg_16_0.start_time
	
	if var_16_0 < 3 then
		return 
	end
	
	if QueryList.processing then
		local var_16_1 = getenv("allow.bypass_lua_error", "")
		local var_16_2 = true
		
		if var_16_1 and var_16_1 ~= "" and DEBUG_INFO.last_report and string.find(DEBUG_INFO.last_report, var_16_1, 1, true) then
			Log.e("bypass lua error :", var_16_1)
			
			var_16_2 = false
		end
		
		if var_16_2 then
			restart_contents()
		else
			arg_16_0:clear()
			removeAllQuery()
			
			QueryList.processing = nil
		end
		
		return 
	end
	
	if var_16_0 < 10 then
		arg_16_0:showWaiting()
	end
end

function NetWaiting.showWaiting(arg_17_0)
	if get_cocos_refid(arg_17_0.wnd_running) then
		arg_17_0.wnd_running:setVisible(true)
		
		return 
	end
	
	local var_17_0 = assert(arg_17_0:createDialog("wnd/net_waiting.csb"))
	local var_17_1 = var_17_0:getChildByName("text_name")
	
	if var_17_1 then
		var_17_1:setString(T("capital_connecting"))
		var_17_1:setVisible(true)
	end
	
	var_17_0:setLocalZOrder(var_17_0:getLocalZOrder() + 1)
	
	arg_17_0.wnd_running = var_17_0
end

function NetWaiting.hideWatting(arg_18_0)
	if get_cocos_refid(arg_18_0.wnd_running) then
		arg_18_0.wnd_running:removeFromParent()
	end
	
	arg_18_0.wnd_running = nil
	
	if get_cocos_refid(arg_18_0.err_dialog) then
		arg_18_0.err_dialog:removeFromParent()
	end
	
	arg_18_0.err_dialog = nil
end

function NetWaiting.clear(arg_19_0)
	if arg_19_0.scheduler then
		Scheduler:removeByName(var_0_0)
	end
	
	arg_19_0.scheduler = nil
	
	arg_19_0:hideWatting()
	
	arg_19_0.start_time = nil
end

function NetWaiting.isWaiting(arg_20_0)
	return arg_20_0.scheduler ~= nil
end
