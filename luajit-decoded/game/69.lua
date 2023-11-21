local function var_0_0(arg_1_0)
	if type(arg_1_0) == "table" then
		local var_1_0 = table.count(arg_1_0)
		
		if table.isInclude(arg_1_0, "quest") then
			if not table.isInclude(arg_1_0, "urgent") then
				table.insert(arg_1_0, "urgent")
			end
			
			if not table.isInclude(arg_1_0, "burning") then
				table.insert(arg_1_0, "burning")
			end
			
			if not table.isInclude(arg_1_0, "descent") then
				table.insert(arg_1_0, "descent")
			end
		end
		
		if var_1_0 < table.count(arg_1_0) then
			return arg_1_0
		end
	elseif arg_1_0 == "quest" then
		local var_1_1 = {}
		
		table.insert(var_1_1, arg_1_0)
		table.insert(var_1_1, "urgent")
		table.insert(var_1_1, "burning")
		table.insert(var_1_1, "descent")
		
		return var_1_1
	end
	
	return nil
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = false
	
	if not arg_2_0 or not arg_2_1 then
		return var_2_0
	end
	
	local var_2_1 = var_0_0(arg_2_0)
	
	if var_2_1 then
		arg_2_0 = var_2_1
	end
	
	if type(arg_2_0) == "table" then
		for iter_2_0, iter_2_1 in pairs(arg_2_0) do
			if iter_2_1 == arg_2_2 then
				var_2_0 = true
			end
		end
	elseif arg_2_0 == arg_2_2 then
		var_2_0 = true
	end
	
	return var_2_0
end

local function var_0_2(arg_3_0, arg_3_1)
	local var_3_0, var_3_1, var_3_2 = DB("character", arg_3_1.targetid, {
		"type",
		"race",
		"monster_tier"
	})
	
	if arg_3_0.db.targetid and (arg_3_0:checkMultikey(arg_3_0.db.targetid, arg_3_1.targetid) or arg_3_0.db.targetid == "all") or arg_3_0.db.type and (var_3_0 == arg_3_0.db.type or arg_3_0.db.type == "all") or arg_3_0.db.mtier and (var_3_2 == arg_3_0.db.mtier or arg_3_0.db.mtier == "all") or arg_3_0.db.race and (var_3_1 == arg_3_0.db.race or arg_3_0:checkMultikey(arg_3_0.db.race, var_3_1) or arg_3_0.db.race == "all") then
		return true
	end
	
	return false
end

local function var_0_3(arg_4_0, arg_4_1)
	if arg_4_0.db.substory and arg_4_0.db.substory ~= arg_4_1.substory_id then
		return false
	end
	
	if arg_4_0.db.entertype then
		local var_4_0 = var_0_1(arg_4_0.db.entertype, arg_4_1.enter_id, arg_4_1.entertype)
		
		if arg_4_1.enter_id and var_4_0 then
			return true
		end
	elseif arg_4_0:checkMultikey(arg_4_0.db.enter, arg_4_1.enter_id) or arg_4_0:checkWildCard(arg_4_0.db.enter, arg_4_1.enter_id) then
		return true
	end
	
	return false
end

local function var_0_4(arg_5_0, arg_5_1)
	if var_0_3(arg_5_0, arg_5_1) then
		arg_5_0:doCountAdd()
		arg_5_0:checkDone()
	end
end

local function var_0_5(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.unique_id
	
	arg_6_0:clearVltTblVars(var_6_0)
	
	if var_0_3(arg_6_0, arg_6_1) then
		arg_6_0:doAccumulateCount(var_6_0)
		arg_6_0:checkDone()
	else
		arg_6_0:removeVltTbl(var_6_0)
	end
end

local function var_0_6(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.unique_id
	
	arg_7_0:clearVltTblVars(var_7_0)
	arg_7_0:doAccumulateCount(var_7_0)
	arg_7_0:checkDone()
end

local function var_0_7(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.unique_id
	local var_8_1 = arg_8_0:getVltTblVars(var_8_0)
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1.friends) do
		if not iter_8_1:isSupporter() and (arg_8_0.db.chrid == "all" or arg_8_0:checkMultikey(arg_8_0.db.chrid, iter_8_1.db.code)) then
			var_8_1.is_chrid = true
		end
	end
end

local function var_0_8(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.unique_id
	
	if arg_9_0.link_quest then
		local var_9_1 = Account:getQuestMissions()[arg_9_0.link_quest] or {}
		
		if var_9_1.state == "clear" or var_9_1.state == "received" then
			arg_9_0:doCountVlt(var_9_0)
			arg_9_0:doAccumulateCount(var_9_0)
			arg_9_0:checkDone()
			
			return 
		end
	end
	
	local var_9_2 = arg_9_1.substory_id
	
	if var_9_2 and var_9_2 ~= "vewrda" then
		if Account:isPlayedStory(arg_9_0.db.storyid) then
			arg_9_0:doCountVlt(var_9_0)
			arg_9_0:doAccumulateCount(var_9_0)
			arg_9_0:checkDone()
			
			return 
		end
		
		return 
	end
	
	if not arg_9_0.area_enter_id then
		return 
	end
	
	local var_9_3, var_9_4 = DB("level_enter", arg_9_0.area_enter_id, {
		"id",
		"atlas_id"
	})
	
	if var_9_4 then
		if Account:isPlayedStory(arg_9_0.db.storyid) then
			arg_9_0:doCountVlt(var_9_0)
			arg_9_0:doAccumulateCount(var_9_0)
			arg_9_0:checkDone()
			
			return 
		end
	elseif Account:isMapCleared(arg_9_0.area_enter_id) then
		arg_9_0:doCountVlt(var_9_0)
		arg_9_0:doAccumulateCount(var_9_0)
		arg_9_0:checkDone()
		
		return 
	end
end

ClearCondition = ClassDef(Condition_New)

function ClearCondition.constructor(arg_10_0)
end

function ClearCondition.getAcceptEvents(arg_11_0, arg_11_1)
	return {
		"battle.clear",
		"storymap.clear",
		"volley.clear",
		"cook.clear",
		"repair.clear",
		"arcade.clear",
		"exorcist.clear"
	}
end

function ClearCondition.onEvent(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 == "battle.clear" then
		var_0_4(arg_12_0, arg_12_2)
	elseif arg_12_1 == "storymap.clear" then
		var_0_4(arg_12_0, arg_12_2)
	elseif arg_12_1 == "volley.clear" then
		var_0_4(arg_12_0, arg_12_2)
	elseif arg_12_1 == "cook.clear" or arg_12_1 == "repair.clear" then
		var_0_4(arg_12_0, arg_12_2)
	elseif arg_12_1 == "arcade.clear" then
		var_0_4(arg_12_0, arg_12_2)
	elseif arg_12_1 == "exorcist.clear" then
		var_0_4(arg_12_0, arg_12_2)
	end
end

ClearConditonForGuide = ClassDef(Condition_New)

function ClearConditonForGuide.constructor(arg_13_0)
end

function ClearConditonForGuide.getAcceptEvents(arg_14_0, arg_14_1)
	return {
		"battle.clear",
		"battle.clear.sync",
		"storymap.clear"
	}
end

function ClearConditonForGuide.onEvent(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 == "battle.clear.sync" then
		local var_15_0 = arg_15_0.cur_count
		local var_15_1 = Account:getMapClearCount(arg_15_0.db.enter)
		
		if var_15_0 < var_15_1 then
			arg_15_0:doCountAdd(var_15_1 - var_15_0)
			arg_15_0:checkDone()
		end
	elseif arg_15_1 == "battle.clear" then
		var_0_4(arg_15_0, arg_15_2)
	elseif arg_15_1 == "storymap.clear" and arg_15_0:checkMultikey(arg_15_0.db.enter, arg_15_2.enter_id) then
		arg_15_0:doCountAdd()
		arg_15_0:checkDone()
	end
end

SyncClearConditon = ClassDef(Condition_New)

function SyncClearConditon.constructor(arg_16_0)
end

function SyncClearConditon.getAcceptEvents(arg_17_0, arg_17_1)
	return {
		"battle.clear",
		"storymap.clear",
		"battle.clear.sync"
	}
end

function SyncClearConditon.onEvent(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.db.content or not arg_18_0.db.enter then
		Log.e("SyncClearConditon", "invalid condition value.")
		
		return 
	end
	
	if arg_18_1 == "battle.clear" then
		var_0_4(arg_18_0, arg_18_2)
	elseif arg_18_1 == "storymap.clear" then
		var_0_4(arg_18_0, arg_18_2)
	elseif arg_18_1 == "battle.clear.sync" and arg_18_2.content == arg_18_0.db.content then
		local var_18_0 = arg_18_0:getCurCount()
		local var_18_1 = 0
		
		if type(arg_18_0.db.enter) == "table" then
			for iter_18_0, iter_18_1 in pairs(arg_18_0.db.enter) do
				var_18_1 = var_18_1 + Account:getMapClearCount(iter_18_1)
			end
		else
			var_18_1 = Account:getMapClearCount(arg_18_0.db.enter)
		end
		
		if var_18_0 < var_18_1 then
			arg_18_0:doCountAdd(var_18_1 - var_18_0)
			arg_18_0:checkDone()
		end
	end
end

ClearInfoCondition = ClassDef(Condition_New)

function ClearInfoCondition.constructor(arg_19_0)
end

function ClearInfoCondition.getAcceptEvents(arg_20_0, arg_20_1)
	return {
		"battle.clear"
	}
end

function ClearInfoCondition.onEvent(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_1 == "battle.clear" and arg_21_0.db.info == arg_21_2.info_id then
		var_0_4(arg_21_0, arg_21_2)
	end
end

StoryCondition = ClassDef(Condition_New)

function StoryCondition.constructor(arg_22_0)
end

function StoryCondition.getAcceptEvents(arg_23_0, arg_23_1)
	return {
		"battle.clear",
		"battle.story"
	}
end

function StoryCondition.onEvent(arg_24_0, arg_24_1, arg_24_2)
	arg_24_2 = arg_24_2 or {}
	
	local var_24_0 = arg_24_2.unique_id
	
	if arg_24_1 == "battle.clear" then
		if (arg_24_0:getVltCount(var_24_0) or 0) == 0 and (arg_24_0:getCurCount() or 0) == 0 then
			var_0_8(arg_24_0, arg_24_2)
		else
			arg_24_0:doAccumulateCount(var_24_0)
			arg_24_0:checkDone()
		end
	elseif arg_24_1 == "battle.story" and arg_24_0.db.storyid == arg_24_2.storyid then
		arg_24_0:doCountVlt(var_24_0)
	end
end

KillCondition = ClassDef(Condition_New)

function KillCondition.constructor(arg_25_0)
end

function KillCondition.getAcceptEvents(arg_26_0)
	return {
		"battle.clear",
		"battle.killed"
	}
end

function KillCondition.onEvent(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = false
	local var_27_1 = true
	local var_27_2 = true
	local var_27_3 = arg_27_2.unique_id
	
	if arg_27_0.db.entertype then
		local var_27_4 = var_0_1(arg_27_0.db.entertype, arg_27_2.enter_id, arg_27_2.entertype)
	end
	
	local var_27_5, var_27_6, var_27_7 = DB("character", arg_27_2.targetid, {
		"type",
		"race",
		"monster_tier"
	})
	
	if arg_27_1 == "battle.killed" and var_27_5 and var_27_6 and var_27_7 and (arg_27_0.db.targetid and (arg_27_0:checkMultikey(arg_27_0.db.targetid, arg_27_2.targetid) or arg_27_0.db.targetid == "all") or arg_27_0.db.type and (var_27_5 == arg_27_0.db.type or arg_27_0.db.type == "all") or arg_27_0.db.mtier and (var_27_7 == arg_27_0.db.mtier or arg_27_0.db.mtier == "all") or arg_27_0.db.race and (var_27_6 == arg_27_0.db.race or arg_27_0:checkMultikey(arg_27_0.db.race, var_27_6) or arg_27_0.db.race == "all")) then
		arg_27_0:doCountVlt(var_27_3)
	elseif arg_27_1 == "battle.clear" and var_0_3(arg_27_0, arg_27_2) then
		var_0_6(arg_27_0, arg_27_2)
	end
end

NoPartyCondition = ClassDef(Condition_New)

function NoPartyCondition.constructor(arg_28_0)
end

function NoPartyCondition.getAcceptEvents(arg_29_0)
	return {
		"battle.party",
		"battle.clear"
	}
end

function NoPartyCondition.onEvent(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_2.unique_id
	
	if arg_30_1 == "battle.party" and arg_30_2.friends then
		local var_30_1 = false
		
		for iter_30_0, iter_30_1 in pairs(arg_30_2.friends) do
			if not iter_30_1:isSupporter() and arg_30_0.db.androle then
				if type(arg_30_0.db.androle) == "table" then
					for iter_30_2, iter_30_3 in pairs(arg_30_0.db.androle) do
						if DB("character", iter_30_1.inst.code, "role") == iter_30_3 then
							var_30_1 = true
							
							break
						end
					end
				elseif type(arg_30_0.db.androle) == "string" and DB("character", iter_30_1.inst.code, "role") == arg_30_0.db.androle then
					var_30_1 = true
				end
			end
			
			if var_30_1 then
				break
			end
		end
		
		if var_30_1 == false then
			arg_30_0:doCountVlt(var_30_0)
		end
	elseif arg_30_1 == "battle.clear" and arg_30_2.enter_id then
		var_0_5(arg_30_0, arg_30_2)
	end
end

PartyAndRoleCondition = ClassDef(Condition_New)

function PartyAndRoleCondition.constructor(arg_31_0)
end

function PartyAndRoleCondition.getAcceptEvents(arg_32_0)
	return {
		"battle.party",
		"battle.clear"
	}
end

function PartyAndRoleCondition.onEvent(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_2.unique_id
	
	if arg_33_1 == "battle.party" and arg_33_2.friends then
		local var_33_1 = {}
		local var_33_2 = {}
		
		if type(arg_33_0.db.androle) == "table" and type(arg_33_0.db.andmember) == "table" then
			if #arg_33_0.db.androle ~= #arg_33_0.db.andmember then
				Log.e("PartyAndRoleCondition", "no_match_count")
				
				return 
			end
			
			for iter_33_0, iter_33_1 in pairs(arg_33_0.db.androle) do
				if arg_33_0.db.andmember[iter_33_0] then
					table.insert(var_33_1, {
						role = iter_33_1,
						member = tonumber(arg_33_0.db.andmember[iter_33_0])
					})
				end
			end
		end
		
		if type(arg_33_0.db.androle) == "string" and type(arg_33_0.db.andmember) == "string" then
			table.insert(var_33_1, {
				role = arg_33_0.db.androle,
				member = tonumber(arg_33_0.db.andmember)
			})
		end
		
		for iter_33_2, iter_33_3 in pairs(arg_33_2.friends) do
			if not iter_33_3:isSupporter() and arg_33_0.db.androle then
				local var_33_3 = DB("character", iter_33_3.inst.code, "role")
				
				var_33_2[var_33_3] = (var_33_2[var_33_3] or 0) + 1
			end
		end
		
		if #var_33_1 <= 0 then
			return 
		end
		
		if table.count(var_33_2) <= 0 then
			return 
		end
		
		local var_33_4 = true
		
		for iter_33_4, iter_33_5 in pairs(var_33_1) do
			if var_33_2[iter_33_5.role] == nil or var_33_2[iter_33_5.role] < iter_33_5.member then
				var_33_4 = false
				
				break
			end
		end
		
		if var_33_4 then
			arg_33_0:doCountVlt(var_33_0)
		end
	elseif arg_33_1 == "battle.clear" and arg_33_2.enter_id then
		var_0_5(arg_33_0, arg_33_2)
	end
end

UnderPartyCondition = ClassDef(Condition_New)

function UnderPartyCondition.constructor(arg_34_0)
end

function UnderPartyCondition.getAcceptEvents(arg_35_0)
	return {
		"battle.party",
		"battle.clear"
	}
end

function UnderPartyCondition.onEvent(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_2.unique_id
	
	if arg_36_1 == "battle.party" and arg_36_2.friends and arg_36_0.db.member then
		local var_36_1 = 0
		
		for iter_36_0, iter_36_1 in pairs(arg_36_2.friends) do
			local var_36_2 = iter_36_1:isSupporter()
			
			var_36_1 = var_36_1 + 1
		end
		
		if var_36_1 <= tonumber(arg_36_0.db.member) then
			arg_36_0:doCountVlt(var_36_0)
		end
	elseif arg_36_1 == "battle.clear" and arg_36_2.enter_id then
		var_0_5(arg_36_0, arg_36_2)
	end
end

PartyGradeAttributeCondition = ClassDef(Condition_New)

function PartyGradeAttributeCondition.constructor(arg_37_0)
end

function PartyGradeAttributeCondition.getAcceptEvents(arg_38_0)
	return {
		"battle.party",
		"battle.clear"
	}
end

function PartyGradeAttributeCondition.onEvent(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_2.unique_id
	
	if arg_39_1 == "battle.party" and arg_39_2.friends then
		local var_39_1 = {}
		local var_39_2 = {}
		
		for iter_39_0, iter_39_1 in pairs(arg_39_2.friends) do
			if not iter_39_1:isSupporter() and arg_39_0.db.basegrade then
				local var_39_3, var_39_4 = DB("character", iter_39_1.inst.code, {
					"grade",
					"ch_attribute"
				})
				
				var_39_1[tostring(var_39_3)] = (var_39_1[tostring(var_39_3)] or 0) + 1
				var_39_2[var_39_4] = (var_39_2[var_39_4] or 0) + 1
			end
		end
		
		if table.count(var_39_1) <= 0 then
			return 
		end
		
		if table.count(var_39_2) <= 0 then
			return 
		end
		
		local var_39_5 = false
		local var_39_6 = false
		
		if arg_39_0.db.basegrade == "all" and arg_39_0.db.bgmember then
			local var_39_7 = 0
			
			for iter_39_2, iter_39_3 in pairs(var_39_1) do
				var_39_7 = var_39_7 + iter_39_3
			end
			
			if var_39_7 >= tonumber(arg_39_0.db.bgmember) then
				var_39_5 = true
			end
		elseif var_39_1[tostring(arg_39_0.db.basegrade)] and arg_39_0.db.bgmember and var_39_1[tostring(arg_39_0.db.basegrade)] >= tonumber(arg_39_0.db.bgmember) then
			var_39_5 = true
		end
		
		if arg_39_0.db.attribute == "all" and arg_39_0.db.atmember then
			local var_39_8 = 0
			
			for iter_39_4, iter_39_5 in pairs(var_39_2) do
				var_39_8 = var_39_8 + iter_39_5
			end
			
			if var_39_8 >= tonumber(arg_39_0.db.atmember) then
				var_39_6 = true
			end
		elseif var_39_2[arg_39_0.db.attribute] and arg_39_0.db.atmember and var_39_2[arg_39_0.db.attribute] >= tonumber(arg_39_0.db.atmember) then
			var_39_6 = true
		end
		
		if var_39_5 and var_39_6 then
			arg_39_0:doCountVlt(var_39_0)
		end
	elseif arg_39_1 == "battle.clear" and arg_39_2.enter_id then
		var_0_5(arg_39_0, arg_39_2)
	end
end

PartyAttributeKilllCondition = ClassDef(Condition_New)

function PartyAttributeKilllCondition.constructor(arg_40_0)
end

function PartyAttributeKilllCondition.getAcceptEvents(arg_41_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.killed"
	}
end

function PartyAttributeKilllCondition.onEvent(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_2.unique_id
	local var_42_1 = arg_42_0:getVltTblVars(var_42_0)
	
	if arg_42_1 == "battle.party" and arg_42_2.friends then
		local var_42_2 = 0
		
		for iter_42_0, iter_42_1 in pairs(arg_42_2.friends) do
			if not iter_42_1:isSupporter() then
				local var_42_3 = DB("character", iter_42_1.inst.code, "ch_attribute")
				
				if arg_42_0.db.attribute and (var_42_3 == arg_42_0.db.attribute or arg_42_0.db.attribute == "all") then
					var_42_2 = var_42_2 + 1
				end
			end
		end
		
		if arg_42_0.db.member and var_42_2 >= tonumber(arg_42_0.db.member) then
			var_42_1.is_attribute = true
		end
	elseif arg_42_1 == "battle.killed" and arg_42_2.targetid then
		if var_42_1.is_attribute then
			local var_42_4, var_42_5, var_42_6 = DB("character", arg_42_2.targetid, {
				"type",
				"race",
				"monster_tier"
			})
			
			if arg_42_0.db.targetid and (arg_42_0:checkMultikey(arg_42_0.db.targetid, arg_42_2.targetid) or arg_42_0.db.targetid == "all") or arg_42_0.db.type and (var_42_4 == arg_42_0.db.type or arg_42_0.db.type == "all") or arg_42_0.db.mtier and (var_42_6 == arg_42_0.db.mtier or arg_42_0.db.mtier == "all") or arg_42_0.db.race and (var_42_5 == arg_42_0.db.race or arg_42_0:checkMultikey(arg_42_0.db.race, var_42_5) or arg_42_0.db.race == "all") then
				arg_42_0:doCountVlt(var_42_0)
			end
		end
	elseif arg_42_1 == "battle.clear" and arg_42_2.enter_id then
		var_0_5(arg_42_0, arg_42_2)
	end
end

PartyRoleKilllCondition = ClassDef(Condition_New)

function PartyRoleKilllCondition.constructor(arg_43_0)
end

function PartyRoleKilllCondition.getAcceptEvents(arg_44_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.killed"
	}
end

function PartyRoleKilllCondition.onEvent(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_2.unique_id
	local var_45_1 = arg_45_0:getVltTblVars(var_45_0)
	
	if arg_45_1 == "battle.party" and arg_45_2.friends then
		local var_45_2 = 0
		
		for iter_45_0, iter_45_1 in pairs(arg_45_2.friends) do
			if not iter_45_1:isSupporter() then
				local var_45_3 = DB("character", iter_45_1.inst.code, "role")
				
				if arg_45_0.db.role and (var_45_3 == arg_45_0.db.role or arg_45_0.db.role == "all") then
					var_45_2 = var_45_2 + 1
				end
			end
		end
		
		if arg_45_0.db.member and var_45_2 >= tonumber(arg_45_0.db.member) then
			var_45_1.is_role = true
		end
	elseif arg_45_1 == "battle.killed" and arg_45_2.targetid then
		if var_45_1.is_role then
			local var_45_4, var_45_5, var_45_6 = DB("character", arg_45_2.targetid, {
				"type",
				"race",
				"monster_tier"
			})
			
			if arg_45_0.db.targetid and (arg_45_0:checkMultikey(arg_45_0.db.targetid, arg_45_2.targetid) or arg_45_0.db.targetid == "all") or arg_45_0.db.type and (var_45_4 == arg_45_0.db.type or arg_45_0.db.type == "all") or arg_45_0.db.mtier and (var_45_6 == arg_45_0.db.mtier or arg_45_0.db.mtier == "all") or arg_45_0.db.race and (var_45_5 == arg_45_0.db.race or arg_45_0:checkMultikey(arg_45_0.db.race, var_45_5) or arg_45_0.db.race == "all") then
				arg_45_0:doCountVlt(var_45_0)
			end
		end
	elseif arg_45_1 == "battle.clear" and arg_45_2.enter_id then
		var_0_5(arg_45_0, arg_45_2)
	end
end

PartyChridKilllCondition = ClassDef(Condition_New)

function PartyChridKilllCondition.constructor(arg_46_0)
end

function PartyChridKilllCondition.getAcceptEvents(arg_47_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.killed"
	}
end

function PartyChridKilllCondition.onEvent(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_2.unique_id
	local var_48_1 = arg_48_0:getVltTblVars(var_48_0)
	
	if arg_48_1 == "battle.party" and arg_48_2.friends then
		for iter_48_0, iter_48_1 in pairs(arg_48_2.friends) do
			if not iter_48_1:isSupporter() and arg_48_0:checkMultikey(arg_48_0.db.chrid, iter_48_1.db.code) then
				var_48_1.is_chrid = true
			end
		end
	elseif arg_48_1 == "battle.killed" and arg_48_2.targetid then
		if var_48_1.is_chrid and var_0_2(arg_48_0, arg_48_2) then
			arg_48_0:doCountVlt(var_48_0)
		end
	elseif arg_48_1 == "battle.clear" and arg_48_2.enter_id then
		var_0_5(arg_48_0, arg_48_2)
	end
end

PartyChridCSCondition = ClassDef(Condition_New)

function PartyChridCSCondition.constructor(arg_49_0)
end

function PartyChridCSCondition.getAcceptEvents(arg_50_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.cs"
	}
end

function PartyChridCSCondition.onEvent(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_2.unique_id
	local var_51_1 = arg_51_0:getVltTblVars(var_51_0)
	
	if arg_51_1 == "battle.party" and arg_51_2.friends then
		var_0_7(arg_51_0, arg_51_2)
	elseif arg_51_1 == "battle.cs" and arg_51_2.state_id then
		if DEBUG.CONDITION_CS then
			print("error?", arg_51_2.target_code, arg_51_2.state_id)
		end
		
		if var_51_1.is_chrid and tostring(arg_51_2.state_id) == tostring(arg_51_0.db.cs) then
			arg_51_0:doCountVlt(var_51_0)
		end
	elseif arg_51_1 == "battle.clear" and arg_51_2.enter_id then
		var_0_5(arg_51_0, arg_51_2)
	end
end

PartyCSCountCondition = ClassDef(Condition_New)

function PartyCSCountCondition.constructor(arg_52_0)
end

function PartyCSCountCondition.getAcceptEvents(arg_53_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.cs"
	}
end

function PartyCSCountCondition.onEvent(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_2.unique_id
	local var_54_1 = arg_54_0:getVltTblVars(var_54_0)
	
	if arg_54_1 == "battle.party" and arg_54_2.friends then
		var_0_7(arg_54_0, arg_54_2)
	elseif arg_54_1 == "battle.cs" and arg_54_2.state_id then
		if DEBUG.CONDITION_CS then
			print("error?", arg_54_2.target_code, arg_54_2.state_id)
		end
		
		if arg_54_0:getVltCount(var_54_0) >= 1 then
			return 
		end
		
		if var_54_1.is_chrid and tostring(arg_54_2.state_id) == tostring(arg_54_0.db.cs) then
			var_54_1.cs_count = (var_54_1.cs_count or 0) + 1
			
			if to_n(var_54_1.cs_count) >= to_n(arg_54_0.db.cscount) then
				arg_54_0:doCountVlt(var_54_0)
			end
		end
	elseif arg_54_1 == "battle.clear" and arg_54_2.enter_id then
		var_0_5(arg_54_0, arg_54_2)
	end
end

PartyCSZeroCountCondition = ClassDef(Condition_New)

function PartyCSZeroCountCondition.constructor(arg_55_0)
end

function PartyCSZeroCountCondition.getAcceptEvents(arg_56_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.cs"
	}
end

function PartyCSZeroCountCondition.onEvent(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = arg_57_2.unique_id
	local var_57_1 = arg_57_0:getVltTblVars(var_57_0)
	
	if arg_57_1 == "battle.party" and arg_57_2.friends then
		var_0_7(arg_57_0, arg_57_2)
	elseif arg_57_1 == "battle.cs" and arg_57_2.state_id then
		if DEBUG.CONDITION_CS then
			print("error?", arg_57_2.target_code, arg_57_2.state_id)
		end
		
		if to_n(var_57_1.cs_count) >= 1 then
			return 
		end
		
		if tostring(arg_57_2.state_id) == tostring(arg_57_0.db.noncs) then
			var_57_1.cs_count = (var_57_1.cs_count or 0) + 1
		end
	elseif arg_57_1 == "battle.clear" and arg_57_2.enter_id then
		if var_57_1.is_chrid and to_n(var_57_1.cs_count) == 0 then
			arg_57_0:doCountVlt(var_57_0)
		end
		
		var_0_5(arg_57_0, arg_57_2)
	end
end

NoPartyRoleKilllCondition = ClassDef(Condition_New)

function NoPartyRoleKilllCondition.constructor(arg_58_0)
end

function NoPartyRoleKilllCondition.getAcceptEvents(arg_59_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.killed"
	}
end

function NoPartyRoleKilllCondition.onEvent(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_2.unique_id
	local var_60_1 = arg_60_0:getVltTblVars(var_60_0)
	
	if arg_60_1 == "battle.party" and arg_60_2.friends then
		if arg_60_0.db.role then
			var_60_1.is_role = true
		end
		
		for iter_60_0, iter_60_1 in pairs(arg_60_2.friends) do
			if not iter_60_1:isSupporter() then
				local var_60_2 = DB("character", iter_60_1.inst.code, "role")
				
				if arg_60_0.db.role and var_60_2 == arg_60_0.db.role then
					var_60_1.is_role = nil
					
					break
				end
			end
		end
	elseif arg_60_1 == "battle.killed" and arg_60_2.targetid then
		if var_60_1.is_role then
			local var_60_3, var_60_4, var_60_5 = DB("character", arg_60_2.targetid, {
				"type",
				"race",
				"monster_tier"
			})
			
			if arg_60_0.db.targetid and (arg_60_0:checkMultikey(arg_60_0.db.targetid, arg_60_2.targetid) or arg_60_0.db.targetid == "all") or arg_60_0.db.type and (var_60_3 == arg_60_0.db.type or arg_60_0.db.type == "all") or arg_60_0.db.mtier and (var_60_5 == arg_60_0.db.mtier or arg_60_0.db.mtier == "all") or arg_60_0.db.race and (var_60_4 == arg_60_0.db.race or arg_60_0:checkMultikey(arg_60_0.db.race, var_60_4) or arg_60_0.db.race == "all") then
				arg_60_0:doCountVlt(var_60_0)
			end
		end
	elseif arg_60_1 == "battle.clear" and arg_60_2.enter_id then
		var_0_5(arg_60_0, arg_60_2)
	end
end

PartyCondition = ClassDef(Condition_New)

function PartyCondition.constructor(arg_61_0)
end

function PartyCondition.getAcceptEvents(arg_62_0)
	return {
		"battle.party",
		"battle.clear",
		"battle.alive"
	}
end

function PartyCondition.onEvent(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = arg_63_2.unique_id
	
	if arg_63_1 == "battle.party" and arg_63_2.friends then
		for iter_63_0, iter_63_1 in pairs(arg_63_2.friends) do
			if not iter_63_1:isSupporter() then
				if arg_63_0.db.role or arg_63_0.db.role == "all" then
					if DB("character", iter_63_1.inst.code, "role") == arg_63_0.db.role then
						arg_63_0:doCountVlt(var_63_0)
					end
				elseif arg_63_0.db.attribute or arg_63_0.db.attribute == "all" then
					if DB("character", iter_63_1.inst.code, "ch_attribute") == arg_63_0.db.attribute then
						arg_63_0:doCountVlt(var_63_0)
					end
				elseif arg_63_0.db.chrid and arg_63_0:checkMultikey(arg_63_0.db.chrid, iter_63_1.db.code) then
					arg_63_0:doCountVlt(var_63_0)
				end
			end
		end
	end
	
	if arg_63_1 == "battle.alive" and arg_63_2.friends then
		for iter_63_2, iter_63_3 in pairs(arg_63_2.friends) do
			local var_63_1 = false
			
			if not iter_63_3:isSupporter() then
				if arg_63_0.db.aliverole and arg_63_0.db.aliverole == "all" and not iter_63_3:isDead() then
					var_63_1 = true
				elseif arg_63_0.db.aliverole and not iter_63_3:isDead() and DB("character", iter_63_3.inst.code, "role") == arg_63_0.db.aliverole then
					var_63_1 = true
				end
				
				if var_63_1 then
					arg_63_0:doCountVlt(var_63_0)
				end
			end
		end
	end
	
	if arg_63_1 == "battle.clear" then
		var_0_5(arg_63_0, arg_63_2)
	end
end

PartyGradeAndRoleCondition = ClassDef(Condition_New)

function PartyGradeAndRoleCondition.constructor(arg_64_0)
end

function PartyGradeAndRoleCondition.getAcceptEvents(arg_65_0)
	return {
		"battle.party",
		"battle.clear"
	}
end

function PartyGradeAndRoleCondition.onEvent(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_2.unique_id
	
	if arg_66_1 == "battle.party" and arg_66_2.friends then
		local var_66_1 = 0
		
		for iter_66_0, iter_66_1 in pairs(arg_66_2.friends) do
			if not iter_66_1:isSupporter() then
				local var_66_2 = DB("character", iter_66_1.inst.code, "role")
				
				if iter_66_1:getBaseGrade() >= to_n(arg_66_0.db.basegradeover) and arg_66_0:checkMultikey(arg_66_0.db.role, var_66_2) then
					var_66_1 = var_66_1 + 1
				end
			end
		end
		
		if var_66_1 >= to_n(arg_66_0.db.member) then
			arg_66_0:doCountVlt(var_66_0)
		end
	end
	
	if arg_66_1 == "battle.clear" and arg_66_2.enter_id then
		var_0_5(arg_66_0, arg_66_2)
	end
end

PartyUnderCondition = ClassDef(Condition_New)

function PartyUnderCondition.constructor(arg_67_0)
end

function PartyUnderCondition.getAcceptEvents(arg_68_0)
	return {
		"battle.party",
		"battle.clear"
	}
end

function PartyUnderCondition.onEvent(arg_69_0, arg_69_1, arg_69_2)
	local var_69_0 = 0
	local var_69_1 = 0
	local var_69_2 = arg_69_2.unique_id
	local var_69_3 = arg_69_0:getVltTblVars(var_69_2)
	
	if arg_69_1 == "battle.party" and arg_69_2.friends then
		local var_69_4 = 0
		
		for iter_69_0, iter_69_1 in pairs(arg_69_2.friends) do
			if not iter_69_1:isSupporter() then
				if arg_69_0.db.role then
					if DB("character", iter_69_1.inst.code, "role") == arg_69_0.db.role then
						var_69_0 = var_69_0 + 1
					end
				elseif arg_69_0.db.attribute then
					if DB("character", iter_69_1.inst.code, "ch_attribute") == arg_69_0.db.attribute then
						var_69_1 = var_69_1 + 1
					end
				elseif arg_69_0.db.basegrade then
					local var_69_5 = iter_69_1:getBaseGrade()
					
					if var_69_5 then
						if not var_69_3.base_grade then
							var_69_3.base_grade = {}
						end
						
						var_69_3.base_grade[var_69_5] = (var_69_3.base_grade[var_69_5] or 0) + 1
					end
				end
			end
		end
		
		if arg_69_0.db.member and arg_69_0.db.role and var_69_0 <= tonumber(arg_69_0.db.member) then
			arg_69_0:doCountVlt(var_69_2)
		elseif arg_69_0.db.member and arg_69_0.db.attribute and var_69_1 <= tonumber(arg_69_0.db.member) then
			arg_69_0:doCountVlt(var_69_2)
		elseif arg_69_0.db.basegrade and var_69_3.base_grade and to_n(var_69_3.base_grade[tonumber(arg_69_0.db.basegrade)]) <= tonumber(arg_69_0.db.member) then
			arg_69_0:doCountVlt(var_69_2)
		end
	end
	
	if arg_69_1 == "battle.clear" and arg_69_2.enter_id then
		var_0_5(arg_69_0, arg_69_2)
	end
end

ObjectCondition = ClassDef(Condition_New)

function ObjectCondition.constructor(arg_70_0)
end

function ObjectCondition.getAcceptEvents(arg_71_0)
	return {
		"battle.touchObject",
		"battle.clear"
	}
end

function ObjectCondition.onEvent(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_2.unique_id
	local var_72_1 = var_0_1(arg_72_0.db.entertype, arg_72_2.enter_id, arg_72_2.entertype)
	
	if arg_72_1 == "battle.touchObject" and arg_72_0:checkMultikey(arg_72_0.db.event, arg_72_2.event_type) then
		arg_72_0:doCountVlt(var_72_0)
	end
	
	if arg_72_1 == "battle.clear" and var_0_3(arg_72_0, arg_72_2) then
		var_0_6(arg_72_0, arg_72_2)
	end
end

ExploreCondition = ClassDef(Condition_New)

function ExploreCondition.constructor(arg_73_0)
end

function ExploreCondition.getAcceptEvents(arg_74_0)
	return {
		"battle.clear"
	}
end

function ExploreCondition.onEvent(arg_75_0, arg_75_1, arg_75_2)
	if arg_75_1 == "battle.clear" and arg_75_2.enter_id and arg_75_2.explore_rate and arg_75_2.enter_id == arg_75_0.db.enter then
		local var_75_0 = arg_75_0:getCurCount()
		
		if var_75_0 <= arg_75_2.explore_rate then
			arg_75_0:doCountAdd(arg_75_2.explore_rate - var_75_0)
			arg_75_0:checkDone()
		end
	end
end

CampCondition = ClassDef(Condition_New)

function CampCondition.constructor(arg_76_0)
end

function CampCondition.getAcceptEvents(arg_77_0)
	return {
		"battle.clear"
	}
end

function CampCondition.onEvent(arg_78_0, arg_78_1, arg_78_2)
end

PvPCondition = ClassDef(Condition_New)

function PvPCondition.constructor(arg_79_0)
end

function PvPCondition.getAcceptEvents(arg_80_0, arg_80_1)
	return {
		"pvp.play",
		"pvprta.play"
	}
end

function PvPCondition.onEvent(arg_81_0, arg_81_1, arg_81_2)
	if not arg_81_0.db.pvptype then
		Log.e("PvPCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_81_1 == "pvp.play" and arg_81_0:checkMultikey(arg_81_0.db.pvptype, "normal") then
		arg_81_0:doCountAdd()
		arg_81_0:checkDone()
	elseif arg_81_1 == "pvprta.play" and arg_81_0:checkMultikey(arg_81_0.db.pvptype, "rta") then
		arg_81_0:doCountAdd()
		arg_81_0:checkDone()
	end
end

PvPWinCondition = ClassDef(Condition_New)

function PvPWinCondition.constructor(arg_82_0)
end

function PvPWinCondition.getAcceptEvents(arg_83_0, arg_83_1)
	return {
		"pvp.win",
		"pvprta.win"
	}
end

function PvPWinCondition.onEvent(arg_84_0, arg_84_1, arg_84_2)
	if not arg_84_0.db.pvptype then
		Log.e("PvPWinCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_84_1 == "pvp.win" and arg_84_0:checkMultikey(arg_84_0.db.pvptype, "normal") then
		arg_84_0:doCountAdd()
		arg_84_0:checkDone()
	elseif arg_84_1 == "pvprta.win" and arg_84_0:checkMultikey(arg_84_0.db.pvptype, "rta") then
		arg_84_0:doCountAdd()
		arg_84_0:checkDone()
	end
end

PvPNpcCondition = ClassDef(Condition_New)

function PvPNpcCondition.constructor(arg_85_0)
end

function PvPNpcCondition.getAcceptEvents(arg_86_0, arg_86_1)
	return {
		"pvp.npc"
	}
end

function PvPNpcCondition.onEvent(arg_87_0, arg_87_1, arg_87_2)
	if arg_87_1 == "pvp.npc" and arg_87_2.npc_id == arg_87_0.db.npcbattle and tonumber(arg_87_2.level) == tonumber(arg_87_0.db.level) then
		arg_87_0:doCountAdd()
		arg_87_0:checkDone()
	end
end

SupporterCondition = ClassDef(Condition_New)

function SupporterCondition.constructor(arg_88_0)
end

function SupporterCondition.getAcceptEvents(arg_89_0)
	return {
		"battle.clear"
	}
end

function SupporterCondition.onEvent(arg_90_0, arg_90_1, arg_90_2)
	if arg_90_1 == "battle.clear" and arg_90_2.is_use_support then
		arg_90_0:doCountAdd()
		arg_90_0:checkDone()
	end
end

ClearMaxLevelCondition = ClassDef(Condition_New)

function ClearMaxLevelCondition.constructor(arg_91_0)
end

function ClearMaxLevelCondition.getAcceptEvents(arg_92_0)
	return {
		"battle.clear",
		"sync.battle_max"
	}
end

function ClearMaxLevelCondition.onEvent(arg_93_0, arg_93_1, arg_93_2)
	if arg_93_1 == "battle.clear" and arg_93_2.enter_id then
		if string.starts(arg_93_2.enter_id, "abysshard") then
			return 
		end
		
		local var_93_0 = arg_93_0:getCurCount()
		local var_93_1 = tonumber(string.sub(arg_93_2.enter_id, -3))
		
		if arg_93_0:checkWildCard(arg_93_0.db.enter, arg_93_2.enter_id) and var_93_0 < var_93_1 then
			arg_93_0:doCountAdd(var_93_1 - var_93_0)
			arg_93_0:checkDone()
		end
	elseif arg_93_1 == "sync.battle_max" then
		if string.starts(arg_93_0.db.enter, "abysshard") then
			return 
		end
		
		if string.starts(arg_93_0.db.enter, "abyss") then
			local var_93_2 = arg_93_0:getCurCount()
			local var_93_3 = AccountData.hell_lv or 0
			
			arg_93_0:doCountAdd(var_93_3 - var_93_2)
			arg_93_0:checkDone()
		elseif string.starts(arg_93_0.db.enter, "autom") then
			local var_93_4 = arg_93_0:getCurCount()
			local var_93_5 = (Account:getAutomatonInfo() or {}).floor or 0
			
			arg_93_0:doCountAdd(var_93_5 - var_93_4)
			arg_93_0:checkDone()
		end
	end
end

AbyssHardMaxLevelCondition = ClassDef(Condition_New)

function AbyssHardMaxLevelCondition.constructor(arg_94_0)
end

function AbyssHardMaxLevelCondition.getAcceptEvents(arg_95_0)
	return {
		"battle.clear",
		"sync.battle_max"
	}
end

function AbyssHardMaxLevelCondition.onEvent(arg_96_0, arg_96_1, arg_96_2)
	local var_96_0 = "abysshard"
	
	if arg_96_1 == "battle.clear" and arg_96_2.enter_id then
		local var_96_1 = arg_96_0:getCurCount()
		local var_96_2 = tonumber(string.sub(arg_96_2.enter_id, -3))
		
		if string.starts(arg_96_2.enter_id, var_96_0) and var_96_1 < var_96_2 then
			arg_96_0:doCountAdd(var_96_2 - var_96_1)
			arg_96_0:checkDone()
		end
	elseif arg_96_1 == "sync.battle_max" then
		local var_96_3 = arg_96_0:getCurCount()
		local var_96_4 = 0
		
		for iter_96_0 = 1, 99 do
			local var_96_5 = DB("level_enter", string.format("%s%03d", var_96_0, iter_96_0), "id")
			
			if not var_96_5 then
				break
			end
			
			if Account:isMapCleared(var_96_5) then
				var_96_4 = iter_96_0
			else
				break
			end
		end
		
		if var_96_3 < var_96_4 then
			arg_96_0:doCountAdd(var_96_4 - var_96_3)
			arg_96_0:checkDone()
		end
	end
end

CampingCondition = ClassDef(Condition_New)

function CampingCondition.constructor(arg_97_0)
end

function CampingCondition.getAcceptEvents(arg_98_0)
	return {
		"battle.camping",
		"battle.clear"
	}
end

function CampingCondition.onEvent(arg_99_0, arg_99_1, arg_99_2)
	local var_99_0 = arg_99_2.unique_id
	
	if arg_99_1 == "battle.camping" then
		arg_99_0:doCountVlt(var_99_0)
	elseif arg_99_1 == "battle.clear" then
		var_0_6(arg_99_0, arg_99_2)
	end
end

TrialHallCondition = ClassDef(Condition_New)

function TrialHallCondition.constructor(arg_100_0)
end

function TrialHallCondition.getAcceptEvents(arg_101_0, arg_101_1)
	return {
		"battle.clear"
	}
end

function TrialHallCondition.onEvent(arg_102_0, arg_102_1, arg_102_2)
	if arg_102_1 == "battle.clear" and arg_102_0.db.trialrank and arg_102_2.rank_idx and tonumber(arg_102_0.db.trialrank) <= tonumber(arg_102_2.rank_idx) then
		arg_102_0:doCountAdd()
		arg_102_0:checkDone()
	end
end

TrialHallScoreCondition = ClassDef(Condition_New)

function TrialHallScoreCondition.constructor(arg_103_0)
end

function TrialHallScoreCondition.getAcceptEvents(arg_104_0, arg_104_1)
	return {
		"battle.trialhall"
	}
end

function TrialHallScoreCondition.onEvent(arg_105_0, arg_105_1, arg_105_2)
	if arg_105_1 == "battle.trialhall" and arg_105_0.db.enter and arg_105_2.enter_id and arg_105_0.db.enter == arg_105_2.enter_id and tonumber(arg_105_0.db.score) <= tonumber(arg_105_2.score) then
		arg_105_0:doCountAdd()
		arg_105_0:checkDone()
	end
end

GetBattleItemConditon = ClassDef(Condition_New)

function GetBattleItemConditon.constructor(arg_106_0)
end

function GetBattleItemConditon.getAcceptEvents(arg_107_0)
	return {
		"token.get"
	}
end

function GetBattleItemConditon.onEvent(arg_108_0, arg_108_1, arg_108_2)
	if arg_108_1 == "token.get" and (arg_108_0.db.tokentype == arg_108_2.tokentype or arg_108_0.db.tokentype == "to_" .. arg_108_2.tokentype) then
		if arg_108_0.db.enter then
			if arg_108_2.enter and (arg_108_0:checkMultikey(arg_108_0.db.enter, arg_108_2.enter) or arg_108_0:checkWildCard(arg_108_0.db.enter, arg_108_2.enter)) then
				arg_108_0:doCountAdd(arg_108_2.value or 1)
				arg_108_0:checkDone()
			end
		elseif arg_108_0.db.entertype then
			local var_108_0 = var_0_1(arg_108_0.db.entertype, arg_108_2.enter_id, arg_108_2.entertype)
			
			if arg_108_2.enter and var_108_0 then
				arg_108_0:doCountAdd(arg_108_2.value or 1)
				arg_108_0:checkDone()
			end
		end
	end
end

WorldBossCondition = ClassDef(Condition_New)

function WorldBossCondition.constructor(arg_109_0)
end

function WorldBossCondition.getAcceptEvents(arg_110_0, arg_110_1)
	return {
		"worldboss.clear"
	}
end

function WorldBossCondition.onEvent(arg_111_0, arg_111_1, arg_111_2)
	if arg_111_1 == "worldboss.clear" then
		arg_111_0:doCountAdd()
		arg_111_0:checkDone()
	end
end

ExpeditionResultCondition = ClassDef(Condition_New)

function ExpeditionResultCondition.constructor(arg_112_0)
end

function ExpeditionResultCondition.getAcceptEvents(arg_113_0, arg_113_1)
	return {
		"expedition.result"
	}
end

function ExpeditionResultCondition.onEvent(arg_114_0, arg_114_1, arg_114_2)
	if arg_114_1 == "expedition.result" and arg_114_2.difficulty and (arg_114_0.db.difficulty == "all" or tonumber(arg_114_2.difficulty) == tonumber(arg_114_0.db.difficulty)) then
		arg_114_0:doCountAdd(arg_114_2.count or 1)
		arg_114_0:checkDone()
	end
end

ExpeditionDetectCondition = ClassDef(Condition_New)

function ExpeditionDetectCondition.constructor(arg_115_0)
end

function ExpeditionDetectCondition.getAcceptEvents(arg_116_0, arg_116_1)
	return {
		"expedition.detect"
	}
end

function ExpeditionDetectCondition.onEvent(arg_117_0, arg_117_1, arg_117_2)
	if arg_117_1 == "expedition.detect" then
		arg_117_0:doCountAdd()
		arg_117_0:checkDone()
	end
end

ExpeditionScoreCondition = ClassDef(Condition_New)

function ExpeditionScoreCondition.constructor(arg_118_0)
end

function ExpeditionScoreCondition.getAcceptEvents(arg_119_0, arg_119_1)
	return {
		"battle.expedition"
	}
end

function ExpeditionScoreCondition.onEvent(arg_120_0, arg_120_1, arg_120_2)
	if arg_120_1 == "battle.expedition" and arg_120_0.db.enter and arg_120_0.db.enter == arg_120_2.enter_id and tonumber(arg_120_0.db.score) <= tonumber(arg_120_2.score) then
		arg_120_0:doCountAdd()
		arg_120_0:checkDone()
	end
end

EquipGetCondition = ClassDef(Condition_New)

function EquipGetCondition.constructor(arg_121_0)
end

function EquipGetCondition.getAcceptEvents(arg_122_0)
	return {
		"equip.get"
	}
end

function EquipGetCondition.onEvent(arg_123_0, arg_123_1, arg_123_2)
	if arg_123_1 == "equip.get" then
		if arg_123_0.db.equiptype and (arg_123_0.db.equiptype == "all" or arg_123_0:checkMultikey(arg_123_0.db.equiptype, arg_123_2.equiptype)) then
			local var_123_0, var_123_1 = DB("equip_item", arg_123_2.code, {
				"id",
				"stone"
			})
			
			if var_123_0 and not var_123_1 then
				arg_123_0:doCountAdd()
				arg_123_0:checkDone()
				
				return 
			end
		end
		
		if arg_123_0.db.equipid and arg_123_0:checkMultikey(arg_123_0.db.equipid, arg_123_2.code) then
			local var_123_2, var_123_3 = DB("equip_item", arg_123_2.code, {
				"id",
				"stone"
			})
			
			if var_123_2 and not var_123_3 then
				if arg_123_0.db.enter then
					if arg_123_2.enter and arg_123_0:checkMultikey(arg_123_0.db.enter, arg_123_2.enter) then
						arg_123_0:doCountAdd()
						arg_123_0:checkDone()
					end
				else
					arg_123_0:doCountAdd()
					arg_123_0:checkDone()
				end
				
				return 
			end
		end
		
		if arg_123_0.db.entertype and arg_123_2.enter and var_0_1(arg_123_0.db.entertype, arg_123_2.enter, arg_123_2.entertype) then
			arg_123_0:doCountAdd(arg_123_2.value or 1)
			arg_123_0:checkDone()
			
			return 
		end
	end
end

EquipGetSubStatCondition = ClassDef(Condition_New)

function EquipGetSubStatCondition.constructor(arg_124_0)
end

function EquipGetSubStatCondition.getAcceptEvents(arg_125_0)
	return {
		"equip.get",
		"equip.upgrade",
		"equip.refine",
		"sync.badge_profile_12"
	}
end

function EquipGetSubStatCondition.onEvent(arg_126_0, arg_126_1, arg_126_2)
	if not arg_126_0.db.subablilty or not arg_126_0.db.stats then
		Log.e("EquipGetSubStatCondition", "invalid condition value.")
		
		return 
	end
	
	local var_126_0 = to_n(arg_126_0.db.stats)
	
	local function var_126_1(arg_127_0)
		local var_127_0 = 0
		
		for iter_127_0, iter_127_1 in pairs(arg_127_0 or {}) do
			if iter_127_1[1] == arg_126_0.db.subablilty then
				var_127_0 = var_127_0 + iter_127_1[2]
			end
		end
		
		return var_127_0 >= var_126_0
	end
	
	if arg_126_1 == "equip.get" then
		if not arg_126_2.sub_stats then
			Log.e("EquipGetSubStatCondition:equip.get", "invalid params.")
			
			return 
		end
		
		if var_126_1(arg_126_2.sub_stats) then
			arg_126_0:doCountAdd()
			arg_126_0:checkDone()
		end
	elseif arg_126_1 == "equip.upgrade" or arg_126_1 == "equip.refine" then
		if not arg_126_2.prev_sub_stats and not arg_126_2.sub_stats then
			Log.e("EquipGetSubStatCondition:" .. arg_126_1, "invalid params.")
			
			return 
		end
		
		local var_126_2 = 0
		
		for iter_126_0, iter_126_1 in pairs(arg_126_2.prev_sub_stats) do
			if iter_126_1[1] == arg_126_0.db.subablilty then
				var_126_2 = var_126_2 + iter_126_1[2]
			end
		end
		
		local var_126_3 = 0
		
		for iter_126_2, iter_126_3 in pairs(arg_126_2.sub_stats) do
			if iter_126_3[1] == arg_126_0.db.subablilty then
				var_126_3 = var_126_3 + iter_126_3[2]
			end
		end
		
		if var_126_2 > 0 and var_126_3 > 0 then
			if var_126_2 < var_126_0 and var_126_0 <= var_126_3 then
				arg_126_0:doCountAdd()
				arg_126_0:checkDone()
			end
		elseif var_126_2 == 0 and var_126_3 > 0 and var_126_0 <= var_126_3 then
			arg_126_0:doCountAdd()
			arg_126_0:checkDone()
		end
	elseif arg_126_1 == "sync.badge_profile_12" then
		local var_126_4 = arg_126_0:getCurCount()
		local var_126_5 = 0
		
		for iter_126_4, iter_126_5 in pairs(Account.equips or {}) do
			if iter_126_5.grade == 5 and var_126_1(iter_126_5.opts) then
				var_126_5 = var_126_5 + 1
			end
		end
		
		if var_126_4 < var_126_5 then
			arg_126_0:doCountAdd(var_126_5 - var_126_4)
			arg_126_0:checkDone()
		end
	end
end

TurnCondition = ClassDef(Condition_New)

function TurnCondition.constructor(arg_128_0)
end

function TurnCondition.getAcceptEvents(arg_129_0)
	return {
		"battle.clear"
	}
end

function TurnCondition.onEvent(arg_130_0, arg_130_1, arg_130_2)
	if not arg_130_0.db.enter or not arg_130_0.db.turn then
		Log.e("TurnCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_130_1 == "battle.clear" then
		if not arg_130_2.enter_id and not arg_130_2.stage_counter then
			Log.e("TurnCondition:" .. arg_130_1, "invalid params.")
			
			return 
		end
		
		if arg_130_0:checkMultikey(arg_130_0.db.enter, arg_130_2.enter_id) and arg_130_2.stage_counter <= to_n(arg_130_0.db.turn) then
			arg_130_0:doCountAdd()
			arg_130_0:checkDone()
		end
	end
end
