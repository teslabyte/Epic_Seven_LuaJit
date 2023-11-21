EpisodeForce = EpisodeForce or {}
FORCE_GROUP = {
	CURRENT = "current",
	PAST = "past"
}
FORCE_CREDIT_GRADE_MAX = 4

function EpisodeForce.isUnlockForce(arg_1_0, arg_1_1)
	if not arg_1_1 then
		return false
	end
	
	local var_1_0, var_1_1, var_1_2, var_1_3 = DB("shop_chapter_force", arg_1_1, {
		"id",
		"group_stage_id",
		"past_group_stage_id",
		"mission_group"
	})
	
	if not var_1_0 then
		return false
	end
	
	return arg_1_0:isUnlockForceByData(var_1_1, var_1_2, var_1_3)
end

function EpisodeForce.isUnlockForceByData(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if not arg_2_1 then
		return false
	end
	
	if not arg_2_2 then
		return false
	end
	
	if not arg_2_3 then
		return false
	end
	
	local var_2_0 = string.split(arg_2_1, ";")
	local var_2_1 = string.split(arg_2_2, ";")
	local var_2_2 = {}
	
	table.add(var_2_2, var_2_0)
	table.add(var_2_2, var_2_1)
	
	local var_2_3 = false
	
	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		local var_2_4, var_2_5 = DB("shop_chapter_category", iter_2_1, {
			"id",
			"unlock_stage"
		})
		
		if var_2_4 and var_2_5 and Account:isMapCleared(var_2_5) then
			var_2_3 = true
			
			break
		end
	end
	
	return var_2_3, arg_2_2
end

function EpisodeForce.isAllReceivedQuest(arg_3_0, arg_3_1)
	local var_3_0 = true
	
	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		if Account:getChapterShopQuest(iter_3_1.id).state < CHAPTER_SHOP_QUEST.REWARDED then
			var_3_0 = false
			
			break
		end
	end
	
	return var_3_0
end

function EpisodeForce.isIncludeForce(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_2 then
		return false
	end
	
	if not arg_4_3 then
		return false
	end
	
	local var_4_0 = string.split(arg_4_2, ";")
	local var_4_1 = string.split(arg_4_3, ";")
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		if iter_4_1 == arg_4_1 then
			return true, FORCE_GROUP.CURRENT
		end
	end
	
	for iter_4_2, iter_4_3 in pairs(var_4_1) do
		if iter_4_3 == arg_4_1 then
			return true, FORCE_GROUP.PAST
		end
	end
	
	return false
end

function EpisodeForce.isNoti(arg_5_0, arg_5_1, arg_5_2)
	if not Account:isStartChapterShopQuest(arg_5_1) and EpisodeForce:isUnlockForce(arg_5_1) then
		return true
	end
	
	if Account:isClearedChapterShopQuest(arg_5_1) then
		return false
	end
	
	if arg_5_0:isQuestNoti(arg_5_1, arg_5_2) then
		return true
	end
	
	local var_5_0 = EpisodeForce:getQuestData(arg_5_1)
	
	if EpisodeForce:isAllReceivedQuest(var_5_0) then
		return true
	end
	
	return false
end

function EpisodeForce.isQuestNoti(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_2 == nil then
		arg_6_2 = arg_6_0:getForceDB(arg_6_1).mission_group
	end
	
	local var_6_0 = Account:getChapterShopQuests()
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		local var_6_1 = string.split(iter_6_0, "_")
		
		if var_6_1[1] and var_6_1[2] and var_6_1[1] .. "_" .. var_6_1[2] == arg_6_2 and iter_6_1.state == CHAPTER_SHOP_QUEST.CLEAR then
			return true
		end
	end
	
	return false
end

function EpisodeForce.getQuestData(arg_7_0, arg_7_1)
	local var_7_0 = {}
	local var_7_1, var_7_2, var_7_3, var_7_4 = DB("shop_chapter_force", arg_7_1, {
		"id",
		"group_stage_id",
		"past_group_stage_id",
		"mission_group"
	})
	
	if EpisodeForce:isUnlockForceByData(var_7_2, var_7_3, var_7_4) then
		local var_7_5 = EpisodeForce:isStartQuest(var_7_1)
	end
	
	for iter_7_0 = 1, 999 do
		local var_7_6 = string.format("%s_%02d", var_7_4, iter_7_0)
		local var_7_7 = DBT("shop_chapter_quest", var_7_6, {
			"id",
			"category",
			"force_id",
			"reward_force_credit",
			"category_name",
			"mission_name",
			"mission_icon_1",
			"mission_icon_2",
			"icon",
			"mission_desc",
			"sort",
			"give_code",
			"give_count",
			"enter_stage",
			"reward_id1",
			"reward_count1",
			"condition",
			"value",
			"btn_move",
			"sort"
		})
		
		if var_7_7 == nil or var_7_7.id == nil then
			break
		end
		
		var_7_7.is_open = var_7_7.cond ~= nil and var_7_7.value ~= nil
		
		table.insert(var_7_0, var_7_7)
	end
	
	return var_7_0
end

function EpisodeForce.getReceivedQuestScore(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or arg_8_0:getQuestData(arg_8_1)
	
	local var_8_0 = 0
	
	for iter_8_0, iter_8_1 in pairs(arg_8_2) do
		if Account:getChapterShopQuest(iter_8_1.id).state == CHAPTER_SHOP_QUEST.REWARDED and iter_8_1.reward_force_credit then
			var_8_0 = var_8_0 + iter_8_1.reward_force_credit
		end
	end
	
	return var_8_0
end

function EpisodeForce.setSlotUI(arg_9_0, arg_9_1, arg_9_2)
	if not get_cocos_refid(arg_9_1) then
		return 
	end
	
	local var_9_0 = arg_9_0:getForceGrade(arg_9_2)
	local var_9_1 = DB("shop_chapter_force_credit_grade", "credit_" .. tostring(var_9_0), "grade_icon")
	
	for iter_9_0 = 1, 4 do
		if_set_visible(arg_9_1, "n_" .. tostring(iter_9_0) .. "_icon", iter_9_0 <= var_9_0)
		
		if iter_9_0 <= var_9_0 then
			if_set_sprite(arg_9_1, "n_" .. tostring(iter_9_0) .. "_icon", "img/" .. var_9_1 .. ".png")
		end
	end
end

function EpisodeForce.getNextGradeScore(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:getForceGrade(arg_10_1)
	local var_10_1 = "credit_" .. tostring(var_10_0 + 1)
	
	if var_10_0 == FORCE_CREDIT_GRADE_MAX then
		var_10_1 = "credit_" .. tostring(FORCE_CREDIT_GRADE_MAX)
	end
	
	return (DB("shop_chapter_force_credit_grade", var_10_1, "event_story_need_value"))
end

function EpisodeForce.getMaxGradeScore(arg_11_0)
	return (DB("shop_chapter_force_credit_grade", "credit_" .. tostring(FORCE_CREDIT_GRADE_MAX), "event_story_need_value"))
end

function EpisodeForce.isStartQuest(arg_12_0, arg_12_1)
	if not arg_12_1 then
		return false
	end
	
	local var_12_0 = Account:getShopChapters()[arg_12_1]
	
	if var_12_0 and (var_12_0.quest_state or -1) >= 0 then
		return true
	end
	
	return false
end

function EpisodeForce.getForceID(arg_13_0)
	local var_13_0 = WorldMapManager:getController()
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = var_13_0:getMapKey()
	
	if not var_13_1 then
		return 
	end
	
	return arg_13_0:getForceIDByChapterID(var_13_1)
end

function EpisodeForce.getForceIDByChapterID(arg_14_0, arg_14_1)
	local var_14_0 = DB("level_world_3_chapter", arg_14_1, "shop_cp_category")
	
	if not var_14_0 then
		return 
	end
	
	local var_14_1 = DBT("shop_chapter_category", var_14_0, {
		"id",
		"force_id"
	})
	
	if not var_14_1 then
		return 
	end
	
	return var_14_1.force_id
end

function EpisodeForce.getForceGrade(arg_15_0, arg_15_1)
	return Account:getShopChatperByID(arg_15_1).vi1 or 1
end

function EpisodeForce.getCreditDB(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:getForceGrade(arg_16_1)
	local var_16_1 = DBT("shop_chapter_force_credit_grade", "credit_" .. tostring(var_16_0), {
		"name",
		"name_color",
		"grade",
		"event_story_need_value"
	})
	
	if tonumber(var_16_1.grade) ~= tonumber(var_16_0) then
		Log.e("EpisodeForce.getCreditDB", "invalid_grade")
		
		return nil
	end
	
	return var_16_1
end

function EpisodeForce.getForceDB(arg_17_0, arg_17_1)
	return (DBT("shop_chapter_force", arg_17_1, {
		"id",
		"force_name",
		"force_flag",
		"force_emblem",
		"group_stage_id",
		"past_group_stage_id",
		"mission_group",
		"npc_credit_1_balloon",
		"npc_credit_2_balloon",
		"npc_credit_3_balloon",
		"npc_credit_4_balloon",
		"past_npc_credit_1_balloon",
		"past_npc_credit_2_balloon",
		"past_npc_credit_3_balloon",
		"past_npc_credit_4_balloon",
		"start_story",
		"event_story_2",
		"event_story_3",
		"event_story_4",
		"mission_clear_img",
		"mission_clear_desc",
		"reward_item_background",
		"reward_item_1",
		"reward_item_1_value",
		"reward_item_2",
		"reward_item_2_value",
		"clear_stamp_cfx"
	}))
end

function MsgHandler.start_force_unlock_quest(arg_18_0)
	if arg_18_0.info then
		Account:setShopChapter(arg_18_0.info)
	end
	
	BackPlayManager:forceStopPlay("chapter_shop_force")
	ConditionContentsManager:getChapterShopQuest():initConditionListner()
	WorldMapManager:getNavigator():updateLocalStoreNoti()
	ShopChapterForcePopup:updateUI()
end

ShopChapterForce = ShopChapterForce or {}

copy_functions(ShopChapter, ShopChapterForce)

function ShopChapterForce.loadData(arg_19_0)
	local var_19_0 = arg_19_0.vars.category_db.force_id
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = EpisodeForce:getForceDB(var_19_0)
	
	arg_19_0.vars.force_db = var_19_1
	
	local var_19_2 = EpisodeForce:isUnlockForce(arg_19_0.vars.force_db.id)
	
	arg_19_0.vars.is_unlock_force = var_19_2
	
	arg_19_0:updateCreditDB()
end

function ShopChapterForce.updateCreditDB(arg_20_0)
	local var_20_0 = arg_20_0.vars.category_db.force_id
	
	if not var_20_0 then
		Log.e("ShopChapterForce.updateCreditDB", "force_id")
		
		return 
	end
	
	local var_20_1 = EpisodeForce:getCreditDB(var_20_0)
	
	arg_20_0.vars.credit_db = var_20_1
end

function ShopChapterForce.initUI(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.vars.category_db
	local var_21_1 = WorldMapManager:getWorldMapUI():getWnd():getChildByName("n_force")
	local var_21_2 = true
	
	if_set_visible(arg_21_1, "n_shop_items", var_21_2)
	if_set_visible(arg_21_1, "n_chapter_shop_quest", false)
	if_set_visible(arg_21_1, "n_quest_info", not var_21_2)
	
	if not var_21_2 then
		arg_21_0:setLockUI()
	end
	
	if var_21_2 then
		arg_21_0:createScrollViewItems(arg_21_0.vars.list)
		arg_21_0:updateTimeLimitedItems(os.time())
		arg_21_0:jumpToPercent(0)
	end
	
	local var_21_3 = EpisodeForce:isStartQuest(var_21_0.force_id)
	
	if arg_21_0.vars.is_unlock_force and not var_21_3 then
		arg_21_0:showQuestStoryPopup()
	end
	
	if not arg_21_2 then
		local var_21_4 = var_21_1:getChildByName("n_flag")
		local var_21_5 = false
		
		var_21_4:setVisible(true)
		
		for iter_21_0, iter_21_1 in pairs(var_21_4:getChildren()) do
			iter_21_1:setVisible(iter_21_1:getName() == arg_21_0.vars.force_db.id)
			
			if iter_21_1:getName() == arg_21_0.vars.force_db.id then
				local var_21_6 = iter_21_1:getChildByName("txt_force_name")
				
				UIUserData:call(var_21_6, "MULTI_SCALE(2, 50)")
				var_21_6:setString(T(arg_21_0.vars.force_db.force_name))
				
				if var_21_6:getStringNumLines() >= 2 then
					var_21_5 = true
				end
			end
		end
		
		local var_21_7 = var_21_1:getChildByName("n_emblem")
		
		var_21_7:setVisible(true)
		if_set_sprite(var_21_7, "emblem", "emblem/" .. arg_21_0.vars.force_db.force_emblem .. ".png")
		
		if var_21_5 then
			var_21_7:setPositionY(var_21_7:getPositionY() + 9)
		end
		
		arg_21_0:updateUI()
	end
end

function ShopChapterForce.updateUI(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	local var_22_0 = WorldMapManager:getWorldMapUI():getWnd():getChildByName("n_force")
	
	if_set(var_22_0, "txt_relation", T(arg_22_0.vars.credit_db.name))
	
	local var_22_1 = arg_22_0.vars.credit_db.name_color
	local var_22_2 = totable(var_22_1)
	
	if_set_color(var_22_0, "txt_relation", cc.c3b(var_22_2.r, var_22_2.g, var_22_2.b))
	
	local var_22_3 = var_22_0:getChildByName("n_level")
	
	EpisodeForce:setSlotUI(var_22_3, arg_22_0.vars.force_db.id)
	
	local var_22_4 = Account:getItemCount(arg_22_0.vars.category_db.material)
	
	if_set(arg_22_0.vars.wnd, "count_cp", T("mission_base_cpshop_cp_value", {
		value = var_22_4
	}))
	
	local var_22_5 = false
	
	if EpisodeForce:isUnlockForce(arg_22_0.vars.force_db.id) then
		var_22_5 = EpisodeForce:isNoti(arg_22_0.vars.force_db.id)
	end
	
	local var_22_6 = var_22_0:getChildByName("btn_force")
	local var_22_7 = EpisodeForce:isUnlockForceByData(arg_22_0.vars.force_db.group_stage_id, arg_22_0.vars.force_db.past_group_stage_id, arg_22_0.vars.force_db.mission_group)
	
	if_set_opacity(var_22_6, nil, var_22_7 and 255 or 76.5)
	if_set_visible(var_22_6, "noti_icon", var_22_5)
end

function ShopChapterForce.ItemListRefresh(arg_23_0)
	ShopChapterForceDetail:itemSort()
	ShopChapterForceDetail:ItemListRefresh()
end

function ShopChapterForce.updatePopupBtnNoti(arg_24_0, arg_24_1)
	if not arg_24_0:isShow() then
		return false
	end
	
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("n_btn_change")
	
	if_set_visible(var_24_0, "icon_noti", arg_24_1)
end

function ShopChapterForce.isBtnNoti(arg_25_0)
	local var_25_0 = false
	local var_25_1 = WorldMapManager:getController():getWorldIDByMapKey()
	local var_25_2 = DB("level_world_1_world", tostring(var_25_1), "key_continent")
	local var_25_3 = {}
	local var_25_4 = WorldMapUtil:getContinentListByContinentKey(var_25_2)
	
	for iter_25_0, iter_25_1 in pairs(var_25_4) do
		local var_25_5 = EpisodeForce:getForceIDByChapterID(iter_25_1.key_normal)
		
		if var_25_5 and var_25_3[var_25_5] == nil then
			var_25_3[var_25_5] = true
			
			if EpisodeForce:isNoti(var_25_5) then
				var_25_0 = true
				
				break
			end
		end
	end
	
	return var_25_0
end

function ShopChapterForce.createPortrait(arg_26_0)
	local var_26_0 = WorldMapManager:getWorldMapUI():getWnd()
	local var_26_1 = WorldMapManager:getController()
	local var_26_2 = var_26_1:getMapKey()
	
	if not var_26_1 then
		return 
	end
	
	if arg_26_0.vars.category_db.npc then
		arg_26_0:addChapterPortrait("n_npc_force")
		
		local var_26_3 = arg_26_0.vars.category_db.unlock_stage
		
		if var_26_3 and not Account:isMapCleared(var_26_3) then
			arg_26_0:updateBalloon(".before", ".before")
		else
			arg_26_0:updateBalloon(".enter")
		end
	end
end

function ShopChapterForce.updateBalloon(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0.vars then
		return 
	end
	
	if not arg_27_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	local var_27_0 = WorldMapManager:getWorldMapUI():getWnd()
	
	if not get_cocos_refid(var_27_0) then
		return 
	end
	
	local var_27_1 = var_27_0:getChildByName("n_npc_force")
	
	if get_cocos_refid(var_27_1) and arg_27_0.vars.category_id then
		local var_27_2 = EpisodeForce:getForceGrade(arg_27_0.vars.force_db.id)
		local var_27_3, var_27_4 = EpisodeForce:isIncludeForce(arg_27_0.vars.category_db.id, arg_27_0.vars.force_db.group_stage_id, arg_27_0.vars.force_db.past_group_stage_id)
		local var_27_5
		
		if var_27_3 and var_27_4 == FORCE_GROUP.CURRENT then
			var_27_5 = arg_27_0.vars.force_db["npc_credit_" .. tostring(var_27_2) .. "_balloon"]
		elseif var_27_3 and var_27_4 == FORCE_GROUP.PAST then
			var_27_5 = arg_27_0.vars.force_db["past_npc_credit_" .. tostring(var_27_2) .. "_balloon"]
		end
		
		if not var_27_5 then
			Log.e("ShopChapterForce.updateBalloon", "no_balloon")
			
			return 
		end
		
		local var_27_6 = var_27_1:getChildByName("talk_bg")
		
		if get_cocos_refid(var_27_6) then
			var_27_6:setScale(0)
			UIUtil:playNPCSoundAndTextRandomly(var_27_5 .. arg_27_1, var_27_6, "disc", 300, var_27_5 .. (arg_27_2 or ".idle"), arg_27_0.vars.portrait)
		end
	end
end

function ShopChapterForce.isUnlockCredit(arg_28_0, arg_28_1)
	if not arg_28_0.vars.force_db then
		return false
	end
	
	if not arg_28_0.vars.force_db.id then
		return false
	end
	
	if not arg_28_1.credit_grade then
		return true
	end
	
	local var_28_0 = DB("shop_chapter_force_credit_grade", arg_28_1.credit_grade, "grade")
	
	if var_28_0 == nil then
		return false
	end
	
	local var_28_1 = EpisodeForce:getForceGrade(arg_28_0.vars.force_db.id)
	
	if arg_28_1.credit_grade and var_28_0 <= var_28_1 then
		return true
	end
	
	return false
end

function ShopChapterForce.showQuestStoryPopup(arg_29_0)
	if not arg_29_0:isShow() then
		return 
	end
	
	local var_29_0 = SceneManager:getRunningPopupScene()
	local var_29_1 = Dialog:open("wnd/mapshop_unlock_popup", arg_29_0, {
		back_func = function()
			arg_29_0:close()
			arg_29_0:playStoryQuest()
		end
	})
	
	arg_29_0.vars.unlock_popup_wnd = var_29_1
	
	local var_29_2 = var_29_1:getChildByName("n_eff")
	
	if get_cocos_refid(var_29_2) then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_29_2
		}, var_29_1, "block")
	end
	
	var_29_0:addChild(var_29_1)
	if_set(var_29_1, "txt_title", T("force_mission_popup_title"))
	if_set(var_29_1, "txt_disc", T("force_mission_popup_desc"))
	if_set(var_29_1, "label", T("close_text"))
	
	local var_29_3 = var_29_1:getChildByName("btn_ok")
	
	var_29_3:setVisible(true)
	
	var_29_3.parent = arg_29_0
end

function ShopChapterForce.playStoryQuest(arg_31_0)
	if not arg_31_0.vars then
		return 
	end
	
	if not arg_31_0.vars.force_db then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.force_db.start_story
	
	if not var_31_0 then
		return 
	end
	
	start_new_story(nil, var_31_0, {
		force = true,
		on_finish = function()
			query("start_force_unlock_quest", {
				force_id = arg_31_0.vars.force_db.id
			})
		end
	})
end

function ShopChapterForce.giveItem(arg_33_0, arg_33_1)
	if not arg_33_1 or not arg_33_1.give_code or not arg_33_1.give_code then
		return Log.e("destiny", "giveItem.null")
	end
	
	if Account:getPropertyCount(arg_33_1.give_code) < arg_33_1.give_count then
		balloon_message_with_sound("lack_give_currencies_count")
		
		return 
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("chaptershop.give", {
		give = arg_33_1.contents_id
	})
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_33_0 = ConditionContentsManager:getUpdateConditions()
	
	ConditionContentsManager:resetAllAdd()
	
	if var_33_0 then
		query("give_shop_chapter_quest", {
			contents_id = arg_33_1.contents_id,
			update_condition_groups = json.encode(var_33_0)
		})
	end
	
	Dialog:close("destiny_present")
end

function ShopChapterForce.onBtnGo(arg_34_0, arg_34_1)
	if arg_34_1.state >= 2 then
	elseif arg_34_1.state == 1 then
		query("get_reward_force_quest", {
			contents_id = arg_34_1.contents_id,
			force_id = arg_34_1.force_id
		})
	elseif arg_34_1.state == 0 then
		if arg_34_1.give_code then
			arg_34_0:showPresentWnd(nil, arg_34_1.contents_id, arg_34_1.give_code, arg_34_1.give_count)
		elseif arg_34_1.enter_stage then
			arg_34_0:enterBattle(arg_34_1)
		elseif arg_34_1.btn_move then
			Dialog:close("force_trust_achieve_p")
			
			local var_34_0 = WorldMapManager:getNavigator()
			
			if var_34_0 and var_34_0.isOpen then
				var_34_0:backNavi()
			end
			
			movetoPath(arg_34_1.btn_move)
		end
	end
end

function HANDLER.force_trust_achieve_p(arg_35_0, arg_35_1)
	if arg_35_1 == "btn_close" then
		Dialog:close("force_trust_achieve_p")
	elseif arg_35_1 == "btn_cshop_go" then
		ShopChapterForce:onBtnGo(arg_35_0)
	elseif string.starts(arg_35_1, "btn_progress") then
		local var_35_0 = string.split(arg_35_1, "btn_progress")
		
		ShopChapterForceDetail:onPlayCreditStory(var_35_0[2])
	elseif arg_35_1 == "btn_get" then
		ShopChapterForceDetail:queryForceReward()
	end
end

function MsgHandler.get_reward_force_quest(arg_36_0)
	if arg_36_0.quest_doc and arg_36_0.contents_id then
		Account:setChapterShopQuest(arg_36_0.contents_id, arg_36_0.quest_doc)
	end
	
	local var_36_0 = {
		desc = T("quest_shop_chapter_reward_desc")
	}
	
	if arg_36_0.force_info then
		Account:setShopChapter(arg_36_0.force_info)
	end
	
	ConditionContentsManager:dispatch("sync.force_credit")
	Account:addReward(arg_36_0.rewards, {
		play_reward_data = var_36_0,
		handler = function()
			if arg_36_0.force_up then
				ShopChapterForceDetail:onPlayCreditStory(arg_36_0.force_up)
				ShopChapterForce:updateScrollViewItems()
			end
		end
	})
	
	if arg_36_0.force_up then
		ShopChapterForce:updateCreditDB()
		ShopChapterForceDetail:updateCreditDB()
	end
	
	ShopChapterForceDetail:itemSort()
	ShopChapterForceDetail:ItemListRefresh()
	ShopChapterForceDetail:updateUI()
	WorldMapManager:getNavigator():updateLocalStoreNoti()
	ShopChapterForce:updateUI()
end

function MsgHandler.get_chapter_shop_force_reward(arg_38_0)
	if arg_38_0.force_info then
		Account:setShopChapter(arg_38_0.force_info)
	end
	
	local var_38_0 = {
		desc = T("max_credit_reward_popup_desc")
	}
	
	var_38_0.delay = 700
	
	ShopChapterForceDetail:onPlayStampAction()
	Account:addReward(arg_38_0.rewards, {
		play_reward_data = var_38_0,
		handler = function()
			ShopChapterForceDetail:updateUI({
				no_eff = true
			})
			WorldMapManager:getNavigator():updateLocalStoreNoti()
			ShopChapterForce:updateUI()
		end
	})
end

ShopChapterForceDetail = ShopChapterForceDetail or {}

function ShopChapterForceDetail.show(arg_40_0, arg_40_1)
	local var_40_0 = EpisodeForce:getForceID()
	
	if not EpisodeForce:isUnlockForce(var_40_0) then
		balloon_message_with_sound("credit_unlock_error_msg")
		
		return 
	end
	
	TutorialGuide:ifStartGuide("ep3_force")
	
	arg_40_0.vars = {}
	arg_40_1 = arg_40_1 or SceneManager:getRunningPopupScene()
	arg_40_0.vars.wnd = Dialog:open("wnd/force_trust_achieve_p", arg_40_0)
	arg_40_0.vars.force_id = var_40_0
	
	if not arg_40_0.vars.force_id then
		Log.e("ShopChapterForceDetail", "no_force_id")
	end
	
	arg_40_0.vars.force_db = EpisodeForce:getForceDB(arg_40_0.vars.force_id)
	
	arg_40_0:updateCreditDB()
	
	arg_40_0.vars.data = EpisodeForce:getQuestData(arg_40_0.vars.force_db.id)
	
	arg_40_1:addChild(arg_40_0.vars.wnd)
	arg_40_0:initUI()
	arg_40_0:createListView()
end

function ShopChapterForceDetail.initUI(arg_41_0)
	if_set_sprite(arg_41_0.vars.wnd, "n_flag", "img/" .. arg_41_0.vars.force_db.force_flag .. ".png")
	
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_force")
	
	for iter_41_0, iter_41_1 in pairs(var_41_0:getChildren()) do
		iter_41_1:setVisible(iter_41_1:getName() == "txt_" .. arg_41_0.vars.force_db.id)
	end
	
	local var_41_1 = false
	local var_41_2 = var_41_0:getChildByName("txt_" .. arg_41_0.vars.force_db.id)
	
	if get_cocos_refid(var_41_2) then
		UIUserData:call(var_41_2, "SINGLE_WSCALE(310)")
		var_41_2:setString(T(arg_41_0.vars.force_db.force_name))
		
		if var_41_2:getStringNumLines() >= 2 then
			var_41_1 = true
		end
	end
	
	local var_41_3 = arg_41_0.vars.wnd:getChildByName("n_emblem")
	
	if_set_sprite(var_41_3, "emblem", "emblem/" .. arg_41_0.vars.force_db.force_emblem .. ".png")
	
	if var_41_1 then
		var_41_3:setPositionY(var_41_3:getPositionY() + 8)
	end
	
	arg_41_0:updateUI()
end

function ShopChapterForceDetail.itemSort(arg_42_0)
	if not arg_42_0.vars or not arg_42_0.vars.data then
		return 
	end
	
	local var_42_0 = {
		[CHAPTER_SHOP_QUEST.CLEAR] = 2,
		[CHAPTER_SHOP_QUEST.ACTIVE] = 1,
		[CHAPTER_SHOP_QUEST.REWARDED] = 0
	}
	
	table.sort(arg_42_0.vars.data, function(arg_43_0, arg_43_1)
		local var_43_0 = Account:getChapterShopQuest(arg_43_0.id).state
		local var_43_1 = Account:getChapterShopQuest(arg_43_1.id).state
		
		if var_43_0 == var_43_1 then
			return (arg_43_0.sort or 1) < (arg_43_1.sort or 1)
		else
			return var_42_0[var_43_0] > var_42_0[var_43_1]
		end
	end)
end

function ShopChapterForceDetail.queryForceReward(arg_44_0)
	if Account:isClearedChapterShopQuest(arg_44_0.vars.force_db.id) then
		return 
	end
	
	query("get_chapter_shop_force_reward", {
		force_id = arg_44_0.vars.force_db.id
	})
end

function ShopChapterForceDetail.onPlayStampAction(arg_45_0)
	local var_45_0 = arg_45_0.vars.wnd:getChildByName("n_stamp_eff")
	
	var_45_0:setVisible(true)
	EffectManager:Play({
		node_name = "@UI_STAMP_EFFECT",
		pivot_x = 0,
		pivot_y = 0,
		pivot_z = 99998,
		fn = arg_45_0.vars.force_db.clear_stamp_cfx .. ".cfx",
		layer = var_45_0
	})
	EffectManager:Play({
		node_name = "@UI_STAMP_EFFECT",
		pivot_x = 0,
		pivot_y = 0,
		delay = 499,
		pivot_z = 99998,
		fn = arg_45_0.vars.force_db.clear_stamp_cfx .. "_loop.cfx",
		layer = var_45_0
	})
	set_high_fps_tick(6000)
end

function ShopChapterForceDetail.updateUI(arg_46_0, arg_46_1)
	if not arg_46_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_46_0.vars.wnd) then
		return 
	end
	
	arg_46_1 = arg_46_1 or {}
	
	local var_46_0 = arg_46_0.vars.wnd:getChildByName("n_relation")
	local var_46_1 = arg_46_0.vars.wnd:getChildByName("n_force_progress")
	
	if_set(var_46_0, "txt_relation", T(arg_46_0.vars.credit_db.name))
	
	local var_46_2 = arg_46_0.vars.credit_db.name_color
	local var_46_3 = totable(var_46_2)
	
	if_set_color(var_46_0, "txt_relation", cc.c3b(var_46_3.r, var_46_3.g, var_46_3.b))
	if_set_color(var_46_1, "progress_bar", cc.c3b(var_46_3.r, var_46_3.g, var_46_3.b))
	
	local var_46_4 = arg_46_0.vars.wnd:getChildByName("n_mission")
	local var_46_5 = EpisodeForce:getForceGrade(arg_46_0.vars.force_db.id)
	local var_46_6 = EpisodeForce:isAllReceivedQuest(arg_46_0.vars.data)
	local var_46_7 = arg_46_0.vars.wnd:getChildByName("n_fulfill")
	
	var_46_7:setVisible(var_46_6)
	
	local var_46_8 = var_46_4:getChildByName("n_reward_info")
	
	if_set_visible(var_46_4, nil, not var_46_6)
	if_set_visible(var_46_8, nil, not var_46_6)
	
	if var_46_6 then
		local var_46_9 = Account:isClearedChapterShopQuest(arg_46_0.vars.force_db.id)
		
		if_set_sprite(arg_46_0.vars.wnd, "n_img", "img/" .. arg_46_0.vars.force_db.mission_clear_img .. ".png")
		
		local var_46_10 = arg_46_0.vars.wnd:getChildByName("n_reward")
		
		var_46_10:setVisible(true)
		
		local var_46_11 = var_46_10:getChildByName("n_1")
		local var_46_12 = var_46_10:getChildByName("n_2")
		local var_46_13 = var_46_10:getChildByName("n_3")
		local var_46_14 = Account:getShopChapterInfo(arg_46_0.vars.force_db.id)
		
		if var_46_14 and (var_46_14.quest_state or 0) >= 1 then
			var_46_10:setOpacity(76.5)
		end
		
		local var_46_15 = arg_46_0.vars.wnd:getChildByName("btn_get")
		
		if_set_visible(var_46_15, nil, not var_46_9)
		UIUtil:getRewardIcon(nil, arg_46_0.vars.force_db.reward_item_background, {
			parent = var_46_11:getChildByName("n_bgpack")
		})
		UIUtil:getRewardIcon(arg_46_0.vars.force_db.reward_item_1_value, arg_46_0.vars.force_db.reward_item_1, {
			parent = var_46_12:getChildByName("n_item")
		})
		UIUtil:getRewardIcon(arg_46_0.vars.force_db.reward_item_2_value, arg_46_0.vars.force_db.reward_item_2, {
			parent = var_46_13:getChildByName("n_item")
		})
		if_set_visible(var_46_11, "icon_noti", not var_46_9)
		if_set_visible(var_46_12, "icon_noti", not var_46_9)
		if_set_visible(var_46_13, "icon_noti", not var_46_9)
		if_set(var_46_7, "txt_desc", T(arg_46_0.vars.force_db.mission_clear_desc))
		
		if var_46_9 then
			if_set_visible(arg_46_0.vars.wnd, "n_receive", true)
		end
		
		local var_46_16 = arg_46_0.vars.wnd:getChildByName("n_stamp_eff")
		
		var_46_16:setVisible(true)
		
		if arg_46_1.no_eff == nil and var_46_9 then
			EffectManager:Play({
				node_name = "@UI_STAMP_EFFECT",
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 99998,
				fn = arg_46_0.vars.force_db.clear_stamp_cfx .. "_loop.cfx",
				layer = var_46_16
			})
			set_high_fps_tick(6000)
		end
	else
		UIUtil:getRewardIcon(nil, arg_46_0.vars.force_db.reward_item_background, {
			parent = var_46_8:getChildByName("n_item1")
		})
		UIUtil:getRewardIcon(arg_46_0.vars.force_db.reward_item_1_value, arg_46_0.vars.force_db.reward_item_1, {
			parent = var_46_8:getChildByName("n_item2")
		})
		UIUtil:getRewardIcon(arg_46_0.vars.force_db.reward_item_2_value, arg_46_0.vars.force_db.reward_item_2, {
			parent = var_46_8:getChildByName("n_item3")
		})
	end
	
	local var_46_17 = EpisodeForce:getReceivedQuestScore(arg_46_0.vars.force_db.id, arg_46_0.vars.data)
	local var_46_18 = EpisodeForce:getNextGradeScore(arg_46_0.vars.force_db.id, arg_46_0.vars.data)
	
	if_set(var_46_1, "t_percent", tostring(var_46_17) .. "/" .. tostring(var_46_18))
	
	local var_46_19 = EpisodeForce:getMaxGradeScore()
	local var_46_20 = arg_46_0.vars.wnd:getChildByName("n_level")
	
	EpisodeForce:setSlotUI(var_46_20, arg_46_0.vars.force_db.id)
	if_set_percent(var_46_1, "progress_bar", var_46_17 / var_46_19)
	
	for iter_46_0 = 1, 4 do
		if_set_visible(var_46_1, "icon_check" .. tostring(iter_46_0), iter_46_0 <= var_46_5)
		
		if var_46_5 < iter_46_0 then
			if_set_opacity(var_46_1, "btn_progress" .. tostring(iter_46_0), 76.5)
		else
			if_set_opacity(var_46_1, "btn_progress" .. tostring(iter_46_0), 255)
		end
	end
end

function ShopChapterForceDetail.getQuestScore(arg_47_0)
end

function ShopChapterForceDetail.getQuestScoreMax(arg_48_0)
end

function ShopChapterForceDetail.updateCreditDB(arg_49_0)
	if not arg_49_0.vars then
		return 
	end
	
	if not arg_49_0.vars.force_id then
		return 
	end
	
	local var_49_0 = arg_49_0.vars.force_id
	
	if not var_49_0 then
		Log.e("ShopChapterForce.updateCreditDB", "force_id")
		
		return 
	end
	
	local var_49_1 = EpisodeForce:getCreditDB(var_49_0)
	
	arg_49_0.vars.credit_db = var_49_1
end

function ShopChapterForceDetail.createListView(arg_50_0)
	local var_50_0 = arg_50_0.vars.wnd:getChildByName("n_mission"):getChildByName("listview")
	
	arg_50_0.vars.listView = ItemListView_v2:bindControl(var_50_0)
	
	local var_50_1 = load_control("wnd/force_trust_quest_item.csb")
	
	if var_50_0.STRETCH_INFO then
		local var_50_2 = var_50_0:getContentSize()
		
		resetControlPosAndSize(var_50_1, var_50_2.width, var_50_0.STRETCH_INFO.width_prev)
	end
	
	local var_50_3 = {
		onUpdate = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			ShopChapterForceDetail:updateItem(arg_51_1, arg_51_3)
			
			return arg_51_3.id
		end
	}
	
	arg_50_0.vars.listView:setRenderer(var_50_1, var_50_3)
	arg_50_0.vars.listView:removeAllChildren()
	
	local var_50_4 = arg_50_0.vars.listView:getInnerContainerPosition()
	
	arg_50_0.vars.listView:setInnerContainerPosition({
		x = var_50_4.x,
		y = var_50_4.y - 27
	})
	arg_50_0:itemSort()
	arg_50_0.vars.listView:setDataSource(arg_50_0.vars.data)
	ConditionContentsManager:checkState(CONTENTS_TYPE.CHAPTER_SHOP_QUEST, {
		db_data = arg_50_0.vars.data
	})
end

function ShopChapterForceDetail.ItemListRefresh(arg_52_0)
	if not arg_52_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_52_0.vars.listView) then
		return 
	end
	
	arg_52_0.vars.listView:refresh()
end

function ShopChapterForceDetail.onPlayCreditStory(arg_53_0, arg_53_1)
	if not arg_53_1 then
	end
	
	if not arg_53_0.vars.force_db then
		return 
	end
	
	if EpisodeForce:getForceGrade(arg_53_0.vars.force_db.id) < tonumber(arg_53_1) then
		balloon_message_with_sound("credit_story_error1")
		
		return 
	end
	
	local var_53_0 = arg_53_0.vars.force_db["event_story_" .. tostring(arg_53_1)]
	
	if tonumber(arg_53_1) == 1 then
		var_53_0 = arg_53_0.vars.force_db.start_story
	end
	
	start_new_story(nil, var_53_0, {
		force = true
	})
end

function ShopChapterForceDetail.updateItem(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = Account:getChapterShopQuest(arg_54_2.id).state or 0
	local var_54_1 = arg_54_1:getChildByName("btn_cshop_go")
	local var_54_2 = 255
	
	if var_54_0 == 2 then
		var_54_2 = 102
	end
	
	local var_54_3 = {
		give = arg_54_2.give_code,
		battle = arg_54_2.enter_stage,
		active_text = T("condition_battle_text")
	}
	
	UIUtil:setColorRewardButtonState(var_54_0, arg_54_1, var_54_1, {
		give = arg_54_2.give_code,
		battle = arg_54_2.enter_stage
	})
	
	if arg_54_2.mission_icon_1 then
		local var_54_4 = 1.5
		local var_54_5 = DB("character", arg_54_2.mission_icon_1, "id")
		local var_54_6 = UIUtil:getRewardIcon(nil, arg_54_2.mission_icon_1, {
			no_popup = true,
			no_grade = true,
			parent = arg_54_1:getChildByName("mob_icon")
		})
		
		if_set_opacity(var_54_6, nil, var_54_2)
		if_set_visible(arg_54_1, "spr_icon", false)
	elseif arg_54_2.mission_icon_2 then
		arg_54_1:getChildByName("mob_icon"):removeAllChildren()
		if_set_visible(arg_54_1, "spr_icon", true)
		if_set_sprite(arg_54_1, "spr_icon", arg_54_2.mission_icon_2 .. ".png")
	end
	
	local var_54_7 = arg_54_2.condition_group_db
	local var_54_8 = ConditionContentsManager:getChapterShopQuest():getScore(arg_54_2.id)
	local var_54_9 = arg_54_2.condition ~= nil and arg_54_2.value ~= nil
	
	if_set_visible(arg_54_1, "n_lock", not var_54_9)
	if_set_visible(arg_54_1, "n_normal", var_54_9)
	if_set_visible(arg_54_1, "n_point", var_54_9)
	if_set_visible(arg_54_1, "n_right", var_54_9)
	
	if var_54_9 then
		if var_54_0 == 2 then
			if_set_opacity(arg_54_1, "n_normal", var_54_2)
			if_set_opacity(arg_54_1, "n_point", var_54_2)
			if_set_opacity(arg_54_1, "n_sort", var_54_2)
		end
		
		local var_54_10 = totable(arg_54_2.value).count
		local var_54_11 = arg_54_1:getChildByName("txt_title")
		
		var_54_11:setString(T(arg_54_2.category_name))
		UIUserData:call(var_54_11, "SINGLE_WSCALE(280)")
		if_set(arg_54_1, "txt_sub_title", T(arg_54_2.mission_name))
		set_scale_fit_width_node(arg_54_1:getChildByName("txt_sub_title"), arg_54_1:getChildByName("progress"))
		if_set_percent(arg_54_1, "progress", var_54_8 / var_54_10)
		if_set(arg_54_1, "txt_progress", comma_value(math.min(var_54_8, var_54_10)) .. " / " .. comma_value(var_54_10))
		
		if var_54_0 == 0 and not arg_54_2.btn_move and not arg_54_2.give_code and not arg_54_2.enter_stage then
			if_set_visible(arg_54_1, "btn_cshop_go", false)
		end
		
		if_set(arg_54_1, "txt_count", arg_54_2.reward_force_credit)
		
		var_54_1.parent = arg_54_0
		var_54_1.contents_id = arg_54_2.id
		var_54_1.state = var_54_0
		var_54_1.give_code = arg_54_2.give_code
		var_54_1.give_count = arg_54_2.give_count
		var_54_1.btn_move = arg_54_2.btn_move
		var_54_1.enter_stage = arg_54_2.enter_stage
		var_54_1.enter_condition_state = arg_54_2.enter_condition_state
		var_54_1.force_id = arg_54_0.vars.force_id
		
		var_54_1:getChildByName("noti"):setVisible(arg_54_2.give_code and var_54_0 == 0 and Account:getPropertyCount(arg_54_2.give_code) >= arg_54_2.give_count)
	else
		if_set_opacity(arg_54_1, "n_sort", 102)
	end
end
