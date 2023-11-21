local var_0_0 = {
	tab_1 = "info",
	tab_5 = "battle",
	tab_4 = "boss",
	tab_3 = "war",
	tab_2 = "history"
}

function HANDLER.clan_war_result(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_confirm" then
		ClanBattleList.ClanWar:enter_clan_war()
	end
	
	if arg_1_1 == "btn_result_info" then
		ClanWarResult:query()
	end
end

function HANDLER.clan_war_result_detail(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		ClanWarResult:hideRecord()
		
		return 
	end
	
	if arg_2_1 == "btn1" or arg_2_1 == "btn2" or arg_2_1 == "btn3" then
		ClanWarResult:selectTab(tonumber(string.sub(arg_2_1, -1, -1)))
		
		return 
	end
	
	if arg_2_1 == "btn_clan_info" then
		if get_cocos_refid(arg_2_0) and arg_2_0.clan_id then
			Clan:queryPreview(arg_2_0.clan_id, "preview")
		end
		
		return 
	end
end

function HANDLER.clan_home(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_member" then
		ClanManagement:show()
	end
	
	if arg_3_1 == "btn_stamp" then
		if not Clan:getAttenInfo().is_y_rewardable then
			balloon_message_with_sound("clan_atten_already_rewarded")
		else
			query("get_attendance_reward")
		end
	end
	
	if arg_3_1 == "btn_edit" then
		ClanEdit:show()
	end
	
	if arg_3_1 == "btn_admin" then
		if Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_notice") then
			ClanHome:showEditNoti()
		else
			balloon_message_with_sound("clan_master_able_edit_notice")
		end
	end
	
	if string.starts(arg_3_1, "member_btn") then
		ClanHome:showTalkBalloon(arg_3_1, arg_3_0)
	end
	
	if arg_3_1 == "btn_vist_reward" then
		ClanAttendance:show()
	end
	
	if arg_3_1 == "btn_history" then
		ClanHistory:showHistory()
		
		return 
	end
	
	if arg_3_1 == "btn_knights_recruitment" then
		ClanHome:showPromotion()
		
		return 
	end
	
	if arg_3_1 == "btn_knights_recru_chat" then
		ClanHome:showChatPromotion()
	end
	
	if arg_3_1 == "btn_clan_war" then
		ClanCategory:setMode("clan_war")
	end
end

function HANDLER.clan_home_history(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		ClanHistory:close()
	end
	
	if string.starts(arg_4_1, "btn_category") then
		local var_4_0 = string.split(arg_4_1, "_")[3]
		
		ClanHistory:selectHistoryTab(var_4_0)
	end
end

function HANDLER.clan_war_season_reward_p(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_ok" then
		ClanHome:closeSeasonRewardPopup()
	end
end

function HANDLER.clan_war_ranking_honor_p(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_ok" then
		ClanHome:closeHallOfFamePopup()
	end
end

function HANDLER.clan_promote_popup(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_cancel" then
		Dialog:close("clan_promote_popup")
	elseif arg_7_1 == "btn_yes" then
		ClanHome:onEventButtonYes()
	end
end

function MsgHandler.clan_edit_notice(arg_8_0)
	Clan:updateInfo(arg_8_0)
	ClanHome:updateClanNoticeUI()
	balloon_message_with_sound("clan_success_change_text_notice")
end

function ErrHandler.clan_edit_notice(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1 then
		return 
	end
	
	balloon_message_with_sound("intro." .. arg_9_1)
end

function MsgHandler.get_clan_history_logs(arg_10_0)
	if arg_10_0.logs then
		ClanHistory:setHistoryData(arg_10_0.logs, "history")
		
		ClanHistory.vars.query_times[var_0_0.tab_2] = os.time()
	end
end

function MsgHandler.get_clan_war_history_logs(arg_11_0)
	if arg_11_0.logs then
		ClanHistory:setHistoryData(arg_11_0.logs, "war")
		
		ClanHistory.vars.query_times[var_0_0.tab_3] = os.time()
	end
end

function MsgHandler.get_worldboss_history_logs(arg_12_0)
	if arg_12_0.logs then
		ClanHistory:setHistoryData(arg_12_0.logs, "boss")
		
		ClanHistory.vars.query_times[var_0_0.tab_4] = os.time()
	end
end

function MsgHandler.get_clan_war_member_result_record(arg_13_0)
	ClanWarResult:showRecord(arg_13_0)
end

ClanHome = {}
ClanWarResult = {}

function ClanHome.show(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.vars = {}
	
	local var_14_0 = load_dlg("clan_home", true, "wnd")
	
	arg_14_0.vars.wnd = var_14_0
	
	arg_14_0:updateRequestMemberNotiCount(Clan:getRequestMemberCount())
	if_set_visible(var_14_0, "noti_arrow_b", false)
	if_set_visible(var_14_0, "clan_war_bg_noti", false)
	
	arg_14_0.vars.ambient = cc.c3b(233, 238, 244)
	
	local var_14_1 = Clan:getMembers()
	
	if var_14_1 and #var_14_1 > 0 then
		ClanHome:setRandomMemberList(var_14_1)
	end
	
	arg_14_0.vars.bg = CACHE:getEffect("guild_table.scsp", "guild")
	
	local var_14_2 = var_14_0:getChildByName("n_table_spine")
	
	var_14_2:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_14_2:setScale(2.22)
	var_14_2:addChild(arg_14_0.vars.bg)
	
	arg_14_0.vars.effect = CACHE:getEffect("guild_light.scsp", "guild")
	
	local var_14_3 = var_14_0:getChildByName("n_table_effect")
	
	var_14_3:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_14_3:setScale(2.22)
	arg_14_0.vars.effect:setAnimation(0, "idle", true)
	var_14_3:addChild(arg_14_0.vars.effect)
	if_set_visible(arg_14_0.vars.wnd:getChildByName("n_clan_war"), "img_noti", false)
	arg_14_0:updateClanWarNotice()
	arg_14_0:initAutoBalloon()
	arg_14_0:initClanPromotion()
	
	return var_14_0
end

function ClanHome.initClanPromotion(arg_15_0)
	if IS_PUBLISHER_ZLONG then
		if_set_visible(arg_15_0.vars.wnd, "n_knights_recruitment", false)
		
		return 
	end
	
	if_set_visible(arg_15_0.vars.wnd, "n_knights_recruitment", false)
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		local var_16_0, var_16_1 = Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_invite_tap")
		
		var_16_0 = var_16_0 and not ContentDisable:byAlias("clan_promote")
		
		if_set_visible(arg_15_0.vars.wnd, "n_knights_recruitment", var_16_0)
	end)), arg_15_0.vars.wnd, "delay")
end

function ClanHome.setStampButtonState(arg_17_0, arg_17_1)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("btn_stamp")
	
	if get_cocos_refid(var_17_0) then
		var_17_0:setOpacity(76.5)
		if_set_visible(arg_17_0.vars.wnd, "stamp_noti", arg_17_1)
	end
end

function ClanHome.updateClanWarNotice(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	local var_18_0 = ClanWar:isWarReady()
	local var_18_1 = Clan:getWorldbossEnterable()
	local var_18_2 = ClanWar:isRewardAble()
	local var_18_3 = Account:isClanLotaNoti()
	
	if_set_visible(arg_18_0.vars.wnd:getChildByName("n_clan_war"), "img_noti", var_18_0 or var_18_2 or var_18_1 or var_18_3)
	if_set_visible(arg_18_0.vars.wnd:getChildByName("n_clan_war"), "clan_war_bg_noti", var_18_2)
	if_set_visible(arg_18_0.vars.wnd:getChildByName("n_clan_war"), "noti_arrow_b", var_18_2)
end

function ClanHome.createSeq(arg_19_0)
	arg_19_0.vars.noti_layer = cc.Layer:create()
	arg_19_0.vars.seq = Sequencer:init()
	
	arg_19_0.vars.seq:addRaw(arg_19_0.seqSupportResponseItem, arg_19_0)
	arg_19_0.vars.seq:addRaw(arg_19_0.seqAttendance, arg_19_0)
	arg_19_0.vars.seq:addRaw(arg_19_0.seqChangeGrade, arg_19_0)
	arg_19_0.vars.seq:addAsync(arg_19_0.clearNoti, arg_19_0)
	arg_19_0.vars.seq:getLayer():addChild(arg_19_0.vars.noti_layer)
	arg_19_0.vars.seq:play()
end

function ClanHome.nextNoti(arg_20_0, arg_20_1)
	if not arg_20_0.vars.seq then
		return 
	end
	
	if arg_20_1 and get_cocos_refid(arg_20_0.vars.noti_layer) then
		arg_20_0.vars.noti_layer:removeAllChildren()
	end
	
	arg_20_0.vars.seq:next(true, true)
end

function ClanHome.seqSupportResponseItem(arg_21_0)
	print("noti", "seqSupportResponseItem")
	
	local var_21_0 = Clan:getNoti() or {}
	
	if var_21_0.support_rewards then
		ClanRequestItemResult:show(arg_21_0.vars.noti_layer, var_21_0.support_rewards)
		
		var_21_0.support_rewards = nil
	else
		arg_21_0:nextNoti()
	end
end

function ClanHome.seqAttendance(arg_22_0)
	print("noti", "seqAttendance")
	
	local var_22_0 = Clan:getNoti() or {}
	
	if var_22_0.is_attendance then
		var_22_0.is_attendance = nil
		
		query("set_attendance")
	else
		arg_22_0:nextNoti()
	end
end

function ClanHome.seqChangeGrade(arg_23_0)
	print("noti", "seqChangeGrade")
	
	local var_23_0 = Clan:getNoti() or {}
	
	if var_23_0.is_change_grade then
		var_23_0.is_change_grade = nil
		
		local var_23_1 = Clan:getMemberGrade()
		
		print("Clan Change Grade : ", var_23_1)
		
		if var_23_1 == CLAN_GRADE.master then
			Dialog:msgBox(T("member_grade_msg1"), {
				handler = function()
					arg_23_0:nextNoti()
				end
			})
		elseif var_23_1 == CLAN_GRADE.executives then
			Dialog:msgBox(T("member_grade_msg2"), {
				handler = function()
					arg_23_0:nextNoti()
				end
			})
		elseif var_23_1 == CLAN_GRADE.member then
			Dialog:msgBox(T("member_grade_msg3"), {
				handler = function()
					arg_23_0:nextNoti()
				end
			})
		else
			arg_23_0:nextNoti()
		end
	else
		arg_23_0:nextNoti()
	end
end

function ClanHome.clearNoti(arg_27_0)
	print("noti", "clearNoti")
	arg_27_0.vars.seq:getLayer():removeAllChildren()
	arg_27_0.vars.seq:deinit()
	
	arg_27_0.vars.seq = nil
	
	if get_cocos_refid(arg_27_0.vars.noti_layer) then
		arg_27_0.vars.noti_layer:removeAllChildren()
	end
	
	if not TutorialGuide:startGuide(UNLOCK_ID.CLAN_MAIN) then
		TutorialGuide:procGuide()
	end
	
	arg_27_0:updateClanWarNotice()
	
	arg_27_0.vars.noti_layer = nil
end

function ClanHome.updateClanNoticeUI(arg_28_0)
	if Clan:isNoDatas() then
		return 
	end
	
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("t_clan_notice")
	
	if not get_cocos_refid(var_28_0) then
		return 
	end
	
	local var_28_1 = Clan:getClanNotice()
	local var_28_2 = "@^ye%"
	local var_28_3 = string.split(var_28_1, var_28_2)
	local var_28_4 = var_28_3[1]
	local var_28_5 = var_28_3[2]
	local var_28_6 = Clan:getMemberInfoById(var_28_5)
	local var_28_7 = Clan:getClanMaster()
	local var_28_8 = var_28_7.user_info
	
	if var_28_5 and not var_28_6 then
		var_28_7 = {}
		var_28_8 = {}
	elseif not var_28_5 then
	else
		var_28_7 = var_28_6
		var_28_8 = var_28_6.user_info
	end
	
	local var_28_9 = var_28_8.leader_code or "m0000"
	
	UIUtil:getRewardIcon(nil, var_28_9, {
		no_popup = true,
		character_type = "character",
		scale = 1,
		no_grade = true,
		parent = arg_28_0.vars.wnd:getChildByName("n_face"),
		border_code = var_28_8.border_code
	})
	if_set(arg_28_0.vars.wnd, "txt_name", var_28_8.name or T("ui_clan_home_notice_unknown_member"))
	
	local var_28_10 = Clan:getClanMaster().user_id
	local var_28_11 = Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_management")
	local var_28_12 = Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_prchat")
	
	if_set_visible(arg_28_0.vars.wnd, "btn_manag", var_28_11)
	if_set_visible(arg_28_0.vars.wnd, "btn_knights_recru_chat", var_28_12)
	
	local var_28_13 = var_28_7.grade and var_28_7.grade >= CLAN_GRADE.executives
	
	if var_28_7.grade and var_28_7.grade == CLAN_GRADE.executives then
		if_set_color(arg_28_0.vars.wnd, "img_grade", cc.c3b(42, 120, 195))
	end
	
	if_set_visible(arg_28_0.vars.wnd, "img_grade", var_28_13)
	UIUtil:updateTextWrapMode(var_28_0, var_28_4)
	var_28_0:setString(var_28_4)
end

function ClanHome.updateClanUI(arg_29_0, arg_29_1)
	if not arg_29_0.vars then
		return 
	end
	
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	UIUtil:updateClanInfo(arg_29_0.vars.wnd:getChildByName("base"), arg_29_1, {
		offset_x = 8
	})
	
	local var_29_0 = Account:serverTimeDayLocalDetail()
	local var_29_1 = Account:isJPN() and var_29_0 < JPN_CLAN_WAR_OPEN_DAY
	
	if_set_visible(arg_29_0.vars.wnd, "n_clan_war", not var_29_1)
	arg_29_0:updateClanNoticeUI()
end

function ClanHome.updateAttenInfoUI(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0 = Clan:getAttenInfo()
	
	if var_30_0 then
		local var_30_1 = #Clan:getMembers()
		
		if_set(arg_30_0.vars.wnd, "t_atten_per", T("ui_clan_home_attend_status", {
			count = var_30_0.t_count,
			max = var_30_1
		}))
		
		local var_30_2 = 255
		local var_30_3 = false
		
		if not Clan:getAttenInfo().is_y_rewardable then
			var_30_2 = 76.5
		elseif to_n(var_30_0.y_count) >= 5 then
			var_30_3 = true
		end
		
		local var_30_4 = arg_30_0.vars.wnd:getChildByName("btn_stamp")
		
		if_set_visible(arg_30_0.vars.wnd, "stamp_noti", var_30_3)
		arg_30_0.vars.wnd:getChildByName("btn_stamp"):setOpacity(var_30_2)
		
		if Clan:getStampValue() then
			ClanHome:setStampButtonState(false)
		end
	end
end

function ClanHome.showEditNoti(arg_31_0)
	local function var_31_0()
		if arg_31_0.vars.noti_info.text == arg_31_0.vars.noti_info.prev_text then
			balloon_message_with_sound("no_change_text_clan_notice")
			
			return 
		end
		
		local var_32_0 = arg_31_0.vars.noti_info.text
		local var_32_1 = string.trim(var_32_0)
		
		if check_abuse_filter(var_32_1, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		if var_32_1 == nil or utf8len(var_32_1) < 5 then
			balloon_message_with_sound("lack_clan_notice_msg_length")
			
			return 
		end
		
		query("clan_edit_notice", {
			msg = arg_31_0.vars.noti_info.text
		})
	end
	
	local var_31_1 = Clan:getClanInfo()
	
	arg_31_0.vars.noti_info = {}
	
	local var_31_2 = Clan:getNoticeOnlyText()
	
	arg_31_0.vars.noti_info.prev_text = var_31_2
	
	local var_31_3, var_31_4 = Dialog:openInputBox(arg_31_0, var_31_0, {
		max_limit = 50,
		info = arg_31_0.vars.noti_info
	})
	
	arg_31_0.vars.wnd:addChild(var_31_3)
end

function ClanHome.isHome(arg_33_0)
	if arg_33_0.vars and arg_33_0.vars.wnd and get_cocos_refid(arg_33_0.vars.wnd) then
		return true
	end
	
	return false
end

function ClanHome.updateRequestMemberNotiCount(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_34_0.vars.wnd, "manage_noti", arg_34_1 and arg_34_1 > 0)
end

function ClanHome.initAutoBalloon(arg_35_0)
	if Scheduler:findByName("ClanHomeAutoBalloon") then
		return 
	end
	
	arg_35_0.vars.autoBalloonTimmer = math.floor(LAST_TICK or -1)
	arg_35_0.vars.beforeIndex = 0
	arg_35_0.vars.balloon_delay = 0
	arg_35_0.vars.balloon_delay = math.random(30000, 60000)
	
	print("baloon_random_period", arg_35_0.vars.balloon_delay / 100)
	arg_35_0:AddAutoBalloonFromScheduler(arg_35_0)
end

function ClanHome.AddAutoBalloonFromScheduler(arg_36_0)
	Scheduler:remove(arg_36_0.check_autoBalloon)
	Scheduler:addSlow(ClanHome.vars.wnd, ClanHome.check_autoBalloon, ClanHome):setName("ClanHomeAutoBalloon")
end

function ClanHome.removeAutoBalloonFromScheduler(arg_37_0)
	Scheduler:remove(ClanHome.check_autoBalloon)
end

function ClanHome.check_autoBalloon(arg_38_0)
	if not arg_38_0.vars or arg_38_0.vars == nil or not get_cocos_refid(arg_38_0.vars.wnd) or not arg_38_0.vars.autoBalloonTimmer or arg_38_0.vars.balloon_delay then
		arg_38_0:removeAutoBalloonFromScheduler()
		
		return 
	end
	
	if math.floor(LAST_TICK or -1) - arg_38_0.vars.autoBalloonTimmer >= arg_38_0.vars.balloon_delay and get_cocos_refid(arg_38_0.vars.wnd) then
		arg_38_0:showAutoBalloon()
	end
end

function ClanHome.showAutoBalloon(arg_39_0)
	if not arg_39_0.vars or arg_39_0.vars == nil then
		return 
	end
	
	local var_39_0 = 0
	
	;(function()
		local var_40_0 = 0
		
		for iter_40_0, iter_40_1 in pairs(arg_39_0.vars.models) do
			if tolua.type(iter_40_1) == "table" then
				var_40_0 = var_40_0 + 1
			end
		end
		
		if var_40_0 <= 1 then
			arg_39_0.vars.beforeIndex = 0
		end
	end)()
	
	while var_39_0 do
		var_39_0 = math.random(1, 8)
		
		if var_39_0 ~= arg_39_0.vars.beforeIndex and arg_39_0.vars.models[var_39_0] and arg_39_0.vars.models[var_39_0] ~= "none" then
			break
		end
	end
	
	local var_39_1 = "member_btn" .. var_39_0
	local var_39_2 = arg_39_0.vars.wnd:getChildByName(var_39_1)
	
	if get_cocos_refid(var_39_2) then
		arg_39_0:showTalkBalloon(var_39_1, var_39_2)
	end
	
	arg_39_0.vars.beforeIndex = var_39_0
	arg_39_0.vars.autoBalloonTimmer = math.floor(LAST_TICK or -1)
end

function ClanHome.showTalkBalloon(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = string.split(arg_41_1, "btn")
	local var_41_1 = tonumber(var_41_0[2])
	
	if UIAction:Find("talk_balloon") then
		return 
	end
	
	if arg_41_0.vars.models[var_41_1] == "none" or not arg_41_0.vars.models[var_41_1] then
		return 
	end
	
	local var_41_2 = 0
	local var_41_3 = 0
	
	if var_41_1 <= 4 then
		var_41_2 = 50
	end
	
	local var_41_4 = Clan:getMemberInfoById(arg_41_0.vars.models[var_41_1].user_info.id).intro_msg or T("input_default_msg_clan_member_intro")
	
	UIUtil:showTalkBalloon2(var_41_4, {
		auto_height = true,
		default_delay = 1500,
		long_word_num = 25,
		name = arg_41_0.vars.models[var_41_1].user_info.name,
		code = arg_41_0.vars.models[var_41_1].user_info.leader_code,
		border_code = arg_41_0.vars.models[var_41_1].user_info.border_code,
		x = var_41_2,
		y = var_41_3 + 200,
		layer = arg_41_2,
		reverse = var_41_1 > 4
	})
end

function ClanHome.setRandomMemberList(arg_42_0, arg_42_1, arg_42_2)
	arg_42_2 = arg_42_2 or {}
	
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.wnd) then
		return 
	end
	
	local var_42_0 = arg_42_2.show_balloon or false
	local var_42_1 = table.clone(arg_42_1)
	
	table.shuffle(var_42_1)
	
	if Clan.test_mode then
		var_42_1 = Clan:getTestRandomModel()
	else
		for iter_42_0 = 1, 8 do
			if not var_42_1[iter_42_0] then
				var_42_1[iter_42_0] = "none"
			end
			
			var_42_1[iter_42_0] = var_42_1[iter_42_0]
		end
		
		table.shuffle(var_42_1)
	end
	
	arg_42_0.vars.models = var_42_1
	
	local var_42_2 = Account:getCurrentTeam()
	local var_42_3 = {
		2.2,
		1.75,
		1.45,
		1.3,
		1.3,
		1.45,
		1.75,
		2.2
	}
	
	for iter_42_1 = 1, 8 do
		arg_42_0.vars.wnd:getChildByName("member_" .. iter_42_1):removeAllChildren()
	end
	
	for iter_42_2, iter_42_3 in pairs(var_42_1 or {}) do
		if iter_42_2 > 8 then
			break
		end
		
		local var_42_4 = arg_42_0.vars.wnd:getChildByName("members"):getChildByName("chair_" .. iter_42_2)
		
		var_42_4:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_42_4:setScale(2.22)
		
		local var_42_5 = "l_chair"
		local var_42_6 = iter_42_2
		
		if iter_42_2 > 4 then
			var_42_5 = "r_chair"
			var_42_6 = 8 - iter_42_2 + 1
		end
		
		local var_42_7 = CACHE:getEffect(var_42_5 .. var_42_6 .. ".scsp", "guild")
		
		var_42_4:addChild(var_42_7)
		
		if iter_42_3 ~= "none" then
			local var_42_8 = UNIT:create({
				code = iter_42_3.user_info.leader_code
			})
			
			if var_42_8 then
				local var_42_9 = CACHE:getModel(var_42_8.db.model_id, var_42_8.db.skin, "camping", var_42_8.db.atlas, var_42_8.db.model_opt)
				local var_42_10 = var_42_9:setAnimation(0, "camping", true)
				
				if var_42_10 then
					var_42_10.time = var_42_10.endTime * math.random()
				end
				
				var_42_9:setPosition(0, 20)
				var_42_9:setColor(arg_42_0.vars.ambient)
				var_42_9:update(math.random())
				
				local var_42_11 = (iter_42_3.scale or var_42_3[iter_42_2]) * var_42_8.db.scale * 0.8
				
				var_42_9:setScale(var_42_11)
				
				if iter_42_2 > 4 then
					var_42_9:setScaleX(0 - var_42_11)
				end
				
				arg_42_0.vars.wnd:getChildByName("member_" .. iter_42_2):addChild(var_42_9)
			end
		end
	end
	
	if var_42_0 then
		arg_42_0:showAutoBalloon()
	end
end

function ClanHome.logicHallofFame_seasonReward(arg_43_0, arg_43_1)
	arg_43_0.vars.isWarSeasonRewardExist = false
	
	if arg_43_1.season_reward_items and not table.empty(arg_43_1.season_reward_items) then
		arg_43_0.vars.isWarSeasonRewardExist = true
		arg_43_0.vars.season_reward_items = arg_43_1.season_reward_items
	end
	
	if arg_43_1.fame_infos and not table.empty(arg_43_1.fame_infos) then
		ClanHome:showHallOfFamePopup(arg_43_1.fame_infos)
	elseif arg_43_0.vars.isWarSeasonRewardExist then
		ClanHome:showSeasonRewardPopup(arg_43_1.season_reward_items)
	end
end

function ClanHome.showSeasonRewardPopup(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1 or arg_44_0.vars.season_reward_items
	
	if not var_44_0 or table.empty(var_44_0) then
		return 
	end
	
	arg_44_0.vars.clanWarSeasonReward_wnd = load_dlg("clan_war_season_reward_p", true, "wnd", function()
		ClanHome:closeSeasonRewardPopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_44_0.vars.clanWarSeasonReward_wnd)
	
	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		local var_44_1 = Clan:getItemCount(iter_44_0)
		local var_44_2, var_44_3, var_44_4 = DB("clan_material", iter_44_0, {
			"name",
			"icon",
			"desc"
		})
		
		if var_44_2 and iter_44_1 ~= var_44_1 then
			if_set(arg_44_0.vars.clanWarSeasonReward_wnd, "txt_emblem_bg_name", T(var_44_2))
			if_set(arg_44_0.vars.clanWarSeasonReward_wnd, "txt_emblem_bg_desc", T(var_44_4))
			if_set_sprite(arg_44_0.vars.clanWarSeasonReward_wnd, "emblem_bg", "emblem/" .. var_44_3)
			Clan:setItemCount(iter_44_0, iter_44_1)
		end
	end
end

function ClanHome.closeSeasonRewardPopup(arg_46_0)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.clanWarSeasonReward_wnd) then
		return 
	end
	
	BackButtonManager:pop("clan_war_season_reward_p")
	arg_46_0.vars.clanWarSeasonReward_wnd:removeFromParent()
end

function ClanHome.showHallOfFamePopup(arg_47_0, arg_47_1)
	arg_47_0.vars.clanWarHallofFame_wnd = load_dlg("clan_war_ranking_honor_p", true, "wnd", function()
		ClanHome:closeHallOfFamePopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_47_0.vars.clanWarHallofFame_wnd)
	UIAction:Add(DELAY(1000), arg_47_0.vars.clanWarHallofFame_wnd, "block")
	
	local var_47_0 = false
	local var_47_1 = Account:getPrevRegularWarSeasonInfo()
	
	if var_47_1 then
		local var_47_2 = DB("clan_war", var_47_1.id, "season_name")
		local var_47_3 = var_47_1.start_time or 0
		local var_47_4 = var_47_1.end_time or 0
		
		if_set(arg_47_0.vars.clanWarHallofFame_wnd, "txt_title", T("clanwar_fame_popup_title", {
			name = T(var_47_2)
		}))
		
		local var_47_5
		
		if UIUtil:isChangeSeasonLabelPosition() then
			var_47_5 = arg_47_0.vars.clanWarHallofFame_wnd:getChildByName("n_season_2/2")
			
			var_47_5:setVisible(true)
			if_set_visible(arg_47_0.vars.clanWarHallofFame_wnd, "n_season_1/2", false)
		else
			var_47_5 = arg_47_0.vars.clanWarHallofFame_wnd:getChildByName("n_season_1/2")
			
			var_47_5:setVisible(true)
			if_set_visible(arg_47_0.vars.clanWarHallofFame_wnd, "n_season_2/2", false)
		end
		
		if_set(var_47_5, "txt_season_number", T(var_47_2))
		if_set(arg_47_0.vars.clanWarHallofFame_wnd, "txt_season_period", T("clanwar_ranking_tap3_desc3", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_47_3,
			end_time = var_47_4
		})))
		
		if var_47_1.id == "war04" and arg_47_1[1] and arg_47_1[2] and tonumber(arg_47_1[1].clan_id) == 1103 and arg_47_1[1].name == "Deviants" and tonumber(arg_47_1[2].clan_id) == 336 and arg_47_1[2].name == "Veritas" then
			var_47_0 = true
			arg_47_1[2], arg_47_1[1] = table.clone(arg_47_1[1]), arg_47_1[2]
		end
	end
	
	local var_47_6 = 1
	
	for iter_47_0 = 1, 3 do
		local var_47_7 = arg_47_0.vars.clanWarHallofFame_wnd:getChildByName("n_" .. iter_47_0)
		
		if not get_cocos_refid(var_47_7) or not arg_47_1[iter_47_0] then
			break
		end
		
		local var_47_8 = arg_47_1[iter_47_0] or {}
		
		if_set(var_47_7, "txt_clan_name", var_47_8.name)
		UIUtil:updateClanEmblem(var_47_7, var_47_8)
		
		if var_47_0 and iter_47_0 == 2 then
			local var_47_9 = arg_47_0.vars.clanWarHallofFame_wnd:getChildByName("txt_1"):clone()
			
			if_set_visible(arg_47_0.vars.clanWarHallofFame_wnd, "txt_2", false)
			var_47_7:addChild(var_47_9)
			var_47_9:setPosition(25, 98)
		end
		
		var_47_6 = var_47_6 + 1
	end
	
	for iter_47_1 = var_47_6, 3 do
		if_set_visible(arg_47_0.vars.clanWarHallofFame_wnd, "n_" .. iter_47_1, false)
	end
end

function ClanHome.showPromotion(arg_49_0)
	local function var_49_0()
		return ({
			kor = T("rta_server_kor"),
			asia = T("rta_server_asia"),
			global = T("rta_server_global"),
			eu = T("rta_server_europe"),
			jpn = T("rta_server_japan")
		})[Login:getRegion()] or "non-server"
	end
	
	local var_49_1 = Clan:getClanInfo()
	local var_49_2 = {
		"public",
		"selection",
		"private"
	}
	local var_49_3 = ClanTag:getClanTagLabelList()
	local var_49_4 = {
		clan_server = var_49_0(),
		clan_level = var_49_1.level,
		clan_name = var_49_1.name,
		clan_introduce = Base64.encode(var_49_1.intro_msg or ""),
		clan_member_num = var_49_1.member_count,
		clan_member_max_num = Clan:getMaxClanMember(),
		clan_limit_level = var_49_1.rank_limit,
		clan_join_approval_type = var_49_2[var_49_1.join_type],
		clan_emblem = ClanUtil:getSpriteEmblemFilename(ClanUtil:getEmblemID({
			emblem = var_49_1.emblem
		})),
		clan_emblem_background = ClanUtil:getSpriteEmblemFilename(ClanUtil:getEmblemBGID({
			emblem = var_49_1.emblem
		})),
		clan_tag_01 = var_49_3[1] or "",
		clan_tag_02 = var_49_3[2] or ""
	}
	
	Stove:openClanPromotionBoardForWrite(var_49_4)
end

function ClanHome.showChatPromotion(arg_51_0)
	arg_51_0.vars.promote_wnd = Dialog:open("wnd/clan_promote_popup", arg_51_0)
	
	if not arg_51_0.vars.promote_wnd then
		return 
	end
	
	local var_51_0 = arg_51_0.vars.promote_wnd:getChildByName("n_content")
	local var_51_1 = Clan:getClanInfo()
	
	upgradeLabelToRichLabel(var_51_0, "t_clan_promo")
	
	local var_51_2 = string.format("<%s>%s</>", "#337ac3", "[" .. (var_51_1.name or "") .. "]")
	
	if_set(arg_51_0.vars.promote_wnd, "t_clan_promo", T("ui_clan_popup_promote_base", {
		clanname = var_51_2
	}))
	UIUtil:updateClanEmblem(arg_51_0.vars.promote_wnd:getChildByName("n_emblem"), {
		emblem = var_51_1.emblem
	})
	
	local var_51_3 = var_51_0:getChildByName("text_clan_info")
	
	UIUtil:updateTextWrapMode(var_51_3, var_51_1.intro_msg)
	
	local var_51_4 = get_ellipsis(var_51_3, var_51_1.intro_msg, function()
		return utf8len(var_51_3:getString()) > 49
	end)
	
	if_set(var_51_3, nil, var_51_4)
	
	local var_51_5 = arg_51_0.vars.promote_wnd:getChildByName("btn_yes")
	local var_51_6 = var_51_5:getChildByName("icon_res")
	local var_51_7 = "ct_clangold"
	local var_51_8 = GAME_CONTENT_VARIABLE.clan_prchat_price_clangold
	
	UIUtil:getRewardIcon(nil, var_51_7, {
		no_bg = true,
		parent = var_51_6
	})
	if_set(var_51_5, "cost", comma_value(var_51_8))
	
	local var_51_9 = GAME_CONTENT_VARIABLE.clan_prchat_daily_limit
	local var_51_10 = Clan:getRemainPromoteCount()
	
	if var_51_10 <= 0 or var_51_8 > Clan:getCurrency(var_51_7) then
		var_51_5:setOpacity(76.5)
	end
	
	local var_51_11 = arg_51_0.vars.promote_wnd:getChildByName("n_content")
	
	if_set(var_51_11, "t_count", T("ui_clan_popup_prlimit_day", {
		count = var_51_10,
		max = var_51_9
	}))
	SceneManager:getRunningPopupScene():addChild(arg_51_0.vars.promote_wnd)
end

function ClanHome.onEventButtonYes(arg_53_0)
	local var_53_0 = GAME_CONTENT_VARIABLE.clan_prchat_daily_limit
	
	if Clan:getRemainPromoteCount() <= 0 then
		balloon_message_with_sound_raw_text(T("clan_promote.count_over"))
		
		return 
	end
	
	local var_53_1 = "ct_clangold"
	
	if GAME_CONTENT_VARIABLE.clan_prchat_price_clangold > Clan:getCurrency(var_53_1) then
		balloon_message_with_sound_raw_text(T("clan_promote.er_ct_clangold"))
		
		return 
	end
	
	local var_53_2 = Clan:getClanInfo()
	local var_53_3 = ClanUtil:isMaxMemberCount(var_53_2)
	local var_53_4 = Clan:getCurrency(var_53_1)
	
	if var_53_3 then
		Dialog:msgBox(T("ui_clan_popup_member_full_check"), {
			yesno = true,
			handler = function()
				query("clan_promote")
			end
		})
	else
		query("clan_promote")
	end
end

function ClanHome.closeHallOfFamePopup(arg_55_0)
	if not arg_55_0.vars or not get_cocos_refid(arg_55_0.vars.clanWarHallofFame_wnd) then
		return 
	end
	
	BackButtonManager:pop("clan_war_ranking_honor_p")
	arg_55_0.vars.clanWarHallofFame_wnd:removeFromParent()
	
	if arg_55_0.vars.isWarSeasonRewardExist and arg_55_0.vars.season_reward_items then
		ClanHome:showSeasonRewardPopup(arg_55_0.vars.season_reward_items)
	end
end

ClanHistory = ClanHistory or {}

function ClanHistory.showHistory(arg_56_0, arg_56_1)
	if not arg_56_0.vars then
		arg_56_0.vars = {}
	end
	
	if not get_cocos_refid(arg_56_0.vars.history_wnd) then
		local var_56_0 = load_dlg("clan_home_history", true, "wnd")
		
		arg_56_1 = arg_56_1 or SceneManager:getDefaultLayer()
		
		arg_56_1:addChild(var_56_0)
		
		arg_56_0.vars.history_wnd = var_56_0
		
		arg_56_0:updateHistoryUI()
	else
		arg_56_0.vars.history_wnd:setVisible(true)
	end
	
	SoundEngine:play("event:/ui/popup/tap")
end

function ClanHistory.close(arg_57_0)
	if not arg_57_0.vars or not arg_57_0.vars.history_wnd then
		return 
	end
	
	arg_57_0.vars.history_wnd:setVisible(false)
end

function ClanHistory.isShow(arg_58_0)
	if not arg_58_0.vars or not arg_58_0.vars.history_wnd then
		return 
	end
	
	return arg_58_0.vars.history_wnd:isVisible()
end

function ClanHistory.clear(arg_59_0)
	arg_59_0.vars = {}
end

function ClanHistory.updateHistoryUI(arg_60_0)
	local var_60_0 = Clan:getClanInfo()
	local var_60_1 = os.date("*t", var_60_0.created)
	
	UIUtil:updateClanInfo(arg_60_0.vars.history_wnd, var_60_0, {
		offset_x = 8
	})
	
	local var_60_2 = #Clan:getMembers()
	local var_60_3 = Clan:getAttenInfo()
	
	if_set(arg_60_0.vars.history_wnd, "txt_todayvisit", T("ui_clan_home_attend_status", {
		count = var_60_3.t_count,
		max = var_60_2
	}))
	if_set(arg_60_0.vars.history_wnd, "txt_date", T("clan_foundation", {
		year = var_60_1.year,
		month = T("txt_month_" .. var_60_1.month),
		day = T("clan_found_day", {
			day = var_60_1.day
		})
	}))
	if_set(arg_60_0.vars.history_wnd, "txt_recode_gold_v", comma_value(var_60_0.acc_contribution_token1 or 0))
	if_set(arg_60_0.vars.history_wnd, "txt_recode_brave_v", comma_value(var_60_0.acc_contribution_token2 or 0))
	if_set(arg_60_0.vars.history_wnd, "txt_recode_weekmission_v", comma_value(var_60_0.acc_week_mission_count or 0))
	if_set(arg_60_0.vars.history_wnd, "txt_attendance_v", comma_value(var_60_0.acc_attribution_count or 0))
	if_set(arg_60_0.vars.history_wnd, "txt_support_v", comma_value(var_60_0.acc_support_count or 0))
	
	arg_60_0.vars.mode_nodes = {}
	arg_60_0.vars.mode_nodes[var_0_0.tab_1] = arg_60_0.vars.history_wnd:getChildByName("n_info")
	arg_60_0.vars.mode_nodes[var_0_0.tab_2] = arg_60_0.vars.history_wnd:getChildByName("n_history")
	arg_60_0.vars.mode_nodes[var_0_0.tab_3] = arg_60_0.vars.history_wnd:getChildByName("n_war")
	arg_60_0.vars.mode_nodes[var_0_0.tab_4] = arg_60_0.vars.history_wnd:getChildByName("n_boss")
	arg_60_0.vars.mode_nodes[var_0_0.tab_5] = arg_60_0.vars.history_wnd:getChildByName("n_occupied_battle")
	
	local var_60_4 = Account:serverTimeDayLocalDetail()
	
	if Account:isJPN() and var_60_4 < JPN_CLAN_WAR_OPEN_DAY then
		arg_60_0.vars.history_wnd:getChildByName("n_category_war"):setVisible(false)
	end
	
	arg_60_0.vars.history_wnd:getChildByName("n_category_battle"):setVisible(false)
	
	arg_60_0.vars.query_times = {}
	arg_60_0.vars.scrollview_list = {}
	
	for iter_60_0 = 1, 5 do
		local var_60_5 = arg_60_0.vars.mode_nodes[var_0_0["tab_" .. tostring(iter_60_0)]]:getChildByName("ScrollView")
		
		if var_60_5 then
			arg_60_0.vars.scrollview_list[var_0_0["tab_" .. tostring(iter_60_0)]] = var_60_5
		end
	end
	
	arg_60_0:selectHistoryTab("info")
end

function ClanHistory.selectHistoryTab(arg_61_0, arg_61_1)
	for iter_61_0, iter_61_1 in pairs(var_0_0) do
		local var_61_0 = arg_61_0.vars.history_wnd:getChildByName("n_category_" .. iter_61_1):getChildByName("bg_category_" .. iter_61_1)
		
		if iter_61_1 == arg_61_1 then
			var_61_0:setVisible(true)
			arg_61_0.vars.mode_nodes[iter_61_1]:setVisible(true)
		else
			var_61_0:setVisible(false)
			arg_61_0.vars.mode_nodes[iter_61_1]:setVisible(false)
		end
	end
	
	if_set_visible(arg_61_0.vars.history_wnd, "n_no_data", false)
	
	if arg_61_1 == "info" then
		local var_61_1 = ClanHistory.vars.query_times[var_0_0.tab_1]
		
		if not var_61_1 or var_61_1 + 300 < os.time() then
			query("clan_war_delete_history", {
				clan_id = Account:getClanId()
			})
		end
	elseif arg_61_1 == "history" then
		local var_61_2 = ClanHistory.vars.query_times[var_0_0.tab_2]
		
		if not var_61_2 or var_61_2 + 300 < os.time() then
			arg_61_0.vars.scrollview_list[var_0_0.tab_2]:removeAllChildren()
			query("get_clan_history_logs")
		else
			if_set_visible(arg_61_0.vars.history_wnd, "n_no_data", not arg_61_0.vars.history_logs or table.count(arg_61_0.vars.history_logs) <= 0)
		end
	elseif arg_61_1 == "war" then
		local var_61_3 = ClanHistory.vars.query_times[var_0_0.tab_3]
		
		if not var_61_3 or var_61_3 + 300 < os.time() then
			arg_61_0.vars.scrollview_list[var_0_0.tab_3]:removeAllChildren()
			query("get_clan_war_history_logs")
		else
			if_set_visible(arg_61_0.vars.history_wnd, "n_no_data", not arg_61_0.vars.war_logs or table.count(arg_61_0.vars.war_logs) <= 0)
		end
	elseif arg_61_1 == "boss" then
		local var_61_4 = ClanHistory.vars.query_times[var_0_0.tab_4]
		
		if not var_61_4 or var_61_4 + 300 < os.time() then
			arg_61_0.vars.scrollview_list[var_0_0.tab_4]:removeAllChildren()
			query("get_worldboss_history_logs")
		else
			if_set_visible(arg_61_0.vars.history_wnd, "n_no_data", not arg_61_0.vars.boss_logs or table.count(arg_61_0.vars.boss_logs) <= 0)
		end
	end
end

function ClanHistory.setHistoryData(arg_62_0, arg_62_1, arg_62_2)
	if arg_62_1 then
		if arg_62_2 == "history" then
			arg_62_0.vars.history_logs = arg_62_1
			
			arg_62_0:setDatas(arg_62_0.vars.scrollview_list[arg_62_2], arg_62_0.vars.history_logs, arg_62_2)
			if_set_visible(arg_62_0.vars.history_wnd, "n_no_data", not arg_62_0.vars.history_logs or table.count(arg_62_0.vars.history_logs) <= 0)
		elseif arg_62_2 == "war" then
			arg_62_0.vars.war_logs = arg_62_1
			
			arg_62_0:setDatas(arg_62_0.vars.scrollview_list[arg_62_2], arg_62_0.vars.war_logs, arg_62_2)
			if_set_visible(arg_62_0.vars.history_wnd, "n_no_data", not arg_62_0.vars.war_logs or table.count(arg_62_0.vars.war_logs) <= 0)
		elseif arg_62_2 == "boss" then
			arg_62_0.vars.boss_logs = arg_62_1
			
			arg_62_0:setDatas(arg_62_0.vars.scrollview_list[arg_62_2], arg_62_0.vars.boss_logs, arg_62_2)
			if_set_visible(arg_62_0.vars.history_wnd, "n_no_data", not arg_62_0.vars.boss_logs or table.count(arg_62_0.vars.boss_logs) <= 0)
		end
	end
	
	if false then
	end
end

function ClanHistory.setDatas(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0 = 1
	
	table.sort(arg_63_2, function(arg_64_0, arg_64_1)
		return arg_64_0.created > arg_64_1.created
	end)
	
	local var_63_1 = 0
	local var_63_2 = 0
	
	for iter_63_0, iter_63_1 in pairs(arg_63_2 or {}) do
		local var_63_3, var_63_4 = arg_63_0:getNodeText(iter_63_1, iter_63_0, nil, arg_63_3)
		
		var_63_1 = var_63_1 + var_63_4
		
		if iter_63_0 == 1 then
			var_63_2 = var_63_4
		end
	end
	
	local var_63_5 = math.max(var_63_1, arg_63_1:getContentSize().height)
	local var_63_6 = var_63_5 - var_63_2
	
	for iter_63_2, iter_63_3 in pairs(arg_63_2 or {}) do
		local var_63_7, var_63_8 = arg_63_0:getNodeText(iter_63_3, iter_63_2, var_63_6, arg_63_3)
		
		var_63_6 = var_63_6 - var_63_8
		
		if not get_cocos_refid(var_63_7) then
			return 
		end
		
		arg_63_1:getInnerContainer():addChild(var_63_7)
	end
	
	arg_63_1:getInnerContainer():setPositionY(0)
	arg_63_1:setInnerContainerSize({
		width = arg_63_1:getContentSize().width,
		height = var_63_5
	})
	arg_63_1:jumpToTop()
end

function ClanHistory.getNodeText(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	local var_65_0 = arg_65_1.history_id
	local var_65_1 = arg_65_1.v1
	local var_65_2 = arg_65_1.v2
	local var_65_3 = arg_65_1.v3
	local var_65_4 = arg_65_1.v4
	local var_65_5 = arg_65_1.v5
	
	if var_65_0 == "ch_member_grade" then
		var_65_2 = T("msg_clangrade_" .. tostring(var_65_2))
	elseif var_65_0 == "ch_mastershop" then
		var_65_2 = T(var_65_2)
	elseif var_65_0 == "ch_wb_battle" then
		local var_65_6 = DB("clan_worldboss", var_65_2, {
			"char_id"
		})
		local var_65_7 = DB("character", var_65_6, {
			"name"
		})
		
		var_65_2 = T(var_65_7)
		var_65_3 = math.floor(var_65_3)
		var_65_3 = comma_value(var_65_3)
	elseif var_65_0 == "ch_wb_prerank" then
		var_65_2 = math.floor(var_65_2)
		var_65_2 = comma_value(var_65_2)
		
		local var_65_8 = DB("clan_worldboss", var_65_3, {
			"char_id"
		})
		local var_65_9 = DB("character", var_65_8, {
			"name"
		})
		
		var_65_3 = T(var_65_9)
		var_65_3, var_65_1 = var_65_1, var_65_3
	elseif var_65_0 == "ch_clan_lvup" then
		var_65_2 = T("msg_clan_history_clan_lvup")
	end
	
	local var_65_10 = T_KR(DB("clan_history", var_65_0, "text"), {
		value1 = var_65_1,
		value2 = var_65_2,
		value3 = var_65_3,
		value4 = var_65_4
	})
	local var_65_11 = 900
	local var_65_12 = cc.CSLoader:createNode("wnd/clan_node_text.csb")
	local var_65_13 = var_65_12:getChildByName("n_msg")
	local var_65_14 = var_65_10
	local var_65_15 = createRichLabel({
		color = cc.c4b(136, 136, 136, 255),
		outline_color = cc.c4b(26, 26, 26, 255)
	})
	
	var_65_15:setContentSize({
		height = 0,
		width = var_65_11
	})
	var_65_15:setAnchorPoint(0, 0)
	UIUtil:updateTextWrapMode(var_65_15, var_65_14, 20)
	
	local var_65_16 = 20
	local var_65_17 = 0.75
	
	var_65_15:setString(var_65_14)
	var_65_15:setScale(var_65_17)
	var_65_15:formatText()
	
	var_65_12.width = var_65_11
	
	var_65_13:addChild(var_65_15)
	
	local var_65_18 = var_65_13:getPositionY()
	local var_65_19 = var_65_15:getLineCount() * var_65_16 + 34
	
	if arg_65_3 then
		var_65_12:getChildByName("n_base"):setPositionY(arg_65_3 - 10)
	end
	
	if arg_65_4 == "war" then
		if_set_visible(var_65_12, "icon_menu", true)
		if_set_visible(var_65_12, "clan_rare", false)
		if_set_visible(var_65_12, "emblem", false)
		if_set_visible(var_65_12, "emblem_bg", false)
	elseif arg_65_4 == "history" then
		if_set_visible(var_65_12, "icon_menu", false)
		if_set_visible(var_65_12, "clan_rare", true)
		
		local var_65_20 = Clan:getClanInfo()
		
		UIUtil:updateClanEmblem(var_65_12, var_65_20)
	elseif arg_65_4 == "boss" then
		if_set_visible(var_65_12, "icon_menu", true)
		if_set_visible(var_65_12, "clan_rare", false)
		if_set_sprite(var_65_12, "icon_menu", "img/icon_menu_raid.png")
		if_set_visible(var_65_12, "emblem", false)
		if_set_visible(var_65_12, "emblem_bg", false)
	elseif arg_65_4 == "heritage" then
		if_set_visible(var_65_12, "icon_menu", true)
		if_set_visible(var_65_12, "clan_rare", false)
		if_set_sprite(var_65_12, "icon_menu", "img/icon_menu_heritage.png")
		if_set_visible(var_65_12, "emblem", false)
		if_set_visible(var_65_12, "emblem_bg", false)
	end
	
	var_65_12:setCascadeOpacityEnabled(true)
	
	local var_65_21 = sec_to_string(os.time() - arg_65_1.created)
	
	if_set(var_65_12, "txt_time", T("ui_clan_home_history_time_stamp", {
		time_value = var_65_21
	}))
	
	return var_65_12, var_65_19
end

function ClanHistory.updateClanWarHistory(arg_66_0, arg_66_1, arg_66_2)
	if_set_visible(arg_66_1, "icon_menu", true)
	if_set_visible(arg_66_1, "clan_rare", false)
	if_set(arg_66_1, "txt_time", "11")
end

function ClanWarResult.effect(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_1 and CACHE:getEffect("ui_clanpvp_result_victory") or CACHE:getEffect("ui_clanpvp_result_defeat")
	
	if not get_cocos_refid(var_67_0) then
		return 
	end
	
	local var_67_1 = arg_67_0.vars.wnd:getChildByName("n_eff")
	
	if arg_67_2 then
		var_67_1 = arg_67_0.vars.wnd:getChildByName("n_eff_move")
	end
	
	var_67_1:addChild(var_67_0)
	UIAction:Add(LOG(FADE_IN(500), 100), var_67_0, "block")
	var_67_0:start()
	SoundEngine:play(arg_67_1 and "event:/effect/ui_clanpvp_result_victory" or "event:/effect/ui_clanpvp_result_defeat")
end

function ClanWarResult.setupText(arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_1 and T("clan_war_win") or T("clan_war_defeat")
	
	if arg_68_2 == 1 then
		var_68_0 = T("clanwar_bye_msg")
	end
	
	if_set(arg_68_0.vars.wnd, "txt_disc", var_68_0)
end

function ClanWarResult.show(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_1.result
	local var_69_1 = arg_69_1.rtn_reward_datas.reward_count
	local var_69_2 = arg_69_1.rtn_reward_datas.defense_reward_count
	local var_69_3 = arg_69_1.rtn_reward_datas.match_failed_reward_id
	local var_69_4 = arg_69_1.rtn_reward_datas.match_failed_reward_count
	local var_69_5 = arg_69_1.mvp_user_info or {}
	local var_69_6 = var_69_0 ~= 0
	
	arg_69_0.vars = {}
	arg_69_0.vars.wnd = load_dlg("clan_war_result", true, "wnd", function()
		BackButtonManager:pop({
			id = "clan_war_result",
			dlg = arg_69_0.vars.wnd
		})
		ClanBattleList.ClanWar:enter_clan_war()
	end)
	
	if not arg_69_0.vars.wnd then
		return 
	end
	
	local var_69_7 = "to_ticketspecial"
	
	arg_69_0.vars.parent = SceneManager:getRunningNativeScene()
	
	arg_69_0.vars.parent:addChild(arg_69_0.vars.wnd)
	
	arg_69_0.vars.reward_count = var_69_1 - var_69_2
	arg_69_0.vars.defense_reward_count = var_69_2 or 0
	arg_69_0.vars.total_reward_count = var_69_1
	
	local var_69_8 = ((ClanWar:getPrevWarInfo() or {}).war_uid or 1) > 1
	
	if_set_visible(arg_69_0.vars.wnd, "btn_result_info", var_69_8)
	arg_69_0:effect(var_69_6, table.empty(var_69_5) or var_69_0 == 1)
	arg_69_0:setupReward(var_69_0, var_69_7, arg_69_0.vars.total_reward_count, var_69_3, var_69_4)
	arg_69_0:setupText(var_69_6, var_69_0)
	arg_69_0:setUI(var_69_0, var_69_5)
end

function ClanWarResult.setUI(arg_71_0, arg_71_1, arg_71_2)
	if arg_71_1 == 1 or table.empty(arg_71_2) then
		local var_71_0 = arg_71_0.vars.wnd:getChildByName("n_contents")
		local var_71_1 = arg_71_0.vars.wnd:getChildByName("n_contents_move")
		
		var_71_0:setPosition(var_71_1:getPosition())
		if_set_visible(arg_71_0.vars.wnd, "n_mvp_info", false)
	elseif not table.empty(arg_71_2) then
		local var_71_2 = arg_71_0.vars.wnd:getChildByName("n_mvp_info")
		
		if_set(var_71_2, "user_name", arg_71_2.name)
		
		local var_71_3 = var_71_2:getChildByName("n_card")
		
		if get_cocos_refid(var_71_3) then
			local var_71_4
			
			if arg_71_2.profile_card then
				local var_71_5 = arg_71_2.id == Account:getUserId()
				local var_71_6 = SAVE:getOptionData("option.profile_off", default_options.profile_off) == true
				
				if not var_71_5 and var_71_6 then
					var_71_4 = CustomProfileCard:create({
						is_default = true,
						leader_code = arg_71_2.leader_code,
						face_id = arg_71_2.face_id or 0
					})
				else
					var_71_4 = CustomProfileCard:create({
						card_data = arg_71_2.profile_card
					})
				end
			elseif arg_71_2.leader_code then
				var_71_4 = CustomProfileCard:create({
					is_default = true,
					leader_code = arg_71_2.leader_code,
					face_id = arg_71_2.face_id or 0
				})
			end
			
			if var_71_4 then
				local var_71_7 = var_71_4:getWnd()
				
				if get_cocos_refid(var_71_7) then
					var_71_3:addChild(var_71_7)
				end
			end
		end
		
		if_set_visible(var_71_2, nil, true)
	end
end

function ClanWarResult.setupReward(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5)
	if arg_72_1 and arg_72_1 == 1 and arg_72_4 and arg_72_5 > 0 then
		local var_72_0 = UIUtil:getRewardIcon(arg_72_3, arg_72_2)
		local var_72_1 = arg_72_0.vars.wnd:getChildByName("n_item_icon_1/2")
		
		if not var_72_0 or not var_72_1 then
			return 
		end
		
		var_72_1:addChild(var_72_0)
		
		local var_72_2 = UIUtil:getRewardIcon(arg_72_5, arg_72_4)
		local var_72_3 = arg_72_0.vars.wnd:getChildByName("n_item_icon_2/2")
		
		if not var_72_2 or not var_72_3 then
			return 
		end
		
		var_72_3:addChild(var_72_2)
		if_set_visible(arg_72_0.vars.wnd, "n_item_icon_1/2", true)
		if_set_visible(arg_72_0.vars.wnd, "n_item_icon_2/2", true)
		if_set_visible(arg_72_0.vars.wnd, "n_item_icon", false)
		if_set_visible(arg_72_0.vars.wnd, "n_mvp_info", false)
	else
		local var_72_4 = UIUtil:getRewardIcon(arg_72_3, arg_72_2)
		local var_72_5 = arg_72_0.vars.wnd:getChildByName("n_item_icon")
		
		if not var_72_4 or not var_72_5 then
			return 
		end
		
		var_72_5:addChild(var_72_4)
		if_set_visible(arg_72_0.vars.wnd, "n_item_icon_1/2", false)
		if_set_visible(arg_72_0.vars.wnd, "n_item_icon_2/2", false)
		if_set_visible(arg_72_0.vars.wnd, "n_item_icon", true)
	end
end

function ClanWarResult.query(arg_73_0)
	if not get_cocos_refid(arg_73_0.vars.record_wnd) then
		query("get_clan_war_member_result_record")
	else
		ClanWarResult:showRecord()
	end
end

function ClanWarResult.hideRecord(arg_74_0)
	if not get_cocos_refid(arg_74_0.vars.record_wnd) then
		return 
	end
	
	arg_74_0.vars.record_wnd:setVisible(false)
end

function ClanWarResult.showRecord(arg_75_0, arg_75_1)
	if get_cocos_refid(arg_75_0.vars.record_wnd) then
		arg_75_0.vars.record_wnd:setVisible(true)
		
		return 
	end
	
	arg_75_0.vars.record_infos = arg_75_1
	arg_75_0.vars.record_wnd = Dialog:open("wnd/clan_war_result_detail", arg_75_0)
	
	if not arg_75_0.vars.record_wnd then
		return 
	end
	
	if not arg_75_0.vars.parent then
		return 
	end
	
	if not ClanWar:getPrevWarInfo() then
		return 
	end
	
	local var_75_0 = arg_75_0.vars.record_wnd:getChildByName("btn_clan_info")
	
	if get_cocos_refid(var_75_0) and arg_75_0.vars.record_infos.enemy_clan_info then
		var_75_0.clan_id = arg_75_0.vars.record_infos.enemy_clan_info.clan_id
	end
	
	arg_75_0.vars.parent:addChild(arg_75_0.vars.record_wnd)
	
	arg_75_0.vars.isInitWarResult = false
	arg_75_0.vars.isInitRecords = false
	arg_75_0.vars.tab = 1
	
	if_set_visible(arg_75_0.vars.record_wnd, "ScrollView_defense", false)
	if_set_visible(arg_75_0.vars.record_wnd, "ScrollView_attack", false)
	arg_75_0:initListView()
	arg_75_0:selectTab(1)
end

function ClanWarResult.selectTab(arg_76_0, arg_76_1)
	if (arg_76_1 == 2 or arg_76_1 == 3) and Account:getCurrentWarUId() < 4 then
		balloon_message_with_sound("clanwar_notyet_msg")
		
		return 
	end
	
	arg_76_0.vars.tab = arg_76_1
	
	for iter_76_0 = 1, 3 do
		local var_76_0 = arg_76_0.vars.record_wnd:getChildByName("tab" .. iter_76_0)
		
		if not get_cocos_refid(var_76_0) then
			break
		end
		
		if_set_visible(var_76_0, "bg", arg_76_1 == iter_76_0)
	end
	
	arg_76_0:updateUI()
end

function ClanWarResult.updateUI(arg_77_0)
	if arg_77_0.vars.tab == 1 then
		if_set_visible(arg_77_0.vars.record_wnd, "listview", false)
		if_set_visible(arg_77_0.vars.record_wnd, "n_detail", true)
		
		if not arg_77_0.vars.isInitWarResult then
			arg_77_0:initWarResult(arg_77_0.vars.record_infos)
			
			arg_77_0.vars.isInitWarResult = true
		end
	elseif arg_77_0.vars.tab == 2 then
		if_set_visible(arg_77_0.vars.record_wnd, "listview", true)
		if_set_visible(arg_77_0.vars.record_wnd, "n_detail", false)
		
		if not arg_77_0.vars.isInitRecords then
			arg_77_0.vars.isInitRecords = true
			
			arg_77_0:req_recordes()
		else
			arg_77_0:_updateListviewItmes()
		end
	elseif arg_77_0.vars.tab == 3 then
		if_set_visible(arg_77_0.vars.record_wnd, "listview", true)
		if_set_visible(arg_77_0.vars.record_wnd, "n_detail", false)
		
		if not arg_77_0.vars.isInitRecords then
			arg_77_0.vars.isInitRecords = true
			
			arg_77_0:req_recordes()
		else
			arg_77_0:_updateListviewItmes()
		end
	end
end

function ClanWarResult._updateListviewItmes(arg_78_0)
	arg_78_0:_setSorting(arg_78_0.vars.records)
	arg_78_0.vars.listview:setItems(arg_78_0.vars.records)
	arg_78_0.vars.listview:refresh()
	arg_78_0.vars.listview:jumpToTop()
end

function ClanWarResult.initWarResult(arg_79_0, arg_79_1)
	local var_79_0 = arg_79_0.vars.record_wnd:getChildByName("n_clan1")
	
	UIUtil:updateClanInfo(var_79_0, Clan:getClanInfo())
	if_set(var_79_0, "clan_score", T("war_ui_0030", {
		value = comma_value(arg_79_1.clan_war_info.final_destroy_score)
	}))
	
	local var_79_1 = ClanWar:getPrevWarInfo()
	
	if var_79_1.final_result == 0 then
		if_set(arg_79_0.vars.record_wnd, "t_result", T("war_ui_0029"))
		if_set_sprite(arg_79_0.vars.record_wnd, "icon_result", "img/battle_pvp_icon_lose_clan.png")
	else
		if_set(arg_79_0.vars.record_wnd, "t_result", T("war_ui_0028"))
	end
	
	if arg_79_1.enemy_clan_info then
		local var_79_2 = arg_79_0.vars.record_wnd:getChildByName("n_clan2")
		
		var_79_2:setVisible(true)
		UIUtil:updateClanInfo(var_79_2, arg_79_1.enemy_clan_info)
		if_set_visible(arg_79_0.vars.record_wnd, "n_clan_nodata", false)
		if_set(var_79_2, "clan_score", T("war_ui_0030", {
			value = comma_value(arg_79_1.enemy_final_destroy_score or 0)
		}))
	else
		if_set_visible(arg_79_0.vars.record_wnd, "n_clan_nodata", true)
		arg_79_0.vars.record_wnd:getChildByName("n_clan2"):setVisible(false)
		
		local var_79_3 = arg_79_0.vars.record_wnd:getChildByName("n_clan_nodata")
		
		if var_79_1.final_result == 1 then
			if_set(var_79_3, "label", T("clan_war_chat_msg_004"))
		else
			if_set(var_79_3, "label", T("war_ui_0095"))
		end
	end
	
	local var_79_4 = "to_ticketspecial"
	
	UIUtil:getRewardIcon(arg_79_0.vars.reward_count, var_79_4, {
		parent = arg_79_0.vars.record_wnd:getChildByName("reward_item1")
	})
	UIUtil:getRewardIcon(arg_79_0.vars.defense_reward_count, var_79_4, {
		show_count = true,
		parent = arg_79_0.vars.record_wnd:getChildByName("reward_item2")
	})
	UIUtil:getRewardIcon(arg_79_0.vars.total_reward_count, var_79_4, {
		parent = arg_79_0.vars.record_wnd:getChildByName("reward_item_total")
	})
	
	local var_79_5 = DB("clan_war_rank_grade", tostring(arg_79_1.grade), {
		"grade_name"
	})
	
	if_set(arg_79_0.vars.record_wnd, "t_reward1", T(var_79_5))
	
	local var_79_6 = arg_79_1.member_record_info or {}
	local var_79_7 = arg_79_0.vars.record_wnd:getChildByName("n_attack_history")
	local var_79_8 = arg_79_0.vars.record_wnd:getChildByName("n_defence_history")
	local var_79_9 = var_79_6.attack_win_count or 0
	local var_79_10 = var_79_6.attack_draw_count or 0
	local var_79_11 = var_79_6.attack_defeat_count or 0
	
	if_set(var_79_7, "t_win_count", var_79_9)
	if_set(var_79_7, "t_draw_count", var_79_10)
	if_set(var_79_7, "t_defeat_count", var_79_11)
	if_set_opacity(var_79_7, "t_win", var_79_9 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "t_win_count", var_79_9 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "icon_win", var_79_9 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "t_draw", var_79_10 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "t_draw_count", var_79_10 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "icon_draw", var_79_10 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "t_defeat", var_79_11 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "t_defeat_count", var_79_11 == 0 and 76.5 or 255)
	if_set_opacity(var_79_7, "icon_defeat", var_79_11 == 0 and 76.5 or 255)
	
	local var_79_12 = var_79_6.defense_win_count or 0
	local var_79_13 = var_79_6.defense_draw_count or 0
	local var_79_14 = var_79_6.defense_defeat_count or 0
	
	if_set(var_79_8, "t_win_count", var_79_6.defense_win_count or 0)
	if_set(var_79_8, "t_draw_count", var_79_6.defense_draw_count or 0)
	if_set(var_79_8, "t_defeat_count", var_79_6.defense_defeat_count or 0)
	if_set_opacity(var_79_8, "t_win", var_79_12 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "t_win_count", var_79_12 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "icon_win", var_79_12 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "t_draw", var_79_13 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "t_draw_count", var_79_13 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "icon_draw", var_79_13 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "t_defeat", var_79_14 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "t_defeat_count", var_79_14 == 0 and 76.5 or 255)
	if_set_opacity(var_79_8, "icon_defeat", var_79_14 == 0 and 76.5 or 255)
	if_set(var_79_7, "t_win", T("war_ui_0097"))
	if_set(var_79_7, "t_draw", T("war_ui_0098"))
	if_set(var_79_7, "t_defeat", T("war_ui_0099"))
	if_set(var_79_8, "t_win", T("war_ui_0097"))
	if_set(var_79_8, "t_draw", T("war_ui_0098"))
	if_set(var_79_8, "t_defeat", T("war_ui_0099"))
end

function ClanWarResult.initListView(arg_80_0)
	arg_80_0.vars.listview = ItemListView:bindControl(arg_80_0.vars.record_wnd:getChildByName("listview"))
	
	local var_80_0 = {
		onUpdate = function(arg_81_0, arg_81_1, arg_81_2)
			local var_81_0 = arg_81_2.attack_win_count
			local var_81_1 = arg_81_2.attack_defeat_count
			local var_81_2 = arg_81_2.attack_draw_count
			local var_81_3 = T("clanwar_result_desc1", {
				value = arg_81_2.att_contribution or 0
			})
			
			if arg_80_0.vars.tab == 3 then
				var_81_0 = arg_81_2.defense_win_count
				var_81_1 = arg_81_2.defense_defeat_count
				var_81_2 = arg_81_2.defense_draw_count
				var_81_3 = T("clanwar_result_desc2", {
					value = arg_81_2.def_contribution or 0
				})
			end
			
			if_set(arg_81_1, "t_result_1", T("war_ui_0038", {
				value = var_81_0 or 0
			}))
			if_set(arg_81_1, "t_result_2", T("war_ui_0039", {
				value = var_81_1 or 0
			}))
			if_set(arg_81_1, "t_result_draw", T("war_ui_0059", {
				value = var_81_2 or 0
			}))
			if_set(arg_81_1, "t_point", var_81_3)
			if_set_opacity(arg_81_1, "t_result_1", var_81_0 == 0 and 76.5 or 255)
			if_set_opacity(arg_81_1, "icon_result_1", var_81_0 == 0 and 76.5 or 255)
			if_set_opacity(arg_81_1, "t_result_2", var_81_1 == 0 and 76.5 or 255)
			if_set_opacity(arg_81_1, "icon_result_2", var_81_1 == 0 and 76.5 or 255)
			if_set_opacity(arg_81_1, "t_result_draw", var_81_2 == 0 and 76.5 or 255)
			if_set_opacity(arg_81_1, "icon_result_draw", var_81_2 == 0 and 76.5 or 255)
			
			local var_81_4 = Clan:getMemberInfoById(arg_81_2.user_id) or {}
			local var_81_5 = var_81_4.user_info or {}
			local var_81_6 = UIUtil:numberDigitToCharOffset(var_81_5.level, 1, 0)
			
			UIUtil:warpping_setLevel(arg_81_1:getChildByName("n_lv"), var_81_5.level, MAX_ACCOUNT_LEVEL, 2, {
				offset_per_char = var_81_6
			})
			
			local var_81_7 = var_81_5.leader_code or "m0000"
			
			UIUtil:getRewardIcon(nil, var_81_7, {
				no_popup = true,
				character_type = "character",
				scale = 1,
				no_grade = true,
				parent = arg_81_1:getChildByName("mob_icon"),
				border_code = var_81_5.border_code
			})
			if_set(arg_81_1, "t_name", var_81_5.name or T("ui_clan_home_notice_unknown_member"))
			if_set_visible(arg_81_1, "master", var_81_4.grade == CLAN_GRADE.master)
			if_set_visible(arg_81_1, "sub_master", var_81_4.grade == CLAN_GRADE.executives)
			
			local var_81_8 = getChildByPath(arg_81_1, "n_item/txt_rank")
			local var_81_9 = arg_81_2.rank or 0
			
			if var_81_9 <= 3 then
				if_set_visible(arg_81_1, "n_toprank", true)
				if_set_visible(var_81_8, nil, false)
				if_set(arg_81_1, "txt_rank", T("war_ui_0071", {
					rank = var_81_9
				}))
			else
				if_set_visible(arg_81_1, "n_toprank", false)
				if_set_visible(var_81_8, nil, true)
				if_set(var_81_8, nil, T("war_ui_0071", {
					rank = var_81_9
				}))
			end
		end
	}
	
	arg_80_0.vars.listview:setRenderer(load_control("wnd/clan_war_result_detail_item.csb"), var_80_0)
end

function ClanWarResult.req_recordes(arg_82_0)
	arg_82_0.vars.records = {}
	
	ClanWar:query("get_clan_war_member_record_datas", function()
		local var_83_0 = ClanWar:getClanWarMemberRecords()
		
		if_set_visible(arg_82_0.vars.wnd, "n_no_data", false)
		arg_82_0:setRecordListItems(var_83_0)
		arg_82_0:updateUI()
	end)
end

function ClanWarResult.setRecordListItems(arg_84_0, arg_84_1)
	local var_84_0 = arg_84_1 or {}
	local var_84_1 = {}
	
	for iter_84_0, iter_84_1 in pairs(var_84_0) do
		table.insert(arg_84_0.vars.records, iter_84_1)
		
		var_84_1[iter_84_1.user_id] = true
	end
	
	local var_84_2 = Clan:getMembers()
	
	for iter_84_2, iter_84_3 in pairs(var_84_2) do
		if not var_84_1[iter_84_3.user_id] then
			local var_84_3 = {
				attack_win_count = 0,
				defense_defeat_count = 0,
				defense_draw_count = 0,
				defense_win_count = 0,
				attack_draw_count = 0,
				attack_defeat_count = 0,
				user_id = iter_84_3.user_id,
				grade = iter_84_3.grade,
				join_time = iter_84_3.join_time,
				att_contribution = iter_84_3.att_contribution or 0,
				def_contribution = iter_84_3.def_contribution or 0
			}
			
			table.insert(arg_84_0.vars.records, var_84_3)
		end
	end
end

function ClanWarResult._setSorting(arg_85_0, arg_85_1)
	local var_85_0 = arg_85_1 or {}
	
	local function var_85_1(arg_86_0, arg_86_1)
		if arg_86_0.grade == CLAN_GRADE.master then
			return true
		end
		
		if arg_86_1.grade == CLAN_GRADE.master then
			return false
		end
		
		if arg_86_1.grade == CLAN_GRADE.master and arg_86_0.grade == CLAN_GRADE.executives then
			return false
		end
		
		if arg_86_0.grade == CLAN_GRADE.master and arg_86_1.grade == CLAN_GRADE.executives then
			return true
		end
		
		if arg_86_0.grade == CLAN_GRADE.member and arg_86_1.grade == CLAN_GRADE.member then
			return arg_86_0.join_time > arg_86_1.join_time
		end
	end
	
	local function var_85_2(arg_87_0, arg_87_1)
		if not arg_87_0.att_contribution then
			return false
		end
		
		if not arg_87_1.att_contribution then
			return true
		end
		
		if arg_87_0.att_contribution == arg_87_1.att_contribution then
			return var_85_1(arg_87_0, arg_87_1)
		else
			return arg_87_0.att_contribution > arg_87_1.att_contribution
		end
	end
	
	local function var_85_3(arg_88_0, arg_88_1)
		if not arg_88_0.def_contribution then
			return false
		end
		
		if not arg_88_1.def_contribution then
			return true
		end
		
		if arg_88_0.def_contribution == arg_88_1.def_contribution then
			return var_85_1(arg_88_0, arg_88_1)
		else
			return arg_88_0.def_contribution > arg_88_1.def_contribution
		end
	end
	
	if arg_85_0.vars.tab == 2 then
		table.sort(var_85_0, var_85_2)
	else
		table.sort(var_85_0, var_85_3)
	end
	
	local var_85_4 = 1
	
	for iter_85_0, iter_85_1 in pairs(var_85_0) do
		iter_85_1.rank = var_85_4
		var_85_4 = var_85_4 + 1
	end
end
