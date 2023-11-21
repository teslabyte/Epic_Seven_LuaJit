function HANDLER.n_button_close(arg_1_0)
	SceneManager:popScene()
end

SceneCloser = {}

function SceneCloser.set(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or SceneManager:getRunningNativeScene()
	
	local var_2_0 = Dialog:open("n_button_close", arg_2_0)
	
	var_2_0:setAnchorPoint(1, 1)
	var_2_0:setPosition(DESIGN_WIDTH, DESIGN_HEIGHT)
	arg_2_1:addChild(var_2_0)
	
	arg_2_0.closer = var_2_0
end

function SceneCloser.unset(arg_3_0)
	if get_cocos_refid(arg_3_0.closer) then
		arg_3_0.closer:removeFromParent()
	end
end

SceneDisable = {}

function SceneDisable.set(arg_4_0)
	local var_4_0 = SceneManager:getDefaultLayer()
	
	if not get_cocos_refid(var_4_0) then
		return 
	end
	
	if get_cocos_refid(arg_4_0.disable) then
		return 
	end
	
	local var_4_1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 180))
	local var_4_2 = var_4_1:getEventDispatcher()
	local var_4_3 = cc.EventListenerTouchOneByOne:create()
	
	var_4_3:registerScriptHandler(function(arg_5_0, arg_5_1)
		arg_5_1:stopPropagation()
		
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	var_4_2:addEventListenerWithSceneGraphPriority(var_4_3, var_4_1)
	
	local var_4_4 = ccui.Text:create()
	
	var_4_4:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	var_4_4:setFontName("font/daum.ttf")
	var_4_4:setFontSize(24)
	var_4_4:setScale(2)
	var_4_4:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_4_4:setString(T("msg_rebuild_desc"))
	var_4_4:setTextColor(cc.c4b(255, 255, 255, 255))
	var_4_4:enableOutline(cc.c3b(0, 0, 0), 1)
	var_4_1:setLocalZOrder(99999999)
	var_4_1:addChild(var_4_4)
	
	arg_4_0.disable = var_4_1
	
	var_4_0:addChild(var_4_1)
end

function SceneDisable.unset(arg_6_0)
	if get_cocos_refid(arg_6_0.disable) then
		arg_6_0.disable:removeFromParent()
	end
end
