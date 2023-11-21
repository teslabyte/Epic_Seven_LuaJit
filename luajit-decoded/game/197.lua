HPBar = {}

function HANDLER_BEFORE.hpbar_boss(arg_1_0, arg_1_1)
	getParentWindow(arg_1_0).parent:showResInfo(true)
end

function HANDLER_CANCEL.hpbar_boss(arg_2_0, arg_2_1)
	getParentWindow(arg_2_0).parent:showResInfo(false)
end

HANDLER.hpbar_boss = HANDLER_CANCEL.hpbar_boss

function HANDLER.formation_heal(arg_3_0, arg_3_1)
	if getParentWindow(arg_3_0).hp_wnd then
		if getParentWindow(arg_3_0).hp_wnd.is_automaton then
			AutomatonUtil:unitResurrection(getParentWindow(arg_3_0).hp_wnd.owner)
		else
			Bistro:ReqFastHeal(getParentWindow(arg_3_0).hp_wnd.owner)
		end
	end
end

function HPBar.showResInfo(arg_4_0, arg_4_1)
	if arg_4_0.owner.logic:getStageCounter() < 1 then
		return 
	end
	
	arg_4_0:fillResInfo(arg_4_1)
	if_set_visible(arg_4_0.control, "n_immune", arg_4_1)
	
	local var_4_0 = arg_4_0.control:getChildByName("n_immune")
	
	if get_cocos_refid(var_4_0) and not var_4_0.move_pos and BattleRepeat:isPlayingRepeatPlay() then
		var_4_0:setPositionX(var_4_0:getPositionX() + 180)
		
		var_4_0.move_pos = true
	end
end

function HPBar.fillResInfo(arg_5_0, arg_5_1)
	if_set(arg_5_0.control, "t_res_info", T("ui_game_battle_boss_title", {
		res = tostring(math.floor(arg_5_0.owner.status.res * 100)) .. "%%"
	}))
	
	local var_5_0 = 125
	local var_5_1 = {}
	local var_5_2 = arg_5_0.owner.states:findByEff("CSP_IMMUNE_AB_DOWN")
	local var_5_3 = arg_5_0.owner.states:findByEff("CSP_IMMUNE_CD_DOWN")
	
	if var_5_2 and not var_5_2.db.cs_immune_hide then
		table.push(var_5_1, "immune_AB_DOWN")
	end
	
	if var_5_3 and not var_5_3.db.cs_immune_hide then
		table.push(var_5_1, "immune_CD_DOWN")
	end
	
	local var_5_4 = arg_5_0.owner.states:getImmuneEffList()
	local var_5_5 = arg_5_0.owner.states:getDebuffBlockList_Eff(var_5_4)
	
	for iter_5_0, iter_5_1 in pairs(var_5_5) do
		local var_5_6 = "immune_" .. iter_5_1.eff
		
		if iter_5_1.cs.db.cs_immune_hide ~= "y" and iter_5_1.eff ~= "CSP_IMMUNE_AB_DOWN" and iter_5_1.eff ~= "CSP_IMMUNE_CD_DOWN" and not table.find(var_5_1, var_5_6) and not iter_5_1.hide then
			table.push(var_5_1, var_5_6)
		end
	end
	
	local var_5_7 = arg_5_0.owner.states:getImmuneStateList(true)
	local var_5_8 = arg_5_0.owner.states:getDebuffBlockList_CS(var_5_7, true)
	
	for iter_5_2 = #var_5_8, 1, -1 do
		if Account:isJPN() and DB("cs", tostring(var_5_8[iter_5_2]), "jpn_hide") == "y" then
			table.remove(var_5_8, iter_5_2)
		end
	end
	
	for iter_5_3, iter_5_4 in pairs(arg_5_0.control:getChildByName("n_icon_immune"):getChildren()) do
		if string.starts(iter_5_4:getName() or "", "cs:") then
			iter_5_4:removeFromParent()
		end
	end
	
	local var_5_9 = {}
	
	for iter_5_5, iter_5_6 in pairs(var_5_8) do
		table.insert(var_5_9, getStateBanner(iter_5_6))
	end
	
	local var_5_10 = 0
	
	if #var_5_8 > 0 then
		for iter_5_7, iter_5_8 in pairs(var_5_9) do
			iter_5_8:setPositionX(0)
			iter_5_8:setPositionY(0 - math.floor(iter_5_7 - 1) * 28)
			
			var_5_0 = var_5_0 + 28
			var_5_10 = var_5_10 - 28
			
			iter_5_8:setName("cs:" .. iter_5_7)
			arg_5_0.control:getChildByName("n_icon_immune"):addChild(iter_5_8)
		end
	end
	
	if_set_visible(arg_5_0.control, "n_icon_immune", #var_5_8 > 0)
	
	local var_5_11 = arg_5_0.control:getChildByName("n_txt_immune")
	
	arg_5_0.control:getChildByName("n_im_cs_bar"):setPositionY(var_5_10)
	if_set_visible(arg_5_0.control, "n_immunes", #var_5_1 + #var_5_8 > 0)
	
	if #var_5_1 + #var_5_8 > 0 then
		var_5_0 = var_5_0 + 50
	end
	
	if_set_visible(arg_5_0.control, "n_im_cs_bar", #var_5_1 > 0 and #var_5_8 > 0)
	
	if #var_5_1 > 0 and #var_5_8 > 0 then
		var_5_0 = var_5_0 + 12
		
		var_5_11:setPositionY(var_5_10 - 12)
	else
		var_5_11:setPositionY(var_5_10)
	end
	
	local var_5_12 = ""
	
	for iter_5_9, iter_5_10 in pairs(var_5_1) do
		if iter_5_9 > 1 then
			var_5_12 = var_5_12 .. "\n"
		end
		
		var_5_12 = var_5_12 .. T(iter_5_10:lower())
		var_5_0 = var_5_0 + 24
	end
	
	if_set(arg_5_0.control, "t_immune_eff", var_5_12)
	var_5_11:setVisible(#var_5_1 > 0)
	
	local var_5_13 = arg_5_0.control:getChildByName("res_frame")
	local var_5_14 = var_5_13:getContentSize()
	
	var_5_13:setContentSize({
		width = var_5_14.width,
		height = var_5_0
	})
	
	if arg_5_1 then
		local var_5_15 = arg_5_0.owner.logic:getTrialHallInfo()
		
		if var_5_15 and var_5_15.boss_id == arg_5_0.owner.inst.code then
			arg_5_0:addTrialInfo(var_5_15)
		end
	end
	
	if_set_visible(arg_5_0.control, "n_trial_target", arg_5_1)
end

function HPBar.addTrialInfo(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.control:getChildByName("n_trial_target")
	
	var_6_0:removeAllChildren()
	
	local var_6_1 = 0
	
	if arg_6_1.penalty then
		local var_6_2, var_6_3 = UIUtil:getTrialHallPanel(arg_6_1.penalty, false)
		
		if get_cocos_refid(var_6_2) then
			var_6_1 = var_6_1 + var_6_3
			
			var_6_0:addChild(var_6_2)
		end
	end
	
	if arg_6_1.benefit then
		local var_6_4 = UIUtil:getTrialHallPanel(arg_6_1.benefit, true)
		
		if get_cocos_refid(var_6_4) then
			var_6_4:setPositionY(-var_6_1)
			var_6_0:addChild(var_6_4)
		end
	end
end

function HPBar.setEliteInfo(arg_7_0, arg_7_1, arg_7_2)
	UIUtil:setUnitSimpleInfo(arg_7_1, arg_7_2)
	UIUtil:setLevel(arg_7_1, arg_7_2:getLv(), nil, 2, false)
	SpriteCache:resetSprite(arg_7_1:getChildByName("face"), "face/" .. (arg_7_2.db.face_id or "") .. "_s.png")
	if_set_visible(arg_7_1, "n_subboss", arg_7_2.db.tier ~= "boss")
	if_set_visible(arg_7_1, "n_boss", arg_7_2.db.tier == "boss")
	if_set_sprite(arg_7_1, "role", "img/cm_icon_role_" .. arg_7_2.db.role .. ".png")
	
	local var_7_0 = 1
	local var_7_1 = {}
	local var_7_2 = 0
	
	for iter_7_0 = 1, 10 do
		local var_7_3 = arg_7_2:getSkillByIndex(iter_7_0)
		
		if var_7_3 then
			local var_7_4, var_7_5 = DB("skill", var_7_3, {
				"sk_show",
				"sk_passive"
			})
			
			if var_7_4 then
				table.push(var_7_1, var_7_3)
			end
		end
	end
	
	local var_7_6
	
	for iter_7_1 = #var_7_1, 1, -1 do
		local var_7_7 = var_7_1[iter_7_1]
		local var_7_8 = DB("skill", var_7_7, "turn_cool")
		
		if var_7_2 < to_n(var_7_8) then
			var_7_2 = var_7_8
			var_7_6 = iter_7_1
		end
	end
	
	if var_7_6 then
		local var_7_9 = table.remove(var_7_1, var_7_6)
		
		table.insert(var_7_1, 1, var_7_9)
	end
	
	local var_7_10 = arg_7_2:getSkillSequencer()
	local var_7_14
	
	if not var_7_10 then
		if_set_visible(arg_7_1, "n_skills", true)
		if_set_visible(arg_7_1, "n_heritage_skill", false)
		
		local var_7_11 = arg_7_1:getChildByName("n_skills")
		
		if get_cocos_refid(var_7_11) then
			for iter_7_2, iter_7_3 in pairs(var_7_1) do
				local var_7_12 = var_7_11:getChildByName("skill" .. iter_7_2)
				
				if not var_7_12 then
					break
				end
				
				local var_7_13 = UIUtil:getSkillIcon(arg_7_2, iter_7_3, {
					tooltip_opts = {
						hide_stat = true,
						show_effs = "right"
					}
				})
				
				var_7_12:addChild(var_7_13)
			end
		end
	else
		if_set_visible(arg_7_1, "n_skills", false)
		if_set_visible(arg_7_1, "n_heritage_skill", true)
		
		var_7_14 = arg_7_1:getChildByName("n_heritage_skill")
		
		if get_cocos_refid(var_7_14) then
			local var_7_15 = var_7_10:getList()
			
			for iter_7_4, iter_7_5 in pairs(var_7_15) do
				local var_7_16 = tonumber(iter_7_5)
				local var_7_17 = var_7_14:getChildByName("skill" .. iter_7_4)
				
				if not var_7_17 then
					break
				end
				
				local var_7_18 = UIUtil:getSkillIcon(arg_7_2, var_7_1[var_7_16], {
					tooltip_opts = {
						hide_stat = true,
						show_effs = "right"
					}
				})
				
				var_7_17:addChild(var_7_18)
			end
		end
	end
end

function HPBar.createForInbattleTab(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or {}
	
	local var_8_0 = arg_8_2.reuse or {}
	local var_8_1 = "wnd/hp_bar.csb"
	
	if arg_8_1.db.tier == "elite" or arg_8_1.db.tier == "boss" or arg_8_1.db.tier == "subboss" then
		arg_8_2.is_boss_mode = true
	end
	
	var_8_0.control = load_control(var_8_1)
	var_8_0.control.parent = var_8_0
	
	if_set_visible(var_8_0.control, "n_element", false)
	var_8_0.control:setAnchorPoint(0.5, 1)
	var_8_0.control:setCascadeOpacityEnabled(true)
	
	var_8_0.node = cc.Node:create()
	
	if_set_visible(var_8_0.control, "frame", false)
	if_set_visible(var_8_0.control, "n_lvs", false)
	if_set_visible(var_8_0.control, "lv_color", false)
	if_set_visible(var_8_0.control, "n_buff", false)
	if_set_visible(var_8_0.control, "n_buff_heritage", false)
	if_set_visible(var_8_0.control, "n_immune", false)
	if_set_visible(var_8_0.control, "n_buff_story", false)
	if_set_visible(var_8_0.control, "n_npc", false)
	if_set_visible(var_8_0.control, "sp", arg_8_1:getSPName() ~= "berserk_gauge" and arg_8_1:getSPName() ~= "week_gauge")
	
	if arg_8_1:getSPName() == "none" or arg_8_1:getSPName() == "berserk_gauge" or arg_8_1:getSPName() == "week_gauge" then
		if_set_visible(var_8_0.control, "frame_1", true)
		var_8_0.control:getChildByName("n_cool"):setPositionY(var_8_0.control:getChildByName("n_cool"):getPositionY() - 2.5)
	else
		if_set_visible(var_8_0.control, "frame_2", true)
		var_8_0.control:getChildByName("n_cool"):setPositionY(var_8_0.control:getChildByName("n_cool"):getPositionY() - 4.5)
	end
	
	local var_8_2, var_8_3 = arg_8_1:getPreCoolSkillTime()
	
	if var_8_2 and var_8_3 and arg_8_1:isNeedToShowSkillCoolTime() then
		if_set_visible(var_8_0.control, "n_cool", true)
		
		local var_8_4 = math.min(5, to_n(var_8_3))
		
		for iter_8_0 = 2, 5 do
			var_8_0.control:getChildByName("n_cool" .. iter_8_0):setVisible(iter_8_0 == var_8_4)
		end
	else
		if_set_visible(var_8_0.control, "n_cool", false)
	end
	
	var_8_0.n_hp = var_8_0.control:getChildByName("n_hp")
	var_8_0.hp = var_8_0.control:getChildByName("hp")
	var_8_0.sh = var_8_0.control:getChildByName("sh")
	var_8_0.n_shield = var_8_0.control:getChildByName("n_shield")
	
	var_8_0.n_shield:setCascadeColorEnabled(false)
	
	var_8_0.hp_red = var_8_0.control:getChildByName("hp_red")
	var_8_0.sp = var_8_0.control:getChildByName("sp")
	var_8_0.n_heal = var_8_0.control:getChildByName("n_heal")
	var_8_0.BAR_SIZE = var_8_0.hp:getContentSize()
	
	if arg_8_1:getSPName() == "mp" then
		SpriteCache:resetSprite(var_8_0.sp, "img/game_hud_bar_mp.png")
	elseif arg_8_1:getSPName() == "bp" then
		SpriteCache:resetSprite(var_8_0.sp, "img/game_hud_bar_bp.png")
	elseif arg_8_1:getSPName() == "cp" then
		SpriteCache:resetSprite(var_8_0.sp, "img/game_hud_bar_cp.png")
	elseif arg_8_1:getSPName() == "none" then
		SpriteCache:resetSprite(var_8_0.control:getChildByName("frame"), "img/game_hud_bar_bg_n.png")
	end
	
	local var_8_5 = var_8_0.control:getChildByName("exp")
	
	if var_8_5 then
		var_8_5:setVisible(false)
		
		if var_8_0.control:getChildByName("gauge_exp") then
			var_8_0.control:getChildByName("gauge_exp"):setVisible(false)
		end
	end
	
	SpriteCache:resetSprite(var_8_0.control:getChildByName("bg_num"), "hp_icon_" .. arg_8_1.db.color .. ".png")
	
	var_8_0.states = {}
	
	copy_functions(HPBar, var_8_0)
	
	var_8_0.owner = arg_8_1
	var_8_0.opts = arg_8_2
	var_8_0.is_boss_mode = arg_8_2.is_boss_mode
	
	var_8_0:set(nil, 0)
	var_8_0:resetMarks(var_8_0.control, arg_8_1, nil, {
		on_tab = true
	})
	
	var_8_0.individual_show = nil
	
	if arg_8_2.layer then
		arg_8_2.layer:addChild(var_8_0.control)
		arg_8_2.layer:addChild(var_8_0.node)
	end
	
	if var_8_0.n_heal then
		var_8_0.n_heal:setVisible(arg_8_2.show_healing)
		
		if arg_8_2.show_healing or arg_8_2.is_automaton then
			local var_8_6 = load_control("wnd/formation_heal.csb")
			
			var_8_6.hp_wnd = var_8_0
			var_8_6.hp_wnd.is_automaton = arg_8_2.is_automaton
			
			if_set_visible(var_8_6, "txt_eat_time", not arg_8_2.is_automaton)
			var_8_0.n_heal:addChild(var_8_6)
			
			if arg_8_2.is_automaton and not var_8_0.n_heal.origin_pos_x then
				var_8_0.n_heal.origin_pos_x = var_8_0.n_heal:getPositionX()
				
				var_8_0.n_heal:setPositionX(var_8_0.n_heal.origin_pos_x + 26)
			end
			
			if arg_8_2.is_automaton and arg_8_1:getAutomatonHPRatio() <= 0 then
				if_set_sprite(var_8_6, "eat_img", "img/cm_icon_st_resurrection.png")
			end
		end
	end
	
	var_8_0.control:setVisible(arg_8_2.show ~= false)
	
	return var_8_0
end

function HPBar.create(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or {}
	
	local var_9_0 = arg_9_2.reuse or {}
	local var_9_1
	
	if arg_9_1.db.tier == "elite" or arg_9_1.db.tier == "boss" or arg_9_1.db.tier == "subboss" then
		arg_9_2.is_boss_mode = true
	end
	
	local var_9_2 = arg_9_2.is_boss_mode and "wnd/hpbar_boss.csb" or "wnd/hp_bar.csb"
	
	if not arg_9_2.reuse then
		var_9_0.control = load_control(var_9_2)
		var_9_0.control.parent = var_9_0
		
		if_set_visible(var_9_0.control, "n_element", false)
		
		if arg_9_2.is_boss_mode then
			var_9_0.control:setLocalZOrder(1)
			arg_9_0:setEliteInfo(var_9_0.control, arg_9_1)
		else
			var_9_0.control:setAnchorPoint(0.5, 1)
		end
		
		var_9_0.control:setCascadeOpacityEnabled(true)
		
		var_9_0.node = cc.Node:create()
	end
	
	if_set_visible(var_9_0.control, "n_immune", false)
	
	local var_9_3, var_9_4 = arg_9_1:getPreCoolSkillTime()
	
	if var_9_3 and var_9_4 and arg_9_1:isNeedToShowSkillCoolTime() then
		if_set_visible(var_9_0.control, "n_cool", true)
		
		local var_9_5 = math.min(5, to_n(var_9_4))
		
		for iter_9_0 = 2, 5 do
			var_9_0.control:getChildByName("n_cool" .. iter_9_0):setVisible(iter_9_0 == var_9_5)
		end
	else
		if_set_visible(var_9_0.control, "n_cool", false)
	end
	
	if_set_visible(var_9_0.control, "n_npc", arg_9_2.guest)
	if_set_visible(var_9_0.control, "n_buff_story", arg_9_2.show_story_buff)
	if_set_visible(arg_9_0.control, "n_hp2", false)
	
	var_9_0.n_hp = var_9_0.control:getChildByName("n_hp")
	var_9_0.hp = var_9_0.control:getChildByName("hp")
	var_9_0.sh = var_9_0.control:getChildByName("sh")
	var_9_0.dhp = var_9_0.control:getChildByName("hp_dhp")
	var_9_0.n_shield = var_9_0.control:getChildByName("n_shield")
	
	var_9_0.n_shield:setCascadeColorEnabled(false)
	
	var_9_0.hp_red = var_9_0.control:getChildByName("hp_red")
	var_9_0.sp = var_9_0.control:getChildByName("sp")
	var_9_0.n_heal = var_9_0.control:getChildByName("n_heal")
	var_9_0.BAR_SIZE = var_9_0.hp:getContentSize()
	
	if arg_9_1:getSPName() == "mp" then
		SpriteCache:resetSprite(var_9_0.sp, "img/game_hud_bar_mp.png")
	elseif arg_9_1:getSPName() == "bp" then
		SpriteCache:resetSprite(var_9_0.sp, "img/game_hud_bar_bp.png")
	elseif arg_9_1:getSPName() == "cp" then
		SpriteCache:resetSprite(var_9_0.sp, "img/game_hud_bar_cp.png")
	elseif arg_9_1:getSPName() ~= "none" or arg_9_2.is_boss_mode then
	else
		SpriteCache:resetSprite(var_9_0.control:getChildByName("frame"), "img/game_hud_bar_bg_n.png")
	end
	
	SpriteCache:resetSprite(var_9_0.control:getChildByName("lv_color"), "img/game_hud_bar_" .. arg_9_1.db.color .. ".png")
	
	local var_9_6 = var_9_0.control:getChildByName("exp")
	
	if var_9_6 then
		var_9_6:setVisible(false)
		
		if var_9_0.control:getChildByName("gauge_exp") then
			var_9_0.control:getChildByName("gauge_exp"):setVisible(false)
		end
	end
	
	SpriteCache:resetSprite(var_9_0.control:getChildByName("bg_num"), "hp_icon_" .. arg_9_1.db.color .. ".png")
	
	var_9_0.states = {}
	
	copy_functions(HPBar, var_9_0)
	
	var_9_0.owner = arg_9_1
	var_9_0.opts = arg_9_2
	var_9_0.is_boss_mode = arg_9_2.is_boss_mode
	var_9_0.individual_show = nil
	
	if arg_9_2.layer then
		arg_9_2.layer:addChild(var_9_0.control)
		arg_9_2.layer:addChild(var_9_0.node)
	end
	
	if var_9_0.n_heal then
		var_9_0.n_heal:setVisible(arg_9_2.show_healing or arg_9_2.is_used_unit)
		
		if arg_9_2.show_healing or arg_9_2.is_automaton or arg_9_2.is_used_unit then
			local var_9_7 = load_control("wnd/formation_heal.csb")
			
			var_9_7.hp_wnd = var_9_0
			var_9_7.hp_wnd.is_automaton = arg_9_2.is_automaton
			var_9_7.hp_wnd.is_used_unit = arg_9_2.is_used_unit
			
			if_set_visible(var_9_7, "txt_eat_time", not arg_9_2.is_automaton and not arg_9_2.is_used_unit)
			var_9_0.n_heal:addChild(var_9_7)
			
			if arg_9_2.is_automaton and not var_9_0.n_heal.origin_pos_x then
				var_9_0.n_heal.origin_pos_x = var_9_0.n_heal:getPositionX()
				
				var_9_0.n_heal:setPositionX(var_9_0.n_heal.origin_pos_x + 26)
			end
			
			if arg_9_2.is_automaton and arg_9_1:getAutomatonHPRatio() <= 0 then
				if_set_sprite(var_9_7, "eat_img", "img/cm_icon_st_resurrection.png")
			end
			
			if arg_9_2.is_used_unit then
				if not var_9_0.n_heal.origin_pos_x then
					var_9_0.n_heal.origin_pos_x = var_9_0.n_heal:getPositionX()
					
					var_9_0.n_heal:setPositionX(var_9_0.n_heal.origin_pos_x + 26)
				end
				
				if_set_sprite(var_9_7, "eat_img", "img/cm_icon_st_no.png")
			end
		end
	end
	
	if arg_9_2.isSplitBar then
		copy_functions(SplitHpBar, var_9_0)
		var_9_0:init()
	end
	
	var_9_0:set(nil, 0)
	var_9_0:resetMarks(var_9_0.control, arg_9_1)
	var_9_0.control:setVisible(arg_9_2.show ~= false)
	
	return var_9_0
end

function HPBar.updateMarks(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_3 = arg_10_3 or {}
	arg_10_1 = arg_10_1 or arg_10_0.control
	arg_10_2 = arg_10_2 or arg_10_0.owner
	
	local var_10_0 = arg_10_2:getLv()
	
	if arg_10_3.force or arg_10_0.prev_lv ~= var_10_0 then
		local var_10_1 = {
			arg_10_1:getChildByName("l2"),
			arg_10_1:getChildByName("l1")
		}
		
		if var_10_0 <= 99 then
			if arg_10_0.is_boss_mode then
				SpriteCache:digit(var_10_1, var_10_0, "img/hero_lv_", false, false)
			else
				SpriteCache:digit(var_10_1, var_10_0, "img/itxt_num", false, false, "_b.png")
			end
			
			local var_10_2 = arg_10_1:getChildByName("n_lvs")
			
			if var_10_2 then
				if var_10_0 < 10 then
					var_10_2:setPositionX(-5)
				else
					var_10_2:setPositionX(0)
				end
			end
			
			arg_10_0.prev_lv = var_10_0
		else
			var_10_1[1]:setVisible(false)
			var_10_1[2]:setVisible(false)
		end
		
		if_set_visible(arg_10_1, "lp", var_10_0 > 99)
	end
end

function HPBar.resetMarks(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	arg_11_4 = arg_11_4 or {}
	arg_11_3 = arg_11_3 or arg_11_0:getOwnerGaugeInfo(arg_11_2).bar_render_scale
	
	local var_11_0 = arg_11_1:getChildByName("n_hpmark")
	local var_11_1 = arg_11_1:getChildByName("n_spmark")
	
	if not var_11_0 then
		return 
	end
	
	var_11_0:removeAllChildren()
	var_11_1:removeAllChildren()
	
	local var_11_2 = 10
	local var_11_3 = 50
	
	if arg_11_2:getSPName() == "mp" then
		var_11_2 = 50
		var_11_3 = 100
	elseif arg_11_2:getSPName() == "cp" then
		var_11_2 = 1
		var_11_3 = 1
	end
	
	if arg_11_0.BAR_SIZE == nil then
		arg_11_0.BAR_SIZE = arg_11_1:getChildByName("hp"):getContentSize()
	end
	
	if arg_11_0:isBoss() and not arg_11_4.on_tab then
		arg_11_0:addMarks(arg_11_0.BAR_SIZE.width * arg_11_3, var_11_0, 200, 10, 50, 3, 0.2, 0.4)
	else
		arg_11_3 = round(arg_11_3, 2)
		
		local var_11_4 = 25
		
		if arg_11_3 > 0.51 then
			var_11_4 = 10
		elseif arg_11_3 > 0.25 then
			var_11_4 = 12.5
		end
		
		arg_11_0:addMarks(arg_11_0.BAR_SIZE.width * arg_11_3, var_11_0, 100, var_11_4, 50, 0.9, 0)
	end
	
	if arg_11_1:getChildByName("sp") then
		arg_11_0:addMarks(arg_11_0.BAR_SIZE.width, var_11_1, arg_11_2:getMaxSP(), var_11_2, var_11_3, 0.6, 1)
	end
end

function HPBar.addMarks(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8)
	arg_12_4 = arg_12_4 or 50
	arg_12_5 = arg_12_5 or arg_12_4 * 5
	arg_12_8 = arg_12_8 or 0.6
	
	local var_12_0
	
	for iter_12_0 = arg_12_4, arg_12_3, arg_12_4 do
		local var_12_1 = SpriteCache:getSprite("img/game_hud_bar_split.png")
		
		var_12_1:setAnchorPoint(0, arg_12_7)
		var_12_1:setPositionX(math.floor(iter_12_0 * (arg_12_1 / arg_12_3) + 0.5))
		
		if iter_12_0 % arg_12_5 ~= 0 then
			var_12_1:setScaleY(arg_12_6 * arg_12_8)
		else
			var_12_1:setScaleY(arg_12_6)
		end
		
		arg_12_2:addChild(var_12_1)
	end
end

function HPBar.getBuffTargetName(arg_13_0)
	if arg_13_0.owner:getSkillSequencer() then
		return "n_buff_heritage"
	end
	
	return "n_buff"
end

function HPBar.updateSkillSequencer(arg_14_0)
	local var_14_0 = arg_14_0.owner:getSkillSequencer()
	local var_14_1, var_14_2
	
	if var_14_0 and get_cocos_refid(arg_14_0.control) then
		var_14_1 = var_14_0:getCurrentOrder()
		var_14_2 = arg_14_0.control:getChildByName("n_heritage_skill")
		
		if get_cocos_refid(var_14_2) then
			for iter_14_0 = 1, 8 do
				local var_14_3 = var_14_2:getChildByName("skill" .. iter_14_0)
				local var_14_4 = var_14_2:getChildByName("arrow" .. iter_14_0)
				local var_14_5 = iter_14_0 < var_14_1 and cc.c3b(80, 80, 80) or cc.c3b(255, 255, 255)
				
				if get_cocos_refid(var_14_3) then
					var_14_3:setColor(var_14_5)
					
					if var_14_1 == iter_14_0 then
						if not BattleUIAction:Find(var_14_3) then
							BattleUIAction:Add(LOOP(SEQ(OPACITY(1000, 1, 0.5), OPACITY(500, 0.5, 1))), var_14_3, "battle")
						end
					elseif BattleUIAction:Find(var_14_3) then
						BattleUIAction:Remove(var_14_3)
						var_14_3:setOpacity(255)
					end
				end
				
				if get_cocos_refid(var_14_4) then
					var_14_4:setColor(var_14_5)
				end
			end
		end
	end
end

function HPBar.updateState(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0:isValid() then
		return 
	end
	
	if not arg_15_1 and arg_15_0.state_counter == arg_15_0.owner.states.counter then
		return 
	end
	
	arg_15_0.state_counter = arg_15_0.owner.states.counter
	
	local var_15_0 = {}
	local var_15_1 = 28
	local var_15_2, var_15_3 = arg_15_0.control:getChildByName(arg_15_0:getBuffTargetName()):getPosition()
	local var_15_4 = 0
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.owner.states.List) do
		local var_15_5 = iter_15_1:getId()
		local var_15_6 = iter_15_1:getUId()
		
		if iter_15_1:isValid() then
			var_15_0[var_15_6] = true
			
			local var_15_7 = arg_15_0.states[var_15_6]
			
			if var_15_7 then
				local var_15_8 = arg_15_0.owner.states:find(var_15_7.id)
				
				if var_15_8 then
					local var_15_9 = var_15_7.value ~= var_15_8.value
					local var_15_10 = var_15_7.stack_count ~= var_15_8.stack_count
					
					if var_15_8:isAntiSkillDamage() and var_15_9 or var_15_10 then
						if get_cocos_refid(var_15_7.spr) then
							var_15_7.spr:removeFromParent()
						end
						
						var_15_7 = nil
					end
				end
			end
			
			if var_15_7 == nil then
				var_15_7 = arg_15_0:getStateIcon(var_15_5, var_15_6, arg_15_0.owner)
			end
			
			if var_15_7 then
				local var_15_11 = var_15_7.spr
				local var_15_12 = var_15_4
				local var_15_13 = 0
				
				if arg_15_0.is_boss_mode then
					var_15_12 = var_15_4 % 8
					var_15_13 = 0 - math.floor(var_15_4 / 8)
				else
					var_15_12 = var_15_4 % 3
					var_15_13 = math.floor(var_15_4 / 3)
				end
				
				var_15_11:setLocalZOrder(iter_15_0)
				var_15_11:setPosition(var_15_2 + var_15_12 * var_15_1, var_15_3 + var_15_13 * var_15_1)
				
				arg_15_0.states[var_15_6] = var_15_7
				
				arg_15_0:setStateTurn(var_15_11, var_15_5, var_15_6)
				if_set_visible(var_15_11, "turn", BattleUI:isVisible())
				
				var_15_4 = var_15_4 + 1
			end
		end
	end
	
	for iter_15_2, iter_15_3 in pairs(arg_15_0.states) do
		if var_15_0[iter_15_3.uid] == nil then
			arg_15_0:removeStateIcon(iter_15_3.uid)
		end
	end
end

function HPBar.removeAllIcon(arg_16_0)
	for iter_16_0, iter_16_1 in pairs(arg_16_0.states) do
		if iter_16_1.uid and arg_16_0.states[iter_16_1.uid] then
			arg_16_0:removeStateIcon(iter_16_1.uid)
		end
	end
end

function HPBar.removeStateIcon(arg_17_0, arg_17_1)
	arg_17_0.control:removeChild(arg_17_0.states[arg_17_1].spr)
	
	arg_17_0.states[arg_17_1] = nil
end

function HPBar.setStateTurn(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_0.owner.states:findByUId(arg_18_3)
	
	if var_18_0.db.cs_turn and var_18_0.db.cs_turn == 0 then
		if arg_18_1 then
			arg_18_1:removeChildByName("turn_img")
			
			arg_18_1.turn = nil
		end
		
		return 
	end
	
	arg_18_4 = arg_18_4 or arg_18_0.owner:getStateTurn(arg_18_3)
	
	if arg_18_4 < 0 then
		return 
	end
	
	local var_18_1
	local var_18_2 = arg_18_4 > 9 and "img/itxt_num9.png" or "img/itxt_num" .. arg_18_4 .. ".png"
	
	if not arg_18_1.turn then
		local var_18_3 = SpriteCache:getSprite(var_18_2)
		
		var_18_3:setAnchorPoint(0.5, 0.5)
		var_18_3:setPosition(1, 23)
		var_18_3:setName("turn_img")
		
		local var_18_4 = DB("cs", tostring(arg_18_2), "cs_type")
		
		if var_18_4 == "buff" then
			var_18_3:setColor(cc.c3b(162, 243, 255))
		elseif var_18_4 == "debuff" then
			var_18_3:setColor(cc.c3b(255, 124, 89))
		else
			var_18_3:setColor(cc.c3b(255, 255, 255))
		end
		
		arg_18_1:addChild(var_18_3)
		
		arg_18_1.turn = var_18_3
	else
		SpriteCache:resetSprite(arg_18_1.turn, var_18_2)
	end
end

function HPBar.getStateIcon(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = UIUtil:getStateIcon(arg_19_1, arg_19_3)
	
	if not var_19_0 then
		return nil
	end
	
	var_19_0:setAnchorPoint(0, 0)
	var_19_0:setScale(1)
	arg_19_0:setStateTurn(var_19_0, arg_19_1, arg_19_2)
	var_19_0:setCascadeOpacityEnabled(true)
	arg_19_0.control:addChild(var_19_0)
	arg_19_0.control:setCascadeOpacityEnabled(true)
	
	local var_19_1 = arg_19_3.states:findByUId(arg_19_2)
	local var_19_2
	local var_19_3
	
	if var_19_1 then
		var_19_2 = var_19_1.value
		var_19_3 = var_19_1.stack_count
	end
	
	return {
		uid = arg_19_2,
		id = arg_19_1,
		spr = var_19_0,
		value = var_19_2,
		stack_count = var_19_3
	}
end

function HPBar.set(arg_20_0, arg_20_1)
	arg_20_0:setHP(arg_20_1)
	arg_20_0:updateSP()
end

function HPBar.updateSP(arg_21_0)
	if not arg_21_0:isValid() then
		return 
	end
	
	if get_cocos_refid(arg_21_0.sp) then
		local var_21_0 = arg_21_0.owner:getSPRatio()
		
		if arg_21_0.opts.full_hp and arg_21_0.owner:getSPName() == "mp" then
			var_21_0 = 1
		end
		
		arg_21_0.sp:setScaleX(var_21_0)
	end
	
	local var_21_1
	
	if arg_21_0.cp then
		var_21_1 = arg_21_0.owner:getSP()
		
		for iter_21_0 = 1, 5 do
			if_set_visible(arg_21_0.control, iter_21_0 .. "charge", iter_21_0 <= var_21_1)
		end
	end
	
	local var_21_2, var_21_3 = arg_21_0.owner:getPreCoolSkillTime()
	local var_21_4, var_21_5
	
	if var_21_2 and var_21_3 and arg_21_0.owner:isNeedToShowSkillCoolTime() then
		var_21_4 = math.min(5, to_n(var_21_3))
		var_21_5 = arg_21_0.control:getChildByName("n_cool" .. var_21_4)
		
		if get_cocos_refid(var_21_5) then
			for iter_21_1 = 1, var_21_4 do
				local var_21_6 = var_21_5:getChildByName(tostring(iter_21_1))
				
				if iter_21_1 <= var_21_4 - var_21_2 then
					var_21_6:setOpacity(255)
				else
					var_21_6:setOpacity(0)
				end
			end
		end
	end
end

function HPBar.getOwnerGaugeInfo(arg_22_0, arg_22_1)
	local var_22_0 = {}
	local var_22_1 = arg_22_1 or arg_22_0.owener
	local var_22_2 = var_22_1:getHP()
	local var_22_3 = var_22_1:getMaxHP()
	local var_22_4 = var_22_1:getRawMaxHP()
	local var_22_5 = var_22_1:getHPRatio()
	local var_22_6 = var_22_1.states:getShield()
	local var_22_7 = var_22_1.states:getMaxShield()
	local var_22_8 = var_22_1:getShieldRatio()
	local var_22_9 = var_22_1:getBrokenHP()
	local var_22_10 = var_22_1:getBrokenHPRatio()
	local var_22_11 = var_22_6
	local var_22_12 = var_22_6 > 0 and 1 or 0
	
	if arg_22_0.opts then
		if arg_22_0.opts.full_hp then
			var_22_5 = 1
		elseif arg_22_0.opts.is_automaton then
			var_22_5 = var_22_1:getAutomatonHPRatio() / 1000
		end
	end
	
	local var_22_13 = 1
	local var_22_14 = 0
	local var_22_15 = 1
	
	if var_22_9 > 0 then
		var_22_13 = 1 - var_22_10
		var_22_14 = var_22_10
		var_22_15 = 1 - var_22_10
	end
	
	local var_22_16
	local var_22_17
	
	if var_22_6 > 0 then
		local var_22_18 = var_22_11 + var_22_2
		
		if var_22_4 < var_22_18 then
			var_22_16 = var_22_2 / var_22_18
			var_22_17 = var_22_11 / var_22_18
			var_22_15 = var_22_3 / var_22_18
		end
	end
	
	var_22_16 = var_22_16 or var_22_5 * var_22_13
	var_22_17 = var_22_17 or var_22_11 / var_22_4
	var_22_0.bar_render_scale = var_22_15
	var_22_0.dhp_bar_ratio = var_22_14
	var_22_0.adjust_hp_ratio = var_22_16
	var_22_0.adjust_sh_ratio = var_22_17
	var_22_0.hp_cur = var_22_2
	var_22_0.hp_max = var_22_3
	var_22_0.raw_hp_max = var_22_4
	var_22_0.sh_cur = var_22_6
	var_22_0.sh_max = var_22_11
	var_22_0.dhp_cur = var_22_9
	var_22_0.hp_ratio = var_22_5
	var_22_0.sh_ratio = var_22_12
	var_22_0.dhp_ratio = var_22_10
	
	return var_22_0
end

function HPBar.setHP(arg_23_0, arg_23_1, arg_23_2)
	arg_23_2 = arg_23_2 or 800
	
	local var_23_0 = arg_23_0:getOwnerGaugeInfo(arg_23_0.owner)
	
	if arg_23_0.prev_sh_cur == var_23_0.sh_cur and arg_23_0.prev_hp_ratio == var_23_0.hp_ratio and arg_23_0.prev_dhp_ratio == var_23_0.dhp_ratio and arg_23_0.prev_max_hp == var_23_0.hp_max and not arg_23_1 then
		return 
	end
	
	arg_23_0:updateMarks()
	
	arg_23_0.prev_max_hp = arg_23_0.prev_max_hp or var_23_0.hp_max
	arg_23_0.prev_sh_cur = arg_23_0.prev_sh_cur or var_23_0.sh_cur
	
	if get_cocos_refid(arg_23_0.dhp) then
		arg_23_0.dhp:setVisible(var_23_0.dhp_cur > 0)
		
		if var_23_0.dhp_cur > 0 then
			arg_23_0.dhp:setScaleX(var_23_0.dhp_bar_ratio)
		end
	end
	
	arg_23_0.n_shield:setVisible(false)
	arg_23_0.n_shield:setVisible(var_23_0.sh_ratio > 0)
	
	if var_23_0.sh_ratio > 0 then
		arg_23_0.sh:setContentSize({
			width = arg_23_0.BAR_SIZE.width,
			height = arg_23_0.BAR_SIZE.height
		})
		arg_23_0.sh:setScaleX(var_23_0.adjust_sh_ratio)
		arg_23_0.sh:setPositionX(arg_23_0.BAR_SIZE.width * var_23_0.adjust_hp_ratio - arg_23_0.BAR_SIZE.width)
	end
	
	if arg_23_0.prev_hp_ratio == nil then
		arg_23_0.hp_red:setVisible(false)
		arg_23_0.hp:setScaleX(var_23_0.adjust_hp_ratio)
	elseif arg_23_0.prev_hp_ratio ~= var_23_0.hp_ratio then
		arg_23_0:playGauge(arg_23_0.prev_hp_gauge_ratio or var_23_0.adjust_hp_ratio, var_23_0.adjust_hp_ratio, arg_23_0.hp, arg_23_0.hp_red, arg_23_2)
	elseif arg_23_0.prev_hp_gauge_ratio ~= var_23_0.adjust_hp_ratio then
		if BattleUIAction:Find(arg_23_0.hp) then
			BattleUIAction:Remove(arg_23_0.hp)
		end
		
		arg_23_0.hp:setScaleX(var_23_0.adjust_hp_ratio)
	end
	
	if (var_23_0.sh_ratio > 0 or var_23_0.dhp_ratio > 0) and (arg_23_0.prev_sh_cur ~= var_23_0.sh_cur or arg_23_0.prev_dhp_ratio ~= var_23_0.dhp_ratio) and not BattleUIAction:Find(arg_23_0.hp_red) then
		arg_23_0.hp_red:setVisible(false)
	end
	
	if arg_23_0.prev_bar_render_scale ~= var_23_0.bar_render_scale then
		arg_23_0:resetMarks(arg_23_0.control, arg_23_0.owner, var_23_0.bar_render_scale)
	end
	
	arg_23_0.prev_hp_ratio = var_23_0.hp_ratio
	arg_23_0.prev_hp_gauge_ratio = var_23_0.adjust_hp_ratio
	arg_23_0.prev_sh_cur = var_23_0.sh_cur
	arg_23_0.prev_max_hp = var_23_0.hp_max
	arg_23_0.prev_dhp_ratio = var_23_0.dhp_ratio
	arg_23_0.prev_bar_render_scale = var_23_0.bar_render_scale
end

function HPBar.playGauge(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = math.min(1, arg_24_2)
	local var_24_1 = 30
	local var_24_2 = arg_24_3:getScaleX()
	local var_24_3 = arg_24_4:getScaleX()
	
	if arg_24_5 == 0 then
		arg_24_4:setScaleX(var_24_0)
		arg_24_3:setScaleX(var_24_0)
		
		return 
	end
	
	if arg_24_2 < arg_24_1 then
		BattleUIAction:Remove(arg_24_3)
		arg_24_3:setScaleX(var_24_0)
		
		if arg_24_4 then
			if not BattleUIAction:Find(arg_24_4) then
				arg_24_4:setScaleX(var_24_2)
				
				var_24_3 = var_24_2
			end
			
			arg_24_4:setVisible(true)
			BattleUIAction:Remove(arg_24_4)
			BattleUIAction:Add(SEQ(DELAY(arg_24_6), SPAWN(REPEAT(3, SEQ(COLOR(0, 255, 255, 155), DELAY(50), COLOR(0, 255, 0, 0), DELAY(50))), SEQ(DELAY(600), SCALEX(arg_24_5, var_24_3, var_24_0)))), arg_24_4, "battle")
		end
	elseif arg_24_1 < arg_24_2 then
		BattleUIAction:Add(LOG(SCALEX(arg_24_5, var_24_2, var_24_0)), arg_24_3, "battle")
		
		if arg_24_4 then
			arg_24_4:setScaleX(var_24_0)
		end
	else
		arg_24_3:setScaleX(var_24_0)
		
		if arg_24_4 then
			arg_24_4:setScaleX(var_24_0)
			arg_24_4:setVisible(false)
		end
	end
end

function HPBar.addChild(arg_25_0, arg_25_1)
	if not arg_25_0:isValid() then
		return false
	end
	
	arg_25_0.control:addChild(arg_25_1)
end

function HPBar.removeTextFromRoot(arg_26_0)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.node:getChildren()) do
		if get_cocos_refid(iter_26_1) and string.starts(iter_26_1:getName() or "", "text") or string.starts(iter_26_1:getName() or "", "dmg.") or string.starts(iter_26_1:getName() or "", "img") then
			iter_26_1:removeFromParent()
		end
	end
end

function HPBar.addChildToRoot(arg_27_0, arg_27_1)
	if not arg_27_0:isValid() then
		return false
	end
	
	arg_27_0.node:addChild(arg_27_1)
end

function HPBar.getChildFromRoot(arg_28_0, arg_28_1)
	if not arg_28_0:isValid() then
		return 
	end
	
	return arg_28_0.node:getChildByName(arg_28_1)
end

function HPBar.updateLv(arg_29_0)
end

function HPBar.setCustomOpacity(arg_30_0, arg_30_1)
	arg_30_0.custom_opacity = arg_30_1
	
	if type(arg_30_1) == "number" then
		arg_30_0:setOpacity(arg_30_1)
	end
end

function HPBar.getCustomOpacity(arg_31_0, arg_31_1)
	return arg_31_0.custom_opacity
end

function HPBar.updatePos(arg_32_0)
	if arg_32_0:isValid() then
		if not arg_32_0.owner or not get_cocos_refid(arg_32_0.owner.model) then
			arg_32_0:remove()
			
			return 
		end
		
		local var_32_0
		
		if not arg_32_0.is_boss_mode then
			local var_32_1 = arg_32_0.owner.model:getBoneNode("top"):getPositionY() + 60
			local var_32_2 = SceneManager:convertToSceneSpace(arg_32_0.owner.model, {
				x = 0,
				y = var_32_1
			})
			
			arg_32_0.control:setPosition(math.floor(var_32_2.x), math.floor(var_32_2.y))
		end
		
		local var_32_3 = SceneManager:convertToSceneSpace(arg_32_0.owner.model, {
			x = 0,
			y = 0
		})
		
		arg_32_0.node:setPosition(math.floor(var_32_3.x), math.floor(var_32_3.y))
		
		if arg_32_0:getCustomOpacity() then
			arg_32_0:setVisible(true)
		elseif arg_32_0.individual_show ~= nil then
			arg_32_0:setVisible(arg_32_0.individual_show)
		else
			if SceneManager:getCurrentSceneName() ~= "effecttool" then
				arg_32_0:setVisible(BattleUI:isVisible())
			end
			
			if not arg_32_0:isBoss() then
				arg_32_0:setOpacity(arg_32_0.owner.model:getOpacity())
			end
		end
	end
end

function HPBar.setIndividualShow(arg_33_0, arg_33_1)
	arg_33_0.individual_show = arg_33_1
end

function HPBar.update(arg_34_0, arg_34_1)
	if arg_34_1 then
		arg_34_0:updatePos(arg_34_1)
	end
	
	arg_34_0:updateState()
end

function HPBar.isVisible(arg_35_0)
	if not arg_35_0:isValid() then
		return 
	end
	
	return arg_35_0.control:isVisible()
end

function HPBar.setVisible(arg_36_0, arg_36_1)
	if not arg_36_0:isValid() then
		return 
	end
	
	if arg_36_0.owner:isDead() and arg_36_1 then
		return 
	end
	
	if arg_36_0.control:isVisible() == arg_36_1 then
		return 
	end
	
	return arg_36_0.control:setVisible(arg_36_1)
end

function HPBar.getOpacity(arg_37_0)
	if not arg_37_0:isValid() then
		return 
	end
	
	return arg_37_0.control:getOpacity()
end

function HPBar.setOpacity(arg_38_0, arg_38_1)
	if not arg_38_0:isValid() then
		return 
	end
	
	if arg_38_0.control:getOpacity() == arg_38_1 then
		return 
	end
	
	return arg_38_0.control:setOpacity(arg_38_1)
end

function HPBar.remove(arg_39_0)
	if get_cocos_refid(arg_39_0.node) then
		arg_39_0.node:removeFromParent()
	end
	
	if get_cocos_refid(arg_39_0.control) then
		arg_39_0.control:removeFromParent()
	end
	
	arg_39_0.node = nil
	arg_39_0.control = nil
end

function HPBar.isBoss(arg_40_0)
	return arg_40_0.is_boss_mode
end

function HPBar.isValid(arg_41_0)
	return get_cocos_refid(arg_41_0.control) and get_cocos_refid(arg_41_0.node)
end

ConditionBar = {}

function ConditionBar.create(arg_42_0, arg_42_1, arg_42_2)
	arg_42_2 = arg_42_2 or {}
	
	local var_42_0 = {}
	
	copy_functions(ConditionBar, var_42_0)
	
	var_42_0.control = load_control("wnd/condition_bar.csb")
	var_42_0.owner = arg_42_1
	
	if get_cocos_refid(arg_42_2.layer) then
		arg_42_2.layer:addChild(var_42_0.control)
	end
	
	var_42_0:updateSP()
	var_42_0:addLine("weak")
	var_42_0:addLine("berserk")
	
	return var_42_0
end

function ConditionBar.update(arg_43_0)
	arg_43_0:updatePos()
end

function ConditionBar.updatePos(arg_44_0)
	if arg_44_0:isValid() then
		if not arg_44_0.owner or not get_cocos_refid(arg_44_0.owner.model) then
			arg_44_0:remove()
			
			return 
		end
		
		local var_44_0 = arg_44_0.owner.model:getBoneNode("top"):getPositionY() + 30
		local var_44_1 = SceneManager:convertToSceneSpace(arg_44_0.owner.model, {
			x = 0,
			y = var_44_0
		})
		
		arg_44_0.control:setPosition(math.floor(var_44_1.x), math.floor(var_44_1.y))
		
		local var_44_2 = 255
		
		if arg_44_0.custom_opacity then
			var_44_2 = to_n(arg_44_0.custom_opacity)
		end
		
		arg_44_0.control:setOpacity(math.min(var_44_2, arg_44_0.owner.model:getOpacity()))
	end
end

function ConditionBar.isValid(arg_45_0)
	return get_cocos_refid(arg_45_0.control)
end

function ConditionBar.updateSP(arg_46_0)
	local var_46_0 = {
		"n_berserk",
		"n_weak"
	}
	local var_46_1
	
	if arg_46_0.owner then
		local var_46_2 = arg_46_0.owner:getSPName()
		local var_46_3 = math.min(1, arg_46_0.owner:getSPRatio() or 0)
		
		if var_46_2 == "berserk_gauge" then
			var_46_1 = "berserk"
		elseif var_46_2 == "week_gauge" then
			var_46_1 = "weak"
		end
		
		local var_46_4
		
		if var_46_1 then
			var_46_4 = "n_" .. var_46_1
			
			local var_46_5 = arg_46_0.control:getChildByName(var_46_4)
			
			if get_cocos_refid(var_46_5) then
				local var_46_6 = var_46_5:getChildByName(var_46_1 .. "_gauge")
				
				if get_cocos_refid(var_46_6) then
					var_46_6:setScaleX(var_46_3)
				end
			end
			
			if_set_visible(var_46_5, var_46_1 .. "_on", var_46_3 >= 1)
			if_set_visible(var_46_5, var_46_1 .. "_off", var_46_3 < 1)
		end
		
		local var_46_7 = false
		
		for iter_46_0, iter_46_1 in pairs(var_46_0) do
			local var_46_8 = iter_46_1 == (var_46_4 or "")
			
			if var_46_8 then
				var_46_7 = true
			end
			
			if_set_visible(arg_46_0.control, iter_46_1, var_46_8)
		end
		
		if_set_visible(arg_46_0.control, "frame", var_46_7)
	end
end

function ConditionBar.addLine(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.control:getChildByName("n_" .. arg_47_1)
	local var_47_1 = var_47_0:getChildByName(arg_47_1 .. "_gauge")
	local var_47_2 = 10
	local var_47_3 = 50
	local var_47_4 = 100
	local var_47_5 = var_47_1:getContentSize().width
	local var_47_6
	
	for iter_47_0 = var_47_2, var_47_4, var_47_2 do
		if iter_47_0 ~= var_47_4 then
			local var_47_7 = SpriteCache:getSprite("img/game_hud_bar_split.png")
			
			var_47_7:setAnchorPoint(0, 0)
			var_47_7:setPositionX(math.floor(iter_47_0 * (var_47_5 / var_47_4) + 0.5))
			
			if iter_47_0 % var_47_3 ~= 0 then
				var_47_7:setScaleY(1)
			else
				var_47_7:setScaleY(1.8)
			end
			
			var_47_0:addChild(var_47_7)
		end
	end
end

function ConditionBar.remove(arg_48_0)
	if arg_48_0:isValid() then
		arg_48_0.control:removeFromParent()
	end
	
	arg_48_0.control = nil
end

function ConditionBar.setVisible(arg_49_0, arg_49_1)
	if not arg_49_0:isValid() then
		return 
	end
	
	if arg_49_0.owner:isDead() and arg_49_1 then
		return 
	end
	
	if arg_49_0.control:isVisible() == arg_49_1 then
		return 
	end
	
	return arg_49_0.control:setVisible(arg_49_1)
end

function ConditionBar.setCustomOpacity(arg_50_0, arg_50_1)
	arg_50_0.custom_opacity = arg_50_1
	
	if type(arg_50_1) == "number" then
		arg_50_0:setOpacity(arg_50_1)
	end
end

function ConditionBar.getCustomOpacity(arg_51_0, arg_51_1)
	return arg_51_0.custom_opacity
end

function ConditionBar.getOpacity(arg_52_0)
	if not arg_52_0:isValid() then
		return 
	end
	
	return arg_52_0.control:getOpacity()
end

function ConditionBar.setOpacity(arg_53_0, arg_53_1)
	if not arg_53_0:isValid() then
		return 
	end
	
	if arg_53_0.control:getOpacity() == arg_53_1 then
		return 
	end
	
	return arg_53_0.control:setOpacity(arg_53_1)
end

SplitHpBar = {}

function SplitHpBar.init(arg_54_0)
	if not get_cocos_refid(arg_54_0.control) then
		return 
	end
	
	if_set_visible(arg_54_0.control, "n_hp", false)
	if_set_visible(arg_54_0.control, "n_hp2", true)
	
	if arg_54_0.owner then
		arg_54_0.split_count = DB("character", arg_54_0.owner.db.code, {
			"splite"
		}) or 1
	end
	
	arg_54_0.rotate_color_info = {
		"#FA7601",
		"#0065FC",
		"#D602FF"
	}
	
	local var_54_0 = arg_54_0.control:getChildByName("n_hp2")
	
	if get_cocos_refid(var_54_0) then
		arg_54_0.n_hp2 = var_54_0
		arg_54_0.hp_next = var_54_0:getChildByName("hp_next")
		
		arg_54_0.hp_next:setColor(arg_54_0:getColor(arg_54_0.split_count - 1))
		
		arg_54_0.dhp = var_54_0:getChildByName("hp_dhp")
		arg_54_0.n_shield = var_54_0:getChildByName("n_shield")
		
		arg_54_0.n_shield:setCascadeColorEnabled(false)
		arg_54_0.n_shield:setVisible(false)
		
		arg_54_0.sh = arg_54_0.n_shield:getChildByName("sh")
		arg_54_0.hp_red = var_54_0:getChildByName("hp_red")
		arg_54_0.hp_red2 = arg_54_0.hp_red:clone()
		
		arg_54_0.hp_red2:setName("hp_red_front")
		arg_54_0.hp_red2:setVisible(false)
		var_54_0:addChild(arg_54_0.hp_red2)
		
		arg_54_0.hp = var_54_0:getChildByName("hp")
		
		arg_54_0.hp:setColor(arg_54_0:getColor(arg_54_0.split_count))
		var_54_0:getChildByName("n_hpmark"):bringToFront()
	end
	
	arg_54_0.hp_hit = getChildByPath(arg_54_0.control, "bar/hit_eff")
	
	arg_54_0.hp_hit:setVisible(false)
	if_set_visible(arg_54_0.control, "n_hp_count", true)
	
	arg_54_0.n_split_count = getChildByPath(arg_54_0.control, "n_hp_count/txt_count")
	
	local var_54_1 = -60
	
	if_set_add_position_x(arg_54_0.control, "color", var_54_1)
	if_set_add_position_x(arg_54_0.control, "role", var_54_1)
	if_set_add_position_x(arg_54_0.control, "n_lv", var_54_1)
	arg_54_0:resetMarks(var_54_0, arg_54_0.owner)
end

function SplitHpBar.setHP(arg_55_0, arg_55_1, arg_55_2)
	arg_55_2 = arg_55_2 or 800
	
	local var_55_0 = arg_55_0:getOwnerGaugeInfo(arg_55_0.owner)
	
	if arg_55_0.prev_sh_cur == var_55_0.sh_cur and arg_55_0.prev_hp_ratio == var_55_0.hp_ratio and arg_55_0.prev_dhp_ratio == var_55_0.dhp_ratio and arg_55_0.prev_max_hp == var_55_0.hp_max and not arg_55_1 then
		return 
	end
	
	arg_55_0:updateMarks()
	
	local var_55_1 = arg_55_0:updateSplitBarRatio(arg_55_0.prev_hp_gauge_ratio or var_55_0.adjust_hp_ratio, var_55_0.adjust_hp_ratio)
	
	arg_55_0:updateBarColor(var_55_1.cur_split_index)
	arg_55_0:setSplitCount(var_55_1.cur_split_index)
	
	arg_55_0.prev_max_hp = arg_55_0.prev_max_hp or var_55_0.hp_max
	arg_55_0.prev_sh_cur = arg_55_0.prev_sh_cur or var_55_0.sh_cur
	
	if arg_55_0.prev_hp_ratio == nil then
		arg_55_0.hp_red:setVisible(false)
		arg_55_0.hp:setScaleX(var_55_1.adjust_hp_ratio)
	elseif arg_55_0.prev_hp_ratio ~= var_55_0.hp_ratio then
		arg_55_0:playGauge(arg_55_0.prev_hp_gauge_ratio or var_55_0.adjust_hp_ratio, var_55_0.adjust_hp_ratio, var_55_1, arg_55_2)
	elseif arg_55_0.prev_hp_gauge_ratio ~= var_55_0.adjust_hp_ratio then
		if BattleUIAction:Find(arg_55_0.hp) then
			BattleUIAction:Remove(arg_55_0.hp)
		end
		
		arg_55_0.hp:setScaleX(var_55_1.adjust_hp_ratio)
	end
	
	if (var_55_0.sh_ratio > 0 or var_55_0.dhp_ratio > 0) and (arg_55_0.prev_sh_cur ~= var_55_0.sh_cur or arg_55_0.prev_dhp_ratio ~= var_55_0.dhp_ratio) and not BattleUIAction:Find(arg_55_0.hp_red) then
		arg_55_0.hp_red:setVisible(false)
	end
	
	if arg_55_0.prev_bar_render_scale ~= var_55_0.bar_render_scale then
		arg_55_0:resetMarks(arg_55_0.control, arg_55_0.owner, var_55_0.bar_render_scale)
	end
	
	arg_55_0.prev_hp_ratio = var_55_0.hp_ratio
	arg_55_0.prev_hp_gauge_ratio = var_55_0.adjust_hp_ratio
	arg_55_0.prev_sh_cur = var_55_0.sh_cur
	arg_55_0.prev_max_hp = var_55_0.hp_max
	arg_55_0.prev_dhp_ratio = var_55_0.dhp_ratio
	arg_55_0.prev_bar_render_scale = var_55_0.bar_render_scale
	arg_55_0.prev_split_index = var_55_1.cur_split_index
end

function SplitHpBar.setSplitCount(arg_56_0, arg_56_1)
	if not get_cocos_refid(arg_56_0.n_split_count) or not arg_56_1 then
		return 
	end
	
	local var_56_0 = "x" .. tostring(arg_56_1)
	
	arg_56_0.n_split_count:setString(var_56_0)
end

function SplitHpBar.getColor(arg_57_0, arg_57_1)
	arg_57_1 = arg_57_1 or arg_57_0.split_count
	
	local var_57_0 = arg_57_0.split_count
	
	if arg_57_0.split_count == arg_57_1 then
		return tocolor("#81C222")
	end
	
	local var_57_1 = table.count(arg_57_0.rotate_color_info or {})
	local var_57_2 = (var_57_0 - arg_57_1) % var_57_1
	
	if var_57_2 == 0 then
		var_57_2 = var_57_1
	end
	
	return tocolor(arg_57_0.rotate_color_info[var_57_2])
end

function SplitHpBar.updateBarColor(arg_58_0, arg_58_1)
	arg_58_1 = arg_58_1 or arg_58_0.split_count
	
	arg_58_0.hp:setColor(arg_58_0:getColor(arg_58_1))
	
	if arg_58_1 > 1 then
		arg_58_0.hp_next:setColor(arg_58_0:getColor(arg_58_1 - 1))
	end
	
	arg_58_0.hp_next:setVisible(arg_58_1 > 1)
end

function SplitHpBar.updateSplitBarRatio(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	local var_59_0 = arg_59_0.split_count
	local var_59_1 = {}
	local var_59_2 = 1 / arg_59_0.split_count
	local var_59_3 = arg_59_2 / var_59_2
	
	if var_59_3 == var_59_0 then
		var_59_1.cur_split_index = math.floor(var_59_3)
		var_59_1.adjust_hp_ratio = 1 - (var_59_3 - math.floor(var_59_3))
	elseif var_59_3 <= 0 then
		var_59_1.cur_split_index = 0
		var_59_1.adjust_hp_ratio = 0
	else
		var_59_1.cur_split_index = math.floor(var_59_3) + 1
		var_59_1.adjust_hp_ratio = var_59_3 - math.floor(var_59_3)
	end
	
	var_59_1.tbl = {}
	
	local var_59_4
	
	if arg_59_2 < arg_59_1 then
		var_59_1.diff = (arg_59_1 - arg_59_2) / var_59_2
		var_59_1.diff = var_59_1.diff - arg_59_0.hp:getScaleX()
		
		if var_59_1.cur_split_index <= 0 then
			var_59_1.diff = math.min(var_59_1.diff, 0)
		end
		
		if var_59_1.diff > 0 then
			table.insert(var_59_1.tbl, {
				to = 0,
				from = arg_59_0.hp:getScaleX()
			})
			
			while var_59_1.diff > 0 do
				var_59_1.diff = var_59_1.diff - 1
				
				if var_59_1.diff < 0 then
					table.insert(var_59_1.tbl, {
						from = 1,
						to = math.abs(var_59_1.diff)
					})
				else
					table.insert(var_59_1.tbl, {
						from = 1,
						to = 0
					})
				end
			end
		end
	elseif arg_59_1 < arg_59_2 then
		var_59_1.diff = (arg_59_2 - arg_59_1) / var_59_2
		var_59_1.diff = var_59_1.diff - (1 - arg_59_0.hp:getScaleX())
		
		if var_59_1.diff > 0 then
			table.insert(var_59_1.tbl, {
				to = 1,
				index = arg_59_0.prev_split_index,
				from = arg_59_0.hp:getScaleX()
			})
			
			var_59_4 = 1
			
			while var_59_1.diff > 0 do
				var_59_1.diff = var_59_1.diff - 1
				
				if var_59_1.diff < 0 then
					table.insert(var_59_1.tbl, {
						from = 0,
						index = arg_59_0.prev_split_index + var_59_4,
						to = 1 - math.abs(var_59_1.diff)
					})
				else
					table.insert(var_59_1.tbl, {
						to = 1,
						from = 0,
						index = arg_59_0.prev_split_index + var_59_4
					})
				end
				
				var_59_4 = var_59_4 + 1
			end
		end
	end
	
	arg_59_0.state = var_59_1
	
	return var_59_1
end

function SplitHpBar.playGauge(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
	local var_60_0 = math.min(1, arg_60_3.adjust_hp_ratio)
	
	arg_60_0.hp_hit:setVisible(false)
	arg_60_0.hp_red:setVisible(false)
	arg_60_0.hp_red2:setVisible(false)
	
	if arg_60_4 == 0 then
		arg_60_0:updateSplitBarState()
		arg_60_0.hp:setScaleX(var_60_0)
		arg_60_0.hp_red:setScaleX(var_60_0)
		
		return 
	end
	
	local var_60_1 = arg_60_0.hp:getScaleX()
	local var_60_2 = arg_60_0.hp_red:getScaleX()
	
	if arg_60_2 < arg_60_1 then
		BattleUIAction:Remove(arg_60_0.hp)
		arg_60_0.hp:setScaleX(var_60_0)
		
		if not BattleUIAction:Find(arg_60_0.hp_red) then
			arg_60_0.hp_red:setScaleX(var_60_1)
			
			var_60_2 = var_60_1
		end
		
		BattleUIAction:Remove(arg_60_0.hp_hit)
		BattleUIAction:Remove(arg_60_0.hp_red)
		BattleUIAction:Remove(arg_60_0.hp_red2)
		
		local var_60_3 = {}
		local var_60_4 = 600
		
		if table.empty(arg_60_3.tbl) then
			arg_60_0.hp_red:setVisible(true)
			table.insert(var_60_3, DELAY(var_60_4))
			table.insert(var_60_3, SCALEX(arg_60_4, var_60_2, var_60_0))
		else
			local var_60_5 = table.count(arg_60_3.tbl)
			local var_60_6 = arg_60_4
			local var_60_7 = var_60_6 / math.pow(var_60_5, 2)
			local var_60_8 = (var_60_6 * 2 / var_60_5 - var_60_7 * (var_60_5 - 1)) / 2
			
			arg_60_0.hp_red2:setVisible(true)
			arg_60_0.hp_red2:setScaleX(var_60_2)
			
			local var_60_9 = {}
			local var_60_10 = false
			
			for iter_60_0, iter_60_1 in pairs(arg_60_3.tbl) do
				if iter_60_0 == 1 then
					table.insert(var_60_9, DELAY(var_60_4))
				end
				
				if iter_60_0 == var_60_5 then
					arg_60_0.hp_red:setScaleX(1)
					arg_60_0.hp_red:setVisible(not var_60_10)
					table.insert(var_60_3, DELAY(var_60_4 + (arg_60_4 - var_60_6 + var_60_7 * (iter_60_0 - 2))))
					table.insert(var_60_3, SHOW(true))
					table.insert(var_60_3, DELAY(var_60_8 + var_60_7 * (iter_60_0 - 1)))
					table.insert(var_60_3, SCALEX(var_60_8 + var_60_7 * (iter_60_0 - 1), iter_60_1.from, iter_60_1.to))
				else
					if iter_60_1.from == 1 and iter_60_1.to <= 0 then
						var_60_10 = true
					end
					
					table.insert(var_60_9, SCALEX(var_60_8 + var_60_7 * (iter_60_0 - 1), iter_60_1.from, iter_60_1.to))
				end
			end
			
			BattleUIAction:Add(SEQ(DELAY(arg_60_5), SPAWN(REPEAT(3, SEQ(COLOR(0, 255, 255, 155), DELAY(50), COLOR(0, 255, 0, 0), DELAY(50))), SEQ_LIST(var_60_9))), arg_60_0.hp_red2, "battle")
		end
		
		BattleUIAction:Add(SEQ(DELAY(arg_60_5), SPAWN(REPEAT(3, SEQ(COLOR(0, 255, 255, 155), DELAY(50), COLOR(0, 255, 0, 0), DELAY(50))), SEQ_LIST(var_60_3))), arg_60_0.hp_red, "battle")
		
		if arg_60_0.hp_hit then
			arg_60_0.hp_hit:setVisible(true)
			arg_60_0.hp_hit:setOpacity(0.6)
			BattleUIAction:Add(OPACITY(var_60_4 - 200, 0.6, 0), arg_60_0.hp_hit, "battle")
		end
	elseif arg_60_1 < arg_60_2 then
		local var_60_11 = {}
		local var_60_13
		
		if table.empty(arg_60_3.tbl) then
			table.insert(var_60_11, LOG(SCALEX(arg_60_4, var_60_1, var_60_0)))
		else
			arg_60_0:updateBarColor(arg_60_0.prev_split_index)
			
			local var_60_12 = table.count(arg_60_3.tbl)
			
			var_60_13 = (arg_60_4 - 100 * var_60_12) / var_60_12
			
			for iter_60_2, iter_60_3 in pairs(arg_60_3.tbl) do
				table.insert(var_60_11, CALL(function()
					arg_60_0:updateBarColor(iter_60_3.index)
					arg_60_0:setSplitCount(iter_60_3.index)
				end))
				table.insert(var_60_11, SCALEX(var_60_13 + 100 * (iter_60_2 - 1), iter_60_3.from, iter_60_3.to))
			end
		end
		
		BattleUIAction:Add(SEQ_LIST(var_60_11), arg_60_0.hp, "battle")
		
		if arg_60_0.hp_red and arg_60_0.hp_red2 then
			arg_60_0.hp_red:setScaleX(var_60_0)
			arg_60_0.hp_red2:setScaleX(0)
		end
	else
		arg_60_0.hp:setScaleX(var_60_0)
		
		if arg_60_0.hp_red and arg_60_0.hp_red2 then
			arg_60_0.hp_red:setScaleX(var_60_0)
			arg_60_0.hp_red2:setScaleX(0)
		end
	end
end

function SplitHpBar.resetMarks(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	if not get_cocos_refid(arg_62_0.control) or not get_cocos_refid(arg_62_1) then
		return 
	end
	
	arg_62_4 = arg_62_4 or {}
	arg_62_3 = arg_62_3 or arg_62_0:getOwnerGaugeInfo(arg_62_2).bar_render_scale
	
	local var_62_0 = arg_62_1:getChildByName("n_hpmark")
	local var_62_1 = arg_62_0.control:getChildByName("n_spmark")
	
	if not var_62_0 then
		return 
	end
	
	var_62_0:removeAllChildren()
	var_62_1:removeAllChildren()
	
	local var_62_2 = 10
	local var_62_3 = 50
	
	if arg_62_2:getSPName() == "mp" then
		var_62_2 = 50
		var_62_3 = 100
	elseif arg_62_2:getSPName() == "cp" then
		var_62_2 = 1
		var_62_3 = 1
	end
	
	if arg_62_0.BAR_SIZE == nil then
		arg_62_0.BAR_SIZE = arg_62_1:getChildByName("hp"):getContentSize()
	end
	
	if arg_62_0:isBoss() and not arg_62_4.on_tab then
		arg_62_0:addMarks(arg_62_0.BAR_SIZE.width * arg_62_3, var_62_0, 200, 10, 50, 3, 0.2, 0.4)
	else
		arg_62_3 = round(arg_62_3, 2)
		
		local var_62_4 = 25
		
		if arg_62_3 > 0.51 then
			var_62_4 = 10
		elseif arg_62_3 > 0.25 then
			var_62_4 = 12.5
		end
		
		arg_62_0:addMarks(arg_62_0.BAR_SIZE.width * arg_62_3, var_62_0, 100, var_62_4, 50, 0.9, 0)
	end
	
	if arg_62_0.control:getChildByName("sp") then
		arg_62_0:addMarks(arg_62_0.BAR_SIZE.width, var_62_1, arg_62_2:getMaxSP(), var_62_2, var_62_3, 0.6, 1)
	end
end
