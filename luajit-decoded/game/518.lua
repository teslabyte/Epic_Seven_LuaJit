function MsgHandler.clan_donate(arg_1_0)
	if arg_1_0.contribution_info then
		local var_1_0 = Clan:getMemberDonateCount(arg_1_0.contribution_info.item_code)
		
		Clan:updateCurrencies(arg_1_0)
		
		local var_1_1 = DB("clan_donate", arg_1_0.contribution_info.item_code, "name")
		local var_1_2 = {
			title = T("clan_donate_success_title"),
			desc = T("clan_donate_success", {
				to_name = T(var_1_1)
			})
		}
		
		Account:addReward(arg_1_0, {
			play_reward_data = var_1_2
		})
		Clan:updateInfo(arg_1_0)
		
		if arg_1_0.contribution_info.count - var_1_0 > 0 then
			ConditionContentsManager:dispatch("clan.donate", {
				code = arg_1_0.contribution_info.item_code,
				count = arg_1_0.contribution_info.count - var_1_0
			})
		end
	end
end

ClanDonate = {}

copy_functions(ScrollView, ClanDonate)

function ClanDonate.show(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.parents = arg_2_1
	arg_2_0.vars.wnd = load_dlg("clan_give", true, "wnd")
	
	arg_2_0:initDB()
	
	for iter_2_0 = 1, 2 do
		local var_2_0 = arg_2_0.vars.wnd:getChildByName("n_donate_card" .. iter_2_0)
		local var_2_1 = arg_2_0.vars.donate_db[iter_2_0]
		
		if get_cocos_refid(var_2_0) and var_2_1 then
			local var_2_2 = load_dlg("clan_donate_item", true, "wnd")
			
			var_2_0:addChild(var_2_2)
			var_2_2:setAnchorPoint(0, 0)
			var_2_2:setPosition(0, 0)
			arg_2_0:updateDonateUI(var_2_2, var_2_1)
		end
	end
	
	return arg_2_0.vars.wnd
end

function ClanDonate.initDB(arg_3_0)
	arg_3_0.vars.donate_db = {}
	
	for iter_3_0 = 1, 99 do
		local var_3_0, var_3_1, var_3_2, var_3_3, var_3_4, var_3_5, var_3_6, var_3_7, var_3_8, var_3_9, var_3_10, var_3_11 = DBN("clan_donate", iter_3_0, {
			"id",
			"name",
			"sort",
			"popup_title",
			"donate_count_until_reset",
			"increase_count",
			"donated_type",
			"donated_detail",
			"donated_count",
			"reward_token",
			"reward_count",
			"reset_time"
		})
		
		if not var_3_0 then
			break
		end
		
		local var_3_12 = {
			id = var_3_0,
			name = var_3_1,
			sort = var_3_2,
			popup_title = var_3_3,
			donate_count_until_reset = var_3_4,
			increase_count = var_3_5,
			donated_type = var_3_6,
			donated_detail = var_3_7,
			donated_count = var_3_8,
			reward_token = var_3_9,
			reward_count = var_3_10,
			reset_time = var_3_11
		}
		
		table.insert(arg_3_0.vars.donate_db, var_3_12)
	end
end

function ClanDonate.updateDonateUI(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = string.split(arg_4_2.id, "_")
	
	if_set(arg_4_1, "t_now_count", T("ui_clan_donate_have_count", {
		count = comma_value(Account:getCurrency(var_4_0[2]))
	}))
	UIUtil:getRewardIcon(nil, arg_4_2.id, {
		show_name = true,
		txt_scale = 0.9,
		scale = 0.85,
		detail = true,
		parent = arg_4_1:getChildByName("n_from_item")
	})
	UIUtil:getRewardIcon(nil, arg_4_2.donated_detail, {
		show_name = true,
		txt_scale = 0.9,
		scale = 0.85,
		detail = true,
		parent = arg_4_1:getChildByName("n_item")
	})
	
	local var_4_1 = ((Clan:getMemberDonateInfo(arg_4_2.id) or {}).count or 0) >= arg_4_2.donate_count_until_reset
	local var_4_2 = (arg_4_2.increase_count or 1) > Account:getPropertyCount(arg_4_2.id)
	
	if_set_visible(arg_4_1, "black_fin", var_4_1)
	if_set_visible(arg_4_1, "btn_go", not var_4_1)
	if_set_opacity(arg_4_1, "btn_go", not (not var_4_1 and not var_4_2) and 76.5 or 255)
	if_set_opacity(arg_4_1, "black_fin", var_4_1 and 76.5 or 255)
	if_set_opacity(arg_4_1, "n_slider", not (not var_4_1 and not var_4_2) and 76.5 or 255)
	
	local var_4_3 = arg_4_1:getChildByName("btn_go")
	
	if var_4_3:isVisible() then
		var_4_3.var_item = arg_4_2
	end
	
	arg_4_0:_updateDonateUI(arg_4_1, arg_4_2)
end

local function var_0_0(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if_set(arg_5_0, "t_count", arg_5_2 .. "/" .. arg_5_3)
	if_set(arg_5_0, "txt_reward_token_count", "+" .. arg_5_2 * arg_5_1.reward_count)
	if_set(arg_5_0, "txt_gold_cur", comma_value(Clan:getCurrency("clangold")))
	
	if arg_5_1.donated_type == "clan_token" then
		if_set(arg_5_0, "txt_gold", "+" .. comma_value(arg_5_2 * arg_5_1.donated_count))
	end
end

function ClanDonate._updateDonateUI(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Clan:getMemberDonateCount(arg_6_2.id)
	local var_6_1 = arg_6_2.increase_count
	local var_6_2 = arg_6_2.increase_count
	local var_6_3 = arg_6_2.donate_count_until_reset - var_6_0
	
	if_set(arg_6_1, "t_title", T(arg_6_2.popup_title))
	
	local var_6_4 = string.split(arg_6_2.id, "_")
	
	if_set(arg_6_1, "t_title_0", T("ui_clan_give_sand_have_count", {
		count = comma_value(Account:getCurrency(var_6_4[2]))
	}))
	if_set(arg_6_1, "t_current_donate_count", T("ui_clan_give_sand_donated_count", {
		count = comma_value(Clan:getMemberDonateCount(arg_6_2.id))
	}))
	UIUtil:getRewardIcon(nil, arg_6_2.reward_token, {
		scale = 0.85,
		parent = arg_6_1:getChildByName("n_member_item")
	})
	
	local var_6_5 = string.split(arg_6_2.donated_detail, "_")
	
	if_set(arg_6_1, "txt_clan_have", T("ui_clan_give_sand_clan_have_count", {
		count = Clan:getCurrency(var_6_5[2])
	}))
	
	local function var_6_6(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = var_6_3 / arg_6_2.increase_count
		
		var_6_1 = arg_7_1 * arg_6_2.increase_count
		
		var_0_0(arg_6_1, arg_6_2, var_6_1, var_6_3)
	end
	
	local var_6_7 = Clan:getMemberDonateInfo(arg_6_2.id)
	local var_6_8 = Account:getPropertyCount(arg_6_2.id) < (var_6_2 or 1)
	local var_6_9 = (not var_6_7 or (var_6_7.count or 0) < arg_6_2.donate_count_until_reset) and not var_6_8
	local var_6_10 = arg_6_1:getChildByName("progress")
	
	var_6_10:addEventListener(Dialog.defaultSliderEventHandler)
	
	var_6_10.handler = var_6_6
	var_6_10.slider_pos = 1
	var_6_10.min = 1
	var_6_10.max = var_6_3 / arg_6_2.increase_count
	
	var_6_10:setMaxPercent(var_6_10.max)
	var_6_10:setPercent(1)
	
	var_6_10.parent = arg_6_1
	
	var_6_10.handler(arg_6_1, var_6_10.slider_pos or 0, 0)
	
	arg_6_1.slider = var_6_10
	
	var_6_10:setTouchEnabled(var_6_9)
	
	local function var_6_11()
		var_6_1 = var_6_1 - var_6_2
		
		var_6_10:setPercent(var_6_10:getPercent() - 1)
		Dialog.defaultSliderEventHandler(var_6_10, 2)
		var_0_0(arg_6_1, arg_6_2, var_6_1, var_6_3)
	end
	
	local function var_6_12()
		var_6_1 = var_6_2
		
		var_6_10:setPercent(var_6_10.min)
		Dialog.defaultSliderEventHandler(var_6_10, 2)
		var_0_0(arg_6_1, arg_6_2, var_6_1, var_6_3)
	end
	
	local function var_6_13()
		local var_10_0 = Account:getPropertyCount(arg_6_2.id)
		
		if arg_6_2.id == "to_gold" then
			var_10_0 = math.floor(var_10_0 / arg_6_2.increase_count) * arg_6_2.increase_count
		end
		
		var_6_1 = var_6_3
		
		local var_10_1 = math.min(var_10_0, var_6_1)
		local var_10_2 = var_10_1 / arg_6_2.increase_count
		
		var_6_10:setPercent(var_10_2)
		Dialog.defaultSliderEventHandler(var_6_10, 2)
		if_set(arg_6_1, "t_count", var_10_1 .. "/" .. var_6_3)
		if_set(arg_6_1, "txt_reward_token_count", "+" .. var_10_1 * arg_6_2.reward_count)
		var_0_0(arg_6_1, arg_6_2, var_10_1, var_6_3)
	end
	
	local function var_6_14()
		if var_6_1 + var_6_2 > var_6_3 then
			return 
		end
		
		var_6_1 = var_6_1 + var_6_2
		
		var_6_10:setPercent(var_6_10:getPercent() + 1)
		Dialog.defaultSliderEventHandler(var_6_10, 2)
		if_set(arg_6_1, "t_count", var_6_1 .. "/" .. var_6_3)
		if_set(arg_6_1, "txt_reward_token_count", "+" .. var_6_1 * arg_6_2.reward_count)
		if_set(arg_6_1, "txt_gold_cur", comma_value(Clan:getCurrency("clangold")))
		
		if arg_6_2.donated_type == "clan_token" then
			if_set(arg_6_1, "txt_gold", "+" .. comma_value(var_6_1 * arg_6_2.donated_count))
		end
	end
	
	local var_6_15 = arg_6_1:getChildByName("btn_plus")
	local var_6_16 = arg_6_1:getChildByName("btn_minus")
	local var_6_17 = arg_6_1:getChildByName("btn_max")
	local var_6_18 = arg_6_1:getChildByName("btn_min")
	
	if get_cocos_refid(var_6_15) and get_cocos_refid(var_6_16) and get_cocos_refid(var_6_17) and get_cocos_refid(var_6_18) then
		var_6_15:addTouchEventListener(function(arg_12_0, arg_12_1)
			if var_6_9 and arg_12_1 == 0 then
				var_6_14()
			end
		end)
		var_6_16:addTouchEventListener(function(arg_13_0, arg_13_1)
			if var_6_9 and arg_13_1 == 0 then
				var_6_11()
			end
		end)
		var_6_17:addTouchEventListener(function(arg_14_0, arg_14_1)
			if var_6_9 and arg_14_1 == 0 then
				var_6_13()
			end
		end)
		var_6_18:addTouchEventListener(function(arg_15_0, arg_15_1)
			if var_6_9 and arg_15_1 == 0 then
				var_6_12()
			end
		end)
	end
	
	local var_6_19 = arg_6_1:getChildByName("btn_go")
	
	if get_cocos_refid(var_6_19) then
		var_6_19:addTouchEventListener(function(arg_16_0, arg_16_1)
			if UIAction:Find("block") then
				return 
			end
			
			if arg_16_1 == 0 then
				if var_6_9 then
					ClanDonate:req_donate(arg_6_2.id, var_6_1)
				elseif not var_6_9 then
					balloon_message_with_sound("clan_donate.lack_currency")
				end
			end
		end)
	end
	
	var_6_10:setPercent(0)
	var_6_13()
end

function ClanDonate.updateUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	for iter_17_0 = 1, 2 do
		local var_17_0 = arg_17_0.vars.wnd:getChildByName("n_donate_card" .. iter_17_0)
		local var_17_1 = arg_17_0.vars.donate_db[iter_17_0]
		
		if get_cocos_refid(var_17_0) and var_17_1 then
			local var_17_2 = Clan:getMemberDonateInfo(var_17_1.id)
			local var_17_3 = var_17_2 and (var_17_2.count or 0) >= var_17_1.donate_count_until_reset
			local var_17_4 = (var_17_1.increase_count or 1) > Account:getPropertyCount(var_17_1.id)
			
			if_set_visible(var_17_0, "black_fin", var_17_3)
			if_set_visible(var_17_0, "btn_go", not var_17_3)
			if_set_opacity(var_17_0, "btn_go", not (not var_17_3 and not var_17_4) and 76.5 or 255)
			if_set_opacity(var_17_0, "n_slider", not (not var_17_3 and not var_17_4) and 76.5 or 255)
			if_set_opacity(var_17_0, "black_fin", var_17_3 and 76.5 or 255)
			
			local var_17_5 = string.split(var_17_1.id, "_")
			
			if_set(var_17_0, "t_now_count", T("ui_clan_donate_have_count", {
				count = comma_value(Account:getCurrency(var_17_5[2]))
			}))
			arg_17_0:updateDonateUI(var_17_0, var_17_1)
		end
	end
end

function ClanDonate.req_donate(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 or not arg_18_2 then
		return 
	end
	
	if arg_18_2 > Account:getPropertyCount(arg_18_1) then
		balloon_message_with_sound("clan_donate.lack_currency")
		
		return 
	end
	
	UIAction:Add(SEQ(DELAY(1000)), arg_18_0.vars.wnd, "block")
	query("clan_donate", {
		donate_id = arg_18_1,
		donate_count = arg_18_2
	})
end
