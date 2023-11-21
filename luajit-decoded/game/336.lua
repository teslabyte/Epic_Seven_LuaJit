FormationBase = {}

function FormationBase.releaseModel(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 == 5 then
		if_set_visible(arg_1_0.vars.form_node, "n_no_sinsu", false)
	end
	
	if_set_visible(arg_1_0.vars.form_node, "info" .. arg_1_1, false)
	if_set_visible(arg_1_0.vars.form_node, "infoTag" .. arg_1_1, false)
	
	if not arg_1_0.vars.model_ids[arg_1_1] then
		return 
	end
	
	local var_1_0 = arg_1_0.vars.model_ids[arg_1_1].model
	local var_1_1 = -300
	local var_1_2 = 75
	
	if arg_1_0.vars.model_mode == "Sprite" or arg_1_0.vars.model_ids[arg_1_1].unit and arg_1_0.vars.model_ids[arg_1_1].unit:isSummon() then
		var_1_1 = -100
		var_1_2 = 100
	end
	
	if arg_1_2 and arg_1_2 > arg_1_0.vars.team_idx then
		var_1_1 = 0 - var_1_1
		var_1_2 = 0 - var_1_2
	end
	
	if not arg_1_2 and arg_1_2 == arg_1_0.vars.team_idx then
		var_1_1 = 0
		var_1_2 = 0
	end
	
	if var_1_0 then
		var_1_0:setLocalZOrder(1000)
		
		if arg_1_2 and (var_1_1 ~= 0 or var_1_2 ~= 0) then
			UIAction:Add(SEQ(LOG(SPAWN(MOVE_BY(300, var_1_1, var_1_2), FADE_OUT(300))), REMOVE(), CALL(arg_1_0.delModel, arg_1_0, var_1_0, arg_1_1)), var_1_0, "block")
		else
			var_1_0:removeFromParent()
			arg_1_0:delModel(var_1_0, arg_1_1)
		end
		
		arg_1_0.vars.model_ids[arg_1_1] = nil
	end
end

function FormationBase.updateHeroTag(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 == nil and arg_2_0.vars.model_ids[arg_2_1] then
		arg_2_2 = arg_2_0.vars.model_ids[arg_2_1].unit
	end
	
	if arg_2_2 == nil then
		return 
	end
	
	if_set_visible(arg_2_0.vars.form_node, "n_sick" .. arg_2_1, not arg_2_0.opts.disable_hp_info and arg_2_2:isGetInjured())
	if_set_visible(arg_2_0.vars.form_node, "n_eat" .. arg_2_1, not arg_2_0.opts.disable_hp_info and arg_2_2:isEating())
	if_set_visible(arg_2_0.vars.form_node, "n_work" .. arg_2_1, false)
	
	local var_2_0 = arg_2_0.vars.form_node:getChildByName("info" .. arg_2_1)
	
	if var_2_0 then
		var_2_0:setVisible(true)
		
		if var_2_0:getChildByName("n_lv") then
			UIUtil:setLevelDetail(var_2_0, arg_2_2:getLv(), arg_2_2:getMaxLevel())
			
			if arg_2_2:isGrowthBoostRegistered() then
				local var_2_1, var_2_2 = arg_2_2:getGrowthBoostLvAndMaxLv()
				
				UIUtil:setLevelDetail(var_2_0, var_2_1, var_2_2)
			end
		end
		
		if_set_sprite(var_2_0, "color", UIUtil:getColorIcon(arg_2_2))
		if_set_sprite(var_2_0, "role", "img/cm_icon_role_" .. arg_2_2.db.role .. ".png")
		
		local var_2_3 = var_2_0:getChildByName("name")
		
		if var_2_3 then
			local var_2_4 = T(arg_2_2.db.name)
			
			var_2_3:setString(var_2_4)
			UIUserData:proc(var_2_3)
		end
		
		if var_2_0.hp_bar then
			var_2_0.hp_bar:removeFromParent()
			
			var_2_0.hp_bar = nil
		end
		
		if not arg_2_0.opts.hide_hpbar and arg_2_2.db.code ~= "cleardummy" then
			local var_2_5 = -30
			local var_2_6 = arg_2_0:getModelHeight(arg_2_1) + 45
			
			if arg_2_1 == 3 then
				var_2_6 = math.clamp(var_2_6, 240, 280)
			end
			
			local var_2_7 = var_2_0:getChildByName("n_hp_pos")
			
			if var_2_7 then
				local var_2_8 = (arg_2_0.opts.story_powerup_units or {})[arg_2_2.db.code]
				local var_2_9 = arg_2_0.opts.disable_hp_info
				local var_2_10 = arg_2_2:isEating() and not var_2_9
				local var_2_11 = arg_2_0.opts.is_automaton
				local var_2_12 = false
				
				if arg_2_0.opts.is_unit_once then
					var_2_12 = Account:isMazeUsedUnit(arg_2_0.opts.map_id, arg_2_2:getUID())
				end
				
				var_2_0.hp_bar = UIUtil:getHPBar(arg_2_2, var_2_7, nil, var_2_9, arg_2_0.opts.hide_hpbar_color, var_2_8, var_2_10, var_2_11, var_2_12)
				
				if arg_2_2:isGrowthBoostRegistered() then
					local var_2_13 = arg_2_2:clone()
					
					GrowthBoost:apply(var_2_13)
					HPBar:updateMarks(var_2_0.hp_bar, var_2_13, {
						force = true
					})
				end
				
				var_2_0.hp_bar:setPosition(var_2_5, var_2_6)
			end
		end
		
		UIUtil:setStarsByUnit(var_2_0, arg_2_2, arg_2_1 > 1)
		
		if var_2_0:getChildByName("bg_subtask") then
			UIUtil:updateSubTaskSkillInfo(var_2_0, arg_2_2)
		end
		
		if arg_2_2:isEating() and not arg_2_0.opts.is_automaton then
			UIUtil:updateEatingEndTime(var_2_0, arg_2_2)
		end
		
		local var_2_14 = Account:getBattleTeam(arg_2_0.vars.team_idx)
		
		arg_2_2:onSetupTeam(var_2_14)
		UIUtil:setStoryBuffIcon(var_2_0, arg_2_2)
	end
	
	arg_2_0:updateHeroSimpleTag(arg_2_1, arg_2_2)
end

function FormationBase.updateHeroSimpleTag(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0.opts.useSimpleTag then
		return 
	end
	
	local var_3_0 = arg_3_0.vars.form_node:getChildByName("infoTag" .. arg_3_1)
	
	if not var_3_0 then
		return 
	end
	
	var_3_0:removeAllChildren()
	
	local var_3_1 = arg_3_0.vars.form_node:getChildByName("pos" .. arg_3_1):getScale()
	local var_3_2 = 0
	local var_3_3 = arg_3_0:getModelHeight(arg_3_1) * var_3_1 + (arg_3_0.opts.tagOffsetY or 0)
	local var_3_4 = load_control("wnd/icon_role_lv.csb")
	
	var_3_4:setAnchorPoint(0.5, 0.5)
	var_3_4:setScale(arg_3_0.opts.tagScale or 1)
	var_3_4:setPosition(var_3_2, var_3_3)
	var_3_0:addChild(var_3_4)
	var_3_0:setVisible(true)
	
	local var_3_5 = arg_3_2:getLv()
	local var_3_6 = arg_3_2:getMaxLevel()
	
	if arg_3_2:isGrowthBoostRegistered() then
		local var_3_7
		
		var_3_5, var_3_7 = arg_3_2:getGrowthBoostLvAndMaxLv()
	end
	
	if var_3_5 > 99 then
		if_set_visible(var_3_4, "99", true)
		if_set_visible(var_3_4, "l1", false)
	else
		if_set_visible(var_3_4, "99", false)
		if_set_sprite(var_3_4, "l2", "img/itxt_num" .. math.floor(var_3_5 / 10) .. "_b.png")
		if_set_sprite(var_3_4, "l1", "img/itxt_num" .. var_3_5 % 10 .. "_b.png")
	end
	
	if_set_sprite(var_3_4, "color", "img/game_hud_bar_" .. arg_3_2.db.color .. ".png")
	if_set_sprite(var_3_4, "role", "img/cm_icon_role_" .. arg_3_2.db.role .. ".png")
end

function FormationBase.getHiddenUnitIndex(arg_4_0)
	return arg_4_0.vars.hidden_unit_index
end

function FormationBase.playReadyAnimation(arg_5_0, arg_5_1)
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.model_ids) do
		local var_5_1 = iter_5_1.model.model
		
		var_5_1.sound_rate = 0
		
		table.push(var_5_0, var_5_1)
	end
	
	if arg_5_1 then
		table.shuffle(var_5_0)
		
		var_5_0[1].sound_rate = 1
	end
	
	for iter_5_2, iter_5_3 in pairs(arg_5_0.vars.model_ids) do
		local var_5_2 = iter_5_3.model.model
		
		if var_5_2.setAnimation then
			UIAction:Add(SEQ(DELAY(math.random(0, 100)), DMOTION("b_idle_ready"), MOTION("b_idle", true)), var_5_2, "block")
		end
	end
end

function FormationBase.getModel(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_2:isSummon() and arg_6_0.vars.model_mode ~= "Sprite" and arg_6_1 ~= arg_6_0:getHiddenUnitIndex() then
		local var_6_0 = cc.Node:create()
		
		var_6_0:setCascadeOpacityEnabled(true)
		
		var_6_0.model = CACHE:getModel(arg_6_2.db.model_id, arg_6_2.db.skin, nil, arg_6_2.db.atlas, arg_6_2.db.model_opt)
		
		var_6_0:addChild(var_6_0.model)
		
		if arg_6_0.opts.flip_model then
			var_6_0.model:setScaleX(0 - var_6_0.model:getScaleX())
		end
		
		if arg_6_0.opts.model_scale then
			var_6_0.model:setScaleX(var_6_0.model:getScaleX() * arg_6_0.opts.model_scale)
			var_6_0.model:setScaleY(var_6_0.model:getScaleY() * arg_6_0.opts.model_scale)
		end
		
		return var_6_0
	else
		local var_6_1
		local var_6_2
		local var_6_3 = false
		
		if arg_6_2:isSummon() then
			var_6_1 = to_n(arg_6_2:getSkillReqPoint(arg_6_2:getSkillByIndex(1)))
			var_6_1 = var_6_1 / 10
			var_6_2 = true
			var_6_3 = arg_6_0.opts.sinsu_block
		end
		
		local var_6_4 = arg_6_2:getLv()
		local var_6_5 = arg_6_2:getMaxLevel()
		local var_6_6 = arg_6_2:getGrade()
		local var_6_7 = arg_6_2:getZodiacGrade()
		local var_6_8 = arg_6_2:getAwakeGrade()
		
		if arg_6_2:isGrowthBoostRegistered() then
			local var_6_9 = arg_6_2:clone()
			
			GrowthBoost:apply(var_6_9)
			
			var_6_4 = var_6_9:getLv()
			var_6_5 = var_6_9:getMaxLevel()
			var_6_6 = var_6_9:getGrade()
			var_6_7 = var_6_9:getZodiacGrade()
		end
		
		local var_6_10 = UIUtil:getRewardIcon("c", arg_6_2:getDisplayCode(), {
			no_db_grade = true,
			role = true,
			no_popup = true,
			soul = var_6_2,
			souls = var_6_1,
			lv = var_6_4,
			max_lv = var_6_5,
			grade = var_6_6,
			zodiac = var_6_7,
			awake = var_6_8,
			is_enemy = arg_6_0.vars.is_enemy
		})
		
		if var_6_3 then
			var_6_10:setColor(cc.c3b(100, 100, 100))
		end
		
		return var_6_10
	end
end

function FormationBase.delModel(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2 ~= arg_7_0:getHiddenUnitIndex() and arg_7_0.vars.model_mode ~= "Sprite" then
		CACHE:releaseModel(arg_7_1.model)
	end
end

function FormationBase.getModelHeight(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.model_ids[arg_8_1].model
	
	if var_8_0 and var_8_0.model and var_8_0.model.getBonePosition then
		local var_8_1, var_8_2 = var_8_0.model:getBonePosition("top")
		
		return var_8_2
	end
	
	return 0
end

function FormationBase.setPetModelTo(arg_9_0, arg_9_1)
	if not get_cocos_refid(arg_9_0.vars.form_node) then
		return 
	end
	
	local var_9_0 = arg_9_0.vars.form_node:getChildByName("pos7")
	
	if not var_9_0 then
		print("Not Have Pos!")
	end
	
	var_9_0:removeAllChildren()
	
	if not arg_9_1 then
		return 
	end
	
	local var_9_1 = UIUtil:getRewardIcon(nil, arg_9_1:getDisplayCode(), {
		no_popup = true,
		role = true,
		no_db_grade = true,
		lv = arg_9_1:getLv(),
		max_lv = arg_9_1:getMaxLevel(),
		grade = arg_9_1:getGrade()
	})
	
	var_9_1:setName("model")
	var_9_0:addChild(var_9_1)
end

function FormationBase.setModelTo(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not get_cocos_refid(arg_10_0.vars.form_node) then
		return 
	end
	
	local var_10_0 = "pos" .. arg_10_1
	local var_10_1 = arg_10_0.vars.form_node:getChildByName(var_10_0)
	local var_10_2 = false
	
	if arg_10_0.vars.model_mode == "Sprite" then
		local var_10_3 = arg_10_0.vars.form_node:getChildByName("mob_icon" .. arg_10_1)
		
		if var_10_3 then
			var_10_1 = var_10_3
			var_10_2 = true
		end
	end
	
	if not var_10_1 then
		return 
	end
	
	if arg_10_2 == nil then
		arg_10_0:releaseModel(arg_10_1, arg_10_3)
		
		return 
	end
	
	if arg_10_1 == 5 then
		if_set_visible(arg_10_0.vars.form_node, "n_no_sinsu", false)
	end
	
	if arg_10_0.vars.model_ids[arg_10_1] == nil then
		arg_10_0.vars.model_ids[arg_10_1] = {}
	end
	
	if arg_10_2 == arg_10_0.vars.model_ids[arg_10_1].unit then
	end
	
	local var_10_4
	
	if arg_10_0.vars.model_ids[arg_10_1] then
		var_10_4 = arg_10_0.vars.model_ids[arg_10_1].unit
	end
	
	arg_10_0:releaseModel(arg_10_1, arg_10_3)
	
	local var_10_5 = 300
	local var_10_6 = -75
	
	if arg_10_0.vars.model_mode == "Sprite" or arg_10_2:isSummon() then
		var_10_5 = 100
		var_10_6 = -100
	end
	
	if arg_10_3 and arg_10_3 > arg_10_0.vars.team_idx then
		var_10_5 = 0 - var_10_5
		var_10_6 = 0 - var_10_6
	end
	
	if not arg_10_3 or arg_10_3 == arg_10_0.vars.team_idx then
		var_10_5 = 0
		var_10_6 = 0
	end
	
	local var_10_7 = var_10_1:getContentSize()
	local var_10_8 = arg_10_0:getModel(arg_10_1, arg_10_2)
	
	var_10_8:setName("model")
	
	if not arg_10_2:isSummon() and not arg_10_0.vars.model_mode ~= "Sprite" and arg_10_1 ~= arg_10_0:getHiddenUnitIndex() then
		if not var_10_2 then
			var_10_8:setScale(arg_10_2.db.scale * 1.6)
		end
	else
		var_10_8:setScale(1.3)
	end
	
	var_10_8:setPosition(var_10_7.width / 2 + var_10_5, var_10_7.height / 2 + var_10_6)
	var_10_8:setVisible(true)
	var_10_8:setOpacity(255)
	var_10_1:addChild(var_10_8)
	
	if arg_10_2.guest then
	end
	
	arg_10_0.vars.model_ids[arg_10_1] = {
		mode_id = arg_10_2.db.model_id,
		unit = arg_10_2,
		model = var_10_8,
		pos = var_10_1
	}
	
	if var_10_5 ~= 0 or var_10_6 ~= 0 then
		var_10_8:setOpacity(0)
		UIAction:Add(SEQ(SPAWN(LOG(MOVE_BY(300, -var_10_5, -var_10_6)), FADE_IN(200))), var_10_8, "block")
	end
	
	arg_10_0:updateHeroTag(arg_10_1, arg_10_2, var_10_4 ~= arg_10_2 or arg_10_3)
end
