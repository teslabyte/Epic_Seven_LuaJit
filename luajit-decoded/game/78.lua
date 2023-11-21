Achievement = Achievement or {}

copy_functions(ConditionContents, Achievement)

function Achievement.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.ACHIEVEMENT
end

function Achievement.dispatch(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.events_map or not arg_2_0.events_map[arg_2_1] then
		return 
	end
	
	local var_2_0 = arg_2_0.events_map[arg_2_1]
	
	for iter_2_0 = #var_2_0, 1, -1 do
		var_2_0[iter_2_0]:onEvent(arg_2_1, arg_2_2)
	end
	
	if string.starts(arg_2_1, "battle") then
		return 
	end
	
	if not arg_2_0.ignore_check_update then
		ConditionContentsManager:queryUpdateConditions(arg_2_1 .. ":" .. SceneManager:getCurrentSceneName())
	end
end

function Achievement.initConditionListner(arg_3_0)
	arg_3_0:clear()
	
	if not UnlockSystem:isUnlockAchievementSystem() then
		return 
	end
	
	local var_3_0 = AchievementBase:loadFactioList()
	
	for iter_3_0, iter_3_1 in pairs(var_3_0 or {}) do
		local var_3_1 = iter_3_1.id
		
		if var_3_1 == SICA_FACTION_ID then
			arg_3_0:initSicaConditionListner()
		else
			local var_3_2 = iter_3_1.groups
			local var_3_3 = AchievementUtil:getAchieveRowMax()
			
			for iter_3_2 = 1, var_3_3 do
				local var_3_4 = iter_3_2
				
				if var_3_1 == "sisters" then
					var_3_4 = iter_3_2 + 100
				end
				
				arg_3_0:addConditionListner(var_3_1, string.format("%s_%03d", var_3_1, var_3_4))
			end
		end
	end
end

function Achievement.initSicaConditionListner(arg_4_0)
	for iter_4_0 = 1, 999 do
		local var_4_0, var_4_1 = DBN("achievement_honor_category", iter_4_0, {
			"id",
			"jpn_hide"
		})
		
		if not var_4_0 then
			break
		end
		
		local var_4_2 = UnlockSystem:isUnlockSystem(UNLOCK_ID.SICA)
		
		if var_4_1 and Account:isJPN() then
			var_4_2 = false
		end
		
		if var_4_2 then
			local var_4_3 = AchievementUtil:getAchieveRowMax()
			
			for iter_4_1 = 1, var_4_3 do
				local var_4_4 = string.format("%s_%03d", var_4_0, iter_4_1)
				local var_4_5 = var_4_4 .. "_01"
				local var_4_6 = DBT("achievement", var_4_5, {
					"id",
					"condition",
					"value",
					"jpn_hide"
				})
				
				if not var_4_6 then
					return 
				end
				
				if not var_4_6.id then
					break
				end
				
				if var_4_6.condition and var_4_6.value and (var_4_6.jpn_hide == nil or not Account:isJPN()) then
					arg_4_0:addSicaConditionListner(SICA_FACTION_ID, var_4_4, var_4_6.condition, var_4_6.value)
				end
			end
		end
	end
end

function Achievement.addSicaConditionListner(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = Account:getFactionGroups(arg_5_1)[arg_5_2] or {}
	
	if not var_5_0.lv then
		local var_5_1 = 1
	end
	
	local var_5_2 = arg_5_0:getScore(arg_5_2)
	local var_5_3 = var_5_0.state or 0
	
	if arg_5_3 and arg_5_4 and var_5_3 == 0 then
		arg_5_0:removeGroup(arg_5_2)
		
		local var_5_4 = arg_5_0:createGroupHandler(arg_5_2, arg_5_3, arg_5_4, var_5_2)
		
		if var_5_4 then
			var_5_4.faction_id = arg_5_1
		else
			print("Achievement : undefined condition class", arg_5_3, acheivement_id)
		end
	end
end

function Achievement.addConditionListner(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Account:getFactionGroups(arg_6_1)[arg_6_2] or {}
	local var_6_1 = var_6_0.lv or 1
	local var_6_2 = arg_6_0:getScore(arg_6_2)
	local var_6_3 = var_6_0.state or 0
	local var_6_4 = string.format("%s_%02d", arg_6_2, var_6_1)
	local var_6_5, var_6_6, var_6_7, var_6_8, var_6_9, var_6_10 = DB("achievement", var_6_4, {
		"condition",
		"value",
		"hide",
		"hold",
		"jpn_hide",
		"reset_time"
	})
	local var_6_11 = Account:isJPN() and var_6_9 == "y"
	local var_6_12 = false
	
	if var_6_10 and FactionDetailPoint:isMaxConsumedPointByMode(var_6_10) then
		var_6_12 = true
	end
	
	arg_6_0:removeGroup(arg_6_2)
	
	if not var_6_5 or not var_6_6 or var_6_7 or var_6_8 or var_6_11 or var_6_12 ~= false or var_6_3 == 2 or arg_6_1 == POINT_FACTION_ID and var_6_3 >= 1 then
	else
		local var_6_13 = arg_6_0:createGroupHandler(arg_6_2, var_6_5, var_6_6, var_6_2)
		
		if var_6_13 then
			var_6_13.faction_id = arg_6_1
		else
			print("Achievement : undefined condition class", var_6_5, var_6_4)
		end
	end
end

function Achievement.isCleared(arg_7_0, arg_7_1)
	local var_7_0 = string.split(arg_7_1, "_")
	local var_7_1 = var_7_0[1]
	local var_7_2 = var_7_0[1] .. "_" .. var_7_0[2]
	local var_7_3 = tonumber(var_7_0[3])
	local var_7_4 = Account:getFactionGroupInfo(var_7_1, var_7_2)
	local var_7_5 = var_7_4.lv or 1
	
	return var_7_3 < (var_7_5 or 1) or var_7_4.state >= 1 and var_7_5 == var_7_3
end

function Achievement.getState(arg_8_0, arg_8_1)
	local var_8_0 = string.split(arg_8_1, "_")
	local var_8_1 = var_8_0[1]
	local var_8_2 = var_8_0[1] .. "_" .. var_8_0[2]
	
	return Account:getFactionGroupInfo(var_8_1, var_8_2).state or 0
end

function Achievement.update(arg_9_0, arg_9_1)
	Account:setFactionGroupInfo(arg_9_1.faction_id, arg_9_1.group_id, {
		faction_id = arg_9_1.faction_id,
		group_id = arg_9_1.group_id,
		state = arg_9_1.state
	})
	
	if arg_9_1.state == 1 then
		ThirdPartySocial:UnlockAchievement(DB("achievement", arg_9_1.achieve_id, {
			"platform_achieveid"
		}))
	end
	
	if (arg_9_1.faction_id == SICA_FACTION_ID or arg_9_1.faction_id == POINT_FACTION_ID) and arg_9_1.state == 1 then
		arg_9_0:removeGroup(arg_9_1.group_id)
	end
	
	arg_9_0:updateTracking(arg_9_1)
end

function Achievement.updateTracking(arg_10_0, arg_10_1)
	if not arg_10_1.group then
		return 
	end
	
	if not arg_10_1.group.conditions then
		return 
	end
	
	local function var_10_0(arg_11_0, arg_11_1, arg_11_2)
		if arg_10_1.achieve_id == arg_11_0 and arg_10_1.group.conditions[arg_11_1] and arg_10_1.group.conditions[arg_11_1].score == 1 then
			Singular:event(arg_11_2)
		end
	end
	
	var_10_0("phantom_012_01", "phantom_012_1", "join_guild")
	var_10_0("manager_008_01", "manager_008_1", "first_grade_up")
	var_10_0("manager_011_01", "manager_011_1", "first_6_grade_up")
	var_10_0("sisters_104_01", "sisters_104_1", "free_summon")
end

function Achievement.addUpdateOptions(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2.score = arg_12_1:isDoneCount()
	arg_12_2.lv = (Account:getFactionGroups(arg_12_1.faction_id)[arg_12_1:getUniqueKey()] or {}).lv or 1
	arg_12_2.f_id = arg_12_1.faction_id
end

function Achievement.getNotifierControl(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2.achieve_id
	local var_13_1 = string.split(var_13_0, "_")
	local var_13_2 = arg_13_2.faction_id
	local var_13_3 = DBT("faction", var_13_2, {
		"id",
		"name",
		"sort",
		"unlock_condition",
		"emblem",
		"description"
	})
	
	if not var_13_3 then
		return 
	end
	
	local var_13_4 = var_13_1[1] .. "_" .. var_13_1[2]
	local var_13_5 = var_13_3.unlock_condition
	local var_13_6 = var_13_3.emblem
	local var_13_7 = (Account:getFactionGroupInfo(var_13_2, var_13_4) or {}).state or 0
	local var_13_8
	local var_13_9 = true
	
	if var_13_5 and not UnlockSystem:isUnlockSystem(var_13_5) then
		var_13_9 = false
	end
	
	if SceneManager:getCurrentSceneName() == "lobby" and string.starts(var_13_0, "merchant_003") then
		var_13_9 = false
	end
	
	if var_13_9 and var_13_7 == 0 then
		local var_13_10, var_13_11, var_13_12, var_13_13 = DB("achievement", var_13_0, {
			"name",
			"desc",
			"reward_count1",
			"reset_time"
		})
		
		if var_13_13 and var_13_12 and var_13_13 == FACTION_POINT_MODE.DAILY then
			if FactionDetailPoint:isMaxConsumedPointByMode(var_13_13) then
				return 
			end
			
			local var_13_14 = FactionPoint:getPoint(var_13_13)
			
			var_13_11 = T("sisters_daily_01_de", {
				point = var_13_14 + var_13_12
			})
			var_13_6 = "fa_em_ap_" .. var_13_13
		elseif var_13_13 and var_13_12 and var_13_13 == FACTION_POINT_MODE.WEEKLY then
			if FactionDetailPoint:isMaxConsumedPointByMode(var_13_13) then
				return 
			end
			
			local var_13_15 = FactionPoint:getPoint(var_13_13)
			
			var_13_11 = T("sisters_weekly_01_de", {
				point = var_13_15 + var_13_12
			})
			var_13_6 = "fa_em_ap_" .. var_13_13
		else
			var_13_11 = T(var_13_11)
		end
		
		var_13_8 = arg_13_0:createNotifyControl(#arg_13_1, var_13_10, var_13_11, var_13_6, var_13_2)
		
		local var_13_16 = {}
		
		table.insert(var_13_16, var_13_10)
		table.insert(var_13_16, var_13_11)
		table.insert(var_13_16, var_13_6)
		table.insert(var_13_16, var_13_2)
		
		var_13_8.args = var_13_16
	end
	
	if var_13_8 then
		table.insert(arg_13_1, var_13_8)
	end
	
	return var_13_8
end

function Achievement.createNotifyControl(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = cc.CSLoader:createNode("wnd/achievement_complete.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_14_0)
	var_14_0:setAnchorPoint(0, 0)
	var_14_0:setName("achivnoti_" .. arg_14_1)
	var_14_0:setGlobalZOrder(999999)
	var_14_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_14_0, T(arg_14_2), arg_14_3)
	
	if arg_14_4 then
		if_set_sprite(var_14_0, "n_faction", "emblem/" .. arg_14_4 .. ".png")
	end
	
	if_set_visible(var_14_0, "n_dagger", arg_14_5 == SICA_FACTION_ID)
	
	return var_14_0
end
