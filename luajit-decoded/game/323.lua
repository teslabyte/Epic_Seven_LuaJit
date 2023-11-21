MoonlightDestinyQuest = MoonlightDestinyQuest or {}
MoonlightDestinyQuest.vars = {}

function HANDLER.destiny_moonlight_quest(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_quest" then
		MoonlightDestinyQuest:onQuestButton(arg_1_0.index)
		
		return 
	end
	
	if arg_1_1 == "btn_lock_big" then
		MoonlightDestinyQuest:onFinalLockButton()
		
		return 
	end
	
	if arg_1_1 == "btn_reset" then
		MoonlightDestinyRecall:open()
		
		return 
	end
end

function MoonlightDestinyQuest.getSceneState(arg_2_0)
end

function MoonlightDestinyQuest.onLoad(arg_3_0)
end

function MoonlightDestinyQuest.onUnload(arg_4_0)
end

function MoonlightDestinyQuest.onPushBackButton(arg_5_0)
	arg_5_0:close()
	SceneManager:popScene()
	BackButtonManager:pop("TopBarNew." .. T("character_mc_title"))
end

function MoonlightDestinyQuest.close(arg_6_0)
	if not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_6_0.vars.wnd, "block")
	
	arg_6_0.vars = {}
end

function MoonlightDestinyQuest.open(arg_7_0, arg_7_1)
	arg_7_0.vars.opts = arg_7_1
	arg_7_0.vars.wnd = load_dlg("destiny_moonlight_quest", true, "wnd")
	
	SceneManager:getDefaultLayer():addChild(arg_7_0.vars.wnd)
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("btn_reset")
	
	if get_cocos_refid(var_7_0) then
		local var_7_1 = Account:getRelationMoonlightSeason()
		
		if var_7_1 and to_n(var_7_1.reset_count) >= to_n(AccountData.relation_moonlight_reset_info.reset_count_limit) then
			var_7_0:setOpacity(76.5)
		end
	end
	
	TopBarNew:create(T("character_mc_title"), arg_7_0.vars.wnd, function()
		arg_7_0:onPushBackButton()
	end)
	if_set_sprite(arg_7_0.vars.wnd, "n_bg", MoonlightDestiny:getBackgroundImagePath())
	
	local var_7_2 = MoonlightDestiny:getSelectCharacterCode()
	
	if not var_7_2 then
		return 
	end
	
	arg_7_0:setUnit(var_7_2)
	
	for iter_7_0 = 1, 4 do
		local var_7_3 = arg_7_0.vars.wnd:getChildByName("n_quest" .. iter_7_0):getChildByName("btn_quest")
		
		if get_cocos_refid(var_7_3) then
			var_7_3.index = iter_7_0
		end
	end
	
	arg_7_0:updateQuests()
	arg_7_0:updateFinalLock()
	TutorialGuide:ifStartGuide("tuto_destiny_moonlight2")
	ConditionContentsManager:moonlightDestinyQuestForceUpdateConditions()
end

function MoonlightDestinyQuest.onUpdateUI(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	arg_9_0:updateQuests()
end

function MoonlightDestinyQuest.changePortrait(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("n_portrait")
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = UIUtil:getPortraitAni(arg_10_1, {
		parent_pos_y = var_10_0:getPositionY() + 200
	})
	
	var_10_1.code = arg_10_1
	
	var_10_1:setAnchorPoint(0.5, 0)
	var_10_1:setLocalZOrder(1)
	var_10_1:setScale(1)
	var_10_0:addChild(var_10_1)
	
	arg_10_0.vars.portrait = var_10_1
	
	return arg_10_0.vars.portrait
end

function MoonlightDestinyQuest.setUnit(arg_11_0, arg_11_1)
	local var_11_0, var_11_1, var_11_2 = DB("character", arg_11_1, {
		"grade",
		"face_id",
		"type"
	})
	local var_11_3 = UNIT:create({
		z = 6,
		exp = 0,
		lv = 1,
		code = arg_11_1,
		g = var_11_0
	})
	
	UIUtil:setUnitAllInfo(arg_11_0.vars.wnd, var_11_3, {
		ignore_stat_diff = true,
		use_basic_star = true
	})
	arg_11_0:changePortrait(MoonlightDestiny:getRelationCharacterCode(arg_11_1))
end

function MoonlightDestinyQuest.updateQuests(arg_12_0)
	for iter_12_0 = 1, 4 do
		arg_12_0:updateQuest(iter_12_0)
	end
end

function MoonlightDestinyQuest.updateQuest(arg_13_0, arg_13_1)
	local var_13_0 = MoonlightDestiny:getCharacterAchievementByIndex(arg_13_1)
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = MoonlightDestiny:getQuestState(var_13_0)
	
	if not var_13_1 then
		return 
	end
	
	local var_13_2 = arg_13_0.vars.wnd:getChildByName("n_quest" .. arg_13_1)
	
	if not get_cocos_refid(var_13_2) then
		return 
	end
	
	local var_13_3 = arg_13_0.vars.wnd:getChildByName("n_complete" .. arg_13_1)
	
	if not get_cocos_refid(var_13_3) then
		return 
	end
	
	if_set_visible(var_13_2, nil, not var_13_1.is_unlock)
	if_set_visible(var_13_3, nil, var_13_1.is_unlock)
	
	if var_13_1.is_unlock then
		if_set_sprite(var_13_3, "icon_menu", "img/" .. var_13_0.icon .. ".png")
		if_set(var_13_3, "t_title", T(var_13_0.name))
		
		return 
	end
	
	if_set_sprite(var_13_2, "icon_menu", "img/" .. var_13_0.icon .. ".png")
	if_set(var_13_2, "t_title", T(var_13_0.name))
	
	local var_13_4 = var_13_1.is_complete and cc.c3b(107, 193, 27) or cc.c3b(255, 255, 255)
	
	if_set_text_color(var_13_2, "t_title", var_13_4)
	if_set_color(var_13_2, "icon_menu", var_13_4)
	if_set(var_13_2, "t_disc", T(var_13_0.desc))
	
	local var_13_5 = var_13_1.is_complete and cc.c3b(102, 102, 102) or cc.c3b(171, 135, 89)
	
	if_set_text_color(var_13_2, "t_disc", var_13_5)
	if_set_percent(var_13_2, "progress_bar", var_13_1.progress / var_13_1.total_count)
	if_set(var_13_2, "t_percent", comma_value(math.min(var_13_1.progress, var_13_1.total_count)) .. " / " .. comma_value(var_13_1.total_count))
	
	local var_13_6 = var_13_1.is_complete and cc.c3b(107, 193, 27) or cc.c3b(146, 109, 62)
	
	if_set_color(var_13_2, "progress_bar", var_13_6)
	if_set_visible(var_13_2, "talk_small", var_13_1.is_complete)
	if_set_visible(var_13_2, "icon_lock", not var_13_1.is_complete)
	
	if var_13_1.is_complete and not var_13_1.is_unlock and not get_cocos_refid(var_13_2:getChildByName("eff_moon_quest_clear")) then
		local var_13_7 = var_13_2:getChildByName("n_icon")
		
		if get_cocos_refid(var_13_7) then
			local var_13_8, var_13_9 = var_13_7:getPosition()
			
			EffectManager:Play({
				fn = "eff_moon_quest_clear.cfx",
				pivot_z = 99998,
				layer = var_13_2,
				x = var_13_8,
				y = var_13_9
			})
		end
	end
end

function MoonlightDestinyQuest.updateFinalLock(arg_14_0)
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("n_final_lock")
	
	if not get_cocos_refid(var_14_0) then
		return 
	end
	
	local var_14_1 = var_14_0:getChildByName("btn_lock_big")
	
	if not get_cocos_refid(var_14_1) then
		return 
	end
	
	local var_14_2 = MoonlightDestiny:isAllSeasonQuestUnlocked()
	
	if_set_visible(var_14_0, "talk_small_final", var_14_2)
	var_14_1:setTouchEnabled(var_14_2)
	
	if var_14_2 then
		local var_14_3 = var_14_0:getChildByName("img_deco")
		
		if get_cocos_refid(var_14_3) then
			local var_14_4, var_14_5 = var_14_3:getPosition()
			
			EffectManager:Play({
				fn = "eff_moon_all_clear.cfx",
				pivot_z = 99998,
				layer = var_14_0,
				x = var_14_4,
				y = var_14_5
			})
		end
	end
end

function MoonlightDestinyQuest.onQuestButton(arg_15_0, arg_15_1)
	local var_15_0 = MoonlightDestiny:getCharacterAchievementsList()
	
	if not var_15_0 then
		return 
	end
	
	local var_15_1 = var_15_0[arg_15_1]
	
	if not var_15_1 then
		return 
	end
	
	local var_15_2 = MoonlightDestiny:getQuestState(var_15_1)
	
	if var_15_2.is_complete and not var_15_2.is_unlock then
		query("relation_moonlight_achievement_complete", {
			season = MoonlightDestiny:getCurrentSeasonNumber(),
			achieve_id = var_15_1.id
		})
	end
end

function MoonlightDestinyQuest.effectUnlockQuest(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.wnd:getChildByName("n_complete" .. arg_16_1)
	
	if not get_cocos_refid(var_16_0) then
		return 
	end
	
	local var_16_1 = var_16_0:getChildByName("n_icon")
	
	if not get_cocos_refid(var_16_1) then
		return 
	end
	
	local var_16_2, var_16_3 = var_16_1:getPosition()
	
	EffectManager:Play({
		fn = "eff_moon_quest_unlock.cfx",
		pivot_z = 99998,
		layer = var_16_0,
		x = var_16_2,
		y = var_16_3
	})
	SoundEngine:play("event:/ui/ml_relation/mission_unlock")
end

function MoonlightDestinyQuest.onFinalLockButton(arg_17_0)
	if not MoonlightDestiny:isAllSeasonQuestUnlocked() then
		return 
	end
	
	if_set_visible(arg_17_0.vars.wnd, "btn_reset", false)
	query("relation_moonlight_complete", {
		season = MoonlightDestiny:getCurrentSeasonNumber()
	})
end

function MoonlightDestinyQuest.onComplete(arg_18_0)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_final_lock")
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	local var_18_1 = var_18_0:getChildByName("btn_lock_big")
	
	if not get_cocos_refid(var_18_1) then
		return 
	end
	
	local var_18_2 = var_18_0:getChildByName("img_deco")
	
	if not get_cocos_refid(var_18_2) then
		return 
	end
	
	local var_18_3 = var_18_0:getChildByName("eff_moon_all_clear")
	
	if get_cocos_refid(var_18_3) then
		var_18_3:removeFromParent()
		
		local var_18_4
	end
	
	local var_18_5, var_18_6 = var_18_2:getPosition()
	
	EffectManager:Play({
		fn = "eff_moon_all_unlock.cfx",
		pivot_z = 99998,
		layer = var_18_0,
		x = var_18_5,
		y = var_18_6
	})
end

function MoonlightDestinyQuest.openCompleteMsgBox(arg_19_0)
	local var_19_0 = T("character_mc_unlocked_contents")
	local var_19_1 = T("character_mc_all_unlock_desc")
	local var_19_2 = T("character_mc_all_unlock_desc2")
	
	Dialog:msgBox(var_19_1, {
		title = var_19_0,
		green = var_19_2,
		handler = function()
			query("relation_moonlight_complete", {
				season = MoonlightDestiny:getCurrentSeasonNumber()
			})
		end
	})
end

function MoonlightDestinyQuest.openAddCoinsMsgBox(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {
		{
			token = arg_21_1.code,
			count = arg_21_1.count
		}
	}
	
	Dialog:msgRewards(T("character_mc_mooncoin"), {
		rewards = var_21_0,
		handler = arg_21_2
	})
end
