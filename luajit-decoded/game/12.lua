if not TransitionScreen then
	TransitionScreen = {}
end

function TransitionScreen.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.scene = arg_1_1
	arg_1_0.color = arg_1_2 or cc.c3b(0, 0, 0)
end

function TransitionScreen.isShow(arg_2_0)
	return get_cocos_refid(arg_2_0.control)
end

function TransitionScreen.show(arg_3_0, arg_3_1)
	if get_cocos_refid(arg_3_0.control) then
		return 
	end
	
	local function var_3_0()
		if arg_3_0.control.custom_handler and type(arg_3_0.control.custom_handler.on_show) == "function" then
			arg_3_0.control.custom_handler.on_show()
		end
		
		if arg_3_0.callback then
			arg_3_0.callback()
			
			arg_3_0.callback = nil
		end
	end
	
	if arg_3_1 and type(arg_3_1.on_show_before) == "function" then
		arg_3_0.control = cc.Layer:create()
		
		arg_3_0.control:setPositionX((ORIGIN_VIEW_WIDTH - VIEW_WIDTH) / 2)
		
		local var_3_1, var_3_2 = arg_3_1.on_show_before(arg_3_0.control)
		local var_3_3 = cc.Sequence:create(cc.DelayTime:create((var_3_2 or 0) / 1000), cc.CallFunc:create(var_3_0))
		
		arg_3_0.control.custom_handler = arg_3_1
		
		arg_3_0.control:runAction(var_3_3)
	else
		arg_3_0.control = cc.LayerColor:create(arg_3_0.color)
		
		arg_3_0.control:setGlobalZOrder(1)
		arg_3_0.control:setOpacity(0)
		arg_3_0.control:setVisible(true)
		
		local var_3_4 = cc.Sequence:create(cc.FadeIn:create(0.25), cc.DelayTime:create(0.1), cc.CallFunc:create(var_3_0))
		
		arg_3_0.control:runAction(var_3_4)
	end
	
	function arg_3_0.control.control_hide_action(arg_5_0)
		if get_cocos_refid(arg_3_0.control) then
			if arg_3_1 and type(arg_3_1.on_hide_before) == "function" then
				local var_5_0, var_5_1 = arg_3_1.on_hide_before(arg_3_0.control)
				local var_5_2 = cc.Sequence:create(cc.DelayTime:create((var_5_1 or 0) / 1000), cc.CallFunc:create(arg_5_0))
				
				arg_3_0.control:runAction(var_5_2)
			else
				local var_5_3 = cc.Sequence:create(cc.FadeOut:create(0.1), cc.CallFunc:create(arg_5_0))
				
				arg_3_0.control:runAction(var_5_3)
			end
		end
	end
	
	print("function TransitionScreen:show")
	arg_3_0.scene:addChild(arg_3_0.control)
end

function TransitionScreen.transition(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_2 then
		arg_6_0.color = arg_6_2
	else
		arg_6_0.color = cc.c3b(0, 0, 0)
	end
	
	arg_6_0.callback = arg_6_1
	
	if not arg_6_0:isShow() then
		arg_6_0:show()
	else
		arg_6_0.callback()
		
		arg_6_0.callback = nil
	end
end

function TransitionScreen.hide(arg_7_0, arg_7_1)
	print("function TransitionScreen.hide( self , callback )")
	
	local function var_7_0()
		if get_cocos_refid(arg_7_0.control) then
			arg_7_0.control:removeFromParent()
		end
		
		if arg_7_1 then
			arg_7_1()
		end
	end
	
	if get_cocos_refid(arg_7_0.control) and type(arg_7_0.control.control_hide_action) == "function" then
		arg_7_0.control.control_hide_action(var_7_0)
	else
		var_7_0()
	end
end
