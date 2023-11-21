DungeonHell = DungeonHell or {}

local var_0_0 = 660

function HANDLER.dungeon_hell(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		if TutorialGuide:isPlayingTutorial() then
			TutorialGuide:procGuide()
		end
		
		DungeonHell:ready()
	end
	
	if arg_1_1 == "btn_clean" then
		DungeonHell:reqCleanHell()
	end
	
	if arg_1_1 == "btn_discussion" then
		local var_1_0 = DungeonHell:isShowHardMode()
		
		Stove:openHellGuidePage(DungeonHell:getCurFloor(var_1_0), var_1_0)
	end
	
	if arg_1_1 == "btn_go_floor" then
		DungeonHell:ready()
	end
	
	if arg_1_1 == "btn_replay" then
		if DungeonHell:isShowHardMode() then
			DungeonHell:retryChallenge()
		else
			DungeonHell:retry()
		end
	end
	
	if arg_1_1 == "btn_reward" then
		DungeonHell:showStarRewardPopup()
	end
	
	if arg_1_1 == "btn_temporary_gat" and Account:getUserConfigsHash("user_etc1", "hell_reward_adjust") == nil then
		query("dungeon_hell_reward_adjust")
	end
end

DungeonHellRewardPopUp = DungeonHellRewardPopUp or {}

copy_functions(ScrollView, DungeonHellRewardPopUp)

function HANDLER.dungeon_hell_reward(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		DungeonHell:closeStarRewardPopup()
	end
end

function HANDLER.dungeon_hell_reward_item(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_get_reward" then
		local var_3_0 = arg_3_0.data
		
		if var_3_0.state == 0 then
			balloon_message_with_sound("not_yet_take_star_reward")
			
			return 
		end
		
		if to_n(var_3_0[1]) <= DungeonHell:getMyStarCount() and var_3_0.state == 1 then
			query("dungeon_hell_star_reward")
		end
	end
end

function MsgHandler.dungeon_hell_star_reward(arg_4_0)
	Account:setWorldmapRwards(arg_4_0.info.chapter_id, tonumber(arg_4_0.info.count))
	
	local var_4_0 = {
		title = T("abyss_hard_start_reward_title"),
		desc = T("abyss_hard_start_reward_desc")
	}
	
	Account:addReward(arg_4_0.rewards, {
		play_reward_data = var_4_0
	})
	DungeonHell:refreshPopUp()
	DungeonHell:updateStarRewardUI()
end

function DungeonHellRewardPopUp.getScrollViewItem(arg_5_0, arg_5_1)
	local var_5_0 = load_control("wnd/dungeon_hell_reward_item.csb")
	local var_5_1 = to_n(arg_5_1[1])
	local var_5_2 = arg_5_1.state
	
	if var_5_2 == 0 or var_5_2 == -1 then
		if_set_opacity(var_5_0, nil, 76.5)
	else
		if_set_opacity(var_5_0, nil, 255)
	end
	
	if_set_visible(var_5_0, "btn_get_reward", var_5_2 ~= -1)
	if_set_visible(var_5_0, "completed", var_5_2 == -1)
	if_set_visible(var_5_0, "icon_checked", var_5_2 == -1)
	if_set(var_5_0, "t_disc", T("abyss_hard_start_mission_desc", {
		count = var_5_1
	}))
	if_set(var_5_0, "t_need", "x" .. var_5_1)
	UIUtil:getRewardIcon(to_n(arg_5_1[3]), arg_5_1[2], {
		show_small_count = true,
		scale = 0.8,
		parent = var_5_0:getChildByName("icon"),
		count = to_n(arg_5_1[3])
	})
	
	var_5_0:getChildByName("btn_get_reward").data = {}
	var_5_0:getChildByName("btn_get_reward").data = arg_5_1
	
	return var_5_0
end

function DungeonHell.refreshPopUp(arg_6_0)
	if get_cocos_refid(arg_6_0.vars.reward_popup) then
		arg_6_0.vars.reward_popup:getChildByName("ScrollView_1"):removeAllChildren()
		DungeonHellRewardPopUp:initScrollView(arg_6_0.vars.reward_popup:getChildByName("ScrollView_1"), 592, 82, {
			fit_height = true
		})
		DungeonHellRewardPopUp:setScrollViewItems(arg_6_0:getStarRewardData())
		if_set(arg_6_0.vars.reward_popup, "t_star_count", "x" .. arg_6_0:getMyStarCount())
		if_set(arg_6_0.vars.reward_popup, "t_star_disc", T("abyss_hard_start_mission_desc", {
			count = arg_6_0:getMyStarCount()
		}))
	end
end

function DungeonHell.isShowStarRewardWnd(arg_7_0)
	return arg_7_0.vars and get_cocos_refid(arg_7_0.vars.reward_popup)
end

function DungeonHell.showStarRewardPopup(arg_8_0)
	arg_8_0.vars.scrollview:setTouchEnabled(false)
	
	local var_8_0 = load_dlg("dungeon_hell_reward", true, "wnd", function()
		DungeonHell:closeStarRewardPopup()
	end)
	
	arg_8_0.vars.reward_popup = var_8_0
	
	arg_8_0:refreshPopUp()
	arg_8_0.vars.wnd:addChild(var_8_0)
end

function DungeonHell.closeStarRewardPopup(arg_10_0)
	arg_10_0.vars.scrollview:setTouchEnabled(true)
	BackButtonManager:pop()
	arg_10_0.vars.reward_popup:removeFromParent()
	
	arg_10_0.vars.reward_popup = nil
end

function MsgHandler.clear_hell(arg_11_0)
	local var_11_0 = arg_11_0.token
	
	if string.starts(var_11_0, "to_") then
		var_11_0 = string.sub(arg_11_0.token, 4, -1)
	end
	
	Account:setCurrency(var_11_0, arg_11_0.remain_token)
	Account:setCurrencyTime(var_11_0, arg_11_0.currency_time)
	TopBarNew:topbarUpdate(true)
	
	if DungeonHell:isShowHardMode() then
		DungeonHell:onStartClearHell(arg_11_0)
	else
		DungeonList:updateNotification()
		DungeonHell:updateCleaningInfo(true)
		TutorialNotice:update("DungeonList")
		UIAction:Add(SEQ(CALL(function()
			EffectManager:Play({
				pivot_x = 0,
				fn = "narak_eff_puri.cfx",
				pivot_y = -150,
				pivot_z = 0,
				layer = DungeonHell.vars.bg_info.tower_layer
			})
		end), DELAY(1000), CALL(function()
			DungeonHell:onStartClearHell(arg_11_0)
		end)), DungeonHell.vars.layer, "block")
	end
end

function ErrHandler.clear_hell(arg_14_0, arg_14_1, arg_14_2)
	if string.starts(arg_14_1, "req_token") then
		Dialog:msgBox(T("abyss_todaycant_enter"))
	end
end

function MsgHandler.dungeon_hell_reward_adjust(arg_15_0)
	DungeonHell:hellRewardAdjusted(arg_15_0)
end

copy_functions(ScrollView, DungeonHell)

function DungeonHell.getScrollViewItem(arg_16_0, arg_16_1)
	local var_16_0 = load_control("wnd/dungeon_period_bar.csb")
	
	if_set_sprite(var_16_0, "bg", arg_16_1.bg)
	
	for iter_16_0, iter_16_1 in pairs(var_16_0:getChildren() or {}) do
		if string.starts(iter_16_1:getName(), "n_") then
			if_set_visible(iter_16_1, nil, false)
		end
	end
	
	local var_16_1 = var_16_0:getChildByName("n_hell")
	
	if_set_visible(var_16_1, nil, var_16_1)
	
	if get_cocos_refid(var_16_1) then
		if_set(var_16_1, "txt_floor", arg_16_1.floor)
		if_set(var_16_1, "txt_abyss", T(arg_16_1.name))
		
		var_16_0.info = arg_16_1
		var_16_0.parent = arg_16_0
	end
	
	if arg_16_1.unlock_id == UNLOCK_ID.HELL_CHALLENGE then
		local var_16_2, var_16_3 = arg_16_0:getStarRewardData()
		
		if_set_visible(var_16_0, "icon_noti", var_16_3 == true)
	end
	
	if_set_visible(var_16_0, "n_locked", not UnlockSystem:isUnlockSystem(arg_16_1.unlock_id))
	if_set_opacity(var_16_0, "n_hell", UnlockSystem:isUnlockSystem(arg_16_1.unlock_id) == true and 255 or 76.5)
	if_set_opacity(var_16_0, "bg", UnlockSystem:isUnlockSystem(arg_16_1.unlock_id) == true and 255 or 76.5)
	
	return var_16_0
end

function DungeonHell.getFirstDungeonControl(arg_17_0)
	return DungeonHell.ScrollViewItems[1].control
end

function DungeonHell.getDungeonControl(arg_18_0, arg_18_1)
	if DungeonHell.ScrollViewItems and arg_18_1 <= #DungeonHell.ScrollViewItems then
		return DungeonHell.ScrollViewItems[arg_18_1].control:getChildByName("btn_go")
	end
end

function DungeonHell.scrollToIndex(arg_19_0, arg_19_1)
	if DungeonHell.ScrollViewItems and arg_19_1 <= #DungeonHell.ScrollViewItems then
		DungeonHell:scrollToIndex(arg_19_1)
	end
end

function DungeonHell.onSelectScrollViewItem(arg_20_0, arg_20_1, arg_20_2)
	if TutorialGuide:checkBlockDungeonPeriodList(arg_20_2) then
		return 
	end
	
	SoundEngine:play("event:/ui/btn_small")
	UnlockSystem:isUnlockSystemAndMsg({
		id = arg_20_2.item.unlock_id
	}, function()
		SoundEngine:play("event:/ui/dungeon_hell/enter")
		DungeonList:onEndStoryCallback(arg_20_2.item)
	end)
end

function DungeonHell.reqCleanHell(arg_22_0)
	if Account:getHellFloor() - 1 <= 0 then
		balloon_message_with_sound("hell_cure_no")
		
		return 
	end
	
	if not arg_22_0:Cleanable() then
		Dialog:msgBox(T("abyss_todaycant_enter"))
		
		return 
	end
	
	local var_22_0 = load_dlg("dungeon_hell_cleaning", true, "wnd")
	local var_22_1 = UIUtil:getRewardIcon(0, "to_abysskey", {
		show_name = true
	})
	local var_22_2 = var_22_0:findChildByName("reward_item")
	
	if var_22_2 and var_22_1 then
		var_22_2:addChild(var_22_1)
	end
	
	if_set(var_22_0, "txt_have", T("have", {
		count = Account:getCurrency("abysskey")
	}))
	if_set(var_22_0, "t_desc", T("abyss_confirm_clean", {
		floor = Account:getHellFloor() - 1
	}))
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_22_0,
		yes_text = T("ui_msgbox_ok"),
		handler = function(arg_23_0)
			query("clear_hell")
		end
	})
end

function DungeonHell.getNormalFloor(arg_24_0)
	local var_24_0 = Account:getHellFloor()
	
	if not DB("level_abyss_reward", tostring(var_24_0), "reward1") then
		var_24_0 = var_24_0 - 1
	end
	
	return var_24_0
end

function DungeonHell.getMaxChallengeFloor(arg_25_0)
	local var_25_0 = 0
	
	for iter_25_0 = 1, 999 do
		if not DB("level_enter", "abysshard" .. string.format("%03d", iter_25_0), "id") then
			break
		end
		
		var_25_0 = var_25_0 + 1
	end
	
	return var_25_0
end

function DungeonHell.getMaxFloor(arg_26_0)
	if GAME_STATIC_VARIABLE.abyss_last_floor then
		return GAME_STATIC_VARIABLE.abyss_last_floor
	end
	
	for iter_26_0 = 100, 1, -1 do
		if DB("level_abyss_reward", tostring(iter_26_0), "reward1") then
			return iter_26_0
		end
	end
	
	return 50
end

function DungeonHell.updateClearBonus(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_1 then
		return 
	end
	
	local var_27_0 = Account:getHellFloor() - 1
	local var_27_1 = var_27_0 == 0
	
	var_27_0 = var_27_1 and 1 or var_27_0
	
	local var_27_2, var_27_3, var_27_4, var_27_5 = DB("level_abyss_reward", tostring(var_27_0), {
		"reward1",
		"reward2",
		"count1",
		"count2"
	})
	
	if_set_visible(arg_27_1, "txt_empty_reward_msg", var_27_0 == 0)
	
	if not var_27_2 then
		return 
	end
	
	local var_27_6 = Booster:getAddCalcValue(BOOSTERSKILL_EFFECT_TYPE.ABYSS_PURIFICATION_REWARD, var_27_4)
	local var_27_7 = Booster:getAddCalcValue(BOOSTERSKILL_EFFECT_TYPE.ABYSS_PURIFICATION_REWARD, var_27_5)
	local var_27_8 = var_27_4 + var_27_6
	local var_27_9 = var_27_5 + var_27_7
	local var_27_10 = arg_27_1:getChildByName("sub_Hell")
	
	if get_cocos_refid(var_27_10) then
		arg_27_1 = var_27_10
	end
	
	local var_27_11 = {
		show_small_count = true,
		scale = 0.8,
		detail = true,
		parent = arg_27_1:getChildByName("n_all_clear_reward1")
	}
	
	if var_27_1 then
	end
	
	var_27_11.count = var_27_1 and 0 or var_27_8
	var_27_11.show_name = arg_27_2
	
	local var_27_12 = {
		show_small_count = true,
		scale = 0.8,
		detail = true,
		parent = arg_27_1:getChildByName("n_all_clear_reward2")
	}
	
	if var_27_1 then
	end
	
	var_27_12.count = var_27_1 and 0 or var_27_9
	var_27_12.show_name = arg_27_2
	var_27_8 = var_27_1 and 0 or var_27_8
	var_27_9 = var_27_1 and 0 or var_27_9
	
	UIUtil:getRewardIcon(var_27_8, var_27_2, var_27_11)
	UIUtil:getRewardIcon(var_27_9, var_27_3, var_27_12)
	
	local var_27_13 = Account:getHellFloor() - 1
	
	if var_27_13 > 0 then
		if_set(arg_27_1, "txt_clear", T("hell_prize", {
			floor = var_27_13
		}))
	end
end

function DungeonHell.getReadyBtn(arg_28_0)
	return arg_28_0.vars.wnd:getChildByName("btn_go")
end

function DungeonHell.onStartClearHell(arg_29_0, arg_29_1)
	local var_29_0 = {
		title = T("hell_cure_title"),
		desc = T("hell_cure")
	}
	
	Account:addReward(arg_29_1, {
		play_reward_data = var_29_0
	})
	TopBarNew:topbarUpdate(true)
	
	AccountData.hell_tm = arg_29_1.hell_tm
	
	arg_29_0:updateCleaningInfo(true)
	
	if arg_29_0.vars.cur_floor then
		arg_29_0.vars.scrollview:setEnabled(false)
		
		local var_29_1 = (arg_29_0.vars.cur_floor - 1) * 100
		
		arg_29_0.vars.clean_info = {}
		arg_29_0.vars.clean_info.begin_tm = uitick()
		arg_29_0.vars.clean_info.scroll_tm = var_29_1
		
		arg_29_0:moveToFloor(1, false)
	end
end

function DungeonHell.onFinishClearHell(arg_30_0)
	arg_30_0.vars.scrollview:setEnabled(true)
end

function DungeonHell.ready(arg_31_0, arg_31_1)
	if arg_31_0.vars.i_floor == arg_31_0.vars.cur_floor or arg_31_1 then
		local var_31_0 = (arg_31_0:isShowHardMode() and "abysshard" or "abyss") .. string.format("%03d", arg_31_0.vars.cur_floor)
		
		BattleReady:show({
			skip_intro = arg_31_1,
			callback = arg_31_0,
			enter_id = var_31_0,
			currencies = DungeonList:getCurrentCurrencies()
		})
		
		DungeonList.vars.enter_info = {
			show_ready_dialog = true
		}
	else
		arg_31_0:moveToFloor(arg_31_0.vars.cur_floor, true, 1)
	end
end

function DungeonHell.isAbyssHardMap(arg_32_0, arg_32_1)
	return (DB("level_enter", arg_32_1, "contents_type") or "") == "abyss_hard"
end

function DungeonHell.retryChallenge(arg_33_0)
	local var_33_0 = "abysshard"
	
	BattleReady:show({
		callback = arg_33_0,
		enter_id = var_33_0 .. string.format("%03d", arg_33_0.vars.i_floor),
		currencies = DungeonList:getCurrentCurrencies()
	})
	
	DungeonList.vars.enter_info = {
		show_ready_dialog = true
	}
end

function DungeonHell.retry(arg_34_0)
	local var_34_0 = "abyss"
	
	BattleReady:show({
		practice_mode = true,
		callback = arg_34_0,
		enter_id = var_34_0 .. string.format("%03d", arg_34_0.vars.i_floor),
		currencies = DungeonList:getCurrentCurrencies()
	})
	
	DungeonList.vars.enter_info = {
		show_ready_dialog = true
	}
end

function DungeonHell.getAbyssScrollView(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	return arg_35_0.vars.scrollview
end

function DungeonHell.isShowHardMode(arg_36_0)
	if not arg_36_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	return arg_36_0.vars.wnd:getChildByName("n_star_reward"):isVisible()
end

function DungeonHell.removeScrollEventListener(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_37_0.vars.listener) then
		return 
	end
	
	if not get_cocos_refid(arg_37_0.vars.scrollview) then
		return 
	end
	
	local var_37_0 = arg_37_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_37_0) then
		var_37_0:removeEventListener(arg_37_0.vars.listener)
	end
	
	arg_37_0.vars.listener:setEnabled(false)
	
	arg_37_0.vars.listener = nil
end

function DungeonHell.create(arg_38_0, arg_38_1)
	arg_38_0.vars = {}
	arg_38_0.vars.layer = cc.Layer:create()
	
	local var_38_0 = cc.Layer:create()
	
	arg_38_0.vars.layer:addChild(var_38_0)
	
	arg_38_0.vars.bg_info = {}
	arg_38_0.vars.bg_info.tower_layer = var_38_0
	
	local var_38_1 = true
	
	if var_38_1 then
		arg_38_0.vars.bg_info.bg1 = CACHE:getEffect("narak_back")
		
		arg_38_0.vars.bg_info.bg1:setScale(VIEW_WIDTH_RATIO)
		arg_38_0.vars.bg_info.bg1:setPosition(0, -150)
		arg_38_0.vars.bg_info.bg1:setAnimation(0, "idle", true)
		var_38_0:addChild(arg_38_0.vars.bg_info.bg1)
		
		arg_38_0.vars.bg_info.eff0 = EffectManager:Play({
			pivot_x = 0,
			fn = "narak_eff_idle.cfx",
			pivot_y = -150,
			pivot_z = 0,
			layer = var_38_0
		})
	end
	
	local function var_38_2(arg_39_0, arg_39_1)
		DungeonHell:updateBackground(arg_39_0, arg_39_1)
	end
	
	arg_38_0:initScrollView(arg_38_1:getChildByName("hell_scrollview"), 250, 204)
	
	local var_38_3
	local var_38_4
	
	if Account:getHellFloor() > arg_38_0:getMaxFloor() then
		var_38_3 = T("ui_dungeon_subhell_label_txt_hell_floor2")
	else
		var_38_3 = T("hell_floor", {
			floor = math.min(Account:getHellFloor(), arg_38_0:getMaxFloor())
		})
	end
	
	if Account:getHardHellFloor() >= arg_38_0:getMaxChallengeFloor() then
		var_38_4 = T("ui_dungeon_subhell_label_txt_hell_floor2")
	else
		var_38_4 = T("abyss_floor", {
			floor = math.min(Account:getHardHellFloor() + 1, arg_38_0:getMaxChallengeFloor())
		})
	end
	
	arg_38_0:createScrollViewItems({
		{
			name = "abyss_name",
			bg = "_dungeon_hell.png",
			unlock_id = UNLOCK_ID.HELL,
			floor = var_38_3
		},
		{
			name = "abyss_hard_name",
			bg = "_dungeon_hell_challenge.png",
			unlock_id = UNLOCK_ID.HELL_CHALLENGE,
			floor = var_38_4
		}
	})
	
	arg_38_0.vars.wnd_scrollview = load_control("wnd/dungeon_hell_tower.csb")
	arg_38_0.vars.bg_back = arg_38_0.vars.wnd_scrollview:getChildByName("bg_back")
	arg_38_0.vars.bg_chain = arg_38_0.vars.wnd_scrollview:getChildByName("bg_chain")
	arg_38_0.vars.bg_chain_layers = {}
	
	arg_38_0.vars.layer:addChild(arg_38_0.vars.wnd_scrollview)
	arg_38_0.vars.wnd_scrollview:setAnchorPoint(0.5, 0.5)
	
	local var_38_5 = arg_38_0.vars.wnd_scrollview:getChildByName("n_tower")
	
	if get_cocos_refid(var_38_5) then
		var_38_5:setPosition(0 - VIEW_BASE_LEFT * 2, 0)
		var_38_5:setVisible(false)
	end
	
	arg_38_0.vars.scrollview = arg_38_0.vars.wnd_scrollview:getChildByName("scrollview")
	arg_38_0.vars.scrollview.parent = arg_38_0
	
	arg_38_0.vars.scrollview:addEventListener(var_38_2)
	
	if var_38_1 then
		arg_38_0.vars.bg_info.bg2 = CACHE:getEffect("narak_front")
		
		arg_38_0.vars.bg_info.bg2:setScale(1)
		arg_38_0.vars.bg_info.bg2:setPosition(0, -150)
		arg_38_0.vars.bg_info.bg2:setAnimation(0, "idle", true)
		var_38_0:addChild(arg_38_0.vars.bg_info.bg2)
		
		arg_38_0.vars.bg_info.eff1 = EffectManager:Play({
			pivot_x = 0,
			fn = "narak_eff_idle_front.cfx",
			pivot_y = -150,
			pivot_z = 0,
			layer = var_38_0
		})
		arg_38_0.vars.bg_info.bg3 = CACHE:getEffect("narak_front_t2")
		
		arg_38_0.vars.bg_info.bg3:setScale(1)
		arg_38_0.vars.bg_info.bg3:setPosition(0, -150)
		arg_38_0.vars.bg_info.bg3:setAnimation(0, "idle", true)
		var_38_0:addChild(arg_38_0.vars.bg_info.bg3)
	end
	
	arg_38_0:updateClearBonus(arg_38_1, true)
	if_set_visible(arg_38_1, "reward", false)
	
	if not TutorialGuide:isClearedTutorial("system_178") and UnlockSystem:isUnlockSystem(UNLOCK_ID.HELL_CHALLENGE) then
		UIAction:Add(SEQ(DELAY(500), CALL(function()
			if not (DungeonList.vars and DungeonList.vars.enter or nil) and not arg_38_0:isShowHardMode() and not TutorialGuide:isPlayingTutorial() then
				TutorialGuide:ifStartGuide("system_178")
			end
		end)), arg_38_0.vars.layer, "block")
	end
	
	return arg_38_0.vars.layer
end

function DungeonHell.getCurFloor(arg_41_0, arg_41_1)
	return math.min(arg_41_1 and Account:getHardHellFloor() + 1 or Account:getHellFloor(), arg_41_0:getMaxFloor(arg_41_1))
end

function DungeonHell.isChallengeRetryMode(arg_42_0, arg_42_1)
	return Account:getMapClearCount(arg_42_1) > 0 and arg_42_0:isAbyssHardMap(arg_42_1)
end

function DungeonHell.onStartBattle(arg_43_0, arg_43_1)
	DungeonList.vars.enter_info = {
		show_ready_dialog = true
	}
	
	startBattle(arg_43_1.enter_id, {
		practice_mode = arg_43_1.practice_mode
	})
end

function DungeonHell.getChallengeData(arg_44_0)
	return (DBT("level_world_3_chapter", "abysshard", {
		"id",
		"name",
		"desc",
		"reward_vars"
	}))
end

function DungeonHell.getStarRewardData(arg_45_0)
	local var_45_0 = arg_45_0:getChallengeData()
	local var_45_1 = totable(var_45_0.reward_vars)
	local var_45_2 = {}
	local var_45_3 = false
	
	for iter_45_0, iter_45_1 in pairs(var_45_1 or {}) do
		local var_45_4 = arg_45_0:getMyStarCount()
		local var_45_5 = Account:getWorldmapReward("abysshard") or 0
		local var_45_6 = to_n(iter_45_1[1])
		local var_45_7 = 0
		
		if var_45_6 <= var_45_5 then
			var_45_7 = -1
		elseif var_45_6 <= var_45_4 then
			var_45_7 = 1
			var_45_3 = true
		elseif var_45_4 < var_45_6 then
			var_45_7 = 0
		end
		
		iter_45_1.state = var_45_7
		iter_45_1[1] = to_n(iter_45_1[1])
		iter_45_1[3] = to_n(iter_45_1[3])
		
		table.push(var_45_2, iter_45_1)
	end
	
	table.sort(var_45_2, function(arg_46_0, arg_46_1)
		if arg_46_0.state == arg_46_1.state then
			return arg_46_0[1] < arg_46_1[1]
		end
		
		return arg_46_0.state > arg_46_1.state
	end)
	
	local var_45_8
	
	for iter_45_2, iter_45_3 in ipairs(var_45_2) do
		if iter_45_3.state == 0 or iter_45_3.state == 1 then
			iter_45_3.ing = true
			var_45_8 = iter_45_3
			
			break
		end
	end
	
	var_45_8 = var_45_8 or var_45_2[#var_45_2]
	
	return var_45_2, var_45_3, var_45_8
end

function DungeonHell.getAllStarCount(arg_47_0)
	local var_47_0 = 0
	
	for iter_47_0 = 1, 999 do
		local var_47_1 = "abysshard" .. string.format("%03d", iter_47_0)
		
		if not DB("level_enter", var_47_1, {
			"id"
		}) then
			break
		end
		
		var_47_0 = var_47_0 + 3
	end
	
	return var_47_0
end

function DungeonHell.getMyStarCount(arg_48_0)
	local var_48_0 = 0
	
	for iter_48_0 = 1, 999 do
		local var_48_1 = "abysshard" .. string.format("%03d", iter_48_0)
		
		if not DB("level_enter", var_48_1, {
			"id"
		}) then
			break
		end
		
		local var_48_2 = Account:getStageScore(var_48_1)
		
		if var_48_2 then
			var_48_0 = var_48_0 + var_48_2
		end
	end
	
	return var_48_0
end

function DungeonHell.updateStarRewardUI(arg_49_0)
	local var_49_0, var_49_1, var_49_2 = arg_49_0:getStarRewardData()
	
	if_set(arg_49_0.vars.wnd, "t_star_count", "x " .. arg_49_0:getMyStarCount())
	if_set_percent(arg_49_0.vars.wnd, "progress_bar", arg_49_0:getMyStarCount() / var_49_2[1])
	if_set(arg_49_0.vars.wnd, "t_progress", arg_49_0:getMyStarCount() .. "/" .. var_49_2[1])
	if_set_visible(arg_49_0.vars.wnd:getChildByName("btn_reward"), "icon_noti", var_49_1)
	
	local var_49_3 = arg_49_0.vars.wnd:getChildByName("next_reward")
	
	if get_cocos_refid(var_49_3) then
		var_49_3:removeFromParent()
	end
	
	local var_49_4 = UIUtil:getRewardIcon(to_n(var_49_2[3]), var_49_2[2], {
		scale = 1,
		parent = arg_49_0.vars.wnd:getChildByName("reward_item")
	})
	
	var_49_4:setName("next_reward")
	
	if (Account:getWorldmapReward("abysshard") or 0) >= arg_49_0:getAllStarCount() then
		var_49_4:setOpacity(76.5)
	end
end

function DungeonHell.createEnterWindow(arg_50_0, arg_50_1, arg_50_2)
	arg_50_0.vars.wnd = load_control("wnd/dungeon_hell.csb")
	
	arg_50_0.vars.wnd:setAnchorPoint(0.5, 0.5)
	arg_50_0.vars.wnd:setScale(1)
	arg_50_0.vars.wnd:setPosition(0 - VIEW_BASE_LEFT * 2, 0)
	arg_50_0.vars.wnd:setVisible(false)
	arg_50_0.vars.wnd:setLocalZOrder(1)
	arg_50_0.vars.layer:addChild(arg_50_0.vars.wnd)
	arg_50_0.vars.layer:sortAllChildren()
	
	if get_cocos_refid(arg_50_0.vars.listener) then
		arg_50_0:removeScrollEventListener(arg_50_0.vars.scrollview)
	end
	
	local var_50_0 = arg_50_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_50_0) then
		arg_50_0.vars.listener = cc.EventListenerTouchOneByOne:create()
		
		arg_50_0.vars.listener:registerScriptHandler(function(arg_51_0, arg_51_1)
			return arg_50_0:onTouchDown(arg_51_0, arg_51_1)
		end, cc.Handler.EVENT_TOUCH_BEGAN)
		arg_50_0.vars.listener:registerScriptHandler(function(arg_52_0, arg_52_1)
			return arg_50_0:onTouchUp(arg_52_0, arg_52_1)
		end, cc.Handler.EVENT_TOUCH_ENDED)
		arg_50_0.vars.listener:registerScriptHandler(function(arg_53_0, arg_53_1)
			return arg_50_0:onTouchMove(arg_53_0, arg_53_1)
		end, cc.Handler.EVENT_TOUCH_MOVED)
		
		local var_50_1 = cc.Node:create()
		
		var_50_1:setName("priority_node")
		arg_50_0.vars.scrollview:addChild(var_50_1)
		var_50_0:addEventListenerWithSceneGraphPriority(arg_50_0.vars.listener, var_50_1)
	end
	
	local var_50_2 = arg_50_1.unlock_id == UNLOCK_ID.HELL_CHALLENGE or arg_50_1.is_hard_mode
	
	if_set_visible(arg_50_0.vars.wnd, "cleanning", not var_50_2)
	if_set_visible(arg_50_0.vars.wnd, "n_star_reward", var_50_2)
	
	arg_50_0.vars.floor_info_node = arg_50_0.vars.wnd:getChildByName("floor_info")
	arg_50_0.vars.enter_btn = arg_50_0.vars.wnd:getChildByName("btn_go")
	
	arg_50_0:updateClearBonus(arg_50_0.vars.wnd)
	
	local var_50_3 = arg_50_0:isShowHardMode() and "abysshard" or "aby"
	local var_50_4 = DB("level_world_3_chapter", var_50_3, "name")
	
	if_set(arg_50_0.vars.wnd:getChildByName("contents"), "label", T(var_50_4))
	
	if arg_50_0:isShowHardMode() then
		arg_50_0:updateStarRewardUI()
	end
	
	local var_50_5, var_50_6 = DB("level_battlemenu", "abysshard", {
		"name",
		"desc_content"
	})
	local var_50_7 = arg_50_0:isShowHardMode() and T(var_50_5) or arg_50_2.title
	local var_50_8 = arg_50_0:isShowHardMode() and T(var_50_6) or arg_50_2.desc
	
	if_set(arg_50_0.vars.wnd, "txt_title", var_50_7)
	if_set(arg_50_0.vars.wnd, "txt_desc", var_50_8)
	arg_50_0:createTower(arg_50_1)
	
	if not arg_50_0:isShowHardMode() then
		arg_50_0:updateCleaningInfo(true)
	end
end

function DungeonHell.CheckNotification(arg_54_0)
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.HELL) and arg_54_0:Cleanable()
end

function DungeonHell.Cleanable(arg_55_0)
	return Account:getCurrency("abysskey") > 0 and Account:getHellFloor() - 1 > 0
end

function DungeonHell.updateCleaningInfo(arg_56_0, arg_56_1)
	local var_56_0 = {
		DungeonList:getLeftWnd(),
		arg_56_0.vars and arg_56_0.vars.wnd
	}
	
	for iter_56_0, iter_56_1 in pairs(var_56_0) do
		if not get_cocos_refid(iter_56_1) then
			return 
		end
		
		if_set_visible(iter_56_1, "cleanning", arg_56_1)
		
		local var_56_1 = iter_56_1:getChildByName("cleanning")
		
		if_set_opacity(var_56_1, "n_all_clear_reward1", Account:getHellFloor() - 1 > 0 and 255 or 76.5)
		if_set_opacity(var_56_1, "n_all_clear_reward2", Account:getHellFloor() - 1 > 0 and 255 or 76.5)
		
		local var_56_2 = var_56_1:getChildByName("btn_clean")
		
		UIUtil:changeButtonState(var_56_2, Account:getHellFloor() - 1 > 0)
		if_set_visible(var_56_2, "cm_icon_noti_clean", arg_56_0:Cleanable())
		
		local var_56_3 = Account:getHellFloor() - 1
		
		if var_56_3 > 0 then
			if_set(var_56_1, "txt_clear", T("hell_prize", {
				floor = var_56_3
			}))
		else
			if_set(var_56_1, "txt_clear", T("hell_cure_title"))
		end
	end
end

function DungeonHell.getTowerPart(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	arg_57_3 = arg_57_3 or ""
	
	if arg_57_1 then
		arg_57_2 = "narak_tower_" .. arg_57_1
	end
	
	local var_57_0 = arg_57_2 .. arg_57_3
	local var_57_1 = CACHE:getEffect(var_57_0)
	
	var_57_1:start()
	
	return var_57_1
end

function DungeonHell.createChainLayer(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = cc.Layer:create()
	local var_58_1
	local var_58_2 = {}
	local var_58_3 = {}
	local var_58_4 = {}
	
	arg_58_0.vars.chain_height = 3000
	
	for iter_58_0 = 0, arg_58_1 do
		table.push(var_58_2, math.random())
		table.push(var_58_3, math.random())
		table.push(var_58_4, math.random())
	end
	
	for iter_58_1 = 0, 1 do
		for iter_58_2, iter_58_3 in pairs(var_58_2) do
			local var_58_5 = arg_58_0:isShowHardMode() and "bg/abyss/narak_2_chain.png" or "bg/abyss/narak_chain.png"
			local var_58_6 = cc.Sprite:create(var_58_5)
			
			var_58_6:setPosition(var_0_0 + VIEW_BASE_LEFT * 2, iter_58_1 * arg_58_0.vars.chain_height + arg_58_0.vars.chain_height * 0.1 + iter_58_3 * arg_58_0.vars.chain_height * 0.8)
			var_58_6:setScale(arg_58_2 - arg_58_2 * 0.2 + var_58_4[iter_58_2] * arg_58_2 * 0.2)
			var_58_6:setRotation(30 - 60 * var_58_3[iter_58_2])
			var_58_6:setOpacity(arg_58_3 * 255)
			var_58_0:addChild(var_58_6)
		end
	end
	
	arg_58_0.vars.bg_chain:addChild(var_58_0)
	
	return var_58_0
end

function DungeonHell.createTower(arg_59_0, arg_59_1)
	arg_59_0.vars.part_offset = 340
	arg_59_0.vars.part_count = 0
	arg_59_0.vars.start_gap = 440
	arg_59_0.vars.parts = {}
	
	arg_59_0.vars.scrollview:setScrollStep(arg_59_0.vars.part_offset)
	arg_59_0.vars.scrollview:setScrollSpeed(5)
	
	local var_59_0 = arg_59_0.vars.start_gap
	
	arg_59_0.vars.infos = {}
	
	local var_59_1 = arg_59_0:isShowHardMode() and arg_59_0:getMaxChallengeFloor() or arg_59_0:getMaxFloor()
	
	for iter_59_0 = 1, var_59_1 do
		local var_59_2 = {}
		local var_59_3 = arg_59_0:isShowHardMode() and "abysshard" or "abyss"
		
		var_59_2.id, var_59_2.name, var_59_2.reward = DB("level_enter", var_59_3 .. string.format("%03d", iter_59_0), {
			"id",
			"name",
			"abyss_reward"
		})
		
		if not var_59_2.id then
			break
		end
		
		table.push(arg_59_0.vars.infos, var_59_2)
	end
	
	arg_59_0.vars.part_count = #arg_59_0.vars.infos
	
	arg_59_0.vars.scrollview:setLocalZOrder(1)
	
	for iter_59_1 = 1, arg_59_0.vars.part_count do
		local var_59_4 = math.random(1, 4)
		local var_59_5 = arg_59_0.vars.part_count + 1 - iter_59_1
		
		if var_59_5 % 5 == 0 then
			var_59_4 = 5
		end
		
		local var_59_6 = arg_59_0:getTowerPart(var_59_4, "", arg_59_0:isShowHardMode() and "_v2")
		
		var_59_6:setPosition(var_0_0, var_59_0 - 100)
		arg_59_0.vars.scrollview:addChild(var_59_6)
		
		if math.random(1, 2) == 2 then
			var_59_6:setScaleX(-1)
		end
		
		arg_59_0.vars.cur_floor = arg_59_0:isShowHardMode() and Account:getHardHellFloor() + 1 or Account:getHellFloor()
		
		if var_59_5 > arg_59_0.vars.cur_floor then
			local var_59_7 = cc.Sprite:create("img/cm_icon_etclock.png")
			
			var_59_7:setScale(4)
			var_59_6:addChild(var_59_7)
			var_59_7:setColor(cc.c3b(160, 160, 160))
			var_59_6:setColor(cc.c3b(160, 160, 160))
		end
		
		var_59_0 = var_59_0 + arg_59_0.vars.part_offset
		
		var_59_6:setVisible(false)
		
		arg_59_0.vars.parts[var_59_5] = var_59_6
	end
	
	local var_59_8 = arg_59_0:getTowerPart(nil, "narak_tower_start", arg_59_0:isShowHardMode() and "_v2")
	
	var_59_8:setPosition(var_0_0, var_59_0 + 50)
	arg_59_0.vars.scrollview:addChild(var_59_8)
	
	arg_59_0.vars.view_height = arg_59_0.vars.part_offset * (arg_59_0.vars.part_count + 1)
	
	arg_59_0.vars.scrollview:setInnerContainerSize({
		width = "840",
		height = arg_59_0.vars.view_height
	})
	
	arg_59_0.vars.height = var_59_0
	
	local var_59_9
	
	for iter_59_2 = 0, 1 do
		local var_59_10 = arg_59_0:isShowHardMode() and "narak_2" or "narak"
		local var_59_11 = cc.Sprite:create("bg/abyss/" .. var_59_10 .. "_bg.png")
		
		var_59_11:setAnchorPoint(0, 0)
		var_59_11:setPositionX(VIEW_BASE_LEFT)
		var_59_11:setScale(4)
		var_59_11:setPositionY(iter_59_2 * 265 * 4)
		
		arg_59_0.vars.bg_height = 1060
		
		arg_59_0.vars.bg_back:addChild(var_59_11)
	end
	
	arg_59_0.vars.bg_chain_layers[1] = arg_59_0:createChainLayer(2, 0.8, 0.5)
	arg_59_0.vars.bg_chain_layers[2] = arg_59_0:createChainLayer(3, 1, 0.8)
	arg_59_0.vars.bg_chain_layers[3] = arg_59_0:createChainLayer(4, 1.5, 1)
	
	local var_59_12 = arg_59_0:isShowHardMode() and "narak_2_center_glow" or "narak_center_glow"
	local var_59_13 = cc.Sprite:create("bg/abyss/" .. var_59_12 .. ".png")
	
	var_59_13:setScale(4)
	var_59_13:setPosition(450, 360)
	var_59_13:setBlendFunc({
		src = gl.ONE,
		dst = gl.ONE_MINUS_SRC_COLOR
	})
	arg_59_0.vars.bg_chain:addChild(var_59_13)
	if_set_visible(arg_59_0.vars.wnd_scrollview, "n_tower", false)
	arg_59_0:updateBackground()
end

function DungeonHell.getSceneState(arg_60_0)
	return {
		is_hard_mode = arg_60_0:isShowHardMode()
	}
end

function DungeonHell.onEnter(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	set_high_fps_tick(10000)
	
	arg_61_2 = arg_61_2 or {}
	
	if arg_61_2.unlock_id == UNLOCK_ID.HELL_CHALLENGE or arg_61_2.is_hard_mode then
		TopBarNew:checkhelpbuttonID("infoabys_4")
	else
		TopBarNew:checkhelpbuttonID("infoabys")
	end
	
	arg_61_0:createEnterWindow(arg_61_2, arg_61_3)
	
	if arg_61_0.vars.bg_info.bg1 then
		arg_61_0.vars.bg_info.bg1:setAnimation(0, "intro", false)
		arg_61_0.vars.bg_info.bg2:setAnimation(0, "intro", false)
		
		if arg_61_0:isShowHardMode() then
			arg_61_0.vars.bg_info.bg3:setVisible(true)
			arg_61_0.vars.bg_info.bg3:setAnimation(0, "intro", false)
		else
			arg_61_0.vars.bg_info.bg3:setVisible(false)
		end
	end
	
	arg_61_0.vars.bg_info.eff2 = EffectManager:Play({
		pivot_y = 300,
		pivot_x = 500,
		fn = "narak_eff_intro_back.cfx",
		layer = arg_61_0.vars.wnd_scrollview
	})
	arg_61_0.vars.bg_info.eff3 = EffectManager:Play({
		pivot_x = 500,
		fn = "narak_eff_intro.cfx",
		pivot_y = 300,
		pivot_z = 2,
		layer = arg_61_0.vars.wnd_scrollview
	})
	
	local var_61_0 = 1300
	
	if arg_61_2.enter then
		arg_61_0.vars.bg_info.bg1:setVisible(false)
		arg_61_0.vars.bg_info.bg2:setVisible(false)
		arg_61_0.vars.bg_info.bg3:setVisible(false)
		
		var_61_0 = 0
	end
	
	arg_61_0.vars.bg_info.eff0:removeFromParent()
	
	arg_61_0.vars.bg_info.eff0 = nil
	
	UIAction:Add(SEQ(RLOG(MOVE_TO(600, 0, 1000)), REMOVE()), arg_61_0.vars.bg_info.eff1, "block")
	UIAction:Add(SEQ(DELAY(var_61_0), CALL(arg_61_0.showWindow, arg_61_0, arg_61_2)), arg_61_0, "block")
	
	local var_61_1 = DungeonList:getModeInfo()
	
	DungeonList:updateLimitInfo(nil, arg_61_0.vars.layer, var_61_1.enter_limit)
	
	if Account:getUserConfigsHash("user_etc1", "hell_reward_adjust") == nil and arg_61_2.unlock_id ~= UNLOCK_ID.HELL_CHALLENGE then
		if_set_visible(arg_61_0.vars.wnd, "btn_temporary_gat", true)
	end
end

function DungeonHell.showWindow(arg_62_0, arg_62_1)
	arg_62_0.vars.wnd:setVisible(true)
	if_set_visible(arg_62_0.vars.wnd_scrollview, "n_tower", true)
	
	local var_62_0 = not ContentDisable:byAlias("abyss_guide") and IS_PUBLISHER_STOVE
	
	if_set_visible(arg_62_0.vars.wnd, "btn_discussion", var_62_0)
	
	local var_62_1 = arg_62_0.vars.wnd:getChildByName("LEFT")
	local var_62_2 = arg_62_0.vars.wnd:getChildByName("RIGHT")
	
	if not arg_62_1.enter then
		var_62_1:setPositionX(VIEW_BASE_LEFT - 400)
		var_62_2:setPositionX(VIEW_BASE_RIGHT + 600)
		UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT + NotchStatus:getNotchSafeLeft())), var_62_1, "block")
		UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_RIGHT + NotchStatus:getNotchSafeRight())), var_62_2, "block")
	end
	
	local var_62_3 = arg_62_0:isShowHardMode() and Account:getHardHellFloor() + 1 or Account:getHellFloor()
	
	if var_62_3 == 1 then
		arg_62_0.vars.scrollview:setInnerContainerPosition({
			x = 0,
			y = 0 - arg_62_0.vars.view_height + 200
		})
	end
	
	arg_62_0:moveToFloor(var_62_3, not arg_62_1.enter, 1.5)
end

function DungeonHell.onLeave(arg_63_0)
	arg_63_0.vars.bg_info = {}
	
	if UnlockSystem:isUnlockSystem(UNLOCK_ID.HELL_CHALLENGE) and not arg_63_0:isShowHardMode() then
		TutorialGuide:ifStartGuide("system_178")
	end
	
	arg_63_0:removeScrollEventListener(arg_63_0.vars.scrollview)
	TopBarNew:checkhelpbuttonID("infodung")
end

function DungeonHell.moveToFloor(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	arg_64_3 = arg_64_3 or 2
	arg_64_1 = math.max(0, math.min(arg_64_0.vars.part_count, arg_64_1))
	
	local var_64_0 = (arg_64_1 - 1) * (100 / (arg_64_0.vars.part_count - 1))
	
	if arg_64_2 then
		arg_64_0.vars.scrollview:scrollToPercentVertical(var_64_0, arg_64_3, true)
	else
		arg_64_0.vars.scrollview:jumpToPercentVertical(var_64_0)
	end
end

function DungeonHell.getChallengeMissionStarCount(arg_65_0, arg_65_1)
	local var_65_0 = "abysshard" .. string.format("%03d", arg_65_1)
	
	return Account:getStageScore(var_65_0)
end

function DungeonHell.updateBackground(arg_66_0, arg_66_1, arg_66_2)
	if not arg_66_0.vars.bg_height then
		return 
	end
	
	local var_66_0 = arg_66_0.vars.scrollview:getInnerContainerPosition().y
	
	arg_66_0:arrangeBackgroundOffset(arg_66_0.vars.bg_back, arg_66_0.vars.bg_height, var_66_0, 0.05)
	arg_66_0:arrangeBackgroundOffset(arg_66_0.vars.bg_chain_layers[1], arg_66_0.vars.chain_height, var_66_0, 0.1)
	arg_66_0:arrangeBackgroundOffset(arg_66_0.vars.bg_chain_layers[2], arg_66_0.vars.chain_height, var_66_0, 0.13)
	arg_66_0:arrangeBackgroundOffset(arg_66_0.vars.bg_chain_layers[3], arg_66_0.vars.chain_height, var_66_0, 0.2)
	
	local var_66_1 = arg_66_0.vars.i_floor
	
	arg_66_0.vars.f_floor = arg_66_0.vars.part_count - ((0 - var_66_0) / (arg_66_0.vars.view_height / (arg_66_0.vars.part_count + 1)) + 1) + 1
	arg_66_0.vars.f_floor = math.max(1, math.min(arg_66_0.vars.f_floor, arg_66_0.vars.part_count))
	arg_66_0.vars.i_floor = math.floor(arg_66_0.vars.f_floor + 0.5)
	
	arg_66_0.vars.floor_info_node:setPositionY((arg_66_0.vars.f_floor - arg_66_0.vars.i_floor) * 103)
	
	if var_66_1 ~= arg_66_0.vars.i_floor then
		local var_66_2 = arg_66_0.vars.i_floor == arg_66_0.vars.cur_floor
		local var_66_3 = var_66_1 and var_66_1 == arg_66_0.vars.cur_floor
		
		arg_66_0.vars.enter_btn.guide_tag = nil
		
		if var_66_2 ~= var_66_3 then
			if var_66_2 then
				arg_66_0.vars.enter_btn.guide_tag = tostring(arg_66_0.vars.i_floor)
			end
			
			if_set_visible(arg_66_0.vars.wnd, "ON", true)
			
			if not arg_66_0:isShowHardMode() then
				if_set_visible(arg_66_0.vars.wnd, "--OFF", arg_66_0.vars.i_floor < arg_66_0.vars.cur_floor)
			end
		end
		
		local var_66_4 = ""
		local var_66_5 = arg_66_0.vars.i_floor == arg_66_0.vars.cur_floor and "available" or arg_66_0.vars.i_floor < arg_66_0.vars.cur_floor and "complete" or "locked"
		local var_66_6 = arg_66_0:isShowHardMode() and arg_66_0:getMaxChallengeFloor() or arg_66_0:getMaxFloor()
		local var_66_7 = arg_66_0.vars.wnd:getChildByName("n_complete")
		
		if get_cocos_refid(var_66_7) then
			if_set(var_66_7, "label", T("hell_moveto", {
				floor = arg_66_0.vars.cur_floor
			}))
			if_set_visible(var_66_7, "btn_go_floor", var_66_6 >= arg_66_0.vars.cur_floor)
		end
		
		local var_66_8 = arg_66_0.vars.wnd:getChildByName("n_locked")
		
		if get_cocos_refid(var_66_8) then
			if_set(var_66_8, "label", T("hell_moveto", {
				floor = arg_66_0.vars.cur_floor
			}))
			if_set_visible(var_66_8, "btn_go_floor", var_66_6 >= arg_66_0.vars.cur_floor)
		end
		
		if_set_visible(arg_66_0.vars.wnd, "n_available", var_66_5 == "available")
		if_set_visible(arg_66_0.vars.wnd, "n_complete", var_66_5 == "complete")
		if_set_visible(arg_66_0.vars.wnd, "n_locked", var_66_5 == "locked")
		if_set(arg_66_0.vars.wnd, "label_title", T(arg_66_0.vars.infos[arg_66_0.vars.i_floor].name))
		
		if arg_66_0.vars.parts[arg_66_0.vars.i_floor - 3] then
			arg_66_0.vars.parts[arg_66_0.vars.i_floor - 3]:setVisible(false)
		end
		
		if arg_66_0.vars.parts[arg_66_0.vars.i_floor - 2] then
			arg_66_0.vars.parts[arg_66_0.vars.i_floor - 2]:setVisible(true)
		end
		
		if arg_66_0.vars.parts[arg_66_0.vars.i_floor - 1] then
			arg_66_0.vars.parts[arg_66_0.vars.i_floor - 1]:setVisible(true)
		end
		
		if arg_66_0.vars.parts[arg_66_0.vars.i_floor] then
			arg_66_0.vars.parts[arg_66_0.vars.i_floor]:setVisible(true)
		end
		
		if arg_66_0.vars.parts[arg_66_0.vars.i_floor + 1] then
			arg_66_0.vars.parts[arg_66_0.vars.i_floor + 1]:setVisible(true)
		end
		
		if arg_66_0.vars.parts[arg_66_0.vars.i_floor + 2] then
			arg_66_0.vars.parts[arg_66_0.vars.i_floor + 2]:setVisible(false)
		end
		
		if arg_66_0:isShowHardMode() then
			arg_66_0:updateFloorRewardInfoForChallenge()
		else
			arg_66_0:updateFloorRewardInfo()
		end
		
		if arg_66_2 then
			vibrate(VIBRATION_TYPE.Select)
		end
		
		for iter_66_0 = -3, 3 do
			local var_66_9 = iter_66_0 + arg_66_0.vars.i_floor
			local var_66_10 = arg_66_0.vars.floor_info_node:getChildByName("F" .. iter_66_0)
			
			var_66_10.guide_tag = tostring(var_66_9)
			
			if var_66_9 < 1 or var_66_9 > arg_66_0.vars.part_count then
				var_66_10:setVisible(false)
			else
				var_66_10:setVisible(true)
				if_set(var_66_10, "floor", T("hell_floor", {
					floor = var_66_9
				}))
				
				local var_66_11 = var_66_10:getChildByName("floor")
				local var_66_12 = var_66_10:getChildByName("desc")
				
				if arg_66_0:isShowHardMode() then
					if_set_visible(var_66_10, "n_star", true)
					
					local var_66_13 = arg_66_0:getChallengeMissionStarCount(var_66_9)
					
					for iter_66_1 = 1, 3 do
						if_set_visible(var_66_10, "icon_star" .. iter_66_1, false)
					end
					
					for iter_66_2 = 1, var_66_13 do
						if_set_visible(var_66_10, "icon_star" .. iter_66_2, true)
					end
				end
				
				if_set_visible(var_66_10, "completed", var_66_9 < arg_66_0.vars.cur_floor)
				if_set_visible(var_66_10, "lock", var_66_9 > arg_66_0.vars.cur_floor)
				
				if var_66_9 == arg_66_0.vars.cur_floor then
					var_66_11:setTextColor(cc.c3b(255, 255, 255))
					var_66_11:setOpacity(255)
					var_66_12:setTextColor(cc.c3b(171, 135, 89))
					var_66_12:setOpacity(255)
					var_66_12:setString(T("ui_dungeon_hell_floorinfo_desc2"))
				elseif var_66_9 < arg_66_0.vars.cur_floor then
					var_66_11:setTextColor(cc.c3b(255, 255, 255))
					var_66_11:setOpacity(255)
					var_66_12:setTextColor(cc.c3b(107, 193, 27))
					var_66_12:setOpacity(255)
					var_66_12:setString(T("ui_dungeon_hell_floorinfo_desc1"))
				else
					var_66_11:setTextColor(cc.c3b(180, 180, 180))
					var_66_11:setOpacity(255)
					var_66_12:setTextColor(cc.c3b(180, 180, 180))
					var_66_12:setOpacity(76.5)
					var_66_12:setString(T("ui_dungeon_hell_floorinfo_desc3"))
				end
			end
		end
		
		if not arg_66_0:isShowHardMode() then
			GrowthGuideNavigator:proc()
		else
			GrowthGuideNavigator:clearNavigators()
		end
	end
end

function DungeonHell.getChallengeRewards(arg_67_0, arg_67_1)
	local var_67_0 = {}
	local var_67_1 = arg_67_1 or "abysshard" .. string.format("%03d", arg_67_0.vars.i_floor)
	local var_67_2, var_67_3, var_67_4, var_67_5, var_67_6 = DB("level_enter", var_67_1, {
		"show_first_clear_reward",
		"show_mission_ready",
		"mission1",
		"mission2",
		"mission3"
	})
	local var_67_7 = var_67_2 ~= nil and totable(var_67_2) or nil
	
	if var_67_7 then
		for iter_67_0, iter_67_1 in pairs(var_67_7) do
			if type(iter_67_1) == "string" then
				var_67_7[iter_67_0] = {
					iter_67_1
				}
			end
		end
	end
	
	for iter_67_2, iter_67_3 in pairs(var_67_7 or {}) do
		iter_67_3.is_half = Account:isMapCleared(var_67_1)
		iter_67_3.first_reward = true
		
		table.push(var_67_0, iter_67_3)
	end
	
	local function var_67_8(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
		local var_68_0, var_68_1 = DB("mission_data", arg_68_2, {
			"reward_count1",
			"reward_id1"
		})
		local var_68_2 = Account:isDungeonMissionCleared(arg_68_1, arg_68_0) == true and true or nil
		local var_68_3 = var_68_2 == nil and true or nil
		
		table.insert(arg_68_3, {
			var_68_1,
			var_68_0,
			mission_clear = var_68_2,
			star_reward = var_68_3
		})
	end
	
	if var_67_3 and var_67_3 == "y" then
		var_67_8(1, var_67_1, var_67_4, var_67_0)
		var_67_8(2, var_67_1, var_67_5, var_67_0)
		var_67_8(3, var_67_1, var_67_6, var_67_0)
	end
	
	return var_67_0
end

function DungeonHell.updateFloorRewardInfoForChallenge(arg_69_0)
	local var_69_0 = {}
	local var_69_1 = (arg_69_0:isShowHardMode() and "abysshard" or "abyss") .. string.format("%03d", arg_69_0.vars.i_floor)
	local var_69_2 = UIUtil:sortDisplayItems(arg_69_0:getChallengeRewards(var_69_1), var_69_1)
	
	for iter_69_0 = 1, 6 do
		var_69_0[iter_69_0] = arg_69_0.vars.wnd:getChildByName("n_item" .. iter_69_0)
		
		if get_cocos_refid(var_69_0[iter_69_0]) then
			var_69_0[iter_69_0]:removeAllChildren()
			
			local var_69_3 = var_69_2[iter_69_0] or {}
			local var_69_4 = var_69_3[1]
			local var_69_5 = var_69_3[2]
			local var_69_6 = var_69_3[3]
			local var_69_7 = var_69_3[4]
			
			var_69_3.reward_info = {}
			
			if var_69_3.first_reward or var_69_3.is_half then
				if var_69_3.is_half then
					var_69_3.reward_info.first_reward_owned = true
				else
					var_69_3.reward_info.first_reward = true
				end
			end
			
			var_69_3.reward_info.stage_mission = var_69_3.star_reward
			var_69_3.reward_info.stage_mission_owned = var_69_3.mission_clear
			
			if var_69_4 then
				local var_69_8 = {
					show_small_count = true,
					tooltip_y = -200,
					no_resize_name = false,
					tooltip_x = -400,
					scale = 0.8,
					parent = var_69_0[iter_69_0],
					count = var_69_4,
					set_drop = var_69_6,
					grade_rate = var_69_7,
					reward_info = var_69_3.reward_info
				}
				local var_69_9 = UIUtil:getRewardIcon(var_69_5, var_69_4, var_69_8)
				
				IconUtil.setIcon(var_69_9).addFirstReward(var_69_3.first_reward or var_69_3.is_half, var_69_3.is_half and var_69_3.is_half == true and tocolor("#888888"), var_69_3.is_half).addStar(var_69_3.star_reward, var_69_3.mission_clear and var_69_3.mission_clear == true and tocolor("#888888")).addCheckIcon(var_69_3.is_half or var_69_3.mission_clear).done()
				if_set(var_69_9, "txt_small_count", comma_value(var_69_5))
				
				local var_69_10 = var_69_9:getChildByName("n_root")
				
				if var_69_10 then
					var_69_10:setScale(0.9)
				end
			end
		end
	end
end

function DungeonHell.updateFloorRewardInfo(arg_70_0)
	local var_70_0 = {
		arg_70_0.vars.wnd:getChildByName("n_item1"),
		arg_70_0.vars.wnd:getChildByName("n_item2")
	}
	local var_70_1 = arg_70_0:isShowHardMode() and "abysshard" or "abyss" .. string.format("%03d", arg_70_0.vars.i_floor)
	local var_70_2 = {}
	
	for iter_70_0 = 1, 2 do
		local var_70_3, var_70_4, var_70_5, var_70_6 = DB("level_enter_drops", var_70_1, {
			"item" .. iter_70_0,
			"type" .. iter_70_0,
			"set" .. iter_70_0,
			"grade_rate" .. iter_70_0
		})
		
		table.insert(var_70_2, {
			var_70_3,
			var_70_4,
			var_70_5,
			var_70_6
		})
	end
	
	local var_70_7 = UIUtil:sortDisplayItems(var_70_2, var_70_1)
	
	for iter_70_1 = 1, 2 do
		if var_70_0[iter_70_1] then
			var_70_0[iter_70_1]:removeAllChildren()
			
			local var_70_8 = var_70_7[iter_70_1] or {}
			local var_70_9 = var_70_8[1]
			local var_70_10 = var_70_8[2]
			local var_70_11 = var_70_8[3]
			local var_70_12 = var_70_8[4]
			
			if var_70_9 then
				local var_70_13 = {
					show_small_count = true,
					tooltip_y = -200,
					no_resize_name = false,
					tooltip_x = -400,
					scale = 0.8,
					parent = var_70_0[iter_70_1],
					count = var_70_9,
					set_drop = var_70_11,
					grade_rate = var_70_12,
					reward_info = var_70_8.reward_info
				}
				local var_70_14 = UIUtil:getRewardIcon(var_70_10, var_70_9, var_70_13):getChildByName("n_root")
				
				if var_70_14 then
					var_70_14:setScale(0.9)
				end
			end
		end
	end
end

function DungeonHell.arrangeBackgroundOffset(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	local var_71_0 = arg_71_3 * arg_71_4
	
	if var_71_0 > 0 then
		var_71_0 = var_71_0 - arg_71_2
	end
	
	while var_71_0 < 0 - arg_71_2 do
		var_71_0 = var_71_0 + arg_71_2
	end
	
	arg_71_1:setPositionY(var_71_0)
end

function DungeonHell.onAfterUpdate(arg_72_0)
	if arg_72_0.vars and arg_72_0.vars.clean_info then
		local var_72_0 = uitick() - arg_72_0.vars.clean_info.begin_tm
		
		if var_72_0 >= 500 then
			local var_72_1 = (var_72_0 - 500) / arg_72_0.vars.clean_info.scroll_tm
			local var_72_2 = math.log(1 + 5 * var_72_1, 6)
			local var_72_3 = math.min(1, var_72_2)
			local var_72_4 = (arg_72_0.vars.cur_floor - 1) * var_72_3
			local var_72_5 = math.floor(var_72_4)
			
			if var_72_5 > 0 and var_72_5 ~= arg_72_0.vars.clean_info.floor and var_72_5 ~= arg_72_0.vars.cur_floor then
				arg_72_0.vars.clean_info.floor = var_72_5
				
				EffectManager:Play({
					z = 1,
					fn = "pit_cure.cfx",
					y = 0,
					x = 0,
					layer = arg_72_0.vars.parts[var_72_5]
				})
			end
			
			arg_72_0:moveToFloor(var_72_4, false, 0)
			
			if var_72_3 >= 1 then
				arg_72_0.vars.clean_info = nil
				
				arg_72_0:onFinishClearHell()
			end
		end
	end
end

function DungeonHell.onTouchDown(arg_73_0, arg_73_1, arg_73_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_73_0.vars then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if arg_73_0:isShowStarRewardWnd() then
		return 
	end
	
	arg_73_0.vars.touchdown_dirty = arg_73_1:getLocation()
	
	return true
end

function DungeonHell.onTouchMove(arg_74_0, arg_74_1, arg_74_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_74_0.vars then
		return 
	end
	
	if arg_74_0:isShowStarRewardWnd() then
		return 
	end
	
	if not arg_74_0.vars.touchdown_dirty then
		return 
	end
	
	if math.abs(arg_74_0.vars.touchdown_dirty.x - arg_74_1:getLocation().x) > DESIGN_HEIGHT * 0.03 or math.abs(arg_74_0.vars.touchdown_dirty.y - arg_74_1:getLocation().y) > DESIGN_HEIGHT * 0.03 then
		arg_74_0.vars.touchdown_dirty = nil
	end
	
	return true
end

function DungeonHell.onTouchUp(arg_75_0, arg_75_1, arg_75_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_75_0.vars then
		return 
	end
	
	if DungeonCommon:isOverlapped() then
		return 
	end
	
	if arg_75_0:isShowStarRewardWnd() then
		return 
	end
	
	local var_75_0
	
	if arg_75_0.vars.touchdown_dirty and get_cocos_refid(arg_75_0.vars.floor_info_node) then
		var_75_0 = arg_75_1:getLocation()
		
		for iter_75_0 = -3, 3 do
			local var_75_1 = iter_75_0 + arg_75_0.vars.i_floor
			local var_75_2 = arg_75_0.vars.floor_info_node:getChildByName("F" .. iter_75_0)
			
			if var_75_1 < 1 or var_75_1 > arg_75_0.vars.part_count then
			else
				local var_75_3 = var_75_2:getChildByName("panel")
				
				if checkCollision(var_75_3, var_75_0.x, var_75_0.y) then
					arg_75_0:moveToFloor(var_75_1)
					arg_75_2:stopPropagation()
				end
			end
		end
	end
	
	return true
end

function DungeonHell.hellRewardAdjusted(arg_76_0, arg_76_1)
	if arg_76_1.rewards then
		local var_76_0 = Account:addReward(arg_76_1.rewards)
		
		Dialog:msgScrollRewards(T("temp_reward_abyss_de"), {
			open_effect = true,
			title = T("temp_reward_abyss_title"),
			rewards = {
				new_items = var_76_0.rewards
			}
		})
	end
	
	if arg_76_1.update_user_configs then
		Account:updateUserConfigs(arg_76_1.update_user_configs)
	end
	
	if arg_76_0.vars and get_cocos_refid(arg_76_0.vars.wnd) then
		if_set_opacity(arg_76_0.vars.wnd, "btn_temporary_gat", 76.5)
	end
end
