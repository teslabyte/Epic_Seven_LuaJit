Scene.patch = SceneHandler:create("patch", 1280, 720)

function HANDLER.patch_popup(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_later" then
		setenv("patch.status", "panding")
		
		if not cc.UserDefault:getInstance():getBoolForKey("tune.has_patch_history", false) and AccountData and (AccountData.last_login_day_id == nil or AccountData.last_login_day_id == 0) then
			tracking_custom_event("cdn_later")
			print("Tune Log : cdn_later")
			cc.UserDefault:getInstance():setBoolForKey("tune.v3_cdn_touch", true)
			cc.UserDefault:getInstance():setBoolForKey("tune.has_patch_history", true)
		end
		
		PatchDownloadPopup:hide()
		
		return 
	end
	
	if arg_1_1 == "btn_ok_tutorial" or arg_1_1 == "btn_ok_normal" then
		print("btn_ok_tutorial")
		Zlong:gameEventLog(ZLONG_LOG_CODE.CDN_PATCH_START)
		setenv("patch.status", "downloading")
		
		if PatchDownloadPopup.callback_ok then
			PatchDownloadPopup.callback_ok()
		end
		
		if not cc.UserDefault:getInstance():getBoolForKey("tune.has_patch_history", false) and AccountData and (AccountData.last_login_day_id == nil or AccountData.last_login_day_id == 0) then
			tracking_custom_event("cdn_ok")
			print("Tune Log : cdn_ok")
			cc.UserDefault:getInstance():setBoolForKey("tune.v3_cdn_touch", true)
			cc.UserDefault:getInstance():setBoolForKey("tune.has_patch_history", true)
		end
		
		PatchDownloadPopup:hide()
		
		return 
	end
end

HANDLER["#WAITINGDLG"] = function(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_start" then
		if not PatchGauge:isCompleted() then
			return 
		end
		
		if PatchGauge:isTouchToStart() then
			return 
		end
		
		PatchGauge:setTouchToStart(true)
		
		local function var_2_0()
			SoundEngine:setMute("bgm", false, false)
			PatchVideo:stop()
			startGame()
		end
		
		SoundEngine:play("event:/ui/title_start")
		PatchGauge:hide(true, var_2_0)
	end
end
PatchDownloadPopup = PatchDownloadPopup or {}

function PatchDownloadPopup.show(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	print("PatchDownloadPopup.show")
	
	if not get_cocos_refid(arg_4_0.dlg_patch_popup) then
		arg_4_0.callback_ok = arg_4_3 and arg_4_3.callback_ok
		arg_4_0.dlg_patch_popup = load_dlg("patch_popup", true, "wnd")
		
		arg_4_1:addChild(arg_4_0.dlg_patch_popup)
		
		if not arg_4_2 then
			Zlong:gameEventLog(ZLONG_LOG_CODE.FORCE_CDN_PATCH_POPUP)
		end
		
		local var_4_0 = arg_4_0.dlg_patch_popup:findChildByName("n_update")
		
		if not get_cocos_refid(var_4_0) then
			return 
		end
		
		local var_4_1 = arg_4_0.dlg_patch_popup:findChildByName("n_first_update")
		
		if not get_cocos_refid(var_4_1) then
			return 
		end
		
		local var_4_2 = (tonumber(getenv("patch.res.version", 0)) or 0) == 0
		local var_4_3 = var_4_2 and var_4_1 or var_4_0
		
		if_set_visible(arg_4_0.dlg_patch_popup, "n_update", not var_4_2)
		if_set_visible(arg_4_0.dlg_patch_popup, "n_first_update", var_4_2)
		var_4_3:findChildByName("dim_msgbox"):setContentSize(VIEW_WIDTH, MAX_VIEW_WITH_LETTERBOX_HEIGHT)
		var_4_3:findChildByName("btn_default"):setContentSize(VIEW_WIDTH, MAX_VIEW_WITH_LETTERBOX_HEIGHT)
		
		local var_4_4 = var_4_3:findChildByName("window_frame")
		
		var_4_4:setContentSize(VIEW_WIDTH, var_4_4:getContentSize().height)
		
		local var_4_5 = tonumber(getenv("patch.download_init_complete", 0))
		local var_4_6 = (tonumber(getenv("patch.download_total", 1)) - var_4_5) / 1048576
		
		print("Patch Capacity : ", var_4_6)
		if_set(var_4_3, "t_mb", string.format("%s : %.1fMB", PreDatas:getText("patch_size"), var_4_6))
		if_set_visible(var_4_3, "btn_ok_tutorial", arg_4_2)
		if_set_visible(var_4_3, "btn_later", arg_4_2)
		if_set_visible(var_4_3, "btn_ok_normal", not arg_4_2)
		
		local var_4_7 = arg_4_2 and T("patch_update_msg_tutorial") or T("patch_update_msg_normal")
		
		if_set(var_4_3, "t_disc", var_4_7)
		
		if var_4_2 then
			local var_4_8 = getenv("media.quality") == "sd"
			local var_4_9 = var_4_8 and T("pre_sd_media_sub_title") or T("pre_fhd_media_sub_title")
			local var_4_10 = var_4_8 and T("pre_sd_media_desc") or T("pre_fhd_media_desc")
			
			if_set(var_4_3, "t_use_media", var_4_9)
			if_set(var_4_3, "t_media_info", var_4_10)
			
			if IS_PUBLISHER_ZLONG and getenv("zlong.download_reward_enable", "false") == "true" and not cc.UserDefault:getInstance():getBoolForKey("download_reward_disable", false) then
				if_set_visible(var_4_1, "download_reward_zl", true)
			end
		end
	end
end

function PatchDownloadPopup.hide(arg_5_0)
	if get_cocos_refid(arg_5_0.dlg_patch_popup) then
		arg_5_0.dlg_patch_popup:removeFromParent()
		
		arg_5_0.dlg_patch_popup = nil
		arg_5_0.callback_ok = nil
	end
end

function PatchDownloadPopup.isShowPopupPatchDownload(arg_6_0)
	return get_cocos_refid(arg_6_0.dlg_patch_popup)
end

PatchVideo = PatchVideo or {}

function PatchVideo.play(arg_7_0, arg_7_1)
	if not get_cocos_refid(arg_7_1) then
		return 
	end
	
	arg_7_0.video_player = create_movie_clip("cinema/mov2_8_10_1.mp4", false, nil, true)
	
	if not get_cocos_refid(arg_7_0.video_player) then
		return 
	end
	
	SoundEngine:setMute("bgm", true, false)
	arg_7_1:addChild(arg_7_0.video_player)
	arg_7_0.video_player:setPositionX(-VIEW_BASE_LEFT)
	arg_7_0.video_player:setLoop(true)
	arg_7_0.video_player:play()
end

function PatchVideo.stop(arg_8_0)
	if not get_cocos_refid(arg_8_0.video_player) then
		return 
	end
	
	arg_8_0.video_player:stop()
end

PatchGauge = PatchGauge or {}

function PatchGauge.fullscreen(arg_9_0)
	if get_cocos_refid(arg_9_0.side_gauge_action) then
		cc.Director:getInstance():getActionManager():removeAction(arg_9_0.side_gauge_action)
	end
	
	if get_cocos_refid(arg_9_0.side_reward_action) then
		cc.Director:getInstance():getActionManager():removeAction(arg_9_0.side_reward_action)
	end
	
	if get_cocos_refid(arg_9_0.fill_layer) then
		arg_9_0.fill_layer:setVisible(true)
		
		local var_9_0 = arg_9_0.fill_layer:getChildByName("bg")
		
		PatchVideo:play(var_9_0)
	end
	
	if get_cocos_refid(arg_9_0.n_download) then
		arg_9_0.n_download:setVisible(false)
	end
	
	if get_cocos_refid(arg_9_0.download) then
		local var_9_1 = arg_9_0.download:getChildByName("download_reward_zl")
		
		if get_cocos_refid(var_9_1) then
			var_9_1:setVisible(false)
		end
	end
end

function PatchGauge.is_fullscreen(arg_10_0)
	if get_cocos_refid(arg_10_0.fill_layer) then
		return arg_10_0.fill_layer:isVisible()
	end
end

function PatchGauge.hide(arg_11_0, arg_11_1, arg_11_2)
	if not get_cocos_refid(arg_11_0.download) then
		return 
	end
	
	if arg_11_1 then
		UIAction:Add(SEQ(FADE_OUT(1000), CALL(function()
			if arg_11_2 then
				arg_11_2()
			end
		end), REMOVE()), arg_11_0.download, "patch.action")
	else
		arg_11_0.download:removeFromParent()
	end
end

function PatchGauge.show(arg_13_0, arg_13_1)
	print("PatchGauge.show")
	
	local var_13_0 = getenv("patch.status")
	
	if var_13_0 == "complete" or var_13_0 == "panding" then
		return 
	end
	
	arg_13_1 = arg_13_1 or {}
	
	local var_13_1 = arg_13_1.parent or cc.Director:getInstance():getRunningScene()
	
	if not get_cocos_refid(var_13_1) then
		return 
	end
	
	if get_cocos_refid(arg_13_0.download) and var_13_1 ~= arg_13_0.download:getParent() then
		arg_13_0.download:ejectFromParent()
		var_13_1:addChild(arg_13_0.download)
	end
	
	local var_13_2 = arg_13_0.download
	
	if not get_cocos_refid(var_13_2) then
		arg_13_0.completed = nil
		var_13_2 = load_control("wnd/download.csb")
		
		var_13_2:setName("#WAITINGDLG")
		var_13_1:addChild(var_13_2)
		
		arg_13_0.download = var_13_2
		arg_13_0.t_help = var_13_2:findChildByName("t_help")
		
		arg_13_0.t_help:setVisible(false)
		
		arg_13_0.t_progress2 = var_13_2:findChildByName("t_progress2")
		
		arg_13_0.t_progress2:setVisible(false)
		
		arg_13_0.t_status = var_13_2:findChildByName("t_status")
		arg_13_0.COLOR_DOWNLOAD = tocolor("#AB8759")
		arg_13_0.COLOR_COMPLETE = tocolor("#6BC11B")
		arg_13_0.fill_layer = var_13_2:findChildByName("n_end")
		
		arg_13_0.fill_layer:setVisible(false)
		
		arg_13_0.progress_download = var_13_2:findChildByName("progress_download")
		arg_13_0.progress_total = var_13_2:findChildByName("progress_total")
		arg_13_0.progress_complete = var_13_2:findChildByName("progress_complete")
		
		arg_13_0.progress_complete:setVisible(false)
		
		arg_13_0.t_progress = var_13_2:findChildByName("t_progress")
		arg_13_0.cm_icon_etcauto = var_13_2:findChildByName("cm_icon_etcauto")
		
		arg_13_0.cm_icon_etcauto:setVisible(false)
		arg_13_0.t_status:setTextColor(arg_13_0.COLOR_DOWNLOAD)
		
		arg_13_0.n_download = var_13_2:findChildByName("n_download")
		arg_13_0.n_download_width = 0
		
		for iter_13_0, iter_13_1 in pairs(arg_13_0.n_download:getChildren()) do
			arg_13_0.n_download_width = math.max(iter_13_1:getContentSize().width, arg_13_0.n_download_width)
		end
		
		arg_13_0.n_download:setVisible(false)
		
		arg_13_0.btn_start = var_13_2:findChildByName("btn_start")
		
		arg_13_0.btn_start:setLocalZOrder(999998)
		arg_13_0.btn_start:setTouchEnabled(false)
		
		arg_13_0.bg_start = var_13_2:findChildByName("bg_start")
	end
	
	arg_13_0.is_touch_to_start = false
	
	var_13_2:setLocalZOrder(999998)
	arg_13_0:updateOffsetDlg()
	
	if get_cocos_refid(arg_13_0.update_listener) then
		cc.Director:getInstance():getEventDispatcher():removeEventListener(arg_13_0.update_listener)
	end
	
	local function var_13_3()
		arg_13_0:update()
	end
	
	arg_13_0.update_listener = cc.EventListenerCustom:create("director_after_draw", var_13_3)
	
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(arg_13_0.update_listener, var_13_2)
	
	if arg_13_1.fullscreen then
		arg_13_0:fullscreen()
	else
		arg_13_0.fill_layer:setVisible(false)
	end
	
	PatchGauge:sideShow(true)
end

function PatchGauge.updateOffsetDlg(arg_15_0)
	if not get_cocos_refid(arg_15_0.download) then
		return 
	end
	
	print("PatchGauge.updateOffsetDlg")
	arg_15_0.download:setAnchorPoint(0.5, 0.5)
	arg_15_0.download:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
	if get_cocos_refid(arg_15_0.n_download) then
		arg_15_0.n_download:setPositionX(-VIEW_BASE_LEFT)
	end
	
	if get_cocos_refid(arg_15_0.fill_layer) then
		local var_15_0 = arg_15_0.fill_layer:getChildByName("bg")
		
		if get_cocos_refid(var_15_0) then
			var_15_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		end
	end
end

function PatchGauge.updateText(arg_16_0, arg_16_1)
	arg_16_0.t_status:setString(T(arg_16_1))
end

function PatchGauge.isCompleted(arg_17_0)
	return arg_17_0.completed
end

function PatchGauge.complete(arg_18_0)
	if arg_18_0.completed then
		return 
	end
	
	arg_18_0.completed = true
	
	Zlong:pollingForLog()
	arg_18_0:updateText("complete_text")
	arg_18_0.progress_complete:setVisible(true)
	arg_18_0.t_status:setTextColor(arg_18_0.COLOR_COMPLETE)
	arg_18_0:sideShow(false)
	
	local var_18_0, var_18_1 = arg_18_0.n_download:getPosition()
	
	UIAction:Add(SEQ(DELAY(2000), SPAWN(LOG(MOVE_TO(200, arg_18_0.n_download_width - VIEW_BASE_LEFT, var_18_1)), CALL(function()
		if arg_18_0:is_fullscreen() then
			UIAction:Add(SEQ(CALL(function()
				arg_18_0.btn_start:setTouchEnabled(true)
			end), SHOW(true), LOOP(SEQ(FADE_OUT(600), DELAY(300), LOG(FADE_IN(1000)), DELAY(300)))), arg_18_0.bg_start, "patch.action")
		end
	end)), SHOW(false)), arg_18_0.n_download, "patch.action")
end

function PatchGauge.sideShow(arg_21_0, arg_21_1, arg_21_2)
	if not get_cocos_refid(arg_21_0.n_download) then
		return 
	end
	
	if get_cocos_refid(arg_21_0.side_gauge_action) then
		cc.Director:getInstance():getActionManager():removeAction(arg_21_0.side_gauge_action)
	end
	
	if arg_21_1 then
		arg_21_0.n_download:setPositionX(arg_21_0.n_download_width - VIEW_BASE_LEFT)
		
		local var_21_0, var_21_1 = arg_21_0.n_download:getPosition()
		
		arg_21_0.side_gauge_action = cc.Sequence:create(cc.DelayTime:create(2), cc.Show:create(), cc.MoveTo:create(0.3, cc.p(0 - VIEW_BASE_LEFT, var_21_1)))
	else
		local var_21_2, var_21_3 = arg_21_0.n_download:getPosition()
		
		arg_21_0.side_gauge_action = cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(arg_21_0.n_download_width - VIEW_BASE_LEFT, var_21_3)), cc.Hide:create())
	end
	
	if get_cocos_refid(arg_21_0.side_gauge_action) then
		arg_21_0.n_download:runAction(arg_21_0.side_gauge_action)
	end
	
	if IS_PUBLISHER_ZLONG and getenv("zlong.download_reward_enable", "false") == "true" and not cc.UserDefault:getInstance():getBoolForKey("download_reward_disable", false) then
		arg_21_0:downloadRewardShow(arg_21_1)
	end
end

function PatchGauge.downloadRewardShow(arg_22_0, arg_22_1)
	if not get_cocos_refid(arg_22_0.download) then
		return 
	end
	
	if get_cocos_refid(arg_22_0.side_reward_action) then
		cc.Director:getInstance():getActionManager():removeAction(arg_22_0.side_reward_action)
	end
	
	local var_22_0 = arg_22_0.download:getChildByName("download_reward_zl")
	
	if not get_cocos_refid(var_22_0) then
		return 
	end
	
	if arg_22_1 then
		var_22_0:setOpacity(0)
		
		arg_22_0.side_reward_action = cc.Sequence:create(cc.DelayTime:create(2), cc.Show:create(), cc.FadeIn:create(0.2), cc.DelayTime:create(5), cc.FadeOut:create(0.2), cc.Hide:create())
	else
		var_22_0:setVisible(false)
		
		arg_22_0.side_reward_action = nil
	end
	
	if get_cocos_refid(arg_22_0.side_reward_action) then
		var_22_0:runAction(arg_22_0.side_reward_action)
	end
end

function PatchGauge.update(arg_23_0)
	if arg_23_0.completed then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.download) then
		return 
	end
	
	local var_23_0 = tonumber(getenv("patch.download_complete", 0))
	local var_23_1 = tonumber(getenv("patch.extract_complete", 0))
	local var_23_2 = var_23_0 / tonumber(getenv("patch.download_total", 1))
	local var_23_3 = var_23_1 / tonumber(getenv("patch.extract_total", 1))
	local var_23_4 = string.format("%.1f%%", (var_23_2 * 100 + var_23_3 * 100) / 2)
	
	arg_23_0.progress_total:setPercent(var_23_3 * 100)
	arg_23_0.progress_download:setPercent(var_23_2 * 100)
	arg_23_0.t_progress:setString(var_23_4)
	
	local var_23_5 = cc.Director:getInstance():getDeltaTime()
	
	arg_23_0.rot_progress = (arg_23_0.rot_progress or 0) + var_23_5 * 100
	
	arg_23_0.cm_icon_etcauto:setRotation(arg_23_0.rot_progress)
	
	if var_23_2 > 0 and var_23_2 < 1 then
		arg_23_0:updateText("pre_patch_download")
	elseif var_23_3 > 0 and var_23_3 < 1 then
		arg_23_0:updateText("pre_patch_decompression")
	end
	
	if false then
	end
	
	if getenv("patch.status") == "complete" then
		arg_23_0:complete()
	end
end

function PatchGauge.getPercent(arg_24_0)
	return tonumber(getenv("patch.extract_complete", 0)) / tonumber(getenv("patch.extract_total", 1))
end

function PatchGauge.isTouchToStart(arg_25_0)
	return arg_25_0.is_touch_to_start
end

function PatchGauge.setTouchToStart(arg_26_0, arg_26_1)
	arg_26_0.is_touch_to_start = arg_26_1
end

function Scene.patch.onLoad(arg_27_0, arg_27_1)
	arg_27_0.layer = cc.Layer:create()
	arg_27_0.start_game = false
end

function Scene.patch.onUnload(arg_28_0)
	if get_cocos_refid(arg_28_0.layer) then
		arg_28_0.layer:removeFromParent()
	end
end

function Scene.patch.onEnter(arg_29_0)
	print("Scene.patch.onEnter")
	
	if getenv("patch.status") == "panding" then
		PatchDownloadPopup:show(arg_29_0.layer, false, {
			callback_ok = function()
				PatchGauge:show({
					fullscreen = true
				})
			end
		})
	else
		PatchGauge:show({
			fullscreen = true
		})
	end
end

function Scene.patch.onAfterDraw(arg_31_0)
end

function Scene.patch.onLeave(arg_32_0)
	UIAction:Remove("patch.action")
end

function Scene.patch.onTouchDown(arg_33_0, arg_33_1, arg_33_2)
end

function show_patch_test()
	setenv("patch.status", "downloading")
	SceneManager:nextScene("patch")
end
