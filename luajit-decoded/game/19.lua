StoveIap = StoveIap or {}
StoveIap.FSM = StoveIap.FSM or {}
StoveIap.FSM.STATES = StoveIap.FSM.STATES or {}
StoveIap.vars = StoveIap.vars or {}
StoveIapState = {
	STOVE_IAP_STANDBY = "STOVE_IAP_STANDBY",
	STOVE_IAP_INITIALIZE = "STOVE_IAP_INITIALIZE",
	STOVE_IAP_SERVER_PURCHASE_ACQUIRE = "STOVE_IAP_SERVER_PURCHASE_ACQUIRE",
	STOVE_IAP_SERVER_CHECK_ITEM = "STOVE_IAP_SERVER_CHECK_ITEM",
	STOVE_IAP_WAIT_PAYMENT = "STOVE_IAP_WAIT_PAYMENT",
	STOVE_IAP_PROBLEM = "STOVE_IAP_PROBLEM",
	STOVE_IAP_REFRESH_TOKEN = "STOVE_IAP_REFRESH_TOKEN",
	STOVE_IAP_START_PURCHASE = "STOVE_IAP_START_PURCHASE",
	STOVE_IAP_FETCH_PRODUCT = "STOVE_IAP_FETCH_PRODUCT"
}

function StoveIap.FSM.isCurrentState(arg_1_0, arg_1_1)
	return arg_1_1 == arg_1_0.current_state
end

function StoveIap.FSM.getCurrentStateString(arg_2_0)
	return arg_2_0.current_state or ""
end

function StoveIap.FSM.getCmdQueueSize(arg_3_0)
	if arg_3_0.reserved_state_queue then
		return #arg_3_0.reserved_state_queue
	else
		return 0
	end
end

function StoveIap.FSM.changeState(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._is_recursive or not arg_4_0.STATES[arg_4_1] then
		arg_4_0.reserved_state_queue = arg_4_0.reserved_state_queue or {}
		
		print("Login FSM ChangeState Add Queue [" .. tostring(arg_4_0:getCurrentStateString()) .. "]  to  [" .. tostring(arg_4_1) .. "]")
		table.insert(arg_4_0.reserved_state_queue, {
			state = arg_4_1,
			params = arg_4_2
		})
	else
		arg_4_0:_changeStateImmediate(arg_4_1, arg_4_2)
	end
end

function StoveIap.FSM._changeStateImmediate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_onExit(arg_5_0.current_state)
	print("Login FSM ChangeStateImmediate [" .. tostring(arg_5_0:getCurrentStateString()) .. "]  to  [" .. tostring(arg_5_1) .. "]")
	
	arg_5_0.current_state = arg_5_1
	
	arg_5_0:_onEnter(arg_5_0.current_state, arg_5_2)
end

function StoveIap.FSM.update(arg_6_0)
	if arg_6_0.current_state then
		arg_6_0:_onUpdate(arg_6_0.current_state)
	end
	
	if arg_6_0.reserved_state_queue and #arg_6_0.reserved_state_queue > 0 and arg_6_0.STATES[arg_6_0.reserved_state_queue[1].state] then
		arg_6_0:_changeStateImmediate(arg_6_0.reserved_state_queue[1].state, arg_6_0.reserved_state_queue[1].params)
		table.remove(arg_6_0.reserved_state_queue, 1)
	end
	
	if arg_6_0.updateWaitScreen then
		arg_6_0:updateWaitScreen()
	end
end

function StoveIap.FSM._onEnter(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0.STATES[arg_7_1] and arg_7_0.STATES[arg_7_1].onEnter then
		arg_7_0._is_recursive = true
		
		print("StoveIap.FSM." .. arg_7_0:getCurrentStateString() .. ".onEnter")
		arg_7_0.STATES[arg_7_1]:onEnter(arg_7_2)
		
		arg_7_0._is_recursive = false
	end
end

function StoveIap.FSM._onUpdate(arg_8_0, arg_8_1)
	if arg_8_0.STATES[arg_8_1] and arg_8_0.STATES[arg_8_1].onUpdate then
		arg_8_0._is_recursive = true
		
		arg_8_0.STATES[arg_8_1]:onUpdate()
		
		arg_8_0._is_recursive = false
	end
end

function StoveIap.FSM._onExit(arg_9_0, arg_9_1)
	if arg_9_0.STATES[arg_9_1] and arg_9_0.STATES[arg_9_1].onExit then
		arg_9_0._is_recursive = true
		
		print("StoveIap.FSM." .. arg_9_0:getCurrentStateString() .. ".onExit")
		arg_9_0.STATES[arg_9_1]:onExit()
		
		arg_9_0._is_recursive = false
	end
end

function StoveIap.FSM.updateWaitScreen(arg_10_0)
	if not Stove.enable then
		return 
	end
	
	if not arg_10_0.current_state then
		return 
	end
	
	if arg_10_0.current_state == StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM or arg_10_0.current_state == StoveIapState.STOVE_IAP_START_PURCHASE or arg_10_0.current_state == StoveIapState.STOVE_IAP_REFRESH_TOKEN or arg_10_0.current_state == StoveIapState.STOVE_IAP_WAIT_PAYMENT or arg_10_0.current_state == StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE then
		if not get_cocos_refid(StoveIap.vars.wait_wnd) then
			local var_10_0 = SceneManager:getRunningPopupScene()
			
			if var_10_0 then
				print("Show Stove Wait Screen")
				
				StoveIap.vars.wait_wnd = load_dlg("net_waiting", true, "wnd")
				
				StoveIap.vars.wait_wnd:setName("stove_wait")
				StoveIap.vars.wait_wnd:setAnchorPoint(0, 0)
				StoveIap.vars.wait_wnd:setPosition(0, 0)
				StoveIap.vars.wait_wnd:setLocalZOrder(StoveIap.vars.wait_wnd:getLocalZOrder() + 1)
				
				local var_10_1 = StoveIap.vars.wait_wnd:getChildByName("btn_close")
				
				if var_10_1 and SceneManager:getCurrentSceneName() == "title" then
					local var_10_2 = var_10_1:getContentSize()
					
					var_10_1:setContentSize(var_10_2.width, var_10_2.height * 2)
				end
				
				var_10_0:addChild(StoveIap.vars.wait_wnd)
				StoveIap.vars.wait_wnd:bringToFront()
				
				StoveIap.vars.start_wait_time = os.time()
			end
		else
			local var_10_3 = os.time() - StoveIap.vars.start_wait_time
			
			if_set_visible(StoveIap.vars.wait_wnd, "img_1", var_10_3 % 4 < 2)
			if_set_visible(StoveIap.vars.wait_wnd, "img_2", var_10_3 % 4 >= 2)
		end
	elseif get_cocos_refid(StoveIap.vars.wait_wnd) then
		print("Hide Stove Wait Screen")
		StoveIap.vars.wait_wnd:removeFromParent()
		
		StoveIap.vars.wait_wnd = nil
	end
end

function StoveIap.showErrorMsgBox(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.errorCode or arg_11_2.return_code or arg_11_2.code or ""
	local var_11_1 = arg_11_2.errorMessage or arg_11_2.return_message or arg_11_2.message or arg_11_2.exception or arg_11_2.msg or ""
	
	Log.e("StoveIap showErrorMsgBox " .. (arg_11_1 or "") .. ", " .. var_11_0 .. ", " .. var_11_1)
	Dialog:msgBox(var_11_1, {
		title = "STOVE IAP ERROR",
		dont_proc_tutorial = true,
		txt_code = "state: " .. (arg_11_1 or "") .. ", code: " .. var_11_0,
		handler = arg_11_3
	})
end

function StoveIap.flush(arg_12_0)
	if not Stove.enable then
		return 
	end
	
	if not StoveIap.vars.initialized then
		return 
	end
	
	if not StoveIap.vars.products then
		return 
	end
	
	if table.count(StoveIap.vars.products) == 0 then
		return 
	end
	
	print("StoveIap.flush")
	call_stove_platform(StoveAPI.flushIAP, "")
end

function StoveIap.getProductInfo(arg_13_0, arg_13_1)
	if not Stove.enable then
		return 
	end
	
	if not StoveIap.vars.initialized then
		return 
	end
	
	if not StoveIap.vars.products then
		return 
	end
	
	print("getProductInfo : ", arg_13_1)
	
	return StoveIap.vars.products[arg_13_1]
end

function StoveIap.getProductPriceString(arg_14_0, arg_14_1)
	local var_14_0 = StoveIap:getProductInfo(arg_14_1)
	
	if var_14_0 and var_14_0.price then
		print("getProductPriceString : ", arg_14_1, var_14_0.price)
		
		return var_14_0.price
	else
		return "N/A"
	end
end

function StoveIap.checkInitializeCompleteAndBalloonMessage(arg_15_0)
	if not Stove.enable then
		return true
	end
	
	if StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_STANDBY) or StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_PROBLEM) then
		return true
	else
		balloon_message_with_sound("waiting_for_stove_api_retry", {
			code = StoveIap.FSM:getCurrentStateString()
		})
	end
end

function StoveIap.waitInitializeComplete(arg_16_0, arg_16_1)
	if not Stove.enable then
		arg_16_1()
		
		return 
	end
	
	if StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_STANDBY) or StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_PROBLEM) then
		arg_16_1()
	elseif StoveIap.vars then
		StoveIap.vars.initializeCallback = arg_16_1
	else
		arg_16_1()
	end
end

function StoveIap.startBilling(arg_17_0, arg_17_1)
	if not Stove.enable then
		return 
	end
	
	if StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_PROBLEM) then
		if StoveIap.vars.problem_code == 40010 then
			Stove:openAppleStoreTireErrorFAQ()
		end
		
		Log.e("startBilling : " .. (StoveIap.vars.problem_message or ""))
		balloon_message(StoveIap.vars.problem_message or "")
		
		return 
	end
	
	if not StoveIap.vars.initialized then
		Log.e("Stove startBilling error: not initialized")
		balloon_message("Stove startBilling error: not initialized")
		
		return 
	end
	
	if not StoveIap.vars.products then
		Log.e("Stove startBilling error: products is nil")
		balloon_message("Stove startBilling error: products is nil")
		
		return 
	end
	
	if table.count(StoveIap.vars.products) == 0 then
		Log.e("Stove startBilling error: zero products")
		balloon_message("Stove startBilling error: zero products")
		
		return 
	end
	
	if not Stove:getNickNameNo() then
		Log.e("Stove startBilling error: not found login information")
		balloon_message("Stove startBilling error: not found login information")
		
		return 
	end
	
	if not StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_STANDBY) then
		balloon_message_with_sound("waiting_for_stove_api_retry", {
			code = Login.FSM:getCurrentStateString()
		})
		
		return 
	end
	
	print("Stove startBilling item_id : ", arg_17_1.item_id)
	
	local var_17_0 = StoveIap.vars.products[arg_17_1.item_id] or {}
	
	print("Stove startBilling product state : ", var_17_0.state)
	table.print(var_17_0)
	
	if var_17_0.state == 0 then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM, arg_17_1)
		
		return 
	elseif var_17_0.state == 1 then
		StoveIap:flush()
		StoveIap:showErrorMsgBox("startBilling", {
			return_code = -1004,
			return_message = "This product has already been paid. Please wait until the payment is made. [" .. arg_17_1.item_id .. "]"
		}, function()
			StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_FETCH_PRODUCT)
		end)
	elseif var_17_0.state == 2 then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_FETCH_PRODUCT)
		balloon_message_with_sound("This is the product payment process. [" .. arg_17_1.item_id .. "]")
	else
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_FETCH_PRODUCT)
		balloon_message_with_sound("This status is not available for purchase. [" .. arg_17_1.item_id .. "]. product.state : " .. tostring(var_17_0.state or "nil"))
	end
end

StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_INITIALIZE] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_INITIALIZE].onEnter = function(arg_19_0, arg_19_1)
	StoveIap.vars = {}
	arg_19_0.params = arg_19_1
	
	function onStoveInitializeIap(arg_20_0)
		arg_19_0:onReceive(arg_20_0)
	end
	
	arg_19_0.test_delay = tonumber(getenv("allow.test_iap_init_delay") or 0)
	
	print("STOVE_IAP_INITIALIZE test delay: ", getenv("allow.test_iap_init_delay"), arg_19_0.test_delay)
	
	if arg_19_0.test_delay and arg_19_0.test_delay > 0.01 then
		arg_19_0.enter_tm = os.time()
	else
		call_stove_platform(StoveAPI.initializeIap, "{\"character_no\":\"" .. tostring(arg_19_1.character_no) .. "\"}")
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_INITIALIZE].onUpdate = function(arg_21_0)
	if arg_21_0.test_delay and arg_21_0.test_delay > 0.01 and arg_21_0.enter_tm + arg_21_0.test_delay < os.time() then
		arg_21_0.test_delay = nil
		
		call_stove_platform(StoveAPI.initializeIap, "{\"character_no\":\"" .. tostring(arg_21_0.params.character_no) .. "\"}")
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_INITIALIZE].onReceive = function(arg_22_0, arg_22_1)
	print("StoveIap.FSM.STOVE_IAP_INITIALIZE.onReceive ")
	
	local var_22_0 = json.decode(arg_22_1)
	
	table.print(var_22_0)
	
	if var_22_0.domain == "com.stove.success" then
		StoveIap.vars.initialized = true
		
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_FETCH_PRODUCT)
	else
		error_msg = "Initialize_Iap Error: " .. (var_22_0.errorMessage or "") .. " errorCode: " .. (var_22_0.errorCode or "")
		
		if var_22_0.responseCode then
			if var_22_0.errorCode == 40003 and var_22_0.responseCode == "3" then
				error_msg = T("stove_error_need_play_store_login")
			else
				error_msg = error_msg .. " responseCode: " .. (var_22_0.responseCode or "")
				
				if var_22_0.userInfo and var_22_0.userInfo.debugMessage then
					error_msg = error_msg .. " message: " .. (var_22_0.userInfo.debugMessage or "")
				end
			end
		end
		
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_PROBLEM, {
			problem_message = error_msg,
			problem_code = var_22_0.errorCode
		})
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_FETCH_PRODUCT] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_FETCH_PRODUCT].onEnter = function(arg_23_0, arg_23_1)
	arg_23_0.params = arg_23_1 or {}
	StoveIap.vars.products = {}
	
	function onStoveFetchProduct(arg_24_0)
		arg_23_0:onReceive(arg_24_0)
	end
	
	call_stove_platform(StoveAPI.fetchProduct, "")
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_FETCH_PRODUCT].onReceive = function(arg_25_0, arg_25_1)
	print("StoveIap.FSM.STOVE_IAP_FETCH_PRODUCT.onReceive ")
	
	local var_25_0 = json.decode(arg_25_1) or {}
	
	if var_25_0 and var_25_0.return_code == -2 then
		error_msg = "STOVE_IAP_FETCH_PRODUCT Error: iap is null"
		
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_PROBLEM, {
			problem_message = error_msg,
			problem_code = var_25_0.return_code
		})
		
		return 
	end
	
	if var_25_0 and var_25_0.domain == "com.stove.success" then
		if var_25_0.products then
			for iter_25_0, iter_25_1 in pairs(var_25_0.products) do
				StoveIap.vars.products[iter_25_1.stoveProductId] = iter_25_1
			end
		end
		
		if var_25_0.needFlush then
			StoveIap:flush()
		end
		
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
	else
		error_msg = "STOVE_IAP_FETCH_PRODUCT Error: " .. (var_25_0.errorMessage or "") .. " code: " .. (var_25_0.errorCode or "")
		
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_PROBLEM, {
			problem_message = error_msg,
			problem_code = var_25_0.errorCode
		})
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_STANDBY] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_STANDBY].onEnter = function(arg_26_0, arg_26_1)
	if StoveIap.vars and StoveIap.vars.initializeCallback then
		StoveIap.vars.initializeCallback()
		
		StoveIap.vars.initializeCallback = nil
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_PROBLEM] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_PROBLEM].onEnter = function(arg_27_0, arg_27_1)
	StoveIap.vars.problem_message = arg_27_1.problem_message
	StoveIap.vars.problem_code = arg_27_1.problem_code
	
	print(arg_27_1.problem_message, arg_27_1.problem_code)
	
	if StoveIap.vars and StoveIap.vars.initializeCallback then
		StoveIap.vars.initializeCallback()
		
		StoveIap.vars.initializeCallback = nil
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM].onEnter = function(arg_28_0, arg_28_1)
	table.print(arg_28_1)
	
	arg_28_0.params = arg_28_1
	MsgHandler.stove_check_game_item_billing = MsgHandler.stove_check_game_item_billing or function(arg_29_0)
		arg_28_0:onReceive(arg_29_0)
	end
	ErrHandler.stove_check_game_item_billing = ErrHandler.stove_check_game_item_billing or function(arg_30_0, arg_30_1, arg_30_2)
		arg_28_0:onReceiveError(arg_30_0, arg_30_1, arg_30_2)
	end
	
	query("stove_check_game_item_billing", {
		item = arg_28_1.item_id,
		shop = arg_28_1.shop,
		npc = arg_28_1.npc,
		caller = arg_28_1.caller,
		buy_desc = arg_28_1.buy_desc
	})
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM].onReceive = function(arg_31_0, arg_31_1)
	print("StoveIap.FSM.STOVE_IAP_SERVER_CHECK_ITEM.onReceive ")
	table.print(arg_31_1)
	
	if arg_31_1.res == "ok" then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_START_PURCHASE, arg_31_0.params)
	else
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM, {
			errorCode = -1,
			errorMessage = string.format("err: %s\nres: %s\ncheck: %s", arg_31_1.err, arg_31_1.res, arg_31_1.is_test)
		})
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM].onReceiveError = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = T(tostring(arg_32_2))
	
	if var_32_0 == "nil" then
		var_32_0 = "unknown_error"
	end
	
	print("StoveIap.FSM.STOVE_IAP_SERVER_CHECK_ITEM.onReceiveError: ", var_32_0)
	table.print(arg_32_3)
	StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
	
	if arg_32_3.err == "content_disable" then
		balloon_message(T("content_disable"))
	else
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_SERVER_CHECK_ITEM, {
			errorCode = -2,
			errorMessage = var_32_0
		})
	end
end
StoveIap.TokenErrorTest = false
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_START_PURCHASE] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_START_PURCHASE].onEnter = function(arg_33_0, arg_33_1)
	arg_33_0.params = arg_33_1
	
	function onStoveStartPurchase(arg_34_0)
		arg_33_0:onReceive(arg_34_0)
	end
	
	print("startPurchase params : ")
	table.print(arg_33_1)
	
	local var_33_0 = {
		item_id = arg_33_1.item_id,
		service_order_id = json.encode(arg_33_1)
	}
	
	if StoveIap.TokenErrorTest then
		arg_33_0:onReceive("{ \"domain\":\"SC_TEST_CHEAT_USED\", \"errorCode\":40103, \"errorMessage\":\"SC_TEST_CHEAT_USED\" }")
		
		StoveIap.TokenErrorTest = false
	else
		call_stove_platform(StoveAPI.startPurchaseWithServiceOrderId, json.encode(var_33_0))
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_START_PURCHASE].onReceive = function(arg_35_0, arg_35_1)
	print("StoveIap.FSM.STOVE_IAP_START_PURCHASE.onReceive ")
	
	local var_35_0 = json.decode(arg_35_1)
	
	table.print(var_35_0)
	
	if var_35_0.domain == "com.stove.success" then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_WAIT_PAYMENT, arg_35_0.params)
		
		return 
	elseif var_35_0.errorCode == 40006 then
		print("STOVE_IAP_START_PURCHASE errorCode == 40006")
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_START_PURCHASE, {
			errorCode = -2,
			errorMessage = err_str
		}, function()
			StoveIap:flush()
		end)
		
		return 
	elseif var_35_0.errorCode == 40103 then
		arg_35_0.params.next_state = StoveIapState.STOVE_IAP_START_PURCHASE
		
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_REFRESH_TOKEN, arg_35_0.params)
		
		return 
	else
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_START_PURCHASE, var_35_0)
		
		return 
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_REFRESH_TOKEN] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_REFRESH_TOKEN].onEnter = function(arg_37_0, arg_37_1)
	arg_37_0.params = arg_37_1 or {}
	
	function onStoveRefreshToken(arg_38_0)
		arg_37_0:onReceive(arg_38_0)
	end
	
	call_stove_platform(StoveAPI.refreshToken, "")
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_REFRESH_TOKEN].onReceive = function(arg_39_0, arg_39_1)
	print("StoveIap.FSM.STOVE_IAP_REFRESH_TOKEN.onReceive ")
	
	local var_39_0 = json.decode(arg_39_1)
	
	table.print(var_39_0)
	
	if var_39_0.domain == "com.stove.success" then
		Stove:setTokenRefreshedTime(os.time())
		
		if arg_39_0.params.next_state then
			StoveIap.FSM:changeState(arg_39_0.params.next_state, arg_39_0.params)
		else
			StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		end
	else
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_WAIT_PAYMENT, var_39_0)
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_WAIT_PAYMENT] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_WAIT_PAYMENT].onEnter = function(arg_40_0, arg_40_1)
	arg_40_0.params = arg_40_1
	
	function onStoveWaitPayment(arg_41_0)
		arg_40_0:onReceive(arg_41_0)
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_WAIT_PAYMENT].onReceive = function(arg_42_0, arg_42_1)
	print("StoveIap.FSM.STOVE_IAP_WAIT_PAYMENT.onReceive ")
	
	local var_42_0 = json.decode(arg_42_1) or {}
	
	table.print(var_42_0)
	
	if var_42_0.domain == "com.stove.success" then
		local var_42_1 = var_42_0.purchaseDetail and var_42_0.purchaseDetail.transactionId
		
		if var_42_1 and var_42_1 ~= "" then
			local var_42_2 = var_42_0.product and var_42_0.product.priceCurrencyCode or ""
			local var_42_3 = (var_42_0.product and var_42_0.product.priceAmountMicros or 0) * 1e-06
			local var_42_4 = var_42_0.product and var_42_0.product.productIdentifier or ""
			local var_42_5 = var_42_0.purchaseDetail and var_42_0.purchaseDetail.marketOrderId or ""
			
			if PRODUCTION_MODE then
				Singular:purchase(var_42_2, var_42_3, var_42_4, var_42_5)
				
				if log_analytics_purchase then
					local var_42_6 = STOVE_IAP
					
					if PLATFORM == "iphoneos" then
						var_42_6 = "apple"
					end
					
					local var_42_7 = {
						success = true,
						currency_code = var_42_2,
						price = var_42_3,
						item_id = var_42_4,
						order_id = var_42_5,
						market_store = var_42_6
					}
					
					log_analytics_purchase(json.encode(var_42_7))
				end
			end
			
			StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE, {
				tid = var_42_1,
				caller = arg_42_0.params and arg_42_0.params.caller
			})
		else
			var_42_0.errorMessage = (var_42_0.errorMessage or "") .. " transaction ID is nil"
			
			StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
			StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_WAIT_PAYMENT, var_42_0)
		end
	elseif var_42_0.domain == "com.stove.cancel" then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
	elseif var_42_0.domain == "com.stove.server" then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_WAIT_PAYMENT, var_42_0)
	elseif var_42_0.errorCode == 40001 then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_WAIT_PAYMENT, var_42_0)
	elseif var_42_0.errorCode == 40002 then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		
		var_42_0.errorMessage = (var_42_0.errorMessage or "") .. " \nresponseCode: " .. (var_42_0.responseCode or "")
		
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_WAIT_PAYMENT, var_42_0)
	elseif var_42_0.errorCode == 30011 then
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
	else
		StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
		StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_WAIT_PAYMENT, var_42_0)
	end
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE] = {}
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE].onEnter = function(arg_43_0, arg_43_1)
	table.print(arg_43_1)
	
	arg_43_0.params = arg_43_1
	MsgHandler.stove_iap_purchase_acquire = MsgHandler.stove_iap_purchase_acquire or function(arg_44_0)
		arg_43_0:onReceive(arg_44_0)
	end
	ErrHandler.stove_iap_purchase_acquire = ErrHandler.stove_iap_purchase_acquire or function(arg_45_0, arg_45_1, arg_45_2)
		arg_43_0:onReceiveError(arg_45_0, arg_45_1, arg_45_2)
	end
	
	query("stove_iap_purchase_acquire", {
		tid = arg_43_1.tid
	})
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE].onReceive = function(arg_46_0, arg_46_1)
	print("StoveIap.FSM.STOVE_IAP_SERVER_PURCHASE_ACQUIRE.onReceive ")
	table.print(arg_46_1)
	
	arg_46_1.caller = arg_46_0.params and arg_46_0.params.caller
	
	MsgHandler.buy(arg_46_1)
	StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
end
StoveIap.FSM.STATES[StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE].onReceiveError = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	print("StoveIap.FSM.STOVE_IAP_SERVER_PURCHASE_ACQUIRE.onReceiveError ")
	
	local var_47_0 = T(tostring(arg_47_2))
	
	if var_47_0 == "nil" then
		var_47_0 = "unknown_error"
	end
	
	print("StoveIap.FSM.STOVE_IAP_SERVER_PURCHASE_ACQUIRE.onReceiveError : ", var_47_0)
	table.print(arg_47_3)
	StoveIap.FSM:changeState(StoveIapState.STOVE_IAP_STANDBY)
	StoveIap:showErrorMsgBox(StoveIapState.STOVE_IAP_SERVER_PURCHASE_ACQUIRE, {
		return_code = -1,
		return_message = var_47_0
	})
end
