ZlongIap = ZlongIap or {}
ZlongIap.FSM = ZlongIap.FSM or {}
ZlongIap.FSM.STATES = ZlongIap.FSM.STATES or {}
ZlongIap.vars = ZlongIap.vars or {}
ZlongIapState = {
	ZLONG_IAP_PROBLEM = "ZLONG_IAP_PROBLEM",
	ZLONG_IAP_SERVER_CHECK_ITEM = "ZLONG_IAP_SERVER_CHECK_ITEM",
	ZLONG_IAP_START_PURCHASE = "ZLONG_IAP_START_PURCHASE",
	ZLONG_IAP_STANDBY = "ZLONG_IAP_STANDBY",
	ZLONG_IAP_SERVER_PURCHASE_ACQUIRE = "ZLONG_IAP_SERVER_PURCHASE_ACQUIRE",
	ZLONG_IAP_INITIALIZE = "ZLONG_IAP_INITIALIZE",
	ZLONG_IAP_GET_PRODUCT_LIST = "ZLONG_IAP_GET_PRODUCT_LIST"
}
ZlongIap.AcquireWorker = {
	interval = 3,
	timeout = 180,
	job_list = {}
}

function ZlongIap.AcquireWorker.getJobListCount(arg_1_0)
	return table.count(arg_1_0.job_list)
end

function ZlongIap.AcquireWorker.addJob(arg_2_0, arg_2_1, arg_2_2)
	print("ZlongIap AcquireWorker addJob : ", arg_2_1, arg_2_2)
	
	arg_2_0.job_list[arg_2_1] = {
		caller = arg_2_2,
		expire_time = os.time() + arg_2_0.timeout,
		next_check_time = os.time() + arg_2_0.interval
	}
end

function ZlongIap.AcquireWorker.removeJob(arg_3_0, arg_3_1)
	print("ZlongIap AcquireWorker removeJob : ", arg_3_1)
	
	if arg_3_0.job_list[arg_3_1] then
		arg_3_0.job_list[arg_3_1] = nil
	end
end

function ZlongIap.AcquireWorker.update(arg_4_0)
	local var_4_0 = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.job_list) do
		if iter_4_1.expire_time < os.time() then
			table.insert(var_4_0, iter_4_0)
			TopBarNew:showZlongShopAcquireBalloon()
		elseif iter_4_1.next_check_time and iter_4_1.next_check_time < os.time() then
			iter_4_1.next_check_time = nil
			
			function MsgHandler.zlong_iap_purchase_acquire(arg_5_0)
				arg_4_0:onReceive(arg_5_0)
			end
			
			function ErrHandler.zlong_iap_purchase_acquire(arg_6_0, arg_6_1, arg_6_2)
				arg_4_0:onReceiveError(arg_6_0, arg_6_1, arg_6_2)
			end
			
			print("ZlongIap AcquireWorker zlong_iap_purchase_acquire : ", iter_4_0)
			query("zlong_iap_purchase_acquire", {
				acquire_id = iter_4_0
			})
		end
	end
	
	for iter_4_2, iter_4_3 in ipairs(var_4_0) do
		arg_4_0:removeJob(iter_4_3)
	end
end

function ZlongIap.AcquireWorker.onReceive(arg_7_0, arg_7_1)
	print("ZlongIap AcquireWorker onReceive : " .. (arg_7_1.res or ""))
	table.print(arg_7_1)
	
	if arg_7_1.res == "ok" then
		local var_7_0 = arg_7_0.job_list[arg_7_1.acquire_id]
		
		if var_7_0 then
			arg_7_1.caller = arg_7_1.caller or var_7_0.caller
			
			MsgHandler.buy(arg_7_1)
			arg_7_0:removeJob(arg_7_1.acquire_id)
			
			local var_7_1 = ZlongIap:getProductInfo(arg_7_1.item)
			
			if var_7_1 then
				local var_7_2 = tonumber(var_7_1.goods_price or 0)
				
				Zlong:gameEventLog("AD_purchaseV2", json.encode({
					price = var_7_2,
					itemId = arg_7_1.item
				}))
			end
		else
			arg_7_1.caller = arg_7_1.caller or var_7_0.caller
			
			MsgHandler.buy(arg_7_1)
			print("ZlongIap AcquireWorker onReceive : not found job : " .. (arg_7_1.acquire_id or ""))
		end
	elseif arg_7_1.res == "iap_data_not_found" then
		if arg_7_1.acquire_id then
			local var_7_3 = arg_7_0.job_list[arg_7_1.acquire_id]
			
			if var_7_3 then
				if var_7_3.expire_time < os.time() then
					arg_7_0:removeJob(arg_7_1.acquire_id)
					TopBarNew:showZlongShopAcquireBalloon()
				else
					var_7_3.next_check_time = os.time() + arg_7_0.interval
				end
			else
				arg_7_0:removeJob(arg_7_1.acquire_id)
			end
		else
			balloon_message("ZlongIap Acquire acquire_id is nil ")
			Log.e("ZlongIap AcquireWorker onReceive : acquire_id is nil")
		end
	elseif arg_7_1.res == "exception" then
		balloon_message("ZlongIap Acquire exception : " .. (arg_7_1.exception or ""))
		Log.e("ZlongIap AcquireWorker onReceive : exception " .. (arg_7_1.exception or ""))
		
		if arg_7_1.acquire_id then
			arg_7_0:removeJob(arg_7_1.acquire_id)
		end
	else
		Log.e("ZlongIap AcquireWorker onReceive : Unknown Error " .. (arg_7_1.res or ""))
		balloon_message("ZlongIap Acquire Unknown Error : " .. (arg_7_1.res or ""))
		
		if arg_7_1.acquire_id then
			arg_7_0:removeJob(arg_7_1.acquire_id)
		end
	end
end

function ZlongIap.AcquireWorker.onReceiveError(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	print("ZlongIap AcquireWorker onReceiveError : " .. (arg_8_2 or ""))
	balloon_message("ZlongIap Acquire Error : " .. (arg_8_2 or ""))
	
	if arg_8_3.acquire_id then
		arg_8_0:removeJob(arg_8_3.acquire_id)
	end
end

function ZlongIap.FSM.isCurrentState(arg_9_0, arg_9_1)
	return arg_9_1 == arg_9_0.current_state
end

function ZlongIap.FSM.getCurrentStateString(arg_10_0)
	return arg_10_0.current_state or ""
end

function ZlongIap.FSM.getCmdQueueSize(arg_11_0)
	if arg_11_0.reserved_state_queue then
		return #arg_11_0.reserved_state_queue
	else
		return 0
	end
end

function ZlongIap.FSM.changeState(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0._is_recursive or not arg_12_0.STATES[arg_12_1] then
		arg_12_0.reserved_state_queue = arg_12_0.reserved_state_queue or {}
		
		print("Login FSM ChangeState Add Queue [" .. tostring(arg_12_0:getCurrentStateString()) .. "]  to  [" .. tostring(arg_12_1) .. "]")
		table.insert(arg_12_0.reserved_state_queue, {
			state = arg_12_1,
			params = arg_12_2
		})
	else
		arg_12_0:_changeStateImmediate(arg_12_1, arg_12_2)
	end
end

function ZlongIap.FSM._changeStateImmediate(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:_onExit(arg_13_0.current_state)
	print("Login FSM ChangeStateImmediate [" .. tostring(arg_13_0:getCurrentStateString()) .. "]  to  [" .. tostring(arg_13_1) .. "]")
	
	arg_13_0.current_state = arg_13_1
	
	arg_13_0:_onEnter(arg_13_0.current_state, arg_13_2)
end

function ZlongIap.FSM.update(arg_14_0)
	if arg_14_0.current_state then
		arg_14_0:_onUpdate(arg_14_0.current_state)
	end
	
	if arg_14_0.reserved_state_queue and #arg_14_0.reserved_state_queue > 0 and arg_14_0.STATES[arg_14_0.reserved_state_queue[1].state] then
		arg_14_0:_changeStateImmediate(arg_14_0.reserved_state_queue[1].state, arg_14_0.reserved_state_queue[1].params)
		table.remove(arg_14_0.reserved_state_queue, 1)
	end
	
	if arg_14_0.updateWaitScreen then
		arg_14_0:updateWaitScreen()
	end
end

function ZlongIap.FSM._onEnter(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0.STATES[arg_15_1] and arg_15_0.STATES[arg_15_1].onEnter then
		arg_15_0._is_recursive = true
		
		print("ZlongIap.FSM." .. arg_15_0:getCurrentStateString() .. ".onEnter")
		arg_15_0.STATES[arg_15_1]:onEnter(arg_15_2)
		
		arg_15_0._is_recursive = false
	end
end

function ZlongIap.FSM._onUpdate(arg_16_0, arg_16_1)
	if arg_16_0.STATES[arg_16_1] and arg_16_0.STATES[arg_16_1].onUpdate then
		arg_16_0._is_recursive = true
		
		arg_16_0.STATES[arg_16_1]:onUpdate()
		
		arg_16_0._is_recursive = false
	end
end

function ZlongIap.FSM._onExit(arg_17_0, arg_17_1)
	if arg_17_0.STATES[arg_17_1] and arg_17_0.STATES[arg_17_1].onExit then
		arg_17_0._is_recursive = true
		
		print("ZlongIap.FSM." .. arg_17_0:getCurrentStateString() .. ".onExit")
		arg_17_0.STATES[arg_17_1]:onExit()
		
		arg_17_0._is_recursive = false
	end
end

function ZlongIap.FSM.updateWaitScreen(arg_18_0)
	if not Zlong.enable then
		return 
	end
	
	if not arg_18_0.current_state then
		return 
	end
	
	if arg_18_0.current_state == ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM or arg_18_0.current_state == ZlongIapState.ZLONG_IAP_START_PURCHASE or arg_18_0.current_state == ZlongIapState.ZLONG_IAP_SERVER_PURCHASE_ACQUIRE then
		if not get_cocos_refid(ZlongIap.vars.wait_wnd) then
			local var_18_0 = SceneManager:getRunningPopupScene()
			
			if var_18_0 then
				print("Show Zlong Wait Screen")
				
				ZlongIap.vars.wait_wnd = load_dlg("net_waiting", true, "wnd")
				
				ZlongIap.vars.wait_wnd:setName("zlong_wait")
				ZlongIap.vars.wait_wnd:setAnchorPoint(0, 0)
				ZlongIap.vars.wait_wnd:setPosition(0, 0)
				ZlongIap.vars.wait_wnd:setLocalZOrder(ZlongIap.vars.wait_wnd:getLocalZOrder() + 1)
				
				local var_18_1 = ZlongIap.vars.wait_wnd:getChildByName("btn_close")
				
				if var_18_1 and SceneManager:getCurrentSceneName() == "title" then
					local var_18_2 = var_18_1:getContentSize()
					
					var_18_1:setContentSize(var_18_2.width, var_18_2.height * 2)
				end
				
				var_18_0:addChild(ZlongIap.vars.wait_wnd)
				ZlongIap.vars.wait_wnd:bringToFront()
				
				ZlongIap.vars.start_wait_time = os.time()
			end
		else
			local var_18_3 = os.time() - ZlongIap.vars.start_wait_time
			
			if_set_visible(ZlongIap.vars.wait_wnd, "img_1", var_18_3 % 4 < 2)
			if_set_visible(ZlongIap.vars.wait_wnd, "img_2", var_18_3 % 4 >= 2)
		end
	elseif get_cocos_refid(ZlongIap.vars.wait_wnd) then
		print("Hide Zlong Wait Screen")
		ZlongIap.vars.wait_wnd:removeFromParent()
		
		ZlongIap.vars.wait_wnd = nil
	end
end

function ZlongIap.showErrorMsgBox(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2.state_code or arg_19_2.return_code or arg_19_2.code or ""
	local var_19_1 = arg_19_2.errorMessage or arg_19_2.return_message or arg_19_2.message or arg_19_2.exception or arg_19_2.msg or ""
	
	Log.e("ZlongIap showErrorMsgBox " .. (arg_19_1 or "") .. ", " .. var_19_0 .. ", " .. var_19_1)
	balloon_message(var_19_1)
end

function ZlongIap.getProductInfo(arg_20_0, arg_20_1)
	if not Zlong.enable then
		return 
	end
	
	if not ZlongIap.vars.products then
		return 
	end
	
	print("getProductInfo : ", arg_20_1)
	
	return ZlongIap.vars.products[arg_20_1]
end

function ZlongIap.getProductPriceString(arg_21_0, arg_21_1)
	local var_21_0 = ZlongIap:getProductInfo(arg_21_1)
	
	if var_21_0 and var_21_0.goods_price then
		print("getProductPriceString : ", arg_21_1, var_21_0.goods_price)
		
		return tostring(var_21_0.goods_price) .. "元"
	else
		return "N/A"
	end
end

function ZlongIap.checkInitializeCompleteAndBalloonMessage(arg_22_0)
	if not Zlong.enable then
		return true
	end
	
	if Login.USE_TEST_GEN then
		return true
	end
	
	if ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_STANDBY) or ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_PROBLEM) then
		return true
	else
		balloon_message_with_sound("waiting_for_zlong_api_retry", {
			code = ZlongIap.FSM:getCurrentStateString()
		})
	end
end

function ZlongIap.waitInitializeComplete(arg_23_0, arg_23_1)
	if not Zlong.enable then
		arg_23_1()
		
		return 
	end
	
	if ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_STANDBY) or ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_PROBLEM) then
		arg_23_1()
	elseif ZlongIap.vars then
		ZlongIap.vars.initializeCallback = arg_23_1
	else
		arg_23_1()
	end
end

function ZlongIap.startBilling(arg_24_0, arg_24_1)
	if not Zlong.enable then
		return 
	end
	
	if ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_PROBLEM) then
		Log.e("startBilling : " .. (ZlongIap.vars.problem_message or ""))
		balloon_message(ZlongIap.vars.problem_message or "")
		
		return 
	end
	
	if not ZlongIap.vars.products then
		Log.e("Zlong startBilling error: products is nil")
		balloon_message("Zlong startBilling error: products is nil")
		
		return 
	end
	
	if table.count(ZlongIap.vars.products) == 0 then
		Log.e("Zlong startBilling error: zero products")
		balloon_message("Zlong startBilling error: zero products")
		
		return 
	end
	
	if not ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_STANDBY) then
		balloon_message_with_sound("waiting_for_zlong_api_retry", {
			code = Login.FSM:getCurrentStateString()
		})
		
		return 
	end
	
	print("Zlong startBilling item_id : ", arg_24_1.item_id)
	
	local var_24_0 = ZlongIap.vars.products[arg_24_1.item_id] or {}
	
	table.print(var_24_0)
	ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM, arg_24_1)
end

ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_INITIALIZE] = {}
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_INITIALIZE].onEnter = function(arg_25_0, arg_25_1)
	ZlongIap.vars = {}
	
	ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_GET_PRODUCT_LIST)
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_GET_PRODUCT_LIST] = {}
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_GET_PRODUCT_LIST].onEnter = function(arg_26_0, arg_26_1)
	function onZlongGetProductList(arg_27_0)
		arg_26_0:onReceive(arg_27_0)
	end
	
	ZlongIap.vars.products = {}
	
	call_zlong_async_api("ZlongGetProductList", "")
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_GET_PRODUCT_LIST].onReceive = function(arg_28_0, arg_28_1)
	print("ZlongIap.FSM.ZLONG_IAP_GET_PRODUCT_LIST.onReceive ")
	
	local var_28_0 = json.decode(arg_28_1) or {}
	
	table.print(var_28_0)
	
	if var_28_0.state_code == ZLONG_CODE.GOODS_SUCCESS then
		if var_28_0.data then
			local var_28_1 = json.decode(var_28_0.data) or {}
			
			for iter_28_0, iter_28_1 in pairs(var_28_1) do
				ZlongIap.vars.products[iter_28_1.goods_id] = iter_28_1
			end
			
			print("Product Count: " .. table.count(ZlongIap.vars.products))
			table.print(ZlongIap.vars.products)
		end
		
		ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
	else
		error_msg = "ZLONG_IAP_GET_PRODUCT_LIST Error: " .. (var_28_0.message or "") .. " code: " .. (var_28_0.state_code or "")
		
		ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_PROBLEM, {
			problem_message = var_28_0.message,
			problem_code = var_28_0.state_code
		})
	end
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_STANDBY] = {}
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_STANDBY].onEnter = function(arg_29_0, arg_29_1)
	if ZlongIap.vars and ZlongIap.vars.initializeCallback then
		ZlongIap.vars.initializeCallback()
		
		ZlongIap.vars.initializeCallback = nil
	end
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_PROBLEM] = {}
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_PROBLEM].onEnter = function(arg_30_0, arg_30_1)
	ZlongIap.vars.problem_message = arg_30_1.problem_message
	ZlongIap.vars.problem_code = arg_30_1.problem_code
	
	print(arg_30_1.problem_message, arg_30_1.problem_code)
	
	if ZlongIap.vars and ZlongIap.vars.initializeCallback then
		ZlongIap.vars.initializeCallback()
		
		ZlongIap.vars.initializeCallback = nil
	end
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM] = {}
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM].onEnter = function(arg_31_0, arg_31_1)
	table.print(arg_31_1)
	
	arg_31_0.params = arg_31_1
	MsgHandler.zlong_check_game_item_billing = MsgHandler.zlong_check_game_item_billing or function(arg_32_0)
		arg_31_0:onReceive(arg_32_0)
	end
	ErrHandler.zlong_check_game_item_billing = ErrHandler.zlong_check_game_item_billing or function(arg_33_0, arg_33_1, arg_33_2)
		arg_31_0:onReceiveError(arg_33_0, arg_33_1, arg_33_2)
	end
	
	local var_31_0 = ZlongIap:getProductInfo(arg_31_1.item_id)
	
	if not var_31_0 or not var_31_0.goods_id then
		balloon_message("not found zlong product info : " .. tostring(arg_31_1.item_id))
		ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
		
		return 
	end
	
	query("zlong_check_game_item_billing", {
		item = arg_31_1.item_id,
		shop = arg_31_1.shop,
		npc = arg_31_1.npc,
		caller = arg_31_1.caller,
		buy_desc = arg_31_1.buy_desc
	})
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM].onReceive = function(arg_34_0, arg_34_1)
	print("ZlongIap.FSM.ZLONG_IAP_SERVER_CHECK_ITEM.onReceive ")
	table.print(arg_34_1)
	
	if arg_34_1.res == "ok" then
		arg_34_0.params.acquire_id = arg_34_1.acquire_id
		
		ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_START_PURCHASE, arg_34_0.params)
	else
		ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
		ZlongIap:showErrorMsgBox(ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM, {
			errorCode = -1,
			errorMessage = string.format("err: %s\nres: %s\ncheck: %s", arg_34_1.err, arg_34_1.res, arg_34_1.is_test)
		})
	end
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM].onReceiveError = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = T(tostring(arg_35_2))
	
	if var_35_0 == "nil" then
		var_35_0 = "unknown_error"
	end
	
	print("ZlongIap.FSM.ZLONG_IAP_SERVER_CHECK_ITEM.onReceiveError: ", var_35_0)
	table.print(arg_35_3)
	ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
	
	if arg_35_3.err == "content_disable" then
		balloon_message(T("content_disable"))
	else
		ZlongIap:showErrorMsgBox(ZlongIapState.ZLONG_IAP_SERVER_CHECK_ITEM, {
			errorCode = -2,
			errorMessage = var_35_0
		})
	end
end
ZlongIap.TestCasePurcahseError = false
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_START_PURCHASE] = {}
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_START_PURCHASE].onEnter = function(arg_36_0, arg_36_1)
	function onZlongPay(arg_37_0)
		arg_36_0:onReceive(arg_37_0)
	end
	
	arg_36_0.params = arg_36_1
	
	table.print(arg_36_1)
	
	local var_36_0 = ZlongIap:getProductInfo(arg_36_1.item_id)
	local var_36_1 = {
		goodsDescribe = "",
		goodsNumber = 1,
		goodsName = var_36_0.goods_name,
		goodsId = var_36_0.goods_id,
		goodsRegisterId = var_36_0.goods_register_id,
		goodsPrice = var_36_0.goods_price,
		customparams = tostring(arg_36_0.params.acquire_id)
	}
	
	if ZlongIap.TestCasePurcahseError then
		arg_36_0:onReceive("{ \"state_code\":101, \"message\":\"this is test error message\" }")
		
		ZlongIap.TestCasePurcahseError = false
		
		return 
	end
	
	arg_36_0.block_end_time = os.time() + 2
	
	call_zlong_async_api("ZlongPay", json.encode(var_36_1))
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_START_PURCHASE].sendMockupServerNoti = function(arg_38_0, arg_38_1)
	print("sendMockupServerNoti")
	
	if getenv("zlong.use_purchase_mockup") == "true" and not PRODUCTION_MODE then
		local var_38_0 = ZlongIap:getProductInfo(arg_38_1.item_id)
		local var_38_1 = {
			areaId = "1",
			expiresDate = "",
			areaName = "版署服",
			appDate = "20230209181348",
			purchaseDate = "",
			isSandbox = 0,
			goodsType = 0,
			goodsId = var_38_0.goods_id,
			channelId = var_38_0.channelId,
			goodsNumber = var_38_0.goods_number,
			userid = Zlong:getZlongId(),
			roleName = Account:getName(),
			goodsRegisterId = var_38_0.goods_register_id,
			amount = var_38_0.goods_price,
			orderId = "PD" .. tostring(os.time()) .. tostring(getRandom(systick())),
			roleId = tostring(Account:getUserId())
		}
		local var_38_2 = {
			use_mockup = "true",
			sign = "4d18a352d1845784",
			type = 1,
			customparams = arg_38_1.acquire_id,
			receipt = json.encode(var_38_1)
		}
		
		MsgHandler.zlong_iap_purchase_mockup = MsgHandler.zlong_iap_purchase_mockup or function(arg_39_0)
			print("onReceive zlong_iap_purchase_mockup")
			table.print(arg_39_0)
		end
		ErrHandler.zlong_iap_purchase_mockup = ErrHandler.zlong_iap_purchase_mockup or function(arg_40_0, arg_40_1, arg_40_2)
			print("onReceiveError zlong_iap_purchase_mockup")
			table.print(arg_40_2)
		end
		
		print("zlong.use_purchase_mockup : true")
		print("query zlong_iap_purchase_mockup")
		table.print(var_38_2)
		query("zlong_iap_purchase_mockup", var_38_2)
	end
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_START_PURCHASE].onUpdate = function(arg_41_0)
	if arg_41_0.block_end_time and os.time() > arg_41_0.block_end_time then
		arg_41_0.block_end_time = nil
		
		ZlongIap.AcquireWorker:addJob(arg_41_0.params.acquire_id, arg_41_0.params.caller)
		ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
	end
end
ZlongIap.FSM.STATES[ZlongIapState.ZLONG_IAP_START_PURCHASE].onReceive = function(arg_42_0, arg_42_1)
	print("ZlongIap.FSM.ZLONG_IAP_START_PURCHASE.onReceive ")
	
	local var_42_0 = json.decode(arg_42_1)
	
	table.print(var_42_0)
	
	if getenv("zlong.use_purchase_mockup") == "true" and not PRODUCTION_MODE then
		arg_42_0:sendMockupServerNoti(arg_42_0.params)
		
		var_42_0.state_code = ZLONG_CODE.PAY_SUCCESS
	end
	
	if var_42_0.state_code == ZLONG_CODE.PAY_SUCCESS then
		return 
	elseif var_42_0.state_code == ZLONG_CODE.PAY_CANCEL then
		arg_42_0.block_end_time = nil
		
		ZlongIap.AcquireWorker:removeJob(arg_42_0.params.acquire_id)
		
		if ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_START_PURCHASE) then
			ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
		end
		
		return 
	else
		arg_42_0.block_end_time = nil
		
		ZlongIap.AcquireWorker:removeJob(arg_42_0.params.acquire_id)
		
		if ZlongIap.FSM:isCurrentState(ZlongIapState.ZLONG_IAP_START_PURCHASE) then
			ZlongIap.FSM:changeState(ZlongIapState.ZLONG_IAP_STANDBY)
		end
		
		ZlongIap:showErrorMsgBox(ZlongIapState.ZLONG_IAP_START_PURCHASE, var_42_0)
		
		return 
	end
end
