ClanManagement = {}

local var_0_0 = {
	tab_1 = "members",
	tab_3 = "invite",
	tab_2 = "request",
	tab_4 = "leave"
}

function HANDLER.clan_member_management(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		Dialog:close("clan_member_management")
		
		return 
	end
	
	if arg_1_1 == "btn_bg" then
		ClanManagement:setMode(arg_1_0:getParent():getName())
		
		return 
	end
	
	if arg_1_1 == "btn_leave" then
		ClanManagement:showLeavePopup()
		
		return 
	end
	
	if arg_1_1 == "btn_sorting" then
		ClanInviteManagement:setVisibleSearchTypeBox(true)
		
		return 
	end
	
	if arg_1_1 == "btn_sel_close" then
		ClanInviteManagement:setVisibleSearchTypeBox(false)
		
		return 
	end
	
	if arg_1_1 == "btn_search" then
		cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
		ClanInviteManagement:search()
		
		return 
	end
	
	if arg_1_1 == "btn_sort" then
		ClanManagement:setVisibleMemberSort(true)
		
		return 
	end
	
	if arg_1_1 == "btn_sort_sel_close" then
		ClanManagement:setVisibleMemberSort(false)
		
		return 
	end
	
	if arg_1_1 == "btn_move_invite" then
		ClanManagement:setMode("tab_3")
		
		return 
	end
	
	if arg_1_1 == "btn_user_info" and arg_1_0.user_id then
		if arg_1_0.user_id == Account:getUserId() then
			ClanMembersManagement:showEditMemberNoti(arg_1_0.user_id)
		else
			Friend:preview(arg_1_0.user_id)
		end
		
		return 
	end
	
	if arg_1_1 == "btn_user_deny" and arg_1_0.user_id then
		query("clan_refuse_join", {
			refuse_user_id = arg_1_0.user_id
		})
		
		return 
	end
	
	if arg_1_1 == "btn_user_acept" and arg_1_0.user_id then
		query("clan_accept_join", {
			accept_user_id = arg_1_0.user_id
		})
		
		return 
	end
	
	if arg_1_1 == "btn_management" then
		ClanManagement:showMemberGradeManagement(arg_1_0, arg_1_0.user_id)
		
		return 
	end
	
	if arg_1_1 == "btn_invite" then
		if arg_1_0.is_lv_limit then
			balloon_message_with_sound("msg_clan_invite_req_rank")
		else
			Clan:queryInvite(arg_1_0.user_id)
		end
		
		return 
	end
	
	if arg_1_1 == "btn_inputbg" then
		if ClanManagement and ClanManagement.vars and get_cocos_refid(ClanManagement.vars.wnd) then
			ClanManagement.vars.wnd:getChildByName("txt_input"):setTextColor(cc.c3b(107, 101, 27))
			ClanManagement.vars.wnd:getChildByName("txt_input"):setCursorEnabled(true)
		end
		
		return 
	end
end

function HANDLER.clan_edit_emblem(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		Dialog:close("clan_edit_emblem")
	end
end

function HANDLER.clan_home_visittable(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("clan_home_visittable")
	end
end

function HANDLER.clan_attendance(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		Dialog:close("clan_attendance")
	end
	
	if arg_4_1 == "btn_bg" then
		ClanAttendance:setMode(arg_4_0:getParent():getName())
	end
	
	if arg_4_1 == "btn_get_reward" then
		if not Clan:getAttenInfo().is_y_rewardable then
			balloon_message_with_sound("clan_atten_already_rewarded")
		else
			query("get_attendance_reward")
		end
	end
	
	if arg_4_1 == "btn_check" and Clan:getAttenInfo().is_t_atten_checked then
		balloon_message_with_sound("clan_atten_already_check")
	end
	
	if false then
	end
end

function HANDLER.clan_home_edit(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" or arg_5_1 == "btn_cancel" then
		ClanEdit:close()
	end
	
	if arg_5_1 == "btn_select" then
		local var_5_0 = arg_5_0:getParent():getName()
		
		ClanEdit:openSel(var_5_0)
	end
	
	if arg_5_1 == "btn_sel_close" then
		arg_5_0:getParent():setVisible(false)
	end
	
	if arg_5_1 == "btn_ok" then
		if ClanEdit:checkErrUpdateList() then
			return 
		end
		
		local var_5_1 = ClanEdit:getUpdateList()
		
		ClanEdit:close()
		
		if table.count(var_5_1) <= 0 then
			return 
		end
		
		local var_5_2 = json.encode(var_5_1)
		
		query("clan_update_info", {
			update_list = var_5_2
		})
	end
	
	if arg_5_1 == "btn_emblem" then
		ClanEmblem:show()
	end
	
	if arg_5_1 == "btn_bg" then
		if not ClanEmblemBG:isOpenSystem() then
			balloon_message_with_sound("notyet_dev")
			
			return 
		end
		
		ClanEmblemBG:show()
		
		return 
	end
	
	if string.starts(arg_5_1, "sort") then
		ClanEdit:updateSel(arg_5_0)
		arg_5_0:getParent():setVisible(false)
		
		return 
	end
	
	if arg_5_1 == "btn_no_tag" or arg_5_1 == "btn_tag1" or arg_5_1 == "btn_tag2" then
		local var_5_3 = ClanEdit:getTagListNode()
		
		ClanTagListUI:show(var_5_3)
		
		return 
	end
end

function HANDLER.clan_member_grade_edit(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_up" or arg_6_1 == "btn_down" or arg_6_1 == "btn_ban" or arg_6_1 == "btn_master" then
		ClanManagement:changeGrade(arg_6_0, arg_6_0.user_id)
	end
	
	Dialog:close("clan_member_grade_edit")
end

function HANDLER.clan_user_ban(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_ok" then
		query("clan_compulsory_leave", {
			target_user_id = arg_7_0.user_id
		})
	end
	
	Dialog:close("clan_user_ban")
end

function HANDLER.clan_home_visit(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_close" then
		Dialog:close("clan_home_visit")
	end
end

function MsgHandler.clan_leave_member(arg_9_0)
	if arg_9_0.res == "ok" then
		Account:setClanId(nil)
		Dialog:close("clan_member_management")
		Clan:clear()
		ClanBase:close()
		ClanBase:show(nil, {
			leave = true
		})
		Account:reset_worldbossSupporterTeam()
	end
end

function MsgHandler.clan_refuse_join(arg_10_0)
	if arg_10_0.refuse_user_id then
		Clan:removeRequestMembers(arg_10_0.refuse_user_id)
	end
	
	ClanJoinRequestManagement:refresh()
	ClanHome:updateRequestMemberNotiCount(Clan:getRequestMemberCount())
end

function MsgHandler.clan_invite(arg_11_0)
	if arg_11_0.err_msg then
		Friend:setInviteErrText(arg_11_0.err_msg)
		balloon_message_with_sound(arg_11_0.err_msg)
	elseif arg_11_0.msg then
		Dialog:msgBox(T(arg_11_0.msg)):bringToFront()
		Clan:updateInfo(arg_11_0)
	else
		balloon_message_with_sound("clan_success_user_invited")
		Clan:updateInfo(arg_11_0)
	end
end

function MsgHandler.clan_update_info(arg_12_0)
	if arg_12_0.err_msg then
		balloon_message_with_sound(arg_12_0.err_msg)
	else
		balloon_message_with_sound("clan_success_change_info")
		ClanTag:setTagInfo(arg_12_0.tag_info)
		Clan:updateInfo(arg_12_0)
		ClanHistory:clear()
	end
end

function MsgHandler.clan_grade_change(arg_13_0)
	if arg_13_0.err_msg then
		balloon_message_with_sound(arg_13_0.err_msg)
	else
		balloon_message_with_sound("clan_success_change_member_grade")
		Clan:updateInfo(arg_13_0)
	end
end

function MsgHandler.clan_compulsory_leave(arg_14_0)
	if arg_14_0.err_msg then
		balloon_message_with_sound(arg_14_0.err_msg)
	elseif arg_14_0.target_member_info then
		balloon_message_with_sound("clan_success_compulsory_leave")
		Clan:removeMembers(arg_14_0.target_member_info.user_id)
		ClanHome:setRandomMemberList(Clan:getMembers())
		Clan:updateInfo(arg_14_0)
	end
end

function MsgHandler.clan_accept_join(arg_15_0)
	if arg_15_0.res == "ok" and arg_15_0.accept_user_info then
		Clan:removeRequestMembers(arg_15_0.accept_user_info.user_id)
		Clan:insertMembers(arg_15_0.accept_user_info)
		Clan:updateInfo(arg_15_0)
		ClanJoinRequestManagement:refresh()
	end
end

function MsgHandler.set_attendance(arg_16_0)
	if arg_16_0.res == "ok" then
		local var_16_0 = {
			title = T("clan_get_attend_check_reward_title"),
			desc = T("clan_get_attend_check_reward")
		}
		
		Account:addReward(arg_16_0, {
			play_reward_data = var_16_0,
			handler = function()
				ClanHome:nextNoti()
			end
		})
		TopBarNew:topbarUpdate(true)
		Clan:updateInfo(arg_16_0)
		ConditionContentsManager:dispatch("clan.attendance")
	end
end

function MsgHandler.get_attendance_reward(arg_18_0)
	if arg_18_0.err_msg then
		balloon_message_with_sound(arg_18_0.err_msg)
	else
		Singular:event("daily_guild_checkin")
		Account:addReward(arg_18_0.rewards)
		ClanAttendance:showRewardPopup()
		TopBarNew:topbarUpdate(true)
		Clan:updateInfo(arg_18_0)
	end
end

function MsgHandler.get_attendance_list(arg_19_0)
	if arg_19_0.res == "ok" then
	end
end

function MsgHandler.get_attendance_info(arg_20_0)
	if arg_20_0.res == "ok" then
		Clan:updateInfo(arg_20_0)
		
		local var_20_0 = "tab_1"
		
		ClanAttendance:setMode(var_20_0)
	end
end

function MsgHandler.clan_user_search(arg_21_0)
	if SceneManager:getCurrentSceneName() == "clan" then
		ClanInviteManagement:searchResult(arg_21_0)
	end
end

function MsgHandler.clan_edit_member_intro(arg_22_0)
	if arg_22_0.member_info then
		Clan:updateInfo(arg_22_0)
		ClanMembersManagement:updateMemberInfo(arg_22_0.member_info)
		balloon_message_with_sound("clan_success_change_text_member_intro")
	end
end

function ErrHandler.clan_edit_member_intro(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_1 then
		return 
	end
	
	balloon_message_with_sound("intro." .. arg_23_1)
end

function HANDLER.clan_emblem_item_popup(arg_24_0, arg_24_1)
	if arg_24_1 == "btn_close" then
		Dialog:close("clan_emblem_item_popup")
		
		return 
	end
end

function ClanManagement.show(arg_25_0, arg_25_1)
	arg_25_0.vars = {}
	arg_25_1 = arg_25_1 or SceneManager:getDefaultLayer()
	arg_25_0.vars.parents = arg_25_1
	arg_25_0.vars.wnd = Dialog:open("wnd/clan_member_management", arg_25_0)
	
	arg_25_1:addChild(arg_25_0.vars.wnd)
	
	arg_25_0.vars.mode_nodes = {}
	arg_25_0.vars.mode_nodes[var_0_0.tab_1] = arg_25_0.vars.wnd:getChildByName("n_clan_member")
	arg_25_0.vars.mode_nodes[var_0_0.tab_2] = arg_25_0.vars.wnd:getChildByName("n_request")
	arg_25_0.vars.mode_nodes[var_0_0.tab_3] = arg_25_0.vars.wnd:getChildByName("n_clan_invite")
	arg_25_0.vars.mode_nodes[var_0_0.tab_4] = arg_25_0.vars.wnd:getChildByName("n_leave")
	
	ClanMembersManagement:create(arg_25_0.vars.mode_nodes.members)
	ClanInviteManagement:create(arg_25_0.vars.mode_nodes.invite)
	ClanJoinRequestManagement:create(arg_25_0.vars.mode_nodes.request)
	UIUtil:updateClanInfo(arg_25_0.vars.mode_nodes.leave, Clan:getClanInfo())
	
	local var_25_0 = "tab_1"
	
	arg_25_0:setMode(var_25_0)
	SoundEngine:play("event:/ui/popup/tap")
	arg_25_0:_refreshMembers()
	
	arg_25_0.vars.member_sorter = Sorter:create(arg_25_0.vars.wnd:getChildByName("n_sorting"))
	
	arg_25_0.vars.member_sorter:setSorter({
		default_sort_index = SAVE:get("app.clan_management_sort_index", 1),
		menus = {
			{
				name = T("ui_clan_member_management_member_sort1"),
				func = ClanMembersManagement.greaterThanMemberGrade
			},
			{
				name = T("ui_clan_member_management_member_sort2"),
				func = ClanMembersManagement.greaterThanRankLevel
			},
			{
				name = T("ui_clan_member_management_member_sort3"),
				func = ClanMembersManagement.greaterThanContributionScore
			},
			{
				name = T("ui_clan_member_management_member_sort4"),
				func = ClanMembersManagement.greaterThanLoginTime
			}
		},
		callback_sort = function(arg_26_0, arg_26_1)
			SAVE:set("app.clan_management_sort_index", arg_26_1)
			ClanMembersManagement:refreshData()
		end
	})
	ClanMembersManagement:refreshData()
	arg_25_0.vars.member_sorter:setItems(arg_25_0.vars.member_sort_items)
	arg_25_0.vars.member_sorter:sort(SAVE:get("app.clan_management_sort_index", 1))
	
	local var_25_1 = arg_25_0.vars.wnd:getChildByName("txt_input")
	
	if get_cocos_refid(var_25_1) then
		var_25_1:setMaxLengthEnabled(true)
		var_25_1:setCursorEnabled(true)
		var_25_1:setTextColor(cc.c3b(107, 101, 27))
	end
	
	arg_25_0.vars.invite_sorter = Sorter:create(arg_25_0.vars.wnd:getChildByName("n_invite_sorting"), {
		csb_file = "wnd/sorting_1.csb"
	})
	
	arg_25_0.vars.invite_sorter:setSorter({
		default_sort_index = 1,
		menus = {
			{
				name = T("ui_clan_member_management_sort1"),
				func = function()
				end
			}
		},
		callback_sort = function(arg_28_0, arg_28_1)
		end
	})
	arg_25_0.vars.invite_sorter:sort(1)
	arg_25_0:updateUI()
end

function ClanManagement.getMemberSortItems(arg_29_0)
	if not arg_29_0.vars then
		return {}
	end
	
	return arg_29_0.vars.member_sort_items
end

function ClanManagement.getSubWnd(arg_30_0, arg_30_1)
	return arg_30_0.vars.mode_nodes[arg_30_1]
end

function ClanManagement.getMode(arg_31_0)
	return arg_31_0.vars.mode
end

function ClanManagement.isShow(arg_32_0)
	if arg_32_0.vars and get_cocos_refid(arg_32_0.vars.wnd) then
		return arg_32_0.vars.wnd:isVisible()
	end
end

function ClanManagement._refreshMembers(arg_33_0)
	local var_33_0 = Clan:getMembers()
	
	arg_33_0.vars.member_sort_items = {}
	
	for iter_33_0, iter_33_1 in pairs(var_33_0) do
		if iter_33_1.user_info and not table.empty(iter_33_1.user_info) then
			table.insert(arg_33_0.vars.member_sort_items, iter_33_1)
		end
	end
end

function ClanManagement.updateMembers(arg_34_0)
	if #Clan:getMembers() > 0 and arg_34_0.vars.member_sorter then
		arg_34_0:_refreshMembers()
		arg_34_0.vars.member_sorter:setItems(arg_34_0.vars.member_sort_items)
		ClanMembersManagement:refreshData()
		arg_34_0.vars.member_sorter:sort(SAVE:get("app.clan_management_sort_index", 1))
	end
end

function ClanManagement.updateUI(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	if arg_35_0.vars and get_cocos_refid(arg_35_0.vars.wnd) then
		if_set(arg_35_0.vars.wnd, "member_count", T("text_user_count", {
			count = Clan:getClanInfo().member_count,
			max = Clan:getMaxClanMember()
		}))
		if_set(arg_35_0.vars.wnd, "txt_member_contribute", T("clan_contribution_score", {
			score = Clan:getUserMemberInfo().contribution_score
		}))
	end
end

function ClanManagement.showCompulsoryLeavePopup(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0, var_36_1 = Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_exile", {
		remain_time = Clan:getUserMemberInfoGradeLimitsRemainTime("clan_exile")
	})
	
	if var_36_0 then
		local var_36_2 = Clan:getMemberInfoById(arg_36_1)
		
		if var_36_2 then
			local var_36_3 = Dialog:open("wnd/clan_user_ban", arg_36_0)
			
			var_36_3:getChildByName("btn_ok").user_id = arg_36_1
			
			UIUtil:updateClanMemberInfo(var_36_3, var_36_2, {
				leader_scale = 1
			})
			
			arg_36_2 = arg_36_2 or SceneManager:getDefaultLayer()
			
			arg_36_2:addChild(var_36_3)
		end
	elseif var_36_1 then
		balloon_message_with_sound("clan_no_excutable_limit_time")
	else
		balloon_message_with_sound("no_executable_ban")
	end
end

function ClanManagement.showLeavePopup(arg_37_0)
	local function var_37_0()
		query("clan_leave_member")
	end
	
	if Clan:isMaster() and #Clan:getMembers() > 1 then
		balloon_message_with_sound("clan_cant_getout")
	elseif Clan:isMaster() then
		Dialog:msgBox(T("clan_dissolution_msg"), {
			yesno = true,
			title = T("clan_dissolution_title"),
			yes_text = T("clan_exit_yes"),
			handler = var_37_0
		})
	else
		Dialog:msgBox(T("clan_exit_text"), {
			yesno = true,
			title = T("clan_exit_title"),
			yes_text = T("clan_exit_yes"),
			handler = var_37_0
		})
	end
end

function ClanManagement.updateRequestMembers(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.wnd) or not arg_39_0.vars.wnd:isVisible() then
		return 
	end
	
	ClanJoinRequestManagement:refresh()
	ClanJoinRequestManagement:updateNotiCount()
	if_set_visible(ClanManagement:getWnd(), "n_request_none", Clan:getRequestMemberCount() <= 0)
end

function ClanManagement.setMode(arg_40_0, arg_40_1)
	local var_40_0 = var_0_0[arg_40_1]
	
	arg_40_0.vars.mode = var_40_0
	
	for iter_40_0 = 1, 4 do
		if arg_40_1 == "tab_" .. iter_40_0 then
			arg_40_0.vars.wnd:getChildByName("tab_" .. iter_40_0):getChildByName("image_selected"):setVisible(true)
		else
			arg_40_0.vars.wnd:getChildByName("tab_" .. iter_40_0):getChildByName("image_selected"):setVisible(false)
		end
	end
	
	if var_40_0 == "members" then
		arg_40_0:updateMembers()
		arg_40_0.vars.wnd:getChildByName("n_member_sub"):setVisible(true)
		arg_40_0.vars.wnd:getChildByName("n_member_sub"):getChildByName("n_sorting"):setVisible(true)
		
		local var_40_1 = arg_40_0.vars.wnd:getChildByName("member_count_pos1")
		
		arg_40_0.vars.wnd:getChildByName("member_count"):setPosition(var_40_1:getPosition())
	elseif var_40_0 == "request" then
		arg_40_0.vars.wnd:getChildByName("n_member_sub"):setVisible(true)
		arg_40_0.vars.wnd:getChildByName("n_member_sub"):getChildByName("n_sorting"):setVisible(false)
		arg_40_0:updateRequestMembers()
		
		local var_40_2 = arg_40_0.vars.wnd:getChildByName("member_count_pos2")
		
		arg_40_0.vars.wnd:getChildByName("member_count"):setPosition(var_40_2:getPosition())
	elseif var_40_0 == "invite" then
		arg_40_0.vars.wnd:getChildByName("n_member_sub"):setVisible(false)
		ClanInviteManagement:updateInviteUI()
	else
		arg_40_0.vars.wnd:getChildByName("n_member_sub"):setVisible(false)
	end
	
	for iter_40_1, iter_40_2 in pairs(arg_40_0.vars.mode_nodes) do
		if iter_40_1 == var_0_0[arg_40_1] then
			iter_40_2:setVisible(true)
		else
			iter_40_2:setVisible(false)
		end
	end
end

function ClanManagement.getWnd(arg_41_0)
	if get_cocos_refid(arg_41_0.vars.wnd) then
		return arg_41_0.vars.wnd
	end
end

function ClanManagement.setVisibleMemberSort(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.vars.wnd:getChildByName("layer_manage_sort_sel")
	
	var_42_0:setVisible(arg_42_1)
	
	if arg_42_1 then
		local var_42_1 = arg_42_0.vars.wnd:getChildByName("manag_sort_cursor")
		local var_42_2 = arg_42_0.vars.wnd:getChildByName("icon_order")
		local var_42_3 = var_42_0:getChildByName("msort_" .. arg_42_0.vars.sort)
		
		var_42_1:setPositionY(var_42_3:getPositionY())
		var_42_2:setPositionY(var_42_3:getPositionY() + 24)
	end
end

function ClanManagement.showMemberGradeManagement(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = Clan:getMemberGrade()
	local var_43_1 = Clan:getMemberInfoById(arg_43_2)
	
	if not var_43_1 then
		balloon_message_with_sound("invalid_clan_member")
		
		return 
	end
	
	local var_43_2 = var_43_1.grade
	
	if var_43_0 == CLAN_GRADE.master then
		if var_43_2 == CLAN_GRADE.master then
			balloon_message_with_sound("clan_no_grade_change_master_mine")
			
			return 
		end
	elseif var_43_0 == CLAN_GRADE.executives then
		if var_43_2 == CLAN_GRADE.master then
			balloon_message_with_sound("clan_no_change_master")
			
			return 
		elseif var_43_2 == CLAN_GRADE.executives then
			balloon_message_with_sound("clan_no_grade_change_executives")
			
			return 
		end
	end
	
	local var_43_3 = arg_43_1:convertToWorldSpace({
		x = 0,
		y = 0
	})
	local var_43_4 = Dialog:open("wnd/clan_member_grade_edit", arg_43_0)
	
	var_43_4:setPositionX(var_43_3.x)
	
	local var_43_5 = var_43_4:getChildByName("bg"):getContentSize().height
	
	var_43_4:setPositionY(math.max(var_43_5 - 10, var_43_3.y + var_43_5 / 2))
	if_set_visible(var_43_4, "layer_master_execu", false)
	if_set_visible(var_43_4, "layer_master_member", false)
	if_set_visible(var_43_4, "layer_execu_member", false)
	
	if var_43_0 == CLAN_GRADE.master then
		if var_43_2 == CLAN_GRADE.master then
		elseif var_43_2 == CLAN_GRADE.executives then
			local var_43_6 = var_43_4:getChildByName("layer_master_execu")
			
			var_43_6:setVisible(true)
			
			var_43_6:getChildByName("btn_master").user_id = arg_43_1.user_id
			var_43_6:getChildByName("btn_down").user_id = arg_43_1.user_id
		else
			local var_43_7 = var_43_4:getChildByName("layer_master_member")
			
			var_43_7:setVisible(true)
			
			var_43_7:getChildByName("btn_up").user_id = arg_43_1.user_id
			var_43_7:getChildByName("btn_ban").user_id = arg_43_1.user_id
		end
	elseif var_43_0 ~= CLAN_GRADE.executives or var_43_2 == CLAN_GRADE.master then
	elseif var_43_2 == CLAN_GRADE.executives then
	else
		local var_43_8 = var_43_4:getChildByName("layer_execu_member")
		
		var_43_8:setVisible(true)
		
		var_43_8:getChildByName("btn_ban").user_id = arg_43_1.user_id
	end
	
	arg_43_0.vars.wnd:addChild(var_43_4)
end

function ClanManagement.changeGrade(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = Clan:getMemberGrade()
	local var_44_1 = Clan:getMemberInfoById(arg_44_2).grade
	local var_44_2 = arg_44_1:getName()
	
	if var_44_0 == CLAN_GRADE.master then
		if var_44_2 == "btn_master" then
			Dialog:msgBox(T("clan_master_entrust_msg"), {
				yesno = true,
				dlg = dlg,
				handler = function()
					query("clan_grade_change", {
						taget_grade = CLAN_GRADE.master,
						target_user_id = arg_44_2
					})
				end,
				title = T("clan_master_entrust")
			})
		elseif var_44_2 == "btn_up" then
			query("clan_grade_change", {
				taget_grade = CLAN_GRADE.executives,
				target_user_id = arg_44_2
			})
		elseif var_44_2 == "btn_down" then
			query("clan_grade_change", {
				taget_grade = CLAN_GRADE.member,
				target_user_id = arg_44_2
			})
		elseif var_44_2 == "btn_ban" then
			ClanManagement:showCompulsoryLeavePopup(arg_44_1.user_id)
		end
	elseif var_44_0 == CLAN_GRADE.executives and var_44_2 == "btn_ban" then
		ClanManagement:showCompulsoryLeavePopup(arg_44_1.user_id)
	end
end

ClanMembersManagement = {}

function ClanMembersManagement.create(arg_46_0, arg_46_1)
	arg_46_0.vars = {}
	
	local var_46_0 = arg_46_1:getChildByName("listview")
	
	arg_46_0.vars.itemView = ItemListView_v2:bindControl(var_46_0)
	
	local var_46_1 = load_control("wnd/clan_member_item_base1.csb")
	local var_46_2 = load_control("wnd/clan_member_item_info.csb")
	
	var_46_2:setName("cont_sub_info")
	
	local var_46_3 = load_control("wnd/clan_member_item_function.csb")
	
	var_46_3:setName("cont_sub_function")
	var_46_1:getChildByName("info_node"):addChild(var_46_2)
	
	local var_46_4
	
	if not Clan:isExecutAbleGrade(Clan:getMemberGrade(), "member_management") then
		var_46_4 = var_46_1:getChildByName("function_node")
		
		var_46_4:addChild(var_46_3)
		if_set_visible(var_46_4, "btn_mamage", false)
	else
		var_46_4 = var_46_1:getChildByName("function_node_master")
		
		var_46_4:addChild(var_46_3)
		if_set_visible(var_46_4, "btn_mamage", true)
	end
	
	if_set_visible(var_46_4, "btn_user_acept", false)
	if_set_visible(var_46_4, "btn_user_deny", false)
	if_set_visible(var_46_4, "btn_invite", false)
	
	local var_46_5 = {
		onUpdate = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
			ClanMembersManagement:updateItem(arg_47_1, arg_47_3)
			
			return arg_47_3.id
		end
	}
	
	arg_46_0.vars.itemView:setRenderer(var_46_1, var_46_5)
	arg_46_0.vars.itemView:removeAllChildren()
	arg_46_0.vars.itemView:setDataSource({})
	query("get_request_clan_members", {
		clan_id = AccountData.clan_id
	})
end

function ClanMembersManagement.refresh(arg_48_0)
	arg_48_0.vars.itemView:refresh()
end

function ClanMembersManagement.refreshData(arg_49_0)
	if not arg_49_0.vars or not arg_49_0.vars.itemView or not ClanManagement:getMemberSortItems() then
		return 
	end
	
	arg_49_0.vars.itemView:setDataSource(ClanManagement:getMemberSortItems())
end

function ClanMembersManagement.updateItem(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_1:getChildByName("cont_sub_function")
	
	var_50_0:getChildByName("btn_user_info").user_id = arg_50_2.user_id
	var_50_0:getChildByName("btn_management").user_id = arg_50_2.user_id
	
	if arg_50_2.user_id == Account:getUserId() then
		if_set(arg_50_1, "profile_label", T("clan_user_notice"))
	else
		if_set(arg_50_1, "profile_label", T("ui_clan_member_item_function_profile"))
	end
	
	UIUtil:updateClanMemberInfo(arg_50_1, arg_50_2)
	
	return arg_50_1
end

function ClanMembersManagement.greaterThanMemberGrade(arg_51_0, arg_51_1)
	return tonumber(arg_51_0.grade) > tonumber(arg_51_1.grade)
end

function ClanMembersManagement.greaterThanRankLevel(arg_52_0, arg_52_1)
	return tonumber(arg_52_0.user_info.level) > tonumber(arg_52_1.user_info.level)
end

function ClanMembersManagement.greaterThanContributionScore(arg_53_0, arg_53_1)
	return tonumber(arg_53_0.contribution_score) > tonumber(arg_53_1.contribution_score)
end

function ClanMembersManagement.greaterThanLoginTime(arg_54_0, arg_54_1)
	return tonumber(arg_54_0.user_info.login_tm) > tonumber(arg_54_1.user_info.login_tm)
end

function ClanMembersManagement.updateMemberInfo(arg_55_0, arg_55_1)
	if not arg_55_1 then
		return 
	end
	
	for iter_55_0, iter_55_1 in pairs(ClanManagement:getMemberSortItems()) do
		if iter_55_1.user_id == arg_55_1.user_id then
			ClanManagement:getMemberSortItems()[iter_55_0] = arg_55_1
			
			ClanMembersManagement:refresh()
			
			break
		end
	end
end

function ClanMembersManagement.showEditMemberNoti(arg_56_0, arg_56_1)
	local function var_56_0()
		if arg_56_0.vars.noti_info.text == arg_56_0.vars.noti_info.prev_text then
			balloon_message_with_sound("no_change_text_clan_member_intro")
			
			return 
		end
		
		local var_57_0 = arg_56_0.vars.noti_info.text
		
		if check_abuse_filter(var_57_0, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		local var_57_1 = string.trim(var_57_0)
		
		if var_57_1 == nil or utf8len(var_57_1) < 5 then
			balloon_message_with_sound("lack_clan_member_intro_msg_length")
			
			return 
		end
		
		query("clan_edit_member_intro", {
			msg = arg_56_0.vars.noti_info.text
		})
	end
	
	local var_56_1 = Clan:getUserMemberInfo()
	
	arg_56_0.vars.noti_info = {}
	arg_56_0.vars.noti_info.prev_text = var_56_1.intro_msg or T("input_default_msg_clan_member_intro")
	
	local var_56_2 = Dialog:openInputBox(arg_56_0, var_56_0, {
		max_limit = 50,
		info = arg_56_0.vars.noti_info
	})
	
	ClanManagement.vars.wnd:addChild(var_56_2)
end

ClanJoinRequestManagement = {}

function ClanJoinRequestManagement.create(arg_58_0, arg_58_1)
	arg_58_0.vars = {}
	
	local var_58_0 = arg_58_1:getChildByName("listview")
	
	arg_58_0.vars.itemView = ItemListView_v2:bindControl(var_58_0)
	
	local var_58_1 = load_control("wnd/clan_member_item_base1.csb")
	local var_58_2 = load_control("wnd/clan_member_item_info.csb")
	
	var_58_2:setName("cont_sub_info")
	
	local var_58_3 = load_control("wnd/clan_member_item_function.csb")
	
	var_58_3:setName("cont_sub_function")
	var_58_1:getChildByName("info_node"):addChild(var_58_2)
	
	if var_58_0.STRETCH_INFO then
		local var_58_4 = var_58_0:getContentSize()
		
		resetControlPosAndSize(var_58_1, var_58_4.width, var_58_0.STRETCH_INFO.width_prev)
	end
	
	local var_58_5
	
	if Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_accept") then
		var_58_1:getChildByName("function_node_master_req"):addChild(var_58_3)
		if_set_visible(var_58_3, "btn_mamage", false)
		if_set_visible(var_58_3, "btn_invite", false)
	else
		var_58_1:getChildByName("function_node"):addChild(var_58_3)
		if_set_visible(var_58_3, "btn_mamage", false)
		if_set_visible(var_58_3, "btn_user_acept", false)
		if_set_visible(var_58_3, "btn_user_deny", false)
		if_set_visible(var_58_3, "btn_invite", false)
	end
	
	local var_58_6 = {
		onUpdate = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
			ClanJoinRequestManagement:updateItem(arg_59_1, arg_59_3)
			
			return arg_59_3.id
		end
	}
	
	arg_58_0.vars.itemView:setRenderer(var_58_1, var_58_6)
	arg_58_0.vars.itemView:removeAllChildren()
	arg_58_0.vars.itemView:setDataSource(Clan:getRequestMembers())
	if_set_visible(ClanManagement:getWnd():getChildByName("tab_2"), "bg_cnt", false)
	arg_58_0:updateNotiCount(Clan:getRequestMemberCount())
end

function ClanJoinRequestManagement.refresh(arg_60_0)
	arg_60_0.vars.itemView:setDataSource(Clan:getRequestMembers())
end

function ClanJoinRequestManagement.updateItem(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = arg_61_1:getChildByName("cont_sub_function")
	
	var_61_0:getChildByName("btn_user_info").user_id = arg_61_2.user_id
	var_61_0:getChildByName("btn_user_deny").user_id = arg_61_2.user_id
	var_61_0:getChildByName("btn_user_acept").user_id = arg_61_2.user_id
	
	UIUtil:updateClanMemberInfo(arg_61_1, arg_61_2, {
		no_contri = true
	})
end

function ClanJoinRequestManagement.updateNotiCount(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_1 or #Clan:getRequestMembers()
	local var_62_1 = ClanManagement:getWnd():getChildByName("tab_2")
	
	if_set_visible(var_62_1, "bg_cnt", var_62_0 > 0)
	if_set(var_62_1, "txt_cnt", var_62_0)
end

ClanInviteManagement = {}

function ClanInviteManagement.create(arg_63_0, arg_63_1)
	arg_63_0.vars = {}
	
	local var_63_0 = arg_63_1:getChildByName("listview")
	
	arg_63_0.vars.itemView = ItemListView_v2:bindControl(var_63_0)
	
	local var_63_1 = load_control("wnd/clan_member_item_base1.csb")
	local var_63_2 = load_control("wnd/clan_member_item_info.csb")
	
	var_63_2:setName("cont_sub_info")
	
	local var_63_3 = load_control("wnd/clan_member_item_function.csb")
	
	var_63_3:setName("cont_sub_function")
	var_63_1:getChildByName("info_node"):addChild(var_63_2)
	
	local var_63_4 = var_63_1:getChildByName("function_node_master_req")
	
	var_63_4:addChild(var_63_3)
	if_set_visible(var_63_4, "btn_mamage", false)
	if_set_visible(var_63_4, "btn_user_acept", false)
	if_set_visible(var_63_4, "btn_user_deny", false)
	if_set_visible(var_63_4, "btn_invite", true)
	
	arg_63_0.vars.search_list = {}
	
	local var_63_5 = {
		onUpdate = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
			ClanInviteManagement:updateItem(arg_64_1, arg_64_3)
			
			return arg_64_3.id
		end
	}
	
	arg_63_0.vars.itemView:setRenderer(var_63_1, var_63_5)
	arg_63_0.vars.itemView:removeAllChildren()
	arg_63_0.vars.itemView:setDataSource(arg_63_0.vars.search_list)
	
	arg_63_0.vars.is_search = false
end

function ClanInviteManagement.updateInviteUI(arg_65_0)
	local var_65_0 = Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_invite_tap")
	local var_65_1 = ClanManagement:getSubWnd(ClanManagement:getMode())
	
	if_set_visible(var_65_1, "n_normal", not var_65_0)
	if_set_visible(var_65_1, "n_search", var_65_0)
	if_set_visible(var_65_1, "n_search_yet", var_65_0 and not arg_65_0.vars.is_search)
	if_set_visible(var_65_1, "cm_bar786", var_65_0)
	if_set_visible(var_65_1, "n_search_result", var_65_0 and table.count(arg_65_0.vars.search_list) <= 0 and arg_65_0.vars.is_search)
	
	local var_65_2 = ClanManagement:getSubWnd(ClanManagement:getMode()):getChildByName("txt_input"):getString()
end

function ClanInviteManagement.reset(arg_66_0)
	arg_66_0.vars.search_list = {}
	
	arg_66_0:refresh()
end

function ClanInviteManagement.refresh(arg_67_0)
	arg_67_0.vars.itemView:setDataSource(arg_67_0.vars.search_list)
end

function ClanInviteManagement.updateItem(arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_1:getChildByName("cont_sub_function")
	
	var_68_0:getChildByName("btn_user_info").user_id = arg_68_2.id
	var_68_0:getChildByName("btn_user_deny").user_id = arg_68_2.id
	var_68_0:getChildByName("btn_user_acept").user_id = arg_68_2.id
	
	local var_68_1 = var_68_0:getChildByName("btn_invite")
	
	var_68_1.user_id = arg_68_2.id
	
	if arg_68_2.level < (GAME_CONTENT_VARIABLE.clan_invite_req_rank or 10) then
		var_68_1.is_lv_limit = true
		
		var_68_1:setOpacity(76.5)
	else
		var_68_1.is_lv_limit = false
		
		var_68_1:setOpacity(255)
	end
	
	var_68_0:getChildByName("btn_mamage").user_id = arg_68_2.id
	
	UIUtil:updateClanMemberInfo(arg_68_1, arg_68_2, {
		no_contri = true
	})
	if_set_visible(arg_68_1, "txt_contribute", false)
	
	return arg_68_1
end

function ClanInviteManagement.setVisibleSearchTypeBox(arg_69_0, arg_69_1)
	local var_69_0 = ClanManagement:getSubWnd(ClanManagement:getMode())
	
	if_set_visible(var_69_0, "layer_sel", arg_69_1)
end

function ClanInviteManagement.searchResult(arg_70_0, arg_70_1)
	if arg_70_1.friend_update then
		arg_70_0.vars.is_search = true
		
		table.sort(arg_70_1.friend_update.find, function(arg_71_0, arg_71_1)
			return arg_71_0.login_tm > arg_71_1.login_tm
		end)
		
		arg_70_0.vars.search_list = arg_70_1.friend_update.find
		
		ClanInviteManagement:refresh()
		arg_70_0:updateInviteUI()
	end
end

function ClanInviteManagement.search(arg_72_0)
	local var_72_0 = ClanManagement:getSubWnd(ClanManagement:getMode()):getChildByName("txt_input"):getString()
	
	if var_72_0 == nil or utf8len(var_72_0) < 2 then
		balloon_message_with_sound("search_two_words")
		
		return 
	end
	
	if (arg_72_0.time_nickname or 0) + 3 > os.time() then
		balloon_message_with_sound("nickname.check_wait_seconds")
	else
		arg_72_0.time_nickname = os.time()
		
		query("clan_user_search", {
			type = 1,
			search = var_72_0
		})
	end
end

ClanEmblem = {}

copy_functions(ScrollView, ClanEmblem)

function ClanEmblem.show(arg_73_0, arg_73_1)
	local var_73_0 = Dialog:open("wnd/clan_edit_emblem", arg_73_0)
	
	arg_73_1 = arg_73_1 or SceneManager:getDefaultLayer()
	
	arg_73_1:addChild(var_73_0)
	
	arg_73_0.vars = {}
	arg_73_0.vars.wnd = var_73_0
	
	local var_73_1 = Clan:getClanInfo()
	
	arg_73_0.vars.scrollview = var_73_0:getChildByName("scrollview")
	arg_73_0.vars.selected_id = GAME_STATIC_VARIABLE.emblem_default_id
	
	if var_73_1 and Account:getClanId() then
		local var_73_2 = ClanEdit:getUpdateList() or {}
		
		arg_73_0.vars.selected_id = var_73_2.emblem or ClanUtil:getEmblemID(var_73_1)
	elseif ClanJoin:isCreatePopupShow() then
		arg_73_0.vars.selected_id = ClanJoin:getSelectedEmblem() or GAME_STATIC_VARIABLE.emblem_default_id
	end
	
	arg_73_0:initScrollView(arg_73_0.vars.scrollview, 135, 135)
	
	arg_73_0.vars.db = {}
	
	for iter_73_0 = 1, 99 do
		local var_73_3, var_73_4, var_73_5, var_73_6, var_73_7, var_73_8, var_73_9, var_73_10, var_73_11 = DBN("clan_emblem", iter_73_0, {
			"id",
			"emblem",
			"unlock_condition",
			"type",
			"material_id",
			"shop_id",
			"token",
			"price",
			"jpn_list_hide"
		})
		
		if not var_73_3 then
			break
		end
		
		local var_73_12 = true
		
		if Account:isJPN() and var_73_11 == "y" then
			var_73_12 = false
		end
		
		if var_73_6 == "emblem" and var_73_7 and var_73_12 then
			local var_73_13 = DBT("clan_material", var_73_7, {
				"id",
				"name",
				"sort",
				"ma_type",
				"icon",
				"grade",
				"desc_category",
				"desc"
			})
			local var_73_14 = var_73_5 and Clan:getItemCount(var_73_7) <= 0
			local var_73_15 = {
				id = var_73_3,
				emblem = var_73_4,
				unlock_condition = var_73_5,
				type = var_73_6,
				material_db = var_73_13,
				is_lock = var_73_14,
				shop_id = var_73_8,
				token = var_73_9,
				price = var_73_10
			}
			
			table.insert(arg_73_0.vars.db, var_73_15)
		end
	end
	
	table.sort(arg_73_0.vars.db, function(arg_74_0, arg_74_1)
		return tonumber(arg_74_0.material_db.sort) < tonumber(arg_74_1.material_db.sort)
	end)
	arg_73_0:createScrollViewItems(arg_73_0.vars.db)
	
	local var_73_16 = ClanEmblem:getInfoById(arg_73_0.vars.selected_id)
	local var_73_17 = ClanEmblem:getIdxById(arg_73_0.vars.selected_id)
	
	arg_73_0:onSelectScrollViewItem(var_73_17, var_73_16)
end

function ClanEmblem.getScrollViewItem(arg_75_0, arg_75_1)
	local var_75_0 = load_dlg("clan_emblem_item", true, "wnd")
	
	var_75_0.emblem = arg_75_1.id
	
	if_set_sprite(var_75_0, "emblem", "emblem/" .. arg_75_1.emblem .. ".png")
	arg_75_0:updateItemUI(var_75_0, arg_75_1)
	
	return var_75_0
end

function ClanEmblem.updateItemUI(arg_76_0, arg_76_1, arg_76_2)
	if_set_visible(arg_76_1, "icon_lock", arg_76_2.is_lock)
	if_set_visible(arg_76_1, "icon_period2", arg_76_2.unlock_condition == "shop" and arg_76_2.is_lock)
	
	if arg_76_2.unlock_condition and arg_76_2.is_lock then
		if_set_opacity(arg_76_1, "emblem", 127.5)
	else
		if_set_opacity(arg_76_1, "emblem", 255)
	end
end

function ClanEmblem.onUpdateScrollViewItemByMaId(arg_77_0, arg_77_1)
	for iter_77_0, iter_77_1 in pairs(arg_77_0.ScrollViewItems) do
		if arg_77_1 == iter_77_1.item.material_db.id then
			if Clan:getItemCount(arg_77_1) >= 1 then
				iter_77_1.item.is_lock = nil
			end
			
			arg_77_0:updateItemUI(iter_77_1.control, iter_77_1.item)
		end
	end
end

function ClanEmblem.getInfoById(arg_78_0, arg_78_1)
	for iter_78_0, iter_78_1 in pairs(arg_78_0.ScrollViewItems) do
		if arg_78_1 == iter_78_1.item.id then
			return iter_78_1
		end
	end
end

function ClanEmblem.getIdxById(arg_79_0, arg_79_1)
	for iter_79_0, iter_79_1 in pairs(arg_79_0.ScrollViewItems) do
		if arg_79_1 == iter_79_1.item.id then
			return iter_79_0
		end
	end
end

function ClanEmblem.onSelectScrollViewItem(arg_80_0, arg_80_1, arg_80_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if arg_80_2.item.unlock_condition and arg_80_2.item.is_lock then
		ClanEdit:onSelectPopup(nil, arg_80_2.item)
		
		return 
	end
	
	arg_80_0:getInfoById(arg_80_0.vars.selected_id).control:getChildByName("selected"):setVisible(false)
	arg_80_2.control:getChildByName("selected"):setVisible(true)
	
	arg_80_0.vars.selected_id = arg_80_2.item.id
	
	local var_80_0
	
	if ClanJoin:isCreatePopupShow() then
		ClanJoin:updateClanEmblem({
			emblem = ClanEmblem:getSelectEmblemId()
		})
		
		var_80_0 = ClanJoin:getSelectedEmblemBG()
	elseif ClanEdit:isShow() then
		ClanEdit:updateClanEmblem(ClanEmblem:getSelectEmblemId())
		
		var_80_0 = ClanEdit:getSelectedEmblemBG()
	end
	
	if_set_sprite(arg_80_0.vars.wnd, "emblem", "emblem/" .. arg_80_2.item.emblem .. ".png")
	
	if ClanEmblemBG:isOpenSystem() then
		local var_80_1 = DB("clan_emblem", tostring(var_80_0), "emblem")
		
		if var_80_1 then
			if_set_sprite(arg_80_0.vars.wnd, "emblem_bg", "emblem/" .. var_80_1 .. ".png")
		end
	else
		var_80_0 = nil
	end
	
	if_set_visible(arg_80_0.vars.wnd, "emblem_bg", var_80_0 ~= nil)
	if_set(arg_80_0.vars.wnd, "emblem_title", T(arg_80_2.item.material_db.name))
	if_set(arg_80_0.vars.wnd, "emblem_disc", T(arg_80_2.item.material_db.desc))
end

function ClanEmblem.getSelectEmblemId(arg_81_0)
	if arg_81_0.vars and arg_81_0.vars.selected_id then
		return arg_81_0.vars.selected_id
	end
end

function ClanEmblem.clear(arg_82_0)
end

ClanEmblemBG = {}

copy_functions(ScrollView, ClanEmblemBG)

function ClanEmblemBG.show(arg_83_0, arg_83_1)
	arg_83_0.vars = {}
	arg_83_0.vars.db = {}
	
	for iter_83_0 = 1, 99 do
		local var_83_0, var_83_1, var_83_2, var_83_3, var_83_4, var_83_5, var_83_6, var_83_7, var_83_8 = DBN("clan_emblem", iter_83_0, {
			"id",
			"emblem",
			"unlock_condition",
			"type",
			"material_id",
			"shop_id",
			"token",
			"price",
			"jpn_list_hide"
		})
		
		if not var_83_0 then
			break
		end
		
		local var_83_9 = true
		
		if Account:isJPN() and var_83_8 == "y" then
			var_83_9 = false
		end
		
		if var_83_3 == "border" and var_83_9 then
			local var_83_10 = DBT("clan_material", var_83_4, {
				"id",
				"name",
				"sort",
				"ma_type",
				"icon",
				"grade",
				"desc_category",
				"desc"
			})
			local var_83_11 = var_83_2 and Clan:getItemCount(var_83_4) <= 0
			local var_83_12 = {
				id = var_83_0,
				emblem = var_83_1,
				unlock_condition = var_83_2,
				type = var_83_3,
				material_db = var_83_10,
				is_lock = var_83_11,
				shop_id = var_83_5,
				token = var_83_6,
				price = var_83_7
			}
			
			table.insert(arg_83_0.vars.db, var_83_12)
		end
	end
	
	table.sort(arg_83_0.vars.db, function(arg_84_0, arg_84_1)
		return tonumber(arg_84_0.material_db.sort) < tonumber(arg_84_1.material_db.sort)
	end)
	
	local var_83_13 = Dialog:open("wnd/clan_edit_emblem", arg_83_0)
	
	arg_83_1 = arg_83_1 or SceneManager:getDefaultLayer()
	
	arg_83_1:addChild(var_83_13)
	
	arg_83_0.vars.wnd = var_83_13
	
	local var_83_14 = Clan:getClanInfo()
	
	arg_83_0.vars.scrollview = var_83_13:getChildByName("scrollview")
	arg_83_0.vars.selected_id = GAME_STATIC_VARIABLE.emblem_bg_default_id
	
	if var_83_14 and Account:getClanId() then
		local var_83_15 = ClanEdit:getUpdateList() or {}
		
		arg_83_0.vars.selected_id = var_83_15.emblem_bg or ClanUtil:getEmblemBGID(var_83_14) or GAME_STATIC_VARIABLE.emblem_bg_default_id
	elseif ClanJoin:isCreatePopupShow() then
		arg_83_0.vars.selected_id = ClanJoin:getSelectedEmblemBG() or GAME_STATIC_VARIABLE.emblem_bg_default_id
	end
	
	arg_83_0:initScrollView(arg_83_0.vars.scrollview, 135, 135)
	table.sort(arg_83_0.vars.db, function(arg_85_0, arg_85_1)
		return tonumber(arg_85_0.id) < tonumber(arg_85_1.id)
	end)
	arg_83_0:createScrollViewItems(arg_83_0.vars.db)
	
	local var_83_16 = ClanEmblemBG:getInfoById(arg_83_0.vars.selected_id)
	local var_83_17 = ClanEmblemBG:getIdxById(arg_83_0.vars.selected_id)
	
	arg_83_0:onSelectScrollViewItem(var_83_17, var_83_16)
end

function ClanEmblemBG.isOpenSystem(arg_86_0)
	if not GAME_STATIC_VARIABLE.emblem_bg_default_id then
		return false
	end
	
	if not DB("clan_emblem", tostring(GAME_STATIC_VARIABLE.emblem_bg_default_id), "id") then
		return false
	end
	
	return true
end

function ClanEmblemBG.getScrollViewItem(arg_87_0, arg_87_1)
	local var_87_0 = load_dlg("clan_emblem_item", true, "wnd")
	
	var_87_0.emblem_bg = arg_87_1.id
	
	if_set_sprite(var_87_0, "emblem", "emblem/" .. arg_87_1.emblem .. ".png")
	arg_87_0:updateItemUI(var_87_0, arg_87_1)
	
	return var_87_0
end

function ClanEmblemBG.updateItemUI(arg_88_0, arg_88_1, arg_88_2)
	if_set_visible(arg_88_1, "icon_banned", arg_88_2.id == GAME_STATIC_VARIABLE.emblem_bg_default_id)
	if_set_visible(arg_88_1, "icon_lock", arg_88_2.is_lock)
	if_set_visible(arg_88_1, "icon_period2", arg_88_2.unlock_condition == "shop" and arg_88_2.is_lock)
	
	if arg_88_2.unlock_condition and arg_88_2.is_lock then
		if_set_opacity(arg_88_1, "emblem", 127.5)
	else
		if_set_opacity(arg_88_1, "emblem", 255)
	end
end

function ClanEmblemBG.onUpdateScrollViewItemByMaId(arg_89_0, arg_89_1)
	for iter_89_0, iter_89_1 in pairs(arg_89_0.ScrollViewItems) do
		if arg_89_1 == iter_89_1.item.material_db.id then
			if Clan:getItemCount(arg_89_1) >= 1 then
				iter_89_1.item.is_lock = nil
			end
			
			arg_89_0:updateItemUI(iter_89_1.control, iter_89_1.item)
		end
	end
end

function ClanEmblemBG.getInfoById(arg_90_0, arg_90_1)
	for iter_90_0, iter_90_1 in pairs(arg_90_0.ScrollViewItems) do
		if arg_90_1 == iter_90_1.item.id then
			return iter_90_1
		end
	end
end

function ClanEmblemBG.getIdxById(arg_91_0, arg_91_1)
	for iter_91_0, iter_91_1 in pairs(arg_91_0.ScrollViewItems) do
		if arg_91_1 == iter_91_1.item.id then
			return iter_91_0
		end
	end
end

function ClanEmblemBG.onSelectScrollViewItem(arg_92_0, arg_92_1, arg_92_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if arg_92_2.item.unlock_condition and arg_92_2.item.is_lock then
		ClanEdit:onSelectPopup(nil, arg_92_2.item)
		
		return 
	end
	
	arg_92_0:getInfoById(arg_92_0.vars.selected_id).control:getChildByName("selected"):setVisible(false)
	arg_92_2.control:getChildByName("selected"):setVisible(true)
	
	arg_92_0.vars.selected_id = arg_92_2.item.id
	
	local var_92_0
	
	if ClanJoin:isCreatePopupShow() then
		ClanJoin:updateClanEmblemBG({
			emblem_bg = ClanEmblemBG:getSelectEmblemId()
		})
		
		var_92_0 = ClanJoin:getSelectedEmblem()
	elseif ClanEdit:isShow() then
		ClanEdit:updateClanEmblemBG(ClanEmblemBG:getSelectEmblemId())
		
		var_92_0 = ClanEdit:getSelectedEmblem()
	end
	
	local var_92_1 = DB("clan_emblem", tostring(var_92_0), "emblem")
	
	if var_92_1 then
		if_set_sprite(arg_92_0.vars.wnd, "emblem", "emblem/" .. var_92_1 .. ".png")
	end
	
	if arg_92_2.item.emblem then
		if_set_sprite(arg_92_0.vars.wnd, "emblem_bg", "emblem/" .. arg_92_2.item.emblem .. ".png")
	end
	
	if_set(arg_92_0.vars.wnd, "emblem_title", T(arg_92_2.item.material_db.name))
	if_set(arg_92_0.vars.wnd, "emblem_disc", T(arg_92_2.item.material_db.desc))
end

function ClanEmblemBG.getSelectEmblemId(arg_93_0)
	if arg_93_0.vars and arg_93_0.vars.selected_id then
		return arg_93_0.vars.selected_id
	end
end

function ClanEmblemBG.clear(arg_94_0)
end

ClanAttendance = {}

function ClanAttendance.show(arg_95_0, arg_95_1)
	if not arg_95_0.vars then
		arg_95_0.vars = {}
	end
	
	local var_95_0 = Dialog:open("wnd/clan_home_visittable", arg_95_0)
	
	arg_95_1 = arg_95_1 or SceneManager:getDefaultLayer()
	
	arg_95_1:addChild(var_95_0)
	
	arg_95_0.vars.wnd = var_95_0
	arg_95_0.vars.attendance_db = ClanBase:getDB().attendance
	arg_95_0.vars.atten_max = ClanBase:getDB().atten_max
	
	arg_95_0:updateAttendanceRewardUI()
	SoundEngine:play("event:/ui/popup/tap")
end

function ClanAttendance.updateAttendanceRewardUI(arg_96_0)
	for iter_96_0 = 1, #arg_96_0.vars.attendance_db do
		local var_96_0 = arg_96_0.vars.wnd:getChildByName("n_reward" .. iter_96_0)
		
		if not var_96_0 then
			break
		end
		
		UIUtil:getRewardIcon(nil, arg_96_0.vars.attendance_db[iter_96_0].reward_id1, {
			scale = 0.5,
			parent = var_96_0:getChildByName("item_bg1")
		})
		if_set(var_96_0:getChildByName("item_bg1"), "txt_point", arg_96_0.vars.attendance_db[iter_96_0].reward_count1)
		UIUtil:getRewardIcon(nil, arg_96_0.vars.attendance_db[iter_96_0].reward_id2, {
			scale = 0.5,
			parent = var_96_0:getChildByName("item_bg2")
		})
		if_set(var_96_0:getChildByName("item_bg2"), "txt_point", arg_96_0.vars.attendance_db[iter_96_0].reward_count2)
		UIUtil:getRewardIcon(nil, arg_96_0.vars.attendance_db[iter_96_0].clan_reward_type, {
			scale = 0.5,
			parent = var_96_0:getChildByName("item_bg3")
		})
		if_set(var_96_0:getChildByName("item_bg3"), "txt_point", arg_96_0.vars.attendance_db[iter_96_0].clan_reward_count)
		if_set(var_96_0, "txt_grade", T("clan_atten_visitor_condition", {
			value = arg_96_0.vars.attendance_db[iter_96_0].atten_member
		}))
	end
end

function ClanAttendance.showRewardPopup(arg_97_0, arg_97_1)
	local var_97_0 = Dialog:open("wnd/clan_home_visit", arg_97_0)
	
	arg_97_1 = arg_97_1 or SceneManager:getDefaultLayer()
	
	arg_97_1:addChild(var_97_0)
	
	if not arg_97_0.vars then
		arg_97_0.vars = {}
	end
	
	arg_97_0.vars.reward_wnd = var_97_0
	
	local var_97_1 = Clan:getAttenInfo().y_count or 0
	local var_97_2 = ClanBase.vars.db.attendance
	local var_97_3
	local var_97_4
	
	for iter_97_0, iter_97_1 in pairs(var_97_2) do
		var_97_3 = iter_97_1
		
		if var_97_1 < iter_97_1.atten_member then
			break
		end
		
		var_97_4 = iter_97_1
	end
	
	local var_97_5 = var_97_0:getChildByName("n_show_eff")
	
	if var_97_5 then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_97_5
		})
	end
	
	if not var_97_4 then
		return 
	end
	
	UIUtil:getRewardIcon(var_97_4.reward_count1, var_97_4.reward_id1, {
		parent = arg_97_0.vars.reward_wnd:getChildByName("n_item1")
	})
	UIUtil:getRewardIcon(var_97_4.reward_count2, var_97_4.reward_id2, {
		parent = arg_97_0.vars.reward_wnd:getChildByName("n_item2")
	})
	if_set(arg_97_0.vars.reward_wnd, "txt_count", var_97_1)
	if_set_arrow(arg_97_0.vars.reward_wnd)
	
	if var_97_1 < var_97_3.atten_member then
		upgradeLabelToRichLabel(arg_97_0.vars.reward_wnd, "txt_remain", true):setAlignment(cc.TEXT_ALIGNMENT_CENTER)
		if_set(arg_97_0.vars.reward_wnd, "txt_remain", T("clan_home_visit_next_step", {
			count = var_97_3.atten_member - var_97_1
		}))
	else
		if_set_visible(arg_97_0.vars.reward_wnd, "txt_remain", false)
	end
end

ClanEdit = {}

function ClanEdit.show(arg_98_0, arg_98_1)
	arg_98_0.vars = {}
	arg_98_1 = arg_98_1 or SceneManager:getDefaultLayer()
	arg_98_0.vars.parents = arg_98_1
	arg_98_0.vars.wnd = Dialog:open("wnd/clan_home_edit", arg_98_0, {
		back_func = function()
			arg_98_0:close()
		end
	})
	arg_98_0.vars.update_list = {}
	
	arg_98_1:addChild(arg_98_0.vars.wnd)
	UIUtil:updateClanInfo(arg_98_0.vars.wnd, Clan:getClanInfo(), {
		no_progress = true
	})
	
	arg_98_0.vars.slider_node = arg_98_0.vars.wnd:getChildByName("n_slider")
	arg_98_0.vars.slider = arg_98_0.vars.slider_node:getChildByName("slider")
	
	arg_98_0.vars.slider:addEventListener(Dialog.defaultSliderEventHandler)
	
	local var_98_0 = math.max(Clan:getClanInfo().rank_limit - GAME_CONTENT_VARIABLE.clan_invite_req_rank, 0)
	local var_98_1 = math.ceil(var_98_0 / (GAME_STATIC_VARIABLE.max_account_level - GAME_CONTENT_VARIABLE.clan_invite_req_rank) * 100)
	
	arg_98_0.vars.slider:setPercent(var_98_1)
	
	if Clan:getClanInfo().rank_limit > 0 then
		arg_98_0.vars.slider_node:getChildByName("t_count"):setString(T("rank_count_over_limit", {
			rank = Clan:getClanInfo().rank_limit
		}))
	else
		arg_98_0.vars.slider_node:getChildByName("t_count"):setString(T("no_clan_rank_limit"))
	end
	
	UIUtil:equalizeProgress(arg_98_0.vars.slider_node, {
		per = arg_98_0.vars.slider:getPercent()
	})
	
	function arg_98_0.vars.slider.handler(arg_100_0, arg_100_1, arg_100_2)
		if arg_100_2 == 0 or arg_100_2 == 3 then
			UIUtil:equalizeProgress(arg_98_0.vars.slider_node, {
				per = arg_98_0.vars.slider:getPercent()
			})
			
			local var_100_0 = arg_98_0.vars.slider_node:getChildByName("t_count")
			local var_100_1 = math.ceil(arg_98_0.vars.slider:getPercent() / 100 * (GAME_STATIC_VARIABLE.max_account_level - GAME_CONTENT_VARIABLE.clan_invite_req_rank))
			
			if var_100_1 > 0 then
				var_100_0:setString(T("rank_count_over_limit", {
					rank = var_100_1 + GAME_CONTENT_VARIABLE.clan_invite_req_rank
				}))
			else
				var_100_0:setString(T("no_clan_rank_limit"))
			end
			
			if math.ceil(arg_98_0.vars.slider:getPercent()) == 0 then
				arg_98_0.vars.update_list.rank_limit = 0
			else
				arg_98_0.vars.update_list.rank_limit = var_100_1 + GAME_CONTENT_VARIABLE.clan_invite_req_rank
			end
		end
	end
	
	arg_98_0.vars.intro_input = arg_98_0.vars.wnd:getChildByName("txt_input")
	
	arg_98_0.vars.intro_input:setString(Clan:getClanInfo().intro_msg or "")
	arg_98_0:updateClanEmblem()
	arg_98_0:getUpdateList()
	
	arg_98_0.vars.sorter = Sorter:create(arg_98_0.vars.wnd:getChildByName("n_sorting"), {
		csb_file = "wnd/sorting_1.csb",
		bg_width_x = 334
	})
	
	arg_98_0.vars.sorter:setSorter({
		default_sort_index = Clan:getClanInfo().join_type or 1,
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
		callback_sort = function(arg_101_0, arg_101_1)
			arg_98_0:updateCreatePopupSel(arg_101_1)
		end
	})
	arg_98_0.vars.sorter:sort()
	arg_98_0.vars.sorter:setTextFitWidth(270)
	arg_98_0:updateSelUI()
	
	if not ClanEmblemBG:isOpenSystem() then
		if_set_opacity(arg_98_0.vars.wnd, "btn_bg", 76.5)
	end
	
	ClanTag:updateUISelectAbleTag(arg_98_0.vars.wnd, ClanTag:getClanTagListIncludeTempTag())
end

function ClanEdit.close(arg_102_0)
	ClanTag:removeUpdateTagList()
	BackButtonManager:pop("Dialog.clan_home_edit")
	arg_102_0.vars.wnd:removeFromParent()
end

function ClanEdit.getTagListNode(arg_103_0)
	if not arg_103_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_103_0.vars.wnd) then
		return 
	end
	
	return arg_103_0.vars.wnd:getChildByName("n_tag_list")
end

function ClanEdit.isShow(arg_104_0)
	return arg_104_0.vars and get_cocos_refid(arg_104_0.vars.wnd) and arg_104_0.vars.wnd:isVisible()
end

function ClanEdit.updateSelUI(arg_105_0, arg_105_1)
	arg_105_1 = arg_105_1 or Clan:getClanInfo().join_type
	
	local var_105_0 = table.clone(Clan:getClanInfo())
	
	var_105_0.join_type = arg_105_1
	
	UIUtil:updateClanInfo(arg_105_0.vars.wnd, var_105_0, {
		no_progress = true
	})
end

function ClanEdit.onSelectPopup(arg_106_0, arg_106_1, arg_106_2)
	arg_106_2 = arg_106_2 or {}
	
	local var_106_0 = Dialog:open("wnd/clan_emblem_item_popup", arg_106_0)
	
	arg_106_1 = arg_106_1 or SceneManager:getRunningPopupScene()
	
	arg_106_1:addChild(var_106_0)
	
	local var_106_1 = ClanJoin:isShow()
	
	if_set_visible(var_106_0, "n_not_buy", false)
	if_set_visible(var_106_0, "n_buy", false)
	if_set_visible(var_106_0, "icon_period2", arg_106_2.unlock_condition == "shop" and var_106_1 == false)
	ClanUtil:setSpriteEmblem(var_106_0, arg_106_2.id)
	
	if arg_106_2.is_lock and arg_106_2.unlock_condition == "shop" and var_106_1 == false then
		if arg_106_2.type == "emblem" then
			if_set(var_106_0, "txt_title", T("ui_clan_emblem_popup_purchase_tl"))
		else
			if_set(var_106_0, "txt_title", T("ui_clan_border_popup_purchase_tl"))
		end
	elseif arg_106_2.type == "emblem" then
		if_set(var_106_0, "txt_title", T("ui_clan_emblem_popup"))
	else
		if_set(var_106_0, "txt_title", T("ui_clan_border_popup"))
	end
	
	if_set(var_106_0, "emblem_title", T(arg_106_2.material_db.name))
	if_set(var_106_0, "infor", T(arg_106_2.material_db.desc))
	if_set_arrow(var_106_0, "n_arrow")
end

function ClanEdit.updateClanEmblem(arg_107_0, arg_107_1)
	local var_107_0 = Clan:getClanInfo()
	
	arg_107_1 = arg_107_1 or ClanUtil:getEmblemID(var_107_0)
	
	local var_107_1 = DB("clan_emblem", tostring(arg_107_1), "emblem")
	
	if_set_sprite(arg_107_0.vars.wnd, "emblem", "emblem/" .. var_107_1 .. ".png")
	
	if arg_107_1 == ClanUtil:getEmblemID(var_107_0) then
		arg_107_0.vars.update_list.emblem = nil
		
		return 
	end
	
	arg_107_0.vars.update_list.emblem = arg_107_1
end

function ClanEdit.updateClanEmblemBG(arg_108_0, arg_108_1)
	local var_108_0 = Clan:getClanInfo()
	
	arg_108_1 = arg_108_1 or ClanUtil:getEmblemBGID(var_108_0)
	
	local var_108_1 = DB("clan_emblem", tostring(arg_108_1), "emblem")
	
	if_set_sprite(arg_108_0.vars.wnd, "emblem_bg", "emblem/" .. var_108_1 .. ".png")
	
	if arg_108_1 == ClanUtil:getEmblemBGID(var_108_0) then
		arg_108_0.vars.update_list.emblem_bg = nil
		
		return 
	end
	
	arg_108_0.vars.update_list.emblem_bg = arg_108_1
end

function ClanEdit.updateCreatePopupSel(arg_109_0, arg_109_1)
	arg_109_0.vars.update_list.join_type = math.abs(arg_109_1)
	
	local var_109_0 = table.clone(Clan:getClanInfo())
	
	table.merge(var_109_0, arg_109_0.vars.update_list)
	UIUtil:updateClanInfo(arg_109_0.vars.wnd, var_109_0, {
		no_progress = true,
		no_emblem_update = true
	})
end

function ClanEdit.checkErrUpdateList(arg_110_0)
	local var_110_0 = Clan:getClanInfo()
	local var_110_1 = arg_110_0.vars.wnd:getChildByName("txt_input"):getString()
	
	if check_abuse_filter(var_110_1, ABUSE_FILTER.CHAT) then
		balloon_message_with_sound("invalid_input_word")
		
		return true
	end
	
	if var_110_1 and utf8len(var_110_1) < 2 then
		balloon_message_with_sound("lack_clan_intro_msg_length")
		
		return true
	end
	
	return false
end

function ClanEdit.getUpdateList(arg_111_0)
	local var_111_0 = Clan:getClanInfo()
	local var_111_1 = arg_111_0.vars.wnd:getChildByName("txt_input"):getString()
	
	if var_111_1 ~= var_111_0.intro_msg then
		arg_111_0.vars.update_list.intro_msg = var_111_1
	else
		arg_111_0.vars.update_list.intro_msg = nil
	end
	
	if arg_111_0.vars.update_list.join_type == var_111_0.join_type then
		arg_111_0.vars.update_list.join_type = nil
	end
	
	if arg_111_0.vars.update_list.emblem == var_111_0.emblem then
		arg_111_0.vars.update_list.emblem = nil
	end
	
	return arg_111_0.vars.update_list
end

function ClanEdit.getSelectedEmblem(arg_112_0)
	return arg_112_0.vars.update_list.emblem or ClanUtil:getEmblemID(Clan:getClanInfo())
end

function ClanEdit.getSelectedEmblemBG(arg_113_0)
	return arg_113_0.vars.update_list.emblem_bg or ClanUtil:getEmblemBGID(Clan:getClanInfo())
end

function ClanEdit.updateTagUI(arg_114_0, arg_114_1)
	if not arg_114_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_114_0.vars.wnd) then
		return 
	end
	
	arg_114_0.vars.update_list.tags = arg_114_1
	
	if not ClanTag:isChangeUpdateList(arg_114_0.vars.update_list.tags) then
		arg_114_0.vars.update_list.tags = nil
	end
	
	local var_114_0 = arg_114_0.vars.update_list.tags or ClanTag:getClanTagListIncludeTempTag()
	
	ClanTag:updateUISelectAbleTag(arg_114_0.vars.wnd, var_114_0)
end
