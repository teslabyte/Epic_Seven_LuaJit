WebView = {}

function WebView.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	if not get_cocos_refid(arg_1_5) or get_cocos_refid(arg_1_0.vars and arg_1_0.vars.webview) then
		return 
	end
	
	arg_1_0.vars = {}
	
	if PLATFORM == "win32" then
		local var_1_0 = cc.LayerColor:create(cc.c3b(255, 0, 0))
		
		var_1_0:setAnchorPoint(0.5, 0.5)
		var_1_0:setContentSize(arg_1_3, arg_1_4)
		var_1_0:setPosition(arg_1_1 - arg_1_3 / 2, arg_1_2 - arg_1_4 / 2)
		arg_1_5:addChild(var_1_0)
		balloon_message_with_sound("윈도우는 웹뷰를 지원하지 않아요!")
		
		arg_1_0.vars.webview = var_1_0
		
		return arg_1_0
	end
	
	arg_1_0.vars.webview = ccui.WebView:create()
	
	arg_1_0.vars.webview:setName("webview")
	arg_1_0.vars.webview:setScalesPageToFit(true)
	arg_1_0.vars.webview:setVisible(true)
	arg_1_0.vars.webview:setContentSize(arg_1_3, arg_1_4)
	arg_1_0.vars.webview:setPosition(arg_1_1, arg_1_2)
	
	arg_1_0.vars.initial_url = arg_1_6
	
	arg_1_5:addChild(arg_1_0.vars.webview)
	
	return arg_1_0
end

function WebView.setOnShouldStartLoading(arg_2_0, arg_2_1)
	if PLATFORM == "win32" or not arg_2_0.vars then
		return 
	end
	
	if type(arg_2_1) ~= "function" then
		return 
	end
	
	arg_2_0.vars._onShouldStartLoading = arg_2_1
	
	arg_2_0.vars.webview:setOnShouldStartLoading(function(arg_3_0, arg_3_1)
		arg_2_1(arg_3_0, arg_3_1)
	end)
end

function WebView.setOnDidFinishLoading(arg_4_0, arg_4_1)
	if PLATFORM == "win32" or not arg_4_0.vars then
		return 
	end
	
	if type(arg_4_1) ~= "function" then
		return 
	end
	
	arg_4_0.vars.setOnDidFinishLoading = arg_4_1
	
	arg_4_0.vars.webview:setOnDidFinishLoading(function(arg_5_0, arg_5_1)
		arg_4_1(arg_5_0, arg_5_1)
	end)
end

function WebView.setOnDidFailLoading(arg_6_0, arg_6_1)
	if PLATFORM == "win32" or not arg_6_0.vars then
		return 
	end
	
	if type(arg_6_1) ~= "function" then
		return 
	end
	
	arg_6_0.vars.setOnDidFailLoading = arg_6_1
	
	arg_6_0.vars.webview:setOnDidFailLoading(function(arg_7_0, arg_7_1)
		arg_6_1(arg_7_0, arg_7_1)
	end)
end

function WebView.reload(arg_8_0)
	if PLATFORM == "win32" or not arg_8_0.vars then
		return 
	end
	
	arg_8_0.vars.webview:refresh()
end

function WebView.forward(arg_9_0)
	if PLATFORM == "win32" or not arg_9_0.vars then
		return 
	end
	
	arg_9_0.vars.webview:goForward()
end

function WebView.back(arg_10_0)
	if PLATFORM == "win32" or not arg_10_0.vars then
		return 
	end
	
	arg_10_0.vars.webview:goBack()
end

function WebView.loadHTMLFile(arg_11_0, arg_11_1)
	if PLATFORM == "win32" or not arg_11_0.vars then
		return 
	end
	
	arg_11_0.vars.webview:loadFile(arg_11_1)
end

function WebView.loadUrl(arg_12_0, arg_12_1, arg_12_2)
	if PLATFORM == "win32" or not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = arg_12_2 and json.encode()
	
	arg_12_0.vars.webview:loadURL(arg_12_1, true, var_12_0)
end

function WebView.loadHTMLString(arg_13_0, arg_13_1)
	if PLATFORM == "win32" or not arg_13_0.vars then
		return 
	end
	
	arg_13_0.vars.webview:loadHTMLString(arg_13_1)
end

function WebView.evalJS(arg_14_0, arg_14_1)
	if PLATFORM == "win32" or not arg_14_0.vars then
		return 
	end
	
	arg_14_0.vars.webview:evaluateJS(arg_14_1)
end

function WebView.reset(arg_15_0)
	if PLATFORM == "win32" or not arg_15_0.vars then
		return 
	end
	
	arg_15_0.vars.webview:loadURL(arg_15_0.vars.initial_url)
end

function WebView.getWebView(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.webview) then
		return 
	end
	
	return arg_16_0.vars.webview
end

function WebView.close(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_17_0.vars.webview) then
		arg_17_0.vars.webview:removeFromParent()
	end
	
	arg_17_0.vars.webview = nil
	arg_17_0.vars = nil
end
