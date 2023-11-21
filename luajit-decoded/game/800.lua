RumbleUnitPopup = {}

function HANDLER.rumble_unit_detail(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		RumbleUnitPopup:close()
	end
end

function RumbleUnitPopup.open(arg_2_0, arg_2_1)
	if arg_2_0.vars and get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	arg_2_1 = arg_2_1 or {}
	
	local var_2_0 = arg_2_1.layer or SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_2_0) then
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("rumble_unit_detail", true, "wnd", function()
		arg_2_0:close()
	end)
	arg_2_0.vars.unit = arg_2_1.unit
	arg_2_0.vars.code = arg_2_1.code or arg_2_1.unit and arg_2_1.unit:getCode()
	
	arg_2_0:setBaseInfo(arg_2_0.vars.code)
	arg_2_0:setSkillInfo(arg_2_0.vars.code)
	arg_2_0:updateInfo()
	
	if arg_2_1.no_dim then
		arg_2_0:setDimVisible(false)
	end
	
	var_2_0:addChild(arg_2_0.vars.wnd)
end

function RumbleUnitPopup.updateInfo(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	if not arg_4_0.vars.code then
		return 
	end
	
	arg_4_0:setStatInfo(arg_4_0.vars.unit or arg_4_0.vars.code)
end

function RumbleUnitPopup.getUnit(arg_5_0)
	return arg_5_0.vars and arg_5_0.vars.unit
end

function RumbleUnitPopup.setBaseInfo(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_frame")
	
	RumbleUtil:setBaseInfo(var_6_0, arg_6_1)
end

function RumbleUnitPopup.setStatInfo(arg_7_0, arg_7_1)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("n_stat")
	
	RumbleUtil:setStatInfo(var_7_0, arg_7_1)
end

function RumbleUnitPopup.setSkillInfo(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	local function var_8_0(arg_9_0)
		return DB("rumble_character", arg_8_1, "skill" .. arg_9_0)
	end
	
	for iter_8_0 = 1, 2 do
		local var_8_1 = var_8_0(iter_8_0)
		local var_8_2 = arg_8_0.vars.wnd:getChildByName("n_skll" .. iter_8_0)
		local var_8_3 = RumbleUtil:getSkillIcon(var_8_1, {
			show_tooltip = true
		})
		
		if get_cocos_refid(var_8_3) then
			var_8_2:addChild(var_8_3)
		end
		
		local var_8_4 = DB("rumble_skill", var_8_1, "name")
		
		if_set(arg_8_0.vars.wnd, "txt_skll" .. iter_8_0, T(var_8_4))
	end
end

function RumbleUnitPopup.setDimVisible(arg_10_0, arg_10_1)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_10_0.vars.wnd, "n_base", arg_10_1)
end

function RumbleUnitPopup.close(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_11_0.vars.wnd, "block")
	BackButtonManager:pop("rumble_unit_detail")
	
	arg_11_0.vars = nil
end
