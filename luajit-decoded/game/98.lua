MOONLIGHT_ACHIEVE_STATE = {}
MOONLIGHT_ACHIEVE_STATE.ACTIVE = 0
MOONLIGHT_ACHIEVE_STATE.CLEAR = 1
MOONLIGHT_ACHIEVE_STATE.COMPLETE = 2
MoonLightAchieve = MoonLightAchieve or {}

copy_functions(ConditionContents, MoonLightAchieve)

function MoonLightAchieve.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.MOONLIHGT_ACHIEVE
end

function MoonLightAchieve.constructor(arg_2_0, arg_2_1)
	arg_2_0.contents_type = arg_2_1
end

function MoonLightAchieve.initConditionListner(arg_3_0)
	arg_3_0:clear()
	
	local var_3_0 = Account:getRelationMoonlightSeason()
	
	if not var_3_0 then
		return 
	end
	
	if not var_3_0.code then
		return 
	end
	
	if var_3_0.state > 0 then
		return 
	end
	
	local var_3_1 = var_3_0.season_idx + 1
	
	for iter_3_0 = 1, 9999 do
		local var_3_2, var_3_3, var_3_4, var_3_5 = DBN("character_achievement", iter_3_0, {
			"id",
			"season",
			"condition",
			"value"
		})
		
		if not var_3_2 then
			break
		end
		
		if to_n(var_3_3) == var_3_1 and var_3_4 and var_3_5 then
			arg_3_0:addConditionListner(var_3_2, var_3_4, var_3_5)
		end
	end
end

function MoonLightAchieve.addConditionListner(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0:getScore(arg_4_1)
	
	if arg_4_0:getState(arg_4_1) == MOONLIGHT_ACHIEVE_STATE.ACTIVE then
		arg_4_0:removeGroup(arg_4_1)
		
		if arg_4_0:createGroupHandler(arg_4_1, arg_4_2, arg_4_3, var_4_0) then
		else
			print("SysAchievement : undefined condition class", arg_4_2, arg_4_1)
		end
	end
end

function MoonLightAchieve.update(arg_5_0, arg_5_1)
	Account:updateRelationMoonlightAchievement(arg_5_1.achieve_info)
	arg_5_0:setUpdateConditionCurScore(arg_5_1.achieve_info.contents_id, nil, arg_5_1.achieve_info.score1)
	
	if arg_5_1.achieve_info.state == MOONLIGHT_ACHIEVE_STATE.CLEAR then
		arg_5_0:removeGroup(arg_5_1.achieve_info.contents_id)
	end
end

function MoonLightAchieve.isCleared(arg_6_0, arg_6_1)
	return Account:isClearedRelationMoonlightAchieveByID(arg_6_1)
end

function MoonLightAchieve.getScore(arg_7_0, arg_7_1)
	return Account:getScoreRelationMoonlightAchieveByID(arg_7_1)
end

function MoonLightAchieve.getState(arg_8_0, arg_8_1)
	return Account:getStateRelationMoonlightAchieveByID(arg_8_1)
end

function MoonLightAchieve.getConditionScore(arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0:getScore(arg_9_1)
end

function MoonLightAchieve.getNotifierControl(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.contents_id
	local var_10_1 = arg_10_0:getState(var_10_0)
	local var_10_2
	
	if (var_10_1 or MOONLIGHT_ACHIEVE_STATE.ACTIVE) == MOONLIGHT_ACHIEVE_STATE.ACTIVE then
		local var_10_3, var_10_4, var_10_5, var_10_6 = DB("character_achievement", var_10_0, {
			"id",
			"name",
			"desc",
			"icon2"
		})
		
		var_10_2 = arg_10_0:createNotifyControl(#arg_10_1, var_10_4, var_10_5, var_10_6)
		
		local var_10_7 = {}
		
		table.insert(var_10_7, var_10_4)
		table.insert(var_10_7, var_10_5)
		table.insert(var_10_7, var_10_6)
		
		var_10_2.args = var_10_7
		
		if var_10_2 then
			table.insert(arg_10_1, var_10_2)
		end
	end
	
	return var_10_2
end

function MoonLightAchieve.createNotifyControl(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = cc.CSLoader:createNode("wnd/achievement_complete.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_11_0)
	var_11_0:setAnchorPoint(0, 0)
	var_11_0:setName("achivnoti_" .. arg_11_1)
	var_11_0:setGlobalZOrder(999999)
	var_11_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_11_0, T(arg_11_2), T(arg_11_3))
	
	if arg_11_4 then
		local var_11_1 = var_11_0:getChildByName("n_faction")
		
		if get_cocos_refid(var_11_1) then
			var_11_1:setScale(1)
			SpriteCache:resetSprite(var_11_1, "img/" .. arg_11_4 .. ".png")
		end
	end
	
	return var_11_0
end
