CoopResult = ClassDef()
CoopResultEventerList = {}

function HANDLER.expedition_result(arg_1_0, arg_1_1)
	forEachEventerList(CoopResultEventerList, "onHandler", arg_1_0, arg_1_1)
end

function CoopResult.onHandler(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	if arg_2_2 == "btn_confirm" and arg_2_0.vars.rtn ~= nil then
		arg_2_0:makeCoopResultDlg(arg_2_0.vars.rewards_result, arg_2_0.vars.rtn)
	elseif arg_2_2 == "btn_user" and arg_2_1.data then
		CoopUtil:showFriendButton(arg_2_1.data)
	end
end

function CoopResult.constructor(arg_3_0, arg_3_1)
	arg_3_0.vars = {}
	arg_3_0.vars.args = arg_3_1
	
	table.insert(CoopResultEventerList, arg_3_0)
end

function CoopResult.onQuery(arg_4_0, arg_4_1)
	arg_4_0.vars.rtn = arg_4_1
	arg_4_0.vars.data = {}
	arg_4_0.vars.data.ranking_list = CoopUtil:getRankList(CoopUtil:makeCoopMemberArray(arg_4_1.user_info, true))
	arg_4_0.vars.data.boss_info = arg_4_1.boss_info
	arg_4_0.vars.my_rank = nil
	arg_4_0.vars.my_damage = nil
	arg_4_0.vars.open_tm = arg_4_1.open_tm
	
	local var_4_0 = Account:getUserId()
	local var_4_1 = arg_4_0.vars.data.ranking_list
	
	for iter_4_0 = 1, table.count(var_4_1) do
		if var_4_1[iter_4_0].uid == var_4_0 then
			arg_4_0.vars.my_rank = var_4_1[iter_4_0].rank
			arg_4_0.vars.my_damage = var_4_1[iter_4_0].total_score
			
			break
		end
	end
	
	if get_cocos_refid(arg_4_0.vars.wnd) then
		if not arg_4_0.vars.wnd:isVisible() then
			TopBarNew:setVisible(false)
			if_set_visible(arg_4_0.vars.wnd, nil, true)
		end
		
		arg_4_0:uiSetting()
	end
	
	if arg_4_1.rewards then
		arg_4_0.vars.rewards_result = Account:addReward(arg_4_1.rewards)
	end
	
	arg_4_0:updateRankList()
end

function CoopResult.makeCoopResultDlg(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.test_rewards or arg_5_1
	local var_5_1 = arg_5_2.point_value
	
	if arg_5_2.add_bonus_point then
		var_5_1 = var_5_1 - arg_5_2.add_bonus_point
	end
	
	local var_5_2 = load_dlg("expedition_result_reward", true, "wnd")
	
	if_set(var_5_2, "txt_title", not arg_5_0.vars.is_win and T("expedition_faile_title") or T("expedition_complete"))
	if_set(var_5_2, "txt_disc", T("expedition_reward_desc"))
	
	local var_5_3 = arg_5_0.vars.is_win and "n_complete" or "n_fail"
	local var_5_4 = var_5_2:findChildByName(var_5_3)
	
	if_set_visible(var_5_2, "n_complete", false)
	if_set_visible(var_5_2, "n_fail", false)
	if_set_visible(var_5_4, nil, true)
	if_set(var_5_4, "txt_rank", T("expedition_rank", {
		rank = arg_5_0.vars.my_rank or "-"
	}))
	if_set(var_5_4, "txt_damage", comma_value(arg_5_0.vars.my_damage))
	if_set(var_5_4, "txt_point_title", T("expedition_boss_point", {
		boss = arg_5_0.vars.boss_name
	}))
	
	local var_5_5 = var_5_4:getChildByName("txt_point")
	
	if get_cocos_refid(var_5_5) then
		UIUserData:call(var_5_5, "SINGLE_WSCALE(210)", {
			origin_scale_x = 0.56
		})
		
		local var_5_6 = Account:getCoopCurrentSeasonPoint(arg_5_0.vars.boss_code)
		local var_5_7 = false
		
		if var_5_6 >= CoopUtil:getMaxRewardPoint(arg_5_0.vars.supply_group_id) then
			var_5_5:setString("MAX")
			
			var_5_7 = true
		else
			var_5_5:setString(T("expedition_supply_point", {
				point = comma_value(var_5_1)
			}))
			
			if arg_5_2.add_event_point then
				var_5_5:setColor(cc.c3b(255, 120, 0))
				var_5_5:enableOutline(cc.c3b(255, 120, 0), 1)
			end
		end
		
		local var_5_8 = arg_5_2.add_bonus_point
		
		if var_5_8 and var_5_8 > 0 and not var_5_7 then
			if_set(var_5_4, "txt_bonus", T("expedition_get_point_bonus", {
				point = var_5_8
			}))
			if_set_visible(var_5_4, "txt_bonus", true)
			var_5_5:setPositionY(var_5_5:getPositionY() + 10)
		end
	end
	
	local function var_5_9(arg_6_0, arg_6_1)
		if not arg_6_0 then
			return 
		end
		
		if not get_cocos_refid(arg_6_1) then
			return 
		end
		
		arg_6_1:setVisible(true)
		
		local var_6_0 = arg_6_0
		
		if arg_6_0.is_randombox then
			var_6_0 = arg_6_0.item
		end
		
		if Account:isCurrencyType(var_6_0.code) and not string.starts(var_6_0.code, "to_") then
			var_6_0.code = "to_" .. var_6_0.code
		end
		
		UIUtil:getRewardIcon(var_6_0.count, var_6_0.code, {
			parent = arg_6_1
		})
	end
	
	local var_5_10 = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0.rewards) do
		if not iter_5_1.is_randombox then
			table.insert(var_5_10, iter_5_1)
		end
	end
	
	local var_5_11 = table.count(var_5_10)
	local var_5_13
	
	if var_5_11 == 1 then
		local var_5_12 = var_5_4:findChildByName("n_item")
		
		var_5_9(var_5_10[1], var_5_12)
	elseif var_5_11 > 1 then
		var_5_13 = var_5_4:findChildByName("n_reward2")
		
		if get_cocos_refid(var_5_13) then
			var_5_13:setVisible(true)
			
			for iter_5_2 = 1, var_5_11 do
				local var_5_14 = var_5_13:findChildByName("n_item" .. iter_5_2)
				
				var_5_9(var_5_10[iter_5_2], var_5_14)
			end
		end
	end
	
	local var_5_15 = var_5_2:findChildByName("n_eff")
	
	if var_5_15 then
		var_5_15:setPositionX(VIEW_WIDTH / 2)
	end
	
	BackButtonManager:pop("expedition_result")
	Dialog:msgBox(T("expedition_complete"), {
		dlg = var_5_2,
		handler = function()
			CoopMission:onPushBackButton()
		end
	})
end

function CoopResult.onShow(arg_8_0, arg_8_1)
	if not get_cocos_refid(arg_8_1) then
		return 
	end
	
	arg_8_0.vars.is_win = arg_8_0.vars.args.boss_info.last_hp ~= nil and arg_8_0.vars.args.boss_info.last_hp <= 0 and arg_8_0.vars.args.boss_info.clear_tm
	arg_8_0.vars.wnd = load_dlg("expedition_result", true, "wnd", function()
		if arg_8_0.vars.rtn ~= nil then
			arg_8_0:makeCoopResultDlg(arg_8_0.vars.rewards_result, arg_8_0.vars.rtn)
		end
	end)
	arg_8_0.vars.rtn = arg_8_0.vars.rtn or {}
	arg_8_0.vars.data = arg_8_0.vars.data or {}
	
	arg_8_0:updateRankList()
	
	local var_8_0 = arg_8_0.vars.args.boss_info.boss_code
	local var_8_1 = Account:getCoopMissionSchedule().boss[var_8_0]
	
	if not var_8_1 then
		return 
	end
	
	arg_8_0.vars.boss_code = var_8_0
	arg_8_0.vars.supply_group_id = var_8_1.supply_group_id
	
	arg_8_1:addChild(arg_8_0.vars.wnd)
	if_set_visible(arg_8_0.vars.wnd, nil, false)
end

function CoopResult.updateRankList(arg_10_0)
	arg_10_0.vars.listView = CoopUtil:makeRankingListView(arg_10_0.vars.wnd:findChildByName("ScrollView"), arg_10_0.vars.data.ranking_list or {}, {
		result_scene = true,
		is_open_room = arg_10_0.vars.open_tm
	})
end

function CoopResult.uiSetting(arg_11_0)
	local var_11_0 = arg_11_0.vars.wnd:findChildByName("n_complete")
	local var_11_1 = arg_11_0.vars.wnd:findChildByName("n_fail")
	
	if_set_visible(var_11_0, nil, arg_11_0.vars.is_win)
	if_set_visible(var_11_1, nil, not arg_11_0.vars.is_win)
	
	local var_11_2 = arg_11_0.vars.data.ranking_list
	
	if var_11_2 then
		arg_11_0:rankingListSetting(var_11_2)
	end
	
	if var_11_2 and arg_11_0.vars.is_win then
		arg_11_0:top3Setting(var_11_2)
	end
	
	local var_11_3 = arg_11_0.vars.args.boss_info
	
	if var_11_3 then
		local var_11_4 = CoopUtil:getLevelData(var_11_3)
		
		arg_11_0.vars.boss_name = T(DB("character", var_11_4.character_id, "name"))
	end
	
	if var_11_3 and not arg_11_0.vars.is_win then
		arg_11_0:bossInfoSetting(var_11_1, var_11_3)
	end
	
	local var_11_5 = arg_11_0.vars.wnd:findChildByName("RIGHT"):findChildByName("n_my")
	local var_11_6 = arg_11_0.vars.args
	
	if var_11_6 then
		arg_11_0:setMyInfo(var_11_5, var_11_6)
	end
	
	if not arg_11_0.vars.my_rank then
		if_set(var_11_5, "txt_rank", T("pvp_list_rank", {
			rank = "-"
		}))
		if_set_visible(var_11_5, "txt_my_damage", false)
		if_set_visible(var_11_5, "txt_damage", false)
	end
	
	if arg_11_0.vars.is_win then
		EffectManager:Play({
			fn = "ui_mission_complete_fireworks.cfx",
			pivot_z = 99998,
			layer = arg_11_0.vars.wnd,
			pivot_x = VIEW_WIDTH / 2,
			pivot_y = VIEW_HEIGHT / 2
		})
	end
end

function CoopResult.rankingListSetting(arg_12_0, arg_12_1)
	arg_12_0.vars.listView:setDataSource(arg_12_1)
end

function CoopResult.top3Setting(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.wnd:findChildByName("n_ranking_honor")
	
	var_13_0:setLocalZOrder(999)
	arg_13_0.vars.wnd:findChildByName("_grow"):setLocalZOrder(99)
	arg_13_0.vars.wnd:findChildByName("_grow_s"):setLocalZOrder(100)
	
	for iter_13_0 = 1, 3 do
		local var_13_1 = var_13_0:findChildByName("n_" .. iter_13_0)
		local var_13_2 = arg_13_0.vars.wnd:findChildByName("n_port" .. iter_13_0)
		local var_13_3 = arg_13_1[iter_13_0]
		
		if not var_13_3 or var_13_3.total_score <= 0 then
			if_set_visible(var_13_1, nil, false)
			if_set_visible(var_13_2, nil, false)
		else
			local var_13_4 = var_13_1:findChildByName("face_icon_" .. iter_13_0)
			local var_13_5 = UIUtil:getLightIcon(var_13_3.leader_code, var_13_3.border_code)
			
			var_13_4:addChild(var_13_5)
			
			local var_13_6, var_13_7 = UIUtil:getPortraitAniByLeaderCode(var_13_3.leader_code, {
				pin_sprite_position_y = true
			})
			
			if var_13_6 then
				UnitMain:setMainUnitSkin(var_13_3.leader_code, var_13_6, var_13_3.face_id)
				
				if not var_13_7 then
					var_13_6:setPositionY(450)
				end
				
				var_13_2:addChild(var_13_6)
				var_13_2:setLocalZOrder(4 - iter_13_0)
			end
			
			if_set(var_13_1, "txt_damage", comma_value(var_13_3.total_score))
			if_set(var_13_1, "txt_user_name", var_13_3.name)
			if_set(var_13_1, "txt_" .. iter_13_0, T("pvp_list_rank", {
				rank = var_13_3.rank
			}))
		end
	end
end

function CoopResult.bossInfoSetting(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_1:findChildByName("n_gauge"):findChildByName("hp_red")
	local var_14_1 = CoopUtil:getBossHpRate(arg_14_2.max_hp, arg_14_2.last_hp)
	
	UIAction:Add(SEQ(LOG(SCALE_TO_X(200, var_14_1), 25)), var_14_0, "block")
	CoopUtil:setDifficulty(arg_14_1:findChildByName("n_difficulty"), tonumber(arg_14_2.difficulty))
	
	local var_14_2 = CoopUtil:getLevelData(arg_14_2)
	local var_14_3 = CoopUtil:getBossLevelFromLevelData(var_14_2)
	
	UIUtil:getRewardIcon(nil, var_14_2.character_id, {
		hide_lv = true,
		hide_star = true,
		tier = "boss",
		show_color_right = true,
		no_grade = true,
		parent = arg_14_1:findChildByName("mob_icon"),
		lv = var_14_3
	})
	
	local var_14_4 = UNIT:create({
		code = var_14_2.character_id
	})
	
	if_set(arg_14_1, "t_name", arg_14_0.vars.boss_name)
	
	local var_14_5 = arg_14_1:findChildByName("n_fu")
	
	if var_14_4 and not var_14_5:findChildByName("model") then
		local var_14_6 = CACHE:getModel(var_14_4.db)
		local var_14_7, var_14_8 = var_14_6:getBonePosition("top")
		
		var_14_6:setPosition(0, -var_14_8)
		var_14_6:setAnchorPoint(0.5, 0.5)
		var_14_6:setColor(var_14_5:getColor())
		var_14_6:setName("model")
		var_14_5:addChild(var_14_6)
	end
end

function CoopResult.setMyInfo(arg_15_0, arg_15_1, arg_15_2)
	CoopUtil:setRankText(arg_15_1, arg_15_0.vars.my_rank, arg_15_2.count, arg_15_2.total_score, true)
end

function CoopResult.onRemove(arg_16_0)
	if get_cocos_refid(arg_16_0.vars.wnd) then
		arg_16_0.vars.wnd:removeFromParent()
	end
	
	arg_16_0.vars = nil
end

function CoopResult.isValid(arg_17_0)
	if not arg_17_0.vars then
		return false
	end
	
	return get_cocos_refid(arg_17_0.vars.wnd)
end

function CoopResult.getBossInfo(arg_18_0)
	return arg_18_0.vars.args.boss_info
end
