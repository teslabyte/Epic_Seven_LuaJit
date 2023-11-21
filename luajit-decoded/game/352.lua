UnitSkill = {}

function MsgHandler.exchange_mura(arg_1_0)
	Account:addReward(arg_1_0.rewards, {
		buy = false,
		single = true,
		effect = true,
		no_check_condition = true
	})
	UnitSkill:UpdateLeftResourceCount()
	UnitSkill:refresh_exchangePopup(arg_1_0.exchange_id)
end

function MsgHandler.refund_skillpoint(arg_2_0)
	UnitSkill:show_moraToSkillPointPopup(arg_2_0)
end

function MsgHandler.upgrade_skill(arg_3_0)
	UnitSkill:procUpgrade_0(arg_3_0)
end

function HANDLER.skill_up_refunds(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_ok" then
		UnitSkill:close_moraToSkillPointPopup()
	end
end

function HANDLER.unit_skill(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
	end
	
	if string.starts(arg_5_1, "btn_skill") then
		UnitSkill:onSelectSkill(tonumber(string.sub(arg_5_1, -1, -1)), false, false)
	end
	
	if arg_5_1 == "btn_go" then
		local var_5_0 = HeroBelt:getInst("UnitMain")
		
		if not var_5_0:isScrolling() and not var_5_0:isPushed() then
			UnitSkill:openConfirmPopup()
		end
	end
	
	if arg_5_1 == "btn_exchange" then
		UnitSkill:exchangeMuraPopup_ex()
	end
	
	if arg_5_1 == "btn_catalyst" then
		if UnitSkill.vars.is_invisible_button_unit then
			balloon_message_with_sound("msg_cannot_use_btn_hero")
			
			return 
		end
		
		local var_5_1 = UnitSkill:getUnit()
		
		if var_5_1 then
			local var_5_2 = var_5_1.db.code
			
			if is_enhanced_mer(var_5_2) then
				var_5_2 = get_origin_mer()
			end
			
			Stove:openEssenceGuidePage(var_5_2)
		else
			Log.e("unit is nil")
		end
	end
end

function HANDLER.skill_up_mura_ex(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" then
		UnitSkill:closeMuraPopup_ex()
	elseif arg_6_1 == "btn_go" then
		UnitSkill:reqExchageMura()
	end
	
	if arg_6_1 == "btn_min" or arg_6_1 == "btn_max" or arg_6_1 == "btn_plus" or arg_6_1 == "btn_minus" then
		UnitSkill:onSliderButton(arg_6_1)
	end
end

function HANDLER.skill_up_confirm(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_ok" then
		UnitSkill:reqUpgradeSkill()
	elseif arg_7_1 == "btn_cancel" then
		UnitSkill:closeConfirmPopup()
	end
end

function UnitSkill.onPushBackground(arg_8_0)
end

function UnitSkill.isValid(arg_9_0)
	return arg_9_0.vars and get_cocos_refid(arg_9_0.vars.wnd)
end

function UnitSkill.onUIUpdate(arg_10_0)
	arg_10_0:UpdateLeftResourceCount()
end

function UnitSkill.onCreate(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		arg_11_0.vars = {}
		arg_11_0.vars.wnd = load_dlg("unit_skill", true, "wnd")
		
		arg_11_0.vars.wnd:setLocalZOrder(1)
		UnitMain.vars.base_wnd:addChild(arg_11_0.vars.wnd)
		arg_11_0.vars.wnd:getChildByName("LEFT"):setOpacity(0)
		arg_11_0.vars.wnd:getChildByName("CENTER"):setOpacity(0)
		
		local var_11_0 = ContentDisable:byAlias("essence_guide")
		
		if_set_visible(arg_11_0.vars.wnd, "n_exchange1", var_11_0)
		if_set_visible(arg_11_0.vars.wnd, "n_exchange2", not var_11_0)
		
		arg_11_0.vars.is_invisible_button_unit = EpisodeAdin:isAdinCode(arg_11_1.unit.db.code)
		
		if arg_11_0.vars.is_invisible_button_unit then
			if_set_opacity(arg_11_0.vars.wnd, "btn_catalyst", 76.5)
			
			local var_11_1 = arg_11_0.vars.wnd:getChildByName(var_11_0 and "n_exchange1" or "n_exchange2")
			
			if_set_opacity(var_11_1, "btn_exchange", 76.5)
		end
		
		if IS_PUBLISHER_ZLONG then
			if_set_visible(arg_11_0.vars.wnd, "n_exchange1", false)
			if_set_visible(arg_11_0.vars.wnd, "n_exchange2", false)
			
			local var_11_2 = arg_11_0.vars.wnd:getChildByName("n_normal_move_zl")
			
			if get_cocos_refid(var_11_2) then
				if_set_position_y(arg_11_0.vars.wnd, "n_normal", var_11_2:getPositionY())
			end
			
			local var_11_3 = arg_11_0.vars.wnd:getChildByName("n_skill_point_move_zl")
			
			if get_cocos_refid(var_11_3) then
				if_set_position_y(arg_11_0.vars.wnd, "n_skill_point", var_11_3:getPositionY())
			end
		end
		
		ItemEventSender:addListener(arg_11_0)
	end
	
	local var_11_4 = arg_11_0.vars.wnd:getChildByName("CENTER")
	
	if arg_11_0.vars.skillbase_posY == nil and var_11_4 ~= nil then
		local var_11_5 = var_11_4:getChildByName("n_sel_skill")
		
		if var_11_5 ~= nil then
			arg_11_0.vars.skillbase_posY = var_11_5:getPositionY()
		end
	end
	
	if UnitExtension:isAttrChangeableUnit(arg_11_1.unit.db.code) and not UnitExtension:isSkillUpgradeUnlocked(arg_11_1.unit.db.code) then
		if_set_opacity(arg_11_0.vars.wnd, "btn_go", 76.5)
	end
	
	if arg_11_0.vars.skillbase_posY == nil then
		arg_11_0.vars.skillbase_posY = -200
	end
	
	arg_11_0.vars.before_maxlv = 1
	
	arg_11_0:onSelectUnit(arg_11_1.unit)
end

function UnitSkill.getSceneState(arg_12_0)
	if not arg_12_0.vars then
		return {}
	end
	
	return {
		unit = arg_12_0.vars.unit,
		prev_mode = arg_12_0.vars.prev_mode,
		start_mode = arg_12_0.vars.prev_mode
	}
end

function UnitSkill.onEnter(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.vars.prev_mode = arg_13_1
	
	local var_13_0 = arg_13_2.unit
	
	arg_13_0.vars.start_unit = arg_13_2.unit
	arg_13_0.vars.before_maxlv = 1
	arg_13_0.vars.current_idx = 1
	
	if not UnitMain:isPortraitUseMode(arg_13_1) then
		UnitMain:enterPortrait()
	end
	
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"ma_moragora2",
		"ma_moragora1",
		"stigma"
	})
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_13_0.vars.wnd:getChildByName("LEFT"), "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 1200)), arg_13_0.vars.wnd:getChildByName("CENTER"), "block")
	if_set_visible(arg_13_0.vars.wnd, "n_skills", not arg_13_0.vars.detailed)
	if_set_visible(arg_13_0.vars.wnd, "n_mura", true)
	arg_13_0:playBgEffect()
	arg_13_0:checkRequestSkillPoint(var_13_0)
	TopBarNew:setDisableTopRight()
	SoundEngine:play("event:/ui/unit_upgrade/enter")
	TutorialGuide:ifStartGuide("skill_enhance")
end

function UnitSkill.onLeave(arg_14_0, arg_14_1)
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), arg_14_0.vars.wnd:getChildByName("LEFT"), "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_14_0.vars.wnd:getChildByName("CENTER"), "block")
	
	if arg_14_1 ~= "Upgrade" and arg_14_1 ~= "Zoom" and arg_14_1 ~= "Review" and arg_14_1 ~= "Detail" then
		UnitMain:leavePortrait(nil, arg_14_1 ~= "Main")
	end
	
	if arg_14_1 == "Detail" then
		UnitDetailGrowth:updateSkillUpgradeButton()
	end
	
	TopBarNew:setEnableTopRight()
	arg_14_0:closeMuraPopup_ex()
	arg_14_0:closeConfirmPopup()
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_14_0.vars.eff_bg, "block")
	UIAction:Add(SEQ(DELAY(200), REMOVE()), arg_14_0.vars.wnd, "block")
	
	arg_14_0.vars.eff_bg = nil
	arg_14_0.vars = {}
end

function UnitSkill.onPushBackButton(arg_15_0)
	if arg_15_0.vars.prev_mode == "Story" or arg_15_0.vars.prev_mode == "Upgrade" or arg_15_0.vars.prev_mode == "Zoom" or arg_15_0.vars.prev_mode == "Zodiac" or arg_15_0.vars.prev_mode == "Equip" or arg_15_0.vars.prev_mode == "Review" then
		UnitMain:setMode("Main")
	elseif arg_15_0.vars.prev_mode == "Detail" then
		UnitMain:setMode("Detail", {
			unit = arg_15_0.vars.unit
		})
	else
		UnitMain:setMode(arg_15_0.vars.prev_mode or UnitMain.vars.start_mode or "Main")
	end
end

function UnitSkill.onSelectUnit(arg_16_0, arg_16_1, arg_16_2)
	arg_16_1 = arg_16_1 or HeroBelt:getInst("UnitMain"):getItems()[1]
	
	if not arg_16_1 then
		return 
	end
	
	if arg_16_1:isLockSkillUpgrade() then
		arg_16_1 = Account:getMainUnit()
	end
	
	UnitMain:changePortrait(arg_16_1)
	
	if arg_16_0.vars.unit == arg_16_1 and arg_16_0.vars.unit_point == arg_16_1:getPoint() then
		return 
	end
	
	if arg_16_1 then
		arg_16_0.vars.wnd.guide_tag = arg_16_1.db.name
		
		TopBarNew:setTitleName(T(arg_16_1.db.name))
		TopBarNew:checkhelpbuttonID("growth_4_1")
	end
	
	arg_16_0.vars.unit_point = arg_16_1:getPoint()
	arg_16_0.vars.unit = arg_16_1
	arg_16_0.vars.birth_grade = DB("character", arg_16_0.vars.unit.inst.code, "grade") or 4
	
	arg_16_0:onSelectSkill(1, true, true)
	arg_16_0:UpdateLeftResource()
end

function UnitSkill.getUnit(arg_17_0)
	if arg_17_0.vars then
		return arg_17_0.vars.unit
	end
end

function UnitSkill._getResSkillPoint(arg_18_0)
	if not arg_18_0.vars or not arg_18_0.vars.unit then
		return 
	end
	
	return arg_18_0.vars.unit:getRestSkillPoint()
end

function UnitSkill.updateSkillInfo(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0.vars then
		return 
	end
	
	local var_19_0
	
	if arg_19_2 then
		var_19_0 = 0
		
		for iter_19_0 = 1, 3 do
			local var_19_1 = arg_19_0.vars.wnd:getChildByName("n_skill" .. iter_19_0)
			local var_19_2 = var_19_1:getChildByName("n_skill_icon" .. iter_19_0)
			
			if get_cocos_refid(var_19_2) then
				var_19_1:removeChildByName("n_skill_icon" .. iter_19_0)
				
				local var_19_3
			end
			
			local var_19_4 = arg_19_0.vars.unit:getSkillByIndex(iter_19_0)
			
			if var_19_4 then
				local var_19_5 = arg_19_0.vars.unit:getSkillLevelByIndex(iter_19_0)
				local var_19_6 = UIUtil:getSkillIcon(arg_19_0.vars.unit, var_19_4, {
					hud_skill = true,
					no_tooltip = true
				})
				
				var_19_6:setName("n_skill_icon" .. iter_19_0)
				if_set_visible(var_19_6, "selected", false)
				if_set_visible(var_19_6, "cost", false)
				
				if var_19_5 == 0 then
					if_set_visible(var_19_6, "up", false)
				else
					if_set_visible(var_19_6, "up", true)
					if_set(var_19_6, "txt_up", "+" .. var_19_5)
				end
				
				if DB("skill", var_19_4, "sk_passive") then
					if_set_visible(var_19_6, "frame", false)
				end
				
				var_19_1:addChild(var_19_6)
				var_19_1:setVisible(true)
				
				var_19_0 = var_19_0 + 1
			else
				var_19_1:setVisible(false)
			end
		end
	end
	
	if arg_19_0.vars.skill_idx then
		if not arg_19_1 or arg_19_0.vars.tooltip == nil then
			arg_19_0:removeTooltip()
			
			arg_19_0.vars.tooltip = load_control("wnd/skill_detail_up.csb")
			
			local var_19_7 = getChildByPath(arg_19_0.vars.tooltip, "n_soul/txt_soul_desc")
			
			UIUserData:call(var_19_7, "MULTI_SCALE(2)")
			if_set_visible(arg_19_0.vars.tooltip, "n_up", false)
			arg_19_0.vars.tooltip:setOpacity(0)
			arg_19_0.vars.tooltip:setPositionX(-400)
			arg_19_0.vars.wnd:getChildByName("n_sk_tooltip"):addChild(arg_19_0.vars.tooltip)
			
			local var_19_8 = arg_19_0.vars.tooltip:getChildByName("main_label")
			
			if get_cocos_refid(var_19_8) then
				if_set(var_19_8, nil, T("skill_detail_soul"))
				set_scale_fit_width(var_19_8, 165)
			end
			
			if_set(arg_19_0.vars.tooltip, "p1_0", T("unit_skill_reinforce_btn"))
			UIAction:Add(LOG(SPAWN(MOVE_TO(180, 0), FADE_IN(180))), arg_19_0.vars.tooltip, "block")
			SoundEngine:play("event:/ui/whoosh_a")
		end
		
		UIUtil:getSkillDetail(arg_19_0.vars.unit, arg_19_0.vars.unit:getSkillByIndex(arg_19_0.vars.skill_idx), {
			wnd = arg_19_0.vars.tooltip,
			skill_lv = arg_19_0.vars.unit:getSkillLevelByIndex(arg_19_0.vars.skill_idx)
		})
		
		arg_19_0.vars.skill_id = arg_19_0.vars.unit:getSkillByIndex(arg_19_0.vars.skill_idx)
		
		local var_19_9 = arg_19_0.vars.unit:getSkillLevelByIndex(arg_19_0.vars.skill_idx)
		local var_19_10 = arg_19_0.vars.unit:getMaxSkillLevelByIndex(arg_19_0.vars.skill_idx)
		
		for iter_19_1 = 1, 8 do
			local var_19_11 = arg_19_0.vars.tooltip:getChildByName("data" .. iter_19_1)
			
			if var_19_11 then
				WidgetUtils:setupTooltip({
					delay = 0,
					control = var_19_11,
					creator = function()
						local var_20_0 = cc.CSLoader:createNode("wnd/unit_skill_tooltip.csb")
						
						if_set(var_20_0, "data3_0", T("unit_skill_need_resources"))
						
						local var_20_1, var_20_2, var_20_3, var_20_4, var_20_5, var_20_6 = arg_19_0:getResInfo(iter_19_1)
						local var_20_7 = 0
						
						if var_20_1 then
							var_20_7 = var_20_7 + 1
							
							UIUtil:getRewardIcon(var_20_2, var_20_1, {
								show_small_count = true,
								show_name = true,
								hide_type = true,
								parent = var_20_0:getChildByName("n_res0"),
								txt_name = var_20_0:getChildByName("txt_name0")
							})
							if_set(var_20_0, "txt_count0", T("it_count", {
								count = comma_value(Account:getPropertyCount(var_20_1))
							}))
						end
						
						if var_20_3 then
							var_20_7 = var_20_7 + 1
							
							UIUtil:getRewardIcon(var_20_4, var_20_3, {
								show_small_count = true,
								show_name = true,
								hide_type = true,
								parent = var_20_0:getChildByName("n_res1"),
								txt_name = var_20_0:getChildByName("txt_name1")
							})
							if_set(var_20_0, "txt_count1", T("it_count", {
								count = comma_value(Account:getPropertyCount(var_20_3))
							}))
						end
						
						if var_20_5 then
							var_20_7 = var_20_7 + 1
							
							UIUtil:getRewardIcon(var_20_6, var_20_5, {
								show_small_count = true,
								show_name = true,
								hide_type = true,
								parent = var_20_0:getChildByName("n_res2"),
								txt_name = var_20_0:getChildByName("txt_name2")
							})
							if_set(var_20_0, "txt_count2", T("it_count", {
								count = comma_value(Account:getPropertyCount(var_20_5))
							}))
						end
						
						local var_20_8 = var_20_0:getChildByName("info_" .. var_20_7 - 1):getPositionY()
						
						var_20_0:getChildByName("n_head"):setPositionY(var_20_8)
						
						local var_20_9 = var_20_0:getChildByName("bg")
						local var_20_10 = var_20_9:getContentSize()
						
						var_20_9:setContentSize({
							width = var_20_10.width,
							height = var_20_8 + 190
						})
						if_set_visible(var_20_0, "info_0", var_20_1 ~= nil)
						if_set_visible(var_20_0, "info_1", var_20_3 ~= nil)
						if_set_visible(var_20_0, "info_2", var_20_5 ~= nil)
						
						return var_20_0
					end
				})
				set_scale_fit_width(var_19_11, 290)
			end
		end
	end
end

function UnitSkill.removeTooltip(arg_21_0, arg_21_1)
	if arg_21_0.vars.tooltip then
		if arg_21_1 then
			arg_21_0.vars.tooltip:removeFromParent()
		else
			UIAction:Add(SEQ(LOG(SPAWN(MOVE_BY(180, 400), FADE_OUT(180))), REMOVE()), arg_21_0.vars.tooltip, "block")
		end
		
		arg_21_0.vars.tooltip = nil
	end
end

function UnitSkill.getResInfo(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.unit:getMaxSkillLevelByIndex(arg_22_0.vars.skill_idx)
	local var_22_1 = tonumber(arg_22_0.vars.unit.db.grade) or 1
	local var_22_2
	
	if EpisodeAdin:isAdinCode(arg_22_0.vars.unit.db.code) then
		var_22_2 = arg_22_0.vars.unit.db.code
	else
		var_22_2 = "g3"
		
		if var_22_1 == 4 then
			var_22_2 = "g4"
		elseif var_22_1 > 4 then
			var_22_2 = "g5"
		end
	end
	
	local var_22_3 = var_22_2 .. "_" .. tostring(var_22_0) .. "_" .. tostring(arg_22_1)
	
	if not DB("skill_upgrade", var_22_3, "id") then
		var_22_3 = tostring(var_22_0) .. "_" .. tostring(arg_22_1)
	end
	
	local var_22_4 = SLOW_DB_ALL("skill_upgrade", var_22_3)
	local var_22_5 = var_22_4.res0
	local var_22_6 = var_22_4.res_count0
	local var_22_7 = var_22_4.res1
	local var_22_8 = var_22_4.res_count1
	local var_22_9 = var_22_4["res2_" .. arg_22_0.vars.unit.db.zodiac]
	local var_22_10 = var_22_4.res_count2
	
	return var_22_5, var_22_6, var_22_7, var_22_8, var_22_9, var_22_10
end

function UnitSkill.onSelectSkill(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if not arg_23_2 and arg_23_0.vars.skill_idx == arg_23_1 then
		return 
	end
	
	if arg_23_1 and not arg_23_0.vars.unit:getSkillByIndex(arg_23_1) then
		return 
	end
	
	arg_23_0.vars.current_idx = arg_23_1
	
	local var_23_0 = arg_23_0.vars.wnd:getChildByName("CENTER")
	local var_23_1 = arg_23_0.vars.skill_idx
	
	arg_23_0.vars.skill_idx = arg_23_1
	
	local var_23_2 = arg_23_0.vars.unit:getMaxSkillLevelByIndex(arg_23_1)
	local var_23_3 = arg_23_0.vars.unit:getSkillLevelByIndex(arg_23_1)
	
	arg_23_0:updateSkillInfo(arg_23_2, arg_23_3)
	if_set_visible(arg_23_0.vars.wnd, "n_sel_none", arg_23_0.vars.skill_idx == nil)
	if_set_visible(arg_23_0.vars.wnd, "n_sk_tooltip", arg_23_0.vars.skill_idx ~= nil)
	if_set_visible(var_23_0, "selected", arg_23_0.vars.skill_idx ~= nil)
	
	if not arg_23_0.vars.skill_idx then
		if var_23_1 then
			UIAction:Add(LOG(MOVE_TO(180, 0, -200)), arg_23_0.vars.wnd:getChildByName("n_sel_skill"), "block")
			arg_23_0:removeTooltip(true)
		end
		
		return 
	end
	
	local var_23_4 = var_23_0:getChildByName("selected")
	
	if not var_23_1 then
		var_23_4:setPosition(arg_23_0.vars.wnd:getChildByName("n_skill" .. arg_23_1):getPosition())
	else
		UIAction:Add(LOG(MOVE_TO(180, arg_23_0.vars.wnd:getChildByName("n_skill" .. arg_23_1):getPosition())), var_23_4, "block")
	end
	
	local var_23_5 = arg_23_0.vars.wnd:getChildByName("n_res1")
	local var_23_6 = arg_23_0.vars.wnd:getChildByName("n_res2")
	
	var_23_5:removeAllChildren()
	var_23_6:removeAllChildren()
	
	local var_23_7 = arg_23_0.vars.unit:getSkillLevelByIndex(arg_23_0.vars.skill_idx) + 1
	local var_23_8 = arg_23_0.vars.unit:getMaxSkillLevelByIndex(arg_23_0.vars.skill_idx)
	local var_23_9, var_23_10, var_23_11, var_23_12, var_23_13, var_23_14 = arg_23_0:getResInfo(var_23_7)
	local var_23_15 = {}
	
	if var_23_9 then
		var_23_15[var_23_9] = var_23_10
	end
	
	if var_23_11 then
		var_23_15[var_23_11] = var_23_12
	end
	
	if var_23_13 then
		var_23_15[var_23_13] = var_23_14
	end
	
	arg_23_0.vars.res = var_23_15
	
	local var_23_16
	
	if var_23_11 then
		var_23_16 = UIUtil:getRewardIcon(var_23_12, var_23_11, {
			show_small_count = true,
			parent = var_23_5
		})
	end
	
	local var_23_17
	
	if var_23_13 then
		var_23_17 = UIUtil:getRewardIcon(var_23_14, var_23_13, {
			show_small_count = true,
			parent = var_23_6
		})
		
		if_set_visible(arg_23_0.vars.wnd, "item_2", true)
	else
		if_set(arg_23_0.vars.wnd, "txt_count2", "")
		if_set_visible(arg_23_0.vars.wnd, "item_2", false)
	end
	
	if var_23_16 then
		local var_23_18 = var_23_11 and var_23_12 > Account:getPropertyCount(var_23_11)
		
		if_set_visible(arg_23_0.vars.wnd, "n_lack1", var_23_18)
		
		if var_23_11 and var_23_12 > Account:getPropertyCount(var_23_11) then
			var_23_16:setOpacity(76.5)
		end
	end
	
	if var_23_17 then
		local var_23_19 = var_23_13 and var_23_14 > Account:getPropertyCount(var_23_13)
		
		if_set_visible(arg_23_0.vars.wnd, "n_lack2", var_23_19)
		
		if var_23_11 and var_23_14 > Account:getPropertyCount(var_23_13) then
			var_23_17:setOpacity(76.5)
		end
		
		if_call(arg_23_0.vars.wnd, "n_res_items", "setPositionX", 0)
	else
		if_call(arg_23_0.vars.wnd, "n_res_items", "setPositionX", 50)
	end
	
	if var_23_9 and var_23_10 > Account:getPropertyCount(var_23_9) then
		if_set_color(arg_23_0.vars.wnd, "cost", UIUtil.RED)
	else
		if_set_color(arg_23_0.vars.wnd, "cost", UIUtil.WHITE)
	end
	
	arg_23_0:newSkillUpgrade()
end

function UnitSkill.newSkillUpgrade(arg_24_0)
	if not arg_24_0.vars.unit or not arg_24_0.vars.wnd or not get_cocos_refid(arg_24_0.vars.wnd) then
		Log.e("스킬재료표시 에러")
		
		return 
	end
	
	local var_24_0 = arg_24_0.vars.unit:getMaxSkillLevelByIndex(arg_24_0.vars.skill_idx)
	local var_24_1 = arg_24_0.vars.wnd:getChildByName("n_resource_renewal")
	
	if not var_24_1 or not var_24_0 then
		return 
	end
	
	for iter_24_0 = 1, GAME_STATIC_VARIABLE.skill_max_level + 1 do
		local var_24_2 = var_24_1:getChildByName("n_skillup" .. iter_24_0)
		
		if not var_24_2 then
			break
		end
		
		var_24_2:removeAllChildren()
	end
	
	arg_24_0:changeSkillPos(var_24_0)
	
	local var_24_3 = 10
	local var_24_4 = 5
	local var_24_5 = 1
	local var_24_6 = 8 - (math.floor(var_24_0 / 3) * 3 + 2)
	local var_24_7 = arg_24_0:_getResSkillPoint() or 0
	
	for iter_24_1 = 1, var_24_0 do
		local var_24_8 = var_24_1:getChildByName("n_skillup" .. iter_24_1 + var_24_6)
		
		if not var_24_8 then
			break
		end
		
		local var_24_9, var_24_10, var_24_11, var_24_12, var_24_13, var_24_14 = arg_24_0:getResInfo(iter_24_1)
		local var_24_15 = load_dlg("skill_up_item", true, "wnd")
		local var_24_16 = 1
		local var_24_17 = not (iter_24_1 > arg_24_0.vars.unit:getSkillLevelByIndex(arg_24_0.vars.skill_idx))
		
		if arg_24_0:_isShowSkillPoint() and var_24_11 and var_24_11 == "ma_moragora1" and var_24_12 and var_24_12 > 0 and var_24_7 > 0 and not var_24_17 then
			if var_24_7 - var_24_12 >= 0 then
				arg_24_0:setItemIcon(var_24_15, "ma_skillpoint", var_24_12, var_24_16)
				
				var_24_16 = var_24_16 + 1
				var_24_7 = var_24_7 - var_24_12
			else
				arg_24_0:setItemIcon(var_24_15, "ma_skillpoint", var_24_7, var_24_16)
				
				var_24_16 = var_24_16 + 1
				
				arg_24_0:setItemIcon(var_24_15, var_24_11, var_24_12 - var_24_7, var_24_16)
				
				var_24_16 = var_24_16 + 1
				var_24_7 = 0
			end
		elseif var_24_11 and var_24_12 then
			arg_24_0:setItemIcon(var_24_15, var_24_11, var_24_12, var_24_16)
			
			var_24_16 = var_24_16 + 1
		end
		
		if var_24_13 and var_24_14 then
			arg_24_0:setItemIcon(var_24_15, var_24_13, var_24_14, var_24_16)
			
			var_24_16 = var_24_16 + 1
		end
		
		if var_24_9 and var_24_10 then
			arg_24_0:setItemIcon(var_24_15, var_24_9, var_24_10, var_24_16)
			
			local var_24_18 = var_24_16 + 1
		end
		
		if_set(var_24_15, "txt_point", "+" .. iter_24_1)
		
		local var_24_19 = DB("skill", arg_24_0.vars.skill_id, "sk_lv_eff" .. iter_24_1)
		local var_24_20 = DB("skill", arg_24_0.vars.skill_id, "sk_passive")
		
		if var_24_19 then
			if var_24_20 then
				if var_24_19 == "*ps_up" then
					local var_24_21 = T(DB("cs", tostring(var_24_20) .. iter_24_1, "cs_lvup_de"))
					
					if_set(var_24_15, "t_skill", var_24_21)
				else
					local var_24_22 = T(DB("cslv", tostring(var_24_19), "cslv_text"))
					
					if_set(var_24_15, "t_skill", var_24_22)
				end
			else
				if_set(var_24_15, "t_skill", T(DB("sklv", tostring(var_24_19), "sklv_text")))
			end
			
			if var_24_17 then
				var_24_15:getChildByName("txt_point"):setOpacity(255)
				if_set_color(var_24_15, "t_skill", tocolor("#FFFFFF"))
				var_24_15:getChildByName("skillup_bg_un"):setVisible(false)
				var_24_15:getChildByName("skillup_bg"):setVisible(true)
			else
				var_24_15:getChildByName("txt_point"):setOpacity(76.5)
				if_set_color(var_24_15, "t_skill", tocolor("#999999"))
				var_24_15:getChildByName("skillup_bg_un"):setVisible(true)
				var_24_15:getChildByName("skillup_bg"):setVisible(false)
			end
		end
		
		var_24_8:addChild(var_24_15)
		
		if var_24_0 > arg_24_0.vars.before_maxlv then
			var_24_15:setVisible(false)
			UIAction:Add(SEQ(DELAY(var_24_3), SHOW(true), FADE_IN(200)), var_24_15)
		end
		
		var_24_5 = var_24_5 + 1
		
		if var_24_5 % 2 == 1 then
			var_24_3 = var_24_3 + var_24_4
		end
		
		var_24_15:setAnchorPoint(0, 0)
		var_24_15:setPosition(0, 0)
	end
	
	arg_24_0.vars.before_maxlv = var_24_0
	
	if var_24_0 == arg_24_0.vars.unit:getSkillLevelByIndex(arg_24_0.vars.skill_idx) then
		if_set_visible(var_24_1, "n_btn", false)
	else
		if_set_visible(var_24_1, "n_btn", true)
	end
end

function UnitSkill.setItemIcon(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	if not arg_25_1 or arg_25_2 == nil or arg_25_3 == nil or arg_25_4 == nil then
		return 
	end
	
	local var_25_0 = arg_25_1:getChildByName("item" .. arg_25_4)
	
	var_25_0:removeAllChildren()
	
	local var_25_1 = UIUtil:getRewardIcon(arg_25_3, arg_25_2, {
		no_tooltip = false,
		no_bg = true,
		no_grade = true,
		parent = var_25_0
	})
	
	var_25_1:getChildByName("txt_small_count"):setScale(1.2)
	arg_25_0:setRewardIconCount(var_25_1, arg_25_3)
	
	local var_25_2 = 0
	
	if arg_25_2 == "ma_skillpoint" then
		var_25_2 = arg_25_0:_getResSkillPoint()
	else
		var_25_2 = Account:getPropertyCount(arg_25_2)
	end
	
	if var_25_2 < arg_25_3 then
		arg_25_1:getChildByName("item" .. arg_25_4):setOpacity(76.5)
	else
		arg_25_1:getChildByName("item" .. arg_25_4):setOpacity(255)
	end
end

function UnitSkill.UpdateLeftResource(arg_26_0)
	if not arg_26_0.vars and not arg_26_0.vars.unit then
		return 
	end
	
	local var_26_0
	local var_26_1
	local var_26_2 = arg_26_0.vars.unit:getMaxSkillLevelByIndex(arg_26_0.vars.skill_idx)
	local var_26_3 = arg_26_0.vars.wnd:getChildByName("n_resource_renewal")
	local var_26_4 = arg_26_0.vars.wnd:getChildByName("n_mura")
	local var_26_5 = false
	
	if not var_26_2 or not var_26_3 or not var_26_4 then
		Log.e("촉매제 업데이트 실패")
		
		return 
	end
	
	if_set_visible(arg_26_0.vars.wnd, "n_mura", true)
	
	for iter_26_0 = 1, var_26_2 do
		local var_26_6, var_26_7, var_26_8, var_26_9, var_26_10, var_26_11 = arg_26_0:getResInfo(iter_26_0)
		
		if var_26_10 ~= var_26_0 and var_26_5 == false then
			var_26_0 = var_26_10
			var_26_1 = var_26_10
			var_26_5 = true
		end
		
		if var_26_10 ~= var_26_1 then
			var_26_1 = var_26_10
		end
	end
	
	if var_26_0 == var_26_1 then
		var_26_1 = nil
	end
	
	arg_26_0.vars.cur_resource1 = var_26_0
	arg_26_0.vars.cur_resource2 = var_26_1
	
	local var_26_12
	local var_26_13
	
	if not arg_26_0.vars.birth_grade then
		local var_26_14 = 4
	end
	
	if_set_visible(arg_26_0.vars.wnd, "n_skill_point", arg_26_0:_isShowSkillPoint(true))
	if_set_visible(arg_26_0.vars.wnd, "n_normal", not arg_26_0:_isShowSkillPoint(true))
	
	if arg_26_0:_isShowSkillPoint(true) then
		var_26_4 = var_26_4:getChildByName("n_skill_point")
	else
		var_26_4 = var_26_4:getChildByName("n_normal")
	end
	
	for iter_26_1 = 1, 5 do
		local var_26_15 = var_26_4:getChildByName("item" .. iter_26_1)
		
		if get_cocos_refid(var_26_15) then
			var_26_15:removeAllChildren()
		end
	end
	
	local var_26_16 = 1
	
	if not arg_26_0:_isShowSkillPoint(true) then
		local var_26_17 = var_26_4:getChildByName("item" .. var_26_16)
		local var_26_18 = UIUtil:getRewardIcon(Account:getPropertyCount("to_stigma"), "to_stigma", {
			no_tooltip = false,
			no_bg = true,
			scale = 1,
			no_grade = true,
			parent = var_26_17
		})
		
		arg_26_0:setRewardIconCount(var_26_18, Account:getPropertyCount("to_stigma"))
	else
		local var_26_19 = var_26_4:getChildByName("item" .. var_26_16)
		local var_26_20 = UIUtil:getRewardIcon(arg_26_0:_getResSkillPoint(), "ma_skillpoint", {
			no_tooltip = false,
			no_bg = true,
			scale = 1,
			no_grade = true,
			parent = var_26_19
		})
		
		arg_26_0:setRewardIconCount(var_26_20, arg_26_0:_getResSkillPoint())
		
		var_26_16 = var_26_16 + 1
		
		local var_26_21 = var_26_4:getChildByName("item" .. var_26_16)
		local var_26_22 = UIUtil:getRewardIcon(Account:getPropertyCount("ma_moragora1"), "ma_moragora1", {
			no_tooltip = false,
			no_bg = true,
			scale = 1,
			no_grade = true,
			parent = var_26_21
		})
		
		arg_26_0:setRewardIconCount(var_26_22, Account:getPropertyCount("ma_moragora1"))
		
		var_26_16 = var_26_16 + 1
		
		local var_26_23 = var_26_4:getChildByName("item" .. var_26_16)
		local var_26_24 = UIUtil:getRewardIcon(Account:getPropertyCount("ma_moragora2"), "ma_moragora2", {
			no_tooltip = false,
			no_bg = true,
			scale = 1,
			no_grade = true,
			parent = var_26_23
		})
		
		arg_26_0:setRewardIconCount(var_26_24, Account:getPropertyCount("ma_moragora2"))
	end
	
	local var_26_25 = var_26_16 + 1
	local var_26_26 = var_26_4:getChildByName("item" .. var_26_25)
	
	if var_26_0 ~= nil then
		var_26_26:setVisible(true)
		
		local var_26_27 = UIUtil:getRewardIcon(Account:getPropertyCount(var_26_0), var_26_0, {
			no_tooltip = false,
			no_bg = true,
			scale = 1,
			no_grade = true,
			parent = var_26_26
		})
		
		arg_26_0:setRewardIconCount(var_26_27, Account:getPropertyCount(var_26_0))
	end
	
	local var_26_28 = var_26_25 + 1
	local var_26_29 = var_26_4:getChildByName("item" .. var_26_28)
	
	if var_26_1 ~= nil then
		var_26_29:setVisible(true)
		
		local var_26_30 = UIUtil:getRewardIcon(Account:getPropertyCount(var_26_1), var_26_1, {
			no_tooltip = false,
			no_bg = true,
			scale = 1,
			no_grade = true,
			parent = var_26_29
		})
		
		arg_26_0:setRewardIconCount(var_26_30, Account:getPropertyCount(var_26_1))
	end
end

function UnitSkill.setRewardIconCount(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_1 or not arg_27_2 then
		return 
	end
	
	if arg_27_2 == 0 or arg_27_2 == 1 then
		if_set_visible(arg_27_1, "txt_small_count", true)
		if_set(arg_27_1, "txt_small_count", arg_27_2)
	end
end

function UnitSkill.UpdateLeftResourceCount(arg_28_0)
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_mura")
	local var_28_1 = var_28_0:getChildByName("n_normal")
	local var_28_2
	local var_28_3 = 1
	
	if not arg_28_0:_isShowSkillPoint(true) then
		local var_28_4 = var_28_1:getChildByName("item" .. var_28_3)
		
		if_set(var_28_4, "txt_small_count", comma_value(Account:getPropertyCount("to_stigma")))
	else
		var_28_1 = var_28_0:getChildByName("n_skill_point")
		
		local var_28_5 = arg_28_0:_getResSkillPoint() or 0
		local var_28_6 = var_28_1:getChildByName("item" .. var_28_3)
		
		if_set(var_28_6, "txt_small_count", comma_value(var_28_5))
		
		var_28_3 = var_28_3 + 1
		
		local var_28_7 = var_28_1:getChildByName("item" .. var_28_3)
		
		if_set(var_28_7, "txt_small_count", comma_value(Account:getPropertyCount("ma_moragora1")))
		
		var_28_3 = var_28_3 + 1
		
		local var_28_8 = var_28_1:getChildByName("item" .. var_28_3)
		
		if_set(var_28_8, "txt_small_count", comma_value(Account:getPropertyCount("ma_moragora2")))
	end
	
	local var_28_9 = var_28_3 + 1
	
	if arg_28_0.vars.cur_resource1 ~= nil then
		local var_28_10 = var_28_1:getChildByName("item" .. var_28_9)
		
		if_set(var_28_10, "txt_small_count", comma_value(Account:getPropertyCount(arg_28_0.vars.cur_resource1)))
		
		var_28_9 = var_28_9 + 1
	end
	
	if arg_28_0.vars.cur_resource2 ~= nil then
		local var_28_11 = var_28_1:getChildByName("item" .. var_28_9)
		
		if_set(var_28_11, "txt_small_count", comma_value(Account:getPropertyCount(arg_28_0.vars.cur_resource2)))
		
		local var_28_12 = var_28_9 + 1
	end
	
	arg_28_0:onSelectSkill(arg_28_0.vars.current_idx, true, false)
end

function UnitSkill.changeSkillPos(arg_29_0, arg_29_1)
	if not arg_29_0.vars.wnd:getChildByName("CENTER") or arg_29_0.vars.skillbase_posY == nil then
		return 
	end
	
	local var_29_0 = 180
	local var_29_1 = ""
	
	if arg_29_1 >= 6 then
		var_29_1 = "n_n_sel_skill_move6-8"
	elseif arg_29_1 >= 3 then
		var_29_1 = "n_n_sel_skill_move3-5"
	elseif arg_29_1 >= 1 then
		var_29_1 = "n_n_sel_skill_move1-2"
	end
	
	local var_29_2, var_29_3 = arg_29_0.vars.wnd:findChildByName(var_29_1):getPosition()
	
	UIAction:Add(MOVE_TO(var_29_0, var_29_2, var_29_3), arg_29_0.vars.wnd:getChildByName("n_sel_skill"), "block")
end

local function var_0_0(arg_30_0, arg_30_1)
	UnitSkill:onChangeSlider(arg_30_0:getPercent(), arg_30_1)
end

function UnitSkill.onChangeSlider(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = math.floor(arg_31_0.vars.exchange_maxcount / arg_31_0.vars.exchange_gap * arg_31_1 / 100)
	
	arg_31_0.vars.exchange_slider.slider_pos = var_31_0
	
	arg_31_0:updateCount(var_31_0 * arg_31_0.vars.exchange_gap)
	
	local var_31_1 = arg_31_0.vars.exchange_count * 100 / arg_31_0.vars.exchange_maxcount
	
	arg_31_0.vars.exchange_slider:setPercent(var_31_1)
end

function UnitSkill.checkRequestSkillPoint(arg_32_0, arg_32_1)
	if not arg_32_0.vars then
		return 
	end
	
	local var_32_0 = arg_32_1 or arg_32_0.vars.unit
	
	if not var_32_0 then
		return 
	end
	
	if var_32_0:canRequest_skillPoint() then
		query("refund_skillpoint", {
			uid = var_32_0:getUID()
		})
	end
end

function UnitSkill.show_moraToSkillPointPopup(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) or not arg_33_1 then
		return 
	end
	
	arg_33_0.vars.refundPopup = load_dlg("skill_up_refunds", true, "wnd", function()
		UnitSkill:close_moraToSkillPointPopup()
	end)
	
	arg_33_0.vars.wnd:addChild(arg_33_0.vars.refundPopup)
	
	local var_33_0 = (Account:addReward(arg_33_1.rewards) or {}).rewards or {}
	
	if table.count(var_33_0) == 1 and var_33_0[1] then
		if_set_visible(arg_33_0.vars.refundPopup, "n_item_icon1/1", true)
		arg_33_0.vars.refundPopup:getChildByName("n_item_icon1/1"):removeAllChildren()
		UIUtil:getRewardIcon(var_33_0[1].count, var_33_0[1].code, {
			no_tooltip = false,
			no_bg = true,
			parent = arg_33_0.vars.refundPopup:getChildByName("n_item_icon1/1")
		})
	end
	
	local var_33_1 = Account:getUnit(arg_33_1.unit.id)
	
	var_33_1:setSkillLevelInfo(arg_33_1.unit.s)
	
	if arg_33_1.unit.opt then
		var_33_1.inst.unit_option = arg_33_1.unit.opt
	end
	
	var_33_1:reset()
	if_set(arg_33_0.vars.refundPopup, "txt_title", T("ui_skillup_refunds_title"))
	if_set(arg_33_0.vars.refundPopup, "t_disc", T("ui_skillup_refunds_desc", {
		name = var_33_1:getName()
	}))
	TopBarNew:topbarUpdate(true)
	arg_33_0:UpdateLeftResourceCount()
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		delay = 0,
		pivot_z = 99998,
		layer = UnitSkill.vars.refundPopup,
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = UnitSkill.vars.refundPopup:getChildByName("txt_title"):getPositionY() + 120
	})
end

function UnitSkill.close_moraToSkillPointPopup(arg_35_0)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.refundPopup) then
		return 
	end
	
	BackButtonManager:pop("skill_up_refunds")
	arg_35_0.vars.refundPopup:removeFromParent()
	
	arg_35_0.vars.refundPopup = nil
end

function UnitSkill.exchangeMuraPopup_ex(arg_36_0)
	if arg_36_0.vars.is_invisible_button_unit then
		balloon_message_with_sound("msg_cannot_use_btn_hero")
		
		return 
	end
	
	if not get_cocos_refid(arg_36_0.vars.exchange_wnd_ex) then
		arg_36_0.vars.exchange_wnd_ex = load_dlg("skill_up_mura_ex", true, "wnd", function()
			UnitSkill:closeMuraPopup_ex()
		end)
		
		UnitMain.vars.base_wnd:addChild(arg_36_0.vars.exchange_wnd_ex)
		arg_36_0.vars.exchange_wnd_ex:bringToFront()
	end
	
	if_set_visible(arg_36_0.vars.exchange_wnd_ex, "n_detail", true)
	if_set_visible(arg_36_0.vars.exchange_wnd_ex, "n_detail_yet", false)
	
	arg_36_0.vars.exchange_id = nil
	arg_36_0.vars.exchange_spendid = nil
	arg_36_0.vars.exchange_count = 0
	arg_36_0.vars.exchange_maxcount = 0
	arg_36_0.vars.exchange_gap = 4
	arg_36_0.vars.exchange_slider = arg_36_0.vars.exchange_wnd_ex:getChildByName("slider")
	arg_36_0.vars.exchange_spendid = "ma_moragora2"
	arg_36_0.vars.exchange_id = "ma_moragora1"
	
	arg_36_0.vars.exchange_slider:addEventListener(var_0_0)
	
	local var_36_0 = arg_36_0.vars.exchange_wnd_ex:getChildByName("n_detail")
	local var_36_1, var_36_2 = DB("item_material", "ma_moragora2", {
		"name",
		"desc_category"
	})
	local var_36_3, var_36_4 = DB("item_material", "ma_moragora1", {
		"name",
		"desc_category"
	})
	local var_36_5 = var_36_0:findChildByName("t_title1")
	local var_36_6 = var_36_0:findChildByName("t_name1")
	local var_36_7 = var_36_0:findChildByName("t_title2")
	local var_36_8 = var_36_0:findChildByName("t_name2")
	
	if_set(var_36_5, nil, T(var_36_2))
	if_set(var_36_6, nil, T(var_36_1))
	if_set(var_36_7, nil, T(var_36_4))
	if_set(var_36_8, nil, T(var_36_3))
	
	if var_36_5:getStringNumLines() == 2 then
		var_36_6._origin_pos_y = var_36_6._origin_pos_y or var_36_6:getPositionY()
		
		var_36_6:setPositionY(var_36_6._origin_pos_y - 11)
	end
	
	if var_36_7:getStringNumLines() == 2 then
		var_36_8._origin_pos_y = var_36_8._origin_pos_y or var_36_8:getPositionY()
		
		var_36_8:setPositionY(var_36_8._origin_pos_y - 11)
	end
	
	if_set(var_36_0:getChildByName("btn_plus"), "label", "+4")
	if_set(var_36_0:getChildByName("btn_minus"), "label", "-4")
	
	local var_36_9 = var_36_0:getChildByName("n_from"):getChildByName("reward_item")
	local var_36_10 = var_36_0:getChildByName("n_to"):getChildByName("reward_item")
	
	var_36_9:removeAllChildren()
	var_36_10:removeAllChildren()
	UIUtil:getRewardIcon(nil, arg_36_0.vars.exchange_spendid, {
		show_name = false,
		parent = var_36_9
	})
	UIUtil:getRewardIcon(nil, arg_36_0.vars.exchange_id, {
		show_name = false,
		parent = var_36_10
	})
	arg_36_0:update_exchange_mura()
end

function UnitSkill.update_exchange_mura(arg_38_0)
	if Account:getPropertyCount("ma_moragora2") < 1 then
		if_set(arg_38_0.vars.exchange_wnd_ex, "t_lack", T("exchange_muragora_lack2"))
	end
	
	arg_38_0.vars.exchange_count = 0
	
	local var_38_0 = arg_38_0.vars.exchange_wnd_ex:getChildByName("n_detail")
	
	if_set_visible(var_38_0, "t_lack", false)
	if_set_visible(var_38_0, "t_mix_count", true)
	if_set_opacity(var_38_0, "btn_go", 255)
	
	arg_38_0.vars.exchange_maxcount = Account:getPropertyCount("ma_moragora2") * 4
	
	if arg_38_0.vars.exchange_maxcount <= 0 then
		arg_38_0.vars.exchange_slider:setPercent(0)
		if_set_visible(var_38_0, "t_lack", true)
		if_set_visible(var_38_0, "t_mix_count", false)
		if_set_opacity(var_38_0, "btn_go", 76.5)
		if_set(arg_38_0.vars.exchange_wnd_ex, "count_from", T("exchange_muragora_popup_use", {
			count = 0
		}))
		if_set(arg_38_0.vars.exchange_wnd_ex, "count_to", T("exchange_muragora_popup_cnt", {
			count = 0
		}))
		
		return 
	end
	
	arg_38_0:updateCount(0, true)
end

function UnitSkill.onSliderButton(arg_39_0, arg_39_1)
	if arg_39_0.vars.exchange_count < 0 then
		return 
	end
	
	local var_39_0 = 0
	
	if arg_39_1 == "btn_minus" then
		var_39_0 = math.max(arg_39_0.vars.exchange_count - arg_39_0.vars.exchange_gap, 0)
	end
	
	if arg_39_1 == "btn_min" then
		var_39_0 = 0
	end
	
	if arg_39_1 == "btn_max" then
		var_39_0 = arg_39_0.vars.exchange_maxcount
	end
	
	if arg_39_1 == "btn_plus" then
		var_39_0 = math.min(arg_39_0.vars.exchange_count + arg_39_0.vars.exchange_gap, arg_39_0.vars.exchange_maxcount)
	end
	
	arg_39_0.vars.exchange_slider:setPercent(100 * var_39_0 / arg_39_0.vars.exchange_maxcount)
	arg_39_0:updateCount(var_39_0)
end

function UnitSkill.updateCount(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_2 and arg_40_1 == arg_40_0.vars.exchange_count then
		return 
	end
	
	if arg_40_1 == 0 and arg_40_0.vars.exchange_maxcount > 0 then
		arg_40_1 = 0
		
		arg_40_0.vars.exchange_slider:setPercent(0)
	end
	
	if arg_40_0.vars.exchange_id == "ma_moragora1" then
		if_set(arg_40_0.vars.exchange_wnd_ex, "count_from", T("exchange_muragora_popup_use", {
			count = arg_40_1 / 4
		}))
		if_set(arg_40_0.vars.exchange_wnd_ex, "count_to", T("exchange_muragora_popup_cnt", {
			count = arg_40_1
		}))
	end
	
	arg_40_0.vars.exchange_count = arg_40_1
	
	if_set(arg_40_0.vars.exchange_wnd_ex:getChildByName("n_detail"), "t_mix_count", tostring(arg_40_0.vars.exchange_count) .. "/" .. arg_40_0.vars.exchange_maxcount)
	
	if arg_40_0.vars.exchange_count <= 0 then
		if_set_opacity(arg_40_0.vars.exchange_wnd_ex:getChildByName("n_detail"), "btn_go", 76.5)
	else
		if_set_opacity(arg_40_0.vars.exchange_wnd_ex:getChildByName("n_detail"), "btn_go", 255)
	end
end

function UnitSkill.reqExchageMura(arg_41_0)
	if arg_41_0.vars.exchange_count <= 0 then
		return 
	end
	
	query("exchange_mura", {
		exchange_to = arg_41_0.vars.exchange_id,
		exchange_to_count = arg_41_0.vars.exchange_count,
		exchange_from = arg_41_0.vars.exchange_spendid
	})
end

function UnitSkill.refresh_exchangePopup(arg_42_0, arg_42_1)
	arg_42_0:exchangeMuraPopup_ex()
	arg_42_0:update_exchange_mura()
end

function UnitSkill.closeMuraPopup_ex(arg_43_0)
	if get_cocos_refid(arg_43_0.vars.exchange_wnd_ex) then
		BackButtonManager:pop("skill_up_mura_ex")
		arg_43_0.vars.exchange_wnd_ex:removeFromParent()
		
		arg_43_0.vars.exchange_wnd_ex = nil
	end
end

function UnitSkill.onChangeUnit(arg_44_0, arg_44_1)
	if arg_44_0.vars then
		arg_44_0.vars.changed_unit = arg_44_1
		arg_44_0.vars.changed_tm = uitick()
	end
end

function UnitSkill.onAfterUpdate(arg_45_0)
	if arg_45_0.vars and arg_45_0.vars.changed_tm and arg_45_0.vars.changed_tm + 500 < uitick() then
		arg_45_0:onSelectUnit(arg_45_0.vars.changed_unit)
		
		arg_45_0.vars.changed_tm = nil
		arg_45_0.vars.changed_unit = nil
	end
end

function UnitSkill.onTouchDown(arg_46_0, arg_46_1)
end

function UnitSkill.onTouchUp(arg_47_0, arg_47_1)
end

function UnitSkill.reqUpgradeSkill(arg_48_0)
	local var_48_0 = UnitSkill.vars.unit
	local var_48_1 = UnitSkill.vars.skill_idx
	local var_48_2
	local var_48_3
	
	if IS_PUBLISHER_ZLONG then
		var_48_2 = var_48_0:getPoint()
		
		local var_48_4 = var_48_0:clone()
		local var_48_5 = var_48_4.inst.skill_lv[var_48_1]
		
		var_48_4.inst.skill_lv[var_48_1] = (var_48_5 or 0) + 1
		
		var_48_4:calc()
		
		var_48_3 = var_48_4:getPoint()
	end
	
	query("upgrade_skill", {
		uid = var_48_0.inst.uid,
		idx = var_48_1,
		begin_point = var_48_2,
		after_point = var_48_3
	})
	arg_48_0:closeConfirmPopup()
end

function UnitSkill.openConfirmPopup(arg_49_0)
	if UnitExtension:isAttrChangeableUnit(arg_49_0.vars.unit.db.code) and not UnitExtension:isSkillUpgradeUnlocked(arg_49_0.vars.unit.db.code) then
		UnitExtension:openSkillUpgradeUnlockMsgbox(arg_49_0.vars.unit.db.code)
		
		return 
	end
	
	for iter_49_0, iter_49_1 in pairs(arg_49_0.vars.res) do
		local var_49_0 = Account:getPropertyCount(iter_49_0) or 0
		
		if string.find(iter_49_0, "ma_moragora1") then
			var_49_0 = var_49_0 + arg_49_0:_getResSkillPoint()
		end
		
		if var_49_0 < iter_49_1 then
			UIUtil:checkCurrencyDialog(iter_49_0)
			
			return 
		end
	end
	
	arg_49_0.vars.confirmPopup = load_dlg("skill_up_confirm", true, "wnd", function()
		UnitSkill:closeConfirmPopup()
	end)
	
	if UnitMain.vars and get_cocos_refid(UnitMain.vars.base_wnd) then
		UnitMain.vars.base_wnd:addChild(arg_49_0.vars.confirmPopup)
		arg_49_0.vars.confirmPopup:bringToFront()
	else
		arg_49_0.vars.wnd:addChild(arg_49_0.vars.confirmPopup)
	end
	
	local var_49_1 = arg_49_0.vars.unit:getMaxSkillLevelByIndex(arg_49_0.vars.skill_idx)
	local var_49_2 = arg_49_0.vars.unit:getSkillLevelByIndex(arg_49_0.vars.skill_idx)
	local var_49_3 = var_49_2 + 1
	local var_49_4, var_49_5 = DB("skill", arg_49_0.vars.skill_id, {
		"sk_lv_eff" .. var_49_3,
		"name"
	})
	
	if var_49_4 then
		local var_49_6 = DB("skill", arg_49_0.vars.skill_id, "sk_passive")
		
		if var_49_6 then
			if var_49_4 == "*ps_up" then
				if_set(arg_49_0.vars.confirmPopup, "t_reinforce", T(DB("cs", tostring(var_49_6) .. var_49_3, "cs_lvup_de")))
			else
				if_set(arg_49_0.vars.confirmPopup, "t_reinforce", T(DB("cslv", tostring(var_49_4), "cslv_text")))
			end
		else
			if_set(arg_49_0.vars.confirmPopup, "t_reinforce", T(DB("sklv", tostring(var_49_4), "sklv_text")))
		end
		
		if_set_color(arg_49_0.vars.confirmPopup, "t_reinforce", tocolor("#999999"))
	end
	
	if_set(arg_49_0.vars.confirmPopup, "t_disc", T("ui_skillup_popup_desc", {
		skill = T(var_49_5)
	}))
	
	local var_49_7 = arg_49_0.vars.confirmPopup:getChildByName("n_skill_icon_before")
	local var_49_8 = var_49_2
	local var_49_9 = UIUtil:getSkillIcon(arg_49_0.vars.unit, arg_49_0.vars.skill_id, {
		hud_skill = true,
		no_tooltip = true
	})
	
	if_set_visible(var_49_9, "selected", false)
	if_set_visible(var_49_9, "cost", false)
	
	if var_49_8 == 0 then
		if_set_visible(var_49_9, "up", false)
	else
		if_set_visible(var_49_9, "up", true)
		if_set(var_49_9, "txt_up", "+" .. var_49_8)
	end
	
	if_set_visible(var_49_9, "frame", false)
	var_49_7:addChild(var_49_9)
	
	local var_49_10 = arg_49_0.vars.confirmPopup:getChildByName("n_skill_icon_after")
	local var_49_11 = var_49_3
	local var_49_12 = UIUtil:getSkillIcon(arg_49_0.vars.unit, arg_49_0.vars.skill_id, {
		hud_skill = true,
		no_tooltip = true
	})
	
	if_set_visible(var_49_12, "selected", false)
	if_set_visible(var_49_12, "cost", false)
	
	if var_49_11 == 0 then
		if_set_visible(var_49_12, "up", false)
	else
		if_set_visible(var_49_12, "up", true)
		if_set(var_49_12, "txt_up", "+" .. var_49_11)
	end
	
	if_set_visible(var_49_12, "frame", false)
	var_49_10:addChild(var_49_12)
	
	local function var_49_13(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		if not arg_51_0 or arg_51_1 == nil or arg_51_2 == nil or arg_51_3 == nil then
			return 
		end
		
		local var_51_0 = arg_51_0:getChildByName("n_item_icon" .. arg_51_3)
		
		var_51_0:removeAllChildren()
		
		local var_51_1 = UIUtil:getRewardIcon(arg_51_2, arg_51_1, {
			no_tooltip = false,
			no_bg = true,
			no_grade = true,
			parent = var_51_0
		})
		
		arg_49_0:setRewardIconCount(var_51_1, arg_51_2)
		
		local var_51_2 = 0
		
		if arg_51_1 == "ma_skillpoint" then
			var_51_2 = arg_49_0:_getResSkillPoint()
		else
			var_51_2 = Account:getPropertyCount(arg_51_1)
		end
		
		if var_51_2 < arg_51_2 then
			arg_51_0:getChildByName("n_item_icon" .. arg_51_3):setOpacity(76.5)
		else
			arg_51_0:getChildByName("n_item_icon" .. arg_51_3):setOpacity(255)
		end
	end
	
	local var_49_14, var_49_15, var_49_16, var_49_17, var_49_18, var_49_19 = arg_49_0:getResInfo(var_49_3)
	local var_49_20 = arg_49_0:_getResSkillPoint() or 0
	local var_49_21 = 0
	local var_49_22 = 1
	
	if var_49_14 then
		var_49_21 = var_49_21 + 1
	end
	
	if var_49_18 then
		var_49_21 = var_49_21 + 1
	end
	
	local var_49_23 = arg_49_0:_isShowSkillPoint() and var_49_16 and var_49_16 == "ma_moragora1" and var_49_17 and var_49_17 > 0 and var_49_20 > 0
	
	if var_49_23 then
		if var_49_20 - var_49_17 >= 0 then
			var_49_21 = var_49_21 + 1
		else
			var_49_21 = var_49_21 + 2
		end
	elseif var_49_16 and var_49_17 then
		var_49_21 = var_49_21 + 1
	end
	
	local var_49_24 = arg_49_0.vars.confirmPopup:getChildByName("n_odd")
	
	if_set_visible(arg_49_0.vars.confirmPopup, "n_odd", true)
	
	if var_49_21 % 2 == 0 then
		var_49_24 = arg_49_0.vars.confirmPopup:getChildByName("n_even")
		
		if_set_visible(arg_49_0.vars.confirmPopup, "n_odd", false)
		if_set_visible(arg_49_0.vars.confirmPopup, "n_even", true)
		
		if var_49_21 == 2 then
			var_49_22 = 2
		end
	end
	
	for iter_49_2 = 1, 4 do
		local var_49_25 = var_49_24:getChildByName("n_item_icon" .. iter_49_2)
		
		if not get_cocos_refid(var_49_25) then
			break
		end
		
		var_49_25:removeAllChildren()
	end
	
	if var_49_23 then
		if var_49_20 - var_49_17 >= 0 then
			var_49_13(var_49_24, "ma_skillpoint", var_49_17, var_49_22)
			
			var_49_22 = var_49_22 + 1
			var_49_20 = var_49_20 - var_49_17
		else
			var_49_13(var_49_24, "ma_skillpoint", var_49_20, var_49_22)
			
			var_49_22 = var_49_22 + 1
			
			var_49_13(var_49_24, var_49_16, var_49_17 - var_49_20, var_49_22)
			
			var_49_22 = var_49_22 + 1
			
			local var_49_26 = 0
		end
	elseif var_49_16 and var_49_17 then
		var_49_13(var_49_24, var_49_16, var_49_17, var_49_22)
		
		var_49_22 = var_49_22 + 1
	end
	
	if var_49_18 and var_49_19 then
		var_49_13(var_49_24, var_49_18, var_49_19, var_49_22)
		
		var_49_22 = var_49_22 + 1
	end
	
	if var_49_14 and var_49_15 then
		var_49_13(var_49_24, var_49_14, var_49_15, var_49_22)
		
		local var_49_27 = var_49_22 + 1
	end
end

function UnitSkill.closeConfirmPopup(arg_52_0)
	if not arg_52_0.vars or not get_cocos_refid(arg_52_0.vars.confirmPopup) then
		return 
	end
	
	BackButtonManager:pop("skill_up_confirm")
	arg_52_0.vars.confirmPopup:removeFromParent()
	
	arg_52_0.vars.confirmPopup = nil
end

function UnitSkill._isShowSkillPoint(arg_53_0, arg_53_1)
	if not arg_53_0.vars then
		return 
	end
	
	local var_53_0 = false
	local var_53_1 = arg_53_0.vars.birth_grade or 0
	local var_53_2 = arg_53_0.vars.unit:getFavLevel() or 0
	
	if arg_53_1 then
		var_53_0 = var_53_1 > 3
	else
		var_53_0 = var_53_1 > 3 and var_53_2 >= 10
	end
	
	return var_53_0
end

function UnitSkill.procUpgrade_0(arg_54_0, arg_54_1)
	SoundEngine:play("event:/ui/hero_grow_02_levelup")
	
	local var_54_0 = arg_54_0.vars.unit:isMaxLevel()
	local var_54_1 = to_n(arg_54_1.exp_ratio)
	local var_54_2 = 70
	local var_54_3 = 0
	local var_54_4 = NONE()
	local var_54_5 = NONE()
	local var_54_6 = CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_54_0.vars.unit)
	
	UIAction:Add(SEQ(SPAWN(SEQ(LOG(BLEND(500, "white", 0, 1), 100), DELAY(var_54_3), RLOG(BLEND(200, "white", 1, 0), 100), LOG(BLEND(0))), CALL(UnitSkill.playBgEffect, arg_54_0), var_54_5, SEQ(LOG(SCALE(500, 0.8, 0.85)), DELAY(var_54_3), var_54_6, CALL(UnitSkill.procUpgrade_1, arg_54_0, arg_54_1), RLOG(SCALE(100, 0.8, 0.75)), RLOG(SCALE(100, 0.75, 0.8))))), UnitMain:getPortrait(), "block")
	UIAction:AddSync(DELAY(1100), arg_54_0, "block")
end

function UnitSkill.procUpgrade_1(arg_55_0, arg_55_1)
	local var_55_0 = Account:getUnit(arg_55_1.unit.id)
	local var_55_1 = var_55_0:getTotalSkillLevel()
	
	var_55_0:setSkillLevelInfo(arg_55_1.unit.s)
	
	if arg_55_1.unit.opt then
		var_55_0.inst.unit_option = arg_55_1.unit.opt
	end
	
	var_55_0:reset()
	
	local var_55_2 = var_55_0:getTotalSkillLevel()
	
	ConditionContentsManager:dispatch("unit.skillup", {
		grade = var_55_0:getBaseGrade(),
		pre_level = var_55_1,
		level = var_55_2
	})
	ConditionContentsManager:dispatch("growthboost.sync.sklv")
	
	if var_55_0.db.code == "c3026" then
		ConditionContentsManager:dispatch("c3026.skillup", {
			unit = var_55_0
		})
	end
	
	HeroBelt:getInst("UnitMain"):updateUnit(nil, var_55_0)
	Account:updateProperties(arg_55_1.properties)
	TopBarNew:topbarUpdate(true)
	arg_55_0:UpdateLeftResourceCount()
	EffectManager:Play({
		fn = "ui_skill_enchant_eff.cfx",
		layer = arg_55_0.vars.wnd:getChildByName("n_skill" .. arg_55_0.vars.skill_idx)
	})
	UIAction:Add(SEQ(DELAY(400), CALL(function()
		arg_55_0:onSelectSkill(arg_55_0.vars.skill_idx, true, true)
		GrowthGuideNavigator:proc()
		UnitSkill:checkRequestSkillPoint(var_55_0)
	end)), arg_55_0.vars.wnd, "block")
end

function UnitSkill.checkNotification(arg_57_0)
	local var_57_0 = Account:getUnits() or {}
	
	for iter_57_0, iter_57_1 in pairs(var_57_0) do
		if iter_57_1.getRestSkillPoint and iter_57_1:getRestSkillPoint() > 0 then
			return true
		end
	end
end

function UnitSkill.playBgEffect(arg_58_0)
	if arg_58_0.vars.eff_bg then
		arg_58_0.vars.eff_bg:removeFromParent()
	end
	
	UnitMain.vars.base_wnd:getChildByName("eff_pos_skill"):setLocalZOrder(-999999)
	
	arg_58_0.vars.eff_bg = EffectManager:Play({
		pivot_x = -60,
		fn = "hero_enchant_circle.cfx",
		pivot_y = 0,
		pivot_z = 0,
		scale = 1,
		layer = UnitMain.vars.base_wnd:getChildByName("eff_pos_skill")
	})
end
