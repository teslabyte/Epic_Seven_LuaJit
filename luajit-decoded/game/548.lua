AmazonPromotionBase = AmazonPromotionBase or {}
AmazonPromotionBase.rewards_scroll_view = {}

function HANDLER.lobby_promotion_amazon(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		AmazonPromotionBase:login()
		
		return 
	end
	
	if arg_1_1 == "btn_detail" then
		AmazonPromotionBase:openDetail()
		
		return 
	end
	
	if arg_1_1 == "btn_close" then
		AmazonPromotionBase:close()
		
		return 
	end
end

function HANDLER.lobby_promotion_amazon_detail(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		AmazonPromotionBase:closeDetail()
		
		return 
	end
end

function AmazonPromotionBase.isOpen(arg_3_0)
	return get_cocos_refid(arg_3_0.main_dlg)
end

function AmazonPromotionBase.refresh(arg_4_0)
	if not EventPlatform:getAmazonCurrentPromotionID() then
		arg_4_0:close()
		
		local var_4_0 = Dialog:msgBox(T("msg_amazon_prime_end_season_desc"), {
			title = T("msg_amazon_prime_end_season_title")
		})
		
		if get_cocos_refid(var_4_0) then
			var_4_0:bringToFront()
		end
		
		return 
	end
	
	AmazonPromotion:getRewards(function(arg_5_0)
		arg_4_0:onGetRewards(arg_5_0)
	end)
	balloon_message(T("msg_amazon_prime_change_count"), nil, nil, {
		delay = 5000
	})
end

function AmazonPromotionBase.open(arg_6_0)
	arg_6_0.vars = {}
	arg_6_0.main_dlg = load_dlg("lobby_promotion_amazon", true, "wnd", function()
		arg_6_0:close()
	end)
	
	arg_6_0.main_dlg:setOpacity(0)
	if_set_sprite(arg_6_0.main_dlg, "amazon_bg", EventPlatform:getAmazonCurrentBannerSprite())
	if_set(arg_6_0.main_dlg, "t_period", "-")
	UIAction:Add(LOG(FADE_IN(250)), arg_6_0.main_dlg, "block")
	SceneManager:getRunningPopupScene():addChild(arg_6_0.main_dlg)
	arg_6_0.main_dlg:bringToFront()
	AmazonPromotion:init()
	copy_functions(ScrollView, arg_6_0.rewards_scroll_view)
	arg_6_0.rewards_scroll_view:initScrollView(arg_6_0.main_dlg:getChildByName("listview_reward"), 700, 108, {
		fit_height = true
	})
	AmazonPromotion:getRewards(function(arg_8_0)
		arg_6_0:onGetRewards(arg_8_0)
	end)
	Singular:event("lwa_window")
	
	local var_6_0 = EventPlatform:getAmazonCurrentRoundRemainTime()
	
	if var_6_0 then
		UIAction:Add(SEQ(DELAY(var_6_0 * 1000), CALL(function()
			arg_6_0:refresh()
		end)), arg_6_0.main_dlg, "AmazonPromotionBase.refresh")
	end
end

function AmazonPromotionBase.login(arg_10_0)
	local var_10_0 = AmazonPromotion:getCurrentRoundData()
	
	if not var_10_0 then
		return 
	end
	
	if var_10_0.is_rewarded then
		balloon_message(T("msg_amazon_prime_already_get_reward"))
		
		return 
	end
	
	if UIAction:Find("login_block") then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(2000)), arg_10_0.main_dlg, "login_block")
	AmazonPromotion:login(function(arg_11_0)
		arg_10_0:onLogout(arg_11_0)
	end, function(arg_12_0)
		arg_10_0:onLogin(arg_12_0)
	end, function(arg_13_0)
		arg_10_0:onReqReward(arg_13_0)
	end)
end

function AmazonPromotionBase.close(arg_14_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(250)), REMOVE()), arg_14_0.main_dlg, "block")
	BackButtonManager:pop("lobby_promotion_amazon")
	
	arg_14_0.vars = {}
end

function AmazonPromotionBase.openDetail(arg_15_0)
	local var_15_0 = EventPlatform:getAmazonCurrentPromotion()
	
	if not var_15_0 then
		return 
	end
	
	arg_15_0.detail_dlg = load_dlg("lobby_promotion_amazon_detail", true, "wnd", function()
		arg_15_0:closeDetail()
	end)
	
	arg_15_0.detail_dlg:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(250)), arg_15_0.detail_dlg, "block")
	SceneManager:getRunningPopupScene():addChild(arg_15_0.detail_dlg)
	arg_15_0.detail_dlg:bringToFront()
	
	local var_15_1 = timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_15_0.start_time,
		end_time = var_15_0.end_time
	})
	
	var_15_1.max_count = EventPlatform:getAmazonCurrentPromotionRoundNum()
	
	if_set(arg_15_0.detail_dlg, "t_info", T("ui_lobby_promotion_amazon_detail_desc", var_15_1))
end

function AmazonPromotionBase.closeDetail(arg_17_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(250)), REMOVE()), arg_17_0.detail_dlg, "block")
	BackButtonManager:pop("lobby_promotion_amazon_detail")
	
	arg_17_0.detail_dlg = nil
end

function AmazonPromotionBase.rewards_scroll_view.getRoundNodeByRound(arg_18_0, arg_18_1)
	if arg_18_0.ScrollViewItems == nil or #arg_18_0.ScrollViewItems == 0 then
		Log.e("AmazonPromotionBase.rewards_scroll_view is not initialized.")
		
		return nil
	end
	
	if arg_18_1 > #arg_18_0.ScrollViewItems then
		return nil
	end
	
	return arg_18_0.ScrollViewItems[arg_18_1].control
end

function AmazonPromotionBase.rewards_scroll_view.updateCurrentItem(arg_19_0)
	local var_19_0 = AmazonPromotion:getCurrentRoundData()
	local var_19_1 = arg_19_0:getRoundNodeByRound(var_19_0.round)
	
	if not get_cocos_refid(var_19_1) then
		return 
	end
	
	arg_19_0:setRoundNode(var_19_1, var_19_0)
end

function AmazonPromotionBase.rewards_scroll_view.setRoundNode(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = T("ui_lobby_promotion_amazon_item_count", {
		count = arg_20_2.round
	})
	
	if_set(arg_20_1, "txt_round", var_20_0)
	if_set(arg_20_1, "txt_inactive", var_20_0)
	if_set(arg_20_1, "txt_start", T("ui_lobby_promotion_amazon_item_start_date", timeToStringDef({
		preceding_with_zeros = true,
		start_time = arg_20_2.start_time
	})))
	if_set(arg_20_1, "txt_end", T("ui_lobby_promotion_amazon_item_end_date", timeToStringDef({
		preceding_with_zeros = true,
		end_time = arg_20_2.end_time
	})))
	
	local var_20_1 = EventPlatform:getAmazonCurrentRound()
	
	if not var_20_1 then
		return 
	end
	
	local var_20_2 = arg_20_1:getChildByName("n_item")
	local var_20_3 = arg_20_1:getChildByName("n_state")
	local var_20_4 = arg_20_2.round == var_20_1
	local var_20_5 = var_20_1 > arg_20_2.round
	local var_20_6 = var_20_1 < arg_20_2.round
	local var_20_7 = arg_20_2.is_rewarded and not var_20_6
	local var_20_8 = var_20_4 and not var_20_7
	
	if_set_visible(arg_20_1, "bg", var_20_4)
	if_set_visible(var_20_2, "txt_round", var_20_8)
	if_set_visible(var_20_2, "txt_inactive", not var_20_8)
	if_set_opacity(var_20_2, "n_info", var_20_4 and 255 or 76.5)
	if_set_opacity(var_20_2, "n_reward", var_20_8 and 255 or 76.5)
	if_set_visible(var_20_3, "n_lock", var_20_6)
	if_set_visible(var_20_3, "n_fail", var_20_5 and not var_20_7)
	if_set_visible(var_20_3, "n_complete", var_20_7)
	
	local var_20_9 = arg_20_1:getChildByName("n_reward")
	local var_20_10 = arg_20_1:getChildByName("n_check")
	
	for iter_20_0, iter_20_1 in pairs(arg_20_2.rewards) do
		local var_20_11 = var_20_9:getChildByName("n_" .. iter_20_0)
		
		arg_20_0:setRewardItemUI(var_20_11, iter_20_1, var_20_7)
		
		local var_20_12 = var_20_10:getChildByName("n_" .. iter_20_0)
		
		if_set_visible(var_20_12, nil, var_20_7)
	end
end

function AmazonPromotionBase.rewards_scroll_view.getScrollViewItem(arg_21_0, arg_21_1)
	local var_21_0 = load_dlg("lobby_promotion_amazon_item", nil, "wnd")
	
	arg_21_0:setRoundNode(var_21_0, arg_21_1)
	
	return var_21_0
end

function AmazonPromotionBase.rewards_scroll_view.setRewardItemUI(arg_22_0, arg_22_1, arg_22_2)
	if not get_cocos_refid(arg_22_1) then
		return 
	end
	
	if not arg_22_2.id then
		return 
	end
	
	local var_22_0 = DB("equip_item", arg_22_2.id, "type") == "artifact"
	local var_22_1 = DB("character", arg_22_2.id, "id") ~= nil
	local var_22_2 = DB("item_set", arg_22_2.set_drop, "id") ~= nil
	local var_22_3
	local var_22_4
	
	if var_22_2 then
		var_22_3 = arg_22_2.set_drop
	else
		var_22_4 = arg_22_2.set_drop
	end
	
	local var_22_5 = {
		tooltip_delay = 300,
		hero_multiply_scale = 1.06,
		artifact_multiply_scale = 0.63,
		show_equip_count = true,
		scale = 0.8,
		parent = arg_22_1,
		no_popup = var_22_1 and arg_22_2.is_rewardable,
		grade_rate = arg_22_2.grade_rate,
		set_fx = var_22_3,
		set_drop = var_22_4,
		no_bg = string.starts(arg_22_2.id, "ma_bg"),
		no_grade = var_22_0
	}
	local var_22_6 = UIUtil:getRewardIcon(arg_22_2.count, arg_22_2.id, var_22_5)
	
	if var_22_0 then
		local var_22_7 = var_22_6:findChildByName("txt_small_count")
		
		if get_cocos_refid(var_22_7) then
			var_22_7:setScale(1.4)
		end
	end
end

function AmazonPromotionBase.onLogin(arg_23_0, arg_23_1)
	print(AmazonPromotion.TAG, arg_23_1.result)
	
	if arg_23_1.result == "ok" then
		balloon_message(T("msg_amazon_prime_data_receive"))
		
		return 
	end
	
	Log.e("amazon_login_fail", arg_23_1.result, Account:getAccountNumberDescString())
	Singular:event("amazon_login_fail", "result", arg_23_1.result, "account", Account:getAccountNumberDescString())
	
	if arg_23_1.result == "Invalid API Key" then
		local var_23_0 = Dialog:msgBox(arg_23_1.result)
		
		if get_cocos_refid(var_23_0) then
			var_23_0:bringToFront()
		end
		
		return 
	end
	
	local var_23_1 = Dialog:msgBox(arg_23_1.result .. "\n\n" .. T("msg_amazon_prime_invalid_account_desc"), {
		title = T("msg_amazon_prime_invalid_account_title")
	})
	
	if get_cocos_refid(var_23_1) then
		var_23_1:bringToFront()
	end
end

function AmazonPromotionBase.onLogout(arg_24_0, arg_24_1)
	print(AmazonPromotion.TAG, arg_24_1.result)
	
	if arg_24_1.result == "ok" or arg_24_1.result == "not login status" then
		return 
	end
end

function AmazonPromotionBase.onReqReward(arg_25_0, arg_25_1)
	if arg_25_1.res == "err" then
		local var_25_0 = arg_25_1.err_msg
		local var_25_1 = {}
		
		if arg_25_1.err_msg == "duplication reward" then
			var_25_0 = T("msg_amazon_prime_already_get_desc")
			var_25_1 = {
				title = T("msg_amazon_prime_already_get_title")
			}
		elseif arg_25_1.err_msg == "invalid prime user" then
			var_25_0 = T("msg_amazon_prime_not_prime_desc")
			var_25_1 = {
				title = T("msg_amazon_prime_not_prime_title")
			}
		end
		
		local var_25_2 = Dialog:msgBox(var_25_0, var_25_1)
		
		if get_cocos_refid(var_25_2) then
			var_25_2:bringToFront()
		end
		
		return 
	end
	
	if arg_25_1.res == "ok" then
		AccountData.mails = arg_25_1.mail_list
		
		TopBarNew:updateMailMark()
		
		Lobby.last_mail_check_time = os.time()
		
		local var_25_3 = Dialog:msgRewards(T("msg_amazon_prime_get_reward_desc"), {
			rewards = {
				{
					token = arg_25_1.item_code,
					count = arg_25_1.item_count
				}
			},
			title = T("msg_amazon_prime_get_reward_title")
		})
		
		if get_cocos_refid(var_25_3) then
			var_25_3:bringToFront()
		end
		
		arg_25_0.rewards_scroll_view:updateCurrentItem()
		
		return 
	end
end

function AmazonPromotionBase.onGetRewards(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	local var_26_0 = table.count(arg_26_1)
	
	if var_26_0 == 0 then
		return 
	end
	
	arg_26_0.rewards_scroll_view:createScrollViewItems(arg_26_1)
	
	local var_26_1 = arg_26_1[var_26_0]
	local var_26_2 = T("ui_lobby_promotion_amazon_end_date", timeToStringDef({
		preceding_with_zeros = true,
		end_time = var_26_1.end_time
	}))
	
	if_set(arg_26_0.main_dlg, "t_period", var_26_2)
	
	local var_26_3 = EventPlatform:getAmazonCurrentRound()
	
	if not var_26_3 then
		return 
	end
	
	arg_26_0.rewards_scroll_view:scrollToIndex(var_26_3)
end
