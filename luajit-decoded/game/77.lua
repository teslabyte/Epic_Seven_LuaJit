FactionCategory = FactionCategory or {}
AchievementBase = AchievementBase or {}
AchievementUtil = AchievementUtil or {}

copy_functions(ScrollView, FactionCategory)

function HANDLER.achievement_base(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" or arg_1_1 == "btn_detail" then
		local var_1_0 = AchievementBase:getFactionID()
		local var_1_1 = AchievementBase:getDetailObj(var_1_0)
		
		if var_1_1 then
			var_1_1:onItemControl(arg_1_0)
		end
		
		return 
	end
	
	if arg_1_1 == "btn_detail_list" then
		local var_1_2 = AchievementBase:getFactionID()
		local var_1_3 = AchievementBase:getDetailObj(var_1_2)
		
		if var_1_3 then
			var_1_3:onItemControl(arg_1_0)
		end
		
		return 
	end
	
	if arg_1_1 == "btn_buffs" then
		AchieveSkillList:show()
		
		return 
	end
	
	if arg_1_1 == "btn_story" then
		if arg_1_0.is_lv_up then
			local var_1_4 = AchievementBase:getFactionID()
			
			query("update_faction_skill", {
				faction_id = var_1_4
			})
			
			return 
		else
			balloon_message_with_sound("achieve_no_story_error")
			
			return 
		end
	end
	
	if arg_1_1 == "btn_point_tab1" then
		if AchievementBase:getFactionID() == POINT_FACTION_ID and FactionDetailPoint:setMode(FACTION_POINT_MODE.DAILY) then
			FactionDetailPoint:setModeData()
		end
		
		return 
	end
	
	if arg_1_1 == "btn_point_tab2" then
		if AchievementBase:getFactionID() == POINT_FACTION_ID and FactionDetailPoint:setMode(FACTION_POINT_MODE.WEEKLY) then
			FactionDetailPoint:setModeData()
		end
		
		return 
	end
	
	if arg_1_1 == "btn_point_reward" and arg_1_0.reward_db then
		FactionDetailPoint:query(arg_1_0.reward_db)
	end
	
	if arg_1_1 == "btn_all" then
		if arg_1_0.is_active then
			local var_1_5 = AchievementBase:getFactionID()
			
			query("clear_achievement_all", {
				faction_id = var_1_5
			})
		end
		
		return 
	end
end

function HANDLER.achieve_buff(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		AchieveSkillList:close()
	end
end

function HANDLER.archievement_dlg_rankup(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("archievement_dlg_rankup")
	end
end

function AchievementUtil.calcFactionLevel(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = 1
	local var_4_1 = false
	local var_4_2 = AchievementUtil:getAchieveRowMax()
	
	for iter_4_0 = 1, var_4_2 do
		local var_4_3 = string.format("%s_%02d", arg_4_1, iter_4_0)
		local var_4_4 = DB("faction_level", var_4_3, "req_achieve_point")
		
		if not var_4_4 then
			var_4_0 = iter_4_0
			var_4_1 = true
			
			break
		end
		
		if arg_4_2 < var_4_4 then
			var_4_0 = iter_4_0
			
			break
		end
	end
	
	return var_4_0, var_4_1
end

function AchievementUtil.getAchieveRowMax(arg_5_0)
	return GAME_STATIC_VARIABLE.achieve_row_max or 50
end

function AchievementUtil.getFactionMax(arg_6_0)
	return GAME_STATIC_VARIABLE.faction_max or 10
end

function AchievementUtil.checkCompleteCount(arg_7_0, arg_7_1)
	local function var_7_0(arg_8_0)
		local var_8_0 = 0
		
		if arg_8_0 == POINT_FACTION_ID then
			var_8_0 = FactionPoint:getRewardAbleCnt()
		else
			local var_8_1 = DB("faction", arg_8_0, {
				"unlock_condition"
			})
			
			if not var_8_1 or Account:isSysAchieveCleared(var_8_1) then
				local var_8_2 = Account:getFactionGroupsByFactionID(arg_8_0)
				
				for iter_8_0, iter_8_1 in pairs(var_8_2) do
					if (tonumber(iter_8_1.state) or 0) == 1 then
						local var_8_3 = string.format("%s_%02d", iter_8_1.group_id, iter_8_1.lv and to_n(iter_8_1.lv) or 1)
						local var_8_4, var_8_5 = DB("achievement", var_8_3, {
							"hide",
							"hold"
						})
						
						if not var_8_4 and not var_8_5 then
							var_8_0 = var_8_0 + 1
						end
					end
				end
			end
		end
		
		return var_8_0
	end
	
	local var_7_1 = 0
	
	if string.empty(arg_7_1) then
		for iter_7_0, iter_7_1 in pairs(Account:getFactions()) do
			var_7_1 = var_7_1 + var_7_0(iter_7_0)
		end
	else
		var_7_1 = var_7_0(arg_7_1)
	end
	
	return var_7_1
end

function FactionCategory.getScrollViewItem(arg_9_0, arg_9_1)
	local var_9_0 = cc.CSLoader:createNode("wnd/archievement_menu_item.csb")
	
	if_set(var_9_0, "txt_title", T(arg_9_1.name))
	if_set_visible(var_9_0, "bg", false)
	
	local var_9_1 = arg_9_1.level - 1
	local var_9_2 = DB("faction_level", string.format("%s_%02d", arg_9_1.id, var_9_1), "level_title")
	
	if_set(var_9_0, "txt_rate", T("ui_faction_grade", {
		level = var_9_1
	}))
	if_set_sprite(var_9_0, "icon_acheive", "emblem/" .. arg_9_1.emblem .. ".png")
	
	if arg_9_1.unlock_condition then
		local var_9_3 = Account:isSysAchieveCleared(arg_9_1.unlock_condition)
		
		if arg_9_1.is_unlock_eff then
			var_9_3 = false
		end
		
		if not var_9_3 and not arg_9_1.is_unlock_eff then
			if_set_visible(var_9_0, "txt_rate", false)
			if_set_visible(var_9_0, "n_locked", true)
			if_set_color(var_9_0, "txt_title", UIUtil.GREY)
			if_set_color(var_9_0, "icon_acheive", UIUtil.GREY)
		end
		
		UIUtil:changeBtnUnlockState(var_9_0:getChildByName("n_locked"), "img/cm_icon_etclock.png", var_9_3, var_9_0, {
			pos_x = 52,
			scale = 1,
			pos_y = 32,
			category_unlock_id = arg_9_1.unlock_condition,
			unlock_eff = arg_9_1.is_unlock_eff
		})
	end
	
	arg_9_0:updateCnt(var_9_0, arg_9_1)
	
	return var_9_0
end

function FactionCategory.updateCnt(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1:getChildByName("n_cnt")
	local var_10_1 = AchievementUtil:checkCompleteCount(arg_10_2.id)
	
	if_set_visible(var_10_0, "bg", var_10_1 > 0)
	if_set(var_10_0, "txt_cnt", var_10_1 > 0 and var_10_1 or "")
end

function FactionCategory.updateItems(arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0.ScrollViewItems) do
		arg_11_0:updateCnt(iter_11_1.control, iter_11_1.item)
	end
end

function FactionCategory.onSelectScrollViewItem(arg_12_0, arg_12_1, arg_12_2)
	SoundEngine:play("event:/ui/category/select")
	
	local var_12_0 = arg_12_0.ScrollViewItems[arg_12_1]
	
	if var_12_0.item.unlock_condition then
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = var_12_0.item.unlock_condition
		}, function()
			arg_12_0:selectItem(arg_12_1)
		end)
	else
		arg_12_0:selectItem(arg_12_1)
	end
end

function FactionCategory.selectItem(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or 1
	
	local var_14_0 = arg_14_0.ScrollViewItems[arg_14_1]
	local var_14_1 = var_14_0.item.id
	
	if AchievementBase:getFactionID() == var_14_1 then
		return 
	end
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.ScrollViewItems) do
		if_set_visible(iter_14_1.control, "bg", arg_14_1 == iter_14_0)
	end
	
	local var_14_2 = var_14_0.item.groups
	
	AchievementBase:setFactionID(var_14_1)
	arg_14_0:selectCategory(var_14_1)
	Analytics:toggleTab(var_14_1)
	AchievementBase:updateUI()
end

function FactionCategory.selectCategory(arg_15_0, arg_15_1)
	local var_15_0 = AchievementBase:getDetailObj(arg_15_1)
	
	if var_15_0 then
		local var_15_1 = AchievementBase:getAchieveDataListByFactionID(arg_15_1)
		
		var_15_0:selectCategory(var_15_1)
	end
end

function AchievementBase.setFactionID(arg_16_0, arg_16_1)
	arg_16_0.vars.faction_id = arg_16_1
end

function AchievementBase.getFactionID(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	return arg_17_0.vars.faction_id
end

function AchievementBase.getCurrentAchieveDatas(arg_18_0)
	local var_18_0 = arg_18_0:getFactionID()
	
	if not var_18_0 then
		return 
	end
	
	return arg_18_0:getAchieveDataListByFactionID(var_18_0)
end

function AchievementBase.updateFactionUI(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:getCurrentFactionData()
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = arg_19_0.vars.wnd:getChildByName("BASE_LEFT")
	
	if var_19_1 then
		local var_19_2 = Account:getFactionByID(var_19_0.id).exp or 0
		local var_19_3, var_19_4 = AchievementUtil:calcFactionLevel(var_19_0.id, var_19_2)
		local var_19_5 = DB("faction_level", string.format("%s_%02d", var_19_0.id, var_19_3 - 1), {
			"id",
			"level_title",
			"req_achieve_point",
			"rank_reward_type",
			"rank_reward_id",
			"rank_reward_icon"
		})
		local var_19_6, var_19_7, var_19_8, var_19_9 = DB("faction_level", string.format("%s_%02d", var_19_0.id, var_19_3), {
			"req_achieve_point",
			"rank_reward_type",
			"rank_reward_id",
			"rank_reward_icon"
		})
		
		if_set(var_19_1, "txt_title", T(var_19_0.name))
		if_set(var_19_1, "txt_desc", T(var_19_0.description))
		
		if var_19_5 ~= nil then
			local var_19_10 = var_19_5 .. "_tl"
		end
		
		if_set(var_19_1, "txt_reputation", T("ui_faction_grade", {
			level = var_19_3 - 1
		}))
		
		local var_19_11 = tonumber(var_19_6)
		
		if_set_sprite(var_19_1, "battle_robby_thumbgrade_101", "emblem/" .. var_19_0.emblem .. ".png")
		
		if var_19_11 then
			if_set(var_19_1, "txt_exp", string.format("%s / %s", comma_value(math.max(0, var_19_2)), comma_value(var_19_11)))
			if_set_percent(var_19_1, "progress", var_19_2 / var_19_11)
		else
			if_set(var_19_1, "txt_exp", comma_value(math.max(0, var_19_2)))
			if_set_percent(var_19_1, "progress", 1)
		end
		
		local var_19_12 = var_19_1:getChildByName("btn_story")
		local var_19_13 = var_19_1:getChildByName("n_reputation")
		
		if get_cocos_refid(var_19_12) and get_cocos_refid(var_19_13) then
			local var_19_14 = not arg_19_0:isMaxSkills() and arg_19_0:checkFactionSkillData() and true
			
			var_19_12:setVisible(var_19_14)
			
			if var_19_14 then
				var_19_12.is_lv_up = arg_19_0:checkFactionSkillData()
				
				local var_19_15 = arg_19_0.vars.wnd:getChildByName("txt_title")
				
				while get_cocos_refid(var_19_12:getChildByName("@UI_FAC_STORY")) do
					var_19_12:removeChildByName("@UI_FAC_STORY")
				end
				
				local var_19_16 = EffectManager:Play({
					node_name = "@UI_FAC_STORY",
					z = 99998,
					fn = "ui_clear_reward.cfx",
					layer = var_19_12,
					x = var_19_12:getContentSize().width / 2,
					y = var_19_12:getContentSize().height / 2 + 3
				})
				
				var_19_16:setScaleX(1.13)
				var_19_16:setScaleY(0.75)
			end
			
			var_19_13:setVisible(not var_19_14)
		end
		
		arg_19_0:setFactionSkillData(var_19_1, var_19_0.id, var_19_3 - 1, var_19_4)
	end
	
	local var_19_17 = arg_19_0.vars.wnd:getChildByName("BASE_RIGHT")
	
	if get_cocos_refid(var_19_17) then
		local var_19_18 = var_19_17:getChildByName("btn_all")
		
		if get_cocos_refid(var_19_18) then
			var_19_18:setVisible(var_19_0.is_receive_all)
			
			if var_19_18:isVisible() then
				local var_19_19 = AchievementUtil:checkCompleteCount(var_19_0.id) > 0
				
				if_set_visible(var_19_18, "cm_icon_clan", var_19_19)
				var_19_18:setOpacity(var_19_19 and 255 or 76.5)
				
				var_19_18.is_active = var_19_19
			end
		end
	end
end

function AchievementBase.closeAchieveReward(arg_20_0)
	FactionCategory:updateItems()
	
	local var_20_0 = AchievementBase:getFactionID()
	local var_20_1 = AchievementBase:getDetailObj(var_20_0)
	
	if var_20_1 then
		var_20_1:sort()
		var_20_1:refreshCenterView()
	end
	
	arg_20_0:updateUI()
	BackButtonManager:pop({
		check_id = "Dialog.achieve_get"
	})
	Dialog:closeInBackFunc("achieve_get")
end

function AchievementBase.updateRewards(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = Account:addReward(arg_21_1.rewards)
	
	if arg_21_1.faction_rewards then
		for iter_21_0, iter_21_1 in pairs(arg_21_1.faction_rewards) do
			local var_21_1 = iter_21_0
			local var_21_2 = AchievementUtil:calcFactionLevel(var_21_1, iter_21_1.exp - (iter_21_1.exp_add or 0))
			local var_21_3, var_21_4 = AchievementUtil:calcFactionLevel(var_21_1, iter_21_1.exp)
			local var_21_5 = var_21_3 - 1
			local var_21_6 = AchievementBase:getRewardPopup(arg_21_1.clear_achieve_id, var_21_1, var_21_0, arg_21_2)
			
			SpriteCache:resetSprite(var_21_6:getChildByName("rank"), string.format("emblem/num%02d.png", var_21_5))
			ConditionContentsManager:dispatch("achivepoint.get", {
				value = iter_21_1.exp_add
			})
			ConditionContentsManager:dispatch("factionpoint.get", {
				faction_id = var_21_1
			})
			if_set(var_21_6, "txt_added", T("achieve_reward_point", {
				achieve_point = iter_21_1.exp_add or 0
			}))
			
			local var_21_7 = string.format("%s_%02d", var_21_1, var_21_4 and var_21_3 - 1 or var_21_3)
			local var_21_8 = DB("faction_level", var_21_7, "req_achieve_point")
			local var_21_9 = iter_21_1.exp
			local var_21_10 = var_21_9 / var_21_8
			
			if var_21_9 > 0 then
				if_set_percent(var_21_6, "exp_gauge_0", var_21_10)
				if_set_percent(var_21_6, "exp_gauge", (iter_21_1.exp - (iter_21_1.exp_add or 0)) / var_21_8)
				UIAction:Add(LOG(PROGRESS(250, (iter_21_1.exp - (iter_21_1.exp_add or 0)) / var_21_8, var_21_10)), var_21_6:getChildByName("exp_gauge"), "block")
				if_set(var_21_6, "txt_exp", string.format("%s / %s", comma_value(var_21_9), comma_value(var_21_8)))
			end
			
			if var_21_2 < var_21_3 then
				var_21_6.faction_id = var_21_1
				var_21_6.level = var_21_5
			end
		end
	end
end

function AchievementBase.getWnd(arg_22_0)
	return arg_22_0.vars.wnd
end

function AchievementBase.onFactionSkillEvent(arg_23_0, arg_23_1)
	if arg_23_1.faction_id then
		local var_23_0 = arg_23_1.faction_id
		local var_23_1 = arg_23_1.level
		local var_23_2 = DB("faction_level", string.format("%s_%02d", var_23_0, var_23_1), "rankup_story")
		
		if var_23_2 then
			local var_23_3 = SceneManager:getRunningPopupScene()
			
			ConditionContentsManager:dispatch("story.achieve", {
				storyid = var_23_2
			})
			start_new_story(var_23_3, var_23_2, {
				force = true,
				on_finish = function()
					arg_23_0:showLevelup(var_23_0, var_23_1)
				end
			})
		else
			arg_23_0:showLevelup(var_23_0, var_23_1)
		end
	end
end

function AchievementBase.getRewardPopup(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = Dialog:open("wnd/achieve_get", arg_25_0, {
		modal = true,
		use_backbutton = true,
		back = true,
		back_func = function()
			AchievementBase:closeAchieveReward()
		end
	})
	
	if arg_25_2 == POINT_FACTION_ID then
		if_set(var_25_0, "txt_title", T("ui_popup_daily_title"))
		if_set(var_25_0, "txt_disc", T("ui_popup_daily_desc"))
	else
		if_set(var_25_0, "txt_title", T("achieve_reward_title"))
	end
	
	if_set_arrow(var_25_0)
	
	local var_25_1 = arg_25_0:getFactionDataByID(arg_25_2)
	
	if arg_25_1 or arg_25_4 then
		upgradeLabelToRichLabel(var_25_0, "txt_disc", true)
		var_25_0:getChildByName("txt_disc"):setAlignment(cc.TEXT_ALIGNMENT_CENTER)
		
		if arg_25_4 then
			if_set(var_25_0, "txt_disc", T("achieve_imm_reward_desc_all", {
				achieve_faction = T(var_25_1.name)
			}))
		else
			local var_25_2 = DB("achievement", arg_25_1, "name")
			
			if_set(var_25_0, "txt_disc", T("achieve_imm_reward_desc", {
				achieve_title = T(var_25_2)
			}))
		end
	end
	
	if_set(var_25_0, "txt_faction_name", T(var_25_1.name))
	if_set_sprite(var_25_0, "emblem", "emblem/" .. var_25_1.emblem .. ".png")
	
	if Account:getFactionLevel(arg_25_2) == 1 then
		if_set_visible(var_25_0, "rank", false)
	end
	
	local var_25_3 = {}
	
	if arg_25_3 and arg_25_3.rewards then
		for iter_25_0, iter_25_1 in pairs(arg_25_3.rewards) do
			if not iter_25_1.is_randombox and not iter_25_1.is_package then
				table.insert(var_25_3, iter_25_1)
			end
		end
	end
	
	local function var_25_4(arg_27_0, arg_27_1)
		local var_27_0 = arg_27_1.item or {}
		local var_27_1 = arg_27_1.count or arg_27_1.diff or 1
		
		if arg_27_1[1] then
			var_27_1 = arg_27_1[1].diff
		end
		
		local var_27_2 = arg_27_1.code
		
		if arg_27_1.is_currency then
			var_27_2 = "to_" .. var_27_2
		end
		
		local var_27_3 = {
			show_small_count = true,
			hero_multiply_scale = 0.94,
			artifact_multiply_scale = 0.67,
			multiply_scale = 0.85,
			parent = arg_27_0,
			equip_stat = var_27_0.equip_stat or {}
		}
		
		table.merge(var_27_3, var_27_0)
		
		if arg_27_1.is_account_skills then
			var_27_2 = var_27_2 .. "_" .. var_27_0.level
		end
		
		return UIUtil:getRewardIcon(var_27_1, var_27_2, var_27_3)
	end
	
	local var_25_5 = table.count(var_25_3)
	
	if var_25_5 <= 10 then
		for iter_25_2 = 1, var_25_5 do
			local var_25_6 = var_25_0:getChildByName("n_item" .. iter_25_2)
			
			var_25_4(var_25_6, var_25_3[iter_25_2])
		end
	else
		local var_25_7 = var_25_0:getChildByName("listview")
		
		if get_cocos_refid(var_25_7) then
			var_25_7:setVisible(true)
			var_25_7:setPositionY(130)
			
			local var_25_8 = ItemListView:bindControl(var_25_7)
			local var_25_9 = {
				onUpdate = function(arg_28_0, arg_28_1, arg_28_2)
					arg_28_1:removeAllChildren()
					
					arg_28_1 = var_25_4(arg_28_1, arg_28_2)
					
					arg_28_1:setAnchorPoint(0, 0)
				end
			}
			local var_25_10 = cc.Layer:create()
			
			var_25_10:setContentSize(81, 81)
			var_25_8:setRenderer(var_25_10, var_25_9)
			var_25_8:setItems(var_25_3)
		end
	end
	
	SceneManager:getDefaultLayer():addChild(var_25_0)
	SoundEngine:play("event:/ui/price_clear")
	
	local var_25_11 = var_25_0:getChildByName("n_eff")
	
	if var_25_11 then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_25_11
		})
		UIAction:Add(DELAY(600), var_25_0, "block")
	end
	
	return var_25_0
end

function AchievementBase.loadFactioList(arg_29_0)
	local var_29_0 = {}
	local var_29_1 = AchievementUtil:getFactionMax()
	
	for iter_29_0 = 1, var_29_1 do
		local var_29_2, var_29_3, var_29_4, var_29_5, var_29_6, var_29_7, var_29_8 = DBN("faction", iter_29_0, {
			"id",
			"name",
			"sort",
			"unlock_condition",
			"emblem",
			"description",
			"receive_all"
		})
		
		if not var_29_2 then
			break
		end
		
		local var_29_9 = Account:getFactionByID(var_29_2)
		local var_29_10 = var_29_9.exp or 0
		local var_29_11 = var_29_9.groups or {}
		local var_29_12 = AchievementUtil:calcFactionLevel(var_29_2, var_29_10)
		local var_29_13 = DB("faction_level", string.format("%s_%02d", var_29_2, var_29_12), "level_title")
		local var_29_14 = Account:isSysAchieveCleared(var_29_5) and not Account:getConfigData("unlock_eff." .. var_29_5)
		local var_29_15 = var_29_8 == "y"
		
		table.insert(var_29_0, {
			id = var_29_2,
			name = var_29_3,
			sort = tonumber(var_29_4) or 999,
			unlock_condition = var_29_5,
			emblem = var_29_6,
			description = var_29_7,
			level = var_29_12,
			level_title = var_29_13,
			exp = var_29_10,
			groups = var_29_11,
			is_unlock_eff = var_29_14,
			is_receive_all = var_29_15
		})
	end
	
	table.sort(var_29_0, function(arg_30_0, arg_30_1)
		return (tonumber(arg_30_0.sort) or 999) < (tonumber(arg_30_1.sort) or 999)
	end)
	
	return var_29_0
end

function AchievementBase.getFactionList(arg_31_0)
	if not arg_31_0.vars then
		return {}
	end
	
	return arg_31_0.vars.faction_list
end

function AchievementBase.getFactionDataByID(arg_32_0, arg_32_1)
	for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.faction_list or {}) do
		if iter_32_1.id == arg_32_1 then
			return iter_32_1
		end
	end
end

function AchievementBase.getCurrentFactionData(arg_33_0)
	local var_33_0 = arg_33_0:getFactionID()
	
	return arg_33_0:getFactionDataByID(var_33_0)
end

function AchievementBase.setFactionSkillData(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = arg_34_1:getChildByName("skill1_up_bg")
	local var_34_1 = arg_34_1:getChildByName("skill2_up_bg")
	local var_34_2 = Account:getFactionGrade(arg_34_3)
	
	if arg_34_3 == 0 then
		arg_34_3 = arg_34_3 + 1
	end
	
	local var_34_3, var_34_4 = DB("faction_level", string.format("%s_%02d", arg_34_2, arg_34_3), {
		"as_ui1",
		"as_ui2"
	})
	local var_34_5
	local var_34_6
	
	if var_34_3 then
		local var_34_7 = string.split(var_34_3, "_")
		
		var_34_3 = var_34_7[1] .. "_" .. var_34_7[2]
		
		local var_34_8 = AccountSkill:getAccountSkill(var_34_3)
		
		if var_34_8 then
			var_34_5 = AccountSkill:getSkillDB(var_34_3 .. "_" .. var_34_8.level)
		else
			var_34_5 = AccountSkill:getSkillDB(var_34_3 .. "_" .. "1")
		end
	end
	
	if var_34_4 then
		local var_34_9 = string.split(var_34_4, "_")
		local var_34_10 = var_34_9[1] .. "_" .. var_34_9[2]
		local var_34_11 = AccountSkill:getAccountSkill(var_34_10)
		
		if var_34_11 then
			var_34_6 = AccountSkill:getSkillDB(var_34_10 .. "_" .. var_34_11.level)
		else
			var_34_6 = AccountSkill:getSkillDB(var_34_10 .. "_" .. "1")
		end
	end
	
	if not var_34_3 then
		if_set_visible(arg_34_1, "txt_plan_update", true)
		arg_34_1:getChildByName("txt_plan_update"):setString(T("faction_skill_not_availrable_list"))
		var_34_0:setVisible(false)
		var_34_1:setVisible(false)
		
		return 
	end
	
	if_set_visible(arg_34_1, "txt_plan_update", false)
	var_34_0:setVisible(true)
	var_34_1:setVisible(true)
	
	if not var_34_6 then
		var_34_1:setVisible(false)
		
		return 
	end
	
	local var_34_12 = AccountSkill:hasSkillByLevelID(var_34_5.id)
	local var_34_13 = AccountSkill:hasSkillByLevelID(var_34_6.id)
	local var_34_14 = var_34_5.value
	
	if var_34_5.calc_type == "multiply" then
		var_34_14 = var_34_14 * 100
	end
	
	local var_34_15 = var_34_6.value
	
	if var_34_6.calc_type == "multiply" then
		var_34_15 = var_34_15 * 100
	end
	
	if not get_cocos_refid(arg_34_0.vars.first_skill_label) then
		arg_34_0.vars.first_skill_label = upgradeLabelToRichLabel(var_34_0, "skill_title", true)
		
		var_34_0:getChildByName("skill_title"):setAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
	
	if not get_cocos_refid(arg_34_0.second_skill_label) then
		arg_34_0.second_skill_label = upgradeLabelToRichLabel(var_34_1, "skill_title", true)
		
		var_34_1:getChildByName("skill_title"):setAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
	
	local var_34_16 = T(var_34_5.effect_value_desc, {
		value = var_34_14
	})
	local var_34_17 = T(var_34_6.effect_value_desc, {
		value = var_34_15
	})
	
	if_set(var_34_0, "skill_title", var_34_16)
	if_set(var_34_1, "skill_title", var_34_17)
	if_set_visible(arg_34_1, "lock1", not var_34_12)
	if_set_visible(arg_34_1, "lock2", not var_34_13)
	
	if not var_34_12 then
		if_set_opacity(var_34_0, "skill_title", 102)
	else
		if_set_opacity(var_34_0, "skill_title", 255)
	end
	
	if not var_34_13 then
		if_set_opacity(var_34_1, "skill_title", 102)
	else
		if_set_opacity(var_34_1, "skill_title", 255)
	end
	
	local var_34_18 = not var_34_12 and not var_34_13
	
	if_set_visible(arg_34_0.vars.wnd, "n_skillup", not var_34_18)
	if_set_visible(arg_34_0.vars.wnd, "txt_none", var_34_18)
end

function AchievementBase.showLevelup(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5)
	local var_35_0 = {}
	
	var_35_0.rank_reward_icon, var_35_0.rank_reward_title, var_35_0.rank_reward_de, var_35_0.level_title, var_35_0.rankup_story_after, var_35_0.rank_up_script, var_35_0.rank_up_cha, var_35_0.offset_x, var_35_0.offset_y, var_35_0.scale = DB("faction_level", string.format("%s_%02d", arg_35_1, arg_35_2), {
		"rank_reward_icon",
		"rank_reward_title",
		"rank_reward_de",
		"level_title",
		"rankup_story_after",
		"rank_up_script",
		"rank_up_cha",
		"offset_x",
		"offset_y",
		"scale"
	})
	
	local var_35_1 = Dialog:open("wnd/archievement_dlg_rankup", arg_35_0, {
		modal = true,
		back = true,
		back_func = function()
			arg_35_0:hideLevelup(var_35_0.rankup_story_after)
		end
	})
	
	SceneManager:getDefaultLayer():addChild(var_35_1)
	
	var_35_0.rank_up_cha_name = DB("character", var_35_0.rank_up_cha, "name")
	
	if_set(var_35_1, "txt_title", T(var_35_0.rank_up_cha_name))
	if_set(var_35_1, "txt_desc", T(var_35_0.rank_up_script))
	if_set_arrow(var_35_1)
	
	var_35_1.rankup_story_after = var_35_0.rankup_story_after
	
	local var_35_2 = AchievementUtil:getFactionMax()
	local var_35_3 = arg_35_0:getFactionDataByID(arg_35_1)
	
	if_set_sprite(var_35_1, "icon_left", "emblem/" .. var_35_3.emblem .. ".png")
	if_set(var_35_1, "txt_faction_title", T(var_35_3.name))
	
	local var_35_4
	local var_35_5 = AccountSkill:getFactionSkillDB(arg_35_1, arg_35_2)
	
	if var_35_5 then
		var_35_4 = AccountSkill:getPrevSkillLevelID(var_35_5.id)
	end
	
	local var_35_6 = AccountSkill:getSkillDB(var_35_4)
	local var_35_7 = UIUtil:getPortraitAni(var_35_0.rank_up_cha, {
		pin_sprite_position_y = true,
		parent_pos_y = var_35_1:getChildByName("portrait"):getPositionY()
	})
	
	if var_35_7 then
		var_35_1:getChildByName("portrait"):addChild(var_35_7)
		var_35_7:setScale(0.8)
		var_35_7:setPositionY(var_35_7:getPositionY() - 60)
	end
	
	if not var_35_7.is_model then
		var_35_7:setPositionX(var_35_0.offset_x * -1)
		var_35_7:setPositionY(var_35_7:getPositionY() - 200 + (var_35_0.offset_y or 0))
		var_35_7:setAnchorPoint(var_35_7:getAnchorPoint().x, 0)
		var_35_7:setScale(0.95)
	end
	
	if_set_visible(var_35_1, "txt_rank_title", false)
	if_set_visible(var_35_1, "img_arrow", false)
	if_set_visible(var_35_1, "txt_skill_desc", false)
	if_set_visible(var_35_1, "txt_skill_before", false)
	if_set_visible(var_35_1, "skill1_up_title", false)
	if_set_visible(var_35_1, "txt_plan_update", false)
	
	local var_35_8 = var_35_1:getChildByName("n_rate_before")
	local var_35_9 = var_35_1:getChildByName("n_rate_after")
	local var_35_10 = var_35_8:getChildByName("txt_buff")
	local var_35_11 = var_35_9:getChildByName("txt_buff")
	local var_35_12 = var_35_8:getChildByName("txt_rate_desc")
	local var_35_13 = var_35_9:getChildByName("txt_rate_desc")
	local var_35_14 = var_35_8:getChildByName("txt_rate")
	local var_35_15 = var_35_9:getChildByName("txt_rate")
	
	if_set(var_35_12, nil, "")
	if_set(var_35_13, nil, "")
	if_set(var_35_10, nil, "")
	if_set(var_35_11, nil, "")
	if_set(var_35_14, nil, "")
	if_set(var_35_15, nil, "")
	upgradeLabelToRichLabel(var_35_8, "txt_buff", true)
	upgradeLabelToRichLabel(var_35_9, "txt_buff", true)
	
	local var_35_16 = arg_35_2 - 1
	
	if var_35_16 >= 1 then
		SpriteCache:resetSprite(var_35_1:getChildByName("icon_rank"), string.format("emblem/num%02d.png", var_35_16))
	else
		SpriteCache:resetSprite(var_35_1:getChildByName("icon_rank"), string.format("emblem/num%02d.png", 0))
	end
	
	local function var_35_17()
		SpriteCache:resetSprite(var_35_1:getChildByName("icon_rank"), string.format("emblem/num%02d.png", arg_35_2))
		if_set_visible(var_35_1, "icon_rank", true)
		if_set_visible(var_35_1, "txt_rank_title", true)
	end
	
	local function var_35_18(arg_38_0)
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_achieve_embleup.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = arg_38_0
		})
	end
	
	local function var_35_19(arg_39_0)
		if not var_35_6 then
		else
			if_set_visible(var_35_1, "skill1_up_title", true)
			if_set(var_35_1, "lv_before", var_35_5.level)
			
			local var_39_0 = AccountSkill:getMaxLevelByLevelID(var_35_5.id)
			
			if_set(var_35_1, "txt_up", "/" .. var_39_0)
		end
		
		local var_39_1 = var_35_1:getChildByName("txt_skill_desc")
		
		if var_39_1 and var_35_5 then
			var_39_1:setString("")
			if_set_visible(var_35_1, "txt_skill_desc", true)
			UIAction:Add(TEXT(T(var_35_5.effect_desc), true, 0), var_39_1)
		end
		
		local var_39_2 = DB("faction_level", string.format("%s_%02d", arg_35_1, arg_35_2 - 1), "level_title")
		
		if var_39_2 then
			UIAction:Add(TEXT(T(var_39_2), true, 0), var_35_12)
		else
			UIAction:Add(TEXT(T("no_faction_title"), true, 0), var_35_12)
		end
		
		if not var_35_6 and var_35_5 then
			local var_39_3 = var_35_5.value
			
			if var_35_5.calc_type == "multiply" then
				local var_39_4 = var_39_3 * 100
			end
			
			UIAction:Add(TEXT(T("rankup_faction_level", {
				level = math.max(0, var_35_16)
			}), true, 0), var_35_14)
			if_set(var_35_8, "txt_buff", T("no_buff_are_being_applied"))
		elseif var_35_6 then
			local var_39_5 = var_35_6.value
			
			if var_35_5.calc_type == "multiply" then
				var_39_5 = var_39_5 * 100
			end
			
			UIAction:Add(TEXT(T("rankup_faction_level", {
				level = arg_35_2 - 1
			}), true, 0), var_35_14)
			if_set(var_35_8, "txt_buff", T(var_35_6.effect_value_desc, {
				value = var_39_5
			}))
		else
			if_set_visible(var_35_1, "txt_plan_update", true)
			if_set(var_35_1, "txt_plan_update", T("faction_skill_not_availrable"))
			if_set(var_35_8, "txt_buff", T("faction_skill_not_availrable"))
			if_set(var_35_9, "txt_buff", T("faction_skill_not_availrable"))
		end
		
		if var_35_5 then
			local var_39_6 = var_35_5.value
			
			if var_35_5.calc_type == "multiply" then
				var_39_6 = var_39_6 * 100
			end
			
			UIAction:Add(TEXT(T("rankup_faction_level", {
				level = arg_35_2
			}), true, 0), var_35_15)
			UIAction:Add(TEXT(T(var_35_0.level_title), true, 0), var_35_13)
			if_set(var_35_9, "txt_buff", T(var_35_5.effect_value_desc, {
				value = var_39_6
			}))
		end
	end
	
	local var_35_20 = var_35_1:getChildByName("n_emblem")
	local var_35_21 = var_35_1:getChildByName("n_effect")
	
	UIAction:Add(SEQ(CALL(var_35_18, var_35_20), SCALE_TO(200, 2), CALL(var_35_17), SCALE_TO(200, 1)), var_35_20, arg_35_1 .. ".emblem")
	UIAction:Add(SEQ(DELAY(400), CALL(if_set_visible, var_35_1, "img_arrow", true), CALL(EffectManager.Play, EffectManager, "ui_achieve_reward.cfx", var_35_21, 100, 0, 99998), DELAY(165), CALL(var_35_19, var_35_21)), var_35_21, arg_35_1 .. ".reward")
	UIAction:Add(DELAY(1000), arg_35_0, "block")
end

function AchievementBase.hideLevelup(arg_40_0, arg_40_1)
	BackButtonManager:pop("Dialog.archievement_dlg_rankup")
	
	if arg_40_1 then
		local var_40_0 = SceneManager:getDefaultLayer()
		
		start_new_story(var_40_0, arg_40_1, {
			force = true
		})
	end
end

function AchievementBase.clear(arg_41_0)
	arg_41_0.vars = {}
	
	FactionDetail:clear()
	FactionDetailPoint:clear()
	FactionDetailSica:clear()
end

function AchievementBase.getDetailObj(arg_42_0, arg_42_1)
	if not arg_42_0.vars then
		return 
	end
	
	if not arg_42_0.vars.detail_list then
		return 
	end
	
	return arg_42_0.vars.detail_list[arg_42_1]
end

function AchievementBase.show(arg_43_0, arg_43_1)
	arg_43_0:clear()
	
	local var_43_0 = load_dlg("achievement_base", nil, "wnd")
	
	arg_43_0.vars = {}
	arg_43_0.vars.wnd = var_43_0
	arg_43_0.vars.detail_list = {}
	arg_43_0.vars.detail_list.sisters = FactionDetailPoint
	arg_43_0.vars.detail_list.manager = FactionDetail
	arg_43_0.vars.detail_list.sanate = FactionDetail
	arg_43_0.vars.detail_list.merchant = FactionDetail
	arg_43_0.vars.detail_list.phantom = FactionDetail
	arg_43_0.vars.detail_list.sica = FactionDetailSica
	
	SceneManager:getDefaultLayer():addChild(var_43_0)
	
	arg_43_0.vars.faction_list = arg_43_0:loadFactioList()
	
	FactionCategory:initScrollView(arg_43_0.vars.wnd:getChildByName("scrollview_menu"), 290, 92, {
		fit_height = true
	})
	FactionCategory:setScrollViewItems(arg_43_0.vars.faction_list)
	FactionDetail:init()
	FactionDetailPoint:init()
	FactionDetailSica:init()
	FactionCategory:selectItem(1)
	TopBarNew:create(T("system_012_title"), var_43_0, function()
		SceneManager:popScene()
		BackButtonManager:pop("TopBarNew." .. T("system_012_title"))
	end, nil, nil, "infoachi")
	SoundEngine:play("event:/ui/main_hud/btn_achieve")
	SoundEngine:playBGM("event:/bgm/default")
	UIAction:Add(SEQ(SLIDE_IN(400, 600)), arg_43_0.vars.wnd:getChildByName("BASE_LEFT"), "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(400, 1200)), arg_43_0.vars.wnd:getChildByName("BASE_CENTER"), "block")
	UIAction:Add(SEQ(SLIDE_IN(400, -600), DELAY(1), CALL(function()
		UIUtil:playUnlockCategoryEffect(FactionCategory.ScrollViewItems, FactionCategory.scrollview, arg_43_0.vars.wnd)
	end)), arg_43_0.vars.wnd:getChildByName("BASE_RIGHT"), "block")
	TutorialGuide:startGuide(UNLOCK_ID.ACHIEVEMENT)
	TutorialGuide:procGuide()
	ConditionContentsManager:updateConditionDispatch()
end

function AchievementBase.updateResetInfo(arg_46_0, arg_46_1)
	if not arg_46_1 then
		return 
	end
	
	Account:setFactionPoint(arg_46_1.point_info)
	
	for iter_46_0, iter_46_1 in pairs(arg_46_1.faction_groups) do
		Account:setFactionGroupInfo(arg_46_1.faction_id, iter_46_0, iter_46_1)
	end
	
	for iter_46_2, iter_46_3 in pairs(arg_46_1.conditions) do
		Account:updateConditions(iter_46_2, iter_46_3)
	end
end

function AchievementBase.checkFactionSkillData(arg_47_0)
	local var_47_0 = arg_47_0:getFactionID()
	local var_47_1 = Account:getFactionByID(var_47_0).exp or 0
	local var_47_2, var_47_3 = AchievementUtil:calcFactionLevel(var_47_0, var_47_1)
	local var_47_4 = var_47_2 - 1
	
	for iter_47_0 = 1, var_47_4 do
		local var_47_5 = DB("faction_level", string.format("%s_%02d", var_47_0, var_47_4), "account_skill")
		local var_47_6 = string.split(var_47_5, "_")
		local var_47_7 = var_47_6[1] .. "_" .. var_47_6[2]
		local var_47_8 = var_47_6[3]
		local var_47_9 = AccountSkill:getAccountSkills()
		
		if not var_47_9[var_47_7] then
			return true
		elseif var_47_9[var_47_7].level < tonumber(var_47_8) then
			return true
		end
	end
	
	return false
end

function AchievementBase.updateUI(arg_48_0)
	local var_48_0 = arg_48_0:getFactionID()
	local var_48_1 = 0
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.faction_list) do
		if iter_48_1.id ~= SICA_FACTION_ID then
			var_48_1 = var_48_1 + Account:getFactionExp(iter_48_1.id)
		end
	end
	
	local var_48_2 = arg_48_0.vars.wnd:getChildByName("txt_total_exp")
	
	var_48_2:setString(comma_value(var_48_1))
	
	local var_48_3 = arg_48_0.vars.wnd:getChildByName("icon_score")
	local var_48_4 = var_48_2:getContentSize().width
	local var_48_5 = var_48_2:getString()
	local var_48_6 = string.len(var_48_5)
	
	if not arg_48_0.vars.first_exp_txt_position_x and get_cocos_refid(var_48_3) then
		arg_48_0.vars.first_exp_txt_position_x = var_48_3:getPositionX()
	end
	
	var_48_3:setPositionX((arg_48_0.vars.first_exp_txt_position_x or 0) + (6 - var_48_6) * 2)
	arg_48_0:updateFactionUI()
end

function AchievementBase.isMaxSkills(arg_49_0)
	local var_49_0 = arg_49_0:getFactionID()
	local var_49_1
	
	for iter_49_0 = 1, 30 do
		local var_49_2, var_49_3 = DB("faction_level", string.format("%s_%02d", var_49_0, iter_49_0), {
			"id",
			"account_skill"
		})
		
		if not var_49_2 then
			break
		end
		
		if not var_49_3 then
			break
		end
		
		local var_49_4 = var_49_3
		local var_49_5 = string.split(var_49_3, "_")
		local var_49_6 = var_49_5[1] .. "_" .. var_49_5[2]
		local var_49_7 = var_49_5[3]
		local var_49_8 = AccountSkill:getAccountSkills()
		
		if not var_49_8[var_49_6] then
			return false
		elseif var_49_8[var_49_6].level < tonumber(var_49_7) then
			return false
		end
	end
	
	return true
end

function AchievementBase.onAfterUpdate(arg_50_0)
end

function AchievementBase.getAchieveDataByGroupID(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0:getAchieveDataListByFactionID(arg_51_1)
	
	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if iter_51_1.group_id == arg_51_2 then
			return iter_51_1
		end
	end
end

function AchievementBase.updateAchieveData(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0:getAchieveDataListByFactionID(arg_52_1)
	
	for iter_52_0, iter_52_1 in pairs(var_52_0) do
		if iter_52_1.group_id == arg_52_2 then
			var_52_0[iter_52_0] = arg_52_0:getAchievementDB(arg_52_1, arg_52_2)
		end
	end
end

function AchievementBase.getAchievementDB(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = Account:getFactionGroupInfo(arg_53_1, arg_53_2) or {}
	local var_53_1 = var_53_0.lv or 1
	local var_53_2 = string.format("%s_%02d", arg_53_2, var_53_1)
	local var_53_3, var_53_4, var_53_5, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12, var_53_13, var_53_14, var_53_15, var_53_16, var_53_17, var_53_18, var_53_19, var_53_20, var_53_21, var_53_22, var_53_23, var_53_24 = DB("achievement", var_53_2, {
		"name",
		"desc",
		"desc2",
		"icon",
		"condition",
		"value",
		"reward_id1",
		"reward_count1",
		"reward_id2",
		"reward_count2",
		"mail_id",
		"btn_move",
		"reset_time",
		"sort",
		"hide",
		"grade_rate1",
		"grade_rate2",
		"set_drop_rate_id1",
		"set_drop_rate_id2",
		"hold",
		"jpn_hide",
		"system_achievement"
	})
	
	if not var_53_3 then
		return 
	end
	
	local var_53_25 = Account:isJPN() and var_53_23 == "y"
	local var_53_26 = var_53_24 and not UnlockSystem:isUnlockSystem(var_53_24)
	
	if not var_53_17 and not var_53_25 and not var_53_26 then
		local var_53_27 = {
			faction_id = arg_53_1,
			group_id = arg_53_2,
			lv = var_53_1,
			id = var_53_2,
			name = var_53_3,
			desc = var_53_4,
			desc2 = var_53_5,
			icon = var_53_6,
			condition = var_53_7,
			value = var_53_8,
			reward_id1 = var_53_9,
			reward_count1 = var_53_10,
			reward_id2 = var_53_11,
			reward_count2 = var_53_12,
			mail_id = var_53_13,
			btn_move = var_53_14,
			reset_time = var_53_15,
			value_data = totable(var_53_8),
			grade_rate1 = var_53_18,
			grade_rate2 = var_53_19,
			drop_rate_id1 = var_53_20,
			drop_rate_id2 = var_53_21,
			sort = var_53_16,
			hold = var_53_22
		}
		
		if var_53_27.hold then
			local var_53_28 = math.max(1, (var_53_0.lv or 1) - 1)
			local var_53_29 = string.format("%s_%02d", var_53_27.group_id, var_53_28)
			local var_53_30, var_53_31, var_53_32, var_53_33, var_53_34 = DB("achievement", var_53_29, {
				"name",
				"desc",
				"desc2",
				"condition",
				"value"
			})
			
			var_53_27.name = var_53_30
			var_53_27.desc = var_53_31
			var_53_27.condition = var_53_33
			var_53_27.value_data = totable(var_53_34)
		end
		
		return var_53_27
	end
end

function AchievementBase.getAchieveDataListByFactionID(arg_54_0, arg_54_1)
	if not arg_54_0.vars then
		return 
	end
	
	if not arg_54_0.vars.achieve_data then
		arg_54_0.vars.achieve_data = {}
	end
	
	if not arg_54_0.vars.achieve_data[arg_54_1] then
		arg_54_0.vars.achieve_data[arg_54_1] = {}
		
		local var_54_0 = ConditionContentsManager:getAchievement()
		
		if not Account:getFactionGroupsByFactionID(arg_54_1) then
			local var_54_1 = {}
		end
		
		local var_54_2
		
		var_54_2 = arg_54_1 == POINT_FACTION_ID
		
		local var_54_3 = {}
		local var_54_4 = AchievementUtil:getAchieveRowMax()
		
		for iter_54_0 = 1, var_54_4 do
			local var_54_5 = iter_54_0
			
			if arg_54_1 == "sisters" then
				var_54_5 = iter_54_0 + 100
			end
			
			local var_54_6 = string.format("%s_%03d", arg_54_1, var_54_5)
			local var_54_7 = arg_54_0:getAchievementDB(arg_54_1, var_54_6)
			
			if var_54_7 then
				table.insert(var_54_3, var_54_7)
			end
		end
		
		arg_54_0.vars.achieve_data[arg_54_1] = var_54_3
	end
	
	return arg_54_0.vars.achieve_data[arg_54_1]
end

function AchievementBase.onUpdateUI(arg_55_0)
	if SceneManager:getCurrentSceneName() ~= "achievement" then
		return 
	end
	
	if not arg_55_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_55_0.vars.wnd) then
		return 
	end
	
	local var_55_0 = AchievementBase:getFactionID()
	local var_55_1 = AchievementBase:getDetailObj(var_55_0)
	
	if var_55_1 then
		var_55_1:onUpdateUI()
	end
	
	FactionCategory:updateItems()
end
