AdNetworks = AdNetworks or {}
AdNetworks.enable = PLATFORM ~= "win32"
AdNetworks.is_init = false
AdNetworks.show_count = -1
AdNetworks.vars = {}

local function var_0_0(arg_1_0)
	local var_1_0 = Stove.enable and Stove:getNickNameNo() and tostring(Stove:getNickNameNo()) or ""
	
	print("ad_networks", "stove_nickname_no", var_1_0, "account_level", tostring(AccountData.level or 0), "show_count", tostring(AdNetworks.show_count), "err_reason", arg_1_0)
	Singular:event("ad_networks", "stove_nickname_no", var_1_0, "account_level", tostring(AccountData.level or 0), "show_count", tostring(AdNetworks.show_count), "err_reason", arg_1_0)
end

function MsgHandler.ad_networks_req_show_rewarded_video(arg_2_0)
	arg_2_0.show_count = arg_2_0.show_count or GAME_STATIC_VARIABLE.ad_networks_max_show_count
	AdNetworks.show_count = arg_2_0.show_count
	
	if arg_2_0.res == "err" then
		AdNetworks:procError(arg_2_0.err_msg)
		
		return 
	end
	
	AdNetworks.payload = arg_2_0.payload
	
	if not PRODUCTION_MODE and PLATFORM == "win32" then
		query("ad_networks_rewarded_video_ad", {
			payload = arg_2_0.payload
		})
		
		return 
	end
	
	if show_ad_networks_rewarded_video then
		local var_2_0 = show_ad_networks_rewarded_video()
		
		AdNetworks.enable = AdNetworks.enable and var_2_0
		
		print("show adnetworks is success?", var_2_0)
		
		if var_2_0 then
			AdNetworks:showWaiting()
		else
			AdNetworks:procError("block")
		end
		
		return 
	end
end

function ErrHandler.ad_networks_req_show_rewarded_video(arg_3_0, arg_3_1, arg_3_2)
	AdNetworks:procError(arg_3_1)
end

function MsgHandler.ad_networks_rewarded_video_ad(arg_4_0)
	arg_4_0.show_count = arg_4_0.show_count or GAME_STATIC_VARIABLE.ad_networks_max_show_count
	AdNetworks.show_count = arg_4_0.show_count
	
	if arg_4_0.res == "err" then
		AdNetworks:procError(arg_4_0.err_msg)
		
		return 
	end
	
	local var_4_0 = T("ad_pop_title")
	local var_4_1 = arg_4_0.show_count == GAME_STATIC_VARIABLE.ad_networks_max_show_count and T("ad_pop_desc2") or T("ad_pop_desc", {
		count = AdNetworks.show_count .. "/" .. GAME_STATIC_VARIABLE.ad_networks_max_show_count
	})
	
	AdNetworks:showMessage(var_4_1, var_4_0)
	
	if arg_4_0.mail_update then
		AccountData.mails = arg_4_0.mail_update
		
		TopBarNew:updateMailMark()
	end
end

function ErrHandler.ad_networks_rewarded_video_ad(arg_5_0, arg_5_1, arg_5_2)
	AdNetworks:procError(arg_5_1)
end

function onErrorRewardedVideoAd(arg_6_0)
	AdNetworks:procError(arg_6_0)
end

function onRewardedVideoAdLoaded(arg_7_0)
	if PLATFORM == "iphoneos" then
		AdNetworks:hideWaiting()
	end
	
	arg_7_0 = arg_7_0 == "true"
end

function onRewardedVideoAd(arg_8_0)
	AdNetworks:hideWaiting()
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		AdNetworks:onRewardedVideoAd(arg_8_0)
	end)), "block")
end

function onRewardedVideoDidOpen()
	AdNetworks:onRewardedVideoDidOpen()
end

function onRewardedVideoDidClose()
	AdNetworks:onRewardedVideoDidClose()
end

function onRewardedVideoAdShowFailed(arg_12_0)
	local var_12_0 = json.decode(arg_12_0).reason
	
	AdNetworks:procError(var_12_0, false)
end

function AdNetworks.init(arg_13_0)
	if IS_ANDROID_PC then
		return 
	end
	
	if AdNetworks.is_init then
		return 
	end
	
	AdNetworks.is_init = true
	
	print("AdNetworks init")
	
	if init_ad_networks then
		init_ad_networks()
	end
end

function AdNetworks.showMessage(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0:hideWaiting()
	Dialog:msgBox(arg_14_1, {
		title = arg_14_2
	})
end

function AdNetworks.procError(arg_15_0, arg_15_1, arg_15_2)
	print("AD_networks error ", arg_15_1)
	
	if arg_15_2 == false then
		return 
	end
	
	if not UIOption:isMute("bgm") then
		SoundEngine:setMute("bgm", false, true)
	end
	
	local var_15_0 = T("ad_pop_title")
	local var_15_1 = json.decode(arg_15_1)
	
	if var_15_1 then
		query("ad_networks_fail_tsv_log", {
			reason = arg_15_1
		})
		
		local var_15_2 = T("ad_error") .. "\n" .. (var_15_1.Code or "")
		
		if not PRODUCTION_MODE then
			var_15_2 = var_15_2 .. " " .. (var_15_1.Message or "")
		end
		
		arg_15_0:showMessage(var_15_2, var_15_0)
		
		return 
	end
	
	local var_15_3 = T("ad_error_show")
	
	if arg_15_1 == "is emulator" then
		var_15_3 = T("ad_error_app")
	elseif arg_15_1 == "is mac" then
		var_15_3 = T("ad_error_mac")
	elseif arg_15_1 == "over show" then
		var_15_3 = T("ad_pop_desc_end")
	elseif arg_15_1 == "timeout" then
		var_15_3 = T("ad_error_load")
	elseif arg_15_1 == "not available" or arg_15_1 == "is not available" or arg_15_1 == "No ad config" then
		var_15_3 = T("ad_out_of_stock")
	elseif arg_15_1 == "block" then
		var_15_3 = var_15_3 .. "\n" .. arg_15_1
	else
		var_15_3 = T("ad_error") .. "\n" .. arg_15_1
		
		query("ad_networks_fail_tsv_log", {
			reason = arg_15_1
		})
	end
	
	arg_15_0:showMessage(var_15_3, var_15_0)
end

function AdNetworks.showRewardedVideo(arg_16_0)
	if not arg_16_0.enable then
		return 
	end
	
	if UIAction:Find("block") then
		print("[AdNetworks] UI block showRewardedVideo")
		
		return 
	end
	
	UIAction:Add(DELAY(1000), arg_16_0, "block")
	query("ad_networks_req_show_rewarded_video")
end

function AdNetworks.onRewardedVideoAd(arg_17_0, arg_17_1)
	if not arg_17_0.enable then
		return 
	end
	
	query("ad_networks_rewarded_video_ad", {
		count = 1,
		payload = arg_17_0.payload
	})
end

function AdNetworks.onRewardedVideoDidOpen(arg_18_0)
	if not arg_18_0.enable then
		return 
	end
	
	arg_18_0.is_open = true
	
	SoundEngine:setMute("bgm", true, true)
end

function AdNetworks.onRewardedVideoDidClose(arg_19_0)
	if not arg_19_0.enable then
		return 
	end
	
	arg_19_0.is_open = false
	
	if not UIOption:isMute("bgm") then
		SoundEngine:setMute("bgm", false, true)
	end
	
	SceneManager:updateTouchEventTime()
end

function AdNetworks.startWaitingAni(arg_20_0)
	if not get_cocos_refid(arg_20_0.vars.wait_wnd) then
		return 
	end
	
	if UIAction:Find("run_ras_ani_01") then
		return 
	end
	
	if UIAction:Find("run_ras_ani_02") then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.wait_wnd:getChildByName("img_1")
	
	if not get_cocos_refid(var_20_0) then
		return 
	end
	
	local var_20_1 = arg_20_0.vars.wait_wnd:getChildByName("img_2")
	
	if not get_cocos_refid(var_20_1) then
		return 
	end
	
	var_20_0:setVisible(false)
	var_20_1:setVisible(true)
	UIAction:Add(LOOP(SEQ(DELAY(500), SHOW(true), DELAY(500), SHOW(false))), var_20_0, "run_ras_ani_01")
	UIAction:Add(LOOP(SEQ(DELAY(500), SHOW(false), DELAY(500), SHOW(true))), var_20_1, "run_ras_ani_02")
end

function AdNetworks.stopWaitingAni(arg_21_0)
	UIAction:Remove("run_ras_ani_01")
	UIAction:Remove("run_ras_ani_02")
end

function AdNetworks.showWaiting(arg_22_0)
	if get_cocos_refid(arg_22_0.vars.wait_wnd) then
		return 
	end
	
	local var_22_0 = SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_22_0) then
		return 
	end
	
	UIAction:Remove("ad_waiting_timeout")
	
	arg_22_0.vars.wait_wnd = load_dlg("net_waiting", true, "wnd")
	
	arg_22_0.vars.wait_wnd:setName("waiting")
	arg_22_0.vars.wait_wnd:setAnchorPoint(0, 0)
	arg_22_0.vars.wait_wnd:setPosition(0, 0)
	arg_22_0.vars.wait_wnd:setLocalZOrder(arg_22_0.vars.wait_wnd:getLocalZOrder() + 1)
	var_22_0:addChild(arg_22_0.vars.wait_wnd)
	arg_22_0.vars.wait_wnd:bringToFront()
	arg_22_0:startWaitingAni()
	UIAction:Add(SEQ(DELAY(10000), CALL(function()
		if get_cocos_refid(arg_22_0.vars.wait_wnd) then
			AdNetworks:procError("timeout")
		end
	end)), arg_22_0.vars.wait_wnd, "ad_waiting_timeout")
end

function AdNetworks.hideWaiting(arg_24_0)
	if not get_cocos_refid(arg_24_0.vars.wait_wnd) then
		return 
	end
	
	UIAction:Remove("ad_waiting_timeout")
	arg_24_0:stopWaitingAni()
	arg_24_0.vars.wait_wnd:removeFromParent()
	
	arg_24_0.vars.wait_wnd = nil
end
