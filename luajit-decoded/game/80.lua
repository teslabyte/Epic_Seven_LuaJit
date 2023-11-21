AchieveSkillList = {}

function MsgHandler.update_faction_skill(arg_1_0)
	if arg_1_0.add_account_skill and arg_1_0.add_account_skill_id then
		AccountSkill:setAccountSkill(arg_1_0.add_account_skill_id, arg_1_0.add_account_skill)
	end
	
	if arg_1_0.stamina_max_bonus then
		Account:setCurrencyMaxBonus("stamina", arg_1_0.stamina_max_bonus)
	end
	
	AchievementBase:onFactionSkillEvent(arg_1_0)
	AchievementBase:updateUI()
end

function AchieveSkillList.show(arg_2_0, arg_2_1)
	local var_2_0 = Dialog:open("wnd/achieve_buff", arg_2_0)
	
	arg_2_0.wnd = var_2_0
	
	SceneManager:getDefaultLayer():addChild(var_2_0)
	arg_2_0:setData()
	SoundEngine:play("event:/ui/popup/tap")
end

function AchieveSkillList.setData(arg_3_0)
	local var_3_0 = AchievementBase:getFactionList()
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_1 = iter_3_1.level - 1
		
		if var_3_1 == 0 then
			var_3_1 = var_3_1 + 1
		end
		
		local var_3_2, var_3_3 = DB("faction_level", string.format("%s_%02d", iter_3_1.id, var_3_1), {
			"as_ui1",
			"as_ui2"
		})
		local var_3_4
		local var_3_5
		local var_3_6 = arg_3_0.wnd:getChildByName("n_contents" .. iter_3_0)
		
		if var_3_6 then
			if_set_sprite(var_3_6, "icon_acheive", "emblem/" .. iter_3_1.emblem .. ".png")
			
			if var_3_2 then
				local var_3_7 = string.split(var_3_2, "_")
				local var_3_8 = var_3_7[1] .. "_" .. var_3_7[2]
				local var_3_9 = AccountSkill:getAccountSkill(var_3_8)
				
				if var_3_9 then
					var_3_4 = AccountSkill:getSkillDB(var_3_8 .. "_" .. var_3_9.level)
				else
					var_3_4 = AccountSkill:getSkillDB(var_3_8 .. "_" .. "1")
				end
			end
			
			if var_3_3 then
				local var_3_10 = string.split(var_3_3, "_")
				local var_3_11 = var_3_10[1] .. "_" .. var_3_10[2]
				local var_3_12 = AccountSkill:getAccountSkill(var_3_11)
				
				if var_3_12 then
					var_3_5 = AccountSkill:getSkillDB(var_3_11 .. "_" .. var_3_12.level)
				else
					var_3_5 = AccountSkill:getSkillDB(var_3_11 .. "_" .. "1")
				end
			end
			
			if_set(var_3_6, "txt_title", T(iter_3_1.name))
			
			if var_3_4 then
				local var_3_13 = var_3_4.value
				
				if var_3_4.calc_type == "multiply" then
					var_3_13 = var_3_13 * 100
				end
				
				upgradeLabelToRichLabel(var_3_6, "txt_buff1")
				
				local var_3_14 = T(var_3_4.effect_value_desc, {
					value = var_3_13
				})
				
				if_set(var_3_6, "txt_buff1", var_3_14)
				
				local var_3_15 = AccountSkill:hasSkillByLevelID(var_3_4.id)
				
				if_set_visible(var_3_6, "cm_icon_locked1", not var_3_15)
				
				local var_3_16 = var_3_6:getChildByName("txt_buff1")
				
				if not var_3_15 then
					var_3_16:setPositionX(var_3_16:getPositionX() + 22)
					var_3_16:setOpacity(51)
				else
					var_3_16:setOpacity(255)
				end
			else
				if_set_visible(var_3_6, "txt_buff1", false)
			end
			
			if var_3_5 then
				local var_3_17 = var_3_5.value
				
				if var_3_5.calc_type == "multiply" then
					var_3_17 = var_3_17 * 100
				end
				
				local var_3_18 = AccountSkill:hasSkillByLevelID(var_3_5.id)
				
				upgradeLabelToRichLabel(var_3_6, "txt_buff2")
				if_set(var_3_6, "txt_buff2", T(var_3_5.effect_value_desc, {
					value = var_3_17
				}))
				if_set_visible(var_3_6, "cm_icon_locked2", not var_3_18)
				if_set_visible(var_3_6, "cm_icon_locked2", not var_3_18)
				
				local var_3_19 = var_3_6:getChildByName("txt_buff1")
				
				var_3_19:formatText()
				
				local var_3_20 = var_3_6:getChildByName("txt_buff2")
				
				if var_3_19:getLineCount() == 2 then
					local var_3_21 = var_3_6:getChildByName("cm_icon_locked2")
					
					var_3_21:setPositionY(var_3_21:getPositionY() - 26)
					var_3_20:setPositionY(var_3_20:getPositionY() - 26)
				end
				
				if not var_3_18 then
					var_3_20:setPositionX(var_3_20:getPositionX() + 22)
					var_3_20:setOpacity(51)
				else
					var_3_20:setOpacity(255)
				end
			else
				if_set_visible(var_3_6, "txt_buff2", false)
			end
			
			if_set_visible(var_3_6, "txt_no_buff", not var_3_4 and not var_3_5)
			if_set_visible(var_3_6, "cm_icon_locked", var_3_4 or var_3_5)
			if_set_visible(var_3_6, "cm_icon_etcinfor_11", not var_3_4 and not var_3_5)
			
			if not var_3_4 and not var_3_5 then
				if_set_visible(var_3_6, "cm_icon_locked1", false)
				if_set_visible(var_3_6, "cm_icon_locked2", false)
			end
		end
	end
end

function AchieveSkillList.close(arg_4_0, arg_4_1)
	if UIAction:Find("block") then
		return 
	end
	
	Dialog:close("achieve_buff")
end
