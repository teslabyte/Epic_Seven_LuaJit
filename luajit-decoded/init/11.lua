Patch = Patch or {}
Patch.Actions = Patch.Actions or {}
Patch.has_verinfo = false

function Patch.makeNoticeDlg(arg_1_0, arg_1_1)
	if not get_cocos_refid(arg_1_0.layer) then
		return 
	end
	
	if arg_1_0.layer:getChildByName("#NOTICE") then
		arg_1_0.layer:removeChildByName("#NOTICE")
	end
	
	local var_1_0 = cc.CSLoader:createNode("ui/notice.csb")
	
	var_1_0:setName("#NOTICE")
	arg_1_0:updateOffsetNoticeDlg(var_1_0)
	var_1_0:getChildByName("title"):setString(arg_1_1.title)
	var_1_0:getChildByName("text"):setString(arg_1_1.text)
	var_1_0:getChildByName("tab_text"):setString(PreDatas:getText("retry"))
	
	local var_1_1 = var_1_0:getChildByName("error_info")
	
	if var_1_1 and arg_1_1.error_info then
		var_1_1:setString(arg_1_1.error_info)
	end
	
	local var_1_2 = var_1_0:getChildByName("btn_default")
	
	if not arg_1_1.no_timer then
		arg_1_0.event_timer = systick() + (arg_1_1.delay_time or 4000)
	end
	
	var_1_2:addTouchEventListener(function(arg_2_0, arg_2_1)
		if arg_2_1 == ccui.TouchEventType.ended and (not arg_1_0.event_timer or arg_1_0.event_timer == 0) then
			arg_1_0.event_timer = nil
			
			arg_1_0.layer:removeChildByName("#NOTICE")
			arg_1_1.callback()
		end
	end)
	arg_1_0.layer:addChild(var_1_0)
end

function Patch.updateOffsetNoticeDlg(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1 or arg_3_0.layer and arg_3_0.layer:getChildByName("#NOTICE")
	
	if not var_3_0 then
		return 
	end
	
	var_3_0:setAnchorPoint(0.5, 0.5)
	var_3_0:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
	local var_3_1 = var_3_0:getChildByName("window_frame")
	
	var_3_1:setContentSize(TITLE_WIDTH, var_3_1:getContentSize().height)
end

function Patch.updateMaintenanceLeftTime(arg_4_0, arg_4_1, arg_4_2)
	arg_4_1 = arg_4_1 or arg_4_0.layer
	
	if not get_cocos_refid(arg_4_1) then
		return 
	end
	
	if not get_cocos_refid(arg_4_1:getChildByName("t_time")) then
		return 
	end
	
	if not (arg_4_2 and arg_4_2 ~= 0) then
		arg_4_1:getChildByName("t_time"):setVisible(false)
		arg_4_1:getChildByName("t_maintenance_time"):setVisible(false)
		
		return 
	end
	
	if arg_4_2 - os.time() < 0 then
		arg_4_1:getChildByName("t_time"):setString("00:00:00")
		
		return 
	end
	
	local var_4_0 = arg_4_2 - os.time()
	local var_4_1 = math.floor(var_4_0 / 60 / 60)
	local var_4_2 = math.floor(var_4_0 / 60) % 60
	local var_4_3 = var_4_0 % 60
	
	var_4_1 = var_4_1 < 10 and "0" .. var_4_1 or var_4_1
	var_4_2 = var_4_2 < 10 and "0" .. var_4_2 or var_4_2
	var_4_3 = var_4_3 < 10 and "0" .. var_4_3 or var_4_3
	
	arg_4_1:getChildByName("t_time"):setString(var_4_1 .. ":" .. var_4_2 .. ":" .. var_4_3)
end

local function var_0_0()
	if not call_zlong_async_api then
		return 
	end
	
	if not IS_PUBLISHER_ZLONG then
		return 
	end
	
	if getenv("zlong.enable") ~= "true" then
		return 
	end
	
	if PLATFORM == "win32" then
		return 
	end
	
	print("openTitleNoticeWebView")
	
	function onZlongBaseWebview(arg_6_0)
	end
	
	call_zlong_async_api("ZlongGeneralWebview", json.encode({
		customparams = "",
		action = "notice",
		title_flag = 2,
		title = "",
		fullscreen_flag = 2
	}))
end

function Patch.makeMaintenanceDlg(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or {}
	
	if arg_7_0.layer and arg_7_0.layer:getChildByName("#MAINTENANCE") then
		arg_7_0.layer:removeChildByName("#MAINTENANCE")
	end
	
	local var_7_0 = cc.CSLoader:createNode("ui/title_server_down.csb")
	
	var_7_0:setName("#MAINTENANCE")
	arg_7_0:updateOffsetMaintenanceDlg(var_7_0)
	
	local var_7_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_7_1:setContentSize({
		width = 9999,
		height = 9999
	})
	var_7_1:setName("maintenance_title_black_board")
	arg_7_0.layer:addChild(var_7_1)
	var_7_0:getChildByName("t_title"):setString(arg_7_1.title)
	var_7_0:getChildByName("t_disc"):setString(arg_7_1.msg)
	var_7_0:getChildByName("t_maintenance_time"):setString(PreDatas:getText("maintenance_time"))
	var_7_0:getChildByName("t_time"):setString(arg_7_1.time)
	var_7_0:getChildByName("btn_retry"):getChildByName("txt_retry"):setString(PreDatas:getText("retry_connect"))
	var_7_0:getChildByName("btn_notice"):getChildByName("txt_notice"):setString(PreDatas:getText("go_notice"))
	
	local var_7_2 = var_7_0:getChildByName("btn_server")
	
	var_7_2:setVisible(arg_7_1.show_server_change)
	
	if arg_7_1.region then
		var_7_2:getChildByName("txt_change"):setString(T(arg_7_1.region .. "_server"))
		var_7_2:setVisible(true)
	end
	
	var_7_0:getChildByName("txt_version_detail"):setString(getVersionDetailString())
	
	if getenv("zlong.download_reward_enable", "false") == "true" and not cc.UserDefault:getInstance():getBoolForKey("download_reward_disable", false) then
		local var_7_3 = var_7_0:getChildByName("download_reward")
		
		if get_cocos_refid(var_7_3) then
			var_7_3:setVisible(true)
		end
	end
	
	var_7_0:getChildByName("txt_timer"):setString("")
	
	if not arg_7_1.no_timer then
		arg_7_0.event_timer = systick() + (arg_7_1.delay_time or 4000)
	end
	
	var_7_0:getChildByName("btn_retry"):addTouchEventListener(function(arg_8_0, arg_8_1)
		if arg_8_1 == ccui.TouchEventType.ended and (not arg_7_0.event_timer or arg_7_0.event_timer == 0) then
			arg_7_0.event_timer = nil
			
			arg_7_0.layer:removeChildByName("#MAINTENANCE")
			arg_7_0.layer:removeChildByName("maintenance_title_black_board")
			
			if arg_7_1.retry_handler then
				arg_7_1.retry_handler()
			end
		end
	end)
	var_7_0:getChildByName("btn_notice"):addTouchEventListener(function(arg_9_0, arg_9_1)
		if arg_9_1 == ccui.TouchEventType.ended then
			if getenv("zlong.enable") == "true" then
				var_0_0()
			elseif arg_7_1.url then
				openURL(arg_7_1.url)
			end
		end
	end)
	
	if not arg_7_1.custom_layer then
		arg_7_0.layer:addChild(var_7_0)
	end
	
	return var_7_0
end

function Patch.updateOffsetMaintenanceDlg(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 or arg_10_0.layer and arg_10_0.layer:getChildByName("#MAINTENANCE")
	
	if not var_10_0 then
		return 
	end
	
	var_10_0:setAnchorPoint(0.5, 0.5)
	var_10_0:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
	local var_10_1 = var_10_0:getChildByName("btn_retry")
	
	var_10_1:setPosition(23 - TITLE_WIDTH / 2, var_10_1:getPositionY())
	
	local var_10_2 = var_10_0:getChildByName("btn_notice")
	
	var_10_2:setPosition(TITLE_WIDTH / 2 - 23, var_10_2:getPositionY())
	
	local var_10_3 = var_10_0:getChildByName("btn_server")
	
	var_10_3:setPosition(TITLE_WIDTH / 2 - 23, var_10_3:getPositionY())
	
	local var_10_4 = var_10_0:getChildByName("txt_version_detail")
	
	var_10_4:setPosition(30 - TITLE_WIDTH / 2, var_10_4:getPositionY())
	
	local var_10_5 = var_10_0:getChildByName("download_reward")
	
	if get_cocos_refid(var_10_5) then
		var_10_5:setPosition(TITLE_WIDTH / 2 - 23, var_10_5:getPositionY())
	end
end

function Patch.getMaintenanceTitle(arg_11_0, arg_11_1)
	if arg_11_1 then
		local var_11_0 = getenv("maintenance_title." .. "world_" .. arg_11_1 .. "." .. getUserLanguage(), "")
		
		var_11_0 = var_11_0 == "" and getenv("maintenance_title." .. getUserLanguage(), "") or var_11_0
		
		return var_11_0
	else
		return getenv("maintenance_title." .. getUserLanguage(), "")
	end
end

function Patch.getMaintenanceMessage(arg_12_0, arg_12_1)
	if arg_12_1 then
		local var_12_0 = getenv("maintenance_msg." .. "world_" .. arg_12_1 .. "." .. getUserLanguage(), "")
		
		var_12_0 = var_12_0 == "" and getenv("maintenance_msg." .. getUserLanguage(), "") or var_12_0
		
		return var_12_0
	else
		return getenv("maintenance_msg." .. getUserLanguage(), "")
	end
end

function Patch.getMaintenanceUrl(arg_13_0, arg_13_1)
	if arg_13_1 then
		local var_13_0 = getenv("maintenance_url." .. "world_" .. arg_13_1 .. "." .. getUserLanguage(), "")
		
		var_13_0 = var_13_0 == "" and getenv("maintenance_url." .. getUserLanguage(), "") or var_13_0
		
		return var_13_0
	else
		return getenv("maintenance_url." .. getUserLanguage(), "")
	end
end

function Patch.showMaintenanceDlg(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or {}
	
	print("Patch.showMaintenanceDlg")
	
	local var_14_0 = arg_14_1.title or arg_14_0:getMaintenanceTitle(arg_14_1.region)
	
	var_14_0 = var_14_0 == "" and PreDatas:getText("maintenance") or var_14_0
	
	local var_14_1 = arg_14_1.msg or arg_14_0:getMaintenanceMessage(arg_14_1.region)
	local var_14_2 = arg_14_1.url or arg_14_0:getMaintenanceUrl(arg_14_1.region)
	
	return (arg_14_0:makeMaintenanceDlg({
		title = var_14_0,
		msg = string.gsub(var_14_1, "\\n", "\n"),
		url = var_14_2,
		retry_handler = arg_14_1.retry_handler or function()
			print("retry connect version server from under_maintenance")
			
			arg_14_0.under_maintenance = nil
			
			async_load_version_info()
		end,
		custom_layer = arg_14_1.custom_layer or nil,
		show_server_change = arg_14_1.show_server_change,
		region = arg_14_1.region
	}))
end

function Patch.showBusyDlg(arg_16_0)
	print("Patch.showBusyDlg")
	arg_16_0:makeNoticeDlg({
		delay_time = 60000,
		title = PreDatas:getText("server_busy"),
		text = getenv("busy_msg", "busy_msg"),
		callback = function()
			print("retry connect version server from under_busy")
			
			arg_16_0.under_busy = nil
			
			async_load_version_info()
		end
	})
end

function Patch.showVerinfoErrorDlg(arg_18_0)
	print("Patch.showVerinfoErrorDlg")
	
	local var_18_0 = getenv("verinfo.error")
	
	if var_18_0 == "Server connection failed" then
		var_18_0 = PreDatas:getText("network_failed")
	end
	
	arg_18_0:makeNoticeDlg({
		title = PreDatas:getText("connection_error"),
		text = var_18_0,
		callback = function()
			print("retry connect version server from under_verinfo_error")
			setenv("verinfo.error", "")
			
			arg_18_0.under_verinfo_error = nil
			
			async_load_version_info()
		end
	})
end

function Patch.showPatchErrorDlg(arg_20_0)
	print("Patch.showPatchErrorDlg")
	
	local var_20_0 = PreDatas:getText("patch_error")
	local var_20_1 = getenv("patch.error.file", "")
	
	if var_20_1 ~= "" then
		var_20_0 = var_20_0 .. "\n[bad hotfix file list]\n" .. var_20_1
	end
	
	arg_20_0:makeNoticeDlg({
		title = PreDatas:getText("download_failed"),
		text = var_20_0,
		error_info = getenv("patch.error", "nil"),
		callback = function()
			print("retry connect version server from under_patch_error")
			
			arg_20_0.under_patch_error = nil
			
			stop_patch()
			setenv("patch.error", "")
			async_load_version_info()
		end
	})
end

function Patch.showAppUpgradeDlg(arg_22_0)
	print("Patch.showAppUpgradeDlg")
	arg_22_0:makeNoticeDlg({
		no_timer = true,
		title = PreDatas:getText("need_to_upgrade"),
		text = PreDatas:getText("touch_to_upgrade"),
		callback = function()
			arg_22_0.under_appupgrade = nil
			
			print("openURL : ", getStoreUrl())
			openURL(getStoreUrl())
		end
	})
end

function Patch.showNoUpdateAvailableDlg(arg_24_0)
	print("Patch.showNoUpdateAvailableDlg")
	arg_24_0:makeNoticeDlg({
		no_timer = true,
		title = PreDatas:getText("need_to_upgrade"),
		text = PreDatas:getText("inapp_pre_touch_to_upgrade"),
		callback = function()
			arg_24_0:cancelImmediateUpdate()
			arg_24_0:googleInAppUpdateImmediate()
		end
	})
end

function Patch.startPatch(arg_26_0)
	arg_26_0.patch_complete = nil
	arg_26_0.start_tick = nil
	arg_26_0.under_copy_error = nil
	arg_26_0.under_maintenance = nil
	arg_26_0.under_busy = nil
	arg_26_0.under_verinfo_error = nil
	arg_26_0.under_patch_error = nil
	arg_26_0.under_appupgrade = nil
	arg_26_0.event_timer = nil
	arg_26_0.started = false
	
	arg_26_0:checkStartPatch()
end

function Patch.checkStartPatch(arg_27_0)
	if arg_27_0.started then
		return true
	end
	
	local var_27_0 = getenv("bundle.content.status", "")
	
	if var_27_0 ~= "" then
		if var_27_0 == "copying" then
			return false
		elseif var_27_0 == "error" then
			if not arg_27_0.under_copy_error and get_cocos_refid(arg_27_0.layer) then
				arg_27_0:makeNoticeDlg({
					no_timer = true,
					text = PreDatas:getText("not_enough_storage"),
					callback = function()
						local var_28_0 = cc.Director:getInstance():getOpenGLView()
						
						if get_cocos_refid(var_28_0) then
							var_28_0["end"](var_28_0)
						end
					end
				})
				
				arg_27_0.under_copy_error = true
			end
			
			return false
		else
			return false
		end
	end
	
	arg_27_0.started = true
	
	print("DEBUG start_patch")
	setenv("patch.background", nil)
	start_patch()
	
	return true
end

function Patch.hide(arg_29_0)
	print("DEBUG Patch.hide")
	
	if get_cocos_refid(arg_29_0.layer) then
		arg_29_0.layer:removeFromParent()
	end
	
	arg_29_0.layer = nil
	arg_29_0.patch_complete = nil
	arg_29_0.start_tick = nil
	arg_29_0.under_maintenance = nil
	arg_29_0.under_busy = nil
	arg_29_0.under_verinfo_error = nil
	arg_29_0.under_patch_error = nil
	arg_29_0.under_appupgrade = nil
	arg_29_0.event_timer = nil
end

function Patch.show(arg_30_0, arg_30_1)
	if get_cocos_refid(arg_30_0.layer) then
		arg_30_0.layer:ejectFromParent()
	else
		arg_30_0.layer = cc.Layer:create()
		
		arg_30_0.layer:setName("patch")
		arg_30_0.layer:setAnchorPoint(0.5, 0.5)
		
		if SKIP_PATCH then
			arg_30_0.patch_complete = true
		end
	end
	
	arg_30_1:addChild(arg_30_0.layer)
	
	arg_30_0.start_tick = systick()
end

function Patch.updateOffsetCtrl(arg_31_0)
	arg_31_0:updateOffsetNoticeDlg()
	arg_31_0:updateOffsetMaintenanceDlg()
end

function Patch.isUpdating(arg_32_0)
	return arg_32_0.patch_complete ~= true
end

function Patch.updateMaintenanceRetryTimer(arg_33_0)
	if arg_33_0.event_timer and arg_33_0.event_timer > 0 then
		local var_33_0 = arg_33_0.event_timer - systick()
		
		if var_33_0 <= 0 then
			arg_33_0.event_timer = 0
		end
		
		if arg_33_0.layer then
			local var_33_1 = arg_33_0.layer:getChildByName("#MAINTENANCE")
			
			if var_33_1 then
				local var_33_2 = var_33_1:getChildByName("txt_timer")
				
				if var_33_2 then
					if var_33_0 > 0 then
						var_33_2:setString(tostring(math.floor(var_33_0 / 1000)))
					else
						var_33_2:setString("")
					end
				end
			end
		end
	end
end

function Patch.updatePopupTimer(arg_34_0)
	if arg_34_0.event_timer and arg_34_0.event_timer > 0 then
		local var_34_0 = arg_34_0.event_timer - systick()
		
		if var_34_0 <= 0 then
			arg_34_0.event_timer = 0
		end
		
		if arg_34_0.layer then
			local var_34_1 = arg_34_0.layer:getChildByName("#NOTICE")
			
			if var_34_1 then
				local var_34_2 = var_34_1:getChildByName("tab_timer")
				
				if var_34_2 then
					if var_34_0 > 0 then
						var_34_2:setString(tostring(math.floor(var_34_0 / 1000)))
					else
						var_34_2:setString("")
					end
				end
			end
		end
	end
end

function Patch.checkComplete(arg_35_0)
	local var_35_0 = getenv("patch.minimal.enable")
	local var_35_1 = getenv("patch.required.status")
	local var_35_2 = getenv("patch.status")
	
	if var_35_0 and not Patch.patch_nextstep and (var_35_2 == "ask_download" or var_35_2 == "downloading" or var_35_2 == "extracting") and var_35_1 == "complete" then
		Patch.patch_nextstep = true
		
		if call_zlong_async_api and IS_PUBLISHER_ZLONG and getenv("zlong.enable") == "true" and tonumber(getenv("patch.download_complete", 0)) ~= 0 then
			call_zlong_async_api("ZlongGameEventLog", json.encode({
				remark = "",
				eventID = "16"
			}))
		end
	end
	
	if var_35_2 == "complete" then
		arg_35_0.patch_complete = true
		arg_35_0.patch_info_flags = {}
		
		TitleBackground:setMessage("")
	elseif var_35_2 == "panding" then
		arg_35_0.patch_info_flags = {}
	else
		if arg_35_0.start_tick and systick() - arg_35_0.start_tick > 5000 then
			set_fps(12)
		end
		
		if getenv("patch.background") then
			arg_35_0.patch_info_flags = {
				gage = true
			}
		else
			arg_35_0.patch_info_flags = {
				gage = true,
				text = true
			}
		end
	end
end

function Patch.updatePatchInformation(arg_36_0)
	if not arg_36_0.patch_info_flags then
		arg_36_0.patch_info_flags = {
			gage = true,
			text = true
		}
	end
	
	local var_36_0 = tonumber(getenv("patch.download_complete", 0)) / tonumber(getenv("patch.download_total", 1))
	local var_36_1 = tonumber(getenv("patch.extract_complete", 0)) / tonumber(getenv("patch.extract_total", 1))
	local var_36_2 = tonumber(getenv("patch.required.total", 1))
	local var_36_3 = tonumber(getenv("patch.extract_total", 1))
	local var_36_4 = var_36_2 * VIEW_WIDTH / var_36_3 - (VIEW_WIDTH - tonumber(getenv("design.width", 1280))) / 2
	
	TitleBackground:showPatchInformation(arg_36_0.patch_info_flags, tonumber(getenv("patch.download_total", 0)), var_36_4)
	TitleBackground:updatePatchInformation(arg_36_0:getMessage(), var_36_0, var_36_1)
end

function Patch.bytesToString(arg_37_0, arg_37_1)
	if arg_37_1 < 1048576 then
		return string.format("%.1fkB", arg_37_1 / 1024)
	end
	
	return string.format("%.1fMB", arg_37_1 / 1048576)
end

function Patch.getMessage(arg_38_0)
	local var_38_0 = getenv("verinfo.error", "")
	
	if var_38_0 and var_38_0 ~= "" then
		return ""
	end
	
	local var_38_1 = getenv("patch.error", "")
	
	if var_38_1 and var_38_1 ~= "" then
		return var_38_1
	end
	
	local var_38_2 = getenv("patch.status", "")
	
	if var_38_2 == "complete" then
		return ""
	end
	
	if var_38_2 == "started" then
		return ""
	end
	
	if var_38_2 == "verifying" then
		return PreDatas:getText("connecting")
	end
	
	if var_38_2 == "panding" then
		return PreDatas:getText("connecting")
	end
	
	if var_38_2 == "ask_download" then
		return ""
	end
	
	if var_38_2 == "cancel" then
		return ""
	end
	
	if var_38_2 == "downloading" or var_38_2 == "extracting" then
		return ""
	end
	
	if var_38_2 == "maintenance" then
		return ""
	end
	
	if var_38_2 == "appupgrade" then
		return ""
	end
	
	if var_38_2 == "accept" then
		return ""
	end
	
	return getenv("patch.message", var_38_2)
end

function onSelectFlexibleUpdate(arg_39_0)
	print("Debug onSelectFlexibleUpdate", arg_39_0)
	
	local var_39_0 = json.decode(arg_39_0)
	
	print("onSelectFlexibleUpdate", var_39_0.is_start_update)
	
	if var_39_0.is_start_update then
		Patch.statusInAppUpdateFlexible = "ok"
	else
		Patch.statusInAppUpdateFlexible = "canceled"
		
		toast_message(PreDatas:getText("inapp_pre_upgrade_msg"))
	end
end

function onDownloadedInAppUpdate()
	print("Patch.onDownloadedInAppUpdate")
	
	Patch.statusInAppUpdateFlexible = "downloaded"
	
	if not show_restart_in_app_update then
		print("error 클라이언트에 show_restart_in_app_update() 구현하지 않았습니다.")
		
		Patch.statusInAppUpdateFlexible = "error"
		
		return 
	end
	
	local var_40_0 = PreDatas:getText("inapp_pre_upgrade_popup_title")
	local var_40_1 = PreDatas:getText("inapp_pre_upgrade_popup_desc")
	local var_40_2 = PreDatas:getText("ok")
	local var_40_3 = PreDatas:getText("cancel")
	local var_40_4 = PreDatas:getText("inapp_pre_upgrade_msg")
	
	show_restart_in_app_update(var_40_0, var_40_1, var_40_2, var_40_3, var_40_4)
end

function onNoUpdateAvailable()
	Patch.is_no_inapp_update_available = true
	
	if Patch.under_appupgrade then
		if Patch.layer:getChildByName("#NOTICE") then
			return 
		end
		
		print("Patch.onNoUpdateAvailable")
		toast_message(PreDatas:getText("try_again_later"))
		Patch:showNoUpdateAvailableDlg()
	end
end

function onCanceledImmediateUpdate()
	Patch:cancelImmediateUpdate()
end

function Patch.cancelImmediateUpdate(arg_43_0)
	Patch.under_appupgrade = nil
end

function Patch.googleInAppUpdateFlexible(arg_44_0)
	print("Patch.googleInAppUpdateFlexible")
	
	if not start_in_app_update then
		start_in_app_update = nil
		
		return false
	end
	
	if getenv("allow.inappupdate.android") ~= "1" then
		return false
	end
	
	if arg_44_0.statusInAppUpdateFlexible ~= nil then
		return false
	end
	
	arg_44_0.statusInAppUpdateFlexible = "start"
	
	start_in_app_update(0)
	
	return true
end

function Patch.googleInAppUpdateImmediate(arg_45_0)
	print("Patch.googleInAppUpdateImmediate")
	
	if not start_in_app_update then
		return false
	end
	
	if PLATFORM ~= "android" then
		return false
	end
	
	if getenv("allow.inappupdate.android") ~= "1" then
		return false
	end
	
	start_in_app_update(1)
	
	return true
end

function Patch.update(arg_46_0)
	if not get_cocos_refid(arg_46_0.layer) then
		return 
	end
	
	if not arg_46_0.has_verinfo then
		return 
	end
	
	if arg_46_0.under_appupgrade then
		return 
	end
	
	if not arg_46_0:checkStartPatch() then
		return 
	end
	
	if not arg_46_0.is_logged_start_patch and getenv("patch.required.status", "") ~= "complete" and tonumber(getenv("patch.download_total", 0)) ~= 0 then
		print("start_download_minimal")
		
		arg_46_0.is_logged_start_patch = true
		
		if call_zlong_async_api and IS_PUBLISHER_ZLONG and getenv("zlong.enable") == "true" and PLATFORM ~= "win32" then
			call_zlong_async_api("ZlongGameEventLog", json.encode({
				remark = "",
				eventID = "15"
			}))
		end
	end
	
	if not arg_46_0.is_logged_start_patch and getenv("patch.status", "") == "downloading" then
		print("start_download_patch")
		
		arg_46_0.is_logged_start_patch = true
		
		if tracking_custom_event then
			tracking_custom_event("start_patch")
		end
	end
	
	if getenv("verinfo.status") == "appupgrade.recommend" and PLATFORM == "android" and not Patch.is_no_inapp_update_available then
		arg_46_0:googleInAppUpdateFlexible()
	end
	
	if getenv("verinfo.status") == "appupgrade" then
		arg_46_0.under_appupgrade = true
		
		local var_46_0 = false
		
		if PLATFORM == "android" then
			var_46_0 = arg_46_0:googleInAppUpdateImmediate()
		end
		
		if not var_46_0 then
			arg_46_0:updatePatchInformation()
			arg_46_0:showAppUpgradeDlg()
		end
		
		return 
	end
	
	if arg_46_0.under_maintenance then
		arg_46_0:updateMaintenanceLeftTime(nil, tonumber(getenv("maintenance_end")))
		arg_46_0:updateMaintenanceRetryTimer()
		
		return 
	end
	
	if getenv("verinfo.status") == "maintenance" then
		arg_46_0.under_maintenance = true
		
		arg_46_0:showMaintenanceDlg()
		TitleBackground:setMaintenanceMessage(PreDatas:getText("maintenance_progress"))
		
		return 
	end
	
	if arg_46_0.under_busy then
		arg_46_0:updatePopupTimer()
		
		return 
	end
	
	if getenv("verinfo.status") == "busy" then
		arg_46_0.under_busy = true
		
		arg_46_0:showBusyDlg()
		TitleBackground:setMaintenanceMessage(PreDatas:getText("server_busy_progress"))
		
		return 
	end
	
	if arg_46_0.under_verinfo_error then
		arg_46_0:updatePopupTimer()
		
		return 
	end
	
	if getenv("verinfo.error") and getenv("verinfo.error") ~= "" then
		arg_46_0.under_verinfo_error = true
		
		arg_46_0:showVerinfoErrorDlg()
		TitleBackground:setMaintenanceMessage("load version server info failed (" .. tostring(getenv("verinfo.status", "nil")) .. ")")
	end
	
	if arg_46_0.under_patch_error then
		arg_46_0:updatePopupTimer()
		
		return 
	end
	
	if getenv("patch.error") and getenv("patch.error") ~= "" then
		arg_46_0.under_patch_error = true
		
		arg_46_0:showPatchErrorDlg()
		TitleBackground:setMaintenanceMessage("patch error (" .. tostring(getenv("patch.status", "nil")) .. ")")
		
		if Patch.patch_nextstep then
			if call_zlong_async_api and IS_PUBLISHER_ZLONG and getenv("zlong.enable") == "true" and PLATFORM ~= "win32" then
				call_zlong_async_api("ZlongGameEventLog", json.encode({
					remark = "",
					eventID = "33"
				}))
			end
		elseif call_zlong_async_api and IS_PUBLISHER_ZLONG and getenv("zlong.enable") == "true" and PLATFORM ~= "win32" then
			call_zlong_async_api("ZlongGameEventLog", json.encode({
				remark = "",
				eventID = "17"
			}))
		end
	end
	
	arg_46_0:checkComplete()
	arg_46_0:updatePatchInformation()
end
