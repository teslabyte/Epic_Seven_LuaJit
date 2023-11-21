function logic_shuffle(arg_1_0, arg_1_1)
	local var_1_0 = #arg_1_0
	
	if var_1_0 < 2 then
		return arg_1_0
	end
	
	for iter_1_0 = 1, var_1_0 do
		local var_1_1 = arg_1_1:get(1, var_1_0)
		
		arg_1_0[var_1_1], arg_1_0[iter_1_0] = arg_1_0[iter_1_0], arg_1_0[var_1_1]
	end
	
	return arg_1_0
end

AIHandler = {}
AIHandler.AI_HANDER_BANSHEE_QUE = {}

function AIHandler.AI_HANDER_BANSHEE_QUE(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == "start_turn" then
		if arg_2_0:isConcentration() and #arg_2_0.logic:pickUnits(arg_2_0, FRIEND, arg_2_0) == 0 then
			arg_2_0.states:removeByCondition(arg_2_2, function(arg_3_0)
				return arg_3_0.db.cs_type == "concentration"
			end)
			
			if arg_2_0 ~= arg_2_0.logic:getTurnOwner() then
				arg_2_0.logic:addNextTurnOwner(arg_2_0, {
					front = true
				})
			end
		end
	elseif arg_2_1 == "end_turn" then
		for iter_2_0, iter_2_1 in pairs(arg_2_2) do
			if iter_2_1.type == "remove_state" and iter_2_1.state.db.cs_type == "concentration" then
				arg_2_0.logic:addNextTurnOwner(arg_2_0, {
					skill_id = "sk_m9171_7",
					front = true
				})
			end
		end
	end
end

AIManager = {}

function AIManager.isActivate(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.logic
	
	if not arg_4_3:checkUseSkill() then
		return false
	end
	
	local var_4_1 = arg_4_3._skill_id
	
	if #var_4_0:getTargetCandidates(arg_4_4, arg_4_2) == 0 then
		return false
	end
	
	local var_4_2 = var_4_0:getSkill_AI_ID(arg_4_2, arg_4_4 or var_4_1)
	local var_4_3 = DBT("skill_ai", var_4_2, {
		"activate1",
		"activate2",
		"activate_value1",
		"activate_value2",
		"rate"
	})
	local var_4_4 = false
	
	for iter_4_0 = 1, 2 do
		local var_4_5 = var_4_3["activate" .. iter_4_0]
		local var_4_6 = var_4_3["activate_value" .. iter_4_0]
		local var_4_7 = ""
		
		if not var_4_5 then
			var_4_7 = string.format("%s(%s) ai condition is empty : colum (%s), skill (%s), ai (%s)", arg_4_2:getName(), arg_4_2.inst.code, "activate" .. iter_4_0, arg_4_4 or var_4_1, var_4_2)
		elseif not AIUtil[var_4_5] then
			var_4_7 = string.format("%s(%s) ai was not developed : condition (%s), skill (%s), ai (%s)", arg_4_2:getName(), arg_4_2.inst.code, var_4_5, arg_4_4 or var_4_1, var_4_2)
		end
		
		if string.len(var_4_7) > 0 then
			if PLATFORM == "win32" and not IS_TOOL_MODE then
				__G__TRACKBACK__(var_4_7)
			end
			
			return true
		end
		
		if AIUtil[var_4_5](var_4_0, arg_4_2, var_4_6) then
			var_4_4 = true
		end
	end
	
	if not var_4_4 then
		return false
	end
	
	if var_4_3.rate and arg_4_1:get() > var_4_3.rate / 100 then
		return false
	end
	
	return true
end

function AIManager.bindUnitAIHandler(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.inst.code
	local var_5_1 = DB("character_ai", var_5_0, "ai_handler") or ""
	
	arg_5_1.inst.ai_handler = AIHandler[var_5_1]
end

function AIManager.procUnitAI(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		if iter_6_1.inst.ai_handler then
			iter_6_1.inst.ai_handler(iter_6_1, arg_6_2, arg_6_3)
		end
	end
end

function AIManager.getTarget(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.logic
	local var_7_1
	local var_7_2 = var_7_0:getSkill_AI_ID(arg_7_2, arg_7_3)
	
	arg_7_4 = logic_shuffle(arg_7_4, arg_7_1)
	
	for iter_7_0 = 1, 5 do
		local var_7_3, var_7_4, var_7_5 = DB("skill_ai", var_7_2, {
			"target" .. iter_7_0,
			"target_value" .. iter_7_0,
			"target_rate" .. iter_7_0
		})
		
		var_7_5 = var_7_5 or 1
		
		if var_7_5 > arg_7_1:get() then
			if var_7_3 and TargetSelectUtil[var_7_3] then
				local var_7_6 = TargetSelectUtil[var_7_3](arg_7_2, arg_7_4, var_7_4, arg_7_3)
				
				if not table.empty(var_7_6) then
					Log.d("AI", "타겟 필터 :", iter_7_0, var_7_3, var_7_4)
					
					for iter_7_1, iter_7_2 in pairs(var_7_6) do
						Log.d("AI", " -", iter_7_2.db.name)
					end
					
					arg_7_4 = var_7_6
				end
			else
				Log.d("AI", "필터 존재 안함:", iter_7_0, var_7_3, var_7_4)
			end
		end
		
		if #arg_7_4 <= 1 then
			break
		end
	end
	
	if #arg_7_4 == 1 then
		var_7_1 = arg_7_4[1]
		
		Log.d("AI", "최종 선택 대상 : ", var_7_1.db.name)
	end
	
	if not var_7_1 then
		local var_7_7 = {
			front = {},
			back = {}
		}
		
		for iter_7_3, iter_7_4 in pairs(arg_7_4) do
			table.insert(var_7_7[iter_7_4.inst.line], iter_7_4)
		end
		
		var_7_1 = arg_7_4[arg_7_1:get(1, #arg_7_4)]
	end
	
	return var_7_1
end

function AIManager.selectSkillIdxAndTarget(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.logic
	local var_8_1
	local var_8_2 = 1
	local var_8_3 = arg_8_2:getSkillSequencer()
	
	if var_8_3 then
		var_8_2 = var_8_3:getCurrentSkillNumber()
	else
		local var_8_4 = {
			3,
			2,
			1
		}
		
		if arg_8_2.db.priority_skill == 2 then
			var_8_4 = {
				2,
				3,
				1
			}
		end
		
		for iter_8_0, iter_8_1 in pairs(var_8_4) do
			local var_8_5 = arg_8_2:getSkillBundle():selectAvailable():slot(iter_8_1)
			
			if var_8_5:assigned() and var_8_5:getShow() and not var_8_5:getPassive() then
				local var_8_6 = AIManager:isActivate(arg_8_1, arg_8_2, var_8_5, arg_8_2:getSkillBundle():slot(iter_8_1):getSkillId())
				
				Log.d("LOGIC", "AI 스킬 필터 :", iter_8_1, var_8_5._skill_id, var_8_6)
				
				if var_8_6 then
					var_8_2 = iter_8_1
					
					break
				end
			end
		end
	end
	
	local var_8_7 = arg_8_2:getSkillBundle():slot(var_8_2):getSkillId()
	
	if arg_8_2:getProvoker() or not arg_8_2:getAutoSkillFlag() and arg_8_5 ~= true then
		var_8_7 = arg_8_2:getSkillBundle():slot(1):getSkillId()
	end
	
	if arg_8_4 then
		var_8_7 = arg_8_4
	end
	
	local var_8_8 = arg_8_2:getSkillBundle():indexOf(var_8_7)
	local var_8_9, var_8_10 = var_8_0:getTargetCandidates(var_8_7, arg_8_2)
	
	Log.d("LOGIC", "AI_SelectSkillIdxAndTarget 스킬선택!", arg_8_2.db.name, var_8_8, var_8_7)
	
	local var_8_11 = arg_8_2:getProvoker()
	
	if not var_8_11 then
		if arg_8_3 and arg_8_3.inst.ally == var_8_10 and arg_8_2.inst.ally == FRIEND then
			var_8_1 = arg_8_3
			
			Log.d("LOGIC", "전투", "자동타겟 설정")
		end
	else
		var_8_1 = var_8_11
		
		Log.d("LOGIC", "전투", "도발에 걸려서 자동타겟 무시")
	end
	
	if var_8_1 == nil then
		var_8_1 = AIManager:getTarget(arg_8_1, arg_8_2, var_8_7, var_8_9)
	end
	
	local var_8_12 = var_8_0:getTargetCandidates(var_8_7, arg_8_2, var_8_1)
	local var_8_13 = table.alignment_clone(var_8_12)
	
	table.convert(var_8_13, function(arg_9_0, arg_9_1)
		return ("%s[%d]"):format(arg_9_1.db.name, arg_9_1.inst.uid)
	end)
	Log.d("LOGIC", "skill", "-- sk_target", table.toCommaStr(var_8_13))
	
	return var_8_8, var_8_7, var_8_12, var_8_1
end

AIUtil = {}

function AIUtil.PASS(arg_10_0, arg_10_1, arg_10_2)
	return true
end

function AIUtil.BLOCK(arg_11_0, arg_11_1, arg_11_2)
	return false
end

function AIUtil.selfhpdown(arg_12_0, arg_12_1, arg_12_2)
	return arg_12_1:getHPRatio() <= arg_12_2 / 100
end

function AIUtil.selfhpup(arg_13_0, arg_13_1, arg_13_2)
	return arg_13_1:getHPRatio() >= arg_13_2 / 100
end

function AIUtil.selfcson(arg_14_0, arg_14_1, arg_14_2)
	return arg_14_1:checkState(arg_14_2)
end

function AIUtil.selfcsoff(arg_15_0, arg_15_1, arg_15_2)
	return not arg_15_1:checkState(arg_15_2)
end

function AIUtil._allycson(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0:pickUnits(arg_16_1, arg_16_3)
	
	if #var_16_0 > 0 then
		for iter_16_0, iter_16_1 in pairs(var_16_0) do
			if iter_16_1:checkState(arg_16_2) then
				return true
			end
		end
	end
end

function AIUtil._allycsoff(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0:pickUnits(arg_17_1, arg_17_3)
	
	if #var_17_0 > 0 then
		for iter_17_0, iter_17_1 in pairs(var_17_0) do
			if not iter_17_1:checkState(arg_17_2) then
				return true
			end
		end
	end
end

function AIUtil._allyhp(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_0:pickUnits(arg_18_1, arg_18_3, nil, arg_18_4)
	
	if #var_18_0 > 0 and arg_18_2 then
		for iter_18_0, iter_18_1 in pairs(var_18_0) do
			if iter_18_1:getHPRatio() <= arg_18_2 / 100 then
				return true
			end
		end
	end
end

function AIUtil.allycson(arg_19_0, arg_19_1, arg_19_2)
	return AIUtil._allycson(arg_19_0, arg_19_1, arg_19_2, FRIEND)
end

function AIUtil.allycsoff(arg_20_0, arg_20_1, arg_20_2)
	return AIUtil._allycsoff(arg_20_0, arg_20_1, arg_20_2, FRIEND)
end

function AIUtil.allyhp(arg_21_0, arg_21_1, arg_21_2)
	return AIUtil._allyhp(arg_21_0, arg_21_1, arg_21_2, FRIEND)
end

function AIUtil.allyhp_inc_dead(arg_22_0, arg_22_1, arg_22_2)
	return AIUtil._allyhp(arg_22_0, arg_22_1, arg_22_2, FRIEND, true)
end

function AIUtil.enemycson(arg_23_0, arg_23_1, arg_23_2)
	return AIUtil._allycson(arg_23_0, arg_23_1, arg_23_2, ENEMY)
end

function AIUtil.enemycsoff(arg_24_0, arg_24_1, arg_24_2)
	return AIUtil._allycsoff(arg_24_0, arg_24_1, arg_24_2, ENEMY)
end

function AIUtil.enemyhp(arg_25_0, arg_25_1, arg_25_2)
	return AIUtil._allyhp(arg_25_0, arg_25_1, arg_25_2, ENEMY)
end

function AIUtil.enemyhp_inc_dead(arg_26_0, arg_26_1, arg_26_2)
	return AIUtil._allyhp(arg_26_0, arg_26_1, arg_26_2, ENEMY, true)
end

function AIUtil.turn_cool(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_2 and arg_27_2 <= arg_27_1:getBattleTurnCount() then
		return true
	end
end

function AIUtil._hasTeamCool(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_0:pickUnits(arg_28_1, arg_28_3, arg_28_4)
	
	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		for iter_28_2, iter_28_3 in ipairs(iter_28_1:getSkillBundle():toSkills()) do
			if not iter_28_3:getPassive() and iter_28_3:assigned() and iter_28_2 > 1 then
				local var_28_1 = iter_28_3:getOriginSkillId()
				
				if iter_28_1:getSkillCool(var_28_1) > 0 then
					return true
				end
			end
		end
	end
end

function AIUtil.allycooltime(arg_29_0, arg_29_1, arg_29_2)
	return AIUtil._hasTeamCool(arg_29_0, arg_29_1, arg_29_2, FRIEND)
end

function AIUtil.allycooltime_notself(arg_30_0, arg_30_1, arg_30_2)
	return AIUtil._hasTeamCool(arg_30_0, arg_30_1, arg_30_2, FRIEND, arg_30_1)
end

function AIUtil.enemycooltime(arg_31_0, arg_31_1, arg_31_2)
	return AIUtil._hasTeamCool(arg_31_0, arg_31_1, arg_31_2, ENEMY)
end

function AIUtil.enemycooltime_notself(arg_32_0, arg_32_1, arg_32_2)
	return AIUtil._hasTeamCool(arg_32_0, arg_32_1, arg_32_2, ENEMY, arg_32_1)
end

function AIUtil.allydebuff(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0:pickUnits(arg_33_1, FRIEND)
	
	if #var_33_0 > 0 then
		for iter_33_0, iter_33_1 in pairs(var_33_0) do
			if iter_33_1.states:getTypeCount("debuff") > 0 then
				return true
			end
		end
	end
end

function AIUtil._hasStateTypeInAlly(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = arg_34_0:pickUnits(arg_34_1, arg_34_3)
	
	if #var_34_0 > 0 then
		for iter_34_0, iter_34_1 in pairs(var_34_0) do
			if iter_34_1.states:getTypeCount(arg_34_4) > 0 then
				return true
			end
		end
	end
end

function AIUtil.allybuff(arg_35_0, arg_35_1, arg_35_2)
	return AIUtil._hasStateTypeInAlly(arg_35_0, arg_35_1, arg_35_2, FRIEND, "buff")
end

function AIUtil.enemybuff(arg_36_0, arg_36_1, arg_36_2)
	return AIUtil._hasStateTypeInAlly(arg_36_0, arg_36_1, arg_36_2, ENEMY, "buff")
end

function AIUtil.allydebuff(arg_37_0, arg_37_1, arg_37_2)
	return AIUtil._hasStateTypeInAlly(arg_37_0, arg_37_1, arg_37_2, FRIEND, "debuff")
end

function AIUtil.enemydebuff(arg_38_0, arg_38_1, arg_38_2)
	return AIUtil._hasStateTypeInAlly(arg_38_0, arg_38_1, arg_38_2, ENEMY, "debuff")
end

function AIUtil.selfresource(arg_39_0, arg_39_1, arg_39_2)
	return arg_39_1:getSPRatio() >= (arg_39_2 or 0.5)
end

function AIUtil.enemy_csid1on_without_csid2(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0:pickUnits(arg_40_1, ENEMY)
	local var_40_2, var_40_3, var_40_4
	
	if #var_40_0 > 0 then
		local var_40_1 = totable(arg_40_2)
		
		var_40_2 = var_40_1.csid1
		var_40_3 = var_40_1.csid2
		var_40_4 = false
		
		if type(var_40_3) == "table" then
			var_40_4 = true
		end
		
		for iter_40_0, iter_40_1 in pairs(var_40_0) do
			if iter_40_1.states:find(var_40_2) then
				local var_40_5 = true
				
				if var_40_4 then
					for iter_40_2, iter_40_3 in pairs(var_40_3) do
						if iter_40_1.states:find(iter_40_3) then
							var_40_5 = false
							
							break
						end
					end
				elseif iter_40_1.states:find(var_40_3) then
					var_40_5 = false
				end
				
				if var_40_5 then
					return true
				end
			end
		end
	end
	
	return false
end

function AIUtil.enemy_hp_without_csid(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0:pickUnits(arg_41_1, ENEMY)
	local var_41_2, var_41_3, var_41_4
	
	if #var_41_0 > 0 then
		local var_41_1 = totable(arg_41_2)
		
		var_41_2 = var_41_1.csid
		var_41_3 = to_n(var_41_1.value) / 100
		var_41_4 = false
		
		if type(var_41_2) == "table" then
			var_41_4 = true
		end
		
		for iter_41_0, iter_41_1 in pairs(var_41_0) do
			if var_41_3 >= iter_41_1:getHPRatio() then
				local var_41_5 = true
				
				if var_41_4 then
					for iter_41_2, iter_41_3 in pairs(var_41_2) do
						if iter_41_1.states:find(iter_41_3) then
							var_41_5 = false
							
							break
						end
					end
				elseif iter_41_1.states:find(var_41_2) then
					var_41_5 = false
				end
				
				if var_41_5 then
					return true
				end
			end
		end
	end
	
	return false
end

TargetSelectUtil = {}

function TargetSelectUtil.cs_stack(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = {}
	local var_42_1 = 0
	
	for iter_42_0, iter_42_1 in pairs(arg_42_1) do
		if not iter_42_1:isDead() then
			local var_42_2 = iter_42_1.states:findById(arg_42_2)
			
			if var_42_2 and var_42_1 <= var_42_2.stack_count then
				if var_42_1 < var_42_2.stack_count then
					var_42_0 = {}
				end
				
				var_42_1 = var_42_2.stack_count
				
				table.insert(var_42_0, iter_42_1)
			end
		end
	end
	
	return var_42_0
end

function TargetSelectUtil.dead(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = {}
	
	for iter_43_0, iter_43_1 in pairs(arg_43_1) do
		if iter_43_1:isDead() and not iter_43_1:getResurrectBlock() then
			table.insert(var_43_0, iter_43_1)
		end
	end
	
	return var_43_0
end

function TargetSelectUtil.alive(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = {}
	
	for iter_44_0, iter_44_1 in pairs(arg_44_1) do
		if not iter_44_1:isDead() then
			table.insert(var_44_0, iter_44_1)
		end
	end
	
	return var_44_0
end

function TargetSelectUtil.losthp(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0
	
	for iter_45_0, iter_45_1 in pairs(arg_45_1) do
		local var_45_1 = iter_45_1:getHPRatio()
		
		if (not arg_45_2 or arg_45_2 <= var_45_1) and (not var_45_0 or var_45_1 < var_45_0.hp) then
			var_45_0 = {
				hp = var_45_1,
				unit = iter_45_1
			}
		end
	end
	
	return {
		(var_45_0 or {}).unit
	}
end

function TargetSelectUtil.formation(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0
	
	arg_46_2 = arg_46_2 or FRONT
	
	local var_46_1 = {}
	
	for iter_46_0, iter_46_1 in pairs(arg_46_1) do
		if arg_46_2 == iter_46_1.inst.line then
			table.insert(var_46_1, iter_46_1)
		end
	end
	
	return var_46_1
end

function TargetSelectUtil.formation_number(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0
	
	arg_47_2 = tonumber(arg_47_2) or 1
	
	local var_47_1 = {}
	
	for iter_47_0, iter_47_1 in pairs(arg_47_1) do
		if arg_47_2 == iter_47_1.inst.pos then
			table.insert(var_47_1, iter_47_1)
		end
	end
	
	return var_47_1
end

function TargetSelectUtil.attribute(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0
	local var_48_1 = {}
	local var_48_2 = false
	
	for iter_48_0, iter_48_1 in pairs(arg_48_1) do
		local var_48_3 = arg_48_0:isStrongAgainst(iter_48_1, arg_48_3)
		local var_48_4 = arg_48_0:isWeaknessAgainst(iter_48_1, arg_48_3)
		
		if var_48_3 then
			if not var_48_2 then
				var_48_1 = {}
				var_48_2 = true
			end
			
			table.insert(var_48_1, iter_48_1)
		elseif not var_48_4 and not var_48_2 then
			table.insert(var_48_1, iter_48_1)
		end
	end
	
	return var_48_1 or {}
end

function TargetSelectUtil.debuff(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0
	local var_49_1 = {}
	
	for iter_49_0, iter_49_1 in pairs(arg_49_1) do
		if iter_49_1.states:getTypeCount("debuff") > 0 then
			table.insert(var_49_1, iter_49_1)
		end
	end
	
	return var_49_1
end

function TargetSelectUtil.buff(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0
	local var_50_1 = {}
	
	for iter_50_0, iter_50_1 in pairs(arg_50_1) do
		if iter_50_1.states:getTypeCount("buff") > 0 then
			table.insert(var_50_1, iter_50_1)
		end
	end
	
	return var_50_1
end

function TargetSelectUtil.cson(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0
	local var_51_1 = {}
	
	if not arg_51_2 then
		return var_51_1
	end
	
	for iter_51_0, iter_51_1 in pairs(arg_51_1) do
		if iter_51_1:checkState(arg_51_2) then
			table.insert(var_51_1, iter_51_1)
		end
	end
	
	return var_51_1
end

function TargetSelectUtil.csoff(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0
	local var_52_1 = {}
	
	if not arg_52_2 then
		return var_52_1
	end
	
	for iter_52_0, iter_52_1 in pairs(arg_52_1) do
		if not iter_52_1:checkState(arg_52_2) then
			table.insert(var_52_1, iter_52_1)
		end
	end
	
	return var_52_1
end

function TargetSelectUtil.status(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = {}
	local var_53_1
	
	for iter_53_0, iter_53_1 in pairs(arg_53_1) do
		local var_53_2 = iter_53_1:getStatus().att
		
		if not var_53_1 or var_53_1 <= var_53_2 then
			if var_53_1 ~= var_53_2 then
				var_53_0 = {}
				var_53_1 = var_53_2
			end
			
			table.insert(var_53_0, iter_53_1)
		end
	end
	
	return var_53_0
end

function TargetSelectUtil.boss(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0 = {
		boss = {
			priority = 1,
			bucket = {}
		},
		subboss = {
			priority = 2,
			bucket = {}
		},
		elite = {
			priority = 3,
			bucket = {}
		},
		normal = {
			priority = 4,
			bucket = {}
		},
		etc = {
			priority = 5,
			bucket = {}
		}
	}
	local var_54_1
	local var_54_2
	
	for iter_54_0, iter_54_1 in pairs(arg_54_1) do
		local var_54_3 = DB("character", iter_54_1.db.code, "monster_tier") or "normal"
		local var_54_4 = var_54_0[var_54_3]
		
		if not var_54_4 then
			var_54_4 = var_54_0.etc
			var_54_3 = "etc"
		end
		
		local var_54_5 = var_54_4.priority
		
		if not var_54_1 or var_54_5 < var_54_1 then
			var_54_1 = var_54_5
			var_54_2 = var_54_3
		end
		
		table.insert(var_54_4.bucket, iter_54_1)
	end
	
	if not var_54_2 then
		return {}
	else
		return var_54_0[var_54_2].bucket
	end
end

function TargetSelectUtil.nowhp(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = {}
	local var_55_1
	
	for iter_55_0, iter_55_1 in pairs(arg_55_1) do
		local var_55_2 = iter_55_1:getHP()
		
		if not var_55_1 or var_55_1 <= var_55_2 then
			if var_55_1 ~= var_55_2 then
				var_55_1 = var_55_2
				var_55_0 = {}
			end
			
			table.insert(var_55_0, iter_55_1)
		end
	end
	
	return var_55_0
end

function TargetSelectUtil.max_hp(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = {}
	local var_56_1
	
	for iter_56_0, iter_56_1 in pairs(arg_56_1) do
		local var_56_2 = iter_56_1:getMaxHP()
		
		if not var_56_1 or var_56_1 <= var_56_2 then
			if var_56_1 ~= var_56_2 then
				var_56_1 = var_56_2
				var_56_0 = {}
			end
			
			table.insert(var_56_0, iter_56_1)
		end
	end
	
	return var_56_0
end

function TargetSelectUtil.actionbarhigh(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	local var_57_0 = {}
	local var_57_1
	
	for iter_57_0, iter_57_1 in pairs(arg_57_1) do
		if iter_57_1 ~= arg_57_0 then
			local var_57_2 = math.min(iter_57_1.inst.elapsed_ut, MAX_UNIT_TICK)
			
			if not var_57_1 or var_57_1 <= var_57_2 then
				if var_57_1 ~= var_57_2 then
					var_57_1 = var_57_2
					var_57_0 = {}
				end
				
				table.insert(var_57_0, iter_57_1)
			end
		end
	end
	
	return var_57_0
end

function TargetSelectUtil.actionbarlow(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = {}
	local var_58_1
	
	for iter_58_0, iter_58_1 in pairs(arg_58_1) do
		if iter_58_1 ~= arg_58_0 then
			local var_58_2 = math.min(iter_58_1.inst.elapsed_ut, MAX_UNIT_TICK)
			
			if not var_58_1 or var_58_2 <= var_58_1 then
				if var_58_1 ~= var_58_2 then
					var_58_1 = var_58_2
					var_58_0 = {}
				end
				
				table.insert(var_58_0, iter_58_1)
			end
		end
	end
	
	return var_58_0
end

function TargetSelectUtil.actionbar(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	if arg_59_2 and TargetSelectUtil["actionbar" .. arg_59_2] then
		return TargetSelectUtil["actionbar" .. arg_59_2](arg_59_0, arg_59_1)
	end
	
	return {}
end

function TargetSelectUtil._cooltime(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	local var_60_0 = {}
	
	for iter_60_0, iter_60_1 in pairs(arg_60_1) do
		local var_60_1 = false
		
		for iter_60_2, iter_60_3 in ipairs(iter_60_1:getSkillBundle():toSkills()) do
			local var_60_2 = true
			
			if not arg_60_4 and iter_60_3:getPassive() then
				var_60_2 = false
			end
			
			if iter_60_3:assigned() and var_60_2 then
				local var_60_3 = iter_60_3:getOriginSkillId()
				
				if iter_60_1:getSkillCool(var_60_3) > 0 then
					var_60_1 = true
				end
			end
		end
		
		if var_60_1 then
			table.insert(var_60_0, iter_60_1)
		end
	end
	
	return var_60_0
end

function TargetSelectUtil.cooltime(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	return TargetSelectUtil._cooltime(arg_61_0, arg_61_1, arg_61_2, arg_61_3, false)
end

function TargetSelectUtil.cooltime_incl_passive(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	return TargetSelectUtil._cooltime(arg_62_0, arg_62_1, arg_62_2, arg_62_3, true)
end

function TargetSelectUtil.attack_high(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0 = {}
	
	for iter_63_0, iter_63_1 in pairs(arg_63_1) do
		local var_63_1 = iter_63_1:getStatus()
		
		if table.empty(var_63_0) or var_63_0.att < var_63_1.att then
			var_63_0 = {
				unit = iter_63_1,
				att = var_63_1.att
			}
		end
	end
	
	return {
		var_63_0.unit
	}
end

function TargetSelectUtil.role(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0 = {}
	local var_64_1 = string.split(arg_64_2 or "", ",")
	
	for iter_64_0, iter_64_1 in pairs(arg_64_1) do
		if table.isInclude(var_64_1, iter_64_1.db.role) then
			table.insert(var_64_0, iter_64_1)
		end
	end
	
	return var_64_0
end

function TargetSelectUtil.not_self(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	local var_65_0 = {}
	
	for iter_65_0, iter_65_1 in pairs(arg_65_1) do
		if iter_65_1 ~= arg_65_0 then
			table.insert(var_65_0, iter_65_1)
		end
	end
	
	if table.count(var_65_0) == 0 then
		table.insert(var_65_0, arg_65_0)
	end
	
	return var_65_0
end

SkillSequencer = ClassDef()

function SkillSequencer.constructor(arg_66_0, arg_66_1)
	arg_66_0.owner = arg_66_1.unit
	arg_66_0.code = arg_66_1.code
	arg_66_0.curr_index = 1
	
	local var_66_0 = DB("character", arg_66_0.code, "use_in_order")
	
	arg_66_0.skill_list = string.split(var_66_0, ",")
	arg_66_0.use_in_order = var_66_0
end

function SkillSequencer.reset(arg_67_0)
	arg_67_0.curr_index = 1
end

function SkillSequencer.getCurrentOrder(arg_68_0)
	return arg_68_0.curr_index
end

function SkillSequencer.getCurrentSkillNumber(arg_69_0)
	return tonumber(arg_69_0.skill_list[arg_69_0.curr_index]) or 1
end

function SkillSequencer.getCurrentSkillID(arg_70_0)
	return arg_70_0.owner:getSkillBundle():slot(arg_70_0:getCurrentSkillNumber()):getSkillId()
end

function SkillSequencer.next(arg_71_0)
	arg_71_0.curr_index = arg_71_0.curr_index + 1
	
	if arg_71_0.curr_index > table.count(arg_71_0.skill_list) then
		arg_71_0.curr_index = 1
	end
	
	return arg_71_0:getCurrentSkillNumber()
end

function SkillSequencer.getList(arg_72_0)
	return arg_72_0.skill_list
end

UnitSkillSequencer = {}

function UnitSkillSequencer.get(arg_73_0, arg_73_1)
	local var_73_0 = arg_73_1.inst.code
	
	if not DB("character", var_73_0, "use_in_order") then
		return 
	end
	
	return SkillSequencer({
		unit = arg_73_1,
		code = var_73_0
	})
end

function UnitSkillSequencer.onEndTurn(arg_74_0, arg_74_1)
	if not arg_74_1 then
		return 
	end
	
	local var_74_0 = arg_74_1:getSkillSequencer()
	
	if var_74_0 and arg_74_1.inst.use_skill == var_74_0:getCurrentSkillID() then
		var_74_0:next()
	end
end
