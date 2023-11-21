SeasonPassBase = SeasonPassBase or {}
SeasonPassBase.vars = {}
SeasonPassBase.scroll_view = {}

function HANDLER.season_pass_base(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_reward" then
		SeasonPassBase:btnReward(arg_1_0)
		
		return 
	end
	
	if arg_1_1 == "btn_get_reward" then
		SeasonPassBase:btnGetReward(SeasonPassBase.vars.season_pass_id)
		
		return 
	end
	
	if arg_1_1 == "btn_rankup_info" then
		if SeasonPass:isPrevSeasonPass(SeasonPassBase.vars.season_pass_id) then
			local var_1_0 = SeasonPass:isModeEpic(SeasonPassBase.vars.season_pass_id)
			
			Dialog:msgBox(T(var_1_0 and "msg_reward_season_point_info" or "msg_reward_substory_point_info"))
			
			return 
		end
		
		SeasonPassRankUpInfo:show(SeasonPassBase.vars.season_pass_id)
		
		return 
	end
	
	if arg_1_1 == "btn_buy_pass" then
		if SeasonPassUnlock:isOpen() then
			return 
		end
		
		local var_1_1 = SeasonPassBase.vars.season_pass_id
		
		if not SeasonPass:isRemainPackage(var_1_1) then
			balloon_message(T("errmsg_season_pass_promotion_limit"))
			
			return 
		end
		
		SeasonPassPromotion:show(var_1_1)
		SeasonPassBase:showNoticePopup(false, false)
		
		return 
	end
	
	if arg_1_1 == "btn_buy_rank" then
		if not SeasonPass:isMaxRank(SeasonPassBase.vars.season_pass_id) then
			SeasonPassBase:showBuyRankUpDialog()
		else
			local var_1_2 = SeasonPass:isModeEpic(SeasonPassBase.vars.season_pass_id)
			
			Dialog:msgBox(T(var_1_2 and "errmsg_season_pass_rank_max_buy" or "errmsg_substory_pass_rank_max_buy"))
		end
		
		return 
	end
	
	if arg_1_1 == "btn_move_reward" then
		SeasonPassBase.scroll_view:scrollToRewardableItem()
		
		if SeasonPass:getLowestRewardableRank(SeasonPassBase.vars.season_pass_id) == nil then
			balloon_message(T("msg_season_pass_reward_get_all"))
		end
		
		return 
	end
	
	if arg_1_1 == "btn_pre" then
		local var_1_3 = SeasonPassBase.vars.season_pass_id
		
		SeasonPassBase:__close()
		SeasonPassBase:__open(SeasonPass:getPreviousSeasonPassID(var_1_3))
		
		return 
	end
	
	if arg_1_1 == "btn_cur" then
		SeasonPassBase:__close()
		SeasonPassBase:__open(SeasonPass:getOpenSeasonID())
		
		return 
	end
end

function HANDLER.season_pass_base_item(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_reward" then
		SeasonPassBase:btnReward(arg_2_0)
		
		return 
	end
end

function SeasonPassBase.btnGetReward(arg_3_0, arg_3_1)
	if not SeasonPass:isRemainReward(arg_3_1) then
		balloon_message(T("reward_get_failed"))
		
		return 
	end
	
	query("get_season_pass_reward", {
		event_id = arg_3_1
	})
end

function SeasonPassBase.btnReward(arg_4_0, arg_4_1)
	if not arg_4_1.season_id then
		return 
	end
	
	if not arg_4_1.rank then
		return 
	end
	
	local var_4_0 = SeasonPass:getRank(SeasonPassBase.vars.season_pass_id)
	local var_4_1 = SeasonPass:getGrade(SeasonPassBase.vars.season_pass_id)
	local var_4_2 = SeasonPass:isModeEpic(SeasonPassBase.vars.season_pass_id)
	local var_4_3 = var_4_0 < arg_4_1.rank
	local var_4_4 = var_4_1 < arg_4_1.grade
	
	if arg_4_1.is_bonus and var_4_4 then
		balloon_message(T(var_4_2 and "err_msg_season_pass_reward_3" or "err_msg_substory_pass_reward_3"))
		
		return 
	end
	
	if var_4_4 then
		return 
	end
	
	if arg_4_1.is_complete and var_4_3 then
		balloon_message(T(var_4_2 and "err_msg_season_pass_reward_2" or "err_msg_substory_pass_reward_2"))
		
		return 
	end
	
	if var_4_3 then
		balloon_message(T(var_4_2 and "err_msg_season_pass_reward_1" or "err_msg_substory_pass_reward_1", {
			num = arg_4_1.rank
		}))
		
		return 
	end
	
	if arg_4_1.is_rewarded == false then
		query("get_season_pass_reward", {
			event_id = arg_4_1.season_id
		})
		
		return 
	end
end

function SeasonPassBase.isVisible(arg_5_0)
	return arg_5_0.vars and get_cocos_refid(arg_5_0.vars.wnd)
end

function SeasonPassBase.__close(arg_6_0)
	UIAction:Remove("SeasonPassBase.season_pass_finish")
	BackButtonManager:pop()
	
	if arg_6_0.vars and get_cocos_refid(arg_6_0.vars.wnd) then
		TopBarNew:pop()
		arg_6_0.vars.wnd:removeFromParent()
		
		arg_6_0.vars.wnd = nil
	end
	
	Dialog:closeAll()
	SeasonPassRankUpInfo:close()
	SeasonPassPromotion:close()
end

function SeasonPassBase.close(arg_7_0, arg_7_1)
	if not arg_7_0:isVisible() then
		return 
	end
	
	arg_7_1 = arg_7_1 or {}
	
	arg_7_0:__close()
	SeasonPass.onRefreshData:remove("season_pass_base")
	SeasonPass.onGetRankReward:remove("season_pass_base")
	SeasonPass.onGetCompleteReward:remove("season_pass_base")
	SeasonPass.onGetBonusReward:remove("season_pass_base")
	SeasonPass.onUpgrade:remove("season_pass_base")
	SeasonPass.onUpdateRankExp:remove("season_pass_base")
	
	if arg_7_0.vars.fn_close then
		arg_7_0.vars.fn_close()
	end
	
	arg_7_0.vars = {}
	
	if arg_7_1.is_expire then
		Dialog:msgBox(T("clan_season_end"))
	end
	
	LuaEventDispatcher:dispatchEvent("invite.event", "reload")
end

function SeasonPassBase.onAddSeasonPassRank(arg_8_0, arg_8_1, arg_8_2)
	SeasonPassRankUpMsgBox:show(arg_8_0.vars.season_pass_id, arg_8_1, arg_8_2)
end

function SeasonPassBase.openSubstoryPass(arg_9_0, arg_9_1)
	local var_9_0 = Account:getSubstoryPassData()
	
	if not var_9_0 then
		return 
	end
	
	arg_9_0:open(var_9_0.id, arg_9_1)
end

function SeasonPassBase.startIntroStory(arg_10_0, arg_10_1, arg_10_2)
	if SeasonPass:isPrevSeasonPass(arg_10_1) then
		return false
	end
	
	local var_10_0 = SeasonPass:getIntroStoryID(arg_10_1)
	
	if not var_10_0 then
		return false
	end
	
	start_new_story(nil, var_10_0, {
		on_finish = arg_10_2
	})
	
	return true
end

function SeasonPassBase.startEndStory(arg_11_0, arg_11_1)
	if SeasonPass:isPrevSeasonPass(arg_11_1) then
		return false
	end
	
	local var_11_0 = SeasonPass:getEndStoryID(arg_11_1)
	
	if not var_11_0 then
		return false
	end
	
	start_new_story(nil, var_11_0)
	
	return true
end

function SeasonPassBase.open(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 then
		return 
	end
	
	if SeasonPass:load(arg_12_1, "last_open_remain_day") == nil and arg_12_0:startIntroStory(arg_12_1, function()
		arg_12_0:_open(arg_12_1, arg_12_2)
	end) then
		return 
	end
	
	LuaEventDispatcher:dispatchEvent("invite.event", "hide")
	arg_12_0:_open(arg_12_1, arg_12_2)
end

function SeasonPassBase._open(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.vars = {}
	arg_14_0.vars.fn_close = arg_14_2
	
	SeasonPass.onRefreshData:add("season_pass_base", function(arg_15_0)
		if get_cocos_refid(arg_14_0.vars.wnd) then
			if SeasonPassBase.vars.season_pass_id == arg_15_0 then
				arg_14_0:updateUI()
			end
		else
			arg_14_0:__open(arg_15_0)
		end
	end)
	SeasonPass.onGetRankReward:add("season_pass_base", function(arg_16_0)
		for iter_16_0 = 0, arg_16_0 do
			arg_14_0:setRankRewardsUI(iter_16_0)
		end
		
		arg_14_0:setGetRewardButton()
	end)
	SeasonPass.onGetCompleteReward:add("season_pass_base", function()
		if not arg_14_0:isRewardedCompleteFreeUI() then
			arg_14_0:startEndStory(arg_14_1)
		end
		
		arg_14_0:setCompleteRewardsUI()
		arg_14_0:setGetRewardButton()
	end)
	SeasonPass.onGetBonusReward:add("season_pass_base", function()
		arg_14_0:setBonusRewardUI()
		arg_14_0:setGetRewardButton()
	end)
	SeasonPass.onAddSeasonPassRank:add("season_pass_base", function(arg_19_0, arg_19_1)
		arg_14_0:onAddSeasonPassRank(arg_19_0, arg_19_1)
		arg_14_0:setGetRewardButton()
	end)
	SeasonPass.onUpgrade:add("season_pass_base", function(arg_20_0)
		if arg_20_0 == arg_14_0.vars.season_pass_id then
			arg_14_0:onUpgrade()
		end
	end)
	SeasonPass.onUpdateRankExp:add("season_pass_base", function()
		arg_14_0:setBuyRankButton()
		arg_14_0:setRewardsUI()
		arg_14_0:setGetRewardButton()
	end)
	query("refresh_season_pass_data", {
		event_id = arg_14_1
	})
end

function SeasonPassBase.updateUI(arg_22_0)
	local var_22_0 = SeasonPass:isPrevSeasonPass(arg_22_0.vars.season_pass_id)
	
	arg_22_0:setSubTitleUI()
	
	local var_22_1 = arg_22_0.vars.wnd:findChildByName("btn_rankup_info")
	
	if get_cocos_refid(var_22_1) then
		if_set_opacity(var_22_1, nil, var_22_0 and 76.5 or 255)
	end
	
	local var_22_2 = getChildByPath(arg_22_0.vars.wnd, "RIGHT/n_not_yet/txt_ex")
	local var_22_3 = arg_22_0.vars.is_epic_mode and T("ui_season_buy_desc") or T("ui_substory_buy_desc")
	
	if_set(var_22_2, nil, var_22_3)
	arg_22_0:setGetRewardButton()
	arg_22_0:setBuyRankButton()
	arg_22_0:setBuySeasonPassButton()
	arg_22_0:setSeasonPassInfoUI()
	arg_22_0:setRewardsUI()
	
	if not SeasonPass:isPrevSeasonPass(arg_22_0.vars.season_pass_id) then
		arg_22_0:showNoticePopup(true, true)
	end
end

function SeasonPassBase.__open(arg_23_0, arg_23_1)
	local var_23_0 = SeasonPass:isOpenSeason(arg_23_1)
	local var_23_1 = 0
	
	if var_23_0 then
		local var_23_2
		local var_23_3, var_23_4, var_23_5
		
		var_23_3, var_23_4, var_23_5, var_23_1 = SeasonPass:getSeasonRemainTime(arg_23_1)
	else
		local var_23_6
		local var_23_7, var_23_8, var_23_9
		
		var_23_7, var_23_8, var_23_9, var_23_1 = SeasonPass:getRewardRemainTime(arg_23_1)
	end
	
	UIAction:Add(SEQ(DELAY(var_23_1 * 1000), CALL(function()
		arg_23_0:close({
			is_expire = true
		})
	end)), arg_23_0, "SeasonPassBase.season_pass_finish")
	
	arg_23_0.vars.season_pass_id = arg_23_1
	arg_23_0.vars.is_epic_mode = SeasonPass:isModeEpic(arg_23_0.vars.season_pass_id)
	arg_23_0.vars.is_rank_type = SeasonPass:isTypeRank(arg_23_0.vars.season_pass_id)
	arg_23_0.vars.wnd = load_dlg("season_pass_base", true, "wnd")
	
	UIAction:Add(DELAY(100), arg_23_0.vars.wnd, "block")
	SceneManager:getRunningPopupScene():addChild(arg_23_0.vars.wnd)
	Announcement:bringToFront()
	
	local var_23_10 = T(arg_23_0.vars.is_epic_mode and "ui_season_title" or "ui_substory_title")
	local var_23_11 = arg_23_0.vars.is_epic_mode and "infoseason" or "infosubstory"
	
	TopBarNew:createFromPopup(var_23_10, arg_23_0.vars.wnd, function()
		arg_23_0:close()
	end, nil, var_23_11)
	TopBarNew:forcedHelp_OnOff(not arg_23_0.vars.is_epic_mode)
	
	local var_23_12 = SeasonPass:getRankRewards(arg_23_0.vars.season_pass_id)
	
	copy_functions(ScrollView, arg_23_0.scroll_view)
	
	local var_23_13 = arg_23_0.vars.wnd:findChildByName("scroll_view_rewards")
	
	var_23_13.STRETCH_INFO = nil
	
	arg_23_0.scroll_view:initScrollView(var_23_13, 105, 430, {
		force_horizontal = true,
		fit_height = true
	})
	arg_23_0.scroll_view:createScrollViewItems(var_23_12)
	arg_23_0.scroll_view:scrollToRewardableItem()
	arg_23_0:setBackground()
	arg_23_0:setPortrait()
	arg_23_0:updateUI()
end

function SeasonPassBase.setGetRewardButton(arg_26_0)
	local var_26_0 = arg_26_0.vars.wnd:findChildByName("btn_get_reward")
	
	if not get_cocos_refid(var_26_0) then
		return 
	end
	
	local var_26_1 = SeasonPass:isRemainReward(arg_26_0.vars.season_pass_id)
	
	if_set_visible(var_26_0, "icon_noti", var_26_1)
end

function SeasonPassBase.setBuyRankButton(arg_27_0)
	local var_27_0 = arg_27_0.vars.wnd:findChildByName("btn_buy_rank")
	local var_27_1 = T("ui_season_buy_purchased")
	local var_27_2 = SeasonPass:isMaxRank(arg_27_0.vars.season_pass_id)
	
	if not var_27_2 then
		var_27_1 = T("ui_season_buy_rank")
		
		if not arg_27_0.vars.is_epic_mode then
			var_27_1 = arg_27_0.vars.is_rank_type and T("ui_substory_buy_rank") or T("ui_substory_buy_achievement")
		end
	end
	
	if_set(var_27_0, "label", var_27_1)
	if_set_opacity(var_27_0, nil, var_27_2 and 76.5 or 255)
end

function SeasonPassBase.setBuySeasonPassButton(arg_28_0)
	local var_28_0 = SeasonPass:isRemainPackage(arg_28_0.vars.season_pass_id)
	local var_28_1 = var_28_0
	local var_28_2 = arg_28_0.vars.wnd:findChildByName("btn_buy_pass")
	
	if_set_opacity(var_28_2, nil, var_28_1 and 255 or 76.5)
	
	local var_28_3 = T("ui_season_buy_purchased")
	
	if var_28_0 then
		var_28_3 = T(arg_28_0.vars.is_epic_mode and "ui_season_buy_common" or "ui_substory_buy_common")
	end
	
	if_set(var_28_2, "label", var_28_3)
end

function SeasonPassBase.setSeasonPassInfoUI(arg_29_0)
	local var_29_0 = arg_29_0.vars.wnd:findChildByName("n_season_info")
	local var_29_1 = SeasonPass:isPrevSeasonPass(arg_29_0.vars.season_pass_id)
	
	if_set(var_29_0, "txt_season_period", T(var_29_1 and "ui_season_reward" or "ui_season_in_progress"))
	
	local var_29_2 = SeasonPass:isModeEpic(arg_29_0.vars.season_pass_id)
	local var_29_3 = SeasonPass:isRewardableSeason(arg_29_0.vars.season_pass_id)
	local var_29_4 = SeasonPass:getStartTime(arg_29_0.vars.season_pass_id)
	local var_29_5 = SeasonPass:getEndTime(arg_29_0.vars.season_pass_id)
	
	if var_29_1 then
		var_29_4 = var_29_5
		var_29_5 = var_29_5 + 604800
	end
	
	local var_29_6 = T(var_29_3 and "ui_season_period_reward_detail" or "ui_season_time", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_29_4,
		end_time = var_29_5
	}))
	
	if_set(var_29_0, "txt_peri", var_29_6)
	
	if not var_29_2 then
		if_set_visible(var_29_0, "n_btn", false)
		
		return 
	end
	
	local var_29_7 = SeasonPass:getOpenSeasonID()
	local var_29_8 = SeasonPass:getPreviousSeasonPassID(arg_29_0.vars.season_pass_id)
	local var_29_9 = arg_29_0.vars.season_pass_id == var_29_7
	local var_29_10 = not var_29_9 and var_29_7 ~= nil
	local var_29_11 = var_29_9 and SeasonPass:isRewardableSeason(var_29_8)
	local var_29_12 = var_29_10 or var_29_11
	
	if_set_visible(var_29_0, "n_btn", var_29_12)
	
	if not var_29_12 then
		return 
	end
	
	var_29_0:setPositionY(60)
	
	local var_29_13 = var_29_0:getChildByName("btn_pre")
	
	if_set_visible(var_29_13, nil, var_29_11)
	
	if var_29_11 then
		local var_29_14 = SeasonPass:isRemainReward(var_29_8)
		
		if_set_visible(var_29_13, "icon_noti", var_29_14)
	end
	
	local var_29_15 = var_29_0:getChildByName("btn_cur")
	
	if_set_visible(var_29_15, nil, var_29_10)
	
	if var_29_10 then
		local var_29_16 = SeasonPass:isRemainReward(var_29_7)
		
		if_set_visible(var_29_15, "icon_noti", var_29_16)
	end
	
	local var_29_17 = var_29_0:findChildByName("talk_small_bg")
	
	if_set_visible(var_29_17, nil, var_29_9)
	
	if not var_29_9 then
		return 
	end
	
	local var_29_18, var_29_19, var_29_20, var_29_21 = SeasonPass:getRewardRemainTime(var_29_8)
	
	if_set(var_29_17, "disc", T("ui_season_before_time", {
		day = sec_to_string(var_29_21)
	}))
	UIAction:Add(LOOP(SEQ(DELAY(2000), LOG(FADE_OUT(400)), DELAY(10000), LOG(FADE_IN(400)))), var_29_17, "talk_small_bg")
end

function SeasonPassBase.updateMoveRewardNotificationUI(arg_30_0)
	local var_30_0 = SeasonPass:getLowestRewardableRank(arg_30_0.vars.season_pass_id) ~= nil
	
	if_set_visible(getChildByPath(arg_30_0.vars.wnd, "n_top/btn_move_reward/icon_noti"), nil, var_30_0)
end

function SeasonPassBase.onUpgrade(arg_31_0)
	arg_31_0:setRewardsUI()
	arg_31_0:setGetRewardButton()
end

function SeasonPassBase.setRewardsUI(arg_32_0)
	arg_32_0:setSubTitleUI()
	if_set_visible(arg_32_0.vars.wnd, "n_not_yet", not SeasonPass:isPaidPremium(arg_32_0.vars.season_pass_id))
	if_set_visible(arg_32_0.vars.wnd, "n_not_yet2", not SeasonPass:isPaidSpecial(arg_32_0.vars.season_pass_id))
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.scroll_view.ScrollViewItems) do
		arg_32_0:setRankRewardsUI(iter_32_0)
	end
	
	arg_32_0:setCompleteRewardsUI()
	arg_32_0:setBonusRewardUI()
end

function SeasonPassBase.setBonusRewardDescUI(arg_33_0)
	local function var_33_0()
		if SeasonPass:isBonusRewarded(arg_33_0.vars.season_pass_id) then
			return arg_33_0.vars.is_epic_mode and T("ui_season_special_comp") or T("ui_substory_special_comp")
		end
		
		if SeasonPass:getGrade(arg_33_0.vars.season_pass_id) == 2 then
			return arg_33_0.vars.is_epic_mode and T("ui_season_special_buy") or T("ui_substory_special_buy")
		end
		
		return arg_33_0.vars.is_epic_mode and T("ui_season_buy_desc2") or T("ui_substory_buy_desc2")
	end
	
	local var_33_1 = getChildByPath(arg_33_0.vars.wnd, "RIGHT/n_contents/n_special_reward/txt_ex")
	
	if_set(var_33_1, nil, var_33_0())
end

function SeasonPassBase.setBonusRewardUI(arg_35_0)
	local var_35_0 = SeasonPass:getBonusReward(arg_35_0.vars.season_pass_id)
	
	if not var_35_0 then
		return 
	end
	
	local var_35_1 = arg_35_0.vars.wnd:findChildByName("n_special_reward")
	
	if not var_35_1 then
		return 
	end
	
	if_set_scale_fit_width_long_word(var_35_1, "txt_bundle", T("ui_season_bonus_reward"), 200)
	
	local var_35_2 = var_35_1:findChildByName("n_reward")
	
	var_35_2.is_bonus = true
	var_35_2.rank = var_35_0.rank
	var_35_2.grade = 2
	
	arg_35_0:setRewardUI(var_35_2, var_35_0)
	arg_35_0:setBonusRewardDescUI()
end

function SeasonPassBase.setRewardsLineUI(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_1:findChildByName("n_reward1")
	
	var_36_0.is_complete = arg_36_1.is_complete
	var_36_0.rank = arg_36_1.rank
	var_36_0.grade = 0
	
	arg_36_0:setRewardUI(var_36_0, arg_36_2.free)
	SeasonPass:isPaidPremium(arg_36_0.vars.season_pass_id)
	
	local var_36_1 = arg_36_1:findChildByName("n_reward_sp1")
	
	var_36_1.is_complete = arg_36_1.is_complete
	var_36_1.rank = arg_36_1.rank
	var_36_1.grade = 1
	
	arg_36_0:setRewardUI(var_36_1, arg_36_2.pass01)
	
	local var_36_2 = arg_36_1:findChildByName("n_reward_sp2")
	
	var_36_2.is_complete = arg_36_1.is_complete
	var_36_2.rank = arg_36_1.rank
	var_36_2.grade = 1
	
	arg_36_0:setRewardUI(var_36_2, arg_36_2.pass02)
end

function SeasonPassBase.isRewardedCompleteFreeUI(arg_37_0)
	if not arg_37_0.vars or not arg_37_0.vars.wnd then
		return false
	end
	
	local var_37_0 = arg_37_0.vars.wnd:findChildByName("n_finish_reward")
	
	if not get_cocos_refid(var_37_0) then
		return false
	end
	
	local var_37_1 = var_37_0:findChildByName("n_reward1")
	
	if not get_cocos_refid(var_37_1) then
		return false
	end
	
	local var_37_2 = var_37_1:findChildByName("btn_reward")
	
	if not get_cocos_refid(var_37_2) then
		return false
	end
	
	return var_37_2.is_rewarded == true
end

function SeasonPassBase.isRewardedCompleteFreeUI(arg_38_0)
	if not arg_38_0.vars or not arg_38_0.vars.wnd then
		return false
	end
	
	local var_38_0 = arg_38_0.vars.wnd:findChildByName("n_finish_reward")
	
	if not get_cocos_refid(var_38_0) then
		return false
	end
	
	local var_38_1 = var_38_0:findChildByName("n_reward1")
	
	if not get_cocos_refid(var_38_1) then
		return false
	end
	
	local var_38_2 = var_38_1:findChildByName("btn_reward")
	
	if not get_cocos_refid(var_38_2) then
		return false
	end
	
	return var_38_2.is_rewarded == true
end

function SeasonPassBase.setCompleteRewardsUI(arg_39_0)
	local var_39_0 = SeasonPass:getCompleteRewards(arg_39_0.vars.season_pass_id)
	local var_39_1 = arg_39_0.vars.wnd:findChildByName("n_finish_reward")
	
	var_39_1.is_complete = true
	var_39_1.rank = var_39_0.rank
	
	if_set_scale_fit_width_long_word(var_39_1, "txt", T("ui_season_complete_reward"), 100)
	arg_39_0:setRewardsLineUI(var_39_1, var_39_0)
end

function SeasonPassBase.setBackgroundImage(arg_40_0, arg_40_1)
	if not arg_40_1 then
		return 
	end
	
	if_set_visible(arg_40_0.vars.wnd, "image_bg", true)
	if_set_sprite(arg_40_0.vars.wnd, "image_bg", arg_40_1)
end

function SeasonPassBase.setBackgroundMap(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not arg_41_1 then
		return 
	end
	
	arg_41_2 = arg_41_2 or 0
	arg_41_3 = arg_41_3 or 0
	
	local var_41_0 = arg_41_0.vars.wnd:findChildByName("n_bg")
	
	if not get_cocos_refid(var_41_0) then
		return 
	end
	
	local var_41_1, var_41_2 = FIELD_NEW:create(arg_41_1)
	
	var_41_2:setViewPortPosition(arg_41_2, arg_41_3)
	var_41_2:updateViewport()
	var_41_1:setPositionY(-360)
	var_41_1:setLocalZOrder(-1)
	var_41_1:setName("@field_bg")
	var_41_0:addChild(var_41_1)
end

function SeasonPassBase.setBackground(arg_42_0)
	local var_42_0 = SeasonPass:getBackgroundData(arg_42_0.vars.season_pass_id)
	
	if not var_42_0 then
		return 
	end
	
	if_set_visible(arg_42_0.vars.wnd, "image_bg", var_42_0.img)
	
	if var_42_0.img then
		arg_42_0:setBackgroundImage(var_42_0.img)
		
		return 
	end
	
	if var_42_0.map then
		arg_42_0:setBackgroundMap(var_42_0.map, var_42_0.scroll_x, var_42_0.scroll_y)
		
		return 
	end
end

function SeasonPassBase.setPortrait(arg_43_0)
	local var_43_0 = SeasonPass:getPortraitData(arg_43_0.vars.season_pass_id)
	
	if not var_43_0 then
		return 
	end
	
	if not var_43_0.portrait then
		return 
	end
	
	local var_43_1 = arg_43_0.vars.wnd:findChildByName("n_portrait")
	
	if not get_cocos_refid(var_43_1) then
		return 
	end
	
	var_43_0.offset_x = var_43_0.offset_x or 0
	var_43_0.offset_y = var_43_0.offset_y or 0
	var_43_0.scale = var_43_0.scale or var_43_0.scale_x or 1
	
	local var_43_2 = UIUtil:getPortraitAni(var_43_0.portrait, {
		pin_sprite_position_y = var_43_0.portrait_pin
	})
	
	var_43_2:setScale(var_43_0.scale)
	var_43_2:setScaleX(var_43_0.portrait_flip and -var_43_2:getScaleX() or var_43_2:getScaleX())
	var_43_2:setPosition(var_43_2:getPositionX() + var_43_0.offset_x, var_43_2:getPositionY() + var_43_0.offset_y)
	var_43_1:addChild(var_43_2)
	arg_43_0:updateBalloon(var_43_2)
end

function SeasonPassBase.updateBalloon(arg_44_0, arg_44_1)
	if not arg_44_0.vars then
		return 
	end
	
	if not arg_44_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	local var_44_0 = arg_44_0.vars.wnd:findChildByName("n_balloon")
	local var_44_1 = SeasonPass:getBalloonData(arg_44_0.vars.season_pass_id)
	
	if_set_visible(var_44_0, nil, var_44_1 ~= nil)
	
	if not var_44_1 then
		return 
	end
	
	if not get_cocos_refid(var_44_0) then
		return 
	end
	
	var_44_0:setScale(0)
	
	local var_44_2 = var_44_1 .. ".idle"
	
	UIUtil:playNPCSoundAndTextRandomly(var_44_2, var_44_0, "txt_balloon", 300, var_44_2, arg_44_1)
end

function SeasonPassBase.setRankTitleUI(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0.vars.wnd:findChildByName("n_rank")
	
	if not get_cocos_refid(var_45_0) then
		return 
	end
	
	UIUtil:setLevel(var_45_0, arg_45_1, SeasonPass:getMaxRank(arg_45_0.vars.season_pass_id), 3, false, nil, 18)
	
	if SeasonPass:isMaxRank(arg_45_0.vars.season_pass_id) then
		if_set_percent(var_45_0, "progress_bar", 1)
		if_set(var_45_0, "t_percent", T("ui_season_pass_rank_max_desc"))
		
		return 
	end
	
	local var_45_1 = SeasonPass:getAccumRankExp(arg_45_0.vars.season_pass_id, arg_45_1 - 1)
	local var_45_2 = SeasonPass:getAccumRankExp(arg_45_0.vars.season_pass_id, arg_45_1)
	local var_45_3 = SeasonPass:getRankExp(arg_45_0.vars.season_pass_id)
	
	if_set_percent(var_45_0, "progress_bar", (var_45_3 - var_45_1) / (var_45_2 - var_45_1))
	if_set(var_45_0, "t_percent", var_45_3 .. " / " .. var_45_2)
end

function SeasonPassBase.setAchieveTitleUI(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0.vars.wnd:findChildByName("n_achieve")
	
	if not get_cocos_refid(var_46_0) then
		return 
	end
	
	if_set(var_46_0, "txt_point", arg_46_1)
end

function SeasonPassBase.setSubTitleUI(arg_47_0)
	local var_47_0 = SeasonPass:getName(arg_47_0.vars.season_pass_id)
	
	if SeasonPass:isPrevSeasonPass(arg_47_0.vars.season_pass_id) then
		if_set(arg_47_0.vars.wnd, "txt_season", T("ui_season_period_reward_title", {
			season_name = var_47_0
		}))
	else
		if_set(arg_47_0.vars.wnd, "txt_season", var_47_0)
	end
	
	local var_47_1 = SeasonPass:getRank(arg_47_0.vars.season_pass_id)
	
	if_set_visible(arg_47_0.vars.wnd, "n_rank", arg_47_0.vars.is_rank_type)
	if_set_visible(arg_47_0.vars.wnd, "n_achieve", not arg_47_0.vars.is_rank_type)
	
	if arg_47_0.vars.is_rank_type then
		arg_47_0:setRankTitleUI(var_47_1)
	else
		arg_47_0:setAchieveTitleUI(var_47_1)
	end
end

function SeasonPassBase.isCheckState(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = Account:getGrowthGuideQuest(arg_48_1)
	
	return var_48_0 and arg_48_2 <= var_48_0.state
end

function SeasonPassBase.setRewardItemUI(arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_2.id then
		return 
	end
	
	local var_49_0 = DB("equip_item", arg_49_2.id, "type") == "artifact"
	local var_49_1 = DB("character", arg_49_2.id, "id") ~= nil
	local var_49_2 = UIUtil:getRewardIcon(arg_49_2.count, arg_49_2.id, {
		hero_multiply_scale = 1,
		artifact_multiply_scale = 0.7,
		tooltip_delay = 300,
		show_equip_count = true,
		scale = 0.9,
		popup_delay = 100,
		parent = arg_49_1,
		no_popup = var_49_1 and arg_49_2.is_rewardable,
		grade_rate = arg_49_2.grade_rate,
		set_fx = arg_49_2.set_drop,
		no_bg = string.starts(arg_49_2.id, "ma_bg"),
		no_grade = var_49_0
	})
	
	if var_49_0 then
		local var_49_3 = var_49_2:findChildByName("txt_small_count")
		
		if get_cocos_refid(var_49_3) then
			var_49_3:setScale(1.4)
		end
	end
end

function SeasonPassBase.setRewardUI(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_1:findChildByName("btn_reward")
	
	if not get_cocos_refid(var_50_0) then
		return 
	end
	
	var_50_0.season_id = arg_50_0.vars.season_pass_id
	var_50_0.rank = arg_50_1.rank
	var_50_0.grade = arg_50_1.grade
	var_50_0.is_bonus = arg_50_1.is_bonus
	var_50_0.is_complete = arg_50_1.is_complete
	
	local var_50_1 = SeasonPass:getRank(arg_50_0.vars.season_pass_id)
	local var_50_2 = SeasonPass:getGrade(arg_50_0.vars.season_pass_id)
	local var_50_3 = arg_50_2.id and arg_50_2.is_rewarded
	local var_50_4 = arg_50_2.id and (var_50_1 < var_50_0.rank or var_50_2 < var_50_0.grade)
	local var_50_5 = var_50_3 or var_50_2 < var_50_0.grade
	local var_50_6 = var_50_0.is_rewarded ~= var_50_3 or var_50_0.is_locked ~= var_50_4 or var_50_0.is_translucence ~= var_50_5
	
	var_50_0.is_rewarded = var_50_3
	var_50_0.is_locked = var_50_4
	var_50_0.is_translucence = var_50_5
	
	if var_50_6 then
		if_set_visible(arg_50_1, "icon_locked", var_50_0.is_locked)
		if_set_opacity(arg_50_1, "reward_icon", var_50_0.is_translucence and 76.5 or 255)
		if_set_visible(arg_50_1, "icon_check", var_50_0.is_rewarded)
		
		arg_50_2.is_rewardable = not var_50_4 and not var_50_0.is_rewarded
		
		arg_50_0:setRewardItemUI(arg_50_1:findChildByName("reward_icon"), arg_50_2)
	end
end

function SeasonPassBase.scroll_view.getScrollViewItem(arg_51_0, arg_51_1)
	local var_51_0 = load_dlg("season_pass_base_item", nil, "wnd")
	local var_51_1 = SeasonPassBase.vars.is_epic_mode and T("ui_season_rank", {
		rank = arg_51_1.rank
	}) or T("ui_substory_achievement", {
		achievement_count = arg_51_1.rank
	})
	
	if_set_scale_fit_width_long_word(var_51_0, "txt", var_51_1, 100)
	
	return var_51_0
end

function SeasonPassBase.scroll_view.scrollToRewardableItem(arg_52_0)
	local var_52_0 = SeasonPassBase.vars.season_pass_id
	local var_52_1 = SeasonPass:getLowestRewardableRank(var_52_0) or SeasonPass:getRank(var_52_0)
	
	arg_52_0:scrollToIndex(var_52_1, 3)
end

function SeasonPassBase.setRankRewardsUI(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0.scroll_view.ScrollViewItems
	
	if not var_53_0 then
		return 
	end
	
	local var_53_1 = var_53_0[arg_53_1]
	
	if not var_53_1 then
		return 
	end
	
	local var_53_2 = arg_53_0.vars.season_pass_id
	local var_53_3 = SeasonPass:getRankRewards(var_53_2, arg_53_1)
	
	var_53_1.control.rank = arg_53_1
	
	arg_53_0:setRewardsLineUI(var_53_1.control, var_53_3)
end

function SeasonPassBase.showNoticePopup(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = os.time()
	local var_54_1 = SeasonPass:getEndTime(arg_54_0.vars.season_pass_id) - var_54_0
	
	if var_54_1 < 0 then
		return 
	end
	
	local var_54_2 = math.floor(var_54_1 / 60) % 60
	local var_54_3 = math.floor(var_54_1 / 3600) % 24
	local var_54_4 = math.floor(var_54_1 / 86400)
	
	SeasonPass:deleteExpire(SeasonPass:isModeEpic(arg_54_0.vars.season_pass_id))
	
	local var_54_5 = SeasonPass:load(arg_54_0.vars.season_pass_id, "last_open_remain_day")
	
	SeasonPass:save(arg_54_0.vars.season_pass_id, "last_open_remain_day", var_54_4)
	
	local var_54_6 = T(arg_54_0.vars.is_epic_mode and "season_start_popup_title" or "substory_start_popup_title", {
		season_name = SeasonPass:getName(arg_54_0.vars.season_pass_id)
	})
	
	if arg_54_1 and not var_54_5 then
		SAVE:sendQueryServerConfig()
		
		local var_54_7 = T(arg_54_0.vars.is_epic_mode and "season_start_popup_desc" or "substory_start_popup_desc", {
			day = var_54_4,
			hour = var_54_3,
			min = var_54_2,
			season_name = SeasonPass:getName(arg_54_0.vars.season_pass_id)
		})
		
		Dialog:msgBox(var_54_7, {
			title = var_54_6
		})
		
		return 
	end
	
	if var_54_4 < 7 and (not arg_54_2 or var_54_5 ~= var_54_4) then
		SAVE:sendQueryServerConfig()
		
		local var_54_8 = T(arg_54_0.vars.is_epic_mode and "season_end_popup_desc" or "substory_end_popup_desc", {
			day = var_54_4,
			hour = var_54_3,
			min = var_54_2,
			season_name = SeasonPass:getName(arg_54_0.vars.season_pass_id)
		})
		
		Dialog:msgBox(var_54_8, {
			title = var_54_6
		})
		
		return 
	end
end

function SeasonPassBase.onRtnBuyPackage(arg_55_0, arg_55_1)
	SeasonPassPromotion:close()
	
	local var_55_0 = SeasonPass:getPackageItem(arg_55_0.vars.season_pass_id, arg_55_1.item)
	
	if not var_55_0 then
		return 
	end
	
	Lobby:checkMail(true)
	
	if var_55_0.type then
		Dialog:msgRewards(T("package_success_desc", {
			package_name = T(var_55_0.name)
		}), {
			rewards = {
				{
					count = 1,
					token = var_55_0.type
				}
			}
		})
	end
	
	arg_55_0:setBuySeasonPassButton()
end

function SeasonPassBase.showBuyRankUpDialog(arg_56_0)
	if SeasonPass:isMaxRank(arg_56_0.vars.season_pass_id) then
		balloon_message(T("errmsg_season_pass_rank_max_buy"))
		
		return 
	end
	
	local var_56_0 = SeasonPass:getMaxRank(arg_56_0.vars.season_pass_id)
	local var_56_1 = SeasonPass:getRank(arg_56_0.vars.season_pass_id)
	local var_56_2 = SeasonPass:getRankUpPrice(arg_56_0.vars.season_pass_id)
	local var_56_3 = 1
	local var_56_4 = var_56_0 - var_56_1
	local var_56_5 = "season_buy_rank_popup_title1"
	local var_56_6 = "season_buy_rank_popup_desc1_1"
	local var_56_7 = "season_buy_rank_popup_desc1_2"
	
	if not arg_56_0.vars.is_epic_mode then
		if arg_56_0.vars.is_rank_condition then
			var_56_5 = "substory_buy_rank_popup_title1"
			var_56_6 = "substory_buy_rank_popup_desc1_1"
			var_56_7 = "substory_buy_rank_popup_desc1_2"
		else
			var_56_5 = "substory_buy_achievement_popup_title1"
			var_56_6 = "substory_buy_achievement_popup_desc1_1"
			var_56_7 = "substory_buy_achievement_popup_desc1_2"
		end
	end
	
	local var_56_8 = {
		yesno = true,
		name = "buy_rank_slider_dlg",
		slider_pos = 1,
		min = 1,
		slider_handler = function(arg_57_0, arg_57_1, arg_57_2)
			local var_57_0 = arg_57_1 * var_56_3
			
			if_set(arg_57_0, "txt_title", T(var_56_5))
			if_set(arg_57_0, "text", T(var_56_6, {
				count = var_57_0
			}))
			if_set(arg_57_0, "txt_add_count", "+" .. comma_value(var_57_0))
			if_set(arg_57_0, "txt_slide", var_56_1 + var_57_0 .. "/" .. var_56_0)
			
			arg_57_0.need_crystal = var_56_2 * var_57_0
			
			if_set(arg_57_0, "txt_rest", comma_value(arg_57_0.need_crystal))
			UIUtil:changeButtonState(arg_57_0.c.btn_yes, arg_57_0.need_crystal <= Account:getCurrency("crystal"), true)
		end,
		token = GAME_STATIC_VARIABLE.inven_hero_add_token,
		max = var_56_4,
		info = T(var_56_7),
		handler = function(arg_58_0, arg_58_1, arg_58_2)
			local var_58_0 = arg_58_0.slider:getPercent()
			local var_58_1 = to_n(arg_58_0.need_crystal)
			
			Action:Add(SEQ(DELAY(1), CALL(function()
				if not UIUtil:checkCurrencyDialog("crystal", var_58_1) then
					return 
				end
				
				query("add_season_pass_rank", {
					event_id = arg_56_0.vars.season_pass_id,
					add_rank = var_58_0
				})
			end)), arg_56_0)
		end
	}
	
	Dialog:msgBoxSlider(var_56_8)
end
