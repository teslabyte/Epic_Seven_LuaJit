PlatformInitializer = {}

function PlatformInitializer.performInitialize(arg_1_0, arg_1_1)
	print("PlatformInitializer performInitialize")
	
	if getenv("zlong.enable") == "true" and get_zlong_initialize_state and get_zlong_initialize_result then
		local var_1_0 = get_zlong_initialize_state()
		
		print("PlatformInitializer initialize_state: ", var_1_0)
		
		if var_1_0 == 400 then
			local var_1_1 = get_zlong_initialize_result()
			
			print("PlatformInitializer result : ", var_1_1)
			arg_1_1()
		else
			arg_1_0.callback = arg_1_1
		end
	else
		arg_1_1()
	end
end

function PlatformInitializer.update(arg_2_0)
	if arg_2_0.callback and get_zlong_initialize_state and get_zlong_initialize_result then
		local var_2_0 = get_zlong_initialize_state()
		
		if var_2_0 == 400 then
			local var_2_1 = get_zlong_initialize_result()
			
			print("PlatformInitializer result : ", var_2_1)
			
			if var_2_1 then
				local var_2_2 = json.decode(var_2_1)
				
				if var_2_2 and var_2_2.device_id then
					print("PlatformInitializer setenv devic_id : ", var_2_2.device_id)
					setenv("device_id", var_2_2.device_id)
				end
			end
			
			arg_2_0.callback()
			
			arg_2_0.callback = nil
		elseif var_2_0 == 401 then
			local var_2_3 = get_zlong_initialize_result()
			
			print("PlatformInitializer result : ", var_2_3)
			
			if var_2_3 then
				arg_2_0.error_data = json.decode(var_2_3)
			end
			
			arg_2_0.callback = nil
		end
	end
	
	if arg_2_0.error_data and get_cocos_refid(arg_2_0.scene) then
		arg_2_0:makeDlg(arg_2_0.scene, {
			title = "Zlong Initialize Error",
			text = arg_2_0.error_data.message or "",
			error_info = arg_2_0.error_data.state_code or ""
		})
		
		arg_2_0.error_data = nil
	end
end

function PlatformInitializer.setScene(arg_3_0, arg_3_1)
	print("PlatformInitializer setScene")
	
	arg_3_0.scene = arg_3_1
end

function PlatformInitializer.makeDlg(arg_4_0, arg_4_1, arg_4_2)
	print("PlatformInitializer makeDlg")
	
	if arg_4_1:getChildByName("#PLATFORMDLG") then
		arg_4_1:removeChildByName("#PLATFORMDLG")
	end
	
	local var_4_0 = cc.CSLoader:createNode("ui/notice.csb")
	
	var_4_0:setName("#PLATFORMDLG")
	arg_4_0:updateOffsetDlg(var_4_0)
	var_4_0:getChildByName("title"):setString(arg_4_2.title)
	var_4_0:getChildByName("text"):setString(arg_4_2.text)
	var_4_0:getChildByName("tab_text"):setString(PreDatas:getText("try_again_later"))
	
	local var_4_1 = var_4_0:getChildByName("error_info")
	
	if var_4_1 and arg_4_2.error_info then
		var_4_1:setString(arg_4_2.error_info)
	end
	
	local var_4_2 = var_4_0:getChildByName("btn_default")
	
	if not arg_4_2.no_timer then
		arg_4_0.dlg_event_timer = systick() + (arg_4_2.delay_time or 4000)
	end
	
	var_4_2:addTouchEventListener(function(arg_5_0, arg_5_1)
		if arg_5_1 == ccui.TouchEventType.ended and (not arg_4_0.dlg_event_timer or arg_4_0.dlg_event_timer == 0) then
			arg_4_0.dlg_event_timer = nil
			
			arg_4_1:removeChildByName("#PLATFORMDLG")
			arg_4_2.callback()
		end
	end)
	arg_4_1:addChild(var_4_0)
end

function PlatformInitializer.updateOffsetDlg(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1 or arg_6_0.layer and arg_6_0.layer:getChildByName("#PLATFORMDLG")
	
	if not var_6_0 then
		return 
	end
	
	var_6_0:setAnchorPoint(0.5, 0.5)
	var_6_0:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
	local var_6_1 = var_6_0:getChildByName("window_frame")
	
	var_6_1:setContentSize(TITLE_WIDTH, var_6_1:getContentSize().height)
end
