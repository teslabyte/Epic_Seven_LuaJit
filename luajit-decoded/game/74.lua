ClanMissions = ClanMissions or {}

copy_functions(ConditionContents, ClanMissions)

function ClanMissions.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.CLAN_MISSION
end

function ClanMissions.initConditionListner(arg_2_0)
	arg_2_0:clear()
	
	local var_2_0 = Account:serverTimeWeekLocalDetail()
	local var_2_1 = Account:getClanMissions()
	
	for iter_2_0, iter_2_1 in pairs(var_2_1 or {}) do
		local var_2_2, var_2_3, var_2_4 = DB("clan_mission", iter_2_0, {
			"id",
			"condition",
			"value"
		})
		
		if var_2_2 and (iter_2_1.state == "active" or iter_2_1.state == 0) and tonumber(iter_2_1.week_id) == tonumber(var_2_0) and tonumber(iter_2_1.clan_id) == tonumber(Account:getClanId()) and var_2_3 and var_2_4 then
			arg_2_0:addConditionListner(iter_2_0, var_2_3, var_2_4)
		end
	end
end

function ClanMissions.addConditionListner(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0:getScore(arg_3_1)
	
	arg_3_0:removeGroup(arg_3_1)
	
	if arg_3_0:createGroupHandler(arg_3_1, arg_3_2, arg_3_3, var_3_0) then
	else
		print("ClanMissions : undefined condition class", arg_3_2, arg_3_1)
	end
end

function ClanMissions.update(arg_4_0, arg_4_1)
	Account:setClanMission(arg_4_1.contents_id, arg_4_1.clan_mission_doc)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.contents_id, nil, arg_4_1.clan_mission_doc.score1)
	
	if arg_4_1.clan_mission_doc.state >= 1 then
		arg_4_0:removeGroup(arg_4_1.contents_id)
	end
end

function ClanMissions.getScore(arg_5_0, arg_5_1)
	local var_5_0 = Account:getClanMissions()
	
	if var_5_0[arg_5_1] == nil then
		return 0
	end
	
	local var_5_1, var_5_2 = DB("clan_mission", arg_5_1, {
		"condition",
		"value"
	})
	
	return arg_5_0:getScore_datas(var_5_0, arg_5_1, var_5_1, var_5_2)
end

function ClanMissions.getConditionScore(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or 1
	
	local var_6_0 = Account:getClanMissions()
	
	return arg_6_0:getConditionScore_datas(var_6_0, arg_6_1, arg_6_2)
end

function ClanMissions.isCleared(arg_7_0, arg_7_1)
end

function ClanMissions.getNotifierControl(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.contents_id
	local var_8_1 = (Account:getClanMissions()[var_8_0] or {}).state or CLAN_WEEKLY_ACHIEVE_STATE.active
	local var_8_2
	
	if var_8_1 == CLAN_WEEKLY_ACHIEVE_STATE.active then
		local var_8_3, var_8_4 = DB("clan_mission", var_8_0, {
			"name",
			"desc"
		})
		
		var_8_2 = arg_8_0:createNotifyControl(#arg_8_1, var_8_3, var_8_4)
		
		local var_8_5 = {}
		
		table.insert(var_8_5, var_8_3)
		table.insert(var_8_5, var_8_4)
		
		var_8_2.args = var_8_5
		
		if var_8_2 then
			table.insert(arg_8_1, var_8_2)
		end
	end
	
	return var_8_2
end

function ClanMissions.createNotifyControl(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = Clan:getClanInfo()
	
	if not var_9_0 then
		return 
	end
	
	if not arg_9_2 or not arg_9_3 then
		return 
	end
	
	local var_9_1 = ClanUtil:getEmblemID(var_9_0)
	
	if not var_9_1 then
		return 
	end
	
	local var_9_2, var_9_3 = DB("clan_emblem", tostring(var_9_1), {
		"id",
		"emblem"
	})
	
	if not var_9_2 then
		return 
	end
	
	if not var_9_3 then
		return 
	end
	
	local var_9_4 = cc.CSLoader:createNode("wnd/achievement_complete_etc.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_9_4)
	var_9_4:setAnchorPoint(0, 0)
	var_9_4:setName("achivnoti_" .. arg_9_1)
	var_9_4:setGlobalZOrder(999999)
	var_9_4:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_9_4, T(arg_9_2), T(arg_9_3))
	if_set_visible(var_9_4, "spr_emblem", true)
	if_set_visible(var_9_4, "n_face", false)
	if_set_sprite(var_9_4, "spr_emblem", "emblem/" .. var_9_3 .. ".png")
	
	return var_9_4
end
