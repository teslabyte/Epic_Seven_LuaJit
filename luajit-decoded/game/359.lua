UnitUpgradeLogic = {}

function UnitUpgradeLogic.UpdateLevelInfo(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_2.g and arg_1_2.g ~= arg_1_1:getGrade()
	
	if var_1_0 then
		local var_1_1 = arg_1_1.inst.grade
		
		arg_1_1.inst.grade = arg_1_2.g
		
		arg_1_1:setExp(0)
		ConditionContentsManager:dispatch("unit.evoGrade", {
			grade = arg_1_2.g,
			chrid = arg_1_1.db.code,
			prev_grade = var_1_1
		})
		
		if arg_1_1.db.code == "c3026" then
			ConditionContentsManager:dispatch("c3026.evo.grade", {
				grade = arg_1_2.g,
				chrid = arg_1_1.db.code
			})
		end
	end
	
	local var_1_2 = arg_1_1:getLv()
	
	if arg_1_4 == "penguin" and arg_1_1:getEXP() < arg_1_2.exp then
		ConditionContentsManager:dispatch("penguin.upgrade", {
			count = arg_1_3
		})
	end
	
	if false then
	end
	
	if arg_1_2.exp then
		arg_1_1:setExp(arg_1_2.exp)
	end
	
	if arg_1_2.s then
		arg_1_1:setSkillLevelInfo(arg_1_2.s)
	end
	
	if var_1_2 ~= arg_1_1.inst.level and not var_1_0 then
		ConditionContentsManager:dispatch("unit.levelup", {
			level = arg_1_1.inst.lv,
			prev_level = var_1_2,
			grade = arg_1_2.g,
			chrid = arg_1_2.code
		})
		ConditionContentsManager:dispatch("growthboost.sync.lv")
		
		if arg_1_1.db.code == "c3026" then
			ConditionContentsManager:dispatch("c3026.levelup", {
				unit = arg_1_1
			})
		end
		
		if arg_1_4 == "penguin" and arg_1_1:isMaxLevel() then
			ConditionContentsManager:dispatch("penguin.maxlevel", {
				level = arg_1_1.inst.lv,
				prev_level = var_1_2,
				content = arg_1_4,
				unit = arg_1_1
			})
		end
	end
end

function UnitUpgradeLogic.UpdateZodiacInfo(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_2.z and arg_2_2.z ~= arg_2_1:getZodiacGrade() then
		local var_2_0 = arg_2_1.inst.zodiac
		
		arg_2_1.inst.zodiac = arg_2_2.z
		
		arg_2_1:updateZodiacSkills()
		arg_2_1:calc()
		Account:updateUnitByInfo(arg_2_2)
		ConditionContentsManager:dispatch("unit.zodiac", {
			unit = arg_2_1,
			grade = arg_2_1:getBaseGrade(),
			pre_level = var_2_0,
			level = arg_2_2.z
		})
		
		if arg_2_1.db.code == "c3026" then
			ConditionContentsManager:dispatch("c3026.zodiac", {
				unit = arg_2_1
			})
		end
	end
end

function UnitUpgradeLogic.UpdateDevote(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0, var_3_1 = arg_3_1:getDevoteGrade()
	local var_3_2, var_3_3 = arg_3_1:getDevoteGrade(arg_3_2.d)
	
	if var_3_0 ~= var_3_2 and not arg_3_1:isPromotionUnit() then
		local var_3_4 = false
		
		for iter_3_0, iter_3_1 in pairs(arg_3_3) do
			if arg_3_1:isDevotionUpgradable(iter_3_1, true) and iter_3_1:isMaxDevoteLevel() then
				var_3_4 = true
			end
		end
		
		if not var_3_4 then
			ConditionContentsManager:dispatch("devote.levelup", {
				devote = var_3_3,
				prev_devote = var_3_1,
				uid = arg_3_1.inst.uid
			})
		end
		
		if arg_3_1.db.code == "c3026" then
			ConditionContentsManager:dispatch("c3026.dvt.grade", {
				devote = var_3_3,
				chrid = arg_3_1.db.code
			})
		end
		
		return true
	end
	
	return false
end

function UnitUpgradeLogic.UpdateImprintFocus(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1:getUnitOptionIndex("imprint_focus")
	
	if arg_4_1:getUnitOptionValue("imprint_focus") == 0 and to_n(string.sub(string.format("%010d", to_n(arg_4_2.opt)), var_4_0, var_4_0)) > 0 then
		arg_4_1:updateUnitOptionValue(arg_4_2.opt)
		
		return true
	end
	
	return false
end

function UnitUpgradeLogic.UpdateAccountUnitInfo(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_1:reset()
	
	if arg_5_1:getLv() ~= arg_5_3 then
		Account:onUpdateUnitLevel(arg_5_1, arg_5_3)
	end
	
	Account:updateUnitByInfo(arg_5_2)
end

function UnitUpgradeLogic.UpdateAccountData(arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0, iter_6_1 in pairs(arg_6_2 or {}) do
		Account:removeUnit(iter_6_1)
	end
	
	Account:setCurrency("gold", arg_6_1.gold)
	TopBarNew:topbarUpdate(true)
end
