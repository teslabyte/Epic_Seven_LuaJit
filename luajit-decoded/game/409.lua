EventMissionView = {}

local var_0_0 = {
	Days = EventMissionDays
}

function EventMissionView.open(arg_1_0, arg_1_1, arg_1_2)
	if not get_cocos_refid(arg_1_1) then
		return 
	end
	
	if not arg_1_0.vars or not get_cocos_refid(arg_1_0.vars.wnd) then
		arg_1_0.vars = {}
		
		local var_1_0 = cc.Layer:create()
		
		var_1_0:setTouchEnabled(true)
		var_1_0:setName("event_mission_view")
		arg_1_1:addChild(var_1_0)
		var_1_0:setPosition(0, 0)
		
		arg_1_0.vars.wnd = var_1_0
	end
	
	if arg_1_0.vars.event_id == arg_1_2 then
		return 
	end
	
	arg_1_0.vars.event_id = arg_1_2
	arg_1_0.vars.event_type = EventMissionUtil:getEventType(arg_1_2)
	arg_1_0.vars.cur_mode = var_0_0[arg_1_0.vars.event_type]
	
	arg_1_0.vars.cur_mode:open(arg_1_0.vars.wnd, arg_1_2)
	
	return arg_1_0
end

function EventMissionView.close(arg_2_0)
	if not arg_2_0.vars then
		return 
	end
	
	arg_2_0.vars.cur_mode:close()
	
	if get_cocos_refid(arg_2_0.vars.wnd) then
		arg_2_0.vars.wnd:removeFromParent()
	end
	
	arg_2_0.vars = nil
end
