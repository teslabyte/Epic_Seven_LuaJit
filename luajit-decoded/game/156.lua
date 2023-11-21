LobbyBattleBalloon = LobbyBattleBalloon or {}
LobbyBattleBalloon.vars = {}

local var_0_0 = 3
local var_0_1 = 4
local var_0_2 = 13
local var_0_3 = 177
local var_0_4 = 189

local function var_0_5()
	local var_1_0 = {}
	
	local function var_1_1(arg_2_0, arg_2_1, arg_2_2)
		if arg_2_1 * 60 * 60 < arg_2_2() then
			return 
		end
		
		table.insert(var_1_0, {
			text_id = arg_2_0,
			get_remain_time = arg_2_2
		})
	end
	
	if UnlockSystem:isUnlockSystem(UNLOCK_ID.TRIAL_HALL) then
		local var_1_2 = Account:getTrialHallRankInfo()
		
		if not var_1_2 or not var_1_2.score then
			var_1_1("level_battlemenu_name_trial", 48, function()
				return Account:getRemainTimeTrialHall()
			end)
		end
	end
	
	if UnlockSystem:isUnlockSystem(UNLOCK_ID.AUTOMATON) and not Account:isConqueredAutomaton() then
		var_1_1("ui_dungeon_automtn_name", 48, function()
			return Account:getRemainTimeAutomaton()
		end)
	end
	
	table.sort(var_1_0, function(arg_5_0, arg_5_1)
		return arg_5_0.get_remain_time() < arg_5_1.get_remain_time()
	end)
	
	return var_1_0
end

local function var_0_6()
	local var_6_0 = load_dlg("lobby_ui_battle_item", true, "wnd")
	
	if not get_cocos_refid(var_6_0) then
		return 0
	end
	
	local var_6_1 = var_6_0:getChildByName("txt_battle_talk")
	
	if not get_cocos_refid(var_6_1) then
		return 0
	end
	
	local var_6_2 = var_6_0:getChildByName("txt_battle_time")
	
	if not get_cocos_refid(var_6_2) then
		return 0
	end
	
	local var_6_3 = 0
	local var_6_4 = var_0_5()
	
	for iter_6_0, iter_6_1 in pairs(var_6_4) do
		if_set(var_6_1, nil, T(iter_6_1.text_id))
		
		var_6_3 = math.max(var_6_3, var_6_1:getAutoRenderSize().width * var_6_1:getScaleX())
		
		local var_6_5 = math.max(iter_6_1.get_remain_time(), 0)
		
		if_set(var_6_2, nil, T("time_remain", {
			time = sec_to_string(var_6_5)
		}))
		
		var_6_3 = math.max(var_6_3, var_6_2:getAutoRenderSize().width * var_6_2:getScaleX())
	end
	
	return var_6_3
end

function LobbyBattleBalloon.set(arg_7_0, arg_7_1)
	copy_functions(ScrollView, LobbyBattleBalloon)
	
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = arg_7_1
	arg_7_0.vars.scrollview = arg_7_0.vars.wnd:getChildByName("balloon_scrollview")
	
	if not get_cocos_refid(arg_7_0.vars.scrollview) then
		return 
	end
	
	local var_7_0 = var_0_6()
	
	arg_7_0.vars.scrollview:setContentSize(var_7_0 + var_0_2, arg_7_0.vars.scrollview:getContentSize().height)
	arg_7_0.vars.scrollview:setScrollBarEnabled(false)
	
	arg_7_0.vars.scroll_sz = arg_7_0.vars.scrollview:getContentSize()
	
	arg_7_0:initScrollView(arg_7_0.vars.scrollview, arg_7_0.vars.scroll_sz.width, arg_7_0.vars.scroll_sz.height, {
		force_horizontal = true,
		onScroll = function(arg_8_0, arg_8_1, arg_8_2)
			arg_7_0:onScroll(arg_8_0, arg_8_1, arg_8_2)
		end
	})
	
	arg_7_0.vars.items = var_0_5()
	arg_7_0.vars.item_count = table.count(arg_7_0.vars.items)
	
	arg_7_0:createScrollViewItems(arg_7_0.vars.items)
	arg_7_0.vars.scrollview:setScrollStep(arg_7_0.vars.scroll_sz.width)
	arg_7_0.vars.scrollview:setScrollSpeed(8)
	arg_7_0.vars.scrollview:setMovementFactor(0.1)
	
	if arg_7_0.vars.item_count > 1 and not Scheduler:findByName("lobby_battle_balloon") then
		Scheduler:addSlow(arg_7_0.vars.scrollview, arg_7_0.onCountSeconds, arg_7_0):setName("lobby_battle_balloon")
	end
	
	arg_7_0:createPageMarker()
	
	local var_7_1 = not table.empty(arg_7_0.vars.items)
	
	if var_7_1 and arg_7_0.vars.scrollview.forceDoLayout then
		arg_7_0.vars.scrollview:forceDoLayout()
	end
	
	if_set_visible(arg_7_0.vars.wnd, nil, var_7_1)
	
	if var_7_1 and not UIAction:Find("lobby_battle_balloon") then
		arg_7_0.vars.wnd:setOpacity(0)
		
		local var_7_2 = UIAction:Find("select_gacha_talk") and 5000 or 0
		
		UIAction:Add(SEQ(DELAY(var_7_2), LOG(FADE_IN(700))), arg_7_0.vars.wnd, "lobby_battle_balloon")
	end
	
	local var_7_3 = arg_7_0.vars.wnd:getChildByName("bg_battle_balloon")
	
	if get_cocos_refid(var_7_3) then
		var_7_3:setContentSize(arg_7_0.vars.scroll_sz.width + var_0_2 * 2, var_7_3:getContentSize().height)
	end
end

function LobbyBattleBalloon.createPageMarker(arg_9_0)
	if not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	local var_9_0 = arg_9_0.vars.wnd:getChildByName("n_num")
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	for iter_9_0 = 1, var_0_0 do
		if_set_visible(var_9_0, "page" .. iter_9_0, false)
		if_set_visible(var_9_0, "page" .. iter_9_0 .. "_off", false)
	end
	
	if arg_9_0.vars.item_count <= 1 then
		return 
	end
	
	for iter_9_1 = 1, var_0_0 do
		local var_9_1 = arg_9_0.vars.items[iter_9_1] ~= nil
		
		if_set_visible(var_9_0, "page" .. iter_9_1, var_9_1)
		if_set_visible(var_9_0, "page" .. iter_9_1 .. "_off", var_9_1)
	end
	
	if Lobby:isAlternativeLobby() then
		var_9_0.origin_pos_x = var_9_0.origin_pos_x or var_9_0:getPositionX()
		
		var_9_0:setPositionX(var_9_0.origin_pos_x + (arg_9_0.vars.scroll_sz.width - var_0_4) * 0.5)
	else
		var_9_0:setPositionX(arg_9_0.vars.scroll_sz.width - var_0_3 + var_0_2)
	end
	
	arg_9_0:updatePageMarker()
end

function LobbyBattleBalloon.updatePageMarker(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.scrollview) then
		return 
	end
	
	local var_10_0 = math.max(0, math.floor(0 - arg_10_0.vars.scrollview:getInnerContainerPosition().x))
	local var_10_1 = math.round(var_10_0 / arg_10_0.vars.scroll_sz.width)
	local var_10_2 = arg_10_0.vars.item_count - var_10_1
	
	for iter_10_0 = 1, var_0_0 do
		local var_10_3 = iter_10_0 == var_10_2
		
		if_set_visible(arg_10_0.vars.wnd, "page" .. iter_10_0, var_10_3)
	end
end

function LobbyBattleBalloon.onScroll(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_3 == 10 or arg_11_3 == 9 then
		arg_11_0:updatePageMarker()
	end
end

function LobbyBattleBalloon.onCountSeconds(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	arg_12_0.vars.seconds = arg_12_0.vars.seconds or 0
	arg_12_0.vars.seconds = arg_12_0.vars.seconds + 1
	
	if math.mod(arg_12_0.vars.seconds, var_0_1) == 0 then
		arg_12_0.vars.index = arg_12_0.vars.index or 1
		arg_12_0.vars.index = arg_12_0.vars.index + 1
		
		if arg_12_0.vars.item_count < arg_12_0.vars.index then
			arg_12_0.vars.index = 1
		end
		
		arg_12_0:scrollToIndex(arg_12_0.vars.index)
	end
end

function LobbyBattleBalloon.getScrollViewItem(arg_13_0, arg_13_1)
	local var_13_0 = load_dlg("lobby_ui_battle_item", true, "wnd")
	
	if not get_cocos_refid(var_13_0) then
		return 
	end
	
	var_13_0:setContentSize(arg_13_0.vars.scroll_sz.width, var_13_0:getContentSize().height)
	
	if Lobby:isAlternativeLobby() then
		local var_13_1 = var_13_0:getChildByName("txt_battle_talk")
		
		if get_cocos_refid(var_13_1) then
			var_13_1:setPositionX(var_13_0:getContentSize().width * 0.5 - 2)
			var_13_1:setAnchorPoint(0.5, 0.5)
			var_13_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		end
		
		local var_13_2 = var_13_0:getChildByName("txt_battle_time")
		
		if get_cocos_refid(var_13_2) then
			var_13_2:setPositionX(var_13_0:getContentSize().width * 0.5 - 2)
			var_13_2:setAnchorPoint(0.5, 0.5)
			var_13_2:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		end
	end
	
	local function var_13_3()
		if_set(var_13_0, "txt_battle_talk", T(arg_13_1.text_id))
		
		local var_14_0 = math.max(arg_13_1.get_remain_time(), 0)
		
		if_set(var_13_0, "txt_battle_time", T("time_remain", {
			time = sec_to_string(var_14_0)
		}))
	end
	
	var_13_3()
	Scheduler:addSlow(var_13_0, var_13_3)
	
	return var_13_0
end

function LobbyBattleBalloon.scrollToIndex(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_1 = arg_15_0.vars.item_count + 1 - arg_15_1
	
	local var_15_0 = 100 * (arg_15_1 - 1 / arg_15_0.vars.item_count - 1)
	
	arg_15_0.vars.scrollview:scrollToPercentHorizontal(var_15_0, 1, true)
end

function LobbyBattleBalloon.onSelectScrollViewItem(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0:close()
end

function LobbyBattleBalloon.close(arg_17_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_17_0.vars.wnd, "block")
end
