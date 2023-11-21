SingleEventPopup = {}

local var_0_0 = "single_event_popup"

HANDLER[var_0_0] = function(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		SingleEventPopup:close()
	end
end

function SingleEventPopup.show(arg_2_0, arg_2_1)
	if arg_2_0:isShow() then
		arg_2_0:close()
	end
	
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.show_params = arg_2_1
	
	if arg_2_1.event_mission and not EventMissionUtil:isActiveEvent(arg_2_1.event_mission) then
		EventMissionUtil:popupEventEnd(arg_2_1.event_mission)
		
		return 
	end
	
	BackButtonManager:push({
		back_func = function()
			arg_2_0:close()
		end,
		check_id = var_0_0
	})
	
	local var_2_0 = SceneManager:getRunningPopupScene()
	
	arg_2_0:initUI(var_2_0)
end

function SingleEventPopup.isShow(arg_4_0)
	return arg_4_0.vars and get_cocos_refid(arg_4_0.vars.wnd)
end

function SingleEventPopup.initUI(arg_5_0, arg_5_1)
	arg_5_0.vars.wnd = load_dlg("lobby_integrated_service", true, "wnd")
	
	if not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	arg_5_0.vars.wnd:setName(var_0_0)
	if_set_visible(arg_5_0.vars.wnd, "n_window", false)
	if_set_visible(arg_5_0.vars.wnd, "n_window_zl", true)
	arg_5_1:addChild(arg_5_0.vars.wnd)
	
	if arg_5_0.vars.show_params then
		arg_5_0:openEventMission(arg_5_0.vars.show_params.event_mission)
	end
	
	arg_5_0.vars.wnd:setLocalZOrder(900000)
end

function SingleEventPopup.openEventMission(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	local var_6_0 = getChildByPath(arg_6_0.vars.wnd, "n_event_7days_zl")
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	if arg_6_1 then
		arg_6_0.vars.event_mission_view = EventMissionView:open(var_6_0, arg_6_1)
	end
	
	if_set_visible(var_6_0, nil, arg_6_1 ~= nil)
end

function SingleEventPopup.close(arg_7_0)
	BackButtonManager:pop({
		check_id = var_0_0
	})
	
	if arg_7_0.vars.event_mission_view then
		arg_7_0.vars.event_mission_view:close()
	end
	
	if get_cocos_refid(arg_7_0.vars.wnd) then
		arg_7_0.vars.wnd:removeFromParent()
	end
	
	arg_7_0.vars = nil
end
