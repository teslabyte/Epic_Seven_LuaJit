function MsgHandler.get_recommend_clan_list(arg_1_0)
	ClanRecommend:update_recommend_list(arg_1_0.clans, true)
	ClanJoin:setInputString("")
end

function MsgHandler.clan_search_tag(arg_2_0)
	ClanRecommend:update_recommend_list(arg_2_0.clans, true)
	ClanJoin:setInputString("")
end

function MsgHandler.search_clan_list(arg_3_0)
	ClanRecommend:update_recommend_list(arg_3_0.clans)
end

function MsgHandler.clan_create(arg_4_0)
	Account:setClanId(arg_4_0.clan_id)
	ClanJoin:closeCreatePopup()
	ClanBase:close()
	ClanJoin:close()
	ClanBase:show(nil, {
		no_sound_eff = true
	})
	SoundEngine:play("event:/ui/clan_congratulation")
	
	if arg_4_0.tag_info then
		ClanTag:setTagInfo(arg_4_0.tag_info)
	end
	
	balloon_message_with_sound("clan_create_success_msg")
	Account:updateCurrencies(arg_4_0)
	TopBarNew:topbarUpdate(true)
end

function MsgHandler.clan_join_request(arg_5_0)
	if arg_5_0.err_msg then
		balloon_message_with_sound(arg_5_0.err_msg)
		
		return 
	end
	
	if arg_5_0.clan_name then
		balloon_message_with_sound("clan_join_request_success", {
			clan_name = arg_5_0.clan_name
		})
	end
	
	ClanJoin:updateJoinLimitTime()
	ClanInfo:setInactiveJoinBtn()
end

function ErrHandler.clan_join_request(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 then
		return 
	end
	
	if arg_6_1 == "more_words" then
		balloon_message_with_sound("lack_clan_join_request_msg_length")
	elseif arg_6_1 == "too_long" then
		balloon_message_with_sound("clan_join_request.too_long")
	end
end

function MsgHandler.clan_auto_join(arg_7_0)
	Account:setClanId(arg_7_0.clan_id)
	
	if SceneManager:getCurrentSceneName() == "clan" then
		ClanBase:close()
		ClanJoin:close()
		Dialog:close("cm_preview_clan")
		ClanBase:show(nil, {
			no_sound_eff = true
		})
		SoundEngine:play("event:/ui/clan_congratulation")
	else
		local var_7_0 = Dialog:msgBox(T("msg_clan_auto_join_approval"))
		
		if get_cocos_refid(var_7_0) then
			var_7_0:bringToFront()
		end
		
		ClanInfo:setInactiveJoinBtn(true)
	end
end

function MsgHandler.clan_invited_accept(arg_8_0)
	Account:setClanId(arg_8_0.clan_id)
	Dialog:close("cm_preview_clan")
	ClanBase:close()
	ClanJoin:close()
	ClanBase:show(nil, {
		no_sound_eff = true
	})
	SoundEngine:play("event:/ui/clan_congratulation")
end

function MsgHandler.clan_join(arg_9_0)
	Account:setClanId(arg_9_0.clan_id)
	Dialog:close("cm_preview_clan")
	ClanBase:close()
	ClanJoin:close()
	ClanBase:show(nil, {
		no_sound_eff = true
	})
	SoundEngine:play("event:/ui/clan_congratulation")
end

function MsgHandler.get_clan_info_has_not(arg_10_0)
	if arg_10_0.invited_clans then
		ClanInvitation:setInvitedClans(arg_10_0.invited_clans)
	end
	
	if arg_10_0.clan_leave_penalty then
		Account:setClanLeavePenalty(arg_10_0.clan_leave_penalty)
	end
	
	if arg_10_0.clan_leave_time then
		Account:setClanLeaveTime(arg_10_0.clan_leave_time)
	end
	
	ClanJoin:updateNotifier()
	ClanJoin:updateJoinLimitTime()
	Clan:resetTeams()
end

function MsgHandler.clan_all_deny_invitation(arg_11_0)
	ClanInvitation:setInvitedClans({})
	ClanJoin:updateNotifier()
end

function HANDLER.clan_join_base(arg_12_0, arg_12_1)
	if arg_12_1 == "btn_recommend" then
		ClanRecommend:refresh()
		
		return 
	end
	
	if arg_12_1 == "btn_inputbg" then
		if ClanJoin and ClanJoin.vars and get_cocos_refid(ClanJoin.vars.wnd) then
			ClanJoin.vars.wnd:getChildByName("txt_input"):setTextColor(cc.c3b(107, 101, 27))
			ClanJoin.vars.wnd:getChildByName("txt_input"):setCursorEnabled(true)
		end
		
		return 
	end
	
	if arg_12_1 == "btn_sorting" then
		ClanJoin:setVisibleSearchTypeBox(true)
		
		return 
	end
	
	if arg_12_1 == "btn_sel_close" then
		ClanJoin:setVisibleSearchTypeBox(false)
		
		return 
	end
	
	if arg_12_1 == "btn_search" then
		ClanJoin:search()
		cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
		
		return 
	end
	
	if arg_12_1 == "btn_open_search" then
		ClanJoin:visibleSearchPopup(true)
		
		return 
	end
	
	if arg_12_1 == "btn_close_search" then
		ClanJoin:visibleSearchPopup(false)
		
		return 
	end
	
	if arg_12_1 == "btn_make" then
		ClanJoin:showClanCreatePopup()
		
		return 
	end
	
	if arg_12_1 == "btn_invite" then
		if #ClanInvitation:getInvitedClans() <= 0 then
			balloon_message_with_sound("has_not_invitation_from_clan")
		else
			ClanInvitation:show()
		end
		
		return 
	end
	
	if arg_12_1 == "btn_tag" then
		ClanTag:onTagSearch()
		
		return 
	end
	
	if arg_12_1 == "btn_knights_recruitment" then
		ClanJoin:showPromoteBoard()
		
		return 
	end
end

function HANDLER.clan_recommend_item(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_info" then
		if arg_13_0.mode == "invitation" then
			Clan:queryPreview(ClanInvitation:getBtnItemClanID(arg_13_0), arg_13_0.mode)
		else
			Clan:queryPreview(ClanRecommend:getScrollItem(arg_13_0).clan_id, arg_13_0.mode)
		end
	end
end

function HANDLER.clan_create(arg_14_0, arg_14_1)
	if arg_14_1 == "btn_emblem" then
		ClanEmblem:show()
	end
	
	if arg_14_1 == "btn_bg" then
		if not ClanEmblemBG:isOpenSystem() then
			balloon_message_with_sound("notyet_dev")
			
			return 
		end
		
		ClanEmblemBG:show()
		
		return 
	end
	
	if arg_14_1 == "btn_close" or arg_14_1 == "btn_cancel" then
		ClanJoin:closeCreatePopup()
		
		return 
	end
	
	if arg_14_1 == "btn_ok" then
		ClanJoin:onCreateClan()
		
		return 
	end
	
	if string.starts(arg_14_1, "sort") then
		ClanJoin:updateCreatePopupSel(arg_14_0)
		arg_14_0:getParent():setVisible(false)
		
		return 
	end
	
	if arg_14_1 == "btn_select" then
		local var_14_0 = arg_14_0:getParent():getName()
		
		ClanJoin:openCreatePopupSel(var_14_0)
		
		return 
	end
	
	if arg_14_1 == "btn_sel_close" then
		arg_14_0:getParent():setVisible(false)
		
		return 
	end
	
	if arg_14_1 == "btn_no_tag" or arg_14_1 == "btn_tag1" or arg_14_1 == "btn_tag2" then
		local var_14_1 = ClanJoin:getCreatePopupTagListNode()
		
		ClanTagListUI:show(var_14_1)
		
		return 
	end
end

function HANDLER.clan_invited(arg_15_0, arg_15_1)
	if arg_15_1 == "btn_close" then
		Dialog:close("clan_invited")
	end
	
	if arg_15_1 == "btn_del" then
		ClanInvitation:allDenyInvitation()
		Dialog:close("clan_invited")
	end
end

function HANDLER.clan_join_info_p(arg_16_0, arg_16_1)
	if arg_16_1 == "btn_close" then
		Dialog:close("clan_join_info_p")
	end
end

ClanJoin = {}

function ClanJoin.isShowClanPromotionButton(arg_17_0)
	if IS_PUBLISHER_ZLONG then
		return false
	end
	
	if ContentDisable:byAlias("clan_promote") then
		return false
	end
	
	return true
end

function ClanJoin.show(arg_18_0, arg_18_1)
	arg_18_0.vars = {}
	
	local var_18_0 = load_dlg("clan_join_base", true, "wnd")
	
	if_set_visible(var_18_0, "n_search_none", false)
	if_set_visible(var_18_0, "bg_cnt", false)
	
	arg_18_0.vars.wnd = var_18_0
	
	arg_18_0:setVisibleSearchTypeBox(false)
	arg_18_0:visibleSearchPopup(false)
	
	arg_18_0.vars.clan_create_price = GAME_STATIC_VARIABLE.clan_open_price
	
	if_set(var_18_0, "cost", comma_value(arg_18_0.vars.clan_create_price))
	
	local var_18_1 = DB("item_token", GAME_STATIC_VARIABLE.clan_open_token, {
		"icon"
	})
	
	if_set_sprite(var_18_0, "icon_res", "item/" .. var_18_1 .. ".png")
	arg_18_0:updateJoinLimitTime()
	UIUtil:getRewardIcon(nil, GAME_STATIC_VARIABLE.clan_activity_reward_1, {
		parent = arg_18_0.vars.wnd:getChildByName("reward_item1")
	})
	UIUtil:getRewardIcon(nil, GAME_STATIC_VARIABLE.clan_activity_reward_2, {
		parent = arg_18_0.vars.wnd:getChildByName("reward_item2")
	})
	UIUtil:getRewardIcon(nil, GAME_STATIC_VARIABLE.clan_activity_reward_3, {
		parent = arg_18_0.vars.wnd:getChildByName("reward_item3")
	})
	UIUtil:getRewardIcon(nil, GAME_STATIC_VARIABLE.clan_activity_reward_4, {
		parent = arg_18_0.vars.wnd:getChildByName("reward_item4")
	})
	arg_18_0.vars.wnd:getChildByName("txt_input"):setTextColor(cc.c3b(107, 101, 27))
	arg_18_0.vars.wnd:getChildByName("txt_input"):setCursorEnabled(true)
	
	local var_18_2 = arg_18_0:isShowClanPromotionButton()
	
	if_set_visible(arg_18_0.vars.wnd, "btn_knights_recruitment", var_18_2)
	
	if var_18_2 then
		if_set_position_x(arg_18_0.vars.wnd, "n_knights", arg_18_0.vars.wnd:getChildByName("n_move_knights"):getPositionX())
	end
	
	Scheduler:addSlow(arg_18_0.vars.wnd, arg_18_0.updateJoinLimitTime, arg_18_0)
	
	return var_18_0
end

function ClanJoin.isShow(arg_19_0)
	if not arg_19_0.vars then
		return false
	end
	
	if not arg_19_0.vars.wnd then
		return false
	end
	
	if not get_cocos_refid(arg_19_0.vars.wnd) then
		return false
	end
	
	return true
end

function ClanJoin.toogleActiveTagSearchButton(arg_20_0, arg_20_1)
	if not arg_20_0.vars then
		return false
	end
	
	if not arg_20_0.vars.wnd then
		return false
	end
	
	if not get_cocos_refid(arg_20_0.vars.wnd) then
		return false
	end
	
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("btn_tag")
	local var_20_1 = arg_20_0.vars.wnd:getChildByName("btn_tag_active")
	
	if get_cocos_refid(var_20_0) and get_cocos_refid(var_20_1) then
		var_20_0:setVisible(not arg_20_1)
		var_20_1:setVisible(arg_20_1)
	end
end

function ClanJoin.visibleSearchPopup(arg_21_0, arg_21_1)
	if_set_visible(arg_21_0.vars.wnd, "layer_search", arg_21_1)
end

function ClanJoin.updateJoinLimitTime(arg_22_0)
	if not arg_22_0.vars or not arg_22_0.vars.wnd or not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	local var_22_0 = Account:getClanLeavePenalty() or 0
	
	if_set_visible(arg_22_0.vars.wnd, "n_join_limit", var_22_0 > 0)
	
	if (Account:getClanLeavePenalty() or 0) > 0 then
		local var_22_1 = Account:getClanLeaveTime() + var_22_0 * 24 * 60 * 60
		
		if var_22_1 - os.time() < 0 then
			if_set_visible(arg_22_0.vars.wnd, "n_join_limit", false)
		else
			if_set(arg_22_0.vars.wnd, "join_limit_label", sec_to_full_string(var_22_1 - os.time()))
		end
	end
end

function ClanJoin.updateNotifier(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if not arg_23_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_23_0.vars.wnd, "bg_cnt", #ClanInvitation:getInvitedClans() > 0)
	if_set(arg_23_0.vars.wnd, "invited_cnt", #ClanInvitation:getInvitedClans())
end

function ClanJoin.setVisibleSearchTypeBox(arg_24_0, arg_24_1)
	if_set_visible(arg_24_0.vars.wnd, "layer_sel", arg_24_1)
end

function ClanJoin.setInputString(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.vars.wnd:getChildByName("txt_input")
	
	if var_25_0 then
		var_25_0:setString(arg_25_1)
	end
end

function ClanJoin.search(arg_26_0)
	local var_26_0 = arg_26_0.vars.wnd:getChildByName("txt_input"):getString()
	
	if var_26_0 == nil or utf8len(var_26_0) < 2 then
		balloon_message_with_sound("search_two_words")
		
		return 
	end
	
	ClanRecommend:clearFilter()
	query("search_clan_list", {
		clan_name = var_26_0
	})
end

function ClanJoin.close(arg_27_0)
	arg_27_0.vars = nil
end

function ClanJoin.updateTagClanCreatePopup(arg_28_0, arg_28_1)
	if not arg_28_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_28_0.vars.create_popup_wnd) then
		return 
	end
	
	arg_28_0.vars.update_list.tags = arg_28_1
	
	local var_28_0 = #arg_28_0.vars.update_list.tags
	local var_28_1 = arg_28_0.vars.create_popup_wnd:getChildByName("btn_tag1")
	local var_28_2 = arg_28_0.vars.create_popup_wnd:getChildByName("btn_tag2")
	
	ClanTag:updateUISelectAbleTag(arg_28_0.vars.create_popup_wnd, arg_28_0.vars.update_list.tags)
end

function ClanJoin.showClanCreatePopup(arg_29_0, arg_29_1)
	local var_29_0 = Dialog:open("wnd/clan_create", arg_29_0, {
		use_backbutton = true,
		back_func = function()
			arg_29_0:closeCreatePopup()
		end
	})
	
	arg_29_1 = arg_29_1 or SceneManager:getDefaultLayer()
	arg_29_0.vars.create_popup_wnd = var_29_0
	
	arg_29_1:addChild(var_29_0)
	
	arg_29_0.vars.update_list = {}
	arg_29_0.vars.update_list.emblem = GAME_STATIC_VARIABLE.emblem_default_id
	arg_29_0.vars.update_list.emblem_bg = GAME_STATIC_VARIABLE.emblem_bg_default_id
	arg_29_0.vars.update_list.join_type = 1
	arg_29_0.vars.update_list.rank_limit = 0
	arg_29_0.vars.update_list.intro_msg = ""
	arg_29_0.vars.update_list.clan_name = ""
	arg_29_0.vars.update_list.tags = {}
	
	UIUtil:updateClanInfo(arg_29_0.vars.create_popup_wnd, arg_29_0.vars.update_list, {
		no_progress = true
	})
	
	arg_29_0.vars.slider_node = arg_29_0.vars.create_popup_wnd:getChildByName("n_slider")
	arg_29_0.vars.slider = arg_29_0.vars.slider_node:getChildByName("slider")
	
	arg_29_0.vars.slider:addEventListener(Dialog.defaultSliderEventHandler)
	arg_29_0.vars.slider:setPercent(0)
	arg_29_0.vars.slider_node:getChildByName("t_count"):setString(T("no_clan_rank_limit"))
	UIUtil:equalizeProgress(arg_29_0.vars.slider_node, {
		per = arg_29_0.vars.slider:getPercent()
	})
	
	function arg_29_0.vars.slider.handler(arg_31_0, arg_31_1, arg_31_2)
		if arg_31_2 == 0 then
			UIUtil:equalizeProgress(arg_29_0.vars.slider_node, {
				per = arg_29_0.vars.slider:getPercent()
			})
			
			local var_31_0 = arg_29_0.vars.slider_node:getChildByName("t_count")
			local var_31_1 = math.ceil(arg_29_0.vars.slider:getPercent() / 100 * (GAME_STATIC_VARIABLE.max_account_level - GAME_CONTENT_VARIABLE.clan_invite_req_rank))
			
			if var_31_1 > 0 then
				var_31_0:setString(T("rank_count_over_limit", {
					rank = var_31_1 + GAME_CONTENT_VARIABLE.clan_invite_req_rank
				}))
			else
				var_31_0:setString(T("no_clan_rank_limit"))
			end
			
			if var_31_1 == 0 then
				arg_29_0.vars.update_list.rank_limit = 0
			else
				arg_29_0.vars.update_list.rank_limit = var_31_1 + GAME_CONTENT_VARIABLE.clan_invite_req_rank
			end
		end
	end
	
	local var_29_1 = DB("item_token", GAME_STATIC_VARIABLE.clan_open_token, {
		"icon"
	})
	
	if_set_sprite(var_29_0, "icon_res", "item/" .. var_29_1 .. ".png")
	if_set(var_29_0, "cost", comma_value(GAME_STATIC_VARIABLE.clan_open_price))
	arg_29_0.vars.create_popup_wnd:getChildByName("txt_name_input"):setCursorEnabled(true)
	arg_29_0.vars.create_popup_wnd:getChildByName("txt_name_input"):setTextColor(cc.c3b(107, 101, 27))
	arg_29_0.vars.create_popup_wnd:getChildByName("txt_info_input"):setCursorEnabled(true)
	arg_29_0.vars.create_popup_wnd:getChildByName("txt_info_input"):setTextColor(cc.c3b(107, 101, 27))
	
	arg_29_0.vars.sorter = Sorter:create(var_29_0:getChildByName("n_sorting"), {
		csb_file = "wnd/sorting_1.csb",
		bg_width_x = 334
	})
	
	arg_29_0.vars.sorter:setSorter({
		default_sort_index = 1,
		menus = {
			{
				name = T("ui_clan_create_type1")
			},
			{
				name = T("ui_clan_create_type2")
			},
			{
				name = T("ui_clan_create_type3")
			}
		},
		callback_sort = function(arg_32_0, arg_32_1)
			arg_29_0:updateCreatePopupSel(arg_32_1)
		end
	})
	arg_29_0.vars.sorter:sort()
	arg_29_0.vars.sorter:setTextFitWidth(270)
	arg_29_0:updateCreatePopupSelUI()
	
	if not ClanEmblemBG:isOpenSystem() then
		if_set_opacity(arg_29_0.vars.create_popup_wnd, "btn_bg", 76.5)
	end
	
	if_set_visible(arg_29_0.vars.create_popup_wnd, "btn_no_tag", true)
	if_set_visible(arg_29_0.vars.create_popup_wnd, "btn_tag1", false)
	if_set_visible(arg_29_0.vars.create_popup_wnd, "btn_tag2", false)
	SoundEngine:play("event:/ui/popup/tap")
end

function ClanJoin.closeCreatePopup(arg_33_0)
	ClanTag:removeUpdateTagList()
	BackButtonManager:pop("Dialog.clan_create")
	arg_33_0.vars.create_popup_wnd:removeFromParent()
end

function ClanJoin.openCreatePopupSel(arg_34_0, arg_34_1)
	if not string.starts(arg_34_1, "btn_sel") then
		return 
	end
	
	local var_34_0 = string.split(arg_34_1, "btn_sel")
	
	arg_34_0.vars.create_popup_wnd:getChildByName("layer_sel" .. var_34_0[2]):setVisible(true)
end

function ClanJoin.updateCreatePopupSelUI(arg_35_0, arg_35_1)
	arg_35_1 = arg_35_1 or arg_35_0.vars.update_list.join_type
	
	UIUtil:updateClanInfo(arg_35_0.vars.create_popup_wnd, arg_35_0.vars.update_list, {
		no_progress = true,
		no_emblem_update = true
	})
end

function ClanJoin.updateCreatePopupSel(arg_36_0, arg_36_1)
	arg_36_0.vars.update_list.join_type = arg_36_1
	
	arg_36_0:updateCreatePopupSelUI(arg_36_0.vars.update_list.join_type)
end

function ClanJoin.updateClanEmblem(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1 or {}
	
	if var_37_0.emblem then
		local var_37_1 = var_37_0.emblem
		local var_37_2 = DB("clan_emblem", tostring(var_37_1), "emblem")
		
		if_set_sprite(arg_37_0.vars.create_popup_wnd, "emblem", "emblem/" .. var_37_2 .. ".png")
		
		arg_37_0.vars.update_list.emblem = var_37_1
	end
end

function ClanJoin.updateClanEmblemBG(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_1 or {}
	
	if var_38_0.emblem_bg then
		local var_38_1 = var_38_0.emblem_bg
		local var_38_2 = DB("clan_emblem", tostring(var_38_1), "emblem")
		
		if_set_sprite(arg_38_0.vars.create_popup_wnd, "emblem_bg", "emblem/" .. var_38_2 .. ".png")
		if_set_visible(arg_38_0.vars.create_popup_wnd, "emblem_bg", true)
		
		arg_38_0.vars.update_list.emblem_bg = var_38_1
	end
end

function ClanJoin.showPromoteBoard(arg_39_0)
	Stove:openClanPromotionBoard()
end

function ClanJoin.getSelectedEmblem(arg_40_0)
	return arg_40_0.vars.update_list.emblem
end

function ClanJoin.getSelectedEmblemBG(arg_41_0)
	return arg_41_0.vars.update_list.emblem_bg
end

function ClanJoin.isCreatePopupShow(arg_42_0)
	return arg_42_0.vars and get_cocos_refid(arg_42_0.vars.create_popup_wnd) and arg_42_0.vars.create_popup_wnd:isVisible()
end

function ClanJoin.getTagListNode(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	return arg_43_0.vars.wnd:getChildByName("n_tag_list")
end

function ClanJoin.getCreatePopupTagListNode(arg_44_0)
	if not arg_44_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_44_0.vars.create_popup_wnd) then
		return 
	end
	
	return arg_44_0.vars.create_popup_wnd:getChildByName("n_tag_list")
end

function ClanJoin.onCreateClan(arg_45_0)
	local var_45_0 = string.sub(GAME_STATIC_VARIABLE.clan_open_token, 4, -1)
	
	if Account:getCurrency(var_45_0) < arg_45_0.vars.clan_create_price then
		balloon_message_with_sound("clan_create.no_token")
		
		return 
	end
	
	if not get_cocos_refid(arg_45_0.vars.create_popup_wnd) then
		return 
	end
	
	local var_45_1 = arg_45_0.vars.create_popup_wnd:getChildByName("txt_name_input"):getString()
	
	if var_45_1 == nil or utf8len(var_45_1) < 2 then
		balloon_message_with_sound("lack_clan_name_length")
		
		return 
	end
	
	if UIUtil:checkInvalidCharacter(var_45_1, nil, {
		msgbox = true
	}) then
		return 
	end
	
	if string.match(var_45_1, "%s") ~= nil then
		balloon_message_with_sound("cannot_use_space")
		
		return 
	end
	
	if check_abuse_filter(var_45_1, ABUSE_FILTER.NAME) then
		Dialog:msgBox(T("cant_use_character"), {
			title = T("invalid_character")
		})
		
		return 
	end
	
	local var_45_2 = arg_45_0.vars.create_popup_wnd:getChildByName("txt_info_input"):getString()
	
	if check_abuse_filter(var_45_2, ABUSE_FILTER.CHAT) then
		balloon_message_with_sound("invalid_input_word")
		
		return 
	end
	
	if var_45_2 == nil or utf8len(var_45_2) < 2 then
		balloon_message_with_sound("lack_clan_intro_msg_length")
		
		return 
	end
	
	arg_45_0.vars.update_list.clan_name = var_45_1
	arg_45_0.vars.update_list.intro_msg = var_45_2
	
	local var_45_3 = json.encode(arg_45_0.vars.update_list)
	
	query("clan_create", {
		update_list = var_45_3
	})
end

ClanRecommend = {}

copy_functions(ScrollView, ClanRecommend)

function ClanRecommend.create(arg_46_0, arg_46_1)
	arg_46_0.vars = {}
	arg_46_0.vars.parent = arg_46_1
	arg_46_0.vars.list = {}
	arg_46_0.vars.scrollview = arg_46_1:getChildByName("scrollview")
	
	arg_46_0:initScrollView(arg_46_0.vars.scrollview, 839, 175)
	
	arg_46_0.vars.sorter = Sorter:create(arg_46_1:getChildByName("n_sorting"), {
		bg_height = 53,
		icon_pos_diff_y = 4,
		csb_file = "wnd/sorting_1.csb",
		txt_cur_sort_pos_diff_y = 4
	})
	
	arg_46_0.vars.sorter:setVisibleIconOrder(false)
	arg_46_0.vars.sorter:setSorter({
		default_sort_index = SAVE:getKeep("clanjoin_type_sort", 0) + 1,
		menus = {
			{
				name = T("ui_clan_create_type4")
			},
			{
				name = T("ui_clan_create_type1")
			},
			{
				name = T("ui_clan_create_type2")
			}
		},
		callback_sort = function(arg_47_0, arg_47_1)
			local var_47_0 = SAVE:getKeep("clanjoin_type_sort", 0)
			
			SAVE:setKeep("clanjoin_type_sort", arg_47_1 - 1)
			
			if ClanRecommend:refresh() == false then
				arg_46_0.vars.sorter:sort(var_47_0 + 1, true)
			end
		end
	})
	arg_46_0.vars.sorter:sort()
end

function ClanRecommend.clearFilter(arg_48_0)
	SAVE:setKeep("clanjoin_type_sort", 0)
	ClanRecommend.vars.sorter:sort(1, true)
end

function ClanRecommend.update_recommend_list(arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_1 then
		return 
	end
	
	ClanRecommend.vars.list = arg_49_1
	
	local var_49_0 = arg_49_0.vars.parent:getChildByName("n_search_none")
	local var_49_1 = ClanRecommend.vars.list
	
	if #var_49_1 <= 0 then
		if_set_visible(var_49_0, nil, true)
		
		if arg_49_2 then
			if_set(var_49_0, "label", T("ui_clan_join_base_no_result1"))
		else
			if_set(var_49_0, "label", T("ui_clan_join_base_no_result"))
		end
	else
		if_set_visible(var_49_0, nil, false)
	end
	
	arg_49_0:createScrollViewItems(var_49_1)
	
	local var_49_2 = arg_49_0.vars.scrollview:getInnerContainerPosition()
	
	arg_49_0.vars.scrollview:setInnerContainerPosition({
		x = var_49_2.x,
		y = var_49_2.y - 5
	})
end

function ClanRecommend.request_join_clan(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0.ScrollViewItems[arg_50_1].item.clan_id
	
	if not var_50_0 then
		return 
	end
	
	if arg_50_2 == 1 then
		query("clan_auto_join", {
			clan_id = var_50_0
		})
	elseif arg_50_2 == 3 then
		Dialog:msgBox(T("clan_cant_join.secret"))
	else
		query("clan_join_request", {
			clan_id = var_50_0
		})
	end
end

function ClanRecommend.getScrollViewItem(arg_51_0, arg_51_1)
	local var_51_0 = load_dlg("clan_recommend_item", true, "wnd")
	
	UIUtil:updateClanInfo(var_51_0, arg_51_1)
	
	local var_51_1 = var_51_0:getChildByName("btn_info")
	
	var_51_1.scroll_index = #arg_51_0.ScrollViewItems + 1
	var_51_1.mode = "recommend"
	arg_51_1.intro_msg = arg_51_1.intro_msg or ""
	
	local var_51_2 = ClanTag:getTagListByTagInfoIncludeTempInfo(arg_51_1.tags, arg_51_1)
	
	ClanTag:updateUIRecommendItemTag(var_51_0, var_51_2)
	
	local var_51_3 = var_51_0:getChildByName("talk_small_bg")
	local var_51_4 = var_51_0:getChildByName("clan_info_msg")
	
	UIUserData:proc(var_51_3)
	
	local var_51_5 = 900
	
	set_ellipsis_label(var_51_4, arg_51_1.intro_msg, var_51_5, 10)
	
	return var_51_0
end

function ClanRecommend.getScrollItem(arg_52_0, arg_52_1)
	return arg_52_0.ScrollViewItems[arg_52_1.scroll_index].item
end

function ClanRecommend.onSelectScrollViewItem(arg_53_0, arg_53_1, arg_53_2)
end

function ClanRecommend.refresh(arg_54_0)
	if (arg_54_0.time_nickname or 0) + 2 > os.time() then
		balloon_message_with_sound("nickname.check_wait_seconds")
		
		return false
	else
		arg_54_0.time_nickname = os.time()
		
		local var_54_0 = SAVE:getKeep("clanjoin_type_sort", 0)
		local var_54_1 = {}
		
		if var_54_0 > 0 then
			var_54_1.join_type = var_54_0
		end
		
		query("get_recommend_clan_list", var_54_1)
		
		return true
	end
end

ClanInvitation = {}

copy_functions(ScrollView, ClanInvitation)

function ClanInvitation.show(arg_55_0, arg_55_1)
	arg_55_0.vars = {}
	
	local var_55_0 = Dialog:open("wnd/clan_invited", arg_55_0)
	
	arg_55_0.vars.wnd = var_55_0
	arg_55_1 = arg_55_1 or SceneManager:getDefaultLayer()
	arg_55_0.vars.parent = arg_55_1
	
	arg_55_1:addChild(arg_55_0.vars.wnd)
	
	arg_55_0.vars.scrollview = var_55_0:getChildByName("scrollview")
	
	arg_55_0:initScrollView(arg_55_0.vars.scrollview, 839, 175)
	arg_55_0:createScrollViewItems(arg_55_0.invited_clans or {})
end

function ClanInvitation.setInvitedClans(arg_56_0, arg_56_1)
	arg_56_0.invited_clans = arg_56_1
end

function ClanInvitation.getInvitedClans(arg_57_0, arg_57_1)
	return arg_57_0.invited_clans or {}
end

function ClanInvitation.getScrollViewItem(arg_58_0, arg_58_1)
	local var_58_0 = load_dlg("clan_recommend_item", true, "wnd")
	
	UIUtil:updateClanInfo(var_58_0, arg_58_1)
	
	local var_58_1 = var_58_0:getChildByName("btn_info")
	
	var_58_1.scroll_index = #arg_58_0.ScrollViewItems + 1
	var_58_1.mode = "invitation"
	
	if_set_visible(var_58_0, "btn_join", false)
	
	local var_58_2 = ClanTag:getTagListByTagInfoIncludeTempInfo(arg_58_1.tags, arg_58_1)
	
	ClanTag:updateUIRecommendItemTag(var_58_0, var_58_2)
	
	local var_58_3 = var_58_0:getChildByName("talk_small_bg")
	local var_58_4 = var_58_0:getChildByName("clan_info_msg")
	
	UIUserData:proc(var_58_3)
	
	local var_58_5 = 900
	
	set_ellipsis_label(var_58_4, arg_58_1.intro_msg, var_58_5, 10)
	
	return var_58_0
end

function ClanInvitation.getBtnItemClanID(arg_59_0, arg_59_1)
	if not arg_59_0.ScrollViewItems[arg_59_1.scroll_index] then
		return nil
	end
	
	if not arg_59_0.ScrollViewItems[arg_59_1.scroll_index].item then
		return nil
	end
	
	return arg_59_0.ScrollViewItems[arg_59_1.scroll_index].item.clan_id
end

function ClanInvitation.acceptClanInvitation(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0:getScrollItem(arg_60_1)
	
	query("clan_accept_invitation", {
		clan_id = var_60_0.clan_id
	})
end

function ClanInvitation.allDenyInvitation(arg_61_0)
	local var_61_0 = {}
	
	for iter_61_0, iter_61_1 in pairs(arg_61_0.ScrollViewItems) do
		table.insert(var_61_0, iter_61_1.item.clan_id)
	end
	
	query("clan_all_deny_invitation", {
		clan_list = json.encode(var_61_0)
	})
end

ClanInfo = {}

local var_0_0 = {}

var_0_0.INFO = "tab_info"
var_0_0.MEMBER = "tab_member"

function HANDLER.cm_preview_clan(arg_62_0, arg_62_1)
	if arg_62_1 == "btn_close" then
		Dialog:close("cm_preview_clan")
		
		return 
	end
	
	if arg_62_1 == "btn_join" then
		ClanInfo:onEventBtnJoin(arg_62_0.mode)
		
		return 
	end
	
	if arg_62_1 == "btn_member" then
		ClanInfo:setMode(var_0_0.MEMBER)
		
		return 
	end
	
	if arg_62_1 == "btn_info" then
		ClanInfo:setMode(var_0_0.INFO)
		
		return 
	end
end

copy_functions(ScrollView, ClanInfo)

function ClanInfo.show(arg_63_0, arg_63_1, arg_63_2)
	if arg_63_0:isShow() then
		return 
	end
	
	if arg_63_2 == "lota_ranking_preview" then
		arg_63_2 = "preview"
		
		LotaRankingBoardUI:closeRankingDetail()
	end
	
	arg_63_0.vars = {}
	
	local var_63_0 = Dialog:open("wnd/cm_preview_clan", arg_63_0)
	
	arg_63_0.vars.wnd = var_63_0
	
	local var_63_1 = SceneManager:getRunningPopupScene()
	
	arg_63_0.vars.parent = var_63_1
	arg_63_0.vars.mode = var_0_0.INFO
	arg_63_0.vars.scrollview = var_63_0:getChildByName("scrollview")
	
	arg_63_0:initScrollView(arg_63_0.vars.scrollview, 550, 125)
	var_63_1:addChild(arg_63_0.vars.wnd)
	var_63_0:bringToFront()
	
	arg_63_0.vars.info = arg_63_1.clan_info
	arg_63_0.vars.parent_mode = arg_63_2
	arg_63_0.vars.tag_info = arg_63_1.tag
	arg_63_0.vars.members = arg_63_1.members
	
	arg_63_0.vars.wnd:getChildByName("btn_join"):setVisible(true)
	ClanInfo:update_member_list(arg_63_0.vars.members)
	UIUtil:updateClanInfo(arg_63_0.vars.wnd, arg_63_0.vars.info, {
		offset_x = 8
	})
	
	if arg_63_2 == "invitation" then
		if_set(arg_63_0.vars.wnd, "signup_label", T("ui_cm_preview_clan_join_accept"))
	elseif arg_63_2 == "recommend" or arg_63_2 == "preview" then
		if_set(arg_63_0.vars.wnd, "signup_label", T("ui_cm_preview_clan_btn_join"))
	end
	
	if ClanUtil:isMaxMemberCount(arg_63_0.vars.info) then
		if_set_opacity(arg_63_0.vars.wnd, "btn_join", 76.5)
	end
	
	arg_63_0.vars.wnd:getChildByName("btn_join").mode = arg_63_2
	
	SoundEngine:play("event:/ui/popup/tap")
	
	local var_63_2 = arg_63_0.vars.wnd:getChildByName("t_introduction")
	
	UIUtil:updateTextWrapMode(var_63_2, arg_63_0.vars.info.intro_msg)
	var_63_2:setString(arg_63_0.vars.info.intro_msg)
	if_set(arg_63_0.vars.wnd, "t_date", T("ui_clan_info_text9", timeToStringDef({
		time = arg_63_0.vars.info.created
	})))
	
	local var_63_3 = T("ui_clan_info_text10")
	
	if_set(arg_63_0.vars.wnd, "rank_clan_war", arg_63_1.clan_war_rank or var_63_3)
	if_set(arg_63_0.vars.wnd, "rank_clan_war_before", arg_63_1.prev_clan_war_rank or var_63_3)
	if_set(arg_63_0.vars.wnd, "rank_worldboss", arg_63_1.world_boss_rank or var_63_3)
	
	local var_63_4 = ClanTag:getTagListByTagInfoIncludeTempInfo(arg_63_0.vars.info.tag, arg_63_0.vars.info)
	
	ClanTag:updateUIPreviewTag(arg_63_0.vars.wnd, var_63_4)
	arg_63_0:updateModeUI()
end

function ClanInfo.updateModeUI(arg_64_0)
	local var_64_0 = arg_64_0.vars.wnd:getChildByName("n_top")
	
	if_set_visible(var_64_0, "fg_info", arg_64_0.vars.mode == var_0_0.INFO)
	if_set_visible(var_64_0, "fg_member", arg_64_0.vars.mode == var_0_0.MEMBER)
	if_set_visible(arg_64_0.vars.scrollview, nil, arg_64_0.vars.mode == var_0_0.MEMBER)
	if_set_visible(arg_64_0.vars.wnd, "n_basic_info", arg_64_0.vars.mode == var_0_0.INFO)
end

function ClanInfo.setMode(arg_65_0, arg_65_1)
	arg_65_0.vars.mode = arg_65_1
	
	arg_65_0:updateModeUI()
end

function ClanInfo.isShow(arg_66_0)
	if not arg_66_0.vars then
		return false
	end
	
	if not get_cocos_refid(arg_66_0.vars.wnd) then
		return false
	end
	
	return true
end

function ClanInfo.onEventBtnJoin(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0.vars.info
	local var_67_1 = arg_67_0.vars.info.join_type
	local var_67_2 = arg_67_0.vars.members
	local var_67_3
	local var_67_4, var_67_5 = Clan:isLeavePanelty()
	
	if var_67_4 then
		var_67_3 = Dialog:msgBox(T("clan_auto_join.limit_clan_join_time", {
			time = sec_to_full_string(var_67_5)
		}))
		
		if get_cocos_refid(var_67_3) then
			var_67_3:bringToFront()
		end
		
		return 
	end
	
	local var_67_6 = ClanUtil:isMaxMemberCount(arg_67_0.vars.info)
	
	if arg_67_1 == "invitation" then
		query("clan_invited_accept", {
			clan_id = var_67_0.clan_id
		})
	elseif arg_67_1 == "recommend" or arg_67_1 == "preview" then
		local var_67_7, var_67_8 = arg_67_0:isActiveJoinRequest()
		
		if var_67_7 then
			if var_67_0.join_type == 1 then
				var_67_3 = Dialog:msgBox(T("popup_clan_auto_join_desc", {
					clan_name = var_67_0.name
				}), {
					yesno = true,
					title = T("popup_clan_auto_join_title"),
					handler = function()
						query("clan_auto_join", {
							clan_id = var_67_0.clan_id
						})
					end
				})
			else
				arg_67_0:showJoinRequestPopup(var_67_0)
			end
		elseif var_67_8 == "max" then
			var_67_3 = Dialog:msgBox(T("clan_auto_join.clan_member_max"))
		elseif var_67_8 == "secret" then
			var_67_3 = Dialog:msgBox(T("clan_cant_join.secret"))
		elseif var_67_8 == "request" then
			var_67_3 = Dialog:msgBox(T("clan_join_request.request_state"))
		elseif var_67_8 == "invitation" then
			var_67_3 = Dialog:msgBox(T("clan_join_request.invitation_state"))
		elseif var_67_8 == "reject" then
			var_67_3 = Dialog:msgBox(T("clan_join_request.clan_reject"))
		end
	else
		Log.e("onEventBtnJoin", "invalid_mode")
	end
	
	if get_cocos_refid(var_67_3) then
		var_67_3:bringToFront()
	end
end

function ClanInfo.showJoinRequestPopup(arg_69_0, arg_69_1)
	local function var_69_0()
		local var_70_0 = arg_69_0.vars.join_info.text or T("friend.default_intro_msg")
		
		if check_abuse_filter(var_70_0, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		local var_70_1 = string.trim(var_70_0)
		
		if var_70_1 == nil or utf8len(var_70_1) < 5 then
			balloon_message_with_sound("lack_clan_join_request_msg_length")
			
			return 
		end
		
		if var_70_1 and utf8len(var_70_1) > 50 then
			balloon_message_with_sound("clan_join_request.too_long")
			
			return 
		end
		
		arg_69_0.vars.join_info.is_request = true
		
		query("clan_join_request", {
			clan_id = arg_69_1.clan_id,
			req_msg = arg_69_0.vars.join_info.text
		})
	end
	
	arg_69_0.vars.join_info = {}
	arg_69_0.vars.join_info.prev_text = T("friend.default_intro_msg")
	
	local var_69_1 = Dialog:openInputBox(arg_69_0, var_69_0, {
		max_limit = 50,
		title = T("ui_clan_apply_popup_tl"),
		btn_yes_txt = T("ui_clan_apply_popup_btn_ok"),
		info = arg_69_0.vars.join_info
	})
	
	arg_69_0.vars.wnd:addChild(var_69_1)
end

function ClanInfo.getInfo(arg_71_0)
	return arg_71_0.vars.info
end

function ClanInfo.getScrollViewItem(arg_72_0, arg_72_1)
	local var_72_0 = load_dlg("clan_member_item_base2", true, "wnd")
	local var_72_1 = load_control("wnd/clan_member_item_info.csb")
	local var_72_2 = load_control("wnd/clan_member_item_function.csb")
	
	var_72_0:getChildByName("info_node"):addChild(var_72_1)
	
	local var_72_3 = var_72_0:getChildByName("function_node")
	
	var_72_3:addChild(var_72_2)
	if_set_visible(var_72_3, "btn_user_info", false)
	if_set_visible(var_72_3, "btn_user_acept", false)
	if_set_visible(var_72_3, "btn_user_deny", false)
	if_set_visible(var_72_3, "btn_mamage", false)
	UIUtil:updateClanMemberInfo(var_72_0, arg_72_1, {
		width_size = 700
	})
	
	return var_72_0
end

function ClanInfo.setInactiveJoinBtn(arg_73_0, arg_73_1)
	if not arg_73_0.vars then
		return 
	end
	
	if not arg_73_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_73_0.vars.wnd) then
		return 
	end
	
	local var_73_0 = arg_73_0.vars.wnd:getChildByName("btn_join")
	
	if arg_73_1 then
		var_73_0:setVisible(false)
	else
		var_73_0:setOpacity(76.5)
	end
end

function ClanInfo.isActiveJoinRequest(arg_74_0)
	local var_74_0 = arg_74_0.vars.members
	local var_74_1 = arg_74_0.vars.info
	
	if not var_74_0 then
		return false
	end
	
	if #var_74_0 <= 0 then
		return false
	end
	
	local var_74_2 = false
	local var_74_3 = arg_74_0.vars.join_info and arg_74_0.vars.join_info.is_request
	local var_74_4 = Account:getUserId()
	local var_74_5
	
	if not TutorialGuide:isClearedTutorial("system_015") then
		return false, "tuto"
	end
	
	local var_74_6 = ClanUtil:isMaxMemberCount(var_74_1)
	
	if Account:getClanId() then
		var_74_5 = "member"
	elseif var_74_6 then
		var_74_5 = "max"
	elseif var_74_1.join_type == 3 then
		var_74_5 = "secret"
	elseif var_74_3 then
		var_74_5 = "request"
	else
		for iter_74_0, iter_74_1 in pairs(var_74_0) do
			if iter_74_1.grade == CLAN_GRADE.request and iter_74_1.user_id == var_74_4 and var_74_1.join_type == 2 then
				var_74_5 = "request"
				
				break
			elseif iter_74_1.grade == CLAN_GRADE.reject and iter_74_1.user_id == var_74_4 then
				var_74_5 = "reject"
				
				break
			elseif iter_74_1.grade == CLAN_GRADE.invitation and iter_74_1.user_id == var_74_4 and var_74_1.join_type == 2 then
				var_74_5 = "invitation"
				
				break
			elseif iter_74_1.grade == CLAN_GRADE.member and iter_74_1.user_id == var_74_4 and var_74_1.join_type == 2 then
				var_74_5 = "member"
				
				break
			end
		end
	end
	
	return var_74_5 == nil, var_74_5
end

function ClanInfo.update_member_list(arg_75_0)
	local var_75_0 = arg_75_0.vars.members
	
	if not var_75_0 then
		return 
	end
	
	if #var_75_0 <= 0 then
		return 
	end
	
	local var_75_1 = {}
	
	for iter_75_0, iter_75_1 in pairs(var_75_0) do
		if tonumber(iter_75_1.grade) >= CLAN_GRADE.member then
			table.insert(var_75_1, iter_75_1)
		end
	end
	
	local var_75_2, var_75_3 = Clan:isLeavePanelty()
	
	if arg_75_0.vars.parent_mode == "invitation" then
		local var_75_4 = arg_75_0.vars.info
		local var_75_5 = ClanUtil:isMaxMemberCount(var_75_4)
		local var_75_6 = Account:getClanId()
		
		if var_75_5 or var_75_6 or var_75_2 then
			arg_75_0:setInactiveJoinBtn()
		end
	else
		local var_75_7, var_75_8 = arg_75_0:isActiveJoinRequest()
		
		if not var_75_7 or var_75_2 then
			arg_75_0:setInactiveJoinBtn(var_75_8 and (var_75_8 == "member" or var_75_8 == "tuto"))
		end
	end
	
	arg_75_0:createScrollViewItems(var_75_1)
end

function ClanInfo.onSelectScrollViewItem(arg_76_0, arg_76_1, arg_76_2)
end

ClanJoinInfoPopup = ClanJoinInfoPopup or {}

function ClanJoinInfoPopup.show(arg_77_0, arg_77_1)
	arg_77_0.vars = {}
	arg_77_1 = arg_77_1 or SceneManager:getDefaultLayer()
	
	local var_77_0 = Dialog:open("wnd/clan_join_info_p", arg_77_0)
	
	arg_77_0.vars.wnd = var_77_0
	
	arg_77_1:addChild(arg_77_0.vars.wnd)
	
	local var_77_1 = GAME_STATIC_VARIABLE.clan_intro_popup_shop_id or "ef501;to_mura;sp_essence5a;sp_clbfexp"
	local var_77_2 = string.split(var_77_1, ";")
	
	for iter_77_0 = 1, 4 do
		if var_77_2[iter_77_0] then
			local var_77_3 = arg_77_0.vars.wnd:getChildByName("n_shop_item" .. tostring(iter_77_0)):getChildByName("n_reward_item")
			local var_77_4 = {
				parent = var_77_3
			}
			
			if not DB("equip_item", var_77_2[iter_77_0], "id") then
				var_77_4.no_bg = true
			end
			
			local var_77_5 = UIUtil:getRewardIcon(nil, var_77_2[iter_77_0], var_77_4)
		end
	end
	
	local var_77_6 = Account:serverTimeDayLocalDetail()
	
	SAVE:setKeep("clanjoin_info_p", var_77_6)
	
	local var_77_7 = GAME_STATIC_VARIABLE.clan_intro_popup_reward_id or "to_ticketspecial;sp_worldboss_clear_s"
	local var_77_8 = string.split(var_77_7, ";")
	
	for iter_77_1 = 1, 2 do
		if var_77_8[iter_77_1] then
			local var_77_9 = arg_77_0.vars.wnd:getChildByName("n_content" .. tostring(iter_77_1)):getChildByName("n_reward_item")
			local var_77_10 = {
				no_bg = true,
				parent = var_77_9
			}
			local var_77_11 = UIUtil:getRewardIcon(nil, var_77_8[iter_77_1], var_77_10)
		end
	end
end
