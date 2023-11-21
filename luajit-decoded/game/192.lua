BattleDelay = {}
BattleDelay["@encounter_enemy"] = {}
BattleDelay["@encounter_enemy"].getDelay = function(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0
	local var_1_1 = 250
	local var_1_2 = 300
	local var_1_3 = 200
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1.enemies) do
		if iter_1_1:isBoss() then
			var_1_0 = 2500
			
			return 
		end
	end
	
	return var_1_0 + var_1_1 + var_1_2 + var_1_3
end
BattleDelay.attack = {}

function BattleDelay.attack.getDelay(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2.target:isIgnoreHitAction() then
		return 
	end
	
	if arg_2_2.cur_hit == arg_2_2.tot_hit then
		return 660
	else
		return 500
	end
end

BattleDelay["@skill_start"] = {}
BattleDelay["@skill_start"].getDelay = function(arg_3_0, arg_3_1, arg_3_2)
	if not get_cocos_refid(arg_3_1.dummy_scene) then
		local var_3_0 = cc.Layer:create()
		
		var_3_0:setName("dummyScene")
		var_3_0:retain()
		
		arg_3_1.dummy_scene = var_3_0
	end
	
	if not get_cocos_refid(arg_3_2.unit.model) then
		local var_3_1 = arg_3_2.unit.db.model_id
		local var_3_2 = arg_3_2.unit.db.model_opt
		local var_3_3 = arg_3_2.unit.db.skin
		local var_3_4 = arg_3_2.unit.db.atlas
		local var_3_5 = CACHE:getModel(var_3_1, var_3_3, "idle", var_3_4, var_3_2)
		
		arg_3_1.dummy_scene:addChild(var_3_5)
		var_3_5:setVisible(false)
		
		arg_3_2.unit.model = var_3_5
		
		arg_3_2.unit.model:setLuaTag({
			unit = arg_3_2.unit
		})
		BattleUtil:updateModel(arg_3_2.unit, "idle")
	end
	
	local var_3_6, var_3_7, var_3_8 = Battle:startSkillWithoutMotion(arg_3_1, arg_3_2.unit, arg_3_2.att_info)
	local var_3_9 = StageStateManager:enumStateTiming("HIT", var_3_6, var_3_8)
	local var_3_10 = 0
	
	if arg_3_2.att_info.coop_order == 1 and not table.empty(var_3_9) then
		arg_3_0.last_hit_timing = var_3_9[#var_3_9] - COOP_ATTACK_DELAY
	elseif arg_3_2.att_info.coop_order == 2 then
		var_3_10 = arg_3_0.last_hit_timing
		arg_3_0.last_hit_timing = 0
	else
		arg_3_0.last_hit_timing = 0
	end
	
	return var_3_7 + var_3_10 + 50 + 400
end
BattleDelay.appear = {}

function BattleDelay.appear.getDelay(arg_4_0, arg_4_1, arg_4_2)
	return 600, 100, 300, 200
end

BattleDelay.appear_by_tag = {}

function BattleDelay.appear_by_tag.getDelay(arg_5_0, arg_5_1, arg_5_2)
	return 1800, 1200, 600
end

BattleDelay.resurrect = {}

function BattleDelay.resurrect.getDelay(arg_6_0, arg_6_1, arg_6_2)
	return 1300, 1000, 300
end

BattleDelay.summon = {}

function BattleDelay.summon.getDelay(arg_7_0, arg_7_1, arg_7_2)
	return 760, 660, 100
end

BattleDelay.replace = {}

function BattleDelay.replace.getDelay(arg_8_0, arg_8_1, arg_8_2)
	return 100, 0, 100
end

BattleDelay.skip_turn = {}

function BattleDelay.skip_turn.getDelay(arg_9_0, arg_9_1, arg_9_2)
	return 1500
end

BattleDelay["@delay_skill"] = {}
BattleDelay["@delay_skill"].getDelay = function(arg_10_0, arg_10_1, arg_10_2)
	return arg_10_2.delay
end
