ClanSupport = {}

local var_0_0 = {}

var_0_0.mine = 1
var_0_0.able = 2
var_0_0.response = 3
var_0_0.complete = 4

function HANDLER.clan_support_request(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ok" then
		local var_1_0, var_1_1, var_1_2 = Account:serverTimeDayLocalDetail()
		local var_1_3 = Clan:getUserMemberInfo()
		
		if ClanSupport:isSupportItemRequestAble() then
			query("clan_request_support_item", {
				item_code = ClanSupportRequest:getRequestSelectItemCode()
			})
			Dialog:close("clan_support_request")
		else
			balloon_message_with_sound("clan_already_support_request")
		end
	end
	
	if arg_1_1 == "btn_close" then
		Dialog:close("clan_support_request")
	end
	
	if string.starts(arg_1_1, "btn_etc_tab") then
		ClanSupportRequest:setCategory(to_n(string.sub(arg_1_1, -1, -1)))
	end
end

function HANDLER.clan_support(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_request" then
		if ClanSupport:isSupportItemRequestAble() then
			ClanSupportRequest:show()
		else
			balloon_message_with_sound("clan_already_support_request")
		end
	end
	
	if arg_2_1 == "btn_support" then
		if AccountData.id == arg_2_0.item.user_id then
			balloon_message_with_sound("clan_request_item_mine")
		elseif arg_2_0.essence then
			ClanSupport:showSupportConfirm(arg_2_0)
		else
			ClanSupport:response_query(arg_2_0)
		end
	end
end

function HANDLER.clan_support_result(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("clan_support_result")
		ClanHome:nextNoti()
	end
end

function HANDLER.clan_support_confirm(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_cancel" then
		Dialog:close("clan_support_confirm")
	elseif arg_4_1 == "btn_support" then
		Dialog:close("clan_support_confirm")
		ClanSupport:response_query(arg_4_0.support_cont)
	end
end

function MsgHandler.clan_request_support_item(arg_5_0)
	balloon_message_with_sound("clan_complete_request_support")
	ClanSupport:addRequestItem(arg_5_0)
	ClanSupport:updateRequestList()
	ClanSupport:updateRequestBtnUI()
	ClanSupport:refreshListView()
	ConditionContentsManager:dispatch("clan.support_req")
end

function MsgHandler.clan_support_info(arg_6_0)
	ClanSupport:updateInfo(arg_6_0)
end

function ErrHandler.clan_response_support_item(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2.err_next_scene and arg_7_1 then
		local var_7_0 = T("clan_response_support_item." .. arg_7_1)
		
		Dialog:msgBox(var_7_0, {
			handler = function()
				SceneManager:nextScene(arg_7_2.err_next_scene)
			end
		})
		
		return 
	end
	
	local var_7_1 = Clan:getUserMemberInfo()
	
	if arg_7_1 == "limit_over_res_contribution_point" then
		balloon_message_with_sound("err_support_limit_over", {
			count = var_7_1.req_contribution_today_score,
			max = GAME_STATIC_VARIABLE.clan_support_daily_limit
		})
	else
		balloon_message_with_sound("clan_response_support_item." .. arg_7_1)
	end
end

function MsgHandler.clan_response_support_item(arg_9_0)
	if arg_9_0.err_msg then
		balloon_message_with_sound(arg_9_0.err_msg)
		
		return 
	end
	
	local var_9_0 = {}
	
	if arg_9_0.request_member_doc then
		ClanSupport:updateInfo(arg_9_0)
		
		local var_9_1 = DB("item_material", arg_9_0.request_member_doc.req_item_code, "name")
		
		var_9_0.title = T("clan_support_success_title")
		var_9_0.desc = T("clan_support_success", {
			user_name = arg_9_0.request_member_doc.user_info.name,
			ma_name = T(var_9_1),
			contribution_count = arg_9_0.response_member_doc.req_contribution_today_score,
			max = GAME_STATIC_VARIABLE.clan_support_daily_limit
		})
		arg_9_0.request_member_doc.user_info = nil
		
		ClanSupport:updateMemberRequestInfo(arg_9_0.request_member_doc)
		
		if arg_9_0.response_member_doc then
			Clan:updateClanUserInfo(arg_9_0.response_member_doc)
			ClanBase:updateClanInfoUI()
		end
		
		ClanSupport:refreshListView()
	end
	
	if arg_9_0.user_item then
		Account:setItem(arg_9_0.user_item)
		ClanSupport:updateInfo(arg_9_0)
	end
	
	ConditionContentsManager:dispatch("clan.support")
	Account:addReward(arg_9_0.rewards, {
		play_reward_data = var_9_0
	})
	Clan:updateInfo(arg_9_0)
end

function ClanSupport.show(arg_10_0, arg_10_1)
	arg_10_0.vars = {}
	arg_10_0.vars.parents = arg_10_1
	arg_10_0.vars.wnd = Dialog:open("wnd/clan_support", arg_10_0, {
		use_backbutton = false
	})
	arg_10_0.vars.info = {}
	arg_10_0.vars.info.request_list = {}
	
	UIUtil:getRewardIcon(nil, "to_honor", {
		parent = arg_10_0.vars.wnd:getChildByName("n_reward")
	})
	if_set_visible(arg_10_0.vars.wnd, "btn_request", false)
	if_set_visible(arg_10_0.vars.wnd, "n_empty", false)
	if_set_visible(arg_10_0.vars.wnd, "n_limit", false)
	query("clan_support_info")
	
	return arg_10_0.vars.wnd
end

function ClanSupport.addRequestItem(arg_11_0, arg_11_1)
	arg_11_0:updateMemberRequestInfo(arg_11_1.request_member_info)
	Clan:updateInfo(arg_11_1)
	arg_11_0:updateRequestList()
	arg_11_0:updateRequestBtnUI()
	arg_11_0:createRequestListView()
end

function ClanSupport.updateInfo(arg_12_0, arg_12_1)
	if not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	if arg_12_1.item_list then
		arg_12_0.vars.info.item_list = arg_12_1.item_list
	end
	
	arg_12_0:updateMemberRequestInfos(arg_12_1.request_list)
	arg_12_0:updateRequestList()
	arg_12_0:updateRequestBtnUI()
	arg_12_0:createRequestListView()
	arg_12_0:updateContribution_todayScoreUI()
end

function ClanSupport.updateContribution_todayScoreUI(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_13_0.vars.wnd, "n_limit", true)
	
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_limit")
	local var_13_1 = Clan:getUserMemberInfo() or {}
	local var_13_2 = var_13_1.req_contribution_today_score
	
	if not var_13_1.contribution_day or var_13_1.contribution_day ~= Account:serverTimeDayLocalDetail() then
		var_13_2 = 0
	end
	
	if_set(var_13_0, "txt_count", var_13_2 .. "/" .. GAME_STATIC_VARIABLE.clan_support_daily_limit)
end

function ClanSupport.updateRequestBtnUI(arg_14_0)
	if_set_visible(arg_14_0.vars.wnd, "btn_request", true)
	
	local var_14_0 = Clan:getUserMemberInfo()
	
	if arg_14_0:isSupportItemRequestAble() then
		if_set_opacity(arg_14_0.vars.wnd, "btn_request", 255)
	else
		if_set_opacity(arg_14_0.vars.wnd, "btn_request", 76.5)
	end
end

function ClanSupport.sortScrollView(arg_15_0)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.info.request_list) do
		local var_15_0 = DB("item_material", iter_15_1.req_item_code, {
			"request_count"
		})
		local var_15_1 = iter_15_1.response_count or 0
		
		if AccountData.id == iter_15_1.user_id then
			iter_15_1.state = var_0_0.mine
		elseif var_15_1 / (var_15_0 or 0) >= 1 then
			iter_15_1.state = var_0_0.complete
		end
	end
	
	table.sort(arg_15_0.vars.info.request_list, function(arg_16_0, arg_16_1)
		local var_16_0 = tonumber(arg_16_0.state) or 999
		local var_16_1 = tonumber(arg_16_1.state) or 999
		
		if var_16_0 == var_16_1 and arg_16_0.request_time and arg_16_1.request_time then
			return arg_16_0.request_time > arg_16_1.request_time
		else
			return var_16_0 < var_16_1
		end
	end)
end

function ClanSupport.isSupportItemRequestAble(arg_17_0)
	local var_17_0, var_17_1, var_17_2 = Account:serverTimeDayLocalDetail()
	local var_17_3 = Clan:getUserMemberInfo()
	
	if not var_17_3.req_item_code and var_17_3.request_day and var_17_3.request_day == var_17_0 then
		return false
	elseif not var_17_3.req_item_code or not var_17_3.request_day or var_17_3.request_day ~= var_17_0 then
		return true
	else
		return false
	end
	
	return false
end

function ClanSupport.updateItemControl(arg_18_0, arg_18_1, arg_18_2)
	if_set(arg_18_1, "user_name", arg_18_2.user_info.name)
	if_set_scale_fit_width_long_word(arg_18_1, "user_name", arg_18_2.user_info.name, 175)
	UIUtil:setLevel(arg_18_1:getChildByName("n_lv"), arg_18_2.user_info.level, MAX_ACCOUNT_LEVEL, 2)
	UIUtil:getRewardIcon(nil, arg_18_2.req_item_code, {
		parent = arg_18_1:getChildByName("n_item")
	})
	UIUtil:getRewardIcon(nil, arg_18_2.user_info.leader_code, {
		no_popup = true,
		scale = 0.85,
		no_grade = true,
		parent = arg_18_1:getChildByName("n_face"),
		border_code = arg_18_2.user_info.border_code
	})
	if_set_visible(arg_18_1, "icon_leader1", Clan:isMaster(arg_18_2.user_id))
	if_set_visible(arg_18_1, "icon_leader2", arg_18_2.grade == CLAN_GRADE.executives)
	
	local var_18_0, var_18_1, var_18_2, var_18_3 = DB("item_material", arg_18_2.req_item_code, {
		"name",
		"request_count",
		"desc_category",
		"ma_type"
	})
	local var_18_4 = arg_18_2.response_count or 0
	
	if_set(arg_18_1, "t_desc", T(var_18_0))
	if_set_scale_fit_width(arg_18_1, "t_desc", 215)
	if_set(arg_18_1, "t_title", T(var_18_2))
	if_set(arg_18_1, "txt", var_18_4 .. "/" .. (var_18_1 or 0))
	
	if arg_18_2.state == var_0_0.complete then
		if_set_color(arg_18_1, "progress", cc.c3b(107, 193, 27))
	else
		if_set_color(arg_18_1, "progress", cc.c3b(146, 109, 62))
	end
	
	if arg_18_2.state == var_0_0.mine then
		if_set_opacity(arg_18_1, "btn_support", 76.5)
		if_set_opacity(arg_18_1, "t_support_count", 76.5)
		if_set(arg_18_1, "t_support_count", T("clan_support_state_mine"))
	end
	
	local var_18_5 = var_18_4 / (var_18_1 or 0)
	
	if_set_percent(arg_18_1, "progress", var_18_5)
	if_set(arg_18_1, "t_have", T("ui_clan_support_item_have_count", {
		count = Account:getItemCount(arg_18_2.req_item_code)
	}))
	if_set_visible(arg_18_1, "btn_support", arg_18_2.state <= var_0_0.able)
	if_set_visible(arg_18_1, "n_cant", arg_18_2.state > var_0_0.able)
	
	local var_18_6 = arg_18_1:getChildByName("btn_support")
	
	var_18_6.item = arg_18_2
	
	if arg_18_2.state == var_0_0.able then
		local var_18_7 = DB("item_material", arg_18_2.req_item_code, "support_count")
		
		var_18_6.item.support_count = var_18_7
		
		if_set(arg_18_1, "t_support_count", T("ui_clan_support_item_btn_support", {
			value = var_18_7
		}))
	end
	
	local var_18_8 = arg_18_1:getChildByName("n_card")
	
	if arg_18_2.state >= var_0_0.response then
		if_set_opacity(var_18_8, nil, 76.5)
	end
	
	if var_18_3 == "essence" then
		var_18_6.essence = true
	end
end

function ClanSupport.getItemList(arg_19_0)
	return arg_19_0.vars.info.item_list or {}
end

function ClanSupport.updateMemberRequestInfos(arg_20_0, arg_20_1)
	if not arg_20_1 then
		return 
	end
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1 or {}) do
		arg_20_0:updateMemberRequestInfo(iter_20_1)
	end
end

function ClanSupport.updateMemberRequestInfo(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0 = Clan:getMembers()
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		if iter_21_1.user_id == arg_21_1.user_id then
			var_21_0[iter_21_0] = merge_table(arg_21_1, iter_21_1)
		end
	end
end

function ClanSupport.updateRequestList(arg_22_0)
	local var_22_0 = Clan:getMembers()
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		local var_22_1 = false
		
		if iter_22_1.req_item_code then
			for iter_22_2, iter_22_3 in pairs(arg_22_0.vars.info.request_list) do
				if iter_22_1.user_id == iter_22_3.user_id then
					local var_22_2 = arg_22_0.vars.info.request_list[iter_22_2].state
					
					arg_22_0.vars.info.request_list[iter_22_2] = iter_22_1
					arg_22_0.vars.info.request_list[iter_22_2].state = var_22_2
					var_22_1 = true
				end
			end
			
			if not var_22_1 then
				table.insert(arg_22_0.vars.info.request_list, iter_22_1)
			end
		end
	end
end

function ClanSupport.refreshListView(arg_23_0)
	arg_23_0.listView:refresh()
end

function ClanSupport.createRequestListView(arg_24_0)
	arg_24_0:sortScrollView()
	
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("listview")
	
	arg_24_0.listView = ItemListView:bindControl(var_24_0)
	
	local var_24_1 = load_control("wnd/clan_support_item.csb")
	
	if var_24_0.STRETCH_INFO then
		local var_24_2 = var_24_0:getContentSize()
		
		resetControlPosAndSize(var_24_1, var_24_2.width, var_24_0.STRETCH_INFO.width_prev)
	end
	
	local var_24_3 = {
		onUpdate = function(arg_25_0, arg_25_1, arg_25_2)
			local var_25_0 = arg_24_0.vars.info.request_list[arg_25_2]
			
			ClanSupport:updateItemControl(arg_25_1, var_25_0)
			
			return var_25_0.id
		end
	}
	local var_24_4 = arg_24_0.vars.info.request_list
	local var_24_5 = {}
	
	for iter_24_0 = 1, #var_24_4 do
		table.insert(var_24_5, iter_24_0)
	end
	
	if_set_visible(arg_24_0.vars.wnd, "n_empty", #var_24_4 <= 0)
	arg_24_0.listView:setRenderer(var_24_1, var_24_3)
	arg_24_0.listView:removeAllChildren()
	arg_24_0.listView:addItems(var_24_5)
	arg_24_0.listView:jumpToTop()
end

function ClanSupport.getRequestItem(arg_26_0)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.info.request_list or {}) do
		if iter_26_1.user_id == AccountData.id then
			return iter_26_1
		end
	end
end

function ClanSupport.response(arg_27_0)
end

function ClanSupport.response_query(arg_28_0, arg_28_1)
	local var_28_0 = Account:getItemCount(arg_28_1.item.req_item_code)
	
	if not var_28_0 or var_28_0 < arg_28_1.item.support_count then
		balloon_message_with_sound("clan_support_lack_currency")
	else
		query("clan_response_support_item", {
			request_user_id = arg_28_1.item.user_id
		})
	end
end

function ClanSupport.showSupportConfirm(arg_29_0, arg_29_1)
	arg_29_0.vars.confirm_wnd = Dialog:open("wnd/clan_support_confirm", arg_29_0)
	
	SceneManager:getDefaultLayer():addChild(arg_29_0.vars.confirm_wnd)
	
	local var_29_0 = arg_29_0.vars.confirm_wnd:getChildByName("n_support")
	local var_29_1 = arg_29_0.vars.confirm_wnd:getChildByName("btn_support")
	
	var_29_1.support_cont = arg_29_1
	
	if_set(var_29_1, "label", T("ui_clan_support_item_btn_support", {
		value = arg_29_1.item.support_count
	}))
	if_set(arg_29_0.vars.confirm_wnd, "user_name", arg_29_1.item.user_info.name)
	UIUtil:setLevel(arg_29_0.vars.confirm_wnd:getChildByName("n_lv"), arg_29_1.item.user_info.level, MAX_ACCOUNT_LEVEL, 2)
	UIUtil:getRewardIcon(arg_29_1.item.support_count, arg_29_1.item.req_item_code, {
		parent = var_29_0:getChildByName("item")
	})
	UIUtil:getRewardIcon(nil, arg_29_1.item.user_info.leader_code, {
		no_popup = true,
		scale = 0.85,
		no_grade = true,
		parent = arg_29_0.vars.confirm_wnd:getChildByName("n_face"),
		border_code = arg_29_1.item.user_info.border_code
	})
	
	local var_29_2, var_29_3 = DB("item_material", arg_29_1.item.req_item_code, {
		"name",
		"desc_category"
	})
	local var_29_4 = T(var_29_2)
	local var_29_5 = T(var_29_3)
	
	if_set(arg_29_0.vars.confirm_wnd, "txt_support", var_29_5)
	if_set(arg_29_0.vars.confirm_wnd, "item_neme", var_29_4)
	if_set(var_29_0, "txt_have", T("ui_clan_support_item_have_count", {
		count = Account:getItemCount(arg_29_1.item.req_item_code)
	}))
end

local var_0_1 = {
	"all",
	"rune",
	"essence",
	"material"
}

ClanSupportRequest = {}

copy_functions(ScrollView, ClanSupportRequest)

function ClanSupportRequest.show(arg_30_0, arg_30_1)
	local var_30_0 = Dialog:open("wnd/clan_support_request", arg_30_0)
	
	arg_30_1 = arg_30_1 or SceneManager:getDefaultLayer()
	
	arg_30_1:addChild(var_30_0)
	
	arg_30_0.vars = {}
	arg_30_0.vars.wnd = var_30_0
	arg_30_0.vars.scrollview = var_30_0:getChildByName("scrollview")
	arg_30_0.vars.selected_id = 1
	
	arg_30_0:initScrollView(arg_30_0.vars.scrollview, 110, 148)
	arg_30_0:setCategory(1)
	SoundEngine:play("event:/ui/popup/tap")
end

function ClanSupportRequest.moveTabSelector(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1 then
		return 
	end
	
	local var_31_0 = arg_31_1:getChildByName("n_selected")
	
	if not var_31_0 then
		return 
	end
	
	local var_31_1 = arg_31_1:getChildByName("n_tab" .. arg_31_2)
	
	if var_31_1 then
		var_31_0:setPositionX(var_31_1:getPositionX())
	end
end

function ClanSupportRequest.setCategory(arg_32_0, arg_32_1)
	arg_32_0.vars.category_tab = var_0_1[arg_32_1]
	
	local var_32_0 = {}
	
	for iter_32_0, iter_32_1 in pairs(ClanSupport:getItemList() or {}) do
		local var_32_1, var_32_2 = DB("item_material", iter_32_1, {
			"ma_type",
			"request_count"
		})
		
		if arg_32_0.vars.category_tab == "all" or var_32_1 == arg_32_0.vars.category_tab then
			table.insert(var_32_0, {
				id = iter_32_1,
				count = var_32_2
			})
		end
	end
	
	arg_32_0:moveTabSelector(arg_32_0.vars.wnd:getChildByName("n_tab"), arg_32_1)
	
	arg_32_0.vars.selected_id = 1
	
	arg_32_0:createScrollViewItems(var_32_0)
	
	if #var_32_0 > 0 then
		arg_32_0.ScrollViewItems[arg_32_0.vars.selected_id].control:getChildByName("n_select"):setVisible(true)
		arg_32_0:updateUI(var_32_0[1].id)
		if_set_visible(arg_32_0.vars.wnd, "n_sel_detail", true)
	else
		if_set_visible(arg_32_0.vars.wnd, "n_sel_detail", false)
	end
end

function ClanSupportRequest.getScrollViewItem(arg_33_0, arg_33_1)
	local var_33_0 = load_control("wnd/inventory_card.csb")
	
	if_set_visible(var_33_0, "icon_type", false)
	if_set_visible(var_33_0, "equip", false)
	if_set_visible(var_33_0, "n_img_value", false)
	if_set_visible(var_33_0, "btn_select", false)
	if_set_visible(var_33_0, "n_select", false)
	if_set_visible(var_33_0, "item_slot", true)
	if_set_visible(var_33_0, "arti_slot", false)
	
	local var_33_1 = var_33_0:getChildByName("bg_item")
	local var_33_2 = UIUtil:getRewardIcon(1, arg_33_1.id, {
		no_count = true,
		no_detail_popup = true,
		parent = var_33_1
	})
	local var_33_3 = var_33_0:getChildByName("txt_value")
	local var_33_4 = var_33_0:getChildByName("n_txt_value")
	
	var_33_4:setVisible(true)
	var_33_3:setString(comma_value(Account:getItemCount(arg_33_1.id)))
	
	local var_33_5 = var_33_3:getContentSize().width
	
	if var_33_5 > 110 then
		var_33_4:setScaleX(110 / var_33_5)
	else
		var_33_4:setScaleX(1)
	end
	
	return var_33_0
end

function ClanSupportRequest.updateUI(arg_34_0, arg_34_1)
	local var_34_0, var_34_1, var_34_2 = DB("item_material", arg_34_1, {
		"request_count",
		"name",
		"desc_category"
	})
	
	UIUtil:getRewardIcon(Account:getItemCount(arg_34_1), arg_34_1, {
		parent = arg_34_0.vars.wnd:getChildByName("n_item")
	})
	if_set(arg_34_0.vars.wnd, "t_name", T(var_34_1))
	if_set(arg_34_0.vars.wnd, "item_category", T(var_34_2))
	if_set(arg_34_0.vars.wnd, "t_count", var_34_0)
end

function ClanSupportRequest.onSelectScrollViewItem(arg_35_0, arg_35_1, arg_35_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	arg_35_0.vars.selected_id = arg_35_1
	
	for iter_35_0, iter_35_1 in pairs(arg_35_0.ScrollViewItems) do
		if arg_35_0.vars.selected_id == iter_35_0 then
			iter_35_1.control:getChildByName("n_select"):setVisible(true)
		else
			iter_35_1.control:getChildByName("n_select"):setVisible(false)
		end
	end
	
	arg_35_0:updateUI(arg_35_2.item.id)
end

function ClanSupportRequest.getRequestSelectItemCode(arg_36_0)
	if arg_36_0.vars and arg_36_0.vars.selected_id then
		return arg_36_0.ScrollViewItems[arg_36_0.vars.selected_id].item.id
	end
end

function ClanSupportRequest.getRequestSelectId(arg_37_0)
	if arg_37_0.vars and arg_37_0.vars.selected_id then
		return arg_37_0.vars.selected_id
	end
end

ClanRequestItemResult = {}

function ClanRequestItemResult.show(arg_38_0, arg_38_1, arg_38_2)
	arg_38_0.vars = {}
	
	local var_38_0 = Dialog:open("wnd/clan_support_result", arg_38_0)
	
	arg_38_0.vars.wnd = var_38_0
	arg_38_1 = arg_38_1 or SceneManager:getDefaultLayer()
	arg_38_0.vars.parent = arg_38_1
	
	arg_38_1:addChild(arg_38_0.vars.wnd)
	
	local var_38_1 = arg_38_2.req_member_doc.req_item_code
	local var_38_2 = arg_38_2.req_member_doc.response_count
	local var_38_3, var_38_4 = DB("item_material", var_38_1, {
		"name",
		"request_count"
	})
	
	var_38_4 = var_38_4 or 0
	
	local var_38_5 = 0
	
	for iter_38_0, iter_38_1 in pairs(arg_38_2.respnose_docs) do
		var_38_5 = var_38_5 + iter_38_1.count
	end
	
	if_set(arg_38_0.vars.wnd, "t_total_count", var_38_5 .. "/" .. var_38_4)
	if_set_arrow(arg_38_0.vars.wnd)
	
	if var_38_4 <= var_38_2 then
		if_set_color(arg_38_0.vars.wnd, "t_total_count", cc.c3b(107, 193, 27))
		arg_38_0.vars.wnd:getChildByName("t_total_count"):enableOutline(cc.c3b(0, 0, 0), 1)
	else
		if_set_color(arg_38_0.vars.wnd, "t_total_count", cc.c3b(255, 120, 0))
		arg_38_0.vars.wnd:getChildByName("t_total_count"):enableOutline(cc.c3b(0, 0, 0), 1)
	end
	
	UIUtil:getRewardIcon(nil, var_38_1, {
		scale = 0.85,
		parent = arg_38_0.vars.wnd:getChildByName("item_node")
	})
	
	for iter_38_2 = 1, 6 do
		local var_38_6 = arg_38_0.vars.wnd:getChildByName("n_user" .. iter_38_2)
		
		if arg_38_2.respnose_docs[iter_38_2] then
			arg_38_0:updateResponseMember(var_38_6, arg_38_2.respnose_docs[iter_38_2])
		else
			var_38_6:setVisible(false)
		end
	end
end

function ClanRequestItemResult.updateResponseMember(arg_39_0, arg_39_1, arg_39_2)
	if_set(arg_39_1, "nickname", arg_39_2.user_info.name)
	UIUtil:getRewardIcon(nil, arg_39_2.user_info.leader_code, {
		no_popup = true,
		scale = 0.8,
		no_grade = true,
		parent = arg_39_1:getChildByName("n_face"),
		border_code = arg_39_2.user_info.border_code
	})
	if_set_visible(arg_39_1, "icon_leader1", arg_39_2.grade == CLAN_GRADE.master)
	if_set_visible(arg_39_1, "icon_leader2", arg_39_2.grade == CLAN_GRADE.executives)
	UIUtil:setLevel(arg_39_1:getChildByName("n__lv"), arg_39_2.user_info.level, MAX_ACCOUNT_LEVEL, 2)
end
