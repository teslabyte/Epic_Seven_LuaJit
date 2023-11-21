ClanWarMemberStatus = {}

function ClanWarMemberStatus.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.filterOpt = 1
	arg_1_0.vars.isDescending = false
	
	arg_1_0:initListView()
	arg_1_0:setListItems()
	
	local var_1_0 = 0
	local var_1_1 = ClanWar:getPvpKeyTokenMax()
	local var_1_2 = 0
	
	for iter_1_0, iter_1_1 in pairs(arg_1_0.vars.datas) do
		if iter_1_1.tower and iter_1_1.remain_token_count then
			var_1_2 = var_1_2 + iter_1_1.remain_token_count
			var_1_0 = var_1_0 + 1
		end
	end
	
	arg_1_0:initFilterUI()
end

function ClanWarMemberStatus.initListView(arg_2_0)
	arg_2_0.vars.listview = ItemListView_v2:bindControl(ClanWarStatusMain:getMemberStatusListview())
	
	local var_2_0 = {
		onUpdate = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = arg_3_3.user_id
			local var_3_1 = arg_3_3.tower
			local var_3_2 = arg_3_3.user_info
			local var_3_3 = arg_3_3.record
			
			UIUtil:getRewardIcon(nil, arg_3_3.user_info.leader_code, {
				no_popup = true,
				scale = 1,
				no_grade = true,
				parent = arg_3_1:getChildByName("mob_icon"),
				border_code = arg_3_3.user_info.border_code
			}):setOpacity(var_3_1 and 255 or 76.5)
			
			local var_3_4 = arg_3_1:getChildByName("n_member")
			
			if_set_visible(var_3_4, "master", Clan:isMaster(var_3_0))
			if_set_visible(var_3_4, "sub_master", arg_3_3.grade == CLAN_GRADE.executives)
			if_set_visible(var_3_4, "cm_icon_check_b", false)
			
			local var_3_5 = arg_3_1:getChildByName("n_place")
			
			if_set_visible(arg_3_1, "n_place", var_3_1)
			if_set_visible(var_3_5, "hp", var_3_1)
			
			if var_3_1 then
				var_3_5:getChildByName("hp"):setScaleX(var_3_1.hp_ratio)
				if_set_opacity(var_3_5, "cm_icon_clan_war" .. var_3_1.type, var_3_1.hp_ratio == 0 and 76.5 or 255)
				
				for iter_3_0 = 1, 3 do
					if_set_visible(var_3_5, "cm_icon_clan_war" .. iter_3_0, var_3_1.type == iter_3_0)
				end
			end
			
			local var_3_6 = getChildByPath(arg_3_1, "n_item/n_info")
			
			if_set(var_3_6, "t_name", var_3_2.name)
			UIUtil:setLevel(var_3_6:getChildByName("n_lv"), var_3_2.level, MAX_ACCOUNT_LEVEL, 2)
			if_set_visible(var_3_6, "t_absent", not var_3_1)
			if_set_visible(arg_3_1, "n_result", var_3_3)
			
			if var_3_3 then
				local var_3_7 = arg_3_1:getChildByName("n_result")
				
				if_set(var_3_7, "t_result_1", T("war_ui_0038", {
					value = var_3_3.win
				}))
				if_set(var_3_7, "t_result_2", T("war_ui_0039", {
					value = var_3_3.lose
				}))
				if_set(var_3_7, "t_result_draw", T("war_ui_0059", {
					value = var_3_3.draw
				}))
				if_set(var_3_7, "t_count", string.format("%d/%d", arg_3_3.remain_token_count, arg_3_3.max_token_count))
				if_set_opacity(var_3_7, "t_result_1", var_3_3.win == 0 and 76.5 or 255)
				if_set_opacity(var_3_7, "t_result_2", var_3_3.lose == 0 and 76.5 or 255)
				if_set_opacity(var_3_7, "t_result_draw", var_3_3.draw == 0 and 76.5 or 255)
				if_set_opacity(var_3_7, "icon_result_1", var_3_3.win == 0 and 76.5 or 255)
				if_set_opacity(var_3_7, "icon_result_2", var_3_3.lose == 0 and 76.5 or 255)
				if_set_opacity(var_3_7, "icon_result_darw", var_3_3.draw == 0 and 76.5 or 255)
				if_set_scale_fit_width(var_3_7, "t_result_draw", 90)
			end
			
			if_set_visible(arg_3_1, "btn_move", var_3_1)
			
			arg_3_1:getChildByName("btn_move").slot = var_3_1 and var_3_1.slot
		end
	}
	
	arg_2_0.vars.listview:setRenderer(load_control("wnd/clan_war_member_status_item.csb"), var_2_0)
end

function ClanWarMemberStatus.initFilterUI(arg_4_0)
	local var_4_0 = ClanWarStatusMain:getMainWnd()
	local var_4_1 = var_4_0:getChildByName("n_sort_wnd"):getChildByName("bg")
	local var_4_2 = var_4_1:getContentSize()
	
	if not arg_4_0.vars.origin_height then
		arg_4_0.vars.origin_height = var_4_2.height
	end
	
	local var_4_3 = 49
	local var_4_4 = 3
	local var_4_5 = 0
	
	var_4_2.height = 76 + var_4_4 * var_4_3 + var_4_5
	
	var_4_1:setContentSize(var_4_2)
	if_set_visible(var_4_0, "n_updown", true)
	if_set_visible(var_4_0, "btn_up", arg_4_0.vars.isDescending)
	if_set_visible(var_4_0, "btn_down", not arg_4_0.vars.isDescending)
	
	local var_4_6 = T("clanwar_status_tab1_sort_item1")
	
	if_set(var_4_0, "txt_cur_sort", var_4_6)
end

function ClanWarMemberStatus.toggleFilter(arg_5_0)
	if not arg_5_0.vars.isToggleShow then
		arg_5_0.vars.isToggleShow = true
	else
		arg_5_0.vars.isToggleShow = not arg_5_0.vars.isToggleShow
	end
	
	local var_5_0 = ClanWarStatusMain:getMainWnd()
	
	if_set_visible(var_5_0, "n_sort", arg_5_0.vars.isToggleShow)
end

function ClanWarMemberStatus.setFilter(arg_6_0, arg_6_1)
	local var_6_0 = ClanWarStatusMain:getMainWnd()
	
	if arg_6_1 == arg_6_0.vars.filterOpt then
		arg_6_0.vars.isDescending = not arg_6_0.vars.isDescending
	else
		arg_6_0.vars.isDescending = false
	end
	
	arg_6_0.vars.filterOpt = arg_6_1
	
	local var_6_1 = var_6_0:getChildByName("btn_sort" .. arg_6_1)
	local var_6_2 = var_6_0:getChildByName("n_sort_cursor")
	
	if get_cocos_refid(var_6_1) and get_cocos_refid(var_6_2) then
		var_6_2:setPosition(var_6_1:getPosition())
	end
	
	if_set_visible(var_6_0, "btn_up", arg_6_0.vars.isDescending)
	if_set_visible(var_6_0, "btn_down", not arg_6_0.vars.isDescending)
	
	local var_6_3 = T("clanwar_status_tab1_sort_item1")
	
	if arg_6_1 == 2 then
		var_6_3 = T("clanwar_status_tab1_sort_item2")
	elseif arg_6_1 == 3 then
		var_6_3 = T("clanwar_status_tab1_sort_item3")
	end
	
	if_set(var_6_0, "txt_cur_sort", var_6_3)
	arg_6_0:toggleFilter()
	arg_6_0:setListItems()
end

local function var_0_0(arg_7_0, arg_7_1)
	if arg_7_0.tower == nil then
		return false
	end
	
	if arg_7_1.tower == nil then
		return true
	end
	
	if ClanWarMemberStatus.vars.isDescending then
		return arg_7_0.tower.type > arg_7_1.tower.type
	else
		return arg_7_0.tower.type < arg_7_1.tower.type
	end
	
	return arg_7_0.tower.slot < arg_7_1.tower.slot
end

local function var_0_1(arg_8_0, arg_8_1)
	if arg_8_0.tower == nil or not arg_8_0.record then
		return false
	end
	
	if arg_8_1.tower == nil or not arg_8_1.record then
		return true
	end
	
	if ClanWarMemberStatus.vars.isDescending then
		if arg_8_0.record.win ~= arg_8_1.record.win then
			return arg_8_0.record.win > arg_8_1.record.win
		elseif arg_8_0.record.draw ~= arg_8_1.record.draw then
			return arg_8_0.record.draw > arg_8_1.record.draw
		elseif arg_8_0.record.lose ~= arg_8_1.record.lose then
			return arg_8_0.record.lose > arg_8_1.record.lose
		end
	elseif arg_8_0.record.lose ~= arg_8_1.record.lose then
		return arg_8_0.record.lose > arg_8_1.record.lose
	elseif arg_8_0.record.draw ~= arg_8_1.record.draw then
		return arg_8_0.record.draw > arg_8_1.record.draw
	elseif arg_8_0.record.win ~= arg_8_1.record.win then
		return arg_8_0.record.win > arg_8_1.record.win
	end
	
	return var_0_0(arg_8_0, arg_8_1)
end

local function var_0_2(arg_9_0, arg_9_1)
	if arg_9_0.tower == nil or not arg_9_0.remain_token_count then
		return false
	end
	
	if arg_9_1.tower == nil or not arg_9_1.remain_token_count then
		return true
	end
	
	if arg_9_0.remain_token_count == arg_9_1.remain_token_count then
		return var_0_0(arg_9_0, arg_9_1)
	end
	
	if ClanWarMemberStatus.vars.isDescending then
		return arg_9_0.remain_token_count < arg_9_1.remain_token_count
	else
		return arg_9_0.remain_token_count > arg_9_1.remain_token_count
	end
end

function ClanWarMemberStatus.setListItems(arg_10_0)
	local var_10_0 = Clan:getMembers()
	
	arg_10_0.vars.datas = {}
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		table.insert(arg_10_0.vars.datas, iter_10_1)
	end
	
	ClanWarStatusMain:getMainWnd():getChildByName("n_no_data"):setVisible(#arg_10_0.vars.datas == 0)
	
	for iter_10_2, iter_10_3 in pairs(arg_10_0.vars.datas) do
		local var_10_1 = ClanWar:userIdToSlot(iter_10_3.user_id)
		
		if var_10_1 then
			iter_10_3.tower = {}
			iter_10_3.tower.slot = var_10_1
			iter_10_3.tower.type = ({
				building = 3,
				tower = 2,
				castle = 1
			})[ClanWarMain:getTowerData(var_10_1).type]
			iter_10_3.tower.hp_ratio = ClanWarMain:getTowerHPRatio(var_10_1)
			
			local var_10_2 = ClanWar:getAttackerInfo(iter_10_3.user_id) or {
				win_count = 0,
				draw_count = 0,
				destroy_score = 0,
				defeat_count = 0
			}
			
			iter_10_3.record = {}
			iter_10_3.record.win = var_10_2.win_count
			iter_10_3.record.lose = var_10_2.defeat_count
			iter_10_3.record.draw = var_10_2.draw_count
			iter_10_3.record.war_point = var_10_2.destroy_score
			iter_10_3.remain_token_count, iter_10_3.max_token_count = ClanWar:getRemainAttackCounter(iter_10_3.user_id)
		else
			iter_10_3.tower = nil
			iter_10_3.record = nil
		end
	end
	
	if arg_10_0.vars.filterOpt == 1 then
		table.sort(arg_10_0.vars.datas, var_0_0)
	elseif arg_10_0.vars.filterOpt == 2 then
		table.sort(arg_10_0.vars.datas, var_0_1)
	elseif arg_10_0.vars.filterOpt == 3 then
		table.sort(arg_10_0.vars.datas, var_0_2)
	end
	
	arg_10_0.vars.listview:removeAllChildren()
	arg_10_0.vars.listview:setDataSource(arg_10_0.vars.datas)
	arg_10_0.vars.listview:jumpToTop()
end

function ClanWarMemberStatus.onLeave(arg_11_0)
	arg_11_0.vars = {}
end
