Clan = Clan or {}
CLAN_GRADE = {
	executives = 6,
	invitation = 4,
	leave = 1,
	reject = -1,
	none = 0,
	request = 3,
	refuse = 2,
	master = 7,
	member = 5
}
JPN_CLAN_WAR_OPEN_DAY = 732

function ErrHandler.clan_enter(arg_1_0, arg_1_1, arg_1_2)
	if Clan:noClanSendToLobby(arg_1_1) then
		return 
	end
end

function MsgHandler.clan_enter(arg_2_0)
	if not Clan.vars then
		Clan:create(arg_2_0)
	end
	
	Clan:updateCurrencies(arg_2_0)
	Clan:updateInfo(arg_2_0)
	ClanHome:setRandomMemberList(Clan:getMembers(), {
		show_balloon = true
	})
	
	if arg_2_0.prev_clan_war_doc then
		ClanWar:setPrevWarInfo(arg_2_0.prev_clan_war_doc)
	end
	
	Account:updateCurrencies(arg_2_0)
	TopBarNew:topbarUpdate(true)
	
	if arg_2_0.support_rewards then
		Account:setItem(arg_2_0.support_rewards.item_doc)
	end
	
	if arg_2_0.clan_mission_attrbutes then
		Account:resetConditonsByContentsType()
		Account:setClanMissions(arg_2_0.clan_mission_attrbutes)
	end
	
	local var_2_0 = Clan:getAttenInfo()
	
	if var_2_0 and not var_2_0.is_t_atten_checked then
		arg_2_0.is_attendance = true
	end
	
	ClanTag:setTagInfo(arg_2_0.tag_info)
	Clan:setNoti(arg_2_0)
	ClanBase:setVisible(true)
	Clan:setItems(arg_2_0.clan_items or {})
end

function MsgHandler.get_clan_members(arg_3_0)
	Clan:updateMembers(arg_3_0.members)
	ClanManagement:show()
end

function MsgHandler.get_clanwar_preview(arg_4_0)
	ClanInfo:show(arg_4_0, arg_4_0.mode)
end

function MsgHandler.get_request_clan_members(arg_5_0)
	Clan:updateRequestMembers(arg_5_0.members)
	ClanHome:updateRequestMemberNotiCount(Clan:getRequestMemberCount())
end

function MsgHandler.clan_promote(arg_6_0)
	Dialog:close("clan_promote_popup")
	Clan:updateCurrencies(arg_6_0)
	Clan:updateInfo(arg_6_0)
	balloon_message_with_sound_raw_text(T("clan_promote.chat_complete"))
end

ClanUtil = ClanUtil or {}

function ClanUtil.isMaxMemberCount(arg_7_0, arg_7_1)
	if arg_7_0:getMaxMemberCount(arg_7_1.level) <= arg_7_1.member_count then
		return true
	end
	
	return false
end

function ClanUtil.getMaxMemberCount(arg_8_0, arg_8_1)
	return DB("clan_level", tostring(arg_8_1), "max_member")
end

function ClanUtil.getEmblemID(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or {}
	
	if arg_9_2.var_name then
		return arg_9_1[arg_9_2.var_name] % 100000
	end
	
	if not arg_9_1.emblem then
		return GAME_STATIC_VARIABLE.emblem_default_id
	end
	
	return arg_9_1.emblem % 100000
end

function ClanUtil.getEmblemBGID(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or {}
	
	local var_10_0 = arg_10_1.emblem
	
	if arg_10_2.var_name then
		var_10_0 = arg_10_1[arg_10_2.var_name]
	end
	
	if var_10_0 <= 100000 then
		return GAME_STATIC_VARIABLE.emblem_bg_default_id
	end
	
	return (math.floor(var_10_0 / 100000))
end

function ClanUtil.getSpriteEmblemFilename(arg_11_0, arg_11_1)
	return (DB("clan_emblem", tostring(arg_11_1), "emblem") or "") .. ".png"
end

function ClanUtil.setSpriteEmblem(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0:getSpriteEmblemFilename(arg_12_2)
	
	if_set_sprite(arg_12_1, "emblem", "emblem/" .. var_12_0)
end

function ClanUtil.getWeekyMissionRewardableItemCnt(arg_13_0)
	if Account:getClanId() == nil then
		return 0
	end
	
	local var_13_0 = ClanWeeklyAchieve:getRewardDB()
	local var_13_1 = Clan:getWeekMissionPoint()
	local var_13_2 = Clan:getWeekMissionRewardPoint()
	local var_13_3 = 0
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		if var_13_2 < iter_13_1.point and var_13_1 >= iter_13_1.point then
			var_13_3 = var_13_3 + 1
		end
	end
	
	return var_13_3
end

function Clan.create(arg_14_0, arg_14_1)
	arg_14_0.vars = {}
	arg_14_0.token_info = {}
	arg_14_0.vars.member_donate = {}
	
	local var_14_0 = {
		"clangold",
		"clanbrave",
		"clanbossgold"
	}
	
	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		local var_14_1, var_14_2, var_14_3, var_14_4, var_14_5, var_14_6 = DB("item_clantoken", "ct_" .. iter_14_1, {
			"type",
			"name",
			"icon",
			"charge_type",
			"charge_value",
			"max"
		})
		local var_14_7 = {}
		
		if var_14_5 then
			local var_14_8 = string.split(var_14_5, ",")
			
			for iter_14_2, iter_14_3 in pairs(var_14_8) do
				local var_14_9 = string.split(iter_14_3, "=")
				
				if var_14_9[1] then
					var_14_7[var_14_9[1]] = var_14_9[2]
				end
			end
		end
		
		arg_14_0.token_info[iter_14_1] = {
			type = var_14_1,
			name = var_14_2,
			icon = var_14_3,
			charge_type = var_14_4,
			charge_value = var_14_5,
			max = var_14_6,
			charge_info = var_14_7
		}
	end
	
	arg_14_0:updateCurrencies(arg_14_1)
	arg_14_0:setItems((arg_14_1 or {}).clan_items)
	arg_14_0:updateInfo(arg_14_1)
	ClanWar:init()
end

function Clan.setNoti(arg_15_0, arg_15_1)
	arg_15_0.vars.noti = {}
	
	if arg_15_1.support_rewards then
		arg_15_0.vars.noti.support_rewards = arg_15_1.support_rewards
	end
	
	if arg_15_1.is_attendance then
		arg_15_0.vars.noti.is_attendance = true
	end
	
	if arg_15_1.member_info and arg_15_1.member_info.is_change_grade then
		arg_15_0.vars.noti.is_change_grade = true
	end
	
	ClanHome:createSeq(arg_15_0)
end

function Clan.getNoti(arg_16_0)
	return arg_16_0.vars.noti
end

function Clan.isAttenChecked(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if not arg_17_0.vars.atten_info then
		return 
	end
	
	return arg_17_0.vars.atten_info.is_t_atten_checked
end

function Clan.clear(arg_18_0)
	arg_18_0.vars = {}
end

function Clan.testMode(arg_19_0, arg_19_1)
	arg_19_0.test_mode = arg_19_1
	
	if not arg_19_1 then
		arg_19_0.test_random_model = nil
	else
		arg_19_0.test_random_model = {
			{
				user_info = {
					leader_code = "c1001"
				}
			},
			{
				user_info = {
					leader_code = "moragora_player_f_p"
				}
			},
			{
				user_info = {
					leader_code = "c1003"
				}
			},
			{
				user_info = {
					leader_code = "c1004"
				}
			},
			{
				user_info = {
					leader_code = "c1005"
				}
			},
			{
				user_info = {
					leader_code = "c1006"
				}
			},
			{
				user_info = {
					leader_code = "c1007"
				}
			},
			{
				user_info = {
					leader_code = "c1008"
				}
			}
		}
	end
end

function Clan.testRandomModel(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or {}
	
	local var_20_0 = arg_20_0.test_random_model
	
	if arg_20_1.code and arg_20_1.index then
		var_20_0[arg_20_1.index].user_info.leader_code = arg_20_1.code
		
		if arg_20_1.scale then
			var_20_0[arg_20_1.index].scale = arg_20_1.scale
		end
	end
	
	arg_20_0.test_random_model = var_20_0
end

function Clan.getTestRandomModel(arg_21_0)
	return arg_21_0.test_random_model
end

function Clan.updateMembers(arg_22_0, arg_22_1)
	if not arg_22_0.vars then
		return 
	end
	
	arg_22_0.vars.members = arg_22_1
	
	arg_22_0:updateClanMaster()
	ClanBase:updateClanInfoUI()
end

function Clan.isNoDatas(arg_23_0)
	local var_23_0 = Clan:getMembers()
	
	if not var_23_0 or table.count(var_23_0) <= 0 then
		return true
	end
	
	return false
end

function Clan.updateMember(arg_24_0, arg_24_1)
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.members or {}) do
		if iter_24_1.user_id == arg_24_1.user_id then
			for iter_24_2, iter_24_3 in pairs(arg_24_1) do
				arg_24_0.vars.members[iter_24_0][iter_24_2] = arg_24_1[iter_24_2]
			end
		end
	end
end

function Clan.updateClanMaster(arg_25_0)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.members) do
		if iter_25_1.grade == CLAN_GRADE.master then
			arg_25_0.vars.clan_master = iter_25_1
		end
	end
end

function Clan.updateWorldbossCount(arg_26_0, arg_26_1)
	arg_26_0.vars.worldboss_play_info = arg_26_1
end

function Clan.updateStampValue(arg_27_0, arg_27_1)
	arg_27_0.vars.stamp_value = arg_27_1
end

function Clan.getStampValue(arg_28_0)
	return arg_28_0.vars.stamp_value
end

function Clan.getWorldbossEnterable(arg_29_0)
	if not arg_29_0.vars.worldboss_play_info or not arg_29_0.vars.worldboss_play_info.count or not arg_29_0.vars.worldboss_play_info.max_count then
		return false
	end
	
	if arg_29_0.vars.worldboss_play_info.count < arg_29_0.vars.worldboss_play_info.max_count then
		return true
	end
	
	return false
end

function Clan.updateTagetMember(arg_30_0, arg_30_1)
	if not arg_30_0.vars then
		return 
	end
	
	if not arg_30_0.vars.members then
		return 
	end
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.members) do
		if iter_30_1.user_id == arg_30_1.user_id then
			arg_30_0.vars.members[iter_30_0] = arg_30_1
		end
	end
	
	if ClanManagement:isShow() then
		ClanMembersManagement:updateMemberInfo(arg_30_1)
	end
	
	ClanBase:updateClanInfoUI()
end

function Clan.getMembers(arg_31_0)
	return arg_31_0.vars.members or {}
end

function Clan.updateInfo(arg_32_0, arg_32_1)
	if not arg_32_1 then
		return 
	end
	
	if arg_32_1.clan_info then
		arg_32_0:setClanInfo(arg_32_1.clan_info)
	end
	
	if arg_32_1.atten_info then
		arg_32_0.vars.atten_info = arg_32_1.atten_info
	end
	
	if arg_32_1.member_info then
		arg_32_0:updateClanUserInfo(arg_32_1.member_info)
	end
	
	if arg_32_1.contribution_info then
		arg_32_0:updateMemberDonateInfo(arg_32_1.donate_id, arg_32_1.contribution_info)
	end
	
	if arg_32_1.members then
		Clan:updateMembers(arg_32_1.members)
	end
	
	if arg_32_1.target_member_info then
		arg_32_0:updateTagetMember(arg_32_1.target_member_info)
	end
	
	if arg_32_1.worldboss_play_info then
		arg_32_0:updateWorldbossCount(arg_32_1.worldboss_play_info)
	end
	
	if arg_32_1.no_reward_db then
		arg_32_0:updateStampValue(arg_32_1.no_reward_db)
	end
	
	if arg_32_1.old_master_info then
		arg_32_0:updateTagetMember(arg_32_1.old_master_info)
		arg_32_0:updateClanUserInfo(arg_32_1.old_master_info)
		arg_32_0:updateClanMaster()
		ClanManagement:updateMembers()
	end
	
	ClanBase:updateClanInfoUI()
	ClanBase:updateAttenInfoUI()
	ClanManagement:updateUI()
	ClanHome:updateRequestMemberNotiCount(Clan:getRequestMemberCount())
	ClanCategory:updateScrollView()
	
	if arg_32_1.donate_id then
		ClanDonate:updateUI()
	end
end

function Clan.getMemberDonateInfo(arg_33_0, arg_33_1)
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.member_donate) do
		if iter_33_1.item_code == arg_33_1 then
			return iter_33_1
		end
	end
end

function Clan.getMemberDonateCount(arg_34_0, arg_34_1)
	for iter_34_0, iter_34_1 in pairs(arg_34_0.vars.member_donate) do
		if iter_34_1.item_code == arg_34_1 then
			return iter_34_1.count
		end
	end
	
	return 0
end

function Clan.updateMemberDonateInfo(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_1 then
		arg_35_0.vars.member_donate = arg_35_2
	else
		local var_35_0 = false
		
		for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.member_donate) do
			if iter_35_1.item_code == arg_35_1 then
				var_35_0 = true
				arg_35_0.vars.member_donate[iter_35_0] = arg_35_2
				
				return 
			end
		end
		
		if not var_35_0 then
			table.insert(arg_35_0.vars.member_donate, arg_35_2)
		end
	end
end

function Clan.getUserMemberInfo(arg_36_0)
	if not arg_36_0.vars then
		return nil
	end
	
	return arg_36_0.vars.clan_user_info
end

function Clan.getUserMemberInfoGradeLimitsRemainTime(arg_37_0, arg_37_1)
	if not arg_37_0.vars then
		return 
	end
	
	if not arg_37_0.vars.clan_user_info then
		return 
	end
	
	if not arg_37_0.vars.clan_user_info.limits then
		return 
	end
	
	return arg_37_0.vars.clan_user_info.limits["gr:" .. arg_37_1]
end

function Clan.updateClanUserInfo(arg_38_0, arg_38_1)
	arg_38_0.vars.clan_user_info = arg_38_1
	
	arg_38_0:updateMember(arg_38_1)
end

function Clan.isMaster(arg_39_0, arg_39_1)
	if not arg_39_0.vars or not arg_39_0.vars.clan_user_info then
		return nil
	end
	
	if not Account:getClanId() then
		return nil
	end
	
	if arg_39_1 then
		return arg_39_0.vars.clan_master.user_id == arg_39_1
	else
		return arg_39_0.vars.clan_user_info.grade == CLAN_GRADE.master
	end
	
	return false
end

function Clan.isClanWarEditableGrade(arg_40_0, arg_40_1)
	if not arg_40_0.vars or not arg_40_0.vars.clan_user_info then
		return false
	end
	
	if not Account:getClanId() then
		return false
	end
	
	local var_40_0 = false
	
	if arg_40_1 then
		local var_40_1 = Clan:getMemberInfoById(arg_40_1)
		
		if var_40_1 then
			var_40_0 = arg_40_0:isExecutAbleGrade(var_40_1.grade, "clan_war_notice")
		end
	else
		var_40_0 = arg_40_0:isExecutAbleGrade(arg_40_0.vars.clan_user_info.grade, "clan_war_notice")
	end
	
	return var_40_0
end

function Clan.getMemberGrade(arg_41_0)
	if not arg_41_0.vars or not arg_41_0.vars.clan_user_info then
		return 
	end
	
	return arg_41_0.vars.clan_user_info.grade
end

function Clan.getMemberInfoById(arg_42_0, arg_42_1)
	for iter_42_0, iter_42_1 in pairs(arg_42_0.vars.members) do
		if tonumber(iter_42_1.user_id) == tonumber(arg_42_1) then
			return iter_42_1
		end
	end
end

function Clan.getMaxClanMember(arg_43_0)
	local var_43_0 = arg_43_0:getClanInfo()
	
	return (DB("clan_level", tostring(var_43_0.level), "max_member"))
end

function Clan.isExecutAbleGrade(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	arg_44_3 = arg_44_3 or {}
	
	local var_44_0 = 3
	
	if arg_44_1 == CLAN_GRADE.master then
		var_44_0 = 1
	end
	
	if arg_44_1 == CLAN_GRADE.executives then
		var_44_0 = 2
	end
	
	local var_44_1
	local var_44_2 = DB("clan_member_grade", tostring(var_44_0), arg_44_2)
	
	if var_44_2 == "y" then
		var_44_1 = nil
	elseif var_44_2 == nil then
		return nil
	end
	
	if var_44_2 and string.starts(var_44_2, "time") then
		local var_44_3 = string.split(var_44_2, "=")
		
		if tonumber(var_44_3[2]) == 0 then
			var_44_1 = nil
		elseif arg_44_3.remain_time == nil then
			var_44_1 = nil
		elseif type(arg_44_3.remain_time) == "table" then
			var_44_1 = 0
			
			for iter_44_0, iter_44_1 in pairs(arg_44_3.remain_time) do
				if iter_44_1 > os.time() then
					var_44_1 = iter_44_1 - os.time()
					
					break
				end
			end
		end
	end
	
	return (var_44_1 or 0) <= 0, var_44_1
end

function Clan.queryInvite(arg_45_0, arg_45_1)
	local var_45_0 = Clan:getUserMemberInfo()
	local var_45_1 = false
	
	if var_45_0 and arg_45_1 then
		local var_45_2, var_45_3 = Clan:isExecutAbleGrade(var_45_0.grade, "clan_invite", {
			remain_time = Clan:getUserMemberInfoGradeLimitsRemainTime("clan_invite")
		})
		
		if var_45_2 then
			Friend:setInviteErrText("already_clan_invitation")
			query("clan_invite", {
				clan_id = var_45_0.clan_id,
				target_user_id = arg_45_1
			})
			
			var_45_1 = true
		else
			if var_45_3 then
				balloon_message_with_sound("clan_no_excutable_limit_time")
			else
				balloon_message_with_sound("msg_cannot_clan_invite")
			end
			
			return 
		end
	end
	
	return var_45_1
end

function Clan.getClanMaster(arg_46_0)
	return arg_46_0.vars.clan_master
end

function Clan.updateRequestMembers(arg_47_0, arg_47_1)
	arg_47_0.vars.request_members = arg_47_1
	
	ClanManagement:updateRequestMembers()
	ClanBase:updateRequestMemberNotiCount(#arg_47_1)
end

function Clan.removeRequestMembers(arg_48_0, arg_48_1)
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.request_members) do
		if tonumber(iter_48_1.user_id) == tonumber(arg_48_1) then
			table.remove(arg_48_0.vars.request_members, iter_48_0)
			
			break
		end
	end
	
	ClanManagement:updateRequestMembers()
	ClanBase:updateClanInfoUI()
end

function Clan.insertMembers(arg_49_0, arg_49_1)
	table.insert(arg_49_0.vars.members, arg_49_1)
	ClanManagement:updateMembers()
	ClanBase:updateClanInfoUI()
end

function Clan.removeMembers(arg_50_0, arg_50_1)
	for iter_50_0, iter_50_1 in pairs(arg_50_0.vars.members) do
		if iter_50_1.user_id == arg_50_1 then
			table.remove(arg_50_0.vars.members, iter_50_0)
			
			break
		end
	end
	
	ClanManagement:updateMembers()
	ClanBase:updateClanInfoUI()
end

function Clan.getRequestMemberCount(arg_51_0)
	return #(arg_51_0.vars.request_members or {})
end

function Clan.getRequestMembers(arg_52_0)
	return arg_52_0.vars.request_members or {}
end

function Clan.setClanInfo(arg_53_0, arg_53_1)
	if not arg_53_0.vars then
		return 
	end
	
	arg_53_0.vars.clan_info = arg_53_1
end

function Clan.getClanInfo(arg_54_0)
	if not arg_54_0.vars then
		return nil
	end
	
	return arg_54_0.vars.clan_info
end

function Clan.getWeekMissionPoint(arg_55_0)
	if not arg_55_0.vars then
		return 0
	end
	
	if not arg_55_0.vars.clan_info then
		return 0
	end
	
	return arg_55_0.vars.clan_info.week_mission_point or 0
end

function Clan.getWeekMissionPrevPoint(arg_56_0)
	if not arg_56_0.vars then
		return 0
	end
	
	if not arg_56_0.vars.clan_info then
		return 0
	end
	
	local var_56_0 = Account:serverTimeWeekLocalDetail()
	
	if arg_56_0.vars.clan_info.week_id == var_56_0 - 1 then
		return arg_56_0.vars.clan_info.week_mission_point or 0
	elseif arg_56_0.vars.clan_info.week_id ~= var_56_0 then
		return 0
	end
	
	return arg_56_0.vars.clan_info.prev_week_mission_point or 0
end

function Clan.getWeekMissionRewardPoint(arg_57_0)
	local var_57_0 = Account:getClanWeekMissionRewardInfo()
	
	if not var_57_0 then
		return 0
	end
	
	local var_57_1 = Account:serverTimeWeekLocalDetail()
	
	if var_57_0.week_id ~= var_57_1 then
		return 0
	end
	
	return var_57_0.point or 0
end

function Clan.getWeekMissionRewardPrevPoint(arg_58_0)
	local var_58_0 = Account:getClanWeekMissionRewardInfo()
	
	if not var_58_0 then
		return 0
	end
	
	local var_58_1 = Account:serverTimeWeekLocalDetail()
	
	if var_58_0.week_id == var_58_1 - 1 then
		return var_58_0.point or 0
	elseif var_58_0.week_id ~= var_58_1 then
		return 0
	end
	
	return var_58_0.prev_point or 0
end

function Clan.isRewardablePrevClanWeeklyMission(arg_59_0)
	local var_59_0 = Clan:getWeekMissionPrevPoint()
	local var_59_1 = Clan:getWeekMissionRewardPrevPoint()
	local var_59_2 = Clan:getUserMemberInfo()
	
	if not var_59_2 then
		return false, 1
	end
	
	local var_59_3 = var_59_2.join_time
	local var_59_4, var_59_5, var_59_6 = Account:serverTimeWeekLocalDetail()
	local var_59_7, var_59_8, var_59_9 = Account:serverTimeWeekLocalDetail(var_59_3)
	
	if var_59_4 == var_59_7 then
		return false, 2
	end
	
	if var_59_1 < var_59_0 then
		local var_59_10 = ClanWeeklyAchieve:getRewardDB()
		
		for iter_59_0, iter_59_1 in pairs(var_59_10) do
			if var_59_1 < iter_59_1.point and var_59_0 >= iter_59_1.point then
				return true
			end
		end
	end
	
	return false, 3
end

function Clan.getClanNotice(arg_60_0)
	if not arg_60_0.vars then
		return nil
	end
	
	if not arg_60_0.vars.clan_info then
		return nil
	end
	
	return arg_60_0.vars.clan_info.notice_msg or T("input_default_msg_clan_notice")
end

function Clan.getClanWarNotice(arg_61_0)
	if not arg_61_0.vars then
		return nil
	end
	
	if not arg_61_0.vars.clan_info then
		return nil
	end
	
	return arg_61_0.vars.clan_info.war_notice_msg or T("clanwar_notice_msg")
end

function Clan.getNoticeOnlyText(arg_62_0)
	local var_62_0 = Clan:getClanNotice()
	local var_62_1 = "@^ye%"
	
	return string.split(var_62_0, var_62_1)[1]
end

function Clan.getWarNoticeOnlyText(arg_63_0)
	local var_63_0 = Clan:getClanWarNotice()
	local var_63_1 = "@^ye%"
	
	return string.split(var_63_0, var_63_1)[1]
end

function Clan.getAttenInfo(arg_64_0)
	return arg_64_0.vars.atten_info
end

function Clan.onPushBack(arg_65_0)
	if ClanHistory:isShow() then
		ClanHistory:close()
	else
		SceneManager:popScene()
		BackButtonManager:pop("TopBarNew." .. T("clan_title"))
	end
end

function Clan.getClanInfoLimits(arg_66_0)
	return arg_66_0.vars.clan_info.limits
end

function Clan.resetTeams(arg_67_0)
	local var_67_0
	
	for iter_67_0 = 13, 16 do
		local var_67_1 = Account:getTeam(iter_67_0)
		
		if var_67_1 and table.count(var_67_1) > 0 then
			Account:resetTeam(iter_67_0)
			
			var_67_0 = true
		end
	end
	
	if var_67_0 then
		Account:saveTeamInfo()
		balloon_message_with_sound("war_err_msg006")
	end
end

function Clan.updateCurrencies(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_1 then
		return 
	end
	
	local var_68_0 = {}
	local var_68_1 = {
		"clangold",
		"clanbrave",
		"clanbossgold"
	}
	local var_68_2
	
	if type(arg_68_1.clan_currency) == "table" then
		var_68_2 = arg_68_1.clan_currency
	else
		var_68_2 = arg_68_1
	end
	
	for iter_68_0, iter_68_1 in ipairs(var_68_1) do
		local var_68_3 = tonumber(var_68_2[iter_68_1]) or tonumber(var_68_2["ct_" .. iter_68_1])
		
		if var_68_3 then
			local var_68_4 = var_68_3 - arg_68_0:getCurrency(iter_68_1)
			
			if var_68_4 ~= 0 then
				var_68_0[iter_68_1] = var_68_4
			end
			
			arg_68_0:setCurrency(iter_68_1, var_68_3, arg_68_2)
		end
	end
	
	local var_68_5
	
	if type(arg_68_1.clan_currency_time) == "table" then
		var_68_5 = arg_68_1.clan_currency_time
		
		for iter_68_2, iter_68_3 in ipairs(var_68_1) do
			local var_68_6 = var_68_5[iter_68_3]
			
			if var_68_6 then
				arg_68_0:setCurrencyTime(iter_68_3, var_68_6)
			end
		end
	end
	
	return var_68_0
end

function Clan.getCurrencyData(arg_69_0)
	return arg_69_0.currency or {}
end

function Clan.setCurrencyData(arg_70_0, arg_70_1)
	if not arg_70_0.currency then
		arg_70_0.currency = {}
	end
	
	for iter_70_0, iter_70_1 in pairs(arg_70_1) do
		if not arg_70_0.currency[iter_70_0] then
			local var_70_0 = 0
		end
		
		arg_70_0.currency[iter_70_0] = iter_70_1
	end
end

function Clan.getCurrency(arg_71_0, arg_71_1)
	return arg_71_0:_getCurrency(arg_71_1)
end

function Clan.setCurrency(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
	arg_72_3 = arg_72_3 or {}
	arg_72_0.currency = arg_72_0.currency or {}
	
	if not arg_72_0.currency[arg_72_1] then
		local var_72_0 = 0
	end
	
	arg_72_0.currency[arg_72_1] = tonumber(arg_72_2) or 0
end

function Clan.addCurrency(arg_73_0, arg_73_1, arg_73_2)
	arg_73_0.currency = arg_73_0.currency or {}
	arg_73_0.currency[arg_73_1] = (arg_73_0.currency[arg_73_1] or 0) + (tonumber(arg_73_2) or 0)
end

function Clan.getCurrencyMax(arg_74_0, arg_74_1)
	if arg_74_0.token_info[arg_74_1] then
		return tonumber(arg_74_0.token_info[arg_74_1].max)
	end
end

function Clan.getLimitCount(arg_75_0, arg_75_1)
	if not arg_75_0.vars.clan_info.limits[arg_75_1] then
		return 0
	end
	
	local var_75_0 = 0
	local var_75_1 = os.time()
	
	for iter_75_0, iter_75_1 in pairs(arg_75_0.vars.clan_info.limits[arg_75_1]) do
		if var_75_1 <= iter_75_1 then
			var_75_0 = var_75_0 + 1
		end
	end
	
	return var_75_0
end

function Clan.updateLimits(arg_76_0, arg_76_1)
	for iter_76_0, iter_76_1 in pairs(arg_76_1) do
		arg_76_0.vars.clan_info.limits[iter_76_0] = iter_76_1
	end
end

function Clan._getCurrency(arg_77_0, arg_77_1)
	if string.starts(arg_77_1, "ct_") then
		arg_77_1 = string.sub(arg_77_1, 4, -1)
	end
	
	local var_77_0 = tonumber((arg_77_0.currency or {})[arg_77_1]) or 0
	local var_77_1 = arg_77_0:getCurrencyMax(arg_77_1) or 0
	local var_77_2 = arg_77_0.token_info[arg_77_1] or {}
	local var_77_3 = var_77_2.charge_type
	
	return (Account:calcCurrency(arg_77_1, var_77_0, var_77_1, var_77_2, var_77_3))
end

function Clan.setItems(arg_78_0, arg_78_1)
	arg_78_0.items = arg_78_1
end

function Clan.setItem(arg_79_0, arg_79_1, arg_79_2)
	arg_79_2 = arg_79_2 or {}
	
	local var_79_0 = arg_79_0.items[arg_79_1.code] or 0
	
	arg_79_0.items[arg_79_1.code] = arg_79_1.c
	
	return arg_79_1.c - var_79_0
end

function Clan.setItemCount(arg_80_0, arg_80_1, arg_80_2, arg_80_3)
	return arg_80_0:setItem({
		code = arg_80_1,
		c = arg_80_2
	}, arg_80_3)
end

function Clan.getItems(arg_81_0)
	return arg_81_0.items or {}
end

function Clan.getItemCount(arg_82_0, arg_82_1)
	local var_82_0 = Clan:getItems()[arg_82_1]
	
	if var_82_0 == nil then
		return 0
	end
	
	return var_82_0
end

function Clan.getAddCalcValue(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = os.time()
	local var_83_1 = Account:getClanBuffs()
	local var_83_2 = 0
	
	for iter_83_0, iter_83_1 in pairs(var_83_1) do
		if var_83_0 < iter_83_1.expire_time then
			local var_83_3 = AccountSkill:getSkillDB(iter_83_1.skill_id)
			
			if var_83_3 and var_83_3.effect_type == arg_83_1 then
				if var_83_3.calc_type == "multiply" then
					var_83_2 = var_83_2 + arg_83_2 * var_83_3.value
				elseif var_83_3.calc_type == "sum" then
					var_83_2 = var_83_2 + var_83_3.value
				end
			end
		end
	end
	
	return (math.floor(var_83_2))
end

function Clan.noClanSendToLobby(arg_84_0, arg_84_1)
	if string.ends(arg_84_1, "no_clan") then
		Dialog:msgBox(T("get_clan_info.no_clan"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end
		})
		
		return true
	end
end

function Clan.queryPreview(arg_86_0, arg_86_1, arg_86_2)
	if not arg_86_1 then
		return 
	end
	
	query("get_clanwar_preview", {
		clan_id = arg_86_1,
		mode = arg_86_2
	})
end

function Clan.isLeavePanelty(arg_87_0)
	local var_87_0 = false
	local var_87_1 = Account:getClanLeavePenalty() or 0
	local var_87_2 = Account:getClanLeaveTime()
	local var_87_3 = 0
	
	if var_87_2 then
		local var_87_4 = var_87_2 + var_87_1 * 24 * 60 * 60
		
		var_87_3 = var_87_4 - os.time()
		
		if var_87_4 - os.time() > 0 then
			var_87_0 = true
		end
	end
	
	return var_87_0, var_87_3
end

function Clan.getRemainPromoteCount(arg_88_0)
	local var_88_0 = 0
	local var_88_1 = os.time()
	local var_88_2 = arg_88_0:getClanInfo()
	
	if not var_88_2 then
		return 
	end
	
	local var_88_3 = arg_88_0:getClanInfoLimits() or {}
	local var_88_4 = GAME_CONTENT_VARIABLE.clan_prchat_daily_limit
	
	for iter_88_0, iter_88_1 in pairs(var_88_3.promote or {}) do
		if var_88_1 <= iter_88_1 then
			var_88_0 = var_88_0 + 1
		else
			var_88_2.limits.promote[iter_88_0] = nil
		end
	end
	
	return var_88_4 - var_88_0
end
