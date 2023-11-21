WebEventPopUp = {}

function HANDLER.lobby_integrated_service(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		WebEventPopUp:close()
	elseif arg_1_1 == "btn_m_open" or arg_1_1 == "btn_m_close" then
		WebEventPopUp:toggleMediaPopUp()
	elseif arg_1_1 == "btn_info_event" then
		local var_1_0 = arg_1_0:getParent():getParent().data
		
		WebEventPopUp:toggleEventBtn(var_1_0, arg_1_0:getParent())
	elseif arg_1_1 == "btn_content" then
		local var_1_1 = arg_1_0:getParent():getParent().data
		
		WebEventPopUp:toggleEventBtn(var_1_1, arg_1_0:getParent())
		if_set_visible(arg_1_0:getParent():getParent(), "icon_noti", false)
		
		local var_1_2 = WebEventPopUp:getEventUrl(var_1_1.link)
		
		if not var_1_2 then
			return 
		end
		
		WebEventPopUp:setAlreadyTouched(var_1_2)
	elseif string.starts(arg_1_1, "btn_") then
		if arg_1_0.datasource and arg_1_0.datasource.media_type then
			WebEventPopUp:setMediaRedDotTimeStamp(arg_1_0.datasource.media_type)
			if_set_visible(arg_1_0.datasource.node, "icon_noti", false)
			WebEventPopUp:isShowMediaTogglesRedDot()
		end
		
		if arg_1_0.stove_url_type then
			Stove:openCommunityUI(arg_1_0.stove_url_type)
		elseif arg_1_0.datasource and arg_1_0.datasource.media_type then
			Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
				is_full = true,
				url = arg_1_0.url
			})
		else
			WebEventPopUp:openURL(arg_1_0.url)
			WebEventPopUp:showWebView(true)
		end
	end
end

function WebEventPopUp.isShowMediaTogglesRedDot(arg_2_0)
	if not get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	local var_2_0 = false
	
	for iter_2_0, iter_2_1 in pairs(arg_2_0.vars.media_icons or {}) do
		if get_cocos_refid(iter_2_1.node) and iter_2_1.node:getChildByName("icon_noti"):isVisible() then
			var_2_0 = true
			
			break
		end
	end
	
	if_set_visible(arg_2_0.vars.wnd:getChildByName("n_media"), "icon_noti", var_2_0)
end

function HANDLER.lobby_integrated_s_card(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.data["link_" .. getUserLanguage()] or arg_3_0.data.link or ""
	
	if string.starts(var_3_0, "epic7") then
		movetoPath(var_3_0)
	else
		WebEventPopUp:openURL(var_3_0, true)
		WebEventPopUp:showWebView(true)
	end
end

function HANDLER.lobby_integrated_service_icon(arg_4_0, arg_4_1)
	if string.starts(arg_4_1, "btn_cal") then
		local var_4_0 = arg_4_0.data
		local var_4_1 = SceneManager:getRunningPopupScene()
		
		if WebEventPopUp.vars and get_cocos_refid(WebEventPopUp.vars.wnd) then
			var_4_1 = WebEventPopUp.vars.wnd
		end
		
		local var_4_2 = {
			has_open_webevent = true,
			option = true,
			parent = var_4_1
		}
		local var_4_3 = {}
		
		table.push(var_4_3, arg_4_0.data)
		
		if table.count(var_4_3) > 1 then
			var_4_2.current = 1
			var_4_2.calendar_count = table.count(var_4_3)
		end
		
		WebEventPopUp:showWebView(false, true)
		Lobby:showAttendanceEvent(var_4_0, var_4_2)
		if_set_visible(WebEventPopUp.vars.wnd, "n_calendar_bg", true)
		if_set_visible(WebEventPopUp.vars.wnd, "n_event_banner", false)
	end
end

function WebEventPopUp.toggleEventBtn(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.vars.selected_event = arg_5_1
	
	if arg_5_0.vars.selected_event_node then
		if_set_visible(arg_5_0.vars.selected_event_node, "n_select", false)
	end
	
	if_set_visible(arg_5_2, "n_select", true)
	
	arg_5_0.vars.selected_event_node = arg_5_2
	
	if_set_visible(arg_5_0.vars.wnd, "n_event_banner", arg_5_1.is_category == "total")
	
	if arg_5_1.event_mission then
		arg_5_0:openEventMission(arg_5_1.event_mission)
	elseif arg_5_1.link then
		WebEventPopUp:openURL(arg_5_1.link, true)
		WebEventPopUp:queryRedDot()
	end
	
	arg_5_0:showEventMissionView(arg_5_1.event_mission)
	arg_5_0:showWebView(not arg_5_1.event_mission and arg_5_1.link, false, arg_5_1.is_category == "total")
end

function WebEventPopUp.makeQueryString(arg_6_0)
	local var_6_0 = ""
	local var_6_1 = getUserLanguage()
	
	if var_6_1 == "zht" then
		var_6_1 = "zh-TW"
	elseif var_6_1 == "zhs" then
		var_6_1 = "zh-CN"
	end
	
	if Stove.enable then
		var_6_0 = var_6_0 .. "?authorization=" .. get_stove_game_access_token()
		var_6_0 = var_6_0 .. "&characterno=" .. tonumber(Stove:getNickNameNo()) or 0
		var_6_0 = var_6_0 .. "&lang=" .. var_6_1
	else
		var_6_0 = "?lang=" .. var_6_1
	end
	
	return var_6_0
end

function WebEventPopUp.openURL(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_1 then
		return 
	end
	
	if Stove:checkStandbyAndBalloonMessage() then
		Login.FSM:changeState(LoginState.WEB_VIEW_CHECK_TOKEN, {
			url = arg_7_1,
			need_token_update = arg_7_2,
			callback = function()
				local var_8_0 = arg_7_2 and arg_7_1 .. WebEventPopUp:makeQueryString() or arg_7_1
				local var_8_1 = getUserLanguage()
				
				if var_8_1 == "zht" then
					var_8_1 = "zh-TW"
				elseif var_8_1 == "zhs" then
					var_8_1 = "zh-CN"
				end
				
				local var_8_2 = "world_" .. Login:getRegion()
				
				if Stove.enable then
					var_8_2 = var_8_2 .. Stove.vars.stove_qa_world_postfix
				end
				
				local var_8_3 = Stove.enable and Stove.user_data.game_id or "STOVE_EPIC7"
				
				if Stove.enable and getenv("stove.environment") ~= "live" and var_8_2 == "world_kor" and var_8_3 == "STOVE_EPIC7_DEV" then
					var_8_0 = var_8_0 .. "&gdist=scdev"
				end
				
				if getenv("stove.environment") ~= "live" then
					print("[WebView] url = ", var_8_0)
				end
				
				local var_8_4 = {
					["Accept-Language"] = var_8_1,
					Authorization = get_stove_game_access_token(),
					GameID = var_8_3,
					CharacterNo = tostring(Stove:getNickNameNo() or 0),
					ServerID = var_8_2
				}
				
				WebEventPopUp.vars.webview:loadUrl(var_8_0, var_8_4)
			end
		})
	end
end

function WebEventPopUp.isShowWebView(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	return arg_9_0.vars.is_show_webview
end

function WebEventPopUp.showWebView(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_2 then
		arg_10_0.vars.is_show_webview = arg_10_1
	end
	
	if_set_visible(arg_10_0.vars.wnd, "webview", arg_10_1)
	
	if arg_10_3 and arg_10_3 == true then
		if_set_visible(arg_10_0.vars.wnd, "n_calendar_bg", false)
	else
		if_set_visible(arg_10_0.vars.wnd, "n_calendar_bg", not arg_10_1)
	end
end

function WebEventPopUp.openEventMission(arg_11_0, arg_11_1)
	local var_11_0 = getChildByPath(arg_11_0.vars.wnd, "n_event_7days")
	
	arg_11_0.vars.event_mission_view = EventMissionView:open(var_11_0, arg_11_1)
end

function WebEventPopUp.showEventMissionView(arg_12_0, arg_12_1)
	local var_12_0 = getChildByPath(arg_12_0.vars.wnd, "n_event_7days")
	
	if_set_visible(var_12_0, nil, arg_12_1)
end

function WebEventPopUp.toggleMediaPopUp(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	arg_13_0.vars.is_media_open = arg_13_1 or not arg_13_0.vars.is_media_open
	
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_m_select")
	local var_13_1 = arg_13_0.vars.is_media_open == true and FADE_IN or FADE_OUT
	
	UIAction:Add(SEQ(var_13_1(90)), var_13_0, "block")
	
	local var_13_7
	
	if arg_13_0.vars.is_media_open then
		local var_13_2 = 0
		
		for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.media_icons or {}) do
			UIAction:Add(SEQ(DELAY(var_13_2), SPAWN(SHOW(true), FADE_IN(350), LOG(MOVE_TO(280, iter_13_1.end_position:getPositionX(), iter_13_1.end_position:getPositionY())))), iter_13_1.node, "block")
			
			var_13_2 = var_13_2 + 30
		end
		
		local var_13_3 = table.clone(arg_13_0.vars.top_icons)
		
		table.reverse(var_13_3)
		
		local var_13_4 = 0
		
		for iter_13_2, iter_13_3 in pairs(var_13_3 or {}) do
			UIAction:Add(SEQ(DELAY(var_13_4), FADE_OUT(140), SHOW(false)), iter_13_3.node, "block")
			
			var_13_4 = var_13_4 + 30
		end
	else
		local var_13_5 = 0
		local var_13_6 = table.clone(arg_13_0.vars.media_icons)
		
		table.reverse(var_13_6)
		
		for iter_13_4, iter_13_5 in pairs(var_13_6 or {}) do
			UIAction:Add(SEQ(DELAY(var_13_5), SPAWN(FADE_OUT(150), RLOG(MOVE_TO(300, iter_13_5.start_position:getPositionX(), iter_13_5.start_position:getPositionY()))), SHOW(false)), iter_13_5.node, "block")
			
			var_13_5 = var_13_5 + 10
		end
		
		var_13_7 = 0
		
		for iter_13_6, iter_13_7 in pairs(arg_13_0.vars.top_icons or {}) do
			UIAction:Add(SEQ(DELAY(var_13_7), SHOW(true), FADE_IN(140)), iter_13_7.node, "block")
			
			var_13_7 = var_13_7 + 20
		end
	end
end

function WebEventPopUp.updateRedDotUI(arg_14_0)
	if not arg_14_0:isShow() then
		return 
	end
	
	if arg_14_0.vars.itemView then
		arg_14_0.vars.itemView:refresh()
	end
end

function WebEventPopUp.parseBool(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1
	local var_15_1 = type(arg_15_1)
	
	if var_15_1 == "number" then
		var_15_0 = var_15_0 == 1 and true or false
	elseif var_15_1 == "string" then
		var_15_0 = var_15_0 == "Y" and true or false
	else
		var_15_0 = nil
	end
	
	return var_15_0
end

function WebEventPopUp.getEventInfo(arg_16_0, arg_16_1)
	if not arg_16_0.web_event_data then
		return 
	end
	
	if not arg_16_0.web_event_data[arg_16_1] then
		return 
	end
	
	return arg_16_0.web_event_data[arg_16_1]
end

function WebEventPopUp.getEventUrl(arg_17_0, arg_17_1)
	local var_17_0
	
	if not arg_17_1 then
		return 
	end
	
	if string.starts(arg_17_1, "epic7") then
		local var_17_1 = parseEpic7Link(arg_17_1).params
		
		var_17_0 = var_17_1.event_mission or var_17_1.custom_event_id
	else
		local var_17_2 = arg_17_0:_getApiURI()
		
		var_17_0 = (string.split(arg_17_1, var_17_2) or {})[2]
	end
	
	return var_17_0
end

function WebEventPopUp.setAlreadyTouched(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not arg_18_1 then
		return 
	end
	
	arg_18_0.vars.already_touched = arg_18_0.vars.already_touched or {}
	arg_18_0.vars.already_touched[arg_18_1] = true
end

function WebEventPopUp.isAlreadyTouched(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not arg_19_0.vars.already_touched or not arg_19_1 then
		return 
	end
	
	return arg_19_0.vars.already_touched[arg_19_1]
end

function WebEventPopUp.setReddotShowed(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not arg_20_1 then
		return 
	end
	
	arg_20_0.vars.reddot_showed = arg_20_0.vars.reddot_showed or {}
	arg_20_0.vars.reddot_showed[arg_20_1] = true
end

function WebEventPopUp.isReddotShowed(arg_21_0, arg_21_1)
	if not arg_21_0.vars or not arg_21_0.vars.reddot_showed or not arg_21_1 then
		return 
	end
	
	return arg_21_0.vars.reddot_showed[arg_21_1]
end

function WebEventPopUp.getRedDotInfo(arg_22_0, arg_22_1)
	if not arg_22_0.web_event_data then
		return 
	end
	
	if not arg_22_0.web_event_data.red_dots then
		return 
	end
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.web_event_data.red_dots or {}) do
		if string.find(iter_22_0, arg_22_1 or "") then
			return to_n(iter_22_1) == 1
		end
	end
end

function WebEventPopUp.getWnd(arg_23_0)
	return arg_23_0.vars and arg_23_0.vars.wnd
end

function WebEventPopUp.updateUI(arg_24_0, arg_24_1)
	TopBarNew:updateWebEventNoti(WebEventNoti:isShowRedDot())
	TopBarNew:updateQuickMenuEventButton()
	
	if not arg_24_0:isShow() then
		return 
	end
	
	arg_24_0:updateRedDotUI()
end

function WebEventPopUp.getEventData(arg_25_0)
	return arg_25_0.web_event_data
end

function WebEventPopUp.updateData(arg_26_0, arg_26_1)
	local var_26_0 = {}
	
	if arg_26_1 then
		arg_26_0.response = arg_26_1.resultbody
	end
	
	var_26_0.red_dots = arg_26_0.response and arg_26_0.response.reddotList or {}
	var_26_0.red_dots.isshowreddot = arg_26_0.response and arg_26_0.response.isshowreddot or 0
	var_26_0.web_event = Account:getEventNoticeIconInfo()
	arg_26_0.web_event_data = var_26_0
	
	return var_26_0
end

function WebEventPopUp._buildIconPositionNode(arg_27_0)
	if not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	arg_27_0.vars.dest_icon_position = {}
	
	for iter_27_0 = 1, 10 do
		arg_27_0.vars.dest_icon_position["n_l_" .. iter_27_0] = arg_27_0.vars.wnd:getChildByName("n_l_" .. iter_27_0)
		arg_27_0.vars.dest_icon_position["n_r_" .. iter_27_0] = arg_27_0.vars.wnd:getChildByName("n_r_" .. iter_27_0)
		arg_27_0.vars.dest_icon_position["n_" .. iter_27_0] = arg_27_0.vars.wnd:getChildByName("n_" .. iter_27_0)
		arg_27_0.vars.dest_icon_position["n_" .. iter_27_0 .. "_start"] = arg_27_0.vars.wnd:getChildByName("n_" .. iter_27_0 .. "_start")
	end
end

function WebEventPopUp.initTopUIBtns(arg_28_0)
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_stove")
	
	if not get_cocos_refid(var_28_0) then
		return 
	end
	
	local var_28_1 = arg_28_0.vars.wnd:getChildByName("n_notice")
	
	if not get_cocos_refid(var_28_1) then
		return 
	end
	
	local var_28_2 = arg_28_0.vars.wnd:getChildByName("n_patch")
	
	if not get_cocos_refid(var_28_2) then
		return 
	end
	
	local var_28_3 = arg_28_0.vars.dest_icon_position.n_r_2
	
	if not get_cocos_refid(var_28_3) then
		return 
	end
	
	var_28_0:setPosition(var_28_3:getPosition())
	
	local var_28_4 = arg_28_0.vars.dest_icon_position.n_l_1
	
	if not get_cocos_refid(var_28_4) then
		return 
	end
	
	var_28_1:setPosition(var_28_4:getPosition())
	
	local var_28_5 = arg_28_0.vars.dest_icon_position.n_l_2
	
	if not get_cocos_refid(var_28_5) then
		return 
	end
	
	var_28_2:setPosition(var_28_5:getPosition())
	
	local var_28_6 = var_28_2:getChildByName("btn_patch")
	
	if not get_cocos_refid(var_28_6) then
		return 
	end
	
	local var_28_7 = var_28_1:getChildByName("btn_notice")
	
	if not get_cocos_refid(var_28_7) then
		return 
	end
	
	local var_28_8 = var_28_0:getChildByName("btn_stove")
	
	if not get_cocos_refid(var_28_8) then
		return 
	end
	
	var_28_6.stove_url_type = "patchnote"
	var_28_7.stove_url_type = "notice"
	var_28_8.stove_url_type = "stove"
	var_28_6.datasource = {
		media_type = "update",
		node = var_28_2
	}
	var_28_7.datasource = {
		media_type = "notice",
		node = var_28_1
	}
	var_28_8.datasource = {
		media_type = "stove",
		node = var_28_0
	}
	arg_28_0.vars.top_icons = {}
	
	table.push(arg_28_0.vars.top_icons, {
		name = "n_notice",
		node = var_28_1
	})
	if_set_visible(var_28_1, "icon_noti", arg_28_0:isRedDotShow("notice"))
	table.push(arg_28_0.vars.top_icons, {
		name = "n_patch",
		node = var_28_2
	})
	if_set_visible(var_28_2, "icon_noti", arg_28_0:isRedDotShow("update"))
	
	local var_28_9 = 3
	local var_28_10 = arg_28_0:getAttendanceData()
	
	for iter_28_0, iter_28_1 in ipairs(var_28_10 or {}) do
		local var_28_11 = table.count(iter_28_1.info.days or {})
		local var_28_12 = arg_28_0:buildCalenderEventIcon(var_28_11, iter_28_1.event_name, iter_28_1)
		
		var_28_12:setAnchorPoint(0, 0)
		var_28_12:setPosition(0, 0)
		
		local var_28_13 = arg_28_0.vars.wnd:getChildByName("n_l_" .. var_28_9)
		
		if get_cocos_refid(var_28_13) then
			var_28_13:addChild(var_28_12)
		end
		
		var_28_9 = var_28_9 + 1
		
		table.push(arg_28_0.vars.top_icons, {
			name = "btn_cal_" .. iter_28_1.event_name,
			node = var_28_12
		})
	end
	
	table.push(arg_28_0.vars.top_icons, {
		name = "n_stove",
		node = var_28_0
	})
end

function WebEventPopUp.buildCalenderEventIcon(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = load_dlg("lobby_integrated_service_icon", true, "wnd")
	
	if not get_cocos_refid(var_29_0) then
		return 
	end
	
	if Account:isReturnAttendance(arg_29_3.event_name) then
		if_set(var_29_0, "txt_info", "W")
	elseif string.find(arg_29_3.event_name, "new") then
		if_set(var_29_0, "txt_info", "N")
	else
		if_set(var_29_0, "txt_info", arg_29_1)
	end
	
	var_29_0:getChildByName("btn_calendar").data = arg_29_3
	
	var_29_0:getChildByName("btn_calendar"):setName("btn_cal_" .. arg_29_2)
	
	return var_29_0
end

function WebEventPopUp.getAttendanceData(arg_30_0)
	local var_30_0 = Account:getEvents().attendance or {}
	
	for iter_30_0, iter_30_1 in pairs(var_30_0 or {}) do
		iter_30_1.sort = to_n(iter_30_1.sort)
		
		if Account:isReturnAttendance(iter_30_1.event_name) then
			iter_30_1.sort = iter_30_1.sort + 100
		elseif string.find(iter_30_1.event_name, "new") then
			iter_30_1.sort = iter_30_1.sort + 1000
		end
	end
	
	table.sort(var_30_0, function(arg_31_0, arg_31_1)
		return arg_31_0.sort < arg_31_1.sort
	end)
	
	return var_30_0
end

function WebEventPopUp.isRedDotShow(arg_32_0, arg_32_1)
	local var_32_0 = false
	local var_32_1 = arg_32_0:getEventData().web_event.notice_event_reddot
	
	for iter_32_0, iter_32_1 in pairs(var_32_1 or {}) do
		if table.find(iter_32_1.langs, getUserLanguage()) then
			local var_32_2 = os.time()
			
			if var_32_2 >= iter_32_1.start_time and var_32_2 <= iter_32_1.end_time and arg_32_1 == iter_32_1.event_name and (arg_32_0:getMediaRedDotTimeStamp(arg_32_1) or 0) <= iter_32_1.start_time then
				var_32_0 = true
				
				break
			end
		end
	end
	
	return var_32_0
end

function WebEventPopUp.isShowMainBtnRedDot(arg_33_0)
	if not arg_33_0.web_event_data then
		return 
	end
	
	local var_33_0 = false
	local var_33_1 = arg_33_0:getEventData().web_event.notice_event_reddot
	
	for iter_33_0, iter_33_1 in pairs(var_33_1 or {}) do
		if table.find(iter_33_1.langs, getUserLanguage()) then
			local var_33_2 = os.time()
			
			if var_33_2 >= iter_33_1.start_time and var_33_2 <= iter_33_1.end_time and (arg_33_0:getMediaRedDotTimeStamp(iter_33_1.event_name) or 0) <= iter_33_1.start_time then
				var_33_0 = true
				
				break
			end
		end
	end
	
	return var_33_0
end

function WebEventPopUp.getMediaRedDotTimeStamp(arg_34_0, arg_34_1)
	local var_34_0 = SAVE:get("event_media_reddots", "") or ""
	
	return (json.decode(var_34_0) or {})[arg_34_1]
end

function WebEventPopUp.setMediaRedDotTimeStamp(arg_35_0, arg_35_1)
	local var_35_0 = SAVE:get("event_media_reddots", "") or ""
	local var_35_1 = json.decode(var_35_0) or {}
	
	var_35_1[arg_35_1] = os.time()
	
	SAVE:set("event_media_reddots", json.encode(var_35_1))
end

function WebEventPopUp.initMediaBtn(arg_36_0)
	if not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_36_0.vars.wnd, "n_top", true)
	
	local var_36_0 = arg_36_0.vars.wnd:getChildByName("n_m_select")
	
	var_36_0:setOpacity(0)
	if_set_visible(var_36_0, nil, true)
	
	local var_36_1 = arg_36_0:getEventData().web_event.notice_event_icon_media
	local var_36_2 = {}
	
	for iter_36_0, iter_36_1 in pairs(var_36_1 or {}) do
		if iter_36_1["link_" .. getUserLanguage()] and iter_36_1["link_" .. getUserLanguage()] ~= "" then
			iter_36_1.node = arg_36_0.vars.wnd:getChildByName("n_" .. iter_36_1.media_type)
			
			table.push(var_36_2, iter_36_1)
		end
	end
	
	table.sort(var_36_2, function(arg_37_0, arg_37_1)
		return (arg_37_0 and arg_37_0.priority and to_n(arg_37_0.priority) or 0) > (arg_37_1 and arg_37_1.priority and to_n(arg_37_1.priority) or 0)
	end)
	
	local var_36_3 = false
	local var_36_4 = arg_36_0:getEventData().web_event.notice_event_reddot
	
	for iter_36_2, iter_36_3 in pairs(var_36_2) do
		local var_36_5 = arg_36_0.vars.dest_icon_position["n_" .. iter_36_2 .. "_start"]
		
		iter_36_3.end_position, iter_36_3.start_position = arg_36_0.vars.dest_icon_position["n_" .. iter_36_2], var_36_5
		
		if get_cocos_refid(iter_36_3.node) then
			iter_36_3.node:setPosition(var_36_5:getPositionX(), var_36_5:getPositionY())
			if_set_visible(iter_36_3.node, nil, true)
			if_set_opacity(iter_36_3.node, nil, 0)
			
			local var_36_6 = arg_36_0:isRedDotShow(iter_36_3.media_type)
			
			if not var_36_3 and var_36_6 then
				var_36_3 = true
			end
			
			iter_36_3.node:getChildByName("btn_" .. iter_36_3.media_type).url = iter_36_3["link_" .. getUserLanguage()]
			iter_36_3.node:getChildByName("btn_" .. iter_36_3.media_type).datasource = iter_36_3
			
			if_set_visible(iter_36_3.node, "icon_noti", var_36_6)
		end
	end
	
	arg_36_0.vars.media_icons = var_36_2
	
	local var_36_7 = arg_36_0.vars.wnd:getChildByName("n_media")
	local var_36_8 = arg_36_0.vars.dest_icon_position.n_r_1
	
	var_36_7:setPosition(var_36_8:getPositionX(), var_36_8:getPositionY())
	if_set_visible(var_36_7, "icon_noti", var_36_3)
end

function WebEventPopUp.getSelectedEvent(arg_38_0)
	if not arg_38_0.vars then
		return 
	end
	
	return arg_38_0.vars.selected_event
end

function WebEventPopUp.getWindow(arg_39_0)
	if not arg_39_0.vars then
		return 
	end
	
	return arg_39_0.vars.wnd
end

function WebEventPopUp.changeSelectBtn(arg_40_0, arg_40_1)
	if not arg_40_0.vars then
		return 
	end
	
	if not arg_40_1 then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.itemView:getChildren()
	
	for iter_40_0, iter_40_1 in pairs(var_40_0 or {}) do
		if get_cocos_refid(iter_40_1:getChildren()[1]) then
			local var_40_1 = iter_40_1:getChildren()[1].data
			
			if var_40_1 and var_40_1.link then
				local var_40_2 = arg_40_0:getEventUrl(var_40_1.link)
				
				if var_40_2 and string.find(arg_40_1, var_40_2) then
					if arg_40_0.vars.selected_event and arg_40_0.vars.selected_event.link and arg_40_0.vars.selected_event.link == var_40_1.link then
						return 
					end
					
					arg_40_0.vars.selected_event = var_40_1
					
					if arg_40_0.vars.selected_event_node then
						if_set_visible(arg_40_0.vars.selected_event_node, "n_select", false)
						if_set_visible(iter_40_1:getChildren()[1], "n_select", true)
					end
					
					arg_40_0.vars.selected_event_node = iter_40_1:getChildren()[1]
					
					arg_40_0.vars.itemView:refresh()
					
					return 
				end
			end
		end
	end
end

function WebEventPopUp.initUI(arg_41_0, arg_41_1)
	arg_41_0.vars.wnd = load_dlg("lobby_integrated_service", true, "wnd")
	
	if not get_cocos_refid(arg_41_0.vars.wnd) then
		return 
	end
	
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_web")
	
	if_set_visible(var_41_0, nil, true)
	
	arg_41_0.vars.webview = WebView:init(var_41_0:getPositionX() - 446, var_41_0:getPositionY() - 250, 892, 500, arg_41_0.vars.wnd)
	
	arg_41_0.vars.webview:getWebView():setName("webview")
	arg_41_0.vars.webview:setOnDidFinishLoading(function(arg_42_0, arg_42_1)
		WebEventPopUp:changeSelectBtn(arg_42_1)
	end)
	arg_41_0:updateData()
	arg_41_0:_buildIconPositionNode()
	arg_41_0:initTopUIBtns()
	arg_41_0:initMediaBtn()
	arg_41_0:initBannerScrollView()
	arg_41_0:initEventListView()
	if_set_visible(arg_41_0.vars.wnd, "n_event_banner", true)
	if_set_visible(arg_41_0.vars.wnd, "n_calendar_bg", false)
	arg_41_0:toggleEventBtn(arg_41_0.vars.selected_event, arg_41_0.vars.selected_event_node)
	arg_41_0:updateUI()
	arg_41_1:addChild(arg_41_0.vars.wnd)
	arg_41_0.vars.wnd:setLocalZOrder(900000)
end

function WebEventPopUp.isShow(arg_43_0)
	return arg_43_0.vars and get_cocos_refid(arg_43_0.vars.wnd) and arg_43_0.vars.wnd:isVisible()
end

function WebEventPopUp.close(arg_44_0)
	if not arg_44_0:isShow() then
		return 
	end
	
	BackButtonManager:pop("WebEventPopUp")
	WebEventPopUp:queryRedDot("Y")
	
	if arg_44_0.vars.event_mission_view then
		arg_44_0.vars.event_mission_view:close()
	end
	
	arg_44_0.vars.webview:close()
	arg_44_0.vars.wnd:removeFromParent()
	
	arg_44_0.vars = nil
	
	if Lobby.vars then
		Lobby.vars.has_open_webevent = nil
	end
	
	Lobby:checkMail(true)
end

function WebEventPopUp.callback_reddot(arg_45_0, arg_45_1)
	arg_45_0:updateData(arg_45_1)
	arg_45_0:updateUI()
	
	arg_45_0.red_dot_request_count = arg_45_0.red_dot_request_count or 0
	
	if arg_45_0.red_dot_request_count > 0 then
		arg_45_0.red_dot_request_count = arg_45_0.red_dot_request_count - 1
	end
end

function WebEventPopUp._getApiURI(arg_46_0)
	local var_46_0 = "https://event-epic7.smilegatemegaport.com"
	
	if getenv("stove.environment") ~= "live" then
		var_46_0 = "https://sandbox-event-epic7.smilegatemegaport.com"
	end
	
	return var_46_0
end

function WebEventPopUp.webevent_query(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_0:_getApiURI()
	
	Net:arena_queue_start()
	print("webevent_query", arg_47_1)
	Net:arena_query(arg_47_1, arg_47_2, {
		content_type = "application/json",
		retry = 2,
		uri = var_47_0,
		callback = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
			if arg_48_3 == 0 then
				if arg_47_3.on_success then
					arg_47_3.on_success(json.decode(arg_48_0))
				end
			elseif arg_47_3.on_fail then
				arg_47_3.on_fail()
			end
		end
	})
end

function WebEventPopUp.queryRedDot(arg_49_0, arg_49_1)
	if ContentDisable:byAlias("event_ui_red_dot_api_use") then
		return 
	end
	
	if ContentDisable:byAlias("event_ui") then
		return 
	end
	
	if arg_49_0.red_dot_request_count and arg_49_0.red_dot_request_count >= 1 then
		return 
	end
	
	local var_49_0 = arg_49_0:getURLWithParams(arg_49_1)
	
	if not var_49_0 or table.empty(var_49_0.eventurllist) then
		if arg_49_1 then
			arg_49_0:callback_reddot({
				resultbody = {
					isshowreddot = 0
				}
			})
		end
		
		return 
	end
	
	arg_49_0.red_dot_request_count = arg_49_0.red_dot_request_count or 0
	arg_49_0.red_dot_request_count = arg_49_0.red_dot_request_count + 1
	
	arg_49_0:webevent_query("/ingame/redDot", {
		nicknameno = var_49_0.nicknameno,
		worldid = var_49_0.worldid,
		totalyn = var_49_0.totalyn,
		eventurllist = var_49_0.eventurllist
	}, {
		on_success = function(arg_50_0)
			if DEBUG.SLOW_DIRECT_QUERY then
				SysAction:Add(SEQ(DELAY(DEBUG.SLOW_DIRECT_QUERY), CALL(function()
					if arg_49_0.callback_reddot then
						arg_49_0:callback_reddot(arg_50_0)
					end
				end)), {})
			else
				arg_49_0:callback_reddot(arg_50_0)
			end
		end,
		on_fail = function()
		end
	})
end

local function var_0_0(arg_53_0)
	if ContentDisable:byAlias("event_user_custom") then
		return false
	end
	
	local var_53_0 = string.split(arg_53_0.custom_event_id, ",")
	local var_53_1 = 0
	
	for iter_53_0, iter_53_1 in pairs(var_53_0 or {}) do
		for iter_53_2, iter_53_3 in pairs(AccountData.custom_web_event_issued_list or {}) do
			if to_n(iter_53_3.event_id) == to_n(iter_53_1) then
				var_53_1 = var_53_1 + 1
			end
		end
	end
	
	return var_53_1 > 0
end

function WebEventPopUp.getEventUrlList(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0.web_event_data and arg_54_0.web_event_data.notice_event_list or arg_54_0:updateData().web_event.notice_event_list
	local var_54_1 = {}
	local var_54_2 = arg_54_0:_getApiURI()
	local var_54_3 = os.time()
	
	for iter_54_0, iter_54_1 in pairs(var_54_0 or {}) do
		local var_54_4 = true
		
		for iter_54_2, iter_54_3 in pairs(arg_54_1) do
			var_54_4 = iter_54_1[iter_54_2] == iter_54_3
			
			if not var_54_4 then
				break
			end
		end
		
		if iter_54_1.is_intelli == "y" then
			var_54_4 = var_54_4 and var_0_0(iter_54_1)
		end
		
		if var_54_3 < iter_54_1.start_time or var_54_3 > iter_54_1.end_time then
			var_54_4 = false
		end
		
		if var_54_4 then
			local var_54_5 = (string.split(iter_54_1.link, var_54_2) or {})[2]
			
			if var_54_5 and (arg_54_2 or not arg_54_0:isReddotShowed(var_54_5) and not arg_54_0:isAlreadyTouched(var_54_5)) then
				table.push(var_54_1, var_54_5)
			end
		end
	end
	
	return var_54_1
end

function WebEventPopUp.initEventListView(arg_55_0)
	if not get_cocos_refid(arg_55_0.vars.wnd) then
		return 
	end
	
	local function var_55_0()
		local var_56_0 = {
			is_category = "total",
			priority = 0,
			["display_" .. getUserLanguage()] = T("event_ui_summary")
		}
		local var_56_1 = {}
		
		table.insert(var_56_1, var_56_0)
		
		local var_56_2 = arg_55_0.web_event_data and arg_55_0.web_event_data.notice_event_list or arg_55_0:updateData().web_event.notice_event_list
		
		for iter_56_0, iter_56_1 in pairs(var_56_2 or {}) do
			local var_56_3 = os.time()
			local var_56_4 = string.split(iter_56_1.link or "", "://")
			
			if var_56_4[1] == "epic7" then
				local var_56_5 = string.split(var_56_4[2], "=")[2]
				
				if EventMissionUtil:getEventTicket(var_56_5) then
					iter_56_1.event_mission = var_56_5
					
					table.insert(var_56_1, iter_56_1)
					
					if not arg_55_0.vars.event_mission_priority or arg_55_0.vars.event_mission_priority > iter_56_1.priority then
						arg_55_0.vars.event_mission_priority = iter_56_1.priority
					end
				end
			elseif var_56_3 >= iter_56_1.start_time and var_56_3 <= iter_56_1.end_time then
				if iter_56_1.is_intelli == "y" then
					if var_0_0(iter_56_1) then
						table.insert(var_56_1, iter_56_1)
					end
				else
					table.insert(var_56_1, iter_56_1)
				end
			end
		end
		
		if arg_55_0.vars.event_mission_priority then
			local var_56_6 = {
				is_category = "y",
				priority = arg_55_0.vars.event_mission_priority - 1,
				["display_" .. getUserLanguage()] = T("em_category_title_0")
			}
			
			table.insert(var_56_1, var_56_6)
		end
		
		table.sort(var_56_1, function(arg_57_0, arg_57_1)
			return (arg_57_0 and arg_57_0.priority and to_n(arg_57_0.priority) or 0) < (arg_57_1 and arg_57_1.priority and to_n(arg_57_1.priority) or 0)
		end)
		arg_55_0.vars.itemView:setDataSource(var_56_1)
		
		local var_56_7 = 1
		
		for iter_56_2, iter_56_3 in pairs(var_56_1) do
			if iter_56_3.is_category == "y" then
			elseif iter_56_3.event_mission and iter_56_3.event_mission == arg_55_0.vars.show_params.event_mission then
				var_56_7 = iter_56_2
				
				break
			elseif arg_55_0.vars.show_params.custom_event_id then
				local var_56_8 = string.split(iter_56_3.custom_event_id, ",")
				local var_56_9 = false
				
				for iter_56_4, iter_56_5 in pairs(var_56_8 or {}) do
					if to_n(arg_55_0.vars.show_params.custom_event_id) == to_n(iter_56_5) then
						var_56_9 = true
						
						break
					end
				end
				
				if var_56_9 then
					var_56_7 = iter_56_2
					
					break
				end
			end
		end
		
		arg_55_0.vars.selected_event = var_56_1[var_56_7]
		arg_55_0.vars.selected_event_node = arg_55_0.vars.itemView:getChildren()[var_56_7]
		
		arg_55_0.vars.itemView:jumpToIndex(var_56_7)
	end
	
	if arg_55_0.vars.itemView then
		arg_55_0.vars.itemView:removeAllChildren()
		var_55_0()
		
		return 
	end
	
	arg_55_0.vars.itemView = ItemListView_v2:bindControl(arg_55_0.vars.wnd:getChildByName("n_listview"))
	
	local var_55_1 = load_control("wnd/lobby_integrated_s_bar.csb")
	
	if arg_55_0.vars.itemView.STRETCH_INFO then
		local var_55_2 = arg_55_0.vars.itemView:getContentSize()
		
		resetControlPosAndSize(var_55_1, var_55_2.width, arg_55_0.vars.itemView.STRETCH_INFO.width_prev)
	end
	
	local var_55_3 = {
		onUpdate = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
			if not get_cocos_refid(arg_58_1) then
				return 
			end
			
			local var_58_0
			
			if arg_58_3.is_category == "total" then
				var_58_0 = arg_58_1:getChildByName("n_info_event")
			elseif arg_58_3.is_category == "y" then
				var_58_0 = arg_58_1:getChildByName("n_category")
			elseif arg_58_3.is_category == "n" then
				var_58_0 = arg_58_1:getChildByName("n_content")
			end
			
			local var_58_1 = arg_58_3.event_mission ~= nil
			
			if_set_visible(arg_58_1, "n_event_7days", var_58_1)
			if_set_visible(var_58_0, "n_select", arg_55_0.vars.selected_event["display_" .. getUserLanguage()] == arg_58_3["display_" .. getUserLanguage()])
			if_set_visible(var_58_0, nil, true)
			if_set(var_58_0, "txt_title", string.gsub(arg_58_3["display_" .. getUserLanguage()] or "", "\\n", "\n"))
			if_set(var_58_0, "txt_title_s", string.gsub(arg_58_3["display_" .. getUserLanguage()] or "", "\\n", "\n"))
			
			local var_58_2 = os.time()
			
			if var_58_2 >= to_n(arg_58_3.ticker_start_time) and var_58_2 <= to_n(arg_58_3.ticker_end_time) then
				if_set_visible(arg_58_1, "icon_new", arg_58_3.show_ticker == "y")
			end
			
			for iter_58_0, iter_58_1 in pairs(arg_55_0:updateData().red_dots or {}) do
				if string.find(arg_58_3.link or "", iter_58_0) then
					local var_58_3 = to_n(iter_58_1) == 1 and not arg_55_0:isAlreadyTouched(iter_58_0) and arg_58_3.show_reddot == "y"
					
					if_set_visible(arg_58_1, "icon_noti", var_58_3)
					
					if var_58_3 then
						arg_55_0:setReddotShowed(iter_58_0)
					end
					
					break
				end
			end
			
			if var_58_1 then
				if_set_visible(arg_58_1, "icon_noti", EventMissionUtil:isShowRedDotEvent(arg_58_3.event_mission) and not arg_55_0:isAlreadyTouched(arg_58_3.event_mission))
			end
			
			arg_58_3.node = arg_58_1
			arg_58_1.data = arg_58_3
			
			return arg_58_3["display_" .. getUserLanguage()]
		end
	}
	
	arg_55_0.vars.itemView:setRenderer(var_55_1, var_55_3)
	arg_55_0.vars.itemView:removeAllChildren()
	var_55_0()
end

copy_functions(ScrollView, WebEventPopUp)

function WebEventPopUp.initBannerScrollView(arg_59_0)
	if not get_cocos_refid(arg_59_0.vars.wnd) then
		return 
	end
	
	local var_59_0 = arg_59_0.vars.wnd:getChildByName("scrollview")
	
	arg_59_0:initScrollView(var_59_0, 892, 184)
	
	local var_59_1 = {}
	local var_59_2 = arg_59_0:updateData().web_event.notice_event_banner
	
	for iter_59_0, iter_59_1 in pairs(var_59_2) do
		local var_59_3 = os.time()
		
		if var_59_3 >= iter_59_1.start_time and var_59_3 <= iter_59_1.end_time then
			local var_59_4 = string.find(iter_59_1.platform, "all")
			local var_59_5 = string.find(iter_59_1.platform, PLATFORM)
			
			if var_59_4 or var_59_5 then
				local var_59_6 = iter_59_1["link_" .. getUserLanguage()]
				
				if var_59_6 and var_59_6 ~= "" and (not IS_ANDROID_PC or not string.find(var_59_6, "showRewardedVideo")) then
					table.insert(var_59_1, iter_59_1)
				end
			end
		end
	end
	
	table.sort(var_59_1, function(arg_60_0, arg_60_1)
		return (arg_60_0 and arg_60_0.priority and to_n(arg_60_0.priority) or 0) < (arg_60_1 and arg_60_1.priority and to_n(arg_60_1.priority) or 0)
	end)
	arg_59_0:createScrollViewItems(var_59_1)
	
	arg_59_0.vars.scrollview = var_59_0
end

function WebEventPopUp.getScrollViewItem(arg_61_0, arg_61_1)
	local var_61_0 = os.time()
	local var_61_1 = load_dlg("lobby_integrated_s_card", true, "wnd")
	
	if not get_cocos_refid(var_61_1) then
		return 
	end
	
	local var_61_2 = cc.Sprite:create(arg_61_1["img_" .. getUserLanguage()])
	
	if var_61_2 and get_cocos_refid(var_61_2) then
		var_61_2:setAnchorPoint(0, 0)
		var_61_1:getChildByName("img_banner"):addChild(var_61_2)
	end
	
	local var_61_3 = arg_61_1.end_time - var_61_0
	local var_61_4
	
	if var_61_3 <= 3600 then
		var_61_4 = "event_ui_time_left_3"
	elseif var_61_3 <= 86400 then
		var_61_4 = "event_ui_time_left_2"
	elseif var_61_3 > 86400 then
		var_61_4 = "event_ui_time_left"
	end
	
	local var_61_5 = to_n(timeToStringDef({
		remain_time_with_day = arg_61_1.end_time - var_61_0
	}).day)
	
	if_set(var_61_1, "txt_date", T(var_61_4, timeToStringDef({
		remain_time_with_day = arg_61_1.end_time - var_61_0
	})))
	if_set_visible(var_61_1, "n_time", arg_61_1.show_date == "y")
	if_set(var_61_1, "txt_period", T("event_ui_date", timeToStringDef({
		preceding_with_zeros = true,
		start_time = arg_61_1.start_time,
		end_time = arg_61_1.end_time
	})))
	
	local var_61_6 = os.time()
	
	if_set_visible(var_61_1, "txt_date", arg_61_1.show_date == "y")
	if_set_color(var_61_1, "txt_date", var_61_5 >= 1 and tocolor("#ab8759") or tocolor("#8bdb41"))
	if_set_visible(var_61_1, "txt_period", arg_61_1.show_date == "y")
	if_set_visible(var_61_1, "icon_new", arg_61_1.show_ticker == "y" and var_61_6 >= arg_61_1.ticker_start_time and var_61_6 <= arg_61_1.ticker_end_time)
	if_set_visible(var_61_1, "img_banner", true)
	
	var_61_1:getChildByName("btn_banner").data = arg_61_1
	
	return var_61_1
end

function WebEventPopUp.getURLWithParams(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_0:_getApiURI()
	local var_62_1 = {}
	
	if arg_62_1 then
		var_62_1 = arg_62_0:getEventUrlList({
			is_intelli = "n",
			show_reddot = "y"
		}, true)
	else
		var_62_1 = arg_62_0:getEventUrlList({
			show_reddot = "y"
		})
	end
	
	local var_62_2 = "world_" .. Login:getRegion()
	
	if Stove.enable then
		var_62_2 = var_62_2 .. Stove.vars.stove_qa_world_postfix
	end
	
	return {
		url = var_62_0,
		worldid = var_62_2,
		eventurllist = var_62_1,
		totalyn = not arg_62_1 and "N" or "Y",
		nicknameno = tonumber(Stove:getNickNameNo()) or 0
	}
end

function WebEventPopUp.show(arg_63_0, arg_63_1)
	if IS_PUBLISHER_ZLONG then
		return 
	end
	
	if arg_63_0:isShow() then
		return 
	end
	
	arg_63_1 = arg_63_1 or {}
	arg_63_0.vars = {}
	arg_63_0.vars.show_params = arg_63_1
	
	if arg_63_1.event_mission then
		if not EventMissionUtil:isActiveEvent(arg_63_1.event_mission) then
			EventMissionUtil:popupEventEnd(arg_63_1.event_mission)
			
			return 
		end
		
		arg_63_0:setAlreadyTouched(arg_63_1.event_mission)
	end
	
	BackButtonManager:push({
		check_id = "WebEventPopUp",
		back_func = function()
			arg_63_0:close()
		end
	})
	
	local var_63_0 = SceneManager:getRunningPopupScene()
	
	arg_63_0:initUI(var_63_0)
	arg_63_0:queryRedDot()
	TopBarNew:hideEventBalloon()
end

function WebEventPopUp.set_bi_data(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_65_0:show()
	
	local var_65_0 = getChildByPath(arg_65_0.vars.wnd, "n_event_7days")
	
	if not get_cocos_refid(var_65_0) then
		return 
	end
	
	EventMissionView:open(var_65_0, arg_65_1)
	arg_65_0:showEventMissionView(true)
	
	local var_65_1 = var_65_0:getChildByName("n_bi")
	
	var_65_1:setScale(arg_65_2)
	var_65_1:setPosition(arg_65_3, arg_65_4)
end

WebEventNoti = WebEventNoti or {}

function WebEventNoti.onUpdateUI(arg_66_0)
	WebEventPopUp:updateUI()
end

function WebEventNoti.isShowRedDot(arg_67_0)
	if ContentDisable:byAlias("disable_lobby_event_reddot") then
		return false
	end
	
	if WebEventPopUp:isShowMainBtnRedDot() then
		return true
	end
	
	if EventMissionUtil:isShowRedDot() then
		return true
	end
	
	local var_67_0 = WebEventPopUp:getEventInfo("red_dots")
	
	if var_67_0 and to_n(var_67_0.isshowreddot or "0") == 1 then
		return true
	end
	
	return false
end

function WebEventNoti.reqDisplayFlag(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	if not IS_PUBLISHER_STOVE then
		return 
	end
	
	if not arg_68_0.custom_wev_display_flag then
		arg_68_0.custom_wev_display_flag = {}
	end
	
	if not arg_68_0.custom_wev_display_flag[arg_68_1] then
		arg_68_0.custom_wev_display_flag[arg_68_1] = -1
		
		WebEventPopUp:webevent_query(arg_68_2, {
			nickname_no = tonumber(Stove:getNickNameNo()),
			world_id = "world_" .. Login:getRegion()
		}, {
			on_success = function(arg_69_0)
				local var_69_0 = arg_69_0.resultBody
				
				if not var_69_0 then
					return 
				end
				
				arg_68_0.custom_wev_display_flag[arg_68_1] = var_69_0.display_flag
				
				if type(arg_68_3) == "function" then
					arg_68_3(var_69_0.display_flag)
				end
			end
		})
	end
end

function WebEventNoti.getDisplayFlag(arg_70_0, arg_70_1)
	if not arg_70_0.custom_wev_display_flag then
		return 
	end
	
	return arg_70_0.custom_wev_display_flag[arg_70_1]
end

function WebEventNoti.resetDisplayFlag(arg_71_0)
	arg_71_0.custom_wev_display_flag = nil
end
