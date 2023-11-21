function Battle.onSummonZeonProc(arg_1_0, arg_1_1, arg_1_2, ...)
	print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% onSummonZeonProc", arg_1_1, arg_1_2, ...)
	
	if not arg_1_1 then
		return 
	end
	
	local function var_1_0(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = arg_2_2 or 0
		local var_2_1 = FADE_OUT
		
		if arg_2_1 then
			var_2_1 = FADE_IN
		end
		
		for iter_2_0, iter_2_1 in pairs(arg_2_0) do
			if not iter_2_1:isDead() and get_cocos_refid(iter_2_1.model) then
				BattleAction:Add(SEQ(SHOW(not arg_2_1), var_2_1(var_2_0), SHOW(arg_2_1)), iter_2_1.model)
			end
		end
	end
	
	local function var_1_1(arg_3_0, arg_3_1, arg_3_2)
		for iter_3_0, iter_3_1 in pairs(arg_3_0) do
			if not iter_3_1:isDead() and get_cocos_refid(iter_3_1.model) then
				BattleAction:Add(SEQ(MOTION(arg_3_1, arg_3_2)), iter_3_1.model)
			end
		end
	end
	
	local function var_1_2(arg_4_0)
		for iter_4_0, iter_4_1 in pairs(arg_4_0) do
			if get_cocos_refid(iter_4_1.model) then
				BattleAction:Add(Battle:getIdleAction(iter_4_1), iter_4_1.model)
			end
		end
	end
	
	local function var_1_3(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_3
		
		if arg_5_1 and arg_5_2 then
			local var_5_0 = BGI.main.tmp_layer
			
			if not get_cocos_refid(var_5_0) then
				var_5_0 = cc.Layer:create()
				BGI.main.tmp_layer = var_5_0
				
				BGI.main.layer:addChild(var_5_0)
			end
			
			local var_5_1, var_5_2 = BattleUtil:getCenterInitPos(arg_5_0)
			
			for iter_5_0, iter_5_1 in pairs(arg_5_0) do
				if get_cocos_refid(iter_5_1.model) and iter_5_1.model:getParent() ~= var_5_0 then
					iter_5_1.model:ejectFromParent()
					var_5_0:addChild(iter_5_1.model)
					iter_5_1.model:setPosition(iter_5_1.init_x - var_5_1, iter_5_1.init_y - var_5_2)
				end
			end
			
			BGI.main.tmp_layer:setScale(arg_5_1.scale)
			BGI.main.tmp_layer:setPosition(arg_5_1.x, arg_5_1.y)
			BattleAction:Add(LOG(MOVE_TO(arg_5_3 or 300, arg_5_2.x, arg_5_2.y), arg_5_4 or 40), BGI.main.tmp_layer)
		else
			var_5_3 = BGI.main.layer
			
			for iter_5_2, iter_5_3 in pairs(arg_5_0) do
				if get_cocos_refid(iter_5_3.model) then
					if iter_5_3.model:getParent() ~= var_5_3 then
						iter_5_3.model:ejectFromParent()
						var_5_3:addChild(iter_5_3.model)
					end
					
					iter_5_3.model:setPosition(iter_5_3.init_x, iter_5_3.init_y)
				end
			end
		end
	end
	
	local var_1_4 = arg_1_1.units
	
	if arg_1_2 == "start" then
	elseif arg_1_2 == "flying" then
		var_1_1(var_1_4.enemies, "flying", true)
	elseif arg_1_2 == "finish" then
		var_1_2(var_1_4.enemies)
	end
end

function Battle.toggleSummonReservation(arg_6_0)
	if not arg_6_0.logic:getSummonSkillUseInfo(FRIEND).useable then
		Log.d("debug", "아직 사용할수 없다.")
		
		return 
	end
	
	arg_6_0:setSummonReservation(not arg_6_0.vars.reserve_summon_skill)
	arg_6_0:startSummonSkill()
	
	return arg_6_0.vars.reserve_summon_skill
end

function Battle.setSummonReservation(arg_7_0, arg_7_1)
	arg_7_0.vars.reserve_summon_skill = arg_7_1
end

function Battle.isSummonReservationOn(arg_8_0)
	return arg_8_0.vars.reserve_summon_skill
end

function Battle.startSummonSkill(arg_9_0)
	local var_9_0 = arg_9_0.logic:getTurnOwner()
	
	if arg_9_0.vars.reserve_summon_skill and arg_9_0.logic:getTurnState() == "ready" and var_9_0 and FRIEND == var_9_0.inst.ally then
		arg_9_0.logic:command({
			cmd = "SummonSkill",
			ally = FRIEND
		})
		
		arg_9_0.vars.reserve_summon_skill = nil
		
		return true
	end
end

function Battle.onSummonSkill(arg_10_0, arg_10_1)
	Battle:highlightMainAttacker()
	
	if not get_cocos_refid(arg_10_1.model) then
		arg_10_1.model = CACHE:getModel(arg_10_1.db.model_id)
		arg_10_1.init_x = 0
		arg_10_1.init_y = 0
		arg_10_1.init_z = 0
		arg_10_1.x = 0
		arg_10_1.y = 0
		arg_10_1.z = 0
		
		BGI.main.layer:addChild(arg_10_1.model)
		arg_10_1.model:setVisible(false)
		
		function arg_10_1.model.setVisible()
		end
	end
	
	arg_10_1.model:setScaleX((Battle:isReverseDirection() and -1 or 1) * math.abs(arg_10_1.model:getScaleX()))
	
	local var_10_0 = arg_10_0.logic:getTurnOwner()
	
	Battle:playIdleAction(var_10_0)
	BattleTopBar:setVisible(false)
	BattleUI:setVisible(false)
	BattleUI:setVisibleSummonReservation()
	
	if arg_10_0:isTimeScaleMode() and arg_10_0:isTimeScaleUp() then
	else
		setenv("time_scale", 1)
	end
	
	if BattleUIAction:Find("battle.sinsu_tooltip") then
		BattleUIAction:Remove("battle.sinsu_tooltip")
	end
end
