ClanWarStatusMain = {}
ClanWarStatus = {}

function HANDLER.clan_war_status(arg_1_0, arg_1_1)
	if arg_1_1 == "btn1" or arg_1_1 == "btn2" then
		ClanWarStatusMain:selectTab(tonumber(string.sub(arg_1_1, -1, -1)))
	elseif arg_1_1 == "btn_close" then
		ClanWarStatusMain:close()
	elseif arg_1_1 == "btn_loading_more" then
		ClanWarStatus:nextPage()
	elseif arg_1_1 == "btn_toggle" then
		ClanWarMemberStatus:toggleFilter()
	elseif string.find(arg_1_1, "btn_sort") then
		ClanWarMemberStatus:setFilter(tonumber(string.sub(arg_1_1, -1, -1)))
	elseif arg_1_1 == "btn_move" then
		local var_1_0 = ClanWarMain:getTowerData(arg_1_0.slot)
		local var_1_1 = arg_1_0.slot
		local var_1_2 = var_1_0.category
		local var_1_3 = "f_" .. string.sub(var_1_0.category, -1)
		
		UIAction:Add(SEQ(DELAY(500), CALL(function()
			ClanWarMain:focusIn(var_1_2, var_1_3)
		end), DELAY(1000), CALL(function()
			ClanWarDetail:focusIn(ClanWarDetail:convertSlotIdToTowerId(var_1_2, var_1_1))
		end)), SceneManager:getDefaultLayer(), "block")
		ClanWarStatusMain:close()
	end
end

local var_0_0 = 20

function ClanWarStatusMain.open(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1 or SceneManager:getDefaultLayer()
	
	arg_4_0.vars = {}
	arg_4_0.vars.tab = 1
	arg_4_0.vars.wnd = load_dlg("clan_war_status", true, "wnd", function()
		arg_4_0:close()
	end)
	
	var_4_0:addChild(arg_4_0.vars.wnd)
	arg_4_0.vars.wnd:setPositionX(arg_4_0.vars.wnd:getPositionX() - var_4_0:getPositionX())
	arg_4_0.vars.wnd:setPositionY(arg_4_0.vars.wnd:getPositionY() - var_4_0:getPositionY())
	UIUtil:slideOpen(arg_4_0.vars.wnd, arg_4_0.vars.wnd:getChildByName("cm_tooltipbox"), true)
	SoundEngine:play("event:/ui/popup/tap")
	
	arg_4_0.vars.warStatusListview = arg_4_0.vars.wnd:getChildByName("listview")
	arg_4_0.vars.memberStatusListview = arg_4_0.vars.wnd:getChildByName("listview_member")
	
	arg_4_0:selectTab(1)
end

function ClanWarStatusMain.selectTab(arg_6_0, arg_6_1)
	arg_6_0.vars.tab = arg_6_1
	
	arg_6_0:updateUI()
end

function ClanWarStatusMain.updateUI(arg_7_0)
	if arg_7_0.vars.tab == 1 then
		if_set_visible(arg_7_0.vars.wnd:getChildByName("n_top"), "n_member", true)
		if_set_visible(arg_7_0.vars.wnd, "n_sort", false)
		if_set_visible(arg_7_0.vars.wnd, "n_top_title", false)
		if_set_visible(arg_7_0.vars.wnd:getChildByName("tab1"), "bg", true)
		if_set_visible(arg_7_0.vars.wnd:getChildByName("tab2"), "bg", false)
		if_set_visible(arg_7_0.vars.wnd, "listview", false)
		if_set_visible(arg_7_0.vars.wnd, "listview_member", true)
		ClanWarMemberStatus:init()
	else
		if_set_visible(arg_7_0.vars.wnd:getChildByName("n_top"), "n_member", false)
		if_set_visible(arg_7_0.vars.wnd, "n_top_title", true)
		if_set_visible(arg_7_0.vars.wnd:getChildByName("tab1"), "bg", false)
		if_set_visible(arg_7_0.vars.wnd:getChildByName("tab2"), "bg", true)
		if_set_visible(arg_7_0.vars.wnd, "listview", true)
		if_set_visible(arg_7_0.vars.wnd, "listview_member", false)
		ClanWarStatus:init()
	end
end

function ClanWarStatusMain.getMainWnd(arg_8_0)
	return arg_8_0.vars.wnd
end

function ClanWarStatusMain.getWarStatusListview(arg_9_0)
	return arg_9_0.vars.warStatusListview
end

function ClanWarStatusMain.getMemberStatusListview(arg_10_0)
	return arg_10_0.vars.memberStatusListview
end

function ClanWarStatusMain.close(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	UIUtil:slideOpen(arg_11_0.vars.wnd, arg_11_0.vars.wnd:getChildByName("cm_tooltipbox"), false)
	BackButtonManager:pop("clan_war_status")
end

function ClanWarStatus.init(arg_12_0)
	arg_12_0.vars = {}
	arg_12_0.vars.items = {
		{
			time = 0
		}
	}
	arg_12_0.vars.page = -1
	
	arg_12_0:initListView()
	arg_12_0:requestItems(true)
end

function ClanWarStatus.nextPage(arg_13_0)
	arg_13_0:requestItems()
end

function ClanWarStatus.canUpdate(arg_14_0)
	return arg_14_0.vars.page < 5 and not arg_14_0.vars.no_more_update
end

function ClanWarStatus.requestItems(arg_15_0, arg_15_1)
	if not arg_15_0:canUpdate() then
		print("no more update")
		
		return 
	end
	
	arg_15_0.vars.prev_count = 0
	
	if arg_15_0.vars.items then
		arg_15_0.vars.prev_count = table.count(arg_15_0.vars.items)
	end
	
	ClanWar:query("get_battle_log_by_clan", function(arg_16_0)
		arg_16_0 = arg_16_0 or {}
		arg_16_0.logs = arg_16_0.logs or {}
		
		if not arg_16_0.updated then
			balloon_message(T("war_err_msg009"))
			
			return 
		end
		
		arg_15_0.vars.no_more_update = table.count(arg_16_0.logs) == 0 or table.count(arg_16_0.logs) < var_0_0
		arg_15_0.vars.page = arg_16_0.page or 99999
		
		arg_15_0:appendsNotExist(arg_16_0.logs)
		arg_15_0:updateItems()
	end, {
		page_no = arg_15_0.vars.page + 1
	}, nil, arg_15_1)
end

function ClanWarStatus.initListView(arg_17_0)
	arg_17_0.vars.listview = ItemListView_v2:bindControl(ClanWarStatusMain:getWarStatusListview())
	
	local var_17_0 = {
		onUpdate = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			if arg_18_3.time == 0 then
				if_set_visible(arg_18_1, "n_item", false)
				if_set_visible(arg_18_1, "n_loading_more", arg_17_0:canUpdate())
				
				return 
			end
			
			local function var_18_0(arg_19_0, arg_19_1, arg_19_2)
				UIUtil:getRewardIcon(nil, arg_19_1.leader_code, {
					no_popup = true,
					scale = 1,
					no_grade = true,
					parent = arg_19_0:getChildByName("mob_icon"),
					is_enemy = arg_19_2,
					border_code = arg_19_1.border_code
				})
				
				local var_19_0 = getChildByPath(arg_19_0, "n_info")
				
				if_set(var_19_0, "t_name", arg_19_1.name)
				UIUtil:setLevel(var_19_0:getChildByName("n_lv"), arg_19_1.level, MAX_ACCOUNT_LEVEL, 2)
			end
			
			local var_18_1 = arg_18_1:getChildByName("n_item")
			
			var_18_0(var_18_1:getChildByName("n_my"), arg_18_3.user_info, false)
			var_18_0(var_18_1:getChildByName("n_feer"), arg_18_3.enemy_user_info, true)
			
			local var_18_2 = var_18_1:getChildByName("n_result")
			
			local function var_18_3(arg_20_0)
				local var_20_0 = math.floor(arg_20_0 / 60)
				local var_20_1 = math.floor(var_20_0 / 60)
				local var_20_2 = math.floor(var_20_1 / 24)
				local var_20_3 = math.floor(var_20_2 / 30)
				local var_20_4 = math.floor(var_20_2 / 365)
				
				if var_20_4 > 0 then
					return T("remain_year", {
						year = var_20_4
					})
				elseif var_20_3 > 0 then
					return T("remain_month", {
						month = var_20_3
					})
				elseif var_20_2 > 0 then
					return T("remain_day", {
						day = var_20_2
					})
				end
				
				if var_20_1 > 0 and var_20_0 > 0 then
					return T("remain_hour", {
						hour = var_20_1
					}) .. T("remain_min", {
						min = var_20_0 % 60
					})
				elseif var_20_1 > 0 then
					return T("remain_hour", {
						hour = var_20_1
					})
				elseif var_20_0 > 0 then
					return T("remain_min", {
						min = var_20_0
					})
				else
					return T("remain_sec", {
						sec = arg_20_0
					})
				end
			end
			
			UIUserData:call(var_18_2:getChildByName("txt_result"), "SINGLE_WSCALE(160)", {
				origin_scale_x = 0.46
			})
			
			local var_18_4 = math.floor(os.time() - tonumber(arg_18_3.time))
			
			if_set(var_18_2, "t_time", var_18_4 < 60 and T("time_just_before") or T("time_before", {
				time = var_18_3(var_18_4)
			}))
			
			if arg_18_3.battle_type == 0 and arg_18_3.result == 2 then
				if_set(var_18_2, "txt_result", T("war_ui_battleresult_03"))
			elseif arg_18_3.battle_type == 0 and arg_18_3.result == 3 then
				if_set(var_18_2, "txt_result", T("war_ui_battleresult_04"))
			elseif arg_18_3.battle_type == 0 and arg_18_3.result == 4 then
				if_set(var_18_2, "txt_result", T("war_ui_battleresult_06"))
			elseif arg_18_3.battle_type == 1 and arg_18_3.result == 2 then
				if_set(var_18_2, "txt_result", T("war_ui_battleresult_01"))
			elseif arg_18_3.battle_type == 1 and arg_18_3.result == 3 then
				if_set(var_18_2, "txt_result", T("war_ui_battleresult_02"))
			elseif arg_18_3.battle_type == 1 and arg_18_3.result == 4 then
				if_set(var_18_2, "txt_result", T("war_ui_battleresult_05"))
			end
			
			if_set_sprite(var_18_2, "battle_pvp_icon_1", ClanWarUIUtil:getRoundResultIconPath(arg_18_3.battle_type, arg_18_3.round1_result))
			if_set_sprite(var_18_2, "battle_pvp_icon_2", ClanWarUIUtil:getRoundResultIconPath(arg_18_3.battle_type, arg_18_3.round2_result))
		end
	}
	
	arg_17_0.vars.listview:setRenderer(load_control("wnd/clan_war_status_item.csb"), var_17_0)
end

function ClanWarStatus.appendsNotExist(arg_21_0, arg_21_1)
	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		local var_21_0 = iter_21_1.clan_war_battle_uid
		
		if not table.find(arg_21_0.vars.items, function(arg_22_0, arg_22_1)
			return arg_22_1.clan_war_battle_uid == var_21_0
		end) then
			table.push(arg_21_0.vars.items, iter_21_1)
		end
	end
end

function ClanWarStatus.updateItems(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	ClanWarStatusMain:getMainWnd():getChildByName("n_no_data"):setVisible((not arg_23_0.vars.items[1] or not arg_23_0.vars.items[1].slot) and not arg_23_0.vars.items[2])
	table.sort(arg_23_0.vars.items, function(arg_24_0, arg_24_1)
		if arg_24_0.time == arg_24_1.time and arg_24_0.clan_war_battle_uid and arg_24_1.clan_war_battle_uid then
			return arg_24_0.clan_war_battle_uid > arg_24_1.clan_war_battle_uid
		end
		
		return arg_24_0.time > arg_24_1.time
	end)
	arg_23_0.vars.listview:removeAllChildren()
	arg_23_0.vars.listview:setDataSource(arg_23_0.vars.items)
	
	if arg_23_0.vars.page == 0 then
		arg_23_0.vars.listview:jumpToTop()
	else
		arg_23_0.vars.listview:forceDoLayout()
		arg_23_0.vars.listview:jumpToIndex(arg_23_0.vars.prev_count)
	end
end

function ClanWarStatus.onLeave(arg_25_0)
	arg_25_0.vars = {}
end
