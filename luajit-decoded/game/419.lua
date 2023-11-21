UnitInfosUtil = {}

function UnitInfosUtil.setUnitDetail(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = UnitInfosController:getUnit()
	
	UIUtil:setUnitAllInfo(arg_1_2, var_1_0)
	arg_1_2:getChildByName("txt_story"):setString(T(DB("character", var_1_0.db.code, "2line"), "text"))
	
	if arg_1_3 then
		local var_1_1 = T(DB("character", var_1_0.db.code, "story"))
		
		if_set(arg_1_3, "txt_story", var_1_1)
		UIUtil:setSubTaskSkillInfo(arg_1_3, var_1_0, {
			no_stat = true
		})
	end
	
	local var_1_2 = arg_1_2:getChildByName("txt_name")
	
	var_1_2:setString(T(var_1_0.db.name))
	if_call(arg_1_2, "star1", "setPositionX", 10 + var_1_2:getContentSize().width * var_1_2:getScaleX() + var_1_2:getPositionX())
	
	local var_1_3 = arg_1_2:findChildByName("n_hero_special_stat")
	
	if get_cocos_refid(var_1_3) then
		UIUtil:setSubTaskStatInfo(var_1_3, var_1_0)
	end
	
	local var_1_4 = var_1_0.db.code
	
	if var_1_0:isMoonlightDestinyUnit() then
		var_1_4 = MoonlightDestiny:getRelationCharacterCode(var_1_4)
	end
	
	local var_1_5 = arg_1_0:getCharacterVoiceName(var_1_4)
	
	if_set_visible(arg_1_3, "n_cv", var_1_5)
	if_set(arg_1_3, "txt_cv", var_1_5)
end

function UnitInfosUtil.getCharacterVoiceName(arg_2_0, arg_2_1)
	local var_2_0 = getUserLanguage()
	
	if var_2_0 == getMediaLanguage() then
		if var_2_0 == "ko" then
			var_2_0 = "kr"
		end
		
		local var_2_1 = DB("character_voice", arg_2_1, var_2_0)
		
		if var_2_1 then
			return T(var_2_1)
		end
	end
	
	return nil
end

function UnitInfosUtil.getCharacterProfileData(arg_3_0, arg_3_1)
	if not arg_3_1 or table.empty(arg_3_1.db) then
		return nil
	end
	
	local var_3_0 = arg_3_1.db.code
	
	if arg_3_1:isMoonlightDestinyUnit() then
		var_3_0 = MoonlightDestiny:getRelationCharacterCode(var_3_0)
	end
	
	local var_3_1 = DBT("character_profile", var_3_0, {
		"dic_category",
		"profile1",
		"profile2",
		"profile3",
		"profile4",
		"profile5",
		"secret1",
		"secret2",
		"secret3",
		"secret_voice1",
		"secret_voice2",
		"secret_voice3"
	}) or {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		if iter_3_0 and string.match(iter_3_0, "secret%d") then
			local var_3_2 = string.len("secret")
			local var_3_3 = string.sub(iter_3_0, var_3_2 + 1, -1)
			local var_3_4 = "secret_voice" .. var_3_3
			
			if var_3_1[var_3_4] then
				local var_3_5 = {
					type = var_3_4,
					value = var_3_1[var_3_4]
				}
				
				var_3_1[var_3_4] = nil
				
				local var_3_6 = iter_3_1
				
				var_3_1[iter_3_0] = {
					value = var_3_6,
					voice = var_3_5
				}
			end
		end
	end
	
	var_3_1.intro = DB("character", arg_3_1.db.code, "2line")
	
	return var_3_1
end

function UnitInfosUtil.isExistUnitProfileUnlock(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_1 or table.empty(arg_4_1.db) then
		return false
	end
	
	arg_4_3 = arg_4_3 or {}
	arg_4_2 = arg_4_2 or "devotion"
	
	local var_4_0 = DBT("character_profile", arg_4_1.db.code, {
		"dic_category",
		"profile1",
		"profile2",
		"profile3",
		"profile4",
		"profile5",
		"secret1",
		"secret2",
		"secret3",
		"secret_voice1",
		"secret_voice2",
		"secret_voice3"
	}) or {}
	
	for iter_4_0 = 1, 9999 do
		local var_4_1, var_4_2, var_4_3 = DBN("character_profile_unlock", iter_4_0, {
			"id",
			"type",
			"level"
		})
		
		if not var_4_1 or not var_4_2 or not var_4_3 then
			break
		end
		
		if var_4_1 and var_4_0[var_4_1] and var_4_2 and var_4_3 and var_4_2 == arg_4_2 then
			local var_4_4
			local var_4_5
			
			if var_4_2 == "intimacy" then
				var_4_4 = arg_4_3.pre_fav or 0
				var_4_5 = arg_4_3.cur_fav or arg_4_1:getFavLevel()
			elseif var_4_2 == "devotion" then
				local var_4_6, var_4_7 = arg_4_1:getDevoteGrade(arg_4_3.pre_devote)
				
				var_4_4 = var_4_7 or 0
				
				local var_4_8, var_4_9 = arg_4_1:getDevoteGrade(arg_4_3.cur_devote)
				
				var_4_5 = var_4_9 or 0
			end
			
			if var_4_4 and var_4_5 and var_4_4 < var_4_5 and var_4_4 < var_4_3 and var_4_3 <= var_4_5 then
				return true
			end
		end
	end
	
	return false
end

function UnitInfosUtil.getCharacterSubStories(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	SubStoryViewerDB:create()
	
	local var_5_0 = arg_5_1.db.code
	
	if arg_5_1:isMoonlightDestinyUnit() then
		var_5_0 = MoonlightDestiny:getRelationCharacterCode(var_5_0)
	end
	
	return (SubStoryViewerDB:getCharacterSubStories(var_5_0))
end

function UnitInfosUtil.isDetailInfoUnit(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return 
	end
	
	local var_6_0 = arg_6_1:getDisplayCode() == "c3084"
	
	return not (arg_6_1:getBaseGrade() < 3) and not arg_6_1:isPromotionUnit() and not arg_6_1:isDevotionUnit() and not arg_6_1:isSpecialUnit() and not var_6_0
end

function UnitInfosUtil.isEnableAwake(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return false
	end
	
	if not arg_7_1:isAwakeUnit() then
		return false
	end
	
	if not TutorialGuide:isClearedTutorial("char_awake_unlock") then
		return false
	end
	
	if arg_7_1:isGrowthBoostRegistered() then
		return false
	end
	
	if arg_7_1:getZodiacGrade() < 6 then
		return false
	end
	
	return true
end

function UnitInfosUtil.isEnableUpgrade(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return false, nil
	end
	
	if not arg_8_1:isHaveDevote() then
		return false, "cant_memorize_hero"
	end
	
	if arg_8_1:isMoonlightDestinyUnit() then
		return false, "character_mc_hero_limit2"
	end
	
	if arg_8_1:isDevotionUnit() then
		return false, "cant_upgrade"
	end
	
	if arg_8_1:isMaxDevoteLevel() then
		return false, "cant_memorize"
	end
	
	return true, nil
end
