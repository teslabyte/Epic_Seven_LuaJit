WorldBossMap = {}

function ErrHandler.worldboss_lobby(arg_1_0, arg_1_1, arg_1_2)
	if Clan:noClanSendToLobby(arg_1_1) then
		return 
	end
	
	if WorldBossMap:sendToWorldboss_map(arg_1_1) then
		return 
	end
end

function MsgHandler.worldboss_lobby(arg_2_0)
	WorldBossMap:onEnter(arg_2_0)
end

function MsgHandler.worldboss_clan_rank_info(arg_3_0)
	if arg_3_0.caller and arg_3_0.caller == "rank_popup" then
		WorldBossMap:openRankRewardPopup(arg_3_0)
	elseif WorldBossMapDetail.vars and WorldBossMapDetail.vars.isFirst == true then
		WorldBossMapDetail:inti_clanInfos(arg_3_0)
	elseif WorldBossMapDetail.vars then
		WorldBossMapDetail:req_clanRanks(arg_3_0)
	end
end

function MsgHandler.worldboss_user_rank_info(arg_4_0)
	WorldBossMapDetail:req_personalRanks(arg_4_0)
end

function MsgHandler.worldboss_clan_member(arg_5_0)
	WorldBossClan:updateMyClanMembers(arg_5_0)
end

function MsgHandler.worldboss_support(arg_6_0)
	if arg_6_0.onenter then
		WorldBossMySupport:onEnter(arg_6_0.supporter)
	end
end

function MsgHandler.worldboss_fullseason_reward(arg_7_0)
	WorldBossMap:res_weeklyRewardItem(arg_7_0)
end

function HANDLER.clan_worldboss_base(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_ready" then
		if WorldBossMap.vars then
			WorldBossMapDetail:openEnterPopup(WorldBossMap:getCurrentWorldboss_info())
		end
	elseif arg_8_1 == "btn_supporter" then
		query("worldboss_support", {
			onenter = true
		})
	elseif arg_8_1 == "btn_right_reward" or arg_8_1 == "btn_left_reward" then
		WorldBossMap:req_weeklyRewardItem(arg_8_0)
	elseif arg_8_1 == "btn_reward" then
		if WorldBossMap.vars and WorldBossMap.vars.currentBossInfo then
			query("worldboss_clan_rank_info", {
				caller = "rank_popup",
				page = 0,
				season_id = WorldBossMap.vars.currentBossInfo.season_id
			})
		else
			WorldBossMap:openRankRewardPopup()
		end
	elseif arg_8_1 == "btn_clan_info" and get_cocos_refid(arg_8_0) and arg_8_0.clan_id then
		Clan:queryPreview(arg_8_0.clan_id, "preview")
	end
end

function HANDLER.clan_worldboss_rank_reward(arg_9_0, arg_9_1)
	if arg_9_1 == "btn_close" then
		WorldBossMap:closeRankRewardPopup()
	end
end

function HANDLER.clan_worldboss_member(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_user_info" then
		Friend:preview(arg_10_0.user_id)
	elseif arg_10_1 == "btn_close" then
		WorldBossClan:closeMyClanMembers()
	end
end

function HANDLER.clan_worldboss_rank_item(arg_11_0, arg_11_1)
	if arg_11_1 == "btn_info" or arg_11_1 == "btn_clan_info" then
		if arg_11_0.is_personal then
			Friend:preview(arg_11_0.item.user_id)
		elseif arg_11_0.item and arg_11_0.item.clan_info then
			local var_11_0 = arg_11_0.item.clan_info
			local var_11_1 = {
				rank_limit = 0,
				acc_support_count = 2,
				week_id = var_11_0.week_id,
				level = var_11_0.level,
				join_type = var_11_0.join_type,
				emblem = var_11_0.emblem,
				clan_id = var_11_0.clan_id,
				name = var_11_0.name,
				member_count = var_11_0.member_count
			}
			
			Clan:queryPreview(arg_11_0.item.clan_info.clan_id, "ranking")
		end
	elseif arg_11_1 == "btn_more" then
		WorldBossMapDetail:req_moreRanks(arg_11_0)
	end
end

function HANDLER.clan_worldboss_map(arg_12_0, arg_12_1)
end

function HANDLER.clan_worldboss_name(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_into" then
		if arg_13_0.bossInfo then
			WorldBossMapDetail:openEnterPopup(arg_13_0.bossInfo)
		else
			balloon_message_with_sound("worldboss_update")
		end
	end
end

function HANDLER.clan_worldboss_detail(arg_14_0, arg_14_1)
	if string.starts(arg_14_1, "btn_tab") then
		WorldBossMapDetail:toggleMenu(tonumber(string.sub(arg_14_1, 8, -1)))
	elseif arg_14_1 == "btn_go" then
		if WorldBossMap:isEnterable() then
			WorldBossMapDetail:closeEnterPopup()
			WorldBossPopup:onEnter(WorldBossMap:getCurrentWorldboss_info(), WorldBossMap:getBonusData())
		else
			balloon_message_with_sound("msg_clan_wb_enter_limit")
		end
	elseif arg_14_1 == "btn_history" then
		WorldBossClan:openMyClanMembers(Clan:getMembers())
	elseif arg_14_1 == "btn_close" then
		WorldBossMapDetail:closeEnterPopup()
	elseif arg_14_1 == "btn_story" then
		local var_14_0 = WorldBossMap:getCurrentWorldboss_info() or WorldBossMapDetail:getBeforeWorldboss_info()
		
		if var_14_0 then
			local var_14_1 = var_14_0.boss_id
			
			WorldBossMap:playWorldbossStoryID(var_14_1)
		end
	elseif arg_14_1 == "btn_clan_info" and get_cocos_refid(arg_14_0) and arg_14_0.clan_id then
		Clan:queryPreview(arg_14_0.clan_id, "preview")
	end
end

function HANDLER.clan_worldboss_support(arg_15_0, arg_15_1)
	if arg_15_1 == "btn_ignore" then
		WorldBossMySupport:setNormalMode()
	elseif arg_15_1 == "btn_auto_support" then
		TutorialGuide:procGuide()
		WorldBossMySupport:setNormalMode()
		WorldBossMySupport:setAutoFormation()
	elseif string.starts(arg_15_1, "btn_") then
		WorldBossMySupport:selectTeamTab(string.sub(arg_15_1, -1))
	end
	
	WorldBossMySupport:updateTabNoti()
end

function HANDLER.clan_worldboss_support_result(arg_16_0, arg_16_1)
	if arg_16_1 == "btn_close" then
		WorldBossMap:close_SupporterRewards()
	end
end

function WorldBossMap.onLoad(arg_17_0, arg_17_1)
	arg_17_0.vars = {}
	arg_17_0.vars.root_layer = arg_17_1
	
	query("worldboss_lobby")
end

function WorldBossMap.onEnter(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.root_layer
	
	arg_18_0.vars.worldBossDBInfos = {}
	arg_18_0.vars.clanInfos = {}
	arg_18_0.vars.wnd = load_dlg("clan_worldboss_base", true, "wnd")
	
	var_18_0:addChild(arg_18_0.vars.wnd)
	
	arg_18_0.vars.map_wnd = load_dlg("clan_worldboss_map", true, "wnd")
	
	arg_18_0.vars.wnd:getChildByName("n_bg"):addChild(arg_18_0.vars.map_wnd)
	arg_18_0.vars.map_wnd:setPosition(0, 0)
	if_set_visible(arg_18_0.vars.map_wnd, "n_area1_on", false)
	if_set_visible(arg_18_0.vars.map_wnd, "n_area2_on", false)
	if_set_visible(arg_18_0.vars.map_wnd, "n_area_off", false)
	TopBarNew:create(T("worldboss_main_title"), arg_18_0.vars.wnd, function()
		SceneManager:popScene()
		BackButtonManager:pop("clan_worldboss_base")
	end, nil, nil, "infowboss")
	arg_18_0:init(arg_18_1)
	Analytics:setMode("worldboss_map")
	
	if not arg_18_0:checkMySupporters(Account:get_worldbossSupporterTeam()) then
		arg_18_0:checkTutorial()
		arg_18_0:setBtnSupport_noti(false)
	else
		arg_18_0:setBtnSupport_noti(true)
	end
	
	Clan:updateCurrencies(arg_18_1)
	
	if arg_18_1.supp_result and not table.empty(arg_18_1.supp_result) then
		arg_18_0:open_SupporterRewards(arg_18_1.supp_result, arg_18_1.use_count)
	end
end

function WorldBossMap.setBtnSupport_noti(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("btn_supporter")
	
	if var_20_0 then
		if_set_visible(var_20_0, "icon_noti", arg_20_1)
	end
end

function WorldBossMap.open_SupporterRewards(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_1 or not arg_21_2 then
		return 
	end
	
	local var_21_0 = "clanpvpband"
	
	arg_21_0.vars.supportReward_popup = load_dlg("clan_worldboss_support_result", true, "wnd")
	
	arg_21_0.vars.wnd:addChild(arg_21_0.vars.supportReward_popup)
	
	local var_21_1 = arg_21_1[var_21_0]
	local var_21_2 = UIUtil:getRewardIcon(arg_21_2 * GAME_STATIC_VARIABLE.worldboss_supp_reward_count, GAME_STATIC_VARIABLE.worldboss_supp_reward_token, {
		show_small_count = true,
		show_name = true,
		show_count = true,
		parent = arg_21_0.vars.supportReward_popup:getChildByName("reward_item")
	})
	
	if_set(arg_21_0.vars.supportReward_popup, "t_use_count", T("ui_clan_worldboss_support_result_use_count", {
		count = arg_21_2
	}))
	if_set_arrow(arg_21_0.vars.supportReward_popup, "n_arrow")
	Account:addReward(arg_21_1)
end

function WorldBossMap.close_SupporterRewards(arg_22_0)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.supportReward_popup) then
		return 
	end
	
	arg_22_0.vars.supportReward_popup:removeFromParent()
	
	arg_22_0.vars.supportReward_popup = nil
end

function WorldBossMap.checkTutorial(arg_23_0)
	if arg_23_0.vars.currentBossInfo then
		TutorialGuide:startGuide("clan_wb_battle")
	elseif not SAVE:getTutorialGuide("clan_wb_battle") then
		TutorialGuide:startGuide("clan_wb_no_battle")
	end
end

function WorldBossMap.checkMySupporters(arg_24_0, arg_24_1)
	arg_24_0.vars.mySupport_init = true
	
	if not arg_24_1 or table.empty(arg_24_1) then
		arg_24_0.vars.mySupport_init = false
		
		Dialog:msgBox(T("msg_wb_supporter"), {
			handler = function()
				query("worldboss_support", {
					onenter = true
				})
			end
		})
		
		return true
	end
	
	local var_24_0 = false
	
	for iter_24_0, iter_24_1 in pairs(arg_24_1) do
		if table.empty(iter_24_1) or table.count(iter_24_1) <= 0 then
			var_24_0 = true
			
			break
		end
	end
	
	if var_24_0 then
		arg_24_0.vars.mySupport_init = false
		
		Dialog:msgBox(T("msg_wb_supporter"), {
			handler = function()
				query("worldboss_support", {
					onenter = true
				})
			end
		})
	end
	
	return var_24_0
end

function WorldBossMap.getMySupport_init(arg_27_0)
	return arg_27_0.vars.mySupport_init
end

function WorldBossMap.getWnd(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	return arg_28_0.vars.wnd
end

function WorldBossMap.init(arg_29_0, arg_29_1)
	WorldBossMap:setWorldBossLobby(arg_29_1)
	arg_29_0:initWeeklyRewards(arg_29_1)
end

function WorldBossMap.initWeeklyRewards(arg_30_0, arg_30_1)
	if not arg_30_1.fullseason_info then
		arg_30_0:setNoRewardUI()
		
		return 
	end
	
	local var_30_0 = arg_30_1.fullseason_info or {}
	
	arg_30_0.vars.reward_info = var_30_0
	
	if var_30_0.start_time and var_30_0.end_time then
		local var_30_1 = WorldBossUtil:getRemainTimeText(var_30_0.end_time - WorldBossUtil:getTime())
		
		if_set(arg_30_0.vars.wnd, "t_time_left", var_30_1)
	end
	
	local var_30_2 = arg_30_0.vars.wnd:getChildByName("n_contri_point")
	
	if_set_visible(arg_30_0.vars.wnd, "n_contri_point", true)
	
	arg_30_0.vars.reward_listview = var_30_2:getChildByName("listview")
	
	if_set(var_30_2, "t_score", comma_value(var_30_0.score))
	
	arg_30_0.vars.rewards = {}
	
	local var_30_3 = true
	local var_30_4 = Account:serverTimeWeekLocalDetail() >= 197
	
	for iter_30_0 = 1, 99 do
		local var_30_5, var_30_6, var_30_7, var_30_8 = DBN("clan_worldboss_weekly_reward", iter_30_0, {
			"point",
			"point_new",
			"reward_id",
			"reward_count"
		})
		
		if not var_30_5 then
			break
		end
		
		if var_30_4 and var_30_6 then
			var_30_5 = var_30_6
		end
		
		local var_30_9 = false
		local var_30_10 = false
		
		if iter_30_0 <= var_30_0.recieve_reward then
			var_30_9 = true
		end
		
		if var_30_5 <= var_30_0.score and var_30_0.recieve_reward + 1 == iter_30_0 then
			var_30_10 = true
		end
		
		table.insert(arg_30_0.vars.rewards, {
			id = iter_30_0,
			point = var_30_5,
			reward_id = var_30_7,
			reward_count = var_30_8,
			is_recieved = var_30_9,
			can_recieve = var_30_10,
			rewardIcon_leftside = var_30_3
		})
		
		var_30_3 = not var_30_3
	end
	
	arg_30_0.vars.reward_listview = ItemListView:bindControl(arg_30_0.vars.reward_listview)
	
	local var_30_11 = load_control("wnd/clan_worldboss_point_item.csb")
	local var_30_12 = {
		onUpdate = function(arg_31_0, arg_31_1, arg_31_2)
			WorldBossMap:updateRewardItem(arg_31_1, arg_31_2)
			
			return arg_31_2.id
		end
	}
	
	arg_30_0.vars.reward_listview:setRenderer(var_30_11, var_30_12)
	arg_30_0.vars.reward_listview:addItems(arg_30_0.vars.rewards)
	
	arg_30_0.vars.before_point = 0
end

function WorldBossMap.updateRewardItem(arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0.vars or not arg_32_0.vars.reward_info then
		return 
	end
	
	local var_32_0 = arg_32_1:getChildByName("n_left")
	
	if not arg_32_2.rewardIcon_leftside then
		var_32_0 = arg_32_1:getChildByName("n_right")
	end
	
	if_set_visible(arg_32_1, "n_left", arg_32_2.rewardIcon_leftside)
	if_set_visible(arg_32_1, "n_right", not arg_32_2.rewardIcon_leftside)
	
	local var_32_1 = UIUtil:getRewardIcon(arg_32_2.reward_count, arg_32_2.reward_id, {
		show_small_count = true,
		show_count = true,
		parent = var_32_0:getChildByName("reward_item")
	})
	local var_32_2 = var_32_0:findChildByName("t_contribution")
	
	if get_cocos_refid(var_32_2) then
		if_set(var_32_2, nil, comma_value(arg_32_2.point))
		
		var_32_2._origin_scale_x = 0.82
		
		set_scale_fit_width(var_32_2, 88)
	end
	
	if_set_visible(arg_32_1, "bg_area", false)
	if_set_visible(arg_32_1, "loadingbar", true)
	if_set_percent(arg_32_1, "loadingbar", 0)
	if_set_visible(var_32_0, "icon_check", arg_32_2.is_recieved)
	
	local var_32_3 = 127.5
	
	if not arg_32_2.is_recieved and arg_32_0.vars.reward_info.score >= arg_32_2.point then
		var_32_3 = 255
		arg_32_1.effect = EffectManager:Play({
			scale = 1,
			z = 99999,
			fn = "ui_pvp_allreward.cfx",
			y = 0,
			x = 0,
			layer = var_32_0:getChildByName("reward_item")
		})
	end
	
	if arg_32_2.is_recieved and arg_32_1.effect then
		arg_32_1.effect:removeFromParent()
		
		arg_32_1.effect = nil
	end
	
	var_32_1:setOpacity(var_32_3)
	
	local var_32_4 = arg_32_0.vars.reward_info.score
	
	if_set_percent(arg_32_1, "loadingbar", (var_32_4 - arg_32_0.vars.before_point) / (arg_32_2.point - arg_32_0.vars.before_point))
	
	if arg_32_2.can_recieve and arg_32_2.id == arg_32_0.vars.reward_info.recieve_reward + 1 then
	end
	
	var_32_0.item = arg_32_2
	arg_32_1.icon = var_32_1
	arg_32_1.n_node = var_32_0
	arg_32_0.vars.before_point = arg_32_2.point
end

function WorldBossMap.update_weeklyRewardItems(arg_33_0)
	if not arg_33_0.vars or not arg_33_0.vars.reward_info then
		return 
	end
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.rewards) do
		if arg_33_0.vars.reward_info.recieve_reward >= iter_33_1.id then
			iter_33_1.is_recieved = true
		end
		
		if arg_33_0.vars.reward_info.score >= iter_33_1.point and arg_33_0.vars.reward_info.recieve_reward + 1 == iter_33_1.id then
			iter_33_1.can_recieve = true
		end
	end
end

function WorldBossMap.req_weeklyRewardItem(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not arg_34_0.vars.reward_info or not arg_34_1 or not arg_34_1:getParent() or not arg_34_1:getParent().item then
		return 
	end
	
	local var_34_0 = arg_34_1:getParent().item
	
	if var_34_0.can_recieve then
		local var_34_1 = arg_34_0.vars.reward_listview:getControl(var_34_0)
		
		if_set_visible(var_34_1.n_node, "icon_check", true)
		var_34_1.icon:setOpacity(76.5)
		
		var_34_0.can_recieve = false
		var_34_0.is_recieved = true
		
		if var_34_1.effect then
			var_34_1.effect:removeFromParent()
			
			var_34_1.effect = nil
		end
		
		var_34_0.is_recieved = true
		
		query("worldboss_fullseason_reward", {
			reward_step = arg_34_0.vars.reward_info.recieve_reward + 1
		})
	elseif var_34_0.is_recieved then
	elseif (arg_34_0.vars.reward_info.score or 0) < var_34_0.point then
		balloon_message_with_sound("msg_clan_wb_contribute_reward_point")
	else
		balloon_message_with_sound("msg_clan_wb_contribute_reward_in_order")
	end
end

function WorldBossMap.res_weeklyRewardItem(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not arg_35_0.vars.reward_info then
		return 
	end
	
	if arg_35_1 and arg_35_1.update_currency then
		Account:addReward(arg_35_1.update_currency, {
			single = true,
			play_reward_data = true
		})
	end
	
	arg_35_0.vars.before_point = 0
	arg_35_0.vars.reward_info = arg_35_1.fullseason_info
	
	arg_35_0:update_weeklyRewardItems()
end

function WorldBossMap.openRankRewardPopup(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1 or {}
	
	arg_36_0.vars.rankRewardPopup = load_dlg("clan_worldboss_rank_reward", true, "wnd")
	
	arg_36_0.vars.wnd:addChild(arg_36_0.vars.rankRewardPopup)
	
	local var_36_1 = {}
	
	table.insert(var_36_1, {
		top = true
	})
	
	for iter_36_0 = 1, 99 do
		local var_36_2, var_36_3, var_36_4, var_36_5, var_36_6 = DBN("clan_worldboss_clanrank", iter_36_0, {
			"id",
			"rank_type",
			"rank_range",
			"clan_reward_id",
			"clan_reward_count"
		})
		
		if not var_36_2 then
			break
		end
		
		local var_36_7 = {
			id = var_36_2,
			rank_type = var_36_3,
			rank_range = var_36_4,
			clan_reward_id = var_36_5,
			clan_reward_count = var_36_6
		}
		
		if var_36_3 == "fix" and var_36_2 >= 4 then
			local var_36_8, var_36_9, var_36_10, var_36_11, var_36_12 = DBN("clan_worldboss_clanrank", iter_36_0 - 1, {
				"id",
				"rank_type",
				"rank_range",
				"clan_reward_id",
				"clan_reward_count"
			})
			
			if var_36_8 then
				var_36_7.before_point = var_36_10 + 1
			end
		end
		
		table.insert(var_36_1, var_36_7)
	end
	
	local var_36_13 = arg_36_0.vars.rankRewardPopup:getChildByName("listview")
	local var_36_14 = ItemListView:bindControl(var_36_13)
	local var_36_15 = load_control("wnd/clan_worldboss_rank_reward_item.csb")
	local var_36_16 = {
		onUpdate = function(arg_37_0, arg_37_1, arg_37_2)
			WorldBossMap:updateRankRewardItem(arg_37_1, arg_37_2)
			
			return arg_37_2.id
		end
	}
	
	var_36_14:setRenderer(var_36_15, var_36_16)
	var_36_14:addItems(var_36_1)
	
	local var_36_17 = WorldBossMap:getMyClanRank_text()
	local var_36_18 = comma_value(WorldBossMap:getMyClanPoint())
	
	if var_36_0.clan_info and var_36_0.clan_info.rank and var_36_0.clan_info.score and var_36_0.clan_info.score >= 0 then
		var_36_17 = T("ui_clan_worldboss_base_clan_rank", {
			clan_rank = var_36_0.clan_info.rank
		})
		var_36_18 = comma_value(var_36_0.clan_info.score)
	end
	
	if_set(arg_36_0.vars.rankRewardPopup, "t_clan_rank", var_36_17)
	if_set(arg_36_0.vars.rankRewardPopup, "t_point", T("ui_clan_worldboss_rank_reward_my_clan_point", {
		clan_point = var_36_18
	}))
end

function WorldBossMap.updateRankRewardItem(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_2.top then
		if_set_visible(arg_38_1, "n_top", true)
		if_set_visible(arg_38_1, "n_contents", false)
		if_set(arg_38_1, "t_h1", T("ui_clan_worldboss_rank_reward_clan_rank"))
		if_set(arg_38_1, "t_h2", T("ui_clan_worldboss_rank_reward_clan_reward"))
		
		return 
	end
	
	if_set_visible(arg_38_1, "n_top", false)
	if_set_visible(arg_38_1, "n_contents", true)
	
	local var_38_0 = UIUtil:getRewardIcon(nil, arg_38_2.clan_reward_id, {
		no_bg = true,
		parent = arg_38_1:getChildByName("reward_item")
	})
	
	if_set(arg_38_1, "t_amount", arg_38_2.clan_reward_count)
	
	local var_38_1 = arg_38_2.rank_range
	local var_38_2 = ""
	
	if arg_38_2.rank_type == "per" then
		local var_38_3 = var_38_1 * 100
		
		var_38_2 = T("ui_clan_worldboss_rank_reward_rank_type3", {
			per_rank = var_38_3
		})
	elseif arg_38_2.rank_type == "fix" then
		if arg_38_2.before_point then
			var_38_2 = T("ui_clan_worldboss_rank_reward_rank_type2", {
				min_rank = arg_38_2.before_point,
				max_rank = arg_38_2.rank_range
			})
		else
			var_38_2 = T("ui_clan_worldboss_rank_reward_rank_type1", {
				min_rank = arg_38_2.rank_range
			})
		end
	end
	
	if_set(arg_38_1, "t_rank", var_38_2)
end

function WorldBossMap.closeRankRewardPopup(arg_39_0)
	arg_39_0.vars.rankRewardPopup:removeFromParent()
	
	arg_39_0.vars.rankRewardPopup = nil
end

function WorldBossMap.setNoRewardUI(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.wnd:getChildByName("n_bg")
	
	if var_40_0 then
		var_40_0:setPositionX(var_40_0:getPositionX() + 100)
	end
	
	local var_40_1 = arg_40_0.vars.wnd:getChildByName("RIGHT")
	local var_40_2 = arg_40_0.vars.wnd:getChildByName("RIGHT_move")
	
	if var_40_2 then
		var_40_1:setPositionX(var_40_2:getPositionX())
	end
end

function WorldBossMap.setWorldBossLobby(arg_41_0, arg_41_1)
	arg_41_0:setWorldBossInfo(arg_41_1)
	arg_41_0:setLeftInfo(arg_41_1)
	arg_41_0:setWorldBossMap()
	if_set_visible(arg_41_0.vars.wnd, "btn_reward", false)
end

function WorldBossMap.setLeftInfo(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.vars.wnd:getChildByName("LEFT")
	local var_42_1 = arg_42_1.latest
	
	if var_42_1 then
		local var_42_2 = WorldBossUtil:getWorldbossCharID(var_42_1.boss_id)
		local var_42_3 = UIUtil:getUserIcon(var_42_2, {
			no_lv = true,
			no_role = true,
			no_grade = true,
			parent = var_42_0:getChildByName("mob_icon")
		})
		local var_42_4 = WorldBossUtil:getStrongColorIconPath(var_42_1.color)
		local var_42_5 = getChildByPath(var_42_0, "n_info/icon_element")
		
		if_set_sprite(var_42_5, nil, var_42_4)
	else
		if_set_visible(var_42_0, "mob_icon", false)
		if_set_visible(var_42_0, "n_info", false)
	end
	
	arg_42_0:setRankInfo(arg_42_1)
end

function WorldBossMap.setRankInfo(arg_43_0, arg_43_1)
	if not arg_43_1 or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	local var_43_0 = arg_43_0.vars.wnd:getChildByName("n_rank")
	local var_43_1 = arg_43_1.rank_info
	
	if var_43_1 then
		if_set_visible(var_43_0, "n_no_rank", false)
		if_set_visible(var_43_0, "n_last_rank", true)
		
		local var_43_2 = 0
		
		for iter_43_0, iter_43_1 in pairs(var_43_1) do
			var_43_2 = var_43_2 + 1
			
			local var_43_3 = var_43_0:getChildByName("n_clan_" .. iter_43_0)
			
			if not var_43_3 then
				break
			end
			
			if_set(var_43_3, "txt_rank", T("ui_clan_worldboss_base_clan_rank", {
				clan_rank = iter_43_1.rank
			}))
			if_set(var_43_3, "clan_name", iter_43_1.clan_info.name)
			if_set(var_43_3, "txt_point", T("ui_clan_worldboss_base_clan_point", {
				clan_point = comma_value(iter_43_1.score)
			}))
			UIUtil:updateClanEmblem(var_43_3, iter_43_1.clan_info)
			UIUtil:warpping_setLevel(var_43_3:getChildByName("n_lv"), iter_43_1.clan_info.level, CLAN_MAX_LEVEL, 2, {
				is_clan_level = true
			})
			
			local var_43_4 = var_43_3:getChildByName("btn_clan_info")
			
			if get_cocos_refid(var_43_4) then
				var_43_4.clan_id = iter_43_1.clan_info.clan_id
			end
		end
		
		if var_43_2 == 0 then
			if_set_visible(arg_43_0.vars.wnd, "n_last_rank", false)
			if_set_visible(arg_43_0.vars.wnd, "n_no_rank", true)
		elseif var_43_2 == 1 then
			if_set_visible(var_43_0, "n_clan_2", false)
			if_set_visible(var_43_0, "n_clan_3", false)
		elseif var_43_2 == 2 then
			if_set_visible(var_43_0, "n_clan_3", false)
		end
		
		if arg_43_1.clan_info then
			if_set_visible(var_43_0, "n_clan_ranking", true)
			
			if arg_43_1.clan_info.score <= 0 then
				if_set(var_43_0:getChildByName("n_clan_ranking"), "txt_rank", T("ui_clan_worldboss_no_rank"))
				arg_43_0:setMyClanRank_text(T("ui_clan_worldboss_no_rank"))
				arg_43_0:setMyClanPoint(0)
			else
				if_set(var_43_0:getChildByName("n_clan_ranking"), "txt_rank", T("ui_clan_worldboss_base_clan_rank", {
					clan_rank = arg_43_1.clan_info.rank
				}))
				arg_43_0:setMyClanRank_text(T("ui_clan_worldboss_base_clan_rank", {
					clan_rank = arg_43_1.clan_info.rank
				}))
				arg_43_0:setMyClanPoint(arg_43_1.clan_info.score)
			end
		else
			if_set_visible(var_43_0, "n_clan_ranking", false)
		end
	else
		if_set_visible(var_43_0, "n_no_rank", true)
		if_set_visible(var_43_0, "n_last_rank", false)
	end
end

function WorldBossMap.setMyClanPoint(arg_44_0, arg_44_1)
	arg_44_0.vars.myClan_point = arg_44_1 or 0
end

function WorldBossMap.getMyClanPoint(arg_45_0)
	return arg_45_0.vars.myClan_point or 0
end

function WorldBossMap.setMyClanRank_text(arg_46_0, arg_46_1)
	arg_46_0.vars.rank_text = arg_46_1
end

function WorldBossMap.getMyClanRank_text(arg_47_0)
	return arg_47_0.vars.rank_text or T("ui_clan_worldboss_no_rank")
end

function WorldBossMap.getLimitUnits(arg_48_0, arg_48_1)
	if not arg_48_1 or not arg_48_0.vars.limitUnits[arg_48_1] then
		return arg_48_0.vars.limitUnits
	end
	
	return arg_48_0.vars.limitUnits[arg_48_1]
end

function WorldBossMap.setLimitUnits(arg_49_0, arg_49_1)
	if not arg_49_0.vars.limitUnits then
		arg_49_0.vars.limitUnits = {}
	end
	
	arg_49_0.vars.limitUnits = arg_49_1
end

function WorldBossMap.getEnterableCount(arg_50_0)
	if not arg_50_0.vars then
		return 
	end
	
	return arg_50_0.vars.maxEnterableCount - arg_50_0.vars.enterableCount
end

function WorldBossMap.setEnterCount(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0.vars then
		return 
	end
	
	arg_51_0.vars.enterableCount = arg_51_1
	arg_51_0.vars.maxEnterableCount = arg_51_2
end

function WorldBossMap.isEnterable(arg_52_0)
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		return true
	end
	
	if arg_52_0.vars.enterableCount >= arg_52_0.vars.maxEnterableCount then
		return false
	end
	
	return true
end

function WorldBossMap.setWorldBossInfo(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_1
	
	arg_53_0.vars.schedules = {}
	arg_53_0.vars.currentBossInfo = arg_53_1.current
	arg_53_0.vars.bonus_data = arg_53_1.bonus_data
	
	arg_53_0:setEnterCount(arg_53_1.count_info.count, arg_53_1.count_info.max_count)
	arg_53_0:setLimitUnits(arg_53_1.limit_list)
	
	local var_53_1 = false
	local var_53_2
	
	if not var_53_0.current then
		var_53_1 = true
	end
	
	for iter_53_0 = 1, 99 do
		local var_53_3, var_53_4, var_53_5, var_53_6, var_53_7, var_53_8, var_53_9 = DBN("clan_worldboss", iter_53_0, {
			"id",
			"char_id",
			"bg",
			"map_index",
			"show",
			"start_story",
			"end_story"
		})
		
		if not var_53_3 then
			break
		end
		
		local var_53_10 = {
			id = var_53_3,
			char_id = var_53_4,
			bg = var_53_5,
			map_index = var_53_6,
			show = var_53_7,
			start_story = var_53_8,
			end_story = var_53_9
		}
		
		table.insert(arg_53_0.vars.worldBossDBInfos, var_53_10)
		
		if not arg_53_0.vars.schedules[var_53_3] then
			arg_53_0.vars.schedules[var_53_3] = {}
		end
		
		if_set_visible(arg_53_0.vars.map_wnd, "n_area" .. var_53_6 .. "_on", false)
		if_set_visible(arg_53_0.vars.map_wnd, "n_area" .. var_53_6 .. "_off", false)
		
		if not var_53_7 then
			if_set_visible(arg_53_0.vars.map_wnd, "n_area" .. var_53_6 .. "_on", false)
			if_set_visible(arg_53_0.vars.map_wnd, "n_area" .. var_53_6 .. "_off", true)
		end
	end
	
	local var_53_11 = WorldBossUtil:getTime()
	
	for iter_53_1, iter_53_2 in pairs(arg_53_1.schedules) do
		if var_53_11 >= iter_53_2.start_time and var_53_11 < iter_53_2.end_time then
			iter_53_2.isOpen = true
		else
			iter_53_2.isOpen = false
		end
		
		if var_53_11 > iter_53_2.end_time then
			iter_53_2.prev_boss = true
		end
		
		if var_53_11 < iter_53_2.start_time and not iter_53_2.isOpen then
			iter_53_2.prev_boss = false
			
			if var_53_1 then
				var_53_2 = WorldBossUtil:getRemainTimeText(iter_53_2.start_time - WorldBossUtil:getTime())
				var_53_1 = false
			end
		end
		
		table.insert(arg_53_0.vars.schedules[iter_53_2.boss_id], iter_53_2)
	end
	
	local var_53_12 = arg_53_0.vars.wnd:getChildByName("n_next_boss")
	
	if var_53_2 then
		if_set_visible(var_53_12, nil, true)
		if_set(var_53_12, "txt_time", var_53_2)
	else
		if_set_visible(var_53_12, nil, false)
		if_set_visible(var_53_12, "txt_time", false)
	end
	
	if arg_53_0.vars.currentBossInfo then
		arg_53_0.vars.currentBossInfo.isOpen = true
		
		SoundEngine:playBGM("event:/bgm/worldboss_ready")
	else
		SoundEngine:playBGM("event:/bgm/worldboss_lobby")
		if_set_opacity(arg_53_0.vars.wnd, "btn_ready", 127.5)
	end
end

function WorldBossMap.sendToWorldboss_map(arg_54_0, arg_54_1)
	if string.ends(arg_54_1, "tx_err") or string.ends(arg_54_1, "limit_supporter") then
		Dialog:msgBox(T("msg_clan_wb_supp_use_limit"), {
			handler = function()
				SceneManager:nextScene("world_boss_map")
			end
		})
		
		return true
	elseif string.ends(arg_54_1, "invalid_supporter") then
		Dialog:msgBox(T("msb_clan_wb_invalid_supp"), {
			handler = function()
				SceneManager:nextScene("world_boss_map")
			end
		})
		
		return true
	elseif string.ends(arg_54_1, "change_supporter") then
		Dialog:msgBox(T("msg_clan_wb_supp_change"), {
			handler = function()
				SceneManager:nextScene("world_boss_map")
			end
		})
		
		return true
	end
end

function WorldBossMap.setWorldBossMap(arg_58_0)
	local var_58_0 = arg_58_0.vars.wnd
	local var_58_1 = arg_58_0.vars.map_wnd
	local var_58_2 = arg_58_0.vars.map_wnd:getChildByName("p_main")
	
	arg_58_0.vars.n_names = {}
	arg_58_0.vars.time_schedules = {}
	
	for iter_58_0, iter_58_1 in pairs(arg_58_0.vars.worldBossDBInfos) do
		local var_58_3 = var_58_1:getChildByName("n_boss" .. iter_58_1.map_index)
		
		if not get_cocos_refid(var_58_3) then
			break
		end
		
		local var_58_4 = load_dlg("clan_worldboss_name", true, "wnd")
		
		var_58_3:addChild(var_58_4)
		var_58_4:setPosition(0, 0)
		
		local var_58_5 = WorldBossUtil:getWorldbossName(iter_58_1.id)
		local var_58_6 = UIUtil:getUserIcon(iter_58_1.char_id, {
			no_lv = true,
			no_role = true,
			is_enemy = true,
			no_grade = true,
			parent = var_58_4:getChildByName("mob_icon")
		}) or UIUtil:getUserIcon("w0001", {
			no_lv = true,
			no_role = true,
			is_enemy = true,
			no_grade = true,
			parent = var_58_4:getChildByName("mob_icon")
		})
		
		if arg_58_0.vars.currentBossInfo and arg_58_0.vars.currentBossInfo.boss_id == iter_58_1.id then
			if_set_visible(var_58_4, "n_battle", true)
			if_set_color(var_58_6, nil, tocolor("#FFFFFF"))
			if_set_visible(var_58_4, "label_bg", false)
			if_set(var_58_4, "label_name_enemy", var_58_5)
			if_set_visible(var_58_4, "n_hp", true)
			
			local var_58_7 = WorldBossUtil:getBossHP(arg_58_0.vars.currentBossInfo.start_time, arg_58_0.vars.currentBossInfo.end_time)
			
			WorldBossUtil:setHPBar(var_58_4:getChildByName("n_hp"), var_58_7)
		else
			if_set_color(var_58_6, nil, tocolor("#666666"))
			if_set_visible(var_58_4, "n_hp", false)
			if_set_visible(var_58_4, "n_battle", false)
			
			if iter_58_1.show then
				if_set_visible(var_58_4, "label_bg_enemy", false)
				if_set(var_58_4, "label_name", var_58_5)
				
				local var_58_8 = var_58_4:getChildByName("info")
				
				if var_58_8 then
					var_58_8:setPositionY(98)
				end
			else
				if_set_visible(var_58_4, "n_bottom", false)
				if_set_visible(var_58_4, "info", false)
				if_set_sprite(var_58_6, "face", "face/m0000_s.png")
			end
		end
		
		table.insert(arg_58_0.vars.n_names, tonumber(iter_58_1.map_index), var_58_4)
	end
	
	for iter_58_2, iter_58_3 in pairs(arg_58_0.vars.schedules) do
		local var_58_9
		
		for iter_58_4, iter_58_5 in pairs(iter_58_3) do
			local var_58_10 = iter_58_5
			local var_58_11 = WorldBossUtil:getBossPosition(var_58_10.boss_id)
			local var_58_12 = arg_58_0.vars.n_names[var_58_11]
			
			if not var_58_12 then
				break
			end
			
			if not var_58_10.isOpen and var_58_10.prev_boss then
				var_58_9 = var_58_10
			end
			
			if var_58_10.isOpen then
				local var_58_13 = WorldBossUtil:getStrongColorIconPath(var_58_10.color)
				
				if_set_sprite(var_58_12:getChildByName("info"), "icon_element", var_58_13)
				if_set_visible(arg_58_0.vars.map_wnd, "n_area" .. var_58_11 .. "_on", true)
				if_set_visible(arg_58_0.vars.map_wnd, "n_area" .. var_58_11 .. "_off", false)
				
				local var_58_14 = WorldBossUtil:getRemainTimeText(var_58_10.end_time - WorldBossUtil:getTime())
				
				if_set(var_58_12, "txt_time", var_58_14)
				
				var_58_12:getChildByName("btn_into").bossInfo = var_58_10
				
				EffectManager:Play({
					fn = "ui_worldboss_battle_eff.cfx",
					layer = var_58_12:getChildByName("n_eff")
				})
				table.insert(arg_58_0.vars.time_schedules, var_58_10)
				
				break
			elseif not var_58_10.prev_boss then
				local var_58_15 = WorldBossUtil:getStrongColorIconPath(var_58_10.color)
				
				if_set_sprite(var_58_12:getChildByName("info"), "icon_element", var_58_15)
				if_set_visible(arg_58_0.vars.map_wnd, "n_area" .. var_58_11 .. "_on", false)
				if_set_visible(arg_58_0.vars.map_wnd, "n_area" .. var_58_11 .. "_off", true)
				
				local var_58_16 = WorldBossUtil:getRemainTimeText(var_58_10.start_time - WorldBossUtil:getTime())
				
				if_set(var_58_12, "txt_time", var_58_16)
				
				var_58_12:getChildByName("btn_into").bossInfo = var_58_10
				
				table.insert(arg_58_0.vars.time_schedules, var_58_10)
				
				if var_58_9 then
					var_58_12:getChildByName("btn_into").bossInfo.before_boss = var_58_9
				end
				
				break
			end
			
			if false then
			end
		end
	end
	
	if not table.empty(arg_58_0.vars.time_schedules) then
		Scheduler:addSlow(arg_58_0.vars.wnd, WorldBossMap.updateTime, arg_58_0)
	end
end

function WorldBossMap.playWorldbossStoryID(arg_59_0, arg_59_1)
	if not arg_59_1 then
		return 
	end
	
	local var_59_0, var_59_1 = DB("clan_worldboss", arg_59_1, {
		"start_story",
		"end_story"
	})
	
	if not Account:isPlayedStory(var_59_0) then
		balloon_message_with_sound("msg_clan_wb_need_clear_story")
		
		return 
	end
	
	if var_59_0 then
		play_story(var_59_0, {
			force = true
		})
	end
	
	if var_59_1 then
		play_story(var_59_1, {
			force = true
		})
	end
end

function WorldBossMap.getCurrentWorldboss_info(arg_60_0)
	if not arg_60_0.vars or not arg_60_0.vars.currentBossInfo then
		return 
	end
	
	return arg_60_0.vars.currentBossInfo
end

function WorldBossMap.getBonusData(arg_61_0)
	if not arg_61_0.vars or not arg_61_0.vars.bonus_data then
		return 
	end
	
	return arg_61_0.vars.bonus_data
end

function WorldBossMap.unload(arg_62_0)
	if not arg_62_0.vars or not get_cocos_refid(arg_62_0.vars.wnd) then
		return 
	end
	
	Scheduler:remove(arg_62_0.updateTime)
	arg_62_0.vars.wnd:removeFromParent()
	
	arg_62_0.vars = {}
end

function WorldBossMap.onLeave(arg_63_0)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.wnd) then
		return 
	end
	
	Scheduler:remove(arg_63_0.updateTime)
	BackButtonManager:pop("clan_worldboss_base")
	TopBarNew:pop()
	arg_63_0.vars.wnd:removeFromParent()
	
	arg_63_0.vars = {}
end

WorldBossMapDetail = {}

copy_functions(ScrollView, WorldBossMapDetail)

function WorldBossMapDetail.openEnterPopup(arg_64_0, arg_64_1)
	if not arg_64_1 then
		balloon_message_with_sound("msg_clan_wb_no_battle")
		
		return 
	end
	
	arg_64_0.vars = {}
	
	if not arg_64_0.vars.enterPopup_wnd then
		arg_64_0.vars.enterPopup_wnd = load_dlg("clan_worldboss_detail", true, "wnd", function()
			WorldBossMapDetail:closeEnterPopup()
		end)
	end
	
	arg_64_0.vars.bossInfo = arg_64_1
	arg_64_0.vars.bossInfo.remain_time = arg_64_1.end_time - WorldBossUtil:getTime()
	arg_64_0.vars.bossInfo.rest_time = arg_64_1.start_time - WorldBossUtil:getTime()
	
	WorldBossMap.vars.wnd:addChild(arg_64_0.vars.enterPopup_wnd)
	arg_64_0.vars.enterPopup_wnd:bringToFront()
	arg_64_0:initPopup()
	TutorialGuide:procGuide()
end

function WorldBossMapDetail.initPopup(arg_66_0)
	if not arg_66_0.vars.enterPopup_wnd or not arg_66_0.vars.bossInfo then
		return 
	end
	
	local var_66_0 = arg_66_0.vars.bossInfo
	local var_66_1 = arg_66_0.vars.enterPopup_wnd
	
	if_set_visible(var_66_1, "fg_category_2", false)
	if_set_visible(var_66_1, "fg_category_3", false)
	if_set_visible(var_66_1, "fg_category_4", false)
	if_set_visible(var_66_1, "n_battle", true)
	
	local var_66_2 = getChildByPath(arg_66_0.vars.enterPopup_wnd, "frame/n_rank")
	
	if_set_visible(var_66_2, nil, false)
	if_set_visible(var_66_1, "n_reward", false)
	if_set_visible(var_66_1, "fg_category_rewards", false)
	if_set_visible(var_66_1, "n_rank_personal", false)
	if_set(var_66_1:getChildByName("n_top"), "txt_title", WorldBossUtil:getWorldbossName(var_66_0.boss_id))
	if_set(var_66_1, "txt_boss_story", WorldBossUtil:getWorldbossStoryDesc(var_66_0.boss_id))
	if_set_sprite(var_66_1, "img_bg", WorldBossUtil:getWorldbossBgPath(var_66_0.boss_id))
	
	local var_66_3, var_66_4 = DB("clan_worldboss", var_66_0.boss_id, {
		"start_story",
		"end_story"
	})
	
	if not Account:isPlayedStory(var_66_3) then
		if_set_opacity(var_66_1, "btn_story", 76.5)
	else
		if_set_opacity(var_66_1, "btn_story", 255)
	end
	
	arg_66_0:init_nBattle()
	arg_66_0:init_nReward()
	if_set_visible(arg_66_0.vars.enterPopup_wnd, "n_rank", false)
	
	arg_66_0.vars.isFirst = true
	
	if var_66_0.isOpen then
		query("worldboss_clan_rank_info", {
			limit = 3
		})
	else
		arg_66_0:inti_clanInfos()
	end
	
	Scheduler:addSlow(arg_66_0.vars.enterPopup_wnd, WorldBossMapDetail.updateTime, arg_66_0)
end

function WorldBossMapDetail.inti_clanInfos(arg_67_0, arg_67_1)
	arg_67_0.vars.isFirst = false
	
	if not arg_67_1 or #arg_67_1.rank_info == 0 then
		if_set_visible(arg_67_0.vars.enterPopup_wnd, "n_rank", false)
		
		return 
	end
	
	if_set_visible(arg_67_0.vars.enterPopup_wnd, "n_rank", true)
	
	local var_67_0 = arg_67_0.vars.enterPopup_wnd:getChildByName("n_rank")
	
	if_set(var_67_0, "txt_title", T("ui_clan_worldboss_detail_clan_ranking_title"))
	
	local var_67_1 = 1
	
	for iter_67_0, iter_67_1 in pairs(arg_67_1.rank_info) do
		local var_67_2 = var_67_0:getChildByName("n_" .. iter_67_0)
		
		if not get_cocos_refid(var_67_2) then
			break
		end
		
		var_67_1 = var_67_1 + 1
		
		if_set(var_67_2, "clan_name", iter_67_1.clan_info.name)
		if_set(var_67_2, "txt_rank", "#" .. iter_67_1.rank)
		UIUtil:updateClanEmblem(var_67_2, iter_67_1.clan_info)
		
		local var_67_3 = var_67_2:getChildByName("btn_clan_info")
		
		if get_cocos_refid(var_67_3) then
			var_67_3.clan_id = iter_67_1.clan_info.clan_id
		end
	end
	
	for iter_67_2 = var_67_1, 3 do
		if_set_visible(var_67_0, "n_" .. iter_67_2, false)
	end
	
	if arg_67_1.clan_info then
		if_set(var_67_0, "txt_pts_my", T("ui_clan_worldboss_rank_item_clan_point", {
			clan_point = comma_value(arg_67_1.clan_info.score)
		}))
		
		if arg_67_1.clan_info.rank == nil or arg_67_1.clan_info.rank <= 0 then
			if_set(var_67_0, "txt_rank_my", T("ui_clan_worldboss_no_rank"))
		else
			if_set(var_67_0, "txt_rank_my", T("ui_clan_worldboss_detail_my_clan_ranking", {
				clan_rank = comma_value(arg_67_1.clan_info.rank)
			}))
		end
	end
end

function WorldBossMapDetail.init_nBattle(arg_68_0)
	local var_68_0 = arg_68_0.vars.bossInfo
	local var_68_1 = arg_68_0.vars.enterPopup_wnd:getChildByName("n_battle")
	
	if_set_visible(var_68_1, "btn_go", var_68_0.isOpen)
	if_set_visible(var_68_1, "n_time", var_68_0.isOpen)
	if_set_visible(var_68_1, "n_rank", var_68_0.isOpen)
	if_set_visible(var_68_1, "n_gauge", var_68_0.isOpen)
	if_set_visible(var_68_1:getChildByName("n_boss"), "n_time", var_68_0.isOpen)
	
	local var_68_2 = getChildByPath(arg_68_0.vars.enterPopup_wnd:getChildByName("frame"), "n_battle/n_time")
	
	if_set_visible(var_68_2, nil, not var_68_0.isOpen)
	
	local var_68_3 = WorldBossUtil:getWorldbossCharID(var_68_0.boss_id)
	local var_68_4 = UIUtil:getUserIcon(var_68_3, {
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = var_68_1:getChildByName("mob_icon")
	})
	
	if_set_color(var_68_4, nil, var_68_0.isOpen and tocolor("#FFFFFF") or tocolor("#666666"))
	
	local var_68_5 = WorldBossUtil:getStrongColorIconPath(var_68_0.color)
	
	if_set_sprite(var_68_1, "icon_element", var_68_5)
	
	if var_68_0.isOpen then
		local var_68_6 = WorldBossMap:getEnterableCount()
		
		if_set(var_68_1:getChildByName("btn_go"), "label", var_68_6 .. "/" .. WorldBossUtil:getMaxWorldbossEnter())
		
		if var_68_6 <= 0 then
			if_set_opacity(var_68_1, "btn_go", 76.5)
		end
		
		local var_68_7 = WorldBossUtil:getRemainTimeText(var_68_0.remain_time)
		
		if_set(var_68_1:getChildByName("n_boss"), "txt_time", var_68_7)
		
		local var_68_8 = WorldBossUtil:getBossHP(var_68_0.start_time, var_68_0.end_time)
		
		WorldBossUtil:setHPBar(var_68_1:getChildByName("n_gauge"), var_68_8)
	else
		local var_68_9 = WorldBossUtil:getRemainTimeText(var_68_0.rest_time)
		
		if_set(var_68_2, "txt_time", var_68_9)
	end
end

function WorldBossMapDetail.check_personalRankInfos(arg_69_0)
	if arg_69_0.vars.personalRank_scroll and arg_69_0.vars.personal_ranks then
		return true
	end
	
	return false
end

function WorldBossMapDetail.init_personalRanks(arg_70_0)
	if arg_70_0.vars.personalRank_scroll then
		return 
	end
	
	local var_70_0 = arg_70_0.vars.enterPopup_wnd:getChildByName("n_rank_personal")
	
	arg_70_0.vars.personalRank_scroll = var_70_0:getChildByName("scrollview_rank_personal")
	
	arg_70_0:initScrollView(arg_70_0.vars.personalRank_scroll, 1030, 114)
	
	if not arg_70_0.vars.personal_ranks then
		arg_70_0.vars.personal_ranks = {}
	end
	
	arg_70_0.vars.clanPersRankPage = 1
	
	arg_70_0:createScrollViewItems(arg_70_0.vars.personal_ranks)
	
	local var_70_1 = arg_70_0.vars.bossInfo.season_id
	
	if not arg_70_0.vars.bossInfo.isOpen and arg_70_0.vars.bossInfo.before_boss then
		var_70_1 = arg_70_0.vars.bossInfo.before_boss.season_id
	end
	
	query("worldboss_user_rank_info", {
		limit = 20,
		season_id = var_70_1,
		page = arg_70_0.vars.clanPersRankPage
	})
end

function WorldBossMapDetail.check_clanRankInfos(arg_71_0)
	if arg_71_0.vars.rank_scroll and arg_71_0.vars.clan_ranks then
		return true
	end
	
	return false
end

function WorldBossMapDetail.init_clanRanks(arg_72_0)
	if arg_72_0.vars.rank_scroll then
		return 
	end
	
	local var_72_0 = getChildByPath(arg_72_0.vars.enterPopup_wnd, "frame/n_rank")
	
	arg_72_0.vars.rank_scroll = var_72_0:getChildByName("scrollview_rank")
	
	arg_72_0:initScrollView(arg_72_0.vars.rank_scroll, 1030, 114)
	
	if not arg_72_0.vars.clan_ranks then
		arg_72_0.vars.clan_ranks = {}
	end
	
	arg_72_0:createScrollViewItems(arg_72_0.vars.clan_ranks)
	
	arg_72_0.vars.clanRanksPage = 1
	
	local var_72_1 = arg_72_0.vars.bossInfo.season_id
	
	if not arg_72_0.vars.bossInfo.isOpen and arg_72_0.vars.bossInfo.before_boss then
		var_72_1 = arg_72_0.vars.bossInfo.before_boss.season_id
	end
	
	query("worldboss_clan_rank_info", {
		limit = 20,
		season_id = var_72_1,
		page = arg_72_0.vars.clanRanksPage
	})
end

function WorldBossMapDetail.req_moreRanks(arg_73_0, arg_73_1)
	if not arg_73_0.vars then
		return 
	end
	
	local var_73_0 = arg_73_0.vars.bossInfo.season_id
	
	if not arg_73_0.vars.bossInfo.isOpen and arg_73_0.vars.bossInfo.before_boss then
		var_73_0 = arg_73_0.vars.bossInfo.before_boss.season_id
	end
	
	if arg_73_1.item and arg_73_1.item.is_personal then
		query("worldboss_user_rank_info", {
			limit = 20,
			season_id = var_73_0,
			page = arg_73_0.vars.clanPersRankPage
		})
	else
		query("worldboss_clan_rank_info", {
			limit = 20,
			season_id = var_73_0,
			page = arg_73_0.vars.clanRanksPage
		})
	end
end

function WorldBossMapDetail.req_clanRanks(arg_74_0, arg_74_1)
	if not arg_74_1 or not arg_74_1.rank_info then
		return 
	end
	
	local var_74_0 = arg_74_1 or {}
	local var_74_1 = var_74_0.rank_info
	local var_74_2 = 1
	
	if arg_74_0.vars and arg_74_0.vars.clan_ranks and #arg_74_0.vars.clan_ranks < 100 then
		var_74_2 = #arg_74_0.vars.clan_ranks
		
		local var_74_3
		
		for iter_74_0, iter_74_1 in pairs(arg_74_0.vars.clan_ranks) do
			if iter_74_1.next_item then
				var_74_3 = iter_74_0
			end
		end
		
		if var_74_3 then
			table.remove(arg_74_0.vars.clan_ranks, var_74_3)
			arg_74_0:removeScrollViewItemAt(var_74_3)
		end
		
		for iter_74_2, iter_74_3 in pairs(var_74_1) do
			table.insert(arg_74_0.vars.clan_ranks, iter_74_3)
			arg_74_0:addScrollViewItem(iter_74_3)
		end
		
		if #var_74_1 >= 20 then
			table.insert(arg_74_0.vars.clan_ranks, {
				next_item = true
			})
			arg_74_0:addScrollViewItem({
				next_item = true
			})
		end
	end
	
	if arg_74_0.vars.clanRanksPage <= 1 then
		arg_74_0:setMyClanInfo(var_74_0.clan_info)
	end
	
	arg_74_0.vars.clanRanksPage = arg_74_0.vars.clanRanksPage + 1
	
	if #arg_74_0.vars.clan_ranks > 1 then
		arg_74_0:jumpToIndex(var_74_2)
	end
end

function WorldBossMapDetail.req_personalRanks(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_1 or {}
	
	if not var_75_0 or not var_75_0.rank_info then
		return 
	end
	
	local var_75_1 = var_75_0.rank_info
	local var_75_2 = 1
	
	if arg_75_0.vars and arg_75_0.vars.personal_ranks and #arg_75_0.vars.personal_ranks < 100 then
		var_75_2 = #arg_75_0.vars.personal_ranks
		
		local var_75_3
		
		for iter_75_0, iter_75_1 in pairs(arg_75_0.vars.personal_ranks) do
			if iter_75_1.next_item then
				var_75_3 = iter_75_0
			end
		end
		
		if var_75_3 then
			table.remove(arg_75_0.vars.personal_ranks, var_75_3)
			arg_75_0:removeScrollViewItemAt(var_75_3)
		end
		
		for iter_75_2, iter_75_3 in pairs(var_75_1) do
			table.insert(arg_75_0.vars.personal_ranks, iter_75_3)
			arg_75_0:addScrollViewItem(iter_75_3)
		end
		
		if #var_75_1 >= 20 then
			table.insert(arg_75_0.vars.personal_ranks, {
				next_item = true,
				is_personal = true
			})
			arg_75_0:addScrollViewItem({
				next_item = true,
				is_personal = true
			})
		end
	end
	
	if arg_75_0.vars.clanPersRankPage <= 1 then
		arg_75_0:setMyRankInfo(var_75_0.my_info)
	end
	
	arg_75_0.vars.clanPersRankPage = arg_75_0.vars.clanPersRankPage + 1
	
	if #arg_75_0.vars.personal_ranks > 1 then
		arg_75_0:jumpToIndex(var_75_2)
	end
end

function WorldBossMapDetail.setMyClanInfo(arg_76_0, arg_76_1)
	if not arg_76_1 then
		return 
	end
	
	local var_76_0 = arg_76_0.vars.enterPopup_wnd:getChildByName("n_clan_rank")
	
	if arg_76_1.score <= 0 then
		if_set(var_76_0, "txt_my_clan_rank", T("ui_clan_worldboss_no_rank"))
	else
		if_set(var_76_0, "txt_my_clan_rank", T("ui_clan_worldboss_detail_my_clan_ranking", {
			clan_rank = comma_value(arg_76_1.rank)
		}))
	end
	
	if_set(var_76_0, "txt_boss_pt", T("ui_clan_worldboss_rank_item_clan_point", {
		clan_point = comma_value(arg_76_1.score)
	}))
end

function WorldBossMapDetail.setMyRankInfo(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0.vars.enterPopup_wnd:getChildByName("n_personal_rank")
	
	if arg_77_1.score <= 0 then
		if_set(var_77_0, "txt_my_clan_rank", T("ui_clan_worldboss_no_rank"))
	else
		if_set(var_77_0, "txt_my_clan_rank", T("ui_clan_worldboss_detail_my_clan_ranking", {
			clan_rank = comma_value(arg_77_1.rank)
		}))
	end
	
	if_set(var_77_0, "txt_boss_pt", T("ui_clan_worldboss_rank_item_clan_point", {
		clan_point = comma_value(arg_77_1.score)
	}))
end

function WorldBossMapDetail.getScrollViewItem(arg_78_0, arg_78_1)
	local var_78_0 = load_control("wnd/clan_worldboss_rank_item.csb")
	
	var_78_0:getChildByName("btn_more").parent = arg_78_0
	
	if arg_78_1.next_item then
		if_set_visible(var_78_0, "n_rank", false)
		if_set_visible(var_78_0, "n_pers", false)
		if_set_visible(var_78_0, "n_clan", false)
		if_set_visible(var_78_0, "btn_info", false)
		if_set_visible(var_78_0, "page_next", true)
		
		var_78_0.item = arg_78_1
		
		local var_78_1 = var_78_0:getChildByName("btn_more")
		
		if var_78_1 then
			var_78_1.item = arg_78_1
		end
		
		return var_78_0
	end
	
	if arg_78_1.is_personal or arg_78_1.user_info then
		if_set_visible(var_78_0, "n_pers", true)
		if_set_visible(var_78_0, "n_clan", false)
		if_set(var_78_0:getChildByName("btn_info"), "label", T("ui_friends_user_info"))
		arg_78_0:getScrollViewPersonalItem(var_78_0, arg_78_1)
	else
		if_set_visible(var_78_0, "n_pers", false)
		if_set_visible(var_78_0, "n_clan", true)
		if_set(var_78_0:getChildByName("btn_info"), "label", T("ui_clan_worldboss_rank_item_btn_clan_info"))
		arg_78_0:getScrollViewClansItem(var_78_0, arg_78_1)
	end
	
	return var_78_0
end

function WorldBossMapDetail.getScrollViewClansItem(arg_79_0, arg_79_1, arg_79_2)
	if_set(arg_79_1, "clan_name", arg_79_2.clan_info.name)
	if_set(arg_79_1, "clan_score", T("ui_clan_worldboss_rank_item_clan_point", {
		clan_point = comma_value(arg_79_2.score)
	}))
	UIUtil:updateClanEmblem(arg_79_1, arg_79_2.clan_info)
	
	local var_79_0
	
	if arg_79_2.rank <= 3 then
		if_set_visible(arg_79_1, "n_toprank", true)
		if_set_visible(arg_79_1, "txt_rank", false)
		
		var_79_0 = arg_79_1:getChildByName("n_toprank"):getChildByName("txt_rank")
	else
		if_set_visible(arg_79_1, "n_toprank", false)
		if_set_visible(arg_79_1, "txt_rank", true)
		
		var_79_0 = arg_79_1:getChildByName("txt_rank")
	end
	
	if_set(var_79_0, nil, T("ui_clan_worldboss_rank_item_clan_rank", {
		clan_rank = arg_79_2.rank
	}))
	UIUtil:warpping_setLevel(arg_79_1:getChildByName("n_lv"), arg_79_2.clan_info.level, CLAN_MAX_LEVEL, 2, {
		is_clan_level = true
	})
	
	if arg_79_2.clan_info.level <= 9 then
		local var_79_1 = arg_79_1:getChildByName("n_lv_num")
		
		if var_79_1 then
			var_79_1:setPositionX(var_79_1:getPositionX() - 18)
		end
	end
	
	local var_79_2 = arg_79_1:getChildByName("btn_info")
	
	if get_cocos_refid(var_79_2) then
		var_79_2.item = arg_79_2
	end
	
	local var_79_3 = arg_79_1:getChildByName("btn_clan_info")
	
	if get_cocos_refid(var_79_3) then
		var_79_3.item = arg_79_2
	end
	
	arg_79_1.item = arg_79_2
end

function WorldBossMapDetail.getScrollViewPersonalItem(arg_80_0, arg_80_1, arg_80_2)
	UIUtil:getUserIcon(arg_80_2.user_info.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		no_grade = true,
		parent = arg_80_1:getChildByName("mob_icon"),
		border_code = arg_80_2.user_info.border_code
	})
	if_set(arg_80_1, "t_name", arg_80_2.user_info.name)
	
	local var_80_0
	
	if arg_80_2.rank <= 3 then
		if_set_visible(arg_80_1, "n_toprank", true)
		if_set_visible(arg_80_1, "txt_rank", false)
		
		var_80_0 = arg_80_1:getChildByName("n_toprank"):getChildByName("txt_rank")
	else
		if_set_visible(arg_80_1, "n_toprank", false)
		if_set_visible(arg_80_1, "txt_rank", true)
		
		var_80_0 = arg_80_1:getChildByName("txt_rank")
	end
	
	if_set(var_80_0, nil, T("ui_clan_worldboss_rank_item_clan_rank", {
		clan_rank = arg_80_2.rank
	}))
	if_set(arg_80_1, "t_pt", T("ui_clan_worldboss_rank_item_point", {
		point = comma_value(arg_80_2.score)
	}))
	UIUtil:setLevel(arg_80_1:getChildByName("n_lv_rank"), arg_80_2.user_info.level, MAX_ACCOUNT_LEVEL, 3, false, nil, 18)
	
	local var_80_1 = arg_80_1:getChildByName("btn_info")
	
	if get_cocos_refid(var_80_1) then
		var_80_1.item = arg_80_2
		var_80_1.is_personal = true
	end
	
	local var_80_2 = arg_80_1:getChildByName("btn_clan_info")
	
	if get_cocos_refid(var_80_2) then
		var_80_2.item = arg_80_2
		var_80_2.is_personal = true
	end
	
	arg_80_1.is_personal = true
	arg_80_1.item = arg_80_2
end

function WorldBossMapDetail.init_nReward(arg_81_0)
	local var_81_0 = arg_81_0.vars.enterPopup_wnd:getChildByName("n_reward")
	local var_81_1 = load_dlg("clan_worldboss_reward_item", true, "wnd")
	
	var_81_0:addChild(var_81_1)
	var_81_1:setPosition(0, 0)
	var_81_1:setAnchorPoint(0, 0)
	
	for iter_81_0 = 1, 99 do
		local var_81_2, var_81_3, var_81_4, var_81_5, var_81_6, var_81_7 = DB("clan_worldboss_battle_grade", tostring(iter_81_0), {
			"grade",
			"grade_point",
			"reward_id",
			"reward_count",
			"static_reward_id",
			"static_reward_count"
		})
		
		if not var_81_2 then
			break
		end
		
		local var_81_8 = string.lower(var_81_2)
		local var_81_9 = var_81_1:getChildByName("n_" .. var_81_8)
		
		if not var_81_9 then
			break
		end
		
		if_set(var_81_9, "t_reward_" .. var_81_8, T("ui_clan_worldboss_reward_item_reward_count", {
			count = var_81_5
		}))
		if_set(var_81_9, "t_point_" .. var_81_8, T("ui_clan_worldboss_reward_item_grade_point", {
			grade_point = comma_value(var_81_3)
		}))
		
		local var_81_10 = UIUtil:getRewardIcon(nil, var_81_4, {
			no_bg = true,
			parent = var_81_9:getChildByName("n_icon_pre")
		})
		local var_81_11 = var_81_1:getChildByName("n_reward_item")
		
		UIUtil:getRewardIcon(var_81_7, var_81_6, {
			show_small_count = true,
			show_name = false,
			show_count = true,
			parent = var_81_11,
			count = var_81_7
		})
	end
end

function WorldBossMapDetail.toggleMenu(arg_82_0, arg_82_1)
	local var_82_0 = arg_82_0.vars.enterPopup_wnd
	local var_82_1 = arg_82_0.vars.enterPopup_wnd:getChildByName("img_bg")
	
	for iter_82_0 = 1, 4 do
		if_set_visible(var_82_0, "fg_category_" .. iter_82_0, arg_82_1 == iter_82_0 and true or false)
	end
	
	local var_82_2 = getChildByPath(arg_82_0.vars.enterPopup_wnd, "frame/n_rank")
	
	if arg_82_1 == 1 then
		if_set_visible(var_82_0, "n_battle", true)
		if_set_visible(var_82_2, nil, false)
		if_set_visible(var_82_0, "n_reward", false)
		if_set_visible(var_82_0, "n_rank_personal", false)
		if_set_opacity(var_82_1, nil, 255)
	elseif arg_82_1 == 2 then
		if_set_visible(var_82_0, "n_battle", false)
		if_set_visible(var_82_2, nil, true)
		if_set_visible(var_82_0, "n_reward", false)
		if_set_visible(var_82_0, "n_rank_personal", false)
		if_set_opacity(var_82_1, nil, 76.5)
		
		if not arg_82_0:check_clanRankInfos() then
			arg_82_0:init_clanRanks()
		end
		
		if false then
		end
	elseif arg_82_1 == 3 then
		if_set_visible(var_82_0, "n_battle", false)
		if_set_visible(var_82_2, nil, false)
		if_set_visible(var_82_0, "n_reward", true)
		if_set_visible(var_82_0, "n_rank_personal", false)
		if_set_opacity(var_82_1, nil, 76.5)
	elseif arg_82_1 == 4 then
		if_set_visible(var_82_0, "n_battle", false)
		if_set_visible(var_82_2, nil, false)
		if_set_visible(var_82_0, "n_reward", false)
		if_set_visible(var_82_0, "n_rank_personal", true)
		if_set_opacity(var_82_1, nil, 76.5)
		
		local var_82_3 = var_82_0:getChildByName("n_rank_personal")
		
		if not arg_82_0:check_personalRankInfos() then
			arg_82_0:init_personalRanks()
		end
	end
	
	if false then
	end
end

function WorldBossMapDetail.getBeforeWorldboss_info(arg_83_0)
	if not arg_83_0.vars or not arg_83_0.vars.bossInfo or not arg_83_0.vars.bossInfo.before_boss then
		return 
	end
	
	return arg_83_0.vars.bossInfo.before_boss
end

function WorldBossMapDetail.closeEnterPopup(arg_84_0)
	if not arg_84_0.vars or not get_cocos_refid(arg_84_0.vars.enterPopup_wnd) then
		return 
	end
	
	BackButtonManager:pop("clan_worldboss_detail")
	Scheduler:remove(arg_84_0.updateTime)
	arg_84_0.vars.enterPopup_wnd:removeFromParent()
	
	arg_84_0.vars.enterPopup_wnd = nil
end

WorldBossClan = {}

function WorldBossClan.openMyClanMembers(arg_85_0, arg_85_1)
	if not arg_85_1 then
		return 
	end
	
	arg_85_0.vars = {}
	arg_85_0.vars.members = arg_85_1
	arg_85_0.vars.myClan_wnd = load_dlg("clan_worldboss_member", true, "wnd", function()
		WorldBossClan:closeMyClanMembers()
	end)
	
	SceneManager:getRunningNativeScene():addChild(arg_85_0.vars.myClan_wnd)
	if_set(arg_85_0.vars.myClan_wnd, "txt_close", T("ui_clan_worldboss.member_close"))
	
	local var_85_0 = {}
	
	for iter_85_0, iter_85_1 in pairs(arg_85_0.vars.members) do
		if iter_85_1.user_info.level >= GAME_STATIC_VARIABLE.worldboss_daily_join_count2 then
			table.insert(var_85_0, iter_85_1)
		end
	end
	
	arg_85_0.vars.members = var_85_0
	
	local var_85_1 = arg_85_0.vars.myClan_wnd:getChildByName("listview")
	
	arg_85_0.vars.listView = ItemListView:bindControl(var_85_1)
	
	local var_85_2 = load_control("wnd/clan_worldboss_member_item.csb")
	local var_85_3 = {
		onUpdate = function(arg_87_0, arg_87_1, arg_87_2)
			WorldBossClan:updateItem(arg_87_1, arg_87_2)
			
			return arg_87_2.id
		end
	}
	
	arg_85_0.vars.listView:setRenderer(var_85_2, var_85_3)
	arg_85_0.vars.listView:removeAllChildren()
	
	local var_85_4 = WorldBossMapDetail:getBeforeWorldboss_info()
	
	if var_85_4 then
		query("worldboss_clan_member", {
			season_id = var_85_4.season_id,
			boss_id = var_85_4.boss_id
		})
	else
		query("worldboss_clan_member")
	end
end

function WorldBossClan.updateMyClanMembers(arg_88_0, arg_88_1)
	if not arg_88_1 then
		return 
	end
	
	local var_88_0 = arg_88_1.member_list
	
	for iter_88_0, iter_88_1 in pairs(var_88_0) do
		for iter_88_2, iter_88_3 in pairs(arg_88_0.vars.members) do
			if tostring(iter_88_3.user_info.id) == tostring(iter_88_0) then
				iter_88_3.user_info.count = iter_88_1.count
				iter_88_3.user_info.max_count = iter_88_1.max_count
				iter_88_3.user_info.score = iter_88_1.score
				iter_88_1.user_info = iter_88_3.user_info
				
				break
			end
		end
	end
	
	local var_88_1 = arg_88_1.total_count or 0
	
	if not arg_88_1.total_max_count then
		local var_88_2 = 0
	end
	
	if_set(arg_88_0.vars.myClan_wnd, "txt_count", var_88_1)
	if_set_visible(arg_88_0.vars.myClan_wnd, "n_no_data", false)
	arg_88_0.vars.listView:addItems(var_88_0)
end

function WorldBossClan.updateItem(arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = arg_89_2.user_info
	
	UIUtil:updateClanMemberInfo(arg_89_1, arg_89_2, {
		leader_scale = 1
	})
	
	local var_89_1 = arg_89_1:getChildByName("txt_name")
	
	UIUserData:call(var_89_1, "SINGLE_WSCALE(175)", {
		origin_scale_x = 0.82
	})
	if_set(var_89_1, nil, var_89_0.name)
	
	if var_89_0.level <= 9 then
		local var_89_2 = arg_89_1:getChildByName("n_lv_num")
		
		if var_89_2 then
			var_89_2:setPositionX(var_89_2:getPositionX() - 15)
		end
	end
	
	local var_89_3 = arg_89_1:getChildByName("btn_user_info")
	
	if var_89_3 then
		var_89_3.user_id = var_89_0.id
	end
	
	if_set(arg_89_1:getChildByName("n_point"), "t_count", comma_value(var_89_0.score))
	if_set(arg_89_1:getChildByName("n_participcation"), "t_count", var_89_0.count)
end

function WorldBossClan.closeMyClanMembers(arg_90_0)
	if not arg_90_0.vars or not get_cocos_refid(arg_90_0.vars.myClan_wnd) then
		return 
	end
	
	BackButtonManager:pop("clan_worldboss_member")
	arg_90_0.vars.myClan_wnd:removeFromParent()
	
	arg_90_0.vars.myClan_wnd = nil
end

WorldBossMySupport = {}

function WorldBossMySupport.onEnter(arg_91_0, arg_91_1)
	arg_91_0:init(arg_91_1)
	TutorialGuide:startGuide("clan_wb_supp")
	Analytics:setPopup("world_boss_mysupport")
end

function WorldBossMySupport.init(arg_92_0, arg_92_1)
	arg_92_0.vars = {}
	arg_92_0.vars.wnd = load_dlg("clan_worldboss_support", true, "wnd")
	
	local var_92_0
	
	if WorldBossMap.vars and get_cocos_refid(WorldBossMap.vars.wnd) then
		var_92_0 = WorldBossMap.vars.wnd
	else
		var_92_0 = SceneManager:getRunningNativeScene()
	end
	
	var_92_0:addChild(arg_92_0.vars.wnd)
	TopBarNew:createFromPopup(T("worldboss_supporter_title"), arg_92_0.vars.wnd, function()
		WorldBossMySupport:onLeave()
	end)
	TopBarNew:setDisableTopRight()
	TopBarNew:checkhelpbuttonID("infowboss_3_1")
	arg_92_0:initTeams(arg_92_1)
	arg_92_0:initUI()
	
	local var_92_1 = arg_92_0.vars.wnd:getChildByName("CENTER")
	local var_92_2 = arg_92_0.vars.wnd:getChildByName("LEFT")
	
	if_set_visible(var_92_1, "slots", false)
	if_set_visible(var_92_1, "selected_btn", false)
	if_set_visible(var_92_2, "btn_dedi", false)
	if_set_visible(var_92_2, "n_power", false)
	
	arg_92_0.vars.formation_wnd = load_dlg("clan_worldboss_support_formation", true, "wnd")
	
	var_92_1:getChildByName("n_formation"):addChild(arg_92_0.vars.formation_wnd)
	
	local var_92_3 = {
		{
			group_name = "worldbossSupporter",
			max_unit = 4,
			can_edit = true,
			custom = true,
			wnd = arg_92_0.vars.formation_wnd,
			title = {
				text = "party1",
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4
			}
		}
	}
	local var_92_4 = {}
	
	GroupFormationEditor:initFormationEditor(var_92_4, {
		sprite_mode = true,
		least_unit = 0,
		notUseTouchHandler = true,
		hide_hpbar = true,
		useSimpleTag = true,
		tagScale = 1,
		tagOffsetY = 45,
		max_unit = 4,
		hide_hpbar_color = true,
		infos = var_92_3,
		callbackUpdateFormation = function(arg_94_0)
			HeroBelt:updateTeamMarkers()
		end,
		callbackSelectUnit = function(arg_95_0)
			HeroBelt:scrollToUnit(arg_95_0)
		end,
		callbackSelectTeam = function(arg_96_0)
			arg_92_0:setTeam(arg_96_0)
		end,
		callbackUpdatePoint = function(arg_97_0)
			arg_92_0:updatePoint(arg_97_0)
			arg_92_0:updateCounts(arg_92_0.vars.cur_team)
		end,
		callbackCanAddUnit = function(arg_98_0)
			return true
		end
	})
	
	arg_92_0.vars.group_editor = var_92_4
	
	arg_92_0:createHeroBelt("worldbossSupporter")
	arg_92_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_92_0.vars.teamFire)
	arg_92_0.vars.group_editor:setFormationEditMode(true)
	arg_92_0:updateTabNoti()
	arg_92_0:updateElementIcon("fire")
end

function WorldBossMySupport.updateTabNoti(arg_99_0)
	if not arg_99_0.vars or not get_cocos_refid(arg_99_0.vars.wnd) then
		return 
	end
	
	local var_99_0 = table.count(arg_99_0.vars.teamFire) < 4
	local var_99_1 = table.count(arg_99_0.vars.teamIce) < 4
	local var_99_2 = table.count(arg_99_0.vars.teamWind) < 4
	local var_99_3 = table.count(arg_99_0.vars.teamLigt) < 4
	local var_99_4 = table.count(arg_99_0.vars.teamDark) < 4
	
	if_set_visible(arg_99_0.vars.wnd:getChildByName("n_1"), "img_noti", var_99_0)
	if_set_visible(arg_99_0.vars.wnd:getChildByName("n_2"), "img_noti", var_99_1)
	if_set_visible(arg_99_0.vars.wnd:getChildByName("n_3"), "img_noti", var_99_2)
	if_set_visible(arg_99_0.vars.wnd:getChildByName("n_4"), "img_noti", var_99_3)
	if_set_visible(arg_99_0.vars.wnd:getChildByName("n_5"), "img_noti", var_99_4)
end

function WorldBossMySupport.updatePoint(arg_100_0, arg_100_1)
	arg_100_1 = arg_100_1 or {}
	
	if arg_100_1.wnd then
		local var_100_0 = arg_100_1.wnd:getChildByName("txt_point")
		
		if var_100_0 then
			UIAction:Add(INC_NUMBER(400, arg_100_1.cur, nil, arg_100_1.pre), var_100_0)
		end
	end
end

function WorldBossMySupport.createHeroBelt(arg_101_0, arg_101_1)
	if not arg_101_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_101_0.vars.unit_dock) then
		arg_101_0.vars.unit_doc = nil
		
		HeroBelt:destroy()
	end
	
	arg_101_0.vars.unit_dock = HeroBelt:create(arg_101_1)
	
	arg_101_0.vars.unit_dock:setEventHandler(arg_101_0.onHeroListEvent, arg_101_0)
	arg_101_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_101_0.vars.wnd:addChild(arg_101_0.vars.unit_dock:getWindow())
	
	local var_101_0 = Account:getUnits()
	
	HeroBelt:resetData(var_101_0, arg_101_1, nil, nil, nil)
	
	local var_101_1 = arg_101_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_101_0.vars.unit_dock:getWindow():setPositionX(var_101_1)
end

function WorldBossMySupport.onHeroListEvent(arg_102_0, arg_102_1, arg_102_2, arg_102_3)
	arg_102_0.vars.group_editor:onHeroListEventForFormationEditor(arg_102_1, arg_102_2, arg_102_3)
end

function WorldBossMySupport.initTeams(arg_103_0, arg_103_1)
	arg_103_0.vars.teamFire = {}
	arg_103_0.vars.teamIce = {}
	arg_103_0.vars.teamWind = {}
	arg_103_0.vars.teamLigt = {}
	arg_103_0.vars.teamDark = {}
	
	arg_103_0:loadTeam(arg_103_1)
	
	arg_103_0.vars.cur_team = arg_103_0.vars.teamFire
	arg_103_0.vars.cur_tab = 1
end

function WorldBossMySupport.loadTeam(arg_104_0, arg_104_1)
	if not arg_104_1 then
		return 
	end
	
	for iter_104_0, iter_104_1 in pairs(arg_104_1.fire) do
		table.insert(arg_104_0.vars.teamFire, Account:getUnit(iter_104_1))
	end
	
	for iter_104_2, iter_104_3 in pairs(arg_104_1.ice) do
		table.insert(arg_104_0.vars.teamIce, Account:getUnit(iter_104_3))
	end
	
	for iter_104_4, iter_104_5 in pairs(arg_104_1.wind) do
		table.insert(arg_104_0.vars.teamWind, Account:getUnit(iter_104_5))
	end
	
	for iter_104_6, iter_104_7 in pairs(arg_104_1.light) do
		table.insert(arg_104_0.vars.teamLigt, Account:getUnit(iter_104_7))
	end
	
	for iter_104_8, iter_104_9 in pairs(arg_104_1.dark) do
		table.insert(arg_104_0.vars.teamDark, Account:getUnit(iter_104_9))
	end
end

function WorldBossMySupport.initUI(arg_105_0)
	local var_105_0 = arg_105_0.vars.wnd:getChildByName("n_tab")
	
	for iter_105_0 = 2, 5 do
		local var_105_1 = var_105_0:getChildByName("n_" .. iter_105_0)
		
		if_set_visible(var_105_1, "select_" .. iter_105_0, false)
	end
	
	if_set_visible(arg_105_0.vars.wnd, "n_dedi_tooltip_slide", false)
	arg_105_0:updateCounts()
end

function WorldBossMySupport.selectTeamTab(arg_106_0, arg_106_1)
	local var_106_0 = tonumber(arg_106_1) or 0
	local var_106_1 = arg_106_0.vars.wnd:getChildByName("n_tab")
	
	if arg_106_0.vars and arg_106_0.vars.cur_tab == var_106_0 then
		return 
	end
	
	arg_106_0.vars.cur_tab = var_106_0
	
	for iter_106_0 = 1, 5 do
		local var_106_2 = var_106_1:getChildByName("n_" .. iter_106_0)
		
		if_set_visible(var_106_2, "select_" .. iter_106_0, var_106_0 == iter_106_0)
	end
	
	if var_106_0 == 1 then
		arg_106_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_106_0.vars.teamFire)
		
		arg_106_0.vars.cur_team = arg_106_0.vars.teamFire
		
		arg_106_0:updateElementIcon("fire")
	elseif var_106_0 == 2 then
		arg_106_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_106_0.vars.teamIce)
		
		arg_106_0.vars.cur_team = arg_106_0.vars.teamIce
		
		arg_106_0:updateElementIcon("ice")
	elseif var_106_0 == 3 then
		arg_106_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_106_0.vars.teamWind)
		
		arg_106_0.vars.cur_team = arg_106_0.vars.teamWind
		
		arg_106_0:updateElementIcon("wind")
	elseif var_106_0 == 4 then
		arg_106_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_106_0.vars.teamLigt)
		
		arg_106_0.vars.cur_team = arg_106_0.vars.teamLigt
		
		arg_106_0:updateElementIcon("light")
	elseif var_106_0 == 5 then
		arg_106_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_106_0.vars.teamDark)
		
		arg_106_0.vars.cur_team = arg_106_0.vars.teamDark
		
		arg_106_0:updateElementIcon("dark")
	end
	
	arg_106_0:setNormalMode()
	arg_106_0:updateCounts(arg_106_0.vars.cur_team)
end

function WorldBossMySupport.updateElementIcon(arg_107_0, arg_107_1)
	if not arg_107_0.vars or not get_cocos_refid(arg_107_0.vars.wnd) or not arg_107_1 then
		return 
	end
	
	local var_107_0 = arg_107_0.vars.wnd:getChildByName("n_count")
	
	if not get_cocos_refid(var_107_0) then
		return 
	end
	
	if_set_sprite(var_107_0, "icon_element", "img/cm_icon_pro" .. arg_107_1 .. ".png")
end

function WorldBossMySupport.setAutoFormation(arg_108_0)
	local var_108_0
	
	if arg_108_0.vars.cur_tab == 1 then
		var_108_0 = "fire"
	elseif arg_108_0.vars.cur_tab == 2 then
		var_108_0 = "ice"
	elseif arg_108_0.vars.cur_tab == 3 then
		var_108_0 = "wind"
	elseif arg_108_0.vars.cur_tab == 4 then
		var_108_0 = "light"
	elseif arg_108_0.vars.cur_tab == 5 then
		var_108_0 = "dark"
	end
	
	local var_108_1 = get_best_formation(nil, nil, {}, var_108_0)
	local var_108_2 = {}
	
	for iter_108_0, iter_108_1 in pairs(var_108_1) do
		table.insert(var_108_2, iter_108_1)
		
		if iter_108_0 == 4 then
			break
		end
	end
	
	arg_108_0:setTeam(var_108_2)
end

function WorldBossMySupport.setTeam(arg_109_0, arg_109_1)
	if not arg_109_1 or not arg_109_0.vars or not arg_109_0.vars.cur_tab or not arg_109_0.vars.cur_team then
		return 
	end
	
	if arg_109_0.vars.cur_tab == 1 then
		arg_109_0.vars.teamFire = arg_109_1
		arg_109_0.vars.cur_team = arg_109_1
	elseif arg_109_0.vars.cur_tab == 2 then
		arg_109_0.vars.teamIce = arg_109_1
		arg_109_0.vars.cur_team = arg_109_1
	elseif arg_109_0.vars.cur_tab == 3 then
		arg_109_0.vars.teamWind = arg_109_1
		arg_109_0.vars.cur_team = arg_109_1
	elseif arg_109_0.vars.cur_tab == 4 then
		arg_109_0.vars.teamLigt = arg_109_1
		arg_109_0.vars.cur_team = arg_109_1
	elseif arg_109_0.vars.cur_tab == 5 then
		arg_109_0.vars.teamDark = arg_109_1
		arg_109_0.vars.cur_team = arg_109_1
	end
	
	arg_109_0.vars.group_editor:updateGroupFormation("worldbossSupporter", arg_109_0.vars.cur_team)
	arg_109_0:updateCounts(arg_109_0.vars.cur_team)
end

function WorldBossMySupport.updateCounts(arg_110_0, arg_110_1)
	local var_110_0 = {
		"warrior",
		"knight",
		"assassin",
		"ranger",
		"mage",
		"manauser"
	}
	local var_110_1 = arg_110_0.vars.wnd:getChildByName("n_count")
	local var_110_2 = var_110_1:getChildByName("icon_element")
	
	arg_110_0:updateTabNoti()
	
	if not arg_110_1 then
		for iter_110_0, iter_110_1 in pairs(var_110_0) do
			local var_110_3 = var_110_1:getChildByName("icon_" .. iter_110_1)
			
			if not var_110_3 then
				break
			end
			
			if_set(var_110_3, "t_count", 0)
		end
		
		if_set(var_110_2, "t_count", 0)
		
		return 
	end
	
	local var_110_4 = "fire"
	
	if arg_110_0.vars.cur_tab == 1 then
		var_110_4 = "fire"
	elseif arg_110_0.vars.cur_tab == 2 then
		var_110_4 = "ice"
	elseif arg_110_0.vars.cur_tab == 3 then
		var_110_4 = "wind"
	elseif arg_110_0.vars.cur_tab == 4 then
		var_110_4 = "light"
	elseif arg_110_0.vars.cur_tab == 5 then
		var_110_4 = "dark"
	end
	
	local var_110_5 = WorldBossUtil:getRoleCount(arg_110_1)
	local var_110_6 = WorldBossUtil:getStrongColorCount(arg_110_1, var_110_4)
	
	for iter_110_2, iter_110_3 in pairs(var_110_0) do
		local var_110_7 = var_110_1:getChildByName("icon_" .. iter_110_3)
		
		if not var_110_7 then
			break
		end
		
		if_set(var_110_7, "t_count", var_110_5[iter_110_3])
	end
	
	if_set(var_110_2, "t_count", var_110_6)
end

function WorldBossMySupport.setNormalMode(arg_111_0)
	local var_111_0 = arg_111_0:getGroupEditor()
	
	if var_111_0 then
		var_111_0:setNormalMode()
	end
end

function WorldBossMySupport.getGroupEditor(arg_112_0)
	if not arg_112_0.vars or not arg_112_0.vars.group_editor then
		return false
	end
	
	return arg_112_0.vars.group_editor
end

function WorldBossMySupport.saveAllTeam(arg_113_0)
	local var_113_0 = {
		fire = {},
		wind = {},
		ice = {},
		light = {},
		dark = {},
		power = {}
	}
	
	if table.count(arg_113_0.vars.teamFire) < 4 or table.count(arg_113_0.vars.teamIce) < 4 or table.count(arg_113_0.vars.teamWind) < 4 or table.count(arg_113_0.vars.teamLigt) < 4 or table.count(arg_113_0.vars.teamDark) < 4 then
		return false
	end
	
	local var_113_1 = {
		wind = "teamWind",
		fire = "teamFire",
		light = "teamLigt",
		dark = "teamDark",
		ice = "teamIce"
	}
	
	for iter_113_0, iter_113_1 in pairs(var_113_1) do
		local var_113_2 = arg_113_0.vars[iter_113_1] or {}
		local var_113_3 = var_113_0[iter_113_0] or {}
		
		if table.count(var_113_2) >= 4 then
			var_113_0.power[iter_113_0] = TeamUtil:getTeamPoint(nil, nil, {
				team = var_113_2
			})
			
			for iter_113_2 = 1, 4 do
				if var_113_2[iter_113_2] then
					var_113_3[iter_113_2] = var_113_2[iter_113_2]:getUID()
				else
					var_113_3[iter_113_2] = nil
				end
			end
		end
	end
	
	Account:set_worldbossSupporterTeam(var_113_0)
	
	local var_113_4 = json.encode(var_113_0)
	
	query("worldboss_support", {
		id = Account:getUserId(),
		supporter = var_113_4
	})
	WorldBossMap:setBtnSupport_noti(false)
	
	arg_113_0.vars.teamFire = {}
	arg_113_0.vars.teamIce = {}
	arg_113_0.vars.teamWind = {}
	arg_113_0.vars.teamLigt = {}
	arg_113_0.vars.teamDark = {}
	
	return true
end

function WorldBossMySupport.onLeave(arg_114_0)
	if not arg_114_0.vars or not get_cocos_refid(arg_114_0.vars.wnd) then
		return 
	end
	
	local var_114_0 = arg_114_0:saveAllTeam()
	
	TopBarNew:setEnableTopRight()
	TopBarNew:pop()
	BackButtonManager:pop("clan_worldboss_support")
	arg_114_0.vars.wnd:removeFromParent()
	
	arg_114_0.vars = {}
	
	Analytics:closePopup()
	
	if not var_114_0 then
		if not WorldBossMap:getMySupport_init() then
			Dialog:msgBox(T("msg_clan_wb_not_cplt_supp"), {
				handler = function()
					WorldBossMap:sendToClanHome()
				end
			})
		else
			Dialog:msgBox(T("msg_clan_wb_not_save_supp"))
		end
	else
		WorldBossMap:checkTutorial()
	end
end

function WorldBossMapDetail.updateTime(arg_116_0)
	if not arg_116_0.vars or not arg_116_0.vars.bossInfo or not get_cocos_refid(arg_116_0.vars.enterPopup_wnd) then
		Scheduler:remove(arg_116_0.updateTime)
		
		return 
	end
	
	if arg_116_0.vars.bossInfo.isOpen then
		local var_116_0 = arg_116_0.vars.enterPopup_wnd:getChildByName("n_battle")
		local var_116_1 = arg_116_0.vars.bossInfo.end_time - WorldBossUtil:getTime()
		
		if WorldBossUtil:checkOnlySecRemain(var_116_1) then
			local var_116_2 = WorldBossUtil:getRemainTimeText(var_116_1)
			
			if_set(var_116_0:getChildByName("n_boss"), "txt_time", var_116_2)
		end
	else
		local var_116_3 = arg_116_0.vars.bossInfo.start_time - WorldBossUtil:getTime()
		
		if WorldBossUtil:checkOnlySecRemain(var_116_3) then
			local var_116_4 = getChildByPath(arg_116_0.vars.enterPopup_wnd:getChildByName("frame"), "n_battle/n_time")
			local var_116_5 = WorldBossUtil:getRemainTimeText(var_116_3)
			
			if_set(var_116_4, "txt_time", var_116_5)
		end
	end
end

function WorldBossMap.updateTime(arg_117_0)
	if not arg_117_0.vars or not get_cocos_refid(arg_117_0.vars.wnd) then
		Scheduler:remove(arg_117_0.updateTime)
		
		return 
	end
	
	for iter_117_0, iter_117_1 in pairs(arg_117_0.vars.time_schedules) do
		local var_117_0 = iter_117_1
		local var_117_1 = WorldBossUtil:getBossPosition(var_117_0.boss_id)
		local var_117_2 = arg_117_0.vars.n_names[var_117_1]
		
		if var_117_2 then
			if var_117_0.isOpen then
				local var_117_3 = var_117_0.end_time - WorldBossUtil:getTime()
				
				if WorldBossUtil:checkOnlySecRemain(var_117_3) then
					local var_117_4 = WorldBossUtil:getRemainTimeText(var_117_3)
					
					if_set(var_117_2, "txt_time", var_117_4)
					
					if var_117_3 <= 0 then
						arg_117_0:reEnter()
						
						return 
					end
				end
			else
				local var_117_5 = var_117_0.start_time - WorldBossUtil:getTime()
				
				if WorldBossUtil:checkOnlySecRemain(var_117_5) then
					local var_117_6 = WorldBossUtil:getRemainTimeText(var_117_5)
					
					if_set(var_117_2, "txt_time", var_117_6)
					
					local var_117_7 = arg_117_0.vars.wnd:getChildByName("n_next_boss")
					
					if var_117_7 and not arg_117_0.vars.currentBossInfo then
						if_set(var_117_7, "txt_time", var_117_6)
					end
					
					if var_117_5 <= 0 then
						arg_117_0:reEnter()
						
						return 
					end
				end
			end
		end
	end
end

function WorldBossMap.sendToClanHome(arg_118_0)
	WorldBossMap:onLeave()
	SceneManager:popScene()
end

function WorldBossMap.reEnter(arg_119_0)
	WorldBossMap:onLeave()
	SceneManager:popScene()
	SceneManager:nextScene("world_boss_map")
end
