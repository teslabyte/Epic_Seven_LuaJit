CoopSharingSort = {}

function CoopSharingSort.greaterThanConnect(arg_1_0, arg_1_1)
	return arg_1_0.login_tm > arg_1_1.login_tm
end

function CoopSharingSort.greaterThanLevel(arg_2_0, arg_2_1)
	return arg_2_0.level > arg_2_1.level
end

function CoopSharingSort.greaterThanRecent(arg_3_0, arg_3_1)
	if arg_3_0.recent_invite ~= arg_3_1.recent_invite then
		return arg_3_0.recent_invite > arg_3_1.recent_invite
	end
	
	return CoopSharingSort.greaterThanConnect(arg_3_0, arg_3_1)
end

CoopSharing = ClassDef()

local var_0_0 = {}

function HANDLER.expedition_ready_sharing(arg_4_0, arg_4_1)
	forEachEventerList(var_0_0, "onHandler", arg_4_0, arg_4_1)
end

function MsgHandler.get_coop_recent_shared_list(arg_5_0)
	forEachEventerList(var_0_0, "onMsgHandler", "get_coop_recent_shared_list", arg_5_0)
end

function MsgHandler.get_coop_friend_shared_list(arg_6_0)
	forEachEventerList(var_0_0, "onMsgHandler", "get_coop_friend_shared_list", arg_6_0)
end

function MsgHandler.get_coop_clan_shared_list(arg_7_0)
	forEachEventerList(var_0_0, "onMsgHandler", "get_coop_clan_shared_list", arg_7_0)
end

function MsgHandler.coop_invite(arg_8_0)
	if not CoopUtil:isValidRtn(arg_8_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	if CoopMission:isRequestInviteAll() then
		CoopMission:responseInviteAll(arg_8_0)
		
		return 
	end
	
	forEachEventerList(var_0_0, "onMsgHandler", "coop_invite", arg_8_0)
end

function CoopSharing.onClose(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.dlg) then
		return 
	end
	
	BackButtonManager:pop("expedition_ready_sharing")
	
	if arg_9_0:isRemainInvitablePeople() then
		CoopUtil:removeSaveInviteAllList(arg_9_0.vars.boss_id)
		CoopMission:updateReadyBtnAll()
	end
	
	arg_9_0.vars.dlg:removeFromParent()
	
	arg_9_0.vars = nil
end

function CoopSharing.onHandler(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_2 == "btn_close" then
		arg_10_0:onClose()
		
		return 
	end
	
	if arg_10_2 == "btn_check_box" then
		local var_10_0 = arg_10_1:getParent():findChildByName("check_box")
		
		if var_10_0.already_invited then
			return 
		end
		
		var_10_0:setSelected(not var_10_0:isSelected())
		
		arg_10_0.vars.invite_select[arg_10_0.vars.current_mode][tostring(var_10_0.id)] = var_10_0:isSelected()
		
		arg_10_0:updateSelectedCount()
		
		return 
	end
	
	if arg_10_2 == "btn_all_check_box" then
		if arg_10_0.vars.data_count == 0 then
			return 
		end
		
		local var_10_1 = arg_10_1:getParent():findChildByName("all_check_box")
		
		var_10_1:setSelected(not var_10_1:isSelected())
		
		for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.invite_select[arg_10_0.vars.current_mode]) do
			if not arg_10_0.vars.origin_data[iter_10_0].already_invited then
				arg_10_0.vars.invite_select[arg_10_0.vars.current_mode][iter_10_0] = var_10_1:isSelected()
			end
		end
		
		arg_10_0.vars.listView:refresh()
		arg_10_0:updateSelectedCount()
		
		return 
	end
	
	if string.starts(arg_10_2, "btn_tab") then
		local var_10_2 = to_n(string.sub(arg_10_2, -1))
		
		arg_10_0:clearSelected(arg_10_0.vars.current_mode)
		
		local var_10_3 = arg_10_0.vars.idx_to_value[var_10_2]
		
		if not arg_10_0.vars.receive_data[var_10_3] then
			if var_10_3 == "clan" then
				if not AccountData.clan_id then
					arg_10_0:setTabVisible(var_10_2)
					arg_10_0:setOriginData({
						list = {}
					}, "clan")
					CoopMission:onMsgGetCoopSharedList({
						list = {}
					}, "clan")
				else
					arg_10_0.vars.get_list_idx = var_10_2
					
					query("get_coop_clan_shared_list", {
						clan_id = AccountData.clan_id,
						boss_id = arg_10_0.vars.boss_id
					})
				end
			elseif var_10_3 == "friend" then
				arg_10_0.vars.get_list_idx = var_10_2
				
				query("get_coop_friend_shared_list", {
					boss_id = arg_10_0.vars.boss_id
				})
			end
		else
			arg_10_0:setTabVisible(var_10_2)
			arg_10_0:setData(arg_10_0.vars.list[var_10_3])
		end
		
		TutorialGuide:procGuide("expedition_invite")
		
		return 
	end
	
	if arg_10_2 == "btn_share" then
		if arg_10_0.vars.select_count == 0 then
			balloon_message_with_sound("expedition_party_call_select")
			
			return 
		end
		
		arg_10_0:offAllCheckBox()
		arg_10_0:query()
	end
end

function CoopSharing.onMsgHandler(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.vars then
		return 
	end
	
	if arg_11_1 == "get_coop_recent_shared_list" then
		arg_11_0:setOriginData(arg_11_2, "recent")
		CoopMission:onMsgGetCoopSharedList(arg_11_2, "recent")
		
		return 
	end
	
	if arg_11_1 == "get_coop_friend_shared_list" then
		if arg_11_0.vars.get_list_idx then
			arg_11_0:setTabVisible(arg_11_0.vars.get_list_idx)
			
			arg_11_0.vars.get_list_idx = nil
		end
		
		arg_11_0:setOriginData(arg_11_2, "friend")
		CoopMission:onMsgGetCoopSharedList(arg_11_2, "friend")
		
		return 
	end
	
	if arg_11_1 == "get_coop_clan_shared_list" then
		if arg_11_0.vars.get_list_idx then
			arg_11_0:setTabVisible(arg_11_0.vars.get_list_idx)
			
			arg_11_0.vars.get_list_idx = nil
		end
		
		arg_11_0:setOriginData(arg_11_2, "clan")
		CoopMission:onMsgGetCoopSharedList(arg_11_2, "clan")
		
		return 
	end
	
	if arg_11_1 == "coop_invite" then
		arg_11_0:openInviteResultDialog(arg_11_2)
		arg_11_0:updateInvitedUsers(arg_11_2)
		
		return 
	end
end

function CoopSharing.constructor(arg_12_0, arg_12_1)
	arg_12_0.vars = {}
	arg_12_0.vars.select_count = 0
	arg_12_0.vars.list = {}
	arg_12_0.vars.invite_select = {}
	arg_12_0.vars.parent = arg_12_1.parent
	arg_12_0.vars.dlg = load_dlg("expedition_ready_sharing", true, "wnd", function()
		arg_12_0:onClose()
	end)
	arg_12_0.vars.current_mode = "recent"
	arg_12_0.vars.mode_empty_strings = {
		friend = "expedition_no_friend",
		recent = "expedition_no_history",
		clan = "expedition_no_clan"
	}
	arg_12_0.vars.boss_id = arg_12_1.boss_id
	arg_12_0.vars.idx_to_value = {
		"recent",
		"friend",
		"clan"
	}
	
	arg_12_0:uiSetting()
	arg_12_0:sortSetting()
	arg_12_0:listViewInit()
	arg_12_0:setData({})
	table.insert(var_0_0, arg_12_0)
	arg_12_0.vars.parent:addChild(arg_12_0.vars.dlg)
	
	if arg_12_1.cache then
		for iter_12_0, iter_12_1 in pairs(arg_12_1.cache) do
			arg_12_0:setOriginData(iter_12_1, iter_12_0, true)
		end
		
		arg_12_0:setData(arg_12_0.vars.list.recent)
	else
		query("get_coop_recent_shared_list", {
			boss_id = arg_12_0.vars.boss_id
		})
	end
	
	arg_12_0:setTabVisible(1)
	arg_12_0:updateSelectedCount()
	TutorialGuide:procGuide("expedition_invite")
end

function CoopSharing.isValid(arg_14_0)
	return arg_14_0.vars ~= nil and get_cocos_refid(arg_14_0.vars.dlg)
end

function CoopSharing.uiSetting(arg_15_0)
	arg_15_0.vars.n_tab = arg_15_0.vars.dlg:findChildByName("n_tab")
	arg_15_0.vars.t_count = arg_15_0.vars.dlg:findChildByName("t_count")
	
	arg_15_0:offAllCheckBox()
end

function CoopSharing.sortSetting(arg_16_0)
	arg_16_0.vars.sorter = Sorter:create(arg_16_0.vars.dlg:findChildByName("n_sort"))
	
	local var_16_0 = {
		{
			name = T("friend_sort_connect"),
			func = CoopSharingSort.greaterThanConnect
		},
		{
			name = T("friend_sort_level"),
			func = CoopSharingSort.greaterThanLevel
		},
		{
			name = T("expedition_recent_sharing"),
			func = CoopSharingSort.greaterThanRecent
		}
	}
	
	arg_16_0.vars.sorter:setSorter({
		default_sort_index = 1,
		menus = var_16_0,
		callback_sort = function(arg_17_0, arg_17_1)
			arg_16_0.vars.listView:refresh()
			arg_16_0.vars.listView:jumpToTop()
		end
	})
	arg_16_0.vars.sorter:setSortVisibleByIdx(3, false)
end

function CoopSharing.offAllCheckBox(arg_18_0)
	arg_18_0.vars.dlg:findChildByName("all_check_box"):setSelected(false)
end

function CoopSharing.setTabVisible(arg_19_0, arg_19_1)
	for iter_19_0 = 1, 3 do
		local var_19_0 = "tab" .. iter_19_0
		local var_19_1 = arg_19_0.vars.n_tab:findChildByName(var_19_0)
		
		if_set_visible(var_19_1, "bg", iter_19_0 == arg_19_1)
	end
	
	arg_19_0.vars.current_mode = arg_19_0.vars.idx_to_value[arg_19_1]
	
	arg_19_0.vars.sorter:setSortVisibleByIdx(3, arg_19_0.vars.current_mode == "recent")
end

function CoopSharing.query(arg_20_0)
	local var_20_0 = CoopMission:getCurrentRoom()
	
	if not var_20_0 then
		return 
	end
	
	local var_20_1 = var_20_0:getBossInfo()
	
	if not var_20_1 then
		return 
	end
	
	local var_20_2 = CoopUtil:getLevelData(var_20_1)
	
	if var_20_1.user_count >= var_20_2.party_max then
		balloon_message_with_sound("expedition_party_call_full")
		
		return 
	end
	
	local var_20_3 = arg_20_0.vars.invite_select[arg_20_0.vars.current_mode]
	local var_20_4 = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_3) do
		if arg_20_0.vars.origin_data[iter_20_0] == nil then
			Log.e("Datasource was nil. Check CoopSharing Data.")
		end
		
		if arg_20_0.vars.origin_data[iter_20_0] and iter_20_1 then
			table.insert(var_20_4, iter_20_0)
		end
	end
	
	arg_20_0.vars.query_mode = arg_20_0.vars.current_mode
	
	query("coop_invite", {
		invitee_list = json.encode(var_20_4),
		boss_id = arg_20_0.vars.boss_id
	})
end

function CoopSharing.setOriginData(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if not arg_21_0.vars.receive_data then
		arg_21_0.vars.receive_data = {}
		arg_21_0.vars.origin_data = {}
	end
	
	arg_21_0.vars.receive_data[arg_21_2] = arg_21_1.list
	
	arg_21_0:makeData(arg_21_2)
	
	if not arg_21_3 then
		arg_21_0:setData(arg_21_0.vars.list[arg_21_2])
	end
end

function CoopSharing.openInviteResultDialog(arg_22_0, arg_22_1)
	CoopUtil:openInviteResultDialog(arg_22_1)
end

function CoopSharing.updateInvitedUsers(arg_23_0, arg_23_1)
	local var_23_0 = {
		"recent",
		"friend",
		"clan"
	}
	
	for iter_23_0, iter_23_1 in pairs(arg_23_1.invited_user_list or {}) do
		local var_23_1 = tostring(iter_23_1)
		
		arg_23_0.vars.origin_data[var_23_1].already_invited = true
		arg_23_0.vars.origin_data[var_23_1].recent_invite = os.time()
		arg_23_0.vars.invite_select[arg_23_0.vars.query_mode][var_23_1] = false
		
		for iter_23_2, iter_23_3 in pairs(var_23_0) do
			if arg_23_0.vars.receive_data[iter_23_3] and arg_23_0.vars.receive_data[iter_23_3][var_23_1] then
				arg_23_0.vars.receive_data[iter_23_3][var_23_1].already_invited = true
				arg_23_0.vars.receive_data[iter_23_3][var_23_1].recent_invite = os.time()
				
				CoopMission:onUpdateCoopSharedList(arg_23_0.vars.receive_data[iter_23_3], iter_23_3)
			end
		end
	end
	
	arg_23_0:makeData("recent")
	arg_23_0:updateSelectableCount(arg_23_0.vars.list[arg_23_0.vars.current_mode])
	arg_23_0:updateSelectedCount()
	
	arg_23_0.vars.query_mode = nil
	
	arg_23_0.vars.listView:refresh()
end

function CoopSharing.setData(arg_24_0, arg_24_1)
	local var_24_0 = table.count(arg_24_1)
	local var_24_1 = arg_24_0.vars.dlg:findChildByName("n_no_data")
	
	if_set_visible(arg_24_0.vars.dlg, "n_no_data", var_24_0 == 0)
	if_set(var_24_1, "label", T(arg_24_0.vars.mode_empty_strings[arg_24_0.vars.current_mode]))
	
	local var_24_2 = arg_24_0.vars.current_mode == "recent" and 3 or 1
	
	arg_24_0.vars.sorter:setItems(arg_24_1)
	
	arg_24_1 = arg_24_0.vars.sorter:sort(var_24_2)
	
	arg_24_0.vars.listView:setDataSource(arg_24_1)
	arg_24_0:updateSelectableCount(arg_24_1)
	arg_24_0:updateSelectedCount()
	arg_24_0:offAllCheckBox()
end

function CoopSharing.makeData(arg_25_0, arg_25_1)
	arg_25_0.vars.list[arg_25_1] = {}
	arg_25_0.vars.invite_select[arg_25_1] = {}
	
	local var_25_0 = CoopMission:getUserList()
	local var_25_1 = {}
	
	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		var_25_1[tostring(iter_25_1.uid)] = true
	end
	
	local var_25_2 = {}
	local var_25_3 = arg_25_0.vars.receive_data[arg_25_1]
	
	for iter_25_2, iter_25_3 in pairs(var_25_3) do
		arg_25_0.vars.invite_select[arg_25_1][tostring(iter_25_3.id)] = false
		
		table.insert(arg_25_0.vars.list[arg_25_1], iter_25_3)
		
		local var_25_4 = #arg_25_0.vars.list[arg_25_1]
		local var_25_5 = arg_25_0.vars.list[arg_25_1][var_25_4]
		
		if not var_25_5.already_invited and arg_25_0.vars.origin_data[iter_25_3.id] then
			var_25_5.already_invited = arg_25_0.vars.origin_data[iter_25_3.id].already_invited
		end
		
		if not var_25_5.already_invited then
			var_25_5.already_invited = var_25_1[tostring(iter_25_3.id)]
		end
	end
	
	for iter_25_4, iter_25_5 in pairs(var_25_3) do
		if arg_25_0.vars.origin_data[iter_25_4] then
			for iter_25_6, iter_25_7 in pairs(iter_25_5) do
				arg_25_0.vars.origin_data[iter_25_4][iter_25_6] = iter_25_7
			end
		else
			arg_25_0.vars.origin_data[iter_25_4] = iter_25_5
		end
	end
end

function CoopSharing.clearSelected(arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.invite_select[arg_26_1]) do
		arg_26_0.vars.invite_select[arg_26_1][iter_26_0] = false
	end
	
	arg_26_0:updateSelectedCount()
end

function CoopSharing.updateSelectedCount(arg_27_0)
	local var_27_0 = 0
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.invite_select[arg_27_0.vars.current_mode] or {}) do
		if iter_27_1 then
			var_27_0 = var_27_0 + 1
		end
	end
	
	local var_27_1 = arg_27_0.vars.dlg:findChildByName("n_bottom")
	
	if_set(var_27_1, "t_count", tostring(var_27_0))
	if_set_visible(var_27_1, "t_count", var_27_0 ~= 0)
	if_set_visible(var_27_1, "t_none", var_27_0 == 0)
	
	arg_27_0.vars.select_count = var_27_0
	
	local var_27_2 = arg_27_0.vars.select_count == 0 and 76.5 or 255
	local var_27_3 = var_27_1:findChildByName("btn_share")
	local var_27_4 = arg_27_0.vars.select_count ~= 0 and " <#6BC11B>(" .. tostring(var_27_0) .. ")</>" or ""
	
	if_set(var_27_3, "label", T("expedition_party_call_all_btn") .. var_27_4)
	UIUserData:call(var_27_3:getChildByName("label"), "RICH_LABEL(true)")
	
	local var_27_5 = arg_27_0.vars.dlg:findChildByName("n_all_check")
	local var_27_6 = var_27_5:findChildByName("all_check_box")
	
	if arg_27_0.vars.data_count <= 0 then
		if_set_opacity(var_27_5, nil, 76.5)
	else
		if_set_opacity(var_27_5, nil, 255)
		
		if var_27_0 >= arg_27_0.vars.data_count then
			var_27_6:setSelected(true)
		else
			var_27_6:setSelected(false)
		end
	end
	
	if_set_opacity(var_27_3, nil, var_27_2)
end

function CoopSharing.isRemainInvitablePeople(arg_28_0)
	local var_28_0 = CoopMission:getUserList() or {}
	local var_28_1 = {}
	
	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		var_28_1[iter_28_1.uid] = true
	end
	
	for iter_28_2, iter_28_3 in pairs(arg_28_0.vars.list) do
		for iter_28_4, iter_28_5 in pairs(iter_28_3) do
			if not iter_28_5.already_invited and not var_28_1[iter_28_5.uid] then
				return true
			end
		end
	end
	
	return false
end

function CoopSharing.updateSelectableCount(arg_29_0, arg_29_1)
	local var_29_0 = 0
	local var_29_1 = CoopMission:getUserList() or {}
	local var_29_2 = {}
	
	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		var_29_2[iter_29_1.uid] = true
	end
	
	for iter_29_2, iter_29_3 in pairs(arg_29_1) do
		if not iter_29_3.already_invited and not var_29_2[iter_29_3.uid] then
			var_29_0 = var_29_0 + 1
		end
	end
	
	local var_29_3 = arg_29_0.vars.dlg:findChildByName("top")
	local var_29_4 = var_29_3:findChildByName("t_count")
	
	if_set(var_29_4, nil, var_29_0)
	
	arg_29_0.vars.data_count = var_29_0
	
	local var_29_5 = var_29_3:findChildByName("t_number_title")
	local var_29_6, var_29_7 = UIUtil:getTextWidthAndPos(var_29_3, "t_number_title")
	local var_29_8 = 4
	local var_29_9 = var_29_7 + var_29_6 + var_29_8
	
	var_29_4:setPositionX(var_29_9)
end

function CoopSharing.onUpdateItem(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = ""
	local var_30_1 = "icon" .. var_30_0
	local var_30_2 = arg_30_1:findChildByName("n_kind"):getChildren()
	
	for iter_30_0, iter_30_1 in pairs(var_30_2) do
		if_set_visible(iter_30_1, nil, iter_30_1:getName() == var_30_1)
	end
	
	if_set(arg_30_1, "txt_name", arg_30_3.name)
	if_set(arg_30_1, "last_time", T("time_before", {
		time = sec_to_string(os.time() - arg_30_3.login_tm, nil, {
			login_tm = true
		})
	}))
	
	local var_30_3 = arg_30_1:findChildByName("talk_small_bg")
	local var_30_4 = arg_30_3.intro_msg or T("friend.default_intro_msg")
	
	if var_30_4 then
		if utf8len(var_30_4) > 30 then
			var_30_4 = utf8sub(var_30_4, 1, 30) .. "..."
		end
		
		if_set(var_30_3, "disc", var_30_4)
	end
	
	set_width_from_node(var_30_3, var_30_3:getChildByName("disc"), {
		add = 40
	})
	
	local var_30_5 = arg_30_1:findChildByName("n_check"):findChildByName("check_box")
	
	var_30_5.id = arg_30_3.id
	var_30_5.already_invited = arg_30_3.already_invited
	
	var_30_5:setSelected(arg_30_0.vars.invite_select[arg_30_0.vars.current_mode][tostring(arg_30_3.id)])
	
	local var_30_6 = UIUtil:numberDigitToCharOffset(arg_30_3.level, 1, 0)
	
	if arg_30_1.level ~= arg_30_3.level then
		UIUtil:warpping_setLevel(arg_30_1, arg_30_3.level, nil, 2, {
			offset_per_char = var_30_6
		})
	end
	
	arg_30_1.level = arg_30_3.level
	
	local var_30_7 = arg_30_1:getChildByName("n_face")
	
	if var_30_7.leader_code ~= arg_30_3.leader_code or var_30_7.border_code ~= arg_30_3.border_code then
		local var_30_8 = arg_30_1:findChildByName("n_face")
		local var_30_9 = var_30_8:findChildByName("light_icon")
		
		if var_30_9 then
			var_30_9:removeFromParent()
		end
		
		local var_30_10 = UIUtil:getLightIcon(arg_30_3.leader_code, arg_30_3.border_code, 1.2)
		
		var_30_8:addChild(var_30_10)
	end
	
	var_30_7.leader_code = arg_30_3.leader_code
	var_30_7.border_code = arg_30_3.border_code
	
	if arg_30_3.already_invited then
		if_set(arg_30_1, "t_check", T("expedition_mode_invite_user"))
		if_set_color(arg_30_1, nil, cc.c3b(88, 88, 88))
	else
		if_set(arg_30_1, "t_check", T("expedition_mode_select"))
		if_set_color(arg_30_1, nil, cc.c3b(255, 255, 255))
	end
end

function CoopSharing.listViewInit(arg_31_0)
	arg_31_0.vars.listView = ItemListView_v2:bindControl(arg_31_0.vars.dlg:findChildByName("listView"))
	
	local var_31_0 = load_control("wnd/expedition_ready_sharing_item.csb")
	local var_31_1 = {
		onUpdate = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
			arg_31_0:onUpdateItem(arg_32_1, arg_32_2, arg_32_3)
		end
	}
	
	arg_31_0.vars.listView:setRenderer(var_31_0, var_31_1)
end

function CoopSharing.destroy(arg_33_0)
	arg_33_0:onClose()
end
